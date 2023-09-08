/*----------------------------------------------------------------------------------------------------
		NEWGEN SOFTWARE TECHNOLOGIES LIMITED
	Group				: Genesis
	Product / Project	: OmniFlow 9.0
	Module				: Transaction Server
	File Name			: WFGenerateLog.sql
	Author				: Sweta Bansal
	Date written (DD/MM/YYYY)	: Aug 27th 2014
	Description			: Purpose of this stored procedure is to perform auditing(i.e. to prepare logging message based on the cabinet and then insert the same into WFMessageTable which will be further processed by Message agent to generate the history).
						  Bug 47853 - Optimization in Expiry Utility to enhance its Performance.
		
	Purpose of the script is as follows : 
		1. Prepare the logging message based on the cabinet(i.e. if WFCurrentRouteLogTable is present in the cabinet then message prepared will be diferent than that when CurrentRouteLogTable will be present in the cabinet).
		2. And then insert the message into WFMessageTable which can be processed by Message agent so that proper auditing can be performed.
		
------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------
				CHANGE HISTORY
------------------------------------------------------------------------------------------------------

Date			Change By		Change Description (Bug No. (If Any))

------------------------------------------------------------------------------------------------------
27/08/2014		Sweta Bansal	Bug 47853 - Optimization in Expiry Utility to enhance its Performance.
//17/06/2016    Kahkeshan		Bug 62323 - History to be made on target cabinet for CTS Archive
16/04/2018		Jyoti Gupta		Bug 74348 - Support for fetching history after the data has been migrated from WFHistoryRouteLogTable to a backup table
23/07/2019		Ravi Ranjan Kumar Bug 85705 - Write SP for fetching next item for utilities
05/06/2023		shubham srivastava Bug 127756 - Three column has been added in WFCurrentRouteLogTable, ProcessingTime ,TAT & DelayTime .
----------------------------------------------------------------------------------------------------*/

CREATE OR REPLACE PROCEDURE WFGenerateLog
(
v_ActionId INTEGER,
v_UserId INTEGER,
v_ProcessDefId INTEGER,
v_ActivityId INTEGER,
v_QueueId INTEGER,
temp_v_UserName NVARCHAR2,
temp_v_ActivityName NVARCHAR2,
v_TotalDuration NUMBER,
temp_v_ProcessInstanceId NVARCHAR2,
v_FieldId INTEGER,
temp_v_FieldName NVARCHAR2,
v_WorkItemId INTEGER,
v_TotalPrTime INTEGER,
v_DelayTime INTEGER,
v_MainCode OUT INTEGER,
v_isReport				VARCHAR2,
v_ProcessVariantId INTEGER,
v_TaskId 		INTEGER,
v_subTaskId 		INTEGER,
temp_v_URN 			NVARCHAR2,
temp_v_NewValue 			NVARCHAR2,
temp_v_AssociatedDateTime NVARCHAR2,
v_tarHisLog				NVARCHAR2,
v_targetCabinet			VARCHAR2
)
AS
	v_QueryStr1			VARCHAR2(8000);
	v_HistoryTableName  VARCHAR2(8000);
	v_insertTarStr      VARCHAR2(8000);	
	v_seqRootLogId		INTEGER;
	v_ProcessInstanceId  NVARCHAR2(80);
	v_ActivityName		 NVARCHAR2(80);
	v_FieldName          NVARCHAR2(4000);
	v_UserName			 NVARCHAR2(130);
	v_URN				NVARCHAR2(100);
	v_NewValue          NVARCHAR2(4000);
	v_quoteChar 			CHAR(1);
	v_AssociatedDateTime NVARCHAR2(80);
	v_TotPrTime			INTEGER;
	v_PrTimeTillNow		INTEGER;
BEGIN
	v_quoteChar := CHR(39);
	v_MainCode := 0;
	v_HistoryTableName := 'WFCURRENTROUTELOGTABLE';
	v_insertTarStr := '';
	
	BEGIN
		IF(v_tarHisLog = 'Y' AND v_targetCabinet IS NOT NULL )THEN
			v_HistoryTableName := 'WFHISTORYROUTELOGTABLE';
			--v_insertTarStr := ' '' ' || v_targetCabinet || '.' || ' '' ';
			v_insertTarStr :=  TRIM(v_targetCabinet) || '.' ;
		END IF;
	EXCEPTION
		WHEN OTHERS THEN 
		v_HistoryTableName := 'WFCURRENTROUTELOGTABLE'; 
		v_insertTarStr := '';
	END;
	
	/*	
	v_NewValue:=REPLACE(temp_v_NewValue,v_quoteChar,v_quoteChar||v_quoteChar);
	v_NewValue:=REPLACE(v_NewValue,v_quoteChar||v_quoteChar,v_quoteChar);
	
	v_URN:=REPLACE(temp_v_URN,v_quoteChar,v_quoteChar||v_quoteChar);
	v_URN:=REPLACE(v_URN,v_quoteChar||v_quoteChar,v_quoteChar);
	
	v_ProcessInstanceId:=REPLACE(temp_v_ProcessInstanceId,v_quoteChar,v_quoteChar||v_quoteChar);
	v_ProcessInstanceId:=REPLACE(v_ProcessInstanceId,v_quoteChar||v_quoteChar,v_quoteChar);
	
	v_ActivityName:=REPLACE(temp_v_ActivityName,v_quoteChar,v_quoteChar||v_quoteChar);
	v_ActivityName:=REPLACE(v_ActivityName,v_quoteChar||v_quoteChar,v_quoteChar);
	
	v_FieldName:=REPLACE(temp_v_FieldName,v_quoteChar,v_quoteChar||v_quoteChar);
	v_FieldName:=REPLACE(v_FieldName,v_quoteChar||v_quoteChar,v_quoteChar);
	
	v_UserName:=REPLACE(temp_v_UserName,v_quoteChar,v_quoteChar||v_quoteChar);
	v_UserName:=REPLACE(v_UserName,v_quoteChar||v_quoteChar,v_quoteChar);
	*/
	
	IF(temp_v_NewValue is NOT NULL) THEN
		SELECT sys.DBMS_ASSERT.noop(temp_v_NewValue) into v_NewValue FROM dual;
	END IF;
	IF(temp_v_URN is NOT NULL) THEN
		SELECT sys.DBMS_ASSERT.noop(temp_v_URN) into v_URN FROM dual;
	END IF;
	IF(temp_v_ProcessInstanceId is NOT NULL) THEN
		SELECT sys.DBMS_ASSERT.noop(temp_v_ProcessInstanceId) into v_ProcessInstanceId FROM dual;
	END IF;
	IF(temp_v_ActivityName is NOT NULL) THEN
		SELECT sys.DBMS_ASSERT.noop(temp_v_ActivityName) into v_ActivityName FROM dual;
	END IF;
	IF(temp_v_FieldName is NOT NULL) THEN
		SELECT sys.DBMS_ASSERT.noop(temp_v_FieldName) into v_FieldName FROM dual;
	END IF;
	IF(temp_v_UserName is NOT NULL) THEN
		SELECT sys.DBMS_ASSERT.noop(temp_v_UserName) into v_UserName FROM dual;
	END IF;
	IF(temp_v_AssociatedDateTime is NOT NULL) THEN
		SELECT sys.DBMS_ASSERT.noop(temp_v_AssociatedDateTime) into v_AssociatedDateTime FROM dual;
	END IF;

	IF(v_ActionId IS NOT NULL AND v_ActionId > 0) THEN
		IF((v_ActionId = 1 OR v_ActionId = 2 OR v_ActionId = 3 OR v_ActionId = 4 OR v_ActionId = 5 OR v_ActionId = 6 OR v_ActionId = 8 OR v_ActionId = 9 OR v_ActionId = 10 OR v_ActionId = 20 OR v_ActionId = 27 OR v_ActionId = 28 OR v_ActionId = 45 OR v_ActionId = 112) AND v_UserId < 10000000) THEN
		
		IF (v_ActionId =8) THEN
		BEGIN
		SELECT ProcessingTime INTO v_PrTimeTillNow FROM WFINSTRUMENTTABLE  WHERE ProcessInstanceId = v_ProcessInstanceId AND WorkitemId = v_WorkItemId;
		
		if (v_PrTimeTillNow is null) then
					begin
					v_PrTimeTillNow := 0;
					end;
					end if;
			v_PrTimeTillNow := v_PrTimeTillNow + v_TotalPrTime;
			
			UPDATE WFINSTRUMENTTABLE SET ProcessingTime = v_PrTimeTillNow WHERE ProcessInstanceId = v_ProcessInstanceId AND WorkitemId = v_WorkItemId;
			END;
		END if;
		
		
			
			IF(v_ActionId  = 2 OR  v_ActionId  = 27 OR  v_ActionId  = 28 OR  v_ActionId  = 45) THEN 
			SELECT ProcessingTime INTO v_TotPrTime FROM WFINSTRUMENTTABLE WHERE ProcessInstanceId = v_ProcessInstanceId AND WorkitemId = v_WorkItemId;
		END if;
		
				INSERT INTO WFMessageTable (MessageId, Message, Status, ActionDateTime) VALUES(seq_messageId.NEXTVAL, '<Message><ActionId>' || TO_CHAR(v_ActionId) || '</ActionId><UserId>' || TO_CHAR(NVL(v_UserId, '')) || '</UserId><ProcessDefId>' || TO_CHAR(NVL(v_ProcessDefId, '')) || '</ProcessDefId><ActivityId>' || TO_CHAR(NVL(v_ActivityId, '')) || '</ActivityId><QueueId>'|| TO_CHAR(NVL(v_QueueId, '')) || '</QueueId><UserName>' || NVL(v_UserName, '') || '</UserName><ActivityName>' || NVL(v_ActivityName, '') || '</ActivityName><TotalWiCount>1</TotalWiCount><TotalDuration>' || TO_CHAR(NVL(v_TotalDuration, 0)) || '</TotalDuration><ActionDateTime>' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS') || '</ActionDateTime><ProcessInstance>' || NVL(v_ProcessInstanceId, '') || '</ProcessInstance><FieldId>' || TO_CHAR(NVL(v_FieldId, '')) || '</FieldId><FieldName>' || NVL(v_FieldName, '') || '</FieldName><WorkitemId>' || TO_CHAR(NVL(v_WorkItemId, '')) || '</WorkitemId><TotalPrTime>' || TO_CHAR(NVL(v_TotPrTime, 0)) || '</TotalPrTime><DelayTime>' || TO_CHAR(NVL(v_DelayTime, 0)) || '</DelayTime><WKInDelay>0</WKInDelay><ReportType>D</ReportType><LoggingFlag>L3</LoggingFlag></Message>', N'N', SYSDATE);
		END IF;

		Execute IMMEDIATE ('Select '||v_insertTarStr ||'seq_rootlogid.NEXTVAL FROM DUAL') INTO v_seqRootLogId;

		v_QueryStr1 := 'Insert into '||v_insertTarStr || v_HistoryTableName || ' (LogId,ProcessDefId, ActivityId, ProcessInstanceId, WorkItemId, UserId, ActionId, ActionDateTime,AssociatedDateTime, AssociatedFieldId, AssociatedFieldName, ActivityName, UserName,NewValue, QueueId, ProcessVariantId, TaskId , subTaskId, URN, ProcessingTime, TAT, DelayTime) values('||v_seqRootLogId||','||v_ProcessDefId||','||v_ActivityId||','|| CHR(39)|| v_ProcessInstanceId || CHR(39) ||','||v_WorkItemId||','||TO_CHAR(NVL(v_UserId, 0))||','||v_ActionId||',SYSDATE,'|| 'to_date('||CHR(39)||v_AssociatedDateTime|| CHR(39)||','||  CHR(39)|| 'YYYY-MM-DD HH24:MI:SS' || CHR(39)||')' ||','||TO_CHAR(NVL(v_FieldId, 0)) ||','|| CHR(39)||NVL(v_FieldName, '')|| CHR(39)||','|| CHR(39)|| NVL(v_ActivityName, '')|| CHR(39)||','|| CHR(39) ||trim(to_nchar(NVL(v_UserName,'')))|| CHR(39) ||','|| CHR(39) ||trim(to_nchar(NVL(v_NewValue,'')))|| CHR(39) ||','||v_QueueId||','|| v_ProcessVariantId || ',' || v_TaskId || ','  || v_subTaskId || ',' || CHR(39) ||trim(to_nchar(NVL(v_URN,'')))|| CHR(39) || ','||TO_CHAR(NVL(v_TotPrTime, 0))||','||TO_CHAR(NVL(v_TotalDuration, 0))||','||TO_CHAR(NVL(v_DelayTime, 0))||')';

		Execute IMMEDIATE (v_QueryStr1);
	END IF;

End;
