/*__________________________________________________________________________________________________________________
			NEWGEN SOFTWARE TECHNOLOGIES LIMITED
____________________________________________________________________________________________________________________
	Group						: Genesis.
	Product / Project			: iBPS
	Module						: WorkFlow Server
	File Name					: WFGenerateRegistration.sql
	Author						: Sajid Khan
	Date written (DD/MM/YYYY)	: 09 May 2016
	Description					: Stored procedure to generate Registration Number while invoked from WFUploadWorkitem API.
____________________________________________________________________________________________________________________
				CHANGE HISTORY
____________________________________________________________________________________________________________________

Date			Change By		Change Description (Bug No. (If Any))
27/02/2017		RishiRam Meel   PRDP Bug  Merging 67207 - Unable to create workitem on different versions of a process.
23/05/2017		Sajid Khan		Bug 69428 - IBPS3.0+Postgres:-Unable to create WI it shows error.
24/10/2017        Kumar Kimil         Case Registration requirement--Upload Workitem changes
21/11/2017		Ambuj Tripathi	Bug 73643 - User-desktop:: Getting error message when clicking on new while creating workitem, increased the size of v_displayName variable from 10 to 20.
29/12/2017      Kumar Kimil     Bug 74438 - jbossEAP+Postgres:-unable to create WI it shows error  .
05/02/2018      Kumar Kimil     Bug 75705 - Weblogic+ Oracle + SSL: By default WI's are coming with Process Instance Id's and quick search through Registration No. is not working
22/04/2018  Ambuj Tripathi		Bug 76862 - Remove the db console messages from all procedures
01/10/2018  	Ambuj Tripathi		Changes related to sharepoint support
13/08/2020      Ravi Raj Mewara     Bug 94091 - iBPS 4.0 SP1 : Unable to create workitem after upgrade when process name contain'-'
12/01/2021		chitranshi nitharia	changes done for upload error handling.
____________________________________________________________________________________________________________________
___________________________________________________________________________________________________________________*/
CREATE OR REPLACE FUNCTION WFGenerateRegistration
	(
		v_DBUserId						INTEGER,
		v_DBProcessDefId				INTEGER,
		v_ValidationReqd				VARCHAR,
		v_InitiateFromActivityId		INTEGER,
		v_InitiateFromActivityName		VARCHAR,
		v_DataDefinitionName			VARCHAR,
		v_DBProcessVariantId			INTEGER,
		PSFlag							VARCHAR,
	    v_HyphenRequired				CHAR(4) = 'N'
	
	)  RETURNS REFCURSOR AS $$
DECLARE	
	existsFlag					INTEGER;
	seq_existFlag				INTEGER;
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
	v_DBParentFolderId			VARCHAR(255);
	v_QueueName					VARCHAR(255); 
	v_QueueId					INTEGER; 
	v_StreamId					INTEGER; 
	v_Length					INTEGER;
	v_RegPrefix					VARCHAR(50); 
	v_RegSuffix					VARCHAR(25); 
	v_RegStartingNo				VARCHAR(20);
	v_RegSeqLength				INTEGER; 
	v_ProcessName				VARCHAR(64); 
	v_ProcessVersion 			INTEGER; 
	v_ProcessInstanceId			VARCHAR(63); 
	v_UserName					VARCHAR(100);
	v_mainCode					INTEGER;
	ResultSet					REFCURSOR;
	v_ValCursor						REFCURSOR; 
	v_PName                     VARCHAR(64);
	v_VersionNo                 INTEGER;
	v_SequenceName				VARCHAR(100);
	v_RegNo                     INTEGER;
	v_ProcessType				VARCHAR(1);
	v_displayName               Varchar(20);
	v_urn                       Varchar(63);
	v_DBTblNm					Varchar(1000); 
	BEGIN
		v_mainCode	:= 0;
		SELECT INTO v_UserName ,v_MainGroupId UserName, MainGroupId 
		FROM 	PDBUser 
		WHERE 	UserIndex = v_DBUserId;
		--RAISE NOTICE 'Starting';
		IF(NOT FOUND) THEN
			
			v_UserName	:= NULL;
			v_mainCode	:= 15;	
			OPEN ResultSet FOR SELECT v_mainCode AS MainCode;
			RETURN ResultSet;
		END IF;	
		v_ValidationReqd1 := v_ValidationReqd; 
		--Raise Notice '@84 >>.Validatin Required check>>(%)',v_ValidationReqd1; 
		IF(v_ValidationReqd1 IS NOT NULL)	THEN
			v_pos1				:= STRPOS(v_ValidationReqd1,CHR(21)); 
			v_TempTableName		:= SUBSTR(COALESCE(v_ValidationReqd1,''), 1, v_pos1-1); 
			v_ValidationReqd1	:= SUBSTR(COALESCE(v_ValidationReqd1,''), v_pos1+1); 
			v_pos1				:= STRPOS(COALESCE(v_ValidationReqd1,''),CHR(21)); 
			v_TempColumnName	:= SUBSTR(COALESCE(v_ValidationReqd1,''), 1, v_pos1-1); 
			v_ValidationReqd1	:= SUBSTR(COALESCE(v_ValidationReqd1,''), v_pos1+1); 
			v_pos1				:= STRPOS(COALESCE(v_ValidationReqd1,''),CHR(25)); 
			v_TempValue			:= RTRIM(SUBSTR(COALESCE(v_ValidationReqd1,''), 1, v_pos1-1));
				
			SELECT INTO v_TempColumnType DATA_TYPE  			  
			FROM USER_TAB_COLUMNS  
			WHERE  	TABLE_NAME 	= v_TempTableName  
			AND 	COLUMN_NAME 	= v_TempColumnName;
			--RAISE NOTICE '@108v_TempTableName>>(%)',v_TempTableName; 
			IF(NOT FOUND) THEN
				--RAISE NOTICE '@99- No datatype found --never be the case'; 
				v_TempColumnType := NULL; 
				v_mainCode	:= 15;	
				OPEN ResultSet FOR SELECT v_mainCode AS MainCode;
				RETURN ResultSet;
			END IF;

			IF UPPER(v_TempColumnType) IN ('VARCHAR2', 'CHAR', 'DATE') THEN 
				v_TempValue := CHR(39) || v_TempValue || CHR(39); 
			END IF; 
		--	RAISE NOTICE '@108(%,%,%)',v_TempTableName,v_TempColumnName,v_TempValue;	
			OPEN v_ValCursor FOR EXECUTE 'SELECT 1 FROM ' || v_TempTableName || ' WHERE ' || v_TempColumnName || ' = ' || v_TempValue;
			FETCH v_ValCursor INTO v_Temp;
			IF(FOUND) THEN
				v_DBStatus	:=  50; 
				v_mainCode		:= v_DBStatus; 
				CLOSE v_ValCursor;
				OPEN ResultSet FOR SELECT v_mainCode AS MainCode;
				RETURN ResultSet;
			END IF;
			CLOSE v_ValCursor;
			v_ValidateQuery := 'INSERT INTO '|| v_TempTableName ||' ( '|| v_TempColumnName ||' ) '||' VALUES ( '|| v_TempValue ||' ) ';
		END IF;
	--	Raise Notice '@124 >>v_InitiateFromActivityId>(%)',v_InitiateFromActivityId; 
	--	Raise Notice '@137 >>v_InitiateFromActivityName>(%)',v_InitiateFromActivityName; 
		IF(v_InitiateFromActivityId > 0) THEN
			SELECT INTO v_ActivityId, v_ActivityName ActivityId, ActivityName 
			FROM	ActivityTable 
			WHERE	ProcessDefID	= v_DBProcessDefId 
			AND	ActivityType	= 1 
			AND	ActivityId	= v_InitiateFromActivityId;
			IF(NOT FOUND) THEN
					--Raise Notice '@133 >>v_InitiateFromActivityId not exist Check loc >>133>(%)',v_InitiateFromActivityId; 
				v_mainCode := 603;
				OPEN ResultSet FOR SELECT v_mainCode AS MainCode;
				RETURN ResultSet;
			END IF;
		ELSIF(v_InitiateFromActivityName IS NOT NULL AND LENGTH(RTRIM(v_InitiateFromActivityName)) > 0 )	THEN
		
			SELECT INTO v_ActivityId, v_ActivityName ActivityId, ActivityName 			
			FROM	ActivityTable 
			WHERE	ProcessDefID = v_DBProcessDefId 
			AND	ActivityType = 1 
			AND	UPPER(ActivityName) = UPPER(v_InitiateFromActivityName); 
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
			AND	PrimaryActivity = 'Y';		/* Default Introduction workstep */ 
		END IF;
		
		IF(v_DataDefinitionName IS NOT NULL) THEN
			SELECT 	INTO v_DBDataDefinitionIndex DataDefIndex 
			FROM 	PDBDataDefinition 
			WHERE 	RTRIM(upper(DataDefName)) = RTRIM(upper(v_DataDefinitionName)) 
			AND 	GroupId = v_MainGroupId; 
			IF(NOT FOUND) THEN
				v_mainCode := PRTRaiseError('PRT_ERR_DDI_Not_Exist');
				OPEN ResultSet FOR SELECT v_mainCode AS MainCode;  
				RETURN ResultSet;
			END IF;
			v_DDTTableName := 'DDT_' || v_DBDataDefinitionIndex; 
		ELSE 
			 v_DBDataDefinitionIndex  := 0; 	
		END IF;
		
		SELECT   INTO v_DBParentFolderId  WorkFlowFolderId 
		FROM   RouteFolderDefTable 
		WHERE  ProcessDefId = v_DBProcessDefId; 
		IF(NOT FOUND) THEN			 
			v_mainCode := PRTRaiseError('PRT_ERR_Invalid_Parameter');
			OPEN ResultSet FOR SELECT v_mainCode AS MainCode;  
			RETURN ResultSet;
		END IF;
		
		IF PSFlag <> 'P' THEN
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
			AND 	QUEUETYPE 			= 'I' 
			AND 	USERID 				= v_DBUserId
			LIMIT 1;
		ELSE
			SELECT 	INTO v_QueueName, v_QueueId, v_StreamId 
			QUEUEDEFTABLE.QUEUENAME, QUEUEDEFTABLE.QUEUEID, QUEUESTREAMTABLE.STREAMID 
			FROM 	QUEUESTREAMTABLE, ACTIVITYTABLE , QUEUEDEFTABLE 
			WHERE 	QUEUESTREAMTABLE.PROCESSDEFID 	= v_DBProcessDefId 
			AND 	QUEUESTREAMTABLE.ACTIVITYID	=  v_ActivityId
			AND 	ACTIVITYTABLE.ACTIVITYTYPE 	= 1			
			AND 	ACTIVITYTABLE.PROCESSDEFID 	= QUEUESTREAMTABLE.PROCESSDEFID 
			AND 	ACTIVITYTABLE.ACTIVITYID	= QUEUESTREAMTABLE.ACTIVITYID 
			AND 	QUEUETYPE 					= 'I'
			AND 	QUEUEDEFTABLE.QUEUEID 		= QUEUESTREAMTABLE.QUEUEID 			
			LIMIT 1;
		END IF;	
		IF(NOT FOUND) THEN
			v_mainCode := 300;
			OPEN ResultSet FOR SELECT v_mainCode AS MainCode;  
			RETURN ResultSet;
		END IF;
		
		
		Select ProcessType,DisplayName into v_ProcessType,v_displayName from ProcessDefTable where processdefid = v_DBProcessDefId;
		IF(NOT FOUND) THEN
			v_mainCode := 2;
			OPEN ResultSet FOR SELECT v_mainCode AS MainCode;  
			RETURN ResultSet;
		END IF;
		select processname into v_ProcessName from processdeftable where processdefid = v_DBProcessDefId;
		v_SequenceName := 'SEQ_Reg_'||v_ProcessName;
		v_SequenceName := REPLACE(v_SequenceName,'-','_');
		v_SequenceName := REPLACE(v_SequenceName,' ','');
	--	v_SequenceName := substr(v_SequenceName,0,30);
		BEGIN
			v_RegStartingNo := NextVal(v_SequenceName);
			EXCEPTION
			WHEN OTHERS THEN
				BEGIN 		 		 	
					v_mainCode   := 4014;
					v_DBTblNm   := v_SequenceName;
					OPEN ResultSet FOR SELECT v_mainCode AS MainCode,v_DBTblNm as DBTblNm; 
					RETURN ResultSet;
				END;
		END;
		--Raise Notice '@234 >>v_RegStartingNo>>v_SequenceName>>-->(%,%)',v_RegStartingNo,v_SequenceName; 
		IF (v_ProcessType = 'S')THEN 
			SELECT	INTO v_RegPrefix,v_RegSuffix,v_RegSeqLength,v_ProcessName,v_ProcessVersion
			RegPrefix, RegSuffix, RegSeqLength, ProcessName, VersionNo
			FROM	ProcessDefTable 
			WHERE	ProcessDefID	= v_DBProcessDefId;
		ELSE
			SELECT	WFProcessVariantDefTable.RegPrefix, 
			WFProcessVariantDefTable.RegSuffix, 
			WFProcessVariantDefTable.RegStartingNo, 
			ProcessDefTable.RegSeqLength, 
			ProcessDefTable.ProcessName, 
			ProcessDefTable.VersionNo  
			INTO v_RegPrefix,v_RegSuffix,v_RegStartingNo,v_RegSeqLength,v_ProcessName,v_ProcessVersion
			FROM	WFProcessVariantDefTable, ProcessDefTable
			WHERE	WFProcessVariantDefTable.ProcessDefId = ProcessDefTable.ProcessDefId
			AND		ProcessDefTable.ProcessDefID	= v_DBProcessDefId
			AND		ProcessVariantId = v_DBProcessVariantId;
		
			UPDATE 	WFProcessVariantDefTable SET RegStartingNo 	= RegStartingNo + 1 WHERE 	ProcessDefID 	= v_DBProcessDefId AND ProcessVariantId = v_DBProcessVariantId;
		END IF;
		
		IF(NOT FOUND) THEN
			v_mainCode := 15;
			OPEN ResultSet FOR SELECT v_mainCode AS MainCode;  
			RETURN ResultSet;
		END IF;
		

		IF ((v_RegPrefix IS NULL OR LENGTH(LTRIM(v_RegPrefix)) < 0) ) THEN 
			v_RegPrefix	:= ''; 
		END IF;
		
		IF (v_RegPrefix IS NOT NULL AND LENGTH(LTRIM(v_RegPrefix)) > 0) THEN /*WFS_8.0_090*/
			v_RegPrefix	:= v_RegPrefix || '-'; 
		END IF;
		
		
		IF (v_RegSuffix IS NOT NULL AND LENGTH(LTRIM(v_RegSuffix)) > 0) THEN /*WFS_8.0_090*/
			v_RegSuffix	:= '-' || v_RegSuffix ; 
		END IF;
		
		IF ((v_RegSuffix IS NULL OR LENGTH(LTRIM(v_RegSuffix)) < 0) ) THEN 
		   IF(v_HyphenRequired ='Y') THEN
		      v_RegSuffix	:= '-'; 
		   ELSE
			v_RegSuffix	:= ''; 
			END IF;
		END IF;		
		
	
		IF(LENGTH(v_RegStartingNo) > (v_RegSeqLength - LENGTH(v_RegPrefix) - LENGTH(v_RegSuffix))) THEN  
			v_mainCode := 19;
			OPEN ResultSet FOR SELECT v_mainCode AS MainCode;  
			RETURN ResultSet;
		END IF;
		
		v_Length			:= v_RegSeqLength - LENGTH(v_RegPrefix) - LENGTH(v_RegSuffix); 
		v_ProcessInstanceId	:= RPAD('0', v_Length, '0');
		v_ProcessInstanceId	:= v_RegPrefix || SUBSTR(v_ProcessInstanceId, 1, LENGTH(v_ProcessInstanceId) - LENGTH(v_RegStartingNo)) || CAST(v_RegStartingNo AS Varchar) || v_RegSuffix; 
		if(v_displayName is NOT NULL AND LENGTH(v_displayName)>0) THEN
		v_urn:=v_displayName ||'-' || CAST(v_RegStartingNo AS Varchar);
		END IF;
		OPEN ResultSet FOR SELECT v_mainCode AS MainCode, v_ProcessInstanceId AS ProcessInstanceId, v_DBParentFolderId AS ParentFolderIndex, v_DBDataDefinitionIndex AS DataDefinitionIndex, v_ActivityId AS ActivityId, v_MainGroupId AS MainGroupId, v_ActivityName AS ActivityName, v_QueueId AS QueueId, v_QueueName AS QueueName, v_ValidateQuery AS ValidateQuery, v_StreamId AS StreamId,v_urn AS URN;
		RETURN ResultSet;
	END;
$$LANGUAGE plpgsql;