/*____________________________________________________________________________________________________
			NEWGEN SOFTWARE TECHNOLOGIES LIMITED
		Group					: Phoenix
		Product / Project		: WorkFlow 7.1
		Module					: Workflow Server
		File Name				: OFCabCreation.sql
		Author					: Varun Bhansaly
		Date written(DD/MM/YYYY): 21/12/2007
		Description				: Script for cabinet creation (Omniflow).
____________________________________________________________________________________________________
			CHANGE HISTORY
____________________________________________________________________________________________________
Date(DD/MM/YYYY)  Change By			Change Description (Bug No. (If Any))
09/01/2008		Ashish Mangla		Bugzilla Bug 1788
25/01/2008		Varun Bhansaly		Bugzilla Id 1719 ([CabCreation + Upgrade] Indexes required on ExceptionTable & ExceptionHistoryTable)
25/01/2008		Varun Bhansaly		Entry in WFCabVersionTable for HOTFIX_6.2_036
28/01/2008 		Varun Bhansaly		Entry in WFCabVersionTable for MULTIPLE_EXCEPTION_AND_MINUTE_SUPPORT
31/01/2008		Ruhi Hira		    Bugzilla Bug 3682, New columns in ExtMethodParamDefTable and WFDataStructureTable.
06/02/2008		Varun Bhansaly		Bugzilla Id 3682, (Enhancements in Web Services)
11/02/2008		Varun Bhansaly		ArchiveTable - AppServerPort size changed to 5
12/02/2008		Varun Bhansaly		ArchiveTable - PortId size changed to 5
20/05/2008		Ashish Mangla		Bugzilla Bug 5044 (UserDiversionTable, keep user name also in the table)
18/11/2008		Ishu Saraf			SrNo-14, Added table WFTypeDescTable, WFTypeDefTable, WFUDTVarMappingTable, WFVarRelationTable, WFDataObjectTable, WFGroupBoxTable, WFAdminLogTable, WFHistoryRouteLogTable, WFCurrentRouteLogTable, WFAutoGenInfoTable, WFSearchVariableTable, WFProxyInfo
18/11/2008		Ishu Saraf			SrNo-14, Added column VariableId, VarPrecision, Unbounded to VarMappingTable
										 Primary Key updated in VarMappingTable
18/11/2008		Ishu Saraf			SrNo-14, Added column VariableId to ActivityAssociationTable
18/11/2008		Ishu Saraf			SrNo-14, Added column VariableId_1, VarFieldId_1, VariableId_2, VarFieldId_2  to RuleConditionTable				
18/11/2008		Ishu Saraf			SrNo-14, Added column VariableId_1, VarFieldId_1, VariableId_2, VarFieldId_2, VariableId_3, VarFieldId_3, FunctionType  to RuleOperationTable
18/11/2008		Ishu Saraf			SrNo-14, Added column VariableId, VarFieldId to ExtMethodParamMappingTable
18/11/2008		Ishu Saraf			SrNo-14, Added column VariableId_1, VarFieldId_1, VariableId_2, VarFieldId_2  to ActionConditionTable, DataSetTriggerTable, ScanActionsTable
18/11/2008		Ishu Saraf			SrNo-14, Added column VariableId_1, VarFieldId_1, VariableId_2, VarFieldId_2, VariableId_3, VarFieldId_3 to ActionOperationTable
18/11/2008		Ishu Saraf			SrNo-14, Added column VariableId, VarFieldId to WFDataMapTable, DataEntryTriggerTable, ArchiveDataMapTable, WFJMSSubscribeTable
18/11/2008		Ishu Saraf			SrNo-14, Added column VariableId_1, VarFieldId_1 to ToDoListDefTable
18/11/2008		Ishu Saraf			SrNo-14, Added column VariableIdTo, VarFieldIdTo, VariableIdFrom, VarFieldIdFrom, VariableIdCc, VarFieldIdCc to MailTriggerTable
18/11/2008		Ishu Saraf			SrNo-14, Added column VariableIdTo, VarFieldIdTo, VariableIdFrom, VarFieldIdFrom, VariableIdCc, VarFieldIdCc, VariableIdFax, VarFieldIdFax to PrintFaxEmailTable
18/11/2008		Ishu Saraf			SrNo-14, Added column VariableId, VarFieldId, DisplayName to ImportedProcessDefTable
18/11/2008		Ishu Saraf			SrNo-14, Added column ImportedVariableId, ImportedVarfieldId, MappedVariableId, MappedVarFieldId, DisplayName to InitiateWorkItemDefTable
18/11/2008		Ishu Saraf			Added column VarPrecision to ExtDBFieldDefinitionTable
18/11/2008		Ishu Saraf			Added column ArgList in TemplateDefinitionTable and remove from GenerateResponseTable
18/11/2008		Ishu Saraf			SrNo-14, Added column FunctionType to WFWebServiceTable
18/11/2008		Ishu Saraf			SrNo-14, Added column Width, Height, BlockId, associatedUrl to ActivityTable
18/11/2008		Ishu Saraf			SrNo-14, Added column Unbounded to EXTMethodParamDefTable
										New WF Type 15, 16
18/11/2008		Ishu Saraf			SrNo-14, Added column Unbounded to WFDataStructureTable
18/11/2008		Ishu Saraf			SrNo-14, Altering constraint of ExtMethodDefTable,it can have values E/ W/ S
										New WF Type 15, 16
18/11/2008		Ishu Saraf			SrNo-14, Index Created on ActivityAssociationTable, WFCurrentRouteLogTable, WFHistoryRouteLogTable
18/11/2008		Ishu Saraf			Entry in WFCabVersionTable for 7.2_RuleConditionTable
									Entry in WFCabVersionTable for 7.2_RuleOperationTable
									Entry in WFCabVersionTable for 7.2_ExtMethodParamMappingTable
									Entry in WFCabVersionTable for 7.2_VarMappingTable
									Entry in WFCabVersionTable for 7.2_UserDiversionTable
									Entry in WFCabVersionTable for 7.2_ActionConditionTable
									Entry in WFCabVersionTable for 7.2_MailTriggerTable
									Entry in WFCabVersionTable for 7.2_DataSetTriggerTable
									Entry in WFCabVersionTable for 7.2_PrintFaxEmailTable
									Entry in WFCabVersionTable for 7.2_ScanActionsTable
									Entry in WFCabVersionTable for 7.2_ToDoListDefTable
									Entry in WFCabVersionTable for 7.2_ImportedProcessDefTable
									Entry in WFCabVersionTable for 7.2_InitiateWorkitemDefTable
18/11/2008		Ishu Saraf			Added Table WFAuthorizationTable, WFAuthorizeQueueDefTable, WFAuthorizeQueueStreamTable, WFAuthorizeQueueUserTable, WFAuthorizeProcessDefTable, WFCorrelationTable
19/11/2008		Ishu Saraf		    Changing name of WFCorrelationTable to WFSoapReqCorrelationTable
22/11/2008		Ishu Saraf			Added column VariableId_Years, VarFieldId_Years, VariableId_Months, VarFieldId_Months, VariableId_Days, VarFieldId_Days, VariableId_Hours, VarFieldId_Hours, VariableId_Minutes, VarFieldId_Minutes, VariableId_Seconds, VarFieldId_Seconds in WFDurationTable
22/11/2008		Ishu Saraf			Entry in WFCabVersionTable for 7.2_WFDurationTable
27/11/2008		Ishu Saraf			Addded column ReplyPath, AssociatedActivityId  to WFWebServiceTable 
27/11/2008		Ishu Saraf			Added Table WFWSAsyncResponseTable 
28/11/2008		Ishu Saraf			Unique constraint and Index added to WFWSAsyncResponseTable 
06/12/2008		Ishu Saraf			Added column allowSOAPRequest to ActivityTable
06/12/2008		Ishu Saraf			Added column QueueFilter to WFAuthorizeQueueDefTable]
08/12/2008		Ishu Saraf			Added column AssociatedActivityId to ActivityTable
15/12/2008		Ishu Saraf			Change version no from 7.2 to 8.0 in WFCabVersionTable
15/12/2008		Ishu Saraf			Added WFScopeDefTable, WFEventDefTable, WFActivityScopeAssocTable
15/12/2008		Ishu Saraf			Added column EventId to ActivityTable
05/01/2009		Ishu Saraf			Bugzilla BugId 7588 (Increase size of ColumnName from 64 to 255)
08/01/2009		Ishu Saraf			Bugzilla BugId 7574 (New columns added to WFSoapReqCorrelationTable)
27/03/2009		Ruhi Hira			SrNo-15, New tables added for SAP integration.
15/04/2009              Ananta Handoo                   New tables added for SAP integration.  
15/05/2009		Ishu Saraf			Added new table WFWebServiceInfoTable for webservice authentication.
23/06/2009              Ananta Handoo                   WFSAPGUIDefTable Modified by Ananta Handoo.Three fields added TCodeType, VariableId, VarFieldId
24/08/2009              Shilpi S                        Hotfix_8.0_045, two new columns VariableId and VarFieldId are added to WFPrintFaxEmailDocTypeTable for variabel support in doctypename in PFE
31/08/2009		Ashish Mangla			WFS_8.0_025 (Arglist length should increased to 2000 from 512 for generate Response)
31/08/2009      Shilpi S                WFS_8.0_026 , workitem specific calendar
12/08/2010		Prateek Verma			New tables added corresponding to MSSQL and Oracle
13/08/2010		Prateek Verma			Tables modified : PROCESSDEFCOMMENTTABLE
									DATASETTRIGGERTABLE
									QUEUEHISTORYTABLE
									QUEUEDEFTABLE
									QUEUEUSERTABLE
									VARALIASTABLE
									PENDINGWORKLISTTABLE
									WFMAILQUEUETABLE
									SCANACTIONSTABLE
									WFWebServiceTable
									WFSwimLaneTable
									WFAuthorizeQueueDefTable
20/10/2010  	Ashish Mangla       WFS_8.0_115 Liberty (Data class & Search Functionality)
09/11/2010  Saurabh Kamal       	Size of AssociatedFieldName and New Value changed in WFCURRENTROUTELOGTABLE and WFHISTORYROUTELOGTABLE
25/04/2011	Amit Goyal				Primary Key needs to be defined for ADO.Net. Tables modified: 
									TemplateDefinitionTable
									TemplateMultilanguageTable
									ActionDefTable
									WFFORM_Table
									ProcessINITable
									WFFORMFragmentTable
									PrintFaxEmailTable
									ToDoPickListTable
									InterfacedescLanguageTable
27/04/11	Amit Goyal			Data type changed from OID to TEXT for the following tables :
									ActivityTable
									TEMPLATEDEFINITIONTABLE
									ACTIONDEFTABLE
									PROCESSINITABLE
									PRINTFAXEMAILTABLE
									WFFORM_TABLE
									TemplateMultiLanguageTable
									WFFormFragmentTable
									WFBPELDefTable
29/04/11	Amit Goyal			Tables added : WFAuditRuleTable , WFAuditTrackTable	
13/05/11	Saurabh Kamal			More Index created on Omniflow Tables
02/06/11	Saurabh Kamal			Entry made into QueueDefTable for SystemPFEQueue and SystemArchiveQueue
26/06/12	Shweta Singhal		Bug 32808, SwimLaneId added in WFDataObjectTable
17/07/2012	Abhishek Gupta			Bug 32883	CallerProcessDefId changed to ImportedProcessDefId for ImportedProcessDefTable.[Changes for CallerProcessDefId reverted].
01/08/2012	Abhishek Gupta		Bug 33699 - unable to deploy any process[TRIGGERTYPEDEFTABLE column ClassName size increased.
01/08/2012	Abhishek Gupta		Bug 33751 - FormViewerApp column added to ProcessDefTable.
03/09/2012	Abhishek Gupta		Bug 34599 - after registering the process select the registered process invalid column name "format" message is appearing
17/10/2012	Shweta Singhal		Bug 34322 - User should get pop-up for reminder without relogin
10/01/2013	Shweta Singhal		New columns are added in WFAdminLogTable table for Right Management Auditing and changes done for Bug 37345
13/03/2013  Neeraj Sharma   	Bug 38685 An entry for each failed records need to be generated in
                 				WFFailedServicesTable if any error occurs while processing records from the CSV/TXT file.
14-03-2014	Sajid Khan			Type of System Queues should be different than "S" as "S" is for Permanent type of queues[A - QueueType for System Defined Queues].								
04/07/2017	Shubhankur Manuja	Added new comment type in WFCOMMENTSTABLE for storing comments entered by user at the time of rejecting the task.
________________________________________________________________________________________________
____________________________________________________________________________________________________
*/

/**** CREATE TABLE ****/
CREATE TABLE WFCabVersionTable (
	cabVersion		VARCHAR(255)	NOT NULL,
	cabVersionId	SERIAL			PRIMARY KEY,
	creationDate	TIMESTAMP,
	lastModified	TIMESTAMP,
	Remarks			VARCHAR(255)	NOT NULL,
	Status			VARCHAR(1)
)

~

INSERT INTO WFCabVersionTable(cabVersion, creationDate, lastModified, Remarks, Status) VALUES ('8.0',CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'OFCabCreation.sql', 'Y')

~

INSERT INTO WFCabVersionTable(cabVersion, creationDate, lastModified, Remarks, Status) VALUES ('HOTFIX_6.2_037',CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'HOTFIX_6.2_036 REPORT UPDATE', 'Y')

~

INSERT INTO WFCabVersionTable(cabVersion, creationDate, lastModified, Remarks, Status) VALUES ('MULTIPLE_EXCEPTION_AND_MINUTE_SUPPORT',CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'UPGRADE FOR MULTIPLE EXCEPTION AND TIMESTAMP', 'Y')

~

INSERT INTO WFCabVersionTable(cabVersion, creationDate, lastModified, Remarks, Status) VALUES ('Bugzilla_Id_3682', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'Enhancements in Web Services', 'Y')

~

INSERT INTO WFCabVersionTable(cabVersion, creationDate, lastModified, Remarks, Status) VALUES (N'7.2_ExtMethodParamMappingTable', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, N'BPEL Compliant OmniFlow', N'Y') /* avoid recreation of table if exists in case of addition of column variableid and varfieldid */

~
																																															
INSERT INTO WFCabVersionTable(cabVersion, creationDate, lastModified, Remarks, Status) VALUES (N'7.2_RuleConditionTable', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, N'BPEL Compliant OmniFlow', N'Y') /* avoid recreation of table if exists in case of addition of column variableid and varfieldid */

~

INSERT INTO WFCabVersionTable(cabVersion, creationDate, lastModified, Remarks, Status) VALUES (N'7.2_RuleOperationTable', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, N'BPEL Compliant OmniFlow', N'Y') /* avoid recreation of table if exists in case of addition of column variableid and varfieldid */

~

INSERT INTO WFCabVersionTable(cabVersion, creationDate, lastModified, Remarks, Status) VALUES (N'7.2_VarMappingTable', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, N'BPEL Compliant OmniFlow', N'Y') /* avoid recreation of table if exists in case of addition of column variableid varprecision and unbounded */

~

INSERT INTO WFCabVersionTable(cabVersion, creationDate, lastModified, Remarks, Status) VALUES (N'7.2_UserDiversionTable', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, N'BPEL Compliant OmniFlow', N'Y') /* avoid recreation of table if exists in case of addition of column userdiversionname and assignedusername */

~

INSERT INTO WFCabVersionTable(cabVersion, creationDate, lastModified, Remarks, Status) VALUES (N'7.2_ActionConditionTable', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, N'Complex Data Type Support', N'Y') /* avoid recreation of table if exists in case of addition of column VariableId_1, VarFieldId_1, VariableId_2, VarFieldId_2 */

~

INSERT INTO WFCabVersionTable(cabVersion, creationDate, lastModified, Remarks, Status) VALUES (N'7.2_MailTriggerTable', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, N'Complex Data Type Support', N'Y') /* avoid recreation of table if exists in case of addition of column VariableIdTo, VarFieldIdTo, VariableIdFrom, VarFieldIdFrom, VariableIdCc, VarFieldIdCc */

~

INSERT INTO WFCabVersionTable(cabVersion, creationDate, lastModified, Remarks, Status) VALUES (N'7.2_DataSetTriggerTable', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, N'Complex Data Type Support', N'Y') /* avoid recreation of table if exists in case of addition of column VariableId_1, VarFieldId_1, VariableId_2, VarFieldId_2 */

~

INSERT INTO WFCabVersionTable(cabVersion, creationDate, lastModified, Remarks, Status) VALUES (N'7.2_PrintFaxEmailTable', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, N'Complex Data Type Support', N'Y') /* avoid recreation of table if exists in case of addition of column VariableIdTo, VarFieldIdTo, VariableIdFrom, VarFieldIdFrom, VariableIdCc, VarFieldIdCc, VariableIdFax, VarFieldIdFax */

~

INSERT INTO WFCabVersionTable(cabVersion, creationDate, lastModified, Remarks, Status) VALUES (N'7.2_ScanActionsTable', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, N'Complex Data Type Support', N'Y') /* avoid recreation of table if exists in case of addition of column VariableId_1, VarFieldId_1, VariableId_2, VarFieldId_2 */

~

INSERT INTO WFCabVersionTable(cabVersion, creationDate, lastModified, Remarks, Status) VALUES (N'7.2_ToDoListDefTable', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, N'Complex Data Type Support', N'Y') /* avoid recreation of table if exists in case of addition of column  VariableId, VarFieldId */

~

INSERT INTO WFCabVersionTable(cabVersion, creationDate, lastModified, Remarks, Status) VALUES (N'7.2_ImportedProcessDefTable', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, N'Complex Data Type Support', N'Y') /* avoid recreation of table if exists in case of addition of column  VariableId, VarFieldId, DisplayName */

~

INSERT INTO WFCabVersionTable(cabVersion, creationDate, lastModified, Remarks, Status) VALUES (N'7.2_InitiateWorkitemDefTable', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, N'Complex Data Type Support', N'Y') /* avoid recreation of table if exists in case of addition of column ImportedVariableId, ImportedVarFieldId, MappedVariableId, MappedVarFieldId, DisplayName */

~

INSERT INTO WFCabVersionTable(cabVersion, creationDate, lastModified, Remarks, Status) VALUES (N'7.2_WFDurationTable', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, N'Complex Data Type Support', N'Y')

~

/******   PROCESSDEFTABLE    ******/

CREATE TABLE PROCESSDEFTABLE(
	ProcessDefId			INTEGER				NOT NULL,
	VersionNo				INTEGER				NOT NULL,
	ProcessName				VARCHAR(30)			NOT NULL,
	ProcessState			VARCHAR(10)			NULL,
	RegPrefix				VARCHAR(20)			NOT NULL,
	RegSuffix				VARCHAR(20)			NULL,
	RegStartingNo			INTEGER				NULL,
	ProcessTurnAroundTime	INTEGER				NULL,
	RegSeqLength			INTEGER				NULL,
	CreatedOn				TIMESTAMP			NULL, 
	LastModifiedOn			TIMESTAMP			NULL,
	WSFont					VARCHAR(255)		NULL,
	WSColor					INTEGER				NULL,
	CommentsFont			VARCHAR(255)		NULL,
	CommentsColor			INTEGER				NULL,
	Backcolor				INTEGER				NULL,
	TATCalFlag				VARCHAR(1)			NULL,
	Description 			TEXT				NULL,
	CreatedBy				VARCHAR(255)		NULL,
	LastModifiedBy			VARCHAR(255)		NULL,
	ProcessShared			NCHAR(1)			NULL,
	ProjectId				INTEGER				NULL,
	Cost					NUMERIC(15,2)		NULL,
	Duration				VARCHAR(255)		NULL,
	FormViewerApp			NCHAR(1)			NULL,
	PRIMARY KEY ( ProcessDefId, VersionNo)
)

~

/******   INTERFACEDEFTABLE    ******/

CREATE TABLE INTERFACEDEFTABLE(
	InterfaceId			INTEGER			PRIMARY KEY,
	InterfaceName		VARCHAR(255)	NOT NULL, 
	ClientInvocation	VARCHAR(255)	NULL, 
	ButtonName			VARCHAR(50)		NULL, 
	MenuName			VARCHAR(50)		NULL, 
	ExecuteClass		VARCHAR(255)	NULL,
	ExecuteClassWeb		VARCHAR(255)	NULL 
)

~

/*****    WFFailedServicesTable    ******/

CREATE TABLE WFFailedServicesTable(
	processDefId 	INTEGER 			NULL,
	ServiceName 	VARCHAR(200) 	NULL,
	ServiceType 	VARCHAR(30) 	NULL,
	ServiceId 		VARCHAR(200) 	NULL,
	ActionDateTime 	TIMESTAMP 		NULL,
	ObjectName 		VARCHAR(100) 	NULL,
	ErrorCode 		INTEGER 			NULL,
	ErrorMessage 	VARCHAR(500) 	NULL,
	Data_1 			INTEGER 			NULL,
	Data_2 			INTEGER 			NULL
)

~


/******   PROCESS_INTERFACETABLE    ******/

CREATE TABLE PROCESS_INTERFACETABLE(
	ProcessDefId		INTEGER			NOT NULL,
	InterfaceId			INTEGER			NOT NULL,
	InterfaceName		VARCHAR(255)	NOT NULL, 
	ClientInvocation	VARCHAR(255)	NULL, 
	MenuName			VARCHAR(50)		NULL, 
	ExecuteClass		VARCHAR(255)	NULL, 
	ExecuteClassWeb		VARCHAR(255)	NULL,
	PRIMARY KEY(ProcessDefId, InterfaceId)
)

~

/******   ACTIVITYTABLE    ******/

CREATE TABLE ACTIVITYTABLE(
	ProcessDefId			INTEGER			NOT NULL,
	ActivityId 				INTEGER 		NOT NULL,
	ActivityType 			INTEGER			NOT NULL,
	ActivityName			VARCHAR(30)		NOT NULL,
	Description				TEXT			NULL,
	xLeft 					INTEGER			NOT NULL,
	yTop 					INTEGER			NOT NULL,
	NeverExpireFlag			VARCHAR(1)		NOT NULL,
	Expiry 					VARCHAR(255)	NULL,
	ExpiryActivity 			VARCHAR(30)		NULL,
	TargetActivity 			INTEGER			NULL,
	AllowReASsignment		VARCHAR(1)		NULL,
	CollectNoOfInstances 	INTEGER			NULL,
	PrimaryActivity			VARCHAR(30)		NULL,
	ExpireOnPrimaryFlag		VARCHAR(1)		NULL,
	TriggerId 				INTEGER			NULL,
	HoldExecutable 			VARCHAR(255)	NULL,
	HoldTillVariable		VARCHAR(255)	NULL,
	ExtObjId 				INTEGER			NULL,
	MainClientInterface 	VARCHAR(255)	NULL,
	ServerInterface			VARCHAR(1)		CHECK (ServerINTerface IN ('Y', 'N', 'E')),
	WebClientInterface 		VARCHAR(255)	NULL,
	ActivityIcon 			TEXT				NULL,
	ActivityTurnAroundTime 	INTEGER			NULL,
	AppExecutionFlag 		VARCHAR(1)		NULL,
	AppExecutionValue  		INTEGER			NULL,
 	ExpiryOperator			INTEGER			NULL, 
	TATCalFlag				VARCHAR(1)		NULL,
	ExpCalFlag				VARCHAR(1)		NULL,
	DeleteOnCollect			VARCHAR(1)		NULL,
	Width					INTEGER			NOT NULL DEFAULT 100,
	Height					INTEGER			NOT NULL DEFAULT 50,
	BlockId					INTEGER			NOT NULL DEFAULT 0,
	associatedUrl			VARCHAR(255),
	allowSOAPRequest		VARCHAR(1) NOT NULL DEFAULT N'N' CHECK (allowSOAPRequest IN (N'Y' , N'N')),
	AssociatedActivityId	INTEGER,
	EventId					INTEGER			NULL,
	ActivitySubType			INTEGER 		NULL,
	Color					INTEGER 		NULL,
	Cost					NUMERIC(15,2)	NULL ,
	Duration				VARCHAR(255)	NULL,
	SwimLaneId				INTEGER 		NULL,
	DummyStrColumn1 		VARCHAR(255)	NULL,
	PRIMARY KEY(ProcessDefId, ActivityId)
)

~

/******   RULECONDITIONTABLE    ******/

CREATE TABLE RULECONDITIONTABLE(
	ProcessDefId 	    INTEGER			NOT NULL,
	ActivityId          INTEGER			NOT NULL,
	RuleType            VARCHAR(1)   	NOT NULL,
	RuleOrderId         INTEGER      	NOT NULL,
	RuleId              INTEGER      	NOT NULL,
	ConditionOrderId    INTEGER 		NOT NULL,
	Param1				VARCHAR(50) 	NOT NULL,
	Type1               VARCHAR(1) 		NOT NULL,
	ExtObjId1	    	INTEGER			NULL,
	VariableId_1		INTEGER			NULL,
	VarFieldId_1		INTEGER			NULL,
	Param2				VARCHAR(255) 	NOT NULL,
	Type2               VARCHAR(1) 		NOT NULL,
	ExtObjId2	    	INTEGER			NULL,
	VariableId_2		INTEGER			NULL,
	VarFieldId_2		INTEGER			NULL,
	Operator            INTEGER 		NOT NULL,
	LogicalOp           INTEGER 		NOT NULL 
)

~

/****** RULEOPERATIONTABLE  *****/

CREATE TABLE RULEOPERATIONTABLE(
	ProcessDefId 	 	INTEGER			NOT NULL, 
	ActivityId       	INTEGER       	NOT NULL, 
	RuleType            VARCHAR(1)    	NOT NULL, 
	RuleId              INTEGER       	NOT NULL, 
	OperationType       INTEGER       	NOT NULL, 
	Param1				VARCHAR(50)   	NOT NULL, 
	Type1               VARCHAR(1)    	NOT NULL, 
	ExtObjId1	 		INTEGER			NULL,
	VariableId_1		INTEGER			NULL,
	VarFieldId_1		INTEGER			NULL,
	Param2				VARCHAR(255)  	NOT NULL, 
	Type2               VARCHAR(1)    	NOT NULL, 
	ExtObjId2	  		INTEGER			NULL, 
	VariableId_2		INTEGER			NULL,
	VarFieldId_2		INTEGER			NULL,
	Param3              VARCHAR(255)	NULL, 
	Type3               VARCHAR(1)		NULL, 
	ExtObjId3	   		INTEGER	   		NULL,
	VariableId_3		INTEGER			NULL,
	VarFieldId_3		INTEGER			NULL,
	Operator            INTEGER 		NOT NULL, 
	OperationOrderId    INTEGER       	NOT NULL, 
	CommentFlag         VARCHAR(1)    	NULL, 
	RuleCalFlag			VARCHAR(1)		NULL,
	FunctionType		VARCHAR(1)		NOT NULL	DEFAULT N'L' CHECK (FunctionType IN (N'G' , N'L')),
	PRIMARY KEY(ProcessDefId, ActivityId, RuleType, RuleId,OperationOrderId)
)

~

/******   PROCESSDEFCOMMENTTABLE    ******/

CREATE TABLE PROCESSDEFCOMMENTTABLE(
	ProcessDefId 	INTEGER			NOT NULL,
	LeftPos 		INTEGER			NOT NULL,
	TopPos 			INTEGER			NOT NULL,
	WIdth 			INTEGER			NOT NULL,
	Height 			INTEGER			NOT NULL,
	Type 			VARCHAR(1)		NOT NULL,
	Comments		VARCHAR(255)	NOT NULL,
	SourceId  		INTEGER			NULL,
	TargetId 		INTEGER			NULL,
	RuleId   		INTEGER			NULL,
 	CommentFont             VARCHAR(255) NOT NULL, 
    CommentForeColor        INTEGER	        NOT NULL,
    CommentBackColor        INTEGER	        NOT NULL,
    CommentBorderStyle      INTEGER	        NOT NULL,
	AnnotationId			INTEGER			NULL,
	SwimLaneId				INTEGER			NULL	
)

~

/******   WORKSTAGELINKTABLE    ******/

CREATE TABLE WORKSTAGELINKTABLE(
	ProcessDefId 	INTEGER 	NOT NULL,
	SourceId 		INTEGER 	NOT NULL,
	TargetId 		INTEGER 	NOT NULL,
	Color 			INTEGER		NULL,
	Type 			VARCHAR(1)	NULL,
	ConnectionId	INTEGER		NULL
)

~

/****** VARMAPPINGTABLE   *****/

CREATE TABLE VARMAPPINGTABLE(
	ProcessDefId 		INTEGER 		NOT NULL,
	VariableId			INTEGER			NOT NULL,
	SystemDefinedName	VARCHAR(50) 	NOT NULL,
	UserDefinedName		VARCHAR(50)		NULL,
	VariableType 		INTEGER 		NOT NULL,
	VariableScope 		VARCHAR(1) 		NOT NULL,
	ExtObjId 			INTEGER			NULL ,
	DefaultValue		VARCHAR(255)	NULL ,
	VariableLength  	INTEGER			NULL,
	VarPrecision		INTEGER			NULL,
	Unbounded			VARCHAR(1) 	NOT NULL DEFAULT N'N' CHECK (Unbounded IN (N'Y' , N'N')),
	CONSTRAINT Ck_VarMappin_VarScope CHECK(VariableScope = 'M' OR (VariableScope = 'I' OR (VariableScope = 'U' OR (VariableScope = 'S')))),
	CONSTRAINT Pk_VarMappingTable PRIMARY KEY(ProcessDefId, VariableId)
)

~

/******   ACTIVITYASSOCIATIONTABLE    ******/

CREATE TABLE ACTIVITYASSOCIATIONTABLE(
	ProcessDefId 	INTEGER 		NOT NULL,
	ActivityId 		INTEGER 		NOT NULL,
	DefinitionType 	VARCHAR(1) 		NOT NULL,
	DefinitionId 	INTEGER 		NOT NULL,
	AccessFlag		VARCHAR(3)		NULL,
    FieldName      	VARCHAR(255)	NULL,
    Attribute      	VARCHAR(1)		NULL,
    ExtObjId       	INTEGER			NULL,
	VariableId		INTEGER			NOT NULL,
	PRIMARY KEY(ProcessDefId, ActivityId, DefinitionType, DefinitionId),
	CONSTRAINT Ck_Assoc_Table CHECK(DefinitionType = 'I' OR (DefinitionType = 'Q' OR (DefinitionType = 'N' OR (DefinitionType = 'S' OR (DefinitionType = 'P' OR (DefinitionType = 'T' ))))))
)

~

/******   TRIGGERDEFTABLE    ******/

CREATE TABLE TRIGGERDEFTABLE( 
	ProcessDefId 		INTEGER 		NOT NULL,
	TriggerId 			INTEGER 		NOT NULL,
	TriggerName 		VARCHAR(50) 	NOT NULL,
	TriggerType			VARCHAR(1)		NOT NULL,
	TriggerTypeName		VARCHAR(50)		NULL,	
	Description			VARCHAR(255)	NULL, 
	AssociatedTAId		INTEGER			NULL,
	PRIMARY KEY(ProcessdefId, TriggerId)
)

~

/******   TRIGGERTYPEDEFTABLE    ******/

CREATE TABLE TRIGGERTYPEDEFTABLE( 
	ProcessDefId 		INTEGER 		NOT NULL,
	TypeName			VARCHAR(50)		NOT NULL,
	ClassName			VARCHAR(255)	NOT NULL,
	ExecutableClass		VARCHAR(255)	NULL,
	HttpPath			VARCHAR(255)	NULL,
	PRIMARY KEY(ProcessdefId, TypeName)
)

~

/******   MAILTRIGGERTABLE    ******/

CREATE TABLE MAILTRIGGERTABLE( 
	ProcessDefId 		INTEGER 		NOT NULL,
	TriggerId 			INTEGER 		NOT NULL,
	Subject 			VARCHAR(255) 	NULL,
	FromUser			VARCHAR(255)	NULL,
	FromUserType		VARCHAR(1)		NULL,
	ExtObjIdFromUser 	INTEGER 		NULL,
	VariableIdFrom		INTEGER			NULL,
	VarFieldIdFrom		INTEGER			NULL,
	ToUser				VARCHAR(255)	NOT NULL,
	ToType				VARCHAR(1)		NOT NULL,
	ExtObjIdTo			INTEGER			NULL,
	VariableIdTo		INTEGER			NULL,
	VarFieldIdTo		INTEGER			NULL,
	CCUser				VARCHAR(255)	NULL,
	CCType				VARCHAR(1)		NULL,
	ExtObjIdCC			INTEGER			NULL,	
	VariableIdCc		INTEGER			NULL,
	VarFieldIdCc		INTEGER			NULL,
	Message				TEXT			NULL,
	PRIMARY KEY(ProcessdefId, TriggerId)
)

~

/******   EXECUTETRIGGERTABLE    ******/

CREATE TABLE EXECUTETRIGGERTABLE( 
	ProcessDefId 		INTEGER 		NOT NULL,
	TriggerId 			INTEGER 		NOT NULL,
	FunctionName 		VARCHAR(255) 	NOT NULL,
	ArgList				VARCHAR(255)	NULL,	
	HttpPath			VARCHAR(255)	NULL,	
	PRIMARY KEY(ProcessdefId, TriggerId)
)

~

/******   LAUNCHAPPTRIGGERTABLE    ******/

CREATE TABLE LAUNCHAPPTRIGGERTABLE( 
	ProcessDefId 		INTEGER 		NOT NULL,
	TriggerId 			INTEGER 		NOT NULL,
	ApplicationName 	VARCHAR(255) 	NOT NULL,
	ArgList				VARCHAR(255)	NULL,
	PRIMARY KEY(ProcessdefId, TriggerId)
)

~

/******   DATAENTRYTRIGGERTABLE    ******/

CREATE TABLE DATAENTRYTRIGGERTABLE( 
	ProcessDefId 		INTEGER 		NOT NULL,
	TriggerId 			INTEGER 		NOT NULL,
	VariableName		VARCHAR(255) 	NOT NULL,
	Type				VARCHAR(1)		NOT NULL,
	ExtObjId			INTEGER			NULL,
	VariableId			INTEGER			NULL,
	VarFieldId			INTEGER			NULL,
	PRIMARY KEY (ProcessdefId, TriggerId, VariableName)
)

~

/******   DATASETTRIGGERTABLE    ******/

CREATE TABLE DATASETTRIGGERTABLE( 
	ProcessDefId 	INTEGER 		NOT NULL,
	TriggerId 		INTEGER 		NOT NULL,
	Param1			VARCHAR(50)		NOT NULL,
	Type1			VARCHAR(1)		NOT NULL,
	ExtObjId1		INTEGER			NULL,
	VariableId_1	INTEGER					NULL,
	VarFieldId_1	INTEGER					NULL,
	Param2			VARCHAR(255) 	NOT NULL,
	Type2			VARCHAR(1)		NOT NULL,
	ExtObjId2		INTEGER			NULL,
	VariableId_2	INTEGER					NULL,
	VarFieldId_2	INTEGER					NULL
)

~

/******   STREAMDEFTABLE   ******/

CREATE TABLE STREAMDEFTABLE(
	ProcessDefId 		INTEGER 		NOT NULL,
	StreamId 			INTEGER 		NOT NULL,
	ActivityId 			INTEGER 		NOT NULL,
	StreamName			VARCHAR(30) 	NOT NULL,
	SortType 			VARCHAR(1) 		NOT NULL,
	SortOn				VARCHAR(50) 	NOT NULL,
	StreamCondition		VARCHAR(255) 	NOT NULL,
	CONSTRAINT Pk_StreamDefTable PRIMARY KEY(ProcessDefId, ActivityId, StreamId)
)

~

/******   EXTDBCONFTABLE   ******/

CREATE TABLE EXTDBCONFTABLE(
	ProcessDefId 	INTEGER 		NOT NULL,
	DataBaseName 	VARCHAR(255)	NULL,
	DataBaseType	VARCHAR(20)		NULL,
	UserId 			VARCHAR(255)	NULL, 
	PWD 			VARCHAR(255)	NULL, 
	TableName 		VARCHAR(255)	NULL, 
	ExtObjId 		INTEGER 		NOT NULL,
	HostName  		VARCHAR(255)	NULL,
	Service	 		VARCHAR(255)	NULL,
	Port			INTEGER			NULL,
	SecurityFlag	VARCHAR(1)		CHECK(SecurityFlag IN ('Y', 'N')),
	PRIMARY KEY(ProcessDefId, ExtObjId)
) 

~

/******   RECORDMAPPINGTABLE   ******/

CREATE TABLE RECORDMAPPINGTABLE( 
	ProcessDefId 	INTEGER 		NOT NULL PRIMARY KEY,
	Rec1 			VARCHAR(255)	NULL,
	Rec2 			VARCHAR(255)	NULL,
	Rec3 			VARCHAR(255)	NULL,
	Rec4 			VARCHAR(255)	NULL,
	Rec5 			VARCHAR(255)	NULL 
)

~

/******   STATESDEFTABLE   ******/

CREATE TABLE STATESDEFTABLE( 
	ProcessDefId 	INTEGER 		NOT NULL,
	StateId			INTEGER 		NOT NULL,
	StateName 		VARCHAR(255) 	NOT NULL,
	PRIMARY KEY(ProcessDefId, StateId) 
)

~

/*****   QUEUEHISTORYTABLE   ******/

CREATE TABLE QUEUEHISTORYTABLE(
	ProcessDefId 				INTEGER 		NOT NULL,
	ProcessName 				VARCHAR(30)		NULL,
	ProcessVersion 				INTEGER			NULL,
	ProcessInstanceId			VARCHAR(63)  	NOT NULL,
	ProcessInstanceName			VARCHAR(63)		NULL,
	ActivityId 					INTEGER 		NOT NULL,
	ActivityName				VARCHAR(30)		NULL,
	ParentWorkItemId 			INTEGER			NULL,
	WorkItemId 					INTEGER 		NOT NULL,
	ProcessInstanceState 		INTEGER 		NOT NULL,
	WorkItemState 				INTEGER 		NOT NULL,
	Statename 					VARCHAR(50)		NULL,
	QueueName					VARCHAR (63)	NULL,
	QueueType 					VARCHAR(1)		NULL,
	AssignedUser				VARCHAR(63)		NULL,
	AssignmentType 				VARCHAR(1)		NULL,
	InstrumentStatus 			VARCHAR(1)		NULL,
	CheckListCompleteFlag 		VARCHAR(1)		NULL,
	IntroductionDateTime		TIMESTAMP		NULL,
	CreatedDatetime				TIMESTAMP		NULL,
	Introducedby				VARCHAR(63)		NULL,
	CreatedByName				VARCHAR(63)		NULL,
	EntryDATETIME				TIMESTAMP 		NOT NULL,
	LockStatus 					VARCHAR(1)		NULL,
	HoldStatus 					INTEGER			NULL,
	PriorityLevel 				INTEGER 		NOT NULL,
	LockedByName				VARCHAR(63)		NULL,
	LockedTime					TIMESTAMP		NULL,
	ValIdTill					TIMESTAMP		NULL,
	SaveStage					VARCHAR(30)		NULL,
	PreviousStage				VARCHAR(30)		NULL,
	ExpectedWorkItemDelayTime	TIMESTAMP		NULL,
	ExpectedProcessDelayTime	TIMESTAMP		NULL,
	Status 						VARCHAR(50)		NULL,
	VAR_INT1 					INTEGER			NULL,
	VAR_INT2 					INTEGER			NULL,
	VAR_INT3 					INTEGER			NULL,
	VAR_INT4 					INTEGER			NULL,
	VAR_INT5 					INTEGER			NULL,
	VAR_INT6 					INTEGER			NULL,
	VAR_INT7 					INTEGER			NULL,
	VAR_INT8 					INTEGER			NULL,
	VAR_FLOAT1					NUMERIC(15,2)	NULL,
	VAR_FLOAT2					NUMERIC(15,2)	NULL,
	VAR_DATE1					TIMESTAMP		NULL,
	VAR_DATE2					TIMESTAMP		NULL,
	VAR_DATE3					TIMESTAMP		NULL,
	VAR_DATE4					TIMESTAMP		NULL,
	VAR_LONG1 					INTEGER			NULL,
	VAR_LONG2 					INTEGER			NULL,
	VAR_LONG3 					INTEGER			NULL,
	VAR_LONG4 					INTEGER			NULL,
	VAR_STR1					VARCHAR(255)	NULL,
	VAR_STR2					VARCHAR(255)	NULL,
	VAR_STR3					VARCHAR(255)	NULL,
	VAR_STR4					VARCHAR(255)	NULL,
	VAR_STR5					VARCHAR(255)	NULL,
	VAR_STR6					VARCHAR(255)	NULL,
	VAR_STR7					VARCHAR(255)	NULL,
	VAR_STR8					VARCHAR(255)	NULL,
	VAR_REC_1					VARCHAR(255)	NULL,
	VAR_REC_2					VARCHAR(255)	NULL,
	VAR_REC_3					VARCHAR(255)	NULL,
	VAR_REC_4					VARCHAR(255)	NULL,
	VAR_REC_5					VARCHAR(255)	NULL,
	Q_StreamId 					INTEGER			NULL,
	Q_QueueId 					INTEGER			NULL,
	Q_UserId 					INTEGER			NULL,
	LastProcessedBy 			INTEGER			NULL,
	ProcessedBy					VARCHAR(63)		NULL,
	ReferredTo 					INTEGER			NULL,
	ReferredToName				VARCHAR(63)		NULL,
	ReferredBy 					INTEGER			NULL,
	ReferredByName				VARCHAR(63)		NULL,
	CollectFlag 				VARCHAR(1)		NULL,
	CompletionDatetime			TIMESTAMP		NULL,
	CalendarName                VARCHAR(255)    NULL, 
	ExportStatus	VARCHAR(1) DEFAULT 'N',
	PRIMARY KEY(ProcessInstanceId, WorkItemId)
) 

~

/******   ROUTEPARENTTABLE    ******/

CREATE TABLE ROUTEPARENTTABLE(
	ProcessDefId  		INTEGER 		NOT NULL,
	ParentProcessDefId 	INTEGER 		NOT NULL,
	PRIMARY KEY(ProcessdefId, ParentProcessDefId)
)

~

/******   WFCURRENTROUTELOGTABLE   ******/

CREATE TABLE WFCURRENTROUTELOGTABLE(
	LogId 				SERIAL			PRIMARY KEY,
	ProcessDefId  		INTEGER 		NOT NULL,
	ActivityId 			INTEGER			NULL,
	ProcessInstanceId	VARCHAR(63)		NULL,
	WorkItemId 			INTEGER			NULL,
	UserId 				INTEGER			NULL,
	ActionId 			INTEGER 		NOT NULL,
	ActionDatetime		TIMESTAMP 		NOT NULL CONSTRAINT Ck_DefADT_CurrentRouteLogTable DEFAULT CURRENT_TIMESTAMP(2),
	AssociatedFieldId 	INTEGER			NULL,
	AssociatedFieldName	VARCHAR(255)	NULL,
	ActivityName		VARCHAR(30)		NULL,
	UserName			VARCHAR (63)	NULL,
	NewValue			VARCHAR (2000)	NULL , 
	AssociatedDateTime	TIMESTAMP 		NULL , 
	QueueId				INTEGER			NULL
)

~

/******   WFHISTORYROUTELOGTABLE    ******/

CREATE TABLE WFHISTORYROUTELOGTABLE(
	LogId 				INTEGER  		PRIMARY KEY,
	ProcessDefId  		INTEGER 		NOT NULL,
	ActivityId 			INTEGER			NULL,
	ProcessInstanceId	VARCHAR(63)		NULL,
	WorkItemId 			INTEGER			NULL,
	UserId 				INTEGER			NULL,
	ActionId 			INTEGER 		NOT NULL,
	ActionDatetime		TIMESTAMP 		NOT NULL CONSTRAINT Ck_DefADT_HistoryRouteLogTable DEFAULT CURRENT_TIMESTAMP(2),
	ASsociatedFieldId 	INTEGER			NULL,
	ASsociatedFieldName	VARCHAR(255)	NULL,
	ActivityName		VARCHAR(30)		NULL,
	UserName			VARCHAR(63)		NULL ,
	NewValue			VARCHAR (2000)	NULL ,
	AssociatedDateTime	TIMESTAMP 		NULL , 
	QueueId				INTEGER			NULL
)

~

/******   GENERATERESPONSETABLE  ******/

CREATE TABLE GENERATERESPONSETABLE(
	ProcessDefId		INTEGER			NOT NULL,
	TriggerId           INTEGER			NOT NULL,
	FileName            VARCHAR(255)	NOT NULL,
	ApplicationName     VARCHAR(255)	NOT NULL,
	GenDocType          VARCHAR(255)	NULL,
	PRIMARY KEY(ProcessdefId, TriggerId)
)

~

/******  EXCEPTIONTRIGGERTABLE  ******/

CREATE TABLE EXCEPTIONTRIGGERTABLE(
	ProcessDefId       INTEGER		NOT NULL,
	TriggerId          INTEGER		NOT NULL,
	ExceptionName      VARCHAR(255)	NOT NULL,
	Attribute          VARCHAR(255) NOT NULL,
	RaiseViewComment   VARCHAR(255) NULL,
	ExceptionId        INTEGER      NOT NULL,
	PRIMARY KEY(ProcessdefId, TriggerId)
)

~

/****** TEMPLATEDEFINITIONTABLE  ******/

CREATE TABLE TEMPLATEDEFINITIONTABLE(
	ProcessDefId       INTEGER			NOT NULL,
    TemplateId         INTEGER   		NOT NULL,
    TemplateFileName   VARCHAR(255)  	NOT NULL,
    TemplateBuffer     TEXT				NULL,
	isEncrypted		   VARCHAR(1),
	ArgList            VARCHAR(2000)   NULL,
	Format             VARCHAR(255)    NULL,	
	CONSTRAINT Pk_TEMPLATEDEFINITIONTABLE PRIMARY KEY (ProcessdefId,TemplateId)
 )

~

/****** EXTDBFIELDDEFINITIONTABLE  ******/

CREATE TABLE EXTDBFIELDDEFINITIONTABLE(
	ProcessDefId    INTEGER         NOT NULL,
    FieldName		VARCHAR(50)  	NOT NULL,
    FieldType    	VARCHAR(255)  	NOT NULL,
    FieldLength		INTEGER         NULL, 
	DefaultValue	VARCHAR(255)	NULL,
	Attribute 		VARCHAR(255)	NULL,
	VarPrecision	INTEGER			NULL,
	ExtObjId		INTEGER			NOT NULL,
	PRIMARY KEY	(ProcessDefId,ExtObjId,FieldName)
)

~

/******   QUEUESTREAMTABLE	******/

CREATE TABLE QUEUESTREAMTABLE(
	ProcessDefId 	INTEGER,
	ActivityId 		INTEGER,
	StreamId 		INTEGER,
	QueueId 		INTEGER, 
	CONSTRAINT Pk_QueueStreamTable PRIMARY KEY(ProcessDefId, ActivityId, StreamId)
)

~

/******   QUEUEDEFTABLE ******/

CREATE TABLE QUEUEDEFTABLE(
	QueueId				SERIAL			PRIMARY KEY,
	QueueName			VARCHAR(63) 	NOT NULL,
	QueueType			VARCHAR(1) 		NOT NULL,
	Comments			VARCHAR(255)	NULL,
	AllowReAssignment 	VARCHAR(1),
	FilterOption		INTEGER			NULL,
	FilterValue			VARCHAR(63)		NULL,
	OrderBy				INTEGER			NULL,
	QueueFilter			VARCHAR(2000)	NULL,
	RefreshInterval		INT		NULL, 
    SortOrder       	VARCHAR(1) 		NULL,
	ProcessName			VARCHAR(30)		NULL
) 

~

Insert into QueueDefTable (QueueName, QueueType, Comments, OrderBy, SortOrder)
values ('SystemArchiveQueue', 'A', 'System generated common Archive Queue', 10, 'A')

~

Insert into QueueDefTable (QueueName, QueueType, Comments, OrderBy, SortOrder)
values ('SystemPFEQueue', 'A', 'System generated common PFE Queue', 10, 'A')

~

Insert into QueueDefTable (QueueName, QueueType, Comments, OrderBy, SortOrder)
values ('SystemSharepointQueue', 'A', 'System generated common Sharepoint Queue', 10, 'A')

~

/******   QUEUEUSERTABLE ******/

CREATE TABLE QUEUEUSERTABLE(
	QueueId 				INTEGER 		NOT NULL,
	UserId 					INTEGER 		NOT NULL,
	ASsociationType 		INTEGER 		NOT NULL,
	ASsignedTillDATETIME	TIMESTAMP		NULL, 
	QueryFilter				VARCHAR(2000)	NULL,
	QueryPreview			VARCHAR(1),
	RevisionNo				INTEGER,
	PRIMARY KEY(QueueId, UserId, AssociationType)
)  

~

/******   PSREGISTERATIONTABLE   ******/

CREATE TABLE PSREGISTERATIONTABLE(
	PSId 			SERIAL 			NOT NULL,
	PSName			VARCHAR(63) 	NOT NULL,
	Type			VARCHAR(1) 		NOT NULL DEFAULT 'P' CHECK(Type = 'C' OR Type = 'P'),
	SessionId 		INTEGER			NULL,
	ProcessdefId 	INTEGER			NULL,
	data			VARCHAR(2000)	NULL,
	CONSTRAINT Uk_PSRegisterationTable UNIQUE(SessionId),
	PRIMARY KEY(PSName, Type)
)

~

/******   USERDIVERSIONTABLE    ******/

CREATE TABLE USERDIVERSIONTABLE( 
	DivertedUserIndex 		INTEGER, 
	DivertedUserName		VARCHAR(64), 
	AssignedUserindex 		INTEGER, 
	AssignedUserName		VARCHAR(64), 
	FromDate				TIMESTAMP, 
	ToDate					TIMESTAMP, 
	CurrentWorkItemsFlag 	VARCHAR(1) CHECK(CurrentWorkItemsFlag  IN ('Y', 'N')),
	CONSTRAINT Pk_UserDiversion PRIMARY KEY(DivertedUserIndex, AssignedUserIndex, FromDate) 
)

~

/******   USERWORKAUDITTABLE    ******/

CREATE TABLE USERWORKAUDITTABLE( 
	Userindex			INTEGER, 
	Auditoruserindex 	INTEGER, 
	Percentageaudit 	INTEGER ,
	AuditActivityId		INTEGER, 
	WorkItemCount		VARCHAR(100),
	ProcessDefId		INTEGER,
	CONSTRAINT Pk_UserWrkAudit PRIMARY KEY(UserIndex, AuditorUserIndex, AuditActivityId, ProcessDefId)
)

~

/******   PREFERREDQUEUETABLE    ******/

CREATE TABLE PREFERREDQUEUETABLE( 
	userindex 		INTEGER, 
	queueindex 		INTEGER,
	CONSTRAINT Pk_PreferredQueueTable PRIMARY KEY(userIndex, queueIndex) 
)

~

/******   USERPREFERENCESTABLE     ******/

CREATE TABLE USERPREFERENCESTABLE(
	UserId 				INTEGER,
	ObjectId 			INTEGER,
	ObjectName 			VARCHAR(255),
	ObjectType 			VARCHAR(30),
	NotifyByEmail 		VARCHAR(1),
	Data				TEXT,	
	CONSTRAINT Pk_UserPrefencesTable PRIMARY KEY(UserId, ObjectId,	ObjectType),
	CONSTRAINT Uk_UserPrefencesTable UNIQUE (UserId, Objectname, ObjectType)
)

~

/******   WFLINKSTABLE     ******/

CREATE TABLE WFLINKSTABLE(
	ChildProcessInstanceId 		VARCHAR(63) 	NOT NULL,
	ParentProcessInstanceId		VARCHAR(63) 	NOT NULL,
	PRIMARY KEY(ChildProcessInstanceId, ParentProcessInstanceId)
) 

~

/******   VARALIASTABLE     ******/

CREATE TABLE VARALIASTABLE(
 	Id				SERIAL			NOT NULL,	
	AliAS   		VARCHAR(63) 	NOT NULL,
 	ToReturn  		VARCHAR(1)  	NOT NULL CHECK (ToReturn IN ('Y','N')),
 	Param1  		VARCHAR(50)  	NOT NULL,
 	Type1  			VARCHAR(1)   	NULL,
 	Param2 			VARCHAR(255)  	NULL,
 	Type2 			VARCHAR(1)   	NULL CHECK (Type2 IN ('V','C')),
 	Operator 		INTEGER   		NULL, 
	QueueId			INTEGER			NOT NULL,
	ProcessDefId	INTEGER		NOT NULL DEFAULT 0,
    AliasRule       VARCHAR(2000)      NULL,
	PRIMARY KEY (QueueId, Alias, ProcessDefId)
) 

~

/******  INITIATEWORKITEMDEFTABLE     ******/

CREATE TABLE INITIATEWORKITEMDEFTABLE( 
	ProcessDefId 		INTEGER				NOT NULL,
	ActivityId			INTEGER				NOT NULL,
	ImportedProcessName VARCHAR(30)			NOT NULL,
	ImportedFieldName 	VARCHAR(63)			NOT NULL,
	ImportedVariableId	INTEGER				NULL,
	ImportedVarFieldId	INTEGER				NULL,
	MappedFieldName		VARCHAR(63)			NOT NULL,	
	MappedVariableId	INTEGER 			NULL,
	MappedVarFieldId	INTEGER				NULL,
	FieldType			VARCHAR(1)			NOT NULL,
	MapType				VARCHAR(1)			NULL,
	DisplayName			VARCHAR(2000)		NULL,
	ImportedProcessDefId	INTEGER				NULL
) 

~

/******  IMPORTEDPROCESSDEFTABLE     ******/

CREATE TABLE IMPORTEDPROCESSDEFTABLE(
	ProcessDefId 			INTEGER 			NOT NULL,
	ActivityId				INTEGER				NOT NULL,
	ImportedProcessName 	VARCHAR(30)			NOT NULL,
	ImportedFieldName 		VARCHAR(63)			NOT NULL,
	FieldDataType			INTEGER				NULL,	
	FieldType				VARCHAR(1)			NOT NULL,
	VariableId				INTEGER				NULL,
	VarFieldId				INTEGER				NULL,
	DisplayName				VARCHAR(2000)		NULL,
	ImportedProcessDefId	INTEGER				NULL,
	ProcessType				VARCHAR(1)			NULL   DEFAULT ('R')	
) 

~

/******	  WFREMINDERTABLE    ******/

CREATE TABLE WFREMINDERTABLE(
 	RemIndex 			SERIAL			PRIMARY KEY,
 	ToIndex 			INTEGER 		NOT NULL,
 	ToType 				VARCHAR(1) 		NOT NULL DEFAULT ('U'),
 	ProcessInstanceId 	VARCHAR(63) 	NOT NULL,
	WorkitemId 			INTEGER 		NULL,
 	RemDateTime 		TIMESTAMP 		NOT NULL,
 	RemComment 			VARCHAR(255)	NULL,
 	SetByUser 			INTEGER 		NOT NULL,
 	InformMode 			VARCHAR(1) 		NULL DEFAULT ('P'),
 	ReminderType 		VARCHAR(1) 		NULL DEFAULT ('U'),
 	MailFlag 			VARCHAR(1) 		NULL DEFAULT ('N'),
 	FaxFlag 			VARCHAR(1) 		NULL DEFAULT ('N')
) 

~

/*********** PROCESSINSTANCETABLE ****************/

CREATE TABLE PROCESSINSTANCETABLE(
	ProcessInstanceId		VARCHAR (63)  	NOT NULL,
	ProcessDefId 			INTEGER 		NOT NULL,
	Createdby 				INTEGER 		NOT NULL,
	CreatedByName			VARCHAR(63)		NULL,
	CreatedDatetime			TIMESTAMP 		NOT NULL,
	IntroducedById 			INTEGER			NULL,
	Introducedby			VARCHAR(63)		NULL,
	IntroductionDateTime	TIMESTAMP		NULL,
	ProcessInstanceState 	INTEGER			NULL,
	ExpectedProcessDelay    TIMESTAMP		NULL,
	IntroducedAt			VARCHAR(30)		NOT NULL,
	CONSTRAINT Pk_ProcessInstanceTable PRIMARY KEY(ProcessInstanceId)
) 

~

/***********  QUEUEDATATABLE ****************/

CREATE TABLE QUEUEDATATABLE(
	ProcessInstanceId		VARCHAR(63)		NOT NULL,
	WorkItemId 				INTEGER 		NOT NULL,
	VAR_INT1 				INTEGER			NULL,
	VAR_INT2 				INTEGER			NULL,
	VAR_INT3 				INTEGER			NULL,
	VAR_INT4 				INTEGER			NULL,
	VAR_INT5 				INTEGER			NULL,
	VAR_INT6 				INTEGER			NULL,
	VAR_INT7 				INTEGER			NULL,
	VAR_INT8 				INTEGER			NULL,
	VAR_FLOAT1				NUMERIC(15, 2)	NULL,
	VAR_FLOAT2				NUMERIC(15, 2)	NULL,
	VAR_DATE1				TIMESTAMP		NULL,
	VAR_DATE2				TIMESTAMP		NULL,
	VAR_DATE3				TIMESTAMP		NULL,
	VAR_DATE4				TIMESTAMP		NULL,
	VAR_LONG1 				INTEGER			NULL,
	VAR_LONG2 				INTEGER			NULL,
	VAR_LONG3 				INTEGER			NULL,
	VAR_LONG4 				INTEGER			NULL,
	VAR_STR1				VARCHAR(255)	NULL,
	VAR_STR2				VARCHAR(255)	NULL,
	VAR_STR3				VARCHAR(255)	NULL,
	VAR_STR4				VARCHAR(255)	NULL,
	VAR_STR5				VARCHAR(255)	NULL,
	VAR_STR6				VARCHAR(255)	NULL,
	VAR_STR7				VARCHAR(255)	NULL,
	VAR_STR8				VARCHAR(255)	NULL,
	VAR_REC_1				VARCHAR(255)	NULL,
	VAR_REC_2				VARCHAR(255)	NULL,
	VAR_REC_3				VARCHAR(255)	NULL,
	VAR_REC_4				VARCHAR(255)	NULL,
	VAR_REC_5				VARCHAR(255)	NULL,
	InstrumentStatus 		VARCHAR(1)		NULL, 
	CheckListCompleteFlag 	VARCHAR(1)		NULL,
	SaveStage				VARCHAR(30)		NULL,
	HoldStatus 				INTEGER			NULL,	
	Status					VARCHAR(255)	NULL,
	ReferredTo 				INTEGER			NULL,
	ReferredToName			VARCHAR(63)		NULL,
	ReferredBy 				INTEGER			NULL,
	ReferredByName			VARCHAR(63)		NULL,
	ChildProcessInstanceId	VARCHAR(63)		NULL,
	ChildWorkitemId 		INTEGER			NULL,
	ParentWorkItemId 		INTEGER,	
	CalendarName            VARCHAR(255)    NULL,
	CONSTRAINT Pk_QueueDataTable PRIMARY KEY(ProcessInstanceId, WorkitemId)
)

~

/***********   WORKLISTTABLE  ****************/

CREATE TABLE WORKLISTTABLE(
	ProcessInstanceId		VARCHAR (63) 	NOT NULL,
	WorkItemId				INTEGER 		NOT NULL,
	ProcessName 			VARCHAR(30) 	NOT NULL,
	ProcessVersion  		INTEGER,
	ProcessDefId 			INTEGER 		NOT NULL,
	LastProcessedBy 		INTEGER			NULL,
	ProcessedBy				VARCHAR(63)		NULL,	
	ActivityName 			VARCHAR(30)		NULL,
	ActivityId 				INTEGER			NULL,
	EntryDateTime 			TIMESTAMP		NULL,
	ParentWorkItemId		INTEGER			NULL,	
	AssignmentType			VARCHAR(1)		NULL,
	CollectFlag				VARCHAR(1)		NULL,
	PriorityLevel			INTEGER			NULL,
	ValIdTill				TIMESTAMP		NULL,
	Q_StreamId				INTEGER			NULL,
	Q_QueueId				INTEGER			NULL,
	Q_UserId				INTEGER			NULL,
	AssignedUser			VARCHAR(63)		NULL,	
	FilterValue				INTEGER			NULL,
	CreatedDatetime			TIMESTAMP		NULL,
	WorkItemState			INTEGER			NULL,
	Statename 				VARCHAR(255),
	ExpectedWorkitemDelay	TIMESTAMP		NULL,
	PreviousStage			VARCHAR(30)		NULL,
	LockedByName			VARCHAR(63)		NULL,	
	LockStatus				VARCHAR(1)   	NOT NULL Default 'N',
	LockedTime				TIMESTAMP		NULL, 
	Queuename 				VARCHAR(63),
	Queuetype 				VARCHAR(1),
	NotifyStatus			VARCHAR(1),
	CONSTRAINT Pk_WorkListTable PRIMARY KEY(ProcessInstanceId, WorkitemId)
) 

~

/***********  WORKINPROCESSTABLE  ****************/

CREATE TABLE WORKINPROCESSTABLE(
	ProcessInstanceId		VARCHAR (63) 	NOT NULL,
	WorkItemId				INTEGER 		NOT NULL,
	ProcessName 			VARCHAR(30) 	NOT NULL,
	ProcessVersion   		INTEGER,
	ProcessDefId 			INTEGER 		NOT NULL,
	LastProcessedBy 		INTEGER			NULL,
	ProcessedBy				VARCHAR(63)		NULL,	
	ActivityName 			VARCHAR(30)		NULL,
	ActivityId 				INTEGER			NULL,
	EntryDateTime 			TIMESTAMP		NULL,
	ParentWorkItemId		INTEGER			NULL,	
	AssignmentType			VARCHAR(1)		NULL,
	CollectFlag				VARCHAR(1)		NULL,
	PriorityLevel			INTEGER			NULL,
	ValIdTill				TIMESTAMP		NULL,
	Q_StreamId				INTEGER			NULL,
	Q_QueueId				INTEGER			NULL,
	Q_UserId				INTEGER			NULL,
	AssignedUser			VARCHAR(63)		NULL,	
	FilterValue				INTEGER			NULL,
	CreatedDatetime			TIMESTAMP		NULL,
	WorkItemState			INTEGER			NULL,
	Statename 				VARCHAR(255),
	ExpectedWorkitemDelay	TIMESTAMP		NULL,
	PreviousStage			VARCHAR(30)		NULL,
	LockedByName			VARCHAR(63)		NULL,	
	LockStatus				VARCHAR(1)		Default 'Y' NOT NULL,
	LockedTime				TIMESTAMP		NULL, 
	Queuename 				VARCHAR(63),
	Queuetype 				VARCHAR(1),
	NotifyStatus			VARCHAR(1),
	GuId 					BIGINT, 
	CONSTRAINT Pl_WorkInProcessTable PRIMARY KEY(ProcessInstanceId, WorkitemId)
) 

~

/***********	WORKDONETABLE	****************/

CREATE TABLE WORKDONETABLE(
	ProcessInstanceId		VARCHAR (63) 	NOT NULL,
	WorkItemId				INTEGER 		NOT NULL,
	ProcessName 			VARCHAR(30) 	NOT NULL,
	ProcessVersion   		INTEGER,
	ProcessDefId 			INTEGER 		NOT NULL,
	LastProcessedBy 		INTEGER			NULL,
	ProcessedBy				VARCHAR(63)		NULL,	
	ActivityName 			VARCHAR(30)		NULL,
	ActivityId 				INTEGER			NULL,
	EntryDateTime 			TIMESTAMP		NULL,
	ParentWorkItemId		INTEGER			NULL,	
	AssignmentType			VARCHAR(1)		NULL,
	CollectFlag				VARCHAR(1)		NULL,
	PriorityLevel			INTEGER			NULL,
	ValIdTill				TIMESTAMP		NULL,
	Q_StreamId				INTEGER			NULL,
	Q_QueueId				INTEGER			NULL,
	Q_UserId				INTEGER			NULL,
	AssignedUser			VARCHAR(63)		NULL,	
	FilterValue				INTEGER			NULL,
	CreatedDatetime			TIMESTAMP		NULL,
	WorkItemState			INTEGER			NULL,
	Statename 				VARCHAR(255),
	ExpectedWorkitemDelay	TIMESTAMP		NULL,
	PreviousStage			VARCHAR(30)		NULL,
	LockedByName			VARCHAR(63)		NULL,	
	LockStatus				VARCHAR(1) 		NOT NULL Default 'N',
	LockedTime				TIMESTAMP		NULL, 
	Queuename 				VARCHAR(63),
	Queuetype 				VARCHAR(1),
	NotifyStatus			VARCHAR(1), 
	CONSTRAINT Pk_WorkDoneTable PRIMARY KEY(ProcessInstanceId, WorkitemId)
) 

~

/***********	WORKWITHPSTABLE	   ****************/

CREATE TABLE WORKWITHPSTABLE(
	ProcessInstanceId		VARCHAR (63) 	NOT NULL,
	WorkItemId				INTEGER 		NOT NULL ,
	ProcessName 			VARCHAR(30) 	NOT NULL ,
	ProcessVersion   		INTEGER,
	ProcessDefId 			INTEGER 		NOT NULL,
	LastProcessedBy 		INTEGER			NULL,
	ProcessedBy				VARCHAR(63)		NULL,	
	ActivityName 			VARCHAR(30)		NULL,
	ActivityId 				INTEGER			NULL,
	EntryDateTime 			TIMESTAMP		NULL,
	ParentWorkItemId		INTEGER			NULL,	
	AssignmentType			VARCHAR(1)		NULL,
	CollectFlag				VARCHAR(1)		NULL,
	PriorityLevel			INTEGER		NULL,
	ValIdTill				TIMESTAMP		NULL,
	Q_StreamId				INTEGER			NULL,
	Q_QueueId				INTEGER			NULL,
	Q_UserId				INTEGER		NULL,
	AssignedUser			VARCHAR(63)		NULL,	
	FilterValue				INTEGER			NULL,
	CreatedDatetime			TIMESTAMP		NULL,
	WorkItemState			INTEGER			NULL,
	Statename 				VARCHAR(255),
	ExpectedWorkitemDelay	TIMESTAMP		NULL,
	PreviousStage			VARCHAR(30)		NULL,
	LockedByName			VARCHAR(63)		NULL,	
	LockStatus				VARCHAR(1) 		NOT NULL Default 'Y',
	LockedTime				TIMESTAMP		NULL, 
	Queuename 				VARCHAR(63),
	Queuetype 				VARCHAR(1),
	NotifyStatus			VARCHAR(1), 
	GuId 					BIGINT, 
	CONSTRAINT Pk_WorkWithPSTable PRIMARY KEY(ProcessInstanceId, WorkitemId)
) 

~

/***********	 PENDINGWORKLISTTABLE	****************/

CREATE TABLE PENDINGWORKLISTTABLE(
	ProcessInstanceId		VARCHAR (63) 	NOT NULL,
	WorkItemId				INTEGER 		NOT NULL,
	ProcessName 			VARCHAR(30) 	NOT NULL,
	ProcessVersion   		INTEGER,
	ProcessDefId 			INTEGER 		NOT NULL,
	LastProcessedBy 		INTEGER			NULL,
	ProcessedBy				VARCHAR(63)		NULL,	
	ActivityName 			VARCHAR(30)		NULL,
	ActivityId 				INTEGER			NULL,
	EntryDateTime 			TIMESTAMP		NULL,
	ParentWorkItemId		INTEGER			NULL,	
	AssignmentType			VARCHAR(1)		NULL,
	CollectFlag				VARCHAR(1)		NULL,
	PriorityLevel			INTEGER			NULL,
	ValIdTill				TIMESTAMP		NULL,
	Q_StreamId				INTEGER			NULL,
	Q_QueueId				INTEGER			NULL,
	Q_UserId				INTEGER			NULL,
	AssignedUser			VARCHAR(63)		NULL,	
	FilterValue				INTEGER			NULL,
	CreatedDatetime			TIMESTAMP		NULL,
	WorkItemState			INTEGER			NULL,
	Statename 				VARCHAR(255),
	ExpectedWorkitemDelay	TIMESTAMP		NULL,
	PreviousStage			VARCHAR(30)		NULL,
	LockedByName			VARCHAR(63)		NULL,	
	LockStatus				VARCHAR(1)		NULL,
	LockedTime				TIMESTAMP		NULL, 
	Queuename 				VARCHAR(63),
	Queuetype 				VARCHAR(1),
	NotifyStatus			VARCHAR(1),
	NoOfCollectedInstances	INT		NOT NULL DEFAULT 0,
	IsPrimaryCollected	VARCHAR(1)	NULL	CHECK (IsPrimaryCollected IN (N'Y', N'N')),
	ExportStatus	VARCHAR(1) DEFAULT 'N',
	CONSTRAINT Pk_PendingWorklistTable PRIMARY KEY(ProcessInstanceId, WorkitemId)
) 

~

/***********	USERQUEUETABLE	****************/

CREATE TABLE USERQUEUETABLE
(
	UserId 			INTEGER		NOT NULL,
	QueueId 		INTEGER 	NOT NULL,
	ConstraINT Pk_UserQueueTable PRIMARY KEY(UserId, QueueId)	
)

~

/***********	WFMAILQUEUETABLE	****************/

CREATE TABLE WFMAILQUEUETABLE(
	TaskId 				SERIAL			PRIMARY KEY,
	mailFrom 			VARCHAR(255),
	mailTo 				VARCHAR(512), 
	mailCC 				VARCHAR(512), 
	mailBCC 			VARCHAR(512), 
	mailSubject 		VARCHAR(512),
	mailMessage			TEXT,
	mailContentType		VARCHAR(64),
	attachmentISINDEX 	VARCHAR(255),
	attachmentNames		VARCHAR(512), 
	attachmentExts		VARCHAR(128),	
	mailPriority		INTEGER, 
	mailStatus			VARCHAR(1),
	statusComments		VARCHAR(512),
	lockedBy			VARCHAR(255),
	successTime			TIMESTAMP,
	LastLockTime		TIMESTAMP,
	insertedBy			VARCHAR(255),
	mailActionType		VARCHAR(20),
	insertedTime		TIMESTAMP,
	processDefId		INTEGER,
	processInstanceId	VARCHAR(63),
	workitemId			INTEGER,
	activityId			INTEGER,
	noOfTrials			INTEGER	DEFAULT 0,
	zipFlag 			varchar(1)		NULL,
	zipName 			varchar(255)	NULL,
	maxZipSize 			INTEGER				NULL,
	alternateMessage 	TEXT			NULL	
)

~

/***********	WFMAILQUEUEHISTORYTABLE		****************/

CREATE TABLE WFMAILQUEUEHISTORYTABLE(
	TaskId 				INTEGER			PRIMARY KEY,
	mailFrom 			VARCHAR(255),
	mailTo 				VARCHAR(512), 
	mailCC 				VARCHAR(512), 
	mailBCC 			VARCHAR(512), 
	mailSubject 		VARCHAR(512),
	mailMessage			TEXT,
	mailContentType		VARCHAR(64),
	attachmentISINDEX 	VARCHAR(255), 
	attachmentNames		VARCHAR(512), 
	attachmentExts		VARCHAR(128),	
	mailPriority		INTEGER, 
	mailStatus			VARCHAR(1),
	statusComments		VARCHAR(512),
	lockedBy			VARCHAR(255),
	successTime			TIMESTAMP,
	LastLockTime		TIMESTAMP,
	insertedBy			VARCHAR(255),
	mailActionType		VARCHAR(20),
	insertedTime		TIMESTAMP,
	processDefId		INTEGER,
	processInstanceId	VARCHAR(63),
	workitemId			INTEGER,
	activityId			INTEGER,
	noOfTrials			INTEGER	DEFAULT 0
)

~

/***********	ACTIONDEFTABLE	****************/

CREATE TABLE ACTIONDEFTABLE(
	ProcessDefId	INTEGER        NOT NULL,
	ActionId        INTEGER        NOT NULL,
	ActionName      VARCHAR(50)    NOT NULL,
	ViewAS          VARCHAR(50)    NULL,
	IconBuffer      TEXT			   NULL,
	ActivityId      INTEGER        NOT NULL,
	isEncrypted		VARCHAR(1),
	CONSTRAINT PK_ACTIONDEFTABLE PRIMARY KEY(ProcessDefId,ActionId,ActivityId)
)

~

/***********	ACTIONCONDITIONTABLE	****************/

CREATE TABLE ACTIONCONDITIONTABLE(
	ProcessDefId            INTEGER			NOT NULL,
	ActivityId              INTEGER			NOT NULL,
	RuleType				VARCHAR(1)		NOT NULL,
	RuleOrderId				INTEGER			NOT NULL,
	RuleId					INTEGER			NOT NULL,
	ConditionOrderId		INTEGER			NOT NULL,
	Param1					VARCHAR(50)		NOT NULL,
	Type1					VARCHAR(1)		NOT NULL,
	ExtObjId1				INTEGER			NULL,
	VariableId_1			INTEGER			NULL,
	VarFieldId_1			INTEGER			NULL,
	Param2					VARCHAR(255)	NOT NULL,
	Type2					VARCHAR(1)      NOT NULL,
	ExtObjId2				INTEGER			NULL,
	VariableId_2			INTEGER			NULL,
	VarFieldId_2			INTEGER			NULL,
	Operator				INTEGER         NOT NULL,
	LogicalOp				INTEGER         NOT NULL
)

~

/***********	ACTIONOPERATIONTABLE	****************/

CREATE TABLE ACTIONOPERATIONTABLE(
	ProcessDefId		INTEGER			NOT NULL,
	ActivityId			INTEGER			NOT NULL,
	RuleType			VARCHAR(1)		NOT NULL,
	RuleId				INTEGER			NOT NULL,
	OperationType		INTEGER			NOT NULL,
	Param1				VARCHAR(50)		NULL,
	Type1				VARCHAR(1)		NOT NULL,
	Param2				VARCHAR(255)	NULL,
	Type2				VARCHAR(1)		NOT NULL,
	Param3				VARCHAR(255)	NULL,
	Type3				VARCHAR(1)		NULL,
	Operator			INTEGER			NULL,
	OperationOrderId	INTEGER         NOT NULL,
	CommentFlag			VARCHAR(1)		NOT NULL,
	ExtObjId1			INTEGER			NULL,
	ExtObjId2			INTEGER			NULL,
	ExtObjId3			INTEGER			NULL,
	ActionCalFlag		VARCHAR(1)		NULL,
	VariableId_1		INTEGER			NULL,
	VarFieldId_1		INTEGER			NULL,
	VariableId_2		INTEGER			NULL,
	VarFieldId_2		INTEGER			NULL,
	VariableId_3		INTEGER			NULL,
	VarFieldId_3		INTEGER			NULL
)

~

/***********	ACTIVITYINTERFACEASSOCTABLE	****************/

CREATE TABLE ACTIVITYINTERFACEASSOCTABLE(
	ProcessDefId            INTEGER			NOT NULL,
	ActivityId              INTEGER         NOT NULL,
	ActivityName            VARCHAR(30)		NOT NULL,
	InterfaceElementId      INTEGER         NOT NULL,
	InterfaceType           VARCHAR(1)		NOT NULL,
	Attribute               VARCHAR(2)		NULL,
	TriggerName             VARCHAR(255)	NULL
)

~

/***********	ARCHIVETABLE	****************/

CREATE TABLE ARCHIVETABLE(
	ProcessDefId            INTEGER         NOT NULL,
	ActivityId              INTEGER         NOT NULL,
	CabinetName             VARCHAR(255)	NOT NULL,
	IPAddress               VARCHAR(15)		NOT NULL,
	PortId                  VARCHAR(5)		NOT NULL,
	ArchiveAs               VARCHAR(255)	NOT NULL,
	UserId                  VARCHAR(50)		NOT NULL,
	Passwd                  VARCHAR(256)	NULL,
	ArchiveDataClassId      INTEGER         NULL,
	AppServerIP				VARCHAR(15)		NULL,
	AppServerPort			VARCHAR(5)		NULL,
	AppServerType			VARCHAR(255)	NULL,
	ArchiveDataClassName    VARCHAR(255)	NULL,
	SecurityFlag			VARCHAR(1)		CHECK(SecurityFlag IN ('Y', 'N'))
)

~

/***********	ARCHIVEDATAMAPTABLE	****************/

CREATE TABLE ARCHIVEDATAMAPTABLE(
	ProcessDefId            INTEGER			NOT NULL,
	ArchiveId               INTEGER			NOT NULL,
	DocTypeId               INTEGER			NOT NULL,
	DataFieldId             INTEGER			NOT NULL,
	DataFieldName           VARCHAR(50)		NOT NULL,
	AssocVar                VARCHAR(255)	NULL,
	ExtObjId                INTEGER			NULL,
	VariableId				INTEGER			NULL,
	VarFieldId				INTEGER			NULL
)

~

/***********	ARCHIVEDOCTYPETABLE	****************/

CREATE TABLE ARCHIVEDOCTYPETABLE(
	ProcessDefId            INTEGER			NOT NULL,
	ArchiveId               INTEGER			NOT NULL,
	DocTypeId               INTEGER			NOT NULL,
	AssocClassName          VARCHAR(255)	NULL,
	AssocClassId            INTEGER			NULL
)

~

/***********	SCANACTIONSTABLE	****************/

CREATE TABLE SCANACTIONSTABLE(
	ProcessDefId		INTEGER         NOT NULL,
	DocTypeId			INTEGER         NOT NULL,
	ActivityId			INTEGER         NOT NULL,
	Param1				VARCHAR(50)		NOT NULL,
	Type1				VARCHAR(1)		NOT NULL,
	ExtObjId1			INTEGER         NOT NULL,
	VariableId_1		INTEGER					NULL,
	VarFieldId_1		INTEGER					NULL,
	Param2				VARCHAR(255)	NOT NULL,
	Type2				VARCHAR(1)		NOT NULL,
	ExtObjId2			INTEGER			NOT NULL,
	VariableId_2		INTEGER					NULL,
	VarFieldId_2		INTEGER					NULL
)

~

/***********	CHECKOUTPROCESSESTABLE	****************/

CREATE TABLE CHECKOUTPROCESSESTABLE( 
	ProcessDefId            INTEGER			NOT NULL,
	ProcessName             VARCHAR(30)		NOT NULL, 
	CheckOutIPAddress       VARCHAR(50)		NOT NULL, 
	CheckOutPath            VARCHAR(255)	NOT NULL,
	ProcessStatus			VARCHAR(1)		NULL,
	ActivityId				INTEGER			NULL,
	SwimlaneId				INTEGER			NULL,
	UserId					INTEGER			NULL
)

~

/***********	TODOLISTDEFTABLE	****************/

CREATE TABLE TODOLISTDEFTABLE(
	ProcessDefId		INTEGER			NOT NULL,
	ToDoId				INTEGER			NOT NULL,
	ToDoName			VARCHAR(255)	NOT NULL,
	Description			VARCHAR(255)	NOT NULL,
	Mandatory			VARCHAR(1)		NOT NULL,
	ViewType			VARCHAR(1)		NULL,
	AssociatedField		VARCHAR(255)	NULL,
	ExtObjId			INTEGER			NULL,
	VariableId			INTEGER			NULL,
	VarFieldId			INTEGER			NULL,
	TriggerName			VARCHAR(50)		NULL,
	PRIMARY KEY (ProcessDefId, ToDoId)
)

~

/***********	TODOPICKLISTTABLE	****************/

CREATE TABLE TODOPICKLISTTABLE(
	ProcessDefId	INTEGER		NOT NULL,
	ToDoId			INTEGER		NOT NULL,
	PickListValue	VARCHAR(50)	NOT NULL,
	CONSTRAINT PK_TODOPICKLISTTABLE PRIMARY KEY(ProcessDefId,ToDoId,PickListValue)
)

~

/***********	TODOSTATUSTABLE	****************/

CREATE TABLE TODOSTATUSTABLE(
	ProcessDefId		INTEGER         NOT NULL,
	ProcessInstanceId	VARCHAR(63)     NOT NULL,
	ToDoValue			VARCHAR(255)    NULL
)

~

/***********	TODOSTATUSHISTORYTABLE	****************/

CREATE TABLE TODOSTATUSHISTORYTABLE(
	ProcessDefId		INTEGER        NOT NULL,
	ProcessInstanceId	VARCHAR(63)    NOT NULL,
	ToDoValue			VARCHAR(255)   NULL
)

~

/***********	EXCEPTIONDEFTABLE	****************/

CREATE TABLE EXCEPTIONDEFTABLE(
	ProcessDefId		INTEGER        NOT NULL,
	ExceptionId         INTEGER        NOT NULL,
	ExceptionName       VARCHAR(50)    NOT NULL,
	Description         VARCHAR(255)   NOT NULL,
	PRIMARY KEY (ProcessDefId, ExceptionId)
)

~

/***********	EXCEPTIONTABLE	****************/

CREATE TABLE EXCEPTIONTABLE(
	ProcessDefId            INTEGER         NOT NULL,
	ExcpSeqId               INTEGER         NOT NULL,
	WorkitemId              INTEGER         NOT NULL,
	ActivityId              INTEGER         NOT NULL,
	ActivityName            VARCHAR(30)		NOT NULL,
	ProcessInstanceId       VARCHAR(63)		NOT NULL,
	UserId                  INTEGER        NOT NULL,
	UserName                VARCHAR(63)		NOT NULL,
	ActionId                INTEGER         NOT NULL,
	ActionDatetime          TIMESTAMP       NOT NULL  CONSTRAINT Ck_DefADT_ExceptionTable DEFAULT CURRENT_TIMESTAMP(2),
	ExceptionId             INTEGER         NOT NULL,
	ExceptionName           VARCHAR(50)		NOT NULL,
	FinalizationStatus      VARCHAR(1)		NOT NULL CONSTRAINT DF_EXCPFS DEFAULT ('T'),
	ExceptionComments       VARCHAR(512)	NULL
)

~

/***********	EXCEPTIONHISTORYTABLE	****************/

CREATE TABLE EXCEPTIONHISTORYTABLE(
	ProcessDefId            INTEGER         NOT NULL,
	ExcpSeqId               INTEGER         NOT NULL,
	WorkitemId              INTEGER         NOT NULL,
	ActivityId              INTEGER         NOT NULL,
	ActivityName			VARCHAR(30)		NOT NULL,
	ProcessInstanceId       VARCHAR(63)		NOT NULL,
	UserId                  INTEGER        NOT NULL,
	UserName                VARCHAR(63)		NOT NULL,
	ActionId                INTEGER         NOT NULL,
	ActionDatetime          TIMESTAMP       NOT NULL  CONSTRAINT Ck_DefADT_ExceptionHistoryTable DEFAULT CURRENT_TIMESTAMP(2),
	ExceptionId             INTEGER         NOT NULL,
	ExceptionName           VARCHAR(50)		NOT NULL,
	FinalizationStatus      VARCHAR(1)		NOT NULL CONSTRAINT DF_EXCPHTFS DEFAULT ('T'),
	ExceptionComments       VARCHAR(512)	NULL
)

~

/***********	DOCUMENTTYPEDEFTABLE	****************/

CREATE TABLE DOCUMENTTYPEDEFTABLE(
	ProcessDefId	INTEGER			NOT NULL,
	DocId			INTEGER			NOT NULL,
	DocName			VARCHAR(50)		NOT NULL,
	DCName 			VARCHAR(64)		NULL,
	PRIMARY KEY (ProcessDefId, DocId)
)

~

/***********	PROCESSINITABLE	****************/

CREATE TABLE PROCESSINITABLE(
	ProcessDefId	INTEGER		NOT NULL,
	ProcessINI		TEXT			NULL,
	CONSTRAINT PK_ProcessINITable PRIMARY KEY(ProcessDefId)
)

~

/***********	ROUTEFOLDERDEFTABLE	****************/

CREATE TABLE ROUTEFOLDERDEFTABLE(
	ProcessDefId            INTEGER         PRIMARY KEY,
	CabinetName             VARCHAR(50)		NOT NULL,
	RouteFolderId           INTEGER         NOT NULL,
	ScratchFolderId         INTEGER         NOT NULL,
	WorkFlowFolderId        INTEGER         NOT NULL,
	CompletedFolderId       INTEGER         NOT NULL,
	DiscardFolderId         INTEGER         NOT NULL 
)

~

/***********	PRINTFAXEMAILTABLE	****************/

CREATE TABLE PRINTFAXEMAILTABLE(
	ProcessDefId            INTEGER			NOT NULL,
	PFEInterfaceId          INTEGER			NOT NULL,
	InstrumentData          VARCHAR(1)		NULL,
	FitToPage               VARCHAR(1)		NULL,
	Annotations             VARCHAR(1)		NULL,
	FaxNo                   VARCHAR(255)	NULL,
	FaxNoType               VARCHAR(1)		NULL,
	ExtFaxNoId              INTEGER			NULL,
	VariableIdFax			INTEGER			NULL,
	VarFieldIdFax			INTEGER			NULL,
	CoverSheet              VARCHAR(50)		NULL,
	CoverSheetBuffer        TEXT				NULL,
	ToUser                  VARCHAR(255)	NULL,
	FromUser                VARCHAR(255)	NULL,
	ToMailId                VARCHAR(255)	NULL,
	ToMailIdType            VARCHAR(1)		NULL,
	ExtToMailId             INTEGER			NULL,
	VariableIdTo			INTEGER			NULL,
	VarFieldIdTo			INTEGER			NULL,
	CCMailId                VARCHAR(255)	NULL,
	CCMailIdType            VARCHAR(1)		NULL,
	ExtCCMailId             INTEGER			NULL,
	VariableIdCc			INTEGER			NULL,
	VarFieldIdCc			INTEGER			NULL,
	SenderMailId            VARCHAR(255)	NULL,
	SenderMailIdType        VARCHAR(1)		NULL,
	ExtSenderMailId         INTEGER			NULL,
	VariableIdFrom			INTEGER			NULL,
	VarFieldIdFrom			INTEGER			NULL,
	Message                 TEXT			NULL,
	Subject                 VARCHAR(255)	NULL,
	CONSTRAINT PK_PRINTFAXEMAILTABLE PRIMARY KEY(ProcessDefId,PFEInterfaceId)
)

~

/***********	PRINTFAXEMAILDOCTYPETABLE	****************/

CREATE TABLE PRINTFAXEMAILDOCTYPETABLE(
	ProcessDefId	INTEGER        NOT NULL,
	ElementId		INTEGER        NOT NULL,
	PFEType			VARCHAR(1)     NOT NULL,
	DocTypeId		INTEGER        NOT NULL,
	CreateDoc		VARCHAR(1)     NOT NULL,
	VariableId              INTEGER,
	VarFieldId              INTEGER
)

~

/***********	WFFORM_TABLE	****************/

CREATE TABLE WFFORM_TABLE(
	ProcessDefId            INTEGER			NOT NULL,
	FormId                  INTEGER			NOT NULL,
	FormName                VARCHAR(50)		NOT NULL,
	FormBuffer              TEXT				NULL,
	isEncrypted				VARCHAR(1),
	LastModifiedOn 			TIMESTAMP		NOT NULL,
	CONSTRAINT PK_WFFORM_TABLE PRIMARY KEY(ProcessDefID,FormId)
)

~

/***********	SUMMARYTABLE	****************/

CREATE TABLE SUMMARYTABLE
(
	processdefId		INTEGER,
	activityId			INTEGER,
	activityname		VARCHAR(30),
	queueId				INTEGER,
	userId				INTEGER,
	username			VARCHAR(255),
	totalwicount		INTEGER,
	ActionDatetime		TIMESTAMP,
	actionId			INTEGER,
	totalduration		INTEGER,
	reporttype			VARCHAR(1),
	totalprocessingtime	INTEGER,
	delaytime			INTEGER,
	wkindelay			INTEGER,
	AssociatedFieldId	INTEGER,
	AssociatedFieldName	VARCHAR(2000)
)

~

/***********	WFMESSAGETABLE	****************/

CREATE TABLE WFMESSAGETABLE(
	messageId 			SERIAL		PRIMARY KEY, 
	message				TEXT		NOT NULL, 
	lockedBy			VARCHAR(63), 
	status 				VARCHAR(1)	CHECK(status IN ('N', 'F')),
	ActionDateTime		TIMESTAMP
)

~

/***********	CONSTANTDEFTABLE	****************/

CREATE TABLE CONSTANTDEFTABLE(
	ProcessDefId		INTEGER		NOT NULL,	
	ConstantName		VARCHAR(64)	NOT NULL,
	ConstantValue		VARCHAR(255),
	LastModifiedOn		TIMESTAMP	NOT NULL,
	PRIMARY KEY(ProcessDefId, ConstantName)
)

~

/***********	EXTMETHODDEFTABLE	****************/

CREATE TABLE EXTMETHODDEFTABLE(
	ProcessDefId		INTEGER			NOT NULL,
	ExtMethodIndex		INTEGER			NOT NULL,	
	ExtAppName			VARCHAR(64)		NOT NULL, 
	ExtAppType			VARCHAR(1)		NOT NULL CHECK(ExtAppType IN ('E', 'W', 'S', 'Z')), 
	ExtMethodName		VARCHAR(64)		NOT NULL, 
	SearchMethod		VARCHAR(255)	NULL, 
	SearchCriteria		INTEGER 		NULL,
	ReturnType			INTEGER			CHECK(ReturnType IN (0,3,4,6,8,10,11,12,14,15,16)),
	MappingFile			VARCHAR(1),
	PRIMARY KEY(ProcessDefId, ExtMethodIndex)
)

~

/************* EXTMETHODPARAMDEFTABLE **************/

CREATE TABLE EXTMETHODPARAMDEFTABLE(
	ProcessDefId		INTEGER		NOT NULL, 
	ExtMethodParamIndex	INTEGER		NOT NULL,
	ExtMethodIndex		INTEGER		NOT NULL,
	ParameterName		VARCHAR(64),
	ParameterType		INTEGER	CHECK(ParameterType IN (0, 3, 4, 6, 8, 10, 11, 12, 14, 15 ,16)),
	ParameterOrder		INTEGER,
	DataStructureId		INTEGER	,
	ParameterScope		VARCHAR(1),
	Unbounded			VARCHAR(1) 	NOT NULL DEFAULT N'N' CHECK (Unbounded IN (N'Y' , N'N')),
	PRIMARY KEY(ProcessDefId, ExtMethodIndex, ExtMethodParamIndex)
)

~

/*********** EXTMETHODPARAMMAPPINGTABLE ************/

CREATE TABLE EXTMETHODPARAMMAPPINGTABLE(
	ProcessDefId			INTEGER		NOT NULL, 
	ActivityId				INTEGER		NOT NULL,
	RuleId					INTEGER		NOT NULL,
	RuleOperationOrderId	INTEGER		NOT NULL,
	ExtMethodIndex			INTEGER		NOT NULL,
	MapType					VARCHAR(1)	CHECK(MapType IN ('F', 'R')),
	ExtMethodParamIndex		INTEGER		NOT NULL,
	MappedField				VARCHAR(255),
	MappedFieldType			VARCHAR(1)	CHECK(MappedFieldType IN('Q', 'F', 'C', 'S', 'I', 'M', 'U')),
	VariableId				INTEGER,
	VarFieldId				INTEGER,
	DataStructureId			INTEGER
)

~

/***********	WFMessageInProcessTable	****************/

CREATE TABLE WFMessageInProcessTable(
	messageId			INTEGER, 
	message				TEXT, 
	lockedBy			VARCHAR(63), 
	status				VARCHAR(1),
	ActionDateTime		TIMESTAMP
)

~

/***********	WFFailedMessageTable	****************/

CREATE TABLE WFFailedMessageTable(
	messageId			INTEGER, 
	message				TEXT, 
	lockedBy			VARCHAR(63), 
	status				VARCHAR(1),
	failureTime			TIMESTAMP,
	ActionDateTime		TIMESTAMP
)

~

/***********	WFEscalationTable	****************/

CREATE TABLE WFEscalationTable(
	EscalationId		SERIAL,
	ProcessInstanceId	VARCHAR(64),
	WorkitemId			INTEGER,
	ProcessDefId		INTEGER,
	ActivityId			INTEGER,
	EscalationMode		VARCHAR(20)		NOT NULL,
	ConcernedAuthInfo	VARCHAR(256)	NOT NULL,
	Comments			VARCHAR(512)	NOT NULL,
	Message				TEXT			NOT NULL,
	ScheduleTime		TIMESTAMP		NOT NULL
)

~

/***********	WFEscInProcessTable	****************/

Create Table WFEscInProcessTable(
	EscalationId		INTEGER	PRIMARY KEY,
	ProcessInstanceId	VARCHAR(64),
	WorkitemId			INTEGER,
	ProcessDefId		INTEGER,
	ActivityId			INTEGER,
	EscalationMode		VARCHAR(20),
	ConcernedAuthInfo	VARCHAR(256),
	Comments			VARCHAR(512),
	Message				TEXT,
	ScheduleTime		TIMESTAMP
)
	
~

/***********	WFJMSMESSAGETABLE	****************/

CREATE TABLE WFJMSMESSAGETABLE(
	messageId		SERIAL, 
	message			TEXT			NOT NULL, 
	destination		VARCHAR(256),
	entryDateTime	TIMESTAMP,
	OperationType	VARCHAR(1)		
)
	
~

/***********	WFJMSMessageInProcessTable	****************/

Create Table WFJMSMessageInProcessTable(
	messageId		INTEGER, 
	message			TEXT, 
	destination		VARCHAR(256), 
	lockedBy		VARCHAR(63), 
	entryDateTime	TIMESTAMP, 
	lockedTime		TIMESTAMP,
	OperationType	VARCHAR(1)
)
	
~

/***********	WFJMSFailedMessageTable	****************/

Create Table WFJMSFailedMessageTable(
	messageId		INTEGER,
	message			TEXT,
	destination		VARCHAR(256), 
	entryDateTime	TIMESTAMP, 
	failureTime		TIMESTAMP ,
	failureCause	VARCHAR(2000),
	OperationType	VARCHAR(1)
)

~

/***********	WFJMSDestInfo	****************/

CREATE TABLE WFJMSDestInfo(
	destinationId		INTEGER PRIMARY KEY,
	appServerIP			VARCHAR(16),
	appServerPort		INTEGER,
	appServerType		VARCHAR(16),
	jmsDestName			VARCHAR(256) NOT NULL,
	jmsDestType			VARCHAR(1) NOT NULL
)

~

/***********	WFJMSPublishTable	****************/

CREATE TABLE WFJMSPublishTable(
	processDefId		INTEGER,
	activityId			INTEGER,
	destinationId		INTEGER,
	Template			TEXT
)
	
~

/***********	WFJMSSubscribeTable	****************/

CREATE TABLE WFJMSSubscribeTable(
	processDefId		INTEGER,
	activityId			INTEGER,
	destinationId		INTEGER,
	extParamName		VARCHAR(256),
	processVariableName	VARCHAR(256),
	variableProperty	VARCHAR(1),
	VariableId			INTEGER					NULL,
	VarFieldId			INTEGER					NULL
)

~

/************	WFDataStructureTable	************/

CREATE TABLE WFDataStructureTable(
	DataStructureId		INTEGER,
	ProcessDefId		INTEGER,
	ActivityId			INTEGER,
	ExtMethodIndex		INTEGER,
	Name				VARCHAR(256),
	Type				INTEGER,
	ParentIndex			INTEGER,
	ClassName			VARCHAR(255),
	Unbounded			VARCHAR(1) 		NOT NULL DEFAULT N'N' CHECK (Unbounded IN (N'Y' , N'N')),
	PRIMARY KEY(ProcessDefId, ExtMethodIndex, DataStructureId)
)

~

/*************	WFWebServiceTable    ***************/
CREATE TABLE WFWebServiceTable(
	ProcessDefId			INTEGER,
	ActivityId				INTEGER,
	ExtMethodIndex			INTEGER,
	ProxyEnabled			VARCHAR(1),
	TimeOutInterval			INTEGER,
	InvocationType			VARCHAR(1),
	FunctionType			VARCHAR(1) NOT NULL DEFAULT N'L' CHECK (FunctionType IN (N'G' , N'L')),
	ReplyPath				VARCHAR(256), 
	AssociatedActivityId	INTEGER,
	InputBuffer			Text,
	OutputBuffer			Text,
	PRIMARY KEY(ProcessDefId, ActivityId)
)

~

/**********	WFVarStatusTable	***********/
CREATE TABLE WFVarStatusTable(
	ProcessDefId	INTEGER		NOT NULL,
	VarName			VARCHAR(50)	NOT NULL,
	Status			VARCHAR(1)	NOT NULL DEFAULT 'Y' CHECK(Status = 'Y' OR Status = 'N')
) 

~

/************  WFActionStatusTable   ************/
CREATE TABLE WFActionStatusTable(
	ActionId	INTEGER		PRIMARY KEY,
	Type		VARCHAR(1)	NOT NULL DEFAULT 'C' CHECK(Type = 'C' OR Type = 'S'),
	Status		VARCHAR(1)	NOT NULL DEFAULT 'Y' CHECK(Status = 'Y' OR Status = 'N')
) 

~

/************  WFCalDefTable  ************/
CREATE TABLE WFCalDefTable(
	ProcessDefId	INTEGER, 
	CalId			INTEGER, 
	CalName			VARCHAR(256)	NOT NULL,
	GMTDiff			INTEGER,
	LastModifiedOn	TIMESTAMP,
	Comments		VARCHAR(1024),
	PRIMARY KEY(ProcessDefId, CalId)
)

~

Insert into WFCalDefTable values(0, 1, N'DEFAULT 24/7', 530, CURRENT_TIMESTAMP, N'This is the default calendar')

~

/************  WFCalRuleDefTable  ************/ 
CREATE TABLE WFCalRuleDefTable( 
	ProcessDefId	INTEGER, 
	CalId			INTEGER, 
	CalRuleId		INTEGER, 
	Def				VARCHAR(256), 
	CalDate			TIMESTAMP, 
	Occurrence		INTEGER, 
	WorkingMode		VARCHAR(1), 
	DayOfWeek		INTEGER, 
	WEF				TIMESTAMP, 
	PRIMARY KEY(ProcessDefId, CalId, CalRuleId)
)

~

/************  WFCalHourDefTable  ************/
CREATE TABLE WFCalHourDefTable(
	ProcessDefId	INTEGER		NOT NULL,
	CalId			INTEGER		NOT NULL,
	CalRuleId		INTEGER		NOT NULL,
	RangeId			INTEGER		NOT NULL,
	StartTime		INTEGER,
	EndTime			INTEGER,
	PRIMARY KEY(ProcessDefId, CalId, CalRuleId, RangeId)
)

~

Insert into WFCalHourDefTable values (0, 1, 0, 1, 0000, 2400)

~

/************  WFCalendarAssocTable  ************/
CREATE TABLE WFCalendarAssocTable(
	CalId			INTEGER		NOT NULL,
	ProcessDefId	INTEGER		NOT NULL,
	ActivityId		INTEGER		NOT NULL,
	CalType			VARCHAR(1)	NOT NULL,
	UNIQUE(processDefId, activityId)
)

~

/************ TemplateMultiLanguageTable  ************/
CREATE TABLE TemplateMultiLanguageTable(
	ProcessDefId	INTEGER		NOT NULL,
	TemplateId		INTEGER		NOT NULL,
	Locale			NCHAR(5)	NOT NULL,
	TemplateBuffer	TEXT			NULL,
	isEncrypted		VARCHAR(1),
	CONSTRAINT PK_TemplateMultiLanguageTable PRIMARY KEY(ProcessdefId,TemplateId,Locale)
)

~

/************ InterfaceDescLanguageTable  ************/
CREATE TABLE InterfaceDescLanguageTable(
	ProcessDefId	INTEGER			NOT NULL,		
	ElementId		INTEGER			NOT NULL,
	InterfaceId		INTEGER			NOT NULL,
	Locale			NCHAR(5)		NOT NULL,
	Description		VARCHAR(255)	NOT NULL,
	CONSTRAINT PK_InterfaceDescLanguageTable PRIMARY KEY(ProcessDefId,ElementId,InterfaceID)
)

~

/***********  WFActivityReportTable  ***********/
CREATE TABLE WFActivityReportTable(
	ProcessDefId		INTEGER,
	ActivityId			INTEGER,
	ActivityName		VARCHAR(30),
	ActionDateTime		TIMESTAMP,
	TotalWICount		INTEGER,
	TotalDuration		INTEGER,
	TotalProcessingTime	INTEGER
)

~

/***********  WFReportDataTable  ***********/
CREATE TABLE WFReportDataTable(
	ProcessInstanceId	VARCHAR(63),
	WorkitemId			INTEGER,
	ProcessDefId		INTEGER		NOT NULL,
	ActivityId			INTEGER,
	UserId				INTEGER,
	TotalProcessingTime	INTEGER
)

~

/*********** WFParamMappingBuffer  ***********/
CREATE TABLE WFParamMappingBuffer(
	processDefId		INTEGER,
	extMethodId			INTEGER,
	paramMappingBuffer  TEXT,
	UNIQUE(processdefId, extmethodId)
)

~

/*********** SuccessLogTable  ***********/
CREATE TABLE SuccessLogTable(
	LogId				INTEGER,
	ProcessInstanceId	VARCHAR(63)
)

~

/*********** FailureLogTable  ***********/
CREATE TABLE FailureLogTable(
	LogId				INTEGER,
	ProcessInstanceId	VARCHAR(63)
)

~

/*********** WFQuickSearchTable ***********/
CREATE TABLE WFQuickSearchTable(
	VariableId			SERIAL,
	ProcessDefId		INTEGER			NOT NULL,
	VariableName		VARCHAR(64)		NOT NULL,
	Alias				VARCHAR(64)		NOT NULL,
	SearchAllVersion	VARCHAR(1)		NOT NULL,  
	CONSTRAINT UK_WFQuickSearchTable UNIQUE(Alias)
)

~

/*********** WFDurationTable ***********/
CREATE TABLE WFDurationTable(
	ProcessDefId		INTEGER			NOT NULL,
	DurationId			INTEGER			NOT NULL,
	WFYears				VARCHAR(256),
	VariableId_Years	INTEGER	,
	VarFieldId_Years	INTEGER	,
	WFMonths			VARCHAR(256),
	VariableId_Months   INTEGER	,
	VarFieldId_Months	INTEGER	,
	WFDays				VARCHAR(256),
	VariableId_Days		INTEGER	,
	VarFieldId_Days		INTEGER	,
	WFHours				VARCHAR(256), 
	VariableId_Hours	INTEGER	,
	VarFieldId_Hours	INTEGER	,
	WFMinutes			VARCHAR(256), 
	VariableId_Minutes	INTEGER	,
	VarFieldId_Minutes	INTEGER	,
	WFSeconds			VARCHAR(256),
	VariableId_Seconds	INTEGER	,
	VarFieldId_Seconds	INTEGER	,
	CONSTRAINT UK_WFDurationTable UNIQUE(ProcessDefId, DurationId)
)

~

/*********** WFCommentsTable ***********/
CREATE TABLE WFCommentsTable(
	CommentsId			SERIAL			PRIMARY KEY,
	ProcessDefId 		INTEGER 		NOT NULL,
	ActivityId 			INTEGER 		NOT NULL,
	ProcessInstanceId 	VARCHAR(64)		NOT NULL,
	WorkItemId 			INTEGER 		NOT NULL,
	CommentsBy			INTEGER 		NOT NULL,
	CommentsByName		VARCHAR(64)		NOT NULL,
	CommentsTo			INTEGER 		NOT NULL,
	CommentsToName		VARCHAR(64)		NOT NULL,
	Comments			VARCHAR(1000)	NULL,
	ActionDateTime		TIMESTAMP		NOT NULL,
	CommentsType		INTEGER			NOT NULL CHECK(CommentsType IN (1, 2, 3,7))
)

~

/*********** WFFilterTable ***********/
CREATE TABLE WFFilterTable(
	ObjectIndex			INTEGER	NOT NULL,
	ObjectType			VARCHAR(1)	NOT NULL
)	

~

/*********** WFSwimLaneTable ***********/
CREATE TABLE WFSwimLaneTable(
	ProcessDefId	INTEGER		NOT NULL,
	SwimLaneId		INTEGER		NOT NULL,
	SwimLaneWIdth	INTEGER		NOT NULL,
	SwimLaneHeight	INTEGER		NOT NULL,
	ITop			INTEGER		NOT NULL,
	ILeft			INTEGER		NOT NULL,
	BackColor		BIGINT		NOT NULL,
    SwimLaneType    VARCHAR(1) NOT NULL,
    SwimLaneText    VARCHAR(255) NOT NULL,
    SwimLaneTextColor     INTEGER   NOT NULL,
	PoolId 				INTEGER		NULL,
	IndexInPool			INTEGER		NULL,
	PRIMARY KEY ( ProcessDefId, SwimLaneId),
	UNIQUE(ProcessDefId, SwimLaneText)		
)

~

/*********** WFExportTable ***********/
CREATE TABLE WFExportTable(
	ProcessDefId		INTEGER,
	ActivityId			INTEGER,
	DatabaseType		VARCHAR(10),
	DatabaseName		VARCHAR(50),
	UserId				VARCHAR(50),
	UserPwd				VARCHAR(255),
	TableName			VARCHAR(50),
	CSVType				INTEGER,
	NoOfRecords			INTEGER,
	HostName			VARCHAR(255),
	ServiceName			VARCHAR(255),
	Port				VARCHAR(255),
	Header				VARCHAR(1),
	CSVFileName			VARCHAR(255),
	OrderBy				VARCHAR(255),
	FileExpireTrigger	VARCHAR(1),
	BreakOn				VARCHAR(1),
	FieldSeperator		VARCHAR(1), 
	FileType			INTEGER,
	FilePath			VARCHAR(255),
	HeaderString		VARCHAR(255),
	FooterString		VARCHAR(255),
	SleepTime			INTEGER,
	MaskedValue			VARCHAR(255)
)

~

/*********** WFDataMapTable ***********/
CREATE TABLE WFDataMapTable(
	ProcessDefId		INTEGER,
	ActivityId			INTEGER,
	OrderId				INTEGER,
	FieldName			VARCHAR(255),
	MappedFieldName		VARCHAR(255),
	FieldLength			INTEGER,
	DocTypeDefId		INTEGER,
	DateTimeFormat		VARCHAR(50),
	QuoteFlag			VARCHAR(1),
	VariableId			INTEGER					NULL,
	VarFieldId			INTEGER					NULL,
	EXTMETHODINDEX		INTEGER					NULL,
	ALIGNMENT 			VARCHAR(5),
	ExportAllDocs		VARCHAR(2),
	PRIMARY KEY (ProcessDefId, ActivityId, OrderId)
)

~

/*********** WFRoutingServerInfo ***********/
CREATE TABLE WFRoutingServerInfo( 
	InfoId				SERIAL, 
	DmsUserIndex			INTEGER, 
	DmsUserName			VARCHAR(64), 
	DmsUserPassword			VARCHAR(255), 
	DmsSessionId			INTEGER, 
	Data				VARCHAR(128) 
) 

~

/****** WFTypeDescTable  ******/

CREATE TABLE WFTypeDescTable (
	ProcessDefId		INTEGER			NOT NULL,
	TypeId				INTEGER			NOT NULL,
	TypeName			VARCHAR(128)	NOT NULL, 
	ExtensionTypeId		INTEGER			NULL,
	PRIMARY KEY (ProcessDefId, TypeId)
)

~

/******   WFTypeDefTable    ******/

CREATE TABLE WFTypeDefTable (
	ProcessDefId	INTEGER				NOT NULL,
	ParentTypeId	INTEGER				NOT NULL,
	TypeFieldId		INTEGER				NOT NULL,
	FieldName		VARCHAR(128)		NOT NULL, 
	WFType			INTEGER				NOT NULL,
	TypeId			INTEGER				NOT NULL,
	Unbounded		VARCHAR(1)			NOT NULL	DEFAULT N'N' CHECK (Unbounded IN (N'Y' , N'N')),
	ExtensionTypeId INTEGER,
	PRIMARY KEY (ProcessDefId, ParentTypeId, TypeFieldId)
)

~

/****** WFUDTVarMappingTable   *****/

CREATE TABLE WFUDTVarMappingTable (
	ProcessDefId 		INTEGER 			NOT NULL,
	VariableId			INTEGER 			NOT NULL,
	VarFieldId			INTEGER				NOT NULL,
	TypeId				INTEGER				NOT NULL,
	TypeFieldId			INTEGER				NOT NULL,
	ParentVarFieldId	INTEGER				NOT NULL,
	MappedObjectName	VARCHAR(256) 		NULL,
	ExtObjId 			INTEGER				NULL,
	MappedObjectType	VARCHAR(1)		    NULL,
	DefaultValue		VARCHAR(256)		NULL,
	FieldLength			INTEGER				NULL,
	VarPrecision		INTEGER				NULL,
	RelationId			INTEGER 			NULL,
	PRIMARY KEY (ProcessDefId, VariableId, VarFieldId)
)

~

/******   WFVarRelationTable   ******/

CREATE TABLE WFVarRelationTable (
	ProcessDefId 	INTEGER 				NOT NULL,
	RelationId		INTEGER 				NOT NULL,
	OrderId			INTEGER 				NOT NULL,
	ParentObject	VARCHAR(256)			NOT NULL,
	Foreignkey		VARCHAR(256)			NOT NULL,
	FautoGen		VARCHAR(1)				NULL,
	ChildObject		VARCHAR(256)			NOT NULL,
	Refkey			VARCHAR(256)			NOT NULL,
	RautoGen		VARCHAR(1)				NULL,
	PRIMARY KEY (ProcessDefId, RelationId, OrderId)
)

~

/******   WFDataObjectTable   ******/

CREATE TABLE WFDataObjectTable (
	ProcessDefId 		INTEGER 			NOT NULL,
	iId					INTEGER,
	xLeft				INTEGER,
	yTop				INTEGER,
	Data				VARCHAR(255),
	SwimLaneId			INTEGER,
	PRIMARY KEY (ProcessDefId, iId)
)

~

/******   WFGroupBoxTable   ******/

CREATE TABLE WFGroupBoxTable (
	ProcessDefId 		INTEGER 			NOT NULL,
	GroupBoxId			INTEGER,
	GroupBoxWidth		INTEGER,
	GroupBoxHeight		INTEGER,
	iTop				INTEGER,
	iLeft				INTEGER,
	BlockName			VARCHAR(255)		NOT NULL,
	SwimLaneId			INTEGER,
	PRIMARY KEY (ProcessDefId, GroupBoxId)
)

~                                                      

/******   WFAdminLogTable    ******/

CREATE TABLE WFAdminLogTable  (
	AdminLogId			SERIAL				PRIMARY KEY,
	ActionId			INTEGER				NOT NULL,
	ActionDateTime		TIMESTAMP			NOT NULL,
	ProcessDefId		INTEGER,
	QueueId				INTEGER,
	QueueName       	VARCHAR(64),
	FieldId1			INTEGER,
	FieldName1			VARCHAR(255),
	FieldId2			INTEGER,
	FieldName2      	VARCHAR(255),
	Property        	VARCHAR(64),
	UserId				INTEGER,
	UserName			VARCHAR(64),
	OldValue			VARCHAR(255),
	NewValue			VARCHAR(255),
	WEFDate         	TIMESTAMP,
	ValidTillDate   	TIMESTAMP,
	Operation			VARCHAR(1),
	ProfileId			INT,
	ProfileName			VARCHAR(64),	
	Property1			VARCHAR(64)	
)

~

/******   WFAutoGenInfoTable    ******/

CREATE TABLE WFAutoGenInfoTable (
	TableName			VARCHAR(30), 
	ColumnName			VARCHAR(30), 
	Seed				INTEGER,
	IncrementBy			INTEGER, 
	CurrentSeqNo		INTEGER,
	UNIQUE(TableName, ColumnName)
)

~

/******   WFSearchVariableTable    ******/

CREATE TABLE WFSearchVariableTable (
   ProcessDefID			INTEGER				NOT NULL,
   ActivityID			INTEGER				NOT NULL,
   FieldName			VARCHAR(2000)		NOT NULL,
   Scope				VARCHAR(1)			NOT NULL CHECK (Scope = 'C' or Scope = 'F' or Scope = 'R'),
   OrderID				INTEGER				NOT NULL,
   PRIMARY KEY (ProcessDefID, ActivityID, FieldName, Scope)
)

~

/******   WFProxyInfo    ******/

CREATE TABLE WFProxyInfo (
   ProxyHost			VARCHAR(200)				NOT NULL,
   ProxyPort			VARCHAR(200)				NOT NULL,
   ProxyUser			VARCHAR(200)				NOT NULL,
   ProxyPassword		VARCHAR(64),
   DebugFlag			VARCHAR(200),				
   ProxyEnabled			VARCHAR(200)
)

~

/***********  WFAuthorizationTable  ***********/
CREATE TABLE WFAuthorizationTable (
	AuthorizationID		SERIAL				PRIMARY KEY,
    EntityType			VARCHAR(1)	CHECK (EntityType = 'Q' or EntityType = 'P'),
	EntityID			INTEGER				NULL,
	EntityName			VARCHAR(63)			NOT NULL,
	ActionDateTime		TIMESTAMP			NOT NULL,
	MakerUserName		VARCHAR(256)		NOT NULL,
	CheckerUserName		VARCHAR(256)		NULL,
	Comments			VARCHAR(2000)		NULL,
	Status				VARCHAR(1)	CHECK (Status = 'P' or Status = 'R' or Status = 'I')	
)

~

/***********  WFAuthorizeQueueDefTable ***********/
CREATE TABLE WFAuthorizeQueueDefTable (
	AuthorizationID		INTEGER				NOT NULL,
	ActionId			INTEGER				NOT NULL,	
	QueueType			VARCHAR(1)			NULL,
	Comments			VARCHAR(255)		NULL ,
	AllowReASsignment 	VARCHAR(1)			NULL,
	FilterOption		INTEGER				NULL,
	FilterValue			VARCHAR(63)			NULL,
	OrderBy				INTEGER				NULL,
	QueueFilter			VARCHAR(2000)		NULL,
	SortOrder           VARCHAR(1)     NULL
) 

~

/***********  WFAuthorizeQueueStreamTable ***********/
CREATE TABLE WFAuthorizeQueueStreamTable (
	AuthorizationID	INTEGER				NOT NULL,
	ActionId		INTEGER				NOT NULL,	
	ProcessDefID 	INTEGER				NOT NULL,
	ActivityID 		INTEGER				NOT NULL,
	StreamId 		INTEGER				NOT NULL,
	StreamName		VARCHAR(30) 		NOT NULL
)

~	

/******   WFAuthorizeQueueUserTable ******/
CREATE TABLE WFAuthorizeQueueUserTable (
	AuthorizationID			INTEGER				NOT NULL,
	ActionId				INTEGER				NOT NULL,	
	Userid					INTEGER				NOT NULL,
	ASsociationType			INTEGER					NULL,
	ASsignedTillDATETIME	TIMESTAMP				NULL, 
	QueryFilter				VARCHAR(2000)			NULL,
	UserName				VARCHAR(256)		NOT NULL
)  

~	

/******   WFAuthorizeProcessDefTable ******/
CREATE TABLE WFAuthorizeProcessDefTable (
	AuthorizationID		INTEGER				NOT NULL,
	ActionId			INTEGER				NOT NULL,	
	VersionNo			INTEGER				NOT NULL,
	ProcessState		VARCHAR(10)			NOT NULL 
)

~

/******   WFSoapReqCorrelationTable ******/
CREATE TABLE WFSoapReqCorrelationTable (
   Processdefid     INTEGER					NOT NULL,
   ActivityId       INTEGER					NOT NULL,
   PropAlias        VARCHAR(255)			NOT NULL,
   VariableId       INTEGER					NOT NULL,
   VarFieldId       INTEGER					NOT NULL,
   SearchField      VARCHAR(255)			NOT NULL,
   SearchVariableId INTEGER					NOT NULL,
   SearchVarFieldId INTEGER					NOT NULL
)

~

/******   WFWSAsyncResponseTable ******/
CREATE TABLE WFWSAsyncResponseTable (
	ProcessDefId		INTEGER				NOT NULL, 
	ActivityId			INTEGER				NOT NULL, 
	ProcessInstanceId	VARCHAR(64)			NOT NULL, 
	WorkitemId			INTEGER				NOT NULL, 
	CorrelationId1		VARCHAR(100)			NULL, 
	CorrelationId2		VARCHAR(100)			NULL, 
	OutParamXML			VARCHAR(2000)			NULL, 
	Response			TEXT					NULL,
	CONSTRAINT UK_WFWSAsyncResponseTable UNIQUE(ActivityId, ProcessInstanceId, WorkitemId)
)

~

/******   WFScopeDefTable ******/
CREATE TABLE WFScopeDefTable (
	ProcessDefId		INTEGER				NOT NULL,
	ScopeId				INTEGER				NOT NULL,
	ScopeName			VarChar(256)		NOT NULL,
	PRIMARY KEY (ProcessDefId, ScopeId)
)

~

/******   WFEventDefTable ******/
CREATE TABLE WFEventDefTable (
	ProcessDefId				INTEGER				NOT NULL,
	EventId						INTEGER				NOT NULL,
	ScopeId						INTEGER				NULL,
	EventType					VarChar(1)			DEFAULT N'M' CHECK (EventType IN (N'A' , N'M')),
	EventDuration				INTEGER				NULL,
	EventFrequency				VarChar(1)			CHECK (EventFrequency IN (N'O' , N'M')),
	EventInitiationActivityId	INTEGER				NOT NULL,
	EventName					VarChar(64)			NOT NULL,
	associatedUrl				VarChar(255)		NULL,
	PRIMARY KEY (ProcessDefId, EventId)
)

~

/******   WFActivityScopeAssocTable ******/
CREATE TABLE WFActivityScopeAssocTable (
	ProcessDefId		INTEGER			NOT NULL,
	ScopeId				INTEGER			NOT NULL,
	ActivityId			INTEGER			NOT NULL,
	CONSTRAINT UK_WFActivityScopeAssocTable UNIQUE (ProcessDefId, ScopeId, ActivityId)
)

~

/* 27/03/2009, SrNo-15, New tables added for SAP integration. - Ruhi Hira */

/****** WFSAPConnectTable ******/
CREATE TABLE WFSAPConnectTable (
	ProcessDefId		        INTEGER				NOT NULL Primary Key,
	SAPHostName			VarChar(64)	NOT NULL,
	SAPInstance			VarChar(2)		NOT NULL,
	SAPClient			VarChar(3)		NOT NULL,
	SAPUserName			VarChar(256)	NULL,
	SAPPassword			VarChar(512)	NULL,
	SAPHttpProtocol		        VarChar(8)		NULL,
	SAPITSFlag			VarChar(1)		NULL,
	SAPLanguage			VarChar(8)		NULL,
	SAPHttpPort			INTEGER				NULL
)

~

/****** WFSAPGUIDefTable ******/
/*Modified on 23-06-2009 by Ananta Handoo .Three fields added TCodeType, VariableId, VarFieldId */
CREATE TABLE WFSAPGUIDefTable (
	ProcessDefId		INTEGER				NOT NULL,
	DefinitionId		INTEGER				NOT NULL,
	DefinitionName		VarChar(256)	                NOT NULL,
	SAPTCode		VarChar(64)			NOT NULL,
	TCodeType		VarChar(1)			NOT NULL,
	VariableId		INTEGER				NULL,
	VarFieldId		INTEGER				NULL,
	PRIMARY KEY (ProcessDefId, DefinitionId)
)

~

/****** WFSAPGUIFieldMappingTable ******/
CREATE TABLE WFSAPGUIFieldMappingTable (
	ProcessDefId		INTEGER				NOT NULL,
	DefinitionId		INTEGER				NOT NULL,
	SAPFieldName		VarChar(512)	NOT NULL,
	MappedFieldName		VarChar(256)	NOT NULL,
	MappedFieldType		VarChar(1)	CHECK (MappedFieldType	in (N'Q', N'F', N'C', N'S', N'I', N'M', N'U')),
	VariableId			INTEGER				NULL,
	VarFieldId			INTEGER				NULL
)

~

/****** WFSAPGUIAssocTable ******/
CREATE TABLE WFSAPGUIAssocTable (
	ProcessDefId		INTEGER				NOT NULL,
	ActivityId		INTEGER				NOT NULL,
	DefinitionId		INTEGER				NOT NULL,
	Coordinates             VarChar(255)                    NULL, 
	CONSTRAINT UK_WFSAPGUIAssocTable UNIQUE (ProcessDefId, ActivityId, DefinitionId)
)

~
/* 15/04/2009, New tables added for SAP integration. - Ananta Handoo */

/****** WFSAPAdapterAssocTable ******/
CREATE TABLE WFSAPAdapterAssocTable (
	ProcessDefId		INTEGER				 NULL,
	ActivityId		INTEGER				 NULL,
	EXTMETHODINDEX		INTEGER				 NULL
)

~

/****** WFWebServiceInfoTable ******/
CREATE TABLE WFWebServiceInfoTable (
	ProcessDefId		INTEGER				NOT NULL, 
	WSDLURLId			INTEGER				NOT NULL,
	WSDLURL				VARCHAR(2000)		NULL,
	USERId				VARCHAR(255)		NULL,
	PWD					VARCHAR(255)		NULL,
	PRIMARY KEY (ProcessDefId, WSDLURLId)
)

~
CREATE TABLE WFPDATable(
	ProcessDefId		INTEGER				NOT NULL, 
	ActivityId			INTEGER				NOT NULL , 
	InterfaceId			INTEGER				NOT NULL,
	InterfaceType		VARCHAR(1)
)

~

/* Added by Prateek Verma - 12/08/2010 */
/****** WFPDA_FormTable ******/
CREATE TABLE WFPDA_FormTable(
	ProcessDefId		INTEGER				NOT NULL, 
	ActivityId			INTEGER				NOT NULL , 
	VariableID			INTEGER				NOT NULL, 
	VarfieldID			INTEGER				NOT NULL,
	ControlType			INTEGER				NOT NULL,
	DisplayName			VARCHAR(255), 
	MinLen				INTEGER				NOT NULL, 
	MaxLen				INTEGER				NOT NULL,
	Validation			INTEGER				NOT NULL, 
	OrderId				INTEGER				NOT NULL
)

~

/* Added by Prateek Verma - 12/08/2010 */
/****** WFPDAControlValueTable ******/
CREATE TABLE WFPDAControlValueTable(
	ProcessDefId	INTEGER			NOT NULL, 
	ActivityId		INTEGER			NOT NULL, 
	VariableId		INTEGER			NOT NULL,
	VarFieldId		INTEGER			NOT NULL,
	ControlValue	VARCHAR(255)
)

~

/****** WFExtInterfaceConditionTable ******/
CREATE TABLE WFExtInterfaceConditionTable (
	ProcessDefId 	    	INTEGER		NOT NULL,
	ActivityId          	INTEGER		NOT NULL ,
	InterFaceType           VARCHAR(1)   	NOT NULL ,
	RuleOrderId         	INTEGER      	NOT NULL ,
	RuleId              	INTEGER      	NOT NULL ,
	ConditionOrderId    	INTEGER 		NOT NULL ,
	Param1			VARCHAR(50) 	NOT NULL ,
	Type1               	VARCHAR(1) 	NOT NULL ,
	ExtObjID1	    	INTEGER		NULL,
	VariableId_1		INTEGER		NULL,
	VarFieldId_1		INTEGER		NULL,
	Param2			VARCHAR(255) 	NOT NULL ,
	Type2               	VARCHAR(1) 	NOT NULL ,
	ExtObjID2	    	INTEGER		NULL,
	VariableId_2		INTEGER             NULL,
	VarFieldId_2		INTEGER             NULL,
	Operator            	INTEGER 		NOT NULL ,
	LogicalOp           	INTEGER 		NOT NULL ,
	PRIMARY KEY (ProcessDefId, InterFaceType, RuleId, ConditionOrderId)		
)

~

/****** WFExtInterfaceOperationTable ******/
CREATE TABLE WFExtInterfaceOperationTable (
	ProcessDefId 	    	INTEGER		NOT NULL,
	ActivityId          	INTEGER		NOT NULL ,
	InterFaceType           VARCHAR(1)   	NOT NULL ,	
	RuleId              	INTEGER      	NOT NULL , 	
	InterfaceElementId	INTEGER		NOT NULL		

)

~

CREATE TABLE WFImportFileData (
    FileIndex	    INTEGER,
    FileName 	    VARCHAR(256),
    FileType 	    VARCHAR(10),
    FileStatus	    VARCHAR(1),
    Message	        VARCHAR(1000),
    StartTime	    TIMESTAMP,
    EndTime	       TIMESTAMP,
    ProcessedBy     VARCHAR(256),
    TotalRecords    INTEGER
)

~
CREATE TABLE WFPURGECRITERIATABLE(
	PROCESSDEFID	INTEGER		NOT NULL PRIMARY KEY,
	OBJECTNAME	VARCHAR(255)	NOT NULL, 
	EXPORTFLAG	VARCHAR(1)	NOT NULL, 
	DATA		TEXT, 
	CONSTRAINT UK_KEY_OBJECTNAME UNIQUE (OBJECTNAME)
)

~
CREATE TABLE WFEXPORTINFOTABLE(	
	SOURCEUSERNAME		VARCHAR(255)	NOT NULL,
	SOURCEPASSWORD		VARCHAR(255),
	KEEPSOURCEIS            VARCHAR(1),
	TARGETCABINETNAME	VARCHAR(255)	NOT NULL,
	APPSERVERIP		VARCHAR(20),
	APPSERVERPORT		INTEGER,
	TARGETUSERNAME		VARCHAR(200)	NOT NULL,
	TARGETPASSWORD		VARCHAR(200),
	SITEID			INTEGER ,
	VOLUMEID		INTEGER ,
	WEBSERVERINFO		VARCHAR(255)
)

~
CREATE TABLE WFSOURCECABINETINFOTABLE(	
	ISSOURCEIS		VARCHAR(1),
	SITEID			INTEGER,
	SOURCECABINET	        VARCHAR(255),
	APPSERVERIP		VARCHAR(30),
	APPSERVERPORT		INTEGER
)

~
CREATE TABLE WFFormFragmentTable(	
	ProcessDefId	INTEGER		   NOT NULL,
	FragmentId	    INTEGER 	   NOT NULL,
	FragmentName	VARCHAR(50)    NOT NULL,
	FragmentBuffer	TEXT           NULL,
	IsEncrypted	    VARCHAR(1)     NOT NULL,
	StructureName	VARCHAR(128)   NOT NULL,
	StructureId	    INTEGER        NOT NULL,
	LastModifiedOn 	TIMESTAMP	   NOT NULL,
	CONSTRAINT PK_WFFormFragmentTable PRIMARY KEY(ProcessDefId,FragmentId)
)

~
/**** WFS_8.0_115 *****/

CREATE TABLE WFDocTypeFieldMapping( 
	ProcessDefId 	INTEGER 			NOT NULL, 
	DocID 			INTEGER 			NOT NULL, 
	DCName 			VARCHAR (30) 		NOT NULL, 
	FieldName 		VARCHAR (30) 		NOT NULL, 
	FieldID 		INTEGER 			NOT NULL, 
	VariableID 		INTEGER 			NOT NULL, 
	VarFieldID 		INTEGER 			NOT NULL, 
	MappedFieldType VARCHAR(1) 			NOT NULL, 
	MappedFieldName VARCHAR(255) 		NOT NULL, 
	FieldType 		INTEGER 			NOT NULL 
) 

~
/**** WFS_8.0_115 *****/
CREATE TABLE WFDocTypeSearchMapping( 
	ProcessDefId 	INTEGER 		NOT NULL, 
	ActivityID 		INTEGER 		NOT NULL, 
	DCName 			VARCHAR(30) 	NULL, 
	DCField 		VARCHAR(30) 	NOT NULL, 
	VariableID 		INTEGER 		NOT NULL, 
	VarFieldID 		INTEGER 		NOT NULL, 
	MappedFieldType VARCHAR(1) 		NOT NULL, 
	MappedFieldName VARCHAR(255) 	NOT NULL, 
	FieldType 		INTEGER 		NOT NULL 
) 

~
/**** WFS_8.0_115 This table is used by Process Modeler Only*****/
CREATE TABLE WFDataclassUserInfo( 
	ProcessDefId 	INTEGER 			NOT NULL, 
	CabinetName 	VARCHAR(30) 		NOT NULL, 
	UserName 		VARCHAR(30) 		NOT NULL, 
	SType 			VARCHAR(1) 			NOT NULL, 
	UserPWD 		VARCHAR(255) 		NOT NULL 
) 

/* Tables for OTMS [Transport Management System]*/
~
CREATE TABLE WFTransportDataTable  (
	TMSLogId			SERIAL PRIMARY KEY,
    RequestId     		VARCHAR(64),
	ActionId			INTEGER				NOT NULL,
	ActionDateTime		TIMESTAMP		NOT NULL,
	ActionComments		VARCHAR(255),
    UserId              INTEGER             NOT NULL,
    UserName            VARCHAR(64)    NOT NULL,
	Released			VARCHAR(1)    Default 'N',
    ReleasedByUserId          INTEGER,
	ReleasedBy       	VARCHAR(64),
    ReleasedComments	VARCHAR(255),
    ReleasedDateTime   TIMESTAMP,
	Transported			VARCHAR(1)     Default 'N',
    TransportedByUserId INTEGER,
	TransportedBy		VARCHAR(64),
    TransportedDateTime TIMESTAMP,
    ObjectName          VARCHAR(64),
    ObjectType          VARCHAR(1),
    ProcessDefId        INTEGER	,
    CONSTRAINT uk_TransportDataTable	UNIQUE (RequestId)    
)

~
CREATE TABLE WFTMSAddQueue (
    RequestId           VARCHAR(64)     NOT NULL,    
    QueueName           VARCHAR(64),
    RightFlag           VARCHAR(64),
    QueueType           VARCHAR(1),    
    Comments            VARCHAR(255),
    ZipBuffer           VARCHAR(1),
    AllowReassignment   VARCHAR(1),
    FilterOption        INTEGER,
    FilterValue         VARCHAR(64),
    QueueFilter         VARCHAR(64),
    OrderBy             INTEGER,
    SortOrder           VARCHAR(1),
    IsStreamOper        VARCHAR(1)     
)

~
CREATE TABLE WFTMSChangeProcessDefState(
    RequestId           VARCHAR(64)     NOT NULL,    
    RightFlag           VARCHAR(64),
    ProcessDefId        INTEGER,    
    ProcessDefState  VARCHAR(64),
    ProcessName         VARCHAR(64)
)

~
CREATE TABLE WFTMSChangeQueuePropertyEx(
    RequestId           VARCHAR(64)     NOT NULL,    
    QueueName           VARCHAR(64),
    QueueId             INTEGER,
    RightFlag           VARCHAR(64),
    ZipBuffer           VARCHAR(1),
    Description         VARCHAR(255),
    QueueType           VARCHAR(1),
    FilterOption        INTEGER,
    QueueFilter         VARCHAR(64),
    FilterValue         VARCHAR(64),    
    OrderBy             INTEGER,
    SortOrder           VARCHAR(1),
    AllowReassignment   VARCHAR(1),            
    IsStreamOper        VARCHAR(1),
    OriginalQueueName   VARCHAR(64)    
)

~
CREATE TABLE WFTMSDeleteQueue(
    RequestId           VARCHAR(64)     NOT NULL,    
    ZipBuffer           VARCHAR(1),
    RightFlag           VARCHAR(64),
    QueueId             INTEGER     NOT NULL,
    QueueName           VARCHAR(64)
)

~
CREATE TABLE WFTMSStreamOperation(
    RequestId           VARCHAR(64)     NOT NULL,    
    ID                  INTEGER,
    StreamName          VARCHAR(64),
    ProcessDefId        INTEGER,
    ProcessName         VARCHAR(64),
    ActivityId          INTEGER,
    ActivityName        VARCHAR(64),
    Operation           VARCHAR(1)
)

~
CREATE TABLE WFTMSSetVariableMapping(
    RequestId           VARCHAR(64)     NOT NULL,    
    ProcessDefId        INTEGER,        
    ProcessName         VARCHAR(64),
    RightFlag           VARCHAR(64),
    ToReturn            VARCHAR(1),
    Alias               VARCHAR(64),
    QueueId             INTEGER,
    QueueName           VARCHAR(64),
    Param1              VARCHAR(64),
    Param1Type           INTEGER,    
    Type1               VARCHAR(1),
	AliasRule			VARCHAR(4000)
)

~
CREATE TABLE WFTMSSetTurnAroundTime(
    RequestId           VARCHAR(64)     NOT NULL,    
    ProcessDefId        INTEGER,    
    ProcessName         VARCHAR(64),
    RightFlag           VARCHAR(64),
    ProcessTATMinutes   INTEGER,           
    ProcessTATHours     INTEGER,    
    ProcessTATDays      INTEGER,    
    ProcessTATCalFlag   VARCHAR(1),    
    ActivityId          INTEGER,
    AcitivityTATMinutes INTEGER,
    ActivityTATHours    INTEGER,
    ActivityTATDays     INTEGER,
    ActivityTATCalFlag  VARCHAR(1)
)

~
CREATE TABLE WFTMSSetActionList(
    RequestId           VARCHAR(64)     NOT NULL,    
    RightFlag           VARCHAR(64),
    EnabledList         VARCHAR(255),
    DisabledList        VARCHAR(255),
    ProcessDefId        INTEGER,    
    ProcessName           VARCHAR(64),
    EnabledVarList       VARCHAR(255)    
)

~
CREATE TABLE WFTMSSetDynamicConstants(
    RequestId           VARCHAR(64)     NOT NULL,    
    ProcessDefId        INTEGER,  
    ProcessName         VARCHAR(64),
    RightFlag           VARCHAR(64),
    ConstantName        VARCHAR(64),
    ConstantValue       VARCHAR(64)
)

~
CREATE TABLE WFTMSSetQuickSearchVariables(
    RequestId           VARCHAR(64)     NOT NULL,    
    RightFlag           VARCHAR(64),
    Name                VARCHAR(64),
    Alias               VARCHAR(64),
    SearchAllVersion    VARCHAR(1),    
    ProcessDefId        INTEGER,    
    ProcessName         VARCHAR(64),
    Operation           VARCHAR(1)
)

~
CREATE TABLE WFTransportRegisterationInfo(
    ID                          INTEGER     PRIMARY KEY,    
    TargetEngineName           VARCHAR(64),
    TargetAppServerIp           VARCHAR(64),
    TargetAppServerPort         INTEGER,       
    TargetAppServerType         VARCHAR(64),    
    UserName                    VARCHAR(64),    
    Password                    VARCHAR(64)    
)

~
Create TABLE WFTMSSetCalendarData(
    RequestId           VARCHAR(64)     NOT NULL, 
    CalendarId          INTEGER,    
    ProcessDefId        INTEGER,
    ProcessName         VARCHAR(64),
    DefaultHourRange    VARCHAR(2000), 
    CalRuleDefinition   VARCHAR(4000)     
)

~
Create TABLE WFTMSAddCalendar(
    RequestId           VARCHAR(64)     NOT NULL,     
    ProcessDefId        INTEGER,
    ProcessName         VARCHAR(64),
    CalendarName        VARCHAR(64),
    CalendarType        VARCHAR(1),
    Comments             VARCHAR(512),
    DefaultHourRange    VARCHAR(2000), 
    CalRuleDefinition   VARCHAR(4000)     
)

~
Create TABLE WFBPELDefTable(    
    ProcessDefId        INTEGER     NOT NULL PRIMARY KEY,
    BPELDef             TEXT  NOT NULL,
    XSDDef              TEXT   NOT NULL    
)

~

/****** WFSystemServicesTable ******/
CREATE TABLE WFSystemServicesTable (
	ServiceId  			Serial 		PRIMARY KEY,
	PSID 				INTEGER					NULL, 
	ServiceName  		VARCHAR(50)		NULL, 
	ServiceType  		VARCHAR(50)		NULL, 
	ProcessDefId 		INTEGER					NULL, 
	EnableLog  			VARCHAR(50)		NULL, 
	MonitorStatus 		VARCHAR(50)		NULL, 
	SleepTime  			INTEGER					NULL, 
	DateFormat  		VARCHAR(50)		NULL, 
	UserName  			VARCHAR(50)		NULL, 
	Password  			VARCHAR(200)		NULL, 
	RegInfo   			VARCHAR(2000)		NULL
)

~

/*      New tables added for color display support on web.(Requirement)     */
/*      Added by Abhishek Gupta - 24/08/2009    */
/****** WFQueueColorTable ******/
CREATE TABLE WFQueueColorTable(
    Id              SERIAL	NOT NULL		PRIMARY KEY,
    QueueId 		INTEGER                     NOT NULL,
    FieldName 		VARCHAR(50)             NULL,
    Operator 		INTEGER                     NULL,
    CompareValue	VARCHAR(255)            NULL,
    Color			VARCHAR(10)             NULL
)

~

/*      Added by Abhishek Gupta - 24/08/2009    */
/****** WFAuthorizeQueueColorTable ******/
CREATE TABLE WFAuthorizeQueueColorTable(
    AuthorizationId INTEGER         	NOT NULL,
    ActionId 		INTEGER             NOT NULL,
    FieldName 		VARCHAR(50)     NULL,
    Operator 		INTEGER             NULL,
    CompareValue	VARCHAR(255)	NULL,
    Color			VARCHAR(10)     NULL
)

~

/*	Added by AMit Goyal	*/
/************WFAuditRuleTable*************/
CREATE TABLE WFAuditRuleTable(
	ProcessDefId	INTEGER NOT NULL,
	ActivityId		INTEGER NOT NULL,
	RuleId			INTEGER NOT NULL,
	RandomNumber	VARCHAR(50),
	CONSTRAINT PK_WFAuditRuleTable PRIMARY KEY(ProcessDefId,ActivityId,RuleId)
)

~
/************WFAuditTrackTable***************/
CREATE TABLE WFAuditTrackTable(
	ProcessInstanceId	VARCHAR(255),
	WorkitemId			INTEGER,
	SampledStatus		INTEGER,
	CONSTRAINT PK_WFAuditTrackTable PRIMARY KEY(ProcessInstanceID,WorkitemId)
	
)

~

CREATE TABLE WFActivitySequenceTABLE(
	ProcessDefId 	INTEGER 	NOT NULL,
	MileStoneId 	INTEGER 	NOT NULL,
	ActivityId 		INTEGER 	NOT NULL,
	SequenceId 		INTEGER 	NOT NULL,
	SubSequenceId 	INTEGER NOT NULL,
	CONSTRAINT pk_WFActivitySequenceTABLE PRIMARY KEY(ProcessDefId,MileStoneId,SequenceId,SubSequenceId)
)

~

CREATE TABLE WFMileStoneTable(
	ProcessDefId 	INTEGER NOT NULL,
	MileStoneId 	INTEGER NOT NULL,
	MileStoneSeqId 	INTEGER NOT NULL,
	MileStoneName 	VARCHAR(255) NULL,
	MileStoneWidth 	INTEGER NOT NULL,
	MileStoneHeight INTEGER NOT NULL,
	ITop 			INTEGER NOT NULL,
	ILeft 			INTEGER NOT NULL,
	BackColor 		INTEGER NOT NULL,
	Description 	VARCHAR(255) NULL,
	isExpanded 		VARCHAR(50) NULL,
	Cost 			INTEGER NULL,
	Duration 		VARCHAR(255) NULL,
    CONSTRAINT pk_WFMileStoneTable PRIMARY KEY(ProcessDefId,MileStoneId),
    CONSTRAINT uk_WFMileStoneTable UNIQUE (ProcessDefId,MileStoneName)
)

~

CREATE TABLE WFProjectListTable(
	ProjectID 			INTEGER 			NOT NULL,
	ProjectName 		VARCHAR(255) 	NOT NULL,
	Description 		TEXT			NULL,
	CreationDateTime 	TIMESTAMP 		NOT NULL,
	CreatedBy 			VARCHAR(255) 	NOT NULL,
	LastModifiedOn 		TIMESTAMP 		NULL,
	LastModifiedBy 		VARCHAR(255) 	NULL,
	ProjectShared 		NCHAR(1) 		NULL,
    CONSTRAINT pk_WFProjectListTable PRIMARY KEY(ProjectID),
    CONSTRAINT WFUNQ_1 UNIQUE(ProjectName)
)

~

Insert into WFProjectListTable values (1, 'Default', ' ', CURRENT_TIMESTAMP, 'Supervisor', CURRENT_TIMESTAMP, 'Supervisor', 'N')

~

create TABLE WFEventDetailsTable(
	EventID 				INTEGER 			NOT NULL,
	EventName 				varchar(255) 	NOT NULL,
	Description 			varchar(255) 	NULL,
	CreationDateTime 		TIMESTAMP 		NOT NULL,
	ModificationDateTime	TIMESTAMP 		NULL,
	CreatedBy 				varchar(255) 	NOT NULL,
	StartTimeHrs 			INTEGER 			NOT NULL,
	StartTimeMins 			INTEGER 			NOT NULL,
	EndTimeMins 			INTEGER 			NOT NULL,
	EndTimeHrs 				INTEGER 			NOT NULL,
	StartDate 				TIMESTAMP 		NOT NULL,
	EndDate 				TIMESTAMP 		NOT NULL,
	EventRecursive 			varchar(1) 	NOT NULL,
	FullDayEvent 			varchar(1) 	NOT NULL,
	ReminderType 			varchar(1) 	NULL,
	ReminderTime 			INTEGER 			NULL,
	ReminderTimeType 		varchar(1) 	NULL,
	ReminderDismissed 		varchar(1) 	NOT NULL Default 'N',
	SnoozeTime 				INTEGER 			NOT NULL DEFAULT -1,
	EventSummary 			varchar(255) 	NULL,
	UserID 					INTEGER 			NULL,
	ParticipantName 		varchar(1024) 	NOT NULL,
    CONSTRAINT pk_WFEventDetailsTable PRIMARY KEY(EventID)
)

~

CREATE TABLE WFRepeatEventTable(
	EventID 		INTEGER 			NOT NULL,
	RepeatType 		VARCHAR(1) 	NOT NULL,
	RepeatDays 		VARCHAR(255) 	NOT NULL,
	RepeatEndDate 	TIMESTAMP 		NOT NULL,
	RepeatSummary 	VARCHAR(255) 	NULL
)

~

CREATE table WFOwnerTable(
	Type 			INTEGER NOT NULL,
	TypeId 			INTEGER NOT NULL,
	ProcessDefId 	INTEGER NOT NULL,	
	OwnerOrderId 	INTEGER NOT NULL,
	UserId  		INTEGER NOT NULL,
	constraint pk_WFOwnerTable PRIMARY KEY (Type,TypeId,ProcessDefId,OwnerOrderId)
)

~

CREATE TABLE WFConsultantsTable(
	Type 				INTEGER 	NOT NULL,
	TypeId 				INTEGER 	NOT NULL,
	ProcessDefId 		INTEGER 	NOT NULL,	
	ConsultantOrderId 	INTEGER 	NOT NULL,
	UserId  			INTEGER 	NOT NULL,
	constraint pk_WFConsultantsTable PRIMARY KEY (Type,TypeId,ProcessDefId,ConsultantOrderId)
)

~

CREATE table WFSystemTable(
	Type 			INTEGER 			NOT NULL,
	TypeId 			INTEGER 			NOT NULL,
	ProcessDefId 	INTEGER 			NOT NULL,	
	SystemOrderId 	INTEGER 			NOT NULL,
	SystemName  	VARCHAR(255) 	NOT NULL,
	constraint pk_WFSystemTable PRIMARY KEY (Type,TypeId,ProcessDefId,SystemOrderId)
)

~

CREATE table WFProviderTable(
	Type 				INTEGER 			NOT NULL,
	TypeId 				INTEGER 			NOT NULL,
	ProcessDefId 		INTEGER 			NOT NULL,	
	ProviderOrderId 	INTEGER 			NOT NULL,
	ProviderName  		VARCHAR(255) 	NOT NULL,
	constraint pk_WFProviderTable PRIMARY KEY (Type,TypeId,ProcessDefId,ProviderOrderId)
)

~

create table WFConsumerTable(
	Type 			INTEGER 			NOT NULL,
	TypeId 			INTEGER 			NOT NULL,
	ProcessDefId 	INTEGER 			NOT NULL,	
	ConsumerOrderId INTEGER 			NOT NULL,
	ConsumerName 	VARCHAR(255) 	NOT NULL,
	constraint pk_WFConsumerTable PRIMARY KEY (Type,TypeId,ProcessDefId,ConsumerOrderId)
)

~

create TABLE WFPoolTable(
	ProcessDefId 		INTEGER 			NOT NULL,
	PoolId 				INTEGER 			NOT NULL,
	PoolName 			VARCHAR(255) 	NULL,
	PoolWidth 			INTEGER 			NOT NULL,
	PoolHeight 			INTEGER 			NOT NULL,
	ITop 				INTEGER 			NOT NULL,
	ILeft 				INTEGER 			NOT NULL,
	BackColor 			VARCHAR(255) 	NULL,   
    CONSTRAINT pk_WFPoolTable PRIMARY KEY (ProcessDefId,PoolId),
    CONSTRAINT uk_WFPoolTable UNIQUE (ProcessDefId,PoolName) 
)

~

CREATE TABLE WFRecordedChats(
	ProcessDefId 		INTEGER 			NOT NULL,
	ProcessName 		VARCHAR(255) 	NULL,
	SavedBy 			VARCHAR(255) 	NULL,
	SavedAt 			TIMESTAMP 		NOT NULL,
	ChatId 				VARCHAR(255) 	NOT NULL,
	Chat 				VARCHAR(MAX) 	NULL,
	ChatStartTime 		TIMESTAMP 		NOT NULL,
	ChatEndTime 		TIMESTAMP 		NOT NULL
)

~

CREATE TABLE WFRequirementTable(
	ProcessDefId		INTEGER		NOT NULL,
	ReqType				INTEGER		NOT NULL,
	ReqId				INTEGER		NOT NULL,
	ReqName				VARCHAR(255)	NOT	NULL,
	ReqDesc				TEXT			NULL,
	ReqPriority			INTEGER				NULL,
	ReqTypeId			INTEGER		NOT NULL,
	ReqImpl				TEXT			NULL,
	CONSTRAINT pk_WFRequirementTable PRIMARY KEY (ProcessDefId, ReqType, ReqId, ReqTypeId)
)

~

CREATE TABLE WFDocBuffer(
	ProcessDefId 	INTEGER NOT NULL,
	ActivityId 		INTEGER NOT NULL ,
	DocName 		VARCHAR(255) NOT NULL,
	DocId 			INTEGER		NOT NULL,
	DocumentBuffer  TEXT NOT NULL,
	PRIMARY KEY (ProcessDefId, ActivityId, DocId)		
)

~

Create Table WFLaneQueueTable (
	ProcessDefId 	INTEGER NOT NULL,
	SwimLaneId 		INTEGER NOT NULL ,
	QueueID 		INTEGER	NOT NULL,
	PRIMARY KEY (ProcessDefId, SwimLaneId, QueueID)
)

~

Create Table WFCreateChildWITable(
	ProcessDefId		INT NOT NULL,
	TriggerId			INT NOT NULL,
	WorkstepName		VARCHAR(255), 
	Type		VARCHAR(1), 
	GenerateSameParent	VARCHAR(1), 
	VariableId			INT, 
	VarFieldId			INT
	PRIMARY KEY (Processdefid , TriggerId)
)
			

~			

CREATE TABLE CONFLICTINGQUEUEUSERTABLE(
	ConflictId				INTEGER			NOT NULL PRIMARY KEY,
	QueueId 				INTEGER 		NOT NULL,
	UserId 					INTEGER 		NOT NULL,
	ASsociationType 		INTEGER 		NOT NULL,
	ASsignedTillDATETIME	TIMESTAMP		NULL, 
	QueryFilter				VARCHAR(2000)	NULL,
	QueryPreview			VARCHAR(1),
	RevisionNo				INTEGER,
	ProcessDefId			INTEGER	
)

~

CREATE TABLE WFWorkdeskLayoutTable (
	ProcessDefId  		INTEGER		NOT NULL,
	ActivityId    		INTEGER 	NOT NULL,
	WSLayoutDefinition 	VARCHAR(4000),
	PRIMARY KEY (ProcessDefId, ActivityId)
)

~

Create Table WFProfileTable(
	ProfileId				INTEGER NOT NULL PRIMARY KEY,
	ProfileName				VARCHAR(50),
	Description				VARCHAR(255),
	Deletable				VARCHAR(1),
	CreatedOn				TIMESTAMP,
	LastModifiedOn			TIMESTAMP,
	OwnerId					INTEGER,
	OwnerName				VARCHAR(64),
	CONSTRAINT UK_WFProfileTable UNIQUE(ProfileName)
)

~
		
Create Table WFObjectListTable(
	ObjectTypeId				INTEGER  NOT NULL PRIMARY KEY,
	ObjectType					VARCHAR(20),
	ObjectTypeName				VARCHAR(50),
	ParentObjectTypeId			INTEGER,
	ClassName					VARCHAR(255),
	DefaultRight				VARCHAR(20)
)

~

Create Table WFAssignableRightsTable(
	ObjectTypeId		INTEGER,
	RightFlag			VARCHAR(10),
	RightName			VARCHAR(50),
	OrderBy				INTEGER
)

~

Create Table WFObjectProfileAssocTable(
	ObjectId					INTEGER 		NOT NULL ,
	ObjectTypeId				INTEGER 		NOT NULL ,
	ParentObjectId				VARCHAR(10),
	RightString					VARCHAR(20),
	UserId						INTEGER 		NOT NULL ,
	AssociationType				INTEGER 		NOT NULL ,
	FilterString				VARCHAR(255),
	PRIMARY KEY(ObjectId, ObjectTypeId, ParentObjectId, UserId, AssociationType)
)

~

Create Table WFProfileUserTable(
	ProfileId				INTEGER NOT NULL ,
	UserId					INTEGER NOT NULL ,
	AssociationType			INTEGER NOT NULL ,
	AssignedTillDATETIME	TIMESTAMP,
	AssociationFlag			VARCHAR(1),
	PRIMARY KEY(ProfileId, UserId, AssociationType)
)

~

Create Table WFFilterListTable(
	ObjectTypeId			INTEGER NOT NULL,
	FilterName				VARCHAR(50),
	TagName					VARCHAR(50)
)

~

/*  Added by Shweta Singhal- 25/10/2012 */

/******   WFUnderlyingDMS    ******/
CREATE TABLE WFUnderlyingDMS (
	DMSType		INTEGER			NOT NULL,
	DMSName		VARCHAR(255)	NULL
)

~

/******   WFSharePointInfo    ******/
CREATE TABLE WFSharePointInfo (
	ServiceURL		VARCHAR(255)	NULL,
	ProxyEnabled	VARCHAR(200)	NULL,
	ProxyIP			VARCHAR(20)		NULL,
	ProxyPort		VARCHAR(200)	NULL,
	ProxyUser		VARCHAR(200)	NULL,
	ProxyPassword	VARCHAR(64)		NULL,
	SPWebUrl		VARCHAR(200)	NULL
)

~

/******   WFDMSLibrary    ******/
CREATE TABLE WFDMSLibrary (
	LibraryId			INTEGER			NOT NULL 	PRIMARY KEY,
	URL			VARCHAR(255)	NULL,
	DocumentLibrary		VARCHAR(255)	NULL
)

~

/******   WFProcessSharePointAssoc    ******/
CREATE TABLE WFProcessSharePointAssoc (
	ProcessDefId			INTEGER		NOT NULL,
	LibraryId				INTEGER		NULL,
	PRIMARY KEY (ProcessDefId)
)

~

/******   WFArchiveInSharePoint    ******/
CREATE TABLE WFArchiveInSharePoint (
	ProcessDefId			INTEGER			NULL,
	ActivityID				INTEGER			NULL,
	URL					 	VARCHAR(255)	NULL,		
	SiteName				VARCHAR(255)	NULL,
	DocumentLibrary			VARCHAR(255)	NULL,
	FolderName				VARCHAR(255)	NULL,
	ServiceURL 				VARCHAR(255) 	NULL,
	SameAssignRights		VARCHAR(255) 	NULL,
	DiffFolderLoc			VARCHAR(255) 	NULL
)

~

/******   WFSharePointDataMapTable    ******/
CREATE TABLE WFSharePointDataMapTable (
	ProcessDefId			INTEGER			NULL,
	ActivityID				INTEGER			NULL,
	FieldId					INTEGER			NULL,
	FieldName				VARCHAR(255)	NULL,
	FieldType				INTEGER			NULL,
	MappedFieldName			VARCHAR(255)	NULL,
	VariableID				VARCHAR(255)	NULL,
	VarFieldID				VARCHAR(255)	NULL
	
)

~

/******   WFSharePointDocAssocTable    ******/
CREATE TABLE WFSharePointDocAssocTable (
	ProcessDefId			INTEGER			NULL,
	ActivityID				INTEGER			NULL,
	DocTypeID				INTEGER			NULL,
	AssocFieldName			VARCHAR(255)	NULL,
	FolderName				VARCHAR(255)	NULL
)

~

CREATE TABLE WFMsgAFTable(
	ProcessDefId 	INT NOT NULL,
	MsgAFId 		INT NOT NULL,
	xLeft 			INT NULL,
	yTop 			INT NULL,
	MsgAFName 		VARCHAR(255) NULL,
	SwimLaneId 		INT NOT NULL,
	PRIMARY KEY ( ProcessDefId, MsgAFId, SwimLaneId)
)
 
~
~
Insert into WFWorkdeskLayoutTable (ProcessDefId, ActivityId, WSLayoutDefinition) values (0, 0, '<WDeskLayout Interfaces="4"><Resolution><ScreenWidth>1024</ScreenWidth><ScreenHeight>768</ScreenHeight></Resolution>        <WDeskInterfaces><Interface Type=''FormView'' Top=''50'' Left=''2'' Width=''501'' Height=''615''/><Interface Type=''Document'' Top=''50'' Left=''510'' Width=''501'' Height=''615''/></WDeskInterfaces><MenuInterfaces><Interface Type="Exceptions"/><Interface Type="ToDoList"/></MenuInterfaces></WDeskLayout>')

~

/****** CREATE SEQUENCE ******/

/****** SEQ_WFImportFileId ******/
CREATE SEQUENCE SEQ_WFImportFileId START 1 INCREMENT 1

~
/****SEQ_ProcessDefId******/
CREATE SEQUENCE ProcessDefId
	START 1 INCREMENT 1 
~

~
/****RevisionNoSequence******/
CREATE SEQUENCE RevisionNoSequence
	START 1 INCREMENT 1 
~

~
/****ConflictIdSequence******/
CREATE SEQUENCE ConflictIdSequence
	START 1 INCREMENT 1 
~
/********ProfileIdSequence************/

CREATE SEQUENCE ProfileIdSequence
	INCREMENT BY 1 START WITH 1 NOCACHE

~
	
/********ObjectTypeIdSequence************/
	
CREATE SEQUENCE ObjectTypeIdSequence
	INCREMENT BY 1 START WITH 1 NOCACHE

~

/****LibraryIdSequence******/
CREATE SEQUENCE LibraryIdSequence START 1 INCREMENT 1 

~

INSERT INTO WFProfileTable values (ProfileIdSequence.nextval,'SYSADMIN','Admin Profile','N',sysdate,sysdate, 2,1)

~

INSERT INTO WFProfileUserTable VALUES(1, 2, 1, NULL, 'Y')

~

/**** CREATE VIEW ****/
/***********	EXCEPTION VIEW	****************/
CREATE OR REPLACE VIEW EXCEPTIONVIEW 
AS
	SELECT * FROM EXCEPTIONTABLE 
	UNION ALL
	SELECT * FROM EXCEPTIONHISTORYTABLE 

~

/***********	TODOSTATUS VIEW	****************/
CREATE OR REPLACE VIEW TODOSTATUSVIEW 
AS 
	SELECT * FROM TODOSTATUSTABLE 
	UNION ALL
	SELECT * FROM TODOSTATUSHISTORYTABLE 


~

/*********** ROUTELOGTABLE VIEW****************/
CREATE OR REPLACE VIEW ROUTELOGTABLE 
AS 
	SELECT * FROM WFCURRENTROUTELOGTABLE 
	UNION ALL
	SELECT * FROM WFHISTORYROUTELOGTABLE 

~

/***********	WFGROUPMEMBERVIEW	****************/
CREATE OR REPLACE VIEW WFGROUPMEMBERVIEW 
AS 
	SELECT * FROM PDBGROUPMEMBER 

~

/***********	QUSERGROUPVIEW	****************/
CREATE OR REPLACE VIEW QUSERGROUPVIEW 
AS
	SELECT queueId,userId, NULL AS groupId, AssignedtillDateTime, queryFilter, QueryPreview
	FROM   QUEUEUSERTABLE 
	WHERE  ASsociationtype=0
 	AND (AssignedtillDateTime IS NULL OR AssignedtillDateTime>=CURRENT_TIMESTAMP)
	UNION
	SELECT queueId, userindex,userId AS groupId,NULL AS AssignedtillDateTime, queryFilter, QueryPreview
 	FROM   QUEUEUSERTABLE , WFGROUPMEMBERVIEW 
	WHERE  ASsociationtype=1 
	AND    QUEUEUSERTABLE.userId=WFGROUPMEMBERVIEW.groupindex 

~

/***********	WFWORKLISTVIEW_0	****************/
CREATE OR REPLACE VIEW WFWORKLISTVIEW_0 
AS 
	 SELECT WORKLISTTABLE.ProcessInstanceId, WORKLISTTABLE.ProcessInstanceId AS ProcessInstanceName, WORKLISTTABLE.ProcessDefId, ProcessName, ActivityId, ActivityName, PriorityLevel, InstrumentStatus, LockStatus, 
		 LockedByName, ValIdTill, CreatedByName, PROCESSINSTANCETABLE.CreatedDatetime, Statename, 
		 CheckListCompleteFlag,  EntryDATETIME, LockedTime, IntroductionDateTime, Introducedby, 
		 AssignedUser, WORKLISTTABLE.WorkItemId,  QueueName, AssignmentType, ProcessInstanceState, 
		 QueueType, Status, Q_QueueId, EXTRACT('DAYS' FROM EntryDateTime - ExpectedWorkItemDelay) * 24 + EXTRACT('HOUR' FROM EntryDateTime - ExpectedWorkItemDelay) AS TurnaroundTime, 
		 ReferredByname, NULL AS ReferTo, Q_UserId, FILTERVALUE, Q_StreamId, CollectFlag, 
		 WORKLISTTABLE.ParentWorkItemId, ProcessedBy, LastProcessedBy, ProcessVersion, WorkItemState, 
		 PREVIOUSSTAGE, ExpectedWorkitemDelay, VAR_INT1, VAR_INT2, VAR_INT3, VAR_INT4, VAR_INT5, VAR_INT6, 
		 VAR_INT7, VAR_INT8, VAR_LONG1, VAR_LONG2, VAR_LONG3, VAR_LONG4  
	 FROM  WORKLISTTABLE , PROCESSINSTANCETABLE , QUEUEDATATABLE 
	 WHERE WORKLISTTABLE.ProcessInstanceId = QUEUEDATATABLE.ProcessInstanceId 
	 AND   WORKLISTTABLE.WorkitemId = QUEUEDATATABLE.WorkitemId 
	 AND   WORKLISTTABLE.ProcessInstanceId = PROCESSINSTANCETABLE.ProcessInstanceId  
	 UNION ALL
	 SELECT  PENDINGWORKLISTTABLE.ProcessInstanceId, PENDINGWORKLISTTABLE.ProcessInstanceId AS ProcessInstanceName, 
		 PENDINGWORKLISTTABLE.ProcessDefId, ProcessName, ActivityId, ActivityName, PriorityLevel, InstrumentStatus, 
		 LockStatus, LockedByName, ValIdTill, CreatedByName, PROCESSINSTANCETABLE.CreatedDatetime, Statename, 
		 CheckListCompleteFlag, EntryDATETIME, LockedTime, IntroductionDateTime, Introducedby, AssignedUser, 
		 PENDINGWORKLISTTABLE.WorkItemId, QueueName, AssignmentType, ProcessInstanceState, QueueType, Status, 
		 Q_QueueId, EXTRACT('DAYS' FROM EntryDateTime - ExpectedWorkItemDelay) * 24 + EXTRACT('HOUR' FROM EntryDateTime - ExpectedWorkItemDelay) AS TurnaroundTime, ReferredByname,  
		 ReferredTo AS ReferTo, Q_UserId, FILTERVALUE, Q_StreamId, CollectFlag, PENDINGWORKLISTTABLE.ParentWorkItemId, 
		 ProcessedBy, LastProcessedBy, ProcessVersion, WorkItemState, PREVIOUSSTAGE, ExpectedWorkitemDelay, 
		 VAR_INT1, VAR_INT2, VAR_INT3, VAR_INT4, VAR_INT5, VAR_INT6, VAR_INT7, VAR_INT8, VAR_LONG1, VAR_LONG2, 
		 VAR_LONG3, VAR_LONG4 
	 FROM  PENDINGWORKLISTTABLE , PROCESSINSTANCETABLE , QUEUEDATATABLE   
	 WHERE PENDINGWORKLISTTABLE.ProcessInstanceId = QUEUEDATATABLE.ProcessInstanceId  
	 AND   PENDINGWORKLISTTABLE.WorkitemId = QUEUEDATATABLE.WorkitemId 
	 AND   PENDINGWORKLISTTABLE.ProcessInstanceId = PROCESSINSTANCETABLE.ProcessInstanceId  
	 UNION ALL 
	 SELECT WORKINPROCESSTABLE.ProcessInstanceId, WORKINPROCESSTABLE.ProcessInstanceId AS ProcessInstanceName, 
		WORKINPROCESSTABLE.ProcessDefId, ProcessName, ActivityId, ActivityName, PriorityLevel, InstrumentStatus, 
		LockStatus, LockedByName, ValIdTill, CreatedByName, PROCESSINSTANCETABLE.CreatedDatetime, Statename, 
		CheckListCompleteFlag, EntryDATETIME, LockedTime, IntroductionDateTime, Introducedby, AssignedUser, 
		WORKINPROCESSTABLE.WorkItemId, QueueName, AssignmentType, ProcessInstanceState,QueueType, Status, 
		Q_QueueId, EXTRACT('DAYS' FROM EntryDateTime - ExpectedWorkItemDelay) * 24 + EXTRACT('HOUR' FROM EntryDateTime - ExpectedWorkItemDelay) AS TurnaroundTime, ReferredByname, 
		NULL AS ReferTo, Q_UserId, FILTERVALUE, Q_StreamId, CollectFlag, WORKINPROCESSTABLE.ParentWorkItemId, 
		ProcessedBy, LastProcessedBy, ProcessVersion, WorkItemState, PREVIOUSSTAGE, ExpectedWorkitemDelay, 
		VAR_INT1, VAR_INT2, VAR_INT3, VAR_INT4, VAR_INT5, VAR_INT6, VAR_INT7, VAR_INT8, VAR_LONG1, VAR_LONG2, 
		VAR_LONG3, VAR_LONG4 
	FROM  WORKINPROCESSTABLE , PROCESSINSTANCETABLE , QUEUEDATATABLE  
	WHERE WORKINPROCESSTABLE.ProcessInstanceId = QUEUEDATATABLE.ProcessInstanceId 
	AND   WORKINPROCESSTABLE.WorkitemId = QUEUEDATATABLE.WorkitemId 
	AND WORKINPROCESSTABLE.ProcessInstanceId = PROCESSINSTANCETABLE.ProcessInstanceId 
 
~

/***********	QUEUETABLE	****************/
CREATE OR REPLACE VIEW QUEUETABLE 
AS
	SELECT  queueTABLE1.processdefId, processname, processversion, 
		queueTABLE1.processinstanceId, queueTABLE1.processinstanceId AS processinstancename, 
		queueTABLE1.activityId, queueTABLE1.activityname, 
		QUEUEDATATABLE.parentworkitemId, queueTABLE1.workitemId, 
		processinstancestate, workitemstate, statename, queuename, queuetype,
		AssignedUser, AssignmentType, instrumentstatus, checklistcompleteflag, 
		IntroductionDateTime, PROCESSINSTANCETABLE.CreatedDatetime AS CreatedDatetime,
		Introducedby, createdbyname, entryDATETIME,
		lockstatus, holdstatus, prioritylevel, lockedbyname, 
		lockedtime, valIdtill, savestage, previousstage,
		expectedworkitemdelay AS expectedworkitemdelaytime,
	        expectedprocessdelay AS expectedprocessdelaytime, status, 
		var_INT1, var_INT2, var_INT3, var_INT4, var_INT5, var_INT6, var_INT7, var_INT8, 
		var_float1, var_float2, 
		var_date1, var_date2, var_date3, var_date4, 
		var_long1, var_long2, var_long3, var_long4, 
		var_str1, var_str2, var_str3, var_str4, var_str5, var_str6, var_str7, var_str8, 
		var_rec_1, var_rec_2, var_rec_3, var_rec_4, var_rec_5,
		q_streamId, q_queueId, q_userId, LastProcessedBy, processedby, referredto,
		referredtoname, referredby, referredbyname, collectflag, NULL AS CompletionDatetime, CalendarName
	FROM QUEUEDATATABLE , 
	     PROCESSINSTANCETABLE  ,
          (SELECT processinstanceId, workitemId, processname, processversion,
                  processdefId, LastProcessedBy, processedby, activityname, activityId,
                  entryDATETIME, parentworkitemId, AssignmentType,
                  collectflag, prioritylevel, valIdtill, q_streamId,
                  q_queueId, q_userId, AssignedUser, CreatedDatetime,
                  workitemstate, expectedworkitemdelay, previousstage,
                  lockedbyname, lockstatus, lockedtime, queuename, queuetype,
                  statename
             FROM WORKLISTTABLE  
           UNION ALL
           SELECT processinstanceId, workitemId, processname, processversion,
                  processdefId, LastProcessedBy, processedby, activityname, activityId,
                  entryDATETIME, parentworkitemId, AssignmentType,
                  collectflag, prioritylevel, valIdtill, q_streamId,
                  q_queueId, q_userId, AssignedUser, CreatedDatetime,
                  workitemstate, expectedworkitemdelay, previousstage,
                  lockedbyname, lockstatus, lockedtime, queuename, queuetype,
                  statename
             FROM WORKINPROCESSTABLE  
           UNION ALL
           SELECT processinstanceId, workitemId, processname, processversion,
                  processdefId, LastProcessedBy, processedby, activityname, activityId,
                  entryDATETIME, parentworkitemId, AssignmentType,
                  collectflag, prioritylevel, valIdtill, q_streamId,
                  q_queueId, q_userId, AssignedUser, CreatedDatetime,
                  workitemstate, expectedworkitemdelay, previousstage,
                  lockedbyname, lockstatus, lockedtime, queuename, queuetype,
                  statename
             FROM WORKDONETABLE  
           UNION ALL
           SELECT processinstanceId, workitemId, processname, processversion,
                  processdefId, LastProcessedBy, processedby, activityname, activityId,
                  entryDATETIME, parentworkitemId, AssignmentType,
                  collectflag, prioritylevel, valIdtill, q_streamId,
                  q_queueId, q_userId, AssignedUser, CreatedDatetime,
                  workitemstate, expectedworkitemdelay, previousstage,
                  lockedbyname, lockstatus, lockedtime, queuename, queuetype,
                  statename
             FROM WORKWITHPSTABLE  
           UNION ALL
           SELECT processinstanceId, workitemId, processname, processversion,
                  processdefId, LastProcessedBy, processedby, activityname, activityId,
                  entryDATETIME, parentworkitemId, AssignmentType,
                  collectflag, prioritylevel, valIdtill, q_streamId,
                  q_queueId, q_userId, AssignedUser, CreatedDatetime,
                  workitemstate, expectedworkitemdelay, previousstage,
                  lockedbyname, lockstatus, lockedtime, queuename, queuetype,
                  statename
             FROM PENDINGWORKLISTTABLE ) queueTABLE1
    WHERE QUEUEDATATABLE.processinstanceId = queueTABLE1.processinstanceId
      AND QUEUEDATATABLE.workitemId = queueTABLE1.workitemId
      AND queueTABLE1.processinstanceId = PROCESSINSTANCETABLE.processinstanceId

~

/***********	QUEUEVIEW	****************/
CREATE OR REPLACE VIEW QUEUEVIEW 
AS
	SELECT * FROM QUEUETABLE 
	UNION ALL 
	SELECT PROCESSDEFID, PROCESSNAME, PROCESSVERSION, PROCESSINSTANCEID, PROCESSINSTANCEID AS PROCESSINSTANCENAME,	ACTIVITYID, ACTIVITYNAME, PARENTWORKITEMID, WORKITEMID, PROCESSINSTANCESTATE, WORKITEMSTATE, STATENAME, 	QUEUENAME, QUEUETYPE, ASSIGNEDUSER, ASSIGNMENTTYPE, INSTRUMENTSTATUS, CHECKLISTCOMPLETEFLAG, INTRODUCTIONDATETIME,CREATEDDATETIME AS CREATEDDATETIME, INTRODUCEDBY, CREATEDBYNAME, ENTRYDATETIME, LOCKSTATUS, HOLDSTATUS, PRIORITYLEVEL, LOCKEDBYNAME, LOCKEDTIME, VALIDTILL, SAVESTAGE, PREVIOUSSTAGE, EXPECTEDWORKITEMDELAYTIME AS EXPECTEDWORKITEMDELAYTIME, EXPECTEDPROCESSDELAYTIME AS EXPECTEDPROCESSDELAYTIME, STATUS, VAR_INT1, VAR_INT2, VAR_INT3, VAR_INT4, VAR_INT5, VAR_INT6, VAR_INT7, VAR_INT8, VAR_FLOAT1, VAR_FLOAT2, VAR_DATE1, VAR_DATE2, VAR_DATE3, VAR_DATE4, VAR_LONG1, VAR_LONG2, VAR_LONG3, VAR_LONG4, VAR_STR1, VAR_STR2, VAR_STR3, VAR_STR4, VAR_STR5, VAR_STR6, VAR_STR7, VAR_STR8, VAR_REC_1, VAR_REC_2, VAR_REC_3, VAR_REC_4, VAR_REC_5, Q_STREAMID, Q_QUEUEID, Q_USERID, LASTPROCESSEDBY, PROCESSEDBY, REFERREDTO, REFERREDTONAME, REFERREDBY, REFERREDBYNAME, COLLECTFLAG, NULL AS COMPLETIONDATETIME, CALENDARNAME FROM QUEUEHISTORYTABLE

~

/***********	WFSEARCHVIEW_0	****************/
CREATE OR REPLACE VIEW WFSEARCHVIEW_0 
AS 
	SELECT QUEUEVIEW.ProcessInstanceId,QUEUEVIEW.QueueName,	QUEUEVIEW.ProcessName,
		ProcessVersion,QUEUEVIEW.ActivityName, statename,QUEUEVIEW.CheckListCompleteFlag,
		QUEUEVIEW.AssignedUser,QUEUEVIEW.EntryDATETIME,QUEUEVIEW.ValIdTill,QUEUEVIEW.workitemId,
		QUEUEVIEW.prioritylevel, QUEUEVIEW.parentworkitemId,QUEUEVIEW.processdefId,
		QUEUEVIEW.ActivityId,QUEUEVIEW.InstrumentStatus, QUEUEVIEW.LockStatus,
		QUEUEVIEW.LockedByName,QUEUEVIEW.CreatedByName,QUEUEVIEW.CreatedDatetime, 
		QUEUEVIEW.LockedTime, QUEUEVIEW.IntroductionDateTime,QUEUEVIEW.Introducedby ,
		QUEUEVIEW.AssignmentType, QUEUEVIEW.processinstancestate, QUEUEVIEW.queuetype ,
		Status ,Q_QueueId , EXTRACT('DAYS' FROM EntryDateTime - ExpectedWorkItemDelayTime) * 24 + EXTRACT('HOUR' FROM EntryDateTime - ExpectedWorkItemDelayTime) AS TurnaroundTime, 
		ReferredBy , ReferredTo ,ExpectedProcessDelayTime , ExpectedWorkItemDelayTime,  
		ProcessedBy ,  Q_UserId , WorkItemState 
	FROM QUEUEVIEW 

~

/***********	WFWORKINPROCESSVIEW_0	****************/
CREATE OR REPLACE VIEW WFWORKINPROCESSVIEW_0 
AS	SELECT WORKINPROCESSTABLE.ProcessInstanceId,WORKINPROCESSTABLE.ProcessInstanceId AS WorkItemName,
		WORKINPROCESSTABLE.ProcessdefId,ProcessName,ActivityId,ActivityName,PriorityLevel,InstrumentStatus,
		LockStatus,LockedByName,ValIdtill,CreatedByName,PROCESSINSTANCETABLE.CreatedDatetime,Statename,
		CheckListCompleteFlag,EntryDATETIME,LockedTime,IntroductionDateTime,Introducedby,AssignedUser,
		WORKINPROCESSTABLE.WorkItemId,QueueName,AssignmentType,ProcessInstanceState,QueueType,
		Status,Q_QueueId, EXTRACT('DAYS' FROM EntryDateTime - ExpectedWorkItemDelay) * 24 + EXTRACT('HOUR' FROM EntryDateTime - ExpectedWorkItemDelay) AS TurnaroundTime,
		ReferredByname,NULL AS ReferTo, guId,Q_userId 
	FROM  WORKINPROCESSTABLE,
	      PROCESSINSTANCETABLE,
	      QUEUEDATATABLE 
	WHERE WORKINPROCESSTABLE.ProcessInstanceId = QUEUEDATATABLE.ProcessInstanceId
	AND   WORKINPROCESSTABLE.WorkitemId = QUEUEDATATABLE.WorkitemId 
	AND   WORKINPROCESSTABLE.ProcessInstanceId = PROCESSINSTANCETABLE.ProcessInstanceId 

~

/***********	WFUSERVIEW	****************/
CREATE OR REPLACE VIEW WFUSERVIEW 
AS 
	SELECT * FROM PDBUSER

~

/***********	WFGROUPVIEW	****************/
CREATE OR REPLACE VIEW WFGROUPVIEW 
AS 
	SELECT groupindex, groupname, CreatedDatetime, expiryDATETIME, 
			privilegecontrollist, owner, comment as commnt, grouptype, maingroupindex 
	FROM PDBGROUP

~

/***********	WFSESSIONVIEW	****************/
CREATE OR REPLACE VIEW WFSESSIONVIEW 
AS 
	SELECT  RandomNumber AS SessionId, UserIndex AS UserId, UserLogINTime, 
		HostName AS Scope, MainGroupId, UserType AS ParticipantType,
		AccessDATETIME , StatusFlag, Locale 
	FROM PDBCONNECTION

~

/**** WFROUTELOGVIEW ****/
CREATE OR REPLACE VIEW WFROUTELOGVIEW
AS 
	SELECT * FROM WFCURRENTROUTELOGTABLE
	UNION ALL
	SELECT * FROM WFHISTORYROUTELOGTABLE

~

/*********** CREATE FUNCTIONS FOR Triggers ****************/
CREATE OR REPLACE FUNCTION WFUserDeletion() RETURNS TRIGGER AS '
BEGIN
	UPDATE WORKLISTTABLE 
	SET	AssignedUser = NULL, AssignmentType = NULL, LockStatus = ''N'', 
		LockedByName = NULL, LockedTime = NULL, Q_UserId = 0,
		QueueName = (SELECT QUEUEDEFTABLE.QueueName 
		FROM   QUEUESTREAMTABLE , QUEUEDEFTABLE
		WHERE  QUEUESTREAMTABLE.QueueID = QUEUEDEFTABLE.QueueID 
	AND	StreamID = Q_StreamID
	AND QUEUESTREAMTABLE.ProcessDefId = WORKLISTTABLE.ProcessDefId
	AND QUEUESTREAMTABLE.ActivityId = WORKLISTTABLE.ActivityId),
		QueueType = (SELECT QUEUEDEFTABLE.QueueType 
			FROM   QUEUESTREAMTABLE , QUEUEDEFTABLE
			WHERE  QUEUESTREAMTABLE.QueueID = QUEUEDEFTABLE.QueueID 
			AND    StreamID = Q_StreamID
			AND QUEUESTREAMTABLE.ProcessDefId = WORKLISTTABLE.ProcessDefId
			AND QUEUESTREAMTABLE.ActivityId = WORKLISTTABLE.ActivityId),
		Q_QueueID = (SELECT QueueId 
			FROM QUEUESTREAMTABLE 
			WHERE StreamID = Q_StreamID
			AND QUEUESTREAMTABLE.ProcessDefId = WORKLISTTABLE.ProcessDefId
			AND QUEUESTREAMTABLE.ActivityId = WORKLISTTABLE.ActivityId)	
	WHERE Q_UserId = OLD.UserIndex;
	UPDATE WORKLISTTABLE 
	SET	AssignedUser = NULL, AssignmentType = NULL, LockStatus = ''N'',
		LockedByName = NULL, LockedTime = NULL, Q_UserId = 0 
	WHERE  AssignmentType != ''F'' AND Q_UserId = OLD.UserIndex;
	DELETE FROM QUEUEUSERTABLE  
		WHERE  UserID = OLD.UserIndex 
		AND    Associationtype = 0;
	DELETE FROM USERPREFERENCESTABLE 
		WHERE  UserID = OLD.UserIndex;
	DELETE FROM USERDIVERSIONTABLE 
		WHERE  Diverteduserindex = OLD.UserIndex 
		OR     AssignedUserindex = OLD.UserIndex;
	DELETE FROM USERWORKAUDITTABLE 
		WHERE  Userindex = OLD.UserIndex 
		OR     Auditoruserindex = OLD.UserIndex;
	RETURN NULL; 
END;
' LANGUAGE 'plpgsql';

~

CREATE OR REPLACE FUNCTION WFLogPDBConnection() RETURNS TRIGGER AS '
DECLARE v_userName WFCurrentRouteLogTable.UserName%Type; 
BEGIN
	IF TG_OP = ''INSERT'' THEN	
		SELECT INTO v_userName userName FROM pdbuser WHERE userindex = new.userindex; 
		INSERT INTO WFCURRENTROUTELOGTABLE (ProcessDefId, ActivityId, ProcessInstanceId, WorkItemId, UserId, ActionId, ActionDateTime, AssociatedFieldId, 		AssociatedFieldName, ActivityName, UserName)VALUES(0, 0, NULL, 0, NEW.userindex, 23, CURRENT_TIMESTAMP, NEW.userindex, v_userName, NULL, v_userName); 
	ELSIF TG_OP = ''DELETE'' THEN 
		SELECT INTO v_userName userName FROM pdbuser WHERE userindex = OLD.userindex; 
		INSERT into WFCURRENTROUTELOGTABLE (ProcessDefId, ActivityId, ProcessInstanceId, WorkItemId, UserId, ActionId, ActionDateTime, AssociatedFieldId, AssociatedFieldName, ActivityName, UserName)VALUES(0, 0, NULL, 0, OLD.userindex, 24, CURRENT_TIMESTAMP, OLD.userindex, v_userName, NULL, v_userName); 
	END IF;
	RETURN NULL;
END;
' LANGUAGE 'plpgsql';


~
/*********** CREATE RULE ****************/
CREATE OR REPLACE RULE WFRuleWFSessionViewUpdate 
AS ON Update TO WFSessionView DO INSTEAD 
	UPDATE PDBConnection SET HostName = NEW.Scope, AccessDateTime = NEW.AccessDateTime, UserLoginTime = NEW.UserLoginTime, StatusFlag = NEW.StatusFlag WHERE RandomNumber = OLD.sessionid;

~

CREATE OR REPLACE RULE WFRuleWFSessionViewDelete 
AS ON Delete TO WFSessionView DO INSTEAD 
	DELETE FROM PDBConnection WHERE RandomNumber = OLD.SessionId;

~

/***********	CREATE TRIGGER	****************/

/***********	TR_USR_DEL	****************/

CREATE TRIGGER TR_USR_DEL 
AFTER DELETE ON PDBUSER FOR EACH ROW
	EXECUTE PROCEDURE WFUserDeletion();
~

/***********	TR_LOG_PDBCONNECTION	****************/

CREATE TRIGGER TR_LOG_PDBCONNECTION	
AFTER DELETE OR INSERT ON PDBCONNECTION FOR EACH ROW 
	EXECUTE PROCEDURE WFLogPDBConnection();

~
/***********	CREATE INDEX	****************/

/***********INDEX FOR WFCURRENTROUTELOGTABLE ****************/
CREATE INDEX  IDX1_WFRouteLogTable ON WFCURRENTROUTELOGTABLE (ProcessDefId, ActionId)

~

/***********INDEX FOR WFCURRENTROUTELOGTABLE ****************/
CREATE INDEX  IDX2_WFRouteLogTable ON WFCURRENTROUTELOGTABLE (ActionId, UserId)

~

/***********INDEX FOR WFCurrentRouteLogTable****************/
CREATE INDEX IDX3_WFRouteLogTable ON WFCurrentRouteLogTable (ProcessInstanceId)

~

/***********INDEX FOR WFCurrentRouteLogTable****************/
CREATE INDEX IDX4_WFCurrentRouteLogTable ON WFCurrentRouteLogTable (ProcessInstanceId, ActionDateTime, LogID)

~

/***********INDEX FOR WFHISTORYROUTELOGTABLE ****************/
CREATE INDEX  IDX1_WFHRouteLogTable ON WFHISTORYROUTELOGTABLE (ProcessDefId, ActionId)

~

/***********INDEX FOR WFHISTORYROUTELOGTABLE ****************/
CREATE INDEX  IDX2_WFHRouteLogTable ON WFHISTORYROUTELOGTABLE (ActionId, UserId)

~

/***********INDEX FOR WFHistoryRouteLogTable****************/
CREATE INDEX IDX3_WFHistoryRouteLogTable ON WFHistoryRouteLogTable (ProcessInstanceId)

~

/***********INDEX FOR WFHistoryRouteLogTable****************/
CREATE INDEX IDX4_HRouteLogTable ON WFHistoryRouteLogTable (ProcessInstanceId, ActionDateTime, LogID)

~

/***********Index for SUMMARYTABLE****************/
CREATE INDEX IDX1_SUMMARYTABLE ON SUMMARYTABLE  (processdefid, actionid)

~

/***********Index for SUMMARYTABLE****************/
CREATE INDEX IDX2_SUMMARYTABLE ON SUMMARYTABLE  (PROCESSDEFID, ACTIVITYID, USERID, ACTIONID, QUEUEID, ACTIONDATETIME)

~

/***********INDEX FOR QUEUEDATATABLE****************/
CREATE INDEX IDX1_QUEUEDATATABLE ON QUEUEDATATABLE (ChildProcessInstanceId, ChildWorkItemId)

~

/***********INDEX FOR WORKDONETABLE****************/
CREATE INDEX IDX1_WORKDONETABLE ON WORKDONETABLE (ProcessDefId) 

~

/***********INDEX FOR WFMessageInProcesstable****************/
CREATE INDEX IX1_WFMessageInProcessTable ON WFMessageInProcessTable (lockedBy)

~

/***********INDEX FOR WFEscalationTable****************/
CREATE INDEX IX1_WFEscalationTable ON WFEscalationTable (EscalationMode, ScheduleTime)

~

/***********INDEX FOR QueueDataTable****************/
CREATE INDEX IDX2_QueueDataTable ON QueueDataTable (var_rec_1, var_rec_2)

~

/***********INDEX FOR WorkListTable****************/
CREATE INDEX IDX1_WorkListTable ON WorkListTable (Q_QueueId)

~

/***********INDEX FOR WorkListTable****************/
CREATE INDEX IDX2_WorkListTable ON WorkListTable (Q_QueueId, WorkItemState)

~

/***********INDEX FOR WorkListTable****************/
CREATE INDEX IDX3_WorkListTable ON WorkListTable (Q_UserID)

~

/***********INDEX FOR WorkListTable****************/
CREATE INDEX IDX4_WorkListTable ON WorkListTable (ProcessDefId, ACTIVITYID)

~

/***********INDEX FOR WorkInProcessTable****************/
CREATE INDEX IDX1_WorkInProcessTable ON WorkInProcessTable (Q_QueueId)

~

/***********INDEX FOR WorkInProcessTable****************/
CREATE INDEX IDX2_WorkInProcessTable ON WorkInProcessTable (Q_QueueId, WorkItemState)

~

/***********INDEX FOR WorkInProcessTable****************/
CREATE INDEX IDX3_WorkInProcessTable ON WorkInProcessTable (ProcessDefId, ACTIVITYID)

~

/***********INDEX FOR WorkInProcessTable****************/
CREATE INDEX IDX4_WorkInProcessTable ON WorkInProcessTable (Q_UserId)

~

/***********INDEX FOR QueueStreamTable****************/
CREATE INDEX IDX1_QueueStreamTable ON QueueStreamTable (QueueId)

~

/***********INDEX FOR QueueStreamTable****************/
CREATE INDEX IDX2_QueueStreamTable ON QueueStreamTable (ProcessDefID, ActivityID, StreamId, QueueId)

~


/***********INDEX FOR QueueDefTable****************/
CREATE UNIQUE INDEX IDX1_QueueDefTable ON QueueDefTable (UPPER(QueueName))

~

/***********INDEX FOR VarMappingTable****************/
CREATE INDEX IDX1_VarMappingTable ON VarMappingTable (ProcessDefId, SystemDefinedName)

~

/***********INDEX FOR VarMappingTable****************/
CREATE INDEX IDX2_VarMappingTable ON VarMappingTable (UPPER(UserDefinedName))

~

/***********INDEX FOR WFMessageInProcessTable****************/
CREATE INDEX IX2_WFMessageInProcessTable ON WFMessageInProcessTable (messageId)

~

/***********INDEX FOR WFACTIVITYREPORTTABLE****************/
CREATE INDEX IDX1_WFActivityReportTable ON WFActivityReportTable (ProcessDefId, ActivityId, ActionDateTime)

~

/***********INDEX FOR WFREPORTDATATABLE****************/
CREATE INDEX IDX1_WFREPORTDATATABLE ON WFREPORTDATATABLE (PROCESSINSTANCEID, WORKITEMID, PROCESSDEFID, ACTIVITYID, USERID)

~

/***********INDEX FOR VarAliasTable****************/
CREATE INDEX IDX1_VarAliasTable ON VarAliasTable (QueueId, Id)

~

/***********INDEX FOR WFQuickSearchTable****************/
CREATE INDEX IDX1_WFQuickSearchTable ON WFQuickSearchTable (UPPER(Alias))

~

/***********INDEX FOR WFCommentsTable****************/
CREATE INDEX IDX1_WFCommentsTable ON WFCommentsTable (ProcessInstanceId, ActivityId)

~

/***********INDEX FOR WFDataMapTable****************/
CREATE INDEX IDX1_WFDataMapTable ON WFDataMapTable (ProcessDefId, ActivityId)

~

/***********INDEX FOR WFExportTable****************/
CREATE INDEX IDX1_WFExportTable ON WFExportTable (ProcessDefId, ActivityId)

~

/***********INDEX FOR ExceptionTable****************/
/* PostgreSQL doesnot support order by on indexed columns */
CREATE INDEX IDX1_ExceptionTable ON ExceptionTable (ProcessInstanceId, ProcessDefId, ActivityId, ExceptionId, excpseqid, ActionId)

~

/***********INDEX FOR ExceptionTable****************/
CREATE INDEX IDX2_ExceptionTable ON ExceptionTable (ProcessInstanceId)

~

/***********INDEX FOR ExceptionTable ****************/
CREATE INDEX IDX3_ExceptionTable  ON ExceptionTable  (Processdefid, ActivityId)

~

/***********INDEX FOR ExceptionHistoryTable****************/
/* PostgreSQL doesnot support order by on indexed columns */
CREATE INDEX IDX1_ExceptionHistoryTable ON ExceptionHistoryTable (ProcessInstanceId, ProcessDefId, ActivityId, ExceptionId, excpseqid, ActionId)

~

/***********INDEX FOR ExceptionHistoryTable****************/
CREATE INDEX IDX2_ExceptionHistoryTable ON ExceptionHistoryTable (ProcessInstanceId)

~

/***********INDEX FOR ActivityAssociationTable****************/
CREATE INDEX IDX1_ActivityAssociationTable ON ActivityAssociationTable (ProcessdefId, ActivityId, VariableId)

~

/***********INDEX FOR WFWSAsyncResponseTable****************/
CREATE INDEX IDX1_WFWSAsyncResponseTable ON WFWSAsyncResponseTable (CorrelationId1)

~

/***********INDEX FOR ActivityTable****************/
CREATE INDEX IDX1_ActivityTable ON ActivityTable (ActivityType)

~

/***********INDEX FOR QueueHistoryTable****************/
CREATE INDEX IDX2_QueueHistoryTable ON QueueHistoryTable (ACTIVITYNAME)

~

/***********INDEX FOR QueueHistoryTable****************/
CREATE INDEX IDX3_QueueHistoryTable ON QueueHistoryTable (VAR_REC_1, VAR_REC_2)

~

/***********INDEX FOR WorkWithPSTable****************/
CREATE INDEX IDX1_WorkWithPSTable ON WorkWithPSTable (Q_UserId)

~

/***********INDEX FOR PendingWorkListTable****************/
CREATE INDEX IDX2_PendingWorkListTable ON PendingWorkListTable (Q_UserId)

~

/***********INDEX FOR TODOSTATUSTABLE ****************/
CREATE INDEX IDX1_TODOSTATUSTABLE  ON TODOSTATUSTABLE  (PROCESSINSTANCEID)

~

/***********INDEX FOR TODOSTATUSHISTORYTABLE ****************/
CREATE INDEX IDX1_TODOSTATUSHISTORYTABLE  ON TODOSTATUSHISTORYTABLE  (PROCESSINSTANCEID)

~

CREATE INDEX IDX2_WORKDONETABLE ON WORKDONETABLE (ActivityName) 

~

CREATE INDEX IDX5_WorkInProcessTable ON WorkInProcessTable (ActivityName) 

~

CREATE INDEX IDX2_WorkWithPSTable ON WorkWithPSTable (ActivityName) 

~

CREATE INDEX IDX3_PendingWorkListTable ON PendingWorkListTable (ActivityName) 

~

CREATE INDEX IDX3_QueueStreamTable ON QueueStreamTable (Activityid, Streamid)