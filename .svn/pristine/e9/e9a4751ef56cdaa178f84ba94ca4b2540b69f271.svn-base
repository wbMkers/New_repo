/*----------------------------------------------------------------------------------------------------
		NEWGEN SOFTWARE TECHNOLOGIES LIMITED
------------------------------------------------------------------------------------------------------
	Group				: Application �Products
	Product / Project		: WorkFlow 5.0.1
	Module				: Transaction Server
	File Name			: WFGetWorkitemData.sql
	Author				: 
	Date written (DD/MM/YYYY)	: 
	Description			: Returns the workitem' data [Bug # WFS_5_066].
------------------------------------------------------------------------------------------------------
			CHANGE HISTORY
------------------------------------------------------------------------------------------------------
 Date		Change By		Change Description (Bug No. (If Any))
			Sumit Aggrawal		Bug WFS_5_081 - SP Written
16/12/2005	Ruhi Hira			Bug # WFS_5_089.
16/02/2006	Sumit Aggarwal		WFS_5_104	Comment Field is required from pdbdocument table in wfgetworkitemdataext call
13/04/2006	Harmeet Kaur		WFS_5_117 - Document Size to be fetched in GetDocumentList
30/01/2007	Umesh Sehgal		WFS_5_157 Opening workitem on custom workstep gives error:"numeric value error"
13/09/2007	Varun Bhansaly		SrNo-1, All data related to Comments
08/02/2008	Vikram Kumbhar		WFS_5_229 WFGetWorkitemDataExt call do not return proper values of queue variables associated with VAR_INT5, VAR_INT6, VAR_INT7
17/03/2008	Shweta Tyagi		Bugzilla bug 3919 return new tag ownerindex in WFGetWorkitemDataExt
14/06/2008	Ishu Saraf		Bugzilla bug 5091 returning more than one rows because of complex type structure
28/07/2008	Ishu Saraf		Bugzilla Bug 5426, 5493
26/08/2008  Varun Bhansaly		SrNo-2, Complex type support. Donot query QueueDataTable/ QueueHistoryTable/ External Table
19/04/2010	Saurabh Kamal		Bugzilla Bug 12114, Exception Sequence should be in order of ActionDateTime instead of ActionId
16/09/2010	Preeti Awasthi		WFS_8.0_131: In document list Owner and Modified Date time should be displayed
18/12/2013	Kahkeshan           Code Optimization changes 
05/05/2015	Mohnish Chopra		Changes for Case Management - New parameters DBTaskId and DBSubTaskId added and 
								returning task specific data in RefCursor8				
11/08/2015	Mohnish Chopra		Changes for Data Locking issue in Case Management -Returning ActivityType and LastModifiedTime
18/08/2015	Mohnish Chopra		Changes for Case View in Case Management -Returning InitiatedBy and InitiatedOn 
05-05-2017	Sajid Khan			Merging Bug 58399 - Need an option to view refer, reassign and ad-hoc routing comments in workitem properties
18/09/2017  Kumar Kimil         Tasktype and TaskMode added in Output of WFGetWorkitemDataExt
22/04/2018	Kumar Kimil		    Bug 77269 - CheckMarx changes (High Severity)
11-03-2019	Ravi Ranjan			Bug 83511 - PRDP bug merging (Support of multiple image cabinets for archived workitems(Queuehistorytable))
04-02-2020  Ravi Raj Mewara     Bug 90386 - Time stamp for Initiated on and Task Due Date is missing in info tab.
----------------------------------------------------------------------------------------------------*/

CREATE OR REPLACE PROCEDURE WFGetWorkitemData(
	temp_DBProcessInstanceId		NVARCHAR2,
	DBWorkItemId			INT,
	DBProcessDefId			INT,
	DBActivityId			INT,
	DBUserIndex			INT,
	temp_DBDocumentOrderBy		NVARCHAR2 ,
	temp_DBDocumentSortOrder		CHAR ,
	temp_DBObjectPreferenceList		NVARCHAR2 ,
	DBISSharePoint			NVARCHAR2,
	RefCursor1			OUT ORACONSTPKG.DBLIST ,
	RefCursor2			OUT ORACONSTPKG.DBLIST ,
	RefCursor3			OUT ORACONSTPKG.DBLIST ,
	RefCursor4			OUT ORACONSTPKG.DBLIST ,
	RefCursor5			OUT ORACONSTPKG.DBLIST ,
	RefCursor6			OUT ORACONSTPKG.DBLIST ,
	RefCursor7			OUT ORACONSTPKG.DBLIST ,
	RefCursor8			OUT ORACONSTPKG.DBLIST ,

	DBTaskId				INT,
	DBSubTaskId				INT
)
AS
	
	v_extTableName			NVARCHAR2(256);	/* Bugzilla Bug 5426, 5493 */
	v_ReferByName			NVARCHAR2(30);
	v_ReferTo			INT;
	v_CheckListCompleteFlag		NVARCHAR2(1);
	v_HoldStatus			INT;
	v_InstrumentStatus		NVARCHAR2(1);
	v_ParentWorkItemID		INT;
	v_ProcessInstanceId		NVARCHAR2(63);
	v_SaveStage			NVARCHAR2(63);
	v_Status			NVARCHAR2(255);
	v_VAR_REC_1			NVARCHAR2(255);
	v_VAR_REC_2			NVARCHAR2(255);

	v_queryStr			VARCHAR2(8000);

	/* Declaration of process variables */

	v_CreatedByName			NVARCHAR2(63);
	v_CreatedDatetime		DATE;
	v_Introducedby			NVARCHAR2(63);
	v_IntroductionDateTime		DATE;
	v_ProcessInstanceState 		NUMBER;
	v_ImageCabName			NVARCHAR2(100);
	v_ExpectedProcessDelay		DATE;
	v_objectName			NVARCHAR2(255);/*WFS_5_157*/
	v_tempUserIndex			NVARCHAR2(10);
	v_rowCount			INT;
	in_DBDocumentOrderBy 		NVARCHAR2(30);
	v_quoteChar 			CHAR(1);
	v_AssignedTo			NVARCHAR2(255);
	v_dueDate				NVARCHAR2(50);
	v_ActivityType 			INT;
	v_LastModifiedTime		DATE;
	v_AssignedBy			NVARCHAR2(63);
	v_ActionDateTime		NVARCHAR2(50);
	v_ShowCaseVisual		NVARCHAR2(1);
	v_CanInitiate			NVARCHAR2(1);
	v_TaskType              Number;
	v_TaskMode              VARCHAR2(1);
	DBProcessInstanceId     NVARCHAR2(128);
	DBDocumentOrderBy 		NVARCHAR2(30);
	DBObjectPreferenceList  NVARCHAR2(255);
	DBDocumentSortOrder     Char(5);
BEGIN
	v_quoteChar := CHR(39);
	IF(temp_DBProcessInstanceId is NOT NULL) THEN
		SELECT sys.DBMS_ASSERT.noop(temp_DBProcessInstanceId) into DBProcessInstanceId FROM dual;
	END IF;
	/*DBProcessInstanceId:=temp_DBProcessInstanceId;
	DBDocumentOrderBy:=temp_DBDocumentOrderBy;
	DBObjectPreferenceList:=temp_DBObjectPreferenceList;
	DBDocumentSortOrder:=temp_DBDocumentSortOrder;
	
	DBProcessInstanceId:=REPLACE(DBProcessInstanceId,v_quoteChar,v_quoteChar||v_quoteChar);
	DBDocumentOrderBy := REPLACE(DBDocumentOrderBy,v_quoteChar,v_quoteChar||v_quoteChar);
	in_DBDocumentOrderBy :=DBDocumentOrderBy;
	DBObjectPreferenceList:= REPLACE(DBObjectPreferenceList,v_quoteChar,v_quoteChar||v_quoteChar);
	DBObjectPreferenceList:= REPLACE(DBObjectPreferenceList,v_quoteChar||v_quoteChar,v_quoteChar);
	DBDocumentSortOrder:=REPLACE(DBDocumentSortOrder,v_quoteChar,v_quoteChar||v_quoteChar);
	*/
	
	IF(temp_DBProcessInstanceId is NOT NULL) THEN
		SELECT sys.DBMS_ASSERT.noop(temp_DBProcessInstanceId) into DBProcessInstanceId FROM dual;
	END IF;
	IF(temp_DBDocumentOrderBy is NOT NULL) THEN
		SELECT sys.DBMS_ASSERT.noop(temp_DBDocumentOrderBy) into DBDocumentOrderBy FROM dual;
	END IF;
	in_DBDocumentOrderBy :=DBDocumentOrderBy;
	IF(temp_DBObjectPreferenceList is NOT NULL) THEN
		SELECT sys.DBMS_ASSERT.noop(temp_DBObjectPreferenceList) into DBObjectPreferenceList FROM dual;
	END IF;
	IF(temp_DBDocumentSortOrder is NOT NULL) THEN
		SELECT sys.DBMS_ASSERT.noop(temp_DBDocumentSortOrder) into DBDocumentSortOrder FROM dual;
	END IF;
	
	
	IF NOT ((UPPER(DBDocumentOrderBy) = UPPER('Name')) OR (UPPER(DBDocumentOrderBy) = UPPER('RevisedDateTime')) OR (UPPER(DBDocumentOrderBy) = UPPER('DocumentSize')) OR (UPPER(DBDocumentOrderBy) = UPPER('CreatedByApplication')) OR (UPPER(DBDocumentOrderBy) = UPPER('NoOfPages')) OR (UPPER(DBDocumentOrderBy) = UPPER('Owner')) OR (UPPER(DBDocumentOrderBy) = UPPER('DocumentOrderNo'))) THEN
		BEGIN
		in_DBDocumentOrderBy := 'Name';
		END;
	END IF;
	IF (DBTaskId>0) then
	BEGIN  
		v_objectName := TO_CHAR(DBProcessDefId) || '@' || TO_CHAR(DBActivityId)||'#'||TO_CHAR(DBTaskId);
	END;
	Else
	BEGIN
	v_objectName := TO_CHAR(DBProcessDefId) || '@' || TO_CHAR(DBActivityId);
	END;
	END IF;
	v_tempUserIndex := TO_CHAR(DBUserIndex);

	v_rowCount := -1;

	v_queryStr := ' Select ObjectId, ObjectName, ObjectType, NotifyByEmail, Data ' ||
			' From	UserPreferencesTable  ' ||
			' Where	userId	= ' || v_tempUserIndex ||
			' AND	UPPER(ObjectName) =  ''' || UPPER(v_objectName) ||
			''' AND	UPPER(ObjectType) in ( ' || UPPER(DBObjectPreferenceList) || ' )';

	Open RefCursor1 For v_queryStr; 

	BEGIN
		Select  ReferredByName, ReferredTo, CheckListCompleteFlag, HoldStatus, InstrumentStatus,
			ParentWorkItemID, ProcessInstanceId, SaveStage, Status, VAR_REC_1, VAR_REC_2,CreatedByName,
			ExpectedProcessDelay, Introducedby,IntroductionDatetime, ProcessInstanceState,ActivityType,LastModifiedTime  
		INTO	v_ReferByName, v_ReferTo, v_CheckListCompleteFlag, v_HoldStatus, v_InstrumentStatus, 
			v_ParentWorkItemID, v_ProcessInstanceId, v_SaveStage, v_Status, v_VAR_REC_1, v_VAR_REC_2,
			v_CreatedByName, v_ExpectedProcessDelay, v_Introducedby, v_IntroductionDatetime,
			v_ProcessInstanceState,v_ActivityType,v_LastModifiedTime  
		From	WFInstrumentTable 
		Where	ProcessInstanceId	=  TRIM(DBProcessInstanceId)
		And	WorkitemId		=  DBWorkitemId;
		
		v_CreatedByName:=REPLACE(v_CreatedByName,v_quoteChar,v_quoteChar||v_quoteChar);--checkMarx changes
		v_ProcessInstanceState:=REPLACE(v_ProcessInstanceState,v_quoteChar,v_quoteChar||v_quoteChar);--checkMarx changes
		--v_IntroductionDatetime:=REPLACE(v_IntroductionDatetime,v_quoteChar,v_quoteChar||v_quoteChar);--checkMarx changes
		v_Introducedby:=REPLACE(v_Introducedby,v_quoteChar,v_quoteChar||v_quoteChar);--checkMarx changes
		v_ExpectedProcessDelay:=REPLACE(v_ExpectedProcessDelay,v_quoteChar,v_quoteChar||v_quoteChar);--checkMarx changes
		v_ReferByName:=REPLACE(v_ReferByName,v_quoteChar,v_quoteChar||v_quoteChar);--checkMarx changes
		v_VAR_REC_2:=REPLACE(v_VAR_REC_2,v_quoteChar,v_quoteChar||v_quoteChar);--checkMarx changes
		v_VAR_REC_1:=REPLACE(v_VAR_REC_1,v_quoteChar,v_quoteChar||v_quoteChar);--checkMarx changes
		v_LastModifiedTime:=REPLACE(v_LastModifiedTime,v_quoteChar,v_quoteChar||v_quoteChar);--checkMarx changes
		v_Status:=REPLACE(v_Status,v_quoteChar,v_quoteChar||v_quoteChar);--checkMarx changes
		v_SaveStage:=REPLACE(v_SaveStage,v_quoteChar,v_quoteChar||v_quoteChar);--checkMarx changes
		v_ProcessInstanceId:=REPLACE(v_ProcessInstanceId,v_quoteChar,v_quoteChar||v_quoteChar);--checkMarx changes
		v_InstrumentStatus:=REPLACE(v_InstrumentStatus,v_quoteChar,v_quoteChar||v_quoteChar);--checkMarx changes
		v_CheckListCompleteFlag:=REPLACE(v_CheckListCompleteFlag,v_quoteChar,v_quoteChar||v_quoteChar);--checkMarx changes
		
		v_rowcount := SQL%ROWCOUNT;
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
				v_rowcount := 0;	

		
	END; 

	IF( v_rowcount <= 0 ) THEN
	BEGIN
	    BEGIN
		Select  ReferredByName, ReferredTo, CheckListCompleteFlag, HoldStatus, InstrumentStatus, 
			ParentWorkItemID, ProcessInstanceId, SaveStage, Status, VAR_REC_1, 
			VAR_REC_2, CreatedByName, Createddatetime, NULL, Introducedby, 
			IntroductionDatetime, ProcessInstanceState,ActivityType,LastModifiedTime ,ImageCabName
		INTO	v_ReferByName, v_ReferTo, v_CheckListCompleteFlag, v_HoldStatus, v_InstrumentStatus,
			v_ParentWorkItemID, v_ProcessInstanceId, v_SaveStage, v_Status, v_VAR_REC_1, 
			v_VAR_REC_2, v_CreatedByName, v_Createddatetime, v_ExpectedProcessDelay, v_Introducedby, 
			v_IntroductionDatetime, v_ProcessInstanceState,v_ActivityType,v_LastModifiedTime ,v_ImageCabName
		From	QueueHistoryTable 
		Where	ProcessInstanceId	= TRIM(DBProcessInstanceId)
		And	WorkitemId		=  DBWorkitemId;
		
		v_ImageCabName:=REPLACE(v_ImageCabName,v_quoteChar,v_quoteChar||v_quoteChar);
		v_CreatedByName:=REPLACE(v_CreatedByName,v_quoteChar,v_quoteChar||v_quoteChar);--checkMarx changes
		v_ProcessInstanceState:=REPLACE(v_ProcessInstanceState,v_quoteChar,v_quoteChar||v_quoteChar);--checkMarx changes
		--v_IntroductionDatetime:=REPLACE(v_IntroductionDatetime,v_quoteChar,v_quoteChar||v_quoteChar);--checkMarx changes
		v_Introducedby:=REPLACE(v_Introducedby,v_quoteChar,v_quoteChar||v_quoteChar);--checkMarx changes
		v_ExpectedProcessDelay:=REPLACE(v_ExpectedProcessDelay,v_quoteChar,v_quoteChar||v_quoteChar);--checkMarx changes
		v_ReferByName:=REPLACE(v_ReferByName,v_quoteChar,v_quoteChar||v_quoteChar);--checkMarx changes
		v_VAR_REC_2:=REPLACE(v_VAR_REC_2,v_quoteChar,v_quoteChar||v_quoteChar);--checkMarx changes
		v_VAR_REC_1:=REPLACE(v_VAR_REC_1,v_quoteChar,v_quoteChar||v_quoteChar);--checkMarx changes
		v_LastModifiedTime:=REPLACE(v_LastModifiedTime,v_quoteChar,v_quoteChar||v_quoteChar);--checkMarx changes
		v_Status:=REPLACE(v_Status,v_quoteChar,v_quoteChar||v_quoteChar);--checkMarx changes
		v_SaveStage:=REPLACE(v_SaveStage,v_quoteChar,v_quoteChar||v_quoteChar);--checkMarx changes
		v_ProcessInstanceId:=REPLACE(v_ProcessInstanceId,v_quoteChar,v_quoteChar||v_quoteChar);--checkMarx changes
		v_InstrumentStatus:=REPLACE(v_InstrumentStatus,v_quoteChar,v_quoteChar||v_quoteChar);--checkMarx changes
		v_CheckListCompleteFlag:=REPLACE(v_CheckListCompleteFlag,v_quoteChar,v_quoteChar||v_quoteChar);--checkMarx changes
		
		v_rowcount := SQL%ROWCOUNT;
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
				v_rowcount := 0;			
	    END;

		/*OPEN RefCursor2 FOR 
			Select  v_CreatedByName		  CreatedByName, 
				v_ExpectedProcessDelay	  ExpectedProcessDelay, 
				v_Introducedby		  Introducedby, 
				v_IntroductionDatetime	  IntroductionDatetime, 
				v_ProcessInstanceState	  ProcessInstanceState
			from dual; */
--		RETURN;
	END;	
	/*Else 
	BEGIN
		v_queryStr := 'Select	CreatedByName, ExpectedProcessDelay, Introducedby, ' || 
				' IntroductionDatetime, ProcessInstanceState ' ||
				' From	ProcessInstanceTable ' ||
				' Where	ProcessInstanceId = ' || v_quoteChar || 
				DBProcessInstanceId  || v_quoteChar;

		Open RefCursor2 for v_queryStr;
--		EXECUTE IMMEDIATE (v_queryStr);
	END;*/
	END IF;
	
	/* Process variables fetched from WFInstrumentTable / QueueHistory Table */
	OPEN RefCursor2 FOR 
			Select  v_CreatedByName		  CreatedByName, 
				v_ExpectedProcessDelay	  ExpectedProcessDelay, 
				v_Introducedby		  Introducedby, 
				to_char(v_IntroductionDatetime,'YYYY-MM-DD HH24:MI:SS')	  IntroductionDatetime,   
				v_ProcessInstanceState	  ProcessInstanceState,
				v_ImageCabName	ImageCabName
			from dual;

	OPEN RefCursor3 FOR 
		Select	v_ReferByName		  ReferredByName,
			v_ReferTo		  ReferredTo,
			v_CheckListCompleteFlag	  CheckListCompleteFlag, 
			v_HoldStatus		  HoldStatus, 
			v_InstrumentStatus	  InstrumentStatus, 
			v_ParentWorkItemID	  ParentWorkItemID,
			v_ProcessInstanceId	  ProcessInstanceId, 
			v_SaveStage		  SaveStage, 
			v_Status		  Status, 
			v_ActivityType	  ActivityType,
			v_LastModifiedTime	LastModifiedTime,
			v_VAR_REC_1		  VAR_REC_1, 
			v_VAR_REC_2		  VAR_REC_2
		From Dual;
--	RETURN;
	
	IF(DBISSharePoint = N'N') THEN
	BEGIN
		v_queryStr := 'Select PDBDocument.DocumentIndex DocumentIndex, VersionNumber, Name, Owner, ' ||  /*bug 3919*/
				' CreatedDateTime, Commnt, AppName CreatedByApplication, ImageIndex, ' ||
				' VolumeId, DocumentType, CheckoutStatus, ' ||
				' CheckoutByUser, NoOfPages, DocumentSize, RevisedDateTime, Author ' || /* WFS_5_117 */
				' From PDBDocument  Inner Join PDBDocumentContent ' ||
				' ON PDBDocument.documentIndex	= PDBDocumentContent.documentIndex ' ||
				' AND parentFolderIndex	= ' || v_VAR_REC_1 ||			 
				' AND ''' || v_VAR_REC_2 || ''' = ''F''' ||
				' ORDER BY ' || in_DBDocumentOrderBy ||
				' ' || DBDocumentSortOrder ;		/* Sr No. 1 */

		Open RefCursor4 For v_queryStr; 
	END;	
	END IF;
	
	v_queryStr := 'Select	ToDoValue FROM	ToDoStatusView  ' ||
			' WHERE	ProcessInstanceId = ' || v_quoteChar || 
			DBProcessInstanceId || v_quoteChar;

	Open RefCursor5 For v_queryStr;

	v_queryStr := 'SELECT	ExceptionId, excpseqid, ActionId, ' ||
			' activitytable.ActivityName ActivityName, UserName, ActionDateTime, ' ||
			' ExceptionName, ExceptionComments, FinalizationStatus ' || 
			' FROM	exceptionview  , activitytable  ' ||
			' WHERE	exceptionview.processdefid	= ' || DBProcessDefId || 
			' AND	activitytable.activityId	=   exceptionview.activityId ' ||
			' AND	activitytable.ProcessDefId	=   exceptionview.ProcessDefId ' ||
			' AND	ProcessInstanceId	= ' || v_quoteChar || DBProcessInstanceId  ||
			 v_quoteChar ||
			' ORDER BY ExceptionId, excpseqid, ActionDateTime ASC';

	Open RefCursor6 For v_queryStr; 
	
	v_queryStr := 'Select WFCOMMENTSVIEW.Comments, WFCOMMENTSVIEW.CommentsBy, WFCOMMENTSVIEW.CommentsByName, WFCOMMENTSVIEW.CommentsTo, WFCOMMENTSVIEW.CommentsToName, WFCOMMENTSVIEW.CommentsType, WFCOMMENTSVIEW.ActionDateTime, ActivityTable.ActivityName From WFCOMMENTSVIEW, ActivityTable Where WFCOMMENTSVIEW.ProcessDefId = ActivityTable.ProcessDefId and WFCOMMENTSVIEW.ActivityId = ActivityTable.ActivityId and ProcessInstanceId =  N''' ||  DBProcessInstanceId || ''' Order By CommentsId DESC';
	/*v_queryStr := 'Select WFCOMMENTSVIEW.Comments, WFCOMMENTSVIEW.CommentsBy, WFCOMMENTSVIEW.CommentsByName, WFCOMMENTSVIEW.CommentsTo, WFCOMMENTSVIEW.CommentsToName, WFCOMMENTSVIEW.CommentsType, WFCOMMENTSVIEW.ActionDateTime, ActivityTable.ActivityName From WFCOMMENTSVIEW, ActivityTable Where WFCOMMENTSVIEW.ProcessDefId = ActivityTable.ProcessDefId and WFCOMMENTSVIEW.ActivityId = ActivityTable.ActivityId and ProcessInstanceId = :DBProcessInstanceId Order By CommentsId DESC';*/
	--Open RefCursor7 For v_queryStr USING DBProcessInstanceId; 	

	Open RefCursor7 For v_queryStr; 	
	
	IF(DBTaskId >0) THEN
	BEGIN
		Select AssignedBy,TO_CHAR( ActionDateTime , 'YYYY-MM-DD HH24:MI:SS'),AssignedTo,TO_CHAR( DUEDATE , 'YYYY-MM-DD HH24:MI:SS'),TaskType,TaskMode  into v_assignedBy,v_ActionDateTime,v_AssignedTo,v_DueDate,v_TaskType,v_TaskMode
		from WFTaskStatusTable S INNER JOIN WFTaskDefTable T
		on processinstanceid=TRIM(DBProcessInstanceId)
		And	WorkitemId		=  DBWorkitemId 
		And ActivityId= DBActivityId
		And S.TaskId	=DBTaskId 
		And SubTaskId = DBSubTaskId
		and T.taskid=S.Taskid
		and T.ProcessDefId=S.ProcessDefId;
		v_AssignedBy:=REPLACE(v_AssignedBy,v_quoteChar,v_quoteChar||v_quoteChar);--checkMarx changes
		v_ActionDateTime:=REPLACE(v_ActionDateTime,v_quoteChar,v_quoteChar||v_quoteChar);--checkMarx changes
		v_AssignedTo:=REPLACE(v_AssignedTo,v_quoteChar,v_quoteChar||v_quoteChar);--checkMarx changes
		v_DueDate:=REPLACE(v_DueDate,v_quoteChar,v_quoteChar||v_quoteChar);--checkMarx changes
		v_TaskType:=REPLACE(v_TaskType,v_quoteChar,v_quoteChar||v_quoteChar);--checkMarx changes
		v_TaskMode:=REPLACE(v_TaskMode,v_quoteChar,v_quoteChar||v_quoteChar);--checkMarx changes
		Open RefCursor8 for 
		Select	v_AssignedBy		AssignedBy,
				v_ActionDateTime	ActionDateTime,
				v_AssignedTo		  AssignedTo,
				v_DueDate	  		  DueDate,
				v_TaskType            TaskType,
				v_TaskMode            TaskMode
		From Dual;
	END;	
	END IF;
		
		

EXCEPTION
	WHEN OTHERS THEN
		/* Bug # WFS_5_089, Max Open Cursor exceeded - Ruhi Hira */
		CLOSE RefCursor1;
		CLOSE RefCursor2;
		CLOSE RefCursor3;
		CLOSE RefCursor4;
		CLOSE RefCursor5;
		CLOSE RefCursor6;
		CLOSE RefCursor7;
		RAISE;
End;