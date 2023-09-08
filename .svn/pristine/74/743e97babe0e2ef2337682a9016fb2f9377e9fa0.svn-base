/*____________________________________________________________________________________________________
			NEWGEN SOFTWARE TECHNOLOGIES LIMITED
		Group					: Phoenix
		Product / Project		: WorkFlow 7.2
		Module					: Workflow Server
		File Name				: OFCabCreation.sql
		Author					: 
		Date written(DD/MM/YYYY): 
		Description				: Script for cabinet creation (Omniflow DB2).
____________________________________________________________________________________________________
			CHANGE HISTORY
____________________________________________________________________________________________________
Date(DD/MM/YYYY)		Change By			Change Description (Bug No. (If Any))
	20/05/2008			Ashish Mangla		Bugzilla Bug 5044 (UserDiversionTable, keep user name also in the table)		13/03/2013       	Neeraj Sharma   	Bug 38685 An entry for each failed records need to be generated in
											WFFailedServicesTable if any error occurs while processing records from the CSV/TXT file.

____________________________________________________________________________________________________
____________________________________________________________________________________________________
*/
-- CONNECT TO OMNICAB user db2admin using db2isgood;

CREATE TABLE WFCabVersionTable (
	cabVersion	VARGRAPHIC(10) NOT NULL,
	cabVersionId	INT GENERATED ALWAYS AS IDENTITY(START WITH 1, INCREMENT BY 1) NOT NULL PRIMARY KEY,
	creationDate	TIMESTAMP,
	lastModified	TIMESTAMP,
	Remarks		VARGRAPHIC(200) NOT NULL,
	Status		VARGRAPHIC(1)
);

INSERT INTO WFCabVersionTable(cabVersion, cabVersionId, creationDate, lastModified, Remarks, Status) VALUES (N'7.0.1', DEFAULT, CURRENT TIMESTAMP, CURRENT TIMESTAMP, N'OFCabCreation.sql', N'Y');

CREATE TABLE PROCESSDEFTABLE(
	ProcessDefId		INT		NOT NULL PRIMARY KEY,
	VersionNo		SMALLINT	NOT NULL,
	ProcessName		VARGRAPHIC(30)	NOT NULL,
	ProcessState		VARGRAPHIC(10),
	RegPrefix		VARGRAPHIC(20)	NOT NULL,
	RegSuffix		VARGRAPHIC(20),
	RegStartingNo		INT,
	ProcessTurnAroundTime	INT,
	RegSeqLength		INT,
	CreatedOn		TIMESTAMP, 
	LastModifiedOn		TIMESTAMP,
	WSFont			VARGRAPHIC(255),
	WSColor			INT,
	CommentsFont		VARGRAPHIC(255),
	CommentsColor		INT,
	Backcolor		INT, 
	TATCalFlag		VARGRAPHIC(1)
);

CREATE TABLE INTERFACEDEFTABLE(
	InterfaceId		INT		NOT NULL PRIMARY KEY,
	InterfaceName		VARGRAPHIC(255)	NOT NULL, 
	ClientInvocation	VARGRAPHIC(255), 
	ButtonName		VARGRAPHIC(50), 
	MenuName		VARGRAPHIC(50), 
	ExecuteClass		VARGRAPHIC(255),
	ExecuteClassWeb		VARGRAPHIC(255) 
);

CREATE TABLE PROCESS_INTERFACETABLE(
	ProcessDefId		INT		NOT NULL,
	InterfaceId		INT		NOT NULL,
	InterfaceName		VARGRAPHIC(255)	NOT NULL, 
	ClientInvocation	VARGRAPHIC(255), 
	MenuName		VARGRAPHIC(50), 
	ExecuteClass		VARGRAPHIC(255), 
	ExecuteClassWeb		VARGRAPHIC(255), 
	PRIMARY KEY(ProcessDefId, InterfaceId)
);

CREATE TABLE ACTIVITYTABLE(
	ProcessDefId		INT		NOT NULL,
	ActivityId 		INT 		NOT NULL,
	ActivityType 		SMALLINT	NOT NULL,
	ActivityName		VARGRAPHIC(30)	NOT NULL,
	Description		VARGRAPHIC(255),
	xLeft 			SMALLINT	NOT NULL,
	yTop 			SMALLINT	NOT NULL,
	NeverExpireFlag		VARGRAPHIC(1)	NOT NULL,
	Expiry 			VARGRAPHIC(255),
	ExpiryActivity 		VARGRAPHIC(30),
	TargetActivity 		INT,
	AllowReASsignment	VARGRAPHIC(1),
	CollectNoOfInstances 	INT,
	PrimaryActivity		VARGRAPHIC(30),
	ExpireOnPrimaryFlag	VARGRAPHIC(1),
	TriggerID 		SMALLINT,
	HoldExecutable 		VARGRAPHIC(255),
	HoldTillVariable	VARGRAPHIC(255),
	ExtObjID 		INT,
	MainClientInterface 	VARGRAPHIC(255),
	ServerInterface		VARGRAPHIC(1) CHECK(ServerINTerface in(N'Y', N'N', N'E')),
	WebClientInterface 	VARGRAPHIC(255),
	ActivityIcon 		BLOB,
	ActivityTurnAroundTime 	INT,
	AppExecutionFlag 	VARGRAPHIC(1),
	AppExecutionValue  	INT,
 	ExpiryOperator		INT,
	TATCalFlag		VARGRAPHIC(1),
	ExpCalFlag		VARGRAPHIC(1),
	DeleteOnCollect VARGRAPHIC(1)	NULL,
	PRIMARY KEY(ProcessDefId, ActivityID)
);

CREATE TABLE RULECONDITIONTABLE(
	ProcessDefId 	    	INT		NOT NULL,
	ActivityId          	INT		NOT NULL,
	RuleType            	VARGRAPHIC(1)   NOT NULL,
	RuleOrderId         	SMALLINT      	NOT NULL,
	RuleId              	SMALLINT      	NOT NULL,
	ConditionOrderId    	SMALLINT 	NOT NULL,
	Param1			VARGRAPHIC(50) 	NOT NULL,
	Type1               	VARGRAPHIC(1) 	NOT NULL,
	ExtObjID1	    	INT,
	Param2			VARGRAPHIC(255)	NOT NULL,
	Type2               	VARGRAPHIC(1) 	NOT NULL,
	ExtObjID2	    	INT,
	Operator            	SMALLINT 	NOT NULL,
	LogicalOp           	SMALLINT 	NOT NULL 
);

CREATE TABLE WFFailedServicesTable(
	processDefId INT NULL,
	ServiceName VARGRAPHIC(200) NULL,
	ServiceType VARGRAPHIC(30) NULL,
	ServiceId VARGRAPHIC(200) NULL,
	ActionDateTime TIMESTAMP NULL,
	ObjectName VARGRAPHIC(100) NULL,
	ErrorCode INT NULL,
	ErrorMessage VARGRAPHIC(500) NULL,
	Data_1 INT NULL,
	Data_2 INT NULL
)


CREATE TABLE RULEOPERATIONTABLE(
	ProcessDefId 	 	INT		NOT NULL,
	ActivityId       	INT       	NOT NULL,
	RuleType               	VARGRAPHIC(1)  	NOT NULL,
	RuleId                  SMALLINT       	NOT NULL,
	OperationType       	SMALLINT       	NOT NULL,
	Param1			VARGRAPHIC(50)  NOT NULL,
	Type1                   VARGRAPHIC(1)   NOT NULL,
	ExtObjID1	 	INT,	
	Param2			VARGRAPHIC(255) NOT NULL,
	Type2                   VARGRAPHIC(1)   NOT NULL,
	ExtObjID2	  	INT,
	Param3                  VARGRAPHIC(255),
	Type3                   VARGRAPHIC(1),
	ExtObjID3	   	INT,
	Operator                SMALLINT 	NOT NULL,
	OperationOrderId     	SMALLINT       	NOT NULL,
	CommentFlag          	VARGRAPHIC(1),
	RuleCalFlag		VARGRAPHIC(1),
	PRIMARY KEY(ProcessDefId, ActivityId, RuleType, RuleId, OperationOrderId)
);

CREATE TABLE PROCESSDEFCOMMENTTABLE(
	ProcessDefId 		INT		NOT NULL,
	LeftPos 		INT		NOT NULL,
	TopPos 			INT		NOT NULL,
	Width 			INT		NOT NULL,
	Height 			INT		NOT NULL,
	Type 			VARGRAPHIC(1)	NOT NULL,
	Comments		VARGRAPHIC(255)	NOT NULL,
	SourceId  		INT,
	Targetid 		INT,
	RuleId   		INT			
);

CREATE TABLE WORKSTAGELINKTABLE(
	ProcessDefId 		INT 		NOT NULL,
	SourceId 		INT 		NOT NULL,
	TargetId 		INT 		NOT NULL,
	Color 			INT,
	Type 			VARGRAPHIC(1)	
);

CREATE TABLE VARMAPPINGTABLE(
	ProcessDefId 		INT 		NOT NULL,
	SystemDefinedName	VARGRAPHIC(50) 	NOT NULL,
	UserDefinedName		VARGRAPHIC(50),
	VariableType 		SMALLINT 	NOT NULL,
	VariableScope 		VARGRAPHIC(1) 	NOT NULL,
	ExtObjId 		INT,
	DefaultValue		VARGRAPHIC(255),
	CONSTRAINT CK_VarMap_VarScope CHECK(VariableScope = 'M' or(VariableScope = 'I' or(VariableScope = 'U' or(VariableScope = 'S')))),
	CONSTRAINT PK_VarMappingTABLE PRIMARY KEY(ProcessDefID, SystemDefinedName)
);

CREATE TABLE ACTIVITYASSOCIATIONTABLE(
	ProcessDefId 		INT 		NOT NULL,
	ActivityId 		INT 		NOT NULL,
	DefinitionType 		VARGRAPHIC(1) 	NOT NULL,
	DefinitionId 		SMALLINT 	NOT NULL,
	AccessFlag		VARGRAPHIC(3),
        FieldName      		VARGRAPHIC(255),
        Attribute      		VARGRAPHIC(1),
        ExtObjID       		INT,
	PRIMARY KEY(ProcessDefId, ActivityId, DefinitionType, DefinitionId),
	CONSTRAINT CK_ASsoc_TABLEr CHECK(DefinitionType = 'I' or(DefinitionType = 'Q' or(DefinitionType = 'N' or(DefinitionType = 'S' or(DefinitionType = 'P' or(DefinitionType = 'T' ))))))
);

CREATE TABLE TRIGGERDEFTABLE( 
	ProcessDefId 		INT 		NOT NULL,
	TriggerID 		SMALLINT 	NOT NULL,
	TriggerName 		VARGRAPHIC(50) 	NOT NULL,
	TriggerType		VARGRAPHIC(1)	NOT NULL,
	TriggerTypeName		VARGRAPHIC(50),	
	Description		VARGRAPHIC(255), 
	AssociatedTAId		INT,
	PRIMARY KEY(Processdefid, TriggerID)
);

CREATE TABLE TRIGGERTYPEDEFTABLE( 
	ProcessDefId 		INT 		NOT NULL,
	TypeName		VARGRAPHIC(50)	NOT NULL,
	ClassName		VARGRAPHIC(50)	NOT NULL,
	ExecutableClass		VARGRAPHIC(255),
	HttpPath		VARGRAPHIC(255),
	PRIMARY KEY(Processdefid, TypeName)
);

CREATE TABLE MAILTRIGGERTABLE( 
	ProcessDefId 		INT 		NOT NULL,
	TriggerID 		SMALLINT 	NOT NULL,
	Subject 		VARGRAPHIC(255),
	FromUser		VARGRAPHIC(255),
	FromUserType		VARGRAPHIC(1),
	ExtObjIDFromUser 	INT,
	ToUser			VARGRAPHIC(255)	NOT NULL,
	ToType			VARGRAPHIC(1)	NOT NULL,
	ExtObjIDTo		INT,
	CCUser			VARGRAPHIC(255),
	CCType			VARGRAPHIC(1),
	ExtObjIDCC		INT,	
	Message			CLOB,
	PRIMARY KEY(Processdefid, TriggerID)
);

CREATE TABLE EXECUTETRIGGERTABLE( 
	ProcessDefId 		INT 		NOT NULL,
	TriggerID 		SMALLINT 	NOT NULL,
	FunctionName 		VARGRAPHIC(255) NOT NULL,
	ArgList			VARGRAPHIC(255),	
	HttpPath		VARGRAPHIC(255),	
	PRIMARY KEY(Processdefid, TriggerID)
);

CREATE TABLE LAUNCHAPPTRIGGERTABLE( 
	ProcessDefId 		INT 		NOT NULL,
	TriggerID 		SMALLINT 	NOT NULL,
	ApplicationName 	VARGRAPHIC(255)	NOT NULL,
	ArgList			VARGRAPHIC(255),
	PRIMARY KEY(Processdefid, TriggerID)
);

CREATE TABLE DATAENTRYTRIGGERTABLE( 
	ProcessDefId 		INT 		NOT NULL,
	TriggerID 		SMALLINT 	NOT NULL,
	VariableName		VARGRAPHIC(255)	NOT NULL,
	Type			VARGRAPHIC(1)	NOT NULL,
	ExtObjID		INT,
	PRIMARY KEY(Processdefid, TriggerID, VariableName)
);

CREATE TABLE DATASETTRIGGERTABLE( 
	ProcessDefId 		INT 		NOT NULL,
	TriggerID 		SMALLINT 	NOT NULL,
	Param1			VARGRAPHIC(50) 	NOT NULL,
	Type1			VARGRAPHIC(1)	NOT NULL,
	ExtObjID1		INT,
	Param2			VARGRAPHIC(255)	NOT NULL,
	Type2			VARGRAPHIC(1)	NOT NULL,
	ExtObjID2		INT
);

CREATE TABLE STREAMDEFTABLE(
	ProcessDefId 		INT 		NOT NULL,
	StreamId 		INT 		NOT NULL,
	ActivityId 		INT 		NOT NULL,
	StreamName		VARGRAPHIC(30) 	NOT NULL,
	SortType 		VARGRAPHIC(1) 	NOT NULL,
	SortOn			VARGRAPHIC(50) 	NOT NULL,
	StreamCondition		VARGRAPHIC(255)	NOT NULL,
	CONSTRAINT u_sdTABLE PRIMARY KEY(ProcessDefId, ActivityId, StreamId) 
);

CREATE TABLE EXTDBCONFTABLE(
	ProcessDefId 		INT 		NOT NULL,
	DatabASeName 		VARGRAPHIC(255),
	DatabASeType		VARGRAPHIC(20),
	UserId 			VARGRAPHIC(255), 
	PWD 			VARGRAPHIC(255), 
	TABLEName 		VARGRAPHIC(255), 
	ExtObjID 		INT 		NOT NULL,
	HostName  		VARGRAPHIC(255),
	Service	 		VARGRAPHIC(255),
	Port			INT,
	PRIMARY KEY(ProcessDefId, ExtObjID)
);

CREATE TABLE RECORDMAPPINGTABLE( 
	ProcessDefId 		INT 		NOT NULL PRIMARY KEY,
	Rec1 			VARGRAPHIC(255),
	Rec2 			VARGRAPHIC(255),
	Rec3 			VARGRAPHIC(255),
	Rec4 			VARGRAPHIC(255),
	Rec5 			VARGRAPHIC(255)	 
);

CREATE TABLE STATESDEFTABLE( 
	ProcessDefId 		INT 		NOT NULL,
	StateId			INTEGER 	NOT NULL,
	StateName 		VARGRAPHIC(255)	NOT NULL,
	PRIMARY KEY(ProcessDefId, StateId) 
);

CREATE TABLE QUEUEHISTORYTABLE(
	ProcessDefId 		INT 		NOT NULL,
	ProcessName 		VARGRAPHIC(30),
	ProcessVersion 		SMALLINT,
	ProcessInstanceId	VARGRAPHIC(63) 	NOT NULL,
	ProcessInstanceName	VARGRAPHIC(63),
	ActivityId 		INT 		NOT NULL,
	ActivityName		VARGRAPHIC(30),
	ParentWorkItemId 	INT,
	WorkItemId 		INT 		NOT NULL,
	ProcessInstanceState 	INT 		NOT NULL,
	WorkItemState 		INT 		NOT NULL,
	Statename 		VARGRAPHIC(50),
	QueueName		VARGRAPHIC(63),
	QueueType 		VARGRAPHIC(1),
	AssignedUser		VARGRAPHIC(63),
	AssignmentType 		VARGRAPHIC(1),
	InstrumentStatus 	VARGRAPHIC(1),
	CheckListCompleteFlag 	VARGRAPHIC(1),
	IntroductionDateTime	TIMESTAMP,
	CreatedDatetime		TIMESTAMP,
	Introducedby		VARGRAPHIC(63),
	CreatedByName		VARGRAPHIC(63),
	EntryDATETIME		TIMESTAMP 	NOT NULL,
	LockStatus 		VARGRAPHIC(1),
	HoldStatus 		SMALLINT,
	PriorityLevel 		SMALLINT 	NOT NULL,
	LockedByName		VARGRAPHIC(63),
	LockedTime		TIMESTAMP,
	ValidTill		TIMESTAMP,
	SaveStage		VARGRAPHIC(30),
	PreviousStage		VARGRAPHIC(30),
	ExpectedWorkItemDelayTime TIMESTAMP,
	ExpectedProcessDelayTime TIMESTAMP,
	Status 			VARGRAPHIC(50),
	VAR_INT1 		SMALLINT,
	VAR_INT2 		SMALLINT,
	VAR_INT3 		SMALLINT,
	VAR_INT4 		SMALLINT,
	VAR_INT5 		SMALLINT,
	VAR_INT6 		SMALLINT,
	VAR_INT7 		SMALLINT,
	VAR_INT8 		SMALLINT,
	VAR_FLOAT1		Numeric(15,2),
	VAR_FLOAT2		Numeric(15,2),
	VAR_DATE1		TIMESTAMP,
	VAR_DATE2		TIMESTAMP,
	VAR_DATE3		TIMESTAMP,
	VAR_DATE4		TIMESTAMP,
	VAR_LONG1 		INT,
	VAR_LONG2 		INT,
	VAR_LONG3 		INT,
	VAR_LONG4 		INT,
	VAR_STR1		VARGRAPHIC(255),
	VAR_STR2		VARGRAPHIC(255),
	VAR_STR3		VARGRAPHIC(64),
	VAR_STR4		VARGRAPHIC(64),
	VAR_STR5		VARGRAPHIC(64),
	VAR_STR6		VARGRAPHIC(64),
	VAR_STR7		VARGRAPHIC(32),
	VAR_STR8		VARGRAPHIC(32),
	VAR_REC_1		VARGRAPHIC(16),
	VAR_REC_2		VARGRAPHIC(16),
	VAR_REC_3		VARGRAPHIC(16),
	VAR_REC_4		VARGRAPHIC(16),
	VAR_REC_5		VARGRAPHIC(16),
	Q_StreamId 		INT,
	Q_QueueId 		INT,
	Q_UserID 		INT,
	LastProcessedBy 	INT,
	ProcessedBy		VARGRAPHIC(63),
	ReferredTo 		INT,
	ReferredToName		VARGRAPHIC(63),
	ReferredBy 		INT,
	ReferredByName		VARGRAPHIC(63),
	CollectFlag 		VARGRAPHIC(1),
	CompletionDatetime	TIMESTAMP,
	PRIMARY KEY(ProcessInstanceId, WorkItemId)
);

CREATE TABLE ROUTEPARENTTABLE(
	ProcessDefId  		INT 		NOT NULL,
	ParentProcessDefId 	INT 		NOT NULL,
	PRIMARY KEY(Processdefid, ParentProcessDefId)
);

CREATE TABLE CURRENTROUTELOGTABLE(
	LogId 			INT		generated always as identity(start with 1, increment by 1) NOT NULL PRIMARY KEY,
	ProcessDefId  		INT 		NOT NULL,
	ActivityId 		INT,
	ProcessInstanceId	VARGRAPHIC(63),
	WorkItemId 		INT,
	UserId 			INT,
	ActionId 		INT 		NOT NULL,
	ActionDatetime		TIMESTAMP 	NOT NULL DEFAULT CURRENT TIMESTAMP,
	AssociatedFieldId 	INT,
	AssociatedFieldName	VARGRAPHIC(1500),
	ActivityName		VARGRAPHIC(30),
	UserName		VARGRAPHIC(63)	
);

CREATE TABLE HISTORYROUTELOGTABLE(
	LogId 			INT  		NOT NULL PRIMARY KEY,
	ProcessDefId  		INT 		NOT NULL,
	ActivityId 		INT,
	ProcessInstanceId	VARGRAPHIC(63),
	WorkItemId 		INT,
	UserId 			INT,
	ActionId 		INT 		NOT NULL,
	ActionDatetime		TIMESTAMP 	NOT NULL DEFAULT CURRENT TIMESTAMP,
	ASsociatedFieldId 	INT,
	ASsociatedFieldName	VARGRAPHIC(1500),
	ActivityName		VARGRAPHIC(30),
	UserName		VARGRAPHIC(63)	 
);

CREATE TABLE GENERATERESPONSETABLE(
	ProcessDefId            INTEGER         NOT NULL,
	TriggerID               SMALLINT        NOT NULL,
	FileName                VARGRAPHIC(255) NOT NULL,
	ApplicationName        	VARGRAPHIC(255) NOT NULL,
	ArgList                	VARGRAPHIC(255), 
	GenDocType             	VARGRAPHIC(255),
	PRIMARY KEY(Processdefid, TriggerID)
);

CREATE TABLE EXCEPTIONTRIGGERTABLE(
	ProcessDefId		INTEGER		NOT NULL,
	TriggerID		SMALLINT	NOT NULL,
	ExceptionName		VARGRAPHIC(255)	NOT NULL,
	Attribute		VARGRAPHIC(255) NOT NULL,
	RaiseViewComment	VARGRAPHIC(255),
	ExceptionId		INTEGER		NOT NULL,
	PRIMARY KEY(Processdefid, TriggerID)
);

CREATE TABLE TEMPLATEDEFINITIONTABLE(
	ProcessDefId		INTEGER         NOT NULL,
	TemplateId		INTEGER   	NOT NULL,
	TemplateFileName	VARGRAPHIC(255) NOT NULL,
	TemplateBuffer		BLOB
);

CREATE TABLE EXTDBFIELDDEFINITIONTABLE(
	ProcessDefId		INTEGER         NOT NULL,
	FieldName		VARGRAPHIC(50) 	NOT NULL,
	FieldType    		VARGRAPHIC(255)	NOT NULL,
	FieldLength		INTEGER, 
	DefaultValue		VARGRAPHIC(255),
	Attribute 		VARGRAPHIC(255)	
);

CREATE TABLE QUEUESTREAMTABLE(
	ProcessDefID 		INT		NOT NULL,
	ActivityID 		INT		NOT NULL,
	StreamId 		INT		NOT NULL,
	QueueId 		INT,
	CONSTRAINT QST_PRIM PRIMARY KEY(ProcessDefID, ActivityID, StreamId)
);

CREATE TABLE QUEUEDEFTABLE(
	QueueID			INT		generated always as identity(start with 1, increment by 1) NOT NULL PRIMARY KEY,
	QueueName		VARGRAPHIC(63) 	NOT NULL,
	QueueType		VARGRAPHIC(1) 	NOT NULL,
	Comments		VARGRAPHIC(255),
	AllowReASsignment 	VARGRAPHIC(1),
	FilterOption		INT,
	FilterValue		VARGRAPHIC(63),
	OrderBy			INT,
	CONSTRAINT uk_QueueDefTable UNIQUE(QueueName)
);

CREATE TABLE QUEUEUSERTABLE(
	QueueId 		INT 		NOT NULL,
	Userid 			INT 	NOT NULL,
	ASsociationType 	SMALLINT 	NOT NULL,
	ASsignedTillDATETIME	TIMESTAMP,
	QueryFilter		VARGRAPHIC(1500),
	PRIMARY KEY(QueueID, UserId, ASsociationType)
);

CREATE TABLE PSREGISTERATIONTABLE(
	PSId 			INT		generated always as identity(start with 1, increment by 1) NOT NULL,
	PSName			VARGRAPHIC(63) 	NOT NULL,
	Type			CHAR(1) 	NOT NULL DEFAULT 'P' CHECK(Type = 'C' OR Type = 'P' ),
	SessionId 		INT,
	Processdefid 		INT,
	data			VARGRAPHIC(1500),	
	PRIMARY KEY(PSName, Type)
);

CREATE TABLE USERDIVERSIONTABLE( 
	Diverteduserindex 	INT	NOT NULL, 
	DivertedUserName	VARGRAPHIC(63), 
	ASsignedUserindex 	INT	NOT NULL, 
	AssignedUserName	VARGRAPHIC(63), 
	fromdate			TIMESTAMP	NOT NULL, 
	todate				TIMESTAMP, 
	currentworkitemsflag 	VARGRAPHIC(1) CHECK(currentworkitemsflag in('Y','N')),
	CONSTRAINT Pk_userdiversion PRIMARY KEY(Diverteduserindex, ASsignedUserindex, fromdate) 
);

CREATE TABLE USERWORKAUDITTABLE( 
	Userindex		INT	NOT NULL, 
	Auditoruserindex 	INT	NOT NULL, 
	Percentageaudit 	INT,
	AuditActivityId		INT		NOT NULL, 
	WorkItemCount		VARGRAPHIC(100),
	ProcessDefId		INT		NOT NULL,
	CONSTRAINT pk_userwrkaudit PRIMARY KEY(userIndex, auditoruserindex, AuditActivityId, ProcessDefId)
);

CREATE TABLE PREFERREDQUEUETABLE( 
	userindex 		INT	NOT NULL, 
	queueindex 		INT		NOT NULL,
	CONSTRAINT pk_quserindex PRIMARY KEY(userIndex, queueIndex) 
);

CREATE TABLE USERPREFERENCESTABLE(
	Userid 			INT	NOT NULL,
	ObjectId 		INT		NOT NULL,
	ObjectName 		VARGRAPHIC(255) NOT NULL,
	ObjectType 		VARGRAPHIC(30)	NOT NULL,
	NotifyByEmail 		VARGRAPHIC(1),
	Data			CLOB,
	CONSTRAINT Pk_User_pref PRIMARY KEY(Userid, ObjectId, ObjectType),
	CONSTRAINT Uk_User_pref UNIQUE(Userid, Objectname, ObjectType)
);

CREATE TABLE WFLINKSTABLE(
	ChildProcessInstanceID 	VARGRAPHIC(63) 	NOT NULL,
	ParentProcessInstanceID VARGRAPHIC(63) 	NOT NULL,
	PRIMARY KEY(ChildProcessInstanceID, ParentProcessInstanceID)
);

CREATE TABLE VARALIASTABLE(
 	Id			INT		generated always as identity(start with 1, increment by 1) NOT NULL,
	AliAS   		VARGRAPHIC(63) 	NOT NULL,
 	ToReturn  		VARGRAPHIC(1)  	NOT NULL CHECK(ToReturn in('Y','N')),
 	Param1  		VARGRAPHIC(50) 	NOT NULL,
 	Type1  			VARGRAPHIC(1),
 	Param2 			VARGRAPHIC(255),
 	Type2 			VARGRAPHIC(1) CHECK(Type2 in('V','C')),
 	Operator 		SMALLINT, 
	QueueId			INT		NOT NULL,
	PRIMARY KEY(AliAS, QueueId)
);

CREATE TABLE INITIATEWORKITEMDEFTABLE( 
	ProcessDefID 		INT		NOT NULL,
	ActivityId		INT		NOT NULL,
	ImportedProcessName 	VARGRAPHIC(30)	NOT NULL,
	ImportedFieldName 	VARGRAPHIC(63)	NOT NULL,
	MappedFieldName		VARGRAPHIC(63)	NOT NULL,	
	FieldType		VARGRAPHIC(1)	NOT NULL,
	MapType			VARGRAPHIC(1)
);

CREATE TABLE IMPORTEDPROCESSDEFTABLE(
	ProcessDefID 		INT 		NOT NULL,
	ActivityId		INT		NOT NULL,
	ImportedProcessName 	VARGRAPHIC(30)	NOT NULL,
	ImportedFieldName 	VARGRAPHIC(63)	NOT NULL,
	FieldDataType		INT,	
	FieldType		VARGRAPHIC(1)	NOT NULL	
);

CREATE TABLE WFREMINDERTABLE(
 	RemIndex 		INT		generated always as identity(start with 1, increment by 1) NOT NULL PRIMARY KEY,
 	ToIndex 		INT 	NOT NULL,
 	ToType 			VARGRAPHIC(1) 	NOT NULL DEFAULT 'U',
 	ProcessInstanceId 	VARGRAPHIC(63) 	NOT NULL,
	WorkitemId 		INT,
 	RemDATETIME 		TIMESTAMP 	NOT NULL,
 	RemComment 		VARGRAPHIC(255),
 	SetByUser 		INT 	NOT NULL,
 	InformMode 		VARGRAPHIC(1) 	NOT NULL DEFAULT 'P',
 	ReminderType 		VARGRAPHIC(1) 	NOT NULL DEFAULT 'U',
 	MailFlag 		VARGRAPHIC(1) 	NOT NULL DEFAULT 'N',
 	FaxFlag 		VARGRAPHIC(1) 	NOT NULL DEFAULT 'N'
);

CREATE TABLE PROCESSINSTANCETABLE(
	ProcessInstanceID	VARGRAPHIC(63) NOT NULL PRIMARY KEY,
	ProcessDefID 		INT 		NOT NULL,
	Createdby 		INT 		NOT NULL,
	CreatedByName		VARGRAPHIC(63),
	CreatedDatetime		TIMESTAMP 	NOT NULL,
	IntroducedById 		INT,
	Introducedby		VARGRAPHIC(63),
	IntroductionDateTime	TIMESTAMP,
	ProcessInstanceState 	INT,
	ExpectedProcessDelay    TIMESTAMP,
	IntroducedAt		VARGRAPHIC(30)	NOT NULL
);

CREATE TABLE QUEUEDATATABLE(
	ProcessInstanceId	VARGRAPHIC(63) 	NOT NULL,
	WorkItemId 		INT 		NOT NULL,
	VAR_INT1 		SMALLINT,
	VAR_INT2 		SMALLINT,
	VAR_INT3 		SMALLINT,
	VAR_INT4 		SMALLINT,
	VAR_INT5 		SMALLINT,
	VAR_INT6 		SMALLINT,
	VAR_INT7 		SMALLINT,
	VAR_INT8 		SMALLINT,
	VAR_FLOAT1		NUMERIC(15, 2),
	VAR_FLOAT2		NUMERIC(15, 2),
	VAR_DATE1		TIMESTAMP,
	VAR_DATE2		TIMESTAMP,
	VAR_DATE3		TIMESTAMP,
	VAR_DATE4		TIMESTAMP,
	VAR_LONG1 		INT,
	VAR_LONG2 		INT,
	VAR_LONG3 		INT,
	VAR_LONG4 		INT,
	VAR_STR1		VARGRAPHIC(255),
	VAR_STR2		VARGRAPHIC(255),
	VAR_STR3		VARGRAPHIC(64),
	VAR_STR4		VARGRAPHIC(64),
	VAR_STR5		VARGRAPHIC(64),
	VAR_STR6		VARGRAPHIC(64),
	VAR_STR7		VARGRAPHIC(32),
	VAR_STR8		VARGRAPHIC(32),
	VAR_REC_1		VARGRAPHIC(16),
	VAR_REC_2		VARGRAPHIC(16),
	VAR_REC_3		VARGRAPHIC(16),
	VAR_REC_4		VARGRAPHIC(16),
	VAR_REC_5		VARGRAPHIC(16),
	InstrumentStatus 	VARGRAPHIC(1), 
	CheckListCompleteFlag 	VARGRAPHIC(1),
	SaveStage		VARGRAPHIC(30),
	HoldStatus 		INT,	
	Status			VARGRAPHIC(255),
	ReferredTo 		INT,
	ReferredToName		VARGRAPHIC(63),
	ReferredBy 		INT,
	ReferredByName		VARGRAPHIC(63),
	ChildProcessInstanceId	VARGRAPHIC(63),
	ChildWorkitemId 	INT,
	ParentWorkItemID 	INT,
	CONSTRAINT PK_QueueDataTABLE PRIMARY KEY(ProcessInstanceID, WorkitemId)
);

CREATE TABLE WORKLISTTABLE(
	ProcessInstanceId	VARGRAPHIC(63)	NOT NULL,
	WorkItemId		INT 		NOT NULL,
	ProcessName 		VARGRAPHIC(30) 	NOT NULL,
	ProcessVersion  	SMALLINT,
	ProcessDefID 		INT 		NOT NULL,
	LastProcessedBy 	INT,
	ProcessedBy		VARGRAPHIC(63),
	ActivityName 		VARGRAPHIC(30),
	ActivityId 		INT,
	EntryDateTime 		TIMESTAMP,
	ParentWorkItemId	INT,	
	AssignmentType		VARGRAPHIC(1),
	CollectFlag		VARGRAPHIC(1),
	PriorityLevel		SMALLINT,
	ValidTill		TIMESTAMP,
	Q_StreamId		INT,
	Q_QueueId		INT,
	Q_UserId		INT,
	AssignedUser		VARGRAPHIC(63),
	FilterValue		INT,
	CreatedDatetime		TIMESTAMP,
	WorkItemState		INT,
	Statename 		VARGRAPHIC(255),
	ExpectedWorkitemDelay	TIMESTAMP,
	PreviousStage		VARGRAPHIC(30),
	LockedByName		VARGRAPHIC(63),	
	LockStatus		VARGRAPHIC(1)  	NOT NULL Default 'N',
	LockedTime		TIMESTAMP, 
	Queuename 		VARGRAPHIC(63),
	Queuetype 		VARGRAPHIC(1),
	NotifyStatus		VARGRAPHIC(1),
	CONSTRAINT PK_WorkListTABLE PRIMARY KEY(ProcessInstanceID, WorkitemId)
);

CREATE TABLE WORKINPROCESSTABLE(
	ProcessInstanceId	VARGRAPHIC(63) NOT NULL,
	WorkItemId		INT 		NOT NULL,
	ProcessName 		VARGRAPHIC(30) 	NOT NULL,
	ProcessVersion   	SMALLINT,
	ProcessDefID 		INT 		NOT NULL,
	LastProcessedBy 	INT,
	ProcessedBy		VARGRAPHIC(63),
	ActivityName 		VARGRAPHIC(30),
	ActivityId 		INT,
	EntryDateTime 		TIMESTAMP,
	ParentWorkItemId	INT,
	AssignmentType		VARGRAPHIC(1),
	CollectFlag		VARGRAPHIC(1),
	PriorityLevel		SMALLINT,
	ValidTill		TIMESTAMP,
	Q_StreamId		INT,
	Q_QueueId		INT,
	Q_UserId		INT,
	AssignedUser		VARGRAPHIC(63),
	FilterValue		INT,
	CreatedDatetime		TIMESTAMP,
	WorkItemState		INT,
	Statename 		VARGRAPHIC(255),
	ExpectedWorkitemDelay	TIMESTAMP,
	PreviousStage		VARGRAPHIC(30),
	LockedByName		VARGRAPHIC(63),	
	LockStatus		VARGRAPHIC(1) Default 'Y' NOT NULL,
	LockedTime		TIMESTAMP,
	Queuename 		VARGRAPHIC(63),
	Queuetype 		VARGRAPHIC(1),
	NotifyStatus		VARGRAPHIC(1),
	Guid 			BIGINT,
	CONSTRAINT PK_WorkInProTAB PRIMARY KEY(ProcessInstanceID, WorkitemId)
);

CREATE TABLE WORKDONETABLE(
	ProcessInstanceId	VARGRAPHIC(63)	NOT NULL,
	WorkItemId		INT 		NOT NULL,
	ProcessName 		VARGRAPHIC(30) 	NOT NULL,
	ProcessVersion   	SMALLINT,
	ProcessDefID 		INT 		NOT NULL,
	LastProcessedBy 	INT,
	ProcessedBy		VARGRAPHIC(63),
	ActivityName 		VARGRAPHIC(30),
	ActivityId 		INT,
	EntryDateTime 		TIMESTAMP,
	ParentWorkItemId	INT,	
	AssignmentType		VARGRAPHIC(1),
	CollectFlag		VARGRAPHIC(1),
	PriorityLevel		SMALLINT,
	ValidTill		TIMESTAMP,
	Q_StreamId		INT,
	Q_QueueId		INT,
	Q_UserId		INT,
	AssignedUser		VARGRAPHIC(63),
	FilterValue		INT,
	CreatedDatetime		TIMESTAMP,
	WorkItemState		INT,
	Statename 		VARGRAPHIC(255),
	ExpectedWorkitemDelay	TIMESTAMP,
	PreviousStage		VARGRAPHIC(30),
	LockedByName		VARGRAPHIC(63),	
	LockStatus		VARGRAPHIC(1)  NOT NULL Default 'N',
	LockedTime		TIMESTAMP, 
	Queuename 		VARGRAPHIC(63),
	Queuetype 		VARGRAPHIC(1),
	NotifyStatus		VARGRAPHIC(1),
	CONSTRAINT PK_WorkDoneTABLE PRIMARY KEY(ProcessInstanceID, WorkitemId)
);

CREATE TABLE WORKWITHPSTABLE(
	ProcessInstanceId	VARGRAPHIC(63)	NOT NULL,
	WorkItemId		INT 		NOT NULL,
	ProcessName 		VARGRAPHIC(30) 	NOT NULL,
	ProcessVersion   	SMALLINT,
	ProcessDefID 		INT 		NOT NULL,
	LastProcessedBy 	INT,
	ProcessedBy		VARGRAPHIC(63),
	ActivityName 		VARGRAPHIC(30),
	ActivityId 		INT,
	EntryDateTime 		TIMESTAMP,
	ParentWorkItemId	INT,	
	AssignmentType		VARGRAPHIC(1),
	CollectFlag		VARGRAPHIC(1),
	PriorityLevel		SMALLINT,
	ValidTill		TIMESTAMP,
	Q_StreamId		INT,
	Q_QueueId		INT,
	Q_UserId		INT,
	AssignedUser		VARGRAPHIC(63),
	FilterValue		INT,
	CreatedDatetime		TIMESTAMP,
	WorkItemState		INT,
	Statename 		VARGRAPHIC(255),
	ExpectedWorkitemDelay	TIMESTAMP,
	PreviousStage		VARGRAPHIC(30),
	LockedByName		VARGRAPHIC(63),	
	LockStatus		VARGRAPHIC(1) 	NOT NULL Default 'Y',
	LockedTime		TIMESTAMP,
	Queuename 		VARGRAPHIC(63),
	Queuetype 		VARGRAPHIC(1),
	NotifyStatus		VARGRAPHIC(1),
	Guid 			bigINT,
	CONSTRAINT PK_WorkwithPSTABLE PRIMARY KEY(ProcessInstanceID, WorkitemId)
);

CREATE TABLE PENDINGWORKLISTTABLE(
	ProcessInstanceId	VARGRAPHIC(63) NOT NULL,
	WorkItemId		INT 		NOT NULL,
	ProcessName 		VARGRAPHIC(30) 	NOT NULL,
	ProcessVersion   	SMALLINT,
	ProcessDefID 		INT 		NOT NULL,
	LastProcessedBy 	INT,
	ProcessedBy		VARGRAPHIC(63),
	ActivityName 		VARGRAPHIC(30),
	ActivityId 		INT,
	EntryDateTime 		TIMESTAMP,
	ParentWorkItemId	INT,	
	AssignmentType		VARGRAPHIC(1),
	CollectFlag		VARGRAPHIC(1),
	PriorityLevel		SMALLINT,
	ValidTill		TIMESTAMP,
	Q_StreamId		INT,
	Q_QueueId		INT,
	Q_UserId		INT,
	AssignedUser		VARGRAPHIC(63),
	FilterValue		INT,
	CreatedDatetime		TIMESTAMP,
	WorkItemState		INT,
	Statename 		VARGRAPHIC(255),
	ExpectedWorkitemDelay	TIMESTAMP,
	PreviousStage		VARGRAPHIC(30),
	LockedByName		VARGRAPHIC(63),	
	LockStatus		VARGRAPHIC(1),
	LockedTime		TIMESTAMP, 
	Queuename 		VARGRAPHIC(63),
	Queuetype 		VARGRAPHIC(1),
	NotifyStatus		VARGRAPHIC(1),
	CONSTRAINT PK_PenWorklistTAB PRIMARY KEY(ProcessInstanceID, WorkitemId)
);

CREATE TABLE USERQUEUETABLE(
	UserID 			INT	NOT NULL,
	QueueID 		INT 		NOT NULL,
	ConstraINT PK_UQTbl PRIMARY KEY(UserID, QueueID)	
);

CREATE TABLE WFMAILQUEUETABLE(
	TaskId 			INTEGER		generated always as identity(start with 1, increment by 1) NOT NULL PRIMARY KEY,
	mailFrom 		VARGRAPHIC(128),
	mailTo 			VARGRAPHIC(128), 
	mailCC 			VARGRAPHIC(128), 
	mailSubject 		VARGRAPHIC(256),
	mailMessage		CLOB,
	mailContentType		VARGRAPHIC(64),
	attachmentISINDEX 	VARGRAPHIC(255),
	attachmentNames		VARGRAPHIC(256), 
	attachmentExts		VARGRAPHIC(128),	
	mailPriority		INTEGER, 
	mailStatus		VARGRAPHIC(1),
	statusComments		VARGRAPHIC(128),
	lockedBy		VARGRAPHIC(128),
	successTime		TIMESTAMP,
	LastLockTime		TIMESTAMP,
	insertedBy		VARGRAPHIC(128),
	mailActionType		VARGRAPHIC(20),
	insertedTime		TIMESTAMP,
	processDefId		INTEGER,
	processInstanceId	VARGRAPHIC(63),
	workitemId		INTEGER,
	activityId		INTEGER,
	noOfTrials		INTEGER	default 0
);

CREATE TABLE WFMAILQUEUEHISTORYTABLE(
	TaskId 			INTEGER		NOT NULL PRIMARY KEY,
	mailFrom 		VARGRAPHIC(128),
	mailTo 			VARGRAPHIC(128), 
	mailCC 			VARGRAPHIC(128), 
	mailSubject 		VARGRAPHIC(256),
	mailMessage		CLOB,
	mailContentType		VARGRAPHIC(64),
	attachmentISINDEX 	VARGRAPHIC(255), 
	attachmentNames		VARGRAPHIC(256), 
	attachmentExts		VARGRAPHIC(128),	
	mailPriority		INTEGER, 
	mailStatus		VARGRAPHIC(1),
	statusComments		VARGRAPHIC(128),
	lockedBy		VARGRAPHIC(128),
	successTime		TIMESTAMP,
	LastLockTime		TIMESTAMP,
	insertedBy		VARGRAPHIC(128),
	mailActionType		VARGRAPHIC(20),
	insertedTime		TIMESTAMP,
	processDefId		INTEGER,
	processInstanceId	VARGRAPHIC(63),
	workitemId		INTEGER,
	activityId		INTEGER,
	noOfTrials		INTEGER	default 0
);

CREATE TABLE ACTIONDEFTABLE(
	ProcessDefId            INT             NOT NULL,
	ActionId                INT             NOT NULL,
	ActionName              VARGRAPHIC(50)  NOT NULL,
	ViewAS                  VARGRAPHIC(50),
	IconBuffer              BLOB,
	ActivityId              INT             NOT NULL 
);

CREATE TABLE ACTIONCONDITIONTABLE(
	ProcessDefId            INT		NOT NULL,
	ActivityId              INT		NOT NULL,
	RuleType		VARGRAPHIC(1)	NOT NULL,
	RuleOrderId		INT		NOT NULL,
	RuleId			INT		NOT NULL,
	ConditionOrderId	INT		NOT NULL,
	Param1			VARGRAPHIC(50)	NOT NULL,
	Type1			VARGRAPHIC(1)	NOT NULL,
	ExtObjID1		INT,
	Param2			VARGRAPHIC(255) NOT NULL,
	Type2			VARGRAPHIC(1)   NOT NULL,
	ExtObjID2		INT,
	Operator		INT             NOT NULL,
	LogicalOp		INT             NOT NULL
);

CREATE TABLE ACTIONOPERATIONTABLE(
	ProcessDefId		INT		NOT NULL,
	ActivityId		INT		NOT NULL,
	RuleType		VARGRAPHIC(1)   NOT NULL,
	RuleId			INT             NOT NULL,
	OperationType		INT             NOT NULL,
	Param1			VARGRAPHIC(50),
	Type1			VARGRAPHIC(1)   NOT NULL,
	Param2			VARGRAPHIC(255),
	Type2			VARGRAPHIC(1)   NOT NULL,
	Param3			VARGRAPHIC(255),
	Type3			VARGRAPHIC(1),
	Operator		INT,
	OperationOrderId	INT             NOT NULL,
	CommentFlag		VARGRAPHIC(1)   NOT NULL,
	ExtObjID1		INT,
	ExtObjID2		INT,
	ExtObjID3		INT,
	RuleCalFlag		VARGRAPHIC(1)	
);

CREATE TABLE ACTIVITYINTERFACEASSOCTABLE(
	ProcessDefId            INT		NOT NULL,
	ActivityId              INT             NOT NULL,
	ActivityName            VARGRAPHIC(30)  NOT NULL,
	InterfaceElementId      INT             NOT NULL,
	InterfaceType           VARGRAPHIC(1)   NOT NULL,
	Attribute               VARGRAPHIC(2),
	TriggerName             VARGRAPHIC(255)   
);

CREATE TABLE ARCHIVETABLE(
	ProcessDefId            INTEGER         NOT NULL,
	ActivityID              INTEGER         NOT NULL,
	CabinetName             VARGRAPHIC(255) NOT NULL,
	IPAddress               VARGRAPHIC(15)	NOT NULL,
	PortId                  VARGRAPHIC(4)   NOT NULL,
	ArchiveAs               VARGRAPHIC(255) NOT NULL,
	UserId                  VARGRAPHIC(50)  NOT NULL,
	Passwd                  VARGRAPHIC(50),
	ArchiveDataClassId      INTEGER,
	AppServerIP				VARGRAPHIC(15),
	AppServerPort			VARGRAPHIC(4),
	AppServerType			VARGRAPHIC(255)
);

CREATE TABLE ARCHIVEDATAMAPTABLE(
	ProcessDefId            INTEGER		NOT NULL,
	ArchiveID               INTEGER		NOT NULL,
	DocTypeID               INTEGER		NOT NULL,
	DataFieldId             INTEGER		NOT NULL,
	DataFieldName           VARGRAPHIC(50)	NOT NULL,
	AssocVar                VARGRAPHIC(255),
	ExtObjID                INTEGER
);

CREATE TABLE ARCHIVEDOCTYPETABLE(
	ProcessDefId            INTEGER		NOT NULL,
	ArchiveID               INTEGER		NOT NULL,
	DocTypeID               INTEGER		NOT NULL,
	AssocClassName          VARGRAPHIC(255),
	AssocClassID            INTEGER	
);

CREATE TABLE SCANACTIONSTABLE(
	ProcessDefId		INT             NOT NULL,
	DocTypeId		INT             NOT NULL,
	ActivityId		INT             NOT NULL,
	Param1			VARGRAPHIC(50)  NOT NULL,
	Type1			VARGRAPHIC(1)   NOT NULL,
	ExtObjId1		INT             NOT NULL,
	Param2			VARGRAPHIC(255) NOT NULL,
	Type2			VARGRAPHIC(1)   NOT NULL,
	ExtObjId2		INT             NOT NULL
);

CREATE TABLE CHECKOUTPROCESSESTABLE( 
	ProcessDefId            INTEGER		NOT NULL,
	ProcessName             VARGRAPHIC(30)	NOT NULL, 
	CheckOutIPAddress       VARCHAR(50)	NOT NULL, 
	CheckOutPath            VARGRAPHIC(255) NOT NULL
);

CREATE TABLE TODOLISTDEFTABLE(
	ProcessDefId		INTEGER		NOT NULL,
	ToDoId			INTEGER		NOT NULL,
	ToDoName		VARGRAPHIC(255)	NOT NULL,
	Description		VARGRAPHIC(255)	NOT NULL,
	Mandatory		VARGRAPHIC(1)	NOT NULL,
	ViewType		VARGRAPHIC(1),
	AssociatedField		VARGRAPHIC(255),
	ExtObjID		INTEGER,
	TriggerName		VARGRAPHIC(50)
);

CREATE TABLE TODOPICKLISTTABLE(
	ProcessDefId		INTEGER		NOT NULL,
	ToDoId			INTEGER		NOT NULL,
	PickListValue		VARGRAPHIC(50)	NOT NULL
);

CREATE TABLE TODOSTATUSTABLE(
	ProcessDefId		INTEGER         NOT NULL,
	ProcessInstanceId	VARGRAPHIC(63)  NOT NULL,
	ToDoValue		VARGRAPHIC(255)    
);

CREATE TABLE TODOSTATUSHISTORYTABLE(
	ProcessDefId		INTEGER         NOT NULL,
	ProcessInstanceId	VARGRAPHIC(63)  NOT NULL,
	ToDoValue		VARGRAPHIC(255)  
);

CREATE TABLE EXCEPTIONDEFTABLE(
	ProcessDefId            INT		NOT NULL,
	ExceptionId             INT             NOT NULL,
	ExceptionName           VARGRAPHIC(50)  NOT NULL,
	Description             VARGRAPHIC(255) NOT NULL
);

CREATE TABLE EXCEPTIONTABLE(
	ProcessDefId            INTEGER         NOT NULL,
	ExcpSeqId               INTEGER         NOT NULL,
	WorkitemId              INTEGER         NOT NULL,
	Activityid              INTEGER         NOT NULL,
	ActivityName            VARGRAPHIC(30)  NOT NULL,
	ProcessInstanceId       VARGRAPHIC(63)  NOT NULL,
	UserId                  INT        NOT NULL,
	UserName                VARGRAPHIC(63)  NOT NULL,
	ActionId                INTEGER         NOT NULL,
	ActionDatetime          TIMESTAMP       NOT NULL DEFAULT CURRENT TIMESTAMP,
	ExceptionId             INTEGER         NOT NULL,
	ExceptionName           VARGRAPHIC(50)  NOT NULL,
	FinalizationStatus      VARGRAPHIC(1)   NOT NULL DEFAULT 'T',
	ExceptionComments       VARGRAPHIC(255)  
);

CREATE TABLE EXCEPTIONHISTORYTABLE(
	ProcessDefId            INTEGER         NOT NULL,
	ExcpSeqId               INTEGER         NOT NULL,
	WorkitemId              INTEGER         NOT NULL,
	Activityid              INTEGER         NOT NULL,
	ActivityName		VARGRAPHIC(30)	NOT NULL,
	ProcessInstanceId       VARGRAPHIC(63)  NOT NULL,
	UserId                  INT        NOT NULL,
	UserName                VARGRAPHIC(63)  NOT NULL,
	ActionId                INTEGER         NOT NULL,
	ActionDatetime          TIMESTAMP       NOT NULL DEFAULT CURRENT TIMESTAMP,
	ExceptionId             INTEGER         NOT NULL,
	ExceptionName           VARGRAPHIC(50)  NOT NULL,
	FinalizationStatus      VARGRAPHIC(1)   NOT NULL DEFAULT 'T',
	ExceptionComments       VARGRAPHIC(255)  
);

CREATE TABLE DOCUMENTTYPEDEFTABLE(
	ProcessDefId		INT		NOT NULL,
	DocId			INT		NOT NULL,
	DocName			VARGRAPHIC(50)  NOT NULL
);

CREATE TABLE PROCESSINITABLE(
	ProcessDefId		INT		NOT NULL,
	ProcessINI		BLOB
);

CREATE TABLE ROUTEFOLDERDEFTABLE(
	ProcessDefId            INTEGER         NOT NULL PRIMARY KEY,
	CabinetName             VARGRAPHIC(50)  NOT NULL,
	RouteFolderId           INTEGER         NOT NULL,
	ScratchFolderId         INTEGER         NOT NULL,
	WorkFlowFolderId        INTEGER         NOT NULL,
	CompletedFolderId       INTEGER         NOT NULL,
	DiscardFolderId         INTEGER         NOT NULL 
);

CREATE TABLE PRINTFAXEMAILTABLE(
	ProcessDefId            INT		NOT NULL,
	PFEInterfaceId          INT		NOT NULL,
	InstrumentData          VARGRAPHIC(1),
	FitToPage               VARGRAPHIC(1),
	Annotations             VARGRAPHIC(1),
	FaxNo                   VARGRAPHIC(128),
	FaxNoType               VARGRAPHIC(1),
	ExtFaxNoId              INT,
	CoverSheet              VARGRAPHIC(50),
	CoverSheetBuffer        BLOB,
	ToUser                  VARGRAPHIC(128),
	FromUser                VARGRAPHIC(128),
	ToMailId                VARGRAPHIC(128),
	ToMailIdType            VARGRAPHIC(1),
	ExtToMailId             INT,
	CCMailId                VARGRAPHIC(128),
	CCMailIdType            VARGRAPHIC(1),
	ExtCCMailId             INT,
	SenderMailId            VARGRAPHIC(128),
	SenderMailIdType        VARGRAPHIC(1),
	ExtSenderMailId         INT,
	Message                 CLOB,
	Subject                 VARGRAPHIC(255)	
);

CREATE TABLE PRINTFAXEMAILDOCTYPETABLE(
	ProcessDefId		INT		NOT NULL,
	ElementId		INT             NOT NULL,
	PFEType			VARGRAPHIC(1)   NOT NULL,
	DocTypeId		INT             NOT NULL,
	CreateDoc		VARGRAPHIC(1)   NOT NULL
);

CREATE TABLE WFFORM_TABLE(
	ProcessDefId            INT             NOT NULL,
	FormId                  INT             NOT NULL,
	FormName                VARGRAPHIC(50)  NOT NULL,
	FormBuffer              BLOB
);

CREATE TABLE SUMMARYTABLE(
	processdefid		INT,
	activityid		INT,
	activityname		VARGRAPHIC(30),
	queueid			INT,
	userid			INT,
	username		VARGRAPHIC(255),
	totalwicount		INT,
	ActionDatetime		TIMESTAMP,
	actionid		INT,
	totalduration		INT,
	reporttype		VARGRAPHIC(1),
	totalprocessingtime	INT,
	delaytime		INT,
	wkindelay		INT,
	ASsociatedFieldId	INT,
	ASsociatedFieldName	VARGRAPHIC(1500)
);

CREATE TABLE WFMESSAGETABLE(
	messageId 		INT	generated always as identity(start with 1, increment by 1) NOT NULL PRIMARY KEY,
	message			CLOB 		NOT NULL, 
	lockedBy		VARGRAPHIC(63), 
	status 			VARGRAPHIC(1) CHECK(status in('N', 'F')),
	ActionDateTime	TIMESTAMP	
);

CREATE TABLE CONSTANTDEFTABLE(
	ProcessDefId		INTEGER		NOT NULL,	
	ConstantName		VARGRAPHIC(64)	NOT NULL,
	ConstantValue		VARGRAPHIC(255),
	LastModifiedOn		TIMESTAMP	NOT NULL,
	PRIMARY KEY(ProcessDefId, ConstantName)
);

CREATE TABLE EXTMETHODDEFTABLE(
	ProcessDefId		INTEGER		NOT NULL,
	ExtMethodIndex		INTEGER		NOT NULL,	
	ExtAppName		VARGRAPHIC(64)	NOT NULL, 
	ExtAppType		VARGRAPHIC(1)	NOT NULL CHECK(ExtAppType in('E','W')),
	ExtMethodName		VARGRAPHIC(64)	NOT NULL,
	SearchMethod		VARGRAPHIC(255),
	SearchCriteria		VARGRAPHIC(1500),
	ReturnType		SMALLINT	CHECK(ReturnType in(0, 3, 4, 6, 8, 10, 11)),
	PRIMARY KEY(ProcessDefId, ExtMethodIndex)
);

CREATE TABLE EXTMETHODPARAMDEFTABLE(
	ProcessDefId		INTEGER		NOT NULL, 
	ExtMethodParamIndex	INTEGER		NOT NULL,
	ExtMethodIndex		INTEGER		NOT NULL,
	ParameterName		VARGRAPHIC(64),
	ParameterType		SMALLINT	CHECK(ParameterType in(0, 3, 4, 6, 8, 10, 11)),
	ParameterOrder		SMALLINT,
	DataStructureId		INTEGER,
	PRIMARY KEY(ProcessDefId, ExtMethodIndex, ExtMethodParamIndex)
);

CREATE TABLE EXTMETHODPARAMMAPPINGTABLE(
	ProcessDefId		INTEGER		NOT NULL, 
	ActivityId		INTEGER		NOT NULL,
	RuleId			INTEGER		NOT NULL,
	RuleOperationOrderId	SMALLINT	NOT NULL,
	ExtMethodIndex		INTEGER		NOT NULL,
	MapType			VARGRAPHIC(1)	CHECK(MapType in('F', 'R')),
	ExtMethodParamIndex	INTEGER		NOT NULL,
	MappedField		VARGRAPHIC(255),
	MappedFieldType		VARGRAPHIC(1)	CHECK(MappedFieldType in('Q', 'F', 'C', 'S', 'I', 'M', 'U')),
	DataStructureId		INTEGER
);

Create Table WFMessageInProcessTable(
	messageId		INT, 
	message			CLOB, 
	lockedBy		VARGRAPHIC(63), 
	status			VARGRAPHIC(1) ,
	ActionDateTime	TIMESTAMP

);

Create Table WFFailedMessageTable(
	messageId		INT,
	message			CLOB,
	lockedBy		VARGRAPHIC(63),
	status			VARGRAPHIC(1),
	failureTime		TIMESTAMP,
	ActionDateTime	TIMESTAMP
);

Create Table WFEscalationTable(
	EscalationId		Int	generated always as identity(start with 1, increment by 1) NOT NULL PRIMARY KEY,
	ProcessInstanceId	VARGRAPHIC(64),
	WorkitemId		Int,
	ProcessDefId		Int,
	ActivityId		Int,
	EscalationMode		VARGRAPHIC(20)	NOT NULL,
	ConcernedAuthInfo	VARGRAPHIC(256)	NOT NULL,
	Comments		VARGRAPHIC(512)	NOT NULL,
	Message			CLOB		NOT NULL,
	ScheduleTime		TIMESTAMP	NOT NULL
);

Create Table WFEscInProcessTable(
	EscalationId		Int		NOT NULL Primary Key,
	ProcessInstanceId	VARGRAPHIC(64),
	WorkitemId		Int,
	ProcessDefId		Int,
	ActivityId		Int,
	EscalationMode		VARGRAPHIC(20)	NOT NULL,
	ConcernedAuthInfo	VARGRAPHIC(256)	NOT NULL,
	Comments		VARGRAPHIC(512)	NOT NULL,
	Message			CLOB		NOT NULL,
	ScheduleTime		TIMESTAMP	NOT NULL
);

CREATE TABLE WFJMSMESSAGETABLE(
	messageId		INT		generated always as identity(start with 1, increment by 1) NOT NULL PRIMARY KEY,
	message			CLOB		NOT NULL, 
	destination		VARGRAPHIC(256),
	entryDateTime		TIMESTAMP,
	OperationType		VARGRAPHIC(1)	
);

Create Table WFJMSMessageInProcessTable(
	messageId		INT, 
	message			CLOB, 
	destination		VARGRAPHIC(256), 
	lockedBy		VARGRAPHIC(63), 
	entryDateTime		TIMESTAMP, 
	lockedTime		TIMESTAMP,
	OperationType		VARGRAPHIC(1)
);

Create Table WFJMSFailedMessageTable(
	messageId		INT,
	message			CLOB,
	destination		VARGRAPHIC(256), 
	entryDateTime		TIMESTAMP, 
	failureTime		TIMESTAMP,
	failureCause		VARGRAPHIC(1500),
	OperationType		VARGRAPHIC(1)
);

CREATE TABLE WFJMSDestInfo(
	destinationId		INT		NOT NULL PRIMARY KEY,
	appServerIP		VARGRAPHIC(16),
	appServerPort		INT,
	appServerType		VARGRAPHIC(16),
	jmsDestName		VARGRAPHIC(256) NOT NULL,
	jmsDestType		VARGRAPHIC(1)	NOT NULL
);

CREATE TABLE WFJMSPublishTable(
	processDefId		INT,
	activityId		INT,
	destinationId		INT,
	Template		CLOB
);

CREATE TABLE WFJMSSubscribeTable(
	processDefId		INT,
	activityId		INT,
	destinationId		INT,
	extParamName		VARGRAPHIC(256),
	processVariableName	VARGRAPHIC(256),
	variableProperty	VARGRAPHIC(1)
);

CREATE TABLE WFDataStructureTable(
	DataStructureId		Int		NOT NULL,
	ProcessDefId		Int		NOT NULL,
	ActivityId		Int,
	ExtMethodIndex		Int,
	Name			VARGRAPHIC(256),
	Type			SmallInt,
	ParentIndex		Int,
	PRIMARY KEY(DataStructureId, ProcessDefId)
);

CREATE TABLE WFWebServiceTable(
	ProcessDefId		Int		NOT NULL,
	ActivityId		Int		NOT NULL,
	ExtMethodIndex		Int,
	ProxyEnabled		VARGRAPHIC(1),
	TimeOutInterval		Int,
	InvocationType		VARGRAPHIC(1),
	PRIMARY KEY(ProcessDefId, ActivityId)
);

CREATE TABLE WFVarStatusTable(
	ProcessDefId		int		NOT NULL,
	VarName			VARGRAPHIC(50)	NOT NULL,
	Status			VARGRAPHIC(1)	NOT NULL DEFAULT 'Y' CHECK(Status = 'Y' OR Status = 'N')
);

CREATE TABLE WFActionStatusTable(
	ActionId		int		NOT NULL PRIMARY KEY,
	Type			VARGRAPHIC(1)	NOT NULL DEFAULT 'C' CHECK(Type = 'C' OR Type = 'S'),
	Status			VARGRAPHIC(1)	NOT NULL DEFAULT 'Y' CHECK(Status = 'Y' OR Status = 'N')
);

CREATE TABLE SuccessLogTable(
	LogId INT,
	ProcessINstanceId VARGRAPHIC(4000)
);

CREATE TABLE FailureLogTable(
	LogId INT,
	ProcessINstanceId VARGRAPHIC(4000)
);

CREATE TABLE WFCalDefTable(
	ProcessDefId	Int		NOT NULL,
	CalId		Int		NOT NULL,
	CalName		VARGRAPHIC(256)	NOT NULL,
	GMTDiff		Int,
	LastModifiedOn	TIMESTAMP,
	Comments	VARGRAPHIC(1024),
	PRIMARY KEY	(ProcessDefId, CalId)
);

Insert into WFCalDefTable values(0, 1, 'DEFAULT 24/7', 530, current timestamp, 'This is the default calendar');

CREATE TABLE WFCalRuleDefTable(
	ProcessDefId	Int		NOT NULL,
	CalId		Int		NOT NULL,
	CalRuleId	Int		NOT NULL,
	Def		VARGRAPHIC(256),
	CalDate		TIMESTAMP,
	Occurrence	SmallInt,
	WorkingMode	VARGRAPHIC(1),
	DayOfWeek	SmallInt,
	WEF		TIMESTAMP,
	PRIMARY KEY	(ProcessDefId, CalId, CalRuleId)
);

CREATE TABLE WFCalHourDefTable(
	ProcessDefId	Int		NOT NULL,
	CalId		Int		NOT NULL,
	CalRuleId	Int		NOT NULL,
	RangeId		Int		NOT NULL,
	StartTime	Int,
	EndTime		Int,
	PRIMARY KEY (ProcessDefId, CalId, CalRuleId, RangeId)
);

Insert into WFCalHourDefTable values (0, 1, 0, 1, 0000, 2400);

CREATE TABLE WFCalendarAssocTable(
	CalId		Int		NOT NULL,
	ProcessDefId	Int		NOT NULL,
	ActivityId	Int		NOT NULL,
	CalType		VARGRAPHIC(1)	NOT NULL,
	UNIQUE (ProcessDefId, ActivityId)
);

CREATE TABLE TemplateMultiLanguageTable (
	ProcessDefId	INT				NOT NULL,
	TemplateId		INT				NOT NULL,
	Locale			GRAPHIC(5)		NOT NULL,
	TemplateBuffer	BLOB			NULL
);

CREATE TABLE InterfaceDescLanguageTable (
	ProcessDefId	INT			NOT NULL,		
	ElementId		INT			NOT NULL,
	InterfaceID		INT			NOT NULL,
	Locale			GRAPHIC(5)	NOT NULL,
	Description		VARGRAPHIC(255)	NOT NULL
);

CREATE TABLE WFACTIVITYREPORTTABLE(
	ProcessDefId         INT,
	ActivityId           INT,
	ActivityName         VARGRAPHIC(30),
	ActionDatetime       TIMESTAMP,
	TotalWICount         INT,
	TotalDuration        INT,
	TotalProcessingTime  INT
);


CREATE TABLE WFREPORTDATATABLE(
	ProcessInstanceId    VARGRAPHIC(63),
	WorkitemId           INT,
	ProcessDefId         INT NOT NULL,
	ActivityId           INT,
	UserId               INT,
	TotalProcessingTime  INT
);

CREATE TABLE WFParamMappingBuffer(
	processDefId    INT,
	extMethodId     INT,
	paramMappingBuffer      CLOB
	UNIQUE(processdefid, extmethodid)
);

CREATE TABLE WFRoutingServerInfo( 
	InfoId			INT		GENERATED ALWAYS AS IDENTITY(START WITH 1, INCREMENT BY 1) NOT NULL, 
	DmsUserIndex		INT		NULL, 
	DmsUserName		VARGRAPHIC(64)	NULL, 
	DmsUserPassword		VARGRAPHIC(255)	NULL, 
	DmsSessionId		INT		NULL, 
	Data			VARGRAPHIC(128)	NULL 
);

CREATE VIEW EXCEPTIONVIEW 
AS
	SELECT * FROM EXCEPTIONTABLE 
	UNION ALL 
	SELECT * FROM EXCEPTIONHISTORYTABLE;

CREATE VIEW TODOSTATUSVIEW 
AS 
	SELECT * FROM TODOSTATUSTABLE 
	UNION ALL 
	SELECT * FROM TODOSTATUSHISTORYTABLE;

CREATE VIEW ROUTELOGTABLE 
AS 
	SELECT * FROM CURRENTROUTELOGTABLE
	UNION ALL
	SELECT * FROM HISTORYROUTELOGTABLE;

CREATE VIEW WFGROUPMEMBERVIEW 
AS 
	SELECT * FROM PDBGROUPMEMBER;

CREATE VIEW QUSERGROUPVIEW 
AS 
	SELECT queueid, userid, cast(NULL AS INT) groupid, AssignedtillDateTime, queryFilter 
	FROM QUEUEUSERTABLE 
	WHERE ASsociationtype = 0 
	AND (AssignedtillDateTime is NULL 
	or AssignedtillDateTime >= current timestamp) 
	UNION ALL
	SELECT queueid, userindex userid, userid AS groupid, cast(NULL AS TIMESTAMP) as AssignedtillDateTime, queryFilter 
	FROM QUEUEUSERTABLE, WFGROUPMEMBERVIEW 
	WHERE ASsociationtype = 1 
	AND QUEUEUSERTABLE.userid = WFGROUPMEMBERVIEW.groupindex;

CREATE VIEW WFWORKLISTVIEW_0 
AS 
	SELECT WORKLISTTABLE.ProcessInstanceId, WORKLISTTABLE.ProcessInstanceId AS ProcessInstanceName, 				WORKLISTTABLE.ProcessDefId,  ProcessName, ActivityId, ActivityName, PriorityLevel, InstrumentStatus, LockStatus, 
		LockedByName, ValidTill, CreatedByName, PROCESSINSTANCETABLE.CreatedDatetime, Statename, 
		CheckListCompleteFlag,  EntryDATETIME, LockedTime, IntroductionDateTime, Introducedby, 
		AssignedUser, WORKLISTTABLE.WorkItemId,  QueueName, AssignmentType, ProcessInstanceState, 
		QueueType, Status, Q_QueueID,  TIMESTAMPDIFF(8, CHAR(ExpectedWorkItemDelay - EntryDateTime) ) AS TurnaroundTime, 
		ReferredByname, cast(NULL AS INT) ReferTo, Q_UserID, FILTERVALUE, Q_StreamId, CollectFlag, 
		WORKLISTTABLE.ParentWorkItemId, ProcessedBy, LastProcessedBy, ProcessVersion, WorkItemState, 
		PREVIOUSSTAGE, ExpectedWorkitemDelay, VAR_INT1, VAR_INT2, VAR_INT3, VAR_INT4, VAR_INT5, VAR_INT6, 
		VAR_INT7, VAR_INT8, VAR_LONG1, VAR_LONG2, VAR_LONG3, VAR_LONG4  
	 FROM	WORKLISTTABLE, PROCESSINSTANCETABLE, QUEUEDATATABLE 
	 WHERE	WORKLISTTABLE.ProcessInstanceid = QUEUEDATATABLE.ProcessInstanceId 
	 AND	WORKLISTTABLE.Workitemid =QUEUEDATATABLE.Workitemid 
	 AND	WORKLISTTABLE.ProcessInstanceId = PROCESSINSTANCETABLE.ProcessInstanceId  
	 UNION ALL
	 SELECT PENDINGWORKLISTTABLE.ProcessInstanceId, PENDINGWORKLISTTABLE.ProcessInstanceId AS ProcessInstanceName, 
		PENDINGWORKLISTTABLE.ProcessDefId, ProcessName, ActivityId, ActivityName, PriorityLevel, InstrumentStatus, 
		LockStatus, LockedByName, ValidTill, CreatedByName, PROCESSINSTANCETABLE.CreatedDatetime, Statename, 
		CheckListCompleteFlag, EntryDATETIME, LockedTime, IntroductionDateTime, Introducedby, AssignedUser, 
		PENDINGWORKLISTTABLE.WorkItemId, QueueName, AssignmentType, ProcessInstanceState, QueueType, Status, 
		Q_QueueID, TIMESTAMPDIFF(8, CHAR(ExpectedWorkItemDelay - entryDATETIME)) AS TurnaroundTime, ReferredByname,  
		ReferredTo AS ReferTo, Q_UserID, FILTERVALUE, Q_StreamId, CollectFlag, PENDINGWORKLISTTABLE.ParentWorkItemId, 
		ProcessedBy, LastProcessedBy, ProcessVersion, WorkItemState, PREVIOUSSTAGE, ExpectedWorkitemDelay, 
		VAR_INT1, VAR_INT2, VAR_INT3, VAR_INT4, VAR_INT5, VAR_INT6, VAR_INT7, VAR_INT8, VAR_LONG1, VAR_LONG2, 
		VAR_LONG3, VAR_LONG4 
	 FROM	PENDINGWORKLISTTABLE, PROCESSINSTANCETABLE, QUEUEDATATABLE  
	 WHERE	PENDINGWORKLISTTABLE.ProcessInstanceid = QUEUEDATATABLE.ProcessInstanceId  
	 AND	PENDINGWORKLISTTABLE.Workitemid = QUEUEDATATABLE.Workitemid 
	 AND	PENDINGWORKLISTTABLE.ProcessInstanceId = PROCESSINSTANCETABLE.ProcessInstanceId  
	 UNION ALL 
	 SELECT WORKINPROCESSTABLE.ProcessInstanceId, WORKINPROCESSTABLE.ProcessInstanceId AS ProcessInstanceName, 
		WORKINPROCESSTABLE.ProcessDefId, ProcessName, ActivityId, ActivityName, PriorityLevel, InstrumentStatus, 
		LockStatus, LockedByName, ValidTill, CreatedByName, PROCESSINSTANCETABLE.CreatedDatetime, Statename, 
		CheckListCompleteFlag, EntryDATETIME, LockedTime, IntroductionDateTime, Introducedby, AssignedUser, 
		WORKINPROCESSTABLE.WorkItemId, QueueName, AssignmentType, ProcessInstanceState,QueueType, Status, 
		Q_QueueID, TIMESTAMPDIFF(8, CHAR(ExpectedWorkItemDelay - entryDATETIME)) AS TurnaroundTime, ReferredByname, 
		cast(NULL AS INT) ReferTo, Q_UserID, FILTERVALUE, Q_StreamId, CollectFlag, WORKINPROCESSTABLE.ParentWorkItemId, 
		ProcessedBy, LastProcessedBy, ProcessVersion, WorkItemState, PREVIOUSSTAGE, ExpectedWorkitemDelay, 
		VAR_INT1, VAR_INT2, VAR_INT3, VAR_INT4, VAR_INT5, VAR_INT6, VAR_INT7, VAR_INT8, VAR_LONG1, VAR_LONG2, 
		VAR_LONG3, VAR_LONG4 
	FROM	WORKINPROCESSTABLE, PROCESSINSTANCETABLE, QUEUEDATATABLE 
	WHERE	WORKINPROCESSTABLE.ProcessInstanceid = QUEUEDATATABLE.ProcessInstanceId 
	AND	WORKINPROCESSTABLE.Workitemid = QUEUEDATATABLE.Workitemid 
	AND	WORKINPROCESSTABLE.ProcessInstanceId = PROCESSINSTANCETABLE.ProcessInstanceId;

CREATE VIEW QUEUETABLE 
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
		referredtoname, referredby, referredbyname, collectflag, cast(NULL AS TIMESTAMP) AS CompletionDatetime
	FROM	QUEUEDATATABLE, 
		PROCESSINSTANCETABLE,
		(SELECT processinstanceid, workitemid, processname, processversion,
			processdefid, LastProcessedBy, processedby, activityname, activityid,
			entryDATETIME, parentworkitemid, AssignmentType,
			collectflag, prioritylevel, validtill, q_streamid,
			q_queueid, q_userid, AssignedUser, CreatedDatetime,
			workitemstate, expectedworkitemdelay, previousstage,
			lockedbyname, lockstatus, lockedtime, queuename, queuetype,
			statename
		FROM WORKLISTTABLE
		UNION ALL
		SELECT processinstanceid, workitemid, processname, processversion,
			processdefid, LastProcessedBy, processedby, activityname, activityid,
			entryDATETIME, parentworkitemid, AssignmentType,
			collectflag, prioritylevel, validtill, q_streamid,
			q_queueid, q_userid, AssignedUser, CreatedDatetime,
			workitemstate, expectedworkitemdelay, previousstage,
			lockedbyname, lockstatus, lockedtime, queuename, queuetype,
			statename
		FROM WORKINPROCESSTABLE
		UNION ALL
		SELECT processinstanceid, workitemid, processname, processversion,
			processdefid, LastProcessedBy, processedby, activityname, activityid,
			entryDATETIME, parentworkitemid, AssignmentType,
			collectflag, prioritylevel, validtill, q_streamid,
			q_queueid, q_userid, AssignedUser, CreatedDatetime,
			workitemstate, expectedworkitemdelay, previousstage,
			lockedbyname, lockstatus, lockedtime, queuename, queuetype,
			statename
		FROM WORKDONETABLE
		UNION ALL
		SELECT processinstanceid, workitemid, processname, processversion,
			processdefid, LastProcessedBy, processedby, activityname, activityid,
			entryDATETIME, parentworkitemid, AssignmentType,
			collectflag, prioritylevel, validtill, q_streamid,
			q_queueid, q_userid, AssignedUser, CreatedDatetime,
			workitemstate, expectedworkitemdelay, previousstage,
			lockedbyname, lockstatus, lockedtime, queuename, queuetype,
			statename
		FROM WORKWITHPSTABLE
		UNION ALL
		SELECT processinstanceid, workitemid, processname, processversion,
			processdefid, LastProcessedBy, processedby, activityname, activityid,
			entryDATETIME, parentworkitemid, AssignmentType,
			collectflag, prioritylevel, validtill, q_streamid,
			q_queueid, q_userid, AssignedUser, CreatedDatetime,
			workitemstate, expectedworkitemdelay, previousstage,
			lockedbyname, lockstatus, lockedtime, queuename, queuetype,
			statename
		FROM PENDINGWORKLISTTABLE) queueTABLE1
	WHERE QUEUEDATATABLE.processinstanceid = queueTABLE1.processinstanceid
	AND QUEUEDATATABLE.workitemid = queueTABLE1.workitemid
	AND queueTABLE1.processinstanceid = PROCESSINSTANCETABLE.processinstanceid;

CREATE VIEW QUEUEVIEW 
AS
	SELECT * FROM QUEUETABLE 
	UNION ALL 
	SELECT * FROM QUEUEHISTORYTABLE;

CREATE VIEW WFSEARCHVIEW_0 
AS 
	SELECT	QUEUEVIEW.ProcessInstanceId, QUEUEVIEW.QueueName, QUEUEVIEW.ProcessName,
		ProcessVersion,QUEUEVIEW.ActivityName, statename,QUEUEVIEW.CheckListCompleteFlag,
		QUEUEVIEW.AssignedUser,QUEUEVIEW.EntryDATETIME,QUEUEVIEW.ValidTill,QUEUEVIEW.workitemid,
		QUEUEVIEW.prioritylevel, QUEUEVIEW.parentworkitemid,QUEUEVIEW.processdefid,
		QUEUEVIEW.ActivityId,QUEUEVIEW.InstrumentStatus, QUEUEVIEW.LockStatus,
		QUEUEVIEW.LockedByName,QUEUEVIEW.CreatedByName,QUEUEVIEW.CreatedDatetime, 
		QUEUEVIEW.LockedTime, QUEUEVIEW.IntroductionDateTime,QUEUEVIEW.Introducedby,
		QUEUEVIEW.AssignmentType, QUEUEVIEW.processinstancestate, QUEUEVIEW.queuetype,
		Status, Q_QueueId, TIMESTAMPDIFF(8, CHAR(ExpectedWorkItemDelayTime - EntryDateTime)) AS TurnaroundTime, 
		ReferredBy, ReferredTo, ExpectedProcessDelayTime, ExpectedWorkItemDelayTime,  
		ProcessedBy, Q_UserID, WorkItemState 
	FROM	QUEUEVIEW;

CREATE VIEW WFWORKINPROCESSVIEW_0 
AS	SELECT	WORKINPROCESSTABLE.ProcessInstanceId,WORKINPROCESSTABLE.ProcessInstanceId AS WorkItemName,
		WORKINPROCESSTABLE.ProcessdefId,ProcessName,ActivityId,ActivityName,PriorityLevel,InstrumentStatus,
		LockStatus,LockedByName,Validtill,CreatedByName,PROCESSINSTANCETABLE.CreatedDatetime,Statename,
		CheckListCompleteFlag,EntryDATETIME,LockedTime,IntroductionDateTime,Introducedby,AssignedUser,
		WORKINPROCESSTABLE.WorkItemId,QueueName,AssignmentType,ProcessInstanceState,QueueType,
		Status, Q_QueueId, TIMESTAMPDIFF(8, CHAR(ExpectedWorkItemDelay - EntryDateTime)) AS TurnaroundTime,
		ReferredByname, cast(NULL AS INT) ReferTo, guid,Q_userId 
	FROM	WORKINPROCESSTABLE,
		PROCESSINSTANCETABLE,
		QUEUEDATATABLE 
	WHERE	WORKINPROCESSTABLE.ProcessInstanceid = QUEUEDATATABLE.ProcessInstanceId
	AND	WORKINPROCESSTABLE.Workitemid = QUEUEDATATABLE.Workitemid 
	AND	WORKINPROCESSTABLE.ProcessInstanceid = PROCESSINSTANCETABLE.ProcessInstanceId;

CREATE VIEW WFUSERVIEW 
AS 
	SELECT	UserIndex, vargraphic(UserName) as UserName, PersonalName, FamilyName,
		CreatedDateTime, ExpiryDateTime, PrivilegeControlList, PASSWORD, Account,
		COMMNT, DeletedDateTime, UserAlive, MainGroupId, MailId, Fax, NoteColor,
		Superior, SuperiorFlag, ParentGroupIndex, PasswordNeverExpire,
		PasswordExpiryTime
	FROM pdbuser;

CREATE VIEW WFGROUPVIEW 
AS 
	SELECT groupindex, groupname, CreatedDatetime, expirydatetime,
		privilegecontrollist, owner, commnt, grouptype, maingroupindex 
	FROM PDBGROUP;

CREATE VIEW WFSESSIONVIEW 
AS
	SELECT  RandomNumber AS SessionID, UserIndex AS UserID, UserLogINTime,
		HostName AS Scope, MainGroupId, UserType AS ParticipantType,
		AccessDATETIME, StatusFlag, Locale 
	FROM	PDBCONNECTION;

CREATE INDEX  IX1_RouteLogTABLE ON CURRENTROUTELOGTABLE (ProcessDefId, ActionId);

CREATE INDEX  IX2_RouteLogTABLE ON CURRENTROUTELOGTABLE (ActionId, UserID); 

CREATE INDEX  IX1_HRouteLogTABLE ON HISTORYROUTELOGTABLE (ProcessDefId, ActionId);

CREATE INDEX  IX2_HRouteLogTABLE ON HISTORYROUTELOGTABLE (ActionId, UserID);

CREATE INDEX IX1_SUMMARYTABLE ON SUMMARYTABLE(processdefid, actionid);

CREATE INDEX IDX1_QDATATABLE ON QUEUEDATATABLE(ChildProcessInstanceID, ChildWorkItemID);

CREATE INDEX IDX1_WORKDONETABLE ON WORKDONETABLE(ProcessDefId);

CREATE INDEX IX1_WFMessInProTab ON WFMessageInProcessTable(lockedBy);

CREATE INDEX IX1_WFEscTable ON WFEscalationTable(EscalationMode, ScheduleTime);

CREATE INDEX IDX3_CRLTable ON CurrentRouteLogTable (ProcessInstanceId);

CREATE INDEX IDX3_HRLTable ON HistoryRouteLogTable (ProcessInstanceId);

CREATE INDEX IDX2_QDataTable ON QueueDataTable (var_rec_1, var_rec_2);

CREATE INDEX IDX2_WorkListTable ON WorkListTable (Q_QueueId);

CREATE INDEX IDX3_WorkListTable ON WorkListTable (Q_QueueId, WorkItemState);

CREATE INDEX IDX2_WIPTable ON WorkInProcessTable (Q_QueueId);

CREATE INDEX IDX3_WIPTable ON WorkInProcessTable (Q_QueueId, WorkItemState);

CREATE INDEX IDX1_QStreamTable ON QueueStreamTable (QueueId);

/* ToDo :: To be discussed with Mr. Dinesh Parikh for addition of new column */
CREATE INDEX IDX2_VMT ON VarMappingTable (UserDefinedName);

CREATE INDEX IX2_WFMIPTable ON WFMessageInProcessTable (messageId);

CREATE INDEX IDX1_WFActRepTTab ON WFACTIVITYREPORTTABLE (PROCESSDEFID, ACTIVITYID, TO_DATE(TO_CHAR(ACTIONDATETIME, 'YYYY-MM-DD HH24'), 'YYYY-MM-DD HH24'));

CREATE INDEX IDX1_WFReptDataTab ON WFREPORTDATATABLE (PROCESSINSTANCEID, WORKITEMID, PROCESSDEFID, ACTIVITYID, USERID);

CREATE TRIGGER WF_USR_DEL 
	AFTER DELETE ON PDBUSER REFERENCING OLD AS OLD_ROW 
	FOR EACH ROW MODE DB2SQL 
BEGIN ATOMIC 
	DELETE FROM QUEUEUSERTABLE WHERE UserID = OLD_ROW.UserIndex AND Associationtype = 0; 
	DELETE FROM USERPREFERENCESTABLE WHERE UserID = OLD_ROW.UserIndex; 
	DELETE FROM USERDIVERSIONTABLE WHERE Diverteduserindex = OLD_ROW.UserIndex OR AssignedUserindex = OLD_ROW.UserIndex; 
	DELETE FROM USERWORKAUDITTABLE WHERE Userindex = OLD_ROW.UserIndex OR Auditoruserindex = OLD_ROW.UserIndex; 
END^

CREATE TRIGGER LOGPDBCONN_DEL 
	AFTER DELETE ON PDBCONNECTION REFERENCING OLD AS OLD_ROW 
	FOR EACH ROW MODE DB2SQL 
BEGIN ATOMIC 
	DECLARE v_userName	VARGRAPHIC(63); 
	
/*	SELECT RTRIM(userName) INTO v_userName FROM pdbuser WHERE userindex = OLD_ROW.userindex;
    Change by : Varun Bhansaly
    Date      : 27/12/2006
    Reason    : Implement DB2 specific trigger creation
*/
	SET v_userName = (SELECT RTRIM(userName) FROM pdbuser WHERE userindex = OLD_ROW.userindex);
	INSERT INTO CURRENTROUTELOGTABLE (
		ProcessDefId, ActivityId, ProcessInstanceId, 
		WorkItemId, UserId, ActionId, 
		ActionDateTime, AssociatedFieldId, AssociatedFieldName, 
		ActivityName, UserName) 
	VALUES (0, 0, NULL, 
		0, OLD_ROW.userindex, 23, 
		Current_TIMESTAMP, OLD_ROW.userindex, v_userName, 
		NULL, v_userName); 
END^

CREATE TRIGGER LOGPDBCONN_INS 
	AFTER INSERT ON PDBCONNECTION REFERENCING NEW AS NEW_ROW 
	FOR EACH ROW MODE DB2SQL 
BEGIN ATOMIC 
	DECLARE v_userName	VARGRAPHIC(63);

/*	SELECT RTRIM(userName) INTO v_userName FROM pdbuser WHERE userindex = NEW_ROW.userindex; 
	Change by : Varun Bhansaly
    Date      : 27/12/2006
    Reason    : Implement DB2 specific trigger creation
*/
	SET v_userName = SELECT RTRIM(userName) FROM pdbuser WHERE userindex = NEW_ROW.userindex;
	INSERT INTO CURRENTROUTELOGTABLE ( 
		ProcessDefId, ActivityId, ProcessInstanceId, 
		WorkItemId, UserId, ActionId, 
		ActionDateTime, AssociatedFieldId, AssociatedFieldName, 
		ActivityName, UserName) 
	VALUES (0, 0, NULL, 
		0, NEW_ROW.userindex, 24, 
		Current_TIMESTAMP, NEW_ROW.userindex, v_userName, 
		NULL, v_userName); 
END^

CREATE TRIGGER UNQPSREGSTRTNTAB 
	AFTER UPDATE ON PSREGISTERATIONTABLE REFERENCING NEW AS NEW_ROW 
	FOR EACH ROW MODE DB2SQL 
BEGIN ATOMIC 
	DECLARE sessionindex	int; 
	DECLARE psindex		int; 

	SET sessionindex = NEW_ROW.sessionid;
	SET psindex = NEW_ROW.psid;
	IF (exists (SELECT * FROM psregisterationtable WHERE sessionid = sessionindex AND  psid != psindex )) THEN
		SIGNAL SQLSTATE '80001' ('Have same session ID');
	END IF;
END^

COMMIT;
