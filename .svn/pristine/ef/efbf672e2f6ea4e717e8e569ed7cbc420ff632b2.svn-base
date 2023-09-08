/*---------------------------------------------------------------------------------------------------
		NEWGEN SOFTWARE TECHNOLOGIES LIMITED
	Group				: Genesis
	Product / Project	: iBPS
	Module				: Transaction Server
	File Name			: WFUpgradeCustomUploadTable.sql
	Author				: Sajid Khan
	Date written		: 29-Apr-2017
	Description			: This procedure will check and upgrade the Custom Upload Table
-----------------------------------------------------------------------------------------------------
				CHANGE HISTORY
-----------------------------------------------------------------------------------------------------
Date			Change By		Change Description (Bug No. (If Any))
-----------------------------------------------------------------------------------------------------
22/04/2018	    Kumar Kimil		Bug 77269 - CheckMarx changes (High Severity)
22/04/2018  Ambuj Tripathi		Bug 76862 - Remove the db console messages from all procedures
----------------------------------------------------------------------------------------------------*/

CREATE OR REPLACE PROCEDURE WFUpgradeCustomUploadTable (
	temp_v_CustomTableName VARCHAR2,
	v_UpgradeHistoryTable VARCHAR2,
	v_MainCode OUT NUMBER,
	v_ErrorDescription OUT VARCHAR2
)
AS
	v_CustomHistoryTableName VARCHAR2(265);
	v_ExistsFlag INT;
	v_CustomTableName VARCHAR2(265);
	v_quoteChar 			CHAR(1);

BEGIN
	v_quoteChar := CHR(39);
	IF(temp_v_CustomTableName is NOT NULL) THEN
		SELECT sys.DBMS_ASSERT.noop(temp_v_CustomTableName) into v_CustomTableName FROM dual;
	END IF;
	v_CustomHistoryTableName := v_CustomTableName || '_History';
	
	--v_CustomTableName:=temp_v_CustomTableName;
	v_MainCode := 0;
	v_ErrorDescription := '';
	v_CustomTableName:=REPLACE(v_CustomTableName,v_quoteChar,v_quoteChar||v_quoteChar);
	v_CustomHistoryTableName:=REPLACE(v_CustomHistoryTableName,v_quoteChar,v_quoteChar||v_quoteChar);
	/* Adding RetryCount column in v_CustomTableName table*/
	BEGIN
		v_ExistsFlag := 0;
		SELECT 1 INTO v_ExistsFlag FROM USER_TABLES WHERE TABLE_NAME = UPPER(v_CustomTableName);
	EXCEPTION WHEN NO_DATA_FOUND THEN
		v_MainCode := 15;
		v_ErrorDescription := 'Table ' || v_CustomTableName || ' does not exist.';
	END;
	IF(v_ExistsFlag = 1) THEN
		BEGIN
			SELECT 1 INTO v_ExistsFlag FROM USER_TAB_COLUMNS WHERE TABLE_NAME = UPPER(v_CustomTableName) AND COLUMN_NAME = UPPER('RetryCount');
		EXCEPTION WHEN NO_DATA_FOUND THEN
			--DBMS_OUTPUT.PUT_LINE('Altering table ' || v_CustomTableName || ', adding column RetryCount.');
			EXECUTE IMMEDIATE 'ALTER TABLE ' || v_CustomTableName || ' ADD RetryCount INT DEFAULT 0';
			EXECUTE IMMEDIATE 'UPDATE ' || v_CustomTableName || ' SET RetryCount = 0';
			--DBMS_OUTPUT.PUT_LINE('Table ' || v_CustomTableName || ' altered.');
			COMMIT;
		END;
	END IF;

	/* Adding RetryCount column in v_CustomHistoryTableName table*/
	IF(v_UpgradeHistoryTable = 'Y') THEN
		BEGIN
			v_ExistsFlag := 0;
			SELECT 1 INTO v_ExistsFlag FROM USER_TABLES WHERE TABLE_NAME = UPPER(v_CustomHistoryTableName);
		EXCEPTION WHEN NO_DATA_FOUND THEN
			v_MainCode := 15;
			v_ErrorDescription := v_ErrorDescription || 'Table ' || v_CustomHistoryTableName || ' does not exist.';
		END;
	
		IF(v_ExistsFlag = 1) THEN
			BEGIN
				SELECT 1 INTO v_ExistsFlag FROM USER_TAB_COLUMNS WHERE TABLE_NAME = UPPER(v_CustomHistoryTableName) AND COLUMN_NAME = UPPER('RetryCount');
			EXCEPTION WHEN NO_DATA_FOUND THEN
				--DBMS_OUTPUT.PUT_LINE('Altering table ' || v_CustomHistoryTableName || ', adding column RetryCount.');
				EXECUTE IMMEDIATE 'ALTER TABLE ' || v_CustomHistoryTableName || ' ADD RetryCount INT DEFAULT 0';
				EXECUTE IMMEDIATE 'UPDATE ' || v_CustomHistoryTableName || ' SET RetryCount = 0';
				--DBMS_OUTPUT.PUT_LINE('Table ' || v_CustomHistoryTableName || ' altered.');
				COMMIT;
			END;
		END IF;
	END IF;
END;
