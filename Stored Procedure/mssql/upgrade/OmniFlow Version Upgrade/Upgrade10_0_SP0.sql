/*
Change DATE		Name				Description
--------------------------------------------------------------
26/05/2017		Sanal Grover		Bug 62518 - Step by Step Debugs in Version Upgrade.
05/06/2017		Sanal Grover		Bug 69853 - WorkinprocessTable and Workwithpstable handling in version upgrade for IBPS upgrade.

*/

CREATE PROCEDURE upgrade AS
BEGIN
	DECLARE @fields			NVARCHAR(4000)
	DECLARE @ErrorMessage	NVARCHAR(100)
	DECLARE @TableName		VARCHAR(50)
	DECLARE @ViewName		VARCHAR(50)
	DECLARE @ConstarintName		VARCHAR(100)
	--DECLARE @DepricatedTables	VARCHAR(200)
	DECLARE @IndexName		VARCHAR(50)
	DECLARE @RegNo			INT
	DECLARE @ForeignKey		VARCHAR(100)
	DECLARE @ParentObject	VARCHAR(100)
	DECLARE @CurrentSeq		INT
	DECLARE @ProcessDefId	INT
	DECLARE @psrIdent		INT
	DECLARE @cabVersion		NVARCHAR(50)
	DECLARE @v_logStatus NVARCHAR(10)
	DECLARE @v_scriptName varchar(100)
	
	SELECT @v_scriptName = 'Upgrade10_0_SP0'
	DECLARE @DepricatedTables TABLE
	(
		Value varchar(200)
	)
	Set NOCOUNT ON
	SELECT @fields = NULL
	
exec @v_logStatus= LogInsert 1,@v_scriptName,'Checking Cabinet is at Service Pack 6 level or not'
	BEGIN
	BEGIN TRY
		IF NOT EXISTS (SELECT 1 FROM WFCabVersionTable where cabVersion = '9.0_SU6')
		BEGIN
			exec  @v_logStatus = LogSkip 1,@v_scriptName
			SELECT @ErrorMessage = 'UPGRADE Failed. Cabinet is not at Service Pack 6 level'
			RAISERROR(@ErrorMessage,16,1)
			RETURN
		END
	END TRY
	BEGIN CATCH
	exec  @v_logStatus = LogFailed 1,@v_scriptName
	RAISERROR('Block 1 Failed.',16,1)
	RETURN
	END CATCH
	END
exec @v_logStatus = LogUpdate 1,@v_scriptName

exec @v_logStatus = LogInsert 2,@v_scriptName,'Checking Message Agent is running or not'	
	BEGIN
	BEGIN TRY
		IF EXISTS (SELECT 1 FROM wfmessagetable)
			BEGIN
				exec  @v_logStatus = LogSkip 2,@v_scriptName
				SELECT @ErrorMessage = 'UPGRADE Failed. Run Message Agent first before upgrade execution'
				RAISERROR(@ErrorMessage,16,1)
				RETURN
	
		END
	END TRY
	BEGIN CATCH
	exec  @v_logStatus = LogFailed 2,@v_scriptName
	RAISERROR('Block 2 Failed.',16,1)
	RETURN
	END CATCH
	END
exec @v_logStatus = LogUpdate 2,@v_scriptName

/*	IF EXISTS (select 1 from Workinprocesstable)
		BEGIN
			select @ErrorMessage = 'UPGRADE Failed. Some workitem locked by user'
			RAISERROR(@ErrorMessage,16,1)
		END
	IF EXISTS (select 1 from WorkWithPSTable)
		BEGIN
			select @ErrorMessage = 'UPGRADE Failed. Some workitem locked by PS'
			RAISERROR(@ErrorMessage,16,1)
		END
*/	

exec @v_logStatus = LogInsert 3,@v_scriptName,'Creating TABLE WFINSTRUMENTTABLE And Creating Indexes on various columns'	
	BEGIN
	BEGIN TRY	
		IF NOT EXISTS(SELECT * FROM sysObjects WHERE NAME = 'WFINSTRUMENTTABLE')
		BEGIN
			exec  @v_logStatus = LogSkip 3,@v_scriptName
			EXECUTE('CREATE TABLE WFINSTRUMENTTABLE (
			ProcessInstanceID			NVARCHAR(63)  NOT NULL ,
			ProcessDefID				INT		NOT NULL,
			Createdby					INT		NOT NULL ,
			CreatedByName				NVARCHAR(63)	NULL ,
			Createddatetime			DATETIME		NOT NULL ,
			Introducedbyid				INT		NULL ,
			Introducedby				NVARCHAR(63)	NULL ,
			IntroductionDATETIME	DATETIME		NULL ,
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
			VAR_DATE1				DATETIME		NULL ,
			VAR_DATE2				DATETIME		NULL ,
			VAR_DATE3				DATETIME		NULL ,
			VAR_DATE4				DATETIME		NULL ,
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
			CalENDarName        		NVARCHAR(255) NULL,  
			ProcessName 				NVARCHAR(30)	NOT NULL ,
			ProcessVersion   			SMALLINT,
			LastProcessedBy 			INT		NULL ,
			ProcessedBy					NVARCHAR(63)	NULL,	
			ActivityName 				NVARCHAR(30)	NULL ,
			ActivityId 					INT		NULL ,
			EntryDATETIME 			DATETIME		NULL ,
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
			Q_DivertedByUserId			INT	NULL,
			CONSTRAINT PK_WFINSTRUMENTTable PRIMARY KEY 
			(
				ProcessInstanceID,WorkitemId
			)
			)')
		
			EXECUTE('CREATE INDEX IDX1_WFINSTRUMENTTABLE ON WFINSTRUMENTTABLE (var_rec_1, var_rec_2)')

			EXECUTE('CREATE INDEX IDX2_WFINSTRUMENTTABLE ON WFINSTRUMENTTABLE (Q_QueueId,ProcessInstanceId,WorkitemId)')

			EXECUTE('CREATE INDEX IDX3_WFINSTRUMENTTABLE ON WFINSTRUMENTTABLE (Q_UserID, ProcessInstanceId, WorkitemId)')

			EXECUTE('CREATE INDEX IDX4_WFINSTRUMENTTABLE ON WFINSTRUMENTTABLE (ProcessInstanceId,WorkitemId)')
			
			EXECUTE('CREATE INDEX IDX5_WFINSTRUMENTTABLE ON WFINSTRUMENTTABLE (Q_QueueId,WorkItemState , LockStatus , RoutingStatus , EntryDateTime)')

			EXECUTE('CREATE INDEX IDX6_WFINSTRUMENTTABLE ON WFINSTRUMENTTABLE (ProcessDefId, RoutingStatus, LockStatus)')

			EXECUTE('CREATE INDEX IDX7_WFINSTRUMENTTABLE ON WFINSTRUMENTTABLE  (PROCESSINSTANCEID, PARENTWORKITEMID)')

			EXECUTE('CREATE INDEX IDX8_WFINSTRUMENTTABLE ON WFINSTRUMENTTABLE(Q_UserId, ROUTINGSTATUS, Q_QUEUEID)')

			EXECUTE('CREATE INDEX IDX9_WFINSTRUMENTTABLE ON WFINSTRUMENTTABLE(Q_Queueid, LockStatus,EntryDateTime,ProcessInstanceID,WorkItemID)')

			EXECUTE('CREATE INDEX IDX10_WFINSTRUMENTTABLE ON WFINSTRUMENTTABLE(Childprocessinstanceid, Childworkitemid)')
			
			EXECUTE('CREATE INDEX IDX11_WFINSTRUMENTTABLE ON WFINSTRUMENTTABLE (ValidTill)')
			
			EXECUTE('CREATE INDEX IDX12_WFINSTRUMENTTABLE ON WFINSTRUMENTTABLE(ASSIGNMENTTYPE ,VALIDTILL  ,ROUTINGSTATUS  ,LOCKSTATUS)')
		END
	END TRY
	BEGIN CATCH
	exec  @v_logStatus = LogFailed 3,@v_scriptName
	RAISERROR('Block 3 Failed.',16,1)
	RETURN
	END CATCH
	END
exec @v_logStatus = LogUpdate 3,@v_scriptName

exec @v_logStatus = LogInsert 4,@v_scriptName,'Creating Index on Column ActivityType of ActivityTable'	
	BEGIN
	BEGIN TRY
		IF NOT EXISTS (SELECT *	FROM sysindexes	WHERE id = OBJECT_ID('ActivityTable')
		AND name = 'IDX1_ActivityTable') 
		BEGIN
			exec  @v_logStatus = LogSkip 4,@v_scriptName
			EXECUTE('CREATE INDEX IDX1_ActivityTable ON ActivityTable (ActivityType)')
			PRINT 'INDEXES CREATED SUCCESSFULLY'
		END	
	END TRY
	BEGIN CATCH
	exec  @v_logStatus = LogFailed 4,@v_scriptName
	RAISERROR('Block 4 Failed.',16,1)
	RETURN
	END CATCH
	END
exec @v_logStatus = LogUpdate 4,@v_scriptName

exec @v_logStatus = LogInsert 5,@v_scriptName,'Creating Index on Columns ProcessInstanceId, ActionDateTime, LogID of WFCurrentRouteLogTable'	
	BEGIN
	BEGIN TRY
		IF EXISTS (SELECT *	FROM sysindexes	WHERE id = OBJECT_ID('WFCurrentRouteLogTable'))
		BEGIN
			IF NOT EXISTS (SELECT *	FROM sysindexes	WHERE id = OBJECT_ID('WFCurrentRouteLogTable')
				AND name = 'IDX4_WFCRouteLogTable') 
			BEGIN
				exec  @v_logStatus = LogSkip 5,@v_scriptName
				EXECUTE('CREATE INDEX IDX4_WFCRouteLogTable ON WFCurrentRouteLogTable(ProcessInstanceId, ActionDateTime, LogID)')
				PRINT 'INDEXES CREATED SUCCESSFULLY'
			END
		END
	END TRY
	BEGIN CATCH
	exec  @v_logStatus = LogFailed 5,@v_scriptName
	RAISERROR('Block 5 Failed.',16,1)
	RETURN
	END CATCH
	END
exec @v_logStatus = LogUpdate 5,@v_scriptName

exec @v_logStatus = LogInsert 6,@v_scriptName,'Creating Index on Columns ProcessInstanceId, ActionDateTime, LogID of WFHISTORYROUTELOGTABLE'	
	BEGIN
	BEGIN TRY
		IF EXISTS (SELECT *	FROM sysindexes	WHERE id = OBJECT_ID('WFHISTORYROUTELOGTABLE'))
		BEGIN
		IF NOT EXISTS (SELECT *	FROM sysindexes	WHERE id = OBJECT_ID('WFHISTORYROUTELOGTABLE')
			AND name = 'IDX4_WFHRouteLogTABLE') 
		BEGIN
			exec  @v_logStatus = LogSkip 6,@v_scriptName
			EXECUTE('CREATE INDEX  IDX4_WFHRouteLogTABLE ON WFHISTORYROUTELOGTABLE(ProcessInstanceId, ActionDateTime, LogID)')
			PRINT 'INDEXES CREATED SUCCESSFULLY'
		END
		END
	END TRY
	BEGIN CATCH
	exec  @v_logStatus = LogFailed 6,@v_scriptName
	RAISERROR('Block 6 Failed.',16,1)
	RETURN
	END CATCH
	END
exec @v_logStatus = LogUpdate 6,@v_scriptName

exec @v_logStatus = LogInsert 7,@v_scriptName,'Creating Index on Columns ProcessInstanceId, ActionDateTime, LogID of CurrentRouteLogTable'	
	BEGIN
	BEGIN TRY
		IF EXISTS (SELECT *	FROM sysindexes	WHERE id = OBJECT_ID('CurrentRouteLogTable'))
		BEGIN
			IF NOT EXISTS (SELECT *	FROM sysindexes	WHERE id = OBJECT_ID('CurrentRouteLogTable')
				AND name = 'IDX4_CRouteLogTable') 
			BEGIN
				exec  @v_logStatus = LogSkip 7,@v_scriptName
				EXECUTE('CREATE INDEX IDX4_CRouteLogTable ON CurrentRouteLogTable(ProcessInstanceId, ActionDateTime, LogID)')
				PRINT 'INDEXES CREATED SUCCESSFULLY'
			END
		END
	END TRY
	BEGIN CATCH
	exec  @v_logStatus = LogFailed 7,@v_scriptName
	RAISERROR('Block 7 Failed.',16,1)
	RETURN
	END CATCH
	END
exec @v_logStatus = LogUpdate 7,@v_scriptName

exec @v_logStatus = LogInsert 8,@v_scriptName,'Creating Index on Columns ProcessInstanceId, ActionDateTime, LogID of HISTORYROUTELOGTABLE'	
	BEGIN
	BEGIN TRY
		IF EXISTS (SELECT *	FROM sysindexes	WHERE id = OBJECT_ID('HISTORYROUTELOGTABLE'))
		BEGIN
			IF NOT EXISTS (SELECT *	FROM sysindexes	WHERE id = OBJECT_ID('HISTORYROUTELOGTABLE')
				AND name = 'IDX4_HRouteLogTABLE') 
			BEGIN
				exec  @v_logStatus = LogSkip 8,@v_scriptName
				EXECUTE('CREATE INDEX  IDX4_HRouteLogTABLE ON HISTORYROUTELOGTABLE(ProcessInstanceId, ActionDateTime, LogID)')
				PRINT 'INDEXES CREATED SUCCESSFULLY'
			END
		END
	END TRY
	BEGIN CATCH
	exec  @v_logStatus = LogFailed 8,@v_scriptName
	RAISERROR('Block 8 Failed.',16,1)
	RETURN
	END CATCH
	END
exec @v_logStatus = LogUpdate 8,@v_scriptName

exec @v_logStatus = LogInsert 9,@v_scriptName,'Creating Index on Column ActivityName of QueueHistoryTable'		
	BEGIN
	BEGIN TRY
		IF NOT EXISTS (SELECT *	FROM sysindexes	WHERE id = OBJECT_ID('QueueHistoryTable')
			AND name = 'IDX2_QueueHistoryTable') 
		BEGIN
			exec  @v_logStatus = LogSkip 9,@v_scriptName
			EXECUTE('CREATE INDEX  IDX2_QueueHistoryTable ON QueueHistoryTable (ActivityName)')
			PRINT 'INDEXES CREATED SUCCESSFULLY'
		END	
	END TRY
	BEGIN CATCH
				exec  @v_logStatus = LogFailed 9,@v_scriptName
	RAISERROR('Block 9 Failed.',16,1)
	RETURN
	END CATCH
	END
exec @v_logStatus = LogUpdate 9,@v_scriptName

exec @v_logStatus = LogInsert 10,@v_scriptName,'Creating Index on Column VAR_REC_1,VAR_REC_2 of QueueHistoryTable'	
	BEGIN
	BEGIN TRY
		IF NOT EXISTS (SELECT *	FROM sysindexes	WHERE id = OBJECT_ID('QueueHistoryTable')
		AND name = 'IDX3_QueueHistoryTable') 
		BEGIN
			exec  @v_logStatus = LogSkip 10,@v_scriptName
			EXECUTE('CREATE INDEX  IDX3_QueueHistoryTable ON QueueHistoryTable (VAR_REC_1,VAR_REC_2)')
			PRINT 'INDEXES CREATED SUCCESSFULLY'
		END	
	END TRY
	BEGIN CATCH
	exec  @v_logStatus = LogFailed 10,@v_scriptName
	RAISERROR('Block 10 Failed.',16,1)
	RETURN
	END CATCH
	END
exec @v_logStatus = LogUpdate 10,@v_scriptName

exec @v_logStatus = LogInsert 11,@v_scriptName,'Creating Index on Column Q_QueueId of QueueHistoryTable'	
	BEGIN
	BEGIN TRY
		IF NOT EXISTS (SELECT *	FROM sysindexes	WHERE id = OBJECT_ID('QueueHistoryTable')
		AND name = 'IDX4_QueueHistoryTable') 
		BEGIN
			exec  @v_logStatus = LogSkip 11,@v_scriptName
			EXECUTE('CREATE INDEX  IDX4_QueueHistoryTable ON QueueHistoryTable (Q_QueueId)')
			PRINT 'INDEXES CREATED SUCCESSFULLY'
		END	
	END TRY
	BEGIN CATCH
	exec  @v_logStatus = LogFailed 11,@v_scriptName
	RAISERROR('Block 11 Failed.',16,1)
	RETURN
	END CATCH
	END
exec @v_logStatus = LogUpdate 11,@v_scriptName

exec @v_logStatus = LogInsert 12,@v_scriptName,'Creating Index on Column Activityid, Streamid of QueueStreamTable'	
	BEGIN
	BEGIN TRY
		IF NOT EXISTS (SELECT *	FROM sysindexes	WHERE id = OBJECT_ID('QueueStreamTable')
		AND name = 'IDX2_QueueStreamTable') 
		BEGIN
			exec  @v_logStatus = LogSkip 12,@v_scriptName
			EXECUTE('CREATE INDEX IDX2_QueueStreamTable ON QueueStreamTable (Activityid, Streamid)')
			PRINT 'INDEXES CREATED SUCCESSFULLY'
		END	
	END TRY
	BEGIN CATCH
	exec  @v_logStatus = LogFailed 12,@v_scriptName
	RAISERROR('Block 12 Failed.',16,1)
	RETURN
	END CATCH
	END
exec @v_logStatus = LogUpdate 12,@v_scriptName

exec @v_logStatus = LogInsert 13,@v_scriptName,'Creating Index on Column ProcessDefId, ActivityId of ExceptionTable'	
	BEGIN
	BEGIN TRY
		
		IF NOT EXISTS (SELECT *	FROM sysindexes	WHERE id = OBJECT_ID('ExceptionTable')
		AND name = 'IDX3_ExceptionTable') 
		BEGIN
			exec  @v_logStatus = LogSkip 13,@v_scriptName
			EXECUTE('CREATE INDEX IDX3_ExceptionTable ON ExceptionTable (ProcessDefId, ActivityId)')
			PRINT 'INDEXES CREATED SUCCESSFULLY'
		END	
	END TRY
	BEGIN CATCH
	exec  @v_logStatus = LogFailed 13,@v_scriptName
	RAISERROR('Block 13 Failed.',16,1)
	RETURN
	END CATCH
	END
exec @v_logStatus = LogUpdate 13,@v_scriptName

exec @v_logStatus = LogInsert 14,@v_scriptName,'Creating Index on Column ProcessInstanceId of TODOSTATUSTABLE'	
	BEGIN
	BEGIN TRY
		IF NOT EXISTS (SELECT *	FROM sysindexes	WHERE id = OBJECT_ID('TODOSTATUSTABLE')
		AND name = 'IDX1_TODOSTATUSTABLE') 
		BEGIN
			exec  @v_logStatus = LogSkip 14,@v_scriptName
			EXECUTE('CREATE INDEX IDX1_TODOSTATUSTABLE ON TODOSTATUSTABLE (ProcessInstanceId)')
			PRINT 'INDEXES CREATED SUCCESSFULLY'
		END	
	END TRY
	BEGIN CATCH
	exec  @v_logStatus = LogFailed 14,@v_scriptName
	RAISERROR('Block 14 Failed.',16,1)
	RETURN
	END CATCH
	END
exec @v_logStatus = LogUpdate 14,@v_scriptName

exec @v_logStatus = LogInsert 15,@v_scriptName,'Data transfering from Processinstancetable and Queuedatatable into WFInstrumentTable...'	
	BEGIN
	BEGIN TRY
		BEGIN Transaction DataMovement
		IF EXISTS (	select 1 
					from sysObjects 
					where name in ('PROCESSINSTANCETABLE','QUEUEDATATABLE')
				  )
		BEGIN
			exec  @v_logStatus = LogSkip 15,@v_scriptName
			EXECUTE('Insert into WFInstrumentTable (ProcessInstanceID, ProcessDefID, Createdby, CreatedByName, Createddatetime, Introducedbyid, Introducedby, IntroductionDATETIME, ProcessInstanceState, ExpectedProcessDelay, IntroducedAt, WorkItemId, VAR_INT1, VAR_INT2, VAR_INT3, VAR_INT4, VAR_INT5, VAR_INT6, VAR_INT7, VAR_INT8, VAR_FLOAT1, VAR_FLOAT2, VAR_DATE1, VAR_DATE2, VAR_DATE3, VAR_DATE4, VAR_LONG1, VAR_LONG2, VAR_LONG3, VAR_LONG4, VAR_STR1, VAR_STR2, VAR_STR3, VAR_STR4, VAR_STR5, VAR_STR6, VAR_STR7, VAR_STR8, VAR_REC_1, VAR_REC_2, VAR_REC_3, VAR_REC_4, VAR_REC_5, InstrumentStatus, CheckListCompleteFlag, SaveStage, HoldStatus, Status, ReferredTo, ReferredToName, ReferredBy, ReferredByName, ChildProcessInstanceId, ChildWorkitemId, ParentWorkItemID, CalENDarName, ProcessName, LockStatus, RoutingStatus)
				select Processinstancetable.ProcessInstanceID, ProcessDefID, Createdby, CreatedByName, Createddatetime, Introducedbyid, Introducedby, IntroductionDATETIME, ProcessInstanceState, ExpectedProcessDelay, IntroducedAt, WorkItemId, VAR_INT1, VAR_INT2, VAR_INT3, VAR_INT4, VAR_INT5, VAR_INT6, VAR_INT7, VAR_INT8, VAR_FLOAT1, VAR_FLOAT2, VAR_DATE1, VAR_DATE2, VAR_DATE3, VAR_DATE4, VAR_LONG1, VAR_LONG2, VAR_LONG3, VAR_LONG4, VAR_STR1, VAR_STR2, VAR_STR3, VAR_STR4, VAR_STR5, VAR_STR6, VAR_STR7, VAR_STR8, VAR_REC_1, VAR_REC_2, VAR_REC_3, VAR_REC_4, VAR_REC_5, InstrumentStatus, CheckListCompleteFlag, SaveStage, HoldStatus, Status, ReferredTo, ReferredToName, ReferredBy, ReferredByName, ChildProcessInstanceId, ChildWorkitemId, ParentWorkItemID, CalENDarName, ''NA'', ''N'', ''R'' from Processinstancetable , Queuedatatable where Processinstancetable.ProcessInstanceID = Queuedatatable.ProcessInstanceID')
			
			EXECUTE('truncate table Processinstancetable')
			
			EXECUTE('truncate table Queuedatatable')
			PRINT 'Data transfered from Processinstancetable and Queuedatatable into WFInstrumentTable...'
		END
	END TRY
	BEGIN CATCH
	exec  @v_logStatus = LogFailed 15,@v_scriptName
	RAISERROR('Block 15 Failed.',16,1)
	RETURN
	END CATCH
	END
exec @v_logStatus = LogUpdate 15,@v_scriptName

exec @v_logStatus = LogInsert 16,@v_scriptName,'Data transfering from WORKLISTTABLE into WFInstrumentTable...'	
	BEGIN
	BEGIN TRY	
		IF EXISTS (	select 1 
					from sysObjects 
					where name = 'WORKLISTTABLE'
				  )
		BEGIN
			exec  @v_logStatus = LogSkip 16,@v_scriptName
			EXECUTE('Update WFInstrumentTable set ProcessName = WLT.ProcessName, ProcessVersion = WLT.ProcessVersion, LastProcessedBy = WLT.LastProcessedBy, ProcessedBy = WLT.ProcessedBy, ActivityName = WLT.ActivityName, ActivityId = WLT.ActivityId, EntryDATETIME = WLT.EntryDATETIME, AssignmentType = WLT.AssignmentType, CollectFlag = WLT.CollectFlag, PriorityLevel = WLT.PriorityLevel, ValidTill = WLT.ValidTill, Q_StreamId = WLT.Q_StreamId, Q_QueueId = WLT.Q_QueueId, Q_UserId = (CASE WHEN WLT.AssignmentType = ''F'' THEN WLT.Q_UserId ELSE 0 END), AssignedUser = WLT.AssignedUser, FilterValue = WLT.FilterValue, WorkItemState = WLT.WorkItemState, Statename = WLT.Statename, ExpectedWorkitemDelay = WLT.ExpectedWorkitemDelay, PreviousStage = WLT.PreviousStage, LockedByName = null, LockStatus = ''N'',RoutingStatus = ''N'',LockedTime = null, Queuename = WLT.Queuename, Queuetype = WLT.Queuetype, NotifyStatus = WLT.NotifyStatus, Q_DivertedByUserId = WLT.Q_DivertedByUserId
			from WFInstrumentTable as WIT inner join Worklisttable as WLT
			on WIT.ProcessInstanceID = WLT.ProcessInstanceID and WIT.WorkItemId = WLT.WorkItemId')
			
			EXECUTE('truncate table Worklisttable')
			PRINT 'Data transfered from WORKLISTTABLE into WFInstrumentTable...'
		END
	END TRY
	BEGIN CATCH
	exec  @v_logStatus = LogFailed 16,@v_scriptName
	RAISERROR('Block 16 Failed.',16,1)
	RETURN
	END CATCH
	END
exec @v_logStatus = LogUpdate 16,@v_scriptName

exec @v_logStatus = LogInsert 17,@v_scriptName,'Data transfering from WORKINPROCESSTABLE into WFInstrumentTable...'	
	BEGIN
	BEGIN TRY	
		IF EXISTS (	select 1 
					from sysObjects 
					where name = 'WORKINPROCESSTABLE' and XTYPE = 'U' 
				  )
		BEGIN
			exec  @v_logStatus = LogSkip 17,@v_scriptName
			EXECUTE('Update WFInstrumentTable set ProcessName = WPT.ProcessName, ProcessVersion = WPT.ProcessVersion, LastProcessedBy = WPT.LastProcessedBy, ProcessedBy = WPT.ProcessedBy, ActivityName = WPT.ActivityName, ActivityId = WPT.ActivityId, EntryDATETIME = WPT.EntryDATETIME, AssignmentType = WPT.AssignmentType, CollectFlag = WPT.CollectFlag, PriorityLevel = WPT.PriorityLevel, ValidTill = WPT.ValidTill, Q_StreamId = WPT.Q_StreamId, Q_QueueId = WPT.Q_QueueId, Q_UserId = (CASE WHEN WPT.AssignmentType = ''F'' THEN WPT.Q_UserId ELSE 0 END), AssignedUser = WPT.AssignedUser, FilterValue = WPT.FilterValue, WorkItemState = WPT.WorkItemState, Statename = WPT.Statename, ExpectedWorkitemDelay = WPT.ExpectedWorkitemDelay, PreviousStage = WPT.PreviousStage, LockedByName = null, LockStatus = ''N'', RoutingStatus = ''N'', LockedTime = null, Queuename = WPT.Queuename, Queuetype = WPT.Queuetype, NotifyStatus = WPT.NotifyStatus, GUID = WPT.GUID, Q_DivertedByUserId = WPT.Q_DivertedByUserId
			from WFInstrumentTable as WIT inner join WorkInProcessTable as WPT
			on WIT.ProcessInstanceID = WPT.ProcessInstanceID and WIT.WorkItemId = WPT.WorkItemId')
			
			EXECUTE('truncate table WorkInProcessTable')
			PRINT 'Data transfered from WORKINPROCESSTABLE into WFInstrumentTable...'
		END
	END TRY
	BEGIN CATCH
	exec  @v_logStatus = LogFailed 17,@v_scriptName
	RAISERROR('Block 17 Failed.',16,1)
	RETURN
	END CATCH
	END
exec @v_logStatus = LogUpdate 17,@v_scriptName

exec @v_logStatus = LogInsert 18,@v_scriptName,'Data transfering from WORKDONETABLE into WFInstrumentTable...'	
	BEGIN
	BEGIN TRY	
		IF EXISTS (	select 1 
					from sysObjects 
					where name = 'WORKDONETABLE'
				  )
		BEGIN
			exec  @v_logStatus = LogSkip 18,@v_scriptName
			EXECUTE('update WFInstrumentTable set ProcessName = WDT.ProcessName, ProcessVersion = WDT.ProcessVersion, LastProcessedBy = WDT.LastProcessedBy, ProcessedBy = WDT.ProcessedBy, ActivityName = WDT.ActivityName, ActivityId = WDT.ActivityId, EntryDATETIME = WDT.EntryDATETIME, AssignmentType = WDT.AssignmentType, CollectFlag = WDT.CollectFlag, PriorityLevel = WDT.PriorityLevel, ValidTill = WDT.ValidTill, Q_StreamId = WDT.Q_StreamId, Q_QueueId = WDT.Q_QueueId, Q_UserId = 0, AssignedUser = WDT.AssignedUser, FilterValue = WDT.FilterValue, WorkItemState = WDT.WorkItemState, Statename = WDT.Statename, ExpectedWorkitemDelay = WDT.ExpectedWorkitemDelay, PreviousStage = WDT.PreviousStage, LockedByName = null, LockStatus = ''N'', RoutingStatus = ''Y'', LockedTime = null, Queuename = WDT.Queuename, Queuetype = WDT.Queuetype, NotifyStatus = WDT.NotifyStatus, Q_DivertedByUserId = WDT.Q_DivertedByUserId
					from WFInstrumentTable as WIT inner join Workdonetable as WDT
					on WIT.ProcessInstanceID = WDT.ProcessInstanceID and WIT.WorkItemId = WDT.WorkItemId')
					
			EXECUTE('truncate table Workdonetable')
			PRINT 'Data transfered from WORKDONETABLE into WFInstrumentTable...'
		END
	END TRY
	BEGIN CATCH
	exec  @v_logStatus = LogFailed 18,@v_scriptName
	RAISERROR('Block 18 Failed.',16,1)
	RETURN
	END CATCH
	END
exec @v_logStatus = LogUpdate 18,@v_scriptName

exec @v_logStatus = LogInsert 19,@v_scriptName,'Data transfering from WorkWithPSTable into WFInstrumentTable...'	
	BEGIN
	BEGIN TRY	
		IF EXISTS (	select 1 
					from sysObjects 
					where name = 'WORKWITHPSTABLE' and XTYPE = 'U'
				  )
		BEGIN
			exec  @v_logStatus = LogSkip 19,@v_scriptName
			EXECUTE('Update WFInstrumentTable set ProcessName = WPST.ProcessName, ProcessVersion = WPST.ProcessVersion, LastProcessedBy = WPST.LastProcessedBy, ProcessedBy = WPST.ProcessedBy, ActivityName = WPST.ActivityName, ActivityId = WPST.ActivityId, EntryDATETIME = WPST.EntryDATETIME, AssignmentType = WPST.AssignmentType, CollectFlag = WPST.CollectFlag, PriorityLevel = WPST.PriorityLevel, ValidTill = WPST.ValidTill, Q_StreamId = WPST.Q_StreamId, Q_QueueId = WPST.Q_QueueId, Q_UserId = 0, AssignedUser = WPST.AssignedUser, FilterValue = WPST.FilterValue, WorkItemState = WPST.WorkItemState, Statename = WPST.Statename, ExpectedWorkitemDelay = WPST.ExpectedWorkitemDelay, PreviousStage = WPST.PreviousStage, LockedByName = null, LockStatus = ''N'', RoutingStatus = ''Y'', LockedTime = null, Queuename = WPST.Queuename, Queuetype = WPST.Queuetype, NotifyStatus = WPST.NotifyStatus, GUID = WPST.GUID, Q_DivertedByUserId = WPST.Q_DivertedByUserId
			from WFInstrumentTable as WIT inner join WorkWithPSTable as WPST
			on WIT.ProcessInstanceID = WPST.ProcessInstanceID and WIT.WorkItemId = WPST.WorkItemId')
			
			EXECUTE('truncate table WorkWithPSTable')
			PRINT 'Data transfered from WorkWithPSTable into WFInstrumentTable...'
		END
	END TRY
	BEGIN CATCH
	exec  @v_logStatus = LogFailed 19,@v_scriptName
	RAISERROR('Block 19 Failed.',16,1)
	RETURN
	END CATCH
	END
exec @v_logStatus = LogUpdate 19,@v_scriptName

exec @v_logStatus = LogInsert 20,@v_scriptName,'Data transfering from PENDINGWORKLISTTABLE into WFInstrumentTable...'	
	BEGIN
	BEGIN TRY	
		IF EXISTS (	select 1 
					from sysObjects 
					where name = 'PENDINGWORKLISTTABLE'
				  )
		BEGIN
			exec  @v_logStatus = LogSkip 20,@v_scriptName
			EXECUTE('update WFInstrumentTable set ProcessName = PWT.ProcessName, ProcessVersion = PWT.ProcessVersion, LastProcessedBy = PWT.LastProcessedBy, ProcessedBy = PWT.ProcessedBy, ActivityName = PWT.ActivityName, ActivityId = PWT.ActivityId, EntryDATETIME = PWT.EntryDATETIME, AssignmentType = PWT.AssignmentType, CollectFlag = PWT.CollectFlag, PriorityLevel = PWT.PriorityLevel, ValidTill = PWT.ValidTill, Q_StreamId = PWT.Q_StreamId, Q_QueueId = PWT.Q_QueueId, Q_UserId = PWT.Q_UserId, AssignedUser = PWT.AssignedUser, FilterValue = PWT.FilterValue, WorkItemState = PWT.WorkItemState, Statename = PWT.Statename, ExpectedWorkitemDelay = PWT.ExpectedWorkitemDelay, PreviousStage = PWT.PreviousStage, LockedByName = PWT.LockedByName, LockStatus = (CASE WHEN PWT.LockStatus is null THEN ''N'' ELSE PWT.LockStatus END), RoutingStatus = ''R'', LockedTime = PWT.LockedTime, Queuename = PWT.Queuename, Queuetype = PWT.Queuetype, NotifyStatus = PWT.NotifyStatus, NoOfCollectedInstances = ISNULL(PWT.NoOfCollectedInstances,0), IsPrimaryCollected = PWT.IsPrimaryCollected, ExportStatus = PWT.ExportStatus, Q_DivertedByUserId = PWT.Q_DivertedByUserId
					from WFInstrumentTable as WIT inner join PENDingworklisttable as PWT
					on WIT.ProcessInstanceID = PWT.ProcessInstanceID and WIT.WorkItemId = PWT.WorkItemId')
					
			EXECUTE('truncate table PENDingworklisttable')
			PRINT 'Data transfered from PENDINGWORKLISTTABLE into WFInstrumentTable...'
		END
		
		Commit Transaction DataMovement
	END TRY
	BEGIN CATCH
	exec  @v_logStatus = LogFailed 20,@v_scriptName
	RAISERROR('Block 20 Failed.',16,1)
	RETURN
	END CATCH
	END
exec @v_logStatus = LogUpdate 20,@v_scriptName

exec @v_logStatus = LogInsert 21,@v_scriptName,'Deleting  Depricated tables PROCESSINSTANCETABLE,QUEUEDATATABLE,WORKLISTTABLE,WORKINPROCESSTABLE,WORKDONETABLE,WORKWITHPSTABLE,PENDINGWORKLISTTABLE'	
	BEGIN
	BEGIN TRY
		exec  @v_logStatus = LogSkip 21,@v_scriptName
		-- SELECT @DepricatedTables = '''PROCESSINSTANCETABLE'',''QUEUEDATATABLE'',''WORKLISTTABLE'',''WORKINPROCESSTABLE'',''WORKDONETABLE'',''WORKWITHPSTABLE'',''PENDINGWORKLISTTABLE'''
		
		--Inserting deprectated tables in table variable
		INSERT INTO @DEPRICATEDTABLES VALUES ('PROCESSINSTANCETABLE')
		INSERT INTO @DEPRICATEDTABLES VALUES ('QUEUEDATATABLE')
		INSERT INTO @DEPRICATEDTABLES VALUES ('WORKLISTTABLE')
		INSERT INTO @DEPRICATEDTABLES VALUES ('WORKINPROCESSTABLE')
		INSERT INTO @DEPRICATEDTABLES VALUES ('WORKDONETABLE')
		INSERT INTO @DEPRICATEDTABLES VALUES ('WORKWITHPSTABLE')
		INSERT INTO @DEPRICATEDTABLES VALUES ('PENDINGWORKLISTTABLE')
		
		DECLARE ConstraintsCursor CURSOR FOR
			select obj.name as ConstraintName, tabs.name as TableName from sys.objects obj, sys.tables tabs where obj.parent_object_id = tabs.object_id 
			and obj.type_desc like '%CONSTRAINT' and tabs.name in (SELECT VALUE FROM @DEPRICATEDTABLES)
		OPEN ConstraintsCursor
		FETCH NEXT FROM ConstraintsCursor into @ConstarintName, @TableName
		WHILE @@FETCH_STATUS = 0
		BEGIN
			EXEC('ALTER TABLE [' + @TableName + '] DROP CONSTRAINT [' + @ConstarintName +']' )
			FETCH NEXT FROM ConstraintsCursor INTO @ConstarintName, @TableName
		END
		CLOSE ConstraintsCursor
		DEALLOCATE ConstraintsCursor
		PRINT 'All constraints on depricated tables has been deleted successfully...'
	
		DECLARE TableCursor Cursor for
				select name from sys.tables where name in (SELECT VALUE FROM @DEPRICATEDTABLES)
		Select @TableName = null
		OPEN TableCursor
		FETCH NEXT FROM TableCursor into @TableName
		WHILE @@FETCH_STATUS = 0
		BEGIN
			EXEC('Drop table '+@TableName)
			FETCH NEXT FROM TableCursor into @TableName
		END
		CLOSE TableCursor
		DEALLOCATE TableCursor
		PRINT 'All depricated tables has been deleted successfully...'
	
		IF EXISTS (select 1 from sys.views 
					where name = 'QueueTable')
		BEGIN
			EXECUTE('DROP VIEW QUEUETABLE')
		END
		
		EXECUTE('CREATE VIEW QUEUETABLE 
		AS
		SELECT  processdefid, processname, processversion, 
			processinstanceid, processinstanceid AS processinstancename, 
			activityid, activityname, parentworkitemid, workitemid, 
			processinstancestate, workitemstate, statename, queuename, queuetype,
			AssignedUser, AssignmentType, instrumentstatus, checklistcompleteflag, 
			IntroductionDateTime, CreatedDatetime AS CreatedDatetime,
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
			referredtoname, referredby, referredbyname, collectflag, NULL AS CompletionDatetime, CalENDarName
		FROM WFINSTRUMENTTABLE with (NOLOCK)')	
	END TRY
	BEGIN CATCH
	exec  @v_logStatus = LogFailed 21,@v_scriptName
	RAISERROR('Block 21 Failed.',16,1)
	RETURN
	END CATCH
	END
exec @v_logStatus = LogUpdate 21,@v_scriptName

exec @v_logStatus = LogInsert 22,@v_scriptName,'INSERT values in WFCabVersionTable for 7.2_ProcessDefTable,7.2_SystemCatalog'	
	BEGIN
	BEGIN TRY
			
		--	IF (OBJECT_ID('Processinstancetable') IS NOT NULL) 
		
		IF NOT EXISTS ( 
			SELECT * 
			FROM WFCabVersionTable
			WHERE cabversion = '7.2_ProcessDefTable'
			)
		BEGIN
			exec  @v_logStatus = LogSkip 22,@v_scriptName
			EXECUTE('INSERT INTO WFCabVersionTable(cabVersion, creationDate, lastModified, Remarks, Status) VALUES (N''7.2_ProcessDefTable'', GETDATE(), GETDATE(), N''7.2_ProcessDefTable'', N''Y'')')
			EXECUTE('INSERT INTO WFCabVersionTable(cabVersion, creationDate, lastModified, Remarks, Status) VALUES (N''7.2_SystemCatalog'', GETDATE(), GETDATE(), N''7.2_SystemCatalog'', N''Y'')')
		END
	END TRY
	BEGIN CATCH
	exec  @v_logStatus = LogFailed 22,@v_scriptName
	RAISERROR('Block 22 Failed.',16,1)
	RETURN
	END CATCH
	END
exec @v_logStatus = LogUpdate 22,@v_scriptName

exec @v_logStatus = LogInsert 23,@v_scriptName,'Adding new column LastModifiedOn in QUEUEDEFTABLE'	
	BEGIN
	BEGIN TRY
		IF NOT EXISTS ( 
			SELECT * FROM sysColumns 
			WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'QUEUEDEFTABLE')
			AND  NAME = 'LastModifiedOn'
			)
		BEGIN
			exec  @v_logStatus = LogSkip 23,@v_scriptName
			EXECUTE('ALTER TABLE QUEUEDEFTABLE ADD LastModifiedOn datetime DEFAULT getdate()')
			PRINT 'Table QUEUEDEFTABLE altered with new Column LastModifiedOn'
		END
	END TRY
	BEGIN CATCH
	exec  @v_logStatus = LogFailed 23,@v_scriptName
	RAISERROR('Block 23 Failed.',16,1)
	RETURN
	END CATCH
	END
exec @v_logStatus = LogUpdate 23,@v_scriptName

exec @v_logStatus = LogInsert 24,@v_scriptName,'Recreating creating TRIGGER WF_USR_DEL on PDBUSER AFTER UPDATE '	
	BEGIN
	BEGIN TRY
			exec  @v_logStatus = LogSkip 24,@v_scriptName
		IF EXISTS(SELECT name from sysobjects where name='WF_USR_DEL')
		BEGIN
			EXECUTE('DROP TRIGGER WF_USR_DEL') 
			PRINT('Trigger dropped WF_USR_DEL')
		END

		EXECUTE(' CREATE TRIGGER WF_USR_DEL 
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
						UPDATE WFInstrumentTable SET AssignedUser = NULL, AssignmentType = ''N'', LockStatus = ''N'' , LockedByName = NULL,LockedTime = NULL , Q_UserId = 0 , QueueName = (SELECT QUEUEDEFTABLE.QueueName FROM QUEUESTREAMTABLE , QUEUEDEFTABLE WHERE  QUEUESTREAMTABLE.QueueID = QUEUEDEFTABLE.QueueID AND StreamID = Q_StreamID AND QUEUESTREAMTABLE.ProcessDefId = WFInstrumentTable.ProcessDefId AND QUEUESTREAMTABLE.ActivityId = WFInstrumentTable.ActivityId ) , QueueType = (SELECT QUEUEDEFTABLE.QueueType FROM QUEUESTREAMTABLE , QUEUEDEFTABLE WHERE QUEUESTREAMTABLE.QueueID = QUEUEDEFTABLE.QueueID AND StreamID = Q_StreamID AND QUEUESTREAMTABLE.ProcessDefId = WFInstrumentTable.ProcessDefId AND QUEUESTREAMTABLE.ActivityId = WFInstrumentTable.ActivityId) , Q_QueueID = (SELECT QueueId FROM QUEUESTREAMTABLE WHERE StreamID = Q_StreamID AND QUEUESTREAMTABLE.ProcessDefId = WFInstrumentTable.ProcessDefId AND QUEUESTREAMTABLE.ActivityId = WFInstrumentTable.ActivityId) WHERE Q_UserId = @Assgnid AND AssignmentType = ''F'' AND RoutingStatus = ''N'' AND LockStatus = ''N''
						DELETE FROM QUEUEUSERTABLE  WHERE UserID = @Assgnid AND Associationtype = 0
						DELETE FROM USERPREFERENCESTABLE WHERE UserID = @Assgnid
						DELETE FROM USERDIVERSIONTABLE WHERE Diverteduserindex = @Assgnid OR AssignedUserindex = @Assgnid
						DELETE FROM USERWORKAUDITTABLE WHERE Userindex = @Assgnid OR Auditoruserindex = @Assgnid
					END				
				END'
		)
		
	END TRY
	BEGIN CATCH
	exec  @v_logStatus = LogFailed 24,@v_scriptName
	RAISERROR('Block 24 Failed.',16,1)
	RETURN
	END CATCH
	END
exec @v_logStatus = LogUpdate 24,@v_scriptName

exec @v_logStatus = LogInsert 25,@v_scriptName,'Droping VIEW where name like WFWorkinProcessView_% ,WFWORKLISTVIEW_%'	
	BEGIN
	BEGIN TRY
			exec  @v_logStatus = LogSkip 25,@v_scriptName
		DECLARE ViewCursor CURSOR For
				select name from sys.views where (name like 'WFWorkinProcessView_%' or name like 'WFWORKLISTVIEW_%')
		OPEN ViewCursor
		FETCH NEXT FROM ViewCursor INTO @ViewName
		WHILE @@FETCH_STATUS = 0
		BEGIN
			EXEC('Drop view '+@ViewName)
			FETCH NEXT FROM ViewCursor INTO @ViewName
		END
		Close ViewCursor
		Deallocate ViewCursor
	END TRY
	BEGIN CATCH
	exec  @v_logStatus = LogFailed 25,@v_scriptName
	RAISERROR('Block 25 Failed.',16,1)
	RETURN
	END CATCH
	END
exec @v_logStatus = LogUpdate 25,@v_scriptName

exec @v_logStatus = LogInsert 26,@v_scriptName,'Creating Index on PROCESSINSTANCEID of WFATTRIBUTEMESSAGETABLE'	
	BEGIN
	BEGIN TRY
			
		-- Message Agent related changes
		IF NOT EXISTS(SELECT * 
					FROM sysObjects 
					WHERE NAME = 'WFATTRIBUTEMESSAGETABLE')
		BEGIN
			exec  @v_logStatus = LogSkip 26,@v_scriptName
			EXECUTE('CREATE TABLE WFATTRIBUTEMESSAGETABLE (
				ProcessDefId		INTEGER		NOT NULL,	
				ProcessInstanceID	NVARCHAR(63)  NOT NULL ,
				WorkItemId 			INT 		NOT NULL ,
				messageId 			INT		identity (1, 1) PRIMARY KEY, 
				message				NTEXT	 	NOT NULL, 
				lockedBy			NVARCHAR(63), 
				status 				NVARCHAR(1)	CHECK (status in (N''N'', N''F'')),
				ActionDateTime		DATETIME	
			)')
			EXECUTE('CREATE INDEX IDX1_WFATTRIBUTEMESSAGETABLE ON WFATTRIBUTEMESSAGETABLE(PROCESSINSTANCEID)')
		END
	END TRY
	BEGIN CATCH
	exec  @v_logStatus = LogFailed 26,@v_scriptName
	RAISERROR('Block 26 Failed.',16,1)
	RETURN
	END CATCH
	END
exec @v_logStatus = LogUpdate 26,@v_scriptName

exec @v_logStatus = LogInsert 27,@v_scriptName,'Altering Column type of column message of WFMessageTable'	
	BEGIN
	BEGIN TRY	
		IF NOT EXISTS(select 1
				from syscolumns syscol, sysobjects sysobj, sys.types systype
				where syscol.id = sysobj.id and syscol.xtype = systype.system_type_id 
				and syscol.name = 'message' and sysobj.name = 'WFMessageTable' and systype.name = 'nvarchar')
		BEGIN
			exec  @v_logStatus = LogSkip 27,@v_scriptName
			EXECUTE('ALTER TABLE WFMessageTable ALTER COLUMN message NVARCHAR(4000)')
			PRINT('Column type of column message of WFMessageTable altered...')
		END
	END TRY
	BEGIN CATCH
	exec  @v_logStatus = LogFailed 27,@v_scriptName
	RAISERROR('Block 27 Failed.',16,1)
	RETURN
	END CATCH
	END
exec @v_logStatus = LogUpdate 27,@v_scriptName

exec @v_logStatus = LogInsert 28,@v_scriptName,'Adding new Column SeqName in WFAutoGenInfoTable'	
	BEGIN
	BEGIN TRY
		IF NOT EXISTS ( 
			SELECT 1 FROM sysColumns 
			WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'WFAutoGenInfoTable')
			AND  NAME = 'SeqName'
			)
		BEGIN
			exec  @v_logStatus = LogSkip 28,@v_scriptName
			EXECUTE('ALTER TABLE WFAutoGenInfoTable ADD SeqName NVARCHAR(30)')
			PRINT 'Table WFAutoGenInfoTable altered with new Column SeqName'
		END
	END TRY
	BEGIN CATCH
	exec  @v_logStatus = LogFailed 28,@v_scriptName
	RAISERROR('Block 28 Failed.',16,1)
	RETURN
	END CATCH
	END
exec @v_logStatus = LogUpdate 28,@v_scriptName

exec @v_logStatus = LogInsert 29,@v_scriptName,'Deleting PS Data from psregisterationtable'	
	BEGIN
	BEGIN TRY
		IF NOT EXISTS(SELECT 1
				FROM psregisterationtable)
		BEGIN
			exec  @v_logStatus = LogSkip 29,@v_scriptName
			EXECUTE('DELETE FROM psregisterationtable WHERE data = ''PROCESS SERVER''')
			PRINT('PS Data from psregisterationtable deleted successfully...')
		END
	END TRY
	BEGIN CATCH
	exec  @v_logStatus = LogFailed 29,@v_scriptName
	RAISERROR('Block 29,@v_scriptName Failed.',16,1)
	RETURN
	END CATCH
	END
exec @v_logStatus = LogUpdate 29,@v_scriptName

exec @v_logStatus = LogInsert 30,@v_scriptName,'Changing PSID Seed value in psregisterationtable'	
	BEGIN
	BEGIN TRY
		
		SELECT @psrIdent = IDENT_CURRENT('psregisterationtable') 
		IF(@psrIdent < 10000000)
		BEGIN
			exec  @v_logStatus = LogSkip 30,@v_scriptName	
			EXECUTE('DBCC CHECKIDENT (''psregisterationtable'', RESEED, 10000000)')
			PRINT('PSID Seed value changed in psregisterationtable...')
		END
	END TRY
	BEGIN CATCH
	exec  @v_logStatus = LogFailed 30,@v_scriptName
	RAISERROR('Block 30 Failed.',16,1)
	RETURN
	END CATCH
	END
exec @v_logStatus = LogUpdate 30,@v_scriptName

exec @v_logStatus = LogInsert 31,@v_scriptName,'Creating table like IDE_RegistrationNumber_ + processdefid from processdeftable'	
	BEGIN
	BEGIN TRY
		exec  @v_logStatus = LogSkip 31,@v_scriptName
		DECLARE REG_NUM_CURSOR CURSOR FOR
			SELECT processdefid, regstartingno+1 AS reg_no FROM processdeftable ORDER BY processdefid;
		OPEN REG_NUM_CURSOR
		FETCH NEXT FROM REG_NUM_CURSOR INTO @ProcessDefId, @RegNo
		WHILE @@FETCH_STATUS = 0
		BEGIN
			SELECT @TableName = 'IDE_RegistrationNumber_' +   CAST(@ProcessDefId AS VARCHAR)
			IF NOT EXISTS ( 
				SELECT id 
				FROM sysObjects 
				WHERE NAME = @TableName
			)
			BEGIN
				EXECUTE('CREATE TABLE '+ @TableName +' (seqId INT IDENTITY ('+ @RegNo +',1))')
				PRINT 'Table ' + @TableName + ' created successfully...'
			END
			FETCH NEXT FROM REG_NUM_CURSOR INTO @ProcessDefId, @RegNo
		END
		CLOSE REG_NUM_CURSOR
		DEALLOCATE REG_NUM_CURSOR
	END TRY
	BEGIN CATCH
	exec  @v_logStatus = LogFailed 31,@v_scriptName
	RAISERROR('Block 31 Failed.',16,1)
	RETURN
	END CATCH
	END
exec @v_logStatus = LogUpdate 31,@v_scriptName

exec @v_logStatus = LogInsert 32,@v_scriptName,'Updating WFVarRelationTable for parentobject column'	
	BEGIN
	BEGIN TRY	
		IF EXISTS(SELECT 1
				FROM WFVarRelationTable
				WHERE parentobject = 'QUEUEDATATABLE')
		BEGIN
			exec  @v_logStatus = LogSkip 32,@v_scriptName
			EXECUTE('UPDATE WFVarRelationTable SET parentobject = ''WFINSTRUMENTTABLE'' WHERE parentobject = ''QUEUEDATATABLE''')
			PRINT('WFVarRelationTable updated for parentobject column...')
		END
	END TRY
	BEGIN CATCH
	exec  @v_logStatus = LogFailed 32,@v_scriptName
	RAISERROR('Block 32 Failed.',16,1)
	RETURN
	END CATCH
	END
exec @v_logStatus = LogUpdate 32,@v_scriptName

exec @v_logStatus = LogInsert 33,@v_scriptName,'Updating wfautogeninfotable for tablename column.'	
	BEGIN
	BEGIN TRY	
		IF EXISTS(SELECT 1
				FROM wfautogeninfotable
				WHERE tablename = 'QUEUEDATATABLE')
		BEGIN
			exec  @v_logStatus = LogSkip 33,@v_scriptName
			EXECUTE('UPDATE wfautogeninfotable SET tablename = ''WFINSTRUMENTTABLE'' WHERE tablename = ''QUEUEDATATABLE''')
			PRINT('wfautogeninfotable updated for tablename column...')
		END
	END TRY
	BEGIN CATCH
	exec  @v_logStatus = LogFailed 33,@v_scriptName
	RAISERROR('Block 33 Failed.',16,1)
	RETURN
	END CATCH
	END
exec @v_logStatus = LogUpdate 33,@v_scriptName

exec @v_logStatus = LogInsert 34,@v_scriptName,'Creating new tables based on record in wfautogeninfotable'	
	BEGIN
	BEGIN TRY
		exec  @v_logStatus = LogSkip 34,@v_scriptName	
		DECLARE CMPLX_MAP_CURSOR CURSOR FOR
			SELECT ParentObject, ForeignKey FROM WFVarRelationTable WHERE fautogen = 'Y' OR rautogen = 'Y';
		OPEN CMPLX_MAP_CURSOR
		FETCH NEXT FROM CMPLX_MAP_CURSOR INTO @ParentObject, @ForeignKey
		WHILE @@FETCH_STATUS = 0
		BEGIN
			SELECT @TableName = 'WFMAPPINGTABLE_' + @ForeignKey
			IF NOT EXISTS ( 
				SELECT id 
				FROM sysObjects 
				WHERE NAME = @TableName
			)
			BEGIN
				SELECT @CurrentSeq = currentseqno+1 FROM wfautogeninfotable WHERE tablename = @ParentObject AND columnname = @ForeignKey
				EXECUTE('CREATE TABLE '+ @TableName +' (seqId INT IDENTITY ('+ @CurrentSeq +',1))')
				PRINT 'Table ' + @TableName + ' created successfully...';
			END
			FETCH NEXT FROM CMPLX_MAP_CURSOR INTO @ParentObject, @ForeignKey
		END
		CLOSE CMPLX_MAP_CURSOR
		DEALLOCATE CMPLX_MAP_CURSOR
	END TRY
	BEGIN CATCH
	exec  @v_logStatus = LogFailed 34,@v_scriptName
	RAISERROR('Block 34 Failed.',16,1)
	RETURN
	END CATCH
	END
exec @v_logStatus = LogUpdate 34,@v_scriptName

exec @v_logStatus = LogInsert 35,@v_scriptName,'Creating Table WFBRMSConnectTable'	
	BEGIN
	BEGIN TRY
			
		-- New tables for BRMS workstep
		IF NOT EXISTS(SELECT * FROM sysObjects WHERE NAME = 'WFBRMSConnectTable')
		BEGIN
			exec  @v_logStatus = LogSkip 35,@v_scriptName
			EXECUTE('create table WFBRMSConnectTable(
					   ConfigName nvarchar(128) NOT NULL,
					   ServerIdentifier integer NOT NULL,
					   ServerHostName nvarchar(128) NOT NULL,
					   ServerPort integer NOT NULL,
					   ServerProtocol nvarchar(32) NOT NULL,
					   URLSuffix nvarchar(32) NOT NULL,
					   UserName nvarchar(128) NULL,
					   Password nvarchar(128) NULL,
					   ProxyEnabled nvarchar(1) NOT NULL,
					   CONSTRAINT pk_WFBRMSConnectTable PRIMARY KEY(ServerIdentifier)
			)')
			PRINT('Table WFBRMSConnectTable created successfully...')
		END
	END TRY
	BEGIN CATCH
	exec  @v_logStatus = LogFailed 35,@v_scriptName
	RAISERROR('Block 35 Failed.',16,1)
	RETURN
	END CATCH
	END
exec @v_logStatus = LogUpdate 35,@v_scriptName

exec @v_logStatus = LogInsert 36,@v_scriptName,'Creating Table WFBRMSRuleSetInfo'	
	BEGIN
	BEGIN TRY
		IF NOT EXISTS(SELECT * FROM sysObjects WHERE NAME = 'WFBRMSRuleSetInfo')
		BEGIN
			exec  @v_logStatus = LogSkip 496,@v_scriptName
			EXECUTE('create table WFBRMSRuleSetInfo(
					   ExtMethodIndex integer NOT NULL,
					   ServerIdentifier integer NOT NULL,
					   RuleSetName nvarchar(128) NOT NULL,
					   VersionNo nvarchar(5) NOT NULL,
					   InvocationMode nvarchar(128) NOT NULL,
					   CONSTRAINT pk_WFBRMSRuleSetInfo PRIMARY KEY(ExtMethodIndex)
			)')
			PRINT('Table WFBRMSRuleSetInfo created successfully...')
		END
	END TRY
	BEGIN CATCH
	exec  @v_logStatus = LogFailed 36,@v_scriptName
	RAISERROR('Block 36 Failed.',16,1)
	RETURN
	END CATCH
	END
exec @v_logStatus = LogUpdate 36,@v_scriptName

exec @v_logStatus = LogInsert 37,@v_scriptName,'Creating Table WFBRMSActivityAssocTable'	
	BEGIN
	BEGIN TRY
		IF NOT EXISTS(SELECT * FROM sysObjects WHERE NAME = 'WFBRMSActivityAssocTable')
		BEGIN
			exec  @v_logStatus = LogSkip 37,@v_scriptName
			EXECUTE('create table WFBRMSActivityAssocTable(
					   ProcessDefId integer NOT NULL,
					   ActivityId integer NOT NULL,
					   ExtMethodIndex integer NOT NULL,
					   OrderId integer NOT NULL,
					   TimeoutDuration integer NOT NULL,
					   CONSTRAINT pk_WFBRMSActivityAssocTable PRIMARY KEY(ProcessDefId,ActivityId,ExtMethodIndex)
			)')
			PRINT('Table WFBRMSActivityAssocTable created successfully...')
		END	
	END TRY
	BEGIN CATCH
	exec  @v_logStatus = LogFailed 37,@v_scriptName
	RAISERROR('Block 37 Failed.',16,1)
	RETURN
	END CATCH
	END
exec @v_logStatus = LogUpdate 37,@v_scriptName

exec @v_logStatus = LogInsert 38,@v_scriptName,'Creating Table WFSYSTEMPROPERTIESTABLE'	
	BEGIN
	BEGIN TRY
		-- WFSYSTEMPROPERTIESTABLE creation
		IF NOT EXISTS(SELECT * FROM sysObjects WHERE NAME = 'WFSYSTEMPROPERTIESTABLE')
		BEGIN
			exec  @v_logStatus = LogSkip 38,@v_scriptName
			EXECUTE('create table WFSYSTEMPROPERTIESTABLE(
						PROPERTYKEY NVARCHAR(255), 
						PROPERTYVALUE NVARCHAR(1000) NOT NULL, 
						PRIMARY KEY (PROPERTYKEY)
			)')
			EXECUTE('INSERT  INTO WFSYSTEMPROPERTIESTABLE(PROPERTYKEY, PROPERTYVALUE) values(''SystemEmailId'',''system_emailid@domain.com'')')
			EXECUTE('INSERT  INTO WFSYSTEMPROPERTIESTABLE(PROPERTYKEY, PROPERTYVALUE) values(''AdminEmailId'',''admin_emailid@domain.com'')')
			PRINT('Table WFSYSTEMPROPERTIESTABLE created successfully...')
		END
	END TRY
	BEGIN CATCH
	exec  @v_logStatus = LogFailed 38,@v_scriptName
	RAISERROR('Block 38 Failed.',16,1)
	RETURN
	END CATCH
	END
exec @v_logStatus = LogUpdate 38,@v_scriptName

exec @v_logStatus = LogInsert 39,@v_scriptName,'Creating Table pmsversioninfo'	
	BEGIN
	BEGIN TRY
		IF NOT EXISTS(SELECT * FROM sysObjects WHERE NAME = 'pmsversioninfo')
		 BEGIN
		 	exec  @v_logStatus = LogSkip 39,@v_scriptName
		  EXECUTE('CREATE TABLE pmsversioninfo(
		   product_acronym varchar(100) not null,
		   label varchar(100) not null,
		   previouslabel varchar(100),
		   updatedon datetime DEFAULT GETDATE()
		)') 
		  
		  PRINT 'Table pmsversioninfo created successfully'
		 END
	END TRY
	BEGIN CATCH
	exec  @v_logStatus = LogFailed 39,@v_scriptName
	RAISERROR('Block 39 Failed.',16,1)
	RETURN
	END CATCH
	END
exec @v_logStatus = LogUpdate 39,@v_scriptName

exec @v_logStatus = LogInsert 40,@v_scriptName,'Inserting value in pmsversioninfo(product_acronym,label)'	
	BEGIN
	BEGIN TRY
		IF NOT EXISTS(SELECT *  
				FROM pmsversioninfo  
				WHERE label = 'LBL_SUP_000_28012015' AND product_acronym='OF'  )
		BEGIN
			exec  @v_logStatus = LogSkip 40,@v_scriptName
			BEGIN TRANSACTION trans
			--date format YYYY/MM/DD
			----INSERT INTO pmsversioninfo(product_acronym,label, previouslabel) VALUES ('OF','LBL_SUP_000_28012015',null)
			EXECUTE('INSERT INTO pmsversioninfo(product_acronym,label) VALUES (''OF'',''LBL_SUP_000_28012015'')')
			COMMIT TRANSACTION trans
		END
	END TRY
	BEGIN CATCH
	exec  @v_logStatus = LogFailed 40,@v_scriptName
	RAISERROR('Block 40 Failed.',16,1)
	RETURN
	END CATCH
	END
exec @v_logStatus = LogUpdate 40,@v_scriptName

exec @v_logStatus = LogInsert 41,@v_scriptName,'Inserting value in WFCabVersionTable for END of Upgrade.sql for Omniflow 10.0'	
	BEGIN
	BEGIN TRY	
		exec  @v_logStatus = LogSkip 41,@v_scriptName
		BEGIN TRANSACTION trans
		EXECUTE('INSERT INTO WFCabVersionTable(cabVersion, creationDate, lastModified, Remarks, Status) VALUES (N''10.2'', GETDATE(), GETDATE(), N''END of Upgrade.sql for Omniflow 10.0'', N''Y'')')
		COMMIT TRANSACTION trans
	END TRY
	BEGIN CATCH
	exec  @v_logStatus = LogFailed 41,@v_scriptName
	RAISERROR('Block 41 Failed.',16,1)
	RETURN
	END CATCH
	END
exec @v_logStatus = LogUpdate 41,@v_scriptName

END

~

PRINT 'Executing procedure Upgrade ........... '
EXEC upgrade
~		

DROP PROCEDURE upgrade

~
