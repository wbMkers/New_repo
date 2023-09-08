/*
Change DATE		Name				Description
--------------------------------------------------------------
26/05/2017		Sanal Grover		Bug 62518 - Step by Step Debugs in Version Upgrade.
*/
CREATE OR REPLACE PROCEDURE update_searchview AS

	v_QueueId			NVARCHAR2(10);
	v_Query				NVARCHAR2(8000);
	v_varStr			NVARCHAR2(4000);
	v_aliasName_view	NVARCHAR2(63);
	v_param1_view		NVARCHAR2(50);
	v_param2_view		NVARCHAR2(50);
	v_operator_view		INTEGER;
	v_varalias_cur		INTEGER;
	v_ret				INTEGER;
	v_logStatus 		BOOLEAN;
	v_scriptName        NVARCHAR2(100) := 'Upgrade09_SP00_009';
	v_viewname 			NVARCHAR2(100);
	EXISTFLAG 			INT;
	
	CURSOR changeview_cur IS SELECT QueueId FROM QueueDefTable ;
	/*CURSOR changeview_Alias_cur IS SELECT DISTINCT QueueId FROM VarAliasTable;*/
	
		
	FUNCTION LogInsert(v_stepNumber Number,v_stepDetails VARCHAR2 )
	RETURN BOOLEAN
	as 
	DBString   BOOLEAN; 
	dbQuery VARCHAR2(1000);
	BEGIN
		BEGIN
		dbQuery := 'INSERT INTO WFVERSIONUPGRADELOGTABLE(STEPNUMBER,SCRIPTNAME,STEPDETAILS, STARTDATE, STATUS) VALUES(:v_stepNumber,:v_scriptName,:v_stepDetails,SYSTIMESTAMP, ''UPDATING'')';
		--dbms_output.put_line ('dbQuery '|| dbQuery);	
		EXECUTE IMMEDIATE dbQuery using v_stepNumber,v_scriptName,v_stepDetails;
		IF SQL%ROWCOUNT = 1
		THEN
		DBString := FALSE;
		ELSE
		DBString := TRUE;
		END IF;
		--dbms_output.put_line ('LogInsert completed with status: ');
		RETURN DBString;
		END;
	END;
	
	FUNCTION LogSkip(v_stepNumber Number)
	RETURN BOOLEAN
	as
	DBString   BOOLEAN; 
	dbQuery VARCHAR2(1000);
	BEGIN
		BEGIN
		dbQuery := 'UPDATE WFVERSIONUPGRADELOGTABLE set ENDDATE = SYSTIMESTAMP, STATUS = ''INSIDE'' WHERE STEPNUMBER =' || v_stepNumber ||' AND STATUS = ''UPDATING''  AND SCRIPTNAME ='''|| v_scriptName ||'''';
		--dbms_output.put_line ('dbQuery '|| dbQuery);
		EXECUTE IMMEDIATE (dbQuery);
		IF SQL%ROWCOUNT = 1
		THEN
		DBString := FALSE;
		ELSE
		DBString := TRUE;
		END IF;
		--dbms_output.put_line ('LogUpdate completed with status: ');
		RETURN DBString;
		END;
	END;
	
	FUNCTION LogUpdate(v_stepNumber Number)
	RETURN BOOLEAN
	as
	DBString   BOOLEAN; 
	dbQuery1 VARCHAR2(1000);
	dbQuery2 VARCHAR2(1000);
	BEGIN
		BEGIN
		dbQuery1 := 'UPDATE WFVERSIONUPGRADELOGTABLE set ENDDATE = SYSTIMESTAMP, STATUS = ''UPDATED'' WHERE STEPNUMBER =' || v_stepNumber ||' AND STATUS = ''INSIDE''  AND SCRIPTNAME ='''|| v_scriptName ||'''';
		dbQuery2 := 'UPDATE WFVERSIONUPGRADELOGTABLE set ENDDATE = SYSTIMESTAMP, STATUS = ''SKIPPED'' WHERE STEPNUMBER =' || v_stepNumber ||' AND STATUS = ''UPDATING''  AND SCRIPTNAME ='''|| v_scriptName ||'''';
		    
		--dbms_output.put_line ('dbQuery '|| dbQuery);
		EXECUTE IMMEDIATE (dbQuery1);
		EXECUTE IMMEDIATE (dbQuery2);
		IF SQL%ROWCOUNT = 1
		THEN
		DBString := FALSE;
		ELSE
		DBString := TRUE;
		END IF;
		--dbms_output.put_line ('LogUpdate completed with status: ');
		RETURN DBString;
		END;
	END;
	
	
	FUNCTION LogUpdateError(v_stepNumber Number)
	RETURN BOOLEAN
	as
	DBString   BOOLEAN;
	dbQuery VARCHAR2(1000);
	BEGIN
		BEGIN
		dbQuery := 'UPDATE WFVERSIONUPGRADELOGTABLE set ENDDATE = SYSTIMESTAMP,STATUS = ''FAILED'' WHERE STEPNUMBER = ' ||v_stepNumber|| ' AND SCRIPTNAME ='''|| v_scriptName ||'''';
		--dbms_output.put_line ('dbQuery '|| dbQuery);
		EXECUTE IMMEDIATE (dbQuery);
		IF SQL%ROWCOUNT = 1
		THEN
		DBString := FALSE;
		ELSE
		DBString := TRUE;
		END IF;
		--dbms_output.put_line ('LogUpdateError completed with status: ');
		RETURN DBString;
		END;
	END;
	
BEGIN


	v_logStatus := LogInsert(1,'Creating view WFSearchView_');
	BEGIN
		v_logStatus := LogSkip(1);
		OPEN changeview_cur;
		LOOP
			FETCH changeview_cur INTO v_QueueId;
				EXIT WHEN changeview_cur%NOTFOUND;
				
				v_viewname := 'WFSearchView_' || v_QueueId;
				
				select COUNT(1) INTO EXISTFLAG from user_views where UPPER(VIEW_NAME) = upper(v_viewname);
				IF (EXISTFLAG > 0) THEN
				BEGIN
					v_Query := ' DROP VIEW WFSearchView_' || v_QueueId;
					EXECUTE IMMEDIATE TO_CHAR(v_Query);
				END;
				END IF;	
		END LOOP;
		CLOSE changeview_cur;


	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(1);   
			raise_application_error(-20201,v_scriptName ||' BLOCK 1 FAILED');
	END;
	v_logStatus := LogUpdate(1);


	/*v_logStatus := LogInsert(2,'Creating view WFSearchView_0 ');
	BEGIN
		v_logStatus := LogSkip(2);
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
						v_varStr := v_varStr + ' Processinstancetable.' + v_param1_view;
					ELSE
						v_varStr := v_varStr || ' , ' || v_param1_view;
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
		CLOSE changeview_Alias_cur; */


	
	
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
	/*	Begin
			dbms_output.put_line('WFSearchView_0 created ... ' );
		End;
		
		
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(2);   
			raise_application_error(-20202,v_scriptName ||' BLOCK 2 FAILED');
	END;
	v_logStatus := LogUpdate(2);*/

End; 

~ 
	Call update_searchview() 
~ 
	Drop Procedure update_searchview 
~
