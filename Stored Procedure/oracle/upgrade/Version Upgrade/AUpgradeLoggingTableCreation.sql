/*_____________________________________________________________________________________________________________________-
		NEWGEN SOFTWARE TECHNOLOGIES LIMITED

	Group						: Genesis
	Product / Project			: iBPS
	Module						: IBPS Server and Services
	File NAME					: AUpgradeLoggingTableCreation.sql (Oracle)
	Author						: Ambuj Tripathi
	Date written (DD/MM/YYYY)	: 17/02/2002
	Description					: This file contains the script which will be executed before the execution of any other 
									modules script.
_______________________________________________________________________________________________________________________-
			CHANGE HISTORY
_______________________________________________________________________________________________________________________-
Date		Change By		Change Description (Bug No. (If Any))
_______________________________________________________________________________________________________________________-*/

create or replace PROCEDURE Upgrade AS
	existsFlag INTEGER:=0;
BEGIN
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_TABLES  
		WHERE UPPER(TABLE_NAME) = UPPER('WFUpgradeLoggingTable');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			BEGIN
				EXECUTE IMMEDIATE 
				'CREATE TABLE WFUpgradeLoggingTable(
					logdetails	NVARCHAR2(2000)
				)';
				EXECUTE IMMEDIATE 'Insert Into WFUpgradeLoggingTable values(''Table WFUpgradeLoggingTable Created successfully'')';
				dbms_output.put_line ('Table WFUpgradeLoggingTable Created successfully');
			END;
	END;
END;

~
call Upgrade()

~
drop procedure Upgrade

~
