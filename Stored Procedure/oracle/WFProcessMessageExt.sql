/*__________________________________________________________________________________________________________________
			NEWGEN SOFTWARE TECHNOLOGIES LIMITED
____________________________________________________________________________________________________________________
	Group				: Application – Products
	Product / Project		: WorkFlow 5.0
	Module				: Transaction Server
	File Name			: WFProcessMessageExt.sql
	Author				: Ruhi Hira
	Date written (DD/MM/YYYY)	: 02/08/2004
	Description			: This stored procedure is called from WFProcessNextMessage (WFInternal.java).

____________________________________________________________________________________________________________________
				CHANGE HISTORY
____________________________________________________________________________________________________________________

Date			Change By		Change Description (Bug No. (If Any))
29/09/2004		Ruhi Hira		ActionId to be inserted should be 27 in case of 8 in SummaryTable.
29/09/2004		Ruhi Hira		- No need to insert into QueueHistoryTable in case of actionId 25.
						- AssociatedFieldId inserted in case of actionId 9 and 10.
09/11/2004		Krishan			DelayTime report bug for ProcessInstance rectified.
02/06/2005		Harmeet Kaur	        Bug No WFS_6_013.
05/08/2005		Mandeep Kaur	        SRNo-1(Bug Ref No WFS_5_047)
08/08/2005		Mandeep Kaur		SRNo-2(Bug REf No WFS_5_053)
18/08/2005		Ruhi Hira		SrNo-3.
16/05/2006		Ashish Mangla		Support for Hourly Report
30/01/2007		Ruhi Hira		Bugzilla Id 460.
08/02/2007		Varun Bhansaly		Bugzilla Id 74 (Inconsistency in date-time)
02/03/2007		Ashish Mangla		Bugzilla Bug 484 (TO_NCHAR replaced with TO_CHAR)
15/03/2007		Ashish Mangla		Processing time should be added in summrytable / new table WFActivitytyReportTable when WI completes 
						- Till that time keep the processing time spent by a user in a separate table 
							that to be deleted when the WI completes
17/05/2013	Shweta Singhal	Process Variant Support Changes
19/06/2013		Sajid Khan		Bug 39903 - Summary table queries and indexes to be modified 		
23/12/2013		Sajid Khan		Message Agent Optimization. 		
10/08/2015		Anwar Danish	PRD Bug 51267 merged - Handling of new ActionIds and optimize usage of current ActionIds regarding OmniFlow Audit Logging functionality.				
10/03/2017                 Sajid Khan             Bug 67568 - Deletion of Audit Logs after audit trail archieve.			
21/04/2017      Kumar Kimil     Bug 62174- Total Processing time not recorded correctly for unlock workitem in WFReportDataTable in Oracle
31/10/2017      Kumar Kimil     Bug 72787 - AuditTrail logs are not generating in case of DMS
12/08/2020		Ashutosh Pandey	Bug 94054 - Optimization in Message Agent
___________________________________________________________________________________________________________________*/

CREATE OR REPLACE PROCEDURE WFProcessMessageExt ( 
	DBActionId		INT, 
	DBUserId		INT, 
	DBProcessDefId		INT, 
	DBActivityId		INT, 
	DBQueueId		INT, 
	DBUserName		NVARCHAR2, 
	DBActivityName		NVARCHAR2, 
	DBSummaryActId		INT,
	DBSummaryActName	NVARCHAR2, 
	DBTotalWiCount		INT, 
	temp_DBTotalDuration		INT, 
	DBProcessInstance	NVARCHAR2, 
	DBFieldId		INT, 
	DBFlag			INT, 
	DBWorkitemId		INT, 
	temp_DBTotalPrTime		INT, 
	DBFieldName		NVARCHAR2, 
	DBNewValue		NVARCHAR2, 
	DBActionDateTime	NVARCHAR2, 
	DBAssociatedDateTime	NVARCHAR2,      
	DBDelayTime		INT, 
	DBWKInDelay		INT, 
	DBReportType		NVARCHAR2, 
	tempmsgId			INT, 
	UtilId			NVARCHAR2, 
	deleteFlag		INT,		/* 1 record to be deleted from wfmessageTable , 2 not to be deleted	*/ 
						/* placed for case setAttribute(more than one in single message)	*/ 
	DBProcessVariantId 	INT,						/*Process Variant Support*/
	ret_messageId		OUT INT, 
	ret_message		OUT NVARCHAR2        /*WFS_6_013*/ 
) 
AS 
	v_pos			INT;
	messId_temp		INT; 
	messageIdStr		NVARCHAR2(8000); 
	cntr			INT; 
	firstMessageId		INT; 
	cnt			INT; 
	rcnt			INT; 
	rst			INT; 
	MessTable_Cursor	INT; 
	ret			INT; 
	rowcount		INT; 
	in_DBWKInDelay		INT; 
	queryStr		VARCHAR2(8000); 
	v_tempUserId		INT; 
	v_divertUserId		INT; 
	v_divertUserName	VARCHAR2(100); 
	DivertUser_Cursor	INT; 
	v_DBFieldName		NVARCHAR2(2000); 
	in_DBDelayTime		INT; 
	v_TotPrTimeTillNow	INT; 
	v_TotPrTimeActivity	INT; 
	/* Added By Varun Bhansaly 0n 08/02/2007 for Bugzilla Bug 74 */
	v_actionDateTime	NVARCHAR2(50);
	v_DBActionDateTime	NVARCHAR2(50);
	v_fieldIdColumn		NVARCHAR2(50);
	v_fieldIdValue		NVARCHAR2(50);
	v_wherestr		NVARCHAR2(150);
	v_DBActivityId		INT;
	v_DBUserId		INT;
	v_DBQueueId		INT;	
	v_DBAssociatedDateTime	DATE;
	msgId			INT;
	v_quoteChar 			CHAR(1);
	DBTotalDuration		INT;
	DBTotalPrTime		INT;
BEGIN 
	v_TotPrTimeTillNow	:= 0; 
	in_DBWKInDelay		:= DBWKInDelay; 
	v_DBFieldName		:= DBFieldName; 
	in_DBDelayTime		:= DBDelayTime; 
	v_quoteChar := CHR(39);
	/* Added By Varun Bhansaly 0n 08/02/2007 for Bugzilla Bug 74 */
	v_pos			:= INSTR(DBActionDateTime,'.'); 
	IF v_pos > 0 THEN 
		v_DBActionDateTime := SUBSTR(DBActionDateTime, 1, v_pos-1); 
	ELSE
		v_DBActionDateTime := DBActionDateTime; 
	END IF;

	IF(tempmsgId is NOT NULL) THEN
		msgId:=CAST(REPLACE(tempmsgId,v_quoteChar,v_quoteChar||v_quoteChar) AS INTEGER);
	END IF;
	
	IF(temp_DBTotalDuration is NOT NULL) THEN
		DBTotalDuration:=CAST(REPLACE(temp_DBTotalDuration,v_quoteChar,v_quoteChar||v_quoteChar) AS INTEGER);
	END IF;
	IF(temp_DBTotalPrTime is NOT NULL) THEN
		DBTotalPrTime:=CAST(REPLACE(temp_DBTotalPrTime,v_quoteChar,v_quoteChar||v_quoteChar) AS INTEGER);
	END IF;
	
	v_DBActivityId := DBSummaryActId;
	v_DBUserId := DBUserId;
	v_DBQueueId := DBQueueId;
	v_wherestr := NULL;
	v_fieldIdColumn := '''';
	v_fieldIdValue := '''';

      /*

	  DBFlag = 1 entry Only in currentroutelogtable
	 DBFlag = 2 entry only in summaryTable
	 DBFlag = 3 entry in both currentRouteLogTable and SummaryTable
	
	*/SAVEPOINT PROCESS;/*


	IF DBFlag = 1 OR DBFlag = 3 THEN For insertion in currentRouteLogTable
		IF DBAssociatedDateTime IS NOT NULL THEN
			v_pos := INSTR(DBAssociatedDateTime,'.'); 
			IF v_pos > 0 THEN 
				v_DBAssociatedDateTime := TO_DATE(SUBSTR(DBAssociatedDateTime, 1, v_pos-1), 'YYYY-MM-DD HH24:MI:SS');
			ELSE
				v_DBAssociatedDateTime := TO_DATE(DBAssociatedDateTime, 'YYYY-MM-DD HH24:MI:SS');
			END IF;
		END IF;

		Insert into WFCurrentRouteLogTable  
			(LogId, ProcessDefId, ActivityId, ProcessInstanceId, WorkItemId, UserId,  
			ActionId, ActionDateTime, AssociatedDateTime, AssociatedFieldId, AssociatedFieldName, 
			ActivityName, UserName, NewValue, QueueId, ProcessVariantId) 
		values (LOGID.NEXTVAL, DBProcessDefId, DBActivityId, DBProcessInstance, DBWorkitemId, DBUserId, 
			DBActionId, TO_DATE(v_DBActionDateTime, 'YYYY-MM-DD HH24:MI:SS'), v_DBAssociatedDateTime, DBFieldId, v_DBFieldName, 
			DBActivityName, DBUserName, DBNewValue, DBQueueId, DBProcessVariantId); Process Variant Support
		rowcount := SQL%ROWCOUNT; 
		IF rowcount <= 0 THEN 
			ROLLBACK TO SAVEPOINT PROCESS; 
		 SRNo-1, WFMessageInProcessTable introduced as Insert on MessageTable was taking time - Mandeep Kaur 
			SAVEPOINT FAILED; 
				Insert Into WFFailedMessageTable  
					Select messageId, message, null, 'F', sysDate, ActionDateTime 
					From WFMessageInProcessTable 
					Where MessageId = msgid; 
				Delete From WFMessageInProcessTable Where MessageId = msgid; 
			COMMIT; 
			ret_messageId := 0; 
			ret_message := 'Insert Failed 1.'; 
			RETURN; 
		END IF; 
		SRNo-2  Code for moving data to history tables removed.-By Mandeep Kaur 
	END IF; */

	If DBActionId = 20 OR DBActionId = 3 THEN 
		update wfaudittraildoctable set status = 'R'  
		Where processInstanceId = nvl(DBProcessInstance, '''') 
		AND workitemId = nvl(DBWorkitemId, 0); 		 
	End IF; 
	
	IF DBFlag = 2 OR DBFlag = 3 THEN /*For insertion in SummaryTable*/
	v_TotPrTimeTillNow := DBTotalPrTime + v_TotPrTimeTillNow; 
		IF DBActionId = 8 THEN 
			UPDATE WFReportDataTable SET 
				TotalProcessingTime = totalprocessingtime + v_TotPrTimeTillNow 
			WHERE processInstanceId = DBProcessInstance 
			AND workitemId = DBWorkitemId 
			AND processdefid =  DBProcessdefId 
			AND activityid = DBActivityId 
			AND Userid = DBUserId
			AND processvariantId = DBProcessVariantId;/*Process Variant Support*/

			rowcount := SQL%ROWCOUNT; 
			IF rowcount = 0 THEN  
				INSERT into WFReportDataTable  
					(processInstanceId, workitemId, processdefid, activityid, userid, totalprocessingtime, processvariantId) 
				values  
					(DBProcessInstance, DBWorkitemId, DBProcessDefId, DBActivityId, DBUserId, v_TotPrTimeTillNow, DBProcessVariantId); /*Process Variant Support*/
				rowcount := SQL%ROWCOUNT;  
				IF rowcount <= 0 THEN  
					ROLLBACK TO SAVEPOINT PROCESS;  
					SAVEPOINT FAILED;  
						Insert Into WFFailedMessageTable  
							Select messageId, message, null, 'F', sysDate, ActionDateTime 
							From WFMessageTable  
							Where MessageId = msgid; 
						Delete From WFMessageTable Where MessageId = msgid; 
					COMMIT; 
					ret_messageId := 0; 
					ret_message := 'Insert Failed 5.'; 
					RETURN; 
				END IF; 
			END IF; 
		ELSE
			IF DBActionId = 2 OR DBActionId = 27 THEN 
				BEGIN 
					SELECT TotalProcessingTime INTO v_TotPrTimeTillNow from WFReportDataTable 
					WHERE processInstanceId = DBProcessInstance 
						AND workitemId = DBWorkitemId 
						AND processdefid =  DBProcessdefId 
						AND activityid = DBActivityId 
						AND Userid = DBUserId
						AND processvariantId = DBProcessVariantId;						/*Process Variant Support*/
				EXCEPTION 
					WHEN NO_DATA_FOUND THEN  
						v_TotPrTimeTillNow := 0; 
				END; 

				SELECT NVL(SUM(TotalProcessingTime),0) INTO v_TotPrTimeActivity from WFReportDataTable 
				WHERE processInstanceId = DBProcessInstance 
					AND processdefid =  DBProcessdefId 
					AND activityid = DBActivityId	/* WorkItemId Check intentionally left for refer case*/ 
					AND processvariantId = DBProcessVariantId;						/*Process Variant Support*/
			END IF; 

			v_TotPrTimeTillNow := DBTotalPrTime + v_TotPrTimeTillNow; 

			IF DBActionId = 2 OR DBActionId = 27 OR DBActionId = 3 OR DBActionId = 5 OR DBActionId = 28 OR DBActionId = 45 THEN 
				DELETE FROM WFReportDataTable  
				WHERE processInstanceId = DBProcessInstance 
					AND processdefid =  DBProcessdefId 
					AND activityid = DBActivityId /* WorkItemId Check intentionally left for refer case*/ 
					AND processvariantId = DBProcessVariantId;/*Process Variant Support*/
			END IF; 

			IF in_DBDelayTime > 0 THEN 
				in_DBWKInDelay := 1; 
			ELSE 
				in_DBWKInDelay := 0; 
				in_DBDelayTime := 0; 
			END IF; 

			IF DBActionId = 1 OR DBActionId = 2 OR DBActionId = 27 THEN
				v_wherestr := 'AND activityId = ' || TO_CHAR(v_DBActivityId) || ' and userid = ' ||  TO_CHAR(v_DBUserId) || ' and queueid = ' || TO_CHAR(v_DBQueueId);
			END IF;


			IF DBActionId = 3 OR DBActionId = 5 OR DBActionId = 20 THEN
				v_wherestr := NULL;
				v_DBActivityId := 0;
				v_DBUserId := 0;
				v_DBQueueId := 0;
			END IF;

			IF DBActionId = 4 OR DBActionId = 6 THEN
				v_wherestr := 'AND activityId = ' || TO_CHAR(v_DBActivityId) || ' and queueid = ' || TO_CHAR(v_DBQueueId);
				v_DBUserId := 0;
			END IF;

			IF DBActionId = 9 OR DBActionId = 10 THEN
				v_fieldIdColumn := ', AssociatedFieldId ';
				v_fieldIdValue := ', ' || TO_CHAR(DBFieldId);
				v_wherestr := 'and activityId = ' ||  TO_CHAR(v_DBActivityId) || ' and AssociatedFieldId = ' ||  TO_CHAR(DBFieldId);
				v_DBUserId := 0;
				v_DBQueueId := 0;
			END IF;

			IF DBActionId = 28 THEN
				v_wherestr := 'and activityId = ' ||  TO_CHAR(v_DBActivityId);
				v_DBUserId := 0;
				v_DBQueueId := 0;
			END IF;
			
			IF DBActionId = 45 THEN
				v_wherestr := 'and activityId = ' ||  TO_CHAR(v_DBActivityId) || ' and userid = ' ||  TO_CHAR(v_DBUserId);
				v_DBQueueId := 0;
			END IF;
/*	Bug 39903 - Summary table queries and indexes to be modified */

			queryStr := 'UPDATE summarytable set' ||
				' totalwicount = nvl(totalwicount, 0) + 1 ' ||
				', totalduration = nvl(totalduration, 0) + :1' ||
				', totalprocessingtime = nvl(totalprocessingtime, 0) + :2' ||
				', delaytime = nvl(delaytime, 0) + :3' ||
				', wkindelay = nvl(wkindelay, 0) + :4' ||
				' where processdefid = :5' || 
				' and actionid = :6' ||
				' and actiondatetime = ' ||
				' TO_DATE(TO_CHAR(TO_DATE(coalesce(TO_CHAR(:7), TO_CHAR(sysDate, ''YYYY-MM-DD HH24:MI:SS'')), ''YYYY-MM-DD HH24:MI:SS''), ''YYYY-MM-DD HH24''), ''YYYY-MM-DD HH24'') ' ||
				v_wherestr ||
				' And ProcessVariantId = ' || DBProcessVariantId ||'';/*Process Variant Support*/


			EXECUTE IMMEDIATE queryStr USING DBTotalDuration, v_TotPrTimeTillNow, in_DBDelayTime, in_DBWKInDelay, DBProcessDefId, DBActionId, v_DBActionDateTime;

			rowcount := SQL%ROWCOUNT; 
			IF rowcount = 0 THEN 
				INSERT into summarytable  
					(processdefid, activityid, queueid, userid, actionid,  
					actiondatetime, activityname, username, totalwicount, 
					totalduration, totalprocessingtime, delaytime, 
					wkindelay, reporttype, AssociatedFieldId, ProcessVariantId) 
				values 
					(DBProcessDefId, v_DBActivityId, DBQueueId, DBUserId, DBActionId, 
					TO_DATE(TO_CHAR(TO_DATE(v_DBActionDateTime, 'YYYY-MM-DD HH24:MI:SS'),'YYYY-MM-DD HH24'),'YYYY-MM-DD HH24'), DBSummaryActName, DBUserName, 1, 
					DBTotalDuration, v_TotPrTimeTillNow, in_DBDelayTime, 
					in_DBWKInDelay, DBReportType, DBFieldId, DBProcessVariantId); /*Process Variant Support*/
				rowcount := SQL%ROWCOUNT; 
				IF rowcount <= 0 THEN 
					ROLLBACK TO SAVEPOINT PROCESS; 
--						/* SRNo-1, WFMessageInProcessTable introduced  as Insert on MessageTable was taking time - Mandeep Kaur* / 
					SAVEPOINT FAILED; 
						Insert Into WFFailedMessageTable  
							Select messageId, message, null, 'F', sysDate, ActionDateTime 
							From WFMessageTable  
							Where MessageId = msgid; 
						Delete From WFMessageTable Where MessageId = msgid; 
					COMMIT; 
					ret_messageId := 0; 
					ret_message := 'Insert Failed 4.'; 
					RETURN; 
				END IF; 
			END IF;
			IF DBActionId  = 27 OR  DBActionId  = 2 THEN 
				UPDATE WFActivityReportTable 
				SET 
					totalwicount = nvl(totalwicount, 0) + 1, 
					totalduration = nvl(totalduration, 0) + DBTotalDuration, 
					totalprocessingtime = nvl(totalprocessingtime, 0) + DBTotalPrTime + v_TotPrTimeActivity 
				WHERE  
					processdefid = DBProcessDefId 
					AND activityid = DBActivityId 
					AND TO_DATE(TO_CHAR(ActionDateTime, 'YYYY-MM-DD HH24'), 'YYYY-MM-DD HH24') = 
					TO_DATE(TO_CHAR(TO_DATE(coalesce(TO_CHAR(v_DBActionDateTime), TO_CHAR(sysDate, 'YYYY-MM-DD HH24:MI:SS')), 'YYYY-MM-DD HH24:MI:SS'), 'YYYY-MM-DD HH24'), 'YYYY-MM-DD HH24'); 
				rowcount := SQL%ROWCOUNT; 

				IF rowcount = 0 THEN 
					INSERT into WFActivityReportTable 
						(processdefid, activityid, activityname, actiondatetime, 
						totalwicount, totalduration, totalprocessingtime) 
					VALUES 
						(DBProcessDefId, DBActivityId, DBActivityName, TO_DATE(v_DBActionDateTime, 'YYYY-MM-DD HH24:MI:SS'), 
						1, DBTotalDuration, DBTotalPrTime + v_TotPrTimeActivity); 
					rowcount := SQL%ROWCOUNT; 
					IF rowcount <= 0 THEN 
						ROLLBACK TO SAVEPOINT PROCESS; 
--							/* SRNo-1, WFMessageInProcessTable introduced  as Insert on MessageTable was taking time - Mandeep Kaur */ 
						SAVEPOINT FAILED; 
							Insert Into WFFailedMessageTable  
								Select messageId, message, null, 'F', sysDate, ActionDateTime 
								From WFMessageTable  
								Where MessageId = msgid; 
							Delete From WFMessageTable Where MessageId = msgid; 
						COMMIT; 
						ret_messageId := 0; 
						ret_message := 'Insert Failed 4.1'; 
						RETURN; 
					END IF; 
				END IF; 
			END IF; 

			/* select 'Step - 6', DBActionId , DBActionDateTime */ 
		END IF; 
	END IF;



	IF deleteFlag = 1 THEN 
		/*SRNo-1, WFMessageInProcessTable introduced as Insert on MessageTable was taking time- Mandeep Kaur*/ 
		Delete From WFMessageTable where messageId = msgId; 
		rowcount := SQL%ROWCOUNT;

		If rowcount <= 0 THEN 
			ROLLBACK TO SAVEPOINT PROCESS; 	
		End If;
		
		rst := rowcount; 
	ELSE 
		rst := 1; 
	END IF; 

	Commit; 
	ret_messageId := 1; 
	ret_message := 'SUCCESS'; 
	
	EXCEPTION WHEN OTHERS THEN 	
			ROLLBACK TO SAVEPOINT PROCESS; 
END;