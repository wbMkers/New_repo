	/*__________________________________________________________________________________;
            NEWGEN SOFTWARE TECHNOLOGIES LIMITED;

    Group                       : Phoenix;
    Product / Project           : IBPS;
    Module                      : IBPS Server;
    File Name                   : WFExportExternalTable.sql (Oracle)
    Author                      : Mohnish Chopra
    Date written (DD/MM/YYYY)   : 14 MAY 2014
    Description                 : Stored procedure for Meta data Migration ;
____________________________________________________________________________________;
                        CHANGE HISTORY;
____________________________________________________________________________________;
Date        Change By        Change Description (Bug No. (IF Any))

____________________________________________________________________________________*/
create or replace
Function WFExportExternalTable
  (
    v_sourceCabinet VARCHAR,
    v_targetCabinet VARCHAR,
    idblinkname     VARCHAR,
    v_processDefId  INTEGER,
	v_migrateAllData VARCHAR
)
  RETURNS void  LANGUAGE 'plpgsql' AS $function$  
 BEGIN 
 DECLARE v_query       VARCHAR(4000);
  v_queryStr    VARCHAR(4000);
  v_createQuery VARCHAR(4000);
  v_filterQueryString VARCHAR(1000);
  v_ddlQuery VARCHAR(4000);
  v_executeDDLQuery VARCHAR(32767);
/*TYPE TableCursor
IS
  REF
  CURSOR;
    v_TableCursor TableCursor;*/
	v_TableCursor   refcursor;
    v_tableName          VARCHAR(256);
	v_externalHistoryTable	VARCHAR(256);
    v_transactionalTable VARCHAR(256);
    v_existsFlag         INTEGER;
	v_existsHistoryFlag 	INTEGER;
	v_existsFlagTable    INTEGER;
	v_colStrQueueDefNew VARCHAR(4000);
	v_colStrQueueDef_WithDataNew VARCHAR(4000);
  BEGIN --1
    v_transactionalTable:='WFINSTRUMENTTABLE';
	IF(v_migrateAllData ='Y') THEN
	v_filterQueryString := ' ';
	Else 
	v_filterQueryString := ' WHERE PROCESSDEFID= '|| v_ProcessDefId;
	END IF;
	
	
	
	v_query  := 'SELECT TABLENAME FROM ' || v_sourceCabinet || '.public.' || 'EXTDBCONFTABLE ' || v_filterQueryString;
	
	v_queryStr := 'SELECT LV_TableName FROM public.dblink ($1,$2) AS DATA(LV_TableName VARCHAR(256))';
	
    OPEN v_TableCursor FOR EXECUTE v_queryStr using V_DBLink , v_query;
    LOOP
		FETCH v_TableCursor INTO v_tableName;
		EXIT WHEN NOT FOUND;
  
		v_externalHistoryTable:=v_tableName||'_history';
		
		v_query := 'select count(1) from pg_class where upper(relname) = upper('|| v_tableName || ')';
		
		v_queryStr := 'SELECT nrow FROM public.dblink ($1,$2) AS DATA(nrow INTEGER)';
		
		BEGIN --2
			EXECUTE v_queryStr INTO v_existsFlag USING V_DBLink , v_query;
			EXCEPTION
					WHEN OTHERS THEN
				v_existsFlag := 0;
		END;--2
		
	/*	v_queryStr:='SELECT 1 FROM DBA_Tables'||idblinkname||' WHERE TABLE_NAME='''||UPPER(v_externalHistoryTable)||''' AND OWNER = '''||UPPER(v_sourceCabinet)||'''';*/
		
		v_query := 'select count(1) from pg_class where upper(relname) = upper('|| v_externalHistoryTable || ')';
		
		v_queryStr := 'SELECT nrow FROM public.dblink ($1,$2) AS DATA(nrow INTEGER)';
		
		BEGIN --2
			EXECUTE v_queryStr INTO v_existsHistoryFlag USING V_DBLink , v_query;
			EXCEPTION
				WHEN OTHERS THEN
				v_existsHistoryFlag := 0;
		END;--2
	
    IF (v_existsFlag = 1) THEN
      
		BEGIN--b
			
			v_query := 'select count(1) from pg_class where upper(relname) = upper('|| v_tableName || ')';
			
			EXECUTE v_query INTO v_existsFlagTable;
			IF(v_existsFlagTable = 0) THEN
			BEGIN
				v_query := 'SELECT v_colStrQueueDef, v_colStrQueueDef_WithData FROM GetColStr('|| v_tableName ||') AS (v_colStrQueueDef varchar(4000), v_colStrQueueDef_WithData varchar(4000))';
		
				v_queryStr := 'SELECT v_colStrQueueDef1, v_colStrQueueDef_WithData1 FROM public.dblink ($1,$2) AS DATA(v_colStrQueueDef1 VARCHAR(4000), v_colStrQueueDef_WithData1 VARCHAR(4000))';
				EXECUTE v_queryStr into v_colStrQueueDefNew, v_colStrQueueDef_WithDataNew USING V_DBLink , v_query;
				
				/*v_query := 'SELECT count(1) from pg_class where upper(relname) = upper('|| v_externalHistoryTable || ')';
				
				v_queryStr := 'SELECT nrow FROM public.dblink ($1,$2) AS DATA(nrow INTEGER)';*/
				
				v_query := 'SELECT '|| v_colStrQueueDefNew || ' FROM ' || v_tableName || ' WHERE 1=2';
				
				v_createQuery :=  'CREATE TABLE $1 AS SELECT * FROM public.dblink ($2,$3) AS DATA(v_colStrQueueDef_WithDataNew VARCHAR(4000))';
				
				EXECUTE v_createQuery USING v_tableName , V_DBLink , v_query;
				EXCEPTION 
		  		  WHEN Others then 
				  RAISE NOTICE 'Error in creating table  %',v_tableName;
			END;
			ELSE
			BEGIN
				 RAISE NOTICE 'Table % already exists' , v_tableName ;
			END;
			END IF;	
				
		END; --b
    END IF;
	IF (v_existsHistoryFlag = 1) THEN
		BEGIN--b
		
			v_query := 'select count(1) from pg_class where upper(relname) = upper('|| v_externalHistoryTable || ')';
			
			EXECUTE v_query INTO v_existsFlagTable;
			IF(v_existsFlagTable = 0) THEN
			BEGIN
				v_query := 'SELECT v_colStrQueueDef, v_colStrQueueDef_WithData FROM GetColStr('|| v_externalHistoryTable ||') AS (v_colStrQueueDef varchar(4000), v_colStrQueueDef_WithData varchar(4000))';
		
				v_queryStr := 'SELECT v_colStrQueueDef1, v_colStrQueueDef_WithData1 FROM public.dblink ($1,$2) AS DATA(v_colStrQueueDef1 VARCHAR(4000), v_colStrQueueDef_WithData1 VARCHAR(4000))';
				EXECUTE v_queryStr into v_colStrQueueDefNew, v_colStrQueueDef_WithDataNew USING V_DBLink , v_query;
				
				/*v_query := 'SELECT count(1) from pg_class where upper(relname) = upper('|| v_externalHistoryTable || ')';
				
				v_queryStr := 'SELECT nrow FROM public.dblink ($1,$2) AS DATA(nrow INTEGER)';*/
				
				v_query := 'SELECT '|| v_colStrQueueDefNew || ' FROM ' || v_externalHistoryTable || ' WHERE 1=2';
				
				v_createQuery :=  'CREATE TABLE $1 AS SELECT * FROM public.dblink ($2,$3) AS DATA(v_colStrQueueDef_WithDataNew VARCHAR(4000))';
				
				EXECUTE v_createQuery USING v_externalHistoryTable , V_DBLink , v_query;
				EXCEPTION 
		  		  WHEN Others then 
				  RAISE NOTICE 'Error in creating table  %',v_externalHistoryTable;
			END;
			ELSE
			BEGIN
				 RAISE NOTICE 'Table % already exists' , v_externalHistoryTable ;
			END;
			END IF;
		
		END; --b
    END IF;
  END LOOP;
  CLOSE v_TableCursor;
END;--1
END;
$function$  ;