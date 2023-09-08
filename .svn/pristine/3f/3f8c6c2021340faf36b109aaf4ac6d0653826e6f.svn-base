/*
--------------------------------------------------------------------------------------------------
		NEWGEN SOFTWARE TECHNOLOGIES LIMITED
	Group				: Genesis
	Product				: iBPS 4.0
	Module				: Omniflow Server
	File Name			: WFGetNextRowFromTable.sql
	Author				: Ravi Ranjan Kumar
	Date written		: 29/04/2019
	Description			: This procedure will fetch and return next record from import table
----------------------------------------------------------------------------------------------------
				CHANGE HISTORY
----------------------------------------------------------------------------------------------------
Date		Change By			Change Description (Bug No. (If Any))
----------------------------------------------------------------------------------------------------
29/04/2019	Ravi Ranjan Kumar		PRDP Bug Merging(Bug 84206 - Optimization in WFGetNextUnlockedRowFromTable API)
4/09/2019	Ravi Ranjan Kumar	Bug 86333 - Import Service is not working. WI are not getting created.
----------------------------------------------------------------------------------------------------
*/



CREATE OR REPLACE FUNCTION WFGetNextRowFromTable ( 
	DBSessionId		INTEGER,
	DBCSName		VARCHAR,
	TableName 		VARCHAR,
	FilterString	VARCHAR
) returns SETOF refcursor AS $$

DECLARE
	v_RowCount INT;
	v_DBStatus INT;
	v_PSId PSREGISTERATIONTABLE.PSID%Type;
	v_PSName PSREGISTERATIONTABLE.PSNAME%Type;
	v_ImportDataId INT;
	v_QueryStr VARCHAR(1000);
	
	out_MainCode	INT;
	out_CSSessionId	INTEGER;
	
	ResultSet0		REFCURSOR;
	ResultSet		REFCURSOR;
	
BEGIN
	out_MainCode := 0;
	out_CSSessionId := 0;
	SELECT PSReg.PSID, PSReg.PSName INTO v_PSId, v_PSName FROM PSRegisterationTable PSReg ,WFPSConnection PSCon WHERE PSCon.SESSIONID = DBSessionId and PSReg.PSID = PSCon.PSID;
	GET DIAGNOSTICS v_RowCount = ROW_COUNT;
	IF(NOT FOUND) THEN
		v_RowCount :=0;
		v_DBStatus :=11;
	END IF;
	
	IF(v_DBStatus <> 0 OR v_RowCount <= 0) THEN
		out_MainCode :=11;
		OPEN ResultSet0 FOR SELECT 11,NULL,NULL,NULL;
		RETURN NEXT ResultSet0;
		RETURN;
	END IF;
	
	SELECT SessionID INTO out_CSSessionId FROM PSRegisterationTable WHERE PSName = DBCSName AND Type = 'C';
	IF(NOT FOUND) THEN
			v_RowCount :=0;
	END IF;
	BEGIN
		BEGIN
			v_QueryStr := 'SELECT ImportDataId FROM ' || TableName || ' WHERE (FileStatus = ''C'' OR FileStatus = ''X'') AND LockStatus = ''N''';
			IF(FilterString IS NOT NULL AND LENGTH(FilterString) > 0) THEN
				v_QueryStr := v_QueryStr || ' AND ' || FilterString;
			END IF;
			v_QueryStr := v_QueryStr || ' ORDER BY ImportDataId ASC LIMIT 1';
			Execute  v_QueryStr into v_ImportDataId ; 
			GET DIAGNOSTICS v_RowCount = ROW_COUNT;
			If(v_RowCount <= 0) THEN
				BEGIN
					v_QueryStr := 'SELECT ImportDataId FROM ' || TableName || ' WHERE (FileStatus = ''C'' OR FileStatus = ''X'') AND LockStatus = ''Y'' AND LockedBy = ''' || v_PSName || '''';
					IF(FilterString IS NOT NULL AND LENGTH(FilterString) > 0) THEN
						v_QueryStr := v_QueryStr || ' AND ' || FilterString;
					END IF;
					v_QueryStr := v_QueryStr || ' ORDER BY ImportDataId ASC LIMIT 1';
					Execute  v_QueryStr into v_ImportDataId ; 
					GET DIAGNOSTICS v_RowCount = ROW_COUNT;
				IF(v_RowCount <= 0) THEN
					out_MainCode :=18;
					OPEN ResultSet0 FOR SELECT out_mainCode AS MainCode, out_CSSessionId AS CSSessionId, v_PSId as PSId, v_PSName AS PSName;
					RETURN NEXT ResultSet0;
					RETURN;
				END IF;
				EXCEPTION WHEN OTHERS THEN
					out_MainCode :=15;
					raise notice 'WFGetNextRowFromTable: Error in 	fetching next locked record';
					OPEN ResultSet0 FOR SELECT out_mainCode AS MainCode, out_CSSessionId AS CSSessionId, v_PSId as PSId, v_PSName AS PSName;
					RETURN NEXT ResultSet0;
					RETURN;
				END;
			ELSE
				v_QueryStr := 'UPDATE ' || TableName || ' SET LockStatus = ''Y'', LockDateTime = CURRENT_TIMESTAMP, LockedBy = ''' || v_PSName || ''' WHERE ImportDataId = ' || v_ImportDataId;
				EXECUTE v_QueryStr;
				GET DIAGNOSTICS v_RowCount = ROW_COUNT;
				IF (v_RowCount <= 0) THEN
					out_MainCode := 15;
					raise notice 'WFGetNextRowFromTable: Status for fetched record is not updated';
					OPEN ResultSet0 FOR SELECT out_mainCode AS MainCode, out_CSSessionId AS CSSessionId, v_PSId as PSId, v_PSName AS PSName;
					RETURN NEXT ResultSet0;
					RETURN;
				END IF;
			END IF;
			EXCEPTION WHEN OTHERS THEN
				out_MainCode :=15;
				raise notice 'WFGetNextRowFromTable: Error in Updating status of fetched record';
				OPEN ResultSet0 FOR SELECT out_mainCode AS MainCode, out_CSSessionId AS CSSessionId, v_PSId as PSId, v_PSName AS PSName;
				RETURN NEXT ResultSet0;
				RETURN;
			END;	
		EXCEPTION WHEN OTHERS THEN
			out_MainCode :=15;
			raise notice 'WFGetNextRowFromTable: Error in fetching next unlocked record';
			OPEN ResultSet0 FOR SELECT out_mainCode AS MainCode, out_CSSessionId AS CSSessionId, v_PSId as PSId, v_PSName AS PSName;
			RETURN NEXT ResultSet0;
			RETURN;
		END;
		EXECUTE  'UPDATE ' || TableName || ' SET RetryCount = (COALESCE(RetryCount, 0) + 1) WHERE ImportDataId = ' ||v_ImportDataId;


	OPEN ResultSet0 FOR SELECT out_mainCode AS MainCode, out_CSSessionId AS CSSessionId, v_PSId as PSId, v_PSName AS PSName;
	RETURN NEXT ResultSet0;
	v_QueryStr := 'SELECT * FROM ' || TableName || ' WHERE ImportDataId = '||v_ImportDataId;
	OPEN ResultSet FOR EXECUTE V_QueryStr;
	RETURN NEXT ResultSet;
	RETURN;
END;
$$LANGUAGE plpgsql;