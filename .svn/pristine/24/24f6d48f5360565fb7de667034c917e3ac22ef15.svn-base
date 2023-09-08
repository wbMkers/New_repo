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

CREATE OR REPLACE PROCEDURE WFPurgeServiceAudit (
	DBConnectId				INT,
	DBHostName				VARCHAR2,
	DBDays					INT DEFAULT 0,
	BackupFlag				CHAR DEFAULT 'N',
	Status					OUT INT
)
AS
	TYPE REF_CURSOR IS REF CURSOR;

	DBUserId				INT;
	MainGroupId				INT;
	DBStatus				INT;
	ApplicationName			VARCHAR2(32);
	ApplicationInfo			VARCHAR2(32);
	Days					INT;
	TillActionDateTime		DATE;
	PSID					INT;
	Query1					VARCHAR2(2000);
	Query2					VARCHAR2(2000);
	Query3					VARCHAR2(2000);
	Query4					VARCHAR2(2000);
	Query5					VARCHAR2(2000);
	Cursor1 				REF_CURSOR;
BEGIN
	DBUserId := 0;
	MainGroupId := 0;
	DBStatus := -1;
	Status := 0;

	PRTCheckUser(DBConnectId, DBHostName, DBUserId, MainGroupId, DBStatus, ApplicationName, ApplicationInfo);
	IF (DBStatus <> 0) THEN
		Status := DBStatus;
		RETURN;
	END IF;

	Days := DBDays;
	IF(Days IS NULL OR Days <= 0) THEN
		Days := 90;
	END IF;

	Query1 := 'SELECT (SYSDATE - :Days) FROM DUAL';

	Query2 := 'SELECT PSID FROM WFServiceAuditTable WHERE ActionDateTime < :TillActionDateTime AND ActionId = 3';

	Query3 := 'DELETE FROM WFServicesListTable WHERE PSID = :PSID';

	Query4 := 'INSERT INTO WFServiceAuditTable_History(LogId, PSID, ServiceName, ServiceType, ActionId, ActionDateTime, Username, ServerDetails, ServiceParamDetails) SELECT LogId, PSID, ServiceName, ServiceType, ActionId, ActionDateTime, Username, ServerDetails, ServiceParamDetails FROM WFServiceAuditTable WHERE ActionDateTime < :TillActionDateTime';

	Query5 := 'DELETE FROM WFServiceAuditTable WHERE ActionDateTime < :TillActionDateTime';

	EXECUTE IMMEDIATE Query1 INTO TillActionDateTime USING Days;

	OPEN Cursor1 FOR Query2 USING TillActionDateTime;
	LOOP
		FETCH Cursor1 INTO PSID;
		EXIT WHEN Cursor1%NOTFOUND;
		EXECUTE IMMEDIATE Query3 USING PSID;
	END LOOP;
	CLOSE Cursor1;

	IF(UPPER(BackupFlag) = 'Y') THEN
		EXECUTE IMMEDIATE Query4 USING TillActionDateTime;
	END IF;

	EXECUTE IMMEDIATE Query5 USING TillActionDateTime;

EXCEPTION WHEN OTHERS THEN
	Status := 15;
	IF(Cursor1%ISOPEN) THEN
		CLOSE Cursor1;
	END IF;
	RAISE;
END;
