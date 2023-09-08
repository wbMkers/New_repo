/*____________________________________________________________________________________________________
			NEWGEN SOFTWARE TECHNOLOGIES LIMITED
______________________________________________________________________________________________________
	Group						: Genesis
	Product / Project			: OmniFlow 10.1
	Module						: Transaction Server
	File Name					: WFLoadAssignmentPS.sql (Oracle)
	Author						: Mohnish Chopra
	Date written (DD/MM/YYYY)	: 04/04/2014
	Description					: Stored procedure to Expire WorkItems Candidates for expiry
______________________________________________________________________________________________________
				CHANGE HISTORY
______________________________________________________________________________________________________
 Date		Change By		Change Description (Bug No. (If Any))
22/06/2017	Sajid Khan		Bug 70211 - AssociatedFieldName is coming blank for ActionId = 28[Workitem Expired] 
15/09/2017	Sajid Khan		Bug 71926 - Error in Expiry Service[Oracle]
22/04/2018  Ambuj Tripathi		Bug 76862 - Remove the db console messages from all procedures
___________________________________________________________________________________________________*/
create or replace
Procedure WFExpireWorkItems(out_WorkItemCount 	OUT 	INT)
 as 

  TYPE wiRecordType IS Record (
  processinstanceid WFInstrumentTable.ProcessInstanceID%TYPE,
  workItemId WFInstrumentTable.WorkItemId%TYPE,
  processdefid WFInstrumentTable.ProcessDefId%TYPE,
  activityid WFInstrumentTable.ProcessDefId%TYPE,
  ACTIVITYNAME  WFInstrumentTable.ACTIVITYNAME%TYPE,
  Q_UserId WFInstrumentTable.Q_UserId%TYPE
  );
    type wiRecordTable is table of wiRecordType index by pls_integer;
     test_rec wiRecordTable;
    TYPE EXPIRY_CURSOR IS REF CURSOR;
	v_Cursor EXPIRY_CURSOR;
	v_DivertedUserIndex INTEGER;
	v_processInstanceId NVARCHAR2(64);
  
BEGIN
	
	BEGIN 
		OPEN v_Cursor FOR SELECT ProcessInstanceId FROM WFINSTRUMENTTABLE WHERE ValidTill<sysdate;
		LOOP
		BEGIN
		FETCH v_Cursor into v_processInstanceId;
			EXIT WHEN v_Cursor%NOTFOUND;
			DELETE FROM WFEscalationTable WHERE ProcessInstanceId =v_processInstanceId;
			/*DELETE FROM WFEscInProcessTable WHERE ProcessInstanceId =v_processInstanceId;*/
		END;
		END LOOP;
		CLOSE v_Cursor;
	END;
	
	out_WorkItemCount := 0;
	Update WFINSTRUMENTTABLE set AssignmentType = 'X', WorkItemState = 6,Q_queueid=0, Statename = 'COMPLETED' , LockStatus = 'N',
             		RoutingStatus = 'Y' , ValidTill = null, Q_UserId = null, AssignedUser = null, FilterValue = null, LockedByName = null, LockedTime = null, 	NotifyStatus	= null , Q_DivertedByUserId = 0,Q_StreamId = Null ,QueueName = NULL,QueueType = NULL where ValidTill<sysdate RETURNING processinstanceid ,workitemid,processdefid,activityid,ACTIVITYNAME,Q_UserId BULK COLLECT INTO test_rec;
	out_WorkItemCount := SQL%ROWCOUNT;					
  IF( out_WorkItemCount > 0) then
 FOR i IN test_rec.FIRST .. test_rec.LAST
 LOOP 
 	insert into WFCurrentRouteLogTable (PROCESSINSTANCEID,WORKITEMID,PROCESSDEFID,ACTIVITYID,ACTIVITYNAME,USERID,ACTIONID,ACTIONDATETIME,ASSOCIATEDFIELDID) values(test_rec(i).processinstanceid ,test_rec(i).workItemId,test_rec(i).processdefid,test_rec(i).activityid,test_rec(i).ACTIVITYNAME,test_rec(i).Q_UserId ,28,SYSDATE,0 );
   --DBMS_OUTPUT.PUT_LINE(test_rec(i).processinstanceid);
 END LOOP;
 END IF;

 BEGIN
		OPEN v_Cursor FOR SELECT DivertedUserIndex FROM UserDiversionTable WHERE ToDate < sysDate;	
		LOOP
		BEGIN
		FETCH v_Cursor INTO v_DivertedUserIndex;
			EXIT WHEN v_Cursor%NOTFOUND;
			DELETE FROM UserDiversionTable WHERE DivertedUserIndex = v_DivertedUserIndex;
		END;
		END LOOP;
		CLOSE v_Cursor;
 END;

 RETURN;
END;
