/*______________________________________________________________________________________________________________-
		NEWGEN SOFTWARE TECHNOLOGIES LIMITED

	Group						: Application – Products
	Product / Project			: WorkFlow
	Module						: Transaction Server
	File NAME					: Upgrade.sql (Oracle Server)
	Author						: Ishu Saraf
	Date written (DD/MM/YYYY)	: 17/03/2009
	Description					: 
________________________________________________________________________________________________________________-
			CHANGE HISTORY
________________________________________________________________________________________________________________-
Date		Change By		Change Description (Bug No. (If Any))
27/03/2009	Ruhi Hira		SrNo-15, New tables added for SAP integration.
15/03/2009      Ananta Handoo           New table WFSAPAdapterAssocTable added for SAP Integration.
17/06/2009	Ishu Saraf		New tables added for OFME - WFPDATable, WFPDA_FormTable, WFPDAControlValueTable
23/06/2009      Ananta Handoo           WFSAPGUIDefTable Modified by Ananta Handoo.Three fields added TCodeType, VariableId, VarFieldId
24/06/2009	Ishu Saraf		Change the datatype of column MESSAGE of MAILTRIGGERTABLE
24/08/2009      Shilpi S                HotFix_8.0_045, two new columns VariableId and VarFieldId are added for variable doctype name support in PFE
31/08/2009	Ashish Mangla		WFS_8.0_025 (Arglist length should increased to 2000 from 512 for generate Response)
31/08/2009      Shilpi S                WFS_8.0_026 , workitem specific calendar
11/09/2009	Saurabh Kamal		New tables created as WFExtInterfaceConditionTable and WFExtInterfaceOperationTable
14/09/2009	Vikas Saraswat		WFS_8.0_031	User not having rights on queue, can view the workitem in readonly mode, if he has rights on query workstep. Workitem opens based on properties of query workstep in this case. Option provided to view the workitem(in read only mode) with the properties of the queue in which workitem exists, instead of query workstep properties.
05/10/2009	Vikas Saraswat		WFS_8.0_038	Support of Auto Refresh Interval for a Queue.
15/10/2009	Saurabh Kamal		WFS_8.0_044 Support of TurnAroundDateTime in FetchWorkList and SearchWorkitem
07/12/2009	Saurabh Kamal		WFS_8.0_061	New column added as ProcessDefId in VarAliasTable   
26/05/2011	Saurabh Kamal		Bug 27108, SUPERIOR, SUPERIORFLAG added to WFUserView
19/08/2010	Vikas Saraswat		WFUserWebServerInfoTable added
07/10/2010	Abhishek Gupta/Saurabh Kamal		WFS_8.0_136 Alias support for external variables.
01/09/2010	Saurabh Kamal		Upgrade for CreateChildWorkitem and DeleteChildWorkitem
13/03/2012	Preeti Awasthi		Bug 30633: 1. Support of Macro in File path
										   2. Support of exporting all documents for mapped document Type
30/03/2012  Neeraj Kumar           Replicated -WFS_8.0_148 Data should retrieve from arrary tables in order of its insertion.
03/04/2012	Bhavneet Kaur		Bug 30559 Provide Refresh in Archive rather than Disconnect		
07/05/2012  Akash Bartaria      Bugzilla – Bug 31570| Multiple SAP server support - Multiple ConfigurationID within one Process 					
12/06/2012	Abhishek Gupta		Bug 32579 - BCC support in e-mail generated through Omniflow.
23/07/2012	Tanisha Ghai 		Bug 32861 Partition Name to be Provided while registering Server from ConfigServer and Web. 
30/08/2012  Bhavneet Kaur   	Bug 34473- Support of adding multiple documents in mulitple folder in case of sharepoint archive workstep
12/09/2012	Preeti Awasthi		Bug 34839 - User should get pop-up for reminder without relogin
15/01/2013	Bhavneet Kaur		[Replicated] Bug 34896 - Provide option to select if form is AppletView
05/02/2013	Bhavneet Kaur		Errors while Upgrading from 8.0
21/03/2013	Neeraj Sharma		Bug 38685 An entry for each failed records need to be generated in WFFailedServicesTable if any error occurs while
processing records from the CSV/TXT file.
04/04/2013 Anwar Ali Danish    Bug 38828 - Changes done for diversion requirement. CSCQR-00000000050705-Process 
16/04/2013	Bhavneet Kaur		VariableId and VariableFieldId columns in PrintFaxEmaildocTypeTable must have default values as 0
16/04/2013	Bhavneet Kaur		Type1 column of VaraliasTable was not getting updated to NVARCHAR2(4) from NVARCHAR2(1)
05/06/2013	Sanal Grover		Bug 39921 - Change in the Size of attachmentISIndex and attachmentNames Columns of WFMailQueueTable and WFMailQueueHistoryTable
24/06/2013	Sanal Grover		Bug 39147 - Removing TR_LOG_PDBCONNECTION trigger on PDBConnection for logging in WFCurrentRouteLogTable.
03/07/2013 Anwar Ali Danish    Bug 38828 - Changes done for diversion requirement. CSCQR-00000000050705-Process, Q_DivertedByUserId added in  GTEMPWORKLISTTABLE
24/07/2013	Sweta Bansal		Bug 41507 - Handling regarding Performance or slowness issue in Message Agent.
05/08/2013	Sweta Bansal		Bug 41693 - Assigned or Locked workitem by a particular user are not getting released when the user get deleted from the OmniDocs end. 
07/08/2013  Neeraj Sharma       Bug 41744 - Column list was appended in the insertion clause while inserting data from varaliastable2 into varaliastable 
19/08/2013  Sweta Bansal		Bug 41790 - MultiLingual Support in OmniFLow Server.(Screen for specifying names of processes, queues,activities, variables, aliases in multiple locales for multilingual functionality.) 
29/08/2013    Kahkeshan         Bug 39079 - EscalateToWithTrigger Feature requirement
30/08/2013    Shweta Singhal    Bug 41770 - TargetDoc added in WFSharePointDocAssocTable
03/09/2013    Neeraj Sharma       Bug 41486 - Creating functional index on QueueDataTable
04/09/2013	Sweta Bansal		Bug 41955 - Optimization in Message Agent to enhance the performance.
10/09/2013    Neeraj Sharma     Bug 42033 - While creating Alias from process Manager the 'Requested Filter Invalid' was coming for Oracle cabinet. 
01/10/2013  Sweta Bansal		Bug 41790 - MultiLingual Support in OmniFLow Server.(Screen for specifying names of processes, queues,activities, variables, aliases in multiple locales for multilingual functionality.)
07/10/2013  Sweta Bansal		Bug 42321 - Support for providing the better debugging in case of Message Agent so that it is easier to find out the Failure Point in code for the failed message.
12/11/2013	Rahul Nagar			Bug 42494 - BCC support at each email sending modules
14/11/2013  Neeraj Sharma		Bug 42579 - The UserList fetched through process Manager displays the User even after deleting a User from OmniDocs.
29/11/2013  Sweta Bansal		Bug 42680 - WFGetMultiLingual API is added to return all the multilingual defined for a process.
06/01/2014  Sweta Bansal		Bug 42827 - Handling of Primary Key Violation error in GetNextWorkItem API in case multiple process server are running.
10/01/2014	Sanal Grover		Bug 42858 - Change the type of message column in PrintFaxEmailTable to NCLOB. 
07/02/2014  Sweta Bansal		Bug 43028 - Support for encrypting the password before inserting the same into WFExportInfoTable through WFSetExportCabinetInfo API and fetch the decrypted value of same field from WFExportInfoTable through WFGetExportCabinetInfo API.
18/03/2014	Sanal Grover		Bug 43469 - Support for Bulk PS
20/05/2014	Sweta Bansal		Bug 45829 - Create a trigger on PSRegisterationTable so that whenever any utility get unregistered, all the locked instances by that particular utility get unlocked.
15/07/2014	Neeraj Sharma		Bug 47374 - Message Agent was throwing Error ORA-12899: value too large for column "ADWMS001"."WFCURRENTROUTELOGTABLE"."NEWVALUE" while inserting records to WFCurrentRouteLogTable.
22/07/2014	Dinkar Kad			Bug 47588 - To Provide support for displaying total number of workItems and pages while click on Queue or Seaching from Advance search functionality
25/08/2014  Chitvan Chhabra		Bug 47640 - Upgrade Development for SU6-New Files added/renamed:UpgradeDataTypesandChecks.sql(Created),UpgradeIndexes.sql(Created)
26/08/2014  Gourav Chadha		Bug 47827 - Add support for default SystemArchiveQueue and SystemPFEQueue association.
25/09/2014	Chitvan Chhabra     Bug 50445 - Performance issues: Slowness Reported In search,MessageAgent(WFLockMessage.sql),and General Slowness wrt to USERPREFRENCE TABLE and also Myqueue Slowness becaue of check of Q_userid index not being there on pendingworklisttable
10/10/2014	Sanal Grover		Bug 50987 - When VariableId1 column is added in Varaliastable it should be updated accordingly in correspondence with the variableid present in the varmappingtable
31/10/2014	Sanal Grover		Bug 51650 - VariableId column is added in WFSearchVariableTable.
31/10/2014 Gouarav Chadha       Bug 51527 - Add functionality for deletion of Audit Logs after archive
18/11/2014  Chitvan Chhabra		Bug 51976 - closing open cursors
06/01/2015	Dinkar Kad			Bug 58528 - After upgrading a cabinet from Omniflow 8 to omniflow 10, already configured Search Variable are not visible in Advance Search.
13/07/2016 Bhupendra Singh      Bug 62635 - procedure was unable to compile if VARIABLEID column not present in WFSEARCHVARIABLETABLE in OmniFlowVersionUpgarde
26/05/2017 Sanal Grover			Bug 62518 - Step by Step Debugs in Version Upgrade.
19/06/2017 Ashok Kumar			Bug 70151 - Primary key constraint violation while moving data from wfmailqueuetable to wfmailqueuehistorytable
________________________________________________________________________________________________________________-*/
CREATE OR REPLACE PROCEDURE dropTableIfExist(v_tableName VARCHAR2)
AS
	existsflag NUMBER;
BEGIN
	existsflag:=0;
	SELECT COUNT(*) INTO existsflag from USER_TABLES WHERE TABLE_NAME =UPPER(v_tableName);

	IF(existsflag > 0)
	THEN
	EXECUTE IMMEDIATE 'DROP TABLE '||TO_CHAR(v_tableName);

	END IF;


END;

~

CREATE OR REPLACE PROCEDURE Upgrade AS
existsFlag			INTEGER;
v_lastSeqValue			INTEGER;
v_ProcessDefId			INTEGER;
v_cabVersion		        VARCHAR2(2000);
v_STR1			        VARCHAR2(8000);
v_constraintName		VARCHAR2(512);
v_SAPconstraintName		VARCHAR2(512);
v_param1				VARCHAR2(256);
v_fieldname				VARCHAR2(256);
v_variableType			INT;
v_VariableId   			INT;
v_ExtObjID 				INT;
v_ConfigurationId     INTEGER;
v_DBStatusa				INT;
v_DBStatus				INT;
v_Query               VARCHAR2(1000);
v_extMethodIndex		INT;
v_retval    	INT;
v_queryStr  	VARCHAR2(800);
queryStr		VARCHAR2(1000);
ExportCur		INT;
ProcessCur		INT;
v_tableName 	VARCHAR2(2000);
v_seqName VARCHAR2(100);
v_indexName varchar2(512);
v_nextseq1 NUMBER;
v_nextseq2 NUMBER;
v_ActivityId		INT;
v_QueueId			INT;
v_rowCount			INT;
TYPE DynamicCursor	IS REF CURSOR;
Cursor1				DynamicCursor;
v_nextVal			INT;
v_nullable			varchar2(1);
v_TableExists		INTEGER;
activity_cursor	INTEGER;
retVal INTEGER;
v_procDefId INTEGER;
v_VariableId_String_constant varchar2(25);
v_logStatus 		BOOLEAN;
v_scriptName        NVARCHAR2(100) := 'Upgrade09_SP06_001';
v_WIPTableExist		INTEGER;
v_WWPSTableExist	INTEGER;
		
	FUNCTION LogInsert(v_stepNumber Number,v_stepDetails VARCHAR2 )
	RETURN BOOLEAN
	as 
	DBString   BOOLEAN; 
	dbQuery VARCHAR2(1000);
	BEGIN
		BEGIN
		dbQuery := 'INSERT INTO WFVERSIONUPGRADELOGTABLE(STEPNUMBER,SCRIPTNAME,STEPDETAILS, STARTDATE, STATUS) VALUES(:v_stepNumber,:v_scriptName,:v_stepDetails,SYSTIMESTAMP, ''UPDATING'')';
			--dbms_output.put_line ('dbQuery '|| dbQuery);	
		EXECUTE IMMEDIATE dbQuery using v_stepNumber,v_scriptName,v_stepDetails;
		IF SQL%ROWCOUNT = 1
		THEN
		DBString := FALSE;
		ELSE
		DBString := TRUE;
		END IF;
		--dbms_output.put_line ('LogInsert completed with status: ');
		RETURN DBString;
		END;
	END;
	
	FUNCTION LogSkip(v_stepNumber Number)
	RETURN BOOLEAN
	as
	DBString   BOOLEAN; 
	dbQuery VARCHAR2(1000);
	BEGIN
		BEGIN
		dbQuery := 'UPDATE WFVERSIONUPGRADELOGTABLE set ENDDATE = SYSTIMESTAMP, STATUS = ''INSIDE'' WHERE STEPNUMBER =' || v_stepNumber ||' AND STATUS = ''UPDATING''  AND SCRIPTNAME ='''|| v_scriptName ||'''';
		--dbms_output.put_line ('dbQuery '|| dbQuery);
		EXECUTE IMMEDIATE (dbQuery);
		IF SQL%ROWCOUNT = 1
		THEN
		DBString := FALSE;
		ELSE
		DBString := TRUE;
		END IF;
		--dbms_output.put_line ('LogUpdate completed with status: ');
		RETURN DBString;
		END;
	END;
	
	FUNCTION LogUpdate(v_stepNumber Number)
	RETURN BOOLEAN
	as
	DBString   BOOLEAN; 
	dbQuery1 VARCHAR2(1000);
	dbQuery2 VARCHAR2(1000);
	BEGIN
		BEGIN
		dbQuery1 := 'UPDATE WFVERSIONUPGRADELOGTABLE set ENDDATE = SYSTIMESTAMP, STATUS = ''UPDATED'' WHERE STEPNUMBER =' || v_stepNumber ||' AND STATUS = ''INSIDE''  AND SCRIPTNAME ='''|| v_scriptName ||'''';
		dbQuery2 := 'UPDATE WFVERSIONUPGRADELOGTABLE set ENDDATE = SYSTIMESTAMP, STATUS = ''SKIPPED'' WHERE STEPNUMBER =' || v_stepNumber ||' AND STATUS = ''UPDATING''  AND SCRIPTNAME ='''|| v_scriptName ||'''';
		    
		--dbms_output.put_line ('dbQuery '|| dbQuery);
		EXECUTE IMMEDIATE (dbQuery1);
		EXECUTE IMMEDIATE (dbQuery2);
		IF SQL%ROWCOUNT = 1
		THEN
		DBString := FALSE;
		ELSE
		DBString := TRUE;
		END IF;
		--dbms_output.put_line ('LogUpdate completed with status: ');
		RETURN DBString;
		END;
	END;
	
	
	FUNCTION LogUpdateError(v_stepNumber Number)
	RETURN BOOLEAN
	as
	DBString   BOOLEAN;
	dbQuery VARCHAR2(1000);
	BEGIN
		BEGIN
		dbQuery := 'UPDATE WFVERSIONUPGRADELOGTABLE set ENDDATE = SYSTIMESTAMP,STATUS = ''FAILED'' WHERE STEPNUMBER = ' ||v_stepNumber|| ' AND SCRIPTNAME ='''|| v_scriptName ||'''';
		--dbms_output.put_line ('dbQuery '|| dbQuery);
		EXECUTE IMMEDIATE (dbQuery);
		IF SQL%ROWCOUNT = 1
		THEN
		DBString := FALSE;
		ELSE
		DBString := TRUE;
		END IF;
		--dbms_output.put_line ('LogUpdateError completed with status: ');
		RETURN DBString;
		END;
	END;
	

	FUNCTION checkIFColExist(v_TableName VARCHAR2,v_ColName VARCHAR2 )
	RETURN BOOLEAN
	AS
	existsFlag NUMBER:=0;
	BEGIN
	
		SELECT COUNT(*) INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME=UPPER(v_TableName) 
		AND 
		COLUMN_NAME=UPPER(v_ColName);
		
		IF(existsFlag=0)
		THEN
			dbms_output.put_line ('Table '||v_TableName||' is NOT having coloumn '||v_ColName);
			RETURN FALSE;		
		ELSE
			dbms_output.put_line ('Table '||v_TableName||' is ALREADY having coloumn '||v_ColName);
			RETURN TRUE;		
		END IF;
	
	END;

BEGIN
	
	BEGIN
		v_WIPTableExist := 0;
		v_WWPSTableExist := 0;
		SELECT COUNT(1) INTO v_WIPTableExist FROM USER_TABLES WHERE TABLE_NAME = 'WORKINPROCESSTABLE';
		SELECT COUNT(1) INTO v_WWPSTableExist FROM USER_TABLES WHERE TABLE_NAME = 'WORKWITHPSTABLE';
	END;

	v_logStatus := LogInsert(1,'CREATE TABLE WFCabVersionTable');
	BEGIN
		BEGIN 
			SELECT 1 INTO v_TableExists 
			FROM USER_TABLES  
			WHERE TABLE_NAME = 'PENDINGWORKLISTTABLE';
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
				v_TableExists := 0;
				dbms_output.put_line ('PENDINGWORKLISTTABLE does not exists');
		END;
		
		BEGIN 
			SELECT 1 INTO existsFlag 
			FROM USER_TABLES  
			WHERE TABLE_NAME = 'WFCABVERSIONTABLE';
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
				v_logStatus := LogSkip(1);
				EXECUTE IMMEDIATE 
				'CREATE TABLE WFCabVersionTable (cabVersion	NVARCHAR2(255) NOT NULL, 
				cabVersionId	INT NOT NULL PRIMARY KEY, 
				creationDate	DATE, 
				lastModified	DATE, 
				Remarks		NVARCHAR2(255) NOT NULL,
				Status			NVARCHAR2(1) )';
				dbms_output.put_line ('Table WFCabVersionTable Created successfully');
		END;

	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(1);   
			raise_application_error(-20201,v_scriptName ||' BLOCK 1 FAILED');
	END;
	v_logStatus := LogUpdate(1);

	v_logStatus := LogInsert(2,'Insert value in WFCabVersionTable for START of Upgrade.sql for SU6');
	BEGIN
		v_logStatus := LogSkip(2);
		SELECT  cabversionid.nextval INTO v_nextseq1  FROM DUAL;
		INSERT INTO WFCabVersionTable(cabVersion, cabVersionId, creationDate, lastModified, Remarks, Status) VALUES ('9.0' ,v_nextseq1 , sysdate,sysdate , 'START of Upgrade.sql for SU6','Y');
		COMMIT;

	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(2);   
			raise_application_error(-20202,v_scriptName ||' BLOCK 2 FAILED');
	END;
	v_logStatus := LogUpdate(2);


		
	v_logStatus := LogInsert(3,'Modifying columns cabVersion,Remarks size to 255 in WFCABVERSIONTABLE');
	BEGIN
		v_logStatus := LogSkip(3);
		EXECUTE IMMEDIATE 'ALTER TABLE WFCabVersionTable MODIFY (cabVersion NVARCHAR2(255))';
		DBMS_OUTPUT.PUT_LINE('Table WFCabVersionTable altered with Column cabVersion size increased to 255');	
		EXECUTE IMMEDIATE 'ALTER TABLE WFCabVersionTable MODIFY (Remarks NVARCHAR2(255))';
		DBMS_OUTPUT.PUT_LINE('Table WFCabVersionTable altered with Column Remarks size increased to 255');
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(3);   
			raise_application_error(-20203,v_scriptName ||' BLOCK 3 FAILED');
	END;
	v_logStatus := LogUpdate(3);


		

	v_logStatus := LogInsert(4,'CREATE SEQUENCE CABVERSIONID');
	BEGIN
			
		BEGIN
			SELECT LAST_NUMBER INTO v_lastSeqValue
			FROM USER_SEQUENCES
			WHERE SEQUENCE_NAME = UPPER('cabVersionId');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_logStatus := LogSkip(4);
				EXECUTE IMMEDIATE 'CREATE SEQUENCE CABVERSIONID INCREMENT BY 1 START WITH 1';
				dbms_output.put_line ('SEQUENCE CABVERSIONID Successfully Created');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(4);   
			raise_application_error(-20204,v_scriptName ||' BLOCK 4 FAILED');
	END;
	v_logStatus := LogUpdate(4);

		

	v_logStatus := LogInsert(5,'CREATE SEQUENCE export_sequence');
	BEGIN
		BEGIN
			SELECT LAST_NUMBER INTO v_lastSeqValue
			FROM USER_SEQUENCES
			WHERE SEQUENCE_NAME = UPPER('export_sequence');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_logStatus := LogSkip(5);
				EXECUTE IMMEDIATE 'CREATE SEQUENCE export_sequence
				  MINVALUE 1
				  MAXVALUE 999999999999999999999999999
				  INCREMENT BY 1
				  NOCYCLE
				  NOORDER
				  CACHE 20';
				dbms_output.put_line ('SEQUENCE export_sequence Successfully Created');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(5);   
			raise_application_error(-20205,v_scriptName ||' BLOCK 5 FAILED');
	END;
	v_logStatus := LogUpdate(5);

		
			
		

	v_logStatus := LogInsert(6,'CREATE SEQUENCE libraryid');
	BEGIN
			
		BEGIN
			SELECT LAST_NUMBER INTO v_lastSeqValue
			FROM USER_SEQUENCES
			WHERE SEQUENCE_NAME = UPPER('libraryid');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_logStatus := LogSkip(6);
				EXECUTE IMMEDIATE 'CREATE SEQUENCE libraryid
									  MINVALUE 1
									  MAXVALUE 999999999999999999999999999
									  INCREMENT BY 1
									  NOCYCLE
									  NOORDER
									  NOCACHE';
				dbms_output.put_line ('SEQUENCE libraryid Successfully Created');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(6);   
			raise_application_error(-20206,v_scriptName ||' BLOCK 6 FAILED');
	END;
	v_logStatus := LogUpdate(6);

		
		

	v_logStatus := LogInsert(7,'CREATE TABLE WFSAPConnectTable');
	BEGIN
		
		
	/*SrNo-15, New tables added for SAP integration by Ruhi Hira.*/

		BEGIN 
			SELECT 1 INTO existsFlag 
			FROM USER_TABLES  
			WHERE TABLE_NAME = UPPER('WFSAPConnectTable');
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
				v_logStatus := LogSkip(7);
				EXECUTE IMMEDIATE 
				q'{CREATE TABLE WFSAPConnectTable (
					ProcessDefId		INT						NOT NULL	PRIMARY KEY,
					SAPHostName			NVARCHAR2(64)	        NOT NULL,
					SAPInstance			NVARCHAR2(2)			NOT NULL,
					SAPClient			NVARCHAR2(3)			NOT NULL,
					SAPUserName			NVARCHAR2(256)				NULL,
					SAPPassword			NVARCHAR2(512)				NULL,
					SAPHttpProtocol		NVARCHAR2(8)				NULL,
					SAPITSFlag			NVARCHAR2(1)				NULL,
					SAPLanguage			NVARCHAR2(8)				NULL,
					SAPHttpPort			INT							NULL,
					SecurityFlag		NVARCHAR2(1)		    DEFAULT 'Y'
				)}';
			DBMS_OUTPUT.PUT_LINE ('Table WFSAPConnectTable Created successfully');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(7);   
			raise_application_error(-20207,v_scriptName ||' BLOCK 7 FAILED');
	END;
	v_logStatus := LogUpdate(7);



	v_logStatus := LogInsert(8,'CREATE TABLE WFSAPGUIDefTable');
	BEGIN
		
	/*Modified on 23-06-2009 by Ananta Handoo .Three fields added TCodeType, VariableId, VarFieldId */
		BEGIN 
			SELECT 1 INTO existsFlag 
			FROM USER_TABLES  
			WHERE TABLE_NAME = UPPER('WFSAPGUIDefTable');
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
				v_logStatus := LogSkip(8);
				EXECUTE IMMEDIATE 
				'CREATE TABLE WFSAPGUIDefTable (
					ProcessDefId		INT					NOT NULL,
					DefinitionId		INT					NOT NULL,
					DefinitionName		NVARCHAR2(256)		NOT NULL,
					SAPTCode			NVARCHAR2(64)		NOT NULL,
					TCodeType			NVARCHAR2(1)	NOT NULL,
					VariableId			INT				NULL,
					VarFieldId			INT				NULL,
					PRIMARY KEY (ProcessDefId, DefinitionId)
				)';
			DBMS_OUTPUT.PUT_LINE ('Table WFSAPGUIDefTable Created successfully');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(8);   
			raise_application_error(-20208,v_scriptName ||' BLOCK 8 FAILED');
	END;
	v_logStatus := LogUpdate(8);




	v_logStatus := LogInsert(9,'CREATE TABLE WFSAPGUIFieldMappingTable');
	BEGIN
		BEGIN 
			SELECT 1 INTO existsFlag 
			FROM USER_TABLES  
			WHERE TABLE_NAME = UPPER('WFSAPGUIFieldMappingTable');
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
				v_logStatus := LogSkip(9);
				EXECUTE IMMEDIATE 
				'CREATE TABLE WFSAPGUIFieldMappingTable (
					ProcessDefId		INT					NOT NULL,
					DefinitionId		INT					NOT NULL,
					SAPFieldName		NVARCHAR2(512)	    NOT NULL,
					MappedFieldName		NVARCHAR2(256)	    NOT NULL,
					MappedFieldType		NVARCHAR2(1)	    CHECK (MappedFieldType	IN (N''Q'', N''F'', N''C'', N''S'', N''I'', N''M'', N''U'')),
					VariableId			INT						NULL,
					VarFieldId			INT						NULL
				)';
			DBMS_OUTPUT.PUT_LINE ('Table WFSAPGUIFieldMappingTable Created successfully');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(9);   
			raise_application_error(-20209,v_scriptName ||' BLOCK 9 FAILED');
	END;
	v_logStatus := LogUpdate(9);

		
		

	v_logStatus := LogInsert(10,'CREATE TABLE WFSAPGUIAssocTable');
	BEGIN
		
		BEGIN 
			SELECT 1 INTO existsFlag 
			FROM USER_TABLES  
			WHERE TABLE_NAME = UPPER('WFSAPGUIAssocTable');
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
				v_logStatus := LogSkip(10);
				EXECUTE IMMEDIATE 
				'CREATE TABLE WFSAPGUIAssocTable (
					ProcessDefId		INT					NOT NULL,
					ActivityId			INT					NOT NULL,
					DefinitionId		INT					NOT NULL,
					Coordinates         NVARCHAR2(255)          NULL, 
					CONSTRAINT UK_WFSAPGUIAssocTable UNIQUE (ProcessDefId, ActivityId, DefinitionId)
				)';
			DBMS_OUTPUT.PUT_LINE ('Table WFSAPGUIAssocTable Created successfully');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(10);   
			raise_application_error(-20210,v_scriptName ||' BLOCK 10 FAILED');
	END;
	v_logStatus := LogUpdate(10);

		

	v_logStatus := LogInsert(11,'CREATE TABLE WFSAPAdapterAssocTable');
	BEGIN
		/* New table WFSAPAdapterAssocTable added for SAP Integration.*/
	   BEGIN 
			SELECT 1 INTO existsFlag 
			FROM USER_TABLES  
			WHERE TABLE_NAME = UPPER('WFSAPAdapterAssocTable');
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
				v_logStatus := LogSkip(11);
				EXECUTE IMMEDIATE 
				'CREATE TABLE WFSAPAdapterAssocTable (
					ProcessDefId		INT				 NULL,
					ActivityId		INT				 NULL,
					EXTMETHODINDEX		INT				 NULL
				)';
			DBMS_OUTPUT.PUT_LINE ('Table WFSAPAdapterAssocTable Created successfully');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(11);   
			raise_application_error(-20211,v_scriptName ||' BLOCK 11 FAILED');
	END;
	v_logStatus := LogUpdate(11);


		

	v_logStatus := LogInsert(12,'Recreating Table MAILTRIGGERTABLE');
	BEGIN
		BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('MAILTRIGGERTABLE') 
			AND 
			COLUMN_NAME=UPPER('Message')
			AND
			DATA_TYPE=UPPER('NCLOB');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_logStatus := LogSkip(12);
				EXECUTE IMMEDIATE 'CREATE TABLE MAILTRIGGERTABLE2 ( 
									ProcessDefId 		INT 			NOT NULL,
									TriggerID 			SMALLINT 		NOT NULL,
									Subject 			NVARCHAR2(255) 		NULL,
									FromUser			NVARCHAR2(255)		NULL,
									FromUserType		NVARCHAR2(1)		NULL,
									ExtObjIDFromUser	INT 				NULL,
									VariableIdFrom		INT					NULL,
									VarFieldIdFrom		INT					NULL,
									ToUser				NVARCHAR2(255)	NOT NULL,
									ToType				NVARCHAR2(1)	NOT NULL,
									ExtObjIDTo			INT					NULL,
									VariableIdTo		INT					NULL,
									VarFieldIdTo		INT					NULL,
									CCUser				NVARCHAR2(255)		NULL,
									CCType				NVARCHAR2(1)		NULL,
									ExtObjIDCC			INT					NULL,
									VariableIdCc		INT					NULL,
									VarFieldIdCc		INT					NULL,
									Message				NCLOB				NULL,
									PRIMARY KEY (Processdefid , TriggerID)
								)'; 
						DBMS_OUTPUT.PUT_LINE ('Table MAILTRIGGERTABLE2 Successfully Created');
				SAVEPOINT save;
						EXECUTE IMMEDIATE 'INSERT INTO MAILTRIGGERTABLE2 SELECT 
											ProcessDefId,TriggerID,Subject,FromUser,FromUserType,
											ExtObjIDFromUser,VariableIdFrom,VarFieldIdFrom,
											ToUser,ToType,ExtObjIDTo,VariableIdTo,VarFieldIdTo,CCUser,CCType,
											ExtObjIDCC,VariableIdCc,VarFieldIdCc,TO_LOB(Message) FROM MAILTRIGGERTABLE'; 
						EXECUTE IMMEDIATE 'RENAME MAILTRIGGERTABLE TO MAILTRIGGERTABLE_Patch8'; 
						EXECUTE IMMEDIATE 'RENAME MAILTRIGGERTABLE2 TO MAILTRIGGERTABLE';
						EXECUTE IMMEDIATE 'DROP TABLE MAILTRIGGERTABLE_Patch8';
				COMMIT; 
		END;
		
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(12);   
			raise_application_error(-20212,v_scriptName ||' BLOCK 12 FAILED');
	END;
	v_logStatus := LogUpdate(12);

		
		

	v_logStatus := LogInsert(13,'Adding new Column BCCUser,EXTOBJIDBCC,EXTOBJIDBCC,VARIABLEIDBCC,VARFIELDIDBCC in MAILTRIGGERTABLE');
	BEGIN
			existsFlag := 0;
		BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('MAILTRIGGERTABLE') 
			AND 
			COLUMN_NAME=UPPER('BCCUser');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_logStatus := LogSkip(13);
				EXECUTE IMMEDIATE 'ALTER TABLE MAILTRIGGERTABLE Add (BCCUser NVARCHAR2(255),BCCTYPE NVARCHAR2(255) Default ''C'', EXTOBJIDBCC NUMBER(*,0), VARIABLEIDBCC NUMBER(*,0), VARFIELDIDBCC NUMBER(*,0))';
				
				EXECUTE IMMEDIATE Q'{UPDATE MAILTRIGGERTABLE SET BCCTYPE=N'C'  WHERE BCCTYPE IS NULL }';			
				DBMS_OUTPUT.PUT_LINE('Table MAILTRIGGERTABLE altered with new Column BCCUser,EXTOBJIDBCC,EXTOBJIDBCC,VARIABLEIDBCC,VARFIELDIDBCC ROWCOUNT:'||SQL%ROWCOUNT);
				COMMIT;
		END;

	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(13);   
			raise_application_error(-20213,v_scriptName ||' BLOCK 13 FAILED');
	END;
	v_logStatus := LogUpdate(13);


		
	v_logStatus := LogInsert(14,'Adding new Column MailPriority,MailPriorityType,ExtObjIdMailPriority,VariableIdMailPriority,VarFieldIdMailPriority in MAILTRIGGERTABLE');
	BEGIN
		
		/* BUG 42795 */
			existsFlag := 0;
		BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('MAILTRIGGERTABLE') 
			AND 
			COLUMN_NAME=UPPER('MailPriority');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_logStatus := LogSkip(14);
				EXECUTE IMMEDIATE 'ALTER TABLE MAILTRIGGERTABLE Add (MailPriority NVARCHAR2(255),MailPriorityType NVARCHAR2(255) Default ''C'', ExtObjIdMailPriority NUMBER(*,0), VariableIdMailPriority NUMBER(*,0), VarFieldIdMailPriority NUMBER(*,0))';
				EXECUTE IMMEDIATE Q'{UPDATE MAILTRIGGERTABLE SET MailPriorityType = N'C' WHERE MailPriorityType IS NULL}';
				
				DBMS_OUTPUT.PUT_LINE('Table MAILTRIGGERTABLE altered with new Column MailPriority,MailPriorityType,ExtObjIdMailPriority,VariableIdMailPriority,VarFieldIdMailPriority');
				COMMIT;
		END;

	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(14);   
			raise_application_error(-20214,v_scriptName ||' BLOCK 14 FAILED');
	END;
	v_logStatus := LogUpdate(14);

		
	v_logStatus := LogInsert(15,'Adding new Column DeleteAudit in ARCHIVETABLE');
	BEGIN
			
		existsFlag := 0;
		BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('ARCHIVETABLE') 
			AND 
			COLUMN_NAME=UPPER('DeleteAudit');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_logStatus := LogSkip(15);
				EXECUTE IMMEDIATE 'ALTER TABLE ARCHIVETABLE Add (DeleteAudit NVARCHAR2(1) Default ''N'')';
				
				EXECUTE IMMEDIATE Q'{UPDATE ARCHIVETABLE SET DeleteAudit=N'N' WHERE DeleteAudit IS NULL }';			
				DBMS_OUTPUT.PUT_LINE('Table ARCHIVETABLE altered with new Column DeleteAudit ROWCOUNT:'||SQL%ROWCOUNT);
				COMMIT;
		END;
		
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(15);   
			raise_application_error(-20215,v_scriptName ||' BLOCK 15 FAILED');
	END;
	v_logStatus := LogUpdate(15);


	v_logStatus := LogInsert(16,'Adding new Column InputBuffer,OutputBuffer in WFWebServiceTable');
	BEGIN
		
		BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('WFWebServiceTable') 
			AND 
			COLUMN_NAME=UPPER('InputBuffer');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_logStatus := LogSkip(16);
				EXECUTE IMMEDIATE 'ALTER TABLE WFWebServiceTable Add InputBuffer NCLOB';
				DBMS_OUTPUT.PUT_LINE('Table WFWebServiceTable altered with new Column InputBuffer');
				EXECUTE IMMEDIATE 'ALTER TABLE WFWebServiceTable Add OutputBuffer NCLOB';
				DBMS_OUTPUT.PUT_LINE('Table WFWebServiceTable altered with new Column OutputBuffer');
		END;
		
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(16);   
			raise_application_error(-20216,v_scriptName ||' BLOCK 16 FAILED');
	END;
	v_logStatus := LogUpdate(16);


	v_logStatus := LogInsert(17,'Creating TABLE WFPDATable');
	BEGIN
			/* Added by Ishu Saraf - 17/06/2009 */
		BEGIN 
			SELECT 1 INTO existsFlag 
			FROM USER_TABLES  
			WHERE TABLE_NAME = UPPER('WFPDATable');
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
				v_logStatus := LogSkip(17);
				EXECUTE IMMEDIATE 
				'CREATE TABLE WFPDATable(
					ProcessDefId		INT				NOT NULL, 
					ActivityId			INT				NOT NULL , 
					InterfaceId			INT				NOT NULL,
					InterfaceType		NVARCHAR2(1)
				)';
			DBMS_OUTPUT.PUT_LINE ('Table WFPDATable Created successfully');
		END;
		
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(17);   
			raise_application_error(-20217,v_scriptName ||' BLOCK 17 FAILED');
	END;
	v_logStatus := LogUpdate(17);

		

	v_logStatus := LogInsert(18,'Creating TABLE WFPDA_FormTable');
	BEGIN
			
		/* Added by Ishu Saraf - 17/06/2009 */
		BEGIN 
			SELECT 1 INTO existsFlag 
			FROM USER_TABLES  
			WHERE TABLE_NAME = UPPER('WFPDA_FormTable');
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
				v_logStatus := LogSkip(18);
				EXECUTE IMMEDIATE 
				'CREATE TABLE WFPDA_FormTable(
					ProcessDefId		INT				NOT NULL, 
					ActivityId			INT				NOT NULL , 
					VariableID			INT				NOT NULL, 
					VarfieldID			INT				NOT NULL,
					ControlType			INT				NOT NULL,
					DisplayName			NVARCHAR2(255), 
					MinLen				INT				NOT NULL, 
					MaxLen				INT				NOT NULL,
					Validation			INT				NOT NULL, 
					OrderId				INT				NOT NULL
				)';
			DBMS_OUTPUT.PUT_LINE ('Table WFPDA_FormTable Created successfully');
		END;
		
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(18);   
			raise_application_error(-20218,v_scriptName ||' BLOCK 18 FAILED');
	END;
	v_logStatus := LogUpdate(18);


	v_logStatus := LogInsert(19,'Creating TABLE WFPDAControlValueTable');
	BEGIN
			/* Added by Ishu Saraf - 17/06/2009 */
		BEGIN 
			SELECT 1 INTO existsFlag 
			FROM USER_TABLES  
			WHERE TABLE_NAME = UPPER('WFPDAControlValueTable');
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
				v_logStatus := LogSkip(19);
				EXECUTE IMMEDIATE 
				'CREATE TABLE WFPDAControlValueTable(
					ProcessDefId	INT			NOT NULL, 
					ActivityId		INT			NOT NULL, 
					VariableId		INT			NOT NULL,
					VarFieldId		INT			NOT NULL,
					ControlValue	NVARCHAR2(255)
				)';
			DBMS_OUTPUT.PUT_LINE ('Table WFPDAControlValueTable Created successfully');
		END;
		
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(19);   
			raise_application_error(-20219,v_scriptName ||' BLOCK 19 FAILED');
	END;
	v_logStatus := LogUpdate(19);

		

	v_logStatus := LogInsert(20,'Adding two new Columns VariableId and VarFieldId in PrintFaxEmailDocTypeTable');
	BEGIN
			/*HotFix_8.0_045- Variable support in doctypename in PFE*/
			
		BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('PrintFaxEmailDocTypeTable') 
			AND 
			COLUMN_NAME=UPPER('VariableId');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_logStatus := LogSkip(20);
				EXECUTE IMMEDIATE 'ALTER TABLE PrintFaxEmailDocTypeTable Add ( VariableId INT 0, VarFieldId INT 0)';
				DBMS_OUTPUT.PUT_LINE('Table PrintFaxEmailDocTypeTable altered with two new Columns VariableId and VarFieldId');
		END;
		
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(20);   
			raise_application_error(-20220,v_scriptName ||' BLOCK 20 FAILED');
	END;
	v_logStatus := LogUpdate(20);

	v_logStatus := LogInsert(21,'Adding a new Column CalendarName in QueueDataTable');
	BEGIN
			/*WFS_8.0_026 - workitem specific calendar*/
		
		BEGIN
			IF v_TableExists = 1
			THEN
				BEGIN
					SELECT 1 INTO existsFlag 
					FROM USER_TAB_COLUMNS
					WHERE TABLE_NAME=UPPER('QueueDataTable') 
					AND 
					COLUMN_NAME=UPPER('CalendarName');
				EXCEPTION
					WHEN NO_DATA_FOUND THEN
						v_logStatus := LogSkip(21);
						EXECUTE IMMEDIATE 'ALTER TABLE QueueDataTable Add ( CalendarName NVARCHAR2(255) )';
						DBMS_OUTPUT.PUT_LINE('Table QueueDataTable altered with a new Column CalendarName');
				END;
			END IF;
		END;
		
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(21);   
			raise_application_error(-20221,v_scriptName ||' BLOCK 21 FAILED');
	END;
	v_logStatus := LogUpdate(21);



	v_logStatus := LogInsert(22,'Adding a new Column QUERYPREVIEW in QUEUEUSERTABLE');
	BEGIN
			BEGIN
			existsFlag := 0;	
			BEGIN 
				SELECT 1 INTO existsFlag 
				FROM DUAL 
				WHERE 
					NOT EXISTS( SELECT 1 FROM USER_TAB_COLUMNS  
						WHERE UPPER(TABLE_NAME) = 'QUEUEUSERTABLE'
						AND UPPER(COLUMN_NAME) = 'QUERYPREVIEW'			
					);  
			EXCEPTION 
				WHEN NO_DATA_FOUND THEN 
					existsFlag := 0; 
			END; 
			IF existsFlag = 1 THEN
				v_logStatus := LogSkip(22);
				EXECUTE IMMEDIATE 'ALTER TABLE "QUEUEUSERTABLE" ADD "QUERYPREVIEW" NVARCHAR2(1) DEFAULT (N''Y'')'; 
				EXECUTE IMMEDIATE Q'{UPDATE  QUEUEUSERTABLE SET QUERYPREVIEW=N'Y' WHERE QUERYPREVIEW IS NULL}'; 
				DBMS_OUTPUT.PUT_LINE ('QUEUEUSERTABLE Add col QUERYPREVIEW ROWCOUNT:'||SQL%ROWCOUNT);
				COMMIT;
				
			END IF;
		
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(22);   
			raise_application_error(-20222,v_scriptName ||' BLOCK 22 FAILED');
	END;
	v_logStatus := LogUpdate(22);


		
		

	v_logStatus := LogInsert(23,'Creating View QUSERGROUPVIEW');
	BEGIN
		v_logStatus := LogSkip(23);
			EXECUTE IMMEDIATE
				'CREATE OR REPLACE VIEW QUSERGROUPVIEW
				(QUEUEID, USERID, GROUPID, ASSIGNEDTILLDATETIME, QUERYFILTER, QUERYPREVIEW)
				AS 
				SELECT "QUEUEID","USERID","GROUPID","ASSIGNEDTILLDATETIME","QUERYFILTER" ,"QUERYPREVIEW"FROM (  
						SELECT queueid,userid, 	cast ( NULL AS INTEGER ) AS GroupId,assignedtilldatetime , queryFilter ,QueryPreview
						FROM QUEUEUSERTABLE  
						WHERE associationtype=0 
						AND ( assignedtilldatetime IS NULL OR assignedtilldatetime>=SYSDATE ) 
						UNION 
						SELECT queueid, userindex,userid AS groupid, assignedtilldatetime, queryFilter ,QueryPreview
						FROM QUEUEUSERTABLE,wfgroupmemberview 
						WHERE associationtype=1  
						AND QUEUEUSERTABLE.userid=wfgroupmemberview.groupindex 
						  )a';
		END;
		
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(23);   
			raise_application_error(-20223,v_scriptName ||' BLOCK 23 FAILED');
	END;
	v_logStatus := LogUpdate(23);


		
		

	v_logStatus := LogInsert(24,'INSERT Value in WFCabVersionTable for 7.2_CalendarName_VarMapping');
	BEGIN
				BEGIN
		SELECT CabVersion INTO v_cabVersion FROM WFCABVERSIONTABLE WHERE CabVersion = '7.2_CalendarName_VarMapping'  AND ROWNUM <= 1;
		EXCEPTION 
		WHEN NO_DATA_FOUND THEN
		BEGIN
			v_logStatus := LogSkip(24);
			DECLARE CURSOR cursor1 IS SELECT ProcessDefId FROM PROCESSDEFTABLE;
			BEGIN		
			OPEN cursor1;
			LOOP
				FETCH cursor1 INTO v_ProcessDefId;
				EXIT WHEN cursor1%NOTFOUND;
				BEGIN 
				SELECT variableid INTO v_cabVersion FROM VARMAPPINGTABLE WHERE processdefid=v_ProcessDefId AND variableid=10001;
				EXCEPTION 
				WHEN NO_DATA_FOUND THEN
				BEGIN
				v_STR1 := ' INSERT INTO VarMappingTable VALUES(' || v_ProcessDefId || ', 10001 , N''CalendarName'', N''CalendarName'', 10 , N''M'', 0, NULL , NULL, 0, N''N'')';
				SAVEPOINT cal_varmapping;
					EXECUTE IMMEDIATE v_STR1;
				END;
				END;
				COMMIT;

			END LOOP;
			CLOSE cursor1;
			END;
		EXECUTE IMMEDIATE 'INSERT INTO WFCabVersionTable(cabVersion, cabVersionId, creationDate, lastModified, Remarks, Status) VALUES (N''7.2_CalendarName_VarMapping'', cabVersionId.nextVal, SYSDATE, SYSDATE, N''OmniFlow 7.2'', N''Y'')';	
		END;
		END;
		
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(24);   
			raise_application_error(-20224,v_scriptName ||' BLOCK 24 FAILED');
	END;
	v_logStatus := LogUpdate(24);


	  
	v_logStatus := LogInsert(25,'Creating VIEW QUEUETABLE ');
	BEGIN
			/*WFS_8.0_026 - workitem specific calendar*/
		BEGIN
		IF v_TableExists = 1 THEN
			BEGIN
			v_logStatus := LogSkip(25);
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
				 referredtoname, referredby, referredbyname, collectflag, NULL AS CompletionDateTime, CalendarName
			FROM	QUEUEDATATABLE, 
				PROCESSINSTANCETABLE,
				(SELECT processinstanceid, workitemid, processname, processversion,
					 processdefid, LastProcessedBy, processedby, activityname, activityid,
					 entrydatetime, parentworkitemid, assignmenttype,
					 collectflag, prioritylevel, validtill, q_streamid,
					 q_queueid, q_userid, assigneduser, createddatetime,
					 workitemstate, expectedworkitemdelay, previousstage,
					 lockedbyname, lockstatus, lockedtime, queuename, queuetype,
					 statename
				FROM	WORKLISTTABLE
					UNION ALL
				SELECT processinstanceid, workitemid, processname, processversion,
					processdefid, LastProcessedBy, processedby, activityname, activityid,
					entrydatetime, parentworkitemid, assignmenttype,collectflag, 
					prioritylevel, validtill, q_streamid,q_queueid, q_userid, 
					assigneduser, createddatetime,workitemstate, expectedworkitemdelay, 
					previousstage,lockedbyname, lockstatus, lockedtime, queuename, 
					queuetype,statename
				FROM   WORKINPROCESSTABLE
					UNION ALL
				SELECT processinstanceid, workitemid, processname, processversion,
					processdefid, LastProcessedBy, processedby, activityname, activityid,
					entrydatetime, parentworkitemid, assignmenttype,
					collectflag, prioritylevel, validtill, q_streamid,
					q_queueid, q_userid, assigneduser, createddatetime,
					workitemstate, expectedworkitemdelay, previousstage,
					lockedbyname, lockstatus, lockedtime, queuename, queuetype,
					statename
				FROM   WORKDONETABLE
				UNION ALL
				SELECT processinstanceid, workitemid, processname, processversion,
					processdefid, LastProcessedBy, processedby, activityname, activityid,
					entrydatetime, parentworkitemid, assignmenttype,
					collectflag, prioritylevel, validtill, q_streamid,
					q_queueid, q_userid, assigneduser, createddatetime,
					workitemstate, expectedworkitemdelay, previousstage,
					lockedbyname, lockstatus, lockedtime, queuename, queuetype,
					statename
				FROM   WORKWITHPSTABLE
				UNION ALL
				SELECT processinstanceid, workitemid, processname, processversion,
					processdefid, LastProcessedBy, processedby, activityname, activityid,
					entrydatetime, parentworkitemid, assignmenttype,
					collectflag, prioritylevel, validtill, q_streamid,
					q_queueid, q_userid, assigneduser, createddatetime,
					workitemstate, expectedworkitemdelay, previousstage,
					lockedbyname, lockstatus, lockedtime, queuename, queuetype,
					statename
				FROM   PENDINGWORKLISTTABLE) queuetable1
			WHERE   QUEUEDATATABLE.processinstanceid = queuetable1.processinstanceid
			AND	QUEUEDATATABLE.workitemid = queuetable1.workitemid
			AND	queuetable1.processinstanceid = PROCESSINSTANCETABLE.processinstanceid';

		EXECUTE IMMEDIATE v_STR1;
			END;
			END IF;
		END;

	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(25);   
			raise_application_error(-20225,v_scriptName ||' BLOCK 25 FAILED');
	END;
	v_logStatus := LogUpdate(25);

		  

	v_logStatus := LogInsert(26,'CREATE TABLE WFExtInterfaceConditionTable');
	BEGIN
		/*Added by Saurabh Kamal for Rules on External Interfaces*/
		BEGIN 
			SELECT 1 INTO existsFlag 
			FROM USER_TABLES  
			WHERE TABLE_NAME = UPPER('WFExtInterfaceConditionTable');
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
			v_logStatus := LogSkip(26);
				EXECUTE IMMEDIATE 
				'CREATE TABLE WFExtInterfaceConditionTable (
					ProcessDefId 	    	INT		NOT NULL,
					ActivityId          	INT		NOT NULL ,
					InterFaceType           NVARCHAR2(1)   	NOT NULL ,
					RuleOrderId         	INT      	NOT NULL ,
					RuleId              	INT      	NOT NULL ,
					ConditionOrderId    	INT 		NOT NULL ,
					Param1			NVARCHAR2(50) 	NOT NULL ,
					Type1               	NVARCHAR2(1) 	NOT NULL ,
					ExtObjID1	    	INT		NULL,
					VariableId_1		INT		NULL,
					VarFieldId_1		INT		NULL,
					Param2			NVARCHAR2(255) 	NOT NULL ,
					Type2               	NVARCHAR2(1) 	NOT NULL ,
					ExtObjID2	    	INT		NULL,
					VariableId_2		INT             NULL,
					VarFieldId_2		INT             NULL,
					OPERATOR            	INT 		NOT NULL ,
					LogicalOp           	INT 		NOT NULL 
				)';
			DBMS_OUTPUT.PUT_LINE ('Table WFExtInterfaceConditionTable Created successfully');
		END;

	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(26);   
			raise_application_error(-20226,v_scriptName ||' BLOCK 26 FAILED');
	END;
	v_logStatus := LogUpdate(26);

		
		
	v_logStatus := LogInsert(27,'CREATE TABLE WFExtInterfaceOperationTable');
	BEGIN
		BEGIN 
			SELECT 1 INTO existsFlag 
			FROM USER_TABLES  
			WHERE TABLE_NAME = UPPER('WFExtInterfaceOperationTable');
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
				v_logStatus := LogSkip(27);
				EXECUTE IMMEDIATE 
				'CREATE TABLE WFExtInterfaceOperationTable (
					ProcessDefId 	    	INT		NOT NULL,
					ActivityId          	INT		NOT NULL ,
					InterFaceType           NVARCHAR2(1)   	NOT NULL ,	
					RuleId              	INT      	NOT NULL , 	
					InterfaceElementId	INT		NOT NULL
				)';
			DBMS_OUTPUT.PUT_LINE ('Table WFExtInterfaceOperationTable Created successfully');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(27);   
			raise_application_error(-20227,v_scriptName ||' BLOCK 27 FAILED');
	END;
	v_logStatus := LogUpdate(27);


		

	v_logStatus := LogInsert(28,'Adding new column REFRESHINTERVAL in QUEUEDEFTABLE');
	BEGIN
		BEGIN
			existsFlag := 0;	
			BEGIN 
				SELECT 1 INTO existsFlag 
				FROM DUAL 
				WHERE 
					NOT EXISTS( SELECT 1 FROM USER_TAB_COLUMNS  
						WHERE UPPER(TABLE_NAME) = 'QUEUEDEFTABLE'
						AND UPPER(COLUMN_NAME) = 'REFRESHINTERVAL'			
					);  
			EXCEPTION 
				WHEN NO_DATA_FOUND THEN 
					existsFlag := 0; 
			END; 
			IF existsFlag = 1 THEN
				v_logStatus := LogSkip(28);
				EXECUTE IMMEDIATE 'ALTER TABLE "QUEUEDEFTABLE" ADD "REFRESHINTERVAL" INT '; 
			END IF;
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(28);   
			raise_application_error(-20228,v_scriptName ||' BLOCK 28 FAILED');
	END;
	v_logStatus := LogUpdate(28);

		
		

	v_logStatus := LogInsert(29,'Adding new column TEMPREFRESHINTERVAL in GTEMPQUEUETABLE');
	BEGIN
			BEGIN
			existsFlag := 1;	
			BEGIN 
				 SELECT 1 INTO  existsFlag 
				 FROM USER_TAB_COLUMNS  
				WHERE UPPER(TABLE_NAME) = 'GTEMPQUEUETABLE'
				AND UPPER(COLUMN_NAME) = 'TEMPREFRESHINTERVAL'	;  
			EXCEPTION 
				WHEN NO_DATA_FOUND THEN 
					existsFlag := 0; 
			END; 
			IF existsFlag = 0 THEN
				v_logStatus := LogSkip(29);
				dbms_output.put_line('-Altering table GTEMPQUEUETABLE  with Col TEMPREFRESHINTERVAL');
			
				EXECUTE IMMEDIATE 'ALTER TABLE "GTEMPQUEUETABLE" ADD "TEMPREFRESHINTERVAL" INT '; 	
			END IF;
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(29);   
			raise_application_error(-20229,v_scriptName ||' BLOCK 29 FAILED');
	END;
	v_logStatus := LogUpdate(29);

		
		
		

	v_logStatus := LogInsert(30,'Adding new column SORTORDER in QUEUEDEFTABLE');
	BEGIN
		BEGIN
			existsFlag := 0;	
			BEGIN 
				SELECT 1 INTO existsFlag 
				FROM DUAL 
				WHERE 
					NOT EXISTS( SELECT 1 FROM USER_TAB_COLUMNS  
						WHERE UPPER(TABLE_NAME) = 'QUEUEDEFTABLE'
						AND UPPER(COLUMN_NAME) = 'SORTORDER'			
					);  
			EXCEPTION 
				WHEN NO_DATA_FOUND THEN 
					existsFlag := 0;
			END;
			IF existsFlag = 1 THEN
				v_logStatus := LogSkip(30);
				EXECUTE IMMEDIATE 'ALTER TABLE "QUEUEDEFTABLE" ADD "SORTORDER" NVARCHAR2(1)'; 
			END IF;
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(30);   
			raise_application_error(-20230,v_scriptName ||' BLOCK 30 FAILED');
	END;
	v_logStatus := LogUpdate(30);

		
		

	v_logStatus := LogInsert(31,'Adding new column TEMPORDERBY in GTEMPQUEUETABLE');
	BEGIN
		BEGIN
			existsFlag := 0;	
			BEGIN 
				SELECT 1 INTO existsFlag 
				FROM DUAL 
				WHERE 
					NOT EXISTS( SELECT 1 FROM USER_TAB_COLUMNS  
						WHERE UPPER(TABLE_NAME) = 'GTEMPQUEUETABLE'
						AND UPPER(COLUMN_NAME) = 'TEMPORDERBY'			
					);  
			EXCEPTION 
				WHEN NO_DATA_FOUND THEN 
					existsFlag := 0;
			END;
			IF existsFlag = 1 THEN
				v_logStatus := LogSkip(31);
				EXECUTE IMMEDIATE 'ALTER TABLE "GTEMPQUEUETABLE" ADD "TEMPORDERBY" INT '; 
			END IF;
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(31);   
			raise_application_error(-20231,v_scriptName ||' BLOCK 31 FAILED');
	END;
	v_logStatus := LogUpdate(31);

		
		

	v_logStatus := LogInsert(32,'Adding new column TEMPSORTORDER in GTEMPQUEUETABLE');
	BEGIN
		BEGIN
			existsFlag := 0;	
			BEGIN 
				SELECT 1 INTO existsFlag 
				FROM DUAL 
				WHERE 
					NOT EXISTS( SELECT 1 FROM USER_TAB_COLUMNS  
						WHERE UPPER(TABLE_NAME) = 'GTEMPQUEUETABLE'
						AND UPPER(COLUMN_NAME) = 'TEMPSORTORDER'			
					);  
			EXCEPTION 
				WHEN NO_DATA_FOUND THEN 
					existsFlag := 0;
			END;
			IF existsFlag = 1 THEN
				v_logStatus := LogSkip(32);
				EXECUTE IMMEDIATE 'ALTER TABLE "GTEMPQUEUETABLE" ADD "TEMPSORTORDER" NVARCHAR2(1)'; 
			END IF;
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(32);   
			raise_application_error(-20232,v_scriptName ||' BLOCK 32 FAILED');
	END;
	v_logStatus := LogUpdate(32);


		

	v_logStatus := LogInsert(33,'BLOCK 33');
	BEGIN
		/* WFS_8.0_044 Support of TurnAroundDateTime in FetchWorkList and SearchWorkitem*/
		BEGIN
		SELECT CabVersion INTO v_cabVersion FROM WFCABVERSIONTABLE WHERE CabVersion = '7.2_TurnAroundDateTime_VarMapping' AND ROWNUM <= 1;
		EXCEPTION 
		WHEN NO_DATA_FOUND THEN
		BEGIN
			v_logStatus := LogSkip(33);
			DECLARE CURSOR cursor1 IS SELECT ProcessDefId FROM PROCESSDEFTABLE;
			BEGIN		
			OPEN cursor1;
			LOOP
				FETCH cursor1 INTO v_ProcessDefId;
				EXIT WHEN cursor1%NOTFOUND;
				BEGIN 
				SELECT variableid INTO v_cabVersion FROM VARMAPPINGTABLE WHERE processdefid=v_ProcessDefId AND variableid=10002;
				EXCEPTION 
				WHEN NO_DATA_FOUND THEN
				BEGIN
				v_STR1 := ' INSERT INTO VarMappingTable VALUES(' || v_ProcessDefId || ', 10002 , N''ExpectedWorkitemDelay'', N''TurnAroundDateTime'', 8 , N''S'', 0, NULL , NULL, 0, N''N'')';
				SAVEPOINT cal_varmapping;
					EXECUTE IMMEDIATE v_STR1;
					END;
					END;
				COMMIT;

			END LOOP;
			CLOSE cursor1;
			END;
		EXECUTE IMMEDIATE 'INSERT INTO WFCabVersionTable(cabVersion, cabVersionId, creationDate, lastModified, Remarks, Status) VALUES (N''7.2_TurnAroundDateTime_VarMapping'', cabVersionId.nextVal, SYSDATE, SYSDATE, N''OmniFlow 7.2'', N''Y'')';	
		END;
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(33);   
			raise_application_error(-20233,v_scriptName ||' BLOCK 33 FAILED');
	END;
	v_logStatus := LogUpdate(33);

		
		

	v_logStatus := LogInsert(34,'CREATING TABLE WFImportFileData');
	BEGIN
		BEGIN 
			SELECT 1 INTO existsFlag 
			FROM USER_TABLES  
			WHERE TABLE_NAME = UPPER('WFImportFileData');
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
				v_logStatus := LogSkip(34);
				EXECUTE IMMEDIATE 
				'CREATE TABLE WFImportFileData (
					FileIndex	    INT,
					FileName 	    NVARCHAR2(256),
					FileType 	    NVARCHAR2(10),
					FileStatus	    NVARCHAR2(1),
					Message	        NVARCHAR2(1000),
					StartTime	    TIMESTAMP,
					EndTime	        TIMESTAMP,
					ProcessedBy     NVARCHAR2(256),
					TotalRecords    INT
				)';

				EXECUTE IMMEDIATE 'CREATE SEQUENCE SEQ_WFImportFileId START WITH 1 INCREMENT BY 1';
			DBMS_OUTPUT.PUT_LINE ('Table WFImportFileData Created successfully');
		END;

	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(34);   
			raise_application_error(-20234,v_scriptName ||' BLOCK 34 FAILED');
	END;
	v_logStatus := LogUpdate(34);

		
		
	v_logStatus := LogInsert(35,'Adding new column ProcessDefId in VarAliasTable');
	BEGIN
		
			BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('VarAliasTable') 
			AND 
			COLUMN_NAME=UPPER('ProcessDefId');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_logStatus := LogSkip(35);
				EXECUTE IMMEDIATE 'ALTER TABLE VarAliasTable ADD ProcessDefId INT DEFAULT 0 ';
				EXECUTE IMMEDIATE Q'{UPDATE VarAliasTable SET  ProcessDefId = 0 WHERE ProcessDefId IS NULL}';
				DBMS_OUTPUT.PUT_LINE('Table VarAliasTable altered with new Column ProcessDefId ROWCOUNT'||SQL%ROWCOUNT);			
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(35);   
			raise_application_error(-20235,v_scriptName ||' BLOCK 35 FAILED');
	END;
	v_logStatus := LogUpdate(35);

		

	v_logStatus := LogInsert(36,'Updating Primary Key (queueid, alias, processdefid) in varaliastable');
	BEGIN
			BEGIN
		SELECT CONSTRAINT_NAME INTO v_constraintName
			FROM USER_CONSTRAINTS 
			WHERE TABLE_NAME = UPPER('varaliastable') AND constraint_type = 'P';
			v_logStatus := LogSkip(36);

			EXECUTE IMMEDIATE 'Alter Table varaliastable Drop Constraint ' || TO_CHAR(v_constraintName);
			EXECUTE IMMEDIATE 'Alter Table varaliastable Add Constraint ' || TO_CHAR(v_constraintName) || ' Primary Key (queueid, alias, processdefid)';
			DBMS_OUTPUT.PUT_LINE('Primary Key Updated for varaliastable');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				DBMS_OUTPUT.PUT_LINE('No Primary Key Exists for varaliastable');
		END;

	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(36);   
			raise_application_error(-20236,v_scriptName ||' BLOCK 36 FAILED');
	END;
	v_logStatus := LogUpdate(36);

		
		
	v_logStatus := LogInsert(37,'Adding new column EXPORTSTATUS in PENDINGWORKLISTTABLE');
	BEGIN
		
		IF v_TableExists = 1
		THEN
			BEGIN
			existsFlag := 0;	
				BEGIN 
					SELECT 1 INTO existsFlag 
					FROM DUAL 
					WHERE 
						NOT EXISTS( SELECT 1 FROM USER_TAB_COLUMNS  
							WHERE UPPER(TABLE_NAME) = 'PENDINGWORKLISTTABLE'
							AND UPPER(COLUMN_NAME) = 'EXPORTSTATUS'			
						);  
				EXCEPTION 
					WHEN NO_DATA_FOUND THEN 
						existsFlag := 0; 
				END; 
				IF existsFlag = 1 THEN
					v_logStatus := LogSkip(37);
					EXECUTE IMMEDIATE 'ALTER TABLE "PENDINGWORKLISTTABLE" ADD "EXPORTSTATUS" NVARCHAR2(1) DEFAULT (N''N'')'; 
				END IF;
			END;
		END IF;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(37);   
			raise_application_error(-20237,v_scriptName ||' BLOCK 37 FAILED');
	END;
	v_logStatus := LogUpdate(37);

		

	v_logStatus := LogInsert(38,'CREATING VIEW QUEUEVIEW');
	BEGIN
		
		IF v_TableExists = 1
		THEN
			BEGIN
				v_logStatus := LogSkip(38);
				EXECUTE IMMEDIATE 'CREATE OR REPLACE VIEW QUEUEVIEW AS SELECT * FROM QUEUETABLE	UNION ALL	SELECT PROCESSDEFID, PROCESSNAME, PROCESSVERSION, PROCESSINSTANCEID, PROCESSINSTANCEID AS PROCESSINSTANCENAME, ACTIVITYID, ACTIVITYNAME, PARENTWORKITEMID, WORKITEMID, PROCESSINSTANCESTATE, WORKITEMSTATE, STATENAME, QUEUENAME, QUEUETYPE, ASSIGNEDUSER, ASSIGNMENTTYPE, INSTRUMENTSTATUS, CHECKLISTCOMPLETEFLAG, INTRODUCTIONDATETIME, CREATEDDATETIME AS CREATEDDATETIME, INTRODUCEDBY, CREATEDBYNAME, ENTRYDATETIME, LOCKSTATUS, HOLDSTATUS, PRIORITYLEVEL, LOCKEDBYNAME, LOCKEDTIME, VALIDTILL, SAVESTAGE, PREVIOUSSTAGE, EXPECTEDWORKITEMDELAYTIME AS EXPECTEDWORKITEMDELAYTIME, EXPECTEDPROCESSDELAYTIME AS EXPECTEDPROCESSDELAYTIME, STATUS, VAR_INT1, VAR_INT2, VAR_INT3, VAR_INT4, VAR_INT5, VAR_INT6, VAR_INT7, VAR_INT8, VAR_FLOAT1, VAR_FLOAT2, VAR_DATE1, VAR_DATE2, VAR_DATE3, VAR_DATE4, VAR_LONG1, VAR_LONG2, VAR_LONG3, VAR_LONG4, VAR_STR1, VAR_STR2, VAR_STR3, VAR_STR4, VAR_STR5, VAR_STR6, VAR_STR7, VAR_STR8, VAR_REC_1, VAR_REC_2, VAR_REC_3, VAR_REC_4, VAR_REC_5, Q_STREAMID, Q_QUEUEID, Q_USERID, LASTPROCESSEDBY, PROCESSEDBY, REFERREDTO, REFERREDTONAME, REFERREDBY, REFERREDBYNAME, COLLECTFLAG, NULL AS COMPLETIONDATETIME, CALENDARNAME FROM QUEUEHISTORYTABLE';
			END;
		END IF;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(38);   
			raise_application_error(-20238,v_scriptName ||' BLOCK 38 FAILED');
	END;
	v_logStatus := LogUpdate(38);

		

	v_logStatus := LogInsert(39,'CREATE TABLE WFPURGECRITERIATABLE');
	BEGIN
		EXISTSFLAG := 0;	
		BEGIN 
			SELECT 1 INTO EXISTSFLAG 
			FROM DUAL 
			WHERE 
				NOT EXISTS( 
					SELECT 1 FROM USER_TABLES  
					WHERE UPPER(TABLE_NAME) = 'WFPURGECRITERIATABLE'
				);  
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
				EXISTSFLAG := 0; 
		END; 
		
		IF EXISTSFLAG = 1 THEN
			v_logStatus := LogSkip(39);
			EXECUTE IMMEDIATE
			' CREATE TABLE WFPURGECRITERIATABLE
				(
					PROCESSDEFID	INT		NOT NULL	PRIMARY KEY,
					OBJECTNAME	NVARCHAR2(255)	NOT NULL, 
					EXPORTFLAG	NVARCHAR2(1)	NOT NULL, 
					DATA		CLOB, 
					CONSTRAINT UK_KEY_OBJECTNAME UNIQUE (OBJECTNAME)
				)';
		END IF;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(39);   
			raise_application_error(-20239,v_scriptName ||' BLOCK 39 FAILED');
	END;
	v_logStatus := LogUpdate(39);

		

	v_logStatus := LogInsert(40,'CREATE TABLE WFEXPORTINFOTABLE');
	BEGIN
		EXISTSFLAG := 0;
		BEGIN 
			SELECT 1 INTO EXISTSFLAG 
			FROM DUAL 
			WHERE 
				NOT EXISTS( 
					SELECT 1 FROM USER_TABLES  
					WHERE UPPER(TABLE_NAME) = 'WFEXPORTINFOTABLE'
				);  
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
				EXISTSFLAG := 0; 
		END;

		
		IF EXISTSFLAG = 1 THEN
			v_logStatus := LogSkip(40);
			EXECUTE IMMEDIATE 
			'CREATE TABLE WFEXPORTINFOTABLE
			(
				SOURCEUSERNAME		NVARCHAR2(255)	NOT NULL,
				SOURCEPASSWORD		NVARCHAR2(255)	NOT NULL,
				KEEPSOURCEIS            NVARCHAR2(1),
				TARGETCABINETNAME	NVARCHAR2(255)	NULL,
				APPSERVERIP		NVARCHAR2(20),
				APPSERVERPORT		INT,
				TARGETUSERNAME		NVARCHAR2(200)	NULL,
				TARGETPASSWORD		NVARCHAR2(200)	NULL,
				SITEID			NUMBER ,
				VOLUMEID		NUMBER ,
				WEBSERVERINFO		NVARCHAR2(255)
			)';	
		END IF;

	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(40);   
			raise_application_error(-20240,v_scriptName ||' BLOCK 40 FAILED');
	END;
	v_logStatus := LogUpdate(40);

		
	v_logStatus := LogInsert(41,'CREATE TABLE WFSOURCECABINETINFOTABLE');
	BEGIN
		
		EXISTSFLAG := 0;
		BEGIN
			SELECT 1 INTO EXISTSFLAG 
			FROM DUAL 
			WHERE 
				NOT EXISTS( 
					SELECT 1 FROM USER_TABLES  
					WHERE UPPER(TABLE_NAME) = 'WFSOURCECABINETINFOTABLE'
				);  
		EXCEPTION
			WHEN NO_DATA_FOUND THEN 
				EXISTSFLAG := 0; 
		END;	
		IF EXISTSFLAG = 1 THEN
			v_logStatus := LogSkip(41);
			EXECUTE IMMEDIATE 
			'CREATE TABLE WFSOURCECABINETINFOTABLE
			(
				ISSOURCEIS		NVARCHAR2(1),
				SITEID			NUMBER,
				SOURCECABINET		NVARCHAR2(255),
				APPSERVERIP		NVARCHAR2(30),
				APPSERVERPORT		NUMBER
			)';
		END IF;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(41);   
			raise_application_error(-20241,v_scriptName ||' BLOCK 41 FAILED');
	END;
	v_logStatus := LogUpdate(41);

		

	v_logStatus := LogInsert(42,'Adding new column ALIASRULE in VARALIASTABLE');
	BEGIN
		EXISTSFLAG := 0;	
		BEGIN 
			SELECT 1 INTO EXISTSFLAG 
			FROM DUAL 
			WHERE 
				NOT EXISTS( 
					SELECT 1 FROM USER_TAB_COLUMNS  
					WHERE UPPER(TABLE_NAME) = 'VARALIASTABLE'
					AND UPPER(COLUMN_NAME) = 'ALIASRULE'
				);  
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
				EXISTSFLAG := 0; 
		END; 
		
		IF EXISTSFLAG = 1 THEN
			v_logStatus := LogSkip(42);
			EXECUTE IMMEDIATE 'ALTER TABLE VARALIASTABLE ADD (ALIASRULE NVARCHAR2(2000))';
			DBMS_OUTPUT.PUT_LINE('TABLE VARALIASTABLE ALTERED WITH NEW COLUMN ALIASRULE ADDED');
		END IF;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(42);   
			raise_application_error(-20242,v_scriptName ||' BLOCK 42 FAILED');
	END;
	v_logStatus := LogUpdate(42);

			
		

	v_logStatus := LogInsert(43,'CREATE TABLE WFFormFragmentTable');
	BEGIN
		BEGIN 
			SELECT 1 INTO existsFlag 
			FROM USER_TABLES  
			WHERE TABLE_NAME = UPPER('WFFormFragmentTable');
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
				v_logStatus := LogSkip(43);
				EXECUTE IMMEDIATE 
				'CREATE TABLE WFFormFragmentTable(	
			ProcessDefId	int 		   NOT NULL,
			FragmentId	    int 		   NOT NULL,
			FragmentName	VARCHAR(50)    NOT NULL,
			FragmentBuffer	BLOB           NULL,
			IsEncrypted	    VARCHAR(1)     NOT NULL,
			StructureName	VARCHAR(128)   NOT NULL,
			StructureId	    int            NOT NULL
			)';
				dbms_output.put_line ('Table WFFormFragmentTable Created successfully');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(43);   
			raise_application_error(-20243,v_scriptName ||' BLOCK 43 FAILED');
	END;
	v_logStatus := LogUpdate(43);

		
		
		

	v_logStatus := LogInsert(44,'CREATE TABLE WFDocTypeFieldMapping');
	BEGIN
		BEGIN 
				SELECT 1 INTO existsFlag 
				FROM USER_TABLES  
				WHERE TABLE_NAME = UPPER('WFDocTypeFieldMapping');
			EXCEPTION 
				WHEN NO_DATA_FOUND THEN 
					v_logStatus := LogSkip(44);
					EXECUTE IMMEDIATE 
					'CREATE TABLE WFDocTypeFieldMapping(
					ProcessDefId int NOT NULL,
					DocID int NOT NULL,
					DCName nvarchar2 (30) NOT NULL,
					FieldName nvarchar2 (30) NOT NULL,
					FieldID int NOT NULL,
					VariableID int NOT NULL,
					VarFieldID int NOT NULL,
					MappedFieldType nvarchar2(1) NOT NULL,
					MappedFieldName nvarchar2(255) NOT NULL,
					FieldType int NOT NULL
					)';
				DBMS_OUTPUT.PUT_LINE ('Table WFDocTypeFieldMapping Created successfully');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(44);   
			raise_application_error(-20244,v_scriptName ||' BLOCK 44 FAILED');
	END;
	v_logStatus := LogUpdate(44);

		
			
		

	v_logStatus := LogInsert(45,'CREATE TABLE WFDocTypeSearchMapping');
	BEGIN
		
			BEGIN 
				SELECT 1 INTO existsFlag 
				FROM USER_TABLES  
				WHERE TABLE_NAME = UPPER('WFDocTypeSearchMapping');
			EXCEPTION 
				WHEN NO_DATA_FOUND THEN 
					v_logStatus := LogSkip(45);
					EXECUTE IMMEDIATE 
					'CREATE TABLE WFDocTypeSearchMapping(
					ProcessDefId int NOT NULL,
					ActivityID int NOT NULL,
					DCName nvarchar2(30) NULL,
					DCField nvarchar2(30) NOT NULL,
					VariableID int NOT NULL,
					VarFieldID int NOT NULL,
					MappedFieldType nvarchar2(1) NOT NULL,
					MappedFieldName nvarchar2(255) NOT NULL,
					FieldType int NOT NULL
					)';
				DBMS_OUTPUT.PUT_LINE ('Table WFDocTypeSearchMapping Created successfully');
		END;

	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(45);   
			raise_application_error(-20245,v_scriptName ||' BLOCK 45 FAILED');
	END;
	v_logStatus := LogUpdate(45);



	v_logStatus := LogInsert(46,'CREATE TABLE DOCUMENTTYPEDEFTABLE');
	BEGIN
		
		BEGIN
				SELECT 1 INTO existsFlag 
				FROM USER_TABLES
				WHERE TABLE_NAME=UPPER('DOCUMENTTYPEDEFTABLE'); 
			EXCEPTION
				WHEN NO_DATA_FOUND THEN
					v_logStatus := LogSkip(46);
					EXECUTE IMMEDIATE 'CREATE TABLE DOCUMENTTYPEDEFTABLE (
					ProcessDefId		INT		NOT NULL, 
					DocId			INT		NOT NULL, 
					DocName			NVARCHAR2(50)	NOT NULL,
					DCName 			NVARCHAR2(250)	NULL
					)';
					DBMS_OUTPUT.PUT_LINE('Table DOCUMENTTYPEDEFTABLE created.');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(46);   
			raise_application_error(-20246,v_scriptName ||' BLOCK 46 FAILED');
	END;
	v_logStatus := LogUpdate(46);

		

	v_logStatus := LogInsert(47,'Adding new column DCName in DOCUMENTTYPEDEFTABLE');
	BEGIN
		
			BEGIN
				SELECT 1 INTO existsFlag 
				FROM USER_TAB_COLUMNS
				WHERE TABLE_NAME=UPPER('DOCUMENTTYPEDEFTABLE') 
				AND 
				COLUMN_NAME=UPPER('DCName');
			EXCEPTION
				WHEN NO_DATA_FOUND THEN
					v_logStatus := LogSkip(47);
					EXECUTE IMMEDIATE 'ALTER TABLE DOCUMENTTYPEDEFTABLE ADD DCName NVARCHAR2(250)';
					DBMS_OUTPUT.PUT_LINE('Table DOCUMENTTYPEDEFTABLE altered with new Column DCName');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(47);   
			raise_application_error(-20247,v_scriptName ||' BLOCK 47 FAILED');
	END;
	v_logStatus := LogUpdate(47);

		

	v_logStatus := LogInsert(48,'CREATE TABLE WFDataclassUserInfo');
	BEGIN
		BEGIN 
				SELECT 1 INTO existsFlag 
				FROM USER_TABLES  
				WHERE TABLE_NAME = UPPER('WFDataclassUserInfo');
			EXCEPTION 
				WHEN NO_DATA_FOUND THEN 
					v_logStatus := LogSkip(48);	
					EXECUTE IMMEDIATE 
					'CREATE TABLE WFDataclassUserInfo(
					ProcessDefId int NOT NULL,
					CabinetName nvarchar2(30) NOT NULL,
					UserName nvarchar2(30) NOT NULL,
					SType nvarchar2(1) NOT NULL,
					UserPWD nvarchar2(255) NOT NULL
					)';
				DBMS_OUTPUT.PUT_LINE ('Table WFDataclassUserInfo Created successfully');
		END;	
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(48);   
			raise_application_error(-20248,v_scriptName ||' BLOCK 48 FAILED');
	END;
	v_logStatus := LogUpdate(48);


			

	v_logStatus := LogInsert(49,'CREATE TABLE WFWebServiceInfoTable ');
	BEGIN
		BEGIN 
				SELECT 1 INTO existsFlag 
				FROM USER_TABLES  
				WHERE TABLE_NAME = UPPER('WFWebServiceInfoTable');
			EXCEPTION 
				WHEN NO_DATA_FOUND THEN 
					v_logStatus := LogSkip(49);
					EXECUTE IMMEDIATE 
					'CREATE TABLE WFWebServiceInfoTable (
					ProcessDefId		INT				NOT NULL, 
					WSDLURLId			INT				NOT NULL,
					WSDLURL				NVARCHAR2(2000)		NULL,
					USERId				NVARCHAR2(255)		NULL,
					PWD					NVARCHAR2(255)		NULL,
					SecurityFlag		NVARCHAR2(1) DEFAULT ''Y''		NULL,
					PRIMARY KEY (ProcessDefId, WSDLURLId)
					)';
				DBMS_OUTPUT.PUT_LINE ('Table WFWebServiceInfoTable Created successfully');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(49);   
			raise_application_error(-20249,v_scriptName ||' BLOCK 49 FAILED');
	END;
	v_logStatus := LogUpdate(49);

		
		

	v_logStatus := LogInsert(50,'Adding new column zipFlag,zipName,maxZipSize,alternateMessage in WFMAILQUEUETABLE');
	BEGIN
		BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('WFMAILQUEUETABLE') 
			AND 
			COLUMN_NAME=UPPER('zipFlag');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_logStatus := LogSkip(50);
				EXECUTE IMMEDIATE 'ALTER TABLE WFMAILQUEUETABLE Add zipFlag NVARCHAR2(1)';
				DBMS_OUTPUT.PUT_LINE('Table WFMAILQUEUETABLE altered with new Column zipFlag');
				EXECUTE IMMEDIATE 'ALTER TABLE WFMAILQUEUETABLE Add zipName NVARCHAR2(255)';
				DBMS_OUTPUT.PUT_LINE('Table WFMAILQUEUETABLE altered with new Column zipName');
				EXECUTE IMMEDIATE 'ALTER TABLE WFMAILQUEUETABLE Add maxZipSize NUMBER';
				DBMS_OUTPUT.PUT_LINE('Table WFMAILQUEUETABLE altered with new Column maxZipSize');
				EXECUTE IMMEDIATE 'ALTER TABLE WFMAILQUEUETABLE Add alternateMessage CLOB';
				DBMS_OUTPUT.PUT_LINE('Table WFMAILQUEUETABLE altered with new Column alternateMessage');
				EXECUTE IMMEDIATE 'TRUNCATE TABLE WFMailQueueHistoryTable;';
		END;

	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(50);   
			raise_application_error(-20250,v_scriptName ||' BLOCK 50 FAILED');
	END;
	v_logStatus := LogUpdate(50);

		
		
	v_logStatus := LogInsert(51,'Adding new column TEMPREGPREFIX,TEMPREGSUFFIX,TEMPREQSEQLENGTH in GTempProcessTable');
	BEGIN
			BEGIN 
			existsFlag := 0;
			BEGIN
				SELECT 1 INTO existsFlag
				FROM USER_TAB_COLUMNS
				WHERE UPPER(TABLE_NAME) = 'GTEMPPROCESSTABLE'
				AND Upper(COLUMN_NAME) in ('TEMPREGPREFIX');
			  EXCEPTION
				WHEN NO_DATA_FOUND THEN 
					v_logStatus := LogSkip(51);	
					EXECUTE IMMEDIATE 'ALTER TABLE GTempProcessTable ADD (TEMPREGPREFIX 	NVarchar2(20), 
					TEMPREGSUFFIX NVarchar2(20), TEMPREQSEQLENGTH 	Int)';
					DBMS_OUTPUT.PUT_LINE ('Table GTempProcessTable altered successfully');
			END;
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(51);   
			raise_application_error(-20251,v_scriptName ||' BLOCK 51 FAILED');
	END;
	v_logStatus := LogUpdate(51);

		
			
		

	v_logStatus := LogInsert(52,'Adding new column COMMENTFONT,COMMENTFORECOLOR,COMMENTBACKCOLOR,COMMENTBORDERSTYLE in PROCESSDEFCOMMENTTABLE');
	BEGIN
		BEGIN
			 existsFlag := 0;
			BEGIN
				SELECT 1 INTO existsFlag
				FROM USER_TAB_COLUMNS
				WHERE UPPER(TABLE_NAME) = 'PROCESSDEFCOMMENTTABLE'
				AND Upper(COLUMN_NAME) in ('COMMENTFONT');
			  EXCEPTION
				WHEN NO_DATA_FOUND THEN 
				v_logStatus := LogSkip(52);
			  EXECUTE IMMEDIATE 'ALTER TABLE PROCESSDEFCOMMENTTABLE ADD (COMMENTFONT NVARCHAR2(255), COMMENTFORECOLOR INT,
			  COMMENTBACKCOLOR INT, COMMENTBORDERSTYLE INT)';
			  DBMS_OUTPUT.PUT_LINE ('Table PROCESSDEFCOMMENTTABLE altered successfully');
			END;
			
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(52);   
			raise_application_error(-20252,v_scriptName ||' BLOCK 52 FAILED');
	END;
	v_logStatus := LogUpdate(52);

	v_logStatus := LogInsert(53,'Adding new column COMMENTFONT,COMMENTFORECOLOR,COMMENTBACKCOLOR,COMMENTBORDERSTYLE in PROCESSDEFCOMMENTTABLE');
	BEGIN
		BEGIN
			 existsFlag := 0;
			BEGIN
				SELECT 1 INTO existsFlag
				FROM USER_TAB_COLUMNS
				WHERE UPPER(TABLE_NAME) = 'PROCESSDEFCOMMENTTABLE'
				AND Upper(COLUMN_NAME) in ('COMMENTFONT');
			  EXCEPTION
				WHEN NO_DATA_FOUND THEN 
				v_logStatus := LogSkip(53);
			  EXECUTE IMMEDIATE 'ALTER TABLE PROCESSDEFCOMMENTTABLE ADD (COMMENTFONT NVARCHAR2(255), COMMENTFORECOLOR INT,
			  COMMENTBACKCOLOR INT, COMMENTBORDERSTYLE INT)';
			  DBMS_OUTPUT.PUT_LINE ('Table PROCESSDEFCOMMENTTABLE altered successfully');
			END;
			
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(53);   
			raise_application_error(-20253,v_scriptName ||' BLOCK 53 FAILED');
	END;
	v_logStatus := LogUpdate(53);		
		

	v_logStatus := LogInsert(54,'Adding new column SORTORDER in QUEUEDEFTABLE');
	BEGIN
		BEGIN
			 existsFlag := 0;
			BEGIN
				SELECT 1 INTO existsFlag
				FROM USER_TAB_COLUMNS
				WHERE UPPER(TABLE_NAME) = 'QUEUEDEFTABLE'
				AND Upper(COLUMN_NAME) = 'SORTORDER';
			  EXCEPTION
				WHEN NO_DATA_FOUND THEN 
				v_logStatus := LogSkip(54);
			  EXECUTE IMMEDIATE 'ALTER TABLE QUEUEDEFTABLE ADD (SORTORDER NVARCHAR2(1))';
			  DBMS_OUTPUT.PUT_LINE ('Table QUEUEDEFTABLE altered successfully');
			END;
			
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(54);   
			raise_application_error(-20254,v_scriptName ||' BLOCK 54 FAILED');
	END;
	v_logStatus := LogUpdate(54);

		
		

	v_logStatus := LogInsert(55,'Adding new column ALIASRULE in VARALIASTABLE');
	BEGIN
		BEGIN
			 existsFlag := 0;
			BEGIN
				SELECT 1 INTO existsFlag
				FROM USER_TAB_COLUMNS
				WHERE UPPER(TABLE_NAME) = 'VARALIASTABLE'
				AND Upper(COLUMN_NAME) = 'ALIASRULE';
			  EXCEPTION
				WHEN NO_DATA_FOUND THEN 
				v_logStatus := LogSkip(55);
			  EXECUTE IMMEDIATE 'ALTER TABLE VARALIASTABLE ADD (ALIASRULE NVARCHAR2(2000))';
			  DBMS_OUTPUT.PUT_LINE ('Table VARALIASTABLE altered successfully');
			END;
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(55);   
			raise_application_error(-20255,v_scriptName ||' BLOCK 55 FAILED');
	END;
	v_logStatus := LogUpdate(55);

			
		

	v_logStatus := LogInsert(56,'CREATE TABLE WFQueueColorTable');
	BEGIN
		BEGIN 
			SELECT 1 INTO existsFlag 
			FROM USER_TABLES  
			WHERE TABLE_NAME = UPPER('WFQueueColorTable');
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
				v_logStatus := LogSkip(56);
				EXECUTE IMMEDIATE 
				'CREATE TABLE WFQueueColorTable(
					Id              INT     		NOT NULL		PRIMARY KEY,
					QueueId 		INT             NOT NULL,
					FieldName 		NVARCHAR2(50)   NULL,
					Operator 		INT             NULL,
					CompareValue	NVARCHAR2(255)  NULL,
					Color			NVARCHAR2(10)   NULL
				)';
			DBMS_OUTPUT.PUT_LINE ('Table WFQueueColorTable Created successfully');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(56);   
			raise_application_error(-20256,v_scriptName ||' BLOCK 56 FAILED');
	END;
	v_logStatus := LogUpdate(56);

			
		

	v_logStatus := LogInsert(57,'CREATE TABLE WFAuthorizeQueueColorTable');
	BEGIN
		
		BEGIN 
			SELECT 1 INTO existsFlag 
			FROM USER_TABLES  
			WHERE TABLE_NAME = UPPER('WFAuthorizeQueueColorTable');
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
				v_logStatus := LogSkip(57);
				EXECUTE IMMEDIATE 
				'CREATE TABLE WFAuthorizeQueueColorTable(
					AuthorizationId INT         	NOT NULL,
					ActionId 		INT             NOT NULL,
					FieldName 		NVARCHAR2(50)   NULL,
					Operator 		INT             NULL,
					CompareValue	NVARCHAR2(255)	NULL,
					Color			NVARCHAR2(10)   NULL
				)';
			DBMS_OUTPUT.PUT_LINE ('Table WFAuthorizeQueueColorTable Created successfully');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(57);   
			raise_application_error(-20257,v_scriptName ||' BLOCK 57 FAILED');
	END;
	v_logStatus := LogUpdate(57);

		

	v_logStatus := LogInsert(58,'Adding new column SwimLaneTextColor,SwimLaneText,SWIMLANETYPE in WFSwimLaneTable');
	BEGIN
			BEGIN 
			v_logStatus := LogSkip(58);
			
			IF (checkIFColExist('WFSwimLaneTable','SWIMLANETYPE'))
			THEN
				EXECUTE IMMEDIATE 'ALTER TABLE WFSwimLaneTable MODIFY (SWIMLANETYPE NVARCHAR2(1) DEFAULT (''H''))';
			ELSE
				EXECUTE IMMEDIATE 'ALTER TABLE WFSwimLaneTable Add (SWIMLANETYPE NVARCHAR2(1) DEFAULT (''H''))';			
				EXECUTE IMMEDIATE Q'{UPDATE WFSwimLaneTable SET SWIMLANETYPE=N'H'  WHERE SWIMLANETYPE IS NULL}';
				DBMS_OUTPUT.PUT_LINE ('Table WFSwimLaneTable add col  SWIMLANETYPE ROWCOUNT:'||SQL%ROWCOUNT);
				COMMIT;
			
			END IF;
			
			IF (checkIFColExist('WFSwimLaneTable','SwimLaneText'))
			THEN
				EXECUTE IMMEDIATE 'ALTER TABLE WFSwimLaneTable MODIFY (SwimLaneText  NVARCHAR2(255)  DEFAULT (''HORIZONTAL LANE''))';
			ELSE
				EXECUTE IMMEDIATE 'ALTER TABLE WFSwimLaneTable Add (SwimLaneText  NVARCHAR2(255)  DEFAULT (''HORIZONTAL LANE''))';
				EXECUTE IMMEDIATE Q'{UPDATE WFSwimLaneTable SET SwimLaneText= N'HORIZONTAL LANE' WHERE SwimLaneText IS NULL}';
				DBMS_OUTPUT.PUT_LINE ('Table WFSwimLaneTable add col  SwimLaneText ROWCOUNT:'||SQL%ROWCOUNT);
				COMMIT;
			END IF;
			
			IF (checkIFColExist('WFSwimLaneTable','SwimLaneTextColor'))
			THEN
				EXECUTE IMMEDIATE 'ALTER TABLE WFSwimLaneTable MODIFY (SwimLaneTextColor  INTEGER DEFAULT (-16777216))';
			ELSE
				EXECUTE IMMEDIATE 'ALTER TABLE WFSwimLaneTable Add (SwimLaneTextColor  INTEGER DEFAULT (-16777216))';
				EXECUTE IMMEDIATE Q'{UPDATE WFSwimLaneTable SET SwimLaneTextColor = -16777216 WHERE SwimLaneTextColor IS NULL}';
				DBMS_OUTPUT.PUT_LINE ('Table WFSwimLaneTable add col  SwimLaneTextColor ROWCOUNT:'||SQL%ROWCOUNT);
				COMMIT;
			
			END IF;
			
			
			
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(58);   
			raise_application_error(-20258,v_scriptName ||' BLOCK 58 FAILED');
	END;
	v_logStatus := LogUpdate(58);

		
		

	v_logStatus := LogInsert(59,'Adding new column EXTMETHODINDEX,ALIGNMENT in WFDataMapTable');
	BEGIN
		
			BEGIN 
			v_logStatus := LogSkip(59);
			
			IF (checkIFColExist('WFDataMapTable','EXTMETHODINDEX'))
			THEN
				EXECUTE IMMEDIATE 'ALTER TABLE WFDataMapTable MODIFY (EXTMETHODINDEX  INTEGER)';
			ELSE
				EXECUTE IMMEDIATE 'ALTER TABLE WFDataMapTable Add (EXTMETHODINDEX  INTEGER )';
			END IF;
			
			IF (checkIFColExist('WFDataMapTable','ALIGNMENT'))
			THEN
				EXECUTE IMMEDIATE 'ALTER TABLE WFDataMapTable MODIFY (ALIGNMENT  NVARCHAR2(5))';
			ELSE
				EXECUTE IMMEDIATE 'ALTER TABLE WFDataMapTable Add (ALIGNMENT  NVARCHAR2(5) )';
			END IF;
			
			
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(59);   
			raise_application_error(-20259,v_scriptName ||' BLOCK 59 FAILED');
	END;
	v_logStatus := LogUpdate(59);

		

	v_logStatus := LogInsert(60,'Adding new column SortOrder in WFAuthorizeQueueDefTable');
	BEGIN
		--chitvan old
		BEGIN 
			existsFlag := 0;
			BEGIN
				SELECT 1 INTO existsFlag
				FROM USER_TAB_COLUMNS
				WHERE UPPER(TABLE_NAME) = UPPER('WFAuthorizeQueueDefTable')
				AND Upper(COLUMN_NAME) = 'SORTORDER';
			  EXCEPTION
				WHEN NO_DATA_FOUND THEN 
					v_logStatus := LogSkip(60);
					EXECUTE IMMEDIATE 'ALTER TABLE WFAuthorizeQueueDefTable ADD (SortOrder NVARCHAR2(1))';
					DBMS_OUTPUT.PUT_LINE ('Table WFAuthorizeQueueDefTable altered successfully');
			END;
		END;
		
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(60);   
			raise_application_error(-20260,v_scriptName ||' BLOCK 60 FAILED');
	END;
	v_logStatus := LogUpdate(60);

		
		

	v_logStatus := LogInsert(61,'Adding new column UserId,UserName,ReleasedByUserId,ReleasedDateTime,TransportedByUserId,TransportedDateTime in WFTransportDataTable');
	BEGIN
		--old
		BEGIN 
			existsFlag := 0;
			BEGIN
				SELECT 1 INTO existsFlag
				FROM USER_TAB_COLUMNS
				WHERE UPPER(TABLE_NAME) = UPPER('WFTransportDataTable')
				AND Upper(COLUMN_NAME) in  ('USERID');
			  EXCEPTION
				WHEN NO_DATA_FOUND THEN 
					v_logStatus := LogSkip(61);
					EXECUTE IMMEDIATE 'ALTER TABLE WFTransportDataTable ADD (UserId  INT NOT NULL)';
					DBMS_OUTPUT.PUT_LINE ('Table WFTransportDataTable altered successfully');
					EXECUTE IMMEDIATE 'ALTER TABLE WFTransportDataTable ADD (UserName  NVARCHAR2(64) NOT NULL)';
					DBMS_OUTPUT.PUT_LINE ('Table WFTransportDataTable altered successfully');
					EXECUTE IMMEDIATE 'ALTER TABLE WFTransportDataTable ADD (ReleasedByUserId INT)';
					DBMS_OUTPUT.PUT_LINE ('Table WFTransportDataTable altered successfully');
					EXECUTE IMMEDIATE 'ALTER TABLE WFTransportDataTable ADD (ReleasedDateTime DATE)';
					DBMS_OUTPUT.PUT_LINE ('Table WFTransportDataTable altered successfully');
					EXECUTE IMMEDIATE 'ALTER TABLE WFTransportDataTable ADD (TransportedByUserId INT)';
					DBMS_OUTPUT.PUT_LINE ('Table WFTransportDataTable altered successfully');
					EXECUTE IMMEDIATE 'ALTER TABLE WFTransportDataTable ADD (TransportedDateTime DATE)';
					DBMS_OUTPUT.PUT_LINE ('Table WFTransportDataTable altered successfully');
			END;
		END;

	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(61);   
			raise_application_error(-20261,v_scriptName ||' BLOCK 61 FAILED');
	END;
	v_logStatus := LogUpdate(61);

		
		
	v_logStatus := LogInsert(62,'CREATE TABLE WFTMSSetVariableMapping');
	BEGIN
		BEGIN 
			existsFlag := 0;
			BEGIN
				SELECT 1 INTO existsFlag
				FROM USER_TABLES
				WHERE UPPER(TABLE_NAME) = UPPER('WFTMSSetVariableMapping');
			  EXCEPTION
				WHEN NO_DATA_FOUND THEN
					v_logStatus := LogSkip(62);
					EXECUTE IMMEDIATE 'CREATE TABLE WFTMSSetVariableMapping(
					RequestId           NVARCHAR2(64)     NOT NULL,    
					ProcessDefId        INT,        
					ProcessName         NVARCHAR2(64),
					RightFlag           NVARCHAR2(64),
					ToReturn            NVARCHAR2(1),
					Alias               NVARCHAR2(64),
					QueueId             INT,
					QueueName           NVARCHAR2(64),
					Param1              NVARCHAR2(64),
					Param1Type           INT,    
					Type1               NVARCHAR2(1),
					AliasRule		    NVARCHAR2(2000)
				)';
					DBMS_OUTPUT.PUT_LINE ('Table WFTMSSetVariableMapping created successfully');
			END;
		END;

	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(62);   
			raise_application_error(-20262,v_scriptName ||' BLOCK 62 FAILED');
	END;
	v_logStatus := LogUpdate(62);

		
		
	v_logStatus := LogInsert(63,'Adding new column ALIASRULE in WFTMSSetVariableMapping');
	BEGIN
		BEGIN 
			existsFlag := 0;
			BEGIN
				SELECT 1 INTO existsFlag
				FROM USER_TAB_COLUMNS
				WHERE UPPER(TABLE_NAME) = UPPER('WFTMSSetVariableMapping')
				AND Upper(COLUMN_NAME) = 'ALIASRULE';
			  EXCEPTION
				WHEN NO_DATA_FOUND THEN 
					v_logStatus := LogSkip(63);
					EXECUTE IMMEDIATE 'ALTER TABLE WFTMSSetVariableMapping ADD (AliasRule NVARCHAR2(2000))';
					DBMS_OUTPUT.PUT_LINE ('Table WFTMSSetVariableMapping altered successfully');
			END;
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(63);   
			raise_application_error(-20263,v_scriptName ||' BLOCK 63 FAILED');
	END;
	v_logStatus := LogUpdate(63);

			
		

	v_logStatus := LogInsert(64,'Renaming column TargetCabinetName to TargetEngineName in TransportRegisterationInfo and renaming table TransportRegisterationInfo TO WFTransportRegisterationInfo');
	BEGIN
		BEGIN 
			existsFlag := 0;
			BEGIN
				SELECT 1 INTO existsFlag
				FROM USER_TAB_COLUMNS
				WHERE UPPER(TABLE_NAME) = UPPER('TransportRegisterationInfo')
				AND Upper(COLUMN_NAME) = 'TARGETCABINETNAME';
			  EXCEPTION
				WHEN NO_DATA_FOUND THEN 
					existsFlag := 0; 
				IF existsFlag = 1 THEN
					v_logStatus := LogSkip(64);
					EXECUTE IMMEDIATE 'alter table TransportRegisterationInfo rename column TargetCabinetName to TargetEngineName';
					DBMS_OUTPUT.PUT_LINE ('Table TransportRegisterationInfo altered successfully,column TargetCabinetName renamed');
					EXECUTE IMMEDIATE 'RENAME TransportRegisterationInfo TO WFTransportRegisterationInfo';
					DBMS_OUTPUT.PUT_LINE ('Table TransportRegisterationInfo renamed');
				END IF;
			END;
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(64);   
			raise_application_error(-20264,v_scriptName ||' BLOCK 64 FAILED');
	END;
	v_logStatus := LogUpdate(64);

			
		

	v_logStatus := LogInsert(65,'CREATE TABLE WFSystemServicesTable');
	BEGIN
		BEGIN 
			SELECT 1 INTO existsFlag 
			FROM USER_TABLES  
			WHERE TABLE_NAME = UPPER('WFSystemServicesTable');
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
				v_logStatus := LogSkip(65);
				EXECUTE IMMEDIATE 
				'CREATE TABLE WFSystemServicesTable (
					ServiceId  			INT 				PRIMARY KEY,
					PSID 				INT					NULL, 
					ServiceName  		NVARCHAR2(50)		NULL, 
					ServiceType  		NVARCHAR2(50)		NULL, 
					ProcessDefId 		INT					NULL, 
					EnableLog  			NVARCHAR2(50)		NULL, 
					MonitorStatus 		NVARCHAR2(50)		NULL, 
					SleepTime  			INT					NULL, 
					DateFormat  		NVARCHAR2(50)		NULL, 
					UserName  			NVARCHAR2(50)		NULL, 
					Password  			NVARCHAR2(200)		NULL, 
					RegInfo   			NVARCHAR2(2000)		NULL
				)';
			DBMS_OUTPUT.PUT_LINE ('Table WFSystemServicesTable Created successfully');
		END;

	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(65);   
			raise_application_error(-20265,v_scriptName ||' BLOCK 65 FAILED');
	END;
	v_logStatus := LogUpdate(65);

			
		
	v_logStatus := LogInsert(66,'CREATE SEQUENCE SEQ_QueueColorId');
	BEGIN
		BEGIN
			SELECT LAST_NUMBER INTO v_lastSeqValue
			FROM USER_SEQUENCES
			WHERE SEQUENCE_NAME = UPPER('SEQ_QueueColorId');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_logStatus := LogSkip(66);
				EXECUTE IMMEDIATE 'CREATE SEQUENCE SEQ_QueueColorId INCREMENT BY 1 START WITH 1';
				dbms_output.put_line ('SEQUENCE SEQ_QueueColorId Successfully Created');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(66);   
			raise_application_error(-20266,v_scriptName ||' BLOCK 66 FAILED');
	END;
	v_logStatus := LogUpdate(66);

			
		

	v_logStatus := LogInsert(67,'create table WFUserWebServerInfoTable');
	BEGIN
		
			BEGIN 
			SELECT 1 INTO existsFlag 
			FROM USER_TABLES  
			WHERE TABLE_NAME = UPPER('WFUserWebServerInfoTable');
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
				v_logStatus := LogSkip(67);
				EXECUTE IMMEDIATE 
				'create table WFUserWebServerInfoTable(
				UserId             INT,
				UserName        nvarchar2(26),
				WebServerInfo    nvarchar2(26)
				)';
			DBMS_OUTPUT.PUT_LINE ('Table WFUserWebServerInfoTable Created successfully');
		END;

	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(67);   
			raise_application_error(-20267,v_scriptName ||' BLOCK 67 FAILED');
	END;
	v_logStatus := LogUpdate(67);

		
	v_logStatus := LogInsert(68,'Creating SEQUENCE Seq_ServiceId');
	BEGIN
			
		BEGIN
			SELECT LAST_NUMBER INTO v_lastSeqValue
			FROM USER_SEQUENCES
			WHERE SEQUENCE_NAME = UPPER('Seq_ServiceId');
		   EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_logStatus := LogSkip(68);
				EXECUTE IMMEDIATE 'CREATE SEQUENCE Seq_ServiceId INCREMENT BY 1 START WITH 1';
				dbms_output.put_line ('SEQUENCE Seq_ServiceId Successfully Created');
		END;

	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(68);   
			raise_application_error(-20268,v_scriptName ||' BLOCK 68 FAILED');
	END;
	v_logStatus := LogUpdate(68);

		
	v_logStatus := LogInsert(69,'Creating SEQUENCE TMSLOGID');
	BEGIN
		BEGIN
			SELECT LAST_NUMBER INTO v_lastSeqValue
			FROM USER_SEQUENCES
			WHERE SEQUENCE_NAME = UPPER('TMSLOGID');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_logStatus := LogSkip(69);
				EXECUTE IMMEDIATE 'CREATE SEQUENCE TMSLOGID INCREMENT BY 1 START WITH 1 ';
				dbms_output.put_line ('SEQUENCE TMSLOGID Successfully Created');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(69);   
			raise_application_error(-20269,v_scriptName ||' BLOCK 69 FAILED');
	END;
	v_logStatus := LogUpdate(69);

		
		

	v_logStatus := LogInsert(70,'Creating Trigger WF_TMS_LOGID_TRIGGER');
	BEGIN
		
		BEGIN 
			v_logStatus := LogSkip(70);
			EXECUTE IMMEDIATE 'CREATE OR REPLACE TRIGGER WF_TMS_LOGID_TRIGGER BEFORE INSERT ON WFTRANSPORTDATATABLE FOR EACH ROW BEGIN 	
			SELECT 	TMSLogId.NEXTVAL INTO :NEW.TMSLogId FROM dual; 	END;';
			DBMS_OUTPUT.PUT_LINE ('Trigger WF_TMS_LOGID_TRIGGER created');		
		END;

	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(70);   
			raise_application_error(-20270,v_scriptName ||' BLOCK 70 FAILED');
	END;
	v_logStatus := LogUpdate(70);

		
	v_logStatus := LogInsert(71,'Creating Trigger WF_QUEUE_COLOR_TRIGGER');
	BEGIN
			v_logStatus := LogSkip(71);
			BEGIN 	
					EXECUTE IMMEDIATE 'CREATE OR REPLACE TRIGGER WF_QUEUE_COLOR_TRIGGER BEFORE INSERT ON WFQueueColorTable 	FOR EACH ROW BEGIN 		
					SELECT SEQ_QueueColorId.NEXTVAL INTO :NEW.Id FROM dual; END;';
					DBMS_OUTPUT.PUT_LINE ('Trigger WF_QUEUE_COLOR_TRIGGER created');
			
			END;
		
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(71);   
			raise_application_error(-20271,v_scriptName ||' BLOCK 71 FAILED');
	END;
	v_logStatus := LogUpdate(71);

		

	v_logStatus := LogInsert(72,'Creating VIEW WFUSERVIEW');
	BEGIN
		BEGIN
			v_logStatus := LogSkip(72);
			v_STR1 := q'{CREATE OR REPLACE VIEW WFUSERVIEW ( USERINDEX, USERNAME, PERSONALNAME, FAMILYNAME, CREATEDDATETIME, 
						  EXPIRYDATETIME, PRIVILEGECONTROLLIST, PASSWORD, ACCOUNT, 
						  COMMNT, DELETEDDATETIME, USERALIVE, MAINGROUPID, 
						  MAILID, FAX, NOTECOLOR, SUPERIOR, SUPERIORFLAG  ) 
						AS 
						SELECT  USERINDEX,TO_NChar(RTRIM(USERNAME)) as USERNAME,PERSONALNAME,FAMILYNAME,
						CREATEDDATETIME, EXPIRYDATETIME,PRIVILEGECONTROLLIST,
						PASSWORD,ACCOUNT,COMMNT,DELETEDDATETIME,USERALIVE,
						MAINGROUPID,MAILID,FAX,NOTECOLOR, SUPERIOR, SUPERIORFLAG 
						FROM PDBUSER  WHERE DELETEDFLAG = 'N'}';
				
			EXECUTE IMMEDIATE v_STR1;		
			DBMS_OUTPUT.PUT_LINE ('VIEW WFUSERVIEW Created');
		
		END;

	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(72);   
			raise_application_error(-20272,v_scriptName ||' BLOCK 72 FAILED');
	END;
	v_logStatus := LogUpdate(72);

		
		
	v_logStatus := LogInsert(73,'Adding new column ProcessName in QUEUEDEFTABLE');
	BEGIN
		
		BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('QueueDefTable') 
			AND 
			COLUMN_NAME=UPPER('ProcessName')
			AND DATA_LENGTH >= 60;
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_logStatus := LogSkip(73);
				EXECUTE IMMEDIATE 'ALTER TABLE "QUEUEDEFTABLE" ADD "PROCESSNAME" NVARCHAR2(30) ';
				DBMS_OUTPUT.PUT_LINE('Table QueueDefTable altered with new Column ProcessName');
		END;

	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(73);   
			raise_application_error(-20273,v_scriptName ||' BLOCK 73 FAILED');
	END;
	v_logStatus := LogUpdate(73);


	v_logStatus := LogInsert(74,'Adding new column TEMPPROCESSNAME in GTEMPQUEUETABLE');
	BEGIN
		
			BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('GTEMPQUEUETABLE') 
			AND 
			COLUMN_NAME=UPPER('TEMPPROCESSNAME');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_logStatus := LogSkip(74);
				EXECUTE IMMEDIATE 'ALTER TABLE "GTEMPQUEUETABLE" ADD "TEMPPROCESSNAME" NVARCHAR2(30) ';
				DBMS_OUTPUT.PUT_LINE('Table QueueDefTable altered with new Column ProcessName');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(74);   
			raise_application_error(-20274,v_scriptName ||' BLOCK 74 FAILED');
	END;
	v_logStatus := LogUpdate(74);

		
			

	v_logStatus := LogInsert(75,'Adding new column TEMPREGPREFIX,TEMPREGSUFFIX,TEMPREQSEQLENGTH in GTEMPPROCESSTABLE');
	BEGIN
		
			BEGIN 
			existsFlag := 0;
			BEGIN
				SELECT 1 INTO existsFlag
				FROM USER_TAB_COLUMNS
				WHERE UPPER(TABLE_NAME) = 'GTEMPPROCESSTABLE'
				AND Upper(COLUMN_NAME) in ('TEMPREGPREFIX');
			  EXCEPTION
				WHEN NO_DATA_FOUND THEN 
					v_logStatus := LogSkip(75);
					EXECUTE IMMEDIATE 'ALTER TABLE GTempProcessTable ADD (TEMPREGPREFIX 	NVarchar2(20), 
					TEMPREGSUFFIX NVarchar2(20), TEMPREQSEQLENGTH 	Int)';
					DBMS_OUTPUT.PUT_LINE ('Table GTempProcessTable altered successfully');
			END;
		END;
		
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(75);   
			raise_application_error(-20275,v_scriptName ||' BLOCK 75 FAILED');
	END;
	v_logStatus := LogUpdate(75);

		

	v_logStatus := LogInsert(76,'Adding new column VAR_REC_1,VAR_REC_2,VAR_REC_3,VAR_REC_4,VAR_REC_5 in GTempWorkListTable');
	BEGIN
		
		BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('GTempWorkListTable') 
			AND 
			COLUMN_NAME=UPPER('VAR_REC_1');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_logStatus := LogSkip(76);
				EXECUTE IMMEDIATE 'ALTER TABLE GTempWorkListTable ADD (VAR_REC_1 NVARCHAR2(255), VAR_REC_2 NVARCHAR2(255),VAR_REC_3 NVARCHAR2(255),VAR_REC_4 NVARCHAR2(255),VAR_REC_5 NVARCHAR2(255))';
				DBMS_OUTPUT.PUT_LINE('Table GTempWorkListTable altered with new Columns ');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(76);   
			raise_application_error(-20276,v_scriptName ||' BLOCK 76 FAILED');
	END;
	v_logStatus := LogUpdate(76);



	v_logStatus := LogInsert(77,'Adding new columns VARIABLEID1 in VARALIASTABLE,And Updating VARALIASTABLE');
	BEGIN
		
		BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('VarAliasTable') 
			AND 
			COLUMN_NAME=UPPER('VariableId1');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_logStatus := LogSkip(77);
				EXECUTE IMMEDIATE 'ALTER TABLE VARALIASTABLE ADD VARIABLEID1 INT DEFAULT 0 ';
				DBMS_OUTPUT.PUT_LINE('Table VarAliasTable altered with new Column VariableId1');
				
				DECLARE CURSOR cursor1 IS SELECT DISTINCT PARAM1, VariableId, VariableType, B.ProcessDefId FROM VARMAPPINGTABLE  A, VARALIASTABLE B WHERE UPPER(A.SYSTEMDEFINEDNAME) = UPPER(B.PARAM1);
				BEGIN					
				OPEN cursor1;
				EXECUTE IMMEDIATE 'CREATE INDEX TEMPIDX1_VarAliasTable ON VarAliasTable (Param1)';	
				LOOP
					FETCH cursor1 INTO v_param1, v_VariableId, v_variableType, v_ProcessdefId;
					EXIT WHEN cursor1%NOTFOUND;			
					BEGIN
					IF UPPER(TRIM(v_param1)) = 'ACTIVITYNAME' THEN
						v_VariableId := 3;
					ELSIF UPPER(TRIM(v_param1)) = 'CHECKLISTCOMPLETEFLAG' THEN
						v_VariableId := 7;
					ELSIF UPPER(TRIM(v_param1)) = 'CREATEDDATETIME' THEN
						v_VariableId := 18;
					ELSIF UPPER(TRIM(v_param1)) = 'ENTRYDATETIME' THEN
						v_VariableId := 10;
					ELSIF UPPER(TRIM(v_param1)) = 'EXPECTEDWORKITEMDELAY' THEN
						v_VariableId := 19;
					ELSIF UPPER(TRIM(v_param1)) = 'INSTRUMENTSTATUS' THEN
						v_VariableId := 6;
					ELSIF UPPER(TRIM(v_param1)) = 'INTRODUCEDBY' THEN
						v_VariableId := 5;
					ELSIF UPPER(TRIM(v_param1)) = 'INTRODUCTIONDATETIME' THEN
						v_VariableId := 13;
					ELSIF UPPER(TRIM(v_param1)) = 'LOCKEDBYNAME' THEN
						v_VariableId := 4;
					ELSIF UPPER(TRIM(v_param1)) = 'LOCKEDTIME' THEN
						v_VariableId := 12;
					ELSIF UPPER(TRIM(v_param1)) = 'LOCKSTATUS' THEN
						v_VariableId := 8;
					ELSIF UPPER(TRIM(v_param1)) = 'PRIORITYLEVEL' THEN
						v_VariableId := 1;
					ELSIF UPPER(TRIM(v_param1)) = 'QUEUENAME' THEN
						v_VariableId := 14;
					ELSIF UPPER(TRIM(v_param1)) = 'STATUS' THEN
						v_VariableId := 17;
					ELSIF UPPER(TRIM(v_param1)) = 'VALIDTILL' THEN
						v_VariableId := 11;
					ELSE
						v_VariableId := v_VariableId + 100;
					END IF;
					v_STR1 := ' Update VarAliasTable Set VariableId1 = ' || v_VariableId || ' , Type1 = ' || v_variableType || ' Where UPPER(Param1) = ''' || UPPER(TO_CHAR(v_param1)) || ''' AND ProcessdefId = ' || v_ProcessdefId;
					SAVEPOINT exttable_alias;
						EXECUTE IMMEDIATE v_STR1;			
					END;
					COMMIT;
				END LOOP;
				EXECUTE IMMEDIATE 'DROP INDEX TEMPIDX1_VarAliasTable';			
				CLOSE cursor1;			
				END;			
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(77);   
			raise_application_error(-20277,v_scriptName ||' BLOCK 77 FAILED');
	END;
	v_logStatus := LogUpdate(77);



	v_logStatus := LogInsert(78,'Recreating table VARALIASTABLE');
	BEGIN
		
		dropTableIfExist('VARALIASTABLE2');

		BEGIN
				
				BEGIN
					SELECT 1 INTO existsFlag 
					FROM USER_TAB_COLUMNS
					WHERE TABLE_NAME=UPPER('VARALIASTABLE') 
					AND COLUMN_NAME=UPPER('TYPE1')
					AND	DATA_TYPE=UPPER('NVARCHAR2')
					AND DATA_LENGTH >= 4;
					
					DBMS_OUTPUT.PUT_LINE ('Table VARALIASTABLE2 Already has coloum type1 of datatype NVARCHAR2 >=4');		
						
				EXCEPTION
					WHEN NO_DATA_FOUND THEN

						BEGIN
							v_logStatus := LogSkip(78);
							EXECUTE IMMEDIATE 'CREATE TABLE VARALIASTABLE2 (
							Id			INT		NOT NULL , 
							Alias			NVARCHAR2 (63) 	NOT NULL ,
							ToReturn		NVARCHAR2 (1) 	NOT NULL	CHECK (ToReturn = N''Y'' OR ToReturn = N''N''),
							Param1  		NVARCHAR2(50)  	NOT NULL ,
							Type1  			NVARCHAR2(4)   	NULL ,
							Param2 			NVARCHAR2(255)  NULL ,
							Type2 			NVARCHAR2(1)   	NULL		CHECK (Type2=N''V'' OR Type2=N''C''),
							Operator 		SMALLINT   	NULL ,
							QueueId			INT		NOT NULL,
							ProcessDefId	INT DEFAULT 0 NOT NULL,
							AliasRule       NVARCHAR2(2000)     NULL,
							VariableId1		INT	DEFAULT 0 NOT NULL,	
							CONSTRAINT Pk_VarAlias2 PRIMARY KEY (QueueId,Alias,ProcessDefId)
						  )'; 
							DBMS_OUTPUT.PUT_LINE ('Table VARALIASTABLE2 Successfully Created');			
							/*EXECUTE IMMEDIATE 'INSERT INTO VARALIASTABLE2(Id,Alias,ToReturn,Param1,Type1,Param2,Type2,Operator,QueueId,ProcessDefId,AliasRule,VariableId1) SELECT Id,Alias,ToReturn,Param1,Type1,Param2,Type2,Operator,QueueId,ProcessDefId,AliasRule,VariableId1 FROM VARALIASTABLE';*/ 
							
							EXECUTE IMMEDIATE 'INSERT INTO VARALIASTABLE2(Id,Alias,ToReturn,Param1,Type1 ,Param2 ,Type2 ,Operator ,QueueId,ProcessDefId,AliasRule,VariableId1	) SELECT Id,Alias,ToReturn,Param1,Type1 ,Param2 ,Type2 ,Operator ,QueueId,ProcessDefId,AliasRule,VariableId1	 FROM VARALIASTABLE';
							EXECUTE IMMEDIATE 'RENAME VARALIASTABLE TO VARALIASTABLE_Patch6'; 
							EXECUTE IMMEDIATE 'RENAME VARALIASTABLE2 TO VARALIASTABLE';
							EXECUTE IMMEDIATE 'DROP TABLE VARALIASTABLE_Patch6';
							EXECUTE IMMEDIATE 'ALTER TABLE VARALIASTABLE DROP CONSTRAINT Pk_VarAlias2';
							EXECUTE IMMEDIATE 'ALTER TABLE VARALIASTABLE ADD CONSTRAINT PK_VarAlias PRIMARY KEY (QueueId,Alias,ProcessDefId)';
							--SAVEPOINT save;
							--COMMIT;
							
						
						EXCEPTION
							WHEN OTHERS THEN
								BEGIN
									SELECT 1 INTO  existsFlag
									FROM USER_TABLES WHERE TABLE_NAME= 'VARALIASTABLE2';
									
									DBMS_OUTPUT.PUT_LINE (' DROPPING VARALIASTABLE2 In Exception Block ');
									
									EXECUTE IMMEDIATE Q'{DROP TABLE VARALIASTABLE2 CASCADE CONSTRAINTS}'; 
									
									DBMS_OUTPUT.PUT_LINE (' DROPPED TABLE  VARALIASTABLE2 In Exception Block ');
								EXCEPTION
									WHEN NO_DATA_FOUND THEN
										DBMS_OUTPUT.PUT_LINE (' VARALIASTABLE2 Already dropped ');	
								
								END;
							
							ROLLBACK;
							
							RAISE;	
								
						END;
				END;				
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(78);   
			raise_application_error(-20278,v_scriptName ||' BLOCK 78 FAILED');
	END;
	v_logStatus := LogUpdate(78);

		
		

	v_logStatus := LogInsert(79,'Adding new columns ConfigurationID,RFCHostName,ConfigurationName in WFSAPCONNECTTABLE');
	BEGIN
			
			BEGIN
				v_logStatus := LogSkip(79);
				
				IF (checkIFColExist('WFSAPCONNECTTABLE','CONFIGURATIONID'))
				THEN
					EXECUTE IMMEDIATE 'ALTER TABLE WFSAPCONNECTTABLE MODIFY (ConfigurationID INTEGER)';
				ELSE
					EXECUTE IMMEDIATE 'ALTER TABLE WFSAPCONNECTTABLE Add (ConfigurationID INTEGER)';
				
				END IF;
				
				IF (checkIFColExist('WFSAPCONNECTTABLE','RFCHostName'))
				THEN
					EXECUTE IMMEDIATE 'ALTER TABLE WFSAPCONNECTTABLE MODIFY (RFCHostName NVARCHAR2(64))';
				ELSE
					EXECUTE IMMEDIATE 'ALTER TABLE WFSAPCONNECTTABLE Add (RFCHostName NVARCHAR2(64))';
				
				END IF;
				
				IF (checkIFColExist('WFSAPCONNECTTABLE','ConfigurationName'))
				THEN
					EXECUTE IMMEDIATE 'ALTER TABLE WFSAPCONNECTTABLE MODIFY (ConfigurationName NVARCHAR2(64))';
				ELSE
					EXECUTE IMMEDIATE 'ALTER TABLE WFSAPCONNECTTABLE Add (ConfigurationName NVARCHAR2(64))';
				
				END IF;
		
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(79);   
			raise_application_error(-20279,v_scriptName ||' BLOCK 79 FAILED');
	END;
	v_logStatus := LogUpdate(79);

		

	v_logStatus := LogInsert(80,'Adding new column ConfigurationID in WFSAPGUIASSOCTABLE');
	BEGIN
		
			BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE Upper(TABLE_NAME) = 'WFSAPGUIASSOCTABLE'
			AND Upper(COLUMN_NAME) = 'CONFIGURATIONID';
			
			EXECUTE IMMEDIATE 'ALTER TABLE WFSAPGUIAssocTable MODIFY ConfigurationID INTEGER';
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_logStatus := LogSkip(80);
				EXECUTE IMMEDIATE 'ALTER TABLE WFSAPGUIAssocTable Add ConfigurationID INTEGER';
				DBMS_OUTPUT.PUT_LINE('Table WFSAPGUIAssocTable altered with new Column ConfigurationID');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(80);   
			raise_application_error(-20280,v_scriptName ||' BLOCK 80 FAILED');
	END;
	v_logStatus := LogUpdate(80);




	v_logStatus := LogInsert(81,'Adding new column ConfigurationID in WFSAPGUIASSOCTABLE');
	BEGIN
		
		BEGIN
			v_logStatus := LogSkip(81);
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE Upper(TABLE_NAME) = 'WFSAPADAPTERASSOCTABLE'
			AND Upper(COLUMN_NAME) = 'CONFIGURATIONID';
			
			EXECUTE IMMEDIATE 'ALTER TABLE WFSAPadapterAssocTable MODIFY ConfigurationID INTEGER';
			
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				EXECUTE IMMEDIATE 'ALTER TABLE WFSAPadapterAssocTable Add ConfigurationID INTEGER';
				DBMS_OUTPUT.PUT_LINE('Table WFSAPadapterAssocTable altered with new Column ConfigurationID');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(81);   
			raise_application_error(-20281,v_scriptName ||' BLOCK 81 FAILED');
	END;
	v_logStatus := LogUpdate(81);



	v_logStatus := LogInsert(82,'Adding new column ConfigurationID in EXTMETHODDEFTABLE');
	BEGIN
			BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE Upper(TABLE_NAME) = 'EXTMETHODDEFTABLE'
			AND Upper(COLUMN_NAME) = 'CONFIGURATIONID';
			
			EXECUTE IMMEDIATE 'ALTER TABLE ExtMethodDefTable MODIFY ConfigurationID INTEGER';
			
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_logStatus := LogSkip(82);
				EXECUTE IMMEDIATE 'ALTER TABLE ExtMethodDefTable Add ConfigurationID INTEGER';
				DBMS_OUTPUT.PUT_LINE('Table ExtMethodDefTable altered with new Column ConfigurationID');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(82);   
			raise_application_error(-20282,v_scriptName ||' BLOCK 82 FAILED');
	END;
	v_logStatus := LogUpdate(82);


		


	v_logStatus := LogInsert(83,'Updating WFSAPConnectTable');
	BEGIN
		
			BEGIN
			SELECT CabVersion INTO v_cabVersion FROM WFCABVERSIONTABLE WHERE CabVersion = '9.0_SAP_CONFIGURATION' AND ROWNUM <= 1;
		EXCEPTION 
		WHEN NO_DATA_FOUND THEN
			v_logStatus := LogSkip(83);
			BEGIN
				DECLARE CURSOR cursor1 IS SELECT ProcessDefId FROM WFSAPConnectTable;
				BEGIN 
				EXECUTE IMMEDIATE 'Update WFSAPConnectTable Set RFCHostName = SAPHostName, ConfigurationName = ''DEFAULT''';			
				OPEN cursor1;
				v_ConfigurationId := 0;
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
		END;

	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(83);   
			raise_application_error(-20283,v_scriptName ||' BLOCK 83 FAILED');
	END;
	v_logStatus := LogUpdate(83);


	v_logStatus := LogInsert(84,'CREATE TABLE WFUnderlyingDMS');
	BEGIN
		
		/* Tables added for Sharepoint integration*/
			BEGIN 
				SELECT 1 INTO existsFlag 
				FROM USER_TABLES  
				WHERE TABLE_NAME = UPPER('WFUnderlyingDMS');
			EXCEPTION 
				WHEN NO_DATA_FOUND THEN 
					v_logStatus := LogSkip(84);
					EXECUTE IMMEDIATE 
					'CREATE TABLE WFUnderlyingDMS (
						DMSType		INT				NOT NULL,
						DMSName		NVARCHAR2(255)	NULL
					)';
				DBMS_OUTPUT.PUT_LINE ('Table WFUnderlyingDMS Created successfully');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(84);   
			raise_application_error(-20284,v_scriptName ||' BLOCK 84 FAILED');
	END;
	v_logStatus := LogUpdate(84);

		

	v_logStatus := LogInsert(85,'CREATE TABLE WFSharePointInfo');
	BEGIN
		
			BEGIN 
				SELECT 1 INTO existsFlag 
				FROM USER_TABLES  
				WHERE TABLE_NAME = UPPER('WFSharePointInfo');
			EXCEPTION 
				WHEN NO_DATA_FOUND THEN 
					v_logStatus := LogSkip(85);
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
				DBMS_OUTPUT.PUT_LINE ('Table WFSharePointInfo Created successfully');
		END;

	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(85);   
			raise_application_error(-20285,v_scriptName ||' BLOCK 85 FAILED');
	END;
	v_logStatus := LogUpdate(85);

		
	v_logStatus := LogInsert(86,'CREATE TABLE WFDMSLibrary');
	BEGIN
		
			BEGIN 
				SELECT 1 INTO existsFlag 
				FROM USER_TABLES  
				WHERE TABLE_NAME = UPPER('WFDMSLibrary');
			EXCEPTION 
				WHEN NO_DATA_FOUND THEN 
					v_logStatus := LogSkip(86);
					EXECUTE IMMEDIATE 
					'CREATE TABLE WFDMSLibrary (
						LibraryId			INT				NOT NULL 	PRIMARY KEY,
						URL			NVARCHAR2(255)	NULL,
						DocumentLibrary		NVARCHAR2(255)	NULL
					)';
				DBMS_OUTPUT.PUT_LINE ('Table WFDMSLibrary Created successfully');
		END;

	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(86);   
			raise_application_error(-20286,v_scriptName ||' BLOCK 86 FAILED');
	END;
	v_logStatus := LogUpdate(86);

		
	v_logStatus := LogInsert(87,'CREATE TABLE WFProcessSharePointAssoc');
	BEGIN
		
			BEGIN 
				SELECT 1 INTO existsFlag 
				FROM USER_TABLES  
				WHERE TABLE_NAME = UPPER('WFProcessSharePointAssoc');
			EXCEPTION 
				WHEN NO_DATA_FOUND THEN 
					v_logStatus := LogSkip(87);
					EXECUTE IMMEDIATE 
					'CREATE TABLE WFProcessSharePointAssoc (
						ProcessDefId			INT		NOT NULL,
						LibraryId				INT		NULL,
						PRIMARY KEY (ProcessDefId)
					)';
				DBMS_OUTPUT.PUT_LINE ('Table WFProcessSharePointAssoc Created successfully');
		END;

	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(87);   
			raise_application_error(-20287,v_scriptName ||' BLOCK 87 FAILED');
	END;
	v_logStatus := LogUpdate(87);

		
	v_logStatus := LogInsert(88,'CREATE TABLE WFArchiveInSharePoint');
	BEGIN
		
		
			BEGIN 
				SELECT 1 INTO existsFlag 
				FROM USER_TABLES  
				WHERE TABLE_NAME = UPPER('WFArchiveInSharePoint');
			EXCEPTION 
				WHEN NO_DATA_FOUND THEN 
					v_logStatus := LogSkip(88);
					EXECUTE IMMEDIATE 
					'CREATE TABLE WFArchiveInSharePoint (
						ProcessDefId			INT				NULL,
						ActivityID				INT				NULL,
						URL					 	NVARCHAR2(255)	NULL,		
						SiteName				NVARCHAR2(255)	NULL,
						DocumentLibrary			NVARCHAR2(255)	NULL,
						FolderName				NVARCHAR2(255)	NULL,
						ServiceURL 				NVARCHAR2(255) 	NULL
					)';
					EXECUTE IMMEDIATE('Insert into QueueDefTable (QueueId, QueueName, QueueType, Comments, OrderBy, SortOrder)
	values (QUEUEID.nextval, ''SystemSharepointQueue'', ''S'', ''System generated common Sharepoint Queue'', 10, ''A'')');
				DBMS_OUTPUT.PUT_LINE ('Table WFArchiveInSharePoint Created successfully');
		END;

	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(88);   
			raise_application_error(-20288,v_scriptName ||' BLOCK 88 FAILED');
	END;
	v_logStatus := LogUpdate(88);

	v_logStatus := LogInsert(89,'CREATE TABLE WFAUDITTRAILDOCTABLE');
	BEGIN

	 BEGIN 
			SELECT 1 INTO existsFlag 
			FROM USER_TABLES  
			WHERE TABLE_NAME = UPPER('wfaudittraildoctable');
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
			v_logStatus := LogSkip(89);
				EXECUTE IMMEDIATE 
				'CREATE TABLE WFAUDITTRAILDOCTABLE(
				PROCESSDEFID			INT NOT NULL,
				PROCESSINSTANCEID		NVARCHAR2(63)  NOT NULL ,
				WORKITEMID				INT NOT NULL,
				ACTIVITYID				INT NOT NULL,
				DOCID					INT NOT NULL,
				PARENTFOLDERINDEX		INT NOT NULL,
				VOLID					INT NOT NULL,
				APPSERVERIP				NVARCHAR2(63) NOT NULL,
				APPSERVERPORT			INT NOT NULL,
				APPSERVERTYPE			NVARCHAR2(63) NULL,
				ENGINENAME				NVARCHAR2(63) NOT NULL,
				DELETEAUDIT				NVARCHAR2(1) default ''N'' ,
				STATUS					CHAR(1)	NOT NULL,
				LOCKEDBY				NVARCHAR2(63)	NULL,
				PRIMARY KEY (PROCESSINSTANCEID, WORKITEMID)
			)';
			DBMS_OUTPUT.PUT_LINE ('Table WFAUDITTRAILDOCTABLE Created successfully');
		END;
			
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(89);   
			raise_application_error(-20289,v_scriptName ||' BLOCK 89 FAILED');
	END;
	v_logStatus := LogUpdate(89);



	v_logStatus := LogInsert(90,'CREATE TABLE WFSharePointDataMapTable');
	BEGIN
		
			BEGIN 
				SELECT 1 INTO existsFlag 
				FROM USER_TABLES  
				WHERE TABLE_NAME = UPPER('WFSharePointDataMapTable');
			EXCEPTION 
				WHEN NO_DATA_FOUND THEN 
				v_logStatus := LogSkip(90);
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
				DBMS_OUTPUT.PUT_LINE ('Table WFSharePointDataMapTable Created successfully');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(90);   
			raise_application_error(-20290,v_scriptName ||' BLOCK 90 FAILED');
	END;
	v_logStatus := LogUpdate(90);

		

	v_logStatus := LogInsert(91,'CREATE TABLE WFSharePointDocAssocTable');
	BEGIN
		
			BEGIN 
				SELECT 1 INTO existsFlag 
				FROM USER_TABLES  
				WHERE TABLE_NAME = UPPER('WFSharePointDocAssocTable');
			EXCEPTION 
				WHEN NO_DATA_FOUND THEN 
				v_logStatus := LogSkip(91);
					EXECUTE IMMEDIATE 
					'CREATE TABLE WFSharePointDocAssocTable (
						ProcessDefId			INT				NULL,
						ActivityID				INT				NULL,
						DocTypeID				INT				NULL,
						AssocFieldName			NVARCHAR2(255)	NULL
					)';
				DBMS_OUTPUT.PUT_LINE ('Table WFSharePointDocAssocTable Created successfully');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(91);   
			raise_application_error(-20291,v_scriptName ||' BLOCK 91 FAILED');
	END;
	v_logStatus := LogUpdate(91);




	v_logStatus := LogInsert(92,'CREATE SEQUENCE LibraryId');
	BEGIN
		
		BEGIN
			SELECT LAST_NUMBER INTO v_lastSeqValue
			FROM USER_SEQUENCES
			WHERE SEQUENCE_NAME = UPPER('LibraryId');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_logStatus := LogSkip(92);
				EXECUTE IMMEDIATE 'CREATE SEQUENCE LibraryId INCREMENT BY 1 START WITH 1 NOCACHE';
				dbms_output.put_line ('SEQUENCE LibraryId Successfully Created');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(92);   
			raise_application_error(-20292,v_scriptName ||' BLOCK 92 FAILED');
	END;
	v_logStatus := LogUpdate(92);

		

	v_logStatus := LogInsert(93,'Adding new column DOMAINNAME in WFDMSLIBRARY,WFARCHIVEINSHAREPOINT');
	BEGIN	
			BEGIN
				v_logStatus := LogSkip(93);
				
				DBMS_OUTPUT.PUT_LINE('Table WFDMSLIBRARY and  WFARCHIVEINSHAREPOINT altering with new Column DOMAINNAME ...');
				IF (checkIFColExist('WFDMSLIBRARY','DOMAINNAME'))
				THEN
					EXECUTE IMMEDIATE 'ALTER TABLE WFDMSLIBRARY MODIFY (DOMAINNAME NVARCHAR2(64))';
				ELSE
					EXECUTE IMMEDIATE 'ALTER TABLE WFDMSLIBRARY Add DOMAINNAME NVARCHAR2(64)';
				
				END IF;
				
				IF (checkIFColExist('WFARCHIVEINSHAREPOINT','DOMAINNAME'))
				THEN
					EXECUTE IMMEDIATE 'ALTER TABLE WFARCHIVEINSHAREPOINT MODIFY (DOMAINNAME NVARCHAR2(64))';
				ELSE
					EXECUTE IMMEDIATE 'ALTER TABLE WFARCHIVEINSHAREPOINT Add DOMAINNAME NVARCHAR2(64)';
				
				END IF;

				
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(93);   
			raise_application_error(-20293,v_scriptName ||' BLOCK 93 FAILED');
	END;
	v_logStatus := LogUpdate(93);

		

	v_logStatus := LogInsert(94,'CREATING TRIGGER WF_LIB_ID_TRIGGER BEFORE INSERT ON WFDMSLIBRARY');
	BEGIN
		
		BEGIN	
					v_logStatus := LogSkip(94);
					EXECUTE IMMEDIATE 'CREATE OR REPLACE TRIGGER WF_LIB_ID_TRIGGER BEFORE INSERT ON WFDMSLIBRARY FOR EACH ROW BEGIN 	
					SELECT LibraryId.NEXTVAL INTO :NEW.LibraryId FROM dual; END;';
					DBMS_OUTPUT.PUT_LINE ('Trigger WF_LIB_ID_TRIGGER created');
		END;

	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(94);   
			raise_application_error(-20294,v_scriptName ||' BLOCK 94 FAILED');
	END;
	v_logStatus := LogUpdate(94);

		
	v_logStatus := LogInsert(95,'Create Table WFCreateChildWITable');
	BEGIN
					
		BEGIN 
			SELECT 1 INTO existsFlag FROM USER_TABLES  
			WHERE TABLE_NAME = UPPER('WFCreateChildWITable');
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
			v_logStatus := LogSkip(95);
			BEGIN
				EXECUTE IMMEDIATE 
				'Create Table WFCreateChildWITable(
						ProcessDefId		INT NOT NULL,
						TriggerId			INT NOT NULL,
						WorkstepName		NVARCHAR2(255), 
						Type		NVARCHAR2(1), 
						GenerateSameParent	NVARCHAR2(1), 
						VariableId			INT, 
						VarFieldId			INT,
						PRIMARY KEY (Processdefid , TriggerID)
				)';
				DBMS_OUTPUT.PUT_LINE ('Table WFCreateChildWITable created successfully');

				BEGIN
					DECLARE CURSOR cursor1 IS SELECT ProcessDefId FROM PROCESSDEFTABLE;
					BEGIN		
						OPEN cursor1;
						LOOP
							FETCH cursor1 INTO v_ProcessDefId;
							EXIT WHEN cursor1%NOTFOUND;
							BEGIN 
							SELECT ExtMethodIndex INTO v_extMethodIndex FROM EXTMETHODDEFTABLE WHERE processdefid=v_ProcessDefId AND ExtMethodIndex=34;
							EXCEPTION 
							WHEN NO_DATA_FOUND THEN
							BEGIN
							v_STR1 := ' INSERT INTO EXTMETHODDEFTABLE VALUES(' || v_ProcessDefId || ', 34 , N''System'', N''S'', N''deleteChildWorkitem'' , NULL, NULL, 3 , NULL,NULL)';
							SAVEPOINT del_extmethod;
								EXECUTE IMMEDIATE v_STR1;
							END;
							END;
							COMMIT;

						END LOOP;
						CLOSE cursor1;
					END;		
				END;
			END;
		END; 
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(95);   
			raise_application_error(-20295,v_scriptName ||' BLOCK 95 FAILED');
	END;
	v_logStatus := LogUpdate(95);



	v_logStatus := LogInsert(96,'BLOCK 96');
	BEGIN
		
		BEGIN
			v_logStatus := LogSkip(96);
			v_queryStr :='select TABLENAME from WFEXPORTTABLE ';
		  
			ExportCur := dbms_sql.open_cursor;  
		  
			DBMS_SQL.PARSE(ExportCur,TO_CHAR(v_queryStr),DBMS_SQL.NATIVE);
		  
			DBMS_SQL.DEFINE_COLUMN(ExportCur, 1 , v_tableName,138);

			v_retval := dbms_sql.EXECUTE(ExportCur); 

			v_DBStatus := DBMS_SQL.fetch_rows(ExportCur);
		  
			WHILE (v_DBStatus <> 0) LOOP
			BEGIN
				EXISTSFLAG := 0 ;
				DBMS_SQL.column_value(ExportCur,1,v_tableName);
				queryStr:='Select 1 from USER_TAB_COLUMNS WHERE UPPER(TABLE_NAME) = UPPER('||chr(39)||v_tableName||chr(39)||') AND UPPER(COLUMN_NAME) = ''SEQUENCENUMBER''';
				EXECUTE IMMEDIATE queryStr;
				EXISTSFLAG := 1 ;
				EXCEPTION 
				WHEN NO_DATA_FOUND THEN 
					EXISTSFLAG := 0; 
			END;
			IF EXISTSFLAG = 1 THEN
			   queryStr := 'ALTER TABLE ' || v_tableName || ' ADD SEQUENCENUMBER NVARCHAR2(100)' ;
			   EXECUTE IMMEDIATE queryStr;
			END IF;
			v_DBStatus := DBMS_SQL.fetch_rows(ExportCur);
			END LOOP;  
			COMMIT;
			DBMS_SQL.CLOSE_CURSOR(ExportCur);
			EXCEPTION 
			WHEN OTHERS THEN 
			IF (DBMS_SQL.IS_OPEN(ExportCur)) THEN 
			   DBMS_SQL.CLOSE_CURSOR(ExportCur);  
			END IF;
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(96);   
			raise_application_error(-20296,v_scriptName ||' BLOCK 96 FAILED');
	END;
	v_logStatus := LogUpdate(96);

		

	v_logStatus := LogInsert(97,'Adding new columns FieldSeperator,FileType,FilePath,HeaderString,FooterString,SleepTime,MaskedValue in WFExportTable');
	BEGIN
		
			BEGIN
				v_logStatus := LogSkip(97);
				DBMS_OUTPUT.PUT_LINE('Table WFExportTable altering with new Columns FieldSeperator, FileType, FilePath, HeaderString, FooterString, SleepTime, MaskedValue');
		
				IF (checkIFColExist('WFExportTable','FieldSeperator'))
				THEN
					EXECUTE IMMEDIATE 'ALTER TABLE WFExportTable MODIFY (FieldSeperator NVARCHAR2(5))';
				ELSE
					EXECUTE IMMEDIATE 'ALTER TABLE WFExportTable Add (FieldSeperator NVARCHAR2(5))';
				
				END IF;
				
				IF (checkIFColExist('WFExportTable','FileType'))
				THEN
					EXECUTE IMMEDIATE 'ALTER TABLE WFExportTable MODIFY (FileType INTEGER)';
				ELSE
					EXECUTE IMMEDIATE 'ALTER TABLE WFExportTable Add (FileType INTEGER)';
				
				END IF;
				
				IF (checkIFColExist('WFExportTable','FilePath'))
				THEN
					EXECUTE IMMEDIATE 'ALTER TABLE WFExportTable MODIFY (FilePath NVARCHAR2(255))';
				ELSE
					EXECUTE IMMEDIATE 'ALTER TABLE WFExportTable Add (FilePath NVARCHAR2(255))';
				
				END IF;
				
				IF (checkIFColExist('WFExportTable','HeaderString'))
				THEN
					EXECUTE IMMEDIATE 'ALTER TABLE WFExportTable MODIFY (HeaderString NVARCHAR2(255))';
				ELSE
					EXECUTE IMMEDIATE 'ALTER TABLE WFExportTable Add (HeaderString NVARCHAR2(255))';			
				END IF;
				
				
				IF (checkIFColExist('WFExportTable','FooterString'))
				THEN
					EXECUTE IMMEDIATE 'ALTER TABLE WFExportTable MODIFY (FooterString NVARCHAR2(255))';
				ELSE
					EXECUTE IMMEDIATE 'ALTER TABLE WFExportTable Add (FooterString NVARCHAR2(255))';			
				END IF;
				
				IF (checkIFColExist('WFExportTable','SleepTime'))
				THEN
					EXECUTE IMMEDIATE 'ALTER TABLE WFExportTable MODIFY (SleepTime INTEGER)';
				ELSE
					EXECUTE IMMEDIATE 'ALTER TABLE WFExportTable Add (SleepTime INTEGER)';			
				END IF;
				
				IF (checkIFColExist('WFExportTable','MaskedValue'))
				THEN
					EXECUTE IMMEDIATE 'ALTER TABLE WFExportTable MODIFY (MaskedValue NVARCHAR2(255))';
				ELSE
					EXECUTE IMMEDIATE 'ALTER TABLE WFExportTable Add (MaskedValue NVARCHAR2(255))';			
				END IF;
		
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(97);   
			raise_application_error(-20297,v_scriptName ||' BLOCK 97 FAILED');
	END;
	v_logStatus := LogUpdate(97);

		

	v_logStatus := LogInsert(98,'Adding new column EXPORTALLDOCS in WFDATAMAPTABLE');
	BEGIN
		
		BEGIN
			v_logStatus := LogSkip(98);
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE Upper(TABLE_NAME) = 'WFDATAMAPTABLE'
			AND Upper(COLUMN_NAME) = 'EXPORTALLDOCS';
			
			EXECUTE IMMEDIATE 'ALTER TABLE WFDATAMAPTABLE MODIFY EXPORTALLDOCS NVARCHAR2(2) DEFAULT 0';
			
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				EXECUTE IMMEDIATE 'ALTER TABLE WFDATAMAPTABLE ADD EXPORTALLDOCS NVARCHAR2(2) DEFAULT 0';
				EXECUTE IMMEDIATE 'UPDATE WFDATAMAPTABLE SET EXPORTALLDOCS = 0 WHERE EXPORTALLDOCS IS NULL';
				DBMS_OUTPUT.PUT_LINE('Table WFDATAMAPTABLE altered with new Columns EXPORTALLDOCS ROWCOUNT:'||SQL%ROWCOUNT);
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(98);   
			raise_application_error(-20298,v_scriptName ||' BLOCK 98 FAILED');
	END;
	v_logStatus := LogUpdate(98);

		

	v_logStatus := LogInsert(99,'Adding new column ARCHIVEDATACLASSNAME in ARCHIVETABLE');
	BEGIN
		
		BEGIN
			v_logStatus := LogSkip(99);
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE Upper(TABLE_NAME) = 'ARCHIVETABLE'
			AND Upper(COLUMN_NAME) = 'ARCHIVEDATACLASSNAME';
			
			EXECUTE IMMEDIATE 'ALTER TABLE ARCHIVETABLE MODIFY ARCHIVEDATACLASSNAME NVARCHAR2(255)';
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				EXECUTE IMMEDIATE 'ALTER TABLE ARCHIVETABLE Add ARCHIVEDATACLASSNAME NVARCHAR2(255)';
				DBMS_OUTPUT.PUT_LINE('Table WFSAPadapterAssocTable altered with new Column ARCHIVEDATACLASSNAME');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(99);   
			raise_application_error(-20299,v_scriptName ||' BLOCK 99 FAILED');
	END;
	v_logStatus := LogUpdate(99);

		

	v_logStatus := LogInsert(100,'Adding new column DATAFIELDTYPE in ARCHIVEDATAMAPTABLE');
	BEGIN
		
		BEGIN
			v_logStatus := LogSkip(100);
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE Upper(TABLE_NAME) = 'ARCHIVEDATAMAPTABLE'
			AND Upper(COLUMN_NAME) = 'DATAFIELDTYPE';
			 EXECUTE IMMEDIATE 'ALTER TABLE ARCHIVEDATAMAPTABLE MODIFY DATAFIELDTYPE INTEGER';
			
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				EXECUTE IMMEDIATE 'ALTER TABLE ARCHIVEDATAMAPTABLE Add DATAFIELDTYPE INTEGER';
				DBMS_OUTPUT.PUT_LINE('Table ARCHIVEDATAMAPTABLE altered with new Column DATAFIELDTYPE');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(100);   
			raise_application_error(-20300,v_scriptName ||' BLOCK 100 FAILED');
	END;
	v_logStatus := LogUpdate(100);

		

	v_logStatus := LogInsert(101,'Adding new column SORTINGCOLUMN in EXTDBCONFTABLE');
	BEGIN
			existsFlag := 0; 
		BEGIN
			v_logStatus := LogSkip(101);
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME='EXTDBCONFTABLE'
			AND 
			COLUMN_NAME=UPPER('SORTINGCOLUMN');
			
			EXECUTE IMMEDIATE 'ALTER TABLE EXTDBCONFTABLE MODIFY SORTINGCOLUMN NVARCHAR2(255)';
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				EXECUTE IMMEDIATE 'ALTER TABLE EXTDBCONFTABLE ADD SORTINGCOLUMN NVARCHAR2(255)';
				DBMS_OUTPUT.PUT_LINE('Table EXTDBCONFTABLE altered with new Columns ');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(101);   
			raise_application_error(-20301,v_scriptName ||' BLOCK 101 FAILED');
	END;
	v_logStatus := LogUpdate(101);

		
		

	v_logStatus := LogInsert(102,'Updating extdbconftable table');
	BEGIN
			BEGIN
			  v_logStatus := LogSkip(102);
			  v_DBStatus := 0;
			  v_queryStr :='select Processdefid,ExtObjId from varmappingtable where extobjid>0 and unbounded=''Y'' ';
			  ProcessCur := dbms_sql.open_cursor;  
			  
			  DBMS_SQL.PARSE(ProcessCur,TO_CHAR(v_queryStr),DBMS_SQL.NATIVE);
			  
			  DBMS_SQL.DEFINE_COLUMN(ProcessCur, 1 , v_ProcessDefId);
			  DBMS_SQL.DEFINE_COLUMN(ProcessCur, 2 , v_ExtObjID); 

			  v_retval := dbms_sql.EXECUTE(ProcessCur); 

			  v_DBStatus := DBMS_SQL.fetch_rows(ProcessCur);
			  WHILE (v_DBStatus <> 0) LOOP
				BEGIN
					existsFlag := 0;
					DBMS_SQL.COLUMN_VALUE(ProcessCur, 1, v_ProcessDefId);
					DBMS_SQL.COLUMN_VALUE(ProcessCur, 2, v_ExtObjID);
				BEGIN
					Select TableName INTO v_TableName from extdbconftable where processdefid =v_ProcessDefId and extobjid=v_ExtObjID;
				END;
					SELECT 1 INTO existsFlag  FROM USER_TAB_COLUMNS WHERE TABLE_NAME=UPPER(v_TableName) AND COLUMN_NAME='INSERTIONORDERID';
					EXCEPTION
					WHEN NO_DATA_FOUND THEN
					BEGIN
						EXECUTE IMMEDIATE 'ALTER TABLE '||v_TableName||' ADD INSERTIONORDERID INT';
						v_seqName := 'WFSEQ_ARRAY_'||v_ProcessDefId||'_'||v_ExtObjID;
						SELECT 1 INTO existsFlag  FROM USER_OBJECTS WHERE OBJECT_NAME=UPPER(v_seqName);
						EXCEPTION
							WHEN NO_DATA_FOUND THEN
							BEGIN
								v_queryStr:='CREATE SEQUENCE WFSEQ_ARRAY_'||v_ProcessDefId||'_'||v_ExtObjID||' INCREMENT BY 1 START WITH 1';
								EXECUTE IMMEDIATE v_queryStr;
							END;
							EXECUTE IMMEDIATE 'UPDATE extdbconftable SET SORTINGCOLUMN=''INSERTIONORDERID'' where processdefid ='||v_ProcessDefId||' and extobjid='||v_ExtObjID;
					 END;
				END;   
			  v_DBStatus := DBMS_SQL.fetch_rows(ProcessCur);
			  END LOOP;
			  DBMS_SQL.CLOSE_CURSOR(ProcessCur); 
			  COMMIT;
			  EXCEPTION 
			  WHEN OTHERS THEN 
			  BEGIN
				IF (DBMS_SQL.IS_OPEN(ProcessCur)) THEN 
					DBMS_SQL.CLOSE_CURSOR(ProcessCur);  
				END IF;
			  END;
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(102);   
			raise_application_error(-20302,v_scriptName ||' BLOCK 102 FAILED');
	END;
	v_logStatus := LogUpdate(102);

		
		
	 
	v_logStatus := LogInsert(103,'Adding new column in INSERTIONORDERID in tables and creating sequences');
	BEGIN
		BEGIN
				v_logStatus := LogSkip(103);
			  v_queryStr :='select d.Processdefid, d.extobjid,d.mappedobjectname from varmappingtable a, wftypedesctable b, wftypedeftable c, wfudtvarmappingtable d where a.processdefid= b.processdefid and b.processdefid=c.processdefid and c.processdefid= d.processdefid and c.typeid=b.typeid and c.unbounded=''Y'' and d.typeid= c.parenttypeid and d.mappedobjecttype=''T'' and d.typefieldid= c.typefieldid and a.variableid = d.variableid';
			  ProcessCur := dbms_sql.open_cursor;  
			  DBMS_SQL.PARSE(ProcessCur,TO_CHAR(v_queryStr),DBMS_SQL.NATIVE);
			  DBMS_SQL.DEFINE_COLUMN(ProcessCur, 1 , v_ProcessDefId);
			  DBMS_SQL.DEFINE_COLUMN(ProcessCur, 2 , v_ExtObjID);
			  DBMS_SQL.DEFINE_COLUMN(ProcessCur, 3, v_TableName,255);
			  v_retval := dbms_sql.EXECUTE(ProcessCur); 
			  v_DBStatus := DBMS_SQL.fetch_rows(ProcessCur);
			  WHILE (v_DBStatus <> 0) LOOP
				   BEGIN
					  DBMS_SQL.COLUMN_VALUE(ProcessCur, 1, v_ProcessDefId);
					  DBMS_SQL.COLUMN_VALUE(ProcessCur, 2, v_ExtObjID);
					  DBMS_SQL.COLUMN_VALUE(ProcessCur, 3, v_TableName);
					  SELECT 1 INTO existsFlag  FROM USER_TAB_COLUMNS WHERE TABLE_NAME=UPPER(v_TableName) AND COLUMN_NAME='INSERTIONORDERID';
					  EXCEPTION
					  WHEN NO_DATA_FOUND THEN
					  BEGIN
						  EXECUTE IMMEDIATE 'ALTER TABLE '||v_TableName||' ADD INSERTIONORDERID INT';
						  v_queryStr:='CREATE SEQUENCE WFSEQ_ARRAY_'||v_ProcessDefId||'_'||v_ExtObjID||' INCREMENT BY 1 START WITH 1';
						  EXECUTE IMMEDIATE v_queryStr;
					  END;
					END;   
			  v_DBStatus := DBMS_SQL.fetch_rows(ProcessCur);
			  END LOOP;
			  DBMS_SQL.CLOSE_CURSOR(ProcessCur); 
			  COMMIT;
			  EXCEPTION 
			  WHEN OTHERS THEN 
			BEGIN
				IF (DBMS_SQL.IS_OPEN(ProcessCur)) THEN 
					DBMS_SQL.CLOSE_CURSOR(ProcessCur);  
				END IF;
			END;
		END;	
		
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(103);   
			raise_application_error(-20303,v_scriptName ||' BLOCK 103 FAILED');
	END;
	v_logStatus := LogUpdate(103);

			
		

	v_logStatus := LogInsert(104,'Adding new column FORMAT in TEMPLATEDEFINITIONTABLE');
	BEGIN
			existsFlag := 0; 
		BEGIN
			v_logStatus := LogSkip(104);
			SELECT 1 INTO existsFlag FROM USER_TAB_COLUMNS WHERE Upper(TABLE_NAME) = 'TEMPLATEDEFINITIONTABLE' AND Upper(COLUMN_NAME) = 'FORMAT';
			EXECUTE IMMEDIATE 'ALTER TABLE TEMPLATEDEFINITIONTABLE MODIFY FORMAT NVARCHAR2(10) DEFAULT ''DOC''';
			
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				EXECUTE IMMEDIATE 'ALTER TABLE TEMPLATEDEFINITIONTABLE Add FORMAT NVARCHAR2(10) DEFAULT ''DOC''';
				EXECUTE IMMEDIATE Q'{UPDATE TEMPLATEDEFINITIONTABLE SET FORMAT ='DOC' WHERE FORMAT IS NULL }';
				DBMS_OUTPUT.PUT_LINE('Table TEMPLATEDEFINITIONTABLE altered with new Column FORMAT ROWCOUNT'||SQL%ROWCOUNT);
		END;	
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(104);   
			raise_application_error(-20304,v_scriptName ||' BLOCK 104 FAILED');
	END;
	v_logStatus := LogUpdate(104);

		
		

	v_logStatus := LogInsert(105,'Adding new column mailBCC in WFMAILQUEUETABLE');
	BEGIN
		
		existsFlag := 0; 
		BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('WFMAILQUEUETABLE') 
			AND COLUMN_NAME=UPPER('mailBCC');
			--EXECUTE IMMEDIATE 'ALTER TABLE WFMAILQUEUETABLE MODIFY mailBCC NVARCHAR2(512)';
			
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_logStatus := LogSkip(105);
				EXECUTE IMMEDIATE 'ALTER TABLE WFMAILQUEUETABLE Add mailBCC NVARCHAR2(512)';
				DBMS_OUTPUT.PUT_LINE('Table WFMAILQUEUETABLE altered with new Column mailBCC');
		END;	
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(105);   
			raise_application_error(-20305,v_scriptName ||' BLOCK 105 FAILED');
	END;
	v_logStatus := LogUpdate(105);



	v_logStatus := LogInsert(106,'Modifying Column PSNAME  to NVARCHAR2(200) in PSREGISTERATIONTABLE');
	BEGIN
		
		BEGIN
			v_logStatus := LogSkip(106);
			EXECUTE IMMEDIATE 'Alter table PSREGISTERATIONTABLE MODIFY(PSNAME NVARCHAR2(200))';
			DBMS_OUTPUT.PUT_LINE( 'Table PSREGISTERATIONTABLE altered Column PSNAME');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(106);   
			raise_application_error(-20306,v_scriptName ||' BLOCK 106 FAILED');
	END;
	v_logStatus := LogUpdate(106);

		
		

	v_logStatus := LogInsert(107,'Adding new column DiffFolderLoc in WFArchiveInSharePoint');
	BEGIN
		
			existsFlag := 0; 
		BEGIN
			v_logStatus := LogSkip(107);
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE Upper(TABLE_NAME) = UPPER('WFArchiveInSharePoint')
			AND Upper(COLUMN_NAME) = UPPER('DiffFolderLoc');
			EXECUTE IMMEDIATE 'ALTER TABLE WFArchiveInSharePoint MODIFY DiffFolderLoc NVARCHAR2(2)';
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				EXECUTE IMMEDIATE 'ALTER TABLE WFArchiveInSharePoint Add DiffFolderLoc NVARCHAR2(2)';
				DBMS_OUTPUT.PUT_LINE('Table WFARCHIVEINSHAREPOINT altered with new Columns DiffFolderLoc');
		END;

	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(107);   
			raise_application_error(-20307,v_scriptName ||' BLOCK 107 FAILED');
	END;
	v_logStatus := LogUpdate(107);

		
		
	v_logStatus := LogInsert(108,'Adding new column SameAssignRights in WFArchiveInSharePoint');
	BEGIN
			existsFlag := 0; 
		BEGIN
			v_logStatus := LogSkip(108);
			SELECT 1 INTO existsFlag FROM USER_TAB_COLUMNS
			WHERE Upper(TABLE_NAME) = UPPER('WFArchiveInSharePoint')
			AND Upper(COLUMN_NAME) = UPPER('SameAssignRights');
			EXECUTE IMMEDIATE 'ALTER TABLE WFArchiveInSharePoint MODIFY SameAssignRights NVARCHAR2(2)';
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				EXECUTE IMMEDIATE 'ALTER TABLE WFArchiveInSharePoint Add SameAssignRights NVARCHAR2(2)';
				DBMS_OUTPUT.PUT_LINE('Table WFARCHIVEINSHAREPOINT altered with new Columns SameAssignRights');
		END;

	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(108);   
			raise_application_error(-20308,v_scriptName ||' BLOCK 108 FAILED');
	END;
	v_logStatus := LogUpdate(108);

		
		
	v_logStatus := LogInsert(109,'Adding new column FolderName in WFSharePointDocAssocTable');
	BEGIN
			existsFlag := 0; 
		BEGIN
			v_logStatus := LogSkip(109);
			SELECT 1 INTO existsFlag  FROM USER_TAB_COLUMNS
			WHERE Upper(TABLE_NAME) = UPPER('WFSharePointDocAssocTable')
			AND Upper(COLUMN_NAME) = UPPER('FolderName');
			EXECUTE IMMEDIATE 'ALTER TABLE WFSharePointDocAssocTable MODIFy FolderName NVARCHAR2(255)';
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				EXECUTE IMMEDIATE 'ALTER TABLE WFSharePointDocAssocTable Add FolderName NVARCHAR2(255)';
				DBMS_OUTPUT.PUT_LINE('Table WFSharePointDocAssocTable altered with new Column FolderName');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(109);   
			raise_application_error(-20309,v_scriptName ||' BLOCK 109 FAILED');
	END;
	v_logStatus := LogUpdate(109);

		
		

	v_logStatus := LogInsert(110,'CREATE TABLE WFLASTREMINDERTABLE');
	BEGIN
		
			existsFlag:= 0;
		BEGIN 
			SELECT 1 INTO existsFlag FROM USER_TABLES WHERE TABLE_NAME = UPPER('WFLASTREMINDERTABLE');
			EXCEPTION 
				WHEN NO_DATA_FOUND THEN 
				BEGIN
					v_logStatus := LogSkip(110);
					EXECUTE IMMEDIATE 'CREATE TABLE WFLASTREMINDERTABLE(
										USERID 				INT NOT NULL,
										LASTREMINDERTIME	DATE)';
					DBMS_OUTPUT.PUT_LINE ('Table WFLASTREMINDERTABLE created successfully');
				END;
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(110);   
			raise_application_error(-20310,v_scriptName ||' BLOCK 110 FAILED');
	END;
	v_logStatus := LogUpdate(110);

		

	v_logStatus := LogInsert(111,'Adding new column IsAppletView in WFFORM_TABLE');
	BEGIN
		
			existsFlag := 0; 
		BEGIN
			v_logStatus := LogSkip(111);
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME='WFFORM_TABLE'
			AND 
			COLUMN_NAME=UPPER('ISAPPLETVIEW');
			
			EXECUTE IMMEDIATE q'{ALTER TABLE WFFORM_TABLE MODIFY ISAPPLETVIEW NVARCHAR2(2) DEFAULT 'Y'}';
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				EXECUTE IMMEDIATE q'{ALTER TABLE WFFORM_TABLE ADD ISAPPLETVIEW NVARCHAR2(2) DEFAULT 'Y'}';
				EXECUTE IMMEDIATE q'{UPDATE WFFORM_TABLE SET ISAPPLETVIEW =N'Y' WHERE ISAPPLETVIEW IS NULL}';
				DBMS_OUTPUT.PUT_LINE('Table WFFORM_TABLE altered with new Column IsAppletView ROWCOUNT'||SQL%ROWCOUNT);
				COMMIT;
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(111);   
			raise_application_error(-20311,v_scriptName ||' BLOCK 111 FAILED');
	END;
	v_logStatus := LogUpdate(111);

		

	v_logStatus := LogInsert(112,'Adding new column SecurityFlag in WFWebServiceInfoTable');
	BEGIN
		
			existsFlag := 0; 
		BEGIN
			v_logStatus := LogSkip(112);
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('WFWebServiceInfoTable')
			AND 
			COLUMN_NAME=UPPER('SecurityFlag');
			EXECUTE IMMEDIATE q'{ALTER TABLE WFWebServiceInfoTable MODIFY SECURITYFLAG NVARCHAR2(1) DEFAULT 'Y'}';
			
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				EXECUTE IMMEDIATE q'{ALTER TABLE WFWebServiceInfoTable ADD SECURITYFLAG NVARCHAR2(1) DEFAULT 'Y'}';
				EXECUTE IMMEDIATE q'{UPDATE WFWebServiceInfoTable SET SECURITYFLAG ='Y' WHERE SECURITYFLAG IS NULL}';
				DBMS_OUTPUT.PUT_LINE('Table WFWebServiceInfoTable altered with new Column SecurityFlag ROWCOUNT'||SQL%ROWCOUNT);
				COMMIT;
		END;

	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(112);   
			raise_application_error(-20312,v_scriptName ||' BLOCK 112 FAILED');
	END;
	v_logStatus := LogUpdate(112);


	v_logStatus := LogInsert(113,'Adding new column SecurityFlag in WFSAPConnectTable');
	BEGIN
		
			existsFlag := 0; 
		BEGIN
			v_logStatus := LogSkip(113);
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('WFSAPConnectTable')
			AND 
			COLUMN_NAME=UPPER('SecurityFlag');
			EXECUTE IMMEDIATE 'ALTER TABLE WFSAPConnectTable MODIFY SECURITYFLAG NVARCHAR2(1) DEFAULT ''Y'' ';
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				EXECUTE IMMEDIATE 'ALTER TABLE WFSAPConnectTable ADD SECURITYFLAG NVARCHAR2(1) DEFAULT ''Y'' ';
				DBMS_OUTPUT.PUT_LINE('Table WFSAPConnectTable altered with new Column SecurityFlag ');
		END;
		
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(113);   
			raise_application_error(-20313,v_scriptName ||' BLOCK 113 FAILED');
	END;
	v_logStatus := LogUpdate(113);

		

	v_logStatus := LogInsert(114,'Adding new column Q_DivertedByUserId in worklisttable');
	BEGIN
		
			/* Bug 38828 - NEW field Q_DivertedByUserId added for diversion requirement by Anwar Ali Danish */
		existsFlag := 0;
		BEGIN
			IF v_TableExists = 1
			THEN
				BEGIN
					SELECT 1 INTO existsFlag 
					FROM USER_TAB_COLUMNS
					WHERE TABLE_NAME=UPPER('worklisttable') 
					AND 
					COLUMN_NAME=UPPER('Q_DivertedByUserId');
				EXCEPTION
					WHEN NO_DATA_FOUND THEN
					v_logStatus := LogSkip(114);
						EXECUTE IMMEDIATE 'ALTER TABLE worklisttable Add Q_DivertedByUserId int';
								
				END;
			END iF;
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(114);   
			raise_application_error(-20314,v_scriptName ||' BLOCK 114 FAILED');
	END;
	v_logStatus := LogUpdate(114);

		

	v_logStatus := LogInsert(115,'Adding new column Q_DivertedByUserId in workinprocesstable');
	BEGIN
		
			existsFlag := 0;
		IF v_WIPTableExist = 1
		THEN
			BEGIN
				SELECT 1 INTO existsFlag 
				FROM USER_TAB_COLUMNS
				WHERE TABLE_NAME=UPPER('workinprocesstable') 
				AND 
				COLUMN_NAME=UPPER('Q_DivertedByUserId');
			EXCEPTION
				WHEN NO_DATA_FOUND THEN	
					v_logStatus := LogSkip(115);
					EXECUTE IMMEDIATE 'ALTER TABLE workinprocesstable Add Q_DivertedByUserId int';
					
			END;
		END IF;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(115);   
			raise_application_error(-20315,v_scriptName ||' BLOCK 115 FAILED');
	END;
	v_logStatus := LogUpdate(115);

		

	v_logStatus := LogInsert(116,'Adding new column Q_DivertedByUserId in PENDINGWORKLISTTABLE');
	BEGIN
		
			existsFlag := 0;
		IF v_TableExists = 1
		THEN
			BEGIN
				SELECT 1 INTO existsFlag 
				FROM USER_TAB_COLUMNS
				WHERE TABLE_NAME=UPPER('PENDINGWORKLISTTABLE') 
				AND 
				COLUMN_NAME=UPPER('Q_DivertedByUserId');
			EXCEPTION
				WHEN NO_DATA_FOUND THEN		
					v_logStatus := LogSkip(116);
					EXECUTE IMMEDIATE 'ALTER TABLE PENDINGWORKLISTTABLE Add Q_DivertedByUserId int';
					
			END;
		END IF;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(116);   
			raise_application_error(-20316,v_scriptName ||' BLOCK 116 FAILED');
	END;
	v_logStatus := LogUpdate(116);

		

	v_logStatus := LogInsert(117,'Adding new column Q_DivertedByUserId in WORKDONETABLE');
	BEGIN
		
			existsFlag := 0;
		IF v_TableExists = 1
		THEN
				BEGIN
					SELECT 1 INTO existsFlag 
					FROM USER_TAB_COLUMNS
					WHERE TABLE_NAME=UPPER('WORKDONETABLE') 
					AND 
					COLUMN_NAME=UPPER('Q_DivertedByUserId');
				EXCEPTION
					WHEN NO_DATA_FOUND THEN	
						v_logStatus := LogSkip(117);
						EXECUTE IMMEDIATE 'ALTER TABLE WORKDONETABLE Add Q_DivertedByUserId int';
				END;
		END IF;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(117);   
			raise_application_error(-20317,v_scriptName ||' BLOCK 117 FAILED');
	END;
	v_logStatus := LogUpdate(117);

		
		

	v_logStatus := LogInsert(118,'Adding new column Q_DivertedByUserId in WORKWITHPSTABLE');
	BEGIN
		
			existsFlag := 0;
		IF v_WWPSTableExist = 1
		THEN
			BEGIN
				SELECT 1 INTO existsFlag 
				FROM USER_TAB_COLUMNS
				WHERE TABLE_NAME=UPPER('WORKWITHPSTABLE') 
				AND 
				COLUMN_NAME=UPPER('Q_DivertedByUserId');
			EXCEPTION
				WHEN NO_DATA_FOUND THEN	
					v_logStatus := LogSkip(118);
					EXECUTE IMMEDIATE 'ALTER TABLE WORKWITHPSTABLE Add Q_DivertedByUserId int';
					
			END;
		END IF;

	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(118);   
			raise_application_error(-20318,v_scriptName ||' BLOCK 118 FAILED');
	END;
	v_logStatus := LogUpdate(118);

		
		
	v_logStatus := LogInsert(119,'Adding new column Q_DivertedByUserId in GTEMPWORKLISTTABLE');
	BEGIN
		
			existsFlag := 0;
		BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('GTEMPWORKLISTTABLE') 
			AND 
			COLUMN_NAME=UPPER('Q_DivertedByUserId');
			--EXECUTE IMMEDIATE 'ALTER TABLE GTEMPWORKLISTTABLE MODIFY Q_DivertedByUserId int';
			
		EXCEPTION
			WHEN NO_DATA_FOUND THEN	
				v_logStatus := LogSkip(119);
				EXECUTE IMMEDIATE 'ALTER TABLE GTEMPWORKLISTTABLE Add Q_DivertedByUserId int';
				
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(119);   
			raise_application_error(-20319,v_scriptName ||' BLOCK 119 FAILED');
	END;
	v_logStatus := LogUpdate(119);



	v_logStatus := LogInsert(120,'CREATE TABLE WFFailedServicesTable');
	BEGIN
			BEGIN 
			  SELECT 1 INTO existsFlag 
			  FROM USER_TABLES  
			  WHERE TABLE_NAME = UPPER('WFFailedServicesTable');
			 EXCEPTION 
			  WHEN NO_DATA_FOUND THEN 
			  v_logStatus := LogSkip(120);
			   EXECUTE IMMEDIATE 
			   'CREATE TABLE WFFailedServicesTable(
			 processDefId int NULL,
			 ServiceName varchar(200) NULL,
			 ServiceType varchar(30) NULL,
			 ServiceId varchar(200) NULL,
			 ActionDateTime DATE NULL,
			 ObjectName varchar(100) NULL,
			 ErrorCode int NULL,
			 ErrorMessage varchar(138) NULL,
			 Data_1 int NULL,
			 Data_2 int NULL
			)';
			  DBMS_OUTPUT.PUT_LINE ('Table WFFailedServicesTable Created successfully');
			 END;

	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(120);   
			raise_application_error(-20320,v_scriptName ||' BLOCK 120 FAILED');
	END;
	v_logStatus := LogUpdate(120);

		
		
		
	v_logStatus := LogInsert(121,'DROPPING TR_LOG_PDBCONNECTION TRIGGER ON PDBCONNECTION');
	BEGIN
		
		
		BEGIN  
			BEGIN
				SELECT 1 INTO existsFlag 
				FROM USER_TRIGGERS
				WHERE TRIGGER_NAME='TR_LOG_PDBCONNECTION'
				AND 
				TABLE_NAME='PDBCONNECTION';
			EXCEPTION
				WHEN NO_DATA_FOUND THEN
					 existsFlag := 0;
			END;
			IF existsFlag = 1 THEN
				v_logStatus := LogSkip(121);
				EXECUTE IMMEDIATE 'DROP TRIGGER TR_LOG_PDBCONNECTION';
				DBMS_OUTPUT.PUT_LINE('TR_LOG_PDBCONNECTION TRIGGER ON PDBCONNECTION DROPPED');
			END IF;
		END;

	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(121);   
			raise_application_error(-20321,v_scriptName ||' BLOCK 121 FAILED');
	END;
	v_logStatus := LogUpdate(121);


		
	v_logStatus := LogInsert(122,'CREATE VIEW WFUSERVIEW');
	BEGIN
		
		BEGIN
			
			v_logStatus := LogSkip(122);
			EXECUTE IMMEDIATE 'DROP VIEW WFUSERVIEW';
			EXECUTE IMMEDIATE 'CREATE VIEW WFUSERVIEW AS SELECT USERINDEX,TO_NChar(RTRIM(USERNAME)) as USERNAME,PERSONALNAME,FAMILYNAME,
			CREATEDDATETIME, EXPIRYDATETIME,PRIVILEGECONTROLLIST,
			PASSWORD,ACCOUNT,COMMNT,DELETEDDATETIME,USERALIVE,
			MAINGROUPID,MAILID,FAX,NOTECOLOR, SUPERIOR, SUPERIORFLAG FROM PDBUSER WHERE DELETEDFLAG = ''N''';
		   
		END;	

	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(122);   
			raise_application_error(-20322,v_scriptName ||' BLOCK 122 FAILED');
	END;
	v_logStatus := LogUpdate(122);


	v_logStatus := LogInsert(123,'CREATING TRIGGER WF_USR_DEL AFTER DELETE ON PDBUSER ');
	BEGIN
		
			BEGIN
				IF v_TableExists = 1
					THEN
					v_logStatus := LogSkip(123);
					BEGIN
						EXECUTE IMMEDIATE 'CREATE OR REPLACE TRIGGER WF_USR_DEL
						AFTER DELETE 
						ON PDBUSER 
						FOR EACH ROW
						BEGIN
							Insert into Worklisttable (ProcessInstanceId, WorkItemId, ProcessName, ProcessVersion, ProcessDefID, LastProcessedBy, ProcessedBy, ActivityName, ActivityId, EntryDateTime, ParentWorkItemId, CollectFlag, PriorityLevel, ValidTill, Q_StreamId, Q_QueueId, Q_UserId, AssignedUser, AssignmentType, FilterValue, CreatedDateTime, WorkItemState, Statename, ExpectedWorkitemDelay, PreviousStage, LockStatus, Queuename, Queuetype, Q_DivertedByUserId) Select ProcessInstanceId, WorkItemId, ProcessName, ProcessVersion, ProcessDefID, LastProcessedBy, ProcessedBy, ActivityName, ActivityId, EntryDateTime, ParentWorkItemId, CollectFlag, PriorityLevel, ValidTill, Q_StreamId, Q_QueueId, Q_UserId, AssignedUser, AssignmentType, FilterValue, CreatedDateTime, WorkItemState, Statename, ExpectedWorkitemDelay, PreviousStage, N''N'', Queuename, Queuetype , Q_DivertedByUserId from WorkinProcessTable where Q_UserId = :OLD.UserIndex;
							Delete from WorkInProcessTable where Q_UserId = :OLD.UserIndex;
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
							WHERE Q_UserId = :OLD.UserIndex AND AssignmentType = N''F'';
							UPDATE WORKLISTTABLE 
							SET	AssignedUser = NULL, AssignmentType = NULL, LockStatus = N''N'' ,
								LockedByName = NULL, LockedTime = NULL , Q_UserId = 0 
							WHERE  AssignmentType != N''F'' AND Q_UserId = :OLD.UserIndex;
							DELETE FROM QUEUEUSERTABLE  
								WHERE  UserID = :OLD.UserIndex 
								AND    Associationtype = 0;
							DELETE FROM USERPREFERENCESTABLE 
								WHERE  UserID = :OLD.UserIndex;
							DELETE FROM USERDIVERSIONTABLE 
								WHERE  Diverteduserindex = :OLD.UserIndex 
								OR     AssignedUserindex = :OLD.UserIndex;
							DELETE FROM USERWORKAUDITTABLE 
								WHERE  Userindex = :OLD.UserIndex 
								OR     Auditoruserindex = :OLD.UserIndex;
						END;';
						DBMS_OUTPUT.PUT_LINE ('Trigger WF_TMS_LOGID_TRIGGER created');
					END;
				END IF;
			END;
				
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(123);   
			raise_application_error(-20323,v_scriptName ||' BLOCK 123 FAILED');
	END;
	v_logStatus := LogUpdate(123);

		

	v_logStatus := LogInsert(124,'CREATE TABLE WFMultiLingualTable');
	BEGIN
		
			BEGIN 
			SELECT 1 INTO existsFlag 
			FROM USER_TABLES  
			WHERE TABLE_NAME = UPPER('WFMultiLingualTable');
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
				v_logStatus := LogSkip(124);
				EXECUTE IMMEDIATE 
				'CREATE TABLE WFMultiLingualTable (
					EntityId			INT						NOT NULL,
					EntityType			INT						NOT NULL,
					Locale				NVARCHAR2(20)			NOT NULL,
					EntityName			NVARCHAR2(255)			NOT NULL,
					ProcessDefId		INT						NOT NULL,
					ParentId			INT						NOT NULL,
					FieldName 			NVARCHAR2(1000),
					PRIMARY KEY (EntityId, EntityType, Locale, ProcessDefId, ParentId)
				)';
			DBMS_OUTPUT.PUT_LINE ('Table WFMultiLingualTable Created successfully');
		END;

	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(124);   
			raise_application_error(-20324,v_scriptName ||' BLOCK 124 FAILED');
	END;
	v_logStatus := LogUpdate(124);

		
	v_logStatus := LogInsert(125,'Adding new column ConfigurationID in WFSAPGUIASSOCTABLE');
	BEGIN
		
			existsFlag := 0;
		BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('WFEscalationTable') 
			AND 
			COLUMN_NAME=UPPER('FromId');
			
			--EXECUTE IMMEDIATE 'ALTER TABLE WFEscalationTable MODIFY FromId NVarchar2(256) Default ''OmniFlowSystem_do_not_reply@newgen.co.in''';
			
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_logStatus := LogSkip(125);
				EXECUTE IMMEDIATE 'ALTER TABLE WFEscalationTable Add FromId NVarchar2(256) Default ''OmniFlowSystem_do_not_reply@newgen.co.in''';
				
				EXECUTE IMMEDIATE Q'{UPDATE WFEscalationTable SET FromId ='OmniFlowSystem_do_not_reply@newgen.co.in' WHERE FromId IS NULL}';
				DBMS_OUTPUT.PUT_LINE ('Table WFMultiLingualTable ADD COL FromId ROWCOUNT:'||SQL%ROWCOUNT);
		END;

	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(125);   
			raise_application_error(-20325,v_scriptName ||' BLOCK 125 FAILED');
	END;
	v_logStatus := LogUpdate(125);

		
	v_logStatus := LogInsert(126,'Adding new column CCId in WFEscalationTable');
	BEGIN
		
			existsFlag := 0;
		BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('WFEscalationTable') 
			AND 
			COLUMN_NAME=UPPER('CCId');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN		
				v_logStatus := LogSkip(126);
				EXECUTE IMMEDIATE 'ALTER TABLE WFEscalationTable Add CCId NVarchar2(256)';
				
		END;

	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(126);   
			raise_application_error(-20326,v_scriptName ||' BLOCK 126 FAILED');
	END;
	v_logStatus := LogUpdate(126);

		
	v_logStatus := LogInsert(127,'Adding new column BCCID in WFESCALATIONTABLE');
	BEGIN
		
			/* BUG 42494 */
		existsFlag := 0;
		BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('WFESCALATIONTABLE') 
			AND 
			COLUMN_NAME=UPPER('BCCID');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_logStatus := LogSkip(127);
				EXECUTE IMMEDIATE 'ALTER TABLE WFESCALATIONTABLE Add (BCCID NVARCHAR2(256))';
				DBMS_OUTPUT.PUT_LINE('Table WFESCALATIONTABLE altered with new Column BCCID');
		END;

	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(127);   
			raise_application_error(-20327,v_scriptName ||' BLOCK 127 FAILED');
	END;
	v_logStatus := LogUpdate(127);

		
	v_logStatus := LogInsert(128,'Adding new column FromId in WFEscInProcessTable');
	BEGIN
		
			existsFlag := 0;
		BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('WFEscInProcessTable') 
			AND 
			COLUMN_NAME=UPPER('FromId');
			
			---EXECUTE IMMEDIATE 'ALTER TABLE WFEscInProcessTable MODIFY FromId NVarchar2(256) Default ''OmniFlowSystem_do_not_reply@newgen.co.in''  ';
			
		EXCEPTION
			WHEN NO_DATA_FOUND THEN	
				v_logStatus := LogSkip(128);
				EXECUTE IMMEDIATE 'ALTER TABLE WFEscInProcessTable Add FromId NVarchar2(256) Default ''OmniFlowSystem_do_not_reply@newgen.co.in''  ';
				
				EXECUTE IMMEDIATE Q'{UPDATE WFEscInProcessTable SET FromId ='OmniFlowSystem_do_not_reply@newgen.co.in' WHERE FromId IS NULL }';
				DBMS_OUTPUT.PUT_LINE('Table WFEscInProcessTable altered with new Column FromId ROWCOUNT:'||SQL%ROWCOUNT);
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(128);   
			raise_application_error(-20328,v_scriptName ||' BLOCK 128 FAILED');
	END;
	v_logStatus := LogUpdate(128);

		

	v_logStatus := LogInsert(129,'Adding new column CCId in WFEscInProcessTable');
	BEGIN
		
			existsFlag := 0;
		BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('WFEscInProcessTable') 
			AND 
			COLUMN_NAME=UPPER('CCId');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN	
				v_logStatus := LogSkip(129);
				EXECUTE IMMEDIATE 'ALTER TABLE WFEscInProcessTable Add CCId NVarchar2(256)';
				
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(129);   
			raise_application_error(-20329,v_scriptName ||' BLOCK 129 FAILED');
	END;
	v_logStatus := LogUpdate(129);

		

	v_logStatus := LogInsert(130,'Adding new column BCCID in WFESCINPROCESSTABLE');
	BEGIN
		
			/* BUG 42494 */
		existsFlag := 0;
		BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('WFESCINPROCESSTABLE') 
			AND 
			COLUMN_NAME=UPPER('BCCID');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_logStatus := LogSkip(130);
				EXECUTE IMMEDIATE 'ALTER TABLE WFESCINPROCESSTABLE Add (BCCID NVARCHAR2(256))';
				DBMS_OUTPUT.PUT_LINE('Table WFESCINPROCESSTABLE altered with new Column BCCID');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(130);   
			raise_application_error(-20330,v_scriptName ||' BLOCK 130 FAILED');
	END;
	v_logStatus := LogUpdate(130);

		

	v_logStatus := LogInsert(131,'Adding new column TARGETDOCNAME in WFSHAREPOINTDOCASSOCTABLE');
	BEGIN
		
			BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE Upper(TABLE_NAME) = 'WFSHAREPOINTDOCASSOCTABLE'
			AND Upper(COLUMN_NAME) = 'TARGETDOCNAME';
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_logStatus := LogSkip(131);
				EXECUTE IMMEDIATE 'ALTER TABLE WFSHAREPOINTDOCASSOCTABLE Add TARGETDOCNAME NVARCHAR2(255) NULL';
				DBMS_OUTPUT.PUT_LINE('Table WFSHAREPOINTDOCASSOCTABLE altered with new Column TARGETDOCNAME');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(131);   
			raise_application_error(-20331,v_scriptName ||' BLOCK 131 FAILED');
	END;
	v_logStatus := LogUpdate(131);

		

	v_logStatus := LogInsert(132,'Adding new column ParentId in WFMultiLingualTable');
	BEGIN
		
		
			BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME = UPPER('WFMultiLingualTable')
			AND COLUMN_NAME = UPPER('ParentId');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_logStatus := LogSkip(132);
				EXECUTE IMMEDIATE 'ALTER TABLE WFMultiLingualTable Add ParentId INT DEFAULT 0 ';
				EXECUTE IMMEDIATE 'UPDATE WFMultiLingualTable SET ParentId=0 WHERE ParentId IS NULL ';
				DBMS_OUTPUT.PUT_LINE('Table WFMultiLingualTable altered with new Column ParentId ROWCOUNT'||SQL%ROWCOUNT);
				Commit;
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(132);   
			raise_application_error(-20332,v_scriptName ||' BLOCK 132 FAILED');
	END;
	v_logStatus := LogUpdate(132);

		
		

	v_logStatus := LogInsert(133,'Adding PRIMARY KEY (EntityId, EntityType, Locale, ProcessDefId, ParentId) in WFMultiLingualTable');
	BEGIN
		
		BEGIN
			v_logStatus := LogSkip(133);
			SELECT 1,CONSTRAINT_NAME INTO existsFlag,v_constraintname 
			FROM USER_CONSTRAINTS
			WHERE TABLE_NAME = UPPER('WFMultiLingualTable')
			AND CONSTRAINT_TYPE = 'P';	

			EXECUTE  IMMEDIATE 'Alter Table WFMultiLingualTable Drop Constraint '||TO_CHAR(v_constraintname);
			EXECUTE IMMEDIATE 'ALTER TABLE WFMultiLingualTable Add PRIMARY KEY (EntityId, EntityType, Locale, ProcessDefId, ParentId)';
				DBMS_OUTPUT.PUT_LINE('Table WFMultiLingualTable altered with new Primary Key');
			
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				EXECUTE IMMEDIATE 'ALTER TABLE WFMultiLingualTable Add PRIMARY KEY (EntityId, EntityType, Locale, ProcessDefId, ParentId)';
				DBMS_OUTPUT.PUT_LINE('Table WFMultiLingualTable altered with new Primary Key');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(133);   
			raise_application_error(-20333,v_scriptName ||' BLOCK 133 FAILED');
	END;
	v_logStatus := LogUpdate(133);

		

	v_logStatus := LogInsert(134,'Adding new column BCCMAILID,BCCMAILIDTYPE,EXTBCCMAILID,VARIABLEIDBCC,VARFIELDIDBCC,MAILPRIORITY,MAILPRIORITYTYPE,EXTOBJIDMAILPRIORITY,VARIABLEIDMAILPRIORITY,VARFIELDIDMAILPRIORITY in PRINTFAXEMAILTABLE');
	BEGIN
		
		/* BUG 42494 */	
			existsFlag := 0;
		BEGIN
			v_logStatus := LogSkip(134);
				IF (checkIFColExist('PRINTFAXEMAILTABLE','BCCMAILID'))
				THEN
					EXECUTE IMMEDIATE 'ALTER TABLE PRINTFAXEMAILTABLE MODIFY (BCCMAILID NVARCHAR2(255))';
				ELSE
					EXECUTE IMMEDIATE 'ALTER TABLE PRINTFAXEMAILTABLE Add (BCCMAILID NVARCHAR2(255))';
				END IF;
				
				
				
				IF (checkIFColExist('PRINTFAXEMAILTABLE','BCCMAILIDTYPE'))
				THEN
					EXECUTE IMMEDIATE 'ALTER TABLE PRINTFAXEMAILTABLE MODIFY (BCCMAILIDTYPE NVARCHAR2(255)   Default ''C'' )';
				ELSE
					EXECUTE IMMEDIATE 'ALTER TABLE PRINTFAXEMAILTABLE Add (BCCMAILIDTYPE NVARCHAR2(255)  Default ''C'' )';
					EXECUTE IMMEDIATE q'{UPDATE PRINTFAXEMAILTABLE SET BCCMAILIDTYPE=N'C' WHERE BCCMAILIDTYPE IS NULL  }';
					DBMS_OUTPUT.PUT_LINE('Table PRINTFAXEMAILTABLE altered with Column BCCMAILIDTYPE ROWCOUNT'||SQL%ROWCOUNT);
					COMMIT;
					
				END IF;
				
				IF (checkIFColExist('PRINTFAXEMAILTABLE','EXTBCCMAILID'))
				THEN
					EXECUTE IMMEDIATE 'ALTER TABLE PRINTFAXEMAILTABLE MODIFY (EXTBCCMAILID NUMBER(*,0) Default 0 )';
				ELSE
					EXECUTE IMMEDIATE 'ALTER TABLE PRINTFAXEMAILTABLE Add (EXTBCCMAILID NUMBER(*,0) Default 0 )';
					EXECUTE IMMEDIATE q'{UPDATE PRINTFAXEMAILTABLE SET EXTBCCMAILID=0 WHERE EXTBCCMAILID IS NULL }';
					DBMS_OUTPUT.PUT_LINE('Table PRINTFAXEMAILTABLE altered with Column EXTBCCMAILID ROWCOUNT'||SQL%ROWCOUNT);
					COMMIT;
				END IF;
				
				IF (checkIFColExist('PRINTFAXEMAILTABLE','VARIABLEIDBCC'))
				THEN
					EXECUTE IMMEDIATE 'ALTER TABLE PRINTFAXEMAILTABLE MODIFY (VARIABLEIDBCC NUMBER(*,0) Default 0 )';
				ELSE
					EXECUTE IMMEDIATE 'ALTER TABLE PRINTFAXEMAILTABLE Add (VARIABLEIDBCC NUMBER(*,0) Default 0 )';
					EXECUTE IMMEDIATE 'UPDATE PRINTFAXEMAILTABLE SET VARIABLEIDBCC=0 WHERE VARIABLEIDBCC IS NULL';
					DBMS_OUTPUT.PUT_LINE('Table PRINTFAXEMAILTABLE altered with Column VARIABLEIDBCC ROWCOUNT'||SQL%ROWCOUNT);
					COMMIT;
				END IF;
				
				IF (checkIFColExist('PRINTFAXEMAILTABLE','VARFIELDIDBCC'))
				THEN
					EXECUTE IMMEDIATE 'ALTER TABLE PRINTFAXEMAILTABLE MODIFY (VARFIELDIDBCC  NUMBER(*,0) Default 0 )';
				ELSE
					EXECUTE IMMEDIATE 'ALTER TABLE PRINTFAXEMAILTABLE Add (VARFIELDIDBCC  NUMBER(*,0) Default 0 )';
					EXECUTE IMMEDIATE 'UPDATE PRINTFAXEMAILTABLE SET VARFIELDIDBCC=0 WHERE VARFIELDIDBCC IS NULL ';
					DBMS_OUTPUT.PUT_LINE('Table PRINTFAXEMAILTABLE altered with Column VARFIELDIDBCC ROWCOUNT'||SQL%ROWCOUNT);
					COMMIT;
				END IF;
				
				
				IF (checkIFColExist('PRINTFAXEMAILTABLE','MAILPRIORITY'))
				THEN
					EXECUTE IMMEDIATE 'ALTER TABLE PRINTFAXEMAILTABLE MODIFY (MailPriority NVARCHAR2(255) Default 1)';
				ELSE
					EXECUTE IMMEDIATE 'ALTER TABLE PRINTFAXEMAILTABLE Add (MailPriority NVARCHAR2(255) Default 1)';
					EXECUTE IMMEDIATE 'UPDATE PRINTFAXEMAILTABLE SET MailPriority=1 WHERE MailPriority IS NULL';
					DBMS_OUTPUT.PUT_LINE('Table PRINTFAXEMAILTABLE altered with Column MailPriority ROWCOUNT'||SQL%ROWCOUNT);
					COMMIT;
				END IF;
				
				IF (checkIFColExist('PRINTFAXEMAILTABLE','MAILPRIORITYTYPE'))
				THEN
					EXECUTE IMMEDIATE 'ALTER TABLE PRINTFAXEMAILTABLE MODIFY (MailPriorityType  NVARCHAR2(255) Default ''C'')';
				ELSE
					EXECUTE IMMEDIATE 'ALTER TABLE PRINTFAXEMAILTABLE Add (MailPriorityType  NVARCHAR2(255) Default ''C'')';
					EXECUTE IMMEDIATE Q'{UPDATE PRINTFAXEMAILTABLE SET MailPriorityType=N'C' WHERE MailPriorityType IS NULL}';
					DBMS_OUTPUT.PUT_LINE('Table PRINTFAXEMAILTABLE altered with Column MailPriority ROWCOUNT'||SQL%ROWCOUNT);
					COMMIT;
				END IF;
				
				IF (checkIFColExist('PRINTFAXEMAILTABLE','EXTOBJIDMAILPRIORITY'))
				THEN
					EXECUTE IMMEDIATE 'ALTER TABLE PRINTFAXEMAILTABLE MODIFY (ExtObjIdMailPriority  NUMBER(*,0) Default 0)';
				ELSE
					EXECUTE IMMEDIATE 'ALTER TABLE PRINTFAXEMAILTABLE Add (ExtObjIdMailPriority  NUMBER(*,0) Default 0)';
					EXECUTE IMMEDIATE 'UPDATE PRINTFAXEMAILTABLE SET ExtObjIdMailPriority = 0 WHERE ExtObjIdMailPriority IS NULL';
					DBMS_OUTPUT.PUT_LINE('Table PRINTFAXEMAILTABLE altered with Column ExtObjIdMailPriority ROWCOUNT'||SQL%ROWCOUNT);
					COMMIT;
					
				END IF;
				
				IF (checkIFColExist('PRINTFAXEMAILTABLE','VARIABLEIDMAILPRIORITY'))
				THEN
					EXECUTE IMMEDIATE 'ALTER TABLE PRINTFAXEMAILTABLE MODIFY (VariableIdMailPriority NUMBER(*,0) Default 0)';
				ELSE
					EXECUTE IMMEDIATE 'ALTER TABLE PRINTFAXEMAILTABLE Add (VariableIdMailPriority NUMBER(*,0) Default 0)';
					EXECUTE IMMEDIATE 'UPDATE PRINTFAXEMAILTABLE SET VariableIdMailPriority =0 WHERE VariableIdMailPriority IS NULL  ';
					DBMS_OUTPUT.PUT_LINE('Table PRINTFAXEMAILTABLE altered with Column VariableIdMailPriority ROWCOUNT'||SQL%ROWCOUNT);
					COMMIT;
				END IF;
				
				IF (checkIFColExist('PRINTFAXEMAILTABLE','VARFIELDIDMAILPRIORITY'))
				THEN
					EXECUTE IMMEDIATE 'ALTER TABLE PRINTFAXEMAILTABLE MODIFY (VarFieldIdMailPriority NUMBER(*,0) Default 0)';
				ELSE
					EXECUTE IMMEDIATE 'ALTER TABLE PRINTFAXEMAILTABLE Add (VarFieldIdMailPriority NUMBER(*,0) Default 0)';
					EXECUTE IMMEDIATE 'UPDATE PRINTFAXEMAILTABLE  SET VarFieldIdMailPriority=0 WHERE VarFieldIdMailPriority IS NULL';
					DBMS_OUTPUT.PUT_LINE('Table PRINTFAXEMAILTABLE altered with Column VarFieldIdMailPriority ROWCOUNT'||SQL%ROWCOUNT);
					COMMIT;
				END IF;
				
				DBMS_OUTPUT.PUT_LINE('Table PRINTFAXEMAILTABLE altered with new Column BCCMAILID,BCCMAILIDTYPE,EXTBCCMAILID,VARIABLEIDBCC,VARFIELDIDBCC');
				DBMS_OUTPUT.PUT_LINE('Table PRINTFAXEMAILTABLE altered with new Column MailPriority,MailPriorityType,ExtObjIdMailPriority,VariableIdMailPriority,VarFieldIdMailPriority');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(134);   
			raise_application_error(-20334,v_scriptName ||' BLOCK 134 FAILED');
	END;
	v_logStatus := LogUpdate(134);

		
		

	v_logStatus := LogInsert(135,'Adding new column FieldName in WFMultiLingualTable');
	BEGIN
		
			BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME = UPPER('WFMultiLingualTable')
			AND COLUMN_NAME = UPPER('FieldName');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				EXECUTE IMMEDIATE 'ALTER TABLE WFMultiLingualTable Add FieldName NVARCHAR2(1000)';
				DBMS_OUTPUT.PUT_LINE('Table WFMultiLingualTable altered with new Column FieldName');
		END;

	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(135);   
			raise_application_error(-20335,v_scriptName ||' BLOCK 135 FAILED');
	END;
	v_logStatus := LogUpdate(135);

			
	v_logStatus := LogInsert(136,'updating wfmultilingualtable');
	BEGIN
		BEGIN	
			v_logStatus := LogSkip(136);
			EXECUTE IMMEDIATE 'update wfmultilingualtable set processdefid = entityid where entitytype = 1 and processdefid = 0';
			
			EXECUTE IMMEDIATE 'update wfmultilingualtable set FieldName = (select ProcessName from processdeftable where entityid = processdeftable.processdefid) where entitytype = 1 and (FieldName IS NULL or FieldName = '''')';
			
			EXECUTE IMMEDIATE 'update wfmultilingualtable set FieldName = (select queuename from queuedeftable where entityid = queueid) where entitytype = 2 and (FieldName IS NULL or FieldName = '''')';
			
			EXECUTE IMMEDIATE 'update wfmultilingualtable set FieldName = (select activityname from activitytable where entityid = activityid and wfmultilingualtable.processdefid = activitytable.processdefid) where entitytype = 3 and (FieldName IS NULL or FieldName = '''')';
			
			EXECUTE IMMEDIATE 'update wfmultilingualtable set FieldName = (select UserDefinedName from varmappingtable where entityid = variableid and wfmultilingualtable.processdefid = varmappingtable.processdefid) where entitytype = 4 and (FieldName IS NULL or FieldName = '''')';
			
			EXECUTE IMMEDIATE 'update wfmultilingualtable set FieldName = (select Alias from varaliastable where entityid = variableid1 and wfmultilingualtable.processdefid = varaliastable.processdefid and parentid = queueid) where entitytype = 5 and (FieldName IS NULL or FieldName = '''')';
			
			EXECUTE IMMEDIATE 'update wfmultilingualtable set FieldName = (select DocName from documenttypedeftable where entityid = docid and wfmultilingualtable.processdefid = documenttypedeftable.processdefid) where entitytype = 6 and (FieldName IS NULL or FieldName = '''')';
		END;

	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(136);   
			raise_application_error(-20336,v_scriptName ||' BLOCK 136 FAILED');
	END;
	v_logStatus := LogUpdate(136);

		
			
	v_logStatus := LogInsert(137,'CREATE TABLE WorkDoneSuspectTable');
	BEGIN
		BEGIN 
			SELECT 1 INTO existsFlag 
			FROM USER_TABLES  
			WHERE TABLE_NAME = UPPER('WorkDoneSuspectTable');
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
				v_logStatus := LogSkip(137);
				EXECUTE IMMEDIATE 
				'CREATE TABLE WorkDoneSuspectTable (
				ProcessInstanceId	NVARCHAR2(63)	NOT NULL ,
				WorkItemId		INT		NOT NULL ,
				ProcessName 		NVARCHAR2(30)	NOT NULL ,
				ProcessVersion   	SMALLINT,
				ProcessDefID 		INT		NOT NULL,
				LastProcessedBy 	INT		NULL ,
				ProcessedBy		NVARCHAR2(63)	NULL,	
				ActivityName 		NVARCHAR2(30)	NULL ,
				ActivityId 		INT		NULL ,
				EntryDateTime 		DATE		NULL ,
				ParentWorkItemId	INT		NULL ,	
				AssignmentType		NVARCHAR2(1)	NULL ,
				CollectFlag		NVARCHAR2(1)	NULL ,
				PriorityLevel		SMALLINT	NULL ,
				ValidTill		DATE		NULL ,
				Q_StreamId		INT		NULL ,
				Q_QueueId		INT		NULL ,
				Q_UserId		SMALLINT	NULL ,
				AssignedUser		NVARCHAR2(63)	NULL,	
				FilterValue		INT		NULL ,
				Createddatetime		DATE		NULL ,
				WorkItemState		INT		NULL ,
				Statename 		NVARCHAR2(255),
				ExpectedWorkitemDelay	DATE		NULL ,
				PreviousStage		NVARCHAR2 (30)  NULL ,
				LockedByName		NVARCHAR2(63)	NULL,	
				LockStatus		NVARCHAR2(1)	Default N''N'' NOT NULL,
				LockedTime		DATE		NULL, 
				Queuename 		NVARCHAR2(63),
				Queuetype 		NVARCHAR2(1),
				NotifyStatus		NVARCHAR2(1),	
				CONSTRAINT PK_WorkDoneSuspectTable PRIMARY KEY  
				(
				ProcessInstanceID,WorkitemId
				)
				)';
			DBMS_OUTPUT.PUT_LINE ('Table WorkDoneSuspectTable Created successfully');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(137);   
			raise_application_error(-20337,v_scriptName ||' BLOCK 137 FAILED');
	END;
	v_logStatus := LogUpdate(137);

		
			

	v_logStatus := LogInsert(138,'Adding new column IsEncrypted in WFExportInfoTable');
	BEGIN
		
		BEGIN
			v_logStatus := LogSkip(138);
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('WFExportInfoTable') 
			AND 
			COLUMN_NAME=UPPER('IsEncrypted');
			
			EXECUTE IMMEDIATE 'ALTER TABLE WFExportInfoTable MODIFY IsEncrypted NVARCHAR2(1) DEFAULT ''N'' ';
			
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				EXECUTE IMMEDIATE 'ALTER TABLE WFExportInfoTable add IsEncrypted NVARCHAR2(1) DEFAULT ''N'' ';
				EXECUTE IMMEDIATE q'{UPDATE  WFEXPORTINFOTABLE SET ISENCRYPTED = N'N' WHERE ISENCRYPTED IS NULL}';
				DBMS_OUTPUT.PUT_LINE('Table WFExportInfoTable altered with new Column IsEncrypted ROWCOUNT:'||SQL%ROWCOUNT);
				COMMIT;
		END;
		
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(138);   
			raise_application_error(-20338,v_scriptName ||' BLOCK 138 FAILED');
	END;
	v_logStatus := LogUpdate(138);

		
		
		
	v_logStatus := LogInsert(139,'Adding new column BulkPS in PSRegisterationTable');
	BEGIN
			existsFlag := 0;
		BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('PSRegisterationTable') 
			AND 
			COLUMN_NAME=UPPER('BulkPS');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_logStatus := LogSkip(139);
				EXECUTE IMMEDIATE 'ALTER TABLE PSRegisterationTable ADD (BulkPS VARCHAR2(1))';
				DBMS_OUTPUT.PUT_LINE('Table PSRegisterationTable altered with new Column BulkPS');
		END;

	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(139);   
			raise_application_error(-20339,v_scriptName ||' BLOCK 139 FAILED');
	END;
	v_logStatus := LogUpdate(139);


	v_logStatus := LogInsert(140,'Creating Trigger WF_UTIL_UNREGISTER AFTER DELETE ON PSREGISTERATIONTABLE FOR EACH ROW');
	BEGIN
		
		BEGIN
			IF v_TableExists = 1
			THEN
				v_logStatus := LogSkip(140);
				BEGIN
					EXECUTE IMMEDIATE 'CREATE OR REPLACE TRIGGER WF_UTIL_UNREGISTER
						AFTER DELETE 
						ON PSREGISTERATIONTABLE 
						FOR EACH ROW
						DECLARE
							PSName NVARCHAR2(100);
							PSData NVARCHAR2(50);
						BEGIN
							PSName := :OLD.PSName;
							PSData := :OLD.Data;
							IF (PSData = ''PROCESS SERVER'') THEN
							BEGIN
								Insert into WorkDoneTable(ProcessInstanceId,WorkItemId,ProcessName,ProcessVersion,ProcessDefID,LastProcessedBy,ProcessedBy,ActivityName,ActivityId,EntryDateTime,ParentWorkItemId,AssignmentType,CollectFlag,PriorityLevel,ValidTill,Q_StreamId,Q_QueueId,Q_UserId,AssignedUser,FilterValue,CreatedDatetime,WorkItemState,Statename,ExpectedWorkitemDelay,PreviousStage,LockedByName,LockStatus,LockedTime,Queuename,Queuetype,NotifyStatus) select ProcessInstanceId,WorkItemId,ProcessName,ProcessVersion,ProcessDefID,LastProcessedBy,ProcessedBy,ActivityName,ActivityId,EntryDateTime,ParentWorkItemId,AssignmentType,CollectFlag,PriorityLevel,ValidTill,Q_StreamId,Q_QueueId,Q_UserId,AssignedUser,FilterValue,CreatedDatetime,WorkItemState,Statename,ExpectedWorkitemDelay,PreviousStage,null,''N'',null,Queuename,Queuetype,NotifyStatus from WorkWithPSTable where LockedByName = PSName;
								Delete from WorkWithPSTable where LockedByName = PSName;
							END;
							END IF;
							IF (PSData = ''MAILING AGENT'') THEN
							BEGIN
								UPDATE WFMailQueueTable SET MailStatus = ''N'', LockedBy = null, LastLockTime = null, NoOfTrials = 0 where LockedBy = PSName;
							END;
							END IF;
							IF (PSData = ''MESSAGE AGENT'') THEN
							BEGIN
								UPDATE WFMessageTable SET LockedBy = null, Status = ''N'' where LockedBy = PSName;
							END;
							END IF;
							IF (PSData = ''PRINT,FAX & EMAIL'' OR PSData = ''ARCHIVE UTILITY'') THEN
							BEGIN
								Insert into Worklisttable (ProcessInstanceId, WorkItemId, ProcessName, ProcessVersion, ProcessDefID, LastProcessedBy, ProcessedBy, ActivityName, ActivityId, EntryDateTime, ParentWorkItemId, CollectFlag, PriorityLevel, ValidTill, Q_StreamId, Q_QueueId, Q_UserId, AssignedUser, AssignmentType, FilterValue, CreatedDateTime, WorkItemState, Statename, ExpectedWorkitemDelay, PreviousStage, LockedByName, LockStatus, LockedTime, Queuename, Queuetype, Q_DivertedByUserId) Select ProcessInstanceId, WorkItemId, ProcessName, ProcessVersion, ProcessDefID, LastProcessedBy, ProcessedBy, ActivityName, ActivityId, EntryDateTime, ParentWorkItemId, CollectFlag, PriorityLevel, ValidTill, Q_StreamId, Q_QueueId, 0, null, AssignmentType, FilterValue, CreatedDateTime, WorkItemState, Statename, ExpectedWorkitemDelay, PreviousStage, null, N''N'', null, Queuename, Queuetype , Q_DivertedByUserId from WorkinProcessTable where LockedByName = PSName;
								Delete from WorkInProcessTable where LockedByName = PSName;
							END;
							END IF;
						END;';
					DBMS_OUTPUT.PUT_LINE ('Trigger WF_UTIL_UNREGISTER created');
				END;
			END IF;
		END;
		
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(140);   
			raise_application_error(-20340,v_scriptName ||' BLOCK 140 FAILED');
	END;
	v_logStatus := LogUpdate(140);

		

	v_logStatus := LogInsert(141,'Adding new column context in processdeftable');
	BEGIN
		
			existsFlag := 0;
		BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('processdeftable') 
			AND 
			COLUMN_NAME=UPPER('context');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_logStatus := LogSkip(141);
				EXECUTE IMMEDIATE 'ALTER TABLE processdeftable ADD context nvarchar2(50)';
				DBMS_OUTPUT.PUT_LINE('Table processdeftable altered with new Column context');
		END; 
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(141);   
			raise_application_error(-20341,v_scriptName ||' BLOCK 141 FAILED');
	END;
	v_logStatus := LogUpdate(141);

		

	v_logStatus := LogInsert(142,'Adding new column TempContext in GTempProcessTable');
	BEGIN		
				existsFlag := 0;
			BEGIN
				SELECT 1 INTO existsFlag
				FROM USER_TAB_COLUMNS
				WHERE UPPER(TABLE_NAME) = 'GTEMPPROCESSTABLE'
				AND Upper(COLUMN_NAME) in ('TEMPCONTEXT');
			  EXCEPTION
				WHEN NO_DATA_FOUND THEN 
					v_logStatus := LogSkip(142);
					EXECUTE IMMEDIATE 'ALTER TABLE GTempProcessTable ADD TempContext NVarchar2(50)';
					DBMS_OUTPUT.PUT_LINE ('Table GTempProcessTable altered successfully');
			END;

	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(142);   
			raise_application_error(-20342,v_scriptName ||' BLOCK 142 FAILED');
	END;
	v_logStatus := LogUpdate(142);

		
	v_logStatus := LogInsert(143,'Adding new column COUNT_1,TABLENAME in GTEMPSEARCHTABLE');
	BEGIN
			
					existsFlag := 0;
			BEGIN
					v_logStatus := LogSkip(143);			
					IF (checkIFColExist('GTEMPSEARCHTABLE','COUNT_1'))
					THEN
						EXECUTE IMMEDIATE 'ALTER TABLE GTEMPSEARCHTABLE MODIFY (COUNT_1 INT)';
					ELSE
						EXECUTE IMMEDIATE 'ALTER TABLE GTEMPSEARCHTABLE Add (COUNT_1 INT)';
					
					END IF;
					
					IF (checkIFColExist('GTEMPSEARCHTABLE','TABLENAME'))
					THEN
						EXECUTE IMMEDIATE 'ALTER TABLE GTEMPSEARCHTABLE MODIFY (TABLENAME NVARCHAR2(100))';
					ELSE
						EXECUTE IMMEDIATE 'ALTER TABLE GTEMPSEARCHTABLE Add (TABLENAME NVARCHAR2(100))';
					
					END IF;

					DBMS_OUTPUT.PUT_LINE ('Table GTempSearchTable altered successfully');
			END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(143);   
			raise_application_error(-20343,v_scriptName ||' BLOCK 143 FAILED');
	END;
	v_logStatus := LogUpdate(143);

		

	v_logStatus := LogInsert(144,'Adding Queue of QueueType A for Archive Utility ,Updating table QueueStreamTable,WorkListTable,WorkInProcessTable');
	BEGIN
			
		BEGIN
			IF v_TableExists = 1
			THEN
				v_logStatus := LogSkip(144);
				BEGIN
					BEGIN
						SELECT QueueId INTO v_QueueId FROM QueueDefTable WHERE QueueType = 'A' and QueueName = 'SystemArchiveQueue';
						v_rowCount := SQL%ROWCOUNT;
						EXCEPTION 
							WHEN OTHERS THEN
							v_rowCount := 0;
					END;
						
						IF(v_rowCount < 1) THEN
						BEGIN
						
							SAVEPOINT Archive;
							--SELECT QUEUEID.NEXTVALUE INTO v_nextVal from DUAL;
							
							EXECUTE IMMEDIATE 'INSERT INTO QueueDefTable (QUEUEID,QUEUENAME,QUEUETYPE,COMMENTS,ALLOWREASSIGNMENT,FILTEROPTION,FILTERVALUE,ORDERBY,QUEUEFILTER,REFRESHINTERVAL,SORTORDER,PROCESSNAME)values(QUEUEID.NEXTVAL, ''SystemArchiveQueue'',''A'',''Queue of QueueType A for Archive Utility is added thorugh Upgradenew.sql'',NULL,NULL,NULL,10,NULL,NULL,''A'',NULL)';
							
							DBMS_OUTPUT.PUT_LINE('Queue of QueueType A for Archive Utility is added successfully');			
							
							v_queryStr := 'Select ActivityAssociationtable.ProcessDefID, activityId from ActivityAssociationtable,Process_Interfacetable where DefinitionType = ''N'' and DefinitionId = InterfaceId and ActivityAssociationtable.ProcessDefID = Process_Interfacetable.ProcessDefID and InterfaceName = ''Archive''';
							Select QueueID into v_QueueId from QueueDefTable where QueueName = 'SystemArchiveQueue' and QueueType = 'A';
							OPEN Cursor1 FOR v_queryStr;
							LOOP
								FETCH Cursor1 INTO v_ProcessDefId, v_ActivityId;
								EXIT WHEN Cursor1%NOTFOUND;
								
								EXECUTE IMMEDIATE 'Update QueueStreamTable set QueueId = ' || v_QueueId || ' where activityId = ' || v_ActivityId || ' and processDefId = '||v_ProcessDefId;
								
								EXECUTE IMMEDIATE 'Update WorkListTable set QueueName = ''SystemArchiveQueue'' ,Q_queueId = ' || v_QueueId || ' where activityId = ' || v_ActivityId || ' and processDefId = ' || v_ProcessDefId;
								
								EXECUTE IMMEDIATE 'Update WorkInProcessTable set QueueName = ''SystemArchiveQueue'',Q_queueId= ' || v_QueueId || ' where activityId = ' || v_ActivityId || ' and processDefId = ' || v_ProcessDefId ;
								
							
								
							END LOOP;
							
							CLOSE Cursor1;	
						EXCEPTION 
						WHEN OTHERS THEN
						ROLLBACK TO SAVEPOINT Archive;	
						CLOSE Cursor1;			
						END;
						END IF;
				END;
			END IF;
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(144);   
			raise_application_error(-20344,v_scriptName ||' BLOCK 144 FAILED');
	END;
	v_logStatus := LogUpdate(144);

		

	v_logStatus := LogInsert(145,'Adding Queue of QueueType A for PFE Utility ,Updating table QueueStreamTable,WorkListTable,WorkInProcessTable');
	BEGIN
		IF v_TableExists = 1
			THEN
				v_logStatus := LogSkip(145);
				BEGIN
					BEGIN
						SELECT QueueId INTO v_QueueId FROM QueueDefTable WHERE QueueType = 'A' and QueueName = 'SystemPFEQueue';
						v_rowCount := SQL%ROWCOUNT;
						EXCEPTION 
							WHEN OTHERS THEN
							v_rowCount := 0;
					END;
				
					IF(v_rowCount < 1) THEN
					BEGIN
					
					SAVEPOINT PFE;
						--SELECT QUEUEID.NEXTVALUE INTO v_nextVal from DUAL;
						
						EXECUTE IMMEDIATE 'INSERT INTO QueueDefTable (QUEUEID,QUEUENAME,QUEUETYPE,COMMENTS,ALLOWREASSIGNMENT,FILTEROPTION,FILTERVALUE,ORDERBY,QUEUEFILTER,REFRESHINTERVAL,SORTORDER,PROCESSNAME) values(QUEUEID.NEXTVAL, ''SystemPFEQueue'',''A'',''Queue of QueueType A for PFE Utility is added thorugh Upgradenew.sql'',NULL,NULL,NULL,10,NULL,NULL,''A'',NULL)';
						
						DBMS_OUTPUT.PUT_LINE('Queue of QueueType A for PFE Utility is added successfully');
						
						
				 
						
						v_queryStr := 'Select ActivityAssociationtable.ProcessDefID, activityId from ActivityAssociationtable,Process_Interfacetable where DefinitionType = ''N'' and DefinitionId = InterfaceId and ActivityAssociationtable.ProcessDefID = Process_Interfacetable.ProcessDefID and InterfaceName = ''PrintFaxEmail''';
						Select QueueID into v_QueueId from QueueDefTable where QueueName = 'SystemPFEQueue' and QueueType = 'A';
						OPEN Cursor1 FOR v_queryStr;
						LOOP
							FETCH Cursor1 INTO v_ProcessDefId, v_ActivityId;
							EXIT WHEN Cursor1%NOTFOUND;
							
							EXECUTE IMMEDIATE 'Update QueueStreamTable set QueueId = ' || v_QueueId || ' where activityId = ' || v_ActivityId || ' and processDefId = '||v_ProcessDefId;

							EXECUTE IMMEDIATE 'Update WorkListTable set QueueName = ''SystemPFEQueue'' ,Q_queueId = ' || v_QueueId || ' where activityId = ' || v_ActivityId || ' and processDefId = ' || v_ProcessDefId;
							
							EXECUTE IMMEDIATE 'Update WorkInProcessTable set QueueName = ''SystemPFEQueue'',Q_queueId= ' || v_QueueId || ' where activityId = ' || v_ActivityId || ' and processDefId = ' || v_ProcessDefId ;
							
							
							
						END LOOP;
						
						CLOSE Cursor1;	
						
					EXCEPTION 
					WHEN OTHERS THEN
					ROLLBACK TO SAVEPOINT PFE;	
					CLOSE Cursor1;			
					END;
					END IF;
				
				END;
			END IF;

	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(145);   
			raise_application_error(-20345,v_scriptName ||' BLOCK 145 FAILED');
	END;
	v_logStatus := LogUpdate(145);

		
		
	v_logStatus := LogInsert(146,'Adding Primary Key (Userid,ObjectType,ObjectId) in UserPreferencesTable');
	BEGIN
		
		BEGIN
		v_logStatus := LogSkip(146);
		SELECT CONSTRAINT_NAME INTO v_constraintName
			FROM USER_CONSTRAINTS 
			WHERE TABLE_NAME = UPPER('UserPreferencesTable') AND constraint_type = 'P';

			EXECUTE IMMEDIATE 'Alter Table UserPreferencesTable  Drop PRIMARY KEY DROP INDEX ' ;
			EXECUTE IMMEDIATE 'Alter Table UserPreferencesTable  Add Constraint ' || TO_CHAR(v_constraintName) || ' Primary Key (Userid,ObjectType,ObjectId)';
			DBMS_OUTPUT.PUT_LINE('Primary Key Updated for UserPreferencesTable');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				DBMS_OUTPUT.PUT_LINE('No Primary Key Exists for UserPreferencesTable');
				EXECUTE IMMEDIATE 'Alter Table UserPreferencesTable  Add Constraint PK_USER_PREF  Primary Key (Userid,ObjectType,ObjectId)';
		END;

	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(146);   
			raise_application_error(-20346,v_scriptName ||' BLOCK 146 FAILED');
	END;
	v_logStatus := LogUpdate(146);

		
	v_logStatus := LogInsert(147,'Adding new column VARIABLEID in WFSearchVariableTable and updating table WFSearchVariableTable');
	BEGIN
		
		
		BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('WFSearchVariableTable') 
			AND 
			COLUMN_NAME=UPPER('VariableId');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_logStatus := LogSkip(147);
				EXECUTE IMMEDIATE 'ALTER TABLE WFSearchVariableTable ADD VARIABLEID INT DEFAULT 0 ';
				DBMS_OUTPUT.PUT_LINE('Table WFSearchVariableTable altered with new Column VariableId');	
				DECLARE CURSOR cursor1 IS SELECT DISTINCT FieldName, A.VariableId, B.ProcessDefId FROM VARMAPPINGTABLE  A, WFSearchVariableTable B WHERE UPPER(A.USERDEFINEDNAME) = UPPER(B.FIELDNAME);
				BEGIN					
				OPEN cursor1;
				LOOP
					FETCH cursor1 INTO v_fieldname, v_VariableId, v_ProcessdefId;
					EXIT WHEN cursor1%NOTFOUND;			
					BEGIN
					v_STR1 := ' Update WFSEARCHVARIABLETABLE Set VariableId = ' || v_VariableId || ' Where UPPER(FIELDNAME) = ''' || UPPER(TO_CHAR(v_fieldname)) || ''' AND ProcessdefId = ' || v_ProcessdefId;
					
						EXECUTE IMMEDIATE v_STR1;			
					END;
					COMMIT;
				END LOOP;
				CLOSE cursor1;			
				END;	
		END;

	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(147);   
			raise_application_error(-20347,v_scriptName ||' BLOCK 147 FAILED');
	END;
	v_logStatus := LogUpdate(147);

	v_logStatus := LogInsert(148,'CREATE TABLE pmsversioninfo');
	BEGIN
		
		BEGIN 
		  SELECT 1 INTO existsFlag 
		  FROM USER_TABLES  
		  WHERE TABLE_NAME = 'PMSVERSIONINFO';
		EXCEPTION 
		  WHEN NO_DATA_FOUND THEN 
		  v_logStatus := LogSkip(148);
		   EXECUTE IMMEDIATE 
		   'CREATE TABLE pmsversioninfo(
				product_acronym varchar2(100),
				label varchar2(100) ,
				previouslabel varchar2(100),
				updatedon date DEFAULT sysdate
				)';
		   dbms_output.put_line ('Table PMSVERSIONINFO Created successfully');
		END;

	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(148);   
			raise_application_error(-20348,v_scriptName ||' BLOCK 148 FAILED');
	END;
	v_logStatus := LogUpdate(148);

		
	v_logStatus := LogInsert(149,'Modifying column LOCKEDBYNAME in tables WORKWITHPSTABLE,WORKDONETABLE');
	BEGIN
		BEGIN 
		SELECT 1 INTO existsFlag 
			FROM USER_TABLES  
			WHERE TABLE_NAME = 'WORKWITHPSTABLE';
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
				existsFlag := 0;
				dbms_output.put_line ('WORKWITHPSTABLE does not exists');
		END;
		IF existsFlag = 1
		THEN
			v_logStatus := LogSkip(149);
			BEGIN
			
				IF(v_WWPSTableExist = 1) THEN
					IF (checkIFColExist('WORKWITHPSTABLE','LOCKEDBYNAME'))
					THEN
						EXECUTE IMMEDIATE 'ALTER TABLE WORKWITHPSTABLE MODIFY (LOCKEDBYNAME NVARCHAR2(200))';
						DBMS_OUTPUT.PUT_LINE('Table WORKWITHPSTABLE column LOCKEDBYNAME modified');
					END IF;
				END IF;
									
			END;
		END IF;
		
		BEGIN 
		SELECT 1 INTO existsFlag 
			FROM USER_TABLES  
			WHERE TABLE_NAME = 'WORKDONETABLE';
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
				existsFlag := 0;
				dbms_output.put_line ('WORKDONETABLE does not exists');
		END;
		IF existsFlag = 1
		THEN
			v_logStatus := LogSkip(149);
			BEGIN
				IF (checkIFColExist('WORKDONETABLE','LOCKEDBYNAME'))
				THEN
					EXECUTE IMMEDIATE 'ALTER TABLE WORKDONETABLE MODIFY (LOCKEDBYNAME NVARCHAR2(200))';
					DBMS_OUTPUT.PUT_LINE('Table WORKDONETABLE column LOCKEDBYNAME modified');				
				END IF;
									
			END;
		END IF;
		
		
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(149);   
			raise_application_error(-20349,v_scriptName ||' BLOCK 149 FAILED');
	END;
	v_logStatus := LogUpdate(149);

		
		

	v_logStatus := LogInsert(150,'Adding Primary Key (TASKID) in WFMAILQUEUEHISTORYTABLE');
	BEGIN
		
		BEGIN
			v_logStatus := LogSkip(150);
			SELECT CONSTRAINT_NAME INTO v_constraintName
			FROM USER_CONSTRAINTS 
			WHERE TABLE_NAME = UPPER('WFMAILQUEUEHISTORYTABLE') AND constraint_type = 'P';

			EXECUTE IMMEDIATE 'Alter Table WFMAILQUEUEHISTORYTABLE Drop Constraint ' || TO_CHAR(v_constraintName);
			EXECUTE IMMEDIATE 'Alter Table WFMAILQUEUEHISTORYTABLE Add Constraint ' || TO_CHAR(v_constraintName) || ' Primary Key (TASKID)';
			DBMS_OUTPUT.PUT_LINE('Primary Key Updated for WFMAILQUEUEHISTORYTABLE');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
			BEGIN
			EXECUTE IMMEDIATE 'Alter Table WFMAILQUEUEHISTORYTABLE Add Primary Key (TASKID)';
				DBMS_OUTPUT.PUT_LINE('Primary Key added for WFMAILQUEUEHISTORYTABLE');
			EXCEPTION
			WHEN OTHERS THEN
				DBMS_OUTPUT.PUT_LINE (SQLERRM);
				DBMS_OUTPUT.PUT_LINE (SQLCODE);
			END;

		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(150);   
			raise_application_error(-20350,v_scriptName ||' BLOCK 150 FAILED');
	END;
	v_logStatus := LogUpdate(150);

			
		

	v_logStatus := LogInsert(151,'Adding Primary Key (PROCESSINSTANCEID) in TODOSTATUSTABLE');
	BEGIN
		
		BEGIN
			v_logStatus := LogSkip(151);
			SELECT CONSTRAINT_NAME INTO v_constraintName
			FROM USER_CONSTRAINTS 
			WHERE TABLE_NAME = UPPER('TODOSTATUSTABLE') AND constraint_type = 'P';

			EXECUTE IMMEDIATE 'Alter Table TODOSTATUSTABLE Drop Constraint ' || TO_CHAR(v_constraintName);
			EXECUTE IMMEDIATE 'Alter Table TODOSTATUSTABLE Add Constraint ' || TO_CHAR(v_constraintName) || ' Primary Key (PROCESSINSTANCEID)';
			DBMS_OUTPUT.PUT_LINE('Primary Key Updated for TODOSTATUSTABLE');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
			BEGIN
			EXECUTE IMMEDIATE 'Alter Table TODOSTATUSTABLE Add Primary Key (PROCESSINSTANCEID)';
				DBMS_OUTPUT.PUT_LINE('Primary Key added for TODOSTATUSTABLE');
			EXCEPTION
			WHEN OTHERS THEN
				DBMS_OUTPUT.PUT_LINE (SQLERRM);
				DBMS_OUTPUT.PUT_LINE (SQLCODE);
			END;
		END;
		
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(151);   
			raise_application_error(-20351,v_scriptName ||' BLOCK 151 FAILED');
	END;
	v_logStatus := LogUpdate(151);

		
		
		

	v_logStatus := LogInsert(152,'Adding Primary Key (PROCESSINSTANCEID) in TODOSTATUSHISTORYTABLE');
	BEGIN
		
		BEGIN
			v_logStatus := LogSkip(152);
			SELECT CONSTRAINT_NAME INTO v_constraintName
			FROM USER_CONSTRAINTS 
			WHERE TABLE_NAME = UPPER('TODOSTATUSHISTORYTABLE') AND constraint_type = 'P';

			EXECUTE IMMEDIATE 'Alter Table TODOSTATUSHISTORYTABLE Drop Constraint ' || TO_CHAR(v_constraintName);
			EXECUTE IMMEDIATE 'Alter Table TODOSTATUSHISTORYTABLE Add Constraint ' || TO_CHAR(v_constraintName) || ' Primary Key (PROCESSINSTANCEID)';
			DBMS_OUTPUT.PUT_LINE('Primary Key Updated for TODOSTATUSHISTORYTABLE');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
			BEGIN
			EXECUTE IMMEDIATE 'Alter Table TODOSTATUSHISTORYTABLE Add Primary Key (PROCESSINSTANCEID)';
				DBMS_OUTPUT.PUT_LINE('Primary Key added for TODOSTATUSHISTORYTABLE');
			EXCEPTION
			WHEN OTHERS THEN
				DBMS_OUTPUT.PUT_LINE (SQLERRM);
				DBMS_OUTPUT.PUT_LINE (SQLCODE);
			END;
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(152);   
			raise_application_error(-20352,v_scriptName ||' BLOCK 152 FAILED');
	END;
	v_logStatus := LogUpdate(152);

		

	v_logStatus := LogInsert(153,'Add Primary Key (MESSAGEID) in WFJMSMESSAGETABLE');
	BEGIN
		
		/*
		BEGIN
		SELECT CONSTRAINT_NAME INTO v_constraintName
			FROM USER_CONSTRAINTS 
			WHERE TABLE_NAME = UPPER('EXCEPTIONTABLE') AND constraint_type = 'P';

			EXECUTE IMMEDIATE 'Alter Table EXCEPTIONTABLE Drop Constraint ' || TO_CHAR(v_constraintName);
			EXECUTE IMMEDIATE 'Alter Table EXCEPTIONTABLE Add Constraint ' || TO_CHAR(v_constraintName) || ' Primary Key (PROCESSINSTANCEID, PROCESSDEFID, ACTIVITYID, EXCEPTIONID, EXCPSEQID, ACTIONID)';
			DBMS_OUTPUT.PUT_LINE('Primary Key Updated for EXCEPTIONTABLE');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
			BEGIN
			EXECUTE IMMEDIATE 'Alter Table EXCEPTIONTABLE Add Primary Key (PROCESSINSTANCEID, PROCESSDEFID, ACTIVITYID, EXCEPTIONID, EXCPSEQID, ACTIONID)';
				DBMS_OUTPUT.PUT_LINE('Primary Key added for EXCEPTIONTABLE');
			EXCEPTION
			WHEN OTHERS THEN
				DBMS_OUTPUT.PUT_LINE (SQLERRM);
				DBMS_OUTPUT.PUT_LINE (SQLCODE);
			END;
		END;
		
		
		BEGIN
		SELECT CONSTRAINT_NAME INTO v_constraintName
			FROM USER_CONSTRAINTS 
			WHERE TABLE_NAME = UPPER('EXCEPTIONTABLE') AND CONSTRAINT_NAME = UPPER('UK_EXCEPTIONTABLE')  AND constraint_type = 'U';

			EXECUTE IMMEDIATE 'Alter Table EXCEPTIONTABLE Drop Constraint ' || TO_CHAR(v_constraintName);
			EXECUTE IMMEDIATE 'Alter Table EXCEPTIONTABLE Add Constraint ' || TO_CHAR(v_constraintName) || ' UNIQUE (PROCESSINSTANCEID, EXCEPTIONID, EXCPSEQID, ACTIONID) ';
			DBMS_OUTPUT.PUT_LINE('Unique constraint'||v_constraintName||' Updated for EXCEPTIONTABLE');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
			BEGIN
			EXECUTE IMMEDIATE 'Alter Table EXCEPTIONTABLE Add Constraint UK_EXCEPTIONTABLE UNIQUE (PROCESSINSTANCEID, EXCEPTIONID, EXCPSEQID, ACTIONID)';
				DBMS_OUTPUT.PUT_LINE('Unique constraint UK_EXCEPTIONTABLE added for EXCEPTIONTABLE');
			EXCEPTION
				WHEN OTHERS THEN
				DBMS_OUTPUT.PUT_LINE (SQLERRM);
				DBMS_OUTPUT.PUT_LINE (SQLCODE);
			END;
		END;
		
		
		BEGIN
		SELECT CONSTRAINT_NAME INTO v_constraintName
			FROM USER_CONSTRAINTS 
			WHERE TABLE_NAME = UPPER('EXCEPTIONHISTORYTABLE') AND constraint_type = 'P';

			EXECUTE IMMEDIATE 'Alter Table EXCEPTIONHISTORYTABLE Drop Constraint ' || TO_CHAR(v_constraintName);
			EXECUTE IMMEDIATE 'Alter Table EXCEPTIONHISTORYTABLE Add Constraint ' || TO_CHAR(v_constraintName) || ' Primary Key (PROCESSINSTANCEID, PROCESSDEFID, ACTIVITYID, EXCEPTIONID, EXCPSEQID , ACTIONID)';
			DBMS_OUTPUT.PUT_LINE('Primary Key Updated for EXCEPTIONHISTORYTABLE');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
			BEGIN
			EXECUTE IMMEDIATE 'Alter Table EXCEPTIONHISTORYTABLE Add Primary Key (PROCESSINSTANCEID, PROCESSDEFID, ACTIVITYID, EXCEPTIONID, EXCPSEQID , ACTIONID)';
				DBMS_OUTPUT.PUT_LINE('Primary Key added for EXCEPTIONHISTORYTABLE');
			EXCEPTION
			WHEN OTHERS THEN
				DBMS_OUTPUT.PUT_LINE (SQLERRM);
				DBMS_OUTPUT.PUT_LINE (SQLCODE);
			END;
		END; */
		
		
		
		BEGIN
			v_logStatus := LogSkip(153);
			SELECT CONSTRAINT_NAME INTO v_constraintName
			FROM USER_CONSTRAINTS 
			WHERE TABLE_NAME = UPPER('WFJMSMESSAGETABLE') AND constraint_type = 'P';

			EXECUTE IMMEDIATE 'Alter Table WFJMSMESSAGETABLE Drop Constraint ' || TO_CHAR(v_constraintName);
			EXECUTE IMMEDIATE 'Alter Table WFJMSMESSAGETABLE Add Constraint ' || TO_CHAR(v_constraintName) || ' Primary Key (MESSAGEID)';
			DBMS_OUTPUT.PUT_LINE('Primary Key Updated for WFJMSMESSAGETABLE');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				BEGIN
				EXECUTE IMMEDIATE 'Alter Table WFJMSMESSAGETABLE Add Primary Key (MESSAGEID)';
					DBMS_OUTPUT.PUT_LINE('Primary Key added for WFJMSMESSAGETABLE');
				EXCEPTION
				WHEN OTHERS THEN
					DBMS_OUTPUT.PUT_LINE ('An error was encountered -' || SQLERRM);
					DBMS_OUTPUT.PUT_LINE ('ERROR CODE :'|| SQLCODE);
				END;
		END;

	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(153);   
			raise_application_error(-20353,v_scriptName ||' BLOCK 153 FAILED');
	END;
	v_logStatus := LogUpdate(153);

		
	v_logStatus := LogInsert(154,'Adding Primary Key (ProcessDefId, WSDLURLId) in WFWebServiceInfoTable');
	BEGIN
		
		
		BEGIN
			v_logStatus := LogSkip(154);
			SELECT CONSTRAINT_NAME INTO v_constraintName
			FROM USER_CONSTRAINTS 
			WHERE TABLE_NAME = UPPER('WFWebServiceInfoTable') AND constraint_type = 'P';

			EXECUTE IMMEDIATE 'Alter Table WFWebServiceInfoTable Drop Constraint ' || TO_CHAR(v_constraintName);
			EXECUTE IMMEDIATE 'Alter Table WFWebServiceInfoTable Add Constraint ' || TO_CHAR(v_constraintName) || ' Primary Key (ProcessDefId, WSDLURLId)';
			DBMS_OUTPUT.PUT_LINE('Primary Key Updated for WFWebServiceInfoTable');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
			BEGIN
			EXECUTE IMMEDIATE 'Alter Table WFWebServiceInfoTable Add Primary Key (ProcessDefId, WSDLURLId)';
				DBMS_OUTPUT.PUT_LINE('Primary Key added for WFWebServiceInfoTable');
			EXCEPTION
			WHEN OTHERS THEN
				DBMS_OUTPUT.PUT_LINE ('An error was encountered -' || SQLERRM);
				DBMS_OUTPUT.PUT_LINE ('ERROR CODE :' || SQLCODE);
			END;
		END;
		
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(154);   
			raise_application_error(-20354,v_scriptName ||' BLOCK 154 FAILED');
	END;
	v_logStatus := LogUpdate(154);

		

	v_logStatus := LogInsert(155,'Modifying columns WORKSTEPNAME,TYPE,GENERATESAMEPARENT in table WFCREATECHILDWITABLE');
	BEGIN
		
		BEGIN
				v_logStatus := LogSkip(155);
				IF (checkIFColExist('WFCREATECHILDWITABLE','WORKSTEPNAME'))
				THEN
					EXECUTE IMMEDIATE 'ALTER TABLE WFCREATECHILDWITABLE MODIFY (WORKSTEPNAME NVARCHAR2(255))';
					DBMS_OUTPUT.PUT_LINE('Table WFCREATECHILDWITABLE column WORKSTEPNAME modified');
				END IF;
				
				IF (checkIFColExist('WFCREATECHILDWITABLE','TYPE'))
				THEN
					EXECUTE IMMEDIATE 'ALTER TABLE WFCREATECHILDWITABLE MODIFY (TYPE NVARCHAR2(1))';
					DBMS_OUTPUT.PUT_LINE('Table WFCREATECHILDWITABLE column TYPE modified');				
				END IF;
				
				IF (checkIFColExist('WFCREATECHILDWITABLE','GENERATESAMEPARENT'))
				THEN
					EXECUTE IMMEDIATE 'ALTER TABLE WFCREATECHILDWITABLE MODIFY (GENERATESAMEPARENT NVARCHAR2(1))';
					DBMS_OUTPUT.PUT_LINE('Table WFCREATECHILDWITABLE column GENERATESAMEPARENT modified');				
				END IF;
				
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(155);   
			raise_application_error(-20355,v_scriptName ||' BLOCK 155 FAILED');
	END;
	v_logStatus := LogUpdate(155);

		
		

	v_logStatus := LogInsert(156,'Adding Table WFCREATECHILDWITABLE Primary Key (PROCESSDEFID , TRIGGERID)');
	BEGIN
		
		BEGIN
			v_logStatus := LogSkip(156);
			SELECT CONSTRAINT_NAME INTO v_constraintName
			FROM USER_CONSTRAINTS 
			WHERE TABLE_NAME = UPPER('WFCREATECHILDWITABLE') AND constraint_type = 'P';

			EXECUTE IMMEDIATE 'Alter Table WFCREATECHILDWITABLE Drop Constraint ' || TO_CHAR(v_constraintName);
			EXECUTE IMMEDIATE 'Alter Table WFCREATECHILDWITABLE Add Constraint ' || TO_CHAR(v_constraintName) || ' Primary Key (PROCESSDEFID , TRIGGERID)';
			DBMS_OUTPUT.PUT_LINE('Primary Key Updated for WFCREATECHILDWITABLE');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
			BEGIN
			EXECUTE IMMEDIATE 'Alter Table WFCREATECHILDWITABLE Add Primary Key (PROCESSDEFID , TRIGGERID)';
				DBMS_OUTPUT.PUT_LINE('Primary Key added for WFCREATECHILDWITABLE');
			EXCEPTION
			WHEN OTHERS THEN
				DBMS_OUTPUT.PUT_LINE (SQLERRM);
				DBMS_OUTPUT.PUT_LINE (SQLCODE);
			END;
		END;

	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(156);   
			raise_application_error(-20356,v_scriptName ||' BLOCK 156 FAILED');
	END;
	v_logStatus := LogUpdate(156);

		
		
		
	v_logStatus := LogInsert(157,'Modifying Column TEMPQUEUENAME,TEMPFILTERVALUE,TEMPSORTORDER to NVARCHAR2(64) in GTEMPQUEUETABLE');
	BEGIN
		
		
		
		BEGIN
			v_logStatus := LogSkip(157);
				IF (checkIFColExist('GTEMPQUEUETABLE','TEMPQUEUENAME'))
				THEN
					EXECUTE IMMEDIATE 'ALTER TABLE GTEMPQUEUETABLE MODIFY (TEMPQUEUENAME NVARCHAR2(64))';
					DBMS_OUTPUT.PUT_LINE('Table GTEMPQUEUETABLE column TEMPQUEUENAME modified');
				END IF;
				
				IF (checkIFColExist('GTEMPQUEUETABLE','TEMPFILTERVALUE'))
				THEN
					EXECUTE IMMEDIATE 'ALTER TABLE GTEMPQUEUETABLE MODIFY (TEMPFILTERVALUE NVARCHAR2(64))';
					DBMS_OUTPUT.PUT_LINE('Table GTEMPQUEUETABLE column TEMPFILTERVALUE modified');				
				END IF;
				
				IF (checkIFColExist('GTEMPQUEUETABLE','TEMPSORTORDER'))
				THEN
					EXECUTE IMMEDIATE 'ALTER TABLE GTEMPQUEUETABLE MODIFY (TEMPSORTORDER NVARCHAR2(1))';
					DBMS_OUTPUT.PUT_LINE('Table GTEMPQUEUETABLE column TEMPSORTORDER modified');				
				END IF;
				
		END;
		
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(157);   
			raise_application_error(-20357,v_scriptName ||' BLOCK 157 FAILED');
	END;
	v_logStatus := LogUpdate(157);

		
		

	v_logStatus := LogInsert(158,'Inserting value in psmversioninfo for LBL_SUP_006_14112014');
	BEGIN
		
			BEGIN
				v_logStatus := LogSkip(158);
				EXECUTE IMMEDIATE Q'{SELECT 1  
				FROM pmsversioninfo  
				WHERE label = 'LBL_SUP_006_14112014' AND product_acronym='OF'  AND previouslabel IS NULL }' INTO  existsFlag;
			EXCEPTION 
			WHEN OTHERS THEN 
			
				EXECUTE IMMEDIATE Q'{INSERT INTO pmsversioninfo(product_acronym,label, previouslabel) VALUES ('OF','LBL_SUP_006_14112014',NULL)}';
				
			END;

	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(158);   
			raise_application_error(-20358,v_scriptName ||' BLOCK 158 FAILED');
	END;
	v_logStatus := LogUpdate(158);

			

	v_logStatus := LogInsert(159,'Updating WFSEARCHVARIABLETABLE');
	BEGIN
		v_logStatus := LogSkip(159);
		EXECUTE IMMEDIATE '
		Declare
		activity_cursor	INTEGER;
		 retVal INTEGER;
		 v_procDefId INTEGER;
		 v_VariableId  INT;
		 v_ActivityId		INT;
		 i                INT;
		BEGIN  
			activity_cursor := DBMS_SQL.OPEN_CURSOR;
			DBMS_SQL.PARSE(
				activity_cursor, 
				''select ACTIVITYID, PROCESSDEFID from ACTIVITYTABLE where ACTIVITYTYPE = 1'',
				DBMS_SQL.NATIVE);
			DBMS_SQL.DEFINE_COLUMN(activity_cursor, 1, v_ActivityId);
			DBMS_SQL.DEFINE_COLUMN(activity_cursor, 2, v_procDefId);
			retVal := DBMS_SQL.EXECUTE(activity_cursor);
			LOOP
				IF DBMS_SQL.FETCH_ROWS(activity_cursor) = 0 THEN
					BEGIN
					DBMS_OUTPUT.PUT_LINE(''No record fetch for the cursor'');
					EXIT;
					END;
				END IF;
					DBMS_SQL.COLUMN_VALUE(activity_cursor, 1, v_ActivityId);
					DBMS_SQL.COLUMN_VALUE(activity_cursor, 2, v_procDefId);
			BEGIN
			
		  for i in (SELECT VARIABLEID from WFSEARCHVARIABLETABLE where ACTIVITYID = v_ActivityId  AND PROCESSDEFID = v_procDefId) 
			LOOP
			v_VariableId := i.VARIABLEID;
			BEGIN
				DBMS_OUTPUT.PUT_LINE(''Record fetch for the cursor'' || v_ActivityId);
				EXECUTE IMMEDIATE ''UPDATE WFSEARCHVARIABLETABLE SET ACTIVITYID = 0 WHERE ACTIVITYID ='' || v_ActivityId ||'' AND PROCESSDEFID =''|| v_procDefId || '' AND VARIABLEID = ''|| v_VariableId;
				EXCEPTION
				WHEN DUP_VAL_ON_INDEX THEN
				DBMS_OUTPUT.PUT_LINE(''Unique constraint violated...'');
			  END;
			END LOOP;
			END;
			END LOOP;
				DBMS_OUTPUT.PUT_LINE(''Loop ended'');
		COMMIT;
		END;';
			
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(159);   
			raise_application_error(-20359,v_scriptName ||' BLOCK 159 FAILED');
	END;
	v_logStatus := LogUpdate(159);

	
	v_logStatus := LogInsert(160,'Inserting value in WFCABVERSIONTABLE for END of Upgrade.sql for SU6');
	BEGIN
			v_logStatus := LogSkip(160);
			SELECT  cabversionid.nextval INTO v_nextseq2  FROM DUAL;
			INSERT INTO WFCabVersionTable(cabVersion, cabVersionId, creationDate, lastModified, Remarks, Status) VALUES ('9.0' ,v_nextseq2 , sysdate,sysdate , 'END of Upgrade.sql for SU6','Y');
			SELECT  cabversionid.nextval INTO v_nextseq2  FROM DUAL;
			INSERT INTO WFCabVersionTable(cabVersion, cabVersionId, creationDate, lastModified, Remarks, Status) VALUES ('9.0_SU6' ,v_nextseq2 , sysdate,sysdate , 'END of Upgrade.sql for SU6','Y');
			COMMIT;

			
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(160);   
			raise_application_error(-20360,v_scriptName ||' BLOCK 160 FAILED');
	END;
	v_logStatus := LogUpdate(160);


	
End;

~

call Upgrade()

~

DROP PROCEDURE Upgrade

~

DROP PROCEDURE dropTableIfExist