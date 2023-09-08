/*____________________________________________________________________________________________________
			NEWGEN SOFTWARE TECHNOLOGIES LIMITED
		Group					: Genesis
		Product / Project		: iBPS 3.0
		Module					: iBPS Server
		File Name				: OFCabCreation.sql
		Author					: Mohnish Chopra
		Date written(DD/MM/YYYY): 04/05/2016
		Description				: Script for cabinet creation for PostgreSQL .
____________________________________________________________________________________________________
			CHANGE HISTORY
____________________________________________________________________________________________________
Date(DD/MM/YYYY)  Change By			Change Description (Bug No. (If Any))
10/03/2017     	  Sajid Khan             Bug 67568 - Deletion of Audit Logs after audit trail archieve. 
18/4/2017       Kumar Kimil     Bug-64498 MailTo column size need to be increased in WFMailQueueTable&WFMailQueueHistoryTable
19/4/2017       Kumar Kimil     Bug 64096 - Support to send the notification by Email when workitem is suspended abnormally due to some error
19/04/2017		Sajid Khan		CreateWebService column added to ProcessDefTable on the basis of which a webservice would be created or not  .
28-02-2017		Sajid Khan		Merging Bug 59122 - In OFServices registered utilities should only be accessible to that app server from which it is registered    
05-05-2017		Sajid Khan		Merging Bug 55753 - Provided option to add Comments while ad-hoc routing of Work Item in process manager
05-05-2017		Sajid Khan		Merging  Bug 58399 - Need an option to view refer, reassign and ad-hoc routing comments in workitem properties
06/05/2017	Mohnish Chopra  PRDP Bug (59917, 56692)- Support for Bulk PS
09-05-2017		Sajid Khan		Queue Varaible Extension  
23/05/2017     Kumar Kimil      Transfer Data for IBPS(Transaction Tables including Case Management)
04/07/2017	Shubhankur Manuja	Added new comment type in WFCOMMENTSTABLE for storing comments entered by user at the time of rejecting the task.
07/07/2017		Ambuj Tripathi  Added changes for the case management (WFReassignTask API) in WFCommentsTable and WFTastStatusTable
18/07/2017        Kumar Kimil     Multiple Precondition enhancement
01/08/2017     Kumar Kimil        Multiple Precondition enhancement(Review Changes)
14/08/2017		Ambuj Tripathi  Added changes for the Task Expiry and task escalation in Case Management
21/08/2017		Ambuj Tripathi  Added changes for the Task escalation in WFEscInProcessTable table
21/08/2017      Kumar Kimil    Process Task Changes(Synchronous and Asynchronous)
30/08/2017		Sajid Khan		PRDP Bug 69029 - Need to send escalation mail after every defined time
31/08/2017		Sajid Khan		WF_UTIL_UNREGISTER Trigger created.
25/08/2017		Ambuj Tripathi  Added Table WFTaskUserAssocTable for UserGroup feature in case Management
29/08/2017		Ambuj Tripathi  Added Table changes in WFTaskstatustable for task approval feature.
22/09/2017      Kumar Kimil     TransferData changes for Ibps3.2
27/09/2017      Ambuj Tripathi  Changes for Bug#71671 in WFEventDetailsTable
04/10/2017      Ambuj Tripathi  Changes done for UT Bug fixes
04/10/2017      Ambuj Tripathi  Changes done for Bug 72218 - EAp 6.2+SQl:- Task Preferences functionality not working.
09/10/2017      Ambuj Tripathi  Bug 72452 - Removed the primary key from WFTaskUserAssocTable
16/09/2017		Ambuj Tripathi	Case registeration Name changes requirement- Columns added in processdeftable and wfinstrumenttable
30/10/2017		Ambuj Tripathi	Bug#72966 Added the revoke comment type in WFCommentsTable and WFCommentsHistoryTable.
17/11/2017      Kumar Kimil     Bug 73520 - weblogic+oracle: Queue name is not getting changed when maker checker request is approved
22/11/2017        Kumar Kimil     Multiple Precondition enhancement
08/12/2017		Ambuj Tripathi	Bug#73125 - Getting unnecessary error message while un-registering server
08/12/2017		Mohnish Chopra	Prdp Bug 71731 - Audit log generation for change/set user preferences
12/12/2017		Sajid Khan		Bug 73913	Rest Ful webservices implementation in iBPS
11/01/2018		Mohd Faizan		Bug 74212 - Inactive user is not showing in Rights Management while it showing in Omnidocs admin
05/02/2018        Kumar Kimil     Bug 75720 - Arabic:-Incorrect validation message displayed on importing document on case workitem
20/04/2018      Ambuj Tripathi     Bug 77151 - Not able to Deploy process getting error "Requested operation failed"
14/05/2018	Ambuj Tripathi	PRD Bug 77201 - EAP6.4+SQL: Generate response template should be generated in pdf or doc based on defined format type in process definition
22/05/2018		Ambuj Tripathi	Reverting PRD Bug 77201 changes
30/05/2018	Ambuj Tripathi	Creating index on URN (used in search APIs)
13/08/2018		Ambuj Tripathi	Fixing cab creation issue for upgrading from OD to OD + iBPS from OFServices
28/08/2019		Ambuj Tripathi	Sharepoint related changes - inserting default property into systemproperties table.
25/01/2019		Ravi Ranjan Kumar Bug 82440 - Required to change the exception comments length form 512 to 1024 (PRDP Bug Merging)
29/01/2019	Ravi Ranjan Kumar Bug Bug 82718 - User able to view & search iBps WF system folders .
11-03-2019	Ravi Ranjan			Bug 83511 - PRDP bug merging (Support of multiple image cabinets for archived workitems(Queuehistorytable))
22/03/2019	Mohnish Chopra		Bug 83717 - Support is required to move/save external variables and complex variables data to Secondary cabinet based on some flag SecondaryDBFlag
8/04/2019	Ravi Ranjan Kumar		Bug 83490 - PRDP Bug Metging (Audit Archive utility gets stuck if an error occurs in processing a record)
30/04/2019      Ravi Ranjan Kumar   PRDP Bug Mergin (Bug 83894 - Support to define explicit History Table for the external table instead of hardcoded '_History')
6/7/2019		Ravi Ranjan Kumar 	Bug 85140 - Enabling to edit workitem (only data and document ) on query workstep if workitem is present on end workstep 
//25/10/2019	Internal Bug fix for LIC Production issue - Arithmetic overflow exception coming for count fields in summary tables and other report tables.
//25/10/2019		Ambuj Tripathi	Landing page (Criteria Management) Requirement.
27/12/2019		Chitranshi Nitharia	Bug 89384 - Support for global catalog function framework
02/01/2019		Shahzad Malik		Bug 89626 - Required to reduce fragmentation in UserQueueTable
24/01/2020		Chitranshi Nitharia	Bug 90094 - Creation Of Utility User Via API instead of scripts
06/02/2020		Ambuj Tripathi Bug 90553 - Asynchronous+Jboss-eap-7.2+MSSQL : Data Exchange utility is not working
16/04/2020		Chitranshi Nitharia	Bug 91524 - Framework to manage custom utility via ofservices
21/04/2020		Ravi Ranjan Kumar 	Bug 91844 - Support For Process wise volume id. When User deploying the process, then their workitem folder and document upload or created in the volume which is selected by user at the time of process design
08/07/2020	Ravi Ranjan Kumar Bug 93100 - Unable to save process after registering the RestWebservice,Getting error "The requested filter is invalid.
15/07/2020	Ravi Ranjan Kumar		Bug 93293 - RPA: Unable to save web activity process, it gives error "The Requested Operation Failed."
29/01/2020      Sourabh Tantuway    Bug 93812 - iBPS 5.0 SP1: Requirement for get SAP user credentials based on process variable value. This mapped variable will contain the username of the user, whose details are to be fetched
08/04/2020      Sourabh Tantuway    Bug 93899 - AlternateMessage column is missing in WFMAILQUEUEHISTORYTABLE
29/01/2021 Sourabh Tantuway    Bug 97518 - iBPS 4.0 + Asynchronous : WMCreateworkitem API in Process Server is getting failed if escalation criteria is containing mailTo list above length 256.
28/05/2021    Chitranshi Nitharia Bug 99590 - Handling of master user preferences with userid 0.
02/07/2021      Ravi Raj Mewara     Bug 100086 - IBPS 5 Sp2 Performance : WMFetchWorklist taking 35 40 secs for fetching queues
19/10/2021		Vardaan Arora		Bug 102127 - In User list or Group List ,Only those Users should be fetched whose parent group is same as that of logged in user.
11/02/2022		Ashutosh Pandey		Bug 105376 - Support for sorting on complex array primitive member
11/02/2022		Vardaan Arora		Bug 105448 - Trigger (TR_USR_DEL) which is used to release work-items on user deletion is not working properly
18/06/2023 Satyanarayan Sharma Bug 124581 - iBPS5.0SP3+Postgre-----In WFATTRIBUTEMESSAGETABLE and WFATTRIBUTEMESSAGEHISTORYTABLE for ActionDateTime column datatype changed from DATE to TIMESTAMP.
____________________________________________________________________________________________
*/

/**** CREATE TABLE ****/


CREATE TABLE WFCabVersionTable (
	cabVersion		VARCHAR(255)	NOT NULL,
    cabVersionId    SERIAL			PRIMARY KEY,
	creationDate	TIMESTAMP,
	lastModified	TIMESTAMP,
	Remarks			VARCHAR(255)	NOT NULL,
	Status			VARCHAR(1)
)

~

/* SrNo-7, Calendar Implementation - Ruhi Hira */
/******   PROCESSDEFTABLE    ******/
CREATE TABLE PROCESSDEFTABLE(
	ProcessDefId			INTEGER,
	VersionNo				INTEGER				NOT NULL,
	ProcessName				VARCHAR(30)			NOT NULL,
	ProcessState			VARCHAR(10)			NULL,
	RegPrefix				VARCHAR(20)			NULL,
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
	CreatedBy		VARCHAR(255)				NULL,
	LastModifiedBy	VARCHAR(255)	NULL,
	ProcessShared	NCHAR(1)		NULL,
	ProjectId		INTEGER				NULL,
	Cost			NUMERIC(15, 2)	NULL ,
	Duration		VARCHAR(255)	NULL,
	FormViewerApp	NCHAR(1)		Default N'J' NOT NULL,
	ProcessType 	VARCHAR(1) 	Default N'S' NOT NULL,
	OWNEREMAILID    VARCHAR(255),
	ThresholdRoutingCount 		INTEGER,
	CreateWebService	VARCHAR(2),
	DisplayName		VARCHAR(20)	NULL,
	ISSecureFolder CHAR(1) DEFAULT 'N' NOT NULL CONSTRAINT CK_ISSecureFolder CHECK (ISSecureFolder IN ('Y', 'N')),
	VolumeId  		INT				NULL,
	SiteId 			INT				NULL,
	PRIMARY KEY ( ProcessDefId , VersionNo )
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

CREATE TABLE INTERFACEDEFTABLE(
	InterfaceId			INTEGER			PRIMARY KEY,
	InterfaceName		VARCHAR(255)	NOT NULL, 
	ClientInvocation	VARCHAR(255)	NULL, 
	ButtonName			VARCHAR(50)		NULL, 
	MenuName			VARCHAR(50)		NULL, 
	ExecuteClass		VARCHAR(255)	NULL,
	ExecuteClassWeb		VARCHAR(255)	NULL 
)
/******   PROCESS_INTERFACETABLE    ******/

~
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
	Description				TEXT 		NULL,
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
	ActivitySubType		 INT	NULL,
	Color				 INT	NULL,
	Cost				 NUMERIC(15, 2)	NULL ,
	Duration		 	 VARCHAR(255)	NULL,
	SwimLaneId			 INT	NULL,
	DummyStrColumn1 	 VARCHAR(255)	NULL,
	CustomValidation 	 TEXT,	
	MobileEnabled			VARCHAR(1),
	GenerateCaseDoc			varchar(1) NOT NULL DEFAULT N'N',
		DoctypeId 			 INTEGER    NOT NULL DEFAULT -1,
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
	Param1				VARCHAR(255) 	NOT NULL,
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
	Param1				VARCHAR(255)   	NOT NULL, 
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
	AnnotationId			INT			NULL,
	SwimLaneId				INT			NULL	   	
)

~

/******   WORKSTAGELINKTABLE    ******/

CREATE TABLE WORKSTAGELINKTABLE(
	ProcessDefId 	INTEGER 	NOT NULL,
	SourceId 		INTEGER 	NOT NULL,
	TargetId 		INTEGER 	NOT NULL,
	Color 			INTEGER		NULL,
	Type 			VARCHAR(1)	NULL,
	ConnectionId	INTEGER			NULL
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
	ProcessVariantId INT DEFAULT(0) NOT NULL,
	IsEncrypted         VARCHAR(1)    DEFAULT N'N' NULL,
	IsMasked           	VARCHAR(1)	  DEFAULT N'N' NULL,
	MaskingPattern      VARCHAR(10)   DEFAULT N'X' NULL,
	CONSTRAINT Ck_VarMappin_VarScope CHECK(VariableScope = 'M' OR (VariableScope = 'I' OR (VariableScope = 'U' OR (VariableScope = 'S')))),
	PRIMARY KEY(ProcessDefId,VariableId,ProcessVariantId)	
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
	ProcessVariantId 	INT DEFAULT 0 NOT NULL,
	PRIMARY KEY(ProcessDefId, ActivityId, DefinitionType, DefinitionId,ProcessVariantId	),
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
	ClassName			VARCHAR(255)		NOT NULL,
	ExecutableClass		VARCHAR(255)	NULL,
	HttpPath			VARCHAR(255)	NULL,
	PRIMARY KEY(ProcessdefId, TypeName)
)

~

/******   MAILTRIGGERTABLE    ******/
/*****DOUBT*****/
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
   	BCCUser 			VARCHAR(255)		NULL,
	BCCTYPE 			VARCHAR(255)		Default 'C' NULL,
	EXTOBJIDBCC 		INTEGER					NULL,
	VARIABLEIDBCC 		INTEGER					NULL,	
	VARFIELDIDBCC 		INTEGER					NULL,
	MailPriority 		VARCHAR(255)		NULL,
	MailPriorityType 	VARCHAR(255)		Default 'C',
	ExtObjIdMailPriority INTEGER, 
	VariableIdMailPriority INTEGER,
	VarFieldIdMailPriority INTEGER,
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
	Param1			VARCHAR(255)		NOT NULL,
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
    SortingColumn	VARCHAR(255)	NULL,
	ProcessVariantId INT DEFAULT 0 NOT NULL,
	HistoryTableName 		VARCHAR(255)	NULL, 
	PRIMARY KEY(ProcessDefId, ExtObjId,ProcessVariantId)
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
	ExportStatus				VARCHAR(1) DEFAULT 'N',
	ProcessVariantId 			INT DEFAULT 0  NOT NULL,
	ActivityType				INT NULL,
	lastModifiedTime				TIMESTAMP		NULL , 
	VAR_DATE5		TIMESTAMP		NULL ,
	VAR_DATE6		TIMESTAMP		NULL ,
	VAR_LONG5		INTEGER		NULL ,
	VAR_LONG6		INTEGER		NULL ,
	VAR_STR9		VARCHAR(512)  NULL ,
	VAR_STR10		VARCHAR(512)  NULL ,
	VAR_STR11		VARCHAR(512)  NULL ,
	VAR_STR12		VARCHAR(512)  NULL ,
	VAR_STR13		VARCHAR(512)  NULL ,
	VAR_STR14		VARCHAR(512)  NULL ,
	VAR_STR15		VARCHAR(512)  NULL ,
	VAR_STR16		VARCHAR(512)  NULL ,
	VAR_STR17		VARCHAR(512)  NULL ,
	VAR_STR18		VARCHAR(512)  NULL ,
	VAR_STR19		VARCHAR(512)  NULL ,
	VAR_STR20		VARCHAR(512)  NULL ,
	ChildProcessInstanceId		VARCHAR(63)	NULL,
	ChildWorkitemId				INT,
	FilterValue					INT		NULL ,
	Guid 						BIGINT,
	NotifyStatus				VARCHAR(1),
	Q_DivertedByUserId   		INT NULL,
	RoutingStatus				VARCHAR(1) ,
	NoOfCollectedInstances		INT DEFAULT 0,
	Introducedbyid				INT		NULL ,
	IntroducedAt				VARCHAR(30)	 NULL ,
	Createdby					INT		 NULL ,
	IsPrimaryCollected			VARCHAR(1) NULL CHECK (IsPrimaryCollected IN (N'Y', N'N')),
	URN					VARCHAR (63)  	NULL,
	IMAGECABNAME    VARCHAR(100),
	SecondaryDBFlag	VARCHAR(1)      Default 'N'  NOT NULL CHECK (SecondaryDBFlag IN (N'Y', N'N',N'U',N'D')),
	ManualProcessingFlag	VARCHAR(1)    DEFAULT 'N' NOT NULL ,
	DBExErrCode     			int       		NULL,
	DBExErrDesc     			VARCHAR(255)	NULL,
	Locale						varchar(30)	NULL,
	ProcessingTime 				INT,
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
	Format			   VARCHAR(255) NULL,
	InputFormat		   VARCHAR(10) NULL,
	Tools			   VARCHAR(20) NULL,
	DateTimeFormat 	   VARCHAR(50) NULL,
	PRIMARY KEY (ProcessdefId,TemplateId)
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
	PRIMARY KEY (ProcessDefId, ExtObjId, FieldName)
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
	ProcessName			VARCHAR(30)		NULL,
    LastModifiedOn  TIMESTAMP    NULL,
	CONSTRAINT u_qdttable  Unique(QueueName) 
) 

~
/******   QUEUEUSERTABLE ******/

CREATE TABLE QUEUEUSERTABLE(
	QueueId 				INTEGER 		NOT NULL,
	UserId 					INTEGER 		NOT NULL,
	ASsociationType 		INTEGER 		NOT NULL,
	ASsignedTillDATETIME	TIMESTAMP		NULL, 
	QueryFilter				VARCHAR(2000)	NULL,
	QueryPreview		VARCHAR(1) DEFAULT 'Y' NULL,
	RevisionNo		INT,
	EDITABLEONQUERY		VARCHAR(1) DEFAULT 'N' NOT NULL,
	PRIMARY KEY(QueueId, UserId, AssociationType)
	
)  

~

CREATE SEQUENCE PSID	
	INCREMENT BY 1 START WITH 10000000
 
~
/******   PSREGISTERATIONTABLE   ******/

CREATE TABLE PSREGISTERATIONTABLE(
	PSId 			INTEGER NOT NULL DEFAULT nextval('PSID') 			,
	PSName			VARCHAR(126) 	NOT NULL,
	Type			VARCHAR(1) 		NOT NULL DEFAULT 'P' CHECK(Type = 'C' OR Type = 'P'),
	SessionId 		INTEGER			NULL,
	ProcessdefId 	INTEGER			NULL,
	data			VARCHAR(2000)	NULL,
	BULKPS 			VARCHAR (1) NULL,
	CONSTRAINT Uk_PSRegisterationTable UNIQUE(SessionId),
	PRIMARY KEY(PSName, Type)
)

~

/******   USERDIVERSIONTABLE    ******/

CREATE TABLE USERDIVERSIONTABLE(
	DiversionId INTEGER,
	Processdefid INTEGER,
	ProcessName	VARCHAR(30),
	ActivityId INTEGER,
	ActivityName VARCHAR(30), 
	DivertedUserIndex 		INTEGER NOT NULL, 
	DivertedUserName		VARCHAR(64), 
	AssignedUserindex 		INTEGER NOT NULL, 
	AssignedUserName		VARCHAR(64), 
	FromDate				TIMESTAMP, 
	ToDate					TIMESTAMP, 
	CurrentWorkItemsFlag 	VARCHAR(1) CHECK(CurrentWorkItemsFlag  IN ('Y', 'N')),
	CONSTRAINT Pk_UserDiversion PRIMARY KEY(DivertedUserIndex, AssignedUserIndex, FromDate) 
)

~

/******   USERWORKAUDITTABLE    ******/

CREATE TABLE USERWORKAUDITTABLE( 
	Userindex			INTEGER NOT NULL, 
	Auditoruserindex 	INTEGER NOT NULL, 
	Percentageaudit 	INTEGER ,
	AuditActivityId		INTEGER, 
	WorkItemCount		VARCHAR(100),
	ProcessDefId		INTEGER,
	CONSTRAINT Pk_UserWrkAudit PRIMARY KEY(UserIndex, AuditorUserIndex, AuditActivityId, ProcessDefId)
)

~

/******   PREFERREDQUEUETABLE    ******/

CREATE TABLE PREFERREDQUEUETABLE( 
	userindex 		INTEGER  NOT NULL, 
	queueindex 		INTEGER,
	CONSTRAINT Pk_PreferredQueueTable PRIMARY KEY(userIndex, queueIndex) 
)

~

/******   USERPREFERENCESTABLE     ******/

CREATE TABLE USERPREFERENCESTABLE(
	UserId 				INTEGER NOT NULL,
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
	IsParentArchived NCHAR(1) DEFAULT 'N',
	IsChildArchived NCHAR(1) DEFAULT 'N',
	TaskId integer not  null default 0,
	PRIMARY KEY(ChildProcessInstanceId, ParentProcessInstanceId)
) 

~

/******   VARALIASTABLE     ******/

CREATE TABLE VARALIASTABLE(
 	Id				SERIAL			NOT NULL,	
	AliAS   		VARCHAR(63) 	NOT NULL,
 	ToReturn  		VARCHAR(1)  	NOT NULL CHECK (ToReturn IN ('Y','N')),
 	Param1  		VARCHAR(50)  	NOT NULL,
 	Type1  			INTEGER   	NULL ,
 	Param2 			VARCHAR(255)  	NULL,
 	Type2 			VARCHAR(1)   	NULL CHECK (Type2 IN ('V','C')),
 	Operator 		INTEGER   		NULL, 
	QueueId			INTEGER			NOT NULL,
	ProcessDefId	INTEGER		NOT NULL DEFAULT 0,
    AliasRule       VARCHAR(2000)      NULL,
	VariableId1		INTEGER			DEFAULT 0 NOT NULL,
	DisplayFlag		VARCHAR(1) NOT NULL CHECK (DisplayFlag IN ('Y','N')),
	SortFlag		VARCHAR(1) NOT NULL CHECK (SortFlag IN ('Y','N')),
	SearchFlag		VARCHAR(1) NOT NULL CHECK (SearchFlag IN ('Y','N')),
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
	ImportedProcessDefId	INT				NULL
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
	ImportedProcessDefId	INT				NULL,
	ProcessType			VARCHAR(1)		DEFAULT (N'R') NULL   
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
 	FaxFlag 			VARCHAR(1) 		NULL DEFAULT ('N'),
	TaskId          	INTEGER   DEFAULT 0 NOT NULL ,
 	SubTaskId       	INTEGER   DEFAULT 0 NOT NULL 
) 

~


CREATE TABLE WFMultiLingualTable (
	EntityId			INTEGER						NOT NULL,
	EntityType			INTEGER						NOT NULL,
	Locale				VARCHAR(20)			NOT NULL,
	EntityName			VARCHAR(255)			NOT NULL,
	ProcessDefId		INTEGER						NOT NULL,
	ParentId			INTEGER						NOT NULL,
	fieldname 			VARCHAR(1000) NULL,
	PRIMARY KEY (EntityId, EntityType, Locale, ProcessDefId, ParentId)
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
	TaskId 				SERIAL		PRIMARY KEY   NOT NULL ,
	mailFrom 			VARCHAR(255),
	mailTo 				VARCHAR(2000), 
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
	TaskId 				INTEGER	,
	mailFrom 			VARCHAR(255),
	mailTo 				VARCHAR(2000), 
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
	alternateMessage 	TEXT			NULL	
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
	Param1					VARCHAR(255)		NOT NULL,
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
	Param1				VARCHAR(255)		NULL,
	Type1				VARCHAR(1)		NOT NULL,
	Param2				VARCHAR(255)	NULL,
	Type2				VARCHAR(1)		NOT NULL,
	Param3				VARCHAR(255)	NULL,
	Type3				VARCHAR(1)		NULL,
	Operator			INTEGER			NULL,
	OperationOrderId	INTEGER         NOT NULL,
	CommentFlag			VARCHAR(1)		NOT NULL,
	ExtObjId1			INTEGER			NULL,
	VariableId_1		INTEGER			NULL,
	VarFieldId_1		INTEGER			NULL,
	ExtObjId2			INTEGER			NULL,
	VariableId_2		INTEGER			NULL,
	VarFieldId_2		INTEGER			NULL,
	ExtObjId3			INTEGER			NULL,
	VariableId_3		INTEGER			NULL,
	VarFieldId_3		INTEGER			NULL,
	ActionCalFlag		VARCHAR(1)		NULL
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
	TriggerName             VARCHAR(255)	NULL,
	ProcessVariantId 		INTEGER 	DEFAULT 0 NOT NULL
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
	SecurityFlag			VARCHAR(1)		CHECK(SecurityFlag IN ('Y', 'N','y','n')),
	ArchiveDataClassName    VARCHAR(255)	NULL,
	DeleteAudit				VARCHAR(1) 		Default 'N'
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
	VarFieldId				INTEGER			NULL,
	DataFieldType			INTEGER			NULL
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
	Param1				VARCHAR(255)		NOT NULL,
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
	ActivityId				INTEGER				NULL,
	SwimlaneId				INTEGER				NULL,
	UserId					INTEGER				NULL
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
	PRIMARY KEY (ProcessDefID, ToDoId)
)

~

/***********	TODOPICKLISTTABLE	****************/

CREATE TABLE TODOPICKLISTTABLE(
	ProcessDefId	INTEGER		NOT NULL,
	ToDoId			INTEGER		NOT NULL,
	PickListValue	VARCHAR(50)	NOT NULL,
	PickListOrderId INTEGER		 NULL,
	PickListId INTEGER NOT NULL,
	CONSTRAINT PK_TODOPICKLISTTABLE PRIMARY KEY(ProcessDefId,ToDoId,PickListId)
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
	Description         VARCHAR(1024)   NOT NULL,
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
	ExceptionComments       VARCHAR(1024)	NULL
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
	ExceptionComments       VARCHAR(1024)	NULL
)

~

/***********	DOCUMENTTYPEDEFTABLE	****************/

CREATE TABLE DOCUMENTTYPEDEFTABLE(
	ProcessDefId	INTEGER			NOT NULL,
	DocId			INTEGER			NOT NULL,
	DocName			VARCHAR(50)		NOT NULL,
	DCName 			VARCHAR(64)		NULL,
	ProcessVariantId INTEGER DEFAULT 0 NOT NULL,
	DocType			VARCHAR(1)		NOT NULL DEFAULT 'D',
	PRIMARY KEY (ProcessDefId, DocId, ProcessVariantId)
)

~

/***********	PROCESSINITABLE	****************/

CREATE TABLE PROCESSINITABLE(
	ProcessDefId	INTEGER		NOT NULL ,
	ProcessINI		TEXT			NULL,
	CONSTRAINT PK_ProcessINITable PRIMARY KEY(ProcessDefId)
)

~

/***********	ROUTEFOLDERDEFTABLE	****************/

CREATE TABLE ROUTEFOLDERDEFTABLE(
	ProcessDefId            INTEGER         PRIMARY KEY,
	CabinetName             VARCHAR(50)		NOT NULL,
	RouteFolderId           VARCHAR(255)         NOT NULL,
	ScratchFolderId         VARCHAR(255)         NOT NULL,
	WorkFlowFolderId        VARCHAR(255)         NOT NULL,
	CompletedFolderId       VARCHAR(255)         NOT NULL,
	DiscardFolderId         VARCHAR(255)         NOT NULL 
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
    Message                 TEXT			 NULL,
	Subject                 VARCHAR(255)  NULL,
	BCCMAILID 				VARCHAR(255) NULL,
	BCCMAILIDTYPE 			VARCHAR(1) NULL,
	EXTBCCMAILID 			INTEGER ,
	VARIABLEIDBCC 			INTEGER ,
	VARFIELDIDBCC 			INTEGER ,
	MailPriority 			VARCHAR(255) ,
	MailPriorityType 		VARCHAR(255) ,
	ExtObjIdMailPriority 	INTEGER ,
	VariableIdMailPriority  INTEGER ,
	VarFieldIdMailPriority  INTEGER ,
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
	LastModifiedOn			TIMESTAMP,
	DeviceType				VARCHAR(1)  DEFAULT 'D',
	FormHeight				INTEGER NOT NULL DEFAULT 100,
	FormWidth				INTEGER  NOT NULL DEFAULT 100,
	ProcessVariantId 		INTEGER DEFAULT 0  NOT NULL,  
	ExistingFormId			INTEGER	NULL,
	FormType varchar(1) default 'P' not null ,
	CONSTRAINT PK_WFFORM_TABLE PRIMARY KEY(ProcessDefID,FormId,DeviceType)
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
	totalwicount		bigint,
	ActionDatetime		TIMESTAMP,
	actionId			INTEGER,
	totalduration		bigint,
	reporttype			VARCHAR(1),
	totalprocessingtime	bigint,
	delaytime			bigint,
	wkindelay			bigint,
	AssociatedFieldId	INTEGER,
	AssociatedFieldName	VARCHAR(2000),
	ProcessVariantId INTEGER DEFAULT 0 NOT NULL
)

~
/***********	WFMESSAGETABLE	****************/

CREATE TABLE WFMESSAGETABLE(
	messageId 			SERIAL		PRIMARY KEY, 
	message				VARCHAR(2000)		NOT NULL, 
	lockedBy			VARCHAR(63), 
	status 				VARCHAR(1)	CHECK(status IN ('N', 'F')),
	ActionDateTime		TIMESTAMP
)

~
CREATE TABLE WFATTRIBUTEMESSAGETABLE ( 
	ProcessDefID		INTEGER		NOT NULL,
	ProcessVariantId 		INTEGER DEFAULT 0  NOT NULL, 
	ProcessInstanceID	VARCHAR (63)  NOT NULL ,
	WorkitemId		    INTEGER		NOT NULL,
	MESSAGEID		Serial NOT NULL, 
	MESSAGE			TEXT NOT NULL, 
	LOCKEDBY		VARCHAR(63), 
	STATUS			VARCHAR(1) CHECK (status in ('N', 'F')), 
	ActionDateTime	TIMESTAMP,  
	CONSTRAINT PK_WFATTRIBUTEMESSAGETABLE2 PRIMARY KEY (MESSAGEID ) 
)
~
CREATE TABLE WFATTRIBUTEMESSAGEHISTORYTABLE ( 
	ProcessDefID		INTEGER		NOT NULL,
	ProcessVariantId 		INTEGER DEFAULT 0  NOT NULL, 
	ProcessInstanceID	VARCHAR (63)  NOT NULL ,
	WorkitemId		    INTEGER		NOT NULL,
	MESSAGEID		INTEGER NOT NULL, 
	MESSAGE			TEXT NOT NULL, 
	LOCKEDBY		VARCHAR(63), 
	STATUS			VARCHAR(1) CHECK (status in ('N', 'F')), 
	ActionDateTime	TIMESTAMP,  
	CONSTRAINT PK_WFATTRIBUTEMESSAGEHISTORYTABLE PRIMARY KEY (MESSAGEID ) 
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
	ExtAppType			VARCHAR(1)		NOT NULL CHECK(ExtAppType IN ('E', 'W', 'S', 'Z', 'B','R')), 
	ExtMethodName		VARCHAR(64)		NOT NULL, 
	SearchMethod		VARCHAR(255)	NULL, 
	SearchCriteria		INTEGER 		NULL,
	ReturnType			INTEGER			CHECK(ReturnType IN (0,3,4,6,8,10,11,12,14,15,16)),
	MappingFile			VARCHAR(1),
    ConfigurationID     INTEGER     NULL,
	AliasName  		VARCHAR(100) NULL,
	DomainName 		VARCHAR(100) NULL,
	Description  	VARCHAR(2000) NULL,
	ServiceScope 	VARCHAR(1) NULL,
	IsBRMSService	VARCHAR(1) NULL,
	PRIMARY KEY(ProcessDefId, ExtMethodIndex)
)

~

/************* EXTMETHODPARAMDEFTABLE **************/
/*Rest Implementation Changes
                    A—                      (unbounded value will always be ‘Y’ or ‘N’)
                          B --                (unbounded value will always be ‘M’ – Non array child  or ‘P’—array child)
                                B1           (unbounded value will always be ‘M’ – Non array child  or ‘P’—array child)
                                B2           (unbounded value will always be ‘M’ – Non array child  or ‘P’—array child)
                     B--                       (unbounded value will always be ‘Z’ – Nested structure created as Array or ‘X’— Nested structure created as 	Non Array )
                          B1                 (unbounded value will always be ‘Z’ – Nested structure child created as Array or ‘X’— Nested structure child  created  as Non Array )
                          B2                 (unbounded value will always be ‘Z’ – Nested structure child  created as Array or ‘X’— Nested structure child  created as Non Array )
 
*/
CREATE TABLE EXTMETHODPARAMDEFTABLE(
	ProcessDefId		INTEGER		NOT NULL, 
	ExtMethodParamIndex	INTEGER		NOT NULL,
	ExtMethodIndex		INTEGER		NOT NULL,
	ParameterName		VARCHAR(64),
	ParameterType		INTEGER	CHECK(ParameterType IN (0, 3, 4, 6, 8, 10, 11, 12, 14, 15 ,16,18)),
	ParameterOrder		INTEGER,
	DataStructureId		INTEGER	,
	ParameterScope		VARCHAR(1),
	Unbounded			VARCHAR(1) 	NOT NULL DEFAULT N'N' CHECK (Unbounded IN (N'Y' , N'N',N'X',N'Z',N'M',N'P')),
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
	message				VARCHAR(2000), 
	lockedBy			VARCHAR(63), 
	status				VARCHAR(1),
	ActionDateTime		TIMESTAMP
)

~

/***********	WFFailedMessageTable	****************/

CREATE TABLE WFFailedMessageTable(
	messageId			INTEGER, 
	message				VARCHAR(2000), 
	lockedBy			VARCHAR(63), 
	status				VARCHAR(1),
	failureTime			TIMESTAMP,
	ActionDateTime		TIMESTAMP
)

~

/***********	WFEscalationTable	****************/

CREATE TABLE WFEscalationTable(
	EscalationId		SERIAL PRIMARY KEY,
	ProcessInstanceId	VARCHAR(64),
	WorkitemId			INTEGER,
	ProcessDefId		INTEGER,
	ActivityId			INTEGER,
	EscalationMode		VARCHAR(20)		NOT NULL,
	ConcernedAuthInfo	VARCHAR(2000)	NOT NULL,
	Comments			VARCHAR(512)	NOT NULL,
	Message				TEXT			NOT NULL,
	ScheduleTime		TIMESTAMP		NOT NULL,
	FromId              VARCHAR(256)  NOT NULL,
	CCId                VARCHAR(256)   NULL,
	BCCId               VARCHAR(256) ,
	Frequency			INTEGER ,
	FrequencyDuration	INTEGER ,
	TaskId				INTEGER NULL,
	EscalationType		VARCHAR(1) DEFAULT 'F',
	ResendDurationMinutes	INTEGER
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
	ScheduleTime		TIMESTAMP,
     FromId              Varchar(256) NOT NULL ,
	CCId                Varchar(256),
	bccid 				VARCHAR (256) NULL,
	Frequency			INTEGER ,
	FrequencyDuration	INTEGER	,
	TaskId				INTEGER NULL,
	EscalationType		VARCHAR(1) DEFAULT 'F',
	ResendDurationMinutes	INTEGER
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
	Unbounded			VARCHAR(1) 		NOT NULL DEFAULT N'N' CHECK (Unbounded IN (N'Y' , N'N',N'X',N'Z',N'M',N'P')),
	PRIMARY KEY(ProcessDefId, ExtMethodIndex, DataStructureId)
)

~

/*************	WFWebServiceTable    ***************/
CREATE TABLE WFWebServiceTable(
	ProcessDefId			INTEGER NOT NULL,
	ActivityId				INTEGER NOT NULL,
	ExtMethodIndex			INTEGER NOT NULL,
	ProxyEnabled			VARCHAR(1),
	TimeOutInterval			INTEGER,
	InvocationType			VARCHAR(1),
	FunctionType			VARCHAR(1) NOT NULL DEFAULT N'L' CHECK (FunctionType IN (N'G' , N'L')),
	ReplyPath				VARCHAR(256), 
	AssociatedActivityId	INTEGER,
	InputBuffer			Text,
	OutputBuffer			Text,	
	OrderId                 INTEGER NOT NULL,	
	PRIMARY KEY(ProcessDefId, ActivityId,ExtMethodIndex)
)

~

/**********	WFVarStatusTable	***********/
CREATE TABLE WFVarStatusTable(
	ProcessDefId	INTEGER		NOT NULL,
	VarName			VARCHAR(50)	NOT NULL,
	Status			VARCHAR(1)	NOT NULL DEFAULT 'Y' CHECK(Status = 'Y' OR Status = 'N'),  
	ProcessVariantId INT DEFAULT(0) NOT NULL
) 

~

/************  WFActionStatusTable   ************/
CREATE TABLE WFActionStatusTable(
	ActionId	INTEGER		PRIMARY KEY,
	Type		VARCHAR(1)	NOT NULL DEFAULT 'C' CHECK(Type = 'C' OR Type = 'S' OR  Type = 'R'),
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
	isEncrypted		VARCHAR(1)
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
/****************Skipping temporary tables *****************/
/***********  WFActivityReportTable  ***********/
CREATE TABLE WFActivityReportTable(	
	ProcessDefId		INTEGER,
	ActivityId			INTEGER,
	ActivityName		VARCHAR(30),
	ActionDateTime		TIMESTAMP,
	TotalWICount		bigint,
	TotalDuration		bigint,
	TotalProcessingTime	bigint
)

~

/***********  WFReportDataTable  ***********/
CREATE TABLE WFReportDataTable(
	ProcessInstanceId	VARCHAR(63),
	WorkitemId			INTEGER,
	ProcessDefId		INTEGER		NOT NULL,
	ActivityId			INTEGER,
	UserId				INTEGER,
	TotalProcessingTime	bigint,
	ProcessVariantId 	 INTEGER DEFAULT 0 NOT NULL
)
~
CREATE TABLE WFReportDataHistoryTable(
			ProcessInstanceId	VARCHAR(63),
	WorkitemId			INTEGER,
	ProcessDefId		INTEGER		NOT NULL,
	ActivityId			INTEGER,
	UserId				INTEGER,
	TotalProcessingTime	bigint,
	ProcessVariantId 	 INTEGER DEFAULT 0 NOT NULL
		);
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
	CommentsType		INTEGER			NOT NULL CHECK(CommentsType IN (1, 2, 3, 4,5,6,7,8,9,10)),
	ProcessVariantId 	INTEGER DEFAULT 0 NOT NULL,
	TaskId 				INTEGER 		DEFAULT 0 NOT NULL,
	SubTaskId 			INTEGER			DEFAULT 0 NOT NULL
)

~
/*********** WFCommentsHistoryTable ***********/
CREATE TABLE WFCommentsHistoryTable(
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
	CommentsType		INTEGER			NOT NULL CHECK(CommentsType IN (1, 2, 3, 4,5,6,7,8,9,10)),
	ProcessVariantId 	INTEGER DEFAULT 0 NOT NULL,
	TaskId 				INTEGER 		DEFAULT 0 NOT NULL,
	SubTaskId 			INTEGER			DEFAULT 0 NOT NULL
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
	PRIMARY KEY (ProcessDefId, SwimLaneId)
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
	FieldSeperator		VARCHAR(2),
	FileType			INT,
	FilePath			VARCHAR(255),
	HeaderString		VARCHAR(255),
	FooterString		VARCHAR(255),
	SleepTime			INT,
	MaskedValue			VARCHAR(255),
	DateTimeFormat		VARCHAR(50)
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
	AssociatedFieldName	VARCHAR(2000)	NULL,
	ActivityName		VARCHAR(30)		NULL,
	UserName			VARCHAR (63)	NULL,
	NewValue			VARCHAR (2000)	NULL , 
	AssociatedDateTime	TIMESTAMP 		NULL , 
	QueueId				INTEGER			NULL,
	ProcessVariantId 	INTEGER			DEFAULT 0  	NOT NULL,
	TaskId 				INTEGER			DEFAULT 0,
	SubTaskId			INTEGER			DEFAULT 0,
	URN					VARCHAR (63)  	NULL,
	ProcessingTime 		INT 				NULL,
	TAT					INT 				NULL,
	DelayTime			INT 				NULL
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
	ASsociatedFieldName	VARCHAR(4000)	NULL,
	ActivityName		VARCHAR(30)		NULL,
	UserName			VARCHAR(63)		NULL ,
	NewValue			VARCHAR (2000)	NULL ,
	AssociatedDateTime	TIMESTAMP 		NULL , 
	QueueId				INTEGER			NULL,
	ProcessVariantId 	INTEGER			DEFAULT 0  	NOT NULL,
	TaskId 				INTEGER			DEFAULT 0,
	SubTaskId			INTEGER			DEFAULT 0,
	URN					VARCHAR (63)  	NULL,
	ProcessingTime 	INT NULL,
		TAT					INT NULL,
		DelayTime			INT NULL
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
	ProfileId			INTEGER,
	ProfileName			VARCHAR(64),	
	Property1			VARCHAR(64)	
)

~
/****** WFTypeDescTable  ******/

CREATE TABLE WFTypeDescTable (
	ProcessDefId		INTEGER			NOT NULL,
	TypeId				INTEGER			NOT NULL,
	TypeName			VARCHAR(128)	NOT NULL, 
	ExtensionTypeId		INTEGER			NULL,
	ProcessVariantId 	INTEGER			DEFAULT 0  	NOT NULL,
	PRIMARY KEY (ProcessDefId, TypeId,ProcessVariantId)
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
	ProcessVariantId 	INTEGER			DEFAULT 0  	NOT NULL,
	SortingFlag 	VARCHAR(1),
	PRIMARY KEY (ProcessDefId, ParentTypeId, TypeFieldId,ProcessVariantId)
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
	ProcessVariantId 	INTEGER DEFAULT 0  NOT NULL,
	IsEncrypted         VARCHAR(1)    DEFAULT N'N' NULL,
	IsMasked           	VARCHAR(1)	  DEFAULT N'N' NULL,
	MaskingPattern      VARCHAR(10)   DEFAULT N'X' NULL,
	MappedViewName      VARCHAR(256)        NULL,
    IsView          	VARCHAR(1)    DEFAULT N'N' NOT NULL,
	DefaultSortingFieldname VARCHAR(256),
	DefaultSortingOrder INT,
	PRIMARY KEY (ProcessDefId, VariableId, VarFieldId,ProcessVariantId)
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
	ProcessVariantId 	INTEGER DEFAULT 0  NOT NULL,
	PRIMARY KEY (ProcessDefId, RelationId, OrderId,ProcessVariantId)
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



/******   WFAutoGenInfoTable    ******/

CREATE TABLE WFAutoGenInfoTable (
	TableName			VARCHAR(256), 
	ColumnName			VARCHAR(256), 
	Seed				INTEGER,
	IncrementBy			INTEGER, 
	CurrentSeqNo		INTEGER,
    SeqName				VARCHAR(30), 
	UNIQUE(TableName, ColumnName)
)

~

/******   WFSearchVariableTable    ******/

CREATE TABLE WFSearchVariableTable (
   ProcessDefID			INTEGER				NOT NULL,
   ActivityID			INTEGER				NOT NULL,
   FieldName			VARCHAR(2000)		NOT NULL,
   VariableId			INTEGER				,
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
	SortOrder           VARCHAR(1)     NULL,
	QueueName			VARCHAR(63) 	NULL
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
	CONSTRAINT UK_WFWSAsyncResponseTable	UNIQUE(ActivityId, ProcessInstanceId, WorkitemId)
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
	ProcessDefId		        INTEGER				NOT NULL ,
	SAPHostName			VarChar(64)	NOT NULL,
	SAPInstance			VarChar(2)		NOT NULL,
	SAPClient			VarChar(3)		NOT NULL,
	SAPUserName			VarChar(256)	NULL,
	SAPPassword			VarChar(512)	NULL,
	SAPHttpProtocol		        VarChar(8)		NULL,
	SAPITSFlag			VarChar(1)		NULL,
	SAPLanguage			VarChar(8)		NULL,
	SAPHttpPort			INTEGER				NULL,
    ConfigurationID     INTEGER             NOT NULL,
	RFCHostName         VarChar(64)	NULL,
	ConfigurationName   VarChar(64)	NULL,
	SecurityFlag		VarChar(1)    NULL,
PRIMARY KEY (ProcessDefId, ConfigurationID)
)

~

/*Modified on 23-06-2009 by Ananta Handoo .Three fields added TCodeType, VariableId, VarFieldId */

/****** WFSAPGUIDefTable ******/

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
ConfigurationID     INTEGER             NOT NULL,
	Coordinates             VarChar(255)                    NULL, 
	CONSTRAINT UK_WFSAPGUIAssocTable UNIQUE (ProcessDefId, ActivityId, DefinitionId)
)

~

/* 15/04/2009, New tables added for SAP integration. - Ananta Handoo */

/****** WFSAPAdapterAssocTable ******/
CREATE TABLE WFSAPAdapterAssocTable (
	ProcessDefId		INTEGER				 NULL,
	ActivityId			INTEGER				 NULL,
	EXTMETHODINDEX		INTEGER				 NULL,
	ConfigurationID     INTEGER              NOT NULL,
	SAPUserVariableId   INTEGER DEFAULT 0    NOT NULL ,
	SAPUserName         VARCHAR(50)          NULL
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
	VarfieldID			INTEGER				NOT NULL
)

~

/****** WFWorkListConfigTable ******/
CREATE TABLE WFWorkListConfigTable(	
	QueueId				INTEGER NOT NULL,
	VariableId			INTEGER,
	AliasId	        	INTEGER,
	ViewCategory		VARCHAR(1),
	VariableType		VARCHAR(1),
	DisplayName			VARCHAR(50),
	MobileDisplay		VARCHAR(2)
)
~
insert into WFWorkListConfigTable values (0,29,0,'M','S','EntryDateTime','Y')
~
insert into WFWorkListConfigTable values (0,31,0,'M','S','ProcessInstanceName','Y')
~
insert into WFWorkListConfigTable values (0,32,0,'M','S','CreatedByName','Y')
~
insert into WFWorkListConfigTable values (0,37,0,'M','S','InstrumentStatus','Y')
~
insert into WFWorkListConfigTable values (0,38,0,'M','S','PriorityLevel','Y')
~
insert into WFWorkListConfigTable values (0,46,0,'M','S','LockedByName','Y')
~
insert into WFWorkListConfigTable values (0,48,0,'M','S','LockStatus','Y')
~
insert into WFWorkListConfigTable values (0,49,0,'M','S','ActivityName','Y')
~
insert into WFWorkListConfigTable values (0,52,0,'M','S','ProcessedBy','Y')
~

/* Added by Prateek Verma - 12/08/2010 */
/****** WFPDAControlValueTable ******/
/*CREATE TABLE WFPDAControlValueTable(
	ProcessDefId	INTEGER			NOT NULL, 
	ActivityId		INTEGER			NOT NULL, 
	VariableId		INTEGER			NOT NULL,
	VarFieldId		INTEGER			NOT NULL,
	ControlValue	VARCHAR(255)
)
*/


/****** WFExtInterfaceConditionTable ******/
CREATE TABLE WFExtInterfaceConditionTable (
	ProcessDefId 	    	INTEGER		NOT NULL,
	ActivityId          	INTEGER		NOT NULL ,
	InterFaceType           VARCHAR(1)   	NOT NULL ,
	RuleOrderId         	INTEGER      	NOT NULL ,
	RuleId              	INTEGER      	NOT NULL ,
	ConditionOrderId    	INTEGER 		NOT NULL ,
	Param1			VARCHAR(255) 	NOT NULL ,
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
	PRIMARY KEY (ProcessDefId, InterfaceType, RuleId, ConditionOrderId) 
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
    TotalRecords    INTEGER,
	FailRecords		INTEGER  DEFAULT 0 
)

~
CREATE TABLE WFFailFileRecords (
	FailRecordId INT NOT NULL,
	FileIndex INT,
	RecordNo INT,
	RecordData varchar(2000),
	Message varchar(1000),
	EntryTime timestamp DEFAULT current_timestamp
)
~
/****WFFailFileRecords_SEQ****/
CREATE SEQUENCE WFFailFileRecords_SEQ
	INCREMENT BY 1 START WITH 1

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
	TARGETCABINETNAME	VARCHAR(255)	NULL,
	APPSERVERIP		VARCHAR(20),
	APPSERVERPORT		INTEGER,
	TARGETUSERNAME		VARCHAR(200)	NULL,
	TARGETPASSWORD		VARCHAR(200),
	SITEID			INTEGER ,
	VOLUMEID		INTEGER ,
	WEBSERVERINFO		VARCHAR(255),
	ISENCRYPTED VARCHAR(1) DEFAULT 'N' NOT NULL
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
	ProcessDefId	INTEGER 		   NOT NULL,
	FragmentId	    INTEGER 		   NOT NULL,
	FragmentName	VARCHAR(50)    NOT NULL,
	FragmentBuffer	TEXT         NULL,
	IsEncrypted	    VARCHAR(1)     NOT NULL,
	StructureName	VARCHAR(128)   NOT NULL,
	StructureId	    INTEGER            NOT NULL,
	LastModifiedOn  TIMESTAMP,
	DeviceType				VARCHAR(1)  DEFAULT 'D',
	FormHeight				INTEGER NOT NULL DEFAULT 100,
	FormWidth				INTEGER  NOT NULL DEFAULT 100,
	CONSTRAINT PK_WFFormFragmentTable PRIMARY KEY(ProcessDefID,FragmentId)
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

~
CREATE TABLE WFTransportDataTable  (
	TMSLogId			SERIAL PRIMARY KEY,
    RequestId     		VARCHAR(64),
	ActionId			INTEGER				NOT NULL,
	ActionDateTime		TIMESTAMP		NOT NULL,
	ActionComments		VARCHAR(255),
    UserId               INTEGER             NOT NULL,
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
	ObjectTypeId		INTEGER,	
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
/****** WFWebServiceInfoTable ******/
CREATE TABLE WFWebServiceInfoTable (
	ProcessDefId		INTEGER				NOT NULL, 
	WSDLURLId			INTEGER				NOT NULL,
	WSDLURL				VARCHAR(2000)		NULL,
	USERId				VARCHAR(255)		NULL,
	PWD					VARCHAR(255)		NULL,
	SecurityFlag		VARCHAR(1)		    NULL,
	PRIMARY KEY (ProcessDefId, WSDLURLId)
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
	RegInfo   			TEXT				NULL,
	AppServerId			VARCHAR(50)		NULL,
	RegisteredBy		VARCHAR(64)		NULL DEFAULT 'SUPERVISOR'
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
	CreationDateTime 	TIMESTAMP 			NOT NULL,
	CreatedBy 			VARCHAR(255) 	NOT NULL,
	LastModifiedOn 		TIMESTAMP	 		NULL,
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
	EventName 				VARCHAR(255) 	NOT NULL,
	Description 			VARCHAR(800) 	NULL,
	CreationDateTime 		TIMESTAMP 			NOT NULL,
	ModificationDateTime	TIMESTAMP	 		NULL,
	CreatedBy 				VARCHAR(255) 	NOT NULL,
	StartTimeHrs 			INTEGER 			NOT NULL,
	StartTimeMins 			INTEGER 			NOT NULL,
	EndTimeMins 			INTEGER 			NOT NULL,
	EndTimeHrs 				INTEGER 			NOT NULL,
	StartDate 				TIMESTAMP	 		NOT NULL,
	EndDate 				TIMESTAMP 			NOT NULL,
	EventRecursive 			VARCHAR(1) 	NOT NULL,
	FullDayEvent 			VARCHAR(1) 	NOT NULL,
	ReminderType 			VARCHAR(1) 	NULL,
	ReminderTime 			INTEGER 			NULL,
	ReminderTimeType 		VARCHAR(1) 	NULL,
	ReminderDismissed 		VARCHAR(1) 	Default 'N' NOT NULL ,
	SnoozeTime 				INTEGER 			DEFAULT -1 NOT NULL,
	EventSummary 			VARCHAR(255) 	NULL,
	UserID 					INTEGER 			NULL,
	ParticipantName 		VARCHAR(1024) 	NOT NULL,
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
	UserName 		VARCHAR(255) 	NOT NULL,
	constraint pk_WFOwnerTable PRIMARY KEY (Type,TypeId,ProcessDefId,OwnerOrderId)
)

~

CREATE TABLE WFConsultantsTable(
	Type 				INTEGER 	NOT NULL,
	TypeId 				INTEGER 	NOT NULL,
	ProcessDefId 		INTEGER 	NOT NULL,	
	ConsultantOrderId 	INTEGER 	NOT NULL,
	UserName 		VARCHAR(255) 	NOT NULL,
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
	Chat 				VARCHAR(2000) 	NULL,
	ChatStartTime 		TIMESTAMP 			NOT NULL,
	ChatEndTime 		TIMESTAMP 			NOT NULL
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
	ProcessDefId 	INTEGER 			NOT NULL,
	ActivityId 		INTEGER 			NOT NULL ,
	DocName 		VARCHAR(255) 	NOT NULL,
	DocId 			INTEGER				NOT NULL,
	DocumentBuffer  TEXT 			NOT NULL,
	Status 			VARCHAR(1) 	DEFAULT 'S' NOT NULL,
	AttachmentName 	VARCHAR(255) DEFAULT 'Attachment' NOT NULL,
    AttachmentType 	VARCHAR(1) 	DEFAULT 'A'  NOT NULL,
    RequirementId 	INTEGER 	DEFAULT -1 NOT NULL,
	PRIMARY KEY (ProcessDefId, ActivityId, DocId)		
)

~

Create Table WFLaneQueueTable (
	ProcessDefId 	INTEGER NOT NULL,
	SwimLaneId 		INTEGER NOT NULL ,
	QueueID 		INTEGER	NOT NULL,
	DefaultQueue	VARCHAR(1) DEFAULT 'N',
	PRIMARY KEY (ProcessDefId, SwimLaneId, QueueID)
)

~

Create Table WFCreateChildWITable(
	ProcessDefId		INTEGER NOT NULL,
	TriggerId			INTEGER NOT NULL,
	WorkstepName		VARCHAR(255), 
	Type		VARCHAR(1), 
	GenerateSameParent	VARCHAR(1), 
	VariableId			INTEGER, 
	VarFieldId			INTEGER,
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
	TaskId	    		INTEGER DEFAULT 0 NOT NULL,
	WSLayoutDefinition 	VARCHAR(4000),
	PRIMARY KEY (ProcessDefId, ActivityId,TaskId)
)

~

Create Table WFProfileTable(
	ProfileId					Serial NOT NULL PRIMARY KEY,
	ProfileName					VARCHAR(50),
	Description					VARCHAR(255),
	Deletable					VARCHAR(1),
	CreatedOn					TIMESTAMP,
	LastModifiedOn				TIMESTAMP,
	OwnerId						INTEGER,
	OwnerName					VARCHAR(64),
	CONSTRAINT u_prftable UNIQUE (ProfileName)   
)

~

Create Table WFObjectListTable(
	ObjectTypeId				Serial  NOT NULL PRIMARY KEY,
	ObjectType					VARCHAR(20),
	ObjectTypeName				VARCHAR(50),
	ParentObjectTypeId			INTEGER,
	ClassName					VARCHAR(255),
	DefaultRight				VARCHAR(100),
	List						VARCHAR(1)
)

~

Create Table WFAssignableRightsTable(
	ObjectTypeId		INTEGER,
	RightFlag			VARCHAR(50),
	RightName			VARCHAR(50),
	OrderBy				INTEGER
)

~

Create Table WFProfileObjTypeTable(
	UserId					INTEGER 		NOT NULL ,
	AssociationType			INTEGER 		NOT NULL ,
	ObjectTypeId			INTEGER 		NOT NULL ,
	RightString				VARCHAR(100),
	Filter					VARCHAR(255)
)
~

Create Table WFUserObjAssocTable(
	ObjectId					INTEGER 		NOT NULL ,
	ObjectTypeId				INTEGER 		NOT NULL ,
	ProfileId					INTEGER,
	UserId						INTEGER 		NOT NULL ,
	AssociationType				INTEGER 		NOT NULL ,
	AssignedTillDATETIME		TIMESTAMP,
	AssociationFlag				VARCHAR(1),
	RightString					VARCHAR(100),
	Filter						VARCHAR(255),
	PRIMARY KEY(ObjectId, ObjectTypeId, ProfileId, UserId, AssociationType, RightString)
)

~

Create Table WFFilterListTable(
	ObjectTypeId			INTEGER NOT NULL,
	FilterName				VARCHAR(50),
	TagName					VARCHAR(50)
)

~

CREATE TABLE WFLASTREMINDERTABLE (
	USERID 				INTEGER NOT NULL,
	LASTREMINDERTIME	TIMESTAMP 
)

/*	Added by AMit Goyal finished	*/

~
/*  Added by Shweta Singhal- 29/03/2012 */

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
	LibraryId			SERIAL			NOT NULL 	PRIMARY KEY,
	URL			VARCHAR(255)	NULL,
	DocumentLibrary		VARCHAR(255)	NULL,
	DOMAINNAME 			VARCHAR(64)	NULL
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
	DiffFolderLoc			VARCHAR(2) 	NULL,
	SameAssignRights		VARCHAR(2) 	NULL,
	DOMAINNAME 				VARCHAR(64)	NULL
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
	FolderName				VARCHAR(255)	NULL,
	TargetDocName			VARCHAR(255)	NULL
)

~

CREATE TABLE WFMsgAFTable(
	ProcessDefId 	INTEGER NOT NULL,
	MsgAFId 		INTEGER NOT NULL,
	xLeft 			INTEGER NULL,
	yTop 			INTEGER NULL,
	MsgAFName 		VARCHAR(255) NULL,
	SwimLaneId 		INTEGER NOT NULL,
	PRIMARY KEY ( ProcessDefId, MsgAFId, SwimLaneId)
)
 
~

CREATE TABLE WFProcessVariantDefTable (
	ProcessDefId		INTEGER		NOT NULL,
	ProcessVariantId    INTEGER		NOT NULL,
	ProcessVariantName	VARCHAR(64)	NOT NULL ,
	ProcessVariantState	VARCHAR(10),
	RegPrefix			VARCHAR(20)	NOT NULL,
	RegSuffix			VARCHAR(20)	NULL,
	RegStartingNo		INTEGER			NULL,		
	Label				VARCHAR (255) NOT	NULL ,
	Description			VARCHAR (255)	NULL ,
	CreatedOn			TIMESTAMP		NULL , 
	CreatedBy			VARCHAR(64)	NULL,
	LastModifiedOn  	TIMESTAMP		NULL,
	LastModifiedBy		VARCHAR(64)	NULL,
	PRIMARY KEY (ProcessVariantId)
)

~

CREATE TABLE WFVariantFieldInfoTable(
	ProcessDefId			INTEGER		NOT NULL,
	ProcessVariantId		INTEGER		NOT NULL,
	FieldId                 INTEGER		NOT NULL,
    VariableId				INTEGER,
    VarFieldId				INTEGER,
    Type          			INTEGER,
    Length                  INTEGER,
    DefaultValue            VARCHAR(255),
    MethodName          	VARCHAR(255),
    PickListInfo            VARCHAR(512),
    ControlType             INTEGER,
	PRIMARY KEY ( ProcessDefId, ProcessVariantId, FieldId)
)

~

CREATE TABLE WFVariantFieldAssociationTable(
	ProcessDefId			INTEGER		NOT NULL,
	ProcessVariantId		INTEGER		NOT NULL,
	ActivityId              INTEGER		NOT NULL,
    VariableId              INTEGER		NOT NULL,
	VarFieldId              INTEGER		NOT NULL,
    Enable       			VARCHAR(1),
    Editable      			VARCHAR(1),
    Visible     	        VARCHAR(1),
    Mandatory				VARCHAR(1),
	PRIMARY KEY ( ProcessDefId, ProcessVariantId, ActivityId, VariableId, VarFieldId)
)

~

CREATE TABLE WFVariantFormListenerTable(
	ProcessDefId			INTEGER		NOT NULL,
	ProcessVariantId		INTEGER		NOT NULL,
	VariableId              INTEGER,
	VarFieldId              INTEGER,
	FormExtId               INTEGER		NULL,
    ActivityId              INTEGER		NULL,
	FunctionName			VARCHAR(512),
    CodeSnippet             TEXT,
    LanguageType  			VARCHAR(2),
    FieldListener     	    INTEGER,
    ObjectForListener		VARCHAR(1)
)

~

CREATE TABLE WFVariantFormTable(
	ProcessDefId			INTEGER Not Null,
	ProcessVariantId		INTEGER	Not Null,
    FormExtId   	        INTEGER Not Null,
	Columns		            INTEGER,
    Width1		            INTEGER,
    Width2		            INTEGER,
    Width3		            INTEGER,
	PRIMARY KEY ( ProcessDefId, ProcessVariantId, FormExtId)
)	

~

CREATE TABLE WFINSTRUMENTTABLE (
	ProcessInstanceID			VARCHAR (63)  NOT NULL ,
	ProcessDefID				INTEGER		NOT NULL,
	Createdby					INTEGER		NOT NULL ,
	CreatedByName				VARCHAR(63)	NULL ,
	Createddatetime				TIMESTAMP		NOT NULL ,
	Introducedbyid				INTEGER		NULL ,
	Introducedby				VARCHAR(63)	NULL ,
	IntroductionDatetime		TIMESTAMP		NULL ,
	ProcessInstanceState		INTEGER		NULL ,
	ExpectedProcessDelay		TIMESTAMP		NULL ,
	IntroducedAt				VARCHAR(30)	NOT NULL ,
	WorkItemId					INTEGER		NOT NULL ,
	VAR_INT1					INTEGER	NULL ,
	VAR_INT2					INTEGER	NULL ,
	VAR_INT3					INTEGER	NULL ,
	VAR_INT4					INTEGER	NULL ,
	VAR_INT5					INTEGER	NULL ,
	VAR_INT6					INTEGER	NULL ,
	VAR_INT7					INTEGER	NULL ,
	VAR_INT8					INTEGER	NULL ,
	VAR_FLOAT1					NUMERIC(15, 2)	NULL ,
	VAR_FLOAT2					NUMERIC(15, 2)	NULL ,
	VAR_DATE1					TIMESTAMP		NULL ,
	VAR_DATE2					TIMESTAMP		NULL ,
	VAR_DATE3					TIMESTAMP		NULL ,
	VAR_DATE4					TIMESTAMP		NULL ,
	VAR_LONG1					INTEGER		NULL ,
	VAR_LONG2					INTEGER		NULL ,
	VAR_LONG3					INTEGER		NULL ,
	VAR_LONG4					INTEGER		NULL ,
	VAR_STR1					VARCHAR(255)  NULL ,
	VAR_STR2					VARCHAR(255)  NULL ,
	VAR_STR3					VARCHAR(255)  NULL ,
	VAR_STR4					VARCHAR(255)  NULL ,
	VAR_STR5					VARCHAR(255)  NULL ,
	VAR_STR6					VARCHAR(255)  NULL ,
	VAR_STR7					VARCHAR(255)  NULL ,
	VAR_STR8					VARCHAR(255)  NULL ,
	VAR_REC_1					VARCHAR(255)  NULL ,
	VAR_REC_2					VARCHAR(255)  NULL ,
	VAR_REC_3					VARCHAR(255)  NULL ,
	VAR_REC_4					VARCHAR(255)  NULL ,
	VAR_REC_5					VARCHAR(255) NULL  Default '0',
	InstrumentStatus			VARCHAR(1)	NULL, 
	CheckListCompleteFlag		VARCHAR(1)	NULL ,
	SaveStage					VARCHAR(30)	NULL ,
	HoldStatus					INTEGER		NULL,
	Status						VARCHAR(255)  NULL ,
	ReferredTo					INTEGER		NULL ,
	ReferredToName				VARCHAR(63)	NULL ,
	ReferredBy					INTEGER		NULL ,
	ReferredByName				VARCHAR(63)	NULL ,
	ChildProcessInstanceId		VARCHAR(63)	NULL,
	ChildWorkitemId				INTEGER,
	ParentWorkItemID			INTEGER,
	CalendarName    			VARCHAR(255) NULL,  
	ProcessName 				VARCHAR(30)	NOT NULL ,
	ProcessVersion  			INTEGER,
	LastProcessedBy 			INTEGER		NULL ,
	ProcessedBy					VARCHAR(63)	NULL,	
	ActivityName 				VARCHAR(30)	NULL ,
	ActivityId 					INTEGER		NULL ,
	EntryDateTime 				TIMESTAMP		NULL ,
	AssignmentType				VARCHAR (1)	NULL ,
	CollectFlag					VARCHAR (1)	NULL ,
	PriorityLevel				INTEGER	NULL ,
	ValidTill					TIMESTAMP		NULL ,
	Q_StreamId					INTEGER		NULL ,
	Q_QueueId					INTEGER		NULL ,
	Q_UserId					INTEGER	NULL ,
	AssignedUser				VARCHAR(63)	NULL,	
	FilterValue					INTEGER		NULL ,
	WorkItemState				INTEGER		NULL ,
	Statename 					VARCHAR(255),
	ExpectedWorkitemDelay		TIMESTAMP		NULL ,
	PreviousStage				VARCHAR (30)  NULL ,
	LockedByName				VARCHAR(63)	NULL,	
	LockStatus					VARCHAR(1) NOT NULL,
	RoutingStatus				VARCHAR(1) NOT NULL,	
	LockedTime					TIMESTAMP		NULL , 
	Queuename 					VARCHAR(63),
	Queuetype 					VARCHAR(1),
	NotifyStatus				VARCHAR(1),	  
	Guid 						BigINT,
	NoOfCollectedInstances		INTEGER DEFAULT 0 NOT NULL,
	IsPrimaryCollected			VARCHAR(1) NULL CHECK (IsPrimaryCollected IN (N'Y', N'N')),
	ExportStatus				VARCHAR(1) DEFAULT 'N',
	ProcessVariantId 			INTEGER DEFAULT(0) NOT NULL ,
	Q_DivertedByUserId   		INTEGER,
	ActivityType				INTEGER NULL,
	lastModifiedTime			TIMESTAMP		NULL ,
	VAR_DATE5		TIMESTAMP		NULL ,
	VAR_DATE6		TIMESTAMP		NULL ,
	VAR_LONG5		INTEGER		NULL ,
	VAR_LONG6		INTEGER		NULL ,
	VAR_STR9		VARCHAR(512)  NULL ,
	VAR_STR10		VARCHAR(512)  NULL ,
	VAR_STR11		VARCHAR(512)  NULL ,
	VAR_STR12		VARCHAR(512)  NULL ,
	VAR_STR13		VARCHAR(512)  NULL ,
	VAR_STR14		VARCHAR(512)  NULL ,
	VAR_STR15		VARCHAR(512)  NULL ,
	VAR_STR16		VARCHAR(512)  NULL ,
	VAR_STR17		VARCHAR(512)  NULL ,
	VAR_STR18		VARCHAR(512)  NULL ,
	VAR_STR19		VARCHAR(512)  NULL ,
	VAR_STR20		VARCHAR(512)  NULL ,
	URN				VARCHAR (63)  NULL ,
	SecondaryDBFlag	VARCHAR(1)    DEFAULT 'N' NOT NULL CHECK (SecondaryDBFlag IN (N'Y', N'N',N'U',N'D')),
	ManualProcessingFlag	VARCHAR(1)    DEFAULT 'N' NOT NULL ,
	DBExErrCode     int       		NULL,
	DBExErrDesc     VARCHAR(255)	NULL,
	Locale						varchar(30)	NULL,
	ProcessingTime	Int  Null,
	CONSTRAINT PK_WFINSTRUMENTTable PRIMARY KEY 
	(
	ProcessInstanceID,WorkitemId
	)
)

~
CREATE TABLE WFUserSkillCategoryTable (
 CategoryId     INTEGER   PRIMARY KEY,
 CategoryName    VARCHAR(256)  NOT NULL ,
 CategoryDefinedBy   INTEGER  NOT NULL ,
 CategoryDefinedOn   TIMESTAMP,
 CategoryAvailableForRating  VARCHAR(1) 
)

~

CREATE TABLE WFUserSkillDefinitionTable (
 SkillId      INTEGER   PRIMARY KEY,
 CategoryId     INTEGER  NOT NULL ,
 SkillName     VARCHAR(256),
 SkillDescription   VARCHAR(512),
 SkillDefinedBy    INTEGER  NOT NULL ,
 SkillDefinedOn    TIMESTAMP,
 SkillAvailableForRating  VARCHAR(1) 
)

~

CREATE TABLE WFUserRatingLogTable (
 RatingLogId     INTEGER 	NOT NULL ,
 RatingToUser    INTEGER    NOT NULL ,
 RatingByUser    INTEGER    NOT NULL,
 SkillId      	 INTEGER    NOT NULL,
 Rating      DECIMAL(5,2)  NOT NULL ,
 RatingDateTime    TIMESTAMP,
 Remarks       VARCHAR(512) ,
 PRIMARY KEY ( RatingToUser , RatingByUser,SkillId)
 )

~
CREATE TABLE WFUserRatingSummaryTable (
 UserId       INTEGER    NOT NULL,
 SkillId      INTEGER    NOT NULL ,
 AverageRating    DECIMAL(5,2) NOT NULL,
 RatingCount     INTEGER NOT NULL,
  PRIMARY KEY (UserId,SkillId)
 )
 
 ~


create table WFBRMSConnectTable(
   ConfigName 			varchar(128) NOT NULL,
   ServerIdentifier 	integer NOT NULL,
   ServerHostName 		varchar(128) NOT NULL,
   ServerPort 			integer NOT NULL,
   ServerProtocol 		varchar(32) NOT NULL,
   URLSuffix 			varchar(32) NOT NULL,
   UserName 			varchar(128) NULL,
   Password 			varchar(128) NULL,
   ProxyEnabled 		varchar(1) NOT NULL,
   RESTServerHostName 		varchar(128) ,
   RESTServerPort 			integer ,
   RESTServerProtocol 		varchar(32) ,
   CONSTRAINT pk_WFBRMSConnectTable PRIMARY KEY(ServerIdentifier)
) 
  
~

create table WFBRMSRuleSetInfo(
   ExtMethodIndex 	integer NOT NULL,
   ServerIdentifier integer NOT NULL,
   RuleSetName 		varchar(128) NOT NULL,
   VersionNo 		varchar(5) NOT NULL,
   InvocationMode 	varchar(128) NOT NULL,
   RuleType  VARCHAR(1) DEFAULT 'P' NOT NULL,
   isEncrypted VARCHAR(1) NULL,
   RuleSetId INTEGER NULL,
   CONSTRAINT pk_WFBRMSRuleSetInfo PRIMARY KEY(ExtMethodIndex)
) 

~
   
   create table WFBRMSActivityAssocTable(
   ProcessDefId 	integer NOT NULL,
   ActivityId 		integer NOT NULL,
   ExtMethodIndex 	integer NOT NULL,
   OrderId 			integer NOT NULL,
   TimeoutDuration 	integer NOT NULL,
   Type		VARCHAR(1) Default 'S' NOT NULL,
   CONSTRAINT pk_WFBRMSActivityAssocTable PRIMARY KEY(ProcessDefId,ActivityId,ExtMethodIndex)
) 

~ 


CREATE TABLE WFSYSTEMPROPERTIESTABLE(
	PROPERTYKEY VARCHAR(255), 
	PROPERTYVALUE VARCHAR(1000) NOT NULL, 
	PRIMARY KEY (PROPERTYKEY)
)

~

Create Table WFObjectPropertiesTable (
 ObjectType VARCHAR(1),
 ObjectId Integer, 
 PropertyName VARCHAR(255),
 PropertyValue VARCHAR(1000), 
 Primary Key(ObjectType,ObjectId,PropertyName))
 

~

/* New Tables added for iBPS Case Mnagaement   */

 create TABLE WFTaskDefTable(
    ProcessDefId INTEGER NOT NULL,
    TaskId INTEGER NOT NULL,
	TaskType INTEGER NOT NULL,
    TaskName VARCHAR(100) NOT NULL,
    Description  TEXT NULL,
    xLeft INTEGER  NULL,
    yTop INTEGER  NULL,
    IsRepeatable VARCHAR(1) DEFAULT 'Y' NOT NULL,
    TurnAroundTime INTEGER  NULL,/*contains duration Id*/
    CreatedOn TIMESTAMP NOT NULL,
    CreatedBy VARCHAR(255) NOT NULL,
    Scope VARCHAR(1) NOT NULL,/*P for process Created*/
    Goal VARCHAR(1000) NULL,
    Instructions VARCHAR(1000) NULL,
    TATCalFlag VARCHAR(1) DEFAULT 'N' NOT NULL,/*contains Y for calenday days else N*/
    Cost numeric(15,2) NULL,
	NotifyEmail VARCHAR(1) DEFAULT 'N' NOT NULL,
	TaskTableFlag VARCHAR(1)  DEFAULT 'N' NOT NULL,
	TaskMode Varchar(1),
	UseSeparateTable VARCHAR(1)  DEFAULT 'Y' NOT NULL,
	InitiateWI VARCHAR(1) Default 'Y' NOT NULL,
	Primary Key( ProcessDefId,TaskId)
 )
~
create table WFTaskInterfaceAssocTable (
    ProcessDefId INTEGER  NOT NULL , 
	ActivityId INTEGER NOT NULL ,
	TaskId INTEGER NOT NULL , 
	InterfaceId INTEGER NOT NULL, 
	InterfaceType NCHAR(1) NOT NULL,
	Attribute VARCHAR(2)
)
~

create table WFRTTaskInterfaceAssocTable (
    ProcessInstanceId VARCHAR(63) NOT NULL,
	WorkItemId  INTEGER NOT NULL,
    ProcessDefId INTEGER  NOT NULL, 
	ActivityId INTEGER NOT NULL,
	TaskId INTEGER NOT NULL, 
	InterfaceId INTEGER NOT NULL, 
	InterfaceType NCHAR(1) NOT NULL,
	Attribute VARCHAR(2)
)
~
create table WFRTTASKINTFCASSOCHISTORY (
    ProcessInstanceId VARCHAR(63) NOT NULL,
	WorkItemId  INTEGER NOT NULL,
	ProcessDefId INTEGER  NOT NULL, 
	ActivityId INTEGER NOT NULL,
	TaskId INTEGER NOT NULL, 
	InterfaceId INTEGER NOT NULL, 
	InterfaceType NCHAR(1) NOT NULL,
	Attribute VARCHAR(2)
)
~

CREATE TABLE RTACTIVITYINTERFACEASSOCTABLE (
    ProcessInstanceId VARCHAR(63) NOT NULL,
	WorkItemId                INTEGER NOT NULL,
	ProcessDefId             INTEGER		NOT NULL,
	ActivityId              INTEGER             NOT NULL,
	ActivityName            VARCHAR(30)    NOT NULL,
	InterfaceElementId      INTEGER             NOT NULL,
	InterfaceType           VARCHAR(1)     NOT NULL,
	Attribute               VARCHAR(2)     NULL,
	TriggerName             VARCHAR(255)   NULL,
	ProcessVariantId 		INTEGER 			DEFAULT 0 NOT NULL 
)

~
CREATE TABLE RTACTIVITYINTFCASSOCHISTORY (
	ProcessInstanceId VARCHAR(63) NOT NULL,
	WorkItemId                INTEGER NOT NULL,
	ProcessDefId             INTEGER		NOT NULL,
	ActivityId              INTEGER             NOT NULL,
	ActivityName            VARCHAR(30)    NOT NULL,
	InterfaceElementId      INTEGER             NOT NULL,
	InterfaceType           VARCHAR(1)     NOT NULL,
	Attribute               VARCHAR(2)     NULL,
	TriggerName             VARCHAR(255)   NULL,
	ProcessVariantId 		INTEGER 			DEFAULT 0 NOT NULL 
		)
~
create table WFTaskTemplateFieldDefTable (
    ProcessDefId INTEGER NOT NULL,
	TaskId INTEGER NOT NULL, 
	TemplateVariableId INTEGER  NOT NULL,
    TaskVariableName VARCHAR(255) NOT NULL, 
	DisplayName VARCHAR(255), 
	VariableType 	INTEGER NOT NULL ,
	OrderId INTEGER NOT NULL,
	ControlType INTEGER NOT NULL /*1 for textbox, 2 for text area, 3 for combo*/,
	DBLinking VARCHAR(1) default 'N' NOT NULL
)
~
create table WFTaskTemplateDefTable (
    ProcessDefId INTEGER NOT NULL ,
	TaskId INTEGER  NOT NULL, 
	TemplateName VARCHAR(255) NOT NULL
)
~
CREATE TABLE WFTaskTempControlValues(
    ProcessDefId INTEGER NOT NULL,
    TaskId INTEGER NOT NULL,
    TemplateVariableId INTEGER NOT NULL,
    ControlValue VARCHAR(255) NOT NULL    
)
~

create table WFApprovalTaskDataTable(
	ProcessInstanceId VARCHAR(63) NOT NULL,
	ProcessDefId INTEGER  NOT NULL, 
	WorkItemId INTEGER NOT NULL, 
	ActivityId INTEGER NOT NULL,
	TaskId INTEGER NOT NULL,
	Decision VARCHAR(100) , 
	Decision_By VARCHAR(255), 
	Decision_Date	TIMESTAMP, 
	Comments VARCHAR(255),
	SubTaskId  INTEGER
)
~
create table WFMeetingTaskDataTable(
	ProcessInstanceId VARCHAR(63) NOT NULL,
	ProcessDefId INTEGER  NOT NULL, 
	WorkItemId INTEGER NOT NULL, 
	ActivityId INTEGER NOT NULL,
	TaskId INTEGER NOT NULL,
	Venue VARCHAR(255), 
	ParticipantList VARCHAR(1000), 
	Purpose	VARCHAR(255),
	InitiatedBy VARCHAR(255),
	Comments VARCHAR(255),
	SubTaskId  INTEGER
)
~

create table WFTaskVariableMappingTable(
	ProcessDefId INTEGER NOT NULL, 
	ActivityId INTEGER NOT NULL, 
	TaskId INTEGER NOT NULL,
	TemplateVariableId INTEGER NOT NULL, 
	TaskVariableName VARCHAR(255) NOT NULL, 
	VariableId INTEGER NOT NULL, 
	TypeFieldId INTEGER NOT NULL, 
	ReadOnly VARCHAR(1) NULL,
	VariableName VARCHAR(255) NULL,
	primary key(ProcessDefId,ActivityId,TaskId,TemplateVariableId)
)
 ~
 
create table WFTaskRulePreConditionTable(
    ProcessDefId INTEGER NOT NULL,
    ActivityId INTEGER NOT NULL,
    TaskId INTEGER NOT NULL,
    RuleType NCHAR(1) NOT NULL,
    RuleOrderId INTEGER NOT NULL,
    RuleId INTEGER NOT NULL,
    ConditionOrderId INTEGER NOT NULL,
    Param1 VARCHAR(255) NOT NULL,
    Type1 VARCHAR(1) not null,
    ExtObjId1 INTEGER,
    VariableId_1 INTEGER NOT NULL,
    VarFieldId_1 INTEGER,
    Param2 VARCHAR(255) ,
    Type2 VARCHAR(1) ,
    ExtObjId2 INTEGER ,
    VariableId_2 INTEGER ,
    VarFieldId_2 INTEGER,
    Operator INTEGER  ,
    Logicalop INTEGER NOT NULL 
)
 ~
  
create table WFTaskStatusTable(
    ProcessInstanceId VARCHAR(63) NOT NULL,
    WorkItemId INTEGER NOT NULL,
    ProcessDefId INTEGER NOT NULL,
    ActivityId INTEGER NOT NULL,
    TaskId  INTEGER NOT NULL,
	SubTaskId  INTEGER NOT NULL,
    TaskStatus INTEGER NOT NULL,
    AssignedBy VARCHAR(63) NOT NULL,
    AssignedTo VARCHAR(63) ,
	Instructions VARCHAR(2000) NULL,
	ActionDateTime TIMESTAMP NOT NULL,
	DueDate TIMESTAMP,
	Priority  INTEGER, 
	ShowCaseVisual	VARCHAR(1) DEFAULT 'N' NOT NULL,
    ReadFlag VARCHAR(1) default 'N' NOT NULL,
	CanInitiate	VARCHAR(1) default 'N' NOT NULL,	
	Q_DivertedByUserId INTEGER DEFAULT 0,
	LockStatus VARCHAR(1) DEFAULT 'N' NOT NULL,
	InitiatedBy VARCHAR(63) NULL,
	TaskEntryDateTime TIMESTAMP NULL,
	ValidTill TIMESTAMP NULL,
	ApprovalRequired Varchar(1) NOT NULL DEFAULT 'N',
	ApprovalSentBy VARCHAR(63) NULL,
	AllowReassignment Varchar(1) NOT NULL DEFAULT 'Y',
	AllowDecline Varchar(1) NOT NULL DEFAULT 'Y',
	EscalatedFlag Varchar(1),
	ChildProcessInstanceId	VARCHAR(63)	NULL,
	ChildWorkitemId	INT,
    CONSTRAINT PK_WFTaskStatusTable PRIMARY KEY(ProcessInstanceId,WorkItemId,ProcessDefID,ActivityId,TaskId,SubTaskId)
)

~
create table WFTaskStatusHistoryTable(
					
	ProcessInstanceId VARCHAR(63) NOT NULL,
	WorkItemId INTEGER NOT NULL,
	ProcessDefId INTEGER NOT NULL,
	ActivityId INTEGER NOT NULL,
	TaskId  INTEGER NOT NULL,
	SubTaskId  INTEGER NOT NULL,
	TaskStatus INTEGER NOT NULL,
	AssignedBy VARCHAR(63) NOT NULL,
	AssignedTo VARCHAR(63) ,
	Instructions VARCHAR(2000) NULL,
	ActionDateTime TIMESTAMP NOT NULL,
	DueDate TIMESTAMP,
	Priority  INTEGER, 
	ShowCaseVisual	VARCHAR(1) DEFAULT 'N' NOT NULL,
	ReadFlag VARCHAR(1) default 'N' NOT NULL,
	CanInitiate	VARCHAR(1) default 'N' NOT NULL,	
	Q_DivertedByUserId INTEGER DEFAULT 0,
	LockStatus VARCHAR(1) DEFAULT 'N' NOT NULL,
	InitiatedBy VARCHAR(63) NULL,
	TaskEntryDateTime TIMESTAMP NULL,
	ValidTill TIMESTAMP NULL,
	ApprovalRequired Varchar(1) NOT NULL DEFAULT 'N',
	ApprovalSentBy VARCHAR(63) NULL,
	AllowReassignment Varchar(1) NOT NULL DEFAULT 'Y',
	AllowDecline Varchar(1) NOT NULL DEFAULT 'Y',
	EscalatedFlag Varchar(1),
    CONSTRAINT PK_WFTaskStatusHistoryTable PRIMARY KEY(ProcessInstanceId,WorkItemId,ProcessDefID,ActivityId,TaskId,SubTaskId)
				)
~

CREATE TABLE WFTaskFormTable (
    ProcessDefId            INTEGER             NOT NULL,
    TaskId                  INTEGER             NOT NULL,
    FormBuffer              TEXT			NULL,
    DeviceType				VARCHAR(1)  DEFAULT 'D',
    FormHeight			    INTEGER DEFAULT(100) NOT NULL,
    FormWidth			    INTEGER DEFAULT(100) NOT NULL,
    StatusFlag 			    VARCHAR(1)  NULL,
    CONSTRAINT PK_WFTaskFormTable PRIMARY KEY(ProcessDefID,TaskId)
) 

~

CREATE TABLE WFCaseDataVariableTable (
    ProcessDefId            INTEGER             NOT NULL,
    ActivityID				INTEGER				NOT NULL,
	VariableId		INTEGER 		NOT NULL ,
	DisplayName			VARCHAR(2000)		NULL,
	CONSTRAINT PK_WFCaseDataVariableTable PRIMARY KEY(ProcessDefID,ActivityID,VariableId)
)


~

CREATE TABLE WFCaseInfoVariableTable (
    ProcessDefId            INTEGER             NOT NULL,
    ActivityID				INTEGER				NOT NULL,
	VariableId		INTEGER 		NOT NULL ,
	DisplayName			VARCHAR(2000)		NULL,
	CONSTRAINT PK_WFCaseInfoVariableTable PRIMARY KEY(ProcessDefID,ActivityID,VariableId)
)

~ 
create table WFTaskruleOperationTable(
	ProcessDefId     INT    NOT NULL,
	ActivityId     INT     NOT NULL, 
	TaskId     INT     NOT NULL, 
	RuleId     SMALLINT     NOT NULL, 
	OperationType     SMALLINT     NOT NULL, 
	Param1 varchar(255) NOT NULL,
	Type1 varchar(1) NOT NULL,
	ExtObjID1 int  NULL,
	VariableId_1 int  NULL,
	VarFieldId_1 int  NULL,    
	Param2 varchar(255) NOT NULL,
	Type2 varchar(1) NOT NULL,
	ExtObjID2 int  NULL,
	VariableId_2 int  NULL,
	VarFieldId_2 int  NULL,
	Param3 varchar(255) NULL,
	Type3 varchar(1) NULL,
	ExtObjID3 int  NULL,
	VariableId_3 int  NULL,
	VarFieldId_3 int  NULL,    
	Operator     SMALLINT     NOT NULL, 
	AssignedTo    varchar(63),    
	OperationOrderId     SMALLINT     NOT NULL,
	RuleCalFlag	varchar(1) NULL,	
	CONSTRAINT pk_WFTaskruleOperationTable PRIMARY KEY  (ProcessDefId,ActivityId,TaskId,RuleId,OperationOrderId ) 
 
)
~
Create Table WFTaskPropertyTable(
ProcessDefId integer NOT NULL,
ActivityId INT NOT NULL ,
TaskId  integer NOT NULL,
DefaultStatus integer NOT NULL,
AllowReassignment varchar(1),
AllowDecline varchar(1),
ApprovalRequired varchar(1),
MandatoryText varchar(255),
CONSTRAINT pk_WFTaskPropertyTable PRIMARY KEY  ( ProcessDefId,ActivityId ,TaskId)
)
~




Create Table WFTaskPreConditionResultTable(
ProcessInstanceId	varchar(63)  	NOT NULL ,
WorkItemId 		INT 		NOT NULL ,
ActivityId INT NOT NULL ,
TaskId  integer NOT NULL,
Ready Integer  null,
Mandatory varchar(1),
CONSTRAINT pk_WFTaskPreCondResultTable PRIMARY KEY  ( ProcessInstanceId,WorkItemId,ActivityId ,TaskId)
)
~
Create Table WFTaskPreCondResultHistory(
ProcessInstanceId	varchar(63)  	NOT NULL ,
WorkItemId 		INT 		NOT NULL ,
ActivityId INT NOT NULL ,
TaskId  integer NOT NULL,
Ready Integer  null,
Mandatory varchar(1),
CONSTRAINT pk_WFTaskPreCondResultHistory PRIMARY KEY  ( ProcessInstanceId,WorkItemId,ActivityId ,TaskId)
)
~

Create Table WFTaskPreCheckTable(
ProcessInstanceId	varchar(63)  	NOT NULL ,
WorkItemId 		INT 		NOT NULL ,
ActivityId INT NOT NULL ,
checkPreCondition varchar(1),
ProcessDefId INTEGER,
CONSTRAINT pk_WFTaskPreCheckTable PRIMARY KEY  ( ProcessInstanceId,WorkItemId,ActivityId)
)
~
Create Table WFTaskPreCheckHistory(
ProcessInstanceId	varchar(63)  	NOT NULL ,
WorkItemId 		INT 		NOT NULL ,
ActivityId INT NOT NULL ,
checkPreCondition varchar(1),
CONSTRAINT pk_WFTaskPreCheckHistory PRIMARY KEY  ( ProcessInstanceId,WorkItemId,ActivityId)
)
~

CREATE TABLE WFCaseSummaryDetailsTable(
    ProcessInstanceId VARCHAR(63) NOT NULL,
    WorkItemId INTEGER NOT NULL,
	ProcessDefId INTEGER NOT NULL,
    ActivityId INTEGER NOT NULL,
    ActivityName VARCHAR(30)    NOT NULL,
    Status INTEGER NOT NULL,
    NoOfRetries INTEGER NOT NULL,
	EntryDateTime 			TIMESTAMP	NOT	NULL ,
	LockedBy	VARCHAR(1000) NULL,
	CONSTRAINT PK_WFCaseSummaryDetailsTable PRIMARY KEY(ProcessInstanceId,WorkItemId,ActivityID,EntryDateTime)
)

~
CREATE TABLE WFCaseSummaryDetailsHistory(
    ProcessInstanceId VARCHAR(63) NOT NULL,
    WorkItemId INTEGER NOT NULL,
	ProcessDefId INTEGER NOT NULL,
    ActivityId INTEGER NOT NULL,
    ActivityName VARCHAR(30)    NOT NULL,
    Status INTEGER NOT NULL,
    NoOfRetries INTEGER NOT NULL,
	EntryDateTime 			TIMESTAMP	NOT	NULL ,
	LockedBy	VARCHAR(1000) NULL,
	CONSTRAINT PK_WFCaseSummaryDetailsHistory PRIMARY KEY(ProcessInstanceId,WorkItemId,ActivityID,EntryDateTime)
)

~

CREATE TABLE WFGenericServicesTable	 (
	ServiceId  			INTEGER 				NOT NULL,
	GenServiceId		INTEGER					NOT NULL, 
	GenServiceName  		VARCHAR(50)		NULL, 
	GenServiceType  		VARCHAR(50)		NULL, 
	ProcessDefId 		INTEGER					NULL, 
	EnableLog  			VARCHAR(50)		NULL, 
	MonitorStatus 		VARCHAR(50)		NULL, 
	SleepTime  			INTEGER					NULL, 
	RegInfo   			TEXT				NULL,
	CONSTRAINT PK_WFGenericServicesTable PRIMARY KEY(ServiceId,GenServiceId)
)

~

create table WFCaseDocStatusTable(
    ProcessInstanceId VARCHAR(63) NOT NULL,
    WorkItemId INTEGER NOT NULL,
    ProcessDefId INTEGER NOT NULL,
    ActivityId INTEGER NOT NULL,
    TaskId  INTEGER NOT NULL,
	SubTaskId  INTEGER NOT NULL,
	DocumentType VARCHAR(63)  NULL,
	DocumentIndex VARCHAR(63) NOT NULL,
	ISIndex VARCHAR(63) NOT NULL,
	CompleteStatus	VARCHAR(1) default 'N' NOT NULL
)

~
create table WFCaseDocStatusHistory(
    ProcessInstanceId VARCHAR(63) NOT NULL,
    WorkItemId INTEGER NOT NULL,
    ProcessDefId INTEGER NOT NULL,
    ActivityId INTEGER NOT NULL,
    TaskId  INTEGER NOT NULL,
	SubTaskId  INTEGER NOT NULL,
	DocumentType VARCHAR(63) NOT NULL,
	DocumentIndex VARCHAR(63) NOT NULL,
	ISIndex VARCHAR(63) NOT NULL,
	CompleteStatus	VARCHAR(1) default 'N' NOT NULL
)

~

CREATE TABLE CaseINITIATEWORKITEMTABLE ( 
	ProcessDefID 		INT				NOT NULL ,
	TaskId          INT    DEFAULT 0 NOT NULL,
	ImportedProcessName VARCHAR(30)	NOT NULL  ,
	ImportedFieldName 	VARCHAR(63)	NOT NULL ,
	ImportedVariableId	INT					NULL,
	ImportedVarFieldId	INT					NULL,
	MappedFieldName		VARCHAR(63)	NOT NULL ,
	MappedVariableId	INT					NULL,
	MappedVarFieldId	INT					NULL,
	FieldType			VARCHAR(1)		NOT NULL,
	MapType				VARCHAR(1)			NULL,
	DisplayName			VARCHAR(2000)		NULL,
	ImportedProcessDefId	INT				NULL,
	EntityType VARCHAR(1) DEFAULT 'A'  NOT NULL
)
~
CREATE TABLE CaseIMPORTEDPROCESSDEFTABLE (
	ProcessDefID 			INT 			NOT NULL,
	TaskId          INT   DEFAULT 0 NOT NULL ,
	ImportedProcessName 	VARCHAR(30)	NOT NULL ,
	ImportedFieldName 		VARCHAR(63)	NOT NULL ,
	FieldDataType			INT					NULL ,	
	FieldType				VARCHAR(1)		NOT NULL,
	VariableId				INT					NULL,
	VarFieldId				INT					NULL,
	DisplayName				VARCHAR(2000)		NULL,
	ImportedProcessDefId	INT					NULL,
	ProcessType				VARCHAR(1)		DEFAULT (N'R')	NULL   	
)

~

CREATE TABLE WFRulesTable (
    ProcessDefId            INT             NOT NULL,
    ActivityID              INT             NOT NULL,
    RuleId                  INT             NOT NULL,
    Condition               VARCHAR(255)    NOT NULL,
    Action                  VARCHAR(255)    NOT NULL    
)

~

CREATE TABLE WFSectionsTable (
    ProcessDefId            INT             NOT NULL,
    ProjectId               INT             NOT NULL,
    OrderId                 INT             NOT NULL,
    SectionName             VARCHAR(255)    NOT NULL,
    Description             VARCHAR(255)    NULL,
    Exclude                 VARCHAR(1)  	DEFAULT 'N' NOT NULL,
    ParentID                INT 			DEFAULT 0 NOT NULL,
    SectionId               INT             NOT NULL
)

~

create TABLE WFTransientVarTable(
    ProcessDefId            INT              NOT NULL,
    OrderId                 INT              NOT NULL,
    FieldName               VARCHAR(50)      NOT NULL,
    FieldType               VARCHAR(255)     NOT NULL,
    FieldLength             INT              NULL,
    DefaultValue            VARCHAR(255)     NULL,
    VarPrecision            INT              NULL,  
	VarScope                   VARCHAR(2)   DEFAULT 'U'   NOT NULL,	
    constraint pk_WFTRANSIENTVARTABLE PRIMARY KEY (ProcessDefId,FieldName)
)
~ 
create TABLE  WFScriptData(
    ProcessDefId           INT             NOT NULL,
    ActivityId             INT             NOT NULL,     
    RuleId                 INT             NOT NULL,
    OrderId                INT             NOT NULL,
    Command                varchar(255)    NOT NULL,
    Target                 varchar(2000)    NULL,
    Value                  varchar(2000)    NULL,
    Type                   varchar(1)      NULL,
    VariableId             INT             NOT NULL,
    VarFieldId             INT             NOT NULL,
    ExtObjId               INT             NOT NULL     
)
~ 
  create TABLE  WFRuleFlowData(
    ProcessDefId             INT             NOT NULL,
    ActivityId               INT             NOT NULL,
    RuleId                   INT             NOT NULL,
    RuleOrderId              INT             NOT NULL,
    RuleType                 varchar(1)      NOT NULL,
    RuleName                 varchar(100)    NOT NULL,
    RuleTypeId               INT             NOT NULL,
    Param1                   varchar(255)    NULL,
    Type1                    varchar(1)      NOT NULL,
    ExtObjID1                INT             NULL,
    VariableId_1             INT             NULL,
    VarFieldId_1             INT             NULL,
    Param2                   varchar(255)    NULL,
    Type2                    varchar(1)      NOT NULL,
    ExtObjID2                INT             NOT NULL,
    VariableId_2             INT             NOT NULL,
    VarFieldId_2             INT             NOT NULL,
    Param3                   varchar(255)    NULL,
    Type3                    varchar(1)      NOT NULL,
    ExtObjID3                INT             NOT NULL,
    VariableId_3             INT             NOT NULL,
    VarFieldId_3             INT             NOT NULL,
    Operator                 INT             NOT NULL,
    LogicalOp                INT             NOT NULL,
    IndentLevel              INT             NOT NULL
  )  
~   
create table WFRuleFileInfo(
    ProcessDefId             INT             NOT NULL,
    ActivityId               INT             NOT NULL,
    RuleId                   INT             NOT NULL,
    FileType                 varchar(1)      NOT NULL,
    RowHeader                INT             NOT NULL,
    Destination              varchar(255)    NULL,
    PickCriteria             varchar(255)    NULL,
    FromSize                 numeric(15,2)              NULL,
    ToSize                   numeric(15,2)              NULL,
    SizeUnit                 varchar(3)      NULL,
    FromModificationDate     TIMESTAMP       NULL,
    ToModificationDate       TIMESTAMP       NULL,
    FromCreationDate         TIMESTAMP       NULL,
    ToCreationDate           TIMESTAMP       NULL,
    PathType                 INT             NULL,
    DocId                    INT             NULL
)
~ 
create table WFWORKITEMMAPPINGTABLE(
    ProcessDefId             INT             NOT NULL,
    ActivityId               INT             NOT NULL,
    RuleId                   INT             NOT NULL,
    OrderId                  INT             NOT NULL,
    VariableName             varchar(255)    NULL,
    VariableId               INT             NOT NULL,
    VarFieldId               INT             NOT NULL,
    VariableType             varchar(2)      NOT NULL,
    ExtObjId                 INT             NOT NULL,
    MappedVariable           varchar(255)    NULL,
    MapType                  varchar(2)      DEFAULT 'V' NOT NULL 
)
~ 
create table WFExcelMapInfo(
    ProcessDefId             INT             NOT NULL,
    ActivityId               INT             NOT NULL,
    RuleId                   INT             NOT NULL,
    OrderId                  INT             NOT NULL,
    ColumnName               varchar(255)    NULL,
    ColumnType               INT             NOT NULL,
    VarName                  varchar(255)    NULL,
    VarScope                 varchar(1)      NULL,
    VarType                  INT             NOT NULL
)
~ 
create TABLE  WFRuleFlowMappingTable(
    ProcessDefId             INT             NOT NULL,
    ActivityId               INT             NOT NULL,
    RuleId                   INT             NOT NULL,
    OrderId                  INT             NOT NULL,
    ExtMethodIndex           INT             NOT NULL,
    MapType                  varchar(1)      NOT NULL,
    ExtMethodParamIndex      INT             NOT NULL,
    MappedField              varchar(255)    NULL,
    MappedFieldType          varchar(1)      NULL,
    VariableId               INT             NOT NULL,
    VarFieldId               INT             NOT NULL,
    DataStructureId          INT             NOT NULL 
)
~ 
create TABLE  WFRoboticVarDocMapping(
    ProcessDefId             INT             NOT NULL,
    FieldName                varchar(255)    NOT NULL, 
    MappedFieldName          varchar(255)    NOT NULL,                                                                                    
    ExtObjId                 INT             NOT NULL, 
    VariableId               INT             NOT NULL, 
    Attribute                varchar(2)      NOT NULL,        
    VariableType             INT             NOT NULL,  
    VariableScope            varchar(2)      NOT NULL,  
    VariableLength           INT             NOT NULL,   
    VarPrecision             INT             NOT NULL,
    Unbounded                varchar(2)      NOT NULL,  
    MapType                  varchar(2)      DEFAULT 'V' NOT NULL 
)
~
create TABLE  WFAssociatedExcpTable(
     ProcessDefId            INT             NOT NULL,
     ActivityId              INT             NOT NULL,
     OrderId                 INT             NOT NULL,
     CodeId                  varchar(1000)   NOT NULL, 
     TriggerId               varchar(1000)   NOT NULL                                                                                        
)


~

create TABLE  WFRuleExceptionData(
    ProcessDefId             INT             NOT NULL,
    ActivityId                 INT             NOT NULL,
    RuleId                     INT              NOT NULL,
    OrderId                 INT              NOT NULL,    
    Param1                     varchar(255)     NULL,
    Type1                     varchar(1)     NOT NULL,
    ExtObjID1                 INT              NULL,
    VariableId_1             INT              NULL,
    VarFieldId_1             INT              NULL,
    Param2                     varchar(255)     NULL,
    Type2                     varchar(1)     NOT NULL,
    ExtObjID2                 INT              NOT NULL,
    VariableId_2             INT              NOT NULL,
    VarFieldId_2             INT              NOT NULL,   
    Operator                 INT              NOT NULL,
    LogicalOp                 INT              NOT NULL    
) 


~

CREATE TABLE WFDBDetails(
    ProcessDefId int NOT NULL,
    ActivityId int NOT NULL,
    IsolateFlag varchar(2) NOT NULL,
    ConfigurationID int NOT NULL
)

~

CREATE TABLE WFTableDetails(
    ProcessDefId int NOT NULL,
    ActivityId int NOT NULL,
    RuleId int  NOT NULL,
    OrderId int  NOT NULL,
    EntityId int  NOT NULL,
    EntityName varchar(255) NOT NULL,
    EntityType varchar(2) NOT NULL
)

~

CREATE TABLE WFTableJoinDetails(
    ProcessDefId int NOT NULL,
    ActivityId int NOT NULL,
    RuleId int  NOT NULL,
    OrderId int  NOT NULL,
    EntityId_1 int  NOT NULL,
    ColumnName_1 varchar(255) NOT NULL,
    EntityId_2 int  NOT NULL,
    ColumnName_2 varchar(255) NOT NULL,
    JoinType int  NOT NULL
)

~

CREATE TABLE WFTableFilterDetails(
    ProcessDefId int NOT NULL,
    ActivityId int NOT NULL,
    RuleId int  NOT NULL,
    OrderId int  NOT NULL,
    EntityId int  NOT NULL,
    ColumnName varchar(255) NOT NULL,
    VarName varchar(255) NOT NULL,
    VarType varchar(2) NOT NULL,
    ExtObjId int NOT NULL,
    VarId int NOT NULL,
    VarFieldId int NOT NULL,
    Operator int  NOT NULL,
    LogicalOperator int NOT NULL
)

~

CREATE TABLE WFTableMappingDetails(
    ProcessDefId int NOT NULL,
    ActivityId int NOT NULL,
    RuleId int  NOT NULL,
    OrderId int  NOT NULL,
    EntityType varchar(2) NOT NULL,
    EntityName varchar(255) NOT NULL,
    ColumnName varchar(255) NOT NULL,
    Nullable varchar(2) NOT NULL,
    VarName varchar(255) NOT NULL,
    VarType varchar(2) NOT NULL,
    VarId int NOT NULL,
    VarFieldId int  NOT NULL,
    ExtObjId int NOT NULL,
    Type  INT NOT NULL,
    ColumnType varchar(255) NULL,
    VarName1 varchar(255) NOT NULL,
    VarType1 varchar(2) NOT NULL,
    VarId1 int NOT NULL,
    VarFieldId1 int NOT NULL,
    ExtObjId1 int NOT NULL,
    Type1 INT NOT NULL,
    Operator int NOT NULL,
    OperationType varchar(2) Default 'E' NOT NULL
)

~
/*--------------------------------------------------------------------------------------------------*/
INSERT  INTO WFSYSTEMPROPERTIESTABLE(PROPERTYKEY, PROPERTYVALUE) values('SYSTEMEMAILID','system_emailid@domain.com')

~

INSERT  INTO WFSYSTEMPROPERTIESTABLE(PROPERTYKEY, PROPERTYVALUE) values('ADMINEMAILID','admin_emailid@domain.com')

~

INSERT  INTO WFSYSTEMPROPERTIESTABLE(PROPERTYKEY, PROPERTYVALUE) values('AUTHORIZATIONFLAG','N')

~

INSERT  INTO WFSYSTEMPROPERTIESTABLE(PROPERTYKEY, PROPERTYVALUE) values('SHAREPOINTFLAG','N')

~
INSERT  INTO WFUserSkillCategoryTable(Categoryid, CategoryName,CategoryDefinedBy,CategoryAvailableForRating) values(1,'Default',1,'N')

~

Insert into WFWorkdeskLayoutTable (ProcessDefId, ActivityId,TaskId, WSLayoutDefinition) values (0, 0, 0 , '<WDeskLayout Interfaces="4"><Resolution><ScreenWidth>1024</ScreenWidth><ScreenHeight>768</ScreenHeight></Resolution>        <WDeskInterfaces><Interface Type=''FormView'' Top=''50'' Left=''2'' Width=''501'' Height=''615''/><Interface Type=''Document'' Top=''50'' Left=''510'' Width=''501'' Height=''615''/></WDeskInterfaces><MenuInterfaces><Interface Type="Exceptions"/><Interface Type="ToDoList"/></MenuInterfaces></WDeskLayout>')


~

/*Insert into WFWorkdeskLayoutTable (ProcessDefId, ActivityId,TaskId, WSLayoutDefinition) values (0, 0, -1 , '<WDeskLayout Interfaces="5"><Resolution><ScreenWidth>580</ScreenWidth><ScreenHeight>360</ScreenHeight></Resolution><WDeskInterfaces><Interface Type="FormView" Top="0" Left="245" Width="329" Height="160" /><Interface Type="Document" Top="170" Left="244" Width="332" Height="150" /><Interface Type="Exceptions" Top="170" Left="0" Width="235" Height="150" /><Interface Type="DynamicCase" Top="0" Left="0" Width="235" Height="160" /></WDeskInterfaces><MenuInterfaces><Interface Type="ToDoList" /></MenuInterfaces></WDeskLayout>')*/


CREATE SEQUENCE SEQ_MESSAGEID 
	START WITH 1 INCREMENT BY 1

~
/********seq_attribmessageId************/

CREATE SEQUENCE SEQ_ATTRIBMESSAGEID
		INCREMENT BY 1 START WITH 1 

~

/****** seq_rootlogid ******/

CREATE SEQUENCE seq_rootlogid 
	INCREMENT BY 1 START WITH 1 		
	
~

/*	PSID added before table
CREATE SEQUENCE PSID	
	INCREMENT BY 1 START WITH 10000000
 
* 
Not required as LOGID is of serial type in WFCURRENTROUTELOGTABLE 

CREATE SEQUENCE LOGID	
	INCREMENT BY 1 START WITH 1

Not required as QUEUEID is of serial type in QUEUEDEFTABLE 
	CREATE SEQUENCE QUEUEID	 
	INCREMENT BY 1 START WITH 1
	
Not required as REMINDEX IS OF serial type in WFREMINDERTABLE	 
CREATE SEQUENCE WFREMID 
	START WITH 1 INCREMENT BY 1 MINVALUE 1
	
Not required as ID IS OF serial type in VARALIASTABLE	 
CREATE SEQUENCE ALIASID 
	START WITH 1 INCREMENT BY 1 MINVALUE 1

Not required as VARIABLEID IS OF serial type in WFQUICKSEARCHTABLE	 

	CREATE SEQUENCE VARIABLEID
	INCREMENT BY 1 START WITH 1

Not required as COMMENTSID IS OF serial type in WFCOMMENTSTABLE	 	
	CREATE SEQUENCE COMMENTSID 
	INCREMENT BY 1 START WITH 1
	
Not required as AdminLogId IS OF serial type in WFAdminLogTable	 	
CREATE SEQUENCE AdminLogId	
	INCREMENT BY 1 START WITH 1	

Not required as TMSLOGID is of type SERIAL in WFTransportDataTable
CREATE SEQUENCE TMSLOGID	
	INCREMENT BY 1 START WITH 1    

Not required as id is of type SERIAL in WFQueueColorTable
CREATE SEQUENCE SEQ_QueueColorId	
	INCREMENT BY 1 START WITH 1
	
Not required as LibraryId is of type SERIAL in WFQueueColorTable
CREATE SEQUENCE LibraryId
	INCREMENT BY 1 START WITH 1 
	
*/

/****** PSREGID ******/

CREATE SEQUENCE PSREGID	  
	INCREMENT BY 1 START WITH 1

~
/********  ESCALATIONID  **********/

CREATE SEQUENCE EscalationId 
	START WITH 1 INCREMENT BY 1 MINVALUE 1

~
/******** JMSMessageId **********/

CREATE SEQUENCE JMSMessageId 
	START WITH 1 INCREMENT BY 1 MINVALUE 1

~

/******** CABVERSIONID **********/
CREATE SEQUENCE	CABVERSIONID	 
	INCREMENT BY 1 START WITH 1

~


/****** INFOID ******/

CREATE SEQUENCE INFOID 
	INCREMENT BY 1 START WITH 1 



~

/****** SEQ_AuthorizationID ******/

CREATE SEQUENCE SEQ_AuthorizationID 
	START WITH 1 INCREMENT BY 1
    
~    
    
/****** SEQ_WFImportFileId ******/
CREATE SEQUENCE SEQ_WFImportFileId START WITH 1 INCREMENT BY 1

~

/****** Seq_ServiceId ******/
/****** Bugzilla Bug 12649 ******/

CREATE SEQUENCE Seq_ServiceId 
	INCREMENT BY 1 START WITH 1 

~
/********ProcessDefId************/

CREATE SEQUENCE ProcessDefId
	INCREMENT BY 1 START WITH 1 

~

/********RevisionNoSequence************/

	CREATE SEQUENCE RevisionNoSequence
		INCREMENT BY 1 START WITH 1 

~

/********ConflictIdSequence************/

	CREATE SEQUENCE ConflictIdSequence
		INCREMENT BY 1 START WITH 1 

~

/********ProfileIdSequence************/

CREATE SEQUENCE ProfileIdSequence
	INCREMENT BY 1 START WITH 1 

~
	
/********ObjectTypeIdSequence************/
	
CREATE SEQUENCE ObjectTypeIdSequence
	INCREMENT BY 1 START WITH 1 

~


/****** Export_Sequence ******/

CREATE SEQUENCE Export_Sequence 
	INCREMENT BY 1 START WITH 1
	
~

/****** ProcessVariantId ******/

CREATE SEQUENCE ProcessVariantId 
	INCREMENT BY 1 START WITH 1 	

~

/****** FormExtId ******/

CREATE SEQUENCE FormExtId 
	INCREMENT BY 1 START WITH 1 		
	
~

/****** MapIdSeqGenerator ******/

CREATE SEQUENCE MapIdSeqGenerator
	INCREMENT BY 1 START WITH 1 		
	
~
/****** TemplateVariableId ******/
CREATE SEQUENCE TemplateVariableId
	INCREMENT BY 1 START WITH 1 

~
/****** TemplateId ******/
CREATE SEQUENCE TemplateId
	INCREMENT BY 1 START WITH 1 


~
CREATE SEQUENCE TASKDEFID 
	INCREMENT BY 1 START WITH 1

~

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
CREATE SEQUENCE seq_userExpertise 
	INCREMENT BY 1 START WITH 1

~

CREATE SEQUENCE seq_userRating 
	INCREMENT BY 1 START WITH 1

~
/**** WFGROUPMEMBERVIEW ****/

CREATE OR REPLACE VIEW WFGROUPMEMBERVIEW ( GROUPINDEX,USERINDEX ) 
AS 
	SELECT GROUPINDEX,USERINDEX
	FROM PDBGROUPMEMBER

~

/*********** ROUTELOGTABLE VIEW****************/
CREATE OR REPLACE VIEW ROUTELOGTABLE 
AS 
	SELECT * FROM WFCURRENTROUTELOGTABLE 
	UNION ALL
	SELECT * FROM WFHISTORYROUTELOGTABLE 

~



/***********	QUSERGROUPVIEW	****************/
CREATE OR REPLACE VIEW QUSERGROUPVIEW 
AS
	SELECT queueId,userId, NULL AS groupId, AssignedtillDateTime, queryFilter, QueryPreview , EDITABLEONQUERY 
	FROM   QUEUEUSERTABLE 
	WHERE  ASsociationtype=0
 	AND (AssignedtillDateTime IS NULL OR AssignedtillDateTime>=CURRENT_TIMESTAMP)
	UNION
	SELECT queueId, userindex,userId AS groupId,NULL AS AssignedtillDateTime, queryFilter, QueryPreview, EDITABLEONQUERY
 	FROM   QUEUEUSERTABLE , WFGROUPMEMBERVIEW 
	WHERE  ASsociationtype=1 
	AND    QUEUEUSERTABLE.userId=WFGROUPMEMBERVIEW.groupindex 

~

/***********	QUEUETABLE	****************/
CREATE OR REPLACE VIEW QUEUETABLE 
AS
	SELECT processdefid, processname, processversion,processinstanceid,
		 processinstanceid AS processinstancename, 
		 activityid, activityname, 
		 parentworkitemid, workitemid, 

		 processinstancestate, workitemstate, statename, queuename, queuetype,
		 assigneduser, assignmenttype, instrumentstatus, checklistcompleteflag, 
		 introductiondatetime, createddatetime,
		 introducedby, createdbyname, entrydatetime,lockstatus, holdstatus, 


		 prioritylevel, lockedbyname, lockedtime, validtill, savestage, 

		 previousstage,	expectedworkitemdelay AS expectedworkitemdelaytime,
	         expectedprocessdelay AS expectedprocessdelaytime, status, 
		 var_int1, var_int2, var_int3, var_int4, var_int5, var_int6, var_int7, var_int8, 

		 var_float1, var_float2, var_date1, var_date2, var_date3, var_date4, var_date5, var_date6, 
		 var_long1, var_long2, var_long3, var_long4, var_long5, var_long6, 
		 var_str1, var_str2, var_str3, var_str4, var_str5, var_str6, var_str7, var_str8,var_str9, var_str10, var_str11,
		 var_str12, var_str13, var_str14, var_str15, var_str16, var_str17, var_str18, var_str19, var_str20,
		 var_rec_1, var_rec_2, var_rec_3, var_rec_4, var_rec_5,	
		 q_streamid, q_queueid, q_userid, LastProcessedBy, processedby, referredto,
		 referredtoname, referredby, referredbyname, collectflag, NULL AS CompletionDateTime, CalendarName, ProcessVariantId
	FROM	WFINSTRUMENTTABLE
~

/***********	QUEUEVIEW	****************/

CREATE OR REPLACE VIEW queueview AS 
 SELECT queuetable.processdefid,
    queuetable.processname,
    queuetable.processversion,
    queuetable.processinstanceid,
    queuetable.processinstancename,
    queuetable.activityid,
    queuetable.activityname,
    queuetable.parentworkitemid,
    queuetable.workitemid,
    queuetable.processinstancestate,
    queuetable.workitemstate,
    queuetable.statename,
    queuetable.queuename,
    queuetable.queuetype,
    queuetable.assigneduser,
    queuetable.assignmenttype,
    queuetable.instrumentstatus,
    queuetable.checklistcompleteflag,
    queuetable.introductiondatetime,
    queuetable.createddatetime,
    queuetable.introducedby,
    queuetable.createdbyname,
    queuetable.entrydatetime,
    queuetable.lockstatus,
    queuetable.holdstatus,
    queuetable.prioritylevel,
    queuetable.lockedbyname,
    queuetable.lockedtime,
    queuetable.validtill,
    queuetable.savestage,
    queuetable.previousstage,
    queuetable.expectedworkitemdelaytime,
    queuetable.expectedprocessdelaytime,
    queuetable.status,
    queuetable.var_int1,
    queuetable.var_int2,
    queuetable.var_int3,
    queuetable.var_int4,
    queuetable.var_int5,
    queuetable.var_int6,
    queuetable.var_int7,
    queuetable.var_int8,
    queuetable.var_float1,
    queuetable.var_float2,
    queuetable.var_date1,
    queuetable.var_date2,
    queuetable.var_date3,
    queuetable.var_date4,
	queuetable.var_date5,
    queuetable.var_date6,
    queuetable.var_long1,
    queuetable.var_long2,
    queuetable.var_long3,
    queuetable.var_long4,
	queuetable.var_long5,
    queuetable.var_long6,
    queuetable.var_str1,
    queuetable.var_str2,
    queuetable.var_str3,
    queuetable.var_str4,
    queuetable.var_str5,
    queuetable.var_str6,
    queuetable.var_str7,
    queuetable.var_str8,
	queuetable.var_str9,
    queuetable.var_str10,
    queuetable.var_str11,
    queuetable.var_str12,
    queuetable.var_str13,
    queuetable.var_str14,
    queuetable.var_str15,
    queuetable.var_str16,
	queuetable.var_str17,
    queuetable.var_str18,
    queuetable.var_str19,
    queuetable.var_str20,
    queuetable.var_rec_1,
    queuetable.var_rec_2,
    queuetable.var_rec_3,
    queuetable.var_rec_4,
    queuetable.var_rec_5,
    queuetable.q_streamid,
    queuetable.q_queueid,
    queuetable.q_userid,
    queuetable.lastprocessedby,
    queuetable.processedby,
    queuetable.referredto,
    queuetable.referredtoname,
    queuetable.referredby,
    queuetable.referredbyname,
    queuetable.collectflag,
    queuetable.completiondatetime,
    queuetable.calendarname,
	queuetable.processvariantid
   FROM queuetable
UNION ALL
 SELECT queuehistorytable.processdefid,
    queuehistorytable.processname,
    queuehistorytable.processversion,
    queuehistorytable.processinstanceid,
    queuehistorytable.processinstanceid AS processinstancename,
    queuehistorytable.activityid,
    queuehistorytable.activityname,
    queuehistorytable.parentworkitemid,
    queuehistorytable.workitemid,
    queuehistorytable.processinstancestate,
    queuehistorytable.workitemstate,
    queuehistorytable.statename,
    queuehistorytable.queuename,
    queuehistorytable.queuetype,
    queuehistorytable.assigneduser,
    queuehistorytable.assignmenttype,
    queuehistorytable.instrumentstatus,
    queuehistorytable.checklistcompleteflag,
    queuehistorytable.introductiondatetime,
    queuehistorytable.createddatetime,
    queuehistorytable.introducedby,
    queuehistorytable.createdbyname,
    queuehistorytable.entrydatetime,
    queuehistorytable.lockstatus,
    queuehistorytable.holdstatus,
    queuehistorytable.prioritylevel,
    queuehistorytable.lockedbyname,
    queuehistorytable.lockedtime,
    queuehistorytable.validtill,
    queuehistorytable.savestage,
    queuehistorytable.previousstage,
    queuehistorytable.expectedworkitemdelaytime,
    queuehistorytable.expectedprocessdelaytime,
    queuehistorytable.status,
    queuehistorytable.var_int1,
    queuehistorytable.var_int2,
    queuehistorytable.var_int3,
    queuehistorytable.var_int4,
    queuehistorytable.var_int5,
    queuehistorytable.var_int6,
    queuehistorytable.var_int7,
    queuehistorytable.var_int8,
    queuehistorytable.var_float1,
    queuehistorytable.var_float2,
    queuehistorytable.var_date1,
    queuehistorytable.var_date2,
    queuehistorytable.var_date3,
    queuehistorytable.var_date4,
	queuehistorytable.var_date5,
    queuehistorytable.var_date6,
    queuehistorytable.var_long1,
    queuehistorytable.var_long2,
    queuehistorytable.var_long3,
    queuehistorytable.var_long4,
	queuehistorytable.var_long5,
    queuehistorytable.var_long6,
    queuehistorytable.var_str1,
    queuehistorytable.var_str2,
    queuehistorytable.var_str3,
    queuehistorytable.var_str4,
    queuehistorytable.var_str5,
    queuehistorytable.var_str6,
    queuehistorytable.var_str7,
    queuehistorytable.var_str8,
	queuehistorytable.var_str9,
    queuehistorytable.var_str10,
    queuehistorytable.var_str11,
    queuehistorytable.var_str12,
    queuehistorytable.var_str13,
    queuehistorytable.var_str14,
    queuehistorytable.var_str15,
    queuehistorytable.var_str16,
	queuehistorytable.var_str17,
    queuehistorytable.var_str18,
    queuehistorytable.var_str19,
    queuehistorytable.var_str20,
    queuehistorytable.var_rec_1,
    queuehistorytable.var_rec_2,
    queuehistorytable.var_rec_3,
    queuehistorytable.var_rec_4,
    queuehistorytable.var_rec_5,
    queuehistorytable.q_streamid,
    queuehistorytable.q_queueid,
    queuehistorytable.q_userid,
    queuehistorytable.lastprocessedby,
    queuehistorytable.processedby,
    queuehistorytable.referredto,
    queuehistorytable.referredtoname,
    queuehistorytable.referredby,
    queuehistorytable.referredbyname,
    queuehistorytable.collectflag,
    NULL::text AS completiondatetime,
    queuehistorytable.calendarname,
	queuehistorytable.processvariantid
   FROM queuehistorytable

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

/***********	WFUSERVIEW	****************/
CREATE OR REPLACE VIEW WFUSERVIEW ( USERINDEX, USERNAME, PERSONALNAME, FAMILYNAME, CREATEDDATETIME, 
				      EXPIRYDATETIME, PRIVILEGECONTROLLIST, PASSWORD, ACCOUNT, 
				      COMMNT, DELETEDDATETIME, USERALIVE, MAINGROUPID, 
				      MAILID, FAX, NOTECOLOR, SUPERIOR, SUPERIORFLAG, PARENTGROUPINDEX   ) 
AS 
	SELECT  USERINDEX,(BTRIM(COALESCE(USERNAME,''))) as USERNAME,PERSONALNAME,FAMILYNAME,
		CREATEDDATETIME, EXPIRYDATETIME,PRIVILEGECONTROLLIST,
		PASSWORD,ACCOUNT,COMMENT,DELETEDDATETIME,USERALIVE,
		MAINGROUPID,MAILID,FAX,NOTECOLOR, SUPERIOR, SUPERIORFLAG, PARENTGROUPINDEX 
	FROM PDBUSER where deletedflag = 'N' and UserAlive='Y' and expirydatetime > CURRENT_TIMESTAMP

~

/***********	WFALLUSERVIEW	****************/
CREATE OR REPLACE VIEW WFALLUSERVIEW ( USERINDEX, USERNAME, PERSONALNAME, FAMILYNAME, CREATEDDATETIME, 
				      EXPIRYDATETIME, PRIVILEGECONTROLLIST, PASSWORD, ACCOUNT, 
				      COMMNT, DELETEDDATETIME, USERALIVE, MAINGROUPID, 
				      MAILID, FAX, NOTECOLOR, SUPERIOR, SUPERIORFLAG, PARENTGROUPINDEX  ) 
AS 
	SELECT  USERINDEX,(BTRIM(COALESCE(USERNAME,''))) as USERNAME,PERSONALNAME,FAMILYNAME,
		CREATEDDATETIME, EXPIRYDATETIME,PRIVILEGECONTROLLIST,
		PASSWORD,ACCOUNT,COMMENT,DELETEDDATETIME,USERALIVE,
		MAINGROUPID,MAILID,FAX,NOTECOLOR, SUPERIOR, SUPERIORFLAG, PARENTGROUPINDEX  
	FROM PDBUSER where deletedflag = 'N'

~

/***********	WFCOMPLETEUSERVIEW	****************/
CREATE OR REPLACE VIEW WFCOMPLETEUSERVIEW ( USERINDEX, USERNAME, PERSONALNAME, FAMILYNAME, CREATEDDATETIME, 
				      EXPIRYDATETIME, PRIVILEGECONTROLLIST, PASSWORD, ACCOUNT, 
				      COMMNT, DELETEDDATETIME, USERALIVE, MAINGROUPID, 
				      MAILID, FAX, NOTECOLOR, SUPERIOR, SUPERIORFLAG, PARENTGROUPINDEX  ) 
AS 
	SELECT  USERINDEX,(BTRIM(COALESCE(USERNAME,''))) as USERNAME,PERSONALNAME,FAMILYNAME,
		CREATEDDATETIME, EXPIRYDATETIME,PRIVILEGECONTROLLIST,
		PASSWORD,ACCOUNT,COMMENT,DELETEDDATETIME,USERALIVE,
		MAINGROUPID,MAILID,FAX,NOTECOLOR, SUPERIOR, SUPERIORFLAG, PARENTGROUPINDEX  
	FROM PDBUSER 

~
/***********	WFGROUPVIEW	****************/
CREATE OR REPLACE VIEW WFGROUPVIEW ( GROUPINDEX,GROUPNAME, CREATEDDATETIME, EXPIRYDATETIME, 
					PRIVILEGECONTROLLIST, OWNER, COMMNT, GROUPTYPE, 
					MAINGROUPINDEX, PARENTGROUPINDEX ) 
AS 
	SELECT  groupindex,groupname,createddatetime,expirydatetime,
		privilegecontrollist,owner,comment,grouptype,maingroupindex,parentgroupindex 
	FROM PDBGROUP


~

CREATE OR REPLACE VIEW WFROLEVIEW ( ROLEINDEX,ROLENAME,DESCRIPTION, MANYUSERFLAG) 
AS 
	SELECT  ROLEINDEX, ROLENAME, DESCRIPTION, MANYUSERFLAG
	FROM PDBROLES
	
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

CREATE OR REPLACE VIEW PROFILEUSERGROUPVIEW
AS 
	SELECT PROFILEID, USERID, GROUPID, ROLEID, ASSIGNEDTILLDATETIME FROM (
	SELECT profileId, userid, cast ( NULL AS integer ) AS groupid, cast ( NULL AS integer ) AS roleid ,NULL AssignedtillDateTime
	FROM WFUserObjAssocTable 
	WHERE Associationtype=0
	AND (AssignedtillDateTime is NULL or AssignedtillDateTime>=CURRENT_TIMESTAMP)
	UNION ALL
	SELECT profileId, userindex, userId AS groupid, cast ( NULL AS integer ) AS roleid, NULL AssignedtillDateTime
	FROM WFUserObjAssocTable , WFGROUPMEMBERVIEW 
	WHERE Associationtype=1
	AND WFUserObjAssocTable.userid=WFGROUPMEMBERVIEW.groupindex 
	AND (AssignedtillDateTime is NULL or AssignedtillDateTime>=CURRENT_TIMESTAMP)
	UNION ALL
	SELECT profileId, userindex, groupindex, userId AS roleid, NULL AssignedtillDateTime
	FROM WFUserObjAssocTable , PDBGroupRoles 
	WHERE Associationtype=3
	AND WFUserObjAssocTable.userid=PDBGroupRoles.roleindex 
	AND (AssignedtillDateTime is NULL or AssignedtillDateTime>=CURRENT_TIMESTAMP))a
	
~

CREATE OR REPLACE VIEW WFCOMMENTSVIEW 	AS 
SELECT * FROM WFCOMMENTSTABLE
UNION ALL
SELECT * FROM WFCOMMENTSHISTORYTABLE

~

/*********** CREATE FUNCTIONS FOR Triggers ****************/
CREATE OR REPLACE FUNCTION WFUserDeletion() RETURNS TRIGGER AS '
BEGIN
	UPDATE WFINSTRUMENTTABLE 
	SET	AssignedUser = NULL, AssignmentType = NULL, LockStatus = ''N'', 
		LockedByName = NULL, LockedTime = NULL, Q_UserId = 0,
		QueueName = (SELECT QUEUEDEFTABLE.QueueName 
		FROM   QUEUESTREAMTABLE , QUEUEDEFTABLE
		WHERE  QUEUESTREAMTABLE.QueueID = QUEUEDEFTABLE.QueueID 
	AND	StreamID = Q_StreamID
	AND QUEUESTREAMTABLE.ProcessDefId = WFINSTRUMENTTABLE.ProcessDefId
	AND QUEUESTREAMTABLE.ActivityId = WFINSTRUMENTTABLE.ActivityId),
		QueueType = (SELECT QUEUEDEFTABLE.QueueType 
			FROM   QUEUESTREAMTABLE , QUEUEDEFTABLE
			WHERE  QUEUESTREAMTABLE.QueueID = QUEUEDEFTABLE.QueueID 
			AND    StreamID = Q_StreamID
			AND QUEUESTREAMTABLE.ProcessDefId = WFINSTRUMENTTABLE.ProcessDefId
			AND QUEUESTREAMTABLE.ActivityId = WFINSTRUMENTTABLE.ActivityId),
		Q_QueueID = (SELECT QueueId 
			FROM QUEUESTREAMTABLE 	
			WHERE StreamID = Q_StreamID
			AND QUEUESTREAMTABLE.ProcessDefId = WFINSTRUMENTTABLE.ProcessDefId
			AND QUEUESTREAMTABLE.ActivityId = WFINSTRUMENTTABLE.ActivityId)	
	WHERE Q_UserId = OLD.UserIndex AND RoutingStatus =''N'' AND LockStatus = ''N'' ;
	UPDATE WFINSTRUMENTTABLE 
	SET	AssignedUser = NULL, AssignmentType = NULL, LockStatus = ''N'',
		LockedByName = NULL, LockedTime = NULL, Q_UserId = 0 
	WHERE  AssignmentType != ''F'' AND Q_UserId = OLD.UserIndex AND LockStatus = ''N'' AND RoutingStatus = ''N'';
DELETE FROM QUEUEUSERTABLE  WHERE  UserID = OLD.UserIndex AND    Associationtype = 0;
		
	DELETE FROM USERQUEUETABLE WHERE UserID = OLD.UserIndex;
	DELETE FROM USERPREFERENCESTABLE WHERE  UserID = OLD.UserIndex;
	DELETE FROM USERDIVERSIONTABLE WHERE  Diverteduserindex = OLD.UserIndex OR     AssignedUserindex = OLD.UserIndex;
	DELETE FROM USERWORKAUDITTABLE 	WHERE  Userindex = OLD.UserIndex OR     Auditoruserindex = OLD.UserIndex;
	DELETE FROM WFProfileObjTypeTable  WHERE  UserID = OLD.UserIndex AND    Associationtype = 0;
	DELETE FROM WFUserObjAssocTable  WHERE  UserID = OLD.UserIndex AND    Associationtype = 0;
	DELETE FROM PMWQUEUEUSERTABLE  WHERE UserID = OLD.UserIndex AND Associationtype = 0;
	RETURN NULL; 
END;
' LANGUAGE 'plpgsql'

~
CREATE OR REPLACE FUNCTION WFUtilUnregister() RETURNS TRIGGER AS $$
DECLARE 
	PSName VARCHAR(100);
	PSData VARCHAR(50);
	v_userName VARCHAR(100);
	BEGIN
		PSName := OLD.PSName;
		PSData := OLD.Data;
		IF (PSData = 'PROCESS SERVER') THEN
		BEGIN				
			Update WFInstrumentTable set Q_UserId = 0, AssignedUser = null, LockedByName = null , LockStatus = 'N', LockedTime = null where LockedByName = PSName and LockStatus = 'Y' and RoutingStatus = 'Y';
		END;
		END IF;
		IF (PSData = 'MAILING AGENT') THEN
		BEGIN
			UPDATE WFMailQueueTable SET MailStatus = 'N', LockedBy = null, LastLockTime = null, NoOfTrials = 0 where LockedBy = PSName;
		END;
		END IF;
		IF (PSData = 'MESSAGE AGENT') THEN
		BEGIN
			UPDATE WFMessageTable SET LockedBy = null, Status = 'N' where LockedBy = PSName;
		END;
		END IF;
		IF (PSData = 'PRINT,FAX & EMAIL' OR PSData = 'ARCHIVE UTILITY') THEN
		BEGIN
			Update WFInstrumentTable set Q_UserId = 0, AssignedUser = null , LockedByName = null , LockStatus = 'N', LockedTime = null 
			 where  LockedByName = PSName and LockStatus = 'Y'  and RoutingStatus = 'N';
		END;
		END IF;
		/*	73125 - Getting unnecessary error message while un-registering server	
		SELECT INTO v_userName userName FROM pdbuser WHERE userindex = OLD.userindex; 
		INSERT into WFCURRENTROUTELOGTABLE (ProcessDefId, ActivityId, ProcessInstanceId, WorkItemId, UserId, ActionId, ActionDateTime, AssociatedFieldId, AssociatedFieldName, ActivityName, UserName)VALUES(0, 0, NULL, 0, OLD.userindex, 24, CURRENT_TIMESTAMP, OLD.userindex, v_userName, NULL, v_userName); 
		*/
		RETURN NULL;
	END;
$$LANGUAGE plpgsql;

~

CREATE OR REPLACE FUNCTION WFGroupDeletion() RETURNS TRIGGER AS $$
DECLARE
	BEGIN
		DELETE FROM QUEUEUSERTABLE WHERE  USERID = OLD.GROUPINDEX AND ASSOCIATIONTYPE = 1; 
		RETURN NULL;
	END;
$$LANGUAGE plpgsql;

~

CREATE OR REPLACE FUNCTION WFGroupMemberChange() RETURNS TRIGGER AS $$
DECLARE
	BEGIN
		IF TG_OP = 'INSERT' THEN
			DELETE FROM USERQUEUETABLE WHERE USERID = NEW.USERINDEX;
		ELSIF TG_OP = 'DELETE' THEN
			DELETE FROM USERQUEUETABLE WHERE USERID = OLD.USERINDEX;
		END IF;
		RETURN NULL;
	END;
$$LANGUAGE plpgsql;

~

/***********	TR_USR_DEL	****************/

CREATE TRIGGER TR_USR_DEL
    AFTER UPDATE ON PDBUSER
    FOR EACH ROW
    WHEN (NEW.DeletedFlag = 'Y')
    EXECUTE PROCEDURE WFUserDeletion();

~
/***********WF_UTIL_UNREGISTER****************/
CREATE TRIGGER WF_UTIL_UNREGISTER 
AFTER DELETE ON PSREGISTERATIONTABLE FOR EACH ROW
	EXECUTE PROCEDURE WFUtilUnregister();
~

/***********WF_GROUP_DEL****************/
CREATE TRIGGER WF_GROUP_DEL 
AFTER DELETE ON PDBGROUP FOR EACH ROW
EXECUTE PROCEDURE WFGroupDeletion();

~
/***********WF_GROUPMEMBER_UPD****************/
CREATE TRIGGER WF_GROUPMEMBER_UPD 
AFTER DELETE OR INSERT ON PDBGROUPMEMBER FOR EACH ROW 
EXECUTE PROCEDURE WFGroupMemberChange();

~

/***********INDEX FOR SUMMARYTABLE****************/

CREATE INDEX IDX1_SUMMARYTABLE ON SUMMARYTABLE
        (PROCESSDEFID, ACTIONID, ActionDateTime, ACTIVITYID, QueueId, USERID)	
~

/***********INDEX FOR WFMessageInProcesstable****************/
CREATE INDEX IX1_WFMessageInProcessTable ON WFMessageInProcessTable (lockedBy)

~

/***********INDEX FOR WFEscalationTable****************/
/*CREATE INDEX IX1_WFEscalationTable ON WFEscalationTable (EscalationMode, ScheduleTime)*/
CREATE INDEX IDX2_WFEscalationTable ON WFEscalationTable (ScheduleTime)

~

/***********INDEX FOR WFEscalationTable****************/

CREATE INDEX IDX3_WFEscalationTable ON WFEscalationTable (ProcessInstanceId,WorkitemId)

~

/***********INDEX FOR QueueStreamTable****************/
CREATE INDEX IDX1_QueueStreamTable ON QueueStreamTable (QueueId)

~

/***********INDEX FOR QueueDefTable****************/
CREATE INDEX IDX2_QueueDefTable ON QueueDefTable (UPPER(RTRIM(QueueName)))

~

/***********INDEX FOR VarMappingTable****************/
CREATE INDEX IDX2_VarMappingTable ON VarMappingTable (UPPER(RTRIM(UserDefinedName)))

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
CREATE INDEX IDX1_ExceptionTable ON ExceptionTable (ProcessInstanceId, ProcessDefId, ActivityId, ExceptionId, excpseqid , ActionId )

~

/***********INDEX FOR ExceptionTable****************/
CREATE INDEX IDX2_ExceptionTable ON ExceptionTable (ProcessInstanceId)

~

/***********INDEX FOR ExceptionHistoryTable****************/
CREATE INDEX IDX1_ExceptionHistoryTable ON ExceptionHistoryTable (ProcessInstanceId, ProcessDefId, ActivityId, ExceptionId, excpseqid , ActionId )

~

/***********INDEX FOR ExceptionHistoryTable****************/
CREATE INDEX IDX2_ExceptionHistoryTable ON ExceptionHistoryTable (ProcessInstanceId)

~

/***********INDEX FOR WFCURRENTROUTELOGTABLE ****************/
CREATE INDEX  IDX1_WFRouteLogTABLE ON WFCURRENTROUTELOGTABLE (ProcessDefId,ActionId)

~

/***********INDEX FOR WFCURRENTROUTELOGTABLE ****************/
CREATE INDEX  IDX2_WFRouteLogTABLE ON WFCURRENTROUTELOGTABLE (ActionId,UserID)

~

/***********INDEX FOR WFCURRENTROUTELOGTABLE ****************/
CREATE INDEX IDX3_WFCRouteLogTable ON WFCurrentRouteLogTable (ProcessInstanceId)

~

/***********INDEX FOR WFHISTORYROUTELOGTABLE ****************/
CREATE INDEX  IDX1_WFHRouteLogTABLE ON WFHISTORYROUTELOGTABLE (ProcessDefId,ActionId)

~

/***********INDEX FOR WFHISTORYROUTELOGTABLE ****************/
CREATE INDEX  IDX2_WFHRouteLogTABLE ON WFHISTORYROUTELOGTABLE (ActionId,UserID)

~

/***********INDEX FOR WFHISTORYROUTELOGTABLE ****************/
CREATE INDEX IDX3_WFHRouteLogTable ON WFHistoryRouteLogTable (ProcessInstanceId)

~

/***********INDEX FOR ActivityAssociationTable****************/
CREATE INDEX IDX1_ActivityAssociationTable ON ActivityAssociationTable (ProcessdefId, ActivityId, VariableId)

~

/***********INDEX FOR WFWSAsyncResponseTable****************/
CREATE INDEX IDX1_WFWSAsyncResponseTable ON WFWSAsyncResponseTable (CorrelationId1)

~

CREATE INDEX IDX1_WFMAILQUEUETABLE ON WFMAILQUEUETABLE(MAILPRIORITY , NOOFTRIALS )  

~

CREATE INDEX IDX1_ExtInterfaceCondTable ON WFExtInterfaceConditionTable (ProcessDefId, InterfaceType, RuleId, RuleOrderId, ConditionOrderId)  

~
CREATE INDEX IDX1_ActivityTable ON ActivityTable (ActivityType)

~

CREATE INDEX IDX4_WFCRouteLogTable ON WFCurrentRouteLogTable (ProcessInstanceId, ActionDateTime, LogID)

~

CREATE INDEX  IDX4_WFHRouteLogTABLE ON WFHISTORYROUTELOGTABLE (ProcessInstanceId, ActionDateTime, LogID)



--CREATE INDEX  IDX2_QueueHistoryTable ON QueueHistoryTable (ActivityName)

~

CREATE INDEX  IDX3_QueueHistoryTable ON QueueHistoryTable (VAR_REC_1, VAR_REC_2)


~
--CREATE INDEX  IDX4_QueueHistoryTable ON QueueHistoryTable (Q_QueueId)

CREATE INDEX IDX6_QueueHistoryTable ON QueueHistoryTable (ProcessDefId, ActivityId)

--CREATE INDEX  IDX5_QueueHistoryTable ON QueueHistoryTable (Q_UserId, LockStatus)

~

CREATE INDEX IDX2_QueueStreamTable ON QueueStreamTable (Activityid, Streamid)

~

CREATE INDEX IDX3_ExceptionTable ON ExceptionTable (ProcessDefId, ActivityId)

~

CREATE INDEX IDX1_TODOSTATUSTABLE ON TODOSTATUSTABLE (ProcessInstanceId)

~

CREATE INDEX IDX1_TODOSTATUSHISTORYTABLE ON TODOSTATUSHISTORYTABLE (ProcessInstanceId)

~
CREATE INDEX IDX1_WFINSTRUMENTTABLE ON WFINSTRUMENTTABLE (var_rec_1, var_rec_2)

~

--CREATE INDEX IDX2_WFINSTRUMENTTABLE ON WFINSTRUMENTTABLE (Q_QueueId,ProcessInstanceId,WorkitemId)

--CREATE INDEX IDX3_WFINSTRUMENTTABLE ON WFINSTRUMENTTABLE (Q_UserID, ProcessInstanceId, WorkitemId)

--CREATE INDEX IDX4_WFINSTRUMENTTABLE ON WFINSTRUMENTTABLE (UPPER(ProcessInstanceId),WorkitemId) 



--CREATE INDEX IDX5_WFINSTRUMENTTABLE ON WFINSTRUMENTTABLE (Q_QueueId  ,  WorkItemState  , LockStatus  ,RoutingStatus   ,EntryDATETIME)



CREATE INDEX IDX6_WFINSTRUMENTTABLE ON WFINSTRUMENTTABLE  (ProcessDefId, RoutingStatus, LockStatus)

~

--CREATE INDEX IDX7_WFINSTRUMENTTABLE ON WFINSTRUMENTTABLE  (PROCESSINSTANCEID, PARENTWORKITEMID)



--CREATE INDEX IDX8_WFINSTRUMENTTABLE ON WFINSTRUMENTTABLE(Q_UserId, ROUTINGSTATUS, Q_QUEUEID)



--CREATE INDEX IDX9_WFINSTRUMENTTABLE ON WFINSTRUMENTTABLE(Q_QUEUEID, LOCKSTATUS,ENTRYDATETIME,PROCESSINSTANCEID,WORKITEMID)



CREATE INDEX IDX10_WFINSTRUMENTTABLE ON WFINSTRUMENTTABLE(childprocessinstanceid, childworkitemid)



--CREATE INDEX IDX11_WFINSTRUMENTTABLE ON WFINSTRUMENTTABLE(ValidTill)

~	

CREATE INDEX IDX12_WFINSTRUMENTTABLE ON WFINSTRUMENTTABLE(ASSIGNMENTTYPE  , VALIDTILL  ,ROUTINGSTATUS  ,LOCKSTATUS)

~


CREATE INDEX IDX13_WFINSTRUMENTTABLE ON WFINSTRUMENTTABLE(URN)

~

CREATE INDEX IDX14_WFINSTRUMENTTABLE ON WFINSTRUMENTTABLE(Q_QueueId, RoutingStatus, LockStatus, PriorityLevel)

~

CREATE INDEX IDX15_WFINSTRUMENTTABLE ON WFINSTRUMENTTABLE(Q_QueueId, RoutingStatus, LockStatus, ProcessInstanceId,WorkitemId)

~

CREATE INDEX IDX16_WFINSTRUMENTTABLE ON WFINSTRUMENTTABLE(Q_QueueId, RoutingStatus, LockStatus, EntryDateTime)

~

CREATE INDEX IDX17_WFINSTRUMENTTABLE ON WFINSTRUMENTTABLE(Q_UserID, RoutingStatus, ProcessInstanceId, WorkitemId)

~

CREATE INDEX IDX1_WFATTRIBUTEMESSAGETABLE ON WFATTRIBUTEMESSAGETABLE(PROCESSINSTANCEID)	
		
~	
CREATE INDEX IDX1_WFObjectPropertiesTable ON WFObjectPropertiesTable(ObjectType,PropertyName)	
~

CREATE INDEX IDX1_WFRTTaskInterfaceAssocTable ON WFRTTaskInterfaceAssocTable(PROCESSINSTANCEID,WorkitemId)

~
	
CREATE INDEX IDX1_RTACTIVITYINTERFACEASSOCTABLE ON RTACTIVITYINTERFACEASSOCTABLE(PROCESSINSTANCEID,WorkitemId)

~
CREATE INDEX IDX1_WFCommentsHistoryTable ON WFCommentsHistoryTable (ProcessInstanceId, ActivityId)
~
Create Extension LO

~

INSERT INTO WFCabVersionTable(cabVersion,  creationDate, lastModified, Remarks, Status) VALUES (N'8.0',  CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, N'OFCabCreation.sql', N'Y')

~

INSERT INTO WFCabVersionTable(cabVersion,  creationDate, lastModified, Remarks, Status) VALUES (N'HOTFIX_6.2_037',  CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, N'HOTFIX_6.2_036 REPORT UPDATE', N'Y')

~
INSERT INTO WFCabVersionTable(cabVersion,  creationDate, lastModified, Remarks, Status) VALUES (N'10.0_OmniFlowCabinet',  CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, N'10.0_OmniFlowCabinet', N'Y')
~
INSERT INTO WFCabVersionTable(cabVersion,  creationDate, lastModified, Remarks, Status) VALUES (N'Bugzilla_Id_2840',  CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, N'[Oracle] [PostgreSQL] Wrong ActionIds for LogIn & LogOut', N'Y')

~

INSERT INTO WFCabVersionTable(cabVersion,  creationDate, lastModified, Remarks, Status) VALUES (N'MULTIPLE_EXCEPTION_AND_MINUTE_SUPPORT',  CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, N'UPGRADE FOR MULTIPLE EXCEPTION AND TIMESTAMP', N'Y')

~

INSERT INTO WFCabVersionTable(cabVersion,  creationDate, lastModified, Remarks, Status) VALUES (N'Bugzilla_Id_3682',  CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, N'Enhancements in Web Services', N'Y')

~

INSERT INTO WFCabVersionTable(cabVersion,  creationDate, lastModified, Remarks, Status) VALUES (N'7.2_ExtMethodParamMappingTable',  CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, N'BPEL Compliant OmniFlow', N'Y') /* avoid recreation of table if exists */

~
																																															
INSERT INTO WFCabVersionTable(cabVersion,  creationDate, lastModified, Remarks, Status) VALUES (N'7.2_RuleConditionTable',  CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, N'BPEL Compliant OmniFlow', N'Y') /* avoid recreation of table if exists */

~

INSERT INTO WFCabVersionTable(cabVersion,  creationDate, lastModified, Remarks, Status) VALUES (N'7.2_RuleOperationTable',  CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, N'BPEL Compliant OmniFlow', N'Y') /* avoid recreation of table if exists */

~

INSERT INTO WFCabVersionTable(cabVersion,  creationDate, lastModified, Remarks, Status) VALUES (N'7.2_VarMappingTable',  CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, N'BPEL Compliant OmniFlow', N'Y') /* avoid recreation of table if exists */

~

INSERT INTO WFCabVersionTable(cabVersion,  creationDate, lastModified, Remarks, Status) VALUES (N'7.2_UserDiversionTable',  CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, N'BPEL Compliant OmniFlow', N'Y') /* avoid recreation of table if exists */

~

INSERT INTO WFCabVersionTable(cabVersion,  creationDate, lastModified, Remarks, Status) VALUES (N'7.2_ActionConditionTable',  CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, N'Complex Data Type Support', N'Y') /* avoid recreation of table if exists in case of addition of column VariableId_1, VarFieldId_1, VariableId_2, VarFieldId_2 */

~

INSERT INTO WFCabVersionTable(cabVersion,  creationDate, lastModified, Remarks, Status) VALUES (N'7.2_MailTriggerTable',  CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,  N'Complex Data Type Support', N'Y') /* avoid recreation of table if exists in case of addition of column VariableIdTo, VarFieldIdTo, VariableIdFrom, VarFieldIdFrom, VariableIdCc, VarFieldIdCc */

~

INSERT INTO WFCabVersionTable(cabVersion,  creationDate, lastModified, Remarks, Status) VALUES (N'7.2_DataSetTriggerTable',  CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, N'Complex Data Type Support', N'Y') /* avoid recreation of table if exists in case of addition of column VariableId_1, VarFieldId_1, VariableId_2, VarFieldId_2 */

~

INSERT INTO WFCabVersionTable(cabVersion,  creationDate, lastModified, Remarks, Status) VALUES (N'7.2_PrintFaxEmailTable',  CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, N'Complex Data Type Support', N'Y') /* avoid recreation of table if exists in case of addition of column VariableIdTo, VarFieldIdTo, VariableIdFrom, VarFieldIdFrom, VariableIdCc, VarFieldIdCc, VariableIdFax, VarFieldIdFax */

~

INSERT INTO WFCabVersionTable(cabVersion,  creationDate, lastModified, Remarks, Status) VALUES (N'7.2_ScanActionsTable',  CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, N'Complex Data Type Support', N'Y') /* avoid recreation of table if exists in case of addition of column VariableId_1, VarFieldId_1, VariableId_2, VarFieldId_2 */

~

INSERT INTO WFCabVersionTable(cabVersion,  creationDate, lastModified, Remarks, Status) VALUES (N'7.2_ToDoListDefTable',  CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, N'Complex Data Type Support', N'Y') /* avoid recreation of table if exists in case of addition of column  VariableId, VarFieldId */

~

INSERT INTO WFCabVersionTable(cabVersion,  creationDate, lastModified, Remarks, Status) VALUES (N'7.2_ImportedProcessDefTable',  CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, N'Complex Data Type Support', N'Y') /* avoid recreation of table if exists in case of addition of column  VariableId, VarFieldId, DisplayName */

~

INSERT INTO WFCabVersionTable(cabVersion,  creationDate, lastModified, Remarks, Status) VALUES (N'7.2_InitiateWorkitemDefTable',  CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, N'Complex Data Type Support', N'Y') /* avoid recreation of table if exists in case of addition of column ImportedVariableId, ImportedVarFieldId, MappedVariableId, MappedVarFieldId, DisplayName */

~

INSERT INTO WFCabVersionTable(cabVersion,  creationDate, lastModified, Remarks, Status) VALUES (N'7.2_WFDurationTable',  CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, N'Complex Data Type Support', N'Y')

~

INSERT INTO WFCabVersionTable(cabVersion,  creationDate, lastModified, Remarks, Status) VALUES (N'7.2_CalendarName_VarMapping',  CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, N'OmniFlow 7.2', N'Y')

~

INSERT INTO WFCabVersionTable(cabVersion,  creationDate, lastModified, Remarks, Status) VALUES (N'7.2_TurnAroundDateTime_VarMapping',  CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, N'OmniFlow 7.2', N'Y')

~
INSERT INTO WFCabVersionTable(cabVersion,  creationDate, lastModified, Remarks, Status) VALUES (N'7.2_ProcessDefTable',  CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, N'7.2_ProcessDefTable', N'Y')

~
INSERT INTO WFCabVersionTable(cabVersion,  creationDate, lastModified, Remarks, Status) VALUES (N'7.2_SystemCatalog',  CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, N'7.2_SystemCatalog', N'Y')

~
INSERT INTO WFCabVersionTable(cabVersion,  creationDate, lastModified, Remarks, Status) VALUES (N'iBPS_3.0_SP1',  CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, N'iBPS_3.0_SP1', N'Y')

~
INSERT INTO WFCabVersionTable(cabVersion,  creationDate, lastModified, Remarks, Status) VALUES (N'iBPS_3.2_GA',  CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, N'iBPS_3.2_GA', N'Y')
~
Insert into QueueDefTable ( QueueName, QueueType, Comments, OrderBy, SortOrder)
values ( 'SystemArchiveQueue', 'A', 'System generated common Archive Queue', 10, 'A')

~

Insert into QueueDefTable ( QueueName, QueueType, Comments, OrderBy, SortOrder)
values ( 'SystemPFEQueue', 'A', 'System generated common PFE Queue', 10, 'A')

~

Insert into QueueDefTable ( QueueName, QueueType, Comments, OrderBy, SortOrder)
values ('SystemSharepointQueue', 'A', 'System generated common Sharepoint Queue', 10, 'A')

~
Insert into QueueDefTable ( QueueName, QueueType, Comments, OrderBy, SortOrder)
values ( 'SystemWSQueue', 'A', 'System generated common WebService Queue', 10, 'A')

~

Insert into QueueDefTable ( QueueName, QueueType, Comments, OrderBy, SortOrder)
values ( 'SystemBRMSQueue', 'A', 'System generated common BRMS Queue', 10, 'A')

~

Insert into QueueDefTable ( QueueName, QueueType, Comments, OrderBy, SortOrder)
values ( 'SystemSAPQueue', 'A', 'System generated common SAP Queue', 10, 'A')
~

Insert into QueueDefTable (QueueName, QueueType, Comments, OrderBy, SortOrder)
values ('SystemDXQueue', 'A', 'System generated common Data Exchange Queue', 10, 'A')
~

CREATE TABLE IBPSUserDomain(
	ORGID VARCHAR(10) NOT NULL,
	DOMAINID VARCHAR(10) PRIMARY KEY NOT NULL,
	DOMAIN VARCHAR(50)  NOT NULL
)
~
CREATE TABLE IBPSUserMaster(
    ORGID VARCHAR(20) NOT NULL,
    MAILID VARCHAR(50) NOT NULL,
    UDID VARCHAR(100) NOT NULL,
  	USERVALIDATIONFLAG VARCHAR(1) NULL,
  	CONSTRAINT user_master PRIMARY KEY (MAILID, UDID)
)

~
CREATE TABLE IBPSUserVerification(
	MAILID VARCHAR(50) NOT NULL,
	UDID VARCHAR(50) NOT NULL,
	VERIFICATIONCODE VARCHAR(10) NULL,
  	VERIFICATIONSTATUS VARCHAR(10) NULL
)

~
CREATE TABLE IBPSUserDomainInfo(
	DOMAINID VARCHAR(10) NOT NULL,
	USERNAME VARCHAR(10) NOT NULL,
	UDID VARCHAR(50)NOT NULL,
  	OFSERVERIP VARCHAR(25)NOT NULL, 
  	OFSERVERPORT VARCHAR(10) NOT NULL,
	OFCABINET VARCHAR(25) NOT NULL,
	OFCABTYPE VARCHAR(25)NOT NULL,
	OFAPPSERVERTYPE VARCHAR(10)NOT NULL,
  	OFMWARNAME VARCHAR(25) NOT NULL,
  	BAMSERVERPROTOCOL VARCHAR(5)  NOT NULL,
    BAMSERVERIP VARCHAR(25)  NOT NULL,
    BAMSERVERPORT VARCHAR(10)  NOT NULL,
    FORMSERVERPROTOCOL VARCHAR(5)  NOT NULL,
    FORMSERVERIP VARCHAR(25)  NOT NULL,
    FORMSERVERPORT VARCHAR(10)  NOT NULL, 
	CALLBACKSERVERPROTOCOL VARCHAR(5) NOT NULL, 
	CALLBACKSERVERIP VARCHAR(25) NOT NULL, 
	CALLBACKSERVERPORT VARCHAR(10) NOT NULL,
  	CONSTRAINT PK_UserDomainInfo PRIMARY KEY (DOMAINID,USERNAME,UDID)
)

~

/* BUG 47682 FIXED */

CREATE TABLE WFPSConnection(
	PSId	INTEGER	Primary Key NOT NULL,
	SessionId	INTEGER	Unique NOT NULL,
	Locale	char(5),	
	PSLoginTime	TIMESTAMP	
)

~
CREATE TABLE WFHoldEventsDefTable (
	ProcessDefId		INTEGER 		   NOT NULL,
	ActivityId			INTEGER 		   NOT NULL,
	EventId				INTEGER			   NOT NULL,
	EventName			VARCHAR(255) NOT NULL,
	TriggerName			VARCHAR(255) NULL,
	TargetActId	INTEGER			   NULL,
	TargetActName	VARCHAR(255) NULL,
	PRIMARY KEY ( ProcessDefId , ActivityId,EventId )
)

~
	
create TABLE WF_OMSConnectInfoTable(
	ProcessDefId 	integer	 		NOT NULL,
	ActivityId 		integer 		NOT NULL,
	CabinetName     VARCHAR(255)  NULL,                
	UserId          VARCHAR(50)   NULL,
	Passwd          VARCHAR(256)  NULL,                
	AppServerIP		VARCHAR(100)	NULL,
	AppServerPort	VARCHAR(5)	NULL,
	AppServerType	VARCHAR(255)	NULL,
	SecurityFlag	VARCHAR(1)	NULL		
)
~
create TABLE WF_OMSTemplateInfoTable(
	ProcessDefId 	integer	 		NOT NULL,
	ActivityId 		integer 		NOT NULL,
	ProductName 	VARCHAR(255)  NOT NULL,
	VersionNo 		VARCHAR(3) 	NOT NULL,
	CommGroupName 	VARCHAR(255)  NULL,
	CategoryName 	VARCHAR(255)  NULL,
	ReportName 		VARCHAR(255)  NULL,
	Description 	VARCHAR(255)  NULL,	
	InvocationType  VARCHAR(1) 	NULL,
	TimeOutInterval integer 		NULL,
	DocTypeName		VARCHAR(255) 	NULL,	
	CONSTRAINT PK_WFOMSTemplateInfoTable PRIMARY KEY(ProcessDefID,ActivityId,ProductName,VersionNo)
)
~

create TABLE WF_OMSTemplateMappingTable(
	ProcessDefId 	integer	 		NOT NULL,
	ActivityId 		integer 		NOT NULL,
	ProductName 	VARCHAR(255)  NULL,
	VersionNo 		VARCHAR(3) 	NULL,			
	MapType 		VARCHAR(1) 	NULL,
	TemplateVarName VARCHAR(255) 	NULL,
	TemplateVarType integer 		NULL,
	MappedName 	VARCHAR(255) 	NULL,
	MaxOccurs 	VARCHAR(255) 	NULL,
	MinOccurs 	VARCHAR(255) 	NULL,	
	VarId  		integer 		NULL,	
	VarFieldId 		integer		NULL,
	VarScope	VARCHAR(255) 	NULL,
	OrderId    integer   NULL
)	

~


/***********	WFAUDITTRAILDOCTABLE 	****************/

CREATE TABLE WFAUDITTRAILDOCTABLE(
	PROCESSDEFID			INTEGER NOT NULL,
	PROCESSINSTANCEID		VARCHAR(63),
	WORKITEMID				INTEGER NOT NULL,
	ACTIVITYID				INTEGER NOT NULL,
	DOCID					INTEGER NOT NULL,
	PARENTFOLDERINDEX		INTEGER NOT NULL,
	VOLID					INTEGER NOT NULL,
	APPSERVERIP				VARCHAR(63) NOT NULL,
	APPSERVERPORT			INTEGER NOT NULL,
	APPSERVERTYPE			VARCHAR(63) NULL,
	ENGINENAME				VARCHAR(63) NOT NULL,
	DELETEAUDIT				VARCHAR(1) Default 'N',
	STATUS					CHAR(1)	NOT NULL,
	LOCKEDBY				VARCHAR(63)	NULL,
	PRIMARY KEY ( PROCESSINSTANCEID , WORKITEMID , ACTIVITYID)
)
~
/**** WFCabinetView ****/
Create view WFCabinetView as Select * from PDBCabinet
~
/******   WFActivityMaskingInfoTable    ******/
CREATE TABLE WFActivityMaskingInfoTable (
ProcessDefId 		INT 			NOT NULL,
ActivityId 		    INT 		    NOT NULL,
ActivityName 		VARCHAR(30)	NOT NULL,
VariableId			INT 			NOT NULL,
VarFieldId			INTEGER		    NOT NULL,
VariableName		VARCHAR(255) 	NOT NULL
)

~

/*** WFTaskExpiryOperation ***/
CREATE TABLE WFTaskExpiryOperation(
    ProcessDefId            INT                 NOT NULL,
    TaskId                  INT                 NOT NULL,
    NeverExpireFlag         VARCHAR(1)         NOT NULL,
    ExpireUntillVariable    VARCHAR(255)       NULL,
    ExtObjID                INT                 NULL,
    ExpCalFlag              VARCHAR(1)         NULL,
    Expiry                  INT                 NOT NULL,
    ExpiryOperation         INT                 NOT NULL,
    ExpiryOpType            VARCHAR(64)        NOT NULL,
    ExpiryOperator          INT                 NOT NULL,
    UserType                VARCHAR(1)         NOT NULL,
    VariableId              INT                 NULL,
    VarFieldId              INT                 NULL,
    Value                   VARCHAR(255)        NULL,
    TriggerID               Int                 NULL,
    PRIMARY KEY (ProcessDefId, TaskId, ExpiryOperation)
)

~

/*** WFTaskUserAssocTable ***/

CREATE TABLE WFTaskUserAssocTable(
	ProcessDefId int,
	ActivityId int,
	TaskId int,
	UserId int,
	AssociationType int,
	FilterId int DEFAULT -1 NOT NULL
)

~

/*** WFDefaultTaskUser ***/

create table WFDefaultTaskUser(
	processdefid int,
	activityid int,
	taskid int,
	CaseManagerId int,
	userid int,
	constraint WFDefaultTaskUser_PK PRIMARY KEY (ProcessDefId, ActivityId, TaskId, CaseManagerId)
)

~

CREATE TABLE WFInitiationAgentReportTable(
	LogId SERIAL NOT NULL,
	EmailReceivedDateTime TIMESTAMP NULL,
	MailFrom VARCHAR(4000) NULL,
	MailTo VARCHAR(4000) NULL,
	MailSubject VARCHAR(4000) NULL,
	MailCC VARCHAR(4000) NULL,
	EmailFileName VARCHAR(200) NULL,
	EMailStatus VARCHAR(100) NULL,
	ActionDateTime TIMESTAMP NULL,
	ProcessInstanceId VARCHAR(200) NULL,
	ActionDescription VARCHAR(4000) NULL,
	ProcessDefId INTEGER ,
	ActivityId INTEGER,
	IAId VARCHAR(50) not null,
	AccountName VARCHAR(100) not null,
	NoOfAttachments INTEGER null,
	SizeOfAttachments VARCHAR(1000) null,
	MessageId VARCHAR(1000)  NULL
)

~

CREATE INDEX IDX1_WFInitiationAgentReportTable ON WFInitiationAgentReportTable ( processDefId, IAId, AccountName, EmailFileName)

~
CREATE TABLE WFExportMapTable (
	ProcessDefId INTEGER,
	ActivityId INTEGER,
	ExportLocation VARCHAR(2000),
	CurrentCount VARCHAR(100),
	Counter VARCHAR(100),
	RecordFlag VARCHAR(100)
) 

~
CREATE TABLE WFUserLogTable  (
	UserLogId			Serial			PRIMARY KEY,
	ActionId			INTEGER			NOT NULL,
	ActionDateTime		TIMESTAMP		NOT NULL,
	UserId				INTEGER,
	UserName			VARCHAR(64),
	Message				VARCHAR(1000)
)
~
/*Bug 73913 : 	Rest Ful webservices implementation in iBPS*/
CREATE TABLE WFRestServiceInfoTable (
	ProcessDefId		INT				NOT NULL, 
	ResourceId			INT 			NOT NULL, 
	ResourceName 		VARCHAR(255) 	NOT NULL ,
	BaseURI             VARCHAR(2000)  NULL,
	ResourcePath        VARCHAR(2000)  NULL,
	ResponseType		VARCHAR(2)			NULL,	
	ContentType			VARCHAR(2)			NULL,	
	OperationType		VARCHAR(50)			NULL,	
	AuthenticationType	VARCHAR(500)		NULL,	
	AuthUser			VARCHAR(1000)		NULL,
	AuthPassword		VARCHAR(1000)		NULL,
	AuthenticationDetails			VARCHAR(2000) NULL,
	AuthToken			VARCHAR(2000)		NULL,
	ProxyEnabled			VARCHAR(2)		NULL,
	SecurityFlag		VARCHAR(1)		    NULL,
	PRIMARY KEY (ProcessDefId,ResourceId)
)

~
Create table WFRestActivityAssocTable(
   ProcessDefId integer ,
   ActivityId integer ,
   ExtMethodIndex integer ,
   OrderId integer ,
   TimeoutDuration integer ,
   CONSTRAINT pk_RestServiceActAssoc PRIMARY KEY(ProcessDefId,ActivityId,ExtMethodIndex)
) 
/*Bug 73913 : 	Rest Ful webservices implementation in iBPS*/
~
/* Custom iBPS Reports implementation starts here */
Create table WFReportPropertiesTable(
	CriteriaID				SERIAL PRIMARY KEY,
	CriteriaName			VARCHAR(255) UNIQUE NOT NULL,
	Description				VARCHAR(255) Null,
	ChartInfo				TEXT Null,
	ExcludeExitWorkitems	Char(1)   	Not Null ,
	State					int			Not Null,
	LastModifiedOn  		TIMESTAMP		NULL
)

~
Create Table WFFilterDefTable(
	FilterID	SERIAL PRIMARY KEY,
	FilterName	VARCHAR(255) NOT NULL,
	FilterXML	TEXT NOT NULL,
	CriteriaID	Int Not NULL,
	FilterColor VARCHAR(20) NOT NULL,
	ConditionOption	int not null,
	CONSTRAINT	uk_WFFilterDefTable UNIQUE(CriteriaID,FilterName)
)

~
Create TABLE WFReportObjAssocTable(
	CriteriaID	Int NOT Null,
	ObjectID	Int NOT Null,
	ObjectType	Char (1) CHECK ( ObjectType in (N'P' , N'Q' , N'F')),
	ObjectName	VARCHAR(255),
	CONSTRAINT	pk_WFReportObjAssocTable PRIMARY KEY(CriteriaID,ObjectID,ObjectType)
)

~
Create TABLE WFReportVarMappingTable(
	CriteriaID			Int NOT Null,
	VariableId			INT NOT NULL ,
	VariableName		VARCHAR(50) 	NOT NULL ,
	Type				int 			Not null ,
	VariableType 		char(1) 		NOT NULL ,
	DisplayName			VARCHAR(50)	NOT NULL ,
	SystemDefinedName	VARCHAR(50) 	NOT NULL ,
	OrderId				Int 			Not NUll ,
	IsHidden			Char(1)			Not Null ,
	IsSortable			Char(1)			Not Null ,
	LastModifiedDateTime TIMESTAMP 		Not NULL ,
	MappedType			int 			not null ,
	DisableSorting 		char(1) 		NOT NULL,
	CONSTRAINT	pk_WFReportVarMappingTable PRIMARY KEY(CriteriaID,VariableId),
	CONSTRAINT	uk_WFReportVarMappingTable UNIQUE(CriteriaID,DisplayName)
)

~

CREATE TABLE WFDMSUserInfo (
	UserName VARCHAR(64) NOT NULL
)

~

INSERT INTO WFDMSUserInfo(UserName) VALUES('Of_Sys_User')

~

CREATE TABLE WFCustomServicesStatusTable (
	PSID				INT NOT NULL PRIMARY KEY,
	ServiceStatus		INT NOT NULL,
	ServiceStatusMsg	VARCHAR(100) NOT NULL,
	WorkItemCount		INT NOT NULL,
	LastUpdated			TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
)

~

CREATE SEQUENCE SEQ_WFSAT_LogId INCREMENT BY 1 START WITH 1
	
~

CREATE TABLE WFServiceAuditTable (
	LogId				INT NOT NUll DEFAULT NEXTVAL('SEQ_WFSAT_LogId'),
	PSID				INT NOT NULL,
	ServiceName			VARCHAR(50) NOT NULL,
	ServiceType			VARCHAR(50) NOT NULL,
	ActionId			INT NOT NULL,
	ActionDateTime		TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	UserName			VARCHAR(64) NOT NULL,
	ServerDetails		VARCHAR(30) NOT NULL,
	ServiceParamDetails	VARCHAR(1000) NULL
)

~

CREATE INDEX IDX1_WFServiceAuditTable ON WFServiceAuditTable(PSID, UPPER(UserName), ActionDateTime)

~

CREATE TABLE WFServiceAuditTable_History (
	LogId				INT NOT NUll,
	PSID				INT NOT NULL,
	ServiceName			VARCHAR(50) NOT NULL,
	ServiceType			VARCHAR(50) NOT NULL,
	ActionId			INT NOT NULL,
	ActionDateTime		TIMESTAMP NOT NULL,
	UserName			VARCHAR(64) NOT NULL,
	ServerDetails		VARCHAR(30) NOT NULL,
	ServiceParamDetails	VARCHAR(1000) NULL
)

~

CREATE TABLE WFServicesListTable (
	PSID				INT NOT NULL,
	ServiceId			INT NOT NULL,
	ServiceName			VARCHAR(50) NOT NULL,
	ServiceType			VARCHAR(50) NOT NULL,
	ProcessDefId		INT NOT NULL,
	ActivityId			INT NOT NULL
)

~

CREATE TABLE WFDEActivityTable
	(
	ProcessDefId    INTEGER NOT NULL,
	ActivityId      INTEGER NOT NULL,
	IsolateFlag     VARCHAR(2)	NOT NULL,
	ConfigurationID INTEGER NOT NULL,
	ConfigType     VARCHAR(2)	NOT NULL
	)
    
~	
    
CREATE TABLE WFDETableMappingDetails
	(
	ProcessDefId       INTEGER NOT NULL,
	ActivityId         INTEGER NOT NULL,
	ExchangeId         INTEGER NOT NULL,
	OrderId            INTEGER NOT NULL,
	VariableType       VARCHAR (2) NOT NULL,
	RowCountVariableId INTEGER NULL,
	FilterString       VARCHAR (255) NULL,
	EntityType         VARCHAR (2) NOT NULL,
	EntityName         VARCHAR (255) NOT NULL,
	ColumnName         VARCHAR (255) NOT NULL,
	Nullable           VARCHAR (2) NOT NULL,
	VarName            VARCHAR (255) NOT NULL,
	VarType            VARCHAR (2) NOT NULL,
	VarId              INTEGER NOT NULL,
	VarFieldId         INTEGER NOT NULL,
	ExtObjId           INTEGER NOT NULL,
	updateIfExist      VARCHAR (2) NOT NULL,
	ColumnType         INTEGER NOT NULL
	)
	
~	
    
CREATE TABLE WFDETableRelationdetails
	(
	ProcessDefId       INTEGER NOT NULL,
	ActivityId         INTEGER NOT NULL,
	ExchangeId         INTEGER NOT NULL,
	EntityName         VARCHAR (255) NOT NULL,
	EntityType         VARCHAR (2) NOT NULL,
	EntityColumnName   VARCHAR (255) NOT NULL,
	ComplexTableName   VARCHAR (255) NOT NULL,
	RelationColumnName VARCHAR (255) NOT NULL,
	ColumnType         INTEGER NOT NULL,
	RelationType       VARCHAR (2) NOT NULL
	)
	
~	
    
CREATE TABLE WFDEConfigTable
   (
    ProcessDefId       INTEGER NOT NULL,
    ConfigName         VARCHAR(255) NOT NULL,
    ActivityId         INTEGER NOT NULL
   )

~   

/* Adding System Catalog Function Starts*/

Insert into EXTMETHODDEFTABLE (PROCESSDEFID,EXTMETHODINDEX,EXTAPPNAME,EXTAPPTYPE,EXTMETHODNAME,SEARCHMETHOD,SEARCHCRITERIA,RETURNTYPE,MAPPINGFILE,CONFIGURATIONID) values (0,1,'System','S','contains',' ',null,12,' ',0)

~

Insert into EXTMETHODDEFTABLE (PROCESSDEFID,EXTMETHODINDEX,EXTAPPNAME,EXTAPPTYPE,EXTMETHODNAME,SEARCHMETHOD,SEARCHCRITERIA,RETURNTYPE,MAPPINGFILE,CONFIGURATIONID) values (0,2,'System','S','normalizeSpace',' ',null,10,' ',0)

~

Insert into EXTMETHODDEFTABLE (PROCESSDEFID,EXTMETHODINDEX,EXTAPPNAME,EXTAPPTYPE,EXTMETHODNAME,SEARCHMETHOD,SEARCHCRITERIA,RETURNTYPE,MAPPINGFILE,CONFIGURATIONID) values (0,3,'System','S','stringValue',' ',null,10,' ',0)

~

Insert into EXTMETHODDEFTABLE (PROCESSDEFID,EXTMETHODINDEX,EXTAPPNAME,EXTAPPTYPE,EXTMETHODNAME,SEARCHMETHOD,SEARCHCRITERIA,RETURNTYPE,MAPPINGFILE,CONFIGURATIONID) values (0,4,'System','S','stringValue',' ',null,10,' ',0)

~

Insert into EXTMETHODDEFTABLE (PROCESSDEFID,EXTMETHODINDEX,EXTAPPNAME,EXTAPPTYPE,EXTMETHODNAME,SEARCHMETHOD,SEARCHCRITERIA,RETURNTYPE,MAPPINGFILE,CONFIGURATIONID) values (0,5,'System','S','stringValue',' ',null,10,' ',0)

~

Insert into EXTMETHODDEFTABLE (PROCESSDEFID,EXTMETHODINDEX,EXTAPPNAME,EXTAPPTYPE,EXTMETHODNAME,SEARCHMETHOD,SEARCHCRITERIA,RETURNTYPE,MAPPINGFILE,CONFIGURATIONID) values (0,6,'System','S','stringValue',' ',null,10,' ',0)

~

Insert into EXTMETHODDEFTABLE (PROCESSDEFID,EXTMETHODINDEX,EXTAPPNAME,EXTAPPTYPE,EXTMETHODNAME,SEARCHMETHOD,SEARCHCRITERIA,RETURNTYPE,MAPPINGFILE,CONFIGURATIONID) values (0,7,'System','S','stringValue',' ',null,10,' ',0)

~

Insert into EXTMETHODDEFTABLE (PROCESSDEFID,EXTMETHODINDEX,EXTAPPNAME,EXTAPPTYPE,EXTMETHODNAME,SEARCHMETHOD,SEARCHCRITERIA,RETURNTYPE,MAPPINGFILE,CONFIGURATIONID) values (0,8,'System','S','stringValue',' ',null,10,' ',0)

~

Insert into EXTMETHODDEFTABLE (PROCESSDEFID,EXTMETHODINDEX,EXTAPPNAME,EXTAPPTYPE,EXTMETHODNAME,SEARCHMETHOD,SEARCHCRITERIA,RETURNTYPE,MAPPINGFILE,CONFIGURATIONID) values (0,9,'System','S','booleanValue',' ',null,12,' ',0)

~

Insert into EXTMETHODDEFTABLE (PROCESSDEFID,EXTMETHODINDEX,EXTAPPNAME,EXTAPPTYPE,EXTMETHODNAME,SEARCHMETHOD,SEARCHCRITERIA,RETURNTYPE,MAPPINGFILE,CONFIGURATIONID) values (0,10,'System','S','booleanValue',' ',null,12,' ',0)

~

Insert into EXTMETHODDEFTABLE (PROCESSDEFID,EXTMETHODINDEX,EXTAPPNAME,EXTAPPTYPE,EXTMETHODNAME,SEARCHMETHOD,SEARCHCRITERIA,RETURNTYPE,MAPPINGFILE,CONFIGURATIONID) values (0,11,'System','S','startsWith',' ',null,12,' ',0)

~

Insert into EXTMETHODDEFTABLE (PROCESSDEFID,EXTMETHODINDEX,EXTAPPNAME,EXTAPPTYPE,EXTMETHODNAME,SEARCHMETHOD,SEARCHCRITERIA,RETURNTYPE,MAPPINGFILE,CONFIGURATIONID) values (0,12,'System','S','stringLength',' ',null,3,' ',0)

~

Insert into EXTMETHODDEFTABLE (PROCESSDEFID,EXTMETHODINDEX,EXTAPPNAME,EXTAPPTYPE,EXTMETHODNAME,SEARCHMETHOD,SEARCHCRITERIA,RETURNTYPE,MAPPINGFILE,CONFIGURATIONID) values (0,13,'System','S','subString',' ',null,10,' ',0)

~

Insert into EXTMETHODDEFTABLE (PROCESSDEFID,EXTMETHODINDEX,EXTAPPNAME,EXTAPPTYPE,EXTMETHODNAME,SEARCHMETHOD,SEARCHCRITERIA,RETURNTYPE,MAPPINGFILE,CONFIGURATIONID) values (0,14,'System','S','subStringBefore',' ',null,10,' ',0)

~

Insert into EXTMETHODDEFTABLE (PROCESSDEFID,EXTMETHODINDEX,EXTAPPNAME,EXTAPPTYPE,EXTMETHODNAME,SEARCHMETHOD,SEARCHCRITERIA,RETURNTYPE,MAPPINGFILE,CONFIGURATIONID) values (0,15,'System','S','subStringAfter',' ',null,10,' ',0)

~

Insert into EXTMETHODDEFTABLE (PROCESSDEFID,EXTMETHODINDEX,EXTAPPNAME,EXTAPPTYPE,EXTMETHODNAME,SEARCHMETHOD,SEARCHCRITERIA,RETURNTYPE,MAPPINGFILE,CONFIGURATIONID) values (0,16,'System','S','translate',' ',null,10,' ',0)

~

Insert into EXTMETHODDEFTABLE (PROCESSDEFID,EXTMETHODINDEX,EXTAPPNAME,EXTAPPTYPE,EXTMETHODNAME,SEARCHMETHOD,SEARCHCRITERIA,RETURNTYPE,MAPPINGFILE,CONFIGURATIONID) values (0,17,'System','S','concat',' ',null,10,' ',0)

~

Insert into EXTMETHODDEFTABLE (PROCESSDEFID,EXTMETHODINDEX,EXTAPPNAME,EXTAPPTYPE,EXTMETHODNAME,SEARCHMETHOD,SEARCHCRITERIA,RETURNTYPE,MAPPINGFILE,CONFIGURATIONID) values (0,18,'System','S','numberValue',' ',null,6,' ',0)

~

Insert into EXTMETHODDEFTABLE (PROCESSDEFID,EXTMETHODINDEX,EXTAPPNAME,EXTAPPTYPE,EXTMETHODNAME,SEARCHMETHOD,SEARCHCRITERIA,RETURNTYPE,MAPPINGFILE,CONFIGURATIONID) values (0,19,'System','S','numberValue',' ',null,6,' ',0)

~

Insert into EXTMETHODDEFTABLE (PROCESSDEFID,EXTMETHODINDEX,EXTAPPNAME,EXTAPPTYPE,EXTMETHODNAME,SEARCHMETHOD,SEARCHCRITERIA,RETURNTYPE,MAPPINGFILE,CONFIGURATIONID) values (0,20,'System','S','numberValue',' ',null,6,' ',0)

~

Insert into EXTMETHODDEFTABLE (PROCESSDEFID,EXTMETHODINDEX,EXTAPPNAME,EXTAPPTYPE,EXTMETHODNAME,SEARCHMETHOD,SEARCHCRITERIA,RETURNTYPE,MAPPINGFILE,CONFIGURATIONID) values (0,21,'System','S','numberValue',' ',null,6,' ',0)

~

Insert into EXTMETHODDEFTABLE (PROCESSDEFID,EXTMETHODINDEX,EXTAPPNAME,EXTAPPTYPE,EXTMETHODNAME,SEARCHMETHOD,SEARCHCRITERIA,RETURNTYPE,MAPPINGFILE,CONFIGURATIONID) values (0,22,'System','S','numberValue',' ',null,6,' ',0)

~

Insert into EXTMETHODDEFTABLE (PROCESSDEFID,EXTMETHODINDEX,EXTAPPNAME,EXTAPPTYPE,EXTMETHODNAME,SEARCHMETHOD,SEARCHCRITERIA,RETURNTYPE,MAPPINGFILE,CONFIGURATIONID) values (0,23,'System','S','round',' ',null,4,' ',0)

~

Insert into EXTMETHODDEFTABLE (PROCESSDEFID,EXTMETHODINDEX,EXTAPPNAME,EXTAPPTYPE,EXTMETHODNAME,SEARCHMETHOD,SEARCHCRITERIA,RETURNTYPE,MAPPINGFILE,CONFIGURATIONID) values (0,24,'System','S','floor',' ',null,4,' ',0)

~

Insert into EXTMETHODDEFTABLE (PROCESSDEFID,EXTMETHODINDEX,EXTAPPNAME,EXTAPPTYPE,EXTMETHODNAME,SEARCHMETHOD,SEARCHCRITERIA,RETURNTYPE,MAPPINGFILE,CONFIGURATIONID) values (0,25,'System','S','ceiling',' ',null,4,' ',0)

~

Insert into EXTMETHODDEFTABLE (PROCESSDEFID,EXTMETHODINDEX,EXTAPPNAME,EXTAPPTYPE,EXTMETHODNAME,SEARCHMETHOD,SEARCHCRITERIA,RETURNTYPE,MAPPINGFILE,CONFIGURATIONID) values (0,26,'System','S','getCurrentDate',' ',null,15,' ',0)

~

Insert into EXTMETHODDEFTABLE (PROCESSDEFID,EXTMETHODINDEX,EXTAPPNAME,EXTAPPTYPE,EXTMETHODNAME,SEARCHMETHOD,SEARCHCRITERIA,RETURNTYPE,MAPPINGFILE,CONFIGURATIONID) values (0,27,'System','S','getCurrentTime',' ',null,16,' ',0)

~

Insert into EXTMETHODDEFTABLE (PROCESSDEFID,EXTMETHODINDEX,EXTAPPNAME,EXTAPPTYPE,EXTMETHODNAME,SEARCHMETHOD,SEARCHCRITERIA,RETURNTYPE,MAPPINGFILE,CONFIGURATIONID) values (0,28,'System','S','getCurrentDateTime',' ',null,8,' ',0)

~

Insert into EXTMETHODDEFTABLE (PROCESSDEFID,EXTMETHODINDEX,EXTAPPNAME,EXTAPPTYPE,EXTMETHODNAME,SEARCHMETHOD,SEARCHCRITERIA,RETURNTYPE,MAPPINGFILE,CONFIGURATIONID) values (0,29,'System','S','getShortDate',' ',null,15,' ',0)

~

Insert into EXTMETHODDEFTABLE (PROCESSDEFID,EXTMETHODINDEX,EXTAPPNAME,EXTAPPTYPE,EXTMETHODNAME,SEARCHMETHOD,SEARCHCRITERIA,RETURNTYPE,MAPPINGFILE,CONFIGURATIONID) values (0,30,'System','S','getTime',' ',null,16,' ',0)

~

Insert into EXTMETHODDEFTABLE (PROCESSDEFID,EXTMETHODINDEX,EXTAPPNAME,EXTAPPTYPE,EXTMETHODNAME,SEARCHMETHOD,SEARCHCRITERIA,RETURNTYPE,MAPPINGFILE,CONFIGURATIONID) values (0,31,'System','S','roundToInt',' ',null,3,' ',0)

~

Insert into EXTMETHODDEFTABLE (PROCESSDEFID,EXTMETHODINDEX,EXTAPPNAME,EXTAPPTYPE,EXTMETHODNAME,SEARCHMETHOD,SEARCHCRITERIA,RETURNTYPE,MAPPINGFILE,CONFIGURATIONID) values (0,32,'System','S','getElementAtIndex',' ',null,3,' ',0)

~

Insert into EXTMETHODDEFTABLE (PROCESSDEFID,EXTMETHODINDEX,EXTAPPNAME,EXTAPPTYPE,EXTMETHODNAME,SEARCHMETHOD,SEARCHCRITERIA,RETURNTYPE,MAPPINGFILE,CONFIGURATIONID) values (0,33,'System','S','addElementToArray',' ',null,3,' ',0)

~

Insert into EXTMETHODDEFTABLE (PROCESSDEFID,EXTMETHODINDEX,EXTAPPNAME,EXTAPPTYPE,EXTMETHODNAME,SEARCHMETHOD,SEARCHCRITERIA,RETURNTYPE,MAPPINGFILE,CONFIGURATIONID) values (0,34,'System','S','deleteChildWorkitem',' ',null,3,' ',0)

~

INSERT INTO  EXTMETHODDEFTABLE (ProcessDefId, ExtMethodIndex, ExtAppName, ExtAppType, ExtMethodName, SearchMethod, SearchCriteria, ReturnType, MappingFile, ConfigurationID) VALUES (0,4001,'System','S','InvokeDBFuncExecuteString','',NULL,10,'',0)

~

INSERT INTO  EXTMETHODDEFTABLE (ProcessDefId, ExtMethodIndex, ExtAppName, ExtAppType, ExtMethodName, SearchMethod, SearchCriteria, ReturnType, MappingFile, ConfigurationID) VALUES (0,4002,'System','S','InvokeDBFuncExecuteInt','',NULL,3,'',0)

~

Insert into EXTMETHODPARAMDEFTABLE (PROCESSDEFID,EXTMETHODPARAMINDEX,EXTMETHODINDEX,PARAMETERNAME,PARAMETERTYPE,PARAMETERORDER,DATASTRUCTUREID,PARAMETERSCOPE,UNBOUNDED) values (0,1,1,'Param1',10,1,0,' ','N')

~

Insert into EXTMETHODPARAMDEFTABLE (PROCESSDEFID,EXTMETHODPARAMINDEX,EXTMETHODINDEX,PARAMETERNAME,PARAMETERTYPE,PARAMETERORDER,DATASTRUCTUREID,PARAMETERSCOPE,UNBOUNDED) values (0,2,1,'Param2',10,2,0,' ','N')

~

Insert into EXTMETHODPARAMDEFTABLE (PROCESSDEFID,EXTMETHODPARAMINDEX,EXTMETHODINDEX,PARAMETERNAME,PARAMETERTYPE,PARAMETERORDER,DATASTRUCTUREID,PARAMETERSCOPE,UNBOUNDED) values (0,1,2,'Param1',10,1,0,' ','N')

~

Insert into EXTMETHODPARAMDEFTABLE (PROCESSDEFID,EXTMETHODPARAMINDEX,EXTMETHODINDEX,PARAMETERNAME,PARAMETERTYPE,PARAMETERORDER,DATASTRUCTUREID,PARAMETERSCOPE,UNBOUNDED) values (0,1,3,'Param1',10,1,0,' ','N')

~

Insert into EXTMETHODPARAMDEFTABLE (PROCESSDEFID,EXTMETHODPARAMINDEX,EXTMETHODINDEX,PARAMETERNAME,PARAMETERTYPE,PARAMETERORDER,DATASTRUCTUREID,PARAMETERSCOPE,UNBOUNDED) values (0,1,4,'Param1',8,1,0,' ','N')

~

Insert into EXTMETHODPARAMDEFTABLE (PROCESSDEFID,EXTMETHODPARAMINDEX,EXTMETHODINDEX,PARAMETERNAME,PARAMETERTYPE,PARAMETERORDER,DATASTRUCTUREID,PARAMETERSCOPE,UNBOUNDED) values (0,1,5,'Param1',6,1,0,' ','N')

~

Insert into EXTMETHODPARAMDEFTABLE (PROCESSDEFID,EXTMETHODPARAMINDEX,EXTMETHODINDEX,PARAMETERNAME,PARAMETERTYPE,PARAMETERORDER,DATASTRUCTUREID,PARAMETERSCOPE,UNBOUNDED) values (0,1,6,'Param1',4,1,0,' ','N')

~

Insert into EXTMETHODPARAMDEFTABLE (PROCESSDEFID,EXTMETHODPARAMINDEX,EXTMETHODINDEX,PARAMETERNAME,PARAMETERTYPE,PARAMETERORDER,DATASTRUCTUREID,PARAMETERSCOPE,UNBOUNDED) values (0,1,7,'Param1',3,1,0,' ','N')

~

Insert into EXTMETHODPARAMDEFTABLE (PROCESSDEFID,EXTMETHODPARAMINDEX,EXTMETHODINDEX,PARAMETERNAME,PARAMETERTYPE,PARAMETERORDER,DATASTRUCTUREID,PARAMETERSCOPE,UNBOUNDED) values (0,1,8,'Param1',12,1,0,' ','N')

~

Insert into EXTMETHODPARAMDEFTABLE (PROCESSDEFID,EXTMETHODPARAMINDEX,EXTMETHODINDEX,PARAMETERNAME,PARAMETERTYPE,PARAMETERORDER,DATASTRUCTUREID,PARAMETERSCOPE,UNBOUNDED) values (0,1,9,'Param1',10,1,0,' ','N')

~

Insert into EXTMETHODPARAMDEFTABLE (PROCESSDEFID,EXTMETHODPARAMINDEX,EXTMETHODINDEX,PARAMETERNAME,PARAMETERTYPE,PARAMETERORDER,DATASTRUCTUREID,PARAMETERSCOPE,UNBOUNDED) values (0,1,10,'Param1',3,1,0,' ','N')

~

Insert into EXTMETHODPARAMDEFTABLE (PROCESSDEFID,EXTMETHODPARAMINDEX,EXTMETHODINDEX,PARAMETERNAME,PARAMETERTYPE,PARAMETERORDER,DATASTRUCTUREID,PARAMETERSCOPE,UNBOUNDED) values (0,1,11,'Param1',10,1,0,' ','N')

~

Insert into EXTMETHODPARAMDEFTABLE (PROCESSDEFID,EXTMETHODPARAMINDEX,EXTMETHODINDEX,PARAMETERNAME,PARAMETERTYPE,PARAMETERORDER,DATASTRUCTUREID,PARAMETERSCOPE,UNBOUNDED) values (0,2,11,'Param2',10,2,0,' ','N')

~

Insert into EXTMETHODPARAMDEFTABLE (PROCESSDEFID,EXTMETHODPARAMINDEX,EXTMETHODINDEX,PARAMETERNAME,PARAMETERTYPE,PARAMETERORDER,DATASTRUCTUREID,PARAMETERSCOPE,UNBOUNDED) values (0,1,12,'Param1',10,1,0,' ','N')

~

Insert into EXTMETHODPARAMDEFTABLE (PROCESSDEFID,EXTMETHODPARAMINDEX,EXTMETHODINDEX,PARAMETERNAME,PARAMETERTYPE,PARAMETERORDER,DATASTRUCTUREID,PARAMETERSCOPE,UNBOUNDED) values (0,1,13,'Param1',10,1,0,' ','N')

~

Insert into EXTMETHODPARAMDEFTABLE (PROCESSDEFID,EXTMETHODPARAMINDEX,EXTMETHODINDEX,PARAMETERNAME,PARAMETERTYPE,PARAMETERORDER,DATASTRUCTUREID,PARAMETERSCOPE,UNBOUNDED) values (0,2,13,'Param2',3,2,0,' ','N')

~

Insert into EXTMETHODPARAMDEFTABLE (PROCESSDEFID,EXTMETHODPARAMINDEX,EXTMETHODINDEX,PARAMETERNAME,PARAMETERTYPE,PARAMETERORDER,DATASTRUCTUREID,PARAMETERSCOPE,UNBOUNDED) values (0,3,13,'Param3',3,3,0,' ','N')

~

Insert into EXTMETHODPARAMDEFTABLE (PROCESSDEFID,EXTMETHODPARAMINDEX,EXTMETHODINDEX,PARAMETERNAME,PARAMETERTYPE,PARAMETERORDER,DATASTRUCTUREID,PARAMETERSCOPE,UNBOUNDED) values (0,1,14,'Param1',10,1,0,' ','N')

~

Insert into EXTMETHODPARAMDEFTABLE (PROCESSDEFID,EXTMETHODPARAMINDEX,EXTMETHODINDEX,PARAMETERNAME,PARAMETERTYPE,PARAMETERORDER,DATASTRUCTUREID,PARAMETERSCOPE,UNBOUNDED) values (0,2,14,'Param2',10,2,0,' ','N')

~

Insert into EXTMETHODPARAMDEFTABLE (PROCESSDEFID,EXTMETHODPARAMINDEX,EXTMETHODINDEX,PARAMETERNAME,PARAMETERTYPE,PARAMETERORDER,DATASTRUCTUREID,PARAMETERSCOPE,UNBOUNDED) values (0,1,15,'Param1',10,1,0,' ','N')

~

Insert into EXTMETHODPARAMDEFTABLE (PROCESSDEFID,EXTMETHODPARAMINDEX,EXTMETHODINDEX,PARAMETERNAME,PARAMETERTYPE,PARAMETERORDER,DATASTRUCTUREID,PARAMETERSCOPE,UNBOUNDED) values (0,2,15,'Param2',10,2,0,' ','N')

~

Insert into EXTMETHODPARAMDEFTABLE (PROCESSDEFID,EXTMETHODPARAMINDEX,EXTMETHODINDEX,PARAMETERNAME,PARAMETERTYPE,PARAMETERORDER,DATASTRUCTUREID,PARAMETERSCOPE,UNBOUNDED) values (0,1,16,'Param1',10,1,0,' ','N')

~

Insert into EXTMETHODPARAMDEFTABLE (PROCESSDEFID,EXTMETHODPARAMINDEX,EXTMETHODINDEX,PARAMETERNAME,PARAMETERTYPE,PARAMETERORDER,DATASTRUCTUREID,PARAMETERSCOPE,UNBOUNDED) values (0,2,16,'Param2',10,2,0,' ','N')

~

Insert into EXTMETHODPARAMDEFTABLE (PROCESSDEFID,EXTMETHODPARAMINDEX,EXTMETHODINDEX,PARAMETERNAME,PARAMETERTYPE,PARAMETERORDER,DATASTRUCTUREID,PARAMETERSCOPE,UNBOUNDED) values (0,3,16,'Param3',10,3,0,' ','N')

~

Insert into EXTMETHODPARAMDEFTABLE (PROCESSDEFID,EXTMETHODPARAMINDEX,EXTMETHODINDEX,PARAMETERNAME,PARAMETERTYPE,PARAMETERORDER,DATASTRUCTUREID,PARAMETERSCOPE,UNBOUNDED) values (0,1,17,'Param1',10,1,0,' ','N')

~

Insert into EXTMETHODPARAMDEFTABLE (PROCESSDEFID,EXTMETHODPARAMINDEX,EXTMETHODINDEX,PARAMETERNAME,PARAMETERTYPE,PARAMETERORDER,DATASTRUCTUREID,PARAMETERSCOPE,UNBOUNDED) values (0,2,17,'Param2',10,2,0,' ','N')

~

Insert into EXTMETHODPARAMDEFTABLE (PROCESSDEFID,EXTMETHODPARAMINDEX,EXTMETHODINDEX,PARAMETERNAME,PARAMETERTYPE,PARAMETERORDER,DATASTRUCTUREID,PARAMETERSCOPE,UNBOUNDED) values (0,1,18,'Param1',10,1,0,' ','N')

~

Insert into EXTMETHODPARAMDEFTABLE (PROCESSDEFID,EXTMETHODPARAMINDEX,EXTMETHODINDEX,PARAMETERNAME,PARAMETERTYPE,PARAMETERORDER,DATASTRUCTUREID,PARAMETERSCOPE,UNBOUNDED) values (0,1,19,'Param1',6,1,0,' ','N')

~

Insert into EXTMETHODPARAMDEFTABLE (PROCESSDEFID,EXTMETHODPARAMINDEX,EXTMETHODINDEX,PARAMETERNAME,PARAMETERTYPE,PARAMETERORDER,DATASTRUCTUREID,PARAMETERSCOPE,UNBOUNDED) values (0,1,20,'Param1',4,1,0,' ','N')

~

Insert into EXTMETHODPARAMDEFTABLE (PROCESSDEFID,EXTMETHODPARAMINDEX,EXTMETHODINDEX,PARAMETERNAME,PARAMETERTYPE,PARAMETERORDER,DATASTRUCTUREID,PARAMETERSCOPE,UNBOUNDED) values (0,1,21,'Param1',3,1,0,' ','N')

~

Insert into EXTMETHODPARAMDEFTABLE (PROCESSDEFID,EXTMETHODPARAMINDEX,EXTMETHODINDEX,PARAMETERNAME,PARAMETERTYPE,PARAMETERORDER,DATASTRUCTUREID,PARAMETERSCOPE,UNBOUNDED) values (0,1,22,'Param1',12,1,0,' ','N')

~

Insert into EXTMETHODPARAMDEFTABLE (PROCESSDEFID,EXTMETHODPARAMINDEX,EXTMETHODINDEX,PARAMETERNAME,PARAMETERTYPE,PARAMETERORDER,DATASTRUCTUREID,PARAMETERSCOPE,UNBOUNDED) values (0,1,23,'Param1',6,1,0,' ','N')

~

Insert into EXTMETHODPARAMDEFTABLE (PROCESSDEFID,EXTMETHODPARAMINDEX,EXTMETHODINDEX,PARAMETERNAME,PARAMETERTYPE,PARAMETERORDER,DATASTRUCTUREID,PARAMETERSCOPE,UNBOUNDED) values (0,1,24,'Param1',6,1,0,' ','N')

~

Insert into EXTMETHODPARAMDEFTABLE (PROCESSDEFID,EXTMETHODPARAMINDEX,EXTMETHODINDEX,PARAMETERNAME,PARAMETERTYPE,PARAMETERORDER,DATASTRUCTUREID,PARAMETERSCOPE,UNBOUNDED) values (0,1,25,'Param1',6,1,0,' ','N')

~

Insert into EXTMETHODPARAMDEFTABLE (PROCESSDEFID,EXTMETHODPARAMINDEX,EXTMETHODINDEX,PARAMETERNAME,PARAMETERTYPE,PARAMETERORDER,DATASTRUCTUREID,PARAMETERSCOPE,UNBOUNDED) values (0,1,29,'Param1',8,1,0,' ','N')

~

Insert into EXTMETHODPARAMDEFTABLE (PROCESSDEFID,EXTMETHODPARAMINDEX,EXTMETHODINDEX,PARAMETERNAME,PARAMETERTYPE,PARAMETERORDER,DATASTRUCTUREID,PARAMETERSCOPE,UNBOUNDED) values (0,1,30,'Param1',8,1,0,' ','N')

~

Insert into EXTMETHODPARAMDEFTABLE (PROCESSDEFID,EXTMETHODPARAMINDEX,EXTMETHODINDEX,PARAMETERNAME,PARAMETERTYPE,PARAMETERORDER,DATASTRUCTUREID,PARAMETERSCOPE,UNBOUNDED) values (0,1,31,'Param1',6,1,0,' ','N')

~

Insert into EXTMETHODPARAMDEFTABLE (PROCESSDEFID,EXTMETHODPARAMINDEX,EXTMETHODINDEX,PARAMETERNAME,PARAMETERTYPE,PARAMETERORDER,DATASTRUCTUREID,PARAMETERSCOPE,UNBOUNDED) values (0,1,32,'Param1',3,1,0,' ','Y')

~

Insert into EXTMETHODPARAMDEFTABLE (PROCESSDEFID,EXTMETHODPARAMINDEX,EXTMETHODINDEX,PARAMETERNAME,PARAMETERTYPE,PARAMETERORDER,DATASTRUCTUREID,PARAMETERSCOPE,UNBOUNDED) values (0,2,32,'Param2',3,2,0,' ','N')

~

Insert into EXTMETHODPARAMDEFTABLE (PROCESSDEFID,EXTMETHODPARAMINDEX,EXTMETHODINDEX,PARAMETERNAME,PARAMETERTYPE,PARAMETERORDER,DATASTRUCTUREID,PARAMETERSCOPE,UNBOUNDED) values (0,1,33,'Param1',3,1,0,' ','Y')

~

Insert into EXTMETHODPARAMDEFTABLE (PROCESSDEFID,EXTMETHODPARAMINDEX,EXTMETHODINDEX,PARAMETERNAME,PARAMETERTYPE,PARAMETERORDER,DATASTRUCTUREID,PARAMETERSCOPE,UNBOUNDED) values (0,2,33,'Param2',3,2,0,' ','N')

~

Insert into EXTMETHODPARAMDEFTABLE (PROCESSDEFID,EXTMETHODPARAMINDEX,EXTMETHODINDEX,PARAMETERNAME,PARAMETERTYPE,PARAMETERORDER,DATASTRUCTUREID,PARAMETERSCOPE,UNBOUNDED) values (0,3,33,'Param3',3,3,0,' ','N')

~

INSERT INTO  EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0,1,4001,'StoredProcedureName',10,1,0,' ','N')

~

INSERT INTO  EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0,2,4001,'Param1',10,2,0,' ','N')

~

INSERT INTO  EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0,3,4001,'Param2',3,3,0,' ','N')

~

INSERT INTO  EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0,4,4001,'Param3',8,4,0,' ','N')

~

INSERT INTO  EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0,1,4002,'StoredProcedureName',10,1,0,' ','N')

~

INSERT INTO  EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0,2,4002,'Param1',10,2,0,' ','N')

~

INSERT INTO  EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0,3,4002,'Param2',3,3,0,' ','N')

~

INSERT INTO  EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0,4,4002,'Param3',8,4,0,' ','N')

/* Adding System Catalog Function Ends*/

~

CREATE OR REPLACE VIEW WORKLISTTABLE AS SELECT ProcessInstanceId, WorkItemId, ProcessName, ProcessVersion, ProcessDefID, LastProcessedBy, ProcessedBy, ActivityName, ActivityId, EntryDateTime, ParentWorkItemId, AssignmentType, CollectFlag, PriorityLevel, ValidTill, Q_StreamId, Q_QueueId, Q_UserId, AssignedUser, FilterValue, CreatedDatetime, WorkItemState, Statename, ExpectedWorkitemDelay, PreviousStage, LockedByName, LockStatus, LockedTime, Queuename, Queuetype, NotifyStatus, Guid, Q_DivertedByUserId FROM WFInstrumentTable WHERE RoutingStatus = 'N' AND LockStatus = 'N';

~

DO $$
	BEGIN
		EXECUTE ('Insert into USERPREFERENCESTABLE (Userid,ObjectId,ObjectName,ObjectType,NotifyByEmail,Data) Values (0,1,N''U'',N''U'',N''N'',N''<General><BatchSize>20</BatchSize><TimeOut>0</TimeOut><ReminderPopup>N</ReminderPopup><ReminderTime>15</ReminderTime><MailFromServer>N</MailFromServer><DocumentOrder></DocumentOrder><DefaultQuickSearchVar></DefaultQuickSearchVar><WorkitemHistoryOrder>D</WorkitemHistoryOrder><DefaultQueueId></DefaultQueueId><DefaultQueueName></DefaultQueueName></General><Worklist><Fields><Field><Name>WL_REGISTRATION_NO</Name><Display>Y</Display></Field><Field><Name>WL_ENTRY_DATE</Name><Display>Y</Display></Field><Field><Name>WL_TURNAROUND_REMAINING</Name><Display>Y</Display></Field><Field><Name>WL_TURNAROUND_CONSUMED</Name><Display>Y</Display></Field><Field><Name>WL_WORKSTEP_NAME</Name><Display>Y</Display></Field><Field><Name>WL_STATUS</Name><Display>N</Display></Field><Field><Name>QUEUE_VARIABLES</Name><Display>Y</Display></Field><Field><Name>WL_LOCKED_BY</Name><Display>Y</Display></Field><Field><Name>WL_CHECKLIST_STATUS</Name><Display>Y</Display></Field><Field><Name>WL_TURNAROUND_DATETIME</Name><Display>Y</Display></Field><Field><Name>WL_VALID_TILL</Name><Display>Y</Display></Field><Field><Name>WL_LOCKED_DATE</Name><Display>Y</Display></Field><Field><Name>WL_INTRODUCED_ON</Name><Display>Y</Display></Field><Field><Name>WL_INTRODUCED_BY</Name><Display>Y</Display></Field><Field><Name>WL_ASSIGNED_TO</Name><Display>Y</Display></Field><Field><Name>WL_PROCESSED_BY</Name><Display>Y</Display></Field><Field><Name>WL_QUEUE_NAME</Name><Display>Y</Display></Field><Field><Name>WL_CREATED_DATE_TIME</Name><Display>Y</Display></Field><Field><Name>WL_STATE</Name><Display>Y</Display></Field></Fields></Worklist><SearchFolder><Fields><Field><Name>F_NAME</Name><Display>Y</Display></Field><Field><Name>F_CREATION_DATE</Name><Display>Y</Display></Field><Field><Name>F_REVISED_DATE</Name><Display>Y</Display></Field><Field><Name>F_ACCESSED_DATE</Name><Display>Y</Display></Field><Field><Name>F_OWNER</Name><Display>Y</Display></Field><Field><Name>F_DATACLASS</Name><Display>Y</Display></Field></Fields></SearchFolder><SearchDocument><Fields><Field><Name>D_NAME</Name><Display>Y</Display></Field><Field><Name>D_REVISED_DATE</Name><Display>Y</Display></Field><Field><Name>D_TYPE</Name><Display>Y</Display></Field><Field><Name>D_SIZE</Name><Display>Y</Display></Field><Field><Name>D_PAGE</Name><Display>Y</Display></Field><Field><Name>D_DATACLASS</Name><Display>Y</Display></Field><Field><Name>D_USEFUL_INFO</Name><Display>Y</Display></Field><Field><Name>D_ANNOTATED</Name><Display>Y</Display></Field><Field><Name>D_LINKED</Name><Display>Y</Display></Field><Field><Name>D_CHECKED_OUT</Name><Display>Y</Display></Field><Field><Name>D_ORDER_NO</Name><Display>Y</Display></Field></Fields></SearchDocument><Workdesk><Fields><Field><Name>WD_PREV</Name><Display>Y</Display></Field><Field><Name>WD_NEXT</Name><Display>Y</Display></Field><Field><Name>WD_SAVE</Name><Display>Y</Display></Field><Field><Name>WD_TOOLS</Name><Display>Y</Display></Field><Field><Name>WD_DONE_INTRO</Name><Display>Y</Display></Field><Field><Name>WD_HELP</Name><Display>Y</Display></Field><Field><Name>WD_ACCEPT_REJECT</Name><Display>Y</Display></Field><Field><Name>OP_WI_ADDCONVERSATION</Name><Display>Y</Display></Field><Field><Name>OP_WI_ADDDOCUMENT</Name><Display>Y</Display></Field><Field><Name>OP_WI_IMPORTDOCUMENT</Name><Display>Y</Display></Field><Field><Name>OP_WI_SCANDOCUMENT</Name><Display>Y</Display></Field><Field><Name>OP_WI_PREFERENCE</Name><Display>Y</Display></Field><Field><Name>OP_WI_REASSIGNWI</Name><Display>Y</Display></Field><Field><Name>OP_WI_LINKEDWI</Name><Display>Y</Display></Field><Field><Name>OP_WI_SEARCH</Name><Display>Y</Display></Field><Field><Name>OP_SEARCH_DOCUMENT</Name><Display>Y</Display></Field><Field><Name>OP_SEARCH_FOLDER</Name><Display>Y</Display></Field><Field><Name>OP_WI_REFER_REVOKE</Name><Display>Y</Display></Field><Field><Name>OP_WI_EXT_INTERFACES</Name><Display>Y</Display></Field><Field><Name>OP_WI_PROPERTIES</Name><Display>Y</Display></Field><Field><Name>WD_HOLD</Name><Display>Y</Display></Field><Field><Name>WD_UNHOLD</Name><Display>Y</Display></Field></Fields></Workdesk><GeneralPreferences><MainHeaderFields><Fields><Field><Name>PREF_INITIATE</Name><Display>1</Display></Field><Field><Name>PREF_DONE</Name><Display>3</Display></Field><Field><Name>PREF_REFER</Name><Display>24</Display></Field></Fields></MainHeaderFields><InnerFields><Fields><Field><Name>PREF_REASSIGN</Name><Display>11</Display></Field><Field><Name>PREF_REVOKE</Name><Display>4</Display></Field><Field><Name>PREF_ADHOC_ROUTING</Name><Display>19</Display></Field><Field><Name>PREF_PROPERTIES</Name><Display>7</Display></Field><Field><Name>PREF_GET_LOCK</Name><Display>10</Display></Field><Field><Name>PREF_RELEASE</Name><Display>23</Display></Field><Field><Name>PREF_SET_DIVERSION</Name><Display>13</Display></Field><Field><Name>PREF_UNLOCK</Name><Display>20</Display></Field><Field><Name>PREF_PRIORITY</Name><Display>8</Display></Field><Field><Name>PREF_SET_REMINDER</Name><Display>9</Display></Field><Field><Name>PREF_DELETE</Name><Display>12</Display></Field><Field><Name>PREF_SET_FILTER</Name><Display>14</Display></Field><Field><Name>PREF_COUNT</Name><Display>15</Display></Field><Field><Name>PREF_REMINDER_LIST</Name><Display>16</Display></Field><Field><Name>PREF_PREFERENCES</Name><Display>17</Display></Field><Field><Name>PREF_GLOBALPREFERENCES</Name><Display>22</Display></Field><Field><Name>PREF_HOLD</Name><Display>5</Display></Field><Field><Name>PREF_UNHOLD</Name><Display>6</Display></Field></Fields></InnerFields></GeneralPreferences>'')');
	END;
$$;

~
/***********	WFTaskUserFilterTable  ****************/
       CREATE TABLE WFTaskUserFilterTable( 
				ProcessDefId INTEGER NOT NULL,
				FilterId INTEGER NOT NULL,
				RuleType VARCHAR(1) NOT NULL,
				RuleOrderId INTEGER  NOT NULL,
				RuleId INTEGER  NOT NULL,
				ConditionOrderId INTEGER  NOT NULL,
				Param1 VARCHAR(255) NOT NULL,
				Type1 VARCHAR(1) NOT NULL,
				ExtObjID1 INTEGER  NULL,
				VariableId_1 INTEGER  Not NULL,
				VarFieldId_1 INTEGER  NULL,
				Param2 VARCHAR(255) NULL,
				Type2 VARCHAR(1)  NULL,
				ExtObjID2 INTEGER  NULL,
				VariableId_2 INTEGER  NULL,
				VarFieldId_2 INTEGER  NULL,
				Operator INTEGER NULL,
				LogicalOp INTEGER  NOT NULL
			)
			
~
DO $$ 
<<first_block>>
DECLARE 
		existFlag  INTEGER :=0;
BEGIN 
	existFlag:=0;
	select 1 into existFlag from information_schema.tables where upper(table_name) =  UPPER('PDBPMS_TABLE');
	IF (not found) then 
		Execute  'CREATE TABLE PDBPMS_TABLE
			(
               Product_Name   VARCHAR(255),
               Product_Version               VARCHAR(255),
               Product_Type     VARCHAR(255),
               Patch_Number   int,
               Install_Date    VARCHAR(255)
		)';
		End if;
END first_block $$;

~

INSERT INTO PDBPMS_TABLE(Product_Name,Product_Version,Product_Type,Patch_Number,Install_Date) values('iBPS','5.0 SP3','PT',1,NOW());

~

INSERT INTO WFCabVersionTable(cabVersion,  creationDate, lastModified, Remarks, Status) VALUES (N'iBPS_5.0_SP3_01',  CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, N'iBPS_5.0_SP3_01', N'Y')

~