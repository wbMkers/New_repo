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
________________________________________________________________________________________________________________-*/
CREATE OR REPLACE PROCEDURE Upgrade AS
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
					EXECUTE IMMEDIATE 'INSERT INTO MAILTRIGGERTABLE2 SELECT * FROM MAILTRIGGERTABLE'; 
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
		BEGIN
	 EXECUTE IMMEDIATE 'CREATE OR REPLACE VIEW QUEUEVIEW AS SELECT * FROM QUEUETABLE	UNION ALL	SELECT PROCESSDEFID, PROCESSNAME, PROCESSVERSION, PROCESSINSTANCEID, PROCESSINSTANCEID AS PROCESSINSTANCENAME, ACTIVITYID, ACTIVITYNAME, PARENTWORKITEMID, WORKITEMID, PROCESSINSTANCESTATE, WORKITEMSTATE, STATENAME, QUEUENAME, QUEUETYPE, ASSIGNEDUSER, ASSIGNMENTTYPE, INSTRUMENTSTATUS, CHECKLISTCOMPLETEFLAG, INTRODUCTIONDATETIME, CREATEDDATETIME AS CREATEDDATETIME, INTRODUCEDBY, CREATEDBYNAME, ENTRYDATETIME, LOCKSTATUS, HOLDSTATUS, PRIORITYLEVEL, LOCKEDBYNAME, LOCKEDTIME, VALIDTILL, SAVESTAGE, PREVIOUSSTAGE, EXPECTEDWORKITEMDELAYTIME AS EXPECTEDWORKITEMDELAYTIME, EXPECTEDPROCESSDELAYTIME AS EXPECTEDPROCESSDELAYTIME, STATUS, VAR_INT1, VAR_INT2, VAR_INT3, VAR_INT4, VAR_INT5, VAR_INT6, VAR_INT7, VAR_INT8, VAR_FLOAT1, VAR_FLOAT2, VAR_DATE1, VAR_DATE2, VAR_DATE3, VAR_DATE4, VAR_LONG1, VAR_LONG2, VAR_LONG3, VAR_LONG4, VAR_STR1, VAR_STR2, VAR_STR3, VAR_STR4, VAR_STR5, VAR_STR6, VAR_STR7, VAR_STR8, VAR_REC_1, VAR_REC_2, VAR_REC_3, VAR_REC_4, VAR_REC_5, Q_STREAMID, Q_QUEUEID, Q_USERID, LASTPROCESSEDBY, PROCESSEDBY, REFERREDTO, REFERREDTONAME, REFERREDBY, REFERREDBYNAME, COLLECTFLAG, NULL AS COMPLETIONDATETIME, CALENDARNAME FROM QUEUEHISTORYTABLE';
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
			dbms_output.put_line ('Table WFFormFragmentTable Created successfully');
	END;
	BEGIN 
			SELECT 1 INTO existsFlag 
			FROM USER_TABLES  
			WHERE TABLE_NAME = UPPER('WFDocTypeFieldMapping');
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
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

	BEGIN 
			SELECT 1 INTO existsFlag 
			FROM USER_TABLES  
			WHERE TABLE_NAME = UPPER('WFDocTypeSearchMapping');
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
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

	BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('DOCUMENTTYPEDEFTABLE') 
			AND 
			COLUMN_NAME=UPPER('DCName');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				EXECUTE IMMEDIATE 'ALTER TABLE DOCUMENTTYPEDEFTABLE ADD DCName NVARCHAR2(250)';
				DBMS_OUTPUT.PUT_LINE('Table DOCUMENTTYPEDEFTABLE altered with new Column DCName');
	END;

	BEGIN 
			SELECT 1 INTO existsFlag 
			FROM USER_TABLES  
			WHERE TABLE_NAME = UPPER('WFDataclassUserInfo');
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
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
		FROM USER_TAB_COLUMNS
		WHERE TABLE_NAME=UPPER('WFMAILQUEUETABLE') 
		AND 
		COLUMN_NAME=UPPER('zipFlag');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'ALTER TABLE WFMAILQUEUETABLE Add zipFlag NVARCHAR2(1)';
			DBMS_OUTPUT.PUT_LINE('Table WFWebServiceTable altered with new Column zipFlag');
			EXECUTE IMMEDIATE 'ALTER TABLE WFMAILQUEUETABLE Add zipName NVARCHAR2(255)';
			DBMS_OUTPUT.PUT_LINE('Table WFWebServiceTable altered with new Column zipName');
			EXECUTE IMMEDIATE 'ALTER TABLE WFMAILQUEUETABLE Add maxZipSize NUMBER';
			DBMS_OUTPUT.PUT_LINE('Table WFWebServiceTable altered with new Column maxZipSize');
			EXECUTE IMMEDIATE 'ALTER TABLE WFMAILQUEUETABLE Add alternateMessage CLOB';
			DBMS_OUTPUT.PUT_LINE('Table WFWebServiceTable altered with new Column alternateMessage');
	END;
	
	BEGIN 
		existsFlag := 0;
		BEGIN
		  	SELECT 1 INTO existsFlag
			FROM USER_TAB_COLUMNS
			WHERE UPPER(TABLE_NAME) = 'GTEMPPROCESSTABLE'
			AND Upper(COLUMN_NAME) in ('TEMPREGPREFIX');
		  EXCEPTION
			WHEN NO_DATA_FOUND THEN 
				EXECUTE IMMEDIATE 'ALTER TABLE GTempProcessTable ADD (TEMPREGPREFIX 	NVarchar2(20), 
				TEMPREGSUFFIX NVarchar2(20), TEMPREQSEQLENGTH 	Int)';
				DBMS_OUTPUT.PUT_LINE ('Table GTempProcessTable altered successfully');
		END;
	END;
	
	BEGIN
		 existsFlag := 0;
		BEGIN
		 	SELECT 1 INTO existsFlag
			FROM USER_TAB_COLUMNS
			WHERE UPPER(TABLE_NAME) = 'PROCESSDEFCOMMENTTABLE'
			AND Upper(COLUMN_NAME) in ('COMMENTFONT');
		  EXCEPTION
			WHEN NO_DATA_FOUND THEN 
		  EXECUTE IMMEDIATE 'ALTER TABLE PROCESSDEFCOMMENTTABLE ADD (COMMENTFONT NVARCHAR2(255), COMMENTFORECOLOR INT,
		  COMMENTBACKCOLOR INT, COMMENTBORDERSTYLE INT)';
		  DBMS_OUTPUT.PUT_LINE ('Table PROCESSDEFCOMMENTTABLE altered successfully');
		END;
		
	END;
	
	BEGIN
		 existsFlag := 0;
		BEGIN
		 	SELECT 1 INTO existsFlag
			FROM USER_TAB_COLUMNS
			WHERE UPPER(TABLE_NAME) = 'QUEUEDEFTABLE'
			AND Upper(COLUMN_NAME) = 'SORTORDER';
		  EXCEPTION
			WHEN NO_DATA_FOUND THEN 
		  EXECUTE IMMEDIATE 'ALTER TABLE QUEUEDEFTABLE ADD (SORTORDER NVARCHAR2(1))';
		  DBMS_OUTPUT.PUT_LINE ('Table QUEUEDEFTABLE altered successfully');
		END;
		
	END;
	
	BEGIN
		 existsFlag := 0;
		BEGIN
		 	SELECT 1 INTO existsFlag
			FROM USER_TAB_COLUMNS
			WHERE UPPER(TABLE_NAME) = 'VARALIASTABLE'
			AND Upper(COLUMN_NAME) = 'ALIASRULE';
		  EXCEPTION
			WHEN NO_DATA_FOUND THEN 
		  EXECUTE IMMEDIATE 'ALTER TABLE VARALIASTABLE ADD (ALIASRULE NVARCHAR2(2000))';
		  DBMS_OUTPUT.PUT_LINE ('Table VARALIASTABLE altered successfully');
		END;
	END;
	
	BEGIN
		 existsFlag := 0;
		BEGIN
		 	SELECT 1 INTO existsFlag
			FROM USER_TAB_COLUMNS
			WHERE UPPER(TABLE_NAME) = 'DOCUMENTTYPEDEFTABLE'
			AND Upper(COLUMN_NAME) = 'DCNAME';
		  EXCEPTION
			WHEN NO_DATA_FOUND THEN 
		  EXECUTE IMMEDIATE 'ALTER TABLE DOCUMENTTYPEDEFTABLE ADD (DCNAME NVARCHAR(250))';
		   DBMS_OUTPUT.PUT_LINE ('Table DOCUMENTTYPEDEFTABLE altered successfully');
		END;
	END;
	
	BEGIN 
		SELECT 1 INTO existsFlag 
		FROM USER_TABLES  
		WHERE TABLE_NAME = UPPER('WFQueueColorTable');
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
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
		FROM user_tab_columns  
		WHERE TABLE_NAME = 'GTEMPWORKLISTTABLE'
		AND column_name = 'LOCKSTATUS'
		AND NULLABLE = 'Y';
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			EXECUTE IMMEDIATE 'alter table GTEMPWORKLISTTABLE modify LOCKSTATUS NVARCHAR2(1) NULL';
		DBMS_OUTPUT.PUT_LINE ('Table GTEMPWORKLISTTABLE altered successfully');
	END;
	
	BEGIN 
		existsFlag := 0;
		BEGIN
		  	SELECT 1 INTO existsFlag
			FROM USER_TAB_COLUMNS
			WHERE UPPER(TABLE_NAME) = UPPER('WFSwimLaneTable')
			AND Upper(COLUMN_NAME) in ('SWIMLANETYPE');
		  EXCEPTION
			WHEN NO_DATA_FOUND THEN 
				EXECUTE IMMEDIATE 'ALTER TABLE WFSwimLaneTable ADD (SwimLaneType    NVARCHAR2(1) NOT NULL, 
				SwimLaneText    NVARCHAR2(255) NOT NULL, SwimLaneTextColor     INTEGER   NOT NULL)';
				DBMS_OUTPUT.PUT_LINE ('Table WFSwimLaneTable altered successfully');
		END;
	END;
	
	BEGIN 
		existsFlag := 0;
		BEGIN
		  	SELECT 1 INTO existsFlag
			FROM USER_TAB_COLUMNS
			WHERE UPPER(TABLE_NAME) = UPPER('WFDataMapTable')
			AND Upper(COLUMN_NAME) in ('EXTMETHODINDEX');
		  EXCEPTION
			WHEN NO_DATA_FOUND THEN 
				EXECUTE IMMEDIATE 'ALTER TABLE WFDataMapTable ADD (EXTMETHODINDEX	INTEGER, 
				ALIGNMENT NVARCHAR2(5))';
				DBMS_OUTPUT.PUT_LINE ('Table WFDataMapTable altered successfully');
		END;
	END;
	
	BEGIN 
		existsFlag := 0;
		BEGIN
		  	SELECT 1 INTO existsFlag
			FROM USER_TAB_COLUMNS
			WHERE UPPER(TABLE_NAME) = UPPER('WFAuthorizeQueueDefTable')
			AND Upper(COLUMN_NAME) = 'SORTORDER';
		  EXCEPTION
			WHEN NO_DATA_FOUND THEN 
				EXECUTE IMMEDIATE 'ALTER TABLE WFAuthorizeQueueDefTable ADD (SortOrder NVARCHAR2(1))';
				DBMS_OUTPUT.PUT_LINE ('Table WFAuthorizeQueueDefTable altered successfully');
		END;
	END;
	
	BEGIN
		EXECUTE IMMEDIATE 'ALTER TABLE WFFormFragmentTable modify FragmentName	NVARCHAR2(50)';
		DBMS_OUTPUT.PUT_LINE ('Table WFFormFragmentTable altered successfully');
		EXECUTE IMMEDIATE 'ALTER TABLE WFFormFragmentTable modify IsEncrypted NVARCHAR2(1)';
		DBMS_OUTPUT.PUT_LINE ('Table WFFormFragmentTable altered successfully');
		EXECUTE IMMEDIATE 'ALTER TABLE WFFormFragmentTable modify StructureName	NVARCHAR2(128)';
		DBMS_OUTPUT.PUT_LINE ('Table WFFormFragmentTable altered successfully');
	END;
	
	BEGIN 
		existsFlag := 0;
		BEGIN
		  	SELECT 1 INTO existsFlag
			FROM USER_TAB_COLUMNS
			WHERE UPPER(TABLE_NAME) = UPPER('WFTransportDataTable')
			AND Upper(COLUMN_NAME) in  ('USERID');
		  EXCEPTION
			WHEN NO_DATA_FOUND THEN 
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
	
	BEGIN 
		existsFlag := 0;
		BEGIN
		  	SELECT 1 INTO existsFlag
			FROM USER_TAB_COLUMNS
			WHERE UPPER(TABLE_NAME) = UPPER('WFTMSSetVariableMapping')
			AND Upper(COLUMN_NAME) = 'ALIASRULE';
		  EXCEPTION
			WHEN NO_DATA_FOUND THEN 
				EXECUTE IMMEDIATE 'ALTER TABLE WFTMSSetVariableMapping ADD (AliasRule VARCHAR2(4000))';
				DBMS_OUTPUT.PUT_LINE ('Table WFTMSSetVariableMapping altered successfully');
		END;
	END;
	
	BEGIN 
		existsFlag := 0;
		BEGIN
		  	SELECT 1 INTO existsFlag
			FROM USER_TAB_COLUMNS
			WHERE UPPER(TABLE_NAME) = UPPER('TransportRegisterationInfo')
			AND Upper(COLUMN_NAME) = 'TARGETCABINETNAME';
		  EXCEPTION
			WHEN NO_DATA_FOUND THEN 
				EXECUTE IMMEDIATE 'alter table TransportRegisterationInfo rename column TargetCabinetName to TargetEngineName';
				DBMS_OUTPUT.PUT_LINE ('Table TransportRegisterationInfo altered successfully,column TargetCabinetName renamed');
				EXECUTE IMMEDIATE 'RENAME TransportRegisterationInfo TO WFTransportRegisterationInfo';
				DBMS_OUTPUT.PUT_LINE ('Table TransportRegisterationInfo renamed');
		END;
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
	
	BEGIN
		SELECT LAST_NUMBER INTO v_lastSeqValue
		FROM USER_SEQUENCES
		WHERE SEQUENCE_NAME = UPPER('SEQ_QueueColorId');
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'CREATE SEQUENCE SEQ_QueueColorId INCREMENT BY 1 START WITH 1';
			dbms_output.put_line ('SEQUENCE SEQ_QueueColorId Successfully Created');
	END;
	
	BEGIN
		SELECT LAST_NUMBER INTO v_lastSeqValue
		FROM USER_SEQUENCES
		WHERE SEQUENCE_NAME = UPPER('Seq_ServiceId');
	   EXCEPTION
		WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'CREATE SEQUENCE Seq_ServiceId INCREMENT BY 1 START WITH 1';
			dbms_output.put_line ('SEQUENCE Seq_ServiceId Successfully Created');
	END;
	
	BEGIN 
		existsFlag := 0;
		BEGIN
		  	SELECT 1 INTO existsFlag
			FROM USER_OBJECTS 
			WHERE object_type in ('TRIGGER')
			AND OBJECT_NAME = 'WF_TMS_LOGID_TRIGGER';
		  EXCEPTION
			WHEN NO_DATA_FOUND THEN 
				EXECUTE IMMEDIATE 'DROP TRIGGER WF_TMS_LOGID_TRIGGER)';
				DBMS_OUTPUT.PUT_LINE ('Trigger WF_TMS_LOGID_TRIGGER dropped');
				EXECUTE IMMEDIATE 'CREATE OR REPLACE TRIGGER WF_TMS_LOGID_TRIGGER BEFORE INSERT ON WFTRANSPORTDATATABLE FOR EACH ROW BEGIN 	
				SELECT 	TMSLogId.NEXTVAL INTO :NEW.TMSLogId FROM dual; 	END;';
				DBMS_OUTPUT.PUT_LINE ('Trigger WF_TMS_LOGID_TRIGGER created');
		END;
	END;
	
	BEGIN 
		existsFlag := 0;
		BEGIN
		  	SELECT 1 INTO existsFlag
			FROM USER_OBJECTS 
			WHERE object_type in ('TRIGGER')
			AND OBJECT_NAME = 'WF_QUEUE_COLOR_TRIGGER';
		  EXCEPTION
			WHEN NO_DATA_FOUND THEN 
				EXECUTE IMMEDIATE 'CREATE OR REPLACE TRIGGER WF_QUEUE_COLOR_TRIGGER BEFORE INSERT ON WFQueueColorTable 	FOR EACH ROW BEGIN 		
				SELECT SEQ_QueueColorId.NEXTVAL INTO :NEW.Id FROM dual; END;';
				DBMS_OUTPUT.PUT_LINE ('Trigger WF_QUEUE_COLOR_TRIGGER created');
		END;
	END;
	
	BEGIN 
		existsFlag := 0;
		BEGIN
		  	SELECT 1 INTO existsFlag
			FROM USER_OBJECTS 
			WHERE object_type in ('INDEX')
			AND OBJECT_NAME = 'IDX1_WFMAILQUEUETABLE';
		  EXCEPTION
			WHEN NO_DATA_FOUND THEN 
				EXECUTE IMMEDIATE 'CREATE INDEX IDX1_WFMAILQUEUETABLE ON WFMAILQUEUETABLE(MAILPRIORITY DESC, NOOFTRIALS ASC)';
				DBMS_OUTPUT.PUT_LINE ('iNDEX IDX1_WFMAILQUEUETABLE created ON WFMAILQUEUETABLE');
		END;
	END;
	
	BEGIN 
		existsFlag := 0;
		BEGIN
		  	SELECT 1 INTO existsFlag
			FROM USER_OBJECTS 
			WHERE object_type in ('INDEX')
			AND OBJECT_NAME = 'IDX1_ExtInterfaceCondTable';
		  EXCEPTION
			WHEN NO_DATA_FOUND THEN 
				EXECUTE IMMEDIATE 'CREATE INDEX IDX1_ExtInterfaceCondTable ON WFExtInterfaceConditionTable (ProcessDefId, InterfaceType, RuleId, RuleOrderId, ConditionOrderId)';
				DBMS_OUTPUT.PUT_LINE ('iNDEX IDX1_ExtInterfaceCondTable created ON WFExtInterfaceConditionTable');
		END;
	END;
	
	BEGIN
		v_STR1 := 'CREATE OR REPLACE VIEW WFUSERVIEW ( USERINDEX, USERNAME, PERSONALNAME, FAMILYNAME, CREATEDDATETIME, 
				      EXPIRYDATETIME, PRIVILEGECONTROLLIST, PASSWORD, ACCOUNT, 
				      COMMNT, DELETEDDATETIME, USERALIVE, MAINGROUPID, 
				      MAILID, FAX, NOTECOLOR, SUPERIOR, SUPERIORFLAG  ) 
	AS 
		SELECT  USERINDEX,TO_NChar(RTRIM(USERNAME)) as USERNAME,PERSONALNAME,FAMILYNAME,
			CREATEDDATETIME, EXPIRYDATETIME,PRIVILEGECONTROLLIST,
			PASSWORD,ACCOUNT,COMMNT,DELETEDDATETIME,USERALIVE,
			MAINGROUPID,MAILID,FAX,NOTECOLOR, SUPERIOR, SUPERIORFLAG 
			FROM PDBUSER';
			
		EXECUTE IMMEDIATE v_STR1;		
	
	END;
	
END;
~
call Upgrade()

~

DROP PROCEDURE Upgrade

~
