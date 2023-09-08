/*_____________________________________________________________________________________________________________________-
		NEWGEN SOFTWARE TECHNOLOGIES LIMITED

	Group						: Genesis
	Product / Project			: iBPS
	Module						: Transaction Server
	File NAME					: TableScript_Server.sql (Postgres Server)
	Author						: Mohnish Chopra
	Date written (DD/MM/YYYY)	: 08/10/2020
	Description					: This file contains the list of changes done after release of iBPS 5.0 sp1
_______________________________________________________________________________________________________________________-
			CHANGE HISTORY
_______________________________________________________________________________________________________________________-
Date		Change By			Change Description (Bug No. (If Any))
24/09/2020  Shubham Singla      Bug 94270 - iBPS 4.0 :-MessageId column needs to be added in WFInitiationAgentReportTable. 
02/11/2020	Mohnish Chopra		Changes for Generate response and Locale handling
29/01/2021  Sourabh Tantuway   Bug 97518 - iBPS 4.0 + Asynchronous : WMCreateworkitem API in Process Server is getting failed if escalation criteria is containing mailTo list above length 256.
20/10/2021	Vardaan Arora	   Bug 102127 - In User list or Group List ,Only those Users should be fetched whose parent group is same as that of logged in user.
11/02/2022	Ashutosh Pandey		Bug 105376 - Support for sorting on complex array primitive member
11/02/2022	Vardaan Arora		Bug 105448 - Trigger (TR_USR_DEL) which is used to release work-items on user deletion is not working properly
______________________________________________________________________________________________________________________-*/

CREATE OR REPLACE FUNCTION  TableScript() 
RETURNS void AS $$
DECLARE 

	v_existFlag		INTEGER;
	V_QUERYSTR VARCHAR(2000);
	v_ProcessDefId 			INTEGER;
	ErrorMessage VARCHAR(1000);
	InputFormat varchar(100);
	Tool varchar(50);
	Processdefid integer;
	Templateid INTEGER;
	TemplateFileName varchar(500);
	TemplateFileName_out varchar(500);
	existsFlag INTEGER;
	Template_Curosr 			REFCURSOR;	
	v_variableid 		INTEGER;
	v_rowCount 			INTEGER;
	Cursor1 			REFCURSOR;
	FileName 			varchar(500);
	triggerid			INTEGER;
	FileName_out        varchar(500);
	GenrateResponse_Curosr  REFCURSOR;
	v_ConstraintName 	VARCHAR(100);
	V_CURSOR1   REFCURSOR;
	sDATA VARCHAR(32000);
	USREID INTEGER;
	vOBJECTID INTEGER;
	vOBJECTNAME VARCHAR(5);
	vOBJECTTYPE VARCHAR(5);
	TempDATA VARCHAR(32000);
	TempIndex1 INTEGER;
	TempIndex2 INTEGER;
	chunk1 VARCHAR(32000);
	chunk2 VARCHAR(32000);
	chunk3 VARCHAR(200);
	tempSubstr VARCHAR(32000);


BEGIN
	
	BEGIN
		v_existFlag := 0;
		SELECT 1 INTO v_existFlag FROM information_schema.columns WHERE UPPER(table_name) = UPPER('WFInitiationAgentReportTable') and UPPER(column_name)=UPPER('MessageId');
		IF(NOT FOUND) THEN 
			Execute ('Alter table WFInitiationAgentReportTable ADD MessageId  VARCHAR(1000)  NULL');
		END IF;
	END; 
	
	BEGIN 
		
		
		SELECT count(1) INTO existsFlag FROM information_schema.columns  WHERE UPPER(table_name) = UPPER('TemplateDefinitionTable') and UPPER(column_name)=UPPER('InputFormat');
		IF(existsFlag = 0) THEN
		BEGIN
			
			ALTER TABLE TemplateDefinitionTable ADD column InputFormat VARCHAR(10) NULL, ADD column Tools VARCHAR(20) NULL, ADD column DateTimeFormat VARCHAR(50) NULL;
		
				v_QueryStr	:= 'SELECT  TemplateFileName, ProcessDefId, TemplateId FROM TEMPLATEDEFINITIONTABLE';
				
				BEGIN
					IF EXISTS(SELECT * FROM pg_cursors WHERE name = 'Template_Curosr') THEN
						CLOSE Template_Curosr;
					END IF;
					OPEN Template_Curosr FOR EXECUTE v_QueryStr;
						LOOP
							FETCH Template_Curosr INTO TemplateFileName,Processdefid , Templateid;
							IF (NOT FOUND) THEN
								EXIT;
							END IF;
							
							V_QUERYSTR := 'SELECT SUBSTR( $1, 1, LENGTH($2) - Strpos(REVERSE($3) ,''.''))' ;
							--V_QUERYSTR := 'SELECT SUBSTR( 'abcdef.txt', 1, LENGTH('abcdef.txt') - Strpos(REVERSE('abcdef.txt') ,'.'))' ;
							EXECUTE V_QUERYSTR INTO TemplateFileName_out USING TemplateFileName , TemplateFileName , TemplateFileName;
							
							
							RAISE NOTICE 'TemplateFileName_out %', TemplateFileName_out;
							
							V_QUERYSTR := 'select Right( $1, Strpos(REVERSE($2),''.'') -1 )';
							EXECUTE V_QUERYSTR INTO InputFormat USING TemplateFileName , TemplateFileName , TemplateFileName;
							
							RAISE NOTICE 'InputFormat %', InputFormat;
							
							
							IF(InputFormat = 'odt' OR InputFormat = 'doc') THEN
							BEGIN
								Tool := 'Open Office';
							END;
							ELSIF ( InputFormat = 'docx' ) THEN
							BEGIN
								Tool := 'MS Office';
							END;
							ELSIF( InputFormat = 'htm' OR  InputFormat = 'html') THEN
							BEGIN
								Tool := 'AddIns(Java)';
							END;
							ELSE
							BEGIN
								Tool := '';
							END;
							END IF;
							
							
							RAISE NOTICE 'tOOL %', Tool;
							
							V_QUERYSTR := 'UPDATE TemplateDefinitionTable 
							SET TemplateFileName =  $1 , InputFormat =  $2 , Tools =  $3 , DateTimeFormat = ''dd/MM/yyyy''
							where processdefid =  $4  and templateid = $5';
							
							EXECUTE V_QUERYSTR USING TemplateFileName_out , InputFormat, Tool , Processdefid , templateid;
							
							--FETCH Template_Curosr INTO TemplateFileName,Processdefid , Templateid;
					
							
				
						END LOOP;
					Close  Template_Curosr;
					EXCEPTION 
						   WHEN OTHERS THEN 
						Close  Template_Curosr; 		
				END;         
						
				

				
				
				v_QueryStr	:= 'select Filename,Processdefid,triggerid from GenerateResponseTable';
				
				BEGIN
					IF EXISTS(SELECT * FROM pg_cursors WHERE name = 'GenrateResponse_Curosr') THEN
						CLOSE GenrateResponse_Curosr;
					END IF;
					OPEN GenrateResponse_Curosr FOR EXECUTE v_QueryStr;
						LOOP
						
						FETCH GenrateResponse_Curosr INTO FileName, Processdefid , triggerid;
							IF (NOT FOUND) THEN
								EXIT;
							END IF;
							
							V_QUERYSTR := 'SELECT SUBSTR( $1, 1, LENGTH($2) - Strpos(REVERSE($3) ,''.''))' ;
							EXECUTE V_QUERYSTR INTO FileName_out USING FileName , FileName , FileName;
							
							V_QUERYSTR := 'UPDATE GenerateResponseTable 
							SET FileName =  $1 
							where processdefid =  $2  and triggerid = $3';
							
							EXECUTE V_QUERYSTR USING FileName_out , Processdefid , triggerid;
							
							--FETCH Template_Curosr INTO TemplateFileName,Processdefid , Templateid;
					
							
				
						END LOOP;
					Close  GenrateResponse_Curosr;
					EXCEPTION 
						   WHEN OTHERS THEN 
						Close  GenrateResponse_Curosr; 		
				END;         
							
				
				
			END;
		END IF;	
	END;			
	v_existFlag := 0;
	SELECT 1 INTO v_existFlag FROM information_schema.columns WHERE UPPER(table_name) = UPPER('WFINSTRUMENTTABLE') and UPPER(column_name)=UPPER('LOCALE');
	IF(NOT FOUND) THEN 
		Execute ('Alter table WFINSTRUMENTTABLE ADD LOCALE          	VARCHAR(30)    DEFAULT N''en_US''');
	END IF;
	
	v_existFlag := 0;
	SELECT 1 INTO v_existFlag FROM information_schema.columns WHERE UPPER(table_name) = UPPER('QUEUEHISTORYTABLE') and UPPER(column_name)=UPPER('LOCALE');
	IF(NOT FOUND) THEN 
		Execute ('Alter table QUEUEHISTORYTABLE ADD LOCALE          	VARCHAR(30)    DEFAULT N''en_US''');
	END IF;
	
	v_existFlag := 0;
	SELECT 1 INTO v_existFlag FROM information_schema.triggers WHERE UPPER(trigger_name) = 'TR_USR_DEL';
	IF(FOUND) THEN 
		Execute ('DROP TRIGGER TR_USR_DEL ON PDBUser');
	END IF;
	Execute ('CREATE TRIGGER TR_USR_DEL
					AFTER UPDATE ON PDBUSER
					FOR EACH ROW
					WHEN (NEW.DeletedFlag = ''Y'')
					EXECUTE PROCEDURE WFUserDeletion()');
	
	SELECT VariableId INTO v_variableid FROM VarMappingTable WHERE UPPER(SystemDefinedName) = UPPER('LOCALE');
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

					EXECUTE 'insert into VarMappingTable (ProcessDefId,VariableId,SystemDefinedName,UserDefinedName,VariableType,VariableScope,ExtObjId,DefaultValue,VariableLength,VarPrecision,Unbounded)  values('||CAST(v_ProcessDefId AS VARCHAR)|| ',  10027,    ''LOCALE'',''LOCALE'',     10,    ''M''    ,0,    NULL,    30   ,0    ,''N'')';
				END LOOP;
				CLOSE Cursor1;
		END IF;	
	
	
	BEGIN
		EXECUTE 'select constraint_name from information_schema.table_constraints where UPPER(table_name)=UPPER(''WFMailQueueHistoryTable'') and constraint_type=''PRIMARY KEY''' INTO v_ConstraintName;
			
			IF (v_ConstraintName IS NOT NULL AND LENGTH(v_ConstraintName) > 0) THEN
				EXECUTE ('ALTER TABLE WFMailQueueHistoryTable DROP CONSTRAINT ' ||  v_ConstraintName);
				RAISE NOTICE 'Table WFMailQueueHistoryTable altered, Primary Key on WFUserObjAssocTable is dropped.';
			END IF;
	END;
	
	v_existFlag := 0;
	SELECT 1 INTO v_existFlag FROM information_schema.columns WHERE UPPER(table_name) = 'WFCOMMENTSVIEW' ;
	IF(NOT FOUND) THEN 
	BEGIN
		Execute ('CREATE OR REPLACE VIEW WFCOMMENTSVIEW 
				AS
					SELECT * FROM WFCOMMENTSTABLE
					UNION 
					SELECT * FROM WFCOMMENTSHISTORYTABLE ');
	END;
	END IF;
	
	BEGIN
		Execute ('CREATE OR REPLACE VIEW WFGROUPVIEW ( GROUPINDEX,GROUPNAME, CREATEDDATETIME, EXPIRYDATETIME, 
					PRIVILEGECONTROLLIST, OWNER, COMMNT, GROUPTYPE, 
					MAINGROUPINDEX,PARENTGROUPINDEX ) 
					AS 
						SELECT  groupindex,groupname,createddatetime,expirydatetime,
							privilegecontrollist,owner,comment,grouptype,maingroupindex,parentgroupindex 
						FROM PDBGROUP ');
	END;
	
	BEGIN
		Execute ('CREATE OR REPLACE VIEW WFUSERVIEW ( USERINDEX, USERNAME, PERSONALNAME, FAMILYNAME, CREATEDDATETIME, 
				      EXPIRYDATETIME, PRIVILEGECONTROLLIST, PASSWORD, ACCOUNT, 
				      COMMNT, DELETEDDATETIME, USERALIVE, MAINGROUPID, 
				      MAILID, FAX, NOTECOLOR, SUPERIOR, SUPERIORFLAG, PARENTGROUPINDEX  ) 
				AS 
					SELECT  USERINDEX,(BTRIM(COALESCE(USERNAME,''''))) as USERNAME,PERSONALNAME,FAMILYNAME,
						CREATEDDATETIME, EXPIRYDATETIME,PRIVILEGECONTROLLIST,
						PASSWORD,ACCOUNT,COMMENT,DELETEDDATETIME,USERALIVE,
						MAINGROUPID,MAILID,FAX,NOTECOLOR, SUPERIOR, SUPERIORFLAG, PARENTGROUPINDEX 
					FROM PDBUSER where deletedflag = ''N'' and UserAlive=''Y''');
	END;
	
	BEGIN
		Execute ('CREATE OR REPLACE VIEW WFALLUSERVIEW ( USERINDEX, USERNAME, PERSONALNAME, FAMILYNAME, CREATEDDATETIME, 
				      EXPIRYDATETIME, PRIVILEGECONTROLLIST, PASSWORD, ACCOUNT, 
				      COMMNT, DELETEDDATETIME, USERALIVE, MAINGROUPID, 
				      MAILID, FAX, NOTECOLOR, SUPERIOR, SUPERIORFLAG, PARENTGROUPINDEX  ) 
				AS 
					SELECT  USERINDEX,(BTRIM(COALESCE(USERNAME,''''))) as USERNAME,PERSONALNAME,FAMILYNAME,
						CREATEDDATETIME, EXPIRYDATETIME,PRIVILEGECONTROLLIST,
						PASSWORD,ACCOUNT,COMMENT,DELETEDDATETIME,USERALIVE,
						MAINGROUPID,MAILID,FAX,NOTECOLOR, SUPERIOR, SUPERIORFLAG, PARENTGROUPINDEX 
					FROM PDBUSER where deletedflag = ''N''');
	END;
	
	BEGIN
		v_existFlag := 0;
		SELECT 1 INTO v_existFlag from information_schema.tables where UPPER(table_name) = UPPER('WFDEActivityTable');
		IF(NOT FOUND) THEN 
			Execute ('CREATE TABLE WFDEActivityTable
	(
	ProcessDefId    INTEGER NOT NULL,
	ActivityId      INTEGER NOT NULL,
	IsolateFlag     VARCHAR(2)	NOT NULL,
	ConfigurationID INTEGER NOT NULL,
	ConfigType     VARCHAR(2)	NOT NULL
	)');
		END IF;
	END;
	
	BEGIN
		v_existFlag := 0;
		SELECT 1 INTO v_existFlag from information_schema.tables where UPPER(table_name) = UPPER('WFDETableMappingDetails');
		IF(NOT FOUND) THEN 
			Execute ('CREATE TABLE WFDETableMappingDetails
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
	)');
		END IF;
	END;
	
	BEGIN
		v_existFlag := 0;
		SELECT 1 INTO v_existFlag from information_schema.tables where UPPER(table_name) = UPPER('WFDETableRelationdetails');
		IF(NOT FOUND) THEN 
			Execute ('CREATE TABLE WFDETableRelationdetails
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
	)');
		END IF;
	END;
	
	BEGIN
		v_existFlag := 0;
		SELECT 1 INTO v_existFlag from information_schema.tables where UPPER(table_name) = UPPER('WFDEConfigTable');
		IF(NOT FOUND) THEN 
			Execute ('CREATE TABLE WFDEConfigTable
   (
    ProcessDefId       INTEGER NOT NULL,
    ConfigName         VARCHAR(255) NOT NULL,
    ActivityId         INTEGER NOT NULL
   )');
		END IF;
	END;
	
	BEGIN
		v_existFlag = 0;
		SELECT 1 INTO v_existFlag
		FROM information_schema.columns  
		WHERE UPPER(table_name) = UPPER('WF_OMSConnectInfoTable') and UPPER(column_name)=UPPER('AppServerIP');
		IF(FOUND) THEN 
			Execute ('Alter table WF_OMSConnectInfoTable ALTER COLUMN AppServerIP TYPE VARCHAR(100)');
		END IF;
	END;

	BEGIN
	v_existFlag := 0;
	SELECT 1 INTO v_existFlag FROM information_schema.columns WHERE UPPER(table_name) = UPPER('WFESCALATIONTABLE') and UPPER(column_name)=UPPER('CONCERNEDAUTHINFO');
	IF(FOUND) THEN 
		Execute ('Alter Table WFESCALATIONTABLE Alter Column  CONCERNEDAUTHINFO Type VARCHAR(2000)');
	END IF;
	END;
	
	
	BEGIN
		v_existFlag := 0;
		SELECT 1 INTO v_existFlag FROM information_schema.columns WHERE UPPER(table_name) = UPPER('EXTMETHODDEFTABLE') and UPPER(column_name)=UPPER('IsBRMSService');
		IF(NOT FOUND) THEN 
			Execute ('Alter table EXTMETHODDEFTABLE ADD IsBRMSService	VARCHAR(1) NULL');
		END IF;
	END;
	
	BEGIN
		v_existFlag := 0;
		SELECT 1 INTO v_existFlag FROM information_schema.columns WHERE UPPER(table_name) = UPPER('WFBRMSRuleSetInfo') and UPPER(column_name)=UPPER('isEncrypted');
		IF(NOT FOUND) THEN 
			Execute ('Alter table WFBRMSRuleSetInfo ADD isEncrypted VARCHAR(1) NULL');
		END IF;
	END;
	
	BEGIN
		v_existFlag := 0;
		SELECT 1 INTO v_existFlag FROM information_schema.columns WHERE UPPER(table_name) = UPPER('WFBRMSRuleSetInfo') and UPPER(column_name)=UPPER('RuleSetId');
		IF(NOT FOUND) THEN 
			Execute ('Alter table WFBRMSRuleSetInfo ADD RuleSetId INTEGER NULL');
		END IF;
	END;
	
	BEGIN
		v_existFlag := 0;
		SELECT 1 INTO v_existFlag FROM information_schema.columns WHERE UPPER(table_name) = UPPER('WFBRMSActivityAssocTable') and UPPER(column_name)=UPPER('Type');
		IF(NOT FOUND) THEN 
			Execute ('Alter table WFBRMSActivityAssocTable ADD Type		VARCHAR(1) Default ''S'' NOT NULL');
		END IF;
	END;
	
	SELECT VariableId INTO v_variableid FROM VarMappingTable WHERE UPPER(SystemDefinedName) = UPPER('TATRemaining');
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

					EXECUTE 'insert into VarMappingTable (ProcessDefId,VariableId,SystemDefinedName,UserDefinedName,VariableType,VariableScope,ExtObjId,DefaultValue,VariableLength,VarPrecision,Unbounded)  values('||CAST(v_ProcessDefId AS VARCHAR)|| ',  10028,    ''TATRemaining'',''TATRemaining'',     4,    ''S''    ,0,    NULL,  NULL   ,0    ,''N'')';
				END LOOP;
				CLOSE Cursor1;
		END IF;	
		
		SELECT VariableId INTO v_variableid FROM VarMappingTable WHERE UPPER(SystemDefinedName) = UPPER('TATConsumed');
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

					EXECUTE 'insert into VarMappingTable (ProcessDefId,VariableId,SystemDefinedName,UserDefinedName,VariableType,VariableScope,ExtObjId,DefaultValue,VariableLength,VarPrecision,Unbounded)  values('||CAST(v_ProcessDefId AS VARCHAR)|| ',  10029,    ''TATConsumed'',''TATConsumed'',     4,    ''S''    ,0,    NULL,    NULL  ,0    ,''N'')';
				END LOOP;
				CLOSE Cursor1;
		END IF;
		
	BEGIN
		v_existFlag := 0;
		SELECT 1 INTO v_existFlag FROM USERPREFERENCESTABLE WHERE Userid = 0 AND ObjectType = N'U';
		IF(NOT FOUND) THEN
			EXECUTE ('Insert into USERPREFERENCESTABLE (Userid,ObjectId,ObjectName,ObjectType,NotifyByEmail,Data) Values (0,1,N''U'',N''U'',N''N'',N''<General><BatchSize>20</BatchSize><TimeOut>0</TimeOut><ReminderPopup>N</ReminderPopup><ReminderTime>15</ReminderTime><MailFromServer>N</MailFromServer><DocumentOrder></DocumentOrder><DefaultQuickSearchVar></DefaultQuickSearchVar><WorkitemHistoryOrder>D</WorkitemHistoryOrder><DefaultQueueId></DefaultQueueId><DefaultQueueName></DefaultQueueName></General><Worklist><Fields><Field><Name>WL_REGISTRATION_NO</Name><Display>Y</Display></Field><Field><Name>WL_ENTRY_DATE</Name><Display>Y</Display></Field><Field><Name>WL_TURNAROUND_REMAINING</Name><Display>Y</Display></Field><Field><Name>WL_TURNAROUND_CONSUMED</Name><Display>Y</Display></Field><Field><Name>WL_WORKSTEP_NAME</Name><Display>Y</Display></Field><Field><Name>WL_STATUS</Name><Display>N</Display></Field><Field><Name>QUEUE_VARIABLES</Name><Display>Y</Display></Field><Field><Name>WL_LOCKED_BY</Name><Display>Y</Display></Field><Field><Name>WL_CHECKLIST_STATUS</Name><Display>Y</Display></Field><Field><Name>WL_TURNAROUND_DATETIME</Name><Display>Y</Display></Field><Field><Name>WL_VALID_TILL</Name><Display>Y</Display></Field><Field><Name>WL_LOCKED_DATE</Name><Display>Y</Display></Field><Field><Name>WL_INTRODUCED_ON</Name><Display>Y</Display></Field><Field><Name>WL_INTRODUCED_BY</Name><Display>Y</Display></Field><Field><Name>WL_ASSIGNED_TO</Name><Display>Y</Display></Field><Field><Name>WL_PROCESSED_BY</Name><Display>Y</Display></Field><Field><Name>WL_QUEUE_NAME</Name><Display>Y</Display></Field><Field><Name>WL_CREATED_DATE_TIME</Name><Display>Y</Display></Field><Field><Name>WL_STATE</Name><Display>Y</Display></Field></Fields></Worklist><SearchFolder><Fields><Field><Name>F_NAME</Name><Display>Y</Display></Field><Field><Name>F_CREATION_DATE</Name><Display>Y</Display></Field><Field><Name>F_REVISED_DATE</Name><Display>Y</Display></Field><Field><Name>F_ACCESSED_DATE</Name><Display>Y</Display></Field><Field><Name>F_OWNER</Name><Display>Y</Display></Field><Field><Name>F_DATACLASS</Name><Display>Y</Display></Field></Fields></SearchFolder><SearchDocument><Fields><Field><Name>D_NAME</Name><Display>Y</Display></Field><Field><Name>D_REVISED_DATE</Name><Display>Y</Display></Field><Field><Name>D_TYPE</Name><Display>Y</Display></Field><Field><Name>D_SIZE</Name><Display>Y</Display></Field><Field><Name>D_PAGE</Name><Display>Y</Display></Field><Field><Name>D_DATACLASS</Name><Display>Y</Display></Field><Field><Name>D_USEFUL_INFO</Name><Display>Y</Display></Field><Field><Name>D_ANNOTATED</Name><Display>Y</Display></Field><Field><Name>D_LINKED</Name><Display>Y</Display></Field><Field><Name>D_CHECKED_OUT</Name><Display>Y</Display></Field><Field><Name>D_ORDER_NO</Name><Display>Y</Display></Field></Fields></SearchDocument><Workdesk><Fields><Field><Name>WD_PREV</Name><Display>Y</Display></Field><Field><Name>WD_NEXT</Name><Display>Y</Display></Field><Field><Name>WD_SAVE</Name><Display>Y</Display></Field><Field><Name>WD_TOOLS</Name><Display>Y</Display></Field><Field><Name>WD_DONE_INTRO</Name><Display>Y</Display></Field><Field><Name>WD_HELP</Name><Display>Y</Display></Field><Field><Name>WD_ACCEPT_REJECT</Name><Display>Y</Display></Field><Field><Name>OP_WI_ADDCONVERSATION</Name><Display>Y</Display></Field><Field><Name>OP_WI_ADDDOCUMENT</Name><Display>Y</Display></Field><Field><Name>OP_WI_IMPORTDOCUMENT</Name><Display>Y</Display></Field><Field><Name>OP_WI_SCANDOCUMENT</Name><Display>Y</Display></Field><Field><Name>OP_WI_PREFERENCE</Name><Display>Y</Display></Field><Field><Name>OP_WI_REASSIGNWI</Name><Display>Y</Display></Field><Field><Name>OP_WI_LINKEDWI</Name><Display>Y</Display></Field><Field><Name>OP_WI_SEARCH</Name><Display>Y</Display></Field><Field><Name>OP_SEARCH_DOCUMENT</Name><Display>Y</Display></Field><Field><Name>OP_SEARCH_FOLDER</Name><Display>Y</Display></Field><Field><Name>OP_WI_REFER_REVOKE</Name><Display>Y</Display></Field><Field><Name>OP_WI_EXT_INTERFACES</Name><Display>Y</Display></Field><Field><Name>OP_WI_PROPERTIES</Name><Display>Y</Display></Field><Field><Name>WD_HOLD</Name><Display>Y</Display></Field><Field><Name>WD_UNHOLD</Name><Display>Y</Display></Field></Fields></Workdesk><GeneralPreferences><MainHeaderFields><Fields><Field><Name>PREF_INITIATE</Name><Display>1</Display></Field><Field><Name>PREF_DONE</Name><Display>3</Display></Field><Field><Name>PREF_REFER</Name><Display>24</Display></Field></Fields></MainHeaderFields><InnerFields><Fields><Field><Name>PREF_REASSIGN</Name><Display>11</Display></Field><Field><Name>PREF_REVOKE</Name><Display>4</Display></Field><Field><Name>PREF_ADHOC_ROUTING</Name><Display>19</Display></Field><Field><Name>PREF_PROPERTIES</Name><Display>7</Display></Field><Field><Name>PREF_GET_LOCK</Name><Display>10</Display></Field><Field><Name>PREF_RELEASE</Name><Display>23</Display></Field><Field><Name>PREF_SET_DIVERSION</Name><Display>13</Display></Field><Field><Name>PREF_UNLOCK</Name><Display>20</Display></Field><Field><Name>PREF_PRIORITY</Name><Display>8</Display></Field><Field><Name>PREF_SET_REMINDER</Name><Display>9</Display></Field><Field><Name>PREF_DELETE</Name><Display>12</Display></Field><Field><Name>PREF_SET_FILTER</Name><Display>14</Display></Field><Field><Name>PREF_COUNT</Name><Display>15</Display></Field><Field><Name>PREF_REMINDER_LIST</Name><Display>16</Display></Field><Field><Name>PREF_PREFERENCES</Name><Display>17</Display></Field><Field><Name>PREF_GLOBALPREFERENCES</Name><Display>22</Display></Field><Field><Name>PREF_HOLD</Name><Display>5</Display></Field><Field><Name>PREF_UNHOLD</Name><Display>6</Display></Field></Fields></InnerFields></GeneralPreferences>'')');
		END IF;
	END;
	
	BEGIN
		V_QUERYSTR := 'UPDATE USERPREFERENCESTABLE SET DATA=$1 WHERE Userid=$2 AND ObjectId=$3 AND ObjectName=$4 AND ObjectType=$5';
		OPEN V_CURSOR1 FOR SELECT USERID,OBJECTID,OBJECTNAME,OBJECTTYPE,DATA FROM USERPREFERENCESTABLE WHERE USERID != 0 AND OBJECTTYPE ='U';
		LOOP
			FETCH V_CURSOR1 INTO USREID,vOBJECTID,vOBJECTNAME,vOBJECTTYPE,sDATA;
			EXIT WHEN NOT FOUND;
			IF position('WL_TURNAROUND_CONSUMED' in sDATA) = 0 THEN
				TempIndex1 := position('WL_ENTRY_DATE' in sDATA);
				IF (TempIndex1 >0) THEN
					tempSubstr = SUBSTR(sDATA , TempIndex1);
					TempIndex1 := position('</Field>' in tempSubstr) + TempIndex1 + 7;
					TempIndex2 := (LENGTH(sDATA)-TempIndex1);
					IF (TempIndex2 >0) THEN
						TempIndex2 := TempIndex2+1;
						chunk1 := SUBSTR(sDATA,0,TempIndex1);
						chunk2 := SUBSTR(sDATA,TempIndex1,TempIndex2);
						chunk3 :=	'<Field><Name>WL_TURNAROUND_REMAINING</Name><Display>Y</Display></Field><Field><Name>WL_TURNAROUND_CONSUMED</Name><Display>Y</Display></Field>';
						TempDATA := chunk1||chunk3||chunk2;
						EXECUTE V_QUERYSTR USING TempDATA,USREID,vOBJECTID,vOBJECTNAME,vOBJECTTYPE;
					ELSE
						RAISE NOTICE 'WL_ENTRY_DATE FIELD NOT FOUND';
					END IF;
				ELSE
					RAISE NOTICE 'WL_ENTRY_DATE FIED NOT FOUND';
				END IF;
			END IF;
		END LOOP;
		CLOSE V_CURSOR1;
	EXCEPTION WHEN OTHERS THEN
		IF EXISTS(SELECT * FROM pg_cursors WHERE name = 'V_CURSOR1') THEN
		  CLOSE V_CURSOR1;
		END IF;
		RAISE NOTICE 'SQL_ERROR : %, SQL_STATE : %', SQLERRM, SQLSTATE;
	END;

	BEGIN
		v_existFlag := 0;
		SELECT 1 INTO v_existFlag FROM information_schema.columns WHERE UPPER(table_name) = UPPER('WFTypeDefTable') AND UPPER(column_name) = UPPER('SortingFlag');
		IF(NOT FOUND) THEN 
			EXECUTE('ALTER TABLE WFTypeDefTable ADD COLUMN SortingFlag VARCHAR(1)');
			EXECUTE('UPDATE WFTypeDefTable SET SortingFlag = ''N''');
		END IF;
	EXCEPTION WHEN OTHERS THEN
		RAISE NOTICE 'SQL_ERROR : %, SQL_STATE : %', SQLERRM, SQLSTATE;
	END;

	BEGIN
		v_existFlag := 0;
		SELECT 1 INTO v_existFlag FROM information_schema.columns WHERE UPPER(table_name) = UPPER('WFUDTVarMappingTable') AND UPPER(column_name) = UPPER('DefaultSortingFieldname');
		IF(NOT FOUND) THEN 
			EXECUTE('ALTER TABLE WFUDTVarMappingTable ADD COLUMN DefaultSortingFieldname VARCHAR(256), ADD COLUMN DefaultSortingOrder INT');
			v_QueryStr := 'SELECT ProcessDefId, VariableId FROM VarMappingTable WHERE VariableType = 11 AND Unbounded = ''Y''';
			OPEN V_CURSOR1 FOR EXECUTE v_QueryStr;
			LOOP
				FETCH V_CURSOR1 INTO v_ProcessDefId, v_variableid;
				EXIT WHEN NOT FOUND;
				EXECUTE 'UPDATE WFUDTVarMappingTable SET DefaultSortingFieldname = ''insertionorderid'', DefaultSortingOrder = 0 WHERE ProcessDefId = $1 AND VariableId = $2 AND ParentVarFieldId = 0' USING v_ProcessDefId, v_variableid;
			END LOOP;
			CLOSE V_CURSOR1;
		END IF;
	EXCEPTION WHEN OTHERS THEN
		IF EXISTS(SELECT * FROM pg_cursors WHERE name = 'V_CURSOR1') THEN
		  CLOSE V_CURSOR1;
		END IF;
		RAISE NOTICE 'SQL_ERROR : %, SQL_STATE : %', SQLERRM, SQLSTATE;
	END;

END;
$$LANGUAGE plpgsql;
~
SELECT TableScript();
~
DROP FUNCTION TableScript();
~