/*----------------------------------------------------------------------------------------------------
		NEWGEN SOFTWARE TECHNOLOGIES LIMITED
	Group				: Application –Products
	Product / Project		: WorkFlow
	Module				: Transaction Server
	File Name			: WFLockWorkItem.sql
	Programmer			: Ruhi Hira
	Date written (DD/MM/YYYY)	: Sep 30th 2004
	Last Modified By (DD/MM/YYYY)	: Ruhi Hira
	Last Modified On (DD/MM/YYYY)	: Oct 4th 2004
	Description			: Stored Procedure called from 
					  class	 - WMWorkItem.java, method - WFFetchWorkItemsWithLock.
					  This stored procedure first checks workInProcessTable for
					  locked workitems (considering batch size), If records fetched
					  are lesser than (batchSize + 1), workListTable is queried again
					  for workitems.
------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------
				CHANGE HISTORY
------------------------------------------------------------------------------------------------------

Date			Change By		Change Description (Bug No. (If Any))
29/01/2005		Ruhi Hira		Bug # WFS_5.1_005, failed for queueId greater than 999
						(three digit number).
24/05/2007		Ruhi Hira		Bugzilla Bug 945.
17/05/2013		Shweta Singhal	Process Variant Support Changes
8/01/2014       Anwar Ali Danish  Changes done for code optimization

------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------*/

If Exists (Select * from SysObjects Where xType = 'P' and name = 'WFLockWorkItem')
Begin
	Execute('DROP PROCEDURE WFLockWorkItem')
	Print 'Procedure WFLockWorkItem already exists, hence older one dropped ..... '
End

~

Create Procedure WFLockWorkItem(
	@sessionId			Int,
	@queueId			Int,
	@sortOrder			Char(1),
	@orderBy			Int,
	@batchSize			Int,
	@lastWorkItem			Int,
	@lastProcessInstance		NVarchar(63),
	@lastValue			NVarchar(63),
	@userFilterStr			NVarchar(500)
)	
AS
Begin
	Set NoCount On
	
	If(@batchSize <= 0)
	Begin
		Select MainCode = 18, SubCode = 0, NoOfRecordsFetched = 0, TotalNoOfRecords = 0 -- No more data, as batch size <= 0
		Return
	End

	-- Variables declared .....
	Declare @filterValue		NVarchar(63)
	Declare @filterOption		Int
	Declare @lockedById		Int
	Declare @lockedByName		NVarchar(63)
  	Declare @WF_EQUAL		Int
	Declare @WF_NOTEQ		Int
	Declare @filterStr		NVarchar(300)
	Declare @queueFilterStr		NVarchar(300)
	Declare @lastValueStr		NVarchar(1000)
	Declare @sortFieldStr		NVarchar(50)
	Declare @quoteChar		Char(1)
	Declare @cnt			Int
	Declare @totalNoOfRec		Int
	Declare @sortStr		NVarchar(6)
	Declare @orderByStr		NVarchar(1000)
	Declare @op			Char(1)
	Declare @fetchSize		Varchar(3)
	Declare @processInstanceId	NVarchar(63)
	Declare @workItemId		Int
	Declare @alias			NVarchar(63)
	Declare @toBeFetched		Int

	Set @WF_EQUAL = 2
	Set @WF_NOTEQ = 3
	Set @quoteChar = Char(39)
	Set @queueFilterStr = ''
	Set @fetchSize = 0
	Set @orderByStr = ''
	Set @filterValue = ''
	Set @filterStr = ''
	Set @queueFilterStr = ''
	Set @lastValueStr = ''
	Set @sortFieldStr = ''

	-- Check for validity of session ...
	Select @lockedById = UserID, @lockedByName = UserName From WFSessionView, WFUserView 
	Where UserId = UserIndex And SessionID = @sessionId

	If(@@ERROR <> 0 OR @@ROWCOUNT <= 0)
	Begin
		Select MainCode = 11, SubCode = 0, NoOfRecordsFetched = 0, TotalNoOfRecords = 0 -- Invalid Session
		Return
	End

	-- Add filer on the basis of queue ...
	If (@queueId > 0)
	Begin
		Set @queueFilterStr = ' And q_queueId = ' + Convert(varchar(10), @queueId)
		If(Not Exists(Select * from QUserGroupView where QueueId = @queueId and UserId = @lockedById))
		Begin
			Select MainCode = 18, SubCode = 810, NoOfRecordsFetched = 0, TotalNoOfRecords = 0 -- No queue
			Return
		End
		-- todo : can add check for queueType - D
		Select @filterOption = filterOption, @filterValue = filterValue From QueueDeftable (NOLOCK) Where QueueID = @queueId
		If(@@ROWCOUNT > 0)
		Begin
			If(@filterOption = @WF_EQUAL)
				Set @filterStr = ' And ' + @filterValue + ' = ' + convert(nvarchar(10), @lockedById)
			Else If(@filterOption = @WF_NOTEQ)
				Set @filterStr = ' And ' + @filterValue + ' != ' + convert(nvarchar(10), @lockedById)
		End
	End

	-- Define sortOrder, default is Ascending .... 
	If(@sortOrder = 'D')
	Begin
		Set @sortStr = ' DESC '
		Set @op = '<'
	End
	Else -- If(@sortOrder = 'A')
	Begin
		Set @sortStr = ' ASC '
		Set @op = '>'
	End

	/*
	 Initialize sort order String, Default is PriorityLevel, Assumption : lastValue will be provided by client 
	 (generally 1 for priority level).
	*/
	Set @sortFieldStr = ' PriorityLevel '
	If(@orderBy = 1)
	Begin
		Set @lastValueStr = @lastValue 
		Set @sortFieldStr = ' PriorityLevel '
	End
	Else If(@orderBy = 2)
	Begin
		If(len(@lastValue) > 0)
			Set @lastValueStr = @quoteChar + @lastValue + @quoteChar
		Set @sortFieldStr = ' ProcessInstanceId '
	End
	Else If(@orderBy = 3)
	Begin
		If(len(@lastValue) > 0)
			Set @lastValueStr = @quoteChar + @lastValue + @quoteChar
		Set @sortFieldStr = ' ActivityName '
	End
	Else If(@orderBy = 4)
	Begin
		If(len(@lastValue) > 0)
			Set @lastValueStr = @quoteChar + @lastValue + @quoteChar
		Set @sortFieldStr = ' LockedByName '
	End
	Else If(@orderBy = 5)
	Begin
		If(len(@lastValue) > 0)
			Set @lastValueStr = @quoteChar + @lastValue + @quoteChar
		Set @sortFieldStr = ' IntroducedBy '
	End
	Else If(@orderBy = 6)
	Begin
		If(len(@lastValue) > 0)
			Set @lastValueStr = @quoteChar + @lastValue + @quoteChar
		Set @sortFieldStr = ' InstrumentStatus '
	End
	Else If(@orderBy = 7)
	Begin
		If(len(@lastValue) > 0)
			Set @lastValueStr = @quoteChar + @lastValue + @quoteChar
		Set @sortFieldStr = ' CheckListCompleteFlag '
	End
	Else If(@orderBy = 8)
	Begin
		If(len(@lastValue) > 0)
			Set @lastValueStr = @quoteChar + @lastValue + @quoteChar
		Set @sortFieldStr = ' LockStatus '
	End
	Else If(@orderBy = 9)
	Begin
		If(len(@lastValue) > 0)
			Set @lastValueStr = @lastValue
		Set @sortFieldStr = ' WorkItemState '
	End
	Else If(@orderBy = 10)
	Begin
		If(len(@lastValue) > 0)
			Set @lastValueStr = @quoteChar + @lastValue + @quoteChar
		Set @sortFieldStr = ' EntryDateTime '
	End
	Else If(@orderBy = 11)
	Begin
		If(len(@lastValue) > 0)
			Set @lastValueStr = @quoteChar + @lastValue + @quoteChar
		Set @sortFieldStr = ' ValidTill '
	End
	Else If(@orderBy = 12)
	Begin
		If(len(@lastValue) > 0)
			Set @lastValueStr = @quoteChar + @lastValue + @quoteChar
		Set @sortFieldStr = ' LockedTime '
	End
	Else If(@orderBy = 13)
	Begin
		If(len(@lastValue) > 0)
			Set @lastValueStr = @quoteChar + @lastValue + @quoteChar
		Set @sortFieldStr = ' IntroductionDateTime '
	End
	Else If(@orderBy = 17)
	Begin
		If(len(@lastValue) > 0)
			Set @lastValueStr = @quoteChar +  @lastValue + @quoteChar
		Set @sortFieldStr = ' Status '
	End
	Else If(@orderBy = 18)
	Begin
		If(len(@lastValue) > 0)
			Set @lastValueStr = @quoteChar + @lastValue + @quoteChar
		Set @sortFieldStr = ' CreatedDateTime '
	End
	Else If(@orderBy > 100) -- todo : do we need to add check for queueId > 0
	Begin
		Execute('Declare VarAliasTable_cur CURSOR FAST_FORWARD FOR ' + 
			' Select alias From VarAliasTable (NOLOCK) Where queueId = ' + @queueId
			)
		Open VarAliasTable_cur
		-- todo : for optimization, dynamic cursor can b used here with fetch absolute........
		--	Generally it is not the case.
		Fetch Next From VarAliasTable_cur Into @alias 
		Set @toBeFetched = 1
		While (@@fetch_status <> -1 OR (@toBeFetched < (@orderBy - 100)))
		Begin
			Set @toBeFetched = @toBeFetched + 1
			Fetch Next From VarAliasTable_cur Into @alias
		End
		Close VarAliasTable_cur
		Deallocate VarAliasTable_cur
		If(@toBeFetched != (@orderBy - 100))
		Begin
			Select MainCode = 800, SubCode = 802, NoOfRecordsFetched = 0, TotalNoOfRecords = 0 -- Illegal parameters
			Return
		End
		If(len(@lastValue) > 0)
			Set @lastValueStr = @quoteChar +  @lastValue + @quoteChar
		Set @sortFieldStr = @alias
	End

	Set @cnt = 0
	Set @totalNoOfRec = 0

	If(@orderBy = 2)
		Set @orderByStr = ' ORDER BY ProcessInstanceID ' + @sortStr + ', WorkItemID ' + @sortStr
	Else 
		Set @orderByStr = ' ORDER BY ' + @sortFieldStr + @sortStr + ', ProcessInstanceID ' + @sortStr 
			+ ', WorkItemID ' + @sortStr
	If(len(@lastProcessInstance) > 0)
	Begin
		If(len(@lastValue) > 0)
			Set @orderByStr = ' AND ( ( ' + @sortFieldStr + ' = ' + @lastValueStr + ' AND ProcessInstanceID = ' + 
					@quoteChar + @lastProcessInstance + @quoteChar + ' AND WorkItemID ' + @op + ' ' + 
					convert(varchar(10), @lastWorkItem) + ' ) OR  ( ' + @sortFieldStr + ' = ' + @lastValueStr +
					' AND ProcessInstanceID ' + @op + @quoteChar + @lastProcessInstance + @quoteChar + 
					'  ) OR ( ' + @sortFieldStr + @op + @lastValueStr + ' ) ) ' + @orderByStr
		Else If(@sortOrder = 'A') 
			Set @orderbyStr = ' AND ( ( ' + @sortFieldStr + ' is null AND ProcessInstanceID = ' +
					@quoteChar + @lastProcessInstance + @quoteChar + ' AND WorkItemID ' + @op + 
					convert(varchar(10), @lastWorkItem) + ' ) OR  ( ' + @sortFieldStr + ' is null AND ProcessInstanceID ' + @op + 
					@quoteChar + @lastProcessInstance + @quoteChar + '  ) OR ( ' +
					@sortFieldStr + ' is not null ) ) ' + @orderByStr
		Else 
			Set @orderbyStr = ' AND ( ( ' + @sortFieldStr + ' is null AND ProcessInstanceID = ' + 
					@quoteChar + @lastProcessInstance + @quoteChar + ' AND WorkItemID ' + @op + 
					convert(varchar(10), @lastWorkItem) + ' ) OR  ( ' + @sortFieldStr + ' is null AND ProcessInstanceID ' + @op + 
					@quoteChar + @lastProcessInstance + @quoteChar + ' )) ' + @orderByStr

	End
	
	-- tempTable created to hold processInstanceId and workItemId of workitems to move
	-- Important : drop the table before returning !!!
	Create Table #tempTable(
		processInstanceId		NVarchar(63),
		workItemId				Int
	)
	
	Set @fetchSize = Convert(Varchar(10), (@batchSize + 1))
	
	/*Execute ('Declare WorkItem_Cur CURSOR FAST_FORWARD FOR ' +
		' Select TOP ' + @fetchSize + 
		' processInstanceId, workItemId ' + ' From WorkInProcessTable Where LockedByName = ' + 
		@quoteChar + @lockedByName + @quoteChar + @queuefilterStr + @filterStr + @userFilterStr + @orderbyStr
		)*/
	Execute ('Declare WorkItem_Cur CURSOR FAST_FORWARD FOR ' +
		' Select TOP ' + @fetchSize + 
		' processInstanceId, workItemId ' + ' From WFINSTRUMENTTABLE Where '
		+'LockStatus = ''Y'' AND RoutingStatus = ''N'' AND LockedByName = ' + 
		@quoteChar + @lockedByName + @quoteChar + @queuefilterStr + @filterStr + @userFilterStr + @orderbyStr
		)
	Open WorkItem_cur
	Fetch Next From WorkItem_cur Into @processinstanceid, @workitemid
	While (@@fetch_status <> -1)
	Begin
		If (@@fetch_status <> -2)
		Begin
			If(@cnt < @batchSize)
			Begin
				Insert into #tempTable values (@processInstanceId, @workitemId)
				If(@@error <> 0)
				Begin
					Execute('Drop table #tempTable')
					Return
				End
				Set @cnt = @cnt + 1
			End
			Set @totalNoOfRec = @totalNoOfRec + 1
		End
		Fetch Next From Workitem_cur Into @processInstanceId, @workitemId
	End
	Close WorkItem_cur
	Deallocate WorkItem_cur

	If(@totalNoOfRec <= @batchSize)
	Begin
		Begin Transaction WorkList_To_WorkInProcess
			Set @fetchSize = Convert(Varchar(10), (@batchSize + 1 - @cnt))

			-- todo : to be reviewed
			-- Important : Query modified, q_userId check was not there previously in java file...
			Execute ('Declare WorkItem_Cur CURSOR FAST_FORWARD FOR ' + 
				' Select TOP ' + @fetchSize + ' processInstanceId, workItemId ' + 
				' From WFINSTRUMENTTABLE Where ( WorkItemState < 4 OR WorkItemState > 6 ) ' + 
				@queueFilterStr + @filterStr + @userFilterStr + 
				' And (q_userId is null OR q_userId in ( 0, ' + @lockedById + ' ) )' + @orderbyStr
				)
			OPEN WorkItem_Cur
			Fetch Next From Workitem_cur Into @processInstanceId, @workitemId
			WHILE (@@FETCH_STATUS <> -1)
			BEGIN
				IF (@@FETCH_STATUS <> -2) 
				BEGIN
					Set @totalNoOfRec = @totalNoOfRec + 1
					If(@cnt < @batchSize)
					Begin
						Insert into #tempTable values (@processInstanceId, @workitemId)
						Set @cnt = @cnt + 1
						/*Process Variant Support Changes*/
						/*Insert into WorkInProcessTable(
							ProcessInstanceId, WorkItemId, ProcessName, ProcessVersion, 
							ProcessDefID, LastProcessedBy, ProcessedBy, ActivityName, 
							ActivityId, EntryDateTime, ParentWorkItemId, AssignmentType,
							CollectFlag, PriorityLevel, ValidTill, Q_StreamId, 
							Q_QueueId, Q_UserId, AssignedUser, FilterValue, 
							CreatedDateTime, WorkItemState, Statename, ExpectedWorkitemDelay, 
							PreviousStage, LockedByName, LockStatus, LockedTime, 
							Queuename, Queuetype, NotifyStatus, Guid, ProcessVariantId
							) 
							Select 
							ProcessInstanceId, WorkItemId, ProcessName, ProcessVersion, 
							ProcessDefID, LastProcessedBy, ProcessedBy, ActivityName,
							ActivityId, EntryDateTime, ParentWorkItemId, AssignmentType,
							CollectFlag, PriorityLevel, ValidTill, Q_StreamId, 
							Q_QueueId, @lockedById, AssignedUser, FilterValue, 
							CreatedDateTime, 2, Statename, ExpectedWorkitemDelay, 
							PreviousStage, @lockedByName, 'Y', getDate(), 
							Queuename, Queuetype, NotifyStatus, null, ProcessVariantId
							From Worklisttable Where ProcessInstanceID = RTrim(LTrim(@processInstanceId))
							and WorkItemID = convert(int, @workItemId)*/
							
						Update WFINSTRUMENTTABLE set Q_UserId = @lockedById , WorkItemState = 2 , LockedByName = @lockedByName , LockStatus = 'Y' , LockedTime = getDate() , Guid = null Where ProcessInstanceID = RTrim(LTrim(@processInstanceId))
						and WorkItemID = convert(int, @workItemId) and LockStatus = 'N' and RoutingStatus = 'N'
							

						If( @@Error <> 0 OR @@rowcount <= 0 )
						Begin
							RollBack Transaction WorkList_To_WorkInProcess
							Execute('Drop table #tempTable')
							-- Fatal Error, Operation failed
							Select MainCode = 825, SubCode = 400, NoOfRecordsFetched = 0, TotalNoOfRecords = 0
							Return 
						End

						/*Delete From WorkListTable Where ProcessInstanceID = RTrim(LTrim(@processInstanceId)) 
							and WorkItemID = convert(int, @workItemId)
						If( @@Error <> 0 OR @@rowcount <= 0 )
						Begin
							RollBack Transaction WorkList_To_WorkInProcess
							Execute('Drop table #tempTable')
							-- Fatal Error, Operation failed
							Select MainCode = 825, SubCode = 400, NoOfRecordsFetched = 0, TotalNoOfRecords = 0
							Return 
						End*/
					End
				End
				Fetch Next From Workitem_cur Into @processInstanceId, @workitemId
			End
			Close Workitem_cur
			Deallocate Workitem_cur

		Commit Transaction WorkList_To_WorkInProcess
	End
	-- Success !! Fetching data to return ...
	Select MainCode = 0, SubCode = 0, NoOfRecordsFetched = @cnt, TotalNoOfRecords = @totalNoOfRec
	/*Execute('Select * from wfWorkListView_' + @queueId + 
		' Inner Join #tempTable ON wfWorkListView_' + @queueId + '.processInstanceId = #tempTable.processInstanceId ' +
		' and wfWorkListView_' + @queueId + '.workItemId = #tempTable.workItemId ' 
		)*/
	Execute('Select * from(select ProcessInstanceId,ProcessInstanceId as 
		ProcessInstanceName,ProcessDefId,ProcessName,ActivityId,ActivityName,PriorityLevel,InstrumentStatus,LockStatus,LockedByName,ValidTill,CreatedByName,CreatedDateTime,Statename,CheckListCompleteFlag,EntryDateTime,LockedTime,IntroductionDateTime,IntroducedBy,AssignedUser, WorkItemId,QueueName,AssignmentType,ProcessInstanceState,QueueType,Status,Q_QueueID, DATEDIFF(HH,entrydatetime, ExpectedWorkItemDelay) as TurnaroundTime,ReferredByname, 0 as ReferTo, Q_UserID,FILTERVALUE,Q_StreamId,CollectFlag,ParentWorkItemId,ProcessedBy,LastProcessedBy,ProcessVersion,
		WORKITEMSTATE, PREVIOUSSTAGE, ExpectedWorkitemDelay,VAR_INT1,VAR_INT2,VAR_INT3,VAR_INT4,VAR_INT5,VAR_INT6,VAR_INT7,VAR_INT8,VAR_LONG1,VAR_LONG2,VAR_LONG3,VAR_LONG4 from WFINSTRUMENTTABLE where Q_QueueId = ' + 
		@queueId +' and RoutingStatus = ''N'')tmp 
		Inner Join #tempTable ON tmp.ProcessInstanceId = #tempTable.processInstanceId and
		tmp.workItemId = #tempTable.workItemId ')
		
	Execute('Drop Table #tempTable')
	Return
End

~

Print 'Stored Procedure WFLockWorkItem compiled successfully ........'
