/*_________________________________________________________________________________________________
				NEWGEN SOFTWARE TECHNOLOGIES LIMITED
___________________________________________________________________________________________________
	Group				: Application ? Products
	Product / Project		: WorkFlow 5.0
	Module				: Transaction Server
	File Name			: WFUploadWorkItem.sql
	Author				: Virochan And Rahul
	Date written (DD/MM/YYYY)	: 16/02/2005
	Description			: This stored procedure is called from WMMiscellaneous.java

___________________________________________________________________________________________________
					CHANGE HISTORY
___________________________________________________________________________________________________
 Date		Change By		Change Description (Bug No. (If Any))
 10/05/2005	Ruhi Hira		SrNo-1.
 16/05/2005	Rahul Mehta		SrNo-2.
 10/08/2005	Mandeep Kaur		SRNo-3 (Bug Ref No WFS_5_056)
 10/08/2005     Mandeep Kaur		SRNo-4 (Bug Ref No WFS_5_055)
 11/08/2005	Mandeep Kaur		SRNo-5, WFS_6.1_020, WFS_6.1_021, WFS_6.1_022
 14/10/2005     Mandeep Kaur            Bug No WFS_6.1_045.
 15/10/2005     Mandeep Kaur            Bug No WFS_6.1_051.
 22/02/2006     Ruhi Hira		Bug No WFS_6.1.2_059.
 23/02/2006     Ahsan Javed		Bug No WFS_6.1_049
 08/03/2006     Ahsan Javed		Bug No WFS_6.1_050
 18/04/2006	Ruhi Hira		Bug No WFS_6.1.2_066.
 23/10/2006	Virochan Dev		Bugzilla Bug 265 - FolderIndex returned
 23/10/2006	Virochan Dev		Bugzilla Bug 270 - For multiple introduction worksteps
 23/10/2006	Virochan Dev		Bugzilla Bug 271 - Default value is checked against Date Type (8) variable
 02/02/2007	Varun Bhansaly	Extra Parameter added for Calendar Support and insert statement modified
 08/02/2007	Varun Bhansaly	Bugzilla Id 74 (Inconsistency in date-time)
 05/04/2007	Tirupati Srivastava		Bugzilla Id 529 (UploadWorkItem)
 11/04/2007	Varun Bhansaly	Bugzilla Id 532
							(In case of Stored Procedure for WFUploadWorkItem written in MSSQL, 
							JAVA style syntax is being used to check for a NULL)
03/05/2007	Tirupati Srivastava		Bugzilla Id 676 (UploadWorkItem) (In case a user is added to introduction queue as well as group is 									asdded to Introduction Queue of which user is alsoa amember, err 																		comes in Oracle)
17/07/2007	Varun Bhansaly		Bugzilla Id 1447 (Introduce WorkItem from Webdesktop using Single Call WFUploadWorkItem)
22/10/2007	Varun Bhansaly		Bugzilla Id 1293 (In WFUploadWorkItem for Oracle if attribute value is not given then it fails)
25/02/2008	Varun Bhansaly	Bugzilla Bug Id 3129 (Support for multiple document types)
05/03/2008	Varun Bhansaly	Coded backward compatibility for Bugzilla Id 3129
11/04/2008	Ashish Mangla		Bugzilla Bug 4078 GenerateName making call slow, to be used only when required
22/05/2008	Varun Bhansaly		WFS_6.2_005, (Error in WFUploadWorkitem when attribute value contains single quote as data)
22/05/2008	Varun Bhansaly		WFS_5_226, (Support for text attribute values upto length 4000 provided. Attribute value can contain single quote as data)
28/08/2008	Varun Bhansaly		Optimization in WFUploadWorkItem, query strings will be generated and passed from API.
08/12/2008	Ashish Mangla		Bugzilla Bug 7193 (special char mu creating problem while being executed Post.sql execution)
04/7/2009	Preeti Awasthi		WFS_8.0_013 - Support for adding document's actual name(Harddisk name) in Comment column .
07/07/2009	Saurabh Kamal		WFS_8.0_010 , If else for InitiateAlso = 'N'
03/07/2009	Indraneel dasgupta	WFS_7.1_033 ( User that do not have rights on an introduction queue got error "Process definition id invalid" on uploading workitem.Rather it should be No Authorization error)
30/09/2009  Prateek Verma       WFS_8.0_037 Message entry in WFMessageTable in case of add document
17/05/2013	Shweta Singhal		Process Variant Support Changes
23/12/2013	Sajid Khan			Message Agent Optimization.
19-02-2014	Sajid Khan			Entries made into WFCurrentRouteLogTable for ActionId 1 and 2 for each execution.
06/03/2014	Sajid Khan			Issue while uploadWorkItem call.Username was not trimed while inserting into wfcurrentroutelogtabl.
03/06/2014  Kanika Manik		PRD Bug 42181 - Change in the Size of a declared Variable "v_comment" in WFUploadWorkitem.sql.
05/06/2014  Kanika Manik        PRD Bug 42185 - [Replicated]RTRIM should be removed
14/07/2014  Kanika Manik        Bug 47326 - UNable to create any workitem in Oracle cabinet. 
29-09-2014	Mohnish Chopra		Bug 50438 - WI properties showing 2 start Events
11/08/2015	Mohnish Chopra		Changes for Data Locking issue in Case Management -ActivityType added in WFInstrumentTable
13/04/2017	Rakesh K Saini		Bug 60465 - Error in creating workitem for a sub process with document in some cases 
22/04/2017  Kumar Kimil         Bug 56084 - IntroducedById, IntroducedByName and IntroductionDatetime was not updating even if InitiateAlso Flag = y in WFUploadWrokitem - Oracle Cabinet
01-05-2017	Sajid Khan			Merging Bug 58270 - Auditing of Attribute set is not being done through WFUPloadWorkitem API
04-05-2017	Sajid Khan			Merging Bug 59182 - Error in insertion in currentroutelogtable when some values to be inserted contain aprostophe .
08/05/2017	Kumar Kimil 	Bug 55927 - Support for API Wise Synchronous Routing.
17/07/2017	Mohnish Chopra 		PRDP Bug 69312 - Workitems created through initiation agent pending for PS are visible on queue click . 
24/10/2017        Kumar Kimil         Case Registration requirement--Upload Workitem changes
29/12/2017  Kumar Kimil         Bug 74441 - PNG File handling through Initiation Agent and 0KB file Handling for ESPN
22/04/2018	    Kumar Kimil		Bug 77269 - CheckMarx changes (High Severity)
22/04/2018  Ambuj Tripathi		Bug 76862 - Remove the db console messages from all procedures
23/05/2018	Ambuj Tripathi		Bug 78093 - Initiation Agent :: work-item is not getting created
01/10/2018  Ambuj Tripathi		Changes related to sharepoint support
29/01/2019	Ravi Ranjan Kumar Bug 82718 - User able to view & search iBps WF system folders .
19/02/2019	Ravi Ranjan Kumar PRDP Bug Merging(Bug 84343 - WFUploadWorkItem getting failed when document data is huge)
02/01/2020 	Shubham Singla      Bug 89615 - Adding "Document" Tag in output of WFUploadWorkItem call as it has been a gap between OF and iBPS API.
04/02/2020	Ambuj Tripathi		Bug 88867 - Png document is not displayed in Attached document when WI is created through import service or initiation agent.
12/01/2021					chitranshi nitharia	changes done for upload error handling.
_________________________________________________________________________________________________*/


CREATE  OR REPLACE PROCEDURE WFUploadWorkItem( 
	temp_v_DBUserId				INTEGER,
	temp_v_ProcessInstanceId		NVARCHAR2,
	temp_v_DBProcessDefId		NUMBER,  
	v_ActivityId			INTEGER,
	temp_v_ActivityName			VARCHAR2 DEFAULT NULL,	
	v_ValidationReqd		VARCHAR2	DEFAULT NULL,  
	v_DBDataDefinitionIndex	INTEGER,
	v_DBDDIDataList1		VARCHAR2	DEFAULT NULL,  
	v_DBDDIDataList2		VARCHAR2	DEFAULT NULL,  
	v_DBDDIDataList3		VARCHAR2	DEFAULT NULL,  
	v_DBDDIDataList4		VARCHAR2	DEFAULT NULL,  
	v_DBDDIDataList5		VARCHAR2	DEFAULT NULL,  
	v_DBDDIDataList6		VARCHAR2	DEFAULT NULL,  
	v_DBDDIDataList7		VARCHAR2	DEFAULT NULL,  
	v_DBDDIDataList8		VARCHAR2	DEFAULT NULL,  
	v_DBDDIDataList9		VARCHAR2	DEFAULT NULL,  
	v_DBDDIDataList10		VARCHAR2	DEFAULT NULL,  
	v_DBDocumentList1		VARCHAR2	DEFAULT NULL, 
	v_DBDocumentList2		VARCHAR2	DEFAULT NULL, 
	v_DBDocumentList3		VARCHAR2	DEFAULT NULL, 
	v_DBDocumentList4		VARCHAR2	DEFAULT NULL, 
	v_DBDocumentList5		VARCHAR2	DEFAULT NULL, 
	v_DBPriorityLevel		INT			DEFAULT NULL, 
	v_DBGenerateLog			CHAR		DEFAULT NULL,
	temp_v_DBExpectedProcessDelay	DATE	DEFAULT NULL,
	v_InitiateAlso			NCHAR		DEFAULT NULL,
	temp_v_DBQDTColumnList		VARCHAR2	DEFAULT NULL, 
	temp_v_DBQDTValueList		VARCHAR2	DEFAULT NULL, 
	temp_v_DBEXTColumnList		VARCHAR2	DEFAULT NULL, 
	temp_v_DBEXTValueList		VARCHAR2	DEFAULT NULL, 
	v_DBRouteLogList		VARCHAR2	DEFAULT NULL, 
	temp_v_ValidateQuery			VARCHAR2	DEFAULT NULL,	
	v_MainGroupId			SMALLINT,
	v_DBParentFolderId		INTEGER, 
	temp_v_ProcessName			VARCHAR2,
	v_ProcessVersion		INT,
	v_QueueId				INT,
	temp_v_QueueName				VARCHAR2,
	v_StreamId				INT,
	Status 					OUT			INT, 
	DBFolderName 			OUT			VARCHAR2, 
	CurrDate				OUT			DATE,
	FolderIndex				OUT			INT,
	v_ProcessVariantId		INT/*Process Variant Support*/,
	v_DBSetAttributeLoggingEnabled		NVARCHAR2,
	v_syncRoute			    NCHAR		DEFAULT NULL,
	urn                   Varchar2,
	v_SharepointFlag		VARCHAR2,
	temp_v_FolderIdSP			VARCHAR2,
	DocumentIndexes			OUT			VARCHAR2,
	temp_v_locale				Varchar2,
	DBMsg					OUT			VARCHAR2,
	DBTblNm					OUT			VARCHAR2,
	v_tarHisLog				VARCHAR2,
	v_targetCabinet			VARCHAR2
)  
AS  
    	/* Declare Variables */ 
	 /* Changed By Varun Bhansaly On 02/02/2007 */
	 /* v_ProcessTurnAroundTime        int;  */
	 /* v_DBParentFolderId		int; */
	 existsFlag				INTEGER;
	  v_seqRootLogId			INTEGER;
	 v_QueryStr1 			VARCHAR2(8000);
	 v_QueryStr11 			VARCHAR2(8000);
	 v_DBFolderName			varchar2(255); 
	 v_DBAccessType			char(1); 
	 v_DBImageVolumeIndex		int; 
	 v_DBFolderType			char(1); 
         v_DBVersionFlag		char(1); 
	 v_DBComment			char(255); 
	 v_DBExpiryDateTime		char(50); 
	 v_NameLength			int; 
	 v_LimitCount			int; 
	 v_DBEnableFTS			char(1); 
	 v_DuplicateNameFlag		char(1); 
	/*  v_DBDataDefinitionIndex	int; */
	 v_DBLocation			char; 
	 v_DBUserRights      		char(10) ; 
	 v_FolderLock			char(1); 
	 v_FinalizedFlag		char(1); 
	 v_EnableVersion		char(1); 
 	 v_DBStatus			int; 
	/* v_DBUserId        		number; */ 
  	 v_NewFolderIndex		int; 
	 v_TempUser			smallint; 
	 v_AccessType			char(1); 
	 v_ACLMore			char(1); 
	 v_ACLstr			char(255); 
	 /*v_MainGroupId			smallint; */
	 v_ExpiryDateTime		DATE; 
	 v_ParentEnableFTS 		char(1); 
	 v_ParentFolderType		CHAR(1); 
	 v_LockByUser			varchar2(255); 
	 v_EffectiveLockByUser		smallint; 
	 v_LockMessage			varchar2(255); 
	 v_LockedObject			int; 
	 v_FolderLevel 			int; 
	 v_FolLock			char(1); 
	 v_FolLockByUser		varchar2(255); 
	 v_Hierarchy			varchar2(4000); 
	 v_ProcessState			varchar2(10); 
	/*	 v_RegPrefix			varchar2(20); 
	 v_RegSuffix			varchar2(20); 
	 v_RegStartingNo		int; 
	 v_RegSeqLength			int; */ 
	 v_TableViewName		varchar2(255); 
	 v_Length			int; 
/* v_ProcessInstanceId		nvarchar2(50); */
	 v_ColumnList			VARCHAR2(8000); 
	 v_ValueList			VARCHAR2(8000); 
	 v_WhileCounter			int; 
	 v_DDTTableName			varchar2(255); 
	 /*v_QueueName			varchar2(255); 
	 v_QueueId			int; 
	 v_StreamId			int; */
	/* v_ActivityId			INTEGER; 
	 v_ActivityName			varchar2(30); */
	 v_UserName			char(256);                
	 v_UpdateFlag			char(1); 
	 v_SystemDefinedName		varchar2(50); 
	 v_VariableType			smallint; 
	 v_DBDDIDataList		VARCHAR2(8000); 
	 v_ParseCount			int; 
	 v_pos1				int; 
	 v_TempStr			VARCHAR2(8000); 
	 v_TempFieldName		varchar2(100); 
	 v_TempFieldValue		varchar2(4000); 
	 v_TempFieldId			int; 
	 v_TempDataFieldType		char(1); 
	 v_DBDocumentList		VARCHAR2(8000); 
	 v_DocumentName			varchar2(255);
	 v_DocumentType			char(1)	 ;
	 v_AppType		        varchar2(50);	
	 v_Comment			varchar2(1020); --WFS_8.0_013
	 v_ISIndexStr			varchar2(50); 
	 v_ImageIndex 			int; 
	 v_VolumeIndex 			int; 
	 v_CurrDate 			DATE; 
	 v_NextOrder 			int; 
	 v_NewDocumentIndex		int; 
	 v_NoOfPage 			int; 
	 v_DocumentSize 		int; 
/*  v_TempTableName		varchar2(255); 
	 v_TempColumnName		varchar2(255); 
	 v_TempColumnType		varchar2(10); 
	 v_TempValue			varchar2(500); */
	 v_UserDefinedName		varchar2(50); 
	 v_ExtObjID			smallint; 
	 v_Rec1 			varchar2(255); 
	 v_Var_Rec_1 			varchar2(255); 
	 v_Rec2				varchar2(255); 
	 v_Var_Rec_2			varchar2(255); 
	 v_Rec3				varchar2(255); 
	 v_Var_Rec_3			varchar2(255); 
	 v_Rec4				varchar2(255); 
	 v_Var_Rec_4			varchar2(255); 
	 v_Rec5				varchar2(255); 
	 v_Var_Rec_5 			varchar2(255); 
	 v_TempVar			varchar2(4000); 
	 v_UpdateColumnStr		NVARCHAR2(8000); 
	 v_UpdateValueStr		NVARCHAR2(8000); 
	 v_UniqueNameString		NVARCHAR2(8000);
	 v_QueryStr			VARCHAR2(8000);
     v_var1			VARCHAR2(4000);	 
	 v_Pattern			varchar2(400); 
	 v_atempstr			VARCHAR2(8000); 
	 v_atempstrdummy		VARCHAR2(8000); 
	 v_Posi1			int; 
	 v_Posi2			int; 
	 v_yesValue			varchar2(4000); 
	 v_InsertExtColumnStr		VARCHAR2(1024); 
	 v_InsertExtValueStr		VARCHAR2(1024); 
	 v_TempExtObjID			int; 
	 v_Temp				smallint; 
	 v_DBProcessDefIdStr 		varchar2(10); 
	 v_ActivityIdStr 		varchar2(10); 
	 v_ValidTill			DATE; 
	 v_ProcessName			varchar2(64); 
	 /*v_ProcessVersion 		smallint; */
	 v_PriorityLevel		varchar2(5); 
	 v_DBTotalDuration		number; 
	 v_DBTotalPrTime		number; 
	 v_valcur			INTEGER; 
	 v_retval			INTEGER; 
	 v_attrcur			INTEGER; 
	 v_sysattrcur			INTEGER; 
	 v_UpdateQueue			INTEGER; 
	 v_count			INTEGER; 
	 v_ValidationReqd1		VARCHAR2(1000); 
	 v_size				INTEGER;
	 v_MessageBuffer		CLOB;
       v_FieldName                    VARCHAR2(2000);
	    v_fieldId				INTEGER;
		v_urnDup     VARCHAR2(63);
		v_urn  VARCHAR2(63);
		v_ProcessInstanceId NVARCHAR2(255);
		v_ActivityName NVARCHAR2(255);
		v_QueueName NVARCHAR2(255);
		v_DBEXTValueList VARCHAR2(4000);
		v_DBEXTColumnList VARCHAR2(4000);
		v_DBQDTValueList VARCHAR2(4000);
		v_DBQDTColumnList VARCHAR2(4000);
		v_DBProcessDefId INTEGER;
		v_ValidateQuery VARCHAR2(8000);
		v_quoteChar 			CHAR(1);
		v_ISSecureFolder CHAR(1);
		v_FolderIdSP  VARCHAR2(2000);
		v_DocumentIndexes		VARCHAR2(8000);
		v_DBUserId				INTEGER;
		v_locale				Varchar2(30);
		v_MainCode 			INTEGER;
		v_DBExpectedProcessDelay	DATE; 
	temp_v_TableViewName	varchar2(255);
BEGIN     
	/* Initialize variables */ 
	v_FolLock	:=  'N'; 
	v_FolLockByUser	:= NULL; 
	v_DBUserRights	:= ''; 
	v_DBStatus	:= -1 ; 
	v_UpdateFlag	:= 'n'; 
	v_TempStr	:= ''; 
	v_DocumentIndexes	:=	'';
	v_MainCode := 0;
	v_quoteChar := CHR(39);
	
	/*
	v_locale:=REPLACE(temp_v_locale,v_quoteChar,v_quoteChar||v_quoteChar);
	v_locale:=REPLACE(v_locale,v_quoteChar||v_quoteChar,v_quoteChar);
	*/
	
	IF(temp_v_locale is NOT NULL) THEN
		SELECT sys.DBMS_ASSERT.noop(temp_v_locale) into v_locale FROM dual;
	END IF;
	
--	v_locale :=temp_v_locale;
	
	IF(temp_v_DBUserId is NOT NULL) THEN
		v_DBUserId:=CAST(REPLACE(temp_v_DBUserId,v_quoteChar,v_quoteChar||v_quoteChar) AS INTEGER);
	END IF;
		/*
	v_urn:=urn;
	v_FolderIdSP:=REPLACE(temp_v_FolderIdSP,v_quoteChar,v_quoteChar||v_quoteChar);
	v_urn:=REPLACE(v_urn,v_quoteChar,v_quoteChar||v_quoteChar);
	*/
	
	IF(temp_v_FolderIdSP is NOT NULL) THEN
		SELECT sys.DBMS_ASSERT.noop(temp_v_FolderIdSP) into v_FolderIdSP FROM dual;
	END IF;
	IF(urn is NOT NULL) THEN
		SELECT sys.DBMS_ASSERT.noop(urn) into v_urn FROM dual;
	END IF;
	

	/*
	v_ProcessInstanceId:=temp_v_ProcessInstanceId;
	v_ProcessInstanceId:=REPLACE(v_ProcessInstanceId,v_quoteChar,v_quoteChar||v_quoteChar);
	v_ActivityName:=temp_v_ActivityName;
	v_ActivityName:=REPLACE(v_ActivityName,v_quoteChar,v_quoteChar||v_quoteChar);
	v_QueueName:=temp_v_QueueName;
	v_QueueName:=REPLACE(v_QueueName,v_quoteChar,v_quoteChar||v_quoteChar);
	v_DBProcessDefId:=temp_v_DBProcessDefId;
	v_DBProcessDefId:=CAST(REPLACE(v_DBProcessDefId,v_quoteChar,v_quoteChar||v_quoteChar) AS INTEGER);
	v_ValidateQuery:=temp_v_ValidateQuery;
	
	*/
	IF(temp_v_ProcessInstanceId is NOT NULL) THEN
		SELECT sys.DBMS_ASSERT.noop(temp_v_ProcessInstanceId) into v_ProcessInstanceId FROM dual;
	END IF;
	
	IF(temp_v_ActivityName is NOT NULL) THEN
		SELECT sys.DBMS_ASSERT.noop(temp_v_ActivityName) into v_ActivityName FROM dual;
	END IF;
	
	IF(temp_v_QueueName is NOT NULL) THEN
		SELECT sys.DBMS_ASSERT.noop(temp_v_QueueName) into v_QueueName FROM dual;
	END IF;
	
	v_DBProcessDefId:=temp_v_DBProcessDefId;
	v_DBProcessDefId:=CAST(REPLACE(v_DBProcessDefId,v_quoteChar,v_quoteChar||v_quoteChar) AS INTEGER);
	IF(temp_v_ValidateQuery is NOT NULL) THEN
		SELECT sys.DBMS_ASSERT.noop(temp_v_ValidateQuery) into v_ValidateQuery FROM dual;
	END IF;
	/* Check Validity of User */ 
	/*	PRTCheckUser (v_DBConnectId, v_DBHostname, v_DBUserId , v_MainGroupId , v_DBStatus ); 

	IF (v_DBStatus <> 0) THEN 
	BEGIN 
		Status := v_DBStatus; 
		RETURN; 
	END; 
	END IF; */

	v_ValidationReqd1 := v_ValidationReqd; 
/*IF v_ValidationReqd1 IS NOT NULL THEN 
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
		IF UPPER(v_TempColumnType) IN ('VARCHAR2', 'CHAR', 'DATE') THEN /*Bug No WFS_6.1_050 Chnaged UPPER and varchar is converted to varchar2*/ 
			/* v_TempValue := CHR(39) || v_TempValue || CHR(39); 
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
			/*Check for rowcount [of cursor in validation block] to 1 in place of 0 -By Mandeep-WFS_6.1_045*/ 

		/*	IF(DBMS_SQL.fetch_rows(v_valcur) > 0) THEN  
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
	END; 
	END IF; 
	/* Changed By Varun Bhansaly On 11/04/2007 for Bugzilla Id 532 */
/*	If (v_InitiateFromActivityId > 0) THEN  
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
	Else  
		/* Changed By Varun Bhansaly On 11/04/2007 for Bugzilla Id 532 */
	/*	If(v_InitiateFromActivityName IS NOT NULL AND LENGTH(RTRIM(v_InitiateFromActivityName)) > 0 ) THEN  
			BEGIN 
				SELECT	ActivityId, ActivityName 
				INTO	v_ActivityId, v_ActivityName 
				FROM	ActivityTable 
				WHERE	ProcessDefID = v_DBProcessDefId 
				AND	ActivityType = 1 
				AND	UPPER(ActivityName) = UPPER(RTRIM(v_InitiateFromActivityName)); 
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
		/*End IF; 
	End IF; */
	BEGIN  
		
		SELECT 	TableName INTO temp_v_TableViewName 
		FROM 	ExtDBConfTable 
		WHERE 	ProcessDefId = v_DBProcessDefId
		AND ExtObjId = 1; 
		SELECT sys.DBMS_ASSERT.noop(temp_v_TableViewName) into v_TableViewName FROM dual;
	--v_TableViewName:=REPLACE(v_TableViewName,v_quoteChar,v_quoteChar||v_quoteChar);
	EXCEPTION 
		WHEN OTHERS THEN 
		v_TableViewName := NULL; 
	END; 

	v_UpdateColumnStr 	:= ''; 
	v_UpdateValueStr 	:= ''; 

	/*IF v_DataDefinitionName IS NOT NULL THEN  
		BEGIN 
			SELECT 	DataDefIndex INTO v_DBDataDefinitionIndex 
			FROM 	PDBDataDefinition 
			WHERE 	RTRIM(upper(DataDefName)) = RTRIM(upper(v_DataDefinitionName)) 
			AND 	GroupId = v_MainGroupId; 
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
				Raise OraExcpPkg.Excp_DDI_Not_Exist; 
				Status := v_DBStatus; 
				RETURN; 
		END; 

		v_DDTTableName := 'DDT_' || TO_CHAR(v_DBDataDefinitionIndex); 
	ELSE 
		 v_DBDataDefinitionIndex  := 0; 
	END IF; */

	IF v_urn IS NULL THEN
	BEGIN
	v_urn:=NULL;
	v_urnDup:=NULL;
	END;
	else
	BEGIN
	v_urnDup:=v_urn;
	v_urn:=CHR(39) || v_urn||CHR(39);
	END;
	END IF;
	
	/* sharepoint related changes */
	BEGIN
	IF v_SharepointFlag = 'N' THEN
	  IF ( v_DBDataDefinitionIndex <> 0 ) THEN  
	  BEGIN
		 v_WhileCounter := 1; 
		 v_ColumnList   := ''; 
		 v_ValueList    := ''; 
 
		WHILE v_WhileCounter <= 10 LOOP  
		BEGIN 
			IF v_WhileCounter = 1 THEN  
				 v_DBDDIDataList := v_DBDDIDataList1;  
			ELSE 
				IF v_WhileCounter = 2 THEN 
					 v_DBDDIDataList := v_DBDDIDataList2; 
				ELSE 
					IF v_WhileCounter = 3 THEN 
						 v_DBDDIDataList := v_DBDDIDataList3; 
					ELSE 
						IF v_WhileCounter = 4 THEN 
							 v_DBDDIDataList := v_DBDDIDataList4; 
						ELSE 
							IF v_WhileCounter = 5 THEN 
								 v_DBDDIDataList := v_DBDDIDataList5; 
							ELSE 
								IF v_WhileCounter = 6 THEN 
									 v_DBDDIDataList := v_DBDDIDataList6; 
								ELSE 
									IF v_WhileCounter = 7 THEN 
										 v_DBDDIDataList := v_DBDDIDataList7;  
									ELSE 
										IF v_WhileCounter = 8 	THEN 
											 v_DBDDIDataList := v_DBDDIDataList8;
										ELSE  
											IF v_WhileCounter = 9 THEN 
												v_DBDDIDataList := v_DBDDIDataList9; 
											ELSE 
												IF v_WhileCounter = 10 THEN 
													v_DBDDIDataList := v_DBDDIDataList10; 
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
			if(v_DBDDIDataList is NOT NULL) THEN
				v_DBDDIDataList:=REPLACE(v_DBDDIDataList,v_quoteChar,v_quoteChar||v_quoteChar);
				v_DBDDIDataList:=REPLACE(v_DBDDIDataList,v_quoteChar||v_quoteChar,v_quoteChar);
			Else
				v_DBDDIDataList:='';
				v_DBDDIDataList:=REPLACE(v_DBDDIDataList,v_quoteChar,v_quoteChar||v_quoteChar);
				v_DBDDIDataList:=NULL;
			END IF;
			v_ParseCount := 1; 
			v_TempStr := ''; 
			
			WHILE LENGTH(v_DBDDIDataList) > 0 LOOP  
			BEGIN 
				IF(v_ParseCount = 1) THEN 
				BEGIN 
					 v_pos1 := INSTR(v_DBDDIDataList,CHR(21),1); 
					IF (v_pos1 = 0) THEN  
					BEGIN 
						 v_TempStr := SUBSTR(v_DBDDIDataList, 1); 
						 v_DBDDIDataList := NULL; 
						EXIT;  
					END;  

					ELSE 
					BEGIN 
						 v_TempFieldName := RTRIM(v_TempStr) || SUBSTR(v_DBDDIDataList, 1, v_pos1-1); 
						 v_DBDDIDataList := SUBSTR(v_DBDDIDataList, v_pos1+1); 
						 v_ParseCount := 2; 
						 v_TempStr := ' '; 
					END; 
					END IF; 
				END; 
				END IF; 
				IF(v_ParseCount = 2) THEN 
				BEGIN 
					 v_pos1 := INSTR( v_DBDDIDataList,CHR(25),1); 
					IF (v_pos1 = 0) THEN 
					BEGIN 
						 v_TempStr := SUBSTR(v_DBDDIDataList, 1); 
						 v_DBDDIDataList := NULL; 
						 EXIT; 
					END; 
					ELSE 
					BEGIN 
						v_TempFieldValue	:= RTRIM(v_TempStr) || SUBSTR(v_DBDDIDataList, 1, v_pos1-1); 
						v_DBDDIDataList := SUBSTR(v_DBDDIDataList,v_pos1+1); 
						v_ParseCount := 1; 
						v_TempStr := ' '; 
						BEGIN  
							SELECT	 A.DataFieldIndex,DataFieldType 
							INTO v_TempFieldId,v_TempDataFieldType 
							FROM PDBGlobalIndex A, PDBDataFieldsTable B 
							WHERE A.DataFieldIndex = B.DataFieldIndex 
							AND   B.DataDefIndex = v_DBDataDefinitionIndex 
							AND   upper(A.DataFieldName) = upper(v_TempFieldName); 
						EXCEPTION 
							WHEN NO_DATA_FOUND THEN 
								STATUS := 15 ; 
								RETURN; 
						END;  

						IF TO_NUMBER(SQL%ROWCOUNT) > 0 THEN  
						BEGIN 
							v_ColumnList :=  RTRIM(v_ColumnList) || ', Field_' || TO_CHAR(v_TempFieldId); 
							v_size := LENGTH(LTRIM(RTRIM(v_TempFieldValue))); 
							/*  data class addition with 'S' and 'D' type fields not working properly(WFS_6.1_051)-Mandeep Kaur*/
							IF (LTRIM(RTRIM(v_TempFieldValue)) = CHR(181) OR v_size = 0)THEN  
								 v_TempFieldValue := 'NULL'; 
							END IF; 

							IF(v_TempFieldValue = 'NULL') THEN 
							BEGIN 
								IF v_TempDataFieldType = 'B' THEN 
									v_TempFieldValue := '0'; 
									v_ValueList := RTRIM(v_ValueList) || ','||LTRIM(RTRIM(v_TempFieldValue)); 
								END IF; 
							END; 
							ELSE 
								/*  data class addition with 'S' and 'D' type fields not working properly(WFS_6.1_051)-Mandeep Kaur*/
								IF (v_TempDataFieldType = 'S') THEN  
								BEGIN  
									v_QueryStr:= CHR(39) || CHR(39); 
									 v_TempFieldValue := REPLACE(v_TempFieldValue,CHR(39),v_QueryStr );  
									 v_ValueList := RTRIM(v_ValueList) || ',' || CHR(39) || RTRIM(v_TempFieldValue) || CHR(39); 
								END; 
								ELSE 
									IF (v_TempDataFieldType = 'D')THEN 
									BEGIN 
										v_ValueList := RTRIM(v_ValueList) || ',TO_DATE(' || CHR(39) || RTRIM(v_TempFieldValue) || CHR(39) || ',' || Chr(39) || 'YYYY-MM-DD' || CHR(39) ||')';  
									END; 
									ELSE 
										IF (v_TempDataFieldType	= 'I' OR 
											v_TempDataFieldType	= 'L' OR 
											v_TempDataFieldType	= 'F' OR 
											v_TempDataFieldType	= 'B' OR 
											v_TempDataFieldType	= 'X') THEN 
										BEGIN 
											 v_ValueList := RTRIM(v_ValueList) || ',' || LTRIM(RTRIM(v_TempFieldValue)); 
										END; 
										END IF; 
									END IF; 
								END IF; 
							END IF; 
							CheckData  ('F', v_NewFolderIndex,RTRIM(upper(v_DDTTableName)), RTRIM(v_TempFieldId),RTRIM(upper(v_TempDataFieldType)), v_TempFieldValue, v_DBStatus ); 
							IF (v_DBStatus <> 0) THEN 
							BEGIN 
								 Status := v_DBStatus ; 
								RETURN; 
							END; 
							END IF; 
						END; 
						END IF; 
					END; 
					END IF; 
				END; 
				END IF; 
			END; 
			END LOOP; 
			v_WhileCounter := v_WhileCounter + 1; 
		END; 
		END LOOP; 
	END; 
	END IF; 

	v_DBAccessType		:= NVL(v_DBAccessType, 'I'); 
	v_DBComment		:= NVL(v_DBComment,	'Not Defined'); 
	v_DuplicateNameFlag	:= NVL(v_DuplicateNameFlag, 'Y'); 
	v_CurrDate := SYSDATE; 
	SELECT ISSecureFolder INTO v_ISSecureFolder FROM ProcessDefTable WHERE ProcessDefId = v_DBProcessDefId;
	IF (NVL(v_ISSecureFolder, 'N') = 'N') THEN
		v_DBFolderType := 'G';
	ELSE
		v_DBFolderType := 'K';
	END IF;
	
   IF v_DBExpiryDateTime IS NULL THEN   
    BEGIN  
         v_ExpiryDateTime := to_date('31/12/2099', 'DD/MM/YYYY');  
    END;  
    ELSE  
    BEGIN   
         v_ExpiryDateTime :=CAST(v_DBExpiryDateTime AS DATE);  -- Never used,to be checked again
    END;  
    END IF; 

	BEGIN 
		SELECT 	 UserName INTO v_UserName /*Bug No WFS_6.1_049 Replaced v_UserNameLong by v_UserName*/  
		FROM 	PDBUser 
		WHERE 	UserIndex = v_DBUserId; 
		v_UserName:=REPLACE(v_UserName,v_quoteChar,v_quoteChar||v_quoteChar);
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			v_UserName:= NULL; 
			STATUS := 15 ; 
			RETURN; 
	END; 

	/*BEGIN  
		SELECT   WorkFlowFolderId INTO v_DBParentFolderId  
		FROM   RouteFolderDefTable 
		WHERE  ProcessDefId = v_DBProcessDefId; 
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			BEGIN 
				Raise OraExcpPkg.Excp_Invalid_Parameter; 
				Status := v_DBStatus; 
				RETURN; 
			END; 
	END;*/

	/*BEGIN  
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
		AND		ROWNUM = 1; /* changed by Tirupati srivastava on 3/5/2007 for Bugzilla Id 676 */
	--END; 

	/*SAVEPOINT TranWorkItem; 
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

	IF SQL%ROWCOUNT<=0 THEN 
		BEGIN 
			Status := 15; 
			RETURN; 
		END; 
	END IF; 

	COMMIT; */

	/*IF v_ProcessState <> 'Enabled' THEN 
	BEGIN 
		 v_DBStatus := 2; 
		 Status   := v_DBStatus; 
		 RETURN; 
	END; 
	END IF; 

	v_RegStartingNo	:= v_RegStartingNo; 
	v_RegPrefix	:= v_RegPrefix || '-'; 
	v_RegSuffix	:= '-' || v_RegSuffix ; 

	IF LENGTH(v_RegStartingNo) > (v_RegSeqLength - LENGTH(v_RegPrefix) - LENGTH(v_RegSuffix)) THEN  
	BEGIN 
		 v_DBStatus := 19; 
		 Status   := v_DBStatus; 
		 RETURN; 
	END; 
	END IF; 

	v_Length		:= v_RegSeqLength - LENGTH(v_RegPrefix) - LENGTH(v_RegSuffix); 
	v_ProcessInstanceId	:= RPAD('0', v_Length,'0'); 
	v_ProcessInstanceId	:= v_RegPrefix || SUBSTR(v_ProcessInstanceId,1, LENGTH(v_ProcessInstanceId) - LENGTH(v_RegStartingNo)) || TO_CHAR(v_RegStartingNo) || v_RegSuffix; */
	v_DBFolderName		:= v_ProcessInstanceId;  

	BEGIN 
		SELECT 	 FolderLock, 
			 FinalizedFlag, 
			 Location, 
			 FolderType, 
			 NVL(v_DBImageVolumeIndex, ImageVolumeIndex),  
			 Owner, 
			 AccessType, 
			 ACLMoreFlag, 
			 ACL, 
			 EnableVersion, 
			 EnableFTS, 
			 LockMessage, 
			 LockByUser, 
			 FolderLevel 
			 INTO v_FolderLock,v_FinalizedFlag,v_DBLocation,v_ParentFolderType,v_DBImageVolumeIndex,v_TempUser,v_AccessType,  
			 v_ACLMore,v_ACLstr,v_EnableVersion,v_ParentEnableFTS,v_LockMessage,v_LockByUser,v_FolderLevel  
		FROM PDBFolder 
		WHERE FolderIndex = v_DBParentFolderId 
		AND (v_MainGroupId = 0 OR MainGroupId = v_MainGroupId); 
	EXCEPTION  
		WHEN NO_DATA_FOUND THEN 
			BEGIN 
				Raise OraExcpPkg.Excp_Folder_Not_Exist; 
				Status := v_DBStatus; 
				RETURN; 
			END; 
		IF (NOT(v_DBLocation IN ('R','G','A','K') and v_DBFolderType IN ('G','A','K'))) THEN 
		BEGIN 
			 Raise OraExcpPkg.Excp_Cannot_AddFolder; 
			 Status := v_DBStatus; 
			RETURN; 
		END; 
		ELSE  
			IF v_ParentFolderType  <>  v_DBFolderType  THEN  
			BEGIN  
				 Raise OraExcpPkg.Excp_Cannot_AddFolder; 
					Status := v_DBStatus; 
				RETURN; 
			END; 
			ELSE  
				IF (v_FolderLock = 'Y') THEN  
				BEGIN 
					/* Fetch effective lock by user and lock message */
					CheckLock('F', v_DBParentFolderId, v_LockByUser, v_FolderLock, v_EffectiveLockByUser, 
								v_LockMessage , v_LockedObject , v_DBStatus ); 
					IF v_EffectiveLockByUser <> v_DBUserId THEN  
					BEGIN 
						Raise OraExcpPkg.Excp_Folder_Locked; 
							Status := v_DBStatus; 
						RETURN; 
					END; 
					END IF; 
				v_FolLock		:= 'Y'; 
				v_FolLockByUser		:= v_LockByUser; 

				END; 
				ELSE  
					IF (v_FinalizedFlag = 'Y') THEN 
					BEGIN 
						 Raise OraExcpPkg.Excp_Finalised_Folder; 
							Status := v_DBStatus; 
						RETURN; 
					END; 
					END IF; 
				END IF; 
			END IF; 
		END IF; 
	END; 

	IF v_FolderLevel >= 255	THEN  
	BEGIN 
		 Raise OraExcpPkg.Excp_Max_Level_Count_Reached; 
			Status := v_DBStatus; 
		RETURN; 
	END; 
	END IF;  

	IF v_LimitCount IS NOT NULL THEN 
	BEGIN 
		SELECT COUNT(*) 
		INTO v_count 
		FROM PDBFolder 
		WHERE ParentFolderIndex = v_DBParentFolderId  
		AND AccessType = v_DBAccessType; 

		IF (v_count >= v_LimitCount) THEN  
		BEGIN 
			 Raise OraExcpPkg.Excp_Max_Folder_Count_Reached; 
			 Status := v_DBStatus; 
			RETURN; 
		END; 
		END IF; 
	END; 
	END IF; 

	/* Generate the name of the folder if the foldername given is NULL*/
	IF v_DBFolderName IS NULL THEN  
	BEGIN 
		 PRTGenerateDefaultName( 'F',v_DBParentFolderId, NULL, NULL, v_MainGroupId, v_DBFolderName , 
						v_DBStatus ); 
		IF (v_DBStatus <> 0) THEN 
		BEGIN 
				Status := v_DBStatus; 
			RETURN; 
		END; 
		END IF; 
	END; 
/*	ELSE 	/ * Check for the uniqueness of the folder	* /
	BEGIN  
		GenerateName('F' , v_DBFolderName, v_DBParentFolderId, NULL, NULL, v_NameLength, v_MainGroupId, 
					v_DuplicateNameFlag, null, v_DBFolderName , v_DBStatus ); 
		IF v_DBStatus <> 0 THEN  
		BEGIN  
				Status := 	v_DBStatus; 
			RETURN; 
		END; 
		END IF; 
	END; */
	END IF; 

	 v_Hierarchy := NVL(RTRIM(v_Hierarchy), '') || RTRIM(TO_CHAR(v_DBParentFolderId)) || '.'; 

	--SAVEPOINT TranWorkItem; 
	SELECT FolderId.NextVal INTO v_NewFolderIndex from dual; 

	INSERT INTO PDBFolder(FolderIndex,ParentFolderIndex, Name, Owner, CreatedDatetime, RevisedDateTime, 
        AccessedDateTime, DataDefinitionIndex, AccessType, ImageVolumeIndex,  
        FolderType, FolderLock, LockByUser, Location, DeletedDateTime,  
        EnableVersion, ExpiryDateTime, Commnt, UseFulData, ACL, FinalizedFlag,  
        FinalizedDateTime, FinalizedBy, ACLMoreFlag, MainGroupId, EnableFTS, LockMessage, 
        Folderlevel)   
    VALUES (v_NewFolderIndex, v_DBParentFolderId, v_DBFolderName, v_DBUserId, v_CurrDate, v_CurrDate, 
        v_CurrDate, v_DBDataDefinitionIndex, v_DBAccessType, v_DBImageVolumeIndex,  
        v_DBFolderType, v_FolLock, v_FolLockByUser, v_ParentFolderType,to_date('31/12/2099', 'DD/MM/YYYY'), 
        NVL(v_DBVersionFlag, v_EnableVersion), v_ExpiryDateTime, NVL(v_DBComment,''), NULL, NULL, 'N',  
        to_date('31/12/2099', 'DD/MM/YYYY'), 0, 'N', v_MainGroupId, NVL(v_DBEnableFTS, v_ParentEnableFTS), 
        v_LockMessage, v_FolderLevel + 1);

	IF( v_DBDataDefinitionIndex > 0) THEN 
	BEGIN 
		IF LENGTH(v_ColumnList) > 0 THEN 
		BEGIN 
			 v_ColumnList   := ' FoldDocIndex, FoldDocFlag' || v_ColumnList; 
			 v_ValueList    :=TO_CHAR(v_NewFolderIndex) || ',' || CHR(39) || 'F' || CHR(39) || v_ValueList; 
			 EXECUTE IMMEDIATE ('INSERT INTO ' || v_DDTTableName || ' ( ' || v_ColumnList || ' ) VALUES ( ' || 
				v_ValueList || ')'); 
			 v_DBStatus := SQLCODE; 

			IF v_DBStatus <> 0 THEN  
			BEGIN  
				--ROLLBACK TO SAVEPOINT TranWorkItem; 
					Status := 15; 
				RETURN; 
			END; 
			END IF; 

		END; 
		END IF; 
	PRTBuildUseFulDataString (v_NewFolderIndex, 'F', v_DBDataDefinitionIndex, v_DBStatus ); 
	END; 
	END IF; 

	v_WhileCounter := 1; 
	v_NextOrder := 0; 
	v_TempStr := '';

	WHILE  v_WhileCounter <= 5 LOOP  
	BEGIN 
		IF v_WhileCounter = 1 THEN  
			 v_DBDocumentList := v_DBDocumentList1; 
		ELSE 
			IF v_WhileCounter = 2  THEN 
				 v_DBDocumentList := v_DBDocumentList2; 
			ELSE 
				IF v_WhileCounter = 3 THEN 
					 v_DBDocumentList := v_DBDocumentList3; 
				ELSE 
					IF v_WhileCounter = 4 THEN 
						 v_DBDocumentList := v_DBDocumentList4; 
					ELSE 
						IF v_WhileCounter = 5 THEN 
							 v_DBDocumentList := v_DBDocumentList5; 
						END IF; 
					END IF; 
				END IF; 
			END IF; 
		END IF; 
 
		--v_TempStr := ''; 
		v_UniqueNameString := ';';
		WHILE LENGTH(v_DBDocumentList) > 0 LOOP  
		BEGIN  
			v_DocumentType := NULL;
			v_pos1 := INSTR( v_DBDocumentList,CHR(25),1); 
			IF v_pos1 = 0 THEN  
			BEGIN  
				v_TempStr := SUBSTR(v_DBDocumentList, 1); 
				v_DBDDIDataList := NULL; 
				EXIT; 
			END; 
			ELSE  
			BEGIN  
				 v_TempStr 	:= RTRIM(v_TempStr) || RTRIM(SUBSTR(v_DBDocumentList, 1, v_pos1-1)); 
				 v_DBDocumentList	:= SUBSTR(v_DBDocumentList,v_pos1+1);  
				 
				 IF RTRIM(SUBSTR(v_TempStr, LENGTH(v_TempStr), 1)) = CHR(21) THEN
					v_TempStr := RTRIM(SUBSTR(v_TempStr, 1, LENGTH(v_TempStr) -1));
				 END IF;
				
				 v_pos1 	:= INSTR( v_TempStr,CHR(21),1); 
				 v_DocumentName := RTRIM(SUBSTR(v_TempStr, 1, v_pos1-1)); 
				 /* Changed By Varun Bhansaly On 22/10/2007 for Bugzilla Id 1293 */
				 v_TempStr 	:= SUBSTR(v_TempStr, v_pos1 + 1); 
				 v_pos1 	:= INSTR( v_TempStr,CHR(21),1); 
				 v_ISIndexStr 	:= RTRIM(SUBSTR(v_TempStr, 1, v_pos1-1)); 
				 /* Changed By Varun Bhansaly On 22/10/2007 for Bugzilla Id 1293 */
				 v_TempStr 	:= SUBSTR(v_TempStr, v_pos1 + 1);
				 v_pos1 	:= INSTR( v_TempStr,CHR(21),1); 
				 v_NoOfPage 	:= TO_NUMBER(RTRIM(SUBSTR(v_TempStr, 1, v_pos1-1))); 
				 /* Changed By Varun Bhansaly On 22/10/2007 for Bugzilla Id 1293 */
				 v_TempStr 		:= SUBSTR(v_TempStr, v_pos1 + 1);
				 v_pos1 		:= INSTR(v_TempStr, CHR(21), 1);
				 /*WFS_8.0_013*/
				 IF v_pos1 >1 THEN
				 BEGIN
					 v_DocumentSize := TO_NUMBER(RTRIM(SUBSTR(v_TempStr, 1,v_pos1-1)));					 
					 v_TempStr 	:= SUBSTR(v_TempStr, v_pos1+1);
					 v_pos1 	:= INSTR( v_TempStr,CHR(21),1);
					 IF v_pos1 >1 THEN
					 BEGIN
						 v_AppType	:= RTRIM(SUBSTR(v_TempStr, 1,v_pos1-1));
						 /*v_Comment	:= RTRIM(SUBSTR(v_TempStr, v_pos1+1));*/
						 v_TempStr 	:= SUBSTR(v_TempStr, v_pos1+1);
						 v_pos1 	:= INSTR( v_TempStr,CHR(21),1);
						 IF v_pos1 = 2 THEN
						 BEGIN
							v_DocumentType := RTRIM(SUBSTR(v_TempStr, 1,v_pos1-1));
							v_Comment := RTRIM(SUBSTR(v_TempStr, v_pos1 + 1, LENGTH(v_TempStr) - 2));
						 END;
						 ELSE
						 BEGIN
							IF LENGTH(v_TempStr) = 1 THEN
							BEGIN
								v_DocumentType := RTRIM(SUBSTR(v_TempStr, 1, LENGTH(v_TempStr)));
								v_Comment := '';
							END;
							ELSE
							BEGIN
								v_Comment := RTRIM(SUBSTR(v_TempStr, 1, LENGTH(v_TempStr)));
							END;
							END IF;
						 END;
						 END IF;
					 END;
					 ELSE
					 BEGIN
						 v_AppType	:= RTRIM(SUBSTR(v_TempStr, v_pos1+1));
						 v_Comment	:= '';
					 END;
					 END IF;
				 END;
				 ELSE
				 BEGIN
					v_DocumentSize := TO_NUMBER(RTRIM(SUBSTR(v_TempStr, v_pos1+1)));
					v_AppType	:='TIF';
					v_Comment	:= ''; 
				 END;
				 END IF;
				 /*WFS_8.0_013*/
				 /* Bug No WFS_6.1.2_059 hash symbol replaced by chr(35) - Ruhi Hira */
				 v_pos1 	:= INSTR( v_ISIndexStr,CHR(35),1); 
				 v_ImageIndex 	:= TO_NUMBER(LTRIM(RTRIM(SUBSTR(v_ISIndexStr, 1, v_pos1-1)))); 
				 /* Changed By Varun Bhansaly On 22/10/2007 for Bugzilla Id 1293 */
				 v_VolumeIndex 	:= TO_NUMBER(LTRIM(RTRIM(SUBSTR(v_ISIndexStr, v_pos1+1))));
				 v_TempStr := '';
				 
				 /*Bugzilla bug id 3129*/
				 IF v_DocumentType IS NULL OR v_DocumentType = NULL THEN
				 BEGIN
				 	IF(UPPER(v_AppType) = 'TIF' OR UPPER(v_AppType) = 'TIFF' OR UPPER(v_AppType) = 'BMP' OR UPPER(v_AppType) = 'JPEG' OR UPPER(v_AppType) = 'JPG' OR UPPER(v_AppType) = 'JIF' OR UPPER(v_AppType) = 'GIF') THEN 
						--Removing 'PNG' for bugzilla bugID - 88867
				 		v_DocumentType := 'I';
				 	ELSE 
				 		v_DocumentType := 'N';
				 	END IF;
				 END;
				 END IF;
				 v_pos1 	:= INSTR(v_UniqueNameString, ';' || v_DocumentName || '.' || v_AppType || ';');
				 IF (v_pos1 > 0 ) THEN
					GenerateName('D', v_DocumentName, v_NewFolderIndex, v_DocumentType, v_AppType, 255, v_MainGroupId, 'Y', null, v_DocumentName, v_DBStatus); 

					 IF v_DBStatus <> 0 THEN 
					 BEGIN 
						--ROLLBACK TO SAVEPOINT TranWorkItem; 
						Status := v_DBStatus ; 
						RETURN; 
					 END ; 
					 END IF; 
				 ELSE
				 	 v_UniqueNameString := v_UniqueNameString  ||v_DocumentName || '.' || v_AppType || ';';  
				 END IF; 

				SELECT  DocumentID.NextVal INTO v_NewDocumentIndex from dual; 
				select replace(v_Comment,'''','''''') into v_Comment FROM DUAL;


				/* 43 attributes are set from the PDBDocument*/
                INSERT INTO PDBDocument(DocumentIndex,VersionNumber, VersionComment,  
                    Name, Owner, CreatedDateTime, RevisedDateTime,  
                    AccessedDateTime, DataDefinitionIndex,  
                    Versioning, AccessType, DocumentType,  
                    CreatedbyApplication, CreatedbyUser,  
                    ImageIndex, VolumeId, NoOfPages, DocumentSize,  
                    FTSDocumentIndex, ODMADocumentIndex,  
                    HistoryEnableFlag, DocumentLock, LockByUser,  
                    Commnt, Author, TextImageIndex, TextVolumeId,  
                    FTSFlag, DocStatus, ExpiryDateTime,  
                    FinalizedFlag, FinalizedDateTime, FinalizedBy,  
                    CheckOutstatus, CheckOutbyUser,    UseFulData,  
                    ACL, PhysicalLocation, ACLMoreFlag, AppName,  
                    MainGroupId, PullPrintFlag, ThumbNailFlag,  
                    LockMessage)   
                 VALUES (v_NewDocumentIndex, 1.0,    'Original',  
                    v_DocumentName, v_DBUserId, v_CurrDate, v_CurrDate,  
                    v_CurrDate, 0,  
                    v_EnableVersion, 'I', v_DocumentType,  
                    0, v_DBUserId,  
                    v_ImageIndex, v_VolumeIndex, v_NoOfPage, v_DocumentSize,  
                    0, 'not defined',  
                    'N', 'N', NULL,  
                    v_Comment, v_UserName, 0, 0, /*Bug No WFS_6.1_049 Replaced v_UserNameLong by v_UserName*/ 
                    'XX', 'A', to_date('31/12/2099', 'DD/MM/YYYY'),  
                    'N', to_date('31/12/2099', 'DD/MM/YYYY'), 0,  
                    'N', 0, NULL,  
                    NULL, 'not defined', 'N', v_AppType,  
                    v_MainGroupId, 'N', 'N', NULL);

				v_DBStatus := SQLCODE ; 

				IF (v_DBStatus <> 0) THEN  
				BEGIN  
					--ROLLBACK TO SAVEPOINT TranWorkItem ; 
						Status := 15; 
					RETURN	 ; 
				END ; 
				END IF; 
 
				v_NextOrder := v_NextOrder + 1; 
				INSERT INTO PDBDocumentContent( 
					ParentFolderIndex, DocumentIndex, 
					FiledBy, FiledDatetime, 
					DocumentOrderNo, RefereceFlag) 
				 VALUES(v_NewFolderIndex, v_NewDocumentIndex, 
					v_DBUserId, v_CurrDate, v_NextOrder , 'O') ; 
				 v_DBStatus := SQLCODE ; 
				v_DocumentIndexes := v_DocumentIndexes || v_DocumentName || CHR(21) || TO_CHAR(v_NewDocumentIndex) || CHR(21) || TO_CHAR(v_ImageIndex) || CHR(35) || TO_CHAR(v_VolumeIndex) || CHR(25) ;

				IF (v_DBStatus <> 0) THEN  
				BEGIN  
					--ROLLBACK TO SAVEPOINT TranWorkItem;  
					Status := 15; 
					RETURN; 
				END; 
				END IF;
                /*WFS_8.0_037*/                                          
                IF v_Comment IS NULL THEN  
				BEGIN  
                    v_FieldName:=v_DocumentName;
				END; 
                ELSE
                Begin
                    v_FieldName:=v_DocumentName  ||  '('  ||  v_Comment ||  '.'  ||  v_AppType || ')';
				End;
                END IF;
               /* Insert Into WFMessageTable (messageId,message, status,ActionDateTime)
                values(seq_messageId.NEXTVAL,'<Message><ActionId>18</ActionId><UserId>'  ||  TO_CHAR(v_DBUserId)  || 
                '</UserId><ProcessDefId>'  ||  TO_CHAR(v_DBProcessDefId)  || 
                '</ProcessDefId><ActivityId>'  ||  TO_CHAR(v_ActivityId)  || 
                '</ActivityId><QueueId>' ||  TO_CHAR( v_QueueId)  || 
                '</QueueId><UserName>'  || trim(to_nchar(NVL(v_UserName,'')))  || 
                '</UserName><ActivityName>'  ||  v_ActivityName  || 
                '</ActivityName><TotalWiCount>1</TotalWiCount><TotalDuration>0</TotalDuration><ProcessInstance>'  ||  v_ProcessInstanceId  || 
                '</ProcessInstance><FieldId>'  ||  TO_CHAR(v_QueueId)  || 
                '</FieldId><WorkitemId>1</WorkitemId><TotalPrTime>0</TotalPrTime><DelayTime>0</DelayTime><WKInDelay>0</WKInDelay><ReportType>D</ReportType><LoggingFlag>1</LoggingFlag><FieldName>' ||
                v_FieldName || '</FieldName></Message>',
                N'N', SYSDATE ); */
				select replace(v_FieldName,'''','''''') into v_FieldName FROM DUAL;
				WFGenerateLog(18, v_DBUserId, v_DBProcessDefId, v_ActivityId, v_QueueId, trim(to_nchar(NVL(v_UserName,''))), v_ActivityName, 0, v_ProcessInstanceId, v_QueueId, v_FieldName, 1, 0, 0, v_MainCode,null,v_ProcessVariantId,0,0,v_urnDup,NULL,NULL,v_tarHisLog,v_targetCabinet);
			
			END; 
			END IF; 
		END; 
		END LOOP;  
		v_WhileCounter := v_WhileCounter + 1; 
	END;  
	END LOOP;  
	END IF; --End of sharepoint IF
	END;		--END of sharepoint begin.
	
	BEGIN 
		v_sysattrcur := DBMS_SQL.open_cursor; 
		v_QueryStr := 'SELECT A.UserDefinedName, A.SystemDefinedName, A.VariableType 
			FROM 	VarMappingTable A, RecordMappingTable B 
			WHERE 	A.ProcessDefId	=' || v_DBProcessDefId || 
			'AND 	A.ProcessDefId 	= B.ProcessDefId 
			AND 	A.VariableScope = ''M'' 
			AND 	(UPPER(A.UserDefinedName) = UPPER(B.REC1) OR UPPER(A.UserDefinedName) = UPPER(B.REC2) OR UPPER(A.UserDefinedName) = UPPER(B.REC3) OR UPPER(A.UserDefinedName) = UPPER(B.REC4) OR UPPER(A.UserDefinedName) = UPPER(B.REC5))'; 

		DBMS_SQL.Parse(v_sysattrcur,v_QueryStr,DBMS_SQL.NATIVE); 
		DBMS_SQL.define_column(v_sysattrcur,1,v_UserDefinedName,50); 
		DBMS_SQL.define_column(v_sysattrcur,2,v_SystemDefinedName,50); 
		DBMS_SQL.define_column(v_sysattrcur,3,v_VariableType); 

		v_retval := DBMS_SQL.execute(v_sysattrcur); 

		WHILE DBMS_SQL.fetch_rows(v_sysattrcur) > 0 LOOP 
		BEGIN 
			DBMS_SQL.column_value(v_sysattrcur,1,v_UserDefinedName); 
			DBMS_SQL.column_value(v_sysattrcur,2,v_SystemDefinedName); 
			DBMS_SQL.column_value(v_sysattrcur,3,v_VariableType); 
						
			v_UserDefinedName:=REPLACE(v_UserDefinedName,v_quoteChar,v_quoteChar||v_quoteChar);			
			
			IF upper(LTRIM(RTRIM(v_UserDefinedName))) = 'ITEMINDEX' THEN 
			BEGIN  
				IF(	v_SharepointFlag = 'N') THEN
					v_Var_Rec_1 := TO_CHAR(v_NewFolderIndex); 
				ELSIF(v_SharepointFlag = 'Y') THEN
					v_Var_Rec_1 := TO_CHAR(v_FolderIdSP); 
				END IF;
				IF v_UpdateFlag = 'Y'  THEN 
				BEGIN 
					 v_UpdateColumnStr:= RTRIM(v_UpdateColumnStr) || ',' || v_SystemDefinedName ; 
					 v_UpdateValueStr := v_UpdateValueStr || ',' || CHR(39) || RTRIM(v_Var_Rec_1) || CHR(39); 
				END; 
				ELSE  
				BEGIN  
					 v_UpdateFlag	:= 'Y'; 
					 v_UpdateColumnStr := RTRIM(v_SystemDefinedName); 
					 v_UpdateValueStr  := CHR(39) || RTRIM(v_Var_Rec_1) || CHR(39); 
				END; 
				END IF; 

			v_InsertExtColumnStr := v_InsertExtColumnStr || ',' || v_UserDefinedName; 
			v_InsertExtValueStr  := v_InsertExtValueStr || ',' || v_Var_Rec_1;  
			END;  

			ELSE 
				IF upper(LTRIM(RTRIM(v_UserDefinedName))) = 'ITEMTYPE' THEN 
					BEGIN 
						 v_Var_Rec_1 	:= CHR(39) || 'F' || CHR(39) ; 

						IF v_UpdateFlag = 'Y' THEN 
						BEGIN 
							 v_UpdateColumnStr:= RTRIM(v_UpdateColumnStr) || ',' || v_SystemDefinedName ; 
							 v_UpdateValueStr := LTRIM(RTRIM(v_UpdateValueStr)) || ','|| RTRIM(v_Var_Rec_1); 
						END; 
						ELSE 
						BEGIN 
							 v_UpdateFlag := 'Y' ; 
							 v_UpdateColumnStr := RTRIM(v_SystemDefinedName); 
							 v_UpdateValueStr  :=  RTRIM(v_Var_Rec_1) ; 

						END; 
						END IF; 
					v_InsertExtColumnStr := v_InsertExtColumnStr || ',' || v_UserDefinedName; 
					v_InsertExtValueStr  := v_InsertExtValueStr || ',' || v_Var_Rec_1; 
					END; 
				ELSE  
					BEGIN  
						 v_Var_Rec_1 := ' NULL '; 
						 v_InsertExtColumnStr := v_InsertExtColumnStr || ',' || v_UserDefinedName; 
						 v_InsertExtValueStr  := v_InsertExtValueStr || ',' || v_Var_Rec_1; 
					END; 
				END IF; 
			END IF; 
		END; 
		END LOOP; 
		DBMS_SQL.CLOSE_CURSOR(v_sysattrcur); 
	EXCEPTION 
		WHEN OTHERS THEN 

			DBMS_SQL.CLOSE_CURSOR(v_sysattrcur); 
			--ROLLBACK TO SAVEPOINT TranWorkItem;/*By Mandeep SRNo-5 Rollback Missing */ 
			Status := 15; 
			RETURN; 
	END;  
	/* Changed By : Varun Bhansaly On 02/02/2007 */
	/*
	SELECT  ProcessTurnAroundTime  INTO  v_ProcessTurnAroundTime  
			FROM PROCESSDEFTABLE A, ACTIVITYTABLE B  
			WHERE 	A.ProcessDefId = B.ProcessDefId 
			AND 	B.ProcessDefId = v_DBProcessDefId 
			AND		ActivityId = v_ActivityId ; */ /* Bugzilla Bug 270 - For multiple introduction worksteps */

	/* Changed by Ruhi on May 10th 2005, SrNo-1, valid till is always null*/
	 v_ValidTill := NULL; 
	/* ____________________________________________________________________________________
	// Changed On  : 5/08/2005
	// Changed By  : Mandeep Kaur
	// Description : SRNo-3, ExpectedProcessDelay is set as 1900-01-01 00:00:00.000 in uploadWorkitem;
	                         it should be ProcessTurnAroundTime + currentDate rather than 0
	// ____________________________________________________________________________________*/
	/* WFS_6.1_022 - Mandeep */

	/* Changed By : Varun Bhansaly On 02/02/2007 */
	/* ______________________________________________________________________________________
		// Changed On  : 07/07/2009
		// Changed By  : Saurabh Kamal
		// Description : WFS_8.0_010, IF-ELSE added.Inserting ProcessInstanceState as 1 and 
		//		 IntroducedByID, IntroducedBy,IntroductionDatetime as NULL	
		// ____________________________________________________________________________________*/
	IF (v_InitiateAlso = N'Y'AND v_syncRoute = N'N') THEN
		BEGIN
		
		IF(temp_v_DBQDTValueList is NOT NULL) THEN
		SELECT sys.DBMS_ASSERT.noop(temp_v_DBQDTValueList) into v_DBQDTValueList FROM dual;
		END IF;
		IF(temp_v_DBQDTColumnList is NOT NULL) THEN
			SELECT sys.DBMS_ASSERT.noop(temp_v_DBQDTColumnList) into v_DBQDTColumnList FROM dual;
		END IF;
		IF(temp_v_DBExpectedProcessDelay is NOT NULL) THEN
			SELECT sys.DBMS_ASSERT.noop(temp_v_DBExpectedProcessDelay) into v_DBExpectedProcessDelay FROM dual;
		END IF;
		IF(temp_v_ProcessName is NOT NULL) THEN
			SELECT sys.DBMS_ASSERT.noop(temp_v_ProcessName) into v_ProcessName FROM dual;
		END IF;
		/*
		v_DBQDTValueList:=temp_v_DBQDTValueList;
		v_DBQDTValueList:=REPLACE(v_DBQDTValueList,v_quoteChar,v_quoteChar||v_quoteChar);
		v_DBQDTValueList:=REPLACE(v_DBQDTValueList,v_quoteChar||v_quoteChar,v_quoteChar);
		*/
			v_QueryStr := '	Insert Into WFInstrumentTable (URN,ProcessInstanceId, ProcessDefID, Createdby, CreatedDatetime,ProcessinstanceState,
				CreatedByName,IntroducedByID, IntroducedBy,IntroductionDatetime,ExpectedProcessDelay, IntroducedAt,WorkItemId,ProcessName,
				ProcessVersion,LastProcessedBy,	ProcessedBy,ActivityName,ActivityId,ActivityType,EntryDateTime,AssignmentType,CollectFlag,PriorityLevel,
				ValidTill,Q_StreamId,Q_QueueId,Q_UserId,AssignedUser,FilterValue, WorkItemState,Statename,ExpectedWorkitemDelay,
				PreviousStage,LockedByName,LockStatus,LockedTime,Queuename,Queuetype,NotifyStatus,RoutingStatus,ProcessVariantId,SaveStage, 
				InstrumentStatus, CheckListCompleteFlag' || NVL(v_DBQDTColumnList, ' ') || ', ' || v_UpdateColumnStr ||' , Locale )
			Values (N'||NVL(v_urn,'''''')||',N' || CHR(39) || v_ProcessInstanceId || CHR(39)||', '|| TO_CHAR(v_DBProcessDefId)||','|| TO_CHAR( v_DBUserId)||',
			SYSDATE,2, N'|| CHR(39) ||trim(to_nchar(v_UserName))|| CHR(39) || ','||TO_CHAR(v_DBUserId)||',N'||CHR(39) ||trim(to_nchar(v_UserName))|| CHR(39)||',
			SYSDATE,N'|| CHR(39) || NVL(v_DBExpectedProcessDelay,null)|| CHR(39) || ', N'|| CHR(39) ||v_ActivityName|| CHR(39)||',1,
			N'|| CHR(39) ||v_ProcessName|| CHR(39)||', '|| TO_CHAR(v_ProcessVersion)||','|| TO_CHAR( v_DBUserId)||',
			N'|| CHR(39) ||trim(to_nchar(v_UserName))|| CHR(39)||', N'|| CHR(39) ||v_ActivityName|| CHR(39)||',
			'|| TO_CHAR( v_ActivityId)||',1, SYSDATE,N'|| CHR(39) ||'Y'|| CHR(39)||',
			N'|| CHR(39) ||'N'|| CHR(39)||','|| TO_CHAR(v_DBPriorityLevel)||',N'|| CHR(39) ||NVL(v_ValidTill,null)|| CHR(39)||',
			NULL,NULL,NULL,NULL,NULL,6,
			N'|| CHR(39) ||'COMPLETED'|| CHR(39)||',NULL,N'|| CHR(39) ||v_ActivityName|| CHR(39)||',NULL,N'|| CHR(39) ||'N'|| CHR(39)||',
			SYSDATE,NULL,NULL,NULL,
			N'|| CHR(39) ||'Y'|| CHR(39)||','|| TO_CHAR(v_ProcessVariantId)||', N'|| CHR(39) ||v_ActivityName|| CHR(39)||' ,
			N'|| CHR(39) ||'N'|| CHR(39)||', N'|| CHR(39) ||'N' || CHR(39) || NVL(v_DBQDTValueList, ' ') || ',' || v_UpdateValueStr ||' , N'||CHR(39)|| NVL(v_locale,'en_US')||CHR(39)||' )';
			
			/*Insert into ProcessInstanceTable (ProcessInstanceId , ProcessDefID , Createdby , CreatedDatetime , 
					ProcessinstanceState , CreatedByName,IntroducedByID, IntroducedBy,IntroductionDatetime, 
					ExpectedProcessDelay, IntroducedAt, ProcessVariantId)  
			Values (v_ProcessInstanceId, v_DBProcessDefId, v_DBUserId, v_CurrDate,2, trim(to_nchar(v_UserName)),/*Bug No WFS_6.1_049 Replaced v_UserName by trim(to_nchar(v_UserName))
				v_DBUserId,trim(to_nchar(v_UserName)),v_CurrDate, v_DBExpectedProcessDelay, v_ActivityName, v_ProcessVariantId);  
				/*Process Variant Support*/
		END;
	ELSE
		BEGIN
			/*
				v_DBQDTValueList:=temp_v_DBQDTValueList;
			v_DBQDTValueList:=REPLACE(v_DBQDTValueList,v_quoteChar,v_quoteChar||v_quoteChar);
			v_DBQDTValueList:=REPLACE(v_DBQDTValueList,v_quoteChar||v_quoteChar,v_quoteChar);
			*/
			IF(temp_v_DBQDTValueList is NOT NULL) THEN
			SELECT sys.DBMS_ASSERT.noop(temp_v_DBQDTValueList) into v_DBQDTValueList FROM dual;
			END IF;
			IF(temp_v_DBQDTColumnList is NOT NULL) THEN
				SELECT sys.DBMS_ASSERT.noop(temp_v_DBQDTColumnList) into v_DBQDTColumnList FROM dual;
			END IF;
			IF(temp_v_DBExpectedProcessDelay is NOT NULL) THEN
				SELECT sys.DBMS_ASSERT.noop(temp_v_DBExpectedProcessDelay) into v_DBExpectedProcessDelay FROM dual;
			END IF;
			IF(temp_v_ProcessName is NOT NULL) THEN
			SELECT sys.DBMS_ASSERT.noop(temp_v_ProcessName) into v_ProcessName FROM dual;
			END IF;
			v_QueryStr := '	Insert Into WFInstrumentTable (URN,ProcessInstanceId, ProcessDefID, Createdby, CreatedDatetime,ProcessinstanceState,
				CreatedByName,IntroducedByID, IntroducedBy,IntroductionDatetime,ExpectedProcessDelay, IntroducedAt,WorkItemId,ProcessName,
				ProcessVersion,LastProcessedBy,	ProcessedBy,ActivityName,ActivityId,ActivityType,EntryDateTime,AssignmentType,CollectFlag,PriorityLevel,
				ValidTill,Q_StreamId,Q_QueueId,Q_UserId,AssignedUser,FilterValue, WorkItemState,Statename,ExpectedWorkitemDelay,
				PreviousStage,LockedByName,LockStatus,LockedTime,Queuename,Queuetype,NotifyStatus,RoutingStatus,ProcessVariantId,SaveStage, 
				InstrumentStatus, CheckListCompleteFlag' || NVL(v_DBQDTColumnList, ' ') || ', ' || v_UpdateColumnStr ||' ,Locale )
			Values (N'||NVL(v_urn,'''''')||',N' || CHR(39) || v_ProcessInstanceId || CHR(39)||', '|| TO_CHAR(v_DBProcessDefId)||','|| TO_CHAR( v_DBUserId)||',
			SYSDATE,1, N'|| CHR(39) ||trim(to_nchar(v_UserName))|| CHR(39) || ',NULL,NULL,NULL,
			N'|| CHR(39) || NVL(v_DBExpectedProcessDelay,null)|| CHR(39) || ', N'|| CHR(39) ||v_ActivityName|| CHR(39)||',1, 
			N'|| CHR(39) ||v_ProcessName|| CHR(39)||', '|| TO_CHAR(v_ProcessVersion)||', '|| TO_CHAR(v_DBUserId)||',
			N'|| CHR(39) ||trim(to_nchar(v_UserName))|| CHR(39)||', N'|| CHR(39) ||v_ActivityName|| CHR(39)||', 
			'|| TO_CHAR(v_ActivityId)||',1, SYSDATE,N'|| CHR(39) ||'S'|| CHR(39)||',
			N'|| CHR(39) ||'N'|| CHR(39)||','|| TO_CHAR(v_DBPriorityLevel)||',N'|| CHR(39) ||NVL(v_ValidTill,null)|| CHR(39)||',
			'|| TO_CHAR(v_StreamId)||','|| TO_CHAR(v_QueueId)||',NULL,NULL,NULL,1,
			N'|| CHR(39) ||'NOTSTARTED'|| CHR(39)||',NULL,N'|| CHR(39) ||v_ActivityName|| CHR(39)||',NULL,N'|| CHR(39) ||'N'|| CHR(39)||',
			NULL,N'|| CHR(39) || v_QueueName|| CHR(39)||', N'|| CHR(39) ||'I'|| CHR(39)||',N'|| CHR(39) ||'N'|| CHR(39)||',N'|| CHR(39) ||'N'|| CHR(39)||',
			'|| TO_CHAR(v_ProcessVariantId)||', N'|| CHR(39) ||v_ActivityName|| CHR(39)||' , N'|| CHR(39) ||'N'|| CHR(39)||',
			N'|| CHR(39) ||'N' || CHR(39) || NVL(v_DBQDTValueList, ' ') || ',' || v_UpdateValueStr || ',N' || CHR(39)||NVL(v_locale,'en_US')||CHR(39)||' )';
				
			/*Insert into ProcessInstanceTable (ProcessInstanceId , ProcessDefID , Createdby , CreatedDatetime , 
					ProcessinstanceState , CreatedByName,IntroducedByID, IntroducedBy,IntroductionDatetime, 
					ExpectedProcessDelay, IntroducedAt, ProcessVariantId)  
			Values (v_ProcessInstanceId, v_DBProcessDefId, v_DBUserId, v_CurrDate,1, trim(to_nchar(v_UserName)),/*Bug No WFS_6.1_049 Replaced v_UserName by trim(to_nchar(v_UserName))
				NULL,NULL,NULL, v_DBExpectedProcessDelay, v_ActivityName,v_ProcessVariantId); 	/*Process Variant Support*/
		END;
	END IF;
	--DBMS_OUTPUT.PUT_LINE(v_QueryStr);
	Execute IMMEDIATE (v_QueryStr); 

	v_DBStatus := SQL%ROWCOUNT; 
 
 	IF v_DBStatus = 0 THEN 
	BEGIN 
		--ROLLBACK TO SAVEPOINT TranWorkItem; 
		Status := 15; 
		RETURN; 
	END; 
	END IF; 

	/* Changed By Varun Bhansaly On 17/07/2007 for Bugzilla Id 1447 */
	/* ______________________________________________________________________________________
		// Changed On  : 07/07/2009
		// Changed By  : Saurabh Kamal
		// Description : WFS_8.0_010, IF InitiateAlso != Y Insert AssignmentType = 'S'				 
		// ____________________________________________________________________________________*/
	/*IF v_InitiateAlso = N'Y' THEN
		BEGIN
			Insert Into workdonetable  
			(ProcessInstanceId,WorkItemId,ProcessName,ProcessVersion,ProcessDefID,LastProcessedBy, 
			ProcessedBy,ActivityName,ActivityId,EntryDateTime,ParentWorkItemId,AssignmentType, 
			CollectFlag,PriorityLevel,ValidTill,Q_StreamId,Q_QueueId,Q_UserId,AssignedUser, 
			FilterValue, CreatedDateTime,WorkItemState,Statename,ExpectedWorkitemDelay,PreviousStage, 
			LockedByName,LockStatus,LockedTime,Queuename,Queuetype,NotifyStatus, ProcessVariantId) 
			Values(v_ProcessInstanceId, 1, v_ProcessName, v_ProcessVersion, v_DBProcessDefId, v_DBUserId, 
				trim(to_nchar(v_UserName)), v_ActivityName, v_ActivityId, v_CurrDate, 0,'Y','N',v_DBPriorityLevel,v_ValidTill,/*Bug No WFS_6.1_049 Replaced v_UserName by trim(to_nchar(v_UserName))
				v_StreamId,v_QueueId,NULL,NULL,NULL,v_CurrDate,6,'COMPLETED',NULL,v_ActivityName,NULL,'N',v_CurrDate, 
				v_QueueName, 'I',NULL, v_ProcessVariantId) ; /*Process Variant Support
			 v_DBStatus := SQL%ROWCOUNT; 
		END;
	ELSE
		BEGIN
			Insert Into WorkListTable  
			(ProcessInstanceId,WorkItemId,ProcessName,ProcessVersion,ProcessDefID,LastProcessedBy, 
			ProcessedBy,ActivityName,ActivityId,EntryDateTime,ParentWorkItemId,AssignmentType, 
			CollectFlag,PriorityLevel,ValidTill,Q_StreamId,Q_QueueId,Q_UserId,AssignedUser, 
			FilterValue, CreatedDateTime,WorkItemState,Statename,ExpectedWorkitemDelay,PreviousStage, 
			LockedByName,LockStatus,LockedTime,Queuename,Queuetype,NotifyStatus, ProcessVariantId) 
			Values(v_ProcessInstanceId, 1, v_ProcessName, v_ProcessVersion, v_DBProcessDefId, v_DBUserId, 
				trim(to_nchar(v_UserName)), v_ActivityName, v_ActivityId, v_CurrDate, 0,'S','N',v_DBPriorityLevel,v_ValidTill,
				v_StreamId,v_QueueId,NULL,NULL,NULL,v_CurrDate,1,'NOTSTARTED',NULL,v_ActivityName,NULL,'N',NULL, 
				v_QueueName, 'I',NULL, v_ProcessVariantId) ; /*Process Variant Support

			 v_DBStatus := SQL%ROWCOUNT; 
		END;
	END IF;


	IF v_DBStatus = 0 THEN 
	BEGIN 
		--ROLLBACK TO SAVEPOINT TranWorkItem; 
		Status := 15; 
		RETURN; 
	END; 
	END IF; 
 
	v_QueryStr := '	Insert into QueueDataTable (ProcessInstanceID, WorkItemID, SaveStage, InstrumentStatus, CheckListCompleteFlag' || NVL(v_DBQDTColumnList, ' ') || ', ' || v_UpdateColumnStr ||') Values(N' || CHR(39) ||  v_ProcessInstanceId || CHR(39)||', 1, N'|| CHR(39) || v_ActivityName || CHR(39) || ', N'|| CHR(39) || 'N' || CHR(39) || ', N' ||CHR(39) || 'N' || CHR(39) || NVL(v_DBQDTValueList, ' ') || ',' || v_UpdateValueStr || ')'; 
	Execute IMMEDIATE (v_QueryStr); 

	v_DBStatus := SQL%ROWCOUNT; 
 
 	IF v_DBStatus = 0 THEN 
	BEGIN 
		--ROLLBACK TO SAVEPOINT TranWorkItem; 
		Status := 15; 
		RETURN; 
	END; 
	END IF; */
 
	IF (LENGTH(v_InsertExtColumnStr) > 0) AND (LENGTH(v_TableViewName) > 0 )THEN  
	BEGIN
		IF temp_v_DBEXTColumnList IS NULL THEN
		BEGIN
			v_InsertExtColumnStr := SUBSTR(v_InsertExtColumnStr,2); 
			v_InsertExtValueStr  := SUBSTR(v_InsertExtValueStr, 2); 
		END;
		END IF;
		/*
		v_DBEXTValueList:=temp_v_DBEXTValueList;
		v_DBEXTValueList:=REPLACE(v_DBEXTValueList,v_quoteChar,v_quoteChar||v_quoteChar);
		v_DBEXTValueList:=REPLACE(v_DBEXTValueList,v_quoteChar||v_quoteChar,v_quoteChar);
		v_DBEXTColumnList:=temp_v_DBEXTColumnList;
		v_DBEXTColumnList:=REPLACE(v_DBEXTColumnList,v_quoteChar,v_quoteChar||v_quoteChar);
		v_DBEXTColumnList:=REPLACE(v_DBEXTColumnList,v_quoteChar||v_quoteChar,v_quoteChar);
		*/
		IF(temp_v_DBEXTValueList is NOT NULL) THEN
		SELECT sys.DBMS_ASSERT.noop(temp_v_DBEXTValueList) into v_DBEXTValueList FROM dual;
		END IF;
		IF(temp_v_DBEXTColumnList is NOT NULL) THEN
		SELECT sys.DBMS_ASSERT.noop(temp_v_DBEXTColumnList) into v_DBEXTColumnList FROM dual;
		END IF;

		
		BEGIN
			EXECUTE IMMEDIATE (' INSERT INTO ' || v_TableViewName || ' ( ' || NVL(v_DBEXTColumnList, '') || v_InsertExtColumnStr || ' ) VALUES ( ' || NVL(v_DBEXTValueList, '') || v_InsertExtValueStr || ' ) ');
		EXCEPTION
			WHEN OTHERS THEN
				Status := 4012;
				DBMsg :=  SQLERRM;
				DBTblNm := v_TableViewName;
				RETURN;
		END;
	END; 
	END IF; 
        /* ____________________________________________________________________________________
	// Changed On  : 5/08/2005
	// Changed By  : Mandeep Kaur
	// Description : SRNo-4, Optimizations in UploadWorkitem to add messages in place
	                 of insert record in CurrentRouteLogTable and SummaryTable
	// ____________________________________________________________________________________*/
	/* WFS_6.1_020 - Mandeep */
	/* Changed By Varun Bhansaly 0n 08/02/2007 for Bugzilla Bug 74 */
	/* Changed By Tirupati Srivastava 0n 05/04/2007 for Bugzilla Bug 529 */
	/*Changes for Bug 50438 - WI properties showing 2 start Events--ActivityId should not be 0 in Message xml*/
	Insert Into WFMessageTable (messageId, message, status, ActionDateTime)  
	values	(seq_messageId.NEXTVAL, '<Message><ActionId>1</ActionId><UserId>' || TO_CHAR(v_DBUserId) || 
			'</UserId><ProcessDefId>' || TO_CHAR(v_DBProcessDefId) || 
			'</ProcessDefId><ActivityId>' || TO_CHAR(v_ActivityId) || 
				'</ActivityId><QueueId>0</QueueId><UserName>' || 
			trim(to_nchar(NVL(v_UserName,''))) || '</UserName><ActivityName>' || NVL(v_ActivityName,'') || 
			'</ActivityName><TotalWiCount>1</TotalWiCount><TotalDuration>0</TotalDuration><ActionDateTime>' 
			|| TO_NCHAR(sysDate, 'YYYY-MM-DD HH24:MI:SS') || 
			'</ActionDateTime><EngineName></EngineName><ProcessInstance>' || v_ProcessInstanceId || 
			'</ProcessInstance><FieldId>' || TO_CHAR(v_QueueId) || '</FieldId><WorkitemId>1</WorkitemId><TotalPrTime>0</TotalPrTime><DelayTime>0</DelayTime><WKInDelay>0</WKInDelay><ReportType>D</ReportType><LoggingFlag>3</LoggingFlag></Message>', 
		N'N', SYSDATE 
	); 
	/*Changes for Bug 50438 - WI properties showing 2 start Events--ActivityId should not be 0 here*/
	WFGenerateLog(1, v_DBUserId, v_DBProcessDefId, v_ActivityId, v_QueueId, trim(to_nchar(NVL(v_UserName,''))), v_ActivityName, 0, v_ProcessInstanceId, v_QueueId, null, 1, 0, 0,v_MainCode, null,v_ProcessVariantId,0,0,v_urnDup,NULL,NULL,v_tarHisLog,v_targetCabinet);

	v_DBStatus := 0; 
	IF(v_DBSetAttributeLoggingEnabled = N'Y' AND v_DBRouteLogList IS NOT NULL AND LENGTH(v_DBRouteLogList) > 0 ) THEN
		BEGIN
			
			if(v_tarHisLog ='Y') THEN
			BEGIN
			--Insert into sp3new1.WFATTRIBUTEMESSAGEHISTORYTABLE (ProcessDefId,ProcessInstanceId ,WorkitemId,messageId, message, status, ActionDateTime) Values 
				--( v_DBProcessDefId,v_ProcessInstanceId,1,v_fieldId,v_DBRouteLogList,N'N',SYSDATE);
				v_var1 := 'Select ' || v_targetCabinet ||'.seq_attribmessageId.NEXTVAL FROM DUAL';
				EXECUTE IMMEDIATE v_var1  INTO v_fieldId;
				v_QueryStr11 := 'Insert into ' ||v_targetCabinet || '.WFATTRIBUTEMESSAGEHISTORYTABLE (ProcessDefId,ProcessInstanceId ,WorkitemId,messageId, message, status, ActionDateTime) Values 
				( ' ||v_DBProcessDefId||','||CHR(39)|| v_ProcessInstanceId||CHR(39)||',1,'||TO_CHAR(NVL(v_FieldId, 0))||','||CHR(39)||v_DBRouteLogList||CHR(39)||','||CHR(39)||'N'||CHR(39)||',SYSDATE)';
				Execute IMMEDIATE (v_QueryStr11);
			end;
			ELSE
			BEGIN
			Select seq_attribmessageId.NEXTVAL INTO v_fieldId FROM DUAL;
			Insert into WFAttributeMessageTable (ProcessDefId,ProcessInstanceId ,WorkitemId,messageId, message, status, ActionDateTime) Values 
				( v_DBProcessDefId,v_ProcessInstanceId,1,v_fieldId,v_DBRouteLogList,N'N',SYSDATE);
				end;
				end if;
				
			WFGenerateLog(75, v_DBUserId, v_DBProcessDefId, v_ActivityId, 0, trim(to_nchar(NVL(v_UserName,''))), v_ActivityName, 0, v_ProcessInstanceId, v_fieldId, null, 1, 0, 0, v_MainCode,null,0,0,0,v_urnDup,NULL,NULL,v_tarHisLog,v_targetCabinet);
		END;
	END IF;
	/*v_MessageBuffer := '<Message><ActionId>16</ActionId><UserId>' || TO_CHAR(v_DBUserId) ||  
			'</UserId><ProcessDefId>' || TO_CHAR(v_DBProcessDefId) || 
			'</ProcessDefId><ActivityId>' || TO_CHAR(v_ActivityId) || 
			'</ActivityId><QueueId>0</QueueId><UserName>' || trim(to_nchar(NVL(v_UserName,''))) || 
			'</UserName><ActivityName>' || NVL(v_ActivityName,'') || 
			'</ActivityName><TotalWiCount>0</TotalWiCount><TotalDuration>0</TotalDuration><ActionDateTime>'  
			|| TO_CHAR(sysDate, 'YYYY-MM-DD HH24:MI:SS') || 
			'</ActionDateTime><EngineName></EngineName><ProcessInstance>' || v_ProcessInstanceId || 
			'</ProcessInstance><FieldId>0</FieldId><FieldName><Attributes>' || NVL(v_DBRouteLogList, '') || 
			'</Attributes></FieldName><WorkitemId>1</WorkitemId><TotalPrTime>0</TotalPrTime><DelayTime>0</DelayTime><WKInDelay>0</WKInDelay><ReportType>D</ReportType><LoggingFlag>1</LoggingFlag></Message>';
	Insert Into WFMessageTable (messageId, message, status, ActionDateTime) values	(seq_messageId.NEXTVAL, v_MessageBuffer, N'N', SYSDATE);*/
	

      /* ____________________________________________________________________________________
	// Changed On  : 5/08/2005
	// Changed By  : Mandeep Kaur
	// Description : SRNo-4, Optimizations in UploadWorkitem to add messages in place
	                 of insert record in CurrentRouteLogTable and SummaryTable
	// ____________________________________________________________________________________*/ 
	/* Bug No WFS_6.1.2_066, trim added to userName - Ruhi Hira */
	/* Changed By Varun Bhansaly 0n 08/02/2007 for Bugzilla Bug 74 */
	/* Changed By Tirupati Srivastava 0n 05/04/2007 for Bugzilla Bug 529 */
	/* Changed By Varun Bhansaly On 17/07/2007 for Bugzilla Id 1447 */
	IF (v_InitiateAlso = N'Y'AND v_syncRoute = N'N') THEN
		BEGIN
			SELECT (SYSDATE - createdDateTime), (SYSDATE -lockedTime)  
					INTO  v_DBTotalDuration,v_DBTotalPrTime  
			FROM WFInstrumentTable   
			WHERE ProcessInstanceId = v_ProcessInstanceId 
			AND RoutingStatus = 'Y' 
			AND LockStatus = 'N'; 
			/*SELECT (SYSDATE - A.createdDateTime), (SYSDATE -A.lockedTime)  
					INTO  v_DBTotalDuration,v_DBTotalPrTime  
			FROM WorkDoneTable A  
			WHERE A.ProcessInstanceId = v_ProcessInstanceId; */
		EXCEPTION  
			WHEN NO_DATA_FOUND THEN  
			BEGIN
				v_DBTotalDuration := 0; 
				v_DBTotalPrTime := 0; 
			END; 
		END;
		
		BEGIN
			v_DBTotalDuration := v_DBTotalDuration * 24 * 60 * 60; 
			v_DBTotalPrTime   := v_DBTotalPrTime * 24 * 60 * 60; 

			/* Bug No WFS_6.1.2_066, trim added to userName - Ruhi Hira */
			/* Changed By Varun Bhansaly 0n 08/02/2007 for Bugzilla Bug 74 */
			/* Changed By Tirupati Srivastava 0n 05/04/2007 for Bugzilla Bug 529 */
			Insert Into WFMessageTable (messageId, message, status, ActionDateTime)  
			values(seq_messageId.NEXTVAL, '<Message><ActionId>2</ActionId><UserId>' || TO_CHAR(v_DBUserId) || 
				'</UserId><ProcessDefId>' || TO_CHAR(v_DBProcessDefId) || 
				'</ProcessDefId><ActivityId>' || TO_CHAR(v_ActivityId) || 
				'</ActivityId><QueueId>'|| TO_CHAR(v_QueueId) || 
				'</QueueId><UserName>' || trim(to_nchar(NVL(v_UserName,''))) || 
				'</UserName><ActivityName>' || NVL(v_ActivityName,'') || 
				'</ActivityName><TotalWiCount>1</TotalWiCount><TotalDuration>' || 
				TO_CHAR(v_DBTotalDuration) ||'</TotalDuration><ActionDateTime>' || 
				TO_NCHAR(sysDate, 'YYYY-MM-DD HH24:MI:SS') || '</ActionDateTime><EngineName></EngineName><ProcessInstance>' || v_ProcessInstanceId || 
				'</ProcessInstance><FieldId>' || TO_CHAR(v_QueueId) || 
				'</FieldId><WorkitemId>1</WorkitemId><TotalPrTime>' || 
				TO_CHAR(v_DBTotalPrTime) || 
				'</TotalPrTime><DelayTime>0</DelayTime><WKInDelay>0</WKInDelay><ReportType>D</ReportType><LoggingFlag>3</LoggingFlag></Message>', 
				N'N', SYSDATE);  
				
				WFGenerateLog(2, v_DBUserId, v_DBProcessDefId, v_ActivityId, v_QueueId, trim(to_nchar(NVL(v_UserName,''))), v_ActivityName, 0, v_ProcessInstanceId, v_QueueId, null, 1, 0, 0, v_MainCode, null,v_ProcessVariantId,0,0,null,null,null,v_tarHisLog,v_targetCabinet);

		END;
	END IF;

	IF v_ValidationReqd1 IS NOT NULL AND v_ValidateQuery IS NOT NULL THEN 
	BEGIN 
		/* 
		v_ValidateQuery:=REPLACE(v_ValidateQuery,v_quoteChar,v_quoteChar||v_quoteChar);
		v_ValidateQuery:=REPLACE(v_ValidateQuery,v_quoteChar||v_quoteChar,v_quoteChar);
		*/
		
		IF(temp_v_ValidateQuery is NOT NULL) THEN
		SELECT sys.DBMS_ASSERT.noop(temp_v_ValidateQuery) into v_ValidateQuery FROM dual;
		END IF;
		
		EXECUTE IMMEDIATE (v_ValidateQuery); 
		v_DBStatus := SQLCODE; 

		IF v_DBStatus <> 0 THEN  
		BEGIN  
			--ROLLBACK TO SAVEPOINT TranWorkItem; 
			Status := 15; 
			RETURN; 
		END; 
		END IF; 
	END; 
	END IF; 

	--COMMIT; 
	Status 		:= v_DBStatus; 
	DBFolderName 	:= v_DBFolderName;  
	CurrDate	:= v_CurrDate; 
	/* Bugzilla Bug 265 - FolderIndex returned */
	FolderIndex	:= v_NewFolderIndex;
	DocumentIndexes := v_DocumentIndexes;
END;