/*__________________________________________________________________________________________________
			NEWGEN SOFTWARE TECHNOLOGIES LIMITED
______________________________________________________________________________________________
	Group						: Genesis
	Product / Project			: iBPS
	Module						: Server and Services
	File Name					: WFEscalateWorkitem.sql
	Author						: Sajid Khan
	Date written (DD/MM/YYYY)	: 26 May 2016
	Description					: To be scheduled on database server, this will 
								  move candidate records [escalation mail item] from
								  WFEscalationTable to WFMailQueueTable.
______________________________________________________________________________________________
				CHANGE HISTORY
______________________________________________________________________________________________
Date			Change By			Change Description (Bug No. (If Any))
_____________________________________________________________________________________________
27/07/2016		Mohnish Chopra		Bug 63118 - Postgres : Escalate to & Escalate with mail trigger is not working
10/08/2016		Ambuj Triapthi		Added changes for the task Escalation feature in Case Management
				Sajid Khan			PRDP Bug 69029 Need to send escalation mail after every defined time	
31/08/2016		Ambuj Triapthi		Added UT bug fixes for task Escalation feature in Case Management
14/09/2017      Kumar Kimil         Handling of Expired flag and Escalated flag	
26/09/2017      Ambuj Tripathi  UT Bug#72140 fixed	
24/07/2019      Shubham Singla      Bug 85726 - iBPS 4.0 +Postgres: Escalate to with trigger is not working in Postgres case.		
16/10/2019		Ambuj Tripathi		Bug 87387 - IBPS 4.0 + PostgresDB :: Getting SQL error while executing wfescalateworkitem procedure  
28/06/2021      Sourabh Tantuway    Bug 100026 - iBPS 4.0 SP0+postgres: Error is coming related to invalid addition of TimeStamp and integer datatypes, while running the WFEscalateWorkitem procedure. This is coming if "repeat after" checkbox is used in escalation criteria.
20/09/2022      Nikhil Garg         Bug 115892 - IBPS 5.0 SP2- Incorrect table name in select query in WFESCALATEWORKITEM.sql
____________________________________________________________________________________________*/

CREATE OR REPLACE FUNCTION WFEscalateWorkitem() RETURNS INTEGER AS  $$
	DECLARE 
		v_escalateId			INTEGER; 
		v_processDefId			INTEGER; 
		v_activityId			INTEGER; 
		v_processInstanceId		VARCHAR(64); 
		v_workitemId			INTEGER; 
		v_activityName			VARCHAR(30); 
		v_concernedAuthInfo		VARCHAR(2000); 
		v_fieldName				VARCHAR(2000);
		existsFlag				INTEGER;
		v_QueryStr				VARCHAR(8000);
		v_actionId				INTEGER;
		v_EscalationType		VARCHAR(1);
		v_ResendDurationMinutes	INTEGER;
		v_taskId				INTEGER;
		v_taskName				VARCHAR(30); 
		v_isValidTask			Integer;
		v_MainCode INTEGER;

		v_cursor_Escalate	CURSOR FOR  SELECT escalationId, processDefid, activityId, processInstanceId, workitemId, concernedAuthInfo,EscalationType, ResendDurationMinutes, coalesce(taskId,0)	From WFEscalationTable WHERE ScheduleTime <= CURRENT_TIMESTAMP AND UPPER(EscalationMode) = 'MAIL';
	BEGIN
		 v_MainCode := 0;
		/*DELETE FROM WFEscInProcessTable;

		INSERT INTO WFEscInProcessTable 
			SELECT * FROM WFEscalationTable 
				WHERE UPPER(EscalationMode) = 'MAIL' 
				AND	ScheduleTime <= CURRENT_TIMESTAMP;*/

		OPEN v_cursor_Escalate;
		LOOP
			FETCH v_cursor_Escalate INTO v_escalateId, v_processDefId, v_activityId, v_processInstanceId, v_workitemId, v_concernedAuthInfo
			,v_EscalationType, v_ResendDurationMinutes,v_taskId; 
			EXIT WHEN NOT FOUND;
			
			IF v_activityId < 0 THEN
				v_isValidTask  := 0;
				
				select 1 into v_isValidTask from wftaskstatustable where ProcessInstanceId = v_processInstanceId and WorkitemId = v_workitemId and ProcessDefId = v_processDefId and ActivityId = -v_activityId and TaskId = v_taskId and TaskStatus in (2, 6);				
				
				IF v_isValidTask = 0 OR v_taskId = 0 THEN
					CONTINUE;
				ELSE
				v_activityId:= -v_activityId;
				v_actionId := 711;
				SELECT INTO v_taskName TaskName 
				From wftaskdeftable 
				WHERE ProcessDefId = v_processDefId AND	TaskId = v_taskId ;
				
					UPDATE WFTaskStatusTable SET EscalatedFlag='Y' where processInstanceId=v_processInstanceId and ProcessDefId = v_processDefId and TaskId =v_taskId and activityId=v_activityId;
				END IF;
			ELSE
				v_actionId := 73;
				v_taskName := '';
			END IF;
			SELECT INTO v_activityName ActivityName 
			From ActivityTable 
			WHERE ProcessDefId = v_processDefId AND	ActivityId = v_activityId;

			INSERT INTO WFMailQueueTable
			(
				MAILFROM, MAILTO, MAILCC, MAILSUBJECT, 
				MAILMESSAGE, MAILCONTENTTYPE, ATTACHMENTISINDEX, ATTACHMENTNAMES, 
				ATTACHMENTEXTS, MAILPRIORITY, MAILSTATUS, STATUSCOMMENTS, 
				LOCKEDBY, SUCCESSTIME, LASTLOCKTIME, INSERTEDBY, 
				MAILACTIONTYPE, INSERTEDTIME, PROCESSDEFID, PROCESSINSTANCEID, 
				WORKITEMID, ACTIVITYID, NOOFTRIALS,ZIPFLAG,ZIPNAME,MAXZIPSIZE,ALTERNATEMESSAGE,MAILBCC
			)
			SELECT FromId, ConcernedAuthInfo, CCId, Comments,
					message, 'text/html',NULL,NULL,
					NULL, 1, 'N', NULL,
					NULL, NULL, NULL, 'SYSTEM',
					'ESCALATIONRULE', CURRENT_TIMESTAMP, processDefId, processInstanceId,
					workitemId, -activityId, 0,'N',null,0,null,BCCId
			FROM WFEscalationTable WHERE EscalationId = v_escalateId ;
			
			IF(v_EscalationType = 'R' AND v_ResendDurationMinutes IS NOT NULL AND v_ResendDurationMinutes <> 0) THEN
			BEGIN
				UPDATE WFEscalationTable SET ScheduleTime = CURRENT_TIMESTAMP + (v_ResendDurationMinutes * interval '1 minute') WHERE EscalationId = v_escalateId;
			END;
			ELSE
			BEGIN
				Delete From WFEscalationTable Where EscalationId = v_escalateId;
			END;
			END IF;
			--DELETE FROM WFEscalationTable WHERE EscalationId = v_escalateId; 
			
			v_fieldName := '<Mode>MAIL</Mode><ConcernedAuthInfo>' || v_ConcernedAuthInfo || '</ConcernedAuthInfo>';
			
			v_MainCode:=WFGenerateLog(v_actionId,  0,v_processDefId,v_activityId, 0, 'SYSTEM', coalesce(v_activityName,'0'), 0, v_processInstanceId, 0 ,v_fieldName , v_workitemId , 0 , 0 , NULL , 0 , v_taskId , 0, NULL,NULL);
		
		END LOOP;
		CLOSE v_cursor_Escalate;
		
		RETURN 1;
	END;

$$ LANGUAGE plpgsql;