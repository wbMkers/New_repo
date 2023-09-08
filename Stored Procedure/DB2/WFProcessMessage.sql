/*__________________________________________________________________________________________________________________-
			NEWGEN SOFTWARE TECHNOLOGIES LIMITED
____________________________________________________________________________________________________________________-
	Group				: Application – Products
	Product / Project		: WorkFlow 7.0
	Module				: Transaction Server
	File Name			: WFProcessMessage.sql
	Author				: Ashish Mangla
	Date written (DD/MM/YYYY)	: 10/07/2006
	Description			: This stored procedure is called from WFProcessMessage (WFInternal.java).

______________________________________________________________________________________________________________________-
				CHANGE HISTORY
______________________________________________________________________________________________________________________-

Date			Change By		Change Description (Bug No. (If Any))
07/02/2007		Ruhi Hira		Bugzilla Id 460.
08/02/2007	    Varun Bhansaly	Bugzilla Id 74 (Inconsistency in date-time)
______________________________________________________________________________________________________________________-
______________________________________________________________________________________________________________________*/
CREATE PROCEDURE WFProcessMessage (
	DBActionId			INT,
	DBUserId			INT,
	DBProcessDefId			INT,
	DBActivityId			INT,
	DBQueueId			INT,
	DBUserName			VARGRAPHIC(63),
	DBActivityName			VARGRAPHIC(30),
	DBTotalWiCount			INT,
	DBTotalDuration			INT,
	DBEngineName			VARGRAPHIC(255),
	DBProcessInstance		VARGRAPHIC(63),
	DBFieldId			INT,
	DBFlag				INT,
	DBWorkitemId			INT,
	DBTotalPrTime			INT,
	DBFieldName			VARGRAPHIC(255),
	DBActionDateTime		VARGRAPHIC(20),
	DBDelayTime			INT,
	DBWKInDelay			INT,
	DBReportType			VARGRAPHIC(1),
	msgId				INT,
	UtilId				VARCHAR(63),
	v_mode 				INT,			/* 1 in case of getNextLocked, 2 in case of process	*/
	messageCount			INT,			/* used in case no message locked	*/
	deleteFlag			INT				/* 1 record to be deleted from wfmessageTable , 2 not to be deleted	*/
)
DYNAMIC RESULT SETS 1
LANGUAGE SQL
BEGIN
	DECLARE ret_messageId		INT;
	DECLARE ret_message		CLOB(1M);
	DECLARE at_end			INT ;
	DECLARE SQLCODE			INT;
	DECLARE messId_temp		INT;
	DECLARE messageIdStr		VARCHAR(8000);	--only messageids will be there no need for vargraphic
	DECLARE cntr			INT;
	DECLARE firstMessageId		INT;
	DECLARE cnt			INT;
	DECLARE rcnt			INT;
	DECLARE rst			INT;
	DECLARE MessTable_Cursor	INT;
	DECLARE ret			INT;
	DECLARE rowcount		INT;
	DECLARE in_DBWKInDelay		INT;
	DECLARE queryStr		VARCHAR(8000);
	DECLARE v_tempUserId		INT;
	DECLARE v_divertUserId		INT;
	DECLARE v_divertUserName	VARCHAR(100);
	DECLARE DivertUser_Cursor	INT;
	DECLARE v_DBFieldName		VARGRAPHIC(2000);
	DECLARE in_DBDelayTime		INT;
	DECLARE v_Count		        INT;	
	DECLARE v_TransferString	VARCHAR(8000);
	DECLARE v_DeleteString		VARCHAR(8000);
	DECLARE v_Cursor_str		VARCHAR(4000);
	DECLARE v_Divert_str		VARCHAR(4000);
	/* Added By Varun Bhansaly 0n 08/02/2007 for Bugzilla Bug 74 */
	DECLARE v_ActionDateTime	VARCHAR(50);
	/* Added By Varun Bhansaly 0n 08/02/2007 for Bugzilla Bug 74 */
	DECLARE v_DBActionDateTime      VARCHAR(50);
    DECLARE v_Cur_stmt		STATEMENT;
	DECLARE v_Divert_stmt		STATEMENT;
	DECLARE v_Var_Cursor		CURSOR FOR v_Cur_stmt;
	DECLARE v_Divert_Cursor		CURSOR FOR v_Divert_stmt;
		
	DECLARE resultCur CURSOR WITH RETURN FOR
		SELECT ret_messageId AS MessageId, ret_message as Message FROM SYSIBM.SYSDUMMY1;
	DECLARE CONTINUE HANDLER FOR NOT FOUND
	BEGIN
		SET at_end = 1;       		
	END;

	SET in_DBWKInDelay = DBWKInDelay;
	SET v_DBFieldName = DBFieldName;
	SET in_DBDelayTime = DBDelayTime;
	/* Added By Varun Bhansaly 0n 08/02/2007 for Bugzilla Bug 74 */
	SET v_DBActionDateTime = DBActionDateTime;

	IF v_mode = 1 THEN
		SET v_Count = -1;
		Select messageId, message, 1 Into ret_messageId, ret_message, v_Count From WFMessageInProcessTable
			where lockedBy = utilId FETCH FIRST 1 ROW ONLY;
--		IF SQLCODE = 100 THEN	-- No rows returned...
		IF v_Count = -1 THEN
			SET cntr = 0;
			SET messageIdStr = '';
			SET firstMessageId = 0;
			
			SAVEPOINT LOCK_MES ON ROLLBACK RETAIN CURSORS;

			SET v_Cursor_str = 'SELECT messageId From WFMessageTable FETCH FIRST ' || CHAR(messageCount) || ' ROWS ONLY FOR UPDATE';
			PREPARE v_Cur_stmt FROM v_Cursor_str;
			OPEN v_Var_Cursor;
			set at_end = 0;
			FETCH FROM v_Var_Cursor into messId_temp;
			WHILE (at_end = 0) do
				IF cntr > 0 THEN
					SET messageIdStr = messageIdStr || ', ';
				ELSE
					SET firstMessageId = messId_temp;
				END IF;
				SET messageIdStr = messageIdStr || CHAR(messId_temp);
				SET cntr = cntr + 1;
				FETCH FROM v_Var_Cursor INTO messId_temp;
			END WHILE ;
			CLOSE v_Var_Cursor;

			IF cntr <= 0 THEN
				ROLLBACK TO SAVEPOINT LOCK_MES;
				SET ret_messageId = 0;
				SET ret_message = 'NO_MORE_DATA';
				OPEN resultCur;
				RETURN;
			END IF;

			/* Changed By Varun Bhansaly 0n 08/02/2007 for Bugzilla Bug 74 */
			SET v_TransferString = 'Insert into WFMessageInProcessTable Select messageId, message, ''' || UtilId || ''', ''L'', ActionDateTime From WFMessageTable where messageId in ( ' || messageIdStr || ' )';
			SET v_DeleteString = 'Delete From WFMessageTable Where messageId  in (' || messageIdStr || ')' ;


			EXECUTE IMMEDIATE v_TransferString;
			EXECUTE IMMEDIATE v_DeleteString;
			
			COMMIT;
			SET ret_messageId = firstMessageId;

			Select message Into ret_message From WFMessageInProcessTable where messageId = firstMessageId;
		END IF;

		OPEN resultCur;
		RETURN;
	ELSE
		IF v_mode = 2 THEN
			SET rst = 0;
			SET cnt = 1;
			/* Changed By Varun Bhansaly 0n 08/02/2007 for Bugzilla Bug Id 74 */
			SELECT VARCHAR_FORMAT(ActionDateTime, 'YYYY-MM-DD HH24:MI:SS') INTO v_actionDateTime FROM WFMessageInProcessTable WHERE messageId = msgId;
			/* Added By Varun Bhansaly On 08/02/2007 for Bugzilla Bug Id 74 */
			IF (LENGTH(COALESCE(v_actionDateTime,'')) <> 0) THEN
				Set v_DBActionDateTime = v_actionDateTime;
			END IF;
		
			IF DBActionId  = 53 OR  DBActionId  = 54 THEN	/* todo: condition should be for actionId 53 only OR for both.	*/
				SET v_tempUserId = int(v_DBFieldName);
				SET v_DBFieldName = N'';
				SET v_Divert_str = 'SELECT UserIndex, UserName From PDBUser Where userIndex in ( ' || CHAR(DBUserId) || ', ' || CHAR(DBFieldId) || ', ' || CHAR(v_tempUserId) || ') ';
				PREPARE v_Divert_stmt FROM v_Divert_str;
				OPEN v_Divert_Cursor;
				set at_end = 0;
				FETCH FROM v_Divert_Cursor INTO v_divertUserId, v_divertUserName;
				WHILE (at_end = 0) do
					IF ( v_divertUserId = v_divertUserId) THEN
						Set v_DBFieldName = v_DBFieldName || '<DivertedByName>';
						Set v_DBFieldName = v_DBFieldName || LTRIM(RTRIM(v_divertUserName));
						Set v_DBFieldName = v_DBFieldName || '</DivertedByName>';
					ELSEIF (v_divertUserId = DBFieldId) THEN
						Set v_DBFieldName = v_DBFieldName || '<DivertedForName>';
						Set v_DBFieldName = v_DBFieldName || LTRIM(RTRIM(v_divertUserName));
						Set v_DBFieldName = v_DBFieldName || '</DivertedForName>';
					ELSEIF v_divertUserId = v_tempUserId THEN
						Set v_DBFieldName = v_DBFieldName || '<DivertedToId>' ;
						Set v_DBFieldName = v_DBFieldName || char(v_tempUserId);
						Set v_DBFieldName = v_DBFieldName || '</DivertedToId>';
						Set v_DBFieldName = v_DBFieldName || '<DivertedToName>';
						Set v_DBFieldName = v_DBFieldName || LTRIM(RTRIM(v_divertUserName));
						Set v_DBFieldName = v_DBFieldName || '</DivertedToName>';
					END IF;
					FETCH FROM v_Divert_Cursor INTO v_divertUserId, v_divertUserName;
				END WHILE ;
				CLOSE v_Divert_Cursor;
			END IF;


			SAVEPOINT PROCESS  ON ROLLBACK RETAIN CURSORS;
				
			IF DBFlag = 0  or DBFlag = 1 THEN
				/* Changed By Varun Bhansaly On 08/02/2007 For Bugzilla Bug Id 74*/
				INSERT INTO CurrentRouteLogTable
					(ProcessDefId, ActivityId, ProcessInstanceId, WorkItemId, UserId,
					ActionId, ActionDateTime, AssociatedFieldId, AssociatedFieldName,
					ActivityName, UserName)
				VALUES (DBProcessDefId, DBActivityId, DBProcessInstance, DBWorkitemId, DBUserId,
					DBActionId, v_DBActionDateTime, DBFieldId, v_DBFieldName,
					DBActivityName, DBUserName);
					
				GET DIAGNOSTICS rowcount = ROW_COUNT;

				IF rowcount <= 0 THEN
					ROLLBACK TO SAVEPOINT PROCESS;
				/* SRNo-1, WFMessageInProcessTable introduced as Insert on MessageTable was taking time - Mandeep Kaur*/
					SAVEPOINT FAILED ON ROLLBACK RETAIN CURSORS;
						/* Changed By Varun Bhansaly On 08/02/2007 For Bugzilla Bug Id 74*/
						INSERT INTO WFFailedMessageTable
							SELECT messageId, message, cast(NULL as vargraphic(63)), 'F', CURRENT TIMESTAMP, ActionDateTime 
							FROM WFMessageInProcessTable
							WHERE MessageId = msgid;
						DELETE FROM WFMessageInProcessTable Where MessageId = msgid;
					COMMIT;
					SET ret_messageId = 0;
					SET ret_message = 'Insert Failed 1.';
					OPEN resultCur;
					RETURN;
				END IF;
			END IF;
					

			IF DBFlag = 2 THEN
				IF in_DBDelayTime > 0 THEN
					SET in_DBWKInDelay = 1;
				ELSE
					SET in_DBWKInDelay = 0;
					SET in_DBDelayTime = 0;
				END IF;
				/* select 'Step - 6', DBActionId , v_DBActionDateTime	*/
				/* Changed By Varun Bhansaly On 08/02/2007 For Bugzilla Bug Id 74*/
				IF DBActionId  = 27 OR  DBActionId  = 2 THEN
					UPDATE summarytable
					set
						totalwicount = coalesce(totalwicount, 0) + 1,
						totalduration = coalesce(totalduration, 0) + DBTotalDuration,
						totalprocessingtime = coalesce(totalprocessingtime, 0) + DBTotalPrTime,
						delaytime = coalesce(delaytime, 0) + in_DBDelayTime,
						wkindelay = coalesce(wkindelay, 0) + in_DBWKInDelay,
						actiondatetime = v_DBActionDateTime
					where processdefid = DBProcessDefId
					and activityid = DBActivityId
					and userid = DBUserId
					and actionid = DBActionId
					and queueid = DBQueueId
					and SUBSTR(TO_CHAR(ActionDateTime, 'YYYY-MM-DD HH24:MI:SS'), 1, 13) =
					SUBSTR(coalesce(v_DBActionDateTime, TO_CHAR(CURRENT TIMESTAMP, 'YYYY-MM-DD HH24:MI:SS')), 1, 13);
					
					/* Changed By Varun Bhansaly On 08/02/2007 For Bugzilla Bug Id 74*/
					GET DIAGNOSTICS rowcount = ROW_COUNT;
					
					IF rowcount = 0 THEN
						INSERT into summarytable
							(processdefid, activityid, queueid, userid, actionid,
							actiondatetime, activityname, username, totalwicount,
							totalduration, totalprocessingtime, delaytime,
							wkindelay, reporttype)
						values
							(DBProcessDefId, DBActivityId, DBQueueId, DBUserId, DBActionId,
							TO_DATE(v_DBActionDateTime, 'YYYY-MM-DD HH24:MI:SS'), DBActivityName, DBUserName, DBTotalWiCount,
							DBTotalDuration, DBTotalPrTime, in_DBDelayTime,
							in_DBWKInDelay, DBReportType);
						GET DIAGNOSTICS rowcount = ROW_COUNT;
						IF rowcount <= 0 THEN
							ROLLBACK TO SAVEPOINT PROCESS;
								/* SRNo-1, WFMessageInProcessTable introduced  as Insert on MessageTable was taking time - Mandeep Kaur*/
							SAVEPOINT FAILED ON ROLLBACK RETAIN CURSORS;
				
								/* Changed By Varun Bhansaly On 08/02/2007 For Bugzilla Bug Id 74*/
								Insert Into WFFailedMessageTable
									Select messageId, message, cast(NULL as vargraphic(63)), 'F', CURRENT TIMESTAMP, ActionDateTime 
									From WFMessageInProcessTable
									Where MessageId = msgid;
								Delete From WFMessageInProcessTable Where MessageId = msgid;
							COMMIT;
							SET ret_messageId = 0;
							SET ret_message = 'Insert Failed 4.';
							OPEN resultCur;
							RETURN;
						END IF;
					END IF;
				END IF;

				/* Changed By Varun Bhansaly On 08/02/2007 For Bugzilla Bug Id 74*/
				IF DBActionId = 8 THEN
					UPDATE summarytable set
						totalprocessingtime = coalesce(totalprocessingtime, 0) + DBTotalPrTime,
						actiondatetime = TO_DATE(v_DBActionDateTime, 'YYYY-MM-DD HH24:MI:SS')
					where processdefid = DBProcessDefId
					and activityid = DBActivityId and userid = DBUserId
					and actionid = 27 and queueid = DBQueueId
					and SUBSTR(TO_CHAR(ActionDateTime, 'YYYY-MM-DD HH24:MI:SS'), 1, 13) =
					SUBSTR(coalesce(v_DBActionDateTime, TO_CHAR(CURRENT TIMESTAMP, 'YYYY-MM-DD HH24:MI:SS')), 1, 13);
					
					GET DIAGNOSTICS rowcount = ROW_COUNT;
					/* Changed By Varun Bhansaly On 08/02/2007 For Bugzilla Bug Id 74*/
					IF rowcount = 0 THEN
						INSERT INTO summarytable
							(processdefid, activityid, queueid, userid, actionid,
							actiondatetime, activityname, username, totalwicount,
							totalduration, totalprocessingtime, delaytime, wkindelay,
							reporttype)
						VALUES
							(DBProcessDefId, DBActivityId, DBQueueId, DBUserId, 27,
							TO_DATE(v_DBActionDateTime, 'YYYY-MM-DD HH24:MI:SS'), DBActivityName, DBUserName, 0,
							DBTotalDuration, DBTotalPrTime, in_DBDelayTime, in_DBWKInDelay,
							DBReportType);
						GET DIAGNOSTICS rowcount = ROW_COUNT;
						IF rowcount <= 0 THEN
							ROLLBACK TO SAVEPOINT PROCESS;
							/* SRNo-1, WFMessageInProcessTable introduced as Insert on MessageTable was taking time- Mandeep Kaur*/
							SAVEPOINT FAILED ON ROLLBACK RETAIN CURSORS;
								/* Changed By Varun Bhansaly On 08/02/2007 For Bugzilla Bug Id 74*/
								Insert Into WFFailedMessageTable
									Select messageId, message, cast(NULL as vargraphic(63)), 'F', CURRENT TIMESTAMP, ActionDateTime 
									From WFMessageInProcessTable
									Where MessageId = msgid;
								Delete From WFMessageInProcessTable Where MessageId = msgid;
							COMMIT;
							SET ret_messageId = 0;
							SET ret_message = 'Insert Failed 5.';
							OPEN resultCur;
							RETURN;
						END IF;
					END IF;

				END IF;

				/* Changed By Varun Bhansaly On 08/02/2007 For Bugzilla Bug Id 74*/
				IF DBActionId  = 28 THEN
					UPDATE summarytable set
						totalwicount = coalesce(totalwicount, 0) + 1,
						totalduration = coalesce(totalduration, 0) + DBTotalDuration,
						totalprocessingtime = coalesce(totalprocessingtime, 0) + DBTotalPrTime,
						wkindelay = coalesce(wkindelay, 0) + in_DBWKInDelay,
						actiondatetime = TO_DATE(v_DBActionDateTime, 'YYYY-MM-DD HH24:MI:SS')
					where processdefid = DBProcessDefId
					and activityid = DBActivityId
					and actionid = DBActionId
					and SUBSTR(TO_CHAR(ActionDateTime, 'YYYY-MM-DD HH24:MI:SS'), 1, 13) =
					SUBSTR(coalesce(v_DBActionDateTime, TO_CHAR(CURRENT TIMESTAMP, 'YYYY-MM-DD HH24:MI:SS')), 1, 13);
					
					/* Changed By Varun Bhansaly On 08/02/2007 For Bugzilla Bug Id 74*/
					GET DIAGNOSTICS rowcount = ROW_COUNT;
					IF rowcount = 0 THEN
						INSERT into summarytable
							(processdefid, activityid, queueid, userid, actionid,
							actiondatetime, activityname, username, totalwicount,
							totalduration, totalprocessingtime, delaytime, wkindelay,
							reporttype)
						values
							(DBProcessDefId, DBActivityId, DBQueueId, DBUserId, DBActionId,
							TO_DATE(v_DBActionDateTime, 'YYYY-MM-DD HH24:MI:SS'), DBActivityName, DBUserName, DBTotalWiCount,
							DBTotalDuration, DBTotalPrTime, in_DBDelayTime, in_DBWKInDelay,
							DBReportType);
						GET DIAGNOSTICS rowcount = ROW_COUNT;
						IF rowcount <= 0 THEN
							ROLLBACK TO SAVEPOINT PROCESS;
							/* SRNo-1, WFMessageInProcessTable introduced as Insert on MessageTable was taking time- Mandeep Kaur*/
							SAVEPOINT FAILED ON ROLLBACK RETAIN CURSORS;
								/* Changed By Varun Bhansaly On 08/02/2007 For Bugzilla Bug Id 74*/
								Insert Into WFFailedMessageTable
									Select messageId, message, cast(NULL as vargraphic(63)), 'F', CURRENT TIMESTAMP, ActionDateTime 
									From WFMessageInProcessTable
									Where MessageId = msgid;
								Delete From WFMessageInProcessTable Where MessageId = msgid;
							COMMIT;
							SET ret_messageId = 0;
							SET ret_message = 'Insert Failed 6.';
							OPEN resultCur;
							RETURN;
						END IF;
					END IF;
				END IF;
				
				/* Changed By Varun Bhansaly On 08/02/2007 For Bugzilla Bug Id 74*/
				IF DBActionId  = 1 THEN
					UPDATE summarytable set
						totalwicount = coalesce(totalwicount, 0) + 1,
						actiondatetime = TO_DATE(v_DBActionDateTime, 'YYYY-MM-DD HH24:MI:SS')
					where processdefid = DBProcessDefId
					and userid = DBUserId
					and actionid = DBActionId
					and SUBSTR(TO_CHAR(ActionDateTime, 'YYYY-MM-DD HH24:MI:SS'), 1, 13) =
					SUBSTR(coalesce(v_DBActionDateTime, TO_CHAR(CURRENT TIMESTAMP, 'YYYY-MM-DD HH24:MI:SS')), 1, 13);

					/* Changed By Varun Bhansaly On 08/02/2007 For Bugzilla Bug Id 74*/
					GET DIAGNOSTICS rowcount = ROW_COUNT;
					IF rowcount = 0 THEN
						INSERT into summarytable
							(processdefid, activityid, queueid, userid, actionid,
							actiondatetime, activityname, username, totalwicount,
							totalduration, totalprocessingtime, delaytime, wkindelay,
							reporttype)
						values
							(DBProcessDefId, DBActivityId, DBQueueId, DBUserId, DBActionId,
							TO_DATE(v_DBActionDateTime, 'YYYY-MM-DD HH24:MI:SS'), DBActivityName, DBUserName, DBTotalWiCount,
							DBTotalDuration, DBTotalPrTime, in_DBDelayTime, in_DBWKInDelay,
							DBReportType);
						GET DIAGNOSTICS rowcount = ROW_COUNT;
						IF rowcount <= 0 THEN
							ROLLBACK TO SAVEPOINT PROCESS;
							/* SRNo-1, WFMessageInProcessTable introduced as Insert on MessageTable was taking time- Mandeep Kaur*/
							SAVEPOINT FAILED ON ROLLBACK RETAIN CURSORS;
								/* Changed By Varun Bhansaly On 08/02/2007 For Bugzilla Bug Id 74*/
								Insert Into WFFailedMessageTable
									Select messageId, message, cast(NULL as vargraphic(63)), 'F', CURRENT TIMESTAMP, ActionDateTime 
									From WFMessageInProcessTable
									Where MessageId = msgid;
								Delete From WFMessageInProcessTable Where MessageId = msgid;
							COMMIT;
							SET ret_messageId = 0;
							SET ret_message = 'Insert Failed 7.';
							OPEN resultCur;
							RETURN;
						END IF;
					END IF;
				END IF;

				/* Changed By Varun Bhansaly On 08/02/2007 For Bugzilla Bug Id 74*/
				IF DBActionId = 45 THEN
					UPDATE summarytable set
						totalwicount = coalesce(totalwicount, 0) + 1,
						totalduration = coalesce(totalduration, 0) + DBTotalDuration,
						totalprocessingtime = coalesce(totalprocessingtime, 0) + DBTotalPrTime,
						delaytime = coalesce(delaytime, 0) + in_DBDelayTime,
						wkindelay = coalesce(wkindelay, 0) + in_DBWKInDelay,
						actiondatetime = TO_DATE(v_DBActionDateTime, 'YYYY-MM-DD HH24:MI:SS')
					where processdefid = DBProcessDefId
					and activityid = DBActivityId
					and userid = DBUserId
					and actionid = DBActionId
					and SUBSTR(TO_CHAR(ActionDateTime, 'YYYY-MM-DD HH24:MI:SS'), 1, 13) =
					SUBSTR(coalesce(v_DBActionDateTime, TO_CHAR(CURRENT TIMESTAMP, 'YYYY-MM-DD HH24:MI:SS')), 1, 13);
					
					/* Changed By Varun Bhansaly On 08/02/2007 For Bugzilla Bug Id 74*/
					GET DIAGNOSTICS rowcount = ROW_COUNT;
					IF rowcount = 0 THEN
						INSERT into summarytable
							(processdefid, activityid, queueid, userid, actionid,
							actiondatetime, activityname, username, totalwicount,
							totalduration, totalprocessingtime, delaytime, wkindelay,
							reporttype)
						values
							(DBProcessDefId, DBActivityId, DBQueueId, DBUserId, DBActionId,
							TO_DATE(v_DBActionDateTime, 'YYYY-MM-DD HH24:MI:SS'), DBActivityName, DBUserName, DBTotalWiCount,
							DBTotalDuration, DBTotalPrTime, in_DBDelayTime, in_DBWKInDelay,
							DBReportType);
						GET DIAGNOSTICS rowcount = ROW_COUNT;
						IF rowcount <= 0 THEN
							ROLLBACK TO SAVEPOINT PROCESS;
							/* SRNo-1, WFMessageInProcessTable introduced as Insert on MessageTable was taking time - Mandeep Kaur*/
							SAVEPOINT FAILED ON ROLLBACK RETAIN CURSORS;
								/* Changed By Varun Bhansaly On 08/02/2007 For Bugzilla Bug Id 74*/
								Insert Into WFFailedMessageTable
									Select messageId, message, cast(NULL as vargraphic(63)), 'F', CURRENT TIMESTAMP, ActionDateTime 
									From WFMessageInProcessTable
									Where MessageId = msgid;
								Delete From WFMessageInProcessTable Where MessageId = msgid;
							COMMIT;
							SET ret_messageId = 0;
							SET ret_message = 'Insert Failed 8.';
							OPEN resultCur;
							RETURN;
						END IF;
					END IF;
				END IF;
						
				/* Changed By Varun Bhansaly On 08/02/2007 For Bugzilla Bug Id 74*/
				IF DBActionId = 20 THEN
					UPDATE summarytable set
						totalwicount = coalesce(totalwicount, 0) + 1,
						totalprocessingtime = coalesce(totalprocessingtime, 0) + DBTotalPrTime,
						delaytime = coalesce(delaytime, 0) + in_DBDelayTime,
						wkindelay = coalesce(wkindelay, 0) + in_DBWKInDelay,
						actiondatetime = TO_DATE(v_DBActionDateTime, 'YYYY-MM-DD HH24:MI:SS')
					where processdefid = DBProcessDefId
					and actionid = DBActionId
					and SUBSTR(TO_CHAR(ActionDateTime, 'YYYY-MM-DD HH24:MI:SS'), 1, 13) =
					SUBSTR(coalesce(v_DBActionDateTime, TO_CHAR(CURRENT TIMESTAMP, 'YYYY-MM-DD HH24:MI:SS')), 1, 13);

					/* Changed By Varun Bhansaly On 08/02/2007 For Bugzilla Bug Id 74*/
					GET DIAGNOSTICS rowcount = ROW_COUNT;
					IF rowcount = 0 THEN
						INSERT into summarytable
							(processdefid, activityid, queueid, userid, actionid,
							actiondatetime, activityname, username, totalwicount,
							totalduration, totalprocessingtime, delaytime, wkindelay,
							reporttype)
						values
							(DBProcessDefId, DBActivityId, DBQueueId, DBUserId, DBActionId,
							TO_DATE(v_DBActionDateTime, 'YYYY-MM-DD HH24:MI:SS'), DBActivityName, DBUserName, DBTotalWiCount,
							DBTotalDuration, DBTotalPrTime, in_DBDelayTime, in_DBWKInDelay,
							DBReportType);
						GET DIAGNOSTICS rowcount = ROW_COUNT;
						IF rowcount <= 0 THEN
							ROLLBACK TO SAVEPOINT PROCESS;
							/* SRNo-1, WFMessageInProcessTable introduced as Insert on MessageTable was taking time- Mandeep Kaur*/
							SAVEPOINT FAILED ON ROLLBACK RETAIN CURSORS;
								Insert Into WFFailedMessageTable
									Select messageId, message, cast(NULL as vargraphic(63)), 'F', CURRENT TIMESTAMP, ActionDateTime 
									From WFMessageInProcessTable
									Where MessageId = msgid;
								Delete From WFMessageInProcessTable Where MessageId = msgid;
							COMMIT;
							SET ret_messageId = 0;
							SET ret_message = 'Insert Failed 9.';
							OPEN resultCur;
							RETURN;
						END IF;
					END IF;
				END IF;
						
				/* Changed By Varun Bhansaly On 08/02/2007 For Bugzilla Bug Id 74*/					
				IF DBActionId = 3 OR DBActionId = 5 THEN
					UPDATE summarytable set
						totalwicount = coalesce(totalwicount, 0) + 1,
						totalduration = coalesce(totalduration, 0) + DBTotalDuration,
						totalprocessingtime = coalesce(totalprocessingtime, 0) + DBTotalPrTime,
						delaytime = coalesce(delaytime, 0) + in_DBDelayTime,
						wkindelay = coalesce(wkindelay, 0) + in_DBWKInDelay,
						actiondatetime = TO_DATE(v_DBActionDateTime, 'YYYY-MM-DD HH24:MI:SS')
					where processdefid = DBProcessDefId
					and actionid = DBActionId
					and SUBSTR(TO_CHAR(ActionDateTime, 'YYYY-MM-DD HH24:MI:SS'), 1, 13) =
					SUBSTR(coalesce(v_DBActionDateTime, TO_CHAR(CURRENT TIMESTAMP, 'YYYY-MM-DD HH24:MI:SS')), 1, 13);
					
					/* Changed By Varun Bhansaly On 08/02/2007 For Bugzilla Bug Id 74*/
					GET DIAGNOSTICS rowcount = ROW_COUNT;
					IF rowcount = 0 THEN
						INSERT into summarytable
							(processdefid, activityid, queueid, userid, actionid,
							actiondatetime, activityname, username, totalwicount,
							totalduration, totalprocessingtime, delaytime, wkindelay,
							reporttype)
						values(DBProcessDefId, DBActivityId, DBQueueId, DBUserId, DBActionId,
							TO_DATE(v_DBActionDateTime, 'YYYY-MM-DD HH24:MI:SS'), DBActivityName, DBUserName, DBTotalWiCount,
							DBTotalDuration, DBTotalPrTime, in_DBDelayTime, in_DBWKInDelay,
							DBReportType);
						GET DIAGNOSTICS rowcount = ROW_COUNT;
						IF rowcount <= 0 THEN
							ROLLBACK TO SAVEPOINT PROCESS;
							/* SRNo-1, WFMessageInProcessTable introduced as Insert on MessageTable was taking time- Mandeep Kaur */
							SAVEPOINT FAILED ON ROLLBACK RETAIN CURSORS;
								/* Changed By Varun Bhansaly On 08/02/2007 For Bugzilla Bug Id 74*/
								Insert Into WFFailedMessageTable
									Select messageId, message, cast(NULL as vargraphic(63)), 'F', CURRENT TIMESTAMP, ActionDateTime 
									From WFMessageInProcessTable
									Where MessageId = msgid;
								Delete From WFMessageInProcessTable Where MessageId = msgid;
							COMMIT;
							SET ret_messageId = 0;
							SET ret_message = 'Insert Failed 10.';
							OPEN resultCur;
							RETURN;
						END IF;
					END IF;
				END IF;
						
				/*
					Changed By  : Ruhi Hira
					Changed On  : 07th Feb 2007
					Description : Bugzilla Id 460, redundant activityName condition removed.
				*/
				/* Changed By Varun Bhansaly On 08/02/2007 For Bugzilla Bug Id 74*/
				IF DBActionId  = 4 OR DBActionId  = 6 THEN
					UPDATE summarytable set
						totalwicount = coalesce(totalwicount, 0) + 1,
						actiondatetime = TO_DATE(v_DBActionDateTime, 'YYYY-MM-DD HH24:MI:SS')
					where processdefid = DBProcessDefId
					and actionid = DBActionId
					and queueid = DBQueueId
					and activityid = DBActivityId
					and SUBSTR(TO_CHAR(ActionDateTime, 'YYYY-MM-DD HH24:MI:SS'), 1, 13) =
					SUBSTR(coalesce(v_DBActionDateTime, TO_CHAR(CURRENT TIMESTAMP, 'YYYY-MM-DD HH24:MI:SS')), 1, 13);
					
					/* Changed By Varun Bhansaly On 08/02/2007 For Bugzilla Bug Id 74*/
					GET DIAGNOSTICS rowcount = ROW_COUNT;
					IF rowcount = 0 THEN
						INSERT into summarytable
							(processdefid, activityid, queueid, userid, actionid,
							actiondatetime, activityname, username, totalwicount,
							totalduration, totalprocessingtime, delaytime, wkindelay,
							reporttype)
						values(DBProcessDefId, DBActivityId, DBQueueId, DBUserId, DBActionId,
							TO_DATE(v_DBActionDateTime, 'YYYY-MM-DD HH24:MI:SS'), DBActivityName, DBUserName, DBTotalWiCount,
							DBTotalDuration, DBTotalPrTime, in_DBDelayTime, in_DBWKInDelay,
							DBReportType);
						GET DIAGNOSTICS rowcount = ROW_COUNT;
						IF rowcount <= 0 THEN
							ROLLBACK TO SAVEPOINT PROCESS;
							/* SRNo-1, WFMessageInProcessTable introduced as Insert on MessageTable was taking time- Mandeep Kaur */
							SAVEPOINT FAILED ON ROLLBACK RETAIN CURSORS;
								/* Changed By Varun Bhansaly On 08/02/2007 For Bugzilla Bug Id 74*/
								Insert Into WFFailedMessageTable
									Select messageId, message, cast(NULL as vargraphic(63)), 'F', CURRENT TIMESTAMP, ActionDateTime 
									From WFMessageInProcessTable
									Where MessageId = msgid;
								Delete From WFMessageInProcessTable Where MessageId = msgid;
							COMMIT;
							SET ret_messageId = 0;
							SET ret_message = 'Insert Failed 11.';
							OPEN resultCur;
							RETURN;
						END IF;
					END IF;
				END IF;

				/* Changed By Varun Bhansaly On 08/02/2007 For Bugzilla Bug Id 74*/
				IF DBActionId  = 9 OR DBActionId  = 10 THEN
					UPDATE summarytable set
						totalwicount = coalesce(totalwicount, 0) + 1,
						actiondatetime = TO_DATE(v_DBActionDateTime, 'YYYY-MM-DD HH24:MI:SS')
					where processdefid = DBProcessDefId
					and actionid = DBActionId
					and AssociatedFieldId = DBFieldId
					and SUBSTR(TO_CHAR(ActionDateTime, 'YYYY-MM-DD HH24:MI:SS'), 1, 13) =
					SUBSTR(coalesce(v_DBActionDateTime, TO_CHAR(CURRENT TIMESTAMP, 'YYYY-MM-DD HH24:MI:SS')), 1, 13);
					
					/* Changed By Varun Bhansaly On 08/02/2007 For Bugzilla Bug Id 74*/
					GET DIAGNOSTICS rowcount = ROW_COUNT;
					IF rowcount = 0 THEN
						INSERT into summarytable
							(processdefid, activityid, queueid, userid, actionid,
							actiondatetime, activityname, username, totalwicount,
							totalduration, totalprocessingtime, delaytime, wkindelay, AssociatedFieldId,
							reporttype)
						values(DBProcessDefId, DBActivityId, DBQueueId, DBUserId, DBActionId,
							TO_DATE(v_DBActionDateTime, 'YYYY-MM-DD HH24:MI:SS'), DBActivityName, DBUserName, DBTotalWiCount,
							DBTotalDuration, DBTotalPrTime, in_DBDelayTime, in_DBWKInDelay, DBFieldId,
							DBReportType);
						GET DIAGNOSTICS rowcount = ROW_COUNT;
						IF rowcount <= 0  THEN
							ROLLBACK TO SAVEPOINT PROCESS;
							/* SRNo-1, WFMessageInProcessTable introduced as Insert on MessageTable was taking time- Mandeep Kaur*/
							SAVEPOINT FAILED ON ROLLBACK RETAIN CURSORS;
								/* Changed By Varun Bhansaly On 08/02/2007 For Bugzilla Bug Id 74*/
								Insert Into WFFailedMessageTable
									Select messageId, message, cast(NULL as vargraphic(63)), 'F', CURRENT TIMESTAMP, ActionDateTime 
									From WFMessageInProcessTable
									Where MessageId = msgid;
								Delete From WFMessageInProcessTable Where MessageId = msgid;
							COMMIT;
							SET ret_messageId = 0;
							SET ret_message = 'Insert Failed 12.';
							OPEN resultCur;
							RETURN;
						END IF;
					END IF;
				END IF;



			END IF;
			
			IF deleteFlag = 1 THEN
				/*SRNo-1, WFMessageInProcessTable introduced as Insert on MessageTable was taking time- Mandeep Kaur*/
				Delete From WFMessageInProcessTable where messageId = msgId;
				GET DIAGNOSTICS rowcount = ROW_COUNT;
				SET rst = rowcount;
			ELSE
				SET rst = 1;
			END IF;

			COMMIT;
			SET ret_messageId = 1;
			SET ret_message = 'SUCCESS';
			OPEN resultCur;
		ELSE
			SET ret_messageId = 0;
			SET ret_message = 'INVALID_MODE';
			OPEN resultCur;
			RETURN;
		END IF;
	END IF;
END			 