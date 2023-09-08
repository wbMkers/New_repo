/*----------------------------------------------------------------------------------------------------
		NEWGEN SOFTWARE TECHNOLOGIES LIMITED
------------------------------------------------------------------------------------------------------
	Group						: Genesis
	Product / Project			: iBPS
	Module						: Omniflow Server
	File Name					: WFGetWorkitemData.sql
	Author						: Sajid Khan
	Date written (DD/MM/YYYY)	:  03-12-2014
	Description					: Returns the workitem' data [Bug # WFS_5_066] 
------------------------------------------------------------------------------------------------------
			CHANGE HISTORY
------------------------------------------------------------------------------------------------------
 Date		Change By		Change Description (Bug No. (If Any))
05-05-2017	Sajid Khan		Bug 58399 - Need an option to view refer, reassign and ad-hoc routing comments in workitem properties
18/09/2017    Kumar Kimil   Tasktype and TaskMode added in Output of WFGetWorkitemDataExt
11-03-2019	Ravi Ranjan			Bug 83511 - PRDP bug merging (Support of multiple image cabinets for archived workitems(Queuehistorytable))
 ----------------------------------------------------------------------------------------------------*/

CREATE OR REPLACE FUNCTION WFGetWorkitemData(
	DBProcessInstanceId		VARCHAR,
	DBWorkItemId			INT,
	DBProcessDefId			INT,
	DBActivityId			INT,
	DBUserIndex				INT,
	DBDocumentOrderBy		VARCHAR ,
	DBDocumentSortOrder		CHAR ,
	DBObjectPreferenceList	VARCHAR ,
	DBISSharePoint			VARCHAR,
	DBTaskId				INT,
	DBSubTaskId				INT
) returns SETOF refcursor AS $$
	
DECLARE 
	RefCursor1			refcursor;
	RefCursor2			refcursor;
	RefCursor3			refcursor;
	RefCursor4			refcursor;
	RefCursor5			refcursor;
	RefCursor6			refcursor;
	RefCursor7			refcursor;
	RefCursor8			refcursor;--Case Management Support
	
	v_extTableName			VARCHAR(256);	
	v_ReferByName			VARCHAR(30);
	v_ReferTo				INT;
	v_CheckListCompleteFlag	VARCHAR(1);
	v_HoldStatus			INT;
	v_InstrumentStatus		VARCHAR(1);
	v_ParentWorkItemID		INT;
	v_ProcessInstanceId		VARCHAR(63);
	v_SaveStage				VARCHAR(63);
	v_Status				VARCHAR(255);
	v_VAR_REC_1				VARCHAR(255);
	v_VAR_REC_2				VARCHAR(255);
	v_queryStr				VARCHAR(8000);
/* Declaration of process variables */
	v_CreatedByName			VARCHAR(63);
	v_CreatedDatetime		TIMESTAMP;
	v_Introducedby			VARCHAR(63);
	v_IntroductionDateTime	TIMESTAMP;
	v_ProcessInstanceState 	INT;
	v_ImageCabName			VARCHAR(100);
	v_ExpectedProcessDelay	TIMESTAMP;
	v_objectName			VARCHAR(255);
	v_tempUserIndex			VARCHAR(10);
	v_rowCount				INT;
	in_DBDocumentOrderBy 	VARCHAR(30);
	v_quoteChar 			CHAR(1);
	v_AssignedTo			VARCHAR(255);
	v_dueDate				TIMESTAMP;
	v_ActivityType 			INT;
	v_LastModifiedTime		TIMESTAMP;
	v_AssignedBy			VARCHAR(63);
	v_ActionDateTime		TIMESTAMP;
	v_ShowCaseVisual		VARCHAR(1);
	v_CanInitiate			VARCHAR(1);
	v_TaskType              INT;
	v_TaskMode              VARCHAR(1);
BEGIN
	in_DBDocumentOrderBy := DBDocumentOrderBy;
	v_quoteChar := CHR(39);
	IF NOT ((UPPER(DBDocumentOrderBy) = UPPER('Name')) OR (UPPER(DBDocumentOrderBy) = UPPER('RevisedDateTime')) OR (UPPER(DBDocumentOrderBy) = UPPER('DocumentSize')) OR (UPPER(DBDocumentOrderBy) = UPPER('CreatedByApplication')) OR (UPPER(DBDocumentOrderBy) = UPPER('NoOfPages')) OR (UPPER(DBDocumentOrderBy) = UPPER('Owner')) OR (UPPER(DBDocumentOrderBy) = UPPER('DocumentOrderNo'))) THEN
		in_DBDocumentOrderBy := 'Name';
	END IF;

	IF (DBTaskId>0) Then
		v_objectName := CAST(DBProcessDefId AS VARCHAR) || '@' || CAST(DBActivityId AS VARCHAR)||'#'||CAST(DBTaskId AS VARCHAR);
	Else
		v_objectName := CAST(DBProcessDefId AS VARCHAR) || '@' ||CAST(DBActivityId AS VARCHAR);
	END IF;
	--Raise Notice 'v_objectName %',v_objectName;
	v_tempUserIndex := CAST(DBUserIndex AS VARCHAR);
	--Raise Notice 'v_tempUserIndex %',v_tempUserIndex;

	v_rowCount := -1;

	v_queryStr := ' Select ObjectId, ObjectName, ObjectType, NotifyByEmail, Data ' ||
			' From	UserPreferencesTable  ' ||
			' Where	userId	= ' || v_tempUserIndex ||
			' AND	UPPER(ObjectName) =  ''' || UPPER(v_objectName) ||
			''' AND	UPPER(ObjectType) in ( ' || UPPER(DBObjectPreferenceList) || ' )';

	--Raise Notice 'Query %',v_queryStr;
	Open RefCursor1 For Execute v_QueryStr; 
	Return next RefCursor1;
		Select  ReferredByName, ReferredTo, CheckListCompleteFlag, HoldStatus, InstrumentStatus,
			ParentWorkItemID, ProcessInstanceId, SaveStage, Status, VAR_REC_1, VAR_REC_2,CreatedByName,
			ExpectedProcessDelay, Introducedby,IntroductionDatetime, ProcessInstanceState,ActivityType,LastModifiedTime  
		INTO v_ReferByName, v_ReferTo, v_CheckListCompleteFlag, v_HoldStatus, v_InstrumentStatus, 
			v_ParentWorkItemID, v_ProcessInstanceId, v_SaveStage, v_Status, v_VAR_REC_1, v_VAR_REC_2,
			v_CreatedByName, v_ExpectedProcessDelay, v_Introducedby, v_IntroductionDatetime,
			v_ProcessInstanceState,v_ActivityType,v_LastModifiedTime 
		From	WFInstrumentTable 
		Where	ProcessInstanceId	=  BTRIM(DBProcessInstanceId)
		And		WorkitemId				=  DBWorkitemId;
		
		GET DIAGNOSTICS v_rowCount = ROW_COUNT;
		IF( v_rowcount <= 0 ) THEN
			Select 	INTO v_ReferByName, v_ReferTo, v_CheckListCompleteFlag, v_HoldStatus, v_InstrumentStatus,
				v_ParentWorkItemID, v_ProcessInstanceId, v_SaveStage, v_Status, v_VAR_REC_1, 
				v_VAR_REC_2, v_CreatedByName, v_Createddatetime, v_ExpectedProcessDelay, v_Introducedby, 
				v_IntroductionDatetime, v_ProcessInstanceState,v_ActivityType,v_LastModifiedTime , v_ImageCabName  
			ReferredByName, ReferredTo, CheckListCompleteFlag, HoldStatus, InstrumentStatus, 
				ParentWorkItemID, ProcessInstanceId, SaveStage, Status, VAR_REC_1, 
				VAR_REC_2, CreatedByName, Createddatetime, NULL, Introducedby, 
				IntroductionDatetime, ProcessInstanceState,ActivityType,LastModifiedTime , ImageCabName 	
			From	QueueHistoryTable 
			Where	ProcessInstanceId	=  BTRIM(DBProcessInstanceId)
			And	WorkitemId		=  DBWorkitemId;

			GET DIAGNOSTICS v_rowCount = ROW_COUNT;
	END IF;

	OPEN RefCursor2 FOR 
		Select  v_CreatedByName				AS	  CreatedByName, 
				v_ExpectedProcessDelay		AS	  ExpectedProcessDelay, 
				v_Introducedby				AS	  Introducedby, 
				v_IntroductionDatetime	 	AS	  IntroductionDatetime, 
				v_ProcessInstanceState		AS	  ProcessInstanceState,
				v_ImageCabName				AS    ImageCabName;
	RETURN next RefCursor2;

	OPEN RefCursor3 FOR 
		Select	v_ReferByName				AS	ReferredByName,
				v_ReferTo					AS	ReferredTo,
				v_CheckListCompleteFlag	 	AS	CheckListCompleteFlag, 
				v_HoldStatus				AS	HoldStatus, 
				v_InstrumentStatus			AS	InstrumentStatus, 
				v_ParentWorkItemID			AS	ParentWorkItemID,
				v_ProcessInstanceId	 		AS	ProcessInstanceId, 
				v_SaveStage					AS  SaveStage, 
				v_Status					AS	Status, 
				v_ActivityType	  			AS  ActivityType,
				v_LastModifiedTime			AS  LastModifiedTime,
				v_VAR_REC_1					AS  VAR_REC_1, 
				v_VAR_REC_2					AS  VAR_REC_2;
	RETURN next RefCursor3;		

	IF(DBISSharePoint = 'N') THEN
		v_queryStr := 'Select PDBDocument.DocumentIndex DocumentIndex, VersionNumber, Name, Owner, ' ||  /*bug 3919*/
				' CreatedDateTime, Comment, AppName CreatedByApplication, ImageIndex, ' ||
				' VolumeId, DocumentType, CheckoutStatus, ' ||
				' CheckoutByUser, NoOfPages, DocumentSize, RevisedDateTime, Author ' || /* WFS_5_117 */
				' From PDBDocument  Inner Join PDBDocumentContent ' ||
				' ON PDBDocument.documentIndex	= PDBDocumentContent.documentIndex ' ||
				' AND parentFolderIndex	= '''||v_VAR_REC_1||''' AND ''' || v_VAR_REC_2 || ''' = ''F''' ||
				' ORDER BY ' || in_DBDocumentOrderBy ||
				' ' || DBDocumentSortOrder ;		
		Open RefCursor4 For execute v_queryStr; 
		RETURN next RefCursor4;	
	END IF;
	
	v_queryStr := 'Select	ToDoValue FROM	ToDoStatusView  '||' WHERE	ProcessInstanceId = '''||DBProcessInstanceId||'''' ;
	Open RefCursor5 For execute v_queryStr;
	RETURN next RefCursor5;
	
	v_queryStr := 'SELECT	ExceptionId, excpseqid, ActionId, ' ||
			' activitytable.ActivityName ActivityName, UserName, ActionDateTime, ' ||
			' ExceptionName, ExceptionComments, FinalizationStatus ' || 
			' FROM	exceptionview  , activitytable  ' ||
			' WHERE	exceptionview.processdefid	= '||DBProcessDefId||' AND	activitytable.activityId	=   exceptionview.activityId ' ||
			' AND	activitytable.ProcessDefId	=   exceptionview.ProcessDefId ' ||
			' AND	ProcessInstanceId	= '''||DBProcessInstanceId||''' ORDER BY ExceptionId, excpseqid, ActionDateTime ASC';
	Open RefCursor6 For execute v_queryStr; 
	RETURN next RefCursor6;

	
	/*v_queryStr := 'Select Comments, CommentsBy, CommentsByName, CommentsTo, CommentsToName, CommentsType, ActionDateTime From WFCOMMENTSVIEW Where ActivityId = '||DBActivityId||' and ProcessInstanceId = '''||DBProcessInstanceId||''' Order By CommentsId DESC';*/
	
	v_queryStr := 'Select Comments, CommentsBy, CommentsByName, CommentsTo, CommentsToName, CommentsType, ActionDateTime,activitytable.ActivityName ActivityName From WFCOMMENTSVIEW,activitytable Where WFCOMMENTSVIEW.ProcessDefId = ActivityTable.ProcessDefId and WFCOMMENTSVIEW.ActivityId = ActivityTable.ActivityId and ProcessInstanceId = '''||DBProcessInstanceId||''' Order By CommentsId DESC';
	Open RefCursor7 For execute v_queryStr; 	
	RETURN next RefCursor7;
	
	IF(DBTaskId >0) THEN
		Select INTO v_assignedBy,v_ActionDateTime,v_AssignedTo,v_DueDate,v_TaskType,v_TaskMode  AssignedBy,ActionDateTime,AssignedTo,DueDate,TaskType,TaskMode FROM WFTaskStatusTable S INNER JOIN WFTaskDefTable T
		on processinstanceid=BTRIM(DBProcessInstanceId) And	WorkitemId	=  DBWorkitemId  And ActivityId= DBActivityId
		And S.TaskId	=DBTaskId  And SubTaskId = DBSubTaskId
		and T.taskid=S.Taskid
		and T.ProcessDefId=S.ProcessDefId;
		
		OPEN RefCursor8 FOR 
		Select	v_AssignedBy		AS	AssignedBy,
				v_ActionDateTime	AS	ActionDateTime,
				v_AssignedTo		AS  AssignedTo,
				v_DueDate	  		AS  DueDate,
				v_TaskType          AS  TaskType,
				v_TaskMode          AS  TaskMode;
		RETURN next RefCursor8;
	END IF;
END;
$$LANGUAGE plpgsql;