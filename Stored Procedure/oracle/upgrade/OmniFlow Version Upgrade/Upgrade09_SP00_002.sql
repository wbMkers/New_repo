/*
Change DATE		Name				Description
--------------------------------------------------------------
26/05/2017		Sanal Grover		Bug 62518 - Step by Step Debugs in Version Upgrade.
*/
CREATE OR REPLACE PROCEDURE Upgrade1(DBInput NVARCHAR2, DBFound OUT INTEGER) AS 
BEGIN
	BEGIN
		EXECUTE IMMEDIATE 'SELECT 0 FROM WFCabVersionTable WHERE UPPER(CabVersion) = ''' || TO_CHAR(UPPER(DBInput)) || ''' AND ROWNUM < 2 ' INTO DBFound;
	EXCEPTION WHEN NO_DATA_FOUND THEN
		DBFound := 1; /* Not Found */
	END; 
END;

~

CREATE OR REPLACE PROCEDURE Upgrade_CheckColumnExistence(DBTableName NVARCHAR2, DBColumnName NVARCHAR2, DBFound OUT INTEGER) AS 
BEGIN
	BEGIN
		EXECUTE IMMEDIATE 'SELECT 0 FROM USER_TAB_COLUMNS WHERE TABLE_NAME = ''' || TO_CHAR(UPPER(DBTableName)) || ''' AND COLUMN_NAME = ''' || TO_CHAR(UPPER(DBColumnName)) || '''' INTO DBFound;
	EXCEPTION WHEN NO_DATA_FOUND THEN
		DBFound := 1; /* Not Found */
	END; 
END;

~

CREATE OR REPLACE PROCEDURE Upgrade_Conversion(DBTableName NVARCHAR2, DBColumnName NVARCHAR2, DBNewColumn NVARCHAR2)
AS
  	   v_existsFlag INT;
	   v_cursor	INT;
	   v_DBStatus INT; 
	   v_queryStr NVARCHAR2(1024);
	   v_indexName NVARCHAR2(32);
BEGIN
	BEGIN 
		SELECT 1 INTO v_existsFlag 
		FROM USER_TAB_COLUMNS  
		WHERE UPPER(TABLE_NAME) = DBTableName AND
		UPPER(Column_Name) = DBColumnName AND
		UPPER(Data_Type) = DBNewColumn;
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN
			 BEGIN
				SELECT 1 INTO v_existsFlag 
				FROM USER_TAB_COLUMNS  
				WHERE UPPER(TABLE_NAME) = DBTableName AND
				UPPER(Column_Name) = DBColumnName AND
				UPPER(Data_Type) = 'NCLOB';
				EXCEPTION
					WHEN NO_DATA_FOUND THEN
					BEGIN
						EXECUTE IMMEDIATE 'ALTER TABLE ' || TO_CHAR(DBTableName) || ' MODIFY ' || TO_CHAR(DBColumnName) || ' ' || TO_CHAR(DBNewColumn);
						DBMS_OUTPUT.PUT_LINE('Table Successfully Altered.');
					END;
			END;
	END;
	
	BEGIN
		v_cursor := DBMS_SQL.OPEN_CURSOR; /* cursor id */
		v_queryStr := 'SELECT index_name FROM user_indexes WHERE Index_Type != N''LOB'' AND table_name = N''' || DBTableName || '''';
		/** Once columns have been migrated from LONG to LOB for a table, Indexes Need to be rebuilt on that table. 
		  * Successful migration of columns from LONG to LOB on a table creates a LOB type Index on that table.
		  * This index cannot be Rebuilt. A Rebuild attempt on the same throws Oracle Execption.
		  * - Varun Bhansaly
		 **/
		DBMS_SQL.PARSE(v_cursor, TO_NCHAR(v_QueryStr), DBMS_SQL.NATIVE); 
		DBMS_SQL.DEFINE_COLUMN(v_cursor, 1 , v_indexName, 32);
		v_DBStatus := DBMS_SQL.EXECUTE(v_cursor);  
		v_DBStatus := DBMS_SQL.FETCH_ROWS(v_cursor);
		WHILE (v_DBStatus <> 0) LOOP
		BEGIN 
			  DBMS_SQL.COLUMN_VALUE(v_cursor, 1, v_indexName);
			  EXECUTE IMMEDIATE 'ALTER INDEX ' || TO_CHAR(v_indexName) || ' REBUILD'; 
			  v_DBStatus := DBMS_SQL.FETCH_ROWS(v_cursor);
			  DBMS_OUTPUT.PUT_LINE('Index Rebuild On ' || DBTableName || ' Successful.');
		END;
		END LOOP;
	EXCEPTION  
		WHEN OTHERS THEN  
		BEGIN
			RAISE;
		END; 
	END;
	/* close Cursor */	
	IF (DBMS_SQL.IS_OPEN(v_Cursor)) THEN 
		DBMS_SQL.CLOSE_CURSOR(v_Cursor);  
	END IF; 
END;

~

CREATE OR REPLACE PROCEDURE Upgrade AS
	v_logStatus 		BOOLEAN;
	v_scriptName        NVARCHAR2(100) := 'Upgrade09_SP00_002';
	
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
	v_logStatus := LogInsert(1,'Modifying TRIGGER WFMAILQUEUETRIGGER');
	BEGIN
		v_logStatus := LogSkip(1);		
		Upgrade_Conversion(UPPER(N'ActivityTable'), UPPER(N'ActivityIcon'), UPPER(N'BLOB'));
		Upgrade_Conversion(UPPER(N'MailTriggerTable'), UPPER(N'Message'), UPPER(N'CLOB'));
		Upgrade_Conversion(UPPER(N'TemplateDefinitionTable'), UPPER(N'TemplateBuffer'), UPPER(N'BLOB'));
		Upgrade_Conversion(UPPER(N'WFMailQueueTable'), UPPER(N'MailMessage'), UPPER(N'CLOB'));
		Upgrade_Conversion(UPPER(N'ActionDefTable'), UPPER(N'IconBuffer'), UPPER(N'BLOB'));
		Upgrade_Conversion(UPPER(N'ProcessINITable'), UPPER(N'ProcessINI'), UPPER(N'BLOB'));
		Upgrade_Conversion(UPPER(N'PrintFaxEmailTable'), UPPER(N'CoverSheetBuffer'), UPPER(N'BLOB'));
		Upgrade_Conversion(UPPER(N'WFForm_Table'), UPPER(N'FormBuffer'), UPPER(N'BLOB'));
		Upgrade_Conversion(UPPER(N'TemplateMultiLanguageTable'), UPPER(N'TemplateBuffer'), UPPER(N'BLOB'));
		EXECUTE IMMEDIATE 'CREATE OR REPLACE TRIGGER WFMAILQUEUETRIGGER	BEFORE INSERT ON WFMAILQUEUETABLE FOR EACH ROW BEGIN SELECT TaskId.NEXTVAL INTO :NEW.TaskId FROM dual;END;';
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(1);
			raise_application_error(-20201,v_scriptName ||' BLOCK 1 FAILED');
	END;
	v_logStatus := LogUpdate(1);
	
	
	
END;

~

call Upgrade()

~

Drop Procedure Upgrade
~