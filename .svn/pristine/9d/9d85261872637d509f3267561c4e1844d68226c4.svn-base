/*-----------------------------------------------------------------------------------------------
			NEWGEN SOFTWARE TECHNOLOGIES LIMITED
-------------------------------------------------------------------------------------------------
	Group				: Application – Products
	Product / Project		: WorkFlow 6.0
	Module				: Transaction Server
	File Name			: WFTransferData.sql
	Author				: Mandep Kaur
	Date written (DD/MM/YYYY)	: 25/08/2005
	Description			: Script to move data to history tables for workitems
						- Reached exit workstep
						- Aborted
						- Discarded
-------------------------------------------------------------------------------------------------
				CHANGE HISTORY
-------------------------------------------------------------------------------------------------

Date			Change By		Change Description (Bug No. (If Any))
08/02/2008		Ashish Mangla	Bugzilla Bug 3326 (ProcessInstanceState for Discarded Workitems was going as that of completed)
29/05/2008		Varun Bhansaly	Optimization of SP - 
								Earlier scenario - 
									1. Query CurrentRouteLogTable and iterate over its results. Extract ProcessInstanceId for ActionIds 3, 5, 20.
									2. Prepare a JOIN of PendingWorkListTable, WorkListTable, ProcessInstanceTable.
								Optimized scenario - 
									1. Donot perform STEP 1 of Earlier scenario.
									2. Perform STEP 2 of Earlier scenario for for ProcessInstanceState 4, 5, 6
										4 - Terminated.
										5 - Aborted.
										6 - Completed.
									& iterate over the results.
09/09/2009		Indraneel	WFS_8.0_032 Error "table or view does not exists " while compiling stored procedure
15/02/2013		Neeraj Sharma   Bug id : 328250 History of the workitems was not generated when cabinet is upgraded from OF versions 6.2 to higher version Of 9.0. 
30/04/2013		Preeti Awasthi	Bug 39067 - Support of <ExternalTable_Name>_History Table in Search Workitem API
11/08/2014		Kahkeshan		Optimization Changes .
11/08/2014		Kahkeshan 		Merging of PRD Bugs 44945,44946,44670
08/10/2014      Kanika Manik    PRD	Bug 50463 - WFTransferData is not moving the data of External Table into ExternalTable_History table even though value of input parameter TransferHistoryData is 'Y'
07/07/2015		Ashutosh Pandey	Replicating from OF9 to OF10.x Bug 55753 - Provided option to add Comments while ad-hoc routing of Work Item in process manager
17/11/2015		Gourav Chadha	Bug 56325 - Observations and error handling in Audit Archive Service
23/12/2015		Ashutosh Pandey	Replicating Bug 58399 - Need an option to view refer, reassign and ad-hoc routing comments in workitem properties
28/07/2016		Kahkeshan		Bug 63161 - Changes required in archival scripts to be provide the support of archival post running WFTransferData
25/11/2016		Gourav Chadha		Bug 65678 - Increment Of Queue Variables 26 to 42
06/01/2017      Anju Gupta      Bug 66599 - Support to purge/move the Report Data from Product tables by using WFPurgeReportData.sql and WFTransferData.sql
18/05/2017      Ambuj Tripathi	Updating the proc for transfer history data for iBPS10 compatibility, Removing the TransferHistoryData flag, it will always be transferred when there exists corresp. history table
22/09/2017      Kumar Kimil     TransferData changes for Ibps3.2
08/11/2017		Ambuj Tripathi	Changes to add URN in TransferData for Case Registration changes.
22/04/2018	    Kumar Kimil		Bug 77269 - CheckMarx changes (High Severity)
22/04/2018  Ambuj Tripathi		Bug 76862 - Remove the db console messages from all procedures
30/04/2019      Ravi Ranjan Kumar   PRDP Bug Mergin (Bug 83894 - Support to define explicit History Table for the external table instead of hardcoded '_History')
08/06/2023		Bug 127756 - Three column has been added in WFCurrentRouteLogTable, ProcessingTime ,TAT & DelayTime (Support given for TAT on UI)
-------------------------------------------------------------------------------------------------*/
CREATE OR REPLACE PROCEDURE WFTransferData (
DBRowsToProcess			INTEGER DEFAULT 0, /*Its value should be mutiple of 100*/
v_Days					INTEGER DEFAULT 0,
v_ProcessDefId          INTEGER DEFAULT 0
)
AS 
	v_quoteChar 			CHAR(1);
	v_queryStr						NVARCHAR2(3000);
	TYPE TransferCursor				IS REF CURSOR;
	TYPE QueueHistoryTableRecord	IS RECORD
	(
		ProcessDefId					QueueHistoryTable.ProcessDefId%Type,
		ProcessName						QueueHistoryTable.ProcessName%Type,
		ProcessVersion					QueueHistoryTable.ProcessVersion%Type,
		ProcessInstanceId				QueueHistoryTable.ProcessInstanceId%Type,
		ProcessInstanceName				QueueHistoryTable.ProcessInstanceName%Type,
		ActivityId						QueueHistoryTable.ActivityId%Type,
		ActivityName					QueueHistoryTable.ActivityName%Type,
		ParentWorkItemId				QueueHistoryTable.ParentWorkItemId%Type,
		WorkItemId						QueueHistoryTable.WorkItemId%Type,
		ProcessInstanceState			QueueHistoryTable.ProcessInstanceState%Type,
		WorkItemState					QueueHistoryTable.WorkItemState%Type,
		StateName						QueueHistoryTable.StateName%Type,
		QueueName						QueueHistoryTable.QueueName%Type,
		QueueType						QueueHistoryTable.QueueType%Type,
		AssignedUser					QueueHistoryTable.AssignedUser%Type,
		AssignmentType					QueueHistoryTable.AssignmentType%Type,
		InstrumentStatus				QueueHistoryTable.InstrumentStatus%Type,
		CheckListCompleteFlag			QueueHistoryTable.CheckListCompleteFlag%Type,
		IntroductionDateTime			QueueHistoryTable.IntroductionDateTime%Type,
		CreatedDateTime					QueueHistoryTable.CreatedDateTime%Type,
		IntroducedBy					QueueHistoryTable.IntroducedBy%Type,
		IntroducedAt					QueueHistoryTable.IntroducedAt%Type,
		CreatedByName					QueueHistoryTable.CreatedByName%Type,
		EntryDateTime					QueueHistoryTable.EntryDateTime%Type,
		LockStatus						QueueHistoryTable.LockStatus%Type,
		HoldStatus						QueueHistoryTable.HoldStatus%Type,
		PriorityLevel					QueueHistoryTable.PriorityLevel%Type,
		LockedByName					QueueHistoryTable.LockedByName%Type,
		LockedTime						QueueHistoryTable.LockedTime%Type,
		ValidTill						QueueHistoryTable.ValidTill%Type,
		SaveStage						QueueHistoryTable.SaveStage%Type,
		PreviousStage					QueueHistoryTable.PreviousStage%Type,
		ExpectedWorkItemDelayTime		QueueHistoryTable.ExpectedWorkItemDelayTime%Type,
		ExpectedProcessDelayTime		QueueHistoryTable.ExpectedProcessDelayTime%Type,
		Status							QueueHistoryTable.Status%Type,
		VAR_INT1						QueueHistoryTable.VAR_INT1%Type,
		VAR_INT2						QueueHistoryTable.VAR_INT2%Type,
		VAR_INT3						QueueHistoryTable.VAR_INT3%Type,
		VAR_INT4						QueueHistoryTable.VAR_INT4%Type,
		VAR_INT5						QueueHistoryTable.VAR_INT5%Type,
		VAR_INT6						QueueHistoryTable.VAR_INT6%Type,
		VAR_INT7						QueueHistoryTable.VAR_INT7%Type,
		VAR_INT8						QueueHistoryTable.VAR_INT8%Type,
		VAR_FLOAT1						QueueHistoryTable.VAR_FLOAT1%Type,
		VAR_FLOAT2						QueueHistoryTable.VAR_FLOAT2%Type,
		VAR_DATE1						QueueHistoryTable.VAR_DATE1%Type,
		VAR_DATE2						QueueHistoryTable.VAR_DATE2%Type,
		VAR_DATE3						QueueHistoryTable.VAR_DATE3%Type,
		VAR_DATE4						QueueHistoryTable.VAR_DATE4%Type,
		VAR_DATE5						QueueHistoryTable.VAR_DATE5%Type,
		VAR_DATE6						QueueHistoryTable.VAR_DATE6%Type,
		VAR_LONG1						QueueHistoryTable.VAR_LONG1%Type,
		VAR_LONG2						QueueHistoryTable.VAR_LONG2%Type,
		VAR_LONG3						QueueHistoryTable.VAR_LONG3%Type,
		VAR_LONG4						QueueHistoryTable.VAR_LONG4%Type,
		VAR_LONG5						QueueHistoryTable.VAR_LONG5%Type,
		VAR_LONG6						QueueHistoryTable.VAR_LONG6%Type,
		VAR_STR1				  		QueueHistoryTable.VAR_STR1%Type,
		VAR_STR2						QueueHistoryTable.VAR_STR2%Type,
		VAR_STR3						QueueHistoryTable.VAR_STR3%Type,
		VAR_STR4						QueueHistoryTable.VAR_STR4%Type,
		VAR_STR5						QueueHistoryTable.VAR_STR5%Type,
		VAR_STR6						QueueHistoryTable.VAR_STR6%Type,
		VAR_STR7						QueueHistoryTable.VAR_STR7%Type,
		VAR_STR8						QueueHistoryTable.VAR_STR8%Type,
		VAR_STR9						QueueHistoryTable.VAR_STR9%Type,
		VAR_STR10						QueueHistoryTable.VAR_STR10%Type,
		VAR_STR11						QueueHistoryTable.VAR_STR11%Type,
		VAR_STR12						QueueHistoryTable.VAR_STR12%Type,
		VAR_STR13						QueueHistoryTable.VAR_STR13%Type,
		VAR_STR14						QueueHistoryTable.VAR_STR14%Type,
		VAR_STR15						QueueHistoryTable.VAR_STR15%Type,
		VAR_STR16						QueueHistoryTable.VAR_STR16%Type,
		VAR_STR17						QueueHistoryTable.VAR_STR17%Type,
		VAR_STR18						QueueHistoryTable.VAR_STR18%Type,
		VAR_STR19						QueueHistoryTable.VAR_STR19%Type,
		VAR_STR20						QueueHistoryTable.VAR_STR20%Type,
		VAR_REC_1						QueueHistoryTable.VAR_REC_1%Type,
		VAR_REC_2						QueueHistoryTable.VAR_REC_2%Type,
		VAR_REC_3						QueueHistoryTable.VAR_REC_3%Type,
		VAR_REC_4						QueueHistoryTable.VAR_REC_4%Type,
		VAR_REC_5						QueueHistoryTable.VAR_REC_5%Type,
		Q_StreamId						QueueHistoryTable.Q_StreamId%Type,
		Q_QueueId						QueueHistoryTable.Q_QueueId%Type,
		Q_UserID						QueueHistoryTable.Q_UserID%Type,
		LastProcessedBy					QueueHistoryTable.LastProcessedBy%Type,
		ProcessedBy						QueueHistoryTable.ProcessedBy%Type,
		ReferredTo						QueueHistoryTable.ReferredTo%Type,
		ReferredToName					QueueHistoryTable.ReferredToName%Type,
		ReferredBy						QueueHistoryTable.ReferredBy%Type,
		ReferredByName					QueueHistoryTable.ReferredByName%Type,
		CollectFlag						QueueHistoryTable.CollectFlag%Type,
		CompletionDateTime				QueueHistoryTable.CompletionDateTime%Type,
		CreatedBy						QueueHistoryTable.CreatedBy%Type,
		--Adding for compatibility with iBPS10
		CalendarName					QueueHistoryTable.CalendarName%Type,
		ExportStatus					QueueHistoryTable.ExportStatus%Type,
		ProcessVariantId				QueueHistoryTable.ProcessVariantId%Type,
		ActivityType					QueueHistoryTable.ActivityType%Type,
		LastModifiedTime				QueueHistoryTable.LastModifiedTime%Type,

		ChildProcessInstanceId			QueueHistoryTable.ChildProcessInstanceId%Type,
		ChildWorkitemId					QueueHistoryTable.ChildWorkitemId%Type,
		FilterValue						QueueHistoryTable.FilterValue%Type,
		Guid							QueueHistoryTable.Guid%Type,
		NotifyStatus					QueueHistoryTable.NotifyStatus%Type,
		Q_DivertedByUserId				QueueHistoryTable.Q_DivertedByUserId%Type,
		RoutingStatus					QueueHistoryTable.RoutingStatus%Type,
		NoOfCollectedInstances			QueueHistoryTable.NoOfCollectedInstances%Type,
		IsPrimaryCollected				QueueHistoryTable.IsPrimaryCollected%Type,
		Introducedbyid                  QueueHistoryTable.Introducedbyid%Type,
		URN								QueueHistoryTable.URN%Type,
		ProcessingTime					QueueHistoryTable.ProcessingTime%Type
	);
	v_cursor						TransferCursor;
	v_record						QueueHistoryTableRecord;
	v_batchSize						SMALLINT;
	v_rowCounter					INTEGER;
	dt varchar2(8000);
	v_ExtTableString	NVARCHAR2(3000);
	var_extTableName	NVARCHAR2(300);
	var_extTableName_HISTORY NVARCHAR2(300);
	v_pos1				INT;
	v_pos2				INT;
	transfer_cursor		INT;
	var_ProcessDefId	INT;
	v_status            INTEGER;
	v_RowsFetched       INTEGER;
	var_VAR_REC_1		NVARCHAR2(510);
	var_VAR_REC_2		NVARCHAR2(10);
	v_queryStr1			VARCHAR(1000);
	v_queryStr2			VARCHAR(1000);
	v_rowPresent		INTEGER; 
	v_rowProcessStr		VARCHAR(200);
	v_conditionStr		VARCHAR(200);
	v_TransferHistoryData VARCHAR(2);
	v_extTableName		VARCHAR(30);
	v_tabExists			INTEGER;
	existsFlag 			INTEGER;
BEGIN 
	--dbms_output.put_line ('Execution begins'); 
	v_quoteChar := CHR(39);
	v_rowCounter := 0;
	v_rowProcessStr := '';
	IF (DBRowsToProcess > 0 AND DBRowsToProcess < 100) THEN
		v_rowProcessStr := v_rowProcessStr || ' AND ROWNUM <= ' ||TO_CHAR(DBRowsToProcess);
	ELSE
		v_rowProcessStr := v_rowProcessStr || ' AND ROWNUM <= 100';	
	END IF;
	v_conditionStr := '';
	IF(v_Days > 0) THEN
		v_conditionStr := v_conditionStr || ' AND ENTRYDATETIME < (SYSDATE - ' || TO_CHAR(v_Days) || ')';
	END IF;
	
	IF(v_ProcessDefId > 0) THEN
		v_conditionStr := v_conditionStr || ' AND PROCESSDEFID = ' || TO_CHAR(v_ProcessDefId);
	END IF;
	
	v_queryStr := 
		'SELECT ProcessDefId, ProcessName, ProcessVersion, ProcessInstanceId, ProcessInstanceId,' ||
		' ActivityId, ActivityName, ParentWorkItemId, WorkItemId, ProcessInstanceState, WorkItemState,' ||
		' StateName, QueueName, QueueType, AssignedUser, AssignmentType,' ||
		' InstrumentStatus, CheckListCompleteFlag, IntroductionDateTime, CreatedDateTime, IntroducedBy, IntroducedAt, ' ||
		' CreatedByName, EntryDateTime, LockStatus, HoldStatus, PriorityLevel,' ||
		' LockedByName, LockedTime, ValidTill, SaveStage, PreviousStage,' ||
		' ExpectedWorkItemDelay, ExpectedProcessDelay, Status, VAR_INT1, VAR_INT2,' ||
		' VAR_INT3, VAR_INT4, VAR_INT5, VAR_INT6, VAR_INT7,' ||
		' VAR_INT8, VAR_FLOAT1, VAR_FLOAT2, VAR_DATE1, VAR_DATE2,' ||
		' VAR_DATE3, VAR_DATE4, VAR_DATE5, VAR_DATE6, VAR_LONG1, VAR_LONG2, VAR_LONG3,' ||
		' VAR_LONG4, VAR_LONG5, VAR_LONG6, VAR_STR1, VAR_STR2, VAR_STR3, VAR_STR4,' ||
		' VAR_STR5, VAR_STR6, VAR_STR7, VAR_STR8, VAR_STR9, VAR_STR10, '||
		' VAR_STR11, VAR_STR12, VAR_STR13, VAR_STR14, VAR_STR15, VAR_STR16, '||
		' VAR_STR17, VAR_STR18, VAR_STR19, VAR_STR20, VAR_REC_1,' ||
		' VAR_REC_2, VAR_REC_3, VAR_REC_4, VAR_REC_5, Q_StreamId,' ||
		' Q_QueueId, Q_UserID, LastProcessedBy, ProcessedBy, ReferredTo,' ||
		' ReferredToName, ReferredBy, ReferredByName, CollectFlag, NULL, CreatedBy,' ||
		--Added the extra columns here
		' CalendarName, ExportStatus, ProcessVariantId, ActivityType, LastModifiedTime,' ||	
		' ChildProcessInstanceId, ChildWorkitemId, FilterValue, Guid, NotifyStatus, Q_DivertedByUserId,' ||
		' RoutingStatus, NoOfCollectedInstances, IsPrimaryCollected,Introducedbyid, ' ||
		' URN, ProcessingTime '||
		' FROM WFInstrumentTable ' ||
		' WHERE WorkItemId = 1 ' ||
		' AND ProcessInstanceState IN (4,5,6)' || v_conditionStr ||
		v_rowProcessStr;
		--DBMS_OUTPUT.PUT_LINE('v_queryStr........'||v_queryStr);

	WHILE ((DBRowsToProcess > 0 AND v_rowCounter < DBRowsToProcess) OR (DBRowsToProcess = 0 AND 1 = 1)) LOOP
	BEGIN
		OPEN  v_cursor FOR TO_CHAR(v_queryStr);
		v_rowPresent := 0;
		LOOP
			FETCH v_cursor INTO v_record;
			EXIT WHEN v_cursor%NOTFOUND;
			SAVEPOINT TRANDATA;
			--DBMS_OUTPUT.PUT_LINE('Starting insert');
			BEGIN
				v_rowPresent := 1;
				Insert Into QueueHistoryTable(
					ProcessDefId, ProcessName, ProcessVersion, ProcessInstanceId, ProcessInstanceName, 
					ActivityId, ActivityName, ParentWorkItemId, WorkItemId, ProcessInstanceState, 
					WorkItemState, StateName, QueueName, QueueType, AssignedUser, 
					AssignmentType, InstrumentStatus, CheckListCompleteFlag, IntroductionDateTime, CreatedDateTime, 
					IntroducedBy, IntroducedAt, CreatedByName, EntryDateTime, LockStatus, HoldStatus, 
					PriorityLevel, LockedByName, LockedTime, ValidTill, SaveStage, 
					PreviousStage, ExpectedWorkItemDelayTime, ExpectedProcessDelayTime, Status, VAR_INT1, 
					VAR_INT2, VAR_INT3, VAR_INT4, VAR_INT5, VAR_INT6, 
					VAR_INT7, VAR_INT8, VAR_FLOAT1, VAR_FLOAT2, VAR_DATE1, 
					VAR_DATE2, VAR_DATE3, VAR_DATE4, VAR_DATE5, VAR_DATE6, VAR_LONG1, VAR_LONG2, 
					VAR_LONG3, VAR_LONG4, VAR_LONG5, VAR_LONG6, VAR_STR1, VAR_STR2, VAR_STR3, 
					VAR_STR4, VAR_STR5, VAR_STR6, VAR_STR7, VAR_STR8, VAR_STR9, VAR_STR10, VAR_STR11, VAR_STR12, VAR_STR13,
					VAR_STR14, VAR_STR15, VAR_STR16, VAR_STR17, VAR_STR18, VAR_STR19, VAR_STR20,
					VAR_REC_1, VAR_REC_2, VAR_REC_3, VAR_REC_4,	VAR_REC_5,
					Q_StreamId, Q_QueueId, Q_UserID, LastProcessedBy, ProcessedBy, 
					ReferredTo, ReferredToName, ReferredBy, ReferredByName, CollectFlag, CompletionDateTime, CreatedBy,
					CalendarName, ExportStatus, ProcessVariantId, ActivityType, LastModifiedTime,ChildProcessInstanceId,ChildWorkitemId,FilterValue,Guid,NotifyStatus,Q_DivertedByUserId,RoutingStatus,NoOfCollectedInstances,IsPrimaryCollected,Introducedbyid,URN,ProcessingTime
				) VALUES (
					v_record.ProcessDefId, v_record.ProcessName, v_record.ProcessVersion, v_record.ProcessInstanceId, v_record.ProcessInstanceName, 
					v_record.ActivityId, v_record.ActivityName, v_record.ParentWorkItemId, v_record.WorkItemId, v_record.ProcessInstanceState, 
					v_record.WorkItemState, v_record.StateName, v_record.QueueName,	v_record.QueueType, v_record.AssignedUser, 
					v_record.AssignmentType, v_record.InstrumentStatus,	v_record.CheckListCompleteFlag, v_record.IntroductionDateTime, v_record.CreatedDateTime, v_record.IntroducedBy, v_record.IntroducedAt, v_record.CreatedByName, v_record.EntryDateTime, v_record.LockStatus, v_record.HoldStatus,
					v_record.PriorityLevel, v_record.LockedByName, v_record.LockedTime, v_record.ValidTill,	v_record.SaveStage, 
					v_record.PreviousStage, v_record.ExpectedWorkItemDelayTime, v_record.ExpectedProcessDelayTime, v_record.Status, v_record.VAR_INT1, 
					v_record.VAR_INT2, v_record.VAR_INT3, v_record.VAR_INT4, v_record.VAR_INT5, v_record.VAR_INT6, 
					v_record.VAR_INT7, v_record.VAR_INT8, v_record.VAR_FLOAT1, v_record.VAR_FLOAT2, v_record.VAR_DATE1,
					v_record.VAR_DATE2, v_record.VAR_DATE3, v_record.VAR_DATE4, v_record.VAR_DATE5, v_record.VAR_DATE6,
					v_record.VAR_LONG1, v_record.VAR_LONG2,	v_record.VAR_LONG3, v_record.VAR_LONG4, v_record.VAR_LONG5, 
					v_record.VAR_LONG6, v_record.VAR_STR1, v_record.VAR_STR2, v_record.VAR_STR3, v_record.VAR_STR4, v_record.VAR_STR5, v_record.VAR_STR6, v_record.VAR_STR7, v_record.VAR_STR8, v_record.VAR_STR9,v_record.VAR_STR10, v_record.VAR_STR11, v_record.VAR_STR12, v_record.VAR_STR13, v_record.VAR_STR14, v_record.VAR_STR15, v_record.VAR_STR16, v_record.VAR_STR17, v_record.VAR_STR18, v_record.VAR_STR19, v_record.VAR_STR20, v_record.VAR_REC_1, v_record.VAR_REC_2, v_record.VAR_REC_3, v_record.VAR_REC_4, v_record.VAR_REC_5,
					v_record.Q_StreamId, v_record.Q_QueueId, v_record.Q_UserID, v_record.LastProcessedBy, v_record.ProcessedBy, 
					v_record.ReferredTo, v_record.ReferredToName, v_record.ReferredBy, v_record.ReferredByName, v_record.CollectFlag, 
					NULL, v_record.CreatedBy, v_record.CalendarName, v_record.ExportStatus, v_record.ProcessVariantId, v_record.ActivityType, v_record.LastModifiedTime, v_record.ChildProcessInstanceId, v_record.ChildWorkitemId, v_record.FilterValue, v_record.Guid, v_record.NotifyStatus, v_record.Q_DivertedByUserId, v_record.RoutingStatus, v_record.NoOfCollectedInstances, v_record.IsPrimaryCollected,v_record.Introducedbyid,v_record.URN,v_record.ProcessingTime
				);

				--DBMS_OUTPUT.PUT_LINE('After insert');
			
				DELETE FROM WFInstrumentTable WHERE ProcessInstanceId = v_record.ProcessInstanceId;
			
				INSERT INTO EXCEPTIONHISTORYTABLE
					SELECT ProcessDefId, ExcpSeqId, WorkitemId, Activityid, ActivityName, 
							ProcessInstanceId, UserId, UserName, ActionId, ActionDateTime, ExceptionId,
							ExceptionName, FinalizationStatus, ExceptionComments
					FROM EXCEPTIONTABLE
					WHERE EXCEPTIONTABLE.ProcessInstanceId = v_record.ProcessInstanceId;
				
				DELETE from EXCEPTIONTABLE where ProcessInstanceId = v_record.ProcessInstanceId;
  
				INSERT INTO TODOSTATUSHISTORYTABLE
					SELECT ProcessDefId, ProcessInstanceId, ToDoValue
					FROM TODOSTATUSTABLE
					WHERE TODOSTATUSTABLE.ProcessInstanceId = v_record.ProcessInstanceId;
				
				DELETE from TODOSTATUSTABLE where ProcessInstanceId = v_record.ProcessInstanceId;  

				INSERT INTO WFREPORTDATAHISTORYTABLE
					SELECT ProcessInstanceId, WorkitemId, ProcessDefId, Activityid, UserId, TotalProcessingTime, ProcessVariantId
					FROM WFREPORTDATATABLE 
					WHERE WFREPORTDATATABLE.ProcessInstanceId = v_record.ProcessInstanceId;
				
				DELETE from WFREPORTDATATABLE where ProcessInstanceId = v_record.ProcessInstanceId;  

				INSERT INTO WFHISTORYROUTELOGTABLE 
					SELECT LogId, ProcessDefId, ActivityId, ProcessInstanceId, WorkItemId, UserId, ActionId, ActionDatetime, AssociatedFieldId, AssociatedFieldName, ActivityName, UserName, NewValue, AssociatedDateTime, QueueId, ProcessVariantId, TaskId, SubTaskId, URN, ProcessingTime, TAT, DelayTime FROM WFCURRENTROUTELOGTABLE
					WHERE WFCURRENTROUTELOGTABLE.ProcessInstanceId =  v_record.ProcessInstanceId;
				DELETE FROM WFCURRENTROUTELOGTABLE WHERE ProcessInstanceId =  v_record.ProcessInstanceId;
				
				--Adding the case management tables
				INSERT INTO WFTASKSTATUSHISTORYTABLE
					SELECT ProcessInstanceId,WorkItemId,ProcessDefId,ActivityId,TaskId,SubTaskId,TaskStatus,AssignedBy,AssignedTo,Instructions,ActionDateTime,DueDate,Priority,ShowCaseVisual,ReadFlag,CanInitiate,Q_DivertedByUserId,LockStatus,InitiatedBy,TaskEntryDateTime,ValidTill,ApprovalRequired,ApprovalSentBy,	AllowReassignment,AllowDecline,EscalatedFlag FROM WFTaskStatusTable
					WHERE WFTaskStatusTable.ProcessInstanceId =  v_record.ProcessInstanceId;
				DELETE FROM WFTaskStatusTable WHERE ProcessInstanceId =  v_record.ProcessInstanceId;

				INSERT INTO WFRTTASKINTFCASSOCHISTORY
					SELECT ProcessInstanceId, WorkItemId, ProcessDefId, ActivityId, TaskId, InterfaceId, InterfaceType, Attribute FROM WFRTTASKINTERFACEASSOCTABLE
					WHERE WFRTTASKINTERFACEASSOCTABLE.ProcessInstanceId =  v_record.ProcessInstanceId;
				DELETE FROM WFRTTASKINTERFACEASSOCTABLE WHERE ProcessInstanceId =  v_record.ProcessInstanceId;
				
				INSERT INTO RTACTIVITYINTFCASSOCHISTORY
					SELECT ProcessInstanceId, WorkItemId, ProcessDefId, ActivityId, ActivityName, InterfaceElementId, InterfaceType, Attribute, TriggerName, ProcessVariantId FROM RTACTIVITYINTERFACEASSOCTABLE
				WHERE RTACTIVITYINTERFACEASSOCTABLE.ProcessInstanceId =  v_record.ProcessInstanceId;
				
				DELETE FROM RTACTIVITYINTERFACEASSOCTABLE WHERE ProcessInstanceId =  v_record.ProcessInstanceId;
				--Adding case management tables ends here
				--IBPS 3.2 release changes start
				INSERT INTO WFCaseSummaryDetailsHistory(ProcessInstanceId,WorkItemId, ProcessDefId, ActivityId,ActivityName,Status,NoOfRetries,EntryDateTime,LockedBy) SELECT  ProcessInstanceId,WorkItemId, ProcessDefId, ActivityId,ActivityName,Status,NoOfRetries,EntryDateTime,LockedBy FROM WFCaseSummaryDetailsTable WHERE WFCaseSummaryDetailsTable.ProcessInstanceId =  v_record.ProcessInstanceId;
				DELETE FROM WFCaseSummaryDetailsTable WHERE ProcessInstanceId =  v_record.ProcessInstanceId;

				INSERT INTO WFCaseDocStatusHistory(ProcessInstanceId,WorkItemId, ProcessDefId, ActivityId,TaskId,SubTaskId,DocumentType,DocumentIndex,ISIndex,CompleteStatus) SELECT  ProcessInstanceId,WorkItemId, ProcessDefId, ActivityId,TaskId,SubTaskId,DocumentType,DocumentIndex,ISIndex,CompleteStatus FROM WFCaseDocStatusTable where WFCaseDocStatusTable.ProcessInstanceId =  v_record.ProcessInstanceId;
				DELETE FROM WFCaseDocStatusTable WHERE ProcessInstanceId =  v_record.ProcessInstanceId;
				
				INSERT INTO WFTaskPreCondResultHistory(ProcessInstanceId,WorkItemId, ActivityId, TaskId,Ready,Mandatory) SELECT  ProcessInstanceId,WorkItemId, ActivityId, TaskId,Ready,Mandatory FROM WFTaskPreConditionResultTable
				WHERE WFTaskPreConditionResultTable.ProcessInstanceId =  v_record.ProcessInstanceId;
				
				DELETE FROM WFTaskPreConditionResultTable WHERE ProcessInstanceId =  v_record.ProcessInstanceId;
				
				INSERT INTO WFTaskPreCheckHistory(ProcessInstanceId, WorkItemId,ActivityId,checkPreCondition) SELECT  ProcessInstanceId, WorkItemId,ActivityId,checkPreCondition FROM WFTaskPreCheckTable
				WHERE WFTaskPreCheckTable.ProcessInstanceId =  v_record.ProcessInstanceId;
				
				DELETE FROM WFTaskPreCheckTable WHERE ProcessInstanceId =  v_record.ProcessInstanceId;
				--IBPS 3.2 release changes end
				--Moving external table data begins here
				BEGIN
					v_tabExists := 0;
					existsFlag	:=0;
					v_extTableName := NULL;
					BEGIN
						/*debug*/
						--dbms_output.put_line('Searching in EXTDBCONFTABLE for ProcessDefId : ' || v_record.ProcessDefId); 
						
						SELECT TABLENAME , HISTORYTABLENAME INTO v_extTableName, var_extTableName_HISTORY FROM EXTDBCONFTABLE 
						WHERE extobjid = 1 AND PROCESSDEFID = v_record.ProcessDefId;
												
						IF v_extTableName IS NOT NULL THEN
							/*debug*/
							--dbms_output.put_line('Found External table name : ' || v_extTableName); 
							v_extTableName:=REPLACE(v_extTableName,v_quoteChar,v_quoteChar||v_quoteChar);--CheckMarx findings
							var_extTableName_HISTORY:=REPLACE(v_extTableName,v_quoteChar,v_quoteChar||v_quoteChar);
							BEGIN
								SELECT COUNT(1) INTO v_tabExists FROM ALL_TABLES WHERE UPPER(TABLE_NAME) = UPPER(v_extTableName || '_HISTORY');
							EXCEPTION
								WHEN NO_DATA_FOUND THEN
									SELECT COUNT(1) INTO existsFlag FROM ALL_TABLES WHERE UPPER(TABLE_NAME) = UPPER(var_extTableName_HISTORY);
							END;
							
							IF v_tabExists =1  THEN
								var_extTableName_HISTORY :=v_extTableName || '_HISTORY';
							END IF;

							IF v_tabExists = 1 OR  existsFlag =1 THEN
								/*debug*/
								--dbms_output.put_line('External history table exists, moving data'); 

								v_queryStr1 := 'INSERT INTO ' || var_extTableName_HISTORY || ' SELECT * FROM ' || v_extTableName || 
												' WHERE ITEMINDEX = N''' || v_record.VAR_REC_1 || ''' AND ITEMTYPE = N''' || v_record.VAR_REC_2 || '''';
								/*debug*/
								--dbms_output.put_line('External history table insert query : ' || v_queryStr1); 
								EXECUTE IMMEDIATE ( v_queryStr1 );
									
								v_queryStr1 := 'DELETE FROM ' || v_extTableName || ' WHERE ITEMINDEX = N''' || v_record.VAR_REC_1 || ''' AND ITEMTYPE = N''' || v_record.VAR_REC_2 || '''';
								/*debug*/
								--dbms_output.put_line('External history table delete query : ' || v_queryStr1); 
								EXECUTE IMMEDIATE ( v_queryStr1 );
							ELSE
								dbms_output.put_line('External history table does not exists.'); 
							END IF;
						ELSE
							dbms_output.put_line('No external tables found in the EXTDBCONFTABLE! : ' || v_extTableName); 
						END IF;
					EXCEPTION
						WHEN NO_DATA_FOUND THEN
						NULL;
						WHEN OTHERS THEN
						BEGIN
							dbms_output.put_line('Error Encountered getting the external table : ' || SQLERRM); 
						END;
					END;
				EXCEPTION
					WHEN OTHERS THEN
					BEGIN
						dbms_output.put_line('Error Encountered while transfer of external table : ' || SQLERRM); 
					END;
				END;
				--Moving external table data ends here

				BEGIN
					INSERT INTO WFCommentsHistoryTable SELECT CommentsId, ProcessDefId, ActivityId, ProcessInstanceId, WorkItemId, CommentsBy, CommentsByName, CommentsTo, CommentsToName, Comments, ActionDateTime, CommentsType, ProcessVariantId, TaskId, SubTaskId FROM WFCommentsTable WHERE WFCommentsTable.ProcessInstanceId = v_record.ProcessInstanceId;
					DELETE FROM WFCommentsTable WHERE ProcessInstanceId = v_record.ProcessInstanceId;
				END;
				
				BEGIN
					INSERT INTO WFATTRIBUTEMESSAGEHISTORYTABLE SELECT  ProcessDefId, ProcessVariantId, ProcessInstanceId, WorkItemId,MessageId,Message,LockedBy,Status,ActionDateTime FROM WFATTRIBUTEMESSAGETABLE WHERE WFATTRIBUTEMESSAGETABLE.ProcessInstanceId = v_record.ProcessInstanceId;
					DELETE FROM WFATTRIBUTEMESSAGETABLE WHERE ProcessInstanceId = v_record.ProcessInstanceId;	
				END;
				
				EXECUTE IMMEDIATE ('INSERT INTO SuccessLogTable Values (0, ''' || to_char(v_record.ProcessInstanceId) || ''')'); 
				COMMIT;
				v_rowCounter := v_rowCounter + 1;
			EXCEPTION
				WHEN OTHERS THEN 
				BEGIN
					ROLLBACK TO SAVEPOINT TRANDATA;
					EXECUTE IMMEDIATE ('INSERT INTO FailureLogTable Values (0, ''' ||to_char(v_record.ProcessInstanceId) || ''')');
					COMMIT;
					--Added to check for infinite loop
					v_rowCounter := v_rowCounter + 1;
					EXIT;
				END;
			END;
		END LOOP;
		CLOSE v_cursor;
		
		IF (v_rowPresent = 0) THEN
			DBMS_OUTPUT.PUT_LINE('Exiting........');
			EXIT;
		END IF;
	EXCEPTION
		WHEN OTHERS THEN 
		BEGIN
			DBMS_OUTPUT.PUT_LINE('Check!! Check!! An Exception occurred while execution of Stored Procedure WFTransferData........'); 
			CLOSE v_cursor; 
			RAISE;
		END;
	END;
	END LOOP;
END;