/*---------------------------------------------------------------------------------------------------
		NEWGEN SOFTWARE TECHNOLOGIES LIMITED
	Group				: Genesis
	Product / Project	: OmniFlow 10X
	Module				: Transaction Server
	File Name			: WFGetMailQueueItem.sql
	Author				: SAJID KHAN
	Date written		: 13 JUNE 2016
	Description			: This procedure will return the next Mail Item for processing
-----------------------------------------------------------------------------------------------------
				CHANGE HISTORY
-----------------------------------------------------------------------------------------------------
Date			Change By		Change Description (Bug No. (If Any))
-----------------------------------------------------------------------------------------------------
22/04/2018  Ambuj Tripathi		Bug 76862 - Remove the db console messages from all procedures
----------------------------------------------------------------------------------------------------*/
CREATE OR REPLACE FUNCTION WFGetMailQueueItem (
	v_AgentName VARCHAR,
	v_NoOfTrials INTEGER,
	v_MailFilter VARCHAR
)RETURNS refcursor AS $$
DECLARE
	v_Query 		VARCHAR(2000);
	v_rowCount		INTEGER;
	v_TaskId		INTEGER;
	ResultSet		REFCURSOR;
BEGIN
	v_TaskId := 0;
	v_Query := 'SELECT TaskId FROM WFMailQueueTable WHERE MailStatus = ''N'' AND NoOfTrials < ' || CAST(v_NoOfTrials AS VARCHAR) || COALESCE(v_MailFilter,'') || ' ORDER BY TaskId ASC LIMIT 1 FOR UPDATE';
			EXECUTE  v_Query INTO v_TaskId;
			GET DIAGNOSTICS v_rowCount = ROW_COUNT;
			IF(v_rowCount>0) THEN
			v_Query := 'UPDATE WFMailQueueTable SET MailStatus = ''L'', LockedBy = ''' || v_AgentName || ''', LastLockTime = CURRENT_TIMESTAMP WHERE TaskId = ' || CAST(v_TaskId AS VARCHAR);
			EXECUTE  v_Query;
			ELSE 
				v_TaskId := 0;	
			END IF;
	
	IF(v_rowCount<=0) THEN
	v_Query := 'SELECT TaskId FROM WFMailQueueTable WHERE MailStatus = ''L'' AND LockedBy = ''' || v_AgentName || ''' AND NoOfTrials < ' || CAST(v_NoOfTrials AS VARCHAR) || COALESCE(v_MailFilter,'') || ' and LastLockTime < CURRENT_TIMESTAMP - INTERVAL ''5 second'' ORDER BY TaskId ASC LIMIT 1 ';
	EXECUTE v_Query INTO v_TaskId;
	 --RAISE NOTICE 'query %',v_Query;
	GET DIAGNOSTICS v_rowCount = ROW_COUNT;

	END IF;
	
	Open ResultSet For Select v_TaskId as TaskId;
	Return ResultSet;
END;
$$LANGUAGE plpgsql;