/*_____________________________________________________________________________________________________________________-
		NEWGEN SOFTWARE TECHNOLOGIES LIMITED

	Group						: Genesis
	Product / Project			: iBPS
	Module						: Transaction Server
	File NAME					: TableScript.sql (Oracle Server)
	Author						: Mohnish Chopra
	Date written (DD/MM/YYYY)	: 08/10/2020
	Description					: This file contains the list of changes done after release of iBPS 5.0 sp1
_______________________________________________________________________________________________________________________-
			CHANGE HISTORY
_______________________________________________________________________________________________________________________-
Date		Change By			Change Description (Bug No. (If Any))
24/09/2020  Shubham Singla      Bug 94270 - iBPS 4.0 :-MessageId column needs to be added in WFInitiationAgentReportTable. 
02/11/2020	Mohnish Chopra		Changes for Generate response and Locale handling
29/01/2021      Sourabh Tantuway    Bug 97518 - iBPS 4.0 + Asynchronous : WMCreateworkitem API in Process Server is getting failed if escalation criteria is containing mailTo list above length 256.
28/04/2021      Sourabh Tantuway    Bug 99245 - iBPS 4.0 + Oracle : Error coming in Report component  of Omniapp
28/05/2021    Chitranshi Nitharia   Bug 99590 - Handling of master user preferences with userid 0.
19/10/2021	Vardaan Arora			Bug 102127 - In User list or Group List ,Only those Users should be fetched whose parent group is same as that of logged in user.
11/02/2022	Ashutosh Pandey		Bug 105376 - Support for sorting on complex array primitive member
 ______________________________________________________________________________________________________________________-*/

CREATE OR REPLACE PROCEDURE TableScript AS

	existsFlag INT;
	v_existsFlag INT;
	ErrorMessage VARCHAR2(1000);
	V_PARAMDEFINITION1 varchar2(1000);
	InputFormat varchar2(100);
	Tool varchar2(50);
	Processdefid varchar2(50);
	Templateid INTEGER;
	TemplateFileName varchar2(500);
	TemplateFileName_out varchar2(500);
	v_variableid	 INTEGER;
	v_queryStr VARCHAR2(800);
	v_rowCount INT;
	TYPE DynamicCursor 	IS REF CURSOR;
	Cursor1 DynamicCursor;
	v_ProcessDefId			INTEGER;
	v_FileName			varchar2(500);		 
	v_TRIGGERID				INTEGER;
	FileName_out    	 varchar2(500);
	v_ConstraintName 	VARCHAR2(100);
	chunk1					CLOB;
	chunk2					CLOB;
	chunk3					CLOB;
	chunk4					CLOB;
	chunk5					CLOB;
	V_CURSOR1   DynamicCursor;
	V_QUERY1 VARCHAR2(2000);
	sDATA VARCHAR2(32000);
	USREID NUMBER;
	OBJECTID NUMBER;
	OBJECTNAME VARCHAR2(5);
	OBJECTTYPE VARCHAR2(5);
	TempDATA VARCHAR2(32000);
	TempIndex1 NUMBER;
	TempIndex2 NUMBER;
	chunk6 VARCHAR2(32000);
	chunk7 VARCHAR2(32000);
	chunk8 VARCHAR2(200);

	
BEGIN
	BEGIN
		existsFlag :=0;	
		select 1 into existsFlag from user_tab_columns where upper(table_name) = upper('WFInitiationAgentReportTable') and upper(column_name) = upper('MessageId');
		Exception when no_data_found then
			EXECUTE IMMEDIATE ('Alter table WFInitiationAgentReportTable ADD  MessageId NVARCHAR2(1000)  NULL');
	END;
	
	BEGIN 
		SELECT COUNT(1) INTO existsFlag FROM USER_TAB_COLUMNS WHERE TABLE_NAME = UPPER('TemplateDefinitionTable') AND COLUMN_NAME = UPPER('InputFormat');
		IF(existsFlag = 0) THEN
		BEGIN
			EXECUTE IMMEDIATE('ALTER TABLE TemplateDefinitionTable ADD (InputFormat NVARCHAR2(10) NULL, Tools NVARCHAR2(20) NULL, DateTimeFormat NVARCHAR2(50) NULL)');
		
			Declare CURSOR Template_Curosr IS SELECT  TemplateFileName, ProcessDefId, TemplateId FROM TEMPLATEDEFINITIONTABLE;
				
				BEGIN
					Open Template_Curosr;
						LOOP
							FETCH Template_Curosr INTO TemplateFileName,Processdefid , Templateid;
							EXIT WHEN Template_Curosr%NOTFOUND;
							BEGIN
							
							    TemplateFileName := LTRIM(RTRIM(TemplateFileName));
								V_QUERYSTR := 'SELECT SUBSTR( :TemplateFileName, 1, LENGTH( :TemplateFileName) - INSTR(REVERSE( :TemplateFileName) ,''.'', 1)) FROM DUAL';
								EXECUTE IMMEDIATE V_QUERYSTR INTO TemplateFileName_out USING TemplateFileName , TemplateFileName , TemplateFileName;
				
				  DBMS_OUTPUT.PUT_LINE('The column TemplateFileName_out--' || TemplateFileName_out);
				  
								V_QUERYSTR := 'SELECT SUBSTR( :TemplateFileName, (-(INSTR(REVERSE( :TemplateFileName),''.'',1))+ 1),LENGTH( :TemplateFileName) ) From DUAL';
								EXECUTE IMMEDIATE V_QUERYSTR INTO InputFormat USING TemplateFileName , TemplateFileName , TemplateFileName;
					
				  DBMS_OUTPUT.PUT_LINE('The column eInputFormat--' || InputFormat);
					
					
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
								
				   DBMS_OUTPUT.PUT_LINE('The column tOOL--' || Tool);
						
								V_QUERYSTR := N'UPDATE TemplateDefinitionTable 
								SET TemplateFileName =  :TemplateFileName_out , InputFormat =  :InputFormat , Tools =  :Tool , DateTimeFormat = ''dd/MM/yyyy''
								where processdefid =  :Processdefid  and templateid = :Templateid';
								
								EXECUTE IMMEDIATE V_QUERYSTR USING TemplateFileName_out , InputFormat, Tool , Processdefid , templateid;
								
								--FETCH Template_Curosr INTO TemplateFileName,Processdefid , Templateid;
					
							END;
				
						END LOOP;
					Close  Template_Curosr;
					EXCEPTION 
						   WHEN OTHERS THEN 
					Close  Template_Curosr; 		
				END;         
				
				
				Declare CURSOR GenrateResponse_Curosr IS SELECT FileName, Processdefid , TRIGGERID FROM GenerateResponseTable;
				
				
				BEGIN
					Open GenrateResponse_Curosr;
						LOOP

							FETCH GenrateResponse_Curosr INTO v_FileName, v_Processdefid , v_TRIGGERID;
							EXIT WHEN GenrateResponse_Curosr%NOTFOUND;
							BEGIN
								
								v_FileName := LTRIM(RTRIM(v_FileName));
								V_QUERYSTR := 'SELECT SUBSTR( :v_FileName, 1, LENGTH( :v_FileName) - INSTR(REVERSE( :v_FileName) ,''.'', 1)) FROM DUAL';
								EXECUTE IMMEDIATE V_QUERYSTR INTO FileName_out USING v_FileName , v_FileName , v_FileName;
				
								DBMS_OUTPUT.PUT_LINE('The column FileName_out--' || FileName_out);

								V_QUERYSTR := N'UPDATE GenerateResponseTable 
								SET FileName =  :FileName_out
								where processdefid =  :Processdefid  and TRIGGERID = :v_TRIGGERID';
								
								EXECUTE IMMEDIATE V_QUERYSTR USING FileName_out , v_Processdefid , v_TRIGGERID;
								
								--FETCH GenrateResponse_Curosr INTO v_FileName, v_Processdefid , v_TRIGGERID;

								DBMS_OUTPUT.PUT_LINE('second cusror fetch next param v_FileName--' || v_FileName);
								
								DBMS_OUTPUT.PUT_LINE('second cusror fetch next param v_TRIGGERID--' || v_Processdefid);
							END;
				
						END LOOP;
					Close  GenrateResponse_Curosr;
					EXCEPTION 
						   WHEN OTHERS THEN 
						   DBMS_OUTPUT.PUT_LINE('Exception Case--');
					Close  GenrateResponse_Curosr; 		
				END;         



				
			END;
		END IF;	
	END;	
	
	BEGIN
		v_existsFlag :=0;	
		select 1 into v_existsFlag from user_tab_columns where upper(table_name) = UPPER('WFINSTRUMENTTABLE') and upper(column_name) = UPPER('LOCALE');
		Exception when no_data_found then
			EXECUTE IMMEDIATE ('Alter table WFINSTRUMENTTABLE ADD  LOCALE          	NVARCHAR2(30)    DEFAULT N''en_US''');
		END;
	
	BEGIN
		v_existsFlag :=0;	
		select 1 into v_existsFlag from user_tab_columns where upper(table_name) = UPPER('QUEUEHISTORYTABLE') and upper(column_name) = UPPER('LOCALE');
		Exception when no_data_found then
			EXECUTE IMMEDIATE ('Alter table QUEUEHISTORYTABLE ADD  LOCALE          	NVARCHAR2(30)    DEFAULT N''en_US''');
	END;
	
	BEGIN
		 SELECT VariableId INTO v_variableid FROM VarMappingTable WHERE UPPER(SystemDefinedName) = UPPER('LOCALE');
		v_rowCount := SQL%ROWCOUNT;
	EXCEPTION
	WHEN OTHERS THEN
		v_rowCount := 0;
	END;
	IF(v_rowCount < 1) THEN
	BEGIN
		SAVEPOINT LOCALE;

			v_queryStr := 'SELECT distinct(ProcessDefId) FROM VarMappingTable';
			OPEN Cursor1 FOR v_queryStr;
			LOOP
				FETCH Cursor1 INTO v_ProcessDefId;
				EXIT WHEN Cursor1%NOTFOUND;

				EXECUTE IMMEDIATE 'insert into VarMappingTable (ProcessDefId,VariableId,SystemDefinedName,UserDefinedName,VariableType,VariableScope,ExtObjId,DefaultValue,VariableLength,VarPrecision,Unbounded)  values('||To_Char(v_ProcessDefId)|| ',  10027,    ''LOCALE'',''LOCALE'',     10,    ''M''    ,0,    NULL,    30   ,0    ,''N'')';				
			END LOOP;
			CLOSE Cursor1;
		COMMIT;
	EXCEPTION
	WHEN OTHERS THEN
		ROLLBACK TO SAVEPOINT LOCALE;
		CLOSE Cursor1;
	END;
	END IF;
	
	BEGIN 
   
			  SELECT CONSTRAINT_NAME INTO v_ConstraintName FROM user_constraints WHERE table_name = UPPER('WFMailQueueHistoryTable') AND constraint_type = 'P';
			  IF (v_ConstraintName IS NOT NULL AND length(v_ConstraintName) > 0) THEN
				EXECUTE IMMEDIATE ('ALTER TABLE WFMailQueueHistoryTable DROP CONSTRAINT ' ||  v_ConstraintName);
			END IF;
			EXCEPTION WHEN NO_DATA_FOUND THEN 
			
				BEGIN
				DBMS_OUTPUT.PUT_LINE('No need to remove Primary key in WFMailQueueHistoryTable as it is not present . ');
				END;
	END;	

	BEGIN
		EXECUTE IMMEDIATE 'CREATE OR REPLACE VIEW WFCOMMENTSVIEW 	AS 
					SELECT * FROM WFCOMMENTSTABLE
					UNION ALL
					SELECT * FROM WFCOMMENTSHISTORYTABLE';
	END;
	
	BEGIN
		EXECUTE IMMEDIATE 'CREATE OR REPLACE VIEW WFGROUPVIEW ( GROUPINDEX,GROUPNAME, CREATEDDATETIME, EXPIRYDATETIME, 
					PRIVILEGECONTROLLIST, OWNER, COMMNT, GROUPTYPE, 
					MAINGROUPINDEX, PARENTGROUPINDEX ) 
					AS 
					SELECT  groupindex,groupname,createddatetime,expirydatetime,
						privilegecontrollist,owner,commnt,grouptype,maingroupindex,parentgroupindex 
					FROM PDBGROUP';
	END;
	
	BEGIN
		EXECUTE IMMEDIATE 'CREATE OR REPLACE VIEW WFUSERVIEW ( USERINDEX, USERNAME, PERSONALNAME, FAMILYNAME, CREATEDDATETIME, 
				      EXPIRYDATETIME, PRIVILEGECONTROLLIST, PASSWORD, ACCOUNT, 
				      COMMNT, DELETEDDATETIME, USERALIVE, MAINGROUPID, 
				      MAILID, FAX, NOTECOLOR, SUPERIOR, SUPERIORFLAG, PARENTGROUPINDEX) 
				AS 
					SELECT  USERINDEX,TO_NChar(RTRIM(USERNAME)) as USERNAME,PERSONALNAME,FAMILYNAME,
						CREATEDDATETIME, EXPIRYDATETIME,PRIVILEGECONTROLLIST,
						PASSWORD,ACCOUNT,COMMNT,DELETEDDATETIME,USERALIVE,
						MAINGROUPID,MAILID,FAX,NOTECOLOR, SUPERIOR, SUPERIORFLAG, PARENTGROUPINDEX 
					FROM PDBUSER where deletedflag = ''N'' and UserAlive = ''Y''';
	END;
	
	BEGIN
		EXECUTE IMMEDIATE 'CREATE OR REPLACE VIEW WFALLUSERVIEW ( USERINDEX, USERNAME, PERSONALNAME, FAMILYNAME, CREATEDDATETIME, 
				      EXPIRYDATETIME, PRIVILEGECONTROLLIST, PASSWORD, ACCOUNT, 
				      COMMNT, DELETEDDATETIME, USERALIVE, MAINGROUPID, 
				      MAILID, FAX, NOTECOLOR, SUPERIOR, SUPERIORFLAG, PARENTGROUPINDEX  ) 
					AS 
						SELECT  USERINDEX,TO_NChar(RTRIM(USERNAME)) as USERNAME,PERSONALNAME,FAMILYNAME,
							CREATEDDATETIME, EXPIRYDATETIME,PRIVILEGECONTROLLIST,
							PASSWORD,ACCOUNT,COMMNT,DELETEDDATETIME,USERALIVE,
							MAINGROUPID,MAILID,FAX,NOTECOLOR, SUPERIOR, SUPERIORFLAG, PARENTGROUPINDEX 
						FROM PDBUSER where deletedflag = ''N''';
	END;
	
	BEGIN
		BEGIN
			SELECT 1 INTO existsFlag FROM user_tables WHERE UPPER(TABLE_NAME)=UPPER('WFDEActivityTable') ;
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				EXECUTE IMMEDIATE 'CREATE TABLE WFDEActivityTable
	(
	ProcessDefId    INT NOT NULL,
	ActivityId      INT NOT NULL,
	IsolateFlag     NVARCHAR2 (2) NOT NULL,
	ConfigurationID INT NOT NULL,
	ConfigType     NVARCHAR2 (2) NOT NULL
	)';
		END;
	EXCEPTION
		WHEN OTHERS THEN  
			raise_application_error(-20231,' BLOCK 1 FAILED');
	END;
	
	BEGIN
		BEGIN
			SELECT 1 INTO existsFlag FROM user_tables WHERE UPPER(TABLE_NAME)=UPPER('WFDETableMappingDetails') ;
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				EXECUTE IMMEDIATE 'CREATE TABLE WFDETableMappingDetails
	(
	ProcessDefId       INT NOT NULL,
	ActivityId         INT NOT NULL,
	ExchangeId         INT NOT NULL,
	OrderId            INT NOT NULL,
	VariableType       NVARCHAR2 (2) NOT NULL,
	RowCountVariableId INT NULL,
	FilterString       NVARCHAR2 (255) NULL,
	EntityType         NVARCHAR2 (2) NOT NULL,
	EntityName         NVARCHAR2(255) NOT NULL,
	ColumnName         NVARCHAR2 (255) NOT NULL,
	Nullable           NVARCHAR2 (2) NOT NULL,
	VarName            NVARCHAR2 (255) NOT NULL,
	VarType            NVARCHAR2 (2) NOT NULL,
	VarId              INT NOT NULL,
	VarFieldId         INT NOT NULL,
	ExtObjId           INT NOT NULL,
	updateIfExist      NVARCHAR2 (2) NOT NULL,
	ColumnType         INT NOT NULL
	)';
		END;
	EXCEPTION
		WHEN OTHERS THEN  
			raise_application_error(-20231,' BLOCK 2 FAILED');
	END;
	
	BEGIN
		BEGIN
			SELECT 1 INTO existsFlag FROM user_tables WHERE UPPER(TABLE_NAME)=UPPER('WFDETableRelationdetails') ;
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				EXECUTE IMMEDIATE 'CREATE TABLE WFDETableRelationdetails
	(
	ProcessDefId       INT NOT NULL,
	ActivityId         INT NOT NULL,
	ExchangeId         INT NOT NULL,
	EntityName         NVARCHAR2 (255) NOT NULL,
	EntityType         NVARCHAR2 (2) NOT NULL,
	EntityColumnName   NVARCHAR2 (255) NOT NULL,
	ComplexTableName   NVARCHAR2 (255) NOT NULL,
	RelationColumnName NVARCHAR2 (255) NOT NULL,
	ColumnType         INT NOT NULL,
	RelationType       NVARCHAR2 (2) NOT NULL
	)';
		END;
	EXCEPTION
		WHEN OTHERS THEN  
			raise_application_error(-20231,' BLOCK 3 FAILED');
	END;
	
	BEGIN
		BEGIN
			SELECT 1 INTO existsFlag FROM user_tables WHERE UPPER(TABLE_NAME)=UPPER('WFDEConfigTable') ;
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				EXECUTE IMMEDIATE 'CREATE TABLE WFDEConfigTable
(
    ProcessDefId       INT NOT NULL,
    ConfigName         NVARCHAR2 (255) NOT NULL,
    ActivityId         INT NOT NULL
)';
		END;
	EXCEPTION
		WHEN OTHERS THEN  
			raise_application_error(-20231,' BLOCK 4 FAILED');
	END;
	
		BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME = UPPER('WF_OMSConnectInfoTable') 
		AND 
		COLUMN_NAME = UPPER('AppServerIP');
		
		EXECUTE IMMEDIATE 'ALTER TABLE WF_OMSConnectInfoTable modify AppServerIP 	NVARCHAR2(100)';	
		
    EXCEPTION
		WHEN NO_DATA_FOUND THEN
     		DBMS_OUTPUT.PUT_LINE('Column AppServerIP does not exist in WF_OMSConnectInfoTable');
			Raise;
	END;
	
	BEGIN
	v_existsFlag :=0;
	SELECT 1 into v_existsFlag from user_tab_columns where upper(table_name) = UPPER('WFESCALATIONTABLE') and upper(column_name) = UPPER('CONCERNEDAUTHINFO') and char_col_decl_length < 2000;
	IF v_existsFlag = 1 THEN
	BEGIN
		EXECUTE IMMEDIATE 'ALTER TABLE WFESCALATIONTABLE MODIFY (CONCERNEDAUTHINFO NVARCHAR2(2000))';
	END;
	END IF;
	EXCEPTION WHEN NO_DATA_FOUND THEN
			BEGIN
				DBMS_OUTPUT.PUT_LINE('Size of column CONCERNEDAUTHINFO column in WFESCALATIONTABLE is 2000');
			END;
	END;
	
	BEGIN
		BEGIN
			v_existsFlag :=0;	
			select 1 into v_existsFlag from user_tab_columns where upper(table_name) = UPPER('EXTMETHODDEFTABLE') and upper(column_name) = UPPER('IsBRMSService');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				EXECUTE IMMEDIATE 'Alter table EXTMETHODDEFTABLE ADD  IsBRMSService	Nvarchar2(1) NULL';
		END;
	EXCEPTION
		WHEN OTHERS THEN  
			raise_application_error(-20231,' BLOCK 107 FAILED');
	END;

	BEGIN
		BEGIN
			v_existsFlag :=0;	
			select 1 into v_existsFlag from user_tab_columns where upper(table_name) = UPPER('WFBRMSRuleSetInfo') and upper(column_name) = UPPER('isEncrypted');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				EXECUTE IMMEDIATE 'Alter table WFBRMSRuleSetInfo ADD  isEncrypted Nvarchar2(1) NULL';
		END;
	EXCEPTION
		WHEN OTHERS THEN  
			raise_application_error(-20231,' BLOCK 108 FAILED');
	END;
	
	BEGIN
		BEGIN
			v_existsFlag :=0;	
			select 1 into v_existsFlag from user_tab_columns where upper(table_name) = UPPER('WFBRMSRuleSetInfo') and upper(column_name) = UPPER('RuleSetId');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				EXECUTE IMMEDIATE 'Alter table WFBRMSRuleSetInfo ADD RuleSetId	INTEGER';
		END;
	EXCEPTION
		WHEN OTHERS THEN  
			raise_application_error(-20231,' BLOCK 109 FAILED');
	END;
	
	
	BEGIN
		BEGIN
			v_existsFlag :=0;	
			select 1 into v_existsFlag from user_tab_columns where upper(table_name) = UPPER('WFBRMSActivityAssocTable') and upper(column_name) = UPPER('Type');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				EXECUTE IMMEDIATE 'Alter table WFBRMSActivityAssocTable ADD Type Nvarchar2(1) Default ''S'' NOT NULL';
		END;
	EXCEPTION
		WHEN OTHERS THEN  
			raise_application_error(-20231,' BLOCK 110 FAILED');
	END;
	
	BEGIN
		BEGIN
			v_existsFlag :=0;	
			SELECT 1 into v_existsFlag from user_tab_columns where upper(table_name) = UPPER('GTEMPOBJECTRIGHTSTABLE') and upper(column_name) = UPPER('ObjectName') and char_col_decl_length < 255;
			IF v_existsFlag = 1 THEN
			BEGIN
				EXECUTE IMMEDIATE 'DROP TABLE GTEMPOBJECTRIGHTSTABLE';
				EXECUTE IMMEDIATE 'CREATE GLOBAL TEMPORARY TABLE GTempObjectRightsTable ( AssociationType INT, ObjectId INT,  ObjectName NVARCHAR2(255), RightString NVARCHAR2(100) ) ON COMMIT PRESERVE ROWS';
			END;
			END IF;	
		EXCEPTION WHEN NO_DATA_FOUND THEN
			BEGIN
			DBMS_OUTPUT.PUT_LINE('Size of column ObjectName column in GTEMPOBJECTRIGHTSTABLE is 255');
			END;
		END;
	EXCEPTION
		WHEN OTHERS THEN  
			raise_application_error(-20231,' BLOCK 111 FAILED');
	END;
	
	BEGIN
		v_existsFlag := 0;
		SELECT count(1) into v_existsFlag from USERPREFERENCESTABLE WHERE Userid = 0 AND ObjectType = N'U';
		IF v_existsFlag = 0 THEN
			chunk1 := N'<General><BatchSize>20</BatchSize><TimeOut>0</TimeOut><ReminderPopup>N</ReminderPopup><ReminderTime>15</ReminderTime><MailFromServer>N</MailFromServer><DocumentOrder></DocumentOrder><DefaultQuickSearchVar></DefaultQuickSearchVar><WorkitemHistoryOrder>D</WorkitemHistoryOrder><DefaultQueueId></DefaultQueueId><DefaultQueueName></DefaultQueueName></General>';
			chunk2 := N'<Worklist><Fields><Field><Name>WL_REGISTRATION_NO</Name><Display>Y</Display></Field><Field><Name>WL_ENTRY_DATE</Name><Display>Y</Display></Field><Field><Name>WL_TURNAROUND_REMAINING</Name><Display>Y</Display></Field><Field><Name>WL_TURNAROUND_CONSUMED</Name><Display>Y</Display></Field><Field><Name>WL_WORKSTEP_NAME</Name><Display>Y</Display></Field><Field><Name>WL_STATUS</Name><Display>N</Display></Field><Field><Name>QUEUE_VARIABLES</Name><Display>Y</Display></Field><Field><Name>WL_LOCKED_BY</Name><Display>Y</Display></Field><Field><Name>WL_CHECKLIST_STATUS</Name><Display>Y</Display></Field><Field><Name>WL_TURNAROUND_DATETIME</Name><Display>Y</Display></Field><Field><Name>WL_VALID_TILL</Name><Display>Y</Display></Field><Field><Name>WL_LOCKED_DATE</Name><Display>Y</Display></Field><Field><Name>WL_INTRODUCED_ON</Name><Display>Y</Display></Field><Field><Name>WL_INTRODUCED_BY</Name><Display>Y</Display></Field><Field><Name>WL_ASSIGNED_TO</Name><Display>Y</Display></Field><Field><Name>WL_PROCESSED_BY</Name><Display>Y</Display></Field><Field><Name>WL_QUEUE_NAME</Name><Display>Y</Display></Field><Field><Name>WL_CREATED_DATE_TIME</Name><Display>Y</Display></Field><Field><Name>WL_STATE</Name><Display>Y</Display></Field></Fields></Worklist>';
			chunk3 := N'<SearchFolder><Fields><Field><Name>F_NAME</Name><Display>Y</Display></Field><Field><Name>F_CREATION_DATE</Name><Display>Y</Display></Field><Field><Name>F_REVISED_DATE</Name><Display>Y</Display></Field><Field><Name>F_ACCESSED_DATE</Name><Display>Y</Display></Field><Field><Name>F_OWNER</Name><Display>Y</Display></Field><Field><Name>F_DATACLASS</Name><Display>Y</Display></Field></Fields></SearchFolder><SearchDocument><Fields><Field><Name>D_NAME</Name><Display>Y</Display></Field><Field><Name>D_REVISED_DATE</Name><Display>Y</Display></Field><Field><Name>D_TYPE</Name><Display>Y</Display></Field><Field><Name>D_SIZE</Name><Display>Y</Display></Field><Field><Name>D_PAGE</Name><Display>Y</Display></Field><Field><Name>D_DATACLASS</Name><Display>Y</Display></Field><Field><Name>D_USEFUL_INFO</Name><Display>Y</Display></Field><Field><Name>D_ANNOTATED</Name><Display>Y</Display></Field><Field><Name>D_LINKED</Name><Display>Y</Display></Field><Field><Name>D_CHECKED_OUT</Name><Display>Y</Display></Field><Field><Name>D_ORDER_NO</Name><Display>Y</Display></Field></Fields></SearchDocument>';
			chunk4 := N'<Workdesk><Fields><Field><Name>WD_PREV</Name><Display>Y</Display></Field><Field><Name>WD_NEXT</Name><Display>Y</Display></Field><Field><Name>WD_SAVE</Name><Display>Y</Display></Field><Field><Name>WD_TOOLS</Name><Display>Y</Display></Field><Field><Name>WD_DONE_INTRO</Name><Display>Y</Display></Field><Field><Name>WD_HELP</Name><Display>Y</Display></Field><Field><Name>WD_ACCEPT_REJECT</Name><Display>Y</Display></Field><Field><Name>OP_WI_ADDCONVERSATION</Name><Display>Y</Display></Field><Field><Name>OP_WI_ADDDOCUMENT</Name><Display>Y</Display></Field><Field><Name>OP_WI_IMPORTDOCUMENT</Name><Display>Y</Display></Field><Field><Name>OP_WI_SCANDOCUMENT</Name><Display>Y</Display></Field><Field><Name>OP_WI_PREFERENCE</Name><Display>Y</Display></Field><Field><Name>OP_WI_REASSIGNWI</Name><Display>Y</Display></Field><Field><Name>OP_WI_LINKEDWI</Name><Display>Y</Display></Field><Field><Name>OP_WI_SEARCH</Name><Display>Y</Display></Field><Field><Name>OP_SEARCH_DOCUMENT</Name><Display>Y</Display></Field><Field><Name>OP_SEARCH_FOLDER</Name><Display>Y</Display></Field><Field><Name>OP_WI_REFER_REVOKE</Name><Display>Y</Display></Field><Field><Name>OP_WI_EXT_INTERFACES</Name><Display>Y</Display></Field><Field><Name>OP_WI_PROPERTIES</Name><Display>Y</Display></Field><Field><Name>WD_HOLD</Name><Display>Y</Display></Field><Field><Name>WD_UNHOLD</Name><Display>Y</Display></Field></Fields></Workdesk>';
			chunk5 := N'<GeneralPreferences><MainHeaderFields><Fields><Field><Name>PREF_INITIATE</Name><Display>1</Display></Field><Field><Name>PREF_DONE</Name><Display>3</Display></Field><Field><Name>PREF_REFER</Name><Display>24</Display></Field></Fields></MainHeaderFields><InnerFields><Fields><Field><Name>PREF_REASSIGN</Name><Display>11</Display></Field><Field><Name>PREF_REVOKE</Name><Display>4</Display></Field><Field><Name>PREF_ADHOC_ROUTING</Name><Display>19</Display></Field><Field><Name>PREF_PROPERTIES</Name><Display>7</Display></Field><Field><Name>PREF_GET_LOCK</Name><Display>10</Display></Field><Field><Name>PREF_RELEASE</Name><Display>23</Display></Field><Field><Name>PREF_SET_DIVERSION</Name><Display>13</Display></Field><Field><Name>PREF_UNLOCK</Name><Display>20</Display></Field><Field><Name>PREF_PRIORITY</Name><Display>8</Display></Field><Field><Name>PREF_SET_REMINDER</Name><Display>9</Display></Field><Field><Name>PREF_DELETE</Name><Display>12</Display></Field><Field><Name>PREF_SET_FILTER</Name><Display>14</Display></Field><Field><Name>PREF_COUNT</Name><Display>15</Display></Field><Field><Name>PREF_REMINDER_LIST</Name><Display>16</Display></Field><Field><Name>PREF_PREFERENCES</Name><Display>17</Display></Field><Field><Name>PREF_GLOBALPREFERENCES</Name><Display>22</Display></Field><Field><Name>PREF_HOLD</Name><Display>5</Display></Field><Field><Name>PREF_UNHOLD</Name><Display>6</Display></Field></Fields></InnerFields></GeneralPreferences>';
			EXECUTE IMMEDIATE 'Insert into USERPREFERENCESTABLE (Userid,ObjectId,ObjectName,ObjectType,NotifyByEmail,Data) Values (0,1,N''U'',N''U'',N''N'', (SELECT to_clob('''||chunk1||''') || to_clob('''||chunk2||''') || to_clob('''||chunk3||''') || to_clob('''||chunk4||''') || to_clob('''||chunk5||''')  FROM dual) )';
		END IF;
	EXCEPTION
		WHEN OTHERS THEN
			raise_application_error(-20231, 'BLOCK 17 FAILED');
	END;
	
	BEGIN
		V_QUERY1 := 'UPDATE USERPREFERENCESTABLE SET DATA=:sDATA WHERE Userid=:Userid AND ObjectId=:ObjectId AND ObjectName=:ObjectName AND ObjectType=:ObjectType';
		OPEN V_CURSOR1 FOR SELECT USERID,OBJECTID,OBJECTNAME,OBJECTTYPE,DATA FROM USERPREFERENCESTABLE WHERE USERID <> 0 AND OBJECTTYPE ='U';
		LOOP
		BEGIN
			FETCH V_CURSOR1 INTO USREID,OBJECTID,OBJECTNAME,OBJECTTYPE,sDATA;
			EXIT WHEN V_CURSOR1%NOTFOUND;
			IF INSTR(sDATA,'WL_TURNAROUND_CONSUMED',1) = 0 THEN
				TempIndex1 := INSTR(sDATA,'WL_ENTRY_DATE',1);
				IF (TempIndex1 >0) THEN
					TempIndex1 := INSTR(sDATA,'</Field>',TempIndex1)+7;
					TempIndex2 := (LENGTH(sDATA)-TempIndex1);
					IF (TempIndex2 >0) THEN
						chunk6 := SUBSTR(sDATA,1,TempIndex1);
						chunk7 := SUBSTR(sDATA,(TempIndex1+1),(TempIndex2+1));
						chunk8 :='<Field><Name>WL_TURNAROUND_REMAINING</Name><Display>Y</Display></Field><Field><Name>WL_TURNAROUND_CONSUMED</Name><Display>Y</Display></Field>';
						TempDATA := chunk6||chunk8||chunk7;
						EXECUTE IMMEDIATE  V_QUERY1 USING TempDATA,USREID,OBJECTID,OBJECTNAME,OBJECTTYPE;
					ELSE
						raise_application_error(-20231,'WL_ENTRY_DATE FIELD NOT FOUND');
					END IF; 
				ELSE
					raise_application_error(-20231,'WL_ENTRY_DATE FIELD NOT FOUND');
				END IF;
			END IF;
		END;
		END LOOP;
		CLOSE V_CURSOR1;
	EXCEPTION WHEN OTHERS THEN
		IF V_CURSOR1%ISOPEN THEN
			CLOSE V_CURSOR1;
		END IF;
		ErrorMessage := 'BLOCK 18 FAILED' || SQLERRM();
		raise_application_error(-20231,ErrorMessage);
	END;
	
	
	BEGIN
		BEGIN
			v_existsFlag :=0;	
			select 1 into v_existsFlag from user_tab_columns where upper(table_name) = UPPER('WFBRMSConnectTable') and upper(column_name) = UPPER('RESTServerHostName');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				EXECUTE IMMEDIATE 'Alter table WFBRMSConnectTable ADD RESTServerHostName nvarchar2(128)';
		END;
	EXCEPTION
		WHEN OTHERS THEN  
			raise_application_error(-20231,' BLOCK 113 FAILED');
	END;
	
	
	
	
	BEGIN
		BEGIN
			v_existsFlag :=0;	
			select 1 into v_existsFlag from user_tab_columns where upper(table_name) = UPPER('WFBRMSConnectTable') and upper(column_name) = UPPER('RESTServerPort');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				EXECUTE IMMEDIATE 'Alter table WFBRMSConnectTable ADD RESTServerPort integer';
		END;
	EXCEPTION
		WHEN OTHERS THEN  
			raise_application_error(-20231,' BLOCK 114 FAILED');
	END;
	
	BEGIN
		BEGIN
			v_existsFlag :=0;	
			select 1 into v_existsFlag from user_tab_columns where upper(table_name) = UPPER('WFBRMSConnectTable') and upper(column_name) = UPPER('RESTServerProtocol');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				EXECUTE IMMEDIATE 'Alter table WFBRMSConnectTable ADD RESTServerProtocol nvarchar2(32)';
		END;
	EXCEPTION
		WHEN OTHERS THEN  
			raise_application_error(-20231,' BLOCK 115 FAILED');
	END;
	
	BEGIN
		 SELECT VariableId INTO v_variableid FROM VarMappingTable WHERE UPPER(SystemDefinedName) = UPPER('TATRemaining');
		v_rowCount := SQL%ROWCOUNT;
	EXCEPTION
	WHEN OTHERS THEN
		v_rowCount := 0;
	END;
	IF(v_rowCount < 1) THEN
	BEGIN
		SAVEPOINT TATRemaining;

			v_queryStr := 'SELECT distinct(ProcessDefId) FROM VarMappingTable';
			OPEN Cursor1 FOR v_queryStr;
			LOOP
				FETCH Cursor1 INTO v_ProcessDefId;
				EXIT WHEN Cursor1%NOTFOUND;

				EXECUTE IMMEDIATE 'insert into VarMappingTable (ProcessDefId,VariableId,SystemDefinedName,UserDefinedName,VariableType,VariableScope,ExtObjId,DefaultValue,VariableLength,VarPrecision,Unbounded)  values('||To_Char(v_ProcessDefId)|| ',  10028,    ''TATRemaining'',''TATRemaining'',     4,    ''S''    ,0,    NULL,    NULL   ,0    ,''N'')';				
			END LOOP;
			CLOSE Cursor1;
		COMMIT;
	EXCEPTION
	WHEN OTHERS THEN
		ROLLBACK TO SAVEPOINT TATRemaining;
		CLOSE Cursor1;
	END;
	END IF;
	
	BEGIN
		 SELECT VariableId INTO v_variableid FROM VarMappingTable WHERE UPPER(SystemDefinedName) = UPPER('TATConsumed');
		v_rowCount := SQL%ROWCOUNT;
	EXCEPTION
	WHEN OTHERS THEN
		v_rowCount := 0;
	END;
	IF(v_rowCount < 1) THEN
	BEGIN
		SAVEPOINT TATConsumed;

			v_queryStr := 'SELECT distinct(ProcessDefId) FROM VarMappingTable';
			OPEN Cursor1 FOR v_queryStr;
			LOOP
				FETCH Cursor1 INTO v_ProcessDefId;
				EXIT WHEN Cursor1%NOTFOUND;

				EXECUTE IMMEDIATE 'insert into VarMappingTable (ProcessDefId,VariableId,SystemDefinedName,UserDefinedName,VariableType,VariableScope,ExtObjId,DefaultValue,VariableLength,VarPrecision,Unbounded)  values('||To_Char(v_ProcessDefId)|| ',  10029,    ''TATConsumed'',''TATConsumed'',     4,    ''S''    ,0,    NULL,    NULL   ,0    ,''N'')';				
			END LOOP;
			CLOSE Cursor1;
		COMMIT;
	EXCEPTION
	WHEN OTHERS THEN
		ROLLBACK TO SAVEPOINT TATConsumed;
		CLOSE Cursor1;
	END;
	END IF;

	BEGIN
		v_existsFlag := -1;
		SELECT COUNT(1) INTO v_existsFlag FROM user_tab_columns WHERE UPPER(table_name) = UPPER('WFTypeDefTable') AND UPPER(column_name) = UPPER('SortingFlag');
		IF(v_existsFlag = 0) THEN
			EXECUTE IMMEDIATE 'ALTER TABLE WFTypeDefTable ADD SortingFlag NVARCHAR2(1)';
			EXECUTE IMMEDIATE 'UPDATE WFTypeDefTable SET SortingFlag = ''N''';
		END IF;
	EXCEPTION WHEN OTHERS THEN
		raise_application_error(-20231, 'BLOCK 116 FAILED');
	END;

	BEGIN
		v_existsFlag := -1;
		SELECT COUNT(1) INTO v_existsFlag FROM user_tab_columns WHERE UPPER(table_name) = UPPER('WFUDTVarMappingTable') AND UPPER(column_name) = UPPER('DefaultSortingFieldname');
		IF(v_existsFlag = 0) THEN
			EXECUTE IMMEDIATE 'ALTER TABLE WFUDTVarMappingTable ADD (DefaultSortingFieldname NVARCHAR2(256), DefaultSortingOrder INT)';
			OPEN V_CURSOR1 FOR SELECT ProcessDefId, VariableId FROM VarMappingTable WHERE VariableType = 11 AND Unbounded = 'Y';
			LOOP
			BEGIN
				FETCH V_CURSOR1 INTO v_ProcessDefId, v_variableid;
				EXIT WHEN V_CURSOR1%NOTFOUND;
				EXECUTE IMMEDIATE 'UPDATE WFUDTVarMappingTable SET DefaultSortingFieldname = ''insertionorderid'', DefaultSortingOrder = 0 WHERE ProcessDefId = :ProcessDefId AND VariableId = :VariableId AND ParentVarFieldId = 0' USING v_ProcessDefId, v_variableid;
			END;
			END LOOP;
			CLOSE V_CURSOR1;
		END IF;
	EXCEPTION WHEN OTHERS THEN
		IF V_CURSOR1%ISOPEN THEN
			CLOSE V_CURSOR1;
		END IF;
		raise_application_error(-20231, 'BLOCK 117 FAILED');
	END;
	
	BEGIN
	  existsFlag :=0;
	  select char_length  into existsFlag FROM USER_TAB_COLUMNS  where upper(table_name) = upper('wfmailqueuetable') and upper(column_name) = upper('mailsubject');
	  IF (existsFlag < 512) THEN
		EXECUTE IMMEDIATE 'ALTER TABLE wfmailqueuetable RENAME COLUMN mailSubject to mailSubject_bkp';
		EXECUTE IMMEDIATE 'ALTER TABLE wfmailqueuetable ADD(mailSubject NVARCHAR2(512))';
		EXECUTE IMMEDIATE 'update wfmailqueuetable set mailSubject = mailSubject_bkp';
		EXECUTE IMMEDIATE 'ALTER TABLE wfmailqueuetable DROP COLUMN mailSubject_bkp';
	  end if;
	END;
	
	BEGIN
	  existsFlag :=0;
	  select char_length  into existsFlag FROM USER_TAB_COLUMNS  where upper(table_name) = upper('wfmailqueuehistorytable') and upper(column_name) = upper('mailsubject');
	  IF (existsFlag < 512) THEN
		EXECUTE IMMEDIATE 'ALTER TABLE wfmailqueuehistorytable RENAME COLUMN mailSubject to mailSubject_bkp';
		EXECUTE IMMEDIATE 'ALTER TABLE wfmailqueuehistorytable ADD(mailSubject NVARCHAR2(512))';
		EXECUTE IMMEDIATE 'update wfmailqueuehistorytable set mailSubject = mailSubject_bkp';
		EXECUTE IMMEDIATE 'ALTER TABLE wfmailqueuehistorytable DROP COLUMN mailSubject_bkp';
	  end if;
	END;

END;

~
call TableScript()

~

DROP PROCEDURE TableScript

~