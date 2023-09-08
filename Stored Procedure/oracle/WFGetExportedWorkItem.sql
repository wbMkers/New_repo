/*-----------------------------------------------------------------------------------------------------
		NEWGEN SOFTWARE TECHNOLOGIES LIMITED
------------------------------------------------------------------------------------------------------
	Group				: Application –Products
	Product / Project	: IBPS 
	Module				: Transaction Server
	File Name			: WFGetExportedWorkitem.sql
	Author				: Neeraj Sharma
	Date written (DD/MM/YYYY)	: 01/11/2013
	Description			: To Check the Rights on Query WorkStep and return mainCode .
------------------------------------------------------------------------------------------------------
			CHANGE HISTORY
------------------------------------------------------------------------------------------------------
 Date		Change By		Change Description (Bug No. (If Any)) */
 
 CREATE OR REPLACE PROCEDURE WFGetExportedWorkItem(
	DBSessionId			INTEGER,
	DBProcessInstanceId		NVARCHAR2,
	DBWorkItemId			INTEGER,
	DBQueueId			INTEGER,
	DBQueueType			NVARCHAR2,	/* '' -> Search; 'F' -> FIFO; 'D', 'S', 'N' -> WIP */
	DBLastProcessInstanceId		NVARCHAR2,
	processDefId		INTEGER,
	DBGenerateLog			NVARCHAR2,
	DBAssignMe			NVARCHAR2,
	out_mainCode			OUT	INT,
	out_lockFlag			OUT NVARCHAR2,
	RefCursor			IN OUT Oraconstpkg.DBLIST
	
)

AS
/* Initializations */
	v_userIndex			INT;
	v_userName			NVARCHAR2(30);
	v_status			NVARCHAR2(1);
	v_rowCount			INT;
	v_DBStatus			INT;
	v_Q_QueueId			INT;
	v_QueryActivityId        INT;
	v_QueryPreview			NVARCHAR2(1);
	v_ActivityId 			INT;
	v_ProcessDefID			INT;
	v_quoteChar 			CHAR(1);
BEGIN
	v_quoteChar := CHR(39);
	IF(processDefId is NOT NULL) THEN
		v_processDefId:=CAST(REPLACE(processDefId,v_quoteChar,v_quoteChar||v_quoteChar) AS INTEGER);
	END IF;
	--v_processDefId :=processDefId;
	/* Check session validity */
	BEGIN
		SELECT	userIndex , userName, statusFlag INTO v_userIndex ,	v_userName, v_status
		FROM	WFSessionView, WFUserView 
		WHERE	UserId		= UserIndex 
		AND	SessionID	= DBSessionId; 
		v_rowCount := SQL%ROWCOUNT; 
		v_DBStatus := SQLCODE;
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
				v_rowCount := 0;			
	END; 

	IF( v_DBStatus <> 0 OR v_rowCount <= 0 ) THEN
		BEGIN	
			out_mainCode	:= 11;		/* Invalid Session Handle */
			RETURN;
		END;
	END IF;
	
	IF(v_status = N'N') THEN
		BEGIN
			Update WFSessionView set statusflag = 'Y' , AccessDateTime = SYSDATE
			  WHERE SessionID = DBSessionId;
		END;
	END IF;
	
	BEGIN
		/* 21/01/2008, Bugzilla Bug 1721, error code 810 - Ruhi Hira */
		IF(DBQueueId >= 0 AND ( (v_Q_QueueId IS NULL) OR (DBQueueId != v_Q_QueueId) ) )THEN
			BEGIN
				out_mainCode := 810; /* Workitem not in the queue specified. */
				RETURN;
			END;
		END IF;
		BEGIN
			/*WFS_8.0_031*/
			SELECT ActivityId, QueryPreview INTO v_QueryActivityId ,v_QueryPreview FROM (
				SELECT ACTIVITYTABLE.ActivityId , QUEUEUSERTABLE.QueryPreview 
				FROM ACTIVITYTABLE, QUEUESTREAMTABLE , QUEUEUSERTABLE
				WHERE ACTIVITYTABLE.ProcessDefId = QUEUESTREAMTABLE.ProcessDefId
				AND ACTIVITYTABLE.ActivityId = QUEUESTREAMTABLE.ActivityId
				AND QUEUEUSERTABLE.QueueId = QUEUESTREAMTABLE.QueueId
				AND ACTIVITYTABLE.ActivityType = 11
				AND ACTIVITYTABLE.ProcessDefId = v_ProcessDefID
				AND QUEUEUSERTABLE.UserId = v_userIndex
				AND associationtype=0
				ORDER BY QUEUEUSERTABLE.UserId DESC
				)WHERE ROWNUM <= 1;

				v_rowCount := SQL%ROWCOUNT; 
			EXCEPTION
				WHEN NO_DATA_FOUND THEN
					v_rowCount := 0;
		END;
		IF(v_rowCount <= 0) THEN
			BEGIN
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
					)WHERE ROWNUM <= 1;
					
					v_rowCount := SQL%ROWCOUNT; 
				EXCEPTION
					WHEN NO_DATA_FOUND THEN
						v_rowCount := 0;
			END;
			IF(v_rowCount <= 0) THEN
				BEGIN
					out_mainCode := 300; /*No Authorization*/
					RETURN;
				END;
			ELSE
				BEGIN
					out_mainCode := 16; /*To be shown in Read only mode*/
					/*WFS_8.0_031*/
					IF(v_QueryPreview = 'Y' OR v_QueryPreview IS NULL) THEN
						v_ActivityId := v_QueryActivityId;
					END IF;
				END;
			END IF;
		ELSE
			BEGIN
				out_mainCode := 16; /*To be shown in Read only mode*/
				/*WFS_8.0_031*/
				IF(v_QueryPreview = 'Y' OR v_QueryPreview IS NULL) THEN
					v_ActivityId := v_QueryActivityId;
				END IF;
			END;
		END IF;		
	END;
	
END;	
	