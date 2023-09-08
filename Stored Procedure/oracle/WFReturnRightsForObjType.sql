/*____________________________________________________________________________________________________
			NEWGEN SOFTWARE TECHNOLOGIES LIMITED
______________________________________________________________________________________________________
	Group				: Phoenix
	Product / Project	: OmniFlow 10
	Module				: Transaction Server
	File Name			: WFReturnRightsForObjType.sql (Oracle)
	Author				: Saurabh Kamal
	Date written (DD/MM/YYYY)	: 12/09/2012
	Description			: Stored procedure to Return Rights for given ObjectType
______________________________________________________________________________________________________
				CHANGE HISTORY
______________________________________________________________________________________________________
 Date		Change By		Change Description (Bug No. (If Any))
23/01/2013	Anwar Danish	In case of returning on error, raise some error to java code.
							Otherwise cstmt.getResultSet() result in error -> Cursor closed.
24/01/2013	Shweta Singhal	Change done for bug 37983								
24/01/2013	Shweta Singhal	Operation failed: Queue Management and Process Management
07/02/2013	Shweta Singhal	Bug 38253- All the rights data was not getting returned due to batching while filling data in temporary table
08/02/2013	Shweta Singhal	Bug 38280- Rights for individual object was not returned as ObjectId check was missing from the query
22/04/2018	Kumar Kimil		Bug 77269 - CheckMarx changes (High Severity)
10/05/2021	Sourabh Tantuway Bug 99245 - iBPS 4.0 + Oracle : Error coming in Report component of Omniapp
____________________________________________________________________________________________________*/

CREATE OR REPLACE PROCEDURE WFReturnRightsForObjType(
	temp_v_DBUserId				INT, 		
	temp_v_DBObjectType			NVARCHAR2,  
	temp_v_queryParam0			NVARCHAR2,  
	temp_v_queryParam1			NVARCHAR2, 
	temp_v_queryParam2			NVARCHAR2,
	temp_v_TempTableName			NVARCHAR2,
	v_DBsortOrder			NVARCHAR2,  		
	v_DBbatchSize			INT,
	temp_v_DBlastValue			NVARCHAR2,
	temp_v_DBFilterString		NVARCHAR2,
	v_DBObjectId			INT,  
	v_ProjectId				INT,
	RefCursor1				OUT ORACONSTPKG.DBLIST,
	RefCursor2				OUT ORACONSTPKG.DBLIST 
) 
AS
	TYPE DynamicCursor	IS REF CURSOR;
	v_DBStatus				INT;
	v_queryStr				VARCHAR2(2000);
	v_profileId				INT;
	v_profileAssocQuery		VARCHAR2(2000);
	v_FinalStatus			INT;
	v_ErrorMessage			NVARCHAR2(100);
	v_sortStr				NVARCHAR2(6); 
	v_op					CHAR(1); 
	v_orderByStr			NVARCHAR2(250);
	v_quoteChar 			CHAR(1); 
	v_lastValueStr			NVARCHAR2(250);
	v_Suffix				NVARCHAR2(50); 
	v_filterStr				NVARCHAR2(255);
	v_CursorQuery			INT;
	v_retval				INT;
	v_ErrorCode				INT;
	v_ObjectId				INT;
	v_ObjectName			NVARCHAR2(255);
	v_RightString			NVARCHAR2(100);
	v_AssociationType		INT;
	v_DataFound				NVARCHAR2(1);
	
	v_CursorObjTable		DynamicCursor;
	v_objectIdStr			NVARCHAR2(250);
	v_ProjectIdCondition	NVARCHAR2(250);
	v_DBlastValue			NVARCHAR2(2000);
	v_DBObjectType			NVARCHAR2(2000);
	v_queryParam0			NVARCHAR2(2000);
	v_queryParam1			NVARCHAR2(2000);
	v_queryParam2			NVARCHAR2(2000);
	v_TempTableName			NVARCHAR2(2000);
	v_DBFilterString		NVARCHAR2(2000);
	v_DBUserId				INT;
BEGIN

	v_FinalStatus := 0;
	v_ErrorCode := 0;
	v_ErrorMessage := '';
	v_quoteChar := CHR(39);
	v_lastValueStr := '';
	v_Suffix := '';
	v_filterStr := '';
	v_DBStatus := -1;
	v_DataFound := 'N';
	IF(temp_v_DBUserId is NOT NULL) THEN
		v_DBUserId:=CAST(REPLACE(temp_v_DBUserId,v_quoteChar,v_quoteChar||v_quoteChar) AS INTEGER);
	END IF;
	/*
	v_DBObjectType:=REPLACE(temp_v_DBObjectType,v_quoteChar,v_quoteChar||v_quoteChar);
	v_queryParam0:=REPLACE(temp_v_queryParam0,v_quoteChar,v_quoteChar||v_quoteChar);
	v_queryParam1:=REPLACE(temp_v_queryParam1,v_quoteChar,v_quoteChar||v_quoteChar);
	v_queryParam2:=REPLACE(temp_v_queryParam2,v_quoteChar,v_quoteChar||v_quoteChar);
	v_TempTableName:=REPLACE(temp_v_TempTableName,v_quoteChar,v_quoteChar||v_quoteChar);
	*/
	
	IF(temp_v_DBObjectType is NOT NULL) THEN
		SELECT sys.DBMS_ASSERT.noop(temp_v_DBObjectType) into v_DBObjectType FROM dual;
	END IF;	
	IF(temp_v_queryParam0 is NOT NULL) THEN
		SELECT sys.DBMS_ASSERT.noop(temp_v_queryParam0) into v_queryParam0 FROM dual;
	END IF;	
	IF(temp_v_queryParam1 is NOT NULL) THEN
		SELECT sys.DBMS_ASSERT.noop(temp_v_queryParam1) into v_queryParam1 FROM dual;
	END IF;
	IF(temp_v_queryParam2 is NOT NULL) THEN
		SELECT sys.DBMS_ASSERT.noop(temp_v_queryParam2) into v_queryParam2 FROM dual;
	END IF;
	IF(temp_v_TempTableName is NOT NULL) THEN
		SELECT sys.DBMS_ASSERT.noop(temp_v_TempTableName) into v_TempTableName FROM dual;
	END IF;
	
	IF(v_DBbatchSize > 0) THEN
	BEGIN
		v_Suffix := ' WHERE ROWNUM <= ' || (v_DBbatchSize + 1);
	END;
	END IF;
	
	IF(v_DBsortOrder = 'D') THEN
	BEGIN 		
		v_sortStr := ' DESC ';
		v_op := '<';
	END; 
	ELSE /* IF(@DBsortOrder = 'A') */  
	BEGIN 		
		v_sortStr := ' ASC ';  
		v_op := '>';  
	END;
	END IF;
	
	IF(v_DBObjectId > 0) THEN
	BEGIN 
		v_objectIdStr := ' AND ObjectId = ' || v_DBObjectId ;
		--v_lastValueStr := ' AND ObjectId = ' || v_DBObjectId ;
	END;
	ELSE	
		v_objectIdStr := '';
	END IF;
	
	
	IF(temp_v_DBlastValue IS NOT NULL) THEN
	BEGIN 
--		v_DBlastValue:=REPLACE(temp_v_DBlastValue,v_quoteChar,v_quoteChar||v_quoteChar);
		SELECT sys.DBMS_ASSERT.noop(temp_v_DBlastValue) into v_DBlastValue FROM dual;
		v_lastValueStr := ' AND UPPER(ObjectName) ' || v_op || ' UPPER(' || v_quoteChar || v_DBlastValue || v_quoteChar || ')';
--		v_lastValueStr := ' AND ' || v_queryParam0 || ' ' || v_op || v_quoteChar || v_DBlastValue || v_quoteChar;
	END;
	END IF;
	
	IF(v_ProjectId > 0) THEN
	BEGIN
		v_ProjectIdCondition := ' AND projectid = ' || v_ProjectId ;
	END;
	END IF;
	
	
	IF(temp_v_DBFilterString IS NOT NULL) THEN
	BEGIN
		IF(temp_v_DBFilterString is NOT NULL) THEN
			SELECT sys.DBMS_ASSERT.noop(temp_v_DBFilterString) into v_DBFilterString FROM dual;
		END IF;
		/*
		v_DBFilterString:=REPLACE(temp_v_DBFilterString,v_quoteChar,v_quoteChar||v_quoteChar);
		v_DBFilterString:=REPLACE(temp_v_DBFilterString,v_quoteChar||v_quoteChar,v_quoteChar);
		*/
		v_filterStr := ' AND ' || v_DBFilterString;
		
	END;
	END IF;	
	
	v_orderByStr := 	' ORDER BY UPPER(ObjectName) ' || v_sortStr;
--	v_orderByStr := 	' ORDER BY ' || v_queryParam0 || ' ' || v_sortStr;

	SAVEPOINT TxnInsert;
	Delete From GTempObjectRightsTable;
	-- Fetch Objects associated with profile
	BEGIN
		v_CursorQuery := DBMS_SQL.OPEN_CURSOR;
		v_queryStr := 'Select ProfileId from ProfileUserGroupView Where UserId = ' || v_DBUserId;			
		DBMS_SQL.PARSE(v_CursorQuery, TO_CHAR(v_queryStr), DBMS_SQL.NATIVE); 
		DBMS_SQL.DEFINE_COLUMN(v_CursorQuery, 1 , v_profileId); 

		v_retval := DBMS_SQL.EXECUTE(v_CursorQuery); 
		v_DBStatus := DBMS_SQL.FETCH_ROWS(v_CursorQuery); 	
		WHILE (v_DBStatus <> 0) LOOP 
		BEGIN
			DBMS_SQL.COLUMN_VALUE(v_CursorQuery, 1, v_profileId); 
			IF(v_queryParam0 IS NOT NULL AND v_queryParam1 IS NOT NULL AND v_queryParam2 IS NOT NULL) THEN
        v_profileAssocQuery := 'select A.Objectid ObjectId, ' || v_queryParam0 || ' ObjectName, D.RightString, 2 AssociationType  from WFUserObjAssocTable A,WFObjectListTable  B, ' || v_queryParam1 || ' C, WFProfileObjTypeTable D where D.userid = ' || v_profileId || ' and ProfileId = D.userid and D.associationtype = 2 and B.objecttype = ''' || v_DBObjectType || ''' and A.ObjectTypeId = B.ObjectTypeId and A.ObjectTypeId = D.ObjectTypeId and (A.AssignedTillDATETIME  IS NULL OR A.AssignedTillDATETIME >=SYSDATE ) '|| v_queryParam2 || v_objectIdStr ||v_ProjectIdCondition; 
      ELSE
				v_profileAssocQuery := 'select A.Objectid ObjectId, NULL, D.RightString, 2 AssociationType  from WFUserObjAssocTable A,WFObjectListTable  B, WFProfileObjTypeTable D where D.userid = ' || v_profileId || ' and ProfileId = D.userid and D.associationtype = 2 and B.objecttype = ''' || v_DBObjectType || ''' and A.ObjectTypeId = B.ObjectTypeId and A.ObjectTypeId = D.ObjectTypeId and (A.AssignedTillDATETIME  IS NULL OR A.AssignedTillDATETIME >=SYSDATE ) '|| v_objectIdStr ||v_ProjectIdCondition; 
      END IF;
			--			v_profileAssocQuery := 'SELECT ObjectId, ObjectName, RightString, AssociationType FROM (select D.objectid ObjectId, ' || v_queryParam0 || ' ObjectName, RightString, 2 AssociationType  from WFProfileObjTypeTable A,WFObjectListTable  B, ' || v_queryParam1 || ' C, WFUserObjAssocTable D where B.objecttype = ''' || v_DBObjectType || ''' and A.ObjectTypeId = B.ObjectTypeId and A.ObjectTypeId = D.ObjectTypeId and profileid = ' || v_profileId || ' AND ( D.assignedtilldatetime IS NULL OR D.assignedtilldatetime>=SYSDATE )'  || v_queryParam2 || v_objectIdStr || ')';
			
			--insert into righttest values (1001, v_profileAssocQuery);
--			v_profileAssocQuery := 'SELECT ObjectId, ObjectName, RightString, AssociationType FROM (select D.objectid ObjectId, ' || v_queryParam0 || ' ObjectName, RightString, 2 AssociationType  from WFProfileObjTypeTable A,WFObjectListTable  B, ' || v_queryParam1 || ' C, WFUserObjAssocTable D where B.objecttype = ''' || v_DBObjectType || ''' and A.ObjectTypeId = B.ObjectTypeId and A.ObjectTypeId = D.ObjectTypeId and profileid = ' || v_profileId || ' AND ( D.assignedtilldatetime IS NULL OR D.assignedtilldatetime>=SYSDATE )'  || v_queryParam2 || v_lastValueStr || v_orderByStr || ')' || v_Suffix;
			OPEN v_CursorObjTable FOR v_profileAssocQuery;
	
			LOOP 
				FETCH v_CursorObjTable INTO v_ObjectId, v_ObjectName, v_RightString, v_AssociationType; 
				EXIT WHEN v_CursorObjTable%NOTFOUND; 				 
				INSERT INTO  GTempObjectRightsTable (ObjectId, ObjectName, RightString, AssociationType) values (v_ObjectId, v_ObjectName, v_RightString, v_AssociationType);
			END LOOP; 
			CLOSE v_CursorObjTable; 	
			
			v_ErrorCode := SQLCODE;
			IF v_ErrorCode <> 0 THEN  
			BEGIN 
				v_FinalStatus := 15;
				v_ErrorMessage := 'Error while insertion of objects associated with Profile';
				ROLLBACK TO SAVEPOINT TxnInsert; 
				RAISE NO_DATA_FOUND;
				RETURN; 
			END; 
			END IF; 
			
			v_DBStatus := DBMS_SQL.fetch_rows(v_CursorQuery); 
		END; 
		END LOOP; 
		dbms_sql.close_cursor(v_CursorQuery);
		
	EXCEPTION  
		
		WHEN OTHERS THEN  
		BEGIN 
			IF (DBMS_SQL.IS_OPEN(v_CursorQuery)) THEN 
				DBMS_SQL.CLOSE_CURSOR(v_CursorQuery);  
			END IF; 
			RAISE NO_DATA_FOUND;
			RETURN;  
		END;	
	END;
		
	-- Fetch Objects associated with Group
	BEGIN
		v_CursorQuery := DBMS_SQL.OPEN_CURSOR;
		v_queryStr := 'Select GroupIndex from WFGroupMemberView Where UserIndex = ' || v_DBUserId;			
		DBMS_SQL.PARSE(v_CursorQuery, TO_CHAR(v_queryStr), DBMS_SQL.NATIVE); 
		DBMS_SQL.DEFINE_COLUMN(v_CursorQuery, 1 , v_profileId); 

		v_retval := DBMS_SQL.EXECUTE(v_CursorQuery); 

		v_DBStatus := DBMS_SQL.FETCH_ROWS(v_CursorQuery); 	
		WHILE (v_DBStatus <> 0) LOOP 
		BEGIN
			DBMS_SQL.COLUMN_VALUE(v_CursorQuery, 1, v_profileId); 
			IF(v_queryParam0 IS NOT NULL AND v_queryParam1 IS NOT NULL AND v_queryParam2 IS NOT NULL) THEN
				v_profileAssocQuery := 'select A.objectid ObjectId, ' || v_queryParam0 || ' ObjectName, RightString, 1 AssociationType from 	WFUserObjAssocTable A,WFObjectListTable  B, ' || v_queryParam1 || ' C where B.objecttype = ''' || v_DBObjectType || ''' and A.ObjectTypeId = B.ObjectTypeId and A.associationType = 1 and ProfileId = 0 and A.userid = ' || v_profileId || ' and (A.AssignedTillDATETIME  IS NULL OR A.AssignedTillDATETIME >=SYSDATE ) ' || v_queryParam2 || v_objectIdStr||v_ProjectIdCondition;  
			ELSE 
				v_profileAssocQuery := 'select A.objectid ObjectId, NULL, RightString, 1 AssociationType from 	WFUserObjAssocTable A,WFObjectListTable  B where B.objecttype = ''' || v_DBObjectType || ''' and A.ObjectTypeId = B.ObjectTypeId and A.associationType = 1 and ProfileId = 0 and A.userid = ' || v_profileId || ' and (A.AssignedTillDATETIME  IS NULL OR A.AssignedTillDATETIME >=SYSDATE ) ' || v_objectIdStr||v_ProjectIdCondition; 
			END IF;
--			v_profileAssocQuery := 'SELECT ObjectId, ObjectName, RightString, AssociationType FROM (select D.objectid ObjectId, ' || v_queryParam0 || ' ObjectName, RightString, 1 AssociationType from WFProfileObjTypeTable A,WFObjectListTable  B, ' || v_queryParam1 || ' C , WFUserObjAssocTable D where B.objecttype = ''' || v_DBObjectType || ''' and A.ObjectTypeId = B.ObjectTypeId and A.ObjectTypeId = D.ObjectTypeId and D.AssociationType = 1 and D.userid = ' || v_profileId || ' AND ( D.assignedtilldatetime IS NULL OR D.assignedtilldatetime>=SYSDATE )'|| v_queryParam2 || v_objectIdStr || ')';
			--insert into righttest values (1002, v_profileAssocQuery);
--			v_profileAssocQuery := 'SELECT ObjectId, ObjectName, RightString, AssociationType FROM (select D.objectid ObjectId, ' || v_queryParam0 || ' ObjectName, RightString, 1 AssociationType from WFProfileObjTypeTable A,WFObjectListTable  B, ' || v_queryParam1 || ' C , WFUserObjAssocTable D where B.objecttype = ''' || v_DBObjectType || ''' and A.ObjectTypeId = B.ObjectTypeId and A.ObjectTypeId = D.ObjectTypeId and D.AssociationType = 1 and D.userid = ' || v_profileId || ' AND ( D.assignedtilldatetime IS NULL OR D.assignedtilldatetime>=SYSDATE )'|| v_queryParam2 || v_lastValueStr || v_orderByStr || ')' || v_Suffix;
			OPEN v_CursorObjTable FOR v_profileAssocQuery;

			LOOP 
				FETCH v_CursorObjTable INTO v_ObjectId, v_ObjectName, v_RightString, v_AssociationType; 
				EXIT WHEN v_CursorObjTable%NOTFOUND; 				 
				INSERT INTO  GTempObjectRightsTable (ObjectId, ObjectName, RightString, AssociationType) values (v_ObjectId, v_ObjectName, v_RightString, v_AssociationType);				
			END LOOP; 
			CLOSE v_CursorObjTable; 	
			
			v_ErrorCode := SQLCODE;
			IF v_ErrorCode <> 0 THEN  
			BEGIN 
				v_FinalStatus := 15;
				v_ErrorMessage := 'Error while insertion of objects associated with Group';
				ROLLBACK TO SAVEPOINT TxnInsert; 
				RAISE NO_DATA_FOUND;
				RETURN; 
			END; 
			END IF; 
			
			v_DBStatus := DBMS_SQL.fetch_rows(v_CursorQuery); 
		END; 
		END LOOP; 
		dbms_sql.close_cursor(v_CursorQuery);
	EXCEPTION  
		WHEN OTHERS THEN  
		BEGIN 
			IF (DBMS_SQL.IS_OPEN(v_CursorQuery)) THEN 
				DBMS_SQL.CLOSE_CURSOR(v_CursorQuery);  
			END IF; 
			RAISE NO_DATA_FOUND;
			RETURN;  
		END;	
	END;
	
	-- Fetch Objects associated with User
	IF(v_queryParam0 IS NOT NULL AND v_queryParam1 IS NOT NULL AND v_queryParam2 IS NOT NULL) THEN
    v_profileAssocQuery := 'select A.objectid ObjectId, ' || v_queryParam0 || ' ObjectName, RightString, 0 AssociationType from WFUserObjAssocTable A,WFObjectListTable  B, ' || v_queryParam1 || ' C where B.objecttype = ''' || v_DBObjectType || ''' and A.ObjectTypeId = B.ObjectTypeId and A.associationtype = 0 and A.userid = ' || v_DBUserId || ' and (A.AssignedTillDATETIME  IS NULL OR 
		A.AssignedTillDATETIME >=SYSDATE) ' || v_queryParam2 || v_objectIdStr||v_ProjectIdCondition; 

	ELSE  
		v_profileAssocQuery := 'select A.objectid ObjectId, NULL, RightString, 0 AssociationType from WFUserObjAssocTable A,WFObjectListTable  B where B.objecttype = ''' || v_DBObjectType || ''' and A.ObjectTypeId = B.ObjectTypeId and A.associationtype = 0 and A.userid = ' || v_DBUserId || ' and (A.AssignedTillDATETIME  IS NULL OR 
		A.AssignedTillDATETIME >=SYSDATE) ' || v_objectIdStr||v_ProjectIdCondition; 
	END IF; 
	
--	v_profileAssocQuery := 'SELECT ObjectId, ObjectName, RightString, AssociationType FROM (select D.objectid ObjectId, ' || v_queryParam0 || ' ObjectName, RightString, 0 AssociationType from WFProfileObjTypeTable A,WFObjectListTable  B, ' || v_queryParam1 || ' C , WFUserObjAssocTable D where B.objecttype = ''' || v_DBObjectType || ''' and A.ObjectTypeId = B.ObjectTypeId and A.ObjectTypeId = D.ObjectTypeId and D.AssociationType = 0 and D.userid = ' || v_DBUserId || ' AND ( D.assignedtilldatetime IS NULL OR D.assignedtilldatetime>=SYSDATE )'|| v_queryParam2 || v_objectIdStr || ')';
	--insert into righttest values (1003, v_profileAssocQuery);
--	v_profileAssocQuery := 'SELECT ObjectId, ObjectName, RightString, AssociationType FROM (select D.objectid ObjectId, ' || v_queryParam0 || ' ObjectName, RightString, 0 AssociationType from WFProfileObjTypeTable A,WFObjectListTable  B, ' || v_queryParam1 || ' C , WFUserObjAssocTable D where B.objecttype = ''' || v_DBObjectType || ''' and A.ObjectTypeId = B.ObjectTypeId and A.ObjectTypeId = D.ObjectTypeId and D.AssociationType = 0 and D.userid = ' || v_DBUserId || ' AND ( D.assignedtilldatetime IS NULL OR D.assignedtilldatetime>=SYSDATE )'|| v_queryParam2 || v_lastValueStr || v_orderByStr || ')' || v_Suffix;
	OPEN v_CursorObjTable FOR v_profileAssocQuery;

	LOOP 
		FETCH v_CursorObjTable INTO v_ObjectId, v_ObjectName, v_RightString, v_AssociationType; 
		EXIT WHEN v_CursorObjTable%NOTFOUND; 				 
		INSERT INTO  GTempObjectRightsTable (ObjectId, ObjectName, RightString, AssociationType) values (v_ObjectId, v_ObjectName, v_RightString, v_AssociationType);		
	END LOOP; 
	CLOSE v_CursorObjTable; 	
	
	v_ErrorCode := SQLCODE;
	IF v_ErrorCode <> 0 THEN  
	BEGIN 
		v_FinalStatus := 15;
		v_ErrorMessage := 'Error while insertion of objects associated with user';
		ROLLBACK TO SAVEPOINT TxnInsert; 
		RAISE NO_DATA_FOUND;
		RETURN; 
	END; 
	END IF;

	IF(v_FinalStatus = 0) THEN	
		COMMIT;
	END IF;
	
	v_queryStr := 'Select ObjectId, ObjectName, RightString, AssociationType from ' || v_TempTableName || ' Order By AssociationType Desc';
	
	Open RefCursor1 For v_queryStr;
		
	v_queryStr := 'SELECT ObjectId, ObjectName FROM (Select DISTINCT ObjectId, ObjectName from ' 
	|| v_TempTableName || ' WHERE 1 = 1 ' || v_filterStr || v_lastValueStr || v_orderByStr || ')' || v_Suffix;
	Open RefCursor2 For v_queryStr;

EXCEPTION
	WHEN OTHERS THEN		
		CLOSE RefCursor1;
		CLOSE RefCursor2;
		
		RAISE;	
	
END;
