/*
-----------------------------------------------------------------------------------------
		NEWGEN SOFTWARE TECHNOLOGIES LIMITED
Group			: Genesis
Product			: iBPS
Module			: Transaction Server
File Name		: WFSetCustomServiceStatus.sql
Author			: Chitranshi Nitharia
Date written	: Mar 24th, 2020
Description		: This procedure will set custom service status
-----------------------------------------------------------------------------------------
		CHANGE HISTORY
-----------------------------------------------------------------------------------------
Date			Change By					Change Description (Bug No. (If Any))
-----------------------------------------------------------------------------------------
16/04/2020		Chitranshi Nitharia			Bug 91524 - Framework to manage custom utility via ofservices
-----------------------------------------------------------------------------------------
*/

CREATE OR REPLACE PROCEDURE WFSetCustomServiceStatus (
	PSID				INTEGER,
	ServiceStatus		INTEGER,
	ServiceStatusMsg	NVARCHAR2,
	WorkItemCount		INTEGER
)
AS
	lWorkItemCount		INTEGER;
	WorkItemCountExp	VARCHAR2(100);
	Query1				VARCHAR2(2000);
BEGIN
	lWorkItemCount := NVL(WorkItemCount, 0);
	IF(lWorkItemCount >= 0) THEN
		WorkItemCountExp := '(WorkItemCount + :lWorkItemCount)';
	ELSIF(lWorkItemCount = -1) THEN
		lWorkItemCount := 0;
		WorkItemCountExp := ':lWorkItemCount';
	ELSE
		lWorkItemCount := 0;
		WorkItemCountExp := '(WorkItemCount + :lWorkItemCount)';
	END IF;

	Query1 := 'UPDATE WFCustomServicesStatusTable SET ServiceStatus = :ServiceStatus, ServiceStatusMsg = :ServiceStatusMsg, WorkItemCount = ' || WorkItemCountExp || ', LastUpdated = SYSDATE WHERE PSID = :PSID';

	EXECUTE IMMEDIATE Query1 USING ServiceStatus, ServiceStatusMsg, lWorkItemCount, PSID;
END;
