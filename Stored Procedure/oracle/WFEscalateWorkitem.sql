/*--------------------------------------------------------------------------------------------
			NEWGEN SOFTWARE TECHNOLOGIES LIMITED
----------------------------------------------------------------------------------------------
	Group				: Application – Products
	Product / Project		: WorkFlow 6.0
	Module				: Transaction Server
	File Name			: WFEscalateWorkitem.sql [Oracle]
	Author				: Ruhi Hira
	Date written (DD/MM/YYYY)	: 18/08/2005
	Description			: To be scheduled on database server, this will 
					  move candidate records [escalation mail item] from
					  WFEscalationTable to WFMailQueueTable.
----------------------------------------------------------------------------------------------
				CHANGE HISTORY
----------------------------------------------------------------------------------------------
Date			Change By		Change Description (Bug No. (If Any))
25/08/2005		Ruhi Hira		Bug # WFS_6.1_029.
15/02/2007	    Varun Bhansaly	Bugzilla Id 74 (Inconsistency in date-time)
01/05/2013      Kahkeshan       Bug 39079 - EscalateToWithTrigger Feature requirement
27/05/2014      Kanika Manik    PRD Bug 42494 - BCC support at each email sending modules
05/06/2014      Kanika Manik    PRD Bug 42185 - [Replicated]RTRIM should be removed
10/08/2016		Ambuj Triapthi	Added changes for the task Escalation feature in Case Management
20/08/2017		Sajid Khan		PRDP Bug 69029 Need to send escalation mail after every defined time
31/08/2016		Ambuj Triapthi		Added UT bug fixes for task Escalation feature in Case Management
14/09/2017      Kumar Kimil         Handling of Expired flag and Escalated flag	
26/09/2017      Ambuj Tripathi  UT Bug#72140 fixed
----------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------*/

CREATE OR REPLACE PROCEDURE WFEscalateWorkitem
AS
	v_escalateId		Integer;
	v_processDefId		Integer;
	v_activityId		Integer;
	v_processInstanceId	NVarchar2(64);
	v_workitemId		Integer;
	v_activityName		NVarchar2(30);
	v_concernedAuthInfo	NVarchar2(2000);
	v_fieldName			NVarchar2(2000);
	v_actionId			Integer;
	v_EscalationType	NVARCHAR2(1);
	v_ResendDurationMinutes	INTEGER;
	v_taskId			Integer;
	v_taskName			NVarchar2(30);
	v_isValidTask		Integer;
	v_MainCode INTEGER;
	v_tarHisLog	 NVARCHAR2(10) DEFAULT 'N';
    v_targetCabinet	VARCHAR2(100) DEFAULT '';

	CURSOR escalate_Cur IS
		Select	escalationId, processDefid, activityId, processInstanceId, workitemId, concernedAuthInfo, EscalationType, ResendDurationMinutes,NVL(taskId,0)
		From	WFEscalationTable  Where ScheduleTime <= sysDate  AND Upper(EscalationMode) = N'MAIL';
Begin
	
	/* Bug # Bug # WFS_6.1_029 , delete from WFEscInProcessTable in the beginning only - Ruhi Hira*/ 
	/*Delete From WFEscInProcessTable;

	Insert Into WFEscInProcessTable
	Select * 
	From WFEscalationTable
	Where	Upper(EscalationMode) = N'MAIL'
	And	ScheduleTime <= sysDate;*/
	v_MainCode := 0;

	Open escalate_Cur;
	LOOP
		FETCH escalate_Cur INTO v_escalateId, v_processDefId, v_activityId, v_processInstanceId, v_workitemId, v_concernedAuthInfo,v_EscalationType, v_ResendDurationMinutes, v_taskId;
		EXIT WHEN escalate_Cur%NOTFOUND;
		
		/*Changes done for task expiry*/
		IF v_activityId < 0 THEN
			v_isValidTask := 0;
			select 1 into v_isValidTask from wftaskstatustable where ProcessInstanceId = v_processInstanceId and WorkitemId = v_workitemId and ProcessDefId = v_processDefId and ActivityId = -v_activityId and TaskId = v_taskId and TaskStatus in (2, 6);
			
			IF v_isValidTask = 0 THEN
				CONTINUE;
			ELSE
			v_activityId := -v_activityId;
			v_actionId := 711;		/* ActionID for Task Escalation*/
			select TaskName into v_taskName from Wftaskdeftable where ProcessDefId = v_processDefId and TaskId = v_taskId;
				UPDATE WFTaskStatusTable SET EscalatedFlag='Y' where processInstanceId=v_processInstanceId and ProcessDefId = v_processDefId and TaskId = v_taskId and activityId=v_activityId;
			
			END IF;
		ELSE
			v_actionId := 73;
		END IF;
		/*Changes done for task expiry ends here*/
		
		Select activityName INTO v_activityName From ActivityTable
		Where	ProcessDefId = v_processDefId
		And	ActivityId = v_activityId;

		SAVEPOINT E_TRANS;

			Insert Into WFMailQueueTable
				(MAILFROM, MAILTO, MAILCC, MAILSUBJECT, 
				MAILMESSAGE, MAILCONTENTTYPE, ATTACHMENTISINDEX, ATTACHMENTNAMES, 
				ATTACHMENTEXTS, MAILPRIORITY, MAILSTATUS, STATUSCOMMENTS, 
				LOCKEDBY, SUCCESSTIME, LASTLOCKTIME, INSERTEDBY, 
				MAILACTIONTYPE, INSERTEDTIME, PROCESSDEFID, PROCESSINSTANCEID, 
				WORKITEMID, ACTIVITYID, NOOFTRIALS,ZIPFLAG,ZIPNAME,MAXZIPSIZE,ALTERNATEMESSAGE,MAILBCC)
			Select	FromId, ConcernedAuthInfo, CCId, Comments,
				message, 'text/html', null, null,
				null, 1, N'N', null,
				null, null, null, 'SYSTEM',
				'ESCALATIONRULE', sysDate, processDefId, processInstanceId,
				workitemId, -activityId, 0, 'N',null,0,null,BCCId
			From WFEscalationTable 
			WHERE EscalationId = v_escalateId ;
			
			
			IF(v_EscalationType = 'R' AND v_ResendDurationMinutes IS NOT NULL AND v_ResendDurationMinutes <> 0) THEN
			BEGIN
				UPDATE WFEscalationTable SET ScheduleTime = SYSDATE + (v_ResendDurationMinutes/1440) WHERE EscalationId = v_escalateId;
			END;
			ELSE
			BEGIN
				Delete From WFEscalationTable Where EscalationId = v_escalateId;
			END;
			END IF;
			--Delete From WFEscalationTable Where EscalationId = v_escalateId;
			/* Changed By Varun Bhansaly On 15/02/2007 For Bugzilla Bug Id 74*/
			/*Insert Into WFMessageTable (messageId, message, status, ActionDateTime)
			values	(Seq_messageid.nextval,
				'<Message><ActionId>73</ActionId><UserId>0</UserId><ProcessDefId>' || to_nchar(v_processDefId) || 
				'</ProcessDefId><ActivityId>' || to_nchar(v_activityId) || 
				'</ActivityId><QueueId>0</QueueId><UserName>System</UserName><ActivityName>' || 
				v_ActivityName || '</ActivityName>' || 
				'<TotalWiCount>0</TotalWiCount><TotalDuration>0</TotalDuration><ActionDateTime>' || 
				to_nchar(sysDate, 'YYYY-MM-DD HH24:MI:SS') || '</ActionDateTime><EngineName></EngineName><ProcessInstance>' || 
				v_processInstanceId || 
				'</ProcessInstance><FiledId>0</FiledId><FieldName><Mode>MAIL</Mode><ConcernedAuthInfo>' || 
				v_ConcernedAuthInfo || '</ConcernedAuthInfo></FieldName><WorkitemId>' || 
				to_nchar(v_workitemId) || 
				'</WorkitemId><TotalPrTime>0</TotalPrTime><DelayTime>0</DelayTime><WKInDelay>0</WKInDelay>' || 
				'<ReportType>D</ReportType><Flag>0</Flag></Message>',
				N'N', SYSDATE
			);*/
			 v_fieldName := '<Mode>MAIL</Mode><ConcernedAuthInfo>' || v_ConcernedAuthInfo || '</ConcernedAuthInfo>';
				
			 WFGenerateLog(v_actionId, 0, v_ProcessDefId, v_activityId, 0, 'System', v_ActivityName, 0, v_ProcessInstanceId, 0, v_fieldName, v_workitemId, 0, 0, v_MainCode,NULL,0,0,v_taskId,NULL,v_taskName,NULL,v_tarHisLog,v_targetCabinet);
			
		COMMIT;
	END LOOP;
	CLOSE escalate_Cur;

End;