/*
/*_____________________________________________________________________________________________________________________-
		NEWGEN SOFTWARE TECHNOLOGIES LIMITED

	Group						: Application – Products
	Product / Project			: WorkFlow
	Module						: Transaction Server
	File NAME					: Upgrade10.sql (Oracle)
	Author						: Sajid Ali Khan
	Date written (DD/MM/YYYY)	: 05/08/2013
	Description					: 
__________________________________________________________________________________-
			CHANGE HISTORY
___________________________________________________________________________________-
Date		Change By		Change Description (Bug No. (If Any))

24/06/2013	Shweta Singhal	sequence created for older processes to create process instance
27/11/2013	Sajid Khan		Changed reflected for Role Association With RMS in OF 10.1.
14-03-2014	Sajid Khan		Type of System Queues should be different than "S" as "S" is for Permanent type of queues[A - QueueType for System Defined Queues].
__________________________________________________________________________________-*/
create or replace
PROCEDURE Upgrade10 AS
existsFlag				INTEGER;
v_lastSeqValue			INTEGER;
v_ProcessDefId			INTEGER;
v_Query             VARCHAR2(8000);
v_STR1			        VARCHAR2(8000);
v_constraintName		VARCHAR2(512);
v_RegStartingNo			INTEGER;
v_SeqName				VARCHAR2(30);
TYPE DynamicCursor	IS REF CURSOR;
CursorObjTable		 DynamicCursor;
CursorExtObjId		DynamicCursor;
v_ExtObjId				INTEGER;
v_STR2			        VARCHAR2(8000);
v_AllowSoapRequest  	VARCHAR2(1);
v_ActivityId_actSub 	 INTEGER;
v_sql_actSub  			VARCHAR2(8000);
v_ActivityType_actSub  	INTEGER;
v_activitysubtype 		INTEGER;
v_previousProcessDefId INTEGER:= 0;
v_counter 			   INTEGER;
v_sourceId 			   INTEGER;
v_targetId			   INTEGER;
cur_coonectionId 	   DynamicCursor;
cur_actSub  			DynamicCursor;
cur_processDef  	DynamicCursor;
cur_QueueDef		DynamicCursor;
cur_ImportPro		DynamicCursor;
v_ConfigurationId		INTEGER;
cursor1            		 DynamicCursor;
v_SAPconstraintName		 VARCHAR2(2000);
v_cabVersion        	VARCHAR2(2000);
v_param1				Varchar2(2000);
v_VariableId			INTEGER;
v_variableType			Integer;
v_QueueName     	Varchar2(2000);
v_ImportedProName  	Varchar2(8000);
v_ImportProid		Integer;	
v_pSeqVar			Integer:= 0;
v_nSeqVar			Integer:= 0;	
v_ActivityId_seq 	Integer;
v_ActivityType_seq	Integer;
cur_ActSeqId		DynamicCursor;
v_ProcessName   VARCHAR2(2000);
cur_extObjId    DynamicCursor;
cur_extDbField		 DynamicCursor;--BUG 42570
cur_getCols			 DynamicCursor;
v_inner_TableName	varchar2(100);
v_colType			varchar2(60);
v_colLen			Integer;
v_FieldType			varchar2(100);
v_tableName			varchar2(100);
v_colName			Varchar2(100);
v_fieldName			Varchar2(100);

/*................................... Adding New Table ............................................... */
BEGIN
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_TABLES  
		WHERE TABLE_NAME = UPPER('WFCABVERSIONTABLE');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			EXECUTE IMMEDIATE 
			'CREATE TABLE WFCabVersionTable (
				cabVersion		NVARCHAR2(255) NOT NULL,
				cabVersionId	INT NOT NULL PRIMARY KEY,
				creationDate	DATE,
				lastModified	DATE,
				Remarks			NVARCHAR2(255) NOT NULL,
				Status			NVARCHAR2(1))';
			dbms_output.put_line ('Table WFCabVersionTable Created successfully');
	END;
	
	BEGIN
		SELECT LAST_NUMBER INTO v_lastSeqValue
		FROM USER_SEQUENCES
		WHERE SEQUENCE_NAME = UPPER('cabVersionId');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'CREATE SEQUENCE CABVERSIONID INCREMENT BY 1 START WITH 1';
			dbms_output.put_line ('SEQUENCE CABVERSIONID Successfully Created');
	END;
	
	
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_TABLES  
		WHERE TABLE_NAME = UPPER('WFAuditRuleTable');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			EXECUTE IMMEDIATE 
			'CREATE TABLE WFAuditRuleTable(
				ProcessDefId	INT NOT NULL,
				ActivityId		INT NOT NULL,
				RuleId			INT NOT NULL,
				RandomNumber	NVARCHAR2(50),
				CONSTRAINT PK_WFAuditRuleTable PRIMARY KEY(ProcessDefId,ActivityId,RuleId)
			)';
			dbms_output.put_line ('Table WFAuditRuleTable Created successfully');
	END;
	
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_TABLES  
		WHERE TABLE_NAME = UPPER('WFAuditTrackTable');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			EXECUTE IMMEDIATE 
			'CREATE TABLE WFAuditTrackTable(
				ProcessInstanceId	NVARCHAR2(255),
				WorkitemId			INT,
				SampledStatus		INT,
				CONSTRAINT PK_WFAuditTrackTable PRIMARY KEY(ProcessInstanceID,WorkitemId)				
			)';
			dbms_output.put_line ('Table WFAuditTrackTable Created successfully');
	END;
	
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_TABLES  
		WHERE TABLE_NAME = UPPER('WFActivitySequenceTABLE');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			EXECUTE IMMEDIATE 
			'CREATE TABLE WFActivitySequenceTABLE(
				ProcessDefId 	INT 	NOT NULL,
				MileStoneId 	INT 	NOT NULL,
				ActivityId 		INT 	NOT NULL,
				SequenceId 		INT 	NOT NULL,
				SubSequenceId 	INT NOT NULL,
				CONSTRAINT pk_WFActivitySequenceTABLE PRIMARY KEY(ProcessDefId,MileStoneId,SequenceId,SubSequenceId)
			)';
			dbms_output.put_line ('Table WFActivitySequenceTABLE Created successfully');
			
			/* Inserting Values in ActivitySequenceTable*/
Begin
		v_STR1:= 'Select b.processdefid ProcessDefId, a.activityid ActivityId, a.activitytype ActivityType from activitytable a inner join  processdeftable b on a.processdefid = b.processdefid order by processdefid, activityid';
		OPEN cur_ActSeqId FOR v_STR1;
	LOOP
		FETCH cur_ActSeqId INTO v_ProcessDefId, v_ActivityId_seq, v_ActivityType_seq;
		EXIT WHEN cur_ActSeqId%NOTFOUND;
		BEGIN
			IF(v_previousProcessDefId = v_ProcessDefId ) THEN
				BEGIN
					IF(v_ActivityType_seq > 4 and v_ActivityType_seq < 8  ) THEN
						v_nSeqVar:=v_nSeqVar - 1;
					ELSE
						v_pSeqVar:= v_pSeqVar + 1;
					END IF;	
				END;
			ELSE
				BEGIN
					IF(v_ActivityType_seq > 4 and v_ActivityType_seq < 8  ) THEN
						v_nSeqVar:= -1;
					ELSE
						v_pSeqVar:= 1;
					END IF;
				END;
			END IF;
			
			IF(v_ActivityType_seq > 4 and v_ActivityType_seq < 8  ) THEN
			EXECUTE IMMEDIATE 'Insert Into WFActivitySequenceTABLE values('||TO_CHAR(v_ProcessDefId)|| ', 1,'||TO_CHAR(v_ActivityId_seq)||','||TO_CHAR(v_nSeqVar)||', 0)';
			ELSE
			EXECUTE IMMEDIATE 'Insert Into WFActivitySequenceTABLE values('||TO_CHAR(v_ProcessDefId)|| ', 1,'||TO_CHAR(v_ActivityId_seq)||','||TO_CHAR(v_pSeqVar)||', 0)';
			END IF;
			v_previousProcessDefId:= v_ProcessDefId;
		END;
	END LOOP;
		CLOSE cur_ActSeqId;
			
END;
END;
	
	
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_TABLES  
		WHERE TABLE_NAME = UPPER('WFMileStoneTable');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			EXECUTE IMMEDIATE 
			'CREATE TABLE WFMileStoneTable(
				ProcessDefId 	INT NOT NULL,
				MileStoneId 	INT NOT NULL,
				MileStoneSeqId 	INT NOT NULL,
				MileStoneName 	NVARCHAR2(255) NULL,
				MileStoneWidth 	INT NOT NULL,
				MileStoneHeight INT NOT NULL,
				ITop 			INT NOT NULL,
				ILeft 			INT NOT NULL,
				BackColor 		INT NOT NULL,
				Description 	NVARCHAR2(255) NULL,
				isExpanded 		NVARCHAR2(50) NULL,
				Cost 			INT NULL,
				Duration 		NVARCHAR2(255) NULL,
				CONSTRAINT pk_WFMileStoneTable PRIMARY KEY(ProcessDefId,MileStoneId),
				CONSTRAINT uk_WFMileStoneTable UNIQUE (ProcessDefId,MileStoneName)
			)';
			dbms_output.put_line ('Table WFMileStoneTable Created successfully');
			
			
	END;

	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_TABLES  
		WHERE TABLE_NAME = UPPER('WFProjectListTable');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			EXECUTE IMMEDIATE 
			'CREATE TABLE WFProjectListTable(
				ProjectID 			INT 			NOT NULL,
				ProjectName 		NVARCHAR2(255) 	NOT NULL,
				Description 		NCLOB			NULL,
				CreationDateTime 	DATE 			NOT NULL,
				CreatedBy 			NVARCHAR2(255) 	NOT NULL,
				LastModifiedOn 		DATE	 		NULL,
				LastModifiedBy 		NVARCHAR2(255) 	NULL,
				ProjectShared 		NCHAR(1) 		NULL,
				CONSTRAINT pk_WFProjectListTable PRIMARY KEY(ProjectID),
				CONSTRAINT WFUNQ_1 UNIQUE(ProjectName)
			)';
			EXECUTE IMMEDIATE 'Insert into WFProjectListTable values (1, ''Default'', EMPTY_CLOB(), sysDate, ''Supervisor'', sysDate, ''Supervisor'', ''N'')';
			dbms_output.put_line ('Table WFProjectListTable Created successfully');
	END;
	
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_TABLES  
		WHERE TABLE_NAME = UPPER('WFEventDetailsTable');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			EXECUTE IMMEDIATE 
			'create TABLE WFEventDetailsTable(
				EventID 				int 			NOT NULL,
				EventName 				nvarchar2(255) 	NOT NULL,
				Description 			nvarchar2(255) 	NULL,
				CreationDateTime 		date 			NOT NULL,
				ModificationDateTime	date	 		NULL,
				CreatedBy 				nvarchar2(255) 	NOT NULL,
				StartTimeHrs 			int 			NOT NULL,
				StartTimeMins 			int 			NOT NULL,
				EndTimeMins 			int 			NOT NULL,
				EndTimeHrs 				int 			NOT NULL,
				StartDate 				date	 		NOT NULL,
				EndDate 				date 			NOT NULL,
				EventRecursive 			nvarchar2(1) 	NOT NULL,
				FullDayEvent 			nvarchar2(1) 	NOT NULL,
				ReminderType 			nvarchar2(1) 	NULL,
				ReminderTime 			int 			NULL,
				ReminderTimeType 		nvarchar2(1) 	NULL,
				ReminderDismissed 		nvarchar2(1) 	DEFAULT ''N'' NOT NULL ,
				SnoozeTime 				int 			DEFAULT -1 NOT NULL,
				EventSummary 			nvarchar2(255) 	NULL,
				UserID 					int 			NULL,
				ParticipantName 		nvarchar2(1024) 	NOT NULL,
				CONSTRAINT pk_WFEventDetailsTable PRIMARY KEY(EventID)
			)';
			dbms_output.put_line ('Table WFEventDetailsTable Created successfully');
	END;
	
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_TABLES  
		WHERE TABLE_NAME = UPPER('WFRepeatEventTable');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			EXECUTE IMMEDIATE 
			'CREATE TABLE WFRepeatEventTable(
				EventID 		INT 			NOT NULL,
				RepeatType 		NVARCHAR2(1) 	NOT NULL,
				RepeatDays 		NVARCHAR2(255) 	NOT NULL,
				RepeatEndDate 	DATE 		NOT NULL,
				RepeatSummary 	NVARCHAR2(255) 	NULL
			)';
			dbms_output.put_line ('Table WFRepeatEventTable Created successfully');
	END;
	
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_TABLES  
		WHERE TABLE_NAME = UPPER('WFOwnerTable');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			EXECUTE IMMEDIATE 
			'CREATE table WFOwnerTable(
				Type 			INT NOT NULL,
				TypeId 			INT NOT NULL,
				ProcessDefId 	INT NOT NULL,	
				OwnerOrderId 	INT NOT NULL,
				UserName 		NVARCHAR2(255) 	NOT NULL,
				constraint pk_WFOwnerTable PRIMARY KEY (Type,TypeId,ProcessDefId,OwnerOrderId)
			)';
			dbms_output.put_line ('Table WFOwnerTable Created successfully');
	END;
	
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_TABLES  
		WHERE TABLE_NAME = UPPER('WFConsultantsTable');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			EXECUTE IMMEDIATE 
			'CREATE TABLE WFConsultantsTable(
				Type 				INT 	NOT NULL,
				TypeId 				INT 	NOT NULL,
				ProcessDefId 		INT 	NOT NULL,	
				ConsultantOrderId 	INT 	NOT NULL,
				UserName			NVARCHAR2(255) 	NOT NULL,
				constraint pk_WFConsultantsTable PRIMARY KEY (Type,TypeId,ProcessDefId,ConsultantOrderId)
			)';
			dbms_output.put_line ('Table WFConsultantsTable Created successfully');
	END;
	
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_TABLES  
		WHERE TABLE_NAME = UPPER('WFSystemTable');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			EXECUTE IMMEDIATE 
			'CREATE table WFSystemTable(
				Type 			INT 			NOT NULL,
				TypeId 			INT 			NOT NULL,
				ProcessDefId 	INT 			NOT NULL,	
				SystemOrderId 	INT 			NOT NULL,
				SystemName  	NVARCHAR2(255) 	NOT NULL,
				constraint pk_WFSystemTable PRIMARY KEY (Type,TypeId,ProcessDefId,SystemOrderId)
			)';
			dbms_output.put_line ('Table WFSystemTable Created successfully');
	END;

	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_TABLES  
		WHERE TABLE_NAME = UPPER('WFProviderTable');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			EXECUTE IMMEDIATE 
			'CREATE table WFProviderTable(
				Type 				INT 			NOT NULL,
				TypeId 				INT 			NOT NULL,
				ProcessDefId 		INT 			NOT NULL,	
				ProviderOrderId 	INT 			NOT NULL,
				ProviderName  		NVARCHAR2(255) 	NOT NULL,
				constraint pk_WFProviderTable PRIMARY KEY (Type,TypeId,ProcessDefId,ProviderOrderId)
			)';
			dbms_output.put_line ('Table WFProviderTable Created successfully');
	END;
	
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_TABLES  
		WHERE TABLE_NAME = UPPER('WFConsumerTable');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			EXECUTE IMMEDIATE 
			'create table WFConsumerTable(
				Type 			INT 			NOT NULL,
				TypeId 			INT 			NOT NULL,
				ProcessDefId 	INT 			NOT NULL,	
				ConsumerOrderId INT 			NOT NULL,
				ConsumerName 	NVARCHAR2(255) 	NOT NULL,
				constraint pk_WFConsumerTable PRIMARY KEY (Type,TypeId,ProcessDefId,ConsumerOrderId)
			)';
			dbms_output.put_line ('Table WFConsumerTable Created successfully');
	END;
	
	
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_TABLES  
		WHERE TABLE_NAME = UPPER('WFPoolTable');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			EXECUTE IMMEDIATE 
			'create TABLE WFPoolTable(
				ProcessDefId 		INT 			NOT NULL,
				PoolId 				INT 			NOT NULL,
				PoolName 			NVARCHAR2(255) 	NULL,
				PoolWidth 			INT 			NOT NULL,
				PoolHeight 			INT 			NOT NULL,
				ITop 				INT 			NOT NULL,
				ILeft 				INT 			NOT NULL,
				BackColor 			NVARCHAR2(255) 	NULL,   
				CONSTRAINT pk_WFPoolTable PRIMARY KEY (ProcessDefId,PoolId),
				CONSTRAINT uk_WFPoolTable UNIQUE (ProcessDefId,PoolName)
			)';
			dbms_output.put_line ('Table WFPoolTable Created successfully');
	END;
	
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_TABLES  
		WHERE TABLE_NAME = UPPER('WFRecordedChats');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			EXECUTE IMMEDIATE 
			'CREATE TABLE WFRecordedChats(
				ProcessDefId 		INT 			NOT NULL,
				ProcessName 		NVARCHAR2(255) 	NULL,
				SavedBy 			NVARCHAR2(255) 	NULL,
				SavedAt 			DATE 		NOT NULL,
				ChatId 				NVARCHAR2(255) 	NOT NULL,
				Chat 				NVARCHAR2(2000) 	NULL,
				ChatStartTime 		DATE 			NOT NULL,
				ChatEndTime 		DATE 			NOT NULL
			)';
			dbms_output.put_line ('Table WFRecordedChats Created successfully');
	END;
	
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_TABLES  
		WHERE TABLE_NAME = UPPER('WFRequirementTable');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			EXECUTE IMMEDIATE 
			'CREATE TABLE WFRequirementTable(
				ProcessDefId		INT		NOT NULL,
				ReqType				INT		NOT NULL,
				ReqId				INT		NOT NULL,
				ReqName				NVARCHAR2(255)	NOT	NULL,
				ReqDesc				NCLOB			NULL,
				ReqPriority			INT				NULL,
				ReqTypeId			INT		NOT NULL,
				ReqImpl				NCLOB			NULL,
				CONSTRAINT pk_WFRequirementTable PRIMARY KEY (ProcessDefId, ReqType, ReqId, ReqTypeId)
			)';
			dbms_output.put_line ('Table WFRequirementTable Created successfully');
	END;
	
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_TABLES  
		WHERE TABLE_NAME = UPPER('WFDocBuffer');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			EXECUTE IMMEDIATE 
			'CREATE TABLE WFDocBuffer(
				ProcessDefId 	INT NOT NULL,
				ActivityId 		INT NOT NULL ,
				DocName 		NVARCHAR2(255) NOT NULL,
				DocId 			INT		NOT NULL,
				DocumentBuffer  NCLOB NOT NULL,
				Status 			NVARCHAR2(1) 	DEFAULT ''S'' NOT NULL,
				PRIMARY KEY (ProcessDefId, ActivityId, DocId)
			)';
			dbms_output.put_line ('Table WFDocBuffer Created successfully');
	END;
	
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_TABLES  
		WHERE TABLE_NAME = UPPER('WFLaneQueueTable');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			EXECUTE IMMEDIATE 
			'Create Table WFLaneQueueTable (
				ProcessDefId 	INT NOT NULL,
				SwimLaneId 		INT NOT NULL ,
				QueueID 		INT	NOT NULL,
				PRIMARY KEY (ProcessDefId, SwimLaneId, QueueID)
			)';
			dbms_output.put_line ('Table WFLaneQueueTable Created successfully');
	END;
	
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_TABLES  
		WHERE TABLE_NAME = UPPER('WFCreateChildWITable');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			EXECUTE IMMEDIATE 
			'Create Table WFCreateChildWITable(
				ProcessDefId		INT NOT NULL,
				TriggerId			INT NOT NULL,
				WorkstepName		NVARCHAR2(255), 
				Type		NVARCHAR2(1), 
				GenerateSameParent	NVARCHAR2(1), 
				VariableId			INT, 
				VarFieldId			INT,
				PRIMARY KEY (Processdefid , TriggerId)
			)';
			dbms_output.put_line ('Table WFCreateChildWITable Created successfully');
	END;
	
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_TABLES  
		WHERE TABLE_NAME = UPPER('CONFLICTINGQUEUEUSERTABLE');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			EXECUTE IMMEDIATE 
			'CREATE TABLE CONFLICTINGQUEUEUSERTABLE(
				ConflictId				INTEGER			NOT NULL PRIMARY KEY,
				QueueId 				INTEGER 		NOT NULL,
				UserId 					INTEGER 		NOT NULL,
				ASsociationType 		INTEGER 		NOT NULL,
				ASsignedTillDATETIME	TIMESTAMP		NULL, 
				QueryFilter				VARCHAR(2000)	NULL,
				QueryPreview			VARCHAR(1),
				RevisionNo				INTEGER,
				ProcessDefId			INTEGER
			)';
			EXECUTE IMMEDIATE 'CREATE SEQUENCE ConflictIdSequence INCREMENT BY 1 START WITH 1 NOCACHE';
			dbms_output.put_line ('Table CONFLICTINGQUEUEUSERTABLE Created successfully');
	END;
	
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_TABLES  
		WHERE TABLE_NAME = UPPER('WFWorkdeskLayoutTable');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			EXECUTE IMMEDIATE 
			'CREATE TABLE WFWorkdeskLayoutTable (
				ProcessDefId  		INT		NOT NULL,
				ActivityId    		INT 	NOT NULL,
				WSLayoutDefinition 	VARCHAR2(4000),
				PRIMARY KEY (ProcessDefId, ActivityId)
			)';
			dbms_output.put_line ('Table WFWorkdeskLayoutTable Created successfully');
			v_STR1 := 'Insert into WFWorkdeskLayoutTable (ProcessDefId, ActivityId, WSLayoutDefinition) values (0, 0, ''<WDeskLayout Interfaces="4"><Resolution><ScreenWidth>1024</ScreenWidth><ScreenHeight>768</ScreenHeight></Resolution>        <WDeskInterfaces><Interface Type=''''FormView'''' Top=''''50'''' Left=''''2'''' Width=''''501'''' Height=''''615''''/><Interface Type=''''Document'''' Top=''''50'''' Left=''''510'''' Width=''''501'''' Height=''''615''''/></WDeskInterfaces><MenuInterfaces><Interface Type="Exceptions"/><Interface Type="ToDoList"/></MenuInterfaces></WDeskLayout>'')';
			
			EXECUTE IMMEDIATE v_STR1;
	END;	
	
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_TABLES  
		WHERE TABLE_NAME = UPPER('WFProfileTable');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			EXECUTE IMMEDIATE 
			'Create Table WFProfileTable(
				ProfileId					INT NOT NULL PRIMARY KEY,
				ProfileName					NVARCHAR2(50),
				Description					NVARCHAR2(255),
				Deletable					NVARCHAR2(1),
				CreatedOn					DATE,
				LastModifiedOn				DATE,
				OwnerId						INT,
				OwnerName					NVARCHAR2(64),
				CONSTRAINT u_prftable UNIQUE (ProfileName)   
			)';
			EXECUTE IMMEDIATE 'CREATE SEQUENCE ProfileIdSequence INCREMENT BY 1 START WITH 1 NOCACHE';
			dbms_output.put_line ('Table WFProfileTable Created successfully');
	END;
	
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_TABLES  
		WHERE TABLE_NAME = UPPER('WFObjectListTable');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			EXECUTE IMMEDIATE 
			'Create Table WFObjectListTable(
				ObjectTypeId				INT  NOT NULL PRIMARY KEY,
				ObjectType					NVARCHAR2(20),
				ObjectTypeName				NVARCHAR2(50),
				ParentObjectTypeId			INT,
				ClassName					NVARCHAR2(255),
				DefaultRight				NVARCHAR2(100),
				List						NVARCHAR2(1)
			)';
			EXECUTE IMMEDIATE 'CREATE SEQUENCE ObjectTypeIdSequence INCREMENT BY 1 START WITH 1 NOCACHE';
			dbms_output.put_line ('Table WFObjectListTable Created successfully');
	END;

	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_TABLES  
		WHERE TABLE_NAME = UPPER('WFAssignableRightsTable');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			EXECUTE IMMEDIATE 
			'Create Table WFAssignableRightsTable(
				ObjectTypeId		INT,
				RightFlag			NVARCHAR2(50),
				RightName			NVARCHAR2(50),
				OrderBy				INT
			)';
			dbms_output.put_line ('Table WFAssignableRightsTable Created successfully');
	END;
	
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_TABLES  
		WHERE TABLE_NAME = UPPER('WFProfileObjTypeTable');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			EXECUTE IMMEDIATE 
			'Create Table WFProfileObjTypeTable(
				UserId					INT 		NOT NULL ,
				AssociationType			INT 		NOT NULL ,
				ObjectTypeId			INT 		NOT NULL ,
				RightString				NVARCHAR2(100),
				Filter					NVARCHAR2(255),
				PRIMARY KEY(UserId, AssociationType, ObjectTypeId, RightString)
			)';
			dbms_output.put_line ('Table WFProfileObjTypeTable Created successfully');
	END;
	
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_TABLES  
		WHERE TABLE_NAME = UPPER('WFUserObjAssocTable');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			EXECUTE IMMEDIATE 
			'Create Table WFUserObjAssocTable(
				ObjectId					INT 		NOT NULL ,
				ObjectTypeId				INT 		NOT NULL ,
				ProfileId					INT,
				UserId						INT 		NOT NULL ,
				AssociationType				INT 		NOT NULL ,
				AssignedTillDATETIME		DATE,
				AssociationFlag				NVARCHAR2(1),
				PRIMARY KEY(ObjectId, ObjectTypeId, ProfileId, UserId, AssociationType)
			)';
			dbms_output.put_line ('Table WFUserObjAssocTable Created successfully');
	END;
	
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_TABLES  
		WHERE TABLE_NAME = UPPER('WFFilterListTable');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			EXECUTE IMMEDIATE 
			'Create Table WFFilterListTable(
				ObjectTypeId			INT NOT NULL,
				FilterName				NVARCHAR2(50),
				TagName					NVARCHAR2(50)
			)';
			dbms_output.put_line ('Table WFFilterListTable Created successfully');
	END;
	
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_TABLES  
		WHERE TABLE_NAME = UPPER('WFLASTREMINDERTABLE');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			EXECUTE IMMEDIATE 
			'CREATE TABLE WFLASTREMINDERTABLE (
				USERID 				INT NOT NULL,
				LASTREMINDERTIME	DATE 
			)';
			dbms_output.put_line ('Table WFLASTREMINDERTABLE Created successfully');
	END;
	
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_TABLES  
		WHERE TABLE_NAME = UPPER( 'WFUnderlyingDMS');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			EXECUTE IMMEDIATE 
			'CREATE TABLE WFUnderlyingDMS (
				DMSType		INT				NOT NULL,
				DMSName		NVARCHAR2(255)	NULL
			)';
			dbms_output.put_line ('Table WFUnderlyingDMS Created successfully');
	END;
	
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_TABLES  
		WHERE TABLE_NAME = UPPER( 'WFSharePointInfo');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			EXECUTE IMMEDIATE 
			'CREATE TABLE WFSharePointInfo (
				ServiceURL		NVARCHAR2(255)	NULL,
				ProxyEnabled	NVARCHAR2(200)	NULL,
				ProxyIP			NVARCHAR2(20)	NULL,
				ProxyPort		NVARCHAR2(200)	NULL,
				ProxyUser		NVARCHAR2(200)	NULL,
				ProxyPassword	NVARCHAR2(512)	NULL,
				SPWebUrl		NVARCHAR2(200)	NULL
			)';
			dbms_output.put_line ('Table WFSharePointInfo Created successfully');
	END;
	
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_TABLES  
		WHERE TABLE_NAME = UPPER( 'WFDMSLibrary');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			EXECUTE IMMEDIATE 
			'CREATE TABLE WFDMSLibrary (
				LibraryId			INT				NOT NULL 	PRIMARY KEY,
				URL			NVARCHAR2(255)	NULL,
				DocumentLibrary		NVARCHAR2(255)	NULL
			)';
			EXECUTE IMMEDIATE 'CREATE SEQUENCE LibraryId INCREMENT BY 1 START WITH 1 NOCACHE';
			dbms_output.put_line ('Table WFDMSLibrary Created successfully');
	END;
	
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_TABLES  
		WHERE TABLE_NAME = UPPER( 'WFProcessSharePointAssoc');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			EXECUTE IMMEDIATE 
			'CREATE TABLE WFProcessSharePointAssoc (
				ProcessDefId			INT		NOT NULL,
				LibraryId				INT		NULL,
				PRIMARY KEY (ProcessDefId)
			)';
			dbms_output.put_line ('Table WFProcessSharePointAssoc Created successfully');
	END;
	
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_TABLES  
		WHERE TABLE_NAME = UPPER( 'WFArchiveInSharePoint');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			EXECUTE IMMEDIATE 
			'CREATE TABLE WFArchiveInSharePoint (
				ProcessDefId			INT				NULL,
				ActivityID				INT				NULL,
				URL					 	NVARCHAR2(255)	NULL,		
				SiteName				NVARCHAR2(255)	NULL,
				DocumentLibrary			NVARCHAR2(255)	NULL,
				FolderName				NVARCHAR2(255)	NULL,
				ServiceURL 				NVARCHAR2(255) 	NULL,
				DiffFolderLoc			NVARCHAR2(2) 	NULL,
				SameAssignRights		NVARCHAR2(2) 	NULL
			)';
			dbms_output.put_line ('Table WFArchiveInSharePoint Created successfully');
	END;
	
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_TABLES  
		WHERE TABLE_NAME = UPPER( 'WFSharePointDataMapTable');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			EXECUTE IMMEDIATE 
			'CREATE TABLE WFSharePointDataMapTable (
				ProcessDefId			INT				NULL,
				ActivityID				INT				NULL,
				FieldId					INT				NULL,
				FieldName				NVARCHAR2(255)	NULL,
				FieldType				INT				NULL,
				MappedFieldName			NVARCHAR2(255)	NULL,
				VariableID				NVARCHAR2(255)	NULL,
				VarFieldID				NVARCHAR2(255)	NULL
				
			)';
			dbms_output.put_line ('Table WFSharePointDataMapTable Created successfully');
	END;
	
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_TABLES  
		WHERE TABLE_NAME = UPPER( 'WFSharePointDocAssocTable');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			EXECUTE IMMEDIATE 
			'CREATE TABLE WFSharePointDocAssocTable (
				ProcessDefId			INT				NULL,
				ActivityID				INT				NULL,
				DocTypeID				INT				NULL,
				AssocFieldName			NVARCHAR2(255)	NULL,
				FolderName				NVARCHAR2(255)	NULL
			)
';
			dbms_output.put_line ('Table WFSharePointDocAssocTable Created successfully');
	END;
	
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_TABLES  
		WHERE TABLE_NAME = UPPER( 'WFMsgAFTable');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			EXECUTE IMMEDIATE 
			'CREATE TABLE WFMsgAFTable(
				ProcessDefId 	INT NOT NULL,
				MsgAFId 		INT NOT NULL,
				xLeft 			INT NULL,
				yTop 			INT NULL,
				MsgAFName 		NVARCHAR2(255) NULL,
				SwimLaneId 		INT NOT NULL,
				PRIMARY KEY ( ProcessDefId, MsgAFId, SwimLaneId)
			)';
			dbms_output.put_line ('Table WFMsgAFTable Created successfully');
	END;
	
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_TABLES  
		WHERE TABLE_NAME = UPPER( 'WFCreateChildWITable');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			EXECUTE IMMEDIATE 
			'Create Table WFCreateChildWITable(
				ProcessDefId		INT NOT NULL,
				TriggerId			INT NOT NULL,
				WorkstepName		NVARCHAR2(255), 
				Type		NVARCHAR2(1), 
				GenerateSameParent	NVARCHAR2(1), 
				VariableId			INT, 
				VarFieldId			INT
				PRIMARY KEY (Processdefid , TriggerId)
			)';
			dbms_output.put_line ('Table WFCreateChildWITable Created successfully');
	END;
	
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_TABLES  
		WHERE TABLE_NAME = UPPER( 'GTempObjectRightsTable');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			EXECUTE IMMEDIATE 
			'CREATE GLOBAL TEMPORARY TABLE GTempObjectRightsTable (
				AssociationType 	INT,
				ObjectId 			INT, 
				ObjectName 			NVARCHAR2(64),
				RightString 		NVARCHAR2(100)
			) ON COMMIT PRESERVE ROWS';
			dbms_output.put_line ('Table GTempObjectRightsTable Created successfully');
	END;
/* ...................................... End Of New Table Add ...........................................*/

/* ................................... Adding new Sequence .................................*/

	BEGIN
		SELECT LAST_NUMBER INTO v_lastSeqValue
		FROM USER_SEQUENCES
		WHERE SEQUENCE_NAME = UPPER('ProcessDefId');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'CREATE SEQUENCE ProcessDefId INCREMENT BY 1 START WITH 1 NOCACHE';
			dbms_output.put_line ('SEQUENCE ProcessDefId Successfully Created');
	END;
	
	BEGIN
		SELECT LAST_NUMBER INTO v_lastSeqValue
		FROM USER_SEQUENCES
		WHERE SEQUENCE_NAME = UPPER('RevisionNoSequence');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'CREATE SEQUENCE RevisionNoSequence INCREMENT BY 1 START WITH 1 NOCACHE';
			dbms_output.put_line ('SEQUENCE RevisionNoSequence Successfully Created');
	END;

	BEGIN
		SELECT LAST_NUMBER INTO v_lastSeqValue
		FROM USER_SEQUENCES
		WHERE SEQUENCE_NAME = UPPER('Export_Sequence');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'CREATE SEQUENCE Export_Sequence INCREMENT BY 1 START WITH 1';
			dbms_output.put_line ('SEQUENCE Export_Sequence Successfully Created');

	END;
	
	BEGIN
		SELECT LAST_NUMBER INTO v_lastSeqValue
		FROM USER_SEQUENCES
		WHERE SEQUENCE_NAME = UPPER('Export_Sequence');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'CREATE SEQUENCE Export_Sequence INCREMENT BY 1 START WITH 1';
			dbms_output.put_line ('SEQUENCE Export_Sequence Successfully Created');

	END;
/* ...................................... End Of New Sequence Addition ...........................................*/

/* ................................... Adding new Index.................................*/

	existsflag :=0;
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM DUAL 
		WHERE 
			NOT EXISTS( 
				SELECT 1 FROM user_indexes WHERE index_name=UPPER('IDX1_ActivityTable')
			);  
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			existsFlag := 0; 
	END; 
	IF existsFlag = 1 THEN
	BEGIN
		EXECUTE IMMEDIATE 'CREATE INDEX IDX1_ActivityTable ON ActivityTable (ActivityType)';
		dbms_output.put_line ('Index on ActivityType of ActivityTable created successfully');
	EXCEPTION 
		WHEN OTHERS THEN 
		BEGIN 
			IF SQLCODE <> -1408 THEN
			BEGIN
				RAISE;
			END;
			END IF;
		END;
	END;
	END IF;
	
	existsflag :=0;
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM DUAL 
		WHERE 
			NOT EXISTS( 
				SELECT 1 FROM user_indexes WHERE index_name=UPPER('IDX4_WFCRouteLogTable')
			);  
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			existsFlag := 0; 
	END; 
	IF existsFlag = 1 THEN
	BEGIN
		EXECUTE IMMEDIATE 'CREATE INDEX IDX4_WFCRouteLogTable ON WFCurrentRouteLogTable (ProcessInstanceId, ActionDateTime, LogID)';
		dbms_output.put_line ('Index on ProcessInstanceId, ActionDateTime, LogID of WFCurrentRouteLogTable created successfully');
	EXCEPTION 
		WHEN OTHERS THEN 
		BEGIN 
			IF SQLCODE <> -1408 THEN
			BEGIN
				RAISE;
			END;
			END IF;
		END;
	END;
	END IF;
	
	existsflag :=0;
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM DUAL 
		WHERE 
			NOT EXISTS( 
				SELECT 1 FROM user_indexes WHERE index_name=UPPER('IDX4_WFHRouteLogTABLE')
			);  
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			existsFlag := 0; 
	END; 
	IF existsFlag = 1 THEN
	BEGIN
		EXECUTE IMMEDIATE 'CREATE INDEX  IDX4_WFHRouteLogTABLE ON WFHISTORYROUTELOGTABLE (ProcessInstanceId, ActionDateTime, LogID)';
		dbms_output.put_line ('Index on ProcessInstanceId, ActionDateTime, LogID of WFHISTORYROUTELOGTABLE created successfully');
	EXCEPTION 
		WHEN OTHERS THEN 
		BEGIN 
			IF SQLCODE <> -1408 THEN
			BEGIN
				RAISE;
			END;
			END IF;
		END;
	END;
	END IF;
	
	existsflag :=0;
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM DUAL 
		WHERE 
			NOT EXISTS( 
				SELECT 1 FROM user_indexes WHERE index_name=UPPER('IDX2_SUMMARYTABLE')
			);  
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			existsFlag := 0; 
	END; 
	IF existsFlag = 1 THEN
	BEGIN
		EXECUTE IMMEDIATE 'CREATE INDEX  IDX2_SUMMARYTABLE ON SUMMARYTABLE (ProcessDefId, ActionId)';
		dbms_output.put_line ('Index on ProcessDefId, ActionId of SUMMARYTABLE created successfully');
	EXCEPTION 
		WHEN OTHERS THEN 
		BEGIN 
			IF SQLCODE <> -1408 THEN
			BEGIN
				RAISE;
			END;
			END IF;
		END;
	END;
	END IF;
	
	existsflag :=0;
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM DUAL 
		WHERE 
			NOT EXISTS( 
				SELECT 1 FROM user_indexes WHERE index_name=UPPER('IDX2_QueueHistoryTable')
			);  
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			existsFlag := 0; 
	END; 
	IF existsFlag = 1 THEN
	BEGIN
		EXECUTE IMMEDIATE 'CREATE INDEX  IDX2_QueueHistoryTable ON QueueHistoryTable (ActivityName)';
		dbms_output.put_line ('Index on ActivityName of QueueHistoryTable created successfully');
	EXCEPTION 
		WHEN OTHERS THEN 
		BEGIN 
			IF SQLCODE <> -1408 THEN
			BEGIN
				RAISE;
			END;
			END IF;
		END;
	END;
	END IF;
	
	existsflag :=0;
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM DUAL 
		WHERE 
			NOT EXISTS( 
				SELECT 1 FROM user_indexes WHERE index_name=UPPER('IDX3_QueueHistoryTable')
			);  
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			existsFlag := 0; 
	END; 
	IF existsFlag = 1 THEN
	BEGIN
		EXECUTE IMMEDIATE 'CREATE INDEX  IDX3_QueueHistoryTable ON QueueHistoryTable (VAR_REC_1, VAR_REC_2)';
		dbms_output.put_line ('Index on VAR_REC_1, VAR_REC_2 of QueueHistoryTable created successfully');
	EXCEPTION 
		WHEN OTHERS THEN 
		BEGIN 
			IF SQLCODE <> -1408 THEN
			BEGIN
				RAISE;
			END;
			END IF;
		END;
	END;
	END IF;
	
	existsflag :=0;
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM DUAL 
		WHERE 
			NOT EXISTS( 
				SELECT 1 FROM user_indexes WHERE index_name=UPPER('IDX4_QueueHistoryTable')
			);  
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			existsFlag := 0; 
	END; 
	IF existsFlag = 1 THEN
	BEGIN
		EXECUTE IMMEDIATE 'CREATE INDEX  IDX4_QueueHistoryTable ON QueueHistoryTable (Q_QueueId)';
		dbms_output.put_line ('Index on Q_QueueId of QueueHistoryTable created successfully');
	EXCEPTION 
		WHEN OTHERS THEN 
		BEGIN 
			IF SQLCODE <> -1408 THEN
			BEGIN
				RAISE;
			END;
			END IF;
		END;
	END;
	END IF;
	
	existsflag :=0;
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM DUAL 
		WHERE 
			NOT EXISTS( 
				SELECT 1 FROM user_indexes WHERE index_name=UPPER('IDX2_WORKDONETABLE')
			);  
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			existsFlag := 0; 
	END; 
	IF existsFlag = 1 THEN
	BEGIN
		EXECUTE IMMEDIATE 'CREATE INDEX IDX2_WORKDONETABLE ON WORKDONETABLE (ActivityName)';
		dbms_output.put_line ('Index on ActivityName of WORKDONETABLE created successfully');
	EXCEPTION 
		WHEN OTHERS THEN 
		BEGIN 
			IF SQLCODE <> -1408 THEN
			BEGIN
				RAISE;
			END;
			END IF;
		END;
	END;
	END IF;
	
	existsflag :=0;
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM DUAL 
		WHERE 
			NOT EXISTS( 
				SELECT 1 FROM user_indexes WHERE index_name=UPPER('IDX4_WorkListTable')
			);  
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			existsFlag := 0; 
	END; 
	IF existsFlag = 1 THEN
	BEGIN
		EXECUTE IMMEDIATE 'CREATE INDEX IDX4_WorkListTable ON WORKLISTTABLE (Q_UserID, ProcessInstanceId, WorkitemId)';
		dbms_output.put_line ('Index on Q_UserID, ProcessInstanceId, WorkitemId of WORKLISTTABLE created successfully');
	EXCEPTION 
		WHEN OTHERS THEN 
		BEGIN 
			IF SQLCODE <> -1408 THEN
			BEGIN
				RAISE;
			END;
			END IF;
		END;
	END;
	END IF;
	
	existsflag :=0;
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM DUAL 
		WHERE 
			NOT EXISTS( 
				SELECT 1 FROM user_indexes WHERE index_name=UPPER('IDX5_WorkListTable')
			);  
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			existsFlag := 0; 
	END; 
	IF existsFlag = 1 THEN
	BEGIN
		EXECUTE IMMEDIATE 'CREATE INDEX IDX5_WorkListTable ON WORKLISTTABLE (ActivityName)';
		dbms_output.put_line ('Index on ActivityName of WORKLISTTABLE created successfully');
	EXCEPTION 
		WHEN OTHERS THEN 
		BEGIN 
			IF SQLCODE <> -1408 THEN
			BEGIN
				RAISE;
			END;
			END IF;
		END;
	END;
	END IF;
	
	existsflag :=0;
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM DUAL 
		WHERE 
			NOT EXISTS( 
				SELECT 1 FROM user_indexes WHERE index_name=UPPER('IDX6_WorkListTable')
			);  
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			existsFlag := 0; 
	END; 
	IF existsFlag = 1 THEN
	BEGIN
		EXECUTE IMMEDIATE 'CREATE INDEX IDX6_WorkListTable ON WORKLISTTABLE (ProcessDefId, ActivityId)';
		dbms_output.put_line ('Index on ProcessDefId, ActivityId of WORKLISTTABLE created successfully');
	EXCEPTION 
		WHEN OTHERS THEN 
		BEGIN 
			IF SQLCODE <> -1408 THEN
			BEGIN
				RAISE;
			END;
			END IF;
		END;
	END;
	END IF;
	
	existsflag :=0;
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM DUAL 
		WHERE 
			NOT EXISTS( 
				SELECT 1 FROM user_indexes WHERE index_name=UPPER('IDX4_WorkInProcessTable')
			);  
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			existsFlag := 0; 
	END; 
	IF existsFlag = 1 THEN
	BEGIN
		EXECUTE IMMEDIATE 'CREATE INDEX IDX4_WorkInProcessTable ON WorkInProcessTable (Q_UserID, ProcessInstanceId, WorkitemId)';
		dbms_output.put_line ('Index on Q_UserID, ProcessInstanceId, WorkitemId of WorkInProcessTable created successfully');
	EXCEPTION 
		WHEN OTHERS THEN 
		BEGIN 
			IF SQLCODE <> -1408 THEN
			BEGIN
				RAISE;
			END;
			END IF;
		END;
	END;
	END IF;
	
	existsflag :=0;
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM DUAL 
		WHERE 
			NOT EXISTS( 
				SELECT 1 FROM user_indexes WHERE index_name=UPPER('IDX5_WorkInProcessTable')
			);  
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			existsFlag := 0; 
	END; 
	IF existsFlag = 1 THEN
	BEGIN
		EXECUTE IMMEDIATE 'CREATE INDEX IDX5_WorkInProcessTable ON WorkInProcessTable (ActivityName)';
		dbms_output.put_line ('Index on ActivityName of WorkInProcessTable created successfully');
	EXCEPTION 
		WHEN OTHERS THEN 
		BEGIN 
			IF SQLCODE <> -1408 THEN
			BEGIN
				RAISE;
			END;
			END IF;
		END;
	END;
	END IF;
	
	existsflag :=0;
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM DUAL 
		WHERE 
			NOT EXISTS( 
				SELECT 1 FROM user_indexes WHERE index_name=UPPER('IDX1_WorkWithPSTable')
			);  
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			existsFlag := 0; 
	END; 
	IF existsFlag = 1 THEN
	BEGIN
		EXECUTE IMMEDIATE 'CREATE INDEX IDX1_WorkWithPSTable ON WorkWithPSTable (Q_UserID, ProcessInstanceId, WorkitemId)';
		dbms_output.put_line ('Index on Q_UserID, ProcessInstanceId, WorkitemId of WorkWithPSTable created successfully');
	EXCEPTION 
		WHEN OTHERS THEN 
		BEGIN 
			IF SQLCODE <> -1408 THEN
			BEGIN
				RAISE;
			END;
			END IF;
		END;
	END;
	END IF;
	
	existsflag :=0;
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM DUAL 
		WHERE 
			NOT EXISTS( 
				SELECT 1 FROM user_indexes WHERE index_name=UPPER('IDX2_WorkWithPSTable')
			);  
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			existsFlag := 0; 
	END; 
	IF existsFlag = 1 THEN
	BEGIN
		EXECUTE IMMEDIATE 'CREATE INDEX IDX2_WorkWithPSTable ON WorkWithPSTable (ActivityName)';
		dbms_output.put_line ('Index on ActivityName of WorkWithPSTable created successfully');
	EXCEPTION 
		WHEN OTHERS THEN 
		BEGIN 
			IF SQLCODE <> -1408 THEN
			BEGIN
				RAISE;
			END;
			END IF;
		END;
	END;
	END IF;
	
	existsflag :=0;
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM DUAL 
		WHERE 
			NOT EXISTS( 
				SELECT 1 FROM user_indexes WHERE index_name=UPPER('IDX1_PendingWorkListTable')
			);  
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			existsFlag := 0; 
	END; 
	IF existsFlag = 1 THEN
	BEGIN
		EXECUTE IMMEDIATE 'CREATE INDEX IDX1_PendingWorkListTable ON PendingWorkListTable (Q_UserID, ProcessInstanceId, WorkitemId)';
		dbms_output.put_line ('Index on Q_UserID, ProcessInstanceId, WorkitemId of PendingWorkListTable created successfully');
	EXCEPTION 
		WHEN OTHERS THEN 
		BEGIN 
			IF SQLCODE <> -1408 THEN
			BEGIN
				RAISE;
			END;
			END IF;
		END;
	END;
	END IF;
	
	existsflag :=0;
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM DUAL 
		WHERE 
			NOT EXISTS( 
				SELECT 1 FROM user_indexes WHERE index_name=UPPER('IDX2_PendingWorkListTable')
			);  
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			existsFlag := 0; 
	END; 
	IF existsFlag = 1 THEN
	BEGIN
		EXECUTE IMMEDIATE 'CREATE INDEX IDX2_PendingWorkListTable ON PendingWorkListTable (ActivityName)';
		dbms_output.put_line ('Index on ActivityName of PendingWorkListTable created successfully');
	EXCEPTION 
		WHEN OTHERS THEN 
		BEGIN 
			IF SQLCODE <> -1408 THEN
			BEGIN
				RAISE;
			END;
			END IF;
		END;
	END;
	END IF;
	
	existsflag :=0;
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM DUAL 
		WHERE 
			NOT EXISTS( 
				SELECT 1 FROM user_indexes WHERE index_name=UPPER('IDX2_QueueStreamTable')
			);  
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			existsFlag := 0; 
	END; 
	IF existsFlag = 1 THEN
	BEGIN
		EXECUTE IMMEDIATE 'CREATE INDEX IDX2_QueueStreamTable ON QueueStreamTable (Activityid, Streamid)';
		dbms_output.put_line ('Index on Activityid, Streamid of QueueStreamTable created successfully');
	EXCEPTION 
		WHEN OTHERS THEN 
		BEGIN 
			IF SQLCODE <> -1408 THEN
			BEGIN
				RAISE;
			END;
			END IF;
		END;
	END;
	END IF;
	
	existsflag :=0;
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM DUAL 
		WHERE 
			NOT EXISTS( 
				SELECT 1 FROM user_indexes WHERE index_name=UPPER('IDX3_ExceptionTable')
			);  
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			existsFlag := 0; 
	END; 
	IF existsFlag = 1 THEN
	BEGIN
		EXECUTE IMMEDIATE 'CREATE INDEX IDX3_ExceptionTable ON ExceptionTable (ProcessDefId, ActivityId)';
		dbms_output.put_line ('Index on ProcessDefId, ActivityId of ExceptionTable created successfully');
	EXCEPTION 
		WHEN OTHERS THEN 
		BEGIN 
			IF SQLCODE <> -1408 THEN
			BEGIN
				RAISE;
			END;
			END IF;
		END;
	END;
	END IF;
	
	existsflag :=0;
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM DUAL 
		WHERE 
			NOT EXISTS( 
				SELECT 1 FROM user_indexes WHERE index_name=UPPER('IDX1_TODOSTATUSTABLE')
			);  
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			existsFlag := 0; 
	END; 
	IF existsFlag = 1 THEN
	BEGIN
		EXECUTE IMMEDIATE 'CREATE INDEX IDX1_TODOSTATUSTABLE ON TODOSTATUSTABLE (ProcessInstanceId)';
		dbms_output.put_line ('Index on ProcessInstanceId of TODOSTATUSTABLE created successfully');
	EXCEPTION 
		WHEN OTHERS THEN 
		BEGIN 
			IF SQLCODE <> -1408 THEN
			BEGIN
				RAISE;
			END;
			END IF;
		END;
	END;
	END IF;
	
	existsflag :=0;
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM DUAL 
		WHERE 
			NOT EXISTS( 
				SELECT 1 FROM user_indexes WHERE index_name=UPPER('IDX1_TODOSTATUSHISTORYTABLE')
			);  
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			existsFlag := 0; 
	END; 
	IF existsFlag = 1 THEN
	BEGIN
		EXECUTE IMMEDIATE 'CREATE INDEX IDX1_TODOSTATUSHISTORYTABLE ON TODOSTATUSHISTORYTABLE (ProcessInstanceId)';
		dbms_output.put_line ('Index on ProcessInstanceId of TODOSTATUSHISTORYTABLE created successfully');
	EXCEPTION 
		WHEN OTHERS THEN 
		BEGIN 
			IF SQLCODE <> -1408 THEN
			BEGIN
				RAISE;
			END;
			END IF;
		END;
	END;
	END IF;
/* ...................................... End Of New Index .....................................*/

/* Dropping columns which was present on the testing cabinet 9.0 which was added during some hotfix release and were causing some issues while checking out the process*/

BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME = UPPER('WFFORM_TABLE') 
		AND COLUMN_NAME = UPPER('ISAPPLETVIEW');
		EXECUTE IMMEDIATE 'ALTER TABLE WFFORM_TABLE DROP COLUMN ISAPPLETVIEW ';
		DBMS_OUTPUT.PUT_LINE('Column ISAPPLETVIEW Dropped');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
		DBMS_OUTPUT.PUT_LINE('Column Does Not exist');
END;

BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME = UPPER('WFSAPCONNECTTABLE') 
		AND COLUMN_NAME = UPPER('SECURITYFLAG');
		EXECUTE IMMEDIATE 'ALTER TABLE WFSAPCONNECTTABLE DROP COLUMN SECURITYFLAG ';
		DBMS_OUTPUT.PUT_LINE('Column SECURITYFLAG Dropped');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
		DBMS_OUTPUT.PUT_LINE('Column Does Not exist');
END;

BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME = UPPER('WFWEBSERVICEINFOTABLE') 
		AND COLUMN_NAME = UPPER('SECURITYFLAG');
		EXECUTE IMMEDIATE 'ALTER TABLE WFWEBSERVICEINFOTABLE DROP COLUMN SECURITYFLAG ';
		DBMS_OUTPUT.PUT_LINE('Column SECURITYFLAG Dropped');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
		DBMS_OUTPUT.PUT_LINE('Column Does Not exist');
END;

/* ................................... Adding new Column in Existing Table .................................*/

	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME = UPPER('PROCESSDEFTABLE') 
		AND 
		COLUMN_NAME = UPPER('Description');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE PROCESSDEFTABLE Add (Description  NCLOB NULL)';			
			EXECUTE IMMEDIATE 'ALTER TABLE PROCESSDEFTABLE Add (CreatedBy NVARCHAR2(255) NULL)';	
			EXECUTE IMMEDIATE 'ALTER TABLE PROCESSDEFTABLE Add (LastModifiedBy NVARCHAR2(255) NULL)';
			EXECUTE IMMEDIATE 'ALTER TABLE PROCESSDEFTABLE Add (ProcessShared NCHAR(1) NULL)';
			EXECUTE IMMEDIATE 'ALTER TABLE PROCESSDEFTABLE Add (ProjectId INT NULL)';
			EXECUTE IMMEDIATE 'ALTER TABLE PROCESSDEFTABLE Add (Cost NUMERIC(15, 2) NULL)';
			EXECUTE IMMEDIATE 'ALTER TABLE PROCESSDEFTABLE Add (Duration NVARCHAR2(255) NULL)';
			EXECUTE IMMEDIATE 'ALTER TABLE PROCESSDEFTABLE Add (FormViewerApp NCHAR(1) NULL)';
			
			DBMS_OUTPUT.PUT_LINE('New Column Added successfully in ProcessDefTable');
			EXECUTE IMMEDIATE 'Update PROCESSDEFTABLE SET Description = '' '',CreatedBy =N''Supervisor'', LastModifiedBy = N''Supervisor'', ProcessShared =N''N'', ProjectId= 1 ,Cost = 0.00,Duration ='''', FormViewerApp = N''A'' ';

	END;
	
	
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME = UPPER('ACTIVITYTABLE') 
		AND 
		COLUMN_NAME = UPPER('ActivitySubType');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE ACTIVITYTABLE Add (ActivitySubType INT NULL)';	
			EXECUTE IMMEDIATE 'ALTER TABLE ACTIVITYTABLE Add (Color INT NULL)';
			EXECUTE IMMEDIATE 'ALTER TABLE ACTIVITYTABLE Add (Cost NUMERIC(15, 2) NULL)';
			EXECUTE IMMEDIATE 'ALTER TABLE ACTIVITYTABLE Add (Duration NVARCHAR2(255) NULL)';
			EXECUTE IMMEDIATE 'ALTER TABLE ACTIVITYTABLE Add (SwimLaneId INT NULL)';
			EXECUTE IMMEDIATE 'ALTER TABLE ACTIVITYTABLE Add (DummyStrColumn1 NVARCHAR2(255) NULL)';
			EXECUTE IMMEDIATE 'ALTER TABLE ACTIVITYTABLE Add (CustomValidation NCLOB)';
			DBMS_OUTPUT.PUT_LINE('New Column Added successfully in ACTIVITYTABLE');
			
			EXECUTE IMMEDIATE 'UPDATE ACTIVITYTABLE SET Color = 1234, Cost = 0.00, Duration = ''0D0H0M'',SwimLaneId = 1, DummyStrColumn1 ='''', CustomValidation ='' ''  ';
/* ActivitySubType Value Updataion */			
			
  
Begin 
    
    v_STR1 := 'select processdefid,activityid, activitytype, AllowSoapRequest  from ACTIVITYTABLE order by ProcessDefId';
    OPEN cur_actSub For v_STR1;
		LOOP
			FETCH  cur_actSub INTO v_ProcessDefId, v_ActivityId_actSub, v_ActivityType_actSub, v_AllowSoapRequest ;
        
		EXIT WHEN cur_actSub%NOTFOUND;
			BEGIN
					v_activitysubtype := 1;
				If ((v_ActivityType_actSub > 3 and v_ActivityType_actSub < 7) or (v_ActivityType_actSub = 3)or (v_ActivityType_actSub = 7) or (v_ActivityType_actSub = 11) or   (v_ActivityType_actSub >= 18) ) then
				DBMS_OUTPUT.PUT_LINE('Case for activitytype = '||v_ActivityType_actSub);
					v_activitysubtype := 1;
				ELSIF (v_ActivityType_actSub = 1 and v_AllowSoapRequest = 'Y')   Then
				DBMS_OUTPUT.PUT_LINE('Case for activitytype = '||v_ActivityType_actSub);
					v_activitysubtype := 2;
				ELSIF (v_ActivityType_actSub = 1 and v_AllowSoapRequest = 'N')    then
				DBMS_OUTPUT.PUT_LINE('Case for activitytype = '||v_ActivityType_actSub);
					v_activitysubtype := 1; 
				ELSIF (v_ActivityType_actSub = 2)  then 
				DBMS_OUTPUT.PUT_LINE('Case for activitytype = '||v_ActivityType_actSub);         
					BEGIN
        				EXECUTE IMMEDIATE 'Select Count(*) from InitiateWorkItemDefTable WHERE activityId = ' || TO_CHAR(v_ActivityId_actSub) || ' AND processDefId = ' || TO_CHAR(v_ProcessDefId) into existsFlag ;
						If existsFlag = 1 then
						DBMS_OUTPUT.PUT_LINE('Case for when data exists inInitiateWorkItemDefTable and  activitytype = '||v_ActivityType_actSub);			
						v_activitysubtype := 2;
						Else
						v_activitysubtype:=1;
						END IF; 
					END;
				ELSIF (v_ActivityType_actSub = 10)  Then
					Begin
						EXECUTE IMMEDIATE 'Select Count(*) from PRINTFAXEMAILTABLE WHERE PFEInterfaceId = ' || TO_CHAR(v_ActivityId_actSub) || ' AND processDefId = ' || TO_CHAR(v_ProcessDefId) into existsFlag;
							BEGIN
								If existsFlag = 1 then
								DBMS_OUTPUT.PUT_LINE('Case for when data exists PRINTFAXEMAILTABLE and  activitytype = '||v_ActivityType_actSub);								
								v_activitysubtype := 1; 
								ELSE
									EXECUTE IMMEDIATE 'Select Count(*) from ARCHIVETABLE WHERE activityid = ' || TO_CHAR(v_ActivityId_actSub) || ' AND processDefId = ' || TO_CHAR(v_ProcessDefId) into existsFlag;
									If existsFlag = 1 then
									DBMS_OUTPUT.PUT_LINE('Case for when data exists ARCHIVETABLE and  activitytype = '||v_ActivityType_actSub);			
									v_activitysubtype := 4;  
									ELSE
										EXECUTE IMMEDIATE 'Select Count(*) from RULEOPERATIONTABLE WHERE activityid = ' || TO_CHAR(v_ActivityId_actSub) || ' AND processDefId = ' || TO_CHAR(v_ProcessDefId) || ' and operationtype = 24 ' into existsFlag ;
										Begin
											If existsFlag = 1 then
											DBMS_OUTPUT.PUT_LINE('Case for when data exists RULEOPERATIONTABLE and  activitytype = '||v_ActivityType_actSub);	     
											v_activitysubtype := 6 ;
                							Else
											v_activitysubtype:= 3;
											END IF;  		
               							END; 
									END IF;
								END IF;
							END;
								    
						END;    
					END IF;    
               
       
		Begin
	        v_STR2 := 'UPDATE Activitytable SET ActivitySubtype = ' || TO_CHAR(v_activitysubtype) || ' Where ProcessDefId = ' || TO_CHAR(v_ProcessDefId) || ' and ActivityId = '|| TO_CHAR(v_ActivityId_actSub);
            DBMS_OUTPUT.PUT_LINE('update query for activityid ='|| v_activityid_actsub||' and ProcessdefId = '||v_ProcessDefId||' QUERY>>>>>>>'||v_STR2);
            Execute Immediate(v_STR2);
		End;
    END;
  END LOOP;
    CLOSE cur_actSub;
End;
/* End Of updating ActivitySubType in ActivityTable*/
			
			

	END;
	
	
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME = UPPER('PROCESSDEFCOMMENTTABLE') 
		AND 
		COLUMN_NAME = UPPER('AnnotationId');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE PROCESSDEFCOMMENTTABLE Add (AnnotationId INT NULL)';	
			EXECUTE IMMEDIATE 'ALTER TABLE PROCESSDEFCOMMENTTABLE Add (SwimLaneId INT NULL)';			
			DBMS_OUTPUT.PUT_LINE('New Column Added successfully in PROCESSDEFCOMMENTTABLE');
			EXECUTE IMMEDIATE 'UPDATE PROCESSDEFCOMMENTTABLE Set SWIMLANEID = 1';
	END;
	
	
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME =UPPER('WORKSTAGELINKTABLE') 
		AND 
		COLUMN_NAME = UPPER('ConnectionId');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE WORKSTAGELINKTABLE Add (ConnectionId	INT  NULL)';						
			DBMS_OUTPUT.PUT_LINE('New Column Added successfully in WORKSTAGELINKTABLE');
			
/* Updating Default Value ConnectionId in WorkstageLink Table*/			

  
Begin 
    
    v_STR1 := 'SELECT Processdefid, SourceId, TargetId  from WORKSTAGELINKTABLE order by processdefid ';
    OPEN cur_coonectionId For v_STR1;
		v_counter:= 1;
	LOOP
			FETCH  cur_coonectionId INTO v_ProcessDefId, v_sourceId, v_targetId ;
        
		EXIT WHEN cur_coonectionId%NOTFOUND;
		Begin
			If(v_previousProcessDefId != v_ProcessDefId) Then
					v_counter:= 1;
			End If;	
			
            v_STR1:= 'UPDATE WORKSTAGELINKTABLE SET ConnectionId = ' || TO_CHAR(v_counter) || ' Where ProcessDefId = ' || TO_CHAR(v_ProcessDefId) || ' and SourceId = '|| TO_CHAR(v_sourceId) || (' and TargetId = '|| TO_CHAR(v_targetId));
	
			Execute Immediate(v_STR1);
			v_counter:= v_counter + 1;
			v_previousProcessDefId:= v_ProcessDefId;
		End;
	END LOOP;
  CLOSE cur_coonectionId;
End;


/*End of Updating Default Value ConnectionId in WorkstageLink Table*/
	END;
	
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME = UPPER('EXTDBCONFTABLE') 
		AND 
		COLUMN_NAME = UPPER('SortingColumn');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE EXTDBCONFTABLE Add (SortingColumn NVARCHAR2(255) NULL)';
			DBMS_OUTPUT.PUT_LINE('New Column Added successfully in EXTDBCONFTABLE');
	END;
	
	
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME = UPPER('TEMPLATEDEFINITIONTABLE') 
		AND 
		COLUMN_NAME = UPPER('Format');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE TEMPLATEDEFINITIONTABLE Add (Format NVARCHAR2(255) NULL)';			
			EXECUTE IMMEDIATE 'ALTER TABLE TEMPLATEDEFINITIONTABLE Add PRIMARY KEY (ProcessdefId,TemplateId)';	
			DBMS_OUTPUT.PUT_LINE('New Column Added successfully in TEMPLATEDEFINITIONTABLE');
			DBMS_OUTPUT.PUT_LINE('Primary Key Added successfully in TEMPLATEDEFINITIONTABLE');
			EXECUTE IMMEDIATE 'UPDATE TEMPLATEDEFINITIONTABLE SET FORMAT = N''DOC'' ';	
	END;
	
	BEGIN
		EXECUTE IMMEDIATE 'UPDATE PROCESSDEFTABLE SET FormViewerApp = N''J'' where FormViewerApp IS NULL';	
		EXECUTE IMMEDIATE 'ALTER TABLE PROCESSDEFTABLE MODIFY(FormViewerApp NCHAR(1) Default N''J'' NOT NULL)';	
	END;
	
/*										BUG 42570
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME = UPPER('EXTDBFIELDDEFINITIONTABLE') 
		AND 
		COLUMN_NAME = UPPER('ExtObjId');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE EXTDBFIELDDEFINITIONTABLE Add (ExtObjId INT NULL)';		
			EXECUTE IMMEDIATE 'ALTER TABLE EXTDBFIELDDEFINITIONTABLE Add PRIMARY KEY (ProcessDefId, ExtObjId, FieldName)';
			DBMS_OUTPUT.PUT_LINE('New Column Added successfully in EXTDBFIELDDEFINITIONTABLE');
			DBMS_OUTPUT.PUT_LINE('Primary Key Added successfully in EXTDBFIELDDEFINITIONTABLE');
	Begin 
    
    v_STR1 := 'select Fieldname, ProcessDefId from ExtDbFieldDefinitionTable';
    OPEN cur_extObjId For v_STR1;
		v_counter:= 1;
	LOOP
			FETCH  cur_extObjId INTO v_fieldName, v_ProcessDefId ;
        
		EXIT WHEN cur_extObjId%NOTFOUND;
		Begin
			Execute Immediate 'select  extobjid from extdbconftable where tablename 
						  in (select table_name FROM  USER_TAB_COLS col WHERE col.COLUMN_NAME = '''||v_fieldName||''') and ProcessDefId = '||TO_CHAR(v_ProcessDefId) into v_extObjId ;
            v_STR1:= 'UPDATE ExtDbfielddefinitiontable SET ExtObjId = ' || TO_CHAR(v_extObjId) || ' Where ProcessDefId = ' || TO_CHAR(v_ProcessDefId) || ' and FieldName = '''|| v_fieldName||'''';
	
			Execute Immediate(v_STR1);
		End;
	END LOOP;
    CLOSE cur_extObjId;
	End;
END;
*/	
BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME = UPPER('EXTDBFIELDDEFINITIONTABLE') 
		AND 
		COLUMN_NAME = UPPER('ExtObjId');
	EXCEPTION
			WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE EXTDBFIELDDEFINITIONTABLE Add (ExtObjId INT NULL)';		
			EXECUTE IMMEDIATE 'UPDATE EXTDBFIELDDEFINITIONTABLE SET ExtObjId = 0 where ExtObjId IS NULL';	
			EXECUTE IMMEDIATE 'ALTER TABLE EXTDBFIELDDEFINITIONTABLE MODIFY(ExtObjId INT NOT NULL)';		
			EXECUTE IMMEDIATE 'ALTER TABLE EXTDBFIELDDEFINITIONTABLE Add PRIMARY KEY (ProcessDefId, ExtObjId, FieldName)';
			
			DBMS_OUTPUT.PUT_LINE('New Column Added successfully in EXTDBFIELDDEFINITIONTABLE');
			DBMS_OUTPUT.PUT_LINE('Primary Key Added successfully in EXTDBFIELDDEFINITIONTABLE');
	BEGIN 
    
    v_STR1 := 'Select ProcessDefId,TableName,ExtObjId From ExtDBConfTable Order By ProcessDefId';
	OPEN cur_extDbField For v_STR1;

	LOOP
			FETCH  cur_extDbField INTO v_ProcessDefId, v_tableName, v_ExtObjId;
			EXIT WHEN cur_extDbField%NOTFOUND;
			
			BEGIN
			DBMS_OUTPUT.PUT_LINE('Table_name = '||v_tableName);
			v_STR2:='Select Column_Name From USER_TAB_COLS WHERE TABLE_NAME = '''||UPPER(v_tableName)||'''';
			--Inner cusror to fetch columns
			
			OPEN cur_getCols For v_STR2;
			
			LOOP
					FETCH  cur_getCols INTO v_colName;
					EXIT WHEN cur_getCols%NOTFOUND;
						BEGIN
							DBMS_OUTPUT.PUT_LINE('Column_name = '||v_colName);
            				EXECUTE IMMEDIATE 'Select count(*) from ExtDBFieldDefinitionTable where processdefid = '||TO_CHAR(v_ProcessDefId)||' AND FieldName = '''||UPPER(v_colName)||'''' INTO existsFlag;
							If existsFlag = 1 THEN
								BEGIN
								v_Query:= 'Update ExtDBFieldDefinitionTable Set ExtObjId = '||TO_CHAR(v_ExtObjId)||' Where ExtObjId = 0';
								EXECUTE IMMEDIATE(v_Query);
								END;
							ELSE
								BEGIN
								EXECUTE IMMEDIATE 'SELECT DATA_TYPE FROM USER_TAB_COLS WHERE COLUMN_NAME = '''||UPPER(v_colName)||''' AND TABLE_NAME = '''||UPPER(v_tableName)||'''' INTO v_colType;
								v_FieldType:= Case v_colType
									WHEN 'NVARCHAR2'	THEN 'STRING'
									WHEN 'VARCHAR2' 	THEN 'STRING'
									WHEN 'LONG' 		THEN 'LONG'
									WHEN 'INTEGER'      THEN 'INTEGER'
									WHEN 'NUMBER'      THEN 'NUMBER'
									WHEN 'FLOAT' 		THEN 'NUMBER'
									WHEN 'CLOB' 		THEN 'CLOB'
									WHEN 'NCLOB' 		THEN 'CLOB'
									WHEN 'TIMESTAMP(6)'    THEN 'TIME'
									WHEN 'DATE' 		THEN 'DATE'
									WHEN 'smallint' 	THEN 'INTEGER'
									END;
									
								v_colLen:= Case v_FieldType
									WHEN 'STRING' 			THEN 50
									WHEN 'LONG'	  			THEN 4
									WHEN 'INTEGER'			THEN 2
									WHEN 'NUMBER'			THEN 15
									WHEN 'DATE'				THEN 8
									WHEN 'TIME'				THEN 8
									WHEN 'CLOB'				THEN 0
									END; 
									
														
								DBMS_OUTPUT.PUT_LINE('Field TYpe>>> '||v_FieldType);
								DBMS_OUTPUT.PUT_LINE('ColLength >>>>'||v_colLen);
								v_Query:='Insert Into ExtDBFieldDefinitionTable(ProcessDefId,FieldName,FieldType,FieldLength,DefaultValue,Attribute,VarPrecision,ExtObjId) Values ( '||TO_CHAR(v_ProcessDefId)||','''||v_colName||''', '''||v_FieldType||''', '||TO_CHAR(v_colLen)||' ,NULL,NULL,2,'||TO_CHAR(v_ExtObjId)||')' ;
								EXECUTE IMMEDIATE(v_Query);
								COMMIT;
								END;	
               				END IF;
						END;
			END LOOP;
			CLOSE cur_getCols;	
			END;
	END LOOP;
	CLOSE cur_extDbField;
	END;
END;
--END of  BUG 42570.

	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME = UPPER('QUEUEDEFTABLE') 
		AND 
		COLUMN_NAME = UPPER('ProcessName');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE QUEUEDEFTABLE Add (ProcessName NVARCHAR2(30) NULL)';			
			DBMS_OUTPUT.PUT_LINE('New Column Added successfully in QUEUEDEFTABLE');
	END;
	
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME = UPPER('QUEUEUSERTABLE') 
		AND 
		COLUMN_NAME = UPPER('RevisionNo');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE QUEUEUSERTABLE Add (RevisionNo INT NULL)';			
			DBMS_OUTPUT.PUT_LINE('New Column Added successfully in QUEUEUSERTABLE');
			EXECUTE IMMEDIATE 'UPDATE  QUEUEUSERTABLE Set REVISIONNO = RevisionNoSequence.nextval';

	END;
	
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME = UPPER('VARALIASTABLE') 
		AND 
		COLUMN_NAME = UPPER('VariableId1');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE VARALIASTABLE Add (VariableId1 INT NULL)';			
			EXECUTE IMMEDIATE 'Alter table VARALIASTABLE add tempType1 smallint';
			EXECUTE IMMEDIATE 'Update VARALIASTABLE set tempType1 = cast(Type1 as smallint)';
			EXECUTE IMMEDIATE 'Alter table VARALIASTABLE drop column Type1';
			EXECUTE IMMEDIATE 'Alter table VARALIASTABLE RENAME COLUMN tempType1 to Type1';
			DBMS_OUTPUT.PUT_LINE('New Column Added successfully in VARALIASTABLE');
	END;	
	
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME = UPPER('WFTMSSETVARIABLEMAPPING') 
		AND 
		COLUMN_NAME = UPPER('VariableId1');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE wftmssetvariablemapping Add (TempALIASRULE varchar2(4000) )';
			EXECUTE IMMEDIATE 'Update wftmssetvariablemapping set tempALIASRULE = cast(ALIASRULE as varchar2(4000))';
			EXECUTE IMMEDIATE 'Alter table wftmssetvariablemapping drop column ALIASRULE';
			EXECUTE IMMEDIATE 'Alter table wftmssetvariablemapping RENAME COLUMN tempALIASRULE to ALIASRULE';
			DBMS_OUTPUT.PUT_LINE('Type Changes successfully in WFTMSSETVARIABLEMAPPING');
	END;	
	
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM QUEUEDEFTABLE
		WHERE QueueName = 'SystemArchiveQueue'; 		
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			
			EXECUTE IMMEDIATE 'Insert into QueueDefTable(QueueId, QueueName, QueueType, Comments, OrderBy, SortOrder) values (QUEUEID.nextval, ''SystemArchiveQueue'', ''A'', ''System generated common Archive Queue'', 10, ''A'')';
			DBMS_OUTPUT.PUT_LINE('Data inserted for SystemArchiveQueue successfully in QUEUEDEFTABLE');
	END;
	
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM QUEUEDEFTABLE
		WHERE QueueName = 'SystemPFEQueue'; 		
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			v_STR1 := 'Insert into QueueDefTable (QueueId, QueueName, QueueType, Comments, OrderBy, SortOrder)
			values (QUEUEID.nextval, ''SystemPFEQueue'', ''A'', ''System generated common PFE Queue'', 10, ''A'')';
			EXECUTE IMMEDIATE v_STR1;
			DBMS_OUTPUT.PUT_LINE('Data inserted for SystemPFEQueue successfully in QUEUEDEFTABLE');
	END;
	
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM QUEUEDEFTABLE
		WHERE QueueName = 'SystemSharePointQueue'; 		
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			v_STR1 := 'Insert into QueueDefTable (QueueId, QueueName, QueueType, Comments, OrderBy, SortOrder)
			values (QUEUEID.nextval, ''SystemSharePointQueue'', ''A'', ''System generated common Share Point Queue'', 10, ''A'')';
			EXECUTE IMMEDIATE v_STR1;
			DBMS_OUTPUT.PUT_LINE('Data inserted for SystemSharePointQueue successfully in QUEUEDEFTABLE');
	END;
	
BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME = UPPER('INITIATEWORKITEMDEFTABLE') 
		AND 
		COLUMN_NAME = UPPER('ImportedProcessDefId');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE INITIATEWORKITEMDEFTABLE Add (ImportedProcessDefId INT NULL)';
			DBMS_OUTPUT.PUT_LINE('New Column Added successfully in INITIATEWORKITEMDEFTABLE');
/* Updating ImportedprocessDefId column in INITIATEWORKITEMDEFTABLE */			
	BEGIN
		SELECT 1 INTO existsFlag FROM USER_TAB_COLUMNS WHERE TABLE_NAME = UPPER('INITIATEWORKITEMDEFTABLE')  AND COLUMN_NAME = UPPER('ImportedProcessDefId');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
		EXECUTE IMMEDIATE 'ALTER TABLE INITIATEWORKITEMDEFTABLE Add (ImportedProcessDefId INT NULL)';
		
		DBMS_OUTPUT.PUT_LINE('New Column Added successfully in INITIATEWORKITEMDEFTABLE');
		
		v_STR1:= 'SELECT importedprocessname  from INITIATEWORKITEMDEFTABLE';
		OPEN cur_ImportPro FOR v_STR1;
	LOOP
		Fetch cur_ImportPro into v_ImportedProName;
		EXIT WHEN cur_ImportPro%NOTFOUND;
		BEGIN
			EXECUTE IMMEDIATE 'Select ProcessDefId from ProcessdefTable Where ProcessName = '''||v_ImportedProName ||''', and VersionNo = (Select MAX(Version) from ProcessDefTable Where ProcessName = '''||v_ImportedProName ||'''';
		END;
	End Loop;
		Close cur_ImportPro;
	END;		
/* End Of Updating ImportedprocessDefId column in INITIATEWORKITEMDEFTABLE */	
END;
	
	
BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME = UPPER('IMPORTEDPROCESSDEFTABLE') 
		AND 
		COLUMN_NAME = UPPER('ImportedProcessDefId');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE IMPORTEDPROCESSDEFTABLE Add (ImportedProcessDefId INT NULL)';
			EXECUTE IMMEDIATE 'ALTER TABLE IMPORTEDPROCESSDEFTABLE Add (ProcessType NVARCHAR2(1) DEFAULT (N''R'') NULL)';
			DBMS_OUTPUT.PUT_LINE('New Column Added successfully in IMPORTEDPROCESSDEFTABLE');
/* Updating ImportedprocessDefId column in IMPORTEDPROCESSDEFTABLE */
BEGIN
		SELECT 1 INTO existsFlag FROM USER_TAB_COLUMNS WHERE TABLE_NAME = UPPER('IMPORTEDPROCESSDEFTABLE')  AND COLUMN_NAME = UPPER('ImportedProcessDefId');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
		EXECUTE IMMEDIATE 'ALTER TABLE IMPORTEDPROCESSDEFTABLE Add (ImportedProcessDefId INT NULL)';
		
		DBMS_OUTPUT.PUT_LINE('New Column Added successfully in IMPORTEDPROCESSDEFTABLE');
		
		v_STR1:= 'SELECT importedprocessname  from IMPORTEDPROCESSDEFTABLE';
		OPEN cur_ImportPro FOR v_STR1;
	LOOP
		Fetch cur_ImportPro into v_ImportedProName;
		EXIT WHEN cur_ImportPro%NOTFOUND;
		BEGIN
			EXECUTE IMMEDIATE 'Select ProcessDefId from ProcessdefTable Where ProcessName = '''||v_ImportedProName ||''', and VersionNo = (Select MAX(Version) from ProcessDefTable Where ProcessName = '''||v_ImportedProName ||'''';
		END;
	End Loop;
		Close cur_ImportPro;
END;		
/* End Of Updating ImportedprocessDefId column in IMPORTEDPROCESSDEFTABLE */			
END;
	
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME = UPPER('WFMAILQUEUETABLE') 
		AND 
		COLUMN_NAME = UPPER('mailBCC');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE WFMAILQUEUETABLE Add (mailBCC NVARCHAR2(512) NULL)';
			DBMS_OUTPUT.PUT_LINE('New Column Added successfully in WFMAILQUEUETABLE');
	END;
	
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME = UPPER('WFMAILQUEUEHISTORYTABLE') 
		AND 
		COLUMN_NAME = UPPER('mailBCC');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE WFMAILQUEUEHISTORYTABLE Add (mailBCC NVARCHAR2(512) NULL)';
			DBMS_OUTPUT.PUT_LINE('New Column Added successfully in WFMAILQUEUEHISTORYTABLE');
	END;
	
	
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME = UPPER('ARCHIVETABLE') 
		AND 
		COLUMN_NAME = UPPER('ArchiveDataClassName');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE ARCHIVETABLE Add (ArchiveDataClassName NVARCHAR2(255) NULL)';
			DBMS_OUTPUT.PUT_LINE('New Column Added successfully in ARCHIVETABLE');
			EXECUTE IMMEDIATE 'UPDATE ARCHIVETABLE SET ArchiveDataClassName = N''SYSTEM_CONFIG''';
			
	END;
	
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME = UPPER('ARCHIVEDATAMAPTABLE') 
		AND 
		COLUMN_NAME = UPPER('DataFieldType');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE ARCHIVEDATAMAPTABLE Add (DataFieldType INT NULL)';
			DBMS_OUTPUT.PUT_LINE('New Column Added successfully in ARCHIVEDATAMAPTABLE');
	END;
	
	
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME = UPPER('CHECKOUTPROCESSESTABLE') 
		AND 
		COLUMN_NAME = UPPER('ActivityId');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE CHECKOUTPROCESSESTABLE Add (ActivityId INT NULL)';
			EXECUTE IMMEDIATE 'ALTER TABLE CHECKOUTPROCESSESTABLE Add (SwimlaneId INT NULL)';
			EXECUTE IMMEDIATE 'ALTER TABLE CHECKOUTPROCESSESTABLE Add (UserId INT NULL)';
			DBMS_OUTPUT.PUT_LINE('New Column Added successfully in CHECKOUTPROCESSESTABLE');
	END;
	
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME = UPPER('EXTMETHODDEFTABLE') 
		AND 
		COLUMN_NAME = UPPER('ConfigurationID');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE EXTMETHODDEFTABLE Add (ConfigurationID INT NULL)';
			DBMS_OUTPUT.PUT_LINE('New Column Added successfully in EXTMETHODDEFTABLE');
	END;
	
	
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME = UPPER('GTempQueueTable') 
		AND 
		COLUMN_NAME = UPPER('TempProcessName');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE GTempQueueTable Add (TempProcessName  Nvarchar2(30) NULL)';			
			DBMS_OUTPUT.PUT_LINE('New Column Added successfully in GTempQueueTable');
	END;
	
	
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME = UPPER('GTEMPWORKLISTTABLE') 
		AND 
		COLUMN_NAME = UPPER('VAR_REC_1');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE GTEMPWORKLISTTABLE Add (VAR_REC_1 NVARCHAR2(255) NULL)';			
			EXECUTE IMMEDIATE 'ALTER TABLE GTEMPWORKLISTTABLE Add (VAR_REC_2 NVARCHAR2(255) NULL)';	
			EXECUTE IMMEDIATE 'ALTER TABLE GTEMPWORKLISTTABLE Add (VAR_REC_3 NVARCHAR2(255) NULL)';	
			EXECUTE IMMEDIATE 'ALTER TABLE GTEMPWORKLISTTABLE Add (VAR_REC_4 NVARCHAR2(255) NULL)';	
			EXECUTE IMMEDIATE 'ALTER TABLE GTEMPWORKLISTTABLE Add (VAR_REC_5 NVARCHAR2(255) NULL)';	
			DBMS_OUTPUT.PUT_LINE('New Column Added successfully in GTEMPWORKLISTTABLE');
	END;
	
	
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME = UPPER('WFSwimLaneTable') 
		AND 
		COLUMN_NAME = UPPER('PoolId');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE WFSwimLaneTable Add (PoolId INTEGER NULL)';			
			EXECUTE IMMEDIATE 'ALTER TABLE WFSwimLaneTable Add (IndexInPool INTEGER NULL)';				
			DBMS_OUTPUT.PUT_LINE('New Column Added successfully in WFSwimLaneTable');
			EXECUTE IMMEDIATE 'UPDATE WFSwimLaneTable SET PoolId = -1,  IndexInPool = -1';			
	END;
	
	
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS   
		WHERE TABLE_NAME = UPPER('WFExportTable') 
		AND 
		COLUMN_NAME = UPPER('FieldSeperator');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE WFExportTable Add (FieldSeperator NVARCHAR2(2))';		
			EXECUTE IMMEDIATE 'ALTER TABLE WFExportTable Add (FileType INT)';
			EXECUTE IMMEDIATE 'ALTER TABLE WFExportTable Add (FilePath NVARCHAR2(255))';
			EXECUTE IMMEDIATE 'ALTER TABLE WFExportTable Add (HeaderString NVARCHAR2(255))';
			EXECUTE IMMEDIATE 'ALTER TABLE WFExportTable Add (FooterString NVARCHAR2(255))';
			EXECUTE IMMEDIATE 'ALTER TABLE WFExportTable Add (SleepTime INT)';
			EXECUTE IMMEDIATE 'ALTER TABLE WFExportTable Add (MaskedValue NVARCHAR2(255))';
			DBMS_OUTPUT.PUT_LINE('New Column Added successfully in WFExportTable');
			
			EXECUTE IMMEDIATE 'Update WFExportTable SET FieldSeperator = '','',FileType = 1, FilePath = '''', HeaderString ='' '', FooterString= '' '' ,SleepTime =  10,MaskedValue =''@'' ';
			
	END;
	
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME = UPPER('WFDataMapTable') 
		AND 
		COLUMN_NAME = UPPER('ExportAllDocs');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE WFDataMapTable Add (ExportAllDocs NVARCHAR2(2))';			
			DBMS_OUTPUT.PUT_LINE('New Column Added successfully in WFDataMapTable');
	END;
	
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME = UPPER('WFAdminLogTable') 
		AND 
		COLUMN_NAME = UPPER('Operation');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE WFAdminLogTable Add (Operation NVARCHAR2(1))';			
			EXECUTE IMMEDIATE 'ALTER TABLE WFAdminLogTable Add (ProfileId INT)';			
			EXECUTE IMMEDIATE 'ALTER TABLE WFAdminLogTable Add (ProfileName NVARCHAR2(64))';			
			EXECUTE IMMEDIATE 'ALTER TABLE WFAdminLogTable Add (Property1 NVARCHAR2(64))';			
			DBMS_OUTPUT.PUT_LINE('New Column Added successfully in WFAdminLogTable');
			EXECUTE IMMEDIATE ' UPDATE WFAdminLogTable SET PROFILEID = 0';
			
	END;
	
	
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME = UPPER('WFDataObjectTable') 
		AND 
		COLUMN_NAME = UPPER('SwimLaneId');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE WFDataObjectTable Add (SwimLaneId INT)';			
			DBMS_OUTPUT.PUT_LINE('New Column Added successfully in WFDataObjectTable');
			EXECUTE IMMEDIATE 'UPDATE WFDataObjectTable SET SWIMLANEID = 1';	
	END;
	
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME = UPPER('WFGroupBoxTable') 
		AND 
		COLUMN_NAME = UPPER('SwimLaneId');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE WFGroupBoxTable Add (SwimLaneId INT)';			
			DBMS_OUTPUT.PUT_LINE('New Column Added successfully in WFGroupBoxTable');
			EXECUTE IMMEDIATE 'UPDATE WFGroupBoxTable SET SWIMLANEID = 1';	
	END;

	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME = UPPER('WFSAPConnectTable') 
		AND 
		COLUMN_NAME = UPPER('ConfigurationID');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE WFSAPConnectTable Add (ConfigurationID INT)';			
			EXECUTE IMMEDIATE 'ALTER TABLE WFSAPConnectTable Add (RFCHostName NVARCHAR2(64))';			
			EXECUTE IMMEDIATE 'ALTER TABLE WFSAPConnectTable Add (ConfigurationName NVARCHAR2(64))';			
			DBMS_OUTPUT.PUT_LINE('New Column Added successfully in WFSAPConnectTable');
	END;
	
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME = UPPER('WFSAPGUIAssocTable') 
		AND 
		COLUMN_NAME = UPPER('ConfigurationID');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE WFSAPGUIAssocTable Add (ConfigurationID INT)';			
			DBMS_OUTPUT.PUT_LINE('New Column Added successfully in WFSAPGUIAssocTable');
	END;
	
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME = UPPER('WFSAPAdapterAssocTable') 
		AND 
		COLUMN_NAME = UPPER('ConfigurationID');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE WFSAPAdapterAssocTable Add (ConfigurationID INT)';			
			DBMS_OUTPUT.PUT_LINE('New Column Added successfully in WFSAPAdapterAssocTable');
	END;
	
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME = UPPER('WFFORM_TABLE') 
		AND 
		COLUMN_NAME = UPPER('LastModifiedOn');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE WFFORM_TABLE Add (LastModifiedOn DATE)';			
			DBMS_OUTPUT.PUT_LINE('New Column Added successfully in WFSAPAdapterAssocTable');
			EXECUTE IMMEDIATE 'UPDATE WFFORM_TABLE SET LASTMODIFIEDON = SYSDATE ';
	END;
	
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME = UPPER('WFFormFragmentTable') 
		AND 
		COLUMN_NAME = UPPER('LastModifiedOn');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE WFFormFragmentTable Add (LastModifiedOn DATE)';			
			DBMS_OUTPUT.PUT_LINE('New Column Added successfully in WFSAPAdapterAssocTable');
			EXECUTE IMMEDIATE 'UPDATE WFFormFragmentTable SET LASTMODIFIEDON = SYSDATE ';
	END;

/* ................................. End Adding new Column in Existing Table ................................*/

/*................................ Create new Trigger or modifying existing one............................... */

	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TRIGGERS
		WHERE TRIGGER_NAME=UPPER('WF_LIB_ID_TRIGGER');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 
			'CREATE OR REPLACE TRIGGER WF_LIB_ID_TRIGGER 	
				BEFORE INSERT ON WFDMSLIBRARY 	
				FOR EACH ROW 
				BEGIN 		
					SELECT LibraryId.NEXTVAL INTO :NEW.LibraryId FROM dual; 	
				END;';
			DBMS_OUTPUT.PUT_LINE('New trigger created with name as WF_LIB_ID_TRIGGER');
	END;
	
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TRIGGERS
		WHERE TRIGGER_NAME=UPPER('WF_USR_DEL');
	EXCEPTION
	WHEN NO_DATA_FOUND THEN
		EXECUTE IMMEDIATE
		'CREATE OR REPLACE TRIGGER WF_USR_DEL
			AFTER UPDATE 
			ON PDBUSER 
			FOR EACH ROW
			DECLARE
				v_DeletedFlag NVARCHAR2(1);
			BEGIN
			IF(UPDATING( ''v_DeletedFlag'' ))
			THEN
				UPDATE WORKLISTTABLE 
				SET	AssignedUser = NULL, AssignmentType = NULL,	LockStatus = N''N'' , 
					LockedByName = NULL,LockedTime = NULL , Q_UserId = 0 ,
					QueueName = (SELECT QUEUEDEFTABLE.QueueName 
				FROM   QUEUESTREAMTABLE , QUEUEDEFTABLE
				WHERE  QUEUESTREAMTABLE.QueueID = QUEUEDEFTABLE.QueueID 
				AND    StreamID = Q_StreamID
				AND    QUEUESTREAMTABLE.ProcessDefId = WORKLISTTABLE.ProcessDefId
				AND    QUEUESTREAMTABLE.ActivityId = WORKLISTTABLE.ActivityId) ,
					   QueueType = (SELECT QUEUEDEFTABLE.QueueType 
							FROM   QUEUESTREAMTABLE , QUEUEDEFTABLE
							WHERE  QUEUESTREAMTABLE.QueueID = QUEUEDEFTABLE.QueueID 
							AND    StreamID = Q_StreamID
							AND QUEUESTREAMTABLE.ProcessDefId = WORKLISTTABLE.ProcessDefId
							AND QUEUESTREAMTABLE.ActivityId = WORKLISTTABLE.ActivityId) ,
					   Q_QueueID = (SELECT QueueId 
							FROM QUEUESTREAMTABLE 
							WHERE StreamID = Q_StreamID
							AND QUEUESTREAMTABLE.ProcessDefId = WORKLISTTABLE.ProcessDefId
							AND QUEUESTREAMTABLE.ActivityId = WORKLISTTABLE.ActivityId)	
				WHERE Q_UserId = :OLD.UserIndex;
				UPDATE WORKLISTTABLE 
				SET	AssignedUser = NULL, AssignmentType = NULL, LockStatus = N''N'' ,
					LockedByName = NULL, LockedTime = NULL , Q_UserId = 0 
				WHERE  AssignmentType != N''F'' AND Q_UserId = :OLD.UserIndex;
				DELETE FROM QUEUEUSERTABLE  
					WHERE  UserID = :OLD.UserIndex 
					AND    Associationtype = 0;
				DELETE FROM USERPREFERENCESTABLE WHERE  UserID = :OLD.UserIndex;
				DELETE FROM USERDIVERSIONTABLE WHERE  Diverteduserindex = :OLD.UserIndex 
					OR AssignedUserindex = :OLD.UserIndex;
				DELETE FROM USERWORKAUDITTABLE WHERE  Userindex = :OLD.UserIndex 
					OR Auditoruserindex = :OLD.UserIndex;
				DELETE FROM WFProfileObjTypeTable  WHERE  UserID = :OLD.UserIndex 
					AND    Associationtype = 0;
				DELETE FROM WFUserObjAssocTable  WHERE  UserID = :OLD.UserIndex 
					AND    Associationtype = 0;
			END IF;	
			END;';
		DBMS_OUTPUT.PUT_LINE('New trigger created with name as WF_USR_DEL');
	END;

/*............................. End of create new Trigger or modifying existing one ............................ */

/*....................................... Create new View....................................... */

	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_VIEWS
		WHERE VIEW_NAME=UPPER('WFUSERVIEW');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 
				'CREATE OR REPLACE VIEW WFUSERVIEW ( USERINDEX, USERNAME, PERSONALNAME, FAMILYNAME, 	CREATEDDATETIME, 
				  EXPIRYDATETIME, PRIVILEGECONTROLLIST, PASSWORD, ACCOUNT, 
				  COMMNT, DELETEDDATETIME, USERALIVE, MAINGROUPID, 
				  MAILID, FAX, NOTECOLOR, SUPERIOR, SUPERIORFLAG  ) 
				AS 
				SELECT  USERINDEX,TO_NChar(RTRIM(USERNAME)) as USERNAME,PERSONALNAME,FAMILYNAME,
					CREATEDDATETIME, EXPIRYDATETIME,PRIVILEGECONTROLLIST,
					PASSWORD,ACCOUNT,COMMNT,DELETEDDATETIME,USERALIVE,
					MAINGROUPID,MAILID,FAX,NOTECOLOR, SUPERIOR, SUPERIORFLAG 
				FROM PDBUSER';
			DBMS_OUTPUT.PUT_LINE('New View created with name as WFUSERVIEW');
	END;
	
	/*BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_VIEWS
		WHERE VIEW_NAME=UPPER('PROFILEUSERGROUPVIEW');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 
			'CREATE OR REPLACE VIEW PROFILEUSERGROUPVIEW
				AS 
					SELECT PROFILEID, USERID, GROUPID, ASSIGNEDTILLDATETIME FROM (
					SELECT profileId,userid, cast ( NULL AS integer ) AS groupid, AssignedtillDateTime
					FROM WFUserObjAssocTable 
					WHERE Associationtype=0
					AND (AssignedtillDateTime is NULL or AssignedtillDateTime>=sysdate)
					UNION
					SELECT profileId, userindex,userId AS groupid,NULL AssignedtillDateTime
					FROM WFUserObjAssocTable , WFGROUPMEMBERVIEW 
					WHERE Associationtype=1
					AND WFUserObjAssocTable.userid=WFGROUPMEMBERVIEW.groupindex )a
					';
			DBMS_OUTPUT.PUT_LINE('New View created with name as PROFILEUSERGROUPVIEW');
	END;*/
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_VIEWS
		WHERE VIEW_NAME=UPPER('PROFILEUSERGROUPVIEW');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 
			'CREATE OR REPLACE VIEW PROFILEUSERGROUPVIEW
		 AS 
			SELECT PROFILEID, USERID, GROUPID, ROLEID, ASSIGNEDTILLDATETIME FROM (
			SELECT profileId, userid, cast ( NULL AS integer ) AS groupid, cast ( NULL AS integer ) AS roleid ,NULL AssignedtillDateTime
			FROM WFUserObjAssocTable 
			WHERE Associationtype=0
			AND (AssignedtillDateTime is NULL or AssignedtillDateTime>=sysdate)
			UNION
			SELECT profileId, userindex, userId AS groupid, cast ( NULL AS integer ) AS roleid, NULL AssignedtillDateTime
			FROM WFUserObjAssocTable , WFGROUPMEMBERVIEW 
			WHERE Associationtype=1
			AND WFUserObjAssocTable.userid=WFGROUPMEMBERVIEW.groupindex 
			AND (AssignedtillDateTime is NULL or AssignedtillDateTime>=sysdate)
			UNION
			SELECT profileId, userindex, groupindex, userId AS roleid, NULL AssignedtillDateTime
			FROM WFUserObjAssocTable , PDBGroupRoles 
			WHERE Associationtype=3
			AND WFUserObjAssocTable.userid=PDBGroupRoles.roleindex 
			AND (AssignedtillDateTime is NULL or AssignedtillDateTime>=sysdate))a';
			DBMS_OUTPUT.PUT_LINE('New View created with name as PROFILEUSERGROUPVIEW');
	END;
	
	
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_VIEWS
		WHERE VIEW_NAME=UPPER('WFROLEVIEW');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 
				'CREATE OR REPLACE VIEW WFROLEVIEW ( ROLEINDEX,ROLENAME,DESCRIPTION, MANYUSERFLAG) 
				AS 
				SELECT  ROLEINDEX, ROLENAME, DESCRIPTION, MANYUSERFLAG
				FROM PDBROLES';
			DBMS_OUTPUT.PUT_LINE('New View created with name as WFROLEVIEW');
	END;
/*....................................... End of new View Creation....................................... */

/*.......................................... Add Primary Key .........................................*/

	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_CONSTRAINTS
		WHERE TABLE_NAME = UPPER('ACTIONDEFTABLE')
		AND CONSTRAINT_TYPE = 'P';
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE ACTIONDEFTABLE Add PRIMARY KEY (ProcessDefId,ActionId,ActivityId)';
			DBMS_OUTPUT.PUT_LINE('Primary key is added in ACTIONDEFTABLE');
	END;
	
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_CONSTRAINTS
		WHERE TABLE_NAME = UPPER('TODOLISTDEFTABLE')
		AND CONSTRAINT_TYPE = 'P';
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE TODOLISTDEFTABLE Add PRIMARY KEY (ProcessDefID, ToDoId)';
			DBMS_OUTPUT.PUT_LINE('Primary key is added in TODOLISTDEFTABLE');
	END;
	
	BEGIN
		EXECUTE IMMEDIATE 'UPDATE  TODOLISTDEFTABLE SET TRIGGERNAME = '' '' where triggername is null ';
	END;
			
	
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_CONSTRAINTS
		WHERE TABLE_NAME = UPPER('TODOPICKLISTTABLE')
		AND CONSTRAINT_TYPE = 'P';
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE TODOPICKLISTTABLE Add PRIMARY KEY (ProcessDefId,ToDoId,PickListValue)';
			DBMS_OUTPUT.PUT_LINE('Primary key is added in TODOPICKLISTTABLE');
	END;
	
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_CONSTRAINTS
		WHERE TABLE_NAME = UPPER('EXCEPTIONDEFTABLE')
		AND CONSTRAINT_TYPE = 'P';
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE EXCEPTIONDEFTABLE Add PRIMARY KEY (ProcessDefId, ExceptionId)';
			DBMS_OUTPUT.PUT_LINE('Primary key is added in EXCEPTIONDEFTABLE');
	END;
	
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_CONSTRAINTS
		WHERE TABLE_NAME = UPPER('DOCUMENTTYPEDEFTABLE')
		AND CONSTRAINT_TYPE = 'P';
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE DOCUMENTTYPEDEFTABLE Add PRIMARY KEY (ProcessDefId, DocId)';
			DBMS_OUTPUT.PUT_LINE('Primary key is added in DOCUMENTTYPEDEFTABLE');
	END;
	
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_CONSTRAINTS
		WHERE TABLE_NAME = UPPER('PROCESSINITABLE')
		AND CONSTRAINT_TYPE = 'P';
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE PROCESSINITABLE Add PRIMARY KEY (ProcessDefId)';
			DBMS_OUTPUT.PUT_LINE('Primary key is added in PROCESSINITABLE');
	END;
	
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_CONSTRAINTS
		WHERE TABLE_NAME = UPPER('WFFORM_TABLE')
		AND CONSTRAINT_TYPE = 'P';
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE WFFORM_TABLE Add PRIMARY KEY (ProcessDefID,FormId)';
			DBMS_OUTPUT.PUT_LINE('Primary key is added in WFFORM_TABLE');
	END;
	
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_CONSTRAINTS
		WHERE TABLE_NAME = UPPER('TemplateMultiLanguageTable')
		AND CONSTRAINT_TYPE = 'P';
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE TemplateMultiLanguageTable Add PRIMARY KEY (ProcessdefId,TemplateId, Locale)';
			DBMS_OUTPUT.PUT_LINE('Primary key is added in TemplateMultiLanguageTable');
	END;
	
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_CONSTRAINTS
		WHERE TABLE_NAME = UPPER('InterfaceDescLanguageTable')
		AND CONSTRAINT_TYPE = 'P';
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE InterfaceDescLanguageTable Add PRIMARY KEY (ProcessDefId,ElementId, InterfaceID)';
			DBMS_OUTPUT.PUT_LINE('Primary key is added in InterfaceDescLanguageTable');
	END;

	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_CONSTRAINTS
		WHERE TABLE_NAME = UPPER('WFSwimLaneTable')
		AND CONSTRAINT_TYPE = 'P';
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE WFSwimLaneTable Add PRIMARY KEY (ProcessDefId, SwimLaneId)';
			DBMS_OUTPUT.PUT_LINE('Primary key is added in WFSwimLaneTable');
	END;
	
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_CONSTRAINTS
		WHERE TABLE_NAME = UPPER('WFDataMapTable')
		AND CONSTRAINT_TYPE = 'P';
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE WFDataMapTable Add PRIMARY KEY (ProcessDefId, ActivityId, OrderId)';
			DBMS_OUTPUT.PUT_LINE('Primary key is added in WFDataMapTable');
	END;
	
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_CONSTRAINTS
		WHERE TABLE_NAME = UPPER('WFExtInterfaceConditionTable')
		AND CONSTRAINT_TYPE = 'P';
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE WFExtInterfaceConditionTable Add PRIMARY KEY (ProcessDefId, InterfaceType, RuleId, ConditionOrderId)';
			DBMS_OUTPUT.PUT_LINE('Primary key is added in WFExtInterfaceConditionTable');
	END;
	
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_CONSTRAINTS
		WHERE TABLE_NAME = UPPER('WFFormFragmentTable')
		AND CONSTRAINT_TYPE = 'P';
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE WFFormFragmentTable Add PRIMARY KEY (ProcessDefId,FragmentId)';
			DBMS_OUTPUT.PUT_LINE('Primary key is added in WFFormFragmentTable');
	END;
		
/*....................................... End of Add primary key ....................................... */

/*.......................................... Modify Existing Primary Key.....................................*/

	BEGIN
	SELECT CONSTRAINT_NAME INTO v_constraintName
		FROM USER_CONSTRAINTS 
		WHERE TABLE_NAME = UPPER('ProcessDefTable') 
		AND constraint_type = 'P';

		EXECUTE IMMEDIATE 'Alter Table ProcessDefTable Drop Constraint ' || TO_CHAR(v_constraintName);
		EXECUTE IMMEDIATE 'Alter Table ProcessDefTable Add Constraint ' || TO_CHAR(v_constraintName) || ' Primary Key (Processdefid, VersionNo)';
		DBMS_OUTPUT.PUT_LINE('Primary Key Updated for ProcessDefTable');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			DBMS_OUTPUT.PUT_LINE('No Primary Key Exists for ProcessDefTable');
	END;
	
	BEGIN
	SELECT CONSTRAINT_NAME INTO v_constraintName
		FROM USER_CONSTRAINTS 
		WHERE TABLE_NAME = UPPER('PRINTFAXEMAILTABLE') 
		AND constraint_type = 'P';

		EXECUTE IMMEDIATE 'Alter Table PRINTFAXEMAILTABLE Drop Constraint ' || TO_CHAR(v_constraintName);
		EXECUTE IMMEDIATE 'Alter Table PRINTFAXEMAILTABLE Add Constraint ' || TO_CHAR(v_constraintName) || ' Primary Key (ProcessDefId, PFEInterfaceId)';
		DBMS_OUTPUT.PUT_LINE('Primary Key Updated for PRINTFAXEMAILTABLE');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			DBMS_OUTPUT.PUT_LINE('No Primary Key Exists for PRINTFAXEMAILTABLE');
	END;
	
	BEGIN
	SELECT CONSTRAINT_NAME INTO v_constraintName
		FROM USER_CONSTRAINTS 
		WHERE TABLE_NAME = UPPER('WFSAPConnectTable') 
		AND constraint_type = 'P';

		EXECUTE IMMEDIATE 'Alter Table WFSAPConnectTable Drop Constraint ' || TO_CHAR(v_constraintName);
		EXECUTE IMMEDIATE 'Alter Table WFSAPConnectTable Add Constraint ' || TO_CHAR(v_constraintName) || ' Primary Key (ProcessDefId, ConfigurationID)';
		DBMS_OUTPUT.PUT_LINE('Primary Key Updated for WFSAPConnectTable');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			DBMS_OUTPUT.PUT_LINE('No Primary Key Exists for WFSAPConnectTable');
	END;
	
	
/*....................................... End of Modify Existing Primary Key .................................. */

/*Modifying Null values to some defualt values for nullable columns whose defalut value is restricted from UI */

BEGIN
	EXECUTE IMMEDIATE 'UPDATE TRIGGERDEFTABLE SET DESCRIPTION = '' '' Where Description is NULL';
END;

/*....................................... Modify Existing Column Type .................................. */

BEGIN
		SELECT 1 INTO existsFlag 
		FROM WFCabVersionTable
		WHERE CabVersion = '10.0_OmniFlowCabinet'; 		
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
		
		EXECUTE IMMEDIATE'Insert into WFCabVersionTable(cabVersion,creationDate,lastModified,Remarks,Status) values(N''10.0_OmniFlowCabinet'', SysDate, SysDate, N''Cabinet Upgraded to 10.0 Version'', N''Y'')';
		
		EXECUTE IMMEDIATE 'ALTER TABLE QUEUEHISTORYTABLE MODIFY (Q_UserID INT)';
		EXECUTE IMMEDIATE 'ALTER TABLE QUEUEHISTORYTABLE MODIFY (LastProcessedBy INT)';
		EXECUTE IMMEDIATE 'ALTER TABLE QUEUEHISTORYTABLE MODIFY (ReferredTo INT)';
		EXECUTE IMMEDIATE 'ALTER TABLE QUEUEHISTORYTABLE MODIFY (ReferredBy INT)';
		DBMS_OUTPUT.PUT_LINE('Column Types modified successfully in QUEUEHISTORYTABLE');
		EXECUTE IMMEDIATE 'ALTER TABLE QUEUEUSERTABLE MODIFY (Userid INT)';		
		DBMS_OUTPUT.PUT_LINE('Column Types modified successfully in QUEUEUSERTABLE');
		EXECUTE IMMEDIATE 'ALTER TABLE USERDIVERSIONTABLE MODIFY (Diverteduserindex INT NOT NULL)';	
		EXECUTE IMMEDIATE 'ALTER TABLE USERDIVERSIONTABLE MODIFY (AssignedUserindex INT NOT NULL)';	
		DBMS_OUTPUT.PUT_LINE('Column Types modified successfully in USERDIVERSIONTABLE');
		EXECUTE IMMEDIATE 'ALTER TABLE USERWORKAUDITTABLE MODIFY (Userindex INT NOT NULL)';	
		EXECUTE IMMEDIATE 'ALTER TABLE USERWORKAUDITTABLE MODIFY (Auditoruserindex INT NOT NULL)';	
		DBMS_OUTPUT.PUT_LINE('Column Types modified successfully in USERWORKAUDITTABLE');
		EXECUTE IMMEDIATE 'ALTER TABLE PREFERREDQUEUETABLE MODIFY (userindex INT NOT NULL)';	
		DBMS_OUTPUT.PUT_LINE('Column Types modified successfully in PREFERREDQUEUETABLE');
		EXECUTE IMMEDIATE 'ALTER TABLE USERPREFERENCESTABLE MODIFY (userid INT NOT NULL)';	
		DBMS_OUTPUT.PUT_LINE('Column Types modified successfully in USERPREFERENCESTABLE');
		EXECUTE IMMEDIATE 'ALTER TABLE WFREMINDERTABLE MODIFY (ToIndex INT)';	
		EXECUTE IMMEDIATE 'ALTER TABLE WFREMINDERTABLE MODIFY (SetByUser INT)';	
		DBMS_OUTPUT.PUT_LINE('Column Types modified successfully in WFREMINDERTABLE');
		EXECUTE IMMEDIATE 'ALTER TABLE WORKLISTTABLE MODIFY (Q_UserId INT )';	
		DBMS_OUTPUT.PUT_LINE('Column Types modified successfully in WORKLISTTABLE');
		EXECUTE IMMEDIATE 'ALTER TABLE WORKINPROCESSTABLE MODIFY (Q_UserId INT )';	
		DBMS_OUTPUT.PUT_LINE('Column Types modified successfully in WORKINPROCESSTABLE');
		EXECUTE IMMEDIATE 'ALTER TABLE WORKDONETABLE MODIFY (Q_UserId INT )';	
		DBMS_OUTPUT.PUT_LINE('Column Types modified successfully in WORKDONETABLE');
		EXECUTE IMMEDIATE 'ALTER TABLE WORKWITHPSTABLE MODIFY (Q_UserId INT )';	
		DBMS_OUTPUT.PUT_LINE('Column Types modified successfully in WORKWITHPSTABLE');
		EXECUTE IMMEDIATE 'ALTER TABLE PENDINGWORKLISTTABLE MODIFY (Q_UserId INT )';	
		DBMS_OUTPUT.PUT_LINE('Column Types modified successfully in PENDINGWORKLISTTABLE');
		EXECUTE IMMEDIATE 'ALTER TABLE USERQUEUETABLE MODIFY (UserID INT )';	
		DBMS_OUTPUT.PUT_LINE('Column Types modified successfully in USERQUEUETABLE');
		EXECUTE IMMEDIATE 'ALTER TABLE EXCEPTIONTABLE MODIFY (UserID INT )';	
		DBMS_OUTPUT.PUT_LINE('Column Types modified successfully in EXCEPTIONTABLE');
		EXECUTE IMMEDIATE 'ALTER TABLE EXCEPTIONHISTORYTABLE MODIFY (UserID INT )';	
		DBMS_OUTPUT.PUT_LINE('Column Types modified successfully in EXCEPTIONHISTORYTABLE');
		EXECUTE IMMEDIATE 'ALTER TABLE WFHistoryRouteLogTable MODIFY (UserID INT )';	
		DBMS_OUTPUT.PUT_LINE('Column Types modified successfully in WFHistoryRouteLogTable');
		EXECUTE IMMEDIATE 'ALTER TABLE WFCurrentRouteLogTable MODIFY (UserID INT )';	
		DBMS_OUTPUT.PUT_LINE('Column Types modified successfully in WFCurrentRouteLogTable');
		EXECUTE IMMEDIATE 'ALTER TABLE WFAuthorizeQueueUserTable MODIFY (UserID INT )';	
		DBMS_OUTPUT.PUT_LINE('Column Types modified successfully in WFAuthorizeQueueUserTable');
		EXECUTE IMMEDIATE 'ALTER TABLE TRIGGERTYPEDEFTABLE MODIFY (ClassName NVARCHAR2(255) )';	
		DBMS_OUTPUT.PUT_LINE('Column Types modified successfully in TRIGGERTYPEDEFTABLE');
		EXECUTE IMMEDIATE 'ALTER TABLE DOCUMENTTYPEDEFTABLE MODIFY (DCName NVARCHAR2(250))';	
		DBMS_OUTPUT.PUT_LINE('Column Types modified successfully in DOCUMENTTYPEDEFTABLE');
		EXECUTE IMMEDIATE 'ALTER TABLE WFEXPORTINFOTABLE MODIFY (TARGETCABINETNAME NVARCHAR2(255) NULL)';	
		DBMS_OUTPUT.PUT_LINE('Column Types modified successfully in WFEXPORTINFOTABLE');
		EXECUTE IMMEDIATE 'ALTER TABLE WFEXPORTINFOTABLE MODIFY (TARGETUSERNAME NVARCHAR2(255) NULL)';	
		DBMS_OUTPUT.PUT_LINE('Column Types modified successfully in WFEXPORTINFOTABLE');
		EXECUTE IMMEDIATE 'ALTER TABLE WFEXPORTINFOTABLE MODIFY (TARGETPASSWORD NVARCHAR2(255) NULL)';	
		DBMS_OUTPUT.PUT_LINE('Column Types modified successfully in WFEXPORTINFOTABLE');

END;
		
	BEGIN				
		EXECUTE IMMEDIATE 'Alter Table ROUTEFOLDERDEFTABLE rename to TEMPROUTEFOLDERDEFTABLE';
		EXECUTE IMMEDIATE 
			'CREATE TABLE ROUTEFOLDERDEFTABLE (
				ProcessDefId            INT					NOT NULL Primary Key,
				CabinetName             NVARCHAR2(50) 		NOT NULL,
				RouteFolderId           NVARCHAR2(255)		NOT NULL,
				ScratchFolderId         NVARCHAR2(255)		NOT NULL,
				WorkFlowFolderId        NVARCHAR2(255)		NOT NULL,
				CompletedFolderId       NVARCHAR2(255)		NOT NULL,
				DiscardFolderId         NVARCHAR2(255)		NOT NULL 
			)';
		DBMS_OUTPUT.PUT_LINE ('Table ROUTEFOLDERDEFTABLE Created successfully.....'	);
		
	  EXECUTE IMMEDIATE 'INSERT INTO ROUTEFOLDERDEFTABLE SELECT ProcessDefId, CabinetName, RouteFolderId, ScratchFolderId, WorkFlowFolderId, CompletedFolderId, DiscardFolderId FROM TEMPROUTEFOLDERDEFTABLE';
	  EXECUTE IMMEDIATE 'DROP TABLE TEMPROUTEFOLDERDEFTABLE';
	  DBMS_OUTPUT.PUT_LINE ('Table TEMPROUTEFOLDERDEFTABLE dropped successfully...........'	);
	END;	
	
	BEGIN
		EXECUTE IMMEDIATE 'ALTER TABLE ACTIVITYTABLE Add (TempDescription NCLOB)';			
		EXECUTE IMMEDIATE 'UPDATE ACTIVITYTABLE SET TempDescription = Description';			
		EXECUTE IMMEDIATE 'ALTER TABLE ACTIVITYTABLE DROP COLUMN Description ';			
		EXECUTE IMMEDIATE 'ALTER TABLE ACTIVITYTABLE RENAME COLUMN tempDescription to Description ';			
		DBMS_OUTPUT.PUT_LINE('Column Type modified successfully in ACTIVITYTABLE');
		
		EXECUTE IMMEDIATE 'UPDATE ACTIVITYTABLE SET DESCRIPTION = '' '' WHERE DESCRIPTION is NULL ';
	END;
	
	BEGIN
		EXECUTE IMMEDIATE 'ALTER TABLE WFBPELDEFTABLE Add (TempBPELDef NCLOB, TempXSDDef NCLOB)';			
		EXECUTE IMMEDIATE 'UPDATE WFBPELDEFTABLE SET TempBPELDef = BPELDef, TempXSDDef = XSDDef';
		EXECUTE IMMEDIATE 'ALTER TABLE WFBPELDEFTABLE DROP COLUMN BPELDef';		
		EXECUTE IMMEDIATE 'ALTER TABLE WFBPELDEFTABLE DROP COLUMN XSDDef';				
		EXECUTE IMMEDIATE 'ALTER TABLE WFBPELDEFTABLE RENAME COLUMN tempBPELDef to BPELDef ';			
		EXECUTE IMMEDIATE 'ALTER TABLE WFBPELDEFTABLE RENAME COLUMN tempXSDDef to XSDDef ';			
		DBMS_OUTPUT.PUT_LINE('Column Type modified successfully in WFBPELDEFTABLE');
	END;
	
	BEGIN
		EXECUTE IMMEDIATE 'ALTER TABLE WFSYSTEMSERVICESTABLE Add (TempRegInfo NCLOB)';		
		EXECUTE IMMEDIATE 'UPDATE WFSYSTEMSERVICESTABLE SET TempRegInfo = RegInfo';
		EXECUTE IMMEDIATE 'ALTER TABLE WFSYSTEMSERVICESTABLE DROP COLUMN RegInfo';		
		EXECUTE IMMEDIATE 'ALTER TABLE WFSYSTEMSERVICESTABLE RENAME COLUMN tempRegInfo to RegInfo';		
		DBMS_OUTPUT.PUT_LINE('Column Type modified successfully in WFSYSTEMSERVICESTABLE');
	END;
		
	begin
		v_STR1 := 'SELECT ProcessDefId, RegStartingNo FROM PROCESSDEFTABLE ORDER BY ProcessDefId ';	
		OPEN CursorObjTable FOR v_STR1;
		LOOP
		FETCH CursorObjTable INTO v_ProcessDefId, v_RegStartingNo; 
		EXIT WHEN CursorObjTable%NOTFOUND;
		v_SeqName := 'SEQ_REGISTRATIONNUMBER_'||v_ProcessDefId;
		v_RegStartingNo := v_RegStartingNo+1 ;
		BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_SEQUENCES  
			WHERE SEQUENCE_NAME = UPPER(v_SeqName);
			EXCEPTION 
				WHEN NO_DATA_FOUND THEN 			
				EXECUTE IMMEDIATE 'CREATE SEQUENCE '||v_SeqName||' INCREMENT BY 1 START WITH '||v_RegStartingNo||' NOCACHE';
		END;
		END LOOP;
    CLOSE CursorObjTable; 
	END;
	
	begin
		v_STR1 := 'SELECT ProcessDefId FROM PROCESSDEFTABLE ORDER BY ProcessDefId ';	
		OPEN CursorObjTable FOR v_STR1;
		LOOP
		FETCH CursorObjTable INTO v_ProcessDefId; 
		EXIT WHEN CursorObjTable%NOTFOUND;
		v_STR2 := 'select distinct ExtObjId from varmappingtable where processdefid = '||v_ProcessDefId||' and unbounded = ''Y'' and variableid in (select distinct(variableid) from wfudtvarmappingtable where processdefid = '||v_ProcessDefId||' )';
		OPEN CursorExtObjId FOR v_STR2;
		LOOP
		FETCH CursorExtObjId INTO v_ExtObjId; 
		EXIT WHEN CursorExtObjId%NOTFOUND;
		v_SeqName := 'WFSEQ_ARRAY_'||v_ProcessDefId||'_'||v_ExtObjId;
		BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_SEQUENCES  
			WHERE SEQUENCE_NAME = UPPER(v_SeqName);
			EXCEPTION 
				WHEN NO_DATA_FOUND THEN 			
				EXECUTE IMMEDIATE 'CREATE SEQUENCE '||v_SeqName||' INCREMENT BY 1 START WITH 1 NOCACHE';
		END;
		END LOOP;
		END LOOP;
    CLOSE CursorExtObjId; 
    CLOSE CursorObjTable; 
	END;
	
/*  Inserting Default values in WFMileStoneTable and WFSwimLaneTable for the exsisting Processses  */
BEGIN
		v_STR1:= 'SELECT Processdefid from processdeftable'; 
		OPEN cur_processDef  FOR v_STR1;
	LOOP
		FETCH cur_processDef into v_ProcessDefId;
		EXIT WHEN cur_processDef%NOTFOUND;
			BEGIN   
				EXECUTE IMMEDIATE 'Select Count(*) from WFMIleStoneTable WHERE processdefid = ' || TO_CHAR(v_ProcessDefId)  into existsFlag ;
				IF existsFlag = 0 THEN
					Execute Immediate 'Insert into WFMIleStoneTable(ProcessDefId, MileStoneId,MileStoneSeqId,MileStoneName,MileStoneWidth,MileStoneHeight,ITop,ILeft,BackColor,Description,isExpanded,Cost,Duration) Values ('||TO_CHAR(v_ProcessDefId)|| ', 1,1,N''MileDefault'',0,0,0,0,1234,N''DefaultDescription'','' '',0.00,'' '')';							
				END IF;
			END;
			BEGIN
				EXECUTE IMMEDIATE 'Select Count(*) from WFSwimLanetable WHERE processdefid = ' || TO_CHAR(v_ProcessDefId)  into existsFlag ;
				If existsFlag = 0 THEN
					Execute Immediate 'Insert into WFSwimLaneTable(ProcessDefId, SwimLaneId,SwimLaneWidth,SwimLaneHeight,ITop,ILeft,BackColor,SwimLaneType,SwimLaneText,SwimLaneTextColor,PoolId,IndexInPool) Values ('||TO_CHAR(v_ProcessDefId)||', 1,754,258,0,0,1234,N''H'',N''SwimLane_1'',-16777216,-1,-1)';
				END If;
			END;
	End Loop;
		Close cur_processDef;
END;	
	

/* Inserting Missing Values in QueuedefTable and WFLnaqueueTable*/	
Begin
		v_STR1:= 'SELECT ProcessDefId,ProcessName  from PROCESSDEFTABLE';
		OPEN cur_QueueDef FOR v_STR1;
	LOOP	
		FETCH cur_QueueDef into v_ProcessDefId,v_ProcessName;
		EXIT WHEN cur_QueueDef%NOTFOUND;
			BEGIN
				v_QueueName:=v_ProcessName||'_SwimLane_1';  
				EXECUTE IMMEDIATE 'Select COUNT(*) from WFLaneQueueTable where processdefid = '||TO_CHAR(v_ProcessdefId) into existsFlag;
				If existsFlag = 0 THEN 
					EXECUTE IMMEDIATE 'Insert into QueueDefTable (QueueId, QueueName, QueueType, Comments, OrderBy, SortOrder) values 
					('''||QueueId.nextval||''','''||v_QueueName||''', N''F'', N''Process Modeler generated Default Swimlane Queue'', 10, N''A'')';
					EXECUTE IMMEDIATE 'Insert into WFLaneQueueTable(ProcessDefId,SwimLaneId,QueueID) Values ('||TO_CHAR(v_ProcessDefId)||',1,'''||QueueId.currval||''')';
				End If;
			END;
	End Loop;
		CLOSE cur_QueueDef;
END;

/* Upgrading Script for SAP and EXTMETHODDETABLE(for configid) and VarAliasTable(VariableId1)*/	  
BEGIN
        SELECT 1 INTO existsFlag FROM USER_TAB_COLUMNS WHERE TABLE_NAME=UPPER('VarAliasTable') 
        AND COLUMN_NAME=UPPER('VariableId1');
		EXCEPTION
        WHEN NO_DATA_FOUND THEN
           EXECUTE IMMEDIATE 'ALTER TABLE "VARALIASTABLE" ADD "VARIABLEID1" INT DEFAULT 0 NOT NULL';
           DBMS_OUTPUT.PUT_LINE('Table VarAliasTable altered with new Column VariableId1');
            
         DECLARE CURSOR cursor1 IS SELECT DISTINCT PARAM1, VariableId, VariableType FROM VARMAPPINGTABLE  A, VARALIASTABLE B WHERE A.SYSTEMDEFINEDNAME = B.PARAM1 AND A.ProcessDefId = (select max(ProcessDefId) from ProcessDefTable);            
		 BEGIN                    
			OPEN cursor1;
				EXECUTE IMMEDIATE 'CREATE INDEX TEMPIDX1_VarAliasTable ON VarAliasTable (Param1)';    
			LOOP
					FETCH cursor1 INTO v_param1, v_VariableId, v_variableType;
					EXIT WHEN cursor1%NOTFOUND;            
                BEGIN
					v_STR1 := ' Update VarAliasTable Set VariableId1 = ' || (100 + v_VariableId) || ' , Type1 = ' || v_variableType || ' Where Param1 = ''' || TO_CHAR(v_param1) || '''';
					SAVEPOINT exttable_alias;
                    EXECUTE IMMEDIATE v_STR1;            
                END;
					COMMIT;
            END LOOP;
				EXECUTE IMMEDIATE 'DROP INDEX TEMPIDX1_VarAliasTable';            
            CLOSE cursor1;            
		END;            
END;    
    

BEGIN
        SELECT 1 INTO existsFlag FROM USER_TAB_COLUMNS WHERE Upper(TABLE_NAME) = 'WFSAPCONNECTTABLE'AND Upper(COLUMN_NAME) = 'CONFIGURATIONID';
		EXCEPTION
        WHEN NO_DATA_FOUND THEN
            EXECUTE IMMEDIATE 'ALTER TABLE WFSAPCONNECTTABLE Add ConfigurationID INTEGER';
            DBMS_OUTPUT.PUT_LINE('Table WFSAPCONNECTTABLE altered with new Column ConfigurationID');
            EXECUTE IMMEDIATE 'ALTER TABLE WFSAPCONNECTTABLE Add RFCHostName NVARCHAR2(64)';
            DBMS_OUTPUT.PUT_LINE('Table WFSAPCONNECTTABLE altered with new Column RFCHostName');
            EXECUTE IMMEDIATE 'ALTER TABLE WFSAPCONNECTTABLE Add ConfigurationName NVARCHAR2(64)';
            DBMS_OUTPUT.PUT_LINE('Table WFSAPCONNECTTABLE altered with new Column ConfigurationName');
END;

   
BEGIN
		SELECT CONSTRAINT_NAME INTO v_SAPconstraintName FROM USER_CONSTRAINTS WHERE TABLE_NAME = UPPER('WFSAPConnectTable') AND constraint_type = 'P';
		EXECUTE IMMEDIATE 'Alter Table WFSAPConnectTable Drop Constraint ' || TO_CHAR(v_SAPconstraintName);
		EXECUTE IMMEDIATE 'Alter Table WFSAPConnectTable Add Constraint ' || TO_CHAR(v_SAPconstraintName) || ' Primary Key (ProcessDefId, ConfigurationID)';
       DBMS_OUTPUT.PUT_LINE('Primary Key Updated for WFSAPConnectTable');
		EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('No Primary Key Exists for WFSAPConnectTable');
		END;
    
BEGIN
        SELECT 1 INTO existsFlag FROM USER_TAB_COLUMNS WHERE Upper(TABLE_NAME) = 'WFSAPGUIASSOCTABLE' AND Upper(COLUMN_NAME) = 'CONFIGURATIONID';
		EXCEPTION
        WHEN NO_DATA_FOUND THEN
            EXECUTE IMMEDIATE 'ALTER TABLE WFSAPGUIAssocTable Add ConfigurationID INTEGER';
            DBMS_OUTPUT.PUT_LINE('Table WFSAPGUIAssocTable altered with new Column ConfigurationID');
END;

BEGIN
        SELECT 1 INTO existsFlag FROM USER_TAB_COLUMNS WHERE Upper(TABLE_NAME) = 'WFSAPADAPTERASSOCTABLE' AND Upper(COLUMN_NAME) = 'CONFIGURATIONID';
		EXCEPTION
        WHEN NO_DATA_FOUND THEN
            EXECUTE IMMEDIATE 'ALTER TABLE WFSAPadapterAssocTable Add ConfigurationID INTEGER';
            DBMS_OUTPUT.PUT_LINE('Table WFSAPadapterAssocTable altered with new Column ConfigurationID');
END;

BEGIN
        SELECT 1 INTO existsFlag FROM USER_TAB_COLUMNS WHERE Upper(TABLE_NAME) = 'EXTMETHODDEFTABLE' AND Upper(COLUMN_NAME) = 'CONFIGURATIONID';
		EXCEPTION
        WHEN NO_DATA_FOUND THEN
            EXECUTE IMMEDIATE 'ALTER TABLE ExtMethodDefTable Add ConfigurationID INTEGER';
            DBMS_OUTPUT.PUT_LINE('Table ExtMethodDefTable altered with new Column ConfigurationID');
END;

	BEGIN
		SELECT CabVersion INTO v_cabVersion FROM WFCABVERSIONTABLE WHERE CabVersion = '9.0_SAP_CONFIGURATION';
		EXCEPTION 
		WHEN NO_DATA_FOUND THEN
        BEGIN
            EXECUTE IMMEDIATE 'Update WFSAPConnectTable Set RFCHostName = SAPHostName, ConfigurationName = ''DEFAULT''';  
            v_ConfigurationId:= 0;
            v_STR1:= ' SELECT ProcessDefId FROM WFSAPConnectTable';
            Open cursor1 FOR v_STR1;
            LOOP
                FETCH cursor1 INTO v_ProcessDefId;
                EXIT WHEN cursor1%NOTFOUND;
                v_ConfigurationId := v_ConfigurationId + 1;
                BEGIN 
                    v_Query := ' UPDATE WFSAPConnectTable SET ConfigurationId = ' || v_ConfigurationId || ' WHERE ProcessDefId = ' || v_ProcessDefId;
                    EXECUTE IMMEDIATE v_Query;
                    v_Query := ' UPDATE WFSAPGUIAssocTable SET ConfigurationId = ' || v_ConfigurationId || ' WHERE ProcessDefId = ' || v_ProcessDefId;
                    EXECUTE IMMEDIATE v_Query;
                    v_Query := ' UPDATE WFSAPadapterAssocTable SET ConfigurationId = ' || v_ConfigurationId || ' WHERE ProcessDefId = ' || v_ProcessDefId;
                    EXECUTE IMMEDIATE v_Query;
                    v_Query := ' UPDATE ExtMethodDefTable SET ConfigurationId = ' || v_ConfigurationId || ' WHERE ProcessDefId = ' || v_ProcessDefId;
                    EXECUTE IMMEDIATE v_Query;
                END;
                COMMIT;
            END LOOP;
            CLOSE cursor1;
			
        END;
        EXECUTE IMMEDIATE 'INSERT INTO WFCabVersionTable(cabVersion, cabVersionId, creationDate, lastModified, Remarks, Status) VALUES (N''9.0_SAP_CONFIGURATION'', cabVersionId.nextVal, SYSDATE, SYSDATE, N''OmniFlow 9.0'', N''Y'')';    
	END;
/* END Upgrading Script for SAP and EXTMETHODDETABLE(for configid) and VarAliasTable(VariableId1)*/	 
 
	/* Upgrade for Process Variant Support */
		
	BEGIN 
	SELECT 1 INTO existsFlag 
	FROM USER_TABLES  
	WHERE TABLE_NAME = UPPER('WFProcessVariantDefTable');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
		EXECUTE IMMEDIATE 'CREATE TABLE WFProcessVariantDefTable (
			ProcessDefId		INT		NOT NULL,
			ProcessVariantId    INT		NOT NULL,
			ProcessVariantName	NVARCHAR2(64)	NOT NULL ,
			ProcessVariantState	NVARCHAR2(10),
			RegPrefix			NVARCHAR2(20)	NOT NULL,
			RegSuffix			NVARCHAR2(20)	NULL,
			RegStartingNo		INT			NULL,		
			Label			NVARCHAR2 (255) NOT	NULL ,
			Description		NVARCHAR2 (255)	NULL ,
			CreatedOn		DATE		NULL , 
			CreatedBy		NVARCHAR2(64)	NULL,
			LastModifiedOn  DATE		NULL,
			LastModifiedBy	NVARCHAR2(64)	NULL,
			PRIMARY KEY ( ProcessVariantId )
	)';
	EXECUTE IMMEDIATE 'ALTER Table ProcessDefTable add ProcessType NVarchar2(1) Default(''S'') NOT NULL';

	DBMS_OUTPUT.PUT_LINE('Table WFProcessVariantDefTable Created successfully');
	END;
	
	BEGIN 
	SELECT 1 INTO existsFlag 
	FROM USER_TABLES  
	WHERE TABLE_NAME = UPPER('WFVariantFieldInfoTable');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
		EXECUTE IMMEDIATE 'CREATE TABLE WFVariantFieldInfoTable(
			ProcessDefId			INT		NOT NULL,
			ProcessVariantId		INT		NOT NULL,
			FieldId                 INT		NOT NULL,
			VariableId				INT,
			VarFieldId				INT,
			Type          			INT,
			Length                  INT,
			DefaultValue            NVARCHAR2(255),
			MethodName          	NVARCHAR2(255),
			PickListInfo            NVARCHAR2(512),
			ControlType             INT,
			PRIMARY KEY ( ProcessDefId, ProcessVariantId, FieldId)
		)';
	
	DBMS_OUTPUT.PUT_LINE('Table WFVariantFieldInfoTable Created successfully');
	END;
	
	BEGIN 
	SELECT 1 INTO existsFlag 
	FROM USER_TABLES  
	WHERE TABLE_NAME = UPPER('WFVariantFieldAssociationTable');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
		EXECUTE IMMEDIATE 'CREATE TABLE WFVariantFieldAssociationTable(
			ProcessDefId			INT		NOT NULL,
			ProcessVariantId		INT		NOT NULL,
			ActivityId              INT		NOT NULL,
			VariableId              INT		NOT NULL,
			VarFieldId              INT		NOT NULL,
			Enable       			NVARCHAR2(1),
			Editable      			NVARCHAR2(1),
			Visible     	        NVARCHAR2(1),
			Mandatory				NVARCHAR2(1),
			PRIMARY KEY ( ProcessDefId, ProcessVariantId, ActivityId, VariableId, VarFieldId)
		)';
	
	DBMS_OUTPUT.PUT_LINE('Table WFVariantFieldAssociationTable Created successfully');
	END;
	
	BEGIN 
	SELECT 1 INTO existsFlag 
	FROM USER_TABLES  
	WHERE TABLE_NAME = UPPER('WFVariantFormListenerTable');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
		EXECUTE IMMEDIATE 'CREATE TABLE WFVariantFormListenerTable(
			ProcessDefId			INT		NOT NULL,
			ProcessVariantId		INT		NOT NULL,
			VariableId              INT,
			VarFieldId              INT,
			FormExtId               INT		NULL,
			ActivityId              INT		NULL,
			FunctionName			NVarchar2(512),
			CodeSnippet             NCLOB,
			LanguageType  			NVARCHAR2(2),
			FieldListener     	    INT,
			ObjectForListener		NVARCHAR2(1)
		)';
	
	DBMS_OUTPUT.PUT_LINE('Table WFVariantFormListenerTable Created successfully');
	END;
	
	BEGIN 
	SELECT 1 INTO existsFlag 
	FROM USER_TABLES  
	WHERE TABLE_NAME = UPPER('WFVariantFormTable');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
		EXECUTE IMMEDIATE 'CREATE TABLE WFVariantFormTable(
			ProcessDefId			INT Not Null,
			ProcessVariantId		INT	Not Null,
			FormExtId   	        INT Not Null,
			Columns		            INT,
			Width1		            INT,
			Width2		            INT,
			Width3		            INT,
			PRIMARY KEY ( ProcessDefId, ProcessVariantId, FormExtId)
		)';
	
	DBMS_OUTPUT.PUT_LINE('Table WFVariantFormTable Created successfully');
	END;
	
	BEGIN
        SELECT 1 INTO existsFlag FROM USER_TAB_COLUMNS WHERE Upper(TABLE_NAME) = 'ACTIVITYASSOCIATIONTABLE' AND Upper(COLUMN_NAME) = 'ProcessVariantId';
		EXCEPTION
        WHEN NO_DATA_FOUND THEN
            EXECUTE IMMEDIATE 'Alter Table ACTIVITYASSOCIATIONTABLE Add  ProcessVariantId INT DEFAULT(0) NOT NULL';
            DBMS_OUTPUT.PUT_LINE('Table ACTIVITYASSOCIATIONTABLE altered with new Column ProcessVariantId');
	END;

	BEGIN	
      SELECT CONSTRAINT_NAME INTO v_constraintName
		FROM USER_CONSTRAINTS 
		WHERE TABLE_NAME = UPPER('ACTIVITYASSOCIATIONTABLE') AND constraint_type = 'P';
		EXECUTE IMMEDIATE 'Alter Table ACTIVITYASSOCIATIONTABLE Drop Constraint ' || TO_CHAR(v_constraintName);
		EXECUTE IMMEDIATE 'Alter Table ACTIVITYASSOCIATIONTABLE Add Constraint ' || TO_CHAR(v_constraintName) || ' Primary Key (ProcessdefId, ActivityId, DefinitionType, DefinitionId,ProcessVariantId)';
		DBMS_OUTPUT.PUT_LINE('Primary Key Updated for ACTIVITYASSOCIATIONTABLE');
  	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			DBMS_OUTPUT.PUT_LINE('No Primary Key Exists for ACTIVITYASSOCIATIONTABLE');
	END;
	
	BEGIN
        SELECT 1 INTO existsFlag FROM USER_TAB_COLUMNS WHERE Upper(TABLE_NAME) = 'VARMAPPINGTABLE' AND Upper(COLUMN_NAME) = 'ProcessVariantId';
		EXCEPTION
        WHEN NO_DATA_FOUND THEN
            EXECUTE IMMEDIATE 'Alter Table VARMAPPINGTABLE Add  ProcessVariantId INT DEFAULT(0) NOT NULL';
            DBMS_OUTPUT.PUT_LINE('Table VARMAPPINGTABLE altered with new Column ProcessVariantId');
	END;
	
	BEGIN
      SELECT CONSTRAINT_NAME INTO v_constraintName FROM USER_CONSTRAINTS 
		WHERE TABLE_NAME = UPPER('VARMAPPINGTABLE') AND constraint_type = 'P';
		EXECUTE IMMEDIATE 'Alter Table VARMAPPINGTABLE Drop Constraint ' || TO_CHAR(v_constraintName);
		EXECUTE IMMEDIATE 'Alter Table VARMAPPINGTABLE Add Constraint ' || TO_CHAR(v_constraintName) || ' Primary Key(ProcessDefID,VariableId,ProcessVariantId)';
		DBMS_OUTPUT.PUT_LINE('Primary Key Updated for VARMAPPINGTABLE');
  	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			DBMS_OUTPUT.PUT_LINE('No Primary Key Exists for VARMAPPINGTABLE');
	END;
	
	BEGIN
        SELECT 1 INTO existsFlag FROM USER_TAB_COLUMNS WHERE Upper(TABLE_NAME) = 'WFUDTVarMappingTable' AND Upper(COLUMN_NAME) = 'ProcessVariantId';
		EXCEPTION
        WHEN NO_DATA_FOUND THEN
            EXECUTE IMMEDIATE 'Alter Table WFUDTVarMappingTable Add  ProcessVariantId INT DEFAULT(0) NOT NULL';
            DBMS_OUTPUT.PUT_LINE('Table WFUDTVarMappingTable altered with new Column ProcessVariantId');
	END;
	
	BEGIN
      SELECT CONSTRAINT_NAME INTO v_constraintName
		FROM USER_CONSTRAINTS 
		WHERE TABLE_NAME = UPPER('WFUDTVarMappingTable') AND constraint_type = 'P';
		EXECUTE IMMEDIATE 'Alter Table WFUDTVarMappingTable Drop Constraint ' || TO_CHAR(v_constraintName);
		EXECUTE IMMEDIATE 'Alter Table WFUDTVarMappingTable Add Constraint ' || TO_CHAR(v_constraintName) || ' Primary Key (ProcessDefId, VariableId, VarFieldId,ProcessVariantId)';
		DBMS_OUTPUT.PUT_LINE('Primary Key Updated for WFUDTVarMappingTable');
  	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			DBMS_OUTPUT.PUT_LINE('No Primary Key Exists for WFUDTVarMappingTable');
	END;
	
	BEGIN
        SELECT 1 INTO existsFlag FROM USER_TAB_COLUMNS WHERE Upper(TABLE_NAME) = 'EXTDBCONFTABLE' AND Upper(COLUMN_NAME) = 'ProcessVariantId';
		EXCEPTION
        WHEN NO_DATA_FOUND THEN
            EXECUTE IMMEDIATE 'Alter Table EXTDBCONFTABLE Add  ProcessVariantId INT DEFAULT(0) NOT NULL';
            DBMS_OUTPUT.PUT_LINE('Table EXTDBCONFTABLE altered with new Column ProcessVariantId');
	END;
	
	BEGIN
      SELECT CONSTRAINT_NAME INTO v_constraintName
		FROM USER_CONSTRAINTS 
		WHERE TABLE_NAME = UPPER('EXTDBCONFTABLE') AND constraint_type = 'P';
		EXECUTE IMMEDIATE 'Alter Table EXTDBCONFTABLE Drop Constraint ' || TO_CHAR(v_constraintName);
		EXECUTE IMMEDIATE 'Alter Table EXTDBCONFTABLE Add Constraint ' || TO_CHAR(v_constraintName) || ' Primary Key (ProcessDefId,ExtObjID,ProcessVariantId)';
		DBMS_OUTPUT.PUT_LINE('Primary Key Updated for EXTDBCONFTABLE');
  	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			DBMS_OUTPUT.PUT_LINE('No Primary Key Exists for EXTDBCONFTABLE');
	END;
	
	BEGIN
        SELECT 1 INTO existsFlag FROM USER_TAB_COLUMNS WHERE Upper(TABLE_NAME) = 'DOCUMENTTYPEDEFTABLE' AND Upper(COLUMN_NAME) = 'ProcessVariantId';
		EXCEPTION
        WHEN NO_DATA_FOUND THEN
            EXECUTE IMMEDIATE 'Alter Table DOCUMENTTYPEDEFTABLE Add  ProcessVariantId INT DEFAULT(0) NOT NULL';
            DBMS_OUTPUT.PUT_LINE('Table DOCUMENTTYPEDEFTABLE altered with new Column ProcessVariantId');
	END;
	
	BEGIN
      SELECT CONSTRAINT_NAME INTO v_constraintName
		FROM USER_CONSTRAINTS 
		WHERE TABLE_NAME = UPPER('DOCUMENTTYPEDEFTABLE') AND constraint_type = 'P';
		EXECUTE IMMEDIATE 'Alter Table DOCUMENTTYPEDEFTABLE Drop Constraint ' || TO_CHAR(v_constraintName);
		EXECUTE IMMEDIATE 'Alter Table DOCUMENTTYPEDEFTABLE Add Constraint ' || TO_CHAR(v_constraintName) || ' Primary Key (ProcessDefId, DocId,ProcessVariantId)';
		DBMS_OUTPUT.PUT_LINE('Primary Key Updated for DOCUMENTTYPEDEFTABLE');
  	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			DBMS_OUTPUT.PUT_LINE('No Primary Key Exists for DOCUMENTTYPEDEFTABLE');
	END;
	
	BEGIN
        SELECT 1 INTO existsFlag FROM USER_TAB_COLUMNS WHERE Upper(TABLE_NAME) = 'WFTYPEDEFTABLE' AND Upper(COLUMN_NAME) = 'ProcessVariantId';
		EXCEPTION
        WHEN NO_DATA_FOUND THEN
            EXECUTE IMMEDIATE 'Alter Table WFTYPEDEFTABLE Add  ProcessVariantId INT DEFAULT(0) NOT NULL';
            DBMS_OUTPUT.PUT_LINE('Table WFTYPEDEFTABLE altered with new Column ProcessVariantId');
	END;
	
	BEGIN
      SELECT CONSTRAINT_NAME INTO v_constraintName
		FROM USER_CONSTRAINTS 
		WHERE TABLE_NAME = UPPER('WFTYPEDEFTABLE') AND constraint_type = 'P';
		EXECUTE IMMEDIATE 'Alter Table WFTYPEDEFTABLE Drop Constraint ' || TO_CHAR(v_constraintName);
		EXECUTE IMMEDIATE 'Alter Table WFTYPEDEFTABLE Add Constraint ' || TO_CHAR(v_constraintName) || ' Primary Key (ProcessDefId, ParentTypeId, TypeFieldId,ProcessVariantId)';
		DBMS_OUTPUT.PUT_LINE('Primary Key Updated for WFTYPEDEFTABLE');
  	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			DBMS_OUTPUT.PUT_LINE('No Primary Key Exists for WFTYPEDEFTABLE');
	END;
	
	BEGIN
        SELECT 1 INTO existsFlag FROM USER_TAB_COLUMNS WHERE Upper(TABLE_NAME) = 'WFTYPEDESCTABLE' AND Upper(COLUMN_NAME) = 'ProcessVariantId';
		EXCEPTION
        WHEN NO_DATA_FOUND THEN
            EXECUTE IMMEDIATE 'Alter Table WFTYPEDESCTABLE Add  ProcessVariantId INT DEFAULT(0) NOT NULL';
            DBMS_OUTPUT.PUT_LINE('Table WFTYPEDESCTABLE altered with new Column ProcessVariantId');
	END;
	
	BEGIN
      SELECT CONSTRAINT_NAME INTO v_constraintName
		FROM USER_CONSTRAINTS 
		WHERE TABLE_NAME = UPPER('WFTYPEDESCTABLE') AND constraint_type = 'P';
		EXECUTE IMMEDIATE 'Alter Table WFTYPEDESCTABLE Drop Constraint ' || TO_CHAR(v_constraintName);
		EXECUTE IMMEDIATE 'Alter Table WFTYPEDESCTABLE Add Constraint ' || TO_CHAR(v_constraintName) || ' Primary Key (ProcessDefId, TypeId,ProcessVariantId)';
		DBMS_OUTPUT.PUT_LINE('Primary Key Updated for WFTYPEDESCTABLE');
  	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			DBMS_OUTPUT.PUT_LINE('No Primary Key Exists for WFTYPEDESCTABLE');
	END;
	
	BEGIN
        SELECT 1 INTO existsFlag FROM USER_TAB_COLUMNS WHERE Upper(TABLE_NAME) = 'WFVARRELATIONTABLE' AND Upper(COLUMN_NAME) = 'ProcessVariantId';
		EXCEPTION
        WHEN NO_DATA_FOUND THEN
            EXECUTE IMMEDIATE 'Alter Table WFVARRELATIONTABLE Add  ProcessVariantId INT DEFAULT(0) NOT NULL';
            DBMS_OUTPUT.PUT_LINE('Table WFVARRELATIONTABLE altered with new Column ProcessVariantId');
	END;
	
	BEGIN
      SELECT CONSTRAINT_NAME INTO v_constraintName
		FROM USER_CONSTRAINTS 
		WHERE TABLE_NAME = UPPER('WFVARRELATIONTABLE') AND constraint_type = 'P';
		EXECUTE IMMEDIATE 'Alter Table WFVARRELATIONTABLE Drop Constraint ' || TO_CHAR(v_constraintName);
		EXECUTE IMMEDIATE 'Alter Table WFVARRELATIONTABLE Add Constraint ' || TO_CHAR(v_constraintName) || ' Primary Key (ProcessDefId, RelationId, OrderId,ProcessVariantId)';
		DBMS_OUTPUT.PUT_LINE('Primary Key Updated for WFVARRELATIONTABLE');
  	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			DBMS_OUTPUT.PUT_LINE('No Primary Key Exists for WFVARRELATIONTABLE');
	END;
	
	BEGIN
        SELECT 1 INTO existsFlag FROM USER_TAB_COLUMNS WHERE Upper(TABLE_NAME) = 'TemplateMultiLanguageTable' AND Upper(COLUMN_NAME) = 'ProcessVariantId';
		EXCEPTION
        WHEN NO_DATA_FOUND THEN
            EXECUTE IMMEDIATE 'Alter Table TemplateMultiLanguageTable Add  ProcessVariantId INT DEFAULT(0) NOT NULL';
            DBMS_OUTPUT.PUT_LINE('Table TemplateMultiLanguageTable altered with new Column ProcessVariantId');
	END;
	
	BEGIN
      SELECT CONSTRAINT_NAME INTO v_constraintName
		FROM USER_CONSTRAINTS 
		WHERE TABLE_NAME = UPPER('TemplateMultiLanguageTable') AND constraint_type = 'P';
		EXECUTE IMMEDIATE 'Alter Table TemplateMultiLanguageTable Drop Constraint ' || TO_CHAR(v_constraintName);
		EXECUTE IMMEDIATE 'Alter Table TemplateMultiLanguageTable Add Constraint ' || TO_CHAR(v_constraintName) || ' Primary Key (PROCESSDEFID, TEMPLATEID, LOCALE,ProcessVariantId)';
		DBMS_OUTPUT.PUT_LINE('Primary Key Updated for TemplateMultiLanguageTable');
  	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			DBMS_OUTPUT.PUT_LINE('No Primary Key Exists for TemplateMultiLanguageTable');
	END;
	
	BEGIN
        SELECT 1 INTO existsFlag FROM USER_TAB_COLUMNS WHERE Upper(TABLE_NAME) = 'WFFORM_TABLE' AND Upper(COLUMN_NAME) = 'ProcessVariantId';
		EXCEPTION
        WHEN NO_DATA_FOUND THEN
            EXECUTE IMMEDIATE 'Alter Table WFFORM_TABLE Add  ProcessVariantId INT DEFAULT(0) NOT NULL';
            DBMS_OUTPUT.PUT_LINE('Table WFFORM_TABLE altered with new Column ProcessVariantId');
	END;
	
	BEGIN
      SELECT CONSTRAINT_NAME INTO v_constraintName
		FROM USER_CONSTRAINTS 
		WHERE TABLE_NAME = UPPER('WFFORM_TABLE') AND constraint_type = 'P';
		EXECUTE IMMEDIATE 'Alter Table WFFORM_TABLE Drop Constraint ' || TO_CHAR(v_constraintName);
		EXECUTE IMMEDIATE 'Alter Table WFFORM_TABLE Add Constraint ' || TO_CHAR(v_constraintName) || ' Primary Key (PROCESSDEFID, FORMID,ProcessVariantId)';
		DBMS_OUTPUT.PUT_LINE('Primary Key Updated for WFFORM_TABLE');
  	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			DBMS_OUTPUT.PUT_LINE('No Primary Key Exists for WFFORM_TABLE');
	END;
	
	BEGIN
        SELECT 1 INTO existsFlag FROM USER_TAB_COLUMNS WHERE Upper(TABLE_NAME) = 'GTEMPWORKLISTTABLE' AND Upper(COLUMN_NAME) = 'ProcessVariantId';
		EXCEPTION
        WHEN NO_DATA_FOUND THEN
            EXECUTE IMMEDIATE 'Alter Table GTEMPWORKLISTTABLE Add  ProcessVariantId INT ';
            DBMS_OUTPUT.PUT_LINE('Table GTEMPWORKLISTTABLE altered with new Column ProcessVariantId');
	END;
	
	BEGIN
		Execute Immediate 'Alter Table ActivityInterfaceAssocTable Add  ProcessVariantId INT DEFAULT(0) NOT NULL';
		Execute Immediate 'Alter Table ProcessInstanceTable Add  ProcessVariantId INT DEFAULT(0) NOT NULL';
		Execute Immediate 'Alter Table WorkListTable Add  ProcessVariantId INT DEFAULT(0) NOT NULL';
		Execute Immediate 'Alter Table WorkDoneTable Add  ProcessVariantId INT DEFAULT(0) NOT NULL';
		Execute Immediate 'Alter Table PendingWorkListTable Add  ProcessVariantId INT DEFAULT(0) NOT NULL';
		Execute Immediate 'Alter Table WorkInProcessTable Add  ProcessVariantId INT DEFAULT(0) NOT NULL';
		Execute Immediate 'Alter Table WorkWithPSTable Add  ProcessVariantId INT DEFAULT(0) NOT NULL';
		Execute Immediate 'Alter Table QueueHistoryTable Add  ProcessVariantId INT DEFAULT(0) NOT NULL';
		Execute Immediate 'Alter Table WFCurrentRouteLogTable Add  ProcessVariantId INT DEFAULT(0) NOT NULL';
		Execute Immediate 'Alter Table WFHistoryRouteLogTable Add  ProcessVariantId INT DEFAULT(0) NOT NULL';
		Execute Immediate 'Alter Table SummaryTable Add  ProcessVariantId INT DEFAULT(0) NOT NULL';
		Execute Immediate 'Alter Table WFReportDataTable Add  ProcessVariantId INT DEFAULT(0) NOT NULL';
		Execute Immediate 'Alter Table WFVarStatusTable Add  ProcessVariantId INT DEFAULT(0) NOT NULL';
		Execute Immediate 'Alter Table WFCommentsTable Add  ProcessVariantId INT DEFAULT(0) NOT NULL';
	END;
	
	BEGIN
		SELECT LAST_NUMBER INTO v_lastSeqValue
		FROM USER_SEQUENCES
		WHERE SEQUENCE_NAME = UPPER('ProcessVariantId');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'CREATE SEQUENCE ProcessVariantId INCREMENT BY 1 START WITH 1';
			dbms_output.put_line ('SEQUENCE ProcessVariantId Successfully Created');
	END;
	
	BEGIN
		SELECT LAST_NUMBER INTO v_lastSeqValue
		FROM USER_SEQUENCES
		WHERE SEQUENCE_NAME = UPPER('FormExtId');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'CREATE SEQUENCE FormExtId INCREMENT BY 1 START WITH 1';
			dbms_output.put_line ('SEQUENCE FormExtId Successfully Created');
	END;
	
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TRIGGERS
		WHERE TRIGGER_NAME=UPPER('WFDeleteProcessVariantTrigger');
	EXCEPTION
	WHEN NO_DATA_FOUND THEN
		EXECUTE IMMEDIATE
		'CREATE OR REPLACE TRIGGER WFDeleteProcessVariantTrigger
			AFTER DELETE ON WFProcessVariantDefTable
			FOR EACH ROW 	  
			BEGIN  
				Delete from ACTIVITYASSOCIATIONTABLE where ProcessVariantId =:old.ProcessVariantId;
				Delete from VARMAPPINGTABLE where ProcessVariantId = :old.ProcessVariantId;
				Delete from WFUDTVarMappingTable where ProcessVariantId = :old.ProcessVariantId;
				Delete from EXTDBCONFTABLE where ProcessVariantId = :old.ProcessVariantId;
				Delete from DOCUMENTTYPEDEFTABLE where ProcessVariantId = :old.ProcessVariantId;
				Delete from WFTYPEDEFTABLE where ProcessVariantId = :old.ProcessVariantId;
				Delete from WFTYPEDESCTABLE where ProcessVariantId = :old.ProcessVariantId;
				Delete from WFVARRELATIONTABLE where ProcessVariantId = :old.ProcessVariantId;
				Delete from TEMPLATEMULTILANGUAGETABLE where ProcessVariantId = :old.ProcessVariantId;
				Delete from ACTIVITYINTERFACEASSOCTABLE where ProcessVariantId = :old.ProcessVariantId;
				Delete from WFFORM_TABLE where ProcessVariantId = :old.ProcessVariantId;	
			';
		DBMS_OUTPUT.PUT_LINE('New trigger created with name as WF_USR_DEL');
	END;
	
	BEGIN
	v_STR1 := 'CREATE OR REPLACE VIEW QUEUETABLE 
	AS
	SELECT queuetable1.processdefid, processname, processversion,queuetable1.processinstanceid,
		 queuetable1.processinstanceid AS processinstancename, 
		 queuetable1.activityid, queuetable1.activityname, 
		 QUEUEDATATABLE.parentworkitemid, queuetable1.workitemid, 
		 processinstancestate, workitemstate, statename, queuename, queuetype,
		 assigneduser, assignmenttype, instrumentstatus, checklistcompleteflag, 
		 introductiondatetime, PROCESSINSTANCETABLE.createddatetime AS createddatetime,
		 introducedby, createdbyname, entrydatetime,lockstatus, holdstatus, 
		 prioritylevel, lockedbyname, lockedtime, validtill, savestage, 
		 previousstage,	expectedworkitemdelay AS expectedworkitemdelaytime,
	         expectedprocessdelay AS expectedprocessdelaytime, status, 
		 var_int1, var_int2, var_int3, var_int4, var_int5, var_int6, var_int7, var_int8, 
		 var_float1, var_float2, var_date1, var_date2, var_date3, var_date4, 
		 var_long1, var_long2, var_long3, var_long4, 
		 var_str1, var_str2, var_str3, var_str4, var_str5, var_str6, var_str7, var_str8,
		 var_rec_1, var_rec_2, var_rec_3, var_rec_4, var_rec_5,	
		 q_streamid, q_queueid, q_userid, LastProcessedBy, processedby, referredto,
		 referredtoname, referredby, referredbyname, collectflag, NULL AS CompletionDateTime, CalendarName, queuetable1.ProcessVariantId
	FROM	QUEUEDATATABLE, 
		PROCESSINSTANCETABLE,
		(SELECT processinstanceid, workitemid, processname, processversion,
			 processdefid, LastProcessedBy, processedby, activityname, activityid,
			 entrydatetime, parentworkitemid, assignmenttype,
			 collectflag, prioritylevel, validtill, q_streamid,
			 q_queueid, q_userid, assigneduser, createddatetime,
			 workitemstate, expectedworkitemdelay, previousstage,
			 lockedbyname, lockstatus, lockedtime, queuename, queuetype,
			 statename, ProcessVariantId
		FROM	WORKLISTTABLE
	        UNION ALL
		SELECT processinstanceid, workitemid, processname, processversion,
			processdefid, LastProcessedBy, processedby, activityname, activityid,
			entrydatetime, parentworkitemid, assignmenttype,collectflag, 
			prioritylevel, validtill, q_streamid,q_queueid, q_userid, 
			assigneduser, createddatetime,workitemstate, expectedworkitemdelay, 
			previousstage,lockedbyname, lockstatus, lockedtime, queuename, 
			queuetype,statename, ProcessVariantId
		FROM   WORKINPROCESSTABLE
	        UNION ALL
		SELECT processinstanceid, workitemid, processname, processversion,
			processdefid, LastProcessedBy, processedby, activityname, activityid,
			entrydatetime, parentworkitemid, assignmenttype,
			collectflag, prioritylevel, validtill, q_streamid,
			q_queueid, q_userid, assigneduser, createddatetime,
			workitemstate, expectedworkitemdelay, previousstage,
			lockedbyname, lockstatus, lockedtime, queuename, queuetype,
			statename, ProcessVariantId
		FROM   WORKDONETABLE
		UNION ALL
		SELECT processinstanceid, workitemid, processname, processversion,
			processdefid, LastProcessedBy, processedby, activityname, activityid,
			entrydatetime, parentworkitemid, assignmenttype,
			collectflag, prioritylevel, validtill, q_streamid,
			q_queueid, q_userid, assigneduser, createddatetime,
			workitemstate, expectedworkitemdelay, previousstage,
			lockedbyname, lockstatus, lockedtime, queuename, queuetype,
			statename, ProcessVariantId
		FROM   WORKWITHPSTABLE
		UNION ALL
		SELECT processinstanceid, workitemid, processname, processversion,
			processdefid, LastProcessedBy, processedby, activityname, activityid,
			entrydatetime, parentworkitemid, assignmenttype,
			collectflag, prioritylevel, validtill, q_streamid,
			q_queueid, q_userid, assigneduser, createddatetime,
			workitemstate, expectedworkitemdelay, previousstage,
			lockedbyname, lockstatus, lockedtime, queuename, queuetype,
			statename, ProcessVariantId
		FROM   PENDINGWORKLISTTABLE) queuetable1
	WHERE   QUEUEDATATABLE.processinstanceid = queuetable1.processinstanceid
	AND	QUEUEDATATABLE.workitemid = queuetable1.workitemid
	AND	queuetable1.processinstanceid = PROCESSINSTANCETABLE.processinstanceid';

	EXECUTE IMMEDIATE v_STR1;
	END;
	
	BEGIN
	v_STR1 := 'CREATE OR REPLACE VIEW QUEUEVIEW 
	AS 
	SELECT * FROM QUEUETABLE	
	UNION ALL	
	SELECT PROCESSDEFID, PROCESSNAME, PROCESSVERSION, PROCESSINSTANCEID, PROCESSINSTANCEID AS PROCESSINSTANCENAME,	ACTIVITYID, ACTIVITYNAME, PARENTWORKITEMID, WORKITEMID, PROCESSINSTANCESTATE, WORKITEMSTATE, STATENAME, 	QUEUENAME, QUEUETYPE, ASSIGNEDUSER, ASSIGNMENTTYPE, INSTRUMENTSTATUS, CHECKLISTCOMPLETEFLAG, INTRODUCTIONDATETIME,CREATEDDATETIME AS CREATEDDATETIME, INTRODUCEDBY, CREATEDBYNAME, ENTRYDATETIME, LOCKSTATUS, HOLDSTATUS, PRIORITYLEVEL, LOCKEDBYNAME, LOCKEDTIME, VALIDTILL, SAVESTAGE, PREVIOUSSTAGE, EXPECTEDWORKITEMDELAYTIME AS EXPECTEDWORKITEMDELAYTIME, EXPECTEDPROCESSDELAYTIME AS EXPECTEDPROCESSDELAYTIME, STATUS, VAR_INT1, VAR_INT2, VAR_INT3, VAR_INT4, VAR_INT5, VAR_INT6, VAR_INT7, VAR_INT8, VAR_FLOAT1, VAR_FLOAT2, VAR_DATE1, VAR_DATE2, VAR_DATE3, VAR_DATE4, VAR_LONG1, VAR_LONG2, VAR_LONG3, VAR_LONG4, VAR_STR1, VAR_STR2, VAR_STR3, VAR_STR4, VAR_STR5, VAR_STR6, VAR_STR7, VAR_STR8, VAR_REC_1, VAR_REC_2, VAR_REC_3, VAR_REC_4, VAR_REC_5, Q_STREAMID, Q_QUEUEID, Q_USERID, LASTPROCESSEDBY, PROCESSEDBY, REFERREDTO, REFERREDTONAME, REFERREDBY, REFERREDBYNAME, COLLECTFLAG, NULL AS COMPLETIONDATETIME, CALENDARNAME, PROCESSVARIANTID FROM QUEUEHISTORYTABLE';

	EXECUTE IMMEDIATE v_STR1;
	END;
	
	/* End of Upgrade for Process Variant Support */
 
END;


~
call upgrade10()

~
drop procedure upgrade10