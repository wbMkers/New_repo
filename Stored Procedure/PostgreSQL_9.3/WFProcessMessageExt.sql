/*__________________________________________________________________________________________________________________
			NEWGEN SOFTWARE TECHNOLOGIES LIMITED
____________________________________________________________________________________________________________________
	Group						: Genesis.
	Product / Project			: iBPS
	Module						: WorkFlow Server
	File Name					: WFProcessMessageExt.sql
	Author						: Sajid Khan
	Date written (DD/MM/YYYY)	: 16 May 2016
	Description					: This stored procedure is called from WFProcessMessage (WFInternal.java).
____________________________________________________________________________________________________________________
				CHANGE HISTORY
____________________________________________________________________________________________________________________

Date			Change By		Change Description (Bug No. (If Any))
10/03/2017      Sajid Khan             Bug 67568 - Deletion of Audit Logs after audit trail archieve.		
12/08/2020		Ashutosh Pandey	Bug 94054 - Optimization in Message Agent
_______________________________________________________________________________________________________________
___________________________________________________________________________________________________________________*/

CREATE OR REPLACE FUNCTION WFProcessMessageExt(
	DBActionId				INTEGER,
	DBUserId				INTEGER,
	DBProcessDefId			INTEGER,
	DBActivityId			INTEGER,
	DBQueueId				INTEGER,
	DBUserName				VARCHAR,
	DBActivityName			VARCHAR,
	DBSummaryActId			INTEGER,
	DBSummaryActName		VARCHAR,
	DBTotalWiCount			INTEGER,
	DBTotalDuration			INTEGER,	
	DBProcessInstance		VARCHAR, 
	DBFieldId				INTEGER, 
	DBFlag					INTEGER,
	DBWorkitemId			INTEGER,
	DBTotalPrTime			INTEGER,
	DBFieldName				VARCHAR,
	DBNewValue				VARCHAR,
	DBActionDateTime		VARCHAR,
	DBAssociatedDateTime	VARCHAR,
	DBDelayTime				INTEGER,
	DBWKInDelay				INTEGER,
	DBReportType			VARCHAR,
	DBMsgId					INT8, 
	DBUtilId				VARCHAR, 	
	DBDeleteFlag			INTEGER	,	/* 1 record to be deleted from wfmessageTable , 2 not to be deleted	;	 placed for case setAttribute(more than one in single message)	*/  
	DBProcessVariantId		INTEGER
) RETURNS REFCURSOR AS $$									
											
DECLARE 
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
	
	v_pos := STRPOS(DBActionDateTime,'.'); 
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
	
	If DBActionId = 20 OR DBActionId = 3 THEN 
		update wfaudittraildoctable set status = 'R'  Where processInstanceId = COALESCE(DBProcessInstance, '''') 
		AND workitemId = COALESCE(DBWorkitemId, 0); 		 
	End IF; 
	
	
	IF(DBFlag = 2 OR DBFlag = 3) THEN /*For insertion in SummaryTable*/
		IF(DBActionId = 8) THEN 
			UPDATE WFReportDataTable SET 
				TotalProcessingTime = totalprocessingtime + v_TotPrTimeTillNow 
			WHERE processInstanceId = DBProcessInstance 
			AND workitemId = DBWorkitemId 
			AND processdefid =  DBProcessdefId 
			AND activityid = DBActivityId 
			AND Userid = DBUserId AND processvariantId = DBProcessVariantId;

			GET DIAGNOSTICS rowCount = ROW_COUNT;
			IF(rowCount = 0) THEN  
				INSERT into WFReportDataTable  
					(processInstanceId, workitemId, processdefid, activityid, userid, totalprocessingtime,processvariantId) 
				values  
					(DBProcessInstance, DBWorkitemId, DBProcessDefId, DBActivityId, DBUserId, v_TotPrTimeTillNow,DBProcessVariantId); 
				GET DIAGNOSTICS rowCount = ROW_COUNT;  
				IF(rowCount <= 0) THEN  
						Insert Into WFFailedMessageTable  
							Select messageId, message, null, 'F', CURRENT_TIMESTAMP, ActionDateTime 
							From WFMessageTable  
							Where MessageId = DBMsgId; 
						Delete From WFMessageTable Where MessageId = DBMsgId; 
					ret_messageId := 0; 
					ret_message := 'Insert Failed 5.';
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
					AND Userid = DBUserId AND processvariantId = DBProcessVariantId; 
				IF(NOT FOUND) THEN
					v_TotPrTimeTillNow := 0; 
				END IF;

				SELECT INTO v_TotPrTimeActivity COALESCE(SUM(TotalProcessingTime), 0)
				FROM WFReportDataTable 
				WHERE	processInstanceId = DBProcessInstance 
				AND processdefid = DBProcessdefId 
				AND activityid = DBActivityId AND processvariantId = DBProcessVariantId;	/* WorkItemId Check intentionally left for refer case*/ 
			END IF; 

			v_TotPrTimeTillNow := DBTotalPrTime + v_TotPrTimeTillNow; 

			IF(DBActionId = 2 OR DBActionId = 27 OR DBActionId = 3 OR DBActionId = 5 OR DBActionId = 28 OR DBActionId = 45) THEN 
				DELETE FROM WFReportDataTable  
				WHERE	processInstanceId = DBProcessInstance 
				AND processdefid = DBProcessdefId 
				AND activityid = DBActivityId AND processvariantId = DBProcessVariantId; /* WorkItemId Check intentionally left for refer case*/ 
			END IF; 

			IF(in_DBDelayTime > 0) THEN 
				in_DBWKInDelay := 1; 
			ELSE 
				in_DBWKInDelay := 0; 
				in_DBDelayTime := 0; 
			END IF; 

			IF(DBActionId = 1 OR DBActionId = 2 OR DBActionId = 27) THEN
				v_wherestr := 'AND activityId = ' || TO_CHAR(v_DBActivityId, '99999') || ' and userid = ' ||  TO_CHAR(v_DBUserId, '99999') || ' and queueid = ' || TO_CHAR(v_DBQueueId, '99999');
			END IF;


			IF(DBActionId = 3 OR DBActionId = 5 OR DBActionId = 20) THEN
				v_wherestr := NULL;
				v_DBActivityId := 0;
				v_DBUserId := 0;
				v_DBQueueId := 0;
			END IF;

			IF(DBActionId = 4 OR DBActionId = 6) THEN
				v_wherestr := 'AND activityId = ' || TO_CHAR(v_DBActivityId, '99999') || ' and queueid = ' || TO_CHAR(v_DBQueueId, '99999');
				v_DBUserId := 0;
			END IF;

			IF(DBActionId = 9 OR DBActionId = 10) THEN
				v_fieldIdColumn := ', AssociatedFieldId ';
				v_fieldIdValue := ', ' || TO_CHAR(DBFieldId, '99999');
				v_wherestr := 'and activityId = ' ||  TO_CHAR(v_DBActivityId, '99999') || ' and AssociatedFieldId = ' ||  TO_CHAR(DBFieldId, '99999');
				v_DBUserId := 0;
				v_DBQueueId := 0;
			END IF;

			IF(DBActionId = 28) THEN
				v_wherestr := 'and activityId = ' ||  TO_CHAR(v_DBActivityId, '99999');
				v_DBUserId := 0;
				v_DBQueueId := 0;
			END IF;
			
			IF(DBActionId = 45) THEN
				v_wherestr := 'and activityId = ' ||  TO_CHAR(v_DBActivityId, '99999') || ' and userid = ' ||  TO_CHAR(v_DBUserId, '99999');
				v_DBQueueId := 0;
			END IF;

			--v_ActionDateTimeStart := COALESCE(date_trunc('hour', TO_TIMESTAMP(v_DBActionDateTime, 'YYYY-MM-DD HH24:MI:SS')), date_trunc('hour', CURRENT_TIMESTAMP));

			--v_ActionDateTimeEnd := v_ActionDateTimeStart + interval '1 hour'; 
			v_ActionDateTimeStart := TO_TIMESTAMP(TO_CHAR(TO_TIMESTAMP(COALESCE(v_DBActionDateTime, TO_CHAR(CURRENT_TIMESTAMP, 'YYYY-MM-DD HH24:MI:SS')), 'YYYY-MM-DD HH24:MI:SS'), 'YYYY-MM-DD HH24'), 'YYYY-MM-DD HH24'); 
	
			UPDATE SummaryTable  
				  SET  
				   totalwicount = COALESCE(totalwicount, 0) + 1, 
				   totalduration = COALESCE(totalduration, 0) + DBTotalDuration, 
				   totalprocessingtime = COALESCE(totalprocessingtime, 0) + v_TotPrTimeTillNow, 
				   delaytime = COALESCE(delaytime, 0) + in_DBDelayTime, 
				   wkindelay = COALESCE(wkindelay, 0) + in_DBWKInDelay 
				  WHERE processdefid = DBProcessDefId      
				  AND activityid = v_DBActivityId      
				  AND userid = v_DBUserId    
				  AND actionid = DBActionId     
				  AND queueid = v_DBQueueId     
				  AND ActionDateTime = v_ActionDateTimeStart AND  ProcessVariantId = DBProcessVariantId;


			GET DIAGNOSTICS rowCount = ROW_COUNT;
			IF(rowCount = 0) THEN 
				INSERT into summarytable  
					(processdefid, activityid, queueid, userid, actionid,  
					actiondatetime, activityname, username, totalwicount, 
					totalduration, totalprocessingtime, delaytime, 
					wkindelay, reporttype, AssociatedFieldId,ProcessVariantId) 
				values 
					(DBProcessDefId, v_DBActivityId, DBQueueId, DBUserId, DBActionId, 
					v_ActionDateTimeStart, DBActivityName, DBUserName, 1, 
					DBTotalDuration, v_TotPrTimeTillNow, in_DBDelayTime, 
					in_DBWKInDelay, DBReportType, DBFieldId,DBProcessVariantId); 
				GET DIAGNOSTICS rowCount = ROW_COUNT;
				IF(rowCount <= 0) THEN 
						Insert Into WFFailedMessageTable  
							Select messageId, message, null, 'F', CURRENT_TIMESTAMP, ActionDateTime 
							From WFMessageTable  
							Where MessageId = DBMsgId; 
						Delete From WFMessageTable Where MessageId = DBMsgId; 
					ret_messageId := 0; 
					ret_message := 'Insert Failed 4.'; 
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
						AND TO_TIMESTAMP(TO_CHAR(ActionDateTime, 'YYYY-MM-DD HH24'), 'YYYY-MM-DD HH24') = 
						TO_TIMESTAMP(TO_CHAR(TO_TIMESTAMP(COALESCE(v_DBActionDateTime, TO_CHAR(CURRENT_TIMESTAMP, 'YYYY-MM-DD HH24:MI:SS')), 'YYYY-MM-DD HH24:MI:SS'), 'YYYY-MM-DD HH24'), 'YYYY-MM-DD HH24'); 
					
					GET DIAGNOSTICS rowCount = ROW_COUNT;

				IF(rowCount = 0) THEN 
					INSERT INTO WFActivityReportTable(
								processdefid, activityid, activityname, actiondatetime, 
								totalwicount, totalduration, totalprocessingtime) 
							VALUES(
								DBProcessDefId, DBActivityId, DBActivityName, TO_TIMESTAMP(v_DBActionDateTime, 'YYYY-MM-DD HH24:MI:SS'), 
								DBTotalWiCount, DBTotalDuration, DBTotalPrTime + v_TotPrTimeActivity); 
							GET DIAGNOSTICS rowCount = ROW_COUNT;
							
					IF(rowCount <= 0) THEN 
							Insert Into WFFailedMessageTable  
								Select messageId, message, null, 'F', CURRENT_TIMESTAMP, ActionDateTime 
								From WFMessageTable  
								Where MessageId = DBMsgId; 
							Delete From WFMessageTable Where MessageId = DBMsgId; 

						ret_messageId := 0; 
						ret_message := 'Insert Failed 4.1'; 
						OPEN ResultSet FOR SELECT ret_messageId, ret_message;
						RETURN ResultSet; 						
					END IF; 
				END IF; 
			END IF; 

			/* select 'Step - 6'', DBActionId , DBActionDateTime */ 
		END IF; 
	END IF;
	
	IF(DBDeleteFlag = 1) THEN 
		DELETE FROM WFMessageTable WHERE messageId = DBMsgId; 
		GET DIAGNOSTICS rowCount = ROW_COUNT;
		rst := rowCount; 
	ELSE 
		rst := 1; 
	END IF;

	ret_messageId := 1; 
	ret_message := 'SUCCESS'; 
	OPEN ResultSet FOR SELECT ret_messageId, ret_message;
	RETURN ResultSet; 	
END; 

$$LANGUAGE plpgsql;