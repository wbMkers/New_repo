If Exists (Select * from SysObjects Where xType = 'P' and name = 'update_searchview')
Begin
	Execute('DROP PROCEDURE update_searchview')
	Print 'Procedure update_searchview, Part of Upgrade already exists, hence older one dropped ..... '
End

~

Create Procedure update_searchview as 
Begin
	Declare @QueueId Varchar(10)
	Declare @Query	Varchar(8000)
	Declare changeview_cur Cursor FAST_FORWARD For 
		select QueueId From QueueDefTable where QueueId NOT IN (Select QueueId From VarAliasTable)
	OPEN changeview_cur
	IF (@@CURSOR_ROWS <> 0)
	BEGIN
		FETCH NEXT FROM changeview_cur INTO @QueueId
		WHILE (@@FETCH_STATUS = 0)
		BEGIN
			IF EXISTS(Select * from sysObjects where name = 'WFSearchView_' + Convert(varchar(4), @QueueId) AND xType = 'V')
				Execute ('Drop View WFSearchView_' + @QueueId)
			Set @Query = 
				' Create view WFSearchView_' + @QueueId + ' as ' +
				' Select queueview.ProcessInstanceId, queueview.QueueName, queueview.processName, ' +
				' queueview.ProcessVersion, queueview.ActivityName, queueview.stateName, ' +
				' queueview.CheckListCompleteFlag, queueview.AssignedUser, queueview.EntryDateTime, ' +
				' queueview.ValidTill, queueview.workitemid, queueview.prioritylevel, queueview.parentworkitemid, ' +
				' queueview.processdefid, queueview.ActivityId, queueview.InstrumentStatus, ' +
				' queueview.LockStatus, queueview.LockedByName, queueview.CreatedByName, ' +
				' queueview.CreatedDateTime, queueview.LockedTime, queueview.IntroductionDateTime, ' +
				' queueview.IntroducedBy, queueview.assignmenttype, queueview.processinstancestate, ' +
				' queueview.queuetype, Status, Q_QueueId, ' +
				' DATEDIFF( hh,  entrydatetime , ExpectedWorkItemDelayTime) as TurnaroundTime, ' +
				' ReferredBy, ReferredTo, ' +
				' ExpectedProcessDelayTime, ExpectedWorkitemDelayTime, ProcessedBy, Q_UserID, WorkItemState ' +
				' from QueueTable queueview with (NOLOCK) ' +
				' Where queueview.referredTo Is Null ' +
				' And queueview.Q_QueueId = ' + @QueueId
			Execute (@Query)
			FETCH NEXT FROM changeview_cur INTO @QueueId
		End
	End
	CLOSE changeview_cur
	DEALLOCATE changeview_cur

	Declare changeview_cur Cursor FAST_FORWARD For 
		Select distinct QueueId From VarAliasTable

	declare @varStr varchar(4000)
	declare @aliasName_view varchar(63)
	declare @param1_view varchar(50)
	declare @param2_view varchar(50)
	declare @operator_view smallint
	
	OPEN changeview_cur
	IF (@@CURSOR_ROWS <> 0)
	BEGIN
		FETCH NEXT FROM changeview_cur INTO @QueueId
		WHILE (@@FETCH_STATUS = 0)
		BEGIN
			
			IF EXISTS(Select * from sysObjects where name = 'WFSearchView_' + Convert(varchar(5), @QueueId) AND xType = 'V')
				Execute( 'Drop View WFSearchView_' + @QueueId )

			Set @varStr = ''
			execute (' Declare varalias_cur Cursor For ' +
				' Select Alias, Param1, Param2, operator From VarAliasTable where queueId = convert(varchar(5), ' 
				+ @QueueId + ') order by id' )
			open varalias_cur
			FETCH NEXT FROM varalias_cur INTO @aliasName_view, @param1_view, @param2_view, @operator_view

			While (@@FETCH_STATUS = 0)
			Begin
				If(@param1_view = 'currentDateTime')
					Set @varStr = @varStr + ', getDate()'
				else
					Set @varStr = @varStr + ', ' + @param1_view
				
				If(@param2_view is not null and @operator_view is not null)
				Begin
					If(@operator_view = 11)
						Set @varStr = @varStr + ' + '
					If(@operator_view = 12)
						Set @varStr = @varStr + ' - '
					If(@operator_view = 13)
						Set @varStr = @varStr + ' * '
					If(@operator_view = 14)
						Set @varStr = @varStr + ' / '
					
					If(@param2_view = 'Currentdatetime' )
						Set @varStr = @varStr + ', getDate()'
					else if(@param2_view = 'CreatedDateTime')
						Set @varStr = @varStr + ' Processinstancetable.' + @param2_view
					Else
						Set @varStr = @varStr + @param2_view
				End

				Set @varStr = @varStr + ' as ' + @aliasName_view
				FETCH NEXT FROM varalias_cur INTO @aliasName_view, @param1_view, @param2_view, @operator_view
			End
			Close varalias_cur
			Deallocate varalias_cur

			Set @Query = 
				' Create view WFSearchView_' + @QueueId + ' as ' +
				' Select queueview.ProcessInstanceId, queueview.QueueName, queueview.processName, ' +
				' queueview.ProcessVersion, queueview.ActivityName, queueview.stateName, ' +
				' queueview.CheckListCompleteFlag, queueview.AssignedUser, ' +
				' queueview.EntryDateTime, queueview.ValidTill, queueview.workitemid, queueview.prioritylevel, ' +
				' queueview.parentworkitemid, queueview.processdefid, queueview.ActivityId, queueview.InstrumentStatus, ' +
				' queueview.LockStatus, queueview.LockedByName, queueview.CreatedByName, queueview.CreatedDateTime, ' +
				' queueview.LockedTime, queueview.IntroductionDateTime, queueview.IntroducedBy, ' +
				' queueview.assignmenttype, queueview.processinstancestate, queueview.queuetype, Status, Q_QueueId, ' +
				' DATEDIFF( hh,  entrydatetime ,  ExpectedWorkItemDelayTime ) as TurnaroundTime, ' +
				' ReferredBy, ReferredTo, ' +
				' ExpectedProcessDelayTime, ExpectedWorkItemDelayTime, ProcessedBy, Q_UserID, WorkItemState ' +
				@varStr +
				' from QueueTable queueview with (NOLOCK) ' +
				' where queueview.referredTo is null ' +
				' And queueview.Q_QueueId = ' + @QueueId
			Execute(@Query)

			FETCH NEXT FROM changeview_cur INTO @QueueId
		END
	END
	CLOSE changeview_cur
	DEALLOCATE changeview_cur

End

~
exec update_searchview 
drop procedure update_searchview 

print 'Script update_searchview, part of Upgrade executed successfully, procedure DROPPED ...... ' 

~
