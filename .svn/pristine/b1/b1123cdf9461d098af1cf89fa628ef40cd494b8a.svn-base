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
05/08/2013	Sweta Bansal		Bug 41694 - Value of Expiry before and after version upgradation are not same in case the Expiry value is present like (90 * 24 + 0) before version upgrade.
01/01/2015	Chitvan Chhabra		Bug 52463 - Optimizations in version upgrade removing triggers and moving indexes in upgradeIndex file
14/09/2015	Dinkar Kad			Bug 56753 - While upgrading cabinet from OF 7.2 to OF 9 , expiry column in ActivityTable is updated as ('0*24 + ' + expiry) , where as it should contain value of DurationId column present in WFDurationTable
12/09/2016 Bhupendra Singh      Bug 62635 - procedure was unable to compile if VARIABLEID column not present in WFSEARCHVARIABLETABLE in
								OmniFlowVersionUpgrade
26/05/2017	Ashok Kumar		Bug 62518 - Step by Step Debugs in Version Upgrade.
__________________________________________________________________________________________________________________________________________________-*/

If Exists (Select * from SysObjects Where xType = 'P' and name = 'LogInsert')
BEGIN
	Drop Procedure LogInsert
	PRINT 'As Procedure LogInsert exists dropping old procedure with 2 Param ........... '
END

~

If Not Exists (Select * from SysObjects Where xType = 'P' and name = 'LogInsert')
Begin
	Execute('CREATE PROCEDURE LogInsert
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
				
				
				EXECUTE (''INSERT INTO WFVERSIONUPGRADELOGTABLE(STEPNUMBER,SCRIPTNAME,
					STEPDETAILS, STARTDATE, STATUS) VALUES
					(''+@v_stepNumber+'',''''''+@v_scriptName+'''''',''''''+ @v_stepDetails +'''''',getdate(), N''''UPDATING'''')'')
				IF @@ROWCOUNT = 1
					return @DBString
				END
			END')
	
End 

~

If Exists (Select * from SysObjects Where xType = 'P' and name = 'LogSkip')
BEGIN
	Drop Procedure LogSkip
	PRINT 'As Procedure LogSkip exists dropping old procedure ........... '
END

~

If Not Exists (Select * from SysObjects Where xType = 'P' and name = 'LogSkip')
Begin
	Execute('CREATE PROCEDURE LogSkip
		@v_stepNumber int,
		@v_scriptName varchar(100)
		AS
			DECLARE @DBString   NVARCHAR(50)
			DECLARE @dbQuery varchar(1000)

			BEGIN
			BEGIN
			SELECT @DBString = 1
			
				PRINT ''INSIDE''
				EXECUTE (''UPDATE WFVERSIONUPGRADELOGTABLE set ENDDATE = getdate(), STATUS = ''''INSIDE'''' WHERE STEPNUMBER ='' + @v_stepNumber +'' AND STATUS = ''''UPDATING'''' AND SCRIPTNAME = '''''' + @v_scriptName + '''''''')
				IF @@ROWCOUNT = 1
					return @DBString
				END
			END')
	
End
~

If Exists (Select * from SysObjects Where xType = 'P' and name = 'LogFailed')
BEGIN
	Drop Procedure LogFailed
	PRINT 'As Procedure LogFailed exists dropping old procedure ........... '
END

~

If Not Exists (Select * from SysObjects Where xType = 'P' and name = 'LogFailed')
Begin
	Execute('CREATE PROCEDURE LogFailed
		@v_stepNumber int,
		@v_scriptName varchar(100)
		AS
			DECLARE @DBString   NVARCHAR(50)
			DECLARE @dbQuery varchar(1000)
			
			BEGIN
			BEGIN
			SELECT @DBString = 1

				PRINT ''FAILED''
				EXECUTE (''UPDATE WFVERSIONUPGRADELOGTABLE set ENDDATE = getdate(), STATUS = ''''FAILED'''' WHERE STEPNUMBER ='' + @v_stepNumber +'' AND SCRIPTNAME=''''''+@v_scriptName+'''''''')
				IF @@ROWCOUNT = 1
					return @DBString
				END
			END')
	
End
~

If Exists (Select 1 from SysObjects Where xType = 'P' and name = 'LogUpdate')
BEGIN
	Drop Procedure LogUpdate
	PRINT 'As Procedure LogUpdate exists dropping old procedure with 2 Param ........... '
END

~

If Not Exists (SELECT 1 FROM SYSObjects WHERE NAME = 'LogUpdate' AND xType = 'P')
BEGIN
	Execute ('
		CREATE PROCEDURE LogUpdate
		@v_stepNumber int,
		@v_scriptName varchar(100)
		AS
			DECLARE @DBString   NVARCHAR(50)
			DECLARE @dbQuery varchar(1000)
			
			BEGIN
			BEGIN
			SELECT @DBString = 1
			
				
				EXECUTE (''UPDATE WFVERSIONUPGRADELOGTABLE set ENDDATE = getdate(), STATUS = ''''UPDATED'''' WHERE STEPNUMBER ='' + @v_stepNumber +'' AND STATUS = ''''INSIDE''''  AND SCRIPTNAME=''''''+@v_scriptName+'''''''')
				
				EXECUTE (''UPDATE WFVERSIONUPGRADELOGTABLE set ENDDATE = getdate(), STATUS = ''''SKIPPED'''' WHERE STEPNUMBER ='' + @v_stepNumber +'' AND STATUS = ''''UPDATING''''  AND SCRIPTNAME=''''''+@v_scriptName+'''''''')
				IF @@ROWCOUNT = 1
					return @DBString
				END
			END')
	
END				

~
If Exists (SELECT 1 FROM SYSObjects WHERE NAME = 'Upgrade' AND xType = 'P')
BEGIN
	Drop Procedure Upgrade
	PRINT 'As Procedure Upgrade exists dropping old procedure ........... '
END
PRINT 'Creating procedure Upgrade ........... '
~	

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
    DECLARE @v_TableExists		INT
	DECLARE @activity_ID     INT
	DECLARE @v_logStatus  NVARCHAR(10) 
	DECLARE @v_scriptName varchar(100)
	SELECT @dropFlag = 0
	SELECT @v_scriptName = 'Upgrade09_SP00_001'
	
		select @v_TableExists = 0
BEGIN

	BEGIN TRY
		IF NOT EXISTS(SELECT * FROM SYSObjects WHERE NAME = 'WFVERSIONUPGRADELOGTABLE')
		BEGIN
			
			EXECUTE ('CREATE TABLE WFVERSIONUPGRADELOGTABLE(STEPNUMBER INT NOT NULL,
						SCRIPTNAME nvarchar(100) NOT NULL,
						STEPDETAILS nvarchar(1000),
						STARTDATE datetime,
						ENDDATE datetime,
						STATUS nvarchar(20),
						CONSTRAINT PK_VersionUpgrade PRIMARY KEY (STEPNUMBER,SCRIPTNAME))')
			PRINT 'WFVERSIONUPGRADELOGTABLE Table Created'
		END
		ELSE
		BEGIN
			IF NOT EXISTS (SELECT 1 FROM SYSColumns WHERE NAME = 'SCRIPTNAME' AND ID = (SELECT ID FROM SYSObjects WHERE NAME ='WFVERSIONUPGRADELOGTABLE'))
			BEGIN 
				EXECUTE('DROP TABLE WFVERSIONUPGRADELOGTABLE')
				EXECUTE ('CREATE TABLE WFVERSIONUPGRADELOGTABLE(STEPNUMBER INT NOT NULL,
						SCRIPTNAME nvarchar(100) NOT NULL,
						STEPDETAILS nvarchar(1000),
						STARTDATE datetime,
						ENDDATE datetime,
						STATUS nvarchar(20),
						CONSTRAINT PK_VersionUpgrade PRIMARY KEY (STEPNUMBER,SCRIPTNAME))')
				PRINT 'WFVERSIONUPGRADELOGTABLE Table Created'
			END
		
			EXECUTE ('DELETE FROM WFVERSIONUPGRADELOGTABLE')
			PRINT 'WFVERSIONUPGRADELOGTABLE entries deleted'
		END
	END TRY
	BEGIN CATCH
	
	END CATCH
	

exec @v_logStatus= LogInsert 1,@v_scriptName,'Checking QUEUEDATATABLE exists or not'
	IF NOT EXISTS(SELECT * FROM SYSObjects WHERE NAME = 'QUEUEDATATABLE')
	BEGIN
		select @v_TableExists = 0
		PRINT 'QUEUEDATATABLE does not exists'
	End
	Else
	BEGIN
		Select @v_TableExists = 1
	END
	END
exec  @v_logStatus = LogUpdate 1,@v_scriptName

exec @v_logStatus = LogInsert 2,@v_scriptName,'Adding new columns cabVersion, Remarks In WFCabVersionTable if exist ,Else Create WFCabVersionTable table'
	BEGIN
	BEGIN TRY
		IF NOT EXISTS(Select * From sysObjects Where name = 'WFCabVersionTable')
		Begin
			exec  @v_logStatus = LogSkip 2,@v_scriptName
			Execute ('
			Create Table WFCabVersionTable (
				cabVersion	NVARCHAR(255) NOT NULL,
				cabVersionId	INT IDENTITY (1,1) PRIMARY KEY,
				creationDate	DATETIME,
				lastModified	DATETIME,
				Remarks		NVARCHAR(255) NOT NULL,
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
	END TRY
	BEGIN CATCH
		exec  @v_logStatus = LogFailed 2,@v_scriptName
		RAISERROR('Block 2 Failed.',16,1)
		RETURN
	END CATCH
	END
exec @v_logStatus = LogUpdate 2,@v_scriptName

exec @v_logStatus = LogInsert 3,@v_scriptName,'WFMessageTable altered with new Column ActionDateTime'
	BEGIN
	BEGIN TRY
		IF NOT EXISTS(SELECT * FROM SYSCOLUMNS WHERE NAME='ActionDateTime' AND id = (SELECT id FROM SYSOBJECTS WHERE NAME = 'WFMessageTable'  AND XTYPE='U' ))
		Begin
			exec  @v_logStatus = LogSkip 3,@v_scriptName
			Execute ('ALTER TABLE WFMessageTable ADD ActionDateTime DATETIME')
			Print 'Table WFMessageTable altered with new Column ActionDateTime'
		End

		SELECT @v_msgCount = COUNT(1) FROM WFMessageTable
		IF(@v_msgCount > 0)
		BEGIN
			SELECT @v_cabVersionId = @@IDENTITY
			UPDATE WFCabVersionTable SET Remarks = Remarks + N' - Upgrade Halted! WFMessageTable contains ' + CONVERT(NVARCHAR(10), @v_msgCount) + N' unprocessed messages. To process these messages run Message Agent. Thereafter, Upgrade once again.' WHERE cabVersionId =  @v_cabVersionId
			SELECT @v_msgStr = 'Upgrade Halted! WFMessageTable contains ' + CONVERT(NVARCHAR(10), @v_msgCount) + ' unprocessed messages. To process these messages run Message Agent. Thereafter, run Upgrade once again.'
			RAISERROR(@v_msgStr, 16, 1)
			RETURN
		END
	END TRY
	BEGIN CATCH
		exec  @v_logStatus = LogFailed 3,@v_scriptName
		RAISERROR('Block 3 Failed.',16,1)
		RETURN
	END CATCH
	END
exec @v_logStatus = LogUpdate 3,@v_scriptName

exec @v_logStatus = LogInsert 4,@v_scriptName,'Creating table ExtMethodDefTable'
	BEGIN
	BEGIN TRY
		IF NOT EXISTS (
			SELECT * FROM SYSObjects
			WHERE	name	= 'ExtMethodDefTable'
			AND	xType	= 'U'
		)
		Begin
			exec  @v_logStatus = LogSkip 4,@v_scriptName
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
	END TRY
	BEGIN CATCH
		exec  @v_logStatus = LogFailed 4,@v_scriptName
		RAISERROR('Block 4 Failed.',16,1)
		RETURN
	END CATCH
	END
exec @v_logStatus = LogUpdate 4,@v_scriptName

exec @v_logStatus = LogInsert 5,@v_scriptName,'Creating table ExtMethodParamDefTable'
	BEGIN
	BEGIN TRY	
		IF NOT EXISTS (
			SELECT * FROM SYSObjects
			WHERE	name	= 'ExtMethodParamDefTable'
			AND	xType	= 'U'
		)
		Begin
			exec  @v_logStatus = LogSkip 5,@v_scriptName
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
	END TRY
	BEGIN CATCH
		exec  @v_logStatus = LogFailed 5,@v_scriptName
		RAISERROR('Block 5 Failed.',16,1)
		RETURN
	END CATCH
	END
exec @v_logStatus = LogUpdate 5,@v_scriptName

exec @v_logStatus = LogInsert 6,@v_scriptName,'Creating Table ExtMethodParamMappingTable'	
	BEGIN
	BEGIN TRY
		IF NOT EXISTS (
			SELECT * FROM SYSObjects
			WHERE	name	= 'ExtMethodParamMappingTable'
			AND	xType	= 'U'
		)
		Begin
			exec  @v_logStatus = LogSkip 6,@v_scriptName
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
	END TRY
	BEGIN CATCH
		exec  @v_logStatus = LogFailed 6,@v_scriptName
		RAISERROR('Block 6 Failed.',16,1)
		RETURN
	END CATCH
	END
exec @v_logStatus = LogUpdate 6,@v_scriptName

exec @v_logStatus = LogInsert 7,@v_scriptName,'Creating Table ConstantDefTable'
	BEGIN
	BEGIN TRY
		IF NOT EXISTS (
			SELECT * FROM SYSObjects
			WHERE	name	= 'ConstantDefTable'
			AND	xType	= 'U'
		)
		Begin
			exec  @v_logStatus = LogSkip 7,@v_scriptName
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
	END TRY
	BEGIN CATCH
		exec  @v_logStatus = LogFailed 7,@v_scriptName
		RAISERROR('Block 7 Failed.',16,1)
		RETURN
	END CATCH
	END
exec @v_logStatus = LogUpdate 7,@v_scriptName

exec @v_logStatus = LogInsert 8,@v_scriptName,'Creating Table WFDataStructureTable'
	BEGIN
	BEGIN TRY	
	IF NOT EXISTS (
		SELECT * FROM SYSObjects
		WHERE	name	= 'WFDataStructureTable'
		AND	xType	= 'U'
	)
	Begin
		exec  @v_logStatus = LogSkip 8,@v_scriptName
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
	END TRY
	BEGIN CATCH
		exec  @v_logStatus = LogFailed 8,@v_scriptName
		RAISERROR('Block 8 Failed.',16,1)
		RETURN
	END CATCH
	END
exec @v_logStatus = LogUpdate 8,@v_scriptName

exec @v_logStatus = LogInsert 9,@v_scriptName,'Creating Table WFWebServiceTable'
	BEGIN
	BEGIN TRY
	IF NOT EXISTS (
		SELECT * FROM SYSObjects
		WHERE	name	= 'WFWebServiceTable'
		AND	xType	= 'U'
	)
	Begin
		exec  @v_logStatus = LogSkip 9,@v_scriptName
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
	END TRY
	BEGIN CATCH
		exec  @v_logStatus = LogFailed 9,@v_scriptName
		RAISERROR('Block 9 Failed.',16,1)
		RETURN
	END CATCH
	END
exec @v_logStatus = LogUpdate 9,@v_scriptName
	
exec @v_logStatus = LogInsert 10,@v_scriptName,'TABLE ExtMethodParamDefTable altered with adding column DataStructureId'
	BEGIN
	BEGIN TRY
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
		exec  @v_logStatus = LogSkip 10,@v_scriptName
		EXECUTE('
			ALTER TABLE ExtMethodParamDefTable ADD DataStructureId Int NULL
		')
	End
	END TRY
	BEGIN CATCH
		exec  @v_logStatus = LogFailed 10,@v_scriptName
		RAISERROR('Block 10 Failed.',16,1)
		RETURN
	END CATCH
	END
exec @v_logStatus = LogUpdate 10,@v_scriptName

exec @v_logStatus = LogInsert 11,@v_scriptName,'TABLE ExtMethodParamDefTable altered with adding column DataStructureId'
	BEGIN
	BEGIN TRY
	IF NOT EXISTS(
		SELECT * FROM SYSColumns
		WHERE id = (
			SELECT id FROM SYSObjects 
			WHERE name = 'ExtMethodParamDefTable' 
			AND xType = 'U'
		)
		AND name = 'DataStructureId' AND type =38
	)
	Begin
		exec  @v_logStatus = LogSkip 11,@v_scriptName
		EXECUTE('
			ALTER TABLE ExtMethodParamDefTable Alter Column DataStructureId Int NULL
		')
	End
	END TRY
	BEGIN CATCH
		exec  @v_logStatus = LogFailed 11,@v_scriptName
		RAISERROR('Block 11 Failed.',16,1)
		RETURN
	END CATCH
	END
exec @v_logStatus = LogUpdate 11,@v_scriptName
	
exec @v_logStatus = LogInsert 12,@v_scriptName,'Adding column DataStructureId to ExtMethodParamMappingTable'
	BEGIN
	BEGIN TRY	
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
		exec  @v_logStatus = LogSkip 12,@v_scriptName
		EXECUTE('
			ALTER TABLE ExtMethodParamMappingTable ADD DataStructureId Int NULL
		')
	End
	END TRY
	BEGIN CATCH
		exec  @v_logStatus = LogFailed 12,@v_scriptName
		RAISERROR('Block 12 Failed.',16,1)
		RETURN
	END CATCH
	END
exec @v_logStatus = LogUpdate 12,@v_scriptName
	
exec @v_logStatus = LogInsert 13,@v_scriptName,'Adding column IntroducedAt to ProcessInstanceTable'
	BEGIN
	BEGIN TRY
	If @v_TableExists = 1
	Begin
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
			exec  @v_logStatus = LogSkip 13,@v_scriptName
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
	End
	END TRY
	BEGIN CATCH
		exec  @v_logStatus = LogFailed 13,@v_scriptName
		RAISERROR('Block 13 Failed.',16,1)
		RETURN
	END CATCH
	END
exec @v_logStatus = LogUpdate 13,@v_scriptName	

exec @v_logStatus = LogInsert 14,@v_scriptName	,'Updating Activitytable by setting primaryActivity = Y'
	BEGIN
	BEGIN TRY
	exec  @v_logStatus = LogSkip 14,@v_scriptName	
	DECLARE Activity_Cursor CURSOR FOR SELECT min( a.activityid),a.processdefid FROM Activitytable a inner join processdeftable b on a.processdefid=b.processdefid where a.activityType	= 1 GROUP BY a.processdefid
	OPEN Activity_Cursor;
			FETCH NEXT FROM Activity_Cursor INTO @activity_ID,@processDefId
				WHILE @@FETCH_STATUS = 0
				BEGIN
					IF exists(select 1 from activitytable where activityType=1 And primaryActivity='Y' and processDefId=@processDefId )
					BEGIN
						FETCH NEXT FROM Activity_Cursor INTO @activity_ID,@processDefId
					END;
					Else	
					BEGIN
						EXECUTE('UPDATE Activitytable SET primaryActivity = ''Y'' WHERE activityType=1 and processDefId=' + @processDefId +'AND activityid=' + @activity_ID )
						FETCH NEXT FROM Activity_Cursor INTO @activity_ID,@processDefId
					END;
				END;
	CLOSE Activity_Cursor;
	DEALLOCATE Activity_Cursor;
	END TRY
	BEGIN CATCH
		exec  @v_logStatus = LogFailed 14,@v_scriptName	
		RAISERROR('Block 14 Failed.',16,1)
		RETURN
	END CATCH
	END
exec @v_logStatus = LogUpdate 14,@v_scriptName		

exec @v_logStatus = LogInsert 15,@v_scriptName	,'Altering datatype of column EXPIRY to NVARCHAR of ACTIVITYTABLE'
	BEGIN
	BEGIN TRY	
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
		exec  @v_logStatus = LogSkip 15,@v_scriptName	
		Alter TABLE ActivityTable ALTER COLUMN expiry NVarchar(255)
		UPDATE ActivityTable SET expiry = NULL where expiry = 'NULL'
		--UPDATE ActivityTable SET expiry = ('0*24 + ' + expiry) 
	END
	END TRY
	BEGIN CATCH
		exec  @v_logStatus = LogFailed 15,@v_scriptName	
		RAISERROR('Block 15 Failed.',16,1)
		RETURN
	END CATCH
	END
exec @v_logStatus = LogUpdate 15,@v_scriptName	

exec @v_logStatus = LogInsert 16,@v_scriptName	,'If WFMessageInProcessTable not exist then creating it else altering table WFMessageInProcessTable with new Column ActionDateTime'
	BEGIN
	BEGIN TRY
		
		IF NOT EXISTS(SELECT * FROM SYSOBJECTS WHERE NAME = 'WFMessageInProcessTable')
		Begin
			exec  @v_logStatus = LogSkip 16,@v_scriptName	
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
				exec  @v_logStatus = LogSkip 16,@v_scriptName	
				Execute ('ALTER TABLE WFMessageInProcessTable ADD ActionDateTime DATETIME')
				Print 'Table WFMessageInProcessTable altered with new Column ActionDateTime'
			End
		End
	END TRY
	BEGIN CATCH
		exec  @v_logStatus = LogFailed 16,@v_scriptName	
		RAISERROR('Block 16 Failed.',16,1)
		RETURN
	END CATCH
	END
exec @v_logStatus = LogUpdate 16,@v_scriptName	
	
exec @v_logStatus = LogInsert 17,@v_scriptName	,'If WFFailedMessageTable not exist then creating it else altering table WFFailedMessageTable with new Column ActionDateTime'
	BEGIN
		
	BEGIN TRY
	IF NOT EXISTS(SELECT * FROM SYSOBJECTS WHERE NAME = 'WFFailedMessageTable')
	Begin
		exec  @v_logStatus = LogSkip 17,@v_scriptName
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
			exec  @v_logStatus = LogSkip 17,@v_scriptName
			Execute ('ALTER TABLE WFFailedMessageTable ADD ActionDateTime DATETIME')
			Print 'Table WFFailedMessageTable altered with new Column ActionDateTime'
		End
	End
	END TRY
	BEGIN CATCH
		exec  @v_logStatus = LogFailed 17,@v_scriptName	
		RAISERROR('Block 17 Failed.',16,1)
		RETURN
	END CATCH
	END
exec @v_logStatus = LogUpdate 17,@v_scriptName	

exec @v_logStatus = LogInsert 18,@v_scriptName	,'Moving Data From WFMessageTable To WFFailedMessageTable'
	BEGIN
	exec  @v_logStatus = LogSkip 18,@v_scriptName	
	BEGIN TRY
	Begin Transaction Move

		EXECUTE('Insert Into WFFailedMessageTable(messageId,message,lockedBy,status,failureTime,ActionDateTime) Select messageId, message, null, status, getDate(), ActionDateTime From WFMessageTable Where status = ''F''')
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
	END TRY
	BEGIN CATCH
		exec  @v_logStatus = LogFailed 18,@v_scriptName	
		RAISERROR('Block 18 Failed.',16,1)
		RETURN
	END CATCH
	END
exec @v_logStatus = LogUpdate 18,@v_scriptName	

exec @v_logStatus = LogInsert 19,@v_scriptName	,'Creating Table WFEscalationTable and creating NONCLUSTERED index on it'
	BEGIN
	BEGIN TRY	
	IF NOT EXISTS(Select * From sysObjects Where name = 'WFEscalationTable')
	Begin
		exec  @v_logStatus = LogSkip 19,@v_scriptName	
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
	END TRY
	BEGIN CATCH
		exec  @v_logStatus = LogFailed 19,@v_scriptName	
		RAISERROR('Block 19 Failed.',16,1)
		RETURN
	END CATCH
	END
exec @v_logStatus = LogUpdate 19,@v_scriptName	
	
exec @v_logStatus = LogInsert 20,@v_scriptName	,'Creating Table WFEscInProcessTable'
	BEGIN
	BEGIN TRY	
	IF NOT EXISTS(Select * From sysObjects Where name = 'WFEscInProcessTable')
	Begin
		exec  @v_logStatus = LogSkip 20,@v_scriptName	
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
	END TRY
	BEGIN CATCH
		exec  @v_logStatus = LogFailed 20,@v_scriptName	
		RAISERROR('Block 20 Failed.',16,1)
		RETURN
	END CATCH
	END
exec @v_logStatus = LogUpdate 20,@v_scriptName	

exec @v_logStatus = LogInsert 21,@v_scriptName	,'Creating Table WFJMSMESSAGETABLE'
	BEGIN
	BEGIN TRY	
	IF NOT EXISTS(Select * From sysObjects Where name = 'WFJMSMESSAGETABLE')
	Begin
		exec  @v_logStatus = LogSkip 21,@v_scriptName	
		CREATE TABLE WFJMSMESSAGETABLE (
        messageId		INT			identity (1, 1), 
        message		NTEXT			NOT NULL, 
        destination		NVarchar(256),
        entryDateTime		DateTime,
		OperationType		NVarchar(1)		
		)
	
		Print 'Table WFJMSMESSAGETABLE created successfully'
	End
	END TRY
	BEGIN CATCH
		exec  @v_logStatus = LogFailed 21,@v_scriptName	
		RAISERROR('Block 21 Failed.',16,1)
		RETURN
	END CATCH
	END
exec @v_logStatus = LogUpdate 21,@v_scriptName	

exec @v_logStatus = LogInsert 22,@v_scriptName	,'Creating Table WFJMSMessageInProcessTable'
	BEGIN
	BEGIN TRY		
		IF NOT EXISTS(Select * From sysObjects Where name = 'WFJMSMessageInProcessTable')
		Begin
			exec  @v_logStatus = LogSkip 22,@v_scriptName	
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
	END TRY
	BEGIN CATCH
		exec  @v_logStatus = LogFailed 22,@v_scriptName	
		RAISERROR('Block 22 Failed.',16,1)
		RETURN
	END CATCH
	END
exec @v_logStatus = LogUpdate 22,@v_scriptName		
	
exec @v_logStatus = LogInsert 23,@v_scriptName	,'Creating Table WFJMSFailedMessageTable'
	BEGIN
	BEGIN TRY	
		IF NOT EXISTS(Select * From sysObjects Where name = 'WFJMSFailedMessageTable')
		Begin
			exec  @v_logStatus = LogSkip 23,@v_scriptName	
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
	END TRY
	BEGIN CATCH
		exec  @v_logStatus = LogFailed 23,@v_scriptName	
		RAISERROR('Block 23 Failed.',16,1)
		RETURN
	END CATCH
	END
exec @v_logStatus = LogUpdate 23,@v_scriptName	

exec @v_logStatus = LogInsert 24,@v_scriptName	,'Creating Table WFJMSDestInfo '
	BEGIN
	BEGIN TRY	
	IF NOT EXISTS(Select * From sysObjects Where name = 'WFJMSDestInfo')
	Begin
		exec  @v_logStatus = LogSkip 24,@v_scriptName	
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
	END TRY
	BEGIN CATCH
		exec  @v_logStatus = LogFailed 24,@v_scriptName	
		RAISERROR('Block 24 Failed.',16,1)
		RETURN
	END CATCH
	END
exec @v_logStatus = LogUpdate 24,@v_scriptName	

exec @v_logStatus = LogInsert 25,@v_scriptName	,'Creating Table WFJMSPublishTable'
	BEGIN
	BEGIN TRY	
	IF NOT EXISTS(Select * From sysObjects Where name = 'WFJMSPublishTable')
	Begin
		exec  @v_logStatus = LogSkip 25,@v_scriptName	
		CREATE TABLE WFJMSPublishTable
			(
			processDefId	INT,
			activityId	INT,
			destinationId	INT,
			Template	NTEXT
			)

		Print 'Table WFJMSPublishTable created successfully'
	End
	END TRY
	BEGIN CATCH
		exec  @v_logStatus = LogFailed 25,@v_scriptName	
		RAISERROR('Block 25 Failed.',16,1)
		RETURN
	END CATCH
	END
exec @v_logStatus = LogUpdate 25,@v_scriptName	

exec @v_logStatus = LogInsert 26,@v_scriptName	,'Creating Table WFJMSSubscribeTable'
	BEGIN
	BEGIN TRY
	IF NOT EXISTS(Select * From sysObjects Where name = 'WFJMSSubscribeTable')
	Begin
		exec  @v_logStatus = LogSkip 26,@v_scriptName	
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
	END TRY
	BEGIN CATCH
		exec  @v_logStatus = LogFailed 26,@v_scriptName	
		RAISERROR('Block 26 Failed.',16,1)
		RETURN
	END CATCH
	END
exec @v_logStatus = LogUpdate 26,@v_scriptName		
	
exec @v_logStatus = LogInsert 27,@v_scriptName	,'Creating Table WFVarStatusTable'
	BEGIN
	BEGIN TRY
	IF NOT EXISTS(Select * From sysObjects Where name = 'WFVarStatusTable')
	Begin
		exec  @v_logStatus = LogSkip 27,@v_scriptName	
		CREATE TABLE WFVarStatusTable 
		(
		ProcessDefId	int		NOT NULL ,
		VarName		nvarchar(50)	NOT NULL ,
		Status		nvarchar(1)	NOT NULL DEFAULT 'Y' CHECK (Status = 'Y' OR Status = 'N' )
		) 
		Print 'Table WFVarStatusTable created successfully'
	End
	END TRY
	BEGIN CATCH
		exec  @v_logStatus = LogFailed 27,@v_scriptName	
		RAISERROR('Block 27 Failed.',16,1)
		RETURN
	END CATCH
	END
exec @v_logStatus = LogUpdate 27,@v_scriptName		

exec @v_logStatus = LogInsert 28,@v_scriptName	,'Creating Table WFActionStatusTable'
	BEGIN
	BEGIN TRY	
	IF NOT EXISTS(Select * From sysObjects Where name = 'WFActionStatusTable')
	Begin
		exec  @v_logStatus = LogSkip 28,@v_scriptName	
		CREATE TABLE WFActionStatusTable
		(
		ActionId	int		PRIMARY KEY ,
		Type		nvarchar(1)	NOT NULL DEFAULT 'C' CHECK (Type = 'C' OR Type = 'S' ),
		Status		nvarchar(1)	NOT NULL DEFAULT 'Y' CHECK (Status = 'Y' OR Status = 'N' )
		)
		Print 'Table WFActionStatusTable created successfully'
	End
	END TRY
	BEGIN CATCH
		exec  @v_logStatus = LogFailed 28,@v_scriptName	
		RAISERROR('Block 28 Failed.',16,1)
		RETURN
	END CATCH
	END
exec @v_logStatus = LogUpdate 28,@v_scriptName	

exec @v_logStatus = LogInsert 29,@v_scriptName	,'Creating Table WFCalDefTable and Inserting Default Calendar values'
	BEGIN
	BEGIN TRY	
	IF NOT EXISTS(Select * From sysObjects Where name = 'WFCalDefTable')
	Begin
		exec  @v_logStatus = LogSkip 29,@v_scriptName	
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
	END TRY
	BEGIN CATCH
		exec  @v_logStatus = LogFailed 29,@v_scriptName	
		RAISERROR('Block 29 Failed.',16,1)
		RETURN
	END CATCH
	END
exec @v_logStatus = LogUpdate 29,@v_scriptName	

exec @v_logStatus = LogInsert 30,@v_scriptName	,'Creating Table WFCalRuleDefTable'
	BEGIN
	BEGIN TRY
	IF NOT EXISTS(Select * From sysObjects Where name = 'WFCalRuleDefTable')
	Begin
		exec  @v_logStatus = LogSkip 30,@v_scriptName	
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
	END TRY
	BEGIN CATCH
		exec  @v_logStatus = LogFailed 30,@v_scriptName	
		RAISERROR('Block 30 Failed.',16,1)
		RETURN
	END CATCH
	END
exec @v_logStatus = LogUpdate 30,@v_scriptName	

exec @v_logStatus = LogInsert 31,@v_scriptName	,'Creating Table WFCalHourDefTable and adding Hour range for default calendar'
	BEGIN
	BEGIN TRY
	IF NOT EXISTS(Select * From sysObjects Where name = 'WFCalHourDefTable')
	Begin
		exec  @v_logStatus = LogSkip 31,@v_scriptName	
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
	END TRY
	BEGIN CATCH
		exec  @v_logStatus = LogFailed 31,@v_scriptName	
		RAISERROR('Block 31 Failed.',16,1)
		RETURN
	END CATCH
	END
exec @v_logStatus = LogUpdate 31,@v_scriptName	

exec @v_logStatus = LogInsert 32,@v_scriptName	,'Creating Table WFCalendarAssocTable'
	BEGIN
	BEGIN TRY
	IF NOT EXISTS(Select * From sysObjects Where name = 'WFCalendarAssocTable')
	Begin
		exec  @v_logStatus = LogSkip 32,@v_scriptName	
		CREATE TABLE WFCalendarAssocTable(
			CalId		Int		NOT NULL,
			ProcessDefId	Int		NOT NULL,
			ActivityId	Int		NOT NULL,
			CalType		NVarChar(1)	NOT NULL,
			UNIQUE (processDefId, activityId)
		)
		Print 'Table WFCalendarAssocTable created successfully'
	End
	END TRY
	BEGIN CATCH
		exec  @v_logStatus = LogFailed 32,@v_scriptName	
		RAISERROR('Block 32 Failed.',16,1)
		RETURN
	END CATCH
	END
exec @v_logStatus = LogUpdate 32,@v_scriptName	

exec @v_logStatus = LogInsert 33,@v_scriptName	,'Creating TABLE SuccessLogTable'
	BEGIN
	BEGIN TRY
	If Not Exists (Select * from SysObjects Where xType = 'U' and name = 'SuccessLogTable')
	Begin
		exec  @v_logStatus = LogSkip 33,@v_scriptName	
		EXECUTE('
			CREATE TABLE SuccessLogTable(
				LogId INT,
				ProcessInstanceId NVARCHAR(63)
			)
		')
	End
	END TRY
	BEGIN CATCH
		exec  @v_logStatus = LogFailed 33,@v_scriptName	
		RAISERROR('Block 33 Failed.',16,1)
		RETURN
	END CATCH
	END
exec @v_logStatus = LogUpdate 33,@v_scriptName	

exec @v_logStatus = LogInsert 34,@v_scriptName	,'Creating TABLE FailureLogTable'
	BEGIN
	BEGIN TRY	
	If Not Exists (Select * from SysObjects Where xType = 'U' and name = 'FailureLogTable')
	Begin
		exec  @v_logStatus = LogSkip 34,@v_scriptName	
		EXECUTE('
			CREATE TABLE FailureLogTable(
				LogId INT,
				ProcessInstanceId NVARCHAR(63)
			)
		')
	End
	END TRY
	BEGIN CATCH
		exec  @v_logStatus = LogFailed 34,@v_scriptName	
		RAISERROR('Block 34 Failed.',16,1)
		RETURN
	END CATCH
	END
exec @v_logStatus = LogUpdate 34,@v_scriptName	

exec @v_logStatus = LogInsert 35,@v_scriptName	,'Inserting Data Into RULEOPERATIONTABLE by Fecthing values from DistributeActivityTable and Inserting Values in RULECONDITIONTABLE on unique ruleId in RULEOPERATIONTABLE And Finally Dropping Table DistributeActivityTable'
	BEGIN
	BEGIN TRY		
	If Exists(	Select * 
			FROM SYSObjects 
			WHERE	name	= 'DistributeActivityTable'
			AND	xType	= 'U'
		)
	Begin
		exec  @v_logStatus = LogSkip 35,@v_scriptName	
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
	END TRY
	BEGIN CATCH
		exec  @v_logStatus = LogFailed 35,@v_scriptName	
		RAISERROR('Block 35 Failed.',16,1)
		RETURN
	END CATCH
	END
exec @v_logStatus = LogUpdate 35,@v_scriptName	

exec @v_logStatus = LogInsert 36,@v_scriptName	,'Altering TABLE ACTIVITYTABLE by adding CONSTRAINT CK_ACTTAB_SERINT'
	BEGIN
	BEGIN TRY	
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
		exec  @v_logStatus = LogSkip 36,@v_scriptName	
		EXECUTE('
			Alter Table ACTIVITYTABLE Drop CONSTRAINT ' + @constraintName
		)
		EXECUTE('
			ALTER TABLE ACTIVITYTABLE ADD CONSTRAINT CK_ACTTAB_SERINT 
					CHECK (ServerInterface IN (N''Y'', N''N'', N''E''))
		')
	End
	END TRY
	BEGIN CATCH
		exec  @v_logStatus = LogFailed 36,@v_scriptName	
		RAISERROR('Block 36 Failed.',16,1)
		RETURN
	END CATCH
	END
exec @v_logStatus = LogUpdate 36,@v_scriptName	
	
exec @v_logStatus = LogInsert 37,@v_scriptName	,'Altering Table UserWorkAuditTable by Altering Column workitemCount'
	BEGIN
	BEGIN TRY
	IF NOT EXISTS ( SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'UserWorkAuditTable') AND  NAME = 'workitemCount')
	BEGIN
		exec  @v_logStatus = LogSkip 37,@v_scriptName	
		EXECUTE('Alter Table UserWorkAuditTable Alter Column workitemCount	NVARCHAR(100)')
	END
	END TRY
	BEGIN CATCH
		exec  @v_logStatus = LogFailed 37,@v_scriptName	
		RAISERROR('Block 37 Failed.',16,1)
		RETURN
	END CATCH
	END
exec @v_logStatus = LogUpdate 37,@v_scriptName	

exec @v_logStatus = LogInsert 38,@v_scriptName,'Adding Columns CreatedOn,LastModifiedOn in ProcessDefTable'
	BEGIN
	BEGIN TRY	
	IF NOT EXISTS ( SELECT * FROM sysColumns 
			WHERE 
			id = (SELECT id FROM sysObjects WHERE NAME = 'ProcessDefTable')
			AND  NAME = 'CreatedOn'
			)
	BEGIN
		exec  @v_logStatus = LogSkip 38,@v_scriptName	
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
	END TRY
	BEGIN CATCH
		exec  @v_logStatus = LogFailed 38,@v_scriptName	
		RAISERROR('Block 38 Failed.',16,1)
		RETURN
	END CATCH
	END
exec @v_logStatus = LogUpdate 38,@v_scriptName	

exec @v_logStatus = LogInsert 39,@v_scriptName	,'Recreating table ProcessDefTable'
	BEGIN
	BEGIN TRY
	IF NOT EXISTS(SELECT * FROM WFCabVersionTable WHERE CabVersion = '7.2_ProcessDefTable') /* Check entry in WFCabVersionTable */
	BEGIN
		exec  @v_logStatus = LogSkip 39,@v_scriptName	
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
	END TRY
	BEGIN CATCH
		exec  @v_logStatus = LogFailed 39,@v_scriptName	
		RAISERROR('Block 39 Failed.',16,1)
		RETURN
	END CATCH
	END
exec @v_logStatus = LogUpdate 39,@v_scriptName	

exec @v_logStatus = LogInsert 40,@v_scriptName	,'Dropping CONSTRAINT From VarAliasTable And ExtMethodDefTable, Altering Constraint on ExtMethodDefTable, ExtMethodParamDefTable'
	BEGIN
	BEGIN TRY	
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
			exec  @v_logStatus = LogSkip 40,@v_scriptName	
			Execute ('
				Alter Table VarAliasTable 
					Drop CONSTRAINT ' + @constraintName
			)
		End
		
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
	END TRY
	BEGIN CATCH
		exec  @v_logStatus = LogFailed 40,@v_scriptName	
		RAISERROR('Block 40 Failed.',16,1)
		RETURN
	END CATCH
	END
exec @v_logStatus = LogUpdate 40,@v_scriptName	

exec @v_logStatus = LogInsert 41,@v_scriptName	,'Updating PRIMARY KEY For QueueStreamTable and Dropping TRIGGER Update_Finalization_Status,TR_LOG_PDBCONNECTION'
	BEGIN
	BEGIN TRY
	exec  @v_logStatus = LogSkip 41,@v_scriptName	
	IF NOT EXISTS( Select 1 from  queuestreamtable group by processdefid, ActivityId, StreamId having count(1) > 1 )
		Begin
			SET @constraintName = ''
			SELECT @constraintName = CONSTRAINT_NAME FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WITH(NOLOCK) WHERE TABLE_NAME = 'QUEUESTREAMTABLE' AND CONSTRAINT_TYPE = 'PRIMARY KEY';
			IF(@constraintName != '')
			BEGIN
				EXECUTE ('Alter Table queuestreamtable drop constraint ' + @constraintName)
			END
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
		Execute('DROP TRIGGER Update_Finalization_Status')
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
	END TRY
	BEGIN CATCH
		exec  @v_logStatus = LogFailed 41,@v_scriptName	
		RAISERROR('Block 41 Failed.',16,1)
		RETURN
	END CATCH
	END
exec @v_logStatus = LogUpdate 41,@v_scriptName		

exec @v_logStatus = LogInsert 42,@v_scriptName	,'Inserting values of PSRegisterationtable into TempPSRegisterationtable, Dropping Table PSRegisterationtable and Renaming TempPSRegisterationtable to PSRegisterationtable'
	BEGIN
	BEGIN TRY
	If exists (	SELECT 1 
			From SYSColumns 
			Where id = (Select id From sysObjects Where name = 'PSRegisterationTable' and xType = 'U')
			AND name = 'Data' 
			AND xType = 99 )
	Begin
		exec  @v_logStatus = LogSkip 42,@v_scriptName	
		Select PSId, PSName, Type, SessionId, ProcessDefId, Convert(NVarchar(2000), Data) Data
		Into	TempPSRegisterationTable
		From	PSRegisterationtable

		Execute('Drop Table PSRegisterationtable')

		Execute SP_RENAME 'TempPSRegisterationtable', 'PSRegisterationtable'
	End 
	END TRY
	BEGIN CATCH
		exec  @v_logStatus = LogFailed 42,@v_scriptName	
		RAISERROR('Block 42 Failed.',16,1)
		RETURN
	END CATCH
	END
exec @v_logStatus = LogUpdate 42,@v_scriptName	

exec @v_logStatus = LogInsert 43,@v_scriptName	,'Dropping TRIGGER TR_UNQ_PSREGISTERATIONTABLE, Creating new TRIGGER TR_UNQ_PSREGISTERATIONTABLE'
	BEGIN
	BEGIN TRY	
	If exists(Select * From SysObjects Where name = 'TR_UNQ_PSREGISTERATIONTABLE' and xType = 'TR')
	BEGIN
		exec  @v_logStatus = LogSkip 43,@v_scriptName	
		Execute('Drop TRIGGER TR_UNQ_PSREGISTERATIONTABLE')
		EXECUTE('
		CREATE TRIGGER TR_UNQ_PSREGISTERATIONTABLE 
		ON PSREGISTERATIONTABLE 
		AFTER  UPDATE 
		AS 
		BEGIN 
		DECLARE  
		@sessionid	int, 
		@psid	int 

		SELECT @sessionid = sessionid,@psid=psid FROM inserted 

		IF (exists (SELECT * FROM psregisterationtable WHERE sessionid =@sessionid AND  psid !=@psid )) 
		BEGIN 
		RAISERROR (''Have same session ID'', 16, 1) 
		RETURN 
		END 
		END  '
	)
	END
		
	END TRY
	BEGIN CATCH
		exec  @v_logStatus = LogFailed 43,@v_scriptName	
		RAISERROR('Block 43 Failed.',16,1)
		RETURN
	END CATCH
	END
exec @v_logStatus = LogUpdate 43,@v_scriptName	

exec @v_logStatus = LogInsert 44,@v_scriptName	,'Creating view WFGROUPVIEW'
	BEGIN
	BEGIN TRY	
	If exists(Select * From SysObjects Where name = 'WFGROUPVIEW' and xType = 'V')
	BEGIN
		exec  @v_logStatus = LogSkip 44,@v_scriptName	
		Execute('Drop View WFGROUPVIEW')
		EXECUTE('
			CREATE VIEW WFGROUPVIEW 
			AS 
			SELECT groupindex, groupname, CreatedDatetime, expiryDATETIME, 
				privilegecontrollist, owner, comment as commnt, grouptype, maingroupindex 
			FROM PDBGROUP
		')
	END
		
	END TRY
	BEGIN CATCH
		exec  @v_logStatus = LogFailed 44,@v_scriptName	
		RAISERROR('Block 44 Failed.',16,1)
		RETURN
	END CATCH
	END
exec @v_logStatus = LogUpdate 44,@v_scriptName	
	
exec @v_logStatus = LogInsert 45,@v_scriptName	,'Updating Expiry Column of Activity Column'
	BEGIN
	BEGIN TRY
	IF NOT EXISTS (SELECT * FROM SysObjects Where xType = 'U' and NAME = 'WFDurationTable')
	BEGIN
		exec  @v_logStatus = LogSkip 45,@v_scriptName	
		UPDATE ActivityTable SET expiry = ('0*24 + ' + expiry) where expiry IS NOT NULL AND expiry != '0' AND CHARINDEX('*', expiry) = 0 
		Print 'expiry column of ActivityTable updated successfully'
	END
    UPDATE ActivityTable SET expiry = null where expiry = '0'
	END TRY
	BEGIN CATCH
		exec  @v_logStatus = LogFailed 45,@v_scriptName	
		RAISERROR('Block 45 Failed.',16,1)
		RETURN
	END CATCH
	END
exec @v_logStatus = LogUpdate 45,@v_scriptName	
	
exec @v_logStatus = LogInsert 46,@v_scriptName	,'Creating table CheckOutProcessesTable'
	BEGIN
	BEGIN TRY
	IF NOT EXISTS (SELECT * FROM SYSObjects	WHERE name = 'CheckOutProcessesTable' AND xType	= 'U')
	BEGIN
		exec  @v_logStatus = LogSkip 46,@v_scriptName	
		EXECUTE('CREATE TABLE CheckOutProcessesTable( 
				ProcessDefId            INTEGER			NOT NULL,
				ProcessName             NVARCHAR(30)	NOT NULL, 
				CheckOutIPAddress       VARCHAR(50)		NOT NULL, 
				CheckOutPath            NVARCHAR(255)   NOT NULL,
				ProcessStatus			NVARCHAR(1)		NULL
			)
		')
	END
	END TRY
	BEGIN CATCH
		exec  @v_logStatus = LogFailed 46,@v_scriptName	
		RAISERROR('Block 46 Failed.',16,1)
		RETURN
	END CATCH
	END
exec @v_logStatus = LogUpdate 46,@v_scriptName	

End

~

exec Upgrade 

~

drop procedure Upgrade 

~

print 'Script Upgrade_Tables, part of Upgrade executed successfully, procedure DROPPED ...... ' 

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
	DECLARE @v_TableExists		INT
	DECLARE @v_logStatus  NVARCHAR(10) 
	DECLARE @v_scriptName varchar(100)
	
	SELECT @v_scriptName = 'Upgrade09_SP00_001'
	
	exec @v_logStatus = LogInsert 48,@v_scriptName,'Create table WFCollectUpgradeTable;Add new Columns IsPrimaryCollected,ExportStatus in PendingWorkListTable; DELETE records from PendingWorkListTable,QueueDataTable on ProcessInstanceId & WorkItemId, If error on deletion then rollback and  INSERT record WFCollectUpgradeTable; Finally update PendingWorkListTable by setting value in IsPrimaryCollected , ExportStatus Column'
	BEGIN
	BEGIN TRY
	
		exec  @v_logStatus = LogSkip 48,@v_scriptName
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
		BEGIN 
		IF NOT EXISTS(SELECT * FROM SYSObjects 
				WHERE NAME = 'QUEUEDATATABLE')
				BEGIN
						select @v_TableExists = 0
						PRINT 'QUEUEDATATABLE does not exists'
				End
		Else
			BEGIN
				Select @v_TableExists = 1
				
			END
		END
		IF @v_TableExists=1
		Begin
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
			
			IF NOT EXISTS(
				SELECT * FROM SYSColumns
				WHERE id = (
					SELECT id FROM SYSObjects 
					WHERE NAME = 'PendingWorkListTable'
					AND xType = 'U'
				)
				AND NAME = 'ExportStatus'
			)
			BEGIN
				EXECUTE('
					ALTER TABLE PendingWorkListTable 
					ADD ExportStatus NVARCHAR(1) DEFAULT ''N''')
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
				exec @v_logStatus = LogUpdate 48,@v_scriptName
				RETURN
			END

			
			WHILE(@@FETCH_STATUS  <> -1)
			BEGIN
				IF(@@FETCH_STATUS <> -2)
				BEGIN
					BEGIN TRANSACTION TRAN_COLLECT_UPGRADE

					SELECT @v_STR1='DELETE FROM PendingWorkListTable WHERE ProcessInstanceId = '''+@var_ProcessInstanceId+''' and WorkItemId = '+ CONVERT(NVARCHAR(10),@var_WorkItemId) 
					print @v_STR1
					EXECUTE(@v_STR1)
					IF(@@ERROR <> 0 OR @@ROWCOUNT = 0)
					BEGIN
						PRINT 'Deletion from PendingWorkListTable failed for ' + @var_ProcessInstanceId
						ROLLBACK TRANSACTION TRAN_COLLECT_UPGRADE
						BEGIN TRANSACTION TRAN_FAILED_WI
							EXECUTE(' INSERT INTO WFCollectUpgradeTable VALUES( N''' + @var_ProcessInstanceId + ''', ' + @var_WorkItemId + ')')
						COMMIT TRANSACTION TRAN_FAILED_WI
						GOTO ProcessNext
					END

					SELECT @v_STR1='DELETE FROM QueueDataTable WHERE ProcessInstanceId ='''+@var_ProcessInstanceId +''' and WorkItemId = '+CONVERT(NVARCHAR(10),@var_WorkItemId)
					EXECUTE(@v_STR1)
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
	END TRY
	BEGIN CATCH
		exec  @v_logStatus = LogFailed 48,@v_scriptName	
		RAISERROR('Block 48 Failed.',16,1)
		RETURN
	END CATCH
	END
	exec @v_logStatus = LogUpdate 48,@v_scriptName	
	
End

~

Print 'Stored Procedure WFCollectionUpgrade compiled successfully ........'

~

Print 'Executing procedure WFCollectionUpgrade'
Exec WFCollectionUpgrade

~
	
Print 'Dropping procedure WFCollectionUpgrade '
DROP PROCEDURE WFCollectionUpgrade

~