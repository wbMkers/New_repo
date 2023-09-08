/*__________________________________________________________________________________________________
			NEWGEN SOFTWARE TECHNOLOGIES LIMITED
______________________________________________________________________________________________
	Group						: Genesis.
	Product / Project			: Omniflow 10.1
	Module						: WorkFlow Server
	File Name					: WFUnlockWorkitem.sql
	Author						: Chitranshi Nitharia
	Date written (DD/MM/YYYY)	: 11-22-2021
	Description					: This is a utility stored procedure.
______________________________________________________________________________________________
*/
CREATE OR REPLACE FUNCTION WFUnlockWorkitem(
v_LockedTime INTEGER,
v_ProcessDefId INTEGER,
v_ActivityId INTEGER
)
RETURNS VOID AS $$
DECLARE
	v_Filter VARCHAR(1000);
	v_Query VARCHAR(2000);
	v_sQuery VARCHAR(2000);
	v_iProcessDefId INTEGER;
	v_iActivityId INTEGER;
	v_sProcessInstanceId VARCHAR(100);
	v_iWorkitemId INTEGER;
	v_sActivityName VARCHAR(100);
	v_iQueueID INTEGER;
	v_tLockedTime VARCHAR(100);
	v_sQueueType VARCHAR(10);
	v_sHistoryNew VARCHAR(1);
    v_cursor REFCURSOR;
	v_rowCounter INTEGER;
	v_seqRootLogId INTEGER;
	v_quoteChar 			CHAR(1);
	v_MainCode   INTEGER;
	v_logId		INTEGER;	
	v_genLog_mainCode	INTEGER;
BEGIN
	v_quoteChar := CHR(39);
	v_Filter := ' WHERE LockStatus = ''Y'' AND RoutingStatus = ''N''';
	IF(v_LockedTime IS NULL OR v_LockedTime < 1) THEN
		v_Filter := v_Filter || ' AND (SELECT (DATE_PART(''day'', now() - LockedTime) * 24 + DATE_PART(''hour'', now() -LockedTime)) * 60 + DATE_PART(''minute'', now() - LockedTime)) >= 60';
	ELSE
		v_Filter := v_Filter || ' AND (SELECT (DATE_PART(''day'', now() - LockedTime) * 24 + DATE_PART(''hour'', now() -LockedTime)) * 60 + DATE_PART(''minute'', now() - LockedTime)) >= ' ||v_LockedTime * 60;
	END IF;
	
	IF(v_ProcessDefId IS NOT NULL AND v_ProcessDefId > 0) THEN
		v_Filter := v_Filter || ' AND ProcessDefId = ' || (v_ProcessDefId);
		IF(v_ActivityId IS NOT NULL AND v_ActivityId > 0) THEN
			v_Filter := v_Filter || ' AND ActivityId = ' ||(v_ActivityId);
		END IF;
	END IF;
	v_Filter := v_Filter || ' limit 100';
	v_Query := 'SELECT ProcessDefId, ActivityId, ProcessInstanceId, WorkitemId, ActivityName, Q_QueueID,(LockedTime, ''YYYY-MM-DD HH24:MI:SS''), QueueType FROM WFInstrumentTable' || v_Filter;
	WHILE (1 = 1) LOOP
	BEGIN
		v_rowCounter := 0;
		OPEN v_cursor FOR EXECUTE v_Query;
		LOOP
			FETCH v_cursor INTO v_iProcessDefId, v_iActivityId, v_sProcessInstanceId, v_iWorkitemId, v_sActivityName, v_iQueueID, v_tLockedTime, v_sQueueType;
			EXIT WHEN NOT FOUND;
			v_sProcessInstanceId:=REPLACE(v_sProcessInstanceId,v_quoteChar,v_quoteChar||v_quoteChar);
			v_sActivityName:=REPLACE(v_sActivityName,v_quoteChar,v_quoteChar||v_quoteChar);
			v_tLockedTime:=REPLACE(v_tLockedTime,v_quoteChar,v_quoteChar||v_quoteChar);
			v_sQuery := 'UPDATE WFInstrumentTable SET LockStatus = ''N'', LockedByName = NULL, LockedTime = NULL';
			IF(v_sQueueType = 'I' OR v_sQueueType = 'F' OR v_sQueueType = 'D' OR v_sQueueType = 'N') THEN
				v_sQuery := v_sQuery || ', Q_UserId = 0, AssignedUser = NULL';
			END IF;
			v_sQuery := v_sQuery || ' WHERE ProcessInstanceId = ''' || v_sProcessInstanceId || ''' AND WorkitemId = ''' || v_iWorkitemId || '''';
			EXECUTE (v_sQuery);
			v_genLog_mainCode := WFGenerateLog(8, 0, v_iProcessDefId, v_iActivityId, v_iQueueID, 'System', v_sActivityName, 0, v_sProcessInstanceId, 0, NULL, v_iWorkitemId, 0, 0, NULL,0,0,0,NULL,NULL);
			v_rowCounter := v_rowCounter + 1;
		END LOOP;
		CLOSE v_cursor;
		IF(v_rowCounter = 0) THEN
			EXIT;
		END IF;
	EXCEPTION WHEN OTHERS THEN
		BEGIN
            IF EXISTS(SELECT * FROM pg_cursors WHERE name = 'v_cursor') THEN
				CLOSE v_cursor;
			END IF;
			v_rowCounter := 0;
			RAISE NOTICE 'SQL_ERROR : %, SQL_STATE : %', SQLERRM, SQLSTATE;
			EXIT;
		END;
	END;
	END LOOP;
END;
$$ LANGUAGE plpgsql;