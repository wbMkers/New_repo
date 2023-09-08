/*
-----------------------------------------------------------------------------------------
		NEWGEN SOFTWARE TECHNOLOGIES LIMITED
Group			: Genesis
Product			: iBPS
Module			: Transaction Server
File Name		: WFPurgeServiceAudit.sql
Author			: Chitranshi Nitharia
Date written	: Apr 16th, 2020
Description		: This procedure will purge service history
-----------------------------------------------------------------------------------------
		CHANGE HISTORY
-----------------------------------------------------------------------------------------
Date			Change By					Change Description (Bug No. (If Any))
-----------------------------------------------------------------------------------------
16/04/2020		Chitranshi Nitharia			Bug 91524 - Framework to manage custom utility via ofservices
-----------------------------------------------------------------------------------------
*/

CREATE OR REPLACE FUNCTION WFPurgeServiceAudit (
	DBConnectId				INT,
	DBHostName				VARCHAR,
	DBDays					INT DEFAULT 0,
	BackupFlag				CHAR DEFAULT 'N'
) RETURNS VOID AS $$
DECLARE
	DBUserId				INT;
	MainGroupId				INT;
	DBStatus				INT;
	ApplicationName			VARCHAR(32);
	ApplicationInfo			VARCHAR(32);
	Days					INT;
	TillActionDateTime		TIMESTAMP;
	PSID					INT;
	Query1					VARCHAR(2000);
	Query2					VARCHAR(2000);
	Query3					VARCHAR(2000);
	Query4					VARCHAR(2000);
	Query5					VARCHAR(2000);
	Cursor1 				REFCURSOR;
BEGIN
	DBUserId := 0;
	MainGroupId := 0;
	DBStatus := -1;

	Days := DBDays;
	IF(Days IS NULL OR Days <= 0) THEN
		Days := 90;
	END IF;

	Query1 := 'SELECT (CURRENT_TIMESTAMP - $1 * INTERVAL ''1 day'')';

	Query2 := 'SELECT PSID FROM WFServiceAuditTable WHERE ActionDateTime < $1 AND ActionId = 3';

	Query3 := 'DELETE FROM WFServicesListTable WHERE PSID = $1';

	Query4 := 'INSERT INTO WFServiceAuditTable_History(LogId, PSID, ServiceName, ServiceType, ActionId, ActionDateTime, Username, ServerDetails, ServiceParamDetails) SELECT LogId, PSID, ServiceName, ServiceType, ActionId, ActionDateTime, Username, ServerDetails, ServiceParamDetails FROM WFServiceAuditTable WHERE ActionDateTime < $1';

	Query5 := 'DELETE FROM WFServiceAuditTable WHERE ActionDateTime < $1';

	EXECUTE Query1 INTO TillActionDateTime USING Days;

	OPEN Cursor1 FOR EXECUTE Query2 USING TillActionDateTime;
	LOOP
		FETCH Cursor1 INTO PSID;
		EXIT WHEN NOT FOUND;
		EXECUTE Query3 USING PSID;
	END LOOP;
	CLOSE Cursor1;

	IF(UPPER(BackupFlag) = 'Y') THEN
		EXECUTE Query4 USING TillActionDateTime;
	END IF;

	EXECUTE Query5 USING TillActionDateTime;

END;
$$LANGUAGE plpgsql;
