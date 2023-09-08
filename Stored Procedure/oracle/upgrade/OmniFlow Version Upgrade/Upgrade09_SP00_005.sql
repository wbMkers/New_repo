/*
Change DATE		Name				Description
--------------------------------------------------------------
26/05/2017		Sanal Grover		Bug 62518 - Step by Step Debugs in Version Upgrade.
*/
Create OR Replace Procedure Upgrade AS
	existsFlag				INTEGER;
	v_logStatus 			BOOLEAN;
	v_scriptName            NVARCHAR2(100) := 'Upgrade09_SP00_005';
		
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

	v_logStatus := LogInsert(1,'Applying HOTFIX_6.2_037');
	BEGIN
		Upgrade1(N'HOTFIX_6.2_037', existsFlag);
		SAVEPOINT savepoint1;
		IF(existsFlag <> 0) THEN
			BEGIN
				v_logStatus := LogSkip(1);
				EXECUTE IMMEDIATE 'INSERT INTO WFCABVERSIONTABLE VALUES (N''HOTFIX_6.2_037'', CABVERSIONID.NEXTVAL, SYSDATE, SYSDATE, N''HOTFIX_6.2_037 REPORT UPDATE'', N''Y'')';
				COMMIT;
				DBMS_OUTPUT.PUT_LINE('Successfully Applied HOTFIX_6.2_037 !!');
			EXCEPTION
			WHEN OTHERS THEN
				DBMS_OUTPUT.PUT_LINE('Check !! Check !! Exception encountered while applying HOTFIX_6.2_037');
				DBMS_OUTPUT.PUT_LINE('Transaction being rolled back to savepoint1');
				ROLLBACK TO SAVEPOINT savepoint1;
			END;
		END IF;
	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(1);   
			raise_application_error(-20201,v_scriptName ||' BLOCK 1 FAILED');
	END;
	v_logStatus := LogUpdate(1);

	v_logStatus := LogInsert(2,'Appliying Bugzilla_Id_2840');
	BEGIN
		Upgrade1(N'Bugzilla_Id_2840', existsFlag);
		SAVEPOINT savepoint2;
		IF(existsFlag <> 0) THEN /* Not Found */
			BEGIN
				v_logStatus := LogSkip(2);
				EXECUTE IMMEDIATE 'INSERT INTO WFCABVERSIONTABLE VALUES (N''Bugzilla_Id_2840'', CABVERSIONID.NEXTVAL, SYSDATE, SYSDATE, N''[Oracle] [PostgreSQL] Wrong ActionIds for LogIn & LogOut'', N''Y'')';
				COMMIT;
				DBMS_OUTPUT.PUT_LINE('Successfully Applied Bugzilla_Id_2840 !!');
			EXCEPTION 
			WHEN OTHERS THEN 
				DBMS_OUTPUT.PUT_LINE('Check !! Check !! Execution encountered while applying Bugzilla_Id_2840');
				DBMS_OUTPUT.PUT_LINE('Transaction being rolled back to savepoint2');
				ROLLBACK TO SAVEPOINT savepoint2;
			END;
		END IF;

	EXCEPTION
		WHEN OTHERS THEN
			v_logStatus := LogUpdateError(2);   
			raise_application_error(-20202,v_scriptName ||' BLOCK 2 FAILED');
	END;
	v_logStatus := LogUpdate(2);


	
END;
~

call Upgrade()

~

Drop Procedure Upgrade

~

Drop Procedure Upgrade_Conversion

~

Drop Procedure Upgrade1

~

Drop Procedure Upgrade_CheckColumnExistence

~
