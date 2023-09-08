/*----------------------------------------------------------------------------------------------------
		NEWGEN SOFTWARE TECHNOLOGIES LIMITED
------------------------------------------------------------------------------------------------------
	Group							: Application –Products
	Product / Project				: iBPS
	Module							: Transaction Server
	File Name						: WFGetExportedWorkitem.sql
	Author							: Sajid Khan
	Date written (DD/MM/YYYY)		: 01/11/2013
	Description						: To Check the Rights on Query WorkStep and return mainCode .
------------------------------------------------------------------------------------------------------
			CHANGE HISTORY
------------------------------------------------------------------------------------------------------
 Date					Change By								Change Description (Bug No. (If Any)) 
 
 
 
 */
 CREATE OR REPLACE FUNCTION WFGetExportedWorkItem(
	DBSessionId					INTEGER,
	DBProcessInstanceId			VARCHAR,
	DBWorkItemId				INTEGER,
	DBQueueId					INTEGER,
	DBQueueType					VARCHAR,	/* '' -> Search; 'F' -> FIFO; 'D', 'S', 'N' -> WIP */
	DBLastProcessInstanceId		VARCHAR,
	processDefId				INTEGER,
	DBGenerateLog				VARCHAR,
	DBAssignMe					VARCHAR,
	DBUtilityFlag 				VARCHAR
)returns refcursor  AS $$ 

DECLARE
/* Initializations */
    ResultSet	 		refcursor;
	v_userIndex			INT;
	v_userName			VARCHAR(30);
	v_status			VARCHAR(1);
	v_rowCount			INT;
	v_DBStatus			INT;
	v_Q_QueueId			INT;
	v_QueryActivityId   INT;
	v_QueryPreview		VARCHAR(1);
	v_ProcessDefID		INT;
	out_mainCode		INT;
	out_lockFlag		VARCHAR;
	v_ActivityId        INT;
	
BEGIN
	v_processDefId :=processDefId;
	/* Check session validity */
	
	SELECT	userIndex , userName, statusFlag INTO v_userIndex ,	v_userName, v_status
	FROM	WFSessionView, WFUserView 
	WHERE	UserId		= UserIndex 
	AND	SessionID	= DBSessionId; 

	GET DIAGNOSTICS v_rowCount = ROW_COUNT;

	IF v_rowCount <= 0  THEN
		out_mainCode	:= 11;		/* Invalid Session Handle */
		OPEN ResultSet for Select out_mainCode as mainCode, out_lockFlag as LockFlag,v_userIndex as UserIndex,v_ActivityId  as ActivityId;
		RETURN ResultSet;
	END IF;
	
	IF v_status = 'N' THEN
		Update WFSessionView set statusflag = 'Y' , AccessDateTime = CURRENT_TIMESTAMP
		WHERE SessionID = DBSessionId;
	END IF;

	IF DBQueueId >= 0 AND ( (v_Q_QueueId IS NULL) OR (DBQueueId != v_Q_QueueId) ) THEN
		out_mainCode := 810; /* Workitem not in the queue specified. */
		OPEN ResultSet for Select out_mainCode as mainCode, out_lockFlag as LockFlag,v_userIndex as UserIndex,v_ActivityId  as ActivityId;
		RETURN ResultSet;
	END IF;
	
	SELECT ActivityId, QueryPreview INTO v_QueryActivityId ,v_QueryPreview FROM (
		SELECT ACTIVITYTABLE.ActivityId , QUSERGROUPVIEW.QueryPreview 
		FROM ACTIVITYTABLE, QUEUESTREAMTABLE , QUSERGROUPVIEW
		WHERE ACTIVITYTABLE.ProcessDefId = QUEUESTREAMTABLE.ProcessDefId
		AND ACTIVITYTABLE.ActivityId = QUEUESTREAMTABLE.ActivityId
		AND QUSERGROUPVIEW.QueueId = QUEUESTREAMTABLE.QueueId
		AND ACTIVITYTABLE.ActivityType = 11
		AND ACTIVITYTABLE.ProcessDefId = v_ProcessDefID
		AND QUSERGROUPVIEW.UserId = v_userIndex
		ORDER BY QUSERGROUPVIEW.GroupId DESC
	) AS TEMP1 LIMIT 1;

	GET DIAGNOSTICS v_rowCount = ROW_COUNT;
	
	IF v_rowCount <= 0 THEN
			SELECT ActivityId, QueryPreview INTO v_QueryActivityId ,v_QueryPreview FROM (
					SELECT ACTIVITYTABLE.ActivityId , QUEUEUSERTABLE.QueryPreview 
					FROM ACTIVITYTABLE, QUEUESTREAMTABLE , QUEUEUSERTABLE,wfgroupmemberview
					WHERE ACTIVITYTABLE.ProcessDefId = QUEUESTREAMTABLE.ProcessDefId
					AND ACTIVITYTABLE.ActivityId = QUEUESTREAMTABLE.ActivityId
					AND QUEUEUSERTABLE.QueueId = QUEUESTREAMTABLE.QueueId
					AND ACTIVITYTABLE.ActivityType = 11
					AND ACTIVITYTABLE.ProcessDefId = v_ProcessDefID
					AND QUEUEUSERTABLE.UserId = wfgroupmemberview.groupindex
					AND associationtype=1
					ORDER BY QUEUEUSERTABLE.UserId DESC
			) AS TEMP2 LIMIT 1;
			
			GET DIAGNOSTICS v_rowCount = ROW_COUNT;
			
			IF v_rowCount <= 0 THEN
					out_mainCode := 300; /*No Authorization*/
					OPEN ResultSet for Select out_mainCode as mainCode, out_lockFlag as LockFlag,v_userIndex as UserIndex,v_ActivityId  as ActivityId;
					RETURN ResultSet;
			ELSE
				out_mainCode := 16; /*To be shown in Read only mode*/
				IF v_QueryPreview = 'Y' OR v_QueryPreview IS NULL THEN
						v_ActivityId := v_QueryActivityId;
				END IF;
			END IF;
	ELSE
			out_mainCode := 16; /*To be shown in Read only mode*/
			IF v_QueryPreview = 'Y' OR v_QueryPreview IS NULL THEN
				v_ActivityId := v_QueryActivityId;
			END IF;
	END IF;		
END;	
$$ LANGUAGE plpgsql;