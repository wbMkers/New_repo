/*__________________________________________________________________________________________________________________
			NEWGEN SOFTWARE TECHNOLOGIES LIMITED
____________________________________________________________________________________________________________________
	Group						: Phoenix
	Product / Project			: Omniflow 8.1
	Module						: WorkFlow Server
	File Name					: WFGenerateRegistration.sql
	Author						: Saurabh Kamal
	Date written (DD/MM/YYYY)	: 18/08/2010
	Description					: Stored procedure to generate Registration Number while invoked from WFUploadWorkitem API.
____________________________________________________________________________________________________________________
				CHANGE HISTORY
____________________________________________________________________________________________________________________

Date			Change By		Change Description (Bug No. (If Any))
____________________________________________________________________________________________________________________
___________________________________________________________________________________________________________________*/
CREATE OR REPLACE FUNCTION WFGenerateRegistration(INTEGER, INTEGER, VARCHAR, INTEGER, VARCHAR, VARCHAR) RETURNS REFCURSOR AS '
DECLARE
	v_DBUserId						ALIAS FOR $1;
	v_DBProcessDefId				ALIAS FOR $2;
	v_ValidationReqd				ALIAS FOR $3;
	v_InitiateFromActivityId		ALIAS FOR $4;
	v_InitiateFromActivityName		ALIAS FOR $5;
	v_DataDefinitionName			ALIAS FOR $6;
	
	v_ValidateQuery				VARCHAR(2000);
	v_ValidationReqd1			VARCHAR(1000); 
	v_pos1						INTEGER; 
	v_Temp						INTEGER; 
	v_TempTableName				VARCHAR(255);
	v_TempColumnName			VARCHAR(255); 
	v_TempColumnType			VARCHAR(10); 
	v_TempValue					VARCHAR(500); 
	v_valcur					INTEGER; 
	v_QueryStr					VARCHAR(8000); 
	v_retval					INTEGER;
	v_DBStatus					INTEGER;
	v_ActivityId				INTEGER;
	v_ActivityName				VARCHAR(30);
	v_DBDataDefinitionIndex		INTEGER; 
	v_MainGroupId				INTEGER;
	v_DDTTableName				VARCHAR(255);
	v_DBParentFolderId			INTEGER;
	v_QueueName					VARCHAR(255); 
	v_QueueId					INTEGER; 
	v_StreamId					INTEGER; 
	v_Length					INTEGER;
	v_RegPrefix					VARCHAR(20); 
	v_RegSuffix					VARCHAR(20); 
	v_RegStartingNo				VARCHAR(20);
	v_RegSeqLength				INTEGER; 
	v_ProcessName				VARCHAR(64); 
	v_ProcessVersion 			INTEGER; 
	v_ProcessInstanceId			VARCHAR(50); 
	v_UserName					VARCHAR(100);
	v_mainCode					INTEGER;
	ResultSet					REFCURSOR;
	v_ValCursor					REFCURSOR; 
	
	BEGIN
		v_mainCode	:= 0;
		SELECT INTO v_UserName ,v_MainGroupId UserName, MainGroupId 
		FROM 	PDBUser 
		WHERE 	UserIndex = v_DBUserId;
		
		IF(NOT FOUND) THEN
			v_UserName	:= NULL;
			v_mainCode	:= 15;	
			OPEN ResultSet FOR SELECT v_mainCode AS MainCode;
			RETURN ResultSet;
		END IF;	
		v_ValidationReqd1 := v_ValidationReqd; 
		IF(v_ValidationReqd1 IS NOT NULL)	THEN
			v_pos1				:= STRPOS(v_ValidationReqd1,CHR(21)); 
			v_TempTableName		:= SUBSTR(v_ValidationReqd1, 1, v_pos1-1); 
			v_ValidationReqd1	:= SUBSTR(v_ValidationReqd1, v_pos1+1); 
			v_pos1				:= STRPOS(v_ValidationReqd1,CHR(21)); 
			v_TempColumnName	:= SUBSTR(v_ValidationReqd1, 1, v_pos1-1); 
			v_ValidationReqd1	:= SUBSTR(v_ValidationReqd1, v_pos1+1); 
			v_pos1				:= STRPOS( v_ValidationReqd1,CHR(25)); 
			v_TempValue			:= RTRIM(SUBSTR(v_ValidationReqd1, 1, v_pos1-1));
				
			SELECT INTO v_TempColumnType DATA_TYPE  			  
			FROM USER_TAB_COLUMNS  
			WHERE  	TABLE_NAME 	= v_TempTableName  
			AND 	COLUMN_NAME 	= v_TempColumnName;
			
			IF(NOT FOUND) THEN
				v_TempColumnType := NULL; 
				v_mainCode	:= 15;	
				OPEN ResultSet FOR SELECT v_mainCode AS MainCode;
				RETURN ResultSet;
			END IF;

			IF UPPER(v_TempColumnType) IN (''VARCHAR2'', ''CHAR'', ''DATE'') THEN 
				v_TempValue := CHR(39) || v_TempValue || CHR(39); 
			END IF; 

			OPEN v_ValCursor FOR EXECUTE ''SELECT 1 FROM '' || v_TempTableName || '' WHERE '' || v_TempColumnName || '' = '' || v_TempValue;
			FETCH v_ValCursor INTO v_Temp;
			IF(FOUND) THEN
				v_DBStatus	:=  50; 
				v_mainCode		:= v_DBStatus; 
				CLOSE v_ValCursor;
				OPEN ResultSet FOR SELECT v_mainCode AS MainCode;
				RETURN ResultSet;
			END IF;
			CLOSE v_ValCursor;
			v_ValidateQuery := ''INSERT INTO ''|| v_TempTableName ||'' ( ''|| v_TempColumnName ||'' ) ''||'' VALUES ( ''|| v_TempValue ||'' ) '';
		END IF;
		
		IF(v_InitiateFromActivityId > 0) THEN
			SELECT INTO v_ActivityId, v_ActivityName ActivityId, ActivityName 
			FROM	ActivityTable 
			WHERE	ProcessDefID	= v_DBProcessDefId 
			AND	ActivityType	= 1 
			AND	ActivityId	= v_InitiateFromActivityId;
			IF(NOT FOUND) THEN
				v_mainCode := 603;
				OPEN ResultSet FOR SELECT v_mainCode AS MainCode;
				RETURN ResultSet;
			END IF;
		ELSIF(v_InitiateFromActivityName IS NOT NULL AND LENGTH(RTRIM(v_InitiateFromActivityName)) > 0 )	THEN
			SELECT INTO v_ActivityId, v_ActivityName ActivityId, ActivityName 			
			FROM	ActivityTable 
			WHERE	ProcessDefID = v_DBProcessDefId 
			AND	ActivityType = 1 
			AND	UPPER(ActivityName) = UPPER(RTRIM(v_InitiateFromActivityName)); 
			IF(NOT FOUND) THEN
				v_mainCode := 603;
				OPEN ResultSet FOR SELECT v_mainCode AS MainCode;
				RETURN ResultSet;
			END IF;
		ELSE
			SELECT INTO	v_ActivityId, v_ActivityName ActivityId, ActivityName 			
			FROM	ActivityTable 
			WHERE	ProcessDefID = v_DBProcessDefId 
			AND	ActivityType = 1 
			AND	PrimaryActivity = ''Y'';		/* Default Introduction workstep */ 
		END IF;
		
		IF(v_DataDefinitionName IS NOT NULL) THEN
			SELECT 	INTO v_DBDataDefinitionIndex DataDefIndex 
			FROM 	PDBDataDefinition 
			WHERE 	RTRIM(upper(DataDefName)) = RTRIM(upper(v_DataDefinitionName)) 
			AND 	GroupId = v_MainGroupId; 
			IF(NOT FOUND) THEN
				v_mainCode := PRTRaiseError(''PRT_ERR_DDI_Not_Exist'');
				OPEN ResultSet FOR SELECT v_mainCode AS MainCode;  
				RETURN ResultSet;
			END IF;
			v_DDTTableName := ''DDT_'' || v_DBDataDefinitionIndex; 
		ELSE 
			 v_DBDataDefinitionIndex  := 0; 	
		END IF;
		
		SELECT   INTO v_DBParentFolderId  WorkFlowFolderId 
		FROM   RouteFolderDefTable 
		WHERE  ProcessDefId = v_DBProcessDefId; 
		IF(NOT FOUND) THEN			 
			v_mainCode := PRTRaiseError(''PRT_ERR_Invalid_Parameter'');
			OPEN ResultSet FOR SELECT v_mainCode AS MainCode;  
			RETURN ResultSet;
		END IF;
		
		SELECT 	INTO v_QueueName, v_QueueId, v_StreamId 
					QUEUEDEFTABLE.QUEUENAME, QUEUEDEFTABLE.QUEUEID, QUEUESTREAMTABLE.STREAMID 
		FROM 	QUEUESTREAMTABLE, QUserGroupView , ACTIVITYTABLE , QUEUEDEFTABLE 
		WHERE 	ACTIVITYTABLE.PROCESSDEFID 	= v_DBProcessDefId 
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
			v_mainCode := 300;
			OPEN ResultSet FOR SELECT v_mainCode AS MainCode;  
			RETURN ResultSet;
		END IF;
		
		UPDATE ProcessDefTable SET RegStartingNo = RegStartingNo + 1 WHERE ProcessDefID = v_DBProcessDefId; 
		
		SELECT	INTO v_RegPrefix,v_RegSuffix,v_RegStartingNo,v_RegSeqLength,v_ProcessName,v_ProcessVersion
		RegPrefix, RegSuffix, RegStartingNo, RegSeqLength, ProcessName, VersionNo
		FROM	ProcessDefTable 
		WHERE	ProcessDefID	= v_DBProcessDefId;

		IF(NOT FOUND) THEN
			v_mainCode := 15;
			OPEN ResultSet FOR SELECT v_mainCode AS MainCode;  
			RETURN ResultSet;
		END IF;			
		
		v_RegPrefix		:= v_RegPrefix || ''-''; 
		v_RegSuffix		:= ''-'' || v_RegSuffix ;

		IF(LENGTH(v_RegStartingNo) > (v_RegSeqLength - LENGTH(v_RegPrefix) - LENGTH(v_RegSuffix))) THEN  
			v_mainCode := 19;
			OPEN ResultSet FOR SELECT v_mainCode AS MainCode;  
			RETURN ResultSet;
		END IF;
		
		v_Length			:= v_RegSeqLength - LENGTH(v_RegPrefix) - LENGTH(v_RegSuffix); 
		v_ProcessInstanceId	:= RPAD(''0'', v_Length, ''0'');
		v_ProcessInstanceId	:= v_RegPrefix || SUBSTR(v_ProcessInstanceId, 1, LENGTH(v_ProcessInstanceId) - LENGTH(v_RegStartingNo)) || v_RegStartingNo || v_RegSuffix; 
		
		OPEN ResultSet FOR SELECT v_mainCode AS MainCode, v_ProcessInstanceId AS ProcessInstanceId, v_DBParentFolderId AS ParentFolderIndex, v_DBDataDefinitionIndex AS DataDefinitionIndex, v_ActivityId AS ActivityId, v_MainGroupId AS MainGroupId, v_ActivityName AS ActivityName, v_QueueId AS QueueId, v_QueueName AS QueueName, v_ValidateQuery AS ValidateQuery, v_StreamId AS StreamId;
		RETURN ResultSet;
	END;
	
'
LANGUAGE 'plpgsql';