/*__________________________________________________________________________________-
		NEWGEN SOFTWARE TECHNOLOGIES LIMITED

	Group						: Application – Products
	Product / Project			: WorkFlow 7.2.2
	Module						: Transaction Server
	File NAME					: Upgrade02_01.sql (Oracle Server)
	Author						: Ishu Saraf
	Date written (DD/MM/YYYY)	: 29/08/2008
	Description					: Upgrade Script for adding System Catalog functions
____________________________________________________________________________________-
			CHANGE HISTORY
____________________________________________________________________________________-
Date		Change By		Change Description (Bug No. (If Any))
26/02/2013	Bhavneet Kaur	Bug 38521: System Defined Entries not inserted in ExtMethodDefTable for Processes without any external method
__________________________________________________________________________________________*/

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
BEGIN
	v_ExtAppName := 'System';
	v_ExtAppType := 'S';

SELECT CabVersion INTO v_cabVersion FROM WFCabVersionTable WHERE CabVersion = '7.2_SystemCatalog';
EXCEPTION 
	WHEN NO_DATA_FOUND THEN
	BEGIN
		DECLARE CURSOR cursor1 IS SELECT ProcessDefId, ExtMethodIndex FROM ExtMethodDefTable WHERE ExtAppType != 'S';
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
			v_STR6 := ' UPDATE RuleOperationTable SET Param1 = TO_CHAR(TO_NUMBER(Param1) + 1000) WHERE ProcessDefId = ' ||  TO_CHAR(v_ProcessDefId) || ' AND OperationType = 22 ';
			v_STR7 := ' UPDATE RuleOperationTable SET Param2 = TO_CHAR(TO_NUMBER(Param2) + 1000) WHERE ProcessDefId = ' || TO_CHAR(v_ProcessDefId) || ' AND OperationType = 23 ';

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
					EXECUTE IMMEDIATE 'INSERT INTO ExtMethodDefTable VALUES(' || v_ProcessDefId || ',' || v_ExtMethodIndex || ',N''' || v_ExtAppName || ''', N''' || v_ExtAppType || ''', N''contains'', NULL, NULL, 12, NULL)';
					EXECUTE IMMEDIATE 'INSERT INTO ExtMethodParamDefTable VALUES(' || v_ProcessDefId || ', 1,'  || v_ExtMethodIndex ||  ', N''Param1'', 10, 1, NULL, NULL, N''N'')';
					EXECUTE IMMEDIATE 'INSERT INTO ExtMethodParamDefTable VALUES(' || v_ProcessDefId|| ', 2,' || v_ExtMethodIndex || ', N''Param2'', 10, 2, NULL, NULL, N''N'')';
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
					EXECUTE IMMEDIATE 'INSERT INTO ExtMethodDefTable VALUES(' || TO_CHAR(v_ProcessDefId) || ',' || TO_CHAR(v_ExtMethodIndex)|| ',N''' || v_ExtAppName || ''', N''' || v_ExtAppType || ''', N''normalizeSpace'', NULL, NULL, 10, NULL)';
					EXECUTE IMMEDIATE 'INSERT INTO ExtMethodParamDefTable VALUES(' || TO_CHAR(v_ProcessDefId) || ', 1,'  || TO_CHAR(v_ExtMethodIndex) ||  ', N''Param1'', 10, 1, NULL, NULL, N''N'')';
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
					EXECUTE IMMEDIATE 'INSERT INTO ExtMethodDefTable VALUES(' || TO_CHAR(v_ProcessDefId) || ',' || TO_CHAR(v_ExtMethodIndex)|| ',N''' || v_ExtAppName || ''', N''' || v_ExtAppType || ''', N''stringValue'', NULL, NULL, 10, NULL)';
					EXECUTE IMMEDIATE 'INSERT INTO ExtMethodParamDefTable VALUES(' || TO_CHAR(v_ProcessDefId) || ', 1,'  || TO_CHAR(v_ExtMethodIndex) ||  ', N''Param1'', 10, 1, NULL, NULL, N''N'')';
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
					EXECUTE IMMEDIATE 'INSERT INTO ExtMethodDefTable VALUES(' || TO_CHAR(v_ProcessDefId) || ',' || TO_CHAR(v_ExtMethodIndex)|| ',N''' || v_ExtAppName || ''', N''' || v_ExtAppType || ''', N''stringValue'', NULL, NULL, 10, NULL)';
					EXECUTE IMMEDIATE 'INSERT INTO ExtMethodParamDefTable VALUES(' || TO_CHAR(v_ProcessDefId) || ', 1,'  || TO_CHAR(v_ExtMethodIndex) ||  ', N''Param1'', 8, 1, NULL, NULL, N''N'')';
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
					EXECUTE IMMEDIATE 'INSERT INTO ExtMethodDefTable VALUES(' || TO_CHAR(v_ProcessDefId) || ',' || TO_CHAR(v_ExtMethodIndex)|| ',N''' || v_ExtAppName || ''', N''' || v_ExtAppType || ''', N''stringValue'', NULL, NULL, 10, NULL)';
					EXECUTE IMMEDIATE 'INSERT INTO ExtMethodParamDefTable VALUES(' || TO_CHAR(v_ProcessDefId) || ', 1,'  || TO_CHAR(v_ExtMethodIndex) ||  ', N''Param1'', 6, 1, NULL, NULL, N''N'')';
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
					EXECUTE IMMEDIATE 'INSERT INTO ExtMethodDefTable VALUES(' || TO_CHAR(v_ProcessDefId) || ',' || TO_CHAR(v_ExtMethodIndex)|| ',N''' || v_ExtAppName || ''', N''' || v_ExtAppType || ''', N''stringValue'', NULL, NULL, 10, NULL)';
					EXECUTE IMMEDIATE 'INSERT INTO ExtMethodParamDefTable VALUES(' || TO_CHAR(v_ProcessDefId) || ', 1,'  || TO_CHAR(v_ExtMethodIndex) ||  ', N''Param1'', 4, 1, NULL, NULL, N''N'')';
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
					EXECUTE IMMEDIATE 'INSERT INTO ExtMethodDefTable VALUES(' || TO_CHAR(v_ProcessDefId) || ',' || TO_CHAR(v_ExtMethodIndex)|| ',N''' || v_ExtAppName || ''', N''' || v_ExtAppType || ''', N''stringValue'', NULL, NULL, 10, NULL)';
					EXECUTE IMMEDIATE 'INSERT INTO ExtMethodParamDefTable VALUES(' || TO_CHAR(v_ProcessDefId) || ', 1,'  || TO_CHAR(v_ExtMethodIndex) ||  ', N''Param1'', 3, 1, NULL, NULL, N''N'')';
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
					EXECUTE IMMEDIATE 'INSERT INTO ExtMethodDefTable VALUES(' || TO_CHAR(v_ProcessDefId) || ',' || TO_CHAR(v_ExtMethodIndex)|| ',N''' || v_ExtAppName || ''', N''' || v_ExtAppType || ''', N''stringValue'', NULL, NULL, 10, NULL)';
					EXECUTE IMMEDIATE 'INSERT INTO ExtMethodParamDefTable VALUES(' || TO_CHAR(v_ProcessDefId) || ', 1,'  || TO_CHAR(v_ExtMethodIndex) ||  ', N''Param1'', 12, 1, NULL, NULL, N''N'')';
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
					EXECUTE IMMEDIATE 'INSERT INTO ExtMethodDefTable VALUES(' || TO_CHAR(v_ProcessDefId) || ',' || TO_CHAR(v_ExtMethodIndex)|| ',N''' || v_ExtAppName || ''', N''' || v_ExtAppType || ''', N''booleanValue'', NULL, NULL, 12, NULL)';
					EXECUTE IMMEDIATE 'INSERT INTO ExtMethodParamDefTable VALUES(' || TO_CHAR(v_ProcessDefId) || ', 1,'  || TO_CHAR(v_ExtMethodIndex) ||  ', N''Param1'', 10, 1, NULL, NULL, N''N'')';
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
					EXECUTE IMMEDIATE 'INSERT INTO ExtMethodDefTable VALUES(' || TO_CHAR(v_ProcessDefId) || ',' || TO_CHAR(v_ExtMethodIndex)|| ',N''' || v_ExtAppName || ''', N''' || v_ExtAppType || ''', N''booleanValue'', NULL, NULL, 12, NULL)';
					EXECUTE IMMEDIATE 'INSERT INTO ExtMethodParamDefTable VALUES(' || TO_CHAR(v_ProcessDefId) || ', 1,'  || TO_CHAR(v_ExtMethodIndex) ||  ', N''Param1'', 3, 1, NULL, NULL, N''N'')';
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
					EXECUTE IMMEDIATE 'INSERT INTO ExtMethodDefTable VALUES(' || TO_CHAR(v_ProcessDefId) || ',' || TO_CHAR(v_ExtMethodIndex)|| ',N''' || v_ExtAppName || ''', N''' || v_ExtAppType || ''', N''startsWith'', NULL, NULL, 12, NULL)';
					EXECUTE IMMEDIATE 'INSERT INTO ExtMethodParamDefTable VALUES(' || TO_CHAR(v_ProcessDefId) || ', 1,'  || TO_CHAR(v_ExtMethodIndex) ||  ', N''Param1'', 10, 1, NULL, NULL, N''N'')';
					EXECUTE IMMEDIATE 'INSERT INTO ExtMethodParamDefTable VALUES(' || TO_CHAR(v_ProcessDefId)|| ', 2,' || TO_CHAR(v_ExtMethodIndex) || ', N''Param2'', 10, 2, NULL, NULL, N''N'')';
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
					EXECUTE IMMEDIATE 'INSERT INTO ExtMethodDefTable VALUES(' || TO_CHAR(v_ProcessDefId) || ',' || TO_CHAR(v_ExtMethodIndex)|| ',N''' || v_ExtAppName || ''', N''' || v_ExtAppType || ''', N''stringLength'', NULL, NULL, 3, NULL)';
					EXECUTE IMMEDIATE 'INSERT INTO ExtMethodParamDefTable VALUES(' || TO_CHAR(v_ProcessDefId) || ', 1,'  || TO_CHAR(v_ExtMethodIndex) ||  ', N''Param1'', 10, 1, NULL, NULL, N''N'')';
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
					EXECUTE IMMEDIATE 'INSERT INTO ExtMethodDefTable VALUES(' || TO_CHAR(v_ProcessDefId) || ',' || TO_CHAR(v_ExtMethodIndex)|| ',N''' || v_ExtAppName || ''', N''' || v_ExtAppType || ''', N''subString'', NULL, NULL, 10, NULL)';
					EXECUTE IMMEDIATE 'INSERT INTO ExtMethodParamDefTable VALUES(' || TO_CHAR(v_ProcessDefId) || ', 1,'  || TO_CHAR(v_ExtMethodIndex) ||  ', N''Param1'', 10, 1, NULL, NULL, N''N'')';
					EXECUTE IMMEDIATE 'INSERT INTO ExtMethodParamDefTable VALUES(' || TO_CHAR(v_ProcessDefId)|| ', 2,' || TO_CHAR(v_ExtMethodIndex) || ', N''Param2'', 3, 2, NULL, NULL, N''N'')';
					EXECUTE IMMEDIATE 'INSERT INTO ExtMethodParamDefTable VALUES(' || TO_CHAR(v_ProcessDefId)|| ', 3,' || TO_CHAR(v_ExtMethodIndex) || ', N''Param3'', 3, 3, NULL, NULL, N''N'')';
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
					EXECUTE IMMEDIATE 'INSERT INTO ExtMethodDefTable VALUES(' || TO_CHAR(v_ProcessDefId) || ',' || TO_CHAR(v_ExtMethodIndex)|| ',N''' || v_ExtAppName || ''', N''' || v_ExtAppType || ''', N''subStringBefore'', NULL, NULL, 10, NULL)';
					EXECUTE IMMEDIATE 'INSERT INTO ExtMethodParamDefTable VALUES(' || TO_CHAR(v_ProcessDefId) || ', 1,'  || TO_CHAR(v_ExtMethodIndex) ||  ', N''Param1'', 10, 1, NULL, NULL, N''N'')';
					EXECUTE IMMEDIATE 'INSERT INTO ExtMethodParamDefTable VALUES(' || TO_CHAR(v_ProcessDefId)|| ', 2,' || TO_CHAR(v_ExtMethodIndex) || ', N''Param2'', 10, 2, NULL, NULL, N''N'')';
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
					EXECUTE IMMEDIATE 'INSERT INTO ExtMethodDefTable VALUES(' || TO_CHAR(v_ProcessDefId) || ',' || TO_CHAR(v_ExtMethodIndex)|| ',N''' || v_ExtAppName || ''', N''' || v_ExtAppType || ''', N''subStringAfter'', NULL, NULL, 10, NULL)';
					EXECUTE IMMEDIATE 'INSERT INTO ExtMethodParamDefTable VALUES(' || TO_CHAR(v_ProcessDefId) || ', 1,'  || TO_CHAR(v_ExtMethodIndex) ||  ', N''Param1'', 10, 1, NULL, NULL, N''N'')';
					EXECUTE IMMEDIATE 'INSERT INTO ExtMethodParamDefTable VALUES(' || TO_CHAR(v_ProcessDefId)|| ', 2,' || TO_CHAR(v_ExtMethodIndex) || ', N''Param2'', 10, 2, NULL, NULL, N''N'')';
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
					EXECUTE IMMEDIATE 'INSERT INTO ExtMethodDefTable VALUES(' || TO_CHAR(v_ProcessDefId) || ',' || TO_CHAR(v_ExtMethodIndex)|| ',N''' || v_ExtAppName || ''', N''' || v_ExtAppType || ''', N''translate'', NULL, NULL, 10, NULL)';
					EXECUTE IMMEDIATE 'INSERT INTO ExtMethodParamDefTable VALUES(' || TO_CHAR(v_ProcessDefId) || ', 1,'  || TO_CHAR(v_ExtMethodIndex) ||  ', N''Param1'', 10, 1, NULL, NULL, N''N'')';
					EXECUTE IMMEDIATE 'INSERT INTO ExtMethodParamDefTable VALUES(' || TO_CHAR(v_ProcessDefId)|| ', 2,' || TO_CHAR(v_ExtMethodIndex) || ', N''Param2'', 10, 2, NULL, NULL, N''N'')';
					EXECUTE IMMEDIATE 'INSERT INTO ExtMethodParamDefTable VALUES(' || TO_CHAR(v_ProcessDefId)|| ', 3,' || TO_CHAR(v_ExtMethodIndex) || ', N''Param3'', 10, 3, NULL, NULL, N''N'')';
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
					EXECUTE IMMEDIATE 'INSERT INTO ExtMethodDefTable VALUES(' || TO_CHAR(v_ProcessDefId) || ',' || TO_CHAR(v_ExtMethodIndex)|| ',N''' || v_ExtAppName || ''', N''' || v_ExtAppType || ''', N''concat'', NULL, NULL, 10, NULL)';
					EXECUTE IMMEDIATE 'INSERT INTO ExtMethodParamDefTable VALUES(' || TO_CHAR(v_ProcessDefId) || ', 1,'  || TO_CHAR(v_ExtMethodIndex) ||  ', N''Param1'', 10, 1, NULL, NULL, N''N'')';
					EXECUTE IMMEDIATE 'INSERT INTO ExtMethodParamDefTable VALUES(' || TO_CHAR(v_ProcessDefId)|| ', 2,' || TO_CHAR(v_ExtMethodIndex) || ', N''Param2'', 10, 2, NULL, NULL, N''N'')';
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
					EXECUTE IMMEDIATE 'INSERT INTO ExtMethodDefTable VALUES(' || TO_CHAR(v_ProcessDefId) || ',' || TO_CHAR(v_ExtMethodIndex)|| ',N''' || v_ExtAppName || ''', N''' || v_ExtAppType || ''', N''numberValue'', NULL, NULL, 6, NULL)';
					EXECUTE IMMEDIATE 'INSERT INTO ExtMethodParamDefTable VALUES(' || TO_CHAR(v_ProcessDefId) || ', 1,'  || TO_CHAR(v_ExtMethodIndex) ||  ', N''Param1'', 10, 1, NULL, NULL, N''N'')';
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
					EXECUTE IMMEDIATE 'INSERT INTO ExtMethodDefTable VALUES(' || TO_CHAR(v_ProcessDefId) || ',' || TO_CHAR(v_ExtMethodIndex)|| ',N''' || v_ExtAppName || ''', N''' || v_ExtAppType || ''', N''numberValue'', NULL, NULL, 6, NULL)';
					EXECUTE IMMEDIATE 'INSERT INTO ExtMethodParamDefTable VALUES(' || TO_CHAR(v_ProcessDefId) || ', 1,'  || TO_CHAR(v_ExtMethodIndex) ||  ', N''Param1'', 6, 1, NULL, NULL, N''N'')';
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
					EXECUTE IMMEDIATE 'INSERT INTO ExtMethodDefTable VALUES(' || TO_CHAR(v_ProcessDefId) || ',' || TO_CHAR(v_ExtMethodIndex)|| ',N''' || v_ExtAppName || ''', N''' || v_ExtAppType || ''', N''numberValue'', NULL, NULL, 6, NULL)';
					EXECUTE IMMEDIATE 'INSERT INTO ExtMethodParamDefTable VALUES(' || TO_CHAR(v_ProcessDefId) || ', 1,'  || TO_CHAR(v_ExtMethodIndex) ||  ', N''Param1'', 4, 1, NULL, NULL, N''N'')';
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
					EXECUTE IMMEDIATE 'INSERT INTO ExtMethodDefTable VALUES(' || TO_CHAR(v_ProcessDefId) || ',' || TO_CHAR(v_ExtMethodIndex)|| ',N''' || v_ExtAppName || ''', N''' || v_ExtAppType || ''', N''numberValue'', NULL, NULL, 6, NULL)';
					EXECUTE IMMEDIATE 'INSERT INTO ExtMethodParamDefTable VALUES(' || TO_CHAR(v_ProcessDefId) || ', 1,'  || TO_CHAR(v_ExtMethodIndex) ||  ', N''Param1'', 3, 1, NULL, NULL, N''N'')';
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
					EXECUTE IMMEDIATE 'INSERT INTO ExtMethodDefTable VALUES(' || TO_CHAR(v_ProcessDefId) || ',' || TO_CHAR(v_ExtMethodIndex)|| ',N''' || v_ExtAppName || ''', N''' || v_ExtAppType || ''', N''numberValue'', NULL, NULL, 6, NULL)';
					EXECUTE IMMEDIATE 'INSERT INTO ExtMethodParamDefTable VALUES(' || TO_CHAR(v_ProcessDefId) || ', 1,'  || TO_CHAR(v_ExtMethodIndex) ||  ', N''Param1'', 12, 1, NULL, NULL, N''N'')';
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
					EXECUTE IMMEDIATE 'INSERT INTO ExtMethodDefTable VALUES(' || TO_CHAR(v_ProcessDefId) || ',' || TO_CHAR(v_ExtMethodIndex)|| ',N''' || v_ExtAppName || ''', N''' || v_ExtAppType || ''', N''round'', NULL, NULL, 4, NULL)';
					EXECUTE IMMEDIATE 'INSERT INTO ExtMethodParamDefTable VALUES(' || TO_CHAR(v_ProcessDefId) || ', 1,'  || TO_CHAR(v_ExtMethodIndex) ||  ', N''Param1'', 6, 1, NULL, NULL, N''N'')';
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
					EXECUTE IMMEDIATE 'INSERT INTO ExtMethodDefTable VALUES(' || TO_CHAR(v_ProcessDefId) || ',' || TO_CHAR(v_ExtMethodIndex)|| ',N''' || v_ExtAppName || ''', N''' || v_ExtAppType || ''', N''floor'', NULL, NULL, 4, NULL)';
					EXECUTE IMMEDIATE 'INSERT INTO ExtMethodParamDefTable VALUES(' || TO_CHAR(v_ProcessDefId) || ', 1,'  || TO_CHAR(v_ExtMethodIndex) ||  ', N''Param1'', 6, 1, NULL, NULL, N''N'')';
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
					EXECUTE IMMEDIATE 'INSERT INTO ExtMethodDefTable VALUES(' || TO_CHAR(v_ProcessDefId) || ',' || TO_CHAR(v_ExtMethodIndex)|| ',N''' || v_ExtAppName || ''', N''' || v_ExtAppType || ''', N''ceiling'', NULL, NULL, 4, NULL)';
					EXECUTE IMMEDIATE 'INSERT INTO ExtMethodParamDefTable VALUES(' || TO_CHAR(v_ProcessDefId) || ', 1,'  || TO_CHAR(v_ExtMethodIndex) ||  ', N''Param1'', 6, 1, NULL, NULL, N''N'')';
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
				EXECUTE IMMEDIATE 'INSERT INTO ExtMethodDefTable VALUES(' || TO_CHAR(v_ProcessDefId) || ',' || TO_CHAR(v_ExtMethodIndex)|| ',N''' || v_ExtAppName || ''', N''' || v_ExtAppType || ''', N''getCurrentDate'', NULL, NULL, 15, NULL)';
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
				EXECUTE IMMEDIATE 'INSERT INTO ExtMethodDefTable VALUES(' || TO_CHAR(v_ProcessDefId) || ',' || TO_CHAR(v_ExtMethodIndex)|| ',N''' || v_ExtAppName || ''', N''' || v_ExtAppType || ''', N''getCurrentTime'', NULL, NULL, 16, NULL)';
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
				EXECUTE IMMEDIATE 'INSERT INTO ExtMethodDefTable VALUES(' || TO_CHAR(v_ProcessDefId) || ',' || TO_CHAR(v_ExtMethodIndex)|| ',N''' || v_ExtAppName || ''', N''' || v_ExtAppType || ''', N''getCurrentDateTime'', NULL, NULL, 8, NULL)';
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
					EXECUTE IMMEDIATE 'INSERT INTO ExtMethodDefTable VALUES(' || TO_CHAR(v_ProcessDefId) || ',' || TO_CHAR(v_ExtMethodIndex)|| ',N''' || v_ExtAppName || ''', N''' || v_ExtAppType || ''', N''getShortDate'', NULL, NULL, 15, NULL)';
					EXECUTE IMMEDIATE 'INSERT INTO ExtMethodParamDefTable VALUES(' || TO_CHAR(v_ProcessDefId) || ', 1,'  || TO_CHAR(v_ExtMethodIndex) ||  ', N''Param1'', 8, 1, NULL, NULL, N''N'')';
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
					EXECUTE IMMEDIATE 'INSERT INTO ExtMethodDefTable VALUES(' || TO_CHAR(v_ProcessDefId) || ',' || TO_CHAR(v_ExtMethodIndex)|| ',N''' || v_ExtAppName || ''', N''' || v_ExtAppType || ''', N''getTime'', NULL, NULL, 16, NULL)';
					EXECUTE IMMEDIATE 'INSERT INTO ExtMethodParamDefTable VALUES(' || TO_CHAR(v_ProcessDefId) || ', 1,'  || TO_CHAR(v_ExtMethodIndex) ||  ', N''Param1'', 8, 1, NULL, NULL, N''N'')';
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
					EXECUTE IMMEDIATE 'INSERT INTO ExtMethodDefTable VALUES(' || TO_CHAR(v_ProcessDefId) || ',' || TO_CHAR(v_ExtMethodIndex)|| ',N''' || v_ExtAppName || ''', N''' || v_ExtAppType || ''', N''roundToInt'', NULL, NULL, 3, NULL)';
					EXECUTE IMMEDIATE 'INSERT INTO ExtMethodParamDefTable VALUES(' || TO_CHAR(v_ProcessDefId) || ', 1,'  || TO_CHAR(v_ExtMethodIndex) ||  ', N''Param1'', 6, 1, NULL, NULL, N''N'')';
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
					EXECUTE IMMEDIATE 'INSERT INTO ExtMethodDefTable VALUES(' || TO_CHAR(v_ProcessDefId) || ',' || TO_CHAR(v_ExtMethodIndex)|| ',N''' || v_ExtAppName || ''', N''' || v_ExtAppType || ''', N''getElementAtIndex'', NULL, NULL, 3, NULL)';
					EXECUTE IMMEDIATE 'INSERT INTO ExtMethodParamDefTable VALUES(' || TO_CHAR(v_ProcessDefId) || ', 1,'  || TO_CHAR(v_ExtMethodIndex) ||  ', N''Param1'', 3, 1, NULL, NULL, N''N'')';
					EXECUTE IMMEDIATE 'INSERT INTO ExtMethodParamDefTable VALUES(' || TO_CHAR(v_ProcessDefId)|| ', 2,' || TO_CHAR(v_ExtMethodIndex) || ', N''Param2'', 3, 2, NULL, NULL, N''N'')';
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
					EXECUTE IMMEDIATE 'INSERT INTO ExtMethodDefTable VALUES(' || TO_CHAR(v_ProcessDefId) || ',' || TO_CHAR(v_ExtMethodIndex)|| ',N''' || v_ExtAppName || ''', N''' || v_ExtAppType || ''', N''addElementToArray'', NULL, NULL, 3, NULL)';
					EXECUTE IMMEDIATE 'INSERT INTO ExtMethodParamDefTable VALUES(' || TO_CHAR(v_ProcessDefId) || ', 1,'  || TO_CHAR(v_ExtMethodIndex) ||  ', N''Param1'', 3, 1, NULL, NULL, N''N'')';
					EXECUTE IMMEDIATE 'INSERT INTO ExtMethodParamDefTable VALUES(' || TO_CHAR(v_ProcessDefId)|| ', 2,' || TO_CHAR(v_ExtMethodIndex) || ', N''Param2'', 3, 2, NULL, NULL, N''N'')';
					EXECUTE IMMEDIATE 'INSERT INTO ExtMethodParamDefTable VALUES(' || TO_CHAR(v_ProcessDefId)|| ', 3,' || TO_CHAR(v_ExtMethodIndex) || ', N''Param3'', 3, 3, NULL, NULL, N''N'')';
				COMMIT;
			END;
			END IF;
		END;
	END LOOP;
	CLOSE cursor1;
END;
END;		
		
~

call SystemCatalog()

~

DROP Procedure SystemCatalog

~