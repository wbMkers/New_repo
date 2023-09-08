CREATE PROCEDURE WFLockWorkItem(
		DBSessionId			INT,
		DBQueueId			INT,
		DBSortOrder			CHAR(1),
		DBOrderBy			INT,
		DBBatchSize			INT,
		DBLastWorkItem			INT,
		DBLastProcessInstance		VARGRAPHIC(63),
		DBLastValue			VARGRAPHIC(63),
		DBUserFilterStr			VARGRAPHIC(500),
		DBConCode                       INT
)

dynamic result sets 3
language sql
P1: BEGIN

declare v_lockedById			INT;
declare v_filterOption			INT;
declare v_WF_EQUAL			INT;
declare v_WF_NOTEQ			INT;
declare v_cnt				INT;
declare v_totalNoOfRec			INT;
declare v_workItemId			INT;
declare v_toBeFetched			INT;
declare v_rowCount			INT;	
declare v_MainCode			INT;
declare v_SubCode			INT;
declare v_NoOfRecordsFetched            INT;
declare v_TotalNoOfRecords              INT;
declare v_fetchStatus                   INT             DEFAULT 0;
declare SQLCODE				INT             DEFAULT 0;
declare v_op				CHAR(1);
declare v_quoteChar 			CHAR(1);

declare v_fetchSize			VARCHAR(3);
declare v_tempTable                     VARCHAR(512);
declare v_QueryStr			VARCHAR(1024);

declare v_sortStr			VARGRAPHIC(6);
declare v_sortFieldStr			VARGRAPHIC(50);
declare v_filterValue			VARGRAPHIC(63);
declare v_lockedByName			VARGRAPHIC(63);
declare v_processInstanceId		VARGRAPHIC(63);
declare v_filterStr			VARGRAPHIC(300);
declare v_queueFilterStr		VARGRAPHIC(300);
declare v_lastValueStr			VARGRAPHIC(1000);
declare v_orderByStr			VARGRAPHIC(1000);

declare cur_Stmt                        STATEMENT;
declare ref_Stmt                        STATEMENT;
declare drop_stmt                       STATEMENT;
declare create_stmt                     STATEMENT;

declare ret_cursor cursor with return for select v_MainCode as MainCode, v_SubCode as SubCode , v_NoOfRecordsFetched as NoOfRecordsFetched, v_TotalNoOfRecords as TotalNoOfRecords from sysibm.sysdummy1;
declare WorkItem_cur cursor with return for cur_Stmt;
declare RefCursor cursor with return for ref_Stmt;

set v_WF_EQUAL = 2;
set v_WF_NOTEQ = 3;
set v_quoteChar = Chr(39);
set v_queueFilterStr = N'';
set v_fetchSize = '';
set v_orderByStr = N'';
set v_filterValue = N'';
set v_filterStr = N'';
set v_queueFilterStr = N'';
set v_lastValueStr = N'';
set v_sortFieldStr = N'';
set v_tempTable = 'TEMPTABLE'||char(DBConCode);         ---concode

if exists(
        select name from sysibm.systables where name = UPPER(LTRIM(RTRIM(v_tempTable)))
)then
        set v_QueryStr = 'drop table ' || UPPER(LTRIM(RTRIM(v_tempTable)));
        prepare drop_stmt from v_QueryStr;
        execute drop_stmt;
end if;
commit;

set v_QueryStr = 'create Table ' || UPPER(LTRIM(RTRIM(v_tempTable))) ||'(processInstanceId VARGRAPHIC(63), workItemId INT)';
prepare create_stmt from v_QueryStr;
execute create_stmt;
commit;

if(DBBatchSize <= 0)
then
        set v_MainCode = 18;       --- batch size 0
	set v_SubCode = 0;
	set v_NoOfRecordsFetched = 0;
	set v_TotalNoOfRecords = 0;
	open ret_cursor;
	return;
end if;

select  UserID ,UserName into v_lockedById ,v_lockedByName From WFSessionView, WFUserView Where UserId = UserIndex And SessionID = DBSessionId;
if(SQLCODE = 100)
then
        set v_MainCode = 11; --not a valid session
	set v_SubCode = 0;
	set v_NoOfRecordsFetched = 0;
	set v_TotalNoOfRecords = 0;
	open ret_cursor;
	return;
end if;
	
if(DBQueueId > 0)
then
        set v_queueFilterStr = N' And q_queueId = '|| char(DBqueueId);
        if not exists(
	        Select * from QUserGroupView where QueueId = DBQueueId and UserId = v_lockedById
	)
	then
	        set v_MainCode = 18;
		set v_SubCode = 810;
		set v_NoOfRecordsFetched = 0;
		set v_TotalNoOfRecords = 0;
		open ret_cursor;
		return;
	end if;
	select filterOption , filterValue into v_filterOption , v_filterValue from QueueDeftable where QueueID = DBQueueId;
	if(SQLCODE = 0)
	then
	        if(v_filterOption = v_WF_EQUAL)
		then
		        set v_filterStr = N' And ' || v_filterValue || N' = ' || char(v_lockedById);
		elseif(v_filterOption = v_WF_NOTEQ)
		then
			set v_filterStr = N' And ' || v_filterValue || N' != ' || char(v_lockedById);
		end if;			
	end if;
end if;

if(UPPER(RTRIM(LTRIM(DBSortOrder))) = 'D')
then
	set v_sortStr = N' DESC ';
	set v_op = '<';
else
	set v_sortStr = N' ASC ';
	set v_op = '>';
end if;

set  v_sortFieldStr = N' PriorityLevel ';
	
if(DBOrderBy = 1)
then
	set v_lastValueStr = DBLastValue;
	set v_sortFieldStr = N' PriorityLevel ';
elseif(DBOrderBy = 2)
then
	if(length(DBLastValue) > 0)
	then
	        set v_lastValueStr = v_quoteChar || DBLastValue || v_quoteChar;
	end if;
        set v_sortFieldStr = N' ProcessInstanceId ';
elseif(DBOrderBy = 3)
then
	if(length(DBLastValue) > 0)
	then
		set v_lastValueStr = v_quoteChar || DBLastValue || v_quoteChar;
	end if;
        set v_sortFieldStr = N' ActivityName ';
elseif(DBOrderBy = 4)
then
	if(length(DBLastValue) > 0)
	then
		set v_lastValueStr = v_quoteChar || DBLastValue || v_quoteChar;
	end if;
        set v_sortFieldStr = N' LockedByName ';
elseif(DBOrderBy = 5)
then
        if(length(DBLastValue) > 0)
        then
	        set v_lastValueStr = v_quoteChar || DBLastValue || v_quoteChar;
	end if;
        set v_sortFieldStr = N' IntroducedBy ';
elseif(DBOrderBy = 6)
then
        if(length(DBLastValue) > 0)
	then
	        set v_lastValueStr = v_quoteChar || DBLastValue || v_quoteChar;
        end if;	
        set v_sortFieldStr = N' InstrumentStatus ';
elseif(DBOrderBy = 7)
then
        if(length(DBLastValue) > 0)
	then
		set v_lastValueStr = v_quoteChar || DBLastValue || v_quoteChar;
        end if;
        set v_sortFieldStr = N' CheckListCompleteFlag ';
elseif(DBOrderBy = 8)
then
	if(length(DBLastValue) > 0)
	then
		set v_lastValueStr = v_quoteChar || DBLastValue || v_quoteChar;
        end if;
        set v_sortFieldStr = N' LockStatus ';
elseif(DBOrderBy = 9)
then
	if(length(DBLastValue) > 0)
	then
		set v_lastValueStr = DBLastValue;
        end if;
        set v_sortFieldStr = N' WorkItemState ';
elseif(DBOrderBy = 10)
then
	if(length(DBLastValue) > 0)
	then
		set v_lastValueStr = v_quoteChar || DBLastValue || v_quoteChar;
	end if;
        set v_sortFieldStr = N' EntryDateTime ';
elseif(DBOrderBy = 11)
then
	if(length(DBLastValue) > 0)
	then
		set v_lastValueStr = v_quoteChar || DBLastValue || v_quoteChar;
	end if;
        set v_sortFieldStr = N' ValidTill ';
elseif(DBOrderBy = 12)
then
	if(length(DBLastValue) > 0)
	then
		set v_lastValueStr = v_quoteChar || DBLastValue || v_quoteChar;
	end if;
        set v_sortFieldStr = N' LockedTime ';
elseif(DBOrderBy = 13)
then
	if(length(DBLastValue) > 0)
	then
		set v_lastValueStr = v_quoteChar || DBLastValue || v_quoteChar;
	end if;	
        set v_sortFieldStr = N' IntroductionDateTime ';
elseif(DBOrderBy = 17)
then
	if(length(DBLastValue) > 0)	
	then
		set v_lastValueStr = v_quoteChar || DBLastValue || v_quoteChar;		
	end if;
        set v_sortFieldStr = N' Status ';
elseif(DBOrderBy = 18)
then
	if(length(DBLastValue) > 0)
	then
		set v_lastValueStr = v_quoteChar || DBLastValue || v_quoteChar;
	end if;
        set v_sortFieldStr = N' CreatedDateTime ';
end if;

set v_cnt = 0;
set v_totalNoOfRec = 0;

if(DBOrderBy = 2)
then
        set v_orderByStr = N' ORDER BY ProcessInstanceID ' || v_sortStr || N', WorkItemID ' || v_sortStr;	
else
        set v_orderByStr = N' ORDER BY ' || v_sortFieldStr || v_sortStr || N', ProcessInstanceID ' || v_sortStr
		        || N', WorkItemID ' || v_sortStr;
end if;

if(length(DBLastProcessInstance) > 0)
then
        if(length(DBLastValue) > 0)
        then
	        set v_orderByStr = N' AND ( ( UPPER(LTRIM(RTRIM(' || v_sortFieldStr || N'))) = ' ||
					UPPER(LTRIM(RTRIM(v_lastValueStr))) ||
					N' AND UPPER(LTRIM(RTRIM(ProcessInstanceID))) = ' || v_quoteChar ||
					UPPER(LTRIM(RTRIM(DBLastProcessInstance))) || v_quoteChar || N' AND WorkItemID ' ||
					v_op || N' ' || char(DBLastWorkItem) ||
					N' ) OR  ( UPPER(LTRIM(RTRIM(' || v_sortFieldStr || N'))) = ' ||
					UPPER(LTRIM(RTRIM(v_lastValueStr))) ||
					N' AND UPPER(LTRIM(RTRIM(ProcessInstanceID))) ' || v_op ||
					v_quoteChar ||
					UPPER(LTRIM(RTRIM(DBLastProcessInstance))) || v_quoteChar || N'  ) OR ( UPPER(LTRIM(RTRIM(' || v_sortFieldStr ||N'))) ' || v_op || UPPER(LTRIM(RTRIM(v_lastValueStr))) || N' ) ) ' ||
					v_orderByStr;
	elseif(DBSortOrder = 'A')
	then
		set v_orderByStr = N' AND ( (' || v_sortFieldStr || N' is null ' ||
					N' AND UPPER(LTRIM(RTRIM(ProcessInstanceID))) = ' || v_quoteChar ||
					UPPER(LTRIM(RTRIM(DBLastProcessInstance)))
					|| v_quoteChar || N' AND WorkItemID ' || v_op ||
					char(DBLastWorkItem) ||
					N' ) OR  ( ' || v_sortFieldStr ||
					N' is null AND UPPER(LTRIM(RTRIM(ProcessInstanceID))) ' ||
					v_op || v_quoteChar || UPPER(LTRIM(RTRIM(DBLastProcessInstance))) || v_quoteChar || N'  ) OR ( ' || v_sortFieldStr || N' is not null ) ) ' ||
					v_orderByStr;
	else
		set v_orderByStr = N' AND ( (' || v_sortFieldStr || N' is null '||
					N' AND UPPER(LTRIM(RTRIM(ProcessInstanceID))) = '|| v_quoteChar ||
					UPPER(LTRIM(RTRIM(DBLastProcessInstance))) ||
					v_quoteChar || N' AND WorkItemID ' || v_op || char(DBLastWorkItem) ||
					N' ) OR  ( ' || v_sortFieldStr || N' is null ' ||
					N' AND UPPER(LTRIM(RTRIM(ProcessInstanceID))) ' ||
					v_op || v_quoteChar || UPPER(LTRIM(RTRIM(DBLastProcessInstance))) ||
					v_quoteChar || N' )) ' || v_orderByStr;
	end if;
end if;

set v_fetchSize = char(DBBatchSize + 1);

BEGIN

declare continue handler for not found
set v_fetchStatus = 1;

set v_QueryStr = 'Select  processInstanceId, workItemId  From WorkInProcessTable Where UPPER(LTRIM(RTRIM(LockedByName))) = ' || v_quoteChar || varchar(UPPER(LTRIM(RTRIM(v_lockedByName)))) || v_quoteChar || varchar(coalesce(v_queueFilterStr,N'')) || varchar(coalesce(v_filterStr,N'')) || varchar(coalesce(DBUserFilterStr,N'')) || varchar(coalesce(v_orderByStr,N'')) || ' fetch first ' || v_fetchSize || ' rows only ';

prepare cur_Stmt from v_QueryStr;

set v_fetchStatus = 0;
open WorkItem_cur;

fetch from WorkItem_cur into v_processInstanceId, v_workItemId;

while (v_fetchStatus = 0)
do
        if(v_cnt < DBBatchSize)
        then
                set v_QueryStr =  'insert into ' || v_tempTable ||' values (''' || varchar(coalesce(v_processInstanceId,N'')) || ''' , ' || char(v_workItemId)|| ')';
                execute immediate v_QueryStr;
                get diagnostics v_rowCount = row_count;
        	if(v_rowCount <= 0)
		then
		        execute drop_stmt;
			return;
		end if;
	        set v_cnt = v_cnt + 1;
	end if;
	set v_totalNoOfRec = v_totalNoOfRec + 1;
        fetch from Workitem_cur into v_processInstanceId, v_workItemId;
end while;
close WorkItem_cur;

if(v_totalNoOfRec <= DBBatchSize)
then
        savepoint worklist_to_workinprocess on rollback retain cursors;
	set v_fetchSize = char(DBBatchSize + 1 - v_cnt);
	set v_QueryStr = 'Select processInstanceId, workItemId From WorkListTable Where ( WorkItemState < 4 OR WorkItemState > 6 ) ' || varchar(coalesce(v_queueFilterStr,N'')) || varchar(coalesce(v_filterStr,N'')) || varchar(coalesce(DBUserFilterStr,N'')) || ' And (q_userId is null OR q_userId in ( 0, ' || char(v_lockedById) || ' ) )' || varchar(coalesce(v_orderbyStr,N'')) || ' fetch first ' || v_fetchSize || ' rows only ';
	prepare cur_Stmt from v_QueryStr;
	set v_fetchStatus = 0;
	open WorkItem_cur;
	fetch from Workitem_cur into v_processInstanceId, v_workItemId ;
	
	while(v_fetchStatus = 0)
	do
	        set v_totalNoOfRec = v_totalNoOfRec + 1;
                if(v_cnt < DBBatchSize)
		then	
	                set v_QueryStr =  'insert into ' || varchar(v_tempTable) ||' values (''' || varchar(v_processInstanceId) ||''' , ' || char(v_workItemId) || ')';
                        execute immediate v_QueryStr;
                        set v_cnt = v_cnt + 1;
	                insert into WorkInProcessTable(
					ProcessInstanceId, WorkItemId, ProcessName, ProcessVersion,
					ProcessDefID, LastProcessedBy, ProcessedBy, ActivityName,
					ActivityId, EntryDateTime, ParentWorkItemId, AssignmentType,
					CollectFlag, PriorityLevel, ValidTill, Q_StreamId,
					Q_QueueId, Q_UserId, AssignedUser, FilterValue,
					CreatedDateTime, WorkItemState, Statename, ExpectedWorkitemDelay,
					PreviousStage, LockedByName, LockStatus, LockedTime,
					Queuename, Queuetype, NotIFyStatus, Guid
					)
					Select
						ProcessInstanceId, WorkItemId, ProcessName, ProcessVersion,
						ProcessDefID, LastProcessedBy, ProcessedBy, ActivityName,
						ActivityId, EntryDateTime, ParentWorkItemId, AssignmentType,
						CollectFlag, PriorityLevel, ValidTill, Q_StreamId,
						Q_QueueId, v_lockedById, AssignedUser, FilterValue,
						CreatedDateTime, 2, Statename, ExpectedWorkitemDelay,
						PreviousStage, v_lockedByName, 'Y', current timestamp,
						Queuename, Queuetype, NotIFyStatus, cast(null as bigint)
						From Worklisttable
						Where UPPER(LTRIM(RTRIM(ProcessInstanceID))) = UPPER(RTRIM(LTRIM(v_processInstanceId)))
						and WorkItemID = integer(v_workItemId);
                        get diagnostics v_rowCount = row_count;
                        if(v_rowCount <= 0)
			then
			        rollback to savepoint worklist_to_workinprocess;
		                execute drop_stmt;
		                set v_MainCode = 825;
				set v_SubCode = 400;
				set v_NoOfRecordsFetched = 0;
				set v_TotalNoOfRecords = 0;
				open ret_cursor;
				return;
			end if;
                        delete from WorkListTable where ProcessInstanceID = RTrim(LTrim(v_processInstanceId))
				        and WorkItemID = integer(v_workItemId);
                        get diagnostics v_rowCount = row_count;
			if(v_rowCount <= 0)
			then
			        rollback to savepoint worklist_to_workinprocess;
				execute drop_stmt;
				set v_MainCode = 825;
				set v_SubCode = 400;
				set v_NoOfRecordsFetched = 0;
				set v_TotalNoOfRecords = 0;
				open ret_cursor;
				return;
			end if;
		end if;
		fetch from Workitem_cur into v_processInstanceId, v_workItemId;
	end while;		
	close Workitem_cur;
	commit;
end if;

END;

set v_MainCode = 0;
set v_SubCode = 0;
set v_NoOfRecordsFetched = v_cnt;
set v_TotalNoOfRecords = v_totalNoOfRec;
open ret_cursor;

-- Success !! Fetching data to return ...
set v_QueryStr = 'Select * from wfWorkListView_' || char(DBQueueId) ||
		' Inner Join '|| v_tempTable ||' ON wfWorkListView_' ||char(DBQueueId) || '.processInstanceId = ' || v_tempTable || '.processInstanceId '||
		' and wfWorkListView_' || char(DBQueueId) || '.workItemId = '|| v_tempTable ||'.workItemId with ur';
prepare ref_Stmt from v_QueryStr;			
open RefCursor;

return;
end P1			
 