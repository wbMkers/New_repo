/*_____________________________________________________________________________________________________________________-
		NEWGEN SOFTWARE TECHNOLOGIES LIMITED

	Group						: Genesis
	Product / Project			: iBPS
	Module						: IBPS Server and Services
	File NAME					: AUpgradeLoggingTableCreation.sql.sql (MS Sql Server)
	Author						: Ambuj Tripathi
	Date written (DD/MM/YYYY)	: 17/02/2002
	Description					: This file contains the script which will be executed before the execution of any other 
									modules script.
_______________________________________________________________________________________________________________________-
			CHANGE HISTORY
_______________________________________________________________________________________________________________________-
Date		Change By		Change Description (Bug No. (If Any))
_______________________________________________________________________________________________________________________-*/

IF NOT EXISTS (
		SELECT * FROM SYSObjects 
		WHERE NAME = 'WFUpgradeLoggingTable' 
		AND xType = 'U'
	)
BEGIN
	EXECUTE(' 
		CREATE TABLE WFUpgradeLoggingTable(
			logdetails	NVARCHAR(2000)
		)
	')
	PRINT 'Table WFUpgradeLoggingTable created successfully.'
	EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Table WFUpgradeLoggingTable created successfully.'')')
END