/*
------------------------------------------------------------------------------------------------------
		NEWGEN SOFTWARE TECHNOLOGIES LIMITED
------------------------------------------------------------------------------------------------------
	Group					: Genesis
	Product					: iBPS
	Module					: Transaction Server
	File Name				: WFGetNextWorkItemForUtil.sql
	Author					: Shahzad Malik
	Date written			: Mar 18th, 2019
	Description				: This procedure will fetch next item present in the specified queue
------------------------------------------------------------------------------------------------------
			CHANGE HISTORY
------------------------------------------------------------------------------------------------------
Date		Change By			Change Description (Bug No. (If Any))
------------------------------------------------------------------------------------------------------
18/03/2019	Shahzad Malik		Bug 83557 - Write SP for fetching next item for utilities
23/07/2019	Ravi Ranjan Kumar   Bug 85705 - Write SP for fetching next item for utilities
13/08/2019  Ravi Ranjan Kumar   Bug 85910 - Optimization in WFGetNextWorkItemForUtil procedure
19/11/2018	Ravi Ranjan Kumar	Bug 88386 - Rest Service and Soap Service Utility ,both utility are register ,then Soap service utility picking the workitem of rest service or vice-versa
23/07/2020  Shubham Singla      Internal Bug:Code modified for picking up only that workitems that are being locked for more than 3 seconds.
------------------------------------------------------------------------------------------------------
*/
CREATE OR REPLACE PROCEDURE WFGetNextWorkItemForUtil (
	V_SESSIONID INT,
	V_Q_QUEUEID INT,
	V_CSNAME NVARCHAR2,
	OUT_MAINCODE OUT INT,
	OUT_CSSESSIONID OUT INT,
	OUT_USERID OUT INT,
	OUT_UserName OUT NVARCHAR2,
	OUT_PROCESSINSTANCEID OUT NVARCHAR2,
	OUT_WORKITEMID OUT INT,
	OUT_PROCESSDEFID OUT INT,
	OUT_ACTIVITYID OUT INT,
	OUT_PROCESSNAME OUT NVARCHAR2,
	OUT_URN OUT NVARCHAR2,
	v_tarHisLog				NVARCHAR2,
	v_targetCabinet			VARCHAR2
)

AS 
	V_ROWCOUNT  NUMBER;
	V_DBSTATUS  NUMBER;
	V_USERID NUMBER;
	V_QUERY VARCHAR2(1000);
--	V_V_SESSIONID NUMBER;
--	V_QUEUEID NUMBER;
	V_ACTIVITYNAME NVARCHAR2(100);
	V_ServiceType NVARCHAR2(256);
	V_ActivityType INT;
	V_isRestSOAP INT;
	v_insertTarStr NVARCHAR2(100);
	
BEGIN	
	OUT_MAINCODE := 0;
	V_isRestSOAP:=0;
	BEGIN
		V_QUERY := 'SELECT NVL(SESSIONID,0) FROM PSREGISTERATIONTABLE WHERE TYPE = ''C'' AND PSNAME = :CSNAME';
		EXECUTE IMMEDIATE V_QUERY INTO OUT_CSSESSIONID USING V_CSNAME;
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				OUT_CSSESSIONID := 0;
	END;
	BEGIN
		V_QUERY := 'SELECT PSReg.PSID,PSReg.PSNAME FROM PSREGISTERATIONTABLE PSReg , WFPSConnection PSCon WHERE PSCon.SESSIONID = :SESSIONID and PSReg.PSID = PSCon.PSID';
		EXECUTE IMMEDIATE V_QUERY INTO OUT_USERID, OUT_USERNAME USING V_SESSIONID;
		V_ROWCOUNT := SQL%ROWCOUNT;
		V_DBSTATUS := SQLCODE;
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN
				V_ROWCOUNT := 0;
	END;
	
	IF(V_DBSTATUS <> 0 OR V_ROWCOUNT <= 0)THEN
	BEGIN
		OUT_MAINCODE := 11;
		RETURN;
	END;
	END IF;
	
	BEGIN
		V_QUERY := 'SELECT ServiceType from WFSystemServicesTable  where PSID=:USERID';
		EXECUTE IMMEDIATE V_QUERY INTO V_ServiceType USING OUT_USERID;
		IF(upper(V_ServiceType)=upper('RestServiceInvoker')) THEN
			V_isRestSOAP:=2;
		END IF;
		IF(upper(V_ServiceType)=upper('WebService Invoker')) THEN
			V_isRestSOAP:=1;
		END IF;
	END;
	
	BEGIN
		 BEGIN
			V_QUERY := 'SELECT PROCESSINSTANCEID, WORKITEMID, PROCESSDEFID, ACTIVITYID, ACTIVITYNAME, PROCESSNAME,URN,ActivityType FROM WFINSTRUMENTTABLE WHERE Q_QUEUEID = :QUEUEID AND ROUTINGSTATUS = N''N'' AND LOCKSTATUS = N''N'' AND ROWNUM <= 1 FOR UPDATE';
			EXECUTE IMMEDIATE V_QUERY INTO OUT_PROCESSINSTANCEID, OUT_WORKITEMID, OUT_PROCESSDEFID, OUT_ACTIVITYID, V_ACTIVITYNAME,OUT_PROCESSNAME,OUT_URN,V_ActivityType USING V_Q_QUEUEID;
			V_ROWCOUNT := SQL%ROWCOUNT;
			EXCEPTION 
				WHEN NO_DATA_FOUND THEN
				BEGIN
					V_ROWCOUNT := 0;
				END;	
		 END;
		 /*IF SOAP Utility call then isRestSOAP=1 , ELSE IF REST Utility call isRestSOAP=2 else isRestSOAP=0*/
			IF(V_isRestSOAP=1 AND V_ActivityType=40) THEN 
			BEGIN
				V_ROWCOUNT :=0;
			END;
			END IF;
			IF(V_isRestSOAP=2 AND V_ActivityType=22) THEN
			BEGIN
				V_ROWCOUNT :=0;
			END;
			END IF;
			
			IF(V_ROWCOUNT > 0) THEN
			BEGIN
				V_QUERY := 'UPDATE WFINSTRUMENTTABLE SET Q_USERID = :USERID, ASSIGNEDUSER = :ASSIGNEDUSER, WORKITEMSTATE = 2, STATENAME = N''RUNNING'', LOCKEDBYNAME = :USERNAME, LOCKSTATUS = N''Y'', LOCKEDTIME = SYSDATE WHERE PROCESSINSTANCEID = :PROCESSINSTANCEID AND WORKITEMID = :WORKITEMID';
				EXECUTE IMMEDIATE V_QUERY USING OUT_USERID, OUT_UserName, OUT_UserName, OUT_PROCESSINSTANCEID, OUT_WORKITEMID;
				V_ROWCOUNT := SQL%ROWCOUNT;
				IF(V_ROWCOUNT > 0) THEN
				BEGIN
					WFGENERATELOG(7,0,OUT_PROCESSDEFID,OUT_ACTIVITYID,V_Q_QUEUEID,'System',V_ACTIVITYNAME,0,OUT_PROCESSINSTANCEID,0,NULL,OUT_WORKITEMID,0,0,OUT_MAINCODE,NULL,0 , 0 ,0 ,NULL,NULL,NULL,v_tarHisLog,v_targetCabinet);
				END;
				ELSE
				BEGIN
					OUT_MAINCODE := 18;
					RETURN;
				END;
				END IF;
			END;
			ELSE
			BEGIN
				BEGIN
					V_QUERY := 'SELECT PROCESSINSTANCEID, WORKITEMID, PROCESSDEFID, ACTIVITYID, PROCESSNAME,URN FROM WFINSTRUMENTTABLE WHERE Q_QUEUEID = :QUEUEID AND ROUTINGSTATUS = N''N'' AND LOCKSTATUS = N''Y'' AND LockedTime <  (SYSDATE-to_char(3/86400)) AND Q_USERID = :USERID AND 
					ROWNUM <= 1';
					EXECUTE IMMEDIATE V_QUERY INTO OUT_PROCESSINSTANCEID, OUT_WORKITEMID, OUT_PROCESSDEFID, OUT_ACTIVITYID, OUT_PROCESSNAME ,OUT_URN USING V_Q_QUEUEID, OUT_USERID;
					V_ROWCOUNT := SQL%ROWCOUNT;
					V_DBSTATUS := SQLCODE;
					EXCEPTION 
						WHEN NO_DATA_FOUND THEN
						BEGIN
							V_ROWCOUNT := 0;
						END;		
				END;
				IF(V_ROWCOUNT = 0)THEN
				BEGIN
					OUT_MAINCODE := 18;
					RETURN;
				END;
				END IF;
			END;
			END IF;	
	END;	
END;