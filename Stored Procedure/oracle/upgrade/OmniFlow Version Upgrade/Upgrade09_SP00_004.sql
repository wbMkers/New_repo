/*
Change DATE		Name				Description
--------------------------------------------------------------
26/05/2017		Sanal Grover		Bug 62518 - Step by Step Debugs in Version Upgrade.
*/
CREATE OR REPLACE PROCEDURE SystemCatalog AS
		v_ProcessDefId		INTEGER;
		v_ExtMethodIndex1	INTEGER;
		v_ExtMethodIndex	INTEGER;
		v_cabVersion		VARCHAR2 (2000);
		v_count				INTEGER;
		v_found				INTEGER;
		v_ExtAppName		VARCHAR2(200);
		v_ExtAppType		VARCHAR2(1);
		v_paramname1		VARCHAR2 (2000);
		v_paramname2		VARCHAR2 (2000);
		v_paramname3		VARCHAR2 (2000);
		v_STR1				VARCHAR2(2000);
		v_STR2				VARCHAR2(2000);
		v_STR3				VARCHAR2(2000);
		v_STR4				VARCHAR2(2000);
		v_STR5				VARCHAR2(2000);
		v_STR6				VARCHAR2(2000);
		v_STR7				VARCHAR2(2000);
		v_logStatus 		BOOLEAN;
		v_scriptName        NVARCHAR2(100) := 'Upgrade09_SP00_004';
		
	FUNCTION findMaxExtMethodIndex(v_processdefid IN NUMBER,v_ExtAppName IN VARCHAR2,v_ExtAppType IN VARCHAR2) RETURN INTEGER
		AS

		v_Maxnumber NUMBER;
		BEGIN

		--v_Maxnumber:=1;
		select NVL(MAX(EXTMETHODINDEX),0) + 1 INTO v_Maxnumber from EXTMETHODDEFTABLE where processdefid=v_processdefid and extappname=v_ExtAppName and extapptype=v_ExtAppType;



		RETURN v_Maxnumber;

	END;
		
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

	v_logStatus := LogInsert(1,'Upgrading SystemCatalog i.e updating and inserting values in tables ExtMethodDefTable,ExtMethodParamDefTable,ExtMethodParamMappingTable,WFWebserviceTable,WFDatastructureTable,RuleOperationTable,WFCabVersionTable');
	BEGIN
					
		BEGIN
			v_ExtAppName := 'System';
			v_ExtAppType := 'S';

			SELECT CabVersion INTO v_cabVersion FROM WFCabVersionTable WHERE CabVersion = '7.2_SystemCatalog' and rownum <= 1;
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN
			BEGIN
				v_logStatus := LogSkip(1);
				DECLARE CURSOR cursor1 IS SELECT ProcessDefId, ExtMethodIndex FROM ExtMethodDefTable WHERE ExtAppType != 'S' and ExtMethodIndex < 1000;
				BEGIN		
				OPEN cursor1;
				LOOP
					FETCH cursor1 INTO v_ProcessDefId, v_ExtMethodIndex;
					EXIT WHEN cursor1%NOTFOUND;
					v_ExtMethodIndex1 := v_ExtMethodIndex + 1000;
				
					v_STR1 := ' UPDATE ExtMethodDefTable SET ExtMethodIndex = ' || TO_CHAR(v_ExtMethodIndex1) || ' WHERE ProcessDefId = ' || TO_CHAR(v_ProcessDefId) || ' AND ExtMethodIndex = ' || TO_CHAR(v_ExtMethodIndex);
					v_STR2 := ' UPDATE ExtMethodParamDefTable SET ExtMethodIndex = ' || TO_CHAR(v_ExtMethodIndex1) || ' WHERE ProcessDefId = ' || TO_CHAR(v_ProcessDefId) || ' AND ExtMethodIndex = ' || TO_CHAR(v_ExtMethodIndex);
					v_STR3 := ' UPDATE ExtMethodParamMappingTable SET ExtMethodIndex = ' || TO_CHAR(v_ExtMethodIndex1) || ' WHERE ProcessDefId = ' || TO_CHAR(v_ProcessDefId) || ' AND ExtMethodIndex = ' || TO_CHAR(v_ExtMethodIndex);
					v_STR4 := ' UPDATE WFWebserviceTable SET ExtMethodIndex = ' || TO_CHAR(v_ExtMethodIndex1) || ' WHERE ProcessDefId = ' ||  TO_CHAR(v_ProcessDefId) || ' AND ExtMethodIndex = ' || TO_CHAR(v_ExtMethodIndex);
					v_STR5 := ' UPDATE WFDatastructureTable SET ExtMethodIndex = ' || TO_CHAR(v_ExtMethodIndex1) || ' WHERE ProcessDefId = '   || TO_CHAR(v_ProcessDefId) || ' AND ExtMethodIndex = ' || TO_CHAR(v_ExtMethodIndex);
					v_STR6 := ' UPDATE RuleOperationTable SET Param1 = '|| TO_CHAR(v_ExtMethodIndex1) ||' WHERE ProcessDefId = ' ||  TO_CHAR(v_ProcessDefId) || ' AND OperationType = 22 AND Param1 = '''||TO_CHAR(v_ExtMethodIndex)||'''';
					v_STR7 := ' UPDATE RuleOperationTable SET Param2 = '|| TO_CHAR(v_ExtMethodIndex1) ||' WHERE ProcessDefId = ' || TO_CHAR(v_ProcessDefId) || ' AND OperationType = 23 AND Param2 = '''||TO_CHAR(v_ExtMethodIndex)||'''';

					SAVEPOINT sys_catalog;
						EXECUTE IMMEDIATE v_STR1;
						EXECUTE IMMEDIATE v_STR2;
						EXECUTE IMMEDIATE v_STR3;
						EXECUTE IMMEDIATE v_STR4;
						EXECUTE IMMEDIATE v_STR5;
						EXECUTE IMMEDIATE v_STR6;
						EXECUTE IMMEDIATE v_STR7;
					COMMIT;

				END LOOP;
				CLOSE cursor1;
				END;
				EXECUTE IMMEDIATE 'INSERT INTO WFCabVersionTable(cabVersion, cabVersionId, creationDate, lastModified, Remarks, Status) VALUES (N''7.2_SystemCatalog'', cabVersionId.nextVal, SYSDATE, SYSDATE, N''BPEL Compliant OmniFlow'', N''Y'')';
			END;

			v_ExtMethodIndex := 1;
			DECLARE 
			CURSOR cursor1 IS SELECT DISTINCT ProcessDefId FROM ProcessDefTable; 
			BEGIN
				OPEN cursor1;
				LOOP
					FETCH cursor1 INTO v_ProcessDefId;
					EXIT WHEN cursor1%NOTFOUND;
					BEGIN
					v_ExtMethodIndex := 1;
						DECLARE 
						CURSOR cursor2 IS SELECT ExtMethodIndex FROM ExtMethodDefTable WHERE ProcessDefId = v_ProcessDefId AND ExtMethodName = N'contains' and ReturnType = 12;	/* Returns the ExtMethodIndex for given ExtMethodName and its ReturnType */
						BEGIN
							v_found := 0;
							OPEN cursor2;
							LOOP
								FETCH cursor2 INTO v_ExtMethodIndex1;
								EXIT WHEN cursor2%NOTFOUND;
								BEGIN
									v_found := 1;
									SELECT count(*) INTO v_count FROM ExtMethodParamDefTable where ProcessDefId = v_ProcessDefId and ExtMethodIndex = v_ExtMethodIndex1;	/* Returns the count of ParameterName from ExtMethodParamDefTable for ExtMethodIndex */
									IF (v_count = 2) THEN /* If count is equal to number of parameters for ExtMethodName */
									BEGIN
										BEGIN
											SELECT ParameterName INTO v_paramname1 FROM ExtMethodParamDefTable WHERE ProcessDefId = v_ProcessDefId and ExtMethodIndex = v_ExtMethodIndex1 and ParameterType = 10 AND ParameterName = 'Param1'; /* Returns the ParameterName from ExtMethodParamDefTable for ExtmethodIndex and ParameterType */
											EXCEPTION
												WHEN NO_DATA_FOUND THEN
													v_found := 0;	 /* If parameter not found */
										END;
										BEGIN
											SELECT ParameterName INTO v_paramname2 FROM ExtMethodParamDefTable WHERE ProcessDefId = v_ProcessDefId and ExtMethodIndex = v_ExtMethodIndex1 and ParameterType = 10 AND ParameterName = 'Param2';
											EXCEPTION
												WHEN NO_DATA_FOUND THEN
													v_found := 0;		 /* If Parameter not found */
										END;
									END;
									ELSE
										v_found := 0;	/* If count is not equal to number of Parameters */
									END IF;
									EXIT WHEN v_found = 1;
								END;
							END LOOP;
							CLOSE cursor2;
						END;

						IF v_found = 0 THEN
						BEGIN
							SAVEPOINT sys_catalog;
							
								v_ExtMethodIndex:=findMaxExtMethodIndex(v_ProcessDefId,v_ExtAppName,v_ExtAppType);
							
								EXECUTE IMMEDIATE 'INSERT INTO ExtMethodDefTable(ProcessDefId,ExtMethodIndex,ExtAppName,ExtAppType,ExtMethodName,SearchMethod,SearchCriteria,ReturnType,MappingFile) VALUES(' || v_ProcessDefId || ',' || v_ExtMethodIndex || ',N''' || v_ExtAppName || ''', N''' || v_ExtAppType || ''', N''contains'', NULL, NULL, 12, NULL)';
								EXECUTE IMMEDIATE 'INSERT INTO ExtMethodParamDefTable(PROCESSDEFID,EXTMETHODPARAMINDEX,EXTMETHODINDEX,PARAMETERNAME,PARAMETERTYPE,PARAMETERORDER,DATASTRUCTUREID,PARAMETERSCOPE,UNBOUNDED) VALUES(' || v_ProcessDefId || ', 1,'  || v_ExtMethodIndex ||  ', N''Param1'', 10, 1, NULL, NULL, N''N'')';
								EXECUTE IMMEDIATE 'INSERT INTO ExtMethodParamDefTable(PROCESSDEFID,EXTMETHODPARAMINDEX,EXTMETHODINDEX,PARAMETERNAME,PARAMETERTYPE,PARAMETERORDER,DATASTRUCTUREID,PARAMETERSCOPE,UNBOUNDED) VALUES(' || v_ProcessDefId|| ', 2,' || v_ExtMethodIndex || ', N''Param2'', 10, 2, NULL, NULL, N''N'')';
							COMMIT;
						END;
						END IF;

						v_ExtMethodIndex := v_ExtMethodIndex + 1;
						DECLARE 
						CURSOR cursor2 IS SELECT ExtMethodIndex FROM ExtMethodDefTable WHERE ProcessDefId = v_ProcessDefId AND ExtMethodName = N'normalizeSpace' and ReturnType = 10;	
						BEGIN
							v_found := 0;
							OPEN cursor2;
							LOOP
								FETCH cursor2 INTO v_ExtMethodIndex1;
								EXIT WHEN cursor2%NOTFOUND;
								BEGIN
									v_found := 1;
									SELECT count(*) INTO v_count FROM ExtMethodParamDefTable where ProcessDefId = v_ProcessDefId and ExtMethodIndex = v_ExtMethodIndex1;	
									IF (v_count = 1) THEN 
									BEGIN
											SELECT ParameterName INTO v_paramname1 FROM ExtMethodParamDefTable WHERE ProcessDefId = v_ProcessDefId and ExtMethodIndex = v_ExtMethodIndex1 and ParameterType = 10 AND ParameterName = 'Param1'; 
											EXCEPTION
												WHEN NO_DATA_FOUND THEN
													v_found := 0;	 
									END;
									ELSE
										v_found := 0;	
									END IF;
									EXIT WHEN v_found = 1;
								END;
							END LOOP;
							CLOSE cursor2;
						END;

						IF v_found = 0 THEN
						BEGIN
							SAVEPOINT sys_catalog;
								v_ExtMethodIndex:=findMaxExtMethodIndex(v_ProcessDefId,v_ExtAppName,v_ExtAppType);
								EXECUTE IMMEDIATE 'INSERT INTO ExtMethodDefTable(ProcessDefId,ExtMethodIndex,ExtAppName,ExtAppType,ExtMethodName,SearchMethod,SearchCriteria,ReturnType,MappingFile) VALUES(' || TO_CHAR(v_ProcessDefId) || ',' || TO_CHAR(v_ExtMethodIndex)|| ',N''' || v_ExtAppName || ''', N''' || v_ExtAppType || ''', N''normalizeSpace'', NULL, NULL, 10, NULL)';
								EXECUTE IMMEDIATE 'INSERT INTO ExtMethodParamDefTable(PROCESSDEFID,EXTMETHODPARAMINDEX,EXTMETHODINDEX,PARAMETERNAME,PARAMETERTYPE,PARAMETERORDER,DATASTRUCTUREID,PARAMETERSCOPE,UNBOUNDED) VALUES(' || TO_CHAR(v_ProcessDefId) || ', 1,'  || TO_CHAR(v_ExtMethodIndex) ||  ', N''Param1'', 10, 1, NULL, NULL, N''N'')';
							COMMIT;
						END;
						END IF;

						v_ExtMethodIndex := v_ExtMethodIndex + 1;
						DECLARE 
						CURSOR cursor2 IS SELECT ExtMethodIndex FROM ExtMethodDefTable WHERE ProcessDefId = v_ProcessDefId AND ExtMethodName = N'stringValue' and ReturnType = 10;	
						BEGIN
							v_found := 0;
							OPEN cursor2;
							LOOP
								FETCH cursor2 INTO v_ExtMethodIndex1;
								EXIT WHEN cursor2%NOTFOUND;
								BEGIN
									v_found := 1;
									SELECT count(*) INTO v_count FROM ExtMethodParamDefTable where ProcessDefId = v_ProcessDefId and ExtMethodIndex = v_ExtMethodIndex1;	
									IF (v_count = 1) THEN 
									BEGIN
											SELECT ParameterName INTO v_paramname1 FROM ExtMethodParamDefTable WHERE ProcessDefId = v_ProcessDefId and ExtMethodIndex = v_ExtMethodIndex1 and ParameterType = 10 AND ParameterName = 'Param1'; 
											EXCEPTION
												WHEN NO_DATA_FOUND THEN
													v_found := 0;	 
									END;
									ELSE
										v_found := 0;	
									END IF;
									EXIT WHEN v_found = 1;
								END;
							END LOOP;
							CLOSE cursor2;
						END;

						IF v_found = 0 THEN
						BEGIN
							SAVEPOINT sys_catalog;
								v_ExtMethodIndex:=findMaxExtMethodIndex(v_ProcessDefId,v_ExtAppName,v_ExtAppType);
							
								EXECUTE IMMEDIATE 'INSERT INTO ExtMethodDefTable(ProcessDefId,ExtMethodIndex,ExtAppName,ExtAppType,ExtMethodName,SearchMethod,SearchCriteria,ReturnType,MappingFile) VALUES(' || TO_CHAR(v_ProcessDefId) || ',' || TO_CHAR(v_ExtMethodIndex)|| ',N''' || v_ExtAppName || ''', N''' || v_ExtAppType || ''', N''stringValue'', NULL, NULL, 10, NULL)';
								EXECUTE IMMEDIATE 'INSERT INTO ExtMethodParamDefTable(PROCESSDEFID,EXTMETHODPARAMINDEX,EXTMETHODINDEX,PARAMETERNAME,PARAMETERTYPE,PARAMETERORDER,DATASTRUCTUREID,PARAMETERSCOPE,UNBOUNDED) VALUES(' || TO_CHAR(v_ProcessDefId) || ', 1,'  || TO_CHAR(v_ExtMethodIndex) ||  ', N''Param1'', 10, 1, NULL, NULL, N''N'')';
							COMMIT;
						END;
						END IF;

						v_ExtMethodIndex := v_ExtMethodIndex + 1;
						DECLARE 
						CURSOR cursor2 IS SELECT ExtMethodIndex FROM ExtMethodDefTable WHERE ProcessDefId = v_ProcessDefId AND ExtMethodName = N'stringValue' and ReturnType = 10;	
						BEGIN
							v_found := 0;
							OPEN cursor2;
							LOOP
								FETCH cursor2 INTO v_ExtMethodIndex1;
								EXIT WHEN cursor2%NOTFOUND;
								BEGIN
									v_found := 1;
									SELECT count(*) INTO v_count FROM ExtMethodParamDefTable where ProcessDefId = v_ProcessDefId and ExtMethodIndex = v_ExtMethodIndex1;	
									IF (v_count = 1) THEN 
									BEGIN
											SELECT ParameterName INTO v_paramname1 FROM ExtMethodParamDefTable WHERE ProcessDefId = v_ProcessDefId and ExtMethodIndex = v_ExtMethodIndex1 and ParameterType = 8 AND ParameterName = 'Param1'; 
											EXCEPTION
												WHEN NO_DATA_FOUND THEN
													v_found := 0;	 
									END;
									ELSE
										v_found := 0;	
									END IF;
									EXIT WHEN v_found = 1;
								END;
							END LOOP;
							CLOSE cursor2;
						END;

						IF v_found = 0 THEN
						BEGIN
							SAVEPOINT sys_catalog;
								v_ExtMethodIndex:=findMaxExtMethodIndex(v_ProcessDefId,v_ExtAppName,v_ExtAppType);
								EXECUTE IMMEDIATE 'INSERT INTO ExtMethodDefTable(ProcessDefId,ExtMethodIndex,ExtAppName,ExtAppType,ExtMethodName,SearchMethod,SearchCriteria,ReturnType,MappingFile) VALUES(' || TO_CHAR(v_ProcessDefId) || ',' || TO_CHAR(v_ExtMethodIndex)|| ',N''' || v_ExtAppName || ''', N''' || v_ExtAppType || ''', N''stringValue'', NULL, NULL, 10, NULL)';
								EXECUTE IMMEDIATE 'INSERT INTO ExtMethodParamDefTable(PROCESSDEFID,EXTMETHODPARAMINDEX,EXTMETHODINDEX,PARAMETERNAME,PARAMETERTYPE,PARAMETERORDER,DATASTRUCTUREID,PARAMETERSCOPE,UNBOUNDED) VALUES(' || TO_CHAR(v_ProcessDefId) || ', 1,'  || TO_CHAR(v_ExtMethodIndex) ||  ', N''Param1'', 8, 1, NULL, NULL, N''N'')';
							COMMIT;
						END;
						END IF;

						v_ExtMethodIndex := v_ExtMethodIndex + 1;
						DECLARE 
						CURSOR cursor2 IS SELECT ExtMethodIndex FROM ExtMethodDefTable WHERE ProcessDefId = v_ProcessDefId AND ExtMethodName = N'stringValue' and ReturnType = 10;	
						BEGIN
							v_found := 0;
							OPEN cursor2;
							LOOP
								FETCH cursor2 INTO v_ExtMethodIndex1;
								EXIT WHEN cursor2%NOTFOUND;
								BEGIN
									v_found := 1;
									SELECT count(*) INTO v_count FROM ExtMethodParamDefTable where ProcessDefId = v_ProcessDefId and ExtMethodIndex = v_ExtMethodIndex1;	
									IF (v_count = 1) THEN 
									BEGIN
											SELECT ParameterName INTO v_paramname1 FROM ExtMethodParamDefTable WHERE ProcessDefId = v_ProcessDefId and ExtMethodIndex = v_ExtMethodIndex1 and ParameterType = 6 AND ParameterName = 'Param1'; 
											EXCEPTION
												WHEN NO_DATA_FOUND THEN
													v_found := 0;	 
									END;
									ELSE
										v_found := 0;	
									END IF;
									EXIT WHEN v_found = 1;
								END;
							END LOOP;
							CLOSE cursor2;
						END;

						IF v_found = 0 THEN
						BEGIN
							SAVEPOINT sys_catalog;
							
								v_ExtMethodIndex:=findMaxExtMethodIndex(v_ProcessDefId,v_ExtAppName,v_ExtAppType);
								EXECUTE IMMEDIATE 'INSERT INTO ExtMethodDefTable(ProcessDefId,ExtMethodIndex,ExtAppName,ExtAppType,ExtMethodName,SearchMethod,SearchCriteria,ReturnType,MappingFile) VALUES(' || TO_CHAR(v_ProcessDefId) || ',' || TO_CHAR(v_ExtMethodIndex)|| ',N''' || v_ExtAppName || ''', N''' || v_ExtAppType || ''', N''stringValue'', NULL, NULL, 10, NULL)';
								EXECUTE IMMEDIATE 'INSERT INTO ExtMethodParamDefTable(PROCESSDEFID,EXTMETHODPARAMINDEX,EXTMETHODINDEX,PARAMETERNAME,PARAMETERTYPE,PARAMETERORDER,DATASTRUCTUREID,PARAMETERSCOPE,UNBOUNDED) VALUES(' || TO_CHAR(v_ProcessDefId) || ', 1,'  || TO_CHAR(v_ExtMethodIndex) ||  ', N''Param1'', 6, 1, NULL, NULL, N''N'')';
							COMMIT;
						END;
						END IF;

						v_ExtMethodIndex := v_ExtMethodIndex + 1;
						DECLARE 
						CURSOR cursor2 IS SELECT ExtMethodIndex FROM ExtMethodDefTable WHERE ProcessDefId = v_ProcessDefId AND ExtMethodName = N'stringValue' and ReturnType = 10;	
						BEGIN
							v_found := 0;
							OPEN cursor2;
							LOOP
								FETCH cursor2 INTO v_ExtMethodIndex1;
								EXIT WHEN cursor2%NOTFOUND;
								BEGIN
									v_found := 1;
									SELECT count(*) INTO v_count FROM ExtMethodParamDefTable where ProcessDefId = v_ProcessDefId and ExtMethodIndex = v_ExtMethodIndex1;	
									IF (v_count = 1) THEN 
									BEGIN
											SELECT ParameterName INTO v_paramname1 FROM ExtMethodParamDefTable WHERE ProcessDefId = v_ProcessDefId and ExtMethodIndex = v_ExtMethodIndex1 and ParameterType = 4 AND ParameterName = 'Param1'; 
											EXCEPTION
												WHEN NO_DATA_FOUND THEN
													v_found := 0;	 
									END;
									ELSE
										v_found := 0;	
									END IF;
									EXIT WHEN v_found = 1;
								END;
							END LOOP;
							CLOSE cursor2;
						END;

						IF v_found = 0 THEN
						BEGIN
							SAVEPOINT sys_catalog;
								
								v_ExtMethodIndex:=findMaxExtMethodIndex(v_ProcessDefId,v_ExtAppName,v_ExtAppType);
							
								EXECUTE IMMEDIATE 'INSERT INTO ExtMethodDefTable(ProcessDefId,ExtMethodIndex,ExtAppName,ExtAppType,ExtMethodName,SearchMethod,SearchCriteria,ReturnType,MappingFile) VALUES(' || TO_CHAR(v_ProcessDefId) || ',' || TO_CHAR(v_ExtMethodIndex)|| ',N''' || v_ExtAppName || ''', N''' || v_ExtAppType || ''', N''stringValue'', NULL, NULL, 10, NULL)';
								EXECUTE IMMEDIATE 'INSERT INTO ExtMethodParamDefTable(PROCESSDEFID,EXTMETHODPARAMINDEX,EXTMETHODINDEX,PARAMETERNAME,PARAMETERTYPE,PARAMETERORDER,DATASTRUCTUREID,PARAMETERSCOPE,UNBOUNDED) VALUES(' || TO_CHAR(v_ProcessDefId) || ', 1,'  || TO_CHAR(v_ExtMethodIndex) ||  ', N''Param1'', 4, 1, NULL, NULL, N''N'')';
							COMMIT;
						END;
						END IF;

						v_ExtMethodIndex := v_ExtMethodIndex + 1;
						DECLARE 
						CURSOR cursor2 IS SELECT ExtMethodIndex FROM ExtMethodDefTable WHERE ProcessDefId = v_ProcessDefId AND ExtMethodName = N'stringValue' and ReturnType = 10;	
						BEGIN
							v_found := 0;
							OPEN cursor2;
							LOOP
								FETCH cursor2 INTO v_ExtMethodIndex1;
								EXIT WHEN cursor2%NOTFOUND;
								BEGIN
									v_found := 1;
									SELECT count(*) INTO v_count FROM ExtMethodParamDefTable where ProcessDefId = v_ProcessDefId and ExtMethodIndex = v_ExtMethodIndex1;	
									IF (v_count = 1) THEN 
									BEGIN
											SELECT ParameterName INTO v_paramname1 FROM ExtMethodParamDefTable WHERE ProcessDefId = v_ProcessDefId and ExtMethodIndex = v_ExtMethodIndex1 and ParameterType = 3 AND ParameterName = 'Param1'; 
											EXCEPTION
												WHEN NO_DATA_FOUND THEN
													v_found := 0;	 
									END;
									ELSE
										v_found := 0;	
									END IF;
									EXIT WHEN v_found = 1;	
								END;
							END LOOP;
							CLOSE cursor2;
						END;

						IF v_found = 0 THEN
						BEGIN
							SAVEPOINT sys_catalog;
								v_ExtMethodIndex:=findMaxExtMethodIndex(v_ProcessDefId,v_ExtAppName,v_ExtAppType);
								EXECUTE IMMEDIATE 'INSERT INTO ExtMethodDefTable(ProcessDefId,ExtMethodIndex,ExtAppName,ExtAppType,ExtMethodName,SearchMethod,SearchCriteria,ReturnType,MappingFile) VALUES(' || TO_CHAR(v_ProcessDefId) || ',' || TO_CHAR(v_ExtMethodIndex)|| ',N''' || v_ExtAppName || ''', N''' || v_ExtAppType || ''', N''stringValue'', NULL, NULL, 10, NULL)';
								EXECUTE IMMEDIATE 'INSERT INTO ExtMethodParamDefTable(PROCESSDEFID,EXTMETHODPARAMINDEX,EXTMETHODINDEX,PARAMETERNAME,PARAMETERTYPE,PARAMETERORDER,DATASTRUCTUREID,PARAMETERSCOPE,UNBOUNDED) VALUES(' || TO_CHAR(v_ProcessDefId) || ', 1,'  || TO_CHAR(v_ExtMethodIndex) ||  ', N''Param1'', 3, 1, NULL, NULL, N''N'')';
							COMMIT;
						END;
						END IF;

						v_ExtMethodIndex := v_ExtMethodIndex + 1;
						DECLARE 
						CURSOR cursor2 IS SELECT ExtMethodIndex FROM ExtMethodDefTable WHERE ProcessDefId = v_ProcessDefId AND ExtMethodName = N'stringValue' and ReturnType = 10;	
						BEGIN
							v_found := 0;
							OPEN cursor2;
							LOOP
								FETCH cursor2 INTO v_ExtMethodIndex1;
								EXIT WHEN cursor2%NOTFOUND;
								BEGIN
									v_found := 1;
									SELECT count(*) INTO v_count FROM ExtMethodParamDefTable where ProcessDefId = v_ProcessDefId and ExtMethodIndex = v_ExtMethodIndex1;	
									IF (v_count = 1) THEN 
									BEGIN
											SELECT ParameterName INTO v_paramname1 FROM ExtMethodParamDefTable WHERE ProcessDefId = v_ProcessDefId and ExtMethodIndex = v_ExtMethodIndex1 and ParameterType = 12 AND ParameterName = 'Param1'; 
											EXCEPTION
												WHEN NO_DATA_FOUND THEN
													v_found := 0;	 
									END;
									ELSE
										v_found := 0;	
									END IF;
									EXIT WHEN v_found = 1;
								END;
							END LOOP;
							CLOSE cursor2;
						END;

						IF v_found = 0 THEN
						BEGIN
							SAVEPOINT sys_catalog;
								v_ExtMethodIndex:=findMaxExtMethodIndex(v_ProcessDefId,v_ExtAppName,v_ExtAppType);
							
								EXECUTE IMMEDIATE 'INSERT INTO ExtMethodDefTable(ProcessDefId,ExtMethodIndex,ExtAppName,ExtAppType,ExtMethodName,SearchMethod,SearchCriteria,ReturnType,MappingFile) VALUES(' || TO_CHAR(v_ProcessDefId) || ',' || TO_CHAR(v_ExtMethodIndex)|| ',N''' || v_ExtAppName || ''', N''' || v_ExtAppType || ''', N''stringValue'', NULL, NULL, 10, NULL)';
								EXECUTE IMMEDIATE 'INSERT INTO ExtMethodParamDefTable(PROCESSDEFID,EXTMETHODPARAMINDEX,EXTMETHODINDEX,PARAMETERNAME,PARAMETERTYPE,PARAMETERORDER,DATASTRUCTUREID,PARAMETERSCOPE,UNBOUNDED) VALUES(' || TO_CHAR(v_ProcessDefId) || ', 1,'  || TO_CHAR(v_ExtMethodIndex) ||  ', N''Param1'', 12, 1, NULL, NULL, N''N'')';
							COMMIT;
						END;
						END IF;

						v_ExtMethodIndex := v_ExtMethodIndex + 1;
						DECLARE 
						CURSOR cursor2 IS SELECT ExtMethodIndex FROM ExtMethodDefTable WHERE ProcessDefId = v_ProcessDefId AND ExtMethodName = N'booleanValue' and ReturnType = 12;	
						BEGIN
							v_found := 0;
							OPEN cursor2;
							LOOP
								FETCH cursor2 INTO v_ExtMethodIndex1;
								EXIT WHEN cursor2%NOTFOUND;
								BEGIN
									v_found := 1;
									SELECT count(*) INTO v_count FROM ExtMethodParamDefTable where ProcessDefId = v_ProcessDefId and ExtMethodIndex = v_ExtMethodIndex1;	
									IF (v_count = 1) THEN 
									BEGIN
											SELECT ParameterName INTO v_paramname1 FROM ExtMethodParamDefTable WHERE ProcessDefId = v_ProcessDefId and ExtMethodIndex = v_ExtMethodIndex1 and ParameterType = 10 AND ParameterName = 'Param1'; 
											EXCEPTION
												WHEN NO_DATA_FOUND THEN
													v_found := 0;	 
									END;
									ELSE
										v_found := 0;	
									END IF;
									EXIT WHEN v_found = 1;
								END;
							END LOOP;
							CLOSE cursor2;
						END;

						IF v_found = 0 THEN
						BEGIN
							SAVEPOINT sys_catalog;
								
								v_ExtMethodIndex:=findMaxExtMethodIndex(v_ProcessDefId,v_ExtAppName,v_ExtAppType);
							
								EXECUTE IMMEDIATE 'INSERT INTO ExtMethodDefTable(ProcessDefId,ExtMethodIndex,ExtAppName,ExtAppType,ExtMethodName,SearchMethod,SearchCriteria,ReturnType,MappingFile) VALUES(' || TO_CHAR(v_ProcessDefId) || ',' || TO_CHAR(v_ExtMethodIndex)|| ',N''' || v_ExtAppName || ''', N''' || v_ExtAppType || ''', N''booleanValue'', NULL, NULL, 12, NULL)';
								EXECUTE IMMEDIATE 'INSERT INTO ExtMethodParamDefTable(PROCESSDEFID,EXTMETHODPARAMINDEX,EXTMETHODINDEX,PARAMETERNAME,PARAMETERTYPE,PARAMETERORDER,DATASTRUCTUREID,PARAMETERSCOPE,UNBOUNDED) VALUES(' || TO_CHAR(v_ProcessDefId) || ', 1,'  || TO_CHAR(v_ExtMethodIndex) ||  ', N''Param1'', 10, 1, NULL, NULL, N''N'')';
							COMMIT;
						END;
						END IF;

						v_ExtMethodIndex := v_ExtMethodIndex + 1;
						DECLARE 
						CURSOR cursor2 IS SELECT ExtMethodIndex FROM ExtMethodDefTable WHERE ProcessDefId = v_ProcessDefId AND ExtMethodName = N'booleanValue' and ReturnType = 12;	
						BEGIN
							v_found := 0;
							OPEN cursor2;
							LOOP
								FETCH cursor2 INTO v_ExtMethodIndex1;
								EXIT WHEN cursor2%NOTFOUND;
								BEGIN
									v_found := 1;
									SELECT count(*) INTO v_count FROM ExtMethodParamDefTable where ProcessDefId = v_ProcessDefId and ExtMethodIndex = v_ExtMethodIndex1;	
									IF (v_count = 1) THEN 
									BEGIN
											SELECT ParameterName INTO v_paramname1 FROM ExtMethodParamDefTable WHERE ProcessDefId = v_ProcessDefId and ExtMethodIndex = v_ExtMethodIndex1 and ParameterType = 3 AND ParameterName = 'Param1'; 
											EXCEPTION
												WHEN NO_DATA_FOUND THEN
													v_found := 0;	 
									END;
									ELSE
										v_found := 0;	
									END IF;
									EXIT WHEN v_found = 1;	
								END;
							END LOOP;
							CLOSE cursor2;
						END;

						IF v_found = 0 THEN
						BEGIN
							SAVEPOINT sys_catalog;
								
								v_ExtMethodIndex:=findMaxExtMethodIndex(v_ProcessDefId,v_ExtAppName,v_ExtAppType);
							
								EXECUTE IMMEDIATE 'INSERT INTO ExtMethodDefTable(ProcessDefId,ExtMethodIndex,ExtAppName,ExtAppType,ExtMethodName,SearchMethod,SearchCriteria,ReturnType,MappingFile) VALUES(' || TO_CHAR(v_ProcessDefId) || ',' || TO_CHAR(v_ExtMethodIndex)|| ',N''' || v_ExtAppName || ''', N''' || v_ExtAppType || ''', N''booleanValue'', NULL, NULL, 12, NULL)';
								EXECUTE IMMEDIATE 'INSERT INTO ExtMethodParamDefTable(PROCESSDEFID,EXTMETHODPARAMINDEX,EXTMETHODINDEX,PARAMETERNAME,PARAMETERTYPE,PARAMETERORDER,DATASTRUCTUREID,PARAMETERSCOPE,UNBOUNDED) VALUES(' || TO_CHAR(v_ProcessDefId) || ', 1,'  || TO_CHAR(v_ExtMethodIndex) ||  ', N''Param1'', 3, 1, NULL, NULL, N''N'')';
							COMMIT;
						END;
						END IF;

						v_ExtMethodIndex := v_ExtMethodIndex + 1;
						DECLARE 
						CURSOR cursor2 IS SELECT ExtMethodIndex FROM ExtMethodDefTable WHERE ProcessDefId = v_ProcessDefId AND ExtMethodName = N'startsWith' and ReturnType = 12;	
						BEGIN
							v_found := 0;
							OPEN cursor2;
							LOOP
								FETCH cursor2 INTO v_ExtMethodIndex1;
								EXIT WHEN cursor2%NOTFOUND;
								BEGIN
									v_found := 1;
									SELECT count(*) INTO v_count FROM ExtMethodParamDefTable where ProcessDefId = v_ProcessDefId and ExtMethodIndex = v_ExtMethodIndex1;	
									IF (v_count = 2) THEN 
									BEGIN
										BEGIN
											SELECT ParameterName INTO v_paramname1 FROM ExtMethodParamDefTable WHERE ProcessDefId = v_ProcessDefId and ExtMethodIndex = v_ExtMethodIndex1 and ParameterType = 10 AND ParameterName = 'Param1'; 
											EXCEPTION
												WHEN NO_DATA_FOUND THEN
													v_found := 0;	
										END;
										BEGIN
											SELECT ParameterName INTO v_paramname2 FROM ExtMethodParamDefTable WHERE ProcessDefId = v_ProcessDefId and ExtMethodIndex = v_ExtMethodIndex1 and ParameterType = 10 AND ParameterName = 'Param2';
											EXCEPTION
												WHEN NO_DATA_FOUND THEN
													v_found := 0;		 
										END;
									END;
									ELSE
										v_found := 0;	
									END IF;
									EXIT WHEN v_found = 1;
								END;
							END LOOP;
							CLOSE cursor2;
						END;

						IF v_found = 0 THEN
						BEGIN
							SAVEPOINT sys_catalog;
							
								v_ExtMethodIndex:=findMaxExtMethodIndex(v_ProcessDefId,v_ExtAppName,v_ExtAppType);
								
								EXECUTE IMMEDIATE 'INSERT INTO ExtMethodDefTable(ProcessDefId,ExtMethodIndex,ExtAppName,ExtAppType,ExtMethodName,SearchMethod,SearchCriteria,ReturnType,MappingFile) VALUES(' || TO_CHAR(v_ProcessDefId) || ',' || TO_CHAR(v_ExtMethodIndex)|| ',N''' || v_ExtAppName || ''', N''' || v_ExtAppType || ''', N''startsWith'', NULL, NULL, 12, NULL)';
								EXECUTE IMMEDIATE 'INSERT INTO ExtMethodParamDefTable(PROCESSDEFID,EXTMETHODPARAMINDEX,EXTMETHODINDEX,PARAMETERNAME,PARAMETERTYPE,PARAMETERORDER,DATASTRUCTUREID,PARAMETERSCOPE,UNBOUNDED) VALUES(' || TO_CHAR(v_ProcessDefId) || ', 1,'  || TO_CHAR(v_ExtMethodIndex) ||  ', N''Param1'', 10, 1, NULL, NULL, N''N'')';
								EXECUTE IMMEDIATE 'INSERT INTO ExtMethodParamDefTable(PROCESSDEFID,EXTMETHODPARAMINDEX,EXTMETHODINDEX,PARAMETERNAME,PARAMETERTYPE,PARAMETERORDER,DATASTRUCTUREID,PARAMETERSCOPE,UNBOUNDED) VALUES(' || TO_CHAR(v_ProcessDefId)|| ', 2,' || TO_CHAR(v_ExtMethodIndex) || ', N''Param2'', 10, 2, NULL, NULL, N''N'')';
							COMMIT;
						END;
						END IF;

						v_ExtMethodIndex := v_ExtMethodIndex + 1;
						DECLARE 
						CURSOR cursor2 IS SELECT ExtMethodIndex FROM ExtMethodDefTable WHERE ProcessDefId = v_ProcessDefId AND ExtMethodName = N'stringLength' and ReturnType = 3;	
						BEGIN
							v_found := 0;
							OPEN cursor2;
							LOOP
								FETCH cursor2 INTO v_ExtMethodIndex1;
								EXIT WHEN cursor2%NOTFOUND;
								BEGIN
									v_found := 1;
									SELECT count(*) INTO v_count FROM ExtMethodParamDefTable where ProcessDefId = v_ProcessDefId and ExtMethodIndex = v_ExtMethodIndex1;	
									IF (v_count = 1) THEN 
									BEGIN
										BEGIN
											SELECT ParameterName INTO v_paramname1 FROM ExtMethodParamDefTable WHERE ProcessDefId = v_ProcessDefId and ExtMethodIndex = v_ExtMethodIndex1 and ParameterType = 10 AND ParameterName = 'Param1'; 
											EXCEPTION
												WHEN NO_DATA_FOUND THEN
													v_found := 0;	
										END;
									END;
									ELSE
										v_found := 0;	
									END IF;
									EXIT WHEN v_found = 1;
								END;
							END LOOP;
							CLOSE cursor2;
						END;

						IF v_found = 0 THEN
						BEGIN
							SAVEPOINT sys_catalog;
							
								v_ExtMethodIndex:=findMaxExtMethodIndex(v_ProcessDefId,v_ExtAppName,v_ExtAppType);
								
								EXECUTE IMMEDIATE 'INSERT INTO ExtMethodDefTable(ProcessDefId,ExtMethodIndex,ExtAppName,ExtAppType,ExtMethodName,SearchMethod,SearchCriteria,ReturnType,MappingFile) VALUES(' || TO_CHAR(v_ProcessDefId) || ',' || TO_CHAR(v_ExtMethodIndex)|| ',N''' || v_ExtAppName || ''', N''' || v_ExtAppType || ''', N''stringLength'', NULL, NULL, 3, NULL)';
								EXECUTE IMMEDIATE 'INSERT INTO ExtMethodParamDefTable(PROCESSDEFID,EXTMETHODPARAMINDEX,EXTMETHODINDEX,PARAMETERNAME,PARAMETERTYPE,PARAMETERORDER,DATASTRUCTUREID,PARAMETERSCOPE,UNBOUNDED) VALUES(' || TO_CHAR(v_ProcessDefId) || ', 1,'  || TO_CHAR(v_ExtMethodIndex) ||  ', N''Param1'', 10, 1, NULL, NULL, N''N'')';
							COMMIT;
						END;
						END IF;

						v_ExtMethodIndex := v_ExtMethodIndex + 1;
						DECLARE 
						CURSOR cursor2 IS SELECT ExtMethodIndex FROM ExtMethodDefTable WHERE ProcessDefId = v_ProcessDefId AND ExtMethodName = N'subString' and ReturnType = 10;	
						BEGIN
							v_found := 0;
							OPEN cursor2;
							LOOP
								FETCH cursor2 INTO v_ExtMethodIndex1;
								EXIT WHEN cursor2%NOTFOUND;
								BEGIN
									v_found := 1;
									SELECT count(*) INTO v_count FROM ExtMethodParamDefTable where ProcessDefId = v_ProcessDefId and ExtMethodIndex = v_ExtMethodIndex1;	
									IF (v_count = 3) THEN 
									BEGIN
										BEGIN
											SELECT ParameterName INTO v_paramname1 FROM ExtMethodParamDefTable WHERE ProcessDefId = v_ProcessDefId and ExtMethodIndex = v_ExtMethodIndex1 and ParameterType = 10 AND ParameterName = 'Param1'; 
											EXCEPTION
												WHEN NO_DATA_FOUND THEN
													v_found := 0;	
										END;
										BEGIN
											SELECT ParameterName INTO v_paramname2 FROM ExtMethodParamDefTable WHERE ProcessDefId = v_ProcessDefId and ExtMethodIndex = v_ExtMethodIndex1 and ParameterType = 3 AND ParameterName = 'Param2';
											EXCEPTION
												WHEN NO_DATA_FOUND THEN
													v_found := 0;		 
										END;
										BEGIN
											SELECT ParameterName INTO v_paramname3 FROM ExtMethodParamDefTable WHERE ProcessDefId = v_ProcessDefId and ExtMethodIndex = v_ExtMethodIndex1 and ParameterType = 3 AND ParameterName = 'Param3';
											EXCEPTION
												WHEN NO_DATA_FOUND THEN
													v_found := 0;		 
										END;
									END;
									ELSE
										v_found := 0;	
									END IF;
									EXIT WHEN v_found = 1;
								END;
							END LOOP;
							CLOSE cursor2;
						END;

						IF v_found = 0 THEN
						BEGIN
							SAVEPOINT sys_catalog;
							
								v_ExtMethodIndex:=findMaxExtMethodIndex(v_ProcessDefId,v_ExtAppName,v_ExtAppType);
								EXECUTE IMMEDIATE 'INSERT INTO ExtMethodDefTable(ProcessDefId,ExtMethodIndex,ExtAppName,ExtAppType,ExtMethodName,SearchMethod,SearchCriteria,ReturnType,MappingFile) VALUES(' || TO_CHAR(v_ProcessDefId) || ',' || TO_CHAR(v_ExtMethodIndex)|| ',N''' || v_ExtAppName || ''', N''' || v_ExtAppType || ''', N''subString'', NULL, NULL, 10, NULL)';
								EXECUTE IMMEDIATE 'INSERT INTO ExtMethodParamDefTable(PROCESSDEFID,EXTMETHODPARAMINDEX,EXTMETHODINDEX,PARAMETERNAME,PARAMETERTYPE,PARAMETERORDER,DATASTRUCTUREID,PARAMETERSCOPE,UNBOUNDED) VALUES(' || TO_CHAR(v_ProcessDefId) || ', 1,'  || TO_CHAR(v_ExtMethodIndex) ||  ', N''Param1'', 10, 1, NULL, NULL, N''N'')';
								EXECUTE IMMEDIATE 'INSERT INTO ExtMethodParamDefTable(PROCESSDEFID,EXTMETHODPARAMINDEX,EXTMETHODINDEX,PARAMETERNAME,PARAMETERTYPE,PARAMETERORDER,DATASTRUCTUREID,PARAMETERSCOPE,UNBOUNDED) VALUES(' || TO_CHAR(v_ProcessDefId)|| ', 2,' || TO_CHAR(v_ExtMethodIndex) || ', N''Param2'', 3, 2, NULL, NULL, N''N'')';
								EXECUTE IMMEDIATE 'INSERT INTO ExtMethodParamDefTable(PROCESSDEFID,EXTMETHODPARAMINDEX,EXTMETHODINDEX,PARAMETERNAME,PARAMETERTYPE,PARAMETERORDER,DATASTRUCTUREID,PARAMETERSCOPE,UNBOUNDED) VALUES(' || TO_CHAR(v_ProcessDefId)|| ', 3,' || TO_CHAR(v_ExtMethodIndex) || ', N''Param3'', 3, 3, NULL, NULL, N''N'')';
							COMMIT;
						END;
						END IF;

						v_ExtMethodIndex := v_ExtMethodIndex + 1;
						DECLARE 
						CURSOR cursor2 IS SELECT ExtMethodIndex FROM ExtMethodDefTable WHERE ProcessDefId = v_ProcessDefId AND ExtMethodName = N'subStringBefore' and ReturnType = 10;	
						BEGIN
							v_found := 0;
							OPEN cursor2;
							LOOP
								FETCH cursor2 INTO v_ExtMethodIndex1;
								EXIT WHEN cursor2%NOTFOUND;
								BEGIN
									v_found := 1;
									SELECT count(*) INTO v_count FROM ExtMethodParamDefTable where ProcessDefId = v_ProcessDefId and ExtMethodIndex = v_ExtMethodIndex1;	
									IF (v_count = 2) THEN 
									BEGIN
										BEGIN
											SELECT ParameterName INTO v_paramname1 FROM ExtMethodParamDefTable WHERE ProcessDefId = v_ProcessDefId and ExtMethodIndex = v_ExtMethodIndex1 and ParameterType = 10 AND ParameterName = 'Param1'; 
											EXCEPTION
												WHEN NO_DATA_FOUND THEN
													v_found := 0;	
										END;
										BEGIN
											SELECT ParameterName INTO v_paramname2 FROM ExtMethodParamDefTable WHERE ProcessDefId = v_ProcessDefId and ExtMethodIndex = v_ExtMethodIndex1 and ParameterType = 10 AND ParameterName = 'Param2';
											EXCEPTION
												WHEN NO_DATA_FOUND THEN
													v_found := 0;		 
										END;
									END;
									ELSE
										v_found := 0;	
									END IF;
									EXIT WHEN v_found = 1;
								END;
							END LOOP;
							CLOSE cursor2;
						END;

						IF v_found = 0 THEN
						BEGIN
							SAVEPOINT sys_catalog;
							
								v_ExtMethodIndex:=findMaxExtMethodIndex(v_ProcessDefId,v_ExtAppName,v_ExtAppType);
							
								EXECUTE IMMEDIATE 'INSERT INTO ExtMethodDefTable(ProcessDefId,ExtMethodIndex,ExtAppName,ExtAppType,ExtMethodName,SearchMethod,SearchCriteria,ReturnType,MappingFile) VALUES(' || TO_CHAR(v_ProcessDefId) || ',' || TO_CHAR(v_ExtMethodIndex)|| ',N''' || v_ExtAppName || ''', N''' || v_ExtAppType || ''', N''subStringBefore'', NULL, NULL, 10, NULL)';
								EXECUTE IMMEDIATE 'INSERT INTO ExtMethodParamDefTable(PROCESSDEFID,EXTMETHODPARAMINDEX,EXTMETHODINDEX,PARAMETERNAME,PARAMETERTYPE,PARAMETERORDER,DATASTRUCTUREID,PARAMETERSCOPE,UNBOUNDED) VALUES(' || TO_CHAR(v_ProcessDefId) || ', 1,'  || TO_CHAR(v_ExtMethodIndex) ||  ', N''Param1'', 10, 1, NULL, NULL, N''N'')';
								EXECUTE IMMEDIATE 'INSERT INTO ExtMethodParamDefTable(PROCESSDEFID,EXTMETHODPARAMINDEX,EXTMETHODINDEX,PARAMETERNAME,PARAMETERTYPE,PARAMETERORDER,DATASTRUCTUREID,PARAMETERSCOPE,UNBOUNDED) VALUES(' || TO_CHAR(v_ProcessDefId)|| ', 2,' || TO_CHAR(v_ExtMethodIndex) || ', N''Param2'', 10, 2, NULL, NULL, N''N'')';
							COMMIT;
						END;
						END IF;

						v_ExtMethodIndex := v_ExtMethodIndex + 1;
						DECLARE 
						CURSOR cursor2 IS SELECT ExtMethodIndex FROM ExtMethodDefTable WHERE ProcessDefId = v_ProcessDefId AND ExtMethodName = N'subStringAfter' and ReturnType = 10;	
						BEGIN
							v_found := 0;
							OPEN cursor2;
							LOOP
								FETCH cursor2 INTO v_ExtMethodIndex1;
								EXIT WHEN cursor2%NOTFOUND;
								BEGIN
									v_found := 1;
									SELECT count(*) INTO v_count FROM ExtMethodParamDefTable where ProcessDefId = v_ProcessDefId and ExtMethodIndex = v_ExtMethodIndex1;	
									IF (v_count = 2) THEN 
									BEGIN
										BEGIN
											SELECT ParameterName INTO v_paramname1 FROM ExtMethodParamDefTable WHERE ProcessDefId = v_ProcessDefId and ExtMethodIndex = v_ExtMethodIndex1 and ParameterType = 10 AND ParameterName = 'Param1'; 
											EXCEPTION
												WHEN NO_DATA_FOUND THEN
													v_found := 0;	
										END;
										BEGIN
											SELECT ParameterName INTO v_paramname2 FROM ExtMethodParamDefTable WHERE ProcessDefId = v_ProcessDefId and ExtMethodIndex = v_ExtMethodIndex1 and ParameterType = 10 AND ParameterName = 'Param2';
											EXCEPTION
												WHEN NO_DATA_FOUND THEN
													v_found := 0;		 
										END;
									END;
									ELSE
										v_found := 0;	
									END IF;
									EXIT WHEN v_found = 1;
								END;
							END LOOP;
							CLOSE cursor2;
						END;

						IF v_found = 0 THEN
						BEGIN
							SAVEPOINT sys_catalog;
								
								v_ExtMethodIndex:=findMaxExtMethodIndex(v_ProcessDefId,v_ExtAppName,v_ExtAppType);
							
								EXECUTE IMMEDIATE 'INSERT INTO ExtMethodDefTable(ProcessDefId,ExtMethodIndex,ExtAppName,ExtAppType,ExtMethodName,SearchMethod,SearchCriteria,ReturnType,MappingFile) VALUES(' || TO_CHAR(v_ProcessDefId) || ',' || TO_CHAR(v_ExtMethodIndex)|| ',N''' || v_ExtAppName || ''', N''' || v_ExtAppType || ''', N''subStringAfter'', NULL, NULL, 10, NULL)';
								EXECUTE IMMEDIATE 'INSERT INTO ExtMethodParamDefTable(PROCESSDEFID,EXTMETHODPARAMINDEX,EXTMETHODINDEX,PARAMETERNAME,PARAMETERTYPE,PARAMETERORDER,DATASTRUCTUREID,PARAMETERSCOPE,UNBOUNDED) VALUES(' || TO_CHAR(v_ProcessDefId) || ', 1,'  || TO_CHAR(v_ExtMethodIndex) ||  ', N''Param1'', 10, 1, NULL, NULL, N''N'')';
								EXECUTE IMMEDIATE 'INSERT INTO ExtMethodParamDefTable(PROCESSDEFID,EXTMETHODPARAMINDEX,EXTMETHODINDEX,PARAMETERNAME,PARAMETERTYPE,PARAMETERORDER,DATASTRUCTUREID,PARAMETERSCOPE,UNBOUNDED) VALUES(' || TO_CHAR(v_ProcessDefId)|| ', 2,' || TO_CHAR(v_ExtMethodIndex) || ', N''Param2'', 10, 2, NULL, NULL, N''N'')';
							COMMIT;
						END;
						END IF;

						v_ExtMethodIndex := v_ExtMethodIndex + 1;
						DECLARE 
						CURSOR cursor2 IS SELECT ExtMethodIndex FROM ExtMethodDefTable WHERE ProcessDefId = v_ProcessDefId AND ExtMethodName = N'translate' and ReturnType = 10;	
						BEGIN
							v_found := 0;
							OPEN cursor2;
							LOOP
								FETCH cursor2 INTO v_ExtMethodIndex1;
								EXIT WHEN cursor2%NOTFOUND;
								BEGIN
									v_found := 1;
									SELECT count(*) INTO v_count FROM ExtMethodParamDefTable where ProcessDefId = v_ProcessDefId and ExtMethodIndex = v_ExtMethodIndex1;	
									IF (v_count = 3) THEN 
									BEGIN
										BEGIN
											SELECT ParameterName INTO v_paramname1 FROM ExtMethodParamDefTable WHERE ProcessDefId = v_ProcessDefId and ExtMethodIndex = v_ExtMethodIndex1 and ParameterType = 10 AND ParameterName = 'Param1'; 
											EXCEPTION
												WHEN NO_DATA_FOUND THEN
													v_found := 0;	
										END;
										BEGIN
											SELECT ParameterName INTO v_paramname2 FROM ExtMethodParamDefTable WHERE ProcessDefId = v_ProcessDefId and ExtMethodIndex = v_ExtMethodIndex1 and ParameterType = 10 AND ParameterName = 'Param2';
											EXCEPTION
												WHEN NO_DATA_FOUND THEN
													v_found := 0;		 
										END;
										BEGIN
											SELECT ParameterName INTO v_paramname3 FROM ExtMethodParamDefTable WHERE ProcessDefId = v_ProcessDefId and ExtMethodIndex = v_ExtMethodIndex1 and ParameterType = 10 AND ParameterName = 'Param3';
											EXCEPTION
												WHEN NO_DATA_FOUND THEN
													v_found := 0;		 
										END;
									END;
									ELSE
										v_found := 0;	
									END IF;
									EXIT WHEN v_found = 1;
								END;
							END LOOP;
							CLOSE cursor2;
						END;

						IF v_found = 0 THEN
						BEGIN
							SAVEPOINT sys_catalog;
							
								v_ExtMethodIndex:=findMaxExtMethodIndex(v_ProcessDefId,v_ExtAppName,v_ExtAppType);
								EXECUTE IMMEDIATE 'INSERT INTO ExtMethodDefTable(ProcessDefId,ExtMethodIndex,ExtAppName,ExtAppType,ExtMethodName,SearchMethod,SearchCriteria,ReturnType,MappingFile) VALUES(' || TO_CHAR(v_ProcessDefId) || ',' || TO_CHAR(v_ExtMethodIndex)|| ',N''' || v_ExtAppName || ''', N''' || v_ExtAppType || ''', N''translate'', NULL, NULL, 10, NULL)';
								EXECUTE IMMEDIATE 'INSERT INTO ExtMethodParamDefTable(PROCESSDEFID,EXTMETHODPARAMINDEX,EXTMETHODINDEX,PARAMETERNAME,PARAMETERTYPE,PARAMETERORDER,DATASTRUCTUREID,PARAMETERSCOPE,UNBOUNDED) VALUES(' || TO_CHAR(v_ProcessDefId) || ', 1,'  || TO_CHAR(v_ExtMethodIndex) ||  ', N''Param1'', 10, 1, NULL, NULL, N''N'')';
								EXECUTE IMMEDIATE 'INSERT INTO ExtMethodParamDefTable(PROCESSDEFID,EXTMETHODPARAMINDEX,EXTMETHODINDEX,PARAMETERNAME,PARAMETERTYPE,PARAMETERORDER,DATASTRUCTUREID,PARAMETERSCOPE,UNBOUNDED) VALUES(' || TO_CHAR(v_ProcessDefId)|| ', 2,' || TO_CHAR(v_ExtMethodIndex) || ', N''Param2'', 10, 2, NULL, NULL, N''N'')';
								EXECUTE IMMEDIATE 'INSERT INTO ExtMethodParamDefTable(PROCESSDEFID,EXTMETHODPARAMINDEX,EXTMETHODINDEX,PARAMETERNAME,PARAMETERTYPE,PARAMETERORDER,DATASTRUCTUREID,PARAMETERSCOPE,UNBOUNDED) VALUES(' || TO_CHAR(v_ProcessDefId)|| ', 3,' || TO_CHAR(v_ExtMethodIndex) || ', N''Param3'', 10, 3, NULL, NULL, N''N'')';
							COMMIT;
						END;
						END IF;

						v_ExtMethodIndex := v_ExtMethodIndex + 1;
						DECLARE 
						CURSOR cursor2 IS SELECT ExtMethodIndex FROM ExtMethodDefTable WHERE ProcessDefId = v_ProcessDefId AND ExtMethodName = N'concat' and ReturnType = 10;	
						BEGIN
							v_found := 0;
							OPEN cursor2;
							LOOP
								FETCH cursor2 INTO v_ExtMethodIndex1;
								EXIT WHEN cursor2%NOTFOUND;
								BEGIN
									v_found := 1;
									SELECT count(*) INTO v_count FROM ExtMethodParamDefTable where ProcessDefId = v_ProcessDefId and ExtMethodIndex = v_ExtMethodIndex1;	
									IF (v_count = 2) THEN 
									BEGIN
										BEGIN
											SELECT ParameterName INTO v_paramname1 FROM ExtMethodParamDefTable WHERE ProcessDefId = v_ProcessDefId and ExtMethodIndex = v_ExtMethodIndex1 and ParameterType = 10 AND ParameterName = 'Param1'; 
											EXCEPTION
												WHEN NO_DATA_FOUND THEN
													v_found := 0;	
										END;
										BEGIN
											SELECT ParameterName INTO v_paramname2 FROM ExtMethodParamDefTable WHERE ProcessDefId = v_ProcessDefId and ExtMethodIndex = v_ExtMethodIndex1 and ParameterType = 10 AND ParameterName = 'Param2';
											EXCEPTION
												WHEN NO_DATA_FOUND THEN
													v_found := 0;		 
										END;
									END;
									ELSE
										v_found := 0;	
									END IF;
									EXIT WHEN v_found = 1;
								END;
							END LOOP;
							CLOSE cursor2;
						END;

						IF v_found = 0 THEN
						BEGIN
							SAVEPOINT sys_catalog;
							
								v_ExtMethodIndex:=findMaxExtMethodIndex(v_ProcessDefId,v_ExtAppName,v_ExtAppType);
								EXECUTE IMMEDIATE 'INSERT INTO ExtMethodDefTable(ProcessDefId,ExtMethodIndex,ExtAppName,ExtAppType,ExtMethodName,SearchMethod,SearchCriteria,ReturnType,MappingFile) VALUES(' || TO_CHAR(v_ProcessDefId) || ',' || TO_CHAR(v_ExtMethodIndex)|| ',N''' || v_ExtAppName || ''', N''' || v_ExtAppType || ''', N''concat'', NULL, NULL, 10, NULL)';
								EXECUTE IMMEDIATE 'INSERT INTO ExtMethodParamDefTable(PROCESSDEFID,EXTMETHODPARAMINDEX,EXTMETHODINDEX,PARAMETERNAME,PARAMETERTYPE,PARAMETERORDER,DATASTRUCTUREID,PARAMETERSCOPE,UNBOUNDED) VALUES(' || TO_CHAR(v_ProcessDefId) || ', 1,'  || TO_CHAR(v_ExtMethodIndex) ||  ', N''Param1'', 10, 1, NULL, NULL, N''N'')';
								EXECUTE IMMEDIATE 'INSERT INTO ExtMethodParamDefTable(PROCESSDEFID,EXTMETHODPARAMINDEX,EXTMETHODINDEX,PARAMETERNAME,PARAMETERTYPE,PARAMETERORDER,DATASTRUCTUREID,PARAMETERSCOPE,UNBOUNDED) VALUES(' || TO_CHAR(v_ProcessDefId)|| ', 2,' || TO_CHAR(v_ExtMethodIndex) || ', N''Param2'', 10, 2, NULL, NULL, N''N'')';
							COMMIT;
						END;
						END IF;

						v_ExtMethodIndex := v_ExtMethodIndex + 1;
						DECLARE 
						CURSOR cursor2 IS SELECT ExtMethodIndex FROM ExtMethodDefTable WHERE ProcessDefId = v_ProcessDefId AND ExtMethodName = N'numberValue' and ReturnType = 6;	
						BEGIN
							v_found := 0;
							OPEN cursor2;
							LOOP
								FETCH cursor2 INTO v_ExtMethodIndex1;
								EXIT WHEN cursor2%NOTFOUND;
								BEGIN
									v_found := 1;
									SELECT count(*) INTO v_count FROM ExtMethodParamDefTable where ProcessDefId = v_ProcessDefId and ExtMethodIndex = v_ExtMethodIndex1;	
									IF (v_count = 1) THEN 
									BEGIN
										BEGIN
											SELECT ParameterName INTO v_paramname1 FROM ExtMethodParamDefTable WHERE ProcessDefId = v_ProcessDefId and ExtMethodIndex = v_ExtMethodIndex1 and ParameterType = 10 AND ParameterName = 'Param1'; 
											EXCEPTION
												WHEN NO_DATA_FOUND THEN
													v_found := 0;	
										END;
									END;
									ELSE
										v_found := 0;	
									END IF;
									EXIT WHEN v_found = 1;
								END;
							END LOOP;
							CLOSE cursor2;
						END;

						IF v_found = 0 THEN
						BEGIN
							SAVEPOINT sys_catalog;
								v_ExtMethodIndex:=findMaxExtMethodIndex(v_ProcessDefId,v_ExtAppName,v_ExtAppType);
							
								EXECUTE IMMEDIATE 'INSERT INTO ExtMethodDefTable(ProcessDefId,ExtMethodIndex,ExtAppName,ExtAppType,ExtMethodName,SearchMethod,SearchCriteria,ReturnType,MappingFile) VALUES(' || TO_CHAR(v_ProcessDefId) || ',' || TO_CHAR(v_ExtMethodIndex)|| ',N''' || v_ExtAppName || ''', N''' || v_ExtAppType || ''', N''numberValue'', NULL, NULL, 6, NULL)';
								EXECUTE IMMEDIATE 'INSERT INTO ExtMethodParamDefTable(PROCESSDEFID,EXTMETHODPARAMINDEX,EXTMETHODINDEX,PARAMETERNAME,PARAMETERTYPE,PARAMETERORDER,DATASTRUCTUREID,PARAMETERSCOPE,UNBOUNDED) VALUES(' || TO_CHAR(v_ProcessDefId) || ', 1,'  || TO_CHAR(v_ExtMethodIndex) ||  ', N''Param1'', 10, 1, NULL, NULL, N''N'')';
							COMMIT;
						END;
						END IF;

						v_ExtMethodIndex := v_ExtMethodIndex + 1;
						DECLARE 
						CURSOR cursor2 IS SELECT ExtMethodIndex FROM ExtMethodDefTable WHERE ProcessDefId = v_ProcessDefId AND ExtMethodName = N'numberValue' and ReturnType = 6;	
						BEGIN
							v_found := 0;
							OPEN cursor2;
							LOOP
								FETCH cursor2 INTO v_ExtMethodIndex1;
								EXIT WHEN cursor2%NOTFOUND;
								BEGIN
									v_found := 1;
									SELECT count(*) INTO v_count FROM ExtMethodParamDefTable where ProcessDefId = v_ProcessDefId and ExtMethodIndex = v_ExtMethodIndex1;	
									IF (v_count = 1) THEN 
									BEGIN
										BEGIN
											SELECT ParameterName INTO v_paramname1 FROM ExtMethodParamDefTable WHERE ProcessDefId = v_ProcessDefId and ExtMethodIndex = v_ExtMethodIndex1 and ParameterType = 6 AND ParameterName = 'Param1'; 
											EXCEPTION
												WHEN NO_DATA_FOUND THEN
													v_found := 0;	
										END;
									END;
									ELSE
										v_found := 0;	
									END IF;
									EXIT WHEN v_found = 1;
								END;
							END LOOP;
							CLOSE cursor2;
						END;

						IF v_found = 0 THEN
						BEGIN
							SAVEPOINT sys_catalog;
								v_ExtMethodIndex:=findMaxExtMethodIndex(v_ProcessDefId,v_ExtAppName,v_ExtAppType);
							
								EXECUTE IMMEDIATE 'INSERT INTO ExtMethodDefTable(ProcessDefId,ExtMethodIndex,ExtAppName,ExtAppType,ExtMethodName,SearchMethod,SearchCriteria,ReturnType,MappingFile) VALUES(' || TO_CHAR(v_ProcessDefId) || ',' || TO_CHAR(v_ExtMethodIndex)|| ',N''' || v_ExtAppName || ''', N''' || v_ExtAppType || ''', N''numberValue'', NULL, NULL, 6, NULL)';
								EXECUTE IMMEDIATE 'INSERT INTO ExtMethodParamDefTable(PROCESSDEFID,EXTMETHODPARAMINDEX,EXTMETHODINDEX,PARAMETERNAME,PARAMETERTYPE,PARAMETERORDER,DATASTRUCTUREID,PARAMETERSCOPE,UNBOUNDED) VALUES(' || TO_CHAR(v_ProcessDefId) || ', 1,'  || TO_CHAR(v_ExtMethodIndex) ||  ', N''Param1'', 6, 1, NULL, NULL, N''N'')';
							COMMIT;
						END;
						END IF;

						v_ExtMethodIndex := v_ExtMethodIndex + 1;
						DECLARE 
						CURSOR cursor2 IS SELECT ExtMethodIndex FROM ExtMethodDefTable WHERE ProcessDefId = v_ProcessDefId AND ExtMethodName = N'numberValue' and ReturnType = 6;	
						BEGIN
							v_found := 0;
							OPEN cursor2;
							LOOP
								FETCH cursor2 INTO v_ExtMethodIndex1;
								EXIT WHEN cursor2%NOTFOUND;
								BEGIN
									v_found := 1;
									SELECT count(*) INTO v_count FROM ExtMethodParamDefTable where ProcessDefId = v_ProcessDefId and ExtMethodIndex = v_ExtMethodIndex1;	
									IF (v_count = 1) THEN 
									BEGIN
										BEGIN
											SELECT ParameterName INTO v_paramname1 FROM ExtMethodParamDefTable WHERE ProcessDefId = v_ProcessDefId and ExtMethodIndex = v_ExtMethodIndex1 and ParameterType = 4 AND ParameterName = 'Param1'; 
											EXCEPTION
												WHEN NO_DATA_FOUND THEN
													v_found := 0;	
										END;
									END;
									ELSE
										v_found := 0;	
									END IF;
									EXIT WHEN v_found = 1;
								END;
							END LOOP;
							CLOSE cursor2;
						END;

						IF v_found = 0 THEN
						BEGIN
							SAVEPOINT sys_catalog;
							
								v_ExtMethodIndex:=findMaxExtMethodIndex(v_ProcessDefId,v_ExtAppName,v_ExtAppType);
								EXECUTE IMMEDIATE 'INSERT INTO ExtMethodDefTable(ProcessDefId,ExtMethodIndex,ExtAppName,ExtAppType,ExtMethodName,SearchMethod,SearchCriteria,ReturnType,MappingFile) VALUES(' || TO_CHAR(v_ProcessDefId) || ',' || TO_CHAR(v_ExtMethodIndex)|| ',N''' || v_ExtAppName || ''', N''' || v_ExtAppType || ''', N''numberValue'', NULL, NULL, 6, NULL)';
								EXECUTE IMMEDIATE 'INSERT INTO ExtMethodParamDefTable(PROCESSDEFID,EXTMETHODPARAMINDEX,EXTMETHODINDEX,PARAMETERNAME,PARAMETERTYPE,PARAMETERORDER,DATASTRUCTUREID,PARAMETERSCOPE,UNBOUNDED) VALUES(' || TO_CHAR(v_ProcessDefId) || ', 1,'  || TO_CHAR(v_ExtMethodIndex) ||  ', N''Param1'', 4, 1, NULL, NULL, N''N'')';
							COMMIT;
						END;
						END IF;

						v_ExtMethodIndex := v_ExtMethodIndex + 1;
						DECLARE 
						CURSOR cursor2 IS SELECT ExtMethodIndex FROM ExtMethodDefTable WHERE ProcessDefId = v_ProcessDefId AND ExtMethodName = N'numberValue' and ReturnType = 6;	
						BEGIN
							v_found := 0;
							OPEN cursor2;
							LOOP
								FETCH cursor2 INTO v_ExtMethodIndex1;
								EXIT WHEN cursor2%NOTFOUND;
								BEGIN
									v_found := 1;
									SELECT count(*) INTO v_count FROM ExtMethodParamDefTable where ProcessDefId = v_ProcessDefId and ExtMethodIndex = v_ExtMethodIndex1;	
									IF (v_count = 1) THEN 
									BEGIN
										BEGIN
											SELECT ParameterName INTO v_paramname1 FROM ExtMethodParamDefTable WHERE ProcessDefId = v_ProcessDefId and ExtMethodIndex = v_ExtMethodIndex1 and ParameterType = 3 AND ParameterName = 'Param1'; 
											EXCEPTION
												WHEN NO_DATA_FOUND THEN
													v_found := 0;	
										END;
									END;
									ELSE
										v_found := 0;	
									END IF;
									EXIT WHEN v_found = 1;
								END;
							END LOOP;
							CLOSE cursor2;
						END;

						IF v_found = 0 THEN
						BEGIN
							SAVEPOINT sys_catalog;
							
								v_ExtMethodIndex:=findMaxExtMethodIndex(v_ProcessDefId,v_ExtAppName,v_ExtAppType);
								
								EXECUTE IMMEDIATE 'INSERT INTO ExtMethodDefTable(ProcessDefId,ExtMethodIndex,ExtAppName,ExtAppType,ExtMethodName,SearchMethod,SearchCriteria,ReturnType,MappingFile) VALUES(' || TO_CHAR(v_ProcessDefId) || ',' || TO_CHAR(v_ExtMethodIndex)|| ',N''' || v_ExtAppName || ''', N''' || v_ExtAppType || ''', N''numberValue'', NULL, NULL, 6, NULL)';
								EXECUTE IMMEDIATE 'INSERT INTO ExtMethodParamDefTable(PROCESSDEFID,EXTMETHODPARAMINDEX,EXTMETHODINDEX,PARAMETERNAME,PARAMETERTYPE,PARAMETERORDER,DATASTRUCTUREID,PARAMETERSCOPE,UNBOUNDED) VALUES(' || TO_CHAR(v_ProcessDefId) || ', 1,'  || TO_CHAR(v_ExtMethodIndex) ||  ', N''Param1'', 3, 1, NULL, NULL, N''N'')';
							COMMIT;
						END;
						END IF;

						v_ExtMethodIndex := v_ExtMethodIndex + 1;
						DECLARE 
						CURSOR cursor2 IS SELECT ExtMethodIndex FROM ExtMethodDefTable WHERE ProcessDefId = v_ProcessDefId AND ExtMethodName = N'numberValue' and ReturnType = 6;	
						BEGIN
							v_found := 0;
							OPEN cursor2;
							LOOP
								FETCH cursor2 INTO v_ExtMethodIndex1;
								EXIT WHEN cursor2%NOTFOUND;
								BEGIN
									v_found := 1;
									SELECT count(*) INTO v_count FROM ExtMethodParamDefTable where ProcessDefId = v_ProcessDefId and ExtMethodIndex = v_ExtMethodIndex1;	
									IF (v_count = 1) THEN 
									BEGIN
										BEGIN
											SELECT ParameterName INTO v_paramname1 FROM ExtMethodParamDefTable WHERE ProcessDefId = v_ProcessDefId and ExtMethodIndex = v_ExtMethodIndex1 and ParameterType = 12 AND ParameterName = 'Param1'; 
											EXCEPTION
												WHEN NO_DATA_FOUND THEN
													v_found := 0;	
										END;
									END;
									ELSE
										v_found := 0;	
									END IF;
									EXIT WHEN v_found = 1;
								END;
							END LOOP;
							CLOSE cursor2;
						END;

						IF v_found = 0 THEN
						BEGIN
							SAVEPOINT sys_catalog;
							
								v_ExtMethodIndex:=findMaxExtMethodIndex(v_ProcessDefId,v_ExtAppName,v_ExtAppType);
								EXECUTE IMMEDIATE 'INSERT INTO ExtMethodDefTable(ProcessDefId,ExtMethodIndex,ExtAppName,ExtAppType,ExtMethodName,SearchMethod,SearchCriteria,ReturnType,MappingFile) VALUES(' || TO_CHAR(v_ProcessDefId) || ',' || TO_CHAR(v_ExtMethodIndex)|| ',N''' || v_ExtAppName || ''', N''' || v_ExtAppType || ''', N''numberValue'', NULL, NULL, 6, NULL)';
								EXECUTE IMMEDIATE 'INSERT INTO ExtMethodParamDefTable(PROCESSDEFID,EXTMETHODPARAMINDEX,EXTMETHODINDEX,PARAMETERNAME,PARAMETERTYPE,PARAMETERORDER,DATASTRUCTUREID,PARAMETERSCOPE,UNBOUNDED) VALUES(' || TO_CHAR(v_ProcessDefId) || ', 1,'  || TO_CHAR(v_ExtMethodIndex) ||  ', N''Param1'', 12, 1, NULL, NULL, N''N'')';
							COMMIT;
						END;
						END IF;

						v_ExtMethodIndex := v_ExtMethodIndex + 1;
						DECLARE 
						CURSOR cursor2 IS SELECT ExtMethodIndex FROM ExtMethodDefTable WHERE ProcessDefId = v_ProcessDefId AND ExtMethodName = N'round' and ReturnType = 4;	
						BEGIN
							v_found := 0;
							OPEN cursor2;
							LOOP
								FETCH cursor2 INTO v_ExtMethodIndex1;
								EXIT WHEN cursor2%NOTFOUND;
								BEGIN
									v_found := 1;
									SELECT count(*) INTO v_count FROM ExtMethodParamDefTable where ProcessDefId = v_ProcessDefId and ExtMethodIndex = v_ExtMethodIndex1;	
									IF (v_count = 1) THEN 
									BEGIN
										BEGIN
											SELECT ParameterName INTO v_paramname1 FROM ExtMethodParamDefTable WHERE ProcessDefId = v_ProcessDefId and ExtMethodIndex = v_ExtMethodIndex1 and ParameterType = 6 AND ParameterName = 'Param1'; 
											EXCEPTION
												WHEN NO_DATA_FOUND THEN
													v_found := 0;	
										END;
									END;
									ELSE
										v_found := 0;	
									END IF;
									EXIT WHEN v_found = 1;
								END;
							END LOOP;
							CLOSE cursor2;
						END;

						IF v_found = 0 THEN
						BEGIN
							SAVEPOINT sys_catalog;
							
								v_ExtMethodIndex:=findMaxExtMethodIndex(v_ProcessDefId,v_ExtAppName,v_ExtAppType);
								EXECUTE IMMEDIATE 'INSERT INTO ExtMethodDefTable(ProcessDefId,ExtMethodIndex,ExtAppName,ExtAppType,ExtMethodName,SearchMethod,SearchCriteria,ReturnType,MappingFile) VALUES(' || TO_CHAR(v_ProcessDefId) || ',' || TO_CHAR(v_ExtMethodIndex)|| ',N''' || v_ExtAppName || ''', N''' || v_ExtAppType || ''', N''round'', NULL, NULL, 4, NULL)';
								EXECUTE IMMEDIATE 'INSERT INTO ExtMethodParamDefTable(PROCESSDEFID,EXTMETHODPARAMINDEX,EXTMETHODINDEX,PARAMETERNAME,PARAMETERTYPE,PARAMETERORDER,DATASTRUCTUREID,PARAMETERSCOPE,UNBOUNDED) VALUES(' || TO_CHAR(v_ProcessDefId) || ', 1,'  || TO_CHAR(v_ExtMethodIndex) ||  ', N''Param1'', 6, 1, NULL, NULL, N''N'')';
							COMMIT;
						END;
						END IF;

						v_ExtMethodIndex := v_ExtMethodIndex + 1;
						DECLARE 
						CURSOR cursor2 IS SELECT ExtMethodIndex FROM ExtMethodDefTable WHERE ProcessDefId = v_ProcessDefId AND ExtMethodName = N'floor' and ReturnType = 4;	
						BEGIN
							v_found := 0;
							OPEN cursor2;
							LOOP
								FETCH cursor2 INTO v_ExtMethodIndex1;
								EXIT WHEN cursor2%NOTFOUND;
								BEGIN
									v_found := 1;
									SELECT count(*) INTO v_count FROM ExtMethodParamDefTable where ProcessDefId = v_ProcessDefId and ExtMethodIndex = v_ExtMethodIndex1;	
									IF (v_count = 1) THEN 
									BEGIN
										BEGIN
											SELECT ParameterName INTO v_paramname1 FROM ExtMethodParamDefTable WHERE ProcessDefId = v_ProcessDefId and ExtMethodIndex = v_ExtMethodIndex1 and ParameterType = 6 AND ParameterName = 'Param1'; 
											EXCEPTION
												WHEN NO_DATA_FOUND THEN
													v_found := 0;	
										END;
									END;
									ELSE
										v_found := 0;	
									END IF;
									EXIT WHEN v_found = 1;
								END;
							END LOOP;
							CLOSE cursor2;
						END;

						IF v_found = 0 THEN
						BEGIN
							SAVEPOINT sys_catalog;
							
								v_ExtMethodIndex:=findMaxExtMethodIndex(v_ProcessDefId,v_ExtAppName,v_ExtAppType);
								EXECUTE IMMEDIATE 'INSERT INTO ExtMethodDefTable(ProcessDefId,ExtMethodIndex,ExtAppName,ExtAppType,ExtMethodName,SearchMethod,SearchCriteria,ReturnType,MappingFile) VALUES(' || TO_CHAR(v_ProcessDefId) || ',' || TO_CHAR(v_ExtMethodIndex)|| ',N''' || v_ExtAppName || ''', N''' || v_ExtAppType || ''', N''floor'', NULL, NULL, 4, NULL)';
								EXECUTE IMMEDIATE 'INSERT INTO ExtMethodParamDefTable(PROCESSDEFID,EXTMETHODPARAMINDEX,EXTMETHODINDEX,PARAMETERNAME,PARAMETERTYPE,PARAMETERORDER,DATASTRUCTUREID,PARAMETERSCOPE,UNBOUNDED) VALUES(' || TO_CHAR(v_ProcessDefId) || ', 1,'  || TO_CHAR(v_ExtMethodIndex) ||  ', N''Param1'', 6, 1, NULL, NULL, N''N'')';
							COMMIT;
						END;
						END IF;

						v_ExtMethodIndex := v_ExtMethodIndex + 1;
						DECLARE 
						CURSOR cursor2 IS SELECT ExtMethodIndex FROM ExtMethodDefTable WHERE ProcessDefId = v_ProcessDefId AND ExtMethodName = N'ceiling' and ReturnType = 4;	
						BEGIN
							v_found := 0;
							OPEN cursor2;
							LOOP
								FETCH cursor2 INTO v_ExtMethodIndex1;
								EXIT WHEN cursor2%NOTFOUND;
								BEGIN
									v_found := 1;
									SELECT count(*) INTO v_count FROM ExtMethodParamDefTable where ProcessDefId = v_ProcessDefId and ExtMethodIndex = v_ExtMethodIndex1;	
									IF (v_count = 1) THEN 
									BEGIN
										BEGIN
											SELECT ParameterName INTO v_paramname1 FROM ExtMethodParamDefTable WHERE ProcessDefId = v_ProcessDefId and ExtMethodIndex = v_ExtMethodIndex1 and ParameterType = 6 AND ParameterName = 'Param1'; 
											EXCEPTION
												WHEN NO_DATA_FOUND THEN
													v_found := 0;	
										END;
									END;
									ELSE
										v_found := 0;	
									END IF;
									EXIT WHEN v_found = 1;
								END;
							END LOOP;
							CLOSE cursor2;
						END;

						IF v_found = 0 THEN
						BEGIN
							SAVEPOINT sys_catalog;
							
								v_ExtMethodIndex:=findMaxExtMethodIndex(v_ProcessDefId,v_ExtAppName,v_ExtAppType);
								EXECUTE IMMEDIATE 'INSERT INTO ExtMethodDefTable(ProcessDefId,ExtMethodIndex,ExtAppName,ExtAppType,ExtMethodName,SearchMethod,SearchCriteria,ReturnType,MappingFile) VALUES(' || TO_CHAR(v_ProcessDefId) || ',' || TO_CHAR(v_ExtMethodIndex)|| ',N''' || v_ExtAppName || ''', N''' || v_ExtAppType || ''', N''ceiling'', NULL, NULL, 4, NULL)';
								EXECUTE IMMEDIATE 'INSERT INTO ExtMethodParamDefTable(PROCESSDEFID,EXTMETHODPARAMINDEX,EXTMETHODINDEX,PARAMETERNAME,PARAMETERTYPE,PARAMETERORDER,DATASTRUCTUREID,PARAMETERSCOPE,UNBOUNDED) VALUES(' || TO_CHAR(v_ProcessDefId) || ', 1,'  || TO_CHAR(v_ExtMethodIndex) ||  ', N''Param1'', 6, 1, NULL, NULL, N''N'')';
							COMMIT;
						END;
						END IF;

						v_ExtMethodIndex := v_ExtMethodIndex + 1;
						v_found := 1;
						BEGIN
							SELECT ExtMethodIndex INTO v_ExtMethodIndex1 FROM ExtMethodDefTable WHERE ProcessDefId = v_ProcessDefId AND ExtMethodName = N'getCurrentDate' and ReturnType = 15;	
							EXCEPTION
								WHEN NO_DATA_FOUND THEN
									v_found := 0;
						END;
						IF v_found = 0 THEN
							
							v_ExtMethodIndex:=findMaxExtMethodIndex(v_ProcessDefId,v_ExtAppName,v_ExtAppType);
						
							EXECUTE IMMEDIATE 'INSERT INTO ExtMethodDefTable(ProcessDefId,ExtMethodIndex,ExtAppName,ExtAppType,ExtMethodName,SearchMethod,SearchCriteria,ReturnType,MappingFile) VALUES(' || TO_CHAR(v_ProcessDefId) || ',' || TO_CHAR(v_ExtMethodIndex)|| ',N''' || v_ExtAppName || ''', N''' || v_ExtAppType || ''', N''getCurrentDate'', NULL, NULL, 15, NULL)';
						END IF;

						v_ExtMethodIndex := v_ExtMethodIndex + 1;
						v_found := 1;
						BEGIN
							SELECT ExtMethodIndex INTO v_ExtMethodIndex1 FROM ExtMethodDefTable WHERE ProcessDefId = v_ProcessDefId AND ExtMethodName = N'getCurrentTime' and ReturnType = 16;	
							EXCEPTION
								WHEN NO_DATA_FOUND THEN
									v_found := 0;
						END;

						IF v_found = 0 THEN
						
							v_ExtMethodIndex:=findMaxExtMethodIndex(v_ProcessDefId,v_ExtAppName,v_ExtAppType);
							EXECUTE IMMEDIATE 'INSERT INTO ExtMethodDefTable(ProcessDefId,ExtMethodIndex,ExtAppName,ExtAppType,ExtMethodName,SearchMethod,SearchCriteria,ReturnType,MappingFile) VALUES(' || TO_CHAR(v_ProcessDefId) || ',' || TO_CHAR(v_ExtMethodIndex)|| ',N''' || v_ExtAppName || ''', N''' || v_ExtAppType || ''', N''getCurrentTime'', NULL, NULL, 16, NULL)';
						END IF;

						v_ExtMethodIndex := v_ExtMethodIndex + 1;
						v_found := 1;
						BEGIN
							SELECT ExtMethodIndex INTO v_ExtMethodIndex1 FROM ExtMethodDefTable WHERE ProcessDefId = v_ProcessDefId AND ExtMethodName = N'getCurrentDateTime' and ReturnType = 8;	
							EXCEPTION
								WHEN NO_DATA_FOUND THEN
									v_found := 0;
						END;

						IF v_found = 0 THEN
							v_ExtMethodIndex:=findMaxExtMethodIndex(v_ProcessDefId,v_ExtAppName,v_ExtAppType);
						
							EXECUTE IMMEDIATE 'INSERT INTO ExtMethodDefTable(ProcessDefId,ExtMethodIndex,ExtAppName,ExtAppType,ExtMethodName,SearchMethod,SearchCriteria,ReturnType,MappingFile) VALUES(' || TO_CHAR(v_ProcessDefId) || ',' || TO_CHAR(v_ExtMethodIndex)|| ',N''' || v_ExtAppName || ''', N''' || v_ExtAppType || ''', N''getCurrentDateTime'', NULL, NULL, 8, NULL)';
						END IF;

						v_ExtMethodIndex := v_ExtMethodIndex + 1;
						DECLARE 
						CURSOR cursor2 IS SELECT ExtMethodIndex FROM ExtMethodDefTable WHERE ProcessDefId = v_ProcessDefId AND ExtMethodName = N'getShortDate' and ReturnType = 15;	
						BEGIN
							v_found := 0;
							OPEN cursor2;
							LOOP
								FETCH cursor2 INTO v_ExtMethodIndex1;
								EXIT WHEN cursor2%NOTFOUND;
								BEGIN
									v_found := 1;
									SELECT count(*) INTO v_count FROM ExtMethodParamDefTable where ProcessDefId = v_ProcessDefId and ExtMethodIndex = v_ExtMethodIndex1;	
									IF (v_count = 1) THEN 
									BEGIN
										BEGIN
											SELECT ParameterName INTO v_paramname1 FROM ExtMethodParamDefTable WHERE ProcessDefId = v_ProcessDefId and ExtMethodIndex = v_ExtMethodIndex1 and ParameterType = 8 AND ParameterName = 'Param1'; 
											EXCEPTION
												WHEN NO_DATA_FOUND THEN
													v_found := 0;	
										END;
									END;
									ELSE
										v_found := 0;	
									END IF;
									EXIT WHEN v_found = 1;
								END;
							END LOOP;
							CLOSE cursor2;
						END;

						IF v_found = 0 THEN
						BEGIN
							SAVEPOINT sys_catalog;
							
								v_ExtMethodIndex:=findMaxExtMethodIndex(v_ProcessDefId,v_ExtAppName,v_ExtAppType);
								
								EXECUTE IMMEDIATE 'INSERT INTO ExtMethodDefTable(ProcessDefId,ExtMethodIndex,ExtAppName,ExtAppType,ExtMethodName,SearchMethod,SearchCriteria,ReturnType,MappingFile) VALUES(' || TO_CHAR(v_ProcessDefId) || ',' || TO_CHAR(v_ExtMethodIndex)|| ',N''' || v_ExtAppName || ''', N''' || v_ExtAppType || ''', N''getShortDate'', NULL, NULL, 15, NULL)';
								EXECUTE IMMEDIATE 'INSERT INTO ExtMethodParamDefTable(PROCESSDEFID,EXTMETHODPARAMINDEX,EXTMETHODINDEX,PARAMETERNAME,PARAMETERTYPE,PARAMETERORDER,DATASTRUCTUREID,PARAMETERSCOPE,UNBOUNDED) VALUES(' || TO_CHAR(v_ProcessDefId) || ', 1,'  || TO_CHAR(v_ExtMethodIndex) ||  ', N''Param1'', 8, 1, NULL, NULL, N''N'')';
							COMMIT;
						END;
						END IF;
						
						v_ExtMethodIndex := v_ExtMethodIndex + 1;
						DECLARE 
						CURSOR cursor2 IS SELECT ExtMethodIndex FROM ExtMethodDefTable WHERE ProcessDefId = v_ProcessDefId AND ExtMethodName = N'getTime' and ReturnType = 16;	
						BEGIN
							v_found := 0;
							OPEN cursor2;
							LOOP
								FETCH cursor2 INTO v_ExtMethodIndex1;
								EXIT WHEN cursor2%NOTFOUND;
								BEGIN
									v_found := 1;
									SELECT count(*) INTO v_count FROM ExtMethodParamDefTable where ProcessDefId = v_ProcessDefId and ExtMethodIndex = v_ExtMethodIndex1;	
									IF (v_count = 1) THEN 
									BEGIN
										BEGIN
											SELECT ParameterName INTO v_paramname1 FROM ExtMethodParamDefTable WHERE ProcessDefId = v_ProcessDefId and ExtMethodIndex = v_ExtMethodIndex1 and ParameterType = 8 AND ParameterName = 'Param1'; 
											EXCEPTION
												WHEN NO_DATA_FOUND THEN
													v_found := 0;	
										END;
									END;
									ELSE
										v_found := 0;	
									END IF;
									EXIT WHEN v_found = 1;
								END;
							END LOOP;
							CLOSE cursor2;
						END;

						IF v_found = 0 THEN
						BEGIN
							SAVEPOINT sys_catalog;
								v_ExtMethodIndex:=findMaxExtMethodIndex(v_ProcessDefId,v_ExtAppName,v_ExtAppType);
								EXECUTE IMMEDIATE 'INSERT INTO ExtMethodDefTable(ProcessDefId,ExtMethodIndex,ExtAppName,ExtAppType,ExtMethodName,SearchMethod,SearchCriteria,ReturnType,MappingFile) VALUES(' || TO_CHAR(v_ProcessDefId) || ',' || TO_CHAR(v_ExtMethodIndex)|| ',N''' || v_ExtAppName || ''', N''' || v_ExtAppType || ''', N''getTime'', NULL, NULL, 16, NULL)';
								EXECUTE IMMEDIATE 'INSERT INTO ExtMethodParamDefTable(PROCESSDEFID,EXTMETHODPARAMINDEX,EXTMETHODINDEX,PARAMETERNAME,PARAMETERTYPE,PARAMETERORDER,DATASTRUCTUREID,PARAMETERSCOPE,UNBOUNDED) VALUES(' || TO_CHAR(v_ProcessDefId) || ', 1,'  || TO_CHAR(v_ExtMethodIndex) ||  ', N''Param1'', 8, 1, NULL, NULL, N''N'')';
							COMMIT;
						END;
						END IF;

						v_ExtMethodIndex := v_ExtMethodIndex + 1;
						DECLARE 
						CURSOR cursor2 IS SELECT ExtMethodIndex FROM ExtMethodDefTable WHERE ProcessDefId = v_ProcessDefId AND ExtMethodName = N'roundToInt' and ReturnType = 3;	
						BEGIN
							v_found := 0;
							OPEN cursor2;
							LOOP
								FETCH cursor2 INTO v_ExtMethodIndex1;
								EXIT WHEN cursor2%NOTFOUND;
								BEGIN
									v_found := 1;
									SELECT count(*) INTO v_count FROM ExtMethodParamDefTable where ProcessDefId = v_ProcessDefId and ExtMethodIndex = v_ExtMethodIndex1;	
									IF (v_count = 1) THEN 
									BEGIN
										BEGIN
											SELECT ParameterName INTO v_paramname1 FROM ExtMethodParamDefTable WHERE ProcessDefId = v_ProcessDefId and ExtMethodIndex = v_ExtMethodIndex1 and ParameterType = 6 AND ParameterName = 'Param1'; 
											EXCEPTION
												WHEN NO_DATA_FOUND THEN
													v_found := 0;	
										END;
									END;
									ELSE
										v_found := 0;	
									END IF;
									EXIT WHEN v_found = 1;
								END;
							END LOOP;
							CLOSE cursor2;
						END;

						IF v_found = 0 THEN
						BEGIN
							SAVEPOINT sys_catalog;
							
								v_ExtMethodIndex:=findMaxExtMethodIndex(v_ProcessDefId,v_ExtAppName,v_ExtAppType);
								EXECUTE IMMEDIATE 'INSERT INTO ExtMethodDefTable(ProcessDefId,ExtMethodIndex,ExtAppName,ExtAppType,ExtMethodName,SearchMethod,SearchCriteria,ReturnType,MappingFile) VALUES(' || TO_CHAR(v_ProcessDefId) || ',' || TO_CHAR(v_ExtMethodIndex)|| ',N''' || v_ExtAppName || ''', N''' || v_ExtAppType || ''', N''roundToInt'', NULL, NULL, 3, NULL)';
								EXECUTE IMMEDIATE 'INSERT INTO ExtMethodParamDefTable(PROCESSDEFID,EXTMETHODPARAMINDEX,EXTMETHODINDEX,PARAMETERNAME,PARAMETERTYPE,PARAMETERORDER,DATASTRUCTUREID,PARAMETERSCOPE,UNBOUNDED) VALUES(' || TO_CHAR(v_ProcessDefId) || ', 1,'  || TO_CHAR(v_ExtMethodIndex) ||  ', N''Param1'', 6, 1, NULL, NULL, N''N'')';
							COMMIT;
						END;
						END IF;

						v_ExtMethodIndex := v_ExtMethodIndex + 1;
						DECLARE 
						CURSOR cursor2 IS SELECT ExtMethodIndex FROM ExtMethodDefTable WHERE ProcessDefId = v_ProcessDefId AND ExtMethodName = N'getElementAtIndex' and ReturnType = 3;	
						BEGIN
							v_found := 0;
							OPEN cursor2;
							LOOP
								FETCH cursor2 INTO v_ExtMethodIndex1;
								EXIT WHEN cursor2%NOTFOUND;
								BEGIN
									v_found := 1;
									SELECT count(*) INTO v_count FROM ExtMethodParamDefTable where ProcessDefId = v_ProcessDefId and ExtMethodIndex = v_ExtMethodIndex1;	
									IF (v_count = 2) THEN 
									BEGIN
										BEGIN
											SELECT ParameterName INTO v_paramname1 FROM ExtMethodParamDefTable WHERE ProcessDefId = v_ProcessDefId and ExtMethodIndex = v_ExtMethodIndex1 and ParameterType = 3 AND ParameterName = 'Param1'; 
											EXCEPTION
												WHEN NO_DATA_FOUND THEN
													v_found := 0;	
										END;
										BEGIN
											SELECT ParameterName INTO v_paramname2 FROM ExtMethodParamDefTable WHERE ProcessDefId = v_ProcessDefId and ExtMethodIndex = v_ExtMethodIndex1 and ParameterType = 3 AND ParameterName = 'Param2';
											EXCEPTION
												WHEN NO_DATA_FOUND THEN
													v_found := 0;		 
										END;
									END;
									ELSE
										v_found := 0;	
									END IF;
									EXIT WHEN v_found = 1;
								END;
							END LOOP;
							CLOSE cursor2;
						END;

						IF v_found = 0 THEN
						BEGIN
							SAVEPOINT sys_catalog;
							
								v_ExtMethodIndex:=findMaxExtMethodIndex(v_ProcessDefId,v_ExtAppName,v_ExtAppType);
								EXECUTE IMMEDIATE 'INSERT INTO ExtMethodDefTable(ProcessDefId,ExtMethodIndex,ExtAppName,ExtAppType,ExtMethodName,SearchMethod,SearchCriteria,ReturnType,MappingFile) VALUES(' || TO_CHAR(v_ProcessDefId) || ',' || TO_CHAR(v_ExtMethodIndex)|| ',N''' || v_ExtAppName || ''', N''' || v_ExtAppType || ''', N''getElementAtIndex'', NULL, NULL, 3, NULL)';
								EXECUTE IMMEDIATE 'INSERT INTO ExtMethodParamDefTable(PROCESSDEFID,EXTMETHODPARAMINDEX,EXTMETHODINDEX,PARAMETERNAME,PARAMETERTYPE,PARAMETERORDER,DATASTRUCTUREID,PARAMETERSCOPE,UNBOUNDED) VALUES(' || TO_CHAR(v_ProcessDefId) || ', 1,'  || TO_CHAR(v_ExtMethodIndex) ||  ', N''Param1'', 3, 1, NULL, NULL, N''N'')';
								EXECUTE IMMEDIATE 'INSERT INTO ExtMethodParamDefTable(PROCESSDEFID,EXTMETHODPARAMINDEX,EXTMETHODINDEX,PARAMETERNAME,PARAMETERTYPE,PARAMETERORDER,DATASTRUCTUREID,PARAMETERSCOPE,UNBOUNDED) VALUES(' || TO_CHAR(v_ProcessDefId)|| ', 2,' || TO_CHAR(v_ExtMethodIndex) || ', N''Param2'', 3, 2, NULL, NULL, N''N'')';
							COMMIT;
						END;
						END IF;

						v_ExtMethodIndex := v_ExtMethodIndex + 1;
						DECLARE 
						CURSOR cursor2 IS SELECT ExtMethodIndex FROM ExtMethodDefTable WHERE ProcessDefId = v_ProcessDefId AND ExtMethodName = N'addElementToArray' and ReturnType = 3;	
						BEGIN
							v_found := 0;
							OPEN cursor2;
							LOOP
								FETCH cursor2 INTO v_ExtMethodIndex1;
								EXIT WHEN cursor2%NOTFOUND;
								BEGIN
									v_found := 1;
									SELECT count(*) INTO v_count FROM ExtMethodParamDefTable where ProcessDefId = v_ProcessDefId and ExtMethodIndex = v_ExtMethodIndex1;	
									IF (v_count = 3) THEN 
									BEGIN
										BEGIN
											SELECT ParameterName INTO v_paramname1 FROM ExtMethodParamDefTable WHERE ProcessDefId = v_ProcessDefId and ExtMethodIndex = v_ExtMethodIndex1 and ParameterType = 3 AND ParameterName = 'Param1'; 
											EXCEPTION
												WHEN NO_DATA_FOUND THEN
													v_found := 0;	
										END;
										BEGIN
											SELECT ParameterName INTO v_paramname2 FROM ExtMethodParamDefTable WHERE ProcessDefId = v_ProcessDefId and ExtMethodIndex = v_ExtMethodIndex1 and ParameterType = 3 AND ParameterName = 'Param2';
											EXCEPTION
												WHEN NO_DATA_FOUND THEN
													v_found := 0;		 
										END;
										BEGIN
											SELECT ParameterName INTO v_paramname3 FROM ExtMethodParamDefTable WHERE ProcessDefId = v_ProcessDefId and ExtMethodIndex = v_ExtMethodIndex1 and ParameterType = 3 AND ParameterName = 'Param3';
											EXCEPTION
												WHEN NO_DATA_FOUND THEN
													v_found := 0;		 
										END;
									END;
									ELSE
										v_found := 0;	
									END IF;
									EXIT WHEN v_found = 1;
								END;
							END LOOP;
							CLOSE cursor2;
						END;

						IF v_found = 0 THEN
						BEGIN
							SAVEPOINT sys_catalog;
								v_ExtMethodIndex:=findMaxExtMethodIndex(v_ProcessDefId,v_ExtAppName,v_ExtAppType);
								EXECUTE IMMEDIATE 'INSERT INTO ExtMethodDefTable(ProcessDefId,ExtMethodIndex,ExtAppName,ExtAppType,ExtMethodName,SearchMethod,SearchCriteria,ReturnType,MappingFile) VALUES(' || TO_CHAR(v_ProcessDefId) || ',' || TO_CHAR(v_ExtMethodIndex)|| ',N''' || v_ExtAppName || ''', N''' || v_ExtAppType || ''', N''addElementToArray'', NULL, NULL, 3, NULL)';
								EXECUTE IMMEDIATE 'INSERT INTO ExtMethodParamDefTable(PROCESSDEFID,EXTMETHODPARAMINDEX,EXTMETHODINDEX,PARAMETERNAME,PARAMETERTYPE,PARAMETERORDER,DATASTRUCTUREID,PARAMETERSCOPE,UNBOUNDED) VALUES(' || TO_CHAR(v_ProcessDefId) || ', 1,'  || TO_CHAR(v_ExtMethodIndex) ||  ', N''Param1'', 3, 1, NULL, NULL, N''N'')';
								EXECUTE IMMEDIATE 'INSERT INTO ExtMethodParamDefTable(PROCESSDEFID,EXTMETHODPARAMINDEX,EXTMETHODINDEX,PARAMETERNAME,PARAMETERTYPE,PARAMETERORDER,DATASTRUCTUREID,PARAMETERSCOPE,UNBOUNDED) VALUES(' || TO_CHAR(v_ProcessDefId)|| ', 2,' || TO_CHAR(v_ExtMethodIndex) || ', N''Param2'', 3, 2, NULL, NULL, N''N'')';
								EXECUTE IMMEDIATE 'INSERT INTO ExtMethodParamDefTable(PROCESSDEFID,EXTMETHODPARAMINDEX,EXTMETHODINDEX,PARAMETERNAME,PARAMETERTYPE,PARAMETERORDER,DATASTRUCTUREID,PARAMETERSCOPE,UNBOUNDED) VALUES(' || TO_CHAR(v_ProcessDefId)|| ', 3,' || TO_CHAR(v_ExtMethodIndex) || ', N''Param3'', 3, 3, NULL, NULL, N''N'')';
							COMMIT;
						END;
						END IF;
					END;
				END LOOP;
				CLOSE cursor1;
			END;
		END;
	EXCEPTION
		WHEN OTHERS THEN
    RAISE;
			v_logStatus := LogUpdateError(1);   
			raise_application_error(-20201,v_scriptName ||' BLOCK 1 FAILED');
	END;
	v_logStatus := LogUpdate(1);

END;
		
		


		
~

call SystemCatalog()

~

DROP Procedure SystemCatalog

~
