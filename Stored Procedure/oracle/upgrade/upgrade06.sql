		
 /*Procedure to create search views for all queues .......  
			CHANGE HISTORY
____________________________________________________________________________________-
Date		Change By		Change Description (Bug No. (If Any))

_14/08/2013	SAJID KHAN		Query Modified for getting createddatetime from queuedata view.z*/
	
CREATE OR REPLACE PROCEDURE update_searchview AS
	v_QueueId		NVARCHAR2(10);
	v_Query			NVARCHAR2(8000);

	v_varStr		NVARCHAR2(4000);
	v_aliasName_view	NVARCHAR2(63);
	v_param1_view		NVARCHAR2(50);
	v_param2_view		NVARCHAR2(50);
	v_operator_view		INTEGER;
	v_varalias_cur		INTEGER;
	v_ret			INTEGER;

	CURSOR changeview_cur IS SELECT QueueId FROM QueueDefTable WHERE QueueId NOT IN (SELECT QueueId FROM VarAliasTable);
	CURSOR changeview_Alias_cur IS SELECT DISTINCT QueueId FROM VarAliasTable;
BEGIN
	OPEN changeview_cur;
	LOOP
		FETCH changeview_cur INTO v_QueueId;
			EXIT WHEN changeview_cur%NOTFOUND;

		v_Query := ' CREATE OR REPLACE VIEW WFSearchView_' || v_QueueId || ' AS ' ||
				' Select queueview.ProcessInstanceId, queueview.QueueName, queueview.processName, ' ||
				' queueview.ProcessVersion, queueview.ActivityName, queueview.stateName, ' ||
				' queueview.CheckListCompleteFlag, queueview.AssignedUser, queueview.EntryDateTime, ' ||
				' queueview.ValidTill, queueview.workitemid, queueview.prioritylevel, queueview.parentworkitemid, ' ||
				' queueview.processdefid, queueview.ActivityId, queueview.InstrumentStatus, ' ||
				' queueview.LockStatus, queueview.LockedByName, queueview.CreatedByName, ' ||
				' queueview.CreatedDateTime, queueview.LockedTime, queueview.IntroductionDateTime, ' ||
				' queueview.IntroducedBy, queueview.assignmenttype, queueview.processinstancestate, ' ||
				' queueview.queuetype, Status, Q_QueueId, ' ||
				' (queueview.entrydatetime - queueview.ExpectedWorkItemDelayTime )*24  as TurnaroundTime, ' ||	
				' ReferredBy, ReferredTo, ' ||
				' ExpectedProcessDelayTime, ExpectedWorkitemDelayTime, ProcessedBy, Q_UserID, WorkItemState ' ||
				' from QueueTable queueview ' ||
				' Where queueview.referredTo Is Null ' ||
				' And queueview.Q_QueueId = ' || v_QueueId;
		Begin
			dbms_output.put_line('WFSearchView_' || v_QueueId || ' created ... ' );
		End;
		EXECUTE IMMEDIATE TO_CHAR(v_Query);
	END LOOP;
	CLOSE changeview_cur;


	
	OPEN changeview_Alias_cur;
	LOOP
		FETCH changeview_Alias_cur INTO v_QueueId;
			EXIT WHEN changeview_Alias_cur%NOTFOUND;
			v_varStr := '';
			v_varalias_cur := DBMS_SQL.OPEN_CURSOR;
			DBMS_SQL.PARSE(v_varalias_cur,'SELECT Alias, Param1 From VarAliasTable where queueId = '  || v_QueueId || '  order by id',
					dbms_sql.native);

			DBMS_SQL.DEFINE_COLUMN(v_varalias_cur, 1, v_aliasName_view, 63);
			DBMS_SQL.DEFINE_COLUMN(v_varalias_cur, 2, v_param1_view, 50);
			v_ret := dbms_sql.EXECUTE(v_varalias_cur);
			LOOP
				IF(dbms_sql.fetch_rows(v_varalias_cur) = 0) THEN
					EXIT;
				END IF;

				DBMS_SQL.column_value(v_varalias_cur, 1, v_aliasName_view);
				DBMS_SQL.column_value(v_varalias_cur, 2, v_param1_view);

				IF( upper(rtrim(v_param1_view)) = upper(rtrim('currentDateTime')) ) THEN
					v_varStr := v_varStr || ' , sysDate ';
				ELSIF (upper(rtrim(v_param1_view)) = upper(rtrim('CreatedDateTime'))) THEN
					v_varStr := v_varStr ||', '|| v_param1_view;
				ELSE
					v_varStr := v_varStr || ', ' || v_param1_view;
				END IF;
				
				v_varStr := v_varStr || ' as ' || v_aliasName_view;
				
			END LOOP;
			DBMS_SQL.CLOSE_CURSOR(v_varalias_cur);

			v_Query := ' CREATE OR REPLACE VIEW WFSearchView_' || v_QueueId || ' as ' ||
				' Select queueview.ProcessInstanceId, queueview.QueueName, queueview.processName, ' ||
				' queueview.ProcessVersion, queueview.ActivityName, queueview.stateName, ' ||
				' queueview.CheckListCompleteFlag, queueview.AssignedUser, ' ||
				' queueview.EntryDateTime, queueview.ValidTill, queueview.workitemid, queueview.prioritylevel, ' ||
				' queueview.parentworkitemid, queueview.processdefid, queueview.ActivityId, queueview.InstrumentStatus, ' ||
				' queueview.LockStatus, queueview.LockedByName, queueview.CreatedByName, queueview.CreatedDateTime, ' ||
				' queueview.LockedTime, queueview.IntroductionDateTime, queueview.IntroducedBy, ' ||
				' queueview.assignmenttype, queueview.processinstancestate, queueview.queuetype, Status, Q_QueueId, ' ||
				' (QUEUEVIEW.entrydatetime - QUEUEVIEW.ExpectedWorkItemDelayTime )*24  as TurnaroundTime, ' ||
				' ReferredBy, ReferredTo, ' ||
				' ExpectedProcessDelayTime, ExpectedWorkItemDelayTime, ProcessedBy, Q_UserID, WorkItemState ' ||
				v_varStr ||
				' from QueueTable queueview  ' ||
				' where queueview.referredTo is null ' ||
				' And queueview.Q_QueueId = ' || v_QueueId;
			Execute Immediate TO_CHAR(v_Query);
	END LOOP;
	CLOSE changeview_Alias_cur;

/*
	Execute Immediate ('CREATE OR REPLACE VIEW WFSearchView_0 as 
		Select queueview.ProcessInstanceId, queueview.QueueName, queueview.processName, 
		queueview.ProcessVersion, queueview.ActivityName, queueview.stateName, 
		queueview.CheckListCompleteFlag, queueview.AssignedUser, queueview.EntryDateTime, 
		queueview.ValidTill, queueview.workitemid, queueview.prioritylevel, 
		queueview.parentworkitemid, queueview.processdefid, queueview.ActivityId, 
		queueview.InstrumentStatus, queueview.LockStatus, queueview.LockedByName, 
		queueview.CreatedByName, queueview.CreatedDateTime, queueview.LockedTime, 
		queueview.IntroductionDateTime, queueview.IntroducedBy, queueview.assignmenttype, 
		queueview.processinstancestate, queueview.queuetype, Status, Q_QueueId, 
		(QUEUEVIEW.entrydatetime - QUEUEVIEW.ExpectedWorkItemDelayTime )*24  as TurnaroundTime, 
		ReferredBy, ReferredTo, 
		ExpectedProcessDelayTime, ExpectedWorkItemDelayTime, ProcessedBy, Q_UserID, WorkItemState
		from queueview
		where queueview.referredTo is null '
		);
*/
		Begin
			dbms_output.put_line('WFSearchView_0 created ... ' );
		End;

End; 
~ 
	Call update_searchview() 
~ 
	Drop Procedure update_searchview 
~