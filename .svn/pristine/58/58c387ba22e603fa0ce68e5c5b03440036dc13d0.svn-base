/*____________________________________________________________________________________________________
			NEWGEN SOFTWARE TECHNOLOGIES LIMITED
______________________________________________________________________________________________________
	Group				: Genesis
	Product / Project	: OmniFlow 10.1
	Module				: Transaction Server
	File Name			: WFLoadAssignmentPS.sql (Oracle)
	Author				: Mohnish Chopra
	Date written (DD/MM/YYYY)	: 18/02/2014
	Description                  : Stored procedure to distribute the load of completed workitems among
                                   running process servers.
                                   This procedure shall be scheduled on an interval of 15 mins.

                                   The recommended value of DBThreshold is 500.
                                   This parameter is the count of workitems on an activity, beyond which
                                   load on the acitvity will be distributed among running PS.

                                   The recommended value of DBTimeOutParameter is 30 mins.
                                   If PS does not process an item which is allocated for given time.
                                   Workitem is be send back to pool for redistribution.
________________________________________________________________________________________________________
				CHANGE HISTORY
______________________________________________________________________________________________________
 Date		Change By		Change Description (Bug No. (If Any))
13/10/16	Rishi		    Bug-64860 - PRDP Bug 59917 - Bulk Ps support
22/04/2018	Kumar Kimil		Bug 77269 - CheckMarx changes (High Severity) 
22/04/2018  Ambuj Tripathi		Bug 76862 - Remove the db console messages from all procedures
19/05/2018	Ambuj		PRDP Merging :: Bug 77534 - Optimization in Procedures WFLoadAssignmentPS and WFGetNextWorkitemForPS
18/11/2020	Mohnish Chopra	Bug 96111 - Issues identified in Bulk ps functionality .Distribution logic in Bulk ps sp is not correct.
____________________________________________________________________________________________________*/
CREATE OR REPLACE PROCEDURE WFLoadAssignmentPS(
    DBthreshold         INTEGER DEFAULT 500,
    DBUseFactor         INTEGER DEFAULT 0, /* Use this much ratio of PS for load*/
    DBUnUseFactor       INTEGER, /* Use this much ratio of PS for normal use*/
    DBTimeOutParameter  INTEGER DEFAULT 30,
    ActivityID			INTEGER DEFAULT 0,
	ProcessDefId		INTEGER DEFAULT 0
	
)
AS
    v_STR1              VARCHAR2(8000);
    v_STR2              VARCHAR2(8000);
    v_STR3              VARCHAR2(8000);
	v_ACT				VARCHAR2(1);
	v_ISBULKPS			VARCHAR2(1);
    TYPE DynamicCursor  IS REF CURSOR;
    cur_PSId            DynamicCursor;
    cur_ProcDefId       DynamicCursor;
    v_ProcessDefId      INT;
    v_ActivityId        INT;
    v_count             INT;
    v_fCount            INT;
    v_PSId              INT;
    v_WICount           INT;
	v_quoteChar 			CHAR(1);
	v_psName			PSREGISTERATIONTABLE.PSNAME%Type;
	v_timeOutParameter  INTEGER;

BEGIN
	
	--DBMS_OUTPUT.PUT_LINE('DBthreshold'||DBthreshold);
	--DBMS_OUTPUT.PUT_LINE('DBUseFactor'||DBUseFactor);
	--DBMS_OUTPUT.PUT_LINE('DBUnUseFactor'||DBUnUseFactor);
	--DBMS_OUTPUT.PUT_LINE('DBTimeOutParameter'||DBTimeOutParameter);
	--DBMS_OUTPUT.PUT_LINE('ActivityID'||ActivityID);
	v_quoteChar := CHR(39);
	v_timeOutParameter := DBTimeOutParameter;
	IF(ProcessDefId <= 0) THEN
		BEGIN
			RETURN ;
		END	;
	END IF;
	
	IF(v_timeOutParameter < 5) THEN
		v_timeOutParameter := 5;
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
		v_STR1 := 'UPDATE WFINSTRUMENTTABLE SET Q_USERId = NULL, LOCKEDTIME = NULL, LOCKSTATUS = N''N'', LOCKEDBYNAME = NULL WHERE PROCESSDEFID = ' || TO_CHAR(ProcessDefId) || ' AND ActivityId = ' || TO_CHAR(ActivityID) || ' AND LockStatus = ''Y'' AND ROUTINGSTATUS = ''Y'' AND LockedTime < (SYSDATE - ' || TO_CHAR(v_timeOutParameter/ (24 * 60)) || ')'; 
	ELSE
		v_STR1 := 'UPDATE WFINSTRUMENTTABLE SET Q_USERId = NULL, LOCKEDTIME = NULL, LOCKSTATUS = N''N'', LOCKEDBYNAME = NULL WHERE PROCESSDEFID = ' || TO_CHAR(ProcessDefId) || ' AND LockStatus = ''Y'' AND ROUTINGSTATUS = ''Y''  AND LockedTime < (SYSDATE - ' || TO_CHAR(v_timeOutParameter/ (24 * 60)) || ')';
	END IF;
	
	EXECUTE IMMEDIATE TO_char(v_STR1);
    COMMIT; 
	
    IF(v_ACT = 'Y') THEN  
		v_STR1:= 'SELECT ProcessDefId, ActivityId FROM WFINSTRUMENTTABLE WHERE PROCESSDEFID = ' || TO_CHAR(ProcessDefId) || ' AND ActivityId = ' ||TO_CHAR(ActivityID)|| ' AND LockStatus = ''N'' AND ROUTINGSTATUS = ''Y''  GROUP BY processdefid, activityid HAVING count(1) > ' || TO_CHAR(DBthreshold);
	ELSE
		v_STR1:= 'SELECT ProcessDefId, ActivityId FROM WFINSTRUMENTTABLE WHERE PROCESSDEFID = ' || TO_CHAR(ProcessDefId) || ' AND LockStatus = ''N''  AND ROUTINGSTATUS = ''Y''  GROUP BY processdefid, activityid HAVING count(1) > ' || TO_CHAR(DBthreshold); 
	END IF;
	
    OPEN cur_ProcDefId FOR v_STR1;
    LOOP
        FETCH cur_ProcDefId INTO v_ProcessDefId, v_ActivityId;
        EXIT
        WHEN cur_ProcDefId%NOTFOUND;    
        BEGIN
			IF(v_ISBULKPS = 'Y') THEN
				EXECUTE IMMEDIATE 'SELECT count(1) FROM PSRegisterationTable psreg inner join WFPSConnection pscon on psreg.psid=pscon.psid WHERE Data = ''PROCESS SERVER'' AND ProcessDefId = '
				|| TO_CHAR(v_ProcessDefId) ||' and pscon.SessionId is not NULL and UPPER(BulkPS) = ''Y''' INTO v_count;
			ELSE
				EXECUTE IMMEDIATE 'SELECT count(1) FROM PSRegisterationTable  psreg inner join WFPSConnection pscon on psreg.psid=pscon.psid WHERE Data = ''PROCESS SERVER'' AND ProcessDefId = '
                || TO_CHAR(v_ProcessDefId) ||' and pscon.SessionId is not NULL' INTO v_count;
				v_count := v_count * (DBUseFactor/ (DBUseFactor + DBUnUseFactor));
			END IF;
          
            EXECUTE IMMEDIATE 'SELECT FLOOR('||v_count||') FROM DUAL 'INTO v_fCount;
			 --dbms_output.put_line('No of ps '||v_fCount);
            IF v_fCount <> 0 THEN
                BEGIN
					IF(v_ISBULKPS = 'Y') THEN
						v_STR2 := 'SELECT psreg.psid, psreg.PSName FROM PSRegisterationTable psreg inner join WFPSConnection pscon on psreg.psid=pscon.psid WHERE Data = ''PROCESS SERVER'' AND ProcessDefId = ' || TO_CHAR(v_ProcessDefId) || ' and pscon.SessionId is not NULL and UPPER(BulkPS) = ''Y'' and rownum<= '|| TO_CHAR(v_fCount) ||' order by PSId';
					ELSE
						v_STR2 := 'SELECT psreg.psid, psreg.PSName FROM PSRegisterationTable psreg inner join WFPSConnection pscon on psreg.psid=pscon.psid WHERE Data = ''PROCESS SERVER'' AND ProcessDefId = ' || TO_CHAR(v_ProcessDefId) || ' and pscon.SessionId is not NULL and rownum<= '|| TO_CHAR(v_fCount) ||' order by PSId';
					END IF;
					--dbms_output.put_line('QUERY ' ||v_STR2);
                    EXECUTE IMMEDIATE 'SELECT count(1) FROM WFINSTRUMENTTABLE WHERE ProcessDefId = ' || TO_CHAR(v_ProcessDefId) 
                                      || ' AND ActivityId = ' || TO_CHAR(v_ActivityId) || ' AND LockStatus = ''N''  AND ROUTINGSTATUS = ''Y''' INTO v_WICount;
                    v_WICount := v_WICount/ v_fCount;
					--dbms_output.put_line('No of WORKITEM '||v_WICount);

--                  --dbms_output.put_line(v_WICount);
                    EXECUTE IMMEDIATE 'SELECT FLOOR('||v_WICount||') FROM DUAL 'INTO v_WICount;
                    OPEN cur_PSId FOR v_STR2;
                    BEGIN
                        LOOP
                            FETCH cur_PSId INTO v_PSId, v_psName;
                            EXIT
                            WHEN cur_PSId%NOTFOUND;
                            BEGIN
							v_psName:=REPLACE(v_psName,v_quoteChar,v_quoteChar||v_quoteChar);--CheckMarx findings
--								
							EXECUTE IMMEDIATE 'UPDATE WFINSTRUMENTTABLE SET LOCKEDTIME = SYSDATE , Q_UserId = '
                                                  || TO_CHAR(v_PSId) || ', LOCKEDBYNAME = ' || ' '' ' ||TO_CHAR(v_psName) || ' '' ' || ', LOCKSTATUS = N''Y'' WHERE ProcessDefId = ' || TO_CHAR(v_ProcessDefId) 
                                                  ||' AND ActivityId = ' || TO_CHAR(v_ActivityId) 
                                                  || ' AND LockStatus = ''N'' AND (Q_USERId IS NULL OR Q_USERId=0) AND ROUTINGSTATUS = ''Y'' AND ROWNUM <= ' || TO_CHAR(v_WICount);
								
                                COMMIT;

                            END;
                        END LOOP;
                    EXCEPTION
                        WHEN OTHERS THEN
                            CLOSE cur_PSId;
                    END;
                    CLOSE cur_PSId;
                END;
            END IF;
        END;
    END LOOP;
    CLOSE cur_ProcDefId;
EXCEPTION
    WHEN OTHERS THEN
        CLOSE cur_ProcDefId;
END;