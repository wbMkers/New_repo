/*__________________________________________________________________________________________________
			NEWGEN SOFTWARE TECHNOLOGIES LIMITED
______________________________________________________________________________________________
	Group						: Phoenix
	Product / Project			: Omniflow 7.1
	Module						: WorkFlow Server
	File Name					: WFEscalateWorkitem.sql
	Author						: Varun Bhansaly
	Date written (DD/MM/YYYY)	: 17/11/2007
	Description					: To be scheduled on database server, this will 
								  move candidate records [escalation mail item] from
								  WFEscalationTable to WFMailQueueTable.
______________________________________________________________________________________________
				CHANGE HISTORY
______________________________________________________________________________________________
Date			Change By			Change Description (Bug No. (If Any))
_____________________________________________________________________________________________
____________________________________________________________________________________________*/

CREATE OR REPLACE FUNCTION WFEscalateWorkitem() RETURNS INTEGER AS '
	DECLARE 
		v_escalateId			INTEGER; 
		v_processDefId			INTEGER; 
		v_activityId			INTEGER; 
		v_processInstanceId		VARCHAR(64); 
		v_workitemId			INTEGER; 
		v_activityName			VARCHAR(30); 
		v_concernedAuthInfo		VARCHAR(255); 
		v_cursor_Escalate		CURSOR FOR 
								SELECT escalationId, processDefid, activityId, processInstanceId, workitemId, concernedAuthInfo	From WFEscInProcessTable;

	BEGIN
		DELETE FROM WFEscInProcessTable;

		INSERT INTO WFEscInProcessTable 
			SELECT * FROM WFEscalationTable 
				WHERE UPPER(EscalationMode) = ''MAIL'' 
				AND	ScheduleTime <= CURRENT_TIMESTAMP;

		OPEN v_cursor_Escalate;
		LOOP
			FETCH v_cursor_Escalate INTO v_escalateId, v_processDefId, v_activityId, v_processInstanceId, v_workitemId, v_concernedAuthInfo; 
			EXIT WHEN NOT FOUND;

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
				WORKITEMID, ACTIVITYID, NOOFTRIALS
			)
			SELECT ''OmniFlowSystem_do_not_reply@newgen.co.in'', ConcernedAuthInfo, NULL, Comments,
					message, ''text/html'',	NULL, NULL,
					NULL, 1, ''N'', NULL,
					NULL, NULL, NULL, ''SYSTEM'',
					''ESCALATIONRULE'', CURRENT_TIMESTAMP, processDefId, processInstanceId,
					workitemId, activityId, 0
			FROM WFEscInProcessTable FOR UPDATE;

			DELETE FROM WFEscalationTable WHERE EscalationId = v_escalateId; 
			
			INSERT INTO WFMessageTable (message, status, ActionDateTime) VALUES
			(
				''<Message><ActionId>73</ActionId><UserId>0</UserId><ProcessDefId>'' || v_processDefId || 
				''</ProcessDefId><ActivityId>'' || v_activityId || 
				''</ActivityId><QueueId>0</QueueId><UserName>System</UserName><ActivityName>'' || 
				v_ActivityName || ''</ActivityName>'' || ''<TotalWiCount>0</TotalWiCount><TotalDuration>0</TotalDuration><ActionDateTime>'' || 
				TO_CHAR(CURRENT_TIMESTAMP, ''YYYY-MM-DD HH24:MI:SS'') || ''</ActionDateTime><EngineName></EngineName><ProcessInstance>'' || 
				v_processInstanceId || ''</ProcessInstance><FiledId>0</FiledId><FieldName><Mode>MAIL</Mode><ConcernedAuthInfo>'' || 
				v_ConcernedAuthInfo || ''</ConcernedAuthInfo></FieldName><WorkitemId>'' || v_workitemId || 
				''</WorkitemId><TotalPrTime>0</TotalPrTime><DelayTime>0</DelayTime><WKInDelay>0</WKInDelay>'' || 
				''<ReportType>D</ReportType><Flag>0</Flag></Message>'', ''N'', CURRENT_TIMESTAMP
			);
		
		END LOOP;
		CLOSE v_cursor_Escalate;
		
		RETURN 1;
	END;
'
LANGUAGE 'plpgsql';