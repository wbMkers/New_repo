/*____________________________________________________________________________________________________
			NEWGEN SOFTWARE TECHNOLOGIES LIMITED
______________________________________________________________________________________________________
	Group				: Genesis
	Product / Project	: OmniFlow 10.1
	Module				: Transaction Server
	File Name			: WFLoadAssignmentPS.sql (Oracle)
	Author				: Mohnish Chopra
	Date written (DD/MM/YYYY)	: 09/05/2016
	Description			: Stored procedure to Distribute Load among PS for Bulk load activities
______________________________________________________________________________________________________
				CHANGE HISTORY
______________________________________________________________________________________________________
 Date		  Change By		    Change Description (Bug No. (If Any))
12-12-2014    Hitesh Singla     Changes made for Postgres support 
11/10/2016	  RishiRam Meel     Bug 64860 - Support for Bulk PS for  Postgresql DB 
22/04/2018  Ambuj Tripathi		Bug 76862 - Remove the db console messages from all procedures
19/05/2018	Ambuj		PRDP Merging :: Bug 77534 - Optimization in Procedures WFLoadAssignmentPS and WFGetNextWorkitemForPS
____________________________________________________________________________________________________*/
CREATE OR REPLACE FUNCTION WFLoadAssignmentPS(
    DBthreshold         INTEGER,
	DBUseFactor         INTEGER, /* Use this much ratio of PS for load*/
    DBUnUseFactor       INTEGER, /* Use this much ratio of PS for normal use*/
    DBTimeOutParameter  INTEGER,
	ActivityID			INTEGER DEFAULT 0,
	ProcessDefId		INTEGER DEFAULT 0	  		
)
RETURNS void AS  $$ 
DECLARE
	v_STR1              VARCHAR(8000);
    v_STR2              VARCHAR(8000);
    v_STR3              VARCHAR(8000);
	v_ACT				VARCHAR(1);
	v_ISBULKPS			VARCHAR(1);
    cur_PSId            REFCURSOR;
    cur_ProcDefId       REFCURSOR;
    v_ProcessDefId      INT;
    v_ActivityId        INT;
    v_count             INT;
    v_fCount            INT;
    v_PSId              INT;
    v_WICount           INT;
    v_psName		PSREGISTERATIONTABLE.PSNAME%Type;
BEGIN
	IF(ProcessDefId <= 0) THEN
		BEGIN
			RETURN ;
		END	;
	END IF;
	
	IF(ActivityID <> 0) THEN
		v_ACT := 'Y';
	ELSE
		v_ACT := 'N';
	END IF;

	IF(DBUseFactor = 0) THEN
		v_ISBULKPS := 'Y';
	ELSE
		v_ISBULKPS := 'N';
	END IF;
	
	IF(v_ACT = 'Y') THEN
		v_STR1 := 'UPDATE WFINSTRUMENTTABLE SET Q_USERId = NULL, LOCKEDTIME = NULL, LOCKSTATUS = ''N'', LOCKEDBYNAME = NULL WHERE LockStatus = ''Y'' AND ROUTINGSTATUS = ''Y'' AND LockedTime < (CURRENT_TIMESTAMP - ' || DBTimeOutParameter||'* interval ''1 minute'') AND ActivityId = ' || CAST(ActivityID AS VARCHAR) || ' AND PROCESSDEFID = ' || CAST(ProcessDefId AS VARCHAR); 
  
	ELSE
		v_STR1 := 'UPDATE WFINSTRUMENTTABLE SET Q_USERId = NULL, LOCKEDTIME = NULL, LOCKSTATUS = ''N'', LOCKEDBYNAME = NULL WHERE LockStatus = ''Y'' AND ROUTINGSTATUS = ''Y''  AND LockedTime < (CURRENT_TIMESTAMP - '|| DBTimeOutParameter||'* interval ''1 minute'')';
	END IF;
	
	EXECUTE  v_STR1; 
	
	 IF(v_ACT = 'Y') THEN  
		v_STR1:= 'SELECT ProcessDefId, ActivityId FROM WFINSTRUMENTTABLE WHERE PROCESSDEFID = ' || CAST(ProcessDefId AS VARCHAR) || ' AND ActivityId = ' ||CAST(ActivityID AS VARCHAR)|| ' AND LockStatus = ''N'' AND ROUTINGSTATUS = ''Y'' GROUP BY processdefid, activityid HAVING count(1) > ' || CAST(DBthreshold AS VARCHAR);
	ELSE
		v_STR1:= 'SELECT ProcessDefId, ActivityId FROM WFINSTRUMENTTABLE WHERE PROCESSDEFID = ' || CAST(ProcessDefId AS VARCHAR) || ' AND LockStatus = ''N''  AND ROUTINGSTATUS = ''Y''  GROUP BY processdefid, activityid HAVING count(1) > ' || CAST(DBthreshold AS VARCHAR); 
	END IF;
	--Raise Notice 'v_STR1 %',v_STR1 ;
	OPEN cur_ProcDefId FOR EXECUTE v_STR1;
    LOOP
        FETCH cur_ProcDefId INTO v_ProcessDefId, v_ActivityId;
        EXIT  WHEN NOT FOUND;
		IF(v_ISBULKPS = 'Y') THEN
			EXECUTE 'SELECT count(1) FROM PSRegisterationTable  psreg inner join WFPSConnection pscon on psreg.psid=pscon.psid WHERE Data = ''PROCESS SERVER'' AND ProcessDefId = '
			|| CAST(v_ProcessDefId AS VARCHAR) ||' and pscon.SessionId is not NULL and UPPER(BulkPS) = ''Y''' INTO v_count;
		ELSE
			EXECUTE 'SELECT count(1) FROM PSRegisterationTable psreg inner join WFPSConnection pscon on psreg.psid=pscon.psid WHERE Data = ''PROCESS SERVER'' AND ProcessDefId = '
			|| CAST(v_ProcessDefId AS VARCHAR) ||' and pscon.SessionId is not NULL ' INTO v_count;
			v_count := v_count * (DBUseFactor/ (DBUseFactor + DBUnUseFactor));
		END IF;
           
		EXECUTE  'SELECT FLOOR('||v_count||') 'INTO v_fCount;
		IF v_fCount <> 0 THEN
			IF(v_ISBULKPS = 'Y') THEN
				v_STR2 := 'SELECT psreg.psid, psreg.PSName FROM PSRegisterationTable psreg inner join WFPSConnection pscon on psreg.psid=pscon.psid WHERE Data = ''PROCESS SERVER'' AND ProcessDefId = ' || CAST(v_ProcessDefId AS VARCHAR) || ' and pscon.SessionId is not NULL and UPPER(BulkPS) = ''Y'' order by PSId LIMIT '|| CAST(v_fCount AS VARCHAR);
			ELSE
				v_STR2 := 'SELECT psreg.psid, psreg.PSName FROM PSRegisterationTable psreg inner join WFPSConnection pscon on psreg.psid=pscon.psid WHERE Data = ''PROCESS SERVER'' AND ProcessDefId = ' || CAST(v_ProcessDefId AS VARCHAR) || ' and pscon.SessionId is not NULL order by PSId LIMIT '|| CAST(v_fCount AS VARCHAR) ;
			END IF;
		--Raise Notice 'v_STR2 %',v_STR2 ;
	
			EXECUTE 'SELECT count(1) FROM WFINSTRUMENTTABLE WHERE ProcessDefId = '|| CAST(v_ProcessDefId AS VARCHAR) || ' AND LockStatus = ''N''  AND ROUTINGSTATUS = ''Y''   AND ActivityId = ' || CAST(v_ActivityId AS VARCHAR) INTO v_WICount;
			v_WICount := v_WICount/ v_fCount;
			--Raise Notice 'v_WICount %',v_WICount ;

			EXECUTE 'SELECT FLOOR('||v_WICount||') 'INTO v_WICount;
			OPEN cur_PSId FOR EXECUTE v_STR2;
				LOOP
					FETCH cur_PSId INTO v_PSId, v_psName;
					EXIT  WHEN NOT FOUND;
					
					EXECUTE  'UPDATE WFINSTRUMENTTABLE wfsinst SET LOCKEDTIME = CURRENT_TIMESTAMP , Q_UserId = '
						  || CAST(v_PSId AS VARCHAR) || ', LOCKEDBYNAME = ' || ' '' ' ||CAST(v_psName AS VARCHAR) || ' '' ' || ', LOCKSTATUS = N''Y'' from (Select processinstanceid from WFINSTRUMENTTABLE WHERE ProcessDefId = ' || CAST(v_ProcessDefId AS VARCHAR) 
						  ||' AND ActivityId = ' || CAST(v_ActivityId AS VARCHAR) 
						  || ' AND LockStatus = ''N'' AND (Q_USERId IS NULL OR Q_USERId=0) AND ROUTINGSTATUS = ''Y''   LIMIT ' || CAST(v_WICount AS VARCHAR) ||') sub where wfsinst.processinstanceid = sub.processinstanceid ';
						  
				END LOOP;
			CLOSE cur_PSId;
		END IF;
    END LOOP;
    CLOSE cur_ProcDefId;
END;
$$ LANGUAGE Plpgsql;