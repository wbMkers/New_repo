/*----------------------------------------------------------------------------------------------------
		NEWGEN SOFTWARE TECHNOLOGIES LIMITED
------------------------------------------------------------------------------------------------------
Group						: Phoenix
Product / Project				: OmniFlow 7.0.1
Module						: OmniFlow Server
File Name					: WFGetWorkitem.sql
Author						: Varun Bhansaly	
TIMESTAMP written (DD/MM/YYYY)			: 18/08/2006
Description					: To lock the workitem and return the data.
------------------------------------------------------------------------------------------------------
			CHANGE HISTORY
------------------------------------------------------------------------------------------------------
 TIMESTAMP		Change By		Change Description (Bug No. (If Any))
 16/02/2007		Varun Bhansaly	Bugzilla Id 74 (Inconsistency in date-time)
----------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE WfGetWorkItem(
DBSessionId		           INTEGER,
DBProcessInstanceId                VARGRAPHIC(63),
DBWorkItemId                       INTEGER,
DBQueueId                          INTEGER,
DBQueueType                        VARGRAPHIC(1), /* '' -> Search; 'F' -> FIFO; 'D', 'S', 'N' -> WIP */
DBGenerateLog			   VARGRAPHIC(1),
DBLastProcessInstanceId            VARGRAPHIC(63),
DBLastWorkitemId                   INTEGER
)

DYNAMIC RESULT SETS 3
LANGUAGE SQL
P1 : BEGIN
        DECLARE	v_userIndex			SMALLINT;
	DECLARE	v_userName			VARGRAPHIC(30);
	DECLARE v_dbStatus			INTEGER;
	DECLARE v_lockFlag			VARGRAPHIC(1);
	DECLARE	v_dbStatusStr			VARCHAR(2000);
	DECLARE	v_qdt_filterOption		INTEGER;
	DECLARE	v_orderBy			VARCHAR(100);
	DECLARE v_len				INTEGER         DEFAULT -1;
	DECLARE v_tempOrderStr                  VARCHAR(2000);
	DECLARE v_iFirstOrder                   INTEGER;
	DECLARE v_sortFieldStr			VARCHAR(2000);
	DECLARE v_iOrder                        INTEGER;
	DECLARE	v_orderByStr			VARCHAR(200);
	DECLARE v_queryFilterStr                VARCHAR(800);
	DECLARE v_ProcessInstanceId		VARGRAPHIC(63);
	DECLARE v_quoteChar                     CHAR(1);
	DECLARE v_workItemId                    INTEGER;
	DECLARE v_ProcessName 			VARGRAPHIC(30);
	DECLARE v_ProcessVersion  		SMALLINT;
	DECLARE v_ProcessDefID 			INTEGER;
	DECLARE v_LastProcessedBy 		INTEGER;
	DECLARE v_ProcessedBy			VARGRAPHIC(63);
	DECLARE v_ActivityName 			VARGRAPHIC(30);
	DECLARE v_ActivityId 			INTEGER;
	DECLARE v_EntryDateTime 		TIMESTAMP;
	DECLARE v_ParentWorkItemId		INTEGER;
	DECLARE v_AssignmentType		VARGRAPHIC(1);
	DECLARE v_CollectFlag			VARGRAPHIC(1);
	DECLARE v_PriorityLevel			SMALLINT;
	DECLARE v_ValidTill			TIMESTAMP;

	DECLARE v_Q_StreamId			INTEGER;
	DECLARE v_Q_QueueId			INTEGER;
	DECLARE v_Q_UserId			SMALLINT;
	DECLARE v_AssignedUser			VARGRAPHIC(63);
	DECLARE v_FilterValue			INTEGER;
	DECLARE v_CreatedDatetime		TIMESTAMP;
	DECLARE v_WorkItemState			INTEGER;
	DECLARE v_StateName 			VARGRAPHIC(255);
	DECLARE v_ExpectedWorkitemDelay		TIMESTAMP;
	DECLARE v_PreviousStage			VARGRAPHIC(30);
	DECLARE v_LockedByName			VARGRAPHIC(63);
	DECLARE v_LockStatus			VARGRAPHIC(1);
	DECLARE v_LockedTime			TIMESTAMP;
	DECLARE v_QueueName 			VARGRAPHIC(63);
	DECLARE v_QueueType 			VARGRAPHIC(1);
	DECLARE v_NotifyStatus			VARGRAPHIC(1);
	DECLARE v_found                         CHAR(1)         DEFAULT 'N';
	DECLARE v_canLock                       CHAR(1)         DEFAULT 'N';
	DECLARE v_queryStr                      VARCHAR(2000);
	DECLARE v_queryStr1                     VARCHAR(200);
	DECLARE v_queryStr2                     VARCHAR(2000);
	DECLARE v_rowCount                      INTEGER         DEFAULT 0;
	DECLARE v_toSearchStr                   VARGRAPHIC(20);
	DECLARE	v_QueryFilter	                VARGRAPHIC(1500);
	DECLARE v_counterInt                    INTEGER;
	DECLARE v_atEnd                         CHAR(1)         DEFAULT 'N';
	DECLARE v_tableStr			VARGRAPHIC(200);
	DECLARE v_orderByPos                    INTEGER;
	DECLARE v_tempFilter			VARGRAPHIC(2000);
	DECLARE SQLCODE                         INTEGER DEFAULT 0;
	DECLARE v_SQLCODE                         INTEGER DEFAULT 0;


        /* Statement Declarations */
	    DECLARE v_stmt                          STATEMENT;
    	DECLARE v_stmt1                         STATEMENT;
	
	/* Cursor Declarations */
	DECLARE v_returnCur		CURSOR WITH RETURN FOR
    	        SELECT v_DBStatus as DBStatus FROM SYSIBM.SYSDUMMY1;

       	DECLARE v_returnCurStr		CURSOR WITH RETURN FOR
    	        SELECT v_DBStatusStr as DBStatusStr FROM SYSIBM.SYSDUMMY1;

    	DECLARE v_lockFlagCur		CURSOR WITH RETURN TO CLIENT FOR
    	        SELECT v_lockFlag as LockFlag FROM SYSIBM.SYSDUMMY1;

    	DECLARE v_dynamicSQLCur         CURSOR WITH RETURN FOR v_stmt1;
    	
    	DECLARE v_Cur                   CURSOR FOR v_stmt;
	
	DECLARE v_ProcessInstCur        CURSOR WITH RETURN FOR v_stmt;

	DECLARE v_FilterCur             CURSOR WITH RETURN FOR v_stmt;
	
	SET v_quoteChar = CHR(39);
	SET v_workItemId = DBWorkItemId;
	SET v_processInstanceId = DBProcessInstanceId;
	SET v_lockFlag = N'N';
	
	-- check session validity
	SELECT userIndex,userName INTO v_userIndex,v_userName FROM WFSessionView, WFUserView
        WHERE UserId= UserIndex AND SessionId = DBSessionId;

	IF( SQLCODE = 100 )
	THEN
	    SET v_dbStatus = 11;   --Invalid Session Handle
            OPEN v_returnCur;
            RETURN 0;
    	END IF;

        -- Fetch queue filter
	IF(DBQueueId IS NOT NULL AND DBQueueId > 0) THEN
		SELECT	FilterOption, CHAR(OrderBy) INTO v_qdt_filterOption, v_orderBy
		FROM	QUEUEDEFTABLE
		WHERE	QueueID = DBQueueId ;
		
	END IF;
	
	IF(v_orderBy IS NOT NULL)
	THEN
	        SET v_len = LENGTH(RTRIM(v_orderBy));
	END IF;
	
	/*
		v_orderBy could be like this x0xx, where x is an integer
		This is done to provide an added functionality of sorting the FIFO Queue on
		the basis of 'PriorityLevel', and either on
		1. EntryDateTime,
			or
		2. ProcessInstanceId
	*/
	

	IF (DBQueueType = N'F' AND v_orderBy IS NOT NULL AND v_len > 0)
	THEN
	        IF (v_len > 3)
		THEN
			-- Extract first order by
			SET v_tempOrderStr = SUBSTR(v_orderBy,1,(v_len-3));
			SET v_iFirstOrder = INT(v_tempOrderStr);

			IF (v_iFirstOrder = 1)
			THEN
				SET v_sortFieldStr = ' PriorityLevel ';
				SET v_orderByStr = ' ORDER BY ' || v_sortFieldStr || ' DESC ';
			END IF;	
			
			-- Extract last three digits for second order By
			SET v_orderBy = SUBSTR(v_orderBy,LENGTH(v_tempOrderStr)+1,v_len-LENGTH(v_tempOrderStr));
		END IF;
                SET v_iOrder = INT(v_orderBy);
		
		IF (v_iOrder = 2)
		THEN
			SET v_sortFieldStr = ' ProcessInstanceId ';
	        ELSEIF (v_iOrder = 10)
        	THEN
	        	SET v_sortFieldStr = ' EntryDateTime ';
        	ELSE
	        	SET v_sortFieldStr = ' ProcessInstanceId ';
        	END IF;
				
	        IF (v_orderByStr IS NOT NULL)
	        THEN
		        SET v_orderByStr = v_orderByStr || ' , ' || v_sortFieldStr || ' ASC ';
        	ELSE
	        	SET v_orderByStr = ' ORDER BY ' || v_sortFieldStr || ' ASC ';
        	END IF;
        	
	END IF;
	
	--Append condition for queue filter
	SET v_queryFilterStr = ' WHERE ';
	IF(v_qdt_filterOption IS NOT NULL AND v_qdt_filterOption > 0)
	THEN
		IF(v_qdt_filterOption = 2)
		THEN
			SET v_queryFilterStr = v_queryFilterStr || ' FilterValue = ' ||
			CHAR(v_userIndex) || ' AND ' ;
		ELSEIF(v_qdt_filterOption = 3)
		THEN
			SET v_queryFilterStr = v_queryFilterStr || ' FilterValue != ' ||
			CHAR(v_userIndex) || ' AND ' ;
		END IF;
        END IF;

	IF(v_ProcessInstanceId IS NULL OR v_ProcessInstanceId = '')
	THEN
		SET v_queryFilterStr = v_queryFilterStr || ' Q_QueueId = '|| CHAR(DBQueueId) ||
						' AND (WorkitemState < 3 OR WorkitemState < 6)';
	ELSE
		SET v_queryFilterStr = v_queryFilterStr || ' ProcessInstanceId = ' ||
					v_quoteChar || UPPER(LTRIM(RTRIM(v_ProcessInstanceId))) ||
							v_quoteChar || ' AND WorkitemId = ' || CHAR(v_WorkitemId) ;
        END IF;
	
	-- Filter on last value if given in input, pre fetch case for thick client
	IF( DBLastProcessInstanceId IS NOT NULL AND LENGTH(DBLastProcessInstanceId) > 0 )
	THEN
		SET v_queryFilterStr = v_queryFilterStr || ' AND NOT ( UPPER(LTRIM(RTRIM(processInstanceId))) =  ' ||
						v_quoteChar || UPPER(LTRIM(RTRIM(DBLastProcessInstanceId))) ||
						v_quoteChar || ' AND workitemId = ' || CHAR(DBLastWorkitemId) || ' ) ';
	END IF;
	
        IF((v_ProcessInstanceId IS NOT NULL AND LENGTH(v_ProcessInstanceId) > 0 AND (DBQueueType != N'F' OR DBQueueType = '' OR DBQueueType IS NULL))
	                       OR
          ((v_ProcessInstanceId IS NULL OR v_ProcessInstanceId = '') AND DBQueueType = N'F'))
	  THEN
	        SET v_queryStr = 'SELECT * FROM ( Select ProcessInstanceId, WorkItemId, ProcessName, ProcessVersion, ' ||
				' ProcessDefID, LastProcessedBy, ProcessedBy, ActivityName,' ||
				' ActivityId, EntryDateTime, ParentWorkItemId, AssignmentType,' ||
				' CollectFlag, PriorityLevel, ValidTill, Q_StreamId,' ||
				' Q_QueueId, Q_UserId, AssignedUser, FilterValue,' ||
				' CreatedDateTime, WorkItemState, Statename, ExpectedWorkitemDelay, ' ||
				' PreviousStage, LockedByName, LockStatus, LockedTime, ' ||
				' Queuename, Queuetype, NotifyStatus From WorkListTable ';
				
		IF ( v_queryFilterStr = ' WHERE ')
		THEN
		        IF (v_orderByStr IS NULL)
		        THEN
        		        SET v_queryStr = v_queryStr || '  )as a FETCH FIRST 1 ROW ONLY';
        		ELSE
                                SET v_queryStr = v_queryStr || v_orderByStr || '  )as a FETCH FIRST 1 ROW ONLY';      		
                        END IF;
		ELSE
		        IF (v_orderByStr IS NULL)
		        THEN
        		        SET v_queryStr = v_queryStr || v_queryFilterStr || '  )as a FETCH FIRST 1 ROW ONLY';
        		ELSE
        		
                                SET v_queryStr = v_queryStr || v_queryFilterStr || v_orderByStr || '  )as a FETCH FIRST 1 ROW ONLY';        		
                        END IF;

                END IF;

               	PREPARE v_stmt from v_queryStr;
		OPEN v_Cur;
	               FETCH v_Cur INTO v_processInstanceId,v_workItemId,v_processName,v_processVersion,v_processDefID,v_lastProcessedBy,v_processedBy,v_activityName,v_activityID,v_entryDateTime,v_parentWorkItemId, v_assignmentType,v_collectFlag,v_priorityLevel, v_validTill, v_Q_StreamId,v_Q_QueueId,v_Q_UserId,v_AssignedUser,v_FilterValue,v_createdDateTime, v_workItemState, v_statename, v_expectedWorkitemDelay,v_previousStage,v_lockedByName,v_lockStatus,v_lockedTime,v_queueName,v_queueType,v_notifyStatus;
        	IF (SQLCODE = 0 )
		THEN
		        SET v_found = 'Y';
		        SET v_canLock = 'Y';
		END IF;
		CLOSE v_Cur;   	
		
		SET v_dbstatusstr = v_queryStr;
                open v_returnCurStr;
                return;

		
        END IF;

        IF(v_found = 'Y')
	THEN
		-- AssignmentType can be null
		IF(v_AssignmentType IS NULL OR v_AssignmentType = ''
		        OR
		NOT (v_AssignmentType = 'F' OR v_AssignmentType = 'E' OR v_AssignmentType = 'A'))
		THEN
			IF(DBQueueId < 0)
			THEN
				SELECT QUEUEDEFTABLE.FilterOption INTO v_qdt_filterOption
				FROM	QUEUEDEFTABLE, QUserGroupView
				WHERE	QUEUEDEFTABLE.QueueID = QUserGroupView.QueueID
				AND	QUEUEDEFTABLE.QueueID = v_Q_QueueId
				AND	UserId = v_userIndex
				FETCH FIRST 1 ROW ONLY;
			END IF;
			SET v_SQLCODE = SQLCODE;
			IF(v_SQLCODE = 0)
			THEN
			        SET v_rowCount = 1;
			END IF;
			IF(v_rowCount > 0)
			THEN
				IF(NOT(v_qdt_FilterOption = 2 AND v_FilterValue = v_userIndex) OR (v_qdt_FilterOption = 3 AND v_FilterValue != v_userIndex) OR  (v_qdt_FilterOption = 1) )
				THEN
					SET v_canLock = 'N';
				END IF;
                        ELSE
			        SET v_canLock = 'N';
			END IF;
		ELSE
		        -- So that WI is not available to any user in a dynamic queue after one user has performed done operation
			IF (DBQueueId != v_Q_QueueId)
			THEN
                        	-- Workitem not in the queue specified.
			        SET v_dbStatus = 810;
                        	OPEN v_returnCur;
                        	RETURN;
			END IF;
		END IF;
		
		-- Support for Query Filter
		-- check filter
		IF (v_Queuetype = N'F' OR v_Queuetype = N'N')
		THEN
			SET v_toSearchStr =N'ORDER BY';
			SELECT QueryFilter INTO v_QueryFilter
		        FROM Qusergroupview
			WHERE GroupId IS NULL
			AND userId = v_userIndex
			AND QueueId = v_Q_QueueId;
			
			SET v_SQLCODE = SQLCODE;
			IF (v_SQLCODE = 0)
			THEN
			        --Only user specific filter exists and no group filter considered.
			  	SET v_QueryFilter =  VARGRAPHIC(LTRIM(RTRIM(REPLACE(v_QueryFilter ,N'&<UserIndex>&',VARGRAPHIC(CHAR(v_userIndex)||'')))));
		                			
				IF (v_QueryFilter != '''' OR  v_QueryFilter IS NOT NULL )
				THEN
					SET v_orderByPos = POSSTR(UPPER(LTRIM(RTRIM(v_QueryFilter))),v_toSearchStr);
					IF (v_orderByPos > 0)
					THEN
						SET v_QueryFilter = SUBSTR(v_QueryFilter,1,v_orderByPos - 1);
				        END IF;
				END IF;
			ELSEIF (v_SQLCODE = 100)  -- SQLCODE 100 <> indicates some rows  were retrieved,
                        THEN			
						-- group filter present
				SET v_queryStr =  ' Select QueryFilter ' ||
	        	                          ' From Qusergroupview ' ||
                        			  ' Where GroupId IS NOT NULL ' ||
		                		  ' AND QueueId  = ' || CHAR(v_Q_QueueId) ||
					          ' AND UserId = ' || CHAR(v_userIndex);
	
			        BEGIN
                                        DECLARE CONTINUE HANDLER FOR NOT FOUND
                                        BEGIN
                                                SET v_atEnd = 'Y';
                                        END;
                                        SET v_atEnd='N';
                                        PREPARE v_stmt from v_queryStr;
                                        OPEN v_FilterCur;
		                        FETCH FROM v_FilterCur INTO v_QueryFilter;
                                	SET v_counterInt = 1;
                        	        WHILE(v_atEnd  <> 'Y')
                                	DO
	        			        SET v_QueryFilter =  VARGRAPHIC(LTRIM(RTRIM(REPLACE(v_QueryFilter ,N'&<UserIndex>&',CHAR(v_userIndex)||''))));
        	        			IF (v_QueryFilter != '''' OR v_QueryFilter IS NOT NULL)
        	        			THEN
        		        			SET v_orderByPos = POSSTR(UPPER(LTRIM(RTRIM(v_QueryFilter))),v_toSearchStr);
	        		        	        IF (v_orderByPos > 0)
	        		        	        THEN					
		        		        		SET v_QueryFilter = SUBSTR(v_QueryFilter,1,v_orderByPos - 1);
			        		        END IF;
					                IF (v_counterInt = 1)
					                THEN
						                SET v_tempFilter =  v_QueryFilter;
        					        ELSE
	        					        SET v_tempFilter  = v_tempFilter || ' OR ' || v_QueryFilter;
        					        END IF;	
                					SET v_counterInt = v_counterInt + 1;
				                END IF;
                                                FETCH v_FilterCur INTO v_QueryFilter;
		                        END WHILE;
	                                CLOSE v_FilterCur;
        	                END;
        	                SET v_QueryFilter = v_tempFilter;
		        END IF;
			
		        IF(v_QueryFilter != '''' OR v_QueryFilter IS NOT NULL)
		        THEN
				SET v_tableStr = N'';
				IF (v_Queuetype = 'F')
				THEN
					SET v_tableStr = N' QueueDataTable ';
				ELSEIF (v_Queuetype = 'N')
				THEN
					SET v_tableStr = N' WFWorklistView_' || VARGRAPHIC(CHAR(v_Q_QueueId));
				END IF;
				SET v_queryStr = VARCHAR(' SELECT ProcessInstanceId FROM ' ||
						v_tableStr ||
						' WHERE ProcessInstanceId = ''' || v_ProcessInstanceId ||
						''' AND WorkItemId = ' || CHAR(v_WorkitemId) ||
						  ' AND (' || v_QueryFilter || ')');
				
				BEGIN
                                        DECLARE CONTINUE HANDLER FOR NOT FOUND
                                        BEGIN
                                                SET v_atEnd = 'Y';
                                        END;
                                        SET v_atEnd='N';
                                        PREPARE v_stmt from v_queryStr;
                                                OPEN v_ProcessInstCur;
                                		FETCH v_ProcessInstCur INTO v_ProcessInstanceId;
  					
						IF (v_atEnd <> 'Y')
						THEN
						        SET v_canLock = 'Y';
						ELSE
						       SET v_canLock = 'N';					
						END IF;
                                        	CLOSE v_ProcessInstCur;
				END;
			END IF;
	        ELSEIF (v_userIndex = v_Q_UserId  OR v_Q_UserId IS NULL OR v_Q_UserId = 0)
	        THEN
			SET v_canLock = 'Y';
		ELSE
			SET v_canLock = 'N';
	        END IF;
		
		IF(v_canLock = 'Y')
		THEN
		        SAVEPOINT LockWI ON ROLLBACK RETAIN CURSORS;
			IF(v_AssignmentType IS NULL)
			THEN
				SET v_AssignmentType = N'S';
			END IF;
			SET v_Q_UserId = v_userIndex;
			SET v_AssignedUser = v_userName;
			SET v_WorkItemState = 2;
			SET v_StateName = N'RUNNING';
			SET v_LockedByName = v_userName;
			SET v_LockStatus = N'Y';
			SET v_LockedTime = CURRENT TIMESTAMP;
			
			Insert into WorkInProcessTable(
			ProcessInstanceId, WorkItemId, ProcessName, ProcessVersion,
			ProcessDefID, LastProcessedBy, ProcessedBy, ActivityName,
			ActivityId, EntryDateTime, ParentWorkItemId, AssignmentType,
			CollectFlag, PriorityLevel, ValidTill, Q_StreamId,
			Q_QueueId, Q_UserId, AssignedUser, FilterValue,
			CreatedDateTime, WorkItemState, Statename, ExpectedWorkitemDelay,
			PreviousStage, LockedByName, LockStatus, LockedTime,
			Queuename, Queuetype, NotifyStatus, Guid
			)
			SELECT	ProcessInstanceId, WorkItemId, ProcessName, ProcessVersion,
			ProcessDefID, LastProcessedBy, ProcessedBy, ActivityName,
			ActivityId, EntryDateTime, ParentWorkItemId, v_AssignmentType,
			CollectFlag, PriorityLevel, ValidTill, Q_StreamId,
			Q_QueueId, v_Q_Userid, v_AssignedUser, FilterValue,
			CreatedDateTime, v_WorkItemState, v_StateName, ExpectedWorkitemDelay,
			PreviousStage, v_LockedByName, v_LockStatus, v_LockedTime,
			Queuename, Queuetype, NotifyStatus,CAST(NULL as BIGINT)
			FROM	WORKLISTTABLE
			WHERE	UPPER(LTRIM(RTRIM(ProcessInstanceID))) = UPPER(LTRIM(RTRIM(v_ProcessInstanceId)))
			AND	WorkItemID = v_WorkitemId;
          		
			IF (SQLCODE = 0)
			THEN
				DELETE	FROM WORKLISTTABLE
				WHERE	UPPER(LTRIM(RTRIM(ProcessInstanceID))) = UPPER(LTRIM(RTRIM(v_ProcessInstanceId)))
				AND	WorkItemID = v_WorkitemId;
			        COMMIT;
				SET v_lockFlag = N'Y';
			        OPEN v_lockFlagCur;
			ELSE
				ROLLBACK TO SAVEPOINT LockWI;
				COMMIT;
				SET v_dbStatus = 6;		-- Invalid workitem when workitem processed by some other user
				OPEN v_returnCur;
				RETURN;
			END IF;
	
		        IF(v_lockFlag = N'Y' AND DBGenerateLog = N'Y')
		        THEN
        		BEGIN
		        /* Logging for Locking workitem */
					/* Changed By Varun Bhansaly 0n 16/02/2007 for Bugzilla Bug 74 */
				    INSERT INTO WFMESSAGETABLE(messageId, message, status, ActionDateTime)
        			VALUES	(default , '<Message><ActionId>7</ActionId><UserId>' || CHAR(v_userIndex) ||
					'</UserId><ProcessDefId>' || VARCHAR(CHAR(v_ProcessDefId)) ||
					'</ProcessDefId><ActivityId>' || VARCHAR(CHAR(v_ActivityId)) ||
					'</ActivityId><QueueId>0</QueueId><UserName>' || VARCHAR(v_userName) ||
					'</UserName><ActivityName>' || VARCHAR(v_ActivityName) ||
					'</ActivityName><TotalWiCount>0</TotalWiCount><TotalDuration>0</TotalDuration><ActionDateTime>' ||
					VARCHAR_FORMAT(CURRENT TIMESTAMP,'YYYY-MM-DD HH24:MI:SS') || '</ActionDateTime><EngineName></EngineName><ProcessInstance>' ||
					VARCHAR(v_ProcessInstanceId) || '</ProcessInstance><FiledId>' || VARCHAR(CHAR(v_Q_QueueId)) ||
					'</FiledId><FieldName>' || VARCHAR(v_Queuename) || '</FieldName><WorkitemId>' || VARCHAR(CHAR(v_WorkitemId)) ||
					'</WorkitemId><TotalPrTime>0</TotalPrTime>' ||
					'<DelayTime>0</DelayTime><WKInDelay>0</WKInDelay><ReportType>D</ReportType><Flag>0</Flag></Message>',
			        	N'N', CURRENT TIMESTAMP);
			/* Logging for work started */
					/* Changed By Varun Bhansaly 0n 16/02/2007 for Bugzilla Bug 74 */
        			INSERT INTO WFMESSAGETABLE(messageId, message, status, ActionDateTime)
	        		VALUES	( default , '<Message><ActionId>200</ActionId><UserId>' || CHAR(v_userIndex) ||
					'</UserId><ProcessDefId>' || VARCHAR(CHAR(v_ProcessDefId)) ||
					'</ProcessDefId><ActivityId>0</ActivityId><QueueId>' ||
					VARCHAR(CHAR(v_Q_QueueId)) ||	'</QueueId><UserName>' || VARCHAR(v_userName) ||
					'</UserName><ActivityName>' || VARCHAR(v_ActivityName) ||
					'</ActivityName><TotalWiCount>0</TotalWiCount><TotalDuration>0</TotalDuration><ActionDateTime>' ||
					VARCHAR_FORMAT(CURRENT TIMESTAMP,'YYYY-MM-DD HH24:MI:SS') || '</ActionDateTime><EngineName></EngineName><ProcessInstance>' ||
					VARCHAR(v_ProcessInstanceId) || '</ProcessInstance><FiledId></FiledId><WorkitemId>' ||
					VARCHAR(CHAR(v_WorkitemId)) || '</WorkitemId><TotalPrTime>0</TotalPrTime>' ||
					'<DelayTime>0</DelayTime><WKInDelay>0</WKInDelay><ReportType>D</ReportType><Flag>0</Flag></Message>',
		        		N'N', CURRENT TIMESTAMP);
		        END;
        		END IF;
	        ELSE
	                SET v_dbStatus = 300;	-- no authorization
	                OPEN v_returnCur;
			RETURN;
        	END IF;
	ELSE
		IF(v_processInstanceId IS NOT NULL AND LENGTH(v_processInstanceId) > 0)
		THEN
		        SELECT	ProcessInstanceId, WorkItemId, ProcessName, ProcessVersion, ProcessDefID,
				LastProcessedBy, ProcessedBy, ActivityName, ActivityId, EntryDateTime,
				ParentWorkItemId, AssignmentType, CollectFlag, PriorityLevel, ValidTill,
				Q_StreamId, Q_QueueId, Q_UserId, AssignedUser, FilterValue, CreatedDateTime,
				WorkItemState, Statename, ExpectedWorkitemDelay, PreviousStage, LockedByName,
				LockStatus, LockedTime, Queuename, Queuetype, NotifyStatus
			INTO
				v_ProcessInstanceId, v_WorkItemId, v_ProcessName, v_ProcessVersion,
				v_ProcessDefID, v_LastProcessedBy, v_ProcessedBy, v_ActivityName,
				v_ActivityId, v_EntryDateTime, v_ParentWorkItemId, v_AssignmentType,
				v_CollectFlag, v_PriorityLevel, v_ValidTill, v_Q_StreamId, v_Q_QueueId,
				v_Q_UserId, v_AssignedUser, v_FilterValue, v_CreatedDateTime, v_WorkItemState,
				v_Statename, v_ExpectedWorkitemDelay, v_PreviousStage, v_LockedByName,
				v_LockStatus, v_LockedTime, v_Queuename, v_Queuetype, v_NotifyStatus
			FROM	WORKINPROCESSTABLE
			WHERE	UPPER(LTRIM(RTRIM(ProcessInstanceID))) = UPPER(LTRIM(RTRIM(v_ProcessInstanceId)))
			AND	WorkItemID = v_WorkitemId;
			
		ELSE	-- For FIFO when workitem not in WorkListTable and some workitem is locked in WorkInProcessTable
			SELECT	ProcessInstanceId, WorkItemId, ProcessName, ProcessVersion, ProcessDefID,
				LastProcessedBy, ProcessedBy, ActivityName, ActivityId, EntryDateTime,
				ParentWorkItemId, AssignmentType, CollectFlag, PriorityLevel, ValidTill,
				Q_StreamId, Q_QueueId, Q_UserId, AssignedUser, FilterValue, CreatedDateTime,
				WorkItemState, Statename, ExpectedWorkitemDelay, PreviousStage, LockedByName,
				LockStatus, LockedTime, Queuename, Queuetype, NotifyStatus
			INTO
				v_ProcessInstanceId, v_WorkItemId, v_ProcessName, v_ProcessVersion,
				v_ProcessDefID, v_LastProcessedBy, v_ProcessedBy, v_ActivityName,
				v_ActivityId, v_EntryDateTime, v_ParentWorkItemId, v_AssignmentType,
				v_CollectFlag, v_PriorityLevel, v_ValidTill, v_Q_StreamId, v_Q_QueueId,
				v_Q_UserId, v_AssignedUser, v_FilterValue, v_CreatedDateTime, v_WorkItemState,
				v_Statename, v_ExpectedWorkitemDelay, v_PreviousStage, v_LockedByName,
				v_LockStatus, v_LockedTime, v_Queuename, v_Queuetype, v_NotifyStatus
			FROM	WORKINPROCESSTABLE
			WHERE	UPPER(LTRIM(RTRIM(LockedByName))) = UPPER(LTRIM(RTRIM(v_userName)))
			AND	Q_QueueId = DBQueueId
			AND	NOT ( UPPER(LTRIM(RTRIM(processInstanceId))) = UPPER(LTRIM(RTRIM(DBLastProcessInstanceId)))
			AND	workitemId = DBLastWorkitemId )
			FETCH FIRST 1 ROW ONLY;
			
			IF(SQLCODE = 100)
			THEN
			        SET v_rowCount = -1;
			ELSE
			        SET v_rowCount = 1;
			END IF;
		END IF;

                IF(NOT (v_LockedByName = v_userName))
                THEN
			SET v_dbStatus = 16;		 --Workitem locked, when workitem locked by some other user
			OPEN v_returnCur;
			RETURN;
		END IF;

		IF(v_rowCount < 1)
		THEN
			IF(v_processInstanceId IS NOT NULL AND LENGTH(v_processInstanceId) > 0)
			THEN
		        	SET v_dbStatus = 300;		-- NO Authorization
				OPEN v_returnCur;
			        SELECT	ProcessInstanceId, WorkItemId, ProcessName, ProcessVersion, ProcessDefID,
					LastProcessedBy, ProcessedBy, ActivityName, ActivityId, EntryDateTime,
					ParentWorkItemId, AssignmentType, CollectFlag, PriorityLevel, ValidTill,
					Q_StreamId, Q_QueueId, Q_UserId, AssignedUser, CAST(NULL AS INTEGER), CreatedDateTime,
					WorkItemState, Statename, CAST(NULL AS TIMESTAMP), PreviousStage, LockedByName,
					LockStatus, LockedTime, Queuename, Queuetype, CAST(NULL AS VARGRAPHIC(1))
				INTO
					v_ProcessInstanceId, v_WorkItemId, v_ProcessName, v_ProcessVersion,
					v_ProcessDefID, v_LastProcessedBy, v_ProcessedBy, v_ActivityName,
					v_ActivityId, v_EntryDateTime, v_ParentWorkItemId, v_AssignmentType,
					v_CollectFlag, v_PriorityLevel, v_ValidTill, v_Q_StreamId, v_Q_QueueId,
					v_Q_UserId, v_AssignedUser, v_FilterValue, v_CreatedDateTime,
					v_WorkItemState, v_Statename, v_ExpectedWorkitemDelay, v_PreviousStage,
					v_LockedByName, v_LockStatus, v_LockedTime, v_Queuename, v_Queuetype,
					v_NotifyStatus
				FROM	QUEUEHISTORYTABLE
				WHERE	UPPER(LTRIM(RTRIM(ProcessInstanceID))) = UPPER(LTRIM(RTRIM(v_ProcessInstanceId)))
				AND	WorkItemID = v_WorkitemId;
				
			        SET v_SQLCODE = SQLCODE;
				IF(v_SQLCODE = 100)
				THEN	
				        SET v_rowCount = -1;
				ELSE
				        SET v_rowCount = 1;
				END IF;
				
				IF(v_rowCount < 1)
				THEN
					SELECT	ProcessInstanceId, WorkItemId, ProcessName, ProcessVersion, ProcessDefID,
						LastProcessedBy, ProcessedBy, ActivityName, ActivityId, EntryDateTime,
						ParentWorkItemId, AssignmentType, CollectFlag, PriorityLevel, ValidTill,
						Q_StreamId, Q_QueueId, Q_UserId, AssignedUser, FilterValue, CreatedDateTime,
						WorkItemState, Statename, ExpectedWorkitemDelay, PreviousStage, LockedByName,
						LockStatus, LockedTime, Queuename, Queuetype, NotifyStatus
					INTO
						v_ProcessInstanceId, v_WorkItemId, v_ProcessName, v_ProcessVersion,
						v_ProcessDefID, v_LastProcessedBy, v_ProcessedBy, v_ActivityName,
						v_ActivityId, v_EntryDateTime, v_ParentWorkItemId, v_AssignmentType,
						v_CollectFlag, v_PriorityLevel, v_ValidTill, v_Q_StreamId, v_Q_QueueId,
						v_Q_UserId, v_AssignedUser, v_FilterValue, v_CreatedDateTime, v_WorkItemState,
						v_Statename, v_ExpectedWorkitemDelay, v_PreviousStage, v_LockedByName,
						v_LockStatus, v_LockedTime, v_Queuename, v_Queuetype, v_NotifyStatus
					FROM	PENDINGWORKLISTTABLE
					WHERE	UPPER(LTRIM(RTRIM(ProcessInstanceID))) = UPPER(LTRIM(RTRIM(v_ProcessInstanceId)))
					AND	WorkItemID = v_WorkitemId;
				
					SET v_SQLCODE = SQLCODE;
					IF (v_SQLCODE = 100)
					THEN
					        SET v_rowCount = -1;
					ELSE
       					        SET v_rowCount = 1;
       					END IF;
					
       					IF(v_rowCount < 1)
       					THEN
					        SELECT	ProcessInstanceId, WorkItemId, ProcessName, ProcessVersion, ProcessDefID,
							LastProcessedBy, ProcessedBy, ActivityName, ActivityId, EntryDateTime,
							ParentWorkItemId, AssignmentType, CollectFlag, PriorityLevel, ValidTill,
							Q_StreamId, Q_QueueId, Q_UserId, AssignedUser, FilterValue, CreatedDateTime,
							WorkItemState, Statename, ExpectedWorkitemDelay, PreviousStage, LockedByName,
							LockStatus, LockedTime, Queuename, Queuetype, NotifyStatus
						INTO
							v_ProcessInstanceId, v_WorkItemId, v_ProcessName, v_ProcessVersion,
							v_ProcessDefID, v_LastProcessedBy, v_ProcessedBy, v_ActivityName,
							v_ActivityId, v_EntryDateTime, v_ParentWorkItemId, v_AssignmentType,
							v_CollectFlag, v_PriorityLevel, v_ValidTill, v_Q_StreamId, v_Q_QueueId,
							v_Q_UserId, v_AssignedUser, v_FilterValue, v_CreatedDateTime, v_WorkItemState,
							v_Statename, v_ExpectedWorkitemDelay, v_PreviousStage, v_LockedByName,
							v_LockStatus, v_LockedTime, v_Queuename, v_Queuetype, v_NotifyStatus
						FROM	WORKDONETABLE
						WHERE	UPPER(LTRIM(RTRIM(ProcessInstanceID))) = UPPER(LTRIM(RTRIM(v_ProcessInstanceId)))
							AND	WorkItemID = v_WorkitemId;
						IF (SQLCODE = 100)
						THEN
						       SET v_rowCount = -1;
        					ELSE
       	        				       SET v_rowCount = 1;
       		        			END IF;

						IF(v_rowCount < 1)
						THEN
							SELECT	ProcessInstanceId, WorkItemId, ProcessName, ProcessVersion, ProcessDefID,
						        	LastProcessedBy, ProcessedBy, ActivityName, ActivityId, EntryDateTime,
								ParentWorkItemId, AssignmentType, CollectFlag, PriorityLevel, ValidTill,
								Q_StreamId, Q_QueueId, Q_UserId, AssignedUser, FilterValue, CreatedDateTime,
								WorkItemState, Statename, ExpectedWorkitemDelay, PreviousStage, LockedByName,
								LockStatus, LockedTime, Queuename, Queuetype, NotifyStatus
							INTO
								v_ProcessInstanceId, v_WorkItemId, v_ProcessName, v_ProcessVersion,
								v_ProcessDefID, v_LastProcessedBy, v_ProcessedBy, v_ActivityName,
								v_ActivityId, v_EntryDateTime, v_ParentWorkItemId, v_AssignmentType,
								v_CollectFlag, v_PriorityLevel, v_ValidTill, v_Q_StreamId, v_Q_QueueId,
								v_Q_UserId, v_AssignedUser, v_FilterValue, v_CreatedDateTime, v_WorkItemState,
								v_Statename, v_ExpectedWorkitemDelay, v_PreviousStage, v_LockedByName,
								v_LockStatus, v_LockedTime, v_Queuename, v_Queuetype, v_NotifyStatus
							FROM	WORKWITHPSTABLE
							WHERE	UPPER(LTRIM(RTRIM(ProcessInstanceID))) = UPPER(LTRIM(RTRIM(v_ProcessInstanceId)))
							AND	WorkItemID = v_WorkitemId;
						ELSEIF(DBQueueId >= 0)
						THEN
							SET v_dbStatus = 810; -- Workitem not in the queue specified.
							OPEN v_returnCur;
							RETURN;
						ELSE
							SET v_dbStatus = 825; -- Fatal error no such workitem exists.
							OPEN v_returnCur;
							RETURN;
						END IF;
					END IF;
                                END IF;
                        END IF;		
		ELSE
			SET v_dbStatus = 18;			-- NO more data for FIFO when only queueId is given
			OPEN v_returnCur;
			RETURN;
		END IF;
		    -- Else workitem found in WorkInProcessTable
	END IF;
	
	IF (POSSTR(v_Queuename,v_quoteChar) >0 )
	THEN
		SET v_Queuename = VARGRAPHIC(REPLACE(v_Queuename,v_quoteChar,VARGRAPHIC('''''')));
	END IF;
	
	SET v_queryStr =  ' SELECT '  || VARCHAR(CHAR(v_userIndex)) || ' UserIndex, ' ||
	                  v_quoteChar || VARCHAR_FORMAT(CURRENT TIMESTAMP,'YYYY-MM-DD HH24:MI:SS') || v_quoteChar ||
	                  ' CurrentDateTime, ' || v_quoteChar ||VARCHAR(v_ProcessInstanceId) || v_quoteChar ||
	                  ' ProcessInstanceId, ' ||	
	                  LTRIM(RTRIM(VARCHAR(CHAR(v_WorkItemId)))) || ' WorkItemId, ' || v_quoteChar ||
	                  LTRIM(RTRIM(VARCHAR(COALESCE(v_ProcessName,N'')))) || v_quoteChar ||   ' ProcessName, ' ||
	                  LTRIM(RTRIM(VARCHAR(CHAR(COALESCE(v_ProcessVersion,0))))) ||' ProcessVersion, ' ||
	                  LTRIM(RTRIM(VARCHAR(CHAR(v_ProcessDefID)))) || ' ProcessDefID, ' ||
	                  v_quoteChar || LTRIM(RTRIM(VARCHAR(v_ProcessedBy))) || v_quoteChar ||  ' ProcessedBy, ' ||
	                  v_quoteChar || LTRIM(RTRIM(VARCHAR(v_ActivityName))) || v_quoteChar || ' ActivityName, ' ||
	                  LTRIM(RTRIM(VARCHAR(CHAR(COALESCE(v_ActivityId,0))))) ||' ActivityId, '||
	                  v_quoteChar || VARCHAR_FORMAT(v_EntryDateTime,'YYYY-MM-DD HH24:MI:SS') || v_quoteChar ||
			  ' EntryDateTime, ' || v_quoteChar || LTRIM(RTRIM(VARCHAR(v_AssignmentType))) || v_quoteChar ||
			  ' AssignmentType, ' || LTRIM(RTRIM(VARCHAR(CHAR(COALESCE(v_PriorityLevel,0))))) || ' PriorityLevel, ';
			
	SET v_queryStr2 = ' ValidTill, ' ||LTRIM(RTRIM(VARCHAR(CHAR(COALESCE(v_Q_QueueId,0))))) || ' Q_QueueId, ' ||
        		  LTRIM(RTRIM(VARCHAR(CHAR(COALESCE(v_Q_UserId,0))))) ||' Q_UserId, ' || v_quoteChar || LTRIM(RTRIM(VARCHAR(v_AssignedUser))) ||
        		  v_quoteChar ||' AssignedUser, ' || v_quoteChar || VARCHAR_FORMAT(v_CreatedDateTime,'YYYY-MM-DD HH24:MI:SS') ||
	        	  v_quoteChar ||' CreatedDateTime, ' || LTRIM(RTRIM(VARCHAR(CHAR(COALESCE(v_WorkItemState,0))))) || ' WorkItemState, ' ||
			  v_quoteChar || LTRIM(RTRIM(VARCHAR(v_Statename))) || v_quoteChar || ' Statename, ' ||
        		  v_quoteChar || VARCHAR_FORMAT(v_ExpectedWorkitemDelay,'YYYY-MM-DD HH24:MI:SS') || v_quoteChar ||
	        	  ' ExpectedWorkitemDelay, ' || v_quoteChar || LTRIM(RTRIM(VARCHAR(v_PreviousStage))) || v_quoteChar ||
		          ' PreviousStage, ' || v_quoteChar || LTRIM(RTRIM(VARCHAR(v_LockedByName))) || v_quoteChar || ' LockedByName, ' ||
			  v_quoteChar || LTRIM(RTRIM(VARCHAR(v_LockStatus))) || v_quoteChar|| ' LockStatus, ' ||	
        		  v_quoteChar || VARCHAR_FORMAT(v_LockedTime,'YYYY-MM-DD HH24:MI:SS') || v_quoteChar || ' LockedTime, ' ||
	        	  v_quoteChar || LTRIM(RTRIM(VARCHAR(v_Queuename))) || v_quoteChar || ' Queuename,  '
		          ||v_quoteChar || LTRIM(RTRIM(VARCHAR(v_Queuetype))) || v_quoteChar ||
			  ' Queuetype FROM SYSIBM.SYSDUMMY1';
	
        IF (v_validTill IS NULL)
        THEN
                SET v_queryStr = v_queryStr || ' CAST(NULL AS TIMESTAMP) '|| v_queryStr2;
	ELSE
                SET v_queryStr = v_queryStr || v_quoteChar || VARCHAR_FORMAT(v_ValidTill,'YYYY-MM-DD HH24:MI:SS') || v_quoteChar || v_queryStr2;
	END IF;
        PREPARE v_stmt1 FROM v_queryStr;
	OPEN v_dynamicSQLCur;
END P1 