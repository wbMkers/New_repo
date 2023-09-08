/*
Change DATE		Name				Description
--------------------------------------------------------------
26/05/2017		Sanal Grover		Bug 62518 - Step by Step Debugs in Version Upgrade.
*/
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
	existsFlag 			INT;
	v_logStatus 		BOOLEAN;
	v_scriptName            NVARCHAR2(100) := 'Upgrade09_SP00_013_history';	
	
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
		
	v_logStatus := LogInsert(1,'Altering WFMailQueueHistoryTable Modifying MailMessage to clob');
	BEGIN
		v_logStatus := LogSkip(1);
		Upgrade_Conversion(UPPER(N'WFMailQueueHistoryTable'), UPPER(N'MailMessage'), UPPER(N'CLOB'));
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(1);   
			raise_application_error(-20201,v_scriptName ||' BLOCK 1 FAILED');
	END;
	v_logStatus := LogUpdate(1);
		
		
	v_logStatus := LogInsert(2,'Modifying EXCEPTIONCOMMENTS to nvarchar in EXCEPTIONHISTORYTABLE');
	BEGIN
		
		BEGIN
			existsFlag:=0;
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME='EXCEPTIONHISTORYTABLE'
			AND COLUMN_NAME=UPPER('EXCEPTIONCOMMENTS')
			AND	DATA_TYPE='NVARCHAR2'
			AND DATA_LENGTH>=512; 
			EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_logStatus := LogSkip(2);
				EXECUTE IMMEDIATE 'ALTER TABLE EXCEPTIONHISTORYTABLE MODIFY (EXCEPTIONCOMMENTS NVARCHAR2(512))';
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(2);   
			raise_application_error(-20202,v_scriptName ||' BLOCK 2 FAILED');
	END;
	v_logStatus := LogUpdate(2);

		
	v_logStatus := LogInsert(3,'Adding new Column CalendarName in QUEUEHISTORYTABLE');
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
				v_logStatus := LogSkip(3);
				EXECUTE IMMEDIATE 'ALTER TABLE QueueHistoryTable Add ( CalendarName NVARCHAR2(255) )';
				DBMS_OUTPUT.PUT_LINE('Table QueueHistoryTable altered with a new Column CalendarName');
		END;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(3);   
			raise_application_error(-20203,v_scriptName ||' BLOCK 3 FAILED');
	END;
	v_logStatus := LogUpdate(3);
		
	v_logStatus := LogInsert(4,'Adding new Column EXPORTSTATUS in QUEUEHISTORYTABLE');
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
				v_logStatus := LogSkip(4);
				EXECUTE IMMEDIATE 'ALTER TABLE "QUEUEHISTORYTABLE" ADD "EXPORTSTATUS" NVARCHAR2(1) DEFAULT (N''N'')'; 
			END IF;
		END;
		
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(4);   
			raise_application_error(-20204,v_scriptName ||' BLOCK 4 FAILED');
	END;
	v_logStatus := LogUpdate(4);
		
		
	v_logStatus := LogInsert(5,'Modifying column  TOTALDURATION to Number in SUMMARYTABLE');
	BEGIN
		
		BEGIN
			existsFlag:=0;
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME='SUMMARYTABLE'
			AND COLUMN_NAME=UPPER('TOTALDURATION')
			AND	DATA_TYPE='NUMBER';
			EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_logStatus := LogSkip(5);
				EXECUTE IMMEDIATE 'ALTER TABLE SUMMARYTABLE MODIFY (TOTALDURATION NUMBER)';
		END;
		
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(5);   
			raise_application_error(-20205,v_scriptName ||' BLOCK 5 FAILED');
	END;
	v_logStatus := LogUpdate(5);
		
		
		
	v_logStatus := LogInsert(6,'Modifying column TOTALPROCESSINGTIME to NUMBER in SUMMARYTABLE ');
	BEGIN
		BEGIN
			existsFlag:=0;
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME='SUMMARYTABLE'
			AND COLUMN_NAME=UPPER('TOTALPROCESSINGTIME')
			AND	DATA_TYPE='NUMBER';
			EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_logStatus := LogSkip(6);
				EXECUTE IMMEDIATE 'ALTER TABLE SUMMARYTABLE MODIFY (TOTALPROCESSINGTIME NUMBER)';
		END;
		
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(6);   
			raise_application_error(-20206,v_scriptName ||' BLOCK 6 FAILED');
	END;
	v_logStatus := LogUpdate(6);
		
		
	v_logStatus := LogInsert(7,'Modifying column DELAYTIME to NUMBER in SUMMARYTABLE ');
	BEGIN
		BEGIN
			existsFlag:=0;
			SELECT 1 INTO existsFlag 
			FROM USER_TAB_COLUMNS
			WHERE TABLE_NAME='SUMMARYTABLE'
			AND COLUMN_NAME=UPPER('DELAYTIME')
			AND	DATA_TYPE='NUMBER';
			EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_logStatus := LogSkip(7);
				EXECUTE IMMEDIATE 'ALTER TABLE SUMMARYTABLE MODIFY (DELAYTIME NUMBER)'; /* Ishu Saraf 16/01/2009 */
		END;
		
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(7);   
			raise_application_error(-20207,v_scriptName ||' BLOCK 7 FAILED');
	END;
	v_logStatus := LogUpdate(7);
		
	
END;


~

call Upgrade()

~

Drop Procedure Upgrade
~

Drop Procedure Upgrade_Conversion

~