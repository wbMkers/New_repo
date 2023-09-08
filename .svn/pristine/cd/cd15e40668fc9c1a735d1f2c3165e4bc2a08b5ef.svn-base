
/*_____________________________________________________________________________________________________________________-
		NEWGEN SOFTWARE TECHNOLOGIES LIMITED

	Group						: Application – Products
	Product / Project			: WorkFlow
	Module						: Transaction Server
	File NAME					: Upgrade.sql (MS Sql Server)
	Author						: Ishu Saraf
	Date written (DD/MM/YYYY)	: 16/03/2009
	Description					: 
_______________________________________________________________________________________________________________________-
			CHANGE HISTORY
_______________________________________________________________________________________________________________________-
Date		Change By		Change Description (Bug No. (If Any))
27/03/2009	Ruhi Hira		SrNo-15, New tables added for SAP integration.
15/03/2009	Ananta Handoo		New table WFSAPAdapterAssocTable added for SAP Integration.
17/06/2009	Ishu Saraf		New tables added for OFME - WFPDATable, WFPDA_FormTable, WFPDAControlValueTable
23/06/2009	Ananta Handoo		WFSAPGUIDefTable Modified by Ananta Handoo.Three fields added TCodeType, VariableId, VarFieldId
28/07/2009	Saurabh Sinha		WFS_8.0_018 Unicode[Chinese in this case] characters are not set in WFMailQueueTable. As a result mail sent contains ??? in place of unicode characters.Support for uncode characters provided in mail content.
24/08/2009	Shilpi S		HotFix_8.0_045, two new columns VariableId and VarFieldId are added in PrintFaxEmailDocTypeTable for variable support in doctype name in PFE    
31/08/2009	Ashish Mangla		WFS_8.0_025 (Arglist length should increased to 2000 from 512 for generate Response)
31/08/2009      Shilpi S                WFS_8.0_026, Workitem specific calendar.
09/09/2009	Vikas Saraswat		WFS_8.0_031	User not having rights on queue, can view the workitem in readonly mode, if he has rights on query workstep. Workitem opens based on properties of query workstep in this case. Option provided to view the workitem(in read only mode) with the properties of the queue in which workitem exists, instead of query workstep properties.
11/09/2009	Saurabh Kamal		New tables created as WFExtInterfaceConditionTable and WFExtInterfaceOperationTable
05/10/2009	Vikas Saraswat		WFS_8.0_038	Support of Auto Refresh Interval for a Queue.
15/10/2009	Saurabh Kamal		WFS_8.0_044 Support of TurnAroundDateTime in FetchWorkList and SearchWorkitem 
19/08/2010	Vikas Saraswat		WFUserWebServerInfoTable  added
08/10/2010	Abhishek Gupta/Saurabh Kamal		WFS_8.0_136 Alias support for external variables.
31/08/2010	Saurabh Kamal   WFS_8.0_129, Change for createChildWorkitem trigger and deleteChildWorkitem method execution
13/03/2012	Preeti Awasthi		Bug 30633: 1. Support of Macro in File path
										   2. Support of exporting all documents for mapped document Type
30/03/2012  Neeraj Kumar           Replicated -WFS_8.0_148 Data should retrieve from arrary tables in order of its insertion.										   
03/04/2012	Bhavneet Kaur		Bug 30559 Provide Refresh in Archive rather than Disconnect
26/04/2012  Bhavneet Kaur     	Bug 31160: Supprort of defining format of Template to be gererated(Pdf/Doc).
07/05/2012  Akash Bartaria      Bugzilla – Bug 31570| Multiple SAP server support - Multiple ConfigurationID within one Process 
12/06/2012	Abhishek Gupta		Bug 32579 - BCC support in e-mail generated through Omniflow.
23/07/2012	Tanisha Ghai 		Bug 32861 Partition Name to be Provided while registering Server from ConfigServer and Web.
30/07/2012	Bhavneet Kaur		Bug 33636- Error while upgrading from OmniFlow6.2 
30/08/2012  Bhavneet Kaur   	Bug 34473- Support of adding multiple documents in mulitple folder in case of sharepoint archive workstep
12/09/2012	Preeti Awasthi		Bug 34839 - User should get pop-up for reminder without relogin
15/01/2013	Bhavneet Kaur		[Replicated] Bug 34896 - Provide option to select if form is AppletView
26/02/2013	Deepti Bachiyani	Bug 38365 - Security Flag added in WFSAPConectTable and WFWebServiceInfoTable
04/04/2013 Anwar Ali Danish    Bug 38828 - Changes done for diversion requirement. CSCQR-00000000050705-Process 
04/06/2013	Sanal Grover		Bug 39921 - Change in the Size of attachmentISIndex and attachmentNames Columns of WFMailQueueTable and WFMailQueueHistoryTable
07/06/2013	Deepak Mittal		Bug 40327 - Create indexes and modified trigger on psregisteration table to resolve deadlock
24/06/2013	Sanal Grover		Bug 39147 - Removing TR_LOG_PDBCONNECTION trigger on PDBConnection for logging in WFCurrentRouteLogTable.
24/07/2013	Sweta Bansal		Bug 41507 - Handling regarding Performance or slowness issue in Message Agent.
05/08/2013	Sweta Bansal		Bug 41693 - Assigned or Locked workitem by a particular user are not getting released when the user get deleted from the OmniDocs end. 
29/08/2013    Kahkeshan         Bug 39079 - EscalateToWithTrigger Feature requirement
30/08/2013    Shweta Singhal    Bug 41770 - TargetDoc added in WFSharePointDocAssocTable
04/09/2013	Sweta Bansal		Bug 41955 - Optimization in Message Agent to enhance the performance.
13/09/2013  Neeraj Sharma       Bug 42071 - Invalid object name 'QUsergroupview' was coming while logging into webdesktop.
01/10/2013  Sweta Bansal		Bug 41790 - MultiLingual Support in OmniFLow Server.(Screen for specifying names of processes, queues,activities, variables, aliases in multiple locales for multilingual functionality.)
07/10/2013  Sweta Bansal		Bug 42321 - Support for providing the better debugging in case of Message Agent so that it is easier to find out the Failure Point in code for the failed message.
12/11/2013	Rahul Nagar			Bug 42494 - BCC support at each email sending modules
14/11/2013  Neeraj Sharma		Bug 42579 - The UserList fetched through process Manager displays the User even after deleting a User from OmniDocs.
29/11/2013  Sweta Bansal		Bug 42680 - WFGetMultiLingual API is added to return all the multilingual defined for a process.
19/12/2013  Sweta Bansal		Bug 42747 - In all product tables, type of column, that contains UserIndex is changed from SmallInt to Int as user is unable to login into OmniFlow and OmniDoc as its userindex is greater than the range of SmallInt.
06/01/2014  Sweta Bansal		Bug 42827 - Handling of Primary Key Violation error in GetNextWorkItem API in case multiple process server are running.
20/01/2014  Rahul Nagar         Bug 42795 - Activity wise customization of sending mail priority
07/02/2014  Sweta Bansal		Bug 43028 - Support for encrypting the password before inserting the same into WFExportInfoTable through WFSetExportCabinetInfo API and fetch the decrypted value of same field from WFExportInfoTable through WFGetExportCabinetInfo API.
18/03/2014	Sanal Grover		Bug 43469 - Support for Bulk PS
19/05/2014	Sweta Bansal		Upgrade_UserIndex.sql Script is prepared for the changes corresponding to Bug 42747. 
19/05/2014	Sweta Bansal		Bug 45829 - Create a trigger on PSRegisterationTable so that whenever any utility get unregistered, all the locked instances by that particular utility get unlocked.
25/08/2014  Chitvan Chhabra		Bug 47640 - Upgrade Development for SU6-New Files added/renamed:UpgradeDataTypesandChecks.sql(Created),UpgradeXIndex.sql(created),UpgradeMessageIdLogId.sql(renamed),UpgradeUserIndex.sql(Renamed)
26/08/2014  Gourav Chadha		Bug 47827 - Add support for default SystemArchiveQueue and SystemPFEQueue association.
25/09/2014  Chitvan Chhabra		Bug 50445 - Performance issues: Slowness Reported In search,MessageAgent(WFLockMessage.sql),and General Slowness wrt to USERPREFRENCE TABLE
10/10/2014	Sanal Grover		Bug 50987 - When VariableId1 column is added in Varaliastable it should be updated accordingly in correspondence with the variableid present in the varmappingtable.
31/10/2014	Sanal Grover		Bug 51650 - VariableId column is added in WFSearchVariableTable.
31/10/2014	Gourav Chadha		Bug 51527 - Add functionality for deletion of Audit Logs after archive
12/09/2016  Bhupendra Singh     Bug 62635 - procedure was unable to compile if VARIABLEID column not present in WFSEARCHVARIABLETABLE in OmniFlowVersionUpgrade 
26/05/2017	Sanal Grover		Bug 62518 - Step by Step Debugs in Version Upgrade.
24/07/2017  Ashok Kumar			Bug 69853 - WorkinprocessTable and Workwithpstable handling in version upgrade for IBPS
05/06/2018  Birjesh Rawat           Handling in version upgrade for IBPS  when VarMappingTable  has entries for calendar. 
 upgrade._______________________________________________________________________________________________________________________-*/

If Exists (SELECT 1 FROM SYSObjects WHERE NAME = 'dropdefaultconstraint' AND xType = 'P')
BEGIN
	Drop Procedure dropdefaultconstraint
	PRINT 'As Procedure dropdefaultconstraint exists dropping old procedure ........... '
END

~

PRINT 'Creating procedure dropdefaultconstraint ........... '
~


CREATE PROCEDURE dropdefaultconstraint
@tablename varchar(max),
@colname varchar(max)

AS
	BEGIN

		
		DECLARE @constname varchar(200) 
		
		SET @constname = ''
		SELECT  @constname  =a.name 
		FROM sys.sysobjects a INNER JOIN 
		(SELECT name, id FROM sys.sysobjects WHERE xtype = 'U') b on 
		(a.parent_obj = b.id) INNER JOIN sys.syscomments c ON (a.id = c.id) 
		INNER JOIN sys.syscolumns d ON (d.cdefault = a.id) where  b.name = @tablename and  d.name=@colname


		IF ((@constname IS NOT NULL)  AND (LEN(@constname) > 0))
		BEGIN
		PRINT ('Table '+ @tablename + ' altered, constraint '+ @constname+' dropped.')
		EXECUTE ('ALTER TABLE '+@tablename+' DROP CONSTRAINT ' + @constname)
		END


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
BEGIN
	DECLARE @ProcessDefId		INT
	Declare @existsFlag		INT
	Declare @constrnName  NVARCHAR(100)
	Declare @SAPconstrnName  NVARCHAR(100)
	DECLARE @PARAM1  		NVarchar(256)
	DECLARE @FIELDNAME 		NVarchar(256)
	DECLARE @VariableType	INT
	DECLARE @ExtObjID		INT
	DECLARE @v_VariableId	INT
	DECLARE @quoteChar		char(1)  
	SET @quoteChar = char(39)  
	DECLARE @ConfigurationId     INT
	DECLARE @TableName VARCHAR(1000)
	DECLARE @v_rowcount INT
	DECLARE @querystr VARCHAR(1000)
	DECLARE @const_name VARCHAR(100)
	Declare @indexName  NVARCHAR(200)
	DECLARE @activityID		INT
	DECLARE @QueueID		INT
	DECLARE @v_TableExists		INT
	DECLARE @activity_Id INT
	DECLARE	@variable_ID INT
	DECLARE @procDefId INT
	DECLARE @TSQL NVARCHAR(1000)
	DECLARE @TSQL2 NVARCHAR(1000)
	DECLARE @v_logStatus NVARCHAR(10)
	DECLARE @v_scriptName varchar(100)
	SET NOCOUNT ON
	SELECT @v_scriptName = 'Upgrade09_SP06_001'
	select @v_TableExists = 0
	
	
exec @v_logStatus = LogInsert 1,@v_scriptName,'Creating Table WFCabVersionTable if exists else adding new Columns cabVersion,Remarks in WFCabVersionTable'
		BEGIN
		BEGIN TRY
				
			BEGIN 
				IF NOT EXISTS(SELECT * FROM SYSObjects 
	    		WHERE NAME = 'Queuedatatable')
	    		BEGIN
	    				select @v_TableExists = 0
	    				PRINT 'QUEUEDATATABLE does not exists'
	    		End
				Else
				BEGIN
	    		select @v_TableExists = 1
	    		
				END
			 END

				
				BEGIN TRANSACTION trans
		
				EXECUTE('INSERT INTO WFCabVersionTable(cabVersion, creationDate, lastModified, Remarks, Status) VALUES (N''9.0'', GETDATE(), GETDATE(), N''START of Upgrade.sql for SU6'', N''Y'')')
				COMMIT TRANSACTION trans

				IF NOT EXISTS(SELECT * FROM sysObjects WHERE NAME = 'WFCabVersionTable')
				BEGIN
				exec  @v_logStatus = LogSkip 1,@v_scriptName
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
						IF NOT EXISTS (Select 1 from syscolumns where name='cabVersion' and length = 510 and id =(SELECT id FROM sysObjects WHERE NAME = 'WFCabVersionTable'))
						
							exec  @v_logStatus = LogSkip 1,@v_scriptName
							EXECUTE('Alter Table WFCabVersionTable Alter Column cabVersion NVARCHAR(255)')
							
							PRINT 'Table WFCabVersionTable altered with Column cabVersion size increased to 255'

						IF NOT EXISTS (Select 1 from syscolumns where name='Remarks' and length = 510 and id =(SELECT id FROM sysObjects WHERE NAME = 'WFCabVersionTable'))
						BEGIN
							exec  @v_logStatus = LogSkip 1,@v_scriptName
							EXECUTE('Alter Table WFCabVersionTable Alter Column Remarks NVARCHAR(255)')
							PRINT 'Table WFCabVersionTable altered with Column Remarks size increased to 255'
						END		

					
				END



		END TRY
		BEGIN CATCH
			exec  @v_logStatus = LogFailed 1,@v_scriptName
			RAISERROR('Block 1 Failed.',16,1)
			RETURN
		END CATCH
		END
	exec @v_logStatus = LogUpdate 1,@v_scriptName

	exec @v_logStatus = LogInsert 2,@v_scriptName,'Creating TABLE WFSAPConnectTable'	
		BEGIN
			BEGIN TRY
	
			/*SrNo-15, New tables added for SAP integration.*/
			IF NOT EXISTS (
			SELECT * FROM SYSObjects 
			WHERE NAME = 'WFSAPConnectTable' 
			AND xType = 'U'
			)
			BEGIN
				exec  @v_logStatus = LogSkip 2,@v_scriptName
				EXECUTE(' 
					CREATE TABLE WFSAPConnectTable (
						ProcessDefId		INT				NOT NULL,	
						SAPHostName			NVarChar(64)	NOT NULL,
						SAPInstance			NVarChar(2)		NOT NULL,
						SAPClient			NVarChar(3)		NOT NULL,
						SAPUserName			NVarChar(256)	    NULL,
						SAPPassword			NVarChar(512)	    NULL,
						SAPHttpProtocol		NVarChar(8)		    NULL,
						SAPITSFlag			NVarChar(1)		    NULL,
						SAPLanguage			NVarChar(8)		    NULL,
						SAPHttpPort			INT			        NULL,
						ConfigurationID     INT             NOT NULL,
						RFCHostName         NVarChar(64)        NULL,
						ConfigurationName   NVarChar(64)        NULL,
						SecurityFlag		NVARCHAR(1)		DEFAULT ''Y''    NULL,
					CONSTRAINT [pk_WFSAPConnect] PRIMARY KEY CLUSTERED 
					(	ProcessDefId ASC,
						ConfigurationID ASC
					) ON [PRIMARY]
					) ON [PRIMARY]
				')
				PRINT 'Table WFSAPConnectTable created successfully.'
			END
			END TRY
			BEGIN CATCH
			exec  @v_logStatus = LogFailed 2,@v_scriptName
			RAISERROR('Block 2 Failed.',16,1)
			RETURN
			END CATCH
		END
	exec @v_logStatus = LogUpdate 2,@v_scriptName

	exec @v_logStatus = LogInsert 3,@v_scriptName,'Creating TABLE WFSAPGUIDefTable'	
		BEGIN
			BEGIN TRY
			IF NOT EXISTS (
			   SELECT * FROM SYSObjects 
			   WHERE NAME = 'WFSAPGUIDefTable'
			   AND xType = 'U'
			)
			BEGIN
				exec  @v_logStatus = LogSkip 3,@v_scriptName
				EXECUTE(' 
				CREATE TABLE WFSAPGUIDefTable (
				ProcessDefId		INT				NOT NULL,
				DefinitionId		INT				NOT NULL,
				DefinitionName		NVarChar(256)	NOT NULL,
				SAPTCode			NVarChar(64)	NOT NULL,
				TCodeType			NVarChar(1)	NOT NULL,
				VariableId			INT				NULL,
				VarFieldId			INT				NULL,
				PRIMARY KEY (ProcessDefId, DefinitionId)
				)
				')
				PRINT 'Table WFSAPGUIDefTable created successfully.'
				END
				END TRY
				BEGIN CATCH
					exec  @v_logStatus = LogFailed 3,@v_scriptName
					RAISERROR('Block 3 Failed.',16,1)
					RETURN
				END CATCH
			END
	exec @v_logStatus = LogUpdate 3,@v_scriptName

	exec @v_logStatus = LogInsert 4,@v_scriptName,'Creating TABLE WFSAPGUIFieldMappingTable '	
		BEGIN
			BEGIN TRY
			IF NOT EXISTS (SELECT * FROM SYSObjects WHERE NAME = 'WFSAPGUIFieldMappingTable' AND xType = 'U')
			BEGIN
				exec  @v_logStatus = LogSkip 4,@v_scriptName
				EXECUTE(' 
				CREATE TABLE WFSAPGUIFieldMappingTable (
				ProcessDefId		INT				NOT NULL,
				DefinitionId		INT				NOT NULL,
				SAPFieldName		NVarChar(512)	NOT NULL,
				MappedFieldName		NVarChar(256)	NOT NULL,
				MappedFieldType		NVarChar(1)	                CHECK (MappedFieldType	in (N''Q'', N''F'', N''C'', N''S'', N''I'', N''M'', N''U'')),
				VariableId			INT				NULL,
				VarFieldId			INT				NULL
				)
				')
				PRINT 'Table WFSAPGUIFieldMappingTable created successfully.'
				END
				END TRY
				BEGIN CATCH
					exec  @v_logStatus = LogFailed 4,@v_scriptName
					RAISERROR('Block 4 Failed.',16,1)
					RETURN
				END CATCH
			END
	exec @v_logStatus = LogUpdate 4,@v_scriptName

	exec @v_logStatus = LogInsert 5,@v_scriptName,'Creating TABLE WFSAPGUIAssocTable'	
		BEGIN
			BEGIN TRY
			
			IF NOT EXISTS(
			SELECT * FROM SYSObjects 
			WHERE NAME = 'WFSAPGUIAssocTable'
			AND xType = 'U'
			)
			BEGIN
				exec  @v_logStatus = LogSkip 5,@v_scriptName
				EXECUTE('
				CREATE TABLE WFSAPGUIAssocTable (
				ProcessDefId		INT				NOT NULL,
				ActivityId			INT				NOT NULL,
				DefinitionId		INT				NOT NULL,
				Coordinates         NVarChar(255)       NULL, 
				CONSTRAINT UK_WFSAPGUIAssocTable UNIQUE (ProcessDefId, ActivityId, DefinitionId)
				)
				')
				PRINT 'Table WFSAPGUIAssocTable created successfully.'
				END
				END TRY
				BEGIN CATCH
					exec  @v_logStatus = LogFailed 5,@v_scriptName
					RAISERROR('Block 5 Failed.',16,1)
					RETURN
				END CATCH
			END
	exec @v_logStatus = LogUpdate 5,@v_scriptName

	exec @v_logStatus = LogInsert 6,@v_scriptName,'Creating TABLE WFSAPAdapterAssocTable'	
		BEGIN
			BEGIN TRY
			IF NOT EXISTS (SELECT * FROM SYSObjects WHERE NAME = 'WFSAPAdapterAssocTable' AND xType = 'U'
			)
			BEGIN
				exec  @v_logStatus = LogSkip 6,@v_scriptName
				EXECUTE('
				CREATE TABLE WFSAPAdapterAssocTable (
				ProcessDefId		INT				 NULL,
				ActivityId			INT				 NULL,
				EXTMETHODINDEX		INT				 NULL
				)
				')
				PRINT 'Table WFSAPAdapterAssocTable created successfully.'
			END
			END TRY
			BEGIN CATCH
				exec  @v_logStatus = LogFailed 6,@v_scriptName
				RAISERROR('Block 6 Failed.',16,1)
				RETURN
			END CATCH
		END
	exec @v_logStatus = LogUpdate 6,@v_scriptName

	exec @v_logStatus = LogInsert 7,@v_scriptName,'Adding new Column InputBuffer,OutputBuffer in WFWebServiceTable '	
	BEGIN
	BEGIN TRY
		IF NOT EXISTS ( SELECT * FROM sysColumns 
			WHERE 
			id = (SELECT id FROM sysObjects WHERE NAME = 'WFWebServiceTable')
			AND  NAME = 'InputBuffer'
			)
			BEGIN
				exec  @v_logStatus = LogSkip 7,@v_scriptName
				EXECUTE('ALTER TABLE WFWebServiceTable ADD InputBuffer NTEXT')
				PRINT 'Table WFWebServiceTable altered with new Column InputBuffer'
				EXECUTE('ALTER TABLE WFWebServiceTable ADD OutputBuffer NTEXT')
				PRINT 'Table WFWebServiceTable altered with new Column OutputBuffer'
			END	
			END TRY
			BEGIN CATCH
				exec  @v_logStatus = LogFailed 7,@v_scriptName
				RAISERROR('Block 7 Failed.',16,1)
				RETURN
			END CATCH
		END
	exec @v_logStatus = LogUpdate 7,@v_scriptName

	exec @v_logStatus = LogInsert 8,@v_scriptName,'Creating TABLE WFPDATable'	
		BEGIN
			BEGIN TRY
			IF NOT EXISTS(SELECT * FROM SYSObjects WHERE NAME = 'WFPDATable' AND xType = 'U')
			BEGIN
				exec  @v_logStatus = LogSkip 8,@v_scriptName
				EXECUTE('
				CREATE TABLE WFPDATable(
					ProcessDefId		INT				NOT NULL, 
					ActivityId			INT				NOT NULL , 
					InterfaceId			INT				NOT NULL,
					InterfaceType		NVARCHAR(1)
				)
				')
				PRINT 'Table WFPDATable created successfully.'
			END
			END TRY
			BEGIN CATCH
				exec  @v_logStatus = LogFailed 8,@v_scriptName
				RAISERROR('Block 8 Failed.',16,1)
				RETURN
			END CATCH
		END
	exec @v_logStatus = LogUpdate 8,@v_scriptName

	exec @v_logStatus = LogInsert 9,@v_scriptName,'creating TABLE WFPDA_FormTable if not exist else adding new Columns i.e. ControlType,DisplayName,MinLen,MaxLen,Validation,OrderId in WFPDA_FormTable'	
		BEGIN
			BEGIN TRY
			IF NOT EXISTS(SELECT * FROM SYSObjects WHERE NAME = 'WFPDA_FormTable' AND xType = 'U')
			BEGIN
			exec  @v_logStatus = LogSkip 9,@v_scriptName
			EXECUTE('
			CREATE TABLE WFPDA_FormTable(
				ProcessDefId		INT				NOT NULL, 
				ActivityId			INT				NOT NULL , 
				VariableID			INT				NOT NULL, 
				VarfieldID			INT				NOT NULL,
				ControlType			INT				NOT NULL,
				DisplayName			NVARCHAR(255), 
				MinLen				INT				NOT NULL, 
				MaxLen				INT				NOT NULL,
				Validation			INT				NOT NULL, 
				OrderId				INT				NOT NULL
			)
			')
			PRINT 'Table WFPDA_FormTable created successfully.'
			END
			ELSE IF EXISTS (SELECT * FROM SYSObjects WHERE NAME = 'WFPDA_FormTable' AND xType = 'U') 
			BEGIN
			IF NOT EXISTS ( SELECT * FROM sysColumns 
			WHERE 
			id = (SELECT id FROM sysObjects WHERE NAME = 'WFPDA_FormTable')
			AND  NAME = 'ControlType'
			)
			BEGIN
				exec  @v_logStatus = LogSkip 9,@v_scriptName
				EXECUTE('ALTER TABLE WFPDA_FormTable ADD ControlType INT NOT NULL')
				PRINT 'Table WFPDA_FormTable altered with new Column ControlType'
				EXECUTE('ALTER TABLE WFPDA_FormTable ADD DisplayName NVARCHAR(255)')
				PRINT 'Table WFPDA_FormTable altered with new Column DisplayName'
				EXECUTE('ALTER TABLE WFPDA_FormTable ADD MinLen INT	NOT NULL')
				PRINT 'Table WFPDA_FormTable altered with new Column MinLen'
				EXECUTE('ALTER TABLE WFPDA_FormTable ADD MaxLen INT	NOT NULL')
				PRINT 'Table WFPDA_FormTable altered with new Column MaxLen'
				EXECUTE('ALTER TABLE WFPDA_FormTable ADD Validation INT	NOT NULL')
				PRINT 'Table WFPDA_FormTable altered with new Column Validation'
				EXECUTE('ALTER TABLE WFPDA_FormTable ADD OrderId INT NOT NULL')
				PRINT 'Table WFPDA_FormTable altered with new Column OrderId'
			END
			END
			END TRY
			BEGIN CATCH
				exec  @v_logStatus = LogFailed 9,@v_scriptName
				RAISERROR('Block 9 Failed.',16,1)
				RETURN
			END CATCH
		END
	exec @v_logStatus = LogUpdate 9,@v_scriptName

	exec @v_logStatus = LogInsert 10,@v_scriptName,'Creating TABLE WFPDAControlValueTable'	
		BEGIN
			BEGIN TRY
	
			/* Added by Ishu Saraf - 17/06/2009 */
			IF NOT EXISTS(
			SELECT * FROM SYSObjects 
			WHERE NAME = 'WFPDAControlValueTable'
			AND xType = 'U'
			)
			BEGIN
			exec  @v_logStatus = LogSkip 10,@v_scriptName
			EXECUTE('
			CREATE TABLE WFPDAControlValueTable(
				ProcessDefId	INT			NOT NULL, 
				ActivityId		INT			NOT NULL, 
				VariableId		INT			NOT NULL,
				VarFieldId		INT			NOT NULL,
				ControlValue	NVARCHAR(255)
			)
			')
			PRINT 'Table WFPDAControlValueTable created successfully.'
			END
			END TRY
			BEGIN CATCH
				exec  @v_logStatus = LogFailed 10,@v_scriptName
				RAISERROR('Block 10 Failed.',16,1)
				RETURN
			END CATCH
		END
	exec @v_logStatus = LogUpdate 10,@v_scriptName

	exec @v_logStatus = LogInsert 11,@v_scriptName,'Creating TABLE MAILTRIGGERTABLE'	
		BEGIN
			BEGIN TRY
			IF EXISTS(
			select *
			from information_schema.columns where table_name = 'mailtriggertable'
			and data_type = 'text'
			)
			BEGIN
			exec  @v_logStatus = LogSkip 11,@v_scriptName
			EXECUTE(' sp_rename mailtriggertable,mailtriggertable_old ')
			PRINT 'Original mailtriggertable renamed to mailtriggertable_old'
			EXECUTE('	
			CREATE TABLE MAILTRIGGERTABLE ( 
				ProcessDefId 		INT 		NOT NULL,
				TriggerID 		SMALLINT 	NOT NULL,
				Subject 		NVARCHAR(255) 	NULL,
				FromUser		NVARCHAR(255)	NULL,
				FromUserType		NVARCHAR(1)	NULL,
				ExtObjIDFromUser 	INT 		NULL,
				VariableIdFrom		INT		NULL,
				VarFieldIdFrom		INT		NULL,
				ToUser			NVARCHAR(255)	NOT NULL,
				ToType			NVARCHAR(1)	NOT NULL,
				ExtObjIDTo		INT		NULL,
				VariableIdTo		INT		NULL,
				VarFieldIdTo		INT		NULL,
				CCUser			NVARCHAR(255)	NULL,
				CCType			NVARCHAR(1)	NULL,
				ExtObjIDCC		INT		NULL,	
				VariableIdCc		INT		NULL,
				VarFieldIdCc		INT		NULL,
				Message			NTEXT		NULL,
				PRIMARY KEY (Processdefid , TriggerID)
		        )
				')
				PRINT 'New Mailtriggertable created with nText'
				EXECUTE('insert into MAILTRIGGERTABLE select * from mailtriggertable_old ')
				PRINT 'Table mailtriggertable updated successfully'
				END 
			END TRY
			BEGIN CATCH
				exec  @v_logStatus = LogFailed 11,@v_scriptName
				RAISERROR('Block 11 Failed.',16,1)
				RETURN
			END CATCH
		END
	exec @v_logStatus = LogUpdate 11,@v_scriptName

	exec @v_logStatus = LogInsert 12,@v_scriptName,'Adding new Columns i.e. BCCUser,BCCType,ExtObjIDBCC,VariableIdBCc,VarFieldIdBCc in MAILTRIGGERTABLE'	
		BEGIN
			BEGIN TRY
			
			/* Bug 42494 */
			IF NOT EXISTS ( SELECT * FROM sysColumns 
			WHERE 
			id = (SELECT id FROM sysObjects WHERE NAME = 'MAILTRIGGERTABLE')
			AND  NAME = 'BCCUser'
			)
			BEGIN
			exec  @v_logStatus = LogSkip 12,@v_scriptName
			EXECUTE('ALTER TABLE MAILTRIGGERTABLE ADD BCCUser NVARCHAR(255) DEFAULT NULL, BCCType NVARCHAR(1) DEFAULT ''C'', ExtObjIDBCC int DEFAULT 0, VariableIdBCc int DEFAULT 0, VarFieldIdBCc int DEFAULT 0')
		
			BEGIN TRANSACTION trans
			
			EXECUTE ('UPDATE MAILTRIGGERTABLE SET BCCTYPE = ''C'' WHERE BCCTYPE IS NULL')
			EXECUTE ('UPDATE MAILTRIGGERTABLE SET ExtObjIDBCC=0 WHERE ExtObjIDBCC IS NULL')
			EXECUTE ('UPDATE MAILTRIGGERTABLE SET VariableIdBCc=0 WHERE VariableIdBCc IS NULL')
			EXECUTE ('UPDATE MAILTRIGGERTABLE SET VarFieldIdBCc=0 WHERE VarFieldIdBCc IS NULL')
		
			COMMIT TRANSACTION trans
				
			PRINT 'Table MAILTRIGGERTABLE altered with new Columns BCCUser,BCCType,ExtObjIDBCC,VariableIdBCc and VarFieldIdBCc'
			END
			END TRY
			BEGIN CATCH
				exec  @v_logStatus = LogFailed 12,@v_scriptName
				RAISERROR('Block 12 Failed.',16,1)
				RETURN
			END CATCH
		END
	exec @v_logStatus = LogUpdate 12,@v_scriptName

	exec @v_logStatus = LogInsert 13,@v_scriptName,'Adding new Columns i.e. MailPriority,MailPriorityType,ExtObjIdMailPriority,VariableIdMailPriority,VarFieldIdMailPriority in MAILTRIGGERTABLE'
		BEGIN
			BEGIN TRY
				
			/* Bug 42795 */
			IF NOT EXISTS ( SELECT * FROM sysColumns 
			WHERE 
			id = (SELECT id FROM sysObjects WHERE NAME = 'MAILTRIGGERTABLE')
			AND  NAME = 'MailPriority'
			)
			BEGIN
			exec  @v_logStatus = LogSkip 13,@v_scriptName
			BEGIN TRANSACTION trans
			
			ALTER TABLE MAILTRIGGERTABLE ADD MailPriority NVARCHAR(255) DEFAULT NULL, MailPriorityType NVARCHAR(1) DEFAULT 'C', ExtObjIdMailPriority int DEFAULT 0, VariableIdMailPriority int DEFAULT 0, VarFieldIdMailPriority int DEFAULT 0
							
			COMMIT TRANSACTION trans
			
			BEGIN TRANSACTION trans
			EXECUTE ('UPDATE MAILTRIGGERTABLE SET MAILPRIORITYTYPE = ''C'' WHERE MAILPRIORITYTYPE IS NULL')
			EXECUTE ('UPDATE MAILTRIGGERTABLE SET ExtObjIdMailPriority=0 WHERE ExtObjIdMailPriority IS NULL')
			EXECUTE ('UPDATE MAILTRIGGERTABLE SET VariableIdMailPriority=0 WHERE VariableIdMailPriority IS NULL')
			EXECUTE ('UPDATE MAILTRIGGERTABLE SET VarFieldIdMailPriority=0 WHERE VarFieldIdMailPriority IS NULL')
			COMMIT TRANSACTION trans
			
			PRINT 'Table MAILTRIGGERTABLE altered with new Columns MailPriority,MailPriorityType,ExtObjIdMailPriority,VariableIdMailPriority and VarFieldIdMailPriority'
			END
			
			END TRY
			BEGIN CATCH
				exec  @v_logStatus = LogFailed 13,@v_scriptName
				RAISERROR('Block 13 Failed.',16,1)
				RETURN
			END CATCH
		END
	exec @v_logStatus = LogUpdate 13,@v_scriptName

	exec @v_logStatus = LogInsert 14,@v_scriptName,'Dropping constrain on TaskId in WFMailQueueHistoryTable'	
		BEGIN
			BEGIN TRY
				
				BEGIN
				SELECT @constrnName = constraint_name 
				FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS 
				where table_name = 'WFMailQueueHistoryTable'
				
				IF (@constrnName IS NOT NULL AND (LEN(@constrnName) > 0))
				BEGIN
					exec  @v_logStatus = LogSkip 14,@v_scriptName
					EXECUTE ('alter table WFMailQueueHistoryTable drop constraint ' + @constrnName)  
					PRINT 'Table WFMailQueueHistoryTable altered, constraint on TaskId dropped.'
				END
				END
			END TRY
			BEGIN CATCH
				exec  @v_logStatus = LogFailed 14,@v_scriptName
				RAISERROR('Block 14 Failed.',16,1)
				RETURN
			END CATCH
		END
	exec @v_logStatus = LogUpdate 14,@v_scriptName

	exec @v_logStatus = LogInsert 15,@v_scriptName,'Recreating TABLE USERPREFERENCESTABLE '	
		BEGIN
			BEGIN TRY
	
			IF EXISTS(
			select *
			from information_schema.columns where table_name = 'userpreferencestable'
			and data_type = 'text'
			)
			BEGIN
			exec  @v_logStatus = LogSkip 15,@v_scriptName
			EXECUTE(' sp_rename userpreferencestable,userpreferencestable_old ')
			PRINT 'Original userpreferencestable renamed to userpreferencestable_old'
			EXECUTE('
				CREATE TABLE USERPREFERENCESTABLE  (
						Userid 			SMALLINT ,
						ObjectId 		INT,
						ObjectName 		NVARCHAR(255),
						ObjectType 		NVARCHAR(30),
						NotifyByEmail 		NVARCHAR(1),
						Data			NTEXT
						CONSTRAINT Pk_User_pref1 PRIMARY KEY (Userid,ObjectType,ObjectId),
						CONSTRAINT Uk_User_pref1 UNIQUE (Userid, Objectname,ObjectType )
				)
			')
			PRINT 'New userpreferencestable created with nText'
			EXECUTE('insert into USERPREFERENCESTABLE 
				select * from userpreferencestable_old ')
			PRINT 'Table userpreferencestable updated successfully'
			END 
			END TRY
			BEGIN CATCH
				exec  @v_logStatus = LogFailed 15,@v_scriptName
				RAISERROR('Block 15 Failed.',16,1)
				RETURN
			END CATCH
		END
	exec @v_logStatus = LogUpdate 15,@v_scriptName

	exec @v_logStatus = LogInsert 16,@v_scriptName,'Creating TABLE WFMAILQUEUEHISTORYTABLE'	
		BEGIN
			BEGIN TRY
	
				IF EXISTS(
				select *
				from information_schema.columns where table_name = 'wfmailqueuehistorytable'
				and data_type = 'text'
				)
				BEGIN
				exec  @v_logStatus = LogSkip 16,@v_scriptName
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
				exec  @v_logStatus = LogFailed 16,@v_scriptName
				RAISERROR('Block 16 Failed.',16,1)
				RETURN
			END CATCH
		END
	exec @v_logStatus = LogUpdate 16,@v_scriptName

	exec @v_logStatus = LogInsert 17,@v_scriptName,'Creating TABLE PRINTFAXEMAILTABLE'	
		BEGIN
			BEGIN TRY
			
				IF EXISTS(
				select *
				from information_schema.columns where table_name = 'printfaxemailtable'
				and data_type = 'text'
				)
				BEGIN
				exec  @v_logStatus = LogSkip 17,@v_scriptName
				EXECUTE(' sp_rename printfaxemailtable,printfaxemailtable_old ')
				PRINT 'Original printfaxemailtable renamed to printfaxemailtable_old'
				EXECUTE('	
					CREATE TABLE PRINTFAXEMAILTABLE (
						ProcessDefId            INT			NOT NULL,
						PFEInterfaceId          INT			NOT NULL,
						InstrumentData          NVARCHAR(1)		NULL,
						FitToPage               NVARCHAR(1)		NULL,
						Annotations             NVARCHAR(1)		NULL,
						FaxNo                   NVARCHAR(255)		NULL,
						FaxNoType               NVARCHAR(1)		NULL,
						ExtFaxNoId              INT			NULL,
						VariableIdFax		INT			NULL,
						VarFieldIdFax		INT			NULL,
						CoverSheet              NVARCHAR(50)		NULL,
						CoverSheetBuffer        IMAGE			NULL,
						ToUser                  NVARCHAR(255)		NULL,
						FromUser                NVARCHAR(255)		NULL,
						ToMailId                NVARCHAR(255)		NULL,
						ToMailIdType            NVARCHAR(1)		NULL,
						ExtToMailId             INT			NULL,
						VariableIdTo		INT			NULL,
						VarFieldIdTo		INT			NULL,
						CCMailId                NVARCHAR(255)		NULL,
						CCMailIdType            NVARCHAR(1)		NULL,
						ExtCCMailId             INT			NULL,
						VariableIdCc		INT			NULL,
						VarFieldIdCc		INT			NULL,
						SenderMailId            NVARCHAR(255)		NULL,
						SenderMailIdType        NVARCHAR(1)		NULL,
						ExtSenderMailId         INT			NULL,
						VariableIdFrom		INT			NULL,
						VarFieldIdFrom		INT			NULL,
						Message                 NTEXT			NULL,
						Subject                 NVARCHAR(255)		NULL
					) 
				')
				PRINT 'New printfaxemailtable created with nText'
				EXECUTE(' insert into PRINTFAXEMAILTABLE select * from printfaxemailtable_old ')
				PRINT 'Table printfaxemailtable updated successfully'
				END
			
			END TRY
			BEGIN CATCH
				exec  @v_logStatus = LogFailed 17,@v_scriptName
				RAISERROR('Block 17 Failed.',16,1)
				RETURN
			END CATCH
		END
	exec @v_logStatus = LogUpdate 17,@v_scriptName

	exec @v_logStatus = LogInsert 18,@v_scriptName,'Adding new Columns i.e. BCCMailId,BCCMailIdType,ExtBCCMailId,VariableIdBCC,VarFieldIdBCC in PRINTFAXEMAILTABLE'	
		BEGIN
			BEGIN TRY
			
				/* Bug 42494 */
				IF NOT EXISTS ( SELECT * FROM sysColumns 
				WHERE 
				id = (SELECT id FROM sysObjects WHERE NAME = 'PRINTFAXEMAILTABLE')
				AND  NAME = 'BCCMailId'
				)
				BEGIN
				exec  @v_logStatus = LogSkip 18,@v_scriptName
			
				EXECUTE('ALTER TABLE PRINTFAXEMAILTABLE ADD BCCMailId NVARCHAR(255) DEFAULT NULL, BCCMailIdType NVARCHAR(1) Default ''C'', ExtBCCMailId int DEFAULT 0, VariableIdBCC int DEFAULT 0, VarFieldIdBCC int DEFAULT 0')
				
				
				BEGIN TRANSACTION trans
				
				EXECUTE ('UPDATE PRINTFAXEMAILTABLE SET BCCMailIdType=''C'' WHERE BCCMailIdType IS NULL')
				
				EXECUTE ('UPDATE PRINTFAXEMAILTABLE SET ExtBCCMailId = 0 WHERE ExtBCCMailId IS NULL')
				
				EXECUTE ('UPDATE PRINTFAXEMAILTABLE SET VariableIdBCC = 0 WHERE VariableIdBCC IS NULL')
				
				EXECUTE ('UPDATE PRINTFAXEMAILTABLE SET  VarFieldIdBCC = 0 WHERE VarFieldIdBCC IS NULL')
				
				COMMIT TRANSACTION trans
				
				
				PRINT 'Table PRINTFAXEMAILTABLE altered with new Columns BCCMailId,BCCMailIdType,ExtBCCMailId,VariableIdBCC and VarFieldIdBCC'
				END
			END TRY
			BEGIN CATCH
				exec  @v_logStatus = LogFailed 18,@v_scriptName
				RAISERROR('Block 18 Failed.',16,1)
				RETURN
			END CATCH
		END
	exec @v_logStatus = LogUpdate 18,@v_scriptName

	exec @v_logStatus = LogInsert 19,@v_scriptName,'Adding new columns MailPriority,MailPriorityType,ExtObjIdMailPriority,VariableIdMailPriority,VarFieldIdMailPriority in PRINTFAXEMAILTABLE'	
		BEGIN
			BEGIN TRY
			
				/* Bug 42795 */
				IF NOT EXISTS ( SELECT * FROM sysColumns 
				WHERE 
				id = (SELECT id FROM sysObjects WHERE NAME = 'PRINTFAXEMAILTABLE')
				AND  NAME = 'MailPriority'
				)
				BEGIN
				exec  @v_logStatus = LogSkip 19,@v_scriptName
			
				EXECUTE('ALTER TABLE PRINTFAXEMAILTABLE ADD MailPriority NVARCHAR(255) Default 1, MailPriorityType NVARCHAR(255) Default ''C'', ExtObjIdMailPriority int DEFAULT 0, VariableIdMailPriority int DEFAULT 0, VarFieldIdMailPriority int DEFAULT 0')
				
				BEGIN TRANSACTION trans
				
				EXECUTE ('UPDATE PRINTFAXEMAILTABLE SET MailPriority=1 WHERE MailPriority IS NULL')
				EXECUTE ('UPDATE PRINTFAXEMAILTABLE SET MailPriorityType= ''C'' WHERE MailPriorityType IS NULL')
				EXECUTE ('UPDATE PRINTFAXEMAILTABLE SET ExtObjIdMailPriority=0 WHERE ExtObjIdMailPriority IS NULL')
				EXECUTE ('UPDATE PRINTFAXEMAILTABLE SET VariableIdMailPriority=0 WHERE VariableIdMailPriority IS NULL')
				EXECUTE ('UPDATE PRINTFAXEMAILTABLE SET VarFieldIdMailPriority=0 WHERE VarFieldIdMailPriority IS NULL')
				
				COMMIT TRANSACTION trans
				
				
				
				PRINT 'Table PRINTFAXEMAILTABLE altered with new Columns MailPriority,MailPriorityType,ExtObjIdMailPriority,VariableIdMailPriority and VarFieldIdMailPriority'
				END
			END TRY
			BEGIN CATCH
				exec  @v_logStatus = LogFailed 19,@v_scriptName
				RAISERROR('Block 19 Failed.',16,1)
				RETURN
			END CATCH
		END
	exec @v_logStatus = LogUpdate 19,@v_scriptName

	exec @v_logStatus = LogInsert 20,@v_scriptName,'Adding  new Columns VariableId and VarFieldId in PrintFaxEmailDocTypeTable'	
		BEGIN
			BEGIN TRY
			
			
				/*HotFix_8.0_045- Variable support in doctypename in PFE*/
				IF NOT EXISTS ( SELECT * FROM sysColumns 
				WHERE 
				id = (SELECT id FROM sysObjects WHERE NAME = 'PrintFaxEmailDocTypeTable')
				AND  NAME = 'VariableId'
				)
				BEGIN
				exec  @v_logStatus = LogSkip 20,@v_scriptName
				
				EXECUTE('ALTER TABLE PrintFaxEmailDocTypeTable ADD VariableId INT DEFAULT 0, VarFieldId INT DEFAULT 0')
				
				EXECUTE ('UPDATE  PrintFaxEmailDocTypeTable SET VariableId=0 WHERE  VariableId IS NULL')
				
				EXECUTE ('UPDATE  PrintFaxEmailDocTypeTable SET VarFieldId=0 WHERE  VarFieldId IS NULL')
			
		
				PRINT 'Table PrintFaxEmailDocTypeTable altered with new Columns VariableId and VarFieldId'
				END
			END TRY
			BEGIN CATCH
				exec  @v_logStatus = LogFailed 20,@v_scriptName
				RAISERROR('Block 20 Failed.',16,1)
				RETURN
			END CATCH
		END
	exec @v_logStatus = LogUpdate 20,@v_scriptName

	exec @v_logStatus = LogInsert 21,@v_scriptName,'Dropping constraint first then adding default constraint on Column VARFIELDID,VarFieldId in PRINTFAXEMAILDOCTYPETABLE '	
		BEGIN
			BEGIN TRY
				exec  @v_logStatus = LogSkip 21,@v_scriptName
			
				EXEC dropdefaultconstraint 'PRINTFAXEMAILDOCTYPETABLE','VARIABLEID'
				ALTER TABLE PrintFaxEmailDocTypeTable ADD CONSTRAINT DF_PFEVARIABLEFIELDID  DEFAULT 0  FOR VARIABLEID
			
				PRINT 'Table PrintFaxEmailDocTypeTable altered  Column VariableId '
			
			
				EXEC dropdefaultconstraint 'PRINTFAXEMAILDOCTYPETABLE','VARFIELDID'
				ALTER TABLE PrintFaxEmailDocTypeTable ADD CONSTRAINT DF_VARFIELDID DEFAULT 0   FOR VARFIELDID
			
				PRINT 'Table PrintFaxEmailDocTypeTable altered  Column  VarFieldId'
			END TRY
			BEGIN CATCH
				exec  @v_logStatus = LogFailed 21,@v_scriptName
				RAISERROR('Block 21 Failed.',16,1)
				RETURN
			END CATCH
		END
	exec @v_logStatus = LogUpdate 21,@v_scriptName

	exec @v_logStatus = LogInsert 22,@v_scriptName,'Adding  new Column CalendarName in QueueDataTable'	
		BEGIN
			BEGIN TRY
					/*WFS_8.0_026 - workitem specific calendar*/
					if @v_TableExists = 1
				Begin
					IF NOT EXISTS ( SELECT * FROM sysColumns 
					WHERE 
					id = (SELECT id FROM sysObjects WHERE NAME = 'QueueDataTable')
					AND  NAME = 'CalendarName'
					)
					BEGIN
						exec  @v_logStatus = LogSkip 22,@v_scriptName
						EXECUTE('ALTER TABLE QueueDataTable ADD CalendarName NVARCHAR(255)')
						PRINT 'Table QueueDataTable altered with new Column CalendarName'
					END
		
				END
			END TRY
			BEGIN CATCH
				exec  @v_logStatus = LogFailed 22,@v_scriptName
				RAISERROR('Block 22 Failed.',16,1)
				RETURN
			END CATCH
		END
	exec @v_logStatus = LogUpdate 22,@v_scriptName

	exec @v_logStatus = LogInsert 23,@v_scriptName,'Inserting in VarMappingTable,Inserting in WFCabVersionTable for 7.2_CalendarName_VarMapping'	
		BEGIN
			BEGIN TRY
			
				/*WFS_8.0_018 End*/
				IF NOT EXISTS(SELECT * FROM WFCabVersionTable WHERE CabVersion = '7.2_CalendarName_VarMapping')
				BEGIN
					exec  @v_logStatus = LogSkip 23,@v_scriptName
					DECLARE cursor1 CURSOR STATIC FOR
					SELECT ProcessDefId FROM ProcessDefTable
					OPEN cursor1
					FETCH NEXT FROM cursor1 INTO @ProcessDefId
					WHILE(@@FETCH_STATUS = 0) 
					BEGIN 
						IF NOT EXISTS( SELECT * FROM VarMappingTable WHERE  processdefid = @ProcessDefId AND variableid = '10001')
						BEGIN
							BEGIN TRANSACTION trans
								EXECUTE(' INSERT INTO VarMappingTable VALUES(' + @ProcessDefId + ', 10001 , N''CalendarName'', N''CalendarName'', 10 , N''M'', 0, NULL , NULL, 0, N''N'')' )
							COMMIT TRANSACTION trans
						END
						FETCH NEXT FROM cursor1 INTO @ProcessDefId
					END
					CLOSE cursor1
					DEALLOCATE cursor1
					EXECUTE('INSERT INTO WFCabVersionTable(cabVersion, creationDate, lastModified, Remarks, Status) VALUES (N''7.2_CalendarName_VarMapping'', GETDATE(), GETDATE(), N''OmniFlow 7.2'', N''Y'')')
				END
			END TRY
			BEGIN CATCH
				exec  @v_logStatus = LogFailed 23,@v_scriptName
				RAISERROR('Block 23 Failed.',16,1)
				RETURN
			END CATCH
		END
	exec @v_logStatus = LogUpdate 23,@v_scriptName

	exec @v_logStatus = LogInsert 24,@v_scriptName,'Creating VIEW QUEUETABLE '	
		BEGIN
			BEGIN TRY
			
			/*WFS_8.0_026 - workitem specific calendar*/
				if @v_TableExists = 1
				Begin
					exec  @v_logStatus = LogSkip 24,@v_scriptName
					EXECUTE('DROP VIEW QueueTable')
					
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
				exec  @v_logStatus = LogFailed 24,@v_scriptName
				RAISERROR('Block 24 Failed.',16,1)
				RETURN
			END CATCH
		END
	exec @v_logStatus = LogUpdate 24,@v_scriptName

	exec @v_logStatus = LogInsert 25,@v_scriptName,'Dropping then Creating VIEW QUSERGROUPVIEW'	
		BEGIN
			BEGIN TRY
				/*WFS_8.0_031*/
				BEGIN
				
					Select @existsFlag = 0 	
					IF NOT EXISTS ( SELECT * FROM sysColumns 
						WHERE 
						id = (SELECT id FROM sysObjects WHERE NAME = 'QUEUEUSERTABLE')
						AND  NAME = 'QUERYPREVIEW'
						)  
					BEGIN
						ALTER TABLE QUEUEUSERTABLE ADD QUERYPREVIEW NVARCHAR(1) DEFAULT ('Y')
					END
					If Exists (Select * FROM SysObjects (NOLOCK) Where xType = 'V' and name = 'QUSERGROUPVIEW')
					Begin
						exec  @v_logStatus = LogSkip 25,@v_scriptName
						Execute('DROP view QUSERGROUPVIEW')
						Print 'View QUSERGROUPVIEW already exists, hence older one dropped ..... '
					End
						exec('CREATE VIEW QUSERGROUPVIEW(
						QUEUEID, USERID, GROUPID, ASSIGNEDTILLDATETIME, QUERYFILTER, QUERYPREVIEW
						)
						AS 
						SELECT "QUEUEID","USERID","GROUPID","ASSIGNEDTILLDATETIME","QUERYFILTER" ,"QUERYPREVIEW" FROM 
						(SELECT queueid,userid,cast ( NULL AS INTEGER ) AS GroupId,assignedtilldatetime , queryFilter ,QueryPreview
						FROM QUEUEUSERTABLE  
						WHERE associationtype=0 
						AND ( assignedtilldatetime IS NULL OR assignedtilldatetime>=getDate() ) 
						UNION 
						SELECT queueid, userindex,userid AS groupid, assignedtilldatetime, queryFilter ,QueryPreview
						FROM QUEUEUSERTABLE,wfgroupmemberview 
						WHERE associationtype=1  AND QUEUEUSERTABLE.userid=wfgroupmemberview.groupindex)as a')
					
				END
			END TRY
			BEGIN CATCH
				exec  @v_logStatus = LogFailed 25,@v_scriptName
				RAISERROR('Block 25 Failed.',16,1)
				RETURN
			END CATCH
		END
	exec @v_logStatus = LogUpdate 25,@v_scriptName

	exec @v_logStatus = LogInsert 26,@v_scriptName,'Adding new Column REFRESHINTERVAL in QUEUEDEFTABLE'	
		BEGIN
			BEGIN TRY
			
				/*WFS_8.0_038*/
				BEGIN
					Select @existsFlag = 0 	
					IF NOT EXISTS ( SELECT * FROM sysColumns 
					WHERE 
					id = (SELECT id FROM sysObjects WHERE NAME = 'QUEUEDEFTABLE')
					AND  NAME = 'REFRESHINTERVAL'
					)  
					BEGIN
					exec  @v_logStatus = LogSkip 26,@v_scriptName
					ALTER TABLE QUEUEDEFTABLE ADD REFRESHINTERVAL INT NULL
					END
				END
			END TRY
			BEGIN CATCH
				exec  @v_logStatus = LogFailed 26,@v_scriptName
				RAISERROR('Block 26 Failed.',16,1)
				RETURN
			END CATCH
		END
	exec @v_logStatus = LogUpdate 26,@v_scriptName

	exec @v_logStatus = LogInsert 27,@v_scriptName,'Creating TABLE WFExtInterfaceConditionTable'	
		BEGIN
			BEGIN TRY
				/*Added by Saurabh Kamal for Rules on External Interfaces*/
				IF NOT EXISTS (
				SELECT * FROM SYSObjects 
				WHERE NAME = 'WFExtInterfaceConditionTable' 
				AND xType = 'U'
				)
				BEGIN
					exec  @v_logStatus = LogSkip 27,@v_scriptName
					EXECUTE(' 
						CREATE TABLE WFExtInterfaceConditionTable (
							ProcessDefId 	    	INT		NOT NULL,
							ActivityId          	INT		NOT NULL ,
							InterFaceType           NVARCHAR(1)   	NOT NULL ,
							RuleOrderId         	INT      	NOT NULL ,
							RuleId              	INT      	NOT NULL ,
							ConditionOrderId    	INT 		NOT NULL ,
							Param1			NVARCHAR(50) 	NOT NULL ,
							Type1               	NVARCHAR(1) 	NOT NULL ,
							ExtObjID1	    	INT		NULL,
							VariableId_1		INT		NULL,
							VarFieldId_1		INT		NULL,
							Param2			NVARCHAR(255) 	NOT NULL ,
							Type2               	NVARCHAR(1) 	NOT NULL ,
							ExtObjID2	    	INT		NULL,
							VariableId_2		INT             NULL,
							VarFieldId_2		INT             NULL,
							Operator            	INT 		NOT NULL ,
							LogicalOp           	INT 		NOT NULL 
						)
					')
					PRINT 'Table WFExtInterfaceConditionTable created successfully.'
				END
			
			END TRY
			BEGIN CATCH
				exec  @v_logStatus = LogFailed 27,@v_scriptName
				RAISERROR('Block 27 Failed.',16,1)
				RETURN
			END CATCH
		END
	exec @v_logStatus = LogUpdate 27,@v_scriptName

	exec @v_logStatus = LogInsert 28,@v_scriptName,'Creating TABLE WFExtInterfaceOperationTable'	
		BEGIN
			BEGIN TRY
			
				IF NOT EXISTS(
				SELECT * FROM SYSObjects 
				WHERE NAME = 'WFExtInterfaceOperationTable'
				AND xType = 'U'
				)
				BEGIN
					exec  @v_logStatus = LogSkip 28,@v_scriptName
					EXECUTE('
						CREATE TABLE WFExtInterfaceOperationTable(
							ProcessDefId 	    	INT		NOT NULL,
							ActivityId          	INT		NOT NULL ,
							InterFaceType           NVARCHAR(1)   	NOT NULL ,	
							RuleId              	INT      	NOT NULL , 	
							InterfaceElementId	INT		NOT NULL
						)
					')
					PRINT 'Table WFExtInterfaceOperationTable created successfully.'
				END
				
			END TRY
			BEGIN CATCH
				exec  @v_logStatus = LogFailed 28,@v_scriptName
				RAISERROR('Block 28 Failed.',16,1)
				RETURN
			END CATCH
		END
	exec @v_logStatus = LogUpdate 28,@v_scriptName

	exec @v_logStatus = LogInsert 29,@v_scriptName,'Inserting in VarMappingTable,Inserting in WFCabVersionTable for 7.2_TurnAroundDateTime_VarMapping'	
		BEGIN
			BEGIN TRY
			
				/*WFS_8.0_044 Support of TurnAroundDateTime in FetchWorkList and SearchWorkitem*/
				IF NOT EXISTS(SELECT * FROM WFCabVersionTable WHERE CabVersion = '7.2_TurnAroundDateTime_VarMapping')
				BEGIN
					exec  @v_logStatus = LogSkip 29,@v_scriptName
					DECLARE cursor1 CURSOR STATIC FOR
					SELECT ProcessDefId FROM ProcessDefTable
					OPEN cursor1
					FETCH NEXT FROM cursor1 INTO @ProcessDefId
					WHILE(@@FETCH_STATUS = 0) 
					BEGIN 
						IF NOT EXISTS( SELECT * FROM VarMappingTable WHERE  processdefid = @ProcessDefId AND variableid = '10001')
						BEGIN
							BEGIN TRANSACTION trans
								EXECUTE(' INSERT INTO VarMappingTable VALUES(' + @ProcessDefId + ', 10002 , N''ExpectedWorkitemDelay'', N''TurnAroundDateTime'', 8 , N''S'', 0, NULL , NULL, 0, N''N'')' )
							COMMIT TRANSACTION trans
						END	
		
						FETCH NEXT FROM cursor1 INTO @ProcessDefId
					END
					CLOSE cursor1
					DEALLOCATE cursor1
					EXECUTE('INSERT INTO WFCabVersionTable(cabVersion, creationDate, lastModified, Remarks, Status) VALUES (N''7.2_TurnAroundDateTime_VarMapping'', GETDATE(), GETDATE(), N''OmniFlow 7.2'', N''Y'')')
				END
			END TRY
			BEGIN CATCH
				exec  @v_logStatus = LogFailed 29,@v_scriptName
				RAISERROR('Block 29 Failed.',16,1)
				RETURN
			END CATCH
		END
	exec @v_logStatus = LogUpdate 29,@v_scriptName

	exec @v_logStatus = LogInsert 30,@v_scriptName,'Creating TABLE WFDocTypeFieldMapping'	
		BEGIN
			BEGIN TRY	
				
				IF NOT EXISTS(SELECT * FROM sysObjects WHERE NAME = 'WFDocTypeFieldMapping')
				BEGIN
					exec  @v_logStatus = LogSkip 30,@v_scriptName
					CREATE TABLE WFDocTypeFieldMapping(
					ProcessDefId int NOT NULL,
					DocID int NOT NULL,
					DCName nvarchar (30) NOT NULL,
					FieldName nvarchar (30) NOT NULL,
					FieldID int NOT NULL,
					VariableID int NOT NULL,
					VarFieldID int NOT NULL,
					MappedFieldType nvarchar(1) NOT NULL,
					MappedFieldName nvarchar(255) NOT NULL,
					FieldType int NOT NULL
					)
					PRINT 'Table WFDocTypeFieldMapping created successfully'
				END
			END TRY
			BEGIN CATCH
				exec  @v_logStatus = LogFailed 30,@v_scriptName
				RAISERROR('Block 30 Failed.',16,1)
				RETURN
			END CATCH
		END
	exec @v_logStatus = LogUpdate 30,@v_scriptName

	exec @v_logStatus = LogInsert 31,@v_scriptName,'Creating TABLE WFDocTypeSearchMapping'	
		BEGIN
			BEGIN TRY
				IF NOT EXISTS(SELECT * FROM sysObjects WHERE NAME = 'WFDocTypeSearchMapping')
				BEGIN
					exec  @v_logStatus = LogSkip 31,@v_scriptName
					CREATE TABLE WFDocTypeSearchMapping(
					ProcessDefId int NOT NULL,
					ActivityID int NOT NULL,
					DCName nvarchar(30) NULL,
					DCField nvarchar(30) NOT NULL,
					VariableID int NOT NULL,
					VarFieldID int NOT NULL,
					MappedFieldType nvarchar(1) NOT NULL,
					MappedFieldName nvarchar(255) NOT NULL,
					FieldType int NOT NULL
					)
					PRINT 'Table WFDocTypeSearchMapping created successfully'
				END
			END TRY
			BEGIN CATCH
				exec  @v_logStatus = LogFailed 31,@v_scriptName
				RAISERROR('Block 31 Failed.',16,1)
				RETURN
			END CATCH
		END
	exec @v_logStatus = LogUpdate 31,@v_scriptName

	exec @v_logStatus = LogInsert 32,@v_scriptName,'Creating TABLE WFDataclassUserInfo'	
		BEGIN
			BEGIN TRY
				IF NOT EXISTS(SELECT * FROM sysObjects WHERE NAME = 'WFDataclassUserInfo')
				BEGIN
					exec  @v_logStatus = LogSkip 32,@v_scriptName
					CREATE TABLE WFDataclassUserInfo(
					ProcessDefId int NOT NULL,
					CabinetName nvarchar(30) NOT NULL,
					UserName nvarchar(30) NOT NULL,
					SType nvarchar(1) NOT NULL,
					UserPWD Nvarchar(255) NOT NULL
					)
					PRINT 'Table WFDataclassUserInfo created successfully'
				END
			
			END TRY
			BEGIN CATCH
				exec  @v_logStatus = LogFailed 32,@v_scriptName
				RAISERROR('Block 32 Failed.',16,1)
				RETURN
			END CATCH
		END
	exec @v_logStatus = LogUpdate 32,@v_scriptName

	exec @v_logStatus = LogInsert 33,@v_scriptName,'Adding new Columns CommentFont,CommentForeColor,CommentBackColor,CommentBorderStyle in PROCESSDEFCOMMENTTABLE'	
		BEGIN
			BEGIN TRY
			
				IF NOT EXISTS ( SELECT * FROM sysColumns 
				WHERE 
				id = (SELECT id FROM sysObjects WHERE NAME = 'PROCESSDEFCOMMENTTABLE')
				AND  NAME in ('CommentFont','CommentForeColor','CommentBackColor','CommentBorderStyle')
				)
				BEGIN
					exec  @v_logStatus = LogSkip 33,@v_scriptName
					EXECUTE('ALTER TABLE PROCESSDEFCOMMENTTABLE ADD CommentFont NVARCHAR(255) NOT NULL DEFAULT ''''')
					PRINT 'Table PROCESSDEFCOMMENTTABLE altered with new Column CommentFont'
					EXECUTE('ALTER TABLE PROCESSDEFCOMMENTTABLE ADD CommentForeColor INT NOT NULL DEFAULT 0')
					PRINT 'Table PROCESSDEFCOMMENTTABLE altered with new Column CommentForeColor'
					EXECUTE('ALTER TABLE PROCESSDEFCOMMENTTABLE ADD CommentBackColor INT NOT NULL DEFAULT 0')
					PRINT 'Table PROCESSDEFCOMMENTTABLE altered with new Column CommentBackColor'
					EXECUTE('ALTER TABLE PROCESSDEFCOMMENTTABLE ADD CommentBorderStyle INT NOT NULL DEFAULT 0')
					PRINT 'Table PROCESSDEFCOMMENTTABLE altered with new CommentBorderStyle'
				END
			END TRY
			BEGIN CATCH
				exec  @v_logStatus = LogFailed 33,@v_scriptName
				RAISERROR('Block 33 Failed.',16,1)
				RETURN
			END CATCH
		END
	exec @v_logStatus = LogUpdate 33,@v_scriptName

	exec @v_logStatus = LogInsert 34,@v_scriptName,'Table WFCURRENTROUTELOGTABLE altering with Column NewValue size as 2000,Table WFHISTORYROUTELOGTABLE altering with Column NewValue size as 2000'	
		BEGIN
			BEGIN TRY
			
				IF EXISTS(SELECT id FROM sysObjects WHERE NAME = 'WFCURRENTROUTELOGTABLE')
				BEGIN
				IF NOT EXISTS ( SELECT * FROM sysColumns 
				WHERE 
				id = (SELECT id FROM sysObjects WHERE NAME = 'WFCURRENTROUTELOGTABLE')
				AND  NAME = 'NewValue'
				)
				BEGIN
					exec  @v_logStatus = LogSkip 34,@v_scriptName
					EXECUTE('alter table WFCURRENTROUTELOGTABLE add  NewValue NVARCHAR(2000)')
					PRINT 'Table WFCURRENTROUTELOGTABLE altered with Column NewValue size as 2000'
					EXECUTE('alter table WFHISTORYROUTELOGTABLE add  NewValue NVARCHAR(2000)')
					PRINT 'Table WFHISTORYROUTELOGTABLE altered with Column NewValue size as 2000'
				END
				END
			END TRY
			BEGIN CATCH
				exec  @v_logStatus = LogFailed 34,@v_scriptName
				RAISERROR('Block 34 Failed.',16,1)
				RETURN
			END CATCH
		END
	exec @v_logStatus = LogUpdate 34,@v_scriptName

	exec @v_logStatus = LogInsert 35,@v_scriptName,'Table CURRENTROUTELOGTABLE altering with Column NewValue size as 2000,Table HISTORYROUTELOGTABLE altering with Column NewValue size as 2000'
		BEGIN
			BEGIN TRY
				IF EXISTS(SELECT id FROM sysObjects WHERE NAME = 'CURRENTROUTELOGTABLE')
				BEGIN
				IF NOT EXISTS ( SELECT * FROM sysColumns 
				WHERE 
				id = (SELECT id FROM sysObjects WHERE NAME = 'CURRENTROUTELOGTABLE')
				AND  NAME = 'NewValue'
				)
				BEGIN
					exec  @v_logStatus = LogSkip 35,@v_scriptName
					EXECUTE('alter table CURRENTROUTELOGTABLE add  NewValue NVARCHAR(2000)')
					PRINT 'Table CURRENTROUTELOGTABLE altered with Column NewValue size as 2000'
					EXECUTE('alter table HISTORYROUTELOGTABLE add  NewValue NVARCHAR(2000)')
					PRINT 'Table HISTORYROUTELOGTABLE altered with Column NewValue size as 2000'
				END
				END
			END TRY
			BEGIN CATCH
				exec  @v_logStatus = LogFailed 35,@v_scriptName
				RAISERROR('Block 35 Failed.',16,1)
				RETURN
			END CATCH
		END
	exec @v_logStatus = LogUpdate 35,@v_scriptName

	exec @v_logStatus = LogInsert 36,@v_scriptName,'Creating TABLE WFFormFragmentTable'	
		BEGIN
			BEGIN TRY
				IF NOT EXISTS(SELECT * FROM sysObjects WHERE NAME = 'WFFormFragmentTable')
				BEGIN
					exec  @v_logStatus = LogSkip 36,@v_scriptName
					CREATE TABLE WFFormFragmentTable(	
					ProcessDefId	int 		   NOT NULL,
					FragmentId	    int 		   NOT NULL,
					FragmentName	NVARCHAR(50)    NOT NULL,
					FragmentBuffer	IMAGE          NULL,
					IsEncrypted	    NVARCHAR(1)     NOT NULL,
					StructureName	NVARCHAR(326)   NOT NULL,
					StructureId	    int            NOT NULL
					)
					PRINT 'Table WFFormFragmentTable created successfully'
				END
			END TRY
			BEGIN CATCH
				exec  @v_logStatus = LogFailed 36,@v_scriptName
				RAISERROR('Block 36 Failed.',16,1)
				RETURN
			END CATCH
		END
	exec @v_logStatus = LogUpdate 36,@v_scriptName

	exec @v_logStatus = LogInsert 37,@v_scriptName,'Creating TABLE WFTMSSetVariableMapping'	
		BEGIN
			BEGIN TRY
				IF NOT EXISTS(SELECT * FROM sysObjects WHERE NAME = 'WFTMSSetVariableMapping')
				BEGIN
					exec  @v_logStatus = LogSkip 37,@v_scriptName
					CREATE TABLE WFTMSSetVariableMapping(
					RequestId           NVARCHAR(64)     NOT NULL,    
					ProcessDefId        INT,        
					ProcessName         NVARCHAR(64),
					RightFlag           NVARCHAR(64),
					ToReturn            NVARCHAR(1),
					Alias               NVARCHAR(64),
					QueueId             INT,
					QueueName           NVARCHAR(64),
					Param1              NVARCHAR(64),
					Param1Type           INT,    
					Type1               NVARCHAR(1),
					AliasRule			NVARCHAR(4000)
					)
					PRINT 'Table WFTMSSetVariableMapping created successfully'
				END
			END TRY
			BEGIN CATCH
				exec  @v_logStatus = LogFailed 37,@v_scriptName
				RAISERROR('Block 37 Failed.',16,1)
				RETURN
			END CATCH
		END
	exec @v_logStatus = LogUpdate 37,@v_scriptName

	exec @v_logStatus = LogInsert 38,@v_scriptName,'Adding new Column SortOrder in QUEUEDEFTABLE'	
		BEGIN
			BEGIN TRY
				IF NOT EXISTS ( SELECT * FROM sysColumns 
				WHERE 
				id = (SELECT id FROM sysObjects WHERE NAME = 'QUEUEDEFTABLE')
				AND  NAME = 'SortOrder'
				)
				BEGIN
					exec  @v_logStatus = LogSkip 38,@v_scriptName
					EXECUTE('ALTER TABLE QUEUEDEFTABLE ADD SortOrder NVARCHAR(1)')
					PRINT 'Table QUEUEDEFTABLE altered with new Column SortOrder'
				END
			END TRY
			BEGIN CATCH
				exec  @v_logStatus = LogFailed 38,@v_scriptName
				RAISERROR('Block 38 Failed.',16,1)
				RETURN
			END CATCH
		END
	exec @v_logStatus = LogUpdate 38,@v_scriptName

	exec @v_logStatus = LogInsert 39,@v_scriptName,'Adding new Column AliasRule in VARALIASTABLE'	
		BEGIN
			BEGIN TRY
				IF NOT EXISTS ( SELECT * FROM sysColumns 
				WHERE 
				id = (SELECT id FROM sysObjects WHERE NAME = 'VARALIASTABLE')
				AND  NAME = 'AliasRule'
				)
				BEGIN
					exec  @v_logStatus = LogSkip 39,@v_scriptName
					EXECUTE('ALTER TABLE VARALIASTABLE ADD AliasRule NVARCHAR(2000)')
					PRINT 'Table VARALIASTABLE altered with new Column AliasRule'
					END
				END TRY
			BEGIN CATCH
				exec  @v_logStatus = LogFailed 39,@v_scriptName
				RAISERROR('Block 39 Failed.',16,1)
				RETURN
			END CATCH
		END
	exec @v_logStatus = LogUpdate 39,@v_scriptName

	exec @v_logStatus = LogInsert 40,@v_scriptName,'Adding new Column DCName in DOCUMENTTYPEDEFTABLE'	
		BEGIN
			BEGIN TRY
				IF NOT EXISTS ( SELECT * FROM sysColumns 
				WHERE 
				id = (SELECT id FROM sysObjects WHERE NAME = 'DOCUMENTTYPEDEFTABLE')
				AND  NAME = 'DCName'
				)
				BEGIN
					exec  @v_logStatus = LogSkip 40,@v_scriptName
					EXECUTE('ALTER TABLE DOCUMENTTYPEDEFTABLE ADD DCName NVARCHAR(64)')
					PRINT 'Table DOCUMENTTYPEDEFTABLE altered with new Column DCName'
				END
			END TRY
			BEGIN CATCH
				exec  @v_logStatus = LogFailed 40,@v_scriptName
				RAISERROR('Block 40 Failed.',16,1)
				RETURN
			END CATCH
		END
	exec @v_logStatus = LogUpdate 40,@v_scriptName

	exec @v_logStatus = LogInsert 41,@v_scriptName,'Adding new Column SwimLaneType,SwimLaneText,SwimLaneTextColor in WFSwimLaneTable'
		BEGIN
			BEGIN TRY

				IF NOT EXISTS ( SELECT * FROM sysColumns 
				WHERE 
				id = (SELECT id FROM sysObjects WHERE NAME = 'WFSwimLaneTable')
				AND  NAME in ('SwimLaneType','SwimLaneText','SwimLaneTextColor')
				)
				BEGIN
					exec  @v_logStatus = LogSkip 41,@v_scriptName
					EXECUTE('ALTER TABLE WFSwimLaneTable ADD SwimLaneType NVARCHAR(1) NOT NULL DEFAULT ''''')
					PRINT 'Table WFSwimLaneTable altered with new Column SwimLaneType'
					EXECUTE('ALTER TABLE WFSwimLaneTable ADD SwimLaneText NVARCHAR(255) NOT NULL DEFAULT ''''')
					PRINT 'Table WFSwimLaneTable altered with new Column SwimLaneText'
					EXECUTE('ALTER TABLE WFSwimLaneTable ADD SwimLaneTextColor INT NOT NULL DEFAULT 0')
					PRINT 'Table WFSwimLaneTable altered with new Column SwimLaneTextColor'
				END
			END TRY
			BEGIN CATCH
				exec  @v_logStatus = LogFailed 41,@v_scriptName
				RAISERROR('Block 41 Failed.',16,1)
				RETURN
			END CATCH
		END
	exec @v_logStatus = LogUpdate 41,@v_scriptName

	exec @v_logStatus = LogInsert 42,@v_scriptName,'Adding new Column EXTMETHODINDEX,ALIGNMENT in WFDataMapTable'
		BEGIN
			BEGIN TRY
				IF NOT EXISTS ( SELECT * FROM sysColumns 
				WHERE 
				id = (SELECT id FROM sysObjects WHERE NAME = 'WFDataMapTable')
				AND  NAME in ('EXTMETHODINDEX','ALIGNMENT')
				)
				BEGIN
					exec  @v_logStatus = LogSkip 42,@v_scriptName
					EXECUTE('ALTER TABLE WFDataMapTable ADD EXTMETHODINDEX INT')
					PRINT 'Table WFDataMapTable altered with new Column EXTMETHODINDEX'
					EXECUTE('ALTER TABLE WFDataMapTable ADD ALIGNMENT NVARCHAR(5)')
					PRINT 'Table WFDataMapTable altered with new Column ALIGNMENT'
				END
			END TRY
			BEGIN CATCH
				exec  @v_logStatus = LogFailed 42,@v_scriptName
				RAISERROR('Block 42 Failed.',16,1)
				RETURN
			END CATCH
		END
	exec @v_logStatus = LogUpdate 42,@v_scriptName

	exec @v_logStatus = LogInsert 43,@v_scriptName,'Adding new Column SortOrder in WFAuthorizeQueueDefTable'
		BEGIN
			BEGIN TRY
				IF NOT EXISTS ( SELECT * FROM sysColumns 
				WHERE 
				id = (SELECT id FROM sysObjects WHERE NAME = 'WFAuthorizeQueueDefTable')
				AND  NAME = 'SortOrder'
				)
				BEGIN
					exec  @v_logStatus = LogSkip 43,@v_scriptName
					EXECUTE('ALTER TABLE WFAuthorizeQueueDefTable ADD SortOrder NVARCHAR(1)')
					PRINT 'Table WFAuthorizeQueueDefTable altered with new Column SortOrder'
					END
			END TRY
			BEGIN CATCH
				exec  @v_logStatus = LogFailed 43,@v_scriptName
				RAISERROR('Block 43 Failed.',16,1)
				RETURN
			END CATCH
		END
	exec @v_logStatus = LogUpdate 43,@v_scriptName

	exec @v_logStatus = LogInsert 44,@v_scriptName,'Adding new Column AliasRule in WFTMSSetVariableMapping'	
		BEGIN
			BEGIN TRY
				IF NOT EXISTS ( SELECT * FROM sysColumns 
				WHERE 
				id = (SELECT id FROM sysObjects WHERE NAME = 'WFTMSSetVariableMapping')
				AND  NAME = 'AliasRule'
				)
				BEGIN
					exec  @v_logStatus = LogSkip 44,@v_scriptName
					EXECUTE('ALTER TABLE WFTMSSetVariableMapping ADD AliasRule	VARCHAR(4000)')
					PRINT 'Table WFTMSSetVariableMapping altered with new Column AliasRule'
				END
			END TRY
			BEGIN CATCH
				exec  @v_logStatus = LogFailed 44,@v_scriptName
				RAISERROR('Block 44 Failed.',16,1)
				RETURN
			END CATCH
		END
	exec @v_logStatus = LogUpdate 44,@v_scriptName

	exec @v_logStatus = LogInsert 45,@v_scriptName,'Creating TABLE WFWebServiceInfoTable'	
		BEGIN
				BEGIN TRY
				IF NOT EXISTS (
					SELECT * FROM SYSObjects 
					WHERE NAME = 'WFWebServiceInfoTable' 
					AND xType = 'U'
				)
				BEGIN
					exec  @v_logStatus = LogSkip 45,@v_scriptName
						EXECUTE(' 
							CREATE TABLE WFWebServiceInfoTable (
							ProcessDefId		INT				NOT NULL, 
							WSDLURLId			INT				NOT NULL,
							WSDLURL				NVARCHAR(2000)		NULL,
							USERId				NVARCHAR(255)		NULL,
							PWD					NVARCHAR(255)		NULL,
							SecurityFlag		NVARCHAR(1)		DEFAULT ''Y''    NULL,
							PRIMARY KEY (ProcessDefId, WSDLURLId)
							)
						')
						PRINT 'Table WFWebServiceInfoTable created successfully.'
				END
			END TRY
			BEGIN CATCH
				exec  @v_logStatus = LogFailed 45,@v_scriptName
				RAISERROR('Block 45 Failed.',16,1)
				RETURN
			END CATCH
		END
	exec @v_logStatus = LogUpdate 45,@v_scriptName

	exec @v_logStatus = LogInsert 46,@v_scriptName,'Creating TABLE WFSystemServicesTable'	
		BEGIN
			BEGIN TRY	
			
				IF NOT EXISTS (
					SELECT * FROM SYSObjects 
					WHERE NAME = 'WFSystemServicesTable' 
					AND xType = 'U'
				)
				BEGIN
					exec  @v_logStatus = LogSkip 46,@v_scriptName
						EXECUTE(' 
							CREATE TABLE WFSystemServicesTable (
							ServiceId  			INT 				IDENTITY (1,1) 		PRIMARY KEY,
							PSID 				INT					NULL, 
							ServiceName  		NVARCHAR(50)		NULL, 
							ServiceType  		NVARCHAR(50)		NULL, 
							ProcessDefId 		INT					NULL, 
							EnableLog  			NVARCHAR(50)		NULL, 
							MonitorStatus 		NVARCHAR(50)		NULL, 
							SleepTime  			INT					NULL, 
							DateFormat  		NVARCHAR(50)		NULL, 
							UserName  			NVARCHAR(50)		NULL, 
							Password  			NVARCHAR(200)		NULL, 
							RegInfo   			NVARCHAR(2000)		NULL
							)
						')
						PRINT 'Table WFSystemServicesTable created successfully.'
				END
			END TRY
			BEGIN CATCH
				exec  @v_logStatus = LogFailed 46,@v_scriptName
				RAISERROR('Block 46 Failed.',16,1)
				RETURN
			END CATCH
		END
	exec @v_logStatus = LogUpdate 46,@v_scriptName

	exec @v_logStatus = LogInsert 47,@v_scriptName,'Creating TABLE WFQueueColorTable'	
		BEGIN
			BEGIN TRY	
				IF NOT EXISTS (
					SELECT * FROM SYSObjects 
					WHERE NAME = 'WFQueueColorTable' 
					AND xType = 'U'
				)
				BEGIN
						exec  @v_logStatus = LogSkip 47,@v_scriptName
						EXECUTE(' 
							CREATE TABLE WFQueueColorTable(
							Id              INT     IDENTITY(1,1)	NOT NULL		PRIMARY KEY,
							QueueId 		INT                     NOT NULL,
							FieldName 		VARCHAR(50)             NULL,
							Operator 		INT                     NULL,
							CompareValue	VARCHAR(255)            NULL,
							Color			VARCHAR(10)             NULL
							)
						')
						PRINT 'Table WFQueueColorTable created successfully.'
				END
			END TRY
			BEGIN CATCH
				exec  @v_logStatus = LogFailed 47,@v_scriptName
				RAISERROR('Block 47 Failed.',16,1)
				RETURN
			END CATCH
		END
	exec @v_logStatus = LogUpdate 47,@v_scriptName

	exec @v_logStatus = LogInsert 48,@v_scriptName,'Creating TABLE WFAuthorizeQueueColorTable'
		BEGIN
			BEGIN TRY	
				IF NOT EXISTS (
					SELECT * FROM SYSObjects 
					WHERE NAME = 'WFAuthorizeQueueColorTable' 
					AND xType = 'U'
				)
				BEGIN
					exec  @v_logStatus = LogSkip 48,@v_scriptName
						EXECUTE(' 
							CREATE TABLE WFAuthorizeQueueColorTable(
							AuthorizationId INT         	NOT NULL,
							ActionId 		INT             NOT NULL,
							FieldName 		VARCHAR(50)     NULL,
							Operator 		INT             NULL,
							CompareValue	VARCHAR(255)	NULL,
							Color			VARCHAR(10)     NULL
							)
						')
						PRINT 'Table WFAuthorizeQueueColorTable created successfully.'
				END
			END TRY
			BEGIN CATCH
				exec  @v_logStatus = LogFailed 48,@v_scriptName
				RAISERROR('Block 48 Failed.',16,1)
				RETURN
			END CATCH
		END
	exec @v_logStatus = LogUpdate 48,@v_scriptName

	exec @v_logStatus = LogInsert 49,@v_scriptName,'Creating TABLE WFUserWebServerInfoTable'
		BEGIN
			BEGIN TRY
				IF NOT EXISTS(SELECT * FROM sysObjects WHERE NAME = 'WFUserWebServerInfoTable')
				BEGIN
					exec  @v_logStatus = LogSkip 49,@v_scriptName
					create table WFUserWebServerInfoTable(
					UserId             INT,
					UserName        nvarchar(26),
					WebServerInfo    nvarchar(26)
					)
					PRINT 'Table WFUserWebServerInfoTable created successfully'
				END
			END TRY
			BEGIN CATCH
				exec  @v_logStatus = LogFailed 49,@v_scriptName
				RAISERROR('Block 339 Failed.',16,1)
				RETURN
			END CATCH
		END
	exec @v_logStatus = LogUpdate 49,@v_scriptName

	exec @v_logStatus = LogInsert 50,@v_scriptName,'Creating TABLE WFTransportDataTable'
		BEGIN
			BEGIN TRY
				IF NOT EXISTS(SELECT * FROM sysObjects WHERE NAME = 'WFTransportDataTable')
				BEGIN
					exec  @v_logStatus = LogSkip 50,@v_scriptName
					CREATE TABLE WFTransportDataTable  (
					TMSLogId			INT				IDENTITY (1,1) PRIMARY KEY,
					RequestId     NVARCHAR(64),
					ActionId			INT				NOT NULL,
					ActionDateTime		DATETIME		NOT NULL,
					ActionComments		NVARCHAR(255),
					UserId              INT             NOT NULL,
					UserName            NVARCHAR(64)    NOT NULL,
					Released			NVARCHAR(1)    Default 'N',
					ReleasedByUserId          INT,
					ReleasedBy       	NVARCHAR(64),
					ReleasedComments	NVARCHAR(255),
					ReleasedDateTime    DATETIME,
					Transported			NVARCHAR(1)     Default 'N',
					TransportedByUserId INT,
					TransportedBy		NVARCHAR(64),
					TransportedDateTime DATETIME,
					ObjectName          NVARCHAR(64),
					ObjectType          NVARCHAR(1),
					ProcessDefId        INT	
					CONSTRAINT uk_TransportDataTable	UNIQUE (RequestId)    
					)
					PRINT 'Table WFTransportDataTable created successfully'
				END
			END TRY
			BEGIN CATCH
				exec  @v_logStatus = LogFailed 50,@v_scriptName
				RAISERROR('Block 50 Failed.',16,1)
				RETURN
			END CATCH
		END
	exec @v_logStatus = LogUpdate 50,@v_scriptName

	exec @v_logStatus = LogInsert 51,@v_scriptName,'Renaming Original TransportDataTable to WFTransportDataTable'	
		BEGIN
			BEGIN TRY
				BEGIN
				IF EXISTS ( SELECT * FROM sysObjects 
				WHERE NAME = 'TransportDataTable'
				)
				BEGIN
					exec  @v_logStatus = LogSkip 51,@v_scriptName
					IF NOT EXISTS ( SELECT id FROM sysObjects 
					WHERE NAME = 'WFTransportDataTable'
					)
						BEGIN
							EXECUTE(' sp_rename TransportDataTable,WFTransportDataTable ')
							PRINT 'Original TransportDataTable renamed to WFTransportDataTable'
						END
					ELSE
						BEGIN
							PRINT 'TransportDataTable and WFTransportDataTable both present,check..'
						END
				END
				END
				END TRY
			BEGIN CATCH
				exec  @v_logStatus = LogFailed 51,@v_scriptName
				RAISERROR('Block 51 Failed.',16,1)
				RETURN
			END CATCH
		
	exec @v_logStatus = LogUpdate 51,@v_scriptName

	exec @v_logStatus = LogInsert 52,@v_scriptName,'Adding new Column UserId,UserName,ReleasedByUserId,ReleasedDateTime,TransportedByUserId,TransportedDateTime in WFTransportDataTable'	
		BEGIN
			BEGIN TRY
				IF NOT EXISTS ( SELECT * FROM sysColumns 
				WHERE 
				id = (SELECT id FROM sysObjects WHERE NAME = 'WFTransportDataTable')
				AND  NAME in ('UserId','UserName','ReleasedByUserId','ReleasedDateTime','TransportedByUserId','TransportedDateTime')
				)
				BEGIN
					exec  @v_logStatus = LogSkip 52
						EXECUTE('ALTER TABLE WFTransportDataTable ADD UserId INT NOT NULL DEFAULT 0')
						PRINT 'Table WFTransportDataTable altered with new Column UserId'
						EXECUTE('ALTER TABLE WFTransportDataTable ADD UserName NVARCHAR(64) NOT NULL DEFAULT ''''')
						PRINT 'Table WFTransportDataTable altered with new Column UserName'
						EXECUTE('ALTER TABLE WFTransportDataTable ADD ReleasedByUserId INT')
						PRINT 'Table WFTransportDataTable altered with new Column ReleasedByUserId'
						EXECUTE('ALTER TABLE WFTransportDataTable ADD ReleasedDateTime DATETIME')
						PRINT 'Table WFTransportDataTable altered with new Column ReleasedDateTime'
						EXECUTE('ALTER TABLE WFTransportDataTable ADD TransportedByUserId INT')
						PRINT 'Table WFTransportDataTable altered with new Column TransportedByUserId'
						EXECUTE('ALTER TABLE WFTransportDataTable ADD TransportedDateTime DATETIME')
						PRINT 'Table WFTransportDataTable altered with new Column TransportedDateTime'
				END
				
			END TRY
			BEGIN CATCH
				exec  @v_logStatus = LogFailed 52,@v_scriptName
				RAISERROR('Block 52 Failed.',16,1)
				RETURN
			END CATCH
		END
	exec @v_logStatus = LogUpdate 52,@v_scriptName

	exec @v_logStatus = LogInsert 53,@v_scriptName,'Renaming Original TransportRegisterationInfo to WFTransportRegisterationInfo'	
		BEGIN
			BEGIN TRY
				BEGIN
					
					IF EXISTS ( SELECT * FROM sysObjects 
					WHERE NAME = 'TransportRegisterationInfo'
					AND xType = 'U'
					)
					BEGIN
						exec  @v_logStatus = LogSkip 53,@v_scriptName
						IF NOT EXISTS ( SELECT id FROM sysObjects 
						WHERE NAME = 'WFTransportRegisterationInfo'
						AND xType = 'U'
						)
							BEGIN
								EXECUTE(' sp_rename TransportRegisterationInfo,WFTransportRegisterationInfo ')
								PRINT 'Original TransportRegisterationInfo renamed to WFTransportRegisterationInfo'
							END
						ELSE
							BEGIN
								PRINT 'TransportRegisterationInfo and WFTransportRegisterationInfo both present,check..'
							END
					END
				
					IF EXISTS ( SELECT * FROM sysColumns 
					WHERE 
					id = (SELECT id FROM sysObjects WHERE NAME = 'WFTransportRegisterationInfo')
					AND  NAME = 'TargetCabinetName'
					)
					BEGIN
						EXECUTE('sp_rename ''WFTransportRegisterationInfo.TargetCabinetName'',''WFTransportRegisterationInfo.TargetEngineName''')
						PRINT 'Table WFTransportRegisterationInfo renamed column to TargetEngineName'
					END
				END	
			END TRY
			BEGIN CATCH
				exec  @v_logStatus = LogFailed 53,@v_scriptName
				RAISERROR('Block 53 Failed.',16,1)
				RETURN
			END CATCH
		END
	exec @v_logStatus = LogUpdate 53,@v_scriptName

	exec @v_logStatus = LogInsert 54,@v_scriptName,'Adding new Column ProcessName in QueueDefTable'	
		BEGIN
			BEGIN TRY
				IF NOT EXISTS ( SELECT * FROM sysColumns 
				WHERE 
				id = (SELECT id FROM sysObjects WHERE NAME = 'QueueDefTable')
				AND  NAME = 'ProcessName'
				)
				BEGIN
					exec  @v_logStatus = LogSkip 54,@v_scriptName
					EXECUTE('ALTER TABLE QueueDefTable ADD ProcessName NVARCHAR(30) DEFAULT NULL')
					PRINT 'Table QueueDefTable altered with new Column ProcessName'
				END
			END TRY
			BEGIN CATCH
				exec  @v_logStatus = LogFailed 54,@v_scriptName
				RAISERROR('Block 54 Failed.',16,1)
				RETURN
			END CATCH
		END
	exec @v_logStatus = LogUpdate 54,@v_scriptName

	exec @v_logStatus = LogInsert 55,@v_scriptName,'Change Datatype to smallint of Type1 in VARALIASTABLE'	
		BEGIN
			BEGIN TRY
				IF NOT EXISTS (select * From information_schema.COLUMNS where table_name='varaliastable' and COLUMN_NAME='type1' and DATA_TYPE = 'SmallInt')
				BEGIN
					exec  @v_logStatus = LogSkip 55,@v_scriptName
					--cant  move to datatype change file  as its refrerence is used below in the file
					EXECUTE('ALTER TABLE VarAliasTable ALTER Column Type1 SmallInt')
					PRINT 'Table VarAliasTable Column Type1 type changed from NVarChar(1) to SmallInt.'
				END
			END TRY
			BEGIN CATCH
				exec  @v_logStatus = LogFailed 55,@v_scriptName
				RAISERROR('Block 55 Failed.',16,1)
				RETURN
			END CATCH
		END
	exec @v_logStatus = LogUpdate 55,@v_scriptName

	exec @v_logStatus = LogInsert 56,@v_scriptName,'Adding new Column ProcessDefId in VarAliasTable'	
		BEGIN
			BEGIN TRY
				IF NOT EXISTS ( SELECT * FROM sysColumns 
				WHERE 
				id = (SELECT id FROM sysObjects WHERE NAME = 'VarAliasTable')
				AND  NAME = 'ProcessDefId'
				)
				BEGIN
					exec  @v_logStatus = LogSkip 56,@v_scriptName
					EXECUTE('ALTER TABLE VarAliasTable ADD ProcessDefId INT  DEFAULT 0')
				
					EXECUTE('UPDATE VarAliasTable SET ProcessDefId=0 WHERE  ProcessDefId  IS NULL')
					PRINT 'Table VarAliasTable altered with new Column ProcessDefId' 
				END
				
			END TRY
			BEGIN CATCH
				exec  @v_logStatus = LogFailed 56,@v_scriptName
				RAISERROR('Block 56 Failed.',16,1)
				RETURN
			END CATCH
		END
	exec @v_logStatus = LogUpdate 56,@v_scriptName

	exec @v_logStatus = LogInsert 57,@v_scriptName,'Adding new Column VariableId1 in VarAliasTable'	
		BEGIN
			BEGIN TRY
			
				IF NOT EXISTS ( SELECT * FROM sysColumns 
				WHERE 
				id = (SELECT id FROM sysObjects WHERE NAME = 'VarAliasTable')
				AND  NAME = 'VariableId1'
				)
				BEGIN
					exec  @v_logStatus = LogSkip 57,@v_scriptName
					EXECUTE('ALTER TABLE VarAliasTable ADD VariableId1 INT DEFAULT 0')
				
					EXECUTE('UPDATE VarAliasTable SET VariableId1=0 WHERE VariableId1 IS NULL');
					PRINT 'Table VarAliasTable altered with new Column VariableId1'
				
					DECLARE alias_cursor CURSOR FAST_FORWARD FOR
						SELECT DISTINCT PARAM1, VariableId, VariableType, B.ProcessdefId FROM VARMAPPINGTABLE  A, VARALIASTABLE B WHERE A.SYSTEMDEFINEDNAME = B.PARAM1 
						OPEN alias_cursor
						FETCH alias_cursor INTO @PARAM1, @v_VariableId, @VariableType, @ProcessDefId
						WHILE(@@FETCH_STATUS = 0) 
						BEGIN 
							IF ((LTRIM(RTRIM(@PARAM1)) = 'ACTIVITYNAME'))
							BEGIN
								SELECT @v_VariableId = 3
							END
							ELSE IF (LTRIM(RTRIM(@PARAM1)) = 'CHECKLISTCOMPLETEFLAG')
							BEGIN
								SELECT @v_VariableId = 7
							END
							ELSE IF (LTRIM(RTRIM(@PARAM1)) = 'CREATEDDATETIME')
							BEGIN
								SELECT @v_VariableId = 18
							END
							ELSE IF (LTRIM(RTRIM(@PARAM1)) = 'ENTRYDATETIME')
							BEGIN
								SELECT @v_VariableId = 10
							END
							ELSE IF (LTRIM(RTRIM(@PARAM1)) = 'EXPECTEDWORKITEMDELAY')
							BEGIN
								SELECT @v_VariableId = 19
							END
							ELSE IF (LTRIM(RTRIM(@PARAM1)) = 'INSTRUMENTSTATUS')
							BEGIN
								SELECT @v_VariableId = 6
							END
							ELSE IF (LTRIM(RTRIM(@PARAM1)) = 'INTRODUCEDBY')
							BEGIN
								SELECT @v_VariableId = 5
							END
							ELSE IF (LTRIM(RTRIM(@PARAM1)) = 'INTRODUCTIONDATETIME')
							BEGIN
							 SELECT @v_VariableId = 13
							END
							ELSE IF (LTRIM(RTRIM(@PARAM1)) = 'LOCKEDBYNAME')
							BEGIN
								SELECT @v_VariableId = 4
							END
							ELSE IF (LTRIM(RTRIM(@PARAM1)) = 'LOCKEDTIME')
							BEGIN
								SELECT @v_VariableId = 12
							END
							ELSE IF (LTRIM(RTRIM(@PARAM1)) = 'LOCKSTATUS')
							BEGIN
								SELECT @v_VariableId = 8
							END
							ELSE IF (LTRIM(RTRIM(@PARAM1)) = 'PRIORITYLEVEL')
							BEGIN
							 SELECT @v_VariableId = 1
							END
							ELSE IF (LTRIM(RTRIM(@PARAM1)) = 'QUEUENAME') 
							BEGIN
								SELECT @v_VariableId = 14
							END
							ELSE IF (LTRIM(RTRIM(@PARAM1)) = 'STATUS') 
							BEGIN
								SELECT @v_VariableId = 17
							END
							ELSE IF (LTRIM(RTRIM(@PARAM1)) = 'VALIDTILL') 
							BEGIN
								SELECT @v_VariableId = 11
							END
							ELSE
							BEGIN
								SELECT @v_VariableId = @v_VariableId + 100
							END
							BEGIN TRANSACTION trans
								EXECUTE(' Update VarAliasTable Set VariableId1 = ' + @v_VariableId + ' , Type1 = ' + @VariableType + ' Where Param1 = ' + @quoteChar + @PARAM1 + @quoteChar + ' And ProcessdefId = ' + @ProcessDefId )
							COMMIT TRANSACTION trans

							FETCH NEXT FROM alias_cursor INTO @PARAM1, @v_VariableId, @VariableType, @ProcessDefId
						END
						CLOSE alias_cursor
					DEALLOCATE alias_cursor
				END
			END TRY
			BEGIN CATCH
				exec  @v_logStatus = LogFailed 57,@v_scriptName
				RAISERROR('Block 57 Failed.',16,1)
				RETURN
			END CATCH
		END
	exec @v_logStatus = LogUpdate 57,@v_scriptName

	exec @v_logStatus = LogInsert 58,@v_scriptName,'Adding new Column SORTINGCOLUMN in EXTDBCONFTABLE'	
		BEGIN
			BEGIN TRY
			
				IF NOT EXISTS ( SELECT * FROM sysColumns 
				WHERE 
				id = (SELECT id FROM sysObjects WHERE NAME = 'EXTDBCONFTABLE')
				AND  NAME = 'SORTINGCOLUMN'
				)
				BEGIN
					exec  @v_logStatus = LogSkip 58,@v_scriptName
					EXECUTE('ALTER TABLE EXTDBCONFTABLE ADD SORTINGCOLUMN NVARCHAR(30)')
					PRINT 'Table EXTDBCONFTABLE altered with new Column SORTINGCOLUMN'
				END
			END TRY
			BEGIN CATCH
				exec  @v_logStatus = LogFailed 58,@v_scriptName
				RAISERROR('Block 58 Failed.',16,1)
				RETURN
			END CATCH
		END
	exec @v_logStatus = LogUpdate 58,@v_scriptName

	exec @v_logStatus = LogInsert 59,@v_scriptName,'Adding new Column INSERTIONORDERID in EXTDBCONFTABLE'	
		BEGIN
			BEGIN TRY	
				BEGIN
					exec  @v_logStatus = LogSkip 59,@v_scriptName
					DECLARE v_PrcCursor CURSOR FAST_FORWARD FOR
					select Processdefid,ExtObjId from varmappingtable where extobjid>0 and unbounded='Y'
					OPEN v_PrcCursor
					FETCH   v_PrcCursor 
					INTO    @ProcessDefId,@ExtObjID
					WHILE (@@FETCH_STATUS  <> -1 )
					BEGIN
						select @TableName = NULL;
						select @TableName=TableName from extdbconftable where processdefid=@ProcessDefId and extobjid=@ExtObjID;
						IF(@TableName IS NOT NULL)
						BEGIN
							IF (EXISTS (SELECT 1 FROM SYSOBJECTS WHERE NAME = @TABLENAME) AND NOT EXISTS ( SELECT * FROM sysColumns 
							WHERE 
							id = (SELECT id FROM sysObjects WHERE NAME = @TableName)
							AND  NAME = 'INSERTIONORDERID')
							)
							BEGIN
								EXECUTE('ALTER TABLE '+@TableName+' ADD INSERTIONORDERID INT IDENTITY (1, 1)');
								EXECUTE('UPDATE extdbconftable set SORTINGCOLUMN=''INSERTIONORDERID'' where processdefid='+@ProcessDefId+' and extobjid='+@ExtObjID);
								PRINT 'Table altered with new Column INSERTIONORDERID'
							END
						END
						FETCH NEXT FROM v_PrcCursor INTO @ProcessDefId,@ExtObjID
					END
					CLOSE v_PrcCursor
					DEALLOCATE v_PrcCursor
					END
					BEGIN
					DECLARE v_PrcCursor CURSOR FAST_FORWARD FOR
					select d.Processdefid, d.extobjid,d.mappedobjectname from varmappingtable a, wftypedesctable b, wftypedeftable c, wfudtvarmappingtable d where a.processdefid= b.processdefid and b.processdefid=c.processdefid and c.processdefid= d.processdefid
				and c.typeid=b.typeid and c.unbounded='Y' and d.typeid= c.parenttypeid and d.mappedobjecttype='T' and d.typefieldid= c.typefieldid
				and a.variableid = d.variableid
					OPEN v_PrcCursor
					FETCH   v_PrcCursor 
					INTO    @ProcessDefId,@ExtObjID,@TableName
					WHILE (@@FETCH_STATUS  <> -1 )
					BEGIN		
						BEGIN
							IF (EXISTS (SELECT 1 FROM SYSOBJECTS WHERE NAME = @TABLENAME) AND NOT EXISTS ( SELECT * FROM sysColumns 
							WHERE 
							id = (SELECT id FROM sysObjects WHERE NAME = @TableName)
							AND  NAME = 'INSERTIONORDERID')
							)
							BEGIN
								EXECUTE('ALTER TABLE '+@TableName+' ADD INSERTIONORDERID INT IDENTITY (1, 1)')
								PRINT 'Table altered with new Column INSERTIONORDERID'
							END
						END
						FETCH NEXT FROM v_PrcCursor INTO @ProcessDefId,@ExtObjID,@TableName
					END
					CLOSE v_PrcCursor
					DEALLOCATE v_PrcCursor
				END
			END TRY
			BEGIN CATCH
				exec  @v_logStatus = LogFailed 59,@v_scriptName
				IF CURSOR_STATUS('global','v_PrcCursor') >= -1
				BEGIN
					IF CURSOR_STATUS('global','v_PrcCursor') > -1
					BEGIN
						CLOSE v_PrcCursor
					END
					DEALLOCATE v_PrcCursor
				END
				RAISERROR('Block 59 Failed.',16,1)
				RETURN
			END CATCH
		END
	exec @v_logStatus = LogUpdate 59,@v_scriptName

	exec @v_logStatus = LogInsert 60,@v_scriptName,'Adding new Column ConfigurationID, RFCHostName and ConfigurationName in WFSAPConnectTable'
		BEGIN
			BEGIN TRY	
				IF EXISTS(SELECT * FROM sysObjects WHERE NAME = 'WFSAPConnectTable')
				BEGIN
					
					IF NOT EXISTS ( SELECT * FROM sysColumns WHERE 
					id = (SELECT id FROM sysObjects WHERE NAME = 'WFSAPConnectTable')
					AND  NAME in ('ConfigurationID','RFCHostName','ConfigurationName'))
					BEGIN
					exec  @v_logStatus = LogSkip 60,@v_scriptName
					 EXECUTE('ALTER TABLE WFSAPConnectTable ADD ConfigurationID Integer  DEFAULT 0, RFCHostName nvarchar(64), ConfigurationName nvarchar(64)')
				 
					 EXECUTE ('UPDATE WFSAPConnectTable SET ConfigurationID = 0 WHERE ConfigurationID IS NULL')
					 PRINT 'Table WFSAPConnectTable altered with new Column ConfigurationID, RFCHostName and ConfigurationName'
					END
				END
			END TRY
			BEGIN CATCH
				exec  @v_logStatus = LogFailed 60,@v_scriptName
				RAISERROR('Block 60 Failed.',16,1)
				RETURN
			END CATCH
		END
	exec @v_logStatus = LogUpdate 60,@v_scriptName

	exec @v_logStatus = LogInsert 61,@v_scriptName,'First Dropping then Creating constraint PRIMARY KEY (ProcessDefId, ConfigurationID) in WFSAPConnectTable '	
		BEGIN
			BEGIN TRY
				BEGIN
					
					SELECT @SAPconstrnName =  constraint_name 
					FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS 
					where table_name = 'WFSAPConnectTable'    
					IF (@SAPconstrnName IS NOT NULL AND (LEN(@SAPconstrnName) > 0))
					BEGIN
						EXECUTE ('alter table WFSAPConnectTable drop constraint ' + @SAPconstrnName)  
						PRINT 'Table WFSAPConnectTable altered, constraint on ProcessDefID dropped.'
					END
					--cant move to datatype change file as refrence may be below in the file
					EXECUTE('ALTER TABLE WFSAPConnectTable ALTER COLUMN ConfigurationID INT NOT NULL')
					EXECUTE('ALTER TABLE WFSAPConnectTable ADD CONSTRAINT pk_WFSAPConnect PRIMARY KEY (ProcessDefId, ConfigurationID)')
					PRINT 'Table WFSAPConnectTable altered, constraint on ProcessDefID and ConfigurationID created.'
				END
			END TRY
			BEGIN CATCH
				exec  @v_logStatus = LogFailed 61,@v_scriptName
				RAISERROR('Block 61 Failed.',16,1)
				RETURN
			END CATCH
		END
	exec @v_logStatus = LogUpdate 61,@v_scriptName

	exec @v_logStatus = LogInsert 62,@v_scriptName,'Adding new Column ConfigurationID in WFSAPGUIAssocTable'	
		BEGIN
			BEGIN TRY 

				IF EXISTS(SELECT * FROM sysObjects WHERE NAME = 'WFSAPGUIAssocTable')
				BEGIN
				IF NOT EXISTS ( SELECT * FROM sysColumns WHERE 
				id = (SELECT id FROM sysObjects WHERE NAME = 'WFSAPGUIAssocTable')
				AND  NAME in ('ConfigurationID')		)
				BEGIN
					exec  @v_logStatus = LogSkip 62,@v_scriptName
					EXECUTE('ALTER TABLE WFSAPGUIAssocTable ADD ConfigurationID Integer')
					PRINT 'Table WFSAPGUIAssocTable altered with new Column ConfigurationID'
				END
				END
			END TRY
			BEGIN CATCH
				exec  @v_logStatus = LogFailed 62,@v_scriptName
				RAISERROR('Block 62 Failed.',16,1)
				RETURN
			END CATCH
		END
	exec @v_logStatus = LogUpdate 62,@v_scriptName

	exec @v_logStatus = LogInsert 63,@v_scriptName,'Adding new Column ConfigurationID in WFSAPadapterAssocTable'	
		BEGIN
			BEGIN TRY
			
				IF EXISTS(SELECT * FROM sysObjects WHERE NAME = 'WFSAPadapterAssocTable')
				BEGIN
				
					IF NOT EXISTS ( SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'WFSAPadapterAssocTable')
					AND  NAME in ('ConfigurationID'))
					BEGIN
						exec  @v_logStatus = LogSkip 63,@v_scriptName
						EXECUTE('ALTER TABLE WFSAPadapterAssocTable ADD ConfigurationID Integer')
						PRINT 'Table WFSAPadapterAssocTable altered with new Column ConfigurationID'
					END
				END
			END TRY
			BEGIN CATCH
				exec  @v_logStatus = LogFailed 63,@v_scriptName
				RAISERROR('Block 63 Failed.',16,1)
				RETURN
			END CATCH
		END
	exec @v_logStatus = LogUpdate 63,@v_scriptName

	exec @v_logStatus = LogInsert 64,@v_scriptName,'Adding new Column ConfigurationID in ExtMethodDefTable'	
		BEGIN
			BEGIN TRY
				IF EXISTS(SELECT * FROM sysObjects WHERE NAME = 'ExtMethodDefTable')
				BEGIN
					
					IF NOT EXISTS ( SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'ExtMethodDefTable')
					AND  NAME in ('ConfigurationID'))
					BEGIN
						exec  @v_logStatus = LogSkip 64,@v_scriptName
						EXECUTE('ALTER TABLE ExtMethodDefTable ADD ConfigurationID Integer')
						PRINT 'Table ExtMethodDefTable altered with new Column ConfigurationID'
					END
				END
			END TRY
			BEGIN CATCH
				exec  @v_logStatus = LogFailed 64,@v_scriptName
				RAISERROR('Block 64 Failed.',16,1)
				RETURN
			END CATCH
		END
	exec @v_logStatus = LogUpdate 64,@v_scriptName

	exec @v_logStatus = LogInsert 65,@v_scriptName,'Updating WFSAPConnectTable,Inserting in WFCabVersionTable for 9.0_SAP_CONFIGURATION'	
		BEGIN
			BEGIN TRY
				IF NOT EXISTS(SELECT * FROM WFCabVersionTable WHERE CabVersion = '9.0_SAP_CONFIGURATION')
				BEGIN
					exec  @v_logStatus = LogSkip 65,@v_scriptName
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
					EXECUTE('INSERT INTO WFCabVersionTable(cabVersion, creationDate, lastModified, Remarks, Status) VALUES (N''9.0_SAP_CONFIGURATION'', GETDATE(), GETDATE(), N''OmniFlow 9.0'', N''Y'')')
				END
			END TRY
			BEGIN CATCH
				exec  @v_logStatus = LogFailed 65,@v_scriptName
				RAISERROR('Block 65 Failed.',16,1)
				RETURN
			END CATCH
		END
	exec @v_logStatus = LogUpdate 65,@v_scriptName

	exec @v_logStatus = LogInsert 66,@v_scriptName,'Creating Table WFCreateChildWITable,Inserting data INTO ExtMethodDefTable'	
		BEGIN
			BEGIN TRY
				exec  @v_logStatus = LogSkip 66,@v_scriptName
				IF NOT EXISTS ( SELECT * FROM sysObjects WHERE NAME = 'WFCreateChildWITable')
				BEGIN
					
					EXECUTE(' 
						Create Table WFCreateChildWITable(
							ProcessDefId		INT NOT NULL,
							TriggerId			INT NOT NULL,
							WorkstepName		NVARCHAR(255), 
							Type		NVARCHAR(1), 
							GenerateSameParent	NVARCHAR(1), 
							VariableId			INT, 
							VarFieldId			INT
							PRIMARY KEY (Processdefid , TriggerId)
						)	
					')
					PRINT 'Table WFCreateChildWITable created successfully.'
				END
			
				BEGIN
				DECLARE cursor1 CURSOR STATIC FOR
				SELECT ProcessDefId FROM ProcessDefTable
				OPEN cursor1
				FETCH NEXT FROM cursor1 INTO @ProcessDefId
				WHILE(@@FETCH_STATUS = 0) 
				BEGIN
					IF NOT EXISTS (
						SELECT ExtMethodIndex FROM EXTMETHODDEFTABLE WHERE processdefid=@ProcessDefId AND ExtMethodIndex=34
					)
					BEGIN
						BEGIN TRANSACTION trans
							EXECUTE(' INSERT INTO ExtMethodDefTable VALUES(' + @ProcessDefId + ', 34 , N''System'', N''S'', N''deleteChildWorkitem'' , NULL, NULL, 3 , NULL, NULL)' )
						COMMIT TRANSACTION trans
					END

					FETCH NEXT FROM cursor1 INTO @ProcessDefId
				END
				CLOSE cursor1
				DEALLOCATE cursor1		
				END	
				BEGIN
				DECLARE v_PrcCursor CURSOR FAST_FORWARD FOR
				
				Select TABLENAME from WFEXPORTTABLE

				OPEN v_PrcCursor
				FETCH   v_PrcCursor 
				INTO    @TableName

				WHILE (@@FETCH_STATUS  <> -1 )
				BEGIN
					IF EXISTS(SELECT id FROM sysObjects WHERE NAME = @TableName)
					BEGIN
						SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = @TableName )
						AND  NAME = 'SequenceNumber'
						SELECT @v_rowcount = @@ROWCOUNT	 
						IF (@v_rowcount <= 0)
						BEGIN
							Select @querystr = 'alter table ' + @TableName + ' add SequenceNumber NVarchar(100)'
							execute( @querystr )
						END
					END
					FETCH NEXT FROM v_PrcCursor INTO @TableName
				END
				CLOSE v_PrcCursor
				DEALLOCATE v_PrcCursor
				END
			END TRY
			BEGIN CATCH
				exec  @v_logStatus = LogFailed 66,@v_scriptName
				IF CURSOR_STATUS('global','v_PrcCursor') >= -1
				BEGIN
					IF CURSOR_STATUS('global','v_PrcCursor') > -1
					BEGIN
						CLOSE v_PrcCursor
					END
					DEALLOCATE v_PrcCursor
				END
				RAISERROR('Block 66 Failed.',16,1)
				RETURN
			END CATCH
		END
	exec @v_logStatus = LogUpdate 66,@v_scriptName

	exec @v_logStatus = LogInsert 67,@v_scriptName,'Adding new Column FieldSeperator,FileType,FilePath,HeaderString,FooterString,SleepTime,MaskedValue in WFExportTable'	
		BEGIN
			BEGIN TRY
				IF EXISTS(SELECT * FROM sysObjects WHERE NAME = 'WFExportTable')
				BEGIN
				
				IF NOT EXISTS ( SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'WFExportTable')
				AND  NAME in ('FieldSeperator','FileType','FilePath','HeaderString','FooterString','SleepTime','MaskedValue'))
				BEGIN
					exec  @v_logStatus = LogSkip 67,@v_scriptName
					EXECUTE('ALTER TABLE WFExportTable ADD FieldSeperator NVARCHAR(5), FileType INT, FilePath NVARCHAR(255), HeaderString NVARCHAR(255), FooterString NVARCHAR(255), SleepTime INT, MaskedValue NVARCHAR(255)')
					PRINT 'Table WFExportTable altered with new Columns FieldSeperator, FileType, FilePath, HeaderString, FooterString, SleepTime, MaskedValue'
				END
				END
			END TRY
			BEGIN CATCH
				exec  @v_logStatus = LogFailed 67,@v_scriptName
				RAISERROR('Block 67 Failed.',16,1)
				RETURN
			END CATCH
		END
	exec @v_logStatus = LogUpdate 67,@v_scriptName

	exec @v_logStatus = LogInsert 68,@v_scriptName,'Adding new Column ExportAllDocs in WFDataMapTable'	
		BEGIN
			BEGIN TRY
				IF EXISTS(SELECT * FROM sysObjects WHERE NAME = 'WFDataMapTable')
				BEGIN
				
				IF NOT EXISTS ( SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'WFDataMapTable')
				AND  NAME = 'ExportAllDocs')
				BEGIN
					exec  @v_logStatus = LogSkip 68,@v_scriptName
					EXECUTE('ALTER TABLE WFDataMapTable ADD ExportAllDocs NVARCHAR(2)')
					PRINT 'Table WFDataMapTable altered with new Columns ExportAllDocs'
				END
				END
			END TRY
			BEGIN CATCH
				exec  @v_logStatus = LogFailed 68,@v_scriptName
				RAISERROR('Block 68 Failed.',16,1)
				RETURN
			END CATCH
		END
	exec @v_logStatus = LogUpdate 68,@v_scriptName

	exec @v_logStatus = LogInsert 69,@v_scriptName,'Adding new Column ArchiveDataClassName in ArchiveTable'	
		BEGIN
			BEGIN TRY
				IF EXISTS(SELECT * FROM sysObjects WHERE NAME = 'ArchiveTable')
				BEGIN
				
				IF NOT EXISTS ( SELECT * FROM sysColumns WHERE NAME = 'ArchiveDataClassName')
				BEGIN
					exec  @v_logStatus = LogSkip 69,@v_scriptName
					EXECUTE('ALTER TABLE ArchiveTable ADD ArchiveDataClassName NVARCHAR(255)')
					PRINT 'Table ArchiveTable altered with new Column ArchiveDataClassName'
				END
				END
			END TRY
			BEGIN CATCH
				exec  @v_logStatus = LogFailed 69,@v_scriptName
				RAISERROR('Block 69 Failed.',16,1)
				RETURN
			END CATCH
		END
	exec @v_logStatus = LogUpdate 69,@v_scriptName

	exec @v_logStatus = LogInsert 70,@v_scriptName,'Adding new Column DataFieldType in ARCHIVEDATAMAPTABLE'	
		BEGIN
			BEGIN TRY
				IF EXISTS(SELECT * FROM sysObjects WHERE NAME = 'ARCHIVEDATAMAPTABLE')
				BEGIN
				
				IF NOT EXISTS (SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'ARCHIVEDATAMAPTABLE')
				AND  NAME = 'DataFieldType')
				BEGIN
					exec  @v_logStatus = LogSkip 70,@v_scriptName
					EXECUTE('ALTER TABLE ARCHIVEDATAMAPTABLE ADD DataFieldType INTEGER')
					PRINT 'Table ARCHIVEDATAMAPTABLE altered with new Column DataFieldType'
				END
				END
			END TRY
			BEGIN CATCH
				exec  @v_logStatus = LogFailed 70,@v_scriptName
				RAISERROR('Block 70 Failed.',16,1)
				RETURN
			END CATCH
		END
	exec @v_logStatus = LogUpdate 70,@v_scriptName

	exec @v_logStatus = LogInsert 71,@v_scriptName,'Adding new Column format in TEMPLATEDEFINITIONTABLE'	
		BEGIN
			BEGIN TRY
				IF EXISTS(SELECT * FROM sysObjects WHERE NAME = 'TEMPLATEDEFINITIONTABLE')
				BEGIN
					
					IF NOT EXISTS (SELECT * FROM sysColumns WHERE NAME = 'format')
					BEGIN
						exec  @v_logStatus = LogSkip 71,@v_scriptName
						EXECUTE('ALTER TABLE TEMPLATEDEFINITIONTABLE ADD format nvarchar(255)')
						PRINT 'Table TEMPLATEDEFINITIONTABLE altered with new Column format'
					END
				END
			END TRY
			BEGIN CATCH
				exec  @v_logStatus = LogFailed 71,@v_scriptName
				RAISERROR('Block 71 Failed.',16,1)
				RETURN
			END CATCH
		END
	exec @v_logStatus = LogUpdate 71,@v_scriptName

	exec @v_logStatus = LogInsert 72,@v_scriptName,'Creating TABLE WFUnderlyingDMS'	
		BEGIN
			BEGIN TRY
			
				IF NOT EXISTS (
					SELECT * FROM SYSObjects 
					WHERE NAME = 'WFUnderlyingDMS' 
					AND xType = 'U'
				)
				BEGIN
				exec  @v_logStatus = LogSkip 72,@v_scriptName
					EXECUTE(' 
						CREATE TABLE WFUnderlyingDMS (
							DMSType		INT				NOT NULL,
							DMSName		NVARCHAR(255)	NULL
						)
					')
					PRINT 'Table WFUnderlyingDMS created successfully.'
				END
			END TRY
			BEGIN CATCH
				exec  @v_logStatus = LogFailed 72,@v_scriptName
				RAISERROR('Block 72 Failed.',16,1)
				RETURN
			END CATCH
		END
	exec @v_logStatus = LogUpdate 72,@v_scriptName

	exec @v_logStatus = LogInsert 73,@v_scriptName,'Creating TABLE WFSharePointInfo'	
		BEGIN
			BEGIN TRY
				
				IF NOT EXISTS (
					SELECT * FROM SYSObjects 
					WHERE NAME = 'WFSharePointInfo' 
					AND xType = 'U'
				)
				BEGIN
				exec  @v_logStatus = LogSkip 73,@v_scriptName
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
			END TRY
			BEGIN CATCH
				exec  @v_logStatus = LogFailed 73,@v_scriptName
				RAISERROR('Block 73 Failed.',16,1)
				RETURN
			END CATCH
		END
	exec @v_logStatus = LogUpdate 73,@v_scriptName

	exec @v_logStatus = LogInsert 74,@v_scriptName,'Creating TABLE WFDMSLibrary'	
		BEGIN
			BEGIN TRY	
				IF NOT EXISTS (
					SELECT * FROM SYSObjects 
					WHERE NAME = 'WFDMSLibrary' 
					AND xType = 'U'
				)
				BEGIN
				exec  @v_logStatus = LogSkip 74,@v_scriptName
					EXECUTE(' 
						CREATE TABLE WFDMSLibrary (
							LibraryId			INT				NOT NULL 	IDENTITY(1,1) 	PRIMARY KEY,
							URL			NVARCHAR(255)	NULL,
							DocumentLibrary		NVARCHAR(255)	NULL
						)
					')
					PRINT 'Table WFDMSLibrary created successfully.'
				END
			END TRY
			BEGIN CATCH
				exec  @v_logStatus = LogFailed 74,@v_scriptName
				RAISERROR('Block 74 Failed.',16,1)
				RETURN
			END CATCH
		END
	exec @v_logStatus = LogUpdate 74,@v_scriptName

	exec @v_logStatus = LogInsert 75,@v_scriptName,'Creating TABLE WFProcessSharePointAssoc'	
		BEGIN
			BEGIN TRY
				IF NOT EXISTS (
					SELECT * FROM SYSObjects 
					WHERE NAME = 'WFProcessSharePointAssoc' 
					AND xType = 'U'
				)
				BEGIN
				exec  @v_logStatus = LogSkip 75,@v_scriptName
					EXECUTE(' 
						CREATE TABLE WFProcessSharePointAssoc (
							ProcessDefId			INT		NOT NULL,
							LibraryId				INT		NULL,
							PRIMARY KEY (ProcessDefId)
						)
					')
					PRINT 'Table WFProcessSharePointAssoc created successfully.'
				END
			END TRY
			BEGIN CATCH
				exec  @v_logStatus = LogFailed 75,@v_scriptName
				RAISERROR('Block 75 Failed.',16,1)
				RETURN
			END CATCH
		END
	exec @v_logStatus = LogUpdate 75,@v_scriptName

	exec @v_logStatus = LogInsert 76,@v_scriptName,'Creating TABLE WFArchiveInSharePoint'	
		BEGIN
			BEGIN TRY
				IF NOT EXISTS (
					SELECT * FROM SYSObjects 
					WHERE NAME = 'WFArchiveInSharePoint' 
					AND xType = 'U'
				)
				BEGIN
				exec  @v_logStatus = LogSkip 76,@v_scriptName
					EXECUTE(' 
						CREATE TABLE WFArchiveInSharePoint (
							ProcessDefId			INT				NULL,
							ActivityID				INT				NULL,
							URL					 	NVARCHAR(255)	NULL,		
							SiteName				NVARCHAR(255)	NULL,
							DocumentLibrary			NVARCHAR(255)	NULL,
							FolderName				NVARCHAR(255)	NULL,
							ServiceURL 				NVARCHAR(255) 	NULL
						)
					')
					EXECUTE('Insert into QueueDefTable (QueueName, QueueType, Comments, OrderBy, SortOrder)
				values (''SystemSharepointQueue'', ''S'', ''System generated common Sharepoint Queue'', 10, ''A'')')
					PRINT 'Table WFArchiveInSharePoint created successfully.'
				END	
			END TRY
			BEGIN CATCH
				exec  @v_logStatus = LogFailed 76,@v_scriptName
				RAISERROR('Block 76 Failed.',16,1)
				RETURN
			END CATCH
		END
	exec @v_logStatus = LogUpdate 76,@v_scriptName

	exec @v_logStatus = LogInsert 77,@v_scriptName,'Creating TABLE WFSharePointDataMapTable'	
		BEGIN
			BEGIN TRY
				IF NOT EXISTS (
					SELECT * FROM SYSObjects 
					WHERE NAME = 'WFSharePointDataMapTable' 
					AND xType = 'U'
				)
				BEGIN
				exec  @v_logStatus = LogSkip 77,@v_scriptName
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
			END TRY
			BEGIN CATCH
				exec  @v_logStatus = LogFailed 77,@v_scriptName
				RAISERROR('Block 77 Failed.',16,1)
				RETURN
			END CATCH
		END
	exec @v_logStatus = LogUpdate 77,@v_scriptName

	exec @v_logStatus = LogInsert 78,@v_scriptName,'Creating TABLE WFSharePointDocAssocTable'	
		BEGIN
			BEGIN TRY
				IF NOT EXISTS (
					SELECT * FROM SYSObjects 
					WHERE NAME = 'WFSharePointDocAssocTable' 
					AND xType = 'U'
				)
				BEGIN
				exec  @v_logStatus = LogSkip 78,@v_scriptName
					EXECUTE(' 
						CREATE TABLE WFSharePointDocAssocTable (
							ProcessDefId			INT				NULL,
							ActivityID				INT				NULL,
							DocTypeID				INT				NULL,
							AssocFieldName			NVARCHAR(255)	NULL
						)
					')
					PRINT 'Table WFSharePointDocAssocTable created successfully.'
				END				
				
			END TRY
			BEGIN CATCH
				exec  @v_logStatus = LogFailed 78,@v_scriptName
				RAISERROR('Block 78 Failed.',16,1)
				RETURN
			END CATCH
		END
	exec @v_logStatus = LogUpdate 78,@v_scriptName

	exec @v_logStatus = LogInsert 79,@v_scriptName,'Adding  new Column DomainName in WFDMSLibrary'	
		BEGIN
			BEGIN TRY
			
				IF NOT EXISTS ( SELECT * FROM sysColumns 
				WHERE 
				id = (SELECT id FROM sysObjects WHERE NAME = 'WFDMSLibrary')
				AND  NAME = 'DomainName'
				)
				BEGIN
					exec  @v_logStatus = LogSkip 79,@v_scriptName
					EXECUTE('ALTER TABLE WFDMSLibrary Add DomainName NVARCHAR(64)')
					PRINT 'Table WFDMSLibrary altered with new Column DomainName'
				
				END
			END TRY
			BEGIN CATCH
				exec  @v_logStatus = LogFailed 79,@v_scriptName
				RAISERROR('Block 79 Failed.',16,1)
				RETURN
			END CATCH
		END
	exec @v_logStatus = LogUpdate 79,@v_scriptName

	exec @v_logStatus = LogInsert 80,@v_scriptName,'Adding  new Column DomainName in WFArchiveInSharePoint'
		BEGIN
			BEGIN TRY
				IF NOT EXISTS ( SELECT * FROM sysColumns 
				WHERE 
				id = (SELECT id FROM sysObjects WHERE NAME = 'WFArchiveInSharePoint')
				AND  NAME = 'DomainName'
				)
				BEGIN
					exec  @v_logStatus = LogSkip 80,@v_scriptName
					EXECUTE('ALTER TABLE WFArchiveInSharePoint Add DomainName NVARCHAR(64)')
					PRINT 'Table WFArchiveInSharePoint altered with new Column DomainName'
				END
			END TRY
			BEGIN CATCH
				exec  @v_logStatus = LogFailed 80,@v_scriptName
				RAISERROR('Block 80 Failed.',16,1)
				RETURN
			END CATCH
		END
	exec @v_logStatus = LogUpdate 80,@v_scriptName

	exec @v_logStatus = LogInsert 81,@v_scriptName,'Adding  new Column mailBCC in WFMAILQUEUETABLE'
		BEGIN
			BEGIN TRY	
				IF NOT EXISTS ( SELECT * FROM sysColumns 
				WHERE 
				id = (SELECT id FROM sysObjects WHERE NAME = 'WFMAILQUEUETABLE')
				AND  NAME = 'mailBCC'
				)
				BEGIN
				exec  @v_logStatus = LogSkip 81,@v_scriptName
				EXECUTE('ALTER TABLE WFMAILQUEUETABLE ADD mailBCC NVARCHAR(512)')
				PRINT 'Table WFMAILQUEUETABLE altered with new Column mailBCC'
				END	
			END TRY
			BEGIN CATCH
				exec  @v_logStatus = LogFailed 81,@v_scriptName
				RAISERROR('Block 81 Failed.',16,1)
				RETURN
			END CATCH
		END
	exec @v_logStatus = LogUpdate 81,@v_scriptName

	exec @v_logStatus = LogInsert 82,@v_scriptName,'Adding  new Column FolderName in WFSharePointDocAssocTable'
		BEGIN
			BEGIN TRY
				IF NOT EXISTS ( SELECT * FROM sysColumns 
				WHERE 
				id = (SELECT id FROM sysObjects WHERE NAME = 'WFSharePointDocAssocTable')
				AND  NAME = 'FolderName'
				)
				BEGIN
					exec  @v_logStatus = LogSkip 82,@v_scriptName
					EXECUTE('ALTER TABLE WFSharePointDocAssocTable Add FolderName NVARCHAR(255)')
						PRINT 'Table WFSharePointDocAssocTable altered with new Column FolderName'
					END
			END TRY
			BEGIN CATCH
				exec  @v_logStatus = LogFailed 82,@v_scriptName
				RAISERROR('Block 82 Failed.',16,1)
				RETURN
			END CATCH
		END
	exec @v_logStatus = LogUpdate 82,@v_scriptName

	exec @v_logStatus = LogInsert 83,@v_scriptName,'Adding  new Column DiffFolderLoc, SameAssignRights in WFArchiveInSharePoint'	
		BEGIN
			BEGIN TRY
				IF NOT EXISTS ( SELECT * FROM sysColumns 
				WHERE 
				id = (SELECT id FROM sysObjects WHERE NAME = 'WFArchiveInSharePoint')
				AND  NAME = 'DiffFolderLoc'
				)
				BEGIN
				exec  @v_logStatus = LogSkip 83,@v_scriptName
					EXECUTE('ALTER TABLE WFArchiveInSharePoint Add DiffFolderLoc NVARCHAR(2), SameAssignRights NVARCHAR(2)')
					PRINT 'Table WFArchiveInSharePoint altered with new Column DiffFolderLoc, SameAssignRights'		
				END
			END TRY
			BEGIN CATCH
				exec  @v_logStatus = LogFailed 83,@v_scriptName
				RAISERROR('Block 83 Failed.',16,1)
				RETURN
			END CATCH
		END
	exec @v_logStatus = LogUpdate 83,@v_scriptName

	exec @v_logStatus = LogInsert 84,@v_scriptName,'Creating TABLE WFLASTREMINDERTABLE'	
		BEGIN
			BEGIN TRY
				IF NOT EXISTS ( SELECT * FROM SYSObjects WHERE NAME = 'WFLASTREMINDERTABLE' AND xType = 'U')
				BEGIN
					exec  @v_logStatus = LogSkip 84,@v_scriptName
					EXECUTE('CREATE TABLE WFLASTREMINDERTABLE (
								USERID 				INT NOT NULL,
								LASTREMINDERTIME	DATETIME 
							)')
					PRINT 'Table WFLASTREMINDERTABLE created successfully.'
				END
			END TRY
			BEGIN CATCH
				exec  @v_logStatus = LogFailed 84,@v_scriptName
				RAISERROR('Block 84 Failed.',16,1)
				RETURN
			END CATCH
		END
	exec @v_logStatus = LogUpdate 84,@v_scriptName

	exec @v_logStatus = LogInsert 85,@v_scriptName,'Adding  new Column isAppletView in WFFORM_TABLE'
		BEGIN
			BEGIN TRY
				IF NOT EXISTS ( SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'WFFORM_TABLE') AND  NAME = 'isAppletView')
				BEGIN
					exec  @v_logStatus = LogSkip 85,@v_scriptName
					EXECUTE('ALTER TABLE WFFORM_TABLE Add isAppletView NVARCHAR(2)')
					PRINT 'Table WFFORM_TABLE altered with new Column isAppletView'
				END
			END TRY
			BEGIN CATCH
				exec  @v_logStatus = LogFailed 85,@v_scriptName
				RAISERROR('Block 85 Failed.',16,1)
				RETURN
			END CATCH
		END
	exec @v_logStatus = LogUpdate 85,@v_scriptName

	exec @v_logStatus = LogInsert 86,@v_scriptName,'Adding  new Column SecurityFlag in WFWebServiceInfoTable,Adding  new Column Q_DivertedByUserId in WORKLISTTABLE'
		BEGIN
			BEGIN TRY
				
				IF NOT EXISTS ( SELECT * FROM sysColumns 
				WHERE 
				id = (SELECT id FROM sysObjects WHERE NAME = 'WFWebServiceInfoTable')
				AND  NAME = 'SecurityFlag'
				)
				BEGIN
					exec  @v_logStatus = LogSkip 86,@v_scriptName
					EXECUTE('ALTER TABLE WFWebServiceInfoTable ADD SecurityFlag NVARCHAR(1) DEFAULT ''Y'' ')
					PRINT 'Table WFWebServiceInfoTable altered with new Column SecurityFlag'
				END
			
			
				/* Bug 38828 - NEW field Q_DivertedByUserId added for diversion requirement by Anwar Ali Danish */
				IF @v_TableExists=1
				BEGIN
					IF NOT EXISTS ( SELECT * FROM sysColumns 
					WHERE 
					id = (SELECT id FROM sysObjects WHERE NAME = 'worklisttable')
					AND  NAME = 'Q_DivertedByUserId'
					)
					BEGIN
						exec  @v_logStatus = LogSkip 86,@v_scriptName	
						EXECUTE('ALTER TABLE WORKLISTTABLE add Q_DivertedByUserId int')			
					END
				END
			END TRY
			BEGIN CATCH
				exec  @v_logStatus = LogFailed 86,@v_scriptName
				RAISERROR('Block 86 Failed.',16,1)
				RETURN
			END CATCH
		END
	exec @v_logStatus = LogUpdate 86,@v_scriptName

	exec @v_logStatus = LogInsert 87,@v_scriptName,'Adding  new Column Q_DivertedByUserId in workinprocesstable,Adding  new Column Q_DivertedByUserId in pendingworklisttable'
		BEGIN
			BEGIN TRY
				IF EXISTS (SELECT * FROM sysObjects WHERE NAME = 'workinprocesstable' AND xType = 'U')
				BEGIN
					
					IF NOT EXISTS ( SELECT * FROM sysColumns 
					WHERE 
					id = (SELECT id FROM sysObjects WHERE NAME = 'workinprocesstable')
					AND  NAME = 'Q_DivertedByUserId'
					)
					BEGIN	
					exec  @v_logStatus = LogSkip 87,@v_scriptName
					EXECUTE('alter table workinprocesstable add Q_DivertedByUserId int')		
				
					END

			
					IF NOT EXISTS ( SELECT * FROM sysColumns 
					WHERE 
					id = (SELECT id FROM sysObjects WHERE NAME = 'pendingworklisttable')
					AND  NAME = 'Q_DivertedByUserId'
					)
					BEGIN	
						exec  @v_logStatus = LogSkip 87,@v_scriptName
						EXECUTE('alter table pendingworklisttable add Q_DivertedByUserId int')		
					END
				END
								
			END TRY
			BEGIN CATCH
				exec  @v_logStatus = LogFailed 87,@v_scriptName
				RAISERROR('Block 87 Failed.',16,1)
				RETURN
			END CATCH
		END
	exec @v_logStatus = LogUpdate 87,@v_scriptName

	exec @v_logStatus = LogInsert 88,@v_scriptName,'Adding  new Column Q_DivertedByUserId in workdonetable'
		BEGIN
			BEGIN TRY
				IF EXISTS (SELECT * FROM sysObjects WHERE NAME = 'workdonetable')
				BEGIN
					IF NOT EXISTS ( SELECT * FROM sysColumns 
					WHERE 
					id = (SELECT id FROM sysObjects WHERE NAME = 'workdonetable')
					AND  NAME = 'Q_DivertedByUserId'
					)
					BEGIN
					exec  @v_logStatus = LogSkip 88,@v_scriptName		
					EXECUTE('alter table workdonetable add Q_DivertedByUserId int')		
				
					END
				END
				
			END TRY
			BEGIN CATCH
				exec  @v_logStatus = LogFailed 88,@v_scriptName
				RAISERROR('Block 88 Failed.',16,1)
				RETURN
			END CATCH
		END
	exec @v_logStatus = LogUpdate 88,@v_scriptName

	exec @v_logStatus = LogInsert 89,@v_scriptName,'Adding  new Column Q_DivertedByUserId in workwithpstable'
		BEGIN
			BEGIN TRY
				IF EXISTS (SELECT * FROM sysObjects WHERE NAME = 'workwithpstable' AND xType = 'U')
				BEGIN
					IF NOT EXISTS ( SELECT * FROM sysColumns 
					WHERE 
					id = (SELECT id FROM sysObjects WHERE NAME = 'workwithpstable')
					AND  NAME = 'Q_DivertedByUserId'
					)
					BEGIN		
						exec  @v_logStatus = LogSkip 89,@v_scriptName
						EXECUTE('alter table workwithpstable add Q_DivertedByUserId int')		
					END	
				
				END
				
			END TRY
			BEGIN CATCH
				exec  @v_logStatus = LogFailed 89,@v_scriptName
				RAISERROR('Block 89 Failed.',16,1)
				RETURN
			END CATCH
		END
	exec @v_logStatus = LogUpdate 89,@v_scriptName

	exec @v_logStatus = LogInsert 90,@v_scriptName,'Adding  new Column SecurityFlag in WFSAPConnectTable'
		BEGIN
			BEGIN TRY
				IF EXISTS (SELECT * FROM sysObjects WHERE NAME = 'WFSAPConnectTable')
				BEGIN
					IF NOT EXISTS ( SELECT * FROM sysColumns 
					WHERE 
					id = (SELECT id FROM sysObjects WHERE NAME = 'WFSAPConnectTable')
					AND  NAME = 'SecurityFlag'
					)
					BEGIN
					exec  @v_logStatus = LogSkip 90,@v_scriptName
						EXECUTE('ALTER TABLE WFSAPConnectTable ADD SecurityFlag NVARCHAR(1) DEFAULT ''Y'' ')
						PRINT 'Table WFSAPConnectTable altered with new Column SecurityFlag'
					END
				END
				
			END TRY
			BEGIN CATCH
				exec  @v_logStatus = LogFailed 90,@v_scriptName
				RAISERROR('Block 90,@v_scriptName Failed.',16,1)
				RETURN
			END CATCH
		END
	exec @v_logStatus = LogUpdate 90,@v_scriptName

	exec @v_logStatus = LogInsert 91,@v_scriptName,'Creating TABLE WFFailedServicesTable'	
		BEGIN
			BEGIN TRY
			
				IF NOT EXISTS (
				SELECT * FROM SYSObjects 
				WHERE NAME = 'WFFailedServicesTable'
				AND xType = 'U'
				)
				BEGIN
					exec  @v_logStatus = LogSkip 91,@v_scriptName
					EXECUTE('
					CREATE TABLE WFFailedServicesTable(
					 processDefId int NULL,
					 ServiceName varchar(200) NULL,
					 ServiceType varchar(30) NULL,
					 ServiceId varchar(200) NULL,
					 ActionDateTime datetime NULL,
					 ObjectName varchar(100) NULL,
					 ErrorCode int NULL,
					 ErrorMessage varchar(500) NULL,
					 Data_1 int NULL,
					 Data_2 int NULL
					)
				   ')
					PRINT 'Table WFFailedServicesTable created successfully.'
				END
		 
		 
			END TRY
			BEGIN CATCH
				exec  @v_logStatus = LogFailed 91,@v_scriptName
				RAISERROR('Block 91 Failed.',16,1)
				RETURN
			END CATCH
		END
	exec @v_logStatus = LogUpdate 91,@v_scriptName

	exec @v_logStatus = LogInsert 92,@v_scriptName,'Recreating TRIGGER TR_UNQ_PSREGISTERATIONTABLE ON PSREGISTERATIONTABLE AFTER  UPDATE '	
		BEGIN
			BEGIN TRY
				IF EXISTS(SELECT name from sysobjects where name='TR_UNQ_PSREGISTERATIONTABLE')
				BEGIN
				exec  @v_logStatus = LogSkip 92,@v_scriptName
				EXECUTE('DROP TRIGGER TR_UNQ_PSREGISTERATIONTABLE') 
				PRINT('Trigger dropped TR_UNQ_PSREGISTERATIONTABLE')
				END
			
				EXECUTE('CREATE TRIGGER TR_UNQ_PSREGISTERATIONTABLE 
					ON PSREGISTERATIONTABLE 
					AFTER  UPDATE 
					AS 
					BEGIN 
						DECLARE  
						@sessionid	int, 
						@psid	int 
						SELECT @sessionid = sessionid,@psid=psid FROM inserted 
						IF (exists (SELECT SessionId, PSID FROM psregisterationtable WHERE sessionid =@sessionid AND  psid !=@psid )) 
						BEGIN 
							RAISERROR (''Have same session ID'', 16, 1) 
							RETURN 
						END 
					END ')
				PRINT('Trigger TR_UNQ_PSREGISTERATIONTABLE created')
			END TRY
			BEGIN CATCH
				exec  @v_logStatus = LogFailed 92,@v_scriptName
				RAISERROR('Block 92 Failed.',16,1)
				RETURN
			END CATCH
		END
	exec @v_logStatus = LogUpdate 92,@v_scriptName

	exec @v_logStatus = LogInsert 93,@v_scriptName,'Dropping TR_LOG_PDBCONNECTION TRIGGER ON PDBCONNECTION'	
		BEGIN
			BEGIN TRY
			
				IF EXISTS ( SELECT  * FROM sys.triggers where name='TR_LOG_PDBCONNECTION')
				BEGIN
				exec  @v_logStatus = LogSkip 93,@v_scriptName
				EXECUTE('DROP TRIGGER TR_LOG_PDBCONNECTION')
				PRINT 'TR_LOG_PDBCONNECTION TRIGGER ON PDBCONNECTION DROPPED '
				END
			END TRY
			BEGIN CATCH
				exec  @v_logStatus = LogFailed 93,@v_scriptName
				RAISERROR('Block 93 Failed.',16,1)
				RETURN
			END CATCH
		END
	exec @v_logStatus = LogUpdate 93,@v_scriptName

	exec @v_logStatus = LogInsert 94,@v_scriptName,'Recreating VIEW WFUSERVIEW'	
		BEGIN
			BEGIN TRY
				BEGIN
				exec  @v_logStatus = LogSkip 94,@v_scriptName
				Execute('DROP VIEW WFUSERVIEW')
				Execute('CREATE VIEW WFUSERVIEW AS SELECT * FROM PDBUSER WHERE DELETEDFLAG = ''N''')		
				END
			END TRY
			BEGIN CATCH
				exec  @v_logStatus = LogFailed 94,@v_scriptName
				RAISERROR('Block 94 Failed.',16,1)
				RETURN
			END CATCH
		END
	exec @v_logStatus = LogUpdate 94,@v_scriptName

	exec @v_logStatus = LogInsert 95,@v_scriptName,'Recreating TRIGGER WF_USR_DEL on PDBUSER FOR DELETE'	
		BEGIN
			BEGIN TRY
				exec  @v_logStatus = LogSkip 95,@v_scriptName
				IF EXISTS(SELECT name from sysobjects where name='WF_USR_DEL')
				BEGIN
				EXECUTE('DROP TRIGGER WF_USR_DEL') 
				PRINT('Trigger dropped WF_USR_DEL')
				END
			
				IF EXISTS (SELECT * FROM sysObjects WHERE NAME = 'WORKLISTTABLE' AND xType = 'U')
				BEGIN
					EXECUTE('CREATE TRIGGER WF_USR_DEL 
						   on PDBUSER 
						   FOR DELETE 
						AS
						DECLARE @Assgnid INT

						BEGIN
							SELECT @Assgnid = DELETED.UserIndex FROM DELETED				
							Insert into Worklisttable (ProcessInstanceId, WorkItemId, ProcessName, ProcessVersion, ProcessDefID, LastProcessedBy, ProcessedBy, ActivityName, ActivityId, EntryDateTime, ParentWorkItemId, CollectFlag, PriorityLevel, ValidTill, Q_StreamId, Q_QueueId, Q_UserId, AssignedUser, AssignmentType, FilterValue, CreatedDateTime, WorkItemState, Statename, ExpectedWorkitemDelay, PreviousStage, LockStatus, Queuename, Queuetype, Q_DivertedByUserId) Select ProcessInstanceId, WorkItemId, ProcessName, ProcessVersion, ProcessDefID, LastProcessedBy, ProcessedBy, ActivityName, ActivityId, EntryDateTime, ParentWorkItemId, CollectFlag, PriorityLevel, ValidTill, Q_StreamId, Q_QueueId, Q_UserId, AssignedUser, AssignmentType, FilterValue, CreatedDateTime, WorkItemState, Statename, ExpectedWorkitemDelay, PreviousStage, N''N'', Queuename, Queuetype , Q_DivertedByUserId from WorkinProcessTable where Q_UserId = @Assgnid	
							Delete from WorkInProcessTable where Q_UserId = @Assgnid
							UPDATE WORKLISTTABLE SET AssignedUser = NULL, AssignmentType = N''N'', LockStatus = N''N'' , LockedByName = NULL,LockedTime = NULL , Q_UserId = 0 , QueueName = (SELECT QUEUEDEFTABLE.QueueName FROM QUEUESTREAMTABLE , QUEUEDEFTABLE WHERE  QUEUESTREAMTABLE.QueueID = QUEUEDEFTABLE.QueueID AND StreamID = Q_StreamID AND QUEUESTREAMTABLE.ProcessDefId = WORKLISTTABLE.ProcessDefId AND QUEUESTREAMTABLE.ActivityId = WORKLISTTABLE.ActivityId) , QueueType = (SELECT QUEUEDEFTABLE.QueueType FROM QUEUESTREAMTABLE , QUEUEDEFTABLE WHERE QUEUESTREAMTABLE.QueueID = QUEUEDEFTABLE.QueueID AND StreamID = Q_StreamID AND QUEUESTREAMTABLE.ProcessDefId = WORKLISTTABLE.ProcessDefId AND QUEUESTREAMTABLE.ActivityId = WORKLISTTABLE.ActivityId) , Q_QueueID = (SELECT QueueId FROM QUEUESTREAMTABLE WHERE StreamID = Q_StreamID AND QUEUESTREAMTABLE.ProcessDefId = WORKLISTTABLE.ProcessDefId AND QUEUESTREAMTABLE.ActivityId = WORKLISTTABLE.ActivityId) WHERE Q_UserId = @Assgnid AND AssignmentType = N''F''
							UPDATE WORKLISTTABLE SET AssignedUser = NULL, AssignmentType = N''N'', LockStatus = N''N'', LockedByName = NULL, LockedTime = NULL , Q_UserId = 0 WHERE  AssignmentType != N''F'' AND Q_UserId = @Assgnid
							DELETE FROM QUEUEUSERTABLE  WHERE UserID = @Assgnid AND Associationtype = 0
							DELETE FROM USERPREFERENCESTABLE WHERE UserID = @Assgnid
							DELETE FROM USERDIVERSIONTABLE WHERE Diverteduserindex = @Assgnid OR AssignedUserindex = @Assgnid
							DELETE FROM USERWORKAUDITTABLE WHERE Userindex = @Assgnid OR Auditoruserindex = @Assgnid
						END')
					PRINT('Trigger WF_USR_DEL created')	
				END
			END TRY
			BEGIN CATCH
				exec  @v_logStatus = LogFailed 95,@v_scriptName
				RAISERROR('Block 95 Failed.',16,1)
				RETURN
			END CATCH
		END
	exec @v_logStatus = LogUpdate 95,@v_scriptName

	exec @v_logStatus = LogInsert 96,@v_scriptName,'Creating TABLE WFMultiLingualTable'	
		BEGIN
			BEGIN TRY
				IF NOT EXISTS(
				   SELECT * FROM SYSObjects 
				   WHERE NAME = 'WFMultiLingualTable'
				   AND xType = 'U'
				)
				BEGIN
				exec  @v_logStatus = LogSkip 96,@v_scriptName
				EXECUTE('
					CREATE TABLE WFMultiLingualTable(
						EntityId 	    INT		NOT NULL,
						EntityType      INT		NOT NULL,
						Locale          NVARCHAR(20)   	NOT NULL ,	
						EntityName      NVARCHAR(255)      	NOT NULL , 	
						ProcessDefId	INT		NOT NULL,
						ParentId		INT		NOT NULL,
						FieldName 		NVARCHAR(1000),
						PRIMARY KEY (EntityId, EntityType, Locale, ProcessDefId, ParentId)
					)
				')
				PRINT 'Table WFMultiLingualTable created successfully.'
				END
			END TRY
			BEGIN CATCH
				exec  @v_logStatus = LogFailed 96,@v_scriptName
				RAISERROR('Block 96 Failed.',16,1)
				RETURN
			END CATCH
		END
	exec @v_logStatus = LogUpdate 96,@v_scriptName

	exec @v_logStatus = LogInsert 97,@v_scriptName,'Adding  new Column FromId in WFEscalationTable'
		BEGIN
			BEGIN TRY
				IF NOT EXISTS ( SELECT * FROM sysColumns 
				WHERE 
				id = (SELECT id FROM sysObjects WHERE NAME = 'WFEscalationTable')
				AND  NAME = 'FromId'
				)
				BEGIN	
				exec  @v_logStatus = LogSkip 97,@v_scriptName
				EXECUTE('alter table WFEscalationTable add FromId NVarchar(256)  
				DEFAULT(''OmniFlowSystem_do_not_reply@newgen.co.in'')')		
				
				EXECUTE('UPDATE WFEscalationTable SET FromId=''OmniFlowSystem_do_not_reply@newgen.co.in''  WHERE FromId IS NULL')
				END	
			END TRY
			BEGIN CATCH
				exec  @v_logStatus = LogFailed 97,@v_scriptName
				RAISERROR('Block 97 Failed.',16,1)
				RETURN
			END CATCH
		END
	exec @v_logStatus = LogUpdate 97,@v_scriptName

	exec @v_logStatus = LogInsert 98,@v_scriptName,'Adding  new Column CCId in WFEscalationTable'
		BEGIN
			BEGIN TRY
				IF NOT EXISTS ( SELECT * FROM sysColumns 
				WHERE 
				id = (SELECT id FROM sysObjects WHERE NAME = 'WFEscalationTable')
				AND  NAME = 'CCId'
				)
				BEGIN	
				exec  @v_logStatus = LogSkip 98,@v_scriptName
				EXECUTE('alter table WFEscalationTable add CCId NVarchar(256)')		
				END	
			END TRY
			BEGIN CATCH
				exec  @v_logStatus = LogFailed 98,@v_scriptName
				RAISERROR('Block 98 Failed.',16,1)
				RETURN
			END CATCH
		END
	exec @v_logStatus = LogUpdate 98,@v_scriptName

	exec @v_logStatus = LogInsert 99,@v_scriptName,'Adding  new Column BCCId in WFESCALATIONTABLE'
		BEGIN
			BEGIN TRY
				/*Bug 42494*/
				IF NOT EXISTS ( SELECT * FROM sysColumns 
				WHERE 
				id = (SELECT id FROM sysObjects WHERE NAME = 'WFESCALATIONTABLE')
				AND  NAME = 'BCCId'
				)
				BEGIN
				exec  @v_logStatus = LogSkip 99,@v_scriptName	
				EXECUTE('ALTER TABLE WFESCALATIONTABLE ADD BCCId NVARCHAR(256) DEFAULT NULL')
				PRINT 'Table WFESCALATIONTABLE altered with new Columns BCCId'
				END
			END TRY
			BEGIN CATCH
				exec  @v_logStatus = LogFailed 99,@v_scriptName
				RAISERROR('Block 99 Failed.',16,1)
				RETURN
			END CATCH
		END
	exec @v_logStatus = LogUpdate 99,@v_scriptName

	exec @v_logStatus = LogInsert 100,@v_scriptName,'Adding  new Column FromId in WFEscInProcessTable'
		BEGIN
			BEGIN TRY
				IF NOT EXISTS ( SELECT * FROM sysColumns 
				WHERE 
				id = (SELECT id FROM sysObjects WHERE NAME = 'WFEscInProcessTable')
				AND  NAME = 'FromId'
				)
				BEGIN	
				exec  @v_logStatus = LogSkip 100,@v_scriptName	
				EXECUTE('alter table WFEscInProcessTable add FromId NVarchar(256)')		
				END	
			END TRY
			BEGIN CATCH
				exec  @v_logStatus = LogFailed 100,@v_scriptName
				RAISERROR('Block 100 Failed.',16,1)
				RETURN
			END CATCH
		END
	exec @v_logStatus = LogUpdate 100,@v_scriptName

	exec @v_logStatus = LogInsert 101,@v_scriptName,'Adding  new Column CCId in WFEscInProcessTable'
		BEGIN
			BEGIN TRY
				IF NOT EXISTS ( SELECT * FROM sysColumns 
				WHERE 
				id = (SELECT id FROM sysObjects WHERE NAME = 'WFEscInProcessTable')
				AND  NAME = 'CCId'
				)
				BEGIN	
				exec  @v_logStatus = LogSkip 101,@v_scriptName
				EXECUTE('alter table WFEscInProcessTable add CCId NVarchar(256)')		
				END	
			END TRY
			BEGIN CATCH
				exec  @v_logStatus = LogFailed 101,@v_scriptName
				RAISERROR('Block 101 Failed.',16,1)
				RETURN
			END CATCH
		END
	exec @v_logStatus = LogUpdate 101,@v_scriptName

	exec @v_logStatus = LogInsert 102,@v_scriptName,'Adding  new Column BCCId in WFESCINPROCESSTABLE'
		BEGIN
			BEGIN TRY
				/*Bug 42494*/
				IF NOT EXISTS ( SELECT * FROM sysColumns 
				WHERE 
				id = (SELECT id FROM sysObjects WHERE NAME = 'WFESCINPROCESSTABLE')
				AND  NAME = 'BCCId'
				)
				BEGIN
				exec  @v_logStatus = LogSkip 102,@v_scriptName
				EXECUTE('ALTER TABLE WFESCINPROCESSTABLE ADD BCCId NVARCHAR(256) DEFAULT NULL')
				PRINT 'Table WFESCINPROCESSTABLE altered with new Columns BCCId'
				END
			END TRY
			BEGIN CATCH
				exec  @v_logStatus = LogFailed 102,@v_scriptName
				RAISERROR('Block 102 Failed.',16,1)
				RETURN
			END CATCH
		END
	exec @v_logStatus = LogUpdate 102,@v_scriptName

	exec @v_logStatus = LogInsert 103,@v_scriptName,'Adding  new Column TargetDocName in WFSharePointDocAssocTable'
		BEGIN
			BEGIN TRY
				IF NOT EXISTS ( SELECT * FROM sysColumns 
				WHERE 
				id = (SELECT id FROM sysObjects WHERE NAME = 'WFSharePointDocAssocTable')
				AND  NAME = 'TargetDocName'
				)
				BEGIN	
				exec  @v_logStatus = LogSkip 103,@v_scriptName
				EXECUTE('ALTER TABLE WFSharePointDocAssocTable ADD TargetDocName NVARCHAR(255) DEFAULT NULL')
				PRINT 'Table WFSharePointDocAssocTable altered with new Column TargetDocName'
				END
			END TRY
			BEGIN CATCH
				exec  @v_logStatus = LogFailed 103,@v_scriptName
				RAISERROR('Block 103 Failed.',16,1)
				RETURN
			END CATCH
		END
	exec @v_logStatus = LogUpdate 103,@v_scriptName

	exec @v_logStatus = LogInsert 104,@v_scriptName,'Recreating Check Constraint on Status in WFMessageTable'	
		BEGIN
			BEGIN TRY
				BEGIN
				
				SET @constrnName = ''
				SELECT @constrnName =  constraint_name 
				FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS 
				where table_name = 'WFMessageTable' and constraint_type = 'CHECK'
				IF (@constrnName IS NOT NULL AND (LEN(@constrnName) > 0))
				BEGIN
					
					EXECUTE ('alter table WFMessageTable drop constraint ' + @constrnName)  
					PRINT 'Table WFMessageTable altered, constraint on Status is dropped.'
				END		
				EXECUTE('ALTER TABLE WFMessageTable ADD CHECK (STATUS in (N''N'',N''L''))')
				PRINT 'Table WFMessageTable altered, Check Constraint on Status created.'
				END
			END TRY
			BEGIN CATCH
				exec  @v_logStatus = LogFailed 104,@v_scriptName
				RAISERROR('Block 104 Failed.',16,1)
				RETURN
			END CATCH
		END
	exec @v_logStatus = LogUpdate 104,@v_scriptName

	exec @v_logStatus = LogInsert 105,@v_scriptName,'Adding  new Column ParentId in WFMultiLingualTable'
		BEGIN
			BEGIN TRY
				IF NOT EXISTS ( SELECT * FROM sysColumns 
				WHERE 
				id = (SELECT id FROM sysObjects WHERE NAME = 'WFMultiLingualTable')
				AND  NAME = 'ParentId'
				)
				BEGIN
				exec  @v_logStatus = LogSkip 105,@v_scriptName
				
				EXECUTE('alter table WFMultiLingualTable add ParentId INT  DEFAULT 0')
				
				EXECUTE ('UPDATE WFMultiLingualTable SET ParentId=0 WHERE ParentId IS NULL')
				PRINT 'Table WFMultiLingualTable altered with new Column ParentId'
				END
			END TRY
			BEGIN CATCH
				exec  @v_logStatus = LogFailed 105,@v_scriptName
				RAISERROR('Block 105 Failed.',16,1)
				RETURN
			END CATCH
		END
	exec @v_logStatus = LogUpdate 105,@v_scriptName

	exec @v_logStatus = LogInsert 106,@v_scriptName,'Creating Table wfaudittraildoctable'	
		BEGIN
			BEGIN TRY
			
				IF NOT EXISTS ( SELECT * FROM sysObjects WHERE NAME = 'wfaudittraildoctable')
				BEGIN
				exec  @v_logStatus = LogSkip 106,@v_scriptName
					EXECUTE('
					Create Table wfaudittraildoctable(
					PROCESSDEFID			INT NOT NULL,
					PROCESSINSTANCEID		NVARCHAR(63)  NOT NULL ,
					WORKITEMID			INT NOT NULL,
					ACTIVITYID			INT NOT NULL,
					DOCID				INT NOT NULL,
					PARENTFOLDERINDEX		INT NOT NULL,
					VOLID				INT NOT NULL,
					APPSERVERIP			NVARCHAR(63) NOT NULL,
					APPSERVERPORT			INT NOT NULL,
					APPSERVERTYPE			NVARCHAR(63) NULL,
					ENGINENAME			NVARCHAR(63) NOT NULL,
					DELETEAUDIT			NVARCHAR(1) default ''N'' ,
					STATUS				CHAR(1)	NOT NULL,
					LOCKEDBY			NVARCHAR(63)	NULL,
					PRIMARY KEY (PROCESSINSTANCEID,WORKITEMID)
						)
						')
				
					PRINT 'Table WFAUDITTRAILDOCTABLE created successfully.'
				END
			END TRY
			BEGIN CATCH
				exec  @v_logStatus = LogFailed 106,@v_scriptName
				RAISERROR('Block 106 Failed.',16,1)
				RETURN
			END CATCH
		END
	exec @v_logStatus = LogUpdate 106,@v_scriptName

	exec @v_logStatus = LogInsert 107,@v_scriptName,'Adding  new Column DeleteAudit in ARCHIVETABLE'
		BEGIN
			BEGIN TRY
				IF NOT EXISTS ( SELECT * FROM sysColumns 
				WHERE 
				id = (SELECT id FROM sysObjects WHERE NAME = 'ARCHIVETABLE')
				AND  NAME = 'DeleteAudit'
				)
				BEGIN
					exec  @v_logStatus = LogSkip 107,@v_scriptName
					EXECUTE('ALTER TABLE ARCHIVETABLE ADD DeleteAudit NVARCHAR(1) DEFAULT ''N'' ')			
					EXECUTE ('UPDATE ARCHIVETABLE SET DeleteAudit = ''N'' WHERE DeleteAudit IS NULL')		
					
					PRINT 'Table ARCHIVETABLE altered with new Column DeleteAudit'
				END
			END TRY
			BEGIN CATCH
				exec  @v_logStatus = LogFailed 107,@v_scriptName
				RAISERROR('Block 107 Failed.',16,1)
				RETURN
			END CATCH
		END
	exec @v_logStatus = LogUpdate 107,@v_scriptName

	exec @v_logStatus = LogInsert 108,@v_scriptName,'Table WFMultiLingualTable altered with new Primary key'	
		BEGIN
			BEGIN TRY
			
			
				IF NOT EXISTS ( select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
				where table_name = 'WFMultiLingualTable' AND CONSTRAINT_TYPE = 'PRIMARY KEY'
				)
				BEGIN	
					exec  @v_logStatus = LogSkip 108,@v_scriptName
					EXECUTE('Alter table wfmultilingualtable Add PRIMARY KEY (EntityId, EntityType, Locale, ProcessDefId, ParentId)')
					PRINT 'Table WFMultiLingualTable altered with new Primary key'
				END
			END TRY
			BEGIN CATCH
				exec  @v_logStatus = LogFailed 108,@v_scriptName
				RAISERROR('Block 108 Failed.',16,1)
				RETURN
			END CATCH
		END
	exec @v_logStatus = LogUpdate 108,@v_scriptName

	exec @v_logStatus = LogInsert 109,@v_scriptName,'Adding  new Column FieldName in WFMultiLingualTable ,updating WFMultiLingualTable'	
		BEGIN
			BEGIN TRY
			
				IF NOT EXISTS ( SELECT * FROM sysColumns 
				WHERE 
				id = (SELECT id FROM sysObjects WHERE NAME = 'WFMultiLingualTable')
				AND  NAME = 'FieldName'
				)
				BEGIN		
				exec  @v_logStatus = LogSkip 109,@v_scriptName
				EXECUTE('Alter table WFMultiLingualTable add FieldName nvarchar(1000)')
				PRINT 'Table WFMultiLingualTable altered with new Column FieldName'
				END
			
				BEGIN	
				EXECUTE('update wfmultilingualtable set processdefid = entityid where entitytype = 1 and processdefid = 0')
				
				EXECUTE('update wfmultilingualtable set FieldName = ProcessName from wfmultilingualtable inner join processdeftable on entityid = processdeftable.processdefid where entitytype = 1 and (FieldName IS NULL or FieldName = '''')')
				
				EXECUTE('update wfmultilingualtable set FieldName = queuename from wfmultilingualtable inner join queuedeftable on entityid = queueid where entitytype = 2 and (FieldName IS NULL or FieldName = '''')')
				
				EXECUTE('update wfmultilingualtable set FieldName = activityname from wfmultilingualtable inner join activitytable on entityid = activityid and wfmultilingualtable.processdefid = activitytable.processdefid where entitytype = 3 and (FieldName IS NULL or FieldName = '''')')
				
				EXECUTE('update wfmultilingualtable set FieldName = UserDefinedName from wfmultilingualtable inner join varmappingtable on entityid = variableid and wfmultilingualtable.processdefid = varmappingtable.processdefid where entitytype = 4 and (FieldName IS NULL or FieldName = '''')')
				
				EXECUTE('update wfmultilingualtable set FieldName = Alias from wfmultilingualtable inner join varaliastable on entityid = variableid1 and wfmultilingualtable.processdefid = varaliastable.processdefid and parentid = queueid where entitytype = 5 and (FieldName IS NULL or FieldName = '''')')
				
				EXECUTE('update wfmultilingualtable set FieldName = DocName from wfmultilingualtable inner join documenttypedeftable on entityid = docid and wfmultilingualtable.processdefid = documenttypedeftable.processdefid where entitytype = 6 and (FieldName IS NULL or FieldName = '''')')
			END
			END TRY
			BEGIN CATCH
				exec  @v_logStatus = LogFailed 109,@v_scriptName
				RAISERROR('Block 109 Failed.',16,1)
				RETURN
			END CATCH
		END
	exec @v_logStatus = LogUpdate 109,@v_scriptName

	exec @v_logStatus = LogInsert 110,@v_scriptName,'CREATING TABLE WorkDoneSuspectTable'	
		BEGIN
			BEGIN TRY
				IF NOT EXISTS(SELECT * FROM sysObjects WHERE NAME = 'WorkDoneSuspectTable')
				BEGIN
				exec  @v_logStatus = LogSkip 110,@v_scriptName
				CREATE TABLE WorkDoneSuspectTable (
					ProcessInstanceId NVARCHAR(63) NOT NULL ,
					WorkItemId INT NOT NULL ,
					ProcessName NVARCHAR(30) NOT NULL ,
					ProcessVersion SMALLINT,
					ProcessDefID INT NOT NULL,
					LastProcessedBy INT NULL ,
					ProcessedBy NVARCHAR(63) NULL,
					ActivityName NVARCHAR(30) NULL ,
					ActivityId INT NULL ,
					EntryDateTime DATETIME NULL ,
					ParentWorkItemId INT NULL ,
					AssignmentType NVARCHAR(1) NULL ,
					CollectFlag NVARCHAR(1) NULL ,
					PriorityLevel SMALLINT NULL ,
					ValidTill DATETIME NULL ,
					Q_StreamId INT NULL ,
					Q_QueueId INT NULL ,
					Q_UserId INT NULL ,
					AssignedUser NVARCHAR(63) NULL,
					FilterValue INT NULL ,
					Createddatetime DATETIME NULL ,
					WorkItemState INT NULL ,
					Statename NVARCHAR(255),
					ExpectedWorkitemDelay DATETIME NULL ,
					PreviousStage NVARCHAR (30) NULL ,
					LockedByName NVARCHAR(63) NULL,
					LockStatus NVARCHAR(1) Default N'N' NOT NULL,
					LockedTime DATETIME NULL,
					Queuename NVARCHAR(63),
					Queuetype NVARCHAR(1),
					NotifyStatus NVARCHAR(1),
					CONSTRAINT PK_WorkDoneSuspectTable PRIMARY KEY (
					ProcessInstanceID,
					WorkitemId
					)
				)
				PRINT 'Table WorkDoneSuspectTable created successfully'
				END
			END TRY
			BEGIN CATCH
				exec  @v_logStatus = LogFailed 110,@v_scriptName
				RAISERROR('Block 110 Failed.',16,1)
				RETURN
			END CATCH
		END
	exec @v_logStatus = LogUpdate 110,@v_scriptName

	exec @v_logStatus = LogInsert 111,@v_scriptName,'Adding  new Column IsEncrypted in WFExportInfoTable'
		BEGIN
			BEGIN TRY
				IF NOT EXISTS ( SELECT * FROM sysColumns 
				WHERE 
				id = (SELECT id FROM sysObjects WHERE NAME = 'WFExportInfoTable')
				AND  NAME = 'IsEncrypted'
				)
				BEGIN
				exec  @v_logStatus = LogSkip 111,@v_scriptName
				EXECUTE('ALTER TABLE WFExportInfoTable add IsEncrypted NVARCHAR(1) DEFAULT ''N'' ')
				
				EXECUTE ('UPDATE WFExportInfoTable SET  IsEncrypted= ''N'' WHERE IsEncrypted IS NULL')
				
				PRINT 'Table WFExportInfoTable altered with new Column IsEncrypted'
				END
			END TRY
			BEGIN CATCH
				exec  @v_logStatus = LogFailed 111,@v_scriptName
				RAISERROR('Block 111 Failed.',16,1)
				RETURN
			END CATCH
		END
	exec @v_logStatus = LogUpdate 111,@v_scriptName

	exec @v_logStatus = LogInsert 112,@v_scriptName,'Adding  new Column BulkPS in PSREGISTERATIONTABLE'
		BEGIN
			BEGIN TRY
				IF NOT EXISTS ( SELECT * FROM sysColumns 
				WHERE 
				id = (SELECT id FROM sysObjects WHERE NAME = 'PSREGISTERATIONTABLE')
				AND  NAME = 'BulkPS'
				)
				BEGIN
				exec  @v_logStatus = LogSkip 112,@v_scriptName
				EXECUTE('ALTER TABLE PSREGISTERATIONTABLE add BulkPS NVARCHAR(1)')
				PRINT 'Table PSREGISTERATIONTABLE altered with new Column BulkPS'
				END
			END TRY
			BEGIN CATCH
				exec  @v_logStatus = LogFailed 112,@v_scriptName
				RAISERROR('Block 112 Failed.',16,1)
				RETURN
			END CATCH
		END
	exec @v_logStatus = LogUpdate 112,@v_scriptName

	exec @v_logStatus = LogInsert 113,@v_scriptName,'CREATING TRIGGER WF_UTIL_UNREGISTER ON PSREGISTERATIONTABLE FOR DELETE'	
		BEGIN
			BEGIN TRY
				IF EXISTS (SELECT 1 FROM SYS.OBJECTS WHERE  OBJECT_ID = OBJECT_ID(N'WORKLISTTABLE') AND OBJECT_ID = OBJECT_ID(N'WORKDONETABLE') AND TYPE = N'U' )
				BEGIN
					IF NOT EXISTS(SELECT name from sysobjects where name='WF_UTIL_UNREGISTER')
					BEGIN
					exec  @v_logStatus = LogSkip 113,@v_scriptName
					EXECUTE('CREATE TRIGGER WF_UTIL_UNREGISTER 
						ON PSREGISTERATIONTABLE 
						FOR DELETE
						AS	
						DECLARE @PSName NVARCHAR(100)	
						DECLARE @PSData NVARCHAR(50)
						BEGIN
							SELECT @PSName = DELETED.PSName, @PSData = DELETED.Data FROM DELETED
							IF @PSData = ''PROCESS SERVER''
							BEGIN
								Insert into WorkDoneTable(ProcessInstanceId,WorkItemId,ProcessName,ProcessVersion,ProcessDefID,LastProcessedBy,ProcessedBy,ActivityName,ActivityId,EntryDateTime,ParentWorkItemId,AssignmentType,CollectFlag,PriorityLevel,ValidTill,Q_StreamId,Q_QueueId,Q_UserId,AssignedUser,FilterValue,CreatedDatetime,WorkItemState,Statename,ExpectedWorkitemDelay,PreviousStage,LockedByName,LockStatus,LockedTime,Queuename,Queuetype,NotifyStatus) select ProcessInstanceId,WorkItemId,ProcessName,ProcessVersion,ProcessDefID,LastProcessedBy,ProcessedBy,ActivityName,ActivityId,EntryDateTime,ParentWorkItemId,AssignmentType,CollectFlag,PriorityLevel,ValidTill,Q_StreamId,Q_QueueId,Q_UserId,AssignedUser,FilterValue,CreatedDatetime,WorkItemState,Statename,ExpectedWorkitemDelay,PreviousStage,null,''N'',null,Queuename,Queuetype,NotifyStatus from WorkWithPSTable where LockedByName = @PSName
								Delete from WorkWithPSTable where LockedByName = @PSName
							END
							IF @PSData = ''MAILING AGENT''
							BEGIN
								UPDATE WFMailQueueTable SET MailStatus = ''N'', LockedBy = null, LastLockTime = null, NoOfTrials = 0 where LockedBy = @PSName
							END
							IF @PSData = ''MESSAGE AGENT''
							BEGIN
								UPDATE WFMessageTable SET LockedBy = null, Status = ''N'' where LockedBy = @PSName
							END
							IF (@PSData = ''PRINT,FAX & EMAIL'' OR @PSData = ''ARCHIVE UTILITY'')
							BEGIN
								Insert into Worklisttable (ProcessInstanceId, WorkItemId, ProcessName, ProcessVersion, ProcessDefID, LastProcessedBy, ProcessedBy, ActivityName, ActivityId, EntryDateTime, ParentWorkItemId, CollectFlag, PriorityLevel, ValidTill, Q_StreamId, Q_QueueId, Q_UserId, AssignedUser, AssignmentType, FilterValue, CreatedDateTime, WorkItemState, Statename, ExpectedWorkitemDelay, PreviousStage, LockedByName, LockStatus, LockedTime, Queuename, Queuetype, Q_DivertedByUserId) Select ProcessInstanceId, WorkItemId, ProcessName, ProcessVersion, ProcessDefID, LastProcessedBy, ProcessedBy, ActivityName, ActivityId, EntryDateTime, ParentWorkItemId, CollectFlag, PriorityLevel, ValidTill, Q_StreamId, Q_QueueId, 0, null, AssignmentType, FilterValue, CreatedDateTime, WorkItemState, Statename, ExpectedWorkitemDelay, PreviousStage, null, N''N'', null, Queuename, Queuetype , Q_DivertedByUserId from WorkinProcessTable where LockedByName = @PSName
								Delete from WorkInProcessTable where LockedByName = @PSName
							END
						END')
					PRINT 'Trigger WF_UTIL_UNREGISTER created on table PSRegisterationTable'
					END
				END
			END TRY
			BEGIN CATCH
				exec  @v_logStatus = LogFailed 113,@v_scriptName
				RAISERROR('Block 113 Failed.',16,1)
				RETURN
			END CATCH
		END
	exec @v_logStatus = LogUpdate 113,@v_scriptName

	exec @v_logStatus = LogInsert 114,@v_scriptName,'Adding  new Column context in processdeftable'
		BEGIN
			BEGIN TRY
				IF NOT EXISTS ( SELECT * FROM sysColumns 
				WHERE 
				id = (SELECT id FROM sysObjects WHERE NAME = 'processdeftable')
				AND  NAME = 'context'
				)
				BEGIN	
				exec  @v_logStatus = LogSkip 114,@v_scriptName
				EXECUTE('ALTER TABLE processdeftable ADD context NVARCHAR(50)')
				PRINT 'Table processdeftable altered with new Column context'
				END
			
			END TRY
			BEGIN CATCH
				exec  @v_logStatus = LogFailed 114,@v_scriptName
				RAISERROR('Block 114 Failed.',16,1)
				RETURN
			END CATCH
		END
	exec @v_logStatus = LogUpdate 114,@v_scriptName

	exec @v_logStatus = LogInsert 115,@v_scriptName,'Adding Queue of QueueType A for Archive Utility'	
		BEGIN
			BEGIN TRY
			
					/* Adding Archive Queue, QueueType A*/
				IF NOT EXISTS(SELECT QueueId  FROM QueueDefTable WHERE QueueType = 'A' and QueueName = 'SystemArchiveQueue')
				BEGIN	
				exec  @v_logStatus = LogSkip 115,@v_scriptName	
				EXECUTE('insert into QueueDefTable (QueueName,QueueType,Comments,AllowReassignment,FilterOption,FilterValue,OrderBy,QueueFilter,RefreshInterval,SortOrder,ProcessName)values(''SystemArchiveQueue'',''A'',''Queue of QueueType A for Archive Utility is added through Upgradenew.sql'',NULL,NULL,NULL,10,NULL,NULL,''A'',NULL)')
				
				PRINT 'Queue of QueueType A for Archive Utility is added successfully'
				
				
				BEGIN
					Select @QueueID = QueueID from QueueDefTable where QueueName = 'SystemArchiveQueue' and QueueType = 'A'
					DECLARE cursor1 CURSOR STATIC FOR
					Select ActivityAssociationtable.ProcessDefID, activityId from ActivityAssociationtable,Process_Interfacetable where DefinitionType = 'N' and DefinitionId = InterfaceId and ActivityAssociationtable.ProcessDefID = Process_Interfacetable.ProcessDefID and InterfaceName = 'Archive'
					
					open cursor1
					FETCH NEXT FROM cursor1 INTO @ProcessDefId,@activityID
					WHILE(@@FETCH_STATUS = 0) 
						BEGIN
							BEGIN TRANSACTION trans
								EXECUTE('Update QueueStreamTable set QueueId = ' + @QueueID + ' where activityId = ' + @activityID + ' and ProcessDefId = '+@ProcessDefId)
								EXECUTE('Update WorkListTable set QueueName = ''SystemArchiveQueue'' ,Q_queueId = ' + @QueueID + ' where activityId = ' + @activityID + ' and ProcessDefId = ' + @ProcessDefId)
								EXECUTE('Update WorkInProcessTable set QueueName = ''SystemArchiveQueue'',Q_queueId= ' + @QueueID + ' where activityId = ' + @activityID + ' and ProcessDefId = ' + @ProcessDefId)
								
							COMMIT TRANSACTION trans	
							FETCH NEXT FROM cursor1 INTO @ProcessDefId,@activityID
						END
					CLOSE cursor1
					DEALLOCATE cursor1
				END		
				END
				
			END TRY
			BEGIN CATCH
				exec  @v_logStatus = LogFailed 115,@v_scriptName
				RAISERROR('Block 115 Failed.',16,1)
				RETURN
			END CATCH
		END
	exec @v_logStatus = LogUpdate 115,@v_scriptName

	exec @v_logStatus = LogInsert 116,@v_scriptName,'Adding Queue of QueueType A for PFE Utility; And Updating QueueStreamTable,WorkListTable,WorkInProcessTable'	
		BEGIN
			BEGIN TRY
				/* Adding PFE Queue, QueueType A*/
				IF NOT EXISTS(SELECT QueueId  FROM QueueDefTable WHERE QueueType = 'A' and QueueName = 'SystemPFEQueue')
				BEGIN	
				exec  @v_logStatus = LogSkip 116,@v_scriptName	
				EXECUTE('insert into QueueDefTable (QueueName,QueueType,Comments,AllowReassignment,FilterOption,FilterValue,OrderBy,QueueFilter,RefreshInterval,SortOrder,ProcessName) values(''SystemPFEQueue'',''A'',''Queue of QueueType A for PFE Utility is added thorugh Upgradenew.sql'',NULL,NULL,NULL,10,NULL,NULL,''A'',NULL)')
				
				PRINT 'Queue of QueueType A for PFE Utility is added successfully'
				
				
				BEGIN
					Select @QueueID = QueueID from QueueDefTable where QueueName = 'SystemPFEQueue' and QueueType = 'A'
					DECLARE cursor1 CURSOR STATIC FOR
					Select ActivityAssociationtable.ProcessDefID, activityId from ActivityAssociationtable,Process_Interfacetable where DefinitionType = 'N' and DefinitionId = InterfaceId and ActivityAssociationtable.ProcessDefID = Process_Interfacetable.ProcessDefID and InterfaceName = 'PrintFaxEmail'
					
					open cursor1
					FETCH NEXT FROM cursor1 INTO @ProcessDefId,@activityID
					WHILE(@@FETCH_STATUS = 0) 
						BEGIN
							BEGIN TRANSACTION trans
								EXECUTE('Update QueueStreamTable set QueueId = ' + @QueueID + ' where activityId = ' + @activityID + ' and ProcessDefId = ' + @ProcessDefId)
								EXECUTE('Update WorkListTable set QueueName=''SystemPFEQueue'',Q_queueId = ' + @QueueID + ' where activityId = ' + @activityID + ' and ProcessDefId = ' + @ProcessDefId)
								EXECUTE('Update WorkInProcessTable set QueueName = ''SystemPFEQueue'',Q_queueId = ' + @QueueID + ' where activityId= '+@activityID+' and ProcessDefId='+@ProcessDefId)
								
							COMMIT TRANSACTION trans
							FETCH NEXT FROM cursor1 INTO @ProcessDefId,@activityID
						END
					CLOSE cursor1
					DEALLOCATE cursor1
				END
				
				END
			END TRY
			BEGIN CATCH
				exec  @v_logStatus = LogFailed 116,@v_scriptName
				RAISERROR('Block 116 Failed.',16,1)
				RETURN
			END CATCH
		END
	exec @v_logStatus = LogUpdate 116,@v_scriptName

	exec @v_logStatus = LogInsert 117,@v_scriptName,'Table USERPREFERENCESTABLE altered, Primary key created'	
		BEGIN
			BEGIN TRY
				BEGIN
				SET @constrnName = ''
				SELECT @constrnName=name
				FROM sys.key_constraints
				WHERE type = 'PK' AND OBJECT_NAME(parent_object_id) = N'USERPREFERENCESTABLE'
				IF (@constrnName IS NOT NULL AND (LEN(@constrnName) > 0))
				BEGIN
					exec  @v_logStatus = LogSkip 107,@v_scriptName
					EXECUTE ('alter table USERPREFERENCESTABLE drop constraint ' + @constrnName)  
					PRINT 'Table USERPREFERENCESTABLE altered, constraint  is dropped.'	
					EXECUTE ('alter table USERPREFERENCESTABLE ADD CONSTRAINT '+ @constrnName +' PRIMARY KEY CLUSTERED (Userid, ObjectType, ObjectId)')
					PRINT 'Table USERPREFERENCESTABLE altered, Primary key created.'	
					
				END
				END
			END TRY
			BEGIN CATCH
				exec  @v_logStatus = LogFailed 117,@v_scriptName
				RAISERROR('Block 117 Failed.',16,1)
				RETURN
			END CATCH
		END
	exec @v_logStatus = LogUpdate 117,@v_scriptName

	exec @v_logStatus = LogInsert 118,@v_scriptName,'Adding  new Column VariableId in WFSearchVariableTable,Updating WFSEARCHVARIABLETABLE'
		BEGIN
			BEGIN TRY
				
				IF NOT EXISTS ( SELECT * FROM sysColumns 
				WHERE 
				id = (SELECT id FROM sysObjects WHERE NAME = 'WFSearchVariableTable')
				AND  NAME = 'VariableId'
				)
			
				BEGIN
					exec  @v_logStatus = LogSkip 118,@v_scriptName
					EXECUTE('ALTER TABLE WFSearchVariableTable ADD VariableId INT DEFAULT 0')
					PRINT 'Table WFSearchVariableTable altered with new Column VariableId'
					BEGIN
						DECLARE WFActivityTableCursor CURSOR FOR SELECT ACTIVITYID, PROCESSDEFID from ACTIVITYTABLE where ACTIVITYTYPE = 1;
						OPEN WFActivityTableCursor 
						FETCH NEXT FROM WFActivityTableCursor INTO @activity_Id, @procDefId
						WHILE @@FETCH_STATUS = 0
							BEGIN 
							DECLARE @Article TABLE
							(
							Title int
							)
							SET @TSQL='SELECT VARIABLEID from WFSEARCHVARIABLETABLE where ACTIVITYID = '+CONVERT(NVARCHAR(10),@activity_Id) +'AND PROCESSDEFID ='+ CONVERT(NVARCHAR(10),@procDefId)
							INSERT @Article
										EXEC SP_EXECUTESQL @TSQL
							DECLARE Variable_Cursor CURSOR FOR 
							SELECT  * FROM @Article
							OPEN Variable_Cursor;
							FETCH NEXT FROM Variable_Cursor INTO @variable_ID
							WHILE @@FETCH_STATUS = 0
								BEGIN
								PRINT 'Inside while loop'
								SET @TSQL2 = 'UPDATE WFSEARCHVARIABLETABLE SET ACTIVITYID = 0 WHERE ACTIVITYID ='+ CONVERT(NVARCHAR(10),@activity_Id) + ' AND PROCESSDEFID = ' + CONVERT(NVARCHAR(10),@procDefId) + ' AND VARIABLEID =' + CONVERT(NVARCHAR(10),@variable_ID)
								EXECUTE(@TSQL2)
								  FETCH NEXT FROM Variable_Cursor INTO @variable_ID
								END;
							CLOSE Variable_Cursor;
							DEALLOCATE Variable_Cursor;
							--EXECUTE('UPDATE WFSEARCHVARIABLETABLE SET ACTIVITYID = 0 WHERE ACTIVITYID ='+ @activity_Id + ' AND PROCESSDEFID = ' + @procDefId)
							FETCH NEXT FROM WFActivityTableCursor INTO @activity_Id, @procDefId
					END
					CLOSE WFActivityTableCursor
					DEALLOCATE WFActivityTableCursor
				END
			
				DECLARE alias_cursor CURSOR FAST_FORWARD FOR
					SELECT DISTINCT FieldName, A.VariableId, B.ProcessdefId FROM VARMAPPINGTABLE  A, WFSearchVariableTable B WHERE A.USERDEFINEDNAME = B.FIELDNAME
					OPEN alias_cursor
					FETCH alias_cursor INTO @FIELDNAME, @v_VariableId, @ProcessDefId
					WHILE(@@FETCH_STATUS = 0) 
					BEGIN 
						BEGIN TRANSACTION trans
							EXECUTE(' Update WFSearchVariableTable Set VariableId = ' + @v_VariableId + ' Where FIELDNAME = ' + @quoteChar + @FIELDNAME + @quoteChar + ' And ProcessdefId = ' + @ProcessDefId )
						COMMIT TRANSACTION trans

						FETCH NEXT FROM alias_cursor INTO @FIELDNAME, @v_VariableId, @ProcessDefId
					END
					CLOSE alias_cursor
					DEALLOCATE alias_cursor
				END
			END TRY
			BEGIN CATCH
				exec  @v_logStatus = LogFailed 118,@v_scriptName
				RAISERROR('Block 118 Failed.',16,1)
				RETURN
			END CATCH
		END
	exec @v_logStatus = LogUpdate 118,@v_scriptName

	exec @v_logStatus = LogInsert 119,@v_scriptName,'Table WORKWITHPSTABLE altered column LOCKEDBYNAME to NVARCHAR(200) '
		BEGIN
			BEGIN TRY
			
				IF EXISTS ( SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'WORKWITHPSTABLE' AND xtype = 'U')
				AND  NAME = 'LOCKEDBYNAME')
				BEGIN
				exec  @v_logStatus = LogSkip 119,@v_scriptName
				EXECUTE('ALTER TABLE WORKWITHPSTABLE ALTER COLUMN LOCKEDBYNAME NVARCHAR(200)')
				PRINT 'Table WORKWITHPSTABLE altered column LOCKEDBYNAME to NVARCHAR(200) '
				END
			END TRY
			BEGIN CATCH
				exec  @v_logStatus = LogFailed 119,@v_scriptName
				RAISERROR('Block 119 Failed.',16,1)
				RETURN
			END CATCH
		END
	exec @v_logStatus = LogUpdate 119,@v_scriptName

	exec @v_logStatus = LogInsert 120,@v_scriptName,'Table WORKDONETABLE altered column LOCKEDBYNAME to NVARCHAR(200)'
		BEGIN
			BEGIN TRY
				IF EXISTS ( SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'WORKDONETABLE')
				AND  NAME = 'LOCKEDBYNAME')
				BEGIN
				exec  @v_logStatus = LogSkip 120,@v_scriptName
				EXECUTE('ALTER TABLE WORKDONETABLE ALTER COLUMN LOCKEDBYNAME NVARCHAR(200)')
				PRINT 'Table WORKDONETABLE altered column LOCKEDBYNAME to NVARCHAR(200) '
				END
			
			END TRY
			BEGIN CATCH
				exec  @v_logStatus = LogFailed 120,@v_scriptName
				RAISERROR('Block 120 Failed.',16,1)
				RETURN
			END CATCH
		END
	exec @v_logStatus = LogUpdate 120,@v_scriptName

	exec @v_logStatus = LogInsert 121,@v_scriptName,'Recreating clustered Primary key on taskId in WFMAILQUEUEHISTORYTABLE'	
		BEGIN
			BEGIN TRY
				
				BEGIN
				SET @constrnName = ''
				SELECT @constrnName=name
				FROM sys.key_constraints
				WHERE type = 'PK' AND OBJECT_NAME(parent_object_id) = N'WFMAILQUEUEHISTORYTABLE'
				IF (@constrnName IS NOT NULL AND (LEN(@constrnName) > 0))
				BEGIN
					exec  @v_logStatus = LogSkip 121,@v_scriptName
					EXECUTE ('alter table WFMAILQUEUEHISTORYTABLE drop constraint ' + @constrnName)  
					PRINT 'Table WFMAILQUEUEHISTORYTABLE altered, constraint  is dropped.'	
					EXECUTE ('alter table WFMAILQUEUEHISTORYTABLE ADD CONSTRAINT '+ @constrnName +' PRIMARY KEY CLUSTERED (TASKID)')
					PRINT 'Table WFMAILQUEUEHISTORYTABLE altered, Primary key created.'	
				END
				ELSE
				BEGIN
					exec  @v_logStatus = LogSkip 121,@v_scriptName
					EXECUTE ('alter table WFMAILQUEUEHISTORYTABLE ADD PRIMARY KEY CLUSTERED (TASKID)')
					PRINT 'Table WFMAILQUEUEHISTORYTABLE altered, Primary key created.'	
				END
				
				END
			END TRY
			BEGIN CATCH
				exec  @v_logStatus = LogFailed 121,@v_scriptName
				RAISERROR('Block 121 Failed.',16,1)
				RETURN
			END CATCH
		END
	exec @v_logStatus = LogUpdate 121,@v_scriptName

	
	exec @v_logStatus = LogInsert 122,@v_scriptName,'Recreating clustered Primary key on MESSAGEID in WFJMSMESSAGETABLE'	
		BEGIN
			BEGIN TRY
				BEGIN
				exec  @v_logStatus = LogSkip 122,@v_scriptName
				SET @constrnName = ''
				SELECT @constrnName=name
				FROM sys.key_constraints
				WHERE type = 'PK' AND OBJECT_NAME(parent_object_id) = N'WFJMSMESSAGETABLE'
				IF (@constrnName IS NOT NULL AND (LEN(@constrnName) > 0))
				BEGIN
					EXECUTE ('alter table WFJMSMESSAGETABLE drop constraint ' + @constrnName)  
					PRINT 'Table WFJMSMESSAGETABLE altered, constraint  is dropped.'	
					EXECUTE ('alter table WFJMSMESSAGETABLE ADD CONSTRAINT '+ @constrnName +' PRIMARY KEY CLUSTERED (MESSAGEID)')
					PRINT 'Table WFJMSMESSAGETABLE altered, Primary key created.'	
				END
				ELSE
				BEGIN
					EXECUTE ('alter table WFJMSMESSAGETABLE ADD PRIMARY KEY CLUSTERED (MESSAGEID)')
					PRINT 'Table WFJMSMESSAGETABLE altered, Primary key created.'	
				END
				END
			
			END TRY
			BEGIN CATCH
				exec  @v_logStatus = LogFailed 122,@v_scriptName
				RAISERROR('Block 122 Failed.',16,1)
				RETURN
			END CATCH
		END
	exec @v_logStatus = LogUpdate 122,@v_scriptName

	exec @v_logStatus = LogInsert 123,@v_scriptName,'Recreating clustered Primary key on (ProcessDefId, WSDLURLId) in WFWebServiceInfoTable'	
		BEGIN
			BEGIN TRY
				exec  @v_logStatus = LogSkip 123,@v_scriptName
				BEGIN
				SET @constrnName = ''
				SELECT @constrnName=name
				FROM sys.key_constraints
				WHERE type = 'PK' AND OBJECT_NAME(parent_object_id) = N'WFWebServiceInfoTable'
				IF (@constrnName IS NOT NULL AND (LEN(@constrnName) > 0))
				BEGIN
					EXECUTE ('alter table WFWebServiceInfoTable drop constraint ' + @constrnName)  
					PRINT 'Table WFWebServiceInfoTable altered, constraint  is dropped.'	
					EXECUTE ('alter table WFWebServiceInfoTable ADD CONSTRAINT '+ @constrnName +' PRIMARY KEY CLUSTERED (ProcessDefId, WSDLURLId)')
					PRINT 'Table WFWebServiceInfoTable altered, Primary key created.'	
				END
				ELSE
				BEGIN
					EXECUTE ('alter table WFWebServiceInfoTable ADD PRIMARY KEY CLUSTERED (ProcessDefId, WSDLURLId)')
					PRINT 'Table WFWebServiceInfoTable altered, Primary key created.'	
				END
				END
			END TRY
			BEGIN CATCH
				exec  @v_logStatus = LogFailed 123,@v_scriptName
				RAISERROR('Block 123 Failed.',16,1)
				RETURN
			END CATCH
		END
	exec @v_logStatus = LogUpdate 123,@v_scriptName

	exec @v_logStatus = LogInsert 124,@v_scriptName,'Table WFCREATECHILDWITABLE altered column WORKSTEPNAME to NVARCHAR(255)'	
		BEGIN
			BEGIN TRY
   			
					IF NOT EXISTS ( SELECT 1 FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'WFCREATECHILDWITABLE')
					AND  NAME = 'WORKSTEPNAME' AND length =510)
					BEGIN
						exec  @v_logStatus = LogSkip 124,@v_scriptName
						EXECUTE('ALTER TABLE WFCREATECHILDWITABLE ALTER COLUMN WORKSTEPNAME NVARCHAR(255)')
						PRINT 'Table WFCREATECHILDWITABLE altered column WORKSTEPNAME to NVARCHAR(255) '
					END
			END TRY
			BEGIN CATCH
				exec  @v_logStatus = LogFailed 124,@v_scriptName
				RAISERROR('Block 124 Failed.',16,1)
				RETURN
			END CATCH
		END
	exec @v_logStatus = LogUpdate 124,@v_scriptName

	exec @v_logStatus = LogInsert 125,@v_scriptName,'Table WFCREATECHILDWITABLE altered column TYPE to NVARCHAR(1)'	
		BEGIN
			BEGIN TRY
				IF NOT EXISTS ( SELECT 1 FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'WFCREATECHILDWITABLE')
				AND  NAME = 'TYPE' AND length =2 AND type = 39)
				BEGIN
					exec  @v_logStatus = LogSkip 125,@v_scriptName
					EXECUTE('ALTER TABLE WFCREATECHILDWITABLE ALTER COLUMN TYPE NVARCHAR(1)')
					PRINT 'Table WFCREATECHILDWITABLE altered column TYPE to NVARCHAR(1) '
						
				END
			END TRY
			BEGIN CATCH
				exec  @v_logStatus = LogFailed 125,@v_scriptName
				RAISERROR('Block 125 Failed.',16,1)
				RETURN
			END CATCH
		END
	exec @v_logStatus = LogUpdate 125,@v_scriptName

	exec @v_logStatus = LogInsert 126,@v_scriptName,'Table WFCREATECHILDWITABLE altered column GENERATESAMEPARENT to NVARCHAR(1)'	
		BEGIN
			BEGIN TRY
					IF NOT EXISTS ( SELECT 1 FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'WFCREATECHILDWITABLE')
					AND  NAME = 'GENERATESAMEPARENT' AND length =2 AND type = 39)
					BEGIN
						exec  @v_logStatus = LogSkip 126,@v_scriptName
						EXECUTE('ALTER TABLE WFCREATECHILDWITABLE ALTER COLUMN GENERATESAMEPARENT NVARCHAR(1)')
						PRINT 'Table WFCREATECHILDWITABLE altered column GENERATESAMEPARENT to NVARCHAR(1) '
					END			
			END TRY
			BEGIN CATCH
				exec  @v_logStatus = LogFailed 126,@v_scriptName
				RAISERROR('Block 126 Failed.',16,1)
				RETURN
			END CATCH
		END
	exec @v_logStatus = LogUpdate 126,@v_scriptName

	exec @v_logStatus = LogInsert 127,@v_scriptName,'Recreating clustered PK (PROCESSDEFID , TRIGGERID) in WFCREATECHILDWITABLE'	
		BEGIN
			BEGIN TRY
				exec  @v_logStatus = LogSkip 127,@v_scriptName
				BEGIN
					SET @constrnName = ''
					SELECT @constrnName=name
					FROM sys.key_constraints
					WHERE type = 'PK' AND OBJECT_NAME(parent_object_id) = N'WFCREATECHILDWITABLE'
					IF (@constrnName IS NOT NULL AND (LEN(@constrnName) > 0))
					BEGIN
						EXECUTE ('alter table WFCREATECHILDWITABLE drop constraint ' + @constrnName)  
						PRINT 'Table WFCREATECHILDWITABLE altered, constraint  is dropped.'	
						EXECUTE ('alter table WFCREATECHILDWITABLE ADD CONSTRAINT '+ @constrnName +' PRIMARY KEY CLUSTERED (PROCESSDEFID , TRIGGERID)')
						PRINT 'Table WFCREATECHILDWITABLE altered, Primary key created.'
					END
					ELSE
					BEGIN
					EXECUTE ('alter table WFCREATECHILDWITABLE ADD PRIMARY KEY CLUSTERED (PROCESSDEFID , TRIGGERID)')
					PRINT 'Table WFCREATECHILDWITABLE altered, Primary key created.'
					END
				END	
			END TRY
			BEGIN CATCH
				exec  @v_logStatus = LogFailed 127,@v_scriptName
				RAISERROR('Block 127 Failed.',16,1)
				RETURN
			END CATCH
		END
	exec @v_logStatus = LogUpdate 127,@v_scriptName

	exec @v_logStatus = LogInsert 128,@v_scriptName,'CREATE TABLE pmsversioninfo'	
		BEGIN
			BEGIN TRY
			
				IF NOT EXISTS(SELECT * FROM sysObjects WHERE NAME = 'pmsversioninfo')
				BEGIN
					exec  @v_logStatus = LogSkip 128,@v_scriptName
					EXECUTE('CREATE TABLE pmsversioninfo(
					product_acronym varchar(100),
					label varchar(100) ,
					previouslabel varchar(100),
					updatedon datetime DEFAULT GETDATE()
					)') 
			  
					PRINT 'Table pmsversioninfo created successfully'
				END
			END TRY
			BEGIN CATCH
				exec  @v_logStatus = LogFailed 128,@v_scriptName
				RAISERROR('Block 128 Failed.',16,1)
				RETURN
			END CATCH
		END
	exec @v_logStatus = LogUpdate 128,@v_scriptName

	exec @v_logStatus = LogInsert 129,@v_scriptName,'Inserting values in pmsversioninfo'	
		BEGIN
			BEGIN TRY
				IF NOT EXISTS(SELECT *  
					FROM pmsversioninfo  
					WHERE label = 'LBL_SUP_006_14112014' AND product_acronym='OF'  )
				BEGIN
				exec  @v_logStatus = LogSkip 129,@v_scriptName
				BEGIN TRANSACTION trans
				--date format YYYY/MM/DD
				----INSERT INTO pmsversioninfo(product_acronym,label, previouslabel) VALUES ('OF','LBL_SUP_006_14112014','')
				EXECUTE('INSERT INTO pmsversioninfo(product_acronym,label, previouslabel) VALUES (''OF'',''LBL_SUP_006_14112014'','''')')
				COMMIT TRANSACTION trans
				END
			END TRY
			BEGIN CATCH
				exec  @v_logStatus = LogFailed 129,@v_scriptName
				RAISERROR('Block 129 Failed.',16,1)
				RETURN
			END CATCH
		END
	exec @v_logStatus = LogUpdate 129,@v_scriptName

	exec @v_logStatus = LogInsert 130,@v_scriptName,'Inserting values in WFCabVersionTable'	
		BEGIN
			BEGIN TRY
			exec  @v_logStatus = LogSkip 130,@v_scriptName
				BEGIN TRANSACTION trans
					EXECUTE('INSERT INTO WFCabVersionTable(cabVersion, creationDate, lastModified, Remarks, Status) VALUES (N''9.0'', GETDATE(), GETDATE(), N''END of Upgrade.sql for SU6'', N''Y'')')
					EXECUTE('INSERT INTO WFCabVersionTable(cabVersion, creationDate, lastModified, Remarks, Status) VALUES (N''9.0_SU6'', GETDATE(), GETDATE(), N''END of Upgrade.sql for SU6'', N''Y'')')
					COMMIT TRANSACTION trans
			
			END TRY
			BEGIN CATCH
				exec  @v_logStatus = LogFailed 130,@v_scriptName
				RAISERROR('Block 130 Failed.',16,1)
				RETURN
			END CATCH
		END
	END

	exec @v_logStatus = LogUpdate 130,@v_scriptName
	END
~

		PRINT 'Executing procedure Upgrade ........... '
		EXEC Upgrade
~			

DROP PROCEDURE Upgrade

~

