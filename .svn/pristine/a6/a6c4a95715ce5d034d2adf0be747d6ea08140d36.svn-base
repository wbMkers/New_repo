/*____________________________________________________________________________________________________
			NEWGEN SOFTWARE TECHNOLOGIES LIMITED
______________________________________________________________________________________________________
	Group						: Genesis
	Product / Project			: iBPS
	Module						: Transaction Server
	File Name					: WFReturnRightsForObjType.sql (Postgres)
	Author						: Sajid Khan
	Date written (DD/MM/YYYY)	: 05 May 2016
	Description					: Stored procedure to Return Rights for given ObjectType
______________________________________________________________________________________________________
										CHANGE HISTORY
______________________________________________________________________________________________________
 Date		Change By		Change Description (Bug No. (If Any))

 
____________________________________________________________________________________________________*/

CREATE OR REPLACE FUNCTION WFReturnRightsForObjType(
	v_DBUserId				INTEGER, 		
	v_DBObjectType			VARCHAR,
	v_queryParam0			VARCHAR,  
	v_queryParam1			VARCHAR, 
	v_queryParam2			VARCHAR,
	v_TempTableName			VARCHAR,
	v_DBsortOrder			VARCHAR,  		
	v_DBbatchSize			INTEGER,
	v_DBlastValue			VARCHAR,
	v_DBFilterString		VARCHAR,
	v_DBObjectId			INTEGER,  
	v_ProjectId				INTEGER
) returns SETOF REFCURSOR AS $$
	
	DECLARE 
	
	RefCursor1				REFCURSOR;
	RefCursor2				REFCURSOR;
	v_DBStatus				INTEGER;
	v_queryStr				VARCHAR(2000);
	v_profileId				INTEGER;
	v_profileAssocQuery		VARCHAR(2000);
	v_FinalStatus			INTEGER;
	v_ErrorMessage			VARCHAR(100);
	v_sortStr				VARCHAR(6); 
	v_op					CHAR(1); 
	v_orderByStr			VARCHAR(250);
	v_quoteChar 			CHAR(1); 
	v_lastValueStr			VARCHAR(250);
	v_Suffix				VARCHAR(50); 
	v_filterStr				VARCHAR(255);
	v_CursorQuery			INTEGER;
	v_retval				INTEGER;
	v_ErrorCode				INTEGER;
	v_ObjectId				INTEGER;
	v_ObjectName			VARCHAR(64);
	v_RightString			VARCHAR(100);
	v_AssociationType		INTEGER;
	v_DataFound				VARCHAR(1);
	v_CursorForOthers		REFCURSOR;
	v_CursorObjTable		REFCURSOR;
	v_ProjectIdCondition	VARCHAR(250);
	v_objectIdStr			VARCHAR(250);
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
	
	IF(v_DBbatchSize > 0) THEN
	BEGIN
		v_Suffix := ' LIMIT ' || (v_DBbatchSize + 1);
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
	
	
	IF(v_DBlastValue IS NOT NULL) THEN
	BEGIN 
		v_lastValueStr := ' AND UPPER(ObjectName) ' || v_op || ' UPPER(' || v_quoteChar || v_DBlastValue || v_quoteChar || ')';
--		v_lastValueStr := ' AND ' || v_queryParam0 || ' ' || v_op || v_quoteChar || v_DBlastValue || v_quoteChar;
	END;
	END IF;
	
	IF(v_ProjectId > 0) THEN
	BEGIN
		v_ProjectIdCondition := ' AND projectid = ' || v_ProjectId ;
	END;
	END IF;
	
	IF(v_DBFilterString IS NOT NULL) THEN
	BEGIN
		v_filterStr := ' AND ' || v_DBFilterString;
	END;
	END IF;	
	
	v_orderByStr := 	' ORDER BY ObjectName ' || v_sortStr;
--	v_orderByStr := 	' ORDER BY ' || v_queryParam0 || ' ' || v_sortStr;

	Delete From TempObjectRightsTable;
	/* Fetch Objects associated with profile*/
	BEGIN
		v_queryStr := 'Select ProfileId from ProfileUserGroupView Where UserId = ' || v_DBUserId;			
		OPEN v_CursorForOthers FOR EXECUTE v_QueryStr;
		LOOP 
			BEGIN
				FETCH v_CursorForOthers INTO v_profileId;
				IF(NOT FOUND) THEN
					EXIT;
				END IF;
				IF(v_queryParam0 IS NOT NULL AND v_queryParam1 IS NOT NULL AND v_queryParam2 IS NOT NULL) THEN
				BEGIN
					v_profileAssocQuery := 'select A.Objectid ObjectId, ' || v_queryParam0 || ' ObjectName, D.RightString, 2 AssociationType  from WFUserObjAssocTable A,WFObjectListTable  B, ' || v_queryParam1 || ' C, WFProfileObjTypeTable D where D.userid = ' || v_profileId || ' and ProfileId = D.userid and D.associationtype = 2 and B.objecttype = '|| CHR(39) || v_DBObjectType || CHR(39)||' and A.ObjectTypeId = B.ObjectTypeId and A.ObjectTypeId = D.ObjectTypeId and (A.AssignedTillDATETIME  IS NULL OR A.AssignedTillDATETIME >=CURRENT_TIMESTAMP ) '|| COALESCE(v_queryParam2,'') || COALESCE(v_objectIdStr,'') ||COALESCE(v_ProjectIdCondition,'');
				END;
				ELSE
				BEGIN
					v_profileAssocQuery := 'select A.Objectid ObjectId, NULL, D.RightString, 2 AssociationType  from WFUserObjAssocTable A,WFObjectListTable  B,  WFProfileObjTypeTable D where D.userid = ' || v_profileId || ' and ProfileId = D.userid and D.associationtype = 2 and B.objecttype = '|| CHR(39) || v_DBObjectType || CHR(39)||' and A.ObjectTypeId = B.ObjectTypeId and A.ObjectTypeId = D.ObjectTypeId and (A.AssignedTillDATETIME  IS NULL OR A.AssignedTillDATETIME >=CURRENT_TIMESTAMP ) ' || COALESCE(v_objectIdStr,'') ||COALESCE(v_ProjectIdCondition,'');
				END;
				END IF;
				OPEN v_CursorObjTable FOR EXECUTE  v_profileAssocQuery;
				LOOP 
					FETCH v_CursorObjTable INTO v_ObjectId, v_ObjectName, v_RightString, v_AssociationType; 
					IF(NOT FOUND) THEN
						EXIT;
					END IF;				 
					INSERT INTO  TempObjectRightsTable (ObjectId, ObjectName, RightString, AssociationType) values (v_ObjectId, v_ObjectName, v_RightString, v_AssociationType);
					IF(NOT FOUND) THEN
						v_FinalStatus := 15;
						v_ErrorMessage := 'Error while insertion of objects associated with Profile';
						/*ROLLBACK TO SAVEPOINT TxnInsert; */
						EXIT; 
					END IF;
				END LOOP; 
				CLOSE v_CursorObjTable; 
					
				/*v_ErrorCode := SQLCODE;
				IF v_ErrorCode <> 0 THEN  
				BEGIN 
					v_FinalStatus := 15;
					v_ErrorMessage := 'Error while insertion of objects associated with Profile';
					ROLLBACK TO SAVEPOINT TxnInsert; 
					RAISE NO_DATA_FOUND;
					RETURN; 
				END; 
				END IF; */
			END; 
		END LOOP; 
		CLOSE v_CursorForOthers;
	END;

	/* Fetch Objects associated with Group*/	
	BEGIN
		v_queryStr := 'Select GroupIndex from WFGroupMemberView Where UserIndex = ' || v_DBUserId;			
		OPEN v_CursorForOthers FOR EXECUTE v_QueryStr;
		LOOP 
		BEGIN
			FETCH v_CursorForOthers INTO v_profileId;
			IF(NOT FOUND) THEN
				EXIT;
			END IF;
			IF(v_queryParam0 IS NOT NULL AND v_queryParam1 IS NOT NULL AND v_queryParam2 IS NOT NULL) THEN
				BEGIN
					v_profileAssocQuery := 'select A.objectid ObjectId, ' || COALESCE(v_queryParam0,'') || ' ObjectName, RightString, 1 AssociationType from 	WFUserObjAssocTable A,WFObjectListTable  B, ' || v_queryParam1 || ' C where B.objecttype = ''' || COALESCE(v_DBObjectType,'') || ''' and A.ObjectTypeId = B.ObjectTypeId and A.associationType = 1 and A.userid = ' || v_profileId || ' and ProfileId = 0 and (A.AssignedTillDATETIME  IS NULL OR A.AssignedTillDATETIME >=CURRENT_TIMESTAMP ) ' || COALESCE(v_queryParam2,'') || COALESCE(v_objectIdStr,'')||COALESCE(v_ProjectIdCondition,'');
				END;
				ELSE
				BEGIN
					v_profileAssocQuery := 'select A.objectid ObjectId, NULL, RightString, 1 AssociationType from 	WFUserObjAssocTable A,WFObjectListTable  B where B.objecttype = ''' || COALESCE(v_DBObjectType,'') || ''' and A.ObjectTypeId = B.ObjectTypeId and A.associationType = 1 and A.userid = ' || v_profileId || ' and ProfileId = 0 and (A.AssignedTillDATETIME  IS NULL OR A.AssignedTillDATETIME >=CURRENT_TIMESTAMP ) ' || COALESCE(v_objectIdStr,'')||COALESCE(v_ProjectIdCondition,'');
				END;
            END IF;
			OPEN v_CursorObjTable FOR EXECUTE v_profileAssocQuery;
			LOOP 
				FETCH v_CursorObjTable INTO v_ObjectId, v_ObjectName, v_RightString, v_AssociationType; 
				IF(NOT FOUND) THEN
					EXIT;
				END IF;	 				 
				INSERT INTO  TempObjectRightsTable (ObjectId, ObjectName, RightString, AssociationType) values (v_ObjectId, v_ObjectName, v_RightString, v_AssociationType);		
				IF(NOT FOUND) THEN
					v_FinalStatus := 15;
					v_ErrorMessage := 'Error while insertion of objects associated with Profile';
				
					EXIT; 
				END IF;
			END LOOP; 
			CLOSE v_CursorObjTable; 	
			
			/*v_ErrorCode := SQLCODE;
			IF v_ErrorCode <> 0 THEN  
			BEGIN 
				v_FinalStatus := 15;
				v_ErrorMessage := 'Error while insertion of objects associated with Group';
				ROLLBACK TO SAVEPOINT TxnInsert; 
				RAISE NO_DATA_FOUND;
				RETURN; 
			END; 
			END IF; */
		END; 
		END LOOP; 
		CLOSE v_CursorForOthers;	
	END;
	
	/* Fetch Objects associated with User*/	
	IF(v_queryParam0 IS NOT NULL AND v_queryParam1 IS NOT NULL AND v_queryParam2 IS NOT NULL) THEN
	BEGIN
		v_profileAssocQuery := 'select A.objectid ObjectId, ' || v_queryParam0 || ' ObjectName, RightString, 0 AssociationType from WFUserObjAssocTable A,WFObjectListTable  B, ' || v_queryParam1 || ' C where B.objecttype = '|| CHR(39) || v_DBObjectType ||CHR(39)||' and A.ObjectTypeId = B.ObjectTypeId and A.associationtype = 0 and A.userid = ' || v_DBUserId || ' and (A.AssignedTillDATETIME  IS NULL OR
		A.AssignedTillDATETIME >=CURRENT_TIMESTAMP) ' || COALESCE(v_queryParam2,'') || COALESCE(v_objectIdStr,'')||COALESCE(v_ProjectIdCondition,'');
	END;
	ELSE
	BEGIN
		v_profileAssocQuery := 'select A.objectid ObjectId, NULL, RightString, 0 AssociationType from WFUserObjAssocTable A,WFObjectListTable  B where B.objecttype = '|| CHR(39) || v_DBObjectType ||CHR(39)||' and A.ObjectTypeId = B.ObjectTypeId and A.associationtype = 0 and A.userid = ' || v_DBUserId || ' and (A.AssignedTillDATETIME  IS NULL OR
		A.AssignedTillDATETIME >=CURRENT_TIMESTAMP) ' || COALESCE(v_objectIdStr,'')||COALESCE(v_ProjectIdCondition,'');
	END;
	END IF;
	OPEN v_CursorObjTable FOR EXECUTE v_profileAssocQuery;
	LOOP 
		FETCH v_CursorObjTable INTO v_ObjectId, v_ObjectName, v_RightString, v_AssociationType; 
		IF(NOT FOUND) THEN
			EXIT;
		END IF;			 
		INSERT INTO  TempObjectRightsTable (ObjectId, ObjectName, RightString, AssociationType) values (v_ObjectId, v_ObjectName, v_RightString, v_AssociationType);		
		IF(NOT FOUND) THEN
			v_FinalStatus := 15;
			v_ErrorMessage := 'Error while insertion of objects associated with Profile';
			
			EXIT; 
		END IF;
	END LOOP; 
	CLOSE v_CursorObjTable; 	
/*	v_ErrorCode := SQLCODE;
	IF v_ErrorCode <> 0 THEN  
	BEGIN 
		v_FinalStatus := 15;
		v_ErrorMessage := 'Error while insertion of objects associated with user';
		ROLLBACK TO SAVEPOINT TxnInsert; 
		RAISE NO_DATA_FOUND;
		RETURN; 
	END; 
	END IF;*/
	v_queryStr := 'Select ObjectId, ObjectName, RightString, AssociationType from ' || v_TempTableName || ' Order By AssociationType Desc';
	Open RefCursor1 For Execute v_queryStr;
	Return next RefCursor1;	

	v_queryStr := 'SELECT a.ObjectId, a.ObjectName FROM (Select DISTINCT ObjectId, ObjectName from ' 
	|| v_TempTableName || ' WHERE 1 = 1 ' || v_filterStr || v_lastValueStr || v_orderByStr || ')a ' || v_Suffix;
	Open RefCursor2 For Execute v_queryStr;
	Return next RefCursor2;

END;
$$LANGUAGE plpgsql;