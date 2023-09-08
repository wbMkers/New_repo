/*______________________________________________________________________________________________________________-
		NEWGEN SOFTWARE TECHNOLOGIES LIMITED

	Group						: Application – Products
	Product / Project			: WorkFlow
	Module						: Transaction Server
	File NAME					: UpgradeDataTypesandChecks.sql (Oracle Server)
	Author						: Chitvan Chhabra
	Date written (DD/MM/YYYY)	: 7/17/2014
	Description					: For changing of datatypes and addition of constraints on heavy tables(Example transaction related tables)
_________________________________________________________________________________________________________________*/
/*
Change DATE		Name				Description
----------------------------------------------------------------------------------------------------------------------------------------------
26/05/2017		Sanal Grover	Bug 62518 - Step by Step Debugs in Version Upgrade.

----------------------------------------------------------------------------------------------------------------------------------------------
*/

/*
*v_existingCheckOnColoumn would denote the coulumn which has any check ,This check may or may corresponds to the check denoted by v_searchConditionString
*v_existingCheckOnColoumn is constarint name
*v_searchConditionString Please take care of any spacing issues.
*/
CREATE OR REPLACE PROCEDURE checkColoumnCheck( v_tableName IN VARCHAR2,
												v_colName IN VARCHAR2,
												v_searchConditionString IN NVARCHAR2 ,
												v_existenceOfCheck OUT NUMBER ,
												v_existingCheckOnColoumn OUT NVARCHAR2  )

AS

v_tmp NVARCHAR2(5000);
--search_cond varchar2(400);
BEGIN
--search_cond:=q'{status in (N'N', N'L')}';

v_existenceOfCheck := 0;

	FOR c_checkString	IN (SELECT SEARCH_CONDITION ,UC.CONSTRAINT_NAME
							FROM USER_CONS_COLUMNS  UCC,USER_CONSTRAINTS UC 
							WHERE UCC.TABLE_NAME=UC.TABLE_NAME AND UCC.CONSTRAINT_NAME=UC.CONSTRAINT_NAME  AND UCC.TABLE_NAME = UPPER(v_tableName) AND 
							UCC.COLUMN_NAME = UPPER(v_colName) )
    LOOP      

          v_existingCheckOnColoumn:=c_checkString.CONSTRAINT_NAME;
		  
		  DBMS_OUTPUT.PUT_LINE('c_checkString.SEARCH_CONDITION'||UPPER(c_checkString.SEARCH_CONDITION));
		  DBMS_OUTPUT.PUT_LINE('UPPER(v_searchConditionString)'||UPPER(v_searchConditionString));
		  
		  v_tmp:=c_checkString.SEARCH_CONDITION;
		  
		  
		  IF UPPER(v_tmp)=UPPER(v_searchConditionString)
          THEN
			v_existenceOfCheck:=1;
          
          END IF;
    END LOOP; 
	
	IF v_existenceOfCheck = 1
	THEN
		DBMS_OUTPUT.PUT_LINE('Check on TABLE '||TO_CHAR(v_tableName)||' and on Coulumn '||v_colName||' EXISTS!!!!' );
	ELSE
		DBMS_OUTPUT.PUT_LINE('Check on TABLE '||TO_CHAR(v_tableName)||' and on Coulumn '||v_colName||' DOES NOT EXISTS!!!!' );	
	END IF;

	

END;


~

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

CREATE OR REPLACE PROCEDURE UpgradeDataTypesandChecks
AS

v_checkString 			NVARCHAR2(100);
v_constraintName 		NVARCHAR2(100);
existsflag 				NUMBER;
v_ExtAppTypeCheckflag 	NUMBER;
v_constraintName1 		NVARCHAR2(2000);
v_constraintName2 		NVARCHAR2(2000);
v_ReturnTypeCheckflag 	NUMBER;
v_ColData 				NUMBER;
v_insertSql 			VARCHAR2(32000);
v_SAPconstraintName		VARCHAR2(512);
v_nextseq1				NUMBER;
v_nextseq2				NUMBER;
v_tableexistence		NUMBER;
v_TableExists			INTEGER;
v_logStatus 			BOOLEAN;
v_scriptName        	NVARCHAR2(100) := 'Upgrade09_SP06_002_DataTypesandChecks';
		
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


	v_logStatus := LogInsert(1,'Inserting Value in WFCabVersionTable for START of UpgradeDataTypesandChecks.sql');
	BEGIN
		v_logStatus := LogSkip(1);
		BEGIN 
			SELECT 1 INTO v_TableExists 
			FROM USER_TABLES  
			WHERE TABLE_NAME = 'PENDINGWORKLISTTABLE';
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
				v_TableExists := 0;
				dbms_output.put_line ('PENDINGWORKLISTTABLE does not exists');
		END;
		
		SELECT  cabversionid.nextval INTO v_nextseq1  FROM DUAL;
		INSERT INTO WFCabVersionTable(cabVersion, cabVersionId, creationDate, lastModified, Remarks, Status) VALUES ('9.0' ,v_nextseq1 , sysdate,sysdate , 'START of UpgradeDataTypesandChecks.sql for SU6','Y');
		COMMIT;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(1);   
			raise_application_error(-20201,v_scriptName ||' BLOCK 1 FAILED');
	END;
	v_logStatus := LogUpdate(1);


	v_logStatus := LogInsert(2,'Updating Check constraint for Status column in WFMessageTable');
	BEGIN
		BEGIN
				
				v_checkString := q'{status in (N'N',N'L')}';
				existsflag:=0;
				checkColoumnCheck( v_tableName =>'WFMESSAGETABLE',
								   v_colName =>'STATUS',
								   v_searchConditionString => v_checkString,
								   v_existenceOfCheck =>existsflag ,
								   v_existingCheckOnColoumn =>v_constraintName  );

				IF(existsflag= 0)
				THEN
					v_logStatus := LogSkip(2);
					IF( v_constraintName IS NOT NULL)
					THEN
						
						DBMS_OUTPUT.PUT_LINE('Dropping Check constraint  Status column in WFMessageTable');
						EXECUTE IMMEDIATE 'Alter Table WFMessageTable Drop Constraint ' || TO_CHAR(v_constraintName);
						DBMS_OUTPUT.PUT_LINE('Check constraint  Status column in WFMessageTable drooped...');
						
						DBMS_OUTPUT.PUT_LINE('Creating Check constraint  Status column in WFMessageTable');
						EXECUTE IMMEDIATE 'Alter Table WFMessageTable Add check (STATUS in (N''N'',N''L''))';
						DBMS_OUTPUT.PUT_LINE('Check constraint updated for Status column in WFMessageTable');
					
					ELSE	
						DBMS_OUTPUT.PUT_LINE('Creating Check constraint  Status column in WFMessageTable');
						EXECUTE IMMEDIATE 'Alter Table WFMessageTable Add check (STATUS in (N''N'',N''L''))';
						DBMS_OUTPUT.PUT_LINE('Check constraint updated for Status column in WFMessageTable');
					END IF;
					
					DBMS_OUTPUT.PUT_LINE('Check constraint updated for Status column in WFMessageTable');
						
					EXECUTE IMMEDIATE 'INSERT INTO WFCabVersionTable(cabVersion, cabVersionId, creationDate, lastModified, Remarks, Status) VALUES (N''9.0_Check_WFMessageTable'', cabVersionId.nextVal, SYSDATE, SYSDATE, N''OmniFlow 9.0'', N''Y'')';	

				END IF;
			
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(2);   
			raise_application_error(-20202,v_scriptName ||' BLOCK 2 FAILED');
	END;
	v_logStatus := LogUpdate(2);
		
		

	v_logStatus := LogInsert(3,'Modifying columns TargetCabinetName,TARGETUSERNAME to nullable in WFExportinfotable');
	BEGIN
			BEGIN
				v_logStatus := LogSkip(3);	
				dbms_output.put_line('Dealing with WFEXPORTINFOTABLE table coloumns.....');
				existsFlag := 0; 
				BEGIN
					SELECT 1 INTO existsFlag FROM USER_TAB_COLUMNS WHERE TABLE_NAME = 'WFEXPORTINFOTABLE' AND Column_name = 'TARGETCABINETNAME' and NULLABLE = 'Y';
				EXCEPTION
					WHEN NO_DATA_FOUND THEN
						EXECUTE IMMEDIATE 'Alter Table WFExportinfotable MODIFY TARGETCABINETNAME NULL';
						DBMS_OUTPUT.PUT_LINE('Column TargetCabinetName can be null in WFEXPORTINFOTABLE');
				END;
				
				existsFlag := 0;
				BEGIN
					SELECT 1 INTO existsFlag FROM USER_TAB_COLUMNS WHERE TABLE_NAME = 'WFEXPORTINFOTABLE' AND Column_name = 'TARGETUSERNAME' and NULLABLE = 'Y';
				EXCEPTION
					WHEN NO_DATA_FOUND THEN
						EXECUTE IMMEDIATE 'Alter Table WFExportinfotable MODIFY TARGETUSERNAME NULL';
						DBMS_OUTPUT.PUT_LINE('Column TARGETUSERNAME can be null in WFEXPORTINFOTABLE');
				END;
				
				existsFlag := 0;
				BEGIN
					SELECT 1 INTO existsFlag FROM USER_TAB_COLUMNS WHERE TABLE_NAME = 'WFEXPORTINFOTABLE' AND Column_name = 'TARGETPASSWORD' and NULLABLE = 'Y';
				EXCEPTION
					WHEN NO_DATA_FOUND THEN
						EXECUTE IMMEDIATE 'Alter Table WFExportinfotable MODIFY TARGETPASSWORD NULL';
						DBMS_OUTPUT.PUT_LINE('Column TARGETPASSWORD can be null in WFEXPORTINFOTABLE');
				END;

				dbms_output.put_line('End Of Dealing with WFEXPORTINFOTABLE table coloumns.....');

			END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(3);   
			raise_application_error(-20203,v_scriptName ||' BLOCK 3 FAILED');
	END;
	v_logStatus := LogUpdate(3);



	v_logStatus := LogInsert(4,'Recreating table EXTMETHODDEFTABLE');
	BEGIN
		
		dropTableIfExist('EXTMETHODDEFTABLE2');

		BEGIN
			v_logStatus := LogSkip(4);
			DBMS_OUTPUT.PUT_LINE ('Creating Table  EXTMETHODDEFTABLE2 ');	
			--EXECUTE IMMEDIATE q'{ALTER TABLE extmethoddeftable RENAME TO extmethoddeftable$1}';
			 
			EXECUTE IMMEDIATE q'{CREATE TABLE EXTMETHODDEFTABLE2 (
			ProcessDefId		INTEGER		NOT NULL ,
			ExtMethodIndex		INTEGER		NOT NULL ,	
			ExtAppName		NVARCHAR2(64)	NOT NULL , 
			ExtAppType		NVARCHAR2(1)	NOT NULL CHECK (ExtAppType in (N'E', N'W', N'S', N'Z')) ,
			ExtMethodName		NVARCHAR2(64)	NOT NULL , 
			SearchMethod		NVARCHAR2(255)	NULL , 
			SearchCriteria		INTEGER 		NULL ,
			ReturnType		SMALLINT	CHECK (ReturnType in (0, 3, 4, 6, 8, 10, 11, 12, 14, 15, 16)) ,
			MappingFile		NVarChar2(1),
			ConfigurationID     INT     NULL,	
			PRIMARY KEY (ProcessDefId , ExtMethodIndex)
			)}';
			  DBMS_OUTPUT.PUT_LINE ('Table  EXTMETHODDEFTABLE2 Created....');	
			  DBMS_OUTPUT.PUT_LINE ('Copying  data from  EXTMETHODDEFTABLE to EXTMETHODDEFTABLE2');	
			  
				BEGIN
					existsFlag:=0;
				
					SELECT 1 INTO existsFlag 
					FROM USER_TAB_COLUMNS
					WHERE Upper(TABLE_NAME) = 'EXTMETHODDEFTABLE'
					AND Upper(COLUMN_NAME) = 'CONFIGURATIONID';
					
					DBMS_OUTPUT.PUT_LINE ('Coloumn  CONFIGURATIONID EXISTS IN EXTMETHODDEFTABLE ');	
					
					 v_insertSql:=q'{INSERT INTO EXTMETHODDEFTABLE2(ProcessDefId,ExtMethodIndex,ExtAppName,ExtAppType,ExtMethodName,SearchMethod,SearchCriteria,ReturnType,MappingFile,ConfigurationID) SELECT ProcessDefId,ExtMethodIndex,ExtAppName,ExtAppType,ExtMethodName,SearchMethod,SearchCriteria,ReturnType,MappingFile,ConfigurationID FROM  EXTMETHODDEFTABLE}';
					
				/*EXCEPTION
				WHEN NO_DATA_FOUND THEN
				
				DBMS_OUTPUT.PUT_LINE ('Coloumn  CONFIGURATIONID DOESNOT EXISTS IN EXTMETHODDEFTABLE ');	
			  
				  v_insertSql:=q'{		
						INSERT INTO EXTMETHODDEFTABLE2
						  ( ProcessDefId,
							extmethodindex,
							ExtAppName,
							ExtAppType,
							ExtMethodName,
							SearchMethod,
							SearchCriteria,
							returntype,
							mappingfile)
							SELECT  ProcessDefId,
							extmethodindex,
							ExtAppName,
							ExtAppType,
							ExtMethodName,
							SearchMethod,
							SearchCriteria,
							returntype,
							mappingfile FROM EXTMETHODDEFTABLE}';
					END ;	*/
							
						
					EXECUTE IMMEDIATE v_insertSql;	
					
					DBMS_OUTPUT.PUT_LINE ('data from  EXTMETHODDEFTABLE to EXTMETHODDEFTABLE2 Copied Rowcount:'||SQL%ROWCOUNT);	
					
					EXECUTE IMMEDIATE Q'{ALTER TABLE EXTMETHODDEFTABLE RENAME TO EXTMETHODDEFTABLE_PATCH6}';
					--DBMS_OUTPUT.PUT_LINE ('data from  EXTMETHODDEFTABLE to EXTMETHODDEFTABLE2 Copied');	
					
					EXECUTE IMMEDIATE Q'{ALTER TABLE EXTMETHODDEFTABLE2 RENAME TO EXTMETHODDEFTABLE}';
					
					EXECUTE IMMEDIATE Q'{DROP TABLE EXTMETHODDEFTABLE_PATCH6 CASCADE CONSTRAINTS}'; 
					DBMS_OUTPUT.PUT_LINE ('Dropping table  EXTMETHODDEFTABLE_PATCH6 ');	

				EXCEPTION
					WHEN OTHERS THEN		
					BEGIN
						SELECT 1 INTO  existsFlag
						FROM USER_TABLES WHERE TABLE_NAME= 'EXTMETHODDEFTABLE2';
						
						DBMS_OUTPUT.PUT_LINE (' DROPPING EXTMETHODDEFTABLE2 In Exception Block ');
						
						EXECUTE IMMEDIATE Q'{DROP TABLE EXTMETHODDEFTABLE2 CASCADE CONSTRAINTS}'; 
						
						DBMS_OUTPUT.PUT_LINE (' DROPPED TABLE  EXTMETHODDEFTABLE2 In Exception Block ');
					EXCEPTION
						WHEN NO_DATA_FOUND THEN
							DBMS_OUTPUT.PUT_LINE (' EXTMETHODDEFTABLE2 Already dropped ');	
					
					END;
					
					ROLLBACK;
				
					RAISE;	
				END ; 
		END;	
	EXCEPTION
		WHEN OTHERS THEN
		v_logStatus := LogUpdateError(4);   
		raise_application_error(-20204,v_scriptName ||' BLOCK 4 FAILED');
	END;
	v_logStatus := LogUpdate(4);
	
	v_logStatus := LogInsert(5,'Recreating table WFTMSSETVARIABLEMAPPING');
	BEGIN
		dropTableIfExist('WFTMSSetVariableMapping2');

		BEGIN
			v_logStatus := LogSkip(5);
			DBMS_OUTPUT.PUT_LINE ('Creating Table  WFTMSSetVariableMapping2 ');	
			--EXECUTE IMMEDIATE q'{ALTER TABLE extmethoddeftable RENAME TO extmethoddeftable$1}';
			 
			EXECUTE IMMEDIATE q'{CREATE TABLE WFTMSSetVariableMapping2(
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
			)}';
			  DBMS_OUTPUT.PUT_LINE ('Table  WFTMSSetVariableMapping2 Created....');	
			  DBMS_OUTPUT.PUT_LINE ('Copying  data from  WFTMSSetVariableMapping to WFTMSSetVariableMapping2');	
			  
			  
				  v_insertSql:=q'{		
						INSERT INTO WFTMSSETVARIABLEMAPPING2(RequestId ,ProcessDefId,ProcessName ,RightFlag ,ToReturn ,Alias ,QueueId ,QueueName ,Param1,Param1Type,Type1,AliasRule)
						  SELECT RequestId ,ProcessDefId,ProcessName ,RightFlag ,ToReturn ,Alias ,QueueId ,QueueName ,Param1,Param1Type,Type1,AliasRule FROM WFTMSSETVARIABLEMAPPING}';
					
							
				
			EXECUTE IMMEDIATE v_insertSql;	
			
			DBMS_OUTPUT.PUT_LINE ('data from  WFTMSSETVARIABLEMAPPING to WFTMSSETVARIABLEMAPPING2 Copied Rowcount:'||SQL%ROWCOUNT);	
			
			EXECUTE IMMEDIATE Q'{ALTER TABLE WFTMSSETVARIABLEMAPPING RENAME TO WFTMSSETVARMAPPING2_PATCH6}';
			--DBMS_OUTPUT.PUT_LINE ('data from  EXTMETHODDEFTABLE to EXTMETHODDEFTABLE2 Copied');	
			
			EXECUTE IMMEDIATE Q'{ALTER TABLE WFTMSSETVARIABLEMAPPING2 RENAME TO WFTMSSETVARIABLEMAPPING}';
			
			EXECUTE IMMEDIATE Q'{DROP TABLE WFTMSSETVARMAPPING2_PATCH6 CASCADE CONSTRAINTS}'; 
			DBMS_OUTPUT.PUT_LINE ('Dropping table  WFTMSSETVARMAPPING2_PATCH6 ');	

		EXCEPTION
			WHEN OTHERS THEN

			
				BEGIN
					SELECT 1 INTO  existsFlag
					FROM USER_TABLES WHERE TABLE_NAME= 'WFTMSSETVARIABLEMAPPING2';
					
					DBMS_OUTPUT.PUT_LINE (' DROPPING WFTMSSETVARIABLEMAPPING2 In Exception Block ');
					
					EXECUTE IMMEDIATE Q'{DROP TABLE WFTMSSETVARIABLEMAPPING2 CASCADE CONSTRAINTS}'; 
					
					DBMS_OUTPUT.PUT_LINE (' DROPPED TABLE  WFTMSSETVARIABLEMAPPING2 In Exception Block ');
				EXCEPTION
					WHEN NO_DATA_FOUND THEN
						DBMS_OUTPUT.PUT_LINE (' EXTMETHODDEFTABLE2 Already dropped ');	
				
				END;
				
				ROLLBACK;
			
				RAISE;	

		END ; 
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(5);   
			raise_application_error(-20205,v_scriptName ||' BLOCK 5 FAILED');
	END;
	v_logStatus := LogUpdate(5);

		

	v_logStatus := LogInsert(6,'Recreating table VARALIASTABLE');
	BEGIN
			dropTableIfExist('VARALIASTABLE2');

		BEGIN
				v_logStatus := LogSkip(6);
				BEGIN
					SELECT 1 INTO existsFlag 
					FROM USER_TAB_COLUMNS
					WHERE TABLE_NAME=UPPER('VARALIASTABLE') 
					AND COLUMN_NAME=UPPER('TYPE1')
					AND	DATA_TYPE=UPPER('NVARCHAR2')
					AND DATA_LENGTH >= 8;
					
					DBMS_OUTPUT.PUT_LINE ('Table VARALIASTABLE2 Already has coloum type1 of datatype NVARCHAR2 >=4');		
						
				EXCEPTION
				WHEN NO_DATA_FOUND THEN

					BEGIN
					
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
			v_logStatus := LogUpdateError(6);   
			raise_application_error(-20206,v_scriptName ||' BLOCK 6 FAILED');
	END;
	v_logStatus := LogUpdate(6);



	v_logStatus := LogInsert(7,'CREATE TRIGGER ALIAS_ID_TRIGGER BEFORE INSERT ON VARALIASTABLE FOR EACH ROW');
	BEGIN
		
		BEGIN
				v_logStatus := LogSkip(7);
				EXECUTE IMMEDIATE 'CREATE OR REPLACE TRIGGER ALIAS_ID_TRIGGER 
				BEFORE INSERT 
				ON VARALIASTABLE 
				FOR EACH ROW 
				BEGIN 
				SELECT AliasID.nextval INTO :new.ID FROM dual; 
				END;';
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(7);   
			raise_application_error(-20207,v_scriptName ||' BLOCK 7 FAILED');
	END;
	v_logStatus := LogUpdate(7);



	v_logStatus := LogInsert(8,'Recreating table ROUTEFOLDERDEFTABLE');
	BEGIN
		dropTableIfExist('ROUTEFOLDERDEFTABLE2');

		BEGIN	
			v_logStatus := LogSkip(8);
			--EXECUTE IMMEDIATE 'Alter Table ROUTEFOLDERDEFTABLE rename to TEMPROUTEFOLDERDEFTABLE';				
			EXECUTE IMMEDIATE 
				'CREATE TABLE ROUTEFOLDERDEFTABLE2 (
					ProcessDefId            INT					NOT NULL Primary Key,
					CabinetName             NVARCHAR2(50) 		NOT NULL,
					RouteFolderId           NVARCHAR2(255)		NOT NULL,
					ScratchFolderId         NVARCHAR2(255)		NOT NULL,
					WorkFlowFolderId        NVARCHAR2(255)		NOT NULL,
					CompletedFolderId       NVARCHAR2(255)		NOT NULL,
					DiscardFolderId         NVARCHAR2(255)		NOT NULL 
				)';
				DBMS_OUTPUT.PUT_LINE ('Table ROUTEFOLDERDEFTABLE Created successfully.....'	);
				
				DBMS_OUTPUT.PUT_LINE ('Attempting to Transfer data from ROUTEFOLDERDEFTABLE2 to ROUTEFOLDERDEFTABLE '	);

				 /* EXECUTE IMMEDIATE 'INSERT INTO ROUTEFOLDERDEFTABLE2 SELECT ProcessDefId, CabinetName, RouteFolderId, ScratchFolderId, WorkFlowFolderId, CompletedFolderId, DiscardFolderId FROM ROUTEFOLDERDEFTABLE';*/
				 
				 EXECUTE IMMEDIATE 'INSERT INTO ROUTEFOLDERDEFTABLE2(ProcessDefId,CabinetName,RouteFolderId,ScratchFolderId ,WorkFlowFolderId ,CompletedFolderId,DiscardFolderId ) SELECT ProcessDefId,CabinetName,RouteFolderId,ScratchFolderId ,WorkFlowFolderId ,CompletedFolderId,DiscardFolderId  FROM ROUTEFOLDERDEFTABLE';
				  
				  DBMS_OUTPUT.PUT_LINE ('transferred.. Rowcount:'||SQL%ROWCOUNT	);
				  
				  EXECUTE IMMEDIATE 'Alter Table ROUTEFOLDERDEFTABLE rename to ROUTEFOLDERDEFTABLE_PATCH6';
				  EXECUTE IMMEDIATE 'Alter Table ROUTEFOLDERDEFTABLE2 rename to ROUTEFOLDERDEFTABLE';
				  EXECUTE IMMEDIATE 'DROP TABLE ROUTEFOLDERDEFTABLE_PATCH6';

				  EXECUTE IMMEDIATE 'INSERT INTO WFCabVersionTable(cabVersion, cabVersionId, creationDate, lastModified, Remarks, Status) VALUES (N''9.0_SharepointIntegration'', cabVersionId.nextVal, SYSDATE, SYSDATE, N''BPEL Compliant OmniFlow'', N''Y'')';
				  
				  
				  EXCEPTION
						WHEN OTHERS THEN
							BEGIN
								SELECT 1 INTO  existsFlag
								FROM USER_TABLES WHERE TABLE_NAME= 'ROUTEFOLDERDEFTABLE2';
								
								DBMS_OUTPUT.PUT_LINE (' DROPPING ROUTEFOLDERDEFTABLE2 In Exception Block ');
								
								EXECUTE IMMEDIATE Q'{DROP TABLE ROUTEFOLDERDEFTABLE2 CASCADE CONSTRAINTS}'; 
								
								DBMS_OUTPUT.PUT_LINE (' DROPPED TABLE  ROUTEFOLDERDEFTABLE2 In Exception Block ');
							EXCEPTION
								WHEN NO_DATA_FOUND THEN
									DBMS_OUTPUT.PUT_LINE (' ROUTEFOLDERDEFTABLE2 Already dropped ');	
							
							END;
							
							ROLLBACK;
							
							RAISE;	
								
		END;	
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(8);   
			raise_application_error(-20208,v_scriptName ||' BLOCK 8 FAILED');
	END;
	v_logStatus := LogUpdate(8);

		

	v_logStatus := LogInsert(9,'Recreating Table WFSYSTEMSERVICESTABLE');
	BEGIN
			dropTableIfExist('WFSystemServicesTable2');

		BEGIN		
			v_logStatus := LogSkip(9);
				--EXECUTE IMMEDIATE 'Alter Table WFSystemServicesTable rename to TEMPWFSystemServicesTable';				
				EXECUTE IMMEDIATE 
				'CREATE TABLE WFSystemServicesTable2 (
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
					RegInfo   			CLOB				NULL
				)';
				  DBMS_OUTPUT.PUT_LINE ('Table WFSystemServicesTable Created successfully.....'	);
				  DBMS_OUTPUT.PUT_LINE ('Transfer started...');
			
				  /*EXECUTE IMMEDIATE 'INSERT INTO WFSystemServicesTable2 SELECT ServiceId, PSID, ServiceName, ServiceType, ProcessDefId, EnableLog, MonitorStatus, SleepTime, DateFormat, UserName, Password, RegInfo FROM WFSystemServicesTable';*/
				  
				  EXECUTE IMMEDIATE 'INSERT INTO WFSystemServicesTable2(ServiceId  ,PSID ,ServiceName ,ServiceType ,ProcessDefId,EnableLog,MonitorStatus,SleepTime,DateFormat ,UserName,Password,RegInfo  ) SELECT ServiceId  ,PSID ,ServiceName ,ServiceType ,ProcessDefId,EnableLog,MonitorStatus,SleepTime,DateFormat ,UserName,Password,RegInfo   FROM WFSystemServicesTable';
				  
				  DBMS_OUTPUT.PUT_LINE ('Transfer completed SQL rowcount'||SQL%ROWCOUNT);
				  
				  EXECUTE IMMEDIATE 'ALTER TABLE WFSYSTEMSERVICESTABLE RENAME TO WFSYSTEMSERVICESTABLE_PATCH6';
				  
				  EXECUTE IMMEDIATE 'ALTER TABLE WFSYSTEMSERVICESTABLE2 RENAME TO WFSYSTEMSERVICESTABLE';
				  
				  EXECUTE IMMEDIATE 'DROP TABLE WFSYSTEMSERVICESTABLE_PATCH6';
				  
				  EXECUTE IMMEDIATE 'INSERT INTO WFCabVersionTable(cabVersion, cabVersionId, creationDate, lastModified, Remarks, Status) VALUES (N''9.0_WFSystemServicesTable'', cabVersionId.nextVal, SYSDATE, SYSDATE, N''BPEL Compliant OmniFlow'', N''Y'')';
				  
			EXCEPTION
						WHEN OTHERS THEN
							BEGIN
								SELECT 1 INTO  existsFlag
								FROM USER_TABLES WHERE TABLE_NAME= 'WFSYSTEMSERVICESTABLE2';
								
								DBMS_OUTPUT.PUT_LINE (' DROPPING WFSYSTEMSERVICESTABLE2 In Exception Block ');
								
								EXECUTE IMMEDIATE Q'{DROP TABLE WFSYSTEMSERVICESTABLE2 CASCADE CONSTRAINTS}'; 
								
								DBMS_OUTPUT.PUT_LINE (' DROPPED TABLE  WFSYSTEMSERVICESTABLE2 In Exception Block ');
							EXCEPTION
								WHEN NO_DATA_FOUND THEN
									DBMS_OUTPUT.PUT_LINE (' WFSYSTEMSERVICESTABLE2 Already dropped ');	
							
							END;
							
							ROLLBACK;
							
							RAISE;	
								
		END;	


	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(9);   
			raise_application_error(-20209,v_scriptName ||' BLOCK 9 FAILED');
	END;
	v_logStatus := LogUpdate(9);
			

	v_logStatus := LogInsert(10,'Recreating Table PrintFaxEmailTable');
	BEGIN
		dropTableIfExist('PrintFaxEmailTable2');
		
		BEGIN
			v_logStatus := LogSkip(10);
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('PrintFaxEmailTable') 
			AND 
			COLUMN_NAME=UPPER('Message')
			AND
			DATA_TYPE=UPPER('NCLOB');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				
				BEGIN
				EXECUTE IMMEDIATE 'CREATE TABLE PrintFaxEmailTable2 ( 
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
									CoverSheetBuffer        BLOB			NULL,
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
									Message                 NCLOB			 NULL,
									Subject                 NVARCHAR2(255)  NULL,
									BCCMAILID 				NVARCHAR2(255),
									BCCMAILIDTYPE 			NVARCHAR2(255) Default ''C'',
									EXTBCCMAILID 			INT 			Default 0,
									VARIABLEIDBCC 			INT 			Default 0,
									VARFIELDIDBCC 			INT 			Default 0,
									MailPriority 			NVARCHAR2(255) Default 1,
									MailPriorityType 		NVARCHAR2(255) Default ''C'',
									ExtObjIdMailPriority 	INT 			Default 0,
									VariableIdMailPriority  INT 			Default 0,
									VarFieldIdMailPriority  INT 			Default 0
									
								)'; 
								
								
						DBMS_OUTPUT.PUT_LINE ('Table PrintFaxEmailTable2 Successfully Created');
				
						EXECUTE IMMEDIATE 'INSERT INTO PrintFaxEmailTable2(ProcessDefId  ,PFEInterfaceId,InstrumentData,FitToPage ,Annotations ,FaxNo ,FaxNoType ,ExtFaxNoId ,VariableIdFax,VarFieldIdFax,CoverSheet,CoverSheetBuffer ,ToUser ,FromUser ,ToMailId  ,ToMailIdType  ,ExtToMailId,VariableIdTo,VarFieldIdTo,CCMailId ,CCMailIdType  ,ExtCCMailId,VariableIdCc,VarFieldIdCc,SenderMailId,SenderMailIdType ,ExtSenderMailId,VariableIdFrom,VarFieldIdFrom,Message ,Subject ,BCCMAILID 	,BCCMAILIDTYPE ,EXTBCCMAILID,VARIABLEIDBCC,VARFIELDIDBCC,MailPriority,MailPriorityType 	,ExtObjIdMailPriority ,VariableIdMailPriority ,VarFieldIdMailPriority)  SELECT ProcessDefId  ,PFEInterfaceId,InstrumentData,FitToPage ,Annotations ,FaxNo ,FaxNoType ,ExtFaxNoId ,VariableIdFax,VarFieldIdFax,CoverSheet,CoverSheetBuffer ,ToUser ,FromUser ,ToMailId  ,ToMailIdType  ,ExtToMailId,VariableIdTo,VarFieldIdTo,CCMailId ,CCMailIdType  ,ExtCCMailId,VariableIdCc,VarFieldIdCc,SenderMailId,SenderMailIdType ,ExtSenderMailId,VariableIdFrom,VarFieldIdFrom,Message ,Subject ,BCCMAILID 	,BCCMAILIDTYPE ,EXTBCCMAILID,VARIABLEIDBCC,VARFIELDIDBCC,MailPriority,MailPriorityType 	,ExtObjIdMailPriority ,VariableIdMailPriority ,VarFieldIdMailPriority FROM PrintFaxEmailTable'; 
						DBMS_OUTPUT.PUT_LINE('Data transfeered :'||SQL%ROWCOUNT);
						
						EXECUTE IMMEDIATE 'RENAME PrintFaxEmailTable TO PrintFaxEmailTable_Patch6'; 
						EXECUTE IMMEDIATE 'RENAME PrintFaxEmailTable2 TO PrintFaxEmailTable';
						EXECUTE IMMEDIATE 'DROP TABLE PrintFaxEmailTable_Patch6';
			 
				COMMIT; 
				
				EXCEPTION
						WHEN OTHERS THEN
							BEGIN
								SELECT 1 INTO  existsFlag
								FROM USER_TABLES WHERE TABLE_NAME= 'PRINTFAXEMAILTABLE2';
								
								DBMS_OUTPUT.PUT_LINE (' DROPPING PRINTFAXEMAILTABLE2 In Exception Block ');
								
								EXECUTE IMMEDIATE Q'{DROP TABLE PRINTFAXEMAILTABLE2 CASCADE CONSTRAINTS}'; 
								
								DBMS_OUTPUT.PUT_LINE (' DROPPED TABLE  PRINTFAXEMAILTABLE2 In Exception Block ');
							EXCEPTION
								WHEN NO_DATA_FOUND THEN
									DBMS_OUTPUT.PUT_LINE (' PRINTFAXEMAILTABLE2 Already dropped ');	
							
							END;
							
							ROLLBACK;
							
							RAISE;	
							
				END;			
								
				
		END;
		
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(10);   
			raise_application_error(-20210,v_scriptName ||' BLOCK 10 FAILED');
	END;
	v_logStatus := LogUpdate(10);

	
	v_logStatus := LogInsert(11,'MODIFYING COLUMN NEWVALUE TO NVARCHAR2 (2000) IN WFADMINLOGTABLE');
	BEGIN
		BEGIN
			
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('wfadminlogtable') 
			AND 
			COLUMN_NAME=UPPER('NEWVALUE')
			AND
			DATA_TYPE=UPPER('NVARCHAR2')
			AND DATA_LENGTH >= 4000;
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
			v_logStatus := LogSkip(11);
			--No Existing Coloumn data type check as it is a small table
			DBMS_OUTPUT.PUT_LINE ('Table wfadminlogtable column being modified  ...');	
			EXECUTE IMMEDIATE 'ALTER TABLE WFADMINLOGTABLE MODIFY ( NEWVALUE NVARCHAR2 (2000) )';
		END;
		
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(11);   
			raise_application_error(-20211,v_scriptName ||' BLOCK 11 FAILED');
	END;
	v_logStatus := LogUpdate(11);
	
		--WFCURRENTROUTELOGTABLE

	v_logStatus := LogInsert(12,'MODIFYING COLUMN NEWVALUE TO NVARCHAR2 (2000) IN WFCURRENTROUTELOGTABLE');
	BEGIN
		
		v_tableexistence:=0;
		
	   select COUNT(*) INTO v_tableexistence  from user_tables where table_name = 'WFCURRENTROUTELOGTABLE';
	   
	   IF v_tableexistence >0
	   THEN
			v_logStatus := LogSkip(12);
		  v_ColData:=1;
		  SELECT COUNT(*) INTO v_ColData  FROM USER_TAB_COLUMNS WHERE TABLE_NAME='WFCURRENTROUTELOGTABLE' AND COLUMN_NAME='NEWVALUE'  AND DATA_TYPE='NVARCHAR2' AND DATA_LENGTH < 4000;
	  
		  IF (v_ColData=0)
		  THEN
		  DBMS_OUTPUT.PUT_LINE ('Table WFCURRENTROUTELOGTABLE column NEWVALUE Dataype not Appropriate so Modifying...');
		  EXECUTE IMMEDIATE 'ALTER TABLE WFCURRENTROUTELOGTABLE MODIFY ( NEWVALUE NVARCHAR2 (2000) )';
	  
		  ELSE
		  DBMS_OUTPUT.PUT_LINE ('Table WFCURRENTROUTELOGTABLE column NEWVALUE Dataype Already  Appropriate');
		  END IF;
	   END IF;

	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(12);   
			raise_application_error(-20212,v_scriptName ||' BLOCK 12 FAILED');
	END;
	v_logStatus := LogUpdate(12);
		

		

	v_logStatus := LogInsert(13,'MODIFYING COLUMN status TO NVARCHAR2 (50) IN WFFailedMessageTable,MODIFYING COLUMN FRAGMENTNAME TO NVARCHAR2 (50),ISENCRYPTED TO NVARCHAR2(1),STRUCTURENAME TO NVARCHAR2(128) IN WFFORMFRAGMENTTABLE');
	BEGIN
		BEGIN
			v_logStatus := LogSkip(13);
				EXECUTE IMMEDIATE 'ALTER TABLE WFFailedMessageTable MODIFY (status NVARCHAR2(50))';
				DBMS_OUTPUT.PUT_LINE('Table WFFailedMessageTable altered with Column status size increased to 50');

				
				IF (checkIFColExist('WFFORMFRAGMENTTABLE','FRAGMENTNAME'))
				THEN
				EXECUTE IMMEDIATE 'ALTER TABLE WFFORMFRAGMENTTABLE modify FRAGMENTNAME	NVARCHAR2(50)';
				DBMS_OUTPUT.PUT_LINE ('Table WFFORMFRAGMENTTABLE altered successfully');
				END IF;
				
				
				IF (checkIFColExist('WFFORMFRAGMENTTABLE','ISENCRYPTED'))
				THEN
				EXECUTE IMMEDIATE 'ALTER TABLE WFFORMFRAGMENTTABLE modify ISENCRYPTED NVARCHAR2(1)';
				DBMS_OUTPUT.PUT_LINE ('Table WFFORMFRAGMENTTABLE altered successfully');
				END IF;
				
				
				IF (checkIFColExist('WFFORMFRAGMENTTABLE','STRUCTURENAME'))
				THEN
				EXECUTE IMMEDIATE 'ALTER TABLE WFFORMFRAGMENTTABLE modify STRUCTURENAME	NVARCHAR2(128)';
				DBMS_OUTPUT.PUT_LINE ('Table WFFORMFRAGMENTTABLE altered successfully');
				END IF;
					
		END;

	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(13);   
			raise_application_error(-20213,v_scriptName ||' BLOCK 13 FAILED');
	END;
	v_logStatus := LogUpdate(13);

	v_logStatus := LogInsert(14,'MODIFYING COLUMN NEWVALUE TO NVARCHAR2 (2000) IN WFHISTORYROUTELOGTABLE,MODIFYING COLUMNS ATTACHMENTISINDEX,ATTACHMENTNAMES TO NVARCHAR2 (1000) IN WFMAILQUEUEHISTORYTABLE');
	BEGIN
			
		BEGIN
			v_tableexistence:=0;
			v_logStatus := LogSkip(14);
			  select COUNT(*) INTO v_tableexistence  from user_tables where table_name = 'WFHISTORYROUTELOGTABLE';
			   
			  IF v_tableexistence >0
			  THEN
			   
				  v_ColData:=1;
					SELECT COUNT(*) INTO v_ColData  FROM USER_TAB_COLUMNS WHERE TABLE_NAME='WFHISTORYROUTELOGTABLE' AND COLUMN_NAME='NEWVALUE'  AND DATA_TYPE='NVARCHAR2' AND DATA_LENGTH < 4000;
					
					IF (v_ColData=0)
					THEN
					DBMS_OUTPUT.PUT_LINE ('Table WFHISTORYROUTELOGTABLE column NEWVALUE Dataype not Appropriate so Modifying...');
					EXECUTE IMMEDIATE 'ALTER TABLE WFHISTORYROUTELOGTABLE MODIFY ( NEWVALUE NVARCHAR2 (2000) )';

					ELSE
					DBMS_OUTPUT.PUT_LINE ('Table WFHISTORYROUTELOGTABLE column NEWVALUE Dataype Already  Appropriate');
					END IF;
			  END IF;
				
			v_ColData:=1;
			SELECT COUNT(*) INTO v_ColData  FROM USER_TAB_COLUMNS WHERE TABLE_NAME='WFMAILQUEUEHISTORYTABLE' AND COLUMN_NAME='ATTACHMENTISINDEX'  AND DATA_TYPE='NVARCHAR2' AND DATA_LENGTH >=2000;
			
			IF (v_ColData=0)
			THEN
				DBMS_OUTPUT.PUT_LINE ('Table WFMAILQUEUEHISTORYTABLE column ATTACHMENTISINDEX Dataype Being Modified');
				EXECUTE IMMEDIATE 'ALTER TABLE WFMAILQUEUEHISTORYTABLE MODIFY ( ATTACHMENTISINDEX NVARCHAR2 (1000) )';
			ELSE
				DBMS_OUTPUT.PUT_LINE ('Table WFMAILQUEUEHISTORYTABLE column ATTACHMENTISINDEX Dataype Already  Appropriate');
			END IF;
			
			v_ColData:=1;
			
			SELECT COUNT(*) INTO v_ColData  FROM USER_TAB_COLUMNS WHERE TABLE_NAME='WFMAILQUEUEHISTORYTABLE' AND COLUMN_NAME='ATTACHMENTNAMES'  AND DATA_TYPE='NVARCHAR2' AND DATA_LENGTH >=2000;
			
			IF (v_ColData=0)
			THEN
				DBMS_OUTPUT.PUT_LINE ('Table WFMAILQUEUEHISTORYTABLE column ATTACHMENTNAMES Dataype Being Modified');
				EXECUTE IMMEDIATE 'ALTER TABLE WFMAILQUEUEHISTORYTABLE MODIFY ( ATTACHMENTNAMES NVARCHAR2 (1000) )';
			ELSE
				DBMS_OUTPUT.PUT_LINE ('Table WFMAILQUEUEHISTORYTABLE column ATTACHMENTNAMES Dataype Already  Appropriate');
			END IF;	

			
			
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(14);   
			raise_application_error(-20214,v_scriptName ||' BLOCK 14 FAILED');
	END;
	v_logStatus := LogUpdate(14);
		

	v_logStatus := LogInsert(15,'MODIFYING COLUMN FieldSeperator TO NVARCHAR2 (2000) IN WFExportTable');
	BEGIN
		v_logStatus := LogSkip(15);
		DBMS_OUTPUT.PUT_LINE('WFExportTable FieldSeperator is being Modified...');
		EXECUTE IMMEDIATE 'ALTER TABLE WFExportTable MODIFY FieldSeperator NVARCHAR2(5)';
		
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(15);   
			raise_application_error(-20215,v_scriptName ||' BLOCK 15 FAILED');
	END;
	v_logStatus := LogUpdate(15);

		

	v_logStatus := LogInsert(16,'MODIFYING COLUMN NEWVALUE TO NVARCHAR2 (2000) IN WFADMINLOGTABLE');
	BEGIN
		v_logStatus := LogSkip(16);
		DBMS_OUTPUT.PUT_LINE('WFADMINLOGTABLE  newValue is being Modified...');
		EXECUTE IMMEDIATE 'ALTER TABLE WFADMINLOGTABLE MODIFY (newValue NVARCHAR2(2000))';
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(16);   
			raise_application_error(-20216,v_scriptName ||' BLOCK 16 FAILED');
	END;
	v_logStatus := LogUpdate(16);
		

	v_logStatus := LogInsert(17,'Updating Primary Key (ProcessDefId, ConfigurationID) in WFSAPConnectTable');
	BEGIN
		
		BEGIN
		v_logStatus := LogSkip(17);
			SELECT CONSTRAINT_NAME INTO v_SAPconstraintName
			FROM USER_CONSTRAINTS 
			WHERE TABLE_NAME = UPPER('WFSAPConnectTable') AND constraint_type = 'P';
		 
			EXECUTE IMMEDIATE 'Alter Table WFSAPConnectTable Drop Constraint ' || TO_CHAR(v_SAPconstraintName);
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
			v_SAPconstraintName := 'pk_WFSAPConnect';
		END;
		EXECUTE IMMEDIATE 'Alter Table WFSAPConnectTable Add Constraint ' || TO_CHAR(v_SAPconstraintName) || ' Primary Key (ProcessDefId, ConfigurationID)';
		DBMS_OUTPUT.PUT_LINE('Primary Key Updated for WFSAPConnectTable');
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(17);   
			raise_application_error(-20217,v_scriptName ||' BLOCK 17 FAILED');
	END;
	v_logStatus := LogUpdate(17);


	v_logStatus := LogInsert(18,'MODIFYING COLUMN AttachmentISIndex TO NVARCHAR2 (1000) IN WFMAILQUEUETABLE');
	BEGIN
		
		----modified
		BEGIN	 
			v_logStatus := LogSkip(18);
			BEGIN
					SELECT 1 INTO existsFlag 
					FROM USER_TAB_COLUMNS
					WHERE TABLE_NAME='WFMAILQUEUETABLE'
					AND 
					COLUMN_NAME=UPPER('attachmentISIndex')
					and
					DATA_TYPE='NVARCHAR2'
					AND 
					DATA_LENGTH=2000;
					existsFlag:=1;
			EXCEPTION
					WHEN NO_DATA_FOUND THEN
						 existsFlag := 0;
			END;
			IF existsFlag = 0 THEN
					EXECUTE IMMEDIATE 'alter table WFMAILQUEUETABLE modify attachmentISIndex NVARCHAR2(1000)  ';
					DBMS_OUTPUT.PUT_LINE('Table WFMAILQUEUETABLE altered column attachmentISIndex with new size');
			END IF;
		END;

	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(18);   
			raise_application_error(-20218,v_scriptName ||' BLOCK 18 FAILED');
	END;
	v_logStatus := LogUpdate(18);
		
		
	v_logStatus := LogInsert(19,'MODIFYING COLUMN attachmentNames TO NVARCHAR2 (1000) IN WFMAILQUEUETABLE');
	BEGIN
		----modified
		BEGIN  
			v_logStatus := LogSkip(19);
				BEGIN
					SELECT 1 INTO existsFlag 
					FROM USER_TAB_COLUMNS
					WHERE TABLE_NAME='WFMAILQUEUETABLE'
					AND 
					COLUMN_NAME=UPPER('attachmentNames')
					and
					DATA_TYPE='NVARCHAR2'
					AND 
					DATA_LENGTH=2000;
					existsFlag:=1;
				EXCEPTION
					WHEN NO_DATA_FOUND THEN
						 existsFlag := 0;
					 END;
				IF existsFlag = 0 THEN
					EXECUTE IMMEDIATE 'alter table WFMAILQUEUETABLE modify   attachmentNames NVARCHAR2(1000)  ';
					DBMS_OUTPUT.PUT_LINE('Table WFMAILQUEUETABLE altered column attachmentNames with new size');
				END IF;
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(19);   
			raise_application_error(-20219,v_scriptName ||' BLOCK 19 FAILED');
	END;
	v_logStatus := LogUpdate(19);
			
	v_logStatus := LogInsert(20,'MODIFYING COLUMN EXCEPTIONCOMMENTS TO NVARCHAR2 (512) IN EXCEPTIONTABLE');
	BEGIN
			
		BEGIN
			v_logStatus := LogSkip(20);
			existsFlag:=0;
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME='EXCEPTIONTABLE'
			AND COLUMN_NAME=UPPER('EXCEPTIONCOMMENTS')
			AND	DATA_TYPE='NVARCHAR2' 
			AND DATA_LENGTH>=1024;
			EXCEPTION
			WHEN NO_DATA_FOUND THEN
				EXECUTE IMMEDIATE 'ALTER TABLE EXCEPTIONTABLE MODIFY (EXCEPTIONCOMMENTS NVARCHAR2(512))';
				DBMS_OUTPUT.PUT_LINE('Table EXCEPTIONTABLE is being altered ');
		END;
		
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(20);   
			raise_application_error(-20220,v_scriptName ||' BLOCK 20 FAILED');
	END;
	v_logStatus := LogUpdate(20);


	v_logStatus := LogInsert(21,'MODIFYING COLUMN EXCEPTIONCOMMENTS TO NVARCHAR2 (512) IN EXCEPTIONHISTORYTABLE');
	BEGIN
		
		BEGIN
			
			existsFlag:=0;
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME='EXCEPTIONHISTORYTABLE'
			AND COLUMN_NAME=UPPER('EXCEPTIONCOMMENTS')
			AND	DATA_TYPE='NVARCHAR2' 
			AND DATA_LENGTH>=1024;
			EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_logStatus := LogSkip(21);
				EXECUTE IMMEDIATE 'ALTER TABLE EXCEPTIONHISTORYTABLE MODIFY (EXCEPTIONCOMMENTS NVARCHAR2(512))';
				DBMS_OUTPUT.PUT_LINE('Table EXCEPTIONHISTORYTABLE is being altered ');		
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(21);   
			raise_application_error(-20221,v_scriptName ||' BLOCK 21 FAILED');
	END;
	v_logStatus := LogUpdate(21);


	v_logStatus := LogInsert(22,'MODIFYING COLUMN ARGLIST TO NVARCHAR2 (2000) IN TEMPLATEDEFINITIONTABLE');
	BEGIN
			
		BEGIN
			existsFlag:=0;
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME='TEMPLATEDEFINITIONTABLE'
			AND COLUMN_NAME=UPPER('ARGLIST')
			AND	DATA_TYPE='NVARCHAR2' 
			AND DATA_LENGTH>=4000;
			EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_logStatus := LogSkip(22);
				EXECUTE IMMEDIATE 'ALTER TABLE TEMPLATEDEFINITIONTABLE MODIFY (ARGLIST NVARCHAR2(2000))';
					DBMS_OUTPUT.PUT_LINE('Table TEMPLATEDEFINITIONTABLE is being altered ');
		END;
		
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(22);   
			raise_application_error(-20222,v_scriptName ||' BLOCK 22 FAILED');
	END;
	v_logStatus := LogUpdate(22);
		


	v_logStatus := LogInsert(23,'MODIFYING COLUMN NEWVALUE TO LockedByName (200) IN WORKWITHPSTABLE');
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
			v_logStatus := LogSkip(23);
			BEGIN
			
					IF (checkIFColExist('WORKWITHPSTABLE','LOCKEDBYNAME'))
					THEN
						EXECUTE IMMEDIATE 'ALTER TABLE WORKWITHPSTABLE MODIFY (LOCKEDBYNAME NVARCHAR2(200))';
						DBMS_OUTPUT.PUT_LINE('Table WORKWITHPSTABLE column LOCKEDBYNAME modified');
					END IF;
									
			END;
		END IF;		
		
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(23);   
			raise_application_error(-20223,v_scriptName ||' BLOCK 23 FAILED');
	END;
	v_logStatus := LogUpdate(23);


	v_logStatus := LogInsert(24,'MODIFYING COLUMN AliasRule TO NVARCHAR2 (2000) IN WFTMSSetVariableMapping');
	BEGIN
		v_logStatus := LogSkip(24);
		DBMS_OUTPUT.PUT_LINE( 'Table WFTMSSetVariableMapping altered Column AliasRule');
		EXECUTE IMMEDIATE 'ALTER TABLE WFTMSSetVariableMapping MODIFY (AliasRule NVARCHAR2(2000))';
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(24);   
			raise_application_error(-20224,v_scriptName ||' BLOCK 24 FAILED');
	END;
	v_logStatus := LogUpdate(24);
	
	v_logStatus := LogInsert(25,'MODIFYING COLUMN LOCKSTATUS TO NVARCHAR2 (1) IN GTEMPWORKLISTTABLE');
	BEGIN
						
		BEGIN 
		SELECT 1 INTO existsFlag 
			FROM user_tab_columns  
			WHERE TABLE_NAME = 'GTEMPWORKLISTTABLE'
			AND column_name = 'LOCKSTATUS'
			AND NULLABLE = 'Y';
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
				existsFlag := 0;
				dbms_output.put_line ('GTEMPWORKLISTTABLE does not exists');
		END;
		IF existsFlag = 0
		THEN
			v_logStatus := LogSkip(25);
			BEGIN
			
					IF (checkIFColExist('GTEMPWORKLISTTABLE','LOCKSTATUS'))
					THEN
						EXECUTE IMMEDIATE 'ALTER TABLE GTEMPWORKLISTTABLE MODIFY  LOCKSTATUS NVARCHAR2(1) NULL';
						DBMS_OUTPUT.PUT_LINE('Table GTEMPWORKLISTTABLE column LOCKSTATUS modified');
					END IF;
									
			END;
		END IF;		
		
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(25);   
			raise_application_error(-20225,v_scriptName ||' BLOCK 25 FAILED');
	END;
	v_logStatus := LogUpdate(25);

		
	v_logStatus := LogInsert(26,'MODIFYING COLUMN MAILTO,MAILCC TO NVARCHAR2 (2000) IN WFMAILQUEUETABLE');
	BEGIN
						
		BEGIN 
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME='WFMAILQUEUETABLE'
			AND 
			COLUMN_NAME='MAILTO' AND DATA_LENGTH>=4000;
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
				existsFlag := 0;
				dbms_output.put_line ('WFMAILQUEUETABLE does not exists');
		END;
		IF existsFlag = 1
		THEN
			v_logStatus := LogSkip(26);
			BEGIN
				EXECUTE IMMEDIATE 'alter table WFMAILQUEUETABLE modify MAILTO NVARCHAR2(2000)';
				DBMS_OUTPUT.PUT_LINE('Table WFMAILQUEUETABLE altered columns MAILTO with new size 2000');
			END;
		END IF;	
		
		BEGIN 
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME='WFMAILQUEUETABLE'
			AND 
			COLUMN_NAME='MAILCC' AND DATA_LENGTH>=4000;
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
				existsFlag := 0;
				dbms_output.put_line ('WFMAILQUEUETABLE does not exists');
		END;
		IF existsFlag = 1
		THEN
			v_logStatus := LogSkip(26);
			BEGIN
				EXECUTE IMMEDIATE 'alter table WFMAILQUEUETABLE modify MAILCC NVARCHAR2(2000)';
				DBMS_OUTPUT.PUT_LINE('Table WFMAILQUEUETABLE altered columns MAILCC with new size 2000');
			END;
		END IF;		
		
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(26);   
			raise_application_error(-20226,v_scriptName ||' BLOCK 26 FAILED');
	END;
	v_logStatus := LogUpdate(26);

	v_logStatus := LogInsert(27,'Adding New Column CalendarName in QueueHistoryTable');
	BEGIN
	/*HotFix_8.0_026- workitem specific calendar*/
		BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('QueueHistoryTable') 
			AND 
			COLUMN_NAME=UPPER('CalendarName');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_logStatus := LogSkip(27);
				EXECUTE IMMEDIATE 'ALTER TABLE QueueHistoryTable Add ( CalendarName NVARCHAR2(255) )';
				DBMS_OUTPUT.PUT_LINE('Table QueueHistoryTable altered with a new Column CalendarName');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(27);   
			raise_application_error(-20227,v_scriptName ||' BLOCK 27 FAILED');
	END;
	v_logStatus := LogUpdate(27);

	v_logStatus := LogInsert(28,'Adding New Column EXPORTSTATUS in QUEUEHISTORYTABLE');
	BEGIN
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
				v_logStatus := LogSkip(28);
				EXECUTE IMMEDIATE 'ALTER TABLE "QUEUEHISTORYTABLE" ADD "EXPORTSTATUS" NVARCHAR2(1) DEFAULT (N''N'')'; 
			END IF;
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(28);   
			raise_application_error(-20228,v_scriptName ||' BLOCK 28 FAILED');
	END;
	v_logStatus := LogUpdate(28);
		
		

	v_logStatus := LogInsert(29,'Adding New Column ALTERNATEMESSAGE in WFMAILQUEUEHISTORYTABLE');
	BEGIN
			
		BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME='WFMAILQUEUEHISTORYTABLE'
			AND 
			COLUMN_NAME='ALTERNATEMESSAGE';
		EXCEPTION
				WHEN NO_DATA_FOUND THEN
				v_logStatus := LogSkip(29);
				EXECUTE IMMEDIATE 'ALTER TABLE WFMAILQUEUEHISTORYTABLE Add alternateMessage CLOB';
				DBMS_OUTPUT.PUT_LINE('Table WFMAILQUEUEHISTORYTABLE altered with new Column alternateMessage');
		
		END;
		
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(29);   
			raise_application_error(-20229,v_scriptName ||' BLOCK 29 FAILED');
	END;
	v_logStatus := LogUpdate(29);
	
	v_logStatus := LogInsert(30,'Adding New Column mailBCC in WFMAILQUEUEHISTORYTABLE');
	BEGIN
		existsFlag := 0; 
		BEGIN
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME=UPPER('WFMAILQUEUEHISTORYTABLE') 
			AND COLUMN_NAME=UPPER('mailBCC');
			--EXECUTE IMMEDIATE 'ALTER TABLE WFMAILQUEUEHISTORYTABLE MODIFY mailBCC NVARCHAR2(512)';
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_logStatus := LogSkip(30);
				EXECUTE IMMEDIATE 'ALTER TABLE WFMAILQUEUEHISTORYTABLE Add mailBCC NVARCHAR2(512)';
				DBMS_OUTPUT.PUT_LINE('Table WFMAILQUEUEHISTORYTABLE altered with new Column mailBCC');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(30);   
			raise_application_error(-20230,v_scriptName ||' BLOCK 30 FAILED');
	END;
	v_logStatus := LogUpdate(30);
		
		
	v_logStatus := LogInsert(31,'Modifying column MAILTO,MAILCC in WFMAILQUEUEHISTORYTABLE');
	BEGIN
		
		BEGIN
				v_logStatus := LogSkip(31);
				IF (checkIFColExist('WFMAILQUEUEHISTORYTABLE','MAILTO'))
				THEN
					EXECUTE IMMEDIATE 'ALTER TABLE WFMAILQUEUEHISTORYTABLE MODIFY (MAILTO NVARCHAR2(2000))';
					DBMS_OUTPUT.PUT_LINE('Table WFMAILQUEUEHISTORYTABLE column MAILTO modified');
				END IF;
				
				IF (checkIFColExist('WFMAILQUEUEHISTORYTABLE','MAILCC'))
				THEN
					EXECUTE IMMEDIATE 'ALTER TABLE WFMAILQUEUEHISTORYTABLE MODIFY (MAILCC NVARCHAR2(2000))';
					DBMS_OUTPUT.PUT_LINE('Table WFMAILQUEUEHISTORYTABLE column MAILCC modified');				
				END IF;
		END;
		
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(31);   
			raise_application_error(-20231,v_scriptName ||' BLOCK 31 FAILED');
	END;
	v_logStatus := LogUpdate(31);
		

	v_logStatus := LogInsert(32,'Inserting value in WFCabVersionTable for END of UpgradeDataTypesandChecks.sql');
	BEGIN
			v_logStatus := LogSkip(32);
			SELECT  cabversionid.nextval INTO v_nextseq2  FROM DUAL;
			INSERT INTO WFCabVersionTable(cabVersion, cabVersionId, creationDate, lastModified, Remarks, Status) VALUES ('9.0' ,v_nextseq2 , sysdate,sysdate , 'END of UpgradeDataTypesandChecks.sql for SU6','Y');
			COMMIT;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(32);   
			raise_application_error(-20232,v_scriptName ||' BLOCK 32 FAILED');
	END;
	v_logStatus := LogUpdate(32);
	
	
	
END;

~

call UpgradeDataTypesandChecks()

~

DROP PROCEDURE UpgradeDataTypesandChecks

~

DROP PROCEDURE dropTableIfExist

~

DROP PROCEDURE  checkColoumnCheck

~