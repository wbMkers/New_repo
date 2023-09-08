/*__________________________________________________________________________________-
		NEWGEN SOFTWARE TECHNOLOGIES LIMITED

	Group						: Phoenix
	Product / Project			: Omniflow 7.0.1
	Module						: Transaction Server
	File Name					: Upgrade_views.sql (MS Sql Server)
	Author						: Varun Bhansaly
	Date written (DD/MM/YYYY)	: 05/03/2007
	Description					: Bugzilla Id 479
____________________________________________________________________________________-
			CHANGE HISTORY
____________________________________________________________________________________-
Date		Change By		Change Description (Bug No. (If Any))
08/06/2007	Ruhi Hira		Bugzilla Bug 637 (referto).
08/06/2007 	Ruhi Hira		WFS_5_161 (Multilingual Support -> Extra Column Added in WFSessionView)
22/07/2008	Ishu Saraf		Added WFROUTELOGVIEW 
__________________________________________________________________________________-*/

If exists(Select * From SysObjects Where name = 'WFGROUPVIEW' and xType = 'V')
	Drop View WFGROUPVIEW

~

CREATE VIEW WFGROUPVIEW 
AS 
	SELECT groupindex, groupname, CreatedDatetime, expiryDATETIME, 
			privilegecontrollist, owner, comment as commnt, grouptype, maingroupindex 
			FROM PDBGROUP

~

IF Exists (Select * from sysObjects Where name = 'EXCEPTIONVIEW' and xType = 'V')
Begin
	Drop view EXCEPTIONVIEW
End

~

CREATE VIEW EXCEPTIONVIEW 
AS
	SELECT * FROM EXCEPTIONTABLE (NOLOCK)
	UNION ALL
	SELECT * FROM EXCEPTIONHISTORYTABLE (NOLOCK)

~

IF Exists (Select * from sysObjects Where name = 'TODOSTATUSVIEW' and xType = 'V')
Begin
	Drop view TODOSTATUSVIEW
End

~

CREATE VIEW TODOSTATUSVIEW 
AS 
	SELECT * FROM TODOSTATUSTABLE (NOLOCK)
	UNION ALL
	SELECT * FROM TODOSTATUSHISTORYTABLE (NOLOCK)

~
-- Modified by Anwar Ali Danish
IF EXISTS (
			SELECT * FROM SYSObjects 
			WHERE NAME = 'CURRENTROUTELOGTABLE' 
			AND xType = 'U'
		  )
BEGIN
	IF Exists (Select * from sysObjects Where name = 'ROUTELOGTABLE' and xType = 'V')
	Begin
		Drop view ROUTELOGTABLE
	END
	
	EXECUTE('CREATE VIEW ROUTELOGTABLE 
	AS 
		SELECT * FROM CURRENTROUTELOGTABLE (NOLOCK)
		UNION ALL
		SELECT * FROM HISTORYROUTELOGTABLE (NOLOCK)')
		
END

~

IF Exists (Select * from sysObjects Where name = 'WFGROUPMEMBERVIEW' and xType = 'V')
Begin
	Drop view WFGROUPMEMBERVIEW 
End

~

CREATE VIEW WFGROUPMEMBERVIEW 
AS 
	SELECT * FROM PDBGROUPMEMBER (NOLOCK)

~

IF Exists (Select * from sysObjects Where name = 'QUSERGROUPVIEW' and xType = 'V')
Begin
	Drop view QUSERGROUPVIEW 
End

~

CREATE VIEW QUSERGROUPVIEW 
AS
	SELECT queueid,userid, NULL  groupid, AssignedtillDateTime, queryFilter
	FROM   QUEUEUSERTABLE (NOLOCK)
	WHERE  ASsociationtype=0
 	AND (AssignedtillDateTime is NULL or AssignedtillDateTime>=getdate())
	UNION
	SELECT queueid, userindex,userid AS groupid,NULL  AssignedtillDateTime, queryFilter
 	FROM   QUEUEUSERTABLE (NOLOCK), WFGROUPMEMBERVIEW (NOLOCK)
	WHERE  ASsociationtype=1 
	AND    QUEUEUSERTABLE.userid=WFGROUPMEMBERVIEW.groupindex 

~

IF Exists (Select * from sysObjects Where name = 'WFWORKLISTVIEW_0' and xType = 'V')
Begin
	Drop view WFWORKLISTVIEW_0 
End

~

CREATE VIEW WFWORKLISTVIEW_0 
AS 
	 SELECT WORKLISTTABLE.ProcessInstanceId, WORKLISTTABLE.ProcessInstanceId AS ProcessInstanceName, 				WORKLISTTABLE.ProcessDefId,  ProcessName, ActivityId, ActivityName, PriorityLevel, InstrumentStatus, LockStatus, 
		 LockedByName, ValidTill, CreatedByName, PROCESSINSTANCETABLE.CreatedDatetime, Statename, 
		 CheckListCompleteFlag,  EntryDATETIME, LockedTime, IntroductionDateTime, Introducedby, 
		 AssignedUser, WORKLISTTABLE.WorkItemId,  QueueName, AssignmentType, ProcessInstanceState, 
		 QueueType, Status, Q_QueueID,  DATEDIFF(hh,EntryDateTime , ExpectedWorkItemDelay ) AS TurnaroundTime, 
		 ReferredByname, NULL ReferTo, Q_UserID, FILTERVALUE, Q_StreamId, CollectFlag, 
		 WORKLISTTABLE.ParentWorkItemId, ProcessedBy, LastProcessedBy, ProcessVersion, WorkItemState, 
		 PREVIOUSSTAGE, ExpectedWorkitemDelay, VAR_INT1, VAR_INT2, VAR_INT3, VAR_INT4, VAR_INT5, VAR_INT6, 
		 VAR_INT7, VAR_INT8, VAR_LONG1, VAR_LONG2, VAR_LONG3, VAR_LONG4  
	 FROM  WORKLISTTABLE with (NOLOCK), PROCESSINSTANCETABLE with (NOLOCK), QUEUEDATATABLE with (NOLOCK) 
	 WHERE WORKLISTTABLE.ProcessInstanceid = QUEUEDATATABLE.ProcessInstanceId 
	 AND   WORKLISTTABLE.Workitemid =QUEUEDATATABLE.Workitemid 
	 AND   WORKLISTTABLE.ProcessInstanceId = PROCESSINSTANCETABLE.ProcessInstanceId  
	 UNION ALL
	 SELECT  PENDINGWORKLISTTABLE.ProcessInstanceId, PENDINGWORKLISTTABLE.ProcessInstanceId AS ProcessInstanceName, 
		 PENDINGWORKLISTTABLE.ProcessDefId, ProcessName, ActivityId, ActivityName, PriorityLevel, InstrumentStatus, 
		 LockStatus, LockedByName, ValidTill, CreatedByName, PROCESSINSTANCETABLE.CreatedDatetime, Statename, 
		 CheckListCompleteFlag, EntryDATETIME, LockedTime, IntroductionDateTime, Introducedby, AssignedUser, 
		 PENDINGWORKLISTTABLE.WorkItemId, QueueName, AssignmentType, ProcessInstanceState, QueueType, Status, 
		 Q_QueueID, DATEDIFF(hh, entryDATETIME, ExpectedWorkItemDelay) AS TurnaroundTime, ReferredByname,  
		 ReferredTo as ReferTo, Q_UserID, FILTERVALUE, Q_StreamId, CollectFlag, PENDINGWORKLISTTABLE.ParentWorkItemId, 
		 ProcessedBy, LastProcessedBy, ProcessVersion, WorkItemState, PREVIOUSSTAGE, ExpectedWorkitemDelay, 
		 VAR_INT1, VAR_INT2, VAR_INT3, VAR_INT4, VAR_INT5, VAR_INT6, VAR_INT7, VAR_INT8, VAR_LONG1, VAR_LONG2, 
		 VAR_LONG3, VAR_LONG4 
	 FROM  PENDINGWORKLISTTABLE with (NOLOCK), PROCESSINSTANCETABLE with (NOLOCK), QUEUEDATATABLE with (NOLOCK)  
	 WHERE PENDINGWORKLISTTABLE.ProcessInstanceid = QUEUEDATATABLE.ProcessInstanceId  
	 AND   PENDINGWORKLISTTABLE.Workitemid = QUEUEDATATABLE.Workitemid 
	 AND   PENDINGWORKLISTTABLE.ProcessInstanceId = PROCESSINSTANCETABLE.ProcessInstanceId  
	 UNION ALL 
	 SELECT WORKINPROCESSTABLE.ProcessInstanceId, WORKINPROCESSTABLE.ProcessInstanceId AS ProcessInstanceName, 
		WORKINPROCESSTABLE.ProcessDefId, ProcessName, ActivityId, ActivityName, PriorityLevel, InstrumentStatus, 
		LockStatus, LockedByName, ValidTill, CreatedByName, PROCESSINSTANCETABLE.CreatedDatetime, Statename, 
		CheckListCompleteFlag, EntryDATETIME, LockedTime, IntroductionDateTime, Introducedby, AssignedUser, 
		WORKINPROCESSTABLE.WorkItemId, QueueName, AssignmentType, ProcessInstanceState,QueueType, Status, 
		Q_QueueID, DATEDIFF(hh, entryDATETIME, ExpectedWorkItemDelay ) AS TurnaroundTime, ReferredByname, 
		NULL ReferTo, Q_UserID, FILTERVALUE, Q_StreamId, CollectFlag, WORKINPROCESSTABLE.ParentWorkItemId, 
		ProcessedBy, LastProcessedBy, ProcessVersion, WorkItemState, PREVIOUSSTAGE, ExpectedWorkitemDelay, 
		VAR_INT1, VAR_INT2, VAR_INT3, VAR_INT4, VAR_INT5, VAR_INT6, VAR_INT7, VAR_INT8, VAR_LONG1, VAR_LONG2, 
		VAR_LONG3, VAR_LONG4 
	FROM  WORKINPROCESSTABLE with (NOLOCK), PROCESSINSTANCETABLE with (NOLOCK), QUEUEDATATABLE with (NOLOCK) 
	WHERE WORKINPROCESSTABLE.ProcessInstanceid = QUEUEDATATABLE.ProcessInstanceId 
	AND   WORKINPROCESSTABLE.Workitemid = QUEUEDATATABLE.Workitemid 
	AND WORKINPROCESSTABLE.ProcessInstanceId = PROCESSINSTANCETABLE.ProcessInstanceId 
 
~ 

IF Exists (Select * from sysObjects Where name = 'QUEUETABLE' and xType = 'V')
Begin
	Drop view QUEUETABLE 
End

~

CREATE VIEW QUEUETABLE 
AS
	SELECT  queueTABLE1.processdefid, processname, processversion, 
		queueTABLE1.processinstanceid, queueTABLE1.processinstanceid AS processinstancename, 
		queueTABLE1.activityid, queueTABLE1.activityname, 
		QUEUEDATATABLE.parentworkitemid, queueTABLE1.workitemid, 
		processinstancestate, workitemstate, statename, queuename, queuetype,
		AssignedUser, AssignmentType, instrumentstatus, checklistcompleteflag, 
		IntroductionDateTime, PROCESSINSTANCETABLE.CreatedDatetime AS CreatedDatetime,
		Introducedby, createdbyname, entryDATETIME,
		lockstatus, holdstatus, prioritylevel, lockedbyname, 
		lockedtime, validtill, savestage, previousstage,
		expectedworkitemdelay AS expectedworkitemdelaytime,
	        expectedprocessdelay AS expectedprocessdelaytime, status, 
		var_INT1, var_INT2, var_INT3, var_INT4, var_INT5, var_INT6, var_INT7, var_INT8, 
		var_float1, var_float2, 
		var_date1, var_date2, var_date3, var_date4, 
		var_long1, var_long2, var_long3, var_long4, 
		var_str1, var_str2, var_str3, var_str4, var_str5, var_str6, var_str7, var_str8, 
		var_rec_1, var_rec_2, var_rec_3, var_rec_4, var_rec_5,
		q_streamid, q_queueid, q_userid, LastProcessedBy, processedby, referredto,
		referredtoname, referredby, referredbyname, collectflag, NULL AS CompletionDatetime
	FROM QUEUEDATATABLE  with (NOLOCK), 
	     PROCESSINSTANCETABLE  with (NOLOCK),
          (SELECT processinstanceid, workitemid, processname, processversion,
                  processdefid, LastProcessedBy, processedby, activityname, activityid,
                  entryDATETIME, parentworkitemid, AssignmentType,
                  collectflag, prioritylevel, validtill, q_streamid,
                  q_queueid, q_userid, AssignedUser, CreatedDatetime,
                  workitemstate, expectedworkitemdelay, previousstage,
                  lockedbyname, lockstatus, lockedtime, queuename, queuetype,
                  statename
             FROM WORKLISTTABLE  with (NOLOCK)
           UNION ALL
           SELECT processinstanceid, workitemid, processname, processversion,
                  processdefid, LastProcessedBy, processedby, activityname, activityid,
                  entryDATETIME, parentworkitemid, AssignmentType,
                  collectflag, prioritylevel, validtill, q_streamid,
                  q_queueid, q_userid, AssignedUser, CreatedDatetime,
                  workitemstate, expectedworkitemdelay, previousstage,
                  lockedbyname, lockstatus, lockedtime, queuename, queuetype,
                  statename
             FROM WORKINPROCESSTABLE  with (NOLOCK)
           UNION ALL
           SELECT processinstanceid, workitemid, processname, processversion,
                  processdefid, LastProcessedBy, processedby, activityname, activityid,
                  entryDATETIME, parentworkitemid, AssignmentType,
                  collectflag, prioritylevel, validtill, q_streamid,
                  q_queueid, q_userid, AssignedUser, CreatedDatetime,
                  workitemstate, expectedworkitemdelay, previousstage,
                  lockedbyname, lockstatus, lockedtime, queuename, queuetype,
                  statename
             FROM WORKDONETABLE  with (NOLOCK)
           UNION ALL
           SELECT processinstanceid, workitemid, processname, processversion,
                  processdefid, LastProcessedBy, processedby, activityname, activityid,
                  entryDATETIME, parentworkitemid, AssignmentType,
                  collectflag, prioritylevel, validtill, q_streamid,
                  q_queueid, q_userid, AssignedUser, CreatedDatetime,
                  workitemstate, expectedworkitemdelay, previousstage,
                  lockedbyname, lockstatus, lockedtime, queuename, queuetype,
                  statename
             FROM WORKWITHPSTABLE  with (NOLOCK)
           UNION ALL
           SELECT processinstanceid, workitemid, processname, processversion,
                  processdefid, LastProcessedBy, processedby, activityname, activityid,
                  entryDATETIME, parentworkitemid, AssignmentType,
                  collectflag, prioritylevel, validtill, q_streamid,
                  q_queueid, q_userid, AssignedUser, CreatedDatetime,
                  workitemstate, expectedworkitemdelay, previousstage,
                  lockedbyname, lockstatus, lockedtime, queuename, queuetype,
                  statename
             FROM PENDINGWORKLISTTABLE with (NOLOCK)) queueTABLE1
    WHERE QUEUEDATATABLE.processinstanceid = queueTABLE1.processinstanceid
      AND QUEUEDATATABLE.workitemid = queueTABLE1.workitemid
      AND queueTABLE1.processinstanceid = PROCESSINSTANCETABLE.processinstanceid

~

IF Exists (Select * from sysObjects Where name = 'QUEUEVIEW' and xType = 'V')
Begin
	Drop view QUEUEVIEW 
End

~

CREATE VIEW QUEUEVIEW  -- Modified by Anwar Ali Danish
AS
	SELECT processdefid,processname,processversion,processinstanceid,processinstancename,activityid,activityname,parentworkitemid,workitemid,processinstancestate,workitemstate,statename,queuename,queuetype,AssignedUser,AssignmentType,instrumentstatus,checklistcompleteflag,IntroductionDateTime,CreatedDatetime,Introducedby,createdbyname,entryDATETIME,lockstatus,holdstatus,prioritylevel,lockedbyname,lockedtime,validtill,savestage,previousstage,expectedworkitemdelaytime,expectedprocessdelaytime,status,var_INT1,var_INT2,var_INT3,var_INT4,var_INT5,var_INT6,var_INT7,var_INT8,var_float1,var_float2,var_date1,var_date2,var_date3,var_date4,var_long1,var_long2,var_long3,var_long4,var_str1,var_str2,var_str3,var_str4,var_str5,var_str6,var_str7,var_str8,var_rec_1,var_rec_2,var_rec_3,var_rec_4,var_rec_5,q_streamid,q_queueid,q_userid,LastProcessedBy,processedby,referredto,referredtoname,referredby,referredbyname,collectflag,CompletionDatetime FROM QUEUETABLE with (NOLOCK) 
	UNION ALL 
	SELECT processdefid,processname,processversion,processinstanceid,processinstancename,activityid,activityname,parentworkitemid,workitemid,processinstancestate,workitemstate,statename,queuename,queuetype,AssignedUser,AssignmentType,instrumentstatus,checklistcompleteflag,IntroductionDateTime,CreatedDatetime,Introducedby,createdbyname,entryDATETIME,lockstatus,holdstatus,prioritylevel,lockedbyname,lockedtime,validtill,savestage,previousstage,expectedworkitemdelaytime,expectedprocessdelaytime,status,var_INT1,var_INT2,var_INT3,var_INT4,var_INT5,var_INT6,var_INT7,var_INT8,var_float1,var_float2,var_date1,var_date2,var_date3,var_date4,var_long1,var_long2,var_long3,var_long4,var_str1,var_str2,var_str3,var_str4,var_str5,var_str6,var_str7,var_str8,var_rec_1,var_rec_2,var_rec_3,var_rec_4,var_rec_5,q_streamid,q_queueid,q_userid,LastProcessedBy,processedby,referredto,referredtoname,referredby,referredbyname,collectflag,CompletionDatetime FROM QUEUEHISTORYTABLE with (NOLOCK)

~

IF Exists (Select * from sysObjects Where name = 'WFSEARCHVIEW_0' and xType = 'V')
Begin
	Drop view WFSEARCHVIEW_0 
End

~

CREATE VIEW WFSEARCHVIEW_0 
AS 
	SELECT QUEUEVIEW.ProcessInstanceId,QUEUEVIEW.QueueName,	QUEUEVIEW.ProcessName,
		ProcessVersion,QUEUEVIEW.ActivityName, statename,QUEUEVIEW.CheckListCompleteFlag,
		QUEUEVIEW.AssignedUser,QUEUEVIEW.EntryDATETIME,QUEUEVIEW.ValidTill,QUEUEVIEW.workitemid,
		QUEUEVIEW.prioritylevel, QUEUEVIEW.parentworkitemid,QUEUEVIEW.processdefid,
		QUEUEVIEW.ActivityId,QUEUEVIEW.InstrumentStatus, QUEUEVIEW.LockStatus,
		QUEUEVIEW.LockedByName,QUEUEVIEW.CreatedByName,QUEUEVIEW.CreatedDatetime, 
		QUEUEVIEW.LockedTime, QUEUEVIEW.IntroductionDateTime,QUEUEVIEW.Introducedby ,
		QUEUEVIEW.AssignmentType, QUEUEVIEW.processinstancestate, QUEUEVIEW.queuetype ,
		Status ,Q_QueueId ,DATEDIFF( hh,  EntryDateTime ,  ExpectedWorkItemDelayTime )  AS TurnaroundTime, 
		ReferredBy , ReferredTo ,ExpectedProcessDelayTime , ExpectedWorkItemDelayTime,  
		ProcessedBy ,  Q_UserID , WorkItemState 
	FROM QUEUEVIEW 

~

IF Exists (Select * from sysObjects Where name = 'WFWORKINPROCESSVIEW_0' and xType = 'V')
Begin
	Drop view WFWORKINPROCESSVIEW_0 
End

~

CREATE VIEW WFWORKINPROCESSVIEW_0 
AS	SELECT WORKINPROCESSTABLE.ProcessInstanceId,WORKINPROCESSTABLE.ProcessInstanceId AS WorkItemName,
		WORKINPROCESSTABLE.ProcessdefId,ProcessName,ActivityId,ActivityName,PriorityLevel,InstrumentStatus,
		LockStatus,LockedByName,Validtill,CreatedByName,PROCESSINSTANCETABLE.CreatedDatetime,Statename,
		CheckListCompleteFlag,EntryDATETIME,LockedTime,IntroductionDateTime,Introducedby,AssignedUser,
		WORKINPROCESSTABLE.WorkItemId,QueueName,AssignmentType,ProcessInstanceState,QueueType,
		Status,Q_QueueId, DATEDIFF( hh,  EntryDateTime ,  ExpectedWorkItemDelay )  AS TurnaroundTime,
		ReferredByname,NULL ReferTo, guid,Q_userId 
	FROM  WORKINPROCESSTABLE,
	      PROCESSINSTANCETABLE,
	      QUEUEDATATABLE 
	WHERE WORKINPROCESSTABLE.ProcessInstanceid = QUEUEDATATABLE.ProcessInstanceId
	AND   WORKINPROCESSTABLE.Workitemid = QUEUEDATATABLE.Workitemid 
	AND   WORKINPROCESSTABLE.ProcessInstanceid = PROCESSINSTANCETABLE.ProcessInstanceId 

~

IF Exists (Select * from sysObjects Where name = 'WFSESSIONVIEW' and xType = 'V')
Begin
	Drop view WFSESSIONVIEW 
End

~

CREATE VIEW WFSESSIONVIEW 
AS 
	SELECT  RandomNumber AS SessionID, UserIndex AS UserID, UserLogINTime, 
		HostName AS Scope, MainGroupId, UserType AS ParticipantType,
		AccessDATETIME , StatusFlag, Locale 
	FROM PDBCONNECTION

~

IF EXISTS (SELECT * from sysObjects Where name = 'WFROUTELOGVIEW' and xType = 'V')
BEGIN
	DROP VIEW WFROUTELOGVIEW
END

~

CREATE VIEW WFROUTELOGVIEW
AS 
	SELECT * FROM WFCURRENTROUTELOGTABLE (NOLOCK)
	UNION ALL
	SELECT * FROM WFHISTORYROUTELOGTABLE (NOLOCK)

~