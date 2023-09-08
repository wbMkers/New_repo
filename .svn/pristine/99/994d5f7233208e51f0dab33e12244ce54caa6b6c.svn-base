/*__________________________________________________________________________________;
            NEWGEN SOFTWARE TECHNOLOGIES LIMITED;

    Group                       : Phoenix;
    Product / Project           : IBPS;
    Module                      : IBPS Server;
    File Name                   : WFMoveProcessData.sql (Oracle)
    Author                      : Puneet Jaiswal
    Date written (DD/MM/YYYY)   : 25 NOV 2020
    Description                 : Stored procedure for Meta data Migration ;
____________________________________________________________________________________;
                        CHANGE HISTORY;
____________________________________________________________________________________;
Date        Change By        Change Description (Bug No. (IF Any))

____________________________________________________________________________________*/
create or replace
Function WFMoveProcessData
  (
    v_sourceCabinet VARCHAR,
    v_targetCabinet VARCHAR,
    v_tableName     VARCHAR,
    idblinkname     VARCHAR,
	v_overRideCabinetData	VARCHAR,
	v_ExecutionLogId	INTEGER
 )
RETURNS void  LANGUAGE 'plpgsql' AS $function$ 
BEGIN
 DECLARE v_query      VARCHAR(4000);
  v_colStr     VARCHAR(4000);
  v_columnName VARCHAR(256);
  existsFlag   INTEGER;
	v_remarks VARCHAR(4000);
	v_colStrQueueDefNew VARCHAR(4000);
	v_colStrQueueDef_WithDataNew VARCHAR(4000);
  
    BEGIN
      --SAVEPOINT Migrate_Process_Data;
	  
	v_query := 'SELECT v_colStrQueueDef, v_colStrQueueDef_WithData FROM GetColStr('|| v_tableName ||') AS (v_colStrQueueDef varchar(4000), v_colStrQueueDef_WithData varchar(4000))';
			--EXECUTE GetColStr 'QueueDefTable' , v_columnStr = v_colStrQueueDef  OUTPUT;
	EXECUTE v_query into v_colStrQueueDefNew, v_colStrQueueDef_WithDataNew; 
	 
    If(v_overRideCabinetData='Y') then
    begin
	v_query := 'TRUNCATE TABLE ' || v_targetCabinet || '.Public.' || v_tableName||'' ;
    EXECUTE v_query;
	
   	v_query := 'INSERT INTO ' || v_targetCabinet || '.public.' || v_tableName||' ('||v_colStrQueueDef||') SELECT '|| v_colStrQueueDef||' FROM public.dblink (''' || V_DBLINK || ''', ''SELECT '||v_colStrQueueDef||' FROM ' || v_tableName ||''') AS DATA('|| v_colStrQueueDef_WithData ||')';
	
    EXECUTE v_query;
    
	v_query := 'UPDATE ' || v_targetCabinet || '.WFPROCESSTABLELIST SET dataMigrationSuccessful = ''Y'' WHERE tableName = ''' || v_tableName || '''';
    EXECUTE v_query;
	insert into WFMetaDataMigrationProgressLog(executionLogId,actionDateTime,ProcessDefId,TableName,Status) values (v_ExecutionLogId,CURRENT_TIMESTAMP,0, v_tableName,'Cabinet Level MetaData');
	end;
	else
		v_query := 'Select count(*) from ' || v_targetCabinet || '.Public.' || v_tableName||'' ;
		EXECUTE v_query into existsFlag;
		  IF(existsFlag = 0 ) then
		
		/*v_query := 'INSERT INTO ' || v_targetCabinet || '.Public.' || v_tableName||' ('||v_colStrQueueDef||') SELECT '||v_colStr||' FROM ' || v_sourceCabinet || '.' || v_tableName||idblinkname||'' ;*/
		v_query := 'INSERT INTO ' || v_targetCabinet || '.public.' || v_tableName||' ('||v_colStrQueueDef||') SELECT '|| v_colStrQueueDef||' FROM public.dblink (''' || V_DBLINK || ''', ''SELECT '||v_colStrQueueDef||' FROM ' || v_tableName ||''') AS DATA('|| v_colStrQueueDef_WithData ||')';
		
		EXECUTE v_query;
		insert into WFMetaDataMigrationProgressLog(executionLogId,actionDateTime,ProcessDefId,TableName,Status) values (v_ExecutionLogId,CURRENT_TIMESTAMP,0, v_tableName,'Cabinet Level MetaData');
		  END IF;
	END IF;
	
	--DBMS_OUTPUT.PUT_LINE ('Data moved for '|| v_tableName);
  EXCEPTION
  WHEN OTHERS THEN
    BEGIN
      ROLLBACK ;
	  v_remarks:= 'Error in Cabinet level metadata migration for table '||v_tableName;
    
	   INSERT INTO WFFailedMetaDataMigrationLog(ExecutionLogId,actionDateTime,ProcessDefId,Status) VALUES (v_ExecutionLogId, Current_Timestamp, 0,v_remarks);
     
	   commit;
      RAISE;
    END;
  END;
END;
$function$ ;