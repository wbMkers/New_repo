/*__________________________________________________________________________________;
            NEWGEN SOFTWARE TECHNOLOGIES LIMITED;

    Group                       : Phoenix;
    Product / Project           : IBPS;
    Module                      : IBPS Server;
    File Name                   : WFMoveVariantMetaData.sql (Oracle)
    Author                      : Puneet Jaiswal
    Date written (DD/MM/YYYY)   : 18 NOV 2020
    Description                 : Stored procedure for Meta data Migration ;
____________________________________________________________________________________;
                        CHANGE HISTORY;
____________________________________________________________________________________;
Date        Change By        Change Description (Bug No. (IF Any))

____________________________________________________________________________________*/
CREATE OR REPLACE FUNCTION WFMoveVariantMetaData
  (
    v_sourceCabinet VARCHAR,
    v_targetCabinet VARCHAR,
    v_tableName     VARCHAR,
    v_processDefId		INTEGER,
	v_processVariantId  INTEGER,
    V_DBLINK     VARCHAR ,
	v_migrateAllData 	VARCHAR,
	v_copyForceFully    VARCHAR,
	v_existingVariantString VARCHAR,
	v_executionLogId	INTEGER
	)
RETURNS void  LANGUAGE 'plpgsql' AS $function$  
BEGIN
  DECLARE v_query      VARCHAR(4000);
  v_colStr     VARCHAR(4000);
  v_columnName VARCHAR(256);
  v_FilterQueryString VARCHAR(1000);
  v_ColumnCursor REFCURSOR;
  v_remarks VARCHAR(4000);
  v_colStrQueueDef_New varchar(4000);
  v_colStrQueueDef_WithData_New VARCHAR(4000);
  
  BEGIN
     -- SAVEPOINT Move_Meta_Data;
     
	v_query := 'SELECT v_colStrQueueDef, v_colStrQueueDef_WithData FROM GetColStr('|| v_tableName ||') AS (v_colStrQueueDef varchar(4000), v_colStrQueueDef_WithData varchar(4000))';
	
	EXECUTE v_query INTO v_colStrQueueDef_New , v_colStrQueueDef_WithData_New ; 
	
	IF(v_migrateAllData ='Y') THEN
		IF(v_copyForceFully ='Y') THEN
		 v_query := 'Truncate Table ' || v_targetCabinet || '.PUBLIC.' || v_tableName;
		 EXECUTE v_query;
		v_FilterQueryString:= ' WHERE 1=1';
		
		Else
		v_FilterQueryString:= ' WHERE ProcessVariantId not in ('||v_existingVariantString||')';
		END IF;
	ELSE
		v_FilterQueryString:= ' WHERE processDefId ='||v_processDefId ||' and processVariantId= '||v_processVariantId;
		IF(v_copyForceFully ='Y') THEN
		v_query := 'Delete FROM ' || v_targetCabinet || '.PUBLIC.' || v_tableName ||' Where processdefid = '||v_processDefId ||' and ProcessVariantId = '||v_processVariantId;
		EXECUTE v_query;
		END IF;
	END IF;
   /* v_query := 'INSERT INTO ' || v_targetCabinet || '.' || v_tableName||' ('||v_colStr||') SELECT '||v_colStr||' FROM ' || v_sourceCabinet || '.' || v_tableName||idblinkname||v_FilterQueryString;*/
   
		
		v_query := 'INSERT INTO $1 (SELECT * FROM public.dblink ($2,''select $3 from $4'') AS DATA( $5 )) as T';
		
		EXECUTE v_query  USING v_tableName , V_DBLINK , v_colStrQueueDef_New ,v_tableName ,v_colStrQueueDef_WithData_New;
		  
	insert into WFMetaDataMigrationProgressLog(executionLogId,actionDateTime,ProcessDefId,TableName,Status) values (v_ExecutionLogId,CURRENT_TIMESTAMP,v_processDefId, v_tableName,'Variant MetaData'||v_processVariantId );

  EXCEPTION  WHEN OTHERS THEN
    BEGIN
      ROLLBACK ;
	   v_remarks:= 'Error in metadata migration for variant id  '||v_processVariantId ||' and table '||v_tableName;
	   INSERT INTO WFFailedMetaDataMigrationLog (ExecutionLogId,actionDateTime,ProcessDefId,Status) VALUES (v_ExecutionLogId, Current_Timestamp, v_processDefId,v_remarks);
	   COMMIT;
      RAISE;
    END;
  END;
END;
$function$;  