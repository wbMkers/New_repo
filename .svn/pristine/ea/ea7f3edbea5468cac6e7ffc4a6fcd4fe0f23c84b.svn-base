/*
Change DATE		Name				Description
--------------------------------------------------------------
26/05/2017		Sanal Grover		Bug 62518 - Step by Step Debugs in Version Upgrade.
*/ 

If Exists (SELECT 1 FROM SYSObjects WHERE NAME = 'Upgrade' AND xType = 'P')
BEGIN
	Drop Procedure Upgrade
	PRINT 'As Procedure Upgrade exists dropping old procedure ........... '
END
PRINT 'Creating procedure Upgrade ........... '
~

Create Procedure Upgrade AS
BEGIN
	SET NOCOUNT ON
	DECLARE @ProcessDefId		INT
	Declare @existsFlag		INT
	Declare @TableId INT
	Declare @ConstraintName VARCHAR(255)
	DECLARE @v_logStatus  NVARCHAR(10) 
	DECLARE @v_scriptName varchar(100)
	
	SELECT @v_scriptName = 'Upgrade09_SP00_009_history'
	
		
exec @v_logStatus= LogInsert 1,@v_scriptName,'Adding new Column ExceptionComments in ExceptionHistoryTable'
	BEGIN
	BEGIN TRY	
	
		IF NOT EXISTS ( SELECT * FROM sysColumns 
			WHERE 
			id = (SELECT id FROM sysObjects WHERE NAME = 'ExceptionHistoryTable')
			AND  NAME = 'ExceptionComments'
			)
		BEGIN
			exec  @v_logStatus = LogSkip 1,@v_scriptName
			EXECUTE('ALTER TABLE ExceptionHistoryTable ALTER COLUMN ExceptionComments NVarchar(1024)')
			PRINT 'Table ExceptionHistoryTable altered with new Column ExceptionComments'
		END
		
	END TRY
	BEGIN CATCH
		exec  @v_logStatus = LogFailed 1,@v_scriptName
		RAISERROR('Block 1 Failed.',16,1)
		RETURN
	END CATCH	
	END
exec @v_logStatus = LogUpdate 1,@v_scriptName

exec @v_logStatus= LogInsert 2,@v_scriptName,'Creating TABLE WFMAILQUEUEHISTORYTABLE'
	BEGIN
	BEGIN TRY
		IF EXISTS(
			   select *
			   from information_schema.columns where table_name = 'wfmailqueuehistorytable'
			   and data_type = 'text'
		)
		BEGIN
			exec  @v_logStatus = LogSkip 2,@v_scriptName
			EXECUTE(' sp_rename wfmailqueuehistorytable,wfmailqueuehistorytable_old ')
			PRINT 'Original wfmailqueuehistorytable renamed to wfmailqueuehistorytable_old'
			EXECUTE('
				CREATE TABLE WFMAILQUEUEHISTORYTABLE(
					TaskId 			INTEGER		PRIMARY KEY,
					mailFrom 		NVARCHAR(255),
					mailTo 			NVARCHAR(512), 
					mailCC 			NVARCHAR(512), 
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
				)
			')
			 PRINT 'New wfmailqueuehistorytable created with nText'
			 EXECUTE('insert into WFMAILQUEUEHISTORYTABLE select * from wfmailqueuehistorytable_old ')
			PRINT 'Table wfmailqueuehistorytable updated successfully'
		END 
		
	END TRY
	BEGIN CATCH
		exec  @v_logStatus = LogFailed 2,@v_scriptName
		RAISERROR('Block 2 Failed.',16,1)
		RETURN
	END CATCH	
	END
exec @v_logStatus = LogUpdate 2,@v_scriptName

exec @v_logStatus = LogInsert 3,@v_scriptName,'Adding new Column ExportStatus in QueueHistoryTable'
	BEGIN
	BEGIN TRY
		IF NOT EXISTS ( SELECT * FROM sysColumns 
			WHERE 
			id = (SELECT id FROM sysObjects WHERE NAME = 'QueueHistoryTable')
			AND  NAME = 'ExportStatus'
			)
		BEGIN	
			exec  @v_logStatus = LogSkip 3,@v_scriptName	
			ALTER TABLE QueueHistoryTable ADD ExportStatus NVARCHAR(1) DEFAULT ('N')
			PRINT 'Table QueueHistoryTable altered with new Column ExportStatus'
		END	
		
	END TRY
	BEGIN CATCH
		exec  @v_logStatus = LogFailed 3,@v_scriptName
		RAISERROR('Block 3 Failed.',16,1)
		RETURN
	END CATCH	
	END
exec @v_logStatus = LogUpdate 3,@v_scriptName

exec @v_logStatus= LogInsert 4,@v_scriptName,'Changing Datatype of totalduration to bigint in SummaryTable'
	BEGIN
	BEGIN TRY
		IF NOT EXISTS (select column_name, data_type, character_maximum_length    
		  from information_schema.columns  
		 where table_name = 'SummaryTable' and COLUMN_NAME= 'totalduration' and data_type= 'bigint')
		 BEGIN
			exec  @v_logStatus = LogSkip 4,@v_scriptName
			EXECUTE('ALTER TABLE SummaryTable ALTER COLUMN totalduration BIGINT')
		 END
	END TRY
	BEGIN CATCH
		exec  @v_logStatus = LogFailed 4,@v_scriptName
		RAISERROR('Block 4 Failed.',16,1)
		RETURN
	END CATCH	
	END
exec @v_logStatus = LogUpdate 4,@v_scriptName

exec @v_logStatus= LogInsert 5,@v_scriptName,'Changing Datatype of TotalProcessingTime to bigint in SummaryTable'
	BEGIN
	BEGIN TRY	 
	 
		 IF NOT EXISTS (select column_name, data_type, character_maximum_length    
		  from information_schema.columns  
		 where table_name = 'SummaryTable' and COLUMN_NAME= 'TotalProcessingTime' and data_type= 'bigint')
		 BEGIN
			exec  @v_logStatus = LogSkip 5,@v_scriptName
			EXECUTE('ALTER TABLE SummaryTable ALTER COLUMN TotalProcessingTime BIGINT')
		 END
	END TRY
	BEGIN CATCH
		exec  @v_logStatus = LogFailed 5,@v_scriptName
		RAISERROR('Block 5 Failed.',16,1)
		RETURN
	END CATCH	
	END
exec @v_logStatus = LogUpdate 5,@v_scriptName

exec @v_logStatus= LogInsert 6,@v_scriptName,'Changing Datatype of delaytime to bigint in SummaryTable'
	BEGIN
	BEGIN TRY 
	    IF NOT EXISTS (select column_name, data_type, character_maximum_length    
			from information_schema.columns  
			where table_name = 'SummaryTable' and COLUMN_NAME= 'delaytime' and data_type= 'bigint')
		BEGIN
			exec  @v_logStatus = LogSkip 6,@v_scriptName
			EXECUTE('ALTER TABLE SummaryTable ALTER COLUMN delaytime BIGINT') /* Ishu Saraf 16/01/2009 */
		END
	END TRY
	BEGIN CATCH
		exec  @v_logStatus = LogFailed 6,@v_scriptName
		RAISERROR('Block 6 Failed.',16,1)
		RETURN
	END CATCH	
	END
exec @v_logStatus = LogUpdate 6,@v_scriptName

END;

~

PRINT 'Executing procedure Upgrade ........... '
EXEC Upgrade
~			

DROP PROCEDURE Upgrade

~	