 CREATE  PROCEDURE WFUploadWorkItem(
	IN v_DBConnectId		INTEGER,
	IN v_DBHostname			VARCHAR(120),
	IN v_DBProcessDefId		INTEGER,
	IN v_InitiateFromActivityId	INTEGER,
	IN v_InitiateFromActivityName	VARGRAPHIC(30) ,
	IN v_ValidationReqd		VARCHAR(1000),
	IN v_DataDefinitionName		VARCHAR(256),
	IN v_DBDDIDataList1		VARGRAPHIC(8000),
	IN v_DBDDIDataList2		VARGRAPHIC(8000),
	IN v_DBDDIDataList3		VARGRAPHIC(8000),
	IN v_DBDDIDataList4		VARGRAPHIC(8000),
	IN v_DBDDIDataList5		VARGRAPHIC(8000),
	IN v_DBDDIDataList6		VARGRAPHIC(8000),
	IN v_DBDDIDataList7		VARGRAPHIC(8000),
	IN v_DBDDIDataList8		VARGRAPHIC(8000),
	IN v_DBDDIDataList9		VARGRAPHIC(8000),
	IN v_DBDDIDataList10		VARGRAPHIC(8000),
	IN v_DBDocumentList1		VARGRAPHIC(8000),
	IN v_DBDocumentList2		VARGRAPHIC(8000),
	IN v_DBDocumentList3		VARGRAPHIC(8000),
	IN v_DBDocumentList4		VARGRAPHIC(8000),
	IN v_DBDocumentList5		VARGRAPHIC(8000),
	IN v_DBAttributeList1		VARGRAPHIC(8000),
	IN v_DBAttributeList2		VARGRAPHIC(8000),
	IN v_DBAttributeList3		VARGRAPHIC(8000),
	IN v_DBAttributeList4		VARGRAPHIC(8000),
	IN v_DBAttributeList5		VARGRAPHIC(8000),
	IN v_DBAttributeList6		VARGRAPHIC(8000),
	IN v_DBAttributeList7		VARGRAPHIC(8000),
	IN v_DBAttributeList8		VARGRAPHIC(8000),
	IN v_DBAttributeList9		VARGRAPHIC(8000),
	IN v_DBAttributeList10		VARGRAPHIC(8000),
	IN v_DBGenerateLog		CHAR(1),
	/* Changed By Varun Bhansaly On 02/02/2007 */
	IN v_DBExpectedProcessDelay	TIMESTAMP
)
/*_________________________________________________________________________________________________
				NEWGEN SOFTWARE TECHNOLOGIES LIMITED
___________________________________________________________________________________________________
	Group				: Application – Products
	Product / Project		: WorkFlow 7.0
	Module				: WorkFlow Server
	File Name			: WFUploadWorkItem.sql
	Author				: Virochan
	Date written (DD/MM/YYYY)	: 20/06/2006
	Description			: This stored procedure is called from WMMiscellaneous.java
___________________________________________________________________________________________________

					CHANGE HISTORY
___________________________________________________________________________________________________
 Date				Change By					Change Description (Bug No. (If Any))

 08/11/2006			Varun Bhansaly				Bugzilla Bug 265 - FolderIndex returned
 08/11/2006			Varun Bhansaly		 		Bugzilla Bug 270 - For multiple introduction worksteps
 08/11/2006			Varun Bhansaly		 		Bugzilla Bug 271 - Default value is checked against Date Type (8) variable
 02/02/2007			Varun Bhansaly				Extra Parameter added for Calendar Support and insert statement modified
 08/02/2007			Varun Bhansaly				Bugzilla Id 74 (Inconsistency in date-time)
 05/04/2007			Tirupati Srivastava			Bugzilla Id 529 (UploadWorkItem)
_________________________________________________________________________________________________
*/



 DYNAMIC RESULT SETS 1
 LANGUAGE SQL
 P1 : BEGIN
     /* Changed By Varun Bhansaly On 02/02/2007 */	
	 /* DECLARE v_ProcessTurnAroundTime        INTEGER; */
	 DECLARE v_DBParentFolderId				INTEGER;
	 DECLARE v_DBFolderName			VARCHAR(255);
	 DECLARE v_DBAccessType			CHAR(1);
	 DECLARE v_DBImageVolumeIndex		INTEGER;
	 DECLARE v_DBFolderType			CHAR(1);
     DECLARE v_DBVersionFlag		CHAR(1);
	 DECLARE v_DBComment			VARCHAR(1020);
	 DECLARE v_DBOwner			SMALLINT;
	 DECLARE v_DBExpiryDateTime		CHAR(50);
	 DECLARE v_NameLength			INTEGER;
	 DECLARE v_LimitCount			INT;
	 DECLARE v_DBEnableFTS			CHAR(1);
	 DECLARE v_DuplicateNameFlag		CHAR(1);
	 DECLARE v_DBDataDefinitionIndex	INT;
	 DECLARE v_DBLocation			char;
	 DECLARE v_DBUserRights      		CHAR(10) ;
	 DECLARE v_FolderLock			CHAR(1);
	 DECLARE v_FinalizedFlag		CHAR(1);
	 DECLARE v_EnableVersion		CHAR(1);
	 DECLARE v_UpdateList			VARCHAR(255);
 	 DECLARE v_DBStatus			INTEGER;
	 DECLARE v_DBUserId        		INTEGER;
  	 DECLARE v_Rights    			CHAR(1);
  	 DECLARE v_NewFolderIndex		INT;
  	 DECLARE v_iCount 			INT;
	 DECLARE v_DBFlag			CHAR(1);
	 DECLARE v_DBFieldName			CHAR(64) ;
	 DECLARE v_TempUser			SMALLINT;
	 DECLARE v_AccessType			CHAR(1);
	 DECLARE v_ACLMore			CHAR(1);
	 DECLARE v_ACLstr			VARCHAR(255);
	 DECLARE v_MainGroupId			SMALLINT;
	 DECLARE v_IsAdmin 			CHAR(1);
	 DECLARE v_ExpiryDateTime		TIMESTAMP;
	 DECLARE v_ParentEnableFTS 		CHAR(1);
	 DECLARE v_ParentFolderType		CHAR(1);
	 DECLARE v_LockByUser			VARCHAR(255);
	 DECLARE v_EffectiveLockByUser		SMALLINT;
	 DECLARE v_LockMessage			VARCHAR(255);
	 DECLARE v_LockedObject			INT;
	 DECLARE v_FolderLevel 			INT;
	 DECLARE v_FolLock			CHAR(1);
	 DECLARE v_FolLockByUser		VARCHAR(255);
	 DECLARE v_Hierarchy			VARCHAR(4000);
	 DECLARE v_ProcessState			VARGRAPHIC(10);
	 DECLARE v_RegPrefix			VARGRAPHIC(20);
	 DECLARE v_RegSuffix			VARGRAPHIC(20);
	 DECLARE v_RegStartingNo		INT;
	 DECLARE v_RegSeqLength			INT;
	 DECLARE v_TableViewName		VARGRAPHIC(255);
	 DECLARE v_DataClassFlag		CHAR(1);
	 DECLARE v_Length			INT;
	 DECLARE v_ProcessInstanceId		VARGRAPHIC(50);
	 DECLARE v_ColumnList			VARCHAR(800);
	 DECLARE v_ValueList			VARCHAR(8000);
	 DECLARE v_WhileCounter			INT;
	 DECLARE v_DDTTableName			VARCHAR(255);
	 DECLARE v_QueueName			VARGRAPHIC(255);
	 DECLARE v_QueueId			INT;
	 DECLARE v_StreamId			INT;
	 DECLARE v_ActivityId			INTEGER;
	 DECLARE v_ActivityName			VARGRAPHIC(30);
	 DECLARE v_UserName			VARCHAR(256);
	 DECLARE v_UpdateStr			VARCHAR(8000);
	 DECLARE v_UpdateFlag			CHAR(1);
	 DECLARE v_UpdateDFlag			CHAR(1);
	 DECLARE v_SystemDefinedName		VARGRAPHIC(50);
	 DECLARE v_VariableType			SMALLINT;
	 DECLARE v_DefaultValue			VARGRAPHIC(255);
	 DECLARE v_DBDDIDataList		VARGRAPHIC(8000);
	 DECLARE v_ParseCount			INT;
	 DECLARE v_pos1				INT;
	 DECLARE v_TempStr			VARCHAR(8000);
	 DECLARE v_TempFieldName		VARCHAR(100);
	 DECLARE v_TempFieldValue		VARCHAR(4000);
	 DECLARE v_TempFieldId			INT;
	 DECLARE v_TempDataFieldType		CHAR(1);
	 DECLARE v_DBDocumentList		VARGRAPHIC(8000);
	 DECLARE v_DocumentName			VARCHAR(255);
	 DECLARE v_ISIndexStr			VARCHAR(50);
	 DECLARE v_ImageIndex 			INT;
	 DECLARE v_VolumeIndex 			INT;
	 DECLARE v_CurrDate 			TIMESTAMP;
	 DECLARE v_NextOrder 			INT;
	 DECLARE v_NewDocumentIndex		INT;
	 DECLARE v_NoOfPage 			INT;
	 DECLARE v_DocumentSize 		INT;
	 DECLARE v_AttributeName		VARCHAR(50);
	 DECLARE v_AttributeType		CHAR(1);
	 DECLARE v_AttributeValue		VARCHAR(500);
	 DECLARE v_TempTableName		VARCHAR(255);
	 DECLARE v_TempColumnName		VARCHAR(255);
	 DECLARE v_TempColumnType		CHARACTER(10);
	 DECLARE v_TempValue			VARCHAR(500);
	 DECLARE v_DBAttributeList		VARGRAPHIC(8000);
	 DECLARE v_UserDefinedName		VARGRAPHIC(50);
	 DECLARE v_ExtObjID			INTEGER;
	 DECLARE v_Rec1 			VARCHAR(255);
	 DECLARE v_Var_Rec_1 			VARCHAR(255);
	 DECLARE v_Rec2				VARCHAR(255);
	 DECLARE v_Var_Rec_2			VARCHAR(255);
	 DECLARE v_Rec3				VARCHAR(255);
	 DECLARE v_Var_Rec_3			VARCHAR(255);
	 DECLARE v_Rec4				VARCHAR(255);
	 DECLARE v_Var_Rec_4			VARCHAR(255);
	 DECLARE v_Rec5				VARCHAR(255);
	 DECLARE v_Var_Rec_5 			VARCHAR(255);
	 DECLARE v_TempVar			VARCHAR(4000);
 	 DECLARE v_AttributeNameStr		VARGRAPHIC(8000);
	 DECLARE v_UpdateColumnStr		VARGRAPHIC(8000);
	 DECLARE v_UpdateValueStr		VARGRAPHIC(8000);
	 DECLARE v_QueryStr			VARCHAR(8000);
	 DECLARE v_Pattern			VARCHAR(400);
	 DECLARE v_atempstr			VARCHAR(8000);
	 DECLARE v_atempstrdummy		VARCHAR(8000);
	 DECLARE v_Posi1			INT;
	 DECLARE v_Posi2			INT;
	 DECLARE v_yesValue			VARCHAR(500);
	 DECLARE v_InsertExtColumnStr		VARCHAR(8000);
	 DECLARE v_InsertExtValueStr		VARCHAR(8000);
	 DECLARE v_TempExtObjID			INT;
	 DECLARE v_Temp				SMALLINT;
	 DECLARE v_DBProcessDefIdStr 		VARCHAR(10);
	 DECLARE v_ActivityIdStr 		VARCHAR(10);
	 DECLARE v_ValidTill			TIMESTAMP;
	 DECLARE v_AttributeRouteStr		VARCHAR(8000);
	 DECLARE v_ProcessName			VARGRAPHIC(64);
	 DECLARE v_ProcessVersion 		SMALLINT;
	 DECLARE v_PriorityLevel		SMALLINT;
	 DECLARE v_DBTotalDuration		INTEGER;
	 DECLARE v_DBTotalPrTime		INTEGER;
	 DECLARE v_count			INTEGER;
	 DECLARE v_ValidationReqd1		VARCHAR(1000);
	 DECLARE v_size				INTEGER;
	 DECLARE rowCount			INT;
	 DECLARE RCount				INT; /* RowCount */
         DECLARE end_of_fetch                   INT;
         DECLARE execute_immediate_query        VARCHAR(1000);
         DECLARE SQLCODE                        INTEGER DEFAULT 0;
 	 DECLARE Status 			INTEGER;
	 DECLARE DBFolderName 			VARCHAR(255);
	 DECLARE CurrDate			TIMESTAMP;
 	 DECLARE v_FolderIndex			INTEGER;
	
	 DECLARE v_Cursor_stmt STATEMENT;
 	 DECLARE v_Cursor_stmt1 STATEMENT;
	 DECLARE v_valcur cursor for v_Cursor_stmt;
	 DECLARE v_attrcur cursor WITH HOLD for v_Cursor_stmt1;
	 DECLARE v_sysattrcur cursor for v_Cursor_stmt;
	 DECLARE v_UpdateQueue cursor for v_Cursor_stmt;
	 DECLARE returnCur CURSOR WITH RETURN FOR
		SELECT v_DBStatus AS Status, v_DBFolderName AS DBFolderName, v_CurrDate AS CurrDate, v_FolderIndex AS FolderIndex FROM sysibm.sysdummy1;
	
	 set v_FolLock	=  'N';
	 set v_FolLockByUser	= NULL;
	 set v_DBUserRights	= '';
	 set v_DBStatus	= -1 ;
	 set v_UpdateFlag	= 'n';
	 set v_TempStr	= '';
         call PRTCheckUser (v_DBConnectId, v_DBHostname, v_DBUserId , v_MainGroupId , v_DBStatus );
       	 IF (v_DBStatus <> 0) THEN
	 BEGIN
		OPEN returnCur;
		RETURN 0;
	 END;
	 END IF;

	SET v_ValidationReqd1 = v_ValidationReqd;
	IF (v_ValidationReqd1 IS NOT NULL) THEN
	BEGIN
		set v_pos1		= POSSTR(v_ValidationReqd1,CHR(21));
		set v_TempTableName	= SUBSTR(v_ValidationReqd1, 1, v_pos1-1);
		set v_ValidationReqd1	= SUBSTR(v_ValidationReqd1, v_pos1+1);
		set v_pos1		= POSSTR(v_ValidationReqd1,CHR(21));
		set v_TempColumnName	= SUBSTR(v_ValidationReqd1, 1, v_pos1-1);
		set v_ValidationReqd1	= SUBSTR(v_ValidationReqd1, v_pos1+1);
		set v_pos1		= POSSTR( v_ValidationReqd1,CHR(25));
		set v_TempValue		= RTRIM(SUBSTR(v_ValidationReqd1, 1, v_pos1-1));
		
		BEGIN
			DECLARE EXIT HANDLER FOR NOT FOUND
			BEGIN
				set v_TempColumnType = NULL;
				set v_dbstatus = 15 ;
				RESIGNAL;
			END;
			
			SELECT 	  COLTYPE
			INTO v_TempColumnType
			FROM SYSIBM.SYSCOLUMNS
			WHERE  	TBNAME 	= v_TempTableName
			AND 	NAME 	= v_TempColumnName;
			
		END;
		
		IF UPPER(v_TempColumnType) IN ('VARCHAR', 'CHARACTER', 'TIMESTAMP') THEN
			 set v_TempValue = CHR(39) || v_TempValue || CHR(39);
		END IF;

		BEGIN
			DECLARE EXIT HANDLER FOR SQLException
			BEGIN
				CLOSE v_valcur;
				set v_dbstatus = 15 ;
				RESIGNAL;
			END;
			
			DECLARE CONTINUE HANDLER FOR NOT FOUND
			BEGIN
				SET end_of_fetch = 1;
			END;

			SET v_QueryStr = ' SELECT 1 FROM ' || v_TempTableName ||' WHERE '|| v_TempColumnName || ' = ' || v_TempValue;
			PREPARE v_Cursor_stmt FROM v_QueryStr;
			OPEN v_valcur;	
			
			SET v_DBStatus = SQLCODE;
			IF (v_DBStatus <> 0) THEN
			BEGIN
				SET v_dbStatus = 15 ;
				CLOSE v_valcur;
				OPEN returnCur;
				RETURN 0;
			END;
			END IF;
			
			WHILE (end_of_fetch = 0) DO
				FETCH v_valcur into v_Temp;
				SET rowCount = rowCount + 1;
			END WHILE;
			
			IF(rowCount > 0) THEN
				SET v_DBStatus	=  50;
				CLOSE v_valcur;
				OPEN returnCur;
				RETURN 0;
			END IF;

			set v_DBStatus = SQLCODE;
			CLOSE v_valcur;
		END;
	END;
	END IF;
	If ((v_InitiateFromActivityId IS NOT NULL) AND v_InitiateFromActivityId > 0) THEN
		BEGIN
			DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				set v_dbStatus = 603;
				open returnCur;
				RESIGNAL;
        		END;
			
			SELECT	ActivityId, ActivityName
			INTO	v_ActivityId, v_ActivityName
			FROM	ActivityTable
			WHERE	ProcessDefID	= v_DBProcessDefId
			AND	ActivityType	= 1
			AND	ActivityId	= v_InitiateFromActivityId;
		END;
	Else
		If((v_InitiateFromActivityName IS NOT NULL) AND LENGTH(RTRIM(v_InitiateFromActivityName)) > 0 ) THEN
			BEGIN
				DECLARE EXIT HANDLER FOR SQLEXCEPTION
				BEGIN
					set v_dbStatus = 603;
					open returnCur;
					RESIGNAL;
        			END;		
				
				SELECT	ActivityId, ActivityName
				INTO	v_ActivityId, v_ActivityName
				FROM	ActivityTable
				WHERE	ProcessDefID = v_DBProcessDefId
				AND	ActivityType = 1
				AND	UPPER(ActivityName) = UPPER(RTRIM(v_InitiateFromActivityName));
			END;
		Else
			SELECT	ActivityId, ActivityName
			INTO	v_ActivityId, v_ActivityName
			FROM	ActivityTable
			WHERE	ProcessDefID = v_DBProcessDefId
			AND	ActivityType = 1
			AND	PrimaryActivity = 'Y';		
		End IF;
	End IF;
	BEGIN
		DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
		BEGIN
			SET v_TableViewName = NULL;
			RESIGNAL;
		END;	
		SELECT 	TableName INTO v_TableViewName
		FROM 	ExtDBConfTable
		WHERE 	ProcessDefId = v_DBProcessDefId;
	END;
	
	SET v_UpdateColumnStr 	= N'';
	SET v_UpdateValueStr 	= N'';
	IF (v_DBAttributeList1 IS NOT NULL) THEN
		SET v_AttributeNameStr	= N'';
		SET v_ParseCount	= 1;
		SET v_WhileCounter	= 1;

		WHILE (v_WhileCounter <= 10) DO
			IF (v_WhileCounter = 1) THEN
				 SET v_DBAttributeList = v_DBAttributeList1;
			ELSE
				IF (v_WhileCounter = 2) THEN
					 SET v_DBAttributeList = v_DBAttributeList2;
				ELSE
					IF (v_WhileCounter = 3) THEN
						 SET v_DBAttributeList = v_DBAttributeList3;
					ELSE
						IF (v_WhileCounter = 4) THEN
							SET v_DBAttributeList = v_DBAttributeList4;
						ELSE
							IF (v_WhileCounter = 5) THEN
								 SET v_DBAttributeList = v_DBAttributeList5;
							ELSE
								IF (v_WhileCounter = 6) THEN
									 SET v_DBAttributeList = v_DBAttributeList6;
								ELSE
									IF (v_WhileCounter = 7) THEN
										 SET v_DBAttributeList = v_DBAttributeList7;
									ELSE
										IF (v_WhileCounter = 8) THEN
											 SET v_DBAttributeList = v_DBAttributeList8;
										ELSE
											IF (v_WhileCounter = 9) THEN
												 SET v_DBAttributeList = v_DBAttributeList9;
											ELSE
												IF (v_WhileCounter = 10) THEN
													 SET v_DBAttributeList = v_DBAttributeList10;
												 END IF;
											 END IF;
										END IF;
									END IF;
								END IF;
							END IF;
						END IF;
					END IF;
				END IF;
			END IF;
			
			whileloop_1:
			WHILE (LENGTH(v_DBAttributeList) > 0) DO
				IF(v_ParseCount = 1)THEN
					BEGIN
						SET v_pos1 = POSSTR(v_DBAttributeList, CHR(21));
						IF (v_pos1 = 0) THEN
							BEGIN
								 SET v_TempStr	 = CHAR(SUBSTR(v_DBAttributeList, 1));
								 SET v_DBDDIDataList = NULL;
								 LEAVE whileloop_1;
							END;
						ELSE
							BEGIN
								 SET v_AttributeName 	= RTRIM(v_TempStr) || CHAR(SUBSTR(v_DBAttributeList, 1, v_pos1-1));
								 SET v_DBAttributeList	= SUBSTR(v_DBAttributeList,v_pos1+1);
								 SET v_ParseCount	= 2;
								 SET v_TempStr		= '';
								 SET v_AttributeNameStr	= LTRIM(RTRIM(v_AttributeNameStr)) || ',' || CHR(39) || VARGRAPHIC(LTRIM(RTRIM(v_AttributeName))) || CHR(39);
							END;
						END IF;
					END;
				END IF;

				IF(v_ParseCount = 2) THEN
					BEGIN
						SET v_pos1 = POSSTR( v_DBAttributeList,CHR(25));
						IF (v_pos1 = 0)THEN
							BEGIN
								 SET v_TempStr = CHAR(SUBSTR(v_DBAttributeList, 1));
								 SET v_DBAttributeList = NULL;
								 LEAVE whileloop_1;
							END;
						ELSE
							BEGIN
								 SET v_AttributeValue  = RTRIM(v_TempStr) || CHAR(SUBSTR(v_DBAttributeList, 1, v_pos1-1));
								 SET v_DBAttributeList = SUBSTR(v_DBAttributeList, v_pos1+1);
								 SET v_ParseCount = 1;
								 SET v_TempStr = '';
							END;
						END IF;
					END;
				END IF;
			END WHILE;
			SET v_WhileCounter = v_WhileCounter + 1;
		END WHILE;
		
		
		SET v_AttributeNameStr  	= SUBSTR(v_AttributeNameStr,2);
		SET v_DBProcessDefIdStr 	= CHAR(v_DBProcessDefId);
		SET v_ActivityIdStr 		= CHAR(v_ActivityId);
		SET v_InsertExtColumnStr	= '';
		SET v_InsertExtValueStr		= '';
		SET v_AttributeRouteStr		= '';

		BEGIN
			DECLARE CONTINUE HANDLER FOR NOT FOUND
			BEGIN
				SET end_of_fetch = 1;
                	        CLOSE v_attrcur;
				RESIGNAL;
			END;
			
			DECLARE EXIT HANDLER FOR SQLEXCEPTION, SQLWARNING
			BEGIN
        			CLOSE v_attrcur;
			        SET v_dbStatus = 15;
				open returnCur;
				RESIGNAL;
			END;

			SET v_QueryStr = 'SELECT  UserDefinedName, SystemDefinedName, VarMappingTable.ExtObjID, VariableType FROM VarMappingTable , 				ActivityAssociationTable WHERE ActivityAssociationTable.ProcessDefID = '
				            || RTRIM(UPPER(v_DBProcessDefIdStr)) || ' AND ActivityAssociationTable.ProcessDefID = VarMappingTable.ProcessDefID AND UPPER(UserDefinedName) IN ( '
			                || LTRIM(RTRIM(VARCHAR(UPPER(v_AttributeNameStr)))) ||
			                ' ) AND VariableScope IN ( ''U'' , ''Q'' , ''I'' ) AND UPPER(RTRIM(ActivityAssociationTable.FieldName)) = UPPER(RTRIM(VarMappingTable.UserDefinedName)) AND ActivityAssociationTable.ActivityId = '|| RTRIM(UPPER(v_ActivityIdStr)) || ' AND Attribute  IN (''O'' , ''B'' , ''M'' ) UNION 	SELECT 	UserDefinedName, SystemDefinedName, VarMappingTable.ExtObjID, VariableType FROM 	VarMappingTable  WHERE VariableScope = ''M'' AND VarMappingTable.ProcessDefID =  '
			                || RTRIM(UPPER(v_DBProcessDefIdStr)) ||' AND 	UserDefinedName IN ( ' || LTRIM(RTRIM(VARCHAR(UPPER(v_AttributeNameStr))))||')';
        		PREPARE v_Cursor_stmt1 FROM v_QueryStr;
			OPEN v_attrcur;
			
			SET end_of_fetch = 0;
			FETCH v_attrcur	INTO v_UserDefinedName, v_SystemDefinedName, v_ExtObjID, v_VariableType;
			WHILE (end_of_fetch = 0)
			DO
			       SET v_AttributeRouteStr = LTRIM(RTRIM(UPPER(v_AttributeRouteStr))) ||  RTRIM(UPPER(VARCHAR(v_UserDefinedName))) || CHR(21);
                               IF (v_ExtObjID = 0)
			       THEN
				        IF (v_UpdateFlag = N'Y')
				        THEN
					    	 SET v_UpdateColumnStr = LTRIM(RTRIM(v_UpdateColumnStr)) || ',' || RTRIM(UPPER(v_SystemDefinedName));
    					ELSE
	    					 SET v_UpdateColumnStr = LTRIM(RTRIM(v_SystemDefinedName));
		    			END IF;
					
        				SET v_atempstr     = CHR(25) || LTRIM(RTRIM(CHAR(v_DBAttributeList1)));
         				SET v_atempstrdummy = v_atempstr;
        				SET v_Pattern      = CHR(25) || RTRIM(UPPER(CHAR(v_UserDefinedName))) || CHR(21);
        				SET v_Posi1        = POSSTR (UPPER(v_atempstr),v_Pattern);
        			
        				SET v_atempstr     = SUBSTR(UPPER(v_atempstr), LENGTH(v_Pattern) + v_Posi1);
				        SET v_Posi2        = POSSTR(UPPER(v_atempstr),CHR(25));
				    	SET v_yesValue     = SUBSTR(RTRIM(v_atempstrdummy), v_Posi1 + LENGTH(v_Pattern), v_Posi2 - 1);
				    	SET v_AttributeRouteStr = RTRIM(v_AttributeRouteStr) ||  COALESCE(v_yesValue,'') || CHR(25);
				        SET v_yesValue = LTRIM(RTRIM(v_yesValue));
				        IF (LENGTH(v_yesValue) > 0)
				        THEN
					        IF (v_VariableType = 10)
					        THEN
							SET v_yesValue = CHR(39) || RTRIM(v_yesValue) || CHR(39);
						END IF;

						IF (v_VariableType = 8)
						THEN
    					               	SET v_yesValue = 'TIMESTAMP_FORMAT(' ||CHR(39) || RTRIM(v_yesValue) || CHR(39)
    					               	|| ',' || CHR(39) || 'YYYY-MM-DD HH24:MI:SS' || CHR(39) || ')';
						END IF;

						IF (v_UpdateFlag = 'Y')
						THEN
							 SET v_UpdateValueStr = LTRIM(RTRIM(v_UpdateValueStr)) || ',' || VARGRAPHIC(LTRIM(RTRIM(v_yesValue))) ;
						ELSE
							 SET v_UpdateValueStr = VARGRAPHIC(LTRIM(RTRIM(v_yesValue)));
						END IF;
					ELSE
					        IF (v_UpdateFlag = 'Y')
					        THEN
							 SET v_UpdateValueStr = LTRIM(RTRIM(v_UpdateValueStr)) || ',NULL';
						ELSE
							 SET v_UpdateValueStr = N'NULL';
						END IF;
        				END IF;
			        	SET v_UpdateFlag = 'Y';
			        ELSE
					 SET v_TempExtObjID = v_ExtObjID;
					 SET v_InsertExtColumnStr = LTRIM(RTRIM(v_InsertExtColumnStr)) || ',' || LTRIM(RTRIM(UPPER(VARCHAR(v_SystemDefinedName))));
					 SET v_atempstr     = CHR(25) || LTRIM(RTRIM(VARCHAR(v_DBAttributeList1)));
					 SET v_atempstrdummy= v_atempstr;
					 SET v_Pattern      = CHR(25) || LTRIM(RTRIM(UPPER(VARCHAR(v_UserDefinedName)))) || CHR(21);
					 SET v_Posi1        = POSSTR(LTRIM(RTRIM(UPPER(v_atempstr))),LTRIM(RTRIM(UPPER(v_Pattern))));
					 SET v_atempstr     = SUBSTR(LTRIM(RTRIM(UPPER(v_atempstr))), LENGTH(LTRIM(RTRIM(v_Pattern))) + v_Posi1);
					 SET v_Posi2        = POSSTR(LTRIM(RTRIM(UPPER(v_atempstr))),CHR(25));
					 SET v_yesValue     = SUBSTR(LTRIM(RTRIM(v_atempstrdummy)), v_Posi1 + LENGTH(LTRIM(RTRIM(v_Pattern))), v_Posi2 - 1);
					 SET v_AttributeRouteStr = LTRIM(RTRIM(v_AttributeRouteStr)) ||  LTRIM(RTRIM(COALESCE(v_yesValue,''))) || CHR(25);
					 SET v_yesValue = LTRIM(RTRIM(v_yesValue));

					IF (LENGTH(v_yesValue) > 0)
					THEN
					        IF (v_VariableType = 10)
					        THEN
        			                     SET v_yesValue = CHR(39) || LTRIM(RTRIM(v_yesValue)) || CHR(39);
						END IF;

						IF (v_VariableType = 8)
						THEN
        					        SET v_yesValue = 'TIMESTAMP_FORMAT(' ||CHR(39) || RTRIM(v_yesValue) || CHR(39)
    					               	|| ',' || CHR(39) || 'YYYY-MM-DD HH24:MI:SS' || CHR(39) || ')';
						END IF;
						SET v_InsertExtValueStr = LTRIM(RTRIM(v_InsertExtValueStr)) || ',' || LTRIM(RTRIM(v_yesValue));
        				ELSE
					        SET v_InsertExtValueStr = LTRIM(RTRIM(v_InsertExtValueStr)) || ', NULL';
					END IF;
				END IF;
			
                                FETCH v_attrcur	INTO v_UserDefinedName, v_SystemDefinedName, v_ExtObjID, v_VariableType;
                    END WHILE;
               END;	
	END IF;
	
	IF (v_DataDefinitionName IS NOT NULL) THEN
		BEGIN
			DECLARE EXIT HANDLER FOR NOT FOUND
			BEGIN
				call PRTRaiseError('Excp_DDI_Not_Exist', v_DBStatus);
				RESIGNAL;
			END;			
			
			SELECT 	DataDefIndex INTO v_DBDataDefinitionIndex
			FROM 	PDBDataDefinition
			WHERE 	RTRIM(UPPER(DataDefName)) = RTRIM(UPPER(v_DataDefinitionName))
			AND 	GroupId = v_MainGroupId;
		
		END;

		SET v_DDTTableName = 'DDT_' || CHAR(v_DBDataDefinitionIndex);
	ELSE
		SET v_DBDataDefinitionIndex  = 0;
	END IF;
	

	IF ( v_DBDataDefinitionIndex <> 0 ) THEN
	BEGIN
		 SET v_WhileCounter = 1;
		 SET v_ColumnList   = '';
		 SET v_ValueList    = '';

		WHILE (v_WhileCounter <= 10) DO
		BEGIN
			IF (v_WhileCounter = 1) THEN
				 SET v_DBDDIDataList = v_DBDDIDataList1;
			ELSE
				IF (v_WhileCounter = 2) THEN
					 SET v_DBDDIDataList = v_DBDDIDataList2;
				ELSE
					IF (v_WhileCounter = 3) THEN
						 SET v_DBDDIDataList = v_DBDDIDataList3;
					ELSE
						IF (v_WhileCounter = 4) THEN
							 SET v_DBDDIDataList = v_DBDDIDataList4;
						ELSE
							IF (v_WhileCounter = 5) THEN
								SET v_DBDDIDataList = v_DBDDIDataList5;
							ELSE
								IF (v_WhileCounter = 6) THEN
									SET v_DBDDIDataList = v_DBDDIDataList6;
								ELSE
									IF (v_WhileCounter = 7) THEN
										SET v_DBDDIDataList = v_DBDDIDataList7;
									ELSE
										IF (v_WhileCounter = 8)	THEN
											SET v_DBDDIDataList = v_DBDDIDataList8;
										ELSE
											IF (v_WhileCounter = 9) THEN
												SET v_DBDDIDataList = v_DBDDIDataList9;
											ELSE
												IF (v_WhileCounter = 10) THEN
													SET v_DBDDIDataList = v_DBDDIDataList10;
												END IF;
											END IF;
										END IF;
									END IF;
								END IF;
							END IF;
						END IF;
					END IF;
				END IF;
			END IF;

			SET v_ParseCount = 1;
			SET v_TempStr = '';

			whileloop_2:
			WHILE (LENGTH(v_DBDDIDataList) > 0) DO
			BEGIN
				IF(v_ParseCount = 1) THEN
				BEGIN
					SET v_pos1 = POSSTR(v_DBDDIDataList,CHR(21));
					IF (v_pos1 = 0) THEN
					BEGIN
						SET v_TempStr = CHAR(SUBSTR(v_DBDDIDataList, 1));
						SET v_DBDDIDataList = NULL;
						LEAVE whileloop_2;
					END;

					ELSE
					BEGIN
						SET v_TempFieldName = RTRIM(v_TempStr) || CHAR(SUBSTR(v_DBDDIDataList, 1, v_pos1-1));
						SET v_DBDDIDataList = SUBSTR(v_DBDDIDataList, v_pos1+1);
						SET v_ParseCount = 2;
						SET v_TempStr = ' ';
					END;
					END IF;
				END;
				END IF;
				IF(v_ParseCount = 2) THEN
				BEGIN
					SET v_pos1 = POSSTR( v_DBDDIDataList,CHR(25));
					IF (v_pos1 = 0) THEN
					BEGIN
						 SET v_TempStr = CHAR(SUBSTR(v_DBDDIDataList, 1));
						 SET v_DBDDIDataList = NULL;
						 LEAVE whileloop_2;
					END;
					ELSE
					BEGIN
						SET v_TempFieldValue	= RTRIM(v_TempStr) || CHAR(SUBSTR(v_DBDDIDataList, 1, v_pos1-1));
						SET v_DBDDIDataList = SUBSTR(v_DBDDIDataList,v_pos1+1);
						SET v_ParseCount = 1;
						SET v_TempStr = ' ';
												
						BEGIN
							DECLARE EXIT HANDLER FOR SQLEXCEPTION
							BEGIN
								SET v_dbSTATUS = 15; 	
								RESIGNAL;
							END;

							SELECT	 A.DataFieldIndex,DataFieldType
							INTO v_TempFieldId,v_TempDataFieldType
							FROM PDBGlobalIndex A, PDBDataFieldsTable B
							WHERE A.DataFieldIndex = B.DataFieldIndex
							AND   B.DataDefIndex = v_DBDataDefinitionIndex
							AND   RTRIM(UPPER(A.DataFieldName)) = RTRIM(UPPER(v_TempFieldName));

						END;
						
        					IF (SQLCODE <> 100 AND SQLCODE = 0) THEN
						BEGIN
							SET v_ColumnList =  RTRIM(v_ColumnList) || ', Field_' || LTRIM(RTRIM(VARCHAR(CHAR(v_TempFieldId))));
							SET v_size = LENGTH(LTRIM(RTRIM(v_TempFieldValue)));
							
							IF (LTRIM(RTRIM(v_TempFieldValue)) = 'ý' OR v_size = 0)THEN
								 SET v_TempFieldValue = 'NULL';
							END IF;

							IF(v_TempFieldValue = 'NULL') THEN
							BEGIN
								IF (v_TempDataFieldType = 'B') THEN
									SET v_TempFieldValue = '0';
									SET v_ValueList = RTRIM(v_ValueList) || ','||LTRIM(RTRIM(v_TempFieldValue));
								END IF;
							END;
							ELSE
								
								IF (v_TempDataFieldType = 'S') THEN
								BEGIN
									SET v_QueryStr = CHR(39) || CHR(39);
									 SET v_TempFieldValue = REPLACE(v_TempFieldValue,CHR(39),v_QueryStr );
									 SET v_ValueList = RTRIM(v_ValueList) || ',' || CHR(39) || RTRIM(v_TempFieldValue) || CHR(39);
								END;
								ELSE
									IF (v_TempDataFieldType = 'D') THEN
									BEGIN
                                                                               SET v_ValueList = RTRIM(v_ValueList) || ',TIMESTAMP_FORMAT(' || CHR(39) || RTRIM(v_TempFieldValue) || CHR(39) || ',' || Chr(39) || 'YYYY-MM-DD HH24:MI:SS' || CHR(39) ||')';
										
									END;
									ELSE
										IF (v_TempDataFieldType	= 'I' OR
											v_TempDataFieldType	= 'L' OR
											v_TempDataFieldType	= 'F' OR
											v_TempDataFieldType	= 'B' OR
											v_TempDataFieldType	= 'X') THEN
										BEGIN
											 SET v_ValueList = RTRIM(v_ValueList) || ',' || LTRIM(RTRIM(v_TempFieldValue));
										END;
										END IF;
									END IF;
								END IF;
							END IF;
							call CheckData  ('F', v_NewFolderIndex,RTRIM(UPPER(v_DDTTableName)), INTEGER(RTRIM(CHAR(v_TempFieldId))),RTRIM(UPPER(v_TempDataFieldType)), v_TempFieldValue, v_DBStatus );
							
							IF (v_DBStatus <> 0) THEN
							BEGIN
								OPEN returnCur;
								RETURN 0;
							END;
							END IF;
						END;
						END IF;
					END;
					END IF;
				END;
				END IF;
			END;
			END WHILE;
			SET v_WhileCounter = v_WhileCounter + 1;
		END;
		END WHILE;
	END;
	END IF;

	SET v_DBAccessType	= COALESCE(v_DBAccessType, 'S');
	SET v_DBFolderType	= COALESCE(v_DBFolderType, 'G');
	SET v_DBComment		= COALESCE(v_DBComment,	'Not Defined');
	SET v_DuplicateNameFlag	= COALESCE(v_DuplicateNameFlag, 'Y');
	SET v_CurrDate		= CURRENT TIMESTAMP;

	IF v_DBExpiryDateTime IS NULL THEN
	BEGIN
		 SET v_ExpiryDateTime = CAST('2099-12-31 00:00:00' AS TIMESTAMP);
	END;
	ELSE
	BEGIN
		 SET v_ExpiryDateTime = CAST(v_DBExpiryDateTime AS TIMESTAMP);
	END;
	END IF;

	BEGIN
		DECLARE EXIT HANDLER FOR NOT FOUND
	        BEGIN
	        	SET v_UserName = NULL;
			SET v_dbSTATUS = 15 ;
			RESIGNAL;
        	END;		
		
		SELECT 	 UserName INTO v_UserName
		FROM 	PDBUser
		WHERE 	UserIndex = v_DBUserId;
	END;

	BEGIN
		DECLARE EXIT HANDLER FOR NOT FOUND
	        BEGIN
			call PRTRaiseError('Excp_Invalid_Parameter', v_DBStatus);	
			RESIGNAL;
         	END;			
		
		SELECT WorkFlowFolderId INTO v_DBParentFolderId
		FROM   RouteFolderDefTable
		WHERE  ProcessDefId = v_DBProcessDefId;
	
	END;
	BEGIN
		DECLARE EXIT HANDLER FOR NOT FOUND
	        BEGIN
			SET v_DBStatus = 2;
			RESIGNAL;
        	END;		
		
		SELECT 	QUEUEDEFTABLE.QUEUENAME,
			QUEUEDEFTABLE.QUEUEID,
			QUEUESTREAMTABLE.STREAMID INTO v_QueueName, v_QueueId, v_StreamId
		FROM 	QUEUESTREAMTABLE, QUserGroupView , ACTIVITYTABLE , QUEUEDEFTABLE
		WHERE 	ACTIVITYTABLE.PROCESSDEFID 	= v_DBProcessDefId
		AND 	ACTIVITYTABLE.ACTIVITYTYPE 	= 1
		AND 	ACTIVITYTABLE.PROCESSDEFID 	= QUEUESTREAMTABLE.PROCESSDEFID
		AND 	ACTIVITYTABLE.ACTIVITYID	= QUEUESTREAMTABLE.ACTIVITYID
		AND 	ACTIVITYTABLE.ACTIVITYID	= v_ActivityId
		AND 	QUEUESTREAMTABLE.QUEUEID 	= QUserGroupView.QUEUEID
		AND 	QUEUEDEFTABLE.QUEUEID 		= QUserGroupView.QUEUEID
		AND 	QUEUETYPE 			= 'I'
		AND 	USERID 				= v_DBUserId
		FETCH FIRST 1 ROWS ONLY;
/*		  Added by :: Varun Bhansaly
	      Date     :: 20/12/2006
		  Purpose  :: To Limit Number of rows returned to 1
*/

	END;

	SAVEPOINT TranWorkItem ON ROLLBACK RETAIN CURSORS;
	UPDATE 	ProcessDefTable
	SET 	RegStartingNo 	= RegStartingNo + 1
	WHERE 	ProcessDefID 	= v_DBProcessDefId;

	SELECT	 ProcessState,
		RegPrefix,
		RegSuffix,
		RegStartingNo,
		RegSeqLength,
		ProcessName,
		VersionNo
		INTO v_ProcessState,v_RegPrefix,v_RegSuffix,v_RegStartingNo,v_RegSeqLength,v_ProcessName,v_ProcessVersion
	FROM	ProcessDefTable
	WHERE	ProcessDefID	= v_DBProcessDefId;
	IF (SQLCODE <> 0 AND SQLCODE <>100) THEN
	BEGIN
		SET v_dbStatus = 15;
		OPEN returnCur;
		RETURN 0;
	END;
	END IF;
	COMMIT;

	IF (v_ProcessState <> N'Enabled') THEN
	BEGIN
		 SET v_DBStatus = 2;
		 OPEN returnCur;
		 RETURN 0;
	END;
	END IF;

	SET v_RegStartingNo	= v_RegStartingNo;
	SET v_RegPrefix	= v_RegPrefix || N'-';
	SET v_RegSuffix	= N'-' || v_RegSuffix ;

	IF (LENGTH(v_RegStartingNo) > (v_RegSeqLength - LENGTH(v_RegPrefix) - LENGTH(v_RegSuffix))) THEN
	BEGIN
		 SET v_DBStatus = 19;
		 OPEN returnCur;
		 RETURN 0;
	END;
	END IF;

	SET v_Length = v_RegSeqLength - LENGTH(v_RegPrefix) - LENGTH(v_RegSuffix);
	
	IF (v_Length > 1) THEN
		SET v_ProcessInstanceId = N'0' || VARGRAPHIC(REPEAT('0', v_Length - 1));
	ELSE
		SET v_ProcessInstanceId = N'0';
	END IF;
	
	SET v_ProcessInstanceId	= v_RegPrefix || SUBSTR(v_ProcessInstanceId,1, LENGTH(v_ProcessInstanceId) - LENGTH(rtrim(CHAR(v_RegStartingNo)))) || VARGRAPHIC(rtrim(CHAR(v_RegStartingNo))) || v_RegSuffix;
	SET v_DBFolderName	= VARCHAR(v_ProcessInstanceId);

	BEGIN
		DECLARE EXIT HANDLER FOR NOT FOUND
		BEGIN
			call PRTRaiseError('Excp_Folder_Not_Exist', v_DBStatus);
			RESIGNAL;
		END;
		
		SELECT 	 FolderLock,
			 FinalizedFlag,
			 Location,
			 FolderType,
			 COALESCE(v_DBImageVolumeIndex, ImageVolumeIndex),
			 Owner,
			 AccessType,
			 ACLMoreFlag,
			 ACL,
			 EnableVersion,
			 EnableFTS,
			 MainGroupId,
			 LockMessage,
			 LockByUser,
			 FolderLevel
			 INTO v_FolderLock,v_FinalizedFlag,v_DBLocation,v_ParentFolderType,v_DBImageVolumeIndex,v_TempUser,v_AccessType,
			 v_ACLMore,v_ACLstr,v_EnableVersion,v_ParentEnableFTS,v_MainGroupId,v_LockMessage,v_LockByUser,v_FolderLevel
		FROM PDBFolder
		WHERE FolderIndex = v_DBParentFolderId
		AND (v_MainGroupId = 0 OR MainGroupId = v_MainGroupId);
	
		IF (NOT(v_DBLocation IN ('R','G','A') and v_DBFolderType IN ('G','A'))) THEN
		BEGIN
			 call PRTRaiseError('Excp_Cannot_AddFolder', v_DBStatus);
			 OPEN returnCur;
			 RETURN 0;
		END;
		ELSE
			IF v_ParentFolderType  = 'A' AND v_DBFolderType <> 'A' THEN
			BEGIN
				call PRTRaiseError('Excp_Cannot_AddFolder', v_DBStatus);
				SET Status = v_DBStatus;
				OPEN returnCur;
				RETURN 0;
			END;
			ELSE
				IF (v_FolderLock = 'Y') THEN
				BEGIN
					call CheckLock('F', v_DBParentFolderId, v_LockByUser, v_FolderLock, v_EffectiveLockByUser,
								v_LockMessage , v_LockedObject , v_DBStatus );
					IF (v_EffectiveLockByUser <> v_DBUserId) THEN
					BEGIN
						call PRTRaiseError('Excp_Folder_Locked', v_DBStatus);
						SET Status = v_DBStatus;
						OPEN returnCur;
						RETURN 0;
					END;
					END IF;
				SET v_FolLock		= 'Y';
				SET v_FolLockByUser	= v_LockByUser;

				END;
				ELSE
					IF (v_FinalizedFlag = 'Y') THEN
					BEGIN
						call PRTRaiseError('Excp_Finalised_Folder', v_DBStatus);
						OPEN returnCur;
						RETURN 0;
					END;
					END IF;
				END IF;
			END IF;
		END IF;
	END;

	IF (v_FolderLevel >= 255) THEN
	BEGIN
		call PRTRaiseError('Excp_Max_Level_Count_Reached', v_DBStatus);
		OPEN returnCur;
		RETURN 0;
	END;
	END IF;
	IF (v_LimitCount IS NOT NULL) THEN
	BEGIN
		SELECT COUNT(*)
		INTO v_count
		FROM PDBFolder
		WHERE ParentFolderIndex = v_DBParentFolderId
		AND AccessType = v_DBAccessType;

		IF (v_count >= v_LimitCount) THEN
		BEGIN
			call PRTRaiseError('Excp_Max_Folder_Count_Reached', v_DBStatus);
			OPEN returnCur;
			RETURN 0;
		END;
		END IF;
	END;
	END IF;
	
	IF (v_DBFolderName IS NULL) THEN
	BEGIN
		 call PRTGenerateDefaultName( 'F',v_DBParentFolderId, NULL, NULL, v_MainGroupId, v_DBFolderName ,
						v_DBStatus );
		IF (v_DBStatus <> 0) THEN
		BEGIN
			OPEN returnCur;
			RETURN 0;
		END;
		END IF;
	END;
	ELSE 	
	BEGIN
		call GenerateName('F' , v_DBFolderName, v_DBParentFolderId, NULL, NULL, v_NameLength, v_MainGroupId,
					v_DuplicateNameFlag, null, v_DBFolderName , v_DBStatus );
		IF (v_DBStatus <> 0) THEN
		BEGIN
			OPEN returnCur;
			RETURN 0;
		END;
		END IF;
	END;
	END IF;

	SET v_Hierarchy = COALESCE(RTRIM(v_Hierarchy), '') || RTRIM(CHAR(v_DBParentFolderId)) || '.';

	SAVEPOINT TranWorkItem ON ROLLBACK RETAIN CURSORS;
	SELECT NextVal FOR FolderId INTO v_NewFolderIndex from SYSIBM.SYSDUMMY1;
	
	INSERT INTO PDBFolder(FolderIndex,ParentFolderIndex, Name, Owner, CreatedDatetime, RevisedDateTime,
		AccessedDateTime, DataDefinitionIndex, AccessType, ImageVolumeIndex,
		FolderType, FolderLock, LockByUser, Location, DeletedDateTime,
		EnableVersion, ExpiryDateTime, Comment, UseFulData, ACL, FinalizedFlag,
		FinalizedDateTime, FinalizedBy, ACLMoreFlag, MainGroupId, EnableFTS, LockMessage,
		Folderlevel)
	VALUES (v_NewFolderIndex, v_DBParentFolderId, v_DBFolderName, v_DBUserId, v_CurrDate, v_CurrDate,
		v_CurrDate, v_DBDataDefinitionIndex, v_DBAccessType, v_DBImageVolumeIndex,
		v_DBFolderType, v_FolLock, v_FolLockByUser, v_ParentFolderType, TIMESTAMP_FORMAT('2099-12-31 00:00:00', 'YYYY-MM-DD HH24:MI:SS'),
		COALESCE(v_DBVersionFlag, v_EnableVersion), v_ExpiryDateTime, COALESCE(v_DBComment,''), NULL, NULL, 'N',
		TIMESTAMP_FORMAT('2099-12-31 00:00:00', 'YYYY-MM-DD HH24:MI:SS'), 0, 'N', v_MainGroupId, COALESCE(v_DBEnableFTS, v_ParentEnableFTS),
		v_LockMessage, v_FolderLevel + 1);

	IF( v_DBDataDefinitionIndex > 0) THEN
	BEGIN
		IF LENGTH(v_ColumnList) > 0 THEN
		BEGIN
			 SET v_ColumnList   = ' FoldDocIndex, FoldDocFlag' || v_ColumnList;
			 SET v_ValueList    = CHAR(v_NewFolderIndex) || ',' || CHR(39) || 'F' || CHR(39) || v_ValueList;
			
			 SET execute_immediate_query = 'INSERT INTO ' || CHAR(v_DDTTableName) || ' ( ' || v_ColumnList || ' ) VALUES ( ' || v_ValueList || ')';
			 EXECUTE IMMEDIATE execute_immediate_query;
			 SET v_DBStatus = SQLCODE;

			IF (v_DBStatus <> 0) THEN
			BEGIN
				ROLLBACK TO SAVEPOINT TranWorkItem;
				SET v_dbStatus = 15;
				OPEN returnCur;
				RETURN 0;
			END;
			END IF;
		END;
		END IF;
	call PRTBuildUseFulDataString (v_NewFolderIndex, 'F', v_DBDataDefinitionIndex, v_DBStatus );
	END;
	END IF;
	SET v_WhileCounter = 1;
	SET v_NextOrder = 0;

	WHILE  (v_WhileCounter <= 5) DO
	BEGIN
		IF (v_WhileCounter = 1) THEN
			 SET v_DBDocumentList = v_DBDocumentList1;
		ELSE
			IF (v_WhileCounter = 2)  THEN
				 SET v_DBDocumentList = v_DBDocumentList2;
			ELSE
				IF (v_WhileCounter = 3) THEN
					 SET v_DBDocumentList = v_DBDocumentList3;
				ELSE
					IF (v_WhileCounter = 4) THEN
						 SET v_DBDocumentList = v_DBDocumentList4;
					ELSE
						IF (v_WhileCounter = 5) THEN
							 SET v_DBDocumentList = v_DBDocumentList5;
						END IF;
					END IF;
				END IF;
			END IF;
		END IF;

		SET v_TempStr = '';
		whileloop_3:
		WHILE (LENGTH(v_DBDocumentList) > 0) DO
		BEGIN
			SET v_pos1 = POSSTR( v_DBDocumentList,CHR(25));
			IF (v_pos1 = 0) THEN
			BEGIN
				SET v_TempStr = CHAR(SUBSTR(v_DBDocumentList, 1));
				SET v_DBDDIDataList = NULL;
				LEAVE whileloop_3;
			END;
			ELSE
			BEGIN
				 SET v_TempStr 	= RTRIM(v_TempStr) || CHAR(RTRIM(SUBSTR(v_DBDocumentList, 1, v_pos1-1)));
				 SET v_DBDocumentList	= SUBSTR(v_DBDocumentList,v_pos1+1);
				 SET v_pos1 	= POSSTR( v_TempStr,CHR(21));
				 SET v_DocumentName = RTRIM(SUBSTR(v_TempStr, 1, v_pos1-1));
				 SET v_TempStr 	= REPLACE(v_TempStr,SUBSTR(v_TempStr, 1, v_pos1), '');
				 SET v_pos1 	= POSSTR( v_TempStr,CHR(21));
				 SET v_ISIndexStr 	= RTRIM(SUBSTR(v_TempStr, 1, v_pos1-1));
				 SET v_TempStr 	= REPLACE(v_TempStr, SUBSTR(v_TempStr,1, v_pos1), '');
				 SET v_pos1 	= POSSTR( v_TempStr,CHR(21));
				 SET v_NoOfPage 	= INTEGER(RTRIM(SUBSTR(v_TempStr, 1, v_pos1-1)));
				 SET v_DocumentSize = INTEGER(RTRIM(REPLACE(v_TempStr,SUBSTR(v_TempStr,1, v_pos1), '')));
       			         SET v_pos1 	= POSSTR( v_ISIndexStr,CHR(35));
				 SET v_ImageIndex 	= INTEGER(LTRIM(RTRIM(SUBSTR(v_ISIndexStr, 1, v_pos1-1))));
				 SET v_VolumeIndex 	= INTEGER(LTRIM(RTRIM(REPLACE(v_ISIndexStr, SUBSTR(v_ISIndexStr,1, v_pos1), ''))));
				 SET v_TempStr = '';
				 call GenerateName( 'D', v_DocumentName,
					v_NewFolderIndex, 'I', 'TIF',
					25, v_MainGroupId, 'Y', null, v_DocumentName, v_DBStatus );

				 IF (v_DBStatus <> 0) THEN
				 BEGIN
					ROLLBACK TO SAVEPOINT TranWorkItem;
					OPEN returnCur;
					RETURN 0;
				 END ;
				 END IF;

				SELECT  NextVal FOR DocumentID INTO v_NewDocumentIndex from sysibm.sysdummy1;
				INSERT INTO PDBDocument(DocumentIndex,VersionNumber, VersionComment,
					Name, Owner, CreatedDateTime, RevisedDateTime,
					AccessedDateTime, DataDefinitionIndex,
					Versioning, AccessType, DocumentType,
					CreatedbyApplication, CreatedbyUser,
					ImageIndex, VolumeId, NoOfPages, DocumentSize,
					FTSDocumentIndex, ODMADocumentIndex,
					HistoryEnableFlag, DocumentLock, LockByUser,
					Comment, Author, TextImageIndex, TextVolumeId,
					FTSFlag, DocStatus, ExpiryDateTime,
					FinalizedFlag, FinalizedDateTime, FinalizedBy,
					CheckOutstatus, CheckOutbyUser,	UseFulData,
					ACL, PhysicalLocation, ACLMoreFlag, AppName,
					MainGroupId, PullPrintFlag, ThumbNailFlag,
					LockMessage)
				 VALUES (v_NewDocumentIndex, 1.0,	'Original',
					v_DocumentName, v_DBUserId, v_CurrDate, v_CurrDate,
					v_CurrDate, 0,
					v_EnableVersion, 'I', 'I',
					0, v_DBUserId,
					v_ImageIndex, v_VolumeIndex, v_NoOfPage, v_DocumentSize,
					0, 'not defined',
					'N', 'N', NULL,
					' ', v_UserName, 0, 0,
					'XX', 'A', TIMESTAMP_FORMAT('2099-12-12 00:00:00', 'YYYY-MM-DD HH24:MI:SS'),
					'N', TIMESTAMP_FORMAT('2099-12-12 00:00:00', 'YYYY-MM-DD HH24:MI:SS'), 0,
					'N', 0, NULL,
					NULL, 'not defined', 'N', 'TIF',
					v_MainGroupId, 'N', 'N', NULL);

				SET v_DBStatus = SQLCODE ;

				IF (v_DBStatus <> 0) THEN
				BEGIN
					ROLLBACK TO SAVEPOINT TranWorkItem ;
					SET v_dbStatus = 15;
					OPEN returnCur;
					RETURN 0;
				END ;
				END IF;

				SET v_NextOrder = v_NextOrder + 1;
				INSERT INTO PDBDocumentContent(
					ParentFolderIndex, DocumentIndex,
					FiledBy, FiledDatetime,
					DocumentOrderNo, RefereceFlag)
				 VALUES(v_NewFolderIndex, v_NewDocumentIndex,
					v_DBUserId, v_CurrDate, v_NextOrder , 'O') ;
				 SET v_DBStatus = SQLCODE ;

				IF (v_DBStatus <> 0) THEN
				BEGIN
					ROLLBACK TO SAVEPOINT TranWorkItem;
					SET v_dbStatus = 15;
					OPEN returnCur;
					RETURN 0;
				END;
				END IF;
			END;
			END IF;
		END;
		END WHILE;
		SET v_WhileCounter = v_WhileCounter + 1;
	END;
	END WHILE;

	BEGIN
		DECLARE CONTINUE HANDLER FOR NOT FOUND
	        BEGIN
	        	SET end_of_fetch = 1;
		END;
		
		DECLARE EXIT HANDLER FOR SQLEXCEPTION, SQLWARNING
	        BEGIN
			CLOSE v_UpdateQueue;
			ROLLBACK TO SAVEPOINT TranWorkItem;
			SET v_dbStatus = 15;
			RESIGNAL;
		END;
		
		SET v_QueryStr = 'SELECT SystemDefinedName, DefaultValue, VariableType FROM VarMappingTable WHERE VariableScope != ''I'' AND DefaultValue IS NOT NULL AND LENGTH(DefaultValue)>0  AND ProcessDefId ='
		                 || CHAR(v_DBProcessDefId);
		PREPARE v_Cursor_stmt FROM v_QueryStr;
        	OPEN v_UpdateQueue;
		SET end_of_fetch = 0;
		FETCH v_UpdateQueue INTO v_SystemDefinedName, v_DefaultValue, v_VariableType;
		
		LABEL_UpdateQueue:
		WHILE  (end_of_fetch = 0) DO
		BEGIN
			BEGIN
				IF (v_SystemDefinedName <> N'PriorityLevel') THEN
				BEGIN
					IF (UPPER(LTRIM(RTRIM(v_UpdateFlag))) = 'Y') THEN
					BEGIN
						SET v_pos1 = POSSTR(v_UpdateColumnStr,v_SystemDefinedName);

						IF (v_pos1 > 0) THEN
						BEGIN
							GOTO LABEL_UpdateQueue;
						END;
						ELSE
						BEGIN
							SET v_UpdateColumnStr = v_UpdateColumnStr || ',' || RTRIM(v_SystemDefinedName);
/*							Bugzilla Bug 271 - Default value is checked against Date Type (8) variable */
							IF (v_VariableType = 10) THEN
								SET v_UpdateValueStr = v_UpdateValueStr || ',' || CHR(39) || RTRIM(v_DefaultValue) || CHR(39);
							ELSE
								 IF (v_VariableType = 8) THEN
								 	SET v_UpdateValueStr = v_UpdateValueStr || ',' || 'TIMESTAMP_FORMAT(' || CHR(39)|| RTRIM(v_DefaultValue) || CHR(39)|| ',' || CHR(39) || 'YYYY-MM-DD HH24:MI:SS' || CHR(39) || ')';
								 ELSE
								 	SET v_UpdateValueStr = v_UpdateValueStr || ',' ||  RTRIM(v_DefaultValue);
								 END IF;	
							END IF;
						END;
						END IF;
					END;
					ELSE
					BEGIN
						SET v_UpdateFlag = 'Y';
						SET v_UpdateColumnStr = RTRIM(v_SystemDefinedName);
/*						Bugzilla Bug 271 - Default value is checked against Date Type (8) variable */
						IF (v_VariableType = 10) THEN
							SET v_UpdateValueStr = CHR(39) || RTRIM(v_DefaultValue) || CHR(39);
						ELSE
							IF (v_VariableType = 8) THEN
							        SET v_UpdateValueStr = 'TIMESTAMP_FORMAT(' || CHR(39)|| RTRIM(v_DefaultValue) || CHR(39) || ',' || CHR(39) || 'YYYY-MM-DD HH24:MI:SS' || CHR(39) || ')';
						        ELSE
							 	  SET v_UpdateValueStr = RTRIM(v_DefaultValue);
							END IF;	
						END IF;
					END;
					END IF;
				END;
				ELSE
					 SET v_PriorityLevel = INTEGER(v_DefaultValue);
				END IF;
			END;
		END;
		FETCH v_UpdateQueue INTO v_SystemDefinedName, v_DefaultValue, v_VariableType;
		END WHILE;
		CLOSE v_UpdateQueue;
	END;

	BEGIN
		DECLARE CONTINUE HANDLER FOR NOT FOUND
	        BEGIN
	        	SET end_of_fetch = 1;
		END;

        	DECLARE EXIT HANDLER FOR SQLEXCEPTION, SQLWARNING
                BEGIN
                        CLOSE v_sysattrcur;
        		ROLLBACK TO SAVEPOINT TranWorkItem;
			SET v_dbStatus = 15;
			RESIGNAL;
		END;

		SET v_QueryStr = 'SELECT A.UserDefinedName, A.SystemDefinedName, A.VariableType FROM VarMappingTable A, RecordMappingTable B WHERE A.ProcessDefId=' || CHAR(v_DBProcessDefId) ||
			         'AND A.ProcessDefId = B.ProcessDefId AND A.VariableScope = ''M'' AND (RTRIM(UPPER(A.UserDefinedName)) = RTRIM(UPPER(B.REC1)) OR RTRIM(UPPER(A.UserDefinedName)) = RTRIM(UPPER(B.REC2)) OR RTRIM(UPPER(A.UserDefinedName)) = RTRIM(UPPER(B.REC3)) OR RTRIM(UPPER(A.UserDefinedName)) = RTRIM(UPPER(B.REC4)) OR UPPER(A.UserDefinedName) = UPPER(B.REC5))';
		
		PREPARE v_Cursor_stmt FROM v_QueryStr;
        	OPEN v_sysattrcur;
		SET end_of_fetch = 0;
		FETCH v_UpdateQueue INTO v_UserDefinedName, v_SystemDefinedName, v_VariableType;
		WHILE (end_of_fetch = 0) DO
		BEGIN
			IF UPPER(LTRIM(RTRIM(v_UserDefinedName))) = 'ITEMINDEX' THEN
			BEGIN
				SET v_Var_Rec_1 = VARCHAR(LTRIM(RTRIM(CHAR(v_NewFolderIndex))));

				IF v_UpdateFlag = 'Y'  THEN
				BEGIN
					 SET v_UpdateColumnStr = RTRIM(v_UpdateColumnStr) || ',' || v_SystemDefinedName ;
					 SET v_UpdateValueStr  = v_UpdateValueStr || ',' || CHR(39) || VARGRAPHIC(RTRIM(v_Var_Rec_1)) || CHR(39);
				END;
				ELSE
				BEGIN
					 SET v_UpdateFlag	= 'Y';
					 SET v_UpdateColumnStr = RTRIM(v_SystemDefinedName);
					 SET v_UpdateValueStr  = CHR(39) || VARGRAPHIC(RTRIM(v_Var_Rec_1)) || CHR(39);
				END;
				END IF;
	        		SET v_InsertExtColumnStr = v_InsertExtColumnStr || ',' || VARCHAR(v_UserDefinedName);
		        	SET v_InsertExtValueStr  = v_InsertExtValueStr || ',' ||  v_Var_Rec_1;
			END;

			ELSE
				IF (UPPER(LTRIM(RTRIM(v_UserDefinedName))) = 'ITEMTYPE') THEN
				BEGIN
						SET v_Var_Rec_1 = CHR(39) || 'F' || CHR(39) ;
                                                IF (v_UpdateFlag = 'Y') THEN
						BEGIN
							SET v_UpdateColumnStr = RTRIM(v_UpdateColumnStr) || ',' || v_SystemDefinedName ;
							SET v_UpdateValueStr = LTRIM(RTRIM(v_UpdateValueStr)) || ','|| VARGRAPHIC(RTRIM(v_Var_Rec_1));
        					END;
						ELSE
						BEGIN
							 SET v_UpdateFlag = 'Y' ;
							 SET v_UpdateColumnStr = RTRIM(v_SystemDefinedName);
							 SET v_UpdateValueStr  =  VARGRAPHIC(RTRIM(v_Var_Rec_1)) ;
                                                END;
						END IF;
					        SET v_InsertExtColumnStr = v_InsertExtColumnStr || ',' || VARCHAR(v_UserDefinedName);
						SET v_InsertExtValueStr  = v_InsertExtValueStr || ',' || v_Var_Rec_1;
        			END;
				ELSE
				BEGIN
						SET v_Var_Rec_1 = ' NULL ';
						SET v_InsertExtColumnStr = v_InsertExtColumnStr || ',' || VARCHAR(v_UserDefinedName);
						SET v_InsertExtValueStr  = v_InsertExtValueStr || ',' || v_Var_Rec_1;
				END;
				END IF;
			END IF;
		END;
		FETCH v_UpdateQueue INTO v_UserDefinedName, v_SystemDefinedName, v_VariableType;
		END WHILE;
		CLOSE v_sysattrcur;
	END;
	
	/* Changed By : Varun Bhansaly On 02/02/2007 */
	/*SELECT  ProcessTurnAroundTime  INTO  v_ProcessTurnAroundTime
	FROM ProcessDefTable A, ACTIVITYTABLE B
	WHERE 	A.ProcessDefId = B.ProcessDefId
	AND 	B.ProcessDefId = v_DBProcessDefId
	AND		ActivityId = v_ActivityId ; */ /* Bugzilla Bug 270 - For multiple introduction worksteps */
	/* AND	ActivityType   = 1; */
	
	
	/* Changed By : Varun Bhansaly On 02/02/2007 */
	Insert into ProcessInstanceTable (ProcessInstanceId , ProcessDefID , Createdby , CreatedDatetime ,
			ProcessinstanceState , CreatedByName,IntroducedByID, IntroducedBy,IntroductionDatetime,
			ExpectedProcessDelay, IntroducedAt)
	Values (v_ProcessInstanceId, v_DBProcessDefId, v_DBUserId, v_CurrDate,2, rtrim(ltrim(vargraphic(v_UserName))),
		v_DBUserId,rtrim(ltrim(vargraphic(v_UserName))),v_CurrDate, v_DBExpectedProcessDelay, v_ActivityName);
	
	 GET DIAGNOSTICS RCount = ROW_COUNT;
         SET v_DBStatus = RCount;
	IF (v_DBStatus = 0) THEN
	BEGIN
		ROLLBACK TO SAVEPOINT TranWorkItem;
		SET v_dbStatus = 15;
		OPEN returnCur;
		RETURN 0;
	END;
	END IF;

	Insert Into workdonetable
	(ProcessInstanceId,WorkItemId,ProcessName,ProcessVersion,ProcessDefID,LastProcessedBy,
	ProcessedBy,ActivityName,ActivityId,EntryDateTime,ParentWorkItemId,AssignmentType,
	CollectFlag,PriorityLevel,ValidTill,Q_StreamId,Q_QueueId,Q_UserId,AssignedUser,
	FilterValue, CreatedDateTime,WorkItemState,Statename,ExpectedWorkitemDelay,PreviousStage,
	LockedByName,LockStatus,LockedTime,Queuename,Queuetype,NotifyStatus)
	Values(v_ProcessInstanceId, 1, v_ProcessName, v_ProcessVersion, v_DBProcessDefId, v_DBUserId,
		rtrim(ltrim(vargraphic(v_UserName))), v_ActivityName, v_ActivityId, v_CurrDate, 0,'Y','N',v_PriorityLevel,v_ValidTill,
		v_StreamId,v_QueueId,NULL,NULL,NULL,v_CurrDate,6,'COMPLETED',NULL,v_ActivityName,NULL,'N',v_CurrDate,
		v_QueueName, 'I',NULL) ;
	
	GET DIAGNOSTICS RCount = ROW_COUNT;
	SET v_DBStatus = RCount;
	IF (v_DBStatus = 0) THEN
	BEGIN
		ROLLBACK TO SAVEPOINT TranWorkItem;
		SET v_dbStatus = 15;
		OPEN returnCur;
		RETURN 0 ;
	END;
	END IF;
	SET v_dbStatus = 0;
       	SET v_QueryStr ='Insert into QueueDataTable (ProcessInstanceID, WorkItemID, SaveStage, InstrumentStatus, CheckListCompleteFlag, '
   	                || VARCHAR(LTRIM(RTRIM(v_UpdateColumnStr))) ||') Values('||CHR(39)||  VARCHAR(v_ProcessInstanceId) ||CHR(39)
   	                ||', 1,'|| CHR(39) || VARCHAR(v_ActivityName) || CHR(39) || ','|| CHR(39) || 'N' || CHR(39) || ',' ||CHR(39)
   	                || 'N' || CHR(39) || ',' || VARCHAR(LTRIM(RTRIM(v_UpdateValueStr))) || ')';

   	Execute IMMEDIATE v_QueryStr;
	GET DIAGNOSTICS RCount = ROW_COUNT;
	SET v_DBStatus = RCOUNT;
 	IF (v_DBStatus = 0) THEN
	BEGIN
		ROLLBACK TO SAVEPOINT TranWorkItem;
		SET v_dbStatus = 15;
		OPEN returnCur;
		RETURN 0;
	END;
	END IF;
       	SET v_dbStatus = 0;
	IF (LENGTH(v_InsertExtColumnStr) > 0) AND (LENGTH(v_TableViewName) > 0 )THEN
	BEGIN
		SET v_InsertExtColumnStr = SUBSTR(v_InsertExtColumnStr,2);
		SET v_InsertExtValueStr  = SUBSTR(v_InsertExtValueStr, 2);
		SET execute_immediate_query = ' INSERT INTO ' || CHAR(v_TableViewName) || ' ( ' || v_InsertExtColumnStr || ' ) VALUES ( ' || v_InsertExtValueStr || ' ) ';
		EXECUTE IMMEDIATE execute_immediate_query;
		
		SET v_DBStatus = SQLCODE;
		IF v_DBStatus <> 0 THEN
		BEGIN
			ROLLBACK To SAVEPOINT TranWorkItem;
			SET v_dbStatus = 15;
			OPEN returnCur;
			RETURN 0;
		END;
		END IF;
	END;
	END IF;
        SET v_dbStatus = 0;
	/* Changed By Varun Bhansaly 0n 08/02/2007 for Bugzilla Bug 74 */
	/* Changed By Tirupati Srivastava 0n 05/04/2007 for Bugzilla Bug 529 */
	Insert Into WFMessageTable (messageId,message, status, ActionDateTime)
	values	(default,'<Message><ActionId>1</ActionId><UserId>' || VARCHAR(CHAR(v_DBUserId)) ||
		'</UserId><ProcessDefId>' || VARCHAR(CHAR(v_DBProcessDefId)) ||
		'</ProcessDefId><ActivityId>0</ActivityId><QueueId>0</QueueId><UserName>' ||
		rtrim(ltrim(vargraphic(COALESCE(v_UserName,'')))) || '</UserName><ActivityName>' || COALESCE(v_ActivityName,'') ||
		'</ActivityName><TotalWiCount>1</TotalWiCount><TotalDuration>0</TotalDuration><ActionDateTime>'
		|| VARCHAR_FORMAT(CURRENT TIMESTAMP, 'YYYY-MM-DD HH24:MI:SS') ||
		'</ActionDateTime><EngineName></EngineName><ProcessInstance>' || v_ProcessInstanceId ||
		'</ProcessInstance><FiledId>' || COALESCE(CHAR(v_QueueId),'') ||
		'</FiledId><WorkitemId>1</WorkitemId><TotalPrTime>0</TotalPrTime><DelayTime>0</DelayTime><WKInDelay>0</WKInDelay><ReportType>D</ReportType><Flag>0</Flag></Message>', N'N', CURRENT TIMESTAMP);
     	
	/* Changed By Varun Bhansaly 0n 08/02/2007 for Bugzilla Bug 74 */
	/* Changed By Tirupati Srivastava 0n 05/04/2007 for Bugzilla Bug 529 */
	Insert Into WFMessageTable (messageId,message, status, ActionDateTime)
	values	(default,'<Message><ActionId>1</ActionId><UserId>' || VARCHAR(CHAR(v_DBUserId)) ||
				'</UserId><ProcessDefId>' || VARCHAR(CHAR(v_DBProcessDefId)) ||
				'</ProcessDefId><ActivityId>0</ActivityId><QueueId>'|| COALESCE(CHAR(v_QueueId),'') ||
				'</QueueId><UserName>' || rtrim(ltrim(vargraphic(COALESCE(v_UserName,'')))) ||
				'</UserName><ActivityName>' || COALESCE(v_ActivityName,'') ||
				'</ActivityName><TotalWiCount>1</TotalWiCount><TotalDuration>0</TotalDuration><ActionDateTime>'
				|| VARCHAR_FORMAT(CURRENT TIMESTAMP, 'YYYY-MM-DD HH24:MI:SS') ||
				'</ActionDateTime><EngineName></EngineName><FiledId>' || COALESCE(CHAR(v_QueueId),'') ||
        			'</FiledId><FieldName>NULL</FieldName><WorkitemId>1</WorkitemId><TotalPrTime>0</TotalPrTime><DelayTime>0</DelayTime><WKInDelay>0</WKInDelay><ReportType>D</ReportType><Flag>2</Flag></Message>',N'N', CURRENT TIMESTAMP);

	WHILE (LENGTH(v_AttributeRouteStr) > 0) DO
	BEGIN
		SET v_pos1 		= POSSTR( v_AttributeRouteStr,CHR(21));
		SET v_AttributeName     = CHAR(RTRIM(SUBSTR(v_AttributeRouteStr, 1, v_pos1-1)));
		SET v_AttributeRouteStr = REPLACE(v_AttributeRouteStr,SUBSTR(v_AttributeRouteStr, 1, v_pos1), '');
		SET v_pos1 		= POSSTR(v_AttributeRouteStr,CHR(25));
		SET v_AttributeValue    = CHAR(RTRIM(SUBSTR(v_AttributeRouteStr, 1, v_pos1-1)));
		SET v_AttributeRouteStr = REPLACE(v_AttributeRouteStr,SUBSTR(v_AttributeRouteStr, 1, v_pos1), '');

		/* Changed By Varun Bhansaly 0n 08/02/2007 for Bugzilla Bug 74 */
		/* Changed By Tirupati Srivastava 0n 05/04/2007 for Bugzilla Bug 529 */
		Insert Into WFMessageTable (messageId,message, status, ActionDateTime)
		values	( default,'<Message><ActionId>16</ActionId><UserId>' || CHAR(v_DBUserId) ||
					'</UserId><ProcessDefId>' || CHAR(v_DBProcessDefId) ||
					'</ProcessDefId><ActivityId>' || CHAR(v_ActivityId) ||
					'</ActivityId><QueueId>0</QueueId><UserName>' || rtrim(ltrim(VARGRAPHIC(COALESCE(v_UserName,'')))) ||
					'</UserName><ActivityName>' || COALESCE(v_ActivityName,'') ||
					'</ActivityName><TotalWiCount>1</TotalWiCount><TotalDuration>0</TotalDuration><ActionDateTime>'
					|| VARCHAR_FORMAT(CURRENT TIMESTAMP, 'YYYY-MM-DD HH24:MI:SS') ||
					'</ActionDateTime><EngineName></EngineName><ProcessInstance>' || v_ProcessInstanceId ||
					'</ProcessInstance><FiledId>0</FiledId><FieldName><Attributes><Attribute><Name>'  || COALESCE(v_AttributeName,'') ||
					'</Name><Value>' || COALESCE(v_AttributeValue,'') ||
					'</Value></Attribute></Attributes></FieldName><WorkitemId>1</WorkitemId><TotalPrTime>0</TotalPrTime><DelayTime>0</DelayTime><WKInDelay>0</WKInDelay><ReportType>D</ReportType><Flag>0</Flag></Message>',N'N', CURRENT TIMESTAMP);
	END;
	END WHILE;


	/* Changed By Varun Bhansaly 0n 08/02/2007 for Bugzilla Bug 74 */
	/* Changed By Tirupati Srivastava 0n 05/04/2007 for Bugzilla Bug 529 */
	Insert Into WFMessageTable (messageId,message, status, ActionDateTime)
	values(default,'<Message><ActionId>2</ActionId><UserId>' || CHAR(v_DBUserId) ||
		'</UserId><ProcessDefId>' || CHAR(v_DBProcessDefId) ||
		'</ProcessDefId><ActivityId>' || CHAR(v_ActivityId) ||
		'</ActivityId><QueueId>0</QueueId><UserName>' || rtrim(ltrim(vargraphic(COALESCE(v_UserName,'')))) ||
		'</UserName><ActivityName>' || COALESCE(v_ActivityName,'') ||
		'</ActivityName><TotalWiCount>1</TotalWiCount><TotalDuration>0</TotalDuration><ActionDateTime>'
		|| VARCHAR_FORMAT(CURRENT TIMESTAMP, 'YYYY-MM-DD HH24:MI:SS') ||
		'</ActionDateTime><EngineName></EngineName><ProcessInstance>' || v_ProcessInstanceId ||
		'</ProcessInstance><FiledId>' || COALESCE(CHAR(v_QueueId),'') ||
		'</FiledId><WorkitemId>1</WorkitemId><TotalPrTime>0</TotalPrTime><DelayTime>0</DelayTime><WKInDelay>0</WKInDelay><ReportType>D</ReportType><Flag>0</Flag></Message>',N'N', CURRENT TIMESTAMP);

	BEGIN
		DECLARE CONTINUE HANDLER FOR NOT FOUND
	        BEGIN
	        	SET v_DBTotalDuration = 0;
			SET v_DBTotalPrTime = 0;
                        RESIGNAL;
        	END;		
		
		SELECT (CURRENT TIMESTAMP - A.createdDateTime),
			 (CURRENT TIMESTAMP - A.lockedTime)
			INTO  v_DBTotalDuration, v_DBTotalPrTime
		FROM WorkDoneTable A
		WHERE A.ProcessInstanceId = v_ProcessInstanceId;
	END;

		/* Changed By Varun Bhansaly 0n 08/02/2007 for Bugzilla Bug 74 */
		/* Changed By Tirupati Srivastava 0n 05/04/2007 for Bugzilla Bug 529 */
		Insert Into WFMessageTable (messageId,message, status, ActionDateTime)
		values(default,'<Message><ActionId>2</ActionId><UserId>' || CHAR(v_DBUserId) ||
			'</UserId><ProcessDefId>' || CHAR(v_DBProcessDefId) ||
			'</ProcessDefId><ActivityId>' || CHAR(v_ActivityId) ||
			'</ActivityId><QueueId>'|| COALESCE(CHAR(v_QueueId),'') ||
			'</QueueId><UserName>' || rtrim(ltrim(vargraphic(COALESCE(v_UserName,'')))) ||
			'</UserName><ActivityName>' || COALESCE(v_ActivityName,'') ||
			'</ActivityName><TotalWiCount>1</TotalWiCount><TotalDuration>' ||
			CHAR(v_DBTotalDuration) ||'</TotalDuration><ActionDateTime>' ||
			VARCHAR_FORMAT(CURRENT TIMESTAMP, 'YYYY-MM-DD HH24:MI:SS') || '</ActionDateTime><EngineName></EngineName><FiledId>' ||
			COALESCE(CHAR(v_QueueId),'') ||
			'</FiledId><FieldName>NULL</FieldName><WorkitemId>1</WorkitemId><TotalPrTime>' ||
			CHAR(v_DBTotalPrTime) ||
			'</TotalPrTime><DelayTime>0</DelayTime><WKInDelay>0</WKInDelay><ReportType>D</ReportType><Flag>2</Flag></Message>',N'N', CURRENT TIMESTAMP);
	IF (v_ValidationReqd1 IS NOT NULL) THEN
	BEGIN
	        SET execute_immediate_query = 'INSERT INTO ' || CHAR(v_TempTableName) || ' ( ' || v_TempColumnName || ' ) ' ||
			' VALUES ( ' || v_TempValue || ' ) ';
		EXECUTE IMMEDIATE execute_immediate_query;
		SET v_DBStatus = SQLCODE;

		IF (v_DBStatus <> 0) THEN
		BEGIN
			ROLLBACK TO SAVEPOINT TranWorkItem;
			SET v_dbStatus = 15;
			OPEN returnCur;
			RETURN 0;
		END;
		END IF;
		SET v_dbStatus = 0;
	END;
	
	END IF;
        SET v_dbStatus = 0;
	COMMIT;
	SET DBFolderName 	= v_DBFolderName;
	SET CurrDate		= v_CurrDate;

	/*      Bugzilla Bug 265 - FolderIndex returned */
	SET v_FolderIndex = v_NewFolderIndex;
	OPEN returnCur;
	RETURN 0;

END P1

