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
06/08/2013  Neeraj Sharma       Bug 41706 - Changes done in version Upgrade of OF 9.0 
30/01/2015  Chitvan Chhabra		Bug 53109 - Version Upgrade:preventing unnecessary update of varmapping table's variableid and moving of view from one location to other because of non availability of calendar column 
04/02/2015	Chitvan Chhabra		Bug 53167 - Version Upgrade : Correcting printfaxemaildoctype and Printfax email and WFcalendar based issues  
15/07/2015	Dinkar Kad			Bug 55876 - Showing error while checkin and check out out route in Process Modeler, after upgrading from Omniflow 8 to newer versions like OF 9 and OF 10
06/01/2015	Dinkar Kad			Bug 58528 - After upgrading a cabinet from Omniflow 8 to omniflow 10, already configured Search Variable are not visible in Advance Search.
26/05/2017		Sanal Grover		Bug 62518 - Step by Step Debugs in Version Upgrade.
________________________________________________________________________________________________________________-*/
CREATE OR REPLACE PROCEDURE Upgrade07 AS
	existsFlag			INTEGER;
	v_lastSeqValue			INTEGER;
	v_ProcessDefId			INTEGER;
	v_cabVersion		    VARCHAR2(2000);
	v_STR1			        VARCHAR2(8000);
	v_constraintName		VARCHAR2(512);
	v_procDefId			 INT;
	v_CalendarId 		INT;
	v_temp 		INT;
	v_logStatus 			BOOLEAN;
	v_scriptName            NVARCHAR2(100) := 'Upgrade09_SP00_010';
		
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
	
BEGIN	

		
	v_logStatus := LogInsert(1,'CREATE SEQUENCE CABVERSIONID');
	BEGIN
			
		BEGIN
			SELECT LAST_NUMBER INTO v_lastSeqValue
			FROM USER_SEQUENCES
			WHERE SEQUENCE_NAME = UPPER('cabVersionId');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_logStatus := LogSkip(1);
				EXECUTE IMMEDIATE 'CREATE SEQUENCE CABVERSIONID INCREMENT BY 1 START WITH 1';
				dbms_output.put_line ('SEQUENCE CABVERSIONID Successfully Created');
		END;

	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(1);   
			raise_application_error(-20201,v_scriptName ||' BLOCK 1 FAILED');
	END;
	v_logStatus := LogUpdate(1);


	v_logStatus := LogInsert(2,'CREATE TABLE WFSAPConnectTable ');
	BEGIN
		/*SrNo-15, New tables added for SAP integration by Ruhi Hira.*/

		BEGIN 
			SELECT 1 INTO existsFlag 
			FROM USER_TABLES  
			WHERE TABLE_NAME = UPPER('WFSAPConnectTable');
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
				v_logStatus := LogSkip(2);
				EXECUTE IMMEDIATE 
				'CREATE TABLE WFSAPConnectTable (
					ProcessDefId		INT						NOT NULL	PRIMARY KEY,
					SAPHostName			NVARCHAR2(64)	        NOT NULL,
					SAPInstance			NVARCHAR2(2)			NOT NULL,
					SAPClient			NVARCHAR2(3)			NOT NULL,
					SAPUserName			NVARCHAR2(256)				NULL,
					SAPPassword			NVARCHAR2(512)				NULL,
					SAPHttpProtocol		NVARCHAR2(8)				NULL,
					SAPITSFlag			NVARCHAR2(1)				NULL,
					SAPLanguage			NVARCHAR2(8)				NULL,
					SAPHttpPort			INT							NULL
				)';
			DBMS_OUTPUT.PUT_LINE ('Table WFSAPConnectTable Created successfully');
		END;
		
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(2);   
			raise_application_error(-20202,v_scriptName ||' BLOCK 2 FAILED');
	END;
	v_logStatus := LogUpdate(2);

	v_logStatus := LogInsert(3,'CREATE TABLE WFSAPGUIDefTable');
	BEGIN
		/*Modified on 23-06-2009 by Ananta Handoo .Three fields added TCodeType, VariableId, VarFieldId */
		BEGIN 
			SELECT 1 INTO existsFlag 
			FROM USER_TABLES  
			WHERE TABLE_NAME = UPPER('WFSAPGUIDefTable');
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
				v_logStatus := LogSkip(3);
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
			v_logStatus := LogUpdateError(3);   
			raise_application_error(-20203,v_scriptName ||' BLOCK 3 FAILED');
	END;
	v_logStatus := LogUpdate(3);

	v_logStatus := LogInsert(4,'CREATE TABLE WFSAPGUIFieldMappingTable');
	BEGIN
		BEGIN 
			SELECT 1 INTO existsFlag 
			FROM USER_TABLES  
			WHERE TABLE_NAME = UPPER('WFSAPGUIFieldMappingTable');
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
				v_logStatus := LogSkip(4);
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
			v_logStatus := LogUpdateError(4);   
			raise_application_error(-20204,v_scriptName ||' BLOCK 4 FAILED');
	END;
	v_logStatus := LogUpdate(4);
		

	v_logStatus := LogInsert(5,'CREATE TABLE WFSAPGUIAssocTable');
	BEGIN
		BEGIN 
			SELECT 1 INTO existsFlag 
			FROM USER_TABLES  
			WHERE TABLE_NAME = UPPER('WFSAPGUIAssocTable');
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
				v_logStatus := LogSkip(5);
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
			v_logStatus := LogUpdateError(5);   
			raise_application_error(-20205,v_scriptName ||' BLOCK 5 FAILED');
	END;
	v_logStatus := LogUpdate(5);

	v_logStatus := LogInsert(6,'CREATE TABLE WFSAPAdapterAssocTable');
	BEGIN
	/* New table WFSAPAdapterAssocTable added for SAP Integration.*/
	   BEGIN 
			SELECT 1 INTO existsFlag 
			FROM USER_TABLES  
			WHERE TABLE_NAME = UPPER('WFSAPAdapterAssocTable');
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
				v_logStatus := LogSkip(6);
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
			v_logStatus := LogUpdateError(6);   
			raise_application_error(-20206,v_scriptName ||' BLOCK 6 FAILED');
	END;
	v_logStatus := LogUpdate(6);

	v_logStatus := LogInsert(7,'Modifying column EXCEPTIONCOMMENTS to NVARCHAR2(512) IN EXCEPTIONTABLE');
	BEGIN
		BEGIN
			existsFlag:=0;
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME='EXCEPTIONTABLE'
			AND COLUMN_NAME=UPPER('EXCEPTIONCOMMENTS')
			AND	DATA_TYPE='NVARCHAR2'
			AND DATA_LENGTH>=512; 
			EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_logStatus := LogSkip(7);
				EXECUTE IMMEDIATE 'ALTER TABLE EXCEPTIONTABLE MODIFY (EXCEPTIONCOMMENTS NVARCHAR2(512))';
		END;
		
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(7);   
			raise_application_error(-20207,v_scriptName ||' BLOCK 7 FAILED');
	END;
	v_logStatus := LogUpdate(7);
		
		

	v_logStatus := LogInsert(8,'Modifying column ARGLIST to NVARCHAR2(512) IN TEMPLATEDEFINITIONTABLE');
	BEGIN
		BEGIN
			existsFlag:=0;
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME='TEMPLATEDEFINITIONTABLE'
			AND COLUMN_NAME=UPPER('ARGLIST')
			AND	DATA_TYPE='NVARCHAR2'
			AND DATA_LENGTH>=2000;
			EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_logStatus := LogSkip(8);
				EXECUTE IMMEDIATE 'ALTER TABLE TEMPLATEDEFINITIONTABLE MODIFY (ARGLIST NVARCHAR2(2000))';
		END;
		
		
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(8);   
			raise_application_error(-20208,v_scriptName ||' BLOCK 8 FAILED');
	END;
	v_logStatus := LogUpdate(8);	
		

	v_logStatus := LogInsert(9,'Recreating Table MAILTRIGGERTABLE');
	BEGIN
		BEGIN
			v_logStatus := LogSkip(9);
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('MAILTRIGGERTABLE') 
			AND 
			COLUMN_NAME=UPPER('Message')
			AND
			DATA_TYPE=UPPER('NCLOB');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
			
			BEGIN
				SELECT 1 INTO existsFlag 
				FROM USER_Tables
				WHERE TABLE_NAME=UPPER('MAILTRIGGERTABLE2');         
			EXCEPTION
			  WHEN NO_DATA_FOUND THEN
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
			END;
						EXECUTE IMMEDIATE 'INSERT INTO MAILTRIGGERTABLE2 SELECT 
											ProcessDefId,TriggerID,Subject,FromUser,FromUserType,
											ExtObjIDFromUser,VariableIdFrom,VarFieldIdFrom,
											ToUser,ToType,ExtObjIDTo,VariableIdTo,VarFieldIdTo,CCUser,CCType,
											ExtObjIDCC,VariableIdCc,VarFieldIdCc,Message FROM MAILTRIGGERTABLE'; 
						EXECUTE IMMEDIATE 'RENAME MAILTRIGGERTABLE TO MAILTRIGGERTABLE_Patch8'; 
						EXECUTE IMMEDIATE 'RENAME MAILTRIGGERTABLE2 TO MAILTRIGGERTABLE';
						EXECUTE IMMEDIATE 'DROP TABLE MAILTRIGGERTABLE_Patch8';
				COMMIT; 
		END;
		
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(9);   
			raise_application_error(-20209,v_scriptName ||' BLOCK 9 FAILED');
	END;
	v_logStatus := LogUpdate(9);

	v_logStatus := LogInsert(10,'Adding new column InputBuffer,OutputBuffer in WFWebServiceTable');
	BEGIN
		BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('WFWebServiceTable') 
			AND 
			COLUMN_NAME=UPPER('InputBuffer');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_logStatus := LogSkip(10);
				EXECUTE IMMEDIATE 'ALTER TABLE WFWebServiceTable Add InputBuffer NCLOB';
				DBMS_OUTPUT.PUT_LINE('Table WFWebServiceTable altered with new Column InputBuffer');
				EXECUTE IMMEDIATE 'ALTER TABLE WFWebServiceTable Add OutputBuffer NCLOB';
				DBMS_OUTPUT.PUT_LINE('Table WFWebServiceTable altered with new Column OutputBuffer');
		END;
		
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(10);   
			raise_application_error(-20210,v_scriptName ||' BLOCK 10 FAILED');
	END;
	v_logStatus := LogUpdate(10);

	v_logStatus := LogInsert(11,'CREATE TABLE WFPDATable');
	BEGIN
		/* Added by Ishu Saraf - 17/06/2009 */
		BEGIN 
			SELECT 1 INTO existsFlag 
			FROM USER_TABLES  
			WHERE TABLE_NAME = UPPER('WFPDATable');
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
				v_logStatus := LogSkip(11);
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
			v_logStatus := LogUpdateError(11);   
			raise_application_error(-20211,v_scriptName ||' BLOCK 11 FAILED');
	END;
	v_logStatus := LogUpdate(11);

	v_logStatus := LogInsert(12,'CREATE TABLE WFPDA_FormTable');
	BEGIN
		/* Added by Ishu Saraf - 17/06/2009 */
		BEGIN 
			SELECT 1 INTO existsFlag 
			FROM USER_TABLES  
			WHERE TABLE_NAME = UPPER('WFPDA_FormTable');
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
				v_logStatus := LogSkip(12);
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
			v_logStatus := LogUpdateError(12);   
			raise_application_error(-20212,v_scriptName ||' BLOCK 12 FAILED');
	END;
	v_logStatus := LogUpdate(12);

	v_logStatus := LogInsert(13,'CREATE TABLE WFPDAControlValueTable');
	BEGIN
		/* Added by Ishu Saraf - 17/06/2009 */
		BEGIN 
			SELECT 1 INTO existsFlag 
			FROM USER_TABLES  
			WHERE TABLE_NAME = UPPER('WFPDAControlValueTable');
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
				v_logStatus := LogSkip(13);
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
			v_logStatus := LogUpdateError(13);   
			raise_application_error(-20213,v_scriptName ||' BLOCK 13 FAILED');
	END;
	v_logStatus := LogUpdate(13);

	v_logStatus := LogInsert(14,'Adding new column VariableId,VarFieldId in PrintFaxEmailDocTypeTable');
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
				v_logStatus := LogSkip(14);
				EXECUTE IMMEDIATE 'ALTER TABLE PrintFaxEmailDocTypeTable Add ( VariableId INT default  0, VarFieldId INT default  0)';
				
				EXECUTE IMMEDIATE 'UPDATE PrintFaxEmailDocTypeTable SET VariableId = 0 WHERE VariableId IS NULL';
				
				EXECUTE IMMEDIATE 'UPDATE PrintFaxEmailDocTypeTable SET VarFieldId = 0 WHERE VarFieldId IS NULL';

				DBMS_OUTPUT.PUT_LINE('Table PrintFaxEmailDocTypeTable altered with two new Columns VariableId and VarFieldId');
		END;
		
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(14);   
			raise_application_error(-20214,v_scriptName ||' BLOCK 14 FAILED');
	END;
	v_logStatus := LogUpdate(14);

	v_logStatus := LogInsert(15,'Adding new column QUERYPREVIEW in QUEUEUSERTABLE');
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
				v_logStatus := LogSkip(15);
				EXECUTE IMMEDIATE 'ALTER TABLE "QUEUEUSERTABLE" ADD "QUERYPREVIEW" NVARCHAR2(1) DEFAULT (N''Y'')'; 
			END IF;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(15);   
			raise_application_error(-20215,v_scriptName ||' BLOCK 15 FAILED');
	END;
	v_logStatus := LogUpdate(15);

	v_logStatus := LogInsert(16,'CREATING VIEW QUSERGROUPVIEW');
	BEGIN		
		BEGIN
			v_logStatus := LogSkip(16);
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
			v_logStatus := LogUpdateError(16);   
			raise_application_error(-20216,v_scriptName ||' BLOCK 16 FAILED');
	END;
	v_logStatus := LogUpdate(16);

	v_logStatus := LogInsert(17,'Inserting value in WFCabVersionTable for 7.2_CalendarName_VarMapping');
	BEGIN
		BEGIN
		SELECT CabVersion INTO v_cabVersion FROM WFCABVERSIONTABLE WHERE CabVersion = '7.2_CalendarName_VarMapping' AND ROWNUM <= 1;
		EXCEPTION 
		WHEN NO_DATA_FOUND THEN
		BEGIN
			v_logStatus := LogSkip(17);
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
			v_logStatus := LogUpdateError(17);   
			raise_application_error(-20217,v_scriptName ||' BLOCK 17 FAILED');
	END;
	v_logStatus := LogUpdate(17);

	v_logStatus := LogInsert(18,'CREATE TABLE WFExtInterfaceConditionTable');
	BEGIN
		/*WFS_8.0_026 - workitem specific calendar*/

		/*Added by Saurabh Kamal for Rules on External Interfaces*/
		BEGIN 
			SELECT 1 INTO existsFlag 
			FROM USER_TABLES  
			WHERE TABLE_NAME = UPPER('WFExtInterfaceConditionTable');
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
				v_logStatus := LogSkip(18);
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
			v_logStatus := LogUpdateError(18);   
			raise_application_error(-20218,v_scriptName ||' BLOCK 18 FAILED');
	END;
	v_logStatus := LogUpdate(18);        

	v_logStatus := LogInsert(19,'CREATE TABLE WFExtInterfaceOperationTable');
	BEGIN
		BEGIN 
			SELECT 1 INTO existsFlag 
			FROM USER_TABLES  
			WHERE TABLE_NAME = UPPER('WFExtInterfaceOperationTable');
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
				v_logStatus := LogSkip(19);
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
			v_logStatus := LogUpdateError(19);   
			raise_application_error(-20219,v_scriptName ||' BLOCK 19 FAILED');
	END;
	v_logStatus := LogUpdate(19);


	v_logStatus := LogInsert(20,'Adding new column REFRESHINTERVAL in QUEUEDEFTABLE');
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
				v_logStatus := LogSkip(20);
				EXECUTE IMMEDIATE 'ALTER TABLE "QUEUEDEFTABLE" ADD "REFRESHINTERVAL" INT '; 
			END IF;
		END;
		
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(20);   
			raise_application_error(-20220,v_scriptName ||' BLOCK 20 FAILED');
	END;
	v_logStatus := LogUpdate(20);	
	
	v_logStatus := LogInsert(21,'Adding new column TEMPREFRESHINTERVAL in GTEMPQUEUETABLE');
	BEGIN

		BEGIN
			existsFlag := 0;	
			BEGIN 
				SELECT 1 INTO existsFlag 
				FROM DUAL 
				WHERE 
					NOT EXISTS( SELECT 1 FROM USER_TAB_COLUMNS  
						WHERE UPPER(TABLE_NAME) = 'GTEMPQUEUETABLE'
						AND UPPER(COLUMN_NAME) = 'TEMPREFRESHINTERVAL'			
					);  
			EXCEPTION 
				WHEN NO_DATA_FOUND THEN 
					existsFlag := 0; 
			END; 
			IF existsFlag = 1 THEN
				v_logStatus := LogSkip(21);
				EXECUTE IMMEDIATE 'ALTER TABLE "GTEMPQUEUETABLE" ADD "TEMPREFRESHINTERVAL" INT '; 
			END IF;
		END;
			
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(21);   
			raise_application_error(-20221,v_scriptName ||' BLOCK 21 FAILED');
	END;
	v_logStatus := LogUpdate(21);	
		

	v_logStatus := LogInsert(22,'Adding new column SORTORDER in QUEUEDEFTABLE');
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
				v_logStatus := LogSkip(22);
				EXECUTE IMMEDIATE 'ALTER TABLE "QUEUEDEFTABLE" ADD "SORTORDER" NVARCHAR2(1)'; 
			END IF;
		END;
		
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(22);   
			raise_application_error(-20222,v_scriptName ||' BLOCK 22 FAILED');
	END;
	v_logStatus := LogUpdate(22);	
	

	v_logStatus := LogInsert(23,'Adding new column TEMPORDERBY in GTEMPQUEUETABLE');
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
				v_logStatus := LogSkip(23);
				EXECUTE IMMEDIATE 'ALTER TABLE "GTEMPQUEUETABLE" ADD "TEMPORDERBY" INT '; 
			END IF;
		END;
		
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(23);   
			raise_application_error(-20223,v_scriptName ||' BLOCK 23 FAILED');
	END;
	v_logStatus := LogUpdate(23);

	v_logStatus := LogInsert(24,'Adding new column TEMPSORTORDER in GTEMPQUEUETABLE');
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
				v_logStatus := LogSkip(24);
				EXECUTE IMMEDIATE 'ALTER TABLE "GTEMPQUEUETABLE" ADD "TEMPSORTORDER" NVARCHAR2(1)'; 
			END IF;
		END;
		
		
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(24);   
			raise_application_error(-20224,v_scriptName ||' BLOCK 24 FAILED');
	END;
	v_logStatus := LogUpdate(24);

	v_logStatus := LogInsert(25,'Inserting value in VarMappingTable for 7.2_TurnAroundDateTime_VarMapping');
	BEGIN
		/* WFS_8.0_044 Support of TurnAroundDateTime in FetchWorkList and SearchWorkitem*/
		BEGIN
		SELECT CabVersion INTO v_cabVersion FROM WFCABVERSIONTABLE WHERE CabVersion = '7.2_TurnAroundDateTime_VarMapping' AND ROWNUM <= 1;
		EXCEPTION 
		WHEN NO_DATA_FOUND THEN
		BEGIN
			v_logStatus := LogSkip(25);
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
			v_logStatus := LogUpdateError(25);   
			raise_application_error(-20225,v_scriptName ||' BLOCK 25 FAILED');
	END;
	v_logStatus := LogUpdate(25);
		

	v_logStatus := LogInsert(26,'CREATE TABLE WFImportFileData ,CREATE SEQUENCE SEQ_WFImportFileId');
	BEGIN
		BEGIN 
			SELECT 1 INTO existsFlag 
			FROM USER_TABLES  
			WHERE TABLE_NAME = UPPER('WFImportFileData');
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
				v_logStatus := LogSkip(26);
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
			v_logStatus := LogUpdateError(26);   
			raise_application_error(-20226,v_scriptName ||' BLOCK 26 FAILED');
	END;
	v_logStatus := LogUpdate(26);

	v_logStatus := LogInsert(27,'Adding new column ProcessDefId in VarAliasTable');
	BEGIN
		BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('VarAliasTable') 
			AND 
			COLUMN_NAME=UPPER('ProcessDefId');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_logStatus := LogSkip(27);
				EXECUTE IMMEDIATE 'ALTER TABLE VarAliasTable ADD ProcessDefId INT DEFAULT 0 NOT NULL';
				DBMS_OUTPUT.PUT_LINE('Table VarAliasTable altered with new Column ProcessDefId');			
		END;
		
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(27);   
			raise_application_error(-20227,v_scriptName ||' BLOCK 27 FAILED');
	END;
	v_logStatus := LogUpdate(27);	

	v_logStatus := LogInsert(28,'Updating Primary Key for varaliastable');
	BEGIN
		BEGIN
			v_logStatus := LogSkip(28);
			SELECT CONSTRAINT_NAME INTO v_constraintName
				FROM USER_CONSTRAINTS 
				WHERE TABLE_NAME = UPPER('varaliastable') AND constraint_type = 'P';

				EXECUTE IMMEDIATE 'Alter Table varaliastable Drop Constraint ' || TO_CHAR(v_constraintName);
				existsFlag := 0;
				BEGIN
					Select 1 into existsflag from user_indexes where index_name = TO_CHAR(v_constraintName);
					EXCEPTION 
					WHEN NO_DATA_FOUND THEN 
						existsFlag := 0; 
				END;
				IF existsFlag = 1 THEN
					EXECUTE IMMEDIATE 'DROP INDEX ' || TO_CHAR(v_constraintName) || '';
				END IF;
				EXECUTE IMMEDIATE 'Alter Table varaliastable Add Constraint ' || TO_CHAR(v_constraintName) || ' Primary Key (queueid, alias, processdefid)';
				DBMS_OUTPUT.PUT_LINE('Primary Key Updated for varaliastable');
			EXCEPTION
				WHEN NO_DATA_FOUND THEN
					DBMS_OUTPUT.PUT_LINE('No Primary Key Exists for varaliastable');
		END;	
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(28);   
			raise_application_error(-20228,v_scriptName ||' BLOCK 28 FAILED');
	END;
	v_logStatus := LogUpdate(28);	
	

	v_logStatus := LogInsert(29,'CREATE TABLE WFPURGECRITERIATABLE');
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
			v_logStatus := LogSkip(29);
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
			v_logStatus := LogUpdateError(29);   
			raise_application_error(-20229,v_scriptName ||' BLOCK 29 FAILED');
	END;
	v_logStatus := LogUpdate(29);
	
	v_logStatus := LogInsert(30,'CREATE TABLE WFEXPORTINFOTABLE');
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
			v_logStatus := LogSkip(30);
			EXECUTE IMMEDIATE 
			'CREATE TABLE WFEXPORTINFOTABLE
			(
				SOURCEUSERNAME		NVARCHAR2(255)	NOT NULL,
				SOURCEPASSWORD		NVARCHAR2(255)	NOT NULL,
				KEEPSOURCEIS            NVARCHAR2(1),
				TARGETCABINETNAME	NVARCHAR2(255)	NOT NULL,
				APPSERVERIP		NVARCHAR2(20),
				APPSERVERPORT		INT,
				TARGETUSERNAME		NVARCHAR2(200)	NOT NULL,
				TARGETPASSWORD		NVARCHAR2(200)	NOT NULL,
				SITEID			NUMBER ,
				VOLUMEID		NUMBER ,
				WEBSERVERINFO		NVARCHAR2(255)
			)';	
		END IF;	
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(30);   
			raise_application_error(-20230,v_scriptName ||' BLOCK 30 FAILED');
	END;
	v_logStatus := LogUpdate(30);


	v_logStatus := LogInsert(31,'CREATE TABLE WFSOURCECABINETINFOTABLE');
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
			v_logStatus := LogSkip(31);
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
			v_logStatus := LogUpdateError(31);   
			raise_application_error(-20231,v_scriptName ||' BLOCK 31 FAILED');
	END;
	v_logStatus := LogUpdate(31);
	
	v_logStatus := LogInsert(32,'Adding new column ALIASRULE in VARALIASTABLE');
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
			v_logStatus := LogSkip(32);
			EXECUTE IMMEDIATE 'ALTER TABLE VARALIASTABLE ADD (ALIASRULE NVARCHAR2(2000))';
			DBMS_OUTPUT.PUT_LINE('TABLE VARALIASTABLE ALTERED WITH NEW COLUMN ALIASRULE ADDED');
		END IF;	
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(32);   
			raise_application_error(-20232,v_scriptName ||' BLOCK 32 FAILED');
	END;
	v_logStatus := LogUpdate(32);	
		

	v_logStatus := LogInsert(33,'CREATE TABLE WFFORMFRAGMENTTABLE');
	BEGIN
		EXISTSFLAG := 0;
		BEGIN
			SELECT 1 INTO EXISTSFLAG 
			FROM DUAL WHERE NOT EXISTS( SELECT 1 FROM USER_TABLES WHERE UPPER(TABLE_NAME) = 'WFFORMFRAGMENTTABLE');  
		EXCEPTION
			WHEN NO_DATA_FOUND THEN 
				EXISTSFLAG := 0; 
		END;
		IF EXISTSFLAG = 1 THEN
			v_logStatus := LogSkip(33);
			EXECUTE IMMEDIATE 
			'CREATE TABLE WFFORMFRAGMENTTABLE(	
			ProcessDefId	int 		   NOT NULL,
			FragmentId	    int 		   NOT NULL,
			FragmentName	VARCHAR(50)    NOT NULL,
			FragmentBuffer	BLOB           NULL,
			IsEncrypted	    VARCHAR(1)     NOT NULL,
			StructureName	VARCHAR(290)   NOT NULL,
			StructureId	    int            NOT NULL
			)';
		END IF;
		
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(33);   
			raise_application_error(-20233,v_scriptName ||' BLOCK 33 FAILED');
	END;
	v_logStatus := LogUpdate(33);  

	v_logStatus := LogInsert(34,'CREATE TABLE WFQueueColorTable');
	BEGIN
		BEGIN 
			SELECT 1 INTO existsFlag 
			FROM USER_TABLES  
			WHERE TABLE_NAME = UPPER('WFQueueColorTable');
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
				v_logStatus := LogSkip(34);
				EXECUTE IMMEDIATE 
				'CREATE TABLE WFQueueColorTable(
					Id              INT     		NOT NULL,
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
			v_logStatus := LogUpdateError(34);   
			raise_application_error(-20234,v_scriptName ||' BLOCK 34 FAILED');
	END;
	v_logStatus := LogUpdate(34);
	
	v_logStatus := LogInsert(35,'CREATE TABLE WFAuthorizeQueueColorTable');
	BEGIN
	/*Modified on 23-06-2009 by Ananta Handoo .Three fields added TCodeType, VariableId, VarFieldId */
		BEGIN 
			SELECT 1 INTO existsFlag 
			FROM USER_TABLES  
			WHERE TABLE_NAME = UPPER('WFAuthorizeQueueColorTable');
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
				v_logStatus := LogSkip(35);
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
			v_logStatus := LogUpdateError(35);   
			raise_application_error(-20235,v_scriptName ||' BLOCK 35 FAILED');
	END;
	v_logStatus := LogUpdate(35);

 
	v_logStatus := LogInsert(36,'CREATE TABLE WFImportFileData ');
	BEGIN
		BEGIN 
			SELECT 1 INTO existsFlag 
			FROM USER_TABLES  
			WHERE TABLE_NAME = UPPER('WFImportFileData');
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
				v_logStatus := LogSkip(36);
				EXECUTE IMMEDIATE 
				'CREATE TABLE WFImportFileData (
					FileIndex	    INT,
					FileName 	    Nvarchar2(256),
					FileType 	    Nvarchar2(10),
					FileStatus	    Nvarchar2(1),
					Message	        Nvarchar2(1000),
					StartTime	    TimeStamp,
					EndTime	        TimeStamp,
					ProcessedBy     Nvarchar2(256),
					TotalRecords    INT
				)';
			DBMS_OUTPUT.PUT_LINE ('Table WFImportFileData Created successfully');
		END;
			
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(36);   
			raise_application_error(-20236,v_scriptName ||' BLOCK 36 FAILED');
	END;
	v_logStatus := LogUpdate(36);   

	v_logStatus := LogInsert(37,'CREATE TABLE WFPURGECRITERIATABLE');
	BEGIN
		BEGIN 
			SELECT 1 INTO existsFlag 
			FROM USER_TABLES  
			WHERE TABLE_NAME = UPPER('WFPURGECRITERIATABLE');
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
				v_logStatus := LogSkip(37);
				EXECUTE IMMEDIATE 
				'CREATE TABLE WFPURGECRITERIATABLE(
					PROCESSDEFID	INT		NOT NULL	PRIMARY KEY,
					OBJECTNAME	NVARCHAR2(255)	NOT NULL, 
					EXPORTFLAG	NVARCHAR2(1)	NOT NULL, 
					DATA		CLOB, 
					CONSTRAINT UK_KEY_OBJECTNAME UNIQUE (OBJECTNAME)
				)';
			DBMS_OUTPUT.PUT_LINE ('Table WFPURGECRITERIATABLE Created successfully');
		END;
		
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(37);   
			raise_application_error(-20237,v_scriptName ||' BLOCK 37 FAILED');
	END;
	v_logStatus := LogUpdate(37);

	v_logStatus := LogInsert(38,'CREATE TABLE WFEXPORTINFOTABLE');
	BEGIN
		/* New table WFSAPAdapterAssocTable added for SAP Integration.*/
	   BEGIN 
			SELECT 1 INTO existsFlag 
			FROM USER_TABLES  
			WHERE TABLE_NAME = UPPER('WFEXPORTINFOTABLE');
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
				v_logStatus := LogSkip(38);
				EXECUTE IMMEDIATE 
				'CREATE TABLE WFEXPORTINFOTABLE(
					SOURCEUSERNAME		NVARCHAR2(255)	NOT NULL,
					SOURCEPASSWORD		NVARCHAR2(255)	NOT NULL,
					KEEPSOURCEIS            NVARCHAR2(1),
					TARGETCABINETNAME	NVARCHAR2(255)	NOT NULL,
					APPSERVERIP		NVARCHAR2(20),
					APPSERVERPORT		INT,
					TARGETUSERNAME		NVARCHAR2(200)	NOT NULL,
					TARGETPASSWORD		NVARCHAR2(200)	NOT NULL,
					SITEID			NUMBER ,
					VOLUMEID		NUMBER ,
					WEBSERVERINFO		NVARCHAR2(255)
				)';
			DBMS_OUTPUT.PUT_LINE ('Table WFEXPORTINFOTABLE Created successfully');
		END;
		
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(38);   
			raise_application_error(-20238,v_scriptName ||' BLOCK 38 FAILED');
	END;
	v_logStatus := LogUpdate(38);

	v_logStatus := LogInsert(39,'CREATE TABLE WFSOURCECABINETINFOTABLE');
	BEGIN
		BEGIN 
			SELECT 1 INTO existsFlag 
			FROM USER_TABLES  
			WHERE TABLE_NAME = UPPER('WFSOURCECABINETINFOTABLE');
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
				v_logStatus := LogSkip(39);
				EXECUTE IMMEDIATE 
				'CREATE TABLE WFSOURCECABINETINFOTABLE(
					ISSOURCEIS		NVARCHAR2(1),
					SITEID			NUMBER,
					SOURCECABINET		NVARCHAR2(255),
					APPSERVERIP		NVARCHAR2(30),
					APPSERVERPORT		NUMBER
				)';
			DBMS_OUTPUT.PUT_LINE ('Table WFSOURCECABINETINFOTABLE Created successfully');
		END;
		
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(39);   
			raise_application_error(-20239,v_scriptName ||' BLOCK 39 FAILED');
	END;
	v_logStatus := LogUpdate(39);	

	v_logStatus := LogInsert(40,'CREATE TABLE WFFormFragmentTable');
	BEGIN
		BEGIN 
			SELECT 1 INTO existsFlag 
			FROM USER_TABLES  
			WHERE TABLE_NAME = UPPER('WFFormFragmentTable');
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
				v_logStatus := LogSkip(40);
				EXECUTE IMMEDIATE 
				'CREATE TABLE WFFormFragmentTable(	
					ProcessDefId	int 		   NOT NULL,
					FragmentId	    int 		   NOT NULL,
					FragmentName	VARCHAR(50)    NOT NULL,
					FragmentBuffer	BLOB           NULL,
					IsEncrypted	    VARCHAR(1)     NOT NULL,
					StructureName	VARCHAR(290)   NOT NULL,
					StructureId	    int            NOT NULL
				)';
			DBMS_OUTPUT.PUT_LINE ('Table WFFormFragmentTable Created successfully');
		END;
		
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(40);   
			raise_application_error(-20240,v_scriptName ||' BLOCK 40 FAILED');
	END;
	v_logStatus := LogUpdate(40);	

	v_logStatus := LogInsert(41,'CREATE TABLE WFTransportDataTable');
	BEGIN
		BEGIN 
			SELECT 1 INTO existsFlag 
			FROM USER_TABLES  
			WHERE TABLE_NAME = UPPER('WFTransportDataTable');
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
				v_logStatus := LogSkip(41);
				EXECUTE IMMEDIATE 
				'CREATE TABLE WFTransportDataTable  (
					TMSLogId			INT		NOT NULL PRIMARY KEY,
					RequestId     NVARCHAR2(64),
					ActionId			INT				NOT NULL,
					ActionDateTime		DATE		NOT NULL,
					ActionComments		NVARCHAR2(255),
					UserId              INT             NOT NULL,
					UserName            NVARCHAR2(64)    NOT NULL,
					Released			NVARCHAR2(1)    Default ''N'',
					ReleasedByUserId          INT,
					ReleasedBy       	NVARCHAR2(64),
					ReleasedComments	NVARCHAR2(255),
					ReleasedDateTime    DATE,
					Transported			NVARCHAR2(1)     Default ''N'',
					TransportedByUserId INT,
					TransportedBy		NVARCHAR2(64),
					TransportedDateTime DATE,
					ObjectName          NVARCHAR2(64),
					ObjectType          NVARCHAR2(1),
					ProcessDefId        INT,	
					CONSTRAINT u_TransportDataTable UNIQUE   
					(
						RequestId
					) 
				)';
			DBMS_OUTPUT.PUT_LINE ('Table WFTransportDataTable Created successfully');
		END;
		
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(41);   
			raise_application_error(-20241,v_scriptName ||' BLOCK 41 FAILED');
	END;
	v_logStatus := LogUpdate(41);	

	v_logStatus := LogInsert(42,'CREATE TABLE WFTMSAddQueue');
	BEGIN
		BEGIN 
			SELECT 1 INTO existsFlag 
			FROM USER_TABLES  
			WHERE TABLE_NAME = UPPER('WFTMSAddQueue');
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
				v_logStatus := LogSkip(42);
				EXECUTE IMMEDIATE 
				'CREATE TABLE WFTMSAddQueue (
					RequestId           NVARCHAR2(64)     NOT NULL,    
					QueueName           NVARCHAR2(64),
					RightFlag           NVARCHAR2(64),
					QueueType           NVARCHAR2(1),    
					Comments            NVARCHAR2(255),
					ZipBuffer           NVARCHAR2(1),
					AllowReassignment   NVARCHAR2(1),
					FilterOption        INT,
					FilterValue         NVARCHAR2(64),
					QueueFilter         NVARCHAR2(64),
					OrderBy             INT,
					SortOrder           NVARCHAR2(1),
					IsStreamOper        NVARCHAR2(1)     
				)';
			DBMS_OUTPUT.PUT_LINE ('Table WFTMSAddQueue Created successfully');
		END;
		
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(42);   
			raise_application_error(-20242,v_scriptName ||' BLOCK 42 FAILED');
	END;
	v_logStatus := LogUpdate(42);	

	v_logStatus := LogInsert(43,'CREATE TABLE WFTMSChangeProcessDefState');
	BEGIN
		BEGIN 
			SELECT 1 INTO existsFlag 
			FROM USER_TABLES  
			WHERE TABLE_NAME = UPPER('WFTMSChangeProcessDefState');
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
				v_logStatus := LogSkip(43);
				EXECUTE IMMEDIATE 
				'CREATE TABLE WFTMSChangeProcessDefState(
					RequestId           NVARCHAR2(64)     NOT NULL,    
					RightFlag           NVARCHAR2(64),
					ProcessDefId        INT,    
					ProcessDefState  NVARCHAR2(64),
					ProcessName         NVARCHAR2(64)
				)';
			DBMS_OUTPUT.PUT_LINE ('Table WFTMSChangeProcessDefState Created successfully');
		END;
		
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(43);   
			raise_application_error(-20243,v_scriptName ||' BLOCK 43 FAILED');
	END;
	v_logStatus := LogUpdate(43);	

	v_logStatus := LogInsert(44,'CREATE TABLE WFTMSChangeQueuePropertyEx');
	BEGIN
		BEGIN 
			SELECT 1 INTO existsFlag 
			FROM USER_TABLES  
			WHERE TABLE_NAME = UPPER('WFTMSChangeQueuePropertyEx');
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
				v_logStatus := LogSkip(44);
				EXECUTE IMMEDIATE 
				'CREATE TABLE WFTMSChangeQueuePropertyEx(
					RequestId           NVARCHAR2(64)     NOT NULL,    
					QueueName           NVARCHAR2(64),
					QueueId             INT,
					RightFlag           NVARCHAR2(64),
					ZipBuffer           NVARCHAR2(1),
					Description         NVARCHAR2(255),
					QueueType           NVARCHAR2(1),
					FilterOption        INT,
					QueueFilter         NVARCHAR2(64),
					FilterValue         NVARCHAR2(64),    
					OrderBy             INT,
					SortOrder           NVARCHAR2(1),
					AllowReassignment   NVARCHAR2(1),            
					IsStreamOper        NVARCHAR2(1),
					OriginalQueueName   NVARCHAR2(64)    
				)';
			DBMS_OUTPUT.PUT_LINE ('Table WFTMSChangeQueuePropertyEx Created successfully');
		END;
		
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(44);   
			raise_application_error(-20244,v_scriptName ||' BLOCK 44 FAILED');
	END;
	v_logStatus := LogUpdate(44);	

	v_logStatus := LogInsert(45,'CREATE TABLE WFTMSDeleteQueue');
	BEGIN
		BEGIN 
			SELECT 1 INTO existsFlag 
			FROM USER_TABLES  
			WHERE TABLE_NAME = UPPER('WFTMSDeleteQueue');
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
				v_logStatus := LogSkip(45);
				EXECUTE IMMEDIATE 
				'CREATE TABLE WFTMSDeleteQueue(
					RequestId           NVARCHAR2(64)     NOT NULL,    
					ZipBuffer           NVARCHAR2(1),
					RightFlag           NVARCHAR2(64),
					QueueId             INT     NOT NULL,
					QueueName           NVARCHAR2(64)
				)';
			DBMS_OUTPUT.PUT_LINE ('Table WFTMSDeleteQueue Created successfully');
		END;

	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(45);   
			raise_application_error(-20245,v_scriptName ||' BLOCK 45 FAILED');
	END;
	v_logStatus := LogUpdate(45);	

	v_logStatus := LogInsert(46,'CREATE TABLE WFTMSStreamOperation');
	BEGIN
		BEGIN 
			SELECT 1 INTO existsFlag 
			FROM USER_TABLES  
			WHERE TABLE_NAME = UPPER('WFTMSStreamOperation');
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
			v_logStatus := LogSkip(46);
				EXECUTE IMMEDIATE 
				'CREATE TABLE WFTMSStreamOperation(
					RequestId           NVARCHAR2(64)     NOT NULL,    
					ID                  INT,
					StreamName          NVARCHAR2(64),
					ProcessDefId        INT,
					ProcessName         NVARCHAR2(64),
					ActivityId          INT,
					ActivityName        NVARCHAR2(64),
					Operation           NVARCHAR2(1)
				)';
			DBMS_OUTPUT.PUT_LINE ('Table WFTMSStreamOperation Created successfully');
		END;

	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(46);   
			raise_application_error(-20246,v_scriptName ||' BLOCK 46 FAILED');
	END;
	v_logStatus := LogUpdate(46);	

	v_logStatus := LogInsert(47,'CREATE TABLE WFTMSSetVariableMapping');
	BEGIN
		BEGIN 
			SELECT 1 INTO existsFlag 
			FROM USER_TABLES  
			WHERE TABLE_NAME = UPPER('WFTMSSetVariableMapping');
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
				v_logStatus := LogSkip(47);
				EXECUTE IMMEDIATE 
				'CREATE TABLE WFTMSSetVariableMapping(
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
					AliasRule		    VARCHAR(4000)
				)';
			DBMS_OUTPUT.PUT_LINE ('Table WFTMSSetVariableMapping Created successfully');
		END;

	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(47);   
			raise_application_error(-20247,v_scriptName ||' BLOCK 47 FAILED');
	END;
	v_logStatus := LogUpdate(47);	
	
	v_logStatus := LogInsert(48,'CREATE TABLE WFTMSSetTurnAroundTime');
	BEGIN
		BEGIN 
			SELECT 1 INTO existsFlag 
			FROM USER_TABLES  
			WHERE TABLE_NAME = UPPER('WFTMSSetTurnAroundTime');
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
				v_logStatus := LogSkip(48);
				EXECUTE IMMEDIATE 
				'CREATE TABLE WFTMSSetTurnAroundTime(
					RequestId           NVARCHAR2(64)     NOT NULL,    
					ProcessDefId        INT,    
					ProcessName         NVARCHAR2(64),
					RightFlag           NVARCHAR2(64),
					ProcessTATMinutes   INT,           
					ProcessTATHours     INT,    
					ProcessTATDays      INT,    
					ProcessTATCalFlag   NVARCHAR2(1),    
					ActivityId          INT,
					AcitivityTATMinutes INT,
					ActivityTATHours    INT,
					ActivityTATDays     INT,
					ActivityTATCalFlag  NVARCHAR2(1)
				)';
			DBMS_OUTPUT.PUT_LINE ('Table WFTMSSetTurnAroundTime Created successfully');
		END;

	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(48);   
			raise_application_error(-20248,v_scriptName ||' BLOCK 48 FAILED');
	END;
	v_logStatus := LogUpdate(48);	

	v_logStatus := LogInsert(49,'CREATE TABLE WFTMSSetActionList');
	BEGIN
		BEGIN 
			SELECT 1 INTO existsFlag 
			FROM USER_TABLES  
			WHERE TABLE_NAME = UPPER('WFTMSSetActionList');
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
				v_logStatus := LogSkip(49);
				EXECUTE IMMEDIATE 
				'CREATE TABLE WFTMSSetActionList(
					RequestId           NVARCHAR2(64)     NOT NULL,    
					RightFlag           NVARCHAR2(64),
					EnabledList         NVARCHAR2(255),
					DisabledList        NVARCHAR2(255),
					ProcessDefId        INT,    
					ProcessName           NVARCHAR2(64),
					EnabledVarList       NVARCHAR2(255)    
				)';
			DBMS_OUTPUT.PUT_LINE ('Table WFTMSSetActionList Created successfully');
		END;
		
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(49);   
			raise_application_error(-20249,v_scriptName ||' BLOCK 49 FAILED');
	END;
	v_logStatus := LogUpdate(49);	

	v_logStatus := LogInsert(50,'CREATE TABLE WFTMSSetDynamicConstants');
	BEGIN
		BEGIN 
			SELECT 1 INTO existsFlag 
			FROM USER_TABLES  
			WHERE TABLE_NAME = UPPER('WFTMSSetDynamicConstants');
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
				v_logStatus := LogSkip(50);
				EXECUTE IMMEDIATE 
				'CREATE TABLE WFTMSSetDynamicConstants(
					RequestId           NVARCHAR2(64)     NOT NULL,    
					ProcessDefId        INT,  
					ProcessName         NVARCHAR2(64),
					RightFlag           NVARCHAR2(64),
					ConstantName        NVARCHAR2(64),
					ConstantValue       NVARCHAR2(64)
				)';
			DBMS_OUTPUT.PUT_LINE ('Table WFTMSSetDynamicConstants Created successfully');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(50);   
			raise_application_error(-20250,v_scriptName ||' BLOCK 50 FAILED');
	END;
	v_logStatus := LogUpdate(50);	
	

	v_logStatus := LogInsert(51,'CREATE TABLE WFTMSSetQuickSearchVariables');
	BEGIN
		BEGIN 
			SELECT 1 INTO existsFlag 
			FROM USER_TABLES  
			WHERE TABLE_NAME = UPPER('WFTMSSetQuickSearchVariables');
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
				v_logStatus := LogSkip(51);
				EXECUTE IMMEDIATE 
				'CREATE TABLE WFTMSSetQuickSearchVariables(
					RequestId           NVARCHAR2(64)     NOT NULL,    
					RightFlag           NVARCHAR2(64),
					Name                NVARCHAR2(64),
					Alias               NVARCHAR2(64),
					SearchAllVersion    NVARCHAR2(1),    
					ProcessDefId        INT,    
					ProcessName         NVARCHAR2(64),
					Operation           NVARCHAR2(1)
				)';
			DBMS_OUTPUT.PUT_LINE ('Table WFTMSSetQuickSearchVariables Created successfully');
		END;

	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(51);   
			raise_application_error(-20251,v_scriptName ||' BLOCK 51 FAILED');
	END;
	v_logStatus := LogUpdate(51);	
	
	v_logStatus := LogInsert(52,'CREATE TABLE WFTransportRegisterationInfo');
	BEGIN
		BEGIN 
			SELECT 1 INTO existsFlag 
			FROM USER_TABLES  
			WHERE TABLE_NAME = UPPER('WFTransportRegisterationInfo');
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
				v_logStatus := LogSkip(52);
				EXECUTE IMMEDIATE 
				'CREATE TABLE WFTransportRegisterationInfo(
					ID                          INT     PRIMARY KEY,    
					TargetEngineName           NVARCHAR2(64),
					TargetAppServerIp           NVARCHAR2(64),
					TargetAppServerPort         INT,       
					TargetAppServerType         NVARCHAR2(64),    
					UserName                    NVARCHAR2(64),    
					Password                    NVARCHAR2(64)    
				)';
			DBMS_OUTPUT.PUT_LINE ('Table WFTransportRegisterationInfo Created successfully');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(52);   
			raise_application_error(-20252,v_scriptName ||' BLOCK 52 FAILED');
	END;
	v_logStatus := LogUpdate(52);	


	v_logStatus := LogInsert(53,'Create TABLE WFTMSSetCalendarData');
	BEGIN
		BEGIN 
			SELECT 1 INTO existsFlag 
			FROM USER_TABLES  
			WHERE TABLE_NAME = UPPER('WFTMSSetCalendarData');
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
				v_logStatus := LogSkip(53);
				EXECUTE IMMEDIATE 
				'Create TABLE WFTMSSetCalendarData(
					RequestId           NVARCHAR2(64)     NOT NULL, 
					CalendarId          INT,    
					ProcessDefId        INT,
					ProcessName         NVARCHAR2(64),
					DefaultHourRange    VARCHAR(2000), 
					CalRuleDefinition   VARCHAR(4000)     
				)';
			DBMS_OUTPUT.PUT_LINE ('Table WFTMSSetCalendarData Created successfully');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(53);   
			raise_application_error(-20253,v_scriptName ||' BLOCK 53 FAILED');
	END;
	v_logStatus := LogUpdate(53);	


	v_logStatus := LogInsert(54,'Create TABLE WFTMSAddCalendar');
	BEGIN
		BEGIN 
			SELECT 1 INTO existsFlag 
			FROM USER_TABLES  
			WHERE TABLE_NAME = UPPER('WFTMSAddCalendar');
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
				v_logStatus := LogSkip(54);
				EXECUTE IMMEDIATE 
				'Create TABLE WFTMSAddCalendar(
					RequestId           NVARCHAR2(64)     NOT NULL,     
					ProcessDefId        INT,
					ProcessName         NVARCHAR2(64),
					CalendarName        NVARCHAR2(64),
					CalendarType        NVARCHAR2(1),
					Comments             NVARCHAR2(512),
					DefaultHourRange    VARCHAR(2000), 
					CalRuleDefinition   VARCHAR(4000)     
				)';
			DBMS_OUTPUT.PUT_LINE ('Table WFTMSAddCalendar Created successfully');
		END;

	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(54);   
			raise_application_error(-20254,v_scriptName ||' BLOCK 54 FAILED');
	END;
	v_logStatus := LogUpdate(54);	
	
	v_logStatus := LogInsert(55,'Create TABLE WFBPELDefTable');
	BEGIN
		BEGIN 
			SELECT 1 INTO existsFlag 
			FROM USER_TABLES  
			WHERE TABLE_NAME = UPPER('WFBPELDefTable');
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
				v_logStatus := LogSkip(55);
				EXECUTE IMMEDIATE 
				'Create TABLE WFBPELDefTable(    
					ProcessDefId        INT     NOT NULL PRIMARY KEY,
					BPELDef             CLOB    NOT NULL,
					XSDDef              CLOB    NOT NULL
				)';
			DBMS_OUTPUT.PUT_LINE ('Table WFBPELDefTable Created successfully');
		END;

	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(55);   
			raise_application_error(-20255,v_scriptName ||' BLOCK 55 FAILED');
	END;
	v_logStatus := LogUpdate(55);	
		
	v_logStatus := LogInsert(56,'CREATE TABLE WFWebServiceInfoTable');
	BEGIN
		BEGIN 
			SELECT 1 INTO existsFlag 
			FROM USER_TABLES  
			WHERE TABLE_NAME = UPPER('WFWebServiceInfoTable');
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
				v_logStatus := LogSkip(56);
				EXECUTE IMMEDIATE 
				'CREATE TABLE WFWebServiceInfoTable (
					ProcessDefId		INT				NOT NULL, 
					WSDLURLId			INT				NOT NULL,
					WSDLURL				NVARCHAR2(2000)		NULL,
					USERId				NVARCHAR2(255)		NULL,
					PWD					NVARCHAR2(255)		NULL,
					PRIMARY KEY (ProcessDefId, WSDLURLId)
				)';
			DBMS_OUTPUT.PUT_LINE ('Table WFWebServiceInfoTable Created successfully');
		END;

	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(56);   
			raise_application_error(-20256,v_scriptName ||' BLOCK 56 FAILED');
	END;
	v_logStatus := LogUpdate(56);	
		
	v_logStatus := LogInsert(57,'CREATE TABLE WFSystemServicesTable');
	BEGIN
		BEGIN 
			SELECT 1 INTO existsFlag 
			FROM USER_TABLES  
			WHERE TABLE_NAME = UPPER('WFSystemServicesTable');
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
				v_logStatus := LogSkip(57);
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
			v_logStatus := LogUpdateError(57);   
			raise_application_error(-20257,v_scriptName ||' BLOCK 57 FAILED');
	END;
	v_logStatus := LogUpdate(57);	
			

	v_logStatus := LogInsert(58,'Adding new Columns CommentFont, CommentForeColor, CommentBackColor and CommentBorderStyle in PROCESSDEFCOMMENTTABLE');
	BEGIN
		--EXECUTE IMMEDIATE 'ALTER TABLE GTEMPWORKLISTTABLE MODIFY (LOCKSTATUS NVARCHAR2(1) NULL)';
		
		BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('PROCESSDEFCOMMENTTABLE') 
			AND 
			COLUMN_NAME=UPPER('CommentFont');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_logStatus := LogSkip(58);
				EXECUTE IMMEDIATE 'create table PROCESSDEFCOMMENTTABLETEMP as select * from PROCESSDEFCOMMENTTABLE';
				EXECUTE IMMEDIATE 'delete from PROCESSDEFCOMMENTTABLE';
				EXECUTE IMMEDIATE 'ALTER TABLE PROCESSDEFCOMMENTTABLE Add ( CommentFont NVARCHAR2(255) NULL, CommentForeColor INT NULL, CommentBackColor INT  NULL, CommentBorderStyle INT NULL)';
				EXECUTE IMMEDIATE 'insert into PROCESSDEFCOMMENTTABLE select processdefid, leftpos, toppos, width, height,TYPE, comments, sourceid, targetid, ruleid,''Bookman Old Style,0,8'',-16777077,-1581081,0 from PROCESSDEFCOMMENTTABLETEMP';
				EXECUTE IMMEDIATE 'drop table PROCESSDEFCOMMENTTABLETEMP';
				DBMS_OUTPUT.PUT_LINE('Table PROCESSDEFCOMMENTTABLE altered with four new Columns CommentFont, CommentForeColor, CommentBackColor and CommentBorderStyle');
		END;
		
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(58);   
			raise_application_error(-20258,v_scriptName ||' BLOCK 58 FAILED');
	END;
	v_logStatus := LogUpdate(58);	


	v_logStatus := LogInsert(59,'Adding new column SortOrder in QUEUEDEFTABLE');
	BEGIN
		
		BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('QUEUEDEFTABLE') 
			AND 
			COLUMN_NAME=UPPER('SortOrder');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_logStatus := LogSkip(59);
				EXECUTE IMMEDIATE 'ALTER TABLE QUEUEDEFTABLE ADD SortOrder NVARCHAR2(1) NULL';
				DBMS_OUTPUT.PUT_LINE('Table QUEUEDEFTABLE altered with new Column SortOrder');			
		END;
		
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(59);   
			raise_application_error(-20259,v_scriptName ||' BLOCK 59 FAILED');
	END;
	v_logStatus := LogUpdate(59);	
		

	v_logStatus := LogInsert(60,'Adding Primary Key for QUEUEDEFTABLE');
	BEGIN
		BEGIN
			v_logStatus := LogSkip(60);
			SELECT CONSTRAINT_NAME INTO v_constraintName
			FROM USER_CONSTRAINTS 
			WHERE TABLE_NAME = UPPER('QUEUEDEFTABLE') AND constraint_type = 'P';

			EXECUTE IMMEDIATE 'Alter Table QUEUEDEFTABLE Drop Constraint ' || TO_CHAR(v_constraintName);
			EXECUTE IMMEDIATE 'Alter Table QUEUEDEFTABLE Add Constraint ' || TO_CHAR(v_constraintName) || ' Primary Key (QueueID)';
			DBMS_OUTPUT.PUT_LINE('Primary Key Updated for QUEUEDEFTABLE');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'Alter Table QUEUEDEFTABLE Add Primary Key (QueueID)';
				DBMS_OUTPUT.PUT_LINE('Primary Key added for QUEUEDEFTABLE');
		END;
		
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(60);   
			raise_application_error(-20260,v_scriptName ||' BLOCK 60 FAILED');
	END;
	v_logStatus := LogUpdate(60);	
		

	v_logStatus := LogInsert(61,'Adding Unique constraint U_QDTTABLE for QUEUEDEFTABLE');
	BEGIN
		BEGIN
			v_logStatus := LogSkip(61);
			SELECT CONSTRAINT_NAME INTO v_constraintName
			FROM USER_CONSTRAINTS 
			WHERE TABLE_NAME = UPPER('QUEUEDEFTABLE') AND CONSTRAINT_NAME = UPPER('U_QDTTABLE')  AND constraint_type = 'U';

			EXECUTE IMMEDIATE 'Alter Table QUEUEDEFTABLE Drop Constraint ' || TO_CHAR(v_constraintName);
			EXECUTE IMMEDIATE 'Alter Table QUEUEDEFTABLE Add Constraint ' || TO_CHAR(v_constraintName) || ' UNIQUE (QueueName) ';
			DBMS_OUTPUT.PUT_LINE('Unique constraint'||v_constraintName||' Updated for QUEUEDEFTABLE');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'Alter Table QUEUEDEFTABLE Add Constraint U_QDTTABLE UNIQUE (QueueName)';
				DBMS_OUTPUT.PUT_LINE('Unique constraint U_QDTTABLE added for QUEUEDEFTABLE');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(61);   
			raise_application_error(-20261,v_scriptName ||' BLOCK 61 FAILED');
	END;
	v_logStatus := LogUpdate(61);	
		
	

	v_logStatus := LogInsert(62,'Adding new column AliasRule in VARALIASTABLE');
	BEGIN
		BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('VARALIASTABLE') 
			AND 
			COLUMN_NAME=UPPER('AliasRule');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_logStatus := LogSkip(62);
				EXECUTE IMMEDIATE 'ALTER TABLE VARALIASTABLE ADD AliasRule NVARCHAR2(2000) NULL';
				DBMS_OUTPUT.PUT_LINE('Table VARALIASTABLE altered with new Column AliasRule');			
		END;

	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(62);   
			raise_application_error(-20262,v_scriptName ||' BLOCK 62 FAILED');
	END;
	v_logStatus := LogUpdate(62);	
		
	
	v_logStatus := LogInsert(63,'Adding new Columns TempOrderBy and TempSortOrder in GTempQueueTable');
	BEGIN
		
		BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('GTempQueueTable') 
			AND COLUMN_NAME=UPPER('TempOrderBy');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_logStatus := LogSkip(63);
				EXECUTE IMMEDIATE 'ALTER TABLE GTempQueueTable ADD ( TempOrderBy INT, TempSortOrder NVarchar2(1))';
				DBMS_OUTPUT.PUT_LINE('Table GTempQueueTable altered with two new Columns TempOrderBy and TempSortOrder');
		END;

	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(63);   
			raise_application_error(-20263,v_scriptName ||' BLOCK 63 FAILED');
	END;
	v_logStatus := LogUpdate(63);	
	
	v_logStatus := LogInsert(64,'Adding new Columns SwimLaneType, SwimLaneText and SwimLaneTextColor in WFSwimLaneTable');
	BEGIN
		BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('WFSwimLaneTable') 
			AND COLUMN_NAME=UPPER('SwimLaneType');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_logStatus := LogSkip(64);
				EXECUTE IMMEDIATE 'ALTER TABLE WFSwimLaneTable ADD ( SwimLaneType  NVARCHAR2(1) DEFAULT (''H'') NOT NULL, SwimLaneText NVARCHAR2(255) DEFAULT (''HORIZONTAL LANE'') NOT NULL, SwimLaneTextColor INTEGER DEFAULT (-16777216) NOT NULL )';
				DBMS_OUTPUT.PUT_LINE('Table WFSwimLaneTable altered with three new Columns SwimLaneType, SwimLaneText and SwimLaneTextColor');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(64);   
			raise_application_error(-20264,v_scriptName ||' BLOCK 64 FAILED');
	END;
	v_logStatus := LogUpdate(64);	
	

	v_logStatus := LogInsert(65,'Adding new column SortOrder in WFAuthorizeQueueDefTable');
	BEGIN
		BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('WFAuthorizeQueueDefTable') 
			AND COLUMN_NAME=UPPER('SortOrder');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_logStatus := LogSkip(65);
				EXECUTE IMMEDIATE 'ALTER TABLE WFAuthorizeQueueDefTable ADD SortOrder NVARCHAR2(1) NULL';
				DBMS_OUTPUT.PUT_LINE('Table WFAuthorizeQueueDefTable altered with new Column SortOrder');
		END;

	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(65);   
			raise_application_error(-20265,v_scriptName ||' BLOCK 65 FAILED');
	END;
	v_logStatus := LogUpdate(65);	
	
	v_logStatus := LogInsert(66,'CREATE SEQUENCE TMSLOGID');
	BEGIN
		BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_SEQUENCES
			WHERE SEQUENCE_NAME=UPPER('TMSLogId');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_logStatus := LogSkip(66);
				EXECUTE IMMEDIATE 'CREATE SEQUENCE TMSLOGID INCREMENT BY 1 START WITH 1';
				DBMS_OUTPUT.PUT_LINE('New sequence created with name as TMSLOGID');
		END;

	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(66);   
			raise_application_error(-20266,v_scriptName ||' BLOCK 66 FAILED');
	END;
	v_logStatus := LogUpdate(66);	
	
	v_logStatus := LogInsert(67,'CREATE SEQUENCE SEQ_WFImportFileId');
	BEGIN
		BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_SEQUENCES
			WHERE SEQUENCE_NAME=UPPER('SEQ_WFImportFileId');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_logStatus := LogSkip(67);
				EXECUTE IMMEDIATE 'CREATE SEQUENCE SEQ_WFImportFileId INCREMENT BY 1 START WITH 1';
				DBMS_OUTPUT.PUT_LINE('New sequence created with name as SEQ_WFImportFileId');
		END;

	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(67);   
			raise_application_error(-20267,v_scriptName ||' BLOCK 67 FAILED');
	END;
	v_logStatus := LogUpdate(67);	
		
	v_logStatus := LogInsert(68,'CREATE SEQUENCE Seq_ServiceId');
	BEGIN
			BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_SEQUENCES
			WHERE SEQUENCE_NAME=UPPER('Seq_ServiceId');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_logStatus := LogSkip(68);
				EXECUTE IMMEDIATE 'CREATE SEQUENCE Seq_ServiceId INCREMENT BY 1 START WITH 1';
				DBMS_OUTPUT.PUT_LINE('New sequence created with name as Seq_ServiceId');
		END;

	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(68);   
			raise_application_error(-20268,v_scriptName ||' BLOCK 68 FAILED');
	END;
	v_logStatus := LogUpdate(68);	

	v_logStatus := LogInsert(69,'CREATING TRIGGER WF_TMS_LOGID_TRIGGER BEFORE INSERT ON WFTRANSPORTDATATABLE FOR EACH ROW ');
	BEGIN
		BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TRIGGERS
			WHERE TRIGGER_NAME=UPPER('WF_TMS_LOGID_TRIGGER');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_logStatus := LogSkip(69);
				EXECUTE IMMEDIATE 
				'CREATE OR REPLACE TRIGGER WF_TMS_LOGID_TRIGGER 	
					BEFORE INSERT ON WFTRANSPORTDATATABLE 	
					FOR EACH ROW 
					BEGIN 		
						SELECT TMSLogId.NEXTVAL INTO :NEW.TMSLogId FROM dual; 	
					END;';
				DBMS_OUTPUT.PUT_LINE('New trigger created with name as WF_TMS_LOGID_TRIGGER');
		END;

	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(69);   
			raise_application_error(-20269,v_scriptName ||' BLOCK 69 FAILED');
	END;
	v_logStatus := LogUpdate(69);	
		
	v_logStatus := LogInsert(70,'Deleting records from UserPreferencesTable where objecttype is U');
	BEGIN
		BEGIN
		existsFlag := 0;
		BEGIN
			SELECT 1 INTO existsflag FROM USER_TABLES WHERE Table_name = UPPER('UserPreferencesTable');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				existsFlag := 0;
		END;
		IF existsFlag = 1 THEN
				v_logStatus := LogSkip(70);
				EXECUTE IMMEDIATE 'Delete From UserPreferencesTable where ObjectType = ''U'''; 
		END IF;
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(70);   
			raise_application_error(-20270,v_scriptName ||' BLOCK 70 FAILED');
	END;
	v_logStatus := LogUpdate(70);	


	v_logStatus := LogInsert(71,'Inserting value in WFCalHourDefTable');
	BEGIN
			BEGIN
				v_logStatus := LogSkip(71);
				DECLARE CURSOR WFCalDefTableCursor IS  SELECT processdefid, calid FROM WFCalDefTable;
				BEGIN
				OPEN WFCalDefTableCursor;
				LOOP
				FETCH WFCalDefTableCursor INTO v_procDefId,v_CalendarId;
				EXIT WHEN WFCalDefTableCursor%NOTFOUND;
					BEGIN
					SELECT count(*) INTO v_temp FROM WFCalHourDefTable WHERE processdefid = v_procDefId AND calid = v_CalendarId;
					DBMS_OUTPUT.PUT_LINE('v_procDefId===>'||v_procDefId||' v_CalendarId===>'|| v_calendarid);
					IF v_temp = 0 THEN


					BEGIN
							DBMS_OUTPUT.PUT_LINE('One row insertted in WFCalHourDefTable');
							EXECUTE IMMEDIATE 'INSERT INTO WFCalHourDefTable(PROCESSDEFID,CALID,CALRULEID,RANGEID,STARTTIME,ENDTIME) VALUES(' || v_procDefId || ', '|| v_CalendarId ||' , 0, 1, 0 , 2400)';
							END;
						END IF;
					END;
				END LOOP;
				CLOSE WFCalDefTableCursor;
			END;
		END;

	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(71);   
			raise_application_error(-20271,v_scriptName ||' BLOCK 71 FAILED');
	END;
	v_logStatus := LogUpdate(71);	
		

END;
~
call Upgrade07()

~

DROP PROCEDURE Upgrade07

~
