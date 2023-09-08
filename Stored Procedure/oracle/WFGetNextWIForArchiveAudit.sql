/*
--------------------------------------------------------------------------------------------------
		NEWGEN SOFTWARE TECHNOLOGIES LIMITED
	Group				: Genesis
	Product				: OmniFlow 10.x
	Module				: Transaction Server
	File Name			: WFGetNextWIForArchiveAudit.sql
	Author				: Ashutosh Pandey
	Date written		: Mar 14, 2019
	Description			: This procedure will fetch and return next record for Audit Archive utility
----------------------------------------------------------------------------------------------------
				CHANGE HISTORY
----------------------------------------------------------------------------------------------------
Date		Change By			Change Description (Bug No. (If Any))
----------------------------------------------------------------------------------------------------
14/03/2019	Ashutosh Pandey		Bug 83490 - Audit Archive utility gets stuck if an error occurs in processing a record
8/04/2019	Ravi Ranjan Kumar		Bug 83490 - PRDP Bug Metging (Audit Archive utility gets stuck if an error occurs in processing a record)
----------------------------------------------------------------------------------------------------
*/
CREATE OR REPLACE PROCEDURE WFGetNextWIForArchiveAudit (
	DBSessionId INTEGER,
	DBCSName NVARCHAR2,
	out_MainCode OUT INT,
	out_PSId OUT INT,
	out_PSName OUT NVARCHAR2,
	out_CSSessionId OUT INT,
	out_RefCursor OUT ORACONSTPKG.DBLIST
)
AS
	v_RowCount INT;
	v_DBStatus INT;
	v_PSId PSREGISTERATIONTABLE.PSID%Type;
	v_PSName PSREGISTERATIONTABLE.PSNAME%Type;
	v_ProcessInstanceId WFAuditTrailDocTable.ProcessInstanceId%Type;
	v_Workitemid WFAuditTrailDocTable.WorkitemId%Type;
	v_ActivityId WFAuditTrailDocTable.ActivityId%Type;
	v_QueryStr VARCHAR2(1000);
	v_URN NVARCHAR2 (63);
	v_quoteChar 			CHAR(1);
	
BEGIN
	out_MainCode := 0;
	v_RowCount := 0;
	out_CSSessionId := 0;
	v_quoteChar := CHR(39);
	BEGIN
		SELECT PSReg.PSID, PSReg.PSName INTO v_PSId, v_PSName FROM PSRegisterationTable PSReg, WFPSConnection PSCon WHERE PSCon.SESSIONID = DBSessionId and PSReg.PSID = PSCon.PSID;
		v_RowCount := SQL%ROWCOUNT;
		v_DBStatus := SQLCODE;
		out_PSId := v_PSId;
		out_PSName := v_PSName;
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			v_RowCount := 0;
	END;

	IF(v_DBStatus <> 0 OR v_RowCount <= 0 ) THEN
	BEGIN
		out_MainCode := 11;
		RETURN;
	END;
	END IF;

	BEGIN
		SELECT SessionID INTO out_CSSessionId FROM PSRegisterationTable WHERE PSName = DBCSName AND Type = 'C';
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			v_RowCount := 0;
	END;

	BEGIN
		SAVEPOINT LockNextRecord;

		BEGIN
			SELECT ProcessInstanceId, WorkitemId, ActivityId INTO v_ProcessInstanceId, v_Workitemid, v_ActivityId FROM WFAuditTrailDocTable WHERE Status = 'R' AND ROWNUM <= 1 FOR UPDATE;
			v_RowCount := SQL%ROWCOUNT;
			v_DBStatus := SQLCODE;
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_RowCount := 0;
		END;

		IF(v_DBStatus <> 0) THEN
		BEGIN
			ROLLBACK TO SAVEPOINT LockNextRecord;
			out_MainCode := 15;
			raise_application_error(-20118, 'WFGetNextWorkitemforArchiveAudit: Error in fetching next unlocked record');
			RETURN;
		END;
		END IF;

		IF(v_RowCount <= 0) THEN
		BEGIN
			BEGIN
				SELECT ProcessInstanceId, WorkitemId, ActivityId INTO v_ProcessInstanceId, v_Workitemid, v_ActivityId FROM WFAuditTrailDocTable WHERE Status = 'L' AND LockedBy = v_PSName AND ROWNUM <= 1;
				v_RowCount := SQL%ROWCOUNT;
				v_DBStatus := SQLCODE;
			EXCEPTION
				WHEN NO_DATA_FOUND THEN
					v_RowCount := 0;
			END;

			IF(v_DBStatus <> 0) THEN
			BEGIN
				ROLLBACK TO SAVEPOINT LockNextRecord;
				out_MainCode := 15;
				raise_application_error(-20118, 'WFGetNextWorkitemforArchiveAudit: Error in fetching next locked record');
				RETURN;
			END;
			END IF;

			IF(v_RowCount <= 0) THEN
			BEGIN
				ROLLBACK TO SAVEPOINT LockNextRecord;
				out_MainCode := 18;
				RETURN;
			END;
			END IF;
		END;
		ELSE
		BEGIN
			UPDATE WFAuditTrailDocTable SET Status = 'L', LockedBy = v_PSName WHERE ProcessInstanceId = v_ProcessInstanceId AND WorkitemId = v_Workitemid AND ActivityId = v_ActivityId;
			v_RowCount := SQL%ROWCOUNT;
			v_DBStatus := SQLCODE;

			IF(v_DBStatus <> 0) THEN
			BEGIN
				ROLLBACK TO SAVEPOINT LockNextRecord;
				out_MainCode := 15;
				raise_application_error(-20118, 'WFGetNextWorkitemforArchiveAudit: Error in Updating status of fetched record');
				RETURN;
			END;
			END IF;

			IF (v_RowCount <= 0) THEN
			BEGIN
				ROLLBACK TO SAVEPOINT LockNextRecord;
				out_MainCode := 15;
				raise_application_error(-20118, 'WFGetNextWorkitemforArchiveAudit: Status for fetched record is not updated');
				RETURN;
			END;
			END IF;
		END;
		END IF;
		
		BEGIN
			SELECT URN into v_URN from WFInstrumentTable where  processinstanceid=v_ProcessInstanceId and workitemid=v_Workitemid;
			v_URN:=REPLACE(v_URN,v_quoteChar,v_quoteChar||v_quoteChar);
			v_RowCount := SQL%ROWCOUNT;
			v_DBStatus := SQLCODE;
			IF(v_DBStatus <> 0) THEN
			BEGIN
				ROLLBACK TO SAVEPOINT LockNextRecord;
				out_MainCode := 15;
				raise_application_error(-20118, 'WFGetNextWorkitemforArchiveAudit: Error in Fetching URN');
				RETURN;
			END;
			END IF;
		END;
		
		COMMIT;

		v_QueryStr := 'SELECT ProcessDefId, ProcessInstanceId, WorkitemId, ActivityId, DocId, ParentFolderIndex, VolId, AppServerIP, AppServerPort, AppServerType, EngineName, DeleteAudit, '''||v_URN||''' URN FROM WFAuditTrailDocTable WHERE ProcessInstanceId = :v_ProcessInstanceId AND WorkitemId = :v_Workitemid AND ActivityId = :v_ActivityId';
		OPEN out_RefCursor FOR v_QueryStr USING v_ProcessInstanceId, v_Workitemid, v_ActivityId;
	END;
END;