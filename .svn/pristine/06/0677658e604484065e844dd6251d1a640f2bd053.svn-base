/*---------------------------------------------------------------------------------------------------
		NEWGEN SOFTWARE TECHNOLOGIES LIMITED
	Group				: Genesis
	Product / Project	: iBPS
	Module				: Transaction Server
	File Name			: WFUpgradeCustomUploadTable.sql
	Author				: Sajid Khan
	Date written		: 29-April-2017
	Description			: This procedure will check and upgrade the Custom Upload Table
-----------------------------------------------------------------------------------------------------
				CHANGE HISTORY
-----------------------------------------------------------------------------------------------------
Date			Change By		Change Description (Bug No. (If Any))
28/05/2018		Mohnish Chopra	Bug 76066 - File upload not working.Please share Postgres script for File upload & Import utility
08/01/2019		Ravi Ranjan Kumar Bug 80518 - Postgres: File Upload Utility is not working as in Ofservices screen count of workitem processed is displayed but in database table dat is not getting displayed (Merging from sp2)
-----------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------*/

CREATE OR REPLACE FUNCTION WFUpgradeCustomUploadTable(
	v_CustomTableName VARCHAR,
	v_UpgradeHistoryTable VARCHAR
) RETURNS REFCURSOR AS $$
DECLARE
	v_MainCode 					INTEGER;
	v_ErrorDescription 			VARCHAR(600);
	v_CustomHistoryTableName	VARCHAR(265);
	v_ExistsFlag 				INT;
	ResultSet					REFCURSOR;

BEGIN
	v_MainCode := 0;
	v_ErrorDescription := '';
	v_CustomHistoryTableName := v_CustomTableName || '_History';
	/* Adding RetryCount column in v_CustomTableName table*/
	BEGIN
		v_ExistsFlag := 0;
		Select 1 into v_ExistsFlag from information_schema.columns where upper(table_name) = upper(v_CustomTableName);
		IF (NOT FOUND) THEN
			v_MainCode := 15;
			v_ErrorDescription := 'Table ' || v_CustomTableName || ' does not exist.';
			OPEN ResultSet FOR SELECT v_MainCode ,v_ErrorDescription;  
			RETURN ResultSet; 
	    END IF;
	END;

	IF(v_ExistsFlag = 1) THEN
		select 1 into v_ExistsFlag from information_schema.columns where upper(table_name) = upper(v_CustomTableName) and upper(column_name) = upper('RetryCount');
		IF (NOT FOUND) THEN
			Execute 'ALTER TABLE '||v_CustomTableName||' ADD RetryCount INTEGER DEFAULT 0';
			Execute 'UPDATE ' || v_CustomTableName || ' SET RetryCount = 0';
	    END IF;
	END IF;
	
	/* Adding RetryCount column in v_CustomHistoryTableName table*/
	IF(v_UpgradeHistoryTable = 'Y') THEN
		BEGIN
			v_ExistsFlag := 0;
			SELECT 1 INTO v_ExistsFlag FROM information_schema.columns where upper(table_name)= UPPER(v_CustomHistoryTableName);
			IF (NOT FOUND) THEN
				v_MainCode := 15;
				v_ErrorDescription := v_ErrorDescription || 'Table ' || v_CustomHistoryTableName || ' does not exist.';
			END IF;
		END;
	
		IF(v_ExistsFlag = 1) THEN
			BEGIN
				SELECT 1 INTO v_ExistsFlag FROM information_schema.columns WHERE upper(table_name) = UPPER(v_CustomHistoryTableName) AND  upper(column_name) = UPPER('RetryCount');
				IF (NOT FOUND) THEN
					Execute 'ALTER TABLE '||v_CustomHistoryTableName||' ADD RetryCount INTEGER DEFAULT 0';
					Execute 'UPDATE ' || v_CustomHistoryTableName || ' SET RetryCount = 0';
				END IF;
			END;
		END IF;
	END IF;
		v_ErrorDescription = 'Success';
		OPEN ResultSet FOR SELECT v_MainCode,v_ErrorDescription;
		Return ResultSet;
END;
$$LANGUAGE plpgsql;
