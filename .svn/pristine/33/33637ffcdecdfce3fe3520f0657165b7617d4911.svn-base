/*__________________________________________________________________________________________________________________
			NEWGEN SOFTWARE TECHNOLOGIES LIMITED
____________________________________________________________________________________________________________________
	Group						: Phoenix
	Product / Project			: Omniflow 8.1
	Module						: WorkFlow Server
	File Name					: WFProcessMessage.sql
	Author						: Saurabh Kamal
	Date written (DD/MM/YYYY)	: 18/08/2010
	Description					: This stored procedure is called from WFProcessMessage (WFInternal.java).
____________________________________________________________________________________________________________________
				CHANGE HISTORY
____________________________________________________________________________________________________________________

Date			Change By		Change Description (Bug No. (If Any))
____________________________________________________________________________________________________________________
___________________________________________________________________________________________________________________*/

CREATE OR REPLACE FUNCTION WFProcessMessageExt(INTEGER, INTEGER, INTEGER, INTEGER, INTEGER, VARCHAR, VARCHAR, INTEGER, VARCHAR, INTEGER, INTEGER, VARCHAR, INTEGER, INTEGER, INTEGER, INTEGER, VARCHAR, VARCHAR, VARCHAR, VARCHAR, INTEGER, INTEGER, VARCHAR, INTEGER, VARCHAR, INTEGER) RETURNS REFCURSOR AS '
DECLARE 
	DBActionId				ALIAS FOR $1;
	DBUserId				ALIAS FOR $2;
	DBProcessDefId			ALIAS FOR $3;
	DBActivityId			ALIAS FOR $4;
	DBQueueId				ALIAS FOR $5;
	DBUserName				ALIAS FOR $6;
	DBActivityName			ALIAS FOR $7;
	DBSummaryActId			ALIAS FOR $8;
	DBSummaryActName		ALIAS FOR $9;
	DBTotalWiCount			ALIAS FOR $10;
	DBTotalDuration			ALIAS FOR $11;	
	DBProcessInstance		ALIAS FOR $12; 
	DBFieldId				ALIAS FOR $13; 
	DBFlag					ALIAS FOR $14;
	DBWorkitemId			ALIAS FOR $15;
	DBTotalPrTime			ALIAS FOR $16;
	DBFieldName				ALIAS FOR $17;
	DBNewValue				ALIAS FOR $18;
	DBActionDateTime		ALIAS FOR $19;
	DBAssociatedDateTime	ALIAS FOR $20;
	DBDelayTime				ALIAS FOR $21;
	DBWKInDelay				ALIAS FOR $22;
	DBReportType			ALIAS FOR $23;
	DBMsgId					ALIAS FOR $24; 
	DBUtilId				ALIAS FOR $25; 	
	DBDeleteFlag			ALIAS FOR $26;		/* 1 record to be deleted from wfmessageTable , 2 not to be deleted	*/ 
											/* placed for case setAttribute(more than one in single message)	*/ 
	ret_messageId			INTEGER; 
	ret_message				TEXT; 													
	v_pos					INTEGER;
	messId_temp				INTEGER; 
	messageIdStr			TEXT; 
	cntr					INTEGER; 
	firstMessageId			INTEGER; 
	cnt						INTEGER; 
	rcnt					INTEGER; 
	rst						INTEGER; 
	MessTable_Cursor		INTEGER; 
	ret						INTEGER; 
	rowCount				INTEGER; 
	in_DBWKInDelay			INTEGER; 
	queryStr				TEXT; 
	v_tempUserId			INTEGER; 
	v_divertUserId			INTEGER; 
	v_divertUserName		VARCHAR(100); 
	DivertUser_Cursor		INTEGER; 
	v_DBFieldName			VARCHAR(2000); 
	in_DBDelayTime			INTEGER; 
	v_TotPrTimeTillNow		INTEGER; 
	v_TotPrTimeActivity		INTEGER; 	
	v_actionDateTime		VARCHAR(50);
	v_DBActionDateTime		VARCHAR(50);
	v_fieldIdColumn			VARCHAR(50);
	v_ActionDateTimeStart	TIMESTAMP;
	v_ActionDateTimeEnd		TIMESTAMP;
	v_fieldIdValue			VARCHAR(50);
	v_wherestr				VARCHAR(150);
	v_DBActivityId			INTEGER;
	v_DBUserId				INTEGER;
	v_DBQueueId				INTEGER;	
	v_DBAssociatedDateTime	DATE;
	ResultSet				REFCURSOR;
BEGIN
	v_TotPrTimeTillNow	:= 0; 
	in_DBWKInDelay		:= DBWKInDelay; 
	v_DBFieldName		:= DBFieldName; 
	in_DBDelayTime		:= DBDelayTime; 
	
	v_pos := STRPOS(DBActionDateTime,''.''); 
	IF(v_pos > 0) THEN 
		v_DBActionDateTime := SUBSTR(DBActionDateTime, 1, v_pos-1); 
	ELSE
		v_DBActionDateTime := DBActionDateTime; 
	END IF;
	
	v_DBActivityId := DBSummaryActId;
	v_DBUserId := DBUserId;
	v_DBQueueId := DBQueueId;
	v_wherestr := NULL;
	v_fieldIdColumn := '''';
	v_fieldIdValue := '''';
	
--	SAVEPOINT PROCESS; 
		IF(DBActionId = 27 OR DBActionId = 3 OR DBActionId = 5) THEN 
			DELETE FROM WFEscalationTable 
			WHERE processDefId = COALESCE(DBProcessDefId, 0) 
			AND activityId = COALESCE(DBActivityId, 0) 
			AND processInstanceId = COALESCE(DBProcessInstance, '''') 
			AND workitemId = COALESCE(DBWorkitemId, 0) 
			AND ScheduleTime > CURRENT_TIMESTAMP; 
		END IF;
		
		IF( DBFlag = 1 OR DBFlag = 3 ) THEN /*For insertion in currentRouteLogTable*/
			IF( DBAssociatedDateTime IS NOT NULL ) THEN
				v_pos := STRPOS(DBAssociatedDateTime,''.''); 
				IF(v_pos > 0) THEN 
					v_DBAssociatedDateTime := TO_TIMESTAMP(SUBSTR(DBAssociatedDateTime, 1, v_pos-1), ''YYYY-MM-DD HH24:MI:SS'');
				ELSE
					v_DBAssociatedDateTime := TO_TIMESTAMP(DBAssociatedDateTime, ''YYYY-MM-DD HH24:MI:SS'');
				END IF;
			END IF;

			Insert into WFCurrentRouteLogTable  
				(ProcessDefId, ActivityId, ProcessInstanceId, WorkItemId, UserId,  
				ActionId, ActionDateTime, AssociatedDateTime, AssociatedFieldId, AssociatedFieldName, 
				ActivityName, UserName, NewValue, QueueId) 
			values (DBProcessDefId, DBActivityId, DBProcessInstance, DBWorkitemId, DBUserId, 
				DBActionId, TO_TIMESTAMP(v_DBActionDateTime, ''YYYY-MM-DD HH24:MI:SS''), v_DBAssociatedDateTime, DBFieldId, v_DBFieldName, 
				DBActivityName, DBUserName, DBNewValue, DBQueueId); 
			GET DIAGNOSTICS rowCount = ROW_COUNT;
			IF(rowCount <= 0) THEN 
--				ROLLBACK TO SAVEPOINT PROCESS; 
			/* SRNo-1, WFMessageInProcessTable introduced as Insert on MessageTable was taking time - Mandeep Kaur */ 
--				SAVEPOINT FAILED; 
					Insert Into WFFailedMessageTable  
						Select messageId, message, null, ''F'', CURRENT_TIMESTAMP, ActionDateTime 
						From WFMessageInProcessTable 
						Where MessageId = DBMsgId; 
					Delete From WFMessageInProcessTable Where MessageId = DBMsgId; 
--				COMMIT; 
				ret_messageId := 0; 
				ret_message := ''Insert Failed 1.''; 
				OPEN ResultSet FOR SELECT ret_messageId, ret_message;
				RETURN ResultSet; 
			END IF; 
		END IF;
		
	IF(DBFlag = 2 OR DBFlag = 3) THEN /*For insertion in SummaryTable*/
		IF(DBActionId = 8) THEN 
			UPDATE WFReportDataTable SET 
				TotalProcessingTime = totalprocessingtime + v_TotPrTimeTillNow 
			WHERE processInstanceId = DBProcessInstance 
			AND workitemId = DBWorkitemId 
			AND processdefid =  DBProcessdefId 
			AND activityid = DBActivityId 
			AND Userid = DBUserId; 

			GET DIAGNOSTICS rowCount = ROW_COUNT;
			IF(rowCount = 0) THEN  
				INSERT into WFReportDataTable  
					(processInstanceId, workitemId, processdefid, activityid, userid, totalprocessingtime) 
				values  
					(DBProcessInstance, DBWorkitemId, DBProcessDefId, DBActivityId, DBUserId, v_TotPrTimeTillNow); 
				GET DIAGNOSTICS rowCount = ROW_COUNT;  
				IF(rowCount <= 0) THEN  
--					ROLLBACK TO SAVEPOINT PROCESS;  
--					SAVEPOINT FAILED;  
						Insert Into WFFailedMessageTable  
							Select messageId, message, null, ''F'', CURRENT_TIMESTAMP, ActionDateTime 
							From WFMessageInProcessTable  
							Where MessageId = DBMsgId; 
						Delete From WFMessageInProcessTable Where MessageId = DBMsgId; 
--					COMMIT; 
					ret_messageId := 0; 
					ret_message := ''Insert Failed 5.'';
					OPEN ResultSet FOR SELECT ret_messageId, ret_message;					
					RETURN ResultSet; 
				END IF; 
			END IF; 
		ELSE
			IF(DBActionId = 2 OR DBActionId = 27) THEN 				 
				SELECT INTO v_TotPrTimeTillNow TotalProcessingTime  
				FROM WFReportDataTable 
				WHERE	processInstanceId = DBProcessInstance 
					AND workitemId = DBWorkitemId 
					AND processdefid = DBProcessdefId 
					AND activityid = DBActivityId 
					AND Userid = DBUserId; 
				IF(NOT FOUND) THEN
					v_TotPrTimeTillNow := 0; 
				END IF;

				SELECT INTO v_TotPrTimeActivity COALESCE(SUM(TotalProcessingTime), 0)
				FROM WFReportDataTable 
				WHERE	processInstanceId = DBProcessInstance 
				AND processdefid = DBProcessdefId 
				AND activityid = DBActivityId;	/* WorkItemId Check intentionally left for refer case*/ 
			END IF; 

			v_TotPrTimeTillNow := DBTotalPrTime + v_TotPrTimeTillNow; 

			IF(DBActionId = 2 OR DBActionId = 27 OR DBActionId = 3 OR DBActionId = 5 OR DBActionId = 28 OR DBActionId = 45) THEN 
				DELETE FROM WFReportDataTable  
				WHERE	processInstanceId = DBProcessInstance 
				AND processdefid = DBProcessdefId 
				AND activityid = DBActivityId; /* WorkItemId Check intentionally left for refer case*/ 
			END IF; 

			IF(in_DBDelayTime > 0) THEN 
				in_DBWKInDelay := 1; 
			ELSE 
				in_DBWKInDelay := 0; 
				in_DBDelayTime := 0; 
			END IF; 

			IF(DBActionId = 1 OR DBActionId = 2 OR DBActionId = 27) THEN
				v_wherestr := ''AND activityId = '' || TO_CHAR(v_DBActivityId, ''99999'') || '' and userid = '' ||  TO_CHAR(v_DBUserId, ''99999'') || '' and queueid = '' || TO_CHAR(v_DBQueueId, ''99999'');
			END IF;


			IF(DBActionId = 3 OR DBActionId = 5 OR DBActionId = 20) THEN
				v_wherestr := NULL;
				v_DBActivityId := 0;
				v_DBUserId := 0;
				v_DBQueueId := 0;
			END IF;

			IF(DBActionId = 4 OR DBActionId = 6) THEN
				v_wherestr := ''AND activityId = '' || TO_CHAR(v_DBActivityId, ''99999'') || '' and queueid = '' || TO_CHAR(v_DBQueueId, ''99999'');
				v_DBUserId := 0;
			END IF;

			IF(DBActionId = 9 OR DBActionId = 10) THEN
				v_fieldIdColumn := '', AssociatedFieldId '';
				v_fieldIdValue := '', '' || TO_CHAR(DBFieldId, ''99999'');
				v_wherestr := ''and activityId = '' ||  TO_CHAR(v_DBActivityId, ''99999'') || '' and AssociatedFieldId = '' ||  TO_CHAR(DBFieldId, ''99999'');
				v_DBUserId := 0;
				v_DBQueueId := 0;
			END IF;

			IF(DBActionId = 28) THEN
				v_wherestr := ''and activityId = '' ||  TO_CHAR(v_DBActivityId, ''99999'');
				v_DBUserId := 0;
				v_DBQueueId := 0;
			END IF;
			
			IF(DBActionId = 45) THEN
				v_wherestr := ''and activityId = '' ||  TO_CHAR(v_DBActivityId, ''99999'') || '' and userid = '' ||  TO_CHAR(v_DBUserId, ''99999'');
				v_DBQueueId := 0;
			END IF;

			v_ActionDateTimeStart := COALESCE(date_trunc(''hour'', TO_TIMESTAMP(v_DBActionDateTime, ''YYYY-MM-DD HH24:MI:SS'')), date_trunc(''hour'', CURRENT_TIMESTAMP));

			v_ActionDateTimeEnd := v_ActionDateTimeStart + interval ''1 hour''; 
	
			 UPDATE SummaryTable  
				  SET  
				   totalwicount = COALESCE(totalwicount, 0) + 1, 
				   totalduration = COALESCE(totalduration, 0) + DBTotalDuration, 
				   totalprocessingtime = COALESCE(totalprocessingtime, 0) + v_TotPrTimeTillNow, 
				   delaytime = COALESCE(delaytime, 0) + in_DBDelayTime, 
				   wkindelay = COALESCE(wkindelay, 0) + in_DBWKInDelay 
				  WHERE processdefid = DBProcessDefId      
				  AND activityid = v_DBActivityId      
				  AND userid = DBUserId    
				  AND actionid = DBActionId     
				  AND queueid = DBQueueId     
				  AND ActionDateTime >= v_ActionDateTimeStart AND ActionDateTime < v_ActionDateTimeEnd;

--			EXECUTE queryStr; 

			GET DIAGNOSTICS rowCount = ROW_COUNT;
			IF(rowCount = 0) THEN 
				INSERT into summarytable  
					(processdefid, activityid, queueid, userid, actionid,  
					actiondatetime, activityname, username, totalwicount, 
					totalduration, totalprocessingtime, delaytime, 
					wkindelay, reporttype, AssociatedFieldId) 
				values 
					(DBProcessDefId, v_DBActivityId, DBQueueId, DBUserId, DBActionId, 
					TO_TIMESTAMP(v_DBActionDateTime, ''YYYY-MM-DD HH24:MI:SS''), DBSummaryActName, DBUserName, 1, 
					DBTotalDuration, v_TotPrTimeTillNow, in_DBDelayTime, 
					in_DBWKInDelay, DBReportType, DBFieldId); 
				GET DIAGNOSTICS rowCount = ROW_COUNT;
				IF(rowCount <= 0) THEN 
--					ROLLBACK TO SAVEPOINT PROCESS; 
--						/* SRNo-1, WFMessageInProcessTable introduced  as Insert on MessageTable was taking time - Mandeep Kaur* / 
--					SAVEPOINT FAILED; 
						Insert Into WFFailedMessageTable  
							Select messageId, message, null, ''F'', CURRENT_TIMESTAMP, ActionDateTime 
							From WFMessageInProcessTable  
							Where MessageId = DBMsgId; 
						Delete From WFMessageInProcessTable Where MessageId = DBMsgId; 
--					COMMIT; 
					ret_messageId := 0; 
					ret_message := ''Insert Failed 4.''; 
					OPEN ResultSet FOR SELECT ret_messageId, ret_message;
					RETURN ResultSet; 					
				END IF; 
			END IF;
			IF(DBActionId  = 27 OR  DBActionId  = 2) THEN 
				UPDATE WFActivityReportTable 
					SET 
						totalwicount = COALESCE(totalwicount, 0) + 1, 
						totalduration = COALESCE(totalduration, 0) + DBTotalDuration, 
						totalprocessingtime = COALESCE(totalprocessingtime, 0) + DBTotalPrTime + v_TotPrTimeActivity 
					WHERE  
						processdefid = DBProcessDefId 
						AND activityid = DBActivityId 
						AND TO_TIMESTAMP(TO_CHAR(ActionDateTime, ''YYYY-MM-DD HH24''), ''YYYY-MM-DD HH24'') = 
						TO_TIMESTAMP(TO_CHAR(TO_TIMESTAMP(COALESCE(v_DBActionDateTime, TO_CHAR(CURRENT_TIMESTAMP, ''YYYY-MM-DD HH24:MI:SS'')), ''YYYY-MM-DD HH24:MI:SS''), ''YYYY-MM-DD HH24''), ''YYYY-MM-DD HH24''); 
					
					GET DIAGNOSTICS rowCount = ROW_COUNT;

				IF(rowCount = 0) THEN 
					INSERT INTO WFActivityReportTable(
								processdefid, activityid, activityname, actiondatetime, 
								totalwicount, totalduration, totalprocessingtime) 
							VALUES(
								DBProcessDefId, DBActivityId, DBActivityName, TO_TIMESTAMP(v_DBActionDateTime, ''YYYY-MM-DD HH24:MI:SS''), 
								DBTotalWiCount, DBTotalDuration, DBTotalPrTime + v_TotPrTimeActivity); 
							GET DIAGNOSTICS rowCount = ROW_COUNT;
							
					IF(rowCount <= 0) THEN 
--						ROLLBACK TO SAVEPOINT PROCESS; 
--							/* SRNo-1, WFMessageInProcessTable introduced  as Insert on MessageTable was taking time - Mandeep Kaur* / 
--						SAVEPOINT FAILED; 
							Insert Into WFFailedMessageTable  
								Select messageId, message, null, ''F'', CURRENT_TIMESTAMP, ActionDateTime 
								From WFMessageInProcessTable  
								Where MessageId = DBMsgId; 
							Delete From WFMessageInProcessTable Where MessageId = DBMsgId; 
--						COMMIT; 
						ret_messageId := 0; 
						ret_message := ''Insert Failed 4.1''; 
						OPEN ResultSet FOR SELECT ret_messageId, ret_message;
						RETURN ResultSet; 						
					END IF; 
				END IF; 
			END IF; 

			/* select ''Step - 6'', DBActionId , DBActionDateTime */ 
		END IF; 
	END IF;
	
	IF(DBDeleteFlag = 1) THEN 
		DELETE FROM WFMessageInProcessTable WHERE messageId = DBMsgId; 
		GET DIAGNOSTICS rowCount = ROW_COUNT;
		rst := rowCount; 
	ELSE 
		rst := 1; 
	END IF;

	ret_messageId := 1; 
	ret_message := ''SUCCESS''; 
	OPEN ResultSet FOR SELECT ret_messageId, ret_message;
	RETURN ResultSet; 	
END; 
'
LANGUAGE 'plpgsql';