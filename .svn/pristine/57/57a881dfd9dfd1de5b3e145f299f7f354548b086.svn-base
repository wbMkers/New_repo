/*----------------------------------------------------------------------------------------------------
		NEWGEN SOFTWARE TECHNOLOGIES LIMITED
------------------------------------------------------------------------------------------------------
	Group					: Genesis
	Product / Project		: OmniFLow 10.1
	Module					: Transaction Server
	File Name				: WFGetNextWorkItemForPS.sql
	Author					: Mohnish Chopra
	Date written (DD/MM/YYYY)	: 17/02/2014
	Description				: Stored procedure that returns the locked workitem data for PS . If no locked workitem exists, then SP
							  locks the workitem and then returns the same.
------------------------------------------------------------------------------------------------------
			CHANGE HISTORY
------------------------------------------------------------------------------------------------------
 Date		Change By		Change Description (Bug No. (If Any))
11/11/2016	RishiRam Meel   Bug 64860 - Support for Bulk PS for  Postgresql DB 
19/05/2018	Ambuj		PRDP Merging :: Bug 77534 - Optimization in Procedures WFLoadAssignmentPS and WFGetNextWorkitemForPS
23/07/2020  Shubham Singla      Internal Bug:Code modified for picking up only that workitems that are being locked for more than 3 seconds.
12/08/2020	Ravi Ranjan Kumar	Bug 94039 - Weblogic+Oracle Upgrade ibps5 to ibps5sp1: PS utility is giving error on starting
18/11/2020	Ashutosh Pandey	Bug 96111 - Issues identified in Bulk ps functionality .Distribution logic in Bulk ps sp is not correct.
----------------------------------------------------------------------------------------------------*/
CREATE OR REPLACE PROCEDURE WFGetNextWorkItemForPS (
	DBSessionId			INTEGER,
	DBCSName			NVARCHAR2,
	DBProcessDefId		INTEGER,
	DBBulkPS			NVARCHAR2,
	out_mainCode		OUT	INT,
	out_csSessionId		OUT	INT,
	out_psId			OUT INT,
	out_psName  		OUT NVARCHAR2,
	out_refCursor		OUT ORACONSTPKG.DBLIST
)
AS
	v_ProcessInstanceId		WFINSTRUMENTTABLE.PROCESSINSTANCEID%Type;
	v_WorkItemId			INT;
	v_rowCount				INT;
	v_DBStatus				INT;
	v_psId					PSREGISTERATIONTABLE.PSID%Type;
	v_psName				PSREGISTERATIONTABLE.PSNAME%Type;
	v_queryStr				VARCHAR2(4000);
	v_rowFetched			INT;
	
BEGIN
	out_mainCode		:= 0;		
	v_rowFetched		:= 0;
	/* Check session validity */
	BEGIN
		SELECT	PSReg.PSID, PSReg.PSName INTO v_psId ,	v_psName
		FROM	PSREGISTERATIONTABLE PSReg, WFPSConnection PSCon 
		WHERE	PSCon.SessionID	= DBSessionId AND PSReg.PSID = PSCon.PSID; 
	
		v_rowCount := SQL%ROWCOUNT; 
		v_DBStatus := SQLCODE;
		out_psId := v_psId;
		out_psName := v_psName;
	EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
				v_rowCount := 0;			
	END; 	
	
	IF( v_DBStatus <> 0 OR v_rowCount <= 0 ) THEN
	BEGIN	
		out_mainCode	:= 11;		/*Invalid Session Handle */
		RETURN;
	END;
	END IF;	
	
	/* Return CSSessionId */
	BEGIN
		Select PSCon.SessionID INTO out_csSessionId from PSREGISTERATIONTABLE PSReg, WFPSConnection PSCon where PSReg.Type = 'C' AND PSReg.PSName = DBCSName AND PSReg.PSID = PSCon.PSID;
	EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
				v_rowCount := 0;			
	END; 	
	BEGIN
		SAVEPOINT LockWI;
		IF(DBBulkPS = 'Y') THEN
		BEGIN
			BEGIN
				SELECT	ProcessInstanceId, Workitemid INTO v_ProcessInstanceId , v_Workitemid
				FROM WFINSTRUMENTTABLE
				WHERE ProcessDefId = DBProcessDefId
				AND RoutingStatus = 'Y' 
				AND LockStatus = 'Y'
				AND LockedTime < (SYSDATE - TO_CHAR(3/86400))
				AND Q_UserId = v_psId
				AND ROWNUM <= 1 FOR UPDATE;
				v_rowCount := SQL%ROWCOUNT;
				v_DBStatus := SQLCODE;
			EXCEPTION 
				WHEN NO_DATA_FOUND THEN 
					v_rowCount := 0;
			END;
			IF(v_DBStatus <> 0) THEN
			BEGIN
				ROLLBACK TO SAVEPOINT LockWI;
				out_mainCode	:= 15;		/* ERROR_IN_PROCESSING */
				raise_application_error(-20118, 'WFGetNextWorkItemForPS: Error while fetching the Workitem Locked by BulkPS from WFINSTRUMENTTABLE');
				RETURN;
			END;
			END IF;
			IF(v_rowCount > 0) THEN
			BEGIN
				UPDATE WFINSTRUMENTTABLE SET LockedTime = SYSDATE WHERE ProcessInstanceId = v_ProcessInstanceId AND Workitemid = v_Workitemid;
				v_rowFetched := 1;
				v_queryStr := 'SELECT ProcessInstanceId, Workitemid, ProcessName, ProcessVersion, LastProcessedBy, ProcessedBy, ActivityName, ActivityId, EntryDateTime, ParentWorkItemId, AssignmentType, CollectFlag, PriorityLevel, CreatedDateTime, ExpectedWorkitemDelay, PreviousStage FROM WFINSTRUMENTTABLE	WHERE ProcessInstanceId = :v_ProcessInstanceId AND WorkitemId = :v_Workitemid ';
			END;
			END IF;
		END;
		END IF;
		
		IF(v_rowFetched = 0) THEN
		BEGIN
			BEGIN
				SELECT	ProcessInstanceId, Workitemid INTO v_ProcessInstanceId , v_Workitemid
				FROM	WFINSTRUMENTTABLE
				WHERE	ProcessDefId = DBProcessDefId
				AND RoutingStatus = 'Y' 
				AND LockStatus = 'N'
				AND ROWNUM <= 1 FOR UPDATE;
				v_rowCount := SQL%ROWCOUNT;
				v_DBStatus := SQLCODE;
			EXCEPTION 
				WHEN NO_DATA_FOUND THEN 
					v_rowCount := 0;			
			END;
			IF(v_DBStatus <> 0) THEN
			BEGIN
				ROLLBACK TO SAVEPOINT LockWI;
				out_mainCode	:= 15;		/* ERROR_IN_PROCESSING */
				raise_application_error(-20118, 'WFGetNextWorkItemForPS: Error while fetching the next Unlocked Workitem from WorkDoneTable');
				RETURN;
			END;
			END IF;
			IF(v_rowCount <= 0) THEN
			BEGIN
				IF(DBBulkPS = 'Y') THEN
				--IF(v_X = 'Y') THEN
				BEGIN
					ROLLBACK TO SAVEPOINT LockWI;
					out_mainCode	:= 18;		/* NO_MORE_DATA */
					RETURN;
				END;
				ELSE
				BEGIN
					v_rowFetched := 2;
					v_queryStr := 'SELECT ProcessInstanceId, Workitemid, ProcessName, ProcessVersion, LastProcessedBy, ProcessedBy, ActivityName, ActivityId, EntryDateTime, ParentWorkItemId, AssignmentType, CollectFlag, PriorityLevel, CreatedDateTime, ExpectedWorkitemDelay, PreviousStage FROM WFINSTRUMENTTABLE	WHERE ProcessDefId = :DBProcessDefId AND RoutingStatus = ''Y'' AND LockStatus = ''Y'' AND LockedTime < (SYSDATE - TO_CHAR(3/86400)) AND Q_UserId = :v_psId AND ROWNUM <= 1';
				END;
				END IF;
			END;
			ELSE			
			BEGIN				
				UPDATE WFINSTRUMENTTABLE SET LockedByName = v_psName, LockStatus = N'Y', LOCKEDTIME = SYSDATE, Q_UserId = v_psId WHERE ProcessInstanceId = v_ProcessInstanceId AND WorkitemId = v_Workitemid;
				v_rowCount := SQL%ROWCOUNT; 
				v_DBStatus := SQLCODE;
				IF(v_DBStatus <> 0) THEN
				BEGIN
					ROLLBACK TO SAVEPOINT LockWI;
					out_mainCode	:= 15;		/* ERROR_IN_PROCESSING */
					raise_application_error(-20118, 'WFGetNextWorkItemForPS: Error while Updating the status of fetched Workitem from WFINSTRUMENTTABLE');
					RETURN;
				END;
				END IF;
				IF (v_rowCount > 0) THEN
				BEGIN
					v_rowFetched := 1;
					v_queryStr := 'SELECT ProcessInstanceId, Workitemid, ProcessName, ProcessVersion, LastProcessedBy, ProcessedBy, ActivityName, ActivityId, EntryDateTime, ParentWorkItemId, AssignmentType, CollectFlag, PriorityLevel, CreatedDateTime, ExpectedWorkitemDelay, PreviousStage FROM WFINSTRUMENTTABLE	WHERE ProcessInstanceId = :v_ProcessInstanceId AND WorkitemId = :v_Workitemid';
				END;
				ELSE
				BEGIN
					ROLLBACK TO SAVEPOINT LockWI;
					out_mainCode	:= 15;		/* ERROR_IN_PROCESSING */
					raise_application_error(-20118, 'WFGetNextWorkItemForPS: Error due to RowCount returned while Updating the status of fetched Workitem from WorkDoneTable');
					RETURN;
				END;
				END IF;
			END;
			END IF;
		END;
		END IF;
		COMMIT;	/* Workitem has been fetched so commit the transaction.*/
		IF(v_rowFetched = 1) THEN
		BEGIN
			OPEN out_refCursor FOR v_queryStr USING v_ProcessInstanceId, v_Workitemid;
		END;
		ELSIF(v_rowFetched = 2) THEN
		BEGIN
			OPEN out_refCursor FOR v_queryStr USING DBProcessDefId, v_psId;
		END;
		END IF;
	END;
END;