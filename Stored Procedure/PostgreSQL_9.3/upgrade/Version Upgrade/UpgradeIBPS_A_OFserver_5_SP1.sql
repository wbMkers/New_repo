/*_____________________________________________________________________________________________________________________-
		NEWGEN SOFTWARE TECHNOLOGIES LIMITED

	Group						: Genesis
	Product / Project			: iBPS
	Module						: Transaction Server
	File NAME					: UpgradeIBPS_A_OFserver_6.sql
	Author						: Ravi Ranjan Kumar
	Date written (DD/MM/YYYY)	: 08/07/2020
	Description					: This file contains the list of changes done after release of iBPS 5.0
_______________________________________________________________________________________________________________________-
			CHANGE HISTORY
_______________________________________________________________________________________________________________________-
Date		Change By		Change Description (Bug No. (If Any))

08/07/2020	Ravi Ranjan Kumar Bug 93100 - Unable to save process after registering the RestWebservice,Getting error "The requested filter is invalid.
29/01/2020  Sourabh Tantuway  Bug 93812 - iBPS 5.0 SP1: Requirement for get SAP user credentials based on process variable value. This mapped variable will contain the username of the user, whose details are to be fetched
08/04/2020  Sourabh Tantuway    Bug 93899 - AlternateMessage column is missing in WFMAILQUEUEHISTORYTABLE
____________________________________________________________________
___________________________________________________-*/


CREATE OR REPLACE FUNCTION  Upgrade() 
RETURNS void AS $$
DECLARE 

	v_existFlag		INTEGER;
	v_ConstraintName 	VARCHAR(100);
	
BEGIN
	
	BEGIN
		SELECT conname into v_ConstraintName FROM pg_constraint WHERE conrelid = (SELECT oid  FROM pg_class WHERE UPPER(relname) LIKE UPPER('EXTMETHODPARAMDEFTABLE')) and upper(conname) like upper('%_parametertype_check%');	
		GET DIAGNOSTICS v_existFlag = ROW_COUNT;
		IF(v_existFlag <> 0) THEN
			EXECUTE ('ALTER TABLE EXTMETHODPARAMDEFTABLE DROP CONSTRAINT '||v_ConstraintName);
		END IF; 
		EXECUTE 'ALTER TABLE EXTMETHODPARAMDEFTABLE ADD CONSTRAINT extmethodparamdeftable_parametertype_check CHECK (ParameterType in (0, 3, 4, 6, 8, 10, 11, 12, 14, 15, 16, 18))';
	END;
	
	BEGIN
		v_existFlag := 0;
		SELECT 1 INTO v_existFlag FROM information_schema.columns WHERE UPPER(table_name) = UPPER('EXTMETHODDEFTABLE') and UPPER(column_name)=UPPER('AliasName');
		IF(NOT FOUND) THEN 
			Execute ('ALTER TABLE EXTMETHODDEFTABLE ADD AliasName VARCHAR(100)  NULL');
		END IF;
	END;
	
	BEGIN
		v_existFlag := 0;
		SELECT 1 INTO v_existFlag FROM information_schema.columns WHERE UPPER(table_name) = UPPER('EXTMETHODDEFTABLE') and UPPER(column_name)=UPPER('DomainName');
		IF(NOT FOUND) THEN 
			Execute ('ALTER TABLE EXTMETHODDEFTABLE ADD DomainName VARCHAR(100)  NULL');
		END IF;
	END;
	
	BEGIN
		v_existFlag := 0;
		SELECT 1 INTO v_existFlag FROM information_schema.columns WHERE UPPER(table_name) = UPPER('EXTMETHODDEFTABLE') and UPPER(column_name)=UPPER('Description');
		IF(NOT FOUND) THEN 
			Execute ('ALTER TABLE EXTMETHODDEFTABLE ADD Description VARCHAR(2000)  NULL');
		END IF;
	END;
	
	BEGIN
		v_existFlag := 0;
		SELECT 1 INTO v_existFlag FROM information_schema.columns WHERE UPPER(table_name) = UPPER('EXTMETHODDEFTABLE') and UPPER(column_name)=UPPER('ServiceScope');
		IF(NOT FOUND) THEN 
			Execute ('ALTER TABLE EXTMETHODDEFTABLE ADD ServiceScope VARCHAR(1)  NULL');
		END IF;
	END;
	
	v_existFlag := 0;
	BEGIN
	SELECT 1 INTO v_existFlag FROM information_schema.columns WHERE UPPER(table_name) = UPPER('WFScriptData') and UPPER(column_name)=Upper('Target');
	IF(v_existFlag=1) THEN 
	BEGIN
		v_existFlag := 0;
		SELECT 1 into v_existFlag from information_schema.columns where UPPER(table_name) = UPPER('WFScriptData') and UPPER(column_name) = UPPER('Target') and character_maximum_length < 2000;
		IF v_existFlag = 1 THEN
		BEGIN
			Execute ('ALTER TABLE WFScriptData ALTER COLUMN Target TYPE VARCHAR(2000)');
		END;
		END IF;
	END;
	END IF;
	END;
	
	v_existFlag := 0;
	BEGIN
	SELECT 1 INTO v_existFlag FROM information_schema.columns WHERE UPPER(table_name) = UPPER('WFScriptData') and UPPER(column_name)=Upper('Value');
	IF(v_existFlag=1) THEN 
	BEGIN
		v_existFlag := 0;
		SELECT 1 into v_existFlag from information_schema.columns where UPPER(table_name) = UPPER('WFScriptData') and UPPER(column_name) = UPPER('Value') and character_maximum_length < 2000;
		IF v_existFlag = 1 THEN
		BEGIN
			Execute ('ALTER TABLE WFScriptData ALTER COLUMN Value TYPE VARCHAR(2000)');
		END;
		END IF;
	END;
	END IF;
	END;
	
	BEGIN
		v_existFlag := 0;
		SELECT 1 INTO v_existFlag FROM information_schema.columns WHERE UPPER(table_name) = UPPER('WFSAPAdapterAssocTable') and UPPER(column_name)=UPPER('SAPUserVariableId');
		IF(NOT FOUND) THEN 
			Execute ('ALTER TABLE WFSAPAdapterAssocTable ADD SAPUserVariableId INTEGER DEFAULT 0    NOT NULL');
		END IF;
	END;
	
	BEGIN
		v_existFlag := 0;
		SELECT 1 INTO v_existFlag FROM information_schema.columns WHERE UPPER(table_name) = UPPER('WFSAPAdapterAssocTable') and UPPER(column_name)=UPPER('SAPUserName');
		IF(NOT FOUND) THEN 
			Execute ('ALTER TABLE WFSAPAdapterAssocTable ADD SAPUserName VARCHAR(50)  NULL');
		END IF;
	END;
	
	BEGIN
		v_existFlag := 0;
		SELECT 1 INTO v_existFlag FROM information_schema.columns WHERE UPPER(table_name) = UPPER('WFMAILQUEUEHISTORYTABLE') and UPPER(column_name)=UPPER('ALTERNATEMESSAGE');
		IF(NOT FOUND) THEN 
			Execute ('Alter table WFMAILQUEUEHISTORYTABLE ADD ALTERNATEMESSAGE TEXT  NULL	');
		END IF;
	END;
	

END;
$$LANGUAGE plpgsql;
~
SELECT Upgrade();
~
DROP FUNCTION Upgrade();
~