/*____________________________________________________________________________________________
            NEWGEN SOFTWARE TECHNOLOGIES LIMITED
______________________________________________________________________________________________
    Group                				: Genesis.
    Product / Project    				: iBPS 
    Module               				: WorkFlow Server
    File Name            				: wfgetnextworkitemforps.sql [Postgres]
    Author               				: Mohnish Chopra
    Date written (DD/MM/YYYY)   : 09-05-2016
    Description            			: Stored procedure to get next workitem 
                                  for Process Server eligible for Routing
______________________________________________________________________________________________
                CHANGE HISTORY
______________________________________________________________________________________________
Date            Change By        Change Description (Bug No. (If Any))
______________________________________________________________________________________________

11/10/2016	RishiRam Meel   Bug 64860 - Support for Bulk PS for  Postgresql DB 
22/04/2018  Ambuj Tripathi		Bug 76862 - Remove the db console messages from all procedures
19/05/2018	Ambuj		PRDP Merging :: Bug 77534 - Optimization in Procedures WFLoadAssignmentPS and WFGetNextWorkitemForPS
23/07/2020  Shubham Singla      Internal Bug:Code modified for picking up only that workitems that are being locked for more than 3 seconds.
______________________________________________________________________________________________*/

CREATE OR REPLACE FUNCTION wfgetnextworkitemforps(
	dbsessionid 		integer,
	dbcsname 			character varying, 
	dbprocessdefid 		integer, 
	DBBulkPS 			VARCHAR
) RETURNS SETOF refcursor AS $$
DECLARE
   
	v_ProcessInstanceId		WFINSTRUMENTTABLE.PROCESSINSTANCEID%Type;
	v_WorkItemId			INT;
	v_rowCount				INT;
	v_DBStatus				INT;	
	--v_InsertedInSuspect		INT;
	v_psId					PSREGISTERATIONTABLE.PSID%Type;
	v_psName				PSREGISTERATIONTABLE.PSNAME%Type;
	v_queryStr				VARCHAR(4000);
	out_mainCode			INT;
	out_csSessionId			INT;
	out_psId			 	INT;
	out_psName  		 	VARCHAR;
	ResultSet  				REFCURSOR;
	out_refCursor			REFCURSOR;
	ResultSet1				REFCURSOR;
	v_rowFetched			INT;
	v_quoteChar 			CHAR(1);
	
BEGIN
	out_mainCode		:= 0;
	v_rowFetched		:= 0;	
	v_quoteChar			:= CHR(39);
	--v_InsertedInSuspect := 0;
	/* Check session validity */
	
		SELECT	PSReg.PSID, PSName INTO v_psId ,	v_psName
		FROM	PSRegisterationTable PSReg, WFPSConnection PSCon
		WHERE	PSCon.SessionID	= DBSessionId AND PSReg.PSID = PSCon.PSID; 
	
		GET DIAGNOSTICS v_rowCount = ROW_COUNT;
		out_psId := v_psId;
		out_psName := v_psName;
				
	 --	raise notice '%d',v_rowCount;
	IF(  v_rowCount <= 0 ) THEN
		out_mainCode	:= 11;			/*Invalid Session Handle */
		OPEN ResultSet for Select out_mainCode as mainCode,out_csSessionId as cssession,out_psId as userID,out_psName as username;
		RETURN NEXT ResultSet;
		Return;
	END IF;	
	
	/* Return CSSessionId */
	Select PSCon.SessionID INTO out_csSessionId from PSRegisterationTable PSReg, WFPSConnection PSCon where PSReg.Type = 'C' AND PSReg.PSName = DBCSName AND PSReg.PSID = PSCon.PSID;
	GET DIAGNOSTICS v_rowCount = ROW_COUNT;

	
	
	IF(DBBulkPS = 'Y') THEN
		SELECT	ProcessInstanceId, Workitemid INTO v_ProcessInstanceId , v_Workitemid
		FROM	WFINSTRUMENTTABLE
		WHERE	Q_UserId = v_psId
		AND ProcessDefId = DBProcessDefId
		AND RoutingStatus = 'Y' 
		LIMIT 1;
		
		GET DIAGNOSTICS v_rowCount = ROW_COUNT;
			
		IF(v_rowCount > 0) THEN
		BEGIN
			v_rowFetched := 1;
			v_queryStr := 'SELECT ProcessInstanceId, Workitemid, ProcessName, ProcessVersion, LastProcessedBy, ProcessedBy, ActivityName, ActivityId, EntryDateTime, ParentWorkItemId, AssignmentType, CollectFlag, PriorityLevel, CreatedDateTime, ExpectedWorkitemDelay, PreviousStage FROM WFINSTRUMENTTABLE	WHERE ProcessInstanceId = '||v_quoteChar||COALESCE(v_ProcessInstanceId,'')||v_quoteChar||' AND WorkitemId = '||COALESCE(v_Workitemid,0);
		END;
		END IF;
	END IF;
	
	IF(v_rowFetched = 0) THEN
		SELECT	ProcessInstanceId, Workitemid INTO v_ProcessInstanceId , v_Workitemid
		FROM	WFINSTRUMENTTABLE
		WHERE	ProcessDefId = DBProcessDefId
		AND RoutingStatus = 'Y' 
		AND LockStatus = 'N' 
		LIMIT 1 FOR UPDATE;
		--raise notice '%v_ProcessInstanceId',v_ProcessInstanceId;
		--raise notice '%v_Workitemid',v_Workitemid;
		--raise notice '%v_psId',v_psId;
		GET DIAGNOSTICS v_rowCount = ROW_COUNT;

		IF(v_rowCount <= 0) THEN
			IF(DBBulkPS = 'Y') THEN
				out_mainCode	:= 18;		/* NO_MORE_DATA */
				OPEN ResultSet for Select out_mainCode as mainCode,out_csSessionId as cssession,out_psId as userID,out_psName as username;
				RETURN NEXT ResultSet;
			ELSE
				v_rowFetched := 2;
				v_queryStr := 'SELECT ProcessInstanceId, Workitemid, ProcessName, ProcessVersion, LastProcessedBy, ProcessedBy, ActivityName, ActivityId, EntryDateTime, ParentWorkItemId, AssignmentType, CollectFlag, PriorityLevel, CreatedDateTime, ExpectedWorkitemDelay, PreviousStage FROM WFINSTRUMENTTABLE	WHERE ProcessDefId = '||DBProcessDefId ||' AND RoutingStatus = ''Y'' AND LockStatus = ''Y'' AND LOCKEDTIME < CURRENT_TIMESTAMP - INTERVAL ''3 second'' AND Q_UserId = '||COALESCE(v_psId,0)||' LIMIT 1';
			END IF;
		ELSE			
				UPDATE WFINSTRUMENTTABLE SET LockedByName = v_psName, LockStatus = 'Y', LOCKEDTIME = CURRENT_TIMESTAMP, Q_UserId = v_psId WHERE ProcessInstanceId = v_ProcessInstanceId AND WorkitemId = v_Workitemid;
				
				GET DIAGNOSTICS v_rowCount = ROW_COUNT;
				
				IF (v_rowCount > 0) THEN
					v_rowFetched := 1;
					v_queryStr := 'SELECT ProcessInstanceId, Workitemid, ProcessName, ProcessVersion, LastProcessedBy, ProcessedBy, ActivityName, ActivityId, EntryDateTime, ParentWorkItemId, AssignmentType, CollectFlag, PriorityLevel, CreatedDateTime, ExpectedWorkitemDelay, PreviousStage FROM WFINSTRUMENTTABLE
					WHERE ProcessInstanceId = '||v_quoteChar||COALESCE(v_ProcessInstanceId,'')||v_quoteChar||' AND WorkitemId = '||COALESCE(v_Workitemid,0) ;
				END IF;
		END IF;
	END IF;
	
	
	OPEN ResultSet1 for Select out_mainCode as mainCode,out_csSessionId as cssession,out_psId as userID,out_psName as username;
	RETURN NEXT ResultSet1;
	
	IF(v_rowFetched = 1) THEN
	BEGIN
		OPEN out_refCursor FOR EXECUTE v_queryStr ;
		RETURN NEXT out_refCursor;
		Return;
	END;
	ELSIF(v_rowFetched = 2) THEN
	BEGIN
		OPEN out_refCursor FOR EXECUTE v_queryStr ;
		RETURN NEXT out_refCursor;
		Return;
	END;
	END IF;

END;
$$ language plpgsql;