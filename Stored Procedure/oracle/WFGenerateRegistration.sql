/*____________________________________________________________________________________________________
			NEWGEN SOFTWARE TECHNOLOGIES LIMITED
______________________________________________________________________________________________________
	Group						: Phoenix
	Product / Project			: OmnniFlow 8.0
	Module						: Omniflow Server
	File Name					: WFUploadWorkitem.sql
	Author						: Preeti Awasthi.
	Date written (DD/MM/YYYY)	: 22/1/2010
	Description					: Stored procedure to generate Registration Number while invoked from WFUploadWorkitem API.
______________________________________________________________________________________________________
				CHANGE HISTORY
	
Date                        Change By        Change Description (Bug No. (If Any))
	
24/01/2011					Saurabh Sinha	 WFS_8.0_090[Replicated] Removing Hyphen from processinstanceid when suffix is not supplied at  	the time of process registration.
24/01/2011					Shweta Singhal	 Variable type changed from VARCHAR2(20) to NVARCHAR2(25)
Case getting generated when user defined regPrefix of length 20
17/05/2013					Shweta Singhal	Process Variant Support Changes
14/06/2013					Shweta Singhal	Bug 40355- Process Registration Number to be generated through sequence - automatically
03/06/2014                  Kanika Manik	PRD Bug 42279 - Transaction Handling missing [ Duplicate of 42278] 
05/06/2014                  Kanika Manik    PRD Bug 42185 - [Replicated]RTRIM should be removed
22/08/2014					Mohnish Chopra	Bug 47515 - Create workitem operation is slow with high concurrency (5 seconds with 100 concurrent users)
27/02/2017					RishiRam Meel   PRDP Bug  Merging 67207 - Unable to create workitem on different versions of a process.
06/03/2017					SAJID KHAN		Bug 67767 - iBPS 3.0 - SP2 |Not Able to initiate a new workitem, getting error 
											"Some database error has occured. Kindly contact your Administrator." 
06/09/2017					Shubhankur Manuja Bug 71495 - In case suffix is not provided, making length as 0.
24/10/2017        			Kumar Kimil         Case Registration requirement--Upload Workitem changes
27/10/2017					Ambuj Traipthi	Bug#72911 - weblogic+oracle: On clicking on new, getting error. Change in size of v_displayName to 20, earlier it was 10
05/02/2018        			Kumar Kimil Bug 75705 - Weblogic+ Oracle + SSL: By default WI's are coming with Process Instance Id's and quick search through Registration No. is not working
13/02/2018					Ambuj Tripathi	Bug 76031 - weblogic+oracle + SSL: Unable to create WI
22/04/2018					Kumar Kimil		Bug 77269 - CheckMarx changes (High Severity) 
01/10/2018  				Ambuj Tripathi		Changes related to sharepoint support
07/01/2019                  Ravi Ranjan Kumar	Bug 82037 - Arabic(weblogic+oracle):-unable to create workitem it shows error (merging from sp2)
03/09/2020                  Ravi Raj Mewara     Bug 94091 - iBPS 4.0 SP1 : Unable to create workitem after upgrade when process name contain '-'
12/01/2021					chitranshi nitharia	changes done for upload error handling.
____________________________________________________________________________________________________*/
CREATE OR REPLACE PROCEDURE WFGenerateRegistration(
	temp_v_DBUserId					INTEGER,
	temp_v_DBProcessDefId			NUMBER,
	temp_v_ValidationReqd			VARCHAR2	DEFAULT	NULL,
	temp_v_InitiateFromActivityId	INTEGER,
	tmp_v_InitiateFromActivityName	VARCHAR2	DEFAULT NULL,	
	v_DataDefinitionName		VARCHAR2	DEFAULT NULL,	
	v_DBProcessVariantId		NUMBER,/*Process Variant Support*/
	PSFlag						VARCHAR2	DEFAULT 'N',
	Status 						OUT	INTEGER,
	RefCursor					IN OUT Oraconstpkg.DBLIST,
	DBTblNm						OUT VARCHAR2
)
AS
v_VaidateQuery				VARCHAR2(2000);
v_ValidationReqd1			VARCHAR2(1000); 
v_pos1						INTEGER; 
v_Temp						SMALLINT; 
v_TempTableName				VARCHAR2(255);
v_TempColumnName			VARCHAR2(255); 
v_TempColumnType			VARCHAR2(10); 
v_TempValue					VARCHAR2(500); 
v_valcur					INTEGER; 
v_QueryStr					VARCHAR2(8000); 
v_retval					INTEGER;
v_DBStatus					INTEGER;
v_ActivityId				INTEGER;
v_ActivityName				NVARCHAR2(30);
v_DBDataDefinitionIndex	INTEGER; 
v_MainGroupId				SMALLINT;
v_DDTTableName				VARCHAR2(255);
v_DBParentFolderId			VARCHAR2(255);
v_QueueName					VARCHAR2(255); 
v_QueueId					INTEGER; 
v_StreamId					INTEGER; 
v_Length					INT;
v_RegPrefix					NVARCHAR2(25); 
v_RegSuffix					NVARCHAR2(25); 
v_RegStartingNo				INT;
v_RegSeqLength				INT; 
v_ProcessName				VARCHAR2(64); 
v_ProcessVersion 			SMALLINT; 
v_ProcessInstanceId			NVARCHAR2(255); 
v_UserName					VARCHAR2(100);
v_ProcessType				VARCHAR2(1);
v_SequenceName				VARCHAR2(100);
v_len						INT;
v_displayName               Varchar2(50);
v_urn                       Varchar2(63);
v_ValidationReqd            Varchar2(63);
v_quoteChar 				CHAR(1);
v_DBUserId			INTEGER;
v_DBProcessDefId		NUMBER;
v_InitiateFromActivityId	INTEGER;
v_InitiateFromActivityName	NVARCHAR2(510);
BEGIN
	v_quoteChar := CHR(39);  
	
	IF(temp_v_DBUserId is NOT NULL) THEN
		v_DBUserId:=CAST(REPLACE(temp_v_DBUserId,v_quoteChar,v_quoteChar||v_quoteChar) AS INTEGER);
	END IF;
	IF(temp_v_DBProcessDefId is NOT NULL) THEN
		v_DBProcessDefId:=CAST(REPLACE(temp_v_DBProcessDefId,v_quoteChar,v_quoteChar||v_quoteChar) AS NUMBER);
	END IF;
	IF(temp_v_InitiateFromActivityId is NOT NULL) THEN
		v_InitiateFromActivityId:=CAST(REPLACE(temp_v_InitiateFromActivityId,v_quoteChar,v_quoteChar||v_quoteChar) AS INTEGER);
	END IF;
	IF(tmp_v_InitiateFromActivityName is NOT NULL) THEN
		SELECT sys.DBMS_ASSERT.noop(tmp_v_InitiateFromActivityName) into v_InitiateFromActivityName FROM dual;
	END IF;
	BEGIN 
		SELECT 	 UserName, MainGroupId INTO v_UserName ,v_MainGroupId
		FROM 	PDBUser 
		WHERE 	UserIndex = v_DBUserId; 
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			v_UserName:= NULL; 
			STATUS := 15 ; 
			RETURN; 
	END;
	IF(temp_v_ValidationReqd is NOT NULL) THEN
		SELECT sys.DBMS_ASSERT.noop(temp_v_ValidationReqd) into v_ValidationReqd FROM dual;
	END IF;
	IF(v_ValidationReqd is NOT NULL) THEN
	v_ValidationReqd:=REPLACE(v_ValidationReqd,v_quoteChar,v_quoteChar||v_quoteChar);
	ELSE
	v_ValidationReqd:='';
	v_ValidationReqd:=REPLACE(v_ValidationReqd,v_quoteChar,v_quoteChar||v_quoteChar);
	v_ValidationReqd:=NULL;
	END IF;
	v_ValidationReqd1 := v_ValidationReqd; 
	IF v_ValidationReqd1 IS NOT NULL THEN 
	BEGIN 
		v_pos1			:= INSTR(v_ValidationReqd1,CHR(21),1); 
		v_TempTableName		:= SUBSTR(v_ValidationReqd1, 1, v_pos1-1); 
		v_ValidationReqd1	:= SUBSTR(v_ValidationReqd1, v_pos1+1); 
		v_pos1			:= INSTR(v_ValidationReqd1,CHR(21),1); 
		v_TempColumnName	:= SUBSTR(v_ValidationReqd1, 1, v_pos1-1); 
		v_ValidationReqd1	:= SUBSTR(v_ValidationReqd1, v_pos1+1); 
		v_pos1			:= INSTR( v_ValidationReqd1,CHR(25),1); 
		v_TempValue		:= RTRIM(SUBSTR(v_ValidationReqd1, 1, v_pos1-1)); 
		BEGIN  
			SELECT 	  DATA_TYPE  
			INTO v_TempColumnType  
			FROM USER_TAB_COLUMNS  
			WHERE  	TABLE_NAME 	= v_TempTableName  
			AND 	COLUMN_NAME 	= v_TempColumnName; 
		EXCEPTION  
			WHEN NO_DATA_FOUND THEN  
				v_TempColumnType := NULL; 
				STATUS := 15 ; 
				RETURN; 
		END; 
		IF UPPER(v_TempColumnType) IN ('VARCHAR2', 'CHAR', 'DATE') THEN 
			 v_TempValue := CHR(39) || v_TempValue || CHR(39); 
		END IF; 
		BEGIN  
			v_valcur := dbms_sql.open_cursor; 
			v_QueryStr := ' SELECT 1 FROM ' || v_TempTableName ||' WHERE '|| v_TempColumnName || ' = ' || v_TempValue; 
			DBMS_SQL.PARSE(v_valcur,v_QueryStr,dbms_sql.native); 
			DBMS_SQL.define_column(v_valcur, 1, v_Temp); 
			v_retval := dbms_sql.execute(v_valcur); 
			v_DBStatus := SQLCODE; 
			IF (v_DBStatus <> 0) THEN  
			BEGIN  
				Status := 15 ; 
				dbms_sql.close_cursor(v_valcur); 
				RETURN	 ; 
			END; 
			END IF; 
			
			IF(DBMS_SQL.fetch_rows(v_valcur) > 0) THEN  
				v_DBStatus	:=  50; 
				Status		:= v_DBStatus; 
				dbms_sql.close_cursor(v_valcur); 
				RETURN; 
			END IF; 
			v_DBStatus := SQLCODE; 
			DBMS_SQL.column_value(v_valcur, 1, v_Temp); 
			DBMS_SQL.CLOSE_CURSOR(v_valcur); 
		EXCEPTION  
			WHEN OTHERS THEN  
				DBMS_SQL.CLOSE_CURSOR(v_valcur); 
				Status := 15; 
				RETURN; 
		END;
		v_VaidateQuery := 'INSERT INTO '||v_TempTableName||' ( '||v_TempColumnName||' ) '||' VALUES ( '||v_TempValue||' ) ';
	END; 
	END IF; 
	/* Changed By Varun Bhansaly On 11/04/2007 for Bugzilla Id 532 */
	If (v_InitiateFromActivityId > 0) THEN  
	Begin  
		SELECT	ActivityId, ActivityName 
		INTO	v_ActivityId, v_ActivityName 
		FROM	ActivityTable 
		WHERE	ProcessDefID	= v_DBProcessDefId 
		AND	ActivityType	= 1 
		AND	ActivityId	= v_InitiateFromActivityId;
	EXCEPTION 
		WHEN OTHERS THEN 
			Status := 603; 
			RETURN; 
	END; 		
	ElsIf(v_InitiateFromActivityName IS NOT NULL AND LENGTH(RTRIM(v_InitiateFromActivityName)) > 0 ) THEN  
	BEGIN 
		SELECT	ActivityId, ActivityName 
		INTO	v_ActivityId, v_ActivityName 
		FROM	ActivityTable 
		WHERE	ProcessDefID = v_DBProcessDefId 
		AND	ActivityType = 1 
		AND	UPPER(ActivityName) = UPPER(v_InitiateFromActivityName); 
	EXCEPTION 
		WHEN OTHERS THEN 
			Status := 603; 
			RETURN; 
	END; 
	Else  
		SELECT	ActivityId, ActivityName 
		INTO	v_ActivityId, v_ActivityName 
		FROM	ActivityTable 
		WHERE	ProcessDefID = v_DBProcessDefId 
		AND	ActivityType = 1 
		AND	PrimaryActivity = 'Y';		/* Default Introduction workstep */ 
	End IF; 		
	IF v_DataDefinitionName IS NOT NULL THEN  
	BEGIN 
		SELECT 	DataDefIndex INTO v_DBDataDefinitionIndex 
		FROM 	PDBDataDefinition 
		WHERE 	upper(DataDefName) = upper(v_DataDefinitionName)
		AND 	GroupId = v_MainGroupId; 
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			Raise OraExcpPkg.Excp_DDI_Not_Exist; 
			Status := v_DBStatus; 
			RETURN; 
	END; 
	ELSE 
		 v_DBDataDefinitionIndex  := 0; 
	END IF; 
	v_DDTTableName := 'DDT_' || TO_CHAR(v_DBDataDefinitionIndex); 
	BEGIN  
		SELECT   WorkFlowFolderId INTO v_DBParentFolderId  
		FROM   RouteFolderDefTable 
		WHERE  ProcessDefId = v_DBProcessDefId; 
		v_DBParentFolderId:=REPLACE(v_DBParentFolderId,v_quoteChar,v_quoteChar||v_quoteChar);
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			BEGIN 
				Raise OraExcpPkg.Excp_Invalid_Parameter; 
				Status := v_DBStatus; 
				RETURN; 
			END; 
	END; 
	
	BEGIN  
		IF PSFlag <> 'P' THEN  
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
			AND		ROWNUM = 1; 
		ELSE
			SELECT  QUEUEDEFTABLE.QUEUENAME,  
				QUEUESTREAMTABLE.QUEUEID,  
				QUEUESTREAMTABLE.STREAMID INTO v_QueueName, v_QueueId, v_StreamId 
			FROM 	QUEUESTREAMTABLE, ACTIVITYTABLE , QUEUEDEFTABLE 
			WHERE 	QUEUESTREAMTABLE.PROCESSDEFID 	= v_DBProcessDefId 
			AND 	QUEUESTREAMTABLE.ACTIVITYID	=  v_ActivityId
			AND 	ACTIVITYTABLE.ACTIVITYTYPE 	= 1			
			AND 	ACTIVITYTABLE.PROCESSDEFID 	= QUEUESTREAMTABLE.PROCESSDEFID 
			AND 	ACTIVITYTABLE.ACTIVITYID	= QUEUESTREAMTABLE.ACTIVITYID 
			AND 	QUEUETYPE 					= 'I'
			AND 	QUEUEDEFTABLE.QUEUEID 		= QUEUESTREAMTABLE.QUEUEID 			
			AND 	ROWNUM = 1;
		END IF;		
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
				BEGIN 
					 v_DBStatus := 300;	
					 Status   := v_DBStatus; 
					 RETURN; 
				END; 
	END; 
	BEGIN
		SELECT ProcessType
		INTO v_ProcessType
		FROM ProcessDefTable 
		WHERE ProcessDefId = v_DBProcessDefId;
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			BEGIN 
		 		 v_DBStatus := 2;	
				 Status   := v_DBStatus; 
				 RETURN; 
			END; 
	END; 
	
	SAVEPOINT TranWorkItem; 	
	/* Changed By Shweta Singhal On 14/06/2013 for Bugzilla Id 40355 */
	select processname,DisplayName into v_ProcessName,v_displayName from processdeftable where processdefid = v_DBProcessDefId;
	v_SequenceName := 'SEQ_Reg_'||v_ProcessName;
	v_SequenceName := REPLACE(v_SequenceName,'-','_');
	v_SequenceName := REPLACE(v_SequenceName,' ','');
	v_SequenceName := substr(v_SequenceName,0,30);
	BEGIN
		EXECUTE IMMEDIATE 'select '|| v_SequenceName ||'.nextval from dual' into v_RegStartingNo;
	EXCEPTION
		WHEN OTHERS THEN
			Status   := 4014;
			DBTblNm   := v_SequenceName;
			RETURN;
	END;
	IF (v_ProcessType = 'S')THEN 
		/*Changed for Bug 47515 - Create workitem operation is slow with high concurrency (5 seconds with 100 concurrent users)*/
		/*UPDATE 	ProcessDefTable 
		SET 	RegStartingNo 	= v_RegStartingNo
		WHERE 	ProcessDefID 	= v_DBProcessDefId; */

		SELECT	RegPrefix, 
			RegSuffix, 
			RegSeqLength, 
			ProcessName, 
			VersionNo  
			INTO v_RegPrefix,v_RegSuffix,v_RegSeqLength,v_ProcessName,v_ProcessVersion 
		FROM	ProcessDefTable 
		WHERE	ProcessDefID	= v_DBProcessDefId; 
	ELSE
		SELECT	WFProcessVariantDefTable.RegPrefix, 
			WFProcessVariantDefTable.RegSuffix, 
			WFProcessVariantDefTable.RegStartingNo, 
			RegSeqLength, 
			ProcessName, 
			VersionNo  
			INTO v_RegPrefix,v_RegSuffix,v_RegStartingNo,v_RegSeqLength,v_ProcessName,v_ProcessVersion
		FROM	WFProcessVariantDefTable, ProcessDefTable
		WHERE	WFProcessVariantDefTable.ProcessDefId = ProcessDefTable.ProcessDefId
		AND		ProcessDefTable.ProcessDefID	= v_DBProcessDefId
		AND		ProcessVariantId = v_DBProcessVariantId;/*Process Variant Support*/
		
		UPDATE 	WFProcessVariantDefTable
		SET 	RegStartingNo 	= RegStartingNo + 1
		WHERE 	ProcessDefID 	= v_DBProcessDefId
		AND 	ProcessVariantId = v_DBProcessVariantId;/*Process Variant Support*/

		
	END IF;
	
	
	IF SQL%ROWCOUNT<=0 THEN 
		BEGIN
            ROLLBACK TO SAVEPOINT TranWorkItem;		
			Status := 15; 
			RETURN; 
		END; 
	END IF;	
	COMMIT; 
	
	
	IF (v_RegPrefix IS NOT NULL AND LENGTH(LTRIM(v_RegPrefix)) > 0) THEN /*WFS_8.0_090*/
		BEGIN
			v_RegPrefix	:= v_RegPrefix || '-'; 
		END;
	END IF;
	
	IF (v_RegSuffix IS NOT NULL AND LENGTH(LTRIM(v_RegSuffix)) > 0) THEN /*WFS_8.0_090*/
		BEGIN
			v_RegSuffix	:= '-' || v_RegSuffix ; 
		END;
	END IF;
	
	IF (v_RegPrefix IS NULL) THEN
		BEGIN
			v_RegPrefix	:= ''; 
		END;
	END IF;
	
	IF (v_RegSuffix IS NULL) THEN
		BEGIN
			v_RegSuffix	:= ''; 
		END;
	END IF;
	
	IF(LENGTH(v_RegSuffix) IS NULL)THEN
        BEGIN
            v_len := 0; 
        END;
    ELSE
        BEGIN
            v_len :=LENGTH(v_RegSuffix);
        END;
    END IF;


	IF LENGTH(v_RegStartingNo) > (v_RegSeqLength - LENGTH(v_RegPrefix) - v_len) THEN  
	BEGIN 
		 v_DBStatus := 19; 
		 Status   := v_DBStatus; 
		 RETURN; 
	END; 
	END IF; 	
	v_RegSuffix:=REPLACE(v_RegSuffix,v_quoteChar,v_quoteChar||v_quoteChar);--checkmarx changes
	v_RegPrefix:=REPLACE(v_RegPrefix,v_quoteChar,v_quoteChar||v_quoteChar);--checkmarx changes
	v_ActivityName:=REPLACE(v_ActivityName,v_quoteChar,v_quoteChar||v_quoteChar);--checkmarx changes
	v_QueueName:=REPLACE(v_QueueName,v_quoteChar,v_quoteChar||v_quoteChar);--checkmarx changes
	
	v_Length			:= v_RegSeqLength - LENGTH(v_RegPrefix) - v_len; 
	v_ProcessInstanceId	:= RPAD('0', v_Length,'0'); 
	v_ProcessInstanceId	:= v_RegPrefix || SUBSTR(v_ProcessInstanceId,1, LENGTH(v_ProcessInstanceId) - LENGTH(v_RegStartingNo)) || TO_CHAR(v_RegStartingNo) || v_RegSuffix;
	if(v_displayName is NOT NULL AND LENGTH(v_displayName)>0) THEN
		v_displayName:=REPLACE(v_displayName,v_quoteChar,v_quoteChar||v_quoteChar);--checkmarx changes
		v_urn:=v_displayName ||'-' || TO_CHAR(v_RegStartingNo);
	END IF;
	v_QueryStr := ' Select '||CHR(39)||v_ProcessInstanceId||CHR(39)||' ProcessInstanceId, '||v_DBParentFolderId||' ParentFolderIndex, '||v_DBDataDefinitionIndex||' DataDefinitionIndex, '||v_ActivityId||' ActivityId, '||v_MainGroupId||' MainGroupId, '||CHR(39)||v_ActivityName||CHR(39)||' ActivityName, '||v_QueueId||' QueueId, '||CHR(39)||v_QueueName||CHR(39)||' QueueName, '||CHR(39)||v_VaidateQuery||CHR(39)||' ValidateQuery, '||v_StreamId||' StreamId,'||CHR(39)||v_urn||CHR(39)||' URN FROM DUAL';
	OPEN RefCursor FOR TO_CHAR(v_QueryStr);		
EXCEPTION
	WHEN OTHERS THEN
        ROLLBACK TO SAVEPOINT TranWorkItem;	
 		CLOSE RefCursor;
		RAISE;
END;	