/*__________________________________________________________________________________-
		NEWGEN SOFTWARE TECHNOLOGIES LIMITED

	Group				: Application – Products
	Product / Project		: WorkFlow 6.1.2
	Module				: Transaction Server
	File NAME			: Upgrade.sql (MS Sql Server)
	Author				: Ruhi Hira
	Date written (DD/MM/YYYY)	: 20/08/2005
	Description			: Upgrade Script for OF [6.0.2 to 6.1.2].
					  Code included in PRTUpgradeScriptPost.sql.
____________________________________________________________________________________-
			CHANGE HISTORY
____________________________________________________________________________________-
Date		Change By		Change Description (Bug No. (If Any))
29/09/2005	Ruhi Hira		SrNo-1.
29/12/2005	Ruhi Hira		SrNo-2.
03/01/2006	Ruhi Hira		WFS_6.1.2_008, WFS_6.1.2_009.
10/01/2006	Mandeep Kaur		SrNo-3
12/01/2006	Mandeep Kaur		WFS_6.1.2_025
13/01/2006	Mandeep Kaur		WFS_6.1.2_031
19/01/2006	Harmeet Kaur		WFS_6.1.2_037
20/01/2006	Harmeet Kaur		WFS_6.1.2_042
25/01/2006	Ashish Mangla		WFS_6.1.2_043											   
28/08/2006	Ruhi Hira		Bugzilla Id 95.
05/02/2007	Varun Bhansaly		Bugzilla Id 442
08/02/2007	Varun Bhansaly		Bugzilla Id 74
08/02/2007	Ruhi Hira		SrNo-5.
05/03/2007	Varun Bhansaly	Bugzilla Id 479
23/04/2007	Varun Bhansaly	New Column ActionCalFlag to ActionOperationTable for Calendar
04/05/2007	Varun Bhansaly	1. Bugzilla Id 458 (Archive - Support for archiving documents on diff app server / domain/ instance)
							2. Calendar NAME should not be Unique
28/05/2007	Varun Bhansaly	MultiLingual Support (2 tables added)
28/05/2007 	Varun Bhansaly	Bugzilla Id 442 (Important Indexes missing in Omniflow 6x cabinet creation script)
							New Tables for Report as well as New Indexes On the new Tables
28/05/2007 	Varun Bhansaly	Bugzilla Id 690 (Delete On collect - configuration)
28/05/2007	Varun Bhansaly	Bugzilla Id 819 (Scripts to be verified in cab creation)
28/05/2007	Varun Bhansaly	Re-structuring of Script (All Create Indexes put together & All Create Tables put together)
21/06/2007  Varun Bhansaly	Removed Hard Coded Cabinet Version
21/06/2007  Varun Bhansaly  datatype of Column description of Table InterfaceDescLanguageTable changed
22/06/2007  Varun Bhansaly  Bugzilla Id 1283 ([Cabinet Upgrade] Wrong check in case of PSRegisterationTable)
04/07/2007  Varun Bhansaly	SrNo-5 (Separate checks for TatCalFlag & ExpCalFlag)
							Bugzilla Id 690 (Delete On collect - configuration)
23/07/2007	Varun Bansaly   Added SuccesLogTable, FailureLogTable
29/10/2007	Varun Bhansaly	SrNo-6, WFQuickSearchTable + IDX1_WFQuickSearchTable
29/10/2007	Varun Bhansaly	SrNo-7, WFDurationTable
29/10/2007	Varun Bhansaly	SrNo-8, WFCommentsTable + IDX1_WFCommentsTable
29/10/2007	Varun Bhansaly	SrNo-9, WFFilterTable
19/12/2007	Varun Bhansaly	SrNo-10, Generic Queue Filter - Filter On Queue
29/10/2007	Varun Bhansaly	Bugzilla Id 1677 ([Cab Creation] Index missing on VarAliasTable)
19/12/2007	Varun Bhansaly	Bugzilla Id 1027 (All DDL Statements should be done through CabCreation Script only)
30/10/2007	Varun Bhansaly	Bugzilla Id 1645 (Password not encrypted in ArchiveTable and ExtDBConfTable)
19/12/2007	Varun Bhansaly	Bugzilla Id 1687 ([Cab Creation + Upgrade] WFDataStructureTable : Primary key violation)
19/12/2007	Varun Bhansaly	SrNo-11, WFExportTable + IDX1_WFExportTable 
19/12/2007	Varun Bhansaly	SrNo-12, WFDataMapTable + IDX1_WFDataMapTable
19/12/2007	Varun Bhansaly	SrNo-13, WFRoutingServerInfo
20/12/2007	Varun Bhansaly	Bugzilla Id 1718, ([Multi Exception Raise Clear] No need to have function in default value for ActiondateTime)
20/12/2007	Varun Bhansaly	Bugzilla Id 1800, ([CabCreation] New parameter type 12 [boolean] to be considered)
20/12/2007	Varun Bhansaly	Bugzilla Id 2817, (OD 6.0 UTF-8 encoding issue - All Databases)
07/01/2008	Varun Bhansaly	Bugzilla Id 3108, (Column NAME in WFSwimLaneTable are not proper...)
25/01/2008	Varun Bhansaly	Bugzilla Id 1719, ([CabCreation + Upgrade] Indexes required on ExceptionTable & ExceptionHistoryTable)
28/01/2008	Varun Bhansaly	Entry in WFCabVersionTable for HOTFIX_6.2_036
28/01/2008	Varun Bhansaly	WFCabVersionTable, Column Remarks size increased to 255
							WFCabVersionTable, Column cabVersion size increased to 255
28/01/2008	Varun Bhansaly	Bugzilla Id 1774, ([STREAMDEFTABLE] primary Key)
28/01/2008	Varun Bhansaly	Bugzilla Id 1788, (index not used in WFDataStructureTable in PostgreSQL.)
06/02/2008	Varun Bhansaly	Bugzilla Id 3682, (Enhancements in Web Services)
28/01/2008	Varun Bhansaly	Bugzilla Id 1788, (index not used in WFDataStructureTable in PostgreSQL.)
11/02/2008	Varun Bhansaly	ArchiveTable - AppServerPort size changed to 5
11/02/2008	Varun Bhansaly	Bugzilla Id 3284
12/02/2008	Varun Bhansaly	ArchiveTable - PortId size changed to 5
24/04/2008	Ashish Mangla	Bugzilla Bug 4062 (Arithmetic Overflow)
23/04/2008	Ishu Saraf		SrNo-14, Added Table WFTypeDescTable, WFTypeDefTable, WFUDTVarMappingTable, WFVarRelationTable
23/04/2008	Ishu Saraf		SrNo-14, Added column VariableId, VarPrecison, Unbounded to VarMappingTable
										Primary Key updated in VarMappingTable
										Altering Constraint on VarMappingTable
23/04/2008	Ishu Saraf		SrNo-14, Added column VariableId to ActivityAssociationTable
									 Primary Key updated in ActivityAssociationTable
23/04/2008	Ishu Saraf		SrNo-14, Added column VariableId_1, VarFieldId_1, VariableId_2, VarFieldId_2  to RuleConditionTable				
23/04/2008	Ishu Saraf		SrNo-14, Added column VariableId_1, VarFieldId_1, VariableId_2, VarFieldId_2, VariableId_3, VarFieldId_3, FunctionType  to RuleOperationTable
23/04/2008	Ishu Saraf		SrNo-14, Added column VariableId, VarFieldId to ExtMethodParamMappingTable
23/04/2008	Ishu Saraf		SrNo-14, Added column FunctionType to WFWebServiceTable
										Altering Constraint on WFWebServiceTable
23/04/2008	Ishu Saraf		SrNo-14, Added column Width, Height to ActivityTable
05/05/2008	Ishu Saraf		SrNo-14, Added column Unbounded to EXTMethodParamDefTable
05/05/2008	Ishu Saraf		SrNo-14, Added column Unbounded to WFDataStructureTable
09/05/2008	Ishu Saraf		SrNo-14, Added table WFDataObjectTable and WFGroupBoxTable
14/05/2008	Ishu Saraf		SrNo-14, Added column ExtensionTypeId in WFTypeDefTable
14/05/2008	Ishu Saraf		SrNo-14, Alter Column precision to VarPrecision in VarMappingTable and WFUDTVarMappingTable
14/05/2008	Ishu Saraf		SrNo-14, Added table WFAdminLogTable
14/05/2008	Ishu Saraf		DROP WFParamMappingBuffer
14/05/2008	Ishu Saraf		SrNo-14, Altering constraint of ExtMethodDefTable,it can have values E/ W/ S
24/05/2008	Ishu Saraf		SrNo-14, Primary key constraint modified in WFDataOBjectTable & WFGroupBoxTable
28/05/2008	Ishu Saraf		SrNo-14, Default value added to columns Height & width of ActivityTAble
05/06/2008	Ishu Saraf		SrNo-14, ExtMethodDefTable - New WF Type 15, 16
05/06/2008	Ishu Saraf		SrNo-14, ExtMethodParamDefTable - New WF Type 15, 16
05/06/2008	Ishu Saraf		SrNo-14, Index Created on ActivityAssociationTable
06/06/2008	Ishu Saraf		SrNo-14, Bugzilla BugId 5066 Primary Key for ActivityAssociationTable changed back to (ProcessdefId, ActivityId, DefinitionType, DefinitionId)
07/06/2008	Ishu Saraf		SrNo-14, Ordering of VariableId in VarMappingTable and ActivityAssociationTAble
09/06/2008	Ishu Saraf		SrNo-14, Bugzilla Bug 5044 (UserDiversionTable, keep user name also in the table)
14/06/2008	Ishu Saraf		Entry in WFCabVersionTable for 7.2_RuleConditionTable
							Entry in WFCabVersionTable for 7.2_RuleOperationTable
							Entry in WFCabVersionTable for 7.2_ExtMethodParamMappingTable
							Entry in WFCabVersionTable for 7.2_VarMappingTable
							Entry in WFCabVersionTable for 7.2_UserDiversionTable
09/07/2008	Ishu Saraf		Bugzilla Bug Id 5062
21/07/2008	Ishu Saraf		Ordering of VariableId and VarFieldId in RuleOperationTable, RuleConditionTable and ExtMethodParamMappingTable
22/07/2008	Ishu Saraf		Added WFCurrentRouteLogTable and WFHistoryRouteLOgTable
22/07/2008	Ishu Saraf		Created Index on WFCurrentRouteLogTable and WFHistoryRouteLogTable
22/07/2008	Ishu Saraf		Created Trigger on WFCurrentRouteLogTable
21/08/2008	Ishu Saraf		SrNo-14, Added column VariableId_1, VarFieldId_1, VariableId_2, VarFieldId_2  to ActionConditionTable, DataSetTriggerTable, ScanActionsTable
21/08/2008	Ishu Saraf		SrNo-14, Added column VariableId_1, VarFieldId_1, VariableId_2, VarFieldId_2, VariableId_3, VarFieldId_3 to ActionOperationTable
21/08/2008	Ishu Saraf		SrNo-14, Added column VariableId, VarFieldId to WFDataMapTable, DataEntryTriggerTable, ArchiveDataMapTable, WFJMSSubscribeTable
21/08/2008	Ishu Saraf		SrNo-14, Added column VariableId_1, VarFieldId_1 to ToDoListDefTable
21/08/2008	Ishu Saraf		SrNo-14, Added column VariableIdTo, VarFieldIdTo, VariableIdFrom, VarFieldIdFrom, VariableIdCc, VarFieldIdCc to MailTriggerTable
21/08/2008	Ishu Saraf		SrNo-14, Added column VariableIdTo, VarFieldIdTo, VariableIdFrom, VarFieldIdFrom, VariableIdCc, VarFieldIdCc, VariableIdFax, VarFieldIdFax to PrintFaxEmailTable
21/08/2008	Ishu Saraf		SrNo-14, Added column VariableId, VarFieldId, DisplayName to ImportedProcessDefTable
21/08/2008	Ishu Saraf		SrNo-14, Added column ImportedVariableId, ImportedVarFieldId, MappedVariableId, MappedVarFieldId, DisplayName to InitiateWorkItemDefTable
21/08/2008	Ishu Saraf		Entry in WFCabVersionTable for 7.2_ActionConditionTable
							Entry in WFCabVersionTable for 7.2_MailTriggerTable
							Entry in WFCabVersionTable for 7.2_DataSetTriggerTable
							Entry in WFCabVersionTable for 7.2_PrintFaxEmailTable
							Entry in WFCabVersionTable for 7.2_ScanActionsTable
							Entry in WFCabVersionTable for 7.2_ToDoListDefTable
							Entry in WFCabVersionTable for 7.2_ImportedProcessDefTable
							Entry in WFCabVersionTable for 7.2_InitiateWorkitemDefTable
01/09/2008	Ishu Saraf		Added column BlockId to ActivityTable
01/09/2008	Ishu Saraf		Added column VarPrecision to ExtDBFieldDefinitionTable
06/10/2008	Ishu Saraf		Added Table WFAutoGenInfoTable
07/10/2008	Ishu Saraf		Changing QueueType for Query workstep in QueueDefTable
08/10/2008	Ishu Saraf		Changing ActivityType for JMS Subscriber and WebService Invoker in ActivityTable
08/10/2008	Ishu Saraf		Added Table WFProxyInfo
21/10/2008	Ishu Saraf		Added WFSearchVariableTable & Search Criteria in WFSearchVariableTable 
30/10/2008	Ishu Saraf		Added column associatedUrl in ActivityTable
31/10/2008	Ishu Saraf		Added column BlockName in WFGroupBoxTable
22/11/2008	Ishu Saraf		Added column ArgList in TemplateDefinitionTable and remove from GenerateResponseTable
22/11/2008	Ishu Saraf		Added Table WFAuthorizationTable, WFAuthorizeQueueDefTable, WFAuthorizeQueueStreamTable, WFAuthorizeQueueUserTable, WFAuthorizeProcessDefTable, WFCorrelationTable
22/11/2008	Ishu Saraf		Changing name of WFCorrelationTable to WFSoapReqCorrelationTable
22/11/2008	Ishu Saraf		Added column VariableId_Years, VarFieldId_Years, VariableId_Months, VarFieldId_Months, VariableId_Days, VarFieldId_Days, VariableId_Hours, VarFieldId_Hours, VariableId_Minutes, VarFieldId_Minutes, VariableId_Seconds, VarFieldId_Seconds in WFDurationTable
22/11/2008	Ishu Saraf		Entry in WFCabVersionTable for 7.2_WFDurationTable
27/11/2008	Ishu Saraf		Addded column ReplyPath, AssociatedActivityId  to WFWebServiceTable 
27/11/2008	Ishu Saraf		Added Table WFWSAsyncResponseTable 
28/11/2008	Ishu Saraf		Unique constraint and Index added to WFWSAsyncResponseTable 
06/12/2008	Ishu Saraf		Added column allowSOAPRequest to ActivityTable
06/12/2008	Ishu Saraf		Changes for AssociatedActivityId for JMS Subscriber in case of Asynchronous WebService Invocation
06/12/2008	Ishu Saraf		Added column QueueFilter to WFAuthorizeQueueDefTable
08/12/2008	Ishu Saraf		Added column AssociatedActivityId to ActivityTable
15/12/2008	Ishu Saraf		Added WFScopeDefTable, WFEventDefTable, WFActivityScopeAssocTable
15/12/2008	Ishu Saraf		Added column EventId to ActivityTable
24/12/2008	Ishu Saraf		Size of ProxyPassword column in WFProxy is changed from 64 to 512
05/01/2009	Ishu Saraf		Bugzilla BugId 7588 (Increase size of ColumnName from 64 to 255)
08/01/2009	Ishu Saraf		Bugzilla BugId 7574 (New columns added to WFSoapReqCorrelationTable)
12/01/2009	Ashish Mangla	        Bugzilla Bug 7626(String or binary data would be truncated)
16/01/2009	Ishu Saraf		Change datatype of column delaytime in SummaryTable
22/04/2009      Ananta Handoo           SrNo-15 SAP Implementation -  Five tables added WFSAPConnectTable, WFSAPGUIDefTable, WFSAPGUIFieldMappingTable, 
	                                WFSAPGUIAssocTable, WFSAPAdapterAssocTable 
22/04/2009      Ananta Handoo           Altering constraint on ExtMethodDefTable SrNo-15 by Ananta Handoo 
__________________________________________________________________________________-*/

If Exists (SELECT 1 FROM SYSObjects WHERE NAME = 'Upgrade' AND xType = 'P')
Begin
	Drop Procedure Upgrade
	PRINT 'As Procedure Upgrade exists dropping old procedure ........... '
End

PRINT 'Creating procedure Upgrade ........... '
~

Create Procedure Upgrade AS
Begin

	DECLARE @constraintName				VARCHAR(40)
	DECLARE @tableId					INT
	DECLARE @v_Exists					INT
	DECLARE @v_msgCount					INT
	DECLARE @v_cabVersionId				INT
	DECLARE @v_msgStr					NVARCHAR(128) 
	DECLARE @processDefId				INT 		 
	DECLARE @QueueId 					INT
	DECLARE @QueueType 					NVARCHAR(1)
	DECLARE @ActivityId					INT 
	DECLARE @ActivityType				INT
	DECLARE @TargetActivityId			INT
	DECLARE @v_STR1						NVARCHAR(2000)
	DECLARE @v_STR2						NVARCHAR(2000)
	DECLARE @v_paramDefinition1			NVARCHAR(2000)
	DECLARE @v_paramDefinition2			NVARCHAR(2000)
	

	IF NOT EXISTS(SELECT * FROM sysObjects WHERE NAME = 'WFCabVersionTable')
	Begin
		Create Table WFCabVersionTable (
			cabVersion		NVARCHAR(255) NOT NULL,
			cabVersionId	INT IDENTITY (1,1) PRIMARY KEY,
			creationDate	DATETIME,
			lastModified	DATETIME,
			Remarks			NVARCHAR(255) NOT NULL,
			Status			NVARCHAR(1)
		)
		PRINT 'Table WFCabVersionTable created successfully'
	End
	ELSE
	BEGIN
		EXECUTE('Alter Table WFCabVersionTable Alter Column cabVersion NVARCHAR(255)')
		PRINT 'Table WFCabVersionTable altered with Column cabVersion size increased to 255'
		EXECUTE('Alter Table WFCabVersionTable Alter Column Remarks NVARCHAR(255)')
		PRINT 'Table WFCabVersionTable altered with Column Remarks size increased to 255'
	END

	SELECT @v_msgCount = COUNT(*) FROM WFMessageTable
	IF(@v_msgCount > 0)
	BEGIN
		SELECT @v_cabVersionId = @@IDENTITY
		UPDATE WFCabVersionTable SET Remarks = Remarks + N' - Upgrade Halted! WFMessageTable contains ' + CONVERT(NVARCHAR(10), @v_msgCount) + N' unprocessed messages. To process these messages run Message Agent. Thereafter, Upgrade once again.' WHERE cabVersionId =  @v_cabVersionId
		SELECT @v_msgStr = 'Upgrade Halted! WFMessageTable contains ' + CONVERT(NVARCHAR(10), @v_msgCount) + ' unprocessed messages. To process these messages run Message Agent. Thereafter, run Upgrade once again.'
		RAISERROR(@v_msgStr, 16, 1) 
	END


	IF NOT EXISTS(SELECT * FROM SYSCOLUMNS WHERE NAME='ActionDateTime' AND id = (SELECT id FROM SYSOBJECTS WHERE NAME = 'WFMessageTable'  AND XTYPE='U' ))
	Begin
			Execute ('ALTER TABLE WFMessageTable ADD ActionDateTime DATETIME')
			PRINT 'Table WFMessageTable altered with new Column ActionDateTime'
	End

	IF NOT EXISTS(SELECT * FROM SYSOBJECTS WHERE NAME = 'WFMessageInProcessTable')
	Begin
		Create Table WFMessageInProcessTable (
			messageId		INT, 
			message			NTEXT, 
			lockedBy		NVARCHAR(63), 
			status			NVARCHAR(1),
			ActionDateTime	DATETIME
		)
		PRINT 'Table WFMessageInProcessTable created successfully'
	End
	ELSE
	Begin
		IF NOT EXISTS(SELECT * FROM SYSCOLUMNS WHERE NAME='ActionDateTime' AND id = (SELECT id FROM SYSOBJECTS WHERE NAME = 'WFMessageInProcessTable' AND XTYPE='U'))
		Begin
			Execute ('ALTER TABLE WFMessageInProcessTable ADD ActionDateTime DATETIME')
			PRINT 'Table WFMessageInProcessTable altered with new Column ActionDateTime'
		End
	End

	IF NOT EXISTS(SELECT * FROM SYSOBJECTS WHERE NAME = 'WFFailedMessageTable')
	Begin
		Create Table WFFailedMessageTable (
			messageId			INT, 
			message				NTEXT, 
			lockedBy			NVARCHAR(63), 
			status				NVARCHAR(1),
			failureTime			DATETIME,
			ActionDateTime			DATETIME
		)
		PRINT 'Table WFFailedMessageTable created successfully'
	End
	ELSE
	Begin
		IF NOT EXISTS(SELECT * FROM SYSCOLUMNS WHERE  NAME='ActionDateTime' AND id = (SELECT id FROM SYSOBJECTS WHERE NAME = 'WFFailedMessageTable' AND XTYPE='U'))
		Begin
			Execute ('ALTER TABLE WFFailedMessageTable ADD ActionDateTime DATETIME')
			PRINT 'Table WFFailedMessageTable altered with new Column ActionDateTime'
		End
	End

	Begin Transaction Move

		Execute ('Insert Into WFFailedMessageTable
			SELECT messageId, message, null, status, getDate(), actionDateTime
			FROM WFMessageTable 
			Where status = ''F''')
		IF(@@error <> 0)
		Begin
			PRINT 'Error while inserting data FROM WFMessageTable to WFFailedMessageTable'
			Rollback Transaction Move
			Return
		End

		Delete FROM WFMessageTable Where status = 'F'
		IF(@@error <> 0)
		Begin
			PRINT 'Error while deleting failed records FROM WFMessageTable'
			Rollback Transaction Move
			Return
		End

		Update WFMessageTable Set LockedBy = null
		IF(@@error <> 0)
		Begin
			PRINT 'Error while updating lockedBy column in WFMessageTable'
			Rollback Transaction Move
			Return
		End

	Commit Transaction Move

	IF NOT EXISTS(SELECT * FROM sysObjects WHERE NAME = 'WFEscalationTable')
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
		PRINT 'Table WFEscalationTable created successfully'

	End

	IF NOT EXISTS(SELECT * FROM sysObjects WHERE NAME = 'WFEscInProcessTable')
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
		PRINT 'Table WFEscInProcessTable created successfully'
	End


	IF NOT EXISTS(SELECT * FROM sysObjects WHERE NAME = 'WFJMSMESSAGETABLE')
	Begin
		CREATE TABLE WFJMSMESSAGETABLE (
         messageId		INT			identity (1, 1), 
         message		NTEXT			NOT NULL, 
         destination		NVarchar(256),
         entryDateTime		DateTime,
	 OperationType		NVarchar(1)		
		)
		PRINT 'Table WFJMSMESSAGETABLE created successfully'
	End

	IF NOT EXISTS(SELECT * FROM sysObjects WHERE NAME = 'WFJMSMessageInProcessTable')
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
	
		PRINT 'Table WFJMSMessageInProcessTable created successfully'
	End

	IF NOT EXISTS(SELECT * FROM sysObjects WHERE NAME = 'WFJMSFailedMessageTable')
	Begin
		Create Table WFJMSFailedMessageTable (
         messageId		 INT, 
         message		 NTEXT,  
         destination		 NVARCHAR(256), 
         entryDateTime		DateTime, 
         failureTime		DateTime ,
	 failureCause		NVARCHAR(2000),
	 OperationType		NVarchar(1)
	)
	
		PRINT 'Table WFJMSFailedMessageTable created successfully'
	End

	IF NOT EXISTS(SELECT * FROM sysObjects WHERE NAME = 'WFJMSDestInfo')
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
	
		PRINT 'Table WFJMSDestInfo created successfully'
	End

	IF NOT EXISTS(SELECT * FROM sysObjects WHERE NAME = 'WFJMSPublishTable')
	Begin
		CREATE TABLE WFJMSPublishTable
		(
		processDefId		INT,
		activityId		INT,
		destinationId		INT,
		Template		NTEXT
		)
	
		PRINT 'Table WFJMSPublishTable created successfully'
	End

	IF NOT EXISTS(SELECT * FROM sysObjects WHERE NAME = 'WFJMSSubscribeTable')
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
	
		PRINT 'Table WFJMSSubscribeTable created successfully'
	End

	/* SrNo-3 New Table for audit log configuration */
	IF NOT EXISTS(SELECT * FROM sysObjects WHERE NAME = 'WFVarStatusTable')
	Begin
		CREATE TABLE WFVarStatusTable 
		(
		ProcessDefId	int		NOT NULL ,
		VarName		nvarchar(50)	NOT NULL ,
		Status		nvarchar(1)	NOT NULL DEFAULT 'Y' CHECK (Status = 'Y' OR Status = 'N' )
		) 
		PRINT 'Table WFVarStatusTable created successfully'
	End
	
	/* SrNo-3 New Tables for audit log configuration */
	IF NOT EXISTS(SELECT * FROM sysObjects WHERE NAME = 'WFActionStatusTable')
	Begin
		CREATE TABLE WFActionStatusTable
		(
		ActionId	int		PRIMARY KEY ,
		Type		nvarchar(1)	NOT NULL DEFAULT 'C' CHECK (Type = 'C' OR Type = 'S' ),
		Status		nvarchar(1)	NOT NULL DEFAULT 'Y' CHECK (Status = 'Y' OR Status = 'N' )
		)
		PRINT 'Table WFActionStatusTable created successfully'
	End

	/* SrNo-5, Calendar Implementation - Ruhi Hira */
	IF NOT EXISTS(SELECT * FROM sysObjects WHERE NAME = 'WFCalDefTable')
	Begin
		CREATE TABLE WFCalDefTable(
			ProcessDefId	Int, 
			CalId		Int, 
			CalName		NVarchar(256)	NOT NULL,
			GMTDiff		Int,
			LastModifiedOn	DATETIME,
			Comments	NVarchar(1024),
			PRIMARY KEY	(ProcessDefId, CalId)
		)
		PRINT 'Table WFCalDefTable created successfully.'
		Insert into WFCalDefTable values(0, 1, 'DEFAULT 24/7', 530, getDate(), 'This is the default calendar')
		PRINT 'Default calendar created in WFCalDefTable.'
	End

	IF NOT EXISTS(SELECT * FROM sysObjects WHERE NAME = 'WFCalRuleDefTable')
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
		PRINT 'Table WFCalRuleDefTable created successfully'
	End

	IF NOT EXISTS(SELECT * FROM sysObjects WHERE NAME = 'WFCalHourDefTable')
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
		PRINT 'Table WFCalHourDefTable created successfully'
		Insert into WFCalHourDefTable values (0, 1, 0, 1, 0000, 2400)
		PRINT 'Hour range for default calendar added to WFCalHourDefTable.'
	End

	IF NOT EXISTS(SELECT * FROM sysObjects WHERE NAME = 'WFCalendarAssocTable')
	Begin
		CREATE TABLE WFCalendarAssocTable(
			CalId		Int		NOT NULL,
			ProcessDefId	Int		NOT NULL,
			ActivityId	Int		NOT NULL,
			CalType		NVarChar(1)	NOT NULL,
			UNIQUE (processDefId, activityId)
		)
		PRINT 'Table WFCalendarAssocTable created successfully'
	End

/*	Update ProcessInstanceTable set ExpectedProcessdelay = null */

	IF NOT EXISTS ( SELECT * FROM sysColumns 
			WHERE 
			id = (SELECT id FROM sysObjects WHERE NAME = 'QueueUserTable')
			AND  NAME = 'QueryFilter'
			)
	BEGIN
		ALTER TABLE QueueUserTable ADD QueryFilter Nvarchar(2000)
	END

	/* SrNo-1, WFS_6.1_039, For license implementation, type of column data is changed FROM Text to NVarchar(2000) - Ruhi */
	/* Changed By Varun Bhansaly On 22/06/2007 for Bugzilla Id 1283 */

	If exists (	SELECT 1 
			FROM SYSColumns 
			Where id = (SELECT id FROM sysObjects WHERE NAME = 'PSRegisterationTable' and xType = 'U')
			AND NAME = 'Data' 
			AND xType = 35 )
	Begin
		SELECT PSId, PSName, Type, SessionId, ProcessDefId, Convert(NVarchar(2000), Data) Data
		Into	TempPSRegisterationTable
		FROM	PSRegisterationtable

		Execute('Drop Table PSRegisterationtable')

		Execute SP_RENAME 'TempPSRegisterationtable', 'PSRegisterationtable'
	End

	/* SrNo-2, New tables for WebServices invoker - Mandep Kaur/ Ruhi Hira */
	/* Create table WFDataStructureTable, WFS_6.1.2_008 */
	/* Changed by Varun Bhansaly On 28/01/2008 for Bugzilla Id 1788 */
	IF NOT EXISTS (
		SELECT * FROM SYSObjects
		WHERE	NAME	= 'WFDataStructureTable'
		AND	xType	= 'U'
	)
	Begin
		EXECUTE('
			CREATE TABLE WFDataStructureTable (
				DataStructureId		Int,
				ProcessDefId		Int,
				ActivityId		Int,
				ExtMethodIndex		Int,
				NAME			NVarchar(256),
				Type			SmallInt,
				ParentIndex		Int,
				PRIMARY KEY		(ProcessDefId, ExtMethodIndex, DataStructureId)
			)
		')
	End

	/* Create table WFWebServiceTable */
	IF NOT EXISTS (
		SELECT * FROM SYSObjects
		WHERE	NAME	= 'WFWebServiceTable'
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
			WHERE NAME = 'ExtMethodParamDefTable' 
			AND xType = 'U'
		)
		AND NAME = 'DataStructureId'
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
			WHERE NAME = 'ExtMethodParamDefTable' 
			AND xType = 'U'
		)
		AND NAME = 'DataStructureId'
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
			WHERE NAME = 'ExtMethodParamMappingTable' 
			AND xType = 'U'
		)
		AND NAME = 'DataStructureId'
	)
	Begin
		EXECUTE('
			ALTER TABLE ExtMethodParamMappingTable ADD DataStructureId Int NULL
		')
	End

	/* Altering Constraint on ExtMethodDefTable, WFS_6.1.2_009 */
	SELECT @tableId = Id 
	FROM SYSObjects 
	WHERE NAME = 'ExtMethodDefTable'
	
	SELECT	@ConstraintName = B.NAME 
	FROM	SYSConstraints A, SYSObjects B
	WHERE	A.constId = B.Id 
	AND B.xtype	= 'C' 
	AND A.Id	= @tableId
	And A.colid = (SELECT colId 
			FROM SYSColumns 
			WHERE Id = @tableId 
			AND NAME = 'ReturnType')
	If(@@ROWCOUNT > 0)
	Begin
		Execute ('
			Alter Table ExtMethodDefTable 
				Drop CONSTRAINT ' + @constraintName
		)
		EXECUTE('
			ALTER TABLE ExtMethodDefTable ADD CONSTRAINT CK_EXTMETHOD_RET 
					CHECK (ReturnType in (0, 3, 4, 6, 8, 10, 11, 12, 14, 15, 16))
		')
	End

	/* Altering Constraint on ExtMethodParamDefTable */
	SELECT @tableId = Id 
	FROM SYSObjects 
	WHERE NAME = 'ExtMethodParamDefTable'
	
	SELECT	@ConstraintName = B.NAME 
	FROM	SYSConstraints A, SYSObjects B
	WHERE	A.constId = B.Id 
	AND B.xtype	= 'C' 
	AND A.Id	= @tableId
	And A.colid = (SELECT colId 
			FROM SYSColumns 
			WHERE Id = @tableId 
			AND NAME = 'ParameterType')
	If(@@ROWCOUNT > 0)
	Begin
		Execute ('
			Alter Table ExtMethodParamDefTable 
				Drop CONSTRAINT ' + @constraintName
		)
		EXECUTE('
			ALTER TABLE ExtMethodParamDefTable ADD CONSTRAINT CK_EXTMETHODPARAM_PARAM
					CHECK (ParameterType in (0, 3, 4, 6, 8, 10, 11, 12, 14, 15, 16))
		')
	End

	/* Altering Constraint on QueueStreamTable WFS_6.1.2_043 */
	IF NOT EXISTS( SELECT 1 FROM  queuestreamtable GROUP BY processdefid, ActivityId, StreamId having count(*) > 1 )
		Begin
			Alter Table queuestreamtable drop constraint QST_PRIM
			Alter Table queuestreamtable Add constraint QST_PRIM Primary Key (ProcessDefId, ActivityId, StreamId)
			PRINT 'Primary Key updated for QueueStreamTable'  
		End
	ELSE
		Begin
			PRINT 'Invalid Data in QueueStreamTable'
		End
	/* END Altering Constraint on QueueStreamTable WFS_6.1.2_043 */

	IF NOT EXISTS ( SELECT * FROM sysColumns 
			WHERE 
			id = (SELECT id FROM sysObjects WHERE NAME = 'ProcessDefTable')
			AND  NAME = 'TATCalFlag'
			)
	BEGIN
		EXECUTE('ALTER TABLE ProcessDefTable ADD TATCalFlag NVarChar(1) NULL')
		Execute ('Update ProcessDefTable set TATCalFlag = N''N'' ')
	END

	IF NOT EXISTS ( SELECT * FROM sysColumns 
			WHERE 
			id = (SELECT id FROM sysObjects WHERE NAME = 'ActivityTable')
			AND  NAME = 'TATCalFlag'
			)
	BEGIN
		EXECUTE('ALTER TABLE ActivityTable ADD TATCalFlag NVarChar(1) NULL')
		Execute ('Update ActivityTable set TATCalFlag = N''N''')
	END

	IF NOT EXISTS ( SELECT * FROM sysColumns 
			WHERE 
			id = (SELECT id FROM sysObjects WHERE NAME = 'ActivityTable')
			AND  NAME = 'ExpCalFlag'
			)
	BEGIN
		EXECUTE('ALTER TABLE ActivityTable ADD ExpCalFlag NVarChar(1) NULL')
		Execute ('Update ActivityTable set ExpCalFlag = N''N'' ')
	END

	/* 28/05/2007 Bugzilla Id 690 Varun Bhansaly */ 
	IF NOT EXISTS ( SELECT * FROM sysColumns 
			WHERE 
			id = (SELECT id FROM sysObjects WHERE NAME = 'ActivityTable')
			AND  NAME = 'DeleteOnCollect'
			)
	BEGIN
		EXECUTE('ALTER TABLE ActivityTable ADD DeleteOnCollect NVarChar(1) NULL')
		EXECUTE('UPDATE ActivityTable set DeleteOnCollect = N''N'' where ActivityType = 6')
	END

	IF NOT EXISTS ( SELECT * FROM sysColumns 
			WHERE 
			id = (SELECT id FROM sysObjects WHERE NAME = 'RuleOperationTable')
			AND  NAME = 'RuleCalFlag'
			)
	BEGIN
		EXECUTE('ALTER TABLE RuleOperationTable ADD RuleCalFlag NVarCHAR(1) NULL')
		Execute ('Update RuleOperationTable set RuleCalFlag = N''N'' ' )
	END

	IF NOT EXISTS ( SELECT * FROM sysColumns 
			WHERE 
			id = (SELECT id FROM sysObjects WHERE NAME = 'ActionOperationTable')
			AND  NAME = 'ActionCalFlag'
			)
	BEGIN
		EXECUTE('ALTER TABLE ActionOperationTable ADD ActionCalFlag NVarCHAR(1) NULL')
		Execute ('Update ActionOperationTable set ActionCalFlag = N''N'' ' )
	END

	/* Bugzilla Bug 458 */
	IF NOT EXISTS ( SELECT * FROM sysColumns 
			WHERE 
			id = (SELECT id FROM sysObjects WHERE NAME = 'ArchiveTable')
			AND  NAME = 'AppServerIP'
			)
	BEGIN
		EXECUTE('ALTER TABLE ArchiveTable ADD AppServerIP NVARCHAR(15) NULL')
	END

	/* Bugzilla Bug 458 */
	IF NOT EXISTS ( SELECT * FROM sysColumns 
			WHERE 
			id = (SELECT id FROM sysObjects WHERE NAME = 'ArchiveTable')
			AND  NAME = 'AppServerPort'
			)
	BEGIN
		EXECUTE('ALTER TABLE ArchiveTable ADD AppServerPort NVARCHAR(4) NULL')
	END

	/* Bugzilla Bug 458 */
	IF NOT EXISTS ( SELECT * FROM sysColumns 
			WHERE 
			id = (SELECT id FROM sysObjects WHERE NAME = 'ArchiveTable')
			AND  NAME = 'AppServerType'
			)
	BEGIN
		EXECUTE('ALTER TABLE ArchiveTable ADD AppServerType NVARCHAR(255) NULL')
	END

	EXECUTE('Update ArchiveTable set AppServerIP = IPAddress , AppServerPort = PortID , AppServerType = null where AppServerIP is null or AppServerPort is null')

	/* 28/05/2007 Varun Bhansaly */ 
	/* Create table TemplateMultiLanguageTable */
	IF NOT EXISTS (
		SELECT * FROM SYSObjects
		WHERE	NAME	= 'TemplateMultiLanguageTable'
		AND	xType	= 'U'
	)
	Begin
		EXECUTE('
			CREATE TABLE TemplateMultiLanguageTable (
				ProcessDefId	INT				NOT NULL,
				TemplateId		INT				NOT NULL,
				Locale			NCHAR(5)		NOT NULL,
				TemplateBuffer	IMAGE			NULL
			)
		')
	End

	/* 28/05/2007 Varun Bhansaly */ 
	/* Create table InterfaceDescLanguageTable */
	IF NOT EXISTS (
		SELECT * FROM SYSObjects
		WHERE	NAME	= 'InterfaceDescLanguageTable'
		AND	xType	= 'U'
	)
	Begin
		EXECUTE('
			CREATE TABLE InterfaceDescLanguageTable (
				ProcessDefId	INT			NOT NULL,		
				ElementId		INT			NOT NULL,
				InterfaceID		INT			NOT NULL,
				Locale			NCHAR(5)	NOT NULL,
				Description		NVARCHAR(255)	NOT NULL
			)
		')
	End

	/* 28/05/2007 Bugzilla Id 819 Varun Bhansaly */ 
	/* Create table WFActivityReportTable */
	IF NOT EXISTS (
		SELECT * FROM SYSObjects
		WHERE	NAME	= 'WFActivityReportTable'
		AND	xType	= 'U'
	)
	Begin
		EXECUTE('
			CREATE TABLE WFActivityReportTable(
				ProcessDefId		Integer,
				ActivityId			Integer,
				ActivityName		Nvarchar(30),
				ActionDateTime		DateTime,
				TotalWICount		Integer,
				TotalDuration		Integer,
				TotalProcessingTime	Integer
			)
		')
	End
	ELSE
		Begin
			EXECUTE('ALTER TABLE WFActivityReportTable ALTER COLUMN TotalDuration BIGINT')
			EXECUTE('ALTER TABLE WFActivityReportTable ALTER COLUMN TotalProcessingTime BIGINT')
		End
	EXECUTE('ALTER TABLE SummaryTable ALTER COLUMN totalduration BIGINT')
	EXECUTE('ALTER TABLE SummaryTable ALTER COLUMN TotalProcessingTime BIGINT')
	EXECUTE('ALTER TABLE SummaryTable ALTER COLUMN delaytime BIGINT') /* Ishu Saraf 16/01/2009 */


	/* 28/05/2007 Bugzilla Id 819 Varun Bhansaly */ 
	/* Create table WFReportDataTable */
	IF NOT EXISTS (
		SELECT * FROM SYSObjects
		WHERE	NAME	= 'WFReportDataTable'
		AND	xType	= 'U'
	)
	Begin
		EXECUTE('
			CREATE TABLE WFReportDataTable(
				ProcessInstanceId	Nvarchar(63),
				WorkitemId			Integer,
				ProcessDefId		Integer NOT NULL,
				ActivityId			Integer,
				UserId				Integer,
				TotalProcessingTime	Integer
			)
		')
	End

	/* 28/05/2007 Bugzilla Id 819 Varun Bhansaly */ 
	/* Create table WFParamMappingBuffer */
	IF NOT EXISTS (
		SELECT * FROM SYSObjects
		WHERE	NAME	= 'WFParamMappingBuffer'
		AND	xType	= 'U'
	)
	Begin
		EXECUTE('
			CREATE TABLE WFParamMappingBuffer(
				processDefId			Integer,
				extMethodId				Integer,
				paramMappingBuffer      NTEXT
				UNIQUE(processdefid, extmethodid)
			)
		')
	End

	/* Added By Varun Bhansaly On 23/07/2007 */
	If Not Exists (SELECT * FROM SysObjects Where xType = 'U' and NAME = 'SuccessLogTable')
	Begin
		EXECUTE('
			CREATE TABLE SuccessLogTable(
				LogId INT,
				ProcessInstanceId NVARCHAR(63)
			)
		')
	End

	/* Added By Varun Bhansaly On 23/07/2007 */
	If Not Exists (SELECT * FROM SysObjects Where xType = 'U' and NAME = 'FailureLogTable')
	Begin
		EXECUTE('
			CREATE TABLE FailureLogTable(
				LogId INT,
				ProcessInstanceId NVARCHAR(63)
			)
		')
	End

	IF NOT EXISTS(SELECT * FROM SYSCOLUMNS WHERE NAME = 'MappingFile' AND id = (SELECT id FROM SYSOBJECTS WHERE NAME = 'ExtMethodDefTable' AND XTYPE='U' ))
	Begin
			Execute ('ALTER TABLE ExtMethodDefTable ADD MappingFile NVarChar(1)')
			PRINT 'Table ExtMethodDefTable altered with new Column MappingFile'
	End

	/* 
	   Added By   : Varun Bhansaly
	   Added On   : 09/02/2007
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
	/* Added By Varun Bhansaly On 29/10/2007 Bugzilla Id 1645 */
	Execute('Alter Table ArchiveTable Alter Column PassWD NVarchar(256)')

	IF NOT EXISTS ( SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'ArchiveTable')	AND  NAME = 'SecurityFlag')
	BEGIN
		Execute('ALTER TABLE archivetable ADD SecurityFlag NVARCHAR(1) CHECK (SecurityFlag IN (N''Y'', N''N''))')
		Execute('Update archivetable set SecurityFlag = N''N''')
		PRINT 'Table ArchiveTable altered with new Column SecurityFlag'
	END

	IF NOT EXISTS ( SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'ExtDBConfTable') AND  NAME = 'SecurityFlag')
	BEGIN
		Execute('ALTER TABLE ExtDBConfTable ADD SecurityFlag NVARCHAR(1) CHECK (SecurityFlag IN (N''Y'', N''N''))')
		Execute('Update ExtDBConfTable set SecurityFlag = N''N''')
		PRINT 'Table ExtDBConfTable altered with new Column SecurityFlag'
	END

	/** Added By Varun Bhansaly On 29/10/2007 Bugzilla Id 1687
	 ** Bugzilla Id 1687 modified according to Bugzilla Id 1788
	 **/
	EXECUTE('Alter table WFDataStructureTable alter column ExtMethodIndex Int NOT NULL')
	SELECT @ConstraintName = C.NAME FROM 
	SysObjects C
	WHERE C.XTYPE = 'PK' AND 
	C.ID IN (SELECT A.ConstId FROM SysConstraints A, SysObjects B WHERE A.ID = B.ID AND B.NAME = 'WFDataStructureTable')
	IF(@@ROWCOUNT > 0)
	BEGIN
		EXECUTE('Alter table WFDataStructureTable Drop Constraint ' + @ConstraintName)
		EXECUTE('Alter table WFDataStructureTable Add Constraint PK_WFDataStructureTable Primary Key (ProcessDefId, ExtMethodIndex, DataStructureId)')
		PRINT 'Primary Key updated for WFDataStructureTable'
	END

	/* Added By Varun Bhansaly On 29/10/2007 */
	IF NOT EXISTS (SELECT * FROM SysObjects Where xType = 'U' and NAME = 'WFQuickSearchTable')
	BEGIN
		EXECUTE('CREATE TABLE WFQuickSearchTable(
					VariableId			INT				IDENTITY(1,1),
					ProcessDefId		INT				NOT NULL,
					VariableName		NVARCHAR(64)	NOT NULL,
					Alias				NVARCHAR(64)	NOT NULL,
					SearchAllVersion	NVARCHAR(1)		NOT NULL,  
					CONSTRAINT UK_WFQuickSearchTable UNIQUE (Alias)
				)'
		)
		PRINT 'Table WFQuickSearchTable Created Successfully'
	END

	/* Added By Varun Bhansaly On 29/10/2007 */
	IF NOT EXISTS (SELECT * FROM SysObjects Where xType = 'U' and NAME = 'WFDurationTable')
	BEGIN
		EXECUTE('CREATE TABLE WFDurationTable(
					ProcessDefId	INT			NOT NULL,
					DurationId		INT			NOT NULL,
					WFYears			NVARCHAR(256),
					WFMonths		NVARCHAR(256),
					WFDays			NVARCHAR(256),
					WFHours			NVARCHAR(256), 
					WFMinutes		NVARCHAR(256), 
					WFSeconds		NVARCHAR(256),
					CONSTRAINT UK_WFDurationTable UNIQUE (ProcessDefId, DurationId)
				)'
		)
		PRINT 'Table WFDurationTable Created Successfully'
	END

	/* Added By Varun Bhansaly On 29/10/2007 */
	IF NOT EXISTS (SELECT * FROM SysObjects Where xType = 'U' and NAME = 'WFCommentsTable')
	BEGIN
		EXECUTE('CREATE TABLE WFCommentsTable(
					CommentsId			INT				IDENTITY(1,1)	PRIMARY KEY,
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
					CommentsType		INT				NOT NULL	CHECK(CommentsType IN (1, 2, 3))
				)'
		)
		PRINT 'Table WFCommentsTable Created Successfully'
	END

	/* Added By Varun Bhansaly On 29/10/2007 */
	/** 
	 * Algortihm :-
	 * If WFFilterTable doesnot exist, then 
	 *	1. if FilterTable exists, reName filterTable To WFFilterTable, reName columns also.
	 *  2. if FilterTable doesnot exist, create WFFilterTable with default columns.
	 */
	IF NOT EXISTS (SELECT * FROM SysObjects Where xType = 'U' AND NAME = 'WFFilterTable')
	BEGIN
		IF EXISTS (SELECT * FROM SysObjects Where xType = 'U' AND NAME = 'FilterTable')
		BEGIN
			EXECUTE('SP_RENAME FilterTable, WFFilterTable')
			EXECUTE('SP_RENAME ''WFFilterTable.ID'', ''ObjectIndex'', ''Column''')
			EXECUTE('Alter Table WFFilterTable Alter Column ObjectIndex SmallInt NOT NULL')
			EXECUTE('SP_RENAME ''WFFilterTable.Type'', ''ObjectType'', ''Column''')
			EXECUTE('Alter Table WFFilterTable Alter Column ObjectType NVARCHAR(1) NOT NULL')
			PRINT 'Table FilterTable successfully renamed to WFFilterTable'
		END
		ELSE /* Create WFFilterTable with default columns */
		BEGIN
			EXECUTE('CREATE TABLE WFFilterTable(
					ObjectIndex			INT			NOT NULL,
					ObjectType			NVARCHAR(1)	NOT NULL
					)'
			)
			PRINT 'Table WFFilterTable Created Successfully'
		END
	END

	/* Added By Varun Bhansaly On 29/10/2007 Bugzilla Id 1027 */
	IF NOT EXISTS ( SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'CheckOutProcessesTable') AND  NAME = 'ProcessStatus')
	BEGIN
		Execute('ALTER TABLE CheckOutProcessesTable ADD ProcessStatus NVARCHAR(1)')
		PRINT 'Table CheckOutProcessesTable altered with new Column ProcessStatus'
	END

	/* Added By Varun Bhansaly On 29/10/2007 Bugzilla Id 1027 */
	IF NOT EXISTS (SELECT * FROM SysObjects Where xType = 'U' and NAME = 'WFSwimLaneTable')
	BEGIN
		EXECUTE('CREATE TABLE WFSwimLaneTable(
					ProcessDefId	INT		NOT NULL,
					SwimLaneId		INT		NOT NULL,
					SwimLaneWidth	INT		NOT NULL,
					SwimLaneHeight	INT		NOT NULL,
					ITop			INT		NOT NULL,
					ILeft			INT		NOT NULL,
					BackColor		BIGINT	NOT NULL
				)'
		)
		PRINT 'Table WFSwimLaneTable Created Successfully'
	END

	/* Added By Varun Bhansaly On 29/10/2007 Filter On Queue */
	IF NOT EXISTS ( SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'QueueDefTable') AND  NAME = 'QueueFilter')
	BEGIN
		Execute('ALTER TABLE QueueDefTable ADD QueueFilter NVARCHAR(2000) NULL')
		PRINT 'Table QueueDefTable altered with new Column QueueFilter'
	END

	/* Added By Varun Bhansaly On 30/10/2007 Bugzilla Id 1677 */
	SELECT @ConstraintName = C.NAME FROM 
	SysObjects C
	WHERE C.XTYPE = 'PK' AND 
	C.ID IN (SELECT A.ConstId FROM SysConstraints A, SysObjects B WHERE A.ID = B.ID AND B.NAME = 'VarAliasTable')
	IF(@@ROWCOUNT > 0)
	BEGIN
		EXECUTE('Alter table VarAliasTable Drop Constraint ' + @ConstraintName)
		EXECUTE('Alter table VarAliasTable Add Constraint PK__VarAliasTable Primary Key (QueueId, Alias)')
		PRINT 'Primary Key updated for VarAliasTable'
	END

	/* Added By Varun Bhansaly On 19/12/2007 SrNo-11 WFExportTable */
	IF NOT EXISTS (SELECT * FROM SysObjects Where xType = 'U' and NAME = 'WFExportTable')
	BEGIN
		EXECUTE('CREATE TABLE WFExportTable(
					ProcessDefId		INT,
					ActivityId			INT,
					DatabaseType		NVARCHAR(10),
					DatabaseName		NVARCHAR(50),
					UserId				NVARCHAR(50),
					UserPwd				NVARCHAR(255),
					TableName			NVARCHAR(50),
					CSVType				INT,
					NoOfRecords			INT,
					HostName			NVARCHAR(255),
					ServiceName			NVARCHAR(255),
					Port				NVARCHAR(255),
					Header				NVARCHAR(1),
					CSVFileName			NVARCHAR(255),
					OrderBy				NVARCHAR(255),
					FileExpireTrigger	NVARCHAR(1),
					BreakOn				NVARCHAR(1)
				)'
		)
		PRINT 'Table WFExportTable Created Successfully'
	END

	/* Added By Varun Bhansaly On 19/12/2007 SrNo-12 WFDataMapTable */
	IF NOT EXISTS (SELECT * FROM SysObjects Where xType = 'U' and NAME = 'WFDataMapTable')
	BEGIN
		EXECUTE('CREATE TABLE WFDataMapTable(
					ProcessDefId		INT,
					ActivityId			INT,
					OrderId				INT,
					FieldName			NVARCHAR(255),
					MappedFieldName		NVARCHAR(255),
					FieldLength			INT,
					DocTypeDefId		INT,
					DateTimeFormat		NVARCHAR(50),
					QuoteFlag			NVARCHAR(1)
				)'
		)
		PRINT 'Table WFDataMapTable Created Successfully'
	END

	/* Added By Varun Bhansaly On 19/12/2007 SrNo-13 WFRoutingServerInfo */
	IF NOT EXISTS (SELECT * FROM SysObjects Where xType = 'U' and NAME = 'WFRoutingServerInfo')
	BEGIN
		EXECUTE('CREATE TABLE WFRoutingServerInfo( 
					InfoId				INT	IDENTITY (1, 1) NOT NULL, 
					DmsUserIndex		INT					NULL, 
					DmsUserName			NVARCHAR(64)		NULL, 
					DmsUserPassword		NVARCHAR(255)		NULL, 
					DmsSessionId		INT					NULL, 
					Data				NVARCHAR(128)		NULL  
				)'
		)
		PRINT 'Table WFRoutingServerInfo Created Successfully'
	END

	/* Added By Varun Bhansaly On 19/12/2007 Bugzilla Id 1718 */
	/* @@Todo - This Query can be and should be optimized */
	SELECT @ConstraintName = NAME FROM SysObjects WHERE xType = 'D' AND Id = 
	(SELECT B.ConstId FROM SysObjects A, SysConstraints B WHERE A.NAME = 'ExceptionTable' AND A.Id = B.Id AND B.colId = 
	(SELECT colid FROM SysObjects A, SysColumns C WHERE A.NAME = 'ExceptionTable' AND A.id = C.id AND C.NAME = 'ActionDatetime'))
	IF(@@ROWCOUNT > 0)
	BEGIN
		EXECUTE('Alter Table ExceptionTable Drop Constraint ' + @ConstraintName)
		EXECUTE('Alter Table ExceptionTable Add Constraint DF_EXCEPTIONTABLE_ActionDatetime DEFAULT getDate() FOR ActionDateTime')
		PRINT 'ExceptionTable Updated with New Constraint DF_EXCEPTIONTABLE_ActionDatetime On Column ActionDateTime'
	END

	/* Added By Varun Bhansaly On 20/12/2007 Bugzilla Id  2817 */
	IF NOT EXISTS (SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'TemplateDefinitionTable') AND  NAME = 'isEncrypted')
	BEGIN
		Execute('ALTER TABLE TemplateDefinitionTable ADD isEncrypted NVARCHAR(1)')
		PRINT 'Table TemplateDefinitionTable altered with new Column isEncrypted'
	END

	/* Added By Varun Bhansaly On 20/12/2007 Bugzilla Id  2817 */
	IF NOT EXISTS (SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'ActionDefTable') AND  NAME = 'isEncrypted')
	BEGIN
		Execute('ALTER TABLE ActionDefTable ADD isEncrypted NVARCHAR(1)')
		PRINT 'Table ActionDefTable altered with new Column isEncrypted'
	END

	/* Added By Varun Bhansaly On 20/12/2007 Bugzilla Id  2817 */
	IF NOT EXISTS (SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'WFForm_Table') AND  NAME = 'isEncrypted')
	BEGIN
		Execute('ALTER TABLE WFForm_Table ADD isEncrypted NVARCHAR(1)')
		PRINT 'Table WFForm_Table altered with new Column isEncrypted'
	END

	/* Added By Varun Bhansaly On 20/12/2007 Bugzilla Id  2817 */
	IF NOT EXISTS (SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'TemplateMultiLanguageTable') AND  NAME = 'isEncrypted')
	BEGIN
		Execute('ALTER TABLE TemplateMultiLanguageTable ADD isEncrypted NVARCHAR(1)')
		PRINT 'Table TemplateMultiLanguageTable altered with new Column isEncrypted'
	END

	IF NOT EXISTS(SELECT * FROM WFCabVersionTable WHERE Remarks = N'reportUpdate')
	BEGIN
		BEGIN TRANSACTION Transaction1
			UPDATE CurrentRouteLogTable SET AssociatedFieldName = N'<OriginalQueueName>' + RTRIM(AssociatedFieldName) + N'</OriginalQueueName>' WHERE ActionId = 51
			IF(@@ERROR <> 0)
			BEGIN
				PRINT 'Check !! Check !! Exception encountered while applying HOTFIX_6.2_037'
				PRINT 'Transaction being rolled back'
				ROLLBACK TRANSACTION Transaction1
			END
			ELSE 
			BEGIN 
				INSERT INTO WFCabVersionTable VALUES (N'6.2.0', getdate(), getdate(), N'reportUpdate', N'Y') /* HOTFIX_6.2_036 */
				IF(@@ERROR <> 0)
				BEGIN
					PRINT 'Check !! Check !! Exception encountered while applying HOTFIX_6.2_037'
					PRINT 'Transaction being rolled back'
					ROLLBACK TRANSACTION Transaction1
				END
			END
		COMMIT TRANSACTION Transaction1
	END
	ELSE
	BEGIN
		UPDATE WFCabVersionTable SET CabVersion = N'HOTFIX_6.2_037' WHERE Remarks = N'reportUpdate' AND CabVersion = N'6.2.0'
	END

	/* Added By Varun Bhansaly On 06/02/2008 Bugzilla Id 3682 */
	IF NOT EXISTS(SELECT * FROM WFCabVersionTable WHERE CabVersion = 'Bugzilla_Id_3682')
--	EXECUTE Upgrade1 'Bugzilla_Id_3682', @v_Exists OUT
--	IF(@v_Exists <> 0)
	BEGIN
		IF NOT EXISTS(SELECT * FROM SYSCOLUMNS WHERE NAME = 'ParameterScope' AND id = (SELECT id FROM SYSOBJECTS WHERE NAME = 'ExtMethodParamDefTable' AND XTYPE='U'))
		BEGIN
			EXECUTE('ALTER TABLE ExtMethodParamDefTable ADD ParameterScope NVARCHAR(1)')
			PRINT 'Table ExtMethodParamDefTable altered with new Column ParameterScope'
		END

		IF NOT EXISTS(SELECT * FROM SYSCOLUMNS WHERE NAME = 'ClassName' AND id = (SELECT id FROM SYSOBJECTS WHERE NAME = 'WFDataStructureTable' AND XTYPE='U'))
		BEGIN
			EXECUTE('ALTER TABLE WFDataStructureTable ADD ClassName NVARCHAR(255)') /* Bugzilla Bug Id 7588 Changed By Ishu Saraf */
			PRINT 'Table WFDataStructureTable altered with new Column ClassName'
		END
		BEGIN TRANSACTION Transaction2
			EXECUTE('UPDATE ExtMethodParamDefTable SET parameterScope = N''O'' WHERE parameterOrder = 0 OR parameterName = N''Fault''')

			EXECUTE('UPDATE ExtMethodParamDefTable SET parameterScope = N''I'' WHERE parameterOrder != 0 AND parameterName != N''Fault''')
			
			EXECUTE('UPDATE ExtMethodParamDefTable SET ParameterName = (SELECT extMethodName FROM ExtMethodDefTable WHERE extMethodParamDefTable.processDefId = ExtMethodDefTable.processDefId AND ExtMethodParamDefTable.extMethodIndex = ExtMethodDefTable.extMethodIndex) WHERE parameterOrder = 0')
			
			EXECUTE('UPDATE WFDataStructureTable SET ClassName = WFDataStructureTable.NAME WHERE type = 11 AND ParentIndex = 0')

			EXECUTE('UPDATE WFDataStructureTable SET WFDataStructureTable.NAME = (SELECT parameterNAME FROM ExtMethodParamDefTable WHERE WFDataStructureTable.processDefId = ExtMethodParamDefTable.processDefId	AND WFDataStructureTable.extMethodIndex = ExtMethodParamDefTable.extMethodIndex	AND parameterOrder = 0) WHERE ParentIndex = 0')
			
			EXECUTE('INSERT INTO WFCabVersionTable(cabVersion, creationDate, lastModified, Remarks, Status) VALUES (N''Bugzilla_Id_3682'', GETDATE(), GETDATE(), N''Enhancements in Web Services'', N''Y'')')
		COMMIT TRANSACTION Transaction2
	END

	/* Added By Varun Bhansaly On 28/01/2008 Bugzilla Id 1774 */
	/* Some of the OLDER cabinets might have A UNIQUE key on StreamDefTable - Varun Bhansaly */
	IF EXISTS(SELECT C.NAME FROM SysObjects C WHERE C.XTYPE = 'U' AND C.NAME = 'U_SDTABLE' AND C.ID IN (SELECT A.ConstId FROM SysConstraints A, SysObjects B WHERE A.ID = B.ID AND B.NAME = 'StreamDefTable'))
	BEGIN
		EXECUTE('ALTER TABLE StreamDefTable DROP CONSTRAINT U_SDTABLE')
		PRINT 'No Unique Constraints with the NAME U_SDTABLE Exists for StreamDefTable'
	END

	SELECT @ConstraintName = C.NAME FROM 
	SysObjects C
	WHERE C.XTYPE = 'PK' AND 
	C.ID IN (SELECT A.ConstId FROM SysConstraints A, SysObjects B WHERE A.ID = B.ID AND B.NAME = 'StreamDefTable')
	IF(@@ROWCOUNT > 0)
	BEGIN
		EXECUTE('Alter table StreamDefTable Drop Constraint ' + @ConstraintName)
		EXECUTE('Alter table StreamDefTable Add Constraint PK_StreamDefTable PRIMARY KEY CLUSTERED (ProcessDefId, ActivityId, StreamId)')
		PRINT 'Primary Key updated for StreamDefTable'
	END
	ELSE
	BEGIN
		EXECUTE('Alter table StreamDefTable Add Constraint PK_StreamDefTable PRIMARY KEY CLUSTERED (ProcessDefId, ActivityId, StreamId)')
		PRINT 'No Primary Key Exists for StreamDefTable..Hence Primary Key Added.'
	END

	EXECUTE('Alter Table ArchiveTable Alter Column AppServerPort NVARCHAR(5)')
	PRINT 'Table ArchiveTable altered with Column AppServerPort size increased to 5'
	EXECUTE('Alter Table ArchiveTable Alter Column PortId NVARCHAR(5)')
	PRINT 'Table ArchiveTable altered with Column PortId size increased to 5'

	IF NOT EXISTS (SELECT * FROM sysColumns WHERE id = (SELECT id FROM sysObjects WHERE NAME = 'VarMappingTable') AND NAME = 'VariableLength')
	BEGIN
		EXECUTE('ALTER TABLE VarMappingTable ADD VariableLength INT NULL')
		PRINT 'Table VarMappingTable altered with new Column VariableLength'
		BEGIN TRANSACTION Transaction3
			EXECUTE('UPDATE VarMappingTable SET VariableLength = 255 WHERE SystemDefinedName IN (''VAR_STR1'', ''VAR_STR2'', ''VAR_STR3'', ''VAR_STR4'', ''VAR_STR5'', ''VAR_STR6'', ''VAR_STR7'', ''VAR_STR8'') OR SystemDefinedName IN (''VAR_REC_1'',''VAR_REC_2'',''VAR_REC_3'',''VAR_REC_4'',''VAR_REC_5'')')
			EXECUTE('UPDATE VarMappingTable SET VariableLength = 1024 WHERE VariableScope = ''I'' AND VariableType = 10 AND ExtObjId = 1')
		COMMIT TRANSACTION Transaction3
	END

	/* Added By Ishu Saraf On 23/04/2008 SrNo-14 */
	IF NOT EXISTS (
		SELECT * FROM SYSObjects
		WHERE	NAME	= 'WFTypeDescTable'
		AND	xType	= 'U'
	)
	Begin
		EXECUTE('
			CREATE TABLE WFTypeDescTable (
				ProcessDefId		INT					NOT NULL,
				TypeId				SMALLINT			NOT NULL,
				TypeName			NVARCHAR(128)		NOT NULL, 
				ExtensionTypeId		SMALLINT		    NULL,
				PRIMARY KEY (ProcessDefId, TypeId)
			)
		')
		PRINT 'Table WFTypeDescTable Created Successfully'
	End

	/* Added By Ishu Saraf On 23/04/2008 SrNo-14 */
	IF NOT EXISTS (
		SELECT * FROM SYSObjects
		WHERE	NAME	= 'WFTypeDefTable'
		AND	xType	= 'U'
	)
	Begin
		EXECUTE('
			CREATE TABLE WFTypeDefTable (
					ProcessDefId	INT				NOT NULL,
					ParentTypeId	SMALLINT		NOT NULL,
					TypeFieldId		SMALLINT		NOT NULL,
					FieldName		NVARCHAR(128)	NOT NULL, 
					WFType			SMALLINT		NOT NULL,
					TypeId			SMALLINT		NOT NULL,
					Unbounded		NVARCHAR(1)		NOT NULL DEFAULT N''N'' CHECK (Unbounded IN (N''Y'' , N''N'')),
					ExtensionTypeId	SMALLINT,
					PRIMARY KEY ( ProcessDefId, ParentTypeId, TypeFieldId )
			)
		')
		PRINT 'Table WFTypeDefTable Created Successfully'		
	End
	
	/* Added By Ishu Saraf On 23/04/2008 SrNo-14 */
	IF NOT EXISTS (
		SELECT * FROM SYSObjects
		WHERE	NAME	= 'WFUDTVarMappingTable'
		AND	xType	= 'U'
	)
	BEGIN
		EXECUTE('
			CREATE TABLE WFUDTVarMappingTable (
				ProcessDefId 		INT 			NOT NULL,
				VariableId			INT 			NOT NULL,
				VarFieldId			SMALLINT		NOT NULL,
				TypeId				SMALLINT		NOT NULL,
				TypeFieldId			SMALLINT		NOT NULL,
				ParentVarFieldId	SMALLINT		NOT NULL,
				MappedObjectName	NVARCHAR(256) 		NULL,
				ExtObjId 			INT					NULL,
				MappedObjectType	NVARCHAR(1)	    	NULL,
				DefaultValue		NVARCHAR(256)		NULL,
				FieldLength			INT					NULL,
				VarPrecision		INT					NULL,
				RelationId			INT 			    NULL,
				PRIMARY KEY (ProcessDefId, VariableId, VarFieldId)
			)
		')
		PRINT 'Table WFUDTVarMappingTable Created Successfully'		
	END

	/* Added By Ishu Saraf On 23/04/2008 SrNo-14 */
	IF NOT EXISTS (
		SELECT * FROM SYSObjects
		WHERE	NAME	= 'WFVarRelationTable'
		AND	xType	= 'U'
	)
	BEGIN
		EXECUTE('
			CREATE TABLE WFVarRelationTable (
				ProcessDefId 		INT 			NOT NULL,
				RelationId			INT 			NOT NULL,
				OrderId				INT 			NOT NULL,
				ParentObject		NVARCHAR(256)	NOT NULL,
				Foreignkey			NVARCHAR(256)	NOT NULL,
				FautoGen			NVARCHAR(1)		NULL,
				ChildObject			NVARCHAR(256)	NOT NULL,
				Refkey				NVARCHAR(256)	NOT NULL,
				RautoGen			NVARCHAR(1)		    NULL,
				PRIMARY KEY ( ProcessDefId, RelationId, OrderId)
			)
		')
		PRINT 'Table WFVarRelationTable Created Successfully'
	END
	
	/* Added By Ishu Saraf On 23/04/2008 SrNo-14 */
	IF NOT EXISTS ( SELECT * FROM sysColumns 
			WHERE 
			id = (SELECT id FROM sysObjects WHERE NAME = 'WFWebServiceTable')
			AND  NAME = 'FunctionType'
			)
	BEGIN
		EXECUTE('ALTER TABLE WFWebServiceTable ADD FunctionType NVarCHAR(1) NOT NULL DEFAULT N''L'' CHECK (FunctionType IN (N''G'' , N''L''))')
		PRINT 'Table WFWebServiceTable altered with new Column FunctionType'
	END
			
	/* Added By Ishu Saraf On 23/04/2008 SrNo-14 */
	IF NOT EXISTS ( SELECT * FROM sysColumns 
			WHERE 
			id = (SELECT id FROM sysObjects WHERE NAME = 'ActivityAssociationTable')
			AND  NAME = 'VariableId'
			)
	BEGIN
		EXECUTE('ALTER TABLE ActivityAssociationTable ADD VariableId INT NOT NULL DEFAULT 0')
		PRINT 'Table ActivityAssociationTable altered with new column VariableId'
	END
	
	/* Added By Ishu Saraf On 23/04/2008 SrNo-14 */
	IF NOT EXISTS ( SELECT * FROM sysColumns 
			WHERE 
			id = (SELECT id FROM sysObjects WHERE NAME = 'VarMappingTable')
			AND  NAME = 'VarPrecision'
			)
	BEGIN
		EXECUTE('ALTER TABLE VarMappingTable ADD VarPrecision INT')
		PRINT 'Table VarMappingTable altered with new Column VarPrecision'
	END	
	
	/* Added By Ishu Saraf On 23/04/2008 SrNo-14 */
	IF NOT EXISTS ( SELECT * FROM sysColumns 
			WHERE 
			id = (SELECT id FROM sysObjects WHERE NAME = 'VarMappingTable')
			AND  NAME = 'Unbounded'
			)
	BEGIN
		EXECUTE('ALTER TABLE VarMappingTable ADD Unbounded NVARCHAR(1) NOT NULL DEFAULT ''N'' CHECK (Unbounded IN (N''Y'' , N''N''))')
		PRINT 'Table VarMappingTable altered with new Column Unbounded'
	END
			
	/* Added By Ishu Saraf On 23/04/2008 SrNo-14 */
	IF NOT EXISTS ( SELECT * FROM sysColumns 
			WHERE 
			id = (SELECT id FROM sysObjects WHERE NAME = 'VarMappingTable')
			AND  NAME = 'VariableId'  
			)
	BEGIN
		EXECUTE('ALTER TABLE VarMappingTable ADD VariableId INT NOT NULL DEFAULT 0')
		PRINT 'Table VarMappingTable altered with new column VariableId'
	END

	/* Added By Ishu Saraf On 23/04/2008 SrNo-14 */
	IF NOT EXISTS ( SELECT * FROM sysColumns 
			WHERE 
			id = (SELECT id FROM sysObjects WHERE NAME = 'RuleOperationTable')
			AND  NAME = 'VariableId_1'
			)
	BEGIN
		EXECUTE('ALTER TABLE RuleOperationTable ADD VariableId_1 INT')
		EXECUTE('UPDATE RuleOperationTable SET VariableId_1 = 0')
		PRINT 'Table RuleOperationTable altered with new Column VariableId_1'
	END
	
	/* Added By Ishu Saraf On 23/04/2008 SrNo-14 */
	IF NOT EXISTS ( SELECT * FROM sysColumns 
			WHERE 
			id = (SELECT id FROM sysObjects WHERE NAME = 'RuleOperationTable')
			AND  NAME = 'VarFieldId_1'
			)
	BEGIN
		EXECUTE('ALTER TABLE RuleOperationTable ADD VarFieldId_1 INT')
		EXECUTE('UPDATE RuleOperationTable SET VarFieldId_1 = 0')
		PRINT 'Table RuleOperationTable altered with new Column VarFieldId_1'
	END
	
	/* Added By Ishu Saraf On 23/04/2008 SrNo-14 */
	IF NOT EXISTS ( SELECT * FROM sysColumns 
			WHERE 
			id = (SELECT id FROM sysObjects WHERE NAME = 'RuleOperationTable')
			AND  NAME = 'VariableId_2'
			)
	BEGIN
		EXECUTE('ALTER TABLE RuleOperationTable ADD VariableId_2 INT')
		EXECUTE('UPDATE RuleOperationTable SET VariableId_2 = 0')
		PRINT 'Table RuleOperationTable altered with new Column VariableId_2'
	END
	
	/* Added By Ishu Saraf On 23/04/2008 SrNo-14 */
	IF NOT EXISTS ( SELECT * FROM sysColumns 
			WHERE 
			id = (SELECT id FROM sysObjects WHERE NAME = 'RuleOperationTable')
			AND  NAME = 'VarFieldId_2'
			)
	BEGIN
		EXECUTE('ALTER TABLE RuleOperationTable ADD VarFieldId_2 INT')
		EXECUTE('UPDATE RuleOperationTable SET VarFieldId_2 = 0')
		PRINT 'Table RuleOperationTable altered with new Column VarFieldId_2'
	END
	
	/* Added By Ishu Saraf On 23/04/2008 SrNo-14 */
	IF NOT EXISTS ( SELECT * FROM sysColumns 
			WHERE 
			id = (SELECT id FROM sysObjects WHERE NAME = 'RuleOperationTable')
			AND  NAME = 'VariableId_3'
			)
	BEGIN
		EXECUTE('ALTER TABLE RuleOperationTable ADD VariableId_3 INT')
		EXECUTE('UPDATE RuleOperationTable SET VariableId_3 = 0')
		PRINT 'Table RuleOperationTable altered with new Column VariableId_3'
	END
	
	/* Added By Ishu Saraf On 23/04/2008 SrNo-14 */
	IF NOT EXISTS ( SELECT * FROM sysColumns 
			WHERE 
			id = (SELECT id FROM sysObjects WHERE NAME = 'RuleOperationTable')
			AND  NAME = 'VarFieldId_3'
			)
	BEGIN
		EXECUTE('ALTER TABLE RuleOperationTable ADD VarFieldId_3 INT')
		EXECUTE('UPDATE RuleOperationTable SET VarFieldId_3 = 0')
		PRINT 'Table RuleOperationTable altered with new Column VarFieldId_3'
	END
	
	/* Added By Ishu Saraf On 23/04/2008 SrNo-14 */	
	IF NOT EXISTS ( SELECT * FROM sysColumns 
			WHERE 
			id = (SELECT id FROM sysObjects WHERE NAME = 'RuleOperationTable')
			AND  NAME = 'FunctionType' 
			)
	BEGIN				
		EXECUTE('ALTER TABLE RuleOperationTable ADD FunctionType NVarCHAR(1) NOT NULL DEFAULT N''L'' CHECK (FunctionType IN (N''G'' , N''L''))')
		PRINT 'Table RuleOperationTable altered with new Column FunctionType'
	END

	/* Added By Ishu Saraf On 23/04/2008 SrNo-14 */
	IF NOT EXISTS ( SELECT * FROM sysColumns 
			WHERE 
			id = (SELECT id FROM sysObjects WHERE NAME = 'RuleConditionTable')
			AND  NAME = 'VariableId_1'
			)
	BEGIN
		EXECUTE('ALTER TABLE RuleConditionTable ADD VariableId_1 INT')
		EXECUTE('UPDATE RuleConditionTable SET VariableId_1 = 0')		
		PRINT 'Table RuleConditionTable altered with new Column VariableId_1'
	END
	
	/* Added By Ishu Saraf On 23/04/2008 SrNo-14 */
	IF NOT EXISTS ( SELECT * FROM sysColumns 
			WHERE 
			id = (SELECT id FROM sysObjects WHERE NAME = 'RuleConditionTable')
			AND  NAME = 'VarFieldId_1'
			)
	BEGIN
		EXECUTE('ALTER TABLE RuleConditionTable ADD VarFieldId_1 INT')
		EXECUTE('UPDATE RuleConditionTable SET VarFieldId_1 = 0')
		PRINT 'Table RuleConditionTable altered with new Column VarFieldId_1'
	END
	
	/* Added By Ishu Saraf On 23/04/2008 SrNo-14 */
	IF NOT EXISTS ( SELECT * FROM sysColumns 
			WHERE 
			id = (SELECT id FROM sysObjects WHERE NAME = 'RuleConditionTable')
			AND  NAME = 'VariableId_2'
			)
	BEGIN
		EXECUTE('ALTER TABLE RuleConditionTable ADD VariableId_2 INT')
		EXECUTE('UPDATE RuleConditionTable SET VariableId_2 = 0')
		PRINT 'Table RuleConditionTable altered with new Column VariableId_2'
	END
	
	/* Added By Ishu Saraf On 23/04/2008 SrNo-14 */
	IF NOT EXISTS ( SELECT * FROM sysColumns 
			WHERE 
			id = (SELECT id FROM sysObjects WHERE NAME = 'RuleConditionTable')
			AND  NAME = 'VarFieldId_2'
			)
	BEGIN
		EXECUTE('ALTER TABLE RuleConditionTable ADD VarFieldId_2 INT')
		EXECUTE('UPDATE RuleConditionTable SET VarFieldId_2 = 0')
		PRINT 'Table RuleConditionTable altered with new Column VarFieldId_2'
   	END

	/* Added By Ishu Saraf On 23/04/2008 SrNo-14 */
	IF NOT EXISTS ( SELECT * FROM sysColumns 
			WHERE 
			id = (SELECT id FROM sysObjects WHERE NAME = 'ExtMethodParamMappingTable')
			AND  NAME = 'VariableId'
			)
	BEGIN
		EXECUTE('ALTER TABLE ExtMethodParamMappingTable ADD VariableId INT')
		EXECUTE('UPDATE ExtMethodParamMappingTable SET VariableId = 0')
		PRINT 'Table ExtMethodParamMappingTable altered with new Column VariableId'
	END

	/* Added By Ishu Saraf On 23/04/2008 SrNo-14 */
	IF NOT EXISTS ( SELECT * FROM sysColumns 
			WHERE 
			id = (SELECT id FROM sysObjects WHERE NAME = 'ExtMethodParamMappingTable')
			AND  NAME = 'VarFieldId'
			)
	BEGIN
		EXECUTE('ALTER TABLE ExtMethodParamMappingTable ADD VarFieldId INT')
		EXECUTE('UPDATE ExtMethodParamMappingTable SET VarFieldId = 0')
		PRINT 'Table ExtMethodParamMappingTable altered with new Column VarFieldId'
	END

	/* Added By Ishu Saraf On 21/08/2008 SrNo-14 */
	IF NOT EXISTS ( SELECT * FROM sysColumns 
			WHERE 
			id = (SELECT id FROM sysObjects WHERE NAME = 'ActionOperationTable')
			AND  NAME = 'VariableId_1'
			)
	BEGIN
		EXECUTE('ALTER TABLE ActionOperationTable ADD VariableId_1 INT')
		EXECUTE('UPDATE ActionOperationTable SET VariableId_1 = 0')
		PRINT 'Table ActionOperationTable altered with new Column VariableId_1'
	END
	
	/* Added By Ishu Saraf On 21/08/2008 SrNo-14 */
	IF NOT EXISTS ( SELECT * FROM sysColumns 
			WHERE 
			id = (SELECT id FROM sysObjects WHERE NAME = 'ActionOperationTable')
			AND  NAME = 'VarFieldId_1'
			)
	BEGIN
		EXECUTE('ALTER TABLE ActionOperationTable ADD VarFieldId_1 INT')
		EXECUTE('UPDATE ActionOperationTable SET VarFieldId_1 = 0')
		PRINT 'Table ActionOperationTable altered with new Column VarFieldId_1'
	END
	
	/* Added By Ishu Saraf On 21/08/2008 SrNo-14 */
	IF NOT EXISTS ( SELECT * FROM sysColumns 
			WHERE 
			id = (SELECT id FROM sysObjects WHERE NAME = 'ActionOperationTable')
			AND  NAME = 'VariableId_2'
			)
	BEGIN
		EXECUTE('ALTER TABLE ActionOperationTable ADD VariableId_2 INT')
		EXECUTE('UPDATE ActionOperationTable SET VariableId_2 = 0')
		PRINT 'Table ActionOperationTable altered with new Column VariableId_2'
	END
	
	/* Added By Ishu Saraf On 21/08/2008 SrNo-14 */
	IF NOT EXISTS ( SELECT * FROM sysColumns 
			WHERE 
			id = (SELECT id FROM sysObjects WHERE NAME = 'ActionOperationTable')
			AND  NAME = 'VarFieldId_2'
			)
	BEGIN
		EXECUTE('ALTER TABLE ActionOperationTable ADD VarFieldId_2 INT')
		EXECUTE('UPDATE ActionOperationTable SET VarFieldId_2 = 0')
		PRINT 'Table ActionOperationTable altered with new Column VarFieldId_2'
	END
	
	/* Added By Ishu Saraf On 21/08/2008 SrNo-14 */
	IF NOT EXISTS ( SELECT * FROM sysColumns 
			WHERE 
			id = (SELECT id FROM sysObjects WHERE NAME = 'ActionOperationTable')
			AND  NAME = 'VariableId_3'
			)
	BEGIN
		EXECUTE('ALTER TABLE ActionOperationTable ADD VariableId_3 INT')
		EXECUTE('UPDATE ActionOperationTable SET VariableId_3 = 0')
		PRINT 'Table ActionOperationTable altered with new Column VariableId_3'
	END
	
	/* Added By Ishu Saraf On 21/08/2008 SrNo-14 */
	IF NOT EXISTS ( SELECT * FROM sysColumns 
			WHERE 
			id = (SELECT id FROM sysObjects WHERE NAME = 'ActionOperationTable')
			AND  NAME = 'VarFieldId_3'
			)
	BEGIN
		EXECUTE('ALTER TABLE ActionOperationTable ADD VarFieldId_3 INT')
		EXECUTE('UPDATE ActionOperationTable SET VarFieldId_3 = 0')
		PRINT 'Table ActionOperationTable altered with new Column VarFieldId_3'
	END

	/* Added By Ishu Saraf On 21/08/2008 SrNo-14 */
	IF NOT EXISTS ( SELECT * FROM sysColumns 
			WHERE 
			id = (SELECT id FROM sysObjects WHERE NAME = 'ActionConditionTable')
			AND  NAME = 'VariableId_1'
			)
	BEGIN
		EXECUTE('ALTER TABLE ActionConditionTable ADD VariableId_1 INT')
		EXECUTE('UPDATE ActionConditionTable SET VariableId_1 = 0')		
		PRINT 'Table ActionConditionTable altered with new Column VariableId_1'
	END
	
	/* Added By Ishu Saraf On 21/08/2008 SrNo-14 */
	IF NOT EXISTS ( SELECT * FROM sysColumns 
			WHERE 
			id = (SELECT id FROM sysObjects WHERE NAME = 'ActionConditionTable')
			AND  NAME = 'VarFieldId_1'
			)
	BEGIN
		EXECUTE('ALTER TABLE ActionConditionTable ADD VarFieldId_1 INT')
		EXECUTE('UPDATE ActionConditionTable SET VarFieldId_1 = 0')
		PRINT 'Table ActionConditionTable altered with new Column VarFieldId_1'
	END
	
	/* Added By Ishu Saraf On 21/08/2008 SrNo-14 */
	IF NOT EXISTS ( SELECT * FROM sysColumns 
			WHERE 
			id = (SELECT id FROM sysObjects WHERE NAME = 'ActionConditionTable')
			AND  NAME = 'VariableId_2'
			)
	BEGIN
		EXECUTE('ALTER TABLE ActionConditionTable ADD VariableId_2 INT')
		EXECUTE('UPDATE ActionConditionTable SET VariableId_2 = 0')
		PRINT 'Table ActionConditionTable altered with new Column VariableId_2'
	END
	
	/* Added By Ishu Saraf On 21/08/20088 SrNo-14 */
	IF NOT EXISTS ( SELECT * FROM sysColumns 
			WHERE 
			id = (SELECT id FROM sysObjects WHERE NAME = 'ActionConditionTable')
			AND  NAME = 'VarFieldId_2'
			)
	BEGIN
		EXECUTE('ALTER TABLE ActionConditionTable ADD VarFieldId_2 INT')
		EXECUTE('UPDATE ActionConditionTable SET VarFieldId_2 = 0')
		PRINT 'Table ActionConditionTable altered with new Column VarFieldId_2'
   	END

	/* Added By Ishu Saraf On 21/08/2008 SrNo-14 */
	IF NOT EXISTS ( SELECT * FROM sysColumns 
			WHERE 
			id = (SELECT id FROM sysObjects WHERE NAME = 'DataSetTriggerTable')
			AND  NAME = 'VariableId_1'
			)
	BEGIN
		EXECUTE('ALTER TABLE DataSetTriggerTable ADD VariableId_1 INT')
		EXECUTE('UPDATE DataSetTriggerTable SET VariableId_1 = 0')		
		PRINT 'Table DataSetTriggerTable altered with new Column VariableId_1'
	END

	/* Added By Ishu Saraf On 21/08/2008 SrNo-14 */
	IF NOT EXISTS ( SELECT * FROM sysColumns 
			WHERE 
			id = (SELECT id FROM sysObjects WHERE NAME = 'DataSetTriggerTable')
			AND  NAME = 'VarFieldId_1'
			)
	BEGIN
		EXECUTE('ALTER TABLE DataSetTriggerTable ADD VarFieldId_1 INT')
		EXECUTE('UPDATE DataSetTriggerTable SET VarFieldId_1 = 0')
		PRINT 'Table DataSetTriggerTable altered with new Column VarFieldId_1'
	END
	
	/* Added By Ishu Saraf On 21/08/2008 SrNo-14 */
	IF NOT EXISTS ( SELECT * FROM sysColumns 
			WHERE 
			id = (SELECT id FROM sysObjects WHERE NAME = 'DataSetTriggerTable')
			AND  NAME = 'VariableId_2'
			)
	BEGIN
		EXECUTE('ALTER TABLE DataSetTriggerTable ADD VariableId_2 INT')
		EXECUTE('UPDATE DataSetTriggerTable SET VariableId_2 = 0')
		PRINT 'Table DataSetTriggerTable altered with new Column VariableId_2'
	END
	
	/* Added By Ishu Saraf On 21/08/20088 SrNo-14 */
	IF NOT EXISTS ( SELECT * FROM sysColumns 
			WHERE 
			id = (SELECT id FROM sysObjects WHERE NAME = 'DataSetTriggerTable')
			AND  NAME = 'VarFieldId_2'
			)
	BEGIN
		EXECUTE('ALTER TABLE DataSetTriggerTable ADD VarFieldId_2 INT')
		EXECUTE('UPDATE DataSetTriggerTable SET VarFieldId_2 = 0')
		PRINT 'Table DataSetTriggerTable altered with new Column VarFieldId_2'
   	END

	/* Added By Ishu Saraf On 21/08/2008 SrNo-14 */
	IF NOT EXISTS ( SELECT * FROM sysColumns 
			WHERE 
			id = (SELECT id FROM sysObjects WHERE NAME = 'ScanActionsTable')
			AND  NAME = 'VariableId_1'
			)
	BEGIN
		EXECUTE('ALTER TABLE ScanActionsTable ADD VariableId_1 INT')
		EXECUTE('UPDATE ScanActionsTable SET VariableId_1 = 0')		
		PRINT 'Table ScanActionsTable altered with new Column VariableId_1'
	END

	/* Added By Ishu Saraf On 21/08/2008 SrNo-14 */
	IF NOT EXISTS ( SELECT * FROM sysColumns 
			WHERE 
			id = (SELECT id FROM sysObjects WHERE NAME = 'ScanActionsTable')
			AND  NAME = 'VarFieldId_1'
			)
	BEGIN
		EXECUTE('ALTER TABLE ScanActionsTable ADD VarFieldId_1 INT')
		EXECUTE('UPDATE ScanActionsTable SET VarFieldId_1 = 0')
		PRINT 'Table ScanActionsTable altered with new Column VarFieldId_1'
	END
	
	/* Added By Ishu Saraf On 21/08/2008 SrNo-14 */
	IF NOT EXISTS ( SELECT * FROM sysColumns 
			WHERE 
			id = (SELECT id FROM sysObjects WHERE NAME = 'ScanActionsTable')
			AND  NAME = 'VariableId_2'
			)
	BEGIN
		EXECUTE('ALTER TABLE ScanActionsTable ADD VariableId_2 INT')
		EXECUTE('UPDATE ScanActionsTable SET VariableId_2 = 0')
		PRINT 'Table ScanActionsTable altered with new Column VariableId_2'
	END
	
	/* Added By Ishu Saraf On 21/08/20088 SrNo-14 */
	IF NOT EXISTS ( SELECT * FROM sysColumns 
			WHERE 
			id = (SELECT id FROM sysObjects WHERE NAME = 'ScanActionsTable')
			AND  NAME = 'VarFieldId_2'
			)
	BEGIN
		EXECUTE('ALTER TABLE ScanActionsTable ADD VarFieldId_2 INT')
		EXECUTE('UPDATE ScanActionsTable SET VarFieldId_2 = 0')
		PRINT 'Table ScanActionsTable altered with new Column VarFieldId_2'
   	END

	/* Added By Ishu Saraf On 21/08/2008 SrNo-14 */
	IF NOT EXISTS ( SELECT * FROM sysColumns 
			WHERE 
			id = (SELECT id FROM sysObjects WHERE NAME = 'WFDataMapTable')
			AND  NAME = 'VariableId'
			)
	BEGIN
		EXECUTE('ALTER TABLE WFDataMapTable ADD VariableId INT')
		EXECUTE('UPDATE WFDataMapTable SET VariableId = 0')
		PRINT 'Table WFDataMapTable altered with new Column VariableId'
	END
	
	/* Added By Ishu Saraf On 21/08/20088 SrNo-14 */
	IF NOT EXISTS ( SELECT * FROM sysColumns 
			WHERE 
			id = (SELECT id FROM sysObjects WHERE NAME = 'WFDataMapTable')
			AND  NAME = 'VarFieldId'
			)
	BEGIN
		EXECUTE('ALTER TABLE WFDataMapTable ADD VarFieldId INT')
		EXECUTE('UPDATE WFDataMapTable SET VarFieldId = 0')
		PRINT 'Table WFDataMapTable altered with new Column VarFieldId'
   	END

	/* Added By Ishu Saraf On 21/08/2008 SrNo-14 */
	IF NOT EXISTS ( SELECT * FROM sysColumns 
			WHERE 
			id = (SELECT id FROM sysObjects WHERE NAME = 'DataEntryTriggerTable')
			AND  NAME = 'VariableId'
			)
	BEGIN
		EXECUTE('ALTER TABLE DataEntryTriggerTable ADD VariableId INT')
		EXECUTE('UPDATE DataEntryTriggerTable SET VariableId = 0')
		PRINT 'Table DataEntryTriggerTable altered with new Column VariableId'
	END
	
	/* Added By Ishu Saraf On 21/08/20088 SrNo-14 */
	IF NOT EXISTS ( SELECT * FROM sysColumns 
			WHERE 
			id = (SELECT id FROM sysObjects WHERE NAME = 'DataEntryTriggerTable')
			AND  NAME = 'VarFieldId'
			)
	BEGIN
		EXECUTE('ALTER TABLE DataEntryTriggerTable ADD VarFieldId INT')
		EXECUTE('UPDATE DataEntryTriggerTable SET VarFieldId = 0')
		PRINT 'Table DataEntryTriggerTable altered with new Column VarFieldId'
   	END

	/* Added By Ishu Saraf On 21/08/2008 SrNo-14 */
	IF NOT EXISTS ( SELECT * FROM sysColumns 
			WHERE 
			id = (SELECT id FROM sysObjects WHERE NAME = 'ArchiveDataMapTable')
			AND  NAME = 'VariableId'
			)
	BEGIN
		EXECUTE('ALTER TABLE ArchiveDataMapTable ADD VariableId INT')
		EXECUTE('UPDATE ArchiveDataMapTable SET VariableId = 0')
		PRINT 'Table ArchiveDataMapTable altered with new Column VariableId'
	END
	
	/* Added By Ishu Saraf On 21/08/20088 SrNo-14 */
	IF NOT EXISTS ( SELECT * FROM sysColumns 
			WHERE 
			id = (SELECT id FROM sysObjects WHERE NAME = 'ArchiveDataMapTable')
			AND  NAME = 'VarFieldId'
			)
	BEGIN
		EXECUTE('ALTER TABLE ArchiveDataMapTable ADD VarFieldId INT')
		EXECUTE('UPDATE ArchiveDataMapTable SET VarFieldId = 0')
		PRINT 'Table ArchiveDataMapTable altered with new Column VarFieldId'
   	END

	/* Added By Ishu Saraf On 21/08/2008 SrNo-14 */
	IF NOT EXISTS ( SELECT * FROM sysColumns 
			WHERE 
			id = (SELECT id FROM sysObjects WHERE NAME = 'WFJMSSubscribeTable')
			AND  NAME = 'VariableId'
			)
	BEGIN
		EXECUTE('ALTER TABLE WFJMSSubscribeTable ADD VariableId INT')
		EXECUTE('UPDATE WFJMSSubscribeTable SET VariableId = 0')
		PRINT 'Table WFJMSSubscribeTable altered with new Column VariableId'
	END
	
	/* Added By Ishu Saraf On 21/08/20088 SrNo-14 */
	IF NOT EXISTS ( SELECT * FROM sysColumns 
			WHERE 
			id = (SELECT id FROM sysObjects WHERE NAME = 'WFJMSSubscribeTable')
			AND  NAME = 'VarFieldId'
			)
	BEGIN
		EXECUTE('ALTER TABLE WFJMSSubscribeTable ADD VarFieldId INT')
		EXECUTE('UPDATE WFJMSSubscribeTable SET VarFieldId = 0')
		PRINT 'Table WFJMSSubscribeTable altered with new Column VarFieldId'
   	END

	/* Added By Ishu Saraf On 21/08/2008 SrNo-14 */
	IF NOT EXISTS ( SELECT * FROM sysColumns 
			WHERE 
			id = (SELECT id FROM sysObjects WHERE NAME = 'ToDoListDefTable')
			AND  NAME = 'VariableId'
			)
	BEGIN
		EXECUTE('ALTER TABLE ToDoListDefTable ADD VariableId INT')
		EXECUTE('UPDATE ToDoListDefTable SET VariableId = 0')		
		PRINT 'Table ToDoListDefTable altered with new Column VariableId'
	END

	/* Added By Ishu Saraf On 21/08/2008 SrNo-14 */
	IF NOT EXISTS ( SELECT * FROM sysColumns 
			WHERE 
			id = (SELECT id FROM sysObjects WHERE NAME = 'ToDoListDefTable')
			AND  NAME = 'VarFieldId'
			)
	BEGIN
		EXECUTE('ALTER TABLE ToDoListDefTable ADD VarFieldId INT')
		EXECUTE('UPDATE ToDoListDefTable SET VarFieldId = 0')
		PRINT 'Table ToDoListDefTable altered with new Column VarFieldId'
	END

	/* Added By Ishu Saraf On 21/08/2008 SrNo-14 */
	IF NOT EXISTS ( SELECT * FROM sysColumns 
			WHERE 
			id = (SELECT id FROM sysObjects WHERE NAME = 'ImportedProcessDefTable')
			AND  NAME = 'VariableId'
			)
	BEGIN
		EXECUTE('ALTER TABLE ImportedProcessDefTable ADD VariableId INT')
		EXECUTE('UPDATE ImportedProcessDefTable SET VariableId = 0')
		PRINT 'Table ImportedProcessDefTable altered with new Column VariableId'
	END
	
	/* Added By Ishu Saraf On 21/08/20088 SrNo-14 */
	IF NOT EXISTS ( SELECT * FROM sysColumns 
			WHERE 
			id = (SELECT id FROM sysObjects WHERE NAME = 'ImportedProcessDefTable')
			AND  NAME = 'VarFieldId'
			)
	BEGIN
		EXECUTE('ALTER TABLE ImportedProcessDefTable ADD VarFieldId INT')
		EXECUTE('UPDATE ImportedProcessDefTable SET VarFieldId = 0')
		PRINT 'Table ImportedProcessDefTable altered with new Column VarFieldId'
   	END

	/* Added By Ishu Saraf On 21/08/20088 SrNo-14 */
	IF NOT EXISTS ( SELECT * FROM sysColumns 
			WHERE 
			id = (SELECT id FROM sysObjects WHERE NAME = 'ImportedProcessDefTable')
			AND  NAME = 'DisplayName'
			)
	BEGIN
		EXECUTE('ALTER TABLE ImportedProcessDefTable ADD DisplayName NVARCHAR(2000)')
		PRINT 'Table ImportedProcessDefTable altered with new Column DisplayName'
   	END

	/* Added By Ishu Saraf On 21/08/2008 SrNo-14 */
	IF NOT EXISTS ( SELECT * FROM sysColumns 
			WHERE 
			id = (SELECT id FROM sysObjects WHERE NAME = 'MailTriggerTable')
			AND  NAME = 'VariableIdTo'
			)
	BEGIN
		EXECUTE('ALTER TABLE MailTriggerTable ADD VariableIdTo INT')
		EXECUTE('UPDATE MailTriggerTable SET VariableIdTo = 0')
		PRINT 'Table MailTriggerTable altered with new Column VariableIdTo'
	END
	
	/* Added By Ishu Saraf On 21/08/20088 SrNo-14 */
	IF NOT EXISTS ( SELECT * FROM sysColumns 
			WHERE 
			id = (SELECT id FROM sysObjects WHERE NAME = 'MailTriggerTable')
			AND  NAME = 'VarFieldIdTo'
			)
	BEGIN
		EXECUTE('ALTER TABLE MailTriggerTable ADD VarFieldIdTo INT')
		EXECUTE('UPDATE MailTriggerTable SET VarFieldIdTo = 0')
		PRINT 'Table MailTriggerTable altered with new Column VarFieldIdTo'
   	END
	
	/* Added By Ishu Saraf On 21/08/2008 SrNo-14 */
	IF NOT EXISTS ( SELECT * FROM sysColumns 
			WHERE 
			id = (SELECT id FROM sysObjects WHERE NAME = 'MailTriggerTable')
			AND  NAME = 'VariableIdFrom'
			)
	BEGIN
		EXECUTE('ALTER TABLE MailTriggerTable ADD VariableIdFrom INT')
		EXECUTE('UPDATE MailTriggerTable SET VariableIdFrom = 0')
		PRINT 'Table MailTriggerTable altered with new Column VariableIdFrom'
	END
	
	/* Added By Ishu Saraf On 21/08/20088 SrNo-14 */
	IF NOT EXISTS ( SELECT * FROM sysColumns 
			WHERE 
			id = (SELECT id FROM sysObjects WHERE NAME = 'MailTriggerTable')
			AND  NAME = 'VarFieldIdFrom'
			)
	BEGIN
		EXECUTE('ALTER TABLE MailTriggerTable ADD VarFieldIdFrom INT')
		EXECUTE('UPDATE MailTriggerTable SET VarFieldIdFrom = 0')
		PRINT 'Table MailTriggerTable altered with new Column VarFieldIdFrom'
   	END

	/* Added By Ishu Saraf On 21/08/2008 SrNo-14 */
	IF NOT EXISTS ( SELECT * FROM sysColumns 
			WHERE 
			id = (SELECT id FROM sysObjects WHERE NAME = 'MailTriggerTable')
			AND  NAME = 'VariableIdCc'
			)
	BEGIN
		EXECUTE('ALTER TABLE MailTriggerTable ADD VariableIdCc INT')
		EXECUTE('UPDATE MailTriggerTable SET VariableIdCc = 0')
		PRINT 'Table MailTriggerTable altered with new Column VariableIdCc'
	END
	
	/* Added By Ishu Saraf On 21/08/20088 SrNo-14 */
	IF NOT EXISTS ( SELECT * FROM sysColumns 
			WHERE 
			id = (SELECT id FROM sysObjects WHERE NAME = 'MailTriggerTable')
			AND  NAME = 'VarFieldIdCc'
			)
	BEGIN
		EXECUTE('ALTER TABLE MailTriggerTable ADD VarFieldIdCc INT')
		EXECUTE('UPDATE MailTriggerTable SET VarFieldIdCc = 0')
		PRINT 'Table MailTriggerTable altered with new Column VarFieldIdCc'
   	END

	/* Added By Ishu Saraf On 21/08/2008 SrNo-14 */
	IF NOT EXISTS ( SELECT * FROM sysColumns 
			WHERE 
			id = (SELECT id FROM sysObjects WHERE NAME = 'PrintFaxEmailTable')
			AND  NAME = 'VariableIdTo'
			)
	BEGIN
		EXECUTE('ALTER TABLE PrintFaxEmailTable ADD VariableIdTo INT')
		EXECUTE('UPDATE PrintFaxEmailTable SET VariableIdTo = 0')
		PRINT 'Table PrintFaxEmailTable altered with new Column VariableIdTo'
	END
	
	/* Added By Ishu Saraf On 21/08/20088 SrNo-14 */
	IF NOT EXISTS ( SELECT * FROM sysColumns 
			WHERE 
			id = (SELECT id FROM sysObjects WHERE NAME = 'PrintFaxEmailTable')
			AND  NAME = 'VarFieldIdTo'
			)
	BEGIN
		EXECUTE('ALTER TABLE PrintFaxEmailTable ADD VarFieldIdTo INT')
		EXECUTE('UPDATE PrintFaxEmailTable SET VarFieldIdTo = 0')
		PRINT 'Table PrintFaxEmailTable altered with new Column VarFieldIdTo'
   	END
	
	/* Added By Ishu Saraf On 21/08/2008 SrNo-14 */
	IF NOT EXISTS ( SELECT * FROM sysColumns 
			WHERE 
			id = (SELECT id FROM sysObjects WHERE NAME = 'PrintFaxEmailTable')
			AND  NAME = 'VariableIdFrom'
			)
	BEGIN
		EXECUTE('ALTER TABLE PrintFaxEmailTable ADD VariableIdFrom INT')
		EXECUTE('UPDATE PrintFaxEmailTable SET VariableIdFrom = 0')
		PRINT 'Table PrintFaxEmailTable altered with new Column VariableIdFrom'
	END
	
	/* Added By Ishu Saraf On 21/08/20088 SrNo-14 */
	IF NOT EXISTS ( SELECT * FROM sysColumns 
			WHERE 
			id = (SELECT id FROM sysObjects WHERE NAME = 'PrintFaxEmailTable')
			AND  NAME = 'VarFieldIdFrom'
			)
	BEGIN
		EXECUTE('ALTER TABLE PrintFaxEmailTable ADD VarFieldIdFrom INT')
		EXECUTE('UPDATE PrintFaxEmailTable SET VarFieldIdFrom = 0')
		PRINT 'Table PrintFaxEmailTable altered with new Column VarFieldIdFrom'
   	END

	/* Added By Ishu Saraf On 21/08/2008 SrNo-14 */
	IF NOT EXISTS ( SELECT * FROM sysColumns 
			WHERE 
			id = (SELECT id FROM sysObjects WHERE NAME = 'PrintFaxEmailTable')
			AND  NAME = 'VariableIdCc'
			)
	BEGIN
		EXECUTE('ALTER TABLE PrintFaxEmailTable ADD VariableIdCc INT')
		EXECUTE('UPDATE PrintFaxEmailTable SET VariableIdCc = 0')
		PRINT 'Table PrintFaxEmailTable altered with new Column VariableIdCc'
	END
	
	/* Added By Ishu Saraf On 21/08/20088 SrNo-14 */
	IF NOT EXISTS ( SELECT * FROM sysColumns 
			WHERE 
			id = (SELECT id FROM sysObjects WHERE NAME = 'PrintFaxEmailTable')
			AND  NAME = 'VarFieldIdCc'
			)
	BEGIN
		EXECUTE('ALTER TABLE PrintFaxEmailTable ADD VarFieldIdCc INT')
		EXECUTE('UPDATE PrintFaxEmailTable SET VarFieldIdCc = 0')
		PRINT 'Table PrintFaxEmailTable altered with new Column VarFieldIdCc'
   	END

	/* Added By Ishu Saraf On 21/08/2008 SrNo-14 */
	IF NOT EXISTS ( SELECT * FROM sysColumns 
			WHERE 
			id = (SELECT id FROM sysObjects WHERE NAME = 'PrintFaxEmailTable')
			AND  NAME = 'VariableIdFax'
			)
	BEGIN
		EXECUTE('ALTER TABLE PrintFaxEmailTable ADD VariableIdFax INT')
		EXECUTE('UPDATE PrintFaxEmailTable SET VariableIdFax = 0')
		PRINT 'Table PrintFaxEmailTable altered with new Column VariableIdFax'
	END
	
	/* Added By Ishu Saraf On 21/08/20088 SrNo-14 */
	IF NOT EXISTS ( SELECT * FROM sysColumns 
			WHERE 
			id = (SELECT id FROM sysObjects WHERE NAME = 'PrintFaxEmailTable')
			AND  NAME = 'VarFieldIdFax'
			)
	BEGIN
		EXECUTE('ALTER TABLE PrintFaxEmailTable ADD VarFieldIdFax INT')
		EXECUTE('UPDATE PrintFaxEmailTable SET VarFieldIdFax = 0')
		PRINT 'Table PrintFaxEmailTable altered with new Column VarFieldIdFax'
   	END

	/* Added By Ishu Saraf On 21/08/2008 SrNo-14 */
	IF NOT EXISTS ( SELECT * FROM sysColumns 
			WHERE 
			id = (SELECT id FROM sysObjects WHERE NAME = 'InitiateWorkItemDefTable')
			AND  NAME = 'ImportedVariableId'
			)
	BEGIN
		EXECUTE('ALTER TABLE InitiateWorkItemDefTable ADD ImportedVariableId INT')
		EXECUTE('UPDATE InitiateWorkItemDefTable SET ImportedVariableId = 0')
		PRINT 'Table InitiateWorkItemDefTable altered with new Column ImportedVariableId'
	END
	
	/* Added By Ishu Saraf On 21/08/20088 SrNo-14 */
	IF NOT EXISTS ( SELECT * FROM sysColumns 
			WHERE 
			id = (SELECT id FROM sysObjects WHERE NAME = 'InitiateWorkItemDefTable')
			AND  NAME = 'ImportedVarFieldId'
			)
	BEGIN
		EXECUTE('ALTER TABLE InitiateWorkItemDefTable ADD ImportedVarFieldId INT')
		EXECUTE('UPDATE InitiateWorkItemDefTable SET ImportedVarFieldId = 0')
		PRINT 'Table InitiateWorkItemDefTable altered with new Column ImportedVarFieldId'
   	END

	/* Added By Ishu Saraf On 21/08/2008 SrNo-14 */
	IF NOT EXISTS ( SELECT * FROM sysColumns 
			WHERE 
			id = (SELECT id FROM sysObjects WHERE NAME = 'InitiateWorkItemDefTable')
			AND  NAME = 'MappedVariableId'
			)
	BEGIN
		EXECUTE('ALTER TABLE InitiateWorkItemDefTable ADD MappedVariableId INT')
		EXECUTE('UPDATE InitiateWorkItemDefTable SET MappedVariableId = 0')
		PRINT 'Table InitiateWorkItemDefTable altered with new Column MappedVariableId'
	END
	
	/* Added By Ishu Saraf On 21/08/20088 SrNo-14 */
	IF NOT EXISTS ( SELECT * FROM sysColumns 
			WHERE 
			id = (SELECT id FROM sysObjects WHERE NAME = 'InitiateWorkItemDefTable')
			AND  NAME = 'MappedVarFieldId'
			)
	BEGIN
		EXECUTE('ALTER TABLE InitiateWorkItemDefTable ADD MappedVarFieldId INT')
		EXECUTE('UPDATE InitiateWorkItemDefTable SET MappedVarFieldId = 0')
		PRINT 'Table InitiateWorkItemDefTable altered with new Column MappedVarFieldId'
   	END

	/* Added By Ishu Saraf On 21/08/20088 SrNo-14 */
	IF NOT EXISTS ( SELECT * FROM sysColumns 
			WHERE 
			id = (SELECT id FROM sysObjects WHERE NAME = 'InitiateWorkItemDefTable')
			AND  NAME = 'DisplayName'
			)
	BEGIN
		EXECUTE('ALTER TABLE InitiateWorkItemDefTable ADD DisplayName NVARCHAR(2000)')
		PRINT 'Table InitiateWorkItemDefTable altered with new Column DisplayName'
   	END

	/* Added By Ishu Saraf On 23/04/2008 SrNo-14 */
	IF NOT EXISTS ( SELECT * FROM sysColumns 
			WHERE 
			id = (SELECT id FROM sysObjects WHERE NAME = 'ActivityTable')
			AND  NAME = 'Width'
			)
	BEGIN
		EXECUTE('ALTER TABLE ActivityTable ADD Width INT NOT NULL DEFAULT 100')
		PRINT 'Table ActivityTable altered with new Column Width'
	END

	/* Added By Ishu Saraf On 23/04/2008 SrNo-14 */
	IF NOT EXISTS ( SELECT * FROM sysColumns 
			WHERE 
			id = (SELECT id FROM sysObjects WHERE NAME = 'ActivityTable')
			AND  NAME = 'Height'
			)
	BEGIN
		EXECUTE('ALTER TABLE ActivityTable ADD Height INT NOT NULL DEFAULT 50')
		PRINT 'Table ActivityTable altered with new Column Height'
	END

	/* Added By Ishu Saraf On 1/09/2008 SrNo-14 */
	IF NOT EXISTS ( SELECT * FROM sysColumns 
			WHERE 
			id = (SELECT id FROM sysObjects WHERE NAME = 'ActivityTable')
			AND  NAME = 'BlockId'
			)
	BEGIN
		EXECUTE('ALTER TABLE ActivityTable ADD BlockId INT NOT NULL DEFAULT 0')
		PRINT 'Table ActivityTable altered with new Column BlockId'
	END

	/* Added By Ishu Saraf On 30/10/2008 SrNo-14 */
	IF NOT EXISTS ( SELECT * FROM sysColumns 
			WHERE 
			id = (SELECT id FROM sysObjects WHERE NAME = 'ActivityTable')
			AND  NAME = 'associatedUrl'
			)
	BEGIN
		EXECUTE('ALTER TABLE ActivityTable ADD associatedUrl NVarchar(255)')
		PRINT 'Table ActivityTable altered with new Column associatedUrl'
	END
	 
	/* Added By Ishu Saraf On 05/05/2008 SrNo-14 */
	IF NOT EXISTS ( SELECT * FROM sysColumns 
			WHERE 
			id = (SELECT id FROM sysObjects WHERE NAME = 'EXTMethodParamDefTable')
			AND  NAME = 'Unbounded'
			)
	BEGIN
		EXECUTE('ALTER TABLE EXTMethodParamDefTable ADD Unbounded NVARCHAR(1) NOT NULL DEFAULT N''N'' CHECK (Unbounded IN (N''Y'' , N''N''))')
		PRINT 'Table EXTMethodParamDefTable altered with new Column Unbounded'
	END


	/* Added By Ishu Saraf On 05/05/2008 SrNo-14 */
	IF NOT EXISTS ( SELECT * FROM sysColumns 
			WHERE 
			id = (SELECT id FROM sysObjects WHERE NAME = 'WFDataStructureTable')
			AND  NAME = 'Unbounded'
			)
	BEGIN
		EXECUTE('ALTER TABLE WFDataStructureTable ADD Unbounded NVARCHAR(1) NOT NULL DEFAULT N''N'' CHECK (Unbounded IN (N''Y'' , N''N''))')
		PRINT 'Table WFDataStructureTable altered with new Column Unbounded'
	END

	/*Added by Ishu Saraf On 05/05/2008*/
	IF EXISTS ( SELECT * FROM sysObjects WHERE NAME = 'WFParamMappingBuffer')
	BEGIN
		EXECUTE('DROP TABLE WFParamMappingBuffer')
		PRINT 'Table WFParamMappingBuffer is dropped.........'
	END
	ELSE
	BEGIN
		PRINT 'Table WFParamMappingBuffer does not exist...........'
	END

	/* Added By Ishu Saraf On 09/05/2008 SrNo-14 */
	IF NOT EXISTS (
		SELECT * FROM SYSObjects
		WHERE	NAME	= 'WFDataObjectTable'
		AND	xType	= 'U'
	)
	BEGIN
		EXECUTE('
			CREATE TABLE WFDataObjectTable (
				ProcessDefId 		INT 			NOT NULL,
				iId					INT				NOT NULL,
				xLeft				INT,
				yTop				INT,
				Data				Nvarchar(255),
				PRIMARY KEY ( ProcessDefId, iId)
			)
		')
		PRINT 'Table WFDataObjectTable Created Successfully....'
	END

	/* Added By Ishu Saraf On 09/05/2008 SrNo-14 */
	IF NOT EXISTS (
		SELECT * FROM SYSObjects
		WHERE	NAME	= 'WFGroupBoxTable'
		AND	xType	= 'U'
	)
	BEGIN
		EXECUTE('
			CREATE TABLE WFGroupBoxTable (
				ProcessDefId 		INT 			NOT NULL,
				GroupBoxId			INT				NOT NULL,
				GroupBoxWidth		INT,
				GroupBoxHeight		INT,
				iTop				INT,
				iLeft				INT,
				BlockName			NVARCHAR(255)	NOT NULL,
				PRIMARY KEY ( ProcessDefId, GroupBoxId)
			)
		')
		PRINT 'Table WFGroupBoxTable Created Successfully....'
	END

	/* Added By Ishu Saraf On 14/05/2008 SrNo-14 */
	IF NOT EXISTS (
		SELECT * FROM SYSObjects
		WHERE	NAME	= 'WFAdminLogTable'
		AND	xType	= 'U'
	)
	BEGIN
		EXECUTE('
			CREATE TABLE WFAdminLogTable  (
				AdminLogId			INT				IDENTITY (1,1) PRIMARY KEY,
				ActionId			INT				NOT NULL,
				ActionDateTime		DateTime		NOT NULL,
				ProcessDefId		INT,
				QueueId				INT,
				QueueName       	Nvarchar(64),
				FieldId1			INT,
				FieldName1			Nvarchar(255),
				FieldId2			INT,
				FieldName2      	Nvarchar(255),
				Property        	Nvarchar(64),
				UserId				INT,
				UserName			Nvarchar(64),
				OldValue			Nvarchar(64),
				NewValue			Nvarchar(64),
				WEFDate         	DateTime,
				ValidTillDate   	DateTime
			)
		')
		PRINT 'Table WFAdminLogTable Created Successfully.....'
	END

	/*Added by Ishu Saraf on 14/05/2008 SrNo-14*/
	/*Altering constraint on ExtMethodDefTable*/
	/*Altering constraint on ExtMethodDefTable SrNo-15 by Ananta Handoo*/
	SELECT @tableId = Id 
	FROM SYSObjects 
	WHERE NAME = 'ExtMethodDefTable'
	
	SELECT	@ConstraintName = B.NAME 
	FROM	SYSConstraints A, SYSObjects B
	WHERE	A.constId = B.Id 
	AND B.xtype	= 'C' 
	AND A.Id	= @tableId
	And A.colid = (SELECT colId 
			FROM SYSColumns 
			WHERE Id = @tableId 
			AND NAME = 'ExtAppType')
	If(@@ROWCOUNT > 0)
	Begin
		EXECUTE ('
			ALTER TABLE ExtMethodDefTable 
				DROP CONSTRAINT ' + @constraintName
		)
		EXECUTE('
			ALTER TABLE ExtMethodDefTable ADD CONSTRAINT CK_EXTMETHOD_ExtAp 
					CHECK (ExtAppType in (N''E'', N''W'', N''S'', N''Z''))
		')
		PRINT 'Constraint altered....'
	End

	/*Added by Ishu Saraf on 09/06/2008 SrNo-14*/
	IF NOT EXISTS ( SELECT * FROM sysColumns 
			WHERE 
			id = (SELECT id FROM sysObjects WHERE NAME = 'UserDiversionTable')
			AND  NAME = 'DivertedUserName'  
			)
	BEGIN
		EXECUTE('ALTER TABLE UserDiversionTable ADD DivertedUserName NVARCHAR(64)')
		PRINT 'Table UserDiversionTable altered with new column DivertedUserName'
	END

	/*Added by Ishu Saraf on 09/06/2008 SrNo-14*/
	IF NOT EXISTS ( SELECT * FROM sysColumns 
			WHERE 
			id = (SELECT id FROM sysObjects WHERE NAME = 'UserDiversionTable')
			AND  NAME = 'AssignedUserName'  
			)
	BEGIN
		EXECUTE('ALTER TABLE UserDiversionTable ADD AssignedUserName NVARCHAR(64)')
		PRINT 'Table UserDiversionTable altered with new column AssignedUserName'
	END	

	/*Added by Ishu Saraf on 1/09/2008 SrNo-14*/
	IF NOT EXISTS ( SELECT * FROM sysColumns 
			WHERE 
			id = (SELECT id FROM sysObjects WHERE NAME = 'ExtDBFieldDefinitionTable')
			AND  NAME = 'VarPrecision'  
			)
	BEGIN
		EXECUTE('ALTER TABLE ExtDBFieldDefinitionTable ADD VarPrecision INT')
		PRINT 'Table ExtDBFieldDefinitionTable altered with new column VarPrecision'
	END

	/* Added By Ishu Saraf On 06/10/2008 SrNo-14 */
	IF NOT EXISTS (
		SELECT * FROM SYSObjects
		WHERE	NAME	= 'WFAutoGenInfoTable'
		AND	xType	= 'U'
	)
	BEGIN
		EXECUTE('
			CREATE TABLE WFAutoGenInfoTable (
				TableName			NVARCHAR(30), 
				ColumnName			NVARCHAR(30), 
				Seed				INT,
				IncrementBy			INT, 
				CurrentSeqNo		INT,
				UNIQUE(TableName, ColumnName)
			)
		')
		PRINT 'Table WFAutoGenInfoTable Created Successfully'
	END

	/* Added By Ishu Saraf On 07/10/2008 - Changing QueueType for query workstep in QueueDefTable*/
	BEGIN
		DECLARE cursor1 CURSOR FAST_FORWARD FOR
		SELECT ProcessDefId, ActivityId FROM ActivityTable WHERE ActivityType = 11
		OPEN cursor1
		FETCH NEXT FROM cursor1 INTO @ProcessDefId, @ActivityId
		WHILE(@@FETCH_STATUS = 0) 
		BEGIN
			SELECT @v_STR1 = 'SELECT @QueueId = QueueId FROM QueueStreamTable where ProcessDefid = ' + convert(NVARCHAR(2000), @processdefid) + 
						     ' and ActivityId = ' + convert(NVARCHAR(20), @ActivityId)
			SELECT @v_paramDefinition1 = '@QueueId INT OUTPUT'
			EXEC sp_executesql @v_STR1, @v_paramDefinition1, @QueueId = @QueueId OUTPUT
			IF(@@ROWCOUNT != 0)
			BEGIN
				SELECT @v_STR2 = 'SELECT @QueueType = QueueType FROM QueueDefTable where QueueId = ' + convert(NVARCHAR(2000), @QueueId)
				SELECT @v_paramDefinition2 = '@QueueType NVARCHAR(1) OUTPUT'
				EXEC sp_executesql @v_STR2, @v_paramDefinition2, @QueueType = @QueueType OUTPUT
			
				IF(@QueueType != 'Q')
					UPDATE QueueDefTable SET QueueType = 'Q' WHERE QueueId = @QueueId
			END

			FETCH NEXT FROM cursor1 INTO @ProcessDefId, @ActivityId
		END
		CLOSE cursor1
		DEALLOCATE cursor1
	END

	/* Added by Ishu Saraf on 08/10/2008 - Changing ActivityType of JMS Subscriber from 19 to 21*/
	BEGIN
		DECLARE cursor1 CURSOR FAST_FORWARD FOR
		SELECT ProcessDefId, ActivityId FROM WFJMSSubscribeTable /* ProcessDefId, ActivityId FROM WFJMSSubscribeTable is selected*/
		OPEN cursor1
		FETCH NEXT FROM cursor1 INTO @ProcessDefId, @ActivityId 
		WHILE(@@FETCH_STATUS = 0) 
		BEGIN
			/* ActivityType from activitytable is selected corresponding to the ProcessDefId, ActivityId fetched */
			SELECT @v_STR1 = 'SELECT @ActivityType = ActivityType FROM ActivityTable where ProcessDefid = ' + convert(NVARCHAR(2000), @processdefid) + 
							 ' and ActivityId = ' + convert(NVARCHAR(20), @ActivityId)
			SELECT @v_paramDefinition1 = '@ActivityType INT OUTPUT'
			EXEC sp_executesql @v_STR1, @v_paramDefinition1, @ActivityType = @ActivityType OUTPUT
			IF(@@ROWCOUNT != 0)
			BEGIN
				IF(@ActivityType != 21) /* If ActivityType != 21 then it is updated */
					UPDATE ActivityTable SET ActivityType = 21 WHERE ProcessDefId = @ProcessDefId AND ActivityId = @ActivityId
			END

			FETCH NEXT FROM cursor1 INTO @ProcessDefId, @ActivityId
		END
		CLOSE cursor1
		DEALLOCATE cursor1
	END

	/* Added by Ishu Saraf on 08/10/2008 - Changing ActivityType of Webservice Invoker from 19 to 22*/
	BEGIN
		DECLARE cursor1 CURSOR FAST_FORWARD FOR
		SELECT ProcessDefId, ActivityId FROM WFWebServiceTable 
		OPEN cursor1
		FETCH NEXT FROM cursor1 INTO @ProcessDefId, @ActivityId
		WHILE(@@FETCH_STATUS = 0) 
		BEGIN
			SELECT @v_STR1 = 'SELECT @ActivityType = ActivityType FROM ActivityTable where ProcessDefid = ' + convert(NVARCHAR(2000), @processdefid) + 
							 ' and ActivityId = ' + convert(NVARCHAR(20), @ActivityId)
			SELECT @v_paramDefinition1 = '@ActivityType INT OUTPUT'
			EXEC sp_executesql @v_STR1, @v_paramDefinition1, @ActivityType = @ActivityType OUTPUT
			IF(@@ROWCOUNT != 0)
			BEGIN
				IF(@ActivityType != 22)
					UPDATE ActivityTable SET ActivityType = 22 WHERE ProcessDefId = @ProcessDefId AND ActivityId = @ActivityId
			END

			FETCH NEXT FROM cursor1 INTO @ProcessDefId, @ActivityId
		END
		CLOSE cursor1
		DEALLOCATE cursor1
	END

	/* Added by Ishu Saraf on 08/10/2008 */
	IF NOT EXISTS (
		SELECT * FROM SYSObjects
		WHERE	NAME	= 'WFProxyInfo'
		AND	xType	= 'U'
	)
	BEGIN
		EXECUTE('
			CREATE TABLE WFProxyInfo (
			   ProxyHost			NVARCHAR(200)				NOT NULL,
			   ProxyPort			NVARCHAR(200)				NOT NULL,
			   ProxyUser			NVARCHAR(200)				NOT NULL,
			   ProxyPassword		NVARCHAR(512),
			   DebugFlag			NVARCHAR(200),				
			   ProxyEnabled			NVARCHAR(200)
			)
		')
		PRINT 'Table WFProxyInfo Created Successfully'
	END

	/* Added By Ishu Saraf On 22/11/2008 SrNo-14 */
	IF EXISTS ( SELECT * FROM sysColumns 
			WHERE 
			id = (SELECT id FROM sysObjects WHERE NAME = 'GenerateResponseTable')
			AND  NAME = 'ArgList'
			)
	BEGIN
		EXECUTE('ALTER TABLE GenerateResponseTable DROP COLUMN ArgList')
		PRINT 'Column ArgList dropped successfully........'
		EXECUTE('ALTER TABLE TemplateDefinitionTable ADD ArgList NVARCHAR(512) NULL')
		PRINT 'Table TemplateDefinitionTable altered with new column ArgList.........'
	END

	/* Added By Ishu Saraf On 22/11/2008 SrNo-14 */
	IF NOT EXISTS (
		SELECT * FROM SYSObjects
		WHERE	NAME	= 'WFAuthorizationTable'
		AND	xType	= 'U'
	)
	BEGIN
		EXECUTE('
			CREATE TABLE WFAuthorizationTable (
				AuthorizationID		INT 			identity (1, 1) PRIMARY KEY,
				EntityType			NVARCHAR(1)		CHECK (EntityType = ''Q'' or EntityType = ''P''),
				EntityID			INT				NULL,
				EntityName			NVARCHAR(63)	NOT NULL,
				ActionDateTime		DATETIME		NOT NULL,
				MakerUserName		NVARCHAR(256)	NOT NULL,
				CheckerUserName		NVARCHAR(256)	NULL,
				Comments			NVARCHAR(2000)	NULL,
				Status				NVARCHAR(1)		CHECK (Status = ''P'' or Status = ''R'' or Status = ''I'')	
			)
		')
		PRINT 'Table WFAuthorizationTable Created Successfully'
	END

	/* Added By Ishu Saraf On 22/11/2008 SrNo-14 */
	IF NOT EXISTS (
		SELECT * FROM SYSObjects
		WHERE	NAME	= 'WFAuthorizeQueueDefTable'
		AND	xType	= 'U'
	)
	BEGIN
		EXECUTE('
			CREATE TABLE WFAuthorizeQueueDefTable (
				AuthorizationID		INT				NOT NULL,
				ActionId			INT				NOT NULL,	
				QueueType			NVARCHAR(1)		NULL,
				Comments			NVARCHAR(255)	NULL ,
				AllowReASsignment 	NVARCHAR(1)		NULL,
				FilterOption		INT				NULL,
				FilterValue			NVARCHAR(63)	NULL,
				OrderBy				INT				NULL,
				QueueFilter			NVARCHAR(2000)	NULL
			) 
		')
		PRINT 'Table WFAuthorizeQueueDefTable Created Successfully'
	END

	/* Added By Ishu Saraf On 22/11/2008 SrNo-14 */
	IF NOT EXISTS (
		SELECT * FROM SYSObjects
		WHERE	NAME	= 'WFAuthorizeQueueStreamTable'
		AND	xType	= 'U'
	)
	BEGIN
		EXECUTE('
			CREATE TABLE WFAuthorizeQueueStreamTable (
				AuthorizationID	INT				NOT NULL,
				ActionId		INT				NOT NULL,	
				ProcessDefID 	INT				NOT NULL,
				ActivityID 		INT				NOT NULL,
				StreamId 		INT				NOT NULL,
				StreamName		NVARCHAR(30) 	NOT NULL
			)
		')
		PRINT 'Table WFAuthorizeQueueStreamTable Created Successfully'
	END

	/* Added By Ishu Saraf On 22/11/2008 SrNo-14 */
	IF NOT EXISTS (
		SELECT * FROM SYSObjects
		WHERE	NAME	= 'WFAuthorizeQueueUserTable'
		AND	xType	= 'U'
	)
	BEGIN
		EXECUTE('
			CREATE TABLE WFAuthorizeQueueUserTable (
				AuthorizationID			INT				NOT NULL,
				ActionId				INT				NOT NULL,	
				Userid					SMALLINT		NOT NULL,
				ASsociationType			SMALLINT		NULL,
				ASsignedTillDATETIME	DATETIME		NULL, 
				QueryFilter				NVARCHAR(2000)	NULL,
				UserName				NVARCHAR(256)	NOT NULL
			)  
		')
		PRINT 'Table WFAuthorizeQueueUserTable Created Successfully'
	END

	/* Added By Ishu Saraf On 22/11/2008 SrNo-14 */
	IF NOT EXISTS (
		SELECT * FROM SYSObjects
		WHERE	NAME	= 'WFAuthorizeProcessDefTable'
		AND	xType	= 'U'
	)
	BEGIN
		EXECUTE('
			CREATE TABLE WFAuthorizeProcessDefTable (
				AuthorizationID		INT				NOT NULL,
				ActionId			INT				NOT NULL,	
				VersionNo			SMALLINT		NOT NULL,
				ProcessState		NVARCHAR(10)	NOT NULL 
			)
		')
		PRINT 'Table WFAuthorizeProcessDefTable Created Successfully'
	END

	/* Added By Ishu Saraf On 22/11/2008 SrNo-14 */
	IF NOT EXISTS (
		SELECT * FROM SYSObjects
		WHERE	NAME	= 'WFSoapReqCorrelationTable'
		AND	xType	= 'U'
	)
	BEGIN
		EXECUTE('
			CREATE TABLE WFSoapReqCorrelationTable (
			   Processdefid     INT					NOT NULL,
			   ActivityId       INT					NOT NULL,
			   PropAlias        NVARCHAR(255)		NOT NULL,
			   VariableId       INT					NOT NULL,
			   VarFieldId       INT					NOT NULL,
			   SearchField      NVARCHAR(255)		NOT NULL,
			   SearchVariableId INT					NOT NULL,
			   SearchVarFieldId INT					NOT NULL
			)
		')
		PRINT 'Table WFSoapReqCorrelationTable Created Successfully'
	END

	/* Added By Ishu Saraf On 22/11/2008 SrNo-14 */
	IF NOT EXISTS ( SELECT * FROM sysColumns 
			WHERE 
			id = (SELECT id FROM sysObjects WHERE NAME = 'WFDurationTable')
			AND  NAME = 'VariableId_Years'
			)
	BEGIN
		EXECUTE('ALTER TABLE WFDurationTable ADD VariableId_Years INT')
		EXECUTE('UPDATE WFDurationTable SET VariableId_Years = 0')
		PRINT 'Table WFDurationTable altered with new Column VariableId_Years'
	END
	
	/* Added By Ishu Saraf On 22/11/2008 SrNo-14 */
	IF NOT EXISTS ( SELECT * FROM sysColumns 
			WHERE 
			id = (SELECT id FROM sysObjects WHERE NAME = 'WFDurationTable')
			AND  NAME = 'VarFieldId_Years'
			)
	BEGIN
		EXECUTE('ALTER TABLE WFDurationTable ADD VarFieldId_Years INT')
		EXECUTE('UPDATE WFDurationTable SET VarFieldId_Years = 0')
		PRINT 'Table WFDurationTable altered with new Column VarFieldId_Years'
	END
	
	/* Added By Ishu Saraf On 22/11/2008 SrNo-14 */
	IF NOT EXISTS ( SELECT * FROM sysColumns 
			WHERE 
			id = (SELECT id FROM sysObjects WHERE NAME = 'WFDurationTable')
			AND  NAME = 'VariableId_Months'
			)
	BEGIN
		EXECUTE('ALTER TABLE WFDurationTable ADD VariableId_Months INT')
		EXECUTE('UPDATE WFDurationTable SET VariableId_Months = 0')
		PRINT 'Table WFDurationTable altered with new Column VariableId_Months'
	END
	
	/* Added By Ishu Saraf On 22/11/2008 SrNo-14 */
	IF NOT EXISTS ( SELECT * FROM sysColumns 
			WHERE 
			id = (SELECT id FROM sysObjects WHERE NAME = 'WFDurationTable')
			AND  NAME = 'VarFieldId_Months'
			)
	BEGIN
		EXECUTE('ALTER TABLE WFDurationTable ADD VarFieldId_Months INT')
		EXECUTE('UPDATE WFDurationTable SET VarFieldId_Months = 0')
		PRINT 'Table WFDurationTable altered with new Column VarFieldId_Months'
	END
	
	/* Added By Ishu Saraf On 22/11/2008 SrNo-14 */
	IF NOT EXISTS ( SELECT * FROM sysColumns 
			WHERE 
			id = (SELECT id FROM sysObjects WHERE NAME = 'WFDurationTable')
			AND  NAME = 'VariableId_Days'
			)
	BEGIN
		EXECUTE('ALTER TABLE WFDurationTable ADD VariableId_Days INT')
		EXECUTE('UPDATE WFDurationTable SET VariableId_Days = 0')
		PRINT 'Table WFDurationTable altered with new Column VariableId_Days'
	END
	
	/* Added By Ishu Saraf On 22/11/2008 SrNo-14 */
	IF NOT EXISTS ( SELECT * FROM sysColumns 
			WHERE 
			id = (SELECT id FROM sysObjects WHERE NAME = 'WFDurationTable')
			AND  NAME = 'VarFieldId_Days'
			)
	BEGIN
		EXECUTE('ALTER TABLE WFDurationTable ADD VarFieldId_Days INT')
		EXECUTE('UPDATE WFDurationTable SET VarFieldId_Days = 0')
		PRINT 'Table WFDurationTable altered with new Column VarFieldId_Days'
	END

	/* Added By Ishu Saraf On 22/11/2008 SrNo-14 */
	IF NOT EXISTS ( SELECT * FROM sysColumns 
			WHERE 
			id = (SELECT id FROM sysObjects WHERE NAME = 'WFDurationTable')
			AND  NAME = 'VariableId_Hours'
			)
	BEGIN
		EXECUTE('ALTER TABLE WFDurationTable ADD VariableId_Hours INT')
		EXECUTE('UPDATE WFDurationTable SET VariableId_Hours = 0')
		PRINT 'Table WFDurationTable altered with new Column VariableId_Hours'
	END
	
	/* Added By Ishu Saraf On 22/11/2008 SrNo-14 */
	IF NOT EXISTS ( SELECT * FROM sysColumns 
			WHERE 
			id = (SELECT id FROM sysObjects WHERE NAME = 'WFDurationTable')
			AND  NAME = 'VarFieldId_Hours'
			)
	BEGIN
		EXECUTE('ALTER TABLE WFDurationTable ADD VarFieldId_Hours INT')
		EXECUTE('UPDATE WFDurationTable SET VarFieldId_Hours = 0')
		PRINT 'Table WFDurationTable altered with new Column VarFieldId_Hours'
	END
	
	/* Added By Ishu Saraf On 22/11/2008 SrNo-14 */
	IF NOT EXISTS ( SELECT * FROM sysColumns 
			WHERE 
			id = (SELECT id FROM sysObjects WHERE NAME = 'WFDurationTable')
			AND  NAME = 'VariableId_Minutes'
			)
	BEGIN
		EXECUTE('ALTER TABLE WFDurationTable ADD VariableId_Minutes INT')
		EXECUTE('UPDATE WFDurationTable SET VariableId_Minutes = 0')
		PRINT 'Table WFDurationTable altered with new Column VariableId_Minutes'
	END
	
	/* Added By Ishu Saraf On 22/11/2008 SrNo-14 */
	IF NOT EXISTS ( SELECT * FROM sysColumns 
			WHERE 
			id = (SELECT id FROM sysObjects WHERE NAME = 'WFDurationTable')
			AND  NAME = 'VarFieldId_Minutes'
			)
	BEGIN
		EXECUTE('ALTER TABLE WFDurationTable ADD VarFieldId_Minutes INT')
		EXECUTE('UPDATE WFDurationTable SET VarFieldId_Minutes = 0')
		PRINT 'Table WFDurationTable altered with new Column VarFieldId_Minutes'
	END
	
	/* Added By Ishu Saraf On 22/11/2008 SrNo-14 */
	IF NOT EXISTS ( SELECT * FROM sysColumns 
			WHERE 
			id = (SELECT id FROM sysObjects WHERE NAME = 'WFDurationTable')
			AND  NAME = 'VariableId_Seconds'
			)
	BEGIN
		EXECUTE('ALTER TABLE WFDurationTable ADD VariableId_Seconds INT')
		EXECUTE('UPDATE WFDurationTable SET VariableId_Seconds = 0')
		PRINT 'Table WFDurationTable altered with new Column VariableId_Seconds'
	END
	
	/* Added By Ishu Saraf On 22/11/2008 SrNo-14 */
	IF NOT EXISTS ( SELECT * FROM sysColumns 
			WHERE 
			id = (SELECT id FROM sysObjects WHERE NAME = 'WFDurationTable')
			AND  NAME = 'VarFieldId_Seconds'
			)
	BEGIN
		EXECUTE('ALTER TABLE WFDurationTable ADD VarFieldId_Seconds INT')
		EXECUTE('UPDATE WFDurationTable SET VarFieldId_Seconds = 0')
		PRINT 'Table WFDurationTable altered with new Column VarFieldId_Seconds'
	END

	/* Added By Ishu Saraf On 27/11/2008 SrNo-14 */
	IF NOT EXISTS ( SELECT * FROM sysColumns 
			WHERE 
			id = (SELECT id FROM sysObjects WHERE NAME = 'WFWebServiceTable')
			AND  NAME = 'ReplyPath'
			)
	BEGIN
		EXECUTE('ALTER TABLE WFWebServiceTable ADD ReplyPath NVARCHAR(256)')
		PRINT 'Table WFWebServiceTable altered with new Column ReplyPath'
	END

	/* Added By Ishu Saraf On 27/11/2008 SrNo-14 */
	IF NOT EXISTS ( SELECT * FROM sysColumns 
			WHERE 
			id = (SELECT id FROM sysObjects WHERE NAME = 'WFWebServiceTable')
			AND  NAME = 'AssociatedActivityId'
			)
	BEGIN
		EXECUTE('ALTER TABLE WFWebServiceTable ADD AssociatedActivityId INT ')
		EXECUTE('UPDATE WFWebServiceTable SET AssociatedActivityId = 0 ')
		PRINT 'Table WFWebServiceTable altered with new Column AssociatedActivityId'
	END

	/* Added By Ishu Saraf On 27/11/2008 SrNo-14 */
	IF NOT EXISTS (
		SELECT * FROM SYSObjects
		WHERE	NAME	= 'WFWSAsyncResponseTable'
		AND	xType	= 'U'
	)
	BEGIN
		EXECUTE('
			CREATE TABLE WFWSAsyncResponseTable (
				ProcessDefId		INT				NOT NULL, 
				ActivityId			INT				NOT NULL, 
				ProcessInstanceId	Nvarchar(64)	NOT NULL, 
				WorkitemId			INT				NOT NULL, 
				CorrelationId1		Nvarchar(100)		NULL, 
				CorrelationId2		Nvarchar(100)		NULL, 
				OutParamXML			Nvarchar(2000)		NULL, 
				Response			NTEXT				NULL,
				CONSTRAINT UK_WFWSAsyncResponseTable UNIQUE (ActivityId, ProcessInstanceId, WorkitemId)
			)
		')
		PRINT 'Table WFWSAsyncResponseTable Created Successfully'
	END

	/* Added By Ishu Saraf On 06/12/2008 SrNo-14 */
	IF NOT EXISTS ( SELECT * FROM sysColumns 
			WHERE 
			id = (SELECT id FROM sysObjects WHERE NAME = 'ActivityTable')
			AND  NAME = 'allowSOAPRequest'
			)
	BEGIN
		EXECUTE('ALTER TABLE ActivityTable ADD allowSOAPRequest NVarChar(1) NOT NULL DEFAULT N''N'' CHECK (allowSOAPRequest IN (N''Y'' , N''N'')) ')
		PRINT 'Table ActivityTable altered with new Column allowSOAPRequest'
	END

	/* Added By Ishu Saraf On 08/12/2008 SrNo-14 */
	IF NOT EXISTS ( SELECT * FROM sysColumns 
			WHERE 
			id = (SELECT id FROM sysObjects WHERE NAME = 'ActivityTable')
			AND  NAME = 'AssociatedActivityId'
			)
	BEGIN
		EXECUTE('ALTER TABLE ActivityTable ADD AssociatedActivityId INT')
		EXECUTE('UPDATE ActivityTable SET AssociatedActivityId = 0')
		PRINT 'Table ActivityTable altered with new Column AssociatedActivityId'
	END

	/* Added By Ishu Saraf On 06/12/2008 SrNo-14 - Changes for AssociatedActivityId for JMS Subscriber in case of Asynchronous WebService Invocation */
	BEGIN
		DECLARE cursor1 CURSOR FAST_FORWARD FOR
		SELECT ActivityId FROM WFWebServiceTable WHERE InvocationType = 'A' /* ActivityId FROM WFWebServiceTable is selected*/
		OPEN cursor1
		FETCH NEXT FROM cursor1 INTO @ActivityId 
		WHILE(@@FETCH_STATUS = 0) 
		BEGIN
			/* TargetActivityId from activitytable is selected corresponding to the ActivityId fetched */
			SELECT @v_STR1 = 'SELECT @TargetActivityId = TargetActivityId FROM ActivityTable where ActivityId = ' + convert(NVARCHAR(2000), @ActivityId)
			SELECT @v_paramDefinition1 = '@TargetActivityId INT OUTPUT'
			EXEC sp_executesql @v_STR1, @v_paramDefinition1, @TargetActivityId = @TargetActivityId OUTPUT
			IF(@@ROWCOUNT != 0)
			BEGIN
				SELECT @v_STR1 = ' UPDATE ActivityTable SET AssociatedActivityId = ' + CONVERT(NVARCHAR(20), @TargetActivityId) + ' WHERE ActivityId = ' + CONVERT(NVARCHAR(20), @ActivityId)
				EXECUTE(@v_STR1)
			END

			FETCH NEXT FROM cursor1 INTO @ActivityId
		END
		CLOSE cursor1
		DEALLOCATE cursor1
	END

	/* Added By Ishu Saraf On 15/12/2008 SrNo-14 */
	IF NOT EXISTS (
		SELECT * FROM SYSObjects
		WHERE	NAME	= 'WFScopeDefTable'
		AND	xType	= 'U'
	)
	BEGIN
		EXECUTE('
			CREATE TABLE WFScopeDefTable (
				ProcessDefId		INT				NOT NULL,
				ScopeId				INT				NOT NULL,
				ScopeName			NVarChar(256)	NOT NULL,
				PRIMARY KEY (ProcessDefId, ScopeId)
			)
		')
		PRINT 'Table WFScopeDefTable Created Successfully'
	END

	/* Added By Ishu Saraf On 15/12/2008 SrNo-14 */
	IF NOT EXISTS (
		SELECT * FROM SYSObjects
		WHERE	NAME	= 'WFEventDefTable'
		AND	xType	= 'U'
	)
	BEGIN
		EXECUTE('
			CREATE TABLE WFEventDefTable (
				ProcessDefId				INT				NOT NULL,
				EventId						INT				NOT NULL,
				ScopeId						INT					NULL,
				EventType					NVarChar(1)		DEFAULT N''M'' CHECK (EventType IN (N''A'' , N''M'')),
				EventDuration				INT					NULL,
				EventFrequency				NVarChar(1)		CHECK (EventFrequency IN (N''O'' , N''M'')),
				EventInitiationActivityId	INT				NOT NULL,
				EventName					NVarChar(64)	NOT NULL,
				associatedUrl				NVarChar(255)		NULL,
				PRIMARY KEY (ProcessDefId, EventId)
			)
		')
		PRINT 'Table WFEventDefTable Created Successfully'
	END

	/* Added By Ishu Saraf On 15/12/2008 SrNo-14 */
	IF NOT EXISTS (
		SELECT * FROM SYSObjects
		WHERE	NAME	= 'WFActivityScopeAssocTable'
		AND	xType	= 'U'
	)
	BEGIN
		EXECUTE('
			CREATE TABLE WFActivityScopeAssocTable (
				ProcessDefId		INT			NOT NULL,
				ScopeId				INT			NOT NULL,
				ActivityId			INT			NOT NULL,
				CONSTRAINT UK_WFActivityScopeAssocTable UNIQUE (ProcessDefId, ScopeId, ActivityId)
			)
		')
		PRINT 'Table WFActivityScopeAssocTable Created Successfully'
	END

	/* Added By Ishu Saraf On 15/12/2008 SrNo-14 */
	IF NOT EXISTS ( SELECT * FROM sysColumns 
			WHERE 
			id = (SELECT id FROM sysObjects WHERE NAME = 'ActivityTable')
			AND  NAME = 'EventId'
			)
	BEGIN
		EXECUTE('ALTER TABLE ActivityTable ADD EventId INT')
		EXECUTE('UPDATE ActivityTable SET EventId = 0')
		PRINT 'Table ActivityTable altered with new Column EventId'
	END
	
	/************** INDEX CREATION **************/
	IF NOT EXISTS(SELECT * FROM sysIndexes WITH (NOLOCK) WHERE NAME = 'IX1_WFMessageInProcessTable')
	Begin
		CREATE INDEX IX1_WFMessageInProcessTable ON WFMessageInProcessTable (lockedBy)
		PRINT 'Index on lockedBy of WFMessageInProcessTable created successfully'
	End

	If Exists(	Select * 
			FROM SYSObjects 
			WHERE	name	= 'CURRENTROUTELOGTABLE'
			AND	xType	= 'U'
		)
		BEGIN
	IF NOT EXISTS(SELECT * FROM sysIndexes WITH (NOLOCK) WHERE NAME = 'IDX3_CRouteLogTable')
	Begin
		CREATE INDEX IDX3_CRouteLogTable ON CurrentRouteLogTable (ProcessInstanceId)
		PRINT 'Index on ProcessInstanceId of CurrentRouteLogTable created successfully'
	End
END

If Exists(	Select * 
			FROM SYSObjects 
			WHERE	name	= 'HistoryRouteLogTable'
			AND	xType	= 'U'
		)
		BEGIN
	IF NOT EXISTS(SELECT * FROM sysIndexes WITH (NOLOCK) WHERE NAME = 'IDX3_HRouteLogTable')
	 Begin
		CREATE INDEX IDX3_HRouteLogTable ON HistoryRouteLogTable (ProcessInstanceId)
	 	PRINT 'Index on ProcessInstanceId of HistoryRouteLogTable created successfully'
	 End
END
	IF NOT EXISTS(SELECT * FROM sysIndexes WITH (NOLOCK) WHERE NAME = 'IDX2_QueueDataTable')
	Begin
		CREATE INDEX IDX2_QueueDataTable ON QueueDataTable (var_rec_1, var_rec_2)
		PRINT 'Index on var_rec_1, var_rec_2 of QueueDataTable created successfully'
	End

	IF NOT EXISTS(SELECT * FROM sysIndexes WITH (NOLOCK) WHERE NAME = 'IDX2_WorkListTable')
	Begin
		CREATE INDEX IDX2_WorkListTable ON WorkListTable (Q_QueueId)
		PRINT 'Index on Q_QueueId of WorkListTable created successfully'
	End

	IF NOT EXISTS(SELECT * FROM sysIndexes WITH (NOLOCK) WHERE NAME = 'IDX3_WorkListTable')
	Begin
		CREATE INDEX IDX3_WorkListTable ON WorkListTable (Q_QueueId, WorkItemState)
		PRINT 'Index on Q_QueueId, WorkItemState of WorkListTable created successfully'
	End

	IF NOT EXISTS(SELECT * FROM sysIndexes WITH (NOLOCK) WHERE NAME = 'IDX2_WorkInProcessTable')
	Begin
		CREATE INDEX IDX2_WorkInProcessTable ON WorkInProcessTable (Q_QueueId)
		PRINT 'Index on Q_QueueId of WorkInProcessTable created successfully'
	End

	IF NOT EXISTS(SELECT * FROM sysIndexes WITH (NOLOCK) WHERE NAME = 'IDX3_WorkInProcessTable')
	Begin
		CREATE INDEX IDX3_WorkInProcessTable ON WorkInProcessTable (Q_QueueId, WorkItemState)
		PRINT 'Index on Q_QueueId, WorkItemState of WorkInProcessTable created successfully'
	End

	IF NOT EXISTS(SELECT * FROM sysIndexes WITH (NOLOCK) WHERE NAME = 'IDX1_QueueStreamTable')
	Begin
		CREATE INDEX IDX1_QueueStreamTable ON QueueStreamTable (QueueId)
		PRINT 'Index on QueueId of QueueStreamTable created successfully'
	End

	IF NOT EXISTS(SELECT * FROM sysIndexes WITH (NOLOCK) WHERE NAME = 'IDX2_QueueDefTable')
	Begin
		CREATE INDEX IDX2_QueueDefTable ON QueueDefTable (QueueNAME)
		PRINT 'Index on QueueName of QueueDefTable created successfully'
	End

	IF NOT EXISTS(SELECT * FROM sysIndexes WITH (NOLOCK) WHERE NAME = 'IDX2_VarMappingTable')
	Begin
		CREATE INDEX IDX2_VarMappingTable ON VarMappingTable (UserDefinedNAME)
		PRINT 'Index on UserDefinedName of VarMappingTable created successfully'
	End

	IF NOT EXISTS(SELECT * FROM sysIndexes WITH (NOLOCK) WHERE NAME = 'IX2_WFMessageInProcessTable')
	Begin
		CREATE INDEX IX2_WFMessageInProcessTable ON WFMessageInProcessTable (messageId)
		PRINT 'Index on messageId of WFMessageInProcessTable created successfully'
	End

	IF NOT EXISTS(SELECT * FROM sysIndexes WITH (NOLOCK) WHERE NAME = 'IX1_WFEscalationTable')
	Begin
		CREATE NONCLUSTERED INDEX IX1_WFEscalationTable ON WFEscalationTable (EscalationMode, ScheduleTime)
		PRINT 'Index on EscalationMode, ScheduleTime of IX1_WFEscalationTable created successfully'
	End

	/* 28/05/2007 Bugzilla Id 819 Varun Bhansaly */ 
	IF NOT EXISTS(SELECT * FROM sysIndexes WITH (NOLOCK) WHERE NAME = 'IDX1_WFActivityReportTable')
	Begin
		CREATE INDEX IDX1_WFActivityReportTable ON WFActivityReportTable (ProcessDefId, ActivityId, ActionDateTime)
		PRINT 'Index on ProcessDefId, ActivityId, ActionDateTime of WFActivityReportTable created successfully'
	End

	/* 28/05/2007 Bugzilla Id 819 Varun Bhansaly */ 
	IF NOT EXISTS(SELECT * FROM sysIndexes WITH (NOLOCK) WHERE NAME = 'IDX1_WFReportDataTable')
	Begin
		CREATE INDEX IDX1_WFReportDataTable ON WFReportDataTable (ProcessInstanceId, WorkitemId, ProcessDefId, ActivityId, UserId)
		PRINT 'Index on ProcessInstanceId, WorkitemId, ProcessDefId, ActivityId, UserId of WFReportDataTable created successfully'
	End

	/* Added By Varun Bhansaly On 29/10/2007 Bugzilla Id 1677 */ 
	IF NOT EXISTS(SELECT * FROM sysIndexes WITH (NOLOCK) WHERE NAME = 'IDX1_VarAliasTable')
	Begin
		CREATE INDEX IDX1_VarAliasTable ON VarAliasTable (QueueId, Id)
		PRINT 'Index on QueueId, Id of VarAliasTable created successfully'
	End

	/* Added By Varun Bhansaly On 29/10/2007 */ 
	IF NOT EXISTS(SELECT * FROM sysIndexes WITH (NOLOCK) WHERE NAME = 'IDX1_WFQuickSearchTable')
	Begin
		CREATE INDEX IDX1_WFQuickSearchTable ON WFQuickSearchTable (Alias)
		PRINT 'Index on Alias of WFQuickSearchTable created successfully'
	End

	/* Added By Varun Bhansaly On 29/10/2007 */ 
	IF NOT EXISTS(SELECT * FROM sysIndexes WITH (NOLOCK) WHERE NAME = 'IDX1_WFCommentsTable')
	Begin
		CREATE INDEX IDX1_WFCommentsTable ON WFCommentsTable (ProcessInstanceId, ActivityId)		
		PRINT 'Index on ProcessInstanceId, ActivityId of WFCommentsTable created successfully'
	End

	/* Added By Varun Bhansaly On 19/12/2007 SrNo-11 */
	IF NOT EXISTS(SELECT * FROM sysIndexes WITH (NOLOCK) WHERE NAME = 'IDX1_WFExportTable')
	Begin
		CREATE INDEX IDX1_WFExportTable ON WFExportTable (ProcessDefId, ActivityId)
		PRINT 'Index on ProcessDefId, ActivityId of WFExportTable created successfully'
	End

	/* Added By Varun Bhansaly On 19/12/2007 SrNo-12 */
	IF NOT EXISTS(SELECT * FROM sysIndexes WITH (NOLOCK) WHERE NAME = 'IDX1_WFDataMapTable')
	Begin
		CREATE INDEX IDX1_WFDataMapTable ON WFDataMapTable (ProcessDefId, ActivityId)
		PRINT 'Index on ProcessDefId, ActivityId of WFDataMapTable created successfully'
	End

	/* Added By Varun Bhansaly On 25/01/2008 Bugzilla Id 1719 */
	IF NOT EXISTS(SELECT * FROM sysIndexes WITH (NOLOCK) WHERE NAME = 'IDX1_ExceptionTable')
	Begin
		CREATE INDEX IDX1_ExceptionTable ON ExceptionTable (ProcessInstanceId, ProcessDefId, ActivityId, ExceptionId, excpseqid DESC, ActionId DESC)
		PRINT 'Index on (ProcessInstanceId, ProcessDefId, ActivityId, ExceptionId, excpseqid DESC, ActionId DESC) of ExceptionTable created successfully'
	End

	/* Added By Varun Bhansaly On 25/01/2008 Bugzilla Id 1719 */
	IF NOT EXISTS(SELECT * FROM sysIndexes WITH (NOLOCK) WHERE NAME = 'IDX2_ExceptionTable')
	Begin
		CREATE INDEX IDX2_ExceptionTable ON ExceptionTable (ProcessInstanceId)
		PRINT 'Index on ProcessInstanceId of ExceptionTable created successfully'
	End

	/* Added By Varun Bhansaly On 25/01/2008 Bugzilla Id 1719 */
	IF NOT EXISTS(SELECT * FROM sysIndexes WITH (NOLOCK) WHERE NAME = 'IDX1_ExceptionHistoryTable')
	Begin
		CREATE INDEX IDX1_ExceptionHistoryTable ON ExceptionHistoryTable (ProcessInstanceId, ProcessDefId, ActivityId, ExceptionId, excpseqid DESC, ActionId DESC)
		PRINT 'Index on (ProcessInstanceId, ProcessDefId, ActivityId, ExceptionId, excpseqid DESC, ActionId DESC) of ExceptionHistoryTable created successfully'
	End

	/* Added By Varun Bhansaly On 25/01/2008 Bugzilla Id 1719 */
	IF NOT EXISTS(SELECT * FROM sysIndexes WITH (NOLOCK) WHERE NAME = 'IDX2_ExceptionHistoryTable')
	Begin
		CREATE INDEX IDX2_ExceptionHistoryTable ON ExceptionTable (ProcessInstanceId)
		PRINT 'Index on ProcessInstanceId of ExceptionHistoryTable created successfully'
	End

	/* Added By Ashish Mangla On 08/12/2008 Bugzilla Id 6433 */
	IF EXISTS(SELECT * FROM sysIndexes WITH (NOLOCK) WHERE name = 'IX2_SUMMARYTABLE')
	Begin
		DROP INDEX SUMMARYTABLE.IX2_SUMMARYTABLE
		PRINT 'Index IX2_SUMMARYTABLE on SUMMARYTABLE dropped successfully'
	End

	IF EXISTS(SELECT * FROM sysIndexes WITH (NOLOCK) WHERE name = 'IX1_SUMMARYTABLE')
	Begin
		DROP INDEX SUMMARYTABLE.IX1_SUMMARYTABLE
		CREATE INDEX IX1_SUMMARYTABLE ON SUMMARYTABLE  (PROCESSDEFID, ACTIONID, ActionDateTime, ACTIVITYID, QueueId, USERID)
		PRINT 'Index IX1_SUMMARYTABLE on SUMMARYTABLE recreated successfully'
	End

	/* Added By Ishu Saraf On 05/06/2008 */
	IF NOT EXISTS(SELECT * FROM sysIndexes WITH (NOLOCK) WHERE NAME = 'IDX1_ActivityAssociationTable')
	BEGIN
		CREATE INDEX IDX1_ActivityAssociationTable ON ActivityAssociationTable (ProcessdefId, ActivityId, VariableId)
		PRINT 'Index on (ProcessdefId, ActivityId, VariableId) of ActivityAssociationTable created successfully'
	END	

	/* Added By Ishu Saraf On 28/11/2008 */
	IF NOT EXISTS(SELECT * FROM sysIndexes WITH (NOLOCK) WHERE NAME = 'IDX1_WFWSAsyncResponseTable')
	BEGIN
		CREATE INDEX IDX1_WFWSAsyncResponseTable ON WFWSAsyncResponseTable (CorrelationId1)
		PRINT 'Index on (CorrelationId1) of WFWSAsyncResponseTable created successfully'
	END
END
~

PRINT 'Executing procedure Upgrade ........... '
EXEC Upgrade
~			

DROP PROCEDURE Upgrade

~

/* Added By Ishu Saraf 21/10/2008 - Search criteria in WFSearchVariableTable */
IF EXISTS (SELECT * FROM SysObjects WHERE xType = 'P' and NAME = 'Upgrade_SearchVariables')
BEGIN
	EXECUTE('DROP PROCEDURE Upgrade_SearchVariables')
	PRINT 'Procedure Upgrade_SearchVariables already exists, hence older one dropped ..... '
END

~

CREATE PROCEDURE Upgrade_SearchVariables AS 
BEGIN
	DECLARE @DefaultIntroductionActID	INTEGER
	DECLARE @QueryActivityId			INTEGER
	DECLARE @OrderID					INTEGER
	DECLARE @FieldName					NVARCHAR(255)
	DECLARE @processDefId				INT

	IF NOT EXISTS(SELECT * FROM sysObjects WHERE NAME = 'WFSearchVariableTable')
	BEGIN
		CREATE TABLE WFSearchVariableTable (
			ProcessDefID 		INT				NOT NULL,
			ActivityID 			INT				NOT NULL,
			FieldName			NVARCHAR(255)	NOT NULL,
			Scope				NVARCHAR(1)		NOT NULL	CHECK (Scope = 'C' or Scope = 'F' or Scope = 'R'),
			OrderID 			INT				NOT NULL
			PRIMARY KEY (ProcessDefID, ActivityID, FieldName, Scope)
		)
		PRINT 'Table WFSearchVariableTable created successfully'

		DECLARE search_cursor CURSOR FAST_FORWARD FOR 
			SELECT ProcessDefID, ActivityID
			FROM ActivityTable
			WHERE ActivityType = 1 
			AND PrimaryActivity = 'Y'

		OPEN search_cursor 
		FETCH search_cursor INTO @ProcessDefID, @DefaultIntroductionActID 
		IF (@@Fetch_Status = -1 OR  @@Fetch_Status = -2) 
		BEGIN 
			CLOSE search_cursor 
			DEALLOCATE search_cursor 
			RETURN 
		END 

		WHILE(@@FETCH_STATUS  <> -1) 
		BEGIN 
			IF(@@FETCH_STATUS <> -2) 
			BEGIN
				DECLARE update_cursor CURSOR FAST_FORWARD FOR
				SELECT FieldName
				FROM ActivityAssociationTable
				WHERE ProcessDefID = @ProcessDefID AND ActivityID = @DefaultIntroductionActID
				AND DefinitionType in ( 'I' , 'Q' , 'N' ) AND Attribute in ( 'O', 'B' , 'R' , 'M' )

				OPEN update_cursor 
				FETCH update_cursor INTO @FieldName
				IF (@@Fetch_Status = -1 OR  @@Fetch_Status = -2) 
				BEGIN 
					CLOSE update_cursor 
					DEALLOCATE update_cursor 
					GOTO ProcessNext
				END

				SELECT @OrderID = 0

				WHILE(@@FETCH_STATUS  <> -1) 
				BEGIN 
					IF(@@FETCH_STATUS <> -2) 
					BEGIN
						BEGIN TRANSACTION TRANDATA
							INSERT INTO WFSearchVariableTable(ProcessDefID, ActivityID, FieldName, Scope, OrderID) VALUES (@ProcessDefID, @DefaultIntroductionActID, @FieldName, 'C', @OrderID)
							INSERT INTO WFSearchVariableTable(ProcessDefID, ActivityID, FieldName, Scope, OrderID) VALUES (@ProcessDefID, @DefaultIntroductionActID, @FieldName ,'R', @OrderID)
						COMMIT TRANSACTION TRANDATA
						SELECT @OrderID = @OrderID + 1
					END 

					FETCH NEXT FROM update_cursor INTO @FieldName
					IF @@ERROR <> 0 
					BEGIN 
						CLOSE update_cursor 
						DEALLOCATE update_cursor 
						GOTO ProcessNext 
					END
				END 
				CLOSE update_cursor 
				DEALLOCATE update_cursor
				
				DECLARE qws_cursor CURSOR FAST_FORWARD FOR 
					SELECT ActivityID
					FROM ActivityTable
					WHERE ProcessDefId = @ProcessDefID AND ActivityType = 11 

				OPEN qws_cursor 
				FETCH qws_cursor INTO @QueryActivityId

				WHILE(@@FETCH_STATUS = 0) 
				BEGIN 
					INSERT INTO WFSearchVariableTable
					SELECT ProcessdefId, @QueryActivityId , FieldName, Scope, OrderId 
					FROM wfsearchVariableTable
					WHERE ProcessDefId = @ProcessDefID  AND ActivityId = @DefaultIntroductionActID
					
					FETCH NEXT FROM qws_cursor INTO @QueryActivityId

				END
				CLOSE qws_cursor 
				DEALLOCATE qws_cursor 
			END 

			ProcessNext: 
				FETCH NEXT FROM search_cursor INTO @ProcessDefID, @DefaultIntroductionActID
			END 
		CLOSE search_cursor 
		DEALLOCATE search_cursor 
	END
END

~ 

EXEC Upgrade_SearchVariables

~

DROP PROCEDURE Upgrade_SearchVariables

~

CREATE PROCEDURE Upgrade_VariableId AS 
BEGIN
	DECLARE @processDefId				INT 
	DECLARE @UserDefinedName			NVARCHAR(200)
	DECLARE @v_count					INT
	DECLARE @SysString					Varchar(2000)
	DECLARE @delimeter					Char(1)
	DECLARE @v_StartPos					INT
	DECLARE @v_EndPos					INT
	DECLARE @v_length					INT
	DECLARE @v_STR1						NVARCHAR(2000)
	DECLARE @v_STR2						NVARCHAR(2000)
	DECLARE @v_STR3						NVARCHAR(2000)
	DECLARE @v_STR4						NVARCHAR(2000)
	DECLARE @v_STR5						NVARCHAR(2000)
	DECLARE @v_STR6						NVARCHAR(2000)
	DECLARE @v_STR7						NVARCHAR(2000)
	DECLARE @v_STR8						NVARCHAR(2000)
	DECLARE @v_STR9						NVARCHAR(2000)
	DECLARE @v_STR10					NVARCHAR(2000)
	DECLARE @v_STR11					NVARCHAR(2000)
	DECLARE @v_STR12					NVARCHAR(2000)
	DECLARE @v_STR13					NVARCHAR(2000)
	DECLARE @v_STR14					NVARCHAR(2000)
	DECLARE @v_STR15					NVARCHAR(2000)
	DECLARE @v_STR16					NVARCHAR(2000)
	DECLARE @v_STR17					NVARCHAR(2000)
	DECLARE @v_STR18					NVARCHAR(2000)
	DECLARE @v_STR19					NVARCHAR(2000)
	DECLARE @v_STR20					NVARCHAR(2000)
	DECLARE @v_STR21					NVARCHAR(2000)
	DECLARE @v_STR22					NVARCHAR(2000)
	DECLARE @v_STR23					NVARCHAR(2000)
	DECLARE @v_STR24					NVARCHAR(2000)
	DECLARE @v_STR25					NVARCHAR(2000)
	DECLARE @v_STR26					NVARCHAR(2000)
	DECLARE @v_STR27					NVARCHAR(2000)
	DECLARE @v_STR28					NVARCHAR(2000)
	DECLARE @v_STR29					NVARCHAR(2000)
	DECLARE @v_STR30					NVARCHAR(2000)
	DECLARE @v_STR31					NVARCHAR(2000)
	DECLARE @v_STR32					NVARCHAR(2000)
	DECLARE @v_STR33					NVARCHAR(2000)
	DECLARE @v_STR34					NVARCHAR(2000)
	DECLARE @v_STR35					NVARCHAR(2000)
	DECLARE @v_STR36					NVARCHAR(2000)
	DECLARE @v_STR37					NVARCHAR(2000)
	DECLARE @v_STR38					NVARCHAR(2000)
	DECLARE @v_STR39					NVARCHAR(2000)
	DECLARE @v_STR40					NVARCHAR(2000)
	DECLARE @v_STR41					NVARCHAR(2000)
	DECLARE @v_STR42					NVARCHAR(2000)
	DECLARE @v_STR43					NVARCHAR(2000)
	DECLARE @v_STR44					NVARCHAR(2000)
	DECLARE @v_STR45					NVARCHAR(2000)
	DECLARE @v_STR46					NVARCHAR(2000)
	DECLARE @v_STR47					NVARCHAR(2000)
	DECLARE @v_STR48					NVARCHAR(2000)
	DECLARE @v_STR49					NVARCHAR(2000)
	DECLARE @v_STR50					NVARCHAR(2000)
	DECLARE @v_STR51					NVARCHAR(2000)
	DECLARE @v_STR52					NVARCHAR(2000)
	DECLARE @v_STR53					NVARCHAR(2000)
	DECLARE @v_STR54					NVARCHAR(2000)
	DECLARE @v_STR55					NVARCHAR(2000)
	DECLARE @v_STR56					NVARCHAR(2000)
	DECLARE @v_STR57					NVARCHAR(2000)
	DECLARE @v_STR58					NVARCHAR(2000)
	DECLARE @v_STR59					NVARCHAR(2000)
	DECLARE @v_STR60					NVARCHAR(2000)
	DECLARE @v_STR61					NVARCHAR(2000)
	DECLARE @v_STR62					NVARCHAR(2000)
	DECLARE @v_STR63					NVARCHAR(2000)
	DECLARE @v_STR64					NVARCHAR(2000)
	DECLARE @v_STR65					NVARCHAR(2000)
	DECLARE @v_STR66					NVARCHAR(2000)
	DECLARE @v_STR67					NVARCHAR(2000)
	DECLARE @v_STR68					NVARCHAR(2000)
	DECLARE @v_STR69					NVARCHAR(2000)
	DECLARE @v_STR70					NVARCHAR(2000)
	DECLARE @v_STR71					NVARCHAR(2000)
	DECLARE @v_STR72					NVARCHAR(2000)
	DECLARE @v_STR73					NVARCHAR(2000)
	DECLARE @v_STR74					NVARCHAR(2000)
	DECLARE @v_STR75					NVARCHAR(2000)
	DECLARE @v_STR76					NVARCHAR(2000)
	DECLARE @v_STR77					NVARCHAR(2000)
	DECLARE @v_paramDefinition1			NVARCHAR(2000)
	DECLARE @v_paramDefinition2			NVARCHAR(2000)
	DECLARE @v_paramDefinition3			NVARCHAR(2000)
	DECLARE @v_paramDefinition4			NVARCHAR(2000)
	DECLARE	@v_quoteChar 				CHAR(1) 
	SELECT	@v_quoteChar = CHAR(39) 
	SELECT @SysString = 'VAR_INT1,VAR_INT2,VAR_INT3,VAR_INT4,VAR_INT5,VAR_INT6,VAR_INT7,VAR_INT8,VAR_FLOAT1,VAR_FLOAT2,'+
		+ 'VAR_DATE1,VAR_DATE2,VAR_DATE3,VAR_DATE4,VAR_LONG1,VAR_LONG2,VAR_LONG3,VAR_LONG4,VAR_STR1,' +
		+ 'VAR_STR2,VAR_STR3,VAR_STR4,VAR_STR5,VAR_STR6,VAR_STR7,VAR_STR8,getdate(),CreatedDateTime,' +
		+ 'EntryDateTime,ValidTill,ProcessInstanceName,CreatedByName,PreviousStage,SaveStage,IntroductionDateTime,' +
		+ 'IntroducedBy,InstrumentStatus,PriorityLevel,HoldStatus,ProcessInstanceState,WorkItemState,' +
		+ 'Status,ActivityId,QueueType,QueueName,LockedByName,LockedTime,LockStatus,ActivityName,' +
		+ 'CheckListCompleteFlag,AssignmentType,ProcessedBy,VAR_REC_1,VAR_REC_2,VAR_REC_3,VAR_REC_4,VAR_REC_5'
	SELECT @delimeter = ','

	BEGIN
		DECLARE cursor1 CURSOR FAST_FORWARD FOR
		SELECT DISTINCT ProcessDefId FROM VarMappingTable
		OPEN cursor1
		FETCH NEXT FROM cursor1 INTO @ProcessDefId
		WHILE(@@FETCH_STATUS = 0) 
		BEGIN
			PRINT 'processdefid is ---->>>> ' + convert(NVarchar(20), @processdefid)
			SELECT @v_count = 1
			SELECT @v_StartPos = 1
			SELECT @v_EndPos = -1
			WHILE @v_EndPos != 0
			BEGIN
				SELECT @v_EndPos = CHARINDEX(@Delimeter, @SysString, @v_StartPos)
				IF @v_EndPos != 0
				BEGIN
					SELECT @v_length = @v_EndPos - @v_StartPos
				END
				ELSE
				BEGIN
					SELECT @v_length = LEN(@SysString)
				END
				SELECT @v_STR1 = 'SELECT @userDefName = UserDefinedName FROM VarMappingTable where ProcessDefid = ' + convert(NVARCHAR(2000), @processdefid) + 
						' and VariableId = 0 and SystemDefinedName = N' + @v_quoteChar +  SUBSTRING(@SysString, @v_StartPos, @v_length) + @v_quoteChar 
				SELECT @v_paramDefinition1 = '@userDefName NVARCHAR(200) OUTPUT'
				EXEC sp_executesql @v_STR1, @v_paramDefinition1, @userDefName = @UserDefinedName OUTPUT
				IF(@@ROWCOUNT != 0)
				BEGIN
					PRINT 'UserDefinedName is :' + @userdefinedName
					SELECT @v_STR2 = ' UPDATE VarMappingTable SET VariableId = ' + convert(Nvarchar(20), @v_count) +
							         ' where ProcessDefId = ' + convert(NVarchar(20), @ProcessDefId) + 
							         ' and SystemDefinedName = N' + @v_quoteChar +  SUBSTRING(@SysString, @v_StartPos, @v_length) + @v_quoteChar 
					SELECT @v_STR3 = ' UPDATE ActivityAssociationTable SET VariableId = ' + convert(Nvarchar(20), @v_count) +
								     ' where ProcessDefId = ' + convert(NVarchar(20), @ProcessDefId) + 
							         ' and FieldName = N' + @v_quoteChar + @UserDefinedName + @v_quoteChar
					SELECT @v_STR4 = ' UPDATE RuleOperationTable SET VariableId_1 = ' + convert(Nvarchar(20), @v_count) + 
									 ' where ProcessDefId = ' + convert(NVarchar(20), @ProcessDefId) + 
									 ' and OperationType in (1, 18, 19, 23, 24) and Type1 != N''C'' and Param1 = N' + @v_quoteChar + @UserDefinedName + @v_quoteChar
					SELECT @v_STR5 = ' UPDATE RuleOperationTable SET VariableId_2 = ' + convert(Nvarchar(20), @v_count) + 
									 ' where ProcessDefId = ' + convert(NVarchar(20), @ProcessDefId) + 
									 ' and OperationType in (1, 18, 19, 23, 24) and Type2 != N''C'' and Param2 = N' + @v_quoteChar + @UserDefinedName + @v_quoteChar
					SELECT @v_STR6 = ' UPDATE RuleOperationTable SET VariableId_3 = ' + convert(Nvarchar(20), @v_count) + 
									 ' where ProcessDefId = ' + convert(NVarchar(20), @ProcessDefId) + 
									 ' and OperationType in (1, 18, 19, 23, 24) and Type3 != N''C'' and Param3 = N' + @v_quoteChar + @UserDefinedName + @v_quoteChar
					SELECT @v_STR7 = ' UPDATE RuleConditionTable SET VariableId_1 = ' + convert(Nvarchar(20), @v_count) + 
									 ' where ProcessDefId = ' + convert(NVarchar(20), @ProcessDefId) + 
									 ' and Type1 != N''C'' and Type1 != N''S'' and Param1 = N' + @v_quoteChar + @UserDefinedName + @v_quoteChar
					SELECT @v_STR8 = ' UPDATE RuleConditionTable SET VariableId_2 = ' + convert(Nvarchar(20), @v_count) + 
									 ' where ProcessDefId = ' + convert(NVarchar(20), @ProcessDefId) + 
									 ' and Type2 != N''C'' and Type2 != N''S'' and Param2 = N' + @v_quoteChar + @UserDefinedName + @v_quoteChar
					SELECT @v_STR9 = ' UPDATE ExtMethodParamMappingTable SET VariableId = ' + convert(Nvarchar(20), @v_count) + 
									 ' where ProcessDefId = ' + convert(NVarchar(20), @ProcessDefId) + 
									 ' and MappedFieldType in (''S'', ''Q'', ''M'', ''I'', ''U'')' +
									 ' and MappedField = N' + + @v_quoteChar + @UserDefinedName + @v_quoteChar
					SELECT @v_STR10 = ' UPDATE ActionOperationTable SET VariableId_1 = ' + convert(Nvarchar(20), @v_count) + 
									  ' where ProcessDefId = ' + convert(NVarchar(20), @ProcessDefId) + 
									  ' and OperationType in (1, 18, 19, 23, 24) and Type1 != N''C'' and Param1 = N' + @v_quoteChar + @UserDefinedName + @v_quoteChar
					SELECT @v_STR11 = ' UPDATE ActionOperationTable SET VariableId_2 = ' + convert(Nvarchar(20), @v_count) + 
									  ' where ProcessDefId = ' + convert(NVarchar(20), @ProcessDefId) + 
									  ' and OperationType in (1, 18, 19, 23, 24) and Type2 != N''C'' and Param2 = N' + @v_quoteChar + @UserDefinedName + @v_quoteChar
					SELECT @v_STR12 = ' UPDATE ActionOperationTable SET VariableId_3 = ' + convert(Nvarchar(20), @v_count) + 
									  ' where ProcessDefId = ' + convert(NVarchar(20), @ProcessDefId) + 
									  ' and OperationType in (1, 18, 19, 23, 24) and Type3 != N''C'' and Param3 = N' + @v_quoteChar + @UserDefinedName + @v_quoteChar
					SELECT @v_STR13 = ' UPDATE ActionConditionTable SET VariableId_1 = ' + convert(Nvarchar(20), @v_count) + 
									  ' where ProcessDefId = ' + convert(NVarchar(20), @ProcessDefId) + 
									  ' and Type1 != N''C'' and Type1 != N''S'' and Param1 = N' + @v_quoteChar + @UserDefinedName + @v_quoteChar
					SELECT @v_STR14 = ' UPDATE ActionConditionTable SET VariableId_2 = ' + convert(Nvarchar(20), @v_count) + 
									  ' where ProcessDefId = ' + convert(NVarchar(20), @ProcessDefId) + 
									  ' and Type2 != N''C'' and Type2 != N''S'' and Param2 = N' + @v_quoteChar + @UserDefinedName + @v_quoteChar
					SELECT @v_STR15 = ' UPDATE DataSetTriggerTable SET VariableId_1 = ' + convert(Nvarchar(20), @v_count) + 
									  ' where ProcessDefId = ' + convert(NVarchar(20), @ProcessDefId) + 
									  ' and Param1 = N' + @v_quoteChar + @UserDefinedName + @v_quoteChar
					SELECT @v_STR16 = ' UPDATE DataSetTriggerTable SET VariableId_2 = ' + convert(Nvarchar(20), @v_count) + 
									  ' where ProcessDefId = ' + convert(NVarchar(20), @ProcessDefId) + 
									  ' and Type2 != N''C'' and Param2 = N' + @v_quoteChar + @UserDefinedName + @v_quoteChar
					SELECT @v_STR17 = ' UPDATE ScanActionsTable SET VariableId_1 = ' + convert(Nvarchar(20), @v_count) + 
									  ' where ProcessDefId = ' + convert(NVarchar(20), @ProcessDefId) + 
									  ' and Param1 = N' + @v_quoteChar + @UserDefinedName + @v_quoteChar
					SELECT @v_STR18 = ' UPDATE ScanActionsTable SET VariableId_2 = ' + convert(Nvarchar(20), @v_count) + 
									  ' where ProcessDefId = ' + convert(NVarchar(20), @ProcessDefId) + 
									  ' and Type2 != N''C'' and Param2 = N' + @v_quoteChar + @UserDefinedName + @v_quoteChar
					SELECT @v_STR19 = ' UPDATE WFDataMapTable SET VariableId = ' + convert(Nvarchar(20), @v_count) + 
									  ' where ProcessDefId = ' + convert(NVarchar(20), @ProcessDefId) + 
									  ' and DocTypeDefId = 0 and MappedFieldName = N' + @v_quoteChar + @UserDefinedName + @v_quoteChar
					SELECT @v_STR20 = ' UPDATE DataEntryTriggerTable SET VariableId = ' + convert(Nvarchar(20), @v_count) + 
									  ' where ProcessDefId = ' + convert(NVarchar(20), @ProcessDefId) + 
									  ' and VariableName = N' + @v_quoteChar + @UserDefinedName + @v_quoteChar
					SELECT @v_STR21 = ' UPDATE ArchiveDataMapTable SET VariableId = ' + convert(Nvarchar(20), @v_count) + 
									  ' where ProcessDefId = ' + convert(NVarchar(20), @ProcessDefId) + 
									  ' and AssocVar = N' + @v_quoteChar + @UserDefinedName + @v_quoteChar
					SELECT @v_STR22 = ' UPDATE WFJMSSubscribeTable SET VariableId = ' + convert(Nvarchar(20), @v_count) + 
									  ' where ProcessDefId = ' + convert(NVarchar(20), @ProcessDefId) + 
									  ' and processVariableName = N' + @v_quoteChar + @UserDefinedName + @v_quoteChar
					SELECT @v_STR23 = ' UPDATE ToDoListDefTable SET VariableId = ' + convert(Nvarchar(20), @v_count) + 
									  ' where ProcessDefId = ' + convert(NVarchar(20), @ProcessDefId) + 
									  ' and AssociatedField = N' + @v_quoteChar + @UserDefinedName + @v_quoteChar
					SELECT @v_STR24 = ' UPDATE MailTriggerTable SET VariableIdTo = ' + convert(Nvarchar(20), @v_count) + 
									  ' where ProcessDefId = ' + convert(NVarchar(20), @ProcessDefId) + 
									  ' and ToType != N''C'' and ToUser = N' + @v_quoteChar + @UserDefinedName + @v_quoteChar
					SELECT @v_STR25 = ' UPDATE MailTriggerTable SET VariableIdFrom = ' + convert(Nvarchar(20), @v_count) + 
									  ' where ProcessDefId = ' + convert(NVarchar(20), @ProcessDefId) + 
									  ' and FromUserType != N''C'' and FromUser = N' + @v_quoteChar + @UserDefinedName + @v_quoteChar
					SELECT @v_STR26 = ' UPDATE MailTriggerTable SET VariableIdCC = ' + convert(Nvarchar(20), @v_count) + 
									  ' where ProcessDefId = ' + convert(NVarchar(20), @ProcessDefId) + 
									  ' and CCType != N''C'' and CCUser = N' + @v_quoteChar + @UserDefinedName + @v_quoteChar
					SELECT @v_STR27 = ' UPDATE PrintFaxEmailTable SET VariableIdTo = ' + convert(Nvarchar(20), @v_count) + 
									  ' where ProcessDefId = ' + convert(NVarchar(20), @ProcessDefId) + 
									  ' and ToMailIdType != N''C'' and ToMailId = N' + @v_quoteChar + @UserDefinedName + @v_quoteChar
					SELECT @v_STR28 = ' UPDATE PrintFaxEmailTable SET VariableIdFrom = ' + convert(Nvarchar(20), @v_count) + 
									  ' where ProcessDefId = ' + convert(NVarchar(20), @ProcessDefId) + 
									  ' and SenderMailIdType != N''C'' and SenderMailId = N' + @v_quoteChar + @UserDefinedName + @v_quoteChar
					SELECT @v_STR29 = ' UPDATE PrintFaxEmailTable SET VariableIdCC = ' + convert(Nvarchar(20), @v_count) + 
									  ' where ProcessDefId = ' + convert(NVarchar(20), @ProcessDefId) + 
									  ' and CCMailIdType != N''C'' and CCMailId = N' + @v_quoteChar + @UserDefinedName + @v_quoteChar
					SELECT @v_STR30 = ' UPDATE PrintFaxEmailTable SET VariableIdFax = ' + convert(Nvarchar(20), @v_count) + 
									  ' where ProcessDefId = ' + convert(NVarchar(20), @ProcessDefId) + 
									  ' and FaxNoType != N''C'' and FaxNo = N' + @v_quoteChar + @UserDefinedName + @v_quoteChar
					SELECT @v_STR31 = ' UPDATE ImportedProcessDefTable SET VariableId = ' + convert(Nvarchar(20), @v_count) + 
									  ' where ProcessDefId = ' + convert(NVarchar(20), @ProcessDefId) + 
									  ' and FieldType != N''D'' and ImportedFieldName = N' + @v_quoteChar + @UserDefinedName + @v_quoteChar
					SELECT @v_STR32 = ' UPDATE InitiateWorkItemDefTable SET ImportedVariableId = ' + convert(Nvarchar(20), @v_count) + 
									  ' where ProcessDefId = ' + convert(NVarchar(20), @ProcessDefId) + 
									  ' and FieldType != N''D'' and ImportedFieldName = N' + @v_quoteChar + @UserDefinedName + @v_quoteChar
					SELECT @v_STR33 = ' UPDATE InitiateWorkItemDefTable SET MappedVariableId = ' + convert(Nvarchar(20), @v_count) + 
									  ' where ProcessDefId = ' + convert(NVarchar(20), @ProcessDefId) + 
									  ' and FieldType != N''D'' and MappedFieldName = N' + @v_quoteChar + @UserDefinedName + @v_quoteChar
					SELECT @v_STR34 = 'UPDATE WFDurationTable SET VariableId_Years = ' + convert(Nvarchar(20), @v_count) +
									  ' where ProcessDefId = ' + convert(NVarchar(20), @ProcessDefId) + 
									  ' and WFYears = N' + @v_quoteChar + @UserDefinedName + @v_quoteChar
					SELECT @v_STR35 = 'UPDATE WFDurationTable SET VariableId_Months = ' + convert(Nvarchar(20), @v_count) +
									  ' where ProcessDefId = ' + convert(NVarchar(20), @ProcessDefId) + 
									  ' and WFMonths = N' + @v_quoteChar + @UserDefinedName + @v_quoteChar				
					SELECT @v_STR36 = 'UPDATE WFDurationTable SET VariableId_Days = ' + convert(Nvarchar(20), @v_count) +
									  ' where ProcessDefId = ' + convert(NVarchar(20), @ProcessDefId) + 
									  ' and WFDays = N' + @v_quoteChar + @UserDefinedName + @v_quoteChar
					SELECT @v_STR37 = 'UPDATE WFDurationTable SET VariableId_Hours = ' + convert(Nvarchar(20), @v_count) +
									  ' where ProcessDefId = ' + convert(NVarchar(20), @ProcessDefId) + 
									  ' and WFHours = N' + @v_quoteChar + @UserDefinedName + @v_quoteChar
					SELECT @v_STR38 = 'UPDATE WFDurationTable SET VariableId_Minutes = ' + convert(Nvarchar(20), @v_count) +
									  ' where ProcessDefId = ' + convert(NVarchar(20), @ProcessDefId) + 
									  ' and WFMinutes = N' + @v_quoteChar + @UserDefinedName + @v_quoteChar
					SELECT @v_STR39 = 'UPDATE WFDurationTable SET VariableId_Seconds = ' + convert(Nvarchar(20), @v_count) +
									  ' where ProcessDefId = ' + convert(NVarchar(20), @ProcessDefId) + 
									  ' and WFSeconds = N' + @v_quoteChar + @UserDefinedName + @v_quoteChar
					BEGIN TRANSACTION trans
					EXECUTE(@v_STR2)
					IF(@UserDefinedName != ' ')
					BEGIN
						EXECUTE(@v_STR3)
						EXECUTE(@v_STR4)
						EXECUTE(@v_STR5)
						EXECUTE(@v_STR6)
						EXECUTE(@v_STR7)
						EXECUTE(@v_STR8)
						EXECUTE(@v_STR9)
						EXECUTE(@v_STR10)
						EXECUTE(@v_STR11)
						EXECUTE(@v_STR12)
						EXECUTE(@v_STR13)
						EXECUTE(@v_STR14)
						EXECUTE(@v_STR15)
						EXECUTE(@v_STR16)
						EXECUTE(@v_STR17)
						EXECUTE(@v_STR18)
						EXECUTE(@v_STR19)
						EXECUTE(@v_STR20)
						EXECUTE(@v_STR21)
						EXECUTE(@v_STR22)
						EXECUTE(@v_STR23)
						EXECUTE(@v_STR24)
						EXECUTE(@v_STR25)
						EXECUTE(@v_STR26)
						EXECUTE(@v_STR27)
						EXECUTE(@v_STR28)
						EXECUTE(@v_STR29)
						EXECUTE(@v_STR30)
						EXECUTE(@v_STR31)
						EXECUTE(@v_STR32)
						EXECUTE(@v_STR33)
						EXECUTE(@v_STR34)
						EXECUTE(@v_STR35)
						EXECUTE(@v_STR36)
						EXECUTE(@v_STR37)
						EXECUTE(@v_STR38)
						EXECUTE(@v_STR39)
					END
					IF(@@error <> 0)
					BEGIN
						PRINT 'Error while inserting values in VariableId....'
						ROLLBACK TRANSACTION trans
						RETURN
					END
					COMMIT TRANSACTION trans
				END
				ELSE
				BEGIN
					PRINT 'userdefinedName is null:'
				END
				SELECT @v_StartPos = @v_EndPos + 1 
				SELECT @v_count = @v_count + 1
			END
			DECLARE cursor2 CURSOR FAST_FORWARD FOR
			SELECT userdefinedname FROM VarmappingTable WHERE processdefid = @processdefid and ExtObjId = 1
			OPEN cursor2
			FETCH NEXT FROM cursor2 INTO  @UserDefinedName
			WHILE(@@FETCH_STATUS = 0) 
			BEGIN
				SELECT @v_STR40 = 'UPDATE VarmappingTable SET VariableId = ' + convert(Nvarchar(20), @v_count)+ 
								  ' where ProcessDefId =' + convert(NVarchar(20), @ProcessDefId) + 
								  ' and ExtObjId = 1 and UserDefinedName = N' + @v_quotechar + @UserDefinedName + @v_quotechar +
								  ' and VariableId = 0'
				SELECT @v_STR41 = 'UPDATE ActivityAssociationTable SET VariableId = ' + convert(Nvarchar(20), @v_count) +
								  ' where ProcessDefid= ' + convert(NVARCHAR(2000), @processdefid) + 
								  ' and ExtObjId = 1 and FieldName = N' + @v_quoteChar + @UserDefinedName + @v_quoteChar +
								  ' and VariableId = 0'
				SELECT @v_STR42 = ' UPDATE RuleOperationTable SET VariableId_1 = ' + convert(Nvarchar(20), @v_count) + 
								  ' where ProcessDefId = ' + convert(NVarchar(20), @ProcessDefId) + 
								  ' and OperationType in (1, 18, 19, 23, 24) ' +
								  ' and Type1 != N''C'' and Param1 = N' + @v_quoteChar + @UserDefinedName + @v_quoteChar
				SELECT @v_STR43 = ' UPDATE RuleOperationTable SET VariableId_2 = ' + convert(Nvarchar(20), @v_count) + 
								  ' where ProcessDefId = ' + convert(NVarchar(20), @ProcessDefId) + 
								  ' and OperationType in (1, 18, 19, 23, 24) ' +
								  ' and Type2 != N''C'' and Param2 = N' + @v_quoteChar + @UserDefinedName + @v_quoteChar
				SELECT @v_STR44 = ' UPDATE RuleOperationTable SET VariableId_3 = ' + convert(Nvarchar(20), @v_count) + 
								  ' where ProcessDefId = ' + convert(NVarchar(20), @ProcessDefId) + 
								  ' and OperationType in (1, 18, 19, 23, 24) ' +
								  ' and Type3 != N''C'' and Param3 = N' + @v_quoteChar + @UserDefinedName + @v_quoteChar
				SELECT @v_STR45 = ' UPDATE RuleConditionTable SET VariableId_1 = ' + convert(Nvarchar(20), @v_count) + 
								  ' where ProcessDefId = ' + convert(NVarchar(20), @ProcessDefId) + 
								  ' and Type1 != N''C'' and Type1 != N''S''' +
								  ' and Param1 = N' + @v_quoteChar + @UserDefinedName + @v_quoteChar
				SELECT @v_STR46 = ' UPDATE RuleConditionTable SET VariableId_2 = ' + convert(Nvarchar(20), @v_count) + 
								  ' where ProcessDefId = ' + convert(NVarchar(20), @ProcessDefId) + 
								  ' and Type2 != N''C'' and Type2 != N''S''' +
								  ' and Param2 = N' + @v_quoteChar + @UserDefinedName + @v_quoteChar
				SELECT @v_STR47 = ' UPDATE ExtMethodParamMappingTable SET VariableId = ' + convert(Nvarchar(20), @v_count) + 
								  ' where ProcessDefId = ' + convert(NVarchar(20), @ProcessDefId) + 
								  ' and MappedFieldType in (''S'', ''Q'', ''M'', ''I'', ''U'')' +
								  ' and MappedField = N' + + @v_quoteChar + @UserDefinedName + @v_quoteChar
				SELECT @v_STR48 = ' UPDATE ActionOperationTable SET VariableId_1 = ' + convert(Nvarchar(20), @v_count) + 
								  ' where ProcessDefId = ' + convert(NVarchar(20), @ProcessDefId) + 
								  ' and OperationType in (1, 18, 19, 23, 24) and Type1 != N''C'' and Param1 = N' + @v_quoteChar + @UserDefinedName + @v_quoteChar
				SELECT @v_STR49 = ' UPDATE ActionOperationTable SET VariableId_2 = ' + convert(Nvarchar(20), @v_count) + 
								  ' where ProcessDefId = ' + convert(NVarchar(20), @ProcessDefId) + 
								  ' and OperationType in (1, 18, 19, 23, 24) and Type2 != N''C'' and Param2 = N' + @v_quoteChar + @UserDefinedName + @v_quoteChar
				SELECT @v_STR50 = ' UPDATE ActionOperationTable SET VariableId_3 = ' + convert(Nvarchar(20), @v_count) + 
								  ' where ProcessDefId = ' + convert(NVarchar(20), @ProcessDefId) + 
								  ' and OperationType in (1, 18, 19, 23, 24) and Type3 != N''C'' and Param3 = N' + @v_quoteChar + @UserDefinedName + @v_quoteChar
				SELECT @v_STR51 = ' UPDATE ActionConditionTable SET VariableId_1 = ' + convert(Nvarchar(20), @v_count) + 
								  ' where ProcessDefId = ' + convert(NVarchar(20), @ProcessDefId) + 
								  ' and Type1 != N''C'' and Type1 != N''S'' and Param1 = N' + @v_quoteChar + @UserDefinedName + @v_quoteChar
				SELECT @v_STR52 = ' UPDATE ActionConditionTable SET VariableId_2 = ' + convert(Nvarchar(20), @v_count) + 
								  ' where ProcessDefId = ' + convert(NVarchar(20), @ProcessDefId) + 
								  ' and Type2 != N''C'' and Type2 != N''S'' and Param2 = N' + @v_quoteChar + @UserDefinedName + @v_quoteChar
				SELECT @v_STR53 = ' UPDATE DataSetTriggerTable SET VariableId_1 = ' + convert(Nvarchar(20), @v_count) + 
								  ' where ProcessDefId = ' + convert(NVarchar(20), @ProcessDefId) + 
								  ' and Param1 = N' + @v_quoteChar + @UserDefinedName + @v_quoteChar
				SELECT @v_STR54 = ' UPDATE DataSetTriggerTable SET VariableId_2 = ' + convert(Nvarchar(20), @v_count) + 
								  ' where ProcessDefId = ' + convert(NVarchar(20), @ProcessDefId) + 
								  ' and Type2 != N''C'' and Param2 = N' + @v_quoteChar + @UserDefinedName + @v_quoteChar
				SELECT @v_STR55 = ' UPDATE ScanActionsTable SET VariableId_1 = ' + convert(Nvarchar(20), @v_count) + 
								  ' where ProcessDefId = ' + convert(NVarchar(20), @ProcessDefId) + 
								  ' and Param1 = N' + @v_quoteChar + @UserDefinedName + @v_quoteChar
				SELECT @v_STR56 = ' UPDATE ScanActionsTable SET VariableId_2 = ' + convert(Nvarchar(20), @v_count) + 
								  ' where ProcessDefId = ' + convert(NVarchar(20), @ProcessDefId) + 
								  ' and Type2 != N''C'' and Param2 = N' + @v_quoteChar + @UserDefinedName + @v_quoteChar
				SELECT @v_STR57 = ' UPDATE WFDataMapTable SET VariableId = ' + convert(Nvarchar(20), @v_count) + 
								  ' where ProcessDefId = ' + convert(NVarchar(20), @ProcessDefId) + 
								  ' and DocTypeDefId = 0 and MappedFieldName = N' + @v_quoteChar + @UserDefinedName + @v_quoteChar
				SELECT @v_STR58 = ' UPDATE DataEntryTriggerTable SET VariableId = ' + convert(Nvarchar(20), @v_count) + 
								  ' where ProcessDefId = ' + convert(NVarchar(20), @ProcessDefId) + 
								  ' and VariableName = N' + @v_quoteChar + @UserDefinedName + @v_quoteChar
				SELECT @v_STR59 = ' UPDATE ArchiveDataMapTable SET VariableId = ' + convert(Nvarchar(20), @v_count) + 
								  ' where ProcessDefId = ' + convert(NVarchar(20), @ProcessDefId) + 
								  ' and AssocVar = N' + @v_quoteChar + @UserDefinedName + @v_quoteChar
				SELECT @v_STR60 = ' UPDATE WFJMSSubscribeTable SET VariableId = ' + convert(Nvarchar(20), @v_count) + 
								  ' where ProcessDefId = ' + convert(NVarchar(20), @ProcessDefId) + 
								  ' and processVariableName = N' + @v_quoteChar + @UserDefinedName + @v_quoteChar
				SELECT @v_STR61 = ' UPDATE ToDoListDefTable SET VariableId = ' + convert(Nvarchar(20), @v_count) + 
								  ' where ProcessDefId = ' + convert(NVarchar(20), @ProcessDefId) + 
								  ' and AssociatedField = N' + @v_quoteChar + @UserDefinedName + @v_quoteChar
				SELECT @v_STR62 = ' UPDATE MailTriggerTable SET VariableIdTo = ' + convert(Nvarchar(20), @v_count) + 
								  ' where ProcessDefId = ' + convert(NVarchar(20), @ProcessDefId) + 
								  ' and ToType != N''C'' and ToUser = N' + @v_quoteChar + @UserDefinedName + @v_quoteChar
				SELECT @v_STR63 = ' UPDATE MailTriggerTable SET VariableIdFrom = ' + convert(Nvarchar(20), @v_count) + 
								  ' where ProcessDefId = ' + convert(NVarchar(20), @ProcessDefId) + 
								  ' and FromUserType != N''C'' and FromUser = N' + @v_quoteChar + @UserDefinedName + @v_quoteChar
				SELECT @v_STR64 = ' UPDATE MailTriggerTable SET VariableIdCC = ' + convert(Nvarchar(20), @v_count) + 
								  ' where ProcessDefId = ' + convert(NVarchar(20), @ProcessDefId) + 
								  ' and CCType != N''C'' and CCUser = N' + @v_quoteChar + @UserDefinedName + @v_quoteChar
				SELECT @v_STR65 = ' UPDATE PrintFaxEmailTable SET VariableIdTo = ' + convert(Nvarchar(20), @v_count) + 
								  ' where ProcessDefId = ' + convert(NVarchar(20), @ProcessDefId) + 
								  ' and ToMailIdType != N''C'' and ToMailId = N' + @v_quoteChar + @UserDefinedName + @v_quoteChar
				SELECT @v_STR66 = ' UPDATE PrintFaxEmailTable SET VariableIdFrom = ' + convert(Nvarchar(20), @v_count) + 
								  ' where ProcessDefId = ' + convert(NVarchar(20), @ProcessDefId) + 
								  ' and SenderMailIdType != N''C'' and SenderMailId = N' + @v_quoteChar + @UserDefinedName + @v_quoteChar
				SELECT @v_STR67 = ' UPDATE PrintFaxEmailTable SET VariableIdCC = ' + convert(Nvarchar(20), @v_count) + 
								  ' where ProcessDefId = ' + convert(NVarchar(20), @ProcessDefId) + 
								  ' and CCMailIdType != N''C'' and CCMailId = N' + @v_quoteChar + @UserDefinedName + @v_quoteChar
				SELECT @v_STR68 = ' UPDATE PrintFaxEmailTable SET VariableIdFax = ' + convert(Nvarchar(20), @v_count) + 
								  ' where ProcessDefId = ' + convert(NVarchar(20), @ProcessDefId) + 
								  ' and FaxNoType != N''C'' and FaxNo = N' + @v_quoteChar + @UserDefinedName + @v_quoteChar
				SELECT @v_STR69 = ' UPDATE ImportedProcessDefTable SET VariableId = ' + convert(Nvarchar(20), @v_count) + 
								  ' where ProcessDefId = ' + convert(NVarchar(20), @ProcessDefId) + 
								  ' and FieldType != N''D'' and ImportedFieldName = N' + @v_quoteChar + @UserDefinedName + @v_quoteChar
				SELECT @v_STR70 = ' UPDATE InitiateWorkItemDefTable SET ImportedVariableId = ' + convert(Nvarchar(20), @v_count) + 
								  ' where ProcessDefId = ' + convert(NVarchar(20), @ProcessDefId) + 
								  ' and FieldType != N''D'' and ImportedFieldName = N' + @v_quoteChar + @UserDefinedName + @v_quoteChar
				SELECT @v_STR71 = ' UPDATE InitiateWorkItemDefTable SET MappedVariableId = ' + convert(Nvarchar(20), @v_count) + 
								  ' where ProcessDefId = ' + convert(NVarchar(20), @ProcessDefId) + 
								  ' and FieldType != N''D'' and MappedFieldName = N' + @v_quoteChar + @UserDefinedName + @v_quoteChar
				SELECT @v_STR72 = 'UPDATE WFDurationTable SET VariableId_Years = ' + convert(Nvarchar(20), @v_count) +
								  ' where ProcessDefId = ' + convert(NVarchar(20), @ProcessDefId) + 
								  ' and WFYears = N' + @v_quoteChar + @UserDefinedName + @v_quoteChar
				SELECT @v_STR73 = 'UPDATE WFDurationTable SET VariableId_Months = ' + convert(Nvarchar(20), @v_count) +
								  ' where ProcessDefId = ' + convert(NVarchar(20), @ProcessDefId) + 
								  ' and WFMonths = N' + @v_quoteChar + @UserDefinedName + @v_quoteChar				
				SELECT @v_STR74 = 'UPDATE WFDurationTable SET VariableId_Days = ' + convert(Nvarchar(20), @v_count) +
								  ' where ProcessDefId = ' + convert(NVarchar(20), @ProcessDefId) + 
								  ' and WFDays = N' + @v_quoteChar + @UserDefinedName + @v_quoteChar
				SELECT @v_STR75 = 'UPDATE WFDurationTable SET VariableId_Hours = ' + convert(Nvarchar(20), @v_count) +
								  ' where ProcessDefId = ' + convert(NVarchar(20), @ProcessDefId) + 
								  ' and WFHours = N' + @v_quoteChar + @UserDefinedName + @v_quoteChar
				SELECT @v_STR76 = 'UPDATE WFDurationTable SET VariableId_Minutes = ' + convert(Nvarchar(20), @v_count) +
								  ' where ProcessDefId = ' + convert(NVarchar(20), @ProcessDefId) + 
								  ' and WFMinutes = N' + @v_quoteChar + @UserDefinedName + @v_quoteChar
				SELECT @v_STR77 = 'UPDATE WFDurationTable SET VariableId_Seconds = ' + convert(Nvarchar(20), @v_count) +
								  ' where ProcessDefId = ' + convert(NVarchar(20), @ProcessDefId) + 
								  ' and WFSeconds = N' + @v_quoteChar + @UserDefinedName + @v_quoteChar
				BEGIN TRANSACTION trans1
					EXECUTE(@v_STR40)
					EXECUTE(@v_STR41)
					EXECUTE(@v_STR42)
					EXECUTE(@v_STR43)
					EXECUTE(@v_STR44)
					EXECUTE(@v_STR45)
					EXECUTE(@v_STR46)
					EXECUTE(@v_STR47)
					EXECUTE(@v_STR48)
					EXECUTE(@v_STR49)
					EXECUTE(@v_STR50)
					EXECUTE(@v_STR51)
					EXECUTE(@v_STR52)
					EXECUTE(@v_STR53)
					EXECUTE(@v_STR54)
					EXECUTE(@v_STR55)
					EXECUTE(@v_STR56)
					EXECUTE(@v_STR57)
					EXECUTE(@v_STR58)
					EXECUTE(@v_STR59)
					EXECUTE(@v_STR60)
					EXECUTE(@v_STR61)
					EXECUTE(@v_STR62)
					EXECUTE(@v_STR63)
					EXECUTE(@v_STR64)
					EXECUTE(@v_STR65)
					EXECUTE(@v_STR66)
					EXECUTE(@v_STR67)
					EXECUTE(@v_STR68)
					EXECUTE(@v_STR69)
					EXECUTE(@v_STR70)
					EXECUTE(@v_STR71)
					EXECUTE(@v_STR72)
					EXECUTE(@v_STR73)
					EXECUTE(@v_STR74)
					EXECUTE(@v_STR75)
					EXECUTE(@v_STR76)
					EXECUTE(@v_STR77)
					IF(@@error <> 0)
					BEGIN
						PRINT 'Error while Updating VarMappingTable....'
						ROLLBACK TRANSACTION trans1
						RETURN
				END
				SELECT @v_count = @v_count + 1
				COMMIT TRANSACTION trans1
				FETCH NEXT FROM cursor2 INTO @UserDefinedName
			END
			CLOSE cursor2
			DEALLOCATE cursor2
			FETCH NEXT FROM cursor1 INTO @ProcessDefId
		END
		CLOSE cursor1
		DEALLOCATE cursor1

		IF NOT EXISTS(SELECT * FROM WFCabVersionTable WHERE CabVersion = '7.2_VarMappingTable') /* Check entry in WFCabVersionTable */
		BEGIN
			IF NOT EXISTS( SELECT 1 FROM  VarMappingTable GROUP BY ProcessDefID, SystemDefinedName HAVING count(*) > 1 )
			BEGIN
				EXECUTE('Alter Table VarMappingTable DROP CONSTRAINT PK_VarMappingTable')
				EXECUTE('Alter Table VarMappingTable DROP CONSTRAINT CK_VarMappin_VarScope')
			End
			ELSE
			BEGIN
				PRINT 'Invalid Data in VarMappingTable'
			End

			
			EXECUTE SP_RENAME 'VarMappingTable', 'TempVarMappingTable'
			EXECUTE(
				'CREATE TABLE VARMAPPINGTABLE (
					ProcessDefId 		INT 				NOT NULL ,
					VariableId			INT 				NOT NULL DEFAULT 0,
					SystemDefinedName	NVARCHAR(50) 		NOT NULL ,
					UserDefinedName		NVARCHAR(50)		    NULL ,
					VariableType 		SMALLINT 			NOT NULL ,
					VariableScope 		NVARCHAR(1) 		NOT NULL ,
					ExtObjId 			INT						NULL ,
					DefaultValue		NVARCHAR(255)		    NULL ,
					VariableLength  	INT						NULL,
					VarPrecision			INT					NULL,
					Unbounded			NVARCHAR(1) 		NOT NULL DEFAULT N''N'' CHECK (Unbounded IN (N''Y'' , N''N'')),
					CONSTRAINT CK_VarMappin_VarScope 
						CHECK (VariableScope = N''M'' or (VariableScope = N''I'' or (VariableScope = N''U'' or (VariableScope = N''S'')))),
					CONSTRAINT PK_VarMappingTable	PRIMARY KEY CLUSTERED
					(
						ProcessDefID,
						VariableId
					)
				)'
			)
				PRINT 'Table VarMappingTable Created successfully.....'	 

			/***********INDEX FOR VarMappingTable****************/
		   
			BEGIN TRANSACTION trans
				EXECUTE('CREATE INDEX IDX2_VarMappingTable ON VarMappingTable (UserDefinedName)')
				PRINT 'INDEX IDX2_VarMappingTable ON VarMappingTable created successfully......'
				EXECUTE('INSERT INTO VarMappingTable SELECT ProcessDefId, VariableId, SystemDefinedName, UserDefinedName, VariableType, VariableScope, ExtObjId, DefaultValue, VariableLength, VarPrecision, Unbounded FROM TempVarMappingTable')
				EXECUTE('DROP TABLE TempVarMappingTable')
				PRINT 'Table TempVarMappingTable dropped successfully...........'
				PRINT 'Table VarMappingTable altered with new Column VariableId' 
				EXECUTE('INSERT INTO WFCabVersionTable(cabVersion, creationDate, lastModified, Remarks, Status) VALUES (N''7.2_VarMappingTable'', GETDATE(), GETDATE(), N''BPEL Compliant OmniFlow'', N''Y'')')
			COMMIT TRANSACTION trans
		END
		
		
		IF NOT EXISTS(SELECT * FROM WFCabVersionTable WHERE CabVersion = '7.2_RuleOperationTable') /* Check entry in WFCabVersionTable */
		BEGIN
			EXECUTE SP_RENAME 'RuleOperationTable', 'TempRuleOperationTable'
			EXECUTE(
				'CREATE TABLE RuleOperationTable (
					ProcessDefId 	 		INT				NOT NULL, 
					ActivityId       		INT       		NOT NULL, 
					RuleType               	NVARCHAR(1)    	NOT NULL, 
					RuleId                  SMALLINT       	NOT NULL, 
					OperationType       	SMALLINT       	NOT NULL, 
					Param1					NVARCHAR(50)   	NOT NULL, 
					Type1                   NVARCHAR(1)    	NOT NULL, 
					ExtObjID1	 			INT					NULL,
					VariableId_1			INT					NULL ,
					VarFieldId_1			INT                 NULL ,
					Param2					NVARCHAR(255)  	NOT NULL, 
					Type2                   NVARCHAR(1)    	NOT NULL, 
					ExtObjID2	  			INT					NULL, 
					VariableId_2			INT					NULL ,
					VarFieldId_2			INT                 NULL ,
					Param3                  NVARCHAR(255)		NULL, 
					Type3                   NVARCHAR(1)			NULL, 
					ExtObjID3	   			INT	   				NULL,
					VariableId_3			INT					NULL ,
					VarFieldId_3			INT                 NULL ,
					Operator                SMALLINT 		NOT NULL, 
					OperationOrderId     	SMALLINT       	NOT NULL, 
					CommentFlag          	NVARCHAR(1)    		NULL, 
					RuleCalFlag				NVARCHAR(1)			NULL,
					FunctionType			NVARCHAR(1)	NOT NULL DEFAULT ''L'' CHECK (FunctionType IN (N''G'' , N''L'')),
					PRIMARY KEY (ProcessDefId, ActivityId, RuleType, RuleId, OperationOrderId)

				)'
			)
				PRINT 'Table RuleOperationTable Created successfully.....'
				BEGIN TRANSACTION trans
					EXECUTE('INSERT INTO RuleOperationTable SELECT ProcessDefId, ActivityId, RuleType, RuleId, OperationType, Param1, Type1, ExtObjID1, VariableId_1, VarFieldId_1, Param2, Type2, ExtObjID2, VariableId_2, VarFieldId_2, Param3, Type3, ExtObjID3, VariableId_3, VarFieldId_3, Operator, OperationOrderId, CommentFlag, RuleCalFlag, FunctionType FROM TempRuleOperationTable')
					EXECUTE('DROP TABLE TempRuleOperationTable')
					EXECUTE('INSERT INTO WFCabVersionTable(cabVersion, creationDate, lastModified, Remarks, Status) VALUES (N''7.2_RuleOperationTable'', GETDATE(), GETDATE(), N''BPEL Compliant OmniFlow'', N''Y'')')
				COMMIT TRANSACTION trans
				PRINT 'Table TempRuleOperationTable dropped successfully...........'
		END

		IF NOT EXISTS(SELECT * FROM WFCabVersionTable WHERE CabVersion = '7.2_RuleConditionTable') /* Check entry in WFCabVersionTable */
		BEGIN
			EXECUTE SP_RENAME 'RuleConditionTable', 'TempRuleConditionTable'
			EXECUTE(
				'CREATE TABLE RuleConditionTable (
					ProcessDefId 	    	INT				NOT NULL,
					ActivityId          	INT				NOT NULL ,
					RuleType            	NVARCHAR(1)   	NOT NULL ,
					RuleOrderId         	SMALLINT      	NOT NULL ,
					RuleId              	SMALLINT      	NOT NULL ,
					ConditionOrderId    	SMALLINT 		NOT NULL ,
					Param1					NVARCHAR(50) 	NOT NULL ,
					Type1               	NVARCHAR(1) 	NOT NULL ,
					ExtObjID1	    		INT					NULL,
					VariableId_1			INT					NULL ,
					VarFieldId_1			INT                 NULL ,
					Param2					NVARCHAR(255) 	NOT NULL ,
					Type2               	NVARCHAR(1) 	NOT NULL ,
					ExtObjID2	    		INT					NULL,
					VariableId_2			INT                 NULL ,
					VarFieldId_2			INT                 NULL ,
					Operator            	SMALLINT 		NOT NULL ,
					LogicalOp           	SMALLINT 		NOT NULL 
					)'
				)
			PRINT 'Table RuleConditionTable Created successfully.....'
			BEGIN TRANSACTION trans
				EXECUTE('INSERT INTO RuleConditionTable SELECT ProcessDefId, ActivityId, RuleType, RuleOrderId, RuleId, ConditionOrderId, Param1, Type1, ExtObjID1, VariableId_1, VarFieldId_1, Param2, Type2, ExtObjID2, VariableId_2, VarFieldId_2, Operator, LogicalOp FROM TempRuleConditionTable')
				EXECUTE('DROP TABLE TempRuleConditionTable')
				EXECUTE('INSERT INTO WFCabVersionTable(cabVersion, creationDate, lastModified, Remarks, Status) VALUES (N''7.2_RuleConditionTable'', GETDATE(), GETDATE(), N''BPEL Compliant OmniFlow'', N''Y'')')
			COMMIT TRANSACTION trans
			PRINT 'Table TempRuleConditionTable dropped successfully...........'
		END

		IF NOT EXISTS(SELECT * FROM WFCabVersionTable WHERE CabVersion = '7.2_ExtMethodParamMappingTable') /* check entry in WFCabVersionTable */ 
		BEGIN
			EXECUTE SP_RENAME 'ExtMethodParamMappingTable', 'TempExtMethodParamMappingTable'
			EXECUTE(
				'CREATE TABLE ExtMethodParamMappingTable (
					ProcessDefId		INTEGER		NOT NULL, 
					ActivityId		INTEGER		NOT NULL,
					RuleId			INTEGER		NOT NULL,
					RuleOperationOrderId	SMALLINT	NOT NULL,
					ExtMethodIndex		INTEGER		NOT NULL,
					MapType			NVARCHAR(1)	CHECK (MapType in (N''F'', N''R'')),
					ExtMethodParamIndex	INTEGER		NOT NULL,
					MappedField		NVARCHAR(255),
					MappedFieldType		NVARCHAR(1)	CHECK (MappedFieldType	in (N''Q'', N''F'', N''C'', N''S'', N''I'', N''M'', N''U'')),
					VariableId		INT,
					VarFieldId		INT,
					DataStructureId		INTEGER
				)'
			)
			PRINT 'Table ExtMethodParamMappingTable Created successfully.....'
			BEGIN TRANSACTION trans
				EXECUTE('INSERT INTO ExtMethodParamMappingTable SELECT ProcessDefId, ActivityId, RuleId, RuleOperationOrderId, ExtMethodIndex, MapType, ExtMethodParamIndex, MappedField, MappedFieldType, VariableId, VarFieldId, DataStructureId FROM TempExtMethodParamMappingTable')
				EXECUTE('DROP TABLE TempExtMethodParamMappingTable')
				EXECUTE('INSERT INTO WFCabVersionTable(cabVersion, creationDate, lastModified, Remarks, Status) VALUES (N''7.2_ExtMethodParamMappingTable'', GETDATE(), GETDATE(), N''BPEL Compliant OmniFlow'', N''Y'')')
			   COMMIT TRANSACTION trans
			PRINT 'Table TempExtMethodParamMappingTable dropped successfully...........'
		END

		IF NOT EXISTS(SELECT * FROM WFCabVersionTable WHERE CabVersion = '7.2_ActionConditionTable') /* Check entry in WFCabVersionTable */
		BEGIN
			EXECUTE SP_RENAME 'ActionConditionTable', 'TempActionConditionTable'
			EXECUTE(
				'CREATE TABLE ActionConditionTable (
					ProcessDefId            INT										NOT NULL,
					ActivityId              INT				CONSTRAINT rct_sid      NOT NULL,
					RuleType				NVARCHAR(1)		CONSTRAINT rct_rtype    NOT NULL,
					RuleOrderId				INT				CONSTRAINT rct_iroid    NOT NULL,
					RuleId					INT				CONSTRAINT rct_rid      NOT NULL,
					ConditionOrderId		INT				CONSTRAINT rct_coid     NOT NULL,
					Param1					NVARCHAR(50)	CONSTRAINT rct_p1		NOT NULL,
					Type1					NVARCHAR(1)		CONSTRAINT rct_type1	NOT NULL,
					ExtObjID1				INT											NULL,
					VariableId_1			INT											NULL,
					VarFieldId_1			INT											NULL,
					Param2					NVARCHAR(255)   CONSTRAINT rct_p2		NOT NULL,
					Type2					NVARCHAR(1)     CONSTRAINT rct_type2	NOT NULL,
					ExtObjID2				INT											NULL,
					VariableId_2			INT											NULL,
					VarFieldId_2			INT											NULL,
					Operator				INT             CONSTRAINT rct_oprt     NOT NULL,
					LogicalOp				INT             CONSTRAINT rct_oprt     NOT NULL
				)'
			)
			PRINT 'Table ActionConditionTable Created successfully.....'
				BEGIN TRANSACTION trans
					EXECUTE('INSERT INTO ActionConditionTable SELECT ProcessDefId, ActivityId, RuleType, RuleOrderId, RuleId, ConditionOrderId, Param1, Type1, ExtObjID1, VariableId_1, VarFieldId_1, Param2, Type2, ExtObjID2, VariableId_2, VarFieldId_2, Operator, LogicalOp FROM TempActionConditionTable')
					EXECUTE('DROP TABLE TempActionConditionTable')
					EXECUTE('INSERT INTO WFCabVersionTable(cabVersion, creationDate, lastModified, Remarks, Status) VALUES (N''7.2_ActionConditionTable'', GETDATE(), GETDATE(), N''Complex Data Type Support'', N''Y'')')
				COMMIT TRANSACTION trans
				PRINT 'Table TempActionConditionTable dropped successfully...........'
		END

		IF NOT EXISTS(SELECT * FROM WFCabVersionTable WHERE CabVersion = '7.2_MailTriggerTable') /* Check entry in WFCabVersionTable */
		BEGIN
			EXECUTE SP_RENAME 'MailTriggerTable', 'TempMailTriggerTable'
			EXECUTE(
				'CREATE TABLE MailTriggerTable (
					ProcessDefId 		INT 			NOT NULL,
					TriggerID 			SMALLINT 		NOT NULL,
					Subject 			NVARCHAR(255) 		NULL,
					FromUser			NVARCHAR(255)		NULL,
					FromUserType		NVARCHAR(1)			NULL,
					ExtObjIDFromUser 	INT 				NULL,
					VariableIdFrom		INT					NULL,
					VarFieldIdFrom		INT					NULL,
					ToUser				NVARCHAR(255)	NOT NULL,
					ToType				NVARCHAR(1)		NOT NULL,
					ExtObjIDTo			INT					NULL,
					VariableIdTo		INT					NULL,
					VarFieldIdTo		INT					NULL,
					CCUser				NVARCHAR(255)		NULL,
					CCType				NVARCHAR(1)			NULL,
					ExtObjIDCC			INT					NULL,	
					VariableIdCc		INT					NULL,
					VarFieldIdCc		INT					NULL,
					Message				TEXT				NULL
					PRIMARY KEY (Processdefid , TriggerID)
				)'
			)
			PRINT 'Table MailTriggerTable Created successfully.....'
				BEGIN TRANSACTION trans
					EXECUTE('INSERT INTO MailTriggerTable SELECT ProcessDefId, TriggerID, Subject, FromUser, FromUserType, ExtObjIDFromUser, VariableIdFrom, VarFieldIdFrom, ToUser, ToType, ExtObjIDTo, VariableIdTo, VarFieldIdTo, CCUser, CCType, ExtObjIDCC, VariableIdCc, VarFieldIdCc, Message FROM TempMailTriggerTable')
					EXECUTE('DROP TABLE TempMailTriggerTable')
					EXECUTE('INSERT INTO WFCabVersionTable(cabVersion, creationDate, lastModified, Remarks, Status) VALUES (N''7.2_MailTriggerTable'', GETDATE(), GETDATE(), N''Complex Data Type Support'', N''Y'')')
				COMMIT TRANSACTION trans
				PRINT 'Table TempMailTriggerTable dropped successfully...........'
		END

		IF NOT EXISTS(SELECT * FROM WFCabVersionTable WHERE CabVersion = '7.2_DataSetTriggerTable') /* Check entry in WFCabVersionTable */
		BEGIN
			EXECUTE SP_RENAME 'DataSetTriggerTable', 'TempDataSetTriggerTable'
			EXECUTE(
				'CREATE TABLE DataSetTriggerTable (
					ProcessDefId 	INT 			NOT NULL,
					TriggerID 		SMALLINT 		NOT NULL,
					Param1			NVARCHAR(50) 	NOT NULL,
					Type1			NVARCHAR(1)		NOT NULL,
					ExtObjID1		INT					NULL,
					VariableId_1	INT					NULL,
					VarFieldId_1	INT					NULL,
					Param2			NVARCHAR(255) 	NOT NULL,
					Type2			NVARCHAR(1)		NOT NULL,
					ExtObjID2		INT					NULL,
					VariableId_2	INT					NULL,
					VarFieldId_2	INT					NULL
				)'
			)
			PRINT 'Table DataSetTriggerTable Created successfully.....'
				BEGIN TRANSACTION trans
					EXECUTE('INSERT INTO DataSetTriggerTable SELECT ProcessDefId, TriggerID, Param1, Type1, ExtObjID1, VariableId_1, VarFieldId_1, Param2, Type2, ExtObjID2, VariableId_2, VarFieldId_2 FROM TempDataSetTriggerTable')
					EXECUTE('DROP TABLE TempDataSetTriggerTable')
					EXECUTE('INSERT INTO WFCabVersionTable(cabVersion, creationDate, lastModified, Remarks, Status) VALUES (N''7.2_DataSetTriggerTable'', GETDATE(), GETDATE(), N''Complex Data Type Support'', N''Y'')')
				COMMIT TRANSACTION trans
				PRINT 'Table TempDataSetTriggerTable dropped successfully...........'
		END

		IF NOT EXISTS(SELECT * FROM WFCabVersionTable WHERE CabVersion = '7.2_PrintFaxEmailTable') /* Check entry in WFCabVersionTable */
		BEGIN
			EXECUTE SP_RENAME 'PrintFaxEmailTable', 'TempPrintFaxEmailTable'
			EXECUTE(
				'CREATE TABLE PrintFaxEmailTable (
					ProcessDefId            INT				NOT NULL,
					PFEInterfaceId          INT				NOT NULL,
					InstrumentData          NVARCHAR(1)			NULL,
					FitToPage               NVARCHAR(1)			NULL,
					Annotations             NVARCHAR(1)			NULL,
					FaxNo                   NVARCHAR(255)		NULL,
					FaxNoType               NVARCHAR(1)			NULL,
					ExtFaxNoId              INT					NULL,
					VariableIdFax			INT					NULL,
					VarFieldIdFax			INT					NULL,
					CoverSheet              NVARCHAR(50)		NULL,
					CoverSheetBuffer        IMAGE				NULL,
					ToUser                  NVARCHAR(255)		NULL,
					FromUser                NVARCHAR(255)		NULL,
					ToMailId                NVARCHAR(255)		NULL,
					ToMailIdType            NVARCHAR(1)			NULL,
					ExtToMailId             INT					NULL,
					VariableIdTo			INT					NULL,
					VarFieldIdTo			INT					NULL,
					CCMailId                NVARCHAR(255)		NULL,
					CCMailIdType            NVARCHAR(1)			NULL,
					ExtCCMailId             INT					NULL,
					VariableIdCc			INT					NULL,
					VarFieldIdCc			INT					NULL,
					SenderMailId            NVARCHAR(255)		NULL,
					SenderMailIdType        NVARCHAR(1)			NULL,
					ExtSenderMailId         INT					NULL,
					VariableIdFrom			INT					NULL,
					VarFieldIdFrom			INT					NULL,
					Message                 Text				NULL,
					Subject                 NVARCHAR(255)		NULL
				)'
			)
			PRINT 'Table PrintFaxEmailTable Created successfully.....'
				BEGIN TRANSACTION trans
					EXECUTE('INSERT INTO PrintFaxEmailTable SELECT ProcessDefId, PFEInterfaceId, InstrumentData, FitToPage, Annotations, FaxNo, FaxNoType, ExtFaxNoId, VariableIdFax, VarFieldIdFax, CoverSheet, CoverSheetBuffer, ToUser, FromUser, ToMailId, ToMailIdType, ExtToMailId, VariableIdTo, VarFieldIdTo, CCMailId, CCMailIdType, ExtCCMailId, VariableIdCc, VarFieldIdCc, SenderMailId, SenderMailIdType, ExtSenderMailId, VariableIdFrom, VarFieldIdFrom, Message, Subject FROM TempPrintFaxEmailTable')
					EXECUTE('DROP TABLE TempPrintFaxEmailTable')
					EXECUTE('INSERT INTO WFCabVersionTable(cabVersion, creationDate, lastModified, Remarks, Status) VALUES (N''7.2_PrintFaxEmailTable'', GETDATE(), GETDATE(), N''Complex Data Type Support'', N''Y'')')
				COMMIT TRANSACTION trans
				PRINT 'Table TempPrintFaxEmailTable dropped successfully...........'
		END

		IF NOT EXISTS(SELECT * FROM WFCabVersionTable WHERE CabVersion = '7.2_ScanActionsTable') /* Check entry in WFCabVersionTable */
		BEGIN
			EXECUTE SP_RENAME 'ScanActionsTable', 'TempScanActionsTable'
			EXECUTE(
				'CREATE TABLE ScanActionsTable (
					ProcessDefId		INT             NOT NULL,
					DocTypeId			INT             NOT NULL,
					ActivityId			INT             NOT NULL,
					Param1				NVARCHAR(50)    NOT NULL,
					Type1				NVARCHAR(1)     NOT NULL,
					ExtObjId1			INT             NOT NULL,
					VariableId_1		INT					NULL,
					VarFieldId_1		INT					NULL,
					Param2				NVARCHAR(255)   NOT NULL,
					Type2				NVARCHAR(1)     NOT NULL,
					ExtObjId2			INT             NOT NULL,
					VariableId_2		INT					NULL,
					VarFieldId_2		INT					NULL
				)'
			)
			PRINT 'Table ScanActionsTable Created successfully.....'
				BEGIN TRANSACTION trans
					EXECUTE('INSERT INTO ScanActionsTable SELECT ProcessDefId, DocTypeId, ActivityId, Param1, Type1, ExtObjId1, VariableId_1, VarFieldId_1, Param2, Type2, ExtObjId2, VariableId_2, VarFieldId_2 FROM TempScanActionsTable')
					EXECUTE('DROP TABLE TempScanActionsTable')
					EXECUTE('INSERT INTO WFCabVersionTable(cabVersion, creationDate, lastModified, Remarks, Status) VALUES (N''7.2_ScanActionsTable'', GETDATE(), GETDATE(), N''Complex Data Type Support'', N''Y'')')
				COMMIT TRANSACTION trans
				PRINT 'Table TempScanActionsTable dropped successfully...........'
		END

		IF NOT EXISTS(SELECT * FROM WFCabVersionTable WHERE CabVersion = '7.2_ToDoListDefTable') /* Check entry in WFCabVersionTable */
		BEGIN
			EXECUTE SP_RENAME 'ToDoListDefTable', 'TempToDoListDefTable'
			EXECUTE(
				'CREATE TABLE ToDoListDefTable (
					ProcessDefId		INTEGER			NOT NULL,
					ToDoId				INTEGER			NOT NULL,
					ToDoName			NVARCHAR(255)	NOT NULL,
					Description			NVARCHAR(255)	NOT NULL,
					Mandatory			NVARCHAR(1)		NOT NULL,
					ViewType			NVARCHAR(1)			NULL,
					AssociatedField		NVARCHAR(255)		NULL,
					ExtObjID			INTEGER				NULL,
					VariableId		INT					NULL,
					VarFieldId		INT					NULL,
					TriggerName			NVARCHAR(50)		NULL
				)'
			)
			PRINT 'Table ToDoListDefTable Created successfully.....'
				BEGIN TRANSACTION trans
					EXECUTE('INSERT INTO ToDoListDefTable SELECT ProcessDefId, ToDoId, ToDoName, Description, Mandatory, ViewType, AssociatedField, ExtObjID, VariableId, VarFieldId, TriggerName FROM TempToDoListDefTable')
					EXECUTE('DROP TABLE TempToDoListDefTable')
					EXECUTE('INSERT INTO WFCabVersionTable(cabVersion, creationDate, lastModified, Remarks, Status) VALUES (N''7.2_ToDoListDefTable'', GETDATE(), GETDATE(), N''Complex Data Type Support'', N''Y'')')
				COMMIT TRANSACTION trans
				PRINT 'Table TempToDoListDefTable dropped successfully...........'
		END

		IF NOT EXISTS(SELECT * FROM WFCabVersionTable WHERE CabVersion = '7.2_ImportedProcessDefTable') /* Check entry in WFCabVersionTable */
		BEGIN
			EXECUTE SP_RENAME 'ImportedProcessDefTable', 'TempImportedProcessDefTable'
			EXECUTE(
				'CREATE TABLE ImportedProcessDefTable (
					ProcessDefID 			INT 			NOT NULL,
					ActivityId				INT				NOT NULL ,
					ImportedProcessName 	NVARCHAR(30)	NOT NULL ,
					ImportedFieldName 		NVARCHAR(63)	NOT NULL ,
					FieldDataType			INT					NULL ,	
					FieldType				NVARCHAR(1)		NOT NULL,
					VariableId				INT					NULL,
					VarFieldId				INT					NULL,
					DisplayName				NVARCHAR(2000)		NULL	
				)'
			)
			PRINT 'Table ImportedProcessDefTable Created successfully.....'
				BEGIN TRANSACTION trans
					EXECUTE('INSERT INTO ImportedProcessDefTable SELECT ProcessDefID, ActivityId, ImportedProcessName, ImportedFieldName, FieldDataType, FieldType, VariableId, VarFieldId, DisplayName FROM TempImportedProcessDefTable')
					EXECUTE('DROP TABLE TempImportedProcessDefTable')
					EXECUTE('INSERT INTO WFCabVersionTable(cabVersion, creationDate, lastModified, Remarks, Status) VALUES (N''7.2_ImportedProcessDefTable'', GETDATE(), GETDATE(), N''Complex Data Type Support'', N''Y'')')
				COMMIT TRANSACTION trans
				PRINT 'Table TempImportedProcessDefTable dropped successfully...........'
		END

		IF NOT EXISTS(SELECT * FROM WFCabVersionTable WHERE CabVersion = '7.2_InitiateWorkitemDefTable') /* Check entry in WFCabVersionTable */
		BEGIN
			EXECUTE SP_RENAME 'InitiateWorkitemDefTable', 'TempInitiateWorkitemDefTable'
			EXECUTE(
				'CREATE TABLE InitiateWorkitemDefTable (
					ProcessDefID 		INT				NOT NULL ,
					ActivityId			INT				NOT NULL  ,
					ImportedProcessName NVARCHAR(30)	NOT NULL  ,
					ImportedFieldName 	NVARCHAR(63)	NOT NULL ,
					ImportedVariableId	INT					NULL,
					ImportedVarFieldId	INT					NULL,
					MappedFieldName		NVARCHAR(63)	NOT NULL ,
					MappedVariableId	INT					NULL,
					MappedVarFieldId	INT					NULL,
					FieldType			NVARCHAR(1)		NOT NULL,
					MapType				NVARCHAR(1)			NULL,
					DisplayName			NVARCHAR(2000)	    NULL	
				)'
			)
			PRINT 'Table InitiateWorkitemDefTable Created successfully.....'
				BEGIN TRANSACTION trans
					EXECUTE('INSERT INTO InitiateWorkitemDefTable SELECT ProcessDefID, ActivityId, ImportedProcessName, ImportedFieldName, ImportedVariableId, ImportedVarFieldId, MappedFieldName, MappedVariableId, MappedVarFieldId, FieldType, MapType, DisplayName FROM TempInitiateWorkitemDefTable')
					EXECUTE('DROP TABLE TempInitiateWorkitemDefTable')
					EXECUTE('INSERT INTO WFCabVersionTable(cabVersion, creationDate, lastModified, Remarks, Status) VALUES (N''7.2_InitiateWorkitemDefTable'', GETDATE(), GETDATE(), N''Complex Data Type Support'', N''Y'')')
				COMMIT TRANSACTION trans
				PRINT 'Table TempInitiateWorkitemDefTable dropped successfully...........'
		END

		IF NOT EXISTS(SELECT * FROM WFCabVersionTable WHERE CabVersion = '7.2_WFDurationTable') /* Check entry in WFCabVersionTable */
		BEGIN
			IF NOT EXISTS( SELECT 1 FROM  WFDurationTable GROUP BY ProcessDefID, DurationId HAVING count(*) > 1 )
			BEGIN
				EXECUTE('Alter Table WFDurationTable DROP CONSTRAINT UK_WFDurationTable')
			END
			ELSE
			BEGIN
				PRINT 'Invalid Data in WFDurationTable'
			END
			
			EXECUTE SP_RENAME 'WFDurationTable', 'TempWFDurationTable'
			EXECUTE(
				'CREATE TABLE WFDurationTable(
					ProcessDefId		INT			NOT NULL,
					DurationId			INT			NOT NULL,
					WFYears				NVARCHAR(256),
					VariableId_Years	INT	,
					VarFieldId_Years	INT	, 
					WFMonths			NVARCHAR(256),
					VariableId_Months   INT	,
					VarFieldId_Months	INT	,
					WFDays				NVARCHAR(256),
					VariableId_Days		INT	,
					VarFieldId_Days		INT	,
					WFHours				NVARCHAR(256), 
					VariableId_Hours	INT	,
					VarFieldId_Hours	INT	,
					WFMinutes		NVARCHAR(256), 
					VariableId_Minutes	INT	,
					VarFieldId_Minutes	INT	,
					WFSeconds			NVARCHAR(256),
					VariableId_Seconds	INT	,
					VarFieldId_Seconds	INT	,
					CONSTRAINT UK_WFDurationTable UNIQUE (ProcessDefId, DurationId)
				)'
			)
			PRINT 'Table WFDurationTable Created successfully.....'	 
		   
			BEGIN TRANSACTION trans
				EXECUTE('INSERT INTO WFDurationTable SELECT ProcessDefId, DurationId, WFYears, VariableId_Years, VarFieldId_Years, WFMonths, VariableId_Months, VarFieldId_Months, WFDays, VariableId_Days, VarFieldId_Days, WFHours, VariableId_Hours, VarFieldId_Hours, WFMinutes, VariableId_Minutes, VarFieldId_Minutes, WFSeconds, VariableId_Seconds, VarFieldId_Seconds FROM TempWFDurationTable')
				EXECUTE('DROP TABLE TempWFDurationTable')
				PRINT 'Table TempWFDurationTable dropped successfully...........'
				EXECUTE('INSERT INTO WFCabVersionTable(cabVersion, creationDate, lastModified, Remarks, Status) VALUES (N''7.2_WFDurationTable'', GETDATE(), GETDATE(), N''BPEL Compliant OmniFlow'', N''Y'')')
			COMMIT TRANSACTION trans
		END
	END
END

~ 

EXEC Upgrade_VariableId

~

DROP PROCEDURE Upgrade_VariableId

~

CREATE PROCEDURE Upgrade_UserDiversion AS 
BEGIN
	DECLARE @DivUserName				NVARCHAR(200)
	DECLARE @AssUserName				NVARCHAR(200)
	DECLARE @AssignedUserName			NVARCHAR(200)
	DECLARE @DivertedUserName			NVARCHAR(200)
	DECLARE @v_STR1						NVARCHAR(2000)
	DECLARE @v_STR2						NVARCHAR(2000)
	DECLARE @v_STR3						NVARCHAR(2000)
	DECLARE @v_STR4						NVARCHAR(2000)
	DECLARE @v_STR5						NVARCHAR(2000)
	DECLARE @v_STR6						NVARCHAR(2000)
	DECLARE @v_paramDefinition1			NVARCHAR(2000)
	DECLARE @v_paramDefinition2			NVARCHAR(2000)
	DECLARE @v_paramDefinition3			NVARCHAR(2000)
	DECLARE @v_paramDefinition4			NVARCHAR(2000)
	DECLARE @DiverteduserIndex			INT
	DECLARE @AssigneduserIndex			INT
	DECLARE	@v_quoteChar 				CHAR(1) 
	SELECT	@v_quoteChar = CHAR(39) 

	BEGIN
		DECLARE cursor1 CURSOR FAST_FORWARD FOR
		SELECT DivertedUserIndex, AssignedUserIndex FROM Userdiversiontable
		OPEN cursor1
		FETCH NEXT FROM cursor1 INTO @DivertedUserIndex, @AssignedUserIndex
		WHILE(@@FETCH_STATUS = 0) 
		BEGIN
			SELECT @v_STR1 = ' SELECT @AssUserName = AssignedUserName FROM UserDiversionTable ' +
				             ' where AssignedUserIndex = ' + convert(Nvarchar(20), @AssignedUserIndex)+
					         ' and DivertedUserIndex = ' + convert(Nvarchar(20), @DivertedUserIndex)
			SELECT @v_paramDefinition1 = '@AssUserName NVARCHAR(200) OUTPUT'
			EXEC sp_executesql @v_STR1, @v_paramDefinition1, @AssUserName = @AssignedUserName OUTPUT
			SELECT @v_STR2 = ' SELECT @DivUserName = DivertedUserName FROM UserDiversionTable ' +
					         ' where AssignedUserIndex = ' + convert(Nvarchar(20), @AssignedUserIndex)+
					         ' and DivertedUserIndex = ' + convert(Nvarchar(20), @DivertedUserIndex)
			SELECT @v_paramDefinition2 = '@DivUserName NVARCHAR(200) OUTPUT'
			EXEC sp_executesql @v_STR2, @v_paramDefinition2, @DivUserName = @DivertedUserName OUTPUT
			IF(@DivertedUserName is null or @AssignedUserName is null)
			BEGIN
				SELECT @v_STR3 = ' SELECT @username1 = UserName FROM WFUserView ' +
								 ' WHERE userindex = ' + convert(Nvarchar(20), @DivertedUserIndex)
				SELECT @v_paramDefinition3 = '@username1 NVARCHAR(200) OUTPUT'
				EXEC sp_executesql @v_STR3, @v_paramDefinition3, @username1 = @DivUserName OUTPUT
				SELECT @v_STR4 = ' SELECT @username2 = UserName FROM WFUserView ' +
								 ' WHERE userindex = ' + convert(Nvarchar(20), @AssignedUserIndex)
				SELECT @v_paramDefinition4 = '@username2 NVARCHAR(200) OUTPUT'
				EXEC sp_executesql @v_STR4, @v_paramDefinition4, @username2 = @AssUserName OUTPUT
				BEGIN TRANSACTION trans
					SELECT @v_STR5 = 'UPDATE UserDiversionTable SET DivertedUserName =N' + @v_quoteChar + @DivUserName + @v_quoteChar +
								 ' WHERE DivertedUserIndex = ' + convert(NvarChar(20), @DivertedUserIndex)
					SELECT @v_STR6 = 'UPDATE UserDiversionTable SET AssignedUserName =N' + @v_quoteChar + @AssUserName + @v_quoteChar +
								 ' WHERE AssignedUserIndex = ' + convert(NvarChar(20), @AssignedUserIndex)
					EXECUTE(@v_str5)	
					EXECUTE(@v_str6)
					IF(@@error <> 0)
					BEGIN
						PRINT 'Error while inserting values in VariableId....'
						ROLLBACK TRANSACTION trans
						RETURN
					END
				COMMIT TRANSACTION trans
			END
			FETCH NEXT FROM cursor1 INTO @DivertedUserIndex, @AssignedUserIndex
		END
		CLOSE cursor1
		DEALLOCATE cursor1

		IF NOT EXISTS(SELECT * FROM WFCabVersionTable WHERE CabVersion = '7.2_UserDiversionTable') /* Check entry in WFCabVersionTable */
		BEGIN
			IF NOT EXISTS( SELECT 1 FROM  UserDiversionTable GROUP BY Diverteduserindex, AssignedUserindex, fromdate HAVING count(*) > 1 )
			BEGIN
				EXECUTE('Alter Table UserDiversionTable DROP CONSTRAINT Pk_userdiversion')
			END
			ELSE
			BEGIN
				PRINT 'Invalid Data in UserDiversionTable'
			END

			EXECUTE SP_RENAME 'UserDiversionTable', 'TEMP_UserDiversionTable'
			EXECUTE(
			   'CREATE TABLE USERDIVERSIONTABLE ( 
				Diverteduserindex 		SMALLINT		NOT NULL, 
				DivertedUserName		NVARCHAR(64), 
				AssignedUserindex 		SMALLINT		NOT NULL,
				AssignedUserName		NVARCHAR(64),	
				fromdate				DATETIME		NOT NULL, 
				todate					DATETIME, 
				currentworkitemsflag 	NVARCHAR(1) CHECK ( currentworkitemsflag  in (N''Y'', N''N''))
				CONSTRAINT Pk_userdiversion PRIMARY KEY (Diverteduserindex, AssignedUserindex,fromdate) 
			   )'
			)
			PRINT 'Table UserDiversionTable Created successfully.....'
			BEGIN TRANSACTION trans
				EXECUTE('INSERT INTO UserDiversionTable SELECT Diverteduserindex, DivertedUserName, AssignedUserindex, AssignedUserName, fromdate, todate, currentworkitemsflag FROM TEMP_UserDiversionTable')
				EXECUTE('DROP Table TEMP_UserDiversionTable')
				EXECUTE('INSERT INTO WFCabVersionTable(cabVersion, creationDate, lastModified, Remarks, Status) VALUES (N''7.2_UserDiversionTable'', GETDATE(), GETDATE(), N''BPEL Compliant OmniFlow'', N''Y'')')
			COMMIT TRANSACTION trans
		END

        /* SrNo-15  SAP Implementation - Added By Ananta Handoo Five tables added WFSAPConnectTable, WFSAPGUIDefTable, WFSAPGUIFieldMappingTable, 
	WFSAPGUIAssocTable, WFSAPAdapterAssocTable */

	IF NOT EXISTS(
		SELECT * FROM SYSObjects 
		WHERE NAME = 'WFSAPConnectTable' 
		AND xType = 'U'
	)
	BEGIN
		EXECUTE(' 
			CREATE TABLE WFSAPConnectTable (
				ProcessDefId		        INT			NOT NULL	Primary Key,
				SAPHostName			NVarChar(64)	        NOT NULL,
				SAPInstance			NVarChar(2)		NOT NULL,
				SAPClient			NVarChar(3)		NOT NULL,
				SAPUserName			NVarChar(256)	        NULL,
				SAPPassword			NVarChar(512)	        NULL,
				SAPHttpProtocol		        NVarChar(8)		NULL,
				SAPITSFlag			NVarChar(1)		NULL,
				SAPLanguage			NVarChar(8)		NULL,
				SAPHttpPort			INT			NULL
			)
		')
		PRINT 'Table WFSAPConnectTable created successfully.'
	END

        /* Added By Ananta Handoo on 22/04/2009 */
	IF NOT EXISTS(
	       SELECT * FROM SYSObjects 
	       WHERE NAME = 'WFSAPGUIDefTable'
	       AND xType = 'U'
	)
	BEGIN
	        EXECUTE(' 
			CREATE TABLE WFSAPGUIDefTable (
			ProcessDefId		INT				NOT NULL,
			DefinitionId		INT				NOT NULL,
			DefinitionName		NVarChar(256)	                NOT NULL,
			SAPTCode		NVarChar(16)	                NOT NULL,
			PRIMARY KEY (ProcessDefId, DefinitionId)
			)
		')
		PRINT 'Table WFSAPGUIDefTable created successfully.'
	END

	/* Added By Ananta Handoo on 22/04/2009 */
	IF NOT EXISTS(
	       SELECT * FROM SYSObjects 
	       WHERE NAME = 'WFSAPGUIFieldMappingTable'
	       AND xType = 'U'
	)
	BEGIN
	        EXECUTE(' 
			CREATE TABLE WFSAPGUIFieldMappingTable (
			ProcessDefId		INT				NOT NULL,
			DefinitionId		INT				NOT NULL,
			SAPFieldName		NVarChar(512)	                NOT NULL,
			MappedFieldName		NVarChar(256)	                NOT NULL,
			MappedFieldType		NVarChar(1)	                CHECK (MappedFieldType	in (N''Q'', N''F'', N''C'', N''S'', N''I'', N''M'', N''U'')),
			VariableId		INT				NULL,
			VarFieldId		INT				NULL
			)
		')
		PRINT 'Table WFSAPGUIFieldMappingTable created successfully.'
	END

	 /* Added By Ananta Handoo on 22/04/2009 */
	IF NOT EXISTS(
	       SELECT * FROM SYSObjects 
	       WHERE NAME = 'WFSAPGUIAssocTable'
	       AND xType = 'U'
	)
	BEGIN
	        EXECUTE('
			CREATE TABLE WFSAPGUIAssocTable (
			ProcessDefId		INT				NOT NULL,
			ActivityId		INT				NOT NULL,
			DefinitionId		INT				NOT NULL,
			Coordinates             NVarChar(255)                   NULL, 
			CONSTRAINT UK_WFSAPGUIAssocTable UNIQUE (ProcessDefId, ActivityId, DefinitionId)
			)
		')
		PRINT 'Table WFSAPGUIAssocTable created successfully.'
	END

         /* Added By Ananta Handoo on 22/04/2009 */
	IF NOT EXISTS(
	       SELECT * FROM SYSObjects 
	       WHERE NAME = 'WFSAPAdapterAssocTable'
	       AND xType = 'U'
	       )
	BEGIN
	        EXECUTE('
			CREATE TABLE WFSAPAdapterAssocTable (
			ProcessDefId		INT				 NULL,
			ActivityId		INT				 NULL,
			EXTMETHODINDEX		INT				 NULL
			)
                ')
		PRINT 'Table WFSAPAdapterAssocTable created successfully.'
	END

    END	
END

~ 

EXEC Upgrade_UserDiversion

~

DROP PROCEDURE Upgrade_UserDiversion

~
If Exists (SELECT 1 FROM SYSObjects WHERE NAME = 'UPGRADE_ACT_EXPIRY' AND xType = 'P')
Begin
	Drop Procedure UPGRADE_ACT_EXPIRY
	PRINT 'As Procedure Upgrade exists dropping old procedure ........... '
End
PRINT 'Creating procedure Upgrade ........... '
~
CREATE PROCEDURE UPGRADE_ACT_EXPIRY AS
BEGIN
	DECLARE @v_queryStr	  VARCHAR(1000)
	DECLARE @v_ProcDefId   INTEGER
	DECLARE @v_ActID 		  INTEGER
	DECLARE @v_ExpiryStr   VARCHAR(100)
	DECLARE @v_retval 		  INTEGER
	DECLARE @v_DBStatus		INTEGER
	DECLARE @v_Days			  VARCHAR(10)
	DECLARE @v_DurationId	INTEGER
	/*Expiry format should be as '0*24 + 2'
	*Only days to be modified
	*/
	Declare v_Cursor CURSOR FAST_FORWARD FOR
		SELECT PROCESSDEFID, ACTIVITYID, EXPIRY FROM ACTIVITYTABLE WHERE EXPIRY IS NOT NULL

	Open v_Cursor

	FETCH NEXT FROM v_Cursor INTO @v_ProcDefId,@v_ActID,@v_ExpiryStr
	
	WHILE (@@FETCH_STATUS <> -1) 
		BEGIN
			IF(@@FETCH_STATUS <> -2)
			BEGIN
				select @v_Days = SUBSTRING(@v_ExpiryStr,7, 8);
				IF(@v_Days IS NOT NULL AND LEN(@v_Days) > 0) 
				BEGIN
					SELECT @v_DurationId=MAX(DURATIONID)+1 FROM WFDURATIONTABLE WHERE PROCESSDEFID = @v_ProcDefId;
					IF( @v_DurationId IS NULL )  
					BEGIN
						INSERT INTO WFDURATIONTABLE (PROCESSDEFID, DURATIONID, WFDAYS) values(@v_ProcDefId,1,@v_Days);
						UPDATE ACTIVITYTABLE SET EXPIRY = 1 WHERE PROCESSDEFID = @v_ProcDefId AND ACTIVITYID = @v_ActID;
					END;
					ELSE
					BEGIN
						INSERT INTO WFDURATIONTABLE (PROCESSDEFID, DURATIONID, WFDAYS) values(@v_ProcDefId,@v_DurationId,@v_Days);
						UPDATE ACTIVITYTABLE SET EXPIRY = @v_DurationId WHERE PROCESSDEFID = @v_ProcDefId AND ACTIVITYID = @v_ActID;
					END;
				END;
			END;
			FETCH NEXT FROM v_Cursor INTO @v_ProcDefId,@v_ActID,@v_ExpiryStr
		END;
		Close v_Cursor
		Deallocate v_Cursor
END;
~
EXEC UPGRADE_ACT_EXPIRY
~
Drop Procedure UPGRADE_ACT_EXPIRY