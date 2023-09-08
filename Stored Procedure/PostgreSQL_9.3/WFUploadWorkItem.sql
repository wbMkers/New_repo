/*__________________________________________________________________________________________________
			NEWGEN SOFTWARE TECHNOLOGIES LIMITED
______________________________________________________________________________________________
	Group						: Genesis.
	Product / Project			: Omniflow 10.1
	Module						: WorkFlow Server
	File Name					: WFUploadWorkItem.sql
	Author						: Sajid Khan
	Date written (DD/MM/YYYY)	: 08-12-2014
	Description					: This stored procedure is called from WMMiscellaneous.java
______________________________________________________________________________________________
				CHANGE HISTORY
______________________________________________________________________________________________
Date			Change By			Change Description (Bug No. (If Any))
 14/04/2014     Kanika Manik       Bug 54916 - OF 10.3: Windows:JBoss: Postgres: Functional >> Unable to create workitem 
10 Dec 2015		Sajid Khan			Bug 58270 - Auditing of Attribute set is not being done through WFUPloadWorkitem API
01-05-2017	Sajid Khan			Merging Bug 58270 - Auditing of Attribute set is not being done through WFUPloadWorkitem API
09/05/2017	Kumar Kimil 	Bug 55927 - Support for API Wise Synchronous Routing.
17/07/2017	Mohnish Chopra 		PRDP Bug 69312 - Workitems created through initiation agent pending for PS are visible on queue click . 
24/10/2017        Kumar Kimil         Case Registration requirement--Upload Workitem changes
29/12/2017  Kumar Kimil         Bug 74441 - PNG File handling through Initiation Agent and 0KB file Handling for ESPN
22/04/2018  Ambuj Tripathi		Bug 76862 - Remove the db console messages from all procedures
01/10/2018  Ambuj Tripathi		Changes related to sharepoint support
29/01/2019	Ravi Ranjan Kumar Bug 82718 - User able to view & search iBps WF system folders .
04/02/2020	Ambuj Tripathi		Bug 88867 - Png document is not displayed in Attached document when WI is created through import service or initiation agent.
12/01/2021					chitranshi nitharia	changes done for upload error handling.
28/06/2021	Aqsa hashmi     Bug 99985 - BPMTransition: An extra character 'N' is getting appended with the document name when document 	get attached in WI through BPM transition
27/09/2021  Aqsa hashmi		Bug 101557 - IBPS5SP2||BPM Application :->On Opening workitem after importing BPM Application on docker,observe that document name 	which is uploaded is shown wrong
_____________________________________________________________________________________________
____________________________________________________________________________________________*/
CREATE OR REPLACE FUNCTION WFUploadWorkItem 
(
		v_DBUserId					INTEGER,  
		v_ProcessInstanceId			VARCHAR, 
		DBProcessDefId				INTEGER,  
		v_ActivityId				INTEGER,  
		v_ActivityName				VARCHAR,   
		v_ValidationReqd			VARCHAR,  
		v_DBDataDefinitionIndex		INTEGER,  
		DBDDIDataList1				VARCHAR,  
		DBDDIDataList2				VARCHAR,  
		DBDDIDataList3				VARCHAR,  
		DBDDIDataList4				VARCHAR,  
		DBDDIDataList5				VARCHAR,  
		DBDDIDataList6				VARCHAR,  
		DBDDIDataList7				VARCHAR,  
		DBDDIDataList8				VARCHAR,  
		DBDDIDataList9				VARCHAR,  
		DBDDIDataList10				VARCHAR,  
		DBDocumentList1				VARCHAR, 
		DBDocumentList2				VARCHAR, 
		DBDocumentList3				VARCHAR, 
		DBDocumentList4				VARCHAR, 
		DBDocumentList5				VARCHAR, 
		DBPriorityLevel				INTEGER, 		
		DBGenerateLog				VARCHAR,
		DBExpectedProcessDelay		TIMESTAMP,
		DBInitiateAlso				VARCHAR,
		v_DBQDTColumnList			VARCHAR,
		v_DBQDTValueList			VARCHAR,
		v_DBEXTColumnList			VARCHAR,
		v_DBEXTValueList			VARCHAR,
		v_DBRouteLogList			VARCHAR,
		v_ValidateQuery				VARCHAR,
		v_MainGroupId				INTEGER,
		v_DBParentFolderId			INTEGER,
		v_ProcessName				VARCHAR,
		v_ProcessVersion			INTEGER,
		v_QueueId					INTEGER,
		v_QueueName					VARCHAR,
		v_StreamId					INTEGER,
		v_ProcessVariantId			INTEGER,
		v_DBSetAttributeLoggingEnabled		VARCHAR,
		synFlag                     VARCHAR,
		v_urn                       Varchar,
		v_SharepointFlag			VARCHAR,
		v_FolderIdSP				VARCHAR,
		v_locale					VARCHAR
	) RETURNS REFCURSOR AS $$
	DECLARE
		v_DBFolderName				VARCHAR(255); 
		v_DBAccessType				VARCHAR(1); 
		v_DBImageVolumeIndex		INTEGER; 
		v_DBFolderType				VARCHAR(1); 
		v_DBVersionFlag				VARCHAR(1); 
		v_DBComment					VARCHAR(255); 
		v_DBExpiryDateTime			VARCHAR(64); 
		v_NameLength				INTEGER; 
		v_LimitCount				INTEGER; 
		v_DBEnableFTS				VARCHAR(1); 
		v_DuplicateNameFlag			VARCHAR(1); 
		v_DBLocation				CHAR;
		v_DBUserRights      		VARCHAR(16); 
		v_DBStatus					INTEGER; 
		v_NewFolderIndex			INT8; 
		v_ExpiryDateTime			TIMESTAMP; 
		v_EffectiveLockByUser		INTEGER; 
		v_LockMessage				VARCHAR(255); 
		v_LockedObject				INTEGER; 
		v_FolLock					VARCHAR(1); 
		v_FolLockByUser				VARCHAR(255); 
		v_Hierarchy					VARCHAR(4000); 
		v_ProcessState				VARCHAR(10); 
		v_TableViewName				VARCHAR(255); 
		v_Length					INTEGER; 
		v_ColumnList				VARCHAR(8000); 
		v_ValueList					VARCHAR(8000); 
		v_WhileCounter				INTEGER; 
		v_DDTTableName				VARCHAR(255); 
		v_UserName					VARCHAR(256);                
		v_UpdateFlag				VARCHAR(1); 
		v_SystemDefinedName			VARCHAR(64); 
		v_VariableType				INTEGER; 
		v_DBDDIDataList				VARCHAR(8000); 
		v_ParseCount				INTEGER; 
		v_pos1						INTEGER; 
		v_posNew					INTEGER;
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
		v_Comment					VARCHAR(1020);
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
		v_UpdateColumnStr			VARCHAR(8000); 
		v_UpdateValueStr			VARCHAR(8000); 
		v_QueryStr					VARCHAR(8000); 
		v_QueryStr1					VARCHAR(8000); 
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
		v_PriorityLevel				VARCHAR(5); 
		v_DBTotalDuration			NUMERIC; 
		v_DBTotalPrTime				NUMERIC; 
		v_retval					INTEGER; 
		v_count						INTEGER; 
		v_rowCount					INTEGER; 
		v_ValidationReqd1			VARCHAR(1000); 
		v_size						INTEGER; 
		v_MessageBuffer				TEXT;
		v_FieldName					VARCHAR(2000);
		v_Output					VARCHAR(255);
		v_Status 					INTEGER;
		v_useFulDataStrStatus		INTEGER;
		v_PDBFolderRecord			RECORD;
		ResultSet					REFCURSOR;
		v_attrcur					REFCURSOR; 
		v_sysattrcur				REFCURSOR; 
		v_UpdateQueue				REFCURSOR; 
		v_DBDocumentIndexes			VARCHAR(8000);
		FolderIndex					INTEGER;
		v_UniqueNameString			VARCHAR(8000);
		existflag					INTEGER;
		v_fieldId				INTEGER;
		v_urnDup                    Varchar(63);
		v_ISSecureFolder VARCHAR(1);
		v_MainCode INT;
		v_DBMsg 					Varchar(1000);
		v_DBTblNm 					Varchar(1000);
BEGIN 
		/* Initialize variables */ 
		v_FolLock		:= 'N'; 
		v_FolLockByUser	:= NULL; 
		v_DBUserRights	:= ''; 
		v_DBStatus		:= -1; 
		v_UpdateFlag	:= 'N'; 
		v_TempStr		:= '';
		v_InsertExtColumnStr := '';
		v_InsertExtValueStr := '';
		v_DBDocumentIndexes	:=	'';
		v_MainCode := 0;
		
		v_ValidationReqd1 := v_ValidationReqd; 
		DBExpectedProcessDelay :=Coalesce(DBExpectedProcessDelay,Now());
		SELECT INTO v_TableViewName TableName  
		FROM 	ExtDBConfTable 
		WHERE 	ProcessDefId = DBProcessDefId
		AND ExtObjId = 1; 
		IF(v_urn IS NULL) THEN
		v_urn:='';
		v_urnDup:='';
		ELSE
		v_urnDup:=v_urn;
		
		END IF;
	--Raise Notice '@847 v_urnDup>>>(%)',v_urnDup;
	--Raise Notice '@847 v_urn>>>(%)',v_urn;
		IF(NOT FOUND) THEN
			v_TableViewName := NULL; 
		END IF; 

		v_UpdateColumnStr 	:= ''; 
		v_UpdateValueStr 	:= ''; 
		
		/* Sharepoint related changes */
	BEGIN
	  IF (v_sharepointFlag = 'N' OR v_sharepointFlag = 'n' ) THEN
		IF(v_DBDataDefinitionIndex <> 0) THEN  
			 v_WhileCounter := 1; 
			 v_ColumnList   := ''; 
			 v_ValueList    := ''; 
	 
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
				v_TempStr := ''; 

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
							 v_TempStr := ''; 
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
							v_TempStr := ''; 
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
								v_ColumnList :=  RTRIM(v_ColumnList) || ', Field_' || v_TempFieldId; 
								v_size := LENGTH(LTRIM(RTRIM(v_TempFieldValue))); 
								IF(LTRIM(RTRIM(v_TempFieldValue)) = CHR(181) OR v_size = 0)THEN  
									 v_TempFieldValue := 'NULL'; 
								END IF; 
								IF(v_TempFieldValue = 'NULL') THEN 
									IF(v_TempDataFieldType = 'B') THEN 
										v_TempFieldValue := '0'; 
										v_ValueList := RTRIM(v_ValueList) || ',' || LTRIM(RTRIM(v_TempFieldValue)); 
									END IF; 
								ELSIF(v_TempDataFieldType = 'S') THEN  
										v_QueryStr:= CHR(39) || CHR(39); 
										v_TempFieldValue := REPLACE(v_TempFieldValue, CHR(39), v_QueryStr);  
										v_ValueList := RTRIM(v_ValueList) || ',' || CHR(39) || RTRIM(v_TempFieldValue) || CHR(39); 
								ELSIF(v_TempDataFieldType = 'D')THEN 
									v_ValueList := RTRIM(v_ValueList) || ',TO_DATE(' || CHR(39) || RTRIM(v_TempFieldValue) || CHR(39) || ',' || Chr(39) || 'YYYY-MM-DD' || CHR(39) ||')';  
								ELSIF(v_TempDataFieldType = 'I' OR v_TempDataFieldType = 'L' OR v_TempDataFieldType	= 'F' OR v_TempDataFieldType = 'B' OR 
										v_TempDataFieldType	= 'X') THEN 
									v_ValueList := RTRIM(v_ValueList) || ',' || LTRIM(RTRIM(v_TempFieldValue)); 
								END IF; 
							END IF; 
							v_DBStatus := CheckData('F', v_NewFolderIndex, RTRIM(upper(v_DDTTableName)), RTRIM(v_TempFieldId), RTRIM(upper(v_TempDataFieldType)), v_TempFieldValue); 
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
	--RAISE NOTICE '@413>>v_DBExpiryDateTime>>(%)',v_DBExpiryDateTime;
	
	v_DBAccessType		:= COALESCE(v_DBAccessType, 'I'); 
	v_DBComment			:= COALESCE(v_DBComment, 'Not Defined'); 
	v_DuplicateNameFlag	:= COALESCE(v_DuplicateNameFlag, 'Y'); 
	v_CurrDate 			:= CURRENT_TIMESTAMP; 
	SELECT ISSecureFolder INTO v_ISSecureFolder FROM ProcessDefTable WHERE ProcessDefId = DBProcessDefId;
	IF (COALESCE(v_ISSecureFolder, 'N') = 'N') THEN
		v_DBFolderType := 'G';
	ELSE
		v_DBFolderType := 'K';
	END IF;
		
	IF(v_DBExpiryDateTime IS NULL OR LENGTH(v_DBExpiryDateTime) = 0)THEN  
	--DBCurrentDateTime := Coalesce(To_TimeStamp(DBCurrentDate,''YYYY-MM-DD HH24:MI:SS''),Now());
	--RAISE NOTICE '@4>>v_DBExpiryDateTime>>(%)',v_DBExpiryDateTime;
		 v_ExpiryDateTime := CAST('31 Dec 2099' AS DATE); 
		 --RAISE NOTICE '@413>>v_DBExpiryDateTime>>(%)',v_ExpiryDateTime;
	ELSE 
		 v_ExpiryDateTime :=cast(v_DBExpiryDateTime AS DATE); 
	END IF; 
	--v_ValidTill :=Coalesce(v_ValidTill,to_timestamp('31-12-2099' ,'DD-MM-YYYY'));
	SELECT 	 UserName INTO v_UserName 
	FROM 	PDBUser 
	WHERE 	UserIndex = v_DBUserId; 
	IF(NOT FOUND) THEN
		v_Status := 15;
		OPEN ResultSet FOR SELECT v_Status AS MainCode;  
		RETURN ResultSet;
	END IF;
	
	v_DBFolderName		:= v_ProcessInstanceId;  

	SELECT INTO v_PDBFolderRecord FolderLock, FinalizedFlag, Location, FolderType, COALESCE(v_DBImageVolumeIndex, ImageVolumeIndex) AS ImageVolumeIndex, Owner, AccessType, 
	ACLMoreFlag, ACL, EnableVersion, EnableFTS, LockMessage, LockByUser, FolderLevel ,MainGroupId
	FROM PDBFolder WHERE PDBFolder.FolderIndex = v_DBParentFolderId AND (v_MainGroupId = 0 OR MainGroupId = v_MainGroupId); 
	
	IF(NOT FOUND) THEN 
		v_Status := PRTRaiseError('PRT_ERR_Folder_Not_Exist');
		OPEN ResultSet FOR SELECT v_Status AS MainCode;  
		RETURN ResultSet;
	ELSIF(NOT(v_PDBFolderRecord.Location IN ('R', 'G', 'A','K') AND v_DBFolderType IN ('G', 'A','K'))) THEN 
		v_Status := PRTRaiseError('PRT_ERR_Cannot_AddFolder');
		OPEN ResultSet FOR SELECT v_Status AS MainCode;  
		RETURN ResultSet;
	ELSIF(v_PDBFolderRecord.FolderType <> v_DBFolderType ) THEN  
			v_Status := PRTRaiseError('PRT_ERR_Cannot_AddFolder');
			OPEN ResultSet FOR SELECT v_Status AS MainCode;  
			RETURN ResultSet;
	ELSIF(v_PDBFolderRecord.FolderLock = 'Y') THEN  
		/* Fetch effective lock by user and lock message */
		v_Output := CheckLock('F', v_DBParentFolderId, v_PDBFolderRecord.LockByUser, v_PDBFolderRecord.FolderLock, v_PDBFolderRecord.LockMessage);
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
			v_Status := PRTRaiseError('PRT_ERR_Folder_Locked');
			OPEN ResultSet FOR SELECT v_Status AS MainCode;  
			RETURN ResultSet;
		END IF; 
		v_FolLock		:= 'Y'; 
		v_FolLockByUser	:= v_PDBFolderRecord.LockByUser; 
	ELSIF(v_PDBFolderRecord.FinalizedFlag = 'Y') THEN 
		v_Status := PRTRaiseError('PRT_ERR_Finalised_Folder');
		OPEN ResultSet FOR SELECT v_Status AS MainCode;  
		RETURN ResultSet;
	END IF; 

	IF(v_PDBFolderRecord.FolderLevel >= 255) THEN  
		v_Status := PRTRaiseError('PRT_ERR_Max_Level_Count_Reached');
		OPEN ResultSet FOR SELECT v_Status AS MainCode;  
		RETURN ResultSet;
	END IF;  

	IF(v_LimitCount IS NOT NULL) THEN 
		SELECT INTO v_count COUNT(*) 
		FROM PDBFolder 
		WHERE ParentFolderIndex = v_DBParentFolderId  
		AND AccessType = v_DBAccessType; 

		IF(v_count >= v_LimitCount) THEN  
			v_Status := PRTRaiseError('PRT_ERR_Max_Folder_Count_Reached');
			OPEN ResultSet FOR SELECT v_Status AS MainCode;  
			RETURN ResultSet;
		END IF; 
	END IF; 

	/* Generate the name of the folder if the foldername given is NULL*/
	IF(v_DBFolderName IS NULL) THEN  
		v_Output := PRTGenerateDefaultName('F', v_DBParentFolderId, NULL, NULL, v_PDBFolderRecord.MainGroupId); 
		v_Posi1	:= STRPOS(v_Output, CHR(21));
		v_DBStatus := CAST(SUBSTR(v_Output, 1, v_Posi1 - 1) AS INTEGER);
		v_DBFolderName := SUBSTR(v_Output, v_Posi1 + 1);
		IF(v_DBStatus <> 0) THEN 
			v_Status := v_DBStatus; 
			OPEN ResultSet FOR SELECT v_Status AS MainCode;  
			RETURN ResultSet;
		END IF; 
	END IF; 

		v_Hierarchy := COALESCE(RTRIM(v_Hierarchy), '') || v_DBParentFolderId || '.'; 

		v_NewFolderIndex := NextVal('FolderId');

		INSERT INTO PDBFolder(FolderIndex,ParentFolderIndex, Name, Owner, CreatedDatetime, RevisedDateTime, 
			AccessedDateTime, DataDefinitionIndex, AccessType, ImageVolumeIndex, 
			FolderType, FolderLock, LockByUser, Location, DeletedDateTime, 
			EnableVersion, ExpiryDateTime, Comment, UseFulData, ACL, FinalizedFlag, 
			FinalizedDateTime, FinalizedBy, ACLMoreFlag, MainGroupId, EnableFTS, LockMessage, 
			Folderlevel)  
		VALUES (v_NewFolderIndex, v_DBParentFolderId, v_DBFolderName, v_DBUserId, v_CurrDate, v_CurrDate, 
			v_CurrDate, v_DBDataDefinitionIndex, v_DBAccessType, v_PDBFolderRecord.ImageVolumeIndex, 
			v_DBFolderType, v_FolLock, v_FolLockByUser, v_PDBFolderRecord.FolderType,TO_DATE('31-12-2099' ,'DD-MM-YYYY'), 
			COALESCE(v_DBVersionFlag, v_PDBFolderRecord.EnableVersion), v_ExpiryDateTime, COALESCE(v_DBComment,''), NULL, NULL, 'N', 
			TO_DATE('31-12-2099' ,'DD-MM-YYYY'), 0, 'N', v_PDBFolderRecord.MainGroupId, COALESCE(v_DBEnableFTS, v_PDBFolderRecord.EnableFTS), 
			v_LockMessage, v_PDBFolderRecord.FolderLevel + 1); 

		IF(v_DBDataDefinitionIndex > 0) THEN 
			IF(LENGTH(v_ColumnList) > 0) THEN 
				 v_ColumnList   := ' FoldDocIndex, FoldDocFlag' || v_ColumnList; 
				 v_ValueList    := TO_CHAR(v_NewFolderIndex, '99999') || ', ' || CHR(39) || 'F' || CHR(39) || v_ValueList; 
				 EXECUTE 'INSERT INTO ' || v_DDTTableName || ' ( ' || v_ColumnList || ' ) VALUES ( ' || v_ValueList || ')'; 
			END IF; 
			v_useFulDataStrStatus := PRTBuildUseFulDataString (v_NewFolderIndex, 'F', v_DBDataDefinitionIndex); 
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
	 
			v_TempStr := ''; 
			v_UniqueNameString := ';';
			WHILE(LENGTH(v_DBDocumentList) > 0) LOOP  
				v_DocumentType := NULL;
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
						v_DocumentSize := TO_NUMBER(RTRIM(SUBSTR(v_TempStr, 1, v_pos1 - 1)), '9999999999');					 
						v_TempStr 	:= SUBSTR(v_TempStr, v_pos1 + 1);
						v_pos1 	:= STRPOS( v_TempStr,CHR(21));
						IF(v_pos1 >1) THEN					 
							v_AppType	:= RTRIM(SUBSTR(v_TempStr, 1,v_pos1-1));
							
							v_TempStr	:= RTRIM(SUBSTR(v_TempStr, v_pos1+1));
							v_pos1 	 := STRPOS( v_TempStr,CHR(21));
							IF(v_pos1=2) THEN
								v_DocumentType := RTRIM(SUBSTR(v_TempStr, 1,v_pos1-1)); 
							    v_Comment 	:= RTRIM(SUBSTR(v_TempStr, v_pos1+1, LENGTH(v_TempStr)-2));
							ELSE
								IF(LENGTH(v_TempStr) = 1) THEN	
									v_DocumentType := RTRIM(SUBSTR(v_TempStr, 1, LENGTH(v_TempStr))); 
								    v_Comment	:= '';
								ELSE
									v_Comment   := RTRIM(SUBSTR(v_TempStr, 1, LENGTH(v_TempStr)));
								END IF;
							END IF;
						ELSE					 
							v_AppType	:= RTRIM(SUBSTR(v_TempStr, v_pos1+1));
							v_Comment	:= '';					 
						END IF;				 
					ELSE				 
						v_DocumentSize := TO_NUMBER(RTRIM(SUBSTR(v_TempStr, v_pos1+1)), '9999999999');
						v_AppType	:='TIF';
						v_Comment	:= ''; 
					END IF;	
					/*Bugzilla bug id 3129*/
					v_pos1 				:= STRPOS(v_ISIndexStr,CHR(35)); 
					v_ImageIndex 		:= CAST(LTRIM(RTRIM(SUBSTR(v_ISIndexStr, 1, v_pos1-1))) AS INTEGER); 
					v_VolumeIndex 		:= CAST(LTRIM(RTRIM(SUBSTR(v_ISIndexStr, v_pos1+1))) AS INTEGER);
					v_TempStr			:= '';
					/*Bugzilla bug id 3129*/
	                IF (v_DocumentType IS NULL OR v_DocumentType = NULL) THEN
						BEGIN
							IF(UPPER(v_AppType) = 'TIF' OR UPPER(v_AppType) = 'TIFF' OR UPPER(v_AppType) = 'BMP' OR UPPER(v_AppType) = 'JPEG' OR UPPER(v_AppType) = 'JPG' OR UPPER(v_AppType) = 'JIF' OR UPPER(v_AppType) = 'GIF' OR UPPER(v_AppType) = 'PDF') THEN  
								--Removing 'PNG' for bugzilla bugID - 88867 
								v_DocumentType := 'I'; 
							ELSE  
								v_DocumentType := 'N'; 
							END IF; 
						END;
					END IF;
					
					v_posNew := STRPOS(v_UniqueNameString, ';' || v_DocumentName || '.' || v_AppType || ';');
					IF (v_posNew > 0 ) THEN
						v_Output := GenerateName('D', v_DocumentName, v_NewFolderIndex, v_DocumentType, v_AppType, 255, v_PDBFolderRecord.MainGroupId, 'Y');
						v_Posi1	:= STRPOS(v_Output, CHR(21));
						v_DBStatus := CAST(SUBSTR(v_Output, 1, v_Posi1 - 1) AS INTEGER);
						v_DocumentName := SUBSTR(v_Output, v_Posi1 + 1);
						IF(v_DBStatus <> 0) THEN 
							v_Status := v_DBStatus; 
							OPEN ResultSet FOR SELECT v_Status AS MainCode;  
							RETURN ResultSet;
						END IF;
					ELSE
						 v_UniqueNameString := v_UniqueNameString  ||v_DocumentName || '.' || v_AppType || ';';  
					END IF;
					
					v_NewDocumentIndex := NextVal('DocumentID');

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
					 VALUES (v_NewDocumentIndex, 1.0,	'Original', 
						v_DocumentName, v_DBUserId, v_CurrDate, v_CurrDate, 
						v_CurrDate, 0, 
						v_PDBFolderRecord.EnableVersion, 'I', v_DocumentType, 
						0, v_DBUserId, 
						v_ImageIndex, v_VolumeIndex, v_NoOfPage, v_DocumentSize, 
						0, 'not defined', 
						'N', 'N', NULL, 
						v_Comment, v_UserName, 0, 0, 
						'XX', 'A', TO_DATE('31-12-2099' ,'DD-MM-YYYY'), 
						'N', TO_DATE('31-12-2099' ,'DD-MM-YYYY'), 0, 
						'N', 0, NULL, 
						NULL, 'not defined', 'N', v_AppType, 
						v_PDBFolderRecord.MainGroupId, 'N', 'N', NULL); 
					
					IF(NOT FOUND) THEN
						v_Status := 15; 
						OPEN ResultSet FOR SELECT v_Status AS MainCode;  
						RETURN ResultSet;
					END IF;
 
					v_NextOrder := v_NextOrder + 1; 
					INSERT INTO PDBDocumentContent(ParentFolderIndex, DocumentIndex, FiledBy, FiledDatetime, DocumentOrderNo, RefereceFlag) 				 VALUES(v_NewFolderIndex, v_NewDocumentIndex, v_DBUserId, v_CurrDate, v_NextOrder , 'O'); 
					v_DBDocumentIndexes = v_DBDocumentIndexes || v_DocumentName || CHR(21) || v_NewDocumentIndex || CHR(21) || v_ImageIndex || CHR(35) || v_VolumeIndex || CHR(25);
					IF(NOT FOUND) THEN
						v_Status := 15; 
						OPEN ResultSet FOR SELECT v_Status AS MainCode;  
						RETURN ResultSet;
					END IF;
					
					IF(v_Comment IS NULL) THEN  				
						v_FieldName:=v_DocumentName;				
					ELSE                
						v_FieldName:=v_DocumentName  ||  '(' ||  v_Comment ||  '.'  ||  v_AppType || ')';				
					END IF;

					v_MainCode :=WFGenerateLog(18, v_DBUserId,DBProcessDefId,v_ActivityId, v_QueueId, BTRIM(COALESCE(v_UserName,'')), coalesce(v_activityName, ''), 0, v_processInstanceId, v_QueueId ,v_FieldName , 1 , 0 , 0 , NULL , v_ProcessVariantId , 0 , 0, v_urnDup,NULL);
				END IF; 
			END LOOP;  
			v_WhileCounter := v_WhileCounter + 1; 
		END LOOP;
	  END IF;
	END;
		
		IF(v_DBSetAttributeLoggingEnabled = N'Y' AND v_DBRouteLogList IS NOT NULL AND LENGTH(v_DBRouteLogList) > 0 ) THEN
		BEGIN
			Insert into WFAttributeMessageTable (ProcessDefId,ProcessInstanceId ,WorkitemId, message, status, ActionDateTime) Values 
				(DBProcessDefId,v_ProcessInstanceId,1,v_DBRouteLogList,N'N',CURRENT_TIMESTAMP);
				
			v_fieldId := CURRVAL('wfattributemessagetable_messageid_seq');
			
			v_MainCode :=WFGenerateLog(75, v_DBUserId,DBProcessDefId,v_ActivityId, 0, BTRIM(COALESCE(v_UserName,'')), coalesce(v_ActivityName, ''), 0, v_processInstanceId, v_fieldId ,NULL , 1 , 0 , 0 , NULL , 0 , 0 , 0 , v_urnDup,NULL);
		END;
		END IF;
		v_QueryStr := 'SELECT A.UserDefinedName, A.SystemDefinedName, A.VariableType FROM VarMappingTable A, RecordMappingTable B WHERE A.ProcessDefId	= ' || DBProcessDefId || ' AND A.ProcessDefId = B.ProcessDefId AND A.VariableScope = ''M'' AND (UPPER(A.UserDefinedName) = UPPER(B.REC1) OR UPPER(A.UserDefinedName) = UPPER(B.REC2) OR UPPER(A.UserDefinedName) = UPPER(B.REC3) OR UPPER(A.UserDefinedName) = UPPER(B.REC4) OR UPPER(A.UserDefinedName) = UPPER(B.REC5))'; 

		OPEN v_sysattrcur FOR EXECUTE v_QueryStr;
		LOOP 
			FETCH v_sysattrcur INTO v_UserDefinedName, v_SystemDefinedName, v_VariableType;
			IF(NOT FOUND) THEN
				EXIT;
			END IF;
			IF(UPPER(LTRIM(RTRIM(v_UserDefinedName))) = 'ITEMINDEX') THEN 
				IF(	v_SharepointFlag = 'N') THEN
					v_Var_Rec_1 := CAST(v_NewFolderIndex AS VARCHAR);  
				ELSIF(v_SharepointFlag = 'Y') THEN
					v_Var_Rec_1 := CHR(39) || v_FolderIdSP || CHR(39); 
				END IF;
				IF(v_UpdateFlag = 'Y')  THEN 
					 v_UpdateColumnStr:= RTRIM(v_UpdateColumnStr) || ', ' || v_SystemDefinedName ; 
					 v_UpdateValueStr := v_UpdateValueStr || ', ' || CHR(39) || RTRIM(v_Var_Rec_1) || CHR(39); 
				ELSE  
					 v_UpdateFlag	:= 'Y'; 
					 v_UpdateColumnStr := RTRIM(v_SystemDefinedName); 
					 v_UpdateValueStr  := RTRIM(v_Var_Rec_1); 
				END IF; 
				v_InsertExtColumnStr := v_InsertExtColumnStr || ', ' || v_UserDefinedName; 
				v_InsertExtValueStr  := v_InsertExtValueStr || ', ' || RTRIM(v_Var_Rec_1);  
			ELSIF(UPPER(LTRIM(RTRIM(v_UserDefinedName))) = 'ITEMTYPE') THEN 
				v_Var_Rec_1 	:= CHR(39) || 'F' || CHR(39) ; 
				IF(v_UpdateFlag = 'Y') THEN 
					v_UpdateColumnStr:= RTRIM(v_UpdateColumnStr) || ', ' || v_SystemDefinedName ; 
					v_UpdateValueStr := LTRIM(RTRIM(v_UpdateValueStr)) || ', ' || RTRIM(v_Var_Rec_1); 
				ELSE 
					v_UpdateFlag := 'Y'; 
					v_UpdateColumnStr := RTRIM(v_SystemDefinedName); 
					v_UpdateValueStr  :=  RTRIM(v_Var_Rec_1) ; 
				END IF; 
				v_InsertExtColumnStr := v_InsertExtColumnStr || ', ' || v_UserDefinedName; 
				v_InsertExtValueStr  := v_InsertExtValueStr || ', ' || v_Var_Rec_1; 
			ELSE  
				v_Var_Rec_1 := ' NULL '; 
				v_InsertExtColumnStr := v_InsertExtColumnStr || ', ' || v_UserDefinedName; 
				v_InsertExtValueStr  := v_InsertExtValueStr || ', ' || v_Var_Rec_1; 
			END IF; 
		END LOOP; 
		CLOSE v_sysattrcur;
		v_ValidTill := NULL;
		--v_ValidTill :=Coalesce(v_ValidTill,to_timestamp('31-12-2099' ,'DD-MM-YYYY'));
		 /* ______________________________________________________________________________________
			// Changed On  : 07/07/2009
			// Changed By  : Saurabh Kamal
			// Description : WFS_8.0_010, IF-ELSE added.Inserting ProcessInstanceState as 1 and 
			//		 IntroducedByID, IntroducedBy,IntroductionDatetime as NULL		 
			// ____________________________________________________________________________________*/
		
		IF((DBInitiateAlso = 'Y') AND (synFlag='N')) THEN
			v_QueryStr := 'Insert Into WFInstrumentTable (URN,ProcessInstanceId, ProcessDefID, Createdby, CreatedDatetime,ProcessinstanceState,
				CreatedByName,IntroducedByID, IntroducedBy,IntroductionDatetime,ExpectedProcessDelay, IntroducedAt,WorkItemId,ProcessName,
				ProcessVersion,LastProcessedBy,	ProcessedBy,ActivityName,ActivityId,ActivityType,EntryDateTime,AssignmentType,CollectFlag,PriorityLevel,
				ValidTill,Q_StreamId,Q_QueueId,Q_UserId,AssignedUser,FilterValue, WorkItemState,Statename,ExpectedWorkitemDelay,
				PreviousStage,LockedByName,LockStatus,LockedTime,Queuename,Queuetype,NotifyStatus,RoutingStatus,ProcessVariantId,SaveStage, 
				InstrumentStatus, CheckListCompleteFlag' || COALESCE(v_DBQDTColumnList, ' ') || ', ' || v_UpdateColumnStr ||', Locale )
			Values ('||CHR(39) ||  v_urn ||CHR(39)||',N' || CHR(39) || v_ProcessInstanceId || CHR(39)||', '|| CAST(DBProcessDefId AS Varchar)||','|| CAST( v_DBUserId AS VarChar)||',
			CURRENT_TIMESTAMP,2, N'|| CHR(39) ||BTRIM(COALESCE(v_UserName,''))|| CHR(39) || ','||CAST( v_DBUserId AS VarChar)||',N'|| CHR(39) ||BTRIM(COALESCE(v_UserName,''))|| CHR(39) ||',CURRENT_TIMESTAMP,
			'|| CHR(39) ||DBExpectedProcessDelay|| CHR(39) || ', N'|| CHR(39) ||v_ActivityName|| CHR(39)||',1,
			N'|| CHR(39) ||v_ProcessName|| CHR(39)||', '|| CAST(v_ProcessVersion AS VARCHAR)||','|| CAST(v_DBUserId AS VARCHAR)||',
			N'|| CHR(39) ||BTRIM(COALESCE(v_UserName,''))|| CHR(39)||', N'|| CHR(39) ||v_ActivityName|| CHR(39)||',
			'|| CAST(v_ActivityId AS VARCHAR)||',1,CURRENT_TIMESTAMP,N'|| CHR(39) ||'Y'|| CHR(39)||',
			N'|| CHR(39) ||'N'|| CHR(39)||','|| CAST(DBPriorityLevel AS VARCHAR)||',null,
			NULL,NULL,NULL,NULL,NULL,6,
			N'|| CHR(39) ||'COMPLETED'|| CHR(39)||',NULL,N'|| CHR(39) ||v_ActivityName|| CHR(39)||',NULL,N'|| CHR(39) ||'N'|| CHR(39)||',
			CURRENT_TIMESTAMP,NULL,NULL,NULL,
			N'|| CHR(39) ||'Y'|| CHR(39)||','||CAST( v_ProcessVariantId AS VarChar)||',N'|| CHR(39) ||v_ActivityName|| CHR(39)||' ,
			N'|| CHR(39) ||'N'|| CHR(39)||', N'|| CHR(39) ||'N'|| CHR(39) || COALESCE(v_DBQDTValueList, ' ') || ',' || v_UpdateValueStr ||' , N'||CHR(39)|| COALESCE(v_locale,'en_US')||CHR(39)||' )';
		ELSE
				
			v_QueryStr := 'Insert Into WFInstrumentTable (URN,ProcessInstanceId, ProcessDefID, Createdby, CreatedDatetime,ProcessinstanceState,
				CreatedByName,IntroducedByID, IntroducedBy,IntroductionDatetime,ExpectedProcessDelay, IntroducedAt,WorkItemId,ProcessName,
				ProcessVersion,LastProcessedBy,	ProcessedBy,ActivityName,ActivityId,ActivityType,EntryDateTime,AssignmentType,CollectFlag,PriorityLevel,
				ValidTill,Q_StreamId,Q_QueueId,Q_UserId,AssignedUser,FilterValue, WorkItemState,Statename,ExpectedWorkitemDelay,
				PreviousStage,LockedByName,LockStatus,LockedTime,Queuename,Queuetype,NotifyStatus,RoutingStatus,ProcessVariantId,SaveStage, 
				InstrumentStatus, CheckListCompleteFlag' || COALESCE(v_DBQDTColumnList, ' ') || ', ' || COALESCE(v_UpdateColumnStr,'') ||' , Locale)
			Values ('||CHR(39) ||  v_urn ||CHR(39)||',N' || CHR(39) || COALESCE(v_ProcessInstanceId,'') || CHR(39)||', '|| CAST(DBProcessDefId AS VARCHAR)||','|| CAST(v_DBUserId AS VARCHAR)||',
			CURRENT_TIMESTAMP,1, N'|| CHR(39) ||BTRIM(COALESCE(v_UserName,''))|| CHR(39) || ',NULL,NULL,NULL,
			'|| CHR(39) || DBExpectedProcessDelay || CHR(39) || ', N'|| CHR(39) ||COALESCE(v_ActivityName,'')|| CHR(39)||',1, 
			'|| CHR(39) ||COALESCE(v_ProcessName,'')|| CHR(39)||', '|| CAST(v_ProcessVersion AS VARCHAR)||', '|| CAST(v_DBUserId AS VARCHAR)||',
			'|| CHR(39) ||BTRIM(COALESCE(v_UserName,''))|| CHR(39)||', N'|| CHR(39) ||COALESCE(v_ActivityName,'')|| CHR(39)||', 
			'|| CAST(v_ActivityId AS VARCHAR)||',1, CURRENT_TIMESTAMP,N'|| CHR(39) ||'S'|| CHR(39)||',
			'|| CHR(39) ||'N'|| CHR(39)||','|| CAST(DBPriorityLevel AS VARCHAR)||',null,
			'|| CAST(v_StreamId AS VARCHAR)||','|| CAST(v_QueueId AS VARCHAR)||',NULL,NULL,NULL,1,
			'|| CHR(39) ||'NOTSTARTED'|| CHR(39)||',NULL,'|| CHR(39) ||v_ActivityName|| CHR(39)||',NULL,N'|| CHR(39) ||'N'|| CHR(39)||',
			NULL,'|| CHR(39) || COALESCE(v_QueueName,'')|| CHR(39)||', '|| CHR(39) ||'I'|| CHR(39)||','|| CHR(39) ||'N'|| CHR(39)||','|| CHR(39) ||'N'|| CHR(39)||','||CAST( v_ProcessVariantId AS VarChar)||','
			|| CHR(39) ||COALESCE(v_ActivityName,'')|| CHR(39)||' , N'|| CHR(39) ||'N'|| CHR(39)||',
			'|| CHR(39) ||'N' || CHR(39) || COALESCE(v_DBQDTValueList, ' ') || ',' || COALESCE(v_UpdateValueStr,'')||' , N'||CHR(39)|| COALESCE(v_locale,'en_US') ||CHR(39)|| ' )';
		END IF;
		--Raise Notice '@847 vqryStr>>>(%)',v_QueryStr;
		--Raise Notice '@848 DBExpectedProcessDelay,v_UpdateColumnStr,v_ActivityName,v_UserName,v_UpdateValueStr,DBProcessDefId,v_DBUserId,v_ProcessVersion,v_ActivityId>>>(%,%,%,%,%,%,%,%,%)',DBExpectedProcessDelay,v_UpdateColumnStr,v_ActivityName,v_UserName,v_UpdateValueStr,DBProcessDefId,v_DBUserId,v_ProcessVersion,v_ActivityId;
		EXECUTE v_QueryStr; 
		IF((LENGTH(v_InsertExtColumnStr) > 0) AND (LENGTH(v_TableViewName) > 0))THEN
			BEGIN
				IF (v_DBEXTColumnList IS NULL) THEN
					v_InsertExtColumnStr := SUBSTR(v_InsertExtColumnStr,2); 
					v_InsertExtValueStr  := SUBSTR(v_InsertExtValueStr, 2); 	
				END IF;			
				v_QueryStr := ' INSERT INTO ' || v_TableViewName || ' ( ' || COALESCE(v_DBEXTColumnList,'') || COALESCE(v_InsertExtColumnStr,'') || ' ) VALUES ( ' || COALESCE(v_DBEXTValueList,'') || COALESCE(v_InsertExtValueStr,'') || ' ) ';
				--Raise Notice '@887 >>(%)',v_QueryStr;			
				EXECUTE v_QueryStr;
				EXCEPTION
						WHEN OTHERS THEN
						v_Status = 4012;
						v_DBMsg :=  SQLERRM;
						v_DBTblNm := v_TableViewName;
						OPEN ResultSet FOR SELECT v_Status AS MainCode,v_DBMsg AS DBMsg , v_DBTblNm AS DBTblNm;
						RETURN ResultSet;
			END;
		END IF; 
		INSERT INTO WFMessageTable (message, status, ActionDateTime)  
		values	('<Message><ActionId>1</ActionId><UserId>' || v_DBUserId || 
				'</UserId><ProcessDefId>' || DBProcessDefId || 
				'</ProcessDefId><ActivityId>0</ActivityId><QueueId>0</QueueId><UserName>' || 
				COALESCE(v_UserName,'') || '</UserName><ActivityName>' || COALESCE(v_ActivityName,'') || 
				'</ActivityName><TotalWiCount>1</TotalWiCount><TotalDuration>0</TotalDuration><ActionDateTime>' 
				|| TO_CHAR(CURRENT_TIMESTAMP, 'YYYY-MM-DD HH24:MI:SS') || 
				'</ActionDateTime><EngineName></EngineName><ProcessInstance>' || v_ProcessInstanceId || 
				'</ProcessInstance><FieldId>' || v_QueueId || '</FieldId><WorkitemId>1</WorkitemId><TotalPrTime>0</TotalPrTime><DelayTime>0</DelayTime><WKInDelay>0</WKInDelay><ReportType>D</ReportType><LoggingFlag>3</LoggingFlag></Message>', 
			'N', CURRENT_TIMESTAMP 
		);
		v_MainCode := WFGenerateLog(1, v_DBUserId,DBProcessDefId,v_ActivityId, v_QueueId, BTRIM(COALESCE(v_UserName,'')), coalesce(v_ActivityName, ''), 0, v_processInstanceId, v_QueueId ,COALESCE(v_FieldName,'') , 1 , 0 , 0 , NULL , v_ProcessVariantId , 0 , 0, v_urnDup,NULL);
		v_DBStatus := 0; 
/*Need to be corrected later on by uncommenting the below mentioned lines as this has been done in OF 10X for auditing done through WFUploadWOrkitme is called with Attributes tag:
	IF(v_DBSetAttributeLoggingEnabled = N'Y' AND v_DBRouteLogList IS NOT NULL AND LENGTH(v_DBRouteLogList) > 0 ) THEN
		BEGIN
			Insert into WFAttributeMessageTable (ProcessDefId,ProcessInstanceId ,WorkitemId, message, status, ActionDateTime) Values 
				(DBProcessDefId,v_ProcessInstanceId,1,v_DBRouteLogList,N'N',CURRENT_TIMESTAMP);
				
			v_fieldId := CURRVAL('wfattributemessagetable_messageid_seq');
			
			SELECT 1 INTO existflag FROM PG_TABLES  WHERE UPPER(TABLENAME) = UPPER('WFCURRENTROUTELOGTABLE');
			IF(NOT FOUND) THEN 
					v_QueryStr1 := 'Insert into CURRENTROUTELOGTABLE (LogId,ProcessDefId, ActivityId, ProcessInstanceId, WorkItemId, UserId, ActionId, 		ActionDateTime, AssociatedFieldId, AssociatedFieldName, ActivityName, UserName) 
					values('||NEXTVAL('wfcurrentroutelogtable_logid_seq')||','||DBProcessDefId||','||v_ActivityId||','|| CHR(39)|| v_ProcessInstanceId || CHR(39) ||',1,'||v_DBUserId||',75,CURRENT_TIMESTAMP,'||v_fieldId||',NULL,'|| CHR(39)||v_ActivityName|| CHR(39)||','|| CHR(39) ||BTRIM(COALESCE(v_UserName,''))|| CHR(39) ||')';
					Execute v_QueryStr1;
			ELSE
					v_QueryStr1 := 'Insert into WFCURRENTROUTELOGTABLE (LogId,ProcessDefId, ActivityId, ProcessInstanceId, WorkItemId, UserId, ActionId, ActionDateTime,AssociatedDateTime, AssociatedFieldId, AssociatedFieldName, ActivityName, UserName,NewValue, QueueId) 
					values('||NEXTVAL('wfcurrentroutelogtable_logid_seq')||','||DBProcessDefId||','||v_ActivityId||','|| CHR(39)|| v_ProcessInstanceId || CHR(39) ||',1,'||v_DBUserId||',75,CURRENT_TIMESTAMP,NULL,'||v_fieldId||',NULL,'|| CHR(39)|| v_ActivityName|| CHR(39)||','|| CHR(39) ||BTRIM(COALESCE(v_UserName,''))|| CHR(39) ||',NULL,0)';
					Execute v_QueryStr1;
			END IF;
		END;
		END IF;*/

		IF((DBInitiateAlso = 'Y' ) AND (synFlag='Y')) THEN		
--			SELECT INTO v_datediff1, v_datediff2
--						(CURRENT_TIMESTAMP - A.createdDateTime), (CURRENT_TIMESTAMP - A.lockedTime)  
--			FROM WorkDoneTable A  
--			WHERE A.ProcessInstanceId = v_ProcessInstanceId; 
--			IF(NOT FOUND) THEN
--				v_DBTotalDuration := 0; 
--				v_DBTotalPrTime := 0; 
--			END IF;
		--	SELECT INTO  v_DBTotalDuration,v_DBTotalPrTime (CURRENT_TIMESTAMP - createdDateTime), (CURRENT_TIMESTAMP -lockedTime)  
			SELECT INTO  v_DBTotalDuration,v_DBTotalPrTime 
			(Current_date - to_date(to_char( createdDateTime,'YYYY-MM-DD'),'YYYY-MM-DD')), 
            (Current_date - to_date(to_char(lockedTime,'YYYY-MM-DD'),'YYYY-MM-DD'))
 					  FROM WFInstrumentTable   
			WHERE ProcessInstanceId = v_ProcessInstanceId 
			AND RoutingStatus = 'Y' 
			AND LockStatus = 'N';
			IF(NOT FOUND) THEN
				v_DBTotalDuration := 0; 
				v_DBTotalPrTime := 0; 
			END IF;
			
			v_DBTotalDuration := COALESCE(v_DBTotalDuration * 24 * 60 * 60, 0); 
			v_DBTotalPrTime   := COALESCE(v_DBTotalPrTime * 24 * 60 * 60, 0); 

			INSERT INTO WFMessageTable (message, status, ActionDateTime)  
			values('<Message><ActionId>2</ActionId><UserId>' || v_DBUserId || 
				'</UserId><ProcessDefId>' || DBProcessDefId || 
				'</ProcessDefId><ActivityId>' || v_ActivityId || 
				'</ActivityId><QueueId>'|| v_QueueId || 
				'</QueueId><UserName>' || BTRIM(COALESCE(v_UserName,'')) || 
				'</UserName><ActivityName>' || COALESCE(v_ActivityName,'') || 
				'</ActivityName><TotalWiCount>1</TotalWiCount><TotalDuration>' || 
				v_DBTotalDuration || '</TotalDuration><ActionDateTime>' || 
				 TO_CHAR(CURRENT_TIMESTAMP, 'YYYY-MM-DD HH24:MI:SS') || 
				 '</ActionDateTime><EngineName></EngineName><ProcessInstance>' || v_ProcessInstanceId || 
				'</ProcessInstance><FieldId>' || v_QueueId || 
				'</FieldId><FieldName>NULL</FieldName><WorkitemId>1</WorkitemId><TotalPrTime>' || 
				v_DBTotalPrTime || 
				'</TotalPrTime><DelayTime>0</DelayTime><WKInDelay>0</WKInDelay><ReportType>D</ReportType><LoggingFlag>3</LoggingFlag></Message>', 
				'N', CURRENT_TIMESTAMP
			);  
			
			v_MainCode := WFGenerateLog(2, v_DBUserId,DBProcessDefId,v_ActivityId, v_QueueId, BTRIM(COALESCE(v_UserName,'')), coalesce(v_ActivityName, ''), 0, v_processInstanceId, v_QueueId ,COALESCE(v_FieldName,'') , 1 , 0 , 0 , NULL , v_ProcessVariantId , 0 , 0, v_urnDup,NULL);
		END IF;
		
		IF(v_ValidationReqd1 IS NOT NULL AND v_ValidateQuery IS NOT NULL) THEN 		
			EXECUTE v_ValidateQuery;
			GET DIAGNOSTICS v_rowCount = ROW_COUNT;
			IF(v_rowCount < 1) THEN
				v_Status := 15; 
				OPEN ResultSet FOR SELECT v_Status AS MainCode;  
				RETURN ResultSet;
			END IF;
		END IF; 

		OPEN ResultSet FOR SELECT v_DBStatus, v_DBFolderName, v_CurrDate, v_NewFolderIndex, v_DBDocumentIndexes;
		RETURN ResultSet;
 END;
$$LANGUAGE plpgsql;