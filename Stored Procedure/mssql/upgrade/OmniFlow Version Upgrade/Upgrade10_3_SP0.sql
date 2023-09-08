/*
Change DATE		Name				Description
--------------------------------------------------------------
26/05/2017		Sanal Grover		Bug 62518 - Step by Step Debugs in Version Upgrade.
24/07/2017      Ashok Kumar			Bug 69853 - WorkinprocessTable and Workwithpstable handling in version upgrade for IBPS upgrade.
03/05/2018		Ashutosh Pandey		Bug 77527 - Provide upper case encrypted password while creating system user if PwdSensitivity is N
23/04/2019		Ashutosh Pandey		Bug 84321 - Change data type of column Type1 in VarAliasTable to SMALLINT
24/01/2020		Chitranshi Nitharia	Bug 90093 - Creation Of Utility User Via API instead of scripts
*/
If Not Exists (Select * from SysObjects Where xType = 'P' and name = 'LogInsertCab')
Begin
	Execute('CREATE PROCEDURE LogInsertCab
	@v_stepNumber varchar(1000),
	@v_scriptName varchar(100),
	@v_stepDetails varchar(1000)

	AS
		DECLARE @DBString  NVARCHAR(10) 
		DECLARE @dbQuery varchar(1000)
		
		BEGIN
			BEGIN
			SELECT @DBString = 1
			
			PRINT''@v_stepNumber--->''+@v_stepNumber
			PRINT''@@v_stepDetails--->''+@v_stepDetails
		
			
			EXECUTE (''INSERT INTO WFCABINETUPGRADELOGTABLE(STEPNUMBER,SCRIPTNAME,STEPDETAILS, STARTDATE, STATUS) VALUES
				('' + @v_stepNumber+'',''''''+@v_scriptName+'''''',''''''+ @v_stepDetails +'''''',getdate(), N''''UPDATING'''')'')
			IF @@ROWCOUNT = 1
				return @DBString
			END
		END')
	Print 'Procedure LogInsertCab created..... '
End
~

If Not Exists (Select * from SysObjects Where xType = 'P' and name = 'LogSkipCab')
Begin
	Execute('CREATE PROCEDURE LogSkipCab
	@v_stepNumber int,
	@v_scriptName varchar(100)
	AS
		DECLARE @DBString   NVARCHAR(50)
		DECLARE @dbQuery varchar(1000)
		
		BEGIN
		BEGIN
		SELECT @DBString = 1
		
			PRINT ''INSIDE''
			EXECUTE (''UPDATE WFCABINETUPGRADELOGTABLE set ENDDATE = getdate(), STATUS = ''''INSIDE'''' WHERE STEPNUMBER ='' + @v_stepNumber +'' AND STATUS = ''''UPDATING'''' AND SCRIPTNAME = '''''' + @v_scriptName + '''''''')
			IF @@ROWCOUNT = 1
				return @DBString
			END
		END')
	Print 'Procedure LogSkipCab created..... '
End
~

If Not Exists (Select * from SysObjects Where xType = 'P' and name = 'LogFailedCab')
Begin
	Execute('CREATE PROCEDURE LogFailedCab
	@v_stepNumber int,
	@v_scriptName varchar(100)
	AS
		DECLARE @DBString   NVARCHAR(50)
		DECLARE @dbQuery varchar(1000)
		
		BEGIN
		BEGIN
		SELECT @DBString = 1
		
			PRINT ''FAILED''
			EXECUTE (''UPDATE WFCABINETUPGRADELOGTABLE set ENDDATE = getdate(), STATUS = ''''FAILED'''' WHERE STEPNUMBER ='' + @v_stepNumber +'' AND SCRIPTNAME=''''''+@v_scriptName+'''''''')
			IF @@ROWCOUNT = 1
				return @DBString
			END
		END')
		Print 'Procedure LogFailedCab Created ..... '
End
~

If Not Exists (SELECT 1 FROM SYSObjects WHERE NAME = 'LogUpdateCab' AND xType = 'P')
BEGIN
	EXECUTE ('CREATE PROCEDURE LogUpdateCab
	@v_stepNumber int,
	@v_scriptName varchar(100)
	AS
		DECLARE @DBString   NVARCHAR(50)
		DECLARE @dbQuery varchar(1000)
		
		BEGIN
		BEGIN
		SELECT @DBString = 1
		
			
			EXECUTE (''UPDATE WFCABINETUPGRADELOGTABLE set ENDDATE = getdate(), STATUS = ''''UPDATED'''' WHERE STEPNUMBER ='' + @v_stepNumber +'' AND STATUS = ''''INSIDE''''  AND SCRIPTNAME=''''''+@v_scriptName+'''''''')
			
			EXECUTE (''UPDATE WFCABINETUPGRADELOGTABLE set ENDDATE = getdate(), STATUS = ''''SKIPPED'''' WHERE STEPNUMBER ='' + @v_stepNumber +'' AND STATUS = ''''UPDATING''''  AND SCRIPTNAME=''''''+@v_scriptName+'''''''')
			IF @@ROWCOUNT = 1
				return @DBString
			END
		END')
	PRINT 'As Procedure LogUpdateCab created........... '
END				

~
If Exists (SELECT 1 FROM SYSObjects WHERE NAME = 'Upgrade' AND xType = 'P')
BEGIN
	Drop Procedure Upgrade
	PRINT 'As Procedure Upgrade exists dropping old procedure ........... '
END				
~

PRINT 'Creating procedure Upgrade ........... '
~


Create Procedure Upgrade AS
BEGIN
	DECLARE @QueueID INT
	DECLARE @ProcessDefId INT
	DECLARE @activityID INT
	DECLARE @ErrorMessage	NVARCHAR(100)
	Declare @primaryKeyName NVARCHAR(200)
	Declare @query NVARCHAR(1000)
	DECLARE @UserIndex INTEGER
	DECLARE @GroupIndex_Str NVARCHAR(6)
	DECLARE @IsMakerCheckerEnabled CHAR(1)
	DECLARE @License_Int INT
	DECLARE @PwdSensitivity CHAR(1)
	DECLARE @UserPassword varbinary(128)
	DECLARE @ActivityCount INT
	DECLARE @constrnName NVARCHAR(200)
	DECLARE @v_logStatus NVARCHAR(10)
	DECLARE @v_scriptName varchar(100)
	DECLARE @Alias NVARCHAR(63)
	DECLARE @Param1 NVARCHAR(50)
	DECLARE @DataClassName NVARCHAR(255)
	DECLARE @DocTypeId INT
	DECLARE @ArchiveId INT
	DECLARE @DataFieldName NVARCHAR(255)
	SET NOCOUNT ON
	SELECT @v_scriptName = 'Upgrade10_3_SP0'
	
	BEGIN TRY
		IF NOT EXISTS(SELECT * FROM SYSObjects WHERE NAME = 'WFCABINETUPGRADELOGTABLE')
		BEGIN
			EXECUTE ('CREATE TABLE WFCABINETUPGRADELOGTABLE(STEPNUMBER INT NOT NULL,
						SCRIPTNAME nvarchar(100) NOT NULL,
						STEPDETAILS nvarchar(1000),
						STARTDATE datetime,
						ENDDATE datetime,
						STATUS nvarchar(20),
						CONSTRAINT PK_CabUpgrade PRIMARY KEY (STEPNUMBER,SCRIPTNAME))')
						
			PRINT 'WFCABINETUPGRADELOGTABLE Table Created'

		END
		ELSE
		BEGIN
			IF NOT EXISTS (SELECT 1 FROM SYSColumns WHERE NAME = 'SCRIPTNAME' AND ID = (SELECT ID FROM SYSObjects WHERE NAME ='WFCABINETUPGRADELOGTABLE'))
			BEGIN 
				EXECUTE('DROP TABLE WFCABINETUPGRADELOGTABLE')
				EXECUTE('CREATE TABLE WFCABINETUPGRADELOGTABLE(STEPNUMBER INT NOT NULL,
						SCRIPTNAME nvarchar(100) NOT NULL,
						STEPDETAILS nvarchar(1000),
						STARTDATE datetime,
						ENDDATE datetime,
						STATUS nvarchar(20),
						CONSTRAINT PK_CabUpgrade PRIMARY KEY (STEPNUMBER,SCRIPTNAME))')
				PRINT 'WFCABINETUPGRADELOGTABLE Table Created'
			END
		
			EXECUTE ('DELETE FROM WFCABINETUPGRADELOGTABLE')
			PRINT 'WFCABINETUPGRADELOGTABLE entries deleted'
		END
	END TRY
	BEGIN CATCH
	
	END CATCH
	
	IF NOT EXISTS(SELECT 1 FROM syscolumns where NAME = 'MobileEnabled' AND id = (SELECT id from sysobjects where NAME = 'ACTIVITYTABLE'))
	BEGIN
			
			ALTER TABLE ACTIVITYTABLE ADD MobileEnabled	Nvarchar(2)
	END
	

	exec @v_logStatus= LogInsertCab 1,@v_scriptName,' Adding Queue of QueueType A for WebServiceInvoker Utility '
	BEGIN
	BEGIN TRY	
		/* Adding WebService Queue, QueueType A*/
		IF NOT EXISTS(SELECT QueueId FROM QueueDefTable WHERE QueueType = 'A' and QueueName = 'SystemWSQueue')
		BEGIN	
			exec  @v_logStatus = LogSkipCab 1,@v_scriptName	
			EXECUTE('insert into QueueDefTable(QueueName,QueueType,Comments,AllowReassignment,FilterOption,FilterValue,OrderBy,QueueFilter,RefreshInterval,SortOrder,ProcessName) values(''SystemWSQueue'',''A'',''Queue of QueueType A for WebServiceInvoker Utility is added thorugh Upgradenew.sql'',NULL,NULL,NULL,10,NULL,NULL,''A'',NULL)')
			SELECT @QueueID = @@IDENTITY
			print 'QueueId : ' + CONVERT(VARCHAR,@QueueID)
			DECLARE cursor1 CURSOR STATIC FOR Select ProcessDefId, ActivityId from ActivityTable WHERE ActivityType = 22
			OPEN cursor1
			FETCH NEXT FROM cursor1 INTO @ProcessDefId, @activityID
			WHILE(@@FETCH_STATUS = 0) 
			BEGIN
				BEGIN TRANSACTION trans
					EXECUTE('Update QueueStreamTable set QueueId = ' + @QueueID + ' where ActivityId = ' + @activityID + ' and ProcessDefId = ' + @ProcessDefId)
					EXECUTE('Update WFInstrumentTable set QueueName=''SystemWSQueue'',Q_queueId = ' + @QueueID + ' where ActivityId = ' + @activityID + ' and ProcessDefId = ' + @ProcessDefId + ' and RoutingStatus =''N'' and LockStatus = ''N'' ')
					EXECUTE('Update WFInstrumentTable set QueueName = ''SystemWSQueue'',Q_queueId = ' + @QueueID + ' where ActivityId = ' + @activityID + ' and ProcessDefId = '+@ProcessDefId+ ' and RoutingStatus =''N'' and LockStatus = ''Y'' ')
				COMMIT TRANSACTION trans
				FETCH NEXT FROM cursor1 INTO @ProcessDefId, @activityID
			END
			CLOSE cursor1
			DEALLOCATE cursor1
		END

	END TRY
	BEGIN CATCH    
		exec  @v_logStatus = LogFailedCab 1,@v_scriptName
		RAISERROR('Block 1 Failed.',16,1)
		RETURN
	END CATCH
	END

exec @v_logStatus = LogUpdateCab 1,@v_scriptName

exec @v_logStatus = LogInsertCab 2,@v_scriptName,'Adding Queue of QueueType A for SAPInvoker Utility'	
	BEGIN
	BEGIN TRY
		IF NOT EXISTS(SELECT QueueId FROM QueueDefTable WHERE QueueType = 'A' and QueueName = 'SystemSAPQueue')
		BEGIN
			exec  @v_logStatus = LogSkipCab 2,@v_scriptName		
			EXECUTE('insert into QueueDefTable 						(QueueName,QueueType,Comments,AllowReassignment,FilterOption,FilterValue,OrderBy,QueueFilter,RefreshInterval,SortOrder,ProcessName) values(''SystemSAPQueue'',''A'',''Queue of QueueType A for SAPInvoker Utility is added thorugh Upgradenew.sql'',NULL,NULL,NULL,10,NULL,NULL,''A'',NULL)')
			SELECT @QueueID = @@IDENTITY
			DECLARE cursor1 CURSOR STATIC FOR Select ProcessDefId, ActivityId from ActivityTable WHERE ActivityType = 29
			OPEN cursor1
			FETCH NEXT FROM cursor1 INTO @ProcessDefId, @activityID
			WHILE(@@FETCH_STATUS = 0) 
			BEGIN
				BEGIN TRANSACTION trans
					EXECUTE('Update QueueStreamTable set QueueId = ' + @QueueID + ' where ActivityId = ' + @activityID + ' and ProcessDefId = ' + @ProcessDefId)
					EXECUTE('Update WFInstrumentTable set QueueName=''SystemSAPQueue'',Q_queueId = ' + @QueueID + ' where ActivityId = ' + @activityID + ' and ProcessDefId = ' + @ProcessDefId + ' and RoutingStatus =''N'' and LockStatus = ''N'' ')
					EXECUTE('Update WFInstrumentTable set QueueName = ''SystemSAPQueue'',Q_queueId = ' + @QueueID + ' where ActivityId = ' + @activityID + ' and ProcessDefId = '+@ProcessDefId+ ' and RoutingStatus =''N'' and LockStatus = ''Y'' ')
				COMMIT TRANSACTION trans
				FETCH NEXT FROM cursor1 INTO @ProcessDefId, @activityID
			END
			CLOSE cursor1
			DEALLOCATE cursor1
		END
	END TRY
	BEGIN CATCH      
	exec  @v_logStatus = LogFailedCab 2,@v_scriptName
	RAISERROR('Block 2 Failed.',16,1)
	RETURN
	END CATCH
	END
exec @v_logStatus = LogUpdateCab 2,@v_scriptName

exec @v_logStatus = LogInsertCab 3,@v_scriptName,'Adding Queue of QueueType A for SystemBRMSQueue Utility'	
	BEGIN
	BEGIN TRY
		/* Adding BRMS Queue, QueueType A*/
		IF NOT EXISTS(SELECT QueueId FROM QueueDefTable WHERE QueueType = 'A' and QueueName = 'SystemBRMSQueue')
		BEGIN
			exec  @v_logStatus = LogSkipCab 3,@v_scriptName			
			EXECUTE('insert into QueueDefTable 						(QueueName,QueueType,Comments,AllowReassignment,FilterOption,FilterValue,OrderBy,QueueFilter,RefreshInterval,SortOrder,ProcessName) values(''SystemBRMSQueue'',''A'',''Queue of QueueType A for SystemBRMSQueue Utility is added thorugh Upgradenew.sql'',NULL,NULL,NULL,10,NULL,NULL,''A'',NULL)')
			SELECT @QueueID = @@IDENTITY
			print 'QueueId : ' + CONVERT(VARCHAR,@QueueID)
			DECLARE cursor1 CURSOR STATIC FOR Select ProcessDefId, ActivityId from ActivityTable WHERE ActivityType = 31
			OPEN cursor1
			FETCH NEXT FROM cursor1 INTO @ProcessDefId, @activityID
			WHILE(@@FETCH_STATUS = 0) 
			BEGIN
				BEGIN TRANSACTION trans
					EXECUTE('Update QueueStreamTable set QueueId = ' + @QueueID + ' where ActivityId = ' + @activityID + ' and ProcessDefId = ' + @ProcessDefId)
					EXECUTE('Update WFInstrumentTable set QueueName=''SystemBRMSQueue'',Q_queueId = ' + @QueueID + ' where ActivityId = ' + @activityID + ' and ProcessDefId = ' + @ProcessDefId + ' and RoutingStatus =''N'' and LockStatus = ''N'' ')
					EXECUTE('Update WFInstrumentTable set QueueName = ''SystemBRMSQueue'',Q_queueId = ' + @QueueID + ' where ActivityId = ' + @activityID + ' and ProcessDefId = '+@ProcessDefId+ ' and RoutingStatus =''N'' and LockStatus = ''Y'' ')
				COMMIT TRANSACTION trans
				FETCH NEXT FROM cursor1 INTO @ProcessDefId, @activityID
			END
			CLOSE cursor1
			DEALLOCATE cursor1
		END
	END TRY
	BEGIN CATCH      
	exec  @v_logStatus = LogFailedCab 3,@v_scriptName
	RAISERROR('Block 3 Failed.',16,1)
	RETURN
	END CATCH
	END
exec @v_logStatus = LogUpdateCab 3,@v_scriptName

exec @v_logStatus = LogInsertCab 4,@v_scriptName,'Dropping first then adding Check Constraint On CommentsType in WFCommentsTable'	
	BEGIN
	BEGIN TRY
		/* Modifying the Check contraint on WFCommentsTable */
		BEGIN
			
			SET @constrnName = ''
			SELECT @constrnName =  constraint_name FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE table_name = 'WFCommentsTable' AND constraint_type = 'CHECK'
			IF (@constrnName IS NOT NULL AND (LEN(@constrnName) > 0))
			BEGIN
				EXECUTE ('ALTER TABLE WFCommentsTable DROP CONSTRAINT ' + @constrnName)
			END
			EXECUTE('ALTER TABLE WFCommentsTable ADD CHECK(CommentsType IN (1, 2, 3, 4))')
		END;
	END TRY
	BEGIN CATCH      
	exec  @v_logStatus = LogFailedCab 4,@v_scriptName
	RAISERROR('Block 4 Failed.',16,1)
	RETURN
	END CATCH
	END
exec @v_logStatus = LogUpdateCab 4,@v_scriptName

exec @v_logStatus = LogInsertCab 5,@v_scriptName,'Adding new Column DateTimeFormat in WFExportTable'	
	BEGIN
	BEGIN TRY
		IF NOT EXISTS(SELECT 1 FROM syscolumns where NAME = 'DateTimeFormat' AND id = (SELECT id from sysobjects where NAME = 'WFExportTable'))
		BEGIN
			exec  @v_logStatus = LogSkipCab 5,@v_scriptName
			ALTER TABLE WFExportTable ADD DateTimeFormat NVARCHAR(50)
		END
	END TRY
	BEGIN CATCH      
	exec  @v_logStatus = LogFailedCab 5,@v_scriptName
	RAISERROR('Block 5 Failed.',16,1)
	RETURN
	END CATCH
	END
exec @v_logStatus = LogUpdateCab 5,@v_scriptName

exec @v_logStatus = LogInsertCab 6,@v_scriptName,'Creating Table pmsversioninfo'	
	BEGIN
	BEGIN TRY	
		IF NOT EXISTS(SELECT 1 from sysobjects where NAME = 'pmsversioninfo')
		BEGIN
			exec  @v_logStatus = LogSkipCab 6,@v_scriptName
			CREATE TABLE pmsversioninfo(
			   product_acronym varchar(100) not null,
			   label varchar(100) not null,
			   previouslabel varchar(100),
			   updatedon datetime DEFAULT GETDATE()
			)
			
			INSERT INTO pmsversioninfo(product_acronym,label, previouslabel) VALUES ('OF','LBL_SUP_000_22122014','')
		
		END
	END TRY
	BEGIN CATCH      
	exec  @v_logStatus = LogFailedCab 6,@v_scriptName
	RAISERROR('Block 6 Failed.',16,1)
	RETURN
	END CATCH
	END
exec @v_logStatus = LogUpdateCab 6,@v_scriptName

exec @v_logStatus = LogInsertCab 7,@v_scriptName,'Adding Primary Key on PROCESSINSTANCEID,WORKITEMID in WFAUDITTRAILDOCTABLE'	
	BEGIN
	BEGIN TRY		
		DECLARE @keycount INTEGER;
		SELECT @keycount = count(1)
		FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS AS TC
		INNER JOIN
		INFORMATION_SCHEMA.KEY_COLUMN_USAGE AS KU
        ON TC.CONSTRAINT_TYPE = 'PRIMARY KEY' AND
        TC.CONSTRAINT_NAME = KU.CONSTRAINT_NAME AND 
        KU.table_name='WFAUDITTRAILDOCTABLE'
		WHERE column_name in ('PROCESSINSTANCEID','WORKITEMID')
		
		If @keycount = 2
		print 'WFAUDITTRAILDOCTABLE already having COMPOSITE PRIMARY KEY of PROCESSINSTANCEID ,WORKITEMID'
		else
		BEGIN
			exec  @v_logStatus = LogSkipCab 13,@v_scriptName
			SELECT @primaryKeyName = name from sys.key_constraints where type= 'PK' and parent_object_id = OBJECT_ID('WFAUDITTRAILDOCTABLE')
			SELECT @query = ' ALTER table WFAUDITTRAILDOCTABLE drop constraint ' + @primaryKeyName
			EXECUTE sp_executeSQL @query
			ALTER table WFAUDITTRAILDOCTABLE ADD PRIMARY KEY  ( PROCESSINSTANCEID ,WORKITEMID )
		END
			
	END TRY
	BEGIN CATCH      
	exec  @v_logStatus = LogFailedCab 7,@v_scriptName
	RAISERROR('Block 7 Failed.',16,1)
	RETURN
	END CATCH
	END
exec @v_logStatus = LogUpdateCab 7,@v_scriptName

exec @v_logStatus = LogInsertCab 9,@v_scriptName,'Adding new column MobileEnabled in ACTIVITYTABLE'	
	BEGIN
	BEGIN TRY	
	
		/* CHANGES FOR MOBILE SUPPORRT BEGINS */
		
		IF NOT EXISTS(SELECT 1 FROM syscolumns where NAME = 'MobileEnabled' AND id = (SELECT id from sysobjects where NAME = 'ACTIVITYTABLE'))
		BEGIN
			exec  @v_logStatus = LogSkipCab 9,@v_scriptName
			ALTER TABLE ACTIVITYTABLE ADD MobileEnabled	Nvarchar(2)
		END
	END TRY
	BEGIN CATCH      
	exec  @v_logStatus = LogFailedCab 9,@v_scriptName
	RAISERROR('Block 9 Failed.',16,1)
	RETURN
	END CATCH
	END
exec @v_logStatus = LogUpdateCab 9,@v_scriptName

exec @v_logStatus = LogInsertCab 10,@v_scriptName,'Adding new column DeviceType in WFFORM_TABLE'	
	BEGIN
	BEGIN TRY
		/* WFFORM_TABLE Changes */
		IF NOT EXISTS(SELECT 1 FROM syscolumns where NAME = 'DeviceType' AND id = (SELECT id from sysobjects where NAME = 'WFFORM_TABLE'))
		BEGIN
			exec  @v_logStatus = LogSkipCab 10,@v_scriptName
			ALTER TABLE WFFORM_TABLE ADD DeviceType	NVARCHAR(1) NOT NULL DEFAULT 'D'
		END
	END TRY
	BEGIN CATCH      
	exec  @v_logStatus = LogFailedCab 10,@v_scriptName
	RAISERROR('Block 10 Failed.',16,1)
	RETURN
	END CATCH
	END
exec @v_logStatus = LogUpdateCab 10,@v_scriptName

exec @v_logStatus = LogInsertCab 11,@v_scriptName,'Adding new column FormHeight in WFFORM_TABLE'		
	BEGIN
	BEGIN TRY	
		IF NOT EXISTS(SELECT 1 FROM syscolumns where NAME = 'FormHeight' AND id = (SELECT id from sysobjects where NAME = 'WFFORM_TABLE'))
		BEGIN
			exec  @v_logStatus = LogSkipCab 11,@v_scriptName
			ALTER TABLE WFFORM_TABLE ADD FormHeight INT NOT NULL DEFAULT 100
		END
	END TRY
	BEGIN CATCH      
	exec  @v_logStatus = LogFailedCab 11,@v_scriptName
	RAISERROR('Block 11 Failed.',16,1)
	RETURN
	END CATCH
	END
exec @v_logStatus = LogUpdateCab 11,@v_scriptName

exec @v_logStatus = LogInsertCab 12,@v_scriptName,'Adding new column FormWidth in WFFORM_TABLE'	
	BEGIN
	BEGIN TRY	
		IF NOT EXISTS(SELECT 1 FROM syscolumns where NAME = 'FormWidth' AND id = (SELECT id from sysobjects where NAME = 'WFFORM_TABLE'))
		BEGIN
			exec  @v_logStatus = LogSkipCab 12,@v_scriptName
			ALTER TABLE WFFORM_TABLE ADD FormWidth INT NOT NULL DEFAULT 100
		END
	END TRY
	BEGIN CATCH      
	exec  @v_logStatus = LogFailedCab 12,@v_scriptName
	RAISERROR('Block 12 Failed.',16,1)
	RETURN
	END CATCH
	END
exec @v_logStatus = LogUpdateCab 12,@v_scriptName

exec @v_logStatus = LogInsertCab 13,@v_scriptName,'Adding new primary key on ProcessDefID,FormId,DeviceType in WFFORM_TABLE'	
	BEGIN
	BEGIN TRY	
		IF NOT EXISTS(SELECT 1 FROM sys.key_constraints where type= 'PK' and parent_object_id = OBJECT_ID('WFFORM_TABLE'))
		BEGIN
			exec  @v_logStatus = LogSkipCab 13,@v_scriptName
			ALTER table WFFORM_TABLE ADD PRIMARY KEY (ProcessDefID,FormId,DeviceType)
		END
	END TRY
	BEGIN CATCH      
	exec  @v_logStatus = LogFailedCab 13,@v_scriptName
	RAISERROR('Block 13 Failed.',16,1)
	RETURN
	END CATCH
	END
exec @v_logStatus = LogUpdateCab 13,@v_scriptName

exec @v_logStatus = LogInsertCab 14,@v_scriptName,'Adding new column DeviceType in WFFormFragmentTable'	
	BEGIN
	BEGIN TRY	
		/* WFFormFragmentTable Changes */
		IF NOT EXISTS(SELECT 1 FROM syscolumns where NAME = 'DeviceType' AND id = (SELECT id from sysobjects where NAME = 'WFFormFragmentTable'))
		BEGIN
			exec  @v_logStatus = LogSkipCab 14,@v_scriptName
			ALTER TABLE WFFormFragmentTable ADD DeviceType	NVARCHAR(1) NOT NULL DEFAULT 'D'
		END
	END TRY
	BEGIN CATCH      
	exec  @v_logStatus = LogFailedCab 14,@v_scriptName
	RAISERROR('Block 14 Failed.',16,1)
	RETURN
	END CATCH
	END
exec @v_logStatus = LogUpdateCab 14,@v_scriptName

exec @v_logStatus = LogInsertCab 15,@v_scriptName,'Adding new column FormHeight in WFFormFragmentTable'	
	BEGIN
	BEGIN TRY	
		IF NOT EXISTS(SELECT 1 FROM syscolumns where NAME = 'FormHeight' AND id = (SELECT id from sysobjects where NAME = 'WFFormFragmentTable'))
		BEGIN
			exec  @v_logStatus = LogSkipCab 15,@v_scriptName
			ALTER TABLE WFFormFragmentTable ADD FormHeight INT NOT NULL DEFAULT 100
		END
	END TRY
	BEGIN CATCH      
	exec  @v_logStatus = LogFailedCab 15,@v_scriptName
	RAISERROR('Block 15 Failed.',16,1)
	RETURN
	END CATCH
	END
exec @v_logStatus = LogUpdateCab 15,@v_scriptName

exec @v_logStatus = LogInsertCab 16,@v_scriptName,'Adding new column FormWidth in WFFormFragmentTable'	
	BEGIN
	BEGIN TRY	
		IF NOT EXISTS(SELECT 1 FROM syscolumns where NAME = 'FormWidth' AND id = (SELECT id from sysobjects where NAME = 'WFFormFragmentTable'))
		BEGIN
			exec  @v_logStatus = LogSkipCab 16,@v_scriptName
			ALTER TABLE WFFormFragmentTable ADD FormWidth INT NOT NULL DEFAULT 100
		END
	END TRY
	BEGIN CATCH      
	exec  @v_logStatus = LogFailedCab 16,@v_scriptName
	RAISERROR('Block 16 Failed.',16,1)
	RETURN
	END CATCH
	END
exec @v_logStatus = LogUpdateCab 16,@v_scriptName

exec @v_logStatus = LogInsertCab 17,@v_scriptName,'Adding new primary key on ProcessDefID,FragmentId in WFFormFragmentTable'
	BEGIN
	BEGIN TRY	
		IF NOT EXISTS(SELECT 1 FROM sys.key_constraints where type= 'PK' and parent_object_id = OBJECT_ID('WFFormFragmentTable'))
		BEGIN
			exec  @v_logStatus = LogSkipCab 17,@v_scriptName
			ALTER table WFFormFragmentTable ADD PRIMARY KEY (ProcessDefId,FragmentId)
		END
	END TRY
	BEGIN CATCH      
	exec  @v_logStatus = LogFailedCab 17,@v_scriptName
	RAISERROR('Block 17 Failed.',16,1)
	RETURN
	END CATCH
	END
exec @v_logStatus = LogUpdateCab 17,@v_scriptName

exec @v_logStatus = LogInsertCab 18,@v_scriptName,'CREATE TABLE WFWorkListConfigTable'	
	BEGIN
	BEGIN TRY	
		/* Creation of WFWorkListConfigTable*/
		
		IF NOT EXISTS(SELECT 1 from sysobjects where NAME = 'WFWorkListConfigTable')
		BEGIN
			exec  @v_logStatus = LogSkipCab 18,@v_scriptName
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
		END
	END TRY
	BEGIN CATCH      
	exec  @v_logStatus = LogFailedCab 18,@v_scriptName
	RAISERROR('Block 18 Failed.',16,1)
	RETURN
	END CATCH
	END
exec @v_logStatus = LogUpdateCab 18,@v_scriptName

exec @v_logStatus = LogInsertCab 19,@v_scriptName,'Adding new column context in processdeftable'	
	BEGIN
	BEGIN TRY
		IF NOT EXISTS ( SELECT * FROM sysColumns 
			WHERE 
			id = (SELECT id FROM sysObjects WHERE NAME = 'processdeftable')
			AND  NAME = 'context'
			)
		BEGIN	
			exec  @v_logStatus = LogSkipCab 19,@v_scriptName
			EXECUTE('ALTER TABLE processdeftable ADD context NVARCHAR(50)')
			PRINT 'Table processdeftable altered with new Column context'
		END
	END TRY
	BEGIN CATCH      
	exec  @v_logStatus = LogFailedCab 19,@v_scriptName
	RAISERROR('Block 19 Failed.',16,1)
	RETURN
	END CATCH
	END
exec @v_logStatus = LogUpdateCab 19,@v_scriptName


	/* CHANGES FOR MOBILE SUPPORRT ENDS */

	/* Adding FailRecords column in WFImportFileData table*/
exec @v_logStatus = LogInsertCab 20,@v_scriptName,'Adding new column FailRecords in WFImportFileData'	
	BEGIN
	BEGIN TRY
		IF NOT EXISTS (SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'WFImportFileData') AND  NAME = 'FailRecords')
		BEGIN
			exec  @v_logStatus = LogSkipCab 20,@v_scriptName
			EXECUTE('UPDATE WFImportFileData SET FileStatus = ''S'' WHERE FileStatus = ''I''')
			EXECUTE('ALTER TABLE WFImportFileData ADD FailRecords INT DEFAULT 0')
			EXECUTE('UPDATE WFImportFileData SET FailRecords = 0')
		END
	END TRY
	BEGIN CATCH      
	exec  @v_logStatus = LogFailedCab 20,@v_scriptName
	RAISERROR('Block 20 Failed.',16,1)
	RETURN
	END CATCH
	END
exec @v_logStatus = LogUpdateCab 20,@v_scriptName

exec @v_logStatus = LogInsertCab 21,@v_scriptName,'CREATE TABLE WFFailFileRecords'	
	BEGIN
	BEGIN TRY
		/* Creating WFFailFileRecords table*/
		IF NOT EXISTS (SELECT * FROM sysObjects WHERE NAME = 'WFFailFileRecords')
		BEGIN
			exec  @v_logStatus = LogSkipCab 21,@v_scriptName
			EXECUTE(
				'CREATE TABLE WFFailFileRecords (
					FailRecordId INT IDENTITY (1, 1),
					FileIndex INT,
					RecordNo INT,
					RecordData NVARCHAR(2000),
					Message NVARCHAR(1000),
					EntryTime DATETIME DEFAULT GETDATE()
				)'
			)
		END
	END TRY
	BEGIN CATCH      
	exec  @v_logStatus = LogFailedCab 21,@v_scriptName
	RAISERROR('Block 21 Failed.',16,1)
	RETURN
	END CATCH
	END
exec @v_logStatus = LogUpdateCab 21,@v_scriptName

exec @v_logStatus = LogInsertCab 22,@v_scriptName,'Adding new column ThresholdRoutingCount in ProcessDefTable'		
	BEGIN
	BEGIN TRY	
		/* Adding ThresholdRoutingCount column in ProcessDefTable */
		IF NOT EXISTS (SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'ProcessDefTable') AND  NAME = 'ThresholdRoutingCount')
		BEGIN
			exec  @v_logStatus = LogSkipCab 22,@v_scriptName
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
		END
	END TRY
	BEGIN CATCH      
	exec  @v_logStatus = LogFailedCab 22,@v_scriptName
	RAISERROR('Block 22 Failed.',16,1)
	RETURN
	END CATCH
	END
exec @v_logStatus = LogUpdateCab 22,@v_scriptName

exec @v_logStatus = LogInsertCab 23,@v_scriptName,'Adding new CONSTRAINT on VAR_REC_5 in WFInstrumentTable'		
	BEGIN
	BEGIN TRY	
		/* Updating UserDefinedName to RoutingCount for Var_Rec_5 */
		IF EXISTS(SELECT * FROM VARMAPPINGTABLE WHERE UPPER(USERDEFINEDNAME) = 'VAR_REC_5')
		BEGIN
			exec  @v_logStatus = LogSkipCab 23,@v_scriptName
			EXECUTE('UPDATE VARMAPPINGTABLE SET USERDEFINEDNAME = ''RoutingCount'' WHERE UPPER(USERDEFINEDNAME) = ''VAR_REC_5''')
			EXECUTE('ALTER TABLE WFInstrumentTable ADD CONSTRAINT DF_VAR_REC_5 DEFAULT ''0'' FOR VAR_REC_5')
			EXECUTE('UPDATE WFInstrumentTable SET VAR_REC_5 = ''0'' WHERE VAR_REC_5 is NULL OR LEN(VAR_REC_5) <= 0')
			PRINT 'RoutingCount variable mapped with Var_Rec_5 successfully.'
		END
	END TRY
	BEGIN CATCH      
	exec  @v_logStatus = LogFailedCab 23,@v_scriptName
	RAISERROR('Block 23 Failed.',16,1)
	RETURN
	END CATCH
	END
exec @v_logStatus = LogUpdateCab 23,@v_scriptName

exec @v_logStatus = LogInsertCab 24,@v_scriptName,'CREATE TABLE WFCommentsHistoryTable'	
	BEGIN
	BEGIN TRY
		-- Creating WFCommentsHistoryTable
		IF NOT EXISTS(select * from sysobjects where name = 'WFCommentsHistoryTable')
		BEGIN
			exec  @v_logStatus = LogSkipCab 24,@v_scriptName
			EXECUTE(
				'CREATE TABLE WFCommentsHistoryTable(
					CommentsId			INT				PRIMARY KEY,
					ProcessDefId 		INT 			NOT NULL,
					ActivityId 			INT 			NOT NULL,
					ProcessInstanceId 	NVARCHAR(64) 	NOT NULL,
					WorkItemId 			INT 			NOT NULL,
					CommentsBy			INT 			NOT NULL,
					CommentsByName		NVARCHAR(64) 	NOT NULL,
					CommentsTo			INT 			NOT NULL,
					CommentsToName		NVARCHAR(64)	NOT NULL,
					Comments			NVARCHAR(1000)	NULL,
					ActionDateTime		DATETIME		NOT NULL,
					CommentsType		INT				NOT NULL	CHECK(CommentsType IN (1, 2, 3, 4))
				)'
			)
		END
END TRY
	BEGIN CATCH      
	exec  @v_logStatus = LogFailedCab 24,@v_scriptName
	RAISERROR('Block 24 Failed.',16,1)
	RETURN
	END CATCH
	END
exec @v_logStatus = LogUpdateCab 24,@v_scriptName

exec @v_logStatus = LogInsertCab 25,@v_scriptName,'Adding new Column AppServerId in WFSystemServicesTable'	
	BEGIN
	BEGIN TRY
		-- Adding AppServerId column in WFSystemServicesTable
		IF NOT EXISTS (SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'WFSystemServicesTable') AND  NAME = 'AppServerId')
		BEGIN
			exec  @v_logStatus = LogSkipCab 25,@v_scriptName
			EXECUTE('ALTER TABLE WFSystemServicesTable ADD AppServerId NVARCHAR(50)')
		END
	END TRY
	BEGIN CATCH      
	exec  @v_logStatus = LogFailedCab 25,@v_scriptName
	RAISERROR('Block 25 Failed.',16,1)
	RETURN
	END CATCH
	END
exec @v_logStatus = LogUpdateCab 25,@v_scriptName

	exec @v_logStatus = LogInsertCab 26, @v_scriptName, 'Droping column ProcessInstanceId from WFMessageTable'
	BEGIN
	BEGIN TRY
		IF EXISTS (SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'WFMessageTable') AND  NAME = 'ProcessInstanceId')
		BEGIN
			exec @v_logStatus = LogSkipCab 26, @v_scriptName
			EXECUTE('ALTER TABLE WFMessageTable DROP COLUMN ProcessInstanceId')
		END
	END TRY
	BEGIN CATCH
		exec @v_logStatus = LogFailedCab 26, @v_scriptName
		RAISERROR('Block 26 Failed.', 16, 1)
		RETURN
	END CATCH
	END
	exec @v_logStatus = LogUpdateCab 26, @v_scriptName

	exec @v_logStatus = LogInsertCab 27, @v_scriptName, 'Droping column ActionId from WFMessageTable'
	BEGIN
	BEGIN TRY
		IF EXISTS (SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'WFMessageTable') AND  NAME = 'ActionId')
		BEGIN
			exec @v_logStatus = LogSkipCab 27, @v_scriptName
			EXECUTE('ALTER TABLE WFMessageTable DROP COLUMN ActionId')
		END
	END TRY
	BEGIN CATCH
		exec @v_logStatus = LogFailedCab 27, @v_scriptName
		RAISERROR('Block 27 Failed.', 16, 1)
		RETURN
	END CATCH
	END
	exec @v_logStatus = LogUpdateCab 27, @v_scriptName

	exec @v_logStatus = LogInsertCab 28, @v_scriptName, 'Droping column ProcessInstanceId from WFFailedMessageTable'
	BEGIN
	BEGIN TRY
		IF EXISTS (SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'WFFailedMessageTable') AND  NAME = 'ProcessInstanceId')
		BEGIN
			exec @v_logStatus = LogSkipCab 28, @v_scriptName
			EXECUTE('ALTER TABLE WFFailedMessageTable DROP COLUMN ProcessInstanceId')
		END
	END TRY
	BEGIN CATCH
		exec @v_logStatus = LogFailedCab 28, @v_scriptName
		RAISERROR('Block 28 Failed.', 16, 1)
		RETURN
	END CATCH
	END
	exec @v_logStatus = LogUpdateCab 28, @v_scriptName

	exec @v_logStatus = LogInsertCab 29, @v_scriptName, 'Droping column ActionId from WFFailedMessageTable'
	BEGIN
	BEGIN TRY
		IF EXISTS (SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'WFFailedMessageTable') AND  NAME = 'ActionId')
		BEGIN
			exec @v_logStatus = LogSkipCab 29, @v_scriptName
			EXECUTE('ALTER TABLE WFFailedMessageTable DROP COLUMN ActionId')
		END
	END TRY
	BEGIN CATCH
		exec @v_logStatus = LogFailedCab 29, @v_scriptName
		RAISERROR('Block 29 Failed.', 16, 1)
		RETURN
	END CATCH
	END
	exec @v_logStatus = LogUpdateCab 29, @v_scriptName

	exec @v_logStatus = LogInsertCab 30, @v_scriptName, 'Changing Type1 to SMALLINT in VarAliasTable'
	BEGIN TRY
		IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'VarAliasTable' AND column_name = 'Type1' AND data_type = 'SMALLINT')
		BEGIN
			exec @v_logStatus = LogSkipCab 30, @v_scriptName
			BEGIN TRY
				BEGIN TRANSACTION trans
				DECLARE aliascursor1 CURSOR STATIC FOR SELECT DISTINCT Alias, Param1, QueueId, ProcessDefId FROM VarAliasTable WITH(NOLOCK) WHERE (Type1 IS NULL OR Type1 = '' OR Type1 = 'C' OR Type1 = 'V' OR Type1 = '*')
				OPEN aliascursor1
				FETCH NEXT FROM aliascursor1 INTO @Alias, @Param1, @QueueID, @ProcessDefId
				WHILE(@@FETCH_STATUS = 0)
				BEGIN
					IF @ProcessDefId IS NULL OR @ProcessDefId = 0
					BEGIN
						UPDATE VarAliasTable SET Type1 = (SELECT TOP 1 VariableType FROM VarMappingTable WITH(NOLOCK) WHERE SystemDefinedName = @Param1) WHERE Alias = @Alias AND QueueId = @QueueID
					END
					ELSE
					BEGIN
						UPDATE VarAliasTable SET Type1 = (SELECT TOP 1 VariableType FROM VarMappingTable WITH(NOLOCK) WHERE SystemDefinedName = @Param1) WHERE Alias = @Alias AND QueueId = @QueueID AND ProcessDefId = @ProcessDefId
					END
					FETCH NEXT FROM aliascursor1 INTO @Alias, @Param1, @QueueID, @ProcessDefId
				END
				CLOSE aliascursor1
				DEALLOCATE aliascursor1
				COMMIT TRANSACTION trans
			END TRY
			BEGIN CATCH
				ROLLBACK TRANSACTION trans
				IF (SELECT CURSOR_STATUS('global', 'aliascursor1')) >= -1
				BEGIN
					IF (SELECT CURSOR_STATUS('global', 'aliascursor1')) > -1
					BEGIN
						CLOSE aliascursor1
					END
					DEALLOCATE aliascursor1
				END
				exec @v_logStatus = LogFailedCab 30, @v_scriptName
				RAISERROR('Block 30 Failed.', 16, 1)
				RETURN
			END CATCH
			EXECUTE('ALTER TABLE VarAliasTable ALTER COLUMN Type1 SMALLINT')
		END
	END TRY
	BEGIN CATCH
		exec @v_logStatus = LogFailedCab 30, @v_scriptName
		RAISERROR('Block 30 Failed.', 16, 1)
		RETURN
	END CATCH
	exec @v_logStatus = LogUpdateCab 30, @v_scriptName

	exec @v_logStatus = LogInsertCab 31, @v_scriptName, 'Setting data class id used in archive activity if blank'
	BEGIN TRY
		exec @v_logStatus = LogSkipCab 31, @v_scriptName
		BEGIN TRY
			BEGIN TRANSACTION trans
			DECLARE tempcur CURSOR STATIC FOR SELECT ProcessDefId, ActivityId, ArchiveDataClassName FROM ArchiveTable WITH(NOLOCK) WHERE ArchiveDataClassName IS NOT NULL AND ArchiveDataClassId IS NULL
			OPEN tempcur
			FETCH NEXT FROM tempcur INTO @ProcessDefId, @activityID, @DataClassName 
			WHILE(@@FETCH_STATUS = 0)
			BEGIN
				UPDATE ArchiveTable SET ArchiveDataClassId = (SELECT DataDefIndex FROM PDBDataDefinition WITH(NOLOCK) WHERE DataDefName = @DataClassName) WHERE ProcessDefId = @ProcessDefId AND ActivityId = @activityID AND ArchiveDataClassName = @DataClassName
				FETCH NEXT FROM tempcur INTO @ProcessDefId, @activityID, @DataClassName
			END
			CLOSE tempcur
			DEALLOCATE tempcur
			COMMIT TRANSACTION trans
		END TRY
		BEGIN CATCH
			ROLLBACK TRANSACTION trans
			IF (SELECT CURSOR_STATUS('global', 'tempcur')) >= -1
			BEGIN
				IF (SELECT CURSOR_STATUS('global', 'tempcur')) > -1
				BEGIN
					CLOSE tempcur
				END
				DEALLOCATE tempcur
			END
			exec @v_logStatus = LogFailedCab 31, @v_scriptName
			RAISERROR('Block 31 Failed.', 16, 1)
			RETURN
		END CATCH

		BEGIN TRY
			BEGIN TRANSACTION trans
			DECLARE tempcur CURSOR STATIC FOR SELECT ProcessDefId, ArchiveId, DocTypeId, AssocClassName FROM ArchiveDocTypeTable WITH(NOLOCK) WHERE AssocClassName IS NOT NULL AND AssocClassId IS NULL
			OPEN tempcur
			FETCH NEXT FROM tempcur INTO @ProcessDefId, @ArchiveId, @DocTypeId, @DataClassName
			WHILE(@@FETCH_STATUS = 0)
			BEGIN
				UPDATE ArchiveDocTypeTable SET AssocClassId = (SELECT DataDefIndex FROM PDBDataDefinition WITH(NOLOCK) WHERE DataDefName = @DataClassName) WHERE ProcessDefId = @ProcessDefId AND ArchiveId = @ArchiveId AND DocTypeId = @DocTypeId AND AssocClassName = @DataClassName
				FETCH NEXT FROM tempcur INTO @ProcessDefId, @ArchiveId, @DocTypeId, @DataClassName
			END
			CLOSE tempcur
			DEALLOCATE tempcur
			COMMIT TRANSACTION trans
		END TRY
		BEGIN CATCH
			ROLLBACK TRANSACTION trans
			IF (SELECT CURSOR_STATUS('global', 'tempcur')) >= -1
			BEGIN
				IF (SELECT CURSOR_STATUS('global', 'tempcur')) > -1
				BEGIN
					CLOSE tempcur
				END
				DEALLOCATE tempcur
			END
			exec @v_logStatus = LogFailedCab 31, @v_scriptName
			RAISERROR('Block 31 Failed.', 16, 1)
			RETURN
		END CATCH

		BEGIN TRY
			BEGIN TRANSACTION trans
			DECLARE tempcur CURSOR STATIC FOR SELECT A.ProcessDefId, A.ArchiveId, A.DocTypeId, A.DataFieldName, B.AssocClassName FROM ArchiveDataMapTable A WITH(NOLOCK), ArchiveDocTypeTable B WITH(NOLOCK) WHERE A.ProcessDefId = B.ProcessDefId AND A.ArchiveId = B.ArchiveId AND A.DocTypeId = B.DocTypeId AND A.DataFieldName IS NOT NULL AND A.DataFieldId IS NULL
			OPEN tempcur
			FETCH NEXT FROM tempcur INTO @ProcessDefId, @ArchiveId, @DocTypeId, @DataFieldName, @DataClassName
			WHILE(@@FETCH_STATUS = 0)
			BEGIN
				UPDATE ArchiveDataMapTable SET DataFieldId = (SELECT A.DataFieldIndex FROM PDBGlobalIndex A WITH(NOLOCK), PDBDataFieldsTable B WITH(NOLOCK), PDBDataDefinition C WITH(NOLOCK) WHERE A.DataFieldIndex = B.DataFieldIndex AND B.DataDefIndex = C.DataDefIndex AND C.DataDefName = @DataClassName AND A.DataFieldName = @DataFieldName) WHERE ProcessDefId = @ProcessDefId AND ArchiveId = @ArchiveId AND DocTypeId = @DocTypeId AND DataFieldName = @DataFieldName
				FETCH NEXT FROM tempcur INTO @ProcessDefId, @ArchiveId, @DocTypeId, @DataFieldName, @DataClassName
			END
			CLOSE tempcur
			DEALLOCATE tempcur
			COMMIT TRANSACTION trans
		END TRY
		BEGIN CATCH
			ROLLBACK TRANSACTION trans
			IF (SELECT CURSOR_STATUS('global', 'tempcur')) >= -1
			BEGIN
				IF (SELECT CURSOR_STATUS('global', 'tempcur')) > -1
				BEGIN
					CLOSE tempcur
				END
				DEALLOCATE tempcur
			END
			exec @v_logStatus = LogFailedCab 31, @v_scriptName
			RAISERROR('Block 31 Failed.', 16, 1)
			RETURN
		END CATCH
	END TRY
	BEGIN CATCH
		exec @v_logStatus = LogFailedCab 31, @v_scriptName
		RAISERROR('Block 31 Failed.', 16, 1)
		RETURN
	END CATCH
	exec @v_logStatus = LogUpdateCab 31, @v_scriptName

END

~

PRINT 'Executing procedure Upgrade ........... '
EXEC upgrade

~

DROP PROCEDURE upgrade

~


