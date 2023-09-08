/*__________________________________________________________________________________;
            NEWGEN SOFTWARE TECHNOLOGIES LIMITED;

    Group                       : Phoenix;
    Product / Project           : IBPS;
    Module                      : IBPS Server;
    File Name                   : WFMoveMetaData.sql (Oracle)
    Author                      : Puneet Jaiswal
    Date written (DD/MM/YYYY)   : 18 NOVEMBER 2020
    Description                 : Stored procedure for Meta data Migration ;
____________________________________________________________________________________;
                        CHANGE HISTORY;
____________________________________________________________________________________;
Date        Change By        Change Description (Bug No. (IF Any))

____________________________________________________________________________________*/
create or replace FUNCTION  WFMoveMetaData
  (
    v_sourceCabinet VARCHAR,
    v_targetCabinet VARCHAR,
    v_tableName     VARCHAR,
    v_processDefId  INTEGER,
    idblinkname     VARCHAR,
	v_migrateAllData VARCHAR,
	v_copyForceFully VARCHAR,
	v_existingProcessString VARCHAR,
  v_ExecutionLogId INTEGER
  )
  RETURNS void  LANGUAGE 'plpgsql' AS $function$  
BEGIN
	Declare v_query      VARCHAR(4000);
	v_colStr     VARCHAR(4000);
	v_FilterQueryString VARCHAR(1000);
	v_columnName VARCHAR(256);
	v_ColumnCursor refcursor;
	v_remarks VARCHAR(4000);
	v_queueId				INT;
	v_QueueCursor REFCURSOR;
	v_colStrQueueDef_WithData VARCHAR(4000);
	v_querystr 			VARCHAR(4000);
	oqueueid 			INT;
	existsflag 			INT;
    BEGIN
     -- SAVEPOINT Move_Meta_Data;
    --  v_query := 'SELECT COLUMN_NAME FROM DBA_TAB_COLUMNS WHERE UPPER(TABLE_NAME) = UPPER(''' || v_tableName || ''') AND OWNER = UPPER(''' || v_targetCabinet || ''')';
		SELECT v_colStrQueueDef, v_colStrQueueDef_WithData FROM GetColStr('pdbUSER') AS (v_colStrQueueDef varchar(4000), v_colStrQueueDef_WithData varchar(4000));
		
		IF(v_migrateAllData ='Y') THEN
		BEGIN
			IF(v_copyForceFully ='Y') THEN
			BEGIN	
				v_query := 'Truncate Table ' || v_targetCabinet || '.PUBLIC.' || v_tableName;
				EXECUTE v_query;
				v_FilterQueryString:= ' WHERE 1=1';
			END;
			Else
				v_FilterQueryString:= ' WHERE processdefid not in ('||v_existingProcessString||')';
			END IF;
		END;
		ELSE 
		BEGIN
			IF(v_copyForceFully ='Y') THEN
			BEGIN
				v_query := 'Delete FROM ' || v_targetCabinet || '.PUBLIC.' || v_tableName ||' Where processdefid = '||v_processDefId;
				EXECUTE v_query;
			END;
			END IF;
		v_FilterQueryString:= ' WHERE PROCESSDEFID= '||v_processDefId;
		END;
		END IF;
    
	
	v_query := 'INSERT INTO ' || v_targetCabinet || '.public.' || v_tableName||' ('||v_colStrQueueDef||') SELECT '|| v_colStrQueueDef||' FROM public.dblink (''' || V_DBLINK || ''', ''SELECT '||v_colStrQueueDef||' FROM ' || v_tableName ||' WHERE QUEUEID= '||v_queueId ||''') AS DATA('|| v_colStrQueueDef_WithData ||')';
	
	RAISE NOTICE 'v_query LINE 75 %',v_query;
	
	EXECUTE v_query;
	
	/*v_query := 'INSERT INTO ' || v_targetCabinet || '.' || v_tableName||' ('||v_colStr||') SELECT '||v_colStr||' FROM ' || v_sourceCabinet || '.' || v_tableName||idblinkname||v_FilterQueryString;
    EXECUTE v_query;*/
    
  	insert into WFMetaDataMigrationProgressLog(executionLogId,actionDateTime,ProcessDefId,TableName,Status )values(v_ExecutionLogId, current_timestamp,v_processDefId, v_tableName,'Process MetaData');
  EXCEPTION WHEN OTHERS THEN
    BEGIN
		ROLLBACK ;
			v_remarks:= 'Error in metadata migration for processdefid '||v_processdefid ||' and table '||v_tableName;
			INSERT INTO WFFailedMetaDataMigrationLog (ExecutionLogId,actionDateTime,ProcessDefId,Status) VALUES (v_ExecutionLogId, Current_Timestamp, v_processDefId,v_remarks);
			commit;
		RAISE;
    END;
  END;
END;
$function$;	
