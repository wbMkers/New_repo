/*---------------------------------------------------------------------------------------------------
		NEWGEN SOFTWARE TECHNOLOGIES LIMITED
	Group				: Genesis
	Product / Project	: OmniFlow 9.0
	Module				: Transaction Server
	File Name			: WFGetMailQueueItem.sql
	Author				: Ashutosh Pandey
	Date written		: May 26th 2016
	Description			: This procedure will return the next Mail Item for processing
-----------------------------------------------------------------------------------------------------
				CHANGE HISTORY
-----------------------------------------------------------------------------------------------------
Date			Change By		Change Description (Bug No. (If Any))
-----------------------------------------------------------------------------------------------------
26/05/2016		Ashutosh Pandey	Bug 59010 - Mailing Agent Enhancement : 1) Option to filter mail items 2) Optimization in WFGetMailQueueItem API 3) Purge mechanism for old mail items
22/04/2018	    Kumar Kimil		Bug 77269 - CheckMarx changes (High Severity) 
23/04/2020      Shubham Singla  Bug 91759 - iBPS 4.0:-MailStatus is not getting updated while fetching the workitem for mail.
03/05/2021      Shubham Singla  Bug 99288 - iBPS 5.0 SP1+Oracle:Multiple mails are getting triggered for a single entry if two or more mailing utilities are started in different nodes.
----------------------------------------------------------------------------------------------------*/

CREATE OR REPLACE PROCEDURE WFGetMailQueueItem (
	temp_v_AgentName NVARCHAR2,
	v_NoOfTrials INT,
	temp_v_MailFilter NVARCHAR2,
	v_TaskId OUT NUMBER
)
AS
	v_Query VARCHAR2(2000);
	v_AgentName NVARCHAR2(2000);
	v_MailFilter NVARCHAR2(2000);
	v_quoteChar CHAR(1);
BEGIN
	v_quoteChar := CHR(39);
	v_TaskId := 0;
	--v_AgentName:=temp_v_AgentName;
	--v_MailFilter:=temp_v_MailFilter;
	IF(temp_v_AgentName is NOT NULL) THEN
	--v_AgentName:=REPLACE(temp_v_AgentName,v_quoteChar,v_quoteChar||v_quoteChar);
	SELECT sys.DBMS_ASSERT.noop(temp_v_AgentName) into v_AgentName FROM dual;
	END IF;
	IF(temp_v_MailFilter is NOT NULL) THEN
	--v_MailFilter:=REPLACE(temp_v_MailFilter,v_quoteChar,v_quoteChar||v_quoteChar);
	--v_MailFilter:=REPLACE(temp_v_MailFilter,v_quoteChar||v_quoteChar,v_quoteChar);
	SELECT sys.DBMS_ASSERT.noop(temp_v_MailFilter) into v_MailFilter FROM dual;
	END IF;
	BEGIN
		v_Query := 'SELECT TaskId FROM WFMailQueueTable WHERE MailStatus = ''N'' AND NoOfTrials < ' || CAST(v_NoOfTrials AS VARCHAR) || v_MailFilter || ' AND ROWNUM <= 1 ORDER BY TaskId ASC FOR UPDATE';
		
		EXECUTE IMMEDIATE v_Query INTO v_TaskId;
		v_Query := 'UPDATE WFMailQueueTable SET MailStatus = ''L'', LockedBy = ''' || v_AgentName || ''', LastLockTime = SYSDATE WHERE TaskId = ' || v_TaskId;
			EXECUTE IMMEDIATE v_Query;
		
	EXCEPTION WHEN NO_DATA_FOUND THEN
		BEGIN
			v_Query := 'SELECT TaskId FROM WFMailQueueTable WHERE MailStatus = ''L'' AND LockedBy = ''' || v_AgentName || ''' AND NoOfTrials < ' || CAST(v_NoOfTrials AS VARCHAR) || v_MailFilter || ' AND ROWNUM <= 1 and LastLockTime <  (SYSDATE-to_char(5/86400)) ORDER BY TaskId ASC';
			EXECUTE IMMEDIATE v_Query INTO v_TaskId;
		EXCEPTION WHEN NO_DATA_FOUND THEN
			v_TaskId := 0;
		END;
	END;
END;