/*_____________________________________________________________________________________________________________________-
		NEWGEN SOFTWARE TECHNOLOGIES LIMITED

	Group						: Genesis
	Product / Project			: iBPS
	Module						: Transaction Server
	File NAME					: Upgrade.sql (MS Sql Server)
	Author						: Kamaljot Singh/Mohnish Chopra/Kirti Wadhwa
	Date written (DD/MM/YYYY)	: 12/08/2016
	Description					: 
_______________________________________________________________________________________________________________________-
			CHANGE HISTORY
_______________________________________________________________________________________________________________________-
Date		Change By		Change Description (Bug No. (If Any))
11/02/2020	Ambuj Tripathi	Bug 90632 - iBPS4.0 based MSSQL Cabinet upgrade failed to iBPS4.0SP1 
27/03/2020	Ravi Ranjan Kumar	Bug 91436 - Webservice Utility does not picking the workitem but workitem is eligible for it
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
SET NOCOUNT ON;
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
	Declare @pkConstraint	VARCHAR(255)
	Declare @nullableVal 	INT
	DECLARE @ActivityCount INT
	DECLARE @ConstraintName1 nvarchar(200)
	Declare  	@vsql         nvarchar(max)
    Declare		@vquery      nvarchar(max)
	Declare    @pmwFlag 	nvarchar(2)
	Declare @cursorMobEnabled as cursor 
	Declare @tempConfigId		int
	Declare @constrnName nvarchar(200)
	declare @ErrMessage 	nvarchar(200)
	DECLARE @V_TRAN_STATUS NVARCHAR(200)
	/*............................................ Adding new Table .............................................*/
	/* Added from Upgrade01_OF10_3 starts*/
	Set NOCOUNT ON
	
	Set @pmwFlag = 'N'
	IF EXISTS (SELECT * FROM SYSObjects 
			WHERE NAME = 'PMWPRocessDefTable' 
			AND xType = 'U')
	BEGIN
		Set @pmwFlag = 'Y'
	END

	BEGIN
		BEGIN TRY
			IF NOT EXISTS ( SELECT * FROM SYSObjects WHERE NAME = 'WFUpgradeLoggingTable' AND xType = 'U' )
			BEGIN
				EXECUTE(' 
					CREATE TABLE WFUpgradeLoggingTable(
					logdetails	NVARCHAR(2000)
				)
				')
				PRINT 'Table WFUpgradeLoggingTable created successfully.'
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Table WFUpgradeLoggingTable created successfully.'')')
			END
		END TRY	
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE TABLE WFUpgradeLoggingTable FAILED.'')')
			SELECT @ErrMessage = 'Block 1 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
			IF(@pmwFlag = 'N')
			BEGIN
				IF EXISTS (SELECT * FROM WFSwimlanetable)
				BEGIN
					EXECUTE('Delete from WFSwimlanetable')
					PRINT 'Table WFUpgradeLoggingTable created successfully.'
					EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Delete from WFSwimlanetable'')')
				END
			End
		END TRY	
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Delete from WFSwimlanetable FAILED.'')')
			SELECT @ErrMessage = 'Block 2 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END		
	
	BEGIN
		BEGIN TRY
			IF NOT EXISTS(SELECT 1 from sysobjects where NAME = 'WFWorkListConfigTable')
			BEGIN
				CREATE TABLE WFWorkListConfigTable(	
					QueueId				INT NOT NULL,
					VariableId			INT ,
					AliasId	        	INT,
					ViewCategory		NVARCHAR(2),
					VariableType		NVARCHAR(2),
					DisplayName			NVARCHAR(50),
					MobileDisplay		NVARCHAR(2)
				)
				insert into WFWorkListConfigTable values (0,29,0,'M','S','EntryDateTime','Y')
				insert into WFWorkListConfigTable values (0,31,0,'M','S','ProcessInstanceName','Y')
				insert into WFWorkListConfigTable values (0,32,0,'M','S','CreatedByName','Y')
				insert into WFWorkListConfigTable values (0,37,0,'M','S','InstrumentStatus','Y')
				insert into WFWorkListConfigTable values (0,38,0,'M','S','PriorityLevel','Y')
				insert into WFWorkListConfigTable values (0,46,0,'M','S','LockedByName','Y')
				insert into WFWorkListConfigTable values (0,48,0,'M','S','LockStatus','Y')
				insert into WFWorkListConfigTable values (0,49,0,'M','S','ActivityName','Y')
				insert into WFWorkListConfigTable values (0,52,0,'M','S','ProcessedBy','Y')
				
				PRINT 'Table WFWorkListConfigTable created and updated successfully.'
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Table WFWorkListConfigTable created and updated successfully.'')')
			END
		END TRY	
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE TABLE WFWorkListConfigTable FAILED.'')')
			SELECT @ErrMessage = 'Block 3 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
			
			
	BEGIN
		BEGIN TRY		
			IF NOT EXISTS(SELECT 1 from sysobjects where NAME = 'IBPSUserDomain')
			BEGIN
				CREATE TABLE IBPSUserDomain(
					ORGID NVARCHAR(10) NOT NULL,
					DOMAINID NVARCHAR(10) PRIMARY KEY NOT NULL,
					DOMAIN NVARCHAR(50)  NOT NULL
				)
				PRINT 'Table IBPSUserDomain created successfully.'
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Table IBPSUserDomain created successfully.'')')
			END
		END TRY	
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE TABLE IBPSUserDomain FAILED.'')')
			SELECT @ErrMessage = 'Block 4 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
			IF NOT EXISTS(SELECT 1 from sysobjects where NAME = 'IBPSUserMaster')
			BEGIN
				CREATE TABLE IBPSUserMaster(
					ORGID NVARCHAR(20) NOT NULL,
					MAILID NVARCHAR(50) NOT NULL,
					UDID NVARCHAR(100) NOT NULL,
					USERVALIDATIONFLAG NVARCHAR(1) NULL,
					CONSTRAINT user_master PRIMARY KEY (MAILID, UDID)
				)
				PRINT 'Table IBPSUserMaster created successfully.'
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Table IBPSUserMaster created successfully.'')')
			END
		END TRY	
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE TABLE IBPSUserMaster FAILED.'')')
			SELECT @ErrMessage = 'Block 5 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END		
			
	BEGIN
		BEGIN TRY		
			IF NOT EXISTS(SELECT 1 from sysobjects where NAME = 'IBPSUserVerification')
			BEGIN
				CREATE TABLE IBPSUserVerification(
					MAILID NVARCHAR(50) NOT NULL,
					UDID NVARCHAR(50) NOT NULL,
					VERIFICATIONCODE NVARCHAR(10) NULL,
					VERIFICATIONSTATUS NVARCHAR(10) NULL
				)
				PRINT 'Table IBPSUserVerification created successfully.'
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Table IBPSUserVerification created successfully.'')')
			END
		END TRY	
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE TABLE IBPSUserVerification FAILED.'')')
			SELECT @ErrMessage = 'Block 6 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
			IF NOT EXISTS(SELECT 1 from sysobjects where NAME = 'IBPSUserDomainInfo')
			BEGIN
				CREATE TABLE IBPSUserDomainInfo(
					DOMAINID NVARCHAR(10) NOT NULL,
					USERNAME NVARCHAR(10) NOT NULL,
					UDID NVARCHAR(50)NOT NULL,
					OFSERVERIP NVARCHAR(25)NOT NULL, 
					OFSERVERPORT NVARCHAR(10) NOT NULL,
					OFCABINET NVARCHAR(25) NOT NULL,
					OFCABTYPE NVARCHAR(25)NOT NULL,
					OFAPPSERVERTYPE NVARCHAR(10) NOT NULL,
					OFMWARNAME NVARCHAR(25) NOT NULL,
					BAMSERVERPROTOCOL NVARCHAR(5)  NOT NULL,
					BAMSERVERIP NVARCHAR(25)  NOT NULL,
					BAMSERVERPORT NVARCHAR(10)  NOT NULL,
					FORMSERVERPROTOCOL NVARCHAR(5)  NOT NULL,
					FORMSERVERIP NVARCHAR(25)  NOT NULL,
					FORMSERVERPORT NVARCHAR(10)  NOT NULL,
					CALLBACKSERVERPROTOCOL NVARCHAR(5) NOT NULL, 
					CALLBACKSERVERIP NVARCHAR(25) NOT NULL, 
					CALLBACKSERVERPORT NVARCHAR(10) NOT NULL,
				CONSTRAINT domain_person PRIMARY KEY (DOMAINID,USERNAME,UDID)
				)
				PRINT 'Table IBPSUserDomainInfo created successfully.'
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Table IBPSUserDomainInfo created successfully.'')')
			END
		END TRY	
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE TABLE IBPSUserDomainInfo FAILED.'')')
			SELECT @ErrMessage = 'Block 7 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
			
	BEGIN
		BEGIN TRY
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
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Table WFActivitySequenceTABLE created and updated Successfully.'')')
			END
		END TRY	
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE TABLE WFActivitySequenceTABLE FAILED.'')')
			SELECT @ErrMessage = 'Block 8 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
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
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Table WFMileStoneTable created successfully.'')')
			END
		END TRY	
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE TABLE WFActivitySequenceTABLE FAILED.'')')
			SELECT @ErrMessage = 'Block 9 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
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
				
				PRINT 'Table WFProjectListTable created and updated successfully.'
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Table WFProjectListTable created and updated successfully.'')')
			END
		END TRY	
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE TABLE WFProjectListTable FAILED.'')')
			SELECT @ErrMessage = 'Block 10 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
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
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Table WFEventDetailsTable created successfully.'')')
			END
		END TRY	
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE TABLE WFEventDetailsTable FAILED.'')')
			SELECT @ErrMessage = 'Block 11 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	
	BEGIN
		BEGIN TRY
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
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Table WFRepeatEventTable created successfully.'')')
			END
		END TRY	
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE TABLE WFRepeatEventTable FAILED.'')')
			SELECT @ErrMessage = 'Block 12 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
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
						UserName 		NVARCHAR(255) 	NOT NULL,
						constraint pk_WFOwnerTable PRIMARY KEY (Type,TypeId,ProcessDefId,OwnerOrderId)
					)
				')
				PRINT 'Table WFOwnerTable created successfully.'
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Table WFOwnerTable created successfully.'')')
			END
		END TRY	
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE TABLE WFOwnerTable FAILED.'')')
			SELECT @ErrMessage = 'Block 13 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
		
	BEGIN
		BEGIN TRY	
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
						UserName 		NVARCHAR(255) 	NOT NULL,
						constraint pk_WFConsultantsTable PRIMARY KEY (Type,TypeId,ProcessDefId,ConsultantOrderId)
					)
				')
				PRINT 'Table WFConsultantsTable created successfully.'
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Table WFConsultantsTable created successfully.'')')
			END
		END TRY	
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE TABLE WFConsultantsTable FAILED.'')')
			SELECT @ErrMessage = 'Block 14 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
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
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Table WFSystemTable created successfully.'')')
			END
		END TRY	
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE TABLE WFSystemTable FAILED.'')')
			SELECT @ErrMessage = 'Block 15 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
			
	BEGIN
		BEGIN TRY
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
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Table WFProviderTable created successfully.'')')
			END
		END TRY	
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE TABLE WFProviderTable FAILED.'')')
			SELECT @ErrMessage = 'Block 16 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
			
	BEGIN
		BEGIN TRY
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
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Table WFConsumerTable created successfully.'')')
			END
		END TRY	
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE TABLE WFConsumerTable FAILED.'')')
			SELECT @ErrMessage = 'Block 17 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
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
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Table WFPoolTable created successfully.'')')
			END
		END TRY	
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE TABLE WFPoolTable FAILED.'')')
			SELECT @ErrMessage = 'Block 18 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
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
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Table WFRecordedChats created successfully.'')')
			END
		END TRY	
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE TABLE WFRecordedChats FAILED.'')')
			SELECT @ErrMessage = 'Block 19 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END		
	
	BEGIN
		BEGIN TRY
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
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Table WFRequirementTable created successfully.'')')
			END
		END TRY	
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE TABLE WFRequirementTable FAILED.'')')
			SELECT @ErrMessage = 'Block 20 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
			
			
	BEGIN
		BEGIN TRY		
			
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
						Status 			NVARCHAR(1) DEFAULT ''S'' NOT NULL,
						PRIMARY KEY (ProcessDefId, ActivityId, DocId)		
					)
				')
				PRINT 'Table WFDocBuffer created successfully.'
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Table WFDocBuffer created successfully.'')')
			END
		END TRY	
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE TABLE WFDocBuffer FAILED.'')')
			SELECT @ErrMessage = 'Block 21 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY	
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
						DefaultQueue 	NVARCHAR(1) DEFAULT ''N'',
						PRIMARY KEY (ProcessDefId, SwimLaneId, QueueID)
					)
				')
				PRINT 'Table WFLaneQueueTable created successfully.'
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Table WFLaneQueueTable created successfully.'')')
			END
		END TRY	
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE TABLE WFLaneQueueTable FAILED.'')')
			SELECT @ErrMessage = 'Block 22 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
			
				
			-- NEW TABLE ADDED FOR RIGHT MANAGEMENT
	BEGIN
		BEGIN TRY		
			IF NOT EXISTS (
					SELECT * FROM SYSObjects 
					WHERE NAME = 'MenuListTable' 
					AND xType = 'U'
				)
			BEGIN
				EXECUTE(' 
					CREATE TABLE MenuListTable(
					MenuDefId int IDENTITY (1,1) PRIMARY KEY,
					AppName nvarchar(255) NOT NULL,
					MenuLabel nvarchar(255) NOT NULL,
					MenuName nvarchar(255) NOT NULL	
				)
				')
				
				EXECUTE('INSERT INTO MenuListTable values (''PMWMENU'',''Save Process'',''SAVEPROCESS'')')
				EXECUTE('INSERT INTO MenuListTable values (''PMWMENU'',''Version'',''VERSION'')')
				EXECUTE('INSERT INTO MenuListTable values (''PMWMENU'',''Audit Trail'',''AUDITRAIL'')')
				EXECUTE('INSERT INTO MenuListTable values (''PMWMENU'',''Include Window'',''INCLUDEWINDOW'')')
				EXECUTE('INSERT INTO MenuListTable values (''PMWMENU'',''ToDoList'',''TODOLIST'')')
				EXECUTE('INSERT INTO MenuListTable values (''PMWMENU'',''Documents'',''DOCUMENTS'')')
				EXECUTE('INSERT INTO MenuListTable values (''PMWMENU'',''Catalog Definition'',''CATLOGDEFINATION'')')
				EXECUTE('INSERT INTO MenuListTable values (''PMWMENU'',''Exception'',''EXCEPTION'')')
				EXECUTE('INSERT INTO MenuListTable values (''PMWMENU'',''Trigger'',''TRIGGER'')')
				EXECUTE('INSERT INTO MenuListTable values (''PMWMENU'',''Register Template'',''REGISTERTEMPLATE'')')
				EXECUTE('INSERT INTO MenuListTable values (''PMWMENU'',''Register Window'',''REGISTERWINDOW'')')  
				EXECUTE('INSERT INTO MenuListTable values (''PMWMENU'',''Register Trigger'',''RIGSTERTRIGGER'')')
				EXECUTE('INSERT INTO MenuListTable values (''PMWMENU'',''Constants'',''CONSTANTS'')')
				EXECUTE('INSERT INTO MenuListTable values (''PMWMENU'',''Define Table'',''DEFINETABLE'')')
				EXECUTE('INSERT INTO MenuListTable values (''PMWMENU'',''External Variables'',''EXTERNALVARIABLE'')')
				EXECUTE('INSERT INTO MenuListTable values (''PMWMENU'',''Complex Types'',''COMPLEXTYPES'')')
				EXECUTE('INSERT INTO MenuListTable values (''PMWMENU'',''Queue Variables'',''QUEUEVARIABLES'')')
				EXECUTE('INSERT INTO MenuListTable values (''PMWMENU'',''Search Variables'',''SEARCHVARIABLES'')')  
				EXECUTE('INSERT INTO MenuListTable values (''PMWMENU'',''Create Project'',''CREATEPROJECT'')')
				EXECUTE('INSERT INTO MenuListTable values (''PMWMENU'',''Delete Project'',''DELETEPROJECT'')')
				EXECUTE('INSERT INTO MenuListTable values (''PMWMENU'',''Create Process'',''CREATEPROCESS'')')
				EXECUTE('INSERT INTO MenuListTable values (''PMWMENU'',''Delete Process'',''DELETEPROCESS'')')
				EXECUTE('INSERT INTO MenuListTable values (''PMWMENU'',''Register Process'',''REGISTERPROCESS'')')
				EXECUTE('INSERT INTO MenuListTable values (''PMWMENU'',''Import Process'',''IMPORTPROCESS'')')
				EXECUTE('INSERT INTO MenuListTable values (''PMWMENU'',''Export Process'',''EXPORTPROCESS'')')
				EXECUTE('INSERT INTO MenuListTable values (''PMWMENU'',''Report Generation'',''REPORTGENERATION'')')
				EXECUTE('INSERT INTO MenuListTable values (''PMWMENU'',''Create Milestone'',''CREATEMILESTONE'')') 
				EXECUTE('INSERT INTO MenuListTable values (''PMWMENU'',''Delete Milestone'',''DELETEMILESTONE'')')
				EXECUTE('INSERT INTO MenuListTable values (''PMWMENU'',''Modify Milestone'',''MODIFYMILESTONE'')')
				EXECUTE('INSERT INTO MenuListTable values (''PMWMENU'',''Add Activity'',''ADDACTIVITY'')')
				EXECUTE('INSERT INTO MenuListTable values (''PMWMENU'',''Create SwimLane'',''CREATESWIMLANE'')')
				EXECUTE('INSERT INTO MenuListTable values (''PMWMENU'',''Delete SwimLane'',''DELETESWIMLANE'')')  
				EXECUTE('INSERT INTO MenuListTable values (''PMWMENU'',''Modify SwimLane'',''MODIFYSWIMLANE'')')
				EXECUTE('INSERT INTO MenuListTable values (''PMWMENU'',''Queue Management'',''QUEUEMANAGEMENT'')')
				EXECUTE('INSERT INTO MenuListTable values (''PMWMENU'',''Delete Activity'',''DELETEACTIVITY'')')
				EXECUTE('INSERT INTO MenuListTable values (''PMWMENU'',''Modify Activity'',''MODIFYACTIVITY'')')
				EXECUTE('INSERT INTO MenuListTable values (''PMWMENU'',''Manage Form'',''MANAGEFORM'')')
				EXECUTE('INSERT INTO MenuListTable values (''PMWMENU'',''Import Business Objects'',''IMPORTBUSINESSOBJECT'')')
				EXECUTE('INSERT INTO MenuListTable values (''PMWMENU'',''View Form'',''VIEWFORM'')')
				EXECUTE('INSERT INTO MenuListTable values (''PMWMENU'',''Maker-Checker'',''MAKERCHECKER'')')
				EXECUTE('INSERT INTO MenuListTable values (''PMWMENU'',''Add Queue'',''ADDQUEUE'')')
				EXECUTE('INSERT INTO MenuListTable values (''PMWMENU'',''Define Variable Alias'',''DEFINEVARALIAS'')')
				
				PRINT 'Table MenuListTable created and updated successfully.'
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Table MenuListTable created and updated Successfully.'')')
			END
		END TRY	
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE and insert in TABLE MenuListTable FAILED.'')')
			SELECT @ErrMessage = 'Block 23 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
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
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Table WFProfileTable created successfully.'')')
			END
		END TRY	
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE WFProfileTable FAILED.'')')
			SELECT @ErrMessage = 'Block 24 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
			
	BEGIN
		BEGIN TRY		
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
				
				EXECUTE('INSERT INTO wfobjectlisttable values (''PRC'',''Process Management'',0,''com.newgen.wf.rightmgmt.WFRightGetProcessList'', ''0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000'', ''Y'')')
				EXECUTE('INSERT INTO wfobjectlisttable values (''QUE'',''Queue Management'',0,''com.newgen.wf.rightmgmt.WFRightGetQueueList'', ''0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000'', ''Y'')')
				EXECUTE('INSERT INTO wfobjectlisttable values (''OTMS'',''Transport Management'',0,'' '',''0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000'', ''N'')')
				
				PRINT 'Table WFObjectListTable created and updated successfully.'
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Table WFObjectListTable created and updated successfully.'')')
			END
		END TRY	
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE WFObjectListTable FAILED.'')')
			SELECT @ErrMessage = 'Block 25 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
			
	BEGIN
		BEGIN TRY		
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
				EXECUTE('INSERT INTO wfassignablerightstable VALUES (3,''T'',''Transport Request Id'', 1)')
				
				PRINT 'Table WFAssignableRightsTable created and updated successfully.'
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Table WFAssignableRightsTable created and updated Successfully.'')')
			END
		END TRY	
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE wfassignablerightstable and insert FAILED.'')')
			SELECT @ErrMessage = 'Block 26 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
			
	BEGIN
		BEGIN TRY		
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
				
				EXECUTE('INSERT INTO WFProfileObjTypeTable(UserId, AssociationType ,ObjectTypeId,RightString, Filter)
				Values(3,0,2,''1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111'',null)')
				
				PRINT 'Table WFProfileObjTypeTable created and updated successfully.'
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Table WFProfileObjTypeTable created and updated successfully.'')')
			END	
		END TRY	
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE WFProfileObjTypeTable and insert FAILED.'')')
			SELECT @ErrMessage = 'Block 27 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
			
			
	BEGIN
		BEGIN TRY		
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
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Table WFUserObjAssocTable created successfully.'')')			
			END
		END TRY	
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE WFUserObjAssocTable FAILED.'')')
			SELECT @ErrMessage = 'Block 28 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
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
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Table WFMsgAFTable created successfully.'')')
			END
		END TRY	
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE WFMsgAFTable FAILED.'')')
			SELECT @ErrMessage = 'Block 29 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
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
				
				EXECUTE('INSERT INTO wffilterlisttable VALUES (1,''Process Name'',''ProcessName'')')
				EXECUTE('INSERT INTO wffilterlisttable VALUES (2,''Queue Name'',''QueueName'')')
				
				PRINT 'Table WFFilterListTable created and updated successfully.'
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Table WFFilterListTable created and updated Successfully.'')')
			END
		END TRY	
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE wffilterlisttable FAILED.'')')
			SELECT @ErrMessage = 'Block 30 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
			
			
			
			/* Creating processDefId identity on processDefTable */
	BEGIN
		BEGIN TRY		
			IF NOT EXISTS ( SELECT * FROM WFCabVersionTable 
				where cabVersion = 'iBPS_3.0')	
			BEGIN
				
				IF NOT EXISTS ( SELECT * FROM sysColumns 
					WHERE 
					id = (SELECT id FROM sysObjects WHERE NAME = 'PROCESSDEFTABLE')
					AND  NAME = 'ProcessType'
					)
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
					EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Enter identity creation on processdeftable'')')
					
					
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
						TATCalFlag		       NVarChar(1)	NULL,
						Description 		   NTEXT,
						CreatedBy			   NVARCHAR(255),
						LastModifiedBy		   NVARCHAR(255),
						ProcessShared		   NCHAR(1),
						ProjectId 			   INT NULL,
						Cost 				   Numeric(15,2),
						Duration			   NVARCHAR(255),
						FormViewerApp		   NCHAR(1) NOT NULL DEFAULT N''J'',
						ProcessType			   NVARCHAR(255) NOT NULL DEFAULT N''S''
					)')
					
					SET IDENTITY_INSERT TEMPPROCESSDEFTABLE ON
					
					DECLARE cur_processtab CURSOR FOR  
					select processdefid  from PROCESSDEFTABLE order by ProcessDefId
					OPEN cur_processtab
					FETCH NEXT FROM cur_processtab INTO @ProcessDefId
					WHILE @@FETCH_STATUS = 0 
					BEGIN
						
		
						EXECUTE('INSERT INTO TEMPPROCESSDEFTABLE(ProcessDefId,VersionNo,ProcessName,ProcessState,RegPrefix,RegSuffix,RegStartingNo,ProcessTurnAroundTime,RegSeqLength,CreatedOn,LastModifiedOn,WSFont,CommentsFont,CommentsColor,Backcolor,TATCalFlag,
						Description,CreatedBy,LastModifiedBy,ProcessShared,ProjectId,Cost,Duration,FormViewerApp,ProcessType) 
						SELECT ProcessDefId,VersionNo,ProcessName,ProcessState,RegPrefix,RegSuffix,RegStartingNo,ProcessTurnAroundTime,RegSeqLength,CreatedOn,LastModifiedOn,WSFont,CommentsFont,CommentsColor,Backcolor,TATCalFlag,
						'' '',''Supervisor'',''Supervisor'',''N'',1, 0.00,'''',''A'',N''S''
						FROM PROCESSDEFTABLE WHERE ProcessDefId = '+@ProcessDefId)
						FETCH NEXT FROM cur_processtab INTO @ProcessDefId
					END
					CLOSE cur_processtab   
					DEALLOCATE cur_processtab
					
					SET IDENTITY_INSERT TEMPPROCESSDEFTABLE OFF
					
					EXECUTE('alter table TEMPPROCESSDEFTABLE add PRIMARY KEY (ProcessDefId,VersionNo)')
					EXECUTE('exec sp_rename ''PROCESSDEFTABLE'' , ''TEMP_PROCESSDEFTABLE''')
					EXECUTE('exec sp_rename ''TEMPPROCESSDEFTABLE'' , ''PROCESSDEFTABLE''')
					
					EXECUTE('Insert into WFCabVersionTable(cabVersion,creationDate,lastModified,Remarks,Status) values(''iBPS_3.0'',getdate(),getdate(),''processDefTable for OmniFlow with Identity ProcessDefId'',''Y'')')
					
					PRINT 'Table PROCESSDEFTABLE updated successfully.'
					EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Table PROCESSDEFTABLE updated Successfully.'')')
				END
			END
		END TRY	
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE and insert in TEMPPROCESSDEFTABLE FAILED.'')')
			SELECT @ErrMessage = 'Block 31 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
			
			
			/*	Upgrade for Process Variant support*/
	BEGIN
		BEGIN TRY		
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
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Table WFProcessVariantDefTable created successfully.'')')
			END
		END TRY	
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE WFProcessVariantDefTable FAILED.'')')
			SELECT @ErrMessage = 'Block 32 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
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
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Table WFVariantFieldInfoTable created successfully.'')')
			END
		END TRY	
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE WFVariantFieldInfoTable FAILED.'')')
			SELECT @ErrMessage = 'Block 33 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
			
	BEGIN
		BEGIN TRY
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
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Table WFVariantFieldAssociationTable created successfully.'')')
			END
		END TRY	
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE WFVariantFieldAssociationTable FAILED.'')')
			SELECT @ErrMessage = 'Block 34 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
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
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Table WFVariantFormListenerTable created successfully.'')')
			END
		END TRY	
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE WFVariantFormListenerTable FAILED.'')')
			SELECT @ErrMessage = 'Block 35 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
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
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Table WFVariantFormTable created successfully.'')')
			END
		END TRY	
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE WFVariantFormTable FAILED.'')')
			SELECT @ErrMessage = 'Block 36 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
			
			/*.....................................Case Tables added here ............................................*/
	BEGIN
		BEGIN TRY		
			IF NOT EXISTS (
					SELECT * FROM SYSObjects 
					WHERE NAME = 'WFTaskDefTable' 
					AND xType = 'U'
				)
			BEGIN
				EXECUTE(' 
				CREATE TABLE WFTaskDefTable(
					ProcessDefId integer NOT NULL,
					TaskId integer NOT NULL,
					TaskType integer NOT NULL,
					TaskName nvarchar(100) NOT NULL,
					Description ntext NULL,
					xLeft integer  NULL,
					yTop integer  NULL,
					IsRepeatable nvarchar(1) DEFAULT ''Y'' NOT NULL,
					TurnAroundTime integer  NULL,/*contains duration Id*/
					CreatedOn datetime NOT NULL,
					CreatedBy nvarchar(255) NOT NULL,
					Scope nvarchar(1) NOT NULL,/*P for process Created*/
					Goal nvarchar(1000) NULL,
					Instructions nvarchar(1000) NULL,
					TATCalFlag nvarchar(1) DEFAULT ''N'' NOT NULL,/*contains Y for calenday days else N*/
					Cost numeric(15,2) NULL,
					NotifyEmail nvarchar(1) DEFAULT ''N'' NOT NULL,
					TaskTableFlag nvarchar(1)  DEFAULT ''N'' NOT NULL,
					Primary Key( ProcessDefId,TaskId)
				)
				')
				PRINT 'Table WFTaskDefTable created successfully.'
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Table WFTaskDefTable created successfully.'')')
			END
		END TRY	
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE WFTaskDefTable FAILED.'')')
			SELECT @ErrMessage = 'Block 37 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
			
	BEGIN
		BEGIN TRY
			IF NOT EXISTS (
					SELECT * FROM SYSObjects 
					WHERE NAME = 'WFTaskInterfaceAssocTable' 
					AND xType = 'U'
				)
			BEGIN
				EXECUTE(' 
				CREATE table WFTaskInterfaceAssocTable (
						ProcessDefId INT  NOT NULL , 
						ActivityId INT NOT NULL ,
						TaskId Integer NOT NULL , 
						InterfaceId Integer NOT NULL, 
						InterfaceType NCHAR(1) NOT NULL,
						Attribute NVarchar(2)
					)
				')
				PRINT 'Table WFTaskInterfaceAssocTable created successfully.'
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Table WFTaskInterfaceAssocTable created successfully.'')')
			END
		END TRY	
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE WFTaskInterfaceAssocTable FAILED.'')')
			SELECT @ErrMessage = 'Block 38 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
			
	BEGIN
		BEGIN TRY
			IF NOT EXISTS (
					SELECT * FROM SYSObjects 
					WHERE NAME = 'WFTaskTemplateDefTable' 
					AND xType = 'U'
				)
			BEGIN
				EXECUTE(' 
				CREATE table WFTaskTemplateDefTable (
						ProcessDefId INT NOT NULL ,
						TaskId Integer NOT NULL, 
						TemplateName NVarchar(255) NOT NULL
					)
				')
				PRINT 'Table WFTaskTemplateDefTable created successfully.'
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Table WFTaskTemplateDefTable created successfully.'')')
			END
		END TRY	
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE WFTaskTemplateDefTable FAILED.'')')
			SELECT @ErrMessage = 'Block 39 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
			
	BEGIN
		BEGIN TRY
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
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Table RevisionNoSequence created successfully.'')')
			END
		END TRY	
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE RevisionNoSequence FAILED.'')')
			SELECT @ErrMessage = 'Block 40 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY	
			IF NOT EXISTS (
					SELECT * FROM SYSObjects 
					WHERE NAME = 'WFTaskTemplateFieldDefTable' 
					AND xType = 'U'
				)
			BEGIN
				EXECUTE(' 
				CREATE table WFTaskTemplateFieldDefTable (
						ProcessDefId INT NOT NULL,
						TaskId Integer NOT NULL, 
						TemplateVariableId Integer  NOT NULL,
						TaskVariableName NVarchar(255) NOT NULL, 
						DisplayName NVarchar(255), 
						VariableType 	Integer NOT NULL ,
						OrderId Integer NOT NULL,
						ControlType Integer NOT NULL /*1 for textbox, 2 for text area, 3 for combo*/,
						DBLinking nvarchar(1) default ''N'' NOT NULL
					)
				')
				PRINT 'Table WFTaskTemplateFieldDefTable created successfully.'	
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Table WFTaskTemplateFieldDefTable created successfully.'')')
			END
		END TRY	
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE RevisionNoSequence FAILED.'')')
			SELECT @ErrMessage = 'Block 41 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
			IF NOT EXISTS (
					SELECT * FROM SYSObjects 
					WHERE NAME = 'WFTaskTempControlValues' 
					AND xType = 'U'
				)
			BEGIN
				EXECUTE(' 
				CREATE TABLE WFTaskTempControlValues(
						ProcessDefId Integer NOT NULL,
						TaskId Integer NOT NULL,
						TemplateVariableId Integer NOT NULL,
						ControlValue NVarchar(255) NOT NULL    
					)
				')
				PRINT 'Table WFTaskTempControlValues created successfully.'	
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Table WFTaskTempControlValues created successfully.'')')
			END
		END TRY	
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE WFTaskTempControlValues FAILED.'')')
			SELECT @ErrMessage = 'Block 42 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
			IF NOT EXISTS (
					SELECT * FROM SYSObjects 
					WHERE NAME = 'WFTaskVariableMappingTable' 
					AND xType = 'U'
				)
			BEGIN
				EXECUTE(' 
				CREATE table WFTaskVariableMappingTable(
						ProcessDefId INT NOT NULL, 
						ActivityId INT NOT NULL, 
						TaskId Integer NOT NULL,
						TemplateVariableId Integer NOT NULL, 
						TaskVariableName NVarchar(255) NOT NULL, 
						VariableId Integer NOT NULL, 
						TypeFieldId Integer NOT NULL, 
						ReadOnly nvarchar(1) NULL,
						VariableName nvarchar(255) NULL,
						primary key(ProcessDefId,ActivityId,TaskId,TemplateVariableId)
					)
				')
				PRINT 'Table WFTaskVariableMappingTable created successfully.'	
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Table WFTaskVariableMappingTable created successfully.'')')
			END
		END TRY	
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE WFTaskVariableMappingTable FAILED.'')')
			SELECT @ErrMessage = 'Block 43 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
			IF NOT EXISTS (
					SELECT * FROM SYSObjects 
					WHERE NAME = 'WFTaskRulePreConditionTable' 
					AND xType = 'U'
				)
			BEGIN
				EXECUTE(' 
				create table WFTaskRulePreConditionTable(
						ProcessDefId INT NOT NULL,
						ActivityId INT NOT NULL,
						TaskId Integer NOT NULL,
						RuleType NCHAR(1) NOT NULL,
						RuleOrderId Integer NOT NULL,
						RuleId Integer NOT NULL,
						ConditionOrderId Integer NOT NULL,
						Param1 NVarchar(50) NOT NULL,
						Type1 NVarchar(1) not null,
						ExtObjId1 Integer null,
						VariableId_1 Integer NOT NULL,
						VarFieldId_1 Integer null,
						Param2 NVarchar(255) ,
						Type2 NVarchar(1) ,
						ExtObjId2 integer null ,
						VariableId_2 integer null,
						VarFieldId_2 integer null,
						Operator integer  ,
						Logicalop integer NOT NULL 
					)
				')
				PRINT 'Table WFTaskRulePreConditionTable created successfully.'	
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Table WFTaskRulePreConditionTable created successfully.'')')
			END
		END TRY	
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE WFTaskVariableMappingTable FAILED.'')')
			SELECT @ErrMessage = 'Block 44 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
			IF NOT EXISTS (
					SELECT * FROM SYSObjects 
					WHERE NAME = 'TaskTemplateLibraryDefTable' 
					AND xType = 'U'
				)
			BEGIN
				EXECUTE(' 
				create TABLE TaskTemplateLibraryDefTable(
						TemplateId integer NOT NULL,
						TemplateName nvarchar(255) Not NULL,
						Description nText NULL,	
						IsRepeatable nvarchar(1) DEFAULT ''Y'' NOT NULL ,		
						Goal nvarchar(1000) NULL,
						Instructions nvarchar(1000) NULL,
						TATCalFlag nvarchar(1) NOT NULL,
						Cost  numeric(15,2) NULL, 
						NotifyEmail nvarchar(1) DEFAULT ''N'' NOT NULL ,
						TATDays int NOT NULL,
						TATHours int NOT NULL,
						TATMinutes int NOT NULL	
					)
				')
				PRINT 'Table TaskTemplateLibraryDefTable created successfully.'	
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Table TaskTemplateLibraryDefTable created successfully.'')')
			END
		END TRY	
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE table TaskTemplateLibraryDefTable FAILED.'')')
			SELECT @ErrMessage = 'Block 45 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END		
	
	BEGIN
		BEGIN TRY
			IF NOT EXISTS (
					SELECT * FROM SYSObjects 
					WHERE NAME = 'TaskTempFieldLibraryDefTable' 
					AND xType = 'U'
				)
			BEGIN
				EXECUTE(' 
				create TABLE TaskTempFieldLibraryDefTable(	
						TemplateId integer NOT NULL,
						TemplateVariableId integer NOT NULL,
						TaskVariableName nvarchar(255) Not NULL,
						DisplayName nvarchar(255) NULL,
						VariableType integer NOT NULL,
						OrderId integer NOT NULL,
						ControlType	integer NOT NULL,
						DBLinking NVARCHAR(1) default ''N'' NOT NULL
					)
				')
				PRINT 'Table TaskTempFieldLibraryDefTable created successfully.'	
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Table TaskTempFieldLibraryDefTable created successfully.'')')
			END
		END TRY	
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE table TaskTemplateLibraryDefTable FAILED.'')')
			SELECT @ErrMessage = 'Block 46 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
			IF NOT EXISTS (
					SELECT * FROM SYSObjects 
					WHERE NAME = 'TaskTempLibraryControlValues' 
					AND xType = 'U'
				)
			BEGIN
				EXECUTE(' 
				create TABLE TaskTempLibraryControlValues(	
						TemplateId integer NOT NULL,
						TemplateVariableId integer NOT NULL,	
						ControlValue nvarchar(255) NOT NULL
					)
				')
				PRINT 'Table TaskTempLibraryControlValues created successfully.'	
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Table TaskTempLibraryControlValues created successfully.'')')
			END
		END TRY	
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE table TaskTempLibraryControlValues FAILED.'')')
			SELECT @ErrMessage = 'Block 47 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
			
	BEGIN
		BEGIN TRY
			IF NOT EXISTS (
					SELECT * FROM SYSObjects 
					WHERE NAME = 'WFTaskFormTable' 
					AND xType = 'U'
				)
			BEGIN
				EXECUTE(' 
				CREATE TABLE WFTaskFormTable (
						ProcessDefId            INT             NOT NULL,
						TaskId                  INT             NOT NULL,
						FormBuffer              NTEXT           NULL,
						DeviceType              NVARCHAR(1)     NOT NULL     DEFAULT ''D'',
						FormHeight              INT             NOT NULL     DEFAULT 100,
						FormWidth               INT             NOT NULL     DEFAULT 100,
						StatusFlag              NVARCHAR(1)        NULL
						CONSTRAINT PK_WFTaskFormTable PRIMARY KEY(ProcessDefID,TaskId)
					) 
				')
				PRINT 'Table WFTaskFormTable created successfully.'	
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Table WFTaskFormTable created successfully.'')')
			END
		END TRY	
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE table WFTaskFormTable FAILED.'')')
			SELECT @ErrMessage = 'Block 48 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
			IF NOT EXISTS (
					SELECT * FROM SYSObjects 
					WHERE NAME = 'TaskTemplateFormDefTable' 
					AND xType = 'U'
				)
			BEGIN
				EXECUTE(' 
				CREATE TABLE TaskTemplateFormDefTable (	
						TemplateId              INT             NOT NULL,		
						FormBuffer              NTEXT           NULL,		
						DeviceType 				nvarchar(1) default ''D''	NOT NULL 	,
						FormHeight 				int 		default 100	NOT NULL 	,
						FormWidth 				int 			default 100	NOT NULL ,
						StatusFlag				nvarchar(1)		NULL,
						UserIndex				int				NOT NULL,
						TemplateName 			nvarchar(255) 	NULL
					)
				')
				PRINT 'Table TaskTemplateFormDefTable created successfully.'	
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Table TaskTemplateFormDefTable created successfully.'')')
			END
		END TRY	
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE table TaskTemplateFormDefTable FAILED.'')')
			SELECT @ErrMessage = 'Block 49 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
		
	BEGIN
		BEGIN TRY		
			IF NOT EXISTS (
					SELECT * FROM SYSObjects 
					WHERE NAME = 'TaskTemplateAdvisorTable' 
					AND xType = 'U'
				)
			BEGIN
				EXECUTE(' 
				create table TaskTemplateAdvisorTable(    
						TemplateId INT NOT NULL,    
						AdvisorOrderId INT NOT NULL,
						UserName  nvarchar(255) NOT NULL,
						constraint PK_TaskTemplateAdvisorTable PRIMARY KEY (TemplateId,AdvisorOrderId)
					)
				')
				PRINT 'Table TaskTemplateAdvisorTable created successfully.'
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Table TaskTemplateAdvisorTable created successfully.'')')		
			END
		END TRY	
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE table TaskTemplateAdvisorTable FAILED.'')')
			SELECT @ErrMessage = 'Block 50 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
			IF NOT EXISTS (
					SELECT * FROM SYSObjects 
					WHERE NAME = 'WFObjectPropertiesTable' 
					AND xType = 'U'
				)
			BEGIN
				EXECUTE(' 
				Create Table WFObjectPropertiesTable (
					ObjectType NVarchar(1),
					ObjectId Integer, 
					PropertyName NVarchar(255),
					PropertyValue NVarchar(1000), 
					Primary Key(ObjectType,ObjectId,PropertyName)
					)
				')
				PRINT 'Table WFObjectPropertiesTable created successfully.'	
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Table WFObjectPropertiesTable created successfully.'')')
			END
		END TRY	
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE table WFObjectPropertiesTable FAILED.'')')
			SELECT @ErrMessage = 'Block 51 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
				/*..................................... Case table ends here ............................................*/
	BEGIN
		BEGIN TRY		
			IF NOT EXISTS (
					SELECT * FROM SYSObjects 
					WHERE NAME = 'WFHoldEventsDefTable' 
					AND xType = 'U'
				)
			BEGIN
				EXECUTE(' 
				CREATE TABLE WFHoldEventsDefTable(	
						ProcessDefId		int 		   NOT NULL,
						ActivityId			int 		   NOT NULL,
						EventId				int			   NOT NULL,
						EventName			NVARCHAR(255)  NOT NULL,
						TriggerName			NVARCHAR(255),
						TargetActId	int,
						TargetActName	NVARCHAR(255),
						CONSTRAINT PK_WFHoldEventsDefTable PRIMARY KEY(ProcessDefId,ActivityId,EventId)
					)
				')
				PRINT 'Table WFHoldEventsDefTable created successfully.'	
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Table WFHoldEventsDefTable created successfully.'')')
			END
		END TRY	
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE table WFHoldEventsDefTable FAILED.'')')
			SELECT @ErrMessage = 'Block 52 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
			
					/*..................................... OMS table starts here ............................................*/
	BEGIN
		BEGIN TRY				
			IF NOT EXISTS (
					SELECT * FROM SYSObjects 
					WHERE NAME = 'WF_OMSConnectInfoTable' 
					AND xType = 'U'
				)
			BEGIN
				EXECUTE(' 
				create TABLE WF_OMSConnectInfoTable(
						ProcessDefId 	int NOT NULL,
						ActivityId 		int NOT NULL,		
						CabinetName     NVARCHAR(255)    NULL,                
						UserId          NVARCHAR(50)     NULL,
						Passwd          NVARCHAR(256)   NULL,                
						AppServerIP		NVARCHAR(15)	NULL,
						AppServerPort	NVARCHAR(5)		NULL,
						AppServerType	NVARCHAR(255)	NULL,
						SecurityFlag	NVARCHAR(1)		NULL
					)
				')
				PRINT 'Table WF_OMSConnectInfoTable created successfully.'	
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Table WF_OMSConnectInfoTable created successfully.'')')
			END
		END TRY	
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE table WF_OMSConnectInfoTable FAILED.'')')
			SELECT @ErrMessage = 'Block 53 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END		
	
	BEGIN
		BEGIN TRY
			IF NOT EXISTS (
					SELECT * FROM SYSObjects 
					WHERE NAME = 'WF_OMSTemplateInfoTable' 
					AND xType = 'U'
				)
			BEGIN
				EXECUTE(' 
				create TABLE WF_OMSTemplateInfoTable(
						ProcessDefId 	int NOT NULL,
						ActivityId 		int NOT NULL,
						ProductName 	nvarchar(255) NOT NULL,
						VersionNo 		nvarchar(3) NOT NULL,
						CommGroupName 	nvarchar(255) NULL,
						CategoryName 	nvarchar(255) NULL,
						ReportName 		nvarchar(255) NULL,
						Description 	nvarchar(255) NULL,	
						InvocationType 	nvarchar(1) NULL,
						TimeOutInterval int NULL,
						DocTypeName		nvarchar(255) NULL,
						CONSTRAINT PK_WFOMSTemplateInfoTable PRIMARY KEY(ProcessDefID,ActivityId,ProductName,VersionNo)
					)
				')
				PRINT 'Table WF_OMSTemplateInfoTable created successfully.'
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Table WF_OMSTemplateInfoTable created successfully.'')')		
			END
		END TRY	
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE table WF_OMSTemplateInfoTable FAILED.'')')
			SELECT @ErrMessage = 'Block 54 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END		
	
	BEGIN
		BEGIN TRY
			IF NOT EXISTS (
					SELECT * FROM SYSObjects 
					WHERE NAME = 'WF_OMSTemplateMappingTable' 
					AND xType = 'U'
				)
			BEGIN
				EXECUTE(' 
				CREATE TABLE WF_OMSTemplateMappingTable(
						ProcessDefId int NOT NULL,
						ActivityId int NOT NULL,
						ProductName nvarchar(255) NOT NULL,
						VersionNo nvarchar(10) NOT NULL,
						MapType nvarchar(2) NOT NULL,
						TemplateVarName nvarchar(255) NULL,
						TemplateVarType int NULL,
						MappedName nvarchar(255) NULL,
						MaxOccurs nvarchar(255) NULL,
						MinOccurs nvarchar(255) NULL,
						VarId int NULL,
						VarFieldId int NULL,
						VarScope nvarchar(255) NULL,
						OrderId		int	
					) 
				')
				PRINT 'Table WF_OMSTemplateMappingTable created successfully.'	
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Table WF_OMSTemplateMappingTable created successfully.'')')
			END
		END TRY	
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE table WF_OMSTemplateMappingTable FAILED.'')')
			SELECT @ErrMessage = 'Block 56 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
			IF NOT EXISTS (
					SELECT * FROM SYSObjects 
					WHERE NAME = 'WF_OMSTemplateMappingTable' 
					AND xType = 'U'
				)
			BEGIN
				EXECUTE(' 
				CREATE TABLE WF_OMSTemplateMappingTable(
						ProcessDefId int NOT NULL,
						ActivityId int NOT NULL,
						ProductName nvarchar(255) NOT NULL,
						VersionNo nvarchar(10) NOT NULL,
						MapType nvarchar(2) NOT NULL,
						TemplateVarName nvarchar(255) NULL,
						TemplateVarType int NULL,
						MappedName nvarchar(255) NULL,
						MaxOccurs nvarchar(255) NULL,
						MinOccurs nvarchar(255) NULL,
						VarId int NULL,
						VarFieldId int NULL,
						VarScope nvarchar(255) NULL,
						OrderId		int	
					) 
				')
				PRINT 'Table WF_OMSTemplateMappingTable created successfully.'	
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Table WF_OMSTemplateMappingTable created successfully.'')')
			END
		END TRY	
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE table WF_OMSTemplateMappingTable FAILED.'')')
			SELECT @ErrMessage = 'Block 57 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
			/*..................................... OMS table ends here ............................................*/
			
			/*......................................New Tables addition by Mohnish starts here.................................*/
	BEGIN
		BEGIN TRY		
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
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Table WFAuditRuleTable created successfully.'')')
			END
		END TRY	
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE table WFAuditRuleTable FAILED.'')')
			SELECT @ErrMessage = 'Block 58 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
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
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Table WFAuditTrackTable created successfully.'')')
			END
		END TRY	
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE table WFAuditTrackTable FAILED.'')')
			SELECT @ErrMessage = 'Block 59 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
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
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Table WFCreateChildWITable created successfully.'')')
			END
		END TRY	
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE table WFCreateChildWITable FAILED.'')')
			SELECT @ErrMessage = 'Block 60 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
			IF NOT EXISTS (
					SELECT * FROM SYSObjects 
					WHERE NAME = 'WFCURRENTROUTELOGTABLE' 
					AND xType = 'U'
				)
			BEGIN
				EXECUTE(' 
					CREATE TABLE WFCURRENTROUTELOGTABLE (
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
						TaskId	INT Default 0,
						SubTaskId INT Default 0
					)
				')
				PRINT 'Table WFCURRENTROUTELOGTABLE created successfully.'	
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Table WFCURRENTROUTELOGTABLE created successfully.'')')
			END
		END TRY	
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE table WFCURRENTROUTELOGTABLE FAILED.'')')
			SELECT @ErrMessage = 'Block 61 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
			IF NOT EXISTS (
					SELECT * FROM SYSObjects 
					WHERE NAME = 'WFHISTORYROUTELOGTABLE' 
					AND xType = 'U'
				)
			BEGIN
				EXECUTE(' 
					CREATE TABLE WFHISTORYROUTELOGTABLE (
						LogId 			BIGINT  		NOT NULL PRIMARY KEY,
						ProcessDefId  		INT 		NOT NULL,
						ActivityId 		INT		NULL ,
						ProcessInstanceId	NVARCHAR(63)	NULL ,
						WorkItemId 		INT		NULL ,
						UserId 			INT	NULL ,
						ActionId 		INT 		NOT NULL ,
						ActionDatetime		DATETIME 	NOT NULL CONSTRAINT DF_WFHRLT_ActDT DEFAULT (CONVERT(DATETIME,getdate(),109)),
						AssociatedFieldId 	INT		NULL ,
						AssociatedFieldName	NVARCHAR (2000) NULL ,
						ActivityName		NVARCHAR(30)	NULL ,
						UserName		NVARCHAR(63)	NULL , 
						NewValue		NVARCHAR (2000)	NULL ,
						AssociatedDateTime	DATETIME 	NULL , 
						QueueId			INT		NULL,
						ProcessVariantId 	INT 		NOT NULL DEFAULT 0,
						TaskId	INT Default 0,
						SubTaskId INT Default 0
					)
				')
				PRINT 'Table WFHISTORYROUTELOGTABLE created successfully.'	
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Table WFHISTORYROUTELOGTABLE created successfully.'')')
			END
		END TRY	
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE table WFCURRENTROUTELOGTABLE FAILED.'')')
			SELECT @ErrMessage = 'Block 62 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
			/*......................................New Tables addition by Mohnish ends here...................................*/
			
			
			/*......................................New Tables addition by Kirti starts here...................................*/
	BEGIN
		BEGIN TRY		
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
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Table CONFLICTINGQUEUEUSERTABLE created successfully.'')')
			END
		END TRY	
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE table CONFLICTINGQUEUEUSERTABLE FAILED.'')')
			SELECT @ErrMessage = 'Block 63 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
 
    BEGIN
		BEGIN TRY
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
				TaskId	    		INT DEFAULT 0 NOT NULL,
				WSLayoutDefinition 	NVARCHAR(4000),
				PRIMARY KEY (ProcessDefId, ActivityId,TaskId)
				)
				')
				PRINT 'Table WFWorkdeskLayoutTable created successfully.'
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Table WFWorkdeskLayoutTable created successfully.'')')
			END
		END TRY	
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE table WFWorkdeskLayoutTable FAILED.'')')
			SELECT @ErrMessage = 'Block 64 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
		
	BEGIN
		BEGIN TRY
			IF NOT EXISTS (
					SELECT * FROM SYSObjects 
					WHERE NAME = 'WFUserSkillCategoryTable' 
					AND xType = 'U'
				)
			BEGIN
				EXECUTE(' 
				CREATE TABLE WFUserSkillCategoryTable (
				CategoryId     INT  IDENTITY (1,1) PRIMARY KEY,
				CategoryName    Nvarchar(256)  NOT NULL ,
				CategoryDefinedBy   INT  NOT NULL ,
				CategoryDefinedOn   DateTime,
				CategoryAvailableForRating  NVARCHAR(1) 
				)
				')
				PRINT 'Table WFUserSkillCategoryTable created successfully.'	
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Table WFUserSkillCategoryTable created successfully.'')')
			END
		END TRY	
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE table WFUserSkillCategoryTable FAILED.'')')
			SELECT @ErrMessage = 'Block 65 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
			IF NOT EXISTS (
					SELECT * FROM SYSObjects 
					WHERE NAME = 'WFUserSkillDefinitionTable' 
					AND xType = 'U'
				)
			BEGIN
				EXECUTE(' 
				CREATE TABLE WFUserSkillDefinitionTable (
				SkillId      INT  IDENTITY (1,1) PRIMARY KEY,
				CategoryId     INT  NOT NULL ,
				SkillName     NVARCHAR(256),
				SkillDescription   Nvarchar(1024),
				SkillDefinedBy    INT  NOT NULL ,
				SkillDefinedOn    DateTime,
				SkillAvailableForRating  NVARCHAR(1) 
				)
				')
				PRINT 'Table WFUserSkillDefinitionTable created successfully.'
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Table WFUserSkillDefinitionTable created successfully.'')')
			END
		END TRY	
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE table WFUserSkillDefinitionTable FAILED.'')')
			SELECT @ErrMessage = 'Block 66 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
		
	BEGIN
		BEGIN TRY
			IF NOT EXISTS (
					SELECT * FROM SYSObjects 
					WHERE NAME = 'WFUserRatingLogTable' 
					AND xType = 'U'
				)
			BEGIN
				EXECUTE(' 
				CREATE TABLE WFUserRatingLogTable (
				RatingLogId     BIGINT  IDENTITY (1,1) ,
				RatingToUser    INT    NOT NULL ,
				RatingByUser    INT    NOT NULL,
				SkillId      INT    NOT NULL,
				Rating      DECIMAL(5,2)  NOT NULL ,
				RatingDateTime    DateTime,
				Remarks       NVARCHAR(1024) ,
				PRIMARY KEY ( RatingToUser,RatingByUser,SkillId )
				)
				')
				PRINT 'Table WFUserRatingLogTable created successfully.'
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Table WFUserRatingLogTable created successfully.'')')
			END
		END TRY	
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE table WFUserRatingLogTable FAILED.'')')
			SELECT @ErrMessage = 'Block 67 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
		
	BEGIN
		BEGIN TRY	
			IF NOT EXISTS (
					SELECT * FROM SYSObjects 
					WHERE NAME = 'WFUserRatingSummaryTable' 
					AND xType = 'U'
				)
			BEGIN
				EXECUTE(' 
				CREATE TABLE WFUserRatingSummaryTable (
				UserId      INT             NOT NULL,
				SkillId      INT    NOT NULL ,
				AverageRating    DECIMAL(5,2) NOT NULL,
				RatingCount     INT NOT NULL,
				PRIMARY KEY (UserId,SkillId )
				)
				')
				PRINT 'Table WFUserRatingSummaryTable created successfully.'
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Table WFUserRatingSummaryTable created successfully.'')')
			END
		END TRY	
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE table WFUserRatingSummaryTable FAILED.'')')
			SELECT @ErrMessage = 'Block 68 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
			IF NOT EXISTS (
					SELECT * FROM SYSObjects 
					WHERE NAME = 'WFRTTaskInterfaceAssocTable' 
					AND xType = 'U'
				)
			BEGIN
				EXECUTE(' 
				create table WFRTTaskInterfaceAssocTable (
				ProcessInstanceId NVarchar(63) NOT NULL,
				WorkItemId  INT NOT NULL,
				ProcessDefId INT  NOT NULL, 
				ActivityId INT NOT NULL,
				TaskId Integer NOT NULL, 
				InterfaceId Integer NOT NULL, 
				InterfaceType NCHAR(1) NOT NULL,
				Attribute NVarchar(2)
				)
				')
				PRINT 'Table WFRTTaskInterfaceAssocTable created successfully.'
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Table WFRTTaskInterfaceAssocTable created successfully.'')')
			END
		END TRY	
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE table WFRTTaskInterfaceAssocTable FAILED.'')')
			SELECT @ErrMessage = 'Block 69 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
			IF NOT EXISTS (
					SELECT * FROM SYSObjects 
					WHERE NAME = 'RTACTIVITYINTERFACEASSOCTABLE' 
					AND xType = 'U'
				)
			BEGIN
				EXECUTE(' 
				CREATE TABLE RTACTIVITYINTERFACEASSOCTABLE (
				ProcessInstanceId NVarchar(63) NOT NULL,
				WorkItemId  INT NOT NULL,
				ProcessDefId            INT		NOT NULL,
				ActivityId              INT             NOT NULL,
				ActivityName            NVARCHAR(30)    NOT NULL,
				InterfaceElementId      INT             NOT NULL,
				InterfaceType           NVARCHAR(1)     NOT NULL,
				Attribute               NVARCHAR(2)     NULL,
				TriggerName             NVARCHAR(255)   NULL,
				ProcessVariantId 		INT 			NOT NULL DEFAULT 0
				)
				')
				PRINT 'Table RTACTIVITYINTERFACEASSOCTABLE created successfully.'	
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Table RTACTIVITYINTERFACEASSOCTABLE created successfully.'')')
			END
		END TRY	
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE table RTACTIVITYINTERFACEASSOCTABLE FAILED.'')')
			SELECT @ErrMessage = 'Block 70 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
			IF NOT EXISTS (
					SELECT * FROM SYSObjects 
					WHERE NAME = 'WFApprovalTaskDataTable' 
					AND xType = 'U'
				)
			BEGIN
				EXECUTE(' 
					create table WFApprovalTaskDataTable(
					ProcessInstanceId NVarchar(63) NOT NULL,
					WorkItemId INT NOT NULL, 
					ProcessDefId INT  NOT NULL, 
					ActivityId INT NOT NULL,
					TaskId Integer NOT NULL,
					Decision NVarchar(100) , 
					Decision_By NVarchar(255), 
					Decision_Date	DATETIME, 
					Comments NVarchar(255),
					SubTaskId INT
					)
				')
				PRINT 'Table WFApprovalTaskDataTable created successfully.'
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Table WFApprovalTaskDataTable created successfully.'')')
			END
		END TRY	
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE table WFApprovalTaskDataTable FAILED.'')')
			SELECT @ErrMessage = 'Block 71 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
			IF NOT EXISTS (
					SELECT * FROM SYSObjects 
					WHERE NAME = 'WFMeetingTaskDataTable' 
					AND xType = 'U'
				)
			BEGIN
				EXECUTE(' 
					create table WFMeetingTaskDataTable(
					ProcessInstanceId NVarchar(63) NOT NULL,
					WorkItemId INT NOT NULL, 
					ProcessDefId INT  NOT NULL, 
					ActivityId INT NOT NULL,
					TaskId Integer NOT NULL,
					Venue NVarchar(255), 
					ParticipantList NVarchar(1000), 
					Purpose	NVarchar(255),
					InitiatedBy NVarchar(255),
					Comments NVarchar(255),
					SubTaskId INT
					)
				')
				PRINT 'Table WFMeetingTaskDataTable created successfully.'
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Table WFMeetingTaskDataTable created successfully.'')')
			END
		END TRY	
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE table WFMeetingTaskDataTable FAILED.'')')
			SELECT @ErrMessage = 'Block 72 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
			IF NOT EXISTS (
					SELECT * FROM SYSObjects 
					WHERE NAME = 'WFTaskStatusTable' 
					AND xType = 'U'
				)
			BEGIN
				EXECUTE(' 
					create table WFTaskStatusTable(
					ProcessInstanceId NVarchar(63) NOT NULL,
					WorkItemId INT NOT NULL,
					ProcessDefId INT NOT NULL,
					ActivityId INT NOT NULL,
					TaskId Integer NOT NULL,
					SubTaskId  Integer NOT NULL,
					TaskStatus integer NOT NULL,
					AssignedBy varchar(63) NOT NULL,
					AssignedTo varchar(63) NULL,
					Instructions varchar(2000) NULL,
					ActionDateTime DATETIME NOT NULL,
					DueDate DATETIME,
					Priority  INT, /* 0 for Low , 1 for MEDIUM , 2 for High*/
					ShowCaseVisual	varchar(1) default ''N'' NOT NULL,
					ReadFlag varchar(1) default ''N'' NOT NULL,
					CanInitiate	varchar(1) default ''N'' NOT NULL,
					Q_DivertedByUserId INT DEFAULT 0
					CONSTRAINT PK_WFTaskStatusTable PRIMARY KEY(ProcessInstanceId,WorkItemId,ProcessDefID,ActivityId,TaskId,SubTaskId)
					)
				')
				PRINT 'Table WFTaskStatusTable created successfully.'
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Table WFTaskStatusTable created successfully.'')')
			END
		END TRY	
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE table WFTaskStatusTable FAILED.'')')
			SELECT @ErrMessage = 'Block 73 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
			IF NOT EXISTS (
					SELECT * FROM SYSObjects 
					WHERE NAME = 'WFCaseDataVariableTable' 
					AND xType = 'U'
				)
			BEGIN
				EXECUTE(' 
					CREATE TABLE WFCaseDataVariableTable (
					ProcessDefId            INT             NOT NULL,
					ActivityID				INT				NOT NULL,
					VariableId		INT 		NOT NULL ,
					DisplayName			NVARCHAR(2000)		NULL,
					CONSTRAINT PK_WFCaseDataVariableTable PRIMARY KEY(ProcessDefID,ActivityID,VariableId)
					)
				')
				PRINT 'Table WFCaseDataVariableTable created successfully.'	
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Table WFCaseDataVariableTable created successfully.'')')
			END	
		END TRY	
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE table WFCaseDataVariableTable FAILED.'')')
			SELECT @ErrMessage = 'Block 74 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
			IF NOT EXISTS (
					SELECT * FROM SYSObjects 
					WHERE NAME = 'getnerateLogId' 
					AND xType = 'U'
				)
			BEGIN
				EXECUTE(' 
					Create Table getnerateLogId(
					id int identity (1,1)
					)
				')
				PRINT 'Table getnerateLogId created successfully.'
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Table getnerateLogId created successfully.'')')
			END
		END TRY	
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE table getnerateLogId FAILED.'')')
			SELECT @ErrMessage = 'Block 75 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
			
	BEGIN
		BEGIN TRY		
			IF NOT EXISTS (
					SELECT * FROM SYSObjects 
					WHERE NAME = 'WFMigrationLogTable' 
					AND xType = 'U'
				)
			BEGIN
				EXECUTE(' 
					CREATE TABLE WFMigrationLogTable(	
					executionLogId INT, 
					actionDateTime DATETIME, 
					Remarks VARCHAR(MAX) 
					) 
				')
				PRINT 'Table WFMigrationLogTable created successfully.'
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Table WFMigrationLogTable created successfully.'')')
			END
		END TRY	
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE table WFMigrationLogTable FAILED.'')')
			SELECT @ErrMessage = 'Block 76 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
			IF NOT EXISTS (
					SELECT * FROM SYSObjects 
					WHERE NAME = 'WFMetaDataMigrationProgressLog' 
					AND xType = 'U'
				)
			BEGIN
				EXECUTE(' 
					CREATE TABLE WFMetaDataMigrationProgressLog(	
					executionLogId	 INT, 
					actionDateTime 	 DATETIME, 
					ProcessId	     INT,
					tableName		 VARCHAR(1024),
					Remarks		     VARCHAR(MAX) 
					) 
				')
				PRINT 'Table WFMetaDataMigrationProgressLog created successfully.'
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Table WFMetaDataMigrationProgressLog created successfully.'')')
			END
		END TRY	
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE table WFMetaDataMigrationProgressLog FAILED.'')')
			SELECT @ErrMessage = 'Block 77 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
			IF NOT EXISTS (
					SELECT * FROM SYSObjects 
					WHERE NAME = 'WFFailedMetaDataMigrationLog' 
					AND xType = 'U'
				)
			BEGIN
				EXECUTE(' 
					
					CREATE TABLE WFFailedMetaDataMigrationLog(	
					executionLogId	 INT, 
					actionDateTime 	 DATETIME, 
					FailedProcessId	 INT,
					Remarks		     VARCHAR(MAX) 
					) 
				')
					PRINT 'Table WFFailedMetaDataMigrationLog created successfully.'	
					EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Table WFFailedMetaDataMigrationLog created and updated Successfully.'')')
			END
		END TRY	
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE table WFFailedMetaDataMigrationLog FAILED.'')')
			SELECT @ErrMessage = 'Block 78 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
			
	BEGIN
		BEGIN TRY		
			IF NOT EXISTS (
					SELECT * FROM SYSObjects 
					WHERE NAME = 'WFTxnDataMigrationProgressLog' 
					AND xType = 'U'
				)
			BEGIN
				EXECUTE(' 
					Create Table WFTxnDataMigrationProgressLog(	 
					executionLogId 					Int,
					actionDateTime 					DATETIME,
					ProcessId 	   					Int,
					BatchStartProcessInstanceId		NVarchar(256),
					BatchEndProcessInstanceId		NVarchar(256)
					)
				')
					PRINT 'Table WFTxnDataMigrationProgressLog created successfully.'	
					EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Table WFTxnDataMigrationProgressLog created and updated Successfully.'')')
			END
		END TRY	
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE table WFTxnDataMigrationProgressLog FAILED.'')')
			SELECT @ErrMessage = 'Block 79 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
			
	BEGIN
		BEGIN TRY
			IF NOT EXISTS (
					SELECT * FROM SYSObjects 
					WHERE NAME = 'WFFailedTxnDataMigrationLogTable' 
					AND xType = 'U'
				)
			BEGIN
				EXECUTE(' 
					Create Table WFFailedTxnDataMigrationLogTable(	 
					executionLogId 					Int,
					actionDateTime 					DATETIME,
					FailedProcessId 	   			Int,
					ProcessInstanceId				NVarchar(256),
					Remarks							Varchar(max)
					)
				')
					PRINT 'Table WFFailedTxnDataMigrationLogTable created successfully.'	
					EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Table WFFailedTxnDataMigrationLogTable created and updated Successfully.'')')
			END
		END TRY	
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE table WFFailedTxnDataMigrationLogTable FAILED.'')')
			SELECT @ErrMessage = 'Block 80 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
			IF NOT EXISTS (
					SELECT * FROM SYSObjects 
					WHERE NAME = 'WFPartitionStatusTable' 
					AND xType = 'U'
				)
			BEGIN
				EXECUTE(' 
					CREATE TABLE WFPartitionStatusTable(	
					processdefid 		int,
					processvariantid 	int,
					--partitionStatus  	VARCHAR(1)
					) 
				')
					PRINT 'Table WFPartitionStatusTable created successfully.'	
					EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Table WFPartitionStatusTable created and updated Successfully.'')')
			END
		END TRY	
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE table WFPartitionStatusTable FAILED.'')')
			SELECT @ErrMessage = 'Block 81 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
			IF NOT EXISTS (
					SELECT * FROM SYSObjects 
					WHERE NAME = 'WFPSConnection' 
					AND xType = 'U'
				)
			BEGIN
				EXECUTE(' 
					CREATE TABLE WFPSConnection(
					PSId	int	Primary Key NOT NULL,
					SessionId	int	Unique NOT NULL,
					Locale	Nchar(5),	
					PSLoginTime	DATETIME	
					) 
				')
					PRINT 'Table WFPSConnection created successfully.'	
					EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Table WFPSConnection created and updated Successfully.'')')
			END
		END TRY	
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE table WFPSConnection FAILED.'')')
			SELECT @ErrMessage = 'Block 82 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
			
			
			
			
			/*......................................New Tables addition by Kirti ends here...................................*/
			
			/*..................................... End of New Table Addition ............................................*/
				/*......................................New Type Addition by Mohnish .........................................*/
	BEGIN
		BEGIN TRY		
				IF NOT EXISTS (SELECT * FROM sys.types
									WHERE is_table_type = 1 
									AND name = 'Process_Variant_Type'			
						)
							BEGIN
								EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE type Process_Variant_Type Started.'')')
								EXECUTE(' 
									CREATE TYPE Process_Variant_Type AS TABLE
								(
							PROCESSDEFID INT, ProcessVariantId INT
								)
							')
							END
		END TRY	
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE table Process_Variant_Type FAILED.'')')
			SELECT @ErrMessage = 'Block 83 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END					
			/*......................................New Type Addition by Mohnish Ends here.........................................*/
			
			/*................................... Adding new columns in existing Table ...................................*/
	BEGIN
		BEGIN TRY		
			IF EXISTS ( SELECT * FROM sysColumns 
				WHERE 
				id = (SELECT id FROM sysObjects WHERE NAME = 'TEMP_PROCESSDEFTABLE')
				AND  NAME = 'Description'
				)
			BEGIN
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Update PROCESSDEFTABLE Started.'')')
				Execute('UPDATE
					pdt
				SET
					pdt.Description = tpdt.Description
				FROM
					PROCESSDEFTABLE pdt
				INNER JOIN
					TEMP_PROCESSDEFTABLE tpdt
				ON 
					pdt.ProcessDefId = tpdt.ProcessDefId');
				
			END
		END TRY	
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Update PROCESSDEFTABLE FAILED.'')')
			SELECT @ErrMessage = 'Block 84 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
			IF EXISTS ( SELECT * FROM sysColumns 
				WHERE 
				id = (SELECT id FROM sysObjects WHERE NAME = 'TEMP_PROCESSDEFTABLE')
				AND  NAME = 'CreatedBy'
				)
			BEGIN
				Execute('UPDATE
					pdt
				SET
					pdt.CreatedBy = tpdt.CreatedBy
				FROM
					PROCESSDEFTABLE pdt
				INNER JOIN
					TEMP_PROCESSDEFTABLE tpdt
				ON 
					pdt.ProcessDefId = tpdt.ProcessDefId');
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CreatedBy in PROCESSDEFTABLE Updated successfully'')')	
				
			END
		END TRY	
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Update PROCESSDEFTABLE FAILED.'')')
			SELECT @ErrMessage = 'Block 85 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END		
	
	BEGIN
		BEGIN TRY
			IF EXISTS ( SELECT * FROM sysColumns 
				WHERE 
				id = (SELECT id FROM sysObjects WHERE NAME = 'TEMP_PROCESSDEFTABLE')
				AND  NAME = 'LastModifiedBy'
				)
			BEGIN
				Execute('UPDATE
					pdt
				SET
					pdt.LastModifiedBy = tpdt.LastModifiedBy
				FROM
					PROCESSDEFTABLE pdt
				INNER JOIN
					TEMP_PROCESSDEFTABLE tpdt
				ON 
					pdt.ProcessDefId = tpdt.ProcessDefId');
		
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''LastModifiedBy in PROCESSDEFTABLE updated successfully'')')		
			END
		END TRY	
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Update PROCESSDEFTABLE FAILED.'')')
			SELECT @ErrMessage = 'Block 86 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
			
	BEGIN
		BEGIN TRY
			IF EXISTS ( SELECT * FROM sysColumns 
				WHERE 
				id = (SELECT id FROM sysObjects WHERE NAME = 'TEMP_PROCESSDEFTABLE')
				AND  NAME = 'ProcessShared'
				)
			BEGIN
		
				Execute('UPDATE
					pdt
				SET
					pdt.ProcessShared = tpdt.ProcessShared
				FROM
					PROCESSDEFTABLE pdt
				INNER JOIN
					TEMP_PROCESSDEFTABLE tpdt
				ON 
					pdt.ProcessDefId = tpdt.ProcessDefId');
					
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ProcessShared in PROCESSDEFTABLE updated successfully'')')		
			END
		END TRY	
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Update ProcessShared in PROCESSDEFTABLE updated FAILED.'')')
			SELECT @ErrMessage = 'Block 87 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
			
	BEGIN
		BEGIN TRY
			IF EXISTS ( SELECT * FROM sysColumns 
				WHERE 
				id = (SELECT id FROM sysObjects WHERE NAME = 'TEMP_PROCESSDEFTABLE')
				AND  NAME = 'ProjectId'
				)
			BEGIN
		
				Execute('UPDATE
					pdt
				SET
					pdt.ProjectId = tpdt.ProjectId
				FROM
					PROCESSDEFTABLE pdt
				INNER JOIN
					TEMP_PROCESSDEFTABLE tpdt
				ON 
					pdt.ProcessDefId = tpdt.ProcessDefId');	
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ProjectId in PROCESSDEFTABLE updated successfully'')')		
			END
		END TRY	
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Update ProjectId in PROCESSDEFTABLE FAILED.'')')
			SELECT @ErrMessage = 'Block 88 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
			IF EXISTS ( SELECT * FROM sysColumns 
				WHERE 
				id = (SELECT id FROM sysObjects WHERE NAME = 'TEMP_PROCESSDEFTABLE')
				AND  NAME = 'Cost'
				)
			BEGIN
		
				Execute('UPDATE
					pdt
				SET
					pdt.Cost = tpdt.Cost
				FROM
					PROCESSDEFTABLE pdt
				INNER JOIN
					TEMP_PROCESSDEFTABLE tpdt
				ON 
					pdt.ProcessDefId = tpdt.ProcessDefId');	
					
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Cost in PROCESSDEFTABLE updated successfully'')')		
			END
		END TRY	
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Update Cost in PROCESSDEFTABLE FAILED.'')')
			SELECT @ErrMessage = 'Block 89 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
			IF EXISTS ( SELECT * FROM sysColumns 
				WHERE 
				id = (SELECT id FROM sysObjects WHERE NAME = 'TEMP_PROCESSDEFTABLE')
				AND  NAME = 'Duration'
				)
			BEGIN
				Execute('UPDATE
					pdt
				SET
					pdt.Duration = tpdt.Duration
				FROM
					PROCESSDEFTABLE pdt
				INNER JOIN
					TEMP_PROCESSDEFTABLE tpdt
				ON 
					pdt.ProcessDefId = tpdt.ProcessDefId');	
					
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Duration in PROCESSDEFTABLE updated successfully'')')		
			END
		END TRY	
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Update Duration in PROCESSDEFTABLE FAILED.'')')
			SELECT @ErrMessage = 'Block 91 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
			
	BEGIN
		BEGIN TRY		
			IF EXISTS ( SELECT * FROM sysColumns 
				WHERE 
				id = (SELECT id FROM sysObjects WHERE NAME = 'TEMP_PROCESSDEFTABLE')
				AND  NAME = 'FormViewerApp'
				)
			BEGIN
				Execute('UPDATE
					pdt
				SET
					pdt.FormViewerApp = tpdt.FormViewerApp
				FROM
					PROCESSDEFTABLE pdt
				INNER JOIN
					TEMP_PROCESSDEFTABLE tpdt
				ON 
					pdt.ProcessDefId = tpdt.ProcessDefId');	
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''FormViewerApp in PROCESSDEFTABLE updated successfully'')')
			END
		END TRY	
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Update Duration in PROCESSDEFTABLE FAILED.'')')
			SELECT @ErrMessage = 'Block 92 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
			
	BEGIN
		BEGIN TRY		
			IF EXISTS ( SELECT * FROM sysColumns 
				WHERE 
				id = (SELECT id FROM sysObjects WHERE NAME = 'TEMP_PROCESSDEFTABLE')
				AND  NAME = 'ProcessType'
				)
			BEGIN
				Execute('UPDATE
					pdt
				SET
					pdt.ProcessType = tpdt.ProcessType
				FROM
					PROCESSDEFTABLE pdt
				INNER JOIN
					TEMP_PROCESSDEFTABLE tpdt
				ON 
					pdt.ProcessDefId = tpdt.ProcessDefId');	
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ProcessType in PROCESSDEFTABLE updated successfully'')')
			END
		END TRY	
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Update ProcessType in PROCESSDEFTABLE FAILED.'')')
			SELECT @ErrMessage = 'Block 93 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
			IF EXISTS ( SELECT * FROM sysColumns 
				WHERE 
				id = (SELECT id FROM sysObjects WHERE NAME = 'PROCESSDEFTABLE')
				AND  NAME = 'CONTEXT'
				)
			BEGIN
		
				EXECUTE('ALTER TABLE PROCESSDEFTABLE DROP Column CONTEXT')
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CONTEXT in PROCESSDEFTABLE Dropped successfully'')')
			END
		END TRY	
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Drop CONTEXT in PROCESSDEFTABLE  FAILED.'')')
			SELECT @ErrMessage = 'Block 94 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
			
			/* Added from Upgrade01_OF10_3.sql starts */
			
			/* CHANGES FOR MOBILE SUPPORRT BEGINS */
	BEGIN
		BEGIN TRY		
			IF NOT EXISTS(SELECT 1 FROM syscolumns where NAME = 'MobileEnabled' AND id = (SELECT id from sysobjects where NAME = 'ACTIVITYTABLE'))
			BEGIN
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE ACTIVITYTABLE ADD MobileEnabled Started.'')')
				EXECUTE ('ALTER TABLE ACTIVITYTABLE ADD MobileEnabled	Nvarchar(2)')
			END
		END TRY	
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE ACTIVITYTABLE ADD MobileEnabled  FAILED.'')')
			SELECT @ErrMessage = 'Block 95 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
			
			/* WFFORM_TABLE Changes */
	BEGIN
		BEGIN TRY		
			IF NOT EXISTS(SELECT 1 FROM syscolumns where NAME = 'DeviceType' AND id = (SELECT id from sysobjects where NAME = 'WFFORM_TABLE'))
			BEGIN
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFFORM_TABLE ADD DeviceType  STARTED.'')')
				EXECUTE ('ALTER TABLE WFFORM_TABLE ADD DeviceType	NVARCHAR(1) NOT NULL DEFAULT ''D''')
			END
		END TRY	
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFFORM_TABLE ADD DeviceType  FAILED.'')')
			SELECT @ErrMessage = 'Block 96 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
			IF NOT EXISTS(SELECT 1 FROM syscolumns where NAME = 'FormHeight' AND id = (SELECT id from sysobjects where NAME = 'WFFORM_TABLE'))
			BEGIN
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFFORM_TABLE ADD FormHeight started.'')')
				EXECUTE ('ALTER TABLE WFFORM_TABLE ADD FormHeight INT NOT NULL DEFAULT 100')
			END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFFORM_TABLE ADD FormHeight  FAILED.'')')
			SELECT @ErrMessage = 'Block 97 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END		
	
	BEGIN
		BEGIN TRY
			IF NOT EXISTS(SELECT 1 FROM syscolumns where NAME = 'FormWidth' AND id = (SELECT id from sysobjects where NAME = 'WFFORM_TABLE'))
			BEGIN
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFFORM_TABLE ADD FormWidth  STARTED.'')')
				EXECUTE ('ALTER TABLE WFFORM_TABLE ADD FormWidth INT NOT NULL DEFAULT 100')
			END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFFORM_TABLE ADD FormWidth  FAILED.'')')
			SELECT @ErrMessage = 'Block 98 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
			IF NOT EXISTS(SELECT 1 FROM sys.key_constraints where type= 'PK' and parent_object_id = OBJECT_ID('WFFORM_TABLE'))
			BEGIN
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER table WFFORM_TABLE ADD PRIMARY KEY started.'')')
				EXECUTE ('ALTER table WFFORM_TABLE ADD PRIMARY KEY (ProcessDefID,FormId,DeviceType)')
			END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER table WFFORM_TABLE ADD PRIMARY KEY FAILED.'')')
			SELECT @ErrMessage = 'Block 99 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
			
			/* WFFormFragmentTable Changes */
	BEGIN
		BEGIN TRY		
			IF NOT EXISTS(SELECT 1 FROM syscolumns where NAME = 'DeviceType' AND id = (SELECT id from sysobjects where NAME = 'WFFormFragmentTable'))
			BEGIN
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFFormFragmentTable ADD DeviceType started.'')')
				EXECUTE ('ALTER TABLE WFFormFragmentTable ADD DeviceType	NVARCHAR(1) NOT NULL DEFAULT ''D''')
			END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFFormFragmentTable ADD DeviceType FAILED.'')')
			SELECT @ErrMessage = 'Block 100 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
			IF NOT EXISTS(SELECT 1 FROM syscolumns where NAME = 'FormHeight' AND id = (SELECT id from sysobjects where NAME = 'WFFormFragmentTable'))
			BEGIN
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFFormFragmentTable ADD FormHeight started.'')')
				EXECUTE ('ALTER TABLE WFFormFragmentTable ADD FormHeight INT NOT NULL DEFAULT 100')
			END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFFormFragmentTable ADD FormHeight FAILED.'')')
			SELECT @ErrMessage = 'Block 101 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
			IF NOT EXISTS(SELECT 1 FROM syscolumns where NAME = 'FormWidth' AND id = (SELECT id from sysobjects where NAME = 'WFFormFragmentTable'))
			BEGIN
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFFormFragmentTable ADD FormHeight started.'')')
				EXECUTE ('ALTER TABLE WFFormFragmentTable ADD FormWidth INT NOT NULL DEFAULT 100')
			END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFFormFragmentTable ADD FormHeight FAILED.'')')
			SELECT @ErrMessage = 'Block 102 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
			IF NOT EXISTS(SELECT 1 FROM sys.key_constraints where type= 'PK' and parent_object_id = OBJECT_ID('WFFormFragmentTable'))
			BEGIN
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER table WFFormFragmentTable ADD PRIMARY KEY started.'')')
				EXECUTE ('ALTER table WFFormFragmentTable ADD PRIMARY KEY (ProcessDefId,FragmentId)')
			END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER table WFFormFragmentTable ADD PRIMARY KEY FAILED.'')')
			SELECT @ErrMessage = 'Block 103 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
			
			
			/* Adding ThresholdRoutingCount column in ProcessDefTable */
	BEGIN
		BEGIN TRY		
			IF NOT EXISTS (SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'ProcessDefTable') AND  NAME = 'ThresholdRoutingCount')
			BEGIN
				EXECUTE('ALTER TABLE ProcessDefTable ADD ThresholdRoutingCount INTEGER')
				DECLARE cursor1 CURSOR STATIC FOR SELECT ProcessDefId, COUNT(1) FROM ACTIVITYTABLE GROUP BY PROCESSDEFID
				OPEN cursor1
				FETCH NEXT FROM cursor1 INTO @ProcessDefId, @ActivityCount
				WHILE(@@FETCH_STATUS = 0) 
				BEGIN
					SET @ActivityCount = @ActivityCount * 2
					EXECUTE('Update ProcessDefTable set ThresholdRoutingCount = ' + @ActivityCount + ' where ProcessDefId = ' + @ProcessDefId)
					FETCH NEXT FROM cursor1 INTO @ProcessDefId, @ActivityCount
				END
				CLOSE cursor1
				DEALLOCATE cursor1
				PRINT 'ThresholdRoutingCount column added to ProcessDefTable successfully.'
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ThresholdRoutingCount column added to ProcessDefTable successfully.'')')
			END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE ProcessDefTable ADD ThresholdRoutingCount FAILED.'')')
			SELECT @ErrMessage = 'Block 104 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
			
			/* Updating UserDefinedName to RoutingCount for Var_Rec_5 */
	BEGIN
		BEGIN TRY		
			IF EXISTS(SELECT * FROM VARMAPPINGTABLE WHERE UPPER(USERDEFINEDNAME) = 'VAR_REC_5')
			BEGIN
				EXECUTE('UPDATE VARMAPPINGTABLE SET USERDEFINEDNAME = ''RoutingCount'' WHERE UPPER(USERDEFINEDNAME) = ''VAR_REC_5''')
				EXECUTE('ALTER TABLE WFInstrumentTable ADD CONSTRAINT DF_VAR_REC_5 DEFAULT ''0'' FOR VAR_REC_5')
				EXECUTE('UPDATE WFInstrumentTable SET VAR_REC_5 = ''0'' WHERE VAR_REC_5 is NULL OR LEN(VAR_REC_5) <= 0')
				PRINT 'RoutingCount variable mapped with Var_Rec_5 successfully.'
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''RoutingCount variable mapped with Var_Rec_5 successfully.'')')
			END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''UPDATE VARMAPPINGTABLE SET USERDEFINEDNAME  and alter wfinstrumenttable FAILED.'')')
			SELECT @ErrMessage = 'Block 105 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
			
			/*Removing fields from WFPDA_FormTable*/
	BEGIN
		BEGIN TRY		
			IF  EXISTS ( SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'WFPDA_FormTable') 
			AND  NAME = 'DisplayName')
			BEGIN
				EXECUTE('ALTER TABLE WFPDA_FormTable Drop Column DisplayName')		
				PRINT 'Column DisplayName Dropped Successfully from  WFPDA_FormTable'	
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Column DisplayName Dropped Successfully from  WFPDA_FormTable'')')	
			END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFPDA_FormTable Drop Column DisplayName FAILED.'')')
			SELECT @ErrMessage = 'Block 106 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
			IF  EXISTS ( SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'WFPDA_FormTable') 
			AND  NAME = 'ControlType')
			BEGIN
				EXECUTE('ALTER TABLE WFPDA_FormTable Drop Column ControlType')		
				PRINT 'Column ControlType Dropped Successfully from  WFPDA_FormTable'	
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Column ControlType Dropped Successfully from  WFPDA_FormTable'')')
			END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFPDA_FormTable Drop Column ControlType FAILED.'')')
			SELECT @ErrMessage = 'Block 107 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END		
	
	BEGIN
		BEGIN TRY
			IF  EXISTS ( SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'WFPDA_FormTable') 
			AND  NAME = 'MinLen')
			BEGIN
				EXECUTE('ALTER TABLE WFPDA_FormTable Drop Column MinLen')		
				PRINT 'Column MinLen Dropped Successfully from  WFPDA_FormTable'	
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Column MinLen Dropped Successfully from  WFPDA_FormTable'')')
			END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFPDA_FormTable Drop Column MinLen FAILED.'')')
			SELECT @ErrMessage = 'Block 108 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
			IF  EXISTS ( SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'WFPDA_FormTable') 
			AND  NAME = 'MaxLen')
			BEGIN
				EXECUTE('ALTER TABLE WFPDA_FormTable Drop Column MaxLen')		
				PRINT 'Column MaxLen Dropped Successfully from  WFPDA_FormTable'
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Column MaxLen Dropped Successfully from  WFPDA_FormTable'')')		
			END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFPDA_FormTable Drop Column MaxLen FAILED.'')')
			SELECT @ErrMessage = 'Block 108 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
			IF  EXISTS ( SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'WFPDA_FormTable') 
			AND  NAME = 'Validation')
			BEGIN
				EXECUTE('ALTER TABLE WFPDA_FormTable Drop Column Validation')		
				PRINT 'Column Validation Dropped Successfully from  WFPDA_FormTable'	
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Column Validation Dropped Successfully from  WFPDA_FormTable'')')		
			END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFPDA_FormTable Drop Column Validation FAILED.'')')
			SELECT @ErrMessage = 'Block 109 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
			IF  EXISTS ( SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'WFPDA_FormTable') 
			AND  NAME = 'OrderId')
			BEGIN
				EXECUTE('ALTER TABLE WFPDA_FormTable Drop Column OrderId')		
				PRINT 'Column OrderId Dropped Successfully from  WFPDA_FormTable'	
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Column OrderId Dropped Successfully from  WFPDA_FormTable'')')	
			END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFPDA_FormTable Drop Column OrderId FAILED.'')')
			SELECT @ErrMessage = 'Block 110 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
			/*End Of Removing fields from WFPDA_FormTable*/
			/* Added from Upgrade01_OF10_3.sql ends */
	BEGIN
		BEGIN TRY		
			IF NOT EXISTS ( SELECT * FROM sysColumns 
				WHERE 
				id = (SELECT id FROM sysObjects WHERE NAME = 'ACTIVITYTABLE')
				AND  NAME = 'Color'
				)
			BEGIN
				EXECUTE('ALTER TABLE ACTIVITYTABLE ADD Color INT')
				EXECUTE('UPDATE ACTIVITYTABLE SET Color = 1234')
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Color added to ACTIVITYTABLE successfully'')')		
			END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE ACTIVITYTABLE ADD Color FAILED.'')')
			SELECT @ErrMessage = 'Block 111 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
		
	BEGIN
		BEGIN TRY	
			IF NOT EXISTS ( SELECT * FROM sysColumns 
				WHERE 
				id = (SELECT id FROM sysObjects WHERE NAME = 'ACTIVITYTABLE')
				AND  NAME = 'Cost'
				)
			BEGIN
				EXECUTE('ALTER TABLE ACTIVITYTABLE ADD Cost Numeric(15,2)')	
				EXECUTE('UPDATE ACTIVITYTABLE SET Cost = 0.00')		
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Cost added to ACTIVITYTABLE successfully'')')		
			END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE ACTIVITYTABLE ADD Cost FAILED.'')')
			SELECT @ErrMessage = 'Block 1111 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
			IF NOT EXISTS ( SELECT * FROM sysColumns 
				WHERE 
				id = (SELECT id FROM sysObjects WHERE NAME = 'ACTIVITYTABLE')
				AND  NAME = 'Duration'
				)
			BEGIN
				EXECUTE('ALTER TABLE ACTIVITYTABLE ADD Duration NVarchar(255)')
				EXECUTE('UPDATE ACTIVITYTABLE SET Duration = ''0D0H0M''')		
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Duration added to ACTIVITYTABLE successfully'')')				
			END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE ACTIVITYTABLE ADD Duration FAILED.'')')
			SELECT @ErrMessage = 'Block 112 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
		
	BEGIN
		BEGIN TRY	
			IF NOT EXISTS ( SELECT * FROM sysColumns 
			WHERE 
			id = (SELECT id FROM sysObjects WHERE NAME = 'ACTIVITYTABLE')
			AND  NAME = 'SwimLaneId'
			)
			BEGIN
				EXECUTE('ALTER TABLE ACTIVITYTABLE ADD SwimLaneId INT')
				EXECUTE('UPDATE ACTIVITYTABLE SET SwimLaneId = 1')		
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''SwimLaneId added to ACTIVITYTABLE successfully'')')				
			END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE ACTIVITYTABLE ADD SwimLaneId FAILED.'')')
			SELECT @ErrMessage = 'Block 113 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END		
	
	BEGIN
		BEGIN TRY
			IF NOT EXISTS ( SELECT * FROM sysColumns 
				WHERE 
				id = (SELECT id FROM sysObjects WHERE NAME = 'ACTIVITYTABLE')
				AND  NAME = 'DummyStrColumn1'
				)
			BEGIN
				EXECUTE('ALTER TABLE ACTIVITYTABLE ADD DummyStrColumn1 NVarchar(255)')	
				EXECUTE('UPDATE ACTIVITYTABLE SET DummyStrColumn1 = ''''')		
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''DummyStrColumn1 added to ACTIVITYTABLE successfully'')')				
			END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE ACTIVITYTABLE ADD DummyStrColumn1 FAILED.'')')
			SELECT @ErrMessage = 'Block 114 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
			
	BEGIN
		BEGIN TRY
			IF NOT EXISTS ( SELECT * FROM sysColumns 
				WHERE 
				id = (SELECT id FROM sysObjects WHERE NAME = 'ACTIVITYTABLE')
				AND  NAME = 'CustomValidation'
				)
			BEGIN
				EXECUTE('ALTER TABLE ACTIVITYTABLE ADD CustomValidation NTEXT')	
				EXECUTE('UPDATE ACTIVITYTABLE SET CustomValidation = '' ''')		
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CustomValidation added to ACTIVITYTABLE successfully'')')				
			END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE ACTIVITYTABLE ADD CustomValidation FAILED.'')')
			SELECT @ErrMessage = 'Block 115 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
			IF EXISTS ( SELECT * FROM sysColumns 
				WHERE 
				id = (SELECT id FROM sysObjects WHERE NAME = 'ACTIVITYTABLE')
				AND  NAME = 'Description'
				)
			BEGIN
				EXECUTE('ALTER TABLE ACTIVITYTABLE ALTER COLUMN Description NTEXT')	
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Description altered to ACTIVITYTABLE successfully'')')				
			END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE ACTIVITYTABLE ALTER COLUMN Description FAILED.'')')
			SELECT @ErrMessage = 'Block 116 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
			IF NOT EXISTS ( SELECT * FROM sysColumns 
				WHERE 
				id = (SELECT id FROM sysObjects WHERE NAME = 'ACTIVITYTABLE')
				AND  NAME = 'ActivitySubType'
				)
			BEGIN
				EXECUTE('ALTER TABLE ACTIVITYTABLE ADD ActivitySubType INT NULL')
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ActivitySubType added to ACTIVITYTABLE successfully'')')		
			
		
				/* Updating ActivitySubType values in ActivityTable*/
							
					
					Declare @AllowSoapRequest nvarchar(1)
					Declare @ActivityId_actSub int 
					Declare @sql_actSub VARCHAR(MAX)
					Declare @ActivityType_actSub int
					
					Declare @activitysubtype int
					
					
					DECLARE cur_actSub CURSOR FOR  
--					select processdefid,activityid, activitytype, AllowSoapRequest from ACTIVITYTABLE order by ProcessDefId
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
						SET @Sql_actSub = 'Update  ActivityTable set SwimlaneId=1 where ProcessDefId = ' 
							+ CONVERT(VARCHAR(10), @ProcessDefId) +  'and ActivityId = '+ CONVERT(VARCHAR(10),@ActivityId_actSub )
						EXECUTE (@Sql_actSub)
					End
					FETCH NEXT FROM cur_actSub INTO @ProcessDefId,@ActivityId_actSub,@ActivityType_actSub,@AllowSoapRequest
				END
				CLOSE cur_actSub   
				DEALLOCATE cur_actSub 
				/* End of updating activitysubtype*/
			END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE ACTIVITYTABLE ADD ActivitySubType FAILED.'')')
			SELECT @ErrMessage = 'Block 117 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
			
	BEGIN
		BEGIN TRY		
			IF NOT EXISTS ( SELECT * FROM sysColumns 
				WHERE 
				id = (SELECT id FROM sysObjects WHERE NAME = 'PROCESSDEFCOMMENTTABLE')
				AND  NAME = 'AnnotationId'
				)
			BEGIN
				EXECUTE('ALTER TABLE PROCESSDEFCOMMENTTABLE ADD AnnotationId INT')		
				EXECUTE('ALTER TABLE PROCESSDEFCOMMENTTABLE ADD SwimLaneId INT')
				Print 'PROCESSDEFCOMMENTTABLE Altered successfully'	
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''PROCESSDEFCOMMENTTABLE Altered successfully'')')		
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
							+ REPLACE(@Comments, '''', '''''') + ''''
							
						EXECUTE (@Sql_pdfcomment)
						select @counter_comments = @counter_comments + 1  
						set @PreviousProcessDefId_comments = @ProcessDefId 
							
						
					FETCH NEXT FROM cur_processdefcomment INTO @ProcessDefId,@Comments
			
		
					END
				CLOSE cur_processdefcomment   
				DEALLOCATE cur_processdefcomment 
		
			
			END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE PROCESSDEFCOMMENTTABLE ADD AnnotationId and swimlaneid FAILED.'')')
			SELECT @ErrMessage = 'Block 118 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
			
	BEGIN
		BEGIN TRY		
			IF NOT EXISTS ( SELECT * FROM sysColumns 
				WHERE 
				id = (SELECT id FROM sysObjects WHERE NAME = 'WORKSTAGELINKTABLE')
				AND  NAME = 'ConnectionId'
				)
			BEGIN
		
			EXECUTE('ALTER TABLE WORKSTAGELINKTABLE ADD ConnectionId INT NULL')	
				Print 'WORKSTAGELINKTABLE Altered successfully'	
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''WORKSTAGELINKTABLE Altered successfully'')')	
		
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
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WORKSTAGELINKTABLE ADD ConnectionId FAILED.'')')
			SELECT @ErrMessage = 'Block 119 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END		
		
		/* Inserting and Updating values into ExtDBFieldDefinitionTable after adding ExtObjId */
	BEGIN
		BEGIN TRY	
			Print 'Inserting and Updating values into ExtDBFieldDefinitionTable'
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Inserting and Updating values into ExtDBFieldDefinitionTable'')')	
			IF NOT EXISTS ( SELECT * FROM sysColumns 
				WHERE 
				id = (SELECT id FROM sysObjects WHERE NAME = 'EXTDBFIELDDEFINITIONTABLE')
				AND  NAME = 'ExtObjId'
				)
				BEGIN	
					EXECUTE('ALTER TABLE EXTDBFIELDDEFINITIONTABLE ADD ExtObjId INT ')
					EXECUTE('update EXTDBFIELDDEFINITIONTABLE set ExtObjId = 1 where ExtObjId is null')
					EXECUTE('ALTER TABLE EXTDBFIELDDEFINITIONTABLE Alter column ExtObjId INT NOT NULL')
								
					/* updating extobjid in extdbfielddefinitiontable*/
					Declare @FieldName varchar(max)
					Declare @sql_exobj VARCHAR(MAX)
					Declare @extobjid1 int
					DECLARE cur_extobj CURSOR FOR  
					select fieldname, ProcessDefId from extdbfielddefinitiontable
					OPEN cur_extobj
					FETCH NEXT FROM cur_extobj INTO @FieldName,@ProcessDefId
									
					WHILE @@FETCH_STATUS = 0 
					BEGIN
						select @extobjid1 = extobjid from extdbconftable where tablename in (select tbl.table_name
						FROM information_schema.tables tbl INNER JOIN information_schema.columns col 
						ON col.table_name = tbl.table_name 
						WHERE col.COLUMN_NAME = @FieldName and tbl.TABLE_TYPE = 'BASE TABLE') and ProcessDefId = @ProcessDefId
										
						SET @sql_exobj = 'Update  extdbfielddefinitiontable set extobjid= ' 
							+ CONVERT(VARCHAR(10), @extobjid1) + ' where processdefid = '
							+ CONVERT(VARCHAR(10), @ProcessDefId)+ 'and FieldName = '''+@FieldName+ ''''
						EXECUTE (@sql_exobj)
						
						FETCH NEXT FROM cur_extobj INTO @FieldName,@ProcessDefId
					END
					CLOSE cur_extobj   
					DEALLOCATE cur_extobj
				END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE EXTDBFIELDDEFINITIONTABLE ADD ExtObjId FAILED.'')')
			SELECT @ErrMessage = 'Block 120 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	/* End Of updating extobjid in extdbfielddefinitiontable*/
	
	BEGIN
		BEGIN TRY
		IF NOT EXISTS ( SELECT * FROM sysColumns 
						WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'EXTDBFIELDDEFINITIONTABLE') AND  NAME = 'ExtObjId'
						)
		BEGIN
		
			EXECUTE('ALTER TABLE EXTDBFIELDDEFINITIONTABLE ADD ExtObjId INT' )
			EXECUTE('update EXTDBFIELDDEFINITIONTABLE set ExtObjId = 1 where ExtObjId is null')
			EXECUTE('ALTER TABLE EXTDBFIELDDEFINITIONTABLE Alter column ExtObjId INT NOT NULL')
		
			
			Print 'After Inserting and Updating values into ExtDBFieldDefinitionTable'
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''After Inserting and Updating values into ExtDBFieldDefinitionTable'')')	
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
					
								Select @existsFlag = count(*) from ExtDBFieldDefinitionTable where processdefid = @ProcessDefId and FieldName = @colName 
								
							If(@existsFlag = 1)
								BEGIN
									Set @sql_qry= 'update ExtDBFieldDefinitionTable set extObjId = '+convert(varchar(max),@extObjId)+' Where extobjid = 1' 
									EXECUTE(@sql_qry)
								END
							ELSE
								BEGIN
		
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
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE EXTDBFIELDDEFINITIONTABLE ADD ExtObjId FAILED.'')')
			SELECT @ErrMessage = 'Block 121 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END
						
		/* End of modifyng ExtDbFieldDefinitionTable*/				
	BEGIN
		BEGIN TRY
			IF NOT EXISTS ( SELECT * FROM QUEUEDEFTABLE 
				WHERE QueueName = 'SystemArchiveQueue'
				)
				BEGIN
					Declare @archieveQId Int
					EXECUTE('Insert into QueueDefTable (QueueName, QueueType, Comments, OrderBy, SortOrder) values 
					(''SystemArchiveQueue'', ''A'', ''System generated common Archive Queue'', 10, ''A'')')
					set @archieveQId =  @@IDENTITY
					EXECUTE('Insert into WFUserObjAssocTable(Objectid, ObjectTypeId, ProfileId, UserId, AssociationType, AssignedTillDATETIME,AssociationFlag)
					values('+@archieveQId+',2,0,3,0,null,null)')
					print 'Values iserted for SystemArchiveQueue'
					EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Values iserted for SystemArchiveQueue'')')
				END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Values iserted for SystemArchiveQueue FAILED.'')')
			SELECT @ErrMessage = 'Block 122 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END		
	
	BEGIN
		BEGIN TRY
			IF NOT EXISTS ( SELECT * FROM QUEUEDEFTABLE 
				WHERE QueueName = 'SystemPFEQueue'
				)
			BEGIN
				Declare @pfeQId Int
				EXECUTE('Insert into QueueDefTable (QueueName, QueueType, Comments, OrderBy, SortOrder) values 
				(''SystemPFEQueue'', ''A'', ''System generated common PFE Queue'', 10, ''A'')')
				set @pfeQId =  @@IDENTITY
				EXECUTE('Insert into WFUserObjAssocTable(Objectid, ObjectTypeId, ProfileId, UserId, AssociationType, AssignedTillDATETIME,AssociationFlag)
				values('+@pfeQId+',2,0,3,0,null,null)')
				print 'Values iserted for SystemPFEQueue'
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Values iserted for SystemPFEQueue'')')
			END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Values iserted for SystemPFEQueue FAILED.'')')
			SELECT @ErrMessage = 'Block 123 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
			
	BEGIN
		BEGIN TRY
			IF NOT EXISTS ( SELECT * FROM QUEUEDEFTABLE 
				WHERE QueueName = 'SystemSharePointQueue'
				)
			BEGIN
				Declare @sharePtQId Int
				EXECUTE('Insert into QueueDefTable (QueueName, QueueType, Comments, OrderBy, SortOrder) values 
				(''SystemSharePointQueue'', ''A'', ''System generated common PFE Queue'', 10, ''A'')')
				set @sharePtQId =  @@IDENTITY
				EXECUTE('Insert into WFUserObjAssocTable(Objectid, ObjectTypeId, ProfileId, UserId, AssociationType, AssignedTillDATETIME,AssociationFlag)
				values('+@sharePtQId+',2,0,3,0,null,null)')
				print 'Values iserted for SystemSharePointQueue'
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Values iserted for SystemSharePointQueue'')')
			END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Values iserted for SystemSharePointQueue FAILED.'')')
			SELECT @ErrMessage = 'Block 124 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
			
	BEGIN
		BEGIN TRY		
			IF NOT EXISTS ( SELECT * FROM sysColumns 
				WHERE 
				id = (SELECT id FROM sysObjects WHERE NAME = 'QUEUEUSERTABLE')
				AND  NAME = 'RevisionNo'
				)
			BEGIN
				EXECUTE('ALTER TABLE QUEUEUSERTABLE ADD RevisionNo INT')
				PRINT 'ALTER TABLE QUEUEUSERTABLE ADD RevisionNo INT'
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE QUEUEUSERTABLE ADD RevisionNo INT'')')
			/* Updating Revision No. in QueueUserTable*/	
				Declare @sql_revision Varchar(max)
				Declare @QueueId int
				Declare @userid int
				Declare @assocType int
				DECLARE curr_Quser CURSOR FOR  
				SELECT QueueId,UserId,AssociationType from QueueUserTable 
		
				OPEN curr_Quser
		
				FETCH NEXT FROM curr_Quser INTO @QueueId,@userid,@assocType
		
				WHILE (@@FETCH_STATUS = 0) 
				BEGIN
				Insert into RevisionNoSequence values (null)
				Set @sql_revision = 'Update  QueueUserTable set RevisionNo = ' + CONVERT(VARCHAR(10), SCOPE_IDENTITY())+ ' where QueueId =' +CONVERT(VARCHAR(10), @QueueId)+' and UserId = '+CONVERT(VARCHAR(10),@userid)+' and AssociationType = '+CONVERT(VARCHAR(10),@assocType)
				PRINT @sql_revision
				EXECUTE (@sql_revision)
				FETCH NEXT FROM curr_Quser INTO @QueueId,@userid,@assocType
			
				END
			CLOSE curr_Quser   
			DEALLOCATE curr_Quser 
			/*End Cursor*/
			END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE QUEUEUSERTABLE ADD RevisionNo FAILED.'')')
			SELECT @ErrMessage = 'Block 125 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
		
			/* Need to discuss for not null field */
				
			
			/*IF EXISTS ( SELECT * FROM sysColumns 
				WHERE 
				id = (SELECT id FROM sysObjects WHERE NAME = 'ARCHIVETABLE')
				AND  NAME = 'DeleteAudit'
				)
			BEGIN
			
			DECLARE @ConstraintName1 nvarchar(200)
			SELECT @ConstraintName1 = Name FROM SYS.DEFAULT_CONSTRAINTS WHERE PARENT_OBJECT_ID = OBJECT_ID('ARCHIVETABLE') AND PARENT_COLUMN_ID = (SELECT column_id FROM sys.columns WHERE NAME = N'DeleteAudit' AND object_id = OBJECT_ID(N'ARCHIVETABLE'))
				EXECUTE('ALTER TABLE ARCHIVETABLE DROP CONSTRAINT ' + @ConstraintName1)
				EXECUTE('ALTER TABLE ARCHIVETABLE DROP COLUMN DeleteAudit')
				PRINT 'ALTER TABLE ARCHIVETABLE DROP COLUMN DeleteAudit'
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE ARCHIVETABLE DROP COLUMN DeleteAudit'')')
			END*/
	BEGIN
		BEGIN TRY		
			IF NOT EXISTS ( SELECT * FROM sysColumns 
				WHERE 
				id = (SELECT id FROM sysObjects WHERE NAME = 'ARCHIVETABLE')
				AND  NAME = 'DeleteAudit'
				)
			BEGIN
				EXECUTE('ALTER TABLE ARCHIVETABLE ADD DeleteAudit NVARCHAR(1) default ''N'' ')		
				PRINT 'ALTER TABLE ARCHIVETABLE ADD COLUMN DeleteAudit'
		
			END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE QUEUEUSERTABLE ADD RevisionNo FAILED.'')')
			SELECT @ErrMessage = 'Block 126 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
			
	BEGIN
		BEGIN TRY		
			IF  EXISTS ( SELECT * FROM sysColumns 
				WHERE 
				id = (SELECT id FROM sysObjects WHERE NAME = 'ACTIVITYTABLE')
				AND  NAME = 'MobileEnabled'
				)
			BEGIN
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''UPDATE Activitytable SET MobileEnabled = N Started.'')')
				DECLARE @mobileEnabled Varchar(256)
				Declare @ActivityId_new int 
			/* DECLARE cursorMobEnabled CURSOR FAST_FORWARD FOR
				SELECT processdefid,activityid,mobileEnabled FROM  ActivityTable
				OPEN cursorMobEnabled*/
				set @vquery = 'SELECT processdefid,activityid,mobileEnabled FROM  ActivityTable'
				set @vsql = 'set @cursor = cursor forward_only static for ' + @vquery + ' open @cursor;'
				exec sys.sp_executesql
					@vsql
					,N'@cursor cursor output'
					,@cursorMobEnabled output
			
				FETCH NEXT FROM @cursorMobEnabled INTO @ProcessDefId,@ActivityId_new,@mobileEnabled
				WHILE(@@FETCH_STATUS = 0) 
				BEGIN 
					If (@mobileEnabled = '' or @mobileEnabled is NULL)
					BEGIN
					BEGIN TRANSACTION trans
						EXECUTE(' UPDATE Activitytable SET MobileEnabled = ''N'' WHERE ProcessDefId = ' + @ProcessDefId+ ' and ActivityId = '+@ActivityId_new)
					COMMIT TRANSACTION trans
					END
		
					FETCH NEXT FROM @cursorMobEnabled INTO @ProcessDefId,@ActivityId_new,@mobileEnabled
				END
				CLOSE @cursorMobEnabled   
				DEALLOCATE @cursorMobEnabled	
			END
		END TRY		
		BEGIN CATCH
			SELECT @V_TRAN_STATUS = XACT_STATE()
			IF(@V_TRAN_STATUS > 0)
				ROLLBACK
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''UPDATE Activitytable SET MobileEnabled = N FAILED.'')')
			SELECT @ErrMessage = 'Block 127 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
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
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE CHECKOUTPROCESSESTABLE ADD UserId INT'')')
				
			END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE CHECKOUTPROCESSESTABLE ADD ActivityId SwimlaneId UserId FAILED.'')')
			SELECT @ErrMessage = 'Block 128 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
			
	BEGIN
		BEGIN TRY		
			IF NOT EXISTS ( SELECT * FROM sysColumns 
				WHERE 
				id = (SELECT id FROM sysObjects WHERE NAME = 'WFSwimLaneTable')
				AND  NAME = 'PoolId'
				)
			BEGIN
				EXECUTE('ALTER TABLE WFSwimLaneTable ADD PoolId INT')		
				EXECUTE('ALTER TABLE WFSwimLaneTable ADD IndexInPool INT')
				PRINT 'ALTER TABLE WFSwimLaneTable ADD IndexInPool INT'
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFSwimLaneTable ADD IndexInPool INT'')')
			END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE CHECKOUTPROCESSESTABLE ADD ActivityId SwimlaneId UserId FAILED.'')')
			SELECT @ErrMessage = 'Block 129 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
			IF EXISTS ( SELECT * FROM sysColumns 
				WHERE 
				id = (SELECT id FROM sysObjects WHERE NAME = 'WFExportTable')
				AND  NAME = 'DateTimeFormat'
				)
			BEGIN
				EXECUTE('ALTER TABLE WFExportTable DROP COLUMN DateTimeFormat')		
				PRINT 'ALTER TABLE WFExportTable  DROP COLUMN DateTimeFormat'
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFExportTable  DROP COLUMN DateTimeFormat'')')
		
				
			END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFExportTable  DROP COLUMN DateTimeFormat FAILED.'')')
			SELECT @ErrMessage = 'Block 130 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
		
	BEGIN
		BEGIN TRY		
			IF NOT EXISTS ( SELECT * FROM sysColumns 
				WHERE 
				id = (SELECT id FROM sysObjects WHERE NAME = 'WFDataObjectTable')
				AND  NAME = 'SwimLaneId'
				)
			BEGIN
				EXECUTE('ALTER TABLE WFDataObjectTable ADD SwimLaneId INT')
				PRINT 'ALTER TABLE WFDataObjectTable ADD SwimLaneId INT'
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFDataObjectTable ADD SwimLaneId INT'')')
				EXECUTE('UPDATE WFDataObjectTable SET SwimLaneId = 1')
			END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFDataObjectTable ADD SwimLaneId FAILED.'')')
			SELECT @ErrMessage = 'Block 131 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
			
	BEGIN
		BEGIN TRY		
			IF NOT EXISTS ( SELECT * FROM sysColumns 
				WHERE 
				id = (SELECT id FROM sysObjects WHERE NAME = 'WFGroupBoxTable')
				AND  NAME = 'SwimLaneId'
				)
			BEGIN
				EXECUTE('ALTER TABLE WFGroupBoxTable ADD SwimLaneId INT')
				PRINT 'ALTER TABLE WFGroupBoxTable ADD SwimLaneId INT'
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFGroupBoxTable ADD SwimLaneId INT'')')
				EXECUTE('UPDATE WFGroupBoxTable SET SwimLaneId = 1')
			END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFGroupBoxTable ADD SwimLaneId FAILED.'')')
			SELECT @ErrMessage = 'Block 132 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
			
	BEGIN
		BEGIN TRY		
			IF NOT EXISTS ( SELECT * FROM sysColumns 
				WHERE 
				id = (SELECT id FROM sysObjects WHERE NAME = 'INITIATEWORKITEMDEFTABLE')
				AND  NAME = 'ImportedProcessDefId'
				)
			BEGIN
				EXECUTE('ALTER TABLE INITIATEWORKITEMDEFTABLE ADD ImportedProcessDefId INT NULL')
				PRINT 'ALTER TABLE INITIATEWORKITEMDEFTABLE ADD ImportedProcessDefId INT NULL'
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE INITIATEWORKITEMDEFTABLE ADD ImportedProcessDefId INT NULL'')')
				
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
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE INITIATEWORKITEMDEFTABLE ADD ImportedProcessDefId FAILED.'')')
			SELECT @ErrMessage = 'Block 133 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
			
	BEGIN
		BEGIN TRY		
			IF NOT EXISTS ( SELECT * FROM sysColumns 
				WHERE 
				id = (SELECT id FROM sysObjects WHERE NAME = 'IMPORTEDPROCESSDEFTABLE')
				AND  NAME = 'ProcessType'
				)
			BEGIN
				EXECUTE('ALTER TABLE IMPORTEDPROCESSDEFTABLE ADD ProcessType  NVARCHAR(1) NOT NULL DEFAULT (N''R'')')
				PRINT 'ALTER TABLE IMPORTEDPROCESSDEFTABLE ADD ProcessType  NVARCHAR(1) NOT NULL DEFAULT (N''R'')'
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE IMPORTEDPROCESSDEFTABLE ADD ProcessType  NVARCHAR(1) NOT NULL DEFAULT R'')')
			END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE IMPORTEDPROCESSDEFTABLE ADD ProcessType FAILED.'')')
			SELECT @ErrMessage = 'Block 134 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END		
	
	BEGIN
		BEGIN TRY
			IF NOT EXISTS ( SELECT * FROM sysColumns 
				WHERE 
				id = (SELECT id FROM sysObjects WHERE NAME = 'IMPORTEDPROCESSDEFTABLE')
				AND  NAME = 'ImportedProcessDefId'
				)
			BEGIN
				EXECUTE('ALTER TABLE IMPORTEDPROCESSDEFTABLE ADD ImportedProcessDefId INT NULL')
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE IMPORTEDPROCESSDEFTABLE ADD ImportedProcessDefId INT NULL'')')
				
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
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE IMPORTEDPROCESSDEFTABLE ADD ImportedProcessDefId FAILED.'')')
			SELECT @ErrMessage = 'Block 135 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
		
	BEGIN
		BEGIN TRY
			IF NOT EXISTS ( SELECT * FROM sysColumns 
				WHERE 
				id = (SELECT id FROM sysObjects WHERE NAME = 'WFMAILQUEUETABLE')
				AND  NAME = 'zipFlag'
				)
			BEGIN
				EXECUTE('ALTER TABLE WFMAILQUEUETABLE ADD zipFlag nvarchar(1) NULL ')		
				PRINT 'ALTER TABLE WFMAILQUEUETABLE ADD zipFlag nvarchar(1) NULL '
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFMAILQUEUETABLE ADD zipFlag nvarchar(1) NULL'')')
				
			END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE IMPORTEDPROCESSDEFTABLE ADD zipFlag FAILED.'')')
			SELECT @ErrMessage = 'Block 136 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END		
	
	BEGIN
		BEGIN TRY
			IF NOT EXISTS ( SELECT * FROM sysColumns 
				WHERE 
				id = (SELECT id FROM sysObjects WHERE NAME = 'WFAdminLogTable')
				AND  NAME = 'Operation'
				)
			BEGIN
				EXECUTE('ALTER TABLE WFAdminLogTable ADD Operation NVARCHAR(1)')		
				PRINT 'ALTER TABLE WFAdminLogTable ADD Operation NVARCHAR(1)'
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFAdminLogTable ADD Operation NVARCHAR(1)'')')
				
			END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE IMPORTEDPROCESSDEFTABLE ADD zipFlag FAILED.'')')
			SELECT @ErrMessage = 'Block 137 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
			
	BEGIN
		BEGIN TRY		
			IF NOT EXISTS ( SELECT * FROM sysColumns 
				WHERE 
				id = (SELECT id FROM sysObjects WHERE NAME = 'WFAdminLogTable')
				AND  NAME = 'ProfileId'
				)
			BEGIN
				EXECUTE('ALTER TABLE WFAdminLogTable ADD ProfileId INT')		
				PRINT 'ALTER TABLE WFAdminLogTable ADD ProfileId INT'
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFAdminLogTable ADD ProfileId INT'')')
				EXECUTE('UPDATE WFADMINLOGTABLE SET PROFILEID = 0')	
				
			END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFAdminLogTable ADD ProfileId FAILED.'')')
			SELECT @ErrMessage = 'Block 138 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
			
	BEGIN
		BEGIN TRY		
			IF NOT EXISTS ( SELECT * FROM sysColumns 
				WHERE 
				id = (SELECT id FROM sysObjects WHERE NAME = 'WFAdminLogTable')
				AND  NAME = 'ProfileName'
				)
			BEGIN
				EXECUTE('ALTER TABLE WFAdminLogTable ADD ProfileName NVARCHAR(64)')		
				PRINT 'ALTER TABLE WFAdminLogTable ADD ProfileName NVARCHAR(64)'
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFAdminLogTable ADD ProfileName NVARCHAR(64)'')')
				
			END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFAdminLogTable ADD ProfileName FAILED.'')')
			SELECT @ErrMessage = 'Block 139 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
			
	BEGIN
		BEGIN TRY		
			IF NOT EXISTS ( SELECT * FROM sysColumns 
				WHERE 
				id = (SELECT id FROM sysObjects WHERE NAME = 'WFAdminLogTable')
				AND  NAME = 'Property1'
				)
			BEGIN
				EXECUTE('ALTER TABLE WFAdminLogTable ADD Property1 NVARCHAR(64)')		
				PRINT 'ALTER TABLE WFAdminLogTable ADD Property1 NVARCHAR(64)'
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFAdminLogTable ADD Property1 NVARCHAR(64)'')')
				
			END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFAdminLogTable ADD Property1 FAILED.'')')
			SELECT @ErrMessage = 'Block 139 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
			
	BEGIN
		BEGIN TRY
			IF NOT EXISTS ( SELECT * FROM sysColumns WHERE 
				id = (SELECT id FROM sysObjects WHERE NAME = 'WFFORM_TABLE')
				AND  NAME = 'LastModifiedOn'
				)
			BEGIN
				EXECUTE('ALTER TABLE WFFORM_TABLE ADD LastModifiedOn DATETIME')		
				PRINT 'ALTER TABLE WFFORM_TABLE ADD LastModifiedOn DATETIME'
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFFORM_TABLE ADD LastModifiedOn DATETIME'')')
				EXECUTE('UPDATE  WFFORM_TABLE SET LastModifiedOn = GetDate() ')	
			END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFFORM_TABLE ADD LastModifiedOn FAILED.'')')
			SELECT @ErrMessage = 'Block 140 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	

	BEGIN
		BEGIN TRY		
			IF NOT EXISTS ( SELECT * FROM sysColumns WHERE 
				id = (SELECT id FROM sysObjects WHERE NAME = 'WFFormFragmentTable')
				AND  NAME = 'LastModifiedOn'
				)
			BEGIN
				EXECUTE('ALTER TABLE WFFormFragmentTable ADD LastModifiedOn DATETIME')		
				PRINT 'ALTER TABLE WFFormFragmentTable ADD LastModifiedOn DATETIME'
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFFormFragmentTable ADD LastModifiedOn DATETIME'')')
				EXECUTE('UPDATE  WFFormFragmentTable SET LastModifiedOn = GetDate() ')	
			END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFFormFragmentTable ADD LastModifiedOn FAILED.'')')
			SELECT @ErrMessage = 'Block 141 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
			
			/*..............................Adding New columns in existing table by Mohnish..................................*/
	BEGIN
		BEGIN TRY		
			IF NOT EXISTS ( SELECT * FROM sysColumns WHERE 
				id = (SELECT id FROM sysObjects WHERE NAME = 'QUEUEHISTORYTABLE')
				AND  NAME = 'ProcessVariantId'
				)
			BEGIN
				EXECUTE('ALTER TABLE QUEUEHISTORYTABLE ADD ProcessVariantId INT NOT NULL DEFAULT 0')		
				PRINT 'ALTER TABLE QUEUEHISTORYTABLE ADD ProcessVariantId INT NOT NULL DEFAULT 0'
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE QUEUEHISTORYTABLE ADD ProcessVariantId INT NOT NULL DEFAULT 0'')')
			END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE QUEUEHISTORYTABLE ADD ProcessVariantId FAILED.'')')
			SELECT @ErrMessage = 'Block 142 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END		
	
	BEGIN
		BEGIN TRY
			IF NOT EXISTS ( SELECT * FROM sysColumns WHERE 
				id = (SELECT id FROM sysObjects WHERE NAME = 'QUEUEHISTORYTABLE')
				AND  NAME = 'ActivityType'
				)
			BEGIN
				EXECUTE('ALTER TABLE QUEUEHISTORYTABLE ADD ActivityType SmallInt NULL')		
				PRINT 'ALTER TABLE QUEUEHISTORYTABLE ADD ActivityType SmallInt NULL'
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE QUEUEHISTORYTABLE ADD ActivityType SmallInt NULL'')')
				EXECUTE('UPDATE QUEUEHISTORYTABLE SET  QUEUEHISTORYTABLE.ActivityType = ActivityTable.ActivityType
				FROM
				QUEUEHISTORYTABLE 
				INNER JOIN
				ActivityTable  
				ON
				QUEUEHISTORYTABLE.ProcessDefId = ActivityTable.ProcessDefId
				and
				QUEUEHISTORYTABLE.ActivityId = ActivityTable.ActivityId')
				PRINT 'ActivityType of QueueHistoryTable updated'
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ActivityType of QueueHistoryTable updated'')')
				
			END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE QUEUEHISTORYTABLE ADD ActivityType FAILED.'')')
			SELECT @ErrMessage = 'Block 143 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
			IF NOT EXISTS ( SELECT * FROM sysColumns WHERE 
				id = (SELECT id FROM sysObjects WHERE NAME = 'QUEUEHISTORYTABLE')
				AND  NAME = 'lastModifiedTime'
				)
			BEGIN
				EXECUTE('ALTER TABLE QUEUEHISTORYTABLE ADD lastModifiedTime 	DATETIME')		
				PRINT 'ALTER TABLE QUEUEHISTORYTABLE ADD lastModifiedTime 	DATETIME'
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE QUEUEHISTORYTABLE ADD lastModifiedTime 	DATETIME'')')
				EXECUTE('UPDATE  QUEUEHISTORYTABLE SET lastModifiedTime = GetDate() ')	
				PRINT 'lastModifiedTime of QueueHistoryTable updated'
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''lastModifiedTime of QueueHistoryTable updated'')')
			END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE QUEUEHISTORYTABLE ADD lastModifiedTime FAILED.'')')
			SELECT @ErrMessage = 'Block 144 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
			
	BEGIN
		BEGIN TRY		
			IF NOT EXISTS ( SELECT * FROM sysColumns WHERE 
				id = (SELECT id FROM sysObjects WHERE NAME = 'WFCURRENTROUTELOGTABLE')
				AND  NAME = 'ProcessVariantId'
				)
			BEGIN
				EXECUTE('ALTER TABLE WFCURRENTROUTELOGTABLE ADD ProcessVariantId 	INT DEFAULT 0')		
				PRINT 'ALTER TABLE WFCURRENTROUTELOGTABLE ADD ProcessVariantId 	INT DEFAULT 0'		
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFCURRENTROUTELOGTABLE ADD ProcessVariantId 	INT DEFAULT 0'')')
				
			END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFCURRENTROUTELOGTABLE ADD ProcessVariantId FAILED.'')')
			SELECT @ErrMessage = 'Block 145 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
			IF NOT EXISTS ( SELECT * FROM sysColumns WHERE 
				id = (SELECT id FROM sysObjects WHERE NAME = 'WFCURRENTROUTELOGTABLE')
				AND  NAME = 'TaskId'
				)
			BEGIN
				EXECUTE('ALTER TABLE WFCURRENTROUTELOGTABLE ADD TaskId INT Default 0')		
				PRINT 'ALTER TABLE WFCURRENTROUTELOGTABLE ADD TaskId INT Default 0'	
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFCURRENTROUTELOGTABLE ADD TaskId INT Default 0'')')		
			END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFCURRENTROUTELOGTABLE ADD TaskId FAILED.'')')
			SELECT @ErrMessage = 'Block 146 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
			IF NOT EXISTS ( SELECT * FROM sysColumns WHERE 
				id = (SELECT id FROM sysObjects WHERE NAME = 'WFCURRENTROUTELOGTABLE')
				AND  NAME = 'SubTaskId'
				)
			BEGIN
				EXECUTE('ALTER TABLE WFCURRENTROUTELOGTABLE ADD SubTaskId INT Default 0')		
				PRINT 'ALTER TABLE WFCURRENTROUTELOGTABLE ADD SubTaskId INT Default 0'	
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFCURRENTROUTELOGTABLE ADD SubTaskId INT Default 0'')')
			END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFCURRENTROUTELOGTABLE ADD SubTaskId FAILED.'')')
			SELECT @ErrMessage = 'Block 147 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
			IF NOT EXISTS ( SELECT * FROM sysColumns WHERE 
				id = (SELECT id FROM sysObjects WHERE NAME = 'WFHISTORYROUTELOGTABLE')
				AND  NAME = 'ProcessVariantId'
				)
			BEGIN
				EXECUTE('ALTER TABLE WFHISTORYROUTELOGTABLE ADD ProcessVariantId 	INT ')		
				PRINT 'ALTER TABLE WFHISTORYROUTELOGTABLE ADD ProcessVariantId 	INT '	
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFHISTORYROUTELOGTABLE ADD ProcessVariantId 	INT '')')		
			END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFHISTORYROUTELOGTABLE ADD ProcessVariantId FAILED.'')')
			SELECT @ErrMessage = 'Block 148 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
			
	BEGIN
		BEGIN TRY
			IF NOT EXISTS ( SELECT * FROM sysColumns WHERE 
				id = (SELECT id FROM sysObjects WHERE NAME = 'WFHISTORYROUTELOGTABLE')
				AND  NAME = 'TaskId'
				)
			BEGIN
				EXECUTE('ALTER TABLE WFHISTORYROUTELOGTABLE ADD TaskId INT Default 0')		
				PRINT 'ALTER TABLE WFHISTORYROUTELOGTABLE ADD TaskId INT Default 0'	
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFHISTORYROUTELOGTABLE ADD TaskId INT Default 0'')')		
			END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFHISTORYROUTELOGTABLE ADD TaskId FAILED.'')')
			SELECT @ErrMessage = 'Block 149 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
			IF NOT EXISTS ( SELECT * FROM sysColumns WHERE 
				id = (SELECT id FROM sysObjects WHERE NAME = 'WFHISTORYROUTELOGTABLE')
				AND  NAME = 'SubTaskId'
				)
			BEGIN
				EXECUTE('ALTER TABLE WFHISTORYROUTELOGTABLE ADD SubTaskId INT Default 0')		
				PRINT 'ALTER TABLE WFHISTORYROUTELOGTABLE ADD SubTaskId INT Default 0'		
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFHISTORYROUTELOGTABLE ADD SubTaskId INT Default 0'')')
		
			END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFHISTORYROUTELOGTABLE ADD SubTaskId FAILED.'')')
			SELECT @ErrMessage = 'Block 150 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
			IF NOT EXISTS ( SELECT * FROM sysColumns WHERE 
				id = (SELECT id FROM sysObjects WHERE NAME = 'WFLINKSTABLE')
				AND  NAME = 'IsParentArchived'
				)
			BEGIN
				EXECUTE('ALTER TABLE WFLINKSTABLE ADD IsParentArchived  NCHAR(1) DEFAULT ''N''')		
				PRINT 'ALTER TABLE WFLINKSTABLE ADD IsParentArchived  NCHAR(1) DEFAULT ''N'''	
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFLINKSTABLE ADD IsParentArchived  NCHAR(1) DEFAULT (N) '')')
			END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFLINKSTABLE ADD IsParentArchived FAILED.'')')
			SELECT @ErrMessage = 'Block 151 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
		IF NOT EXISTS ( SELECT * FROM sysColumns WHERE 
				id = (SELECT id FROM sysObjects WHERE NAME = 'WFLINKSTABLE')
				AND  NAME = 'IsChildArchived'
				)
			BEGIN
				EXECUTE('ALTER TABLE WFLINKSTABLE ADD IsChildArchived  NCHAR(1) DEFAULT ''N''')		
				PRINT 'ALTER TABLE WFLINKSTABLE ADD IsChildArchived  NCHAR(1) DEFAULT ''N'''	
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFLINKSTABLE ADD IsChildArchived  NCHAR(1) DEFAULT (N)'')')
			END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFLINKSTABLE ADD IsChildArchived FAILED.'')')
			SELECT @ErrMessage = 'Block 152 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
			
			/*..............................Adding New columns in existing table by Mohnish..................................*/
			
			/*...............................Adding New columns in existing table by Kirti.....................................................*/
	
	BEGIN
		BEGIN TRY
			IF NOT EXISTS ( SELECT * FROM sysColumns WHERE 
				id = (SELECT id FROM sysObjects WHERE NAME = 'WFTransportDataTable')
				AND  NAME = 'ObjectTypeId'
				)
			BEGIN
				EXECUTE('ALTER TABLE WFTransportDataTable ADD ObjectTypeId INT')		
				PRINT 'ALTER TABLE WFTransportDataTable ADD ObjectTypeId INT'
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFTransportDataTable ADD ObjectTypeId INT'')')
			END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFTransportDataTable ADD ObjectTypeId FAILED.'')')
			SELECT @ErrMessage = 'Block 153 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
			IF NOT EXISTS ( SELECT * FROM sysColumns WHERE 
				id = (SELECT id FROM sysObjects WHERE NAME = 'WFReportDataTable')
				AND  NAME = 'ProcessVariantId'
				)
			BEGIN
				EXECUTE('ALTER TABLE WFReportDataTable ADD ProcessVariantId INT NOT NULL DEFAULT 0')		
				PRINT 'ALTER TABLE WFReportDataTable ProcessVariantId INT NOT NULL DEFAULT 0'
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFReportDataTable ProcessVariantId INT NOT NULL DEFAULT 0'')')
			END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFReportDataTable ADD ProcessVariantId FAILED.'')')
			SELECT @ErrMessage = 'Block 154 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
			IF NOT EXISTS ( SELECT * FROM sysColumns WHERE 
				id = (SELECT id FROM sysObjects WHERE NAME = 'WFVarStatusTable')
				AND  NAME = 'ProcessVariantId'
				)
			BEGIN
				EXECUTE('ALTER TABLE WFVarStatusTable ADD ProcessVariantId  INT NOT NULL DEFAULT 0')		
				PRINT 'ALTER TABLE WFVarStatusTable ProcessVariantId INT NOT NULL DEFAULT 0'
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFVarStatusTable ProcessVariantId INT NOT NULL DEFAULT 0'')')
			END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFVarStatusTable ADD ProcessVariantId FAILED.'')')
			SELECT @ErrMessage = 'Block 155 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
			IF NOT EXISTS ( SELECT * FROM sysColumns WHERE 
				id = (SELECT id FROM sysObjects WHERE NAME = 'WFEscInProcessTable')
				AND  (NAME = 'Frequency' OR NAME='FrequencyDuration')
				)
			BEGIN
				EXECUTE('ALTER TABLE WFEscInProcessTable ADD FrequencyDuration  INT')	
				PRINT 'ALTER TABLE WFEscInProcessTable FrequencyDuration INT' 
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFEscInProcessTable FrequencyDuration INT'')')
				EXECUTE('ALTER TABLE WFEscInProcessTable ADD Frequency  INT')
				PRINT 'ALTER TABLE WFEscInProcessTable Frequency INT '
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFEscInProcessTable Frequency INT '')')
			END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFEscInProcessTable ADD FrequencyDuration FAILED.'')')
			SELECT @ErrMessage = 'Block 156 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
			IF NOT EXISTS ( SELECT * FROM sysColumns WHERE 
				id = (SELECT id FROM sysObjects WHERE NAME = 'WFEscalationTable')
				AND  (NAME = 'Frequency' OR NAME='FrequencyDuration')
				)
			BEGIN
				EXECUTE('ALTER TABLE WFEscalationTable ADD FrequencyDuration  INT')	
				PRINT 'ALTER TABLE WFEscalationTable FrequencyDuration INT' 
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFEscalationTable FrequencyDuration INT'')')
				EXECUTE('ALTER TABLE WFEscalationTable ADD Frequency  INT')
				PRINT 'ALTER TABLE WFEscalationTable Frequency INT '
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFEscalationTable Frequency INT '')')
			END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFEscalationTable ADD FrequencyDuration FAILED.'')')
			SELECT @ErrMessage = 'Block 157 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
			
	BEGIN
		BEGIN TRY		
			IF NOT EXISTS ( SELECT * FROM sysColumns WHERE 
				id = (SELECT id FROM sysObjects WHERE NAME = 'WFINSTRUMENTTABLE')
				AND  NAME = 'ActivityType'
				)
			BEGIN
				EXECUTE('ALTER TABLE WFINSTRUMENTTABLE ADD ActivityType SmallInt NULL')		
				PRINT 'ALTER TABLE WFINSTRUMENTTABLE ADD ActivityType SmallInt NULL'
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFINSTRUMENTTABLE ADD ActivityType SmallInt NULL'')')
				EXECUTE('UPDATE WFINSTRUMENTTABLE SET  WFINSTRUMENTTABLE.ActivityType = ActivityTable.ActivityType
				FROM
				WFINSTRUMENTTABLE 
				INNER JOIN
				ActivityTable  
				ON
				WFINSTRUMENTTABLE.ProcessDefId = ActivityTable.ProcessDefId
				and
				WFINSTRUMENTTABLE.ActivityId = ActivityTable.ActivityId')
				PRINT 'ActivityType of WFINSTRUMENTTABLE updated'
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ActivityType of WFINSTRUMENTTABLE updated'')')
				
			END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFINSTRUMENTTABLE ADD ActivityType FAILED.'')')
			SELECT @ErrMessage = 'Block 158 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
			
			
	BEGIN
		BEGIN TRY			
			IF NOT EXISTS ( SELECT * FROM sysColumns WHERE 
				id = (SELECT id FROM sysObjects WHERE NAME = 'WFINSTRUMENTTABLE')
				AND  NAME = 'lastModifiedTime'
				)
			BEGIN
				EXECUTE('ALTER TABLE WFINSTRUMENTTABLE ADD lastModifiedTime 	DATETIME')		
				PRINT 'ALTER TABLE WFINSTRUMENTTABLE ADD lastModifiedTime 	DATETIME'
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFINSTRUMENTTABLE ADD lastModifiedTime 	DATETIME'')')
				EXECUTE('UPDATE  WFINSTRUMENTTABLE SET lastModifiedTime = GetDate() ')	
				PRINT 'lastModifiedTime of WFINSTRUMENTTABLE updated'
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''lastModifiedTime of WFINSTRUMENTTABLE updated'')')
			END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFINSTRUMENTTABLE ADD lastModifiedTime FAILED.'')')
			SELECT @ErrMessage = 'Block 159 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
			
	BEGIN
		BEGIN TRY
			IF NOT EXISTS ( SELECT * FROM sysColumns WHERE 
				id = (SELECT id FROM sysObjects WHERE NAME = 'SUMMARYTABLE')
				AND  NAME = 'ProcessVariantId'
				)
			BEGIN
				EXECUTE('ALTER TABLE SUMMARYTABLE ADD ProcessVariantId  INT NOT NULL DEFAULT 0')		
				PRINT 'ALTER TABLE SUMMARYTABLE ProcessVariantId INT NOT NULL DEFAULT 0'
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE SUMMARYTABLE ProcessVariantId INT NOT NULL DEFAULT 0'')')
			END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE SUMMARYTABLE ADD ProcessVariantId FAILED.'')')
			SELECT @ErrMessage = 'Block 160 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
			IF NOT EXISTS ( SELECT * FROM sysColumns WHERE 
				id = (SELECT id FROM sysObjects WHERE NAME = 'WFATTRIBUTEMESSAGETABLE')
				AND  NAME = 'ProcessVariantId'
				)
			BEGIN
				EXECUTE('ALTER TABLE WFATTRIBUTEMESSAGETABLE ADD ProcessVariantId  INT NOT NULL DEFAULT 0')		
				PRINT 'ALTER TABLE WFATTRIBUTEMESSAGETABLE ProcessVariantId INT NOT NULL DEFAULT 0'
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFATTRIBUTEMESSAGETABLE ProcessVariantId INT NOT NULL DEFAULT 0'')')
			END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFATTRIBUTEMESSAGETABLE ADD ProcessVariantId FAILED.'')')
			SELECT @ErrMessage = 'Block 161 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
			
	BEGIN
		BEGIN TRY
		IF NOT EXISTS ( SELECT * FROM sysColumns 
				WHERE 
				id = (SELECT id FROM sysObjects WHERE NAME = 'WFCommentsTable')
				AND  NAME = 'ProcessVariantId'
				)
			BEGIN
				EXECUTE('Alter Table WFCommentsTable add ProcessVariantId INT NOT NULL DEFAULT 0')		
				Print 'WFCommentsTable Altered successfully'			
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''WFCommentsTable Altered successfully'')')		
			END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Alter Table WFCommentsTable add ProcessVariantId FAILED.'')')
			SELECT @ErrMessage = 'Block 162 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
			IF NOT EXISTS ( SELECT * FROM sysColumns 
				WHERE 
				id = (SELECT id FROM sysObjects WHERE NAME = 'WFREMINDERTABLE')
				AND  NAME = 'TaskId'
				)
			BEGIN
				EXECUTE('Alter Table WFREMINDERTABLE add  TaskId INT NOT NULL DEFAULT 0')		
				Print 'WFREMINDERTABLE Altered successfully'	
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''WFREMINDERTABLE Altered successfully'')')		
			END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Alter Table WFREMINDERTABLE add  TaskId FAILED.'')')
			SELECT @ErrMessage = 'Block 163 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
			
	BEGIN
		BEGIN TRY
			IF NOT EXISTS ( SELECT * FROM sysColumns 
				WHERE 
				id = (SELECT id FROM sysObjects WHERE NAME = 'WFREMINDERTABLE')
				AND  NAME = 'SubTaskId'
				)
			BEGIN
				EXECUTE('Alter Table WFREMINDERTABLE add  SubTaskId INT NOT NULL DEFAULT 0')		
				Print 'WFREMINDERTABLE Altered successfully'	
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''WFREMINDERTABLE Altered successfully'')')
			END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Alter Table WFREMINDERTABLE add  SubTaskId FAILED.'')')
			SELECT @ErrMessage = 'Block 164 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
			
			/*.........................End Of changes done by Kirti.....................................................*/
			
			/*...............................END of Adding new columns in existing Table...............................*/
			
				/* ............................ Modifying Existing Columns .............................................*/
	BEGIN
		BEGIN TRY	
			BEGIN
				EXECUTE('update PROCESSDEFTABLE set FormViewerApp = N''J'' where FormViewerApp is null')
				EXECUTE('Alter Table ACTIVITYTABLE Alter Column Description NTEXT NULL')
				EXECUTE('Alter Table TRIGGERTYPEDEFTABLE Alter Column ClassName NVARCHAR(255) NOT NULL')
				PRINT 	'Alter Table TRIGGERTYPEDEFTABLE Alter Column ClassName NVARCHAR(255) NOT NULL'
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Alter Table TRIGGERTYPEDEFTABLE Alter Column ClassName NVARCHAR(255) NOT NULL'')')
				EXECUTE('Alter Table VARALIASTABLE Alter Column Type1 SMALLINT NULL')
				PRINT 'Alter Table VARALIASTABLE Alter Column Type1 SMALLINT NULL'
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Alter Table VARALIASTABLE Alter Column Type1 SMALLINT NULL'')')
				IF EXISTS (SELECT *	FROM sysindexes	WHERE id = OBJECT_ID('WFDataMapTable') AND name = 'IDX1_WFDataMapTable')
				BEGIN
					EXECUTE('DROP Index IDX1_WFDataMapTable ON WFDataMapTable')
				END 
				EXECUTE('UPDATE WFDataMapTable SET ProcessDefId = 0 where ProcessDefId is NULL')
				EXECUTE('UPDATE WFDataMapTable SET ActivityId = 0 where ActivityId is NULL')
				EXECUTE('UPDATE WFDataMapTable SET OrderId = 0 where OrderId is NULL')		
				EXECUTE('ALTER TABLE WFDataMapTable Alter column ProcessDefId INT NOT NULL')
				EXECUTE('ALTER TABLE WFDataMapTable Alter column ActivityId INT NOT NULL')
				EXECUTE('ALTER TABLE WFDataMapTable Alter column OrderId INT NOT NULL')
				EXECUTE('CREATE INDEX IDX1_WFDataMapTable ON WFDataMapTable (ProcessDefId, ActivityId)')
				PRINT 'ALTER TABLE WFDataMapTable Alter column OrderId INT NOT NULL'
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFDataMapTable Alter column OrderId INT NOT NULL'')')
				--EXECUTE('Alter table EXTMETHODDEFTABLE add tempSearchCriteria integer')
				--EXECUTE('update EXTMETHODDEFTABLE set tempSearchCriteria = cast(SearchCriteria as integer)')
				--EXECUTE('alter table EXTMETHODDEFTABLE drop column SearchCriteria')
				--EXECUTE('sp_RENAME ''EXTMETHODDEFTABLE.tempSearchCriteria'', ''SearchCriteria'' , ''COLUMN''')
				EXECUTE('ALTER TABLE EXTMETHODDEFTABLE Alter column SearchCriteria INT')
				
				/*...........................Added by Mohnish........................................................*/
				
				EXECUTE('Alter Table RuleConditionTable Alter Column Param1 NVARCHAR(255) NOT NULL')
				Print 'Alter Table RuleConditionTable Alter Column Param1 NVARCHAR(255) NOT NULL'
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Alter Table RuleConditionTable Alter Column Param1 NVARCHAR(255) NOT NULL'')')
				EXECUTE('Alter Table RULEOPERATIONTABLE Alter Column Param1 NVARCHAR(255) NOT NULL')
				Print 'Alter Table RULEOPERATIONTABLE Alter Column Param1 NVARCHAR(255) NOT NULL'
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Alter Table RULEOPERATIONTABLE Alter Column Param1 NVARCHAR(255) NOT NULL'')')
				EXECUTE('UPDATE MAILTRIGGERTABLE SET MailPriorityType = ''C'' where MailPriorityType is NULL')
				Print 'UPDATE MAILTRIGGERTABLE SET MailPriorityType = ''C'' where MailPriorityType is NULL'
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''UPDATE MAILTRIGGERTABLE SET MailPriorityType = C where MailPriorityType is NULL'')')
				EXECUTE('UPDATE MAILTRIGGERTABLE SET ExtObjIdMailPriority = 0 where ExtObjIdMailPriority is NULL')
				Print 'UPDATE MAILTRIGGERTABLE SET ExtObjIdMailPriority = 0 where ExtObjIdMailPriority is NULL'
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''UPDATE MAILTRIGGERTABLE SET ExtObjIdMailPriority = 0 where ExtObjIdMailPriority is NULL'')')
				EXECUTE('UPDATE MAILTRIGGERTABLE SET VariableIdMailPriority = 0 where VariableIdMailPriority is NULL')
				Print 'UPDATE MAILTRIGGERTABLE SET VariableIdMailPriority = 0 where VariableIdMailPriority is NULL'
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''UPDATE MAILTRIGGERTABLE SET VariableIdMailPriority = 0 where VariableIdMailPriority is NULL'')')
				EXECUTE('UPDATE MAILTRIGGERTABLE SET VarFieldIdMailPriority = 0 where VarFieldIdMailPriority is NULL')
				Print 'UPDATE MAILTRIGGERTABLE SET VarFieldIdMailPriority = 0 where VarFieldIdMailPriority is NULL'
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''UPDATE MAILTRIGGERTABLE SET VarFieldIdMailPriority = 0 where VarFieldIdMailPriority is NULL'')')
				EXECUTE('Alter Table MAILTRIGGERTABLE Alter Column MailPriorityType NVARCHAR(1)  NOT NULL')
				Print 'Alter Table MAILTRIGGERTABLE Alter Column MailPriorityType NVARCHAR(1)  NOT NULL' 
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Alter Table MAILTRIGGERTABLE Alter Column MailPriorityType NVARCHAR(1)  NOT NULL'')')
				EXECUTE('Alter Table DATASETTRIGGERTABLE Alter Column Param1 NVARCHAR(255) ')
				Print 'Alter Table DATASETTRIGGERTABLE Alter Column Param1 NVARCHAR(255)' 
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Alter Table DATASETTRIGGERTABLE Alter Column Param1 NVARCHAR(255)'')')
				EXECUTE('Alter Table ACTIONCONDITIONTABLE Alter Column Param1 NVARCHAR(255) NOT NULL')
				Print 'Alter Table ACTIONCONDITIONTABLE Alter Column Param1 NVARCHAR(255) NOT NULL'
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Alter Table ACTIONCONDITIONTABLE Alter Column Param1 NVARCHAR(255) NOT NULL'')')
				EXECUTE('Alter Table ACTIONOPERATIONTABLE Alter Column Param1 NVARCHAR(255) NOT NULL')
				Print 'Alter Table ACTIONOPERATIONTABLE Alter Column Param1 NVARCHAR(255) NOT NULL'
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Alter Table ACTIONOPERATIONTABLE Alter Column Param1 NVARCHAR(255) NOT NULL'')')
				EXECUTE('Alter Table SCANACTIONSTABLE Alter Column Param1 NVARCHAR(255)    NOT NULL')
				Print 'Alter Table SCANACTIONSTABLE	 Alter Column Param1 NVARCHAR(255) NOT NULL'	
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Alter Table SCANACTIONSTABLE	 Alter Column Param1 NVARCHAR(255) NOT NULL'')')
			END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Multiple Alter Table and Update in a block FAILED.'')')
			SELECT @ErrMessage = 'Block 165 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
				
				/*...........................Added by Mohnish ends........................................................*/
				
				/*............................Changes done by Kirti...................................................*/
	BEGIN
		BEGIN TRY			
				BEGIN
					EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFMultiLingualTable ALTER COLUMN Locale started.'')')
					SET @ConstraintName = ''
					SELECT @ConstraintName =  constraint_name FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE table_name = 'WFMultiLingualTable' AND constraint_type = 'PRIMARY KEY'
					IF (@ConstraintName IS NOT NULL AND (LEN(@ConstraintName) > 0))
					BEGIN
						EXECUTE ('ALTER TABLE WFMultiLingualTable DROP CONSTRAINT ' + @ConstraintName)
					END
					EXECUTE('ALTER TABLE WFMultiLingualTable ALTER COLUMN Locale  NVARCHAR(100) NOT NULL ')
					EXECUTE('ALTER TABLE WFMultiLingualTable ADD CONSTRAINT '+@ConstraintName+' PRIMARY KEY (EntityId, EntityType, Locale, ProcessDefId, ParentId)')
					
				END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFMultiLingualTable ALTER COLUMN Locale FAILED.'')')
			SELECT @ErrMessage = 'Block 166 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END		
		
	BEGIN
		BEGIN TRY	
				--EXECUTE('ALTER TABLE WFMultiLingualTable ALTER COLUMN Locale  NVARCHAR(100) NOT NULL ')
				EXECUTE('ALTER TABLE WFExtInterfaceConditionTable ALTER COLUMN Param1 NVARCHAR(255) NOT NULL ')
				EXECUTE('ALTER TABLE WFEscalationTable ALTER COLUMN CCId NVARCHAR(MAX)')
				EXECUTE('ALTER TABLE PRINTFAXEMAILTABLE ALTER COLUMN MailPriorityType NVARCHAR(1)')
				/*EXECUTE ('UPDATE WFCURRENTROUTELOGTABLE SET TaskId =0 WHERE TaskId is NULL')
				PRINT 'Update TABLE WFCURRENTROUTELOGTABLE set TaskId 0'
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Update TABLE WFCURRENTROUTELOGTABLE set TaskId 0'')')
				EXECUTE ('UPDATE WFCURRENTROUTELOGTABLE SET SubTaskId =0 WHERE SubTaskId is NULL')		
				PRINT 'Update TABLE WFCURRENTROUTELOGTABLE set SubTaskId 0'
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Update TABLE WFCURRENTROUTELOGTABLE set SubTaskId 0'')')
				EXECUTE ('UPDATE WFHISTORYROUTELOGTABLE SET TaskId =0 WHERE TaskId is NULL')
				PRINT 'Update TABLE WFHISTORYROUTELOGTABLE set TaskId 0'	
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Update TABLE WFHISTORYROUTELOGTABLE set TaskId 0'')')
				EXECUTE ('UPDATE WFHISTORYROUTELOGTABLE SET SubTaskId =0 WHERE SubTaskId is NULL')
				PRINT 'Update TABLE WFHISTORYROUTELOGTABLE set SubTaskId 0'	
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Update TABLE WFHISTORYROUTELOGTABLE set SubTaskId 0'')')	*/	
				EXECUTE ('UPDATE WFLINKSTABLE SET IsParentArchived =''N'' WHERE IsParentArchived is NULL')
				PRINT 'Update TABLE WFLINKSTABLE set IsParentArchived N'	
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Update TABLE WFLINKSTABLE set IsParentArchived N'')')		
				EXECUTE ('UPDATE WFLINKSTABLE SET IsChildArchived =''N'' WHERE IsChildArchived is NULL')
				PRINT 'Update TABLE WFLINKSTABLE set IsChildArchived N'		
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Update TABLE WFLINKSTABLE set IsChildArchived N'')')
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFExtInterfaceConditionTable,WFEscalationTable PRINTFAXEMAILTABLE ALTER COLUMN FAILED.'')')
			SELECT @ErrMessage = 'Block 167 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END			
	
	BEGIN
		BEGIN TRY
			BEGIN
				IF NOT EXISTS(SELECT * FROM WFEXPORTINFOTABLE WHERE TARGETCABINETNAME  
				is null)
				BEGIN
					EXECUTE('Alter table WFEXPORTINFOTABLE ALTER COLUMN 
						TARGETCABINETNAME NVARCHAR(255)	NOT NULL')
					PRINT 'Alter table WFEXPORTINFOTABLE alter column 
						TARGETCABINETNAME NVARCHAR(255)	NOT NULL'
					EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Alter table WFEXPORTINFOTABLE alter column 
						TARGETCABINETNAME NVARCHAR(255)	NOT NULL'')')
				END
			END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFExtInterfaceConditionTable,WFEscalationTable PRINTFAXEMAILTABLE ALTER COLUMN FAILED.'')')
			SELECT @ErrMessage = 'Block 168 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
			BEGIN
				IF NOT EXISTS(SELECT * FROM WFEXPORTINFOTABLE WHERE TARGETUSERNAME  
				is null)
				BEGIN
					EXECUTE('Alter table WFEXPORTINFOTABLE ALTER COLUMN 
						TARGETUSERNAME NVARCHAR(255)	NOT NULL')
					PRINT 'Alter table WFEXPORTINFOTABLE alter column 
						TARGETUSERNAME NVARCHAR(255) NOT NULL'
					EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Alter table WFEXPORTINFOTABLE alter column 
						TARGETUSERNAME NVARCHAR(255) NOT NULL'')')
				END
			END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Alter table WFEXPORTINFOTABLE ALTER COLUMN TARGETUSERNAME FAILED.'')')
			SELECT @ErrMessage = 'Block 169 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
			BEGIN
				IF NOT EXISTS(SELECT * FROM PRINTFAXEMAILTABLE WHERE ExtObjIdMailPriority is null)
				BEGIN
					EXECUTE('Alter table PRINTFAXEMAILTABLE alter column ExtObjIdMailPriority INT NOT NULL')
					PRINT 'Alter table PRINTFAXEMAILTABLE alter column ExtObjIdMailPriority INT NOT NULL'
					EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Alter table PRINTFAXEMAILTABLE alter column ExtObjIdMailPriority INT NOT NULL'')')
				END
			END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Alter table WFEXPORTINFOTABLE PRINTFAXEMAILTABLE alter column ExtObjIdMailPriority FAILED.'')')
			SELECT @ErrMessage = 'Block 170 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
			
	BEGIN
		BEGIN TRY		
			BEGIN
				IF NOT EXISTS(SELECT * FROM PRINTFAXEMAILTABLE WHERE VariableIdMailPriority is null)
				BEGIN
					EXECUTE('Alter table PRINTFAXEMAILTABLE alter column VariableIdMailPriority INT NOT NULL')
					PRINT 'Alter table PRINTFAXEMAILTABLE alter column VariableIdMailPriority INT NOT NULL'
					EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Alter table PRINTFAXEMAILTABLE alter column VariableIdMailPriority INT NOT NULL'')')
				END
			END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Alter table WFEXPORTINFOTABLE PRINTFAXEMAILTABLE alter column ExtObjIdMailPriority FAILED.'')')
			SELECT @ErrMessage = 'Block 171 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
			BEGIN
				IF NOT EXISTS(SELECT * FROM PRINTFAXEMAILTABLE WHERE VarFieldIdMailPriority is null)
				BEGIN
					EXECUTE('Alter table PRINTFAXEMAILTABLE alter column VarFieldIdMailPriority INT NOT NULL')
					PRINT 'Alter table PRINTFAXEMAILTABLE alter column VarFieldIdMailPriority INT NOT NULL'
					EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Alter table PRINTFAXEMAILTABLE alter column VarFieldIdMailPriority INT NOT NULL'')')
				END
			END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Alter table PRINTFAXEMAILTABLE alter column VarFieldIdMailPriority FAILED.'')')
			SELECT @ErrMessage = 'Block 172 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
				
	BEGIN
		BEGIN TRY
			IF  EXISTS ( SELECT * FROM sysColumns 
				WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'PRINTFAXEMAILTABLE') AND  NAME = 'BCCMailIdType')
				BEGIN
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Alter table PRINTFAXEMAILTABLE DROP CONSTRAINT on  BCCMailIdType started.'')')
				SET @ConstraintName = ''
				SELECT @ConstraintName = Name FROM SYS.DEFAULT_CONSTRAINTS WHERE PARENT_OBJECT_ID = OBJECT_ID('PRINTFAXEMAILTABLE')
				AND PARENT_COLUMN_ID = (SELECT column_id FROM sys.columns WHERE NAME = N'BCCMailIdType' AND object_id = OBJECT_ID(N'PRINTFAXEMAILTABLE'))
				IF (@ConstraintName IS NOT NULL AND (LEN(@ConstraintName) > 0))
					EXECUTE('ALTER TABLE PRINTFAXEMAILTABLE DROP CONSTRAINT ' + @ConstraintName)
						
				END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Alter table PRINTFAXEMAILTABLE DROP CONSTRAINT on  BCCMailIdType FAILED.'')')
			SELECT @ErrMessage = 'Block 173 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END		
		 
	BEGIN
		BEGIN TRY
			IF  EXISTS ( SELECT * FROM sysColumns WHERE  id = (SELECT id FROM sysObjects WHERE NAME = 'PRINTFAXEMAILTABLE')
			AND  NAME = 'ExtBCCMailId' )
			BEGIN
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE PRINTFAXEMAILTABLE DROP CONSTRAINT  on ExtBCCMailId started.'')')
				SET @ConstraintName = ''
				SELECT @ConstraintName = Name FROM SYS.DEFAULT_CONSTRAINTS WHERE PARENT_OBJECT_ID = OBJECT_ID('PRINTFAXEMAILTABLE')
				AND PARENT_COLUMN_ID = (SELECT column_id FROM sys.columns WHERE NAME = N'ExtBCCMailId' AND object_id = OBJECT_ID(N'PRINTFAXEMAILTABLE'))
				IF (@ConstraintName IS NOT NULL AND (LEN(@ConstraintName) > 0))
					EXECUTE('ALTER TABLE PRINTFAXEMAILTABLE DROP CONSTRAINT ' + @ConstraintName)
					
			END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE PRINTFAXEMAILTABLE DROP CONSTRAINT  on ExtBCCMailId FAILED.'')')
			SELECT @ErrMessage = 'Block 174 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
			
	BEGIN
		BEGIN TRY	 
			IF  EXISTS ( SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'PRINTFAXEMAILTABLE')
			AND  NAME = 'VariableIdBCC'			)
			BEGIN
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE PRINTFAXEMAILTABLE DROP CONSTRAINT  on VariableIdBCC started.'')')
				SET @ConstraintName = ''
				SELECT @ConstraintName = Name FROM SYS.DEFAULT_CONSTRAINTS WHERE PARENT_OBJECT_ID = OBJECT_ID('PRINTFAXEMAILTABLE')
				AND PARENT_COLUMN_ID = (SELECT column_id FROM sys.columns WHERE NAME = N'VariableIdBCC' AND object_id = OBJECT_ID(N'PRINTFAXEMAILTABLE'))
				IF (@ConstraintName IS NOT NULL AND (LEN(@ConstraintName) > 0))
					EXECUTE('ALTER TABLE PRINTFAXEMAILTABLE DROP CONSTRAINT ' + @ConstraintName)
					
			END 
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE PRINTFAXEMAILTABLE DROP CONSTRAINT  on VariableIdBCC FAILED.'')')
			SELECT @ErrMessage = 'Block 175 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
			IF  EXISTS ( SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'PRINTFAXEMAILTABLE')
			AND  NAME = 'VarFieldIdBCC'	)
			BEGIN
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE PRINTFAXEMAILTABLE DROP CONSTRAINT  on VarFieldIdBCC started.'')')
				SET @ConstraintName = ''
				SELECT @ConstraintName = Name FROM SYS.DEFAULT_CONSTRAINTS WHERE PARENT_OBJECT_ID = OBJECT_ID('PRINTFAXEMAILTABLE')
				AND PARENT_COLUMN_ID = (SELECT column_id FROM sys.columns WHERE NAME = N'VarFieldIdBCC' AND object_id = OBJECT_ID(N'PRINTFAXEMAILTABLE'))
				IF (@ConstraintName IS NOT NULL AND (LEN(@ConstraintName) > 0))
					EXECUTE('ALTER TABLE PRINTFAXEMAILTABLE DROP CONSTRAINT ' + @ConstraintName)
					
			END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE PRINTFAXEMAILTABLE DROP CONSTRAINT  on VarFieldIdBCC FAILED.'')')
			SELECT @ErrMessage = 'Block 176 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
			
	BEGIN
		BEGIN TRY		
			IF  EXISTS ( SELECT * FROM sysColumns WHERE 
			id = (SELECT id FROM sysObjects WHERE NAME = 'PRINTFAXEMAILTABLE')
			AND  NAME = 'MailPriority'
			)
			BEGIN
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE PRINTFAXEMAILTABLE DROP CONSTRAINT  on MailPriority started.'')')
				SET @ConstraintName = ''
				SELECT @ConstraintName = Name FROM SYS.DEFAULT_CONSTRAINTS WHERE PARENT_OBJECT_ID = OBJECT_ID('PRINTFAXEMAILTABLE')
				AND PARENT_COLUMN_ID = (SELECT column_id FROM sys.columns WHERE NAME = N'MailPriority' AND object_id = OBJECT_ID(N'PRINTFAXEMAILTABLE'))
				IF (@ConstraintName IS NOT NULL AND (LEN(@ConstraintName) > 0))
					EXECUTE('ALTER TABLE PRINTFAXEMAILTABLE DROP CONSTRAINT ' + @ConstraintName)
					
			END 
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE PRINTFAXEMAILTABLE DROP CONSTRAINT  on MailPriority FAILED.'')')
			SELECT @ErrMessage = 'Block 177 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END		
	
	BEGIN
		BEGIN TRY
			IF  EXISTS ( SELECT * FROM sysColumns WHERE 
			id = (SELECT id FROM sysObjects WHERE NAME = 'PRINTFAXEMAILTABLE')
			AND  NAME = 'MailPriorityType'
			)
			BEGIN
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE PRINTFAXEMAILTABLE DROP CONSTRAINT  on MailPriority started.'')')
				SET @ConstraintName = ''
				SELECT @ConstraintName = Name FROM SYS.DEFAULT_CONSTRAINTS WHERE PARENT_OBJECT_ID = OBJECT_ID('PRINTFAXEMAILTABLE')
				AND PARENT_COLUMN_ID = (SELECT column_id FROM sys.columns WHERE NAME = N'MailPriorityType' AND object_id = OBJECT_ID(N'PRINTFAXEMAILTABLE'))
				IF (@ConstraintName IS NOT NULL AND (LEN(@ConstraintName) > 0))
					EXECUTE('ALTER TABLE PRINTFAXEMAILTABLE DROP CONSTRAINT ' + @ConstraintName)
					
			END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE PRINTFAXEMAILTABLE DROP CONSTRAINT  on MailPriority FAILED.'')')
			SELECT @ErrMessage = 'Block 178 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
			IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'WFATTRIBUTEMESSAGETABLE' AND COLUMN_NAME = 'messageId' AND DATA_TYPE = 'BIGINT')
			BEGIN
			IF EXISTS (SELECT 1 FROM SYSObjects WHERE NAME = 'WFATTRIBUTEMESSAGETABLE' AND xType = 'U')
				BEGIN
					SET @ConstraintName = ''
					SELECT @ConstraintName =  CONSTRAINT_NAME FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME = 'WFATTRIBUTEMESSAGETABLE' AND CONSTRAINT_TYPE = 'PRIMARY KEY'
					IF (@ConstraintName IS NOT NULL AND (LEN(@ConstraintName) > 0))
					BEGIN
						EXECUTE ('ALTER TABLE WFATTRIBUTEMESSAGETABLE DROP CONSTRAINT ' + @ConstraintName)
						PRINT 'Table WFATTRIBUTEMESSAGETABLE altered, Primary Key on WFATTRIBUTEMESSAGETABLE is dropped.'
						EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Table WFATTRIBUTEMESSAGETABLE altered, Primary Key on WFATTRIBUTEMESSAGETABLE is dropped.'')')
					END
				
					EXECUTE('ALTER TABLE WFATTRIBUTEMESSAGETABLE ALTER COLUMN messageId BIGINT ')
					PRINT 'Table WFATTRIBUTEMESSAGETABLE altered with Column messageId changed to BIGINT'
					EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Table WFATTRIBUTEMESSAGETABLE altered with Column messageId changed to BIGINT'')')
		
					EXECUTE('ALTER TABLE WFATTRIBUTEMESSAGETABLE ADD PRIMARY KEY (messageId)')
					PRINT 'Table WFATTRIBUTEMESSAGETABLE altered, Primary Key created.'
					EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Table WFATTRIBUTEMESSAGETABLE altered, Primary Key created.'')')
				END
			END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE PRINTFAXEMAILTABLE DROP CONSTRAINT  on MailPriority FAILED.'')')
			SELECT @ErrMessage = 'Block 179 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
			IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'WFMessageInProcessTable' AND COLUMN_NAME = 'messageId' AND DATA_TYPE = 'BIGINT')
			BEGIN
			/*IF EXISTS (SELECT 1 FROM SYSObjects WHERE NAME = 'WFMessageInProcessTable' AND xType = 'U')
				IF EXISTS (SELECT *	FROM sysindexes	WHERE id = OBJECT_ID('WFMessageInProcessTable')
					AND name = 'IX2_WFMessageInProcessTable')
					BEGIN
						EXECUTE('DROP Index IX2_WFMessageInProcessTable ON WFMessageInProcessTable')
					END */
					SET @constrnName = ''
					Select @constrnName = index_name 
					from (SELECT i.name AS index_name ,COL_NAME(ic.object_id,ic.column_id) AS column_name  ,ic.index_column_id,
					ic.key_ordinal, ic.is_included_column  
					FROM sys.indexes AS i INNER JOIN sys.index_columns AS ic   
					ON i.object_id = ic.object_id AND i.index_id = ic.index_id  
					WHERE i.object_id = OBJECT_ID('WFMessageInProcessTable'))a where column_name = 'MessageId'
					IF (@constrnName IS NOT NULL AND (LEN(@constrnName) > 0))
					BEGIN
						EXECUTE('DROP INDEX ' + @constrnName + ' ON WFMessageInProcessTable')
						PRINT('Index Dropped on WFMessageInProcessTable')
					END
			
				EXECUTE('ALTER TABLE WFMessageInProcessTable ALTER COLUMN messageId BIGINT ')
				PRINT 'Table WFMessageInProcessTable altered with Column messageId changed to BIGINT'
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Table WFMessageInProcessTable altered with Column messageId changed to BIGINT'')')
				EXECUTE('CREATE INDEX IX2_WFMessageInProcessTable ON WFMessageInProcessTable (messageId)')
			END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE INDEX IX2_WFMessageInProcessTable ON WFMessageInProcessTable messageId FAILED.'')')
			SELECT @ErrMessage = 'Block 180 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END		
		
	BEGIN
		BEGIN TRY
			BEGIN
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFMessageInProcessTable ALTER COLUMN message started.'')')
				EXECUTE('ALTER TABLE WFMessageInProcessTable ALTER COLUMN message NVARCHAR(4000)')
				EXECUTE('ALTER TABLE WFFailedMessageTable ALTER COLUMN message NVARCHAR(4000)')
				EXECUTE('UPDATE WFFailedMessageTable SET Status= ''F'' where Status= ''F_Finally'' ')
				EXECUTE('ALTER TABLE WFFailedMessageTable ALTER COLUMN Status NVARCHAR(1)')
					
			
			/*............................Changes done by Kirti ends here..........................................*/
			END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFMessageInProcessTable ALTER COLUMN message FAILED.'')')
			SELECT @ErrMessage = 'Block 181 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
		
		
		/*...............................End of Modify column ....................................................*/
		
			/* Dropping extra columns*/
	BEGIN
		BEGIN TRY	
		IF  EXISTS ( SELECT * FROM sysColumns 
			WHERE 
			id = (SELECT id FROM sysObjects WHERE NAME = 'WFFORM_TABLE')
			AND  NAME = 'ISAPPLETVIEW'
			)
		BEGIN
			EXECUTE('UPDATE WFFORM_TABLE SET DeviceType=''Y'' WHERE ISAPPLETVIEW=''Y''')
			EXECUTE('UPDATE WFFORM_TABLE SET DeviceType=''D'' WHERE ISAPPLETVIEW=''N''')
			SET @ConstraintName1 = ''
			SELECT @ConstraintName1 = Name FROM SYS.DEFAULT_CONSTRAINTS WHERE PARENT_OBJECT_ID = OBJECT_ID('WFFORM_TABLE') AND PARENT_COLUMN_ID = (SELECT column_id FROM sys.columns WHERE NAME = N'ISAPPLETVIEW' AND object_id = OBJECT_ID(N'WFFORM_TABLE'))
				print 'contraint name '
				print '@ConstraintName1'
				IF (@ConstraintName1 IS NOT NULL AND (LEN(@ConstraintName1) > 0))
				BEGIN
				EXECUTE('ALTER TABLE WFFORM_TABLE DROP CONSTRAINT ' + @ConstraintName1)
				END
				EXECUTE('ALTER TABLE WFFORM_TABLE DROP COLUMN ISAPPLETVIEW')		
		END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFFORM_TABLE DROP COLUMN ISAPPLETVIEW FAILED.'')')
			SELECT @ErrMessage = 'Block 182 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END
	
	BEGIN
		BEGIN TRY
		BEGIN
			SET @nullableVal=0
			select @nullableVal=is_nullable from sys.columns where object_id = object_id('mailtriggertable') and name = 'ExtObjIdMailPriority'
				IF(@nullableVal=1)
				BEGIN
					EXECUTE('ALTER TABLE mailtriggertable ALTER COLUMN  ExtObjIdMailPriority int NOT NULL ')
					SET @ConstraintName = ''
					SELECT @ConstraintName = Name FROM SYS.DEFAULT_CONSTRAINTS WHERE PARENT_OBJECT_ID = OBJECT_ID('MAILTRIGGERTABLE') AND PARENT_COLUMN_ID = (SELECT column_id FROM sys.columns WHERE NAME = N'ExtObjIdMailPriority' AND object_id = OBJECT_ID(N'MAILTRIGGERTABLE'))
					IF (@ConstraintName IS NOT NULL AND (LEN(@ConstraintName) > 0))
					BEGIN
						EXECUTE('ALTER TABLE MAILTRIGGERTABLE DROP CONSTRAINT ' + @ConstraintName)
						PRINT 'ALTER TABLE MAILTRIGGERTABLE DROP OLD CONSTRAINT ' 
						EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE MAILTRIGGERTABLE DROP OLD CONSTRAINT'')')
					END	
					EXECUTE('ALTER TABLE mailtriggertable ADD CONSTRAINT DF__ExtObjIdMail DEFAULT 0 FOR ExtObjIdMailPriority')
					PRINT 'ALTER TABLE mailtriggertable ADD CONSTRAINT DF__ExtObjIdMail DEFAULT 0 FOR ExtObjIdMailPriority'
					EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE mailtriggertable ADD CONSTRAINT DF__ExtObjIdMail DEFAULT 0 FOR ExtObjIdMailPriority'')')
				END
		END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE mailtriggertable ADD CONSTRAINT DF__ExtObjIdMail FAILED.'')')
			SELECT @ErrMessage = 'Block 183 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END
	
	BEGIN
		BEGIN TRY
		BEGIN
			SET @nullableVal=0
			select @nullableVal=is_nullable from sys.columns where object_id = object_id('mailtriggertable') and name = 'VariableIdMailPriority'
				IF(@nullableVal=1)
				BEGIN
					EXECUTE('ALTER TABLE mailtriggertable ALTER COLUMN  VariableIdMailPriority int NOT NULL ')
					SET @ConstraintName = ''
					SELECT @ConstraintName = Name FROM SYS.DEFAULT_CONSTRAINTS WHERE PARENT_OBJECT_ID = OBJECT_ID('MAILTRIGGERTABLE') AND PARENT_COLUMN_ID = (SELECT column_id FROM sys.columns WHERE NAME = N'VariableIdMailPriority' AND object_id = OBJECT_ID(N'MAILTRIGGERTABLE'))
					IF (@ConstraintName IS NOT NULL AND (LEN(@ConstraintName) > 0))
					BEGIN
						EXECUTE('ALTER TABLE MAILTRIGGERTABLE DROP CONSTRAINT ' + @ConstraintName)
						PRINT 'ALTER TABLE MAILTRIGGERTABLE DROP OLD CONSTRAINT ' 
						EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE MAILTRIGGERTABLE DROP OLD CONSTRAINT'')')
					END	
					EXECUTE('ALTER TABLE mailtriggertable ADD CONSTRAINT DF__VariableIdMailPriority DEFAULT 0 FOR VariableIdMailPriority')
					PRINT 'ALTER TABLE mailtriggertable ADD CONSTRAINT DF__VariableIdMailPriority DEFAULT 0 FOR VariableIdMailPriority'
					EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE mailtriggertable ADD CONSTRAINT DF__VariableIdMailPriority DEFAULT 0 FOR VariableIdMailPriority'')')
				END
		
		END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE mailtriggertable ADD CONSTRAINT DF__VariableIdMailPriority FAILED.'')')
			SELECT @ErrMessage = 'Block 184 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END
	
	BEGIN
		BEGIN TRY
		BEGIN
			SET @nullableVal=0
			select @nullableVal=is_nullable from sys.columns where object_id = object_id('mailtriggertable') and name = 'VarFieldIdMailPriority'
				print @nullableVal
				IF(@nullableVal=1)
				BEGIN
					EXECUTE('ALTER TABLE mailtriggertable ALTER COLUMN  VarFieldIdMailPriority int NOT NULL ')
					SET @ConstraintName = ''
					SELECT @ConstraintName = Name FROM SYS.DEFAULT_CONSTRAINTS WHERE PARENT_OBJECT_ID = OBJECT_ID('MAILTRIGGERTABLE') AND PARENT_COLUMN_ID = (SELECT column_id FROM sys.columns WHERE NAME = N'VarFieldIdMailPriority' AND object_id = OBJECT_ID(N'MAILTRIGGERTABLE'))
					IF (@ConstraintName IS NOT NULL AND (LEN(@ConstraintName) > 0))
					BEGIN
						EXECUTE('ALTER TABLE MAILTRIGGERTABLE DROP CONSTRAINT ' + @ConstraintName)
						PRINT 'ALTER TABLE MAILTRIGGERTABLE DROP OLD CONSTRAINT ' 
						EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE MAILTRIGGERTABLE DROP OLD CONSTRAINT'')')
					END	
					EXECUTE('ALTER TABLE mailtriggertable ADD CONSTRAINT DF__arFieldIdMailPriority DEFAULT 0 FOR VarFieldIdMailPriority')
	
				END
				Print 'ALTER TABLE mailtriggertable ALTER COLUMN  VarFieldIdMailPriority int NOT NULL'
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE mailtriggertable ALTER COLUMN  VarFieldIdMailPriority int NOT NULL'')')
		END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE mailtriggertable ADD CONSTRAINT DF__VariableIdMailPriority FAILED.'')')
			SELECT @ErrMessage = 'Block 185 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END
		/*..........................................Added by Mohnish .............................................*/
	BEGIN
		BEGIN TRY
			IF  EXISTS ( SELECT * FROM sysColumns 
				WHERE 
				id = (SELECT id FROM sysObjects WHERE NAME = 'PSREGISTERATIONTABLE')
				AND  NAME = 'BulkPS'
				)
			BEGIN
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE PSREGISTERATIONTABLE DROP COLUMN BulkPS Started.'')')
				EXECUTE('ALTER TABLE PSREGISTERATIONTABLE DROP COLUMN BulkPS')		
			END	
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE PSREGISTERATIONTABLE DROP COLUMN BulkPS FAILED.'')')
			SELECT @ErrMessage = 'Block 186 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
			
			
		/*..........................................Added by Mohnish ends..........................................*/
		
		
		/*.........................................Changes done by Kirti...........................................*/
		
		/*IF  EXISTS ( SELECT * FROM sysColumns 
			WHERE 
			id = (SELECT id FROM sysObjects WHERE NAME = 'WFSharePointDocAssocTable')
			AND  NAME = 'TargetDocName'
			)
		BEGIN
			EXECUTE('ALTER TABLE WFSharePointDocAssocTable DROP COLUMN TargetDocName')		
		END	*/
		
	BEGIN
		BEGIN TRY	
		IF  EXISTS ( SELECT * FROM sysColumns 
			WHERE 
			id = (SELECT id FROM sysObjects WHERE NAME = 'WFSystemServicesTable')
			AND  NAME = 'AppServerId'
			)
			BEGIN
				EXECUTE('ALTER TABLE WFSystemServicesTable DROP COLUMN AppServerId')		
			END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFSystemServicesTable DROP COLUMN AppServerId FAILED.'')')
			SELECT @ErrMessage = 'Block 187 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END
	
	BEGIN
		BEGIN TRY
		IF  EXISTS ( SELECT * FROM sysColumns 
			WHERE 
			id = (SELECT id FROM sysObjects WHERE NAME = 'WFImportFileData')
			AND  NAME = 'FailRecords'
			)
		BEGIN
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFImportFileData DROP COLUMN FailRecords started.'')')
			SET @ConstraintName = ''
			SELECT @ConstraintName = Name FROM SYS.DEFAULT_CONSTRAINTS WHERE PARENT_OBJECT_ID = OBJECT_ID('WFImportFileData') AND PARENT_COLUMN_ID = (SELECT column_id FROM sys.columns WHERE NAME = N'FailRecords' AND object_id = OBJECT_ID(N'WFImportFileData'))
				IF (@ConstraintName IS NOT NULL AND (LEN(@ConstraintName) > 0))
				BEGIN
					EXECUTE('ALTER TABLE WFImportFileData DROP CONSTRAINT ' + @ConstraintName)
					EXECUTE('ALTER TABLE WFImportFileData DROP COLUMN FailRecords')		
				END 
		END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFImportFileData DROP COLUMN FailRecords FAILED.'')')
			SELECT @ErrMessage = 'Block 188 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END
		
		
		/*.........................................Changes done by Kirti Ends here..................................*/
		
		/*...................................End of Dropping extra columns..........................................*/
		
		
		/*..........................................Adding Constraints.............................................*/
	BEGIN
		BEGIN TRY	
		BEGIN
			SET @ConstraintName = ' '
			SELECT @TableId = id FROM sysobjects WHERE name = 'TEMPLATEDEFINITIONTABLE'
			SELECT @ConstraintName = name FROM SYSCONSTRAINTS A, SYSOBJECTS B WHERE A.constid = B.id AND B.xtype = 'PK'AND A.id = @TableId 
			
			IF NOT EXISTS ( SELECT * FROM sysObjects WHERE NAME = @ConstraintName)
			BEGIN
				EXECUTE('alter table TEMPLATEDEFINITIONTABLE add CONSTRAINT Pk_TEMPLATEDEFINITIONTABLE PRIMARY KEY (ProcessdefId,TemplateId)')
				PRINT 'alter table TEMPLATEDEFINITIONTABLE add CONSTRAINT Pk_TEMPLATEDEFINITIONTABLE PRIMARY KEY (ProcessdefId,TemplateId) IN IF CASE'
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''alter table TEMPLATEDEFINITIONTABLE add CONSTRAINT Pk_TEMPLATEDEFINITIONTABLE PRIMARY KEY (ProcessdefId,TemplateId) IN IF CASE'')')
			END
			ELSE
			BEGIN
				execute('alter table TEMPLATEDEFINITIONTABLE drop CONSTRAINT ' + @ConstraintName)
				EXECUTE('alter table TEMPLATEDEFINITIONTABLE add CONSTRAINT Pk_TEMPLATEDEFINITIONTABLE PRIMARY KEY (ProcessdefId,TemplateId)')
				PRINT 'alter table TEMPLATEDEFINITIONTABLE add CONSTRAINT Pk_TEMPLATEDEFINITIONTABLE PRIMARY KEY (ProcessdefId,TemplateId)'
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''alter table TEMPLATEDEFINITIONTABLE add CONSTRAINT Pk_TEMPLATEDEFINITIONTABLE PRIMARY KEY (ProcessdefId,TemplateId)'')')
			END
		END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''TABLE TEMPLATEDEFINITIONTABLE add CONSTRAINT Pk_TEMPLATEDEFINITIONTABLE FAILED.'')')
			SELECT @ErrMessage = 'Block 189 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END
	
	BEGIN
		BEGIN TRY	
		BEGIN
			SET @ConstraintName = ' '
			SELECT @TableId = id FROM sysobjects WHERE name = 'ProcessdefTable'
			SELECT @ConstraintName = name FROM SYSCONSTRAINTS A, SYSOBJECTS B WHERE A.constid = B.id AND B.xtype = 'PK'AND A.id = @TableId 
			
			IF NOT EXISTS ( SELECT * FROM sysObjects WHERE NAME = @ConstraintName)
			BEGIN
				EXECUTE('alter table ProcessdefTable add PRIMARY KEY (ProcessDefId,VersionNo)')
				PRINT 'alter table ProcessdefTable add PRIMARY KEY (ProcessDefId,VersionNo) IF CASE'
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''alter table ProcessdefTable add PRIMARY KEY (ProcessDefId,VersionNo) IF CASE'')')
			END
			ELSE
			BEGIN
				execute('alter table ProcessdefTable drop CONSTRAINT ' + @ConstraintName)
				EXECUTE('alter table ProcessdefTable add PRIMARY KEY (ProcessDefId,VersionNo)')
				PRINT 'alter table ProcessdefTable add PRIMARY KEY (ProcessDefId,VersionNo) ELSE CASE'
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''alter table ProcessdefTable add PRIMARY KEY (ProcessDefId,VersionNo) ELSE CASE'')')
			END
		END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''TABLE ProcessdefTable add PRIMARY KEY FAILED.'')')
			SELECT @ErrMessage = 'Block 190 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END
	
	BEGIN
		BEGIN TRY
		BEGIN
			SET @ConstraintName = ' '
			SELECT @TableId = id FROM sysobjects WHERE name = 'EXTDBFIELDDEFINITIONTABLE'
			SELECT @ConstraintName = name FROM SYSCONSTRAINTS A, SYSOBJECTS B WHERE A.constid = B.id AND B.xtype = 'PK'AND A.id = @TableId 
			
			IF NOT EXISTS ( SELECT * FROM sysObjects WHERE NAME = @ConstraintName)
			BEGIN
				EXECUTE('alter table EXTDBFIELDDEFINITIONTABLE add PRIMARY KEY (ProcessDefId,ExtObjId,FieldName)')
				PRINT 'alter table EXTDBFIELDDEFINITIONTABLE add PRIMARY KEY (ProcessDefId,ExtObjId,FieldName) IF CASE'
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''alter table EXTDBFIELDDEFINITIONTABLE add PRIMARY KEY (ProcessDefId,ExtObjId,FieldName) IF CASE'')')
			END
			ELSE
			BEGIN
				execute('alter table EXTDBFIELDDEFINITIONTABLE drop CONSTRAINT ' + @ConstraintName)
				EXECUTE('alter table EXTDBFIELDDEFINITIONTABLE add PRIMARY KEY (ProcessDefId,ExtObjId,FieldName)')
				PRINT 'alter table EXTDBFIELDDEFINITIONTABLE add PRIMARY KEY (ProcessDefId,ExtObjId,FieldName) ELSE CASE'
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''alter table EXTDBFIELDDEFINITIONTABLE add PRIMARY KEY (ProcessDefId,ExtObjId,FieldName) ELSE CASE'')')
			END
		END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''alter table EXTDBFIELDDEFINITIONTABLE drop CONSTRAINT FAILED.'')')
			SELECT @ErrMessage = 'Block 191 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
		
	BEGIN
		BEGIN TRY	
		BEGIN
			SET @ConstraintName = ' '
			SELECT @TableId = id FROM sysobjects WHERE name = 'ACTIONDEFTABLE'
			SELECT @ConstraintName = name FROM SYSCONSTRAINTS A, SYSOBJECTS B WHERE A.constid = B.id AND B.xtype = 'PK'AND A.id = @TableId 
			
			IF NOT EXISTS ( SELECT * FROM sysObjects WHERE NAME = @ConstraintName)
			BEGIN
				EXECUTE('alter table ACTIONDEFTABLE add CONSTRAINT PK_ACTIONDEFTABLE PRIMARY KEY(ProcessDefId,ActionId,ActivityId)')
				PRINT 'alter table ACTIONDEFTABLE add CONSTRAINT PK_ACTIONDEFTABLE PRIMARY KEY(ProcessDefId,ActionId,ActivityId) IF CASE'
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''alter table ACTIONDEFTABLE add CONSTRAINT PK_ACTIONDEFTABLE PRIMARY KEY(ProcessDefId,ActionId,ActivityId) IF CASE'')')
			END
			ELSE
			BEGIN
				execute('alter table ACTIONDEFTABLE drop CONSTRAINT ' + @ConstraintName)
				EXECUTE('alter table ACTIONDEFTABLE add CONSTRAINT PK_ACTIONDEFTABLE PRIMARY KEY(ProcessDefId,ActionId,ActivityId)')
				PRINT 'alter table ACTIONDEFTABLE add CONSTRAINT PK_ACTIONDEFTABLE PRIMARY KEY(ProcessDefId,ActionId,ActivityId) ELSE CASE'
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''alter table ACTIONDEFTABLE add CONSTRAINT PK_ACTIONDEFTABLE PRIMARY KEY(ProcessDefId,ActionId,ActivityId) ELSE CASE'')')
			END
		END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''lter table ACTIONDEFTABLE add CONSTRAINT PK_ACTIONDEFTABLE FAILED.'')')
			SELECT @ErrMessage = 'Block 192 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END
		
	BEGIN
		BEGIN TRY
		BEGIN
		SET @ConstraintName = ' '
			SELECT @TableId = id FROM sysobjects WHERE name = 'TODOLISTDEFTABLE'
			SELECT @ConstraintName = name FROM SYSCONSTRAINTS A, SYSOBJECTS B WHERE A.constid = B.id AND B.xtype = 'PK'AND A.id = @TableId 
			
			IF NOT EXISTS ( SELECT * FROM sysObjects WHERE NAME = @ConstraintName)
			BEGIN
				EXECUTE('alter table TODOLISTDEFTABLE add PRIMARY KEY (ProcessDefId, ToDoId)')
				PRINT 'alter table TODOLISTDEFTABLE add PRIMARY KEY (ProcessDefId, ToDoId) IF CASE'
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''alter table TODOLISTDEFTABLE add PRIMARY KEY (ProcessDefId, ToDoId) IF CASE'')')
			END
			ELSE
			BEGIN
				execute('alter table TODOLISTDEFTABLE drop CONSTRAINT ' + @ConstraintName)
				EXECUTE('alter table TODOLISTDEFTABLE add PRIMARY KEY (ProcessDefId, ToDoId)')
				PRINT 'alter table TODOLISTDEFTABLE add PRIMARY KEY (ProcessDefId, ToDoId) ELSE CASE'
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''alter table TODOLISTDEFTABLE add PRIMARY KEY (ProcessDefId, ToDoId) ELSE CASE'')')
			END
		END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''alter table TODOLISTDEFTABLE add PRIMARY KEY FAILED.'')')
			SELECT @ErrMessage = 'Block 193 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END
		
	BEGIN
		BEGIN TRY	
		BEGIN
			SET @ConstraintName = ' '
			SELECT @TableId = id FROM sysobjects WHERE name = 'TODOPICKLISTTABLE'
			SELECT @ConstraintName = name FROM SYSCONSTRAINTS A, SYSOBJECTS B WHERE A.constid = B.id AND B.xtype = 'PK'AND A.id = @TableId 
			
			IF NOT EXISTS ( SELECT * FROM sysObjects WHERE NAME = @ConstraintName)
			BEGIN
				EXECUTE('alter table TODOPICKLISTTABLE add CONSTRAINT PK_TODOPICKLISTTABLE PRIMARY KEY (ProcessDefId,ToDoId,PickListValue)')
				PRINT 'alter table TODOPICKLISTTABLE add CONSTRAINT PK_TODOPICKLISTTABLE PRIMARY KEY (ProcessDefId,ToDoId,PickListValue) IF CASE'
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''alter table TODOPICKLISTTABLE add CONSTRAINT PK_TODOPICKLISTTABLE PRIMARY KEY (ProcessDefId,ToDoId,PickListValue) IF CASE'')')
			END
			ELSE
			BEGIN
				execute('alter table TODOPICKLISTTABLE drop CONSTRAINT ' + @ConstraintName)
				EXECUTE('alter table TODOPICKLISTTABLE add CONSTRAINT PK_TODOPICKLISTTABLE PRIMARY KEY (ProcessDefId,ToDoId,PickListValue)')
				PRINT 'alter table TODOPICKLISTTABLE add CONSTRAINT PK_TODOPICKLISTTABLE PRIMARY KEY (ProcessDefId,ToDoId,PickListValue) ELSE CASE'
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''alter table TODOPICKLISTTABLE add CONSTRAINT PK_TODOPICKLISTTABLE PRIMARY KEY (ProcessDefId,ToDoId,PickListValue) ELSE CASE'')')
			END
		END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''lter table TODOPICKLISTTABLE add CONSTRAINT PK_TODOPICKLISTTABLE PRIMARY KEY  FAILED.'')')
			SELECT @ErrMessage = 'Block 194 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END
		
	BEGIN
		BEGIN TRY	
		BEGIN
			SET @ConstraintName = ' '
			SELECT @TableId = id FROM sysobjects WHERE name = 'EXCEPTIONDEFTABLE'
			SELECT @ConstraintName = name FROM SYSCONSTRAINTS A, SYSOBJECTS B WHERE A.constid = B.id AND B.xtype = 'PK'AND A.id = @TableId 
			
			IF NOT EXISTS ( SELECT * FROM sysObjects WHERE NAME = @ConstraintName)
			BEGIN
				EXECUTE('alter table EXCEPTIONDEFTABLE add PRIMARY KEY (ProcessDefId, ExceptionId)')
				PRINT 'alter table EXCEPTIONDEFTABLE add PRIMARY KEY (ProcessDefId, ExceptionId) IF CASE'
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''alter table EXCEPTIONDEFTABLE add PRIMARY KEY (ProcessDefId, ExceptionId) IF CASE'')')
			END
			ELSE
			BEGIN
				execute('alter table EXCEPTIONDEFTABLE drop CONSTRAINT ' + @ConstraintName)
				EXECUTE('alter table EXCEPTIONDEFTABLE add PRIMARY KEY (ProcessDefId, ExceptionId)')
				PRINT 'alter table EXCEPTIONDEFTABLE add PRIMARY KEY (ProcessDefId, ExceptionId) ELSE CASE'
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''alter table EXCEPTIONDEFTABLE add PRIMARY KEY (ProcessDefId, ExceptionId) ELSE CASE'')')
			END
		END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''alter table EXCEPTIONDEFTABLE add PRIMARY KEY  FAILED.'')')
			SELECT @ErrMessage = 'Block 195 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END
		
	BEGIN
		BEGIN TRY
		BEGIN
			SET @ConstraintName = ' '
			SELECT @TableId = id FROM sysobjects WHERE name = 'PROCESSINITABLE'
			SELECT @ConstraintName = name FROM SYSCONSTRAINTS A, SYSOBJECTS B WHERE A.constid = B.id AND B.xtype = 'PK'AND A.id = @TableId 
			
			IF NOT EXISTS ( SELECT * FROM sysObjects WHERE NAME = @ConstraintName)
			BEGIN
				EXECUTE('alter table PROCESSINITABLE add CONSTRAINT PK_ProcessINITable PRIMARY KEY(ProcessDefId)')
				PRINT 'alter table PROCESSINITABLE add CONSTRAINT PK_ProcessINITable PRIMARY KEY(ProcessDefId) IF CASE'
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''alter table PROCESSINITABLE add CONSTRAINT PK_ProcessINITable PRIMARY KEY(ProcessDefId) IF CASE'')')
			END
			ELSE
			BEGIN
				execute('alter table PROCESSINITABLE drop CONSTRAINT ' + @ConstraintName)
				EXECUTE('alter table PROCESSINITABLE add CONSTRAINT PK_ProcessINITable PRIMARY KEY(ProcessDefId)')
				PRINT 'alter table PROCESSINITABLE add CONSTRAINT PK_ProcessINITable PRIMARY KEY(ProcessDefId) ELSE CASE'
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''alter table PROCESSINITABLE add CONSTRAINT PK_ProcessINITable PRIMARY KEY(ProcessDefId) ELSE CASE'')')
			END
		END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''alter table PROCESSINITABLE add CONSTRAINT PK_ProcessINITable  FAILED.'')')
			SELECT @ErrMessage = 'Block 196 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END
		
	BEGIN
		BEGIN TRY	
		BEGIN
			SET @ConstraintName = ' '
			SELECT @TableId = id FROM sysobjects WHERE name = 'PRINTFAXEMAILTABLE'
			SELECT @ConstraintName = name FROM SYSCONSTRAINTS A, SYSOBJECTS B WHERE A.constid = B.id AND B.xtype = 'PK'AND A.id = @TableId 
			
			IF NOT EXISTS ( SELECT * FROM sysObjects WHERE NAME = @ConstraintName)
			BEGIN
				EXECUTE('alter table PRINTFAXEMAILTABLE add CONSTRAINT PK_PRINTFAXEMAILTABLE PRIMARY KEY(ProcessDefId,PFEInterfaceId)')
				PRINT 'alter table PRINTFAXEMAILTABLE add CONSTRAINT PK_PRINTFAXEMAILTABLE PRIMARY KEY(ProcessDefId,PFEInterfaceId) IF CASE'
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''alter table PRINTFAXEMAILTABLE add CONSTRAINT PK_PRINTFAXEMAILTABLE PRIMARY KEY(ProcessDefId,PFEInterfaceId) IF CASE'')')
			END
			ELSE
			BEGIN
				execute('alter table PRINTFAXEMAILTABLE drop CONSTRAINT ' + @ConstraintName)
				EXECUTE('alter table PRINTFAXEMAILTABLE add CONSTRAINT PK_PRINTFAXEMAILTABLE PRIMARY KEY(ProcessDefId,PFEInterfaceId)')
				PRINT 'alter table PRINTFAXEMAILTABLE add CONSTRAINT PK_PRINTFAXEMAILTABLE PRIMARY KEY(ProcessDefId,PFEInterfaceId) ELSE CASE'
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''alter table PRINTFAXEMAILTABLE add CONSTRAINT PK_PRINTFAXEMAILTABLE PRIMARY KEY(ProcessDefId,PFEInterfaceId) ELSE CASE'')')
			END
		END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''alter table PRINTFAXEMAILTABLE add CONSTRAINT PK_PRINTFAXEMAILTABLE  FAILED.'')')
			SELECT @ErrMessage = 'Block 197 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END
		
	BEGIN
		BEGIN TRY	
		BEGIN
			SET @ConstraintName = ' '
			SELECT @TableId = id FROM sysobjects WHERE name = 'WFFORM_TABLE'
			SELECT @ConstraintName = name FROM SYSCONSTRAINTS A, SYSOBJECTS B WHERE A.constid = B.id AND B.xtype = 'PK'AND A.id = @TableId 
			Print 'ConstraintName for form is' + @ConstraintName
			IF NOT EXISTS ( SELECT * FROM sysObjects WHERE NAME = @ConstraintName)
			BEGIN
				EXECUTE('alter table WFFORM_TABLE add CONSTRAINT PK_WFFORM_TABLE PRIMARY KEY(ProcessDefID,FormId,DeviceType)')
				PRINT 'alter table WFFORM_TABLE add CONSTRAINT PK_WFFORM_TABLE PRIMARY KEY(ProcessDefID,FormId,DeviceType) IF CASE'
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''alter table WFFORM_TABLE add CONSTRAINT PK_WFFORM_TABLE PRIMARY KEY(ProcessDefID,FormId) IF CASE'')')
			END
			ELSE
			BEGIN
				execute('alter table WFFORM_TABLE drop CONSTRAINT ' + @ConstraintName)
				EXECUTE('alter table WFFORM_TABLE add CONSTRAINT PK_WFFORM_TABLE PRIMARY KEY(ProcessDefID,FormId,DeviceType)')
				PRINT 'alter table WFFORM_TABLE add CONSTRAINT PK_WFFORM_TABLE PRIMARY KEY(ProcessDefID,FormId,DeviceType) ELSE CASE'
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''alter table WFFORM_TABLE add CONSTRAINT PK_WFFORM_TABLE PRIMARY KEY(ProcessDefID,FormId) ELSE CASE'')')
			END
		END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''alter table WFFORM_TABLE add CONSTRAINT PK_WFFORM_TABLE PRIMARY KEY  FAILED.'')')
			SELECT @ErrMessage = 'Block 198 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END
	
	BEGIN
		BEGIN TRY	
		BEGIN
			SET @ConstraintName = ' '
			SELECT @TableId = id FROM sysobjects WHERE name = 'InterfaceDescLanguageTable'
			SELECT @ConstraintName = name FROM SYSCONSTRAINTS A, SYSOBJECTS B WHERE A.constid = B.id AND B.xtype = 'PK'AND A.id = @TableId 
			
			IF NOT EXISTS ( SELECT * FROM sysObjects WHERE NAME = @ConstraintName)
			BEGIN
				EXECUTE('alter table InterfaceDescLanguageTable add CONSTRAINT PK_InterfaceDescLanguageTable PRIMARY KEY (ProcessDefId,ElementId,InterfaceID)')
				PRINT 'alter table InterfaceDescLanguageTable add CONSTRAINT PK_InterfaceDescLanguageTable PRIMARY KEY (ProcessDefId,ElementId,InterfaceID) IF CASE'
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''alter table InterfaceDescLanguageTable add CONSTRAINT PK_InterfaceDescLanguageTable PRIMARY KEY (ProcessDefId,ElementId,InterfaceID) IF CASE'')')
			END
			ELSE
			BEGIN
				execute('alter table InterfaceDescLanguageTable drop CONSTRAINT ' + @ConstraintName)
				EXECUTE('alter table InterfaceDescLanguageTable add CONSTRAINT PK_InterfaceDescLanguageTable PRIMARY KEY (ProcessDefId,ElementId,InterfaceID)')
				PRINT 'alter table InterfaceDescLanguageTable add CONSTRAINT PK_InterfaceDescLanguageTable PRIMARY KEY (ProcessDefId,ElementId,InterfaceID) ELSE CASE'
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''alter table InterfaceDescLanguageTable add CONSTRAINT PK_InterfaceDescLanguageTable PRIMARY KEY (ProcessDefId,ElementId,InterfaceID) ELSE CASE'')')
			END
		END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''alter table InterfaceDescLanguageTable add CONSTRAINT PK_InterfaceDescLanguageTable  FAILED.'')')
			SELECT @ErrMessage = 'Block 199 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END
		
	BEGIN
		BEGIN TRY	
		BEGIN
			SET @ConstraintName = ' '
			SELECT @TableId = id FROM sysobjects WHERE name = 'WFSwimLaneTable'
			SELECT @ConstraintName = name FROM SYSCONSTRAINTS A, SYSOBJECTS B WHERE A.constid = B.id AND B.xtype = 'PK'AND A.id = @TableId 
			
			IF NOT EXISTS ( SELECT * FROM sysObjects WHERE NAME = @ConstraintName)
			BEGIN
				EXECUTE('alter table WFSwimLaneTable add PRIMARY KEY ( ProcessDefId, SwimLaneId)')
				PRINT 'alter table WFSwimLaneTable add PRIMARY KEY ( ProcessDefId, SwimLaneId) IF CASE'
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''alter table WFSwimLaneTable add PRIMARY KEY ( ProcessDefId, SwimLaneId) IF CASE'')')
			END
			ELSE
			BEGIN
				execute('alter table WFSwimLaneTable drop CONSTRAINT ' + @ConstraintName)
				EXECUTE('alter table WFSwimLaneTable add PRIMARY KEY ( ProcessDefId, SwimLaneId)')
				PRINT 'alter table WFSwimLaneTable add PRIMARY KEY ( ProcessDefId, SwimLaneId) ELSE CASE'
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''alter table WFSwimLaneTable add PRIMARY KEY ( ProcessDefId, SwimLaneId) ELSE CASE'')')
			END
		END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''alter table WFSwimLaneTable add PRIMARY KEY  FAILED.'')')
			SELECT @ErrMessage = 'Block 200 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END
		
	BEGIN
		BEGIN TRY	
		BEGIN
			SET @ConstraintName = ' '
			SELECT @TableId = id FROM sysobjects WHERE name = 'WFSwimLaneTable'
			SELECT @ConstraintName = name FROM SYSCONSTRAINTS A, SYSOBJECTS B WHERE A.constid = B.id AND B.xtype = 'UQ' AND A.id = @TableId 
			
			IF NOT EXISTS ( SELECT * FROM sysObjects WHERE NAME = @ConstraintName)
			BEGIN
				EXECUTE('alter table WFSwimLaneTable add UNIQUE(ProcessDefId, SwimLaneText)')
				PRINT 'alter table WFSwimLaneTable add UNIQUE(ProcessDefId, SwimLaneText) IF CASE'
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''alter table WFSwimLaneTable add UNIQUE(ProcessDefId, SwimLaneText) IF CASE'')')
			END
			ELSE
			BEGIN
				execute('alter table WFSwimLaneTable drop CONSTRAINT ' + @ConstraintName)
				EXECUTE('alter table WFSwimLaneTable add UNIQUE(ProcessDefId, SwimLaneText)')
				PRINT 'alter table WFSwimLaneTable add UNIQUE(ProcessDefId, SwimLaneText) ELSE CASE'
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''alter table WFSwimLaneTable add UNIQUE(ProcessDefId, SwimLaneText) ELSE CASE'')')
			END
		END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''alter table WFSwimLaneTable add UNIQUE  FAILED.'')')
			SELECT @ErrMessage = 'Block 201 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END
		
	BEGIN
		BEGIN TRY
			BEGIN
				SET @ConstraintName = ' '
				SELECT @TableId = id FROM sysobjects WHERE name = 'WFDataMapTable'
				SELECT @ConstraintName = name FROM SYSCONSTRAINTS A, SYSOBJECTS B WHERE A.constid = B.id AND B.xtype = 'PK' AND A.id = @TableId 
				
				IF NOT EXISTS ( SELECT * FROM sysObjects WHERE NAME = @ConstraintName)
				BEGIN
					Execute ('alter table WFDataMapTable add PRIMARY KEY (ProcessDefId, ActivityId, OrderId)')
					PRINT 'alter table WFDataMapTable add PRIMARY KEY (ProcessDefId, ActivityId, OrderId) IF CASE'
					EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''alter table WFDataMapTable add PRIMARY KEY (ProcessDefId, ActivityId, OrderId) IF CASE'')')
				END
				ELSE
				BEGIN
					execute('alter table WFDataMapTable drop CONSTRAINT ' + @ConstraintName)
					execute('alter table WFDataMapTable add PRIMARY KEY (ProcessDefId, ActivityId, OrderId)')
					PRINT 'alter table WFDataMapTable add PRIMARY KEY (ProcessDefId, ActivityId, OrderId) ELSE CASE'
					EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''alter table WFDataMapTable add PRIMARY KEY (ProcessDefId, ActivityId, OrderId) ELSE CASE'')')
				END
			END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''alter table WFDataMapTable add PRIMARY KEY  FAILED.'')')
			SELECT @ErrMessage = 'Block 202 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
			
	BEGIN
		BEGIN TRY		
			BEGIN
				SET @ConstraintName = ' '
				SELECT @TableId = id FROM sysobjects WHERE name = 'WFExtInterfaceConditionTable'
				SELECT @ConstraintName = name FROM SYSCONSTRAINTS A, SYSOBJECTS B WHERE A.constid = B.id AND B.xtype = 'PK'AND A.id = @TableId 
				
				IF NOT EXISTS ( SELECT * FROM sysObjects WHERE NAME = @ConstraintName)
				BEGIN
					EXECUTE('alter table WFExtInterfaceConditionTable add PRIMARY KEY (ProcessDefId, InterFaceType, RuleId, ConditionOrderId)')
					PRINT 'alter table WFExtInterfaceConditionTable add PRIMARY KEY (ProcessDefId, InterFaceType, RuleId, ConditionOrderId) IF CASE'
					EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''alter table WFExtInterfaceConditionTable add PRIMARY KEY (ProcessDefId, InterFaceType, RuleId, ConditionOrderId) IF CASE'')')
				END
				ELSE
				BEGIN
					execute('alter table WFExtInterfaceConditionTable drop CONSTRAINT ' + @ConstraintName)
					EXECUTE('alter table WFExtInterfaceConditionTable add PRIMARY KEY (ProcessDefId, InterFaceType, RuleId, ConditionOrderId)')
					PRINT 'alter table WFExtInterfaceConditionTable add PRIMARY KEY (ProcessDefId, InterFaceType, RuleId, ConditionOrderId) ELSE CASE'
					EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''alter table WFExtInterfaceConditionTable add PRIMARY KEY (ProcessDefId, InterFaceType, RuleId, ConditionOrderId) ELSE CASE'')')
				END
			END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''alter table WFExtInterfaceConditionTable add PRIMARY KEY  FAILED.'')')
			SELECT @ErrMessage = 'Block 203 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
			
			/*......................................... Added by Mohnish starts ........................................*/
	BEGIN
		BEGIN TRY		
			IF  EXISTS ( SELECT * FROM sysColumns 
				WHERE 
				id = (SELECT id FROM sysObjects WHERE NAME = 'MAILTRIGGERTABLE')
				AND  NAME = 'ExtObjIdMailPriority'
				)
			BEGIN
			SELECT @ConstraintName = Name FROM SYS.DEFAULT_CONSTRAINTS WHERE PARENT_OBJECT_ID = OBJECT_ID('MAILTRIGGERTABLE') AND PARENT_COLUMN_ID = (SELECT column_id FROM sys.columns WHERE NAME = N'ExtObjIdMailPriority' AND object_id = OBJECT_ID(N'MAILTRIGGERTABLE'))
				IF (@ConstraintName IS NOT NULL AND (LEN(@ConstraintName) > 0))
				BEGIN
					EXECUTE('ALTER TABLE MAILTRIGGERTABLE DROP CONSTRAINT ' + @ConstraintName)
					PRINT 'ALTER TABLE MAILTRIGGERTABLE DROP OLD CONSTRAINT ' 
					EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE MAILTRIGGERTABLE DROP OLD CONSTRAINT'')')
				END	
				EXECUTE('alter table MAILTRIGGERTABLE add CONSTRAINT df_MTT_ExtObjIdMailPriority DEFAULT 0 FOR ExtObjIdMailPriority')
				PRINT 'alter table MAILTRIGGERTABLE add CONSTRAINT df_MTT_ExtObjIdMailPriority DEFAULT 0 FOR ExtObjIdMailPriority'	
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''alter table MAILTRIGGERTABLE add CONSTRAINT df_MTT_ExtObjIdMailPriority DEFAULT 0 FOR ExtObjIdMailPriority'')')
			END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''alter table MAILTRIGGERTABLE add CONSTRAINT df_MTT_ExtObjIdMailPriority  FAILED.'')')
			SELECT @ErrMessage = 'Block 204 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
			IF  EXISTS ( SELECT * FROM sysColumns 
				WHERE 
				id = (SELECT id FROM sysObjects WHERE NAME = 'MAILTRIGGERTABLE')
				AND  NAME = 'VariableIdMailPriority'
				)
			BEGIN
			SELECT @ConstraintName = Name FROM SYS.DEFAULT_CONSTRAINTS WHERE PARENT_OBJECT_ID = OBJECT_ID('MAILTRIGGERTABLE') AND PARENT_COLUMN_ID = (SELECT column_id FROM sys.columns WHERE NAME = N'VariableIdMailPriority' AND object_id = OBJECT_ID(N'MAILTRIGGERTABLE'))
				IF (@ConstraintName IS NOT NULL AND (LEN(@ConstraintName) > 0))
				BEGIN
					EXECUTE('ALTER TABLE MAILTRIGGERTABLE DROP CONSTRAINT ' + @ConstraintName)
					PRINT 'ALTER TABLE MAILTRIGGERTABLE DROP OLD CONSTRAINT ' 
					EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE MAILTRIGGERTABLE DROP OLD CONSTRAINT '')')
				END	
				EXECUTE('alter table MAILTRIGGERTABLE add CONSTRAINT df_MTT_VariableIdMailPriority DEFAULT 0 FOR VariableIdMailPriority')
				PRINT 'alter table MAILTRIGGERTABLE add CONSTRAINT df_MTT_VariableIdMailPriority DEFAULT 0 FOR VariableIdMailPriority'
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''alter table MAILTRIGGERTABLE add CONSTRAINT df_MTT_VariableIdMailPriority DEFAULT 0 FOR VariableIdMailPriority'')')
			END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''alter table MAILTRIGGERTABLE add CONSTRAINT df_MTT_VariableIdMailPriority FAILED.'')')
			SELECT @ErrMessage = 'Block 205 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
			
	BEGIN
		BEGIN TRY		
			IF  EXISTS ( SELECT * FROM sysColumns 
				WHERE 
				id = (SELECT id FROM sysObjects WHERE NAME = 'MAILTRIGGERTABLE')
				AND  NAME = 'VarFieldIdMailPriority'
				)
			BEGIN
			SELECT @ConstraintName = Name FROM SYS.DEFAULT_CONSTRAINTS WHERE PARENT_OBJECT_ID = OBJECT_ID('MAILTRIGGERTABLE') AND PARENT_COLUMN_ID = (SELECT column_id FROM sys.columns WHERE NAME = N'VarFieldIdMailPriority' AND object_id = OBJECT_ID(N'MAILTRIGGERTABLE'))
				IF (@ConstraintName IS NOT NULL AND (LEN(@ConstraintName) > 0))
				BEGIN
					EXECUTE('ALTER TABLE MAILTRIGGERTABLE DROP CONSTRAINT ' + @ConstraintName)
					PRINT 'ALTER TABLE MAILTRIGGERTABLE DROP OLD CONSTRAINT '
					EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE MAILTRIGGERTABLE DROP OLD CONSTRAINT'')')			
				END	
				EXECUTE('alter table MAILTRIGGERTABLE add CONSTRAINT df_MTT_VarFieldIdMailPriority DEFAULT 0 FOR VarFieldIdMailPriority')
				PRINT 'alter table MAILTRIGGERTABLE add CONSTRAINT df_MTT_VarFieldIdMailPriority DEFAULT 0 FOR VarFieldIdMailPriority'
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''alter table MAILTRIGGERTABLE add CONSTRAINT df_MTT_VarFieldIdMailPriority DEFAULT 0 FOR VarFieldIdMailPriority'')')
			END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''alter table MAILTRIGGERTABLE add CONSTRAINT df_MTT_VarFieldIdMailPriority FAILED.'')')
			SELECT @ErrMessage = 'Block 206 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
			
			/*BEGIN
				IF NOT EXISTS(SELECT * FROM USERDIVERSIONTABLE WHERE Diverteduserindex is null)
				BEGIN
					EXECUTE('Alter table USERDIVERSIONTABLE alter column Diverteduserindex INT NOT NULL')
					PRINT 'Alter table USERDIVERSIONTABLE alter column Diverteduserindex INT NOT NULL'
					EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Alter table USERDIVERSIONTABLE alter column Diverteduserindex INT NOT NULL'')')
				END
			END
			
			BEGIN
				IF NOT EXISTS(SELECT * FROM USERDIVERSIONTABLE WHERE AssignedUserindex is null)
				BEGIN
					EXECUTE('Alter table USERDIVERSIONTABLE alter column AssignedUserindex INT NOT NULL')
					PRINT 'Alter table USERDIVERSIONTABLE alter column AssignedUserindex INT NOT NULL'
					EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Alter table USERDIVERSIONTABLE alter column AssignedUserindex INT NOT NULL'')')
				END
			END
			
			BEGIN
				IF NOT EXISTS(SELECT * FROM USERWORKAUDITTABLE WHERE Userindex is null)
				BEGIN
					EXECUTE('Alter table USERWORKAUDITTABLE alter column Userindex INT NOT NULL')
					PRINT 'Alter table USERWORKAUDITTABLE alter column Userindex INT NOT NULL'
					EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Alter table USERWORKAUDITTABLE alter column Userindex INT NOT NULL'')')
				END
			END
			
			BEGIN
				IF NOT EXISTS(SELECT * FROM USERWORKAUDITTABLE WHERE Auditoruserindex is null)
				BEGIN
					EXECUTE('Alter table USERWORKAUDITTABLE alter column Auditoruserindex INT NOT NULL')
					PRINT 'Alter table USERWORKAUDITTABLE alter column Auditoruserindex INT NOT NULL'
					EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Alter table USERWORKAUDITTABLE alter column Auditoruserindex INT NOT NULL'')')
				END
			END
			
			BEGIN
				IF NOT EXISTS(SELECT * FROM PREFERREDQUEUETABLE WHERE userindex is null)
				BEGIN
					EXECUTE('Alter table PREFERREDQUEUETABLE alter column userindex INT NOT NULL')
					PRINT 'Alter table PREFERREDQUEUETABLE alter column userindex INT NOT NULL'
					EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Alter table PREFERREDQUEUETABLE alter column userindex INT NOT NULL'')')
				END
			END
			
			BEGIN
				IF NOT EXISTS(SELECT * FROM USERPREFERENCESTABLE WHERE Userid is null)
				BEGIN
					EXECUTE('Alter table USERPREFERENCESTABLE alter column Userid INT NOT NULL')
					PRINT 'Alter table USERPREFERENCESTABLE alter column Userid INT NOT NULL'
					EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Alter table USERPREFERENCESTABLE alter column Userid INT NOT NULL'')')
				END
			END*/
			
	BEGIN
		BEGIN TRY		
			IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'WFMailQueueTable' AND COLUMN_NAME = 'TaskId' AND DATA_TYPE = 'BIGINT')
			BEGIN
				IF EXISTS (SELECT 1 FROM SYSObjects WHERE NAME = 'WFMailQueueTable' AND xType = 'U')
				BEGIN
					SET @ConstraintName = ''
					SELECT @ConstraintName =  CONSTRAINT_NAME FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME = 'WFMailQueueTable' AND CONSTRAINT_TYPE = 'PRIMARY KEY'
					IF (@ConstraintName IS NOT NULL AND (LEN(@ConstraintName) > 0))
					BEGIN
						EXECUTE ('ALTER TABLE WFMailQueueTable DROP CONSTRAINT ' + @ConstraintName)
						PRINT 'Table WFMailQueueTable altered, Primary Key on WFMailQueueTable is dropped.'
						EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Table WFMailQueueTable altered, Primary Key on WFMailQueueTable is dropped.'')')
					END
		
					EXECUTE('ALTER TABLE WFMailQueueTable ALTER COLUMN TaskId BIGINT NOT NULL')
					PRINT 'Table WFMailQueueTable altered with Column TaskId changed to BIGINT'
					EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Table WFMailQueueTable altered with Column TaskId changed to BIGINT'')')
					EXECUTE('ALTER TABLE WFMailQueueTable ADD PRIMARY KEY (TaskId)')
					PRINT 'Table WFMailQueueTable altered, Primary Key created.'
					EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Table WFMailQueueTable altered, Primary Key created.'')')
				END
			END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFMailQueueTable ADD PRIMARY KEY taskid FAILED.'')')
			SELECT @ErrMessage = 'Block 207 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END		
	
	BEGIN
		BEGIN TRY	
			IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'WFMailQueueHistoryTable' AND COLUMN_NAME = 'TaskId' AND DATA_TYPE = 'BIGINT')
			BEGIN
				IF EXISTS (SELECT 1 FROM SYSObjects WHERE NAME = 'WFMailQueueHistoryTable' AND xType = 'U')
				BEGIN
					SET @ConstraintName = ''
					SELECT @ConstraintName =  CONSTRAINT_NAME FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME = 'WFMailQueueHistoryTable' AND CONSTRAINT_TYPE = 'PRIMARY KEY'
					IF (@ConstraintName IS NOT NULL AND (LEN(@ConstraintName) > 0))
					BEGIN
						EXECUTE ('ALTER TABLE WFMailQueueHistoryTable DROP CONSTRAINT ' + @ConstraintName)
						PRINT 'Table WFMailQueueHistoryTable altered, Primary Key on WFMailQueueHistoryTable is dropped.'
						EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Table WFMailQueueHistoryTable altered, Primary Key on WFMailQueueHistoryTable is dropped.'')')
					END
		
					EXECUTE('ALTER TABLE WFMailQueueHistoryTable ALTER COLUMN TaskId BIGINT NOT NULL')
					PRINT 'Table WFMailQueueHistoryTable altered with Column TaskId changed to BIGINT'
					EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Table WFMailQueueHistoryTable altered with Column TaskId changed to BIGINT'')')
		
					EXECUTE('ALTER TABLE WFMailQueueHistoryTable ADD PRIMARY KEY (TaskId)')
					PRINT 'Table WFMailQueueHistoryTable altered, Primary Key created.'
					EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Table WFMailQueueHistoryTable altered, Primary Key created.'')')
				END
			END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFMailQueueHistoryTable ADD PRIMARY KEY taskid FAILED.'')')
			SELECT @ErrMessage = 'Block 208 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
		
			/*......................................... Added by Mohnish ends ..........................................*/
			
			/*...........................................Changes done by Kirti...........................................*/
	BEGIN
		BEGIN TRY		
			BEGIN
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFCommentsTable DROP CONSTRAINT started.'')')
				SET @ConstraintName = ''
				SELECT @ConstraintName =  constraint_name FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE table_name = 'WFCommentsTable' AND constraint_type = 'CHECK'
				IF (@ConstraintName IS NOT NULL AND (LEN(@ConstraintName) > 0))
				BEGIN
					EXECUTE ('ALTER TABLE WFCommentsTable DROP CONSTRAINT ' + @ConstraintName)
				END
				/* In case user is upgrading the cabinet from 4.0 to 4.0 SP1*/
				EXECUTE('ALTER TABLE WFCommentsTable ADD CHECK(CommentsType IN (1, 2, 3, 4,5,6,7,8,9,10))')
			END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFCommentsTable DROP CONSTRAINT FAILED.'')')
			SELECT @ErrMessage = 'Block 209 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
			BEGIN
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFActionStatusTable ADD CHECK constraint started.'')')
				SET @ConstraintName = ''
				select @ConstraintName =  constraint_name from INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE where table_name = 'WFActionStatusTable' AND COLUMN_NAME='Type'
				IF (@ConstraintName IS NOT NULL AND (LEN(@ConstraintName) > 0))  
				BEGIN
					EXECUTE ('ALTER TABLE WFActionStatusTable DROP CONSTRAINT ' + @ConstraintName)
				END
				EXECUTE('ALTER TABLE WFActionStatusTable ADD CHECK(Type IN (''C'', ''S'', ''R''))')
			END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFActionStatusTable ADD CHECK constraint FAILED.'')')
			SELECT @ErrMessage = 'Block 210 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
			BEGIN
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFMESSAGETABLE ADD CHECK constraint started.'')')
				SET @ConstraintName = ''
				SELECT @ConstraintName =  constraint_name FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE table_name = 'WFMESSAGETABLE' AND constraint_type = 'CHECK'
				IF (@ConstraintName IS NOT NULL AND (LEN(@ConstraintName) > 0))
				BEGIN
					EXECUTE ('ALTER TABLE WFMESSAGETABLE DROP CONSTRAINT ' + @ConstraintName)
				END
				EXECUTE('ALTER TABLE WFMESSAGETABLE ADD CHECK(status IN (''N'',''F''))')
			END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFMESSAGETABLE ADD CHECK constraint FAILED.'')')
			SELECT @ErrMessage = 'Block 211 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END		
			
			
			
			
			/*.....................................End of Changes done by Kirti...........................................*/
			
			
			
			/*......................................... End of Constraints Addition .....................................*/
			
		
			/*............................... Modify old Trigger .....................................................*/
	BEGIN
		BEGIN TRY		
			IF OBJECT_ID('WF_USR_DEL', 'TR') IS NOT NULL
			BEGIN
				DROP TRIGGER WF_USR_DEL
			END
			IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id('pdbUser') AND xType='U')
			Begin
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE TRIGGER WF_USR_DEL FAILED started.'')')
				EXECUTE('
					CREATE TRIGGER WF_USR_DEL 
					on PDBUSER 
					AFTER UPDATE 
					AS
					DECLARE @Assgnid INT,
						@DeletedFlag NVARCHAR(1)	
					IF(UPDATE(DeletedFlag))
					BEGIN
						SELECT @Assgnid = DELETED.UserIndex, @DeletedFlag = INSERTED.DeletedFlag FROM INSERTED,DELETED
						IF(@DeletedFlag = ''Y'')
						BEGIN
							
							UPDATE WFInstrumentTable 
							SET	AssignedUser = NULL, AssignmentType = NULL,	LockStatus = ''N'' , 
							LockedByName = NULL,LockedTime = NULL , Q_UserId = 0 ,
							QueueName = (SELECT QUEUEDEFTABLE.QueueName 
							FROM   QUEUESTREAMTABLE , QUEUEDEFTABLE
							WHERE  QUEUESTREAMTABLE.QueueID = QUEUEDEFTABLE.QueueID 
							AND    StreamID = Q_StreamID
							AND    QUEUESTREAMTABLE.ProcessDefId = WFInstrumentTable.ProcessDefId
							AND    QUEUESTREAMTABLE.ActivityId = WFInstrumentTable.ActivityId) ,
							QueueType = (SELECT QUEUEDEFTABLE.QueueType 
									FROM   QUEUESTREAMTABLE , QUEUEDEFTABLE
									WHERE  QUEUESTREAMTABLE.QueueID = QUEUEDEFTABLE.QueueID 
									AND    StreamID = Q_StreamID
									AND QUEUESTREAMTABLE.ProcessDefId = WFInstrumentTable.ProcessDefId
									AND QUEUESTREAMTABLE.ActivityId = WFInstrumentTable.ActivityId) ,
									Q_QueueID = (SELECT QueueId 
									FROM QUEUESTREAMTABLE 
									WHERE StreamID = Q_StreamID
									AND QUEUESTREAMTABLE.ProcessDefId = WFInstrumentTable.ProcessDefId
									AND QUEUESTREAMTABLE.ActivityId = WFInstrumentTable.ActivityId)	
							WHERE Q_UserId = @Assgnid AND RoutingStatus =''N'' AND LockStatus = ''N''
					
							UPDATE WFInstrumentTable 
							SET	AssignedUser = NULL, AssignmentType = NULL, LockStatus = ''N'' ,
								LockedByName = NULL, LockedTime = NULL , Q_UserId = 0 
								WHERE  AssignmentType != ''F'' AND Q_UserId = @Assgnid AND LockStatus = ''N'' AND RoutingStatus = ''N''
							
							DELETE FROM QUEUEUSERTABLE  WHERE UserID = @Assgnid AND Associationtype = 0
							DELETE FROM USERQUEUETABLE  WHERE UserID = @Assgnid
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
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE TRIGGER WF_USR_DEL FAILED.'')')
			SELECT @ErrMessage = 'Block 212 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
			
			
			/*............................. End  of modify Trigger ..................................................*/
			
			/*..............................Dropping Old  Triggers by Mohnish........................................*/
	BEGIN
		BEGIN TRY		
			IF OBJECT_ID('WF_UTIL_UNREGISTER', 'TR') IS NOT NULL
			BEGIN
				DROP TRIGGER WF_UTIL_UNREGISTER
				PRINT 'Trigger WF_UTIL_UNREGISTER Dropped'
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Trigger WF_UTIL_UNREGISTER Dropped'')')
			END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''DROP TRIGGER WF_UTIL_UNREGISTER FAILED.'')')
			SELECT @ErrMessage = 'Block 213 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END		
	
	BEGIN
		BEGIN TRY
			IF OBJECT_ID('TR_LOG_PDBCONNECTION', 'TR') IS NOT NULL
			BEGIN
				DROP TRIGGER TR_LOG_PDBCONNECTION
				PRINT 'Trigger TR_LOG_PDBCONNECTION Dropped'
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Trigger TR_LOG_PDBCONNECTION Dropped'')')
			END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''DROP TRIGGER TR_LOG_PDBCONNECTION FAILED.'')')
			SELECT @ErrMessage = 'Block 214 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
			
			/*..............................Dropping Old  Triggers by Mohnish Ends ..................................*/
			
/*..		................................. Adding new Indexes  ...................................................*/
			
	BEGIN
		BEGIN TRY	
			IF NOT EXISTS (SELECT *	FROM sysindexes	WHERE id = OBJECT_ID('ActivityTable')
				AND name = 'IDX1_ActivityTable') 
			BEGIN
				
				EXECUTE('CREATE INDEX IDX1_ActivityTable ON ActivityTable (ActivityType)')
				EXECUTE('CREATE INDEX IDX2_QueueStreamTable ON QueueStreamTable (Activityid, Streamid)')
				PRINT 'INDEXES CREATED SUCCESSFULLY'
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''INDEXES CREATED SUCCESSFULLY'')')
		
			END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE INDEX IDX1_ActivityTable ON ActivityTable FAILED.'')')
			SELECT @ErrMessage = 'Block 215 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
			/*.................................. Added by Mohnish ..................................................*/
			
	BEGIN
		BEGIN TRY					
			IF NOT EXISTS(SELECT * FROM sys.indexes
				WHERE name='IDXMIGRATION_WFINSTRUMENTTABLE'
				AND object_id = OBJECT_ID('WFINSTRUMENTTABLE')
						)
			BEGIN
				EXECUTE('CREATE INDEX IDXMIGRATION_WFINSTRUMENTTABLE ON WFINSTRUMENTTABLE(PROCESSINSTANCESTATE, CREATEDDATETIME, PROCESSINSTANCEID, WORKITEMID, PROCESSDEFID)')
				PRINT 'INDEX IDXMIGRATION_WFINSTRUMENTTABLE CREATED SUCCESSFULLY'
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''INDEXES CREATED SUCCESSFULLY'')')
			END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE INDEX IDXMIGRATION_WFINSTRUMENTTABLE ON WFINSTRUMENTTABLE FAILED.'')')
			SELECT @ErrMessage = 'Block 216 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
				
	BEGIN
		BEGIN TRY		
			IF NOT EXISTS(SELECT * FROM sys.indexes
				WHERE name='IDX1_RTACTIVITYINTERFACEASSOCTABLE'
				AND object_id = OBJECT_ID('RTACTIVITYINTERFACEASSOCTABLE')
						)
			BEGIN
				EXECUTE('CREATE INDEX IDX1_RTACTIVITYINTERFACEASSOCTABLE ON RTACTIVITYINTERFACEASSOCTABLE(PROCESSINSTANCEID,WorkitemId)')
				PRINT 'INDEX IDX1_RTACTIVITYINTERFACEASSOCTABLE CREATED SUCCESSFULLY'
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''INDEXES CREATED SUCCESSFULLY'')')
			END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE INDEX IDX1_RTACTIVITYINTERFACEASSOCTABLE ON RTACTIVITYINTERFACEASSOCTABLE FAILED.'')')
			SELECT @ErrMessage = 'Block 217 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END		
	
	BEGIN
		BEGIN TRY
			IF NOT EXISTS(SELECT * FROM sys.indexes
				WHERE name='IDX1_WFRTTaskInterfaceAssocTable'
				AND object_id = OBJECT_ID('WFRTTaskInterfaceAssocTable')
						)
			BEGIN
				EXECUTE('CREATE INDEX IDX1_WFRTTaskInterfaceAssocTable ON WFRTTaskInterfaceAssocTable(PROCESSINSTANCEID,WorkitemId)')
		
				PRINT 'INDEX IDX1_WFRTTaskInterfaceAssocTable CREATED SUCCESSFULLY'
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''INDEXES CREATED SUCCESSFULLY'')')
			END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE INDEX IDX1_WFRTTaskInterfaceAssocTable ON WFRTTaskInterfaceAssocTable FAILED.'')')
			SELECT @ErrMessage = 'Block 218 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
			IF NOT EXISTS(SELECT * FROM sys.indexes
				WHERE name='IDX1_WFObjectPropertiesTable'
				AND object_id = OBJECT_ID('WFObjectPropertiesTable')
						)
			BEGIN
				EXECUTE('CREATE INDEX IDX1_WFObjectPropertiesTable ON WFObjectPropertiesTable(ObjectType,PropertyName)')
		
				PRINT 'INDEX IDX1_WFObjectPropertiesTable CREATED SUCCESSFULLY'
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''IDX1_WFObjectPropertiesTable ON WFObjectPropertiesTable SUCCESSFULLY'')')
			END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE INDEX IDX1_WFObjectPropertiesTable ON WFObjectPropertiesTable FAILED.'')')
			SELECT @ErrMessage = 'Block 219 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
			
			
			/*.................................. Added by Mohnish Ends..................................................*/
			
			
/*.................................. End of Adding new Indexes ..............................................*/
		
/* ........................................ Adding new view .................................................*/
		
	BEGIN
		BEGIN TRY		
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
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE VIEW PROFILEUSERGROUPVIEW SUCCESSFULLY'')')
			END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE VIEW PROFILEUSERGROUPVIEW FAILED.'')')
			SELECT @ErrMessage = 'Block 220 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
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
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''INDEXES CREATED SUCCESSFULLY'')')
			END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE VIEW PROFILEUSERGROUPVIEW FAILED.'')')
			SELECT @ErrMessage = 'Block 221 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
			IF NOT  EXISTS (SELECT * FROM sysobjects WHERE ID = OBJECT_ID(N'WFROLEVIEW')
			AND OBJECTPROPERTY(id, N'IsView') = 1)
				BEGIN
					EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE VIEW WFROLEVIEW started.'')')
					EXECUTE('
						CREATE VIEW WFROLEVIEW 
						AS 
						SELECT roleindex, rolename, description, manyuserflag
						FROM PDBROLES
					')
				END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE VIEW WFROLEVIEW FAILED.'')')
			SELECT @ErrMessage = 'Block 222 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END		
				
		
/*......................................Adding/modifying new views by Mohnish..................................*/
	BEGIN
		BEGIN TRY
		IF  EXISTS (SELECT * FROM sysobjects WHERE ID = OBJECT_ID(N'QUEUETABLE')
			AND OBJECTPROPERTY(id, N'IsView') = 1)
			BEGIN
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE VIEW QUEUETABLE started.'')')
				EXECUTE('DROP VIEW QUEUETABLE')
			
				EXECUTE('CREATE VIEW QUEUETABLE 
					AS
					SELECT  processdefid, processname, processversion, 
						processinstanceid, processinstanceid AS processinstancename, 
						activityid, activityname, 
						parentworkitemid, workitemid, 
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
						referredtoname, referredby, referredbyname, collectflag, NULL AS CompletionDatetime, CalendarName, ProcessVariantId
					FROM WFINSTRUMENTTABLE  with (NOLOCK) ')
			END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE VIEW QUEUETABLE FAILED.'')')
			SELECT @ErrMessage = 'Block 223 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	

	BEGIN
		BEGIN TRY
		IF  EXISTS (SELECT * FROM sysobjects WHERE ID = OBJECT_ID(N'QUEUEVIEW')
			AND OBJECTPROPERTY(id, N'IsView') = 1)
			BEGIN
					EXECUTE('DROP VIEW QUEUEVIEW')
				
					EXECUTE('CREATE VIEW QUEUEVIEW AS 
					SELECT * FROM QUEUETABLE WITH (NOLOCK) 
					UNION ALL 
					SELECT PROCESSDEFID, PROCESSNAME, PROCESSVERSION, PROCESSINSTANCEID, PROCESSINSTANCEID AS PROCESSINSTANCENAME, ACTIVITYID, ACTIVITYNAME, PARENTWORKITEMID, WORKITEMID, PROCESSINSTANCESTATE, WORKITEMSTATE, STATENAME, QUEUENAME, QUEUETYPE, ASSIGNEDUSER, ASSIGNMENTTYPE, INSTRUMENTSTATUS, CHECKLISTCOMPLETEFLAG, INTRODUCTIONDATETIME, CREATEDDATETIME AS CREATEDDATETIME, INTRODUCEDBY, CREATEDBYNAME, ENTRYDATETIME, LOCKSTATUS, HOLDSTATUS, PRIORITYLEVEL, LOCKEDBYNAME, LOCKEDTIME, VALIDTILL, SAVESTAGE, PREVIOUSSTAGE, EXPECTEDWORKITEMDELAYTIME AS EXPECTEDWORKITEMDELAYTIME, EXPECTEDPROCESSDELAYTIME AS EXPECTEDPROCESSDELAYTIME, STATUS, VAR_INT1, VAR_INT2, VAR_INT3, VAR_INT4, VAR_INT5, VAR_INT6, VAR_INT7, VAR_INT8, VAR_FLOAT1, VAR_FLOAT2, VAR_DATE1, VAR_DATE2, VAR_DATE3, VAR_DATE4, VAR_LONG1, VAR_LONG2, VAR_LONG3, VAR_LONG4, VAR_STR1, VAR_STR2, VAR_STR3, VAR_STR4, VAR_STR5, VAR_STR6, VAR_STR7, VAR_STR8, VAR_REC_1, VAR_REC_2, VAR_REC_3, VAR_REC_4, VAR_REC_5, Q_STREAMID, Q_QUEUEID, Q_USERID, LASTPROCESSEDBY, PROCESSEDBY, REFERREDTO, REFERREDTONAME, REFERREDBY, REFERREDBYNAME, COLLECTFLAG, NULL AS COMPLETIONDATETIME, CALENDARNAME, PROCESSVARIANTID FROM QUEUEHISTORYTABLE WITH (NOLOCK) ')
			END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE VIEW QUEUEVIEW FAILED.'')')
			SELECT @ErrMessage = 'Block 224 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END
		
	BEGIN
		BEGIN TRY	
		IF  EXISTS (SELECT * FROM sysobjects WHERE ID = OBJECT_ID(N'WFSEARCHVIEW_0')
			AND OBJECTPROPERTY(id, N'IsView') = 1)
			BEGIN
					EXECUTE('DROP VIEW WFSEARCHVIEW_0')
				
				/*	EXECUTE('CREATE VIEW WFSEARCHVIEW_0 
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
					ProcessedBy ,  Q_UserID , WorkItemState , VAR_REC_1, VAR_REC_2
				FROM QUEUEVIEW ')*/
			END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE VIEW WFSEARCHVIEW_0 FAILED.'')')
			SELECT @ErrMessage = 'Block 225 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
			
		/*......................................Adding/modifying new views by Mohnish ends.............................*/
			
		/* .................................... End of Adding new view .................................................*/
		/*  Inserting Default values in WFMileStoneTable and WFSwimLaneTable for the exsisting Processses  */
	BEGIN
		BEGIN TRY	
		Print 'Inserting Default values in WFMileStoneTable and WFSwimLaneTable'
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
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Insert into WFMIleStoneTable WFSwimLaneTable  FAILED.'')')
			SELECT @ErrMessage = 'Block 226 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END
		
		/* Inserting Missing Values in QueuedefTable and WFLanequeueTable*/
	BEGIN
		BEGIN TRY	
			BEGIN
					Declare @processDefId_lane int
					
					Declare @processname_lane varchar(MAX) 
					
					Declare @Qname varchar(max)
					Declare @swimlaneQueueId int
					
					DECLARE cur_Lane_Queue CURSOR FOR  
					SELECT ProcessDefId,ProcessName  from PROCESSDEFTABLE 
		
					OPEN cur_Lane_Queue
		
					FETCH NEXT FROM cur_Lane_Queue INTO @processDefId_lane,@processname_lane
					
					WHILE @@FETCH_STATUS = 0 
					BEGIN
					
					If Not Exists(Select * from WFLaneQueueTable where processdefid = @processDefId_lane)
						BEGIN
							Select @Qname =  @processname_lane + '_SwimLane_1'
							SET @swimlaneQueueId = -1
							SELECT @swimlaneQueueId = QueueID FROM QueueDefTable WHERE QueueName = @Qname
							if(@swimlaneQueueId = -1)
							BEGIN
							Insert into QueueDefTable (QueueName, QueueType, Comments,AllowReassignment, OrderBy,RefreshInterval, SortOrder,LastMOdifiedOn) values 
							(@Qname, 'F', 'Process Modeler generated Default Swimlane Queue','N', 10,0, 'A',GetDate())
				
							Insert into WFLaneQueueTable(ProcessDefId,SwimLaneId,QueueID,DefaultQueue) Values (@processDefId_lane,1,SCOPE_IDENTITY(),'N')
							END
							ELSE
							BEGIN
							Insert into WFLaneQueueTable(ProcessDefId,SwimLaneId,QueueID,DefaultQueue) Values (@processDefId_lane,1,@swimlaneQueueId,'N')
							END
						
						END
						
					
					FETCH NEXT FROM cur_Lane_Queue INTO @processDefId_lane,@processname_lane
			
		
				END
			CLOSE cur_Lane_Queue   
			DEALLOCATE cur_Lane_Queue 
		END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Insert into QueueDefTable WFLaneQueueTable  FAILED.'')')
			SELECT @ErrMessage = 'Block 227 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END
		
		/*.................................Insert missing values in Tables By Mohnish........................................*/
	BEGIN
		BEGIN TRY	
			BEGIN
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Insert WFUserSkillCategoryTable  started.'')')
				INSERT INTO WFUserSkillCategoryTable(CategoryName,CategoryDefinedBy,CategoryAvailableForRating) values('Default',1,'N')
			END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Insert WFUserSkillCategoryTable  FAILED.'')')
			SELECT @ErrMessage = 'Block 228 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END
			
	BEGIN
		BEGIN TRY	
		IF NOT EXISTS(SELECT * FROM WFSYSTEMPROPERTIESTABLE WHERE PROPERTYKEY = 'SYSTEMEMAILID')
			BEGIN
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''INSERT  INTO WFSYSTEMPROPERTIESTABLE FOR SYSTEMEMAILID started.'')')
				INSERT  INTO WFSYSTEMPROPERTIESTABLE(PROPERTYKEY, PROPERTYVALUE) values('SYSTEMEMAILID','system_emailid@domain.com')
			End
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''INSERT  INTO WFSYSTEMPROPERTIESTABLE FOR SYSTEMEMAILID FAILED.'')')
			SELECT @ErrMessage = 'Block 229 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
		
	BEGIN
		BEGIN TRY
		IF NOT EXISTS(SELECT * FROM WFSYSTEMPROPERTIESTABLE WHERE PROPERTYKEY = 'ADMINEMAILID')
			BEGIN
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''INSERT  INTO WFSYSTEMPROPERTIESTABLE FOR ADMINEMAILID started.'')')
				INSERT  INTO WFSYSTEMPROPERTIESTABLE(PROPERTYKEY, PROPERTYVALUE) values('ADMINEMAILID','admin_emailid@domain.com')
			End
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''INSERT  INTO WFSYSTEMPROPERTIESTABLE FOR ADMINEMAILID FAILED.'')')
			SELECT @ErrMessage = 'Block 230 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
		IF NOT EXISTS(SELECT * FROM WFSYSTEMPROPERTIESTABLE WHERE PROPERTYKEY = 'AUTHORIZATIONFLAG')
			BEGIN
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''INSERT  INTO WFSYSTEMPROPERTIESTABLE FOR AUTHORIZATIONFLAG started.'')')
				INSERT  INTO WFSYSTEMPROPERTIESTABLE(PROPERTYKEY, PROPERTYVALUE) values('AUTHORIZATIONFLAG','N')
			End
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''INSERT  INTO WFSYSTEMPROPERTIESTABLE FOR AUTHORIZATIONFLAG FAILED.'')')
			SELECT @ErrMessage = 'Block 231 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
		
		
		
		/*.................................Insert missing values in Tables By Mohnish Ends...................................*/
		
		
		
		/* End of cursor*/		
			
		
	BEGIN
		BEGIN TRY	
			IF NOT EXISTS(SELECT * FROM WFCabVersionTable WHERE CabVersion = '9.0_SAP_CONFIGURATION')
			BEGIN
				Execute ('Update WFSAPConnectTable Set RFCHostName = SAPHostName, ConfigurationName = ''DEFAULT''')
				SET @ConfigurationId = 0
				DECLARE cursorSAPConfig CURSOR STATIC FOR
				SELECT ProcessDefId, ConfigurationId FROM WFSAPConnectTable 
				OPEN cursorSAPConfig
				FETCH NEXT FROM cursorSAPConfig INTO @ProcessDefId, @tempConfigId
				WHILE(@@FETCH_STATUS = 0) 
				BEGIN 
					SET @ConfigurationId = @ConfigurationId + 1
					BEGIN TRANSACTION trans
		
		
						EXECUTE(' UPDATE WFSAPConnectTable SET ConfigurationId = ' + @ConfigurationId + ' WHERE ProcessDefId = ' + @ProcessDefId +' And ConfigurationId = '+@tempConfigId)
						EXECUTE(' UPDATE WFSAPGUIAssocTable SET ConfigurationId = ' + @ConfigurationId + ' WHERE ProcessDefId = ' + @ProcessDefId +' And ConfigurationId = '+@tempConfigId)
						EXECUTE(' UPDATE WFSAPadapterAssocTable SET ConfigurationId = ' + @ConfigurationId + ' WHERE ProcessDefId = ' + 
						@ProcessDefId +' And ConfigurationId = '+@tempConfigId)
						EXECUTE(' UPDATE ExtMethodDefTable SET ConfigurationId = ' + @ConfigurationId + ' WHERE ProcessDefId = ' + @ProcessDefId +' And ConfigurationId = '+@tempConfigId)
					COMMIT TRANSACTION trans
		
		
					FETCH NEXT FROM cursorSAPConfig INTO @ProcessDefId,@tempConfigId
				END
				CLOSE cursorSAPConfig   
				DEALLOCATE cursorSAPConfig	
				EXECUTE('INSERT INTO WFCabVersionTable(cabVersion, creationDate, lastModified, Remarks, Status) VALUES (N''9.0_SAP_CONFIGURATION'', GETDATE(), GETDATE(), N''UpgradeIBPS_A_OFServer_3.sql'', N''Y'')')
			END
		END TRY		
		BEGIN CATCH
			SELECT @V_TRAN_STATUS = XACT_STATE()
			IF(@V_TRAN_STATUS > 0)
				ROLLBACK
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Update WFSAPConnectTable Set FAILED.'')')
			SELECT @ErrMessage = 'Block 232 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
		
	BEGIN
		BEGIN TRY
			IF NOT EXISTS ( SELECT * FROM sysColumns 
				WHERE 
				id = (SELECT id FROM sysObjects WHERE NAME = 'ActivityAssociationTable')
				AND  NAME = 'ProcessVariantId'
				)
			BEGIN
				EXECUTE('Alter Table ActivityAssociationTable add ProcessVariantId Integer Default 0 NOT NULL')		
				Print 'ActivityAssociationTable Altered successfully'	
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ActivityAssociationTable Altered successfully'')')		
			END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Alter Table ActivityAssociationTable add ProcessVariantId FAILED.'')')
			SELECT @ErrMessage = 'Block 233 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
			
	BEGIN
		BEGIN TRY
			IF NOT EXISTS ( SELECT * FROM sysColumns 
				WHERE 
				id = (SELECT id FROM sysObjects WHERE NAME = 'VarMappingTable')
				AND  NAME = 'ProcessVariantId'
				)
			BEGIN
				EXECUTE('Alter Table VarMappingTable add ProcessVariantId Integer Default 0 NOT NULL')		
				Print 'VarMappingTable Altered successfully'
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''VarMappingTable Altered successfully'')')
			END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Alter Table VarMappingTable add ProcessVariantId FAILED.'')')
			SELECT @ErrMessage = 'Block 234 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
			
	BEGIN
		BEGIN TRY
			IF NOT EXISTS ( SELECT * FROM sysColumns 
				WHERE 
				id = (SELECT id FROM sysObjects WHERE NAME = 'WFUDTVarMappingTable')
				AND  NAME = 'ProcessVariantId'
				)
			BEGIN
				EXECUTE('Alter Table WFUDTVarMappingTable add ProcessVariantId Integer Default 0 NOT NULL ')		
				Print 'WFUDTVarMappingTable Altered successfully'	
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''WFUDTVarMappingTable Altered successfully'')')
			END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Alter Table WFUDTVarMappingTable add ProcessVariantId FAILED.'')')
			SELECT @ErrMessage = 'Block 235 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
			
	BEGIN
		BEGIN TRY
			IF NOT EXISTS ( SELECT * FROM sysColumns 
				WHERE 
				id = (SELECT id FROM sysObjects WHERE NAME = 'ExtDBConfTable')
				AND  NAME = 'ProcessVariantId'
				)
			BEGIN
				EXECUTE('Alter Table ExtDBConfTable add ProcessVariantId Integer Default 0 NOT NULL ')		
				Print 'ExtDBConfTable Altered successfully'		
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ExtDBConfTable Altered successfully'')')
			END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Alter Table ExtDBConfTable add ProcessVariantId Set FAILED.'')')
			SELECT @ErrMessage = 'Block 236 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
			IF NOT EXISTS ( SELECT * FROM sysColumns 
				WHERE 
				id = (SELECT id FROM sysObjects WHERE NAME = 'DocumentTypeDefTable')
				AND  NAME = 'ProcessVariantId'
				)
			BEGIN
				EXECUTE('Alter Table DocumentTypeDefTable add ProcessVariantId Integer Default 0 NOT NULL ')		
				Print 'DocumentTypeDefTable Altered successfully'	
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''DocumentTypeDefTable Altered successfully'')')
			END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Alter Table DocumentTypeDefTable add ProcessVariantId Set FAILED.'')')
			SELECT @ErrMessage = 'Block 237 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
			
	BEGIN
		BEGIN TRY
			IF NOT EXISTS ( SELECT * FROM sysColumns 
				WHERE 
				id = (SELECT id FROM sysObjects WHERE NAME = 'WFTypeDefTable')
				AND  NAME = 'ProcessVariantId'
				)
			BEGIN
				EXECUTE('Alter Table WFTypeDefTable add ProcessVariantId Integer Default 0 NOT NULL ')		
				Print 'WFTypeDefTable Altered successfully'			
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''WFTypeDefTable Altered successfully'')')
			END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Alter Table WFTypeDefTable add ProcessVariantId Set FAILED.'')')
			SELECT @ErrMessage = 'Block 238 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
			IF NOT EXISTS ( SELECT * FROM sysColumns 
				WHERE 
				id = (SELECT id FROM sysObjects WHERE NAME = 'WFTypeDescTable')
				AND  NAME = 'ProcessVariantId'
				)
			BEGIN
				EXECUTE('Alter Table WFTypeDescTable add ProcessVariantId Integer Default 0 NOT NULL')		
				Print 'WFTypeDescTable Altered successfully'
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''WFTypeDescTable Altered successfully'')')
			END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Alter Table WFTypeDescTable add ProcessVariantId FAILED.'')')
			SELECT @ErrMessage = 'Block 239 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
			IF NOT EXISTS ( SELECT * FROM sysColumns 
				WHERE 
				id = (SELECT id FROM sysObjects WHERE NAME = 'WFVarRelationTable')
				AND  NAME = 'ProcessVariantId'
				)
			BEGIN
				EXECUTE('Alter Table WFVarRelationTable add ProcessVariantId Integer Default 0 NOT NULL')		
				Print 'WFVarRelationTable Altered successfully'	
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''WFVarRelationTable Altered successfully'')')
			END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Alter Table WFVarRelationTable add ProcessVariantId FAILED.'')')
			SELECT @ErrMessage = 'Block 240 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
			IF NOT EXISTS ( SELECT * FROM sysColumns 
				WHERE 
				id = (SELECT id FROM sysObjects WHERE NAME = 'ActivityInterfaceAssocTable')
				AND  NAME = 'ProcessVariantId'
				)
			BEGIN
				EXECUTE('Alter Table ActivityInterfaceAssocTable add ProcessVariantId Integer Default 0 NOT NULL')		
				Print 'ActivityInterfaceAssocTable Altered successfully'	
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ActivityInterfaceAssocTable Altered successfully'')')
			END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Alter Table ActivityInterfaceAssocTable add ProcessVariantId FAILED.'')')
			SELECT @ErrMessage = 'Block 241 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
			IF NOT EXISTS ( SELECT * FROM sysColumns 
				WHERE 
				id = (SELECT id FROM sysObjects WHERE NAME = 'WFForm_Table')
				AND  NAME = 'ProcessVariantId'
				)
			BEGIN
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Alter Table WFForm_Table add ProcessVariantId  started.'')')
				EXECUTE('Alter Table WFForm_Table add ProcessVariantId Integer Default 0 NOT NULL')	
			END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Alter Table WFForm_Table add ProcessVariantId  FAILED.'')')
			SELECT @ErrMessage = 'Block 242 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
		
	BEGIN
		BEGIN TRY	
			IF NOT EXISTS ( SELECT * FROM sysColumns 
				WHERE 
				id = (SELECT id FROM sysObjects WHERE NAME = 'WFForm_Table')
				AND  NAME = 'ExistingFormId'
				)
			BEGIN
				EXECUTE('Alter Table WFForm_Table add ExistingFormId Integer Default -1 NOT NULL')
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''WFForm_Table Altered successfully'')')	
			END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Alter Table WFForm_Table add ExistingFormId  FAILED.'')')
			SELECT @ErrMessage = 'Block 243 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END		
	
	BEGIN
		BEGIN TRY
			Begin
				SELECT @TableId = id FROM sysobjects WHERE name = 'ActivityAssociationTable'
				SELECT @ConstraintName = name FROM SYSCONSTRAINTS A, SYSOBJECTS B WHERE A.constid = B.id AND B.xtype = 'PK' AND A.id = @TableId 		
				IF EXISTS ( SELECT * FROM sysObjects WHERE NAME = @ConstraintName)
					BEGIN
						execute('alter table ActivityAssociationTable drop CONSTRAINT ' + @ConstraintName)				
					END				
				EXECUTE('alter table ActivityAssociationTable add PRIMARY KEY (ProcessdefId, ActivityId, DefinitionType, DefinitionId, ProcessVariantId)')
				PRINT 'Alter Table ActivityAssociationTable Successfully'
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Alter Table ActivityAssociationTable Successfully'')')
			End
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''alter table ActivityAssociationTable add PRIMARY KEY  FAILED.'')')
			SELECT @ErrMessage = 'Block 244 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
			Begin
				SELECT @TableId = id FROM sysobjects WHERE name = 'VarMappingTable'
				SELECT @ConstraintName = name FROM SYSCONSTRAINTS A, SYSOBJECTS B WHERE A.constid = B.id AND B.xtype = 'PK' AND A.id = @TableId 		
				IF EXISTS ( SELECT * FROM sysObjects WHERE NAME = @ConstraintName)
					BEGIN
						execute('alter table VarMappingTable drop CONSTRAINT ' + @ConstraintName)				
					END				
				EXECUTE('alter table VarMappingTable add PRIMARY KEY (ProcessdefId, VariableId, ProcessVariantId)')
				PRINT 'Alter Table VarMappingTable Successfully'
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Alter Table VarMappingTable Successfully'')')
			End
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''alter table VarMappingTable add PRIMARY KEY FAILED.'')')
			SELECT @ErrMessage = 'Block 245 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
			
	BEGIN
		BEGIN TRY		
			Begin
				SELECT @TableId = id FROM sysobjects WHERE name = 'WFUDTVarMappingTable'
				SELECT @ConstraintName = name FROM SYSCONSTRAINTS A, SYSOBJECTS B WHERE A.constid = B.id AND B.xtype = 'PK' AND A.id = @TableId 		
				IF EXISTS ( SELECT * FROM sysObjects WHERE NAME = @ConstraintName)
					BEGIN
						execute('alter table WFUDTVarMappingTable drop CONSTRAINT ' + @ConstraintName)				
					END				
				EXECUTE('alter table WFUDTVarMappingTable add PRIMARY KEY (ProcessDefId, VariableId, VarFieldId, ProcessVariantId)')
				PRINT 'Alter Table WFUDTVarMappingTable Successfully'
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Alter Table WFUDTVarMappingTable Successfully'')')
			End
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''alter table WFUDTVarMappingTable add PRIMARY KEY FAILED.'')')
			SELECT @ErrMessage = 'Block 246 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY	
			Begin
				SELECT @TableId = id FROM sysobjects WHERE name = 'ExtDBConfTable'
				SELECT @ConstraintName = name FROM SYSCONSTRAINTS A, SYSOBJECTS B WHERE A.constid = B.id AND B.xtype = 'PK' AND A.id = @TableId 		
				IF EXISTS ( SELECT * FROM sysObjects WHERE NAME = @ConstraintName)
					BEGIN
						execute('alter table ExtDBConfTable drop CONSTRAINT ' + @ConstraintName)				
					END				
				EXECUTE('alter table ExtDBConfTable add PRIMARY KEY (ProcessDefId, ExtObjID, ProcessVariantId)')
				PRINT 'Alter Table ExtDBConfTable Successfully'
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Alter Table ExtDBConfTable Successfully'')')
			End
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''alter table ExtDBConfTable add PRIMARY KEY FAILED.'')')
			SELECT @ErrMessage = 'Block 247 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
			Begin
				SELECT @TableId = id FROM sysobjects WHERE name = 'DocumentTypeDefTable'
				SELECT @ConstraintName = name FROM SYSCONSTRAINTS A, SYSOBJECTS B WHERE A.constid = B.id AND B.xtype = 'PK' AND A.id = @TableId 		
				IF EXISTS ( SELECT * FROM sysObjects WHERE NAME = @ConstraintName)
					BEGIN
						execute('alter table DocumentTypeDefTable drop CONSTRAINT ' + @ConstraintName)				
					END				
				EXECUTE('alter table DocumentTypeDefTable add PRIMARY KEY (ProcessDefId, DocId, ProcessVariantId)')
				PRINT 'Alter Table DocumentTypeDefTable Successfully'
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Alter Table DocumentTypeDefTable Successfully'')')
			End
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''alter table DocumentTypeDefTable add PRIMARY KEY FAILED.'')')
			SELECT @ErrMessage = 'Block 248 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
			Begin
				SELECT @TableId = id FROM sysobjects WHERE name = 'WFTypeDefTable'
				SELECT @ConstraintName = name FROM SYSCONSTRAINTS A, SYSOBJECTS B WHERE A.constid = B.id AND B.xtype = 'PK' AND A.id = @TableId 		
				IF EXISTS ( SELECT * FROM sysObjects WHERE NAME = @ConstraintName)
					BEGIN
						execute('alter table WFTypeDefTable drop CONSTRAINT ' + @ConstraintName)				
					END				
				EXECUTE('alter table WFTypeDefTable add PRIMARY KEY (ProcessDefId, ParentTypeId, TypeFieldId, ProcessVariantId)')
				PRINT 'Alter Table WFTypeDefTable Successfully'
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Alter Table WFTypeDefTable Successfully'')')
			End
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''alter table WFTypeDefTable add PRIMARY KEY FAILED.'')')
			SELECT @ErrMessage = 'Block 249 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
			Begin
				SELECT @TableId = id FROM sysobjects WHERE name = 'WFTypeDescTable'
				SELECT @ConstraintName = name FROM SYSCONSTRAINTS A, SYSOBJECTS B WHERE A.constid = B.id AND B.xtype = 'PK' AND A.id = @TableId 		
				IF EXISTS ( SELECT * FROM sysObjects WHERE NAME = @ConstraintName)
					BEGIN
						execute('alter table WFTypeDescTable drop CONSTRAINT ' + @ConstraintName)				
					END				
				EXECUTE('alter table WFTypeDescTable add PRIMARY KEY (ProcessDefId, TypeId, ProcessVariantId)')
				PRINT 'Alter Table WFTypeDescTable Successfully'
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Alter Table WFTypeDescTable Successfully'')')
			End
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''alter table WFTypeDescTable add PRIMARY KEY FAILED.'')')
			SELECT @ErrMessage = 'Block 250 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END		
	
	BEGIN
		BEGIN TRY
			Begin
				SELECT @TableId = id FROM sysobjects WHERE name = 'WFVarRelationTable'
				SELECT @ConstraintName = name FROM SYSCONSTRAINTS A, SYSOBJECTS B WHERE A.constid = B.id AND B.xtype = 'PK' AND A.id = @TableId 		
				IF EXISTS ( SELECT * FROM sysObjects WHERE NAME = @ConstraintName)
					BEGIN
						execute('alter table WFVarRelationTable drop CONSTRAINT ' + @ConstraintName)				
					END				
				EXECUTE('alter table WFVarRelationTable add PRIMARY KEY (ProcessDefId, RelationId, OrderId, ProcessVariantId)')
				PRINT 'Alter Table WFVarRelationTable Successfully'
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Alter Table WFVarRelationTable Successfully'')')
			End
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''alter table WFVarRelationTable add PRIMARY KEY FAILED.'')')
			SELECT @ErrMessage = 'Block 251 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
			Begin
				SELECT @TableId = id FROM sysobjects WHERE name = 'TemplateMultiLanguageTable'
				print @ConstraintName
				SELECT @ConstraintName = name FROM SYSCONSTRAINTS A, SYSOBJECTS B WHERE A.constid = B.id AND B.xtype = 'PK' AND A.id = @TableId 		
				IF EXISTS ( SELECT * FROM sysObjects WHERE NAME = @ConstraintName)
					BEGIN
						execute('alter table TemplateMultiLanguageTable drop CONSTRAINT ' + @ConstraintName)				
					END				
				EXECUTE('alter table TemplateMultiLanguageTable add PRIMARY KEY (ProcessDefId, TemplateId, Locale)')
				PRINT 'Alter Table TemplateMultiLanguageTable Successfully'
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Alter Table TemplateMultiLanguageTable Successfully'')')
			End
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''alter table TemplateMultiLanguageTable add PRIMARY KEY FAILED.'')')
			SELECT @ErrMessage = 'Block 252 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
			Begin
				SELECT @TableId = id FROM sysobjects WHERE name = 'WFForm_Table'
				SELECT @ConstraintName = name FROM SYSCONSTRAINTS A, SYSOBJECTS B WHERE A.constid = B.id AND B.xtype = 'PK' AND A.id = @TableId 		
				IF EXISTS ( SELECT * FROM sysObjects WHERE NAME = @ConstraintName)
					BEGIN
						execute('alter table WFForm_Table drop CONSTRAINT ' + @ConstraintName)				
					END				
				EXECUTE('alter table WFForm_Table add PRIMARY KEY (ProcessDefId, FormId, DeviceType)')
				PRINT 'Alter Table WFForm_Table Successfully'
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Alter Table WFForm_Table Successfully'')')
			End
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''alter table WFForm_Table add PRIMARY KEY FAILED.'')')
			SELECT @ErrMessage = 'Block 253 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END		
			
			
			/* End of Upgrade for Process Variant support */
			/* Start of Interface level changes for mobile and DMS search*/
	BEGIN
		BEGIN TRY		
			IF EXISTS(SELECT * FROM PROCESS_INTERFACETABLE WHERE InterfaceId =9)
			BEGIN
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Update PROCESS_INTERFACETABLE set Interfaceid=-1 where InterfaceId =9 started.'')')
				EXECUTE('Update PROCESS_INTERFACETABLE set Interfaceid=-1 where InterfaceId =9 and InterfaceName=''DMSSearch''')	
				Print 'PROCESS_INTERFACETABLE DMSEARCH updated successfully'				
			END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Update PROCESS_INTERFACETABLE set Interfaceid=-1 where InterfaceId =9 FAILED.'')')
			SELECT @ErrMessage = 'Block 254 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
			
			
	BEGIN
		BEGIN TRY		
			IF EXISTS(SELECT * FROM PROCESS_INTERFACETABLE WHERE InterfaceId =11)
			BEGIN
				EXECUTE('Update PROCESS_INTERFACETABLE set InterfaceId = 9, interfacename=''Mobile'',clientinvocation=''Mobile.clsMobile'',menuname=''Mobile'' where InterfaceId =11 and InterfaceName=''MobileSubTab''')	
				Print 'PROCESS_INTERFACETABLE DMSEARCH updated successfully'	
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''PROCESS_INTERFACETABLE DMSEARCH updated successfully'')')
			END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Update PROCESS_INTERFACETABLE set InterfaceId = 9 FAILED.'')')
			SELECT @ErrMessage = 'Block 255 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
			/* End of Interface level changes for mobile and DMS search*/
			/*---bugs fixing of UT --Starts--*/
	BEGIN
		BEGIN TRY		
			EXECUTE ('Update varmappingtable set varprecision = 0 where varprecision is NULL')
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Update varmappingtable set varprecision = 0 where varprecision is NULL'')')
			EXECUTE ('Update PROCESSDEFCOMMENTTABLE set CommentFont = ''BookMan Old Style,0,8'' where CommentFont is NULL')
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Update PROCESSDEFCOMMENTTABLE set CommentFont'')')
			EXECUTE ('Update PROCESSDEFCOMMENTTABLE set CommentForeColor = 0 where CommentForeColor is NULL')
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Update PROCESSDEFCOMMENTTABLE set CommentForeColor'')')
			EXECUTE ('Update PROCESSDEFCOMMENTTABLE set CommentBackColor = 0 where CommentBackColor is NULL')
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Update PROCESSDEFCOMMENTTABLE set CommentBackColor'')')
			EXECUTE ('Update PROCESSDEFCOMMENTTABLE set CommentBorderStyle = 0 where CommentBorderStyle is NULL')
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Update PROCESSDEFCOMMENTTABLE set CommentBorderStyle'')')
			EXECUTE ('update QUEUEUSERTABLE set QueryPreview = ''Y'' where QueryPreview is NULL')
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Update QUEUEUSERTABLE set QueryPreview'')')
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Update varmappingtable PROCESSDEFCOMMENTTABLE QUEUEUSERTABLE FAILED.'')')
			SELECT @ErrMessage = 'Block 256 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END		
	
	BEGIN
		BEGIN TRY
			IF NOT EXISTS (SELECT *	FROM sysindexes	WHERE id = OBJECT_ID('WFCURRENTROUTELOGTABLE')
						AND name = 'IDX1_WFRouteLogTABLE')
			BEGIN
				EXECUTE('CREATE INDEX  IDX1_WFRouteLogTABLE ON WFCURRENTROUTELOGTABLE (ProcessDefId,ActionId)')
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE INDEX  IDX1_WFRouteLogTABLE ON WFCURRENTROUTELOGTABLE (ProcessDefId,ActionId)'')')
			END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE INDEX  IDX1_WFRouteLogTABLE ON WFCURRENTROUTELOGTABLE FAILED.'')')
			SELECT @ErrMessage = 'Block 257 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
			IF NOT EXISTS (SELECT *	FROM sysindexes	WHERE id = OBJECT_ID('WFCURRENTROUTELOGTABLE')
						AND name = 'IDX2_WFRouteLogTABLE')
			BEGIN
				EXECUTE('CREATE INDEX  IDX2_WFRouteLogTABLE ON WFCURRENTROUTELOGTABLE (ActionId,UserID)')
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE INDEX  IDX2_WFRouteLogTABLE ON WFCURRENTROUTELOGTABLE (ActionId,UserID)'')')
			END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE INDEX  IDX2_WFRouteLogTABLE ON WFCURRENTROUTELOGTABLE FAILED.'')')
			SELECT @ErrMessage = 'Block 258 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
			IF NOT EXISTS (SELECT *	FROM sysindexes	WHERE id = OBJECT_ID('WFCURRENTROUTELOGTABLE')
						AND name = 'IDX3_WFCRouteLogTable')
			BEGIN
				EXECUTE('CREATE INDEX IDX3_WFCRouteLogTable ON WFCurrentRouteLogTable (ProcessInstanceId)')
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE INDEX IDX3_WFCRouteLogTable ON WFCurrentRouteLogTable (ProcessInstanceId)'')')
			END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE INDEX  IDX3_WFCRouteLogTable ON WFCURRENTROUTELOGTABLE FAILED.'')')
			SELECT @ErrMessage = 'Block 259 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
			
	BEGIN
		BEGIN TRY		
			IF NOT EXISTS (SELECT *	FROM sysindexes	WHERE id = OBJECT_ID('WFCURRENTROUTELOGTABLE')
						AND name = 'IDX4_WFCRouteLogTable')
			BEGIN
				EXECUTE('CREATE INDEX IDX4_WFCRouteLogTable ON WFCurrentRouteLogTable (ProcessInstanceId, ActionDateTime, LogID)')
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE INDEX IDX4_WFCRouteLogTable ON WFCurrentRouteLogTable (ProcessInstanceId, ActionDateTime, LogID)'')')
			END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE INDEX  IDX4_WFCRouteLogTable ON WFCURRENTROUTELOGTABLE FAILED.'')')
			SELECT @ErrMessage = 'Block 260 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
			
	BEGIN
		BEGIN TRY
			IF NOT EXISTS (SELECT *	FROM sysindexes	WHERE id = OBJECT_ID('WFHISTORYROUTELOGTABLE')
						AND name = 'IDX1_WFHRouteLogTABLE')
			BEGIN
				EXECUTE('CREATE INDEX  IDX1_WFHRouteLogTABLE ON WFHISTORYROUTELOGTABLE (ProcessDefId,ActionId)')
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE INDEX  IDX1_WFHRouteLogTABLE ON WFHISTORYROUTELOGTABLE (ProcessDefId,ActionId)'')')
			END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE INDEX  IDX1_WFHRouteLogTABLE ON WFHISTORYROUTELOGTABLE FAILED.'')')
			SELECT @ErrMessage = 'Block 261 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END		
	
	BEGIN
		BEGIN TRY
			IF NOT EXISTS (SELECT *	FROM sysindexes	WHERE id = OBJECT_ID('WFHISTORYROUTELOGTABLE')
						AND name = 'IDX2_WFHRouteLogTABLE')
			BEGIN
				EXECUTE('CREATE INDEX  IDX2_WFHRouteLogTABLE ON WFHISTORYROUTELOGTABLE (ActionId,UserID)')
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE INDEX  IDX2_WFHRouteLogTABLE ON WFHISTORYROUTELOGTABLE (ActionId,UserID)'')')
			END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE INDEX  IDX2_WFHRouteLogTABLE ON WFHISTORYROUTELOGTABLE FAILED.'')')
			SELECT @ErrMessage = 'Block 262 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
			IF NOT EXISTS (SELECT *	FROM sysindexes	WHERE id = OBJECT_ID('WFHISTORYROUTELOGTABLE')
						AND name = 'IDX3_WFHRouteLogTable')
			BEGIN
				EXECUTE('CREATE INDEX IDX3_WFHRouteLogTable ON WFHistoryRouteLogTable (ProcessInstanceId)')
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE INDEX IDX3_WFHRouteLogTable ON WFHistoryRouteLogTable (ProcessInstanceId)'')')
			END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE INDEX  IDX3_WFHRouteLogTable ON WFHISTORYROUTELOGTABLE FAILED.'')')
			SELECT @ErrMessage = 'Block 263 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
			IF NOT EXISTS (SELECT *	FROM sysindexes	WHERE id = OBJECT_ID('WFHISTORYROUTELOGTABLE')
						AND name = 'IDX4_WFHRouteLogTABLE')
			BEGIN
				EXECUTE('CREATE INDEX  IDX4_WFHRouteLogTABLE ON WFHISTORYROUTELOGTABLE (ProcessInstanceId, ActionDateTime, LogID)')
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE INDEX  IDX4_WFHRouteLogTABLE ON WFHISTORYROUTELOGTABLE (ProcessInstanceId, ActionDateTime, LogID)'')')
			END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE INDEX  IDX4_WFHRouteLogTABLE ON WFHISTORYROUTELOGTABLE FAILED.'')')
			SELECT @ErrMessage = 'Block 264 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
			IF EXISTS ( SELECT * FROM sysColumns 
				WHERE 
				id = (SELECT id FROM sysObjects WHERE NAME = 'ARCHIVEDATAMAPTABLE')
				AND  NAME = 'Datafieldlength'
				)
			BEGIN
				EXECUTE('alter table ARCHIVEDATAMAPTABLE drop column Datafieldlength')	
				Print 'ARCHIVEDATAMAPTABLE Altered successfully'	
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''alter table ARCHIVEDATAMAPTABLE drop column datafieldlength'')')		
			END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''alter table ARCHIVEDATAMAPTABLE drop column Datafieldlength FAILED.'')')
			SELECT @ErrMessage = 'Block 265 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END		
	
	BEGIN
		BEGIN TRY
			IF EXISTS ( SELECT * FROM sysColumns 
				WHERE 
				id = (SELECT id FROM sysObjects WHERE NAME = 'IMPORTEDPROCESSDEFTABLE')
				AND  NAME = 'FIELDLENGTH'
				)
			BEGIN
				EXECUTE('alter table IMPORTEDPROCESSDEFTABLE drop column FIELDLENGTH')	
				Print 'IMPORTEDPROCESSDEFTABLE Altered successfully'	
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''alter table IMPORTEDPROCESSDEFTABLE drop column FIELDLENGTH'')')		
			END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''alter table IMPORTEDPROCESSDEFTABLE drop column FIELDLENGTH FAILED.'')')
			SELECT @ErrMessage = 'Block 266 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END
	
	BEGIN
		BEGIN TRY
			IF EXISTS ( SELECT * FROM sysColumns 
				WHERE 
				id = (SELECT id FROM sysObjects WHERE NAME = 'ExtMethodParamMappingTable')
				AND  NAME = 'datastructureid'
				)
			BEGIN
				EXECUTE('update ExtMethodParamMappingTable set datastructureid=0 where  datastructureid is NULL') 
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''update ExtMethodParamMappingTable set datastructureid=0 where  datastructureid is NULL'')')
			END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''update ExtMethodParamMappingTable set datastructureid=0 FAILED.'')')
			SELECT @ErrMessage = 'Block 267 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
			IF EXISTS ( SELECT * FROM sysColumns 
				WHERE 
				id = (SELECT id FROM sysObjects WHERE NAME = 'WFDurationTable')
				AND  NAME = 'WFHours'
				)
			BEGIN
				EXECUTE('update WFDurationTable set WFHours=''<None>'' where  WFHours is NULL') 
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''update WFDurationTable set WFHours to none'')')
			END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''pdate WFDurationTable set WFHours FAILED.'')')
			SELECT @ErrMessage = 'Block 268 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END

	BEGIN
		BEGIN TRY
			IF EXISTS ( SELECT * FROM sysColumns 
				WHERE 
				id = (SELECT id FROM sysObjects WHERE NAME = 'WFDurationTable')
				AND  NAME = 'WFMinutes'
				)
			BEGIN
				EXECUTE('update WFDurationTable set WFMinutes=''<None>'' where  WFMinutes is NULL') 
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''update WFDurationTable set WFMinutes to none'')')
			END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''pdate WFDurationTable set WFHours FAILED.'')')
			SELECT @ErrMessage = 'Block 269 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
			
			
	BEGIN
		BEGIN TRY		
			IF EXISTS ( SELECT * FROM sysColumns 
				WHERE 
				id = (SELECT id FROM sysObjects WHERE NAME = 'WFDurationTable')
				AND  NAME = 'WFSeconds'
				)
			BEGIN
				EXECUTE('update WFDurationTable set WFSeconds=''<None>'' where  WFSeconds is NULL') 
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''update WFDurationTable set WFSeconds to none'')')
			END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''update WFDurationTable set WFSeconds FAILED.'')')
			SELECT @ErrMessage = 'Block 270 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
			
	BEGIN
		BEGIN TRY		
			IF EXISTS ( SELECT * FROM sysColumns 
				WHERE 
				id = (SELECT id FROM sysObjects WHERE NAME = 'PRINTFAXEMAILTABLE')
				AND  NAME = 'FaxNoType'
				)
			BEGIN
				EXECUTE('update PRINTFAXEMAILTABLE set FaxNoType='''' where  FaxNoType is NULL and VariableIdFax!=0') 
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''update PRINTFAXEMAILTABLE set FaxNoType to blank'')')
				EXECUTE('update PRINTFAXEMAILTABLE set FaxNoType=''C'' where  FaxNoType is NULL and VariableIdFax=0') 
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''update PRINTFAXEMAILTABLE set FaxNoType to NULL'')')
			END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''update PRINTFAXEMAILTABLE set FaxNoType FAILED.'')')
			SELECT @ErrMessage = 'Block 271 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	

	BEGIN
		BEGIN TRY
			IF EXISTS ( SELECT * FROM sysColumns 
				WHERE 
				id = (SELECT id FROM sysObjects WHERE NAME = 'PRINTFAXEMAILTABLE')
				AND  NAME = 'MailPriority'
				)
			BEGIN
				EXECUTE('update PRINTFAXEMAILTABLE set MailPriority='''' where  MailPriority is NULL ') 
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''update PRINTFAXEMAILTABLE set MailPriority to blank'')')
				
			END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''update PRINTFAXEMAILTABLE set MailPriority FAILED.'')')
			SELECT @ErrMessage = 'Block 272 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END
	
	BEGIN
		BEGIN TRY
			IF EXISTS ( SELECT * FROM sysColumns 
				WHERE 
				id = (SELECT id FROM sysObjects WHERE NAME = 'EXTDBCONFTABLE')
				AND  NAME = 'DatabaseName'
				)
			BEGIN
				EXECUTE('update EXTDBCONFTABLE set DatabaseName=''online''') 
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''update EXTDBCONFTABLE set DatabaseName to online'')')
				
			END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''update EXTDBCONFTABLE set DatabaseName=online FAILED.'')')
			SELECT @ErrMessage = 'Block 273 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END

	BEGIN
		BEGIN TRY
			IF EXISTS ( SELECT * FROM sysColumns 
				WHERE 
				id = (SELECT id FROM sysObjects WHERE NAME = 'EXTDBCONFTABLE')
				AND  NAME = 'DatabaseType'
				)
			BEGIN
				EXECUTE('update EXTDBCONFTABLE set DatabaseType=''local''') 
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''update EXTDBCONFTABLE set DatabaseType to local'')')
				
			END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''update EXTDBCONFTABLE set DatabaseName=local FAILED.'')')
			SELECT @ErrMessage = 'Block 274 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
			
			
	BEGIN
		BEGIN TRY		
			IF EXISTS ( SELECT * FROM sysColumns 
				WHERE 
				id = (SELECT id FROM sysObjects WHERE NAME = 'VARALIASTABLE')
				AND  NAME = 'AliasRule'
				)
			BEGIN
				EXECUTE('update VARALIASTABLE set AliasRule=''<Rules></Rules>'' where AliasRule is NULL') ;
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''update VARALIASTABLE set AliasRule '')')
				
			END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''update VARALIASTABLE set AliasRule FAILED.'')')
			SELECT @ErrMessage = 'Block 275 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
			
	BEGIN
		BEGIN TRY		
			IF NOT EXISTS ( SELECT * FROM sysColumns 
				WHERE 
				id = (SELECT id FROM sysObjects WHERE NAME = 'WFSAPGUIDefTable')
				AND  NAME = 'TCodeType'
				)
			BEGIN
				EXECUTE('alter table WFSAPGUIDefTable add TCodeType NVarChar(1)	NOT NULL') ;
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''alter table WFSAPGUIDefTable add TCodeType '')')
				
			END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''alter table WFSAPGUIDefTable add TCodeType FAILED.'')')
			SELECT @ErrMessage = 'Block 276 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
		
	BEGIN
		BEGIN TRY		
			IF NOT EXISTS ( SELECT * FROM sysColumns 
				WHERE 
				id = (SELECT id FROM sysObjects WHERE NAME = 'WFSAPGUIDefTable')
				AND  NAME = 'VariableId'
				)
			BEGIN
				EXECUTE('alter table WFSAPGUIDefTable add VariableId INT') 
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''alter table WFSAPGUIDefTable add VariableId INT'')')
				
			END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''alter table WFSAPGUIDefTable add VariableId FAILED.'')')
			SELECT @ErrMessage = 'Block 277 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
			IF NOT EXISTS ( SELECT * FROM sysColumns 
				WHERE 
				id = (SELECT id FROM sysObjects WHERE NAME = 'WFSAPGUIDefTable')
				AND  NAME = 'VarFieldId'
				)
			BEGIN
				EXECUTE('alter table WFSAPGUIDefTable add VarFieldId INT') 
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''alter table WFSAPGUIDefTable add VarFieldId INT '')')
				
			END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''alter table WFSAPGUIDefTable add VarFieldId FAILED.'')')
			SELECT @ErrMessage = 'Block 278 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
			IF EXISTS ( SELECT * FROM sysColumns 
				WHERE 
				id = (SELECT id FROM sysObjects WHERE NAME = 'WFPDA_FORMTABLE')
				AND  NAME = 'CONTROLTYPE'
				)
			BEGIN
				EXECUTE('alter table WFPDA_FORMTABLE drop column CONTROLTYPE') 
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''alter table WFPDA_FORMTABLE drop column CONTROLTYPE '')')
				
			END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''alter table WFPDA_FORMTABLE drop column CONTROLTYPE FAILED.'')')
			SELECT @ErrMessage = 'Block 279 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END		
	
	BEGIN
		BEGIN TRY
			IF EXISTS ( SELECT * FROM sysColumns 
				WHERE 
				id = (SELECT id FROM sysObjects WHERE NAME = 'WFPDA_FORMTABLE')
				AND  NAME = 'DISPLAYNAME'
				)
			BEGIN
				EXECUTE('alter table WFPDA_FORMTABLE drop column DISPLAYNAME') 
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''alter table WFPDA_FORMTABLE drop column DISPLAYNAME '')')
				
			END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''alter table WFPDA_FORMTABLE drop column DISPLAYNAME FAILED.'')')
			SELECT @ErrMessage = 'Block 280 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
			
	BEGIN
		BEGIN TRY
			IF EXISTS ( SELECT * FROM sysColumns 
				WHERE 
				id = (SELECT id FROM sysObjects WHERE NAME = 'WFPDA_FORMTABLE')
				AND  NAME = 'MINLEN'
				)
			BEGIN
				EXECUTE('alter table WFPDA_FORMTABLE drop column MINLEN') 
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''alter table WFPDA_FORMTABLE drop column MINLEN '')')
				
			END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''alter table WFPDA_FORMTABLE drop column MINLEN FAILED.'')')
			SELECT @ErrMessage = 'Block 281 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END
	
	BEGIN
		BEGIN TRY
			IF EXISTS ( SELECT * FROM sysColumns 
				WHERE 
				id = (SELECT id FROM sysObjects WHERE NAME = 'WFPDA_FORMTABLE')
				AND  NAME = 'MAXLEN'
				)
			BEGIN
				EXECUTE('alter table WFPDA_FORMTABLE drop column MAXLEN') 
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''alter table WFPDA_FORMTABLE drop column MAXLEN '')')
				
			END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''alter table WFPDA_FORMTABLE drop column MAXLEN FAILED.'')')
			SELECT @ErrMessage = 'Block 282 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
			IF EXISTS ( SELECT * FROM sysColumns 
				WHERE 
				id = (SELECT id FROM sysObjects WHERE NAME = 'WFPDA_FORMTABLE')
				AND  NAME = 'VALIDATION'
				)
			BEGIN
				EXECUTE('alter table WFPDA_FORMTABLE drop column VALIDATION') 
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''alter table WFPDA_FORMTABLE drop column VALIDATION '')')
				
			END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''alter table WFPDA_FORMTABLE drop column VALIDATION FAILED.'')')
			SELECT @ErrMessage = 'Block 283 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END
	
	BEGIN
		BEGIN TRY
			IF EXISTS ( SELECT * FROM sysColumns 
				WHERE 
				id = (SELECT id FROM sysObjects WHERE NAME = 'WFPDA_FORMTABLE')
				AND  NAME = 'ORDERID'
				)
			BEGIN
				EXECUTE('alter table WFPDA_FORMTABLE drop column ORDERID') 
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''alter table WFPDA_FORMTABLE drop column ORDERID '')')
				
			END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''alter table WFPDA_FORMTABLE drop column ORDERID FAILED.'')')
			SELECT @ErrMessage = 'Block 284 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
			
	BEGIN
		BEGIN TRY		
			IF NOT EXISTS(SELECT * FROM sysObjects WHERE NAME = 'WFAUDITTRAILDOCTABLE')
			BEGIN
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE TABLE WFAUDITTRAILDOCTABLE started.'')')
				CREATE TABLE WFAUDITTRAILDOCTABLE(
					PROCESSDEFID			INT NOT NULL,
					PROCESSINSTANCEID		NVARCHAR(63),
					WORKITEMID			INT NOT NULL,
					ACTIVITYID			INT NOT NULL,
					DOCID				INT NOT NULL,
					PARENTFOLDERINDEX		INT NOT NULL,
					VOLID				INT NOT NULL,
					APPSERVERIP			NVARCHAR(63) NOT NULL,
					APPSERVERPORT			INT NOT NULL,
					APPSERVERTYPE			NVARCHAR(63) NULL,
					ENGINENAME			NVARCHAR(63) NOT NULL,
					DELETEAUDIT			NVARCHAR(1) Default 'N',
					STATUS				CHAR(1)	NOT NULL,
					LOCKEDBY			NVARCHAR(63)	NULL,
					PRIMARY KEY ( PROCESSINSTANCEID , WORKITEMID)
				)
				PRINT 'Table WFAUDITTRAILDOCTABLE created successfully'
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE TABLE WFAUDITTRAILDOCTABLE successfully.'')')
			END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE TABLE WFAUDITTRAILDOCTABLE FAILED.'')')
			SELECT @ErrMessage = 'Block 285 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	/*---bugs fixing of UT --Ends--*/
	BEGIN
		BEGIN TRY
			IF NOT EXISTS ( SELECT * FROM sysColumns 
				WHERE 
				id = (SELECT id FROM sysObjects WHERE NAME = 'WFWorkdeskLayoutTable')
				AND  NAME = 'TaskId'
				)
			BEGIN
				EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFWorkdeskLayoutTable ADD TaskId started.'')')
				EXECUTE('ALTER TABLE WFWorkdeskLayoutTable ADD TaskId INT DEFAULT 0 NOT NULL')
				PRINT 'Table WFWorkdeskLayoutTable altered with new Column TaskId'			
			END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFWorkdeskLayoutTable ADD TaskId FAILED.'')')
			SELECT @ErrMessage = 'Block 286 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	
	
	BEGIN
		BEGIN TRY
			DECLARE @PKName NVARCHAR(200)
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFWorkdeskLayoutTable ADD PRIMARY KEY STARTED.'')')
			select @PKName = name from sysobjects where parent_obj  = (select id from sysobjects where name = 'WFWorkdeskLayoutTable' ) and xtype = 'PK' 
			print @PKName
			EXECUTE ('ALTER TABLE WFWorkdeskLayoutTable DROP CONSTRAINT ' + @PKName)
			ALTER TABLE WFWorkdeskLayoutTable ADD PRIMARY KEY (ProcessDefId, ActivityId, TaskId)
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFWorkdeskLayoutTable ADD PRIMARY KEY FAILED.'')')
			SELECT @ErrMessage = 'Block 287 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END		
	
	BEGIN
		BEGIN TRY
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Delete from WFWorkdeskLayoutTable where processdefid = 0 started.'')')
			EXECUTE ('Delete from WFWorkdeskLayoutTable where processdefid = 0 and ActivityId= 0 and TaskId = 0')
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Delete from WFWorkdeskLayoutTable where processdefid = 0 FAILED.'')')
			SELECT @ErrMessage = 'Block 288 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	

	BEGIN
		BEGIN TRY
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Insert into WFWorkdeskLayoutTable started.'')')
			EXECUTE ('Insert into WFWorkdeskLayoutTable (ProcessDefId, ActivityId,TaskId, WSLayoutDefinition) values (0, 0,0, ''<WDeskLayout Interfaces="4"><Resolution><ScreenWidth>1024</ScreenWidth><ScreenHeight>768</ScreenHeight></Resolution>        <WDeskInterfaces><Interface Type=''''FormView'''' Top=''''50'''' Left=''''2'''' Width=''''501'''' Height=''''615''''/><Interface Type=''''Document'''' Top=''''50'''' Left=''''510'''' Width=''''501'''' Height=''''615''''/></WDeskInterfaces><MenuInterfaces><Interface Type="Exceptions"/><Interface Type="ToDoList"/></MenuInterfaces></WDeskLayout>'')')
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Insert into WFWorkdeskLayoutTable FAILED.'')')
			SELECT @ErrMessage = 'Block 289 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END	

	BEGIN
		BEGIN TRY
			IF NOT EXISTS(SELECT cabVersion FROM WFCabVersionTable WHERE cabVersion = 'iBPS_3.0_End')
					BEGIN
						EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Insert into WFCabVersionTable started.'')')
						Execute ('INSERT INTO WFCabVersionTable(cabVersion, creationDate, lastModified, Remarks, Status) VALUES (N''iBPS_3.0_End'', GETDATE(), GETDATE(), N''iBPS_3.0_End'', N''Y'')')
					END
		END TRY		
		BEGIN CATCH
			EXECUTE ('INSERT INTO WFUpgradeLoggingTable VALUES (''Insert into WFCabVersionTable FAILED.'')')
			SELECT @ErrMessage = 'Block 290 ' + ERROR_MESSAGE()
			RAISERROR(@ErrMessage,16,1)
			RETURN
		END CATCH
	END
	
END

~


PRINT 'Executing procedure Upgrade ........... '
EXEC Upgrade 

~
DROP PROCEDURE Upgrade
	
	
	


	
	
	