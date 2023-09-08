/*
Change DATE		Name				Description
--------------------------------------------------------------
26/05/2017		Sanal Grover		Bug 62518 - Step by Step Debugs in Version Upgrade.
03/05/2018		Ashutosh Pandey		Bug 77527 - Provide upper case encrypted password while creating system user if PwdSensitivity is N
23/04/2019		Ashutosh Pandey		Bug 84321 - Change data type of column Type1 in VarAliasTable to SMALLINT
24/01/2020		Chitranshi Nitharia	Bug 90093 - Creation Of Utility User Via API instead of scripts
*/
CREATE OR REPLACE PROCEDURE Upgrade AS
v_QueueId INT;
v_rowCount INT;
v_queryStr VARCHAR2(800);
TYPE DynamicCursor	IS REF CURSOR;
Cursor1 DynamicCursor;
v_ProcessDefId INTEGER;
v_ActivityId INT;
v_primaryKeyName  VARCHAR2(200);
existsFlag   INT;
v_UserIndex INTEGER;
v_Status NUMBER;
v_IVolumeIndex NUMBER;
v_RC1 OraConstPkg.DBList;
v_RC2 OraConstPkg.DBList;
v_RC3 OraConstPkg.DBList;
v_RC4 OraConstPkg.DBList;
v_RC5 OraConstPkg.DBList;
v_DBTableExists CHAR;
v_DBFieldName VARCHAR2(1000);
v_UserImage PDBUser.UserImage%TYPE;
v_GroupIndex_Str NVARCHAR2(6);
v_License_Int INTEGER;
v_IsMakerCheckerEnabled CHAR;
v_PwdSensitivity CHAR;
v_UserPassword RAW(128);
v_constraintName VARCHAR2(512);
v_SearchCondition NVARCHAR2(5000);
v_SearchConditionOld NVARCHAR2(5000);
v_SearchConditionNew NVARCHAR2(5000);
v_IsConstraintUpdated INT;
v_ProcessCursor DynamicCursor;
v_AliasCursor DynamicCursor;
v_Alias NVARCHAR2 (63);
v_Param1 NVARCHAR2 (100);
v_ProcDefId INT;
v_VariableId INT;
v_logStatus 			BOOLEAN;
v_scriptName        	NVARCHAR2(100) := 'Upgrade10_3_SP0';
v_DataClassName NVARCHAR2(255);
v_ArchiveId INTEGER;
v_DocTypeId INTEGER;
v_DataFieldName NVARCHAR2(255);
		
	FUNCTION LogInsert(v_stepNumber Number,v_stepDetails VARCHAR2 )
	RETURN BOOLEAN
	as 
	DBString   BOOLEAN; 
	dbQuery VARCHAR2(1000);
	BEGIN
		BEGIN
		dbQuery := 'INSERT INTO WFCABINETUPGRADELOGTABLE(STEPNUMBER,SCRIPTNAME,STEPDETAILS, STARTDATE, STATUS) VALUES(:v_stepNumber,:v_scriptName,:v_stepDetails,SYSTIMESTAMP, ''UPDATING'')';
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
		dbQuery := 'UPDATE WFCABINETUPGRADELOGTABLE set ENDDATE = SYSTIMESTAMP, STATUS = ''INSIDE'' WHERE STEPNUMBER =' || v_stepNumber ||' AND STATUS = ''UPDATING''  AND SCRIPTNAME ='''|| v_scriptName ||'''';
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
		dbQuery1 := 'UPDATE WFCABINETUPGRADELOGTABLE set ENDDATE = SYSTIMESTAMP, STATUS = ''UPDATED'' WHERE STEPNUMBER =' || v_stepNumber ||' AND STATUS = ''INSIDE''  AND SCRIPTNAME ='''|| v_scriptName ||'''';
		dbQuery2 := 'UPDATE WFCABINETUPGRADELOGTABLE set ENDDATE = SYSTIMESTAMP, STATUS = ''SKIPPED'' WHERE STEPNUMBER =' || v_stepNumber ||' AND STATUS = ''UPDATING''  AND SCRIPTNAME ='''|| v_scriptName ||'''';
		    
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
		dbQuery := 'UPDATE WFCABINETUPGRADELOGTABLE set ENDDATE = SYSTIMESTAMP,STATUS = ''FAILED'' WHERE STEPNUMBER = ' ||v_stepNumber|| ' AND SCRIPTNAME ='''|| v_scriptName ||'''';
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
	
	BEGIN
		BEGIN
			SELECT 1 INTO existsFlag from USER_TABLES where upper(table_name) = upper('WFCABINETUPGRADELOGTABLE');
			IF(existsFlag = 1) THEN
				BEGIN
					SELECT 1 INTO existsFlag from user_tab_columns where upper(table_name) = upper('WFCABINETUPGRADELOGTABLE') and upper(column_name) = upper('SCRIPTNAME');					
				EXCEPTION WHEN no_data_found THEN 
					EXECUTE IMMEDIATE 'DROP TABLE WFCABINETUPGRADELOGTABLE' ;
					
					EXECUTE IMMEDIATE 'CREATE TABLE WFCABINETUPGRADELOGTABLE(STEPNUMBER NUMBER,SCRIPTNAME NVARCHAR2(100) NOT NULL, STEPDETAILS NVARCHAR2(1000),  STARTDATE timestamp, ENDDATE timestamp, STATUS NVARCHAR2(20), CONSTRAINT PK_CabinetUpgrade PRIMARY KEY (STEPNUMBER,SCRIPTNAME))';
				END;				
			END IF;		
		EXCEPTION WHEN NO_DATA_FOUND THEN
			EXECUTE IMMEDIATE 'CREATE TABLE WFCABINETUPGRADELOGTABLE(STEPNUMBER NUMBER,SCRIPTNAME NVARCHAR2(100) NOT NULL, STEPDETAILS NVARCHAR2(1000),  STARTDATE timestamp, ENDDATE timestamp, STATUS NVARCHAR2(20), CONSTRAINT PK_CabinetUpgrade PRIMARY KEY (STEPNUMBER,SCRIPTNAME))';
		END;		
		EXECUTE IMMEDIATE 'DELETE FROM WFCABINETUPGRADELOGTABLE WHERE SCRIPTNAME = :v_scriptName' USING v_scriptName;
	END;

	v_logStatus := LogInsert(1,'Adding WebService Queue, QueueType A for WebServiceInvoker Utility');
	BEGIN
		/* Adding WebService Queue, QueueType A*/
		BEGIN
			SELECT QueueId INTO v_QueueId FROM QueueDefTable WHERE QueueType = 'A' and QueueName = 'SystemWSQueue';
			v_rowCount := SQL%ROWCOUNT;
		EXCEPTION
		WHEN OTHERS THEN
			v_rowCount := 0;
		END;
		IF(v_rowCount < 1) THEN
		BEGIN
			v_logStatus := LogSkip(1);
			SAVEPOINT WSInvoker;
				SELECT QUEUEID.NEXTVAL INTO v_QueueId FROM dual;
				EXECUTE IMMEDIATE 'INSERT INTO QueueDefTable (QUEUEID,QUEUENAME,QUEUETYPE,COMMENTS,ALLOWREASSIGNMENT,FILTEROPTION,FILTERVALUE,ORDERBY,QUEUEFILTER,REFRESHINTERVAL,SORTORDER,PROCESSNAME) values(' || v_QueueId || ', ''SystemWSQueue'',''A'',''Queue of QueueType A for WebServiceInvoker Utility is added thorugh Upgradenew.sql'',NULL,NULL,NULL,10,NULL,NULL,''A'',NULL)';
				DBMS_OUTPUT.PUT_LINE('Queue of QueueType A for WebServiceInvoker Utility is added successfully');

				v_queryStr := 'Select ProcessDefId, ActivityId from ActivityTable WHERE ActivityType = 22';
				OPEN Cursor1 FOR v_queryStr;
				LOOP
					FETCH Cursor1 INTO v_ProcessDefId, v_ActivityId;
					EXIT WHEN Cursor1%NOTFOUND;

					EXECUTE IMMEDIATE 'Update QueueStreamTable set QueueId = ' || v_QueueId || ' where activityId = ' || v_ActivityId || ' and processDefId = '||v_ProcessDefId;

					EXECUTE IMMEDIATE 'Update WFInstrumentTable set QueueName = ''SystemWSQueue'' ,Q_queueId = ' || v_QueueId || ' where activityId = ' || v_ActivityId || ' and processDefId = ' || v_ProcessDefId || ' and RoutingStatus =''N'' ';

				END LOOP;
				CLOSE Cursor1;
			COMMIT;
		EXCEPTION
		WHEN OTHERS THEN
			ROLLBACK TO SAVEPOINT WSInvoker;
			CLOSE Cursor1;
		END;
		END IF;	
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(1);   
			raise_application_error(-20201,v_scriptName ||' BLOCK 1 FAILED');
	END;
	v_logStatus := LogUpdate(1);
	
	v_logStatus := LogInsert(2,'Adding SAP Queue, QueueType A for SAPInvoker Utility');
	BEGIN
		/* Adding SAP Queue, QueueType A*/
		BEGIN
			SELECT QueueId INTO v_QueueId FROM QueueDefTable WHERE QueueType = 'A' and QueueName = 'SystemSAPQueue';
			v_rowCount := SQL%ROWCOUNT;
		EXCEPTION
		WHEN OTHERS THEN
			v_rowCount := 0;
		END;
		IF(v_rowCount < 1) THEN
		BEGIN
			v_logStatus := LogSkip(2);
			SAVEPOINT SAPInvoker;
			SELECT QUEUEID.NEXTVAL INTO v_QueueId FROM dual;
			EXECUTE IMMEDIATE 'INSERT INTO QueueDefTable (QUEUEID,QUEUENAME,QUEUETYPE,COMMENTS,ALLOWREASSIGNMENT,FILTEROPTION,FILTERVALUE,ORDERBY,QUEUEFILTER,REFRESHINTERVAL,SORTORDER,PROCESSNAME) values(' || v_QueueId || ', ''SystemSAPQueue'',''A'',''Queue of QueueType A for SAPInvoker Utility is added thorugh Upgradenew.sql'',NULL,NULL,NULL,10,NULL,NULL,''A'',NULL)';
			DBMS_OUTPUT.PUT_LINE('Queue of QueueType A for SAPInvoker Utility is added successfully');

			v_queryStr := 'Select ProcessDefId, ActivityId from ActivityTable WHERE ActivityType = 29';
			OPEN Cursor1 FOR v_queryStr;
			LOOP
				FETCH Cursor1 INTO v_ProcessDefId, v_ActivityId;
				EXIT WHEN Cursor1%NOTFOUND;

				EXECUTE IMMEDIATE 'Update QueueStreamTable set QueueId = ' || v_QueueId || ' where activityId = ' || v_ActivityId || ' and processDefId = '||v_ProcessDefId;

				EXECUTE IMMEDIATE 'Update WFInstrumentTable set QueueName = ''SystemSAPQueue'' ,Q_queueId = ' || v_QueueId || ' where activityId = ' || v_ActivityId || ' and processDefId = ' || v_ProcessDefId || ' and RoutingStatus =''N'' ';
				
			END LOOP;
			CLOSE Cursor1;
			COMMIT;
		EXCEPTION
		WHEN OTHERS THEN
			ROLLBACK TO SAVEPOINT SAPInvoker;
			CLOSE Cursor1;
		END;
		END IF;	
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(2);   
			raise_application_error(-20202,v_scriptName ||' BLOCK 2 FAILED');
	END;
	v_logStatus := LogUpdate(2);	

	v_logStatus := LogInsert(3,'Adding BRMS Queue, QueueType A for WebServiceInvoker Utility');
	BEGIN
		/* Adding BRMS Queue, QueueType A*/
		BEGIN
			SELECT QueueId INTO v_QueueId FROM QueueDefTable WHERE QueueType = 'A' and QueueName = 'SystemBRMSQueue';
			v_rowCount := SQL%ROWCOUNT;
		EXCEPTION
		WHEN OTHERS THEN
			v_rowCount := 0;
		END;
		IF(v_rowCount < 1) THEN
		BEGIN
			v_logStatus := LogSkip(3);
			SAVEPOINT WSInvoker;
				SELECT QUEUEID.NEXTVAL INTO v_QueueId FROM dual;
				EXECUTE IMMEDIATE 'INSERT INTO QueueDefTable (QUEUEID,QUEUENAME,QUEUETYPE,COMMENTS,ALLOWREASSIGNMENT,FILTEROPTION,FILTERVALUE,ORDERBY,QUEUEFILTER,REFRESHINTERVAL,SORTORDER,PROCESSNAME) values(' || v_QueueId || ', ''SystemBRMSQueue'',''A'',''Queue of QueueType A for WebServiceInvoker Utility is added thorugh Upgradenew.sql'',NULL,NULL,NULL,10,NULL,NULL,''A'',NULL)';
				DBMS_OUTPUT.PUT_LINE('Queue of QueueType A for WebServiceInvoker Utility is added successfully');

				v_queryStr := 'Select ProcessDefId, ActivityId from ActivityTable WHERE ActivityType = 31';
				OPEN Cursor1 FOR v_queryStr;
				LOOP
					FETCH Cursor1 INTO v_ProcessDefId, v_ActivityId;
					EXIT WHEN Cursor1%NOTFOUND;

					EXECUTE IMMEDIATE 'Update QueueStreamTable set QueueId = ' || v_QueueId || ' where activityId = ' || v_ActivityId || ' and processDefId = '||v_ProcessDefId;

					EXECUTE IMMEDIATE 'Update WFInstrumentTable set QueueName = ''SystemWSQueue'' ,Q_queueId = ' || v_QueueId || ' where activityId = ' || v_ActivityId || ' and processDefId = ' || v_ProcessDefId || ' and RoutingStatus =''N'' ';

				END LOOP;
				CLOSE Cursor1;
			COMMIT;
		EXCEPTION
		WHEN OTHERS THEN
			ROLLBACK TO SAVEPOINT WSInvoker;
			CLOSE Cursor1;
		END;
		END IF;
			
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(3);   
			raise_application_error(-20203,v_scriptName ||' BLOCK 3 FAILED');
	END;
	v_logStatus := LogUpdate(3);	


	v_logStatus := LogInsert(4,'Adding check constraint on column commentstype in WFCommentsTable');
	BEGIN
		/* Modifying the Check contraint on WFCommentsTable */
		BEGIN
			v_logStatus := LogSkip(4);
			SAVEPOINT ModifyCheckConstraint;
			v_IsConstraintUpdated := 0;
			v_SearchConditionOld := 'CommentsType IN (1, 2, 3)';
			v_SearchConditionNew := 'CommentsType IN (1, 2, 3, 4)';
			DECLARE CURSOR Cursor1 IS SELECT constraint_name, search_condition FROM user_constraints WHERE table_name = UPPER('WFCommentsTable') AND constraint_type = 'C';
			BEGIN
				OPEN Cursor1;
				LOOP
					FETCH Cursor1 INTO v_constraintName, v_SearchCondition;
					EXIT WHEN Cursor1%NOTFOUND;
					IF v_SearchCondition IS NOT NULL THEN
						IF UPPER(v_SearchCondition) = UPPER(v_SearchConditionOld) THEN
							EXECUTE IMMEDIATE 'ALTER TABLE WFCommentsTable DROP CONSTRAINT ' || v_constraintName;
						END IF;
						IF UPPER(v_SearchCondition) = UPPER(v_SearchConditionNew) THEN
							v_IsConstraintUpdated := 1;
						END IF;
					END IF;
				END LOOP;
				CLOSE Cursor1;
			END;
			IF v_IsConstraintUpdated = 0 THEN
				EXECUTE IMMEDIATE 'ALTER TABLE WFCommentsTable ADD CHECK(CommentsType IN (1, 2, 3, 4))';
			END IF;
		EXCEPTION
			WHEN OTHERS THEN
			ROLLBACK TO SAVEPOINT ModifyCheckConstraint;
			CLOSE Cursor1;
		END;	
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(4);   
			raise_application_error(-20204,v_scriptName ||' BLOCK 4 FAILED');
	END;
	v_logStatus := LogUpdate(4);	

	v_logStatus := LogInsert(5,'Adding new column DateTimeFormat in WFExportTable');
	BEGIN
		BEGIN
			existsFlag := 0;
			select 1 into existsFlag from user_tab_columns where upper(table_name) = upper('WFExportTable') and upper(column_name) = upper('DateTimeFormat');
			Exception when no_data_found then 
				v_logStatus := LogSkip(5);
				Execute Immediate('ALTER TABLE WFExportTable Add DateTimeFormat NVARCHAR2(50)');
		END;	
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(5);   
			raise_application_error(-20205,v_scriptName ||' BLOCK 5 FAILED');
	END;
	v_logStatus := LogUpdate(5);	


	v_logStatus := LogInsert(6,'CREATING TABLE pmsversioninfo');
	BEGIN
		BEGIN
			existsFlag := 0;
			select 1 into existsFlag from user_tables where table_name =  UPPER('pmsversioninfo');
			Exception when no_data_found then 
				v_logStatus := LogSkip(6);
					Execute Immediate( 'CREATE TABLE pmsversioninfo(
										product_acronym varchar2(100) not null,
										label varchar2(100) not null,
										previouslabel varchar2(100),
										updatedon date DEFAULT sysdate
									)');
		END;	
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(6);   
			raise_application_error(-20206,v_scriptName ||' BLOCK 6 FAILED');
	END;
	v_logStatus := LogUpdate(6);	


	v_logStatus := LogInsert(7,'Adding Primary Key( PROCESSINSTANCEID ,WORKITEMID ) in WFAUDITTRAILDOCTABLE ');
	BEGIN
		BEGIN
			v_logStatus := LogSkip(7);
			select UPPER(constraint_name) into v_primaryKeyName from user_constraints where upper(table_name) = upper('WFAUDITTRAILDOCTABLE') and constraint_type = 'P';
			Execute Immediate('Alter Table WFAUDITTRAILDOCTABLE Drop Primary Key');
			Execute Immediate('Alter Table WFAUDITTRAILDOCTABLE Add PRIMARY KEY  ( PROCESSINSTANCEID ,WORKITEMID ) ');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(7);   
			raise_application_error(-20207,v_scriptName ||' BLOCK 7 FAILED');
	END;
	v_logStatus := LogUpdate(7);	

	v_logStatus := LogInsert(9,'Inserting value in WFCabVersionTable for END of Omniflow 10.0');
	BEGIN
		v_logStatus := LogSkip(9);
		INSERT INTO WFCabVersionTable(cabVersion, cabVersionId, creationDate, lastModified, Remarks, Status) VALUES ('10.3' ,cabversionid.nextval, sysdate,sysdate , 'END of Omniflow 10.0','Y');
		COMMIT;	
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(9);   
			raise_application_error(-20209,v_scriptName ||' BLOCK 9 FAILED');
	END;
	v_logStatus := LogUpdate(9);	

	v_logStatus := LogInsert(10,'Adding new column MobileEnabled in ACTIVITYTABLE');
	BEGIN
		/* CHANGES FOR MOBILE SUPPORRT BEGINS */
		BEGIN
			existsFlag := 0;
			select 1 into existsFlag from user_tab_columns where upper(table_name) = upper('ACTIVITYTABLE') and upper(column_name) = upper('MobileEnabled');
			Exception when no_data_found then 
				v_logStatus := LogSkip(10);
				Execute Immediate('ALTER TABLE ACTIVITYTABLE Add MobileEnabled NVARCHAR2(1)');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(10);   
			raise_application_error(-20210,v_scriptName ||' BLOCK 10 FAILED');
	END;
	v_logStatus := LogUpdate(10);	
		
		

	v_logStatus := LogInsert(11,'Adding new column DeviceType in WFFORM_TABLE');
	BEGIN
		/* WFFORM_TABLE Changes */
		BEGIN
			existsFlag := 0;
			select 1 into existsFlag from user_tab_columns where upper(table_name) = upper('WFFORM_TABLE') and upper(column_name) = upper('DeviceType');
			Exception when no_data_found then 
				v_logStatus := LogSkip(11);
				Execute Immediate('ALTER TABLE WFFORM_TABLE Add DeviceType	NVARCHAR2(1)  DEFAULT ''D'' ');
		END;		

	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(11);   
			raise_application_error(-20211,v_scriptName ||' BLOCK 11 FAILED');
	END;
	v_logStatus := LogUpdate(11);	

	v_logStatus := LogInsert(12,'Adding new column FormHeight in WFFORM_TABLE');
	BEGIN
		BEGIN	
			existsFlag := 0;
			select 1 into existsFlag from user_tab_columns where upper(table_name) = upper('WFFORM_TABLE') and upper(column_name) = upper('FormHeight');
			Exception when no_data_found then
				v_logStatus := LogSkip(12);
				Execute Immediate('ALTER TABLE WFFORM_TABLE Add FormHeight	INT DEFAULT(100) NOT NULL');
		END;

	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(12);   
			raise_application_error(-20212,v_scriptName ||' BLOCK 12 FAILED');
	END;
	v_logStatus := LogUpdate(12);	

	v_logStatus := LogInsert(13,'Adding new column FormWidth in WFFORM_TABLE');
	BEGIN
		BEGIN	
			existsFlag := 0;
			select 1 into existsFlag from user_tab_columns where upper(table_name) = upper('WFFORM_TABLE') and upper(column_name) = upper('FormWidth');
			Exception when no_data_found then 
				v_logStatus := LogSkip(13);
				Execute Immediate('ALTER TABLE WFFORM_TABLE Add FormWidth INT DEFAULT(100) NOT NULL');
		END;
		
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(13);   
			raise_application_error(-20213,v_scriptName ||' BLOCK 13 FAILED');
	END;
	v_logStatus := LogUpdate(13);

	v_logStatus := LogInsert(14,'Add PRIMARY KEY(ProcessDefID,FormId,DeviceType) in WFFORM_TABLE');
	BEGIN
		BEGIN	
			existsFlag := 0;
			select 1 into existsFlag from user_constraints where upper(table_name) = upper('WFFORM_TABLE') and constraint_type = 'P';
			Exception when no_data_found then 
				v_logStatus := LogSkip(14);
				Execute Immediate('ALTER TABLE WFFORM_TABLE Add PRIMARY KEY(ProcessDefID,FormId,DeviceType)');
		END;
		
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(14);   
			raise_application_error(-20214,v_scriptName ||' BLOCK 14 FAILED');
	END;
	v_logStatus := LogUpdate(14);

	v_logStatus := LogInsert(15,'Adding new column DeviceType in WFFormFragmentTable');
	BEGIN
		/* WFFormFragmentTable Changes */
		BEGIN
			existsFlag := 0;
			select 1 into existsFlag from user_tab_columns where upper(table_name) = upper('WFFormFragmentTable') and upper(column_name) = upper('DeviceType');
			Exception when no_data_found then 
				v_logStatus := LogSkip(15);
				Execute Immediate('ALTER TABLE WFFormFragmentTable Add DeviceType	NVARCHAR2(1)  DEFAULT ''D'' ');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(15);   
			raise_application_error(-20215,v_scriptName ||' BLOCK 15 FAILED');
	END;
	v_logStatus := LogUpdate(15);	

	v_logStatus := LogInsert(16,'Adding new column FormHeight in WFFormFragmentTable');
	BEGIN
		BEGIN	
			existsFlag := 0;
			select 1 into existsFlag from user_tab_columns where upper(table_name) = upper('WFFormFragmentTable') and upper(column_name) = upper('FormHeight');
			Exception when no_data_found then 
				v_logStatus := LogSkip(16);
				Execute Immediate('ALTER TABLE WFFormFragmentTable Add FormHeight	INT DEFAULT(100) NOT NULL');
		END;
		
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(16);   
			raise_application_error(-20216,v_scriptName ||' BLOCK 16 FAILED');
	END;
	v_logStatus := LogUpdate(16);	

	v_logStatus := LogInsert(17,'Adding new column FormWidth in WFFormFragmentTable');
	BEGIN
		BEGIN	
			existsFlag := 0;
			select 1 into existsFlag from user_tab_columns where upper(table_name) = upper('WFFormFragmentTable') and upper(column_name) = upper('FormWidth');
			Exception when no_data_found then 
				v_logStatus := LogSkip(17);
				Execute Immediate('ALTER TABLE WFFormFragmentTable Add FormWidth INT DEFAULT(100) NOT NULL');
		END;
		
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(17);   
			raise_application_error(-20217,v_scriptName ||' BLOCK 17 FAILED');
	END;
	v_logStatus := LogUpdate(17);	

	v_logStatus := LogInsert(18,'Add PRIMARY KEY(ProcessDefID,FragmentId) in WFFormFragmentTable');
	BEGIN
		BEGIN	
			existsFlag := 0;
			select 1 into existsFlag from user_constraints where upper(table_name) = upper('WFFormFragmentTable') and constraint_type = 'P';
			Exception when no_data_found then 
				v_logStatus := LogSkip(18);
				Execute Immediate('ALTER TABLE WFFormFragmentTable Add PRIMARY KEY(ProcessDefID,FragmentId)');
		END;
		
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(18);   
			raise_application_error(-20218,v_scriptName ||' BLOCK 18 FAILED');
	END;
	v_logStatus := LogUpdate(18);

	v_logStatus := LogInsert(19,'CREATING and Inserting values TABLE WFWorkListConfigTable');
	BEGIN
		/* Creation of WFWorkListConfigTable*/
		BEGIN
			existsFlag := 0;
			select 1 into existsFlag from user_tables where table_name =  UPPER('WFWorkListConfigTable');
			Exception when no_data_found then 
					v_logStatus := LogSkip(19);
					Execute Immediate( 'CREATE TABLE WFWorkListConfigTable(	
											QueueId				INT NOT NULL,
											VariableId			INT ,
											AliasId	        	INT,
											ViewCategory		NVARCHAR2(1),
											VariableType		NVARCHAR2(1),
											DisplayName			NVARCHAR2(50),
											MobileDisplay		NVARCHAR2(2)
									)');
									
			  Execute Immediate( ' insert into WFWorkListConfigTable values (0,29,0,''M'',''S'',''EntryDateTime'',''Y'') ');
			  Execute Immediate('insert into WFWorkListConfigTable values (0,31,0,''M'',''S'',''ProcessInstanceName'',''Y'') ');
			  Execute Immediate('insert into WFWorkListConfigTable values (0,32,0,''M'',''S'',''CreatedByName'',''Y'') ');
			  Execute Immediate('insert into WFWorkListConfigTable values (0,37,0,''M'',''S'',''InstrumentStatus'',''Y'') ');
			  Execute Immediate('insert into WFWorkListConfigTable values (0,38,0,''M'',''S'',''PriorityLevel'',''Y'') ');
			  Execute Immediate('insert into WFWorkListConfigTable values (0,46,0,''M'',''S'',''LockedByName'',''Y'') ');
			  Execute Immediate('insert into WFWorkListConfigTable values (0,48,0,''M'',''S'',''LockStatus'',''Y'') ');
			  Execute Immediate('insert into WFWorkListConfigTable values (0,52,0,''M'',''S'',''ProcessedBy'',''Y'') ');
			  
		END;
		
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(19);   
			raise_application_error(-20219,v_scriptName ||' BLOCK 19 FAILED');
	END;
	v_logStatus := LogUpdate(19);	

	v_logStatus := LogInsert(20,'Adding new column context in table processdeftable');
	BEGIN
		/* CHANGES FOR MOBILE SUPPORRT ENDS */

		BEGIN
			existsFlag := 0;
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('processdeftable') 
			AND 
			COLUMN_NAME=UPPER('context');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_logStatus := LogSkip(20);
				EXECUTE IMMEDIATE 'ALTER TABLE processdeftable ADD context nvarchar2(50)';
				DBMS_OUTPUT.PUT_LINE('Table processdeftable altered with new Column context');
		END; 
		
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(20);   
			raise_application_error(-20220,v_scriptName ||' BLOCK 20 FAILED');
	END;
	v_logStatus := LogUpdate(20);	

	v_logStatus := LogInsert(21,'Adding new column TempContext in table GTempProcessTable');
	BEGIN
			BEGIN
			existsFlag := 0;
				SELECT 1 INTO existsFlag
				FROM USER_TAB_COLUMNS
				WHERE UPPER(TABLE_NAME) = 'GTEMPPROCESSTABLE'
				AND Upper(COLUMN_NAME) in ('TEMPCONTEXT');
			  EXCEPTION
				WHEN NO_DATA_FOUND THEN 
					v_logStatus := LogSkip(21);
					EXECUTE IMMEDIATE 'ALTER TABLE GTempProcessTable ADD TempContext NVarchar2(50)';
					DBMS_OUTPUT.PUT_LINE ('Table GTempProcessTable altered successfully');
			END;

	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(21);   
			raise_application_error(-20221,v_scriptName ||' BLOCK 21 FAILED');
	END;
	v_logStatus := LogUpdate(21);			

	v_logStatus := LogInsert(22,'Adding new column FailRecords in table WFImportFileData');
	BEGIN
		/* Adding FailRecords column in WFImportFileData table*/
		existsFlag := 0;
		BEGIN
			SELECT 1 INTO existsFlag FROM USER_TAB_COLUMNS WHERE TABLE_NAME = UPPER('WFImportFileData') AND COLUMN_NAME = UPPER('FailRecords');
		EXCEPTION
		WHEN NO_DATA_FOUND THEN
			v_logStatus := LogSkip(22);
			EXECUTE IMMEDIATE 'UPDATE WFImportFileData SET FileStatus = ''S'' WHERE FileStatus = ''I''';
			EXECUTE IMMEDIATE 'ALTER TABLE WFImportFileData ADD FailRecords INT DEFAULT 0';
			EXECUTE IMMEDIATE 'UPDATE WFImportFileData SET FailRecords = 0';
			DBMS_OUTPUT.PUT_LINE('Table WFImportFileData altered with new Column FailRecords');
		END;
		
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(22);   
			raise_application_error(-20222,v_scriptName ||' BLOCK 22 FAILED');
	END;
	v_logStatus := LogUpdate(22);

	v_logStatus := LogInsert(23,'CREATING TABLE WFFailFileRecords,CREATING SEQUENCE WFFailFileRecords_SEQ,CREATING TRIGGER WFFailFileRecords_TRG BEFORE INSERT ON WFFailFileRecords FOR EACH ROW');
	BEGIN
		/* Creating WFFailFileRecords table*/
		existsFlag := 0;
		BEGIN 
			SELECT 1 INTO existsFlag FROM USER_TABLES WHERE TABLE_NAME = UPPER('WFFailFileRecords');
		EXCEPTION 
		WHEN NO_DATA_FOUND THEN
			v_logStatus := LogSkip(23);
			EXECUTE IMMEDIATE 'CREATE TABLE WFFailFileRecords (
				FailRecordId INT NOT NULL,
				FileIndex INT,
				RecordNo INT,
				RecordData NVARCHAR2(2000),
				Message NVARCHAR2(1000),
				EntryTime TIMESTAMP DEFAULT SYSDATE
			)';
			DBMS_OUTPUT.PUT_LINE('Table WFFailFileRecords Created successfully');

			EXECUTE IMMEDIATE 'CREATE SEQUENCE WFFailFileRecords_SEQ';
			DBMS_OUTPUT.PUT_LINE('Sequence WFFailFileRecords_SEQ Created successfully');

			EXECUTE IMMEDIATE 'CREATE OR REPLACE TRIGGER WFFailFileRecords_TRG BEFORE INSERT ON WFFailFileRecords FOR EACH ROW BEGIN SELECT WFFailFileRecords_SEQ.NEXTVAL INTO :NEW.FailRecordId FROM DUAL; END;';
			DBMS_OUTPUT.PUT_LINE('Trigger WFFailFileRecords_TRG Created successfully');
		END;
		
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(23);   
			raise_application_error(-20223,v_scriptName ||' BLOCK 23 FAILED');
	END;
	v_logStatus := LogUpdate(23);

	v_logStatus := LogInsert(24,'Adding new column ThresholdRoutingCount in table ProcessDefTable');
	BEGIN
		existsFlag := 0;
		BEGIN
			SELECT 1 INTO existsFlag FROM USER_TAB_COLUMNS WHERE TABLE_NAME = UPPER('ProcessDefTable') AND COLUMN_NAME = UPPER('ThresholdRoutingCount');
		EXCEPTION
		WHEN NO_DATA_FOUND THEN
		BEGIN
			v_logStatus := LogSkip(24);
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
							DBMS_OUTPUT.PUT_LINE('No record present in ACTIVITYTABLE for processdefId' || v_ProcessDefId);
						END IF;
				  EXCEPTION WHEN OTHERS THEN
					  DBMS_OUTPUT.PUT_LINE('inside exception when updating ThresholdRoutingCount column of processdeftable ');
					END;
				COMMIT;
			END LOOP;
			CLOSE processCursor;

			DBMS_OUTPUT.PUT_LINE('Table ProcessDefTable altered with new Column ThresholdRoutingCount');
		 END;
		END;
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(24);   
			raise_application_error(-20224,v_scriptName ||' BLOCK 24 FAILED');
	END;
	v_logStatus := LogUpdate(24);	
		


	v_logStatus := LogInsert(25,'Mapping RoutingCount variable with Var_Rec_5 ');
	BEGIN
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
				v_logStatus := LogSkip(25);
				SAVEPOINT ROUTINGTRAN;
				EXECUTE IMMEDIATE 'UPDATE VARMAPPINGTABLE SET USERDEFINEDNAME = ''RoutingCount'' WHERE UPPER(USERDEFINEDNAME) = ''VAR_REC_5''';
				EXECUTE IMMEDIATE 'ALTER TABLE WFInstrumentTable MODIFY VAR_REC_5 DEFAULT ''0''';
				EXECUTE IMMEDIATE 'UPDATE WFInstrumentTable SET VAR_REC_5 = ''0'' WHERE VAR_REC_5 is NULL OR LENGTH(VAR_REC_5) <= 0';			
				DBMS_OUTPUT.PUT_LINE('RoutingCount variable mapped with Var_Rec_5 successfully.');
				COMMIT;
			EXCEPTION
				WHEN OTHERS THEN
				BEGIN
					ROLLBACK TO SAVEPOINT ROUTINGTRAN;
					DBMS_OUTPUT.PUT_LINE('Some error occured in mapping RoutingCount variable with Var_Rec_5.');
				END;			
			END;
			END IF;
		END;
		
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(25);   
			raise_application_error(-20225,v_scriptName ||' BLOCK 25 FAILED');
	END;
	v_logStatus := LogUpdate(25);	
		



	v_logStatus := LogInsert(26,' Creating WFCommentsHistoryTable table');
	BEGIN
		/* Creating WFCommentsHistoryTable table*/
		existsFlag := 0;
		BEGIN 
			SELECT 1 INTO existsFlag FROM USER_TABLES WHERE TABLE_NAME = UPPER('WFCommentsHistoryTable');
		EXCEPTION 
		WHEN NO_DATA_FOUND THEN
			BEGIN
			v_logStatus := LogSkip(26);
			EXECUTE IMMEDIATE
				'CREATE TABLE WFCommentsHistoryTable (
					CommentsId			INT					PRIMARY KEY,
					ProcessDefId 		INT					NOT NULL,
					ActivityId 			INT					NOT NULL,
					ProcessInstanceId 	NVARCHAR2(64)		NOT NULL,
					WorkItemId 			INT					NOT NULL,
					CommentsBy			INT					NOT NULL,
					CommentsByName		NVARCHAR2(64)		NOT NULL,
					CommentsTo			INT					NOT NULL,
					CommentsToName		NVARCHAR2(64)		NOT NULL,
					Comments			NVARCHAR2(1000)		NULL,
					ActionDateTime		DATE				NOT NULL,
					CommentsType		INT					NOT NULL CHECK(CommentsType IN (1, 2, 3, 4))
				)';
			END;
		END;

	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(26);   
			raise_application_error(-20226,v_scriptName ||' BLOCK 26 FAILED');
	END;
	v_logStatus := LogUpdate(26);
		

	v_logStatus := LogInsert(27,'Adding AppServerId column in WFSystemServicesTable');
	BEGIN
		/* Adding AppServerId column in WFSystemServicesTable */
		existsFlag := 0;
		BEGIN
			SELECT 1 INTO existsFlag FROM USER_TAB_COLUMNS WHERE TABLE_NAME = UPPER('WFSystemServicesTable') AND COLUMN_NAME = UPPER('AppServerId');
		EXCEPTION
		WHEN NO_DATA_FOUND THEN
			BEGIN
				v_logStatus := LogSkip(27);
				EXECUTE IMMEDIATE 'ALTER TABLE WFSystemServicesTable ADD AppServerId NVARCHAR2(50)';
			END;
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(27);   
			raise_application_error(-20227,v_scriptName ||' BLOCK 27 FAILED');
	END;
	v_logStatus := LogUpdate(27);

	v_logStatus := LogInsert(28, 'Updating VariableId1 in VarAliasTable if VariableId1 is 0');
	BEGIN
		OPEN v_ProcessCursor FOR SELECT ProcessDefId FROM ProcessDefTable;
		LOOP
			FETCH v_ProcessCursor INTO v_ProcessDefId;
			EXIT WHEN v_ProcessCursor%NOTFOUND;
			OPEN v_AliasCursor FOR SELECT Alias, Param1, QueueId, ProcessDefId FROM VarAliasTable WHERE VariableId1 IS NULL OR VariableId1 = 0;
			LOOP
				FETCH v_AliasCursor INTO v_Alias, v_Param1, v_QueueId, v_ProcDefId;
				EXIT WHEN v_AliasCursor%NOTFOUND;
				SELECT VariableId INTO v_VariableId FROM VarMappingTable WHERE ((UPPER(SystemDefinedName) = UPPER(v_Param1)) OR (UPPER(UserDefinedName) = UPPER(v_Param1))) AND ProcessDefId = v_ProcessDefId;
				v_VariableId := 100 + v_VariableId;
				UPDATE VarAliasTable SET VariableId1 = v_VariableId WHERE QueueId = v_QueueId AND ProcessDefId = v_ProcDefId AND UPPER(Alias) = UPPER(v_Alias);
			END LOOP;
			CLOSE v_AliasCursor;
		END LOOP;
		CLOSE v_ProcessCursor;
	EXCEPTION
	WHEN OTHERS THEN
		v_logStatus := LogUpdateError(28);   
		raise_application_error(-20228, v_scriptName || ' BLOCK 28 FAILED');
	END;
	v_logStatus := LogUpdate(28);

	v_logStatus := LogInsert(29, 'Droping column ProcessInstanceId from WFMessageTable');
	BEGIN
		existsFlag := 0;
		BEGIN
			SELECT 1 INTO existsFlag FROM USER_TAB_COLUMNS WHERE UPPER(table_name) = UPPER('WFMessageTable') and UPPER(column_name) = UPPER('ProcessInstanceId');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				existsFlag := 0;
		END;
		IF existsFlag = 1 THEN
		BEGIN
			v_logStatus := LogSkip(29);
			EXECUTE IMMEDIATE 'ALTER TABLE WFMessageTable DROP COLUMN ProcessInstanceId';
		END;
		END IF;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(29);
			raise_application_error(-20229, v_scriptName || ' BLOCK 29 FAILED');
	END;
	v_logStatus := LogUpdate(29);

	v_logStatus := LogInsert(30, 'Droping column ActionId from WFMessageTable');
	BEGIN
		existsFlag := 0;
		BEGIN
			SELECT 1 INTO existsFlag FROM USER_TAB_COLUMNS WHERE UPPER(table_name) = UPPER('WFMessageTable') and UPPER(column_name) = UPPER('ActionId');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				existsFlag := 0;
		END;
		IF existsFlag = 1 THEN
		BEGIN
			v_logStatus := LogSkip(30);
			EXECUTE IMMEDIATE 'ALTER TABLE WFMessageTable DROP COLUMN ActionId';
		END;
		END IF;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(30);
			raise_application_error(-20230, v_scriptName || ' BLOCK 30 FAILED');
	END;
	v_logStatus := LogUpdate(30);

	v_logStatus := LogInsert(31, 'Droping column ProcessInstanceId from WFFailedMessageTable');
	BEGIN
		existsFlag := 0;
		BEGIN
			SELECT 1 INTO existsFlag FROM USER_TAB_COLUMNS WHERE UPPER(table_name) = UPPER('WFFailedMessageTable') and UPPER(column_name) = UPPER('ProcessInstanceId');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				existsFlag := 0;
		END;
		IF existsFlag = 1 THEN
		BEGIN
			v_logStatus := LogSkip(31);
			EXECUTE IMMEDIATE 'ALTER TABLE WFFailedMessageTable DROP COLUMN ProcessInstanceId';
		END;
		END IF;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(31);
			raise_application_error(-20231, v_scriptName || ' BLOCK 31 FAILED');
	END;
	v_logStatus := LogUpdate(31);

	v_logStatus := LogInsert(32, 'Droping column ActionId from WFFailedMessageTable');
	BEGIN
		existsFlag := 0;
		BEGIN
			SELECT 1 INTO existsFlag FROM USER_TAB_COLUMNS WHERE UPPER(table_name) = UPPER('WFFailedMessageTable') and UPPER(column_name) = UPPER('ActionId');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				existsFlag := 0;
		END;
		IF existsFlag = 1 THEN
		BEGIN
			v_logStatus := LogSkip(32);
			EXECUTE IMMEDIATE 'ALTER TABLE WFFailedMessageTable DROP COLUMN ActionId';
		END;
		END IF;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(32);
			raise_application_error(-20232, v_scriptName || ' BLOCK 32 FAILED');
	END;
	v_logStatus := LogUpdate(32);

	v_logStatus := LogInsert(33, 'Changing Type1 to SMALLINT in VarAliasTable');
	BEGIN
		existsFlag := 0;
		BEGIN
			SELECT 1 INTO existsFlag FROM USER_TAB_COLUMNS WHERE UPPER(table_name) = UPPER('VarAliasTable') AND UPPER(column_name) = UPPER('Type1') AND UPPER(data_type) = UPPER('NUMBER');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				existsFlag := 0;
		END;
		IF existsFlag <> 1 THEN
			v_logStatus := LogSkip(33);
			DECLARE CURSOR aliascursor1 IS SELECT DISTINCT Alias, Param1, QueueId, ProcessDefId FROM VarAliasTable WHERE (Type1 IS NULL OR Type1 = '' OR Type1 = 'C' OR Type1 = 'V' OR Type1 = '*');
			BEGIN
				OPEN aliascursor1;
				LOOP
					FETCH aliascursor1 INTO v_Alias, v_Param1, v_QueueId, v_ProcDefId;
					EXIT WHEN aliascursor1%NOTFOUND;
					IF v_ProcDefId IS NULL OR v_ProcDefId = 0 THEN
						UPDATE VarAliasTable SET Type1 = (SELECT VariableType FROM VarMappingTable WHERE UPPER(SystemDefinedName) = UPPER(v_Param1) AND ROWNUM <= 1) WHERE Alias = v_Alias AND QueueId = v_QueueId;
					ELSE
						UPDATE VarAliasTable SET Type1 = (SELECT VariableType FROM VarMappingTable WHERE UPPER(SystemDefinedName) = UPPER(v_Param1) AND ProcessDefId = v_ProcDefId AND ROWNUM <= 1) WHERE Alias = v_Alias AND QueueId = v_QueueId AND ProcessDefId = v_ProcDefId;
					END IF;
				END LOOP;
				CLOSE aliascursor1;
			EXCEPTION
				WHEN OTHERS THEN
					CLOSE aliascursor1;
					raise_application_error(-20233, v_scriptName || ' BLOCK 33 FAILED');
			END;
			EXECUTE IMMEDIATE 'ALTER TABLE VarAliasTable ADD TempType1 SMALLINT';
			EXECUTE IMMEDIATE 'UPDATE VarAliasTable SET TempType1 = CAST(Type1 AS SMALLINT)';
			EXECUTE IMMEDIATE 'ALTER TABLE VarAliasTable DROP COLUMN Type1';
			EXECUTE IMMEDIATE 'ALTER TABLE VarAliasTable RENAME COLUMN TempType1 TO Type1';
		END IF;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(33);
			raise_application_error(-20233, v_scriptName || ' BLOCK 33 FAILED');
	END;
	v_logStatus := LogUpdate(33);

	v_logStatus := LogInsert(34, 'Setting data class id used in archive activity if blank');
	BEGIN
		v_logStatus := LogSkip(34);
		DECLARE CURSOR tempcur IS SELECT ProcessDefId, ActivityId, ArchiveDataClassName FROM ArchiveTable WHERE ArchiveDataClassName IS NOT NULL AND ArchiveDataClassId IS NULL;
		BEGIN
			OPEN tempcur;
			LOOP
				FETCH tempcur INTO v_ProcDefId, v_ActivityId, v_DataClassName;
				EXIT WHEN tempcur%NOTFOUND;
				UPDATE ArchiveTable SET ArchiveDataClassId = (SELECT DataDefIndex FROM PDBDataDefinition WHERE DataDefName = v_DataClassName) WHERE ProcessDefId = v_ProcDefId AND ActivityId = v_ActivityId AND ArchiveDataClassName = v_DataClassName;
			END LOOP;
			CLOSE tempcur;
		EXCEPTION
			WHEN OTHERS THEN
				CLOSE tempcur;
				raise_application_error(-20234, v_scriptName || ' BLOCK 34 FAILED');
		END;

		DECLARE CURSOR tempcur IS SELECT ProcessDefId, ArchiveId, DocTypeId, AssocClassName FROM ArchiveDocTypeTable WHERE AssocClassName IS NOT NULL AND AssocClassId IS NULL;
		BEGIN
			OPEN tempcur;
			LOOP
				FETCH tempcur INTO v_ProcDefId, v_ArchiveId, v_DocTypeId, v_DataClassName;
				EXIT WHEN tempcur%NOTFOUND;
				UPDATE ArchiveDocTypeTable SET AssocClassId = (SELECT DataDefIndex FROM PDBDataDefinition WHERE DataDefName = v_DataClassName) WHERE ProcessDefId = v_ProcDefId AND ArchiveId = v_ArchiveId AND DocTypeId = v_DocTypeId AND AssocClassName = v_DataClassName;
			END LOOP;
			CLOSE tempcur;
		EXCEPTION
			WHEN OTHERS THEN
				CLOSE tempcur;
				raise_application_error(-20234, v_scriptName || ' BLOCK 34 FAILED');
		END;

		DECLARE CURSOR tempcur IS SELECT A.ProcessDefId, A.ArchiveId, A.DocTypeId, A.DataFieldName, B.AssocClassName FROM ArchiveDataMapTable A, ArchiveDocTypeTable B WHERE A.ProcessDefId = B.ProcessDefId AND A.ArchiveId = B.ArchiveId AND A.DocTypeId = B.DocTypeId AND A.DataFieldName IS NOT NULL AND A.DataFieldId IS NULL;
		BEGIN
			OPEN tempcur;
			LOOP
				FETCH tempcur INTO v_ProcDefId, v_ArchiveId, v_DocTypeId, v_DataFieldName, v_DataClassName;
				EXIT WHEN tempcur%NOTFOUND;
				UPDATE ArchiveDataMapTable SET DataFieldId = (SELECT A.DataFieldIndex FROM PDBGlobalIndex A, PDBDataFieldsTable B, PDBDataDefinition C WHERE A.DataFieldIndex = B.DataFieldIndex AND B.DataDefIndex = C.DataDefIndex AND C.DataDefName = v_DataClassName AND A.DataFieldName = v_DataFieldName) WHERE ProcessDefId = v_ProcDefId AND ArchiveId = v_ArchiveId AND DocTypeId = v_DocTypeId AND DataFieldName = v_DataFieldName;
			END LOOP;
			CLOSE tempcur;
		EXCEPTION
			WHEN OTHERS THEN
				CLOSE tempcur;
				raise_application_error(-20234, v_scriptName || ' BLOCK 34 FAILED');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(34);
			raise_application_error(-20234, v_scriptName || ' BLOCK 34 FAILED');
	END;
	v_logStatus := LogUpdate(34);
	
	
END;

~

call Upgrade()

~

Drop procedure Upgrade

~
