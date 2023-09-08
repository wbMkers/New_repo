/*_____________________________________________________________________________________________________________________-
		NEWGEN SOFTWARE TECHNOLOGIES LIMITED

	Group						: Genesis
	Product / Project			: iBPS
	Module						: Transaction Server
	File NAME					: UpgradeIBPS_A_OFserver_5_SP1.sql (MS Sql Server)
	Author						: Ravi Ranjan Kumar
	Date written (DD/MM/YYYY)	: 08/07/2020
	Description					: This file contains the list of changes done after release of iBPS 5.0
_______________________________________________________________________________________________________________________-
CHANGE HISTORY
29/01/2020      Sourabh Tantuway    Bug 93812 - iBPS 5.0 SP1: Requirement for get SAP user credentials based on process variable value. This mapped variable will contain the username of the user, whose details are to be fetched
08/04/2020      Sourabh Tantuway    Bug 93899 - AlternateMessage column is missing in WFMAILQUEUEHISTORYTABLE

_______________________________________________________________________________________________________________________-*/

CREATE OR REPLACE PROCEDURE Upgrade AS

	existsFlag INT;
	v_ConstraintName 	VARCHAR2(100);
	
	
BEGIN

	BEGIN
		SELECT CONSTRAINT_NAME INTO v_ConstraintName FROM user_constraints WHERE table_name = UPPER('EXTMETHODPARAMDEFTABLE') AND constraint_type = 'C' and Upper(Search_condition_vc) LIKE Upper('ParameterType%');
		IF (v_ConstraintName IS NOT NULL AND length(v_ConstraintName) > 0) THEN
			EXECUTE IMMEDIATE ('ALTER TABLE EXTMETHODPARAMDEFTABLE DROP CONSTRAINT ' ||  v_ConstraintName);
		END IF;
		EXECUTE IMMEDIATE 'ALTER TABLE EXTMETHODPARAMDEFTABLE ADD CHECK(ParameterType in (0, 3, 4, 6, 8, 10, 11, 12, 14, 15, 16, 18))';
	EXCEPTION
		WHEN OTHERS THEN  
			raise_application_error(-20231,' BLOCK 1 FAILED');
	END;

	BEGIN
		existsFlag :=0;	
		select 1 into existsFlag from user_tab_columns where upper(table_name) = UPPER('EXTMETHODDEFTABLE') and upper(column_name) = UPPER('AliasName');
		Exception when no_data_found then
			EXECUTE IMMEDIATE ('Alter table EXTMETHODDEFTABLE ADD  AliasName          	NVARCHAR2(100)   NULL');
	END;
	
	BEGIN
		existsFlag :=0;	
		select 1 into existsFlag from user_tab_columns where upper(table_name) = UPPER('EXTMETHODDEFTABLE') and upper(column_name) = UPPER('DomainName');
		Exception when no_data_found then
			EXECUTE IMMEDIATE ('Alter table EXTMETHODDEFTABLE ADD  DomainName          	NVARCHAR2(100)   NULL');
	END;
	
	BEGIN
		existsFlag :=0;	
		select 1 into existsFlag from user_tab_columns where upper(table_name) = UPPER('EXTMETHODDEFTABLE') and upper(column_name) = UPPER('Description');
		Exception when no_data_found then
			EXECUTE IMMEDIATE ('Alter table EXTMETHODDEFTABLE ADD  Description          	NVARCHAR2(2000)   NULL');
	END;
	
	BEGIN
		existsFlag :=0;	
		select 1 into existsFlag from user_tab_columns where upper(table_name) = UPPER('EXTMETHODDEFTABLE') and upper(column_name) = UPPER('ServiceScope');
		Exception when no_data_found then
			EXECUTE IMMEDIATE ('Alter table EXTMETHODDEFTABLE ADD  ServiceScope          	NVARCHAR2(1)   NULL');
	END;
	
	existsFlag := 0;
	BEGIN
		BEGIN
		SELECT COUNT(1) INTO existsFlag FROM USER_TAB_COLUMNS WHERE TABLE_NAME=UPPER('WFScriptData') AND COLUMN_NAME=UPPER('Target');
		IF (existsFlag=1) THEN
		BEGIN
			existsFlag :=0;
			SELECT 1 into existsFlag from user_tab_columns where table_name = UPPER('WFScriptData') and column_name = UPPER('Target') and
				char_col_decl_length < 2000;
			IF existsFlag = 1 THEN
			BEGIN
				EXECUTE IMMEDIATE 'ALTER TABLE WFScriptData MODIFY (Target NVARCHAR2(2000))';
			END;
			END IF;
			EXCEPTION
					WHEN NO_DATA_FOUND THEN
					BEGIN
						DBMS_OUTPUT.PUT_LINE('Size of column in Target column in WFScriptData');
					END;
		END;
		END IF;
		END;
	EXCEPTION
		WHEN OTHERS THEN
			raise_application_error(-20444,'Increasing size of Target in WFScriptData Failed.');
			RETURN;
	END;
	
	existsFlag := 0;
	BEGIN
		BEGIN
		SELECT COUNT(1) INTO existsFlag FROM USER_TAB_COLUMNS WHERE TABLE_NAME=UPPER('WFScriptData') AND COLUMN_NAME=UPPER('Value');
		IF (existsFlag=1) THEN
		BEGIN
			existsFlag :=0;
			SELECT 1 into existsFlag from user_tab_columns where table_name = UPPER('WFScriptData') and column_name = UPPER('Value') and
				char_col_decl_length < 2000;
			IF existsFlag = 1 THEN
			BEGIN
				EXECUTE IMMEDIATE 'ALTER TABLE WFScriptData MODIFY (Value NVARCHAR2(2000))';
			END;
			END IF;
			EXCEPTION
					WHEN NO_DATA_FOUND THEN
					BEGIN
						DBMS_OUTPUT.PUT_LINE('Size of column in Value column in WFScriptData');
					END;
		END;
		END IF;
		END;
	EXCEPTION
		WHEN OTHERS THEN
			raise_application_error(-20444,'Increasing size of Value in WFScriptData Failed.');
			RETURN;
	END;
	
	BEGIN
		existsFlag :=0;	
		select 1 into existsFlag from user_tab_columns where upper(table_name) = UPPER('WFSAPAdapterAssocTable') and upper(column_name) = UPPER('SAPUserVariableId');
		Exception when no_data_found then
			EXECUTE IMMEDIATE ('Alter table WFSAPAdapterAssocTable ADD  SAPUserVariableId          	INT DEFAULT(0)   NOT NULL');
	END;
	
	BEGIN
		existsFlag :=0;	
		select 1 into existsFlag from user_tab_columns where upper(table_name) = UPPER('WFSAPAdapterAssocTable') and upper(column_name) = UPPER('SAPUserName');
		Exception when no_data_found then
			EXECUTE IMMEDIATE ('Alter table WFSAPAdapterAssocTable ADD  SAPUserName          	NVARCHAR2(50)   NULL');
	END;
	
	BEGIN
		existsFlag :=0;	
		select 1 into existsFlag from user_tab_columns where upper(table_name) = UPPER('WFMAILQUEUEHISTORYTABLE') and upper(column_name) = UPPER('ALTERNATEMESSAGE');
		Exception when no_data_found then
			EXECUTE IMMEDIATE ('Alter table WFMAILQUEUEHISTORYTABLE add ALTERNATEMESSAGE CLOB NULL	');
	END;
	
END;

~
call Upgrade()

~
DROP PROCEDURE Upgrade

~