/*____________________________________________________________________________________________________
			NEWGEN SOFTWARE TECHNOLOGIES LIMITED
______________________________________________________________________________________________________
	Group						: Genesis
	Product / Project			: iBPS
	Module						: Transaction Server
	File Name					: WFExpireWorkItems.sql (Postgres)
	Author						: Sajid Khan	
	Date written (DD/MM/YYYY)	: 04 May 2016
	Description					: Stored procedure to Expire workitems candidates for expiry
______________________________________________________________________________________________________
				CHANGE HISTORY
______________________________________________________________________________________________________
 Date		Change By		Change Description (Bug No. (If Any))
22/06/2017	Sajid Khan		Bug 70211 - AssociatedFieldName is coming blank for ActionId = 28[Workitem Expired] 
____________________________________________________________________________________________________*/
create or replace FUNCTION WFExpireWorkItems () RETURNS REFCURSOR AS $$
DECLARE 
record  RECORD;
v_rowCount INTEGER;
v_rowCountTemp INTEGER;
v_query    VARCHAR;
v_MainCode INTEGER;
resultSet  REFCURSOR; 
resultSetReturnCount  REFCURSOR; 
v_processinstanceid  WFInstrumentTable.ProcessInstanceID%TYPE;
v_workitemid  WFInstrumentTable.WorkItemId%TYPE;
v_processdefid  WFInstrumentTable.ProcessDefId%TYPE;
v_activityid  WFInstrumentTable.ProcessDefId%TYPE;
v_activityName  WFInstrumentTable.ACTIVITYNAME%TYPE;
v_Q_UserId  WFInstrumentTable.Q_UserId%TYPE;
v_cursor CURSOR FOR Select processinstanceid from WFINSTRUMENTTABLE where ValidTill < CURRENT_TIMESTAMP;
BEGIN
 v_rowCount :=0;
 v_MainCode :=0;	
 	
 	
	OPEN v_cursor;
	LOOP
		FETCH v_cursor into v_processinstanceid;
		EXIT WHEN NOT FOUND;
		DELETE FROM WFEscalationTable WHERE ProcessInstanceId =v_processinstanceid;
		/*DELETE FROM WFEscInProcessTable WHERE ProcessInstanceId =v_processinstanceid;*/
	
	END LOOP;
	CLOSE v_cursor;
	
 v_query :=  'Select processinstanceid ,workitemid,processdefid,activityid,ACTIVITYNAME,Q_UserId from WFINSTRUMENTTABLE where ValidTill < CURRENT_TIMESTAMP';
 --Update WFINSTRUMENTTABLE set AssignmentType = 'X', WorkItemState = 6, Q_queueid=0, Statename = 'COMPLETED' , LockStatus = 'N',RoutingStatus = 'Y' , ValidTill = null, Q_UserId = null, AssignedUser = null, FilterValue = null, LockedByName = null, LockedTime = null,NotifyStatus	= null  WHERE  ValidTill < CURRENT_TIMESTAMP ;   
	OPEN resultSet FOR EXECUTE v_query; 
	LOOP
		FETCH resultSet into v_processinstanceid ,v_workitemid,v_processdefid,v_activityid,v_activityName,v_Q_UserId;
		IF(NOT FOUND) THEN
		   EXIT;
		END IF;
		Update WFINSTRUMENTTABLE set AssignmentType = 'X', WorkItemState = 6, Q_queueid=0, Statename = 'COMPLETED' , LockStatus = 'N',RoutingStatus = 'Y' , ValidTill = null, Q_UserId = null, AssignedUser = null, FilterValue = null, LockedByName = null, LockedTime = null,NotifyStatus	= null,Q_StreamId = Null ,QueueName = NULL,QueueType = NULL WHERE  processinstanceid=v_processinstanceid AND workitemid=v_workitemid AND processdefid=v_processdefid AND activityid=v_activityid AND Q_UserId=v_Q_UserId;
		
		GET DIAGNOSTICS v_rowCountTemp = ROW_COUNT;
		v_rowCount := v_rowCountTemp+1;
		v_MainCode:=WFGenerateLog(28, v_Q_UserId,v_processDefId,v_activityId, 0, 'SYSTEM', coalesce(v_activityName,0), 0, v_processinstanceid, 0 ,null , v_workitemId , 0 , 0 , NULL , 0 , v_taskId , 0, NULL,NULL);
	END LOOP;

	OPEN resultSetReturnCount FOR SELECT v_rowCount;
	RETURN resultSetReturnCount;

END;
$$ LANGUAGE plpgsql;
