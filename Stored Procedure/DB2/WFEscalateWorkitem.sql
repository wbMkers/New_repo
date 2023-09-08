/*--------------------------------------------------------------------------------------------
			NEWGEN SOFTWARE TECHNOLOGIES LIMITED
----------------------------------------------------------------------------------------------
	Group				: Phoenix
	Product / Project		: WorkFlow 7.0
	Module				: Transaction Server
	File Name			: WFEscalateWorkitem.sql [DB2]
	Author				: Ruhi Hira
	Date written (DD/MM/YYYY)	: 23/06/2006
	Description			: To be scheduled on database server, this will
					  move candidate records [escalation mail item] from
					  WFEscalationTable to WFMailQueueTable.
----------------------------------------------------------------------------------------------
				CHANGE HISTORY
----------------------------------------------------------------------------------------------
Date			Change By		Change Description (Bug No. (If Any))
15/02/2007	    Varun Bhansaly	Bugzilla Id 74 (Inconsistency in date-time)


----------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------*/

CREATE PROCEDURE WFEscalateWorkitem
LANGUAGE SQL
BEGIN
	DECLARE v_escalateId		Integer;
	DECLARE v_processDefId		Integer;
	DECLARE v_activityId		Integer;
	DECLARE v_processInstanceId	VARGRAPHIC(64);
	DECLARE v_workitemId		Integer;
	DECLARE v_activityName		VARGRAPHIC(30);
	DECLARE v_concernedAuthInfo	VARGRAPHIC(255);

	DECLARE at_end			SMALLINT DEFAULT 0;

	DECLARE v_Cursor_CNT		SMALLINT DEFAULT 0;
	DECLARE v_Cursor_str		VARCHAR(2000);
	DECLARE v_Cursor_stmt		STATEMENT;
	DECLARE v_Cursor		CURSOR FOR v_Cursor_stmt;

	SET v_Cursor_str = 'Select escalationId, processDefid, activityId, processInstanceId, workitemId, concernedAuthInfo From WFEscInProcessTable';
	Delete From WFEscInProcessTable;
	Insert Into WFEscInProcessTable
	Select *
	From WFEscalationTable
	Where	Upper(RTRIM(EscalationMode)) = N'MAIL'
	And	ScheduleTime <= Current TimeStamp;

	PREPARE v_Cursor_stmt FROM v_Cursor_str;
	Open v_Cursor;
	SET at_end = 0;
	BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION, NOT FOUND, SQLWARNING
		BEGIN
			SET at_end = 1;
			-- RESIGNAL;
		END;

		WHILE (at_end = 0) DO
			FETCH v_Cursor INTO v_escalateId, v_processDefId, v_activityId, v_processInstanceId, v_workitemId, v_concernedAuthInfo;
			Select activityName INTO v_activityName From ActivityTable
			Where	ProcessDefId = v_processDefId
			And	ActivityId = v_activityId;
			SAVEPOINT E_TRANS ON ROLLBACK RETAIN CURSORS;
				Insert Into WFMailQueueTable
					(MAILFROM, MAILTO, MAILSUBJECT,
					MAILMESSAGE, MAILCONTENTTYPE, MAILPRIORITY,
					MAILSTATUS, INSERTEDBY, MAILACTIONTYPE,
					INSERTEDTIME, PROCESSDEFID, PROCESSINSTANCEID,
					WORKITEMID, ACTIVITYID, NOOFTRIALS)
				Select	N'OmniFlowSystem_do_not_reply@newgen.co.in', ConcernedAuthInfo, Comments,
					message, N'text/html', 1,
					N'N', N'SYSTEM', N'ESCALATIONRULE',
					Current TimeStamp, processDefId, processInstanceId,
					workitemId, activityId, 0
				From WFEscInProcessTable
				WHERE EscalationId = v_escalateId ;
				Delete From WFEscalationTable Where EscalationId = v_escalateId;
				/* Changed By Varun Bhansaly On 15/02/2007 For Bugzilla Bug Id 74*/
				Insert Into WFMessageTable (message, status, ActionDateTime)
				values	('<Message><ActionId>73</ActionId><UserId>0</UserId><ProcessDefId>' || char(v_processDefId) ||
					'</ProcessDefId><ActivityId>' || char(v_activityId) ||
					'</ActivityId><QueueId>0</QueueId><UserName>System</UserName><ActivityName>' ||
					v_ActivityName || '</ActivityName>' ||
					'<TotalWiCount>0</TotalWiCount><TotalDuration>0</TotalDuration><ActionDateTime>' ||
					to_char(Current TimeStamp, 'YYYY-MM-DD HH24:MI:SS') || '</ActionDateTime><EngineName></EngineName><ProcessInstance>' ||
					v_processInstanceId ||
					'</ProcessInstance><FiledId>0</FiledId><FieldName><Mode>MAIL</Mode><ConcernedAuthInfo>' ||
					v_ConcernedAuthInfo || '</ConcernedAuthInfo></FieldName><WorkitemId>' ||
					CHAR(v_workitemId) ||
					'</WorkitemId><TotalPrTime>0</TotalPrTime><DelayTime>0</DelayTime><WKInDelay>0</WKInDelay>' ||
					'<ReportType>D</ReportType><Flag>0</Flag></Message>',
					N'N', CURRENT TIMESTAMP
				);
			COMMIT;
		END WHILE;
	END;
End
