/*__________________________________________________________________________________;
            NEWGEN SOFTWARE TECHNOLOGIES LIMITED;

    Group                       : Phoenix;
    Product / Project           : IBPS;
    Module                      : IBPS Server;
    File Name                   : WFChangeTriggersStatus.sql (Oracle)
    Author                      : Puneet Jaiswal
    Date written (DD/MM/YYYY)   : 20 NOV 2020
    Description                 : Stored procedure for Meta data Migration ;
____________________________________________________________________________________;
                        CHANGE HISTORY;
____________________________________________________________________________________;
Date        Change By        Change Description (Bug No. (IF Any))

____________________________________________________________________________________*/
create or replace
FUNCTION WFChangeTriggersStatus
  (
    v_sourceCabinet     VARCHAR,
    v_targetCabinet     VARCHAR,
    v_enableDisableFlag CHAR,
   -- idblinkname         VARCHAR ,
	V_DBLink VARCHAR
	)
RETURNS void  LANGUAGE 'plpgsql' AS $function$  
Declare 
  v_query     VARCHAR(4000);
  v_tableName VARCHAR(256);
  v_triggerCursor refcursor;
  v_queryStr 	VARCHAR(4000);
  BEGIN
    BEGIN
		-- v_query := 'SELECT TABLE_NAME FROM USER_TRIGGERS'||idblinkname||' where TABLE_OWNER =UPPER('''||v_sourceCabinet||''') AND '|| 'TABLE_NAME NOT IN ( ''PDBDOCUMENTCONTENT'', ''PDBDOCUMENT'', ''PDBUSER'' ,''PSREGISTERATIONTABLE'' , ''WFADMINLOGTABLE'')';
	  
		v_query := 'SELECT EVENT_OBJECT_TABLE FROM information_schema.triggers where upper(Trigger_catalog) = upper('''||v_sourceCabinet||''') AND EVENT_OBJECT_TABLE NOT IN (''PDBDOCUMENTCONTENT'', ''PDBDOCUMENT'', ''PDBUSER'' ,''PSREGISTERATIONTABLE'' , ''WFADMINLOGTABLE'')';
	  	
		v_queryStr := 'SELECT NTABLE_NAME FROM public.dblink ($1,$2) AS DATA(NTABLE_NAME VARCHAR(100))';
		
		--EXECUTE v_queryStr INTO v_existsHistoryFlag USING V_DBLink , v_query;
	  
	  
      
	  OPEN v_triggerCursor FOR EXECUTE v_queryStr USING V_DBLink , v_query;
      LOOP
        FETCH v_triggerCursor INTO v_tableName;
		EXIT WHEN NOT FOUND;
		IF(v_enableDisableFlag='D') THEN
        BEGIN
          v_query := 'Alter table ' || v_tableName||' DISABLE TRIGGER ALL ' ;
		  EXECUTE v_query;
			EXCEPTION
				WHEN OTHERS THEN
        				RAISE NOTICE ' ERROR IN DISABLE TRIGGER %',v_tableName;
        END ;
		ELSIF(v_enableDisableFlag='E') THEN
        BEGIN
          v_query := 'Alter table ' || v_tableName||' Enable TRIGGER ALL ' ;
          EXECUTE v_query;
        EXCEPTION
        WHEN OTHERS THEN
				RAISE NOTICE ' ERROR IN ENABLE TRIGGER %',v_tableName;
        END ;
      END IF;
    END LOOP;
	Close v_triggerCursor;
  EXCEPTION
  WHEN OTHERS THEN
    BEGIN
      RAISE;
    END;
  END;
END;
$function$ ;