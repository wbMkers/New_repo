/*__________________________________________________________________________________________________
			NEWGEN SOFTWARE TECHNOLOGIES LIMITED
______________________________________________________________________________________________
	Group						: Phoenix
	Product / Project			: Omniflow 7.1
	Module						: WorkFlow Server
	File Name					: WFUploadWorkItem.sql
	Author						: Varun Bhansaly
	Date written (DD/MM/YYYY)	: 13/12/2007
	Description					: This stored procedure is called from WMMiscellaneous.java
______________________________________________________________________________________________
				CHANGE HISTORY
______________________________________________________________________________________________
Date			Change By			Change Description (Bug No. (If Any))
25/02/2008		Varun Bhansaly		1. Bugzilla Bug Id 3129 (Support for multiple document types)
									2. PDBDocument has column comment instead of commnt
05/03/2008		Varun Bhansaly		Coded backward compatibility for Bugzilla Id 3129
07/07/2009		Saurabh Kamal		WFS_8.0_010 , If else for InitiateAlso = 'N'
30/08/2010		Saurabh Kamal		OF 9.0 support on Postgres DB
28/01/2011		Abhishek Gupta		Change for Error in document support.
03/02/2011		Saurabh Kamal		Unable to set external table variable.
09/03/2011		Saurabh Kamal		Error while uploading document with AppType[Incorrect STRPOS syntax].
_____________________________________________________________________________________________
____________________________________________________________________________________________*/
CREATE OR REPLACE FUNCTION WFUploadWorkItem(INTEGER, VARCHAR, INTEGER, INTEGER, VARCHAR, VARCHAR, INTEGER, VARCHAR, VARCHAR, VARCHAR, VARCHAR, VARCHAR, VARCHAR, VARCHAR, VARCHAR, VARCHAR, VARCHAR, VARCHAR, VARCHAR, VARCHAR, VARCHAR, VARCHAR, INTEGER, VARCHAR, TIMESTAMPTZ, VARCHAR, VARCHAR, VARCHAR, VARCHAR, VARCHAR, VARCHAR, VARCHAR, INTEGER, INTEGER, VARCHAR, INTEGER, INTEGER, VARCHAR, INTEGER) RETURNS REFCURSOR AS '
	DECLARE
		v_DBUserId					ALIAS FOR $1;  
		v_ProcessInstanceId			ALIAS FOR $2;  
		DBProcessDefId				ALIAS FOR $3;  
		v_ActivityId				ALIAS FOR $4;  
		v_ActivityName				ALIAS FOR $5;   
		v_ValidationReqd			ALIAS FOR $6;  
		v_DBDataDefinitionIndex		ALIAS FOR $7;  
		DBDDIDataList1				ALIAS FOR $8;  
		DBDDIDataList2				ALIAS FOR $9;  
		DBDDIDataList3				ALIAS FOR $10;  
		DBDDIDataList4				ALIAS FOR $11;  
		DBDDIDataList5				ALIAS FOR $12;  
		DBDDIDataList6				ALIAS FOR $13;  
		DBDDIDataList7				ALIAS FOR $14;  
		DBDDIDataList8				ALIAS FOR $15;  
		DBDDIDataList9				ALIAS FOR $16;  
		DBDDIDataList10				ALIAS FOR $17;  
		DBDocumentList1				ALIAS FOR $18; 
		DBDocumentList2				ALIAS FOR $19; 
		DBDocumentList3				ALIAS FOR $20; 
		DBDocumentList4				ALIAS FOR $21; 
		DBDocumentList5				ALIAS FOR $22; 
		DBPriorityLevel				ALIAS FOR $23; 		
		DBGenerateLog				ALIAS FOR $24;
		DBExpectedProcessDelay		ALIAS FOR $25;
		DBInitiateAlso				ALIAS FOR $26;
		v_DBQDTColumnList			ALIAS FOR $27;
		v_DBQDTValueList			ALIAS FOR $28;
		v_DBEXTColumnList			ALIAS FOR $29;
		v_DBEXTValueList			ALIAS FOR $30;
		v_DBRouteLogList			ALIAS FOR $31;
		v_ValidateQuery				ALIAS FOR $32;
		v_MainGroupId				ALIAS FOR $33;
		v_DBParentFolderId			ALIAS FOR $34;
		v_ProcessName				ALIAS FOR $35;
		v_ProcessVersion			ALIAS FOR $36;
		v_QueueId					ALIAS FOR $37;
		v_QueueName					ALIAS FOR $38;
		v_StreamId					ALIAS FOR $39;

--		v_DBParentFolderId			INTEGER; 
		v_DBFolderName				VARCHAR(255); 
		v_DBAccessType				VARCHAR(1); 
		v_DBImageVolumeIndex		INTEGER; 
		v_DBFolderType				VARCHAR(1); 
		v_DBVersionFlag				VARCHAR(1); 
		v_DBComment					VARCHAR(255); 
--		v_DBOwner					INTEGER; 
		v_DBExpiryDateTime			VARCHAR(64); 
		v_NameLength				INTEGER; 
		v_LimitCount				INTEGER; 
		v_DBEnableFTS				VARCHAR(1); 
		v_DuplicateNameFlag			VARCHAR(1); 
--		v_DBDataDefinitionIndex		INTEGER; 
		v_DBUserRights      		VARCHAR(16); 
--		v_UpdateList				VARCHAR(255); 
		v_DBStatus					INTEGER; 
--		v_DBUserId        			INTEGER; 
		v_NewFolderIndex			INT8; 
--		v_MainGroupId				INTEGER; 
		v_ExpiryDateTime			TIMESTAMP; 
		v_EffectiveLockByUser		INTEGER; 
		v_LockMessage				VARCHAR(255); 
		v_LockedObject				INTEGER; 
		v_FolLock					VARCHAR(1); 
		v_FolLockByUser				VARCHAR(255); 
		v_Hierarchy					VARCHAR(4000); 
		v_ProcessState				VARCHAR(10); 
/*		v_RegPrefix					VARCHAR(20); 
		v_RegSuffix					VARCHAR(20); 
		v_RegStartingNo				INTEGER; 
		v_RegSeqLength				INTEGER; */
		v_TableViewName				VARCHAR(255); 
--		v_DataClassFlag				VARCHAR(1); 
		v_Length					INTEGER; 
--		v_ProcessInstanceId			VARCHAR(64); 
		v_ColumnList				VARCHAR(8000); 
		v_ValueList					VARCHAR(8000); 
		v_WhileCounter				INTEGER; 
		v_DDTTableName				VARCHAR(255); 
/*		v_QueueName					VARCHAR(255); 
		v_QueueId					INTEGER; 
		v_StreamId					INTEGER; 
		v_ActivityId				INTEGER; 
		v_ActivityName				VARCHAR(32);*/ 
		v_UserName					VARCHAR(256);                
--		v_UpdateStr					VARCHAR(8000); 
		v_UpdateFlag				VARCHAR(1); 
--		v_UpdateDFlag				VARCHAR(1); 
		v_SystemDefinedName			VARCHAR(64); 
		v_VariableType				INTEGER; 
--		v_DefaultValue				VARCHAR(255); 
		v_DBDDIDataList				VARCHAR(8000); 
		v_ParseCount				INTEGER; 
		v_pos1						INTEGER; 
		v_TempStr					VARCHAR(8000); 
		v_TempFieldName				VARCHAR(100); 
		v_TempFieldValue			VARCHAR(4000); 
		v_TempFieldId				INTEGER; 
		v_TempDataFieldType			VARCHAR(1); 
		v_DBDocumentList			VARCHAR(8000); 
		v_DocumentName				VARCHAR(255); 
		v_ISIndexStr				VARCHAR(64); 
		v_ImageIndex 				INTEGER; 
		v_VolumeIndex 				INTEGER; 
		v_CurrDate 					TIMESTAMP; 
		v_NextOrder 				INTEGER; 
		v_NewDocumentIndex			INTEGER; 
		v_NoOfPage 					INTEGER; 
		v_DocumentSize 				INTEGER; 
		v_DocumentType				VARCHAR(1);
		v_AppType					VARCHAR(50);
		v_Comment					VARCHAR(50);	--WFS_8.0_013
--		v_AttributeName				VARCHAR(64); 
--		v_AttributeType				VARCHAR(1); 
--		v_AttributeValue			VARCHAR(4000); 
/*		v_TempTableName				VARCHAR(255); 
		v_TempColumnName			VARCHAR(255); 
		v_TempColumnType			VARCHAR(10); 
		v_TempValue					VARCHAR(500); */
--		v_DBAttributeList			VARCHAR(8000); 
		v_UserDefinedName			VARCHAR(50); 
		v_ExtObjID					INTEGER; 
		v_Rec1 						VARCHAR(255); 
		v_Var_Rec_1 				VARCHAR(255); 
		v_Rec2						VARCHAR(255); 
		v_Var_Rec_2					VARCHAR(255); 
		v_Rec3						VARCHAR(255); 
		v_Var_Rec_3					VARCHAR(255); 
		v_Rec4						VARCHAR(255); 
		v_Var_Rec_4					VARCHAR(255); 
		v_Rec5						VARCHAR(255); 
		v_Var_Rec_5 				VARCHAR(255); 
		v_TempVar					VARCHAR(4000); 
--		v_AttributeNameStr			VARCHAR(8000); 
		v_UpdateColumnStr			VARCHAR(8000); 
		v_UpdateValueStr			VARCHAR(8000); 
		v_QueryStr					VARCHAR(8000); 
		v_Pattern					VARCHAR(400); 
		v_atempstr					VARCHAR(8000); 
		v_atempstrdummy				VARCHAR(8000); 
		v_Posi1						INTEGER; 
		v_Posi2						INTEGER; 
		v_yesValue					VARCHAR(4000); 
		v_InsertExtColumnStr		VARCHAR(1024); 
		v_InsertExtValueStr			VARCHAR(1024); 
		v_TempExtObjID				INTEGER; 
		v_Temp						INTEGER; 
		v_DBProcessDefIdStr 		VARCHAR(10); 
		v_ActivityIdStr 			VARCHAR(10); 
		v_ValidTill					TIMESTAMP; 
		v_AttributeRouteStr			VARCHAR(8000); 
/*		v_ProcessName				VARCHAR(64); 
		v_ProcessVersion 			INTEGER; */
		v_PriorityLevel				VARCHAR(5); 
		v_DBTotalDuration			NUMERIC; 
		v_DBTotalPrTime				NUMERIC; 
		v_retval					INTEGER; 
		v_count						INTEGER; 
		v_rowCount					INTEGER; 
		v_ValidationReqd1			VARCHAR(1000); 
		v_size						INTEGER; 
		v_MessageBuffer				TEXT;
		v_FieldName					VARCHAR(100);
		v_Output					VARCHAR(255);
		v_Status 					INTEGER;
		v_useFulDataStrStatus		INTEGER;
		v_PDBFolderRecord			RECORD;
		ResultSet					REFCURSOR;
		v_attrcur					REFCURSOR; 
		v_sysattrcur				REFCURSOR; 
		v_UpdateQueue				REFCURSOR; 
	BEGIN  
		/* Initialize variables */ 
		v_FolLock		:= ''N''; 
		v_FolLockByUser	:= NULL; 
		v_DBUserRights	:= ''''; 
		v_DBStatus		:= -1; 
		v_UpdateFlag	:= ''N''; 
		v_TempStr		:= ''''; 

		/* Check Session Validity of User */ 
/*		SELECT	INTO v_DBUserId, v_userName, v_MainGroupId userIndex, userName, WFSessionView.MainGroupId 
		FROM	WFSessionView, WFUserView 
		WHERE	UserId = UserIndex AND SessionID = DBConnectId;

		IF(NOT FOUND) THEN 
			v_Status := 11; 
			OPEN ResultSet FOR SELECT v_Status AS MainCode;  
			RETURN ResultSet; 
		END IF; */
		
		v_ValidationReqd1 := v_ValidationReqd; 

/*		IF(DBInitiateFromActivityId > 0) THEN  
			SELECT INTO v_ActivityId, v_ActivityName 
						ActivityId, ActivityName 
			FROM ActivityTable 
			WHERE ProcessDefID = DBProcessDefId 
			AND	ActivityType = 1 
			AND	ActivityId	= DBInitiateFromActivityId; 

			IF(NOT FOUND) THEN
				v_Status := 603;
				OPEN ResultSet FOR SELECT v_Status AS MainCode;  
				RETURN ResultSet; 
			END IF;
		ELSIF(DBInitiateFromActivityName IS NOT NULL AND LENGTH(RTRIM(DBInitiateFromActivityName)) > 0) THEN  
			SELECT INTO v_ActivityId, v_ActivityName 
						ActivityId, ActivityName 
			FROM	ActivityTable 
			WHERE	ProcessDefID = DBProcessDefId 
			AND	ActivityType = 1 
			AND	UPPER(ActivityName) = UPPER(RTRIM(DBInitiateFromActivityName)); 

			IF(NOT FOUND) THEN
				v_Status := 603;
				OPEN ResultSet FOR SELECT v_Status AS MainCode;  
				RETURN ResultSet; 
			END IF;
		ELSE 
			SELECT INTO v_ActivityId, v_ActivityName  
						ActivityId, ActivityName 
			FROM ActivityTable 
			WHERE ProcessDefID = DBProcessDefId 
			AND	ActivityType = 1 
			AND	PrimaryActivity = ''Y'';		/* Default Introduction workstep */ 
/*		END IF; */

		SELECT INTO v_TableViewName TableName  
		FROM 	ExtDBConfTable 
		WHERE 	ProcessDefId = DBProcessDefId
		AND ExtObjId = 1; 

		IF(NOT FOUND) THEN
			v_TableViewName := NULL; 
		END IF; 

		v_UpdateColumnStr 	:= ''''; 
		v_UpdateValueStr 	:= ''''; 
		v_InsertExtColumnStr:= '''';
		v_InsertExtValueStr := '''';		
		
/*		IF(DBDataDefinitionName IS NOT NULL AND LENGTH(BTRIM(DBDataDefinitionName)) > 0)THEN  
			SELECT 	INTO v_DBDataDefinitionIndex DataDefIndex  
			FROM 	PDBDataDefinition 
			WHERE 	DataDefName = DBDataDefinitionName 
			AND 	GroupId = v_MainGroupId; 

			IF(NOT FOUND) THEN
				v_Status := PRTRaiseError(''PRT_ERR_DDI_Not_Exist'');
				OPEN ResultSet FOR SELECT v_Status AS MainCode;  
				RETURN ResultSet;
			END IF;
			v_DDTTableName := ''DDT_'' || v_DBDataDefinitionIndex; 
		ELSE 
			 v_DBDataDefinitionIndex  := 0; 
		END IF; */

		IF(v_DBDataDefinitionIndex <> 0) THEN  
			 v_WhileCounter := 1; 
			 v_ColumnList   := ''''; 
			 v_ValueList    := ''''; 
	 
			WHILE(v_WhileCounter <= 10) LOOP  
				IF(v_WhileCounter = 1) THEN  
					v_DBDDIDataList := DBDDIDataList1;  
				ELSIF(v_WhileCounter = 2) THEN 
					v_DBDDIDataList := DBDDIDataList2; 
				ELSIF(v_WhileCounter = 3) THEN 
					v_DBDDIDataList := DBDDIDataList3; 
				ELSIF(v_WhileCounter = 4) THEN 
					v_DBDDIDataList := DBDDIDataList4; 
				ELSIF(v_WhileCounter = 5) THEN 
					v_DBDDIDataList := DBDDIDataList5; 
				ELSIF(v_WhileCounter = 6) THEN 
					v_DBDDIDataList := DBDDIDataList6; 
				ELSIF(v_WhileCounter = 7) THEN 
					v_DBDDIDataList := DBDDIDataList7;  
				ELSIF(v_WhileCounter = 8) THEN 
					v_DBDDIDataList := DBDDIDataList8;
				ELSIF(v_WhileCounter = 9) THEN 
					v_DBDDIDataList := DBDDIDataList9; 
				ELSIF(v_WhileCounter = 10) THEN 
					v_DBDDIDataList := DBDDIDataList10; 
				END IF; 
				v_ParseCount := 1; 
				v_TempStr := ''''; 

				WHILE(LENGTH(v_DBDDIDataList) > 0) LOOP  
					IF(v_ParseCount = 1) THEN 
						v_pos1 := STRPOS(v_DBDDIDataList, CHR(21)); 
						IF(v_pos1 = 0) THEN  
							v_TempStr := SUBSTR(v_DBDDIDataList, 1); 
							v_DBDDIDataList := NULL; 
							EXIT;  
						ELSE 
							 v_TempFieldName := RTRIM(v_TempStr) || SUBSTR(v_DBDDIDataList, 1, v_pos1 - 1); 
							 v_DBDDIDataList := SUBSTR(v_DBDDIDataList, v_pos1 + 1); 
							 v_ParseCount := 2; 
							 v_TempStr := ''''; 
						END IF; 
					END IF; 
					IF(v_ParseCount = 2) THEN 
						v_pos1 := STRPOS(v_DBDDIDataList, CHR(25)); 
						IF(v_pos1 = 0) THEN 
							 v_TempStr := SUBSTR(v_DBDDIDataList, 1); 
							 v_DBDDIDataList := NULL; 
							 EXIT; 
						ELSE 
							v_TempFieldValue := RTRIM(v_TempStr) || SUBSTR(v_DBDDIDataList, 1, v_pos1 - 1); 
							v_DBDDIDataList := SUBSTR(v_DBDDIDataList,v_pos1 + 1); 
							v_ParseCount := 1; 
							v_TempStr := ''''; 
							SELECT INTO v_TempFieldId,v_TempDataFieldType A.DataFieldIndex, DataFieldType 
							FROM PDBGlobalIndex A, PDBDataFieldsTable B 
							WHERE A.DataFieldIndex = B.DataFieldIndex 
							AND   B.DataDefIndex = v_DBDataDefinitionIndex 
							AND   A.DataFieldName = v_TempFieldName; 
							IF(NOT FOUND) THEN
								v_Status := 15; 
								OPEN ResultSet FOR SELECT v_Status AS MainCode;  
								RETURN ResultSet;
							ELSE
								GET DIAGNOSTICS v_rowCount = ROW_COUNT;
							END IF;

							IF(v_rowCount > 0) THEN  
								v_ColumnList :=  RTRIM(v_ColumnList) || '', Field_'' || v_TempFieldId; 
								v_size := LENGTH(LTRIM(RTRIM(v_TempFieldValue))); 
								IF(LTRIM(RTRIM(v_TempFieldValue)) = CHR(181) OR v_size = 0)THEN  
									 v_TempFieldValue := ''NULL''; 
								END IF; 
								IF(v_TempFieldValue = ''NULL'') THEN 
									IF(v_TempDataFieldType = ''B'') THEN 
										v_TempFieldValue := ''0''; 
										v_ValueList := RTRIM(v_ValueList) || '','' || LTRIM(RTRIM(v_TempFieldValue)); 
									END IF; 
								ELSIF(v_TempDataFieldType = ''S'') THEN  
										v_QueryStr:= CHR(39) || CHR(39); 
										v_TempFieldValue := REPLACE(v_TempFieldValue, CHR(39), v_QueryStr);  
										v_ValueList := RTRIM(v_ValueList) || '','' || CHR(39) || RTRIM(v_TempFieldValue) || CHR(39); 
								ELSIF(v_TempDataFieldType = ''D'')THEN 
									v_ValueList := RTRIM(v_ValueList) || '',TO_DATE('' || CHR(39) || RTRIM(v_TempFieldValue) || CHR(39) || '','' || Chr(39) || ''YYYY-MM-DD'' || CHR(39) ||'')'';  
								ELSIF(v_TempDataFieldType = ''I'' OR v_TempDataFieldType = ''L'' OR v_TempDataFieldType	= ''F'' OR v_TempDataFieldType = ''B'' OR 
										v_TempDataFieldType	= ''X'') THEN 
									v_ValueList := RTRIM(v_ValueList) || '','' || LTRIM(RTRIM(v_TempFieldValue)); 
								END IF; 
							END IF; 
							v_DBStatus := CheckData(''F'', v_NewFolderIndex, RTRIM(upper(v_DDTTableName)), RTRIM(v_TempFieldId), RTRIM(upper(v_TempDataFieldType)), v_TempFieldValue); 
							IF(v_DBStatus <> 0) THEN 
								v_Status := v_DBStatus ; 
								OPEN ResultSet FOR SELECT v_Status AS MainCode;  
								RETURN ResultSet;
							END IF; 
						END IF; 
					END IF; 
				END LOOP; 
				v_WhileCounter := v_WhileCounter + 1; 
			END LOOP; 
		END IF; 

		v_DBAccessType		:= COALESCE(v_DBAccessType, ''S''); 
		v_DBFolderType		:= COALESCE(v_DBFolderType, ''G''); 
		v_DBComment			:= COALESCE(v_DBComment, ''Not Defined''); 
		v_DuplicateNameFlag	:= COALESCE(v_DuplicateNameFlag, ''Y''); 
		v_CurrDate := CURRENT_TIMESTAMP; 

		IF(v_DBExpiryDateTime IS NULL OR LENGTH(v_DBExpiryDateTime) = 0)THEN  
			 v_ExpiryDateTime := CAST(''31 Dec 2099'' AS DATE); 
		ELSE 
			 v_ExpiryDateTime :=CAST(v_DBExpiryDateTime AS DATE); 
		END IF; 

/*		SELECT INTO v_DBParentFolderId WorkFlowFolderId 
		FROM   RouteFolderDefTable 
		WHERE  ProcessDefId = DBProcessDefId; 

		IF(NOT FOUND) THEN
			v_Status := PRTRaiseError(''PRT_ERR_Invalid_Parameter'');
			OPEN ResultSet FOR SELECT v_Status AS MainCode;  
			RETURN ResultSet;
		END IF;
		
		SELECT 	INTO v_QueueName, v_QueueId, v_StreamId 
					QUEUEDEFTABLE.QUEUENAME, QUEUEDEFTABLE.QUEUEID, QUEUESTREAMTABLE.STREAMID 
		FROM 	QUEUESTREAMTABLE, QUserGroupView , ACTIVITYTABLE , QUEUEDEFTABLE 
		WHERE 	ACTIVITYTABLE.PROCESSDEFID 	= DBProcessDefId 
		AND 	ACTIVITYTABLE.ACTIVITYTYPE 	= 1 
		AND 	ACTIVITYTABLE.PROCESSDEFID 	= QUEUESTREAMTABLE.PROCESSDEFID 
		AND 	ACTIVITYTABLE.ACTIVITYID	= QUEUESTREAMTABLE.ACTIVITYID 
		AND 	ACTIVITYTABLE.ACTIVITYID	= v_ActivityId 
		AND 	QUEUESTREAMTABLE.QUEUEID 	= QUserGroupView.QUEUEID 
		AND 	QUEUEDEFTABLE.QUEUEID 		= QUserGroupView.QUEUEID 
		AND 	QUEUETYPE 			= ''I'' 
		AND 	USERID 				= v_DBUserId
		LIMIT 1;

		IF(NOT FOUND) THEN
			v_Status := 300;
			OPEN ResultSet FOR SELECT v_Status AS MainCode;  
			RETURN ResultSet;
		END IF;

		UPDATE ProcessDefTable SET RegStartingNo = RegStartingNo + 1 WHERE ProcessDefID = DBProcessDefId; 

		SELECT INTO v_ProcessState,v_RegPrefix,v_RegSuffix,v_RegStartingNo,v_RegSeqLength,v_ProcessName,v_ProcessVersion 
					ProcessState, RegPrefix, RegSuffix, RegStartingNo, RegSeqLength, ProcessName, VersionNo  			
		FROM	ProcessDefTable 
		WHERE	ProcessDefID = DBProcessDefId; 

		IF(NOT FOUND) THEN
			v_Status := 15;
			OPEN ResultSet FOR SELECT v_Status AS MainCode;  
			RETURN ResultSet;
		END IF;

		IF(UPPER(v_ProcessState) <> UPPER(''Enabled'')) THEN 
			v_Status := 2;
			OPEN ResultSet FOR SELECT v_Status AS MainCode;  
			RETURN ResultSet;
		END IF; 

		v_RegStartingNo	:= v_RegStartingNo; 
		v_RegPrefix		:= v_RegPrefix || ''-''; 
		v_RegSuffix		:= ''-'' || v_RegSuffix ; 

		IF(LENGTH(v_RegStartingNo) > (v_RegSeqLength - LENGTH(v_RegPrefix) - LENGTH(v_RegSuffix))) THEN  
			v_Status := 19;
			OPEN ResultSet FOR SELECT v_Status AS MainCode;  
			RETURN ResultSet;
		END IF; 

		v_Length			:= v_RegSeqLength - LENGTH(v_RegPrefix) - LENGTH(v_RegSuffix); 
		v_ProcessInstanceId	:= RPAD(''0'', v_Length, ''0''); 
		v_ProcessInstanceId	:= v_RegPrefix || SUBSTR(v_ProcessInstanceId, 1, LENGTH(v_ProcessInstanceId) - LENGTH(v_RegStartingNo)) || v_RegStartingNo || v_RegSuffix; */
		v_DBFolderName		:= v_ProcessInstanceId;  

		SELECT INTO v_PDBFolderRecord
					FolderLock, FinalizedFlag, Location, FolderType, COALESCE(v_DBImageVolumeIndex, ImageVolumeIndex) AS ImageVolumeIndex, Owner, AccessType, 
					ACLMoreFlag, ACL, EnableVersion, EnableFTS, LockMessage, LockByUser, FolderLevel, MainGroupId 
		FROM PDBFolder 
		WHERE PDBFolder.FolderIndex = v_DBParentFolderId 
		AND (v_MainGroupId = 0 OR MainGroupId = v_MainGroupId); 
		IF(NOT FOUND) THEN 
			v_Status := PRTRaiseError(''PRT_ERR_Folder_Not_Exist'');
			OPEN ResultSet FOR SELECT v_Status AS MainCode;  
			RETURN ResultSet;
		ELSIF(NOT(v_PDBFolderRecord.Location IN (''R'', ''G'', ''A'') AND v_DBFolderType IN (''G'', ''A''))) THEN 
			v_Status := PRTRaiseError(''PRT_ERR_Cannot_AddFolder'');
			OPEN ResultSet FOR SELECT v_Status AS MainCode;  
			RETURN ResultSet;
		ELSIF(v_PDBFolderRecord.FolderType = ''A'' AND v_DBFolderType <> ''A'') THEN  
				v_Status := PRTRaiseError(''PRT_ERR_Cannot_AddFolder'');
				OPEN ResultSet FOR SELECT v_Status AS MainCode;  
				RETURN ResultSet;
		ELSIF(v_PDBFolderRecord.FolderLock = ''Y'') THEN  
			/* Fetch effective lock by user and lock message */
			v_Output := CheckLock(''F'', v_DBParentFolderId, v_PDBFolderRecord.LockByUser, v_PDBFolderRecord.FolderLock, v_PDBFolderRecord.LockMessage);
			v_Posi1 := STRPOS(v_Output, CHR(21));
			v_DBStatus := CAST(SUBSTR(v_Output, 1, v_Posi1 - 1) AS INTEGER);
			v_Output := SUBSTR(v_Output, v_Posi1 + 1);

			v_Posi1 := STRPOS(v_Output, CHR(21));
			v_EffectiveLockByUser := SUBSTR(v_Output, 1, v_Posi1 - 1);
			v_Output := SUBSTR(v_Output, v_Posi1 + 1);

			v_Posi1 := STRPOS(v_Output, CHR(21));
			v_LockMessage := SUBSTR(v_Output, 1, v_Posi1 - 1);
			v_Output := SUBSTR(v_Output, v_Posi1 + 1);

			v_Posi1 := STRPOS(v_Output, CHR(21));
			v_LockedObject := SUBSTR(v_Output, 1, v_Posi1 - 1);
			v_Output := SUBSTR(v_Output, v_Posi1 + 1);

			IF(v_EffectiveLockByUser <> v_DBUserId) THEN  
				v_Status := PRTRaiseError(''PRT_ERR_Folder_Locked'');
				OPEN ResultSet FOR SELECT v_Status AS MainCode;  
				RETURN ResultSet;
			END IF; 
			v_FolLock		:= ''Y''; 
			v_FolLockByUser	:= v_PDBFolderRecord.LockByUser; 
		ELSIF(v_PDBFolderRecord.FinalizedFlag = ''Y'') THEN 
			v_Status := PRTRaiseError(''PRT_ERR_Finalised_Folder'');
			OPEN ResultSet FOR SELECT v_Status AS MainCode;  
			RETURN ResultSet;
		END IF; 

		IF(v_PDBFolderRecord.FolderLevel >= 255) THEN  
			v_Status := PRTRaiseError(''PRT_ERR_Max_Level_Count_Reached'');
			OPEN ResultSet FOR SELECT v_Status AS MainCode;  
			RETURN ResultSet;
		END IF;  

		IF(v_LimitCount IS NOT NULL) THEN 
			SELECT INTO v_count COUNT(*) 
			FROM PDBFolder 
			WHERE ParentFolderIndex = v_DBParentFolderId  
			AND AccessType = v_DBAccessType; 

			IF(v_count >= v_LimitCount) THEN  
				v_Status := PRTRaiseError(''PRT_ERR_Max_Folder_Count_Reached'');
				OPEN ResultSet FOR SELECT v_Status AS MainCode;  
				RETURN ResultSet;
			END IF; 
		END IF; 

		/* Generate the name of the folder if the foldername given is NULL*/
		IF(v_DBFolderName IS NULL) THEN  
			v_Output := PRTGenerateDefaultName(''F'', v_DBParentFolderId, NULL, NULL, v_PDBFolderRecord.MainGroupId); 
			v_Posi1	:= STRPOS(v_Output, CHR(21));
			v_DBStatus := CAST(SUBSTR(v_Output, 1, v_Posi1 - 1) AS INTEGER);
			v_DBFolderName := SUBSTR(v_Output, v_Posi1 + 1);
			IF(v_DBStatus <> 0) THEN 
				v_Status := v_DBStatus; 
				OPEN ResultSet FOR SELECT v_Status AS MainCode;  
				RETURN ResultSet;
			END IF; 
		ELSE 	/* Check for the uniqueness of the folder	*/
			v_Output := GenerateName(''F'', v_DBFolderName, v_DBParentFolderId, NULL, NULL, v_NameLength, v_PDBFolderRecord.MainGroupId, v_DuplicateNameFlag); 
			v_Posi1	:= STRPOS(v_Output, CHR(21));
			v_DBStatus := CAST(SUBSTR(v_Output, 1, v_Posi1 - 1) AS INTEGER);
			v_DBFolderName := SUBSTR(v_Output, v_Posi1 + 1);
			IF(v_DBStatus <> 0) THEN  
				v_Status := v_DBStatus; 
				OPEN ResultSet FOR SELECT v_Status AS MainCode;  
				RETURN ResultSet;
			END IF; 
		END IF; 

		v_Hierarchy := COALESCE(RTRIM(v_Hierarchy), '''') || v_DBParentFolderId || ''.''; 

		v_NewFolderIndex := NextVal(''FolderId'');

		INSERT INTO PDBFolder(FolderIndex,ParentFolderIndex, Name, Owner, CreatedDatetime, RevisedDateTime, 
			AccessedDateTime, DataDefinitionIndex, AccessType, ImageVolumeIndex, 
			FolderType, FolderLock, LockByUser, Location, DeletedDateTime, 
			EnableVersion, ExpiryDateTime, Comment, UseFulData, ACL, FinalizedFlag, 
			FinalizedDateTime, FinalizedBy, ACLMoreFlag, MainGroupId, EnableFTS, LockMessage, 
			Folderlevel)  
		VALUES (v_NewFolderIndex, v_DBParentFolderId, v_DBFolderName, v_DBUserId, v_CurrDate, v_CurrDate, 
			v_CurrDate, v_DBDataDefinitionIndex, v_DBAccessType, v_PDBFolderRecord.ImageVolumeIndex, 
			v_DBFolderType, v_FolLock, v_FolLockByUser, v_PDBFolderRecord.FolderType,CAST(''31 Dec 2099'' AS DATE), 
			COALESCE(v_DBVersionFlag, v_PDBFolderRecord.EnableVersion), v_ExpiryDateTime, COALESCE(v_DBComment,''''), NULL, NULL, ''N'', 
			CAST(''31 Dec 2099'' AS DATE), 0, ''N'', v_PDBFolderRecord.MainGroupId, COALESCE(v_DBEnableFTS, v_PDBFolderRecord.EnableFTS), 
			v_LockMessage, v_PDBFolderRecord.FolderLevel + 1); 

		IF(v_DBDataDefinitionIndex > 0) THEN 
			IF(LENGTH(v_ColumnList) > 0) THEN 
				 v_ColumnList   := '' FoldDocIndex, FoldDocFlag'' || v_ColumnList; 
				 v_ValueList    := TO_CHAR(v_NewFolderIndex, ''99999'') || '', '' || CHR(39) || ''F'' || CHR(39) || v_ValueList; 
				 EXECUTE ''INSERT INTO '' || v_DDTTableName || '' ( '' || v_ColumnList || '' ) VALUES ( '' || v_ValueList || '')''; 
			END IF; 
			v_useFulDataStrStatus := PRTBuildUseFulDataString (v_NewFolderIndex, ''F'', v_DBDataDefinitionIndex); 
		END IF; 

		v_WhileCounter := 1; 
		v_NextOrder := 0; 

		WHILE(v_WhileCounter <= 5) LOOP  
			IF v_WhileCounter = 1 THEN  
				v_DBDocumentList := DBDocumentList1; 
			ELSIF v_WhileCounter = 2 THEN 
				v_DBDocumentList := DBDocumentList2; 
			ELSIF v_WhileCounter = 3 THEN 
				v_DBDocumentList := DBDocumentList3; 
			ELSIF v_WhileCounter = 4 THEN 
				v_DBDocumentList := DBDocumentList4; 
			ELSIF v_WhileCounter = 5 THEN 
				v_DBDocumentList := DBDocumentList5; 
			END IF; 
	 
			v_TempStr := ''''; 
			WHILE(LENGTH(v_DBDocumentList) > 0) LOOP  
				v_pos1 := STRPOS(v_DBDocumentList, CHR(25)); 
				IF(v_pos1 = 0) THEN  
					v_TempStr := SUBSTR(v_DBDocumentList, 1); 
					v_DBDDIDataList := NULL; 
					EXIT; 
				ELSE  
					v_TempStr 			:= RTRIM(v_TempStr) || RTRIM(SUBSTR(v_DBDocumentList, 1, v_pos1-1)); 
					v_DBDocumentList	:= SUBSTR(v_DBDocumentList, v_pos1 + 1);  
					v_pos1 				:= STRPOS(v_TempStr, CHR(21)); 
					v_DocumentName		:= RTRIM(SUBSTR(v_TempStr, 1, v_pos1-1)); 
					v_TempStr 			:= SUBSTR(v_TempStr, v_pos1 + 1); 
					v_pos1 				:= STRPOS( v_TempStr, CHR(21)); 
					v_ISIndexStr 		:= RTRIM(SUBSTR(v_TempStr, 1, v_pos1-1)); 
					v_TempStr 			:= SUBSTR(v_TempStr, v_pos1 + 1);
					v_pos1 				:= STRPOS(v_TempStr,CHR(21)); 
					v_NoOfPage 			:= CAST((BTRIM(SUBSTR(v_TempStr, 1, v_pos1-1))) AS INTEGER);
					/*Bugzilla bug id 3129*/
					v_TempStr 			:= SUBSTR(v_TempStr, v_pos1 + 1);
					v_pos1 				:= STRPOS(v_TempStr, CHR(21));
					IF(v_pos1 >1) THEN				 
						v_DocumentSize := TO_NUMBER(RTRIM(SUBSTR(v_TempStr, 1, v_pos1 - 1)), ''9999999999'');					 
						v_TempStr 	:= SUBSTR(v_TempStr, v_pos1 + 1);
						v_pos1 	:= STRPOS( v_TempStr,CHR(21));
						IF(v_pos1 >1) THEN					 
							v_AppType	:= RTRIM(SUBSTR(v_TempStr, 1,v_pos1-1));
							v_Comment	:= RTRIM(SUBSTR(v_TempStr, v_pos1+1));					 
						ELSE					 
							v_AppType	:= RTRIM(SUBSTR(v_TempStr, v_pos1+1));
							v_Comment	:= '''';					 
						END IF;				 
					ELSE				 
						v_DocumentSize := TO_NUMBER(RTRIM(SUBSTR(v_TempStr, v_pos1+1)), ''9999999999'');
						v_AppType	:=''TIF'';
						v_Comment	:= ''''; 
					END IF;	
					/*Bugzilla bug id 3129*/
					v_pos1 				:= STRPOS(v_ISIndexStr,CHR(35)); 
					v_ImageIndex 		:= CAST(LTRIM(RTRIM(SUBSTR(v_ISIndexStr, 1, v_pos1-1))) AS INTEGER); 
					v_VolumeIndex 		:= CAST(LTRIM(RTRIM(SUBSTR(v_ISIndexStr, v_pos1+1))) AS INTEGER);
					v_TempStr			:= '''';
					/*Bugzilla bug id 3129*/
	                IF(UPPER(v_AppType) = ''TIF'' OR UPPER(v_AppType) = ''TIFF'' OR UPPER(v_AppType) = ''BMP'' OR UPPER(v_AppType) = ''JPEG'' OR UPPER(v_AppType) = ''JPG'' OR UPPER(v_AppType) = ''JIF'' OR UPPER(v_AppType) = ''GIF'') THEN 
						v_DocumentType := ''I'';
					ELSE 
						v_DocumentType := ''N'';
					END IF;
					v_Output := GenerateName(''D'', v_DocumentName, v_NewFolderIndex, v_DocumentType, v_AppType, 25, v_PDBFolderRecord.MainGroupId, ''Y'');
					v_Posi1	:= STRPOS(v_Output, CHR(21));
					v_DBStatus := CAST(SUBSTR(v_Output, 1, v_Posi1 - 1) AS INTEGER);
					v_DocumentName := SUBSTR(v_Output, v_Posi1 + 1);

					 IF(v_DBStatus <> 0) THEN 
						v_Status := v_DBStatus; 
						OPEN ResultSet FOR SELECT v_Status AS MainCode;  
						RETURN ResultSet;
					 END IF; 

					v_NewDocumentIndex := NextVal(''DocumentID'');

					/* 43 attributes are set from the PDBDocument*/
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
					 VALUES (v_NewDocumentIndex, 1.0,	''Original'', 
						v_DocumentName, v_DBUserId, v_CurrDate, v_CurrDate, 
						v_CurrDate, 0, 
						v_PDBFolderRecord.EnableVersion, ''I'', v_DocumentType, 
						0, v_DBUserId, 
						v_ImageIndex, v_VolumeIndex, v_NoOfPage, v_DocumentSize, 
						0, ''not defined'', 
						''N'', ''N'', NULL, 
						v_Comment, v_UserName, 0, 0, 
						''XX'', ''A'', CAST(''12 Dec 2099'' AS DATE), 
						''N'', CAST(''12 Dec 2099'' AS DATE), 0, 
						''N'', 0, NULL, 
						NULL, ''not defined'', ''N'', v_AppType, 
						v_PDBFolderRecord.MainGroupId, ''N'', ''N'', NULL); 

 
					v_NextOrder := v_NextOrder + 1; 
					INSERT INTO PDBDocumentContent(ParentFolderIndex, DocumentIndex, FiledBy, FiledDatetime, DocumentOrderNo, RefereceFlag) 				 VALUES(v_NewFolderIndex, v_NewDocumentIndex, v_DBUserId, v_CurrDate, v_NextOrder , ''O''); 
					
					IF(v_Comment IS NULL) THEN  				
						v_FieldName:=v_DocumentName;				
					ELSE                
						v_FieldName:=v_DocumentName  ||  ''('' ||  v_Comment ||  ''.''  ||  v_AppType || '')'';				
					END IF;
					Insert Into WFMessageTable (message, status,ActionDateTime)
					values(''<Message><ActionId>18</ActionId><UserId>''  ||  TO_CHAR(v_DBUserId, ''99999'')  || 
					''</UserId><ProcessDefId>''  ||  TO_CHAR(DBProcessDefId, ''99999'')  || 
					''</ProcessDefId><ActivityId>''  ||  TO_CHAR(v_ActivityId, ''99999'')  || 
					''</ActivityId><QueueId>'' ||  TO_CHAR(v_QueueId, ''99999'')  || 
					''</QueueId><UserName>''  || BTRIM(COALESCE(v_UserName,''''))  || 
					''</UserName><ActivityName>''  ||  COALESCE(v_ActivityName,'''')  || 
					''</ActivityName><TotalWiCount>1</TotalWiCount><TotalDuration>0</TotalDuration><ProcessInstance>''  ||  v_ProcessInstanceId  || 
					''</ProcessInstance><FieldId>''  ||  TO_CHAR(v_QueueId, ''99999'')  || 
					''</FieldId><WorkitemId>1</WorkitemId><TotalPrTime>0</TotalPrTime><DelayTime>0</DelayTime><WKInDelay>0</WKInDelay><ReportType>D</ReportType><LoggingFlag>1</LoggingFlag><FieldName>'' ||
					v_FieldName || ''</FieldName></Message>'',
					''N'', CURRENT_TIMESTAMP );
				END IF; 
			END LOOP;  
			v_WhileCounter := v_WhileCounter + 1; 
		END LOOP;  
		
		v_QueryStr := ''SELECT A.UserDefinedName, A.SystemDefinedName, A.VariableType FROM VarMappingTable A, RecordMappingTable B WHERE A.ProcessDefId	= '' || DBProcessDefId || '' AND A.ProcessDefId = B.ProcessDefId AND A.VariableScope = ''''M'''' AND (UPPER(A.UserDefinedName) = UPPER(B.REC1) OR UPPER(A.UserDefinedName) = UPPER(B.REC2) OR UPPER(A.UserDefinedName) = UPPER(B.REC3) OR UPPER(A.UserDefinedName) = UPPER(B.REC4) OR UPPER(A.UserDefinedName) = UPPER(B.REC5))''; 

		OPEN v_sysattrcur FOR EXECUTE v_QueryStr;
		LOOP 
			FETCH v_sysattrcur INTO v_UserDefinedName, v_SystemDefinedName, v_VariableType;
			IF(NOT FOUND) THEN
				EXIT;
			END IF;
			IF(UPPER(LTRIM(RTRIM(v_UserDefinedName))) = ''ITEMINDEX'') THEN 
				v_Var_Rec_1 	:= CAST(v_NewFolderIndex AS VARCHAR); 
				IF(v_UpdateFlag = ''Y'')  THEN 
					 v_UpdateColumnStr:= RTRIM(v_UpdateColumnStr) || '', '' || v_SystemDefinedName ; 
					 v_UpdateValueStr := v_UpdateValueStr || '', '' || CHR(39) || RTRIM(v_Var_Rec_1) || CHR(39); 
				ELSE  
					 v_UpdateFlag	:= ''Y''; 
					 v_UpdateColumnStr := RTRIM(v_SystemDefinedName); 
					 v_UpdateValueStr  := CHR(39) || RTRIM(v_Var_Rec_1) || CHR(39); 
				END IF; 
				v_InsertExtColumnStr := v_InsertExtColumnStr || '', '' || v_UserDefinedName; 
				v_InsertExtValueStr  := v_InsertExtValueStr || '', '' || v_Var_Rec_1;  
			ELSIF(UPPER(LTRIM(RTRIM(v_UserDefinedName))) = ''ITEMTYPE'') THEN 
				v_Var_Rec_1 	:= CHR(39) || ''F'' || CHR(39) ; 
				IF(v_UpdateFlag = ''Y'') THEN 
					v_UpdateColumnStr:= RTRIM(v_UpdateColumnStr) || '', '' || v_SystemDefinedName ; 
					v_UpdateValueStr := LTRIM(RTRIM(v_UpdateValueStr)) || '', '' || RTRIM(v_Var_Rec_1); 
				ELSE 
					v_UpdateFlag := ''Y''; 
					v_UpdateColumnStr := RTRIM(v_SystemDefinedName); 
					v_UpdateValueStr  :=  RTRIM(v_Var_Rec_1) ; 
				END IF; 
				v_InsertExtColumnStr := v_InsertExtColumnStr || '', '' || v_UserDefinedName; 
				v_InsertExtValueStr  := v_InsertExtValueStr || '', '' || v_Var_Rec_1; 
			ELSE  
				v_Var_Rec_1 := '' NULL ''; 
				v_InsertExtColumnStr := v_InsertExtColumnStr || '', '' || v_UserDefinedName; 
				v_InsertExtValueStr  := v_InsertExtValueStr || '', '' || v_Var_Rec_1; 
			END IF; 
		END LOOP; 
		CLOSE v_sysattrcur;
		 v_ValidTill := NULL;
		 /* ______________________________________________________________________________________
			// Changed On  : 07/07/2009
			// Changed By  : Saurabh Kamal
			// Description : WFS_8.0_010, IF-ELSE added.Inserting ProcessInstanceState as 1 and 
			//		 IntroducedByID, IntroducedBy,IntroductionDatetime as NULL		 
			// ____________________________________________________________________________________*/
		IF(DBInitiateAlso = ''Y'') THEN
			INSERT INTO ProcessInstanceTable (ProcessInstanceId , ProcessDefID , Createdby , CreatedDatetime , 
					ProcessinstanceState , CreatedByName,IntroducedByID, IntroducedBy,IntroductionDatetime, 
					ExpectedProcessDelay, IntroducedAt)  
			VALUES (v_ProcessInstanceId, DBProcessDefId, v_DBUserId, v_CurrDate, 2, BTRIM(v_UserName), v_DBUserId, BTRIM(v_UserName), v_CurrDate, DBExpectedProcessDelay, v_ActivityName); 
		ELSE
			INSERT INTO ProcessInstanceTable (ProcessInstanceId , ProcessDefID , Createdby , CreatedDatetime , 
					ProcessinstanceState , CreatedByName,IntroducedByID, IntroducedBy,IntroductionDatetime, 
					ExpectedProcessDelay, IntroducedAt)  
			VALUES (v_ProcessInstanceId, DBProcessDefId, v_DBUserId, v_CurrDate, 1, BTRIM(v_UserName), NULL, NULL, NULL, DBExpectedProcessDelay, v_ActivityName); 
		END IF;
		 /* ______________________________________________________________________________________
			// Changed On  : 07/07/2009
			// Changed By  : Saurabh Kamal
			// Description : WFS_8.0_010, IF InitiateAlso != Y Insert AssignmentType = ''S''				 
			// ____________________________________________________________________________________*/

		IF(DBInitiateAlso = ''Y'') THEN
				INSERT INTO workdonetable  
				(ProcessInstanceId,WorkItemId,ProcessName,ProcessVersion,ProcessDefID,LastProcessedBy, 
				ProcessedBy,ActivityName,ActivityId,EntryDateTime,ParentWorkItemId,AssignmentType, 
				CollectFlag,PriorityLevel,ValidTill,Q_StreamId,Q_QueueId,Q_UserId,AssignedUser, 
				FilterValue, CreatedDateTime,WorkItemState,Statename,ExpectedWorkitemDelay,PreviousStage, 
				LockedByName,LockStatus,LockedTime,Queuename,Queuetype,NotifyStatus) 
				Values(v_ProcessInstanceId, 1, v_ProcessName, v_ProcessVersion, DBProcessDefId, v_DBUserId, 
					BTRIM(v_UserName), v_ActivityName, v_ActivityId, v_CurrDate, 0,''Y'',''N'', DBPriorityLevel, v_ValidTill,
					v_StreamId,v_QueueId,NULL,NULL,NULL,v_CurrDate,6,''COMPLETED'',NULL,v_ActivityName,NULL,''N'',v_CurrDate, 
					v_QueueName, ''I'',NULL) ; 
		ELSE
				INSERT INTO WorkListTable  
				(ProcessInstanceId,WorkItemId,ProcessName,ProcessVersion,ProcessDefID,LastProcessedBy, 
				ProcessedBy,ActivityName,ActivityId,EntryDateTime,ParentWorkItemId,AssignmentType, 
				CollectFlag,PriorityLevel,ValidTill,Q_StreamId,Q_QueueId,Q_UserId,AssignedUser, 
				FilterValue, CreatedDateTime,WorkItemState,Statename,ExpectedWorkitemDelay,PreviousStage, 
				LockedByName,LockStatus,LockedTime,Queuename,Queuetype,NotifyStatus) 
				Values(v_ProcessInstanceId, 1, v_ProcessName, v_ProcessVersion, DBProcessDefId, v_DBUserId, 
					BTRIM(v_UserName), v_ActivityName, v_ActivityId, v_CurrDate, 0,''S'',''N'', DBPriorityLevel, v_ValidTill,
					v_StreamId,v_QueueId,NULL,NULL,NULL,v_CurrDate,1,''NOTSTARTED'',NULL,v_ActivityName,NULL,''N'',NULL, 
					v_QueueName, ''I'',NULL) ; 
		END IF;
		v_QueryStr := ''INSERT INTO QueueDataTable (ProcessInstanceID, WorkItemID, SaveStage, InstrumentStatus, CheckListCompleteFlag ''|| COALESCE(v_DBQDTColumnList,'''') || '', '' || v_UpdateColumnStr ||'') Values(''||CHR(39)||  v_ProcessInstanceId ||CHR(39)||'', 1,''|| CHR(39) || v_ActivityName || CHR(39) || '',''|| CHR(39) || ''N'' || CHR(39) || '','' ||CHR(39) || ''N'' || CHR(39) || COALESCE(v_DBQDTValueList,'''') || '','' || v_UpdateValueStr || '')''; 
		EXECUTE v_QueryStr;
	 
		IF((LENGTH(v_InsertExtColumnStr) > 0) AND (LENGTH(v_TableViewName) > 0))THEN
			IF v_DBEXTColumnList IS NULL THEN
				v_InsertExtColumnStr := SUBSTR(v_InsertExtColumnStr,2); 
				v_InsertExtValueStr  := SUBSTR(v_InsertExtValueStr, 2); 	
			END IF;			
			v_QueryStr := '' INSERT INTO '' || v_TableViewName || '' ( '' || COALESCE(v_DBEXTColumnList,'''') || v_InsertExtColumnStr || '' ) VALUES ( '' || COALESCE(v_DBEXTValueList,'''') || v_InsertExtValueStr || '' ) '';
			EXECUTE v_QueryStr; 
		END IF; 
		INSERT INTO WFMessageTable (message, status, ActionDateTime)  
		values	(''<Message><ActionId>1</ActionId><UserId>'' || v_DBUserId || 
				''</UserId><ProcessDefId>'' || DBProcessDefId || 
				''</ProcessDefId><ActivityId>0</ActivityId><QueueId>0</QueueId><UserName>'' || 
				COALESCE(v_UserName,'''') || ''</UserName><ActivityName>'' || COALESCE(v_ActivityName,'''') || 
				''</ActivityName><TotalWiCount>1</TotalWiCount><TotalDuration>0</TotalDuration><ActionDateTime>'' 
				|| TO_CHAR(CURRENT_TIMESTAMP, ''YYYY-MM-DD HH24:MI:SS'') || 
				''</ActionDateTime><EngineName></EngineName><ProcessInstance>'' || v_ProcessInstanceId || 
				''</ProcessInstance><FieldId>'' || v_QueueId || ''</FieldId><WorkitemId>1</WorkitemId><TotalPrTime>0</TotalPrTime><DelayTime>0</DelayTime><WKInDelay>0</WKInDelay><ReportType>D</ReportType><Flag>0</Flag></Message>'', 
			''N'', CURRENT_TIMESTAMP 
		);

		v_DBStatus := 0; 
		
		v_MessageBuffer := ''<Message><ActionId>16</ActionId><UserId>'' || TO_CHAR(v_DBUserId, ''99999'') ||  
			''</UserId><ProcessDefId>'' || TO_CHAR(DBProcessDefId, ''99999'') || 
			''</ProcessDefId><ActivityId>'' || TO_CHAR(v_ActivityId, ''99999'') || 
			''</ActivityId><QueueId>0</QueueId><UserName>'' || BTRIM(COALESCE(v_UserName,'''')) || 
			''</UserName><ActivityName>'' || COALESCE(v_ActivityName,'''') || 
			''</ActivityName><TotalWiCount>0</TotalWiCount><TotalDuration>0</TotalDuration><ActionDateTime>''  
			|| TO_CHAR(CURRENT_TIMESTAMP, ''YYYY-MM-DD HH24:MI:SS'') || 
			''</ActionDateTime><EngineName></EngineName><ProcessInstance>'' || v_ProcessInstanceId || 
			''</ProcessInstance><FieldId>0</FieldId><FieldName><Attributes>'' || COALESCE(v_DBRouteLogList, '''') || 
			''</Attributes></FieldName><WorkitemId>1</WorkitemId><TotalPrTime>0</TotalPrTime><DelayTime>0</DelayTime><WKInDelay>0</WKInDelay><ReportType>D</ReportType><LoggingFlag>1</LoggingFlag></Message>'';
			
		Insert Into WFMessageTable (message, status, ActionDateTime) values	(v_MessageBuffer, ''N'', CURRENT_TIMESTAMP);
		

		IF(DBInitiateAlso = ''Y'') THEN		
--			SELECT INTO v_datediff1, v_datediff2
--						(CURRENT_TIMESTAMP - A.createdDateTime), (CURRENT_TIMESTAMP - A.lockedTime)  
--			FROM WorkDoneTable A  
--			WHERE A.ProcessInstanceId = v_ProcessInstanceId; 
--			IF(NOT FOUND) THEN
--				v_DBTotalDuration := 0; 
--				v_DBTotalPrTime := 0; 
--			END IF;
			v_DBTotalDuration := COALESCE(v_DBTotalDuration * 24 * 60 * 60, 0); 
			v_DBTotalPrTime   := COALESCE(v_DBTotalPrTime * 24 * 60 * 60, 0); 

			INSERT INTO WFMessageTable (message, status, ActionDateTime)  
			values(''<Message><ActionId>2</ActionId><UserId>'' || v_DBUserId || 
				''</UserId><ProcessDefId>'' || DBProcessDefId || 
				''</ProcessDefId><ActivityId>'' || v_ActivityId || 
				''</ActivityId><QueueId>''|| v_QueueId || 
				''</QueueId><UserName>'' || BTRIM(COALESCE(v_UserName,'''')) || 
				''</UserName><ActivityName>'' || COALESCE(v_ActivityName,'''') || 
				''</ActivityName><TotalWiCount>1</TotalWiCount><TotalDuration>'' || 
				v_DBTotalDuration || ''</TotalDuration><ActionDateTime>'' || 
				 TO_CHAR(CURRENT_TIMESTAMP, ''YYYY-MM-DD HH24:MI:SS'') || 
				 ''</ActionDateTime><EngineName></EngineName><ProcessInstance>'' || v_ProcessInstanceId || 
				''</ProcessInstance><FieldId>'' || v_QueueId || 
				''</FieldId><FieldName>NULL</FieldName><WorkitemId>1</WorkitemId><TotalPrTime>'' || 
				v_DBTotalPrTime || 
				''</TotalPrTime><DelayTime>0</DelayTime><WKInDelay>0</WKInDelay><ReportType>D</ReportType><LoggingFlag>3</LoggingFlag></Message>'', 
				''N'', CURRENT_TIMESTAMP
			);  
		END IF;
		
		IF(v_ValidationReqd1 IS NOT NULL AND v_ValidateQuery IS NOT NULL) THEN 		
			EXECUTE v_ValidateQuery;
		END IF; 

		OPEN ResultSet FOR SELECT v_DBStatus, v_DBFolderName, v_CurrDate, v_NewFolderIndex;
		RETURN ResultSet;
	END; 
'
LANGUAGE 'plpgsql';