/*__________________________________________________________________________________;
NEWGEN SOFTWARE TECHNOLOGIES LIMITED;
Group                       : Phoenix;
Product / Project           : IBPS;
Module                      : IBPS Server;
File Name                   : WFCreatePartionedTables.sql (Oracle)
Author                      : Mohnish Chopra
Date written (DD/MM/YYYY)   : 22 MAY 2014
Description                 : Support for Partitioning in Archival . Creates partitioning supported tables.
____________________________________________________________________________________;
CHANGE HISTORY;
____________________________________________________________________________________;
Date        Change By        Change Description (Bug No. (IF Any))
____________________________________________________________________________________*/
/***************************************************************************************;
*  Description : Database partitioning Solution for IBPS
* It is mandatory to compile and EXECUTE IMMEDIATE this script on target cabinet 
*
***************************************************************************************/
Create or replace PROCEDURE WFCreatePartionedTables
AS
v_query VARCHAR2(32767);

BEGIN 

v_query:='DROP TABLE WFINSTRUMENTTABLE';

Execute immediate v_query;



v_query:='CREATE TABLE WFINSTRUMENTTABLE (
	ProcessInstanceID			NVARCHAR2 (63)  NOT NULL ,
	ProcessDefID				INT		NOT NULL,
	Createdby					INT		NOT NULL ,
	CreatedByName				NVARCHAR2(63)	NULL ,
	Createddatetime				DATE		NOT NULL ,
	Introducedbyid				INT		NULL ,
	Introducedby				NVARCHAR2(63)	NULL ,
	IntroductionDatetime		DATE		NULL ,
	ProcessInstanceState		INT		NULL ,
	ExpectedProcessDelay		DATE		NULL ,
	IntroducedAt				NVARCHAR2(30)	NOT NULL ,
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
	VAR_DATE1					DATE		NULL ,
	VAR_DATE2					DATE		NULL ,
	VAR_DATE3					DATE		NULL ,
	VAR_DATE4					DATE		NULL ,
	VAR_LONG1					INT		NULL ,
	VAR_LONG2					INT		NULL ,
	VAR_LONG3					INT		NULL ,
	VAR_LONG4					INT		NULL ,
	VAR_STR1					NVARCHAR2(255)  NULL ,
	VAR_STR2					NVARCHAR2(255)  NULL ,
	VAR_STR3					NVARCHAR2(255)  NULL ,
	VAR_STR4					NVARCHAR2(255)  NULL ,
	VAR_STR5					NVARCHAR2(255)  NULL ,
	VAR_STR6					NVARCHAR2(255)  NULL ,
	VAR_STR7					NVARCHAR2(255)  NULL ,
	VAR_STR8					NVARCHAR2(255)  NULL ,
	VAR_REC_1					NVARCHAR2(255)  NULL ,
	VAR_REC_2					NVARCHAR2(255)  NULL ,
	VAR_REC_3					NVARCHAR2(255)  NULL ,
	VAR_REC_4					NVARCHAR2(255)  NULL ,
	VAR_REC_5					NVARCHAR2(255) DEFAULT ''0''  NULL ,
	InstrumentStatus			NVARCHAR2(1)	NULL, 
	CheckListCompleteFlag		NVARCHAR2(1)	NULL ,
	SaveStage					NVARCHAR2(30)	NULL ,
	HoldStatus					INT		NULL,
	Status						NVARCHAR2(255)  NULL ,
	ReferredTo					INT		NULL ,
	ReferredToName				NVARCHAR2(63)	NULL ,
	ReferredBy					INT		NULL ,
	ReferredByName				NVARCHAR2(63)	NULL ,
	ChildProcessInstanceId		NVARCHAR2(63)	NULL,
	ChildWorkitemId				INT,
	ParentWorkItemID			INT,
	CalendarName    			NVARCHAR2(255) NULL,  
	ProcessName 				NVARCHAR2(30)	NOT NULL ,
	ProcessVersion  			SMALLINT,
	LastProcessedBy 			INT		NULL ,
	ProcessedBy					NVARCHAR2(63)	NULL,	
	ActivityName 				NVARCHAR2(30)	NULL ,
	ActivityId 					INT		NULL ,
	EntryDateTime 				DATE		NULL ,
	AssignmentType				NVARCHAR2 (1)	NULL ,
	CollectFlag					NVARCHAR2 (1)	NULL ,
	PriorityLevel				SMALLINT	NULL ,
	ValidTill					DATE		NULL ,
	Q_StreamId					INT		NULL ,
	Q_QueueId					INT		NULL ,
	Q_UserId					INT	NULL ,
	AssignedUser				NVARCHAR2(63)	NULL,	
	FilterValue					INT		NULL ,
	WorkItemState				INT		NULL ,
	Statename 					NVARCHAR2(255),
	ExpectedWorkitemDelay		DATE		NULL ,
	PreviousStage				NVARCHAR2 (30)  NULL ,
	LockedByName				NVARCHAR2(63)	NULL,	
	LockStatus					NVARCHAR2(1) NOT NULL,
	RoutingStatus				NVARCHAR2(1) NOT NULL,	
	LockedTime					DATE		NULL , 
	Queuename 					NVARCHAR2(63),
	Queuetype 					NVARCHAR2(1),
	NotifyStatus				NVARCHAR2(1),	  
	Guid 						NUMBER,
	NoOfCollectedInstances		INT DEFAULT 0 NOT NULL,
	IsPrimaryCollected			NVARCHAR2(1) NULL CHECK (IsPrimaryCollected IN (N''Y'', N''N'')),
	ExportStatus				NVARCHAR2(1) DEFAULT ''N'',
	ProcessVariantId 			INT DEFAULT(0) NOT NULL ,
	Q_DivertedByUserId   		INT,
	ActivityType				SMALLINT NULL,
	lastModifiedTime				DATE		NULL , 
	VAR_DATE5					DATE		NULL ,
	VAR_DATE6					DATE		NULL ,
	VAR_LONG5					INT		NULL ,
	VAR_LONG6					INT		NULL ,
	VAR_STR9					NVARCHAR2(512)  NULL ,
	VAR_STR10					NVARCHAR2(512)  NULL ,
	VAR_STR11					NVARCHAR2(512)  NULL ,
	VAR_STR12					NVARCHAR2(512)  NULL ,
	VAR_STR13					NVARCHAR2(512)  NULL ,
	VAR_STR14					NVARCHAR2(512)  NULL ,
	VAR_STR15					NVARCHAR2(512)  NULL ,
	VAR_STR16					NVARCHAR2(512)  NULL ,
	VAR_STR17					NVARCHAR2(512)  NULL ,
	VAR_STR18					NVARCHAR2(512)  NULL ,
	VAR_STR19					NVARCHAR2(512)  NULL ,
	VAR_STR20					NVARCHAR2(512)  NULL ,
	CONSTRAINT PK_WFINSTRUMENTTable PRIMARY KEY 
	(
	ProcessInstanceID,WorkitemId
	)
) 
PARTITION BY LIST (ProcessDefID)
        SUBPARTITION BY RANGE (ProcessVariantId,ProcessInstanceID)
    (    PARTITION P0_WFIT VALUES (0 )

         (SUBPARTITION SP0_WFIT VALUES LESS THAN  (1,''ZZZ-001-ZZZ''))

    )'; 


Execute immediate v_query;


v_query:='CREATE INDEX IDX1_WFINSTRUMENTTABLE ON WFINSTRUMENTTABLE (var_rec_1, var_rec_2)';


Execute immediate v_query;
v_query:='CREATE INDEX IDX2_WFINSTRUMENTTABLE ON WFINSTRUMENTTABLE (Q_QueueId,ProcessInstanceId,WorkitemId)';

Execute immediate v_query;
v_query:='CREATE INDEX IDX3_WFINSTRUMENTTABLE ON WFINSTRUMENTTABLE (Q_UserID, ProcessInstanceId, WorkitemId)';

Execute immediate v_query;

v_query:='CREATE INDEX IDX5_WFINSTRUMENTTABLE ON WFINSTRUMENTTABLE (Q_QueueId  ,  WorkItemState  , LockStatus  ,RoutingStatus   ,EntryDATETIME)';

Execute immediate v_query;
v_query:='CREATE INDEX IDX6_WFINSTRUMENTTABLE ON WFINSTRUMENTTABLE  (ProcessDefId, RoutingStatus, LockStatus)';


Execute immediate v_query;
v_query:='CREATE INDEX IDX7_WFINSTRUMENTTABLE ON WFINSTRUMENTTABLE  (PROCESSINSTANCEID, PARENTWORKITEMID)';


Execute immediate v_query;
v_query:='CREATE INDEX IDX8_WFINSTRUMENTTABLE ON WFINSTRUMENTTABLE(Q_UserId, ROUTINGSTATUS, Q_QUEUEID)';


Execute immediate v_query;
v_query:='CREATE INDEX IDX9_WFINSTRUMENTTABLE ON WFINSTRUMENTTABLE(Q_QUEUEID, LOCKSTATUS,ENTRYDATETIME,PROCESSINSTANCEID,WORKITEMID)';


Execute immediate v_query;
v_query:='CREATE INDEX IDX10_WFINSTRUMENTTABLE ON WFINSTRUMENTTABLE(childprocessinstanceid, childworkitemid)';


Execute immediate v_query;
v_query:='CREATE INDEX IDX11_WFINSTRUMENTTABLE ON WFINSTRUMENTTABLE(ValidTill)';

v_query:='DROP TABLE QUEUEHISTORYTABLE';

Execute immediate v_query;	
v_query:='CREATE TABLE QUEUEHISTORYTABLE (
	ProcessDefId 		INT 		NOT NULL ,
	ProcessName 		NVARCHAR(30)	NULL,
	ProcessVersion 		SMALLINT	NULL,
	ProcessInstanceId	NVARCHAR(63)  	NOT NULL ,
	ProcessInstanceName	NVARCHAR(63)	NULL ,
	ActivityId 		INT 		NOT NULL ,
	ActivityName		NVARCHAR(30)	NULL ,
	ParentWorkItemId 	INT		NULL ,
	WorkItemId 		INT 		NOT NULL ,
	ProcessInstanceState 	INT 		NOT NULL ,
	WorkItemState 		INT 		NOT NULL ,
	Statename 		NVARCHAR(50)	NULL,
	QueueName		NVARCHAR (63)	NULL ,
	QueueType 		NVARCHAR(1)	NULL ,
	AssignedUser		NVARCHAR (63)	NULL ,
	AssignmentType 		NVARCHAR(1)	NULL ,
	InstrumentStatus 	NVARCHAR(1)	NULL ,
	CheckListCompleteFlag 	NVARCHAR(1)	NULL ,
	IntroductionDateTime	DATETIME	NULL ,
	CreatedDatetime		DATETIME	NULL ,
	Introducedby		NVARCHAR (63)	NULL ,
	CreatedByName		NVARCHAR (63)	NULL ,
	EntryDATETIME		DATETIME 	NOT NULL ,
	LockStatus 		NVARCHAR(1)	NULL ,
	HoldStatus 		SMALLINT	NULL ,
	PriorityLevel 		SMALLINT 	NOT NULL ,
	LockedByName		NVARCHAR (63)	NULL ,
	LockedTime		DATETIME	NULL ,
	ValidTill		DATETIME	NULL ,
	SaveStage		NVARCHAR(30)	NULL ,
	PreviousStage		NVARCHAR(30)	NULL ,
	ExpectedWorkItemDelayTime DATETIME	NULL,
	ExpectedProcessDelayTime DATETIME	NULL,
	Status 			NVARCHAR(50)	NULL ,
	VAR_INT1 		SMALLINT	NULL ,
	VAR_INT2 		SMALLINT	NULL ,
	VAR_INT3 		SMALLINT	NULL ,
	VAR_INT4 		SMALLINT	NULL ,
	VAR_INT5 		SMALLINT	NULL ,
	VAR_INT6 		SMALLINT	NULL ,
	VAR_INT7 		SMALLINT	NULL ,
	VAR_INT8 		SMALLINT	NULL ,
	VAR_FLOAT1		Numeric(15,2)	NULL ,
	VAR_FLOAT2		Numeric(15,2)	NULL ,
	VAR_DATE1		DATETIME	NULL ,
	VAR_DATE2		DATETIME	NULL ,
	VAR_DATE3		DATETIME	NULL ,
	VAR_DATE4		DATETIME	NULL ,
	VAR_LONG1 		INT		NULL ,
	VAR_LONG2 		INT		NULL ,
	VAR_LONG3 		INT		NULL ,
	VAR_LONG4 		INT		NULL ,
	VAR_STR1		NVARCHAR(255)	NULL ,
	VAR_STR2		NVARCHAR(255)	NULL ,
	VAR_STR3		NVARCHAR(255)	NULL ,
	VAR_STR4		NVARCHAR(255)	NULL ,
	VAR_STR5		NVARCHAR(255)	NULL ,
	VAR_STR6		NVARCHAR(255)	NULL ,
	VAR_STR7		NVARCHAR(255)	NULL ,
	VAR_STR8		NVARCHAR(255)	NULL ,
	VAR_REC_1		NVARCHAR(255)	NULL ,
	VAR_REC_2		NVARCHAR(255)	NULL ,
	VAR_REC_3		NVARCHAR(255)	NULL ,
	VAR_REC_4		NVARCHAR(255)	NULL ,
	VAR_REC_5		NVARCHAR(255)	NULL ,
	Q_StreamId 		INT		NULL ,
	Q_QueueId 		INT		NULL ,
	Q_UserID 		INT	NULL ,
	LastProcessedBy 	INT	NULL,
	ProcessedBy		NVARCHAR (63)	NULL ,
	ReferredTo 		INT	NULL ,
	ReferredToName		NVARCHAR (63)	NULL ,
	ReferredBy 		INT	NULL ,
	ReferredByName		NVARCHAR (63)	NULL ,
	CollectFlag 		NVARCHAR(1)	NULL ,
	CompletionDatetime	DATETIME	NULL ,
	CalendarName       NVARCHAR(255) NULL,
	ExportStatus	NVARCHAR(1) DEFAULT ''N'',
	ProcessVariantId 	INT 		NOT NULL DEFAULT 0,
	ActivityType		SmallInt NULL,
	lastModifiedTime 	DATETIME,
	VAR_DATE5		DATETIME	NULL ,
	VAR_DATE6		DATETIME	NULL ,
	VAR_LONG5 		INT		NULL ,
	VAR_LONG6 		INT		NULL ,
	VAR_STR9		NVARCHAR(512)	NULL ,
	VAR_STR10		NVARCHAR(512)	NULL ,
	VAR_STR11		NVARCHAR(512)	NULL ,
	VAR_STR12		NVARCHAR(512)	NULL ,
	VAR_STR13		NVARCHAR(512)	NULL ,
	VAR_STR14		NVARCHAR(512)	NULL ,
	VAR_STR15		NVARCHAR(512)	NULL ,
	VAR_STR16		NVARCHAR(512)	NULL ,
	VAR_STR17		NVARCHAR(512)	NULL ,
	VAR_STR18		NVARCHAR(512)	NULL ,
	VAR_STR19		NVARCHAR(512)	NULL ,
	VAR_STR20		NVARCHAR(512)	NULL ,
	ChildProcessInstanceId		NVARCHAR(63)	NULL,
    ChildWorkitemId				INT,
	FilterValue					INT		NULL,
	Guid 						BIGINT ,
	NotifyStatus				NVARCHAR(1),
	Q_DivertedByUserId   		INT NULL,
	RoutingStatus				NVARCHAR(1),
	NoOfCollectedInstances		INT DEFAULT 0,
	IsPrimaryCollected			NVARCHAR(1)	NULL CHECK (IsPrimaryCollected IN (N''Y'', N''N''))
	PRIMARY KEY ( ProcessInstanceId , WorkItemId )
	)
	PARTITION BY LIST (ProcessDefID)
        SUBPARTITION BY RANGE (ProcessVariantId,ProcessInstanceID)
    (    PARTITION P0_WFIT VALUES (0 )

         (SUBPARTITION SP0_WFIT VALUES LESS THAN  (1,''ZZZ-001-ZZZ''))

    )'; 
Execute immediate v_query;

v_query:='CREATE INDEX  IDX2_QueueHistoryTable ON QueueHistoryTable (ActivityName)';
Execute immediate v_query;


v_query:='CREATE INDEX  IDX3_QueueHistoryTable ON QueueHistoryTable (VAR_REC_1, VAR_REC_2)';
Execute immediate v_query;


v_query:='CREATE INDEX  IDX4_QueueHistoryTable ON QueueHistoryTable (Q_QueueId)';
Execute immediate v_query;



v_query:='DROP TABLE EXCEPTIONTABLE';
Execute immediate v_query;

v_query:='CREATE TABLE EXCEPTIONTABLE (
	ProcessDefId		INTEGER		NOT NULL,
	ExcpSeqId		INTEGER		NOT NULL,
	WorkitemId		INTEGER		NOT NULL,
	ActivityId		INTEGER		NOT NULL,
	ActivityName		NVARCHAR2(30)   NOT NULL,
	ProcessinstanceId	NVARCHAR2(63)	NOT NULL,
	Userid			INT	NOT NULL,
	Username		NVARCHAR2(63)	NOT NULL,
	Actionid		INTEGER		NOT NULL,
	Actiondatetime		DATE		DEFAULT SYSDATE NOT NULL,
	Exceptionid		INTEGER		NOT NULL,
	Exceptionname		NVARCHAR2(50)	NOT NULL,
	Finalizationstatus	NVARCHAR2(1)    DEFAULT N''T''  NOT NULL,
	Exceptioncomments	NVARCHAR2(512)  NULL 
)
PARTITION BY LIST (ProcessDefID)
        SUBPARTITION BY RANGE (ProcessInstanceID)
    (    PARTITION P0_ET VALUES (0 )

         (SUBPARTITION SP0_ET VALUES LESS THAN  (''ZZZ-001-ZZZ''))

    )'; 

Execute immediate v_query;
v_query:='CREATE INDEX IDX1_ExceptionTable ON ExceptionTable (ProcessInstanceId, ProcessDefId, ActivityId, ExceptionId, excpseqid DESC, ActionId DESC)';


Execute immediate v_query;
v_query:='CREATE INDEX IDX2_ExceptionTable ON ExceptionTable (ProcessInstanceId)';


Execute immediate v_query;
v_query:='CREATE INDEX IDX3_ExceptionTable ON ExceptionTable (ProcessDefId, ActivityId)';

Execute immediate v_query;
v_query:='DROP TABLE TODOSTATUSTABLE ';



Execute immediate v_query;
v_query:='CREATE TABLE TODOSTATUSTABLE (
	ProcessDefId		INTEGER         NOT NULL,
	ProcessInstanceId	NVARCHAR2(63)     NOT NULL,
	ToDoValue		NVARCHAR2(255)    NULL
)
PARTITION BY LIST (ProcessDefID)
        SUBPARTITION BY RANGE (ProcessInstanceID)
    (    PARTITION P0_TDST VALUES (0 )

         (SUBPARTITION SP0_TDST VALUES LESS THAN  (''ZZZ-001-ZZZ''))

    )'; 
	
 	
Execute immediate v_query;
v_query:='CREATE INDEX IDX1_TODOSTATUSTABLE ON TODOSTATUSTABLE (ProcessInstanceId)';


Execute immediate v_query;
v_query:='DROP TABLE WFCURRENTROUTELOGTABLE';


Execute immediate v_query;
v_query:='CREATE TABLE WFCurrentRouteLogTable (
		LogId 				INT							NOT NULL	PRIMARY KEY,
		ProcessDefId  		INT 						NOT NULL,
		ActivityId 			INT								NULL ,
		ProcessInstanceId	NVARCHAR2(63)					NULL ,
		WorkItemId 			INT								NULL ,
		UserId 				INT								NULL ,
		ActionId 			INT 						NOT NULL ,
		ActionDatetime		DATE	 DEFAULT SYSDATE	NOT NULL , 
		AssociatedFieldId 	INT								NULL , 
		AssociatedFieldName	NVARCHAR2(2000)					NULL , 
		ActivityName		NVARCHAR2(30)					NULL , 
		UserName			NVARCHAR2(63)					NULL , 
		NewValue			NVARCHAR2(255)					NULL , 
		AssociatedDateTime	DATE							NULL , 
		QueueId				INT								NULL ,
		ProcessVariantId 	INT 			DEFAULT(0) 	NOT NULL,
		TaskId 				INT   			DEFAULT(0),
		SubTaskId			INT 			DEFAULT(0)
)

PARTITION BY LIST (ProcessDefID)
        SUBPARTITION BY RANGE (ProcessVariantId,ProcessInstanceID)
    (    PARTITION P0_WFCRLT VALUES (0 )

         (SUBPARTITION SP0_WFCRLT VALUES LESS THAN  (1,''ZZZ-001-ZZZ''))

    )'; 



Execute immediate v_query;
v_query:='CREATE INDEX  IDX1_WFRouteLogTABLE ON WFCURRENTROUTELOGTABLE (ProcessDefId,ActionId)';
Execute immediate v_query;
v_query:='CREATE INDEX  IDX2_WFRouteLogTABLE ON WFCURRENTROUTELOGTABLE (ActionId,UserID)';
Execute immediate v_query;
v_query:='CREATE INDEX IDX3_WFCRouteLogTable ON WFCurrentRouteLogTable (ProcessInstanceId)';
Execute immediate v_query;
v_query:='CREATE INDEX IDX4_WFCRouteLogTable ON WFCurrentRouteLogTable (ProcessInstanceId, ActionDateTime, LogID)';

Execute immediate v_query;

v_query:='DROP TABLE WFATTRIBUTEMESSAGETABLE';
Execute immediate v_query;
	
v_query:='CREATE TABLE WFATTRIBUTEMESSAGETABLE ( 
	ProcessDefID		INT		NOT NULL,
	ProcessVariantId 	INT DEFAULT(0)  NOT NULL ,
	ProcessInstanceID	NVARCHAR2 (63)  NOT NULL ,
	WorkitemId		    INTEGER		NOT NULL,
	MESSAGEID		INTEGER NOT NULL, 
	MESSAGE			CLOB NOT NULL, 
	LOCKEDBY		NVARCHAR2(63), 
	STATUS			NVARCHAR2(1) CHECK (status in (N''N'', N''F'')), 
	ActionDateTime	DATE,  
	CONSTRAINT PK_WFATTRIBUTEMESSAGETABLE2 PRIMARY KEY (MESSAGEID ) 
)
 PARTITION BY LIST (ProcessDefID)
        SUBPARTITION BY RANGE (ProcessVariantId,ProcessInstanceID)
    (    PARTITION P0_WFAMT VALUES (0 )

         (SUBPARTITION SP0_WFAMT VALUES LESS THAN  (1,''ZZZ-001-ZZZ''))

    )'; 


Execute immediate v_query;

v_query:='CREATE INDEX IDX1_WFATTRIBUTEMESSAGETABLE ON WFATTRIBUTEMESSAGETABLE(PROCESSINSTANCEID)';
Execute immediate v_query;
	
v_query:='DROP TABLE WFACTIVITYREPORTTABLE';

Execute immediate v_query;
v_query:='CREATE TABLE WFACTIVITYREPORTTABLE(
	ProcessDefId         Integer,
	ActivityId           Integer,
	ActivityName         Nvarchar2(30),
	ActionDatetime       Date,
	TotalWICount         Integer,
	TotalDuration        NUMBER,
	TotalProcessingTime  NUMBER
)
PARTITION BY RANGE (ActionDateTime)
        ( 
		PARTITION P0_WFART VALUES LESS THAN (''01-JAN-1970'')
    )'; 

	
	Execute immediate v_query;
v_query:='CREATE INDEX IDX1_WFACTIVITYREPORTTABLE ON WFACTIVITYREPORTTABLE (PROCESSDEFID, ACTIVITYID, TO_DATE(TO_CHAR(ACTIONDATETIME, ''YYYY-MM-DD HH24''), ''YYYY-MM-DD HH24''))';


Execute immediate v_query;
v_query:='DROP TABLE SUMMARYTABLE';



Execute immediate v_query;
v_query:='CREATE TABLE SUMMARYTABLE(
	processdefid		INT,
	activityid		INT,
	activityname		NVARCHAR2(30),
	queueid			INT,
	userid			INT,
	username		NVARCHAR2(255),
	totalwicount		INT,
	actiondatetime		DATE ,
	actionid		INT,
	totalduration		NUMBER,
	reporttype		NVARCHAR2(1),
	totalprocessingtime	NUMBER,
	delaytime		NUMBER,
	wkindelay		INT,
	AssociatedFieldId	INT,
	AssociatedFieldName	NVARCHAR2(2000),
	ProcessVariantId INT DEFAULT(0) NOT NULL
)
PARTITION BY RANGE (ActionDateTime)
        ( 
		PARTITION P0_ST VALUES LESS THAN (''01-JAN-1970'')
    )'; 


Execute immediate v_query;
v_query:='CREATE INDEX IDX1_SUMMARYTABLE ON SUMMARYTABLE
        (PROCESSDEFID, ACTIONID, ActionDateTime, ACTIVITYID, QueueId, USERID)';
		

Execute immediate v_query;
v_query:='DROP TABLE WFMAILQUEUEHISTORYTABLE'; 

Execute immediate v_query;
v_query:='CREATE TABLE WFMAILQUEUEHISTORYTABLE (
	taskId 			NUMBER		primary key ,
	mailFrom 		NVARCHAR2(255),
	mailTo 			NVARCHAR2(2000), 
	mailCC 			NVARCHAR2(512),
	mailBCC 		NVARCHAR2(512),
	mailSubject 		NVARCHAR2(255),
	mailMessage		CLOB,
	mailContentType		NVARCHAR2(64),
	attachmentISINDEX	NVARCHAR2(1000),
	attachmentNames		NVARCHAR2(1000), 
	attachmentExts		NVARCHAR2(128),	
	mailPriority		NUMBER, 
	mailStatus		NVARCHAR2(1),
	statusComments		NVARCHAR2(512),
	lockedBy		NVARCHAR2(255),
	successTime		DATE ,
	lastLockTime		DATE ,
	insertedBy		NVARCHAR2(255),
	mailActionType		NVARCHAR2(20),
	insertedTime		DATE ,
	processDefId		NUMBER,
	processInstanceId	NVARCHAR2(63),
	workitemId		NUMBER,
	activityId		NUMBER,
	noOfTrials		NUMBER		default 0
)
PARTITION BY RANGE (successTime)
        ( 
		PARTITION P0_WFMQHT VALUES LESS THAN (''01-JAN-1970'')
    )'; 


Execute immediate v_query;
v_query:='DROP TABLE WFRecordedChats'; 


Execute immediate v_query;
v_query:='CREATE TABLE WFRecordedChats(
	ProcessDefId 		INT 			NOT NULL,
	ProcessName 		NVARCHAR2(255) 	NULL,
	SavedBy 			NVARCHAR2(255) 	NULL,
	SavedAt 			DATE 		NOT NULL,
	ChatId 				NVARCHAR2(255) 	NOT NULL,
	Chat 				NVARCHAR2(2000) 	NULL,
	ChatStartTime 		DATE 			NOT NULL,
	ChatEndTime 		DATE 			NOT NULL
)
PARTITION BY RANGE (SavedAt)
        ( 
		PARTITION P0_WFRC VALUES LESS THAN (''01-JAN-1970'')
    )'; 

Execute immediate v_query;
v_query:='DROP TABLE WFUserRatingLogTable'; 

	
Execute immediate v_query;
v_query:='CREATE TABLE WFUserRatingLogTable (
 RatingLogId     INT 	NOT NULL ,
 RatingToUser    INT    NOT NULL ,
 RatingByUser    INT    NOT NULL,
 SkillId      	 INT    NOT NULL,
 Rating      DECIMAL(5,2)  NOT NULL ,
 RatingDateTime    DATE,
 Remarks       NVARCHAR2(512) ,
 PRIMARY KEY ( RatingToUser , RatingByUser,SkillId)
  )
PARTITION BY RANGE (RatingDateTime)
        ( 
		PARTITION P0_WFURLT VALUES LESS THAN (''01-JAN-1970'')
    )'; 
Execute immediate v_query;
v_query:='INSERT INTO WFCabVersionTable(cabVersion, cabVersionId, creationDate, lastModified, Remarks, Status) VALUES (N''PARTITIONING_SUPPORT'', cabVersionId.nextVal, SYSDATE, SYSDATE, N''PARTITIONING in Archival'', N''Y'')
';
Execute immediate v_query;
END;
