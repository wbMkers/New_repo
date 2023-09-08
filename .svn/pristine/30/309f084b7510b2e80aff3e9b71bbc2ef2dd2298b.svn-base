/*_____________________________________________________________________________________________________________________-
		NEWGEN SOFTWARE TECHNOLOGIES LIMITED

	Group						: Genesis
	Product / Project			: iBPS
	Module						: IBPS Server and Services
	File NAME					: AUpgradeLoggingTableCreation.sql (POSTGresSQL_9.3)
	Author						: Ambuj Tripathi
	Date written (DD/MM/YYYY)	: 17/02/2002
	Description					: This file contains the script which will be executed before the execution of any other 
									modules script.
_______________________________________________________________________________________________________________________-
			CHANGE HISTORY
_______________________________________________________________________________________________________________________-
Date		Change By		Change Description (Bug No. (If Any))
_______________________________________________________________________________________________________________________-*/

CREATE OR REPLACE FUNCTION Upgrade() RETURNS void AS $$
	DECLARE
		existsFlag INTEGER;
	BEGIN
		existsFlag := 0;
		SELECT 1 into existsFlag FROM  information_schema.tables where UPPER(table_name) = 'WFUPGRADELOGGINGTABLE';
		IF(NOT FOUND) THEN 
			Execute (' CREATE TABLE WFUpgradeLoggingTable( logdetails	VARCHAR(2000) )');
			Execute (' Insert into WFUpgradeLoggingTable values (''Table WFUpgradeLoggingTable created successfully'')');
			RAISE NOTICE 'Table WFUpgradeLoggingTable created successfully';
		END IF;
	END;
$$LANGUAGE plpgsql;

~
select Upgrade();

~
DROP FUNCTION Upgrade();

~
