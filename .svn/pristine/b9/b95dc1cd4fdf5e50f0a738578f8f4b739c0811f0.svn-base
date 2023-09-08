/*
------------------------------------------------------------------------------------------------------
		NEWGEN SOFTWARE TECHNOLOGIES LIMITED
------------------------------------------------------------------------------------------------------
	Group					: Genesis
	Product					: iBPS
	Module					: Transaction Server
	File Name				: WFGetNextWorkItemForUtil.sql
	Author					: Ravi Ranjan Kumar
	Date written			: 22th July,2019
	Description				: This procedure will fetch next item present in the specified queue
------------------------------------------------------------------------------------------------------
			CHANGE HISTORY
------------------------------------------------------------------------------------------------------
Date		Change By			Change Description (Bug No. (If Any))
------------------------------------------------------------------------------------------------------
18/03/2019	Shahzad Malik		Bug 83557 - Write SP for fetching next item for utilities
23/07/2019		Ravi Ranjan Kumar Bug 85705 - Write SP for fetching next item for utilities
19/11/2018	Ravi Ranjan Kumar	Bug 88386 - Rest Service and Soap Service Utility ,both utility are register ,then Soap service utility picking the workitem of rest service or vice-versa
27/01/2020	Ravi Ranjan Kumar	Bug 90262 - Postgres+Jboss7+Asynchronous mode+Linux : Archive utility is not working
23/07/2020  Shubham Singla      Internal Bug:Code modified for picking up only that workitems that are being locked for more than 3 seconds.
--------------------------------------------------------------------------------
*/
CREATE OR REPLACE FUNCTION WFGetNextWorkItemForUtil ( 
	V_SESSIONID		INTEGER,
	V_Q_QUEUEID		INTEGER,
	V_CSNAME 		VARCHAR
) returns SETOF refcursor AS $$
DECLARE
	V_ROWCOUNT INT;
	V_DBSTATUS INT;
	V_USERID   INT;
	V_QUERY    VARCHAR(1000);
	V_V_SESSIONID INT;
	V_QUEUEID INT;
	V_ACTIVITYNAME VARCHAR(100);
	V_ServiceType VARCHAR(256);
	V_ActivityType INT;
	V_isRestSOAP INT;
	
	OUT_MAINCODE  INT;
	OUT_CSSESSIONID  INT;
	OUT_USERID  INT;
	OUT_UserName  VARCHAR;
	OUT_PROCESSINSTANCEID  VARCHAR;
	OUT_WORKITEMID  INT;
	OUT_PROCESSDEFID  INT;
	OUT_ACTIVITYID  INT;
	OUT_PROCESSNAME  VARCHAR;
	OUT_URN  VARCHAR;
	
	ResultSet0		REFCURSOR;
	
BEGIN

	OUT_MAINCODE := 0;
	V_isRestSOAP:=0;
	BEGIN
		SELECT SESSIONID INTO OUT_CSSESSIONID FROM PSREGISTERATIONTABLE WHERE TYPE = 'C' AND PSNAME = V_CSNAME;
		IF(NOT FOUND) THEN
			OUT_CSSESSIONID :=0;
		END IF;
	END;
	BEGIN
		SELECT PSReg.PSID,PSReg.PSNAME INTO OUT_USERID,OUT_UserName FROM PSREGISTERATIONTABLE PSReg ,WFPSConnection PSCon WHERE PSCon.SESSIONID = V_SESSIONID and PSReg.PSID = PSCon.PSID;
		IF(NOT FOUND) THEN
			V_DBSTATUS :=11;
			V_ROWCOUNT:=0;
		ELSE
			GET DIAGNOSTICS V_ROWCOUNT = ROW_COUNT;
		END IF;
	END;
	
	
	IF(V_DBSTATUS <> 0 OR V_ROWCOUNT <= 0) THEN
		OUT_MAINCODE :=11;
	    OPEN ResultSet0 FOR SELECT OUT_MAINCODE AS MAINCODE,OUT_CSSESSIONID as CSSESSSIONID, NULL AS USERID,NULL AS UserName; 
		RETURN NEXT ResultSet0;
		RETURN;
	END IF;
	
	BEGIN
		SELECT ServiceType INTO V_ServiceType  from WFSystemServicesTable  where PSID=OUT_USERID;
		IF(upper(V_ServiceType)=upper('RestServiceInvoker')) THEN
			V_isRestSOAP:=2;
		END IF;
		IF(upper(V_ServiceType)=upper('WebService Invoker')) THEN
			V_isRestSOAP:=1;
		END IF;
	END;
	
	BEGIN
		BEGIN
			V_QUERY := 'SELECT PROCESSINSTANCEID,WORKITEMID,PROCESSDEFID,ACTIVITYID,ACTIVITYNAME,PROCESSNAME,URN,Q_QUEUEID,ActivityType 
			FROM WFINSTRUMENTTABLE  WHERE 1 = 1 AND Q_QUEUEID = '||V_Q_QUEUEID||' AND ROUTINGSTATUS = ''N'' AND LOCKSTATUS = ''N''  LIMIT 1 FOR UPDATE';
			Execute  V_QUERY into  OUT_PROCESSINSTANCEID,OUT_WORKITEMID,OUT_PROCESSDEFID,OUT_ACTIVITYID,V_ACTIVITYNAME,OUT_PROCESSNAME,OUT_URN,V_QUEUEID,V_ActivityType ; 
			IF(NOT FOUND) THEN
				V_ROWCOUNT:=0;
			ELSE
				GET DIAGNOSTICS V_ROWCOUNT = ROW_COUNT;
			END IF;
		END;
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
			UPDATE WFINSTRUMENTTABLE SET Q_USERID = OUT_USERID,ASSIGNEDUSER = OUT_UserName,WORKITEMSTATE = 2,STATENAME = 'RUNNING',LOCKEDBYNAME = OUT_UserName,LOCKSTATUS = 'Y',LOCKEDTIME = CURRENT_TIMESTAMP WHERE PROCESSINSTANCEID = OUT_PROCESSINSTANCEID AND WORKITEMID = OUT_WORKITEMID;
			IF(NOT FOUND) THEN
				OUT_MAINCODE :=18;
				OPEN ResultSet0 FOR SELECT OUT_MAINCODE AS MAINCODE,OUT_CSSESSIONID as CSSESSSIONID, OUT_USERID AS USERID,OUT_UserName AS UserName; 
				RETURN NEXT ResultSet0;
				RETURN;
			ELSE
				GET DIAGNOSTICS V_ROWCOUNT = ROW_COUNT;
				OUT_MAINCODE:=WFGenerateLog( 7, 0, OUT_PROCESSDEFID, OUT_ACTIVITYID, V_Q_QUEUEID,  'SYSTEM', V_ACTIVITYNAME, 0, OUT_PROCESSINSTANCEID, 0, NULL, OUT_WORKITEMID, 0, 0, NULL ,0 ,0 ,0 , NULL,NULL)  ;
			END IF;
		END;
		ELSE
		BEGIN
			BEGIN
				V_QUERY := 'SELECT PROCESSINSTANCEID,WORKITEMID,PROCESSDEFID,ACTIVITYID,ACTIVITYNAME,PROCESSNAME,URN,Q_QUEUEID FROM WFINSTRUMENTTABLE WHERE Q_QUEUEID = '||V_Q_QUEUEID||' AND Q_USERID = '||OUT_USERID||' AND ROUTINGSTATUS = ''N'' AND LOCKSTATUS = ''Y''
				AND LOCKEDTIME < CURRENT_TIMESTAMP - INTERVAL ''3 second'' LIMIT 1';
				Execute  V_QUERY into  OUT_PROCESSINSTANCEID,OUT_WORKITEMID,OUT_PROCESSDEFID,OUT_ACTIVITYID,V_ACTIVITYNAME,OUT_PROCESSNAME,OUT_URN,V_QUEUEID;
				IF(NOT FOUND) THEN
					V_ROWCOUNT:=0;
				ELSE
					GET DIAGNOSTICS V_ROWCOUNT = ROW_COUNT;
				END IF;
			END;
			IF(V_ROWCOUNT=0) THEN
				OUT_MAINCODE :=18;
				OPEN ResultSet0 FOR SELECT OUT_MAINCODE AS MAINCODE,OUT_CSSESSIONID as CSSESSSIONID, OUT_USERID AS USERID,OUT_UserName AS UserName; 
				RETURN NEXT ResultSet0;
				RETURN;
			END IF;
		END;
		END IF;
	END;
	OPEN ResultSet0 FOR SELECT OUT_MAINCODE AS MAINCODE,OUT_CSSESSIONID as CSSESSSIONID, OUT_USERID AS USERID,OUT_UserName AS UserName ,OUT_PROCESSINSTANCEID AS PROCESSINSTANCEID,OUT_WORKITEMID AS WORKEDITEMID,OUT_PROCESSDEFID AS PROCESSDEFID,OUT_ACTIVITYID AS ACTIVITYID, OUT_PROCESSNAME AS PROCESSNAME, OUT_URN AS URN; 
	RETURN NEXT ResultSet0;
	RETURN;
		
	
END;
$$LANGUAGE plpgsql;