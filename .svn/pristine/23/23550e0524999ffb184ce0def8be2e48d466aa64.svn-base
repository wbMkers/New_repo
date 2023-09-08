

/*_____________________________________________________________________________________________________________________-
		NEWGEN SOFTWARE TECHNOLOGIES LIMITED

	Group						: Application – Products
	Product / Project			: WorkFlow
	Module						: Transaction Server
	File NAME					: Upgrade.sql (MS Sql Server)
	Author						: Sajid Ali Khan
	Date written (DD/MM/YYYY)	: 02/08/2013
	Description					: 
_______________________________________________________________________________________________________________________-
			CHANGE HISTORY
_______________________________________________________________________________________________________________________-
Date		Change By		Change Description (Bug No. (If Any))
15/11/2013	Sajid Khan		Bug 42190: Duration column was given null value in WFMileStoneTable
15/11/2013	Sajid Khan		Bug 42571: Issue while upgrading OF 8.0 cabinet to OF 10.0
15/11/2013	Sajid Khan		Bug 42570(requirement)-Insertion of rows in ExtDbFieldDefinitionTable.
27/11/2013	Sajid Khan		Changed reflected for Role Association With RMS in OF 10.1.
14-03-2014	Sajid Khan		Type of System Queues should be different than "S" as "S" is for Permanent type of queues[A - QueueType for System Defined Queues].
____________________________________________________________________
___________________________________________________-*/

If Exists (SELECT 1 FROM SYSObjects WHERE NAME = 'Upgrade' AND xType = 'P')
BEGIN
	Drop Procedure Upgrade
	PRINT 'As Procedure Upgrade exists dropping old procedure ........... '
END

PRINT 'Creating procedure Upgrade ........... '

~
Create Procedure Upgrade AS
BEGIN

	DECLARE @ProcessDefId		INT
	Declare @existsFlag			INT
	Declare @TableId 			INT
	Declare @ConfigurationId 	INT
	Declare @SAPconstrnName 	varchar(100)
	Declare @ConstraintName 	VARCHAR(255)
	DECLARE @PARAM1          	Varchar(256)
	DECLARE @VariableType    	INT
	DECLARE @v_VariableId    	INT
	DECLARE @quoteChar        char(1)  
    SET @quoteChar = char(39)  
	Declare @previousPid int
	

	/*............................................ Adding new Table .............................................*/
PRINT 'Creating procedure Upgrade 1........... '





	IF NOT EXISTS(SELECT * FROM sysObjects WHERE NAME = 'WFCabVersionTable')
	BEGIN
		Create Table WFCabVersionTable (
			cabVersion		NVARCHAR(255) NOT NULL,
			cabVersionId	INT IDENTITY (1,1) PRIMARY KEY,
			creationDate	DATETIME,
			lastModified	DATETIME,
			Remarks			NVARCHAR(255) NOT NULL,
			Status			NVARCHAR(1)
		)
		PRINT 'Table WFCabVersionTable created successfully'
	END
	ELSE
	BEGIN
		EXECUTE('Alter Table WFCabVersionTable Alter Column cabVersion NVARCHAR(255)')
		PRINT 'Table WFCabVersionTable altered with Column cabVersion size increased to 255'
		EXECUTE('Alter Table WFCabVersionTable Alter Column Remarks NVARCHAR(255)')
		PRINT 'Table WFCabVersionTable altered with Column Remarks size increased to 255'
	END

	/* New tables created for BPM 10.0 */
	

	IF NOT EXISTS (
			SELECT * FROM SYSObjects 
			WHERE NAME = 'WFAuditRuleTable' 
			AND xType = 'U'
		)
	BEGIN
		EXECUTE(' 
			CREATE TABLE WFAuditRuleTable(
				ProcessDefId	INT NOT NULL,
				ActivityId		INT NOT NULL,
				RuleId			INT NOT NULL,
				RandomNumber	NVARCHAR(50),
				CONSTRAINT PK_WFAuditRuleTable PRIMARY KEY(ProcessDefId,ActivityId,RuleId)
			)
		')
		PRINT 'Table WFAuditRuleTable created successfully.'
	END
	
	IF NOT EXISTS (
			SELECT * FROM SYSObjects 
			WHERE NAME = 'WFAuditTrackTable' 
			AND xType = 'U'
		)
	BEGIN
		EXECUTE(' 
			CREATE TABLE WFAuditTrackTable(
				ProcessInstanceId	NVARCHAR(255),
				WorkitemId			INT,
				SampledStatus		INT,
				CONSTRAINT PK_WFAuditTrackTable PRIMARY KEY(ProcessInstanceID,WorkitemId)
				
			)
		')
		PRINT 'Table WFAuditTrackTable created successfully.'
	END
	
	IF NOT EXISTS (
			SELECT * FROM SYSObjects 
			WHERE NAME = 'WFDocTypeSearchMapping' 
			AND xType = 'U'
		)
	BEGIN
		EXECUTE(' 
			CREATE TABLE WFDocTypeSearchMapping( 
			ProcessDefId 	INT		 		NOT NULL, 
			ActivityID 		INT		 		NOT NULL, 
			DCName 			NVARCHAR(30) 	NULL, 
			DCField 		NVARCHAR(30) 	NOT NULL, 
			VariableID 		INT		 		NOT NULL, 
			VarFieldID 		INT		 		NOT NULL, 
			MappedFieldType NVARCHAR(1) 	NOT NULL, 
			MappedFieldName NVARCHAR(255) 	NOT NULL, 
			FieldType 		INT		 		NOT NULL 
) 
		')
		PRINT 'Table WFDocTypeSearchMapping created successfully.'
	END
	
	IF NOT EXISTS (
			SELECT * FROM SYSObjects 
			WHERE NAME = 'WFActivitySequenceTABLE' 
			AND xType = 'U'
		)
	BEGIN
		EXECUTE(' 
			CREATE TABLE WFActivitySequenceTABLE(
				ProcessDefId 	INT 	NOT NULL,
				MileStoneId 	INT 	NOT NULL,
				ActivityId 		INT 	NOT NULL,
				SequenceId 		INT 	NOT NULL,
				SubSequenceId 	INT 	NOT NULL,
				CONSTRAINT pk_WFActivitySequenceTABLE PRIMARY KEY(ProcessDefId,MileStoneId,SequenceId,SubSequenceId)
			)
		')
/*inserting values for old processes*/		
		Declare @pSeqVar int
		Set @pSeqVar = 0
		Declare @nSeqVar int
		Set @nSeqVar = 0
		Declare @ActivityId int 
		Declare @ActivityType int
		
		Set @previousPid = 0

		DECLARE cur_actSeqId CURSOR FOR  
		Select b.processdefid ProcessDefId, a.activityid ActivityId, a.activitytype ActivityType from activitytable a inner join  processdeftable b on a.processdefid = b.processdefid order by processdefid, activityid
		OPEN cur_actSeqId
		FETCH NEXT FROM cur_actSeqId INTO @ProcessDefId,@ActivityId,@ActivityType

		WHILE @@FETCH_STATUS = 0 
		BEGIN
			If (@previousPid = @ProcessDefId)
			Begin
				If ((@ActivityType = 5) or (@ActivityType = 6) or (@ActivityType = 7))
				Begin
					set @nSeqVar = @nSeqVar -1
				End	
				Else
				Begin
					set @pSeqVar = @pSeqVar +1
				End
			End
			Else
			Begin
				If ((@ActivityType = 5) or (@ActivityType = 6) or (@ActivityType = 7))
				Begin
					set @nSeqVar = -1
				End	
				Else
				Begin
					set @pSeqVar = 1
				End
			End	
			If ((@ActivityType = 5) or (@ActivityType = 6) or (@ActivityType = 7))			
			Begin
				--	Update WFActivitySequenceTABLE set SequenceId = @nSeqVar, SubSequenceId = 0 where processdefid = @ProcessDefId and ActivityId = @ActivityId 
				Insert Into WFActivitySequenceTABLE values(@ProcessDefId, 1,@ActivityId,@nSeqVar, 0)
			End	
			Else
			Begin
				--Update WFActivitySequenceTABLE set SequenceId = @pSeqVar, SubSequenceId = 0 where processdefid = @ProcessDefId and ActivityId = @ActivityId 
				Insert Into WFActivitySequenceTABLE values(@ProcessDefId, 1,@ActivityId,@pSeqVar, 0)
			End
			set @previousPid = @processdefid
			FETCH NEXT FROM cur_actSeqId INTO @ProcessDefId,@ActivityId,@ActivityType
		END
		CLOSE cur_actSeqId   
		DEALLOCATE cur_actSeqId 
	/*End of inserting values for old processes*/		
		PRINT 'Table WFActivitySequenceTABLE created and updated Successfully.'
	END
	
	IF NOT EXISTS (
			SELECT * FROM SYSObjects 
			WHERE NAME = 'WFMileStoneTable' 
			AND xType = 'U'
		)
	BEGIN
		EXECUTE(' 
			CREATE TABLE WFMileStoneTable(
				ProcessDefId 	INT NOT NULL,
				MileStoneId 	INT NOT NULL,
				MileStoneSeqId 	INT NOT NULL,
				MileStoneName 	NVARCHAR(255) NULL,
				MileStoneWidth 	INT NOT NULL,
				MileStoneHeight INT NOT NULL,
				ITop 			INT NOT NULL,
				ILeft 			INT NOT NULL,
				BackColor 		INT NOT NULL,
				Description 	NVARCHAR(255) NULL,
				isExpanded 		NVARCHAR(50) NULL,
				Cost 			INT NULL,
				Duration 		NVARCHAR(255) NULL,
				CONSTRAINT pk_WFMileStoneTable PRIMARY KEY(ProcessDefId,MileStoneId),
				CONSTRAINT uk_WFMileStoneTable UNIQUE (ProcessDefId,MileStoneName)
			)
		')
		PRINT 'Table WFMileStoneTable created successfully.'
	END
	
	IF NOT EXISTS (
			SELECT * FROM SYSObjects 
			WHERE NAME = 'WFProjectListTable' 
			AND xType = 'U'
		)
	BEGIN
		EXECUTE(' 
			CREATE TABLE WFProjectListTable(
				ProjectID 			INT 			NOT NULL,
				ProjectName 		NVARCHAR(255) 	NOT NULL,
				Description 		NVARCHAR(255) 	NOT NULL,
				CreationDateTime 	DATETIME 		NOT NULL,
				CreatedBy 			NVARCHAR(255) 	NOT NULL,
				LastModifiedOn 		DATETIME 		NULL,
				LastModifiedBy 		NVARCHAR(255) 	NULL,
				ProjectShared 		NCHAR(1) 		NULL,
				CONSTRAINT pk_WFProjectListTable PRIMARY KEY(ProjectID),
				CONSTRAINT WFUNQ_1 UNIQUE(ProjectName)
			)
		')
		EXECUTE('Insert into WFProjectListTable values (1, ''Default'', '''', GETDATE(), ''Supervisor'', GETDATE(), ''Supervisor'', ''N'')')
		
		PRINT 'Table WFProjectListTable created successfully.'
	END
	
	IF NOT EXISTS (
			SELECT * FROM SYSObjects 
			WHERE NAME = 'WFEventDetailsTable' 
			AND xType = 'U'
		)
	BEGIN
		EXECUTE(' 
			CREATE TABLE WFEventDetailsTable(
				EventID 				int 			NOT NULL,
				EventName 				nvarchar(255) 	NOT NULL,
				Description 			nvarchar(255) 	NULL,
				CreationDateTime 		datetime 		NOT NULL,
				ModificationDateTime	datetime 		NULL,
				CreatedBy 				nvarchar(255) 	NOT NULL,
				StartTimeHrs 			int 			NOT NULL,
				StartTimeMins 			int 			NOT NULL,
				EndTimeMins 			int 			NOT NULL,
				EndTimeHrs 				int 			NOT NULL,
				StartDate 				datetime 		NOT NULL,
				EndDate 				datetime 		NOT NULL,
				EventRecursive 			nvarchar(1) 	NOT NULL,
				FullDayEvent 			nvarchar(1) 	NOT NULL,
				ReminderType 			nvarchar(1) 	NULL,
				ReminderTime 			int 			NULL,
				ReminderTimeType 		nvarchar(1) 	NULL,
				ReminderDismissed 		nvarchar(1) 	NOT NULL Default ''N'',
				SnoozeTime 				int 			NOT NULL DEFAULT -1,
				EventSummary 			nvarchar(255) 	NULL,
				UserID 					int 			NULL,
				ParticipantName 		nvarchar(1024) 	NOT NULL,
				CONSTRAINT pk_WFEventDetailsTable PRIMARY KEY(EventID)
			)
		')
		PRINT 'Table WFEventDetailsTable created successfully.'
	END
	
	IF NOT EXISTS (
			SELECT * FROM SYSObjects 
			WHERE NAME = 'WFRepeatEventTable' 
			AND xType = 'U'
		)
	BEGIN
		EXECUTE(' 
			CREATE TABLE WFRepeatEventTable(
				EventID 		INT 			NOT NULL,
				RepeatType 		NVARCHAR(1) 	NOT NULL,
				RepeatDays 		NVARCHAR(255) 	NOT NULL,
				RepeatEndDate 	DATETIME 		NOT NULL,
				RepeatSummary 	NVARCHAR(255) 	NULL
			)
		')
		PRINT 'Table WFRepeatEventTable created successfully.'
	END
	
	IF NOT EXISTS (
			SELECT * FROM SYSObjects 
			WHERE NAME = 'WFOwnerTable' 
			AND xType = 'U'
		)
	BEGIN
		EXECUTE(' 
			CREATE table WFOwnerTable(
				Type 			INT NOT NULL,
				TypeId 			INT NOT NULL,
				ProcessDefId 	INT NOT NULL,	
				OwnerOrderId 	INT NOT NULL,
				UserId  		INT NOT NULL,
				constraint pk_WFOwnerTable PRIMARY KEY (Type,TypeId,ProcessDefId,OwnerOrderId)
			)
		')
		PRINT 'Table WFOwnerTable created successfully.'
	END
	
	IF NOT EXISTS (
			SELECT * FROM SYSObjects 
			WHERE NAME = 'WFConsultantsTable' 
			AND xType = 'U'
		)
	BEGIN
		EXECUTE(' 
			CREATE TABLE WFConsultantsTable(
				Type 				INT 	NOT NULL,
				TypeId 				INT 	NOT NULL,
				ProcessDefId 		INT 	NOT NULL,	
				ConsultantOrderId 	INT 	NOT NULL,
				UserId  			INT 	NOT NULL,
				constraint pk_WFConsultantsTable PRIMARY KEY (Type,TypeId,ProcessDefId,ConsultantOrderId)
			)
		')
		PRINT 'Table WFConsultantsTable created successfully.'
	END
	
	IF NOT EXISTS (
			SELECT * FROM SYSObjects 
			WHERE NAME = 'WFSystemTable' 
			AND xType = 'U'
		)
	BEGIN
		EXECUTE(' 
			CREATE table WFSystemTable(
				Type 			INT 			NOT NULL,
				TypeId 			INT 			NOT NULL,
				ProcessDefId 	INT 			NOT NULL,	
				SystemOrderId 	INT 			NOT NULL,
				SystemName  	NVARCHAR(255) 	NOT NULL,
				constraint pk_WFSystemTable PRIMARY KEY (Type,TypeId,ProcessDefId,SystemOrderId)
			)
		')
		PRINT 'Table WFSystemTable created successfully.'
	END
	
	IF NOT EXISTS (
			SELECT * FROM SYSObjects 
			WHERE NAME = 'WFProviderTable' 
			AND xType = 'U'
		)
	BEGIN
		EXECUTE(' 
			CREATE table WFProviderTable(
				Type 				INT 			NOT NULL,
				TypeId 				INT 			NOT NULL,
				ProcessDefId 		INT 			NOT NULL,	
				ProviderOrderId 	INT 			NOT NULL,
				ProviderName  		NVARCHAR(255) 	NOT NULL,
				constraint pk_WFProviderTable PRIMARY KEY (Type,TypeId,ProcessDefId,ProviderOrderId)
			)
		')
		PRINT 'Table WFProviderTable created successfully.'
	END
	
	IF NOT EXISTS (
			SELECT * FROM SYSObjects 
			WHERE NAME = 'WFConsumerTable' 
			AND xType = 'U'
		)
	BEGIN
		EXECUTE(' 
			create table WFConsumerTable(
				Type 			INT 			NOT NULL,
				TypeId 			INT 			NOT NULL,
				ProcessDefId 	INT 			NOT NULL,	
				ConsumerOrderId INT 			NOT NULL,
				ConsumerName 	NVARCHAR(255) 	NOT NULL,
				constraint pk_WFConsumerTable PRIMARY KEY (Type,TypeId,ProcessDefId,ConsumerOrderId)
			)
		')
		PRINT 'Table WFConsumerTable created successfully.'
	END
	
	IF NOT EXISTS (
			SELECT * FROM SYSObjects 
			WHERE NAME = 'WFPoolTable' 
			AND xType = 'U'
		)
	BEGIN
		EXECUTE(' 
			create TABLE WFPoolTable(
				ProcessDefId 		INT 			NOT NULL,
				PoolId 				INT 			NOT NULL,
				PoolName 			NVARCHAR(255) 	NULL,
				PoolWidth 			INT 			NOT NULL,
				PoolHeight 			INT 			NOT NULL,
				ITop 				INT 			NOT NULL,
				ILeft 				INT 			NOT NULL,
				BackColor 			NVARCHAR(255) 	NULL,   
				CONSTRAINT pk_WFPoolTable PRIMARY KEY (ProcessDefId,PoolId),
				CONSTRAINT uk_WFPoolTable UNIQUE (ProcessDefId,PoolName) 
			)
		')
		PRINT 'Table WFPoolTable created successfully.'
	END
	
	IF NOT EXISTS (
			SELECT * FROM SYSObjects 
			WHERE NAME = 'WFRecordedChats' 
			AND xType = 'U'
		)
	BEGIN
		EXECUTE(' 
			CREATE TABLE WFRecordedChats(
				ProcessDefId 		INT 			NOT NULL,
				ProcessName 		NVARCHAR(255) 	NULL,
				SavedBy 			NVARCHAR(255) 	NULL,
				SavedAt 			DATETIME 		NOT NULL,
				ChatId 				NVARCHAR(255) 	NOT NULL,
				Chat 				NVARCHAR(MAX) 	NULL,
				ChatStartTime 		DATETIME 		NOT NULL,
				ChatEndTime 		DATETIME 		NOT NULL
			)
		')
		PRINT 'Table WFRecordedChats created successfully.'
	END
	
	IF NOT EXISTS (
			SELECT * FROM SYSObjects 
			WHERE NAME = 'WFRequirementTable' 
			AND xType = 'U'
		)
	BEGIN
		EXECUTE(' 
		CREATE TABLE WFRequirementTable(
			ProcessDefId		INT				NOT NULL,
			ReqType				INT				NOT NULL,
			ReqId				INT				NOT NULL,
			ReqName				NVARCHAR(255)	NOT	NULL,
			ReqDesc				NTEXT			NULL,
			ReqPriority			INT				NULL,
			ReqTypeId			INT				NOT NULL,
			ReqImpl				NTEXT			NULL,
			CONSTRAINT pk_WFRequirementTable PRIMARY KEY (ProcessDefId, ReqType, ReqId, ReqTypeId)

			)
		')
		PRINT 'Table WFRequirementTable created successfully.'
	END
	
	
	
	
	IF NOT EXISTS (
			SELECT * FROM SYSObjects 
			WHERE NAME = 'WFDocBuffer' 
			AND xType = 'U'
		)
	BEGIN
		EXECUTE(' 
			CREATE TABLE WFDocBuffer(
				ProcessDefId 	INT NOT NULL,
				ActivityId 		INT NOT NULL ,
				DocName 		NVARCHAR(255) NOT NULL,
				DocId 			INT		NOT NULL,
				DocumentBuffer  Ntext NOT NULL,
				PRIMARY KEY (ProcessDefId, ActivityId, DocId)		
			)
		')
		PRINT 'Table WFDocBuffer created successfully.'
	END
	
	IF NOT EXISTS (
			SELECT * FROM SYSObjects 
			WHERE NAME = 'WFLaneQueueTable' 
			AND xType = 'U'
		)
	BEGIN
		EXECUTE(' 
			Create Table WFLaneQueueTable (
				ProcessDefId 	INT NOT NULL,
				SwimLaneId 		INT NOT NULL ,
				QueueID 		INT	NOT NULL,
				PRIMARY KEY (ProcessDefId, SwimLaneId, QueueID)
			)
		')
		PRINT 'Table WFLaneQueueTable created successfully.'
	END
	
	IF NOT EXISTS (
			SELECT * FROM SYSObjects 
			WHERE NAME = 'WFCreateChildWITable' 
			AND xType = 'U'
		)
	BEGIN
		EXECUTE(' 
			Create Table WFCreateChildWITable(
				ProcessDefId		INT NOT NULL,
				TriggerId			INT NOT NULL,
				WorkstepName		NVARCHAR(255), 
				Type		NVARCHAR(1), 
				GenerateSameParent	NVARCHAR(1), 
				VariableId			INT, 
				VarFieldId			INT,
				PRIMARY KEY (Processdefid , TriggerId)
			)
		')
		PRINT 'Table WFCreateChildWITable created successfully.'
	END
	
	IF NOT EXISTS (
			SELECT * FROM SYSObjects 
			WHERE NAME = 'CONFLICTINGQUEUEUSERTABLE' 
			AND xType = 'U'
		)
	BEGIN
		EXECUTE(' 
			CREATE TABLE CONFLICTINGQUEUEUSERTABLE (
				ConflictId		INT			IDENTITY (1,1) 		NOT NULL	PRIMARY KEY,
				QueueId 		INT 		NOT NULL ,
				Userid 			INT 	NOT NULL ,
				AssociationType 	SMALLINT 	NOT NULL ,
				AssignedTillDATETIME	DATETIME	NULL, 
				QueryFilter		NVarchar(2000)	NULL,
				QueryPreview		NVARCHAR(1)	NULL DEFAULT ''Y'',
				RevisionNo		INT,
				ProcessDefId	INT
			)
		')
		PRINT 'Table CONFLICTINGQUEUEUSERTABLE created successfully.'
	END
	
	
	
	
	
	
	IF NOT EXISTS (
			SELECT * FROM SYSObjects 
			WHERE NAME = 'RevisionNoSequence' 
			AND xType = 'U'
		)
	BEGIN
		EXECUTE(' 
			CREATE TABLE RevisionNoSequence (
				SeqNo 				INT		IDENTITY (1,1) 		NOT NULL	PRIMARY KEY,
				SeqValue  			INT 		NULL,	
			)
		')
		PRINT 'Table RevisionNoSequence created successfully.'
	END
	
	IF NOT EXISTS (
			SELECT * FROM SYSObjects 
			WHERE NAME = 'WFWorkdeskLayoutTable' 
			AND xType = 'U'
		)
	BEGIN
		EXECUTE(' 
			CREATE TABLE WFWorkdeskLayoutTable (
				ProcessDefId  		INT		NOT NULL,
				ActivityId    		INT 	NOT NULL,	
				WSLayoutDefinition 	NVARCHAR(4000),
				PRIMARY KEY (ProcessDefId, ActivityId)
			)
		')
		PRINT 'Table WFWorkdeskLayoutTable created successfully.'
		
		EXECUTE('Insert into WFWorkdeskLayoutTable (ProcessDefId, ActivityId, WSLayoutDefinition) values (0, 0, ''<WDeskLayout Interfaces="4"><Resolution><ScreenWidth>1024</ScreenWidth><ScreenHeight>768</ScreenHeight></Resolution><WDeskInterfaces><Interface Type=''''FormView'''' Top=''''50'''' Left=''''2'''' Width=''''501'''' Height=''''615''''/><Interface Type=''''Document'''' Top=''''50'''' Left=''''510'''' Width=''''501'''' Height=''''615''''/></WDeskInterfaces><MenuInterfaces><Interface Type="Exceptions"/><Interface Type="ToDoList"/></MenuInterfaces></WDeskLayout>'')')
	END
	
	
	
	
	
	-- NEW TABLE ADDED FOR RIGHT MANAGEMENT
	
	IF NOT EXISTS (
			SELECT * FROM SYSObjects 
			WHERE NAME = 'WFProfileTable' 
			AND xType = 'U'
		)
	BEGIN
		EXECUTE(' 
			Create Table WFProfileTable(
				ProfileId		INT IDENTITY(1,1) PRIMARY KEY,
				ProfileName		NVARCHAR(50),
				Description		NVARCHAR(255),
				Deletable		NVARCHAR(1),
				CreatedOn		DateTime,
				LastModifiedOn	DateTime,
				OwnerId			INT,
				OwnerName		NVARCHAR(64),
				CONSTRAINT uk_WFProfileTable UNIQUE (ProfileName)
			)
		')
		PRINT 'Table WFProfileTable created successfully.'	
		EXECUTE('INSERT INTO WFProfileTable values(''SYSADMIN'',''Admin Profile'',''N'',getDate(),getDate(), 0,''Administrator'')')
		
	END
	
	
	IF NOT EXISTS (
			SELECT * FROM SYSObjects 
			WHERE NAME = 'WFObjectListTable' 
			AND xType = 'U'
		)
	BEGIN
		EXECUTE(' 
		
			Create Table WFObjectListTable(
				ObjectTypeId			INT IDENTITY(1,1) PRIMARY KEY,
				ObjectType				NVARCHAR(20),
				ObjectTypeName			NVARCHAR(50),
				ParentObjectTypeId		INT,
				ClassName				NVARCHAR(255),
				DefaultRight			NVARCHAR(100),
				List					NVARCHAR(1)
)
		')
		PRINT 'Table WFObjectListTable created successfully.'	
		EXECUTE('INSERT INTO wfobjectlisttable values (''PRC'',''Process Management'',0,''com.newgen.wf.rightmgmt.WFRightGetProcessList'', ''0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000'', ''Y'')')
		EXECUTE('INSERT INTO wfobjectlisttable values (''QUE'',''Queue Management'',0,''com.newgen.wf.rightmgmt.WFRightGetQueueList'', ''0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000'', ''Y'')')
		
	END
	
	
	IF NOT EXISTS (
			SELECT * FROM SYSObjects 
			WHERE NAME = 'WFAssignableRightsTable' 
			AND xType = 'U'
		)
	BEGIN
		EXECUTE(' 
			Create Table WFAssignableRightsTable(
				ObjectTypeId		INT,
				RightFlag			NVARCHAR(50),
				RightName			NVARCHAR(50),
				OrderBy				INT
			)
		')
		PRINT 'Table WFAssignableRightsTable created successfully.'	
		EXECUTE('INSERT INTO wfassignablerightstable VALUES (1,''V'',''View'', 1)')
		EXECUTE('INSERT INTO wfassignablerightstable VALUES (1,''M'',''Modify'', 2)')
		EXECUTE('INSERT INTO wfassignablerightstable VALUES (1,''U'',''UnRegister'', 3)')
		EXECUTE('INSERT INTO wfassignablerightstable VALUES (1,''C'',''Check-In/CheckOut/UndoCheckOut'', 4)')
		EXECUTE('INSERT INTO wfassignablerightstable VALUES (1,''CS'',''Change State'', 5)')
		EXECUTE('INSERT INTO wfassignablerightstable values (1,''AT'',''Audit Trail'', 6) ')
		EXECUTE('INSERT INTO wfassignablerightstable values (1,''PRPT'',''Process Report'', 7)')
		EXECUTE('INSERT INTO wfassignablerightstable values (1,''IMPBO'',''Import Business objects'', 8)')
		
		EXECUTE('INSERT INTO wfassignablerightstable VALUES (2,''V'',''View'', 1)')
		EXECUTE('INSERT INTO wfassignablerightstable VALUES (2,''D'',''Delete'', 2)')
		EXECUTE('INSERT INTO wfassignablerightstable VALUES (2,''MQP'',''Modify Queue Property'', 3)')
		EXECUTE('INSERT INTO wfassignablerightstable VALUES (2,''MQU'',''Modify Queue User'', 4)')
		EXECUTE('INSERT INTO wfassignablerightstable VALUES (2,''MQA'',''Modify Queue Activity'', 5)')	
								
	END
	
	
	
	IF NOT EXISTS (
			SELECT * FROM SYSObjects 
			WHERE NAME = 'WFObjectProfileAssocTable' 
			AND xType = 'U'
		)
	BEGIN
		EXECUTE(' 
			Create Table WFObjectProfileAssocTable(
				ObjectId					INT 		NOT NULL ,
				ObjectTypeId				INT 		NOT NULL ,
				ParentObjectId				NVARCHAR(10),
				RightString					NVARCHAR(20),
				UserId						INT 		NOT NULL ,
				AssociationType				INT 		NOT NULL ,
				FilterString				NVARCHAR(255),
				PRIMARY KEY(ObjectId, ObjectTypeId, ParentObjectId, UserId, AssociationType)
			)
		')
		PRINT 'Table WFObjectProfileAssocTable created successfully.'	
				
	END
	
	IF NOT EXISTS (
			SELECT * FROM SYSObjects 
			WHERE NAME = 'WFProfileObjTypeTable' 
			AND xType = 'U'
		)
	BEGIN
		EXECUTE(' 
			Create Table WFProfileObjTypeTable(
				UserId					INT 		NOT NULL ,
				AssociationType			INT 		NOT NULL ,
				ObjectTypeId			INT 		NOT NULL ,
				RightString				NVARCHAR(100),
				Filter					NVARCHAR(255),
				PRIMARY KEY(UserId, AssociationType, ObjectTypeId, RightString)

			)
		')
		PRINT 'Table WFProfileObjTypeTable created successfully.'	
		END	
	
	
	
	IF NOT EXISTS (
			SELECT * FROM SYSObjects 
			WHERE NAME = 'WFUserObjAssocTable' 
			AND xType = 'U'
		)
	BEGIN
		EXECUTE(' 
			Create Table WFUserObjAssocTable(
					ObjectId					INT 		NOT NULL ,
					ObjectTypeId				INT 		NOT NULL ,
					ProfileId					INT,
					UserId						INT 		NOT NULL ,
					AssociationType				INT 		NOT NULL ,
					AssignedTillDATETIME		DATETIME,
					AssociationFlag				NVARCHAR(1),
					PRIMARY KEY(ObjectId, ObjectTypeId, ProfileId, UserId, AssociationType))

					')
		PRINT 'Table WFUserObjAssocTable created successfully.'	
			EXECUTE('INSERT INTO WFUserObjAssocTable values (0,0,1,2,1,null,''Y'')')			
	END
	
	
	
	IF NOT EXISTS (
			SELECT * FROM SYSObjects 
			WHERE NAME = 'WFLASTREMINDERTABLE' 
			AND xType = 'U'
		)
	BEGIN
		EXECUTE(' 
			CREATE TABLE WFLASTREMINDERTABLE (
				USERID 				INT NOT NULL,
				LASTREMINDERTIME	DATETIME 
				)

					')
		PRINT 'Table WFLASTREMINDERTABLE created successfully.'	
				
	END
	
	
	
	
	IF NOT EXISTS (
			SELECT * FROM SYSObjects 
			WHERE NAME = 'WFUnderlyingDMS' 
			AND xType = 'U'
		)
	BEGIN
		EXECUTE(' 
			CREATE TABLE WFUnderlyingDMS (
				DMSType		INT				NOT NULL,
				DMSName		NVARCHAR(255)	NULL
				)

					')
		PRINT 'Table WFUnderlyingDMS created successfully.'	
				
	END
	
	
	IF NOT EXISTS (
			SELECT * FROM SYSObjects 
			WHERE NAME = 'WFSharePointInfo' 
			AND xType = 'U'
		)
	BEGIN
		EXECUTE(' 
			CREATE TABLE WFSharePointInfo (
				ServiceURL		NVARCHAR(255)	NULL,
				ProxyEnabled	NVARCHAR(200)	NULL,
				ProxyIP			NVARCHAR(20)	NULL,
				ProxyPort		NVARCHAR(200)	NULL,
				ProxyUser		NVARCHAR(200)	NULL,
				ProxyPassword	NVARCHAR(512)	NULL,
				SPWebUrl		NVARCHAR(200)	NULL
				)
					')
		PRINT 'Table WFSharePointInfo created successfully.'	
				
	END
	
	
	
	IF NOT EXISTS (
			SELECT * FROM SYSObjects 
			WHERE NAME = 'WFDMSLibrary' 
			AND xType = 'U'
		)
	BEGIN
		EXECUTE(' 
			CREATE TABLE WFDMSLibrary (
				LibraryId			INT				NOT NULL 	IDENTITY(1,1) 	PRIMARY KEY,
				URL			NVARCHAR(255)	NULL,
				DocumentLibrary		NVARCHAR(255)	NULL
				)
					')
		PRINT 'Table WFDMSLibrary created successfully.'	
				
	END
	
	
	
	IF NOT EXISTS (
			SELECT * FROM SYSObjects 
			WHERE NAME = 'WFProcessSharePointAssoc' 
			AND xType = 'U'
		)
	BEGIN
		EXECUTE(' 
			CREATE TABLE WFProcessSharePointAssoc (
				ProcessDefId			INT		NOT NULL,
				LibraryId				INT		NULL,
				PRIMARY KEY (ProcessDefId)
					)
					')
		PRINT 'Table WFProcessSharePointAssoc created successfully.'	
				
	END
	
	
	
	IF NOT EXISTS (
			SELECT * FROM SYSObjects 
			WHERE NAME = 'WFArchiveInSharePoint' 
			AND xType = 'U'
		)
	BEGIN
		EXECUTE(' 
			CREATE TABLE WFArchiveInSharePoint (
					ProcessDefId			INT				NULL,
					ActivityID				INT				NULL,
					URL					 	NVARCHAR(255)	NULL,		
					SiteName				NVARCHAR(255)	NULL,
					DocumentLibrary			NVARCHAR(255)	NULL,
					FolderName				NVARCHAR(255)	NULL,
					ServiceURL 				NVARCHAR(255) 	NULL,
					SameAssignRights		NVARCHAR(2) 	NULL,
					DiffFolderLoc			NVARCHAR(2) 	NULL	
					)
					')
		PRINT 'Table WFArchiveInSharePoint created successfully.'	
				
	END
	
	
	IF NOT EXISTS (
			SELECT * FROM SYSObjects 
			WHERE NAME = 'WFSharePointDataMapTable' 
			AND xType = 'U'
		)
	BEGIN
		EXECUTE(' 
			CREATE TABLE WFSharePointDataMapTable (
				ProcessDefId			INT				NULL,
				ActivityID				INT				NULL,
				FieldId					INT				NULL,
				FieldName				NVARCHAR(255)	NULL,
				FieldType				INT				NULL,
				MappedFieldName			NVARCHAR(255)	NULL,
				VariableID				NVARCHAR(255)	NULL,
				VarFieldID				NVARCHAR(255)	NULL
	
			)
					')
		PRINT 'Table WFSharePointDataMapTable created successfully.'	
				
	END
	
	
	
		IF NOT EXISTS (
			SELECT * FROM SYSObjects 
			WHERE NAME = 'WFSharePointDocAssocTable' 
			AND xType = 'U'
		)
	BEGIN
		EXECUTE(' 
			CREATE TABLE WFSharePointDocAssocTable (
				ProcessDefId			INT				NULL,
				ActivityID				INT				NULL,
				DocTypeID				INT				NULL,
				AssocFieldName			NVARCHAR(255)	NULL,
				FolderName				NVARCHAR(255)	NULL
					)
					')
		PRINT 'Table WFSharePointDocAssocTable created successfully.'	
				
	END
	
	
	IF NOT EXISTS (
			SELECT * FROM SYSObjects 
			WHERE NAME = 'WFMsgAFTable' 
			AND xType = 'U'
		)
	BEGIN
		EXECUTE(' 
			CREATE TABLE WFMsgAFTable(
				ProcessDefId 	INT NOT NULL,
				MsgAFId 		INT NOT NULL,
				xLeft 			INT NULL,
				yTop 			INT NULL,
				MsgAFName 		NVARCHAR(255) NULL,
				SwimLaneId 		INT NOT NULL,
				PRIMARY KEY ( ProcessDefId, MsgAFId, SwimLaneId)
						)
					')
		PRINT 'Table WFMsgAFTable created successfully.'	
				
	END
	
	IF NOT EXISTS (
			SELECT * FROM SYSObjects 
			WHERE NAME = 'WFProfileUserTable' 
			AND xType = 'U'
		)
	BEGIN
		EXECUTE(' 
			Create Table WFProfileUserTable(
				ProfileId				INT NOT NULL ,
				UserId					INT NOT NULL ,
				AssociationType			INT NOT NULL ,
				AssignedTillDATETIME	DateTime,
				AssociationFlag			NVARCHAR(1),
				PRIMARY KEY(ProfileId, UserId, AssociationType)
			)
		')
		PRINT 'Table WFProfileUserTable created successfully.'	
		EXECUTE('INSERT INTO WFProfileUserTable VALUES(1, 2, 1, NULL, ''Y'')')
		
	END
	
	
	
	IF NOT EXISTS (
			SELECT * FROM SYSObjects 
			WHERE NAME = 'WFFilterListTable' 
			AND xType = 'U'
		)
	BEGIN
		EXECUTE(' 
			Create Table WFFilterListTable(
				ObjectTypeId			INT NOT NULL,
				FilterName				NVARCHAR(50),
				TagName					NVARCHAR(50)
			)
		')
		PRINT 'Table WFFilterListTable created successfully.'	
		EXECUTE('INSERT INTO wffilterlisttable VALUES (1,''Process Name'',''ProcessName'')')
		EXECUTE('INSERT INTO wffilterlisttable VALUES (2,''Queue Name'',''QueueName'')')
		
	END
	
	
	
	/* Creating processDefId identity on processDefTable */
	
	IF NOT EXISTS ( SELECT * FROM WFCabVersionTable 
		where cabVersion = '10.0_OmniFlowCabinet')	
	BEGIN
	
		IF EXISTS(select processdefid from processdeftable)
		BEGIN
			select @ProcessDefId = max(processdefid) from PROCESSDEFTABLE
			set @ProcessDefId = @ProcessDefId + 1			
		END
		ELSE 
		BEGIN
			set @ProcessDefId = 1
		END	

		
		
		EXECUTE('CREATE TABLE TEMPPROCESSDEFTABLE (
			ProcessDefId		   INT		IDENTITY('+@ProcessDefId+',1),
			VersionNo		       SMALLINT	NOT NULL ,
			ProcessName		       NVARCHAR(30)	NOT NULL ,
			ProcessState		   NVARCHAR(10)	NULL ,
			RegPrefix		       NVARCHAR(20)	NOT NULL ,
			RegSuffix		       NVARCHAR(20)	NULL ,
			RegStartingNo		   INT		NULL,
			ProcessTurnAroundTime  INT		NULL,
			RegSeqLength		   INT		NULL,
			CreatedOn		       DATETIME	NULL, 
			LastModifiedOn		   DATETIME	NULL,
			WSFont			       NVARCHAR(255)	NULL,
			WSColor			       INT		NULL,
			CommentsFont		   NVARCHAR(255)	NULL,
			CommentsColor		   INT		NULL,
			Backcolor		       INT		NULL,
			TATCalFlag		       NVarChar(1)	NULL
		)')
		EXECUTE('alter table TEMPPROCESSDEFTABLE add PRIMARY KEY (ProcessDefId)')
		EXECUTE('alter table processdeftable switch to tempprocessdeftable')
		EXECUTE('Drop Table processdeftable')
		EXECUTE('exec sp_rename ''TEMPPROCESSDEFTABLE'' , ''PROCESSDEFTABLE''')
		EXECUTE('Insert into WFCabVersionTable(cabVersion,creationDate,lastModified,Remarks,Status) values(''10.0_OmniFlowCabinet'',getdate(),getdate(),''processDefTable for OmniFlow with Identity ProcessDefId'',''Y'')')
	END
	
	/*	Upgrade for Process Variant support*/
	IF NOT EXISTS (
			SELECT * FROM SYSObjects 
			WHERE NAME = 'WFProcessVariantDefTable' 
			AND xType = 'U'
		)
	BEGIN
		EXECUTE(' 
			CREATE TABLE WFProcessVariantDefTable(
				ProcessDefId			Integer,
				ProcessVariantId		Integer		IDENTITY(1,1),
				ProcessVariantName		NVARCHAR(64),
				ProcessVariantState		NVARCHAR(10),
				RegPrefix				NVARCHAR(20)	NOT NULL,
				RegSuffix				NVARCHAR(20)	NULL,
				RegStartingNo			INT				NULL,
				Label					NVARCHAR(255),
				Description				NVARCHAR(255),
				CreatedOn				DATETIME,
				CreatedBy				NVARCHAR(64),
				LastModifiedOn			DATETIME,
				LastModifiedBy			NVARCHAR(64)
			)
		')
		PRINT 'Table WFProcessVariantDefTable created successfully.'	
		EXECUTE('Alter Table ProcessDefTable add ProcessType NVARCHAR(1) DEFAULT N''S'' NOT NULL')
	END
	
	IF NOT EXISTS (
			SELECT * FROM SYSObjects 
			WHERE NAME = 'WFVariantFieldInfoTable' 
			AND xType = 'U'
		)
	BEGIN
		EXECUTE(' 
			CREATE TABLE WFVariantFieldInfoTable(
				ProcessDefId			INT Not Null,
				ProcessVariantId		INT	Not Null,
				FieldId                 INT Not Null,
				VariableId				INT,
				VarFieldId				INT,
				Type          			INT,
				Length                  INT,
				DefaultValue            Nvarchar(255),
				MethodName          	Nvarchar(255),
				PickListInfo            Nvarchar(512),
				ControlType             INT,
				PRIMARY KEY ( ProcessDefId, ProcessVariantId, FieldId)
			)
		')
		PRINT 'Table WFVariantFieldInfoTable created successfully.'	
	END
	
	IF NOT EXISTS (
			SELECT * FROM SYSObjects 
			WHERE NAME = 'WFVariantFieldAssociationTable' 
			AND xType = 'U'
		)
	BEGIN
		EXECUTE(' 
			CREATE TABLE WFVariantFieldAssociationTable(
				ProcessDefId			INT Not Null,
				ProcessVariantId		INT	Not Null,
				ActivityId              INT Not Null,
				VariableId              INT Not Null,
				VarFieldId              INT Not Null,
				Enable		       		Nvarchar(1),
				Editable	      		Nvarchar(1),
				Visible     	        Nvarchar(1),
				Mandatory				Nvarchar(1),
				PRIMARY KEY ( ProcessDefId, ProcessVariantId, ActivityId, VariableId, VarFieldId)
			)
		')
		PRINT 'Table WFVariantFieldAssociationTable created successfully.'	
	END
	
	IF NOT EXISTS (
			SELECT * FROM SYSObjects 
			WHERE NAME = 'WFVariantFormListenerTable' 
			AND xType = 'U'
		)
	BEGIN
		EXECUTE(' 
			CREATE TABLE WFVariantFormListenerTable(
				ProcessDefId			INT Not Null,
				ProcessVariantId		INT	Not Null,
				VariableId              INT Null,
				VarFieldId              INT Null,
				FormExtId               INT Null,
				ActivityId              INT Null,
				FunctionName			NVarchar(512),
				CodeSnippet             NText,
				LanguageType  			NVarchar(2),
				FieldListener     	    INT,
				ObjectForListener		NVarchar(1)
			)
		')
		PRINT 'Table WFVariantFormListenerTable created successfully.'	
	END
	
	IF NOT EXISTS (
			SELECT * FROM SYSObjects 
			WHERE NAME = 'WFVariantFormTable' 
			AND xType = 'U'
		)
	BEGIN
		EXECUTE(' 
			CREATE TABLE WFVariantFormTable(
				ProcessDefId			INT Not Null,
				ProcessVariantId		INT	Not Null,
				FormExtId   	        INT Not Null identity (1,1) ,
				Columns		            INT,
				Width1		            INT,
				Width2		            INT,
				Width3		            INT,
				PRIMARY KEY ( ProcessDefId, ProcessVariantId, FormExtId)
			)
		')
		PRINT 'Table WFVariantFormTable created successfully.'	
	END
	
	/*..................................... End of New Table Addition ............................................*/
	
	/*................................... Adding new columns in existing Table ...................................*/
	IF NOT EXISTS ( SELECT * FROM sysColumns 
		WHERE 
		id = (SELECT id FROM sysObjects WHERE NAME = 'PROCESSDEFTABLE')
		AND  NAME = 'Description'
		)
	BEGIN

     	EXECUTE('ALTER TABLE PROCESSDEFTABLE ADD Description NVARCHAR(255)')		
		
		EXECUTE('ALTER TABLE PROCESSDEFTABLE ADD CreatedBy NVARCHAR(255) NULL')		
		EXECUTE('ALTER TABLE PROCESSDEFTABLE ADD LastModifiedBy NVARCHAR(255) NULL')		
		EXECUTE('ALTER TABLE PROCESSDEFTABLE ADD ProcessShared NCHAR(1)')		
		EXECUTE('ALTER TABLE PROCESSDEFTABLE ADD ProjectId INT NULL')		
		EXECUTE('ALTER TABLE PROCESSDEFTABLE ADD Cost Numeric(15,2)')
		EXECUTE('ALTER TABLE PROCESSDEFTABLE ADD Duration NVARCHAR(255)')
		EXECUTE('ALTER TABLE PROCESSDEFTABLE ADD FormViewerApp NCHAR(1)	NULL')
		Print 'processDefTable Altered successfully'	

		EXECUTE('Update PROCESSDEFTABLE SET Description = '' '',CreatedBy =''Supervisor'', LastModifiedBy = ''Supervisor'', ProcessShared =''N'', ProjectId= 1 ,Cost = 0.00,Duration ='''', FormViewerApp = ''A'' ')

		
	END	
	
	
	IF NOT EXISTS ( SELECT * FROM sysColumns 
		WHERE 
		id = (SELECT id FROM sysObjects WHERE NAME = 'EXTDBCONFTABLE')
		AND  NAME = 'SortingColumn'
		)
	BEGIN
		EXECUTE('ALTER TABLE EXTDBCONFTABLE ADD SortingColumn NVARCHAR(255)')		
		
		Print 'extdbConfTable Altered successfully'	
		
	END	
	
	IF NOT EXISTS ( SELECT * FROM sysColumns 
		WHERE 
		id = (SELECT id FROM sysObjects WHERE NAME = 'ACTIVITYTABLE')
		AND  NAME = 'ActivitySubType'
		)
	BEGIN
		EXECUTE('ALTER TABLE ACTIVITYTABLE ADD ActivitySubType INT NULL')		
		EXECUTE('ALTER TABLE ACTIVITYTABLE ADD Color INT')		
		EXECUTE('ALTER TABLE ACTIVITYTABLE ADD Cost Numeric(15,2)')		
		EXECUTE('ALTER TABLE ACTIVITYTABLE ADD Duration NVarchar(255)')				
		EXECUTE('ALTER TABLE ACTIVITYTABLE ADD SwimLaneId INT')
		EXECUTE('ALTER TABLE ACTIVITYTABLE ADD DummyStrColumn1 NVarchar(255)')	
		EXECUTE('ALTER TABLE ACTIVITYTABLE ADD CustomValidation NTEXT')	
		Print 'ACTIVITYTABLE Altered successfully'
		
		EXECUTE('UPDATE ACTIVITYTABLE SET Color = 1234, Cost = 0.00, Duration = ''0D0H0M'',SwimLaneId = 1, DummyStrColumn1 ='''', CustomValidation ='' ''  ')	
		
		/* Updating ActivitySubType values in ActivityTable*/
					
			
			Declare @AllowSoapRequest nvarchar(1)
			Declare @ActivityId_actSub int 
			Declare @sql_actSub VARCHAR(MAX)
			Declare @ActivityType_actSub int
			
			Declare @activitysubtype int
			
			
			DECLARE cur_actSub CURSOR FOR  
--			select processdefid,activityid, activitytype, AllowSoapRequest from ACTIVITYTABLE order by ProcessDefId
			select processdefid,activityid, activitytype, AllowSoapRequest  from ACTIVITYTABLE order by ProcessDefId
			
			OPEN cur_actSub
   
			FETCH NEXT FROM cur_actSub INTO @ProcessDefId,@ActivityId_actSub,@ActivityType_actSub,@AllowSoapRequest
			
			WHILE @@FETCH_STATUS = 0 
			BEGIN
			
				Set  @activitysubtype = 1
		 If ((@ActivityType_actSub > 3 and @ActivityType_actSub < 7) or (@ActivityType_actSub = 3)or (@ActivityType_actSub = 7) or (@ActivityType_actSub = 11) or (@ActivityType_actSub >= 18) )
				Begin
					Set  @activitysubtype = 1
					
				End
			Else if (@ActivityType_actSub = 1 and @AllowSoapRequest = 'Y')    
				Begin
				Set @activitysubtype = 2
				End
			Else if (@ActivityType_actSub = 1 and @AllowSoapRequest = 'N')    
				Begin
				Set @activitysubtype = 1	
				End
			Else if (@ActivityType_actSub = 2)    
				Begin
				If not exists (select 1 from InitiateWorkItemDefTable where activityid = @ActivityId_actSub and processdefid = @processdefid)
					Begin
					Set @activitysubtype = 1
					End
				Else
					Begin
					Set @activitysubtype = 2
					End
				End	
			Else if (@ActivityType_actSub = 10)   
				Begin
					Set @activitysubtype = 3
				If  exists (select 1 from PRINTFAXEMAILTABLE where PFEInterfaceId = @ActivityId_actSub and processdefid = @processdefid)
					Begin
					Set  @activitysubtype = 1
					End
				If exists (select 1 from ARCHIVETABLE where activityid = @ActivityId_actSub and processdefid = @processdefid)
					Begin
					Set @activitysubtype = 4
					END
				If exists (select 1 from RULEOPERATIONTABLE where activityid = @ActivityId_actSub and processdefid = @processdefid and operationtype = 24)
					Begin
					Set @activitysubtype = 6
					End
				End
			
			Begin	
				SET @Sql_actSub = 'Update  ActivityTable set ActivitySubtype= ' 
					+ CONVERT(VARCHAR(10), @activitysubtype)
					+ ' where ProcessDefId = ' 
					+ CONVERT(VARCHAR(10), @ProcessDefId) +  'and ActivityId = '+ CONVERT(VARCHAR(10),@ActivityId_actSub )
				EXECUTE (@Sql_actSub)
			End
			 FETCH NEXT FROM cur_actSub INTO @ProcessDefId,@ActivityId_actSub,@ActivityType_actSub,@AllowSoapRequest
	  	END
		CLOSE cur_actSub   
		DEALLOCATE cur_actSub 
		/* End of updating activitysubtype*/
	END
	
	
	IF NOT EXISTS ( SELECT * FROM sysColumns 
		WHERE 
		id = (SELECT id FROM sysObjects WHERE NAME = 'PROCESSDEFCOMMENTTABLE')
		AND  NAME = 'AnnotationId'
		)
	BEGIN
		EXECUTE('ALTER TABLE PROCESSDEFCOMMENTTABLE ADD AnnotationId INT')		
		EXECUTE('ALTER TABLE PROCESSDEFCOMMENTTABLE ADD SwimLaneId INT')
		Print 'PROCESSDEFCOMMENTTABLE Altered successfully'				
		EXECUTE('Update PROCESSDEFCOMMENTTABLE SET SwimLaneId = 1')
		
					
	
			Declare @Comments nvarchar(255)
			Declare @PreviousProcessDefId_comments int
			Declare @counter_comments int
			Declare @Sql_pdfcomment VARCHAR(MAX)
			
			select @PreviousProcessDefId_comments = 0

			DECLARE cur_processdefcomment CURSOR FOR  
			SELECT Processdefid,Comments  from PROCESSDEFCOMMENTTABLE order by ProcessDefId

			OPEN cur_processdefcomment
   
			FETCH NEXT FROM cur_processdefcomment INTO @ProcessDefId,@Comments
			
			select @counter_comments = 1

			WHILE @@FETCH_STATUS = 0 
			BEGIN
				if(@PreviousProcessDefId_comments != @ProcessDefId)
					Begin
						select @counter_comments=1
					End
			SET @Sql_pdfcomment = 'Update  PROCESSDEFCOMMENTTABLE set annotationid= ' 
					+ CONVERT(VARCHAR(10), @counter_comments)
					+ ' where ProcessDefId = ' 
					+ CONVERT(VARCHAR(10), @ProcessDefId) +  'and Comments = '''  
					+  @Comments + ''''
					
		   EXECUTE (@Sql_pdfcomment)
			select @counter_comments = @counter_comments + 1  
				 set @PreviousProcessDefId_comments = @ProcessDefId 
					
				
			 FETCH NEXT FROM cur_processdefcomment INTO @ProcessDefId,@Comments
	  

			END
		CLOSE cur_processdefcomment   
		DEALLOCATE cur_processdefcomment 

	
	END
	
	
	IF NOT EXISTS ( SELECT * FROM sysColumns 
		WHERE 
		id = (SELECT id FROM sysObjects WHERE NAME = 'WORKSTAGELINKTABLE')
		AND  NAME = 'ConnectionId'
		)
	BEGIN

	EXECUTE('ALTER TABLE WORKSTAGELINKTABLE ADD ConnectionId INT NULL')	
		Print 'WORKSTAGELINKTABLE Altered successfully'	

		Declare @SourceId int
			Declare @TargetId int
			Declare @PreviousProcessDefId int
			Declare @counter int
			Declare @Sql VARCHAR(MAX)
			
			select @PreviousProcessDefId = 0

			DECLARE cur_connectionid CURSOR FOR  
			SELECT Processdefid,SourceId, TargetId  from WORKSTAGELINKTABLE order by processdefid 

			OPEN cur_connectionid
   
			FETCH NEXT FROM cur_connectionid INTO @ProcessDefId,@SourceId,@TargetId 
			print @ProcessDefId

			select @counter = 1

			WHILE @@FETCH_STATUS = 0 
			BEGIN
				if(@PreviousProcessDefId != @ProcessDefId)
					Begin
						select @counter=1
					End
			SET @Sql = 'Update  WORKSTAGELINKTABLE set connectionId= ' 
					+ CONVERT(VARCHAR(10), @counter)
					+ ' where ProcessDefId = ' 
					+ CONVERT(VARCHAR(10), @ProcessDefId) 
					+ ' and SourceId = '
					+ CONVERT(VARCHAR(10), @SourceId)
					+ ' and TargetId = '
					+ CONVERT(VARCHAR(10), @TargetId)
		   EXECUTE (@Sql)
			select @counter = @counter + 1  
				 set @PreviousProcessDefId = @ProcessDefId 
					print @PreviousProcessDefId
				print @ProcessDefId 
			 FETCH NEXT FROM cur_connectionid INTO @ProcessDefId,@SourceId,@TargetId 
	  

			END
		CLOSE cur_connectionid   
		DEALLOCATE cur_connectionid 
/* */
	END	


		
/* Inserting and Updating values into ExtDBFieldDefinitionTable after adding ExtObjId */
	
					/*IF NOT EXISTS ( SELECT * FROM sysColumns 
						WHERE 
						id = (SELECT id FROM sysObjects WHERE NAME = 'EXTDBFIELDDEFINITIONTABLE')
						AND  NAME = 'ExtObjId'
						)
					BEGIN	
						EXECUTE('ALTER TABLE EXTDBFIELDDEFINITIONTABLE ADD ExtObjId INT ')
						EXECUTE('update EXTDBFIELDDEFINITIONTABLE set ExtObjId = 1 where ExtObjId is null')
						EXECUTE('ALTER TABLE EXTDBFIELDDEFINITIONTABLE Alter column ExtObjId INT NOT NULL')
						
					 updating extobjid in extdbfielddefinitiontable*
							Declare @FieldName varchar(max)
					
						
							Declare @sql_exobj VARCHAR(MAX)
							Declare @extobjid int
							
							
							DECLARE cur_extobj CURSOR FOR  
							select fieldname, ProcessDefId from extdbfielddefinitiontable

							OPEN cur_extobj
				   
							FETCH NEXT FROM cur_extobj INTO @FieldName,@ProcessDefId
							
							WHILE @@FETCH_STATUS = 0 
							BEGIN
								
							select @extobjid = extobjid from extdbconftable where tablename in (select tbl.table_name
								FROM information_schema.tables tbl INNER JOIN information_schema.columns col 
								ON col.table_name = tbl.table_name 
								WHERE col.COLUMN_NAME = @FieldName and tbl.TABLE_TYPE = 'BASE TABLE') and ProcessDefId = @ProcessDefId
								
								SET @sql_exobj = 'Update  extdbfielddefinitiontable set extobjid= ' 
									+ CONVERT(VARCHAR(10), @extobjid) + ' where processdefid = '
									 + CONVERT(VARCHAR(10), @ProcessDefId)+ 'and FieldName = '''+@FieldName+ ''''
								EXECUTE (@sql_exobj)
							
							 FETCH NEXT FROM cur_extobj INTO @FieldName,@ProcessDefId
					  

							END
						CLOSE cur_extobj   
						DEALLOCATE cur_extobj 
						 End Of updating extobjid in extdbfielddefinitiontable*/	
IF NOT EXISTS ( SELECT * FROM sysColumns 
				WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'EXTDBFIELDDEFINITIONTABLE') AND  NAME = 'ExtObjId'
				)
BEGIN
print'1'
	EXECUTE('ALTER TABLE EXTDBFIELDDEFINITIONTABLE ADD ExtObjId INT' )
	EXECUTE('update EXTDBFIELDDEFINITIONTABLE set ExtObjId = 0 where ExtObjId is null')
	EXECUTE('ALTER TABLE EXTDBFIELDDEFINITIONTABLE Alter column ExtObjId INT NOT NULL')

	

	Declare @extObjId			INT
	Declare @colName			nvarchar(40)
	Declare @TableName			nvarchar(40)
	Declare @colType			nvarchar(40)
	Declare @sql_qry		    VARCHAR(MAX)
	Declare @varPrecision 		int
	Set @varPrecision = 	2
	Declare @colLen				INT	
	Declare @inner_TableName   varchar(max)
	Declare @fieldType			nvarchar(40)

	--outer cursor	
	DECLARE cur_extDbField CURSOR FOR  
	
	
	Select ProcessDefId,TableName,extobjid  from ExtDBConfTable
	open cur_extDbField 
	
	Fetch Next from cur_extDbField into @ProcessDefId,@TableName,@extObjId
	WHILE @@FETCH_STATUS = 0 
	
	BEGIN
		/*print'Table Name '+@TableName
		print 'ExtObjId = '+Convert(varchar(max),@extObjId)*/
		--inner cursor
		Declare cur_columns CURSOR FOR
		Select COLUMN_NAME from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME=@TableName
		Open cur_columns
		Fetch Next From cur_columns into @colName
		WHILE @@FETCH_STATUS = 0 
		BEGIN	
		Print'Column Name '+@colName
			If Exists(Select * from SysObjects where name =@TableName)	
				Begin
					Print'2'
				
						Select @existsFlag = count(*) from ExtDBFieldDefinitionTable where processdefid = @ProcessDefId and FieldName = @colName 
						
					If(@existsFlag = 1)
						BEGIN
							Set @sql_qry= 'update ExtDBFieldDefinitionTable set extObjId = '+convert(varchar(max),@extObjId)+' Where extobjid = 0' 
							EXECUTE(@sql_qry)
						END
					ELSE
						BEGIN
						print '4'	
							Select @colType = DATA_TYPE from  INFORMATION_SCHEMA.COLUMNS where COLUMN_NAME=@colName and TABLE_NAME=@TableName
							-- Map Db fields into FieldType (to be inserted into FieldType col in EXTDBFIELDDEFINIOTNTABLE)
							Select @fieldType = 
								Case @colType
									When 'int'    		Then 'INTEGER'			--Set @colLen = 2
									When 'smallint'    	Then 'INTEGER' 		--	,Set @colLen = 2
									When 'bigint' 		THEN 'BIGINT'  		--	,Set @colLen = 4
									When 'float'  		THEN 'NUMERIC'		--	,Set @colLen = 15
									When 'datetime' 	THEN 'datetime'		--	,Set @colLen = 8
									When 'date' 		THEN 'smalldatetime'--	,Set @colLen = 8
									When 'varchar' 		THEN 'STRING'		--	,Set @colLen = 50
									When 'nvarchar' 	THEN 'STRING'		--	,Set @colLen = 50
									When 'numeric' 		THEN 'NUMERIC'		--	,Set @colLen = 15
									When 'bit' 			THEN 'BOOLEAN'		--	,Set @colLen = 5
									When 'ntext' 		THEN 'NTEXT'		--	,Set @colLen = 0
							END
				
							Select @colLen = 
								Case @fieldType
								When 'INTEGER' 			THEN 2
								WHEN 'BIGINT' 			THEN 4
								When 'NUMERIC' 			THEN 15
								When 'datetime'		    THEN 8
								When 'smalldatetime' 	Then 8
								When 'STRING' 			THEN 50
								When 'NUMERIC' 			THEN 15
								When 'BOOLEAN'			THEN 5
								When 'NTEXT' 			THEN 0
							END
						
				
					
							-- Insert rows into EXTDBFIELDDEFINITON TABLE [processdefid,col_name,fieldtype,filedlength,varprecision =2, default value and attribute to be 		null,extObjId]
							Set @sql_qry ='Insert Into ExtDBFieldDefinitionTable(ProcessDefId,FieldName,FieldType,FieldLength,DefaultValue,Attribute,VarPrecision,ExtObjId)
							values ('+CONVERT(Varchar(max),@ProcessDefId)+ ','''+@colName+''','''+@fieldType+''','+CONVERT(Varchar(max),@colLen)+',null,null,2,'+CONVERT(Varchar(max),@extObjId)+')'
							Execute(@sql_qry)
							
				
				END
				
			END
			FETCH NEXT FROM cur_columns INTO @colName
		END	
	FETCH NEXT FROM cur_extDbField INTO @ProcessDefId,@TableName,@extObjId
	CLOSE cur_columns
	Deallocate cur_columns
	  
	END
	CLOSE cur_extDbField   
		DEALLOCATE cur_extDbField 
	END
				
		/* End of modifyng ExtDbFieldDefinitionTable*/				

	
	IF NOT EXISTS ( SELECT * FROM sysColumns 
		WHERE 
		id = (SELECT id FROM sysObjects WHERE NAME = 'QUEUEDEFTABLE')
		AND  NAME = 'ProcessName'
		)
	BEGIN
		EXECUTE('ALTER TABLE QUEUEDEFTABLE ADD ProcessName	NVARCHAR(30) NULL')
		
		print 'ALTER TABLE QUEUEDEFTABLE ADD ProcessName	NVARCHAR(30) NULL'
	END
	
	
	
 IF NOT EXISTS ( SELECT * FROM QUEUEDEFTABLE 
		WHERE QueueName = 'SystemArchiveQueue'
		)
	BEGIN
		
		EXECUTE('Insert into QueueDefTable (QueueName, QueueType, Comments, OrderBy, SortOrder) values 
		(''SystemArchiveQueue'', ''A'', ''System generated common Archive Queue'', 10, ''A'')')
		print 'Values iserted for SystemArchiveQueue'
	END
	
	 IF NOT EXISTS ( SELECT * FROM QUEUEDEFTABLE 
		WHERE QueueName = 'SystemPFEQueue'
		)
	BEGIN
		
		EXECUTE('Insert into QueueDefTable (QueueName, QueueType, Comments, OrderBy, SortOrder) values 
		(''SystemPFEQueue'', ''A'', ''System generated common PFE Queue'', 10, ''A'')')
		print 'Values iserted for SystemPFEQueue'
	END
	
	 IF NOT EXISTS ( SELECT * FROM QUEUEDEFTABLE 
		WHERE QueueName = 'SystemSharePointQueue'
		)
	BEGIN
		
		EXECUTE('Insert into QueueDefTable (QueueName, QueueType, Comments, OrderBy, SortOrder) values 
		(''SystemSharePointQueue'', ''A'', ''System generated common PFE Queue'', 10, ''A'')')
		print 'Values iserted for SystemSharePointQueue'
	END
	
	
IF NOT EXISTS ( SELECT * FROM sysColumns 
		WHERE 
		id = (SELECT id FROM sysObjects WHERE NAME = 'QUEUEUSERTABLE')
		AND  NAME = 'RevisionNo'
		)
BEGIN
		EXECUTE('ALTER TABLE QUEUEUSERTABLE ADD RevisionNo INT')
		PRINT 'ALTER TABLE QUEUEUSERTABLE ADD RevisionNo INT'
	/* Updating Revision No. in QueueUserTable*/	
		Declare @sql_revision Varchar(max)
		Declare @QueueId int
		Declare @userid int
		Declare @assocType int
		DECLARE cur_Quser CURSOR FOR  
		SELECT QueueId,UserId,AssociationType from QueueUserTable 

		OPEN cur_Quser
   
		FETCH NEXT FROM cur_Quser INTO @QueueId,@userid,@assocType

		WHILE (@@FETCH_STATUS = 0) 
		BEGIN
			Insert into RevisionNoSequence values (null)
		Set @sql_revision = 'Update  QueueUserTable set RevisionNo = ' + CONVERT(VARCHAR(10), SCOPE_IDENTITY())+ ' where QueueId =' +CONVERT(VARCHAR(10), @QueueId)+' and UserId = '+CONVERT(VARCHAR(10),@userid)+' and AssociationType = '+CONVERT(VARCHAR(10),@assocType)
		 EXECUTE (@sql_revision)
        FETCH NEXT FROM cur_Quser INTO @QueueId,@userid,@assocType
	  
	END
CLOSE cur_Quser   
DEALLOCATE cur_Quser 
	/*End Cursor*/

	END
	
	/* Need to discuss for not null field */
		
	
	IF NOT EXISTS ( SELECT * FROM sysColumns 
		WHERE 
		id = (SELECT id FROM sysObjects WHERE NAME = 'ARCHIVETABLE')
		AND  NAME = 'ArchiveDataClassName'
		)
	BEGIN
		EXECUTE('ALTER TABLE ARCHIVETABLE ADD ArchiveDataClassName NVARCHAR(255) NULL')
		PRINT 'ALTER TABLE ARCHIVETABLE ADD ArchiveDataClassName NVARCHAR(255) NULL'
	EXECUTE('Update ARCHIVETABLE SET ArchiveDataClassName = ''System_config'' ')
	END
	
	
	IF NOT EXISTS ( SELECT * FROM sysColumns 
		WHERE 
		id = (SELECT id FROM sysObjects WHERE NAME = 'CHECKOUTPROCESSESTABLE')
		AND  NAME = 'ActivityId'
		)
	BEGIN
		EXECUTE('ALTER TABLE CHECKOUTPROCESSESTABLE ADD ActivityId INT')
		EXECUTE('ALTER TABLE CHECKOUTPROCESSESTABLE ADD SwimlaneId INT')
		EXECUTE('ALTER TABLE CHECKOUTPROCESSESTABLE ADD UserId INT')
		PRINT 'ALTER TABLE CHECKOUTPROCESSESTABLE ADD UserId INT'
		
	END
	
	
	IF NOT EXISTS ( SELECT * FROM sysColumns 
		WHERE 
		id = (SELECT id FROM sysObjects WHERE NAME = 'WFSwimLaneTable')
		AND  NAME = 'PoolId'
		)
	BEGIN
		EXECUTE('ALTER TABLE WFSwimLaneTable ADD PoolId INT')		
		EXECUTE('ALTER TABLE WFSwimLaneTable ADD IndexInPool INT')
		PRINT 'ALTER TABLE WFSwimLaneTable ADD IndexInPool INT'
		
		
		
	END
	
	
	
	
	
	IF NOT EXISTS ( SELECT * FROM sysColumns 
		WHERE 
		id = (SELECT id FROM sysObjects WHERE NAME = 'WFExportTable')
		AND  NAME = 'FieldSeperator'
		)
	BEGIN
		EXECUTE('ALTER TABLE WFExportTable ADD FieldSeperator NVARCHAR(1)')		
		EXECUTE('ALTER TABLE WFExportTable ADD FileType INT')
		EXECUTE('ALTER TABLE WFExportTable ADD FilePath NVARCHAR(255)')
		EXECUTE('ALTER TABLE WFExportTable ADD HeaderString  NVARCHAR(255)')
		EXECUTE('ALTER TABLE WFExportTable ADD FooterString NVARCHAR(255)')
		EXECUTE('ALTER TABLE WFExportTable ADD SleepTime INT')
		EXECUTE('ALTER TABLE WFExportTable ADD MaskedValue NVARCHAR(255)')
		PRINT 'ALTER TABLE WFExportTable ADD MaskedValue NVARCHAR(255)'
		
		EXECUTE('UPDATE WFExportTable SET FieldSeperator = '','', FileType = 1,FilePath = '''', HeaderString = '' '', FooterString = '' '', SleepTime = 10, MaskedValue = ''@'' ')	
		
	END
	
	
	IF NOT EXISTS ( SELECT * FROM sysColumns 
		WHERE 
		id = (SELECT id FROM sysObjects WHERE NAME = 'WFDataMapTable')
		AND  NAME = 'ExportAllDocs'
		)
	BEGIN
		EXECUTE('ALTER TABLE WFDataMapTable ADD ExportAllDocs NVARCHAR(2)')
		PRINT 'ALTER TABLE WFDataMapTable ADD ExportAllDocs NVARCHAR(2)'
		EXECUTE('UPDATE WFDataMapTable SET ExportAllDocs = '' '' ')
	END
	
	
	IF NOT EXISTS ( SELECT * FROM sysColumns 
		WHERE 
		id = (SELECT id FROM sysObjects WHERE NAME = 'WFDataObjectTable')
		AND  NAME = 'SwimLaneId'
		)
	BEGIN
		EXECUTE('ALTER TABLE WFDataObjectTable ADD SwimLaneId INT')
		PRINT 'ALTER TABLE WFDataObjectTable ADD SwimLaneId INT'
		EXECUTE('UPDATE WFDataObjectTable SET SwimLaneId = 1')
		END
	
	
	IF NOT EXISTS ( SELECT * FROM sysColumns 
		WHERE 
		id = (SELECT id FROM sysObjects WHERE NAME = 'WFGroupBoxTable')
		AND  NAME = 'SwimLaneId'
		)
	BEGIN
		EXECUTE('ALTER TABLE WFGroupBoxTable ADD SwimLaneId INT')
		PRINT 'ALTER TABLE WFGroupBoxTable ADD SwimLaneId INT'
		EXECUTE('UPDATE WFGroupBoxTable SET SwimLaneId = 1')
	END
	
	
	IF NOT EXISTS ( SELECT * FROM sysColumns 
		WHERE 
		id = (SELECT id FROM sysObjects WHERE NAME = 'INITIATEWORKITEMDEFTABLE')
		AND  NAME = 'ImportedProcessDefId'
		)
	BEGIN
		EXECUTE('ALTER TABLE INITIATEWORKITEMDEFTABLE ADD ImportedProcessDefId INT NULL')
		PRINT 'ALTER TABLE INITIATEWORKITEMDEFTABLE ADD ImportedProcessDefId INT NULL'
		
		 Declare @importedprocessname_init varchar(max)
			Declare @importedprocessdefid_init int 
			Declare @Sql_init VARCHAR(MAX)
			
			
			DECLARE cur_importedProcessDef_init CURSOR FOR  
			SELECT importedprocessname  from INITIATEWORKITEMDEFTABLE 

			OPEN cur_importedProcessDef_init
   
			FETCH NEXT FROM cur_importedProcessDef_init INTO @importedprocessname_init
			
			WHILE @@FETCH_STATUS = 0 
			BEGIN
				
				select @importedprocessdefid_init = 	processdefid from PROCESSDEFTABLE where processname = @importedprocessname_init and versionno = (select max(versionno) from PROCESSDEFTABLE where processname = @importedprocessname_init)
				SET @Sql_init = 'Update  INITIATEWORKITEMDEFTABLE set importedprocessdefid= ' 
					+ CONVERT(VARCHAR(10), @importedprocessdefid_init)
					+ ' where importedprocessname = '''  
					+  @importedprocessname_init + ''''
		 EXECUTE (@Sql_init)
			
			 FETCH NEXT FROM cur_importedProcessDef_init INTO @importedprocessname_init
	  

			END
		CLOSE cur_importedProcessDef_init   
		DEALLOCATE cur_importedProcessDef_init 
	END
	
	
	IF NOT EXISTS ( SELECT * FROM sysColumns 
		WHERE 
		id = (SELECT id FROM sysObjects WHERE NAME = 'IMPORTEDPROCESSDEFTABLE')
		AND  NAME = 'ImportedProcessDefId'
		)
	BEGIN
		EXECUTE('ALTER TABLE IMPORTEDPROCESSDEFTABLE ADD ImportedProcessDefId INT NULL')
		EXECUTE('ALTER TABLE IMPORTEDPROCESSDEFTABLE ADD ProcessType  NVARCHAR(1) NOT NULL DEFAULT (N''R'')')
		PRINT 'ALTER TABLE IMPORTEDPROCESSDEFTABLE ADD ProcessType  NVARCHAR(1) NOT NULL DEFAULT (N''R'')'
		
		/*Cursor for  Updating ImportedProcessDefId */
		    Declare @importedprocessname varchar(max)
			Declare @importedprocessdefid int 
			Declare @Sql_Import VARCHAR(MAX)
			
			
			DECLARE cur_importedProcessDef CURSOR FOR  
			SELECT importedprocessname  from IMPORTEDPROCESSDEFTABLE 

			OPEN cur_importedProcessDef
   
			FETCH NEXT FROM cur_importedProcessDef INTO @importedprocessname
			
			WHILE @@FETCH_STATUS = 0 
			BEGIN
				
				select @importedprocessdefid = 	processdefid from PROCESSDEFTABLE where processname = @importedprocessname and versionno = (select max(versionno) from PROCESSDEFTABLE where processname = @importedprocessname)
				SET @Sql_Import = 'Update  IMPORTEDPROCESSDEFTABLE set importedprocessdefid= ' 
					+ CONVERT(VARCHAR(10), @importedprocessdefid)
					+ ' where importedprocessname = '''  
					+  @importedprocessname + ''''
		 EXECUTE (@Sql_Import)
			
			 FETCH NEXT FROM cur_importedProcessDef INTO @importedprocessname
	  

			END
		CLOSE cur_importedProcessDef   
		DEALLOCATE cur_importedProcessDef 
		/* End of Cursor*/
	END
	
	
	IF NOT EXISTS ( SELECT * FROM sysColumns 
		WHERE 
		id = (SELECT id FROM sysObjects WHERE NAME = 'TEMPLATEDEFINITIONTABLE')
		AND  NAME = 'Format'
		)
	BEGIN
		EXECUTE('ALTER TABLE TEMPLATEDEFINITIONTABLE ADD Format NVARCHAR(255) NULL')		
		PRINT 'ALTER TABLE TEMPLATEDEFINITIONTABLE ADD Format NVARCHAR(255) NULL'
		EXECUTE('UPDATE TEMPLATEDEFINITIONTABLE SET Format = ''Doc'' ')		
	END
	
	IF NOT EXISTS ( SELECT * FROM sysColumns 
		WHERE 
		id = (SELECT id FROM sysObjects WHERE NAME = 'WFMAILQUEUETABLE')
		AND  NAME = 'zipFlag'
		)
	BEGIN
		EXECUTE('ALTER TABLE WFMAILQUEUETABLE ADD zipFlag nvarchar(1) NULL ')		
		PRINT 'ALTER TABLE WFMAILQUEUETABLE ADD zipFlag nvarchar(1) NULL '
		
	END
	
	IF NOT EXISTS ( SELECT * FROM sysColumns 
		WHERE 
		id = (SELECT id FROM sysObjects WHERE NAME = 'WFMAILQUEUETABLE')
		AND  NAME = 'zipName'
		)
	BEGIN
		EXECUTE('ALTER TABLE WFMAILQUEUETABLE ADD zipName NVARCHAR(255) NULL ')		
		PRINT 'ALTER TABLE WFMAILQUEUETABLE ADD zipName NVARCHAR(255) NULL'
		
	END
	
	IF NOT EXISTS ( SELECT * FROM sysColumns 
		WHERE 
		id = (SELECT id FROM sysObjects WHERE NAME = 'WFMAILQUEUETABLE')
		AND  NAME = 'maxZipSize'
		)
	BEGIN
		EXECUTE('ALTER TABLE WFMAILQUEUETABLE ADD maxZipSize INT NULL ')		
		PRINT 'ALTER TABLE WFMAILQUEUETABLE ADD maxZipSize INT NULL '
		
	END
	
	IF NOT EXISTS ( SELECT * FROM sysColumns 
		WHERE 
		id = (SELECT id FROM sysObjects WHERE NAME = 'WFMAILQUEUETABLE')
		AND  NAME = 'alternateMessage'
		)
	BEGIN
		EXECUTE('ALTER TABLE WFMAILQUEUETABLE ADD alternateMessage ntext NULL ')		
		PRINT 'ALTER TABLE WFMAILQUEUETABLE ADD alternateMessage ntext NULL '
		
	END
	
	
	IF NOT EXISTS ( SELECT * FROM sysColumns 
		WHERE 
		id = (SELECT id FROM sysObjects WHERE NAME = 'WFMAILQUEUETABLE')
		AND  NAME = 'mailBCC'
		)
	BEGIN
		EXECUTE('ALTER TABLE WFMAILQUEUETABLE ADD mailBCC NVARCHAR(512) ')		
		PRINT 'ALTER TABLE WFMAILQUEUETABLE ADD mailBCC NVARCHAR(512) '
		
	END
	
		
	
	IF NOT EXISTS ( SELECT * FROM sysColumns 
		WHERE 
		id = (SELECT id FROM sysObjects WHERE NAME = 'WFMAILQUEUEHISTORYTABLE')
		AND  NAME = 'mailBCC'
		)
	BEGIN
		EXECUTE('ALTER TABLE WFMAILQUEUEHISTORYTABLE ADD mailBCC NVARCHAR(512)')		
		PRINT 'ALTER TABLE WFMAILQUEUEHISTORYTABLE ADD mailBCC NVARCHAR(512)'
		
	END
	
	
	IF NOT EXISTS ( SELECT * FROM sysColumns 
		WHERE 
		id = (SELECT id FROM sysObjects WHERE NAME = 'WFAdminLogTable')
		AND  NAME = 'Operation'
		)
	BEGIN
		EXECUTE('ALTER TABLE WFAdminLogTable ADD Operation NVARCHAR(1)')		
		PRINT 'ALTER TABLE WFAdminLogTable ADD Operation NVARCHAR(1)'
		
	END
	
	
	IF NOT EXISTS ( SELECT * FROM sysColumns 
		WHERE 
		id = (SELECT id FROM sysObjects WHERE NAME = 'WFAdminLogTable')
		AND  NAME = 'ProfileId'
		)
	BEGIN
		EXECUTE('ALTER TABLE WFAdminLogTable ADD ProfileId INT')		
		PRINT 'ALTER TABLE WFAdminLogTable ADD ProfileId INT'
		EXECUTE('UPDATE WFADMINLOGTABLE SET PROFILEID = 0')	
		
	END
	
	
	IF NOT EXISTS ( SELECT * FROM sysColumns 
		WHERE 
		id = (SELECT id FROM sysObjects WHERE NAME = 'WFAdminLogTable')
		AND  NAME = 'ProfileName'
		)
	BEGIN
		EXECUTE('ALTER TABLE WFAdminLogTable ADD ProfileName NVARCHAR(64)')		
		PRINT 'ALTER TABLE WFAdminLogTable ADD ProfileName NVARCHAR(64)'
		
	END
	
	
	IF NOT EXISTS ( SELECT * FROM sysColumns 
		WHERE 
		id = (SELECT id FROM sysObjects WHERE NAME = 'WFAdminLogTable')
		AND  NAME = 'Property1'
		)
	BEGIN
		EXECUTE('ALTER TABLE WFAdminLogTable ADD Property1 NVARCHAR(64)')		
		PRINT 'ALTER TABLE WFAdminLogTable ADD Property1 NVARCHAR(64)'
		
	END
	
	IF NOT EXISTS ( SELECT * FROM sysColumns 
        WHERE 
        id = (SELECT id FROM sysObjects WHERE NAME = 'ARCHIVEDATAMAPTABLE')
        AND  NAME = 'DataFieldType'
        )
    BEGIN
    Declare  @v_processDefId int

        EXECUTE('ALTER TABLE ARCHIVEDATAMAPTABLE ADD DataFieldType INTEGER NOT NULL DEFAULT 0')
        PRINT 'Table ARCHIVEDATAMAPTABLE altered with new Column DataFieldType'
        
        DECLARE archieve_datatype CURSOR FAST_FORWARD FOR
            select ProcessDefID, variableid from varmappingtable where 
			processdefid in (Select processdefid from ArchiveDataMapTable)

            OPEN archieve_datatype
            FETCH archieve_datatype INTO @v_processDefId, @v_VariableId
            WHILE(@@FETCH_STATUS = 0) 
            BEGIN 
                BEGIN TRANSACTION trans
                    
                    EXECUTE(' UPDATE Archivedatamaptable set datafieldtype=(Select variabletype 
							from  varmappingtable WHERE PROCESSDEFID= '+@v_ProcessDefID+' and 
						variableid= '+@v_variableid+' ) WHERE processdefid = '+@v_ProcessDefID+' and variableid=' +@v_VariableId
							)
                COMMIT TRANSACTION trans

                FETCH NEXT FROM archieve_datatype INTO @v_processDefId, @v_VariableId
            END
            CLOSE archieve_datatype
        DEALLOCATE archieve_datatype
    END
	

	
	
	
	IF NOT EXISTS ( SELECT * FROM sysColumns WHERE 
		id = (SELECT id FROM sysObjects WHERE NAME = 'WFDocBuffer')
		AND  NAME = 'Status'
		)
	BEGIN
		EXECUTE('ALTER TABLE WFDocBuffer ADD Status NVARCHAR(1) DEFAULT ''S'' NOT NULL')		
		PRINT 'ALTER TABLE WFDocBuffer ADD Status NVARCHAR(1) DEFAULT ''S'' NOT NULL'
	END
	
	IF NOT EXISTS ( SELECT * FROM sysColumns WHERE 
		id = (SELECT id FROM sysObjects WHERE NAME = 'WFFORM_TABLE')
		AND  NAME = 'LastModifiedOn'
		)
	BEGIN
		EXECUTE('ALTER TABLE WFFORM_TABLE ADD LastModifiedOn DATETIME')		
		PRINT 'ALTER TABLE WFFORM_TABLE ADD LastModifiedOn DATETIME'
		EXECUTE('UPDATE  WFFORM_TABLE SET LastModifiedOn = GetDate() ')	
		END
	
	IF NOT EXISTS ( SELECT * FROM sysColumns WHERE 
		id = (SELECT id FROM sysObjects WHERE NAME = 'WFFormFragmentTable')
		AND  NAME = 'LastModifiedOn'
		)
	BEGIN
		EXECUTE('ALTER TABLE WFFormFragmentTable ADD LastModifiedOn DATETIME')		
		PRINT 'ALTER TABLE WFFormFragmentTable ADD LastModifiedOn DATETIME'
		EXECUTE('UPDATE  WFFormFragmentTable SET LastModifiedOn = GetDate() ')	
	END
	
	
	IF NOT EXISTS ( SELECT * FROM sysColumns WHERE 
		id = (SELECT id FROM sysObjects WHERE NAME = 'WFOwnerTable')
		AND  NAME = 'UserName'
		)
	BEGIN
		EXECUTE('ALTER TABLE WFOwnerTable ADD UserName NVARCHAR(255) ')	
		EXECUTE('Update WFOwnerTable set username = ''padmin'' ')
		EXECUTE('Alter table WFOwnerTable Alter Column UserName NVARCHAR(255) NOT NULL ')	
		PRINT 'ALTER TABLE WFOwnerTable ADD UserName NVARCHAR(255) NOT NULL'
	END
	
	
	IF NOT EXISTS ( SELECT * FROM sysColumns WHERE 
		id = (SELECT id FROM sysObjects WHERE NAME = 'WFConsultantsTable')
		AND  NAME = 'UserName'
		)
	BEGIN
		EXECUTE('ALTER TABLE WFConsultantsTable ADD UserName NVARCHAR(255) ')	
		EXECUTE('Update WFConsultantsTable set username = ''padmin'' ')
		EXECUTE('Alter table WFConsultantsTable Alter Column UserName NVARCHAR(255) NOT NULL ')	
		PRINT 'ALTER TABLE WFConsultantsTable ADD UserName NVARCHAR(255) NOT NULL'
	END
	
	/*...............................END of Adding new columns in existing Table...............................*/
	
		/* ............................ Modifying Existing Columns .............................................*/
	
	BEGIN
		EXECUTE('update PROCESSDEFTABLE set FormViewerApp = N''J'' where FormViewerApp is null')
		EXECUTE('ALTER TABLE PROCESSDEFTABLE Alter column FormViewerApp NCHAR(1) NOT NULL DEFAULT N''J''')	
		
		EXECUTE('Alter Table ACTIVITYTABLE Alter Column Description NTEXT NULL')
		EXECUTE('Alter Table TRIGGERTYPEDEFTABLE Alter Column ClassName NVARCHAR(255) NOT NULL')
		EXECUTE('Alter Table QUEUEHISTORYTABLE Alter Column Q_UserID INT NULL')
		EXECUTE('Alter Table QUEUEHISTORYTABLE Alter Column LastProcessedBy INT NULL')
		EXECUTE('Alter Table QUEUEHISTORYTABLE Alter Column ReferredTo INT NULL')
		EXECUTE('Alter Table QUEUEHISTORYTABLE Alter Column ReferredBy INT NULL')
		EXECUTE('Alter Table WFSystemServicesTable Alter Column RegInfo NTEXT NULL')
		PRINT 	'Alter Table QUEUEHISTORYTABLE Alter Column ReferredBy INT NULL'
	IF EXISTS (SELECT *	FROM sysindexes	WHERE id = OBJECT_ID('WFcurrentRouteLogTABLE')
		AND name = 'IDX2_WFRouteLogTABLE') 
	 BEGIN
		Drop index WFcurrentRouteLogTABLE.IDX2_WFRouteLogTABLE
	 END
		
		EXECUTE('Alter Table WFCURRENTROUTELOGTABLE Alter Column UserId INT	NULL')
		EXECUTE('CREATE INDEX  IDX2_WFRouteLogTABLE ON WFCURRENTROUTELOGTABLE (ActionId,UserID)')
		PRINT 'Alter Table WFCURRENTROUTELOGTABLE Alter Column UserId INT	NULL'
		
		
		EXECUTE('Alter Table ROUTEFOLDERDEFTABLE Alter Column RouteFolderId NVARCHAR(255) NOT NULL')
		EXECUTE('Alter Table ROUTEFOLDERDEFTABLE Alter Column ScratchFolderId NVARCHAR(255) NOT NULL')
		EXECUTE('Alter Table ROUTEFOLDERDEFTABLE Alter Column CompletedFolderId NVARCHAR(255) NOT NULL')
		EXECUTE('Alter Table ROUTEFOLDERDEFTABLE Alter Column WorkFlowFolderId NVARCHAR(255) NOT NULL')
		EXECUTE('Alter Table ROUTEFOLDERDEFTABLE Alter Column DiscardFolderId NVARCHAR(255) NOT NULL')
		/* Drop primary key constraint before Alter Column */
		
		SELECT @TableId = id FROM sysobjects WHERE name = 'QUEUEUSERTABLE'
		SELECT @ConstraintName = name FROM SYSCONSTRAINTS A, SYSOBJECTS B WHERE A.constid = B.id AND B.xtype = 'PK'AND A.id = @TableId 		
		IF EXISTS ( SELECT * FROM sysObjects WHERE NAME = @ConstraintName)
			BEGIN
				execute('alter table QUEUEUSERTABLE drop CONSTRAINT ' + @ConstraintName)				
			END				
		EXECUTE('Alter Table QUEUEUSERTABLE Alter Column Userid INT NOT NULL')
		EXECUTE('alter table QUEUEUSERTABLE add PRIMARY KEY (QueueID , UserId , AssociationType )')
		PRINT 'Alter Table QUEUEUSERTABLE Alter Column Userid INT NOT NULL'
		
		EXECUTE('Alter Table VARALIASTABLE Alter Column Type1 SMALLINT NULL')
		EXECUTE('Alter Table WFREMINDERTABLE Alter Column ToIndex INT NOT NULL')
		EXECUTE('Alter Table WFREMINDERTABLE Alter Column SetByUser INT NOT NULL')
		EXECUTE('Alter Table WORKLISTTABLE Alter Column Q_UserId INT NULL')
		EXECUTE('Alter Table WORKINPROCESSTABLE Alter Column Q_UserId INT NULL')
		EXECUTE('Alter Table WORKDONETABLE Alter Column Q_UserId INT NULL')
		EXECUTE('Alter Table WORKWITHPSTABLE Alter Column Q_UserId  INT	 NULL')
		EXECUTE('Alter Table PENDINGWORKLISTTABLE Alter Column Q_UserId  INT  NULL')
		PRINT 'Alter Table PENDINGWORKLISTTABLE Alter Column Q_UserId  INT  NULL'
		
		IF EXISTS ( select * from sysobjects where name = 'PK_UQTbl' and xtype = 'PK')
			BEGIN
				execute('alter table USERQUEUETABLE drop CONSTRAINT PK_UQTbl')				
			END			
		EXECUTE('Alter Table USERQUEUETABLE Alter Column UserID INT	NOT NULL')
		execute('alter table USERQUEUETABLE Add CONSTRAINT PK_UQTbl PRIMARY KEY CLUSTERED(UserID,QueueID)')	
		PRINT 'Alter Table USERQUEUETABLE Alter Column UserID INT	NOT NULL'
		
		EXECUTE('Alter Table EXCEPTIONTABLE Alter Column UserId INT NOT NULL')
		EXECUTE('Alter Table EXCEPTIONHISTORYTABLE Alter Column UserId INT NOT NULL')
		EXECUTE('Alter Table WFAuthorizeQueueUserTable Alter Column Userid INT NOT NULL')
		PRINT 'Alter Table WFAuthorizeQueueUserTable Alter Column Userid INT NOT NULL'
		
		/*  Check applied while dropping an index */	
	IF EXISTS (SELECT *	FROM sysindexes	WHERE id = OBJECT_ID('WFHISTORYROUTELOGTABLE')
		AND name = 'IDX2_WFHRouteLogTABLE') 
	BEGIN
			Drop index WFHISTORYROUTELOGTABLE.IDX2_WFHRouteLogTABLE
	END
	
		EXECUTE('Alter Table WFHISTORYROUTELOGTABLE Alter Column UserId INT NULL')
		EXECUTE('CREATE INDEX IDX2_WFHRouteLogTABLE ON WFHISTORYROUTELOGTABLE (ActionId,UserID)')
		PRINT 'Alter Table WFHISTORYROUTELOGTABLE Alter Column UserId INT NULL'
		
		/*.................................. Modify null to not null column ...............................*/
		EXECUTE('alter table USERDIVERSIONTABLE drop CONSTRAINT Pk_userdiversion')
		EXECUTE('update USERDIVERSIONTABLE set Diverteduserindex = 0 where Diverteduserindex is null')
		EXECUTE('ALTER TABLE USERDIVERSIONTABLE Alter column Diverteduserindex INT NOT NULL')		
		EXECUTE('update USERDIVERSIONTABLE set AssignedUserindex = 0 where AssignedUserindex is null')
		EXECUTE('ALTER TABLE USERDIVERSIONTABLE Alter column AssignedUserindex INT NOT NULL')
		EXECUTE('alter table USERDIVERSIONTABLE Add CONSTRAINT Pk_userdiversion PRIMARY KEY (Diverteduserindex, AssignedUserindex,fromdate)')	
		PRINT 'ALTER TABLE USERDIVERSIONTABLE Alter column AssignedUserindex INT NOT NULL'
		
		EXECUTE('alter table USERWORKAUDITTABLE drop CONSTRAINT pk_userwrkaudit')
		EXECUTE('update USERWORKAUDITTABLE set Userindex = 0 where Userindex is null')
		EXECUTE('ALTER TABLE USERWORKAUDITTABLE Alter column Userindex INT NOT NULL')		
		EXECUTE('update USERWORKAUDITTABLE set Auditoruserindex = 0 where Auditoruserindex is null')
		EXECUTE('ALTER TABLE USERWORKAUDITTABLE Alter column Auditoruserindex INT NOT NULL')
		EXECUTE('alter table USERWORKAUDITTABLE Add CONSTRAINT pk_userwrkaudit PRIMARY KEY(userIndex,auditoruserindex,AuditActivityId,ProcessDefId)')	
		PRINT 'ALTER TABLE USERWORKAUDITTABLE Alter column Auditoruserindex INT NOT NULL'
		
		EXECUTE('alter table PREFERREDQUEUETABLE drop CONSTRAINT pk_quserindex')
		EXECUTE('update PREFERREDQUEUETABLE set userindex = 0 where userindex is null')
		EXECUTE('ALTER TABLE PREFERREDQUEUETABLE Alter column userindex INT NOT NULL')
		EXECUTE('alter table PREFERREDQUEUETABLE Add CONSTRAINT pk_quserindex PRIMARY KEY(userIndex,queueIndex)')	
		PRINT 'ALTER TABLE PREFERREDQUEUETABLE Alter column userindex INT NOT NULL'
		
		EXECUTE('alter table USERPREFERENCESTABLE drop CONSTRAINT Pk_User_pref')
		EXECUTE('alter table USERPREFERENCESTABLE drop CONSTRAINT Uk_User_pref')
		EXECUTE('update USERPREFERENCESTABLE set Userid = 0 where Userid is null')
		EXECUTE('ALTER TABLE USERPREFERENCESTABLE Alter column Userid INT NOT NULL')
		EXECUTE('alter table USERPREFERENCESTABLE Add CONSTRAINT Pk_User_pref PRIMARY KEY (Userid ,ObjectId ,ObjectType)')	
		EXECUTE('alter table USERPREFERENCESTABLE Add CONSTRAINT Uk_User_pref UNIQUE (Userid ,Objectname ,ObjectType )')	
		PRINT 'ALTER TABLE USERPREFERENCESTABLE Alter column Userid INT NOT NULL'
		
		
		
		EXECUTE('DROP Index IDX1_WFDataMapTable ON WFDataMapTable')
		EXECUTE('UPDATE WFDataMapTable SET ProcessDefId = 0 where ProcessDefId is NULL')
		EXECUTE('UPDATE WFDataMapTable SET ActivityId = 0 where ActivityId is NULL')
		EXECUTE('UPDATE WFDataMapTable SET OrderId = 0 where OrderId is NULL')		
		EXECUTE('ALTER TABLE WFDataMapTable Alter column ProcessDefId INT NOT NULL')
		EXECUTE('ALTER TABLE WFDataMapTable Alter column ActivityId INT NOT NULL')
		EXECUTE('ALTER TABLE WFDataMapTable Alter column OrderId INT NOT NULL')
		EXECUTE('CREATE INDEX IDX1_WFDataMapTable ON WFDataMapTable (ProcessDefId, ActivityId)')
		PRINT 'ALTER TABLE WFDataMapTable Alter column OrderId INT NOT NULL'
		
		EXECUTE('Alter table EXTMETHODDEFTABLE add tempSearchCriteria integer')
		EXECUTE('update EXTMETHODDEFTABLE set tempSearchCriteria = cast(SearchCriteria as integer)')
		EXECUTE('alter table EXTMETHODDEFTABLE drop column SearchCriteria')
		EXECUTE('sp_RENAME ''EXTMETHODDEFTABLE.tempSearchCriteria'', ''SearchCriteria'' , ''COLUMN''')
 
	IF  EXISTS ( SELECT * FROM sysColumns WHERE 
		id = (SELECT id FROM sysObjects WHERE NAME = 'WFOwnerTable')
		AND  NAME = 'UserId'
		)
	BEGIN
		EXECUTE('ALTER TABLE WFOwnerTable DROP Column UserId')		
		PRINT 'ALTER TABLE WFOwnerTable DROP Column UserId'
	END
	
	IF  EXISTS ( SELECT * FROM sysColumns WHERE 
		id = (SELECT id FROM sysObjects WHERE NAME = 'WFConsultantsTable')
		AND  NAME = 'UserId'
		)
	BEGIN
		EXECUTE('ALTER TABLE WFConsultantsTable DROP Column UserId')		
		PRINT 'ALTER TABLE WFConsultantsTable DROP Column UserId'
	END	
		
		
	END
	
	
	
	/*...............................End of Modify column ....................................................*/
	
		/* Dropping extra columns*/
	IF  EXISTS ( SELECT * FROM sysColumns 
		WHERE 
		id = (SELECT id FROM sysObjects WHERE NAME = 'WFSAPCONNECTTABLE')
		AND  NAME = 'SECURITYFLAG'
		)
	BEGIN
		EXECUTE('ALTER TABLE WFSAPCONNECTTABLE DROP COLUMN SECURITYFLAG')		
	END		
	
	
	IF  EXISTS ( SELECT * FROM sysColumns 
		WHERE 
		id = (SELECT id FROM sysObjects WHERE NAME = 'WFWEBSERVICEINFOTABLE')
		AND  NAME = 'SECURITYFLAG'
		)
	BEGIN
		EXECUTE('ALTER TABLE WFWEBSERVICEINFOTABLE DROP COLUMN SECURITYFLAG')		
	END		
	
	IF  EXISTS ( SELECT * FROM sysColumns 
		WHERE 
		id = (SELECT id FROM sysObjects WHERE NAME = 'WFFORM_TABLE')
		AND  NAME = 'ISAPPLETVIEW'
		)
	BEGIN
		EXECUTE('ALTER TABLE WFFORM_TABLE DROP COLUMN ISAPPLETVIEW')		
	END	
	/*..........................................Adding Constraints.............................................*/
	
	BEGIN
		SELECT @TableId = id FROM sysobjects WHERE name = 'TEMPLATEDEFINITIONTABLE'
		SELECT @ConstraintName = name FROM SYSCONSTRAINTS A, SYSOBJECTS B WHERE A.constid = B.id AND B.xtype = 'PK'AND A.id = @TableId 
		
		IF NOT EXISTS ( SELECT * FROM sysObjects WHERE NAME = @ConstraintName)
		BEGIN
			EXECUTE('alter table TEMPLATEDEFINITIONTABLE add CONSTRAINT Pk_TEMPLATEDEFINITIONTABLE PRIMARY KEY (ProcessdefId,TemplateId)')
			PRINT 'alter table TEMPLATEDEFINITIONTABLE add CONSTRAINT Pk_TEMPLATEDEFINITIONTABLE PRIMARY KEY (ProcessdefId,TemplateId) IN IF CASE'
		END
		ELSE
		BEGIN
			execute('alter table TEMPLATEDEFINITIONTABLE drop CONSTRAINT ' + @ConstraintName)
			EXECUTE('alter table TEMPLATEDEFINITIONTABLE add CONSTRAINT Pk_TEMPLATEDEFINITIONTABLE PRIMARY KEY (ProcessdefId,TemplateId)')
			PRINT 'alter table TEMPLATEDEFINITIONTABLE add CONSTRAINT Pk_TEMPLATEDEFINITIONTABLE PRIMARY KEY (ProcessdefId,TemplateId)'
		END
	END
	
	
	
	BEGIN
		SELECT @TableId = id FROM sysobjects WHERE name = 'TEMPLATEDEFINITIONTABLE'
		SELECT @ConstraintName = name FROM SYSCONSTRAINTS A, SYSOBJECTS B WHERE A.constid = B.id AND B.xtype = 'PK'AND A.id = @TableId 
		
		IF NOT EXISTS ( SELECT * FROM sysObjects WHERE NAME = @ConstraintName)
		BEGIN
			EXECUTE('alter table TEMPLATEDEFINITIONTABLE add CONSTRAINT Pk_TEMPLATEDEFINITIONTABLE PRIMARY KEY (ProcessdefId,TemplateId)')
			PRINT 'alter table TEMPLATEDEFINITIONTABLE add CONSTRAINT Pk_TEMPLATEDEFINITIONTABLE PRIMARY KEY (ProcessdefId,TemplateId) IF CASE'
		END
		ELSE
		BEGIN
			execute('alter table TEMPLATEDEFINITIONTABLE drop CONSTRAINT ' + @ConstraintName)
			EXECUTE('alter table TEMPLATEDEFINITIONTABLE add CONSTRAINT Pk_TEMPLATEDEFINITIONTABLE PRIMARY KEY (ProcessdefId,TemplateId)')
			PRINT 'alter table TEMPLATEDEFINITIONTABLE add CONSTRAINT Pk_TEMPLATEDEFINITIONTABLE PRIMARY KEY (ProcessdefId,TemplateId) ELSE CASE'
		END
	END
	
	
	BEGIN
		SELECT @TableId = id FROM sysobjects WHERE name = 'ProcessdefTable'
		SELECT @ConstraintName = name FROM SYSCONSTRAINTS A, SYSOBJECTS B WHERE A.constid = B.id AND B.xtype = 'PK'AND A.id = @TableId 
		
		IF NOT EXISTS ( SELECT * FROM sysObjects WHERE NAME = @ConstraintName)
		BEGIN
			EXECUTE('alter table ProcessdefTable add PRIMARY KEY (ProcessDefId,VersionNo)')
			PRINT 'alter table ProcessdefTable add PRIMARY KEY (ProcessDefId,VersionNo) IF CASE'
		END
		ELSE
		BEGIN
			execute('alter table ProcessdefTable drop CONSTRAINT ' + @ConstraintName)
			EXECUTE('alter table ProcessdefTable add PRIMARY KEY (ProcessDefId,VersionNo)')
			PRINT 'alter table ProcessdefTable add PRIMARY KEY (ProcessDefId,VersionNo) ELSE CASE'
		END
	END
	
	
	BEGIN
		SELECT @TableId = id FROM sysobjects WHERE name = 'EXTDBFIELDDEFINITIONTABLE'
		SELECT @ConstraintName = name FROM SYSCONSTRAINTS A, SYSOBJECTS B WHERE A.constid = B.id AND B.xtype = 'PK'AND A.id = @TableId 
		
		IF NOT EXISTS ( SELECT * FROM sysObjects WHERE NAME = @ConstraintName)
		BEGIN
			EXECUTE('alter table EXTDBFIELDDEFINITIONTABLE add PRIMARY KEY (ProcessDefId,ExtObjId,FieldName)')
			PRINT 'alter table EXTDBFIELDDEFINITIONTABLE add PRIMARY KEY (ProcessDefId,ExtObjId,FieldName) IF CASE'
		END
		ELSE
		BEGIN
			execute('alter table EXTDBFIELDDEFINITIONTABLE drop CONSTRAINT ' + @ConstraintName)
			EXECUTE('alter table EXTDBFIELDDEFINITIONTABLE add PRIMARY KEY (ProcessDefId,ExtObjId,FieldName)')
			PRINT 'alter table EXTDBFIELDDEFINITIONTABLE add PRIMARY KEY (ProcessDefId,ExtObjId,FieldName) ELSE CASE'
		END
	END
	
	
	BEGIN
		SELECT @TableId = id FROM sysobjects WHERE name = 'ACTIONDEFTABLE'
		SELECT @ConstraintName = name FROM SYSCONSTRAINTS A, SYSOBJECTS B WHERE A.constid = B.id AND B.xtype = 'PK'AND A.id = @TableId 
		
		IF NOT EXISTS ( SELECT * FROM sysObjects WHERE NAME = @ConstraintName)
		BEGIN
			EXECUTE('alter table ACTIONDEFTABLE add CONSTRAINT PK_ACTIONDEFTABLE PRIMARY KEY(ProcessDefId,ActionId,ActivityId)')
			PRINT 'alter table ACTIONDEFTABLE add CONSTRAINT PK_ACTIONDEFTABLE PRIMARY KEY(ProcessDefId,ActionId,ActivityId) IF CASE'
		END
		ELSE
		BEGIN
			execute('alter table ACTIONDEFTABLE drop CONSTRAINT ' + @ConstraintName)
			EXECUTE('alter table ACTIONDEFTABLE add CONSTRAINT PK_ACTIONDEFTABLE PRIMARY KEY(ProcessDefId,ActionId,ActivityId)')
			PRINT 'alter table ACTIONDEFTABLE add CONSTRAINT PK_ACTIONDEFTABLE PRIMARY KEY(ProcessDefId,ActionId,ActivityId) ELSE CASE'
		END
	END
	
	
	BEGIN
		SELECT @TableId = id FROM sysobjects WHERE name = 'TODOLISTDEFTABLE'
		SELECT @ConstraintName = name FROM SYSCONSTRAINTS A, SYSOBJECTS B WHERE A.constid = B.id AND B.xtype = 'PK'AND A.id = @TableId 
		
		IF NOT EXISTS ( SELECT * FROM sysObjects WHERE NAME = @ConstraintName)
		BEGIN
			EXECUTE('alter table TODOLISTDEFTABLE add PRIMARY KEY (ProcessDefId, ToDoId)')
			PRINT 'alter table TODOLISTDEFTABLE add PRIMARY KEY (ProcessDefId, ToDoId) IF CASE'
		END
		ELSE
		BEGIN
			execute('alter table TODOLISTDEFTABLE drop CONSTRAINT ' + @ConstraintName)
			EXECUTE('alter table TODOLISTDEFTABLE add PRIMARY KEY (ProcessDefId, ToDoId)')
			PRINT 'alter table TODOLISTDEFTABLE add PRIMARY KEY (ProcessDefId, ToDoId) ELSE CASE'
		END
	END
	
	
	BEGIN
		SELECT @TableId = id FROM sysobjects WHERE name = 'TODOPICKLISTTABLE'
		SELECT @ConstraintName = name FROM SYSCONSTRAINTS A, SYSOBJECTS B WHERE A.constid = B.id AND B.xtype = 'PK'AND A.id = @TableId 
		
		IF NOT EXISTS ( SELECT * FROM sysObjects WHERE NAME = @ConstraintName)
		BEGIN
			EXECUTE('alter table TODOPICKLISTTABLE add CONSTRAINT PK_TODOPICKLISTTABLE PRIMARY KEY (ProcessDefId,ToDoId,PickListValue)')
			PRINT 'alter table TODOPICKLISTTABLE add CONSTRAINT PK_TODOPICKLISTTABLE PRIMARY KEY (ProcessDefId,ToDoId,PickListValue) IF CASE'
		END
		ELSE
		BEGIN
			execute('alter table TODOPICKLISTTABLE drop CONSTRAINT ' + @ConstraintName)
			EXECUTE('alter table TODOPICKLISTTABLE add CONSTRAINT PK_TODOPICKLISTTABLE PRIMARY KEY (ProcessDefId,ToDoId,PickListValue)')
			PRINT 'alter table TODOPICKLISTTABLE add CONSTRAINT PK_TODOPICKLISTTABLE PRIMARY KEY (ProcessDefId,ToDoId,PickListValue) ELSE CASE'
		END
	END
	
	
	BEGIN
		SELECT @TableId = id FROM sysobjects WHERE name = 'EXCEPTIONDEFTABLE'
		SELECT @ConstraintName = name FROM SYSCONSTRAINTS A, SYSOBJECTS B WHERE A.constid = B.id AND B.xtype = 'PK'AND A.id = @TableId 
		
		IF NOT EXISTS ( SELECT * FROM sysObjects WHERE NAME = @ConstraintName)
		BEGIN
			EXECUTE('alter table EXCEPTIONDEFTABLE add PRIMARY KEY (ProcessDefId, ExceptionId)')
			PRINT 'alter table EXCEPTIONDEFTABLE add PRIMARY KEY (ProcessDefId, ExceptionId) IF CASE'
		END
		ELSE
		BEGIN
			execute('alter table EXCEPTIONDEFTABLE drop CONSTRAINT ' + @ConstraintName)
			EXECUTE('alter table EXCEPTIONDEFTABLE add PRIMARY KEY (ProcessDefId, ExceptionId)')
			PRINT 'alter table EXCEPTIONDEFTABLE add PRIMARY KEY (ProcessDefId, ExceptionId) ELSE CASE'
		END
	END
	
	
	BEGIN
		SELECT @TableId = id FROM sysobjects WHERE name = 'DOCUMENTTYPEDEFTABLE'
		SELECT @ConstraintName = name FROM SYSCONSTRAINTS A, SYSOBJECTS B WHERE A.constid = B.id AND B.xtype = 'PK'AND A.id = @TableId 
		
		IF NOT EXISTS ( SELECT * FROM sysObjects WHERE NAME = @ConstraintName)
		BEGIN
			EXECUTE('alter table DOCUMENTTYPEDEFTABLE add PRIMARY KEY (ProcessDefId, DocId)')
			PRINT 'alter table DOCUMENTTYPEDEFTABLE add PRIMARY KEY (ProcessDefId, DocId) IF CASE'
		END
		ELSE
		BEGIN
			execute('alter table DOCUMENTTYPEDEFTABLE drop CONSTRAINT ' + @ConstraintName)
			EXECUTE('alter table DOCUMENTTYPEDEFTABLE add PRIMARY KEY (ProcessDefId, DocId)')
			PRINT 'alter table DOCUMENTTYPEDEFTABLE add PRIMARY KEY (ProcessDefId, DocId) ELSE CASE'
		END
	END
	
	
	BEGIN
		SELECT @TableId = id FROM sysobjects WHERE name = 'PROCESSINITABLE'
		SELECT @ConstraintName = name FROM SYSCONSTRAINTS A, SYSOBJECTS B WHERE A.constid = B.id AND B.xtype = 'PK'AND A.id = @TableId 
		
		IF NOT EXISTS ( SELECT * FROM sysObjects WHERE NAME = @ConstraintName)
		BEGIN
			EXECUTE('alter table PROCESSINITABLE add CONSTRAINT PK_ProcessINITable PRIMARY KEY(ProcessDefId)')
			PRINT 'alter table PROCESSINITABLE add CONSTRAINT PK_ProcessINITable PRIMARY KEY(ProcessDefId) IF CASE'
		END
		ELSE
		BEGIN
			execute('alter table PROCESSINITABLE drop CONSTRAINT ' + @ConstraintName)
			EXECUTE('alter table PROCESSINITABLE add CONSTRAINT PK_ProcessINITable PRIMARY KEY(ProcessDefId)')
			PRINT 'alter table PROCESSINITABLE add CONSTRAINT PK_ProcessINITable PRIMARY KEY(ProcessDefId) ELSE CASE'
		END
	END
	
	
	BEGIN
		SELECT @TableId = id FROM sysobjects WHERE name = 'PRINTFAXEMAILTABLE'
		SELECT @ConstraintName = name FROM SYSCONSTRAINTS A, SYSOBJECTS B WHERE A.constid = B.id AND B.xtype = 'PK'AND A.id = @TableId 
		
		IF NOT EXISTS ( SELECT * FROM sysObjects WHERE NAME = @ConstraintName)
		BEGIN
			EXECUTE('alter table PRINTFAXEMAILTABLE add CONSTRAINT PK_PRINTFAXEMAILTABLE PRIMARY KEY(ProcessDefId,PFEInterfaceId)')
			PRINT 'alter table PRINTFAXEMAILTABLE add CONSTRAINT PK_PRINTFAXEMAILTABLE PRIMARY KEY(ProcessDefId,PFEInterfaceId) IF CASE'
		END
		ELSE
		BEGIN
			execute('alter table PRINTFAXEMAILTABLE drop CONSTRAINT ' + @ConstraintName)
			EXECUTE('alter table PRINTFAXEMAILTABLE add CONSTRAINT PK_PRINTFAXEMAILTABLE PRIMARY KEY(ProcessDefId,PFEInterfaceId)')
			PRINT 'alter table PRINTFAXEMAILTABLE add CONSTRAINT PK_PRINTFAXEMAILTABLE PRIMARY KEY(ProcessDefId,PFEInterfaceId) ELSE CASE'
		END
	END
	
	
	BEGIN
		SELECT @TableId = id FROM sysobjects WHERE name = 'WFFORM_TABLE'
		Print @TableId
		SELECT @ConstraintName = name FROM SYSCONSTRAINTS A, SYSOBJECTS B WHERE A.constid = B.id AND B.xtype = 'PK'AND A.id = @TableId 
		Print 'ConstraintName for form is' + @ConstraintName
		IF NOT EXISTS ( SELECT * FROM sysObjects WHERE NAME = @ConstraintName)
		BEGIN
			EXECUTE('alter table WFFORM_TABLE add CONSTRAINT PK_WFFORM_TABLE PRIMARY KEY(ProcessDefID,FormId)')
			PRINT 'alter table WFFORM_TABLE add CONSTRAINT PK_WFFORM_TABLE PRIMARY KEY(ProcessDefID,FormId) IF CASE'
		END
		ELSE
		BEGIN
			execute('alter table WFFORM_TABLE drop CONSTRAINT ' + @ConstraintName)
			EXECUTE('alter table WFFORM_TABLE add CONSTRAINT PK_WFFORM_TABLE PRIMARY KEY(ProcessDefID,FormId)')
			PRINT 'alter table WFFORM_TABLE add CONSTRAINT PK_WFFORM_TABLE PRIMARY KEY(ProcessDefID,FormId) ELSE CASE'
		END
	END
	
	
	BEGIN
		SELECT @TableId = id FROM sysobjects WHERE name = 'TemplateMultiLanguageTable'
		Print @TableId
		SELECT @ConstraintName = name FROM SYSCONSTRAINTS A, SYSOBJECTS B WHERE A.constid = B.id AND B.xtype = 'PK'AND A.id = @TableId 
		Print 'ConstraintName for TemplateMultiLanguageTable is' + @ConstraintName
		IF NOT EXISTS ( SELECT * FROM sysObjects WHERE NAME = @ConstraintName)
		BEGIN
			EXECUTE('Alter Table TemplateMultiLanguageTable add CONSTRAINT PK_TemplateMultiLanguageTable PRIMARY KEY (ProcessdefId,TemplateId,Locale)')
			PRINT 'alter table TemplateMultiLanguageTable add CONSTRAINT PK_TemplateMultiLanguageTable PRIMARY KEY (ProcessdefId,TemplateId,Locale) IF CASE'
		END
		ELSE
		BEGIN
			execute('alter table TemplateMultiLanguageTable drop CONSTRAINT ' + @ConstraintName)
			EXECUTE('alter table TemplateMultiLanguageTable add CONSTRAINT PK_TemplateMultiLanguageTable PRIMARY KEY (ProcessdefId,TemplateId,Locale)')
			PRINT 'alter table TemplateMultiLanguageTable add CONSTRAINT PK_TemplateMultiLanguageTable PRIMARY KEY (ProcessdefId,TemplateId,Locale) ELSE CASE'
		END
	END
	
	
	BEGIN
		SELECT @TableId = id FROM sysobjects WHERE name = 'InterfaceDescLanguageTable'
		SELECT @ConstraintName = name FROM SYSCONSTRAINTS A, SYSOBJECTS B WHERE A.constid = B.id AND B.xtype = 'PK'AND A.id = @TableId 
		
		IF NOT EXISTS ( SELECT * FROM sysObjects WHERE NAME = @ConstraintName)
		BEGIN
			EXECUTE('alter table InterfaceDescLanguageTable add CONSTRAINT PK_InterfaceDescLanguageTable PRIMARY KEY (ProcessDefId,ElementId,InterfaceID)')
			PRINT 'alter table InterfaceDescLanguageTable add CONSTRAINT PK_InterfaceDescLanguageTable PRIMARY KEY (ProcessDefId,ElementId,InterfaceID) IF CASE'
		END
		ELSE
		BEGIN
			execute('alter table InterfaceDescLanguageTable drop CONSTRAINT ' + @ConstraintName)
			EXECUTE('alter table InterfaceDescLanguageTable add CONSTRAINT PK_InterfaceDescLanguageTable PRIMARY KEY (ProcessDefId,ElementId,InterfaceID)')
			PRINT 'alter table InterfaceDescLanguageTable add CONSTRAINT PK_InterfaceDescLanguageTable PRIMARY KEY (ProcessDefId,ElementId,InterfaceID) ELSE CASE'
		END
	END
	
	
	BEGIN
		SELECT @TableId = id FROM sysobjects WHERE name = 'WFSwimLaneTable'
		SELECT @ConstraintName = name FROM SYSCONSTRAINTS A, SYSOBJECTS B WHERE A.constid = B.id AND B.xtype = 'PK'AND A.id = @TableId 
		
		IF NOT EXISTS ( SELECT * FROM sysObjects WHERE NAME = @ConstraintName)
		BEGIN
			EXECUTE('alter table WFSwimLaneTable add PRIMARY KEY ( ProcessDefId, SwimLaneId)')
			PRINT 'alter table WFSwimLaneTable add PRIMARY KEY ( ProcessDefId, SwimLaneId) IF CASE'
		END
		ELSE
		BEGIN
			execute('alter table WFSwimLaneTable drop CONSTRAINT ' + @ConstraintName)
			EXECUTE('alter table WFSwimLaneTable add PRIMARY KEY ( ProcessDefId, SwimLaneId)')
			PRINT 'alter table WFSwimLaneTable add PRIMARY KEY ( ProcessDefId, SwimLaneId) ELSE CASE'
		END
	END
	
	
	BEGIN
		SELECT @TableId = id FROM sysobjects WHERE name = 'WFSwimLaneTable'
		SELECT @ConstraintName = name FROM SYSCONSTRAINTS A, SYSOBJECTS B WHERE A.constid = B.id AND B.xtype = 'UQ' AND A.id = @TableId 
		
		IF NOT EXISTS ( SELECT * FROM sysObjects WHERE NAME = @ConstraintName)
		BEGIN
			EXECUTE('alter table WFSwimLaneTable add UNIQUE(ProcessDefId, SwimLaneText)')
			PRINT 'alter table WFSwimLaneTable add UNIQUE(ProcessDefId, SwimLaneText) IF CASE'
		END
		ELSE
		BEGIN
			execute('alter table WFSwimLaneTable drop CONSTRAINT ' + @ConstraintName)
			EXECUTE('alter table WFSwimLaneTable add UNIQUE(ProcessDefId, SwimLaneText)')
			PRINT 'alter table WFSwimLaneTable add UNIQUE(ProcessDefId, SwimLaneText) ELSE CASE'
		END
	END
	
	
	BEGIN
		SELECT @TableId = id FROM sysobjects WHERE name = 'WFDataMapTable'
		SELECT @ConstraintName = name FROM SYSCONSTRAINTS A, SYSOBJECTS B WHERE A.constid = B.id AND B.xtype = 'PK'AND A.id = @TableId 
		
		IF NOT EXISTS ( SELECT * FROM sysObjects WHERE NAME = @ConstraintName)
		BEGIN
			Execute ('alter table WFDataMapTable add PRIMARY KEY (ProcessDefId, ActivityId, OrderId)')
			PRINT 'alter table WFDataMapTable add PRIMARY KEY (ProcessDefId, ActivityId, OrderId) IF CASE'
		END
		ELSE
		BEGIN
			execute('alter table WFDataMapTable drop CONSTRAINT ' + @ConstraintName)
			execute('alter table WFDataMapTable add PRIMARY KEY (ProcessDefId, ActivityId, OrderId)')
			PRINT 'alter table WFDataMapTable add PRIMARY KEY (ProcessDefId, ActivityId, OrderId) ELSE CASE'
		END
	END
	
	
	BEGIN
		SELECT @TableId = id FROM sysobjects WHERE name = 'WFExtInterfaceConditionTable'
		SELECT @ConstraintName = name FROM SYSCONSTRAINTS A, SYSOBJECTS B WHERE A.constid = B.id AND B.xtype = 'PK'AND A.id = @TableId 
		
		IF NOT EXISTS ( SELECT * FROM sysObjects WHERE NAME = @ConstraintName)
		BEGIN
			EXECUTE('alter table WFExtInterfaceConditionTable add PRIMARY KEY (ProcessDefId, InterFaceType, RuleId, ConditionOrderId)')
			PRINT 'alter table WFExtInterfaceConditionTable add PRIMARY KEY (ProcessDefId, InterFaceType, RuleId, ConditionOrderId) IF CASE'
		END
		ELSE
		BEGIN
			execute('alter table WFExtInterfaceConditionTable drop CONSTRAINT ' + @ConstraintName)
			EXECUTE('alter table WFExtInterfaceConditionTable add PRIMARY KEY (ProcessDefId, InterFaceType, RuleId, ConditionOrderId)')
			PRINT 'alter table WFExtInterfaceConditionTable add PRIMARY KEY (ProcessDefId, InterFaceType, RuleId, ConditionOrderId) ELSE CASE'
		END
	END
	
	
	BEGIN
		SELECT @TableId = id FROM sysobjects WHERE name = 'WFFormFragmentTable'
		SELECT @ConstraintName = name FROM SYSCONSTRAINTS A, SYSOBJECTS B WHERE A.constid = B.id AND B.xtype = 'PK'AND A.id = @TableId 
		
		IF NOT EXISTS ( SELECT * FROM sysObjects WHERE NAME = @ConstraintName)
		BEGIN
			EXECUTE('alter table WFFormFragmentTable add CONSTRAINT PK_WFFormFragmentTable PRIMARY KEY(ProcessDefId,FragmentId)')
			PRINT 'alter table WFFormFragmentTable add CONSTRAINT PK_WFFormFragmentTable PRIMARY KEY(ProcessDefId,FragmentId) IF CASE'
		END
		ELSE
		BEGIN
			execute('alter table WFFormFragmentTable drop CONSTRAINT ' + @ConstraintName)
			EXECUTE('alter table WFFormFragmentTable add CONSTRAINT PK_WFFormFragmentTable PRIMARY KEY(ProcessDefId,FragmentId)')
			PRINT 'alter table WFFormFragmentTable add CONSTRAINT PK_WFFormFragmentTable PRIMARY KEY(ProcessDefId,FragmentId) ELSE CASE'
		END
	END
	
	
	/*......................................... End of Constraints Addition .....................................*/
	

	/*............................... Modify old Trigger .....................................................*/
	
	IF OBJECT_ID('WF_USR_DEL', 'TR') IS NOT NULL
	BEGIN
		DROP TRIGGER WF_USR_DEL
	END
		IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id('pdbUser') AND xType='U')
	Begin
		EXECUTE('
	CREATE TRIGGER WF_USR_DEL 
		       on PDBUSER 
		       AFTER UPDATE 
	        AS
			DECLARE @Assgn NVARCHAR(63),
				@Assgnid INT,
				@DeletedFlag NVARCHAR(1)	
			IF(UPDATE(DeletedFlag))
			BEGIN
				SELECT @Assgn = INSERTED.UserName , @Assgnid = INSERTED.UserIndex, @DeletedFlag = INSERTED.DeletedFlag FROM INSERTED
				IF(@DeletedFlag = ''Y'')
				BEGIN
					
					DELETE FROM QUEUEUSERTABLE  WHERE UserID = @Assgnid AND Associationtype = 0
					DELETE FROM PMWQUEUEUSERTABLE  WHERE UserID = @Assgnid AND Associationtype = 0
					DELETE FROM USERPREFERENCESTABLE WHERE UserID = @Assgnid
					DELETE FROM USERDIVERSIONTABLE WHERE Diverteduserindex = @Assgnid OR AssignedUserindex = @Assgnid
					DELETE FROM USERWORKAUDITTABLE WHERE Userindex = @Assgnid OR Auditoruserindex = @Assgnid
					DELETE FROM WFProfileObjTypeTable WHERE UserID = @Assgnid AND Associationtype = 0
					DELETE FROM WFUserObjAssocTable WHERE UserID = @Assgnid AND Associationtype = 0
				END				
			END
         ')

	END
	
	
	/*............................. End  of modify Trigger ..................................................*/
	
/*................................... Adding new Indexes  ...................................................*/
	
	
	IF EXISTS (SELECT *	FROM sysindexes	WHERE id = OBJECT_ID('SummaryTable')
		AND name = 'IX1_SUMMARYTABLE') 
	BEGIN
		Drop index SummaryTable.IX1_SUMMARYTABLE
	END
		
   IF EXISTS (SELECT *	FROM sysindexes	WHERE id = OBJECT_ID('SummaryTable')
		AND name = 'IDX2_SUMMARYTABLE') 
	Begin
	   Drop index SummaryTable.IDX2_SUMMARYTABLE
	END
	
	
	IF NOT EXISTS (SELECT *	FROM sysindexes	WHERE id = OBJECT_ID('ActivityTable')
		AND name = 'IDX1_ActivityTable') 
	BEGIN
		
		EXECUTE('CREATE INDEX IDX1_ActivityTable ON ActivityTable (ActivityType)')
		EXECUTE('CREATE INDEX IDX4_WFCRouteLogTable ON WFCurrentRouteLogTable (ProcessInstanceId, ActionDateTime, LogID)')
		EXECUTE('CREATE INDEX  IDX4_WFHRouteLogTABLE ON WFHISTORYROUTELOGTABLE (ProcessInstanceId, ActionDateTime, LogID)')
		EXECUTE('CREATE INDEX IDX1_SUMMARYTABLE ON SUMMARYTABLE
        (PROCESSDEFID, ACTIONID, ActionDateTime, ACTIVITYID, QueueId, USERID)')
		EXECUTE('CREATE INDEX  IDX2_QueueHistoryTable ON QueueHistoryTable (ActivityName)')
		EXECUTE('CREATE INDEX  IDX3_QueueHistoryTable ON QueueHistoryTable (VAR_REC_1, VAR_REC_2)')
		EXECUTE('CREATE INDEX  IDX4_QueueHistoryTable ON QueueHistoryTable (Q_QueueId)')
		EXECUTE('CREATE INDEX IDX2_WORKDONETABLE ON WORKDONETABLE (ActivityName) ')
		EXECUTE('CREATE INDEX IDX4_WorkListTable ON WORKLISTTABLE (Q_UserID)')
		EXECUTE('CREATE INDEX IDX5_WorkListTable ON WORKLISTTABLE (ActivityName)')
		EXECUTE('CREATE INDEX IDX6_WorkListTable ON WORKLISTTABLE (ProcessDefId, ActivityId)')
		EXECUTE('CREATE INDEX IDX4_WorkInProcessTable ON WorkInProcessTable (Q_UserId)')
		EXECUTE('CREATE INDEX IDX5_WorkInProcessTable ON WorkInProcessTable (ActivityName)')
		EXECUTE('CREATE INDEX IDX1_WorkWithPSTable ON WorkWithPSTable (Q_UserId)')
		EXECUTE('CREATE INDEX IDX2_WorkWithPSTable ON WorkWithPSTable (ActivityName)')
		EXECUTE('CREATE INDEX IDX1_PendingWorkListTable ON PendingWorkListTable (Q_UserId)')
		EXECUTE('CREATE INDEX IDX2_PendingWorkListTable ON PendingWorkListTable (ActivityName)')
		EXECUTE('CREATE INDEX IDX2_QueueStreamTable ON QueueStreamTable (Activityid, Streamid)')
		EXECUTE('CREATE INDEX IDX3_ExceptionTable ON ExceptionTable (ProcessDefId, ActivityId)')
		EXECUTE('CREATE INDEX IDX1_TODOSTATUSTABLE ON TODOSTATUSTABLE (ProcessInstanceId)')
		EXECUTE('CREATE INDEX IDX1_TODOSTATUSHISTORYTABLE ON TODOSTATUSHISTORYTABLE (ProcessInstanceId)')
		
		PRINT 'INDEXES CREATED SUCCESSFULLY'

	END
	
	

		
		

/*.................................. End of Adding new Indexes ..............................................*/

/* ........................................ Adding new view .................................................*/

/*	IF NOT EXISTS (SELECT * FROM sysobjects WHERE ID = OBJECT_ID(N'PROFILEUSERGROUPVIEW')
	AND OBJECTPROPERTY(id, N'IsView') = 1)
	BEGIN
		
		EXECUTE('CREATE VIEW PROFILEUSERGROUPVIEW 
				 AS
				SELECT profileId,userid, NULL groupid, AssignedtillDateTime
				FROM WFUserObjAssocTable (NOLOCK) WHERE Associationtype=0
				AND (AssignedtillDateTime is NULL or AssignedtillDateTime>=getdate())
				UNION
				SELECT profileId, userindex,userId AS groupid,NULL AssignedtillDateTime
				FROM WFUserObjAssocTable (NOLOCK), WFGROUPMEMBERVIEW (NOLOCK)
				WHERE Associationtype=1 AND WFUserObjAssocTable.userid=WFGROUPMEMBERVIEW.groupindex ')
		PRINT 'VIEW PROFILEUSERGROUPVIEW CREATED SUCCESSFULLY'
	END*/
	
	IF  EXISTS (SELECT * FROM sysobjects WHERE ID = OBJECT_ID(N'PROFILEUSERGROUPVIEW')
	AND OBJECTPROPERTY(id, N'IsView') = 1)
	BEGIN
		EXECUTE('DROP VIEW PROFILEUSERGROUPVIEW')
	
		EXECUTE('CREATE VIEW PROFILEUSERGROUPVIEW
		AS
		SELECT profileId,userid, NULL groupid, NULL roleid, AssignedtillDateTime
		FROM WFUserObjAssocTable (NOLOCK)
		WHERE Associationtype=0
		AND (AssignedtillDateTime is NULL or AssignedtillDateTime>=getdate())
		UNION
		SELECT profileId, userindex as userid, userId AS groupid, NULL roleid, NULL AssignedtillDateTime
	FROM WFUserObjAssocTable (NOLOCK), WFGROUPMEMBERVIEW (NOLOCK)
	WHERE Associationtype=1
	AND WFUserObjAssocTable.userid=WFGROUPMEMBERVIEW.groupindex 
	AND (AssignedtillDateTime is NULL or AssignedtillDateTime>=getdate())
	UNION
	SELECT profileId, userindex as userid, groupindex as groupid, userId AS roleid, NULL AssignedtillDateTime
	FROM WFUserObjAssocTable (NOLOCK), PDBGroupRoles (NOLOCK)
	WHERE Associationtype=3
	AND WFUserObjAssocTable.userid=PDBGroupRoles.RoleIndex 
	AND (AssignedtillDateTime is NULL or AssignedtillDateTime>=getdate())')
		
		PRINT 'VIEW PROFILEUSERGROUPVIEW CREATED SUCCESSFULLY'
	END
	

IF NOT  EXISTS (SELECT * FROM sysobjects WHERE ID = OBJECT_ID(N'PROFILEUSERGROUPVIEW')
	AND OBJECTPROPERTY(id, N'IsView') = 1)
	BEGIN
		EXECUTE('CREATE VIEW PROFILEUSERGROUPVIEW
		AS
		SELECT profileId,userid, NULL groupid, NULL roleid, AssignedtillDateTime
		FROM WFUserObjAssocTable (NOLOCK)
		WHERE Associationtype=0
		AND (AssignedtillDateTime is NULL or AssignedtillDateTime>=getdate())
		UNION
		SELECT profileId, userindex as userid, userId AS groupid, NULL roleid, NULL AssignedtillDateTime
	FROM WFUserObjAssocTable (NOLOCK), WFGROUPMEMBERVIEW (NOLOCK)
	WHERE Associationtype=1
	AND WFUserObjAssocTable.userid=WFGROUPMEMBERVIEW.groupindex 
	AND (AssignedtillDateTime is NULL or AssignedtillDateTime>=getdate())
	UNION
	SELECT profileId, userindex as userid, groupindex as groupid, userId AS roleid, NULL AssignedtillDateTime
	FROM WFUserObjAssocTable (NOLOCK), PDBGroupRoles (NOLOCK)
	WHERE Associationtype=3
	AND WFUserObjAssocTable.userid=PDBGroupRoles.RoleIndex 
	AND (AssignedtillDateTime is NULL or AssignedtillDateTime>=getdate())')
		
		PRINT 'VIEW PROFILEUSERGROUPVIEW CREATED SUCCESSFULLY'
	END
	
	
	IF NOT  EXISTS (SELECT * FROM sysobjects WHERE ID = OBJECT_ID(N'WFROLEVIEW')
	AND OBJECTPROPERTY(id, N'IsView') = 1)
		BEGIN
			EXECUTE('
				CREATE VIEW WFROLEVIEW 
				AS 
				SELECT roleindex, rolename, description, manyuserflag
				FROM PDBROLES
			')
		END
	
/* .................................... End of Adding new view .................................................*/
/*  Inserting Default values in WFMileStoneTable and WFSwimLaneTable for the exsisting Processses  */
BEGIN
Declare @sql_insert1 varchar(max)
DECLARE cur_processDef CURSOR FOR  
SELECT Processdefid from processdeftable 

OPEN cur_processDef   
FETCH NEXT FROM cur_processDef INTO @Processdefid   

WHILE @@FETCH_STATUS = 0   
BEGIN   

If Not Exists(Select * from WFMIleStoneTable where processdefid = @ProcessDefId)
   BEGIN
       Insert into WFMIleStoneTable(ProcessDefId, MileStoneId,MileStoneSeqId,MileStoneName,MileStoneWidth,MileStoneHeight,ITop,ILeft,BackColor,Description,isExpanded,Cost,Duration) Values (@ProcessDefId, 1,1,'MileDefault',0,0,0,0,1234,'DefaultDescription',' ',0.00,null)
	  
	END
If Not Exists(Select * from WFSwimLanetable where processdefid = @ProcessDefId)
   BEGIN
		Set @sql_insert1 = 'Insert into WFSwimLaneTable(ProcessDefId, SwimLaneId,SwimLaneWidth,SwimLaneHeight,ITop,ILeft,BackColor,SwimLaneType,SwimLaneText,SwimLaneTextColor,PoolId,IndexInPool) Values (' +CONVERT(Varchar(max),@ProcessDefId)+ ', 1,754,258,0,0,1234,''H'',''SwimLane_1'',-16777216,-1,-1)'
       Execute(@sql_insert1)
	  
	END	
	
       FETCH NEXT FROM cur_processDef INTO @Processdefid   
END   

CLOSE cur_processDef   
DEALLOCATE cur_processDef 
END
/* Inserting Missing Values in QueuedefTable and WFLnaqueueTable*/
BEGIN
			Declare @processDefId_lane int
			
			Declare @processname_lane varchar(MAX) 
			
			Declare @Qname varchar(max)
			
			
			DECLARE cur_Lane_Queue CURSOR FOR  
			SELECT ProcessDefId,ProcessName  from PROCESSDEFTABLE 

			OPEN cur_Lane_Queue
   
			FETCH NEXT FROM cur_Lane_Queue INTO @processDefId_lane,@processname_lane
			
			WHILE @@FETCH_STATUS = 0 
			BEGIN
			
			If Not Exists(Select * from WFLaneQueueTable where processdefid = @processDefId_lane)
				BEGIN
					Select @Qname =  @processname_lane + '_SwimLane_1'
					Insert into QueueDefTable (QueueName, QueueType, Comments, OrderBy, SortOrder) values 
					(@Qname, 'F', 'Process Modeler generated Default Swimlane Queue', 10, 'A')
		
					Insert into WFLaneQueueTable(ProcessDefId,SwimLaneId,QueueID) Values (@processDefId_lane,1,SCOPE_IDENTITY())
				
				END
				
			
			 FETCH NEXT FROM cur_Lane_Queue INTO @processDefId_lane,@processname_lane
	  

		END
	CLOSE cur_Lane_Queue   
	DEALLOCATE cur_Lane_Queue 
END
/* End of cursor*/		
	  
    IF EXISTS(SELECT * FROM sysObjects WHERE NAME = 'WFSAPConnectTable')
    BEGIN
        IF NOT EXISTS ( SELECT * FROM sysColumns WHERE 
        id = (SELECT id FROM sysObjects WHERE NAME = 'WFSAPConnectTable')
        AND  NAME in ('ConfigurationID','RFCHostName','ConfigurationName'))
        BEGIN
         EXECUTE('ALTER TABLE WFSAPConnectTable ADD ConfigurationID Integer NOT NULL DEFAULT 0, RFCHostName nvarchar(64), ConfigurationName nvarchar(64)')
         PRINT 'Table WFSAPConnectTable altered with new Column ConfigurationID, RFCHostName and ConfigurationName'
        END
    END
    
    BEGIN
    SELECT @SAPconstrnName =  constraint_name 
    FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS 
    where table_name = 'WFSAPConnectTable'    
    IF (@SAPconstrnName IS NOT NULL AND (LEN(@SAPconstrnName) > 0))
    BEGIN
        EXECUTE ('alter table WFSAPConnectTable drop constraint ' + @SAPconstrnName)  
        PRINT 'Table WFSAPConnectTable altered, constraint on ProcessDefID dropped.'
    END
    EXECUTE('ALTER TABLE WFSAPConnectTable ALTER COLUMN ConfigurationID INT NOT NULL')
    EXECUTE('ALTER TABLE WFSAPConnectTable ADD CONSTRAINT pk_WFSAPConnect PRIMARY KEY (ProcessDefId, ConfigurationID)')
    PRINT 'Table WFSAPConnectTable altered, constraint on ProcessDefID and ConfigurationID created.'
    END
    
    IF EXISTS(SELECT * FROM sysObjects WHERE NAME = 'WFSAPGUIAssocTable')
    BEGIN
       IF NOT EXISTS ( SELECT * FROM sysColumns WHERE 
       id = (SELECT id FROM sysObjects WHERE NAME = 'WFSAPGUIAssocTable')
       AND  NAME in ('ConfigurationID'))
        BEGIN
         EXECUTE('ALTER TABLE WFSAPGUIAssocTable ADD ConfigurationID Integer')
         PRINT 'Table WFSAPGUIAssocTable altered with new Column ConfigurationID'
        END
    END

    IF EXISTS(SELECT * FROM sysObjects WHERE NAME = 'WFSAPadapterAssocTable')
    BEGIN
      IF NOT EXISTS ( SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'WFSAPadapterAssocTable')
      AND  NAME in ('ConfigurationID'))
      BEGIN
        EXECUTE('ALTER TABLE WFSAPadapterAssocTable ADD ConfigurationID Integer')
        PRINT 'Table WFSAPadapterAssocTable altered with new Column ConfigurationID'
      END
    END

    IF EXISTS(SELECT * FROM sysObjects WHERE NAME = 'ExtMethodDefTable')
    BEGIN
      IF NOT EXISTS ( SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'ExtMethodDefTable')
      AND  NAME in ('ConfigurationID'))
      BEGIN
        EXECUTE('ALTER TABLE ExtMethodDefTable ADD ConfigurationID Integer')
        PRINT 'Table ExtMethodDefTable altered with new Column ConfigurationID'
      END
    END

    IF NOT EXISTS(SELECT * FROM WFCabVersionTable WHERE CabVersion = '9.0_SAP_CONFIGURATION')
    BEGIN
        Execute ('Update WFSAPConnectTable Set RFCHostName = SAPHostName, ConfigurationName = ''DEFAULT''')
        SET @ConfigurationId = 0
        DECLARE cursorSAPConfig CURSOR STATIC FOR
        SELECT ProcessDefId FROM WFSAPConnectTable 
        OPEN cursorSAPConfig
        FETCH NEXT FROM cursorSAPConfig INTO @ProcessDefId
        WHILE(@@FETCH_STATUS = 0) 
        BEGIN 
            SET @ConfigurationId = @ConfigurationId + 1
            BEGIN TRANSACTION trans


                EXECUTE(' UPDATE WFSAPConnectTable SET ConfigurationId = ' + @ConfigurationId + ' WHERE ProcessDefId = ' + @ProcessDefId)
                EXECUTE(' UPDATE WFSAPGUIAssocTable SET ConfigurationId = ' + @ConfigurationId + ' WHERE ProcessDefId = ' + @ProcessDefId)
                EXECUTE(' UPDATE WFSAPadapterAssocTable SET ConfigurationId = ' + @ConfigurationId + ' WHERE ProcessDefId = ' + @ProcessDefId)
                EXECUTE(' UPDATE ExtMethodDefTable SET ConfigurationId = ' + @ConfigurationId + ' WHERE ProcessDefId = ' + @ProcessDefId)
            COMMIT TRANSACTION trans


            FETCH NEXT FROM cursorSAPConfig INTO @ProcessDefId
        END
		CLOSE cursorSAPConfig   
	DEALLOCATE cursorSAPConfig	
		
    END    


/* Updating VariableId1 in VarAliasTable */
IF NOT EXISTS ( SELECT * FROM sysColumns 
        WHERE 
        id = (SELECT id FROM sysObjects WHERE NAME = 'VarAliasTable')
        AND  NAME = 'VariableId1'
        )
    BEGIN
        EXECUTE('ALTER TABLE VarAliasTable ADD VariableId1 INT DEFAULT 0')
        PRINT 'Table VarAliasTable altered with new Column VariableId1'
        
        DECLARE alias_cursor CURSOR FAST_FORWARD FOR
            SELECT DISTINCT PARAM1, VariableId, VariableType FROM VARMAPPINGTABLE  A, VARALIASTABLE B WHERE A.SYSTEMDEFINEDNAME = B.PARAM1 AND A.ProcessDefId = (select max(ProcessDefId) from ProcessDefTable)
            OPEN alias_cursor
            FETCH alias_cursor INTO @PARAM1, @v_VariableId, @VariableType
            WHILE(@@FETCH_STATUS = 0) 
            BEGIN 
                BEGIN TRANSACTION trans
                    SELECT @v_VariableId = @v_VariableId + 100
                    EXECUTE(' Update VarAliasTable Set VariableId1 = ' + @v_VariableId + ' , Type1 = ' + @VariableType + ' Where Param1 = ' + @quoteChar + @PARAM1 + @quoteChar)
                COMMIT TRANSACTION trans

                FETCH NEXT FROM alias_cursor INTO @PARAM1, @v_VariableId, @VariableType
            END
            CLOSE alias_cursor
        DEALLOCATE alias_cursor
    END

/* End of Updating VariableId1 in VarAliasTable */

	IF NOT EXISTS ( SELECT * FROM sysColumns 
		WHERE 
		id = (SELECT id FROM sysObjects WHERE NAME = 'ActivityAssociationTable')
		AND  NAME = 'ProcessVariantId'
		)
	BEGIN
		EXECUTE('Alter Table ActivityAssociationTable add ProcessVariantId Integer Default 0 NOT NULL')		
		Print 'ActivityAssociationTable Altered successfully'				
	END
	
	IF NOT EXISTS ( SELECT * FROM sysColumns 
		WHERE 
		id = (SELECT id FROM sysObjects WHERE NAME = 'VarMappingTable')
		AND  NAME = 'ProcessVariantId'
		)
	BEGIN
		EXECUTE('Alter Table VarMappingTable add ProcessVariantId Integer Default 0 NOT NULL')		
		Print 'VarMappingTable Altered successfully'				
	END
	
	IF NOT EXISTS ( SELECT * FROM sysColumns 
		WHERE 
		id = (SELECT id FROM sysObjects WHERE NAME = 'WFUDTVarMappingTable')
		AND  NAME = 'ProcessVariantId'
		)
	BEGIN
		EXECUTE('Alter Table WFUDTVarMappingTable add ProcessVariantId Integer Default 0 NOT NULL ')		
		Print 'WFUDTVarMappingTable Altered successfully'				
	END
	
	IF NOT EXISTS ( SELECT * FROM sysColumns 
		WHERE 
		id = (SELECT id FROM sysObjects WHERE NAME = 'ExtDBConfTable')
		AND  NAME = 'ProcessVariantId'
		)
	BEGIN
		EXECUTE('Alter Table ExtDBConfTable add ProcessVariantId Integer Default 0 NOT NULL ')		
		Print 'ExtDBConfTable Altered successfully'				
	END
	
	IF NOT EXISTS ( SELECT * FROM sysColumns 
		WHERE 
		id = (SELECT id FROM sysObjects WHERE NAME = 'DocumentTypeDefTable')
		AND  NAME = 'ProcessVariantId'
		)
	BEGIN
		EXECUTE('Alter Table DocumentTypeDefTable add ProcessVariantId Integer Default 0 NOT NULL ')		
		Print 'DocumentTypeDefTable Altered successfully'				
	END
	
	IF NOT EXISTS ( SELECT * FROM sysColumns 
		WHERE 
		id = (SELECT id FROM sysObjects WHERE NAME = 'WFTypeDefTable')
		AND  NAME = 'ProcessVariantId'
		)
	BEGIN
		EXECUTE('Alter Table WFTypeDefTable add ProcessVariantId Integer Default 0 NOT NULL ')		
		Print 'WFTypeDefTable Altered successfully'				
	END
	
	IF NOT EXISTS ( SELECT * FROM sysColumns 
		WHERE 
		id = (SELECT id FROM sysObjects WHERE NAME = 'WFTypeDescTable')
		AND  NAME = 'ProcessVariantId'
		)
	BEGIN
		EXECUTE('Alter Table WFTypeDescTable add ProcessVariantId Integer Default 0 NOT NULL')		
		Print 'WFTypeDescTable Altered successfully'				
	END
	
	IF NOT EXISTS ( SELECT * FROM sysColumns 
		WHERE 
		id = (SELECT id FROM sysObjects WHERE NAME = 'WFVarRelationTable')
		AND  NAME = 'ProcessVariantId'
		)
	BEGIN
		EXECUTE('Alter Table WFVarRelationTable add ProcessVariantId Integer Default 0 NOT NULL')		
		Print 'WFVarRelationTable Altered successfully'				
	END
	
	IF NOT EXISTS ( SELECT * FROM sysColumns 
		WHERE 
		id = (SELECT id FROM sysObjects WHERE NAME = 'TemplateMultiLanguageTable')
		AND  NAME = 'ProcessVariantId'
		)
	BEGIN
		EXECUTE('Alter Table TemplateMultiLanguageTable add ProcessVariantId Integer Default 0 NOT NULL')		
		Print 'TemplateMultiLanguageTable Altered successfully'				
	END
	
	IF NOT EXISTS ( SELECT * FROM sysColumns 
		WHERE 
		id = (SELECT id FROM sysObjects WHERE NAME = 'ActivityInterfaceAssocTable')
		AND  NAME = 'ProcessVariantId'
		)
	BEGIN
		EXECUTE('Alter Table ActivityInterfaceAssocTable add ProcessVariantId Integer Default 0 NOT NULL')		
		Print 'ActivityInterfaceAssocTable Altered successfully'				
	END
	
	IF NOT EXISTS ( SELECT * FROM sysColumns 
		WHERE 
		id = (SELECT id FROM sysObjects WHERE NAME = 'WFForm_Table')
		AND  NAME = 'ProcessVariantId'
		)
	BEGIN
		EXECUTE('Alter Table WFForm_Table add ProcessVariantId Integer Default 0 NOT NULL')		
		Print 'WFForm_Table Altered successfully'				
	END
	
	IF NOT EXISTS ( SELECT * FROM sysColumns 
		WHERE 
		id = (SELECT id FROM sysObjects WHERE NAME = 'ProcessInstanceTable')
		AND  NAME = 'ProcessVariantId'
		)
	BEGIN
		EXECUTE('Alter Table ProcessInstanceTable add ProcessVariantId Integer Default 0 NOT NULL')		
		Print 'ProcessInstanceTable Altered successfully'				
	END
	
	IF NOT EXISTS ( SELECT * FROM sysColumns 
		WHERE 
		id = (SELECT id FROM sysObjects WHERE NAME = 'WorkDoneTable')
		AND  NAME = 'ProcessVariantId'
		)
	BEGIN
		EXECUTE('Alter Table WorkDoneTable add ProcessVariantId Integer Default 0 NOT NULL')		
		Print 'WorkDoneTable Altered successfully'				
	END
	
	IF NOT EXISTS ( SELECT * FROM sysColumns 
		WHERE 
		id = (SELECT id FROM sysObjects WHERE NAME = 'WorkInProcessTable')
		AND  NAME = 'ProcessVariantId'
		)
	BEGIN
		EXECUTE('Alter Table WorkInProcessTable add ProcessVariantId Integer Default 0 NOT NULL')		
		Print 'WorkInProcessTable Altered successfully'				
	END
	
	IF NOT EXISTS ( SELECT * FROM sysColumns 
		WHERE 
		id = (SELECT id FROM sysObjects WHERE NAME = 'WorkWithPSTable')
		AND  NAME = 'ProcessVariantId'
		)
	BEGIN
		EXECUTE('Alter Table WorkWithPSTable add ProcessVariantId Integer Default 0 NOT NULL')		
		Print 'WorkWithPSTable Altered successfully'				
	END
	
	IF NOT EXISTS ( SELECT * FROM sysColumns 
		WHERE 
		id = (SELECT id FROM sysObjects WHERE NAME = 'PendingWorkListTable')
		AND  NAME = 'ProcessVariantId'
		)
	BEGIN
		EXECUTE('Alter Table PendingWorkListTable add ProcessVariantId Integer Default 0 NOT NULL')		
		Print 'PendingWorkListTable Altered successfully'				
	END
	
	IF NOT EXISTS ( SELECT * FROM sysColumns 
		WHERE 
		id = (SELECT id FROM sysObjects WHERE NAME = 'QueueHistoryTable')
		AND  NAME = 'ProcessVariantId'
		)
	BEGIN
		EXECUTE('Alter Table QueueHistoryTable add ProcessVariantId Integer Default 0 NOT NULL')		
		Print 'QueueHistoryTable Altered successfully'				
	END
	
	IF NOT EXISTS ( SELECT * FROM sysColumns 
		WHERE 
		id = (SELECT id FROM sysObjects WHERE NAME = 'WFCurrentRouteLogTable')
		AND  NAME = 'ProcessVariantId'
		)
	BEGIN
		EXECUTE('Alter Table WFCurrentRouteLogTable add ProcessVariantId Integer Default 0 NOT NULL')		
		Print 'WFCurrentRouteLogTable Altered successfully'				
	END
	
	IF NOT EXISTS ( SELECT * FROM sysColumns 
		WHERE 
		id = (SELECT id FROM sysObjects WHERE NAME = 'WFHistoryRouteLogTable')
		AND  NAME = 'ProcessVariantId'
		)
	BEGIN
		EXECUTE('Alter Table WFHistoryRouteLogTable add ProcessVariantId Integer Default 0 NOT NULL')		
		Print 'WFHistoryRouteLogTable Altered successfully'				
	END
	
	IF NOT EXISTS ( SELECT * FROM sysColumns 
		WHERE 
		id = (SELECT id FROM sysObjects WHERE NAME = 'SummaryTable')
		AND  NAME = 'ProcessVariantId'
		)
	BEGIN
		EXECUTE('Alter Table SummaryTable add ProcessVariantId Integer Default 0 NOT NULL')		
		Print 'SummaryTable Altered successfully'				
	END
	
	IF NOT EXISTS ( SELECT * FROM sysColumns 
		WHERE 
		id = (SELECT id FROM sysObjects WHERE NAME = 'WfReportDataTable')
		AND  NAME = 'ProcessVariantId'
		)
	BEGIN
		EXECUTE('Alter Table WfReportDataTable add ProcessVariantId Integer Default 0 NOT NULL')		
		Print 'WfReportDataTable Altered successfully'				
	END
	
	IF NOT EXISTS ( SELECT * FROM sysColumns 
		WHERE 
		id = (SELECT id FROM sysObjects WHERE NAME = 'WFVarStatusTable')
		AND  NAME = 'ProcessVariantId'
		)
	BEGIN
		EXECUTE('Alter Table WFVarStatusTable add ProcessVariantId Integer Default 0 NOT NULL')		
		Print 'WFVarStatusTable Altered successfully'				
	END
	
	IF NOT EXISTS ( SELECT * FROM sysColumns 
		WHERE 
		id = (SELECT id FROM sysObjects WHERE NAME = 'WFCommentsTable')
		AND  NAME = 'ProcessVariantId'
		)
	BEGIN
		EXECUTE('Alter Table WFCommentsTable add ProcessVariantId Integer Default 0 NOT NULL')		
		Print 'WFCommentsTable Altered successfully'				
	END
	
	Begin
		SELECT @TableId = id FROM sysobjects WHERE name = 'ActivityAssociationTable'
		SELECT @ConstraintName = name FROM SYSCONSTRAINTS A, SYSOBJECTS B WHERE A.constid = B.id AND B.xtype = 'PK' AND A.id = @TableId 		
		IF EXISTS ( SELECT * FROM sysObjects WHERE NAME = @ConstraintName)
			BEGIN
				execute('alter table ActivityAssociationTable drop CONSTRAINT ' + @ConstraintName)				
			END				
		EXECUTE('alter table ActivityAssociationTable add PRIMARY KEY (ProcessdefId, ActivityId, DefinitionType, DefinitionId, ProcessVariantId)')
		PRINT 'Alter Table ActivityAssociationTable Successfully'
	End	
	
	Begin
		SELECT @TableId = id FROM sysobjects WHERE name = 'VarMappingTable'
		SELECT @ConstraintName = name FROM SYSCONSTRAINTS A, SYSOBJECTS B WHERE A.constid = B.id AND B.xtype = 'PK' AND A.id = @TableId 		
		IF EXISTS ( SELECT * FROM sysObjects WHERE NAME = @ConstraintName)
			BEGIN
				execute('alter table VarMappingTable drop CONSTRAINT ' + @ConstraintName)				
			END				
		EXECUTE('alter table VarMappingTable add PRIMARY KEY (ProcessdefId, VariableId, ProcessVariantId)')
		PRINT 'Alter Table VarMappingTable Successfully'
	End
	
	Begin
		SELECT @TableId = id FROM sysobjects WHERE name = 'WFUDTVarMappingTable'
		SELECT @ConstraintName = name FROM SYSCONSTRAINTS A, SYSOBJECTS B WHERE A.constid = B.id AND B.xtype = 'PK' AND A.id = @TableId 		
		IF EXISTS ( SELECT * FROM sysObjects WHERE NAME = @ConstraintName)
			BEGIN
				execute('alter table WFUDTVarMappingTable drop CONSTRAINT ' + @ConstraintName)				
			END				
		EXECUTE('alter table WFUDTVarMappingTable add PRIMARY KEY (ProcessDefId, VariableId, VarFieldId, ProcessVariantId)')
		PRINT 'Alter Table WFUDTVarMappingTable Successfully'
	End
	
	Begin
		SELECT @TableId = id FROM sysobjects WHERE name = 'ExtDBConfTable'
		SELECT @ConstraintName = name FROM SYSCONSTRAINTS A, SYSOBJECTS B WHERE A.constid = B.id AND B.xtype = 'PK' AND A.id = @TableId 		
		IF EXISTS ( SELECT * FROM sysObjects WHERE NAME = @ConstraintName)
			BEGIN
				execute('alter table ExtDBConfTable drop CONSTRAINT ' + @ConstraintName)				
			END				
		EXECUTE('alter table ExtDBConfTable add PRIMARY KEY (ProcessDefId, ExtObjID, ProcessVariantId)')
		PRINT 'Alter Table ExtDBConfTable Successfully'
	End
	
	Begin
		SELECT @TableId = id FROM sysobjects WHERE name = 'DocumentTypeDefTable'
		SELECT @ConstraintName = name FROM SYSCONSTRAINTS A, SYSOBJECTS B WHERE A.constid = B.id AND B.xtype = 'PK' AND A.id = @TableId 		
		IF EXISTS ( SELECT * FROM sysObjects WHERE NAME = @ConstraintName)
			BEGIN
				execute('alter table DocumentTypeDefTable drop CONSTRAINT ' + @ConstraintName)				
			END				
		EXECUTE('alter table DocumentTypeDefTable add PRIMARY KEY (ProcessDefId, DocId, ProcessVariantId)')
		PRINT 'Alter Table DocumentTypeDefTable Successfully'
	End
	
	Begin
		SELECT @TableId = id FROM sysobjects WHERE name = 'WFTypeDefTable'
		SELECT @ConstraintName = name FROM SYSCONSTRAINTS A, SYSOBJECTS B WHERE A.constid = B.id AND B.xtype = 'PK' AND A.id = @TableId 		
		IF EXISTS ( SELECT * FROM sysObjects WHERE NAME = @ConstraintName)
			BEGIN
				execute('alter table WFTypeDefTable drop CONSTRAINT ' + @ConstraintName)				
			END				
		EXECUTE('alter table WFTypeDefTable add PRIMARY KEY (ProcessDefId, ParentTypeId, TypeFieldId, ProcessVariantId)')
		PRINT 'Alter Table WFTypeDefTable Successfully'
	End
	
	Begin
		SELECT @TableId = id FROM sysobjects WHERE name = 'WFTypeDescTable'
		SELECT @ConstraintName = name FROM SYSCONSTRAINTS A, SYSOBJECTS B WHERE A.constid = B.id AND B.xtype = 'PK' AND A.id = @TableId 		
		IF EXISTS ( SELECT * FROM sysObjects WHERE NAME = @ConstraintName)
			BEGIN
				execute('alter table WFTypeDescTable drop CONSTRAINT ' + @ConstraintName)				
			END				
		EXECUTE('alter table WFTypeDescTable add PRIMARY KEY (ProcessDefId, TypeId, ProcessVariantId)')
		PRINT 'Alter Table WFTypeDescTable Successfully'
	End
	
	Begin
		SELECT @TableId = id FROM sysobjects WHERE name = 'WFVarRelationTable'
		SELECT @ConstraintName = name FROM SYSCONSTRAINTS A, SYSOBJECTS B WHERE A.constid = B.id AND B.xtype = 'PK' AND A.id = @TableId 		
		IF EXISTS ( SELECT * FROM sysObjects WHERE NAME = @ConstraintName)
			BEGIN
				execute('alter table WFVarRelationTable drop CONSTRAINT ' + @ConstraintName)				
			END				
		EXECUTE('alter table WFVarRelationTable add PRIMARY KEY (ProcessDefId, RelationId, OrderId, ProcessVariantId)')
		PRINT 'Alter Table WFVarRelationTable Successfully'
	End
	
	Begin
		SELECT @TableId = id FROM sysobjects WHERE name = 'TemplateMultiLanguageTable'
		SELECT @ConstraintName = name FROM SYSCONSTRAINTS A, SYSOBJECTS B WHERE A.constid = B.id AND B.xtype = 'PK' AND A.id = @TableId 		
		IF EXISTS ( SELECT * FROM sysObjects WHERE NAME = @ConstraintName)
			BEGIN
				execute('alter table TemplateMultiLanguageTable drop CONSTRAINT ' + @ConstraintName)				
			END				
		EXECUTE('alter table TemplateMultiLanguageTable add PRIMARY KEY (ProcessDefId, TemplateId, Locale, ProcessVariantId)')
		PRINT 'Alter Table TemplateMultiLanguageTable Successfully'
	End
	
	Begin
		SELECT @TableId = id FROM sysobjects WHERE name = 'WFForm_Table'
		SELECT @ConstraintName = name FROM SYSCONSTRAINTS A, SYSOBJECTS B WHERE A.constid = B.id AND B.xtype = 'PK' AND A.id = @TableId 		
		IF EXISTS ( SELECT * FROM sysObjects WHERE NAME = @ConstraintName)
			BEGIN
				execute('alter table WFForm_Table drop CONSTRAINT ' + @ConstraintName)				
			END				
		EXECUTE('alter table WFForm_Table add PRIMARY KEY (ProcessDefId, FormId, ProcessVariantId)')
		PRINT 'Alter Table WFForm_Table Successfully'
	End
	
	IF EXISTS (SELECT * FROM sysobjects WHERE ID = OBJECT_ID(N'QUEUETABLE')
	AND OBJECTPROPERTY(id, N'IsView') = 1)
	BEGIN
		EXECUTE('DROP VIEW QUEUETABLE')
		EXECUTE('CREATE VIEW QUEUETABLE 
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
				referredtoname, referredby, referredbyname, collectflag, NULL AS CompletionDatetime, CalendarName, queueTABLE1.ProcessVariantId
			FROM QUEUEDATATABLE  with (NOLOCK), 
				 PROCESSINSTANCETABLE  with (NOLOCK),
				  (SELECT processinstanceid, workitemid, processname, processversion,
						  processdefid, LastProcessedBy, processedby, activityname, activityid,
						  entryDATETIME, parentworkitemid, AssignmentType,
						  collectflag, prioritylevel, validtill, q_streamid,
						  q_queueid, q_userid, AssignedUser, CreatedDatetime,
						  workitemstate, expectedworkitemdelay, previousstage,
						  lockedbyname, lockstatus, lockedtime, queuename, queuetype,
						  statename, ProcessVariantId
					 FROM WORKLISTTABLE  with (NOLOCK)
				   UNION ALL
				   SELECT processinstanceid, workitemid, processname, processversion,
						  processdefid, LastProcessedBy, processedby, activityname, activityid,
						  entryDATETIME, parentworkitemid, AssignmentType,
						  collectflag, prioritylevel, validtill, q_streamid,
						  q_queueid, q_userid, AssignedUser, CreatedDatetime,
						  workitemstate, expectedworkitemdelay, previousstage,
						  lockedbyname, lockstatus, lockedtime, queuename, queuetype,
						  statename, ProcessVariantId
					 FROM WORKINPROCESSTABLE  with (NOLOCK)
				   UNION ALL
				   SELECT processinstanceid, workitemid, processname, processversion,
						  processdefid, LastProcessedBy, processedby, activityname, activityid,
						  entryDATETIME, parentworkitemid, AssignmentType,
						  collectflag, prioritylevel, validtill, q_streamid,
						  q_queueid, q_userid, AssignedUser, CreatedDatetime,
						  workitemstate, expectedworkitemdelay, previousstage,
						  lockedbyname, lockstatus, lockedtime, queuename, queuetype,
						  statename, ProcessVariantId
					 FROM WORKDONETABLE  with (NOLOCK)
				   UNION ALL
				   SELECT processinstanceid, workitemid, processname, processversion,
						  processdefid, LastProcessedBy, processedby, activityname, activityid,
						  entryDATETIME, parentworkitemid, AssignmentType,
						  collectflag, prioritylevel, validtill, q_streamid,
						  q_queueid, q_userid, AssignedUser, CreatedDatetime,
						  workitemstate, expectedworkitemdelay, previousstage,
						  lockedbyname, lockstatus, lockedtime, queuename, queuetype,
						  statename, ProcessVariantId
					 FROM WORKWITHPSTABLE  with (NOLOCK)
				   UNION ALL
				   SELECT processinstanceid, workitemid, processname, processversion,
						  processdefid, LastProcessedBy, processedby, activityname, activityid,
						  entryDATETIME, parentworkitemid, AssignmentType,
						  collectflag, prioritylevel, validtill, q_streamid,
						  q_queueid, q_userid, AssignedUser, CreatedDatetime,
						  workitemstate, expectedworkitemdelay, previousstage,
						  lockedbyname, lockstatus, lockedtime, queuename, queuetype,
						  statename, ProcessVariantId
					 FROM PENDINGWORKLISTTABLE with (NOLOCK)) queueTABLE1
			WHERE QUEUEDATATABLE.processinstanceid = queueTABLE1.processinstanceid
			  AND QUEUEDATATABLE.workitemid = queueTABLE1.workitemid
			  AND queueTABLE1.processinstanceid = PROCESSINSTANCETABLE.processinstanceid')
		PRINT 'VIEW QUEUEVIEW CREATED SUCCESSFULLY'
	END
	ELSE 
	BEGIN
		EXECUTE('CREATE VIEW QUEUETABLE 
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
				referredtoname, referredby, referredbyname, collectflag, NULL AS CompletionDatetime, CalendarName, queueTABLE1.ProcessVariantId
			FROM QUEUEDATATABLE  with (NOLOCK), 
				 PROCESSINSTANCETABLE  with (NOLOCK),
				  (SELECT processinstanceid, workitemid, processname, processversion,
						  processdefid, LastProcessedBy, processedby, activityname, activityid,
						  entryDATETIME, parentworkitemid, AssignmentType,
						  collectflag, prioritylevel, validtill, q_streamid,
						  q_queueid, q_userid, AssignedUser, CreatedDatetime,
						  workitemstate, expectedworkitemdelay, previousstage,
						  lockedbyname, lockstatus, lockedtime, queuename, queuetype,
						  statename, ProcessVariantId
					 FROM WORKLISTTABLE  with (NOLOCK)
				   UNION ALL
				   SELECT processinstanceid, workitemid, processname, processversion,
						  processdefid, LastProcessedBy, processedby, activityname, activityid,
						  entryDATETIME, parentworkitemid, AssignmentType,
						  collectflag, prioritylevel, validtill, q_streamid,
						  q_queueid, q_userid, AssignedUser, CreatedDatetime,
						  workitemstate, expectedworkitemdelay, previousstage,
						  lockedbyname, lockstatus, lockedtime, queuename, queuetype,
						  statename, ProcessVariantId
					 FROM WORKINPROCESSTABLE  with (NOLOCK)
				   UNION ALL
				   SELECT processinstanceid, workitemid, processname, processversion,
						  processdefid, LastProcessedBy, processedby, activityname, activityid,
						  entryDATETIME, parentworkitemid, AssignmentType,
						  collectflag, prioritylevel, validtill, q_streamid,
						  q_queueid, q_userid, AssignedUser, CreatedDatetime,
						  workitemstate, expectedworkitemdelay, previousstage,
						  lockedbyname, lockstatus, lockedtime, queuename, queuetype,
						  statename, ProcessVariantId
					 FROM WORKDONETABLE  with (NOLOCK)
				   UNION ALL
				   SELECT processinstanceid, workitemid, processname, processversion,
						  processdefid, LastProcessedBy, processedby, activityname, activityid,
						  entryDATETIME, parentworkitemid, AssignmentType,
						  collectflag, prioritylevel, validtill, q_streamid,
						  q_queueid, q_userid, AssignedUser, CreatedDatetime,
						  workitemstate, expectedworkitemdelay, previousstage,
						  lockedbyname, lockstatus, lockedtime, queuename, queuetype,
						  statename, ProcessVariantId
					 FROM WORKWITHPSTABLE  with (NOLOCK)
				   UNION ALL
				   SELECT processinstanceid, workitemid, processname, processversion,
						  processdefid, LastProcessedBy, processedby, activityname, activityid,
						  entryDATETIME, parentworkitemid, AssignmentType,
						  collectflag, prioritylevel, validtill, q_streamid,
						  q_queueid, q_userid, AssignedUser, CreatedDatetime,
						  workitemstate, expectedworkitemdelay, previousstage,
						  lockedbyname, lockstatus, lockedtime, queuename, queuetype,
						  statename, ProcessVariantId
					 FROM PENDINGWORKLISTTABLE with (NOLOCK)) queueTABLE1
			WHERE QUEUEDATATABLE.processinstanceid = queueTABLE1.processinstanceid
			  AND QUEUEDATATABLE.workitemid = queueTABLE1.workitemid
			  AND queueTABLE1.processinstanceid = PROCESSINSTANCETABLE.processinstanceid ')
		PRINT 'VIEW QUEUETABLE CREATED SUCCESSFULLY'		
	END
	
	IF EXISTS (SELECT * FROM sysobjects WHERE ID = OBJECT_ID(N'QUEUEVIEW')
	AND OBJECTPROPERTY(id, N'IsView') = 1)
	BEGIN
		EXECUTE('DROP VIEW QUEUEVIEW')
		EXECUTE('CREATE VIEW QUEUEVIEW AS 
				SELECT * FROM QUEUETABLE WITH (NOLOCK) 
				UNION ALL 
				SELECT PROCESSDEFID, PROCESSNAME, PROCESSVERSION, PROCESSINSTANCEID, PROCESSINSTANCEID AS PROCESSINSTANCENAME, ACTIVITYID, ACTIVITYNAME, PARENTWORKITEMID, WORKITEMID, PROCESSINSTANCESTATE, WORKITEMSTATE, STATENAME, QUEUENAME, QUEUETYPE, ASSIGNEDUSER, ASSIGNMENTTYPE, INSTRUMENTSTATUS, CHECKLISTCOMPLETEFLAG, INTRODUCTIONDATETIME, CREATEDDATETIME AS CREATEDDATETIME, INTRODUCEDBY, CREATEDBYNAME, ENTRYDATETIME, LOCKSTATUS, HOLDSTATUS, PRIORITYLEVEL, LOCKEDBYNAME, LOCKEDTIME, VALIDTILL, SAVESTAGE, PREVIOUSSTAGE, EXPECTEDWORKITEMDELAYTIME AS EXPECTEDWORKITEMDELAYTIME, EXPECTEDPROCESSDELAYTIME AS EXPECTEDPROCESSDELAYTIME, STATUS, VAR_INT1, VAR_INT2, VAR_INT3, VAR_INT4, VAR_INT5, VAR_INT6, VAR_INT7, VAR_INT8, VAR_FLOAT1, VAR_FLOAT2, VAR_DATE1, VAR_DATE2, VAR_DATE3, VAR_DATE4, VAR_LONG1, VAR_LONG2, VAR_LONG3, VAR_LONG4, VAR_STR1, VAR_STR2, VAR_STR3, VAR_STR4, VAR_STR5, VAR_STR6, VAR_STR7, VAR_STR8, VAR_REC_1, VAR_REC_2, VAR_REC_3, VAR_REC_4, VAR_REC_5, Q_STREAMID, Q_QUEUEID, Q_USERID, LASTPROCESSEDBY, PROCESSEDBY, REFERREDTO, REFERREDTONAME, REFERREDBY, REFERREDBYNAME, COLLECTFLAG, NULL AS COMPLETIONDATETIME, CALENDARNAME, PROCESSVARIANTID FROM QUEUEHISTORYTABLE WITH (NOLOCK) ')
		PRINT 'VIEW QUEUEVIEW CREATED SUCCESSFULLY'
	END
	ELSE 
	BEGIN
		EXECUTE('CREATE VIEW QUEUEVIEW AS 
				SELECT * FROM QUEUETABLE WITH (NOLOCK) 
				UNION ALL 
				SELECT PROCESSDEFID, PROCESSNAME, PROCESSVERSION, PROCESSINSTANCEID, PROCESSINSTANCEID AS PROCESSINSTANCENAME, ACTIVITYID, ACTIVITYNAME, PARENTWORKITEMID, WORKITEMID, PROCESSINSTANCESTATE, WORKITEMSTATE, STATENAME, QUEUENAME, QUEUETYPE, ASSIGNEDUSER, ASSIGNMENTTYPE, INSTRUMENTSTATUS, CHECKLISTCOMPLETEFLAG, INTRODUCTIONDATETIME, CREATEDDATETIME AS CREATEDDATETIME, INTRODUCEDBY, CREATEDBYNAME, ENTRYDATETIME, LOCKSTATUS, HOLDSTATUS, PRIORITYLEVEL, LOCKEDBYNAME, LOCKEDTIME, VALIDTILL, SAVESTAGE, PREVIOUSSTAGE, EXPECTEDWORKITEMDELAYTIME AS EXPECTEDWORKITEMDELAYTIME, EXPECTEDPROCESSDELAYTIME AS EXPECTEDPROCESSDELAYTIME, STATUS, VAR_INT1, VAR_INT2, VAR_INT3, VAR_INT4, VAR_INT5, VAR_INT6, VAR_INT7, VAR_INT8, VAR_FLOAT1, VAR_FLOAT2, VAR_DATE1, VAR_DATE2, VAR_DATE3, VAR_DATE4, VAR_LONG1, VAR_LONG2, VAR_LONG3, VAR_LONG4, VAR_STR1, VAR_STR2, VAR_STR3, VAR_STR4, VAR_STR5, VAR_STR6, VAR_STR7, VAR_STR8, VAR_REC_1, VAR_REC_2, VAR_REC_3, VAR_REC_4, VAR_REC_5, Q_STREAMID, Q_QUEUEID, Q_USERID, LASTPROCESSEDBY, PROCESSEDBY, REFERREDTO, REFERREDTONAME, REFERREDBY, REFERREDBYNAME, COLLECTFLAG, NULL AS COMPLETIONDATETIME, CALENDARNAME, PROCESSVARIANTID FROM QUEUEHISTORYTABLE WITH (NOLOCK) ')
		PRINT 'VIEW QUEUEVIEW CREATED SUCCESSFULLY'		
	END
	
	IF OBJECT_ID('WF_DelProcVariantTrigger', 'TR') IS NOT NULL
	BEGIN
		DROP TRIGGER WF_DelProcVariantTrigger
	END
		IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id('WFProcessVariantDefTable') AND xType='U')
	Begin
		EXECUTE('
		CREATE TRIGGER WF_DelProcVariantTrigger
			ON WFProcessVariantDefTable
			AFTER DELETE
		AS 
		DECLARE 
		@deleteCnt	INT,
		@processVariantId	INT
		BEGIN
			SELECT @deleteCnt = COUNT(*) FROM Deleted
			IF (@deleteCnt>0)
			BEGIN
				SELECT @processVariantId = ProcessVariantId FROM Deleted
		 
				Delete from ACTIVITYASSOCIATIONTABLE where ProcessVariantId =@processVariantId;
				Delete from VARMAPPINGTABLE where ProcessVariantId =@processVariantId;
				Delete from WFUDTVarMappingTable where ProcessVariantId =@processVariantId;
				Delete from EXTDBCONFTABLE where ProcessVariantId =@processVariantId;
				Delete from DOCUMENTTYPEDEFTABLE where ProcessVariantId =@processVariantId;
				Delete from WFTYPEDEFTABLE where ProcessVariantId = @processVariantId;
				Delete from WFTYPEDESCTABLE where ProcessVariantId = @processVariantId;
				Delete from WFVARRELATIONTABLE where ProcessVariantId = @processVariantId;
				Delete from TEMPLATEMULTILANGUAGETABLE where ProcessVariantId = @processVariantId;
				Delete from ACTIVITYINTERFACEASSOCTABLE where ProcessVariantId = @processVariantId;
				Delete from WFFORM_TABLE where ProcessVariantId = @processVariantId;
			END
			
		END
        ')
	END
	/* End of Upgrade for Process Variant support */
END;

~


PRINT 'Executing procedure Upgrade ........... '
EXEC Upgrade 
		

DROP PROCEDURE Upgrade
	
	
	


	
	
	