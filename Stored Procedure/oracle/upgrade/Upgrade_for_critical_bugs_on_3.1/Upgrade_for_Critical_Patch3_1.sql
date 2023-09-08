/*_____________________________________________________________________________________________________________________-
		NEWGEN SOFTWARE TECHNOLOGIES LIMITED

	Group						: Genesis
	Product / Project			: iBPS
	Module						: Transaction Server
	File NAME					: Upgrade_for_Critical_Patch3_1.sql (Oracle Server)
	Author						: Mohnish Chopra
	Date written (DD/MM/YYYY)	: 10/04/2017
	Description					: 
_______________________________________________________________________________________________________________________-
			CHANGE HISTORY
_______________________________________________________________________________________________________________________-
Date		Change By		Change Description (Bug No. (If Any))
____________________________________________________________________
___________________________________________________-*/
CREATE OR REPLACE PROCEDURE Upgrade_for_Critical_Patch3_1 AS
	existsFlag	INTEGER;
BEGIN
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_TABLES  
		WHERE TABLE_NAME = 'WFActivityMaskingInfoTable';
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			EXECUTE IMMEDIATE 
			'CREATE TABLE WFActivityMaskingInfoTable (
				ProcessDefId 		INT 			NOT NULL,
				ActivityId 		    INT 		    NOT NULL,
				ActivityName 		NVARCHAR2(30)	NOT NULL,
				VariableId			INT 			NOT NULL,
				VarFieldId			SMALLINT		NOT NULL,
				VariableName		NVARCHAR2(255) 	NOT NULL
				)';
			dbms_output.put_line ('Table WFActivityMaskingInfoTable Created successfully');
	END;
	
	BEGIN
	SELECT 1 INTO existsFlag  from USER_TAB_COLS WHERE COLUMN_NAME = 'IsEncrypted' AND TABLE_NAME = 'VARMAPPINGTABLE';
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			EXECUTE IMMEDIATE 
			'ALTER TABLE VARMAPPINGTABLE ADD IsEncrypted NVARCHAR2(1)    DEFAULT N''N'' NULL';
			dbms_output.put_line ('COLUMN IsEncrypted ADDED IN VARMAPPINGTABLE SUCCESSFULLY');
	END;
	BEGIN
	SELECT 1 INTO existsFlag  from USER_TAB_COLS WHERE COLUMN_NAME = 'IsMasked' AND TABLE_NAME = 'VARMAPPINGTABLE';
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			EXECUTE IMMEDIATE 
			'ALTER TABLE VARMAPPINGTABLE ADD IsMasked NVARCHAR2(1)    DEFAULT N''N'' NULL';
			dbms_output.put_line ('COLUMN IsMasked ADDED IN VARMAPPINGTABLE SUCCESSFULLY');
	END;
	BEGIN
	SELECT 1 INTO existsFlag  from USER_TAB_COLS WHERE COLUMN_NAME = 'MaskingPattern' AND TABLE_NAME = 'VARMAPPINGTABLE';
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			EXECUTE IMMEDIATE 
			'ALTER TABLE VARMAPPINGTABLE ADD MaskingPattern NVARCHAR2(10)   DEFAULT N''X'' NULL';
			dbms_output.put_line ('COLUMN MaskingPattern ADDED IN VARMAPPINGTABLE SUCCESSFULLY');
	END;
	
	BEGIN
	SELECT 1 INTO existsFlag  from USER_TAB_COLS WHERE COLUMN_NAME = 'IsEncrypted' AND TABLE_NAME = 'WFUDTVarMappingTable';
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			EXECUTE IMMEDIATE 
			'ALTER TABLE WFUDTVarMappingTable ADD IsEncrypted NVARCHAR2(1)    DEFAULT N''N'' NULL';
			dbms_output.put_line ('COLUMN IsEncrypted ADDED IN WFUDTVarMappingTable SUCCESSFULLY');
	END;
	BEGIN
	SELECT 1 INTO existsFlag  from USER_TAB_COLS WHERE COLUMN_NAME = 'IsMasked' AND TABLE_NAME = 'WFUDTVarMappingTable';
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			EXECUTE IMMEDIATE 
			'ALTER TABLE WFUDTVarMappingTable ADD IsMasked NVARCHAR2(1)    DEFAULT N''N'' NULL';
			dbms_output.put_line ('COLUMN IsMasked ADDED IN WFUDTVarMappingTable SUCCESSFULLY');
	END;
	BEGIN
	SELECT 1 INTO existsFlag  from USER_TAB_COLS WHERE COLUMN_NAME = 'MaskingPattern' AND TABLE_NAME = 'WFUDTVarMappingTable';
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			EXECUTE IMMEDIATE 
			'ALTER TABLE WFUDTVarMappingTable ADD MaskingPattern NVARCHAR2(10)   DEFAULT N''X'' NULL';
			dbms_output.put_line ('COLUMN MaskingPattern ADDED IN WFUDTVarMappingTable SUCCESSFULLY');
	END;
	
	
END;
~
call Upgrade_for_Critical_Patch3_1()
~
DROP PROCEDURE Upgrade_for_Critical_Patch3_1
~	