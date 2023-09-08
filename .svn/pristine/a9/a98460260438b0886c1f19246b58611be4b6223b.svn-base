/*
--------------------------------------------------------------------------------------------------
		NEWGEN SOFTWARE TECHNOLOGIES LIMITED
	Group				: Genesis
	Product				: OmniFlow 10.x
	Module				: Transaction Server
	File Name			: WFGetNextRowFromTable.sql
	Author				: Ashutosh Pandey
	Date written		: Apr 16, 2019
	Description			: This procedure will fetch and return next record from import table
----------------------------------------------------------------------------------------------------
				CHANGE HISTORY
----------------------------------------------------------------------------------------------------
Date		Change By			Change Description (Bug No. (If Any))
----------------------------------------------------------------------------------------------------
17/04/2019	Ashutosh Pandey		Bug 84206 - Optimization in WFGetNextUnlockedRowFromTable API
4/09/2019	Ravi Ranjan Kumar	Bug 86333 - Import Service is not working. WI are not getting created.
----------------------------------------------------------------------------------------------------
*/
CREATE OR REPLACE PROCEDURE WFGetNextRowFromTable (
	DBSessionId INTEGER,
	DBCSName NVARCHAR2,
	temp_TableName NVARCHAR2,
	temp_FilterString NVARCHAR2,
	out_MainCode OUT INT,
	out_CSSessionId OUT INT,
	out_RefCursor OUT ORACONSTPKG.DBLIST
)
AS
	v_RowCount INT;
	v_DBStatus INT;
	v_PSId PSREGISTERATIONTABLE.PSID%Type;
	v_PSName PSREGISTERATIONTABLE.PSNAME%Type;
	v_ImportDataId INT;
	v_QueryStr VARCHAR2(1000);
	v_quoteChar 			CHAR(1);
	FilterString NVARCHAR2(2000);
	TableName NVARCHAR2(500);
BEGIN
	out_MainCode := 0;
	out_CSSessionId := 0;
	v_quoteChar := CHR(39);
	IF(temp_TableName is NOT NULL) THEN
		SELECT sys.DBMS_ASSERT.noop(temp_TableName) into TableName FROM dual;
	END IF;
	TableName:=REPLACE(TableName,v_quoteChar,v_quoteChar||v_quoteChar);
	IF(temp_FilterString is NOT NULL) THEN
	/*
		FilterString:=REPLACE(temp_FilterString,v_quoteChar,v_quoteChar||v_quoteChar);
		FilterString:=REPLACE(temp_FilterString,v_quoteChar||v_quoteChar,v_quoteChar);
		*/
		SELECT sys.DBMS_ASSERT.noop(temp_FilterString) into FilterString FROM dual;
	END IF;
	BEGIN
		SELECT PSReg.PSID,PSReg.PSName INTO v_PSId, v_PSName FROM PSRegisterationTable PSReg , WFPSConnection PSCon WHERE PSCon.SESSIONID = DBSessionId and PSReg.PSID = PSCon.PSID;
		v_RowCount := SQL%ROWCOUNT;
		v_DBStatus := SQLCODE;
		v_PSName:=REPLACE(v_PSName,v_quoteChar,v_quoteChar||v_quoteChar);
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
			v_QueryStr := 'SELECT ImportDataId FROM ' || TO_CHAR(TableName) || ' WHERE (FileStatus = ''C'' OR FileStatus = ''X'') AND LockStatus = ''N''';
			IF(FilterString IS NOT NULL AND LENGTH(FilterString) > 0) THEN
				v_QueryStr := v_QueryStr || ' AND ' || TO_CHAR(FilterString);
			END IF;
			v_QueryStr := v_QueryStr || ' AND ROWNUM <= 1 ORDER BY ImportDataId ASC';
			EXECUTE IMMEDIATE v_QueryStr INTO v_ImportDataId;

			v_RowCount := SQL%ROWCOUNT;
			v_DBStatus := SQLCODE;
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_RowCount := 0;
		END;

		IF(v_DBStatus <> 0) THEN
			ROLLBACK TO SAVEPOINT LockNextRecord;
			out_MainCode := 15;
			raise_application_error(-20118, 'WFGetNextRowFromTable: Error in fetching next unlocked record');
			RETURN;
		END IF;

		IF(v_RowCount <= 0) THEN
			BEGIN
				v_QueryStr := 'SELECT ImportDataId FROM ' || TO_CHAR(TableName) || ' WHERE (FileStatus = ''C'' OR FileStatus = ''X'') AND LockStatus = ''Y'' AND LockedBy = ''' || TO_CHAR(v_PSName) || '''';
				IF(FilterString IS NOT NULL AND LENGTH(FilterString) > 0) THEN
					v_QueryStr := v_QueryStr || ' AND ' || TO_CHAR(FilterString);
				END IF;
				v_QueryStr := v_QueryStr || ' AND ROWNUM <= 1 ORDER BY ImportDataId ASC';
				EXECUTE IMMEDIATE v_QueryStr INTO v_ImportDataId;

				v_RowCount := SQL%ROWCOUNT;
				v_DBStatus := SQLCODE;
			EXCEPTION
				WHEN NO_DATA_FOUND THEN
					v_RowCount := 0;
			END;

			IF(v_DBStatus <> 0) THEN
				ROLLBACK TO SAVEPOINT LockNextRecord;
				out_MainCode := 15;
				raise_application_error(-20118, 'WFGetNextRowFromTable: Error in fetching next locked record');
				RETURN;
			END IF;

			IF(v_RowCount <= 0) THEN
				ROLLBACK TO SAVEPOINT LockNextRecord;
				out_MainCode := 18;
				RETURN;
			END IF;
		ELSE
			v_QueryStr := 'UPDATE ' || TO_CHAR(TableName) || ' SET LockStatus = ''Y'', LockDateTime = SYSDATE, LockedBy = ''' || TO_CHAR(v_PSName) || ''' WHERE ImportDataId = ' || TO_CHAR(v_ImportDataId);
			EXECUTE IMMEDIATE v_QueryStr;

			v_RowCount := SQL%ROWCOUNT;
			v_DBStatus := SQLCODE;

			IF(v_DBStatus <> 0) THEN
				ROLLBACK TO SAVEPOINT LockNextRecord;
				out_MainCode := 15;
				raise_application_error(-20118, 'WFGetNextRowFromTable: Error in Updating status of fetched record');
				RETURN;
			END IF;

			IF (v_RowCount <= 0) THEN
				ROLLBACK TO SAVEPOINT LockNextRecord;
				out_MainCode := 15;
				raise_application_error(-20118, 'WFGetNextRowFromTable: Status for fetched record is not updated');
				RETURN;
			END IF;
		END IF;

		EXECUTE IMMEDIATE 'UPDATE ' || TO_CHAR(TableName) || ' SET RetryCount = (NVL(RetryCount, 0) + 1) WHERE ImportDataId = ' || TO_CHAR(v_ImportDataId);

		COMMIT;

		v_QueryStr := 'SELECT * FROM ' || TO_CHAR(TableName) || ' WHERE ImportDataId = :v_ImportDataId';
		OPEN out_RefCursor FOR v_QueryStr USING v_ImportDataId;
	END;
END;