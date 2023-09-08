	/*__________________________________________________________________________________;
		NEWGEN SOFTWARE TECHNOLOGIES LIMITED;
		Group                       : Genesis;
		Product / Project           : IBPS;
		Module                      : IBPS Server;
		File Name                   : WFMoveQueueData.sql (MSSQL)
		Author                      : Puneet Jaiswal
		Date written (DD/MM/YYYY)   : 25 NOV 2020
		Description                 : Stored Procedure To Move Queue Data
		____________________________________________________________________________________;
		CHANGE HISTORY;
		____________________________________________________________________________________;
		Date        Change By        Change Description (Bug No. (IF Any))
		____________________________________________________________________________________*/	
		
CREATE OR REPLACE FUNCTION WFMoveQueueData(v_sourceCabinet 	     VARCHAR(256),
		v_targetCabinet 	     VARCHAR(256),
		v_processDefId  	     INT,
		dblinkString     	     VARCHAR(256),
		v_migrateAllData 	     VARCHAR(1),
		v_copyForceFully 		 VARCHAR(1),
		v_existingProcessString VARCHAR(256),
		v_executionLogId		 INT,
		V_DBLINK VARCHAR(100) -- It will take name of the CREATE SERVER demodbrnd FOREIGN DATA WRAPPER
		) 
		RETURNS void  LANGUAGE 'plpgsql' AS $function$  
	
	
	BEGIN

		DECLARE v_query               	VARCHAR(2000);
		DECLARE v_tableName      		VARCHAR(256);
		DECLARE v_colStrQueueDef  		VARCHAR(4000);
		DECLARE v_colStrQueueUser 		VARCHAR(4000);
		DECLARE v_columnName      		VARCHAR(256);
		DECLARE v_FilterQueryString 	VARCHAR(1000);
		DECLARE v_queryParameter       VARCHAR(256);
		DECLARE value        			INT;
		DECLARE val						INT;
		DECLARE v_queueId				INT;
		DECLARE v_QueueCursor REFCURSOR;
		DECLARE v_colStrQueueDef_WithData VARCHAR(4000);
		DECLARE v_querystr 			VARCHAR(4000);
		DECLARE oqueueid 			INT;
		DECLARE existsflag 			INT;
		DECLARE v_colStrQueueDefNew	VARCHAR(4000);
		declare v_colStrQueueDef_WithDataNew VARCHAR(4000);
		

		BEGIN
		
			v_query := 'SELECT v_colStrQueueDef, v_colStrQueueDef_WithData FROM GetColStr('|| v_tableName ||') AS (v_colStrQueueDef varchar(4000), v_colStrQueueDef_WithData varchar(4000))';
			--EXECUTE GetColStr 'QueueDefTable' , v_columnStr = v_colStrQueueDef  OUTPUT;
			EXECUTE v_query into v_colStrQueueDefNew, v_colStrQueueDef_WithDataNew;
				IF( v_migrateAllData ='Y' ) THEN
				BEGIN
					IF( v_copyForceFully ='Y' ) THEN
					BEGIN
						---Truncating QUEUEDEFTABLE on target Cabinet
						--SELECT * FROM public.dblink (|| V_DBLINK || ,'Truncate table QueueDefTable') AS DATA (post varchar);
						v_query := 'Truncate Table ' || v_targetCabinet || '.PUBLIC.' || v_tableName;
						EXECUTE v_query;
						SELECT v_FilterQueryString = ' WHERE 1 = 1 ';
					END;
					ELSE
					BEGIN
						SELECT v_FilterQueryString = ' WHERE PROCESSDEFID NOT IN ( ' || v_existingProcessString || ')';
					END;
					END IF;
				END;
				ELSE
				BEGIN
					SELECT v_FilterQueryString = ' WHERE PROCESSDEFID = ' || v_processDefId ;
					IF( v_copyForceFully ='Y' ) THEN
					BEGIN
						
						v_querystr := 'SELECT QUEUEID FROM public.dblink ($1,''SELECT QUEUEID FROM public.QUEUESTREAMTABLE'') AS DATA(QUEUEID INTEGER)'|| v_FilterQueryString;	
						RAISE NOTICE ' v_querystr %',v_querystr;
						EXECUTE v_querystr into OQUEUEID using V_DBLINK;		
						
						
						v_querystr := 'DELETE FROM $1 QUEUEDEFTABLE WHERE QUEUEID IN ( $2 )';
						EXECUTE v_querystr USING v_targetCabinet, OQUEUEID;
						IF (NOT FOUND) THEN
							RETURN;
						END IF;	
					END;
					END IF;
				END;
			
			
				v_query := 'SELECT QUEUEID FROM public.dblink ($1,''SELECT DISTINCT QUEUEID FROM public.QUEUESTREAMTABLE'') AS DATA(QUEUEID INTEGER)'|| v_FilterQueryString;	
				--EXECUTE v_query into OQUEUEID using V_DBLINK;	
				--OPEN v_QueueCursor FOR EXECUTE v_query;
				OPEN v_QueueCursor FOR EXECUTE v_query using V_DBLINK;
				LOOP
					FETCH v_QueueCursor INTO v_queueId;
					EXIT WHEN NOT FOUND;
					BEGIN 
						--v_query := ' SELECT  COUNT(*) FROM ' || v_targetCabinet || '.public.QueueDefTable WHERE QUEUEID = ' || v_queueId;
						--EXECUTE v_query into val; 
						--If ( val = 0 )
						BEGIN
							Raise Notice 'columnstr>.';
							Raise Notice 'v_colStrQueueDef %', v_colStrQueueDefNew;
							v_tableName:='QUEUEDEFTABLE';
							v_queryStr:= 'Select Count(*) from '|| v_targetCabinet || '.' || v_tableName||' where QueueId = '|| v_queueId;
							Execute v_queryStr into existsFlag;
							IF(existsFlag = 0 ) then
							
							/*v_query := 'INSERT INTO ' || v_targetCabinet || '.' || v_tableName||' ('||v_colStrQueueDef||') SELECT '|| v_colStrQueueDef||' FROM public.dblink (' || V_DBLINK || ', ''SELECT '||v_colStrQueueDef||' FROM ' || v_tableName ||' WHERE QUEUEID= '||v_queueId'') 'AS DATA('|| v_colStrQueueDef_WithData ||);*/
							
							v_query := 'INSERT INTO ' || v_targetCabinet || '.public.' || v_tableName||' ('||v_colStrQueueDefNew||') SELECT '|| v_colStrQueueDefNew||' FROM public.dblink (''' || V_DBLINK || ''', ''SELECT '||v_colStrQueueDefNew||' FROM ' || v_tableName ||' WHERE QUEUEID= '||v_queueId ||''') AS DATA('|| v_colStrQueueDef_WithDataNew ||')';
							
							RAISE nOTICE 'v_query %',v_query;
							
							EXECUTE v_query;
							END IF;
						END;
						--END IF;
					END;
				END LOOP;	
					
					INSERT INTO WFMetaDataMigrationProgressLog(executionLogId,actionDateTime,ProcessId,tableName,Remarks) VALUES (v_executionLogId,current_timestamp,0,NULL,'[WFMoveQueueData] Queue Data Migrated For queue-->' || v_queueId))
				END
				CLOSE v_QueueCursor ;
				
	END;
$function$;		
	