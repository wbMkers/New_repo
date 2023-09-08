/*__________________________________________________________________________________-
		NEWGEN SOFTWARE TECHNOLOGIES LIMITED

	Group						: Phoenix
	Product / Project			: Omniflow 7.0.1
	Module						: Transaction Server
	File Name					: Upgrade_views.sql (Oracle Server)
	Author						: Varun Bhansaly
	Date written (DD/MM/YYYY)	: 05/03/2007
	Description					: Bugzilla Id 479
____________________________________________________________________________________-
			CHANGE HISTORY
____________________________________________________________________________________-
Date		Change By		Change Description (Bug No. (If Any))
08/06/2007	Ruhi Hira		Bugzilla Bug 637 (referto).
08/06/2007 	Ruhi Hira		WFS_5_161 (Multilingual Support -> Extra Column Added in WFSessionView)
04/07/2007  Varun Bhansaly	Bugzilla Id 361 (TurnAroundTime expression incorrect in Oracle)
24/08/2008	Ishu Saraf		Created View WFROUTELOGVIEW
__________________________________________________________________________________-*/

CREATE OR REPLACE VIEW QUSERGROUPVIEW 
AS
	SELECT * FROM ( 
		SELECT queueid, userid, cast ( NULL AS integer ) AS GroupId, assignedtilldatetime, queryFilter
			FROM QUEUEUSERTABLE 
			WHERE associationtype = 0
			AND (
				assignedtilldatetime is NULL OR assignedtilldatetime> = sysdate
				)
		UNION
		SELECT queueid, userindex,userid AS groupid, assignedtilldatetime, queryFilter
			FROM QUEUEUSERTABLE, wfgroupmemberview
			WHERE associationtype = 1 
			AND QUEUEUSERTABLE.userid = wfgroupmemberview.groupindex
	)a

~

CREATE OR REPLACE VIEW WFUSERVIEW ( USERINDEX, USERNAME, PERSONALNAME, FAMILYNAME, CREATEDDATETIME, EXPIRYDATETIME, PRIVILEGECONTROLLIST, PASSWORD, ACCOUNT, COMMNT, DELETEDDATETIME, USERALIVE, MAINGROUPID, MAILID, FAX, NOTECOLOR )
AS 
	SELECT  USERINDEX,TO_NChar(RTRIM(USERNAME)) as USERNAME,PERSONALNAME,FAMILYNAME, CREATEDDATETIME,
			EXPIRYDATETIME, PRIVILEGECONTROLLIST, PASSWORD, ACCOUNT, COMMNT, 
			DELETEDDATETIME, USERALIVE, MAINGROUPID, MAILID, FAX, 
			NOTECOLOR
		FROM PDBUSER

~

CREATE OR REPLACE VIEW WFWORKLISTVIEW_0 
AS 
	SELECT WORKLISTTABLE.ProcessInstanceId, WORKLISTTABLE.ProcessInstanceId AS ProcessInstanceName, WORKLISTTABLE.ProcessDefId, 
		 ProcessName, ActivityId, ActivityName, PriorityLevel, InstrumentStatus, 
		 LockStatus, LockedByName, ValidTill, CreatedByName, 
		 PROCESSINSTANCETABLE.CreatedDateTime, Statename, CheckListCompleteFlag, 
		 EntryDateTime, LockedTime, IntroductionDateTime, IntroducedBy, 
		 AssignedUser, WORKLISTTABLE.WorkItemId, QueueName, AssignmentType, 
		 ProcessInstanceState, QueueType, Status, Q_QueueID,
		 (ExpectedWorkItemDelay - entrydatetime) * 24.0 AS TurnaroundTime, 
		 ReferredByname, NULL ReferTo, Q_UserID, FILTERVALUE, Q_StreamId, 
		 CollectFlag, WORKLISTTABLE.ParentWorkItemId, ProcessedBy, LastProcessedBy, 
		 ProcessVersion, WorkItemState, PREVIOUSSTAGE, ExpectedWorkitemDelay , 
		 VAR_INT1, VAR_INT2, VAR_INT3, VAR_INT4, VAR_INT5, VAR_INT6, 
		 VAR_INT7, VAR_INT8, VAR_LONG1, VAR_LONG2, VAR_LONG3, VAR_LONG4 
	FROM	WORKLISTTABLE , PROCESSINSTANCETABLE , QUEUEDATATABLE  
	WHERE	WORKLISTTABLE.ProcessInstanceid = QUEUEDATATABLE.ProcessInstanceId 
	AND	WORKLISTTABLE.Workitemid =QueueDatatable.Workitemid 
	AND	WORKLISTTABLE.ProcessInstanceId = PROCESSINSTANCETABLE.ProcessInstanceId  
	UNION ALL
	SELECT PENDINGWORKLISTTABLE.ProcessInstanceId, 
		 PENDINGWORKLISTTABLE.ProcessInstanceId AS ProcessInstanceName, 
		 PENDINGWORKLISTTABLE.ProcessDefId, ProcessName, ActivityId, ActivityName, 
		 PriorityLevel, InstrumentStatus, LockStatus, LockedByName, ValidTill, 
		 CreatedByName, PROCESSINSTANCETABLE.CreatedDateTime, Statename, 
		 CheckListCompleteFlag, EntryDateTime, LockedTime, IntroductionDateTime, 
		 IntroducedBy, AssignedUser, PENDINGWORKLISTTABLE.WorkItemId, 
		 QueueName, AssignmentType, ProcessInstanceState, QueueType, Status, 
		 Q_QueueID,(ExpectedWorkItemDelay - entrydatetime) * 24.0 AS TurnaroundTime, 
		 ReferredByname, referredTo AS ReferTo, Q_UserID, FILTERVALUE, Q_StreamId, CollectFlag, 
		 PENDINGWORKLISTTABLE.ParentWorkItemId, ProcessedBy, LastProcessedBy, 
		 ProcessVersion, WorkItemState, PREVIOUSSTAGE, ExpectedWorkitemDelay, 
		 VAR_INT1, VAR_INT2, VAR_INT3, VAR_INT4, VAR_INT5, VAR_INT6, 
		 VAR_INT7, VAR_INT8, VAR_LONG1, VAR_LONG2, VAR_LONG3, VAR_LONG4  
	FROM	PENDINGWORKLISTTABLE , PROCESSINSTANCETABLE , QUEUEDATATABLE   
	WHERE   PENDINGWORKLISTTABLE.ProcessInstanceid = QUEUEDATATABLE.ProcessInstanceId  
	AND	PENDINGWORKLISTTABLE.Workitemid = QUEUEDATATABLE.Workitemid 
	AND	PENDINGWORKLISTTABLE.ProcessInstanceId = PROCESSINSTANCETABLE.ProcessInstanceId	
	UNION	ALL
	SELECT WORKINPROCESSTABLE.ProcessInstanceId, 
		 WORKINPROCESSTABLE.ProcessInstanceId AS ProcessInstanceName, 
		 WORKINPROCESSTABLE.ProcessDefId, ProcessName, ActivityId, 
		 ActivityName, PriorityLevel,InstrumentStatus, LockStatus, LockedByName, 
		 ValidTill, CreatedByName, PROCESSINSTANCETABLE.CreatedDateTime,  
		 Statename, CheckListCompleteFlag, EntryDateTime, LockedTime, 
		 IntroductionDateTime, IntroducedBy, AssignedUser, 
		 WORKINPROCESSTABLE.WorkItemId, QueueName, AssignmentType, 
		 ProcessInstanceState, QueueType, Status, Q_QueueID, 
		 (ExpectedWorkItemDelay - entrydatetime) * 24.0 AS TurnaroundTime,  
		 ReferredByname, NULL ReferTo, Q_UserID, FILTERVALUE, Q_StreamId, CollectFlag,
		 WORKINPROCESSTABLE.ParentWorkItemId,ProcessedBy, LastProcessedBy, 
		 ProcessVersion, WorkItemState, PREVIOUSSTAGE, ExpectedWorkitemDelay, 
		 VAR_INT1, VAR_INT2, VAR_INT3, VAR_INT4, VAR_INT5, VAR_INT6, 
		 VAR_INT7, VAR_INT8, VAR_LONG1, VAR_LONG2, VAR_LONG3, VAR_LONG4 
	FROM	WORKINPROCESSTABLE , PROCESSINSTANCETABLE , QUEUEDATATABLE  
	WHERE	WORKINPROCESSTABLE.ProcessInstanceid = QUEUEDATATABLE.ProcessInstanceId 
	AND	WORKINPROCESSTABLE.Workitemid = QUEUEDATATABLE.Workitemid 
	AND	WORKINPROCESSTABLE.ProcessInstanceId = PROCESSINSTANCETABLE.ProcessInstanceId 

~

CREATE OR REPLACE VIEW WFSESSIONVIEW ( SESSIONID,USERID, USERLOGINTIME, SCOPE, MAINGROUPID, 
					PARTICIPANTTYPE, ACCESSDATETIME, STATUSFLAG, LOCALE ) 
AS 
	SELECT  RandomNumber AS SessionID, UserIndex AS UserID, 
		UserLoginTime, HostName AS Scope, MainGroupId, 
		UserType AS ParticipantType,AccessDateTime , StatusFlag , Locale
	FROM PDBCONNECTION

~

CREATE OR REPLACE VIEW WFSEARCHVIEW_0 
AS 
	SELECT queueview.ProcessInstanceId,queueview.QueueName,
		queueview.ProcessName,ProcessVersion,queueview.ActivityName, 
		statename,queueview.CheckListCompleteFlag,
		queueview.AssignedUser,queueview.EntryDateTime,
		queueview.ValidTill,queueview.workitemid,
		queueview.prioritylevel, queueview.parentworkitemid,
		queueview.processdefid,queueview.ActivityId,queueview.InstrumentStatus,
		queueview.LockStatus,queueview.LockedByName,
		queueview.CreatedByName,queueview.CreatedDateTime, 
		queueview.LockedTime, queueview.IntroductionDateTime,
		queueview.IntroducedBy ,queueview.assignmenttype, 
		queueview.processinstancestate, queueview.queuetype ,
		Status ,Q_QueueId ,
		(ExpectedWorkItemDelayTime - entrydatetime)*24  AS TurnaroundTime, 
		ReferredBy , ReferredTo ,ExpectedProcessDelayTime , 
		ExpectedWorkItemDelayTime,  ProcessedBy ,  Q_UserID , WorkItemState 
	FROM   queueview 

~

CREATE OR REPLACE VIEW WFWORKINPROCESSVIEW_0 
AS 
	SELECT WORKINPROCESSTABLE.ProcessInstanceId,WORKINPROCESSTABLE.ProcessInstanceId AS 		WorkItemName,WORKINPROCESSTABLE.ProcessdefId,ProcessName,ActivityId,ActivityName,PriorityLevel,InstrumentStatus,
		LockStatus,LockedByName,Validtill,CreatedByName,
		PROCESSINSTANCETABLE.CreatedDateTime,Statename,
		CheckListCompleteFlag,EntryDateTime,LockedTime,
		IntroductionDateTime,IntroducedBy,AssignedUser,
		WORKINPROCESSTABLE.WorkItemId,QueueName,AssignmentType,
		ProcessInstanceState,QueueType,	Status,Q_QueueId, 
		(ExpectedWorkItemDelay - entrydatetime)*24  AS TurnaroundTime,
		ReferredByname,NULL ReferTo, guid,Q_userId 
	FROM   WORKINPROCESSTABLE,PROCESSINSTANCETABLE,QUEUEDATATABLE 
	WHERE  WORKINPROCESSTABLE.ProcessInstanceid = QUEUEDATATABLE.ProcessInstanceId
	AND    WORKINPROCESSTABLE.Workitemid = QUEUEDATATABLE.Workitemid 
	AND    WORKINPROCESSTABLE.ProcessInstanceid = PROCESSINSTANCETABLE.ProcessInstanceId 

~
