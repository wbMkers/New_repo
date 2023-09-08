/*____________________________________________________________________________________________________
			NEWGEN SOFTWARE TECHNOLOGIES LIMITED
______________________________________________________________________________________________________
	Group						: Genesis
	Product / Project			: OmniFlow 10.x
	Module						: Transaction Server
	File Name					: WFBulkLockWorkitem.sql (ORACLE)
	Author						: Mohd Jaseem Ansari	
	Date written (DD/MM/YYYY)	: 12/01/2017
	Description					: Stored procedure to lock multiple workitems.
______________________________________________________________________________________________________
				CHANGE HISTORY
______________________________________________________________________________________________________
 Date		Change By		Change Description (Bug No. (If Any))
 24.07.2017		Mohnish Chopra	PRDP Bug 70097 - Error in BulkLock Worktiems when certain workitems provided in input xml are already locked 
____________________________________________________________________________________________________*/
CREATE OR REPLACE PROCEDURE WFBulkLockWorkitem (
	DBSessionId 		IN INT,
	DBQueueId 			IN INT,
	DBNoOfRecord 		IN NUMBER,
	DBBatchFlag 		IN CHAR,
	DBHistoryFlag 		IN CHAR,
	DBProcessInstaceIds IN NVARCHAR2,
	DBWorkItemIds 		IN  NVARCHAR2,
	DBMainCode 			OUT INT,  
	DBSubCode 			OUT INT,  
	DBNoOfFailedRecord 	OUT INT,  
	DBFailedProcessInstanceIds OUT NVARCHAR2,
	DBSubCodeList		OUT NVARCHAR2
)

AS

	sep_current_position_PId 	INT;
	sep_prev_postion_PId 		INT;
	sep_current_position_WId 	INT;
	sep_prev_postion_WId 		INT;
	v_ProcessInstaceId 			NVARCHAR2(60);
	v_WorkitemId 				NVARCHAR2(60);
	v_lockedById 					INT;
	v_lockedByName 				NVARCHAR2(60);
	v_ProcessDefId				INT;
	v_ActivityId				INT;
	v_QueueId					INT;
	v_ActivityName				NVARCHAR2(60);
	v_MainCode					INT;
	v_LockStatus				CHAR(1);
	v_userName					NVARCHAR2(60);
	
	FailedProcessInstanceId 	NVARCHAR2(4000);
	NoOfFailedProcessInstanceId INT;
	ErrorFlag 					CHAR(1);
	NoOfRecord 					INT;
	v_rowcount 					INT;
	v_DBStatus					INT; 
	V_DBQueuId          		INT;
	v_LockedTime				NVARCHAR2(50);
	v_FailedWISubCodeList  		NVARCHAR2(2000);
	
  

	
  BEGIN
  
	sep_prev_postion_PId :=1;
	sep_prev_postion_WId :=1;
	NoOfRecord:=DBNoOfRecord;
	NoOfFailedProcessInstanceId :=0 ;
	ErrorFlag :='N';
	v_LockedTime := TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS');
	
	/*Initializing output parameter*/
	DBMainCode := 0;
	DBSubCode := 0;
	DBNoOfFailedRecord := 0;
	DBFailedProcessInstanceIds := '';
	v_FailedWISubCodeList := '';
	
	 
	/*Check for validity of session */
	BEGIN 
		SELECT UserID, UserName INTO v_lockedById , v_userName  
		FROM WFSessionView, WFUserView 
		WHERE UserId = UserIndex AND SessionID = DBsessionId; 
		v_rowcount := SQL%ROWCOUNT;  
	EXCEPTION  
		WHEN NO_DATA_FOUND THEN 
		v_rowcount := 0; 
	END;
   
     
  IF (v_DBStatus <> 0 OR v_rowcount <= 0) THEN
		DBMainCode := 11; 
		DBSubCode := 0; 
		DBNoOfFailedRecord := 0;
		DBFailedProcessInstanceIds := '';
  RETURN; 	
  END IF;
 
  
  BEGIN 
	SELECT QueueID INTO V_DBQueuId FROM userqueuetable WHERE UserID = v_lockedById AND  QueueID = DBQueueId;
		v_rowcount := SQL%ROWCOUNT;  
		v_DBStatus := SQLCODE; 
	EXCEPTION  
	WHEN NO_DATA_FOUND THEN 
	v_rowcount := 0; 		
   END;
    
   
  IF (v_DBStatus <> 0 OR v_rowcount <= 0) THEN
		DBMainCode := 830; 
		DBSubCode := 0; 
		DBNoOfFailedRecord := 0;
		DBFailedProcessInstanceIds := '';  -- User has no rights on the queue.
  RETURN; 	
  END IF;

  	IF(DBBatchFlag = 'Y') THEN
	SAVEPOINT Batch_Transaction;
	END IF;
	WHILE NoOfRecord > 0 
			Loop
			BEGIN -- Beginning of While loop
				IF(DBBatchFlag = 'N') THEN
					SAVEPOINT Single_Transaction;
				END IF;
				 sep_current_position_PId := INSTR(DBProcessInstaceIds,',',sep_prev_postion_PId,1);	
				 sep_current_position_WId := INSTR(DBWorkItemIds, ',',sep_prev_postion_WId);
				 v_ProcessInstaceId := SUBSTR(DBProcessInstaceIds, sep_prev_postion_PId, sep_current_position_PId-sep_prev_postion_PId);
				 v_WorkitemId := SUBSTR(DBWorkItemIds, sep_prev_postion_WId, sep_current_position_WId-sep_prev_postion_WId);
				 sep_prev_postion_PId := sep_current_position_PId+1;		--for next iteration
				 sep_prev_postion_WId := sep_current_position_WId+1;
				 NoOfRecord := NoOfRecord-1;
				 BEGIN
				 SELECT ProcessDefId,ActivityId,ActivityName,Q_QueueId,LockStatus,LockedByName INTO v_ProcessDefId,v_ActivityId,v_ActivityName,v_QueueId,v_LockStatus,v_LockedByName from  wfinstrumenttable WHERE ProcessInstanceID = RTrim(LTrim(v_ProcessInstaceId)) AND WorkItemID = v_WorkitemId  AND RoutingStatus = 'N' FOR UPDATE;
				 
				v_rowcount := SQL%ROWCOUNT;  
				v_DBStatus := SQLCODE; 
				EXCEPTION  
				WHEN NO_DATA_FOUND THEN 
				v_rowcount := 0; 		
				END;
				
				IF (v_DBStatus <> 0 OR v_rowcount <= 0) THEN
				BEGIN
				ErrorFlag :=  'Y';
				DBMainCode := 400; 
				DBSubCode := 6; 
				DBNoOfFailedRecord := 0;
				DBFailedProcessInstanceIds := '';  -- User has no rights on the queue. 
				END;
				ELSE
				BEGIN
					IF(v_QueueId=DBQueueId) THEN
						BEGIN
							IF(v_LockStatus = 'N' ) THEN
							BEGIN
								BEGIN
									UPDATE wfinstrumenttable SET Q_UserId = v_lockedById , WorkItemState = 2 , LockedByName = v_userName , LockStatus = 'Y' , LockedTime =SYSDATE , Guid = null WHERE ProcessInstanceID = RTrim(LTrim(v_ProcessInstaceId))  AND WorkItemID = v_workItemId;
									
								v_rowcount := SQL%ROWCOUNT;  
								v_DBStatus := SQLCODE; 
								EXCEPTION  
								WHEN NO_DATA_FOUND THEN 
								v_rowcount := 0; 		
								END;
								
								IF(v_DBStatus <> 0 OR v_rowcount <= 0 ) THEN 
								BEGIN
									ErrorFlag :='Y';
									DBMainCode := 400;
									DBSubCode := 6;
									DBNoOfFailedRecord := 0;
									DBFailedProcessInstanceIds := ''; --Need to set the main code and subcode when issue comes while uploading the table.
																	
								END;
								END IF;
								/*IF(ErrorFlag = 'N') THEN
										BEGIN
                                         wfgeneratelog(7,v_lockedById,v_ProcessDefId, v_ActivityId, v_QueueId, v_UserName, v_ActivityId,0, v_ProcessInstaceId,0,NULL,v_workItemId,0,0,DBHistoryFlag,v_MainCode,NULL,NULL);
														 
										END;
								END IF;*/
							
							END;
							ELSIF (v_LockedByName=v_userName) THEN
								BEGIN
									BEGIN
									UPDATE wfinstrumenttable SET Q_UserId = v_lockedById , WorkItemState = 2 , LockedByName = v_userName , LockStatus = 'Y' , LockedTime =SYSDATE , Guid = null WHERE ProcessInstanceID = RTrim(LTrim(v_ProcessInstaceId))  AND WorkItemID = v_workItemId ;
									
									v_rowcount := SQL%ROWCOUNT;  
									v_DBStatus := SQLCODE; 
									EXCEPTION  
									WHEN NO_DATA_FOUND THEN 
									v_rowcount := 0; 		
									END;
									
									IF(v_DBStatus <> 0 OR v_rowcount <= 0 ) THEN 
									BEGIN
									ErrorFlag :='Y';
									DBMainCode := 400;
									DBSubCode := 6;
									DBNoOfFailedRecord := 0;
									DBFailedProcessInstanceIds := ''; --Need to set the main code and subcode when issue comes while uploading the table.																	
									END;
									END IF;
								
							
								END;
              ELSE 
              BEGIN
                  ErrorFlag :='Y';
									DBMainCode := 400;
									DBSubCode := 16;
									DBNoOfFailedRecord := 0;
									DBFailedProcessInstanceIds := ''; --Need to set the main code and subcode when issue comes while uploading the table.		
              END;
							END IF;
						END;	
					ELSE
						BEGIN					
							ErrorFlag :='Y';
							DBMainCode := 400;
							DBSubCode := 985;
							DBNoOfFailedRecord := 0;
							DBFailedProcessInstanceIds := ''; --Need to set the main code and subcode when workitem is in different queue.
						 END;
					END IF;
				END;
				END IF;
					
					IF(DBBatchFlag = 'Y' ) THEN
						BEGIN
							IF(ErrorFlag = 'Y') THEN
								BEGIN
									EXIT;
								END;
							ELSE
								BEGIN
									ErrorFlag := 'N';
									CONTINUE;
								END;
							END IF;
						END;
					ELSIF(DBBatchFlag = 'N') THEN
						BEGIN
							IF(ErrorFlag = 'Y') THEN
								BEGIN
									ErrorFlag := 'N';
									FailedProcessInstanceId := FailedProcessInstanceId || v_ProcessInstaceId || ',';
									NoOfFailedProcessInstanceId := NoOfFailedProcessInstanceId + 1;
									v_FailedWISubCodeList := v_FailedWISubCodeList || DBSubCode || ',';
									ROLLBACK  TO SAVEPOINT Single_Transaction;					
									CONTINUE;
								END;
							ELSIF(ErrorFlag = 'N') THEN
								BEGIN
									ErrorFlag := 'N';
									COMMIT ;
								END;
							END IF;
						END;
					END IF;				
					
				
				END; --End of while loop
				END Loop;
				
	IF(DBBatchFlag = 'Y') THEN
		BEGIN
		IF(ErrorFlag='Y') THEN
			BEGIN
				ROLLBACK  TO SAVEPOINT Batch_Transaction;
				RETURN;
			END;
		ELSE
			BEGIN
				COMMIT;
				RETURN;
			END;
		END IF;
		END;
	ELSE
		BEGIN
			DBMainCode := 0;
			DBSubCode := 0;
			DBNoOfFailedRecord := NoOfFailedProcessInstanceId;
			DBFailedProcessInstanceIds := FailedProcessInstanceId;
			DBSubCodeList := v_FailedWISubCodeList;
			RETURN;
		END;
	END IF;
END;
