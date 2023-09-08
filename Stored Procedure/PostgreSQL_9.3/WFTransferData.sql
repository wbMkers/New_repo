    /*-----------------------------------------------------------------------------------------------
			NEWGEN SOFTWARE TECHNOLOGIES LIMITED
-------------------------------------------------------------------------------------------------
	Group				: Application – Products
	Product / Project	: Omniflow 10
	Module				: Transaction Server
	File Name			: WFTransferData.sql
	Author				: Hitesh Singla
	Date written (DD/MM/YYYY)	: 18/03/2015
	Description			: Script to move data to history tables for workitems
						- Reached exit workstep
						- Aborted
						- Discarded
-------------------------------------------------------------------------------------------------
				CHANGE HISTORY
22/05/2017  Kumar Kimil Transfer Data for IBPS(Transaction Tables including Case Management)
22/09/2017      Kumar Kimil     TransferData changes for Ibps3.2
08/11/2017		Ambuj Tripathi	Changes to add URN in TransferData for Case Registration changes.
28/11/2017  Kumar Kimil         Bug 73807 - EAP+Postgres+SSL: Endevent workitem has not been moved in history after executing wftransferdata
22/04/2018  Ambuj Tripathi		Bug 76862 - Remove the db console messages from all procedures
07/01/2019  Shubham Singla		Bug 81610 - in history feature is not working 
30/04/2019      Ravi Ranjan Kumar   PRDP Bug Mergin (Bug 83894 - Support to define explicit History Table for the external table instead of hardcoded '_History')
6/7/2019		Ravi Ranjan Kumar 	Bug 85140 - Enabling to edit workitem (only data and document ) on query workstep if workitem is present on end workstep 
-------------------------------------------------------------------------------------------------*/

	CREATE OR REPLACE FUNCTION WFTransferData (DBRowsToProcess INTEGER DEFAULT 0, v_Days INTEGER DEFAULT 0,v_ProcessDefId          INTEGER DEFAULT 0) returns void as $$
    Declare
	v_queryStr VARCHAR(3000);
	record RECORD;
	v_ProcessDefId					QueueHistoryTable.ProcessDefId%Type;
	v_ProcessName						QueueHistoryTable.ProcessName%Type;
	v_ProcessVersion					QueueHistoryTable.ProcessVersion%Type;
	v_ProcessInstanceId				QueueHistoryTable.ProcessInstanceId%Type;
	v_ProcessInstanceName				QueueHistoryTable.ProcessInstanceName%Type;
	v_ActivityId						QueueHistoryTable.ActivityId%Type;
	v_ActivityName					QueueHistoryTable.ActivityName%Type;
	v_ParentWorkItemId				QueueHistoryTable.ParentWorkItemId%Type;
	v_WorkItemId						QueueHistoryTable.WorkItemId%Type;
	v_ProcessInstanceState			QueueHistoryTable.ProcessInstanceState%Type;
	v_WorkItemState					QueueHistoryTable.WorkItemState%Type;
	v_StateName						QueueHistoryTable.StateName%Type;
	v_QueueName						QueueHistoryTable.QueueName%Type;
	v_QueueType						QueueHistoryTable.QueueType%Type;
	v_AssignedUser					QueueHistoryTable.AssignedUser%Type;
	v_AssignmentType					QueueHistoryTable.AssignmentType%Type;
	v_InstrumentStatus				QueueHistoryTable.InstrumentStatus%Type;
	v_CheckListCompleteFlag			QueueHistoryTable.CheckListCompleteFlag%Type;
	v_IntroductionDateTime			QueueHistoryTable.IntroductionDateTime%Type;
	v_CreatedDateTime					QueueHistoryTable.CreatedDateTime%Type;
	v_IntroducedBy					QueueHistoryTable.IntroducedBy%Type;
	v_CreatedByName					QueueHistoryTable.CreatedByName%Type;
	v_EntryDateTime					QueueHistoryTable.EntryDateTime%Type;
	v_LockStatus						QueueHistoryTable.LockStatus%Type;
	v_HoldStatus						QueueHistoryTable.HoldStatus%Type;
	v_PriorityLevel					QueueHistoryTable.PriorityLevel%Type;
	v_LockedByName					QueueHistoryTable.LockedByName%Type;
	v_LockedTime						QueueHistoryTable.LockedTime%Type;
	v_ValidTill						QueueHistoryTable.ValidTill%Type;
	v_SaveStage						QueueHistoryTable.SaveStage%Type;
	v_PreviousStage					QueueHistoryTable.PreviousStage%Type;
	v_ExpectedWorkItemDelayTime		QueueHistoryTable.ExpectedWorkItemDelayTime%Type;
	v_ExpectedProcessDelayTime		QueueHistoryTable.ExpectedProcessDelayTime%Type;
	v_Status							QueueHistoryTable.Status%Type;
	v_VAR_INT1						QueueHistoryTable.VAR_INT1%Type;
	v_VAR_INT2						QueueHistoryTable.VAR_INT2%Type;
	v_VAR_INT3						QueueHistoryTable.VAR_INT3%Type;
	v_VAR_INT4						QueueHistoryTable.VAR_INT4%Type;
	v_VAR_INT5						QueueHistoryTable.VAR_INT5%Type;
	v_VAR_INT6						QueueHistoryTable.VAR_INT6%Type;
	v_VAR_INT7						QueueHistoryTable.VAR_INT7%Type;
	v_VAR_INT8						QueueHistoryTable.VAR_INT8%Type;
	v_VAR_FLOAT1						QueueHistoryTable.VAR_FLOAT1%Type;
	v_VAR_FLOAT2						QueueHistoryTable.VAR_FLOAT2%Type;
	v_VAR_DATE1						QueueHistoryTable.VAR_DATE1%Type;
	v_VAR_DATE2						QueueHistoryTable.VAR_DATE2%Type;
	v_VAR_DATE3						QueueHistoryTable.VAR_DATE3%Type;
	v_VAR_DATE4						QueueHistoryTable.VAR_DATE4%Type;
	v_VAR_LONG1						QueueHistoryTable.VAR_LONG1%Type;
	v_VAR_LONG2						QueueHistoryTable.VAR_LONG2%Type;
	v_VAR_LONG3						QueueHistoryTable.VAR_LONG3%Type;
	v_VAR_LONG4						QueueHistoryTable.VAR_LONG4%Type;
	v_VAR_STR1				  		QueueHistoryTable.VAR_STR1%Type;
	v_VAR_STR2						QueueHistoryTable.VAR_STR2%Type;
	v_VAR_STR3						QueueHistoryTable.VAR_STR3%Type;
	v_VAR_STR4						QueueHistoryTable.VAR_STR4%Type;
	v_VAR_STR5						QueueHistoryTable.VAR_STR5%Type;
	v_VAR_STR6						QueueHistoryTable.VAR_STR6%Type;
	v_VAR_STR7						QueueHistoryTable.VAR_STR7%Type;
	v_VAR_STR8						QueueHistoryTable.VAR_STR8%Type;
	v_VAR_REC_1						QueueHistoryTable.VAR_REC_1%Type;
	v_VAR_REC_2						QueueHistoryTable.VAR_REC_2%Type;
	v_VAR_REC_3						QueueHistoryTable.VAR_REC_3%Type;
	v_VAR_REC_4						QueueHistoryTable.VAR_REC_4%Type;
	v_VAR_REC_5						QueueHistoryTable.VAR_REC_5%Type;
	v_Q_StreamId						QueueHistoryTable.Q_StreamId%Type;
	v_Q_QueueId						QueueHistoryTable.Q_QueueId%Type;
	v_Q_UserID						QueueHistoryTable.Q_UserID%Type;
	v_LastProcessedBy					QueueHistoryTable.LastProcessedBy%Type;
	v_ProcessedBy						QueueHistoryTable.ProcessedBy%Type;
	v_ReferredTo						QueueHistoryTable.ReferredTo%Type;
	v_ReferredToName					QueueHistoryTable.ReferredToName%Type;
	v_ReferredBy						QueueHistoryTable.ReferredBy%Type;
	v_ReferredByName					QueueHistoryTable.ReferredByName%Type;
	v_CollectFlag						QueueHistoryTable.CollectFlag%Type;
	v_CompletionDateTime				QueueHistoryTable.CompletionDateTime%Type;
	v_URN								QueueHistoryTable.URN%Type;
	v_ACTIVITYTYPE						QueueHistoryTable.ACTIVITYTYPE%Type;
	v_ProcessingTime					QueueHistoryTable.ProcessingTime%Type;
	resultset						REFCURSOR;
	transfer_cursor		            REFCURSOR;
	v_batchSize						INTEGER;
	v_rowCounter					INTEGER;
	v_newCab						VARCHAR(4);
	HistoryTableName				VARCHAR(22);
	CurrentTableName				VARCHAR(22); 
	dt varchar(8000);
	v_ExtTableString	VARCHAR(3000);
	v_ExtTableHistoryString	 VARCHAR(3000);
	var_extTableName	VARCHAR(300);
	var_extTableName_HISTORY VARCHAR(300);
	v_pos1				INTEGER;
	v_pos2				INTEGER;
	
	var_ProcessDefId	INTEGER;
	
	v_RowsFetched       INTEGER;
	var_VAR_REC_1		VARCHAR(510);
	var_VAR_REC_2		VARCHAR(10);
	v_queryStr1			VARCHAR(1000);
	v_actionId			INTEGER;
	v_queryStr2			VARCHAR(1000);
	v_rowPresent		INTEGER; 
	v_rowProcessStr		VARCHAR(200);
	v_conditionStr		VARCHAR(200);
	
	v_ChildProcessInstanceId VARCHAR(63);
	v_ChildWorkitemId INTEGER;
	v_ExportStatus VARCHAR(1);
	v_FilterValue INTEGER;
	v_Guid BigInt;
	v_IsPrimaryCollected VARCHAR(1);
	v_NoOfCollectedInstances INTEGER;
	v_NotifyStatus  VARCHAR(1);
	v_ProcessVariantId INTEGER;
	v_Q_DivertedByUserId INTEGER;
	v_RoutingStatus VARCHAR(1);
	v_VAR_DATE5 TIMESTAMP;
	v_VAR_DATE6 TIMESTAMP;
	v_VAR_LONG5 INTEGER;
	v_VAR_LONG6 INTEGER;
	v_VAR_STR9  VARCHAR(512);
	v_VAR_STR10 VARCHAR(512);
	v_VAR_STR11 VARCHAR(512);
	v_VAR_STR12 VARCHAR(512);
	v_VAR_STR13 VARCHAR(512);
	v_VAR_STR14 VARCHAR(512);
	v_VAR_STR15 VARCHAR(512);
	v_VAR_STR16 VARCHAR(512);
	v_VAR_STR17 VARCHAR(512);
	v_VAR_STR18 VARCHAR(512);
	v_VAR_STR19 VARCHAR(512);
	v_VAR_STR20 VARCHAR(512);
	v_TransferHistoryData VARCHAR(1);
	v_Introducedbyid				INTEGER		 ;
	v_IntroducedAt				VARCHAR(30);	
	v_Createdby					INTEGER	;
	existsFlag 			INTEGER;

	BEGIN
	--Raise Notice 'Execution Begins';
	v_rowCounter := 0;
	v_TransferHistoryData:='Y';
	v_rowProcessStr := '';
	existsFlag :=0;
	IF (DBRowsToProcess > 0 AND DBRowsToProcess < 100) THEN
		v_rowProcessStr := v_rowProcessStr || ' LIMIT ' ||TO_CHAR(DBRowsToProcess,'99');
	ELSE
		v_rowProcessStr := v_rowProcessStr || ' LIMIT 100';	
	END IF;
	v_conditionStr := '';
	IF(v_Days > 0) THEN
	v_conditionStr := v_conditionStr || ' AND ENTRYDATETIME < (CURRENT_TIMESTAMP - '|| v_Days||'* interval ''1 day'')';
	
	END IF;
	
	IF(v_ProcessDefId > 0) THEN
	v_conditionStr := v_conditionStr || ' AND ProcessDefId =  '|| v_ProcessDefId;
	
	END IF;
	
	dt := '';


      v_newCab :='Y';   
      CurrentTableName :='WFCURRENTROUTELOGTABLE';
      HistoryTableName :='WFHISTORYROUTELOGTABLE';
      --RAISE NOTICE 'WFCurrentRouteLogTable is being used in the cabinet........'; 
	--RAISE NOTICE 'v_newCab........%',v_newCab ;
   	v_queryStr := 
		'SELECT ProcessDefId, ProcessName, ProcessVersion, ProcessInstanceId, ProcessInstanceId,' ||
		' ActivityId, ActivityName, ParentWorkItemId, WorkItemId, ProcessInstanceState, WorkItemState,' ||
		' StateName, QueueName, QueueType, AssignedUser, AssignmentType,' ||
		' InstrumentStatus, CheckListCompleteFlag, IntroductionDateTime, CreatedDateTime, IntroducedBy,' ||
		' CreatedByName, EntryDateTime, LockStatus, HoldStatus, PriorityLevel,' ||
		' LockedByName, LockedTime, ValidTill, SaveStage, PreviousStage,' ||
		' ExpectedWorkItemDelay, ExpectedProcessDelay, Status, VAR_INT1, VAR_INT2,' ||
		' VAR_INT3, VAR_INT4, VAR_INT5, VAR_INT6, VAR_INT7,' ||
		' VAR_INT8, VAR_FLOAT1, VAR_FLOAT2, VAR_DATE1, VAR_DATE2,' ||
		' VAR_DATE3, VAR_DATE4, VAR_LONG1, VAR_LONG2, VAR_LONG3,' ||
		' VAR_LONG4, VAR_STR1, VAR_STR2, VAR_STR3, VAR_STR4,' ||
		' VAR_STR5, VAR_STR6, VAR_STR7, VAR_STR8, VAR_REC_1,' ||
		' VAR_REC_2, VAR_REC_3, VAR_REC_4, VAR_REC_5, Q_StreamId,' ||
		' Q_QueueId, Q_UserID, LastProcessedBy, ProcessedBy, ReferredTo,' ||
		' ReferredToName, ReferredBy, ReferredByName, CollectFlag, NULL,' ||
        'ChildProcessInstanceId,ChildWorkitemId,ExportStatus,FilterValue,Guid,'||
		'IsPrimaryCollected,NoOfCollectedInstances,NotifyStatus,ProcessVariantId,Q_DivertedByUserId ,'||
		'RoutingStatus,VAR_DATE5,VAR_DATE6,VAR_LONG5,VAR_LONG6,VAR_STR9,VAR_STR10,VAR_STR11,'||
		'VAR_STR12,VAR_STR13,VAR_STR14,VAR_STR15,VAR_STR16,VAR_STR17,VAR_STR18,VAR_STR19,VAR_STR20,Introducedbyid,IntroducedAt,Createdby,URN , ACTIVITYTYPE,ProcessingTime '||
		' FROM WFInstrumentTable ' ||
		' WHERE WorkItemId = 1 ' ||
		' AND ProcessInstanceState IN (4,5,6)' || v_conditionStr ||
		v_rowProcessStr;
		
		--RAISE NOTICE 'v_queryStr=%',v_queryStr;
	WHILE ((DBRowsToProcess > 0 AND v_rowCounter < DBRowsToProcess) OR (DBRowsToProcess = 0 AND 1 = 1)) 
	LOOP
		OPEN  resultset FOR EXECUTE v_queryStr;
		v_rowPresent := 0;
		LOOP
			v_actionId := 1;
			FETCH resultset INTO v_ProcessDefId,v_ProcessName,v_ProcessVersion,v_ProcessInstanceId,v_ProcessInstanceName,v_ActivityId,v_ActivityName,v_ParentWorkItemId,v_WorkItemId,v_ProcessInstanceState,v_WorkItemState,v_StateName,v_QueueName,v_QueueType,v_AssignedUser,v_AssignmentType,v_InstrumentStatus,v_CheckListCompleteFlag,v_IntroductionDateTime,v_CreatedDateTime,v_IntroducedBy,v_CreatedByName,v_EntryDateTime,v_LockStatus,v_HoldStatus,v_PriorityLevel,v_LockedByName,v_LockedTime,v_ValidTill,v_SaveStage,v_PreviousStage,v_ExpectedWorkItemDelayTime,v_ExpectedProcessDelayTime,v_Status,v_VAR_INT1,v_VAR_INT2,v_VAR_INT3,v_VAR_INT4,v_VAR_INT5,v_VAR_INT6,v_VAR_INT7,v_VAR_INT8,v_VAR_FLOAT1,v_VAR_FLOAT2,v_VAR_DATE1,v_VAR_DATE2,v_VAR_DATE3,v_VAR_DATE4,v_VAR_LONG1,v_VAR_LONG2,v_VAR_LONG3,v_VAR_LONG4,v_VAR_STR1,v_VAR_STR2,v_VAR_STR3,v_VAR_STR4,v_VAR_STR5,v_VAR_STR6,v_VAR_STR7,v_VAR_STR8,v_VAR_REC_1,v_VAR_REC_2,v_VAR_REC_3,v_VAR_REC_4,v_VAR_REC_5,v_Q_StreamId,v_Q_QueueId,v_Q_UserID,v_LastProcessedBy,v_ProcessedBy,v_ReferredTo,v_ReferredToName,v_ReferredBy,v_ReferredByName,v_CollectFlag,v_CompletionDateTime,v_ChildProcessInstanceId,v_ChildWorkitemId,v_ExportStatus,v_FilterValue,v_Guid,v_IsPrimaryCollected,v_NoOfCollectedInstances,v_NotifyStatus,v_ProcessVariantId,v_Q_DivertedByUserId ,v_RoutingStatus,v_VAR_DATE5,v_VAR_DATE6,v_VAR_LONG5,v_VAR_LONG6,v_VAR_STR9,v_VAR_STR10,v_VAR_STR11,v_VAR_STR12,v_VAR_STR13,v_VAR_STR14,v_VAR_STR15,v_VAR_STR16,v_VAR_STR17,v_VAR_STR18,v_VAR_STR19,v_VAR_STR20,v_Introducedbyid,v_IntroducedAt,v_Createdby,v_URN, v_ACTIVITYTYPE, v_ProcessingTime;
			IF (NOT FOUND) THEN
			--RAISE NOTICE 'No Result set found';
            EXIT;
            END IF;
			
				IF v_actionId = 1 THEN
				v_rowPresent := 1;
				Insert Into QueueHistoryTable(
					ProcessDefId, ProcessName, ProcessVersion, ProcessInstanceId, ProcessInstanceName, 
					ActivityId, ActivityName, ParentWorkItemId, WorkItemId, ProcessInstanceState, 
					WorkItemState, StateName, QueueName, QueueType, AssignedUser, 
					AssignmentType, InstrumentStatus, CheckListCompleteFlag, IntroductionDateTime, CreatedDateTime, 
					IntroducedBy, CreatedByName, EntryDateTime, LockStatus, HoldStatus, 
					PriorityLevel, LockedByName, LockedTime, ValidTill, SaveStage, 
					PreviousStage, ExpectedWorkItemDelayTime, ExpectedProcessDelayTime, Status, VAR_INT1, 
					VAR_INT2, VAR_INT3, VAR_INT4, VAR_INT5, VAR_INT6, 
					VAR_INT7, VAR_INT8, VAR_FLOAT1, VAR_FLOAT2, VAR_DATE1, 
					VAR_DATE2, VAR_DATE3, VAR_DATE4, VAR_LONG1, VAR_LONG2, 
					VAR_LONG3, VAR_LONG4, VAR_STR1, VAR_STR2, VAR_STR3, 
					VAR_STR4, VAR_STR5, VAR_STR6, VAR_STR7, VAR_STR8,
					VAR_REC_1, VAR_REC_2, VAR_REC_3, VAR_REC_4,	VAR_REC_5,
					Q_StreamId, Q_QueueId, Q_UserID, LastProcessedBy, ProcessedBy, 
					ReferredTo, ReferredToName, ReferredBy, ReferredByName, CollectFlag, 
					CompletionDateTime,ChildProcessInstanceId,ChildWorkitemId,ExportStatus,FilterValue,Guid,
					IsPrimaryCollected,NoOfCollectedInstances,NotifyStatus,ProcessVariantId,Q_DivertedByUserId ,
					RoutingStatus,VAR_DATE5,VAR_DATE6,VAR_LONG5,VAR_LONG6,VAR_STR9,VAR_STR10,VAR_STR11,
					VAR_STR12,VAR_STR13,VAR_STR14,VAR_STR15,VAR_STR16,VAR_STR17,VAR_STR18,VAR_STR19,VAR_STR20,Introducedbyid,IntroducedAt,Createdby,URN , ACTIVITYTYPE,ProcessingTime
				) VALUES (v_ProcessDefId,v_ProcessName,v_ProcessVersion,v_ProcessInstanceId,v_ProcessInstanceName,v_ActivityId,v_ActivityName,v_ParentWorkItemId,v_WorkItemId,v_ProcessInstanceState,v_WorkItemState,v_StateName,v_QueueName,v_QueueType,v_AssignedUser,v_AssignmentType,v_InstrumentStatus,v_CheckListCompleteFlag,v_IntroductionDateTime,v_CreatedDateTime,v_IntroducedBy,v_CreatedByName,v_EntryDateTime,v_LockStatus,v_HoldStatus,v_PriorityLevel,v_LockedByName,v_LockedTime,v_ValidTill,v_SaveStage,v_PreviousStage,v_ExpectedWorkItemDelayTime,v_ExpectedProcessDelayTime,v_Status,v_VAR_INT1,v_VAR_INT2,v_VAR_INT3,v_VAR_INT4,v_VAR_INT5,v_VAR_INT6,v_VAR_INT7,v_VAR_INT8,v_VAR_FLOAT1,v_VAR_FLOAT2,v_VAR_DATE1,v_VAR_DATE2,v_VAR_DATE3,v_VAR_DATE4,v_VAR_LONG1,v_VAR_LONG2,v_VAR_LONG3,v_VAR_LONG4,v_VAR_STR1,v_VAR_STR2,v_VAR_STR3,v_VAR_STR4,v_VAR_STR5,v_VAR_STR6,v_VAR_STR7,v_VAR_STR8,v_VAR_REC_1,v_VAR_REC_2,v_VAR_REC_3,v_VAR_REC_4,v_VAR_REC_5,v_Q_StreamId,v_Q_QueueId,v_Q_UserID,v_LastProcessedBy,v_ProcessedBy,v_ReferredTo,v_ReferredToName,v_ReferredBy,v_ReferredByName,v_CollectFlag,NULL,
				v_ChildProcessInstanceId,v_ChildWorkitemId,v_ExportStatus,v_FilterValue,v_Guid,v_IsPrimaryCollected,v_NoOfCollectedInstances,v_NotifyStatus,v_ProcessVariantId,v_Q_DivertedByUserId ,v_RoutingStatus,v_VAR_DATE5,v_VAR_DATE6,v_VAR_LONG5,v_VAR_LONG6,v_VAR_STR9,v_VAR_STR10,v_VAR_STR11,v_VAR_STR12,v_VAR_STR13,v_VAR_STR14,v_VAR_STR15,v_VAR_STR16,v_VAR_STR17,v_VAR_STR18,v_VAR_STR19,v_VAR_STR20,v_Introducedbyid,v_IntroducedAt,v_Createdby,v_URN ,v_ACTIVITYTYPE,v_ProcessingTime
				);

				DELETE FROM WFInstrumentTable WHERE ProcessInstanceId = v_ProcessInstanceId;
				--RAISE NOTICE 'WFInstrumentTable deleted QueueHistoryTable inserted';
				INSERT INTO EXCEPTIONHISTORYTABLE
					SELECT ProcessDefId, ExcpSeqId, WorkitemId, Activityid, ActivityName, 
							ProcessInstanceId, UserId, UserName, ActionId, ActionDateTime, ExceptionId,
							ExceptionName, FinalizationStatus, ExceptionComments
					FROM EXCEPTIONTABLE
					WHERE EXCEPTIONTABLE.ProcessInstanceId = v_ProcessInstanceId;
				
				DELETE from EXCEPTIONTABLE where ProcessInstanceId = v_ProcessInstanceId;
				--RAISE NOTICE 'EXCEPTIONTABLE deleted EXCEPTIONHISTORYTABLE inserted';
				INSERT INTO TODOSTATUSHISTORYTABLE
					SELECT ProcessDefId, ProcessInstanceId, ToDoValue
					FROM TODOSTATUSTABLE
					WHERE TODOSTATUSTABLE.ProcessInstanceId = v_ProcessInstanceId;
				
				DELETE from TODOSTATUSTABLE where ProcessInstanceId = v_ProcessInstanceId;   
				--RAISE NOTICE 'TODOSTATUSTABLE deleted TODOSTATUSHISTORYTABLE inserted';
                IF v_newCab = 'Y' THEN
                dt := 'INSERT INTO '||HistoryTableName||' SELECT LogId, ProcessDefId, ActivityId, ProcessInstanceId, WorkItemId, UserId, ActionId, ActionDateTime, AssociatedFieldId, AssociatedFieldName, ActivityName, UserName, NewValue, AssociatedDateTime, QueueID, ProcessVariantId, TaskId, SubTaskId, URN,ProcessingTime,TAT,DelayTime FROM '||CurrentTableName||' WHERE ProcessInstanceId = '||chr(39)|| v_ProcessInstanceId||CHR(39);
				--RAISE NOTICE 'Query : %',dt;
				END IF;
                EXECUTE dt;
                dt := 'DELETE from '||CurrentTableName||' where ProcessInstanceId ='||chr(39)||v_ProcessInstanceId||chr(39);
                EXECUTE dt;
				IF v_TransferHistoryData = 'Y' THEN 
				--RAISE NOTICE 'ProcessDefId===%',v_ProcessDefId;
					v_queryStr1 := 'SELECT TABLENAME ,HISTORYTABLENAME FROM EXTDBCONFTABLE where extobjid = 1 and ProcessDefId='||v_ProcessDefId;
					OPEN transfer_cursor FOR EXECUTE v_QueryStr1;
					LOOP
					FETCH transfer_cursor INTO  var_extTableName, var_extTableName_HISTORY;
					IF(NOT FOUND) THEN
							EXIT;
					END IF;
					v_ExtTableString := var_extTableName;
					 END LOOP;
					 CLOSE transfer_cursor;
					 --RAISE NOTICE 'v_ExtTableString selected ';
					
					
					PERFORM 1 FROM PG_TABLES  
					WHERE UPPER(TABLENAME) = UPPER(v_ExtTableString||'_History');
					IF(FOUND) THEN 
						v_ExtTableHistoryString := v_ExtTableString ||'_History';
						existsFlag :=1;
					ELSE
						PERFORM 1 FROM PG_TABLES  WHERE UPPER(TABLENAME) = UPPER(v_ExtTableString||'_History');
						IF(FOUND) THEN 
							v_ExtTableHistoryString := var_extTableName_HISTORY ;
							existsFlag :=1;
						END IF;
					END IF;
					
					IF(existsFlag = 1) THEN 
					--RAISE NOTICE 'External History table History %',v_ExtTableString||'_History';
					v_VAR_REC_1:=chr(39)||v_VAR_REC_1||chr(39);
					v_VAR_REC_2:=chr(39)||v_VAR_REC_2||chr(39);
					v_queryStr1:='INSERT INTO '||var_extTableName_HISTORY||' SELECT * from '||v_ExtTableString||' WHERE ITEMINDEX = N' || v_VAR_REC_1 || ' AND ITEMTYPE = N' || v_VAR_REC_2 ;
					--RAISE NOTICE 'External Hist Insert query=%',v_QueryStr1;
					EXECUTE v_QueryStr1;
					
					v_QueryStr1:='DELETE FROM '||v_ExtTableString||' WHERE ItemIndex = N'||v_VAR_REC_1||' AND ITEMTYPE = N'||v_VAR_REC_2;
					--RAISE NOTICE 'External Delete query=%',v_QueryStr1;
					EXECUTE v_QueryStr1;
					--RAISE NOTICE 'v_ExtTableString deleted v_ExtTableString_history inserted';
					END IF;
					--RAISE NOTICE 'v_ExtTableString_history inserted222222';
					
					
				
				END IF;
				
				INSERT INTO WFREPORTDATAHISTORYTABLE SELECT ProcessInstanceId, WorkitemId, ProcessDefId, Activityid, UserId, TotalProcessingTime,ProcessVariantId FROM WFREPORTDATATABLE WHERE WFREPORTDATATABLE.ProcessInstanceId = v_ProcessInstanceId;
				
				DELETE from WFREPORTDATATABLE where ProcessInstanceId = v_ProcessInstanceId;
				--RAISE NOTICE 'WFREPORTDATAHISTORYTABLE inserted';
				INSERT INTO WFCommentsHistoryTable(ProcessDefId, ActivityId, ProcessInstanceId, WorkItemId, CommentsBy, CommentsByName, CommentsTo, CommentsToName, Comments, ActionDateTime, CommentsType,ProcessVariantId) SELECT ProcessDefId, ActivityId, ProcessInstanceId, WorkItemId, CommentsBy, CommentsByName, CommentsTo, CommentsToName, Comments, ActionDateTime, CommentsType,ProcessVariantId FROM WFCommentsTable WHERE ProcessInstanceId = v_ProcessInstanceId;
				
				DELETE FROM WFCommentsTable WHERE ProcessInstanceId = v_ProcessInstanceId ;
				--RAISE NOTICE 'WFCommentsHistoryTable inserted';
				INSERT INTO WFtaskstatusHistorytable SELECT ProcessInstanceId,WorkItemId,ProcessDefId,ActivityId,TaskId,SubTaskId,TaskStatus,AssignedBy,AssignedTo,Instructions,ActionDateTime,DueDate,Priority,ShowCaseVisual,ReadFlag,CanInitiate,Q_DivertedByUserId FROM WFtaskstatustable WHERE ProcessInstanceId = v_ProcessInstanceId;
				
				DELETE FROM WFtaskstatustable WHERE ProcessInstanceId = v_ProcessInstanceId;
				--RAISE NOTICE 'WFtaskstatusHistorytable inserted';
				INSERT INTO WFRTTASKINTFCASSOCHISTORY SELECT ProcessInstanceId,WorkItemId,ProcessDefId,ActivityId,TaskId,InterfaceId,InterfaceType,Attribute FROM WFRTTaskInterfaceAssocTable WHERE ProcessInstanceId = v_ProcessInstanceId;
				
				DELETE FROM WFRTTaskInterfaceAssocTable WHERE ProcessInstanceId = v_ProcessInstanceId;
				--RAISE NOTICE 'WFRTTASKINTFCASSOCHISTORY inserted';
				INSERT INTO RTACTIVITYINTFCASSOCHISTORY SELECT ProcessInstanceId,WorkItemId,ProcessDefId,ActivityId,ActivityName,InterfaceElementId,InterfaceType,Attribute,TriggerName,ProcessVariantId FROM RTACTIVITYINTERFACEASSOCTABLE WHERE ProcessInstanceId = v_ProcessInstanceId;
				
				DELETE FROM RTACTIVITYINTERFACEASSOCTABLE WHERE ProcessInstanceId = v_ProcessInstanceId;
				--RAISE NOTICE 'RTACTIVITYINTFCASSOCHISTORY inserted';
				INSERT INTO WFATTRIBUTEMESSAGEHISTORYTABLE(ProcessDefId,ProcessVariantId, ProcessInstanceId, WorkItemId,MessageId,Message,LockedBy,Status,ActionDateTime) SELECT  ProcessDefId,ProcessVariantId, ProcessInstanceId, WorkItemId,MessageId,Message,LockedBy,Status,ActionDateTime FROM WFATTRIBUTEMESSAGETABLE WHERE ProcessInstanceId = v_ProcessInstanceId;
				
				DELETE FROM WFATTRIBUTEMESSAGETABLE WHERE ProcessInstanceId = v_ProcessInstanceId;
				--RAISE NOTICE 'WFATTRIBUTEMESSAGEHISTORYTABLE inserted';
				
				--IBPS 3.2 release changes start
				INSERT INTO WFCaseSummaryDetailsHistory(ProcessInstanceId,WorkItemId, ProcessDefId, ActivityId,ActivityName,Status,NoOfRetries,EntryDateTime,LockedBy) SELECT  ProcessInstanceId,WorkItemId, ProcessDefId, ActivityId,ActivityName,Status,NoOfRetries,EntryDateTime,LockedBy FROM WFCaseSummaryDetailsTable WHERE WFCaseSummaryDetailsTable.ProcessInstanceId =  v_ProcessInstanceId;
				DELETE FROM WFCaseSummaryDetailsTable WHERE ProcessInstanceId =  v_ProcessInstanceId;
				--RAISE NOTICE 'WFCaseSummaryDetailsHistory inserted';
				INSERT INTO WFCaseDocStatusHistory(ProcessInstanceId,WorkItemId, ProcessDefId, ActivityId,TaskId,SubTaskId,DocumentType,DocumentIndex,ISIndex,CompleteStatus) SELECT  ProcessInstanceId,WorkItemId, ProcessDefId, ActivityId,TaskId,SubTaskId,DocumentType,DocumentIndex,ISIndex,CompleteStatus FROM WFCaseDocStatusTable where WFCaseDocStatusTable.ProcessInstanceId =  v_ProcessInstanceId;
				DELETE FROM WFCaseDocStatusTable WHERE ProcessInstanceId =  v_ProcessInstanceId;
				--RAISE NOTICE 'WFCaseDocStatusHistory inserted';
				INSERT INTO WFTaskPreCondResultHistory(ProcessInstanceId,WorkItemId, ActivityId, TaskId,Ready,Mandatory) SELECT  ProcessInstanceId,WorkItemId, ActivityId, TaskId,Ready,Mandatory FROM WFTaskPreConditionResultTable
				WHERE WFTaskPreConditionResultTable.ProcessInstanceId =  v_ProcessInstanceId;
				
				DELETE FROM WFTaskPreConditionResultTable WHERE ProcessInstanceId =  v_ProcessInstanceId;
				--RAISE NOTICE 'WFTaskPreCondResultHistory inserted';
				INSERT INTO WFTaskPreCheckHistory(ProcessInstanceId, WorkItemId,ActivityId,checkPreCondition) SELECT  ProcessInstanceId, WorkItemId,ActivityId,checkPreCondition FROM WFTaskPreCheckTable
				WHERE WFTaskPreCheckTable.ProcessInstanceId =  v_ProcessInstanceId;
				
				DELETE FROM WFTaskPreCheckTable WHERE ProcessInstanceId = v_ProcessInstanceId;
				--IBPS 3.2 release changes end
				--RAISE NOTICE 'WFTaskPreCheckHistory inserted';
				EXECUTE 'INSERT INTO SuccessLogTable Values (0,'||chr(39)||v_ProcessInstanceId||chr(39)|| ')'; 
				--RAISE NOTICE 'SuccessLogTable inserted';
				v_rowCounter := v_rowCounter + 1;
			
				END IF;
			
				IF (NOT FOUND) THEN 
					EXECUTE 'INSERT INTO FailureLogTable Values (0, '||chr(39)||v_ProcessInstanceId||chr(39)||')';
					--RAISE NOTICE 'FailureLogTable inserted';					
				END IF;
				--RAISE NOTICE 'End of all insert';
		END LOOP;
		CLOSE resultset;
		IF (v_rowPresent = 0) THEN
			--RAISE NOTICE 'Exiting........'; 
			EXIT;
		END IF;
		IF (NOT FOUND) THEN 
		
			RAISE NOTICE 'Check!! Check!! An Exception occurred while execution of Stored Procedure WFTransferData........'; 
			
		
		END IF;
	END LOOP;
	RAISE NOTICE 'Procedure compiled succesfully'; 
END;

$$LANGUAGE plpgsql;