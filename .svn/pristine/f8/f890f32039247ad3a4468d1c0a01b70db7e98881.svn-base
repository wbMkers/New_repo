/*----------------------------------------------------------------------------------------------------
		NEWGEN SOFTWARE TECHNOLOGIES LIMITED
	Group				: Genesis
	Product / Project	: OmniFlow
	Module				: Transaction Server
	File Name			: WFUnlockWorkitems.sql
	Programmer			: Ashutosh Pandey
	Date written		: Mar 2nd 2017
	Description			: This stored procedure is wriiten to unlock the workitems which are locked for more than a specified time
------------------------------------------------------------------------------------------------------
	Parameter Description

	v_LockedTime   : Provide the no of hours. All the workitem which are locked for more than this hour will be unlocked.
	v_ProcessDefId : Provide this value if you want to unlock the workitems of a specified process otherwise 0.
	v_ActivityId   : Provide this value if you want to unlock the workitems of specified activity otherwise 0. ProcessDefId is must if it’s value is not 0.
------------------------------------------------------------------------------------------------------
				CHANGE HISTORY
------------------------------------------------------------------------------------------------------
Date			Change By		Change Description (Bug No. (If Any))
06-Apr-2107		Ashutosh Pandey	Bug 67688 - Requirement to unlock workitems which are locked for more than a specified time
----------------------------------------------------------------------------------------------------*/

CREATE OR REPLACE PROCEDURE WFUnlockWorkitems (
v_LockedTime INT,
v_ProcessDefId INT,
v_ActivityId INT,
v_tarHisLog	 NVARCHAR2 DEFAULT 'N',
v_targetCabinet	VARCHAR2 DEFAULT ''
)
AS
	v_Filter NVARCHAR2(1000);
	v_Query NVARCHAR2(2000);
	v_sQuery NVARCHAR2(2000);
	v_iProcessDefId INT;
	v_iActivityId INT;
	v_sProcessInstanceId NVARCHAR2(100);
	v_sWorkitemId NVARCHAR2(10);
	v_sActivityName NVARCHAR2(100);
	v_iQueueID INT;
	v_tLockedTime NVARCHAR2(100);
	v_sQueueType NVARCHAR2(10);
	v_sHistoryNew NVARCHAR2(1);
	TYPE v_CursorType IS REF CURSOR;
    v_cursor v_CursorType;
	v_rowCounter INT;
	v_quoteChar 			CHAR(1);
	v_MainCode   INTEGER;
BEGIN
	v_quoteChar := CHR(39);

	v_Filter := ' WHERE LockStatus = N''Y'' AND RoutingStatus = N''N''';

	IF(v_LockedTime IS NULL OR v_LockedTime < 1) THEN
		v_Filter := v_Filter || ' AND ((SYSDATE - LockedTime) * 24 * 60) >= 60';
	ELSE
		v_Filter := v_Filter || ' AND ((SYSDATE - LockedTime) * 24 * 60) >= ' || TO_CHAR(v_LockedTime * 60);
	END IF;

	IF(v_ProcessDefId IS NOT NULL AND v_ProcessDefId > 0) THEN
	BEGIN
		v_Filter := v_Filter || ' AND ProcessDefId = ' || TO_CHAR(v_ProcessDefId);
		IF(v_ActivityId IS NOT NULL AND v_ActivityId > 0) THEN
			v_Filter := v_Filter || ' AND ActivityId = ' || TO_CHAR(v_ActivityId);
		END IF;
	END;
	END IF;

	v_Filter := v_Filter || ' AND ROWNUM <= 100';

	v_Query := 'SELECT ProcessDefId, ActivityId, ProcessInstanceId, WorkitemId, ActivityName, Q_QueueID, TO_CHAR(LockedTime, ''YYYY-MM-DD HH24:MI:SS''), QueueType FROM WFInstrumentTable' || v_Filter;

	WHILE (1 = 1) LOOP
    BEGIN
		SAVEPOINT UnlockWorkitems;
		v_rowCounter := 0;
		OPEN v_cursor FOR TO_CHAR(v_Query);
		LOOP
			FETCH v_cursor INTO v_iProcessDefId, v_iActivityId, v_sProcessInstanceId, v_sWorkitemId, v_sActivityName, v_iQueueID, v_tLockedTime, v_sQueueType;
            EXIT WHEN v_cursor%NOTFOUND;
			v_sProcessInstanceId:=REPLACE(v_sProcessInstanceId,v_quoteChar,v_quoteChar||v_quoteChar);
			v_sWorkitemId:=REPLACE(v_sWorkitemId,v_quoteChar,v_quoteChar||v_quoteChar);
			v_sActivityName:=REPLACE(v_sActivityName,v_quoteChar,v_quoteChar||v_quoteChar);
			v_tLockedTime:=REPLACE(v_tLockedTime,v_quoteChar,v_quoteChar||v_quoteChar);
			v_sQuery := 'UPDATE WFInstrumentTable SET LockStatus = N''N'', LockedByName = NULL, LockedTime = NULL';
			IF(v_sQueueType = 'I' OR v_sQueueType = 'F' OR v_sQueueType = 'D' OR v_sQueueType = 'N') THEN
				v_sQuery := v_sQuery || ', Q_UserId = 0, AssignedUser = NULL';
			END IF;
			v_sQuery := v_sQuery || ' WHERE ProcessInstanceId = N''' || v_sProcessInstanceId || ''' AND WorkitemId = N''' || v_sWorkitemId || '''';
			EXECUTE IMMEDIATE TO_CHAR(v_sQuery);

			WFGenerateLog(8, 0, v_iProcessDefId, v_iActivityId, v_iQueueID, 'System', v_sActivityName, 0, v_sProcessInstanceId, 0, NULL, v_sWorkitemId, 0, 0, v_MainCode, NULL,NULL,0,0,NULL,NULL,NULL,v_tarHisLog,v_targetCabinet);
			v_rowCounter := v_rowCounter + 1;
		END LOOP;
		COMMIT;
		CLOSE v_cursor;
	EXCEPTION
		WHEN OTHERS THEN
		BEGIN
			ROLLBACK TO SAVEPOINT UnlockWorkitems;
            CLOSE v_cursor;
			v_rowCounter := 0;
		END;
	END;
	IF(v_rowCounter = 0) THEN
		EXIT;
	END IF;
	END LOOP;
END;

