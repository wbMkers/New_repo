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
_______________________________________________________________________________________________________________________-
Date		Change By		Change Description (Bug No. (If Any))
28/01/2019		Ravi Ranjan Kumar Bug 82440 - Required to change the exception comments length form 512 to 1024 (PRDP Bug Merging)
29/01/2019	Ravi Ranjan Kumar Bug 82718 - User able to view & search iBps WF system folders .
22/03/2019	Mohnish Chopra		Bug 83717 - Support is required to move/save external variables and complex variables data to Secondary cabinet based on some flag SecondaryDBFlag
13/05/2019	Ravi Ranjan Kumar Bug 84500 - Support of URN as system variable is required
6/7/2019		Ravi Ranjan Kumar 	Bug 85140 - Enabling to edit workitem (only data and document ) on query workstep if workitem is present on end workstep 
//25/10/2019		Ambuj Tripathi	Landing page (Criteria Management) Requirement.
27/12/2019		Chitranshi Nitharia	Bug 89384 - Support for global catalog function framework
02/01/2019		Shahzad Malik		Bug 89626 - Required to reduce fragmentation in UserQueueTable
24/01/2020		Chitranshi Nitharia	Bug 90094 - Creation Of Utility User Via API instead of scripts
06/02/2020		Ambuj Tripathi Bug 90553 - Asynchronous+Jboss-eap-7.2+MSSQL : Data Exchange utility is not working
24/03/2020     Shubham Singla  Bug 90785 - iBPS 4.0+Oracle+Postgres: Same insertion order is getting created for the workitems if the same complex table is used in two different processes.
16/04/2020		Chitranshi Nitharia	Bug 91524 - Framework to manage custom utility via ofservices
02/07/2021      Ravi Raj Mewara     Bug 100086 - IBPS 5 Sp2 Performance : WMFetchWorklist taking 35 40 secs for fetching queues
____________________________________________________________________
___________________________________________________-*/

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

CREATE OR REPLACE FUNCTION  Upgrade() 
RETURNS void AS $$
DECLARE 

	v_existFlag		INTEGER;
	v_ObjectId			INTEGER;
	v_ObjectTypeId		INTEGER;
	v_UserId			INTEGER;
	v_AssociationType 	INTEGER;
	v_RightString		VARCHAR(200);
	v_Filter			VARCHAR(200);
	v_ConstraintName 	VARCHAR(100);
	v_Query				VARCHAR(4000);
	v_Cursor 			REFCURSOR;
	v_ProcessDefId 			INTEGER;
	v_ActivityID 			INTEGER;
	v_StreamId   			INTEGER;
	v_StreamName 			VARCHAR(100);
	cur_streamInfoUpdate 	REFCURSOR;
	v_variableid 		INTEGER;
	v_rowCount 			INTEGER;
	Cursor1 			REFCURSOR;
	v_QueryStr        	VARCHAR(2000);
	
	v_ToDoId INTEGER;
	v_PickListValue VARCHAR(50);
	v_PickListOrderId INTEGER;
	v_LastProcessDefId INTEGER;
	v_LastToDoId INTEGER;
	v_primaryName varchar(512);
	R_COUNT INTEGER;
	c_tablename  VARCHAR(512);
	v_queryStr2  	VARCHAR(800);
	v_insertionorderid INTEGER;
	v_length   INTEGER;
	v_folderIndex INTEGER;
	v_volumeId INTEGER;
	v_siteId INTEGER;
	V_QUERYSTR1 VARCHAR(2000);
	v_cabinettype VARCHAR(1);	


	V_EXPIRYACTIVITY VARCHAR(200);
	V_Expiray_ActivityId INT;
	V_COUNT INT;
	V_CONNID INT;
	V_CURSOR_STR VARCHAR(1000);	
	
BEGIN
	SELECT 1 INTO v_existFlag FROM WFSYSTEMPROPERTIESTABLE WHERE UPPER(PROPERTYKEY) = 'SHAREPOINTFLAG';
    IF(NOT FOUND) THEN
		Execute ('INSERT  INTO WFSYSTEMPROPERTIESTABLE(PROPERTYKEY, PROPERTYVALUE) values(''SHAREPOINTFLAG'',''N'')');
	END IF;

	v_existFlag := 0;
	SELECT 1 INTO v_existFlag from information_schema.tables where UPPER(table_name) = 'WFUNDERLYINGDMS';
	IF(NOT FOUND) THEN 
		Execute ('CREATE TABLE WFUnderlyingDMS (
					DMSType		INTEGER			NOT NULL,
					DMSName		VARCHAR(255)	NULL
				)');
	END IF;

	v_existFlag := 0;
	SELECT 1 INTO v_existFlag from information_schema.tables where UPPER(table_name) = 'WFDMSLIBRARY';
	IF(NOT FOUND) THEN 
		Execute ('CREATE TABLE WFDMSLibrary (
					LibraryId			SERIAL			NOT NULL 	PRIMARY KEY,
					URL			VARCHAR(255)	NULL,
					DocumentLibrary		VARCHAR(255)	NULL,
					DOMAINNAME 			VARCHAR(64)	NULL
				)');
	END IF;
    IF (v_existFlag = 1) THEN
        v_existFlag := 0;
        SELECT 1 INTO v_existFlag from information_schema.columns where UPPER(table_name) = 'WFDMSLIBRARY' and  UPPER(column_name) = 'DOMAINNAME';
        IF(NOT FOUND) THEN 
            Execute ('alter table WFDMSLIBRARY ADD DOMAINNAME VARCHAR(64) NULL');
        END IF;
    END IF;
	
	v_existFlag := 0;
	SELECT 1 INTO v_existFlag from information_schema.tables where UPPER(table_name) = 'WFPROCESSSHAREPOINTASSOC';
	IF(NOT FOUND) THEN 
		Execute ('CREATE TABLE WFProcessSharePointAssoc (
					ProcessDefId			INTEGER		NOT NULL,
					LibraryId				INTEGER		NULL,
					PRIMARY KEY (ProcessDefId)
				)');
	END IF;
	
	v_existFlag := 0;
	SELECT 1 INTO v_existFlag from information_schema.tables where UPPER(table_name) = 'WFSHAREPOINTINFO';
	IF(NOT FOUND) THEN 
		Execute ('CREATE TABLE WFSharePointInfo (
					ServiceURL		VARCHAR(255)	NULL,
					ProxyEnabled	VARCHAR(200)	NULL,
					ProxyIP			VARCHAR(20)		NULL,
					ProxyPort		VARCHAR(200)	NULL,
					ProxyUser		VARCHAR(200)	NULL,
					ProxyPassword	VARCHAR(64)		NULL,
					SPWebUrl		VARCHAR(200)	NULL
				)');
	END IF;
	
	v_existFlag := 0;
	SELECT 1 INTO v_existFlag from information_schema.tables where UPPER(table_name) = 'WFARCHIVEINSHAREPOINT';
	IF(NOT FOUND) THEN 
		Execute ('CREATE TABLE WFArchiveInSharePoint (
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
				)');
	END IF;
    IF (v_existFlag = 1) THEN
        v_existFlag := 0;
        SELECT 1 INTO v_existFlag from information_schema.columns where UPPER(table_name) = 'WFARCHIVEINSHAREPOINT' and  UPPER(column_name) = 'DOMAINNAME';
        IF(NOT FOUND) THEN 
            Execute ('alter table WFARCHIVEINSHAREPOINT ADD DOMAINNAME	VARCHAR(64)	NULL');
        END IF;
    END IF;
	
	v_existFlag := 0;
	SELECT 1 INTO v_existFlag from information_schema.tables where UPPER(table_name) = 'WFSHAREPOINTDATAMAPTABLE';
	IF(NOT FOUND) THEN 
		Execute ('CREATE TABLE WFSharePointDataMapTable (
					ProcessDefId			INTEGER			NULL,
					ActivityID				INTEGER			NULL,
					FieldId					INTEGER			NULL,
					FieldName				VARCHAR(255)	NULL,
					FieldType				INTEGER			NULL,
					MappedFieldName			VARCHAR(255)	NULL,
					VariableID				VARCHAR(255)	NULL,
					VarFieldID				VARCHAR(255)	NULL
				)');
	END IF;
	
	v_existFlag := 0;
	SELECT 1 INTO v_existFlag from information_schema.tables where UPPER(table_name) = 'WFSHAREPOINTDOCASSOCTABLE';
	IF(NOT FOUND) THEN 
		Execute ('CREATE TABLE WFSharePointDocAssocTable (
					ProcessDefId			INTEGER			NULL,
					ActivityID				INTEGER			NULL,
					DocTypeID				INTEGER			NULL,
					AssocFieldName			VARCHAR(255)	NULL,
					FolderName				VARCHAR(255)	NULL,
					TargetDocName			VARCHAR(255)	NULL
				)');
	END IF;
    IF (v_existFlag = 1) THEN
        v_existFlag := 0;
        SELECT 1 INTO v_existFlag from information_schema.columns where UPPER(table_name) = 'WFSHAREPOINTDOCASSOCTABLE' and  UPPER(column_name) = 'TARGETDOCNAME';
        IF(NOT FOUND) THEN 
            Execute ('alter table WFSHAREPOINTDOCASSOCTABLE ADD TARGETDOCNAME VARCHAR(255)	NULL');
        END IF;
    END IF;
	
	BEGIN
		v_existFlag := 0;
		SELECT 1 INTO v_existFlag
		FROM information_schema.columns  
		WHERE UPPER(table_name) = UPPER('WFInitiationAgentReportTable') and UPPER(column_name)=UPPER('IAId');
		IF (NOT FOUND) THEN
			EXECUTE  ('alter table WFInitiationAgentReportTable add IAId VARCHAR(50)  null ');
			
			EXECUTE  ('alter table WFInitiationAgentReportTable add AccountName VARCHAR(100)  null ');

			EXECUTE  ('alter table WFInitiationAgentReportTable add NoOfAttachments INTEGER null  ');

			EXECUTE  ('alter table WFInitiationAgentReportTable add SizeOfAttachments VARCHAR(1000) null ');
			
		END IF;
	END;
	
	BEGIN
		v_existFlag = 0;
		SELECT 1 INTO v_existFlag
		FROM information_schema.columns  
		WHERE UPPER(table_name) = UPPER('PROCESSDEFTABLE') and UPPER(column_name)=UPPER('RegPrefix');
		IF(FOUND) THEN 
			Execute ('Alter table PROCESSDEFTABLE ALTER COLUMN RegPrefix TYPE VARCHAR(20)');
		END IF;
	END;
	
	BEGIN
		v_existFlag = 0;
		SELECT 1 INTO v_existFlag
		FROM information_schema.tables 
		where upper(table_name) =  UPPER('WFExportMapTable');
		IF(NOT FOUND) THEN 
			Execute ('CREATE TABLE WFExportMapTable(
				ProcessDefId INTEGER,
				ActivityId INTEGER,
				ExportLocation VARCHAR(2000),
				CurrentCount VARCHAR(100),
				Counter VARCHAR(100),
				RecordFlag VARCHAR(100)
			)');
			RAISE NOTICE 'Table WFExportMapTable created successfully';
		END IF;
	END;
	
	BEGIN
		v_existFlag = 0;
		SELECT 1 INTO v_existFlag
		FROM information_schema.columns  
		WHERE UPPER(table_name) = UPPER('WFUserObjAssocTable') and UPPER(column_name)=UPPER('RightString');
		IF(NOT FOUND) THEN 
			EXECUTE 'select constraint_name from information_schema.table_constraints where UPPER(table_name)=UPPER(''WFUserObjAssocTable'') and constraint_type=''PRIMARY KEY''' INTO v_ConstraintName;
			
			IF (v_ConstraintName IS NOT NULL AND LENGTH(v_ConstraintName) > 0) THEN
				EXECUTE ('ALTER TABLE WFUserObjAssocTable DROP CONSTRAINT ' ||  v_ConstraintName);
				RAISE NOTICE 'Table WFUserObjAssocTable altered, Primary Key on WFUserObjAssocTable is dropped.';
			END IF;
		
			EXECUTE 'select constraint_name from information_schema.table_constraints where UPPER(table_name)=UPPER(''WFProfileObjTypeTable'') and constraint_type=''PRIMARY KEY''' INTO v_ConstraintName;
			
			IF (v_ConstraintName IS NOT NULL AND LENGTH(v_ConstraintName) > 0) THEN
				EXECUTE ('ALTER TABLE WFProfileObjTypeTable DROP CONSTRAINT ' ||  v_ConstraintName);
				RAISE NOTICE 'Table WFProfileObjTypeTable altered, Primary Key on WFProfileObjTypeTable is dropped.';
			END IF;
			
			Execute ('Alter table WFUserObjAssocTable Add RightString VARCHAR(100) NOT NULL Default ''1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111''' );
		
			Execute ('Alter table WFUserObjAssocTable Add Filter VARCHAR(255)');
			
			EXECUTE('ALTER TABLE WFUserObjAssocTable ADD PRIMARY KEY (ObjectId, ObjectTypeId, ProfileId, UserId, AssociationType, RightString)');
			RAISE NOTICE 'Table WFUserObjAssocTable altered, Primary Key created.';
			
			v_Query = 'Select A.ObjectId, A.ObjectTypeId, A.AssociationType, A.UserId, C.RightString, C.Filter as RightStringCasted FROM WFUserObjAssocTable A, WFObjectListTable B, WFProfileObjTypeTable C WHERE A.ObjectTypeId = B.ObjectTypeId AND A.ObjectTypeId = C.ObjectTypeId AND A.associationType = C.associationType AND A.userid = C.userid AND A.Profileid = 0';
			
			BEGIN
				OPEN v_Cursor FOR EXECUTE v_Query;
				LOOP
					FETCH v_Cursor INTO v_ObjectId, v_ObjectTypeId, v_AssociationType, v_UserId, v_RightString, v_Filter;
					IF (NOT FOUND) THEN
						EXIT;
					END IF;
					
					EXECUTE('Update WFUserObjAssocTable set RightString = ''' || COALESCE(v_RightString,'') || ''', Filter  = ''' || COALESCE(v_Filter,'') || ''' Where Objectid = ' || v_ObjectId || ' And ObjectTypeId = ' || v_ObjectTypeId || ' And AssociationType = ' || v_AssociationType || ' And UserId = ' || v_UserId || ' And ProfileId = 0');
					
				END LOOP;
				CLOSE v_Cursor;
			END;
			
			EXECUTE('Insert into WFUserObjAssocTable (ObjectId, ObjectTypeId, ProfileId, UserId, AssociationType, AssociationFlag, RightString, Filter) 
			Select DISTINCT -1, ObjectTypeId, 0, UserId, AssociationType, Null, RightString, Filter FROM WFProfileObjTypeTable where AssociationType IN (0,1) and ObjectTypeId not in (1,2,4,6,12,13)');
		END IF;
	END;
	
	BEGIN	
		OPEN cur_streamInfoUpdate FOR EXECUTE 'Select processdefid,ActivityId,StreamId,StreamName from STREAMDEFTABLE order by processdefid,ActivityId,StreamId';
		LOOP
		FETCH cur_streamInfoUpdate INTO v_ProcessDefId,v_ActivityID,v_StreamId,v_StreamName;
				IF (NOT FOUND) THEN
					EXIT;
				END IF;
				v_existFlag:=0;
				Select Count(*) into v_existFlag from RuleConditionTable where processdefid = v_ProcessDefId and ActivityId=v_ActivityID and RuleType='S';
				IF (v_existFlag = 0 and v_StreamName = 'Default') THEN
					insert into RuleConditionTable (ProcessDefId,ActivityId,RuleType,RuleOrderId,RuleId,ConditionOrderId,Param1,Type1,ExtObjID1,VariableId_1,VarFieldId_1,Param2,Type2,ExtObjID2,VariableId_2,VarFieldId_2,Operator,LogicalOp) values(v_ProcessDefId,v_ActivityID,'S',1,v_StreamId,1,'ALWAYS','S',0,0,0,'ALWAYS','S',0,0,0,4,4);
				END IF;
		END LOOP;
		CLOSE cur_streamInfoUpdate;
	END;
	
	/*BEGIN
		v_existFlag := 0;
		SELECT 1 INTO v_existFlag FROM information_schema.columns WHERE UPPER(table_name) = 'TODOPICKLISTTABLE' and UPPER(column_name)='PICKLISTORDERID';
		IF(NOT FOUND) THEN 
			Execute ('Alter table TODOPICKLISTTABLE ADD PickListOrderId INTEGER');
		END IF;
	END;*/
	
	v_existFlag := 0;
	SELECT 1 INTO v_existFlag FROM information_schema.columns WHERE UPPER(table_name) = UPPER('WFUDTVarMappingTable') and UPPER(column_name)=UPPER('MappedViewName');
	IF(NOT FOUND) THEN 
		Execute ('alter table WFUDTVarMappingTable add MappedViewName      VARCHAR(256)        NULL');
	END IF;

	v_existFlag := 0;
	SELECT 1 INTO v_existFlag FROM information_schema.columns WHERE UPPER(table_name) = UPPER('WFUDTVarMappingTable') and UPPER(column_name)=UPPER('IsView');
	IF(NOT FOUND) THEN 
		Execute ('Alter table WFUDTVarMappingTable ADD IsView          	VARCHAR(1)    DEFAULT N''N'' NOT NULL');
	END IF;
	
	v_existFlag := 0;
	SELECT 1 INTO v_existFlag FROM information_schema.columns WHERE UPPER(table_name) = 'EXCEPTIONVIEW' ;
	IF(v_existFlag=1) THEN 
	BEGIN
		Execute ('DROP VIEW EXCEPTIONVIEW');
	END;
	END IF;
	
	v_existFlag := 0;
	BEGIN
	SELECT 1 INTO v_existFlag FROM information_schema.columns WHERE UPPER(table_name) = 'EXCEPTIONTABLE' and UPPER(column_name)='EXCEPTIONCOMMENTS';
	IF(v_existFlag=1) THEN 
	BEGIN
		v_existFlag := 0;
		SELECT 1 into v_existFlag from information_schema.columns where UPPER(table_name) = UPPER('EXCEPTIONTABLE') and UPPER(column_name) = UPPER('EXCEPTIONCOMMENTS') and character_maximum_length < 1024;
		IF v_existFlag = 1 THEN
		BEGIN
			Execute ('ALTER TABLE EXCEPTIONTABLE ALTER COLUMN ExceptionComments TYPE VARCHAR(1024)');
		END;
		END IF;
	END;
	END IF;
	END;
	
	v_existFlag := 0;
	BEGIN
	SELECT 1 INTO v_existFlag FROM information_schema.columns WHERE UPPER(table_name) = 'EXCEPTIONHISTORYTABLE' and UPPER(column_name)='EXCEPTIONCOMMENTS';
	IF(v_existFlag=1) THEN 
	BEGIN
		v_existFlag := 0;
		SELECT 1 into v_existFlag from information_schema.columns where UPPER(table_name) = UPPER('EXCEPTIONHISTORYTABLE') and UPPER(column_name) = UPPER('EXCEPTIONCOMMENTS') and character_maximum_length < 1024;
		IF v_existFlag = 1 THEN
		BEGIN
			Execute ('ALTER TABLE EXCEPTIONHISTORYTABLE ALTER COLUMN ExceptionComments TYPE VARCHAR(1024)');
		END;
		END IF;
	END;
	END IF;
	END;
	
	v_existFlag := 0;
	SELECT 1 INTO v_existFlag FROM information_schema.columns WHERE UPPER(table_name) = 'EXCEPTIONVIEW' ;
	IF(NOT FOUND) THEN 
	BEGIN
		Execute ('CREATE OR REPLACE VIEW EXCEPTIONVIEW 
AS
	SELECT * FROM EXCEPTIONTABLE 
	UNION ALL
	SELECT * FROM EXCEPTIONHISTORYTABLE ');
	END;
	END IF;
	
	BEGIN
	v_existFlag := 0;
	SELECT 1 INTO v_existFlag FROM information_schema.columns WHERE UPPER(table_name) = 'PROCESSDEFTABLE' and UPPER(column_name)=UPPER('ISSecureFolder');
	IF(NOT FOUND) THEN 
		Execute ('alter table PROCESSDEFTABLE add ISSecureFolder CHAR(1) DEFAULT ''N'' NOT NULL CONSTRAINT CK_ISSecureFolder CHECK (ISSecureFolder IN (''Y'', ''N''))');
	END IF;
	END;	
	
	BEGIN
	v_existFlag := 0;
	SELECT 1 INTO v_existFlag FROM information_schema.columns WHERE UPPER(table_name) = 'QUEUEHISTORYTABLE' and UPPER(column_name)=UPPER('IMAGECABNAME');
	IF(NOT FOUND) THEN 
		Execute ('alter table QUEUEHISTORYTABLE add IMAGECABNAME VARCHAR(100)');
	END IF;
	END;

	v_existFlag := 0;
	SELECT 1 INTO v_existFlag FROM pg_indexes WHERE upper(tablename) = upper('WFEscalationTable') and upper(indexname)=upper('IX1_WFEscalationTable');
	IF(v_existFlag=1) THEN 
		EXECUTE  ('DROP INDEX IX1_WFEscalationTable');
	END IF;
	
	v_existFlag := 0;
	SELECT 1 INTO v_existFlag FROM pg_indexes WHERE upper(tablename) = upper('WFEscalationTable') and upper(indexname)=upper('IDX2_WFEscalationTable');
	IF(NOT FOUND) THEN 
		EXECUTE  ('CREATE INDEX IDX2_WFEscalationTable ON WFEscalationTable (ScheduleTime)');
	END IF;
	
	v_existFlag := 0;
	SELECT 1 INTO v_existFlag FROM pg_indexes WHERE upper(tablename) = upper('WFEscalationTable') and upper(indexname)=upper('IDX3_WFEscalationTable');
	IF(NOT FOUND) THEN 
		EXECUTE  ('CREATE INDEX IDX3_WFEscalationTable ON WFEscalationTable (ProcessInstanceId,WorkitemId)');
	END IF;
	
	v_existFlag := 0;
	SELECT 1 INTO v_existFlag FROM   pg_index i JOIN   pg_attribute a ON a.attrelid = i.indrelid AND a.attnum = ANY(i.indkey) WHERE i.indrelid= 'wfescalationtable'::regclass AND i.indisprimary;
	IF(NOT FOUND) THEN 
			EXECUTE  ('ALTER TABLE WFEscalationTable ADD PRIMARY KEY (EscalationId)');
	END IF;
	
	SELECT VariableId INTO v_variableid FROM VarMappingTable WHERE UPPER(SystemDefinedName) = UPPER('SecondaryDBFlag');
		GET DIAGNOSTICS v_rowCount = ROW_COUNT;
		IF (NOT FOUND) THEN 
			v_rowCount := 0;
		END IF;
		IF(v_rowCount < 1) THEN
				v_queryStr := 'SELECT distinct(ProcessDefId) FROM VarMappingTable';
				OPEN Cursor1 FOR EXECUTE v_queryStr;
				LOOP
					FETCH Cursor1 INTO v_ProcessDefId;
					IF (NOT FOUND) THEN
						EXIT;
					END IF;

					EXECUTE 'insert into varmappingtable (ProcessDefId, variableId, SystemDefinedName, UserDefinedName, 
					VariableType, VariableScope, ExtObjId, DefaultValue, VariableLength, VarPrecision, Unbounded,ProcessVariantId,IsEncrypted,IsMasked,MaskingPattern) 
					values('||CAST(v_ProcessDefId AS VARCHAR)|| '	, 10022, ''SecondaryDBFlag'', ''SecondaryDBFlag'', 10, ''M'', 0, ''N'', NULL, 0, ''N'',0,''N'',''N'',''X'')';
				END LOOP;
				CLOSE Cursor1;
		END IF;	
		
	
	BEGIN
		v_existFlag := 0;
		SELECT 1 INTO v_existFlag FROM information_schema.columns WHERE UPPER(table_name) = 'WFINSTRUMENTTABLE' and UPPER(column_name)=UPPER('SecondaryDBFlag');
		IF(NOT FOUND) THEN 
			Execute ('alter table WFINSTRUMENTTABLE add  SecondaryDBFlag	VARCHAR(1) DEFAULT ''N''    NOT NULL CHECK (SecondaryDBFlag IN (N''Y'', N''N'',N''U'',N''D''))
');
		END IF;
	END;
	
	BEGIN
		v_existFlag := 0;
		SELECT 1 INTO v_existFlag FROM information_schema.columns WHERE UPPER(table_name) = 'QUEUEHISTORYTABLE' and UPPER(column_name)=UPPER('SecondaryDBFlag');
		IF(NOT FOUND) THEN 
			Execute ('alter table QUEUEHISTORYTABLE add  SecondaryDBFlag	VARCHAR(1) DEFAULT ''N''   NOT NULL CHECK (SecondaryDBFlag IN (N''Y'', N''N'',N''U'',N''D''))
');
		END IF;
	END;
	
	v_existFlag := 0;
	BEGIN
		BEGIN
			SELECT 1 INTO v_existFlag FROM information_schema.columns WHERE UPPER(table_name) = UPPER('TODOPICKLISTTABLE') and UPPER(column_name)=UPPER('PickListOrderId');
			IF(NOT FOUND) THEN 
			BEGIN
				Execute ('alter table TODOPICKLISTTABLE add PickListOrderId INTEGER');
				v_LastProcessDefId := -1;
				v_LastToDoId := -1;
				v_PickListOrderId := -1;
				v_QueryStr := 'SELECT ProcessDefId, ToDoId, PickListValue FROM TODOPICKLISTTABLE ORDER BY ProcessDefId ASC, ToDoId ASC';
				OPEN v_Cursor FOR EXECUTE v_QueryStr;
				LOOP
					FETCH v_Cursor INTO v_ProcessDefId, v_ToDoId, v_PickListValue;
					IF (NOT FOUND) THEN
						EXIT;
					END IF;
					IF (v_LastProcessDefId <> v_ProcessDefId OR v_LastToDoId <> v_ToDoId) THEN
						v_PickListOrderId := 1;
					END IF;
					v_QueryStr := 'UPDATE TODOPICKLISTTABLE SET PickListOrderId = ' || v_PickListOrderId || ' WHERE ProcessDefId = ' || v_ProcessDefId || ' AND ToDoId = ' || v_ToDoId || ' AND PickListValue = ''' || v_PickListValue || '''';
					EXECUTE  (v_QueryStr) ;
					v_PickListOrderId := v_PickListOrderId + 1;
					v_LastProcessDefId := v_ProcessDefId;
					v_LastToDoId := v_ToDoId;
				END LOOP;
				CLOSE v_Cursor;
			END;
			END IF;
		END;
	END;
	
	
	v_existFlag := 0;
	BEGIN
		BEGIN
			SELECT 1 INTO v_existFlag FROM information_schema.columns WHERE UPPER(table_name) = UPPER('TODOPICKLISTTABLE') and UPPER(column_name)=UPPER('PickListId');
			IF(NOT FOUND) THEN 
			BEGIN
				Execute ('alter table TODOPICKLISTTABLE add PickListId INTEGER ');
				v_LastProcessDefId := -1;
				v_LastToDoId := -1;
				v_PickListOrderId := -1;
				v_QueryStr := 'SELECT ProcessDefId, ToDoId, PickListValue FROM TODOPICKLISTTABLE ORDER BY ProcessDefId ASC, ToDoId ASC';
				OPEN v_Cursor FOR EXECUTE v_QueryStr;
				LOOP
					FETCH v_Cursor INTO v_ProcessDefId, v_ToDoId, v_PickListValue;
					IF (NOT FOUND) THEN
						EXIT;
					END IF;
					IF (v_LastProcessDefId <> v_ProcessDefId OR v_LastToDoId <> v_ToDoId) THEN
						v_PickListOrderId := 1;
					END IF;
					v_QueryStr := 'UPDATE TODOPICKLISTTABLE SET PickListId = ' || v_PickListOrderId || ' WHERE ProcessDefId = ' || v_ProcessDefId || ' AND ToDoId = ' || v_ToDoId || ' AND PickListValue = ''' || v_PickListValue || '''';
					EXECUTE (v_QueryStr);
					v_PickListOrderId := v_PickListOrderId + 1;
					v_LastProcessDefId := v_ProcessDefId;
					v_LastToDoId := v_ToDoId;
				END LOOP;
				CLOSE v_Cursor;
				Execute ('alter table TODOPICKLISTTABLE ALTER COLUMN PickListId set NOT NULL');
			END;
			END IF;
		END;
	END;
	
	BEGIN
		v_existFlag := 0;
		select tco.constraint_name into v_primaryName from information_schema.table_constraints tco join information_schema.key_column_usage kcu on kcu.constraint_name = tco.constraint_name and kcu.constraint_schema = tco.constraint_schema and kcu.constraint_name = tco.constraint_name where tco.constraint_type = 'PRIMARY KEY' and  lower(kcu.table_name)=lower('WFAuditTrailDocTable') ;
		GET DIAGNOSTICS v_existFlag = ROW_COUNT;
		IF(v_existFlag <> 3) THEN
			EXECUTE ('ALTER TABLE WFAuditTrailDocTable DROP CONSTRAINT '||v_primaryName);
			Execute ('ALTER TABLE WFAuditTrailDocTable ADD  PRIMARY KEY (ProcessInstanceId, WorkItemId, ActivityId)');
		END IF;
	END;
	
	BEGIN
		v_existFlag := 0;
		SELECT 1 INTO v_existFlag FROM information_schema.columns WHERE UPPER(table_name) = UPPER('ExtDBConfTable') and UPPER(column_name)=UPPER('HistoryTableName');
		IF(NOT FOUND) THEN 
			Execute ('ALTER TABLE ExtDBConfTable ADD HistoryTableName VARCHAR(128)');
		END IF;
	END;
	
	SELECT VariableId INTO v_variableid FROM VarMappingTable WHERE UPPER(SystemDefinedName) = UPPER('URN');
		GET DIAGNOSTICS v_rowCount = ROW_COUNT;
		IF (NOT FOUND) THEN 
			v_rowCount := 0;
		END IF;
		IF(v_rowCount < 1) THEN
				v_QueryStr := 'SELECT distinct(ProcessDefId) FROM VarMappingTable';
				OPEN Cursor1 FOR EXECUTE v_QueryStr;
				LOOP
					FETCH Cursor1 INTO v_ProcessDefId;
					IF (NOT FOUND) THEN
						EXIT;
					END IF;

					EXECUTE 'insert into VarMappingTable (ProcessDefId,VariableId,SystemDefinedName,UserDefinedName,VariableType,VariableScope,ExtObjId,DefaultValue,VariableLength,VarPrecision,Unbounded)  values('||CAST(v_ProcessDefId AS VARCHAR)|| ',  10023,    ''URN'',''URN'',     10,    ''S''    ,0,    ''N'',    63   ,0    ,''N'')';
				END LOOP;
				CLOSE Cursor1;
		END IF;	
		
	v_existFlag := 0;
	SELECT 1 INTO v_existFlag FROM information_schema.columns WHERE UPPER(table_name) = UPPER('QUEUEUSERTABLE') and UPPER(column_name)=UPPER('EDITABLEONQUERY');
	IF(NOT FOUND) THEN 
		Execute ('Alter table QUEUEUSERTABLE ADD EDITABLEONQUERY  VARCHAR(1)  DEFAULT N''N'' NOT NULL');
	END IF;
	
	v_existFlag := 0;
	SELECT 1 INTO v_existFlag FROM information_schema.columns WHERE UPPER(table_name) = UPPER('QUSERGROUPVIEW') and UPPER(column_name)=UPPER('EDITABLEONQUERY');
	IF(NOT FOUND) THEN 
		Execute ('CREATE OR REPLACE VIEW QUSERGROUPVIEW AS SELECT queueId,userId, NULL AS groupId, AssignedtillDateTime, queryFilter, QueryPreview , EditableonQuery FROM   QUEUEUSERTABLE  WHERE  ASsociationtype=0 AND (AssignedtillDateTime IS NULL OR AssignedtillDateTime>=CURRENT_TIMESTAMP) UNION SELECT queueId, userindex,userId AS groupId,NULL AS AssignedtillDateTime, queryFilter, QueryPreview ,EditableonQuery FROM   QUEUEUSERTABLE , WFGROUPMEMBERVIEW WHERE  ASsociationtype=1 AND    QUEUEUSERTABLE.userId=WFGROUPMEMBERVIEW.groupindex ');
	END IF;
	
	BEGIN
		v_existFlag := 0;
		SELECT 1 INTO v_existFlag FROM information_schema.columns WHERE UPPER(table_name) = UPPER('WFDocBuffer') and UPPER(column_name)=UPPER('AttachmentName');
		IF(NOT FOUND) THEN 
			Execute ('ALTER TABLE WFDocBuffer ADD AttachmentName VARCHAR(255)  DEFAULT ''Attachment'' NOT NULL');
		END IF;
	END;
	
	
	BEGIN
		v_existFlag := 0;
		SELECT 1 INTO v_existFlag FROM information_schema.columns WHERE UPPER(table_name) = UPPER('WFDocBuffer') and UPPER(column_name)=UPPER('AttachmentType');
		IF(NOT FOUND) THEN 
			Execute ('ALTER TABLE WFDocBuffer ADD AttachmentType VARCHAR(1)  DEFAULT ''A'' NOT NULL');
		END IF;
	END;
	
	BEGIN
		v_existFlag := 0;
		SELECT 1 INTO v_existFlag FROM information_schema.columns WHERE UPPER(table_name) = UPPER('WFDocBuffer') and UPPER(column_name)=UPPER('RequirementId');
		IF(NOT FOUND) THEN 
			Execute ('ALTER TABLE WFDocBuffer ADD RequirementId INTEGER  DEFAULT -1 NOT NULL');
		END IF;
	END;


	BEGIN
		v_existFlag := 0;
		SELECT 1 INTO v_existFlag FROM pg_class WHERE UPPER(relname) = UPPER('WFRulesTable') ;
		IF(NOT FOUND) THEN 
			Execute ('CREATE TABLE WFRulesTable (
    ProcessDefId            INT             NOT NULL,
    ActivityID              INT             NOT NULL,
    RuleId                  INT             NOT NULL,
    Condition               VARCHAR(255)    NOT NULL,
    Action                  VARCHAR(255)    NOT NULL    
)');
		END IF;
	END;
	
	BEGIN
		v_existFlag := 0;
		SELECT 1 INTO v_existFlag FROM pg_class WHERE UPPER(relname) = UPPER('WFSectionsTable') ;
		IF(NOT FOUND) THEN 
			Execute ('CREATE TABLE WFSectionsTable (
    ProcessDefId            INT             NOT NULL,
    ProjectId               INT             NOT NULL,
    OrderId                 INT             NOT NULL,
    SectionName             VARCHAR(255)    NOT NULL,
    Description             VARCHAR(255)    NULL,
    Exclude                 VARCHAR(1)  	DEFAULT ''N'' NOT NULL,
    ParentID                INT 			DEFAULT 0 NOT NULL,
    SectionId               INT             NOT NULL
)');
		END IF;
	END;
	
	BEGIN
		v_existFlag := 0;
		SELECT 1 INTO v_existFlag FROM pg_indexes WHERE upper(tablename) = upper('WFINSTRUMENTTABLE') and upper(indexname)=upper('IDX2_WFINSTRUMENTTABLE');
		IF(v_existFlag=1) THEN 
			EXECUTE  ('DROP INDEX IDX2_WFINSTRUMENTTABLE');
		END IF;
	END;
	BEGIN
		v_existFlag := 0;
		SELECT 1 INTO v_existFlag FROM pg_indexes WHERE upper(tablename) = upper('WFINSTRUMENTTABLE') and upper(indexname)=upper('IDX3_WFINSTRUMENTTABLE');
		IF(v_existFlag=1) THEN 
			EXECUTE  ('DROP INDEX IDX3_WFINSTRUMENTTABLE');
		END IF;
	END;
	BEGIN
		v_existFlag := 0;
		SELECT 1 INTO v_existFlag FROM pg_indexes WHERE upper(tablename) = upper('WFINSTRUMENTTABLE') and upper(indexname)=upper('IDX5_WFINSTRUMENTTABLE');
		IF(v_existFlag=1) THEN 
			EXECUTE  ('DROP INDEX IDX5_WFINSTRUMENTTABLE');
		END IF;
	END;
	BEGIN
		v_existFlag := 0;
		SELECT 1 INTO v_existFlag FROM pg_indexes WHERE upper(tablename) = upper('WFINSTRUMENTTABLE') and upper(indexname)=upper('IDX7_WFINSTRUMENTTABLE');
		IF(v_existFlag=1) THEN 
			EXECUTE  ('DROP INDEX IDX7_WFINSTRUMENTTABLE');
		END IF;
	END;
	BEGIN
		v_existFlag := 0;
		SELECT 1 INTO v_existFlag FROM pg_indexes WHERE upper(tablename) = upper('WFINSTRUMENTTABLE') and upper(indexname)=upper('IDX8_WFINSTRUMENTTABLE');
		IF(v_existFlag=1) THEN 
			EXECUTE  ('DROP INDEX IDX8_WFINSTRUMENTTABLE');
		END IF;
	END;
	BEGIN
		v_existFlag := 0;
		SELECT 1 INTO v_existFlag FROM pg_indexes WHERE upper(tablename) = upper('WFINSTRUMENTTABLE') and upper(indexname)=upper('IDX9_WFINSTRUMENTTABLE');
		IF(v_existFlag=1) THEN 
			EXECUTE  ('DROP INDEX IDX9_WFINSTRUMENTTABLE');
		END IF;
	END;
	BEGIN
		v_existFlag := 0;
		SELECT 1 INTO v_existFlag FROM pg_indexes WHERE upper(tablename) = upper('WFINSTRUMENTTABLE') and upper(indexname)=upper('IDX12_WFINSTRUMENTTABLE');
		IF(v_existFlag=1) THEN 
			EXECUTE  ('DROP INDEX IDX12_WFINSTRUMENTTABLE');
		END IF;
	END;
	BEGIN
		v_existFlag := 0;
		SELECT 1 INTO v_existFlag FROM pg_indexes WHERE upper(tablename) = upper('WFINSTRUMENTTABLE') and upper(indexname)=upper('IDX14_WFINSTRUMENTTABLE');
		IF(NOT FOUND) THEN 
			EXECUTE  ('CREATE INDEX IDX14_WFINSTRUMENTTABLE ON WFINSTRUMENTTABLE(Q_QueueId, LockStatus, PriorityLevel)');
		ELSE
		    EXECUTE  ('DROP INDEX IDX14_WFINSTRUMENTTABLE');
			EXECUTE  ('CREATE INDEX IDX14_WFINSTRUMENTTABLE ON WFINSTRUMENTTABLE(Q_QueueId, LockStatus, PriorityLevel)');	
		END IF;
	END;
	BEGIN
		v_existFlag := 0;
		SELECT 1 INTO v_existFlag FROM pg_indexes WHERE upper(tablename) = upper('WFINSTRUMENTTABLE') and upper(indexname)=upper('IDX15_WFINSTRUMENTTABLE');
		IF(NOT FOUND) THEN 
			EXECUTE  ('CREATE INDEX IDX15_WFINSTRUMENTTABLE ON WFINSTRUMENTTABLE(Q_QueueId, LockStatus, ProcessInstanceId, WorkitemId)');
		ELSE
		    EXECUTE  ('DROP INDEX IDX15_WFINSTRUMENTTABLE');
			EXECUTE  ('CREATE INDEX IDX15_WFINSTRUMENTTABLE ON WFINSTRUMENTTABLE(Q_QueueId, LockStatus, ProcessInstanceId,WorkitemId)');
		END IF;
	END;
	BEGIN
		v_existFlag := 0;
		SELECT 1 INTO v_existFlag FROM pg_indexes WHERE upper(tablename) = upper('WFINSTRUMENTTABLE') and upper(indexname)=upper('IDX16_WFINSTRUMENTTABLE');
		IF(NOT FOUND) THEN 
			EXECUTE  ('CREATE INDEX IDX16_WFINSTRUMENTTABLE ON WFINSTRUMENTTABLE(Q_QueueId, LockStatus, EntryDateTime)');
		ELSE
		    EXECUTE  ('DROP INDEX IDX16_WFINSTRUMENTTABLE');
			EXECUTE  ('CREATE INDEX IDX16_WFINSTRUMENTTABLE ON WFINSTRUMENTTABLE(Q_QueueId, LockStatus, EntryDateTime)');	
		END IF;
	END;
	BEGIN
		v_existFlag := 0;
		SELECT 1 INTO v_existFlag FROM pg_indexes WHERE upper(tablename) = upper('WFINSTRUMENTTABLE') and upper(indexname)=upper('IDX17_WFINSTRUMENTTABLE');
		IF(NOT FOUND) THEN 
			EXECUTE  ('CREATE INDEX IDX17_WFINSTRUMENTTABLE ON WFINSTRUMENTTABLE(Q_UserID, ProcessInstanceId, WorkitemId)');
		ELSE
		    EXECUTE  ('DROP INDEX IDX17_WFINSTRUMENTTABLE');
			EXECUTE  ('CREATE INDEX IDX17_WFINSTRUMENTTABLE ON WFINSTRUMENTTABLE(Q_UserID, ProcessInstanceId, WorkitemId)');	
		END IF;
	END;
	
	BEGIN
		EXECUTE 'select constraint_name from information_schema.table_constraints where UPPER(table_name)=UPPER(''TODOPICKLISTTABLE'') and constraint_type=''PRIMARY KEY''' INTO v_ConstraintName;
			
		IF (v_ConstraintName IS NOT NULL AND LENGTH(v_ConstraintName) > 0) THEN
			EXECUTE ('ALTER TABLE TODOPICKLISTTABLE DROP CONSTRAINT ' ||  v_ConstraintName);
			RAISE NOTICE 'Table TODOPICKLISTTABLE altered, Primary Key on TODOPICKLISTTABLE is dropped.';
		END IF;
		EXECUTE('ALTER TABLE TODOPICKLISTTABLE ADD PRIMARY KEY (ProcessDefId,ToDoId,PickListId)');
	END;
	
	v_existFlag := 0;
	BEGIN
	SELECT 1 INTO v_existFlag FROM information_schema.columns WHERE UPPER(table_name) = 'EXCEPTIONDEFTABLE' and UPPER(column_name)=UPPER('Description');
	IF(v_existFlag=1) THEN 
	BEGIN
		v_existFlag := 0;
		SELECT 1 into v_existFlag from information_schema.columns where UPPER(table_name) = UPPER('EXCEPTIONDEFTABLE') and UPPER(column_name) = UPPER('Description') and character_maximum_length < 1024;
		IF v_existFlag = 1 THEN
		BEGIN
			Execute ('ALTER TABLE EXCEPTIONDEFTABLE ALTER COLUMN Description TYPE VARCHAR(1024)');
		END;
		END IF;
	END;
	END IF;
	END;
	
	BEGIN
		v_existFlag := 0;
		SELECT 1 INTO v_existFlag from information_schema.tables where UPPER(table_name) = 'WFREPORTPROPERTIESTABLE';
		IF(NOT FOUND) THEN 
			Execute ('Create table WFReportPropertiesTable(
				CriteriaID				SERIAL PRIMARY KEY,
				CriteriaName			VARCHAR(255) UNIQUE NOT NULL,
				Description				VARCHAR(255) Null,
				ChartInfo				TEXT Null,
				ExcludeExitWorkitems	Char(1)   	Not Null ,
				State					int			Not Null ,
				LastModifiedOn  		TIMESTAMP		NULL
			)');
		END IF;
	END;
	
	BEGIN
		v_existFlag := 0;
		SELECT 1 INTO v_existFlag from information_schema.tables where UPPER(table_name) = 'WFFILTERDEFTABLE';
		IF(NOT FOUND) THEN 
			Execute ('Create Table WFFilterDefTable(
				FilterID	SERIAL PRIMARY KEY,
				FilterName	VARCHAR(255) NOT NULL,
				FilterXML	TEXT NOT NULL,
				CriteriaID	Int Not NULL,
				FilterColor VARCHAR(20) NOT NULL,
				ConditionOption	int not null,
				CONSTRAINT	uk_WFFilterDefTable UNIQUE(CriteriaID,FilterName)
			)');
		END IF;
	END;
	
	BEGIN
		v_existFlag := 0;
		SELECT 1 INTO v_existFlag from information_schema.tables where UPPER(table_name) = 'WFREPORTOBJASSOCTABLE';
		IF(NOT FOUND) THEN 
			Execute ('Create TABLE WFReportObjAssocTable(
				CriteriaID	Int NOT Null,
				ObjectID	Int NOT Null,
				ObjectType	Char (1) CHECK ( ObjectType in (N''P'' , N''Q'' , N''F'')),
				ObjectName	VARCHAR(255),
				CONSTRAINT	pk_WFReportObjAssocTable PRIMARY KEY(CriteriaID,ObjectID,ObjectType)
			)');
		END IF;
	END;
	
	BEGIN
		v_existFlag := 0;
		SELECT 1 INTO v_existFlag from information_schema.tables where UPPER(table_name) = 'WFREPORTVARMAPPINGTABLE';
		IF(NOT FOUND) THEN 
			Execute ('Create TABLE WFReportVarMappingTable(
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
			)');
		END IF;
	END;
	
	BEGIN
		v_existFlag := 0;
		SELECT 1 INTO v_existFlag FROM pg_class WHERE UPPER(relname) = UPPER('WFTransientVarTable') ;
		IF(NOT FOUND) THEN 
			Execute ('create TABLE WFTransientVarTable(
    ProcessDefId            INT              NOT NULL,
    OrderId                 INT              NOT NULL,
    FieldName               VARCHAR(50)      NOT NULL,
    FieldType               VARCHAR(255)     NOT NULL,
    FieldLength             INT              NULL,
    DefaultValue            VARCHAR(255)     NULL,
    VarPrecision            INT              NULL,    
	VarScope                   VARCHAR(2)   DEFAULT ''U''   NOT NULL,	
    constraint pk_WFTRANSIENTVARTABLE PRIMARY KEY (ProcessDefId,FieldName)
)');
		END IF;
	END;
	
	
	BEGIN
		v_existFlag := 0;
		SELECT 1 INTO v_existFlag FROM pg_class WHERE UPPER(relname) = UPPER('WFScriptData') ;
		IF(NOT FOUND) THEN 
			Execute ('create TABLE  WFScriptData(
    ProcessDefId           INT             NOT NULL,
    ActivityId             INT             NOT NULL,     
    RuleId                 INT             NOT NULL,
    OrderId                INT             NOT NULL,
    Command                varchar(255)    NOT NULL,
    Target                 varchar(255)    NULL,
    Value                  varchar(255)    NULL,
    Type                   varchar(1)      NULL,
    VariableId             INT             NOT NULL,
    VarFieldId             INT             NOT NULL,
    ExtObjId               INT             NOT NULL     
)');
		END IF;
	END;
	
	BEGIN
		v_existFlag := 0;
		SELECT 1 INTO v_existFlag FROM pg_class WHERE UPPER(relname) = UPPER('WFRuleFlowData') ;
		IF(NOT FOUND) THEN 
			Execute ('create TABLE  WFRuleFlowData(
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
  )');
		END IF;
	END;

	BEGIN
		v_existFlag := 0;
		SELECT 1 INTO v_existFlag FROM pg_class WHERE UPPER(relname) = UPPER('WFRuleFileInfo') ;
		IF(NOT FOUND) THEN 
			Execute ('create table WFRuleFileInfo(
    ProcessDefId             INT             NOT NULL,
    ActivityId               INT             NOT NULL,
    RuleId                   INT             NOT NULL,
    FileType                 varchar(1)      NOT NULL,
    RowHeader                INT             NOT NULL,
    Destination              varchar(255)    NULL,
    PickCriteria             varchar(255)    NULL,
    FromSize                 numeric(15,2)               NULL,
    ToSize                   numeric(15,2)               NULL,
    SizeUnit                 varchar(3)      NULL,
    FromModificationDate     TIMESTAMP       NULL,
    ToModificationDate       TIMESTAMP       NULL,
    FromCreationDate         TIMESTAMP       NULL,
    ToCreationDate           TIMESTAMP       NULL,
    PathType                 INT             NULL,
    DocId                    INT             NULL
)');
		END IF;
	END;
	
	BEGIN
		v_existFlag := 0;
		SELECT 1 INTO v_existFlag FROM pg_class WHERE UPPER(relname) = UPPER('WFWORKITEMMAPPINGTABLE') ;
		IF(NOT FOUND) THEN 
			Execute ('create table WFWORKITEMMAPPINGTABLE(
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
    MapType                  varchar(2)      DEFAULT ''V'' NOT NULL 
)');
		END IF;
	END;
	
	BEGIN
		v_existFlag := 0;
		SELECT 1 INTO v_existFlag FROM pg_class WHERE UPPER(relname) = UPPER('WFExcelMapInfo') ;
		IF(NOT FOUND) THEN 
			Execute ('create table WFExcelMapInfo(
    ProcessDefId             INT             NOT NULL,
    ActivityId               INT             NOT NULL,
    RuleId                   INT             NOT NULL,
    OrderId                  INT             NOT NULL,
    ColumnName               varchar(255)    NULL,
    ColumnType               INT             NOT NULL,
    VarName                  varchar(255)    NULL,
    VarScope                 varchar(1)      NULL,
    VarType                  INT             NOT NULL
)');
		END IF;
	END;
	
	BEGIN
		v_existFlag := 0;
		SELECT 1 INTO v_existFlag FROM pg_class WHERE UPPER(relname) = UPPER('WFRuleFlowMappingTable') ;
		IF(NOT FOUND) THEN 
			Execute ('create TABLE  WFRuleFlowMappingTable(
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
)');
		END IF;
	END;
	
	
	BEGIN
		v_existFlag := 0;
		SELECT 1 INTO v_existFlag FROM pg_class WHERE UPPER(relname) = UPPER('WFRoboticVarDocMapping') ;
		IF(NOT FOUND) THEN 
			Execute ('create TABLE  WFRoboticVarDocMapping(
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
    MapType                  varchar(2)      DEFAULT ''V'' NOT NULL 
)');
		END IF;
	END;
	
	BEGIN
		v_existFlag := 0;
		SELECT 1 INTO v_existFlag FROM pg_class WHERE UPPER(relname) = UPPER('WFAssociatedExcpTable') ;
		IF(NOT FOUND) THEN 
			Execute ('create TABLE  WFAssociatedExcpTable(
     ProcessDefId            INT             NOT NULL,
     ActivityId              INT             NOT NULL,
     OrderId                 INT             NOT NULL,
     CodeId                  varchar(1000)   NOT NULL, 
     TriggerId               varchar(1000)   NOT NULL                                                                                        
)
');
		END IF;
	END;
	
	BEGIN
		v_existFlag := 0;
		SELECT 1 INTO v_existFlag FROM pg_class WHERE UPPER(relname) = UPPER('WFRuleExceptionData') ;
		IF(NOT FOUND) THEN 
			Execute ('create TABLE  WFRuleExceptionData(
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
');
		END IF;
	END;
	
	BEGIN
		v_existFlag := 0;
		SELECT 1 INTO v_existFlag FROM pg_class WHERE UPPER(relname) = UPPER('WFDBDetails') ;
		IF(NOT FOUND) THEN 
			Execute ('CREATE TABLE WFDBDetails(
    ProcessDefId int NOT NULL,
    ActivityId int NOT NULL,
    IsolateFlag varchar(2) NOT NULL,
    ConfigurationID int NOT NULL
)
');
		END IF;
	END;
	
	BEGIN
		v_existFlag := 0;
		SELECT 1 INTO v_existFlag FROM pg_class WHERE UPPER(relname) = UPPER('WFTableDetails') ;
		IF(NOT FOUND) THEN 
			Execute ('CREATE TABLE WFTableDetails(
    ProcessDefId int NOT NULL,
    ActivityId int NOT NULL,
    RuleId int  NOT NULL,
    OrderId int  NOT NULL,
    EntityId int  NOT NULL,
    EntityName varchar(255) NOT NULL,
    EntityType varchar(2) NOT NULL
)
');
		END IF;
	END;
	
	BEGIN
		v_existFlag := 0;
		SELECT 1 INTO v_existFlag FROM pg_class WHERE UPPER(relname) = UPPER('WFTableJoinDetails') ;
		IF(NOT FOUND) THEN 
			Execute ('CREATE TABLE WFTableJoinDetails(
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
');
		END IF;
	END;
	
	
	BEGIN
		v_existFlag := 0;
		SELECT 1 INTO v_existFlag FROM pg_class WHERE UPPER(relname) = UPPER('WFTableFilterDetails') ;
		IF(NOT FOUND) THEN 
			Execute ('CREATE TABLE WFTableFilterDetails(
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
');
		END IF;
	END;
	
	
	BEGIN
		v_existFlag := 0;
		SELECT 1 INTO v_existFlag FROM pg_class WHERE UPPER(relname) = UPPER('WFTableMappingDetails') ;
		IF(NOT FOUND) THEN 
			Execute ('CREATE TABLE WFTableMappingDetails(
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
						OperationType varchar(2) Default ''E'' NOT NULL
)
');
		END IF;
	END;
	
	
		SELECT VariableId INTO v_variableid FROM VarMappingTable WHERE UPPER(SystemDefinedName) = UPPER('ManualProcessingFlag');
		GET DIAGNOSTICS v_rowCount = ROW_COUNT;
		IF (NOT FOUND) THEN 
			v_rowCount := 0;
		END IF;
		IF(v_rowCount < 1) THEN
				v_QueryStr := 'SELECT distinct(ProcessDefId) FROM VarMappingTable';
				OPEN Cursor1 FOR EXECUTE v_QueryStr;
				LOOP
					FETCH Cursor1 INTO v_ProcessDefId;
					IF (NOT FOUND) THEN
						EXIT;
					END IF;

					EXECUTE 'insert into VarMappingTable (ProcessDefId,VariableId,SystemDefinedName,UserDefinedName,VariableType,VariableScope,ExtObjId,DefaultValue,VariableLength,VarPrecision,Unbounded)  values('||CAST(v_ProcessDefId AS VARCHAR)|| ',  10024,    ''ManualProcessingFlag'',''ManualProcessingFlag'',     10,    ''M''    ,0,    ''N'',    1   ,0    ,''N'')';
				END LOOP;
				CLOSE Cursor1;
		END IF;	
		
		
		
	v_existFlag := 0;
	SELECT 1 INTO v_existFlag FROM information_schema.columns WHERE UPPER(table_name) = UPPER('WFBRMSRuleSetInfo') and UPPER(column_name)=UPPER('RuleType');
	IF(NOT FOUND) THEN 
		Execute ('Alter table WFBRMSRuleSetInfo ADD RuleType          	VARCHAR(1)    DEFAULT N''P'' NOT NULL');
	END IF;
	
	/* Adding changes for Columns DBExErrCode and DBExErrDesc */
	v_existFlag := 0;
	SELECT 1 INTO v_existFlag FROM information_schema.columns WHERE UPPER(table_name) = UPPER('WFINSTRUMENTTABLE') and UPPER(column_name)=UPPER('DBExErrCode');
	IF(NOT FOUND) THEN 
		Execute ('Alter table WFINSTRUMENTTABLE ADD DBExErrCode	Int	NULL');
	END IF;
	
	v_existFlag := 0;
	SELECT 1 INTO v_existFlag FROM information_schema.columns WHERE UPPER(table_name) = UPPER('WFINSTRUMENTTABLE') and UPPER(column_name)=UPPER('DBExErrDesc');
	IF(NOT FOUND) THEN 
		Execute ('Alter table WFINSTRUMENTTABLE ADD DBExErrDesc	VARCHAR(255) NULL');
	END IF;
	
	v_existFlag := 0;
	SELECT 1 INTO v_existFlag FROM information_schema.columns WHERE UPPER(table_name) = UPPER('QUEUEHISTORYTABLE') and UPPER(column_name)=UPPER('DBExErrCode');
	IF(NOT FOUND) THEN 
		Execute ('Alter table QUEUEHISTORYTABLE ADD DBExErrCode	Int	NULL');
	END IF;
	
	v_existFlag := 0;
	SELECT 1 INTO v_existFlag FROM information_schema.columns WHERE UPPER(table_name) = UPPER('QUEUEHISTORYTABLE') and UPPER(column_name)=UPPER('DBExErrDesc');
	IF(NOT FOUND) THEN 
		Execute ('Alter table QUEUEHISTORYTABLE  ADD DBExErrDesc	VARCHAR(255) NULL');
	END IF;
	
	SELECT VariableId INTO v_variableid FROM VarMappingTable WHERE UPPER(SystemDefinedName) = UPPER('DBExErrCode');
	GET DIAGNOSTICS v_rowCount = ROW_COUNT;
	IF (NOT FOUND) THEN 
		v_rowCount := 0;
	END IF;
	IF(v_rowCount < 1) THEN
			v_QueryStr := 'SELECT distinct(ProcessDefId) FROM VarMappingTable';
			OPEN Cursor1 FOR EXECUTE v_QueryStr;
			LOOP
				FETCH Cursor1 INTO v_ProcessDefId;
				IF (NOT FOUND) THEN
					EXIT;
				END IF;

				EXECUTE 'insert into VarMappingTable (ProcessDefId,VariableId,SystemDefinedName,UserDefinedName,VariableType,VariableScope,ExtObjId,DefaultValue,VariableLength,VarPrecision,Unbounded)  values('||CAST(v_ProcessDefId AS VARCHAR)|| ',  10025,    ''DBExErrCode'',''DBExErrCode'',     3,    ''M''    ,0,    NULL,    2   ,0    ,''N'')';
			END LOOP;
			CLOSE Cursor1;
	END IF;	
	
	SELECT VariableId INTO v_variableid FROM VarMappingTable WHERE UPPER(SystemDefinedName) = UPPER('DBExErrDesc');
	GET DIAGNOSTICS v_rowCount = ROW_COUNT;
	IF (NOT FOUND) THEN 
		v_rowCount := 0;
	END IF;
	IF(v_rowCount < 1) THEN
			v_QueryStr := 'SELECT distinct(ProcessDefId) FROM VarMappingTable';
			OPEN Cursor1 FOR EXECUTE v_QueryStr;
			LOOP
				FETCH Cursor1 INTO v_ProcessDefId;
				IF (NOT FOUND) THEN
					EXIT;
				END IF;

				EXECUTE 'insert into VarMappingTable (ProcessDefId,VariableId,SystemDefinedName,UserDefinedName,VariableType,VariableScope,ExtObjId,DefaultValue,VariableLength,VarPrecision,Unbounded)  values('||CAST(v_ProcessDefId AS VARCHAR)|| ',  10026,    ''DBExErrDesc'',''DBExErrDesc'',     10,    ''M''    ,0,    NULL,    255  ,0    ,''N'')';
			END LOOP;
			CLOSE Cursor1;
	END IF;	
	
	/* Adding changes for Columns DBExErrCode and DBExErrDesc till here */
	
	v_existFlag := 0;
	SELECT 1 INTO v_existFlag FROM information_schema.columns WHERE UPPER(table_name) = UPPER('WFINSTRUMENTTABLE') and UPPER(column_name)=UPPER('ManualProcessingFlag');
	IF(NOT FOUND) THEN 
		Execute ('Alter table WFINSTRUMENTTABLE ADD ManualProcessingFlag          	VARCHAR(1)    DEFAULT N''N'' NOT NULL');
	END IF;
	
	v_existFlag := 0;
	SELECT 1 INTO v_existFlag FROM information_schema.columns WHERE UPPER(table_name) = UPPER('QUEUEHISTORYTABLE') and UPPER(column_name)=UPPER('ManualProcessingFlag');
	IF(NOT FOUND) THEN 
		Execute ('Alter table QUEUEHISTORYTABLE ADD ManualProcessingFlag          	VARCHAR(1)    DEFAULT N''N'' NOT NULL');
	END IF;
	
	
	INSERT INTO WFCabVersionTable(cabVersion,  creationDate, lastModified, Remarks, Status) VALUES ('iBPS_4.0_SP1',  CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'UpgradeIBPS_A_OFserver_5.sql', 'Y');
	


	BEGIN
		R_COUNT := 0;
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
			INSERT INTO  EXTMETHODDEFTABLE (ProcessDefId, ExtMethodIndex, ExtAppName, ExtAppType, ExtMethodName, SearchMethod, SearchCriteria, ReturnType, MappingFile, ConfigurationID) VALUES (0, 10,'System','S','booleanValue','', NULL, 12,'', 0);
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
	EXCEPTION
		WHEN OTHERS THEN
			RAISE EXCEPTION USING MESSAGE = CONCAT('Insertion Failed With Error : ', SQLERRM);
			RETURN;
	END;
	BEGIN
		v_existFlag := 0;
		SELECT 1 into v_existFlag FROM PG_TRIGGER WHERE UPPER(TGNAME) = UPPER('WF_GROUP_DEL');
		IF(NOT FOUND) THEN 
			EXECUTE ('DELETE FROM USERQUEUETABLE');
		END IF;

		DROP TRIGGER IF EXISTS WF_GROUP_DEL ON PDBGROUP;
		CREATE TRIGGER WF_GROUP_DEL 
		AFTER DELETE ON PDBGROUP FOR EACH ROW
		EXECUTE PROCEDURE WFGroupDeletion();

		DROP TRIGGER IF EXISTS WF_GROUPMEMBER_UPD ON PDBGROUPMEMBER;
		CREATE TRIGGER WF_GROUPMEMBER_UPD 
		AFTER DELETE OR INSERT ON PDBGROUPMEMBER FOR EACH ROW 
		EXECUTE PROCEDURE WFGroupMemberChange();
	END;
	
	
	
	BEGIN
		v_existFlag := 0;
		SELECT 1 INTO v_existFlag from information_schema.tables where UPPER(table_name) = 'PDBPMS_TABLE';
		IF(NOT FOUND) THEN 
			Execute ('CREATE TABLE PDBPMS_TABLE
			(
               Product_Name   VARCHAR(255),
               Product_Version               VARCHAR(255),
               Product_Type     VARCHAR(255),
               Patch_Number   int,
               Install_Date    VARCHAR(255)
		)');
		END IF;
	END;
	
	

	BEGIN
		v_existFlag := 0;
		SELECT 1 INTO v_existFlag FROM information_schema.tables WHERE UPPER(table_name) = UPPER('WFDMSUserInfo');
		IF(NOT FOUND) THEN 
			EXECUTE ('CREATE TABLE WFDMSUserInfo(UserName VARCHAR(64) NOT NULL) ');
			EXECUTE ('INSERT INTO WFDMSUserInfo(UserName) VALUES(''Of_Sys_User'')');
		END IF;
	END;
	
	BEGIN
		v_existFlag := 0;
		SELECT 1 INTO v_existFlag from queuedeftable where UPPER(queuename) = 'SYSTEMDXQUEUE';
		IF(NOT FOUND) THEN 
			Execute ('Insert into QueueDefTable (QueueName, QueueType, Comments, OrderBy, SortOrder) values (''SystemDXQueue'', ''A'', ''System generated common Data Exchange Queue'', 10, ''A'')');
		END IF;
	END;
	
	BEGIN
		v_existFlag := 0;
		SELECT 1 INTO v_existFlag FROM pg_indexes WHERE upper(tablename) = upper('QueueHistoryTable') and upper(indexname)=upper('IDX5_QueueHistoryTable');
		IF(NOT FOUND) THEN 
			EXECUTE  ('CREATE INDEX IDX5_QueueHistoryTable ON QueueHistoryTable (Q_UserId, LockStatus)');
		END IF;
	END;
	
	BEGIN
		delete from WFRoutingServerInfo;
	END;
	
	BEGIN 
	v_queryStr := 'select distinct mappedobjectname from varmappingtable inner join wfudtvarmappingtable on varmappingtable.processdefid=wfudtvarmappingtable.processdefid
	and varmappingtable.variableid=wfudtvarmappingtable.variableid WHERE wfudtvarmappingtable.mappedobjecttype =''T'' and varmappingtable.unbounded=''Y''
	and wfudtvarmappingtable.parentvarfieldid=0';
	OPEN Cursor1 FOR EXECUTE v_queryStr;
		LOOP
			FETCH Cursor1 INTO c_tablename;
			IF (NOT FOUND) THEN
			EXIT;
			END IF;
	v_queryStr2:='select COALESCE (max(insertionorderid), 0)+1  from  ' ||c_tablename  ;
	EXECUTE  v_queryStr2 INTO v_insertionorderid;
	if(length(c_tablename)>28) then
		c_tablename:=SUBSTR(c_tablename,1,28);
         --insert into test45 values(32,c_tablename);
    end if;
	
	IF NOT EXISTS (SELECT 1 FROM pg_class where Upper(relname) = 'S_' ||Upper(c_tablename) )
		THEN
        	c_tablename:='S_'||c_tablename;
            if(v_insertionorderid is null) then
            	v_insertionorderid:=1;
             end if;
			EXECUTE 'CREATE SEQUENCE ' || c_tablename ||' INCREMENT BY 1 START WITH  '|| v_insertionorderid ;
		END IF;
   END LOOP;
   CLOSE Cursor1;
   
   v_queryStr := 'Select DISTINCT c.tablename from WFTypeDefTable a 
					inner join WFUDTVarMappingTable b
					on a.processdefid =b.processdefid
					and a.typefieldid = b.typefieldid 
					and a.ParentTypeId=b.TypeId
					inner join EXTDBCONFTABLE c
					on b.extobjid = c.extobjid
					and b.processdefid=c.processdefid
					and a.unbounded = ''Y''';
	OPEN Cursor1 FOR EXECUTE v_queryStr;
		LOOP
			FETCH Cursor1 INTO c_tablename;
			IF (NOT FOUND) THEN
			EXIT;
			END IF;
	v_queryStr2:='select COALESCE (max(insertionorderid), 0)+1  from  ' ||c_tablename  ;
	EXECUTE  v_queryStr2 INTO v_insertionorderid;
	if(length(c_tablename)>28) then
		c_tablename:=SUBSTR(c_tablename,1,28);
    end if;
	
	IF NOT EXISTS (SELECT 1 FROM pg_class where Upper(relname) = 'S_' ||upper(c_tablename) )
		THEN
			c_tablename:='S_'||c_tablename;
            if(v_insertionorderid is null) then
            	v_insertionorderid:=1;
            end if;
			EXECUTE 'CREATE SEQUENCE ' || c_tablename ||' INCREMENT BY 1 START WITH  '|| v_insertionorderid ;
	END IF;
	END LOOP;
	CLOSE Cursor1;
	
	 v_queryStr := 'select distinct b.tablename from varmappingtable a inner join EXTDBCONFTABLE b on a.processdefid=b.processdefid and a.extobjid=b.extobjid and a.unbounded=''Y'' and a.variabletype != 11 ';
	OPEN Cursor1 FOR EXECUTE v_queryStr;
		LOOP
			FETCH Cursor1 INTO c_tablename;
			IF (NOT FOUND) THEN
			EXIT;
			END IF;
	v_queryStr2:='select COALESCE (max(insertionorderid), 0)+1  from  ' ||c_tablename  ;
	EXECUTE  v_queryStr2 INTO v_insertionorderid;
	if(length(c_tablename)>28) then
		c_tablename:=SUBSTR(c_tablename,1,28);
    end if;
	
	IF NOT EXISTS (SELECT 1 FROM pg_class where Upper(relname) = 'S_' ||upper(c_tablename) )
		THEN
			c_tablename:='S_'||c_tablename;
            if(v_insertionorderid is null) then
            	v_insertionorderid:=1;
            end if;
			EXECUTE 'CREATE SEQUENCE ' || c_tablename ||' INCREMENT BY 1 START WITH  '|| v_insertionorderid ;
	END IF;
	END LOOP;
	CLOSE Cursor1;
   

	END; 

	BEGIN
		v_existFlag := 0;
		SELECT 1 INTO v_existFlag FROM INFORMATION_SCHEMA.COLUMNS WHERE UPPER(TABLE_NAME) = UPPER('WFSystemServicesTable') AND UPPER(COLUMN_NAME) = UPPER('RegisteredBy');
		IF(NOT FOUND) THEN 
			EXECUTE('ALTER TABLE WFSystemServicesTable ADD RegisteredBy VARCHAR(64) NULL DEFAULT ''SUPERVISOR''');
			EXECUTE('UPDATE WFSystemServicesTable SET RegisteredBy = ''SUPERVISOR''');
		END IF;
	END;

	BEGIN
		v_existFlag := 0;
		SELECT 1 INTO v_existFlag FROM INFORMATION_SCHEMA.TABLES WHERE UPPER(TABLE_NAME) = UPPER('WFCustomServicesStatusTable');
		IF(NOT FOUND) THEN 
			EXECUTE('CREATE TABLE WFCustomServicesStatusTable (
						PSID				INT NOT NULL PRIMARY KEY,
						ServiceStatus		INT NOT NULL,
						ServiceStatusMsg	VARCHAR(100) NOT NULL,
						WorkItemCount		INT NOT NULL,
						LastUpdated			TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
					)');
		END IF;
	END;

	BEGIN
		v_existFlag := 0;
		SELECT 1 INTO v_existFlag FROM INFORMATION_SCHEMA.TABLES WHERE UPPER(TABLE_NAME) = UPPER('WFServiceAuditTable');
		IF(NOT FOUND) THEN
			EXECUTE('CREATE SEQUENCE SEQ_WFSAT_LogId INCREMENT BY 1 START WITH 1');
			EXECUTE('CREATE TABLE WFServiceAuditTable (
						LogId 				INT NOT NUll DEFAULT NEXTVAL(''SEQ_WFSAT_LogId''),
						PSID				INT NOT NULL,
						ServiceName			VARCHAR(100) NOT NULL,
						ServiceType			VARCHAR(50) NOT NULL,
						ActionId			INT NOT NULL,
						ActionDateTime		TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
						Username			VARCHAR(64) NOT NULL,
						ServerDetails		VARCHAR(30) NOT NULL,
						ServiceParamDetails	VARCHAR(1000) NULL
					)');
			EXECUTE('CREATE INDEX IDX1_WFServiceAuditTable ON WFServiceAuditTable(PSID, UPPER(UserName), ActionDateTime)');
		END IF;
	END;

	BEGIN
		v_existFlag := 0;
		SELECT 1 INTO v_existFlag FROM INFORMATION_SCHEMA.TABLES WHERE UPPER(TABLE_NAME) = UPPER('WFServiceAuditTable_History');
		IF(NOT FOUND) THEN
			EXECUTE('CREATE TABLE WFServiceAuditTable_History (
						LogId 				INT NOT NUll,
						PSID				INT NOT NULL,
						ServiceName			VARCHAR(100) NOT NULL,
						ServiceType			VARCHAR(50) NOT NULL,
						ActionId			INT NOT NULL,
						ActionDateTime		TIMESTAMP NOT NULL,
						Username			VARCHAR(64) NOT NULL,
						ServerDetails		VARCHAR(30) NOT NULL,
						ServiceParamDetails	VARCHAR(1000) NULL
					)');
		END IF;
	END;

	BEGIN
		v_existFlag := 0;
		SELECT 1 INTO v_existFlag FROM INFORMATION_SCHEMA.TABLES WHERE UPPER(TABLE_NAME) = UPPER('WFServicesListTable');
		IF(NOT FOUND) THEN
			EXECUTE('CREATE TABLE WFServicesListTable (
						PSID				INT NOT NULL,
						ServiceId			INT NOT NULL,
						ServiceName			VARCHAR(50) NOT NULL,
						ServiceType			VARCHAR(50) NOT NULL,
						ProcessDefId		INT NOT NULL,
						ActivityId			INT NOT NULL
					)');
			EXECUTE('INSERT INTO WFServicesListTable(PSID, ServiceId, ServiceName, ServiceType, ProcessDefId, ActivityId) SELECT PSID, ServiceId, ServiceName, ServiceType, COALESCE(ProcessDefId, 0), 0 FROM WFSystemServicesTable');
		END IF;
	END;
	
	
	BEGIN
		v_existFlag := 0;
		SELECT 1 INTO v_existFlag FROM information_schema.columns WHERE UPPER(table_name) = 'PROCESSDEFTABLE' and UPPER(column_name)=UPPER('VolumeId');
		IF(NOT FOUND) THEN 
			BEGIN
				Execute ('alter table PROCESSDEFTABLE add VolumeId INT NULL');
				v_QueryStr := 'SELECT distinct(ProcessDefId) FROM ProcessDefTable';
				OPEN Cursor1 FOR EXECUTE v_QueryStr;
				LOOP
					FETCH Cursor1 INTO v_ProcessDefId;
					IF (NOT FOUND) THEN
						EXIT;
					END IF;
					
					SELECT WorkFlowFolderId into v_folderIndex FROM RouteFolderDefTable where ProcessDefId=v_ProcessDefId;
					SELECT ImageVolumeIndex into v_volumeId FROM PDBFolder where FolderIndex=v_folderIndex;
						
					EXECUTE  'UPDATE ProcessDefTable SET VolumeID = '||v_volumeId||' where ProcessdefId='||v_ProcessDefId;
				END LOOP;
				CLOSE Cursor1;
			END;
		END IF;
	END;
	
	BEGIN
		v_existFlag := 0;
		SELECT 1 INTO v_existFlag FROM information_schema.columns WHERE UPPER(table_name) = 'PROCESSDEFTABLE' and UPPER(column_name)=UPPER('SiteId');
		IF(NOT FOUND) THEN 
			BEGIN
				Execute ('alter table PROCESSDEFTABLE add SiteId INT NULL');
				v_QueryStr := 'SELECT distinct(ProcessDefId) FROM ProcessDefTable';
				OPEN Cursor1 FOR EXECUTE v_QueryStr;
				LOOP
					FETCH Cursor1 INTO v_ProcessDefId;
					IF (NOT FOUND) THEN
						EXIT;
					END IF;
					
					SELECT WorkFlowFolderId into v_folderIndex FROM RouteFolderDefTable where ProcessDefId=v_ProcessDefId;
					SELECT ImageVolumeIndex into v_volumeId FROM PDBFolder where FolderIndex=v_folderIndex;
					--SELECT HomeSite into v_siteId From ISVOLUME where VolumeId=v_volumeId;
					SELECT CABINETTYPE into v_cabinettype FROM PDBCABINET;
					IF (v_cabinettype = 'R') THEN
					BEGIN
						v_siteId := 1;
						RAISE NOTICE 'IF v_siteId AND  SCRIPT --> %', v_siteId ;
						
					END;
					ELSE 
					BEGIN
						--SELECT HomeSite into v_siteId From ISVOLUME where VolumeId=v_volumeId
						V_QUERYSTR1 := 'SELECT HomeSite From ISVOLUME where VolumeId= $1';
						
						EXECUTE V_QUERYSTR1 USING v_volumeId INTO v_siteId;
						
						IF(v_siteId IS NULL ) THEN
						BEGIN
							v_siteId := 1;
							--RAISE NOTICE 'IF v_siteId is null AND  SCRIPT  '
							--RAISE NOTICE 'IF v_siteId is null AND  SCRIPT  %', v_siteId ;
						
						END;
						END IF;
						
						RAISE NOTICE 'else v_siteId AND  SCRIPT --> %', v_siteId ;
				
					END;
					END IF;				  
					EXECUTE  'UPDATE ProcessDefTable SET SiteId = '||v_siteId||' where ProcessdefId='||v_ProcessDefId;
				END LOOP;
				CLOSE Cursor1;
			END;
		END IF;
	END;
	
	BEGIN
		update wfactionstatustable set type ='C',status='N' where actionid in (23,24) and status = 'Y'; 
	END;
	/*	UnComment below block for iBPS 4.0 SP1 HOTFIX*/
	BEGIN
	v_existFlag := 0;
	SELECT 1 INTO v_existFlag FROM pg_indexes WHERE upper(tablename) = upper('WFINSTRUMENTTABLE') and upper(indexname)=upper('IDX12_WFINSTRUMENTTABLE');
	IF(NOT FOUND) THEN 
		--EXECUTE  ('CREATE INDEX IDX2_WFEscalationTable ON WFEscalationTable (ScheduleTime)');
		EXECUTE ('CREATE INDEX IDX12_WFINSTRUMENTTABLE ON WFINSTRUMENTTABLE(ASSIGNMENTTYPE  , VALIDTILL  ,ROUTINGSTATUS  ,LOCKSTATUS)');
	END IF;
	END;
	
	BEGIN
	v_existFlag := 0;
	SELECT 1 INTO v_existFlag FROM pg_indexes WHERE upper(tablename) = upper('WFINSTRUMENTTABLE') and upper(indexname)=upper('IDX19_WFINSTRUMENTTABLE');
	IF(NOT FOUND) THEN 
				EXECUTE ('CREATE INDEX IDX19_WFINSTRUMENTTABLE ON WFINSTRUMENTTABLE(ProcessDefId, ActivityId)');
	END IF;
	END;
	
	BEGIN
	v_existFlag := 0;
	SELECT 1 INTO v_existFlag FROM pg_indexes WHERE upper(tablename) = upper('QueueHistoryTable') and upper(indexname)=upper('IDX6_QueueHistoryTable');
	IF(NOT FOUND) THEN 
		--EXECUTE  ('CREATE INDEX IDX2_WFEscalationTable ON WFEscalationTable (ScheduleTime)');
		EXECUTE ('CREATE INDEX IDX6_QueueHistoryTable ON QueueHistoryTable (ProcessDefId, ActivityId)');
	END IF;
	END;
	
	BEGIN
	v_existFlag := 0;
	SELECT 1 INTO v_existFlag FROM pg_indexes WHERE upper(tablename) = upper('WFINSTRUMENTTABLE') and upper(indexname)=upper('IDX4_WFINSTRUMENTTABLE');
	IF(v_existFlag=1) THEN 
		EXECUTE  ('DROP INDEX IDX4_WFINSTRUMENTTABLE');
	END IF;
	END;
	
	BEGIN
	v_existFlag := 0;
	SELECT 1 INTO v_existFlag FROM pg_indexes WHERE upper(tablename) = upper('WFINSTRUMENTTABLE') and upper(indexname)=upper('IDX11_WFINSTRUMENTTABLE');
	IF(v_existFlag=1) THEN 
		EXECUTE  ('DROP INDEX IDX11_WFINSTRUMENTTABLE');
	END IF;
	END;
	
	BEGIN
	v_existFlag := 0;
	SELECT 1 INTO v_existFlag FROM pg_indexes WHERE upper(tablename) = upper('QueueHistoryTable') and upper(indexname)=upper('IDX2_QueueHistoryTable');
	IF(v_existFlag=1) THEN 
		EXECUTE  ('DROP INDEX IDX2_QueueHistoryTable');
	END IF;
	END;
	
	BEGIN
	v_existFlag := 0;
	SELECT 1 INTO v_existFlag FROM pg_indexes WHERE upper(tablename) = upper('QueueHistoryTable') and upper(indexname)=upper('IDX4_QueueHistoryTable');
	IF(v_existFlag=1) THEN 
		EXECUTE  ('DROP INDEX IDX4_QueueHistoryTable');
	END IF;
	END;
	
	BEGIN
	v_existFlag := 0;
	SELECT 1 INTO v_existFlag FROM pg_indexes WHERE upper(tablename) = upper('QueueHistoryTable') and upper(indexname)=upper('IDX5_QueueHistoryTable');
	IF(v_existFlag=1) THEN 
		EXECUTE  ('DROP INDEX IDX5_QueueHistoryTable');
	END IF;
	END;						  

	BEGIN
		CREATE OR REPLACE VIEW WORKLISTTABLE AS SELECT ProcessInstanceId, WorkItemId, ProcessName, ProcessVersion, ProcessDefID, LastProcessedBy, ProcessedBy, ActivityName, ActivityId, EntryDateTime, ParentWorkItemId, AssignmentType, CollectFlag, PriorityLevel, ValidTill, Q_StreamId, Q_QueueId, Q_UserId, AssignedUser, FilterValue, CreatedDatetime, WorkItemState, Statename, ExpectedWorkitemDelay, PreviousStage, LockedByName, LockStatus, LockedTime, Queuename, Queuetype, NotifyStatus, Guid, Q_DivertedByUserId FROM WFInstrumentTable WHERE RoutingStatus = 'N' AND LockStatus = 'N';
	END;


	BEGIN
		BEGIN
			 V_CURSOR_STR := 'SELECT ProcessDefId, ActivityId, ExpiryActivity FROM ACTIVITYTABLE where ExpiryActivity is not null and ExpiryActivity <> '' '' and length(ExpiryActivity) > 0  and UPPER(ExpiryActivity) <> UPPER(''previousstage'')';
			BEGIN		
				OPEN cursor1 FOR EXECUTE V_CURSOR_STR;
				LOOP
					FETCH cursor1 INTO V_PROCESSDEFID , V_ACTIVITYID , V_EXPIRYACTIVITY;
					IF (NOT FOUND) THEN
						EXIT;
					END IF;
					BEGIN 
						Select COUNT(1) INTO V_COUNT FROM WORKSTAGELINKTABLE  where type = 'X' and ProcessDefId = V_PROCESSDEFID and SourceId = V_ACTIVITYID;
						IF (V_COUNT IS NULL OR  V_COUNT = 0) THEN
							BEGIN
								Raise Notice 'ABCD';
								V_QUERYSTR := 'select MAX(connectionid) from WORKSTAGELINKTABLE where ProcessDefId = $1';
								
								EXECUTE V_QUERYSTR INTO V_CONNID USING V_PROCESSDEFID ;
								
								V_QUERYSTR := 'select ActivityId from ACTIVITYTABLE where ActivityName = $1 and ProcessDefId = $2';
								
								EXECUTE V_QUERYSTR INTO V_Expiray_ActivityId USING V_EXPIRYACTIVITY , V_PROCESSDEFID ;
								
								
								V_QUERYSTR := 'INSERT into WORKSTAGELINKTABLE (ProcessDefId,SourceId,TargetId,color,Type, ConnectionId)	
								values (  $1,  $2 ,  $3, 1234 , ''X'', $4)';
				
								EXECUTE V_QUERYSTR USING V_PROCESSDEFID,  V_ACTIVITYID ,  V_Expiray_ActivityId , V_CONNID;
							
							END;
						END IF;	
					END;
				--	COMMIT;
				END LOOP;
				CLOSE cursor1;

			END;
			exception when others then 
				raise  'The transaction is in an uncommittable state. ';
				raise  '% %', SQLERRM, SQLSTATE;
				
			END;
		END;
END;
$$LANGUAGE plpgsql;
~
SELECT Upgrade();
~
DROP FUNCTION Upgrade();
~