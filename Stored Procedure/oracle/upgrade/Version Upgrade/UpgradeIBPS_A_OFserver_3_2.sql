~
create or replace
PROCEDURE Upgrade AS
existsFlag				INTEGER:=0;
v_lastSeqValue			INTEGER;
v_ProcessDefId			INTEGER;
v_Query                 VARCHAR2(8000);
v_STR1			        VARCHAR2(8000);
v_constraintName		VARCHAR2(512);
v_RegStartingNo			INTEGER;
v_SeqName				VARCHAR2(30);
TYPE DynamicCursor	IS REF CURSOR;
CursorObjTable		    DynamicCursor;
CursorExtObjId		    DynamicCursor;
v_ExtObjId				INTEGER;
v_STR2			        VARCHAR2(8000);
v_AllowSoapRequest  	VARCHAR2(1);
v_ActivityId_actSub 	INTEGER;
v_ActivityType_actSub  	INTEGER;
v_activitysubtype 		INTEGER;
v_previousProcessDefId  INTEGER:= 0;
v_counter 			    INTEGER;
v_sourceId 			    INTEGER;
v_targetId			    INTEGER;
Comments                VARCHAR2(255);
counter_comments        INTEGER;
cur_coonectionId 	    DynamicCursor;
cur_actSub  			DynamicCursor;
cur_processComment      DynamicCursor;
cur_processDef  	    DynamicCursor;
cur_QueueDef		    DynamicCursor;
cur_ImportPro		    DynamicCursor;
curr_Quser              DynamicCursor;
v_ConfigurationId		INTEGER;
cursor2            		DynamicCursor;
v_cabVersion        	VARCHAR2(2000);
v_param1				Varchar2(2000);
v_VariableId			INTEGER;
v_variableType			Integer;
v_QueueName     	    Varchar2(2000);
v_ImportedProName  	    Varchar2(8000);
v_ImportProid		    Integer;	
v_pSeqVar			    Integer:= 0;
v_nSeqVar			    Integer:= 0;	
v_ActivityId_seq 	    Integer;
v_ActivityType_seq		Integer;
cur_ActSeqId			DynamicCursor;
v_ProcessName  		    VARCHAR2(2000);
cur_extObjId    	    DynamicCursor;
cur_extDbField		    DynamicCursor;
cur_getCols			    DynamicCursor;
v_inner_TableName	    varchar2(100);
archieveQId             INTEGER;
pfeQId                  INTEGER;
sharePtQId              INTEGER;
objectTypeId		    INTEGER;
QueueId                 INTEGER;
userid                  INTEGER;
assocType               INTEGER;
v_mobileEnabled		    NVARCHAR2(1);
p_count                 INTEGER;
v_nullable              NVARCHAR2(1);
PreviousProcessDefId_comments INTEGER;
/*added by server team -- start here */
v_existsFlag		INT;
v_TableId 			INT;
Cursor1				DynamicCursor;
v_SearchCondition    NVARCHAR2(5000);
v_SearchConditionOld NVARCHAR2(5000);
v_SearchConditionNew NVARCHAR2(5000);
v_IsConstraintUpdated INT;
v_PrevQueueId INT;
v_PrevProcName NVARCHAR2 (30);
/*added by server team -- end here*/
v_Seq_PrcMgmt	Integer:=1;
v_Seq_QueueMgmt	Integer:=1;
v_Seq_OTMS		Integer:=1;
Comments   NVARCHAR2(2000);
v_rowCount Integer:=0;
v_importedprocessdefid INTEGER;
v_QueryTemp   VARCHAR2(2000);
v_QueryTemp1   VARCHAR2(2000);
v_maxProcId	INTEGER:=1;
v_pmwFlag 	VARCHAR2(2);
v_swimlaneQueueId INTEGER := -1;


/*................................... Adding New Table ............................................... */
BEGIN
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_TABLES  
		WHERE TABLE_NAME = UPPER('WFUpgradeLoggingTable');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			EXECUTE IMMEDIATE 
			'CREATE TABLE WFUpgradeLoggingTable(
				logdetails	NVARCHAR2(2000)
				
			)';
			dbms_output.put_line ('Table WFUpgradeLoggingTable Created successfully');
	END;
	
	v_pmwFlag := 'N';
	existsFlag :=0;	
	SELECT Count(1) INTO existsFlag FROM USER_TABLES WHERE TABLE_NAME = UPPER('PMWPRocessDefTable');
	IF(existsFlag=1) THEN
	BEGIN
		v_pmwFlag := 'Y';
	END;
	END IF;
	
	IF(v_pmwFlag = 'N') THEN
    BEGIN 
        EXECUTE IMMEDIATE('Delete from WFSwimlanetable');
		EXECUTE IMMEDIATE('INSERT INTO WFUpgradeLoggingTable VALUES (''Delete from WFSwimlanetable'')');
			
	END;
	END IF;
	
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
			/*dbms_output.put_line ('Table WFAuditRuleTable Created successfully');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Table WFAuditRuleTable Created successfully '')';
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
			/*dbms_output.put_line ('Table WFAuditTrackTable Created successfully');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Table WFAuditTrackTable Created successfully'')';
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
			/*dbms_output.put_line ('Table WFActivitySequenceTABLE Created successfully');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Table WFActivitySequenceTABLE Created successfully'')';
			
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
			/*dbms_output.put_line ('Table WFMileStoneTable Created successfully');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Table WFMileStoneTable Created successfully'')';
			
			
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
			/*dbms_output.put_line ('Table WFProjectListTable Created successfully');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Table WFProjectListTable Created successfully'')';
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
			/*dbms_output.put_line ('Table WFEventDetailsTable Created successfully');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Table WFEventDetailsTable Created successfully'')';
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
			/*dbms_output.put_line ('Table WFRepeatEventTable Created successfully');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Table WFRepeatEventTable Created successfully'')';
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
			/*dbms_output.put_line ('Table WFOwnerTable Created successfully');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Table WFOwnerTable Created successfully'')';
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
			/*dbms_output.put_line ('Table WFConsultantsTable Created successfully');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Table WFConsultantsTable Created successfully'')';
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
			/*dbms_output.put_line ('Table WFSystemTable Created successfully');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Table WFSystemTable Created successfully'')';
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
			/*dbms_output.put_line ('Table WFProviderTable Created successfully');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Table WFProviderTable Created successfully'')';
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
			/*dbms_output.put_line ('Table WFConsumerTable Created successfully');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Table WFConsumerTable Created successfully'')';
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
			/*dbms_output.put_line ('Table WFPoolTable Created successfully');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Table WFConsumerTable Created successfully'')';
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
			/*dbms_output.put_line ('Table WFRecordedChats Created successfully');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Table WFRecordedChats Created successfully'')';
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
			/*dbms_output.put_line ('Table WFRequirementTable Created successfully');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Table WFRequirementTable Created successfully'')';
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
			/*dbms_output.put_line ('Table WFDocBuffer Created successfully');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Table WFDocBuffer Created successfully'')';
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
				DefaultQueue	NVARCHAR2(1) DEFAULT ''N'',
				PRIMARY KEY (ProcessDefId, SwimLaneId, QueueID)
			)';
			/*dbms_output.put_line ('Table WFLaneQueueTable Created successfully');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Table WFLaneQueueTable Created successfully'')';
	END;
	
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_TABLES  
		WHERE TABLE_NAME = UPPER('MenuListTable');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			EXECUTE IMMEDIATE 
			'CREATE TABLE MenuListTable(
				MenuDefId int NOT NULL,
				AppName nvarchar2(255) NOT NULL,
				MenuLabel nvarchar2(255) NOT NULL,
				MenuName nvarchar2(255) NOT NULL,
				CONSTRAINT pk_MenuListTable PRIMARY KEY (MenuDefId)	
			)';
			/*dbms_output.put_line ('Table MenuListTable Created successfully');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Table MenuListTable Created successfully'')';
			EXECUTE IMMEDIATE 'CREATE SEQUENCE  MenuListDefIdSeq START WITH 1 INCREMENT BY 1 ';
			EXECUTE IMMEDIATE 'INSERT INTO MenuListTable values (MenuListDefIdSeq.nextval,''PMWMENU'',''Save Process'',''SAVEPROCESS'')';
			EXECUTE IMMEDIATE 'INSERT INTO MenuListTable values (MenuListDefIdSeq.nextval,''PMWMENU'',''Version'',''VERSION'')';
			EXECUTE IMMEDIATE 'INSERT INTO MenuListTable values (MenuListDefIdSeq.nextval,''PMWMENU'',''Audit Trail'',''AUDITRAIL'')';
			EXECUTE IMMEDIATE 'INSERT INTO MenuListTable values (MenuListDefIdSeq.nextval,''PMWMENU'',''Include Window'',''INCLUDEWINDOW'')';
			EXECUTE IMMEDIATE 'INSERT INTO MenuListTable values (MenuListDefIdSeq.nextval,''PMWMENU'',''ToDoList'',''TODOLIST'')';
			EXECUTE IMMEDIATE 'INSERT INTO MenuListTable values (MenuListDefIdSeq.nextval,''PMWMENU'',''Documents'',''DOCUMENTS'')';
			EXECUTE IMMEDIATE 'INSERT INTO MenuListTable values (MenuListDefIdSeq.nextval,''PMWMENU'',''Catalog Definition'',''CATLOGDEFINATION'')';
			EXECUTE IMMEDIATE 'INSERT INTO MenuListTable values (MenuListDefIdSeq.nextval,''PMWMENU'',''Exception'',''EXCEPTION'')';
			EXECUTE IMMEDIATE 'INSERT INTO MenuListTable values (MenuListDefIdSeq.nextval,''PMWMENU'',''Trigger'',''TRIGGER'')';
			EXECUTE IMMEDIATE 'INSERT INTO MenuListTable values (MenuListDefIdSeq.nextval,''PMWMENU'',''Register Template'',''REGISTERTEMPLATE'')';
			EXECUTE IMMEDIATE 'INSERT INTO MenuListTable values (MenuListDefIdSeq.nextval,''PMWMENU'',''Register Window'',''REGISTERWINDOW'')';
			EXECUTE IMMEDIATE 'INSERT INTO MenuListTable values (MenuListDefIdSeq.nextval,''PMWMENU'',''Register Trigger'',''RIGSTERTRIGGER'')';
			EXECUTE IMMEDIATE 'INSERT INTO MenuListTable values (MenuListDefIdSeq.nextval,''PMWMENU'',''Constants'',''CONSTANTS'')';
			EXECUTE IMMEDIATE 'INSERT INTO MenuListTable values (MenuListDefIdSeq.nextval,''PMWMENU'',''Define Table'',''DEFINETABLE'')';
			EXECUTE IMMEDIATE 'INSERT INTO MenuListTable values (MenuListDefIdSeq.nextval,''PMWMENU'',''External Variables'',''EXTERNALVARIABLE'')';
			EXECUTE IMMEDIATE 'INSERT INTO MenuListTable values (MenuListDefIdSeq.nextval,''PMWMENU'',''ComplexTypes'',''COMPLEXTYPES'')';
			EXECUTE IMMEDIATE 'INSERT INTO MenuListTable values (MenuListDefIdSeq.nextval,''PMWMENU'',''Queue Variables'',''QUEUEVARIABLES'')';
			EXECUTE IMMEDIATE 'INSERT INTO MenuListTable values (MenuListDefIdSeq.nextval,''PMWMENU'',''Search Variables'',''SEARCHVARIABLES'')';
			 EXECUTE IMMEDIATE 'INSERT INTO MenuListTable values (MenuListDefIdSeq.nextval,''PMWMENU'',''Create Project'',''CREATEPROJECT'')';
			EXECUTE IMMEDIATE 'INSERT INTO MenuListTable values (MenuListDefIdSeq.nextval,''PMWMENU'',''Delete Project'',''DELETEPROJECT'')';
			EXECUTE IMMEDIATE 'INSERT INTO MenuListTable values (MenuListDefIdSeq.nextval,''PMWMENU'',''Create Process'',''CREATEPROCESS'')';
			EXECUTE IMMEDIATE 'INSERT INTO MenuListTable values (MenuListDefIdSeq.nextval,''PMWMENU'',''Delete Process'',''DELETEPROCESS'')';
			EXECUTE IMMEDIATE 'INSERT INTO MenuListTable values (MenuListDefIdSeq.nextval,''PMWMENU'',''Register Process'',''REGISTERPROCESS'')';
			EXECUTE IMMEDIATE 'INSERT INTO MenuListTable values (MenuListDefIdSeq.nextval,''PMWMENU'',''Import Process'',''IMPORTPROCESS'')';
			EXECUTE IMMEDIATE 'INSERT INTO MenuListTable values (MenuListDefIdSeq.nextval,''PMWMENU'',''Export Process'',''EXPORTPROCESS'')';
			EXECUTE IMMEDIATE 'INSERT INTO MenuListTable values (MenuListDefIdSeq.nextval,''PMWMENU'',''Report Generation'',''REPORTGENERATION'')';
			EXECUTE IMMEDIATE 'INSERT INTO MenuListTable values (MenuListDefIdSeq.nextval,''PMWMENU'',''Create Milestone'',''CREATEMILESTONE'')';
			EXECUTE IMMEDIATE 'INSERT INTO MenuListTable values (MenuListDefIdSeq.nextval,''PMWMENU'',''Delete Milestone'',''DELETEMILESTONE'')';
			EXECUTE IMMEDIATE 'INSERT INTO MenuListTable values (MenuListDefIdSeq.nextval,''PMWMENU'',''Modify Milestone'',''MODIFYMILESTONE'')';
			EXECUTE IMMEDIATE 'INSERT INTO MenuListTable values (MenuListDefIdSeq.nextval,''PMWMENU'',''Add Activity'',''ADDACTIVITY'')';
			EXECUTE IMMEDIATE 'INSERT INTO MenuListTable values (MenuListDefIdSeq.nextval,''PMWMENU'',''Create SwimLane'',''CREATESWIMLANE'')';
			EXECUTE IMMEDIATE 'INSERT INTO MenuListTable values (MenuListDefIdSeq.nextval,''PMWMENU'',''Delete SwimLane'',''DELETESWIMLANE'')';
			EXECUTE IMMEDIATE 'INSERT INTO MenuListTable values (MenuListDefIdSeq.nextval,''PMWMENU'',''Modify SwimLane'',''MODIFYSWIMLANE'')';
			EXECUTE IMMEDIATE 'INSERT INTO MenuListTable values (MenuListDefIdSeq.nextval,''PMWMENU'',''Queue Management'',''QUEUEMANAGEMENT'')';
			EXECUTE IMMEDIATE 'INSERT INTO MenuListTable values (MenuListDefIdSeq.nextval,''PMWMENU'',''Delete Activity'',''DELETEACTIVITY'')';
			EXECUTE IMMEDIATE 'INSERT INTO MenuListTable values (MenuListDefIdSeq.nextval,''PMWMENU'',''Modify Activity'',''MODIFYACTIVITY'')';
			EXECUTE IMMEDIATE 'INSERT INTO MenuListTable values (MenuListDefIdSeq.nextval,''PMWMENU'',''Manage Form'',''MANAGEFORM'')';
			EXECUTE IMMEDIATE 'INSERT INTO MenuListTable values (MenuListDefIdSeq.nextval,''PMWMENU'',''Import Business Objects'',''IMPORTBUSINESSOBJECT'')';
			EXECUTE IMMEDIATE 'INSERT INTO MenuListTable values (MenuListDefIdSeq.nextval,''PMWMENU'',''View Form'',''VIEWFORM'')';
			EXECUTE IMMEDIATE 'INSERT INTO MenuListTable values (MenuListDefIdSeq.nextval,''PMWMENU'',''Maker-Checker'',''MAKERCHECKER'')';
			EXECUTE IMMEDIATE 'INSERT INTO MenuListTable values (MenuListDefIdSeq.nextval,''PMWMENU'',''Add Queue'',''ADDQUEUE'')';
			EXECUTE IMMEDIATE 'INSERT INTO MenuListTable values (MenuListDefIdSeq.nextval,''PMWMENU'',''Define Variable Alias'',''DEFINEVARALIAS'')';
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Values inserted in  MenuListTable successfully'')';
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
			/*dbms_output.put_line ('Table WFCreateChildWITable Created successfully');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Table WFCreateChildWITable Created successfully'')';
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
			/*dbms_output.put_line ('Table CONFLICTINGQUEUEUSERTABLE Created successfully');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Table CONFLICTINGQUEUEUSERTABLE Created successfully'')';
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
				TaskId	    		INT DEFAULT 0 NOT NULL,
				WSLayoutDefinition 	VARCHAR2(4000),
				PRIMARY KEY (ProcessDefId, ActivityId)
			)';
			/*dbms_output.put_line ('Table WFWorkdeskLayoutTable Created successfully');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Table WFWorkdeskLayoutTable Created successfully'')';
			v_STR1 := 'Delete from WFWorkdeskLayoutTable where processdefid = 0 and ActivityId= 0 and TaskId = 0';
			EXECUTE IMMEDIATE v_STR1;
			v_STR1 := 'Insert into WFWorkdeskLayoutTable (ProcessDefId, ActivityId,TaskId,WSLayoutDefinition) values (0, 0,0, ''<WDeskLayout Interfaces="4"><Resolution><ScreenWidth>1024</ScreenWidth><ScreenHeight>768</ScreenHeight></Resolution>        <WDeskInterfaces><Interface Type=''''FormView'''' Top=''''50'''' Left=''''2'''' Width=''''501'''' Height=''''615''''/><Interface Type=''''Document'''' Top=''''50'''' Left=''''510'''' Width=''''501'''' Height=''''615''''/></WDeskInterfaces><MenuInterfaces><Interface Type="Exceptions"/><Interface Type="ToDoList"/></MenuInterfaces></WDeskLayout>'')';
			EXECUTE IMMEDIATE v_STR1;
	END;

    BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_TABLES  
		WHERE TABLE_NAME = UPPER('WFUserSkillCategoryTable');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			EXECUTE IMMEDIATE 
			'CREATE TABLE WFUserSkillCategoryTable (
				 CategoryId     INT   PRIMARY KEY,
				 CategoryName    Nvarchar2(256)  NOT NULL ,
				 CategoryDefinedBy   INT  NOT NULL ,
				 CategoryDefinedOn   Date,
				 CategoryAvailableForRating  NVARCHAR2(1) 
				)';
			EXECUTE IMMEDIATE 'INSERT  INTO WFUserSkillCategoryTable(Categoryid, CategoryName,CategoryDefinedBy,CategoryAvailableForRating) values(1,''Default'',1,''N'')';
			/*dbms_output.put_line ('Table WFUserSkillCategoryTable Created successfully');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Table WFUserSkillCategoryTable Created successfully'')';
	END;
    BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_TABLES  
		WHERE TABLE_NAME = UPPER('WFUserSkillDefinitionTable');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			EXECUTE IMMEDIATE 
			'CREATE TABLE WFUserSkillDefinitionTable (
				 SkillId      INT   PRIMARY KEY,
				 CategoryId     INT  NOT NULL ,
				 SkillName     NVARCHAR2(256),
				 SkillDescription   Nvarchar2(512),
				 SkillDefinedBy    INT  NOT NULL ,
				 SkillDefinedOn    Date,
				 SkillAvailableForRating  NVARCHAR2(1) 
				)';
				/*Creating sequence */
			EXECUTE IMMEDIATE 'CREATE SEQUENCE seq_userExpertise INCREMENT BY 1 START WITH 1';
			/*dbms_output.put_line ('Table WFUserSkillDefinitionTable Created successfully');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Table WFUserSkillDefinitionTable Created successfully'')';
	END;
	
    BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_TABLES  
		WHERE TABLE_NAME = UPPER('WFUserRatingLogTable');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			EXECUTE IMMEDIATE 
			'CREATE TABLE WFUserRatingLogTable (
				 RatingLogId     INT 	NOT NULL ,
				 RatingToUser    INT    NOT NULL ,
				 RatingByUser    INT    NOT NULL,
				 SkillId      	 INT    NOT NULL,
				 Rating      DECIMAL(5,2)  NOT NULL ,
				 RatingDateTime    DATE,
				 Remarks       NVARCHAR2(512) ,
				 PRIMARY KEY ( RatingToUser , RatingByUser,SkillId)
				 )';
				 
				
			EXECUTE IMMEDIATE 'CREATE SEQUENCE seq_userRating INCREMENT BY 1 START WITH 1';
				
			/*dbms_output.put_line ('Table WFUserRatingLogTable Created successfully');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Table WFUserRatingLogTable Created successfully'')';
	END;	
	
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_TABLES  
		WHERE TABLE_NAME = UPPER('WFUserRatingSummaryTable');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			EXECUTE IMMEDIATE 
			'CREATE TABLE WFUserRatingSummaryTable (
				 UserId       INT    NOT NULL,
				 SkillId      INT    NOT NULL ,
				 AverageRating    DECIMAL(5,2) NOT NULL,
				 RatingCount     INT NOT NULL,
				  PRIMARY KEY (UserId,SkillId)
				 )';
			/*dbms_output.put_line ('Table WFUserRatingSummaryTable Created successfully');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Table WFUserRatingSummaryTable Created successfully'')';
	END;
	
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_TABLES  
		WHERE TABLE_NAME = UPPER('WFRTTaskInterfaceAssocTable');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			EXECUTE IMMEDIATE 
			'create table WFRTTaskInterfaceAssocTable (
				ProcessInstanceId NVarchar2(63) NOT NULL,
				WorkItemId  INT NOT NULL,
				ProcessDefId INT  NOT NULL, 
				ActivityId INT NOT NULL,
				TaskId Integer NOT NULL, 
				InterfaceId Integer NOT NULL, 
				InterfaceType NCHAR(1) NOT NULL,
				Attribute NVarchar2(2)
			)';
			EXECUTE IMMEDIATE 'CREATE INDEX IDX1_WFRTTaskIntAssocTable ON WFRTTaskInterfaceAssocTable(PROCESSINSTANCEID,WorkitemId)';
			/*dbms_output.put_line ('Table WFRTTaskInterfaceAssocTable Created successfully');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Table WFRTTaskInterfaceAssocTable Created successfully'')';
	END;
	
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_TABLES  
		WHERE TABLE_NAME = UPPER('RTACTIVITYINTERFACEASSOCTABLE');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			EXECUTE IMMEDIATE 
			'CREATE TABLE RTACTIVITYINTERFACEASSOCTABLE (
				ProcessInstanceId NVarchar2(63) NOT NULL,
				WorkItemId                INT NOT NULL,
				ProcessDefId             INT		NOT NULL,
				ActivityId              INT             NOT NULL,
				ActivityName            NVARCHAR2(30)    NOT NULL,
				InterfaceElementId      INT             NOT NULL,
				InterfaceType           NVARCHAR2(1)     NOT NULL,
				Attribute               NVARCHAR2(2)     NULL,
				TriggerName             NVARCHAR2(255)   NULL,
				ProcessVariantId 		INT 			DEFAULT 0 NOT NULL 
			)';
			EXECUTE IMMEDIATE 'CREATE INDEX IDX1_RTACTIVITYINTASSOCTABLE ON RTACTIVITYINTERFACEASSOCTABLE(PROCESSINSTANCEID,WorkitemId)';
			/*dbms_output.put_line ('Table RTACTIVITYINTERFACEASSOCTABLE Created successfully');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Table RTACTIVITYINTERFACEASSOCTABLE Created successfully'')';
	END;
	
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_TABLES  
		WHERE TABLE_NAME = UPPER('WFApprovalTaskDataTable');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			EXECUTE IMMEDIATE 
			'create table WFApprovalTaskDataTable(
				ProcessInstanceId NVarchar2(63) NOT NULL,
				ProcessDefId INT  NOT NULL, 
				WorkItemId INT NOT NULL, 
				ActivityId INT NOT NULL,
				TaskId Integer NOT NULL,
				Decision NVarchar2(100) , 
				Decision_By NVarchar2(255), 
				Decision_Date	DATE, 
				Comments NVarchar2(255),
				SubTaskId  INT
			)';
			/*dbms_output.put_line ('Table WFApprovalTaskDataTable Created successfully');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Table WFApprovalTaskDataTable Created successfully'')';
	END;
	
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_TABLES  
		WHERE TABLE_NAME = UPPER('WFMeetingTaskDataTable');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			EXECUTE IMMEDIATE 
			'create table WFMeetingTaskDataTable(
				ProcessInstanceId NVarchar2(63) NOT NULL,
				ProcessDefId INT  NOT NULL, 
				WorkItemId INT NOT NULL, 
				ActivityId INT NOT NULL,
				TaskId Integer NOT NULL,
				Venue NVarchar2(255), 
				ParticipantList NVarchar2(1000), 
				Purpose	NVarchar2(255),
				InitiatedBy NVarchar2(255),
				Comments NVarchar2(255),
				SubTaskId  INT
			)';
			/*dbms_output.put_line ('Table WFMeetingTaskDataTable Created successfully');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Table WFMeetingTaskDataTable Created successfully'')';
	END;
	
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_TABLES  
		WHERE TABLE_NAME = UPPER('WFTaskStatusTable');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			EXECUTE IMMEDIATE 
			'create table WFTaskStatusTable(
				ProcessInstanceId NVarchar2(63) NOT NULL,
				WorkItemId INT NOT NULL,
				ProcessDefId INT NOT NULL,
				ActivityId INT NOT NULL,
				TaskId  Integer NOT NULL,
				SubTaskId  Integer NOT NULL,
				TaskStatus integer NOT NULL,
				AssignedBy Nvarchar2(63) NOT NULL,
				AssignedTo Nvarchar2(63) ,
				Instructions NVARCHAR2(2000) NULL,
				ActionDateTime DATE NOT NULL,
				DueDate DATE,
				Priority  INT, /* 0 for Low , 1 for MEDIUM , 2 for High*/
				ShowCaseVisual	NVARCHAR2(1) DEFAULT ''N'' NOT NULL,
				ReadFlag NVARCHAR2(1) default ''N'' NOT NULL,
				CanInitiate	NVARCHAR2(1) default ''N'' NOT NULL,	
				Q_DivertedByUserId INT DEFAULT 0,
				CONSTRAINT PK_WFTaskStatusTable PRIMARY KEY(ProcessInstanceId,WorkItemId,ProcessDefID,ActivityId,TaskId,SubTaskId)
			)';
			/*dbms_output.put_line ('Table WFTaskStatusTable Created successfully');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Table WFTaskStatusTable Created successfully'')';
	END;
	
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_TABLES  
		WHERE TABLE_NAME = UPPER('WFCaseDataVariableTable');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			EXECUTE IMMEDIATE 
			'CREATE TABLE WFCaseDataVariableTable (
				ProcessDefId            INT             NOT NULL,
				ActivityID				INT				NOT NULL,
				VariableId		INT 		NOT NULL ,
				DisplayName			NVARCHAR2(2000)		NULL,
				CONSTRAINT PK_WFCaseDataVariableTable PRIMARY KEY(ProcessDefID,ActivityID,VariableId)
				)';
			/*dbms_output.put_line ('Table WFCaseDataVariableTable Created successfully');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Table WFCaseDataVariableTable Created successfully'')';
	END;
	
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_TABLES  
		WHERE TABLE_NAME = UPPER('WFMigrationLogTable');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			EXECUTE IMMEDIATE 
			'Create Table WFMigrationLogTable (
				executionLogId         INTEGER,
				actionDateTime 	 Timestamp,
				Remarks               Varchar2(4000),
				PRIMARY KEY ( executionLogId)
			)';
			/*dbms_output.put_line ('Table WFMigrationLogTable Created successfully');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Table WFMigrationLogTable Created successfully'')';
	END;
	
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_TABLES  
		WHERE TABLE_NAME = UPPER('WFMetaDataMigrationProgressLog');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			EXECUTE IMMEDIATE 
			'Create Table WFMetaDataMigrationProgressLog (
				executionLogId		INTEGER,
				actionDateTime		TimeStamp,
				ProcessDefId		INTEGER,
				TableName			Varchar2(1024),
				Status				Varchar2(4000)
				)';
			/*dbms_output.put_line ('Table WFMetaDataMigrationProgressLog Created successfully');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Table WFMetaDataMigrationProgressLog Created successfully'')';
	END;
	
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_TABLES  
		WHERE TABLE_NAME = UPPER('WFFailedMetaDataMigrationLog');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			EXECUTE IMMEDIATE 
			'Create Table WFFailedMetaDataMigrationLog (
				executionLogId		INTEGER,
				actionDateTime		TimeStamp,
				ProcessDefId		INTEGER,
				Status				Varchar2(4000)
				)';
			/*dbms_output.put_line ('Table WFFailedMetaDataMigrationLog Created successfully');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Table WFFailedMetaDataMigrationLog Created successfully'')';
	END;
	
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_TABLES  
		WHERE TABLE_NAME = UPPER('WFTxnDataMigrationProgressLog');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			EXECUTE IMMEDIATE 
			'Create Table WFTxnDataMigrationProgressLog(
				executionLogId  Integer,
				actionDateTime  TimeStamp,
				ProcessDefId Integer,
				BatchStartProcessInstanceId NVarchar2(256),
				BatchEndProcessInstanceId NVarchar2(256),
				Remarks               Varchar2(4000)
				)';
			/*dbms_output.put_line ('Table WFTxnDataMigrationProgressLog Created successfully');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Table WFTxnDataMigrationProgressLog Created successfully'')';
	END;
	
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_TABLES  
		WHERE TABLE_NAME = UPPER('WFPSConnection');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			EXECUTE IMMEDIATE 
			'CREATE TABLE WFPSConnection(
				PSId	int	Primary Key NOT NULL,
				SessionId	int	Unique NOT NULL,
				Locale	char(5),	
				PSLoginTime	DATE	
			)';
			/*dbms_output.put_line ('Table WFPSConnection Created successfully');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Table WFPSConnection Created successfully'')';
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
			/*dbms_output.put_line ('Table WFProfileTable Created successfully');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Table WFProfileTable Created successfully'')';
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
			EXECUTE IMMEDIATE 'CREATE SEQUENCE ObjectTypeIdSequence INCREMENT BY 1 START WITH 4 NOCACHE';
			/*dbms_output.put_line ('Table WFObjectListTable Created successfully');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Table WFObjectListTable Created successfully'')';
			EXECUTE IMMEDIATE 'INSERT INTO wfobjectlisttable values (1,''PRC'',''Process Management'',0,''com.newgen.wf.rightmgmt.WFRightGetProcessList'', ''0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000'', ''Y'')';
		    EXECUTE IMMEDIATE 'INSERT INTO wfobjectlisttable values (2,''QUE'',''Queue Management'',0,''com.newgen.wf.rightmgmt.WFRightGetQueueList'', ''0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000'', ''Y'')';
		    EXECUTE IMMEDIATE 'INSERT INTO wfobjectlisttable values (3,''OTMS'',''Transport Management'',0,'' '',''0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000'', ''N'')';
			/*dbms_output.put_line ('Insertion done in WFObjectListTable successfully');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Insertion done in WFObjectListTable successfully'')';
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
			/*dbms_output.put_line ('Table WFAssignableRightsTable Created successfully');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Table WFAssignableRightsTable Created successfully'')';
			EXECUTE IMMEDIATE  'INSERT INTO wfassignablerightstable VALUES (1,''V'',''View'', 1)';
			EXECUTE IMMEDIATE  'INSERT INTO wfassignablerightstable VALUES (1,''M'',''Modify'', 2)';
			EXECUTE IMMEDIATE  'INSERT INTO wfassignablerightstable VALUES (1,''U'',''UnRegister'', 3)';
			EXECUTE IMMEDIATE  'INSERT INTO wfassignablerightstable VALUES (1,''C'',''Check-In/CheckOut/UndoCheckOut'', 4)';
			EXECUTE IMMEDIATE  'INSERT INTO wfassignablerightstable VALUES (1,''CS'',''Change State'', 5)';
			EXECUTE IMMEDIATE  'INSERT INTO wfassignablerightstable values (1,''AT'',''Audit Trail'', 6) ';
			EXECUTE IMMEDIATE  'INSERT INTO wfassignablerightstable values (1,''PRPT'',''Process Report'', 7)';
			EXECUTE IMMEDIATE  'INSERT INTO wfassignablerightstable values (1,''IMPBO'',''Import Business objects'', 8)';
			EXECUTE IMMEDIATE  'INSERT INTO wfassignablerightstable VALUES (2,''V'',''View'', 1)';
			EXECUTE IMMEDIATE  'INSERT INTO wfassignablerightstable VALUES (2,''D'',''Delete'', 2)';
			EXECUTE IMMEDIATE  'INSERT INTO wfassignablerightstable VALUES (2,''MQP'',''Modify Queue Property'', 3)';
			EXECUTE IMMEDIATE  'INSERT INTO wfassignablerightstable VALUES (2,''MQU'',''Modify Queue User'', 4)';
			EXECUTE IMMEDIATE  'INSERT INTO wfassignablerightstable VALUES (2,''MQA'',''Modify Queue Activity'', 5)';	
			EXECUTE IMMEDIATE  'INSERT INTO wfassignablerightstable VALUES (3,''T'',''Transport Request Id'', 1)';	
			/*dbms_output.put_line ('Insertion done in WFAssignableRightsTable successfully');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Insertion done in WFAssignableRightsTable successfully'')';
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
			/*dbms_output.put_line ('Table WFProfileObjTypeTable Created successfully');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Table WFProfileObjTypeTable Created successfully'')';
			
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
			/*dbms_output.put_line ('Table WFUserObjAssocTable Created successfully');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Table WFUserObjAssocTable Created successfully'')';
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
			/*dbms_output.put_line ('Table WFFilterListTable Created successfully');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Table WFFilterListTable Created successfully'')';
			EXECUTE IMMEDIATE 'INSERT INTO wffilterlisttable VALUES (1,''Process Name'',''ProcessName'')';
		    EXECUTE IMMEDIATE 'INSERT INTO wffilterlisttable VALUES (2,''Queue Name'',''QueueName'')';
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
			/*dbms_output.put_line ('Table WFMsgAFTable Created successfully');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Table WFMsgAFTable Created successfully'')';
	END;
	
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_TABLES  
		WHERE TABLE_NAME = UPPER('WFTaskDefTable');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			EXECUTE IMMEDIATE 
			'create TABLE WFTaskDefTable(
				ProcessDefId integer NOT NULL,
				TaskId integer NOT NULL,
				TaskType integer NOT NULL,
				TaskName nvarchar2(100) NOT NULL,
				Description  NCLOB NULL,
				xLeft integer  NULL,
				yTop integer  NULL,
				IsRepeatable nvarchar2(1) DEFAULT ''Y'' NOT NULL,
				TurnAroundTime integer  NULL,
				CreatedOn date NOT NULL,
				CreatedBy nvarchar2(255) NOT NULL,
				Scope nvarchar2(1) NOT NULL,
				Goal nvarchar2(1000) NULL,
				Instructions nvarchar2(1000) NULL,
				TATCalFlag nvarchar2(1) DEFAULT ''N'' NOT NULL,
				Cost numeric(15,2) NULL,
				NotifyEmail nvarchar2(1) DEFAULT ''N'' NOT NULL,
				TaskTableFlag nvarchar2(1)  DEFAULT ''N'' NOT NULL,
				Primary Key( ProcessDefId,TaskId)
			 )';
			/*dbms_output.put_line ('Table WFTaskDefTable Created successfully');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Table WFTaskDefTable Created successfully'')';
	END;
	
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_TABLES  
		WHERE TABLE_NAME = UPPER( 'WFTaskInterfaceAssocTable');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			EXECUTE IMMEDIATE 
			'create table WFTaskInterfaceAssocTable (
				ProcessDefId INT  NOT NULL , 
				ActivityId INT NOT NULL ,
				TaskId Integer NOT NULL , 
				InterfaceId Integer NOT NULL, 
				InterfaceType NCHAR(1) NOT NULL,
				Attribute NVarchar2(2)
			)';
			/*dbms_output.put_line ('Table WFTaskInterfaceAssocTable Created successfully');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Table WFTaskInterfaceAssocTable Created successfully'')';
	END;
	
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_TABLES  
		WHERE TABLE_NAME = UPPER( 'WFTaskTemplateDefTable');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			EXECUTE IMMEDIATE 
			'create table WFTaskTemplateDefTable (
				ProcessDefId INT NOT NULL ,
				TaskId Integer  NOT NULL, 
				TemplateName NVarchar2(255) NOT NULL
			)';
			/*dbms_output.put_line ('Table WFTaskTemplateDefTable Created successfully');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Table WFTaskTemplateDefTable Created successfully'')';
	END;
	
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_TABLES  
		WHERE TABLE_NAME = UPPER( 'WFTaskTemplateFieldDefTable');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			EXECUTE IMMEDIATE 
			'create table WFTaskTemplateFieldDefTable (
				ProcessDefId INT NOT NULL,
				TaskId Integer NOT NULL, 
				TemplateVariableId Integer  NOT NULL,
				TaskVariableName NVarchar2(255) NOT NULL, 
				DisplayName NVarchar2(255), 
				VariableType 	Integer NOT NULL ,
				OrderId Integer NOT NULL,
				ControlType Integer NOT NULL /*1 for textbox, 2 for text area, 3 for combo*/,
				DBLinking NVARCHAR2(1) default ''N'' NOT NULL
			)';
			/*dbms_output.put_line ('Table WFTaskTemplateFieldDefTable Created successfully');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Table WFTaskTemplateFieldDefTable Created successfully'')';
	END;
	
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_TABLES  
		WHERE TABLE_NAME = UPPER( 'WFTaskTempControlValues');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			EXECUTE IMMEDIATE 
			'CREATE TABLE WFTaskTempControlValues(
				ProcessDefId Integer NOT NULL,
				TaskId Integer NOT NULL,
				TemplateVariableId Integer NOT NULL,
				ControlValue NVarchar2(255) NOT NULL    
			)';
			/*dbms_output.put_line ('Table WFTaskTempControlValues Created successfully');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Table WFTaskTempControlValues Created successfully'')';
	END;
	
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_TABLES  
		WHERE TABLE_NAME = UPPER( 'WFTaskVariableMappingTable');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			EXECUTE IMMEDIATE 
			'create table WFTaskVariableMappingTable(
				ProcessDefId INT NOT NULL, 
				ActivityId INT NOT NULL, 
				TaskId Integer NOT NULL,
				TemplateVariableId Integer NOT NULL, 
				TaskVariableName NVarchar2(255) NOT NULL, 
				VariableId Integer NOT NULL, 
				TypeFieldId Integer NOT NULL, 
				ReadOnly nvarchar2(1) NULL,
				VariableName nvarchar2(255) NULL,
				primary key(ProcessDefId,ActivityId,TaskId,TemplateVariableId)
			)';
			/*dbms_output.put_line ('Table WFTaskVariableMappingTable Created successfully');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Table WFTaskVariableMappingTable Created successfully'')';
	END;
	
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_TABLES  
		WHERE TABLE_NAME = UPPER( 'WFTaskRulePreConditionTable');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			EXECUTE IMMEDIATE 
			'create table WFTaskRulePreConditionTable(
				ProcessDefId INT NOT NULL,
				ActivityId INT NOT NULL,
				TaskId Integer NOT NULL,
				RuleType NCHAR(1) NOT NULL,
				RuleOrderId Integer NOT NULL,
				RuleId Integer NOT NULL,
				ConditionOrderId Integer NOT NULL,
				Param1 NVarchar2(50) NOT NULL,
				Type1 NVarchar2(1) not null,
				ExtObjId1 Integer,
				VariableId_1 Integer NOT NULL,
				VarFieldId_1 Integer,
				Param2 NVarchar2(255) ,
				Type2 NVarchar2(1) ,
				ExtObjId2 integer ,
				VariableId_2 integer ,
				VarFieldId_2 integer,
				Operator integer  ,
				Logicalop integer NOT NULL 
			)';
			/*dbms_output.put_line ('Table WFTaskRulePreConditionTable Created successfully');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Table WFTaskRulePreConditionTable Created successfully'')';
	END;
	
	BEGIN 
		SELECT 1 INTO v_existsFlag 
		FROM USER_TABLES  
		WHERE UPPER(TABLE_NAME) = UPPER('WFTaskFormTable');  
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			EXECUTE IMMEDIATE
				'CREATE TABLE WFTaskFormTable (
				 ProcessDefId            INT             NOT NULL,
				 TaskId                  INT             NOT NULL,
				 FormBuffer              NCLOB			NULL,
				 DeviceType				NVARCHAR2(1)  DEFAULT ''D'',
				 FormHeight			    INT DEFAULT(100) NOT NULL,
				 FormWidth			    INT DEFAULT(100) NOT NULL,
				 StatusFlag 			    NVARCHAR2(1)  NULL,
				 CONSTRAINT PK_WFTaskFormTable PRIMARY KEY(ProcessDefID,TaskId)
				) ';
			/*dbms_output.put_line ('Table WFTaskFormTable Created successfully');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Table WFTaskFormTable Created successfully'')';
	END;
	
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_TABLES  
		WHERE TABLE_NAME = UPPER( 'TaskTemplateLibraryDefTable');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			EXECUTE IMMEDIATE 
			'create TABLE TaskTemplateLibraryDefTable(
				TemplateId integer NOT NULL,
				TemplateName nvarchar2(255) Not NULL,
				Description nClob NULL,	
				IsRepeatable nvarchar2(1) DEFAULT ''Y'' NOT NULL ,	
				Goal nvarchar2(1000) NULL,
				Instructions nvarchar2(1000) NULL,
				TATCalFlag nvarchar2(1) NOT NULL,
				Cost  numeric(15,2) NULL,  
				NotifyEmail nvarchar2(1) DEFAULT ''N'' NOT NULL ,
				TATDays integer NOT NULL,
				TATHours integer NOT NULL,
				TATMinutes integer NOT NULL	
			)';
			/*dbms_output.put_line ('Table TaskTemplateLibraryDefTable Created successfully');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Table TaskTemplateLibraryDefTable Created successfully'')';
	END;
	
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_TABLES  
		WHERE TABLE_NAME = UPPER( 'TaskTempFieldLibraryDefTable');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			EXECUTE IMMEDIATE 
			'create TABLE TaskTempFieldLibraryDefTable(	
				TemplateId integer NOT NULL,
				TemplateVariableId integer NOT NULL,
				TaskVariableName nvarchar2(255) Not NULL,
				DisplayName nvarchar2(255) NULL,
				VariableType integer NOT NULL,
				OrderId integer NOT NULL,
				ControlType	integer NOT NULL,
			  DBLinking NVARCHAR2(1) default ''N'' NOT NULL
			)';
			/*dbms_output.put_line ('Table TaskTempFieldLibraryDefTable Created successfully');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Table TaskTempFieldLibraryDefTable Created successfully'')';
	END;
	
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
	/*DBMS_OUTPUT.PUT_LINE('Table WFProcessVariantDefTable Created successfully');*/
	EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Table WFProcessVariantDefTable Created successfully'')';
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
	
	/*DBMS_OUTPUT.PUT_LINE('Table WFVariantFieldInfoTable Created successfully');*/
	EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Table WFVariantFieldInfoTable Created successfully'')';
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
	
	/*DBMS_OUTPUT.PUT_LINE('Table WFVariantFieldAssociationTable Created successfully');*/
	EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Table WFVariantFieldAssociationTable Created successfully'')';
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
	
	/*DBMS_OUTPUT.PUT_LINE('Table WFVariantFormListenerTable Created successfully');*/
	EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Table WFVariantFormListenerTable Created successfully'')';
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
	
	/*DBMS_OUTPUT.PUT_LINE('Table WFVariantFormTable Created successfully');*/
	EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Table WFVariantFormTable Created successfully'')';
	END;
	
	/*added by RishiRam -- start here*/
	BEGIN 
		SELECT 1 INTO v_existsFlag 
		FROM USER_TABLES  
		WHERE UPPER(TABLE_NAME) = UPPER('WFObjectPropertiesTable');  
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			EXECUTE IMMEDIATE
				'Create Table WFObjectPropertiesTable (
				 ObjectType NVarchar2(1),
				 ObjectId Integer, 
				 PropertyName NVarchar2(255),
				 PropertyValue NVarchar2(1000), 
				 Primary Key(ObjectType,ObjectId,PropertyName)
				)';
			/*dbms_output.put_line ('Table WFObjectPropertiesTable Created successfully');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Table WFObjectPropertiesTable Created successfully'')';
	END;
	
	BEGIN 
		SELECT 1 INTO v_existsFlag 
		FROM USER_TABLES  
		WHERE UPPER(TABLE_NAME) = UPPER('WFHoldEventsDefTable');  
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			EXECUTE IMMEDIATE
				'CREATE TABLE WFHoldEventsDefTable (
				 ProcessDefId		INT 		   NOT NULL,
				 ActivityId			INT 		   NOT NULL,
				 EventId				INT			   NOT NULL,
				 EventName			NVARCHAR2(255) NOT NULL,
				 TriggerName			NVARCHAR2(255) NULL,
				 TargetActId	INT			   NULL,
				 TargetActName	NVARCHAR2(255) NULL,
				 PRIMARY KEY ( ProcessDefId , ActivityId,EventId )
				)';
			/*dbms_output.put_line ('Table WFHoldEventsDefTable Created successfully');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Table WFHoldEventsDefTable Created successfully'')';
	END;
	
	BEGIN 
		SELECT 1 INTO v_existsFlag 
		FROM USER_TABLES  
		WHERE UPPER(TABLE_NAME) = UPPER('WF_OMSConnectInfoTable');  
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			EXECUTE IMMEDIATE
				'create TABLE WF_OMSConnectInfoTable(
				 ProcessDefId 	integer	 		NOT NULL,
				 ActivityId 		integer 		NOT NULL,
				 CabinetName     nvarchar2(255)  NULL,                
				 UserId          nvarchar2(50)   NULL,
				 Passwd          nvarchar2(256)  NULL,                
				 AppServerIP		nvarchar2(15)	NULL,
				 AppServerPort	nvarchar2(5)	NULL,
				 AppServerType	nvarchar2(255)	NULL,
				 SecurityFlag	nvarchar2(1)	NULL		
				)';
			/*dbms_output.put_line ('Table WF_OMSConnectInfoTable Created successfully');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Table WF_OMSConnectInfoTable Created successfully'')';
	END;
	
	BEGIN 
		SELECT 1 INTO v_existsFlag 
		FROM USER_TABLES  
		WHERE UPPER(TABLE_NAME) = UPPER('WF_OMSTemplateInfoTable');  
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			EXECUTE IMMEDIATE
				'create TABLE WF_OMSTemplateInfoTable(
				 ProcessDefId 	integer	 		NOT NULL,
				 ActivityId 		integer 		NOT NULL,
				 ProductName 	nvarchar2(255)  NOT NULL,
				 VersionNo 		nvarchar2(3) 	NOT NULL,
				 CommGroupName 	nvarchar2(255)  NULL,
				 CategoryName 	nvarchar2(255)  NULL,
				 ReportName 		nvarchar2(255)  NULL,
				 Description 	nvarchar2(255)  NULL,	
				 InvocationType  nvarchar2(1) 	NULL,
				 TimeOutInterval integer 		NULL,
				 DocTypeName		nvarchar2(255) 	NULL,	
				 CONSTRAINT PK_WFOMSTemplateInfoTable PRIMARY KEY(ProcessDefID,ActivityId,ProductName,VersionNo)
				)';
			/*dbms_output.put_line ('Table WF_OMSTemplateInfoTable Created successfully');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Table WF_OMSTemplateInfoTable Created successfully'')';
	END;
	
	BEGIN 
		SELECT 1 INTO v_existsFlag 
		FROM USER_TABLES  
		WHERE UPPER(TABLE_NAME) = UPPER('WF_OMSTemplateMappingTable');  
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			EXECUTE IMMEDIATE
				'create TABLE WF_OMSTemplateMappingTable(
				 ProcessDefId 	integer	 		NOT NULL,
				 ActivityId 		integer 		NOT NULL,
				 ProductName 	nvarchar2(255)  NULL,
				 VersionNo 		nvarchar2(3) 	NULL,			
				 MapType 		nvarchar2(1) 	NULL,
				 TemplateVarName nvarchar2(255) 	NULL,
				 TemplateVarType integer 		NULL,
				 MappedName 	nvarchar2(255) 	NULL,
				 MaxOccurs 	nvarchar2(255) 	NULL,
				 MinOccurs 	nvarchar2(255) 	NULL,	
				 VarId  		integer 		NULL,	
				 VarFieldId 		integer		NULL,
				 VarScope	nvarchar2(255) 	NULL,
				 OrderId    integer   NULL
				)';
			/*dbms_output.put_line ('Table WF_OMSTemplateMappingTable Created successfully');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Table WF_OMSTemplateMappingTable Created successfully'')';
	END;
	
	BEGIN 
		SELECT 1 INTO v_existsFlag 
		FROM USER_TABLES  
		WHERE UPPER(TABLE_NAME) = UPPER('WFFailedTxnDataMigrationLog');  
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			EXECUTE IMMEDIATE
				'Create Table WFFailedTxnDataMigrationLog(
				 executionLogId        Integer,
				 actionDateTime        Timestamp,
				 ProcessDefId             Integer,
				 ProcessInstanceId     NVARCHAR2(256),
				 Remarks               Varchar2(4000)
				)';
			/*dbms_output.put_line ('Table WFFailedTxnDataMigrationLog Created successfully');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Table WFFailedTxnDataMigrationLog Created successfully'')';
	END;
	
	BEGIN 
		SELECT 1 INTO v_existsFlag 
		FROM USER_TABLES  
		WHERE UPPER(TABLE_NAME) = UPPER('GTempObjectRightsTable');  
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			EXECUTE IMMEDIATE
				'CREATE GLOBAL TEMPORARY TABLE GTempObjectRightsTable (
					AssociationType INT,
					ObjectId INT, 
					ObjectName NVARCHAR2(64),
					RightString NVARCHAR2(100)
				 )ON COMMIT PRESERVE ROWS';
			/*dbms_output.put_line ('Table GTempObjectRightsTable Created successfully');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Table GTempObjectRightsTable Created successfully'')';
	END;
	/*added by Rishiram -- end here*/
	
	/*BEGIN
		SELECT LAST_NUMBER INTO v_lastSeqValue
		FROM USER_SEQUENCES
		WHERE SEQUENCE_NAME = UPPER('ProcessDefId');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
		    EXECUTE IMMEDIATE 'SELECT  max(processdefid) INTO '||v_maxProcId ||' FROM USER_SEQUENCES';
			EXECUTE IMMEDIATE 'CREATE SEQUENCE ProcessDefId INCREMENT BY 1 START WITH '||v_maxProcId ||' NOCACHE';
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''SEQUENCE ProcessDefId Successfully Created'')';
	END;*/
	BEGIN
		SELECT LAST_NUMBER INTO v_lastSeqValue
		FROM USER_SEQUENCES
		WHERE SEQUENCE_NAME = UPPER('ProcessDefId');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			BEGIN
				SELECT COUNT(1) INTO existsFlag FROM processdeftable;
				IF(existsFlag > 0) THEN
				BEGIN
					SELECT  max(processdefid) INTO v_maxProcId  FROM processdeftable;
					EXECUTE IMMEDIATE 'CREATE SEQUENCE ProcessDefId INCREMENT BY 1 START WITH '||v_maxProcId ||' NOCACHE';
					EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''SEQUENCE ProcessDefId Successfully Created'')';
				END;
				ELSE
				BEGIN
					--SELECT  max(processdefid) INTO v_maxProcId  FROM processdeftable;
					EXECUTE IMMEDIATE 'CREATE SEQUENCE ProcessDefId INCREMENT BY 1 START WITH 1 NOCACHE';
					EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''SEQUENCE ProcessDefId Successfully Created'')';
				END;
				END IF;
			END;	
	END;
	
	BEGIN
		SELECT LAST_NUMBER INTO v_lastSeqValue
		FROM USER_SEQUENCES
		WHERE SEQUENCE_NAME = UPPER('RevisionNoSequence');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'CREATE SEQUENCE RevisionNoSequence INCREMENT BY 1 START WITH 1 NOCACHE';
			/*dbms_output.put_line ('SEQUENCE RevisionNoSequence Successfully Created');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''SEQUENCE RevisionNoSequence Successfully Created'')';
	END;

	BEGIN
		SELECT LAST_NUMBER INTO v_lastSeqValue
		FROM USER_SEQUENCES
		WHERE SEQUENCE_NAME = UPPER('Export_Sequence');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'CREATE SEQUENCE Export_Sequence INCREMENT BY 1 START WITH 1';
			/*dbms_output.put_line ('SEQUENCE Export_Sequence Successfully Created');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''SEQUENCE Export_Sequence Successfully Created'')';

	END;
	BEGIN
		SELECT LAST_NUMBER INTO v_lastSeqValue
		FROM USER_SEQUENCES
		WHERE SEQUENCE_NAME = UPPER('LOGID');
		EXECUTE IMMEDIATE 'DROP SEQUENCE LOGID';
		EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''DROP SEQUENCE LOGID'')';
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''SEQUENCE LOGID NOT Exist'')';
	END;
	

/* ...................................... End Of New Sequence Addition ...........................................*/

/* ................................... Adding new Index.................................*/
	BEGIN 
		existsFlag := 0;
		BEGIN
		  	SELECT 1 INTO existsFlag
			FROM USER_OBJECTS 
			WHERE object_type in ('INDEX')
			AND OBJECT_NAME = UPPER('IDX4_WFCRouteLogTable');
		  EXCEPTION
			WHEN NO_DATA_FOUND THEN 
				EXECUTE IMMEDIATE 'CREATE INDEX IDX4_WFCRouteLogTable ON WFCurrentRouteLogTable (ProcessInstanceId, ActionDateTime, LogID)';
		        /*dbms_output.put_line ('Index on ProcessInstanceId, ActionDateTime, LogID of WFCurrentRouteLogTable created successfully');*/
				EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Index on ProcessInstanceId, ActionDateTime, LogID of WFCurrentRouteLogTable created successfully'')';
		END;
	END;
	
	BEGIN 
		existsFlag := 0;
		BEGIN
		  	SELECT 1 INTO existsFlag
			FROM USER_OBJECTS 
			WHERE object_type in ('INDEX')
			AND OBJECT_NAME = UPPER('IDX2_SUMMARYTABLE');
		  EXCEPTION
			WHEN NO_DATA_FOUND THEN 
				EXECUTE IMMEDIATE 'CREATE INDEX  IDX2_SUMMARYTABLE ON SUMMARYTABLE (ProcessDefId, ActionId)';
		        /*dbms_output.put_line ('Index on ProcessDefId, ActionId of SUMMARYTABLE created successfully');*/
				EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Index on ProcessDefId, ActionId of SUMMARYTABLE created successfully'')';
		END;
	END;
	
	BEGIN
	  FOR ind IN 
		(SELECT index_name FROM user_indexes WHERE table_name = UPPER('QueueHistoryTable') AND index_name NOT IN 
		   (SELECT unique index_name FROM user_constraints WHERE 
			  table_name = UPPER('QueueHistoryTable') AND index_name IS NOT NULL))
	  LOOP
	      dbms_output.put_line ('kamal index dropped   '||ind.index_name); 
		  execute immediate 'DROP INDEX '||ind.index_name;
	  END LOOP;
	END;
	
	BEGIN 
		existsFlag := 0;
		BEGIN
		  	SELECT 1 INTO existsFlag
			FROM USER_OBJECTS 
			WHERE object_type in ('INDEX')
			AND OBJECT_NAME = UPPER('IDX2_QueueHistoryTable');
		  EXCEPTION
			WHEN NO_DATA_FOUND THEN 
				EXECUTE IMMEDIATE 'CREATE INDEX  IDX2_QueueHistoryTable ON QueueHistoryTable (ActivityName)';
	        	/*dbms_output.put_line ('Index on ActivityName of QueueHistoryTable created successfully');*/
				EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Index on ActivityName of QueueHistoryTable created successfully'')';
		END;
	END;

		
	BEGIN 
		existsFlag := 0;
		BEGIN
		  	SELECT 1 INTO existsFlag
			FROM USER_OBJECTS 
			WHERE object_type in ('INDEX')
			AND OBJECT_NAME = UPPER('IDX3_QueueHistoryTable');
		  EXCEPTION
			WHEN NO_DATA_FOUND THEN 
				EXECUTE IMMEDIATE 'CREATE INDEX  IDX3_QueueHistoryTable ON QueueHistoryTable (VAR_REC_1, VAR_REC_2)';
	        	/*dbms_output.put_line ('Index on VAR_REC_1, VAR_REC_2 of QueueHistoryTable created successfully');*/
				EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Index on VAR_REC_1, VAR_REC_2 of QueueHistoryTable created successfully'')';
		END;
	END;
	
	BEGIN 
		existsFlag := 0;
		BEGIN
		  	SELECT 1 INTO existsFlag
			FROM USER_OBJECTS 
			WHERE object_type in ('INDEX')
			AND OBJECT_NAME = UPPER('IDX4_QueueHistoryTable');
		  EXCEPTION
			WHEN NO_DATA_FOUND THEN 
				EXECUTE IMMEDIATE 'CREATE INDEX  IDX4_QueueHistoryTable ON QueueHistoryTable (Q_QueueId)';
		        /*dbms_output.put_line ('Index on Q_QueueId of QueueHistoryTable created successfully');*/
				EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Index on Q_QueueId of QueueHistoryTable created successfully'')';
		END;
	END;

	BEGIN 
		existsFlag := 0;
		BEGIN
		  	SELECT 1 INTO existsFlag
			FROM USER_OBJECTS 
			WHERE object_type in ('INDEX')
			AND OBJECT_NAME = UPPER('IDX3_ExceptionTable');
		  EXCEPTION
			WHEN NO_DATA_FOUND THEN 
				EXECUTE IMMEDIATE 'CREATE INDEX IDX3_ExceptionTable ON ExceptionTable (ProcessDefId, ActivityId)';
				/*dbms_output.put_line ('Index on ProcessDefId, ActivityId of ExceptionTable created successfully');*/
				EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Index on ProcessDefId, ActivityId of ExceptionTable created successfully'')';
		END;
	END;
	/*added by rishi --- start here*/

	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_INDEXES
		WHERE INDEX_NAME = UPPER('IDX1_WFObjectPropertiesTable');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN 
			EXECUTE IMMEDIATE 
				'CREATE INDEX IDX1_WFObjectPropertiesTable on  WFObjectPropertiesTable(ObjectType,PropertyName)';
			/*DBMS_OUTPUT.PUT_LINE ('iNDEX IDX1_WFObjectPropertiesTable created ON WFObjectPropertiesTable');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''iNDEX IDX1_WFObjectPropertiesTable created ON WFObjectPropertiesTable'')';
	END;
	BEGIN
		SELECT 1 INTO v_existsFlag 
		FROM USER_INDEXES
		WHERE INDEX_NAME = UPPER('IDXMIGRATION_WFINSTRUMENTTABLE');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN 
			EXECUTE IMMEDIATE 
				'CREATE INDEX IDXMIGRATION_WFINSTRUMENTTABLE ON WFINSTRUMENTTABLE(PROCESSINSTANCESTATE, CREATEDDATETIME, PROCESSINSTANCEID, WORKITEMID, PROCESSDEFID)';
			/*DBMS_OUTPUT.PUT_LINE ('iNDEX IDXMIGRATION_WFINSTRUMENTTABLE created ON WFINSTRUMENTTABLE');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''iNDEX IDXMIGRATION_WFINSTRUMENTTABLE created ON WFINSTRUMENTTABLE'')';
	END;
	BEGIN
		SELECT 1 INTO v_existsFlag 
		FROM USER_INDEXES
		WHERE INDEX_NAME = UPPER('IDX4_ExceptionTable');		

		EXECUTE IMMEDIATE 'DROP INDEX IDX4_ExceptionTable'; 
		/*dbms_output.put_line ('Dropped INDEX IDX4_ExceptionTable....');*/
		EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Dropped INDEX IDX4_ExceptionTable....'')';
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN
				/*dbms_output.put_line ('INDEX IDX4_ExceptionTable doesnot exist...');*/
				EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''INDEX IDX4_ExceptionTable doesnot exist...'')';
	END;
	
	BEGIN
		SELECT 1 INTO v_existsFlag 
		FROM USER_INDEXES
		WHERE INDEX_NAME = UPPER('IDX1_WFATTRIBMSGHIS');		

		EXECUTE IMMEDIATE 'DROP INDEX IDX1_WFATTRIBMSGHIS'; 
		/*dbms_output.put_line ('Dropped INDEX IDX1_WFATTRIBMSGHIS....');*/
		EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Dropped INDEX IDX1_WFATTRIBMSGHIS....'')';
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN
				/*dbms_output.put_line ('INDEX IDX1_WFATTRIBMSGHIS doesnot exist...');*/
				EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''INDEX IDX1_WFATTRIBMSGHIS doesnot exist...'')';
	END;
	BEGIN
		SELECT 1 INTO v_existsFlag 
		FROM USER_INDEXES
		WHERE INDEX_NAME = UPPER('IDX1_WFCommentsHistoryTable');		

		EXECUTE IMMEDIATE 'DROP INDEX IDX1_WFCommentsHistoryTable'; 
		/*dbms_output.put_line ('Dropped INDEX IDX1_WFCommentsHistoryTable....');*/
		EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Dropped INDEX IDX1_WFCommentsHistoryTable....'')';
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN
				/*dbms_output.put_line ('INDEX IDX1_WFCommentsHistoryTable doesnot exist...');*/
				EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''INDEX IDX1_WFCommentsHistoryTable doesnot exist...'')';
	END;
	
	BEGIN
		SELECT 1 INTO v_existsFlag 
		FROM USER_INDEXES
		WHERE INDEX_NAME = UPPER('IDX3_ExceptionHistoryTable');		

		EXECUTE IMMEDIATE 'DROP INDEX IDX3_ExceptionHistoryTable'; 
		/*dbms_output.put_line ('Dropped INDEX IDX3_ExceptionHistoryTable....');*/
		EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Dropped INDEX IDX3_ExceptionHistoryTable....'')';
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN
				/*dbms_output.put_line ('');*/
				EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''INDEX IDX3_ExceptionHistoryTable doesnot exist...'')';
	END;
	
	BEGIN
		SELECT 1 INTO v_existsFlag 
		FROM USER_INDEXES
		WHERE INDEX_NAME = UPPER('IDX2_WFMessageTable');		

		EXECUTE IMMEDIATE 'DROP INDEX IDX2_WFMessageTable'; 
		/*dbms_output.put_line ('Dropped INDEX IDX2_WFMessageTable....');*/
		EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Dropped INDEX IDX2_WFMessageTable....'')';
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN
				/*dbms_output.put_line ('INDEX IDX2_WFMessageTable doesnot exist...');*/
				EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''INDEX IDX2_WFMessageTable doesnot exist...'')';
	END;
	
    /*added by rishi --- end here*/
	/* ................................... Adding new Index ends here.................................*/
	
	existsflag :=0;
	BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME = UPPER('WFFORM_TABLE') 
			AND COLUMN_NAME = UPPER('ISAPPLETVIEW');
			EXECUTE IMMEDIATE 'UPDATE WFFORM_TABLE SET DeviceType=''Y'' WHERE ISAPPLETVIEW=''Y''';
			EXECUTE IMMEDIATE 'UPDATE WFFORM_TABLE SET DeviceType=''D'' WHERE ISAPPLETVIEW=''N''';
			EXECUTE IMMEDIATE 'ALTER TABLE WFFORM_TABLE DROP COLUMN ISAPPLETVIEW ';
			/*DBMS_OUTPUT.PUT_LINE('Column ISAPPLETVIEW Dropped');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Column ISAPPLETVIEW Dropped'')';
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
			/*DBMS_OUTPUT.PUT_LINE('Column Does Not exist');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Column Does Not exist'')';
	END;
	
	BEGIN
		existsFlag := 0;
		  	SELECT 1 INTO existsFlag
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME = UPPER('GTEMPPROCESSTABLE')
			AND COLUMN_NAME = UPPER('TEMPCONTEXT');
			EXECUTE IMMEDIATE 'ALTER TABLE GTEMPPROCESSTABLE DROP COLUMN TEMPCONTEXT';
		
		  EXCEPTION
			WHEN NO_DATA_FOUND THEN 
				DBMS_OUTPUT.PUT_LINE('COLUMN TEMPCONTEXT DOES NOT EXISTS IN GTEMPPROCESSTABLE ');
			END;
	BEGIN
		existsFlag := 0;
		  	SELECT 1 INTO existsFlag
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME = UPPER('GTEMPPROCESSTABLE')
			AND COLUMN_NAME = UPPER('ProcessType');
		  EXCEPTION
			WHEN NO_DATA_FOUND THEN 
				EXECUTE IMMEDIATE 'ALTER TABLE GTempProcessTable ADD ProcessType NVarchar2(1)';
				/*DBMS_OUTPUT.PUT_LINE ('Table GTempProcessTable altered successfully');*/
				EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Table GTempProcessTable altered successfully'')';
	END;
	BEGIN
		existsFlag := 0;
		  	SELECT 1 INTO existsFlag
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME = UPPER('WFFORM_TABLE')
			AND COLUMN_NAME = UPPER('ExistingFormId');
		  EXCEPTION
			WHEN NO_DATA_FOUND THEN 
				EXECUTE IMMEDIATE 'ALTER TABLE WFFORM_TABLE ADD ExistingFormId INT NULL';
				/*DBMS_OUTPUT.PUT_LINE ('Table WFFORM_TABLE altered successfully');*/
				EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Table WFFORM_TABLE altered successfully'')';
	END;
	
	v_nullable :='N';
	BEGIN
			SELECT nullable INTO v_nullable 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME = UPPER('mailtriggertable') 
			AND COLUMN_NAME = UPPER('ExtObjIdMailPriority');
		 EXCEPTION 
		    WHEN NO_DATA_FOUND THEN
			/*DBMS_OUTPUT.PUT_LINE('Some Error Occured in Select Query of ExtObjIdMailPriority');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Some Error Occured in Select Query of ExtObjIdMailPriority'')';
	END;
	IF v_nullable = 'N' THEN
	BEGIN
		EXECUTE IMMEDIATE 'ALTER TABLE MAILTRIGGERTABLE MODIFY (EXTOBJIDMAILPRIORITY DEAFULT 0)'; 
				EXECUTE IMMEDIATE 'ALTER TABLE MAILTRIGGERTABLE  MODIFY EXTOBJIDMAILPRIORITY INT NOT NULL'; 
				/*dbms_output.put_line ('ALTER TABLE MAILTRIGGERTABLE  MODIFY EXTOBJIDMAILPRIORITY INT NOT NULL');*/
				EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE MAILTRIGGERTABLE  MODIFY EXTOBJIDMAILPRIORITY INT NOT NULL'')';
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
	
	v_nullable :='N';
	BEGIN
			SELECT nullable INTO v_nullable 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME = UPPER('mailtriggertable') 
			AND COLUMN_NAME = UPPER('VariableIdMailPriority');
		 EXCEPTION
		    WHEN NO_DATA_FOUND THEN
			/*DBMS_OUTPUT.PUT_LINE('Some Error Occured in Select Query of VariableIdMailPriority');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Some Error Occured in Select Query of VariableIdMailPriority'')';
	END;
	IF v_nullable = 'N' THEN
	BEGIN
		        EXECUTE IMMEDIATE 'ALTER TABLE MAILTRIGGERTABLE MODIFY (VARIABLEIDMAILPRIORIITY DEAFULT 0)'; 
				EXECUTE IMMEDIATE 'ALTER TABLE MAILTRIGGERTABLE  MODIFY VARIABLEIDMAILPRIORIITY INT NOT NULL'; 
				/*dbms_output.put_line ('ALTER TABLE MAILTRIGGERTABLE  MODIFY VARIABLEIDMAILPRIORIITY INT NOT NULL');*/
				EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE MAILTRIGGERTABLE  MODIFY VARIABLEIDMAILPRIORIITY INT NOT NULL'')';
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

	v_nullable :='N';
	BEGIN
			SELECT nullable INTO v_nullable 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME = UPPER('mailtriggertable') 
			AND COLUMN_NAME = UPPER('VarFieldIdMailPriority');
		 EXCEPTION
		    WHEN NO_DATA_FOUND THEN
			/*DBMS_OUTPUT.PUT_LINE('Some Error Occured in Select Query of VarFieldIdMailPriority');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Some Error Occured in Select Query of VarFieldIdMailPriority'')';
	END;
	
	IF v_nullable = 'N' THEN
	BEGIN
		        EXECUTE IMMEDIATE 'ALTER TABLE MAILTRIGGERTABLE MODIFY (VARFIELIDMAILPRIORITY DEAFULT 0)'; 
				EXECUTE IMMEDIATE 'ALTER TABLE MAILTRIGGERTABLE  MODIFY VARFIELIDMAILPRIORITY INT NOT NULL'; 
				/*dbms_output.put_line ('ALTER TABLE MAILTRIGGERTABLE  MODIFY VARFIELIDMAILPRIORITY INT NOT NULL');*/
				EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE MAILTRIGGERTABLE  MODIFY VARFIELIDMAILPRIORITY INT NOT NULL'')';
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
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME = UPPER('PROCESSDEFTABLE') 
		AND 
		COLUMN_NAME = UPPER('CONTEXT');
		EXECUTE IMMEDIATE 'ALTER TABLE PROCESSDEFTABLE DROP COLUMN CONTEXT';
		EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE MAILTRIGGERTABLE  MODIFY VARFIELIDMAILPRIORITY INT NOT NULL'')';
		
		EXCEPTION
		WHEN NO_DATA_FOUND THEN
			DBMS_OUTPUT.PUT_LINE('COLUMN CONTEXT NOT EXIST');
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE MAILTRIGGERTABLE  MODIFY VARFIELIDMAILPRIORITY INT NOT NULL'')';
	END;

	
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME = UPPER('PROCESSDEFTABLE') 
		AND 
		COLUMN_NAME = UPPER('Description');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE PROCESSDEFTABLE Add (Description  NCLOB NULL)';			
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE PROCESSDEFTABLE Add (Description  NCLOB NULL)'')';
			EXECUTE IMMEDIATE 'Update PROCESSDEFTABLE SET Description = '' '' ';
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Update PROCESSDEFTABLE SET Description '')';

	END;
	
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME = UPPER('PROCESSDEFTABLE') 
		AND 
		COLUMN_NAME = UPPER('CreatedBy');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
	
			EXECUTE IMMEDIATE 'ALTER TABLE PROCESSDEFTABLE Add (CreatedBy NVARCHAR2(255) NULL)';	
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE PROCESSDEFTABLE Add (CreatedBy NVARCHAR2(255) NULL)'')';
			EXECUTE IMMEDIATE 'Update PROCESSDEFTABLE SET CreatedBy =N''Supervisor'' ';
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Update PROCESSDEFTABLE SET CreatedBy '')';
	END;
	
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME = UPPER('PROCESSDEFTABLE') 
		AND 
		COLUMN_NAME = UPPER('LastModifiedBy');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
	
			EXECUTE IMMEDIATE 'ALTER TABLE PROCESSDEFTABLE Add (LastModifiedBy NVARCHAR2(255) NULL)';
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE PROCESSDEFTABLE Add (LastModifiedBy NVARCHAR2(255) NULL)'')';
			EXECUTE IMMEDIATE 'Update PROCESSDEFTABLE SET LastModifiedBy = N''Supervisor'' ';
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Update PROCESSDEFTABLE SET LastModifiedBy '')';
	END;
	
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME = UPPER('PROCESSDEFTABLE') 
		AND 
		COLUMN_NAME = UPPER('ProcessShared');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
	
			EXECUTE IMMEDIATE 'ALTER TABLE PROCESSDEFTABLE Add (ProcessShared NCHAR(1) NULL)';
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE PROCESSDEFTABLE Add (ProcessShared NCHAR(1) NULL)'')';
			EXECUTE IMMEDIATE 'Update PROCESSDEFTABLE SET ProcessShared =N''N''';
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Update PROCESSDEFTABLE SET ProcessShared '')';
	END;
	
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME = UPPER('PROCESSDEFTABLE') 
		AND 
		COLUMN_NAME = UPPER('ProjectId');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
	
			EXECUTE IMMEDIATE 'ALTER TABLE PROCESSDEFTABLE Add (ProjectId INT NULL)';
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE PROCESSDEFTABLE Add (ProjectId INT NULL)'')';
			EXECUTE IMMEDIATE 'Update PROCESSDEFTABLE SET ProjectId= 1 ';
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Update PROCESSDEFTABLE SET ProjectId '')';
	END;
	
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME = UPPER('PROCESSDEFTABLE') 
		AND 
		COLUMN_NAME = UPPER('Cost');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
	
			EXECUTE IMMEDIATE 'ALTER TABLE PROCESSDEFTABLE Add (Cost NUMERIC(15, 2) NULL)';
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE PROCESSDEFTABLE Add (Cost NUMERIC(15, 2) NULL)'')';
			EXECUTE IMMEDIATE 'Update PROCESSDEFTABLE SET Cost = 0.00';
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Update PROCESSDEFTABLE SET Cost '')';
	END;
	
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME = UPPER('PROCESSDEFTABLE') 
		AND 
		COLUMN_NAME = UPPER('Duration');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
	
			EXECUTE IMMEDIATE 'ALTER TABLE PROCESSDEFTABLE Add (Duration NVARCHAR2(255) NULL)';
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE PROCESSDEFTABLE Add (Duration NVARCHAR2(255) NULL)'')';
			EXECUTE IMMEDIATE 'Update PROCESSDEFTABLE SET Duration ='''' ';
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Update PROCESSDEFTABLE SET Duration '')';
	END;
	
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME = UPPER('PROCESSDEFTABLE') 
		AND 
		COLUMN_NAME = UPPER('FormViewerApp');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
	
			EXECUTE IMMEDIATE 'ALTER TABLE PROCESSDEFTABLE Add (FormViewerApp NCHAR(1) Default N''J'' NOT NULL)';
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE PROCESSDEFTABLE Add (FormViewerApp NCHAR(1) Default J NOT NULL)'')';
			EXECUTE IMMEDIATE 'Update PROCESSDEFTABLE SET FormViewerApp = N''J'' ';
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Update PROCESSDEFTABLE SET FormViewerApp '')';
	END;
	
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME = UPPER('PROCESSDEFTABLE') 
		AND 
		COLUMN_NAME = UPPER('ProcessType');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
	
			EXECUTE IMMEDIATE 'ALTER Table ProcessDefTable add ProcessType NVarchar2(1) Default(''S'') NOT NULL';
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER Table ProcessDefTable add ProcessType NVarchar2(1) Default(S) NOT NULL'')';
			
	END;
	
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME = UPPER('WFSystemServicesTable') 
		AND 
		COLUMN_NAME = UPPER('AppServerId');
		EXECUTE IMMEDIATE 'ALTER TABLE WFSystemServicesTable DROP COLUMN AppServerId';
		EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFSystemServicesTable DROP COLUMN AppServerId'')';
		
		EXCEPTION
		WHEN NO_DATA_FOUND THEN
			DBMS_OUTPUT.PUT_LINE('COLUMN AppServerId DOES NOT EXIST IN WFSystemServicesTable');
	END;	
	
	BEGIN
		existsFlag := 0;
		SELECT 1 INTO existsFlag FROM USER_TAB_COLUMNS WHERE TABLE_NAME = UPPER('ProcessDefTable') AND COLUMN_NAME = UPPER('ThresholdRoutingCount');
	EXCEPTION
	WHEN NO_DATA_FOUND THEN
	BEGIN
		EXECUTE IMMEDIATE 'ALTER TABLE ProcessDefTable ADD ThresholdRoutingCount INT';
			
		DECLARE CURSOR processCursor IS SELECT ProcessDefId FROM PROCESSDEFTABLE;
		BEGIN		
		OPEN processCursor;
		LOOP
			FETCH processCursor INTO v_ProcessDefId;
			EXIT WHEN processCursor%NOTFOUND;
				BEGIN 
				SELECT Count(1) INTO v_rowCount FROM ACTIVITYTABLE WHERE processdefid=v_ProcessDefId;
					IF(v_rowCount > 0) THEN
						EXECUTE IMMEDIATE 'UPDATE ProcessDefTable SET ThresholdRoutingCount = ' || (v_rowCount * 2) ||' WHERE processdefid= ' || v_ProcessDefId;
					ELSE
						/*DBMS_OUTPUT.PUT_LINE('No record present in ACTIVITYTABLE for processdefId' || v_ProcessDefId);*/
						/*Comments := 'No record present in ACTIVITYTABLE for processdefId' || v_ProcessDefId;*/
						EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''No record present in ACTIVITYTABLE'')';
					END IF;
			  EXCEPTION WHEN OTHERS THEN
				  /*DBMS_OUTPUT.PUT_LINE('inside exception when updating ThresholdRoutingCount column of processdeftable ');*/
				  EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''inside exception when updating ThresholdRoutingCount column of processdeftable '')';
				END;
			COMMIT;
		END LOOP;
		CLOSE processCursor;

		/*DBMS_OUTPUT.PUT_LINE('Table ProcessDefTable altered with new Column ThresholdRoutingCount');*/
	    EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Table ProcessDefTable altered with new Column ThresholdRoutingCount '')';
	 END;
	END;
	END;
	
	

	/* Updating UserDefinedName to RoutingCount for Var_Rec_5 */
	BEGIN
		existsFlag := 0;
		BEGIN
			SELECT 1 INTO existsFlag FROM VARMAPPINGTABLE WHERE UPPER(USERDEFINEDNAME) = 'VAR_REC_5' AND ROWNUM <= 1;
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
			BEGIN
				existsFlag := 0;
			END;
		END;
		IF existsFlag = 1 THEN
		BEGIN
			SAVEPOINT ROUTINGTRAN;
			EXECUTE IMMEDIATE 'UPDATE VARMAPPINGTABLE SET USERDEFINEDNAME = ''RoutingCount'' WHERE UPPER(USERDEFINEDNAME) = ''VAR_REC_5''';
			EXECUTE IMMEDIATE 'ALTER TABLE WFInstrumentTable MODIFY VAR_REC_5 DEFAULT ''0''';
			EXECUTE IMMEDIATE 'UPDATE WFInstrumentTable SET VAR_REC_5 = ''0'' WHERE VAR_REC_5 is NULL OR LENGTH(VAR_REC_5) <= 0';			
			/*DBMS_OUTPUT.PUT_LINE('RoutingCount variable mapped with Var_Rec_5 successfully.');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''RoutingCount variable mapped with Var_Rec_5 successfully. '')';
			COMMIT;
		EXCEPTION
			WHEN OTHERS THEN
			BEGIN
				ROLLBACK TO SAVEPOINT ROUTINGTRAN;
				/*DBMS_OUTPUT.PUT_LINE('Some error occured in mapping RoutingCount variable with Var_Rec_5.');*/
				EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Some error occured in mapping RoutingCount variable with Var_Rec_5. '')';
			END;			
		END;
		END IF;
	END;
	
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME = UPPER('ACTIVITYTABLE') 
		AND 
		COLUMN_NAME = UPPER('Color');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE ACTIVITYTABLE Add (Color INT NULL)';
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE ACTIVITYTABLE Add (Color INT NULL)'')';
			EXECUTE IMMEDIATE 'UPDATE ACTIVITYTABLE SET Color = 1234 ';
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''UPDATE ACTIVITYTABLE SET Color = 1234 '')';
	END;
	
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME = UPPER('ACTIVITYTABLE') 
		AND 
		COLUMN_NAME = UPPER('Cost');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE ACTIVITYTABLE Add (Cost NUMERIC(15, 2) NULL)';
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE ACTIVITYTABLE Add (Cost NUMERIC(15, 2) NULL)'')';
			EXECUTE IMMEDIATE 'UPDATE ACTIVITYTABLE SET Cost = 0.00 ';
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''UPDATE ACTIVITYTABLE SET Cost = 0.00 '')';
	END;
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME = UPPER('ACTIVITYTABLE') 
		AND 
		COLUMN_NAME = UPPER('Duration');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			
			EXECUTE IMMEDIATE 'ALTER TABLE ACTIVITYTABLE Add (Duration NVARCHAR2(255) NULL)';
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE ACTIVITYTABLE Add (Duration NVARCHAR2(255) NULL)'')';
			EXECUTE IMMEDIATE 'UPDATE ACTIVITYTABLE SET Duration = ''0D0H0M'' ';
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''UPDATE ACTIVITYTABLE SET Duration'')';
	END;
	
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME = UPPER('ACTIVITYTABLE') 
		AND 
		COLUMN_NAME = UPPER('SwimLaneId');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			
			EXECUTE IMMEDIATE 'ALTER TABLE ACTIVITYTABLE Add (SwimLaneId INT NULL)';
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE ACTIVITYTABLE Add (SwimLaneId INT NULL)'')';
			EXECUTE IMMEDIATE 'UPDATE ACTIVITYTABLE SET SwimLaneId = 1';
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''UPDATE ACTIVITYTABLE SET SwimLaneId = 1'')';
	END;
	
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME = UPPER('ACTIVITYTABLE') 
		AND 
		COLUMN_NAME = UPPER('DummyStrColumn1');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			
			EXECUTE IMMEDIATE 'ALTER TABLE ACTIVITYTABLE Add (DummyStrColumn1 NVARCHAR2(255) NULL)';
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE ACTIVITYTABLE Add (DummyStrColumn1 NVARCHAR2(255) NULL)'')';
			EXECUTE IMMEDIATE 'UPDATE ACTIVITYTABLE SET DummyStrColumn1 ='''' ';
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''UPDATE ACTIVITYTABLE SET DummyStrColumn1'')';
	END;
	
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME = UPPER('ACTIVITYTABLE') 
		AND 
		COLUMN_NAME = UPPER('CustomValidation');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			
			EXECUTE IMMEDIATE 'ALTER TABLE ACTIVITYTABLE Add (CustomValidation NCLOB)';
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE ACTIVITYTABLE Add (CustomValidation NCLOB)'')';
			EXECUTE IMMEDIATE 'UPDATE ACTIVITYTABLE SET CustomValidation ='' ''  ';
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''UPDATE ACTIVITYTABLE SET CustomValidation'')';
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
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE ACTIVITYTABLE Add (ActivitySubType INT NULL)'')';
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
						v_activitysubtype := 1;
					ELSIF (v_ActivityType_actSub = 1 and v_AllowSoapRequest = 'Y')   Then
						v_activitysubtype := 2;
					ELSIF (v_ActivityType_actSub = 1 and v_AllowSoapRequest = 'N')    then
						v_activitysubtype := 1; 
					ELSIF (v_ActivityType_actSub = 2)  then 
 

						BEGIN
							EXECUTE IMMEDIATE 'Select Count(*) from InitiateWorkItemDefTable WHERE activityId = ' || TO_CHAR(v_ActivityId_actSub) || ' AND processDefId = ' || TO_CHAR(v_ProcessDefId) into existsFlag ;
							If existsFlag > 0 then
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
									If existsFlag > 0 then
                                    EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Case for when data exists PRINTFAXEMAILTABLE '')';									
									v_activitysubtype := 1; 
									ELSE
										EXECUTE IMMEDIATE 'Select Count(*) from ARCHIVETABLE WHERE activityid = ' || TO_CHAR(v_ActivityId_actSub) || ' AND processDefId = ' || TO_CHAR(v_ProcessDefId) into existsFlag;
										If existsFlag > 0 then
						                EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Case for when data exists ARCHIVETABLE'')';											
										v_activitysubtype := 4;  
										ELSE
											EXECUTE IMMEDIATE 'Select Count(*) from RULEOPERATIONTABLE WHERE activityid = ' || TO_CHAR(v_ActivityId_actSub) || ' AND processDefId = ' || TO_CHAR(v_ProcessDefId) || ' and operationtype = 24 ' into existsFlag ;
											Begin
												If existsFlag > 0 then
									            EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Case for when data exists RULEOPERATIONTABLE'')';													
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
                EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''update query for activityid'')';	
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
			/*DBMS_OUTPUT.PUT_LINE('New Column Added successfully in PROCESSDEFCOMMENTTABLE');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''New Column Added successfully in PROCESSDEFCOMMENTTABLE'')';	
			EXECUTE IMMEDIATE 'UPDATE PROCESSDEFCOMMENTTABLE Set SWIMLANEID = 1';
			/*updating annotation id--Starts here*/
			/*Begin 
    
			PreviousProcessDefId_comments := 0;
			v_STR1 := 'SELECT Processdefid,Comments  from PROCESSDEFCOMMENTTABLE order by ProcessDefId';
			OPEN cur_processComment For v_STR1;
				LOOP
					FETCH  cur_processComment INTO v_ProcessDefId, Comments ;
				
				EXIT WHEN cur_processComment%NOTFOUND;
					BEGIN
						counter_comments := 1;
						If (PreviousProcessDefId_comments = 0) then
						DBMS_OUTPUT.PUT_LINE('Case for previous processDefId is different from the Current ProcessDefId');
							counter_comments := 1;
						ELSIF (PreviousProcessDefId_comments != v_ProcessDefId)   Then
						DBMS_OUTPUT.PUT_LINE('Case for activitytype = '||v_ActivityType_actSub);
							counter_comments := counter_comments + 1;
							  
						END IF;    
						Begin
							v_STR2 := 'UPDATE PROCESSDEFCOMMENTTABLE SET ANNOTATIONID = ' || TO_CHAR(counter_comments) || ' Where ProcessDefId = ' || TO_CHAR(v_ProcessDefId) || ' and Comments = '|| TO_CHAR(Comments);
							DBMS_OUTPUT.PUT_LINE('UPDATE PROCESSDEFCOMMENTTABLE');
							PreviousProcessDefId_comments := v_ProcessDefId;
							Execute Immediate(v_STR2);
						End;
			END;
		  END LOOP;
			CLOSE cur_processComment;
		End;*/
			/*updating annotation id--Ends here*/
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
			/*DBMS_OUTPUT.PUT_LINE('New Column Added successfully in WORKSTAGELINKTABLE');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''New Column Added successfully in WORKSTAGELINKTABLE'')';	
			
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
	END;

    BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME = UPPER('EXTDBFIELDDEFINITIONTABLE') 
		AND 
		COLUMN_NAME = UPPER('ExtObjId');
	EXCEPTION
			WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE EXTDBFIELDDEFINITIONTABLE Add (ExtObjId INT NULL)';	
           /* DBMS_OUTPUT.PUT_LINE('New Column Added successfully in EXTDBFIELDDEFINITIONTABLE');*/	
            EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''New Column Added successfully in EXTDBFIELDDEFINITIONTABLE'')';			
			EXECUTE IMMEDIATE 'UPDATE EXTDBFIELDDEFINITIONTABLE SET ExtObjId = 0 where ExtObjId IS NULL';	
			/*DBMS_OUTPUT.PUT_LINE('Column ExtObjId updated successfully in EXTDBFIELDDEFINITIONTABLE');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Column ExtObjId updated successfully in EXTDBFIELDDEFINITIONTABLE'')';	
			EXECUTE IMMEDIATE 'ALTER TABLE EXTDBFIELDDEFINITIONTABLE MODIFY(ExtObjId INT NOT NULL)';		
			/*DBMS_OUTPUT.PUT_LINE('Primary Key Added successfully in EXTDBFIELDDEFINITIONTABLE');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Primary Key Added successfully in EXTDBFIELDDEFINITIONTABLE'')';	
	END;
	
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME = UPPER('ARCHIVETABLE') 
		AND 
		COLUMN_NAME = UPPER('DeleteAudit');
		EXECUTE IMMEDIATE 'ALTER TABLE ARCHIVETABLE  DROP COLUMN DeleteAudit';			
	    DBMS_OUTPUT.PUT_LINE('DeleteAudit Column dropped successfully in ARCHIVETABLE');
		EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''DeleteAudit Column dropped successfully in ARCHIVETABLE'')';	
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			DBMS_OUTPUT.PUT_LINE('DeleteAudit Column not exist in  ARCHIVETABLE');	
            EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''DeleteAudit Column not exist in  ARCHIVETABLE'')';	
	END;
	
	BEGIN
        SELECT 1 INTO existsFlag FROM USER_TAB_COLUMNS WHERE TABLE_NAME=UPPER('ACTIVITYTABLE') 
        AND COLUMN_NAME=UPPER('MobileEnabled');
        DECLARE CURSOR cursor_mobile IS SELECT processdefid,activityid,mobileEnabled FROM  ActivityTable;            
		 BEGIN                    
			OPEN cursor_mobile;
			LOOP
					FETCH cursor_mobile INTO v_ProcessDefId, v_ActivityId_actSub, v_mobileEnabled;
					EXIT WHEN cursor_mobile%NOTFOUND;  
                    IF v_mobileEnabled = '' or v_mobileEnabled is NULL THEN					
					BEGIN
						v_STR1 := ' UPDATE Activitytable SET MobileEnabled = ''N'' WHERE ProcessDefId = '|| v_ProcessDefId ||' and ActivityId = '||v_ActivityId_actSub;
						SAVEPOINT mobile_enabled;
						EXECUTE IMMEDIATE v_STR1;            
					END;
					END IF;
					COMMIT;
            END LOOP;
        
            CLOSE cursor_mobile;            
		END;            
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
			/*DBMS_OUTPUT.PUT_LINE('New Column Added successfully in QUEUEUSERTABLE');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''New Column Added successfully in QUEUEUSERTABLE'')';	
			EXECUTE IMMEDIATE 'UPDATE  QUEUEUSERTABLE Set REVISIONNO = RevisionNoSequence.nextval';
	END;
	
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM QUEUEDEFTABLE
		WHERE QueueName = 'SystemArchiveQueue'; 		
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
		   	EXECUTE IMMEDIATE 'Insert into QueueDefTable(QueueId, QueueName, QueueType, Comments, OrderBy, SortOrder) values (QUEUEID.nextval, ''SystemArchiveQueue'', ''A'', ''System generated common Archive Queue'', 10, ''A'')';
			/*DBMS_OUTPUT.PUT_LINE('Data inserted for SystemArchiveQueue successfully in QUEUEDEFTABLE');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Data inserted for SystemArchiveQueue successfully in QUEUEDEFTABLE'')';
			EXECUTE IMMEDIATE 'Insert into WFUserObjAssocTable(Objectid, ObjectTypeId, ProfileId, UserId, AssociationType, AssignedTillDATETIME,AssociationFlag)
		values(QUEUEID.currval,2,0,3,0,null,null)';
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
			/*DBMS_OUTPUT.PUT_LINE('Data inserted for SystemPFEQueue successfully in QUEUEDEFTABLE');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Data inserted for SystemPFEQueue successfully in QUEUEDEFTABLE'')';
			EXECUTE IMMEDIATE 'Insert into WFUserObjAssocTable(Objectid, ObjectTypeId, ProfileId, UserId, AssociationType, AssignedTillDATETIME,AssociationFlag)
		values(QUEUEID.currval,2,0,3,0,null,null)';
			
	END;
	
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM QUEUEDEFTABLE
		WHERE upper(QueueName) = upper('SystemSharePointQueue'); 		
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			v_STR1 := 'Insert into QueueDefTable (QueueId, QueueName, QueueType, Comments, OrderBy, SortOrder)
			values (QUEUEID.nextval, ''SystemSharePointQueue'', ''A'', ''System generated common Share Point Queue'', 10, ''A'')';
			EXECUTE IMMEDIATE v_STR1;
			/*DBMS_OUTPUT.PUT_LINE('Data inserted for SystemSharePointQueue successfully in QUEUEDEFTABLE');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Data inserted for SystemSharePointQueue successfully in QUEUEDEFTABLE'')';
			EXECUTE IMMEDIATE 'Insert into WFUserObjAssocTable(Objectid, ObjectTypeId, ProfileId, UserId, AssociationType, AssignedTillDATETIME,AssociationFlag)
		values(QUEUEID.currval,2,0,3,0,null,null)';
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
				/*DBMS_OUTPUT.PUT_LINE('New Column Added successfully in INITIATEWORKITEMDEFTABLE');*/
				EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''New Column Added successfully in INITIATEWORKITEMDEFTABLE'')';
	/* Updating ImportedprocessDefId column in INITIATEWORKITEMDEFTABLE */			
	/*BEGIN
			SELECT 1 INTO existsFlag FROM USER_TAB_COLUMNS WHERE TABLE_NAME = UPPER('INITIATEWORKITEMDEFTABLE')  AND COLUMN_NAME = UPPER('ImportedProcessDefId');
	EXCEPTION
			WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE INITIATEWORKITEMDEFTABLE Add (ImportedProcessDefId INT NULL)';*/
			
			/*DBMS_OUTPUT.PUT_LINE('New Column Added successfully in INITIATEWORKITEMDEFTABLE');*/
			/*EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''New Column Added successfully in INITIATEWORKITEMDEFTABLE'')';*/
			
			v_STR1:= 'SELECT importedprocessname  from INITIATEWORKITEMDEFTABLE';
			OPEN cur_ImportPro FOR v_STR1;
		LOOP
			Fetch cur_ImportPro into v_ImportedProName;
			EXIT WHEN cur_ImportPro%NOTFOUND;
			BEGIN
				DBMS_OUTPUT.PUT_LINE(v_ImportedProName);
				v_QueryTemp := 'Select ProcessDefId from ProcessdefTable Where ProcessName = '''||v_ImportedProName ||''' and VersionNo = (Select MAX(VersionNo) from ProcessDefTable Where ProcessName = '''||v_ImportedProName ||''')';
    			 DBMS_OUTPUT.PUT_LINE(v_QueryTemp);
				EXECUTE IMMEDIATE v_QueryTemp into v_importedprocessdefid;
				v_QueryTemp1 := 'Update INITIATEWORKITEMDEFTABLE set importedprocessdefid= '|| TO_CHAR(v_importedprocessdefid)||' where importedprocessname = '''||v_ImportedProName||'''';

				DBMS_OUTPUT.PUT_LINE(v_QueryTemp1);
				EXECUTE IMMEDIATE v_QueryTemp1;
			END;
		End Loop;
			Close cur_ImportPro;
		/*END;	*/	
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
				/*DBMS_OUTPUT.PUT_LINE('New Column Added successfully in IMPORTEDPROCESSDEFTABLE');*/
				EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''New Column Added successfully in IMPORTEDPROCESSDEFTABLE'')';
				DBMS_OUTPUT.PUT_LINE('kamal00000000000004354');
	/* Updating ImportedprocessDefId column in IMPORTEDPROCESSDEFTABLE */
	    BEGIN
			/*SELECT 1 INTO existsFlag FROM USER_TAB_COLUMNS WHERE TABLE_NAME = UPPER('IMPORTEDPROCESSDEFTABLE')  AND COLUMN_NAME = UPPER('ImportedProcessDefId');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE IMPORTEDPROCESSDEFTABLE Add (ImportedProcessDefId INT NULL)';
			
			/*DBMS_OUTPUT.PUT_LINE('New Column Added successfully in IMPORTEDPROCESSDEFTABLE');*/
			/*EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''New Column Added successfully in IMPORTEDPROCESSDEFTABLE'')';*/
			
			v_STR1:= 'SELECT importedprocessname  from IMPORTEDPROCESSDEFTABLE';
			OPEN cur_ImportPro FOR v_STR1;
		LOOP
			Fetch cur_ImportPro into v_ImportedProName;
			EXIT WHEN cur_ImportPro%NOTFOUND;
			BEGIN
			    DBMS_OUTPUT.PUT_LINE(v_ImportedProName);
				v_QueryTemp := 'Select ProcessDefId from ProcessdefTable Where ProcessName = '''||v_ImportedProName ||''' and VersionNo = (Select MAX(VersionNo) from ProcessDefTable Where ProcessName = '''||v_ImportedProName ||''')';
    			 DBMS_OUTPUT.PUT_LINE(v_QueryTemp);
				EXECUTE IMMEDIATE v_QueryTemp into v_importedprocessdefid;
				v_QueryTemp1 := 'Update IMPORTEDPROCESSDEFTABLE set importedprocessdefid= '|| TO_CHAR(v_importedprocessdefid)||' where importedprocessname = '''||v_ImportedProName||'''';

				DBMS_OUTPUT.PUT_LINE(v_QueryTemp1);
				EXECUTE IMMEDIATE v_QueryTemp1;

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
		COLUMN_NAME = UPPER('zipFlag');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE WFMAILQUEUETABLE Add (zipFlag nvarchar(1) NULL)';
			/*DBMS_OUTPUT.PUT_LINE('New Column Added successfully in WFMAILQUEUETABLE');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''New Column Added successfully in WFMAILQUEUETABLE'')';
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
			/*DBMS_OUTPUT.PUT_LINE('New Column Added successfully in ARCHIVETABLE');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''New Column Added successfully in ARCHIVETABLE'')';
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
			/*DBMS_OUTPUT.PUT_LINE('New Column Added successfully in ARCHIVEDATAMAPTABLE');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''New Column Added successfully in ARCHIVEDATAMAPTABLE'')';
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
			/*DBMS_OUTPUT.PUT_LINE('New Column Added successfully in CHECKOUTPROCESSESTABLE');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''New Column Added successfully in CHECKOUTPROCESSESTABLE'')';
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
			/*DBMS_OUTPUT.PUT_LINE('New Column Added successfully in EXTMETHODDEFTABLE');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''New Column Added successfully in EXTMETHODDEFTABLE'')';
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
			/*DBMS_OUTPUT.PUT_LINE('New Column Added successfully in GTempQueueTable');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''New Column Added successfully in GTempQueueTable'')';
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
			/*DBMS_OUTPUT.PUT_LINE('New Column Added successfully in GTEMPWORKLISTTABLE');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''New Column Added successfully in GTEMPWORKLISTTABLE'')';
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
			/*DBMS_OUTPUT.PUT_LINE('New Column Added successfully in WFSwimLaneTable');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''New Column Added successfully in WFSwimLaneTable'')';
			EXECUTE IMMEDIATE 'UPDATE WFSwimLaneTable SET PoolId = -1,  IndexInPool = -1';			
	END;
	
	
	BEGIN
	    p_count := 0;
		SELECT count(*) INTO p_count 
		FROM USER_TAB_COLUMNS   
		WHERE TABLE_NAME = UPPER('WFExportTable') 
		AND 
		COLUMN_NAME = UPPER('DateTimeFormat');
		IF (p_count > 0) then
		
			EXECUTE IMMEDIATE 'ALTER TABLE WFExportTable DROP COLUMN DateTimeFormat';		
			/*DBMS_OUTPUT.PUT_LINE('DateTimeFormat Column dropped successfully in WFExportTable');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''DateTimeFormat Column dropped successfully in WFExportTable'')';

		END IF;	
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
			/*DBMS_OUTPUT.PUT_LINE('New Column Added successfully in WFDataMapTable');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''New Column Added successfully in WFDataMapTable'')';
	END;
	
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME = UPPER('WFAdminLogTable') 
		AND 
		COLUMN_NAME = UPPER('Operation');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE WFAdminLogTable ADD Operation NVARCHAR2(1)';			
			/*DBMS_OUTPUT.PUT_LINE('New Column Operation Added successfully in WFAdminLogTable');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''New Column Operation Added successfully in WFAdminLogTable'')';
	
	END;
	
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME = UPPER('WFAdminLogTable') 
		AND 
		COLUMN_NAME = UPPER('ProfileId');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE WFAdminLogTable ADD ProfileId INT';			
			/*DBMS_OUTPUT.PUT_LINE('New Column ProfileId Added successfully in WFAdminLogTable');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''New Column ProfileId Added successfully in WFAdminLogTable'')';
	
	END;
	
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME = UPPER('WFAdminLogTable') 
		AND 
		COLUMN_NAME = UPPER('ProfileName');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE WFAdminLogTable ADD ProfileName NVARCHAR2(64)';			
			/*DBMS_OUTPUT.PUT_LINE('New Column ProfileName Added successfully in WFAdminLogTable');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''New Column ProfileName Added successfully in WFAdminLogTable'')';
	
	END;
	
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME = UPPER('WFAdminLogTable') 
		AND 
		COLUMN_NAME = UPPER('Property1');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE WFAdminLogTable ADD Property1 NVARCHAR2(64)';			
			/*DBMS_OUTPUT.PUT_LINE('New Column Property1 Added successfully in WFAdminLogTable');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''New Column Property1 Added successfully in WFAdminLogTable'')';
	
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
			/*DBMS_OUTPUT.PUT_LINE('New Column Added successfully in WFDataObjectTable');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''New Column Added successfully in WFDataObjectTable'')';
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
			/*DBMS_OUTPUT.PUT_LINE('New Column Added successfully in WFGroupBoxTable');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''New Column Added successfully in WFGroupBoxTable'')';
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
			/*DBMS_OUTPUT.PUT_LINE('New Column Added successfully in WFSAPConnectTable');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''New Column Added successfully in WFSAPConnectTable'')';
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
			/*DBMS_OUTPUT.PUT_LINE('New Column Added successfully in WFSAPGUIAssocTable');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''New Column Added successfully in WFSAPGUIAssocTable'')';
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
			/*DBMS_OUTPUT.PUT_LINE('New Column Added successfully in WFSAPAdapterAssocTable');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''New Column Added successfully in WFSAPAdapterAssocTable'')';
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
			/*DBMS_OUTPUT.PUT_LINE('New Column LastModifiedOn Added successfully in WFFORM_TABLE');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''New Column Added successfully in WFFORM_TABLE'')';
			EXECUTE IMMEDIATE 'UPDATE WFFORM_TABLE SET LASTMODIFIEDON = SYSDATE ';
	END;
	
	    BEGIN
        SELECT 1 INTO existsFlag FROM USER_TAB_COLUMNS WHERE TABLE_NAME = UPPER('QueueHistoryTable') AND COLUMN_NAME = UPPER('ProcessVariantId');
		EXCEPTION
        WHEN NO_DATA_FOUND THEN
            EXECUTE IMMEDIATE 'Alter Table QueueHistoryTable Add  ProcessVariantId INT DEFAULT(0) NOT NULL';
            /*DBMS_OUTPUT.PUT_LINE('Table QueueHistoryTable altered with new Column ProcessVariantId');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''New Column ProcessVariantId Added successfully in QueueHistoryTable'')';
	END;
	BEGIN
        SELECT 1 INTO existsFlag FROM USER_TAB_COLUMNS WHERE TABLE_NAME = UPPER('QueueHistoryTable') AND COLUMN_NAME = UPPER('lastModifiedTime');
		EXCEPTION
        WHEN NO_DATA_FOUND THEN
            EXECUTE IMMEDIATE 'Alter Table QueueHistoryTable Add lastModifiedTime DATE NULL';
            /*DBMS_OUTPUT.PUT_LINE('Table QueueHistoryTable altered with new Column lastModifiedTime');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''New Column lastModifiedTime Added successfully in QueueHistoryTable'')';
	END;
	BEGIN
        SELECT 1 INTO existsFlag FROM USER_TAB_COLUMNS WHERE TABLE_NAME = UPPER('QueueHistoryTable') AND COLUMN_NAME = UPPER('ActivityType');
		EXCEPTION
        WHEN NO_DATA_FOUND THEN
            EXECUTE IMMEDIATE 'ALTER TABLE QUEUEHISTORYTABLE ADD ActivityType SMALLINT NULL';
            /*DBMS_OUTPUT.PUT_LINE('Table QueueHistoryTable altered with new Column ActivityType');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''New Column ActivityType Added successfully in QueueHistoryTable'')';
	END;
	BEGIN
        SELECT 1 INTO existsFlag FROM USER_TAB_COLUMNS WHERE TABLE_NAME = UPPER('GTempSearchTable') AND COLUMN_NAME = UPPER('ACTIVITYTYPE');
		EXCEPTION
        WHEN NO_DATA_FOUND THEN
            EXECUTE IMMEDIATE 'ALTER TABLE GTempSearchTable ADD  ACTIVITYTYPE INT';
            /*DBMS_OUTPUT.PUT_LINE('Table GTempSearchTable altered with new Column ActivityType');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''New Column ActivityType Added successfully in GTempSearchTable'')';
			EXECUTE IMMEDIATE 'ALTER TABLE GTempSearchTable drop column COUNT_1';
			/*DBMS_OUTPUT.PUT_LINE('Table GTempSearchTable altered with drop column COUNT_1');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Table GTempSearchTable altered with drop column COUNT_1'')';
			EXECUTE IMMEDIATE 'ALTER TABLE GTempSearchTable drop column TABLENAME';
			/*DBMS_OUTPUT.PUT_LINE('Table GTempSearchTable altered with drop column TABLENAME');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Table GTempSearchTable altered with drop column TABLENAME'')';
	END;
	BEGIN
        SELECT 1 INTO existsFlag FROM USER_TAB_COLUMNS WHERE TABLE_NAME = UPPER('GTempSearchTable') AND COLUMN_NAME = UPPER('CALENDARNAME');
		EXCEPTION
        WHEN NO_DATA_FOUND THEN
            EXECUTE IMMEDIATE 'ALTER TABLE GTempSearchTable ADD  CALENDARNAME NVARCHAR2 (63)';
            /*DBMS_OUTPUT.PUT_LINE('Table GTempSearchTable altered with new Column ActivityType');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''New Column CALENDARNAME Added successfully in GTempSearchTable'')';
	END;
	BEGIN
        SELECT 1 INTO existsFlag FROM USER_TAB_COLUMNS WHERE TABLE_NAME = UPPER('WFHistoryRouteLogTable') AND COLUMN_NAME = UPPER('ProcessVariantId');
		EXCEPTION
        WHEN NO_DATA_FOUND THEN
            EXECUTE IMMEDIATE 'Alter Table WFHistoryRouteLogTable Add  ProcessVariantId INT DEFAULT(0) NOT NULL';
            /*DBMS_OUTPUT.PUT_LINE('Table WFHistoryRouteLogTable altered with new Column ProcessVariantId');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Table WFHistoryRouteLogTable altered with new Column ProcessVariantId'')';
	END;
	BEGIN
        SELECT 1 INTO existsFlag FROM USER_TAB_COLUMNS WHERE TABLE_NAME = UPPER('WFHistoryRouteLogTable') AND COLUMN_NAME = UPPER('TaskId');
		EXCEPTION
        WHEN NO_DATA_FOUND THEN
            EXECUTE IMMEDIATE 'ALTER TABLE WFHISTORYROUTELOGTABLE ADD TaskId  INT  	DEFAULT(0)';
            /*DBMS_OUTPUT.PUT_LINE('Table WFHistoryRouteLogTable altered with new Column TaskId');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Table WFHistoryRouteLogTable altered with new Column TaskId'')';
	END;
	BEGIN
        SELECT 1 INTO existsFlag FROM USER_TAB_COLUMNS WHERE TABLE_NAME = UPPER('WFHistoryRouteLogTable') AND COLUMN_NAME = UPPER('SubTaskId');
		EXCEPTION
        WHEN NO_DATA_FOUND THEN
            EXECUTE IMMEDIATE 'ALTER TABLE WFHISTORYROUTELOGTABLE ADD SubTaskId	 INT  DEFAULT(0)';
            /*DBMS_OUTPUT.PUT_LINE('Table WFHistoryRouteLogTable altered with new Column SubTaskId');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Table WFHistoryRouteLogTable altered with new Column SubTaskId'')';
	END;
	BEGIN
        SELECT 1 INTO existsFlag FROM USER_TAB_COLUMNS WHERE TABLE_NAME = UPPER('WFCurrentRouteLogTable') AND COLUMN_NAME = UPPER('ProcessVariantId');
		EXCEPTION
        WHEN NO_DATA_FOUND THEN
            EXECUTE IMMEDIATE 'Alter Table WFCurrentRouteLogTable Add  ProcessVariantId INT DEFAULT(0) NOT NULL';
           /* DBMS_OUTPUT.PUT_LINE('Table WFCurrentRouteLogTable altered with new Column ProcessVariantId');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Table WFCurrentRouteLogTable altered with new Column ProcessVariantId'')';
	END;
	BEGIN
        SELECT 1 INTO existsFlag FROM USER_TAB_COLUMNS WHERE TABLE_NAME = UPPER('WFCurrentRouteLogTable') AND COLUMN_NAME = UPPER('TaskId');
		EXCEPTION
        WHEN NO_DATA_FOUND THEN
            EXECUTE IMMEDIATE 'ALTER TABLE WFCURRENTROUTELOGTABLE ADD TaskId 	INT   	DEFAULT(0)';
            /*DBMS_OUTPUT.PUT_LINE('Table WFCurrentRouteLogTable altered with new Column TaskId');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Table WFCurrentRouteLogTable altered with new Column TaskId'')';
	END;
	BEGIN
        SELECT 1 INTO existsFlag FROM USER_TAB_COLUMNS WHERE TABLE_NAME = UPPER('WFCurrentRouteLogTable') AND COLUMN_NAME = UPPER('SubTaskId');
		EXCEPTION
        WHEN NO_DATA_FOUND THEN
            EXECUTE IMMEDIATE 'ALTER TABLE WFCURRENTROUTELOGTABLE ADD SubTaskId	INT 	DEFAULT(0)';
           /* DBMS_OUTPUT.PUT_LINE('Table WFCurrentRouteLogTable altered with new Column SubTaskId');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Table WFCurrentRouteLogTable altered with new Column SubTaskId'')';
	END;
	BEGIN
        SELECT 1 INTO existsFlag FROM USER_TAB_COLUMNS WHERE TABLE_NAME = UPPER('ActivityInterfaceAssocTable') AND COLUMN_NAME = UPPER('ProcessVariantId');
		EXCEPTION
        WHEN NO_DATA_FOUND THEN
            EXECUTE IMMEDIATE 'Alter Table ActivityInterfaceAssocTable Add  ProcessVariantId INT DEFAULT(0) NOT NULL';
            /*DBMS_OUTPUT.PUT_LINE('Table ActivityInterfaceAssocTable altered with new Column ProcessVariantId');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Table ActivityInterfaceAssocTable altered with new Column ProcessVariantId'')';
	END;
	BEGIN
        SELECT 1 INTO existsFlag FROM USER_TAB_COLUMNS WHERE TABLE_NAME = UPPER('SummaryTable') AND COLUMN_NAME = UPPER('ProcessVariantId');
		EXCEPTION
        WHEN NO_DATA_FOUND THEN
            EXECUTE IMMEDIATE 'Alter Table SummaryTable Add  ProcessVariantId INT DEFAULT(0) NOT NULL';
            /*DBMS_OUTPUT.PUT_LINE('Table SummaryTable altered with new Column ProcessVariantId');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Table SummaryTable altered with new Column ProcessVariantId'')';
	END;
	BEGIN
        SELECT 1 INTO existsFlag FROM USER_TAB_COLUMNS WHERE TABLE_NAME = UPPER('WFReportDataTable') AND COLUMN_NAME = UPPER('ProcessVariantId');
		EXCEPTION
        WHEN NO_DATA_FOUND THEN
            EXECUTE IMMEDIATE 'Alter Table WFReportDataTable Add  ProcessVariantId INT DEFAULT(0) NOT NULL';
            /*DBMS_OUTPUT.PUT_LINE('Table WFReportDataTable altered with new Column ProcessVariantId');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Table WFReportDataTable altered with new Column ProcessVariantId'')';
	END;
	BEGIN
        SELECT 1 INTO existsFlag FROM USER_TAB_COLUMNS WHERE TABLE_NAME = UPPER('WFVarStatusTable') AND COLUMN_NAME = UPPER('ProcessVariantId');
		EXCEPTION
        WHEN NO_DATA_FOUND THEN
            EXECUTE IMMEDIATE 'Alter Table WFVarStatusTable Add  ProcessVariantId INT DEFAULT(0) NOT NULL';
            /*DBMS_OUTPUT.PUT_LINE('Table WFVarStatusTable altered with new Column ProcessVariantId');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Table WFVarStatusTable altered with new Column ProcessVariantId'')';
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
			/*DBMS_OUTPUT.PUT_LINE('New Column LastModifiedOn Added successfully in WFFormFragmentTable');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Table WFFormFragmentTable altered with new Column LastModifiedOn'')';
			EXECUTE IMMEDIATE 'UPDATE WFFormFragmentTable SET LASTMODIFIEDON = SYSDATE ';
	END;
	
	BEGIN
        SELECT 1 INTO existsFlag FROM USER_TAB_COLUMNS WHERE TABLE_NAME = UPPER('ACTIVITYASSOCIATIONTABLE') AND COLUMN_NAME = UPPER('ProcessVariantId');
		EXCEPTION
        WHEN NO_DATA_FOUND THEN
            EXECUTE IMMEDIATE 'Alter Table ACTIVITYASSOCIATIONTABLE Add  ProcessVariantId INT DEFAULT(0) NOT NULL';
           /* DBMS_OUTPUT.PUT_LINE('Table ACTIVITYASSOCIATIONTABLE altered with new Column ProcessVariantId');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Table ACTIVITYASSOCIATIONTABLE altered with new Column ProcessVariantId'')';
    END;
	
	BEGIN
        SELECT 1 INTO existsFlag FROM USER_TAB_COLUMNS WHERE TABLE_NAME = UPPER('VARMAPPINGTABLE') AND COLUMN_NAME = UPPER('ProcessVariantId');
		EXCEPTION
        WHEN NO_DATA_FOUND THEN
            EXECUTE IMMEDIATE 'Alter Table VARMAPPINGTABLE Add  ProcessVariantId INT DEFAULT(0) NOT NULL';
            /*DBMS_OUTPUT.PUT_LINE('Table VARMAPPINGTABLE altered with new Column ProcessVariantId');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Table VARMAPPINGTABLE altered with new Column ProcessVariantId'')';
	END;
	
	BEGIN
        SELECT 1 INTO existsFlag FROM USER_TAB_COLUMNS WHERE TABLE_NAME = UPPER('WFUDTVarMappingTable') AND COLUMN_NAME = UPPER('ProcessVariantId');
		EXCEPTION
        WHEN NO_DATA_FOUND THEN
            EXECUTE IMMEDIATE 'Alter Table WFUDTVarMappingTable Add  ProcessVariantId INT DEFAULT(0) NOT NULL';
           /* DBMS_OUTPUT.PUT_LINE('Table WFUDTVarMappingTable altered with new Column ProcessVariantId');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Table WFUDTVarMappingTable altered with new Column ProcessVariantId'')';
	END;
	
	BEGIN
        SELECT 1 INTO existsFlag FROM USER_TAB_COLUMNS WHERE TABLE_NAME = UPPER('EXTDBCONFTABLE') AND COLUMN_NAME = UPPER('ProcessVariantId');
		EXCEPTION
        WHEN NO_DATA_FOUND THEN
            EXECUTE IMMEDIATE 'Alter Table EXTDBCONFTABLE Add  ProcessVariantId INT DEFAULT(0) NOT NULL';
            /*DBMS_OUTPUT.PUT_LINE('Table EXTDBCONFTABLE altered with new Column ProcessVariantId');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Table EXTDBCONFTABLE altered with new Column ProcessVariantId'')';
	END;
	
	BEGIN
        SELECT 1 INTO existsFlag FROM USER_TAB_COLUMNS WHERE TABLE_NAME = UPPER('DOCUMENTTYPEDEFTABLE') AND COLUMN_NAME = UPPER('ProcessVariantId');
		EXCEPTION
        WHEN NO_DATA_FOUND THEN
            EXECUTE IMMEDIATE 'Alter Table DOCUMENTTYPEDEFTABLE Add  ProcessVariantId INT DEFAULT(0) NOT NULL';
            /*DBMS_OUTPUT.PUT_LINE('Table DOCUMENTTYPEDEFTABLE altered with new Column ProcessVariantId');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Table DOCUMENTTYPEDEFTABLE altered with new Column ProcessVariantId'')';
	END;
	
	BEGIN
        SELECT 1 INTO existsFlag FROM USER_TAB_COLUMNS WHERE TABLE_NAME = UPPER('WFTYPEDEFTABLE') AND COLUMN_NAME = UPPER('ProcessVariantId');
		EXCEPTION
        WHEN NO_DATA_FOUND THEN
            EXECUTE IMMEDIATE 'Alter Table WFTYPEDEFTABLE Add  ProcessVariantId INT DEFAULT(0) NOT NULL';
            /*DBMS_OUTPUT.PUT_LINE('Table WFTYPEDEFTABLE altered with new Column ProcessVariantId');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Table WFTYPEDEFTABLE altered with new Column ProcessVariantId'')';
	END;
	
	BEGIN
        SELECT 1 INTO existsFlag FROM USER_TAB_COLUMNS WHERE TABLE_NAME = UPPER('WFTYPEDESCTABLE') AND COLUMN_NAME = UPPER('ProcessVariantId');
		EXCEPTION
        WHEN NO_DATA_FOUND THEN
            EXECUTE IMMEDIATE 'Alter Table WFTYPEDESCTABLE Add  ProcessVariantId INT DEFAULT(0) NOT NULL';
            /*DBMS_OUTPUT.PUT_LINE('Table WFTYPEDESCTABLE altered with new Column ProcessVariantId');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Table WFTYPEDESCTABLE altered with new Column ProcessVariantId'')';
	END;
	
	BEGIN
        SELECT 1 INTO existsFlag FROM USER_TAB_COLUMNS WHERE TABLE_NAME = UPPER('WFVARRELATIONTABLE') AND COLUMN_NAME = UPPER('ProcessVariantId');
		EXCEPTION
        WHEN NO_DATA_FOUND THEN
            EXECUTE IMMEDIATE 'Alter Table WFVARRELATIONTABLE Add  ProcessVariantId INT DEFAULT(0) NOT NULL';
            /*DBMS_OUTPUT.PUT_LINE('Table WFVARRELATIONTABLE altered with new Column ProcessVariantId');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Table WFVARRELATIONTABLE altered with new Column ProcessVariantId'')';
	END;
	
	BEGIN
        SELECT 1 INTO existsFlag FROM USER_TAB_COLUMNS WHERE TABLE_NAME = UPPER('TemplateMultiLanguageTable') AND COLUMN_NAME = UPPER('ProcessVariantId');
		EXCEPTION
        WHEN NO_DATA_FOUND THEN
            EXECUTE IMMEDIATE 'Alter Table TemplateMultiLanguageTable Add  ProcessVariantId INT DEFAULT(0) NOT NULL';
            /*DBMS_OUTPUT.PUT_LINE('Table TemplateMultiLanguageTable altered with new Column ProcessVariantId');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Table TemplateMultiLanguageTable altered with new Column ProcessVariantId'')';
	END;
	
	BEGIN
        SELECT 1 INTO existsFlag FROM USER_TAB_COLUMNS WHERE TABLE_NAME = UPPER('WFFORM_TABLE') AND COLUMN_NAME = UPPER('ProcessVariantId');
		EXCEPTION
        WHEN NO_DATA_FOUND THEN
            EXECUTE IMMEDIATE 'Alter Table WFFORM_TABLE Add  ProcessVariantId INT DEFAULT(0) NOT NULL';
            /*DBMS_OUTPUT.PUT_LINE('Table WFFORM_TABLE altered with new Column ProcessVariantId');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Table WFFORM_TABLE altered with new Column ProcessVariantId'')';
	END;
	
	BEGIN
        SELECT 1 INTO existsFlag FROM USER_TAB_COLUMNS WHERE TABLE_NAME = UPPER('GTEMPWORKLISTTABLE') AND COLUMN_NAME = UPPER('ProcessVariantId');
		EXCEPTION
        WHEN NO_DATA_FOUND THEN
            EXECUTE IMMEDIATE 'Alter Table GTEMPWORKLISTTABLE Add  ProcessVariantId INT ';
            /*DBMS_OUTPUT.PUT_LINE('Table GTEMPWORKLISTTABLE altered with new Column ProcessVariantId');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Table GTEMPWORKLISTTABLE altered with new Column ProcessVariantId'')';
	END;
	
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
			/*DBMS_OUTPUT.PUT_LINE('New trigger created with name as WF_LIB_ID_TRIGGER');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''New trigger created with name as WF_LIB_ID_TRIGGER'')';
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
		/*DBMS_OUTPUT.PUT_LINE('New trigger created with name as WF_USR_DEL');*/
		EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''New trigger created with name as WF_USR_DEL'')';
	END;
	/*added by rishi -- start here*/
	BEGIN
		SELECT LAST_NUMBER INTO v_lastSeqValue
		FROM USER_SEQUENCES
		WHERE SEQUENCE_NAME = UPPER('seq_rootlogid');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
		    EXECUTE IMMEDIATE 'CREATE SEQUENCE seq_rootlogid INCREMENT BY 1 START WITH 1 NOCACHE';
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE SEQUENCE seq_rootlogid'')';
	END;
	 BEGIN
		BEGIN  
		EXECUTE IMMEDIATE ('CREATE OR REPLACE TRIGGER WF_LOG_ID_TRIGGER 	BEFORE INSERT ON WFCURRENTROUTELOGTABLE 	
						   FOR EACH ROW BEGIN 	SELECT seq_rootlogid.nextval INTO :new.LOGID FROM dual; END;');
	  END;
	EXCEPTION
		WHEN OTHERS THEN
		raise_application_error(-20298, 'Creating TRIGGER WF_LOG_ID_TRIGGER Failed.');
		RETURN;
	END;
	
	BEGIN  
		BEGIN
			SELECT 1 INTO v_existsFlag 
			FROM USER_TRIGGERS
			WHERE TRIGGER_NAME='WF_UTIL_UNREGISTER'
			AND 
			TABLE_NAME='PSREGISTERATIONTABLE';
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				 v_existsFlag := 0;
		END;
		IF v_existsFlag = 1 THEN
			EXECUTE IMMEDIATE 'DROP TRIGGER WF_UTIL_UNREGISTER';
			/*DBMS_OUTPUT.PUT_LINE('WF_UTIL_UNREGISTER TRIGGER ON PSREGISTERATIONTABLE DROPPED');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''WF_UTIL_UNREGISTER TRIGGER ON PSREGISTERATIONTABLE DROPPED'')';
		END IF;
	EXCEPTION
		WHEN OTHERS THEN
		raise_application_error(-20325, 'Dropping trigger WF_UTIL_UNREGISTER Failed.');
		RETURN;
	END;
	
	BEGIN  
		BEGIN
			SELECT 1 INTO v_existsFlag 
			FROM USER_TRIGGERS
			WHERE TRIGGER_NAME='WFFailFileRecords_TRG'
			AND 
			TABLE_NAME='WFFailFileRecords';
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				 v_existsFlag := 0;
		END;
		IF v_existsFlag = 1 THEN
			EXECUTE IMMEDIATE 'DROP TRIGGER WFFailFileRecords_TRG';
			/*DBMS_OUTPUT.PUT_LINE('WFFailFileRecords_TRG TRIGGER ON WFFailFileRecords DROPPED');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''WFFailFileRecords_TRG TRIGGER ON WFFailFileRecords DROPPED'')';
		END IF;
	EXCEPTION
		WHEN OTHERS THEN
		raise_application_error(-20325, 'Dropping trigger WFFailFileRecords_TRG Failed.');
		RETURN;
	END;
	/*added by rishi -- end here*/

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
			/*DBMS_OUTPUT.PUT_LINE('New View created with name as WFUSERVIEW');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''New View created with name as WFUSERVIEW'')';
	END;
	
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
			/*DBMS_OUTPUT.PUT_LINE('New View created with name as PROFILEUSERGROUPVIEW');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''New View created with name as PROFILEUSERGROUPVIEW'')';
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
			/*DBMS_OUTPUT.PUT_LINE('New View created with name as WFROLEVIEW');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''New View created with name as WFROLEVIEW'')';
	END;
	
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_CONSTRAINTS
		WHERE TABLE_NAME = UPPER('TEMPLATEDEFINITIONTABLE')
		AND CONSTRAINT_TYPE = 'P';
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE TEMPLATEDEFINITIONTABLE Add CONSTRAINT Pk_TEMPLATEDEFINITIONTABLE PRIMARY KEY (ProcessdefId,TemplateId)';
			/*DBMS_OUTPUT.PUT_LINE('Primary key is added in TEMPLATEDEFINITIONTABLE');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Primary key is added in TEMPLATEDEFINITIONTABLE'')';
	END;
	
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_CONSTRAINTS
		WHERE TABLE_NAME = UPPER('ACTIONDEFTABLE')
		AND CONSTRAINT_TYPE = 'P';
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE ACTIONDEFTABLE Add CONSTRAINT PK_ACTIONDEFTABLE PRIMARY KEY (ProcessDefId,ActionId,ActivityId)';
			/*DBMS_OUTPUT.PUT_LINE('Primary key is added in ACTIONDEFTABLE');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Primary key is added in ACTIONDEFTABLE'')';
	END;
	
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_CONSTRAINTS
		WHERE TABLE_NAME = UPPER('TODOLISTDEFTABLE')
		AND CONSTRAINT_TYPE = 'P';
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE TODOLISTDEFTABLE Add CONSTRAINT PK_TODOLISTDEFTABLE PRIMARY KEY (ProcessDefID, ToDoId)';
			/*DBMS_OUTPUT.PUT_LINE('Primary key is added in TODOLISTDEFTABLE');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Primary key is added in TODOLISTDEFTABLE'')';
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
			EXECUTE IMMEDIATE 'ALTER TABLE TODOPICKLISTTABLE Add CONSTRAINT PK_TODOPICKLISTTABLE PRIMARY KEY (ProcessDefId,ToDoId,PickListValue)';
			/*DBMS_OUTPUT.PUT_LINE('Primary key is added in TODOPICKLISTTABLE');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Primary key is added in TODOPICKLISTTABLE'')';
	END;
	
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_CONSTRAINTS
		WHERE TABLE_NAME = UPPER('EXCEPTIONDEFTABLE')
		AND CONSTRAINT_TYPE = 'P';
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE EXCEPTIONDEFTABLE Add CONSTRAINT PK_EXCEPTIONDEFTABLE PRIMARY KEY (ProcessDefId, ExceptionId)';
			/*DBMS_OUTPUT.PUT_LINE('Primary key is added in EXCEPTIONDEFTABLE');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Primary key is added in EXCEPTIONDEFTABLE'')';
	END;
	
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_CONSTRAINTS
		WHERE TABLE_NAME = UPPER('DOCUMENTTYPEDEFTABLE')
		AND CONSTRAINT_TYPE = 'P';
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE DOCUMENTTYPEDEFTABLE Add CONSTRAINT PK_DOCUMENTTYPEDEFTABLE PRIMARY KEY (ProcessDefId, DocId)';
			/*DBMS_OUTPUT.PUT_LINE('Primary key is added in DOCUMENTTYPEDEFTABLE');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Primary key is added in DOCUMENTTYPEDEFTABLE'')';
	END;
	
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_CONSTRAINTS
		WHERE TABLE_NAME = UPPER('PROCESSINITABLE')
		AND CONSTRAINT_TYPE = 'P';
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE PROCESSINITABLE Add CONSTRAINT PK_PROCESSINITABLE PRIMARY KEY (ProcessDefId)';
			/*DBMS_OUTPUT.PUT_LINE('Primary key is added in PROCESSINITABLE');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Primary key is added in PROCESSINITABLE'')';
	END;
	
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_CONSTRAINTS
		WHERE TABLE_NAME = UPPER('InterfaceDescLanguageTable')
		AND CONSTRAINT_TYPE = 'P';
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE InterfaceDescLanguageTable Add CONSTRAINT PK_InterfaceDescLanguageTable PRIMARY KEY (ProcessDefId,ElementId, InterfaceID)';
			/*DBMS_OUTPUT.PUT_LINE('Primary key is added in InterfaceDescLanguageTable');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Primary key is added in InterfaceDescLanguageTable'')';
	END;

	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_CONSTRAINTS
		WHERE TABLE_NAME = UPPER('WFSwimLaneTable')
		AND CONSTRAINT_TYPE = 'P';
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE WFSwimLaneTable Add CONSTRAINT PK_WFSwimLaneTable PRIMARY KEY (ProcessDefId, SwimLaneId)';
			/*DBMS_OUTPUT.PUT_LINE('Primary key is added in WFSwimLaneTable');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Primary key is added in WFSwimLaneTable'')';
	END;
	
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_CONSTRAINTS
		WHERE TABLE_NAME = UPPER('WFDataMapTable')
		AND CONSTRAINT_TYPE = 'P';
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE WFDataMapTable Add CONSTRAINT PK_WFDataMapTable PRIMARY KEY (ProcessDefId, ActivityId, OrderId)';
			/*DBMS_OUTPUT.PUT_LINE('Primary key is added in WFDataMapTable');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Primary key is added in WFDataMapTable'')';
	END;
	
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_CONSTRAINTS
		WHERE TABLE_NAME = UPPER('WFExtInterfaceConditionTable')
		AND CONSTRAINT_TYPE = 'P';
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE WFExtInterfaceConditionTable Add CONSTRAINT PK_WFExtIntCondTable PRIMARY KEY (ProcessDefId, InterfaceType, RuleId, ConditionOrderId)';
			/*DBMS_OUTPUT.PUT_LINE('Primary key is added in WFExtInterfaceConditionTable');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Primary key is added in WFExtInterfaceConditionTable'')';
	END;
	
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_CONSTRAINTS
		WHERE TABLE_NAME = UPPER('WFFormFragmentTable')
		AND CONSTRAINT_TYPE = 'P';
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE WFFormFragmentTable Add CONSTRAINT PK_WFFormFragmentTable PRIMARY KEY (ProcessDefId,FragmentId)';
			/*DBMS_OUTPUT.PUT_LINE('Primary key is added in WFFormFragmentTable');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Primary key is added in WFFormFragmentTable'')';
	END;
	/*added by rishi -- start here*/
	BEGIN
		SELECT CONSTRAINT_NAME INTO v_constraintName
			FROM USER_CONSTRAINTS 
			WHERE TABLE_NAME = UPPER('PRINTFAXEMAILTABLE') AND constraint_type = 'P';
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE('Alter Table PRINTFAXEMAILTABLE Add Constraint PK_PRINTFAXEMAILTABLE PRIMARY KEY(ProcessDefId,PFEInterfaceId)');
			/*DBMS_OUTPUT.PUT_LINE('Primary Key Updated for PRINTFAXEMAILTABLE');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Primary key is added in PRINTFAXEMAILTABLE'')';
	END;
	/*added by rishi -- end here*/
	
	BEGIN
	SELECT CONSTRAINT_NAME INTO v_constraintName
		FROM USER_CONSTRAINTS 
		WHERE TABLE_NAME = UPPER('ProcessDefTable') 
		AND constraint_type = 'P';

		EXECUTE IMMEDIATE 'Alter Table ProcessDefTable Drop Constraint ' || TO_CHAR(v_constraintName);
		EXECUTE IMMEDIATE 'Alter Table ProcessDefTable Add Constraint ' || TO_CHAR(v_constraintName) || ' Primary Key (Processdefid, VersionNo)';
		/*DBMS_OUTPUT.PUT_LINE('Primary Key Updated for ProcessDefTable');*/
		EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''PrimaryPrimary Key Updated for ProcessDefTable'')';
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'Alter Table ProcessDefTable Add Constraint PK_PROCESSDEFTABLE Primary Key (Processdefid, VersionNo)';
		    /*DBMS_OUTPUT.PUT_LINE('Primary Key Created for ProcessDefTable');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Primary key is Created in ProcessDefTable'')';
	END;

	BEGIN	
      SELECT CONSTRAINT_NAME INTO v_constraintName
		FROM USER_CONSTRAINTS 
		WHERE TABLE_NAME = UPPER('ACTIVITYASSOCIATIONTABLE') AND constraint_type = 'P';
		EXECUTE IMMEDIATE 'Alter Table ACTIVITYASSOCIATIONTABLE Drop Constraint ' || TO_CHAR(v_constraintName);
		EXECUTE IMMEDIATE 'Alter Table ACTIVITYASSOCIATIONTABLE Add Constraint ' || TO_CHAR(v_constraintName) || ' Primary Key (ProcessdefId, ActivityId, DefinitionType, DefinitionId,ProcessVariantId)';
		/*DBMS_OUTPUT.PUT_LINE('Primary Key Updated for ACTIVITYASSOCIATIONTABLE');*/
		EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Primary key is Updated in ACTIVITYASSOCIATIONTABLE'')';
  	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'Alter Table ACTIVITYASSOCIATIONTABLE Add Constraint PK_ACTIVITYASSOCTABLE Primary Key (ProcessdefId, ActivityId, DefinitionType, DefinitionId,ProcessVariantId)';
		    /*DBMS_OUTPUT.PUT_LINE('Primary Key created for ACTIVITYASSOCIATIONTABLE');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Primary key is Created in ACTIVITYASSOCIATIONTABLE'')';
	END;
	
	BEGIN
      SELECT CONSTRAINT_NAME INTO v_constraintName FROM USER_CONSTRAINTS 
		WHERE TABLE_NAME = UPPER('VARMAPPINGTABLE') AND constraint_type = 'P';
		EXECUTE IMMEDIATE 'Alter Table VARMAPPINGTABLE Drop Constraint ' || TO_CHAR(v_constraintName);
		EXECUTE IMMEDIATE 'Alter Table VARMAPPINGTABLE Add Constraint ' || TO_CHAR(v_constraintName) || ' Primary Key(ProcessDefID,VariableId,ProcessVariantId)';
		/*DBMS_OUTPUT.PUT_LINE('Primary Key Updated for VARMAPPINGTABLE');*/
		EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Primary key is Updated in VARMAPPINGTABLE'')';
  	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'Alter Table VARMAPPINGTABLE Add Constraint PK_VARMAPPINGTABLE Primary Key(ProcessDefID,VariableId,ProcessVariantId)';
		    /*DBMS_OUTPUT.PUT_LINE('Primary Key created for VARMAPPINGTABLE');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Primary key is Created in VARMAPPINGTABLE'')';
	END;
	
	BEGIN
      SELECT CONSTRAINT_NAME INTO v_constraintName
		FROM USER_CONSTRAINTS 
		WHERE TABLE_NAME = UPPER('WFUDTVarMappingTable') AND constraint_type = 'P';
		EXECUTE IMMEDIATE 'Alter Table WFUDTVarMappingTable Drop Constraint ' || TO_CHAR(v_constraintName);
		EXECUTE IMMEDIATE 'Alter Table WFUDTVarMappingTable Add Constraint ' || TO_CHAR(v_constraintName) || ' Primary Key (ProcessDefId, VariableId, VarFieldId,ProcessVariantId)';
		/*DBMS_OUTPUT.PUT_LINE('Primary Key Updated for WFUDTVarMappingTable');*/
		EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Primary key is Updated in WFUDTVarMappingTable'')';
  	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'Alter Table WFUDTVarMappingTable Add Constraint PK_WFUDTVarMappTable  Primary Key (ProcessDefId, VariableId, VarFieldId,ProcessVariantId)';
		   /*DBMS_OUTPUT.PUT_LINE('Primary Key Created for WFUDTVarMappingTable');*/
		   EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Primary key is Created in WFUDTVarMappingTable'')';
	END;
	
	BEGIN
      SELECT CONSTRAINT_NAME INTO v_constraintName
		FROM USER_CONSTRAINTS 
		WHERE TABLE_NAME = UPPER('EXTDBCONFTABLE') AND constraint_type = 'P';
		EXECUTE IMMEDIATE 'Alter Table EXTDBCONFTABLE Drop Constraint ' || TO_CHAR(v_constraintName);
		EXECUTE IMMEDIATE 'Alter Table EXTDBCONFTABLE Add Constraint ' || TO_CHAR(v_constraintName) || ' Primary Key (ProcessDefId,ExtObjID,ProcessVariantId)';
		/*DBMS_OUTPUT.PUT_LINE('Primary Key Updated for EXTDBCONFTABLE');*/
		EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Primary key is Updated in EXTDBCONFTABLE'')';
  	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'Alter Table EXTDBCONFTABLE Add Constraint PK_EXTDBCONFTABLE Primary Key (ProcessDefId,ExtObjID,ProcessVariantId)';
		    /*DBMS_OUTPUT.PUT_LINE('Primary Key created for EXTDBCONFTABLE');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Primary key is Created in EXTDBCONFTABLE'')';
	END;
	
	BEGIN
      SELECT CONSTRAINT_NAME INTO v_constraintName
		FROM USER_CONSTRAINTS 
		WHERE TABLE_NAME = UPPER('DOCUMENTTYPEDEFTABLE') AND constraint_type = 'P';
		EXECUTE IMMEDIATE 'Alter Table DOCUMENTTYPEDEFTABLE Drop Constraint ' || TO_CHAR(v_constraintName);
		EXECUTE IMMEDIATE 'Alter Table DOCUMENTTYPEDEFTABLE Add Constraint ' || TO_CHAR(v_constraintName) || ' Primary Key (ProcessDefId, DocId,ProcessVariantId)';
		/*DBMS_OUTPUT.PUT_LINE('Primary Key Updated for DOCUMENTTYPEDEFTABLE');*/
		EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Primary key is Updated in DOCUMENTTYPEDEFTABLE'')';
  	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'Alter Table DOCUMENTTYPEDEFTABLE Add Constraint PK_DOCUMENTTYPEDEFTABLE Primary Key (ProcessDefId, DocId,ProcessVariantId)';
	    	/*DBMS_OUTPUT.PUT_LINE('Primary Key created for DOCUMENTTYPEDEFTABLE');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Primary key is Created in DOCUMENTTYPEDEFTABLE'')';
	END;
	
	BEGIN
      SELECT CONSTRAINT_NAME INTO v_constraintName
		FROM USER_CONSTRAINTS 
		WHERE TABLE_NAME = UPPER('WFTYPEDEFTABLE') AND constraint_type = 'P';
		EXECUTE IMMEDIATE 'Alter Table WFTYPEDEFTABLE Drop Constraint ' || TO_CHAR(v_constraintName);
		EXECUTE IMMEDIATE 'Alter Table WFTYPEDEFTABLE Add Constraint ' || TO_CHAR(v_constraintName) || ' Primary Key (ProcessDefId, ParentTypeId, TypeFieldId,ProcessVariantId)';
		/*DBMS_OUTPUT.PUT_LINE('Primary Key Updated for WFTYPEDEFTABLE');*/
		EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Primary key is Updated in WFTYPEDEFTABLE'')';
  	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'Alter Table WFTYPEDEFTABLE Add Constraint PK_WFTYPEDEFTABLE Primary Key (ProcessDefId, ParentTypeId, TypeFieldId,ProcessVariantId)';
		DBMS_OUTPUT.PUT_LINE('Primary Key created for WFTYPEDEFTABLE');
		EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Primary key is Created in WFTYPEDEFTABLE'')';
	END;
	
	BEGIN
      SELECT CONSTRAINT_NAME INTO v_constraintName
		FROM USER_CONSTRAINTS 
		WHERE TABLE_NAME = UPPER('WFTYPEDESCTABLE') AND constraint_type = 'P';
		EXECUTE IMMEDIATE 'Alter Table WFTYPEDESCTABLE Drop Constraint ' || TO_CHAR(v_constraintName);
		EXECUTE IMMEDIATE 'Alter Table WFTYPEDESCTABLE Add Constraint ' || TO_CHAR(v_constraintName) || ' Primary Key (ProcessDefId, TypeId,ProcessVariantId)';
		/*DBMS_OUTPUT.PUT_LINE('Primary Key Updated for WFTYPEDESCTABLE');*/
		EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Primary key is Updated in WFTYPEDESCTABLE'')';
  	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'Alter Table WFTYPEDESCTABLE Add Constraint PK_WFTYPEDESCTABLE Primary Key (ProcessDefId, TypeId,ProcessVariantId)';
		/*DBMS_OUTPUT.PUT_LINE('Primary Key created for WFTYPEDESCTABLE');*/
		EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Primary key is Created in WFTYPEDESCTABLE'')';
	END;
	
	BEGIN
      SELECT CONSTRAINT_NAME INTO v_constraintName
		FROM USER_CONSTRAINTS 
		WHERE TABLE_NAME = UPPER('WFVARRELATIONTABLE') AND constraint_type = 'P';
		EXECUTE IMMEDIATE 'Alter Table WFVARRELATIONTABLE Drop Constraint ' || TO_CHAR(v_constraintName);
		EXECUTE IMMEDIATE 'Alter Table WFVARRELATIONTABLE Add Constraint ' || TO_CHAR(v_constraintName) || ' Primary Key (ProcessDefId, RelationId, OrderId,ProcessVariantId)';
		/*DBMS_OUTPUT.PUT_LINE('Primary Key Updated for WFVARRELATIONTABLE');*/
		EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Primary key is Updated in WFVARRELATIONTABLE'')';
  	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'Alter Table WFVARRELATIONTABLE Add Constraint PK_WFVARRELATIONTABLE Primary Key (ProcessDefId, RelationId, OrderId,ProcessVariantId)';
	    	/*DBMS_OUTPUT.PUT_LINE('Primary Key created for WFVARRELATIONTABLE');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Primary key is Created in WFVARRELATIONTABLE'')';
	END;
	
	BEGIN
      SELECT CONSTRAINT_NAME INTO v_constraintName
		FROM USER_CONSTRAINTS 
		WHERE TABLE_NAME = UPPER('TemplateMultiLanguageTable') AND constraint_type = 'P';
		EXECUTE IMMEDIATE 'Alter Table TemplateMultiLanguageTable Drop Constraint ' || TO_CHAR(v_constraintName);
		EXECUTE IMMEDIATE 'Alter Table TemplateMultiLanguageTable Add Constraint ' || TO_CHAR(v_constraintName) || ' Primary Key (PROCESSDEFID, TEMPLATEID, LOCALE,ProcessVariantId)';
		/*DBMS_OUTPUT.PUT_LINE('Primary Key Updated for TemplateMultiLanguageTable');*/
		EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Primary key is Updated in TemplateMultiLanguageTable'')';
  	EXCEPTION
		WHEN NO_DATA_FOUND THEN
		EXECUTE IMMEDIATE 'Alter Table TemplateMultiLanguageTable Add Constraint PK_TempMultiLangTable Primary Key (PROCESSDEFID, TEMPLATEID, LOCALE,ProcessVariantId)';
	    /*DBMS_OUTPUT.PUT_LINE('Primary Key created for TemplateMultiLanguageTable');*/
		EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Primary key is Created in TemplateMultiLanguageTable'')';
	END;
	
	BEGIN
      SELECT CONSTRAINT_NAME INTO v_constraintName
		FROM USER_CONSTRAINTS 
		WHERE TABLE_NAME = UPPER('WFFORM_TABLE') AND constraint_type = 'P';
		EXECUTE IMMEDIATE 'Alter Table WFFORM_TABLE Drop Constraint ' || TO_CHAR(v_constraintName);
		EXECUTE IMMEDIATE 'Alter Table WFFORM_TABLE Add Constraint ' || TO_CHAR(v_constraintName) || ' Primary Key (ProcessDefID,FormId,DeviceType)';
		/*DBMS_OUTPUT.PUT_LINE('Primary Key Updated for WFFORM_TABLE');*/
		EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Primary key is Updated in WFFORM_TABLE'')';
  	EXCEPTION
		WHEN NO_DATA_FOUND THEN
		EXECUTE IMMEDIATE 'Alter Table WFFORM_TABLE Add Constraint PK_WFFORM_TABLE Primary Key (ProcessDefID,FormId,DeviceType)';
		/*DBMS_OUTPUT.PUT_LINE('Primary Key created for WFFORM_TABLE');*/
		EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Primary key is Created in WFFORM_TABLE'')';
	END;
	
	BEGIN
		EXECUTE IMMEDIATE 'UPDATE TRIGGERDEFTABLE SET DESCRIPTION = '' '' Where Description is NULL';
	END;

	BEGIN
			SELECT 1 INTO existsFlag 
			FROM WFCabVersionTable
			WHERE CabVersion = 'iBPS_3.0'; 		
			EXCEPTION
				WHEN NO_DATA_FOUND THEN
			
			EXECUTE IMMEDIATE 'ALTER TABLE QUEUEHISTORYTABLE MODIFY (LastProcessedBy INT)';
			EXECUTE IMMEDIATE 'ALTER TABLE QUEUEHISTORYTABLE MODIFY (ReferredTo INT)';
			EXECUTE IMMEDIATE 'ALTER TABLE QUEUEHISTORYTABLE MODIFY (ReferredBy INT)';
			/*DBMS_OUTPUT.PUT_LINE('Column Types modified successfully in QUEUEHISTORYTABLE');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Column Types modified successfully in QUEUEHISTORYTABLE'')';
			EXECUTE IMMEDIATE 'ALTER TABLE QUEUEUSERTABLE MODIFY (Userid INT)';		
			/*DBMS_OUTPUT.PUT_LINE('Column Types modified successfully in QUEUEUSERTABLE');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Column Types modified successfully in QUEUEUSERTABLE'')';
			EXECUTE IMMEDIATE 'ALTER TABLE USERDIVERSIONTABLE MODIFY (Diverteduserindex INT)';	
			EXECUTE IMMEDIATE 'ALTER TABLE USERDIVERSIONTABLE MODIFY (AssignedUserindex INT )';	
			/*DBMS_OUTPUT.PUT_LINE('Column Types modified successfully in USERDIVERSIONTABLE');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Column Types modified successfully in USERDIVERSIONTABLE'')';
			EXECUTE IMMEDIATE 'ALTER TABLE USERWORKAUDITTABLE MODIFY (Userindex INT)';	
			EXECUTE IMMEDIATE 'ALTER TABLE USERWORKAUDITTABLE MODIFY (Auditoruserindex INT)';	
			/*DBMS_OUTPUT.PUT_LINE('Column Types modified successfully in USERWORKAUDITTABLE');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Column Types modified successfully in USERWORKAUDITTABLE'')';
			EXECUTE IMMEDIATE 'ALTER TABLE PREFERREDQUEUETABLE MODIFY (userindex INT)';	
			/*DBMS_OUTPUT.PUT_LINE('Column Types modified successfully in PREFERREDQUEUETABLE');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Column Types modified successfully in PREFERREDQUEUETABLE'')';
			EXECUTE IMMEDIATE 'ALTER TABLE USERPREFERENCESTABLE MODIFY (userid INT)';	
			/*DBMS_OUTPUT.PUT_LINE('Column Types modified successfully in USERPREFERENCESTABLE');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Column Types modified successfully in USERPREFERENCESTABLE'')';
			EXECUTE IMMEDIATE 'ALTER TABLE WFREMINDERTABLE MODIFY (ToIndex INT)';	
			EXECUTE IMMEDIATE 'ALTER TABLE WFREMINDERTABLE MODIFY (SetByUser INT)';	
			/*DBMS_OUTPUT.PUT_LINE('Column Types modified successfully in WFREMINDERTABLE');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Column Types modified successfully in WFREMINDERTABLE'')';
			EXECUTE IMMEDIATE 'ALTER TABLE USERQUEUETABLE MODIFY (UserID INT )';	
			/*DBMS_OUTPUT.PUT_LINE('Column Types modified successfully in USERQUEUETABLE');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Column Types modified successfully in USERQUEUETABLE'')';
			EXECUTE IMMEDIATE 'ALTER TABLE EXCEPTIONTABLE MODIFY (UserID INT )';	
			/*DBMS_OUTPUT.PUT_LINE('Column Types modified successfully in EXCEPTIONTABLE');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Column Types modified successfully in EXCEPTIONTABLE'')';
			EXECUTE IMMEDIATE 'ALTER TABLE EXCEPTIONHISTORYTABLE MODIFY (UserID INT )';	
			/*DBMS_OUTPUT.PUT_LINE('Column Types modified successfully in EXCEPTIONHISTORYTABLE');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Column Types modified successfully in EXCEPTIONHISTORYTABLE'')';
			EXECUTE IMMEDIATE 'ALTER TABLE WFHistoryRouteLogTable MODIFY (UserID INT )';	
			/*DBMS_OUTPUT.PUT_LINE('Column Types modified successfully in WFHistoryRouteLogTable');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Column Types modified successfully in WFHistoryRouteLogTable'')';
			EXECUTE IMMEDIATE 'ALTER TABLE WFHistoryRouteLogTable MODIFY (UserID INT )';	
			/*DBMS_OUTPUT.PUT_LINE('Column Types modified successfully in WFHistoryRouteLogTable');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Column Types modified successfully in WFHistoryRouteLogTable'')';
			EXECUTE IMMEDIATE 'ALTER TABLE WFAuthorizeQueueUserTable MODIFY (UserID INT )';	
			/*DBMS_OUTPUT.PUT_LINE('Column UserID modified successfully in WFAuthorizeQueueUserTable');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Column UserID modified successfully in WFAuthorizeQueueUserTable'')';
			EXECUTE IMMEDIATE 'ALTER TABLE TRIGGERTYPEDEFTABLE MODIFY (ClassName NVARCHAR2(255) )';	
			/*DBMS_OUTPUT.PUT_LINE('Column ClassName modified successfully in TRIGGERTYPEDEFTABLE');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Column ClassName modified successfully in TRIGGERTYPEDEFTABLE'')';
			EXECUTE IMMEDIATE 'ALTER TABLE RuleConditionTable MODIFY (Param1 NVARCHAR2(255))';	
			/*DBMS_OUTPUT.PUT_LINE('Column Param1 modified successfully in RuleConditionTable');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Column Param1 modified successfully in RuleConditionTable'')';
			EXECUTE IMMEDIATE 'ALTER TABLE RULEOPERATIONTABLE MODIFY (Param1 NVARCHAR2(255))';	
			/*DBMS_OUTPUT.PUT_LINE('Column Param1 modified successfully in RULEOPERATIONTABLE');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Column Param1 modified successfully in RULEOPERATIONTABLE'')';
			EXECUTE IMMEDIATE 'ALTER TABLE MAILTRIGGERTABLE MODIFY (ExtObjIdMailPriority NUMBER(*,0))';	
			/*DBMS_OUTPUT.PUT_LINE('Column ExtObjIdMailPriority modified successfully in MAILTRIGGERTABLE');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Column ExtObjIdMailPriority modified successfully in MAILTRIGGERTABLE'')';
			EXECUTE IMMEDIATE 'ALTER TABLE MAILTRIGGERTABLE MODIFY (VariableIdMailPriority NUMBER(*,0))';	
			/*DBMS_OUTPUT.PUT_LINE('Column VariableIdMailPriority modified successfully in MAILTRIGGERTABLE');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Column VariableIdMailPriority modified successfully in MAILTRIGGERTABLE'')';
			EXECUTE IMMEDIATE 'ALTER TABLE MAILTRIGGERTABLE MODIFY (VarFieldIdMailPriority NUMBER(*,0))';	
			/*DBMS_OUTPUT.PUT_LINE('Column VarFieldIdMailPriority modified successfully in MAILTRIGGERTABLE');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Column VarFieldIdMailPriority modified successfully in MAILTRIGGERTABLE'')';
			EXECUTE IMMEDIATE 'UPDATE MAILTRIGGERTABLE SET ExtObjIdMailPriority = 0 where ExtObjIdMailPriority is NULL';	
			/*DBMS_OUTPUT.PUT_LINE('update ExtObjIdMailPriority modified successfully in MAILTRIGGERTABLE');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''update ExtObjIdMailPriority modified successfully in MAILTRIGGERTABLE'')';
			EXECUTE IMMEDIATE 'UPDATE MAILTRIGGERTABLE SET VariableIdMailPriority = 0 where VariableIdMailPriority is NULL';	
			/*DBMS_OUTPUT.PUT_LINE('update VariableIdMailPriority modified successfully in MAILTRIGGERTABLE');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''update VariableIdMailPriority modified successfully in MAILTRIGGERTABLE'')';
			EXECUTE IMMEDIATE 'UPDATE MAILTRIGGERTABLE SET VarFieldIdMailPriority = 0 where VarFieldIdMailPriority is NULL';	
			/*DBMS_OUTPUT.PUT_LINE('update VarFieldIdMailPriority modified successfully in MAILTRIGGERTABLE');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''update VarFieldIdMailPriority modified successfully in MAILTRIGGERTABLE'')';
			EXECUTE IMMEDIATE 'ALTER TABLE DATASETTRIGGERTABLE MODIFY (Param1 NVARCHAR2(255))';	
			/*DBMS_OUTPUT.PUT_LINE('Column Param1 modified successfully in DATASETTRIGGERTABLE');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Column Param1 modified successfully in DATASETTRIGGERTABLE'')';
			EXECUTE IMMEDIATE 'ALTER TABLE ACTIONCONDITIONTABLE MODIFY (Param1 NVARCHAR2(255))';	
			/*DBMS_OUTPUT.PUT_LINE('Column Param1 modified successfully in ACTIONCONDITIONTABLE');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Column Param1 modified successfully in ACTIONCONDITIONTABLE'')';
			EXECUTE IMMEDIATE 'ALTER TABLE ACTIONOPERATIONTABLE MODIFY (Param1 NVARCHAR2(255))';	
			/*DBMS_OUTPUT.PUT_LINE('Column Param1 modified successfully in ACTIONOPERATIONTABLE');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Column Param1 modified successfully in ACTIONOPERATIONTABLE'')';
			EXECUTE IMMEDIATE 'ALTER TABLE SCANACTIONSTABLE MODIFY (Param1 NVARCHAR2(255))';	
			/*DBMS_OUTPUT.PUT_LINE('Column Param1 modified successfully in SCANACTIONSTABLE');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Column Param1 modified successfully in SCANACTIONSTABLE'')';
			EXECUTE IMMEDIATE 'ALTER TABLE TEMPLATEDEFINITIONTABLE modify Format NVARCHAR2(255) DEFAULT NULL';	
			/*DBMS_OUTPUT.PUT_LINE('Column Format modified successfully in TEMPLATEDEFINITIONTABLE');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Column Format modified successfully in TEMPLATEDEFINITIONTABLE'')';
			/*added by rishi -- start here*/
			EXECUTE IMMEDIATE('Alter Table WFMultiLingualTable modify Locale NVARCHAR2(100)');
			/*dbms_output.put_line ('Alter Table WFMultiLingualTable modify Locale NVARCHAR2(100)');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Alter Table WFMultiLingualTable modify Locale NVARCHAR2(100)'')';
			EXECUTE IMMEDIATE('Alter Table WFMultiLingualTable modify FieldName	NVarchar2(255)');
			/*dbms_output.put_line ('Alter Table WFMultiLingualTable modify FieldName	NVarchar2(255)');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Alter Table WFMultiLingualTable modify FieldName	NVarchar2(255)'')';
			EXECUTE IMMEDIATE('Alter Table WFExtInterfaceConditionTable modify Param1 NVARCHAR2(255)');
	        /*dbms_output.put_line ('Alter Table WFExtInterfaceConditionTable modify Param1	NVARCHAR2(255)');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Alter Table WFExtInterfaceConditionTable modify Param1	NVARCHAR2(255)'')';
			EXECUTE IMMEDIATE('ALTER TABLE PRINTFAXEMAILTABLE  modify EXTBCCMAILID  INT Default null');
			/*dbms_output.put_line ('ALTER TABLE PRINTFAXEMAILTABLE  modify EXTBCCMAILID  INT Default null');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE PRINTFAXEMAILTABLE  modify EXTBCCMAILID  INT Default null'')';
			EXECUTE IMMEDIATE('ALTER TABLE PRINTFAXEMAILTABLE  modify BCCMAILIDTYPE 	NVARCHAR2(1) default 	NULL');
			/*dbms_output.put_line ('ALTER TABLE PRINTFAXEMAILTABLE  modify BCCMAILIDTYPE 	NVARCHAR2(1) default 	NULL');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE PRINTFAXEMAILTABLE  modify BCCMAILIDTYPE 	NVARCHAR2(1) default 	NULL'')';
			EXECUTE IMMEDIATE('ALTER TABLE PRINTFAXEMAILTABLE  modify VARIABLEIDBCC INT default 	NULL');
			/*dbms_output.put_line ('ALTER TABLE PRINTFAXEMAILTABLE  modify VARIABLEIDBCC INT default 	NULL');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE PRINTFAXEMAILTABLE  modify VARIABLEIDBCC INT default 	NULL'')';
			EXECUTE IMMEDIATE('ALTER TABLE PRINTFAXEMAILTABLE  modify VARFIELDIDBCC INT default 	NULL');
			/*dbms_output.put_line ('ALTER TABLE PRINTFAXEMAILTABLE modify VARFIELDIDBCC 	INT  default 	NULL');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE PRINTFAXEMAILTABLE modify VARFIELDIDBCC 	INT  default 	NULL'')';
			EXECUTE IMMEDIATE('ALTER TABLE PRINTFAXEMAILTABLE  modify MailPriority 	NVARCHAR2(255) default 	NULL');
			/*dbms_output.put_line ('ALTER TABLE PRINTFAXEMAILTABLE modify MailPriority 	NVARCHAR2(255) default 	NULL');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE PRINTFAXEMAILTABLE modify MailPriority 	NVARCHAR2(255) default 	NULL'')';
			EXECUTE IMMEDIATE('ALTER TABLE PRINTFAXEMAILTABLE  modify MailPriorityType 	NVARCHAR2(255) default 	NULL');
			/*dbms_output.put_line ('ALTER TABLE PRINTFAXEMAILTABLE modify MailPriorityType 	NVARCHAR2(255) default 	NULL');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE PRINTFAXEMAILTABLE modify MailPriorityType 	NVARCHAR2(255) default 	NULL'')';
			EXECUTE IMMEDIATE('ALTER TABLE PRINTFAXEMAILTABLE  modify ExtObjIdMailPriority 	NUMBER(*,0) default 	NULL');
			/*dbms_output.put_line ('ALTER TABLE PRINTFAXEMAILTABLE modify ExtObjIdMailPriority 	NUMBER(*,0) default 	NULL');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE PRINTFAXEMAILTABLE modify ExtObjIdMailPriority 	NUMBER(*,0) default 	NULL'')';
			EXECUTE IMMEDIATE('ALTER TABLE PRINTFAXEMAILTABLE  modify VariableIdMailPriority 	NUMBER(*,0) default 	NULL');
			/*dbms_output.put_line ('ALTER TABLE PRINTFAXEMAILTABLE modify VariableIdMailPriority 	NUMBER(*,0) default 	NULL');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE PRINTFAXEMAILTABLE modify VariableIdMailPriority 	NUMBER(*,0) default 	NULL'')';
			EXECUTE IMMEDIATE('ALTER TABLE PRINTFAXEMAILTABLE  modify VarFieldIdMailPriority 	NUMBER(*,0) default 	NULL');
			/*dbms_output.put_line ('ALTER TABLE PRINTFAXEMAILTABLE modify VarFieldIdMailPriority 	NUMBER(*,0) default 	NULL');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE PRINTFAXEMAILTABLE modify VarFieldIdMailPriority 	NUMBER(*,0) default 	NULL'')';
			EXECUTE IMMEDIATE('ALTER TABLE WFMAILQUEUETABLE  modify mailTo 	NVARCHAR2(512)');
			/*dbms_output.put_line ('ALTER TABLE WFMAILQUEUETABLE  modify mailTo 	NVARCHAR2(512)');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFMAILQUEUETABLE  modify mailTo 	NVARCHAR2(512)'')';
			EXECUTE IMMEDIATE('ALTER TABLE WFMAILQUEUETABLE modify mailCC 	NVARCHAR2(512)');
			/*dbms_output.put_line ('ALTER TABLE WFMAILQUEUETABLE modify mailCC 	NVARCHAR2(512)');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFMAILQUEUETABLE modify mailCC 	NVARCHAR2(512)'')';
			/*added by rishi -- end here*/
			EXECUTE IMMEDIATE'Insert into WFCabVersionTable(cabVersion,cabVersionId,creationDate,lastModified,Remarks,Status) values(N''iBPS_3.0'', cabVersionId.nextVal ,SysDate, SysDate, N''Cabinet Upgraded to iBPS 3.0 Version'', N''Y'')';
	
	END;
	
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME = UPPER('WFSystemServicesTable') 
		AND 
		COLUMN_NAME = UPPER('AppServerId');
		
		EXECUTE IMMEDIATE 'ALTER TABLE WFSystemServicesTable DROP COLUMN AppServerId';	
		EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFMAILQUEUETABLE modify mailCC 	NVARCHAR2(512)'')';
    EXCEPTION
		WHEN NO_DATA_FOUND THEN
     		DBMS_OUTPUT.PUT_LINE('Column AppServerId not exist');
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFMAILQUEUETABLE modify mailCC 	NVARCHAR2(512)'')';
	END;
	
	BEGIN
		SELECT 1 INTO v_existsFlag 
		FROM USER_INDEXES
		WHERE INDEX_NAME = UPPER('IDX1_WFDataMapTable');
		    /*DBMS_OUTPUT.PUT_LINE('BEFORE DROP Index IDX1_WFDataMapTable');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''BEFORE DROP Index IDX1_WFDataMapTable'')';
			EXECUTE IMMEDIATE 'DROP Index IDX1_WFDataMapTable';
			/*DBMS_OUTPUT.PUT_LINE('DROP Index IDX1_WFDataMapTable');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''DROP Index IDX1_WFDataMapTable'')';
			EXECUTE IMMEDIATE 'UPDATE WFDataMapTable SET ProcessDefId = 0 where ProcessDefId is NULL';
			/*DBMS_OUTPUT.PUT_LINE('Column ProcessDefId value updated of WFDataMapTable');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Column ProcessDefId value updated of WFDataMapTable'')';
			EXECUTE IMMEDIATE 'UPDATE WFDataMapTable SET ActivityId = 0 where ActivityId is NULL';
			/*DBMS_OUTPUT.PUT_LINE('Column ActivityId value updated of WFDataMapTable');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Column ActivityId value updated of WFDataMapTable'')';
			EXECUTE IMMEDIATE 'UPDATE WFDataMapTable SET OrderId = 0 where OrderId is NULL';
			/*DBMS_OUTPUT.PUT_LINE('Column OrderId value updated of WFDataMapTable');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Column OrderId value updated of WFDataMapTable'')';
			EXECUTE IMMEDIATE 'CREATE INDEX IDX1_WFDataMapTable ON WFDataMapTable (ProcessDefId, ActivityId)';
			/*DBMS_OUTPUT.PUT_LINE('CREATE INDEX IDX1_WFDataMapTable ON WFDataMapTable');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE INDEX IDX1_WFDataMapTable ON WFDataMapTable'')';
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN
				/*dbms_output.put_line ('INDEX IDX1_WFDataMapTable doesnot exist...');*/
				EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''INDEX IDX1_WFDataMapTable doesnot exist...'')';
				EXECUTE IMMEDIATE 'UPDATE WFDataMapTable SET ProcessDefId = 0 where ProcessDefId is NULL';
				/*DBMS_OUTPUT.PUT_LINE('Column ProcessDefId value updated of WFDataMapTable');*/
				EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Column ProcessDefId value updated of WFDataMapTable'')';
				EXECUTE IMMEDIATE 'UPDATE WFDataMapTable SET ActivityId = 0 where ActivityId is NULL';
				/*DBMS_OUTPUT.PUT_LINE('Column ActivityId value updated of WFDataMapTable');*/
				EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Column ActivityId value updated of WFDataMapTable'')';
				EXECUTE IMMEDIATE 'UPDATE WFDataMapTable SET OrderId = 0 where OrderId is NULL';
				/*DBMS_OUTPUT.PUT_LINE('Column OrderId value updated of WFDataMapTable');*/
				EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Column OrderId value updated of WFDataMapTable'')';
				EXECUTE IMMEDIATE 'CREATE INDEX IDX1_WFDataMapTable ON WFDataMapTable (ProcessDefId, ActivityId)';
				/*DBMS_OUTPUT.PUT_LINE('CREATE INDEX IDX1_WFDataMapTable ON WFDataMapTable');*/
				EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE INDEX IDX1_WFDataMapTable ON WFDataMapTable'')';
	END;
		
	BEGIN
		SELECT 1 INTO v_existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME=UPPER('VARALIASTABLE') 
		AND 
		COLUMN_NAME=UPPER('Type1')
		AND
		DATA_TYPE=UPPER('NUMBER');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
		EXECUTE IMMEDIATE 'ALTER TABLE VARALIASTABLE Add (TempType1 SMALLINT)';	
		/*DBMS_OUTPUT.PUT_LINE('ALTER TABLE VARALIASTABLE Add (TempType1 SMALLINT)');	*/
        EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE VARALIASTABLE Add (TempType1 SMALLINT)'')';		
		EXECUTE IMMEDIATE 'UPDATE VARALIASTABLE SET TempType1 = Type1';		
		/*DBMS_OUTPUT.PUT_LINE('UPDATE VARALIASTABLE SET TempType1 = Type1');	*/
        EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''UPDATE VARALIASTABLE SET TempType1 = Type1'')';		
		EXECUTE IMMEDIATE 'ALTER TABLE VARALIASTABLE DROP COLUMN Type1 ';	
		/*DBMS_OUTPUT.PUT_LINE('ALTER TABLE VARALIASTABLE DROP COLUMN Type1');*/
        EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE VARALIASTABLE DROP COLUMN Type1'')';		
		EXECUTE IMMEDIATE 'ALTER TABLE VARALIASTABLE RENAME COLUMN TempType1 to Type1 ';			
		/*DBMS_OUTPUT.PUT_LINE('ALTER TABLE VARALIASTABLE RENAME COLUMN TempType1 to Type1');*/
		EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE VARALIASTABLE RENAME COLUMN TempType1 to Type1'')';
	    EXECUTE IMMEDIATE 'UPDATE VARALIASTABLE SET Type1 = '' '' WHERE Type1 is NULL ';
	END;
	
	BEGIN
		SELECT 1 INTO v_existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME=UPPER('ACTIVITYTABLE') 
		AND 
		COLUMN_NAME=UPPER('Description')
		AND
		DATA_TYPE=UPPER('NCLOB');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
		EXECUTE IMMEDIATE 'ALTER TABLE ACTIVITYTABLE Add (TempDescription NCLOB)';			
		EXECUTE IMMEDIATE 'UPDATE ACTIVITYTABLE SET TempDescription = Description';			
		EXECUTE IMMEDIATE 'ALTER TABLE ACTIVITYTABLE DROP COLUMN Description ';			
		EXECUTE IMMEDIATE 'ALTER TABLE ACTIVITYTABLE RENAME COLUMN tempDescription to Description ';			
		/*DBMS_OUTPUT.PUT_LINE('Column Type modified successfully in ACTIVITYTABLE');*/
		EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Column Type modified successfully in ACTIVITYTABLE'')';
	    EXECUTE IMMEDIATE 'UPDATE ACTIVITYTABLE SET DESCRIPTION = '' '' WHERE DESCRIPTION is NULL ';
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
			CLOSE CursorExtObjId; 
		END LOOP;
    CLOSE CursorObjTable; 
	END;
	
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
			v_STR1:= 'SELECT ProcessName,ProcessDefId  from PROCESSDEFTABLE order by ProcessName asc,ProcessDefId asc';
			DBMS_OUTPUT.PUT_LINE('Enterr KKKKKK v_STR1  '||v_STR1);
			OPEN cur_QueueDef FOR v_STR1;
            v_PrevProcName :=' ';	
		LOOP	
			FETCH cur_QueueDef into v_ProcessName,v_ProcessDefId;
			EXIT WHEN cur_QueueDef%NOTFOUND;
				BEGIN
				    /*DBMS_OUTPUT.PUT_LINE('Enterr 11111  ');*/
					EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Enterr 11111 '')';
					v_QueueName := v_ProcessName||'_SwimLane_1';  
			        DBMS_OUTPUT.PUT_LINE('Enterr 22222  '||v_ProcessName);
					DBMS_OUTPUT.PUT_LINE('Enterr 33333  '||v_QueueName);
					EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Enterr 22222  '')';
					EXECUTE IMMEDIATE 'Select Count(*) from WFLaneQueueTable where processdefid = '||TO_CHAR(v_ProcessdefId) into existsFlag;
					DBMS_OUTPUT.PUT_LINE('Enterr 44444  '||existsFlag);
					If existsFlag = 0 THEN 
					    if(v_PrevProcName !=v_ProcessName) THEN
							DBMS_OUTPUT.PUT_LINE('Enterr 5555 ');
							/* merging code from mssql for upgrade fix (ibps 5.0)*/
							
							v_swimlaneQueueId := -1;
							BEGIN
								EXECUTE IMMEDIATE 'Select QueueID FROM QueueDefTable WHERE UPPER(QueueName) = UPPER('''||v_QueueName||''')' into v_swimlaneQueueId;
							EXCEPTION
								WHEN NO_DATA_FOUND THEN
									v_swimlaneQueueId := -1;
							END;
							
							if v_swimlaneQueueId = -1 THEN
								EXECUTE IMMEDIATE 'Insert into QueueDefTable (QueueId, QueueName, QueueType, Comments, OrderBy, SortOrder) values 
								(QUEUEID.nextval,'''||TO_CHAR(v_QueueName)||''', N''F'', N''Process Modeler generated Default Swimlane Queue'', 10, N''A'')';
								/*DBMS_OUTPUT.PUT_LINE('Insertion done in QueueDefTable');*/
								EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Insertion done in QueueDefTable'')';
								
								EXECUTE IMMEDIATE 'Insert into WFLaneQueueTable(ProcessDefId,SwimLaneId,QueueID,DefaultQueue) Values ('||TO_CHAR(v_ProcessDefId)||',1,QUEUEID.currval,''N'')';
							Else
								EXECUTE IMMEDIATE 'Insert into WFLaneQueueTable(ProcessDefId,SwimLaneId,QueueID,DefaultQueue) Values ('||TO_CHAR(v_ProcessDefId)||',1,'|| to_char(v_swimlaneQueueId)||',''N'')';
							END IF;
							
						End If;
						v_PrevProcName := v_ProcessName;
						
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
			   /*DBMS_OUTPUT.PUT_LINE('Table VarAliasTable altered with new Column VariableId1');*/
			   EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Table VarAliasTable altered with new Column VariableId1'')';
				
			 DECLARE CURSOR cursor2 IS SELECT DISTINCT PARAM1, VariableId, VariableType FROM VARMAPPINGTABLE  A, VARALIASTABLE B WHERE A.SYSTEMDEFINEDNAME = B.PARAM1 AND A.ProcessDefId = (select max(ProcessDefId) from ProcessDefTable);            
			 BEGIN                    
				OPEN cursor2;
					EXECUTE IMMEDIATE 'CREATE INDEX TEMPIDX1_VarAliasTable ON VarAliasTable (Param1)';    
				LOOP
						FETCH cursor2 INTO v_param1, v_VariableId, v_variableType;
						EXIT WHEN cursor2%NOTFOUND;            
					BEGIN
						v_STR1 := ' Update VarAliasTable Set VariableId1 = ' || (100 + v_VariableId) || ' , Type1 = ' || v_variableType || ' Where Param1 = ''' || TO_CHAR(v_param1) || '''';
						SAVEPOINT exttable_alias;
						EXECUTE IMMEDIATE v_STR1;            
					END;
						COMMIT;
				END LOOP;
					EXECUTE IMMEDIATE 'DROP INDEX TEMPIDX1_VarAliasTable';            
				CLOSE cursor2;            
			END;            
	END;    
   

    
	BEGIN
			SELECT 1 INTO existsFlag FROM USER_TAB_COLUMNS WHERE Upper(TABLE_NAME) = 'WFSAPGUIASSOCTABLE' AND Upper(COLUMN_NAME) = 'CONFIGURATIONID';
			EXCEPTION
			WHEN NO_DATA_FOUND THEN
				EXECUTE IMMEDIATE 'ALTER TABLE WFSAPGUIAssocTable Add ConfigurationID INTEGER';
				/*DBMS_OUTPUT.PUT_LINE('Table WFSAPGUIAssocTable altered with new Column ConfigurationID');*/
				EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Table WFSAPGUIAssocTable altered with new Column ConfigurationID'')';
	END;
	
	BEGIN
		SELECT CabVersion INTO v_cabVersion FROM WFCABVERSIONTABLE WHERE CabVersion = '9.0_SAP_CONFIGURATION';
		EXCEPTION 
		WHEN NO_DATA_FOUND THEN
        BEGIN
            EXECUTE IMMEDIATE 'Update WFSAPConnectTable Set RFCHostName = SAPHostName, ConfigurationName = ''DEFAULT''';  
            v_ConfigurationId:= 0;
            v_STR1:= ' SELECT ProcessDefId FROM WFSAPConnectTable';
            Open cursor2 FOR v_STR1;
            LOOP
                FETCH cursor2 INTO v_ProcessDefId;
                EXIT WHEN cursor2%NOTFOUND;
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
            CLOSE cursor2;
			
        END;
        EXECUTE IMMEDIATE 'INSERT INTO WFCabVersionTable(cabVersion, cabVersionId, creationDate, lastModified, Remarks, Status) VALUES (N''9.0_SAP_CONFIGURATION'', cabVersionId.nextVal, SYSDATE, SYSDATE, N''OmniFlow 9.0'', N''Y'')';    
	END;
/* END Upgrading Script for SAP and EXTMETHODDETABLE(for configid) and VarAliasTable(VariableId1)*/	 
 /* Changes made for the introduction of process variant*/
	
	
	BEGIN
		SELECT LAST_NUMBER INTO v_lastSeqValue
		FROM USER_SEQUENCES
		WHERE SEQUENCE_NAME = UPPER('ProcessVariantId');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'CREATE SEQUENCE ProcessVariantId INCREMENT BY 1 START WITH 1';
			/*dbms_output.put_line ('SEQUENCE ProcessVariantId Successfully Created');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''SEQUENCE ProcessVariantId Successfully Created'')';
	END;
	
	BEGIN
		SELECT LAST_NUMBER INTO v_lastSeqValue
		FROM USER_SEQUENCES
		WHERE SEQUENCE_NAME = UPPER('FormExtId');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'CREATE SEQUENCE FormExtId INCREMENT BY 1 START WITH 1';
			/*dbms_output.put_line ('SEQUENCE FormExtId Successfully Created');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''SEQUENCE FormExtId Successfully Created'')';
	END;
	
	BEGIN
	v_STR1 := 'CREATE OR REPLACE VIEW QUEUETABLE 
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
		 var_float1, var_float2, var_date1, var_date2, var_date3, var_date4, 
		 var_long1, var_long2, var_long3, var_long4, 
		 var_str1, var_str2, var_str3, var_str4, var_str5, var_str6, var_str7, var_str8,
		 var_rec_1, var_rec_2, var_rec_3, var_rec_4, var_rec_5,	
		 q_streamid, q_queueid, q_userid, LastProcessedBy, processedby, referredto,
		 referredtoname, referredby, referredbyname, collectflag, NULL AS CompletionDateTime, CalendarName, ProcessVariantId
	     FROM	WFINSTRUMENTTABLE';

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
	
	/*Added by server team -- start here*/
	/*BEGIN
		EXECUTE IMMEDIATE ('CREATE OR REPLACE VIEW WFSEARCHVIEW_0 AS 
							SELECT queueview.ProcessInstanceId,queueview.QueueName,
							queueview.ProcessName,ProcessVersion,queueview.ActivityName, 
							statename,queueview.CheckListCompleteFlag,
							queueview.AssignedUser,queueview.EntryDateTime,
							queueview.ValidTill,queueview.workitemid,
							queueview.prioritylevel, queueview.parentworkitemid,
							queueview.processdefid,queueview.ActivityId,queueview.InstrumentStatus,
							queueview.LockStatus,queueview.LockedByName,
							queueview.CreatedByName,queueview.CreatedDateTime, 
							queueview.LockedTime, queueview.IntroductionDateTime,
							queueview.IntroducedBy ,queueview.assignmenttype, 
							queueview.processinstancestate, queueview.queuetype ,
							Status ,Q_QueueId ,
							(ExpectedWorkItemDelayTime - entrydatetime)*24  AS TurnaroundTime, 
							ReferredBy , ReferredTo ,ExpectedProcessDelayTime , 
							ExpectedWorkItemDelayTime,  ProcessedBy ,  Q_UserID , WorkItemState 
							FROM   queueview ');
		/*dbms_output.put_line ('VIEW WFSEARCHVIEW_0 Successfully modified ');*/
		/*EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''VIEW WFSEARCHVIEW_0 Successfully modified '')';
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN
				/*dbms_output.put_line ('Modifying VIEW WFSEARCHVIEW_0 failed');*/
				/*EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Modifying VIEW WFSEARCHVIEW_0 failed'')';
	END;*/
	
	BEGIN
		SELECT 1 INTO v_existsFlag 
		FROM WFSYSTEMPROPERTIESTABLE
		WHERE PROPERTYKEY = 'AUTHORIZATIONFLAG';
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN
				EXECUTE IMMEDIATE('INSERT  INTO WFSYSTEMPROPERTIESTABLE(PROPERTYKEY, PROPERTYVALUE) values(''AUTHORIZATIONFLAG'',''N'')');
		    	/*dbms_output.put_line (' AUTHORIZATIONFLAG column inserted successfully in  WFSYSTEMPROPERTIESTABLE');*/
				EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''AUTHORIZATIONFLAG column inserted successfully in  WFSYSTEMPROPERTIESTABLE'')';
	END;
	/*BEGIN
		SELECT 1 INTO v_existsFlag 
		FROM WFUserSkillCategoryTable
		WHERE CategoryName = 'Default';
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN
				EXECUTE IMMEDIATE('INSERT  INTO WFUserSkillCategoryTable(Categoryid, CategoryName,CategoryDefinedBy,CategoryAvailableForRating) values(1,''Default'',1,''N'')');*/
				/*dbms_output.put_line (' Default column inserted successfully in  WFUserSkillCategoryTable');*/
				/*EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Default column inserted successfully in  WFUserSkillCategoryTable'')';
	END;*/
	BEGIN
		SELECT 1 INTO v_existsFlag 
		FROM TAB
		WHERE TNAME = UPPER('WFCOMMENTS_USER_CONSTRAINTS') ;
		EXCEPTION
		WHEN NO_DATA_FOUND THEN
		v_existsFlag := 0;
	END;
  
	BEGIN
		SAVEPOINT ModifyCheckConstraint;
		--v_IsConstraintUpdated := 0;
		--v_SearchConditionOld := 'CommentsType IN (1, 2, 3,4)';
		--v_SearchConditionNew := 'CommentsType IN (1, 2, 3, 4,5)';
		
		IF (v_existsFlag = 1) THEN
		BEGIN
		  EXECUTE IMMEDIATE  'DROP table WFCOMMENTS_USER_CONSTRAINTS';
		  EXECUTE IMMEDIATE  'CREATE table WFCOMMENTS_USER_CONSTRAINTS as
		  select constraint_name, to_lob(search_condition) search_condition_vc from user_constraints WHERE table_name = UPPER(''WFCommentsTable'') AND constraint_type = ''C''';
		END;
		ELSE
		BEGIN
        EXECUTE IMMEDIATE  'CREATE table WFCOMMENTS_USER_CONSTRAINTS as
        select constraint_name, to_lob(search_condition) search_condition_vc from user_constraints WHERE table_name = UPPER(''WFCommentsTable'') AND constraint_type = ''C''';
		END;
		END IF;
		v_STR1:= 'SELECT constraint_name,search_condition_vc FROM WFCOMMENTS_USER_CONSTRAINTS WHERE Upper(Search_condition_Vc) LIKE ''COMMENTSTYPE%'''; 
		BEGIN
				OPEN Cursor1 FOR v_STR1;
				LOOP
					FETCH Cursor1 INTO v_constraintName, v_SearchCondition;
					EXIT WHEN Cursor1%NOTFOUND;
					IF v_SearchCondition IS NOT NULL THEN
						EXECUTE IMMEDIATE 'ALTER TABLE WFCommentsTable DROP CONSTRAINT ' || v_constraintName;
					END IF;
				END LOOP;
				CLOSE Cursor1;
			END;
			EXECUTE IMMEDIATE 'ALTER TABLE WFCommentsTable ADD CHECK(CommentsType IN (1,2,3,4,5,6,7,8,9,10))';
		EXCEPTION
		WHEN OTHERS THEN
		ROLLBACK TO SAVEPOINT ModifyCheckConstraint;
		CLOSE Cursor1;
		raise_application_error(-20364, 'Modifying the Check contraint on WFCommentsTable Failed.');
		RETURN;
	END;
	
	BEGIN
		SAVEPOINT ModifyCheckConstraint;
		v_IsConstraintUpdated := 0;
		v_SearchConditionOld := 'Type = N''C'' OR Type = N''S'' ';
		v_SearchConditionNew := 'Type = N''C'' OR Type = N''S'' OR  Type = N''R''';
		DECLARE CURSOR Cursor1 IS SELECT constraint_name, search_condition FROM user_constraints WHERE table_name = UPPER('WFActionStatusTable') AND constraint_type = 'C';
		BEGIN
			OPEN Cursor1;
			LOOP
				FETCH Cursor1 INTO v_constraintName, v_SearchCondition;
				EXIT WHEN Cursor1%NOTFOUND;
				IF v_SearchCondition IS NOT NULL THEN
					IF UPPER(v_SearchCondition) = UPPER(v_SearchConditionOld) THEN
						EXECUTE IMMEDIATE 'ALTER TABLE WFActionStatusTable DROP CONSTRAINT ' || v_constraintName;
					END IF;
					IF UPPER(v_SearchCondition) = UPPER(v_SearchConditionNew) THEN
						v_IsConstraintUpdated := 1;
					END IF;
				END IF;
			END LOOP;
			CLOSE Cursor1;
		END;
		IF v_IsConstraintUpdated = 0 THEN
			EXECUTE IMMEDIATE 'ALTER TABLE WFActionStatusTable ADD CHECK(Type = N''C'' OR Type = N''S'' OR  Type = N''R'')';
		END IF;
	EXCEPTION
		WHEN OTHERS THEN
		ROLLBACK TO SAVEPOINT ModifyCheckConstraint;
		CLOSE Cursor1;
		raise_application_error(-20364, 'Modifying the Check contraint on WFActionStatusTable Failed.');
		RETURN;
	END;
	
	BEGIN
		SAVEPOINT ModifyCheckConstraint;
		v_IsConstraintUpdated := 0;
		v_SearchConditionOld := 'status IN (''N'',''L'')';
		v_SearchConditionNew := 'status IN (''N'',''F'')';
		DECLARE CURSOR Cursor1 IS SELECT constraint_name, search_condition FROM user_constraints WHERE table_name = UPPER('WFMESSAGETABLE') AND constraint_type = 'C';
		BEGIN
			OPEN Cursor1;
			LOOP
				FETCH Cursor1 INTO v_constraintName, v_SearchCondition;
				EXIT WHEN Cursor1%NOTFOUND;
				IF v_SearchCondition IS NOT NULL THEN
					IF UPPER(v_SearchCondition) = UPPER(v_SearchConditionOld) THEN
						EXECUTE IMMEDIATE 'ALTER TABLE WFMESSAGETABLE DROP CONSTRAINT ' || v_constraintName;
					END IF;
					IF UPPER(v_SearchCondition) = UPPER(v_SearchConditionNew) THEN
						v_IsConstraintUpdated := 1;
					END IF;
				END IF;
			END LOOP;
			CLOSE Cursor1;
		END;
		IF v_IsConstraintUpdated = 0 THEN
			EXECUTE IMMEDIATE 'ALTER TABLE WFMESSAGETABLE ADD CHECK(status IN (''N'',''F''))';
		END IF;
	EXCEPTION
		WHEN OTHERS THEN
		ROLLBACK TO SAVEPOINT ModifyCheckConstraint;
		CLOSE Cursor1;
		raise_application_error(-20364, 'Modifying the Check contraint on WFMESSAGETABLE Failed.');
		RETURN;
	END;
	/*-----------------------------------------New Type Addition------------------------------------------------*/
	BEGIN   
		SELECT 1 INTO v_existsFlag 
		FROM user_types  
		WHERE UPPER(TYPE_NAME) = UPPER('Process_Variant_Type');  
	EXCEPTION 
	WHEN NO_DATA_FOUND THEN 
			EXECUTE IMMEDIATE
				'create TYPE Process_Variant_Type AS Object(ProcessDefId number(15), ProcessVariantId number(15))';
			/*dbms_output.put_line ('Type Process_Variant_Type  Created successfully');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Type Process_Variant_Type  Created successfully'')';
	END;
	
	BEGIN   
		SELECT 1 INTO v_existsFlag 
		FROM user_types  
		WHERE UPPER(TYPE_NAME) = UPPER('Process_Variant_Tab_Var');  
	EXCEPTION 
	WHEN NO_DATA_FOUND THEN 
			EXECUTE IMMEDIATE
				'create TYPE  Process_Variant_Tab_Var IS TABLE OF Process_Variant_Type';
			/*dbms_output.put_line ('Type Process_Variant_Tab_Var  Created successfully');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Type Process_Variant_Tab_Var  Created successfully'')';
	END;
	
	
    /*-----------------------------------------End Of New Type Addition----------------------------------------------*/
	
	BEGIN
		SELECT 1 INTO v_existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME=UPPER('WFLINKSTABLE') 
		AND 
		COLUMN_NAME=UPPER('IsParentArchived');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE('ALTER TABLE WFLINKSTABLE ADD IsParentArchived  NCHAR(1) DEFAULT ''N''');
			EXECUTE IMMEDIATE('ALTER TABLE WFLINKSTABLE ADD IsChildArchived NCHAR(1) DEFAULT ''N''');
			/*dbms_output.put_line ('WFLINKSTABLE Altered successfully');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''WFLINKSTABLE Altered successfully'')';
	END;
	BEGIN
		SELECT 1 INTO v_existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME=UPPER('WFTransportDataTable') 
		AND 
		COLUMN_NAME=UPPER('ObjectTypeId');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE('ALTER TABLE WFTransportDataTable ADD ObjectTypeId INT');
			/*dbms_output.put_line ('WFTransportDataTable Altered successfully');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''WFTransportDataTable Altered successfully'')';
	END;
	BEGIN
		SELECT 1 INTO v_existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME=UPPER('WFEscInProcessTable') 
		AND 
		COLUMN_NAME=UPPER('FrequencyDuration');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE('ALTER TABLE WFEscInProcessTable ADD FrequencyDuration Integer');
			EXECUTE IMMEDIATE('ALTER TABLE WFEscInProcessTable ADD Frequency Integer');
			/*dbms_output.put_line ('WFEscInProcessTable Altered successfully');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''WFEscInProcessTable Altered successfully'')';
	END;
	BEGIN
		SELECT 1 INTO v_existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME=UPPER('WFEscalationTable') 
		AND 
		COLUMN_NAME=UPPER('FrequencyDuration');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE('ALTER TABLE WFEscalationTable ADD FrequencyDuration Integer');
			EXECUTE IMMEDIATE('ALTER TABLE WFEscalationTable ADD Frequency Integer');
			/*dbms_output.put_line ('WFEscalationTable Altered successfully');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''WFEscalationTable Altered successfully'')';
	END;
	BEGIN
		SELECT 1 INTO v_existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME=UPPER('WFINSTRUMENTTABLE') 
		AND 
		COLUMN_NAME=UPPER('ActivityType');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE('ALTER TABLE WFINSTRUMENTTABLE ADD ActivityType	SMALLINT NULL');
			EXECUTE IMMEDIATE('MERGE INTO WFINSTRUMENTTABLE USING ( SELECT ProcessDefId,ActivityId,ActivityType FROM ActivityTable ) ta ON (ta.ProcessDefId = WFINSTRUMENTTABLE.ProcessDefId and ta.ActivityId = WFINSTRUMENTTABLE.ActivityId) WHEN MATCHED THEN UPDATE SET WFINSTRUMENTTABLE.ActivityType = ta.ActivityType');
			/*dbms_output.put_line ('WFINSTRUMENTTABLE Altered successfully');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''WFINSTRUMENTTABLE Altered successfully'')';
	END;
	BEGIN
		SELECT 1 INTO v_existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME=UPPER('WFINSTRUMENTTABLE') 
		AND 
		COLUMN_NAME=UPPER('lastModifiedTime');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE('ALTER TABLE WFINSTRUMENTTABLE ADD lastModifiedTime DATE NULL');
			EXECUTE IMMEDIATE('UPDATE  WFINSTRUMENTTABLE SET lastModifiedTime = SYSDATE ');
			/*dbms_output.put_line ('WFINSTRUMENTTABLE Altered successfully');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''WFINSTRUMENTTABLE Altered successfully'')';
	END;
	BEGIN
		SELECT 1 INTO v_existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME=UPPER('SUMMARYTABLE') 
		AND 
		COLUMN_NAME=UPPER('ProcessVariantId');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE('ALTER TABLE SUMMARYTABLE ADD ProcessVariantId INT DEFAULT(0) NOT NULL');
			/*dbms_output.put_line ('SUMMARYTABLE Altered successfully');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''SUMMARYTABLE Altered successfully'')';
	END;
	BEGIN
		SELECT 1 INTO v_existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME=UPPER('WFATTRIBUTEMESSAGETABLE') 
		AND 
		COLUMN_NAME=UPPER('ProcessVariantId');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE('ALTER TABLE WFATTRIBUTEMESSAGETABLE ADD ProcessVariantId 	INT DEFAULT(0)  NOT NULL');
			/*dbms_output.put_line ('WFATTRIBUTEMESSAGETABLE Altered successfully');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''WFATTRIBUTEMESSAGETABLE Altered successfully'')';
	END;
	BEGIN
		SELECT 1 INTO v_existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME=UPPER('WFCommentsTable') 
		AND 
		COLUMN_NAME=UPPER('ProcessVariantId');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE('ALTER TABLE WFCommentsTable ADD ProcessVariantId INT DEFAULT(0) NOT NULL');
			/*dbms_output.put_line ('WFCommentsTable Altered successfully');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''WFCommentsTable Altered successfully'')';
	END;
	BEGIN
		SELECT 1 INTO v_existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME=UPPER('WFREMINDERTABLE') 
		AND 
		COLUMN_NAME=UPPER('TaskId');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE('ALTER TABLE WFREMINDERTABLE ADD TaskId  INT   DEFAULT 0 NOT NULL');
			EXECUTE IMMEDIATE('ALTER TABLE WFREMINDERTABLE ADD SubTaskId  INT  DEFAULT 0 NOT NULL');
			/*dbms_output.put_line ('WFREMINDERTABLE Altered successfully');*/
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''WFREMINDERTABLE Altered successfully'')';
	END;
	
/*	BEGIN
		BEGIN
			SELECT 1 INTO v_existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('PRINTFAXEMAILTABLE') 
			AND 
			COLUMN_NAME=UPPER('CoverSheetBuffer')
			AND
			DATA_TYPE=UPPER('NCLOB');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
      
				EXECUTE IMMEDIATE 'CREATE TABLE PRINTFAXEMAILTABLE2 (
							ProcessDefId            INT			NOT NULL,
							PFEInterfaceId          INT			NOT NULL,
							InstrumentData          NVARCHAR2(1)    NULL,
							FitToPage               NVARCHAR2(1)    NULL,
							Annotations             NVARCHAR2(1)    NULL,
							FaxNo                   NVARCHAR2(255)  NULL,
							FaxNoType               NVARCHAR2(1)    NULL,
							ExtFaxNoId              INT				NULL,
							VariableIdFax			INT				NULL,
							VarFieldIdFax			INT				NULL,
							CoverSheet              NVARCHAR2(50)   NULL,
							CoverSheetBuffer        NCLOB			NULL,
							ToUser                  NVARCHAR2(255)  NULL,
							FromUser                NVARCHAR2(255)  NULL,
							ToMailId                NVARCHAR2(255)  NULL,
							ToMailIdType            NVARCHAR2(1)    NULL,
							ExtToMailId             INT				NULL,
							VariableIdTo			INT				NULL,
							VarFieldIdTo			INT				NULL,
							CCMailId                NVARCHAR2(255)  NULL,
							CCMailIdType            NVARCHAR2(1)    NULL,
							ExtCCMailId             INT				NULL,
							VariableIdCc			INT				NULL,
							VarFieldIdCc			INT				NULL,
							SenderMailId            NVARCHAR2(255)  NULL,
							SenderMailIdType        NVARCHAR2(1)    NULL,
							ExtSenderMailId         INT				NULL,
							VariableIdFrom			INT				NULL,
							VarFieldIdFrom			INT				NULL,
							Message                 NCLOB			NULL,
							Subject                 NVARCHAR2(255)  NULL,
							BCCMAILID 				NVARCHAR2(255)	NULL,
							BCCMAILIDTYPE 			NVARCHAR2(1)	NULL, 
							EXTBCCMAILID 			INT				NULL,
							VARIABLEIDBCC 			INT				NULL,
							VARFIELDIDBCC 			INT				NULL,
							MailPriority 			NVARCHAR2(255),
							MailPriorityType 		NVARCHAR2(255), 
							ExtObjIdMailPriority 	NUMBER(*,0), 
							VariableIdMailPriority 	NUMBER(*,0), 
							VarFieldIdMailPriority 	NUMBER(*,0),
							PRIMARY KEY(ProcessDefId,PFEInterfaceId)
						)'; 
						DBMS_OUTPUT.PUT_LINE ('Table PRINTFAXEMAILTABLE2 Successfully Created');
						EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Table PRINTFAXEMAILTABLE2 Successfully Created'')';
				SAVEPOINT save;
						EXECUTE IMMEDIATE 'INSERT INTO PRINTFAXEMAILTABLE2 SELECT ProcessDefId ,PFEInterfaceId      ,InstrumentData,FitToPage ,Annotations ,FaxNo ,
							FaxNoType,ExtFaxNoId ,VariableIdFax	,VarFieldIdFax,CoverSheet,blob_to_clob(CoverSheetBuffer),ToUser,FromUser,	ToMailId,ToMailIdType,ExtToMailId,VariableIdTo,VarFieldIdTo,CCMailId,CCMailIdType,ExtCCMailId,VariableIdCc,VarFieldIdCc,SenderMailId,SenderMailIdType,ExtSenderMailId,VariableIdFrom,VarFieldIdFrom,Message,Subject,BCCMAILID,BCCMAILIDTYPE,EXTBCCMAILID,VARIABLEIDBCC,VARFIELDIDBCC,MailPriority,MailPriorityType, ExtObjIdMailPriority, VariableIdMailPriority, VarFieldIdMailPriority FROM PRINTFAXEMAILTABLE'; 
						DBMS_OUTPUT.PUT_LINE ('INsertion in  PRINTFAXEMAILTABLE2 Successfully Created'); 
						EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''INsertion in  PRINTFAXEMAILTABLE2 Successfully Created'')';
            EXECUTE IMMEDIATE 'RENAME PRINTFAXEMAILTABLE TO PRINTFAXEMAILTABLE_Temp'; 
			DBMS_OUTPUT.PUT_LINE ('INsertion in  PRINTFAXEMAILTABLE2 Successfully Created1');
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''INsertion in  PRINTFAXEMAILTABLE2 Successfully Created1'')';
						EXECUTE IMMEDIATE 'RENAME PRINTFAXEMAILTABLE2 TO PRINTFAXEMAILTABLE';
						DBMS_OUTPUT.PUT_LINE ('INsertion in  PRINTFAXEMAILTABLE2 Successfully Created2'); 
						EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''INsertion in  PRINTFAXEMAILTABLE2 Successfully Created2'')';
						EXECUTE IMMEDIATE 'DROP TABLE PRINTFAXEMAILTABLE_Temp';
						DBMS_OUTPUT.PUT_LINE ('INsertion in  PRINTFAXEMAILTABLE2 Successfully Created3'); 
						EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''INsertion in  PRINTFAXEMAILTABLE2 Successfully Created3'')';
				COMMIT; 
		END;
	EXCEPTION 
		WHEN OTHERS THEN
		raise_application_error(-20214, 'Changing datatype of CoverSheetBuffer column of PRINTFAXEMAILTABLE to NCLOB Failed.');
		RETURN;
	END;
*/	
	
	BEGIN
		BEGIN
			SELECT 1 INTO v_existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('WFMessageInProcessTable') 
			AND 
			COLUMN_NAME=UPPER('message')
			AND
			DATA_TYPE=UPPER('NVARCHAR2');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
      
				EXECUTE IMMEDIATE 'Create Table WFMessageInProcessTable2 (
							messageId		INT, 
							message			NVARCHAR2(2000), 
							lockedBy		NVARCHAR2(63), 
							status			NVARCHAR2(1),
							ActionDateTime	DATE
						)'; 
				/*DBMS_OUTPUT.PUT_LINE ('Table WFMessageInProcessTable2 Successfully Created');*/
				EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Table WFMessageInProcessTable2 Successfully Created'')';
				SAVEPOINT save;
				EXECUTE IMMEDIATE 'INSERT INTO WFMessageInProcessTable2 SELECT messageId,TO_CHAR(message),lockedBy,status,ActionDateTime  FROM WFMessageInProcessTable'; 
						 
				EXECUTE IMMEDIATE 'RENAME WFMessageInProcessTable TO WFMessageInProcessTable_Temp'; 
				EXECUTE IMMEDIATE 'RENAME WFMessageInProcessTable2 TO WFMessageInProcessTable';
				EXECUTE IMMEDIATE 'DROP TABLE WFMessageInProcessTable_Temp';
				COMMIT; 
		END;
		EXCEPTION 
		WHEN OTHERS THEN
		raise_application_error(-20214, 'Changing datatype of message column of WFMessageInProcessTable to NVARCHAR2(2000) Failed.');
		RETURN;
	END;
	BEGIN
		v_existsFlag := 0;
			BEGIN
			SELECT 1 INTO v_existsFlag
					FROM USER_TAB_COLUMNS 
					WHERE UPPER(table_name) = UPPER('WFSharePointDocAssocTable') and UPPER(column_name) = UPPER('TargetDocName');
				EXCEPTION
				  WHEN NO_DATA_FOUND THEN
				/*DBMS_OUTPUT.PUT_LINE ('TargetDocName Already Dropped.');*/
				EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''TargetDocName Already Dropped.'')';
			END;
			IF (v_existsFlag = 1) THEN
			BEGIN
				EXECUTE IMMEDIATE 'ALTER TABLE WFSharePointDocAssocTable DROP COLUMN TargetDocName';
			END;
			END IF;	
	END;
	
	BEGIN
		v_existsFlag := 0;
			BEGIN
			SELECT 1 INTO v_existsFlag
					FROM USER_TAB_COLUMNS 
					WHERE UPPER(table_name) = UPPER('WFImportFileData') and UPPER(column_name) = UPPER('FailRecords');
				EXCEPTION
				  WHEN NO_DATA_FOUND THEN
				/*DBMS_OUTPUT.PUT_LINE ('FailRecords Already Dropped.');*/
				EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''FailRecords Already Dropped.'')';
			END;
			IF (v_existsFlag = 1) THEN
			BEGIN
				EXECUTE IMMEDIATE 'ALTER TABLE WFImportFileData DROP COLUMN FailRecords';
			END;
			END IF;	
	END;
	
	/*Added by server team -- end here*/
	
	/*added for bug in UT -- starts here*/
	BEGIN
		BEGIN
			SELECT 1 INTO v_existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('ACTIVITYTABLE') 
			AND 
			COLUMN_NAME=UPPER('ActivityIcon')
			AND
			DATA_TYPE=UPPER('NCLOB');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
                DBMS_OUTPUT.PUT_LINE ('att111');
				EXECUTE IMMEDIATE 'CREATE TABLE ACTIVITYTABLE_Temp (
							ProcessDefId		INT		NOT NULL,
							ActivityId		INT		NOT NULL ,
							ActivityType		SMALLINT	NOT NULL ,
							ActivityName		NVARCHAR2 (30)	NOT NULL ,
							Description		NCLOB NULL ,
							xLeft			SMALLINT	NOT NULL ,
							yTop			SMALLINT	NOT NULL ,
							NeverExpireFlag		NVARCHAR2(1)	NOT NULL ,
							Expiry			NVARCHAR2(255)	NULL ,
							ExpiryActivity		NVARCHAR2(30)	NULL ,
							TargetActivity		INT		NULL ,
							AllowReassignment	NVARCHAR2(1)	NULL ,
							CollectNoOfInstances	INT		NULL ,
							PrimaryActivity		NVARCHAR2(30)	NULL ,
							ExpireOnPrimaryFlag	NVARCHAR2 (1)	NULL ,
							TriggerID		SMALLINT	NULL ,
							HoldExecutable		NVARCHAR2(255)	NULL ,
							HoldTillVariable	NVARCHAR2 (255) NULL ,
							ExtObjID		INT		NULL ,
							MainClientInterface	NVARCHAR2(255)	NULL ,
							ServerInterface		NVARCHAR2(1)	CHECK ( ServerInterface in (N''Y'' , N''N'' , N''E'')),
							WebClientInterface	NVARCHAR2(255)	NULL ,
							ActivityIcon		NCLOB			NULL ,
							ActivityTurnAroundTime	INT		NULL,
							AppExecutionFlag	NVARCHAR2(1)	NULL,
							AppExecutionValue	INT		NULL,
							ExpiryOperator		INT		NULL ,
							TATCalFlag		NVARCHAR2(1)	NULL,
							ExpCalFlag		NVARCHAR2(1)	NULL,
							DeleteOnCollect NVARCHAR2(1)	NULL,
							Width			INT DEFAULT 100 NOT NULL ,
							Height			INT DEFAULT 50  NOT NULL ,
							BlockId			INT DEFAULT 0   NOT NULL ,
							associatedUrl		Nvarchar2(255) ,
							allowSOAPRequest	NVarChar2(1) DEFAULT N''N'' CHECK (allowSOAPRequest IN (N''Y'' , N''N'')) NOT NULL , 
							AssociatedActivityId INT,
							EventId				 INT	NULL,
							ActivitySubType		 INT	NULL,
							Color				 INT	NULL,
							Cost				 NUMERIC(15, 2)	NULL ,
							Duration		 	 NVARCHAR2(255)	NULL,
							SwimLaneId			 INT	NULL,
							DummyStrColumn1 	 NVARCHAR2(255)	NULL,
							CustomValidation 	 NCLOB,	
							MobileEnabled		NVARCHAR2(1),
							PRIMARY KEY ( ProcessDefId , ActivityID)
						)'; 
				/*DBMS_OUTPUT.PUT_LINE ('Table ACTIVITYTABLE_Temp Successfully Created');*/
				EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Table ACTIVITYTABLE_Temp Successfully Created'')';
				SAVEPOINT save;
				EXECUTE IMMEDIATE 'INSERT INTO ACTIVITYTABLE_Temp (ProcessDefId,ActivityId,ActivityType,ActivityName,Description,xLeft,yTop,NeverExpireFlag,Expiry,ExpiryActivity,TargetActivity,AllowReassignment,CollectNoOfInstances,PrimaryActivity,ExpireOnPrimaryFlag,TriggerID,HoldExecutable,HoldTillVariable,ExtObjID,MainClientInterface,ServerInterface,WebClientInterface,ActivityIcon,ActivityTurnAroundTime,AppExecutionFlag,AppExecutionValue,ExpiryOperator,TATCalFlag,ExpCalFlag,DeleteOnCollect,Width,Height,BlockId,associatedUrl,allowSOAPRequest,AssociatedActivityId,EventId,ActivitySubType,Color,Duration,SwimLaneId,DummyStrColumn1,CustomValidation,MobileEnabled) SELECT ProcessDefId,ActivityId,ActivityType,ActivityName,Description,xLeft,yTop,NeverExpireFlag,Expiry,ExpiryActivity,TargetActivity,AllowReassignment,CollectNoOfInstances,PrimaryActivity,ExpireOnPrimaryFlag,TriggerID,HoldExecutable,HoldTillVariable,ExtObjID,MainClientInterface,ServerInterface,WebClientInterface,blob_to_clob(ActivityIcon),ActivityTurnAroundTime,AppExecutionFlag,AppExecutionValue,ExpiryOperator,TATCalFlag,ExpCalFlag,DeleteOnCollect,Width,Height,BlockId,associatedUrl,allowSOAPRequest,AssociatedActivityId,EventId,ActivitySubType,Color,Duration,SwimLaneId,DummyStrColumn1,CustomValidation,MobileEnabled  FROM ACTIVITYTABLE'; 
				 DBMS_OUTPUT.PUT_LINE ('Insertion done in ACTIVITYTABLE_Temp Successfully');
						 
				EXECUTE IMMEDIATE 'RENAME ACTIVITYTABLE TO ACTIVITYTABLE_Temp1'; 
				/*DBMS_OUTPUT.PUT_LINE ('RENAME done in ACTIVITYTABLE TO ACTIVITYTABLE_Temp1 Successfully');*/
				EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''RENAME done in ACTIVITYTABLE TO ACTIVITYTABLE_Temp1 Successfully'')';
				EXECUTE IMMEDIATE 'RENAME ACTIVITYTABLE_Temp TO ACTIVITYTABLE';
				/*DBMS_OUTPUT.PUT_LINE ('RENAME done in ACTIVITYTABLE_Temp TO ACTIVITYTABLE Successfully');*/
				EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''RENAME done in ACTIVITYTABLE_Temp TO ACTIVITYTABLE Successfully'')';
				EXECUTE IMMEDIATE 'DROP TABLE ACTIVITYTABLE_Temp1';
				/*DBMS_OUTPUT.PUT_LINE ('DROP TABLE ACTIVITYTABLE_Temp1 Successfully');*/
				EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''DROP TABLE ACTIVITYTABLE_Temp1 Successfully'')';
				COMMIT; 
		END;
		EXCEPTION 
		WHEN OTHERS THEN
		EXECUTE IMMEDIATE 'DROP TABLE ACTIVITYTABLE_Temp';
		raise_application_error(-20214, 'Changing datatype of message ActivityIcon of ACTIVITYTABLE to NCLOB Failed.');
		RETURN;
    END;
	
	BEGIN
		BEGIN
			SELECT 1 INTO v_existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('TEMPLATEDEFINITIONTABLE') 
			AND 
			COLUMN_NAME=UPPER('TemplateBuffer')
			AND
			DATA_TYPE=UPPER('NCLOB');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
			    DBMS_OUTPUT.PUT_LINE ('Table TEMPLATEDEFINITIONTABLE_Temp Before Created');
				EXECUTE IMMEDIATE 'CREATE TABLE TEMPLATEDEFINITIONTABLE_Temp (
						ProcessDefId        INT				NOT NULL,
						TemplateId			INT				NOT NULL,
						TemplateFileName	NVARCHAR2(255)  NOT NULL,
						TemplateBuffer		NCLOB			NULL,
						isEncrypted			NVARCHAR2(1),
						ArgList             NVARCHAR2(2000)  NULL,
						Format              NVARCHAR2(255)  NULL,		
						CONSTRAINT Pk_TEMPLATEDEFTABLE_Temp PRIMARY KEY (ProcessdefId,TemplateId)
				)'; 
				/*DBMS_OUTPUT.PUT_LINE ('Table TEMPLATEDEFINITIONTABLE_Temp Successfully Created');*/
				EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Table TEMPLATEDEFINITIONTABLE_Temp Successfully Created'')';
				SAVEPOINT save;
				EXECUTE IMMEDIATE 'INSERT INTO TEMPLATEDEFINITIONTABLE_Temp (ProcessDefId,TemplateId,TemplateFileName,TemplateBuffer,isEncrypted,ArgList,Format) SELECT ProcessDefId,TemplateId,TemplateFileName,blob_to_clob(TemplateBuffer),isEncrypted,ArgList,Format FROM TEMPLATEDEFINITIONTABLE'; 
				 /*DBMS_OUTPUT.PUT_LINE ('Insertion done in TEMPLATEDEFINITIONTABLE_Temp Successfully');*/
				 EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Insertion done in TEMPLATEDEFINITIONTABLE_Temp Successfully'')';
						 
				EXECUTE IMMEDIATE 'RENAME TEMPLATEDEFINITIONTABLE TO TEMPLATEDEFINITIONTABLE_Temp1'; 
				/*DBMS_OUTPUT.PUT_LINE ('RENAME done in TEMPLATEDEFINITIONTABLE TO TEMPLATEDEFINITIONTABLE_Temp1 Successfully');*/
				EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''RENAME done in TEMPLATEDEFINITIONTABLE TO TEMPLATEDEFINITIONTABLE_Temp1 Successfully'')';
				EXECUTE IMMEDIATE 'RENAME TEMPLATEDEFINITIONTABLE_Temp TO TEMPLATEDEFINITIONTABLE';
				/*DBMS_OUTPUT.PUT_LINE ('RENAME done in TEMPLATEDEFINITIONTABLE_Temp TO TEMPLATEDEFINITIONTABLE Successfully');*/
				EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''RENAME done in TEMPLATEDEFINITIONTABLE_Temp TO TEMPLATEDEFINITIONTABLE Successfully'')';
				EXECUTE IMMEDIATE 'DROP TABLE TEMPLATEDEFINITIONTABLE_Temp1';
				/*DBMS_OUTPUT.PUT_LINE ('DROP TABLE TEMPLATEDEFINITIONTABLE_Temp1 Successfully');*/
				EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''DROP TABLE TEMPLATEDEFINITIONTABLE_Temp1 Successfully'')';
				COMMIT; 
		END;
		EXCEPTION 
		WHEN OTHERS THEN
		EXECUTE IMMEDIATE 'DROP TABLE TEMPLATEDEFINITIONTABLE_Temp';
		raise_application_error(-20214, 'Changing datatype of message TemplateBuffer of TEMPLATEDEFINITIONTABLE to NCLOB Failed.');
		RETURN;
    END;
	BEGIN
		BEGIN
			SELECT 1 INTO v_existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('ACTIONDEFTABLE') 
			AND 
			COLUMN_NAME=UPPER('IconBuffer')
			AND
			DATA_TYPE=UPPER('NCLOB');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
			    DBMS_OUTPUT.PUT_LINE ('Table ACTIONDEFTABLE_Temp Before Created');
				EXECUTE IMMEDIATE 'CREATE TABLE ACTIONDEFTABLE_Temp (
					ProcessDefId            INT             NOT NULL,
					ActionId                INT             NOT NULL,
					ActionName              NVARCHAR2(50)   NOT NULL,
					ViewAs                  NVARCHAR2(50)   NULL,
					IconBuffer              NCLOB			NULL,
					ActivityId              INT             NOT NULL,
					isEncrypted				NVARCHAR2(1),
					CONSTRAINT PK_ACTIONDEFTABLE_temp PRIMARY KEY(ProcessDefId,ActionId,ActivityId)
				)'; 
				/*DBMS_OUTPUT.PUT_LINE ('Table ACTIONDEFTABLE_Temp Successfully Created');*/
				EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Table ACTIONDEFTABLE_Temp Successfully Created'')';
				SAVEPOINT save;
				EXECUTE IMMEDIATE 'INSERT INTO ACTIONDEFTABLE_Temp (ProcessDefId,ActionId,ActionName,ViewAs,IconBuffer,ActivityId,isEncrypted) SELECT ProcessDefId,ActionId,ActionName,ViewAs,blob_to_clob(IconBuffer),ActivityId,isEncrypted FROM ACTIONDEFTABLE'; 
				 /*DBMS_OUTPUT.PUT_LINE ('Insertion done in ACTIONDEFTABLE_Temp Successfully');*/
				EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Insertion done in ACTIONDEFTABLE_Temp Successfully'')';		 
				EXECUTE IMMEDIATE 'RENAME ACTIONDEFTABLE TO ACTIONDEFTABLE_Temp1'; 
				/*DBMS_OUTPUT.PUT_LINE ('RENAME done in ACTIONDEFTABLE TO ACTIONDEFTABLE_Temp1 Successfully');*/
				EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''RENAME done in ACTIONDEFTABLE TO ACTIONDEFTABLE_Temp1 Successfully'')';
				EXECUTE IMMEDIATE 'RENAME ACTIONDEFTABLE_Temp TO ACTIONDEFTABLE';
				/*DBMS_OUTPUT.PUT_LINE ('RENAME done in ACTIONDEFTABLE_Temp TO ACTIONDEFTABLE Successfully');*/
				EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''RENAME done in ACTIONDEFTABLE_Temp TO ACTIONDEFTABLE Successfully'')';
				EXECUTE IMMEDIATE 'DROP TABLE ACTIONDEFTABLE_Temp1';
				/*DBMS_OUTPUT.PUT_LINE ('DROP TABLE ACTIONDEFTABLE_Temp1 Successfully');*/
				EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''DROP TABLE ACTIONDEFTABLE_Temp1 Successfully'')';
				COMMIT; 
		END;
		EXCEPTION 
		WHEN OTHERS THEN
		EXECUTE IMMEDIATE 'DROP TABLE ACTIONDEFTABLE_Temp';
		raise_application_error(-20214, 'Changing datatype of message IconBuffer of ACTIONDEFTABLE to NCLOB Failed.');
		RETURN;
    END;
	BEGIN
		BEGIN
			SELECT 1 INTO v_existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('PROCESSINITABLE') 
			AND 
			COLUMN_NAME=UPPER('ProcessINI')
			AND
			DATA_TYPE=UPPER('NCLOB');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
			    DBMS_OUTPUT.PUT_LINE ('Table PROCESSINITABLE_Temp Before Created');
				EXECUTE IMMEDIATE 'CREATE TABLE PROCESSINITABLE_Temp (
					ProcessDefId		INT             NOT NULL,
					ProcessINI			NCLOB			NULL,
					CONSTRAINT PK_ProcessINITable_Temp PRIMARY KEY(ProcessDefId)
				)'; 
				DBMS_OUTPUT.PUT_LINE ('Table PROCESSINITABLE_Temp Successfully Created');
				EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Table PROCESSINITABLE_Temp Successfully Created'')';
				SAVEPOINT save;
				EXECUTE IMMEDIATE 'INSERT INTO PROCESSINITABLE_Temp (ProcessDefId,ProcessINI) SELECT ProcessDefId,blob_to_clob(ProcessINI) FROM PROCESSINITABLE'; 
				/* DBMS_OUTPUT.PUT_LINE ('Insertion done in PROCESSINITABLE_Temp Successfully');*/
				EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Insertion done in PROCESSINITABLE_Temp Successfully'')';		 
				EXECUTE IMMEDIATE 'RENAME PROCESSINITABLE TO PROCESSINITABLE_Temp1'; 
				/*DBMS_OUTPUT.PUT_LINE ('RENAME done in PROCESSINITABLE TO PROCESSINITABLE_Temp1 Successfully');*/
				EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''RENAME done in PROCESSINITABLE TO PROCESSINITABLE_Temp1 Successfully'')';
				EXECUTE IMMEDIATE 'RENAME PROCESSINITABLE_Temp TO PROCESSINITABLE';
				/*DBMS_OUTPUT.PUT_LINE ('RENAME done in PROCESSINITABLE_Temp TO PROCESSINITABLE Successfully');*/
				EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''RENAME done in PROCESSINITABLE_Temp TO PROCESSINITABLE Successfully'')';
				EXECUTE IMMEDIATE 'DROP TABLE PROCESSINITABLE_Temp1';
				/*DBMS_OUTPUT.PUT_LINE ('DROP TABLE PROCESSINITABLE_Temp1 Successfully');*/
				EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''DROP TABLE PROCESSINITABLE_Temp1 Successfully'')';
				COMMIT; 
		END;
		EXCEPTION 
		WHEN OTHERS THEN
		EXECUTE IMMEDIATE 'DROP TABLE PROCESSINITABLE_Temp';
		raise_application_error(-20214, 'Changing datatype of message ProcessINI of PROCESSINITABLE to NCLOB Failed.');
		RETURN;
    END;
	BEGIN
		BEGIN
			SELECT 1 INTO v_existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('WFFORM_TABLE') 
			AND 
			COLUMN_NAME=UPPER('FormBuffer')
			AND
			DATA_TYPE=UPPER('NCLOB');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
			    DBMS_OUTPUT.PUT_LINE ('Table WFFORM_TABLE_Temp Before Created');
				EXECUTE IMMEDIATE 'CREATE TABLE WFFORM_TABLE_Temp (
					ProcessDefId            INT             NOT NULL,
					FormId                  INT             NOT NULL,
					FormName                NVARCHAR2(50)  NOT NULL,
					FormBuffer              NCLOB			NULL,
					isEncrypted				NVARCHAR2(1),
					LastModifiedOn 			DATE			NOT NULL,
					DeviceType				NVARCHAR2(1)  DEFAULT ''D'',
					FormHeight				INT DEFAULT(100) NOT NULL,
					FormWidth				INT DEFAULT(100) NOT NULL,
					ProcessVariantId 		INT 	DEFAULT(0) NOT NULL,  
					ExistingFormId			INT				NULL,
					CONSTRAINT PK_WFFORM_TABLE_Temp PRIMARY KEY(ProcessDefID,FormId,DeviceType)
				)'; 
				/*DBMS_OUTPUT.PUT_LINE ('Table WFFORM_TABLE_Temp Successfully Created');*/
				EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Table WFFORM_TABLE_Temp Successfully Created'')';
				SAVEPOINT save;
				EXECUTE IMMEDIATE 'INSERT INTO WFFORM_TABLE_Temp (ProcessDefId,FormId,FormName,FormBuffer,isEncrypted,LastModifiedOn,DeviceType,FormHeight,FormWidth,ProcessVariantId,ExistingFormId) SELECT ProcessDefId,FormId,FormName,blob_to_clob(FormBuffer),isEncrypted,LastModifiedOn,DeviceType,FormHeight,FormWidth,ProcessVariantId,ExistingFormId FROM WFFORM_TABLE'; 
				/* DBMS_OUTPUT.PUT_LINE ('Insertion done in WFFORM_TABLE_Temp Successfully');*/
				EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Insertion done in WFFORM_TABLE_Temp Successfully'')';		 
				EXECUTE IMMEDIATE 'RENAME WFFORM_TABLE TO WFFORM_TABLE_Temp1'; 
				/*DBMS_OUTPUT.PUT_LINE ('RENAME done in WFFORM_TABLE TO WFFORM_TABLE_Temp1 Successfully');*/
				EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''RENAME done in WFFORM_TABLE TO WFFORM_TABLE_Temp1 Successfully'')';
				EXECUTE IMMEDIATE 'RENAME WFFORM_TABLE_Temp TO WFFORM_TABLE';
				/*DBMS_OUTPUT.PUT_LINE ('RENAME done in WFFORM_TABLE_Temp TO WFFORM_TABLE Successfully');*/
				EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''RENAME done in WFFORM_TABLE_Temp TO WFFORM_TABLE Successfully'')';
				EXECUTE IMMEDIATE 'DROP TABLE WFFORM_TABLE_Temp1';
				/*DBMS_OUTPUT.PUT_LINE ('DROP TABLE WFFORM_TABLE_Temp1 Successfully');*/
				EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''DROP TABLE WFFORM_TABLE_Temp1 Successfully'')';
				COMMIT; 
		END;
		EXCEPTION 
		WHEN OTHERS THEN
		EXECUTE IMMEDIATE 'DROP TABLE WFFORM_TABLE_Temp';
		raise_application_error(-20214, 'Changing datatype of message FormBuffer of WFFORM_TABLE to NCLOB Failed.');
		RETURN;
    END;
	BEGIN
		BEGIN
			SELECT 1 INTO v_existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('TemplateMultiLanguageTable') 
			AND 
			COLUMN_NAME=UPPER('TemplateBuffer')
			AND
			DATA_TYPE=UPPER('NCLOB');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
			    DBMS_OUTPUT.PUT_LINE ('Table TemplateMultiLangTable_Temp Before Created');
				EXECUTE IMMEDIATE 'CREATE TABLE TemplateMultiLangTable_Temp (
					ProcessDefId	INT				NOT NULL,
					TemplateId		INT				NOT NULL,
					Locale			NCHAR(5)		NOT NULL,
					TemplateBuffer	NCLOB			NULL,
					isEncrypted		NVARCHAR2(1)
				)'; 
				/*DBMS_OUTPUT.PUT_LINE ('Table TemplateMultiLangTable_Temp Successfully Created');*/
				EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Table TemplateMultiLangTable_Temp Successfully Created'')';
				SAVEPOINT save;
				EXECUTE IMMEDIATE 'INSERT INTO TemplateMultiLangTable_Temp (ProcessDefId,TemplateId,Locale,TemplateBuffer,isEncrypted) SELECT ProcessDefId,TemplateId,Locale,blob_to_clob(TemplateBuffer),isEncrypted FROM TemplateMultiLanguageTable'; 
				 /*DBMS_OUTPUT.PUT_LINE ('Insertion done in TemplateMultiLangTable_Temp Successfully');*/
				EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Insertion done in TemplateMultiLangTable_Temp Successfully'')';		 
				EXECUTE IMMEDIATE 'RENAME TemplateMultiLanguageTable TO TemplateMultiLangTable_Temp1'; 
				/*DBMS_OUTPUT.PUT_LINE ('RENAME done in WFFORM_TABLE TO WFFORM_TABLE_Temp1 Successfully');*/
				EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''RENAME done in WFFORM_TABLE TO WFFORM_TABLE_Temp1 Successfully'')';
				EXECUTE IMMEDIATE 'RENAME TemplateMultiLangTable_Temp TO TemplateMultiLanguageTable';
				/*DBMS_OUTPUT.PUT_LINE ('RENAME done in TemplateMultiLangTable_Temp TO TemplateMultiLanguageTable Successfully');*/
				EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''RENAME done in TemplateMultiLangTable_Temp TO TemplateMultiLanguageTable Successfully'')';
				EXECUTE IMMEDIATE 'DROP TABLE TemplateMultiLangTable_Temp1';
				/*DBMS_OUTPUT.PUT_LINE ('DROP TABLE TemplateMultiLangTable_Temp1 Successfully');*/
				EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''DROP TABLE TemplateMultiLangTable_Temp1 Successfully'')';
				COMMIT; 
		END;
		EXCEPTION 
		WHEN OTHERS THEN
		EXECUTE IMMEDIATE 'DROP TABLE TemplateMultiLangTable_Temp';
		raise_application_error(-20214, 'Changing datatype of message TemplateBuffer of TemplateMultiLanguageTable to NCLOB Failed.');
		RETURN;
    END;
	BEGIN
		BEGIN
			SELECT 1 INTO v_existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('WFFormFragmentTable') 
			AND 
			COLUMN_NAME=UPPER('FragmentBuffer')
			AND
			DATA_TYPE=UPPER('NCLOB');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
			    DBMS_OUTPUT.PUT_LINE ('Table TemplateMultiLangTable_Temp Before Created');
				EXECUTE IMMEDIATE 'CREATE TABLE WFFormFragmentTable_Temp(	
					ProcessDefId	int 		   NOT NULL,
					FragmentId	    int 		   NOT NULL,
					FragmentName	NVARCHAR2(50)  NOT NULL,
					FragmentBuffer	NCLOB          NULL,
					IsEncrypted	    NVARCHAR2(1)   NOT NULL,
					StructureName	NVARCHAR2(128) NOT NULL,
					StructureId	    int            NOT NULL,
					LastModifiedOn  DATE,
					DeviceType				NVARCHAR2(1)  DEFAULT ''D'',
					FormHeight				INT DEFAULT(100) NOT NULL,
					FormWidth				INT DEFAULT(100) NOT NULL,
					CONSTRAINT PK_WFFormFragTable_Tp PRIMARY KEY(ProcessDefId,FragmentId)
				)'; 
				/*DBMS_OUTPUT.PUT_LINE ('Table WFFormFragmentTable_Temp Successfully Created');*/
				EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Table WFFormFragmentTable_Temp Successfully Created'')';
				SAVEPOINT save;
				EXECUTE IMMEDIATE 'INSERT INTO WFFormFragmentTable_Temp (ProcessDefId,FragmentId,FragmentName,FragmentBuffer,IsEncrypted,StructureName,StructureId,LastModifiedOn,DeviceType,FormHeight,FormWidth) SELECT ProcessDefId,FragmentId,FragmentName,blob_to_clob(FragmentBuffer),IsEncrypted,StructureName,StructureId,LastModifiedOn,DeviceType,FormHeight,FormWidth FROM WFFormFragmentTable'; 
				 /*DBMS_OUTPUT.PUT_LINE ('Insertion done in WFFormFragmentTable_Temp Successfully');*/
				EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Insertion done in WFFormFragmentTable_Temp Successfully'')';		 
				EXECUTE IMMEDIATE 'RENAME WFFormFragmentTable TO WFFormFragmentTable_Temp1'; 
				/*DBMS_OUTPUT.PUT_LINE ('RENAME done in WFFormFragmentTable TO WFFormFragmentTable_Temp1 Successfully');*/
				EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''RENAME done in WFFormFragmentTable TO WFFormFragmentTable_Temp1 Successfully'')';
				EXECUTE IMMEDIATE 'RENAME WFFormFragmentTable_Temp TO WFFormFragmentTable';
				/*DBMS_OUTPUT.PUT_LINE ('RENAME done in WFFormFragmentTable_Temp TO WFFormFragmentTable Successfully');*/
				EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''RENAME done in WFFormFragmentTable_Temp TO WFFormFragmentTable Successfully'')';
				EXECUTE IMMEDIATE 'DROP TABLE WFFormFragmentTable_Temp1';
				/*DBMS_OUTPUT.PUT_LINE ('DROP TABLE WFFormFragmentTable_Temp1 Successfully');*/
				EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''DROP TABLE WFFormFragmentTable_Temp1 Successfull'')';
				COMMIT; 
		END;
		EXCEPTION 
		WHEN OTHERS THEN
		EXECUTE IMMEDIATE 'DROP TABLE WFFormFragmentTable_Temp';
		raise_application_error(-20214, 'Changing datatype of message FragmentBuffer of WFFormFragmentTable to NCLOB Failed.');
		RETURN;
    END;
	/*BEGIN
	   SELECT 1 INTO v_existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME=UPPER('WFAUDITTRAILDOCTABLE') 
		AND 
		COLUMN_NAME=UPPER('DELETEAUDIT');
		EXECUTE IMMEDIATE 'ALTER TABLE WFAUDITTRAILDOCTABLE DROP COLUMN DELETEAUDIT';
		/*DBMS_OUTPUT.PUT_LINE ('ALTER TABLE WFAUDITTRAILDOCTABLE DROP COLUMN DELETEAUDIT');*/
		/*EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE WFAUDITTRAILDOCTABLE DROP COLUMN DELETEAUDIT'')';
	    EXCEPTION
			WHEN NO_DATA_FOUND THEN
			    /*DBMS_OUTPUT.PUT_LINE ('DELETEAUDIT column not exist in WFAUDITTRAILDOCTABLE');*/
				/*EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''DELETEAUDIT column not exist in WFAUDITTRAILDOCTABLE'')';
				
	END;
	BEGIN
	   SELECT 1 INTO v_existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME=UPPER('ARCHIVETABLE') 
		AND 
		COLUMN_NAME=UPPER('DELETEAUDIT');
		EXECUTE IMMEDIATE 'ALTER TABLE ARCHIVETABLE DROP COLUMN DELETEAUDIT';
		/*DBMS_OUTPUT.PUT_LINE ('ALTER TABLE ARCHIVETABLE DROP COLUMN DELETEAUDIT');*/
		/*EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''ALTER TABLE ARCHIVETABLE DROP COLUMN DELETEAUDIT'')';
	    EXCEPTION
			WHEN NO_DATA_FOUND THEN
			    /*DBMS_OUTPUT.PUT_LINE ('DELETEAUDIT column not exist in WFAUDITTRAILDOCTABLE');*/
				/*EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''DELETEAUDIT column not exist in WFAUDITTRAILDOCTABLE'')';
				
	END;*/
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TABLES  
		WHERE TABLE_NAME = UPPER('PROCESS_INTERFACETABLE');
		EXECUTE IMMEDIATE 'UPDATE PROCESS_INTERFACETABLE set InterfaceId = -1 where InterfaceId = 9 and InterfaceName=''DMSSearch''';
		/*DBMS_OUTPUT.PUT_LINE ('Table PROCESS_INTERFACETABLE updated interface id 9 to -1');*/
		EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Table PROCESS_INTERFACETABLE updated interface id 9 to -1'')';
		EXECUTE IMMEDIATE 'UPDATE PROCESS_INTERFACETABLE set InterfaceId = 9,InterfaceName = ''Mobile'',ClientInvocation = ''Mobile.clsMobile'',menuname = ''Mobile'' where InterfaceId = 11 and InterfaceName=''MobileSubTab''';
		/*DBMS_OUTPUT.PUT_LINE ('Table PROCESS_INTERFACETABLE updated interface id 11 to 9');*/
		EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Table PROCESS_INTERFACETABLE updated interface id 11 to 9'')';
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
			    DBMS_OUTPUT.PUT_LINE ('Table PROCESS_INTERFACETABLE not present');
				EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Table PROCESS_INTERFACETABLE not present'')';
				
	END;
	
	BEGIN
	EXECUTE IMMEDIATE('Update varmappingtable set varprecision = 0 where varprecision is NULL');
	EXECUTE IMMEDIATE('Update PROCESSDEFCOMMENTTABLE set CommentFont = ''BookMan Old Style,0,8'' where CommentFont is NULL');
	EXECUTE IMMEDIATE('INSERT INTO WFUpgradeLoggingTable VALUES (''Update PROCESSDEFCOMMENTTABLE set CommentFont'')');
	EXECUTE IMMEDIATE('Update PROCESSDEFCOMMENTTABLE set CommentForeColor = 0 where CommentForeColor is NULL');
	EXECUTE IMMEDIATE('INSERT INTO WFUpgradeLoggingTable VALUES (''Update PROCESSDEFCOMMENTTABLE set CommentForeColor'')');
	EXECUTE IMMEDIATE('Update PROCESSDEFCOMMENTTABLE set CommentBackColor = 0 where CommentBackColor is NULL');
	EXECUTE IMMEDIATE('INSERT INTO WFUpgradeLoggingTable VALUES (''Update PROCESSDEFCOMMENTTABLE set CommentBackColor'')');
	EXECUTE IMMEDIATE('Update PROCESSDEFCOMMENTTABLE set CommentBorderStyle = 0 where CommentBorderStyle is NULL');
	EXECUTE IMMEDIATE('INSERT INTO WFUpgradeLoggingTable VALUES (''Update PROCESSDEFCOMMENTTABLE set CommentBorderStyle'')');
	EXECUTE IMMEDIATE('update QUEUEUSERTABLE set QueryPreview = ''Y'' where QueryPreview is NULL');
	EXECUTE IMMEDIATE('INSERT INTO WFUpgradeLoggingTable VALUES (''Update QUEUEUSERTABLE set QueryPreview'')');
	END;
	BEGIN
	  FOR ind IN 
		(SELECT index_name FROM user_indexes WHERE table_name = UPPER('WFCURRENTROUTELOGTABLE') AND index_name NOT IN 
		   (SELECT unique index_name FROM user_constraints WHERE 
			  table_name = UPPER('WFCURRENTROUTELOGTABLE') AND index_name IS NOT NULL))
	  LOOP
		  execute immediate 'DROP INDEX '||ind.index_name;
	  END LOOP;
	END;
	
	BEGIN
		SELECT 1 INTO v_existsFlag 
		FROM USER_INDEXES
		WHERE INDEX_NAME = UPPER('IDX1_WFRouteLogTABLE');
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'CREATE INDEX IDX1_WFRouteLogTABLE ON WFCURRENTROUTELOGTABLE (ProcessDefId,ActionId)';	EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE INDEX IDX1_WFRouteLogTABLE ON WFCURRENTROUTELOGTABLE (ProcessDefId,ActionId)'')';
	    
	END;
	BEGIN
		SELECT 1 INTO v_existsFlag 
		FROM USER_INDEXES
		WHERE INDEX_NAME = UPPER('IDX2_WFRouteLogTABLE');
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'CREATE INDEX IDX2_WFRouteLogTABLE ON WFCURRENTROUTELOGTABLE (ActionId,UserID)';	
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE INDEX IDX2_WFRouteLogTABLE ON WFCURRENTROUTELOGTABLE (ActionId,UserID)'')';
	    
	END;
	BEGIN
		SELECT 1 INTO v_existsFlag 
		FROM USER_INDEXES
		WHERE INDEX_NAME = UPPER('IDX3_WFCRouteLogTable');
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'CREATE INDEX IDX3_WFCRouteLogTable ON WFCURRENTROUTELOGTABLE (ProcessInstanceId)';	
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE INDEX IDX3_WFCRouteLogTable ON WFCURRENTROUTELOGTABLE (ProcessInstanceId)'')';
	    
	END;
	BEGIN
		SELECT 1 INTO v_existsFlag 
		FROM USER_INDEXES
		WHERE INDEX_NAME = UPPER('IDX4_WFCRouteLogTable');
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'CREATE INDEX IDX4_WFCRouteLogTable ON WFCURRENTROUTELOGTABLE (ProcessInstanceId, ActionDateTime, LogID)';	
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE INDEX IDX4_WFCRouteLogTable ON WFCURRENTROUTELOGTABLE (ProcessInstanceId, ActionDateTime, LogID)'')';
	    
	END;
	
	BEGIN
	  FOR ind IN 
		(SELECT index_name FROM user_indexes WHERE table_name = UPPER('WFHISTORYROUTELOGTABLE') AND index_name NOT IN 
		   (SELECT unique index_name FROM user_constraints WHERE 
			  table_name = UPPER('WFHISTORYROUTELOGTABLE') AND index_name IS NOT NULL))
	  LOOP
		  execute immediate 'DROP INDEX '||ind.index_name;
	  END LOOP;
	END;
	
	BEGIN
		SELECT 1 INTO v_existsFlag 
		FROM USER_INDEXES
		WHERE INDEX_NAME = UPPER('IDX1_WFHRouteLogTABLE');
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'CREATE INDEX IDX1_WFHRouteLogTABLE ON WFHISTORYROUTELOGTABLE (ProcessDefId,ActionId)';	EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE INDEX IDX1_WFHRouteLogTABLE ON WFHISTORYROUTELOGTABLE (ProcessDefId,ActionId)'')';
	    
	END;
	BEGIN
		SELECT 1 INTO v_existsFlag 
		FROM USER_INDEXES
		WHERE INDEX_NAME = UPPER('IDX2_WFHRouteLogTABLE');
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'CREATE INDEX IDX2_WFHRouteLogTABLE ON WFHISTORYROUTELOGTABLE (ActionId,UserID)';	
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE INDEX IDX2_WFHRouteLogTABLE ON WFHISTORYROUTELOGTABLE (ActionId,UserID)'')';
	    
	END;
	BEGIN
		SELECT 1 INTO v_existsFlag 
		FROM USER_INDEXES
		WHERE INDEX_NAME = UPPER('IDX3_WFHRouteLogTable');
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'CREATE INDEX IDX3_WFHRouteLogTable ON WFHistoryRouteLogTable (ProcessInstanceId)';	
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE INDEX IDX3_WFHRouteLogTable ON WFHistoryRouteLogTable (ProcessInstanceId)'')';
	    
	END;
	BEGIN
		SELECT 1 INTO v_existsFlag 
		FROM USER_INDEXES
		WHERE INDEX_NAME = UPPER('IDX4_WFHRouteLogTABLE');
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'CREATE INDEX IDX4_WFHRouteLogTABLE ON WFHISTORYROUTELOGTABLE (ProcessInstanceId, ActionDateTime, LogID)';	
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''CREATE INDEX IDX4_WFHRouteLogTABLE ON WFHISTORYROUTELOGTABLE (ProcessInstanceId, ActionDateTime, LogID)'')';
	    
	END;
	
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME = UPPER('ARCHIVEDATAMAPTABLE') 
		AND 
		COLUMN_NAME = UPPER('Datafieldlength');
		EXECUTE IMMEDIATE('alter table ARCHIVEDATAMAPTABLE drop column Datafieldlength');	
		EXECUTE IMMEDIATE('INSERT INTO WFUpgradeLoggingTable VALUES (''alter table ARCHIVEDATAMAPTABLE drop column datafieldlength'')');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''Datafieldlength Not present in the table ARCHIVEDATAMAPTABLE'')';
	END;
	
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME = UPPER('IMPORTEDPROCESSDEFTABLE') 
		AND 
		COLUMN_NAME = UPPER('FIELDLENGTH');
		EXECUTE IMMEDIATE('alter table IMPORTEDPROCESSDEFTABLE drop column FIELDLENGTH');	
		EXECUTE IMMEDIATE('INSERT INTO WFUpgradeLoggingTable VALUES (''alter table IMPORTEDPROCESSDEFTABLE drop column FIELDLENGTH'')');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''FIELDLENGTH Not present in the table IMPORTEDPROCESSDEFTABLE'')';
	END;
	
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME = UPPER('ExtMethodParamMappingTable') 
		AND 
		COLUMN_NAME = UPPER('datastructureid');
		EXECUTE IMMEDIATE('update ExtMethodParamMappingTable set datastructureid=0 where  datastructureid is NULL');	
		EXECUTE IMMEDIATE('INSERT INTO WFUpgradeLoggingTable VALUES (''update ExtMethodParamMappingTable set datastructureid=0 where  datastructureid is NULL'')');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''datastructureid Not present in the table ExtMethodParamMappingTable'')';
	END;
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME = UPPER('WFDurationTable') 
		AND 
		COLUMN_NAME = UPPER('WFHours');
		EXECUTE IMMEDIATE('update WFDurationTable set WFHours=''<None>'' where  WFHours is NULL');	
		EXECUTE IMMEDIATE('INSERT INTO WFUpgradeLoggingTable VALUES (''update WFDurationTable set WFHours=<None> where  WFHours is NULL'')');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''WFHours Not present in the table WFDurationTable'')';
	END;
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME = UPPER('WFDurationTable') 
		AND 
		COLUMN_NAME = UPPER('WFMinutes');
		EXECUTE IMMEDIATE('update WFDurationTable set WFMinutes=''<None>'' where  WFMinutes is NULL');	
		EXECUTE IMMEDIATE('INSERT INTO WFUpgradeLoggingTable VALUES (''update WFDurationTable set WFMinutes=<None> where  WFMinutes is NULL'')');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''WFMinutes Not present in the table WFDurationTable'')';
	END;
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME = UPPER('WFDurationTable') 
		AND 
		COLUMN_NAME = UPPER('WFSeconds');
		EXECUTE IMMEDIATE('update WFDurationTable set WFSeconds=''<None>'' where  WFSeconds is NULL');	
		EXECUTE IMMEDIATE('INSERT INTO WFUpgradeLoggingTable VALUES (''update WFDurationTable set WFSeconds=<None> where  WFSeconds is NULL'')');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''WFSeconds Not present in the table WFDurationTable'')';
	END;
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME = UPPER('PRINTFAXEMAILTABLE') 
		AND 
		COLUMN_NAME = UPPER('FaxNoType');
		EXECUTE IMMEDIATE 'update PRINTFAXEMAILTABLE set FaxNoType='''' where  FaxNoType is NULL and VariableIdFax!=0'; 
		EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''update PRINTFAXEMAILTABLE set FaxNoType to blank'')';
		EXECUTE IMMEDIATE 'update PRINTFAXEMAILTABLE set FaxNoType=''C'' where  FaxNoType is NULL and VariableIdFax=0';
		EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''update PRINTFAXEMAILTABLE set FaxNoType to NULL'')';
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''FaxNoType Not present in the table PRINTFAXEMAILTABLE'')';
	END;
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME = UPPER('PRINTFAXEMAILTABLE') 
		AND 
		COLUMN_NAME = UPPER('MailPriority');
		EXECUTE IMMEDIATE 'update PRINTFAXEMAILTABLE set MailPriority='''' where  MailPriority is NULL ';
		EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''update PRINTFAXEMAILTABLE set MailPriority to blank'')';
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''MailPriority Not present in the table PRINTFAXEMAILTABLE'')';
	END;
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME = UPPER('EXTDBCONFTABLE') 
		AND 
		COLUMN_NAME = UPPER('DatabaseName');
		EXECUTE IMMEDIATE 'update EXTDBCONFTABLE set DatabaseName=''online''';
		EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''update EXTDBCONFTABLE set DatabaseName to online'')';
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''DatabaseName Not present in the table EXTDBCONFTABLE'')';
	END;
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME = UPPER('EXTDBCONFTABLE') 
		AND 
		COLUMN_NAME = UPPER('DatabaseType');
		EXECUTE IMMEDIATE 'update EXTDBCONFTABLE set DatabaseType=''local''';
		EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''update EXTDBCONFTABLE set DatabaseType to local'')';
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''DatabaseType Not present in the table EXTDBCONFTABLE'')';
	END;
	
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME = UPPER('mailtriggertable') 
		AND 
		COLUMN_NAME = UPPER('fromuser');
		EXECUTE IMMEDIATE 'update mailtriggertable set fromuser='' '' where fromuser is NULL';
		EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''update mailtriggertable set fromuser to blank when NULL'')';
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''fromuser Not present in the table mailtriggertable'')';
	END;
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME = UPPER('mailtriggertable') 
		AND 
		COLUMN_NAME = UPPER('SUBJECT');
		EXECUTE IMMEDIATE 'update mailtriggertable set SUBJECT='' '' where SUBJECT is NULL';
		EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''update mailtriggertable set SUBJECT to blank when NULL'')';
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''SUBJECT Not present in the table mailtriggertable'')';
	END;
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME = UPPER('VARALIASTABLE') 
		AND 
		COLUMN_NAME = UPPER('AliasRule');
		EXECUTE IMMEDIATE 'update VARALIASTABLE set AliasRule=''<Rules></Rules>'' where AliasRule is NULL';
		EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''update VARALIASTABLE set AliasRule'')';
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'INSERT INTO WFUpgradeLoggingTable VALUES (''AliasRule Not present in the table VARALIASTABLE'')';
	END;
	
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME = UPPER('WFSAPGUIDefTable') 
		AND 
		COLUMN_NAME = UPPER('TCodeType');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
		EXECUTE IMMEDIATE('alter table WFSAPGUIDefTable add TCodeType NVarChar2(1)	NOT NULL');	
		EXECUTE IMMEDIATE('INSERT INTO WFUpgradeLoggingTable VALUES (''alter table WFSAPGUIDefTable add TCodeType NVarChar2(1)'')');
	END;
	
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME = UPPER('WFSAPGUIDefTable') 
		AND 
		COLUMN_NAME = UPPER('VariableId');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
		EXECUTE IMMEDIATE('alter table WFSAPGUIDefTable add VariableId INT');	
		EXECUTE IMMEDIATE('INSERT INTO WFUpgradeLoggingTable VALUES (''alter table WFSAPGUIDefTable add VariableId INT'')');
	END;
	
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME = UPPER('WFSAPGUIDefTable') 
		AND 
		COLUMN_NAME = UPPER('VarFieldId');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
		EXECUTE IMMEDIATE('alter table WFSAPGUIDefTable add VarFieldId INT');	
		EXECUTE IMMEDIATE('INSERT INTO WFUpgradeLoggingTable VALUES (''alter table WFSAPGUIDefTable add VarFieldId INT'')');
	END;
	
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME = UPPER('WFPDA_FormTable') 
		AND 
		COLUMN_NAME = UPPER('CONTROLTYPE');
		EXECUTE IMMEDIATE('alter table WFPDA_FormTable drop column CONTROLTYPE');	
		EXECUTE IMMEDIATE('INSERT INTO WFUpgradeLoggingTable VALUES (''alter table WFPDA_FormTable drop column CONTROLTYPE'')');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
		EXECUTE IMMEDIATE('INSERT INTO WFUpgradeLoggingTable VALUES ('' column CONTROLTYPE not exist'')');
	END;
	
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME = UPPER('WFPDA_FormTable') 
		AND 
		COLUMN_NAME = UPPER('DISPLAYNAME');
		EXECUTE IMMEDIATE('alter table WFPDA_FormTable drop column DISPLAYNAME');	
		EXECUTE IMMEDIATE('INSERT INTO WFUpgradeLoggingTable VALUES (''alter table WFPDA_FormTable drop column DISPLAYNAME'')');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
		EXECUTE IMMEDIATE('INSERT INTO WFUpgradeLoggingTable VALUES (''column DISPLAYNAME not exist'')');
	END;
	
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME = UPPER('WFPDA_FormTable') 
		AND 
		COLUMN_NAME = UPPER('MINLEN');
		EXECUTE IMMEDIATE('alter table WFPDA_FormTable drop column MINLEN');	
		EXECUTE IMMEDIATE('INSERT INTO WFUpgradeLoggingTable VALUES (''alter table WFPDA_FormTable drop column MINLEN '')');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
		EXECUTE IMMEDIATE('INSERT INTO WFUpgradeLoggingTable VALUES ('' column MINLEN not exist'')');
	END;
	
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME = UPPER('WFPDA_FormTable') 
		AND 
		COLUMN_NAME = UPPER('MAXLEN');
		EXECUTE IMMEDIATE('alter table WFPDA_FormTable drop column MAXLEN');	
		EXECUTE IMMEDIATE('INSERT INTO WFUpgradeLoggingTable VALUES (''alter table WFPDA_FormTable drop column MAXLEN  '')');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
		EXECUTE IMMEDIATE('INSERT INTO WFUpgradeLoggingTable VALUES ('' column MAXLEN  not exist'')');
	END;
	
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME = UPPER('WFPDA_FormTable') 
		AND 
		COLUMN_NAME = UPPER('VALIDATION');
		EXECUTE IMMEDIATE('alter table WFPDA_FormTable drop column VALIDATION');	
		EXECUTE IMMEDIATE('INSERT INTO WFUpgradeLoggingTable VALUES (''alter table WFPDA_FormTable drop column VALIDATION'')');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
		EXECUTE IMMEDIATE('INSERT INTO WFUpgradeLoggingTable VALUES ('' column VALIDATION not exist'')');
	END;
	
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME = UPPER('WFPDA_FormTable') 
		AND 
		COLUMN_NAME = UPPER('ORDERID');
		EXECUTE IMMEDIATE('alter table WFPDA_FormTable drop column ORDERID');	
		EXECUTE IMMEDIATE('INSERT INTO WFUpgradeLoggingTable VALUES (''alter table WFPDA_FormTable drop column ORDERID'')');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
		EXECUTE IMMEDIATE('INSERT INTO WFUpgradeLoggingTable VALUES (''column ORDERID not exist'')');
	END;
	
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME = UPPER('extmethodparammappingtable') 
		AND 
		COLUMN_NAME = UPPER('datastructureid');
		EXECUTE IMMEDIATE('update extmethodparammappingtable set datastructureid=0 where datastructureid is NULL');	
		EXECUTE IMMEDIATE('INSERT INTO WFUpgradeLoggingTable VALUES (''update extmethodparammappingtable set datastructureid=0 where datastructureid is NULL'')');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
		EXECUTE IMMEDIATE('INSERT INTO WFUpgradeLoggingTable VALUES (''column datastructureid not exist'')');
	END;
	/*added for bug in UT -- ends here*/
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME = UPPER('ARCHIVETABLE') 
		AND 
		COLUMN_NAME = UPPER('DeleteAudit');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE ARCHIVETABLE ADD DeleteAudit NVARCHAR2(1) DEFAULT ''N''';			
			EXECUTE IMMEDIATE('INSERT INTO WFUpgradeLoggingTable VALUES (''DeleteAudit Column added in  ARCHIVETABLE'')');
	END;
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_TABLES  
		WHERE TABLE_NAME = 'WFAUDITTRAILDOCTABLE';
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			EXECUTE IMMEDIATE 
			'CREATE TABLE WFAUDITTRAILDOCTABLE(
				PROCESSDEFID			INT NOT NULL,
				PROCESSINSTANCEID		NVARCHAR2(63),
				WORKITEMID				INT NOT NULL,
				ACTIVITYID				INT NOT NULL,
				DOCID					INT NOT NULL,
				PARENTFOLDERINDEX		INT NOT NULL,
				VOLID					INT NOT NULL,
				APPSERVERIP				NVARCHAR2(63) NOT NULL,
				APPSERVERPORT			INT NOT NULL,
				APPSERVERTYPE			NVARCHAR2(63) NULL,
				ENGINENAME				NVARCHAR2(63) NOT NULL,
				DELETEAUDIT				NVARCHAR2(1) Default ''N'',
				STATUS					CHAR(1)	NOT NULL,
				LOCKEDBY				NVARCHAR2(63)	NULL,
				PRIMARY KEY ( PROCESSINSTANCEID , WORKITEMID)
			)';
			EXECUTE IMMEDIATE('INSERT INTO WFUpgradeLoggingTable VALUES (''Table WFAUDITTRAILDOCTABLE Created successfully'')');
	END;
  
END;

~
call upgrade()

~
drop procedure upgrade
