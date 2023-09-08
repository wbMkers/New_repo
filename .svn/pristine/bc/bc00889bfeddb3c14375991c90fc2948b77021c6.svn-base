	/*__________________________________________________________________________________;
		NEWGEN SOFTWARE TECHNOLOGIES LIMITED;
		Group                       : Genesis;
		Product / Project           : IBPS;
		Module                      : IBPS Server;
		File Name                   : WFExportTaskTables.sql (MSSQL)
		Author                      : Sajid Khan
		Date written (DD/MM/YYYY)   : 07 July 2015
		Description                 : Stored Procedure to set migrate Task Data Tables
		____________________________________________________________________________________;
		CHANGE HISTORY;
		____________________________________________________________________________________;
		Date        Change By        Change Description (Bug No. (IF Any))
		____________________________________________________________________________________*/	
		
	CREATE OR REPLACE FUNCTION WFExportTaskTables(
		v_sourceCabinet 	VARCHAR(256),
		v_targetCabinet 	VARCHAR(256),
		dblinkString     	VARCHAR(256),
		v_processDefId  	INT,
		v_migrateAllData 	VARCHAR(256),
		v_executionLogId	INT,
		v_isRunTimeTable		VARCHAR(1)
		)
		RETURNS void  LANGUAGE 'plpgsql' AS $function$ 
		
	
	
	BEGIN
		DECLARE v_query       			VARCHAR(2000);
		DECLARE v_queryStr    			VARCHAR(2000);
		DECLARE v_createQuery  		VARCHAR(4000);
		DECLARE v_filterQueryString 	VARCHAR(1000);
		DECLARE v_tableName			VARCHAR(256);
		DECLARE	v_localProcessDefId  	INT;
		DECLARE v_taskId				INT;
		Declare v_scope				VARCHAR(1);
		--DECLARE ref_cursor REFCURSOR := 'mycursor';
		DECLARE v_TableCursor REFCURSOR;
		DECLARE CO_DATATYPE VARCHAR(4000);
		DECLARE v_createQuery_Column VARCHAR(4000);
	
	BEGIN
		IF (v_migrateAllData = 'Y') THEN
		BEGIN
			v_filterQueryString := ' ';
		END;
		ELSE
		BEGIN
			v_filterQueryString := ' WHERE PROCESSDEFID =  ' || v_ProcessDefId;
		END;
		END IF;
		
		IF (v_isRunTimeTable ='Y') THEN
		BEGIN
			v_scope := 'U';
		END;
		ELSE
		BEGIN
			v_scope := 'P';
		END;
		END IF;
		
		IF (v_migrateAllData ='Y')THEN
		BEGIN
			v_filterQueryString := ' Where  SCOPE = ''' || v_scope ||'''';
		END;
		ELSE
		BEGIN
			v_filterQueryString := v_filterQueryString ||' And SCOPE = '''||v_scope ||'''';
		END;
		END IF;
		
		--v_query := ' SELECT ProcessDefId, TaskId FROM ' || dblinkString || '.WFTASKDEFTABLE ' || v_filterQueryString;
		
		v_query := 'SELECT ProcessDefId,TaskId FROM public.dblink ($1,''SELECT ProcessDefId,TaskId FROM WFTASKDEFTABLE'') AS DATA(ProcessDefId INTEGER,TaskId INTEGER) ' || v_filterQueryString;
		
		--EXECUTE v_query into OQUEUEID using V_DBLINK;
		
		
		OPEN v_TableCursor FOR EXECUTE v_query using V_DBLINK;
		LOOP
			FETCH v_TableCursor INTO v_localProcessDefId,v_taskId;
			EXIT WHEN NOT FOUND;
			BEGIN 
				Select 'WFGenericData_'|| v_localProcessDefId||'_'||v_taskId INTO v_tableName;
				IF EXISTS(SELECT 1 FROM pg_class WHERE relname = v_tableName) THEN
					RAISE NOTICE 'Table Already exists on target Cabinet';
				ELSE
				BEGIN
					--v_createQuery := 'SELECT * INTO ' || v_tableName || ' FROM ' || dblinkString || '.' || v_tableName || ' WHERE 1 = 2';
					
					v_createQuery_Column := 'SELECT  column_Name_WithData FROM GetColStr('|| v_tableName ||') AS (column_Name varchar(4000), column_Name_WithData varchar(4000))';
					
					v_createQuery := 'SELECT column_Name_WithData FROM public.dblink ($1,$2) AS DATA(column_Name_WithData varchar(4000)';
					
					EXECUTE v_createQuery INTO CO_DATATYPE USING V_DBLINK , v_createQuery_Column;
					
					v_createQuery := 'SELECT * INTO $1 FROM (SELECT * FROM public.dblink ($2,''select * from pdbuser'') AS DATA(' || CO_DATATYPE || ')) as T';
					
					EXECUTE v_createQuery  USING v_tableName , V_DBLINK ;
					exception when others then 
					BEGIN
						INSERT INTO WFFailedMetaDataMigrationLog (executionLogId,actionDateTime,FailedProcessId,Remarks) VALUES (v_executionLogId,current_timestamp,v_processDefId,  'Error in Creating Task Data Tables On Target' || v_createQuery);
						Raise notice '% %', SQLERRM, SQLSTATE;
						Return;
					END;
				END;
				END IF;
				
			END;
			
		END LOOP;
		CLOSE v_TableCursor;
		DEALLOCATE v_TableCursor; 
	END;
	END;
                    
$function$;