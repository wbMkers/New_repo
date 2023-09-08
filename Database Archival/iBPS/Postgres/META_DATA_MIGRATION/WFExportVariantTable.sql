/*__________________________________________________________________________________;
            NEWGEN SOFTWARE TECHNOLOGIES LIMITED;

    Group                       : Phoenix;
    Product / Project           : IBPS;
    Module                      : IBPS Server;
    File Name                   : WFExportVariantTable.sql (Oracle)
    Author                      : Puneet Jaiswal
    Date written (DD/MM/YYYY)   : 26 NOV 2020
    Description                 : Stored procedure for Meta data Migration ;
____________________________________________________________________________________;
                        CHANGE HISTORY;
____________________________________________________________________________________;
Date        Change By        Change Description (Bug No. (IF Any))

____________________________________________________________________________________*/
create or replace Function WFExportVariantTable
  (
    v_sourceCabinet      VARCHAR,
    v_targetCabinet      VARCHAR,
    idblinkname          VARCHAR,
    v_processDefId 		INTEGER,
	v_processVariantId  INTEGER,
	V_DBLINK 			VARCHAR
	)
RETURNS void  LANGUAGE 'plpgsql' AS $function$  
 declare  v_query       VARCHAR(4000);
  v_queryStr    VARCHAR(4000);
  v_createQuery VARCHAR(4000);
	--v_VariantCursor   refcursor;

	v_processVariantName VARCHAR(255);

    --v_TableCursor refcursor;
    v_tableName  VARCHAR(256);
	v_transactionalTable VARCHAR(256);
    v_existsFlag INTEGER;
	v_existsFlagTable INTEGER;
	v_colStrQueueDefNew varchar(4000);
	v_colStrQueueDef_WithDataNew varchar(4000);
  BEGIN
    BEGIN
		v_query := 'SELECT ProcessVariantName FROM ' || v_sourceCabinet || '.public.' || 'WFProcessVariantDefTable where processdefid = '|| v_ProcessDefId || ' and ProcessVariantId = '||v_processVariantId ;
	  
		v_queryStr := 'SELECT VProcessVariantName FROM public.dblink (''$1'',''$2'') AS DATA(VProcessVariantName varchar(500))';
		
		EXECUTE v_queryStr INTO V_ProcessVariantName USING V_DBLINK , v_query; 
	  
    
		BEGIN
			v_tableName :='WFPV_'||  v_processVariantName;
			--v_queryStr:='SELECT 1 FROM DBA_Tables'||idblinkname||' WHERE TABLE_NAME='''||UPPER(v_tableName)||''' AND OWNER = '''||UPPER(v_sourceCabinet)||'''';
			
			v_query := 'select count(1) from pg_class where upper(relname) = upper('|| v_tableName || ')';
		
			v_queryStr := 'SELECT nrow FROM public.dblink ($1,$2) AS DATA(nrow INTEGER)';
			BEGIN
				EXECUTE v_queryStr INTO v_existsFlag USING V_DBLink , v_query;
				EXCEPTION 
					WHEN OTHERS THEN
					v_existsFlag := 0;
			END;
		  
		IF (v_existsFlag = 1) THEN
            
			v_query := 'select count(1) from pg_class where upper(relname) = upper('|| v_tableName || ')';
			
			EXECUTE v_query INTO v_existsFlagTable;
			IF(v_existsFlagTable = 0) THEN
            BEGIN
				v_query := 'SELECT v_colStrQueueDef, v_colStrQueueDef_WithData FROM GetColStr('|| v_tableName ||') AS (v_colStrQueueDef varchar(4000), v_colStrQueueDef_WithData varchar(4000))';
		
				v_queryStr := 'SELECT v_colStrQueueDef1, v_colStrQueueDef_WithData1 FROM public.dblink ($1,$2) AS DATA(v_colStrQueueDef1 VARCHAR(4000), v_colStrQueueDef_WithData1 VARCHAR(4000))';
				EXECUTE v_queryStr into v_colStrQueueDefNew, v_colStrQueueDef_WithDataNew USING V_DBLink , v_query;
				
				v_query := 'SELECT '|| v_colStrQueueDefNew || ' FROM ' || v_tableName || ' WHERE 1=2';
				 --v_createQuery :='CREATE TABLE '||v_tableName||' AS SELECT * FROM ' || v_sourceCabinet ||'.'||v_tableName||idblinkname||' WHERE 1=2';
				--EXECUTE IMMEDIATE v_createQuery;
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
         END IF;
        
        --CLOSE v_VariantCursor;
    END;
  END;
END;
$function$; 