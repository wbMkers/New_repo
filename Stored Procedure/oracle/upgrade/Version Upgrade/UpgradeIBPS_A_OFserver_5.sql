/*_____________________________________________________________________________________________________________________-
		NEWGEN SOFTWARE TECHNOLOGIES LIMITED

	Group						: Genesis
	Product / Project			: iBPS
	Module						: Transaction Server
	File NAME					: Upgrade.sql (MS Sql Server)
	Author						: Ambuj Tripathi
	Date written (DD/MM/YYYY)	: 08/10/2018
	Description					: This file contains the list of changes done after release of iBPS 4.0
_______________________________________________________________________________________________________________________-
CHANGE HISTORY
25/01/2019		Ravi Ranjan Kumar Bug 82440 - Required to change the exception comments length form 512 to 1024 (PRDP Bug Merging)
29/01/2019	Ravi Ranjan Kumar Bug 82718 - User able to view & search iBps WF system folders .
11-03-2019	Ravi Ranjan			Bug 83511 - PRDP bug merging (Support of multiple image cabinets for archived workitems(Queuehistorytable))
22/03/2019	Mohnish Chopra		Bug 83717 - Support is required to move/save external variables and complex variables data to Secondary cabinet based on some flag SecondaryDBFlag
8/04/2019	Ravi Ranjan Kumar		Bug 83490 - PRDP Bug Metging (Audit Archive utility gets stuck if an error occurs in processing a record)
30/04/2019      Ravi Ranjan Kumar   PRDP Bug Mergin (Bug 83894 - Support to define explicit History Table for the external table instead of hardcoded '_History')
13/05/2019	Ravi Ranjan Kumar Bug 84500 - Support of URN as system variable is required
6/7/2019		Ravi Ranjan Kumar 	Bug 85140 - Enabling to edit workitem (only data and document ) on query workstep if workitem is present on end workstep 
25/10/2019		Ambuj Tripathi	Landing page (Criteria Management) Requirement.
27/12/2019		Chitranshi Nitharia	Bug 89384 - Support for global catalog function framework
02/01/2019		Shahzad Malik		Bug 89626 - Required to reduce fragmentation in UserQueueTable
24/01/2020		Chitranshi Nitharia	Bug 90094 - Creation Of Utility User Via API instead of scripts
06/02/2020		Ambuj Tripathi Bug 90553 - Asynchronous+Jboss-eap-7.2+MSSQL : Data Exchange utility is not working
20/02/2020		Ambuj Tripathi		Bug 90824 - iBPS4.0 based Oracle Cabinet upgrade failed to iBPS5.0
24/03/2020     Shubham Singla  Bug 90785 - iBPS 4.0+Oracle+Postgres: Same insertion order is getting created for the workitems if the same complex table is used in two different processes.
16/04/2020		Chitranshi Nitharia	Bug 91524 - Framework to manage custom utility via ofservices
21/04/2020		Ravi Ranjan Kumar 	Bug 91844 - Support For Process wise volume id. When User deploying the process, then their workitem folder and document upload or created in the volume which is selected by user at the time of process design
02/07/2021      Ravi Raj Mewara     Bug 100086 - IBPS 5 Sp2 Performance : WMFetchWorklist taking 35 40 secs for fetching queues
_______________________________________________________________________________________________________________________-*/

CREATE OR REPLACE PROCEDURE Upgrade AS

	v_existsFlag INT;
	existsFlag INT;
	v_ObjectId			INTEGER;
	v_ObjectTypeId		INTEGER;
	v_UserId			INTEGER;
	v_AssociationType 	INTEGER;
	v_RightString		VARCHAR2(200);
	v_Filter			VARCHAR2(200);
	v_ConstraintName 	VARCHAR2(100);
	v_Query				VARCHAR2(4000);
	TYPE DynamicCursor 	IS REF CURSOR;
	v_Cursor 			DynamicCursor;
	v_STR1				NVARCHAR2(4000);
	v_lastSeqValue			INTEGER;
	v_ProcessDefId			INTEGER;
	v_queueid    			INTEGER;
	v_ActivityID            INTEGER;
	v_STR2			        VARCHAR2(8000);
	cur_streamInfoUpdate 	DynamicCursor;
	cur_queueIDAct 	    	DynamicCursor;
	v_queueName             VARCHAR2(100);
	v_StreamId              INTEGER;
	v_StreamName            VARCHAR2(100);
	v_variableid	 INTEGER;
	Cursor1 DynamicCursor;
	v_rowCount INT;
	v_queryStr VARCHAR2(800);
	V_QUERYSTR1 VARCHAR2(500);
	v_cabinettype VARCHAR2(1);
						   
	
	v_ToDoId INTEGER;
	v_PickListValue NVARCHAR2(50);
	v_PickListOrderId INTEGER;
	v_LastProcessDefId INTEGER;
	v_LastToDoId INTEGER;
	R_COUNT INTEGER;
	V_DELETEUSERQUEUETABLEDATA INT;
	v_folderIndex INT;
	v_volumeId INT;
	v_siteId INT;
	
	c_tablename  VARCHAR2(512);
	v_insertionorderid INTEGER;
	v_length   INTEGER;
	
	V_EXPIRYACTIVITY VARCHAR2(200);
	V_Expiray_ActivityId INT;
	V_COUNT INT;
	V_CONNID INT;
	
 
    --v_lastSeqValue INTEGER;
	CURSOR c_mappedobjectname is 
	select distinct mappedobjectname from varmappingtable inner join wfudtvarmappingtable on varmappingtable.processdefid=wfudtvarmappingtable.processdefid
	and varmappingtable.variableid=wfudtvarmappingtable.variableid WHERE wfudtvarmappingtable.mappedobjecttype ='T' and varmappingtable.unbounded='Y' 
	 and wfudtvarmappingtable.parentvarfieldid=0;
	
	CURSOR  c_mappedobjectname2 is 
	Select DISTINCT c.tablename from WFTypeDefTable a 
			inner join WFUDTVarMappingTable b
			on a.processdefid =b.processdefid
			and a.typefieldid = b.typefieldid 
			and a.ParentTypeId=b.TypeId
			inner join EXTDBCONFTABLE c
			on b.extobjid = c.extobjid
			and b.processdefid=c.processdefid
			and a.unbounded = 'Y';
	
	CURSOR  c_mappedobjectname3 is 
	select distinct b.tablename from varmappingtable a inner join EXTDBCONFTABLE b on a.processdefid=b.processdefid and a.extobjid=b.extobjid and a.unbounded='Y' and a.variabletype != 11 ;
	
	
BEGIN

	V_DELETEUSERQUEUETABLEDATA := 0;

	BEGIN
		SELECT 1 INTO v_existsFlag FROM WFSYSTEMPROPERTIESTABLE WHERE UPPER(PROPERTYKEY) = 'SHAREPOINTFLAG';
    EXCEPTION 
        WHEN NO_DATA_FOUND THEN
			Execute IMMEDIATE ('INSERT  INTO WFSYSTEMPROPERTIESTABLE(PROPERTYKEY, PROPERTYVALUE) values(''SHAREPOINTFLAG'',''N'')');
	END;

    BEGIN
        v_existsFlag := 0;
        SELECT 1 INTO v_existsFlag FROM USER_TABLES WHERE UPPER(TABLE_NAME) = 'WFUNDERLYINGDMS';
    EXCEPTION 
        WHEN NO_DATA_FOUND THEN
            EXECUTE IMMEDIATE ('CREATE TABLE WFUnderlyingDMS (
				DMSType		INT				NOT NULL,
				DMSName		NVARCHAR2(255)	NULL
			)');
    END;

    BEGIN
        v_existsFlag := 0;
        SELECT 1 INTO v_existsFlag FROM USER_TABLES WHERE UPPER(TABLE_NAME) = 'WFDMSLIBRARY';
    EXCEPTION 
        WHEN NO_DATA_FOUND THEN
            EXECUTE IMMEDIATE ('CREATE TABLE WFDMSLibrary (
				LibraryId			INT				NOT NULL 	PRIMARY KEY,
				URL			NVARCHAR2(255)	NULL,
				DocumentLibrary		NVARCHAR2(255)	NULL,
				DOMAINNAME 			NVARCHAR2(64)	NULL
			)');
    END;
    BEGIN
        IF (v_existsFlag = 1) THEN
            BEGIN
                v_existsFlag := 0;
                select 1 into v_existsFlag from user_tab_columns where upper(table_name) = 'WFDMSLIBRARY' and upper(column_name) = 'DOMAINNAME';
            Exception 
                when no_data_found then
                    EXECUTE IMMEDIATE ('alter table WFDMSLIBRARY ADD DOMAINNAME 	NVARCHAR2(64) NULL');
            END;
        END IF;
    END;
	
    BEGIN
        v_existsFlag := 0;
        SELECT 1 INTO v_existsFlag FROM USER_TABLES WHERE UPPER(TABLE_NAME) = 'WFPROCESSSHAREPOINTASSOC';
    EXCEPTION 
        WHEN NO_DATA_FOUND THEN
            EXECUTE IMMEDIATE ('CREATE TABLE WFProcessSharePointAssoc (
				ProcessDefId			INT		NOT NULL,
				LibraryId				INT		NULL,
				PRIMARY KEY (ProcessDefId)
			)');
    END;
	
    BEGIN
        v_existsFlag := 0;
        SELECT 1 INTO v_existsFlag FROM USER_TABLES WHERE UPPER(TABLE_NAME) = 'WFSHAREPOINTINFO';
    EXCEPTION 
        WHEN NO_DATA_FOUND THEN
            EXECUTE IMMEDIATE ('CREATE TABLE WFSharePointInfo (
				ServiceURL		NVARCHAR2(255)	NULL,
				ProxyEnabled	NVARCHAR2(200)	NULL,
				ProxyIP			NVARCHAR2(20)	NULL,
				ProxyPort		NVARCHAR2(200)	NULL,
				ProxyUser		NVARCHAR2(200)	NULL,
				ProxyPassword	NVARCHAR2(512)	NULL,
				SPWebUrl		NVARCHAR2(200)	NULL
			)');
    END;
	
    BEGIN
        v_existsFlag := 0;
        SELECT 1 INTO v_existsFlag FROM USER_TABLES WHERE UPPER(TABLE_NAME) = 'WFARCHIVEINSHAREPOINT';
    EXCEPTION 
        WHEN NO_DATA_FOUND THEN
            EXECUTE IMMEDIATE ('CREATE TABLE WFArchiveInSharePoint (
				ProcessDefId			INT				NULL,
				ActivityID				INT				NULL,
				URL					 	NVARCHAR2(255)	NULL,		
				SiteName				NVARCHAR2(255)	NULL,
				DocumentLibrary			NVARCHAR2(255)	NULL,
				FolderName				NVARCHAR2(255)	NULL,
				ServiceURL 				NVARCHAR2(255) 	NULL,
				DiffFolderLoc			NVARCHAR2(2) 	NULL,
				SameAssignRights		NVARCHAR2(2) 	NULL,
				DOMAINNAME 				NVARCHAR2(64)	NULL
			)');
    END;
    BEGIN
        IF (v_existsFlag = 1) THEN
            BEGIN
                v_existsFlag := 0;
                select 1 into v_existsFlag from user_tab_columns where upper(table_name) = 'WFARCHIVEINSHAREPOINT' and upper(column_name) = 'DOMAINNAME';
            Exception 
                when no_data_found then
                    EXECUTE IMMEDIATE ('alter table WFARCHIVEINSHAREPOINT ADD DOMAINNAME	NVARCHAR2(64)	NULL');
            END;
        END IF;
    END;
	
    BEGIN
        v_existsFlag := 0;
        SELECT 1 INTO v_existsFlag FROM USER_TABLES WHERE UPPER(TABLE_NAME) = 'WFSHAREPOINTDATAMAPTABLE';
    EXCEPTION 
        WHEN NO_DATA_FOUND THEN
            EXECUTE IMMEDIATE ('CREATE TABLE WFSharePointDataMapTable (
				ProcessDefId			INT				NULL,
				ActivityID				INT				NULL,
				FieldId					INT				NULL,
				FieldName				NVARCHAR2(255)	NULL,
				FieldType				INT				NULL,
				MappedFieldName			NVARCHAR2(255)	NULL,
				VariableID				NVARCHAR2(255)	NULL,
				VarFieldID				NVARCHAR2(255)	NULL
			)');
    END;
	
    BEGIN
        v_existsFlag := 0;
        SELECT 1 INTO v_existsFlag FROM USER_TABLES WHERE UPPER(TABLE_NAME) = 'WFSHAREPOINTDOCASSOCTABLE';
    EXCEPTION 
        WHEN NO_DATA_FOUND THEN
            EXECUTE IMMEDIATE ('CREATE TABLE WFSharePointDocAssocTable (
				ProcessDefId			INT				NULL,
				ActivityID				INT				NULL,
				DocTypeID				INT				NULL,
				AssocFieldName			NVARCHAR2(255)	NULL,
				FolderName				NVARCHAR2(255)	NULL,
				TARGETDOCNAME			NVARCHAR2(255)	NULL
			)');
    END;
    BEGIN
        IF (v_existsFlag = 1) THEN
            BEGIN
                v_existsFlag := 0;
                select 1 into v_existsFlag from user_tab_columns where upper(table_name) = 'WFSHAREPOINTDOCASSOCTABLE' and upper(column_name) = 'TARGETDOCNAME';
            Exception 
                when no_data_found then
                    EXECUTE IMMEDIATE ('alter table WFSHAREPOINTDOCASSOCTABLE ADD TARGETDOCNAME	NVARCHAR2(255)	NULL');
            END;
        END IF;
    END;
	
	BEGIN
			
		existsFlag :=0;	
		BEGIN 
				SELECT 1 INTO existsFlag 
				FROM USER_TABLES  
				WHERE TABLE_NAME = UPPER('WFInitiationAgentReportTable');
			EXCEPTION 
				WHEN NO_DATA_FOUND THEN 
					EXECUTE IMMEDIATE 
					'create table WFInitiationAgentReportTable(
							LogId INT ,
							EmailReceivedDateTime DATE,
							MailFrom NVARCHAR2(2000),
							MailTo NVARCHAR2(2000),
							MailSubject NVARCHAR2(2000),
							MailCC NVARCHAR2(2000),
							EmailFileName NVARCHAR2(200),
							EMailStatus NVARCHAR2(100),
							ActionDateTime DATE,
							ProcessInstanceId NVARCHAR2(200),
							ActionDescription NVARCHAR2(2000),
							ProcessDefId INT,
							ActivityId INT
							)';	
		--dbms_output.put_line ('Table WFInitiationAgentReportTable Created successfully');
		END;
	/* seq_userlogid for Bug 76093 - EAP7+sql: User filter is not working for 'Set preferences' audit log option */
			existsFlag :=0;
			BEGIN
					SELECT 1 INTO existsFlag 
							FROM USER_SEQUENCES  
							WHERE Upper(SEQUENCE_NAME) = UPPER('seq_userlogid');
				EXCEPTION
					WHEN NO_DATA_FOUND THEN
					EXECUTE IMMEDIATE 
					'CREATE SEQUENCE seq_userlogid START WITH 1 INCREMENT BY 1 NOCACHE';
						--dbms_output.put_line ('Sequence seq_userlogid Created successfully');
			END;

			existsFlag :=0;
			BEGIN
					SELECT 1 INTO existsFlag 
							FROM USER_SEQUENCES  
							WHERE Upper(SEQUENCE_NAME) = UPPER('SEQ_InitAgentReport');
				EXCEPTION
					WHEN NO_DATA_FOUND THEN
					EXECUTE IMMEDIATE 
					'CREATE SEQUENCE SEQ_InitAgentReport START WITH 1 INCREMENT BY 1 NOCACHE';
						--dbms_output.put_line ('Sequence SEQ_InitAgentReport Created successfully');
			END;
		

	END;
	
	BEGIN 
		existsFlag := 0;
		select 1 into existsFlag from user_tab_columns where upper(table_name) = upper('WFInitiationAgentReportTable') and upper(column_name) = upper('IAId');
		EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
		
			EXECUTE IMMEDIATE ('ALTER TABLE WFInitiationAgentReportTable ADD IAId NVARCHAR2(50)  NULL ');
		
			EXECUTE IMMEDIATE ('ALTER TABLE WFInitiationAgentReportTable ADD AccountName NVARCHAR2(100)  NULL ');

			EXECUTE IMMEDIATE ('ALTER TABLE WFInitiationAgentReportTable ADD NoOfAttachments INT NULL ');
			
			EXECUTE IMMEDIATE ('ALTER TABLE WFInitiationAgentReportTable ADD SizeOfAttachments NVARCHAR2(1000) NULL ');
			
	END;
	
	BEGIN 
			existsFlag := 0;
			SELECT 1 INTO existsFlag 
			FROM USER_TABLES  
			WHERE TABLE_NAME = UPPER('WFEXPORTMAPTABLE');
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
				EXECUTE IMMEDIATE 
				'CREATE TABLE WFEXPORTMAPTABLE(
					ProcessDefId Integer,
					ActivityId Integer,
					ExportLocation nvarchar2(2000),
					CurrentCount nvarchar2(100),
					Counter nvarchar2(100),
					RecordFlag nvarchar2(100)
				)';
				dbms_output.put_line ('Table WFEXPORTMAPTABLE Created successfully');
	END;	


	/*Changes for Rights Management*/
	BEGIN
		existsFlag :=0;	
		select 1 into existsFlag from user_tab_columns where upper(table_name) = upper('PROCESSDEFTABLE') and upper(column_name) = upper('RegPrefix');
		IF( existsFlag = 1) THEN
			EXECUTE IMMEDIATE ('Alter table PROCESSDEFTABLE MODIFY RegPrefix NVARCHAR2(20)');
		END IF;
	END;
	
	BEGIN
		existsFlag :=0;	
		select 1 into existsFlag from user_tab_columns where upper(table_name) = upper('WFUserObjAssocTable') and upper(column_name) = upper('RightString');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN 
			BEGIN
      
               BEGIN 
			   
						  SELECT CONSTRAINT_NAME INTO v_ConstraintName FROM user_constraints WHERE table_name = UPPER('WFUserObjAssocTable') AND constraint_type = 'P';
						  IF (v_ConstraintName IS NOT NULL AND length(v_ConstraintName) > 0) THEN
							EXECUTE IMMEDIATE ('ALTER TABLE WFUserObjAssocTable DROP CONSTRAINT ' ||  v_ConstraintName);
						END IF;
						EXCEPTION WHEN NO_DATA_FOUND THEN 
						
							BEGIN
							DBMS_OUTPUT.PUT_LINE('No Data Found');
							END;
               END;
			   
			    BEGIN 
			   
					SELECT CONSTRAINT_NAME INTO v_ConstraintName FROM user_constraints WHERE table_name = UPPER('WFProfileObjTypeTable') AND constraint_type = 'P';
					IF (v_ConstraintName IS NOT NULL AND length(v_ConstraintName) > 0) THEN
					  EXECUTE IMMEDIATE('ALTER TABLE WFProfileObjTypeTable DROP CONSTRAINT ' ||  v_ConstraintName);
					END IF;
					EXCEPTION WHEN NO_DATA_FOUND THEN 
						
						BEGIN
						DBMS_OUTPUT.PUT_LINE('No Data Found');
						END;
                END;
        
				Execute IMMEDIATE ('Alter table WFUserObjAssocTable Add RightString NVARCHAR2(100) Default ''1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111''  NOT NULL' );
				
				Execute IMMEDIATE ('Alter table WFUserObjAssocTable Add Filter NVARCHAR2(255)');
				
				EXECUTE IMMEDIATE ('ALTER TABLE WFUserObjAssocTable ADD PRIMARY KEY (ObjectId, ObjectTypeId, ProfileId, UserId, AssociationType, RightString)');
				
				BEGIN
					OPEN v_Cursor FOR Select A.ObjectId, A.ObjectTypeId, A.AssociationType, A.UserId, C.RightString, C.Filter as RightStringCasted FROM WFUserObjAssocTable A, WFObjectListTable B, WFProfileObjTypeTable C WHERE A.ObjectTypeId = B.ObjectTypeId AND A.ObjectTypeId = C.ObjectTypeId AND A.associationType = C.associationType AND A.userid = C.userid AND A.Profileid = 0;
					LOOP
					    DBMS_OUTPUT.PUT_LINE('befor fetch');
						FETCH v_Cursor INTO v_ObjectId, v_ObjectTypeId, v_AssociationType, v_UserId, v_RightString, v_Filter;
						DBMS_OUTPUT.PUT_LINE('after fetch');
						EXIT WHEN v_Cursor%NOTFOUND;
						
					   -- v_STR1 := 'Update WFUserObjAssocTable set RightString = ''' || v_RightString || ''', Filter  = ''' || v_Filter || ''' Where Objectid = ' || TO_CHAR(v_ObjectId) || ' And ObjectTypeId = ' || TO_CHAR(v_ObjectTypeId) || ' And AssociationType = ' || TO_CHAR(v_AssociationType) || ' And UserId = ' || TO_CHAR(v_UserId) || ' And ProfileId = 0';
						--DBMS_OUTPUT.PUT_LINE(v_STR1);
						EXECUTE IMMEDIATE('Update WFUserObjAssocTable set RightString = ''' || v_RightString || ''', Filter  = ''' || v_Filter || ''' Where Objectid = ' || TO_CHAR(v_ObjectId) || ' And ObjectTypeId = ' || TO_CHAR(v_ObjectTypeId) || ' And AssociationType = ' || TO_CHAR(v_AssociationType) || ' And UserId = ' || TO_CHAR(v_UserId) || ' And ProfileId = 0');
					    --EXECUTE IMMEDIATE v_STR1;

					END LOOP;
					CLOSE v_Cursor;
				END;
				
				
				
				EXECUTE IMMEDIATE('Insert into WFUserObjAssocTable (ObjectId, ObjectTypeId, ProfileId, UserId, AssociationType, AssignedTillDateTime, AssociationFlag, RightString, Filter) Select DISTINCT -1, ObjectTypeId, 0, UserId, AssociationType, Null, Null, RightString, Filter FROM WFProfileObjTypeTable where AssociationType IN (0,1) and ObjectTypeId not in (1,2,4,6,12,13)');
			END;
	END;
	-------------Rights management changes ends here
	BEGIN
		v_STR2 := 'Select processdefid,ActivityId,StreamId,StreamName from STREAMDEFTABLE order by processdefid,ActivityId,StreamId';	
		OPEN cur_streamInfoUpdate FOR v_STR2;
		LOOP
			FETCH cur_streamInfoUpdate INTO v_ProcessDefId,v_ActivityID,v_StreamId,v_StreamName; 
			EXIT WHEN cur_streamInfoUpdate%NOTFOUND;
			BEGIN
				Select Count(*) into existsFlag from RuleConditionTable where processdefid = v_ProcessDefId and ActivityId=v_ActivityID and RuleType='S' ;
				IF existsFlag = 0 and v_StreamName = 'Default' THEN
					insert into RuleConditionTable (ProcessDefId,ActivityId,RuleType,RuleOrderId,RuleId,ConditionOrderId,Param1,Type1,ExtObjID1,VariableId_1,VarFieldId_1,Param2,Type2,ExtObjID2,VariableId_2,VarFieldId_2,Operator,LogicalOp) values(v_ProcessDefId,v_ActivityID,'S',1,v_StreamId,1,'ALWAYS','S',0,0,0,'ALWAYS','S',0,0,0,4,4);
					COMMIT;
				END IF;
			END;
		END LOOP;
		CLOSE cur_streamInfoUpdate; 
	END;
	
	BEGIN
		existsFlag :=0;	
		select 1 into existsFlag from user_tab_columns where upper(table_name) = 'TODOPICKLISTTABLE' and upper(column_name) = 'PICKLISTORDERID';
		Exception when no_data_found then
			EXECUTE IMMEDIATE ('Alter table TODOPICKLISTTABLE ADD PickListOrderId INTEGER');
	END;
	
	BEGIN
		v_existsFlag :=0;	
		select 1 into v_existsFlag from user_tab_columns where upper(table_name) = UPPER('WFUDTVarMappingTable') and upper(column_name) = UPPER('MappedViewName');
		Exception 
			when no_data_found then
			EXECUTE IMMEDIATE ('ALTER TABLE WFUDTVarMappingTable ADD MappedViewName      NVARCHAR2(256)      NULL');
	END;
	BEGIN
		v_existsFlag :=0;	
		select 1 into v_existsFlag from user_tab_columns where upper(table_name) = UPPER('WFUDTVarMappingTable') and upper(column_name) = UPPER('IsView');
		Exception when no_data_found then
			EXECUTE IMMEDIATE ('Alter table WFUDTVarMappingTable ADD  IsView          	NVARCHAR2(1)    DEFAULT N''N'' NOT NULL');
	END;
	
	BEGIN
		existsFlag :=0;	
		SELECT 1 INTO existsFlag FROM USER_SEQUENCES  WHERE SEQUENCE_NAME = UPPER('WFFailFileRecords_SEQ');
		EXCEPTION WHEN no_data_found THEN
			EXECUTE IMMEDIATE 'CREATE SEQUENCE WFFailFileRecords_SEQ INCREMENT BY 1 START WITH 1';
	END;
	
	BEGIN 
		existsFlag :=0;	
		SELECT 1 INTO existsFlag FROM USER_TRIGGERS where Trigger_name = UPPER('WFFailFileRecords_TRG');
		EXCEPTION WHEN no_data_found THEN
		EXECUTE IMMEDIATE('CREATE OR REPLACE TRIGGER WFFailFileRecords_TRG BEFORE INSERT ON WFFailFileRecords FOR EACH ROW
		BEGIN
			SELECT WFFailFileRecords_SEQ.NEXTVAL INTO :NEW.FailRecordId FROM DUAL;
		END;');
		
	END;

	existsFlag := 0;
	BEGIN
		BEGIN
		SELECT COUNT(1) INTO existsFlag FROM USER_TAB_COLUMNS WHERE TABLE_NAME=UPPER('EXCEPTIONTABLE') AND COLUMN_NAME=UPPER('EXCEPTIONCOMMENTS');
		IF (existsFlag=1) THEN
		BEGIN
			v_existsFlag :=0;
			SELECT 1 into v_existsFlag from user_tab_columns where table_name = UPPER('EXCEPTIONTABLE') and column_name = UPPER('EXCEPTIONCOMMENTS') and
				char_col_decl_length < 1024;
			IF v_existsFlag = 1 THEN
			BEGIN
				EXECUTE IMMEDIATE 'ALTER TABLE EXCEPTIONTABLE MODIFY (ExceptionComments NVARCHAR2(1024))';
			END;
			END IF;
			EXCEPTION
					WHEN NO_DATA_FOUND THEN
					BEGIN
						DBMS_OUTPUT.PUT_LINE('Size of column in ExceptionComments column in ExceptionTable');
					END;
		END;
		END IF;
		END;
	EXCEPTION
		WHEN OTHERS THEN
			raise_application_error(-20444,'Increasing size of ExceptionComments in ExceptionTable Failed.');
			RETURN;
	END;
	
	
		
	existsFlag := 0;
	BEGIN
		BEGIN
		SELECT COUNT(1) INTO existsFlag FROM USER_TAB_COLUMNS WHERE TABLE_NAME=UPPER('EXCEPTIONHISTORYTABLE') AND COLUMN_NAME=UPPER('EXCEPTIONCOMMENTS');
		IF (existsFlag=1) THEN
		BEGIN
			v_existsFlag :=0;
			SELECT 1 into v_existsFlag from user_tab_columns where table_name = 'EXCEPTIONHISTORYTABLE' and column_name = 'EXCEPTIONCOMMENTS' and char_col_decl_length < 1024;
			IF v_existsFlag = 1 THEN
			BEGIN
				EXECUTE IMMEDIATE 'ALTER TABLE EXCEPTIONHISTORYTABLE MODIFY (ExceptionComments NVARCHAR2(1024))';
			END;
			END IF;
			EXCEPTION
					WHEN NO_DATA_FOUND THEN
					BEGIN
						DBMS_OUTPUT.PUT_LINE('Size of column in ExceptionComments column in ExceptionHistoryTable');
					END;
		END;
		END IF;
		END;
	EXCEPTION
		WHEN OTHERS THEN
			raise_application_error(-20445,'Increasing size of ExceptionComments in ExceptionHistoryTable Failed.');
			RETURN;
	END;
	
	BEGIN
	v_existsFlag :=0;	
	select 1 into v_existsFlag from user_tab_columns where upper(table_name) = 'PROCESSDEFTABLE' and upper(column_name) = UPPER('ISSecureFolder');
	Exception when no_data_found then
		EXECUTE IMMEDIATE ('ALTER TABLE PROCESSDEFTABLE ADD ISSecureFolder CHAR(1) DEFAULT ''N'' NOT NULL CONSTRAINT CK_ISSecureFolder CHECK (ISSecureFolder IN (''Y'', ''N''))');
	END;
	
	BEGIN
	v_existsFlag :=0;	
	select 1 into v_existsFlag from user_tab_columns where upper(table_name) = 'QUEUEHISTORYTABLE' and upper(column_name) = UPPER('IMAGECABNAME');
	Exception when no_data_found then
		EXECUTE IMMEDIATE ('ALTER TABLE QUEUEHISTORYTABLE ADD IMAGECABNAME NVARCHAR2(100)');
	END;
	
	Begin
	v_existsFlag := 0;
		SELECT 1 INTO v_existsFlag FROM user_indexes WHERE UPPER(index_name)=UPPER('IX1_WFEscalationTable') AND upper(table_name)=upper('WFEscalationTable');
		IF v_existsFlag=1 THEN
				EXECUTE IMMEDIATE 'DROP INDEX IX1_WFEscalationTable';
				DBMS_OUTPUT.PUT_LINE ('Index IX1_WFEscalationTable dropped');
		END IF;
	EXCEPTION
			WHEN NO_DATA_FOUND THEN
				DBMS_OUTPUT.PUT_LINE ('Index IX1_WFEscalationTable Not Found');
	END;
	
	Begin
	v_existsFlag := 0;
		BEGIN
		SELECT 1 INTO v_existsFlag FROM user_indexes WHERE UPPER(index_name)=UPPER('IDX2_WFEscalationTable') AND upper(table_name)=upper('WFEscalationTable');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				EXECUTE IMMEDIATE 'CREATE INDEX IDX2_WFEscalationTable ON WFEscalationTable (ScheduleTime)';
				DBMS_OUTPUT.PUT_LINE ('Index IDX2_WFESCALATIONTABLE created');
		END;
	EXCEPTION
		WHEN OTHERS THEN
		raise_application_error(-20436, 'IDX2_WFEscalationTable creation Failed.');
		RETURN;
	END;
	
	Begin
	v_existsFlag := 0;
		BEGIN
		SELECT 1 INTO v_existsFlag FROM user_indexes WHERE UPPER(index_name)=UPPER('IDX3_WFEscalationTable') AND upper(table_name)=upper('WFEscalationTable');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				EXECUTE IMMEDIATE 'CREATE INDEX IDX3_WFEscalationTable ON WFEscalationTable (ProcessInstanceId,WorkitemId)';
				DBMS_OUTPUT.PUT_LINE ('Index IDX3_WFEscalationTable created');
		END;
	EXCEPTION
		WHEN OTHERS THEN
		raise_application_error(-20437, 'IDX3_WFEscalationTable creation Failed.');
		RETURN;
	END;
	
	Begin
	v_existsFlag := 0;
		BEGIN
		SELECT CONSTRAINT_NAME INTO v_ConstraintName FROM user_constraints WHERE table_name = UPPER('WFEscalationTable') AND constraint_type = 'P';
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				EXECUTE IMMEDIATE 'ALTER TABLE WFEscalationTable MODIFY EscalationId Integer PRIMARY KEY';
				DBMS_OUTPUT.PUT_LINE ('EscalationId modified to primary key');
		END;
	EXCEPTION
		WHEN OTHERS THEN
		raise_application_error(-20438, 'EscalationId modification failed.');
		RETURN;
	END;
	
	BEGIN
		 SELECT VariableId INTO v_variableid FROM VarMappingTable WHERE UPPER(SystemDefinedName) = UPPER('SecondaryDBFlag');
		v_rowCount := SQL%ROWCOUNT;
	EXCEPTION
	WHEN OTHERS THEN
		v_rowCount := 0;
	END;
	IF(v_rowCount < 1) THEN
	BEGIN
		SAVEPOINT SecondaryDBFlagAddition;

			v_queryStr := 'SELECT distinct(ProcessDefId) FROM VarMappingTable';
			OPEN Cursor1 FOR v_queryStr;
			LOOP
				FETCH Cursor1 INTO v_ProcessDefId;
				EXIT WHEN Cursor1%NOTFOUND;

				EXECUTE IMMEDIATE 'insert into varmappingtable (ProcessDefId, variableId, SystemDefinedName, UserDefinedName, 
				VariableType, VariableScope, ExtObjId, DefaultValue, VariableLength, VarPrecision, Unbounded,ProcessVariantId,IsEncrypted,IsMasked,MaskingPattern) 
				values('||To_Char(v_ProcessDefId)|| '	, 10022, ''SecondaryDBFlag'', ''SecondaryDBFlag'', 10, ''M'', 0, ''N'', NULL, 0, ''N'',0,''N'',''N'',''X'')';				
			END LOOP;
			CLOSE Cursor1;
		COMMIT;
	EXCEPTION
	WHEN OTHERS THEN
		ROLLBACK TO SAVEPOINT SecondaryDBFlagAddition;
		CLOSE Cursor1;
	END;
	END IF;
	
	BEGIN
		v_existsFlag :=0;	
		select 1 into v_existsFlag from user_tab_columns where upper(table_name) = upper('WFINSTRUMENTTABLE') and upper(column_name) = upper('SecondaryDBFlag');
		Exception when no_data_found then
			EXECUTE IMMEDIATE ('Alter table WFINSTRUMENTTABLE add SecondaryDBFlag				NVARCHAR2(1)    Default ''N'' NOT NULL CHECK (SecondaryDBFlag IN (N''Y'', N''N'',N''U'',N''D''))');
	END;
	
	BEGIN
		v_existsFlag :=0;	
		select 1 into v_existsFlag from user_tab_columns where upper(table_name) = upper('QUEUEHISTORYTABLE') and upper(column_name) = upper('SecondaryDBFlag');
		Exception when no_data_found then
			EXECUTE IMMEDIATE ('Alter table QUEUEHISTORYTABLE add SecondaryDBFlag				NVARCHAR2(1)    Default ''N'' NOT NULL CHECK (SecondaryDBFlag IN (N''Y'', N''N'',N''U'',N''D''))');
	END;
	
	BEGIN
		BEGIN
			SELECT 1 INTO existsFlag FROM USER_TAB_COLUMNS WHERE TABLE_NAME = UPPER('TODOPICKLISTTABLE') AND COLUMN_NAME = UPPER('PickListOrderId');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
			BEGIN
				EXECUTE IMMEDIATE 'ALTER TABLE TODOPICKLISTTABLE ADD PickListOrderId INTEGER';
				v_LastProcessDefId := -1;
				v_LastToDoId := -1;
				v_PickListOrderId := -1;
				v_queryStr := 'SELECT ProcessDefId, ToDoId, PickListValue FROM TODOPICKLISTTABLE ORDER BY ProcessDefId ASC, ToDoId ASC';
				OPEN Cursor1 FOR v_queryStr;
				LOOP
					FETCH Cursor1 INTO v_ProcessDefId, v_ToDoId, v_PickListValue;
					EXIT WHEN Cursor1%NOTFOUND;
					IF (v_LastProcessDefId <> v_ProcessDefId OR v_LastToDoId <> v_ToDoId) THEN
						v_PickListOrderId := 1;
					END IF;
					v_queryStr := 'UPDATE TODOPICKLISTTABLE SET PickListOrderId = ' || v_PickListOrderId || ' WHERE ProcessDefId = ' || v_ProcessDefId || ' AND ToDoId = ' || v_ToDoId || ' AND PickListValue = ''' || v_PickListValue || '''';
					EXECUTE IMMEDIATE v_queryStr;
					COMMIT;
					v_PickListOrderId := v_PickListOrderId + 1;
					v_LastProcessDefId := v_ProcessDefId;
					v_LastToDoId := v_ToDoId;
				END LOOP;
				CLOSE Cursor1;
			END;
		END;
	EXCEPTION
		WHEN OTHERS THEN
			raise_application_error(-20221, ' TODOPICKLISTTABLE FAILED');
	END;
	
	BEGIN
		BEGIN
			SELECT 1 INTO existsFlag FROM USER_TAB_COLUMNS WHERE TABLE_NAME = UPPER('TODOPICKLISTTABLE') AND COLUMN_NAME = UPPER('PickListId');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
			BEGIN
				EXECUTE IMMEDIATE 'ALTER TABLE TODOPICKLISTTABLE ADD PickListId INTEGER';
				v_LastProcessDefId := -1;
				v_LastToDoId := -1;
				v_PickListOrderId := -1;
				v_queryStr := 'SELECT ProcessDefId, ToDoId, PickListValue FROM TODOPICKLISTTABLE ORDER BY ProcessDefId ASC, ToDoId ASC';
				OPEN Cursor1 FOR v_queryStr;
				LOOP
					FETCH Cursor1 INTO v_ProcessDefId, v_ToDoId, v_PickListValue;
					EXIT WHEN Cursor1%NOTFOUND;
					IF (v_LastProcessDefId <> v_ProcessDefId OR v_LastToDoId <> v_ToDoId) THEN
						v_PickListOrderId := 1;
					END IF;
					v_queryStr := 'UPDATE TODOPICKLISTTABLE SET PickListId = ' || v_PickListOrderId  || ' WHERE ProcessDefId = ' || v_ProcessDefId || ' AND ToDoId = ' || v_ToDoId || ' AND PickListValue = ''' || v_PickListValue || '''';
					EXECUTE IMMEDIATE v_queryStr;
					COMMIT;
					v_PickListOrderId := v_PickListOrderId + 1;
					v_LastProcessDefId := v_ProcessDefId;
					v_LastToDoId := v_ToDoId;
				END LOOP;
				CLOSE Cursor1;
				EXECUTE IMMEDIATE 'ALTER TABLE TODOPICKLISTTABLE MODIFY PickListId INTEGER NOT NULL';
			END;
		END;
	EXCEPTION
		WHEN OTHERS THEN
			raise_application_error(-20221,  ' BLOCK 21 FAILED');
	END;
	
	BEGIN
		SELECT COUNT(1) INTO existsFlag FROM all_cons_columns WHERE constraint_name = (SELECT constraint_name FROM user_constraints WHERE UPPER(table_name) = UPPER('WFAuditTrailDocTable') AND CONSTRAINT_TYPE = 'P');
		IF (existsFlag <> 3) THEN
		BEGIN
			EXECUTE IMMEDIATE('ALTER TABLE WFAuditTrailDocTable DROP PRIMARY KEY');
			EXECUTE IMMEDIATE('ALTER TABLE WFAuditTrailDocTable ADD PRIMARY KEY(ProcessInstanceId, WorkItemId, ActivityId)');
		END;
		END IF;
	EXCEPTION
		WHEN OTHERS THEN
			raise_application_error(-20223, ' BLOCK 23 FAILED');
	END;
	
	existsFlag := 0;
	BEGIN
		BEGIN
			SELECT 1 INTO existsFlag FROM USER_TAB_COLUMNS WHERE TABLE_NAME=UPPER('ExtDBConfTable') AND COLUMN_NAME=UPPER('HistoryTableName');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				EXECUTE IMMEDIATE 'ALTER TABLE ExtDBConfTable ADD HistoryTableName NVARCHAR2(128)';
		END;
	EXCEPTION
		WHEN OTHERS THEN  
			raise_application_error(-20224,' BLOCK 24 FAILED');
	END;
	BEGIN
	select 1 into v_existsFlag from user_tab_columns where upper(table_name) = upper('GTempQueueTable') and upper(column_name) = upper('TempComments');
	Exception when no_data_found then
		EXECUTE IMMEDIATE ('DROP TABLE GTempQueueTable');
		EXECUTE IMMEDIATE('CREATE GLOBAL TEMPORARY TABLE GTempQueueTable (
			TempQueueId			Int, 
			TempQueueName			NVarchar2(64), 
			TempQueueType			Char(1), 
			TempAllowReassignment		Char(1), 
			TempFilterOption		Int, 
			TempFilterValue			NVarchar2(64), 
			TempAssignedTillDatetime	Date, 	
			TotalWorkItems			Int, 
			TotalActiveUsers		Int, 
			LoginUsers			Int, 
			Delayed				Int, 
			totalassignedtouser		Int, 
			totalusers			Int,
			TempRefreshInterval		Int,
			TempOrderBy			int, 
			TempSortOrder			NVarchar2(1),
			TempProcessName			NVarchar2(30)	NULL,
			TempComments  NVARCHAR2(255)	NULL
		) ON COMMIT PRESERVE ROWS');
	END;
	
	BEGIN
		 SELECT VariableId INTO v_variableid FROM VarMappingTable WHERE UPPER(SystemDefinedName) = UPPER('URN');
		v_rowCount := SQL%ROWCOUNT;
	EXCEPTION
	WHEN OTHERS THEN
		v_rowCount := 0;
	END;
	IF(v_rowCount < 1) THEN
	BEGIN
		SAVEPOINT SecondaryDBFlagAddition;

			v_queryStr := 'SELECT distinct(ProcessDefId) FROM VarMappingTable';
			OPEN Cursor1 FOR v_queryStr;
			LOOP
				FETCH Cursor1 INTO v_ProcessDefId;
				EXIT WHEN Cursor1%NOTFOUND;

				EXECUTE IMMEDIATE 'insert into VarMappingTable (ProcessDefId,VariableId,SystemDefinedName,UserDefinedName,VariableType,VariableScope,ExtObjId,DefaultValue,VariableLength,VarPrecision,Unbounded)  values('||To_Char(v_ProcessDefId)|| ',  10023,    ''URN'',''URN'',     10,    ''S''    ,0,    ''N'',    63   ,0    ,''N'')';				
			END LOOP;
			CLOSE Cursor1;
		COMMIT;
	EXCEPTION
	WHEN OTHERS THEN
		ROLLBACK TO SAVEPOINT SecondaryDBFlagAddition;
		CLOSE Cursor1;
	END;
	END IF;
	
	
	BEGIN
	v_existsFlag :=0;
	select 1 into v_existsFlag from user_tab_columns where upper(table_name) = upper('QUEUEUSERTABLE') and upper(column_name) = upper('EDITABLEONQUERY');
	Exception when no_data_found then
		EXECUTE IMMEDIATE ('Alter table QUEUEUSERTABLE ADD  EDITABLEONQUERY NVARCHAR2(1)  DEFAULT N''N'' NOT NULL');
	END;
	
	BEGIN
	v_existsFlag :=0;	
	select 1 into v_existsFlag from user_tab_columns where upper(table_name) = upper('QUSERGROUPVIEW') and upper(column_name) = upper('EDITABLEONQUERY') ;
	Exception when no_data_found then
		EXECUTE IMMEDIATE ('CREATE OR REPLACE VIEW QUSERGROUPVIEW AS SELECT * FROM ( SELECT queueid,userid, cast ( NULL AS integer ) AS GroupId,assignedtilldatetime , queryFilter,QueryPreview , EDITABLEONQUERY FROM QUEUEUSERTABLE WHERE associationtype=0 AND ( assignedtilldatetime is NULL OR assignedtilldatetime>=sysdate ) UNION SELECT queueid, userindex,userid AS groupid, assignedtilldatetime, queryFilter,QueryPreview , EDITABLEONQUERY FROM QUEUEUSERTABLE,wfgroupmemberview WHERE associationtype=1  AND QUEUEUSERTABLE.userid=wfgroupmemberview.groupindex )a');
	END;
	
	existsFlag := 0;
	BEGIN
		BEGIN
			SELECT 1 INTO existsFlag FROM USER_TAB_COLUMNS WHERE TABLE_NAME=UPPER('WFDOCBUFFER') AND COLUMN_NAME=UPPER('ATTACHMENTNAME');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				EXECUTE IMMEDIATE 'ALTER TABLE WFDOCBUFFER ADD ATTACHMENTNAME NVARCHAR2(255)  DEFAULT N''Attachment'' NOT NULL';
		END;
	EXCEPTION
		WHEN OTHERS THEN  
			raise_application_error(-20228,' BLOCK 28 FAILED');
	END;
	
	
	existsFlag := 0;
	BEGIN
		BEGIN
			SELECT 1 INTO existsFlag FROM USER_TAB_COLUMNS WHERE TABLE_NAME=UPPER('WFDOCBUFFER') AND COLUMN_NAME=UPPER('ATTACHMENTTYPE');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				EXECUTE IMMEDIATE 'ALTER TABLE WFDOCBUFFER ADD ATTACHMENTTYPE NVARCHAR2(1)  DEFAULT N''A'' NOT NULL';
		END;
	EXCEPTION
		WHEN OTHERS THEN  
			raise_application_error(-20229,' BLOCK 29 FAILED');
	END;
	
	existsFlag := 0;
	BEGIN
		BEGIN
			SELECT 1 INTO existsFlag FROM USER_TAB_COLUMNS WHERE TABLE_NAME=UPPER('WFDOCBUFFER') AND COLUMN_NAME=UPPER('REQUIREMENTID');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				EXECUTE IMMEDIATE 'ALTER TABLE WFDOCBUFFER ADD REQUIREMENTID int  DEFAULT -1 NOT NULL';
		END;
	EXCEPTION
		WHEN OTHERS THEN  
			raise_application_error(-20230,' BLOCK 30 FAILED');
	END;
	
	
	BEGIN
		BEGIN
			SELECT 1 INTO existsFlag FROM user_tables WHERE UPPER(TABLE_NAME)=UPPER('WFRulesTable') ;
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				EXECUTE IMMEDIATE 'CREATE TABLE WFRulesTable (
    ProcessDefId            INT                NOT NULL,
    ActivityID              INT                NOT NULL,
    RuleId                  INT                NOT NULL,
    Condition               NVARCHAR2(255)    NOT NULL,
    Action                  NVARCHAR2(255)    NOT NULL    
)';
		END;
	EXCEPTION
		WHEN OTHERS THEN  
			raise_application_error(-20231,' BLOCK 31 FAILED');
	END;
	
	
	
	BEGIN
		BEGIN
			SELECT 1 INTO existsFlag FROM user_tables WHERE UPPER(TABLE_NAME)=UPPER('WFSectionsTable') ;
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				EXECUTE IMMEDIATE 'CREATE TABLE WFSectionsTable (
    ProcessDefId            INT                NOT NULL,
    ProjectId               INT                NOT NULL,
    OrderId                 INT                NOT NULL,
    SectionName             NVARCHAR2(255)     NOT NULL,
    Description             NVARCHAR2(255)     NULL,
    Exclude                 NVARCHAR2(1)  	   DEFAULT ''N'' NOT NULL,
    ParentID                INT 			   DEFAULT 0 NOT NULL,
    SectionId               INT                NOT NULL
)
';
		END;
	EXCEPTION
		WHEN OTHERS THEN  
			raise_application_error(-20231,' BLOCK WFSectionsTable FAILED');
	END;
	
	
	Begin
	v_existsFlag := 0;
		SELECT 1 INTO v_existsFlag FROM user_indexes WHERE UPPER(index_name)=UPPER('IDX2_WFINSTRUMENTTABLE') AND upper(table_name)=upper('WFINSTRUMENTTABLE');
		IF v_existsFlag=1 THEN
				EXECUTE IMMEDIATE 'DROP INDEX IDX2_WFINSTRUMENTTABLE';
				DBMS_OUTPUT.PUT_LINE ('Index IDX2_WFINSTRUMENTTABLE dropped');
		END IF;
	EXCEPTION
			WHEN NO_DATA_FOUND THEN
				DBMS_OUTPUT.PUT_LINE ('Index IDX2_WFINSTRUMENTTABLE Not Found');
	END;
	
	Begin
	v_existsFlag := 0;
		SELECT 1 INTO v_existsFlag FROM user_indexes WHERE UPPER(index_name)=UPPER('IDX3_WFINSTRUMENTTABLE') AND upper(table_name)=upper('WFINSTRUMENTTABLE');
		IF v_existsFlag=1 THEN
				EXECUTE IMMEDIATE 'DROP INDEX IDX3_WFINSTRUMENTTABLE';
				DBMS_OUTPUT.PUT_LINE ('Index IDX3_WFINSTRUMENTTABLE dropped');
		END IF;
	EXCEPTION
			WHEN NO_DATA_FOUND THEN
				DBMS_OUTPUT.PUT_LINE ('Index IDX3_WFINSTRUMENTTABLE Not Found');
	END;
	
	Begin
	v_existsFlag := 0;
		SELECT 1 INTO v_existsFlag FROM user_indexes WHERE UPPER(index_name)=UPPER('IDX5_WFINSTRUMENTTABLE') AND upper(table_name)=upper('WFINSTRUMENTTABLE');
		IF v_existsFlag=1 THEN
				EXECUTE IMMEDIATE 'DROP INDEX IDX5_WFINSTRUMENTTABLE';
				DBMS_OUTPUT.PUT_LINE ('Index IDX5_WFINSTRUMENTTABLE dropped');
		END IF;
	EXCEPTION
			WHEN NO_DATA_FOUND THEN
				DBMS_OUTPUT.PUT_LINE ('Index IDX5_WFINSTRUMENTTABLE Not Found');
	END;
	
	Begin
	v_existsFlag := 0;
		SELECT 1 INTO v_existsFlag FROM user_indexes WHERE UPPER(index_name)=UPPER('IDX7_WFINSTRUMENTTABLE') AND upper(table_name)=upper('WFINSTRUMENTTABLE');
		IF v_existsFlag=1 THEN
				EXECUTE IMMEDIATE 'DROP INDEX IDX7_WFINSTRUMENTTABLE';
				DBMS_OUTPUT.PUT_LINE ('Index IDX7_WFINSTRUMENTTABLE dropped');
		END IF;
	EXCEPTION
			WHEN NO_DATA_FOUND THEN
				DBMS_OUTPUT.PUT_LINE ('Index IDX7_WFINSTRUMENTTABLE Not Found');
	END;
	
	Begin
	v_existsFlag := 0;
		SELECT 1 INTO v_existsFlag FROM user_indexes WHERE UPPER(index_name)=UPPER('IDX8_WFINSTRUMENTTABLE') AND upper(table_name)=upper('WFINSTRUMENTTABLE');
		IF v_existsFlag=1 THEN
				EXECUTE IMMEDIATE 'DROP INDEX IDX8_WFINSTRUMENTTABLE';
				DBMS_OUTPUT.PUT_LINE ('Index IDX8_WFINSTRUMENTTABLE dropped');
		END IF;
	EXCEPTION
			WHEN NO_DATA_FOUND THEN
				DBMS_OUTPUT.PUT_LINE ('Index IDX8_WFINSTRUMENTTABLE Not Found');
	END;
	
	Begin
	v_existsFlag := 0;
		SELECT 1 INTO v_existsFlag FROM user_indexes WHERE UPPER(index_name)=UPPER('IDX9_WFINSTRUMENTTABLE') AND upper(table_name)=upper('WFINSTRUMENTTABLE');
		IF v_existsFlag=1 THEN
				EXECUTE IMMEDIATE 'DROP INDEX IDX9_WFINSTRUMENTTABLE';
				DBMS_OUTPUT.PUT_LINE ('Index IDX9_WFINSTRUMENTTABLE dropped');
		END IF;
	EXCEPTION
			WHEN NO_DATA_FOUND THEN
				DBMS_OUTPUT.PUT_LINE ('Index IDX9_WFINSTRUMENTTABLE Not Found');
	END;
	
	Begin
	v_existsFlag := 0;
		SELECT 1 INTO v_existsFlag FROM user_indexes WHERE UPPER(index_name)=UPPER('IDX12_WFINSTRUMENTTABLE') AND upper(table_name)=upper('WFINSTRUMENTTABLE');
		IF v_existsFlag=1 THEN
				EXECUTE IMMEDIATE 'DROP INDEX IDX12_WFINSTRUMENTTABLE';
				DBMS_OUTPUT.PUT_LINE ('Index IDX12_WFINSTRUMENTTABLE dropped');
		END IF;
	EXCEPTION
			WHEN NO_DATA_FOUND THEN
				DBMS_OUTPUT.PUT_LINE ('Index IDX12_WFINSTRUMENTTABLE Not Found');
	END;
	
	Begin
	v_existsFlag := 0;
		SELECT 1 INTO v_existsFlag FROM user_indexes WHERE UPPER(index_name)=UPPER('IDXMIGRATION_WFINSTRUMENTTABLE') AND upper(table_name)=upper('WFINSTRUMENTTABLE');
		IF v_existsFlag=1 THEN
				EXECUTE IMMEDIATE 'DROP INDEX IDXMIGRATION_WFINSTRUMENTTABLE';
				DBMS_OUTPUT.PUT_LINE ('Index IDXMIGRATION_WFINSTRUMENTTABLE dropped');
		END IF;
	EXCEPTION
			WHEN NO_DATA_FOUND THEN
				DBMS_OUTPUT.PUT_LINE ('Index IDXMIGRATION_WFINSTRUMENTTABLE Not Found');
	END;
	
	
	Begin
	v_existsFlag := 0;
		BEGIN
		SELECT 1 INTO v_existsFlag FROM user_indexes WHERE UPPER(index_name)=UPPER('IDX14_WFINSTRUMENTTABLE') AND upper(table_name)=upper('WFINSTRUMENTTABLE');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				EXECUTE IMMEDIATE 'CREATE INDEX IDX14_WFINSTRUMENTTABLE ON WFINSTRUMENTTABLE(Q_QueueId, LockStatus, PriorityLevel)';
				DBMS_OUTPUT.PUT_LINE ('Index IDX14_WFINSTRUMENTTABLE created');
		END;
	EXCEPTION
		WHEN OTHERS THEN
		raise_application_error(-20436, 'IDX14_WFINSTRUMENTTABLE creation Failed.');
		RETURN;
	END;
	BEGIN
        IF (v_existsFlag = 1) THEN
            BEGIN
			 EXECUTE IMMEDIATE 'DROP INDEX IDX14_WFINSTRUMENTTABLE';
				DBMS_OUTPUT.PUT_LINE ('OLD Index IDX14_WFINSTRUMENTTABLE Dropped');
			 EXECUTE IMMEDIATE 'CREATE INDEX IDX14_WFINSTRUMENTTABLE ON WFINSTRUMENTTABLE(Q_QueueId, LockStatus, PriorityLevel)';
				DBMS_OUTPUT.PUT_LINE ('Index IDX14_WFINSTRUMENTTABLE created');	
                
            END;
        END IF;
    END;
	
	Begin
	v_existsFlag := 0;
		BEGIN
		SELECT 1 INTO v_existsFlag FROM user_indexes WHERE UPPER(index_name)=UPPER('IDX15_WFINSTRUMENTTABLE') AND upper(table_name)=upper('WFINSTRUMENTTABLE');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				EXECUTE IMMEDIATE 'CREATE INDEX IDX15_WFINSTRUMENTTABLE ON WFINSTRUMENTTABLE(Q_QueueId, LockStatus, ProcessInstanceId)';
				DBMS_OUTPUT.PUT_LINE ('Index IDX15_WFINSTRUMENTTABLE created');
		END;
	EXCEPTION
		WHEN OTHERS THEN
		raise_application_error(-20436, 'IDX15_WFINSTRUMENTTABLE creation Failed.');
		RETURN;
	END;
	BEGIN
        IF (v_existsFlag = 1) THEN
            BEGIN
			 EXECUTE IMMEDIATE 'DROP INDEX IDX15_WFINSTRUMENTTABLE';
				DBMS_OUTPUT.PUT_LINE ('OLD Index IDX15_WFINSTRUMENTTABLE Dropped');
			 EXECUTE IMMEDIATE 'CREATE INDEX IDX15_WFINSTRUMENTTABLE ON WFINSTRUMENTTABLE(Q_QueueId, LockStatus, ProcessInstanceId)';
				DBMS_OUTPUT.PUT_LINE ('Index IDX15_WFINSTRUMENTTABLE created');	
                
            END;
        END IF;
    END;
	
	Begin
	v_existsFlag := 0;
		BEGIN
		SELECT 1 INTO v_existsFlag FROM user_indexes WHERE UPPER(index_name)=UPPER('IDX16_WFINSTRUMENTTABLE') AND upper(table_name)=upper('WFINSTRUMENTTABLE');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				EXECUTE IMMEDIATE 'CREATE INDEX IDX16_WFINSTRUMENTTABLE ON WFINSTRUMENTTABLE(Q_QueueId, LockStatus, EntryDateTime)';
				DBMS_OUTPUT.PUT_LINE ('Index IDX16_WFINSTRUMENTTABLE created');
		END;
	EXCEPTION
		WHEN OTHERS THEN
		raise_application_error(-20436, 'IDX16_WFINSTRUMENTTABLE creation Failed.');
		RETURN;
	END;
	BEGIN
        IF (v_existsFlag = 1) THEN
            BEGIN
			 EXECUTE IMMEDIATE 'DROP INDEX IDX16_WFINSTRUMENTTABLE';
				DBMS_OUTPUT.PUT_LINE ('OLD Index IDX16_WFINSTRUMENTTABLE Dropped');
			 EXECUTE IMMEDIATE 'CREATE INDEX IDX16_WFINSTRUMENTTABLE ON WFINSTRUMENTTABLE(Q_QueueId, LockStatus, EntryDateTime)';
				DBMS_OUTPUT.PUT_LINE ('Index IDX16_WFINSTRUMENTTABLE created');	
                
            END;
        END IF;
    END;
	
	Begin
	v_existsFlag := 0;
		BEGIN
		SELECT 1 INTO v_existsFlag FROM user_indexes WHERE UPPER(index_name)=UPPER('IDX17_WFINSTRUMENTTABLE') AND upper(table_name)=upper('WFINSTRUMENTTABLE');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				EXECUTE IMMEDIATE 'CREATE INDEX IDX17_WFINSTRUMENTTABLE ON WFINSTRUMENTTABLE(Q_UserID, ProcessInstanceId, WorkitemId)';
				DBMS_OUTPUT.PUT_LINE ('Index IDX17_WFINSTRUMENTTABLE created');
		END;
	EXCEPTION
		WHEN OTHERS THEN
		raise_application_error(-20436, 'IDX17_WFINSTRUMENTTABLE creation Failed.');
		RETURN;
	END;
	BEGIN
        IF (v_existsFlag = 1) THEN
            BEGIN
			 EXECUTE IMMEDIATE 'DROP INDEX IDX17_WFINSTRUMENTTABLE';
				DBMS_OUTPUT.PUT_LINE ('OLD Index IDX17_WFINSTRUMENTTABLE Dropped');
			 EXECUTE IMMEDIATE 'CREATE INDEX IDX17_WFINSTRUMENTTABLE ON WFINSTRUMENTTABLE(Q_UserID, ProcessInstanceId, WorkitemId)';
				DBMS_OUTPUT.PUT_LINE ('Index IDX17_WFINSTRUMENTTABLE created');	
                
            END;
        END IF;
    END;
	
	
	Begin
		BEGIN
			SELECT CONSTRAINT_NAME INTO v_ConstraintName FROM user_constraints WHERE table_name = UPPER('TODOPICKLISTTABLE') AND constraint_type = 'P';
			IF (v_ConstraintName IS NOT NULL AND length(v_ConstraintName) > 0) THEN
				EXECUTE IMMEDIATE('ALTER TABLE TODOPICKLISTTABLE DROP CONSTRAINT ' ||  v_ConstraintName);
			END IF;
			EXCEPTION WHEN NO_DATA_FOUND THEN 
				BEGIN
					DBMS_OUTPUT.PUT_LINE('No Data Found');
				END;
		END;
		BEGIN
			EXECUTE IMMEDIATE ('ALTER TABLE TODOPICKLISTTABLE ADD PRIMARY KEY (ProcessDefId,ToDoId,PickListId )');
		END;
	
	END;
	
	
	BEGIN
		existsFlag := 0;
		BEGIN
		SELECT 1 INTO existsFlag FROM USER_TAB_COLUMNS WHERE TABLE_NAME=UPPER('EXCEPTIONDEFTABLE') AND COLUMN_NAME=UPPER('Description');
		IF (existsFlag=1) THEN
		BEGIN
			v_existsFlag :=0;
			SELECT 1 into v_existsFlag from user_tab_columns where table_name = UPPER('EXCEPTIONDEFTABLE') and column_name = UPPER('Description') and
				char_col_decl_length < 1024;
			IF v_existsFlag = 1 THEN
			BEGIN
				EXECUTE IMMEDIATE 'ALTER TABLE EXCEPTIONDEFTABLE MODIFY (Description NVARCHAR2(1024))';
			END;
			END IF;
			EXCEPTION
					WHEN NO_DATA_FOUND THEN
					BEGIN
						DBMS_OUTPUT.PUT_LINE('Size of column in Description column in EXCEPTIONDEFTABLE');
					END;
		END;
		END IF;
		END;
	EXCEPTION
		WHEN OTHERS THEN
			raise_application_error(-20444,'Increasing size of Description in EXCEPTIONDEFTABLE Failed.');
			RETURN;
	END;
	
	
	Begin
	v_existsFlag := 0;
		BEGIN
			v_existsFlag := 0;
			SELECT 1 INTO v_existsFlag FROM USER_TABLES WHERE UPPER(TABLE_NAME) = 'WFREPORTPROPERTIESTABLE';
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN
				EXECUTE IMMEDIATE ('Create table WFReportPropertiesTable(
					CriteriaID				int PRIMARY KEY,
					CriteriaName			NVARCHAR2(255) UNIQUE NOT NULL,
					Description				NVARCHAR2(255) Null,
					ChartInfo				NVARCHAR2(2000) Null,
					ExcludeExitWorkitems	Char(1)   	Not Null ,
					State					int			Not Null ,
					LastModifiedOn  		DATE		NULL
				)');
				DBMS_OUTPUT.PUT_LINE ('Table WFReportPropertiesTable created');
		END;
	EXCEPTION
		WHEN OTHERS THEN
		raise_application_error(-20445, ' Table WFReportPropertiesTable creation Failed.');
		RETURN;
	END;
	
	BEGIN
		existsFlag :=0;	
		SELECT 1 INTO existsFlag FROM USER_SEQUENCES  WHERE SEQUENCE_NAME = UPPER('CriteriaID');
		EXCEPTION WHEN no_data_found THEN
			EXECUTE IMMEDIATE 'CREATE SEQUENCE CriteriaID INCREMENT BY 1 START WITH 1 NOCACHE';
	END;
	
	Begin
	v_existsFlag := 0;
		BEGIN
			v_existsFlag := 0;
			SELECT 1 INTO v_existsFlag FROM USER_TABLES WHERE UPPER(TABLE_NAME) = 'WFFILTERDEFTABLE';
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN
				EXECUTE IMMEDIATE ('Create Table WFFilterDefTable(
					FilterID	int PRIMARY KEY,
					FilterName	NVARCHAR2(255) NOT NULL,
					FilterXML	NVARCHAR2(2000) NOT NULL,
					CriteriaID	Int Not NULL,
					FilterColor NVARCHAR2(20) NOT NULL,
					ConditionOption	int not null,
					CONSTRAINT	uk_WFFilterDefTable UNIQUE(CriteriaID,FilterName)
				)');
				DBMS_OUTPUT.PUT_LINE ('Table WFFilterDefTable created');
		END;
	EXCEPTION
		WHEN OTHERS THEN
		raise_application_error(-20446, ' Table WFFilterDefTable creation Failed.');
		RETURN;
	END;
	
	BEGIN
		existsFlag :=0;	
		SELECT 1 INTO existsFlag FROM USER_SEQUENCES  WHERE SEQUENCE_NAME = UPPER('FilterID');
		EXCEPTION WHEN no_data_found THEN
			EXECUTE IMMEDIATE 'CREATE SEQUENCE FilterID INCREMENT BY 1 START WITH 1 NOCACHE';
	END;
	
	Begin
	v_existsFlag := 0;
		BEGIN
			v_existsFlag := 0;
			SELECT 1 INTO v_existsFlag FROM USER_TABLES WHERE UPPER(TABLE_NAME) = 'WFREPORTOBJASSOCTABLE';
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN
				EXECUTE IMMEDIATE ('Create TABLE WFReportObjAssocTable(
					CriteriaID	Int NOT Null,
					ObjectID	Int NOT Null,
					ObjectType	Char (1) CHECK ( ObjectType in (N''P'' , N''Q'' , N''F'')),
					ObjectName	NVARCHAR2(255),
					CONSTRAINT	pk_WFReportObjAssocTable PRIMARY KEY(CriteriaID,ObjectID,ObjectType)
				)');
				DBMS_OUTPUT.PUT_LINE ('Table WFReportObjAssocTable created');
		END;
	EXCEPTION
		WHEN OTHERS THEN
		raise_application_error(-20447, ' Table WFReportObjAssocTable creation Failed.');
		RETURN;
	END;
	
	Begin
	v_existsFlag := 0;
		BEGIN
			v_existsFlag := 0;
			SELECT 1 INTO v_existsFlag FROM USER_TABLES WHERE UPPER(TABLE_NAME) = 'WFREPORTVARMAPPINGTABLE';
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN
				EXECUTE IMMEDIATE ('Create TABLE WFReportVarMappingTable(
					CriteriaID			Int NOT Null,
					VariableId			INT NOT NULL ,
					VariableName		NVARCHAR2(50) 	NOT NULL ,
					Type				int 			Not null ,
					VariableType 		char(1) 		NOT NULL ,
					DisplayName			NVARCHAR2(50)	NOT NULL ,
					SystemDefinedName	NVARCHAR2(50) 	NOT NULL ,
					OrderId				Int 			Not NUll ,
					IsHidden			Char(1)			Not Null ,
					IsSortable			Char(1)			Not Null ,
					LastModifiedDateTime TIMESTAMP 		Not NULL ,
					MappedType			int 			not null ,
					DisableSorting 		char(1) 		NOT NULL,
					CONSTRAINT	pk_WFReportVarMappingTable PRIMARY KEY(CriteriaID,VariableId),
					CONSTRAINT	uk_WFReportVarMappingTable UNIQUE(CriteriaID,DisplayName)
				)');
				DBMS_OUTPUT.PUT_LINE ('Table WFReportVarMappingTable created');
		END;
	EXCEPTION
		WHEN OTHERS THEN
		raise_application_error(-20448, ' Table WFReportVarMappingTable creation Failed.');
		RETURN;
	END;
	
	
	Select ObjectTypeIdSequence.nextval into v_ObjectTypeId from dual;
	BEGIN	
	SELECT 1 INTO  existsFlag FROM wfobjectlisttable WHERE ObjectType  = 'CRM';
		EXCEPTION
        WHEN NO_DATA_FOUND THEN	
			INSERT INTO wfobjectlisttable values (v_ObjectTypeId,'CRM','Criteria Management',0,'com.newgen.wf.rightmgmt.WFRightGetCriteriaList', '0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000', 'Y');
	END;	

	BEGIN
		EXecute Immediate 'SELECT 1 FROM wfassignablerightstable WHERE ObjectTypeId  = '||v_ObjectTypeId||'' into existsFlag;
		EXCEPTION
		WHEN NO_DATA_FOUND THEN	
			INSERT INTO wfassignablerightstable (OBJECTTYPEID,RIGHTFLAG,RIGHTNAME,ORDERBY) VALUES (v_ObjectTypeId,'V','View', 2);
			INSERT INTO wfassignablerightstable (OBJECTTYPEID,RIGHTFLAG,RIGHTNAME,ORDERBY) VALUES (v_ObjectTypeId,'M','Modify', 3);
			INSERT INTO wfassignablerightstable (OBJECTTYPEID,RIGHTFLAG,RIGHTNAME,ORDERBY) VALUES (v_ObjectTypeId,'D','Delete', 4);
	END;	


	BEGIN
	SELECT 1 INTO  existsFlag FROM wffilterlisttable WHERE TAGNAME  = 'CriteriaName';
		EXCEPTION
        WHEN NO_DATA_FOUND THEN	
			INSERT INTO wffilterlisttable VALUES (v_ObjectTypeId,'Criteria Name','CriteriaName');
	END;	
	
	
	
	BEGIN
		BEGIN
			SELECT 1 INTO existsFlag FROM user_tables WHERE UPPER(TABLE_NAME)=UPPER('WFTransientVarTable') ;
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				EXECUTE IMMEDIATE 'create TABLE WFTransientVarTable(
    ProcessDefId            INT                 NOT NULL,
    OrderId                 INT                 NOT NULL,
    FieldName               NVARCHAR2(50)      NOT NULL,
    FieldType                 NVARCHAR2(255)      NOT NULL,
    FieldLength             INT              NULL,
    DefaultValue             NVARCHAR2(255)      NULL,
    VarPrecision             INT                 NULL,    
	VarScope                   NVARCHAR2(2)   DEFAULT ''U''   NOT NULL,   
    constraint pk_WFTRANSIENTVARTABLE PRIMARY KEY (ProcessDefId,FieldName)
)';
		END;
	EXCEPTION
		WHEN OTHERS THEN  
			raise_application_error(-20231,' BLOCK 101 FAILED');
	END;
	
	
	BEGIN
		BEGIN
			SELECT 1 INTO existsFlag FROM user_tables WHERE UPPER(TABLE_NAME)=UPPER('WFScriptData') ;
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				EXECUTE IMMEDIATE 'create TABLE  WFScriptData(
    ProcessDefId             INT                NOT NULL,
    ActivityId                 INT             NOT NULL,     
    RuleId                     INT                NOT NULL,
    OrderId                 INT              NOT NULL,
    Command                 NVARCHAR2(255)   NOT NULL,
    Target                     NVARCHAR2(255)   NULL,
    Value                     NVARCHAR2(255)   NULL,
    Type                      NVARCHAR2(1)     NULL,
    VariableId                 INT             NOT NULL,
    VarFieldId                 INT             NOT NULL,
    ExtObjId                 INT             NOT NULL     
)';
		END;
	EXCEPTION
		WHEN OTHERS THEN  
			raise_application_error(-20231,' BLOCK 102 FAILED');
	END;
	
	BEGIN
		BEGIN
			SELECT 1 INTO existsFlag FROM user_tables WHERE UPPER(TABLE_NAME)=UPPER('WFRuleFlowData') ;
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				EXECUTE IMMEDIATE 'create TABLE  WFRuleFlowData(
    ProcessDefId             INT             NOT NULL,
    ActivityId                 INT             NOT NULL,
    RuleId                     INT              NOT NULL,
    RuleOrderId             INT              NOT NULL,
    RuleType                 NVARCHAR2(1)     NOT NULL,
    RuleName                 NVARCHAR2(100)     NOT NULL,
    RuleTypeId                 INT             NOT NULL,
    Param1                     NVARCHAR2(255)     NULL,
    Type1                     NVARCHAR2(1)     NOT NULL,
    ExtObjID1                 INT              NULL,
    VariableId_1             INT              NULL,
    VarFieldId_1             INT              NULL,
    Param2                     NVARCHAR2(255)     NULL,
    Type2                     NVARCHAR2(1)     NOT NULL,
    ExtObjID2                 INT              NOT NULL,
    VariableId_2             INT              NOT NULL,
    VarFieldId_2             INT              NOT NULL,
    Param3                     NVARCHAR2(255)     NULL,
    Type3                     NVARCHAR2(1)     NOT NULL,
    ExtObjID3                 INT              NOT NULL,
    VariableId_3             INT              NOT NULL,
    VarFieldId_3             INT              NOT NULL,
    Operator                 INT              NOT NULL,
    LogicalOp                 INT              NOT NULL,
    IndentLevel             INT             NOT NULL
  )';
		END;
	EXCEPTION
		WHEN OTHERS THEN  
			raise_application_error(-20231,' BLOCK 109 FAILED');
	END;
	
	BEGIN
		BEGIN
			SELECT 1 INTO existsFlag FROM user_tables WHERE UPPER(TABLE_NAME)=UPPER('WFRuleFileInfo') ;
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				EXECUTE IMMEDIATE 'create table WFRuleFileInfo(
    ProcessDefId             INT             NOT NULL,
    ActivityId                INT             NOT NULL,
    RuleId                     INT             NOT NULL,
    FileType                 NVARCHAR2(1)     NOT NULL,
    RowHeader                 INT             NOT NULL,
    Destination             NVARCHAR2(255)     NULL,
    PickCriteria              NVARCHAR2(255)     NULL,
    FromSize                  numeric(15,2)              NULL,
    ToSize                  numeric(15,2)              NULL,
    SizeUnit                  NVARCHAR2(3)     NULL,
    FromModificationDate      DATE              NULL,
    ToModificationDate      DATE              NULL,
    FromCreationDate          DATE              NULL,
    ToCreationDate          DATE              NULL,
    PathType                INT                    NULL,
    DocId                    INT                    NULL
)';
		END;
	EXCEPTION
		WHEN OTHERS THEN  
			raise_application_error(-20231,' BLOCK 103 FAILED');
	END;
	
	BEGIN
		BEGIN
			SELECT 1 INTO existsFlag FROM user_tables WHERE UPPER(TABLE_NAME)=UPPER('WFWORKITEMMAPPINGTABLE') ;
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				EXECUTE IMMEDIATE 'create table WFWORKITEMMAPPINGTABLE(
    ProcessDefId             INT             NOT NULL,
    ActivityId                 INT             NOT NULL,
    RuleId                     INT             NOT NULL,
    OrderId                 INT              NOT NULL,
    VariableName              NVARCHAR2(255)      NULL,
    VariableId                 INT             NOT NULL,
    VarFieldId                 INT             NOT NULL,
    VariableType             NVARCHAR2(2)     NOT NULL,
    ExtObjId                 INT              NOT NULL,
    MappedVariable          NVARCHAR2(255)      NULL,
    MapType                 NVARCHAR2(2)  DEFAULT N''V'' NOT NULL 
)';
		END;
	EXCEPTION
		WHEN OTHERS THEN  
			raise_application_error(-20231,' BLOCK 104 FAILED');
	END;
	
	BEGIN
		BEGIN
			SELECT 1 INTO existsFlag FROM user_tables WHERE UPPER(TABLE_NAME)=UPPER('WFExcelMapInfo') ;
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				EXECUTE IMMEDIATE 'create table WFExcelMapInfo(
    ProcessDefId             INT             NOT NULL,
    ActivityId                 INT             NOT NULL,
    RuleId                     INT             NOT NULL,
    OrderId                 INT              NOT NULL,
    ColumnName              NVARCHAR2(255)      NULL,
    ColumnType                 INT             NOT NULL,
    VarName                  NVARCHAR2(255)      NULL,
    VarScope                 NVARCHAR2(1)      NULL,
    VarType                 INT             NOT NULL
)';
		END;
	EXCEPTION
		WHEN OTHERS THEN  
			raise_application_error(-20231,' BLOCK 105 FAILED');
	END;
	
	BEGIN
		BEGIN
			SELECT 1 INTO existsFlag FROM user_tables WHERE UPPER(TABLE_NAME)=UPPER('WFRuleFlowMappingTable') ;
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				EXECUTE IMMEDIATE 'create TABLE  WFRuleFlowMappingTable(
    ProcessDefId             INT             NOT NULL,
    ActivityId                 INT             NOT NULL,
    RuleId                     INT              NOT NULL,
    OrderId                 INT              NOT NULL,
    ExtMethodIndex             INT              NOT NULL,
    MapType                 NVARCHAR2(1)      NOT NULL,
    ExtMethodParamIndex     INT              NOT NULL,
    MappedField              NVARCHAR2(255)      NULL,
    MappedFieldType         NVARCHAR2(1)       NULL,
    VariableId                 INT             NOT NULL,
    VarFieldId                 INT             NOT NULL,
    DataStructureId         INT              NOT NULL 
)';
		END;
	EXCEPTION
		WHEN OTHERS THEN  
			raise_application_error(-20231,' BLOCK 106 FAILED');
	END;
	
	BEGIN
		BEGIN
			SELECT 1 INTO existsFlag FROM user_tables WHERE UPPER(TABLE_NAME)=UPPER('WFRoboticVarDocMapping') ;
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				EXECUTE IMMEDIATE 'create TABLE  WFRoboticVarDocMapping(
    ProcessDefId             INT             NOT NULL,
    FieldName                 NVARCHAR2(255)     NOT NULL, 
    MappedFieldName         NVARCHAR2(255)     NOT NULL,                                                                                    
    ExtObjId                   INT             NOT NULL, 
    VariableId                 INT              NOT NULL, 
    Attribute                 NVARCHAR2(2)     NOT NULL,        
    VariableType              INT             NOT NULL,  
    VariableScope           NVARCHAR2(2)     NOT NULL,  
    VariableLength             INT             NOT NULL,   
    VarPrecision               INT             NOT NULL,
    Unbounded               NVARCHAR2(2)      NOT NULL,  
    MapType                 NVARCHAR2(2)     DEFAULT N''V'' NOT NULL 
)';
		END;
	EXCEPTION
		WHEN OTHERS THEN  
			raise_application_error(-20231,' BLOCK 107 FAILED');
	END;
	
	BEGIN
		BEGIN
			SELECT 1 INTO existsFlag FROM user_tables WHERE UPPER(TABLE_NAME)=UPPER('WFAssociatedExcpTable') ;
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				EXECUTE IMMEDIATE 'create TABLE  WFAssociatedExcpTable(
     ProcessDefId             INT             NOT NULL,
     ActivityId             INT             NOT NULL,
     OrderId                 INT              NOT NULL,
     CodeId                 NVARCHAR2(1000)    NOT NULL, 
     TriggerId                 NVARCHAR2(1000)  NOT NULL                                                                                        
)';
		END;
	EXCEPTION
		WHEN OTHERS THEN  
			raise_application_error(-20231,' BLOCK 108 FAILED');
	END;
	
	BEGIN
		BEGIN
			SELECT 1 INTO existsFlag FROM user_tables WHERE UPPER(TABLE_NAME)=UPPER('WFRuleExceptionData') ;
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				EXECUTE IMMEDIATE 'create TABLE  WFRuleExceptionData(
    ProcessDefId             INT             NOT NULL,
    ActivityId                 INT             NOT NULL,
    RuleId                     INT              NOT NULL,
    OrderId                 INT              NOT NULL,    
    Param1                     nvarchar2(255)     NULL,
    Type1                     nvarchar2(1)     NOT NULL,
    ExtObjID1                 INT              NULL,
    VariableId_1             INT              NULL,
    VarFieldId_1             INT              NULL,
    Param2                     nvarchar2(255)     NULL,
    Type2                     nvarchar2(1)     NOT NULL,
    ExtObjID2                 INT              NOT NULL,
    VariableId_2             INT              NOT NULL,
    VarFieldId_2             INT              NOT NULL,   
    Operator                 INT              NOT NULL,
    LogicalOp                 INT              NOT NULL    
)';
		END;
	EXCEPTION
		WHEN OTHERS THEN  
			raise_application_error(-20231,' BLOCK 109 FAILED');
	END;
	
	BEGIN
		BEGIN
			SELECT 1 INTO existsFlag FROM user_tables WHERE UPPER(TABLE_NAME)=UPPER('WFDBDetails') ;
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				EXECUTE IMMEDIATE 'CREATE TABLE WFDBDetails(
    ProcessDefId int NOT NULL,
    ActivityId int NOT NULL,
    IsolateFlag nvarchar2(2) NOT NULL,
    ConfigurationID int NOT NULL
)';
		END;
	EXCEPTION
		WHEN OTHERS THEN  
			raise_application_error(-20231,' BLOCK 110 FAILED');
	END;
	
	BEGIN
		BEGIN
			SELECT 1 INTO existsFlag FROM user_tables WHERE UPPER(TABLE_NAME)=UPPER('WFTableDetails') ;
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				EXECUTE IMMEDIATE 'CREATE TABLE WFTableDetails(
    ProcessDefId int NOT NULL,
    ActivityId int NOT NULL,
    RuleId int  NOT NULL,
    OrderId int  NOT NULL,
    EntityId int  NOT NULL,
    EntityName nvarchar2(255) NOT NULL,
    EntityType nvarchar2(2) NOT NULL
)';
		END;
	EXCEPTION
		WHEN OTHERS THEN  
			raise_application_error(-20231,' BLOCK 111 FAILED');
	END;
	
	BEGIN
		BEGIN
			SELECT 1 INTO existsFlag FROM user_tables WHERE UPPER(TABLE_NAME)=UPPER('WFTableJoinDetails') ;
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				EXECUTE IMMEDIATE 'CREATE TABLE WFTableJoinDetails(
    ProcessDefId int NOT NULL,
    ActivityId int NOT NULL,
    RuleId int  NOT NULL,
    OrderId int  NOT NULL,
    EntityId_1 int  NOT NULL,
    ColumnName_1 nvarchar2(255) NOT NULL,
    EntityId_2 int  NOT NULL,
    ColumnName_2 nvarchar2(255) NOT NULL,
    JoinType int  NOT NULL
)';
		END;
	EXCEPTION
		WHEN OTHERS THEN  
			raise_application_error(-20231,' BLOCK 112 FAILED');
	END;
	
	BEGIN
		BEGIN
			SELECT 1 INTO existsFlag FROM user_tables WHERE UPPER(TABLE_NAME)=UPPER('WFTableFilterDetails') ;
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				EXECUTE IMMEDIATE 'CREATE TABLE WFTableFilterDetails(
    ProcessDefId int NOT NULL,
    ActivityId int NOT NULL,
    RuleId int  NOT NULL,
    OrderId int  NOT NULL,
    EntityId int  NOT NULL,
    ColumnName nvarchar2(255) NOT NULL,
    VarName nvarchar2(255) NOT NULL,
    VarType nvarchar2(2) NOT NULL,
    ExtObjId int NOT NULL,
    VarId int NOT NULL,
    VarFieldId int NOT NULL,
    Operator int  NOT NULL,
    LogicalOperator int NOT NULL
) ';
		END;
	EXCEPTION
		WHEN OTHERS THEN  
			raise_application_error(-20231,' BLOCK 113 FAILED');
	END;
	
	
	BEGIN
		BEGIN
			SELECT 1 INTO existsFlag FROM user_tables WHERE UPPER(TABLE_NAME)=UPPER('WFTableMappingDetails') ;
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				EXECUTE IMMEDIATE 'CREATE TABLE WFTableMappingDetails(
					ProcessDefId int NOT NULL,
					ActivityId int NOT NULL,
					RuleId int  NOT NULL,
					OrderId int  NOT NULL,
					EntityType nvarchar2(2) NOT NULL,
					EntityName nvarchar2(255) NOT NULL,
					ColumnName nvarchar2(255) NOT NULL,
					Nullable nvarchar2(2) NOT NULL,
					VarName nvarchar2(255) NOT NULL,
					VarType nvarchar2(2) NOT NULL,
					VarId int NOT NULL,
					VarFieldId int  NOT NULL,
					ExtObjId int NOT NULL,
					Type  INT NOT NULL,
					ColumnType nvarchar2(255) NULL,
					VarName1 nvarchar2(255) NOT NULL,
					VarType1 nvarchar2(2) NOT NULL,
					VarId1 int NOT NULL,
					VarFieldId1 int NOT NULL,
					ExtObjId1 int NOT NULL,
					Type1 INT NOT NULL,
					Operator int NOT NULL,
					OperationType nvarchar2(2) Default ''E'' NOT NULL
) ';
		END;
	EXCEPTION
		WHEN OTHERS THEN  
			raise_application_error(-20231,' BLOCK 114 FAILED');
	END;
	
	BEGIN
		 SELECT VariableId INTO v_variableid FROM VarMappingTable WHERE UPPER(SystemDefinedName) = UPPER('ManualProcessingFlag');
		v_rowCount := SQL%ROWCOUNT;
	EXCEPTION
	WHEN OTHERS THEN
		v_rowCount := 0;
	END;
	IF(v_rowCount < 1) THEN
	BEGIN
		SAVEPOINT ManualProcessingFlag;

			v_queryStr := 'SELECT distinct(ProcessDefId) FROM VarMappingTable';
			OPEN Cursor1 FOR v_queryStr;
			LOOP
				FETCH Cursor1 INTO v_ProcessDefId;
				EXIT WHEN Cursor1%NOTFOUND;

				EXECUTE IMMEDIATE 'insert into VarMappingTable (ProcessDefId,VariableId,SystemDefinedName,UserDefinedName,VariableType,VariableScope,ExtObjId,DefaultValue,VariableLength,VarPrecision,Unbounded)  values('||To_Char(v_ProcessDefId)|| ',  10024,    ''ManualProcessingFlag'',''ManualProcessingFlag'',     10,    ''M''    ,0,    ''N'',    1   ,0    ,''N'')';				
			END LOOP;
			CLOSE Cursor1;
		COMMIT;
	EXCEPTION
	WHEN OTHERS THEN
		ROLLBACK TO SAVEPOINT ManualProcessingFlag;
		CLOSE Cursor1;
	END;
	END IF;
	
	
	
	
	BEGIN
		v_existsFlag :=0;	
		select 1 into v_existsFlag from user_tab_columns where upper(table_name) = UPPER('WFBRMSRuleSetInfo') and upper(column_name) = UPPER('RuleType');
		Exception when no_data_found then
			EXECUTE IMMEDIATE ('Alter table WFBRMSRuleSetInfo ADD  RuleType          	NVARCHAR2(1)    DEFAULT N''P'' NOT NULL');
	END;
	
	 BEGIN
			INSERT INTO WFCabVersionTable(cabVersion, cabVersionId, creationDate, lastModified, Remarks, Status) VALUES (N'iBPS_4.0_SP1', cabVersionId.nextVal, SYSDATE, SYSDATE, N'UpgradeIBPS_A_OFserver_5.sql', N'Y');
	END;
	
	BEGIN
		v_existsFlag :=0;	
		select 1 into v_existsFlag from user_tab_columns where upper(table_name) = UPPER('WFINSTRUMENTTABLE') and upper(column_name) = UPPER('ManualProcessingFlag');
		Exception when no_data_found then
			EXECUTE IMMEDIATE ('Alter table WFINSTRUMENTTABLE ADD  ManualProcessingFlag          	NVARCHAR2(1)    DEFAULT N''N'' NOT NULL');
	END;
	
	BEGIN
		v_existsFlag :=0;	
		select 1 into v_existsFlag from user_tab_columns where upper(table_name) = UPPER('QUEUEHISTORYTABLE') and upper(column_name) = UPPER('ManualProcessingFlag');
		Exception when no_data_found then
			EXECUTE IMMEDIATE ('Alter table QUEUEHISTORYTABLE ADD  ManualProcessingFlag          	NVARCHAR2(1)    DEFAULT N''N'' NOT NULL');
	END;
		
	/* adding changes to add DBExErrCode and DBExErrDesc */
	BEGIN
		v_existsFlag :=0;	
		select 1 into v_existsFlag from user_tab_columns where upper(table_name) = UPPER('WFINSTRUMENTTABLE') and upper(column_name) = UPPER('DBExErrCode');
		Exception when no_data_found then
			EXECUTE IMMEDIATE ('Alter table WFINSTRUMENTTABLE ADD  DBExErrCode INT NULL');
	END;
	
	BEGIN
		v_existsFlag :=0;	
		select 1 into v_existsFlag from user_tab_columns where upper(table_name) = UPPER('WFINSTRUMENTTABLE') and upper(column_name) = UPPER('DBExErrDesc');
		Exception when no_data_found then
			EXECUTE IMMEDIATE ('Alter table WFINSTRUMENTTABLE ADD  DBExErrDesc  NVARCHAR2(255)	NULL');
	END;
	
	BEGIN
		v_existsFlag :=0;	
		select 1 into v_existsFlag from user_tab_columns where upper(table_name) = UPPER('QUEUEHISTORYTABLE') and upper(column_name) = UPPER('DBExErrCode');
		Exception when no_data_found then
			EXECUTE IMMEDIATE ('Alter table QUEUEHISTORYTABLE ADD  DBExErrCode INT NULL');
	END;
	
	BEGIN
		v_existsFlag :=0;	
		select 1 into v_existsFlag from user_tab_columns where upper(table_name) = UPPER('QUEUEHISTORYTABLE') and upper(column_name) = UPPER('DBExErrDesc');
		Exception when no_data_found then
			EXECUTE IMMEDIATE ('Alter table QUEUEHISTORYTABLE ADD  DBExErrDesc  NVARCHAR2(255)	NULL');
	END;
	
	BEGIN
		 SELECT VariableId INTO v_variableid FROM VarMappingTable WHERE UPPER(SystemDefinedName) = UPPER('DBExErrCode');
		v_rowCount := SQL%ROWCOUNT;
	EXCEPTION
	WHEN OTHERS THEN
		v_rowCount := 0;
	END;
	IF(v_rowCount < 1) THEN
	BEGIN
		SAVEPOINT DBExErrCodeFlag;
			v_queryStr := 'SELECT distinct(ProcessDefId) FROM VarMappingTable';
			OPEN Cursor1 FOR v_queryStr;
			LOOP
				FETCH Cursor1 INTO v_ProcessDefId;
				EXIT WHEN Cursor1%NOTFOUND;

				EXECUTE IMMEDIATE 'insert into VarMappingTable (ProcessDefId,VariableId,SystemDefinedName,UserDefinedName,VariableType,VariableScope,ExtObjId,DefaultValue,VariableLength,VarPrecision,Unbounded)  values('||To_Char(v_ProcessDefId)|| ',  10025,    ''DBExErrCode'',''DBExErrCode'',     3,    ''M''    ,0,    NULL,    2   ,0    ,''N'')';				
			END LOOP;
			CLOSE Cursor1;
		COMMIT;
	EXCEPTION
	WHEN OTHERS THEN
		ROLLBACK TO SAVEPOINT DBExErrCodeFlag;
		CLOSE Cursor1;
	END;
	END IF;
	
	BEGIN
		 SELECT VariableId INTO v_variableid FROM VarMappingTable WHERE UPPER(SystemDefinedName) = UPPER('DBExErrDesc');
		v_rowCount := SQL%ROWCOUNT;
	EXCEPTION
	WHEN OTHERS THEN
		v_rowCount := 0;
	END;
	IF(v_rowCount < 1) THEN
	BEGIN
		SAVEPOINT DBExErrDescFlag;
			v_queryStr := 'SELECT distinct(ProcessDefId) FROM VarMappingTable';
			OPEN Cursor1 FOR v_queryStr;
			LOOP
				FETCH Cursor1 INTO v_ProcessDefId;
				EXIT WHEN Cursor1%NOTFOUND;

				EXECUTE IMMEDIATE 'insert into VarMappingTable (ProcessDefId,VariableId,SystemDefinedName,UserDefinedName,VariableType,VariableScope,ExtObjId,DefaultValue,VariableLength,VarPrecision,Unbounded)  values('||To_Char(v_ProcessDefId)|| ',  10026,    ''DBExErrDesc'',''DBExErrDesc'',     10,    ''M''    ,0,    NULL,    255   ,0    ,''N'')';				
			END LOOP;
			CLOSE Cursor1;
		COMMIT;
	EXCEPTION
	WHEN OTHERS THEN
		ROLLBACK TO SAVEPOINT DBExErrDescFlag;
		CLOSE Cursor1;
	END;
	END IF;
	
	/* adding changes to add DBExErrCode and DBExErrDesc till here*/

	BEGIN
		R_COUNT := 0;
		SAVEPOINT EXTMETHOD_TRANS;
		SELECT COUNT(1)INTO R_COUNT FROM EXTMETHODDEFTABLE WHERE ProcessDefId = 0 and ExtMethodIndex = 1;
		IF (R_COUNT = 0) THEN
		BEGIN
			DELETE FROM EXTMETHODDEFTABLE WHERE ProcessDefId > 0 and ExtMethodIndex >=1 and ExtMethodIndex <=34;
			DELETE FROM EXTMETHODPARAMDEFTABLE WHERE ProcessDefId > 0 and ExtMethodIndex >=1 and ExtMethodIndex <=34;

			INSERT INTO EXTMETHODDEFTABLE (ProcessDefId, ExtMethodIndex, ExtAppName, ExtAppType, ExtMethodName, SearchMethod, SearchCriteria, ReturnType, MappingFile, ConfigurationID) VALUES (0, 1,'System','S','contains','', NULL, 12,'', 0);
			INSERT INTO  EXTMETHODDEFTABLE (ProcessDefId, ExtMethodIndex, ExtAppName, ExtAppType, ExtMethodName, SearchMethod, SearchCriteria, ReturnType, MappingFile, ConfigurationID) VALUES (0, 2,'System','S','normalizeSpace','', NULL, 10,'', 0);
			INSERT INTO  EXTMETHODDEFTABLE (ProcessDefId, ExtMethodIndex, ExtAppName, ExtAppType, ExtMethodName, SearchMethod, SearchCriteria, ReturnType, MappingFile, ConfigurationID) VALUES (0, 3,'System','S','stringValue','', NULL, 10,'', 0);
			INSERT INTO  EXTMETHODDEFTABLE (ProcessDefId, ExtMethodIndex, ExtAppName, ExtAppType, ExtMethodName, SearchMethod, SearchCriteria, ReturnType, MappingFile, ConfigurationID) VALUES (0, 4,'System','S','stringValue','', NULL, 10,'', 0);
			INSERT INTO  EXTMETHODDEFTABLE (ProcessDefId, ExtMethodIndex, ExtAppName, ExtAppType, ExtMethodName, SearchMethod, SearchCriteria, ReturnType, MappingFile, ConfigurationID) VALUES (0, 5,'System','S','stringValue','', NULL, 10,'', 0);
			INSERT INTO  EXTMETHODDEFTABLE (ProcessDefId, ExtMethodIndex, ExtAppName, ExtAppType, ExtMethodName, SearchMethod, SearchCriteria, ReturnType, MappingFile, ConfigurationID) VALUES (0, 6,'System','S','stringValue','', NULL, 10,'', 0);
			INSERT INTO  EXTMETHODDEFTABLE (ProcessDefId, ExtMethodIndex, ExtAppName, ExtAppType, ExtMethodName, SearchMethod, SearchCriteria, ReturnType, MappingFile, ConfigurationID) VALUES (0, 7,'System','S','stringValue','', NULL, 10,'', 0);
			INSERT INTO  EXTMETHODDEFTABLE (ProcessDefId, ExtMethodIndex, ExtAppName, ExtAppType, ExtMethodName, SearchMethod, SearchCriteria, ReturnType, MappingFile, ConfigurationID) VALUES (0, 8,'System','S','stringValue','', NULL, 10,'', 0);
			INSERT INTO  EXTMETHODDEFTABLE (ProcessDefId, ExtMethodIndex, ExtAppName, ExtAppType, ExtMethodName, SearchMethod, SearchCriteria, ReturnType, MappingFile, ConfigurationID) VALUES (0, 9,'System','S','booleanValue','', NULL, 12,'', 0);
			INSERT INTO  EXTMETHODDEFTABLE (ProcessDefId, ExtMethodIndex, ExtAppName, ExtAppType, ExtMethodName, SearchMethod, SearchCriteria, ReturnType, MappingFile, ConfigurationID) VALUES (0,10,'System','S','booleanValue',' ',null,12,' ',0);
			INSERT INTO  EXTMETHODDEFTABLE (ProcessDefId, ExtMethodIndex, ExtAppName, ExtAppType, ExtMethodName, SearchMethod, SearchCriteria, ReturnType, MappingFile, ConfigurationID) VALUES (0, 11,'System','S','startsWith','', NULL, 12,'', 0);
			INSERT INTO  EXTMETHODDEFTABLE (ProcessDefId, ExtMethodIndex, ExtAppName, ExtAppType, ExtMethodName, SearchMethod, SearchCriteria, ReturnType, MappingFile, ConfigurationID) VALUES (0, 12,'System','S','stringLength','', NULL, 3,'', 0);
			INSERT INTO  EXTMETHODDEFTABLE (ProcessDefId, ExtMethodIndex, ExtAppName, ExtAppType, ExtMethodName, SearchMethod, SearchCriteria, ReturnType, MappingFile, ConfigurationID) VALUES (0, 13,'System','S','subString','', NULL, 10,'', 0);
			INSERT INTO  EXTMETHODDEFTABLE (ProcessDefId, ExtMethodIndex, ExtAppName, ExtAppType, ExtMethodName, SearchMethod, SearchCriteria, ReturnType, MappingFile, ConfigurationID) VALUES (0, 14,'System','S','subStringBefore','', NULL, 10,'', 0);
			INSERT INTO  EXTMETHODDEFTABLE (ProcessDefId, ExtMethodIndex, ExtAppName, ExtAppType, ExtMethodName, SearchMethod, SearchCriteria, ReturnType, MappingFile, ConfigurationID) VALUES (0, 15,'System','S','subStringAfter','', NULL, 10,'', 0);
			INSERT INTO  EXTMETHODDEFTABLE (ProcessDefId, ExtMethodIndex, ExtAppName, ExtAppType, ExtMethodName, SearchMethod, SearchCriteria, ReturnType, MappingFile, ConfigurationID) VALUES (0, 16,'System','S','translate','', NULL, 10,'', 0);
			INSERT INTO  EXTMETHODDEFTABLE (ProcessDefId, ExtMethodIndex, ExtAppName, ExtAppType, ExtMethodName, SearchMethod, SearchCriteria, ReturnType, MappingFile, ConfigurationID) VALUES (0, 17,'System','S','concat','', NULL, 10,'', 0);
			INSERT INTO  EXTMETHODDEFTABLE (ProcessDefId, ExtMethodIndex, ExtAppName, ExtAppType, ExtMethodName, SearchMethod, SearchCriteria, ReturnType, MappingFile, ConfigurationID) VALUES (0, 18,'System','S','numberValue','', NULL, 6,'', 0);
			INSERT INTO  EXTMETHODDEFTABLE (ProcessDefId, ExtMethodIndex, ExtAppName, ExtAppType, ExtMethodName, SearchMethod, SearchCriteria, ReturnType, MappingFile, ConfigurationID) VALUES (0, 19,'System','S','numberValue','', NULL, 6,'', 0);
			INSERT INTO  EXTMETHODDEFTABLE (ProcessDefId, ExtMethodIndex, ExtAppName, ExtAppType, ExtMethodName, SearchMethod, SearchCriteria, ReturnType, MappingFile, ConfigurationID) VALUES (0, 20,'System','S','numberValue','', NULL, 6,'', 0);
			INSERT INTO  EXTMETHODDEFTABLE (ProcessDefId, ExtMethodIndex, ExtAppName, ExtAppType, ExtMethodName, SearchMethod, SearchCriteria, ReturnType, MappingFile, ConfigurationID) VALUES (0, 21,'System','S','numberValue','', NULL, 6,'', 0);
			INSERT INTO  EXTMETHODDEFTABLE (ProcessDefId, ExtMethodIndex, ExtAppName, ExtAppType, ExtMethodName, SearchMethod, SearchCriteria, ReturnType, MappingFile, ConfigurationID) VALUES (0, 22,'System','S','numberValue','', NULL, 6,'', 0);
			INSERT INTO  EXTMETHODDEFTABLE (ProcessDefId, ExtMethodIndex, ExtAppName, ExtAppType, ExtMethodName, SearchMethod, SearchCriteria, ReturnType, MappingFile, ConfigurationID) VALUES (0, 23,'System','S','round','', NULL, 4,'', 0);
			INSERT INTO  EXTMETHODDEFTABLE (ProcessDefId, ExtMethodIndex, ExtAppName, ExtAppType, ExtMethodName, SearchMethod, SearchCriteria, ReturnType, MappingFile, ConfigurationID) VALUES (0, 24,'System','S','floor','', NULL, 4,'', 0);
			INSERT INTO  EXTMETHODDEFTABLE (ProcessDefId, ExtMethodIndex, ExtAppName, ExtAppType, ExtMethodName, SearchMethod, SearchCriteria, ReturnType, MappingFile, ConfigurationID) VALUES (0, 25,'System','S','ceiling','', NULL, 4,'', 0);
			INSERT INTO  EXTMETHODDEFTABLE (ProcessDefId, ExtMethodIndex, ExtAppName, ExtAppType, ExtMethodName, SearchMethod, SearchCriteria, ReturnType, MappingFile, ConfigurationID) VALUES (0, 26,'System','S','getCurrentDate','', NULL, 15,'', 0);
			INSERT INTO  EXTMETHODDEFTABLE (ProcessDefId, ExtMethodIndex, ExtAppName, ExtAppType, ExtMethodName, SearchMethod, SearchCriteria, ReturnType, MappingFile, ConfigurationID) VALUES (0, 27,'System','S','getCurrentTime','', NULL, 16,'', 0);
			INSERT INTO  EXTMETHODDEFTABLE (ProcessDefId, ExtMethodIndex, ExtAppName, ExtAppType, ExtMethodName, SearchMethod, SearchCriteria, ReturnType, MappingFile, ConfigurationID) VALUES (0, 28,'System','S','getCurrentDateTime','', NULL, 8,'', 0);
			INSERT INTO  EXTMETHODDEFTABLE (ProcessDefId, ExtMethodIndex, ExtAppName, ExtAppType, ExtMethodName, SearchMethod, SearchCriteria, ReturnType, MappingFile, ConfigurationID) VALUES (0, 29,'System','S','getShortDate','', NULL, 15,'', 0);
			INSERT INTO  EXTMETHODDEFTABLE (ProcessDefId, ExtMethodIndex, ExtAppName, ExtAppType, ExtMethodName, SearchMethod, SearchCriteria, ReturnType, MappingFile, ConfigurationID) VALUES (0, 30,'System','S','getTime','', NULL, 16,'', 0);
			INSERT INTO  EXTMETHODDEFTABLE (ProcessDefId, ExtMethodIndex, ExtAppName, ExtAppType, ExtMethodName, SearchMethod, SearchCriteria, ReturnType, MappingFile, ConfigurationID) VALUES (0, 31,'System','S','roundToInt','', NULL, 3,'', 0);
			INSERT INTO  EXTMETHODDEFTABLE (ProcessDefId, ExtMethodIndex, ExtAppName, ExtAppType, ExtMethodName, SearchMethod, SearchCriteria, ReturnType, MappingFile, ConfigurationID) VALUES (0, 32,'System','S','getElementAtIndex','', NULL, 3,'', 0);
			INSERT INTO  EXTMETHODDEFTABLE (ProcessDefId, ExtMethodIndex, ExtAppName, ExtAppType, ExtMethodName, SearchMethod, SearchCriteria, ReturnType, MappingFile, ConfigurationID) VALUES (0, 33,'System','S','addElementToArray','', NULL, 3,'', 0);
			INSERT INTO  EXTMETHODDEFTABLE (ProcessDefId, ExtMethodIndex, ExtAppName, ExtAppType, ExtMethodName, SearchMethod, SearchCriteria, ReturnType, MappingFile, ConfigurationID) VALUES (0, 34,'System','S','deleteChildWorkitem','', NULL, 3,'', 0);
			INSERT INTO  EXTMETHODDEFTABLE (ProcessDefId, ExtMethodIndex, ExtAppName, ExtAppType, ExtMethodName, SearchMethod, SearchCriteria, ReturnType, MappingFile, ConfigurationID) VALUES (0,4001,'System','S','InvokeDBFuncExecuteString','',NULL,10,'',0);
			INSERT INTO  EXTMETHODDEFTABLE (ProcessDefId, ExtMethodIndex, ExtAppName, ExtAppType, ExtMethodName, SearchMethod, SearchCriteria, ReturnType, MappingFile, ConfigurationID) VALUES (0,4002,'System','S','InvokeDBFuncExecuteInt','',NULL,3,'',0);		

			INSERT INTO  EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0, 1, 1, 'Param1', 10, 1, 0, ' ', 'N');
			INSERT INTO  EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0, 2, 1, 'Param2', 10, 2, 0, ' ', 'N');
			INSERT INTO  EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0, 1, 2, 'Param1', 10, 1, 0, ' ', 'N');
			INSERT INTO  EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0, 1, 3, 'Param1', 10, 1, 0, ' ', 'N');
			INSERT INTO  EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0, 1, 4, 'Param1', 8, 1, 0, ' ', 'N');
			INSERT INTO  EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0, 1, 5, 'Param1', 6, 1, 0, ' ', 'N');
			INSERT INTO  EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0, 1, 6, 'Param1', 4, 1, 0, ' ', 'N');
			INSERT INTO  EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0, 1, 7, 'Param1', 3, 1, 0, ' ', 'N');
			INSERT INTO  EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0, 1, 8, 'Param1', 12, 1, 0, ' ', 'N');
			INSERT INTO  EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0, 1, 9, 'Param1', 10, 1, 0, ' ', 'N');
			INSERT INTO  EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0, 1, 10, 'Param1', 3, 1, 0, ' ', 'N');
			INSERT INTO  EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0, 1, 11, 'Param1', 10, 1, 0, ' ', 'N');
			INSERT INTO  EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0, 2, 11, 'Param2', 10, 2, 0, ' ', 'N');
			INSERT INTO  EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0, 1, 12, 'Param1', 10, 1, 0, ' ', 'N');
			INSERT INTO  EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0, 1, 13, 'Param1', 10, 1, 0, ' ', 'N');
			INSERT INTO  EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0, 2, 13, 'Param2', 3, 2, 0, ' ', 'N');
			INSERT INTO  EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0, 3, 13, 'Param3', 3, 3, 0, ' ', 'N');
			INSERT INTO  EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0, 1, 14, 'Param1', 10, 1, 0, ' ', 'N');
			INSERT INTO  EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0, 2, 14, 'Param2', 10, 2, 0, ' ', 'N');
			INSERT INTO  EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0, 1, 15, 'Param1', 10, 1, 0, ' ', 'N');
			INSERT INTO  EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0, 2, 15, 'Param2', 10, 2, 0, ' ', 'N');
			INSERT INTO  EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0, 1, 16, 'Param1', 10, 1, 0, ' ', 'N');
			INSERT INTO  EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0, 2, 16, 'Param2', 10, 2, 0, ' ', 'N');
			INSERT INTO  EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0, 3, 16, 'Param3', 10, 3, 0, ' ', 'N');
			INSERT INTO  EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0, 1, 17, 'Param1', 10, 1, 0, ' ', 'N');
			INSERT INTO  EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0, 2, 17, 'Param2', 10, 2, 0, ' ', 'N');
			INSERT INTO  EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0, 1, 18, 'Param1', 10, 1, 0, ' ', 'N');
			INSERT INTO  EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0, 1, 19, 'Param1', 6, 1, 0, ' ', 'N');
			INSERT INTO  EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0, 1, 20, 'Param1', 4, 1, 0, ' ', 'N');
			INSERT INTO  EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0, 1, 21, 'Param1', 3, 1, 0, ' ', 'N');
			INSERT INTO  EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0, 1, 22, 'Param1', 12, 1, 0, ' ', 'N');
			INSERT INTO  EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0, 1, 23, 'Param1', 6, 1, 0, ' ', 'N');
			INSERT INTO  EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0, 1, 24, 'Param1', 6, 1, 0, ' ', 'N');
			INSERT INTO  EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0, 1, 25, 'Param1', 6, 1, 0, ' ', 'N');
			INSERT INTO  EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0, 1, 29, 'Param1', 8, 1, 0, ' ', 'N');
			INSERT INTO  EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0, 1, 30, 'Param1', 8, 1, 0, ' ', 'N');
			INSERT INTO  EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0, 1, 31, 'Param1', 6, 1, 0, ' ', 'N');
			INSERT INTO  EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0, 1, 32, 'Param1', 3, 1, 0, ' ', 'Y');
			INSERT INTO  EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0, 2, 32, 'Param2', 3, 2, 0, ' ', 'N');
			INSERT INTO  EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0, 1, 33, 'Param1', 3, 1, 0, ' ', 'Y');
			INSERT INTO  EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0, 2, 33, 'Param2', 3, 2, 0, ' ', 'N');
			INSERT INTO  EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0, 3, 33, 'Param3', 3, 3, 0, ' ', 'N');
			INSERT INTO  EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0,1,4001,'StoredProcedureName',10,1,0,' ','N');
			INSERT INTO  EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0,2,4001,'Param1',10,2,0,' ','N');
			INSERT INTO  EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0,3,4001,'Param2',3,3,0,' ','N');
			INSERT INTO  EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0,4,4001,'Param3',8,4,0,' ','N');
			INSERT INTO  EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0,1,4002,'StoredProcedureName',10,1,0,' ','N');
			INSERT INTO  EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0,2,4002,'Param1',10,2,0,' ','N');
			INSERT INTO  EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0,3,4002,'Param2',3,3,0,' ','N');
			INSERT INTO  EXTMETHODPARAMDEFTABLE(ProcessDefId,ExtMethodParamIndex,ExtMethodIndex,ParameterName,ParameterType,ParameterOrder,DataStructureId,ParameterScope,Unbounded) VALUES (0,4,4002,'Param3',8,4,0,' ','N');
		END ;
		END IF ;
		COMMIT ;
	EXCEPTION
		WHEN OTHERS THEN
			ROLLBACK TO SAVEPOINT EXTMETHOD_TRANS;
			raise_application_error(-20231, 'BLOCK 115 Failed With Error : ' || SQLERRM);
			RETURN;
	END;

	BEGIN
		BEGIN
			SELECT 1 INTO R_COUNT FROM USER_TRIGGERS WHERE TRIGGER_NAME = 'WF_GROUPMEMBER_UPD';
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				V_DELETEUSERQUEUETABLEDATA := 1;
		END;
		EXECUTE IMMEDIATE 'CREATE OR REPLACE TRIGGER WF_GROUPMEMBER_UPD
				AFTER DELETE OR INSERT ON PDBGROUPMEMBER FOR EACH ROW 
				DECLARE
				BEGIN
					CASE
						WHEN DELETING THEN
						BEGIN
							DELETE FROM USERQUEUETABLE WHERE USERID = :OLD.USERINDEX;
						END;
						
						WHEN INSERTING THEN
						BEGIN
							DELETE FROM USERQUEUETABLE WHERE USERID = :OLD.USERINDEX;
						END;
					END CASE;
				END;';
		IF( V_DELETEUSERQUEUETABLEDATA = 1) THEN
			Execute Immediate('Delete from UserQueuetable');
		END IF;
	EXCEPTION
		WHEN OTHERS THEN
			raise_application_error(-20231, 'BLOCK 116 Failed With Error : ' || SQLERRM);
			RETURN;
	END;

	BEGIN
		EXECUTE IMMEDIATE 'CREATE OR REPLACE TRIGGER WF_GROUP_DEL 
								AFTER DELETE  
								ON PDBGROUP  
								FOR EACH ROW 
								BEGIN 
									DELETE FROM QUEUEUSERTABLE WHERE  USERID = :OLD.GROUPINDEX AND ASSOCIATIONTYPE = 1; 
								END;';
		EXCEPTION
		WHEN OTHERS THEN
			raise_application_error(-20231, 'BLOCK 117 Failed With Error : ' || SQLERRM);
			RETURN;
	END;
	
	BEGIN
		BEGIN
			SELECT 1 INTO existsFlag FROM user_tables WHERE UPPER(TABLE_NAME)=UPPER('PDBPMS_TABLE') ;
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				EXECUTE IMMEDIATE 'CREATE TABLE PDBPMS_TABLE
			(
               Product_Name   VARCHAR2(255),
               Product_Version        VARCHAR2(255),
               Product_Type     VARCHAR2(255),
               Patch_Number   Number(5),
               Install_Date    VARCHAR2(255))';
		END;
	EXCEPTION
		WHEN OTHERS THEN  
			raise_application_error(-20231,' BLOCK 118 FAILED');
	END;
	

	BEGIN
		existsFlag := 0;
		BEGIN
			SELECT 1 INTO existsFlag FROM USER_TABLES WHERE UPPER(TABLE_NAME) = UPPER('WFDMSUserInfo');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				existsFlag := 0;
		END;
		IF existsFlag <> 1 THEN
			EXECUTE IMMEDIATE 'CREATE TABLE WFDMSUserInfo(UserName NVARCHAR2(64) NOT NULL)';
			EXECUTE IMMEDIATE 'INSERT INTO WFDMSUserInfo(UserName) VALUES(''Of_Sys_User'')';
		END IF;
	EXCEPTION
		WHEN OTHERS THEN
			raise_application_error(-20231,' BLOCK 119 FAILED');
	END;
	
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM QUEUEDEFTABLE
		WHERE UPPER(QueueName) = 'SYSTEMDXQUEUE';
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
		   	EXECUTE IMMEDIATE 'Insert into QueueDefTable(QueueId, QueueName, QueueType, Comments, OrderBy, SortOrder) values (QUEUEID.nextval, ''SystemDXQueue'', ''A'', ''System generated common Data Exchange Queue'', 10, ''A'')';
			DBMS_OUTPUT.PUT_LINE('Data inserted for SystemDXQueue successfully in QUEUEDEFTABLE');
	END;
	
	
	Begin
	v_existsFlag := 0;
		BEGIN
		SELECT 1 INTO v_existsFlag FROM user_indexes WHERE UPPER(index_name)=UPPER('IDX5_QueueHistoryTable') AND upper(table_name)=upper('QueueHistoryTable');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				EXECUTE IMMEDIATE 'CREATE INDEX IDX5_QueueHistoryTable ON QueueHistoryTable (Q_UserId, LockStatus)';
				DBMS_OUTPUT.PUT_LINE ('Index IDX5_QueueHistoryTable created');
		END;
	EXCEPTION
		WHEN OTHERS THEN
		raise_application_error(-20436, 'IDX5_QueueHistoryTable creation Failed.');
		RETURN;
	END;
	
	 BEGIN
			delete from WFRoutingServerInfo;
	 END;
	
	BEGIN 
	OPEN c_mappedobjectname; 
	LOOP 
	FETCH c_mappedobjectname into c_tablename; 
     EXIT WHEN c_mappedobjectname%notfound; 
     --DBMS_OUTPUT.put_line(c_tablename);
     v_queryStr:=' select NVL(max(insertionorderid), 0)+1  from  ' ||c_tablename  ;
     -- DBMS_OUTPUT.put_line(v_queryStr);
	 EXECUTE IMMEDIATE v_queryStr INTO v_insertionorderid;
	 select length(c_tablename) into v_length from dual;
	 if(v_length>28) then
		c_tablename:=SUBSTR(c_tablename,1,28);
        end if;
    begin
	v_queryStr:='SELECT LAST_NUMBER	FROM USER_SEQUENCES	WHERE SEQUENCE_NAME = '''|| UPPER('S_' ||c_tablename)|| '''';
	--DBMS_OUTPUT.put_line(v_queryStr);
    EXECUTE IMMEDIATE v_queryStr INTO v_lastSeqValue;
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'CREATE SEQUENCE S_'||c_tablename||' INCREMENT BY 1 START WITH '||v_insertionorderid;
    end;
	END LOOP; 
	CLOSE c_mappedobjectname; 
   
	OPEN c_mappedobjectname2; 
	LOOP 
	FETCH c_mappedobjectname2 into c_tablename; 
     EXIT WHEN c_mappedobjectname2%notfound; 
      --DBMS_OUTPUT.put_line(c_tablename);
	 v_queryStr:=' select NVL(max(insertionorderid), 0)+1  from ' ||c_tablename  ;
      --DBMS_OUTPUT.put_line(v_queryStr);
      EXECUTE IMMEDIATE v_queryStr INTO v_insertionorderid;
	 select length(c_tablename) into v_length from dual;
	 if(v_length>28) then
		c_tablename:=SUBSTR(c_tablename,1,28);
        end if;
    begin
	v_queryStr:='SELECT LAST_NUMBER	FROM USER_SEQUENCES	WHERE SEQUENCE_NAME = '''|| UPPER('S_' ||c_tablename)|| '''';
    EXECUTE IMMEDIATE v_queryStr INTO v_lastSeqValue;
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'CREATE SEQUENCE S_'||c_tablename||' INCREMENT BY 1 START WITH '||v_insertionorderid;
    end;
	END LOOP; 
	CLOSE c_mappedobjectname2; 
	
	OPEN c_mappedobjectname3; 
	LOOP 
	FETCH c_mappedobjectname3 into c_tablename; 
     EXIT WHEN c_mappedobjectname3%notfound; 
     --DBMS_OUTPUT.put_line(c_tablename);
     v_queryStr:=' select NVL(max(insertionorderid), 0)+1  from  ' ||c_tablename  ;
     -- DBMS_OUTPUT.put_line(v_queryStr);
	 EXECUTE IMMEDIATE v_queryStr INTO v_insertionorderid;
	 select length(c_tablename) into v_length from dual;
	 if(v_length>28) then
		c_tablename:=SUBSTR(c_tablename,1,28);
        end if;
    begin
	v_queryStr:='SELECT LAST_NUMBER	FROM USER_SEQUENCES	WHERE SEQUENCE_NAME = '''|| UPPER('S_' ||c_tablename)|| '''';
	--DBMS_OUTPUT.put_line(v_queryStr);
    EXECUTE IMMEDIATE v_queryStr INTO v_lastSeqValue;
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'CREATE SEQUENCE S_'||c_tablename||' INCREMENT BY 1 START WITH '||v_insertionorderid;
    end;
	END LOOP; 
	CLOSE c_mappedobjectname3; 
   
   
	END; 

	BEGIN
		SELECT COUNT(1) INTO v_existsFlag FROM USER_TAB_COLS WHERE TABLE_NAME = UPPER('WFSystemServicesTable') AND COLUMN_NAME = UPPER('RegisteredBy');
		IF v_existsFlag = 0 THEN
			EXECUTE IMMEDIATE 'ALTER TABLE WFSystemServicesTable ADD RegisteredBy NVARCHAR2(64) DEFAULT ''SUPERVISOR'' NULL';
			EXECUTE IMMEDIATE 'UPDATE WFSystemServicesTable SET RegisteredBy = ''SUPERVISOR''';
		END IF;
	EXCEPTION
		WHEN OTHERS THEN
			raise_application_error(-20231, 'BLOCK 120 FAILED');
	END;

	BEGIN
		SELECT COUNT(1) INTO v_existsFlag FROM USER_TABLES WHERE TABLE_NAME = UPPER('WFCustomServicesStatusTable');
		IF v_existsFlag = 0 THEN
			EXECUTE IMMEDIATE 'CREATE TABLE WFCustomServicesStatusTable (
									PSID				INT NOT NULL PRIMARY KEY,
									ServiceStatus		INT NOT NULL,
									ServiceStatusMsg	NVARCHAR2(100) NOT NULL,
									WorkItemCount		INT NOT NULL,
									LastUpdated			DATE DEFAULT SYSDATE NOT NULL
								)';
		END IF;
	EXCEPTION
		WHEN OTHERS THEN
			raise_application_error(-20231, 'BLOCK 121 FAILED');
	END;

	BEGIN
		SELECT COUNT(1) INTO v_existsFlag FROM USER_TABLES WHERE TABLE_NAME = UPPER('WFServiceAuditTable');
		IF v_existsFlag = 0 THEN
			EXECUTE IMMEDIATE 'CREATE TABLE WFServiceAuditTable (
									LogId				INT NOT NULL,
									PSID				INT NOT NULL,
									ServiceName			NVARCHAR2(100) NOT NULL,
									ServiceType			NVARCHAR2(50) NOT NULL,
									ActionId			INT NOT NULL,
									ActionDateTime		DATE DEFAULT SYSDATE NOT NULL,
									Username			NVARCHAR2(64) NOT NULL,
									ServerDetails		NVARCHAR2(30) NOT NULL,
									ServiceParamDetails	NVARCHAR2(1000) NULL
								)';

			EXECUTE IMMEDIATE 'CREATE SEQUENCE SEQ_WFSAT_LogId INCREMENT BY 1 START WITH 1 NOCACHE';

			
			EXECUTE IMMEDIATE 'CREATE INDEX IDX1_WFServiceAuditTable ON WFServiceAuditTable(PSID, UPPER(UserName), ActionDateTime)';
		END IF;
	EXCEPTION
		WHEN OTHERS THEN
			raise_application_error(-20231, 'BLOCK 122 FAILED');
	END;
	BEGIN
		
		EXECUTE IMMEDIATE 'CREATE OR REPLACE TRIGGER WFServiceAuditTable_TRG
								BEFORE INSERT ON WFServiceAuditTable FOR EACH ROW
								BEGIN
									SELECT SEQ_WFSAT_LogId.NEXTVAL INTO :NEW.LogId FROM DUAL;
								END;';
	
	EXCEPTION
		WHEN OTHERS THEN
			raise_application_error(-20231, 'BLOCK 1221 FAILED');
	END;

	BEGIN
		SELECT COUNT(1) INTO v_existsFlag FROM USER_TABLES WHERE TABLE_NAME = UPPER('WFServiceAuditTable_History');
		IF v_existsFlag = 0 THEN
			EXECUTE IMMEDIATE 'CREATE TABLE WFServiceAuditTable_History (
									LogId				INT NOT NULL,
									PSID				INT NOT NULL,
									ServiceName			NVARCHAR2(100) NOT NULL,
									ServiceType			NVARCHAR2(50) NOT NULL,
									ActionId			INT NOT NULL,
									ActionDateTime		DATE NOT NULL,
									Username			NVARCHAR2(64) NOT NULL,
									ServerDetails		NVARCHAR2(30) NOT NULL,
									ServiceParamDetails	NVARCHAR2(1000) NULL
								)';
		END IF;
	EXCEPTION
		WHEN OTHERS THEN
			raise_application_error(-20231, 'BLOCK 123 FAILED');
	END;

	BEGIN
		SELECT COUNT(1) INTO v_existsFlag FROM USER_TABLES WHERE TABLE_NAME = UPPER('WFServicesListTable');
		IF v_existsFlag = 0 THEN
			EXECUTE IMMEDIATE 'CREATE TABLE WFServicesListTable (
									PSID				INT NOT NULL,
									ServiceId			INT NOT NULL,
									ServiceName			NVARCHAR2(50) NOT NULL,
									ServiceType			NVARCHAR2(50) NOT NULL,
									ProcessDefId		INT NOT NULL,
									ActivityId			INT NOT NULL
								)';
			EXECUTE IMMEDIATE 'INSERT INTO WFServicesListTable(PSID, ServiceId, ServiceName, ServiceType, ProcessDefId, ActivityId) SELECT PSID, ServiceId, ServiceName, ServiceType, NVL(ProcessDefId, 0), 0 FROM WFSystemServicesTable';
		END IF;
	EXCEPTION
		WHEN OTHERS THEN
			raise_application_error(-20231, 'BLOCK 124 FAILED');
	END;
	
	BEGIN
	v_existsFlag :=0;	
	select 1 into v_existsFlag from user_tab_columns where upper(table_name) = 'PROCESSDEFTABLE' and upper(column_name) = UPPER('VolumeId');
	Exception when no_data_found then
		BEGIN
			EXECUTE IMMEDIATE ('ALTER TABLE PROCESSDEFTABLE ADD VolumeId INT  NULL ');
			BEGIN
				v_queryStr := 'SELECT distinct(ProcessDefId) FROM ProcessDefTable';
				OPEN Cursor1 FOR v_queryStr;
				LOOP
					FETCH Cursor1 INTO v_ProcessDefId;
					EXIT WHEN Cursor1%NOTFOUND;
				
					SELECT WorkFlowFolderId into v_folderIndex FROM RouteFolderDefTable where ProcessDefId=v_ProcessDefId;
					SELECT ImageVolumeIndex into v_volumeId FROM PDBFolder where FolderIndex=v_folderIndex;
						
					EXECUTE IMMEDIATE 'UPDATE ProcessDefTable SET VolumeID = '||v_volumeId||' where ProcessdefId='||v_ProcessDefId;				
				END LOOP;
				CLOSE Cursor1;
			EXCEPTION
			WHEN OTHERS THEN
				CLOSE Cursor1;
				raise_application_error(-20436, 'Issue occur during volumeId values update');
				RETURN;
			END;
		END;
	END;
	
	BEGIN
	v_existsFlag :=0;	
	select 1 into v_existsFlag from user_tab_columns where upper(table_name) = 'PROCESSDEFTABLE' and upper(column_name) = UPPER('SiteId');
	Exception when no_data_found then
		BEGIN
			EXECUTE IMMEDIATE ('ALTER TABLE PROCESSDEFTABLE ADD SiteId INT  NULL ');
			BEGIN
				v_queryStr := 'SELECT distinct(ProcessDefId) FROM ProcessDefTable';
				OPEN Cursor1 FOR v_queryStr;
				LOOP
					FETCH Cursor1 INTO v_ProcessDefId;
					EXIT WHEN Cursor1%NOTFOUND;
				
					SELECT WorkFlowFolderId into v_folderIndex FROM RouteFolderDefTable where ProcessDefId=v_ProcessDefId;
					SELECT ImageVolumeIndex into v_volumeId FROM PDBFolder where FolderIndex=v_folderIndex;
					--SELECT HomeSite into v_siteId From ISVOLUME where VolumeId=v_volumeId;
					
					SELECT CABINETTYPE into v_cabinettype FROM PDBCABINET;
					IF (v_cabinettype = 'R') THEN
						BEGIN
							v_siteId := 1;
						END;
					ELSE 
						BEGIN
						--SELECT HomeSite into v_siteId From ISVOLUME where VolumeId=v_volumeId;
							V_QUERYSTR1 := 'SELECT HomeSite From ISVOLUME where VolumeId=:a';
							EXECUTE IMMEDIATE V_QUERYSTR1 INTO v_siteId USING v_volumeId;
							EXCEPTION WHEN no_data_found THEN   
								BEGIN
									v_siteId := 1;
								END;
						
						--DBMS_OUTPUT.PUT_LINE('v_siteId AND  SCRIPT' || v_siteId );
						END;
					END IF;
					EXECUTE IMMEDIATE 'UPDATE ProcessDefTable SET SiteId = '||v_siteId||' where ProcessdefId='||v_ProcessDefId;				
				END LOOP;
				CLOSE Cursor1;
			EXCEPTION
			WHEN OTHERS THEN
				CLOSE Cursor1;
				raise_application_error(-20436, 'Issue occur during SiteId values update');
				RETURN;
			END;
		END;
	END;
	BEGIN
		update wfactionstatustable set type ='C',status='N' where actionid in (23,24) and status = 'Y'; 
	END;
	BEGIN
		v_existsFlag :=0;
		SELECT COUNT(*) INTO v_existsFlag FROM user_indexes WHERE index_name = 'IDX12_WFINSTRUMENTTABLE';
		IF v_existsFlag = 0 THEN
		EXECUTE IMMEDIATE ('CREATE INDEX IDX12_WFINSTRUMENTTABLE ON WFINSTRUMENTTABLE(ASSIGNMENTTYPE  , VALIDTILL  ,ROUTINGSTATUS  ,LOCKSTATUS)');
		END IF;
		EXCEPTION
		WHEN OTHERS THEN
		raise_application_error(-20500,' BLOCK 125 FAILED');
	END;
	
	BEGIN
		v_existsFlag :=0;
		SELECT COUNT(*) INTO v_existsFlag FROM user_indexes WHERE index_name = 'IDX19_WFINSTRUMENTTABLE';
		IF v_existsFlag = 0 THEN
		EXECUTE IMMEDIATE ('CREATE INDEX IDX19_WFINSTRUMENTTABLE ON WFINSTRUMENTTABLE(ProcessDefId, ActivityId)');
		END IF;
		EXCEPTION
		WHEN OTHERS THEN
		raise_application_error(-20500,' BLOCK 126 FAILED');
	END;
	
	BEGIN
		v_existsFlag :=0;
		SELECT COUNT(*) INTO v_existsFlag FROM user_indexes WHERE index_name = upper('IDX6_QueueHistoryTable');
		IF v_existsFlag = 0 THEN
		EXECUTE IMMEDIATE ('CREATE INDEX  IDX6_QueueHistoryTable ON QueueHistoryTable (ProcessDefId, ActivityId)');
		END IF;
		EXCEPTION
		WHEN OTHERS THEN
		raise_application_error(-20500,' BLOCK 127 FAILED');
	END;

	BEGIN
		v_existsFlag :=0;
		SELECT COUNT(*) INTO v_existsFlag FROM user_indexes WHERE index_name = upper('IDX11_WFINSTRUMENTTABLE');
		IF v_existsFlag > 0 THEN
		EXECUTE IMMEDIATE ('DROP INDEX IDX11_WFINSTRUMENTTABLE');
		END IF;
		EXCEPTION
		WHEN OTHERS THEN
		raise_application_error(-20500,' BLOCK 128 FAILED');
	END;
	
	BEGIN
		v_existsFlag :=0;
		SELECT COUNT(*) INTO v_existsFlag FROM user_indexes WHERE index_name = upper('IDX2_QueueHistoryTable');
		IF v_existsFlag > 0 THEN
		EXECUTE IMMEDIATE ('DROP INDEX IDX2_QueueHistoryTable');
		END IF;
		EXCEPTION
		WHEN OTHERS THEN
		raise_application_error(-20500,' BLOCK 129 FAILED');
	END;
	
	BEGIN
		v_existsFlag :=0;
		SELECT COUNT(*) INTO v_existsFlag FROM user_indexes WHERE index_name = upper('IDX4_QueueHistoryTable');
		IF v_existsFlag > 0 THEN
		EXECUTE IMMEDIATE ('DROP INDEX IDX4_QueueHistoryTable');
		END IF;
		EXCEPTION
		WHEN OTHERS THEN
		raise_application_error(-20500,' BLOCK 130 FAILED');
	END;
	
	BEGIN
		v_existsFlag :=0;
		SELECT COUNT(*) INTO v_existsFlag FROM user_indexes WHERE index_name = upper('IDX5_QueueHistoryTable');
		IF v_existsFlag > 0 THEN
		EXECUTE IMMEDIATE ('DROP INDEX IDX5_QueueHistoryTable');
		END IF;
		EXCEPTION
		WHEN OTHERS THEN
		raise_application_error(-20500,' BLOCK 131 FAILED');
	END;  

	BEGIN
	execute IMMEDIATE '	CREATE OR REPLACE VIEW WORKLISTTABLE AS SELECT ProcessInstanceId, WorkItemId, ProcessName, ProcessVersion, ProcessDefID, LastProcessedBy, ProcessedBy, ActivityName, ActivityId, EntryDateTime, ParentWorkItemId, AssignmentType, CollectFlag, PriorityLevel, ValidTill, Q_StreamId, Q_QueueId, Q_UserId, AssignedUser, FilterValue, CreatedDatetime, WorkItemState, Statename, ExpectedWorkitemDelay, PreviousStage, LockedByName, LockStatus, LockedTime, Queuename, Queuetype, NotifyStatus, Guid, Q_DivertedByUserId FROM WFInstrumentTable WHERE RoutingStatus = ''N''' ;
	EXCEPTION WHEN OTHERS THEN
		raise_application_error(-20500,' BLOCK 132 FAILED');
	END;
	
	BEGIN
	execute IMMEDIATE ' CREATE OR REPLACE VIEW QueueDataTable
					AS 	SELECT ProcessInstanceId  ,WorkItemId ,
						VAR_INT1 ,VAR_INT2 ,VAR_INT3,VAR_INT4,VAR_INT5,VAR_INT6,VAR_INT7,VAR_INT8,
						VAR_FLOAT1,VAR_FLOAT2, VAR_DATE1,VAR_DATE2,VAR_DATE3,VAR_DATE4,VAR_LONG1,VAR_LONG2,VAR_LONG3,
						VAR_LONG4, VAR_STR1, VAR_STR2, VAR_STR3, VAR_STR4, VAR_STR5, VAR_STR6, VAR_STR7, VAR_STR8,
						VAR_REC_1,VAR_REC_2, VAR_REC_3,VAR_REC_4,VAR_REC_5,InstrumentStatus, CheckListCompleteFlag,
						SaveStage, HoldStatus,Status, ReferredTo, ReferredToName, ReferredBy, ReferredByName, ChildProcessInstanceId,
						ChildWorkitemId, ParentWorkItemID,CalendarName 				
						FROM wfinstrumenttable';
	EXCEPTION WHEN OTHERS THEN
		raise_application_error(-20500,' BLOCK 133 FAILED');					
	END;


	BEGIN
	execute IMMEDIATE  ' Create OR REPLACE VIEW PENDINGWORKLISTTABLE 
		As  SELECT ProcessInstanceId  ,WorkItemId ,ProcessName,ProcessVersion,ProcessDefID,LastProcessedBy,ProcessedBy,ActivityName,ActivityId,EntryDateTime, 
			ParentWorkItemId,AssignmentType,CollectFlag,PriorityLevel,ValidTill,Q_StreamId,Q_QueueId,Q_UserId,AssignedUser,FilterValue,Createddatetime,WorkItemState,Statename,ExpectedWorkitemDelay,PreviousStage,LockedByName,LockStatus, 
			LockedTime,Queuename,Queuetype,NotifyStatus,
			NoOfCollectedInstances,IsPrimaryCollected,ExportStatus,Q_DivertedByUserId  
			
			FROM wfinstrumenttable 
			where Processinstancestate  IN (4,5,6) OR assignmenttype = ''Z'' OR WorkItemState IN (3,8) '	;
	EXCEPTION WHEN OTHERS THEN
		raise_application_error(-20500,' BLOCK 134 FAILED');			
	END;		

	BEGIN
	execute IMMEDIATE ' Create OR REPLACE VIEW ProcessInstanceTable
		As 
		 
			SELECT ProcessInstanceId,ProcessDefID,Createdby,CreatedByName,CreatedDatetime,IntroducedById,
			Introducedby,IntroductionDateTime,ProcessInstanceState,ExpectedProcessDelay,IntroducedAt
			FROM wfinstrumenttable 
			where workitemid = 1';
	EXCEPTION WHEN OTHERS THEN
		raise_application_error(-20500,' BLOCK 135 FAILED');
	END;
	
			

	BEGIN
	execute IMMEDIATE ' Create OR REPLACE VIEW QueueDataTable
					As 
					 
						SELECT ProcessInstanceId  ,WorkItemId ,
						VAR_INT1 ,VAR_INT2 ,VAR_INT3,VAR_INT4,VAR_INT5,VAR_INT6,VAR_INT7,VAR_INT8,
						VAR_FLOAT1,VAR_FLOAT2, VAR_DATE1,VAR_DATE2,VAR_DATE3,VAR_DATE4,VAR_LONG1,VAR_LONG2,VAR_LONG3,
						VAR_LONG4, VAR_STR1, VAR_STR2, VAR_STR3, VAR_STR4, VAR_STR5, VAR_STR6, VAR_STR7, VAR_STR8,
						VAR_REC_1,VAR_REC_2, VAR_REC_3,VAR_REC_4,VAR_REC_5,InstrumentStatus, CheckListCompleteFlag,
						SaveStage, HoldStatus,Status, ReferredTo, ReferredToName, ReferredBy, ReferredByName, ChildProcessInstanceId,
						ChildWorkitemId, ParentWorkItemID,CalendarName 				
						FROM wfinstrumenttable '	;
	EXCEPTION WHEN OTHERS THEN
		raise_application_error(-20500,' BLOCK 136 FAILED');					
						
	END;					
	
	BEGIN

	execute IMMEDIATE ' Create OR REPLACE VIEW WorkDoneTable
					As 
					 
						SELECT ProcessInstanceId,WorkItemId ,ProcessName ,	ProcessVersion  ,ProcessDefID , LastProcessedBy, ProcessedBy, ActivityName  ,	ActivityId ,EntryDateTime ,ParentWorkItemId	,AssignmentType	 , CollectFlag	,PriorityLevel	,ValidTill ,	Q_StreamId	,Q_QueueId	, Q_UserId ,AssignedUser ,	FilterValue	, CreatedDatetime , WorkItemState ,
						Statename 	, ExpectedWorkitemDelay	, PreviousStage	 , LockedByName	,LockStatus	, LockedTime , 
						Queuename , Queuetype , NotifyStatus , Guid , Q_DivertedByUserId   
						FROM wfinstrumenttable where routingstatus = ''Y''';
	EXCEPTION WHEN OTHERS THEN
		raise_application_error(-20500,' BLOCK 137 FAILED');					

	END;


	BEGIN
		BEGIN
				DECLARE CURSOR cursor1 IS SELECT ProcessDefId, ActivityId, ExpiryActivity FROM ACTIVITYTABLE where ExpiryActivity is not null AND EXPIRYACTIVITY <> ' ' and length(EXPIRYACTIVITY) > 0 and UPPER(ExpiryActivity) <> UPPER('previousstage');
				BEGIN		
				OPEN cursor1;
				LOOP
					FETCH cursor1 INTO V_PROCESSDEFID , V_ACTIVITYID , V_EXPIRYACTIVITY;
					EXIT WHEN cursor1%NOTFOUND;
					BEGIN 
						Select COUNT(1) INTO V_COUNT FROM WORKSTAGELINKTABLE  where type = 'X' and ProcessDefId = V_PROCESSDEFID and SourceId = V_ACTIVITYID;
						IF(V_COUNT = 0) THEN
							BEGIN
								
								V_QUERYSTR := 'select MAX(connectionid) from WORKSTAGELINKTABLE where ProcessDefId = :V_PROCESSDEFID';
								
								EXECUTE IMMEDIATE V_QUERYSTR INTO V_CONNID USING V_PROCESSDEFID ;
								DBMS_OUTPUT.PUT_LINE('V_CONNID--' || V_CONNID);
			
								V_QUERYSTR := 'select ActivityId from ACTIVITYTABLE where ActivityName = :V_EXPIRYACTIVITY and ProcessDefId = :V_PROCESSDEFID';
								
								EXECUTE IMMEDIATE V_QUERYSTR INTO V_Expiray_ActivityId USING V_EXPIRYACTIVITY , V_PROCESSDEFID;
									DBMS_OUTPUT.PUT_LINE('V_Expiray_ActivityId--' || V_Expiray_ActivityId);
								
								V_QUERYSTR := 'INSERT into WORKSTAGELINKTABLE (ProcessDefId,SourceId,TargetId,color,Type, ConnectionId)	
								values (  :V_PROCESSDEFID,  :V_ACTIVITYID ,  :V_Expiray_ActivityId, 1234 , ''X'', :V_CONNID)';
				
								EXECUTE IMMEDIATE V_QUERYSTR USING V_PROCESSDEFID,  V_ACTIVITYID ,  V_Expiray_ActivityId , V_CONNID;
							
								
							END;
						END IF;	
					END;
					COMMIT;

				END LOOP;
				CLOSE cursor1;
				EXCEPTION WHEN OTHERS THEN
				IF cursor1%ISOPEN THEN
					CLOSE cursor1;
				END IF; 
				raise_application_error(-20384,'WORKSTAGELINKTABLE BLOCK  FAILED');  
			END;
				
			END;
	
		END;
	
	
	


END;

~
call Upgrade()

~
DROP PROCEDURE Upgrade

~

Create Or REPLACE Procedure UpgradeIBPS_S_PopulateColumn AS
v_Count					INTEGER:=0;
v_PrevProcId			INTEGER:=0;
v_ProcessDefId			INTEGER;
v_PrevTodoId    		INTEGER:=0;
v_STR1			    	VARCHAR2(8000);
TYPE DynamicCursor		IS REF CURSOR;
cur_picklistInfoUpdate 	DynamicCursor;
cur_queueIDAct 	    	DynamicCursor;
v_TodoId            	INTEGER;
v_PickListName      	NVARCHAR2(100);
v_PickListOrderId   	INTEGER;

BEGIN
	v_STR1 := 'Select processdefid, ToDoId, PickListValue, PickListOrderId from TODOPICKLISTTABLE order by processdefid,ToDoId';	
	OPEN cur_picklistInfoUpdate FOR v_STR1;
	LOOP
		FETCH cur_picklistInfoUpdate INTO v_ProcessDefId,v_TodoId,v_PickListName,v_PickListOrderId; 
		EXIT WHEN cur_picklistInfoUpdate%NOTFOUND;
		BEGIN
			IF v_PickListOrderId is NULL THEN
				IF v_PrevProcId != v_ProcessDefId or v_PrevTodoId != v_TodoId THEN
				BEGIN
					v_Count := 1;
				END;
				ELSE
				BEGIN
					v_Count := v_Count + 1;
				END;
				END IF; 					 
				Update TODOPICKLISTTABLE set PickListOrderId = v_Count where ProcessDefId = v_ProcessDefId and ToDoId = v_TodoId and PickListValue = v_PickListName;
				COMMIT;
				v_PrevProcId := v_ProcessDefId;
				v_PrevTodoId := v_TodoId;
			END IF;
		END;
	END LOOP;
	CLOSE cur_picklistInfoUpdate; 
END;
~
CALL UpgradeIBPS_S_PopulateColumn()
~
DROP PROCEDURE UpgradeIBPS_S_PopulateColumn

~