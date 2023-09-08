	/*__________________________________________________________________________________;
	NEWGEN SOFTWARE TECHNOLOGIES LIMITED;
	Group                       : Genesis;
	Product / Project           : IBPS;
	Module                      : IBPS Server;
	File Name                   : WFPartitionLargeTables.sql (MSSQL)
	Author                      : Kahkeshan
	Date written (DD/MM/YYYY)   : 30 MAY 2014
	Description                 : Script to handle Partition in large Tables in SQL
	____________________________________________________________________________________;
	CHANGE HISTORY;
	____________________________________________________________________________________;
	Date        Change By        Change Description (Bug No. (IF Any))
	____________________________________________________________________________________*/	
				
			
	If Exists (Select * FROM SysObjects  WITH (NOLOCK) Where xType = 'P' and name = 'WFPartitionLargeTables')
	Begin
	Execute('DROP PROCEDURE WFPartitionLargeTables')
	Print 'Procedure WFPartitionLargeTables already exists, hence older one dropped ..... '
	End
	
	~
		
	Create Procedure WFPartitionLargeTables	
	AS
	BEGIN
		
		DECLARE @vquery NVARCHAR(Max)
		
		SELECT @vquery = ' CREATE PARTITION FUNCTION PartitionRangeDate (DATETIME) AS RANGE Right FOR VALUES
		(''20100101'', ''20110101'',''20120101'',''20130101'',''20140101'',''20150101'', ''20160101'',''20170101'',''20180101'',''20190101'',''20200101'') '
		
		EXECUTE(@vquery)
		
		SELECT @vquery = ' CREATE PARTITION SCHEME PartitionSchemeDate AS PARTITION PartitionRangeDate ALL TO ([PRIMARY]) '
		EXECUTE(@vquery)
		
		SELECT @vquery = ' CREATE PARTITION FUNCTION PartitionRangePId (nvarchar(63)) AS RANGE Right FOR VALUES (''aaaaa-0000000000-aaaaa'') '
		EXECUTE(@vquery)
		
		SELECT @vquery = ' CREATE PARTITION SCHEME PartitionSchemePId AS PARTITION PartitionRangePId ALL TO ([PRIMARY]) '
		EXECUTE(@vquery)
		
		/* Recreate Tables For Applying Partitions */
		
		/*********** WFINSTRUMENTTABLE ****************/
		
		If Exists (Select * FROM SysObjects (NOLOCK) Where xType = 'U' and name = 'WFINSTRUMENTTABLE')
		Begin
			Execute('DROP Table WFINSTRUMENTTABLE')
			Print 'Table WFINSTRUMENTTABLE already exists, hence older one dropped ..... '
		End
		
		SELECT @vquery = ' CREATE TABLE WFINSTRUMENTTABLE (
			ProcessInstanceID			NVARCHAR(63)  NOT NULL ,
			ProcessDefID				INT		NOT NULL,
			Createdby					INT		NOT NULL ,
			CreatedByName				NVARCHAR(63)	NULL ,
			Createddatetime				DATETIME		NOT NULL ,
			Introducedbyid				INT		NULL ,
			Introducedby				NVARCHAR(63)	NULL ,
			IntroductionDATETIME		DATETIME		NULL ,
			ProcessInstanceState		INT		NULL ,
			ExpectedProcessDelay		DATETIME		NULL ,
			IntroducedAt				NVARCHAR(30)	NOT NULL ,
			WorkItemId					INT		NOT NULL ,
			VAR_INT1					SMALLINT	NULL ,
			VAR_INT2					SMALLINT	NULL ,
			VAR_INT3					SMALLINT	NULL ,
			VAR_INT4					SMALLINT	NULL ,
			VAR_INT5					SMALLINT	NULL ,
			VAR_INT6					SMALLINT	NULL ,
			VAR_INT7					SMALLINT	NULL ,
			VAR_INT8					SMALLINT	NULL ,
			VAR_FLOAT1					NUMERIC(15, 2)	NULL ,
			VAR_FLOAT2					NUMERIC(15, 2)	NULL ,
			VAR_DATE1					DATETIME		NULL ,
			VAR_DATE2					DATETIME		NULL ,
			VAR_DATE3					DATETIME		NULL ,
			VAR_DATE4					DATETIME		NULL ,
			VAR_LONG1					INT		NULL ,
			VAR_LONG2					INT		NULL ,
			VAR_LONG3					INT		NULL ,
			VAR_LONG4					INT		NULL ,
			VAR_STR1					NVARCHAR(255)  NULL ,
			VAR_STR2					NVARCHAR(255)  NULL ,
			VAR_STR3					NVARCHAR(255)  NULL ,
			VAR_STR4					NVARCHAR(255)  NULL ,
			VAR_STR5					NVARCHAR(255)  NULL ,
			VAR_STR6					NVARCHAR(255)  NULL ,
			VAR_STR7					NVARCHAR(255)  NULL ,
			VAR_STR8					NVARCHAR(255)  NULL ,
			VAR_REC_1					NVARCHAR(255)  NULL ,
			VAR_REC_2					NVARCHAR(255)  NULL ,
			VAR_REC_3					NVARCHAR(255)  NULL ,
			VAR_REC_4					NVARCHAR(255)  NULL ,
			VAR_REC_5					NVARCHAR(255)  NULL ,
			InstrumentStatus			NVARCHAR(1)	NULL, 
			CheckListCompleteFlag		NVARCHAR(1)	NULL ,
			SaveStage					NVARCHAR(30)	NULL ,
			HoldStatus					INT		NULL,
			Status						NVARCHAR(255)  NULL ,
			ReferredTo					INT		NULL ,
			ReferredToName				NVARCHAR(63)	NULL ,
			ReferredBy					INT		NULL ,
			ReferredByName				NVARCHAR(63)	NULL ,
			ChildProcessInstanceId		NVARCHAR(63)	NULL,
			ChildWorkitemId				INT,
			ParentWorkItemID			INT,
			CalendarName        		NVARCHAR(255) NULL,  
			ProcessName 				NVARCHAR(30)	NOT NULL ,
			ProcessVersion   			SMALLINT,
			LastProcessedBy 			INT		NULL ,
			ProcessedBy					NVARCHAR(63)	NULL,	
			ActivityName 				NVARCHAR(30)	NULL ,
			ActivityId 					INT		NULL ,
			EntryDATETIME 				DATETIME		NULL ,
			AssignmentType				NVARCHAR (1)	NULL ,
			CollectFlag					NVARCHAR (1)	NULL ,
			PriorityLevel				SMALLINT	NULL ,
			ValidTill					DATETIME		NULL ,
			Q_StreamId					INT		NULL ,
			Q_QueueId					INT		NULL ,
			Q_UserId					INT	NULL ,
			AssignedUser				NVARCHAR(63)	NULL,	
			FilterValue					INT		NULL ,
			WorkItemState				INT		NULL ,
			Statename 					NVARCHAR(255),
			ExpectedWorkitemDelay		DATETIME		NULL ,
			PreviousStage				NVARCHAR (30)  NULL ,
			LockedByName				NVARCHAR(63)	NULL,	
			LockStatus					NVARCHAR(1)	NOT NULL,
			RoutingStatus				NVARCHAR(1) NOT NULL,	
			LockedTime					DATETIME		NULL , 
			Queuename 					NVARCHAR(63),
			Queuetype 					NVARCHAR(1),
			NotifyStatus				NVARCHAR(1),	  /* moved from after Guid*/
			Guid 						BIGINT ,
			NoOfCollectedInstances		INT DEFAULT 0 NOT NULL,
			IsPrimaryCollected			NVARCHAR(1)	NULL CHECK (IsPrimaryCollected IN (N''Y'', N''N'')),
			ExportStatus				NVARCHAR(1) DEFAULT ''N'',
			ProcessVariantId 			INT 		NOT NULL DEFAULT 0,
			Q_DivertedByUserId   		INT NULL,
			ActivityType				SmallInt NULL,
			lastModifiedTime				DATETIME,
			VAR_DATE5					DATETIME		NULL ,
			VAR_DATE6					DATETIME		NULL ,
			VAR_LONG5					INT		NULL ,
			VAR_LONG6					INT		NULL ,
			VAR_STR9					NVARCHAR(512)  NULL ,
			VAR_STR10					NVARCHAR(512)  NULL ,
			VAR_STR11					NVARCHAR(512)  NULL ,
			VAR_STR12					NVARCHAR(512)  NULL ,
			VAR_STR13					NVARCHAR(512)  NULL ,
			VAR_STR14					NVARCHAR(512)  NULL ,
			VAR_STR15					NVARCHAR(512)  NULL ,
			VAR_STR16					NVARCHAR(512)  NULL ,
			VAR_STR17					NVARCHAR(512)  NULL ,
			VAR_STR18					NVARCHAR(512)  NULL ,
			VAR_STR19					NVARCHAR(512)  NULL ,
			VAR_STR20					NVARCHAR(512)  NULL ,
			CONSTRAINT PK_WFINSTRUMENTTable PRIMARY KEY 
			(
			ProcessInstanceID,WorkitemId
			)
		)  ON PartitionSchemePId (processinstanceid) '

		EXECUTE(@vquery)
		print 'query -'+@vquery
		
		SELECT @vquery = ' CREATE INDEX IDX1_WFINSTRUMENTTABLE ON WFINSTRUMENTTABLE (var_rec_1, var_rec_2) '
		EXECUTE(@vquery)

		SELECT @vquery = ' CREATE INDEX IDX2_WFINSTRUMENTTABLE ON WFINSTRUMENTTABLE (Q_QueueId,ProcessInstanceId,WorkitemId)'
		EXECUTE(@vquery)

		SELECT @vquery = ' CREATE INDEX IDX3_WFINSTRUMENTTABLE ON WFINSTRUMENTTABLE (Q_UserID, ProcessInstanceId, WorkitemId)'
		EXECUTE(@vquery)

		SELECT @vquery = ' CREATE INDEX IDX5_WFINSTRUMENTTABLE ON WFINSTRUMENTTABLE (Q_QueueId, WorkItemState , LockStatus , RoutingStatus , EntryDateTime)'
		EXECUTE(@vquery)

		SELECT @vquery = ' CREATE INDEX IDX6_WFINSTRUMENTTABLE ON WFINSTRUMENTTABLE (ProcessDefId, RoutingStatus, LockStatus)'
		EXECUTE(@vquery)

		SELECT @vquery = ' CREATE INDEX IDX7_WFINSTRUMENTTABLE ON WFINSTRUMENTTABLE  (PROCESSINSTANCEID, PARENTWORKITEMID)'
		EXECUTE(@vquery)

		SELECT @vquery = ' CREATE INDEX IDX8_WFINSTRUMENTTABLE ON WFINSTRUMENTTABLE(Q_UserId, ROUTINGSTATUS, Q_QUEUEID)'
		EXECUTE(@vquery)
		
		SELECT @vquery = ' CREATE INDEX IDX9_WFINSTRUMENTTABLE ON WFINSTRUMENTTABLE(Q_Queueid, LockStatus,EntryDateTime,ProcessInstanceID,WorkItemID)'
		EXECUTE(@vquery)
		
		SELECT @vquery = ' CREATE INDEX IDX10_WFINSTRUMENTTABLE ON WFINSTRUMENTTABLE(Childprocessinstanceid, Childworkitemid)'
		EXECUTE(@vquery)

		SELECT @vquery = ' CREATE INDEX IDX11_WFINSTRUMENTTABLE ON WFINSTRUMENTTABLE(ValidTill)'
		EXECUTE(@vquery)
		
		SELECT @vquery = ' CREATE INDEX IDX12_WFINSTRUMENTTABLE ON WFINSTRUMENTTABLE(ASSIGNMENTTYPE  , VALIDTILL  ,ROUTINGSTATUS  ,LOCKSTATUS)'
		EXECUTE(@vquery)
		
		
		/*****   QUEUEHISTORYTABLE   ******/
		
		If Exists (Select * FROM SysObjects (NOLOCK) Where xType = 'U' and name = 'QUEUEHISTORYTABLE')
		Begin
			Execute('DROP Table QUEUEHISTORYTABLE')
			Print 'Table QUEUEHISTORYTABLE already exists, hence older one dropped ..... '
		End
		
		SELECT @vquery = ' CREATE TABLE QUEUEHISTORYTABLE (
			ProcessDefId 		INT 		NOT NULL ,
			ProcessName 		NVARCHAR(30)	NULL,
			ProcessVersion 		SMALLINT	NULL,
			ProcessInstanceId	NVARCHAR(63)  	NOT NULL ,
			ProcessInstanceName	NVARCHAR(63)	NULL ,
			ActivityId 		INT 		NOT NULL ,
			ActivityName		NVARCHAR(30)	NULL ,
			ParentWorkItemId 	INT		NULL ,
			WorkItemId 		INT 		NOT NULL ,
			ProcessInstanceState 	INT 		NOT NULL ,
			WorkItemState 		INT 		NOT NULL ,
			Statename 		NVARCHAR(50)	NULL,
			QueueName		NVARCHAR (63)	NULL ,
			QueueType 		NVARCHAR(1)	NULL ,
			AssignedUser		NVARCHAR (63)	NULL ,
			AssignmentType 		NVARCHAR(1)	NULL ,
			InstrumentStatus 	NVARCHAR(1)	NULL ,
			CheckListCompleteFlag 	NVARCHAR(1)	NULL ,
			IntroductionDateTime	DATETIME	NULL ,
			CreatedDatetime		DATETIME	NULL ,
			Introducedby		NVARCHAR (63)	NULL ,
			CreatedByName		NVARCHAR (63)	NULL ,
			EntryDATETIME		DATETIME 	NOT NULL ,
			LockStatus 		NVARCHAR(1)	NULL ,
			HoldStatus 		SMALLINT	NULL ,
			PriorityLevel 		SMALLINT 	NOT NULL ,
			LockedByName		NVARCHAR (63)	NULL ,
			LockedTime		DATETIME	NULL ,
			ValidTill		DATETIME	NULL ,
			SaveStage		NVARCHAR(30)	NULL ,
			PreviousStage		NVARCHAR(30)	NULL ,
			ExpectedWorkItemDelayTime DATETIME	NULL,
			ExpectedProcessDelayTime DATETIME	NULL,
			Status 			NVARCHAR(50)	NULL ,
			VAR_INT1 		SMALLINT	NULL ,
			VAR_INT2 		SMALLINT	NULL ,
			VAR_INT3 		SMALLINT	NULL ,
			VAR_INT4 		SMALLINT	NULL ,
			VAR_INT5 		SMALLINT	NULL ,
			VAR_INT6 		SMALLINT	NULL ,
			VAR_INT7 		SMALLINT	NULL ,
			VAR_INT8 		SMALLINT	NULL ,
			VAR_FLOAT1		Numeric(15,2)	NULL ,
			VAR_FLOAT2		Numeric(15,2)	NULL ,
			VAR_DATE1		DATETIME	NULL ,
			VAR_DATE2		DATETIME	NULL ,
			VAR_DATE3		DATETIME	NULL ,
			VAR_DATE4		DATETIME	NULL ,
			VAR_LONG1 		INT		NULL ,
			VAR_LONG2 		INT		NULL ,
			VAR_LONG3 		INT		NULL ,
			VAR_LONG4 		INT		NULL ,
			VAR_STR1		NVARCHAR(255)	NULL ,
			VAR_STR2		NVARCHAR(255)	NULL ,
			VAR_STR3		NVARCHAR(255)	NULL ,
			VAR_STR4		NVARCHAR(255)	NULL ,
			VAR_STR5		NVARCHAR(255)	NULL ,
			VAR_STR6		NVARCHAR(255)	NULL ,
			VAR_STR7		NVARCHAR(255)	NULL ,
			VAR_STR8		NVARCHAR(255)	NULL ,
			VAR_REC_1		NVARCHAR(255)	NULL ,
			VAR_REC_2		NVARCHAR(255)	NULL ,
			VAR_REC_3		NVARCHAR(255)	NULL ,
			VAR_REC_4		NVARCHAR(255)	NULL ,
			VAR_REC_5		NVARCHAR(255)	NULL ,
			Q_StreamId 		INT		NULL ,
			Q_QueueId 		INT		NULL ,
			Q_UserID 		INT	NULL ,
			LastProcessedBy 	INT	NULL,
			ProcessedBy		NVARCHAR (63)	NULL ,
			ReferredTo 		INT	NULL ,
			ReferredToName		NVARCHAR (63)	NULL ,
			ReferredBy 		INT	NULL ,
			ReferredByName		NVARCHAR (63)	NULL ,
			CollectFlag 		NVARCHAR(1)	NULL ,
			CompletionDatetime	DATETIME	NULL ,
			CalendarName       NVARCHAR(255) NULL,
			ExportStatus	NVARCHAR(1) DEFAULT ''N'',
			ProcessVariantId 	INT 		NOT NULL DEFAULT 0,
			ActivityType		SmallInt NULL,
			lastModifiedTime 	DATETIME,
			VAR_DATE5		DATETIME	NULL ,
			VAR_DATE6		DATETIME	NULL ,
			VAR_LONG5 		INT		NULL ,
			VAR_LONG6 		INT		NULL ,
			VAR_STR9		NVARCHAR(512)	NULL ,
			VAR_STR10		NVARCHAR(512)	NULL ,
			VAR_STR11		NVARCHAR(512)	NULL ,
			VAR_STR12		NVARCHAR(512)	NULL ,
			VAR_STR13		NVARCHAR(512)	NULL ,
			VAR_STR14		NVARCHAR(512)	NULL ,
			VAR_STR15		NVARCHAR(512)	NULL ,
			VAR_STR16		NVARCHAR(512)	NULL ,
			VAR_STR17		NVARCHAR(512)	NULL ,
			VAR_STR18		NVARCHAR(512)	NULL ,
			VAR_STR19		NVARCHAR(512)	NULL ,
			VAR_STR20		NVARCHAR(512)	NULL ,
			CONSTRAINT PK_QUEUEHISTORYTABLE  PRIMARY KEY
			(
				ProcessInstanceId , WorkItemId
			)
		) ON PartitionSchemePId (processinstanceid)'
		
		EXECUTE(@vquery)
		print 'query -'+@vquery

		SELECT @vquery = 'CREATE INDEX IDX2_QueueHistoryTable ON QueueHistoryTable (ActivityName)'
		EXECUTE(@vquery)
		
		SELECT @vquery = 'CREATE INDEX IDX3_QueueHistoryTable ON QueueHistoryTable (VAR_REC_1, VAR_REC_2)'
		EXECUTE(@vquery)
		
		SELECT @vquery = 'CREATE INDEX IDX4_QueueHistoryTable ON QueueHistoryTable (Q_QueueId)'
		EXECUTE(@vquery)
		
		
		/***********	ExceptionTable	****************/
		
		If Exists (Select * FROM SysObjects (NOLOCK) Where xType = 'U' and name = 'ExceptionTable')
		Begin
			Execute('DROP Table ExceptionTable')
			Print 'Table ExceptionTable already exists, hence older one dropped ..... '
		End
		
		
		SELECT @vquery = ' CREATE TABLE EXCEPTIONTABLE (
			ProcessDefId            INTEGER         NOT NULL,
			ExcpSeqId               INTEGER         NOT NULL,
			WorkitemId              INTEGER         NOT NULL,
			Activityid              INTEGER         NOT NULL,
			ActivityName            NVARCHAR(30)    NOT NULL,
			ProcessInstanceId       NVARCHAR(63)    NOT NULL,
			UserId                  INT        NOT NULL,
			UserName                NVARCHAR(63)    NOT NULL,
			ActionId                INTEGER         NOT NULL,
			ActionDatetime          DATETIME        NOT NULL  CONSTRAINT DF_EXCPTAB DEFAULT getdate(),
			ExceptionId             INTEGER         NOT NULL,
			ExceptionName           NVARCHAR(50)    NOT NULL,
			FinalizationStatus      NVARCHAR(1)     NOT NULL CONSTRAINT DF_EXCPFS DEFAULT (N''T''),
			ExceptionComments       NVARCHAR(512)   NULL
		)  ON PartitionSchemePId (processinstanceid) '
		EXECUTE(@vquery)
		
		
		/***********INDEX FOR ExceptionTable****************/
		SELECT @vquery = ' CREATE INDEX IDX1_ExceptionTable ON ExceptionTable (ProcessInstanceId, ProcessDefId, ActivityId, ExceptionId, excpseqid DESC, ActionId DESC)'
		EXECUTE(@vquery)
		

		/***********INDEX FOR ExceptionTable****************/
		SELECT @vquery = ' CREATE INDEX IDX2_ExceptionTable ON ExceptionTable (ProcessInstanceId)'
		EXECUTE(@vquery)
		
		SELECT @vquery = ' CREATE INDEX IDX3_ExceptionTable ON ExceptionTable (ProcessDefId, ActivityId)'
		EXECUTE(@vquery)
		
		
		/***********	TODOSTATUSTABLE	****************/
		
		If Exists (Select * FROM SysObjects (NOLOCK) Where xType = 'U' and name = 'TODOSTATUSTABLE')
		Begin
			Execute('DROP Table TODOSTATUSTABLE')
			Print 'Table TODOSTATUSTABLE already exists, hence older one dropped ..... '
		End

		SELECT @vquery = ' CREATE TABLE TODOSTATUSTABLE (
			ProcessDefId		INTEGER         NOT NULL,
			ProcessInstanceId	NVARCHAR(63)     NOT NULL,
			ToDoValue		NVARCHAR(255)    NULL
		)  ON PartitionSchemePId (processinstanceid)'
		EXECUTE(@vquery)
		
		SELECT @vquery = ' CREATE INDEX IDX1_TODOSTATUSTABLE ON TODOSTATUSTABLE (ProcessInstanceId)'
		EXECUTE(@vquery)
		
		
		/******   WFCURRENTROUTELOGTABLE    ******/
		
		If Exists (Select * FROM SysObjects (NOLOCK) Where xType = 'U' and name = 'WFCURRENTROUTELOGTABLE')
		Begin
			Execute('DROP Table WFCURRENTROUTELOGTABLE')
			Print 'Table WFCURRENTROUTELOGTABLE already exists, hence older one dropped ..... '
		End

		SELECT @vquery = ' CREATE TABLE WFCURRENTROUTELOGTABLE (
			LogId 			BIGINT		IDENTITY (1,1) 		NOT NULL	PRIMARY KEY,
			ProcessDefId  		INT 		NOT NULL,
			ActivityId 		INT		NULL ,
			ProcessInstanceId	NVARCHAR(63)	NULL ,
			WorkItemId 		INT		NULL ,
			UserId 			INT	NULL ,
			ActionId 		INT 		NOT NULL ,
			ActionDatetime		DATETIME 	NOT NULL CONSTRAINT DF_WFCRLT_ActDT DEFAULT (CONVERT(DATETIME,getdate(),109)),
			AssociatedFieldId 	INT		NULL , 
			AssociatedFieldName	NVARCHAR (2000) NULL , 
			ActivityName		NVARCHAR(30)	NULL , 
			UserName		NVARCHAR (63)	NULL , 
			NewValue		NVARCHAR (2000)	NULL , 
			AssociatedDateTime	DATETIME 	NULL , 
			QueueId			INT		NULL,
			ProcessVariantId 	INT 		NOT NULL DEFAULT 0,
			TaskId			INT Default 0,
			SubTaskId 		INT Default 0
		)'
		EXECUTE(@vquery)
		
		SELECT @vquery = ' CREATE NONCLUSTERED  INDEX IX_CRT_partitioncol ON dbo.WFCurrentRouteLogTable (ProcessInstanceId)
		WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF,  ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) 
		 ON PartitionSchemeDate(ActionDatetime) '
		EXECUTE(@vquery)
		
		SELECT @vquery = ' CREATE INDEX  IDX1_WFRouteLogTABLE ON WFCURRENTROUTELOGTABLE (ProcessDefId,ActionId) '
		EXECUTE(@vquery)

		SELECT @vquery = ' CREATE INDEX  IDX2_WFRouteLogTABLE ON WFCURRENTROUTELOGTABLE (ActionId,UserID)'
		EXECUTE(@vquery)
		
		SELECT @vquery = ' CREATE INDEX IDX3_WFCRouteLogTable ON WFCurrentRouteLogTable (ProcessInstanceId)'
		EXECUTE(@vquery)

		SELECT @vquery = ' CREATE INDEX IDX4_WFCRouteLogTable ON WFCurrentRouteLogTable (ProcessInstanceId, ActionDateTime, LogID)'
		EXECUTE(@vquery)
		
		
		/***********	WFATTRIBUTEMESSAGETABLE	****************/
		
		If Exists (Select * FROM SysObjects (NOLOCK) Where xType = 'U' and name = 'WFATTRIBUTEMESSAGETABLE')
		Begin
			Execute('DROP Table WFATTRIBUTEMESSAGETABLE')
			Print 'Table WFATTRIBUTEMESSAGETABLE already exists, hence older one dropped ..... '
		End
		
		SELECT @vquery = ' CREATE TABLE WFATTRIBUTEMESSAGETABLE (
			ProcessInstanceID	NVARCHAR(63)  NOT NULL ,
			ProcessDefID		INT		NOT NULL,
			WorkItemId			INT		NOT NULL ,
			ProcessVariantId 	INT 		NOT NULL DEFAULT 0,
			messageId 			BIGINT		identity (1, 1) PRIMARY KEY, 
			message				NTEXT	 	NOT NULL, 
			lockedBy			NVARCHAR(63), 
			status 				NVARCHAR(1)	CHECK (status in (N''N'', N''F'')),
			ActionDateTime		DATETIME	
		) '
		EXECUTE(@vquery)
		
		SELECT @vquery = ' CREATE NONCLUSTERED  INDEX IX_AMT_partitioncol ON dbo.WFATTRIBUTEMESSAGETABLE (ProcessInstanceId)
		WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF,  ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) 
		 ON PartitionSchemeDate(ActionDateTime)'
		EXECUTE(@vquery)
		

		/***********	WFActivityReportTable	****************/
		
		If Exists (Select * FROM SysObjects (NOLOCK) Where xType = 'U' and name = 'WFActivityReportTable')
		Begin
			Execute('DROP Table WFActivityReportTable')
			Print 'Table WFActivityReportTable already exists, hence older one dropped ..... '
		End
		
		
		SELECT @vquery = ' CREATE TABLE WFActivityReportTable(
			ProcessDefId		Integer,
			ActivityId		    Integer,
			ActivityName		Nvarchar(30),
			ActionDateTime		DateTime,
			TotalWICount		Integer,
			TotalDuration		BIGINT,
			TotalProcessingTime	BIGINT
		) ON PartitionSchemeDate(ActionDateTime) '
		EXECUTE(@vquery)
		
		
		/***********INDEX FOR WFActivityReportTable****************/
		SELECT @vquery = ' CREATE INDEX IDX1_WFActivityReportTable ON WFActivityReportTable (ProcessDefId, ActivityId, ActionDateTime) '
		EXECUTE(@vquery)
		
		/***********	SUMMARYTABLE	****************/
		
		If Exists (Select * FROM SysObjects (NOLOCK) Where xType = 'U' and name = 'SUMMARYTABLE')
		Begin
			Execute('DROP Table SUMMARYTABLE')
			Print 'Table SUMMARYTABLE already exists, hence older one dropped ..... '
		End
		
		SELECT @vquery = ' CREATE TABLE SUMMARYTABLE
		(
		processdefid		INT,
		activityid			INT,
		activityname		NVARCHAR(30),
		queueid				INT,
		userid				INT,
		username			NVARCHAR(255),
		totalwicount		INT,
		ActionDatetime		DATETIME,
		actionid			INT,
		totalduration		BIGINT,
		reporttype			NVARCHAR(1),
		totalprocessingtime	BIGINT,
		delaytime			BIGINT,
		wkindelay			INT,
		AssociatedFieldId	INT,
		AssociatedFieldName	NVARCHAR(2000),
		ProcessVariantId        INT          NOT NULL DEFAULT 0
		) ON PartitionSchemeDate(ActionDateTime) '
		
		EXECUTE(@vquery)
		
		/***********Index for SUMMARYTABLE****************/

		SELECT @vquery = ' CREATE INDEX IDX1_SUMMARYTABLE ON SUMMARYTABLE (PROCESSDEFID, ACTIONID, ActionDateTime, ACTIVITYID, QueueId, USERID)	'
		EXECUTE(@vquery) 
		
		
		/***********	WFMAILQUEUEHISTORYTABLE	****************/
		
		If Exists (Select * FROM SysObjects (NOLOCK) Where xType = 'U' and name = 'WFMAILQUEUEHISTORYTABLE')
		Begin
			Execute('DROP Table WFMAILQUEUEHISTORYTABLE')
			Print 'Table WFMAILQUEUEHISTORYTABLE already exists, hence older one dropped ..... '
		End

		SELECT @vquery = ' CREATE TABLE WFMAILQUEUEHISTORYTABLE(
			TaskId 			INTEGER		PRIMARY KEY,
			mailFrom 		NVARCHAR(255),
			mailTo 			NVARCHAR(512), 
			mailCC 			NVARCHAR(512), 
			mailBCC 		NVARCHAR(512),	
			mailSubject 		NVARCHAR(255),
			mailMessage		NText,
			mailContentType		NVARCHAR(64),
			attachmentISINDEX 	NVARCHAR(255), 
			attachmentNames		NVARCHAR(512), 
			attachmentExts		NVARCHAR(128),	
			mailPriority		INTEGER, 
			mailStatus		NVARCHAR(1),
			statusComments		NVARCHAR(512),
			lockedBy		NVARCHAR(255),
			successTime		DATETIME,
			LastLockTime		DATETIME,
			insertedBy		NVARCHAR(255),
			mailActionType		NVARCHAR(20),
			insertedTime		DATETIME,
			processDefId		INTEGER,
			processInstanceId	NVARCHAR(63),
			workitemId		INTEGER,
			activityId		INTEGER,
			noOfTrials		INTEGER		default 0
		) '
		EXECUTE(@vquery) 
		
		SELECT @vquery = ' CREATE NONCLUSTERED  INDEX IX_MQHT_partitioncol ON dbo.WFMAILQUEUEHISTORYTABLE (ProcessInstanceId)
		WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF,  ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) 
		 ON PartitionSchemeDate(successTime) '
		EXECUTE(@vquery) 
		
		
		/***********	WFRecordedChats	****************/
		
		If Exists (Select * FROM SysObjects (NOLOCK) Where xType = 'U' and name = 'WFRecordedChats')
		Begin
			Execute('DROP Table WFRecordedChats')
			Print 'Table WFRecordedChats already exists, hence older one dropped ..... '
		End
		
		
		SELECT @vquery = ' CREATE TABLE WFRecordedChats(
			ProcessDefId 		INT 			NOT NULL,
			ProcessName 		NVARCHAR(255) 	NULL,
			SavedBy 			NVARCHAR(255) 	NULL,
			SavedAt 			DATETIME 		NOT NULL,
			ChatId 				NVARCHAR(255) 	NOT NULL,
			Chat 				NVARCHAR(MAX) 	NULL,
			ChatStartTime 		DATETIME 		NOT NULL,
			ChatEndTime 		DATETIME 		NOT NULL
		) ON PartitionSchemeDate(SavedAt) '
		EXECUTE(@vquery) 
		
		

		/***********	WFUserRatingLogTable	****************/
		
		If Exists (Select * FROM SysObjects (NOLOCK) Where xType = 'U' and name = 'WFUserRatingLogTable')
		Begin
			Execute('DROP Table WFUserRatingLogTable')
			Print 'Table WFUserRatingLogTable already exists, hence older one dropped ..... '
		End
		
		
		SELECT @vquery = ' CREATE TABLE WFUserRatingLogTable (
			RatingLogId     BIGINT  IDENTITY (1,1) ,
			RatingToUser    INT    NOT NULL ,
			RatingByUser    INT    NOT NULL,
			SkillId      INT    NOT NULL,
			Rating      DECIMAL(5,2)  NOT NULL ,
			RatingDateTime    DateTime,
			Remarks       NVARCHAR(1024) ,
			PRIMARY KEY ( RatingToUser,RatingByUser,SkillId )
		 
		) '
		EXECUTE(@vquery) 
			
		SELECT @vquery = ' CREATE NONCLUSTERED  INDEX IX_URT_partitioncol ON dbo.WFUserRatingLogTable (RatingDateTime)
		WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF,  ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) 
		ON PartitionSchemeDate(RatingDateTime) '
		EXECUTE(@vquery) 
		
		Select @vquery =  'INSERT INTO WFCabVersionTable(cabVersion, creationDate, lastModified, Remarks, Status) 
						  VALUES (N''PARTITIONINGSUPPORT'',GETDATE(), GETDATE(), N''Partitioning for Archival'', N''Y'')'
		EXECUTE(@vquery) 
		
	END
	