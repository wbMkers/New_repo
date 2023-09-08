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
20/06/2014  Kanika Manik        PRD Bug 41706 - Changes done in version Upgrade of OF 9.0    
________________________________________________________________________________________________________________-*/
CREATE OR REPLACE PROCEDURE Upgrade07 AS
existsFlag			INTEGER;
v_lastSeqValue			INTEGER;
v_ProcessDefId			INTEGER;
v_cabVersion		        VARCHAR2(2000);
v_STR1			        VARCHAR2(8000);
v_constraintName		VARCHAR2(512);
BEGIN

	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_TABLES  
		WHERE TABLE_NAME = 'WFCABVERSIONTABLE';
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			EXECUTE IMMEDIATE 
			'CREATE TABLE WFCabVersionTable (cabVersion	NVARCHAR2(255) NOT NULL, 
			cabVersionId	INT NOT NULL PRIMARY KEY, 
			creationDate	DATE, 
			lastModified	DATE, 
			Remarks		NVARCHAR2(255) NOT NULL,
			Status			NVARCHAR2(1) )';
			dbms_output.put_line ('Table WFCabVersionTable Created successfully');
	END;

	EXECUTE IMMEDIATE 'ALTER TABLE WFCabVersionTable MODIFY (cabVersion NVARCHAR2(255))';
	DBMS_OUTPUT.PUT_LINE('Table WFCabVersionTable altered with Column cabVersion size increased to 255');
	EXECUTE IMMEDIATE 'ALTER TABLE WFCabVersionTable MODIFY (Remarks NVARCHAR2(255))';
	DBMS_OUTPUT.PUT_LINE('Table WFCabVersionTable altered with Column Remarks size increased to 255');
	
	BEGIN
		SELECT LAST_NUMBER INTO v_lastSeqValue
		FROM USER_SEQUENCES
		WHERE SEQUENCE_NAME = UPPER('cabVersionId');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'CREATE SEQUENCE CABVERSIONID INCREMENT BY 1 START WITH 1';
			dbms_output.put_line ('SEQUENCE CABVERSIONID Successfully Created');
	END;

/*SrNo-15, New tables added for SAP integration by Ruhi Hira.*/

	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_TABLES  
		WHERE TABLE_NAME = UPPER('WFSAPConnectTable');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
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

/*Modified on 23-06-2009 by Ananta Handoo .Three fields added TCodeType, VariableId, VarFieldId */
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_TABLES  
		WHERE TABLE_NAME = UPPER('WFSAPGUIDefTable');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
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

    
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_TABLES  
		WHERE TABLE_NAME = UPPER('WFSAPGUIFieldMappingTable');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
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

    BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_TABLES  
		WHERE TABLE_NAME = UPPER('WFSAPGUIAssocTable');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
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

/* New table WFSAPAdapterAssocTable added for SAP Integration.*/
   BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_TABLES  
		WHERE TABLE_NAME = UPPER('WFSAPAdapterAssocTable');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			EXECUTE IMMEDIATE 
			'CREATE TABLE WFSAPAdapterAssocTable (
				ProcessDefId		INT				 NULL,
				ActivityId		INT				 NULL,
				EXTMETHODINDEX		INT				 NULL
			)';
		DBMS_OUTPUT.PUT_LINE ('Table WFSAPAdapterAssocTable Created successfully');
	END;

	EXECUTE IMMEDIATE 'ALTER TABLE EXCEPTIONTABLE MODIFY (EXCEPTIONCOMMENTS NVARCHAR2(512))';
	EXECUTE IMMEDIATE 'ALTER TABLE EXCEPTIONHISTORYTABLE MODIFY (EXCEPTIONCOMMENTS NVARCHAR2(512))';
	EXECUTE IMMEDIATE 'ALTER TABLE TEMPLATEDEFINITIONTABLE MODIFY (ARGLIST NVARCHAR2(2000))';

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

	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME=UPPER('WFWebServiceTable') 
		AND 
		COLUMN_NAME=UPPER('InputBuffer');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE WFWebServiceTable Add InputBuffer NCLOB';
			DBMS_OUTPUT.PUT_LINE('Table WFWebServiceTable altered with new Column InputBuffer');
			EXECUTE IMMEDIATE 'ALTER TABLE WFWebServiceTable Add OutputBuffer NCLOB';
			DBMS_OUTPUT.PUT_LINE('Table WFWebServiceTable altered with new Column OutputBuffer');
	END;

	/* Added by Ishu Saraf - 17/06/2009 */
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_TABLES  
		WHERE TABLE_NAME = UPPER('WFPDATable');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			EXECUTE IMMEDIATE 
			'CREATE TABLE WFPDATable(
				ProcessDefId		INT				NOT NULL, 
				ActivityId			INT				NOT NULL , 
				InterfaceId			INT				NOT NULL,
				InterfaceType		NVARCHAR2(1)
			)';
		DBMS_OUTPUT.PUT_LINE ('Table WFPDATable Created successfully');
	END;

	/* Added by Ishu Saraf - 17/06/2009 */
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_TABLES  
		WHERE TABLE_NAME = UPPER('WFPDA_FormTable');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
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

	/* Added by Ishu Saraf - 17/06/2009 */
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_TABLES  
		WHERE TABLE_NAME = UPPER('WFPDAControlValueTable');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
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

	/*HotFix_8.0_045- Variable support in doctypename in PFE*/
	
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME=UPPER('PrintFaxEmailDocTypeTable') 
		AND 
		COLUMN_NAME=UPPER('VariableId');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE PrintFaxEmailDocTypeTable Add ( VariableId INT, VarFieldId INT )';
			DBMS_OUTPUT.PUT_LINE('Table PrintFaxEmailDocTypeTable altered with two new Columns VariableId and VarFieldId');
	END;

	/*WFS_8.0_026 - workitem specific calendar*/
	
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME=UPPER('QueueDataTable') 
		AND 
		COLUMN_NAME=UPPER('CalendarName');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE QueueDataTable Add ( CalendarName NVARCHAR2(255) )';
			DBMS_OUTPUT.PUT_LINE('Table QueueDataTable altered with a new Column CalendarName');
	END;



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
			EXECUTE IMMEDIATE 'ALTER TABLE "QUEUEUSERTABLE" ADD "QUERYPREVIEW" NVARCHAR2(1) DEFAULT (N''Y'')'; 
		END IF;

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
	
	
	/*HotFix_8.0_026- workitem specific calendar*/
	
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME=UPPER('QueueHistoryTable') 
		AND 
		COLUMN_NAME=UPPER('CalendarName');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE QueueHistoryTable Add ( CalendarName NVARCHAR2(255) )';
			DBMS_OUTPUT.PUT_LINE('Table QueueHistoryTable altered with a new Column CalendarName');
	END;

	BEGIN
	SELECT CabVersion INTO v_cabVersion FROM WFCABVERSIONTABLE WHERE CabVersion = '7.2_CalendarName_VarMapping';
	EXCEPTION 
	WHEN NO_DATA_FOUND THEN
	BEGIN
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
        
	/*WFS_8.0_026 - workitem specific calendar*/

	/*Added by Saurabh Kamal for Rules on External Interfaces*/
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_TABLES  
		WHERE TABLE_NAME = UPPER('WFExtInterfaceConditionTable');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
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

	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_TABLES  
		WHERE TABLE_NAME = UPPER('WFExtInterfaceOperationTable');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
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
			EXECUTE IMMEDIATE 'ALTER TABLE "QUEUEDEFTABLE" ADD "REFRESHINTERVAL" INT '; 
		END IF;
	END;
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
			EXECUTE IMMEDIATE 'ALTER TABLE "GTEMPQUEUETABLE" ADD "TEMPREFRESHINTERVAL" INT '; 
		END IF;
	END;
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
			EXECUTE IMMEDIATE 'ALTER TABLE "QUEUEDEFTABLE" ADD "SORTORDER" NVARCHAR2(1)'; 
		END IF;
	END;

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
			EXECUTE IMMEDIATE 'ALTER TABLE "GTEMPQUEUETABLE" ADD "TEMPORDERBY" INT '; 
		END IF;
	END;

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
			EXECUTE IMMEDIATE 'ALTER TABLE "GTEMPQUEUETABLE" ADD "TEMPSORTORDER" NVARCHAR2(1)'; 
		END IF;
	END;
	/* WFS_8.0_044 Support of TurnAroundDateTime in FetchWorkList and SearchWorkitem*/
	BEGIN
	SELECT CabVersion INTO v_cabVersion FROM WFCABVERSIONTABLE WHERE CabVersion = '7.2_TurnAroundDateTime_VarMapping';
	EXCEPTION 
	WHEN NO_DATA_FOUND THEN
	BEGIN
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

	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_TABLES  
		WHERE TABLE_NAME = UPPER('WFImportFileData');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
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
	
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME=UPPER('VarAliasTable') 
		AND 
		COLUMN_NAME=UPPER('ProcessDefId');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE VarAliasTable ADD ProcessDefId INT DEFAULT 0 NOT NULL';
			DBMS_OUTPUT.PUT_LINE('Table VarAliasTable altered with new Column ProcessDefId');			
	END;
	BEGIN
	SELECT CONSTRAINT_NAME INTO v_constraintName
		FROM USER_CONSTRAINTS 
		WHERE TABLE_NAME = UPPER('varaliastable') AND constraint_type = 'P';

		EXECUTE IMMEDIATE 'Alter Table varaliastable Drop Constraint ' || TO_CHAR(v_constraintName);
		EXECUTE IMMEDIATE 'Alter Table varaliastable Add Constraint ' || TO_CHAR(v_constraintName) || ' Primary Key (queueid, alias, processdefid)';
		DBMS_OUTPUT.PUT_LINE('Primary Key Updated for varaliastable');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			DBMS_OUTPUT.PUT_LINE('No Primary Key Exists for varaliastable');
	END;
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
			EXECUTE IMMEDIATE 'ALTER TABLE "PENDINGWORKLISTTABLE" ADD "EXPORTSTATUS" NVARCHAR2(1) DEFAULT (N''N'')'; 
		END IF;
	END;
	BEGIN
	existsFlag := 0;	
		BEGIN 
			SELECT 1 INTO existsFlag 
			FROM DUAL 
			WHERE 
				NOT EXISTS( SELECT 1 FROM USER_TAB_COLUMNS  
					WHERE UPPER(TABLE_NAME) = 'QUEUEHISTORYTABLE'
					AND UPPER(COLUMN_NAME) = 'EXPORTSTATUS'			
				);  
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
				existsFlag := 0; 
		END; 
		IF existsFlag = 1 THEN
			EXECUTE IMMEDIATE 'ALTER TABLE "QUEUEHISTORYTABLE" ADD "EXPORTSTATUS" NVARCHAR2(1) DEFAULT (N''N'')'; 
		END IF;
		END;
	
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
		EXECUTE IMMEDIATE 'ALTER TABLE VARALIASTABLE ADD (ALIASRULE NVARCHAR2(2000))';
		DBMS_OUTPUT.PUT_LINE('TABLE VARALIASTABLE ALTERED WITH NEW COLUMN ALIASRULE ADDED');
	END IF;
  
	EXISTSFLAG := 0;
	BEGIN
		SELECT 1 INTO EXISTSFLAG 
		FROM DUAL WHERE NOT EXISTS( SELECT 1 FROM USER_TABLES WHERE UPPER(TABLE_NAME) = 'WFFORMFRAGMENTTABLE');  
	EXCEPTION
		WHEN NO_DATA_FOUND THEN 
			EXISTSFLAG := 0; 
	END;
	IF EXISTSFLAG = 1 THEN
		EXECUTE IMMEDIATE 
		'CREATE TABLE WFFORMFRAGMENTTABLE(	
		ProcessDefId	int 		   NOT NULL,
		FragmentId	    int 		   NOT NULL,
		FragmentName	VARCHAR(50)    NOT NULL,
		FragmentBuffer	BLOB           NULL,
		IsEncrypted	    VARCHAR(1)     NOT NULL,
		StructureName	VARCHAR(128)   NOT NULL,
		StructureId	    int            NOT NULL
		)';
	END IF;
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_TABLES  
		WHERE TABLE_NAME = UPPER('WFQueueColorTable');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
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

/*Modified on 23-06-2009 by Ananta Handoo .Three fields added TCodeType, VariableId, VarFieldId */
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_TABLES  
		WHERE TABLE_NAME = UPPER('WFAuthorizeQueueColorTable');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
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

    
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_TABLES  
		WHERE TABLE_NAME = UPPER('WFImportFileData');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
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

    BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_TABLES  
		WHERE TABLE_NAME = UPPER('WFPURGECRITERIATABLE');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
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

/* New table WFSAPAdapterAssocTable added for SAP Integration.*/
   BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_TABLES  
		WHERE TABLE_NAME = UPPER('WFEXPORTINFOTABLE');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
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
	
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_TABLES  
		WHERE TABLE_NAME = UPPER('WFSOURCECABINETINFOTABLE');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
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
	
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_TABLES  
		WHERE TABLE_NAME = UPPER('WFFormFragmentTable');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
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
		DBMS_OUTPUT.PUT_LINE ('Table WFFormFragmentTable Created successfully');
	END;
	
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_TABLES  
		WHERE TABLE_NAME = UPPER('WFTransportDataTable');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
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
	
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_TABLES  
		WHERE TABLE_NAME = UPPER('WFTMSAddQueue');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
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
	
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_TABLES  
		WHERE TABLE_NAME = UPPER('WFTMSChangeProcessDefState');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
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
	
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_TABLES  
		WHERE TABLE_NAME = UPPER('WFTMSChangeQueuePropertyEx');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
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
	
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_TABLES  
		WHERE TABLE_NAME = UPPER('WFTMSDeleteQueue');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
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
	
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_TABLES  
		WHERE TABLE_NAME = UPPER('WFTMSStreamOperation');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
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
	
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_TABLES  
		WHERE TABLE_NAME = UPPER('WFTMSSetVariableMapping');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
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
	
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_TABLES  
		WHERE TABLE_NAME = UPPER('WFTMSSetTurnAroundTime');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
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
	
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_TABLES  
		WHERE TABLE_NAME = UPPER('WFTMSSetActionList');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
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
	
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_TABLES  
		WHERE TABLE_NAME = UPPER('WFTMSSetDynamicConstants');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
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
	
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_TABLES  
		WHERE TABLE_NAME = UPPER('WFTMSSetQuickSearchVariables');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
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
	
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_TABLES  
		WHERE TABLE_NAME = UPPER('WFTransportRegisterationInfo');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
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
	
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_TABLES  
		WHERE TABLE_NAME = UPPER('WFTMSSetCalendarData');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
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
	
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_TABLES  
		WHERE TABLE_NAME = UPPER('WFTMSAddCalendar');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
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
	
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_TABLES  
		WHERE TABLE_NAME = UPPER('WFBPELDefTable');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			EXECUTE IMMEDIATE 
			'Create TABLE WFBPELDefTable(    
				ProcessDefId        INT     NOT NULL PRIMARY KEY,
				BPELDef             CLOB    NOT NULL,
				XSDDef              CLOB    NOT NULL
			)';
		DBMS_OUTPUT.PUT_LINE ('Table WFBPELDefTable Created successfully');
	END;
	
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_TABLES  
		WHERE TABLE_NAME = UPPER('WFWebServiceInfoTable');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
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
	
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_TABLES  
		WHERE TABLE_NAME = UPPER('WFSystemServicesTable');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
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
	
  --EXECUTE IMMEDIATE 'ALTER TABLE GTEMPWORKLISTTABLE MODIFY (LOCKSTATUS NVARCHAR2(1) NULL)';
	
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME=UPPER('PROCESSDEFCOMMENTTABLE') 
		AND 
		COLUMN_NAME=UPPER('CommentFont');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'create table PROCESSDEFCOMMENTTABLETEMP as select * from PROCESSDEFCOMMENTTABLE';
			EXECUTE IMMEDIATE 'delete from PROCESSDEFCOMMENTTABLE';
			EXECUTE IMMEDIATE 'ALTER TABLE PROCESSDEFCOMMENTTABLE Add ( CommentFont NVARCHAR2(255) NOT NULL, CommentForeColor INT  NOT NULL, CommentBackColor INT NOT NULL, CommentBorderStyle INT NOT NULL)';
			EXECUTE IMMEDIATE 'insert into PROCESSDEFCOMMENTTABLE select processdefid, leftpos, toppos, width, height,TYPE, comments, sourceid, targetid, ruleid,''Bookman Old Style,0,8'',-16777077,-1581081,0 from PROCESSDEFCOMMENTTABLETEMP';
			EXECUTE IMMEDIATE 'drop table PROCESSDEFCOMMENTTABLETEMP';
			DBMS_OUTPUT.PUT_LINE('Table PROCESSDEFCOMMENTTABLE altered with four new Columns CommentFont, CommentForeColor, CommentBackColor and CommentBorderStyle');
	END;
	
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME=UPPER('QUEUEHISTORYTABLE') 
		AND 
		COLUMN_NAME=UPPER('ExportStatus');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE QUEUEHISTORYTABLE ADD ExportStatus NVARCHAR2(1) DEFAULT (N''Y'')';
			DBMS_OUTPUT.PUT_LINE('Table QUEUEHISTORYTABLE altered with new Column ExportStatus');			
	END;
	
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME=UPPER('QUEUEDEFTABLE') 
		AND 
		COLUMN_NAME=UPPER('SortOrder');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE QUEUEDEFTABLE ADD SortOrder NVARCHAR2(1) NULL';
			DBMS_OUTPUT.PUT_LINE('Table QUEUEDEFTABLE altered with new Column SortOrder');			
	END;
	
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME=UPPER('VARALIASTABLE') 
		AND 
		COLUMN_NAME=UPPER('AliasRule');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE VARALIASTABLE ADD AliasRule NVARCHAR2(2000) NULL';
			DBMS_OUTPUT.PUT_LINE('Table VARALIASTABLE altered with new Column AliasRule');			
	END;
	
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME=UPPER('PENDINGWORKLISTTABLE') 
		AND 
		COLUMN_NAME=UPPER('ExportStatus');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE PENDINGWORKLISTTABLE ADD ExportStatus NVARCHAR2(1) DEFAULT (N''N'')';
			DBMS_OUTPUT.PUT_LINE('Table PENDINGWORKLISTTABLE altered with new Column ExportStatus');
	END;
	
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME=UPPER('GTempQueueTable') 
		AND COLUMN_NAME=UPPER('TempOrderBy');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE GTempQueueTable ADD ( TempOrderBy INT, TempSortOrder NVarchar2(1))';
			DBMS_OUTPUT.PUT_LINE('Table GTempQueueTable altered with two new Columns TempOrderBy and TempSortOrder');
	END;
	
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME=UPPER('WFSwimLaneTable') 
		AND COLUMN_NAME=UPPER('SwimLaneType');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE WFSwimLaneTable ADD ( SwimLaneType  NVARCHAR2(1) NOT NULL, SwimLaneText NVARCHAR2(255) NOT NULL, SwimLaneTextColor INTEGER NOT NULL )';
			DBMS_OUTPUT.PUT_LINE('Table WFSwimLaneTable altered with three new Columns SwimLaneType, SwimLaneText and SwimLaneTextColor');
	END;
	
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME=UPPER('WFAuthorizeQueueDefTable') 
		AND COLUMN_NAME=UPPER('SortOrder');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE WFAuthorizeQueueDefTable ADD SortOrder NVARCHAR2(1) NULL';
			DBMS_OUTPUT.PUT_LINE('Table WFAuthorizeQueueDefTable altered with new Column SortOrder');
	END;
	
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_SEQUENCES
		WHERE SEQUENCE_NAME=UPPER('TMSLogId');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'CREATE SEQUENCE TMSLOGID INCREMENT BY 1 START WITH 1';
			DBMS_OUTPUT.PUT_LINE('New sequence created with name as TMSLOGID');
	END;
	
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_SEQUENCES
		WHERE SEQUENCE_NAME=UPPER('SEQ_WFImportFileId');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'CREATE SEQUENCE SEQ_WFImportFileId INCREMENT BY 1 START WITH 1';
			DBMS_OUTPUT.PUT_LINE('New sequence created with name as SEQ_WFImportFileId');
	END;
	
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_SEQUENCES
		WHERE SEQUENCE_NAME=UPPER('Seq_ServiceId');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'CREATE SEQUENCE Seq_ServiceId INCREMENT BY 1 START WITH 1';
			DBMS_OUTPUT.PUT_LINE('New sequence created with name as Seq_ServiceId');
	END;
	
	BEGIN
		SELECT 1 INTO existsFlag 
		FROM USER_TRIGGERS
		WHERE TRIGGER_NAME=UPPER('WF_TMS_LOGID_TRIGGER');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 
			'CREATE OR REPLACE TRIGGER WF_TMS_LOGID_TRIGGER 	
				BEFORE INSERT ON WFTRANSPORTDATATABLE 	
				FOR EACH ROW 
				BEGIN 		
					SELECT TMSLogId.NEXTVAL INTO :NEW.TMSLogId FROM dual; 	
				END;';
			DBMS_OUTPUT.PUT_LINE('New trigger created with name as WF_TMS_LOGID_TRIGGER');
	END;

END;
~
call Upgrade07()

~

DROP PROCEDURE Upgrade07

~
