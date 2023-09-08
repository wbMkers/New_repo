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

CREATE OR REPLACE FUNCTION WFSetCustomServiceStatus (
	PSID				INTEGER,
	ServiceStatus		INTEGER,
	ServiceStatusMsg	VARCHAR(100),
	WorkItemCount		INTEGER
)
RETURNS VOID AS $$
DECLARE
	lWorkItemCount		INTEGER;
	WorkItemCountExp	VARCHAR(100);
	Query1				VARCHAR(2000);
BEGIN
	lWorkItemCount := COALESCE(WorkItemCount, 0);
	IF(lWorkItemCount >= 0) THEN
		WorkItemCountExp := '(WorkItemCount + $3)';
	ELSIF(lWorkItemCount = -1) THEN
		lWorkItemCount := 0;
		WorkItemCountExp := '$3';
	ELSE
		lWorkItemCount := 0;
		WorkItemCountExp := '(WorkItemCount + $3)';
	END IF;

	Query1 := 'UPDATE WFCustomServicesStatusTable SET ServiceStatus = $1, ServiceStatusMsg = $2, WorkItemCount = ' || WorkItemCountExp || ', LastUpdated = CURRENT_TIMESTAMP WHERE PSID = $4';
	EXECUTE Query1 USING ServiceStatus, ServiceStatusMsg, lWorkItemCount, PSID;
END;
$$ LANGUAGE plpgsql;
