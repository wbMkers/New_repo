/*__________________________________________________________________________________-
		NEWGEN SOFTWARE TECHNOLOGIES LIMITED

	Group				: Application – Products
	Product / Project		: WorkFlow 6.1.2
	Module				: Transaction Server
	File Name			: Upgrade.sql (MSSql Server)
	Author				: Ruhi Hira
	Date written (DD/MM/YYYY)	: 27/04/2005
	Description			: Upgrade Script for OF, (5.0.1 - 6.1.2)
____________________________________________________________________________________-
			CHANGE HISTORY
____________________________________________________________________________________-
Date		Change By		Change Description (Bug No. (If Any))
29/09/2005	Ruhi Hira			SrNo-1.
5/08/2005	Mandeep Kaur		SrNo-3.
23/12/2005	Mandeep Kaur		SrNo-2.
03/01/2006	Ruhi Hira			WFS_6.1.2_008, WFS_6.1.2_009.
10/01/2006	Mandeep Kaur		SrNo-4.
12/01/2006	Mandeep Kaur		WFS_6.1.2_027(script not being executed properly)
19/01/2006	Harmeet Kaur		WFS_6.1.2_037
20/01/2006	Harmeet Kaur		WFS_6.1.2_042
25/01/2006	Ashish Mangla		WFS_6.1.2_043
28/08/2006	Ruhi Hira			Bugzilla Id 95.
06/12/2006	Ruhi Hira			SrNo-5.
09/01/2007	Varun Bhansaly		Bugzilla Bug 370
09/02/2007	Varun Bhansaly		Bugzilla Id 442
09/02/2007	Varun Bhansaly		Bugzilla Id 74
23/07/2007  Varun Bhansaly	    To counter RD bugs & To make Upgrade Script more robust. 	
16/08/2007	Varun Bhansaly		Transfer Data from DistributeActivityTable to 
								RuleOperationTable & RuleConditionTable as well. 	
20/12/2007	Varun Bhansaly		Bugzilla Id 1800, ([CabCreation] New parameter type 12 [boolean] to be considered)
28/01/2008	Varun Bhansaly		Bugzilla Id 1788, (index not used in WFDataStructureTable in PostgreSQL.)
12/02/2008	Varun Bhansaly		CheckOutProcessesTable may not exist on all 5x cabinets, - Create it
23/07/2008	Ishu Saraf			New Parameters Type 15, 16 in ExtMethodDefTable and ExtMethodParamDefTable need to be considered as discussed with Ruhi
13/01/2009	Ishu Saraf			Changes for ProcessDefTable
14/01/2009	Ishu Saraf			Add procedure WFCollectionUpgrade - Collect Distribute
30/06/2013  Sajid Khan			Check applied for currentroutelog and wfcurrentroutelogtable.
____________________________________________________________________________________-
To debug:
________-
Search on __**DEBUG**__
uncomment statements encloseed in enclosed in '__**DEBUG**__' tag 
by jus removing '__' before print, need to rerun the script.

____________________________________________________________________________________-
Todo:
____-

__________________________________________________________________________________-*/

If Exists (Select * from SysObjects Where xType = 'P' and name = 'Upgrade_Tables')
Begin
	Execute('DROP PROCEDURE Upgrade_Tables')
	Print 'Procedure Upgrade_Tables, Part of Upgrade already exists, hence older one dropped ..... '
End

~
If Exists (Select * from SysObjects Where xType = 'P' and name = 'Upgrade')
Begin
	Execute('DROP PROCEDURE Upgrade')
	Print 'Procedure Upgrade already exists, hence older one dropped ..... '
End

~

/* Procedure to Create new tables / constraints / Views / Triggers */

Create Procedure Upgrade AS 
Begin
	/* Declare variables */
	DECLARE	@processDefId		INTEGER
	DECLARE	@activityId		INTEGER
	DECLARE	@targetActivityId	INTEGER
	DECLARE @constraintName		VARCHAR(40)
	DECLARE @tableId		INT
	DECLARE @dropFlag		INT
	DECLARE	@ruleId			INT
	DECLARE @v_msgCount			INTEGER
	DECLARE @v_cabVersionId		INTEGER
	DECLARE @v_msgStr			NVARCHAR(128)

	SELECT @dropFlag = 0

	IF NOT EXISTS(Select * From sysObjects Where name = 'WFCabVersionTable')
	Begin
		Execute ('
		Create Table WFCabVersionTable (
			cabVersion	NVARCHAR(10) NOT NULL,
			cabVersionId	INT IDENTITY (1,1) PRIMARY KEY,
			creationDate	DATETIME,
			lastModified	DATETIME,
			Remarks		NVARCHAR(200) NOT NULL,
			Status		NVARCHAR(1)
		)')
		Print 'Table WFCabVersionTable created successfully'
	End
	ELSE
	BEGIN
		EXECUTE('Alter Table WFCabVersionTable Alter Column cabVersion NVARCHAR(255)')
		Print 'Table WFCabVersionTable altered with Column cabVersion size increased to 255'
		EXECUTE('Alter Table WFCabVersionTable Alter Column Remarks NVARCHAR(255)')
		Print 'Table WFCabVersionTable altered with Column Remarks size increased to 255'
	END

	IF NOT EXISTS(SELECT * FROM SYSCOLUMNS WHERE NAME='ActionDateTime' AND id = (SELECT id FROM SYSOBJECTS WHERE NAME = 'WFMessageTable'  AND XTYPE='U' ))
	Begin
			Execute ('ALTER TABLE WFMessageTable ADD ActionDateTime DATETIME')
			Print 'Table WFMessageTable altered with new Column ActionDateTime'
	End

	SELECT @v_msgCount = COUNT(*) FROM WFMessageTable
	IF(@v_msgCount > 0)
	BEGIN
		SELECT @v_cabVersionId = @@IDENTITY
		UPDATE WFCabVersionTable SET Remarks = Remarks + N' - Upgrade Halted! WFMessageTable contains ' + CONVERT(NVARCHAR(10), @v_msgCount) + N' unprocessed messages. To process these messages run Message Agent. Thereafter, Upgrade once again.' WHERE cabVersionId =  @v_cabVersionId
		SELECT @v_msgStr = 'Upgrade Halted! WFMessageTable contains ' + CONVERT(NVARCHAR(10), @v_msgCount) + ' unprocessed messages. To process these messages run Message Agent. Thereafter, run Upgrade once again.'
		RAISERROR(@v_msgStr, 16, 1) 
	END


	/* Create table ExtMethodDefTable */
	IF NOT EXISTS (
		SELECT * FROM SYSObjects
		WHERE	name	= 'ExtMethodDefTable'
		AND	xType	= 'U'
	)
	Begin
		EXECUTE('
			CREATE TABLE ExtMethodDefTable(
				ProcessDefId		INTEGER		NOT NULL,
				ExtMethodIndex		INTEGER		NOT NULL,	
				ExtAppName		NVARCHAR(64)	NOT NULL, 
				ExtAppType		NVARCHAR(1)	NOT NULL CHECK (ExtAppType in (N''E'', N''W'')),
				ExtMethodName		NVARCHAR(64)	NOT NULL,
				SearchMethod		NVARCHAR(255)	NULL,
				SearchCriteria		NVARCHAR(2000) 	NULL,
				ReturnType		SMALLINT	CHECK (ReturnType in (0, 3, 4, 6, 8, 10, 11)),
				PRIMARY KEY(ProcessDefId, ExtMethodIndex)
			)
		')
	End

	/* Create table ExtMethodParamDefTable */
	/* SrNo-2, New field DataStructureId added for Web Service Invoker - Mandeep Kaur/ Ruhi Hira */
	IF NOT EXISTS (
		SELECT * FROM SYSObjects
		WHERE	name	= 'ExtMethodParamDefTable'
		AND	xType	= 'U'
	)
	Begin
		EXECUTE('
			CREATE TABLE ExtMethodParamDefTable(
				ProcessDefId		INTEGER		NOT NULL, 
				ExtMethodParamIndex	INTEGER		NOT NULL,
				ExtMethodIndex		INTEGER		NOT NULL,
				ParameterName		NVARCHAR(64),
				ParameterType		SMALLINT	CHECK (ParameterType in (0, 3, 4, 6, 8, 10, 11)),
				ParameterOrder		SMALLINT,
				DataStructureId		INTEGER,
				PRIMARY KEY(ProcessDefId, ExtMethodIndex, ExtMethodParamIndex)
			)
		')
	End

	/* Create table ExtMethodParamMappingTable */
	IF NOT EXISTS (
		SELECT * FROM SYSObjects
		WHERE	name	= 'ExtMethodParamMappingTable'
		AND	xType	= 'U'
	)
	Begin
		EXECUTE('
			CREATE TABLE ExtMethodParamMappingTable(
				ProcessDefId		INTEGER		NOT NULL,
				ActivityId		INTEGER		NOT NULL,
				RuleId			INTEGER		NOT NULL,
				RuleOperationOrderId	SMALLINT	NOT NULL,
				ExtMethodIndex		INTEGER		NOT NULL,
				MapType			NVARCHAR(1)	CHECK(MapType IN (N''F'', N''R'')),
				ExtMethodParamIndex	INTEGER		NOT NULL,
				MappedField		NVARCHAR(255),
				MappedFieldType		NVARCHAR(1)	CHECK(MappedFieldType IN (N''Q'', N''F'', N''C'', N''S'', N''I'', N''U'', N''M'')),
				DataStructureId		INTEGER		NOT NULL
			)
		')
	End

	/* Create table ConstantDefTable */
	IF NOT EXISTS (
		SELECT * FROM SYSObjects
		WHERE	name	= 'ConstantDefTable'
		AND	xType	= 'U'
	)
	Begin
		EXECUTE('
			CREATE TABLE ConstantDefTable(
				ProcessDefId		INTEGER		NOT NULL,	
				ConstantName		NVARCHAR(64)	NOT NULL,
				ConstantValue		NVARCHAR(255),
				LastModifiedOn		DATETIME	NOT NULL,
				PRIMARY KEY (ProcessDefId, ConstantName)
			)
		')
	End

	/* SrNo-2, New tables for WebServices invoker - Mandep Kaur/ Ruhi Hira; WFS_6.1.2_008 */
	/* Create table WFDataStructureTable */
	IF NOT EXISTS (
		SELECT * FROM SYSObjects
		WHERE	name	= 'WFDataStructureTable'
		AND	xType	= 'U'
	)
	Begin
		EXECUTE('
			CREATE TABLE WFDataStructureTable (
				DataStructureId		Int,
				ProcessDefId		Int,
				ActivityId		Int,
				ExtMethodIndex		Int,
				Name			NVarchar(256),
				Type			SmallInt,
				ParentIndex		Int,
				PRIMARY KEY		(ProcessDefId, ExtMethodIndex, DataStructureId)
			)
		')
	End

	/* Create table WFWebServiceTable */
	IF NOT EXISTS (
		SELECT * FROM SYSObjects
		WHERE	name	= 'WFWebServiceTable'
		AND	xType	= 'U'
	)
	Begin
		EXECUTE('
			CREATE TABLE WFWebServiceTable (
				ProcessDefId		Int,
				ActivityId		Int,
				ExtMethodIndex		Int,
				ProxyEnabled		NVarchar(1),
				TimeOutInterval		Int,
				InvocationType		NVarchar(1),
				PRIMARY KEY		(ProcessDefId, ActivityId)
			)
		')
	End

	/* SrNo-2, New field DataStructureId added for Web Service Invoker - Ruhi Hira */
	/* Adding column DataStructureId in ExtMethodParamDefTable */
	IF NOT EXISTS(
		SELECT * FROM SYSColumns
		WHERE id = (
			SELECT id FROM SYSObjects 
			WHERE name = 'ExtMethodParamDefTable' 
			AND xType = 'U'
		)
		AND name = 'DataStructureId'
	)
	Begin
		EXECUTE('
			ALTER TABLE ExtMethodParamDefTable ADD DataStructureId Int NULL
		')
	End

	IF EXISTS(
		SELECT * FROM SYSColumns
		WHERE id = (
			SELECT id FROM SYSObjects 
			WHERE name = 'ExtMethodParamDefTable' 
			AND xType = 'U'
		)
		AND name = 'DataStructureId'
	)
	Begin
		EXECUTE('
			ALTER TABLE ExtMethodParamDefTable Alter Column DataStructureId Int NULL
		')
	End

	/* Adding column DataStructureId in ExtMethodParamMappingTable */
	IF NOT EXISTS(
		SELECT * FROM SYSColumns
		WHERE id = (
			SELECT id FROM SYSObjects 
			WHERE name = 'ExtMethodParamMappingTable' 
			AND xType = 'U'
		)
		AND name = 'DataStructureId'
	)
	Begin
		EXECUTE('
			ALTER TABLE ExtMethodParamMappingTable ADD DataStructureId Int NULL
		')
	End

	/* Adding + Initializing column IntroducedAt in ProcessInstanceTable */
	IF NOT EXISTS(
		SELECT * FROM SYSColumns
		WHERE id = (
			SELECT id FROM SYSObjects 
			WHERE name = 'ProcessInstanceTable' 
			AND xType = 'U'
		)
		AND name = 'IntroducedAt'
	)
	Begin
		EXECUTE('
			ALTER TABLE ProcessInstanceTable add IntroducedAt NVarchar(30)
		')
		EXECUTE('
			UPDATE ProcessInstanceTable 
			SET introducedAt = (SELECT	activityName 
						FROM	activitytable 
						WHERE	processDefId	= processInstanceTable.processdefId 
						AND	activityType	= 1
					)
		')
	End

	/* Updating ActivityTable */
	UPDATE Activitytable SET primaryActivity = 'Y' where activityType = 1
	
	/* Modifying ActivityTable, changing the datatype of column expiry.... */
	If Exists(
		Select 1 
		FROM SYSColumns
		WHERE	id = (
				Select id
				FROM	SYSObjects
				WHERE	name = 'ActivityTable'
				AND	xType = 'U'
			)
		AND	name = 'EXPIRY'
		AND	xType = 56
	)
	BEGIN
		Alter TABLE ActivityTable ALTER COLUMN expiry NVarchar(255)
		UPDATE ActivityTable SET expiry = ('0*24+' + expiry)
	END

	/* New table for Message Agent optimization */
	IF NOT EXISTS(SELECT * FROM SYSOBJECTS WHERE NAME = 'WFMessageInProcessTable')
	Begin
		Execute( 
			'Create Table WFMessageInProcessTable
			(
				messageId		INT, 
				message			NTEXT, 
				lockedBy		NVARCHAR(63), 
				status			NVARCHAR(1),
				ActionDateTime	DATETIME
			)')
		Print 'Table WFMessageInProcessTable created successfully'
	End
	ELSE
	Begin
		IF NOT EXISTS(SELECT * FROM SYSCOLUMNS WHERE NAME='ActionDateTime' AND id = (SELECT id FROM SYSOBJECTS WHERE NAME = 'WFMessageInProcessTable' AND XTYPE='U'))
		Begin
			Execute ('ALTER TABLE WFMessageInProcessTable ADD ActionDateTime DATETIME')
			Print 'Table WFMessageInProcessTable altered with new Column ActionDateTime'
		End
	End

	IF NOT EXISTS(SELECT * FROM sysIndexes WITH (NOLOCK) WHERE name = 'IX1_WFMessageInProcessTable')
	Begin
		CREATE INDEX IX1_WFMessageInProcessTable ON WFMessageInProcessTable (lockedBy)
		Print 'Index on lockedBy of WFMessageInProcessTable created successfully'
	End
	
	
	If Exists(	Select * 
			FROM SYSObjects 
			WHERE	name	= 'CURRENTROUTELOGTABLE'
			AND	xType	= 'U'
		)
		Begin
	IF NOT EXISTS(SELECT * FROM sysIndexes WITH (NOLOCK) WHERE name = 'IDX3_CRouteLogTable')
	Begin
		CREATE INDEX IDX3_CRouteLogTable ON CurrentRouteLogTable (ProcessInstanceId)
		Print 'Index on ProcessInstanceId of CurrentRouteLogTable created successfully'
	End
End
	
	
If Exists(	Select * 
			FROM SYSObjects 
			WHERE	name	= 'HistoryRouteLogTable'
			AND	xType	= 'U'
		)
		BEGIN
IF NOT EXISTS(SELECT * FROM sysIndexes WITH (NOLOCK) WHERE name = 'IDX3_HRouteLogTable')
	Begin
		CREATE INDEX IDX3_HRouteLogTable ON HistoryRouteLogTable (ProcessInstanceId)
		Print 'Index on ProcessInstanceId of HistoryRouteLogTable created successfully'
	End
END
	IF NOT EXISTS(SELECT * FROM sysIndexes WITH (NOLOCK) WHERE name = 'IDX2_QueueDataTable')
	Begin
		CREATE INDEX IDX2_QueueDataTable ON QueueDataTable (var_rec_1, var_rec_2)
		Print 'Index on var_rec_1, var_rec_2 of QueueDataTable created successfully'
	End

	IF NOT EXISTS(SELECT * FROM sysIndexes WITH (NOLOCK) WHERE name = 'IDX2_WorkListTable')
	Begin
		CREATE INDEX IDX2_WorkListTable ON WorkListTable (Q_QueueId)
		Print 'Index on Q_QueueId of WorkListTable created successfully'
	End

	IF NOT EXISTS(SELECT * FROM sysIndexes WITH (NOLOCK) WHERE name = 'IDX3_WorkListTable')
	Begin
		CREATE INDEX IDX3_WorkListTable ON WorkListTable (Q_QueueId, WorkItemState)
		Print 'Index on Q_QueueId, WorkItemState of WorkListTable created successfully'
	End

	IF NOT EXISTS(SELECT * FROM sysIndexes WITH (NOLOCK) WHERE name = 'IDX2_WorkInProcessTable')
	Begin
		CREATE INDEX IDX2_WorkInProcessTable ON WorkInProcessTable (Q_QueueId)
		Print 'Index on Q_QueueId of WorkInProcessTable created successfully'
	End

	IF NOT EXISTS(SELECT * FROM sysIndexes WITH (NOLOCK) WHERE name = 'IDX3_WorkInProcessTable')
	Begin
		CREATE INDEX IDX3_WorkInProcessTable ON WorkInProcessTable (Q_QueueId, WorkItemState)
		Print 'Index on Q_QueueId, WorkItemState of WorkInProcessTable created successfully'
	End

	IF NOT EXISTS(SELECT * FROM sysIndexes WITH (NOLOCK) WHERE name = 'IDX1_QueueStreamTable')
	Begin
		CREATE INDEX IDX1_QueueStreamTable ON QueueStreamTable (QueueId)
		Print 'Index on QueueId of QueueStreamTable created successfully'
	End

	IF NOT EXISTS(SELECT * FROM sysIndexes WITH (NOLOCK) WHERE name = 'IDX2_QueueDefTable')
	Begin
		CREATE INDEX IDX2_QueueDefTable ON QueueDefTable (QueueName)
		Print 'Index on QueueName of QueueDefTable created successfully'
	End

	IF NOT EXISTS(SELECT * FROM sysIndexes WITH (NOLOCK) WHERE name = 'IDX2_VarMappingTable')
	Begin
		CREATE INDEX IDX2_VarMappingTable ON VarMappingTable (UserDefinedName)
		Print 'Index on UserDefinedName of VarMappingTable created successfully'
	End

	IF NOT EXISTS(SELECT * FROM sysIndexes WITH (NOLOCK) WHERE name = 'IX2_WFMessageInProcessTable')
	Begin
		CREATE INDEX IX2_WFMessageInProcessTable ON WFMessageInProcessTable (messageId)
		Print 'Index on messageId of WFMessageInProcessTable created successfully'
	End

	IF NOT EXISTS(SELECT * FROM SYSOBJECTS WHERE NAME = 'WFFailedMessageTable')
	Begin
		Execute ('
		Create Table WFFailedMessageTable (
			messageId			INT, 
			message				NTEXT, 
			lockedBy			NVARCHAR(63), 
			status				NVARCHAR(1),
			failureTime			DATETIME,
			ActionDateTime			DATETIME
		)
		')
		Print 'Table WFFailedMessageTable created successfully'
	End
	ELSE
	Begin
		IF NOT EXISTS(SELECT * FROM SYSCOLUMNS WHERE  NAME='ActionDateTime' AND id = (SELECT id FROM SYSOBJECTS WHERE NAME = 'WFFailedMessageTable' AND XTYPE='U'))
		Begin
			Execute ('ALTER TABLE WFFailedMessageTable ADD ActionDateTime DATETIME')
			Print 'Table WFFailedMessageTable altered with new Column ActionDateTime'
		End
	End

	Begin Transaction Move

		EXECUTE('Insert Into WFFailedMessageTable Select messageId, message, null, status, getDate(), ActionDateTime From WFMessageTable Where status = ''F''')
		IF(@@error <> 0)
		Begin
			Print 'Error while inserting data from WFMessageTable to WFFailedMessageTable'
			Rollback Transaction Move
			Return
		End

		Delete From WFMessageTable Where status = 'F'
		IF(@@error <> 0)
		Begin
			Print 'Error while deleting failed records from WFMessageTable'
			Rollback Transaction Move
			Return
		End

		Update WFMessageTable Set LockedBy = null
		IF(@@error <> 0)
		Begin
			Print 'Error while updating lockedBy column in WFMessageTable'
			Rollback Transaction Move
			Return
		End

	Commit Transaction Move

	/* New table for feature Escalation */
	IF NOT EXISTS(Select * From sysObjects Where name = 'WFEscalationTable')
	Begin
		Create Table WFEscalationTable (
			EscalationId		Int	Identity,
			ProcessInstanceId	NVarchar(64),
			WorkitemId		Int,
			ProcessDefId		Int,
			ActivityId		Int,
			EscalationMode		NVarchar(20)	NOT NULL,
			ConcernedAuthInfo	NVarchar(256)	NOT NULL,
			Comments		NVarchar(512)	NOT NULL,
			Message			NText		NOT NULL,
			ScheduleTime		DateTime	NOT NULL
		)
		Print 'Table WFEscalationTable created successfully'

		CREATE NONCLUSTERED INDEX IX1_WFEscalationTable ON WFEscalationTable (EscalationMode, ScheduleTime)
	End

	/* New table for feature Escalation */
	IF NOT EXISTS(Select * From sysObjects Where name = 'WFEscInProcessTable')
	Begin
		Create Table WFEscInProcessTable (
			EscalationId		Int	Primary Key,
			ProcessInstanceId	NVarchar(64),
			WorkitemId		Int,
			ProcessDefId		Int,
			ActivityId		Int,
			EscalationMode		NVarchar(20),
			ConcernedAuthInfo	NVarchar(256),
			Comments		NVarchar(512),
			Message			NText,
			ScheduleTime		DateTime
		)
		Print 'Table WFEscInProcessTable created successfully'
	End

	/* New table for feature JMS Integration */
	IF NOT EXISTS(Select * From sysObjects Where name = 'WFJMSMESSAGETABLE')
	Begin
		  CREATE TABLE WFJMSMESSAGETABLE (
         messageId		INT			identity (1, 1), 
         message		NTEXT			NOT NULL, 
         destination		NVarchar(256),
         entryDateTime		DateTime,
	 OperationType		NVarchar(1)		
		)
	
		Print 'Table WFJMSMESSAGETABLE created successfully'
	End

	/* New table for feature JMS Integration */
	IF NOT EXISTS(Select * From sysObjects Where name = 'WFJMSMessageInProcessTable')
	Begin
		 Create Table WFJMSMessageInProcessTable (
         messageId		INT, 
         message		NTEXT, 
         destination		NVARCHAR(256), 
         lockedBy		NVARCHAR(63), 
         entryDateTime		DateTime, 
         lockedTime		DateTime,
	 OperationType		NVarchar(1)
		)
		Print 'Table WFJMSMessageInProcessTable created successfully'
	End
	
	
	
	/* New table for feature JMS Integration */
	IF NOT EXISTS(Select * From sysObjects Where name = 'WFJMSFailedMessageTable')
	Begin
		  Create Table WFJMSFailedMessageTable (
         messageId		INT, 
         message		NTEXT,  
         destination		NVARCHAR(256), 
         entryDateTime		DateTime, 
         failureTime		DateTime ,
	  failureCause		NVARCHAR(2000),
	 OperationType		NVarchar(1)
	
      )
 	
		Print 'Table WFJMSFailedMessageTable created successfully'
	End

	/* New table for feature JMS Integration */
	IF NOT EXISTS(Select * From sysObjects Where name = 'WFJMSDestInfo')
	Begin
		CREATE TABLE WFJMSDestInfo
		(
			destinationId	INT PRIMARY KEY,
			appServerIP	NVARCHAR(16),
			appServerPort	INT,
			appServerType	NVARCHAR(16),
			jmsDestName	NVARCHAR(256) NOT NULL,
			jmsDestType	NVARCHAR(1) NOT NULL
		)
 
		Print 'Table WFJMSDestInfo created successfully'
	End

	/* New table for feature JMS Integration */
	IF NOT EXISTS(Select * From sysObjects Where name = 'WFJMSPublishTable')
	Begin
		CREATE TABLE WFJMSPublishTable
			(
			processDefId	INT,
			activityId	INT,
			destinationId	INT,
			Template	NTEXT
			)

		Print 'Table WFJMSPublishTable created successfully'
	End


	/* New table for feature JMS Integration */
	IF NOT EXISTS(Select * From sysObjects Where name = 'WFJMSSubscribeTable')
	Begin
		CREATE TABLE WFJMSSubscribeTable
			(
			processDefId		INT,
			activityId		INT,
			destinationId		INT,
			extParamName		NVARCHAR(256),
			processVariableName	NVARCHAR(256),
			variableProperty	NVARCHAR(1)
			)
		Print 'Table WFJMSSubscribeTable created successfully'
	End
	
	
	/* SrNo-4 New Table for audit log configuration */
	IF NOT EXISTS(Select * From sysObjects Where name = 'WFVarStatusTable')
	Begin
		CREATE TABLE WFVarStatusTable 
		(
		ProcessDefId	int		NOT NULL ,
		VarName		nvarchar(50)	NOT NULL ,
		Status		nvarchar(1)	NOT NULL DEFAULT 'Y' CHECK (Status = 'Y' OR Status = 'N' )
		) 
		Print 'Table WFVarStatusTable created successfully'
	End
	
	/* SrNo-4 New Tables for audit log configuration */
	IF NOT EXISTS(Select * From sysObjects Where name = 'WFActionStatusTable')
	Begin
		CREATE TABLE WFActionStatusTable
		(
		ActionId	int		PRIMARY KEY ,
		Type		nvarchar(1)	NOT NULL DEFAULT 'C' CHECK (Type = 'C' OR Type = 'S' ),
		Status		nvarchar(1)	NOT NULL DEFAULT 'Y' CHECK (Status = 'Y' OR Status = 'N' )
		)
		Print 'Table WFActionStatusTable created successfully'
	End

	/* SrNo-5, Calendar Implementation - Ruhi Hira */
	IF NOT EXISTS(Select * From sysObjects Where name = 'WFCalDefTable')
	Begin
		CREATE TABLE WFCalDefTable(
			ProcessDefId	Int, 
			CalId		Int, 
			CalName		NVarchar(256)	NOT NULL UNIQUE,
			GMTDiff		Int,
			LastModifiedOn	DATETIME,
			Comments	NVarchar(1024),
			PRIMARY KEY	(ProcessDefId, CalId)
		)
		Print 'Table WFCalDefTable created successfully.'
		Insert into WFCalDefTable values(0, 1, 'DEFAULT 24/7', 530, getDate(), 'This is the default calendar')
		Print 'Default calendar created in WFCalDefTable.'
	End

	IF NOT EXISTS(Select * From sysObjects Where name = 'WFCalRuleDefTable')
	Begin
		CREATE TABLE WFCalRuleDefTable( 
			ProcessDefId	Int, 
			CalId		Int, 
			CalRuleId	Int, 
			Def		NVarchar(256), 
			CalDate		DateTime, 
			Occurrence	SmallInt, 
			WorkingMode	NVarChar(1), 
			DayOfWeek	SmallInt, 
			WEF		DateTime, 
			PRIMARY KEY	(ProcessDefId, CalId, CalRuleId)
		)
		Print 'Table WFCalRuleDefTable created successfully'
	End

	IF NOT EXISTS(Select * From sysObjects Where name = 'WFCalHourDefTable')
	Begin
		CREATE TABLE WFCalHourDefTable(
			ProcessDefId	Int		NOT NULL,
			CalId		Int		NOT NULL,
			CalRuleId	Int		NOT NULL,
			RangeId		Int		NOT NULL,
			StartTime	Int,
			EndTime		Int,
			PRIMARY KEY (ProcessDefId, CalId, CalRuleId, RangeId)
		)
		Print 'Table WFCalHourDefTable created successfully'
		Insert into WFCalHourDefTable values (0, 1, 0, 1, 0000, 2400)
		Print 'Hour range for default calendar added to WFCalHourDefTable.'
	End

	IF NOT EXISTS(Select * From sysObjects Where name = 'WFCalendarAssocTable')
	Begin
		CREATE TABLE WFCalendarAssocTable(
			CalId		Int		NOT NULL,
			ProcessDefId	Int		NOT NULL,
			ActivityId	Int		NOT NULL,
			CalType		NVarChar(1)	NOT NULL,
			UNIQUE (processDefId, activityId)
		)
		Print 'Table WFCalendarAssocTable created successfully'
	End

/* Added By Varun Bhansaly On 23/07/2007 */
	If Not Exists (Select * from SysObjects Where xType = 'U' and name = 'SuccessLogTable')
	Begin
		EXECUTE('
			CREATE TABLE SuccessLogTable(
				LogId INT,
				ProcessInstanceId NVARCHAR(63)
			)
		')
	End

	/* Added By Varun Bhansaly On 23/07/2007 */
	If Not Exists (Select * from SysObjects Where xType = 'U' and name = 'FailureLogTable')
	Begin
		EXECUTE('
			CREATE TABLE FailureLogTable(
				LogId INT,
				ProcessInstanceId NVARCHAR(63)
			)
		')
	End

	/* Populate RuleOperationTable for distributeTo entries */
	If Exists(	Select * 
			FROM SYSObjects 
			WHERE	name	= 'DistributeActivityTable'
			AND	xType	= 'U'
		)
	Begin
		Declare dist_cur CURSOR FAST_FORWARD FOR
			SELECT processDefId, activityId, targetActivityId FROM DistributeActivityTable
		Open dist_cur
		FETCH NEXT FROM dist_cur INTO @processDefId, @activityId, @targetActivityId
		Begin Transaction dist_Tran
			WHILE(@@FETCH_STATUS = 0)
			BEGIN
				Insert Into RuleOperationTable (
						ProcessDefId, ActivityId, RuleType, RuleId, OperationType,  Param1, 
						Type1, ExtObjID1, Param2, Type2, ExtObjID2, Param3, 
						Type3, ExtObjID3, Operator, OperationOrderId, CommentFlag
					)
						Select @processDefId, @activityId, N'D', 1, 21, 
							(SELECT activityName 
								FROM ActivityTable 
								WHERE activityId = @targetActivityId
								AND ActivityTable.processDefId = @processDefId), 
							N'V', 0, N' ', N'V', 0, N'', N'', 0, 0, 
							ISNULL((Select (Max(OperationOrderId) + 1) 
									From RuleOperationTable 
									Where	processDefId	= @processDefId
									AND	activityId	= @activityId
									AND	operationType	= 21
									AND	ruleType	= 'D'
									AND	ruleId		= 1),
								1), 
							N'N'

				If(@@ERROR <> 0 OR @@ROWCOUNT <= 0)
				Begin
					Rollback Transaction dist_Tran
					Close dist_cur
					Deallocate dist_cur
					Return
				End
				FETCH NEXT FROM dist_cur INTO @processDefId, @activityId, @targetActivityId
			END
		Commit Transaction dist_Tran
		Close dist_cur
		Deallocate dist_cur

		Declare cursor1 CURSOR FAST_FORWARD FOR
			SELECT processDefId, activityId FROM RULEOPERATIONTABLE WHERE RuleType = N'D' group by processDefId, activityId
			Open cursor1
			FETCH NEXT FROM cursor1 INTO @processDefId, @activityId
			BEGIN Transaction transaction1
			WHILE(@@FETCH_STATUS = 0)
			BEGIN
				Declare cursor2 CURSOR FAST_FORWARD FOR
					SELECT distinct(ruleId) FROM RULEOPERATIONTABLE WHERE RuleType = N'D' AND processDefId = @processDefId AND activityId = @activityId
					Open cursor2
					FETCH NEXT FROM cursor2 INTO @ruleId
					WHILE(@@FETCH_STATUS = 0)
					BEGIN
						IF NOT Exists (Select * from RULECONDITIONTABLE WHERE RuleType = N'D' AND ruleId = @ruleId AND processDefId = @processDefId AND activityId = @activityId)
						BEGIN 
								Insert Into RULECONDITIONTABLE (
										ProcessDefId, ActivityId, RuleType, 
										RuleOrderId, RuleId, ConditionOrderId,  
										Param1,	Type1, ExtObjID1, 
										Param2, Type2, ExtObjID2, 
										Operator, LogicalOp)
										Values 
										(@processDefId, @activityId, N'D', 
										@ruleId, @ruleId, @ruleId, 
										N'ALWAYS', N'S', 0, 
										N'ALWAYS', N'S', 0, 
										4, 4)
		
								If(@@ERROR <> 0)
								Begin
									Rollback Transaction transaction1
									Close cursor1
									Deallocate cursor1
									
									Close cursor2
									Deallocate cursor2
									Return
								End
						END
						FETCH NEXT FROM cursor2 INTO @ruleId
					END
				CLOSE cursor2
				DEALLOCATE cursor2
				FETCH NEXT FROM cursor1 INTO @processDefId, @activityId
			END	
			Commit Transaction transaction1
			CLOSE cursor1
			DEALLOCATE cursor1
		SELECT @dropFlag = 1
	End

	/* Drop table DistributeActivityTable */
	IF (	@dropFlag = 1 
		AND 
		EXISTS(
			SELECT	1 
			FROM	SYSObjects
			WHERE	name = 'DistributeActivityTable'
			AND	xType = 'U'
		)
	)
	Begin
		EXECUTE('
			Drop Table DistributeActivityTable
		')
	End

	/* Alter check constraint on ActivityTable.ServerInterface, allow E beside Y/ N */
	SELECT @tableId = Id FROM SYSObjects WHERE name = 'ActivityTable'
	SELECT @ConstraintName = B.name 
	FROM SYSConstraints A,	SYSObjects B
	WHERE	A.constId= B.Id 
	AND	B.xtype	= 'C' 
	AND	A.Id	= @tableId
	And	A.colid = (Select colId 
				FROM SYSColumns 
				WHERE Id = @tableId 
				AND name = 'ServerInterface')
	If(@@ROWCOUNT > 0)
	Begin
		EXECUTE('
			Alter Table ACTIVITYTABLE Drop CONSTRAINT ' + @constraintName
		)
		EXECUTE('
			ALTER TABLE ACTIVITYTABLE ADD CONSTRAINT CK_ACTTAB_SERINT 
					CHECK (ServerInterface IN (N''Y'', N''N'', N''E''))
		')
	End
	
	/* Alter table UserWorkAuditTable to modify the type of column - workitemCount */
	EXECUTE('
		Alter Table UserWorkAuditTable Alter Column 
			workitemCount	NVARCHAR(100)
	')

	/* Change for ProcessDefTable - Changes done by Ishu Saraf 13/01/09 */ 
	IF NOT EXISTS ( SELECT * FROM sysColumns 
			WHERE 
			id = (SELECT id FROM sysObjects WHERE NAME = 'ProcessDefTable')
			AND  NAME = 'CreatedOn'
			)
	BEGIN
		EXECUTE('
			ALTER TABLE ProcessDefTable 
			ADD	CreatedOn		DateTime, 
				WSFont			NVarChar(255), 
				WSColor			INTEGER, 
				CommentsFont	NVarchar(255), 
				CommentsColor	INTEGER, 
				BackColor		INTEGER 
		')

		IF NOT EXISTS ( SELECT * FROM sysColumns 
				WHERE 
				id = (SELECT id FROM sysObjects WHERE NAME = 'ProcessDefTable')
				AND  NAME = 'LastModifiedOn'
				)
		BEGIN
			EXECUTE('ALTER TABLE ProcessDefTable ADD LastModifiedOn DATETIME')
			EXECUTE('UPDATE ProcessDefTable SET LastModifiedOn = getDate(), CreatedOn = getDate()')
		END
		ELSE
			EXECUTE('UPDATE ProcessDefTable SET CreatedOn = LastModifiedOn')
	END

	IF NOT EXISTS(SELECT * FROM WFCabVersionTable WHERE CabVersion = '7.2_ProcessDefTable') /* Check entry in WFCabVersionTable */
	BEGIN
		EXECUTE SP_RENAME 'ProcessDefTable', 'TempProcessDefTable'
		EXECUTE(
			'CREATE TABLE ProcessDefTable (
				ProcessDefId			INT				PRIMARY KEY,
				VersionNo				SMALLINT		NOT NULL ,
				ProcessName				NVARCHAR(30)	NOT NULL ,
				ProcessState			NVARCHAR(10)	NULL ,
				RegPrefix				NVARCHAR(20)	NOT NULL ,
				RegSuffix				NVARCHAR(20)	NULL ,
				RegStartingNo			INT				NULL,
				ProcessTurnAroundTime	INT				NULL,
				RegSeqLength			INT				NULL,
				CreatedOn				DATETIME		NULL, 
				LastModifiedOn			DATETIME		NULL,
				WSFont					NVARCHAR(255)	NULL,
				WSColor					INT				NULL,
				CommentsFont			NVARCHAR(255)	NULL,
				CommentsColor			INT				NULL,
				Backcolor				INT				NULL
			)'
		)
		PRINT 'Table ProcessDefTable Created successfully.....'	 

		BEGIN TRANSACTION trans
			EXECUTE(' INSERT INTO ProcessDefTable SELECT ProcessDefId, VersionNo, ProcessName, ProcessState, RegPrefix, RegSuffix, RegStartingNo, ProcessTurnAroundTime, RegSeqLength, CreatedOn, LastModifiedOn, WSFont, WSColor, CommentsFont, CommentsColor, Backcolor FROM TempProcessDefTable ')
			EXECUTE('DROP TABLE TempProcessDefTable')
			PRINT 'Table TempProcessDefTable dropped successfully...........'
			EXECUTE('INSERT INTO WFCabVersionTable(cabVersion, creationDate, lastModified, Remarks, Status) VALUES (N''7.2_ProcessDefTable'', GETDATE(), GETDATE(), N''BPEL Compliant OmniFlow'', N''Y'')')
		COMMIT TRANSACTION trans
	END	

	/* Dropping Constraints on VarAliasTable */
	SELECT @tableId = Id 
	FROM SYSObjects 
	WHERE name = 'VarAliasTable'
	SELECT	@ConstraintName = B.name 
	FROM	SYSConstraints A, SYSObjects B
	WHERE	A.constId = B.Id 
	AND B.xtype	= 'C' 
	AND A.Id	= @tableId
	And A.colid = (Select colId 
			FROM SYSColumns 
			WHERE Id = @tableId 
			AND name = 'Type1')
	If(@@ROWCOUNT > 0)
	Begin
		Execute ('
			Alter Table VarAliasTable 
				Drop CONSTRAINT ' + @constraintName
		)
	End
	Execute('
		ALTER TABLE VarAliasTable ALTER Column 
			Type1	Char(1) NULL
	') 

	/* Altering Constraint on ExtMethodDefTable, WFS_6.1.2_009 */
	SELECT @tableId = Id 
	FROM SYSObjects 
	WHERE name = 'ExtMethodDefTable'
	
	SELECT	@ConstraintName = B.name 
	FROM	SYSConstraints A, SYSObjects B
	WHERE	A.constId = B.Id 
	AND B.xtype	= 'C' 
	AND A.Id	= @tableId
	And A.colid = (Select colId 
			FROM SYSColumns 
			WHERE Id = @tableId 
			AND name = 'ReturnType')
	If(@@ROWCOUNT > 0)
	Begin
		Execute ('
			Alter Table ExtMethodDefTable 
				Drop CONSTRAINT ' + @constraintName
		)
		EXECUTE('
			ALTER TABLE ExtMethodDefTable ADD CONSTRAINT CK_EXTMETHOD_RET 
					CHECK (ReturnType in (0, 3, 4, 6, 8, 10, 11, 12, 15, 16))
		')
	End

	/* Altering Constraint on ExtMethodParamDefTable */
	SELECT @tableId = Id 
	FROM SYSObjects 
	WHERE name = 'ExtMethodParamDefTable'
	
	SELECT	@ConstraintName = B.name 
	FROM	SYSConstraints A, SYSObjects B
	WHERE	A.constId = B.Id 
	AND B.xtype	= 'C' 
	AND A.Id	= @tableId
	And A.colid = (Select colId 
			FROM SYSColumns 
			WHERE Id = @tableId 
			AND name = 'ParameterType')
	If(@@ROWCOUNT > 0)
	Begin
		Execute ('
			Alter Table ExtMethodParamDefTable 
				Drop CONSTRAINT ' + @constraintName
		)
		EXECUTE('
			ALTER TABLE ExtMethodParamDefTable ADD CONSTRAINT CK_EXTMETHODPARAM_PARAM 
					CHECK (ParameterType in (0, 3, 4, 6, 8, 10, 11, 12, 15, 16))
		')
	End

	/* Altering Constraint on QueueStreamTable WFS_6.1.2_043 */
	IF NOT EXISTS( Select 1 from  queuestreamtable group by processdefid, ActivityId, StreamId having count(*) > 1 )
		Begin
			Alter Table queuestreamtable drop constraint QST_PRIM
			Alter Table queuestreamtable Add constraint QST_PRIM Primary Key (ProcessDefId, ActivityId, StreamId)
			Print 'Primary Key updated for QueueStreamTable';  
		End
	ELSE
		Begin
			Print 'Invalid Data in QueueStreamTable';
		End
	/* END Altering Constraint on QueueStreamTable WFS_6.1.2_043 */

	/* Drop Trigger Update_Finalization_Status */
	If EXISTS (
		SELECT * 
		FROM SYSObjects
		WHERE	name	= 'Update_Finalization_Status'
		AND	xType	= 'TR'
	)
	Begin
		Execute('
			DROP TRIGGER Update_Finalization_Status
		')
	End

	/* Drop Trigger TR_LOG_PDBCONNECTION */
	If EXISTS (
		SELECT * 
		FROM SYSObjects
		WHERE	name	= 'TR_LOG_PDBCONNECTION'
		AND	xType	= 'TR'
	)
	Begin
		Execute('
			DROP TRIGGER TR_LOG_PDBCONNECTION
		')
	End

	/* Create Trigger TR_LOG_PDBCONNECTION */
	/*
	Check applied for currentroutelog and wfcurrentroutelogtable
	*/
If Exists(SELECT * 
		FROM SYSObjects
		WHERE	name	= 'CurrentRouteLogTable'
		AND	xType	= 'U')
Begin		
	If NOT EXISTS (
		SELECT * 
		FROM SYSObjects
		WHERE	name	= 'TR_LOG_PDBCONNECTION'
		AND	xType	= 'TR'
	)
	Begin
		Execute('
			CREATE TRIGGER TR_LOG_PDBCONNECTION
			ON PDBCONNECTION
			FOR INSERT,DELETE
			AS 
				DECLARE 
				@deleteCnt	int,
				@insertCnt	int,
				@userid		int,
				@username	nvarchar(63)
			BEGIN
				SELECT @deleteCnt = COUNT(*) from Deleted
				SELECT @insertCnt = COUNT(*) from INSERTED
				IF (@deleteCnt>0)
				BEGIN
					select @userId = userindex from deleted
					select @userName = username from pdbuser where userindex = @userid
			 
					Insert into CurrentRouteLogTable( 
						ProcessDefId, ActivityId, ProcessInstanceId, WorkItemId, 
						UserId, ActionId, ActionDateTime, AssociatedFieldId, 
						AssociatedFieldName, ActivityName, UserName 
						) 
					values (0, 0, null, 0, 
						@userid, 24, getdate(), @userid, 
						@username, null, @username
						)
			 
				END
				ELSE IF(@insertCnt >0)
				BEGIN
					select @userId = userindex from inserted 
					select @userName = username from pdbuser where userindex = @userid
			 
					Insert into CurrentRouteLogTable( 
						ProcessDefId, ActivityId, ProcessInstanceId, WorkItemId, 
						UserId, ActionId, ActionDateTime, AssociatedFieldId, 
						AssociatedFieldName, ActivityName, UserName 
						)
					values (0, 0, null, 0, 
						@userid, 23, getdate(), @userid, 
						@username, null, @username
						)
				END
			END
		')
	End
End
If Exists(SELECT * 
		FROM SYSObjects
		WHERE	name	= 'WFCurrentRouteLogTable'
		AND	xType	= 'U')
Begin		
	If NOT EXISTS (
		SELECT * 
		FROM SYSObjects
		WHERE	name	= 'TR_LOG_PDBCONNECTION'
		AND	xType	= 'TR'
	)
	Begin
		Execute('
			CREATE TRIGGER TR_LOG_PDBCONNECTION
			ON PDBCONNECTION
			FOR INSERT,DELETE
			AS 
				DECLARE 
				@deleteCnt	int,
				@insertCnt	int,
				@userid		int,
				@username	nvarchar(63)
			BEGIN
				SELECT @deleteCnt = COUNT(*) from Deleted
				SELECT @insertCnt = COUNT(*) from INSERTED
				IF (@deleteCnt>0)
				BEGIN
					select @userId = userindex from deleted
					select @userName = username from pdbuser where userindex = @userid
			 
					Insert into WFCurrentRouteLogTable( 
						ProcessDefId, ActivityId, ProcessInstanceId, WorkItemId, 
						UserId, ActionId, ActionDateTime, AssociatedFieldId, 
						AssociatedFieldName, ActivityName, UserName 
						) 
					values (0, 0, null, 0, 
						@userid, 24, getdate(), @userid, 
						@username, null, @username
						)
			 
				END
				ELSE IF(@insertCnt >0)
				BEGIN
					select @userId = userindex from inserted 
					select @userName = username from pdbuser where userindex = @userid
			 
					Insert into WFCurrentRouteLogTable( 
						ProcessDefId, ActivityId, ProcessInstanceId, WorkItemId, 
						UserId, ActionId, ActionDateTime, AssociatedFieldId, 
						AssociatedFieldName, ActivityName, UserName 
						)
					values (0, 0, null, 0, 
						@userid, 23, getdate(), @userid, 
						@username, null, @username
						)
				END
			END
		')
	End
End

	/* SrNo-1, For license implementation, type of column data is changed from Text to NVarchar(2000) - Ruhi */

	If exists (	SELECT 1 
			From SYSColumns 
			Where id = (Select id From sysObjects Where name = 'PSRegisterationTable' and xType = 'U')
			AND name = 'Data' 
			AND xType = 99 )
	Begin
		Select PSId, PSName, Type, SessionId, ProcessDefId, Convert(NVarchar(2000), Data) Data
		Into	TempPSRegisterationTable
		From	PSRegisterationtable

		Execute('Drop Table PSRegisterationtable')

		Execute SP_RENAME 'TempPSRegisterationtable', 'PSRegisterationtable'
	End 

	/* Bugzilla Id 95, Comment -> Commnt, 28/08/2006 - Ruhi Hira*/
	If exists(Select * From SysObjects Where name = 'WFGROUPVIEW' and xType = 'V')
		Execute('Drop View WFGROUPVIEW')
	EXECUTE('
		CREATE VIEW WFGROUPVIEW 
		AS 
		SELECT groupindex, groupname, CreatedDatetime, expiryDATETIME, 
			privilegecontrollist, owner, comment as commnt, grouptype, maingroupindex 
		FROM PDBGROUP
	')
	/* 
	   Added By   : Varun Bhansaly
	   Added On   : 09/01/2007
	   Reason     : Bugzilla Bug 370
	   *****************************
	   IMPORTANT :: IN FUTURE, WHEN MAIL LOGGING FEATURE IS IMPLEMENTED IN OMNIFLOW (v7.X OR LATER) 
					THE SQL STATEMENTS WRITTEN BELOW SHOULD BE REMOVED FROM THIS FILE.
	   ****************************
	*/

	/* actionId for WFL_Constant_Updated = 78 */
	If Exists(	Select * 
			FROM SYSObjects 
			WHERE	name	= 'CURRENTROUTELOGTABLE'
			AND	xType	= 'U'
		)
BEGIN
	UPDATE CURRENTROUTELOGTABLE SET actionId = 78 where actionId = 70
	/*  actionId for WFL_WorkItemSuspended = 79 */
	UPDATE CURRENTROUTELOGTABLE SET actionId = 79 where actionId = 71
END
	/* Added By Varun Bhansaly On 23/07/2007 */
	UPDATE ActivityTable SET expiry = ('0*24 + ' + expiry) where expiry IS NOT NULL AND expiry != '0' AND CHARINDEX('*', expiry) = 0 
    UPDATE ActivityTable SET expiry = null where expiry = '0'

	/* Create table CheckOutProcessesTable */
	IF NOT EXISTS (SELECT * FROM SYSObjects	WHERE name = 'CheckOutProcessesTable' AND xType	= 'U')
	BEGIN
		EXECUTE('CREATE TABLE CheckOutProcessesTable( 
				ProcessDefId            INTEGER			NOT NULL,
				ProcessName             NVARCHAR(30)	NOT NULL, 
				CheckOutIPAddress       VARCHAR(50)		NOT NULL, 
				CheckOutPath            NVARCHAR(255)   NOT NULL,
				ProcessStatus			NVARCHAR(1)		NULL
			)
		')
	END
End

~

If Exists (Select * from SysObjects Where xType = 'P' and name = 'Upgradation_RightsManagement')
Begin
	Execute('DROP PROCEDURE Upgradation_RightsManagement')
	Print 'Procedure Upgradation_RightsManagement, Part of Upgrade already exists, hence older one dropped ..... '
End

~

Create Procedure Upgradation_RightsManagement as 
 begin
	declare @ProcessFolderName varchar(30)
	declare @QueueFolderName varchar(30)
	declare @imageVolumeIndex int
	declare @processName varchar(30)
	declare @queueName varchar(63)
	declare @folderId int
	declare @documentId int
	declare @order int
	
	Set @imageVolumeIndex = null
	Set @ProcessFolderName = 'ProcessFolder'
	Set @QueueFolderName = 'QueueFolder'
	Select @imageVolumeIndex = imageVolumeIndex from PDBFolder Where FolderIndex = 0
	
	Update PDBDocument set appname = 'TXT' where appname = 'TX'
	
	If(@imageVolumeIndex is null)
	begin
		Print '!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!'
		Print '  Check this case No Record Found in PDBFolder for FolderIndex 0'
		Print '!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!'
		return
	end

	If NOT EXISTS (Select * from PDBFolder where Name = @ProcessFolderName)
	begin
		Begin Transaction process_trans
			Insert Into PDBFolder(
				ParentFolderIndex, Name, Owner, CreatedDatetime, RevisedDateTime,
				AccessedDateTime, DataDefinitionIndex, AccessType, ImageVolumeIndex,
				FolderType, FolderLock, LockByUser, Location, DeletedDateTime, 
				EnableVersion, ExpiryDateTime, Comment, UseFulData, ACL, FinalizedFlag,
				FinalizedDateTime, FinalizedBy, ACLMoreFlag, MainGroupId, EnableFTS, 
				LockMessage, FolderLevel, Hierarchy
				)
			values (
				0, @ProcessFolderName, 1, getDate(), getDate(),
				getDate(), 0, 'S', @imageVolumeIndex,
				'G', 'N', null, 'G', '2055-12-31 00:00:00.000',
				'N', '2055-12-31 00:00:00.000', '', null, 'G1#010000, ', 'N',
				getDate(), 0, 'N', 0, 'N',
				null, 2, '0.'
				)

			Select @folderId = FolderIndex from PDBFolder Where Name = @ProcessFolderName

			Declare process_cursor CURSOR FAST_FORWARD FOR
				Select Distinct(ProcessName) From ProcessDefTable
			
			Open process_cursor
			FETCH NEXT FROM process_cursor INTO @processName
			
			Set @order = 0

			WHILE(@@FETCH_STATUS <> -1)
			BEGIN
				IF (@@FETCH_STATUS <> -2)
				BEGIN
					If NOT EXISTS (		
						Select * from pdbdocument inner join pdbdocumentcontent
						on pdbdocument.documentIndex = pdbdocumentContent.documentIndex 
						and parentFolderindex = @folderId and name = @processName
					)
					begin
						set @order = @order + 1
						Insert Into PDBDocument	(
							VersionNumber, VersionComment, Name, Owner, CreatedDateTime,
							RevisedDateTime, AccessedDateTime, DataDefinitionIndex,
							Versioning, AccessType, DocumentType, CreatedbyApplication,
							CreatedbyUser, ImageIndex, VolumeId, NoOfPages, DocumentSize,
							FTSDocumentIndex, ODMADocumentIndex, HistoryEnableFlag,
							DocumentLock, LockByUser, Comment, Author, TextImageIndex,
							TextVolumeId, FTSFlag, DocStatus, ExpiryDateTime, 
							FinalizedFlag, FinalizedDateTime, FinalizedBy, CheckOutstatus,
							CheckOutbyUser, UseFulData, ACL, PhysicalLocation, ACLMoreFlag,
							AppName, MainGroupId, PullPrintFlag, ThumbNailFlag, 
							LockMessage 
							) 
						values(
							1.0, 'Original', @processName, 1, getDate(),
							getDate(), getDate(), 0,
							'N', 'S', 'N', 0, 
							1, -1, -1, 0, 0,
							0, 'not defined', 'N', 
							'N', null, '', 'supervisor', 0, 
							0, 'XX', 'A', '2099-12-12 00:00:00.000', 
							'N', '2099-12-12 00:00:00.000', 0, 'N',
							0, null, null, 'not defined', 'N',
							'txt', 0, 'N', 'N', 
							null
							)
			
						Select @documentId = DocumentIndex from PDBDocument 
						Where Name = @processName
						
						Insert Into PDBDocumentContent	(
							ParentFolderIndex, DocumentIndex, FiledBy, FiledDatetime,
							DocumentOrderNo, RefereceFlag, DocStatus
							) 
						values(
							@folderId, @documentId, 1, getDate(),
							@order, 'O', 'A'
							)
					end 
					else 
					begin 
						Print '!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!'
						Print '  Check this case Some Document exists with name ' + @ProcessName
						Print '!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!'
					end 
					FETCH NEXT FROM process_cursor INTO @processName 
				END 
			END 

			Close process_cursor 
			Deallocate process_cursor 
		
		Commit Transaction process_trans 
	end 
	else 
	begin 
		Print '!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!' 
		Print '  Check this case Some Folder exists with name ' + @ProcessFolderName 
		Print '!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!' 
	end 

	If NOT EXISTS (Select * from PDBFolder where Name = @QueueFolderName)
	begin
		Begin Transaction queue_trans
			Insert Into PDBFolder(
				ParentFolderIndex, Name, Owner, CreatedDatetime, RevisedDateTime,
				AccessedDateTime, DataDefinitionIndex, AccessType, ImageVolumeIndex,
				FolderType, FolderLock, LockByUser, Location, DeletedDateTime, 
				EnableVersion, ExpiryDateTime, Comment, UseFulData, ACL, FinalizedFlag,
				FinalizedDateTime, FinalizedBy, ACLMoreFlag, MainGroupId, EnableFTS, 
				LockMessage, FolderLevel, Hierarchy) 
			values (
				0, @QueueFolderName, 1, getDate(), getDate(),
				getDate(), 0, 'S', @imageVolumeIndex,
				'G', 'N', null, 'G', '2055-12-31 00:00:00.000',
				'N', '2055-12-31 00:00:00.000', '', null, 'G1#010000, ', 'N',
				getDate(), 0, 'N', 0, 'N',
				null, 2, '0.')

	END;
	else 
	begin 
		Print '!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!'
		Print '  Check this case Some Folder exists with name ' + @QueueFolderName
		Print '!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!'
	end 
	BEGIN
			Begin Transaction queue_trans
			Select @folderId = FolderIndex from PDBFolder Where Name = @QueueFolderName

			Declare queue_cursor CURSOR FAST_FORWARD FOR
				Select QueueName From QueueDefTable
			Open queue_cursor
			FETCH NEXT FROM queue_cursor INTO @queueName
			
			set @order = 0

			WHILE(@@FETCH_STATUS <> -1)
			BEGIN
				IF (@@FETCH_STATUS <> -2)
				BEGIN
					If NOT EXISTS (		
						Select * from pdbdocument inner join pdbdocumentcontent
						on pdbdocument.documentIndex = pdbdocumentContent.documentIndex 
						and parentFolderindex = @folderId and name = @queueName
					)
					begin
						select @order = max(DocumentOrderNo) from pdbdocumentcontent where parentFolderindex = @folderId
						set @order = @order + 1
						Insert Into PDBDocument	(
							VersionNumber, VersionComment, Name, Owner, CreatedDateTime,
							RevisedDateTime, AccessedDateTime, DataDefinitionIndex,
							Versioning, AccessType, DocumentType, CreatedbyApplication,
							CreatedbyUser, ImageIndex, VolumeId, NoOfPages, DocumentSize,
							FTSDocumentIndex, ODMADocumentIndex, HistoryEnableFlag,
							DocumentLock, LockByUser, Comment, Author, TextImageIndex,
							TextVolumeId, FTSFlag, DocStatus, ExpiryDateTime, 
							FinalizedFlag, FinalizedDateTime, FinalizedBy, CheckOutstatus,
							CheckOutbyUser, UseFulData, ACL, PhysicalLocation, ACLMoreFlag,
							AppName, MainGroupId, PullPrintFlag, ThumbNailFlag, 
							LockMessage 
							) 
						values(
							1.0, 'Original', @queueName, 1, getDate(),
							getDate(), getDate(), 0,
							'N', 'S', 'N', 0, 
							1, -1, -1, 0, 0,
							0, 'not defined', 'N', 
							'N', null, '', 'supervisor', 0, 
							0, 'XX', 'A', '2099-12-12 00:00:00.000', 
							'N', '2099-12-12 00:00:00.000', 0, 'N',
							0, null, null, 'not defined', 'N',
							'txt', 0, 'N', 'N', 
							null
							)
			
						Select @documentId = DocumentIndex from PDBDocument 
						Where Name = @queueName
						
						Insert Into PDBDocumentContent	(
							ParentFolderIndex, DocumentIndex, FiledBy, FiledDatetime,
							DocumentOrderNo, RefereceFlag, DocStatus
							) 
						values(
							@folderId, @documentId, 1, getDate(),
							@order, 'O', 'A'
							)
					end 
					else 
					begin 
						Print '!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!'
						Print '  Check this case Some Document exists with name ' + @queueName
						Print '!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!'
					end 
					FETCH NEXT FROM queue_cursor INTO @queueName 
				END 
			END 

			Close queue_cursor
			Deallocate queue_cursor

		Commit Transaction queue_trans
	end 
end

~

exec Upgrade 

~

drop procedure Upgrade 

~

print 'Script Upgrade_Tables, part of Upgrade executed successfully, procedure DROPPED ...... ' 

~

exec Upgradation_RightsManagement 

~

drop procedure Upgradation_RightsManagement 

~

print 'Script Upgradation_RightsManagement, part of Upgrade executed successfully, procedure DROPPED ...... ' 

~

/*Added by Ishu Saraf - 14/01/2009 - Distribute Collect Case */

IF EXISTS (SELECT * FROM SysObjects WHERE xType = 'P' and NAME = 'WFCollectionUpgrade')
BEGIN
	EXECUTE('Drop Procedure WFCollectionUpgrade')
	PRINT 'Procedure WFCollectionUpgrade already exists, hence older one dropped ..... '
End

~

CREATE PROCEDURE WFCollectionUpgrade  
AS
BEGIN
	SET NOCOUNT ON

	DECLARE @var_ProcessInstanceId	NVARCHAR(126)
	DECLARE @var_WorkItemId			INT
	DECLARE @var_ParentWorkItemId	INT
	DECLARE @var_PreviousStage		NVARCHAR(60)
	DECLARE @var_PrimaryActivity	NVARCHAR(60)
	DECLARE @v_STR1					NVARCHAR(2000)

	IF NOT EXISTS (
		SELECT * FROM SYSObjects
		WHERE	NAME	= 'WFCollectUpgradeTable'
		AND	xType	= 'U'
	)
	BEGIN
		EXECUTE('
			CREATE TABLE WFCollectUpgradeTable (
					ProcessInstanceId	NVARCHAR(63)  	NOT NULL ,
					WorkItemId 			INT 			NOT NULL
			)
		')
		PRINT 'Table WFCollectUpgradeTable Created Successfully'		
	END

	IF NOT EXISTS(
		SELECT * FROM SYSColumns
		WHERE id = (
			SELECT id FROM SYSObjects 
			WHERE NAME = 'PendingWorkListTable' 
			AND xType = 'U'
		)
		AND NAME = 'NoOfCollectedInstances'
	)
	BEGIN
		EXECUTE('
			ALTER TABLE PendingWorkListTable 
			ADD NoOfCollectedInstances	INT			NOT NULL DEFAULT 0, 
				IsPrimaryCollected		NVARCHAR(1)		NULL CHECK (IsPrimaryCollected IN (N''Y'', N''N''))
		')
	END

	DECLARE collection_cursor CURSOR FAST_FORWARD FOR
	SELECT A.ProcessInstanceID, A.WorkitemID, A.ParentWorkitemID, 
	       A.PreviousStage, B.PrimaryActivity
	FROM PendingWorkListTable A, ActivityTable B
	WHERE A.ProcessDefID = B.ProcessDefID AND A.ActivityID = B.ActivityID AND B.ActivityType = 6

	OPEN collection_cursor
	FETCH collection_cursor INTO @var_ProcessInstanceId, @var_WorkItemId, @var_ParentWorkItemId, @var_PreviousStage, @var_PrimaryActivity

	IF (@@Fetch_Status = -1 OR  @@Fetch_Status = -2)
	BEGIN				
		CLOSE collection_cursor
		DEALLOCATE collection_cursor
		RETURN
	END

	WHILE(@@FETCH_STATUS  <> -1)
	BEGIN
		IF(@@FETCH_STATUS <> -2)
		BEGIN
			BEGIN TRANSACTION TRAN_COLLECT_UPGRADE

			DELETE FROM PendingWorkListTable WHERE ProcessInstanceId = @var_ProcessInstanceId and WorkItemId = @var_WorkItemId 
			IF(@@ERROR <> 0 OR @@ROWCOUNT = 0)
			BEGIN
				PRINT 'Deletion from PendingWorkListTable failed for ' + @var_ProcessInstanceId
				ROLLBACK TRANSACTION TRAN_COLLECT_UPGRADE
				BEGIN TRANSACTION TRAN_FAILED_WI
					EXECUTE(' INSERT INTO WFCollectUpgradeTable VALUES( N''' + @var_ProcessInstanceId + ''', ' + @var_WorkItemId + ')')
				COMMIT TRANSACTION TRAN_FAILED_WI
				GOTO ProcessNext
			END

			DELETE FROM QueueDataTable WHERE ProcessInstanceId = @var_ProcessInstanceId and WorkItemId = @var_WorkItemId 
			IF(@@ERROR <> 0 OR @@ROWCOUNT = 0)
			BEGIN
				PRINT 'Deletion from QueueDataTable failed for ' + @var_ProcessInstanceId
				ROLLBACK TRANSACTION TRAN_COLLECT_UPGRADE
				BEGIN TRANSACTION TRAN_FAILED_WI
					EXECUTE(' INSERT INTO WFCollectUpgradeTable VALUES( N''' + @var_ProcessInstanceId + ''', ' + @var_WorkItemId + ')')
				COMMIT TRANSACTION TRAN_FAILED_WI
				GOTO ProcessNext
			END

			SELECT @v_STR1 = ' UPDATE PendingWorkListTable SET NoOfCollectedInstances = NoOfCollectedInstances + 1 WHERE ProcessInstanceId = ''' + @var_ProcessInstanceId + ''' AND WorkItemId = ' + CONVERT(NVARCHAR(20), @var_ParentWorkItemId)
			EXECUTE(@v_STR1)
			IF(@@ERROR <> 0 OR @@ROWCOUNT = 0)
			BEGIN
				PRINT 'Updation of NoOfCollectedInstances failed for ' + @var_ProcessInstanceId
				ROLLBACK TRANSACTION TRAN_COLLECT_UPGRADE
				BEGIN TRANSACTION TRAN_FAILED_WI
					EXECUTE(' INSERT INTO WFCollectUpgradeTable VALUES( N''' + @var_ProcessInstanceId + ''', ' + @var_WorkItemId + ')')
				COMMIT TRANSACTION TRAN_FAILED_WI
				GOTO ProcessNext
			END

			IF @var_PreviousStage = @var_PrimaryActivity
			BEGIN
				SELECT @v_STR1 = ' UPDATE PendingWorkListTable SET IsPrimaryCollected = ''Y'' WHERE ProcessInstanceId = ''' + @var_ProcessInstanceId + ''' AND WorkItemId = ' + CONVERT(NVARCHAR(20), @var_ParentWorkItemId)
				EXECUTE(@v_STR1)
				IF(@@ERROR <> 0 OR @@ROWCOUNT = 0)
				BEGIN
					PRINT 'Updation of IsPrimaryCollected failed for ' + @var_ProcessInstanceId
					ROLLBACK TRANSACTION TRAN_COLLECT_UPGRADE
					BEGIN TRANSACTION TRAN_FAILED_WI
						EXECUTE(' INSERT INTO WFCollectUpgradeTable VALUES( N''' + @var_ProcessInstanceId + ''', ' + @var_WorkItemId + ')')
					COMMIT TRANSACTION TRAN_FAILED_WI
					GOTO ProcessNext
				END
			END

			COMMIT TRANSACTION TRAN_COLLECT_UPGRADE
		END
		
		ProcessNext:
		FETCH NEXT FROM collection_cursor INTO @var_ProcessInstanceId, @var_WorkItemId, @var_ParentWorkItemId, @var_PreviousStage, @var_PrimaryActivity
	END

	CLOSE collection_cursor
	DEALLOCATE collection_cursor
END

~

Print 'Stored Procedure WFCollectionUpgrade compiled successfully ........'

~

Print 'Executing procedure WFCollectionUpgrade'
Exec WFCollectionUpgrade

~

Print 'Dropping procedure WFCollectionUpgrade '
DROP PROCEDURE WFCollectionUpgrade

~