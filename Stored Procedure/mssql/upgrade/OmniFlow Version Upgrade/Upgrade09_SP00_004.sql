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
08/06/2014  CHitvan Chhabra Bug 47706 - While version upgrading from 	omniflow 8.0 to omniflow 9.0 issues were 											encountered
26/05/2017	Ashok Kumar	Bug 62518 - Step by Step Debugs in Version Upgrade.
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
	
	
IF Exists (Select * from sysObjects Where name = 'ROUTELOGTABLE' and xType = 'V')
Begin
	Drop view ROUTELOGTABLE
End

~
DECLARE @v_logStatus  NVARCHAR(10) 
exec @v_logStatus= LogInsert 1,'Upgrade09_SP00_004','Creating View CURRENTROUTELOGTABLE'
	BEGIN
	BEGIN TRY
		If Exists (Select * from SysObjects where name = 'CURRENTROUTELOGTABLE' and  xtype='U')
		Begin
			exec  @v_logStatus = LogSkip 1,'Upgrade09_SP00_004'
			Execute('CREATE VIEW ROUTELOGTABLE 
		AS 
			SELECT * FROM CURRENTROUTELOGTABLE (NOLOCK)
			UNION ALL
			SELECT * FROM HISTORYROUTELOGTABLE (NOLOCK)')
			Print 'CREATING VIEW ROUTELOGTABLE..... '
		End
	END TRY
	BEGIN CATCH
		exec  @v_logStatus = LogFailed 1,'Upgrade09_SP00_004'
		RAISERROR('Block 1 Failed.',16,1)
		RETURN
	END CATCH	
	END
exec @v_logStatus = LogUpdate 1,'Upgrade09_SP00_004'
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

DECLARE @v_logStatus  NVARCHAR(10) 
exec @v_logStatus= LogInsert 3,'Upgrade09_SP00_004','Adding new Column in QueueDataTable '
	BEGIN
	BEGIN TRY
		IF Exists (Select * from sysObjects Where name = 'QUEUEDATATABLE' and xType = 'U')
		Begin
		exec  @v_logStatus = LogSkip 3,'Upgrade09_SP00_004'
		/*WFS_8.0_026 - workitem specific calendar*/
			IF NOT EXISTS ( SELECT * FROM sysColumns 
				WHERE 
				id = (SELECT id FROM sysObjects WHERE NAME = 'QueueDataTable')
				AND  NAME = 'CalendarName'
				)
			BEGIN
				EXECUTE('ALTER TABLE QueueDataTable ADD CalendarName NVARCHAR(225)')
				PRINT 'Table QueueDataTable altered with new Column CalendarName'
			END
			END
	END TRY
	BEGIN CATCH
		exec  @v_logStatus = LogFailed 3,'Upgrade09_SP00_004'
		RAISERROR('Block 3 Failed.',16,1)
		RETURN
	END CATCH	
	END
exec @v_logStatus = LogUpdate 3,'Upgrade09_SP00_004'	
~
DECLARE @v_logStatus  NVARCHAR(10) 
exec @v_logStatus= LogInsert 4,'Upgrade09_SP00_004','Adding new Column in QueueHistoryTable'
	BEGIN
	BEGIN TRY
		IF NOT EXISTS ( SELECT * FROM sysColumns 
				WHERE 
				id = (SELECT id FROM sysObjects WHERE NAME = 'QueueHistoryTable')
				AND  NAME = 'CalendarName'
				)
			BEGIN
				exec  @v_logStatus = LogSkip 4,'Upgrade09_SP00_004'
				EXECUTE('ALTER TABLE QueueHistoryTable ADD CalendarName NVARCHAR(255)')
				PRINT 'Table QueueHistoryTable altered with new Column CalendarName'
			END
	END TRY
	BEGIN CATCH
		exec  @v_logStatus = LogFailed 4,'Upgrade09_SP00_004'
		RAISERROR('Block 4 Failed.',16,1)
		RETURN
	END CATCH	
	END
 
exec @v_logStatus = LogUpdate 4,'Upgrade09_SP00_004'	
~
IF Exists (Select * from sysObjects Where name = 'QUEUETABLE' and xType = 'V')
Begin
	Drop view QUEUETABLE 
End

~
DECLARE @v_logStatus  NVARCHAR(10) 
exec @v_logStatus= LogInsert 5,'Upgrade09_SP00_004','Creating View QUEUETABLE'
	BEGIN
	BEGIN TRY

			IF Exists (Select * from sysObjects Where name = 'QUEUEDATATABLE' and xType = 'U')
			Begin
			exec  @v_logStatus = LogSkip 5,'Upgrade09_SP00_004'
			Execute(
			'CREATE VIEW QUEUETABLE 
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
					referredtoname, referredby, referredbyname, collectflag, NULL AS CompletionDatetime, CalendarName
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
				  AND queueTABLE1.processinstanceid = PROCESSINSTANCETABLE.processinstanceid')
				End
	END TRY
	BEGIN CATCH
		exec  @v_logStatus = LogFailed 5,'Upgrade09_SP00_004'
		RAISERROR('Block 5 Failed.',16,1)
		RETURN
	END CATCH	
	END
exec @v_logStatus = LogUpdate 5,'Upgrade09_SP00_004'			
~

IF Exists (Select * from sysObjects Where name = 'QUEUEVIEW' and xType = 'V')
Begin
	Drop view QUEUEVIEW 
End

~

DECLARE @v_logStatus  NVARCHAR(10) 
exec @v_logStatus= LogInsert 6,'Upgrade09_SP00_004','Creating View QUEUEVIEW'
	BEGIN
	BEGIN TRY
		IF Exists (Select * from sysObjects Where name = 'QUEUEDATATABLE' and xType = 'U')
		Begin
		exec  @v_logStatus = LogSkip 6,'Upgrade09_SP00_004'
		Execute('
		CREATE VIEW QUEUEVIEW AS 
		SELECT * FROM QUEUETABLE WITH (NOLOCK) 
		UNION ALL 
		SELECT PROCESSDEFID, PROCESSNAME, PROCESSVERSION, PROCESSINSTANCEID, PROCESSINSTANCEID AS PROCESSINSTANCENAME, ACTIVITYID, ACTIVITYNAME, PARENTWORKITEMID, WORKITEMID, PROCESSINSTANCESTATE, WORKITEMSTATE, STATENAME, QUEUENAME, QUEUETYPE, ASSIGNEDUSER, ASSIGNMENTTYPE, INSTRUMENTSTATUS, CHECKLISTCOMPLETEFLAG, INTRODUCTIONDATETIME, CREATEDDATETIME AS CREATEDDATETIME, INTRODUCEDBY, CREATEDBYNAME, ENTRYDATETIME, LOCKSTATUS, HOLDSTATUS, PRIORITYLEVEL, LOCKEDBYNAME, LOCKEDTIME, VALIDTILL, SAVESTAGE, PREVIOUSSTAGE, EXPECTEDWORKITEMDELAYTIME AS EXPECTEDWORKITEMDELAYTIME, EXPECTEDPROCESSDELAYTIME AS EXPECTEDPROCESSDELAYTIME, STATUS, VAR_INT1, VAR_INT2, VAR_INT3, VAR_INT4, VAR_INT5, VAR_INT6, VAR_INT7, VAR_INT8, VAR_FLOAT1, VAR_FLOAT2, VAR_DATE1, VAR_DATE2, VAR_DATE3, VAR_DATE4, VAR_LONG1, VAR_LONG2, VAR_LONG3, VAR_LONG4, VAR_STR1, VAR_STR2, VAR_STR3, VAR_STR4, VAR_STR5, VAR_STR6, VAR_STR7, VAR_STR8, VAR_REC_1, VAR_REC_2, VAR_REC_3, VAR_REC_4, VAR_REC_5, Q_STREAMID, Q_QUEUEID, Q_USERID, LASTPROCESSEDBY, PROCESSEDBY, REFERREDTO, REFERREDTONAME, REFERREDBY, REFERREDBYNAME, COLLECTFLAG, NULL AS COMPLETIONDATETIME, CALENDARNAME FROM QUEUEHISTORYTABLE WITH (NOLOCK)')
		End
	END TRY
	BEGIN CATCH
		exec  @v_logStatus = LogFailed 6,'Upgrade09_SP00_004'
		RAISERROR('Block 6 Failed.',16,1)
		RETURN
	END CATCH	
	END
 
exec @v_logStatus = LogUpdate 6,'Upgrade09_SP00_004'	
~

IF Exists (Select * from sysObjects Where name = 'WFSEARCHVIEW_0' and xType = 'V')
Begin
	Drop view WFSEARCHVIEW_0 
End

~

DECLARE @v_logStatus NVARCHAR(10)
exec @v_logStatus= LogInsert 9,'Upgrade09_SP00_004','Recreating View WFSESSIONVIEW'
	BEGIN
	BEGIN TRY
		IF Exists (Select * from sysObjects Where name = 'WFSESSIONVIEW' and xType = 'V')
		Begin
			Drop view WFSESSIONVIEW 
			exec  @v_logStatus = LogSkip 9,'Upgrade09_SP00_004'
			Execute('CREATE VIEW WFSESSIONVIEW 
				AS 
				SELECT  RandomNumber AS SessionID, UserIndex AS UserID, UserLogINTime, 
				HostName AS Scope, MainGroupId, UserType AS ParticipantType,
				AccessDATETIME , StatusFlag, Locale 
				FROM PDBCONNECTION')
		End
		
	END TRY
	BEGIN CATCH
		exec  @v_logStatus = LogFailed 9,'Upgrade09_SP00_004'
		RAISERROR('Block 9 Failed.',16,1)
		RETURN
	END CATCH	
	END
exec @v_logStatus = LogUpdate 9,'Upgrade09_SP00_004'	




~
DECLARE @v_logStatus NVARCHAR(10)
exec @v_logStatus= LogInsert 10,'Upgrade09_SP00_004','Recreating View WFROUTELOGVIEW'
	BEGIN
	BEGIN TRY
			IF EXISTS (SELECT * from sysObjects Where name = 'WFROUTELOGVIEW' and xType = 'V')
			BEGIN
			DROP VIEW WFROUTELOGVIEW
			END
				
			If Exists (Select * from SysObjects where name = 'WFCURRENTROUTELOGTABLE' and  xtype='U')
			Begin
			exec  @v_logStatus = LogSkip 10,'Upgrade09_SP00_004'
			EXECUTE('CREATE VIEW WFROUTELOGVIEW
			AS 
				SELECT * FROM WFCURRENTROUTELOGTABLE (NOLOCK)
				UNION ALL
				SELECT * FROM WFHISTORYROUTELOGTABLE (NOLOCK)')
			END
	END TRY
	BEGIN CATCH
		exec  @v_logStatus = LogFailed 10,'Upgrade09_SP00_004'
		RAISERROR('Block 10 Failed.',16,1)
		RETURN
	END CATCH	
	END
exec @v_logStatus = LogUpdate 10,'Upgrade09_SP00_004'	
~