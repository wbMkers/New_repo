/*
--------------------------------------------------------------------------------------------------
		NEWGEN SOFTWARE TECHNOLOGIES LIMITED
	Group				: Genesis
	Product				: iBPS 4.0
	Module				: Omniflow Server
	File Name			: WFGetNextWIForArchiveAudit.sql
	Author				: Ravi Ranjan Kumar
	Date written		: 8/04/2019
	Description			: This procedure will fetch and return next record for Audit Archive utility
----------------------------------------------------------------------------------------------------
				CHANGE HISTORY
----------------------------------------------------------------------------------------------------
Date		Change By			Change Description (Bug No. (If Any))
----------------------------------------------------------------------------------------------------
8/04/2019	Ravi Ranjan Kumar		Bug 83490 - PRDP Bug Metging (Audit Archive utility gets stuck if an error occurs in processing a record)
----------------------------------------------------------------------------------------------------
*/


CREATE OR REPLACE FUNCTION WFGetNextWIForArchiveAudit ( 
	DBSessionId		INTEGER,
	DBCSName		VARCHAR
) returns SETOF refcursor AS $$

DECLARE
	v_RowCount INTEGER;
	v_DBStatus INTEGER;
	v_PSId PSREGISTERATIONTABLE.PSID%Type;
	v_PSName PSREGISTERATIONTABLE.PSNAME%Type;
	v_ProcessInstanceId WFAuditTrailDocTable.ProcessInstanceId%Type;
	v_Workitemid WFAuditTrailDocTable.WorkitemId%Type;
	v_ActivityId WFAuditTrailDocTable.ActivityId%Type;
	v_QueryStr VARCHAR(1000);
	v_urn VARCHAR (63);
	
	out_mainCode	INTEGER;
	out_PSId		INTEGER;
	out_PSName		VARCHAR;
	out_CSSessionId	INTEGER;
	
	ResultSet0		REFCURSOR;
	ResultSet		REFCURSOR;
	
BEGIN
	out_MainCode := 0;
	v_RowCount := 0;
	out_CSSessionId := 0;
	
	
	SELECT PSReg.PSID,PSReg.PSName INTO v_PSId, v_PSName FROM PSRegisterationTable PSReg ,WFPSConnection PSCon WHERE PSCon.SESSIONID = DBSessionId and PSReg.PSID = PSCon.PSID;
	GET DIAGNOSTICS v_RowCount = ROW_COUNT;
	out_PSId := v_PSId;
	out_PSName := v_PSName;
	IF(NOT FOUND) THEN
		v_RowCount :=0;
		v_DBStatus :=11;
	END IF;

	IF(v_DBStatus <> 0 OR v_RowCount <= 0) THEN
		out_MainCode :=11;
		OPEN ResultSet0 FOR SELECT out_mainCode AS MainCode, NULL AS CSSessionId, NULL as PSId, NULL AS PSName;
		RETURN NEXT ResultSet0;
		RETURN;
	END IF;
	
	SELECT SessionID INTO out_CSSessionId FROM PSRegisterationTable WHERE PSName = DBCSName AND Type = 'C';
	IF(NOT FOUND) THEN
			v_RowCount :=0;
	END IF;
	
	BEGIN
		BEGIN
		SELECT ProcessInstanceId, WorkitemId, ActivityId INTO v_ProcessInstanceId, v_Workitemid, v_ActivityId FROM WFAuditTrailDocTable WHERE Status = 'R' LIMIT 1;
		GET DIAGNOSTICS v_RowCount = ROW_COUNT;
		IF(v_RowCount <= 0 ) THEN
			BEGIN
			SELECT ProcessInstanceId, WorkitemId, ActivityId INTO v_ProcessInstanceId, v_Workitemid, v_ActivityId FROM WFAuditTrailDocTable WHERE Status = 'L' AND LockedBy = v_PSName LIMIT 1;
			GET DIAGNOSTICS v_RowCount = ROW_COUNT;
			IF (v_RowCount <=0) THEN
				out_MainCode :=18;
				OPEN ResultSet0 FOR SELECT out_mainCode AS MainCode, out_CSSessionId AS CSSessionId, out_PSId as PSId, out_PSName AS PSName;
				RETURN NEXT ResultSet0;
				RETURN;
			END IF;
			EXCEPTION WHEN OTHERS THEN
				out_MainCode :=15;
				raise notice 'WFGetNextWorkitemforArchiveAudit: Error in fetching next locked record';
				OPEN ResultSet0 FOR SELECT out_mainCode AS MainCode,out_PSId as PSId, out_PSName AS PSName,out_CSSessionId AS CSSessionId ;
				RETURN NEXT ResultSet0;
				RETURN;
			END;	
		ELSE
			BEGIN
			UPDATE WFAuditTrailDocTable SET Status = 'L', LockedBy = v_PSName WHERE ProcessInstanceId = v_ProcessInstanceId AND WorkitemId = v_Workitemid AND ActivityId = v_ActivityId;
			EXCEPTION WHEN OTHERS THEN
				out_MainCode :=15;
				raise notice 'WFGetNextWorkitemforArchiveAudit: Status for fetched record is not updated';
				OPEN ResultSet0 FOR SELECT out_mainCode AS MainCode, out_CSSessionId AS CSSessionId, out_PSId as PSId, out_PSName AS PSName;
				RETURN NEXT ResultSet0;
				RETURN;
			END;
		END IF;
		EXCEPTION WHEN OTHERS THEN
			out_MainCode :=15;
			raise notice 'WFGetNextWorkitemforArchiveAudit: Error in fetching next unlocked record';
			OPEN ResultSet0 FOR SELECT out_mainCode AS MainCode, out_CSSessionId AS CSSessionId, out_PSId as PSId, out_PSName AS PSName;
			RETURN NEXT ResultSet0;
			RETURN;
		END;

		SELECT URN into v_URN from WFInstrumentTable where  processinstanceid=v_ProcessInstanceId and workitemid=v_Workitemid;
		
	END;
	OPEN ResultSet0 FOR SELECT out_mainCode AS MainCode, out_CSSessionId AS CSSessionId, out_PSId as PSId, out_PSName AS PSName;
	RETURN NEXT ResultSet0;
	v_QueryStr := 'SELECT ProcessDefId, ProcessInstanceId, WorkitemId, ActivityId, DocId, ParentFolderIndex, VolId, AppServerIP, AppServerPort, AppServerType, EngineName, DeleteAudit, '''||v_URN||'''  URN FROM WFAuditTrailDocTable WHERE ProcessInstanceId ='''||COALESCE(v_ProcessInstanceId,'') ||''' AND WorkitemId = ' ||v_Workitemid||' AND ActivityId = '||v_ActivityId;
	OPEN ResultSet FOR EXECUTE V_QueryStr;
	RETURN NEXT ResultSet;
	RETURN;
END;
$$LANGUAGE plpgsql;
		
	