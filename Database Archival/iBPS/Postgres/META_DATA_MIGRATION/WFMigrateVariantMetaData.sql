/*__________________________________________________________________________________;
            NEWGEN SOFTWARE TECHNOLOGIES LIMITED;

    Group                       : Phoenix;
    Product / Project           : IBPS;
    Module                      : IBPS Server;
    File Name                   : WFMigrateVariantMetaData.sql (Oracle)
    Author                      : Puneet Jaiswal
    Date written (DD/MM/YYYY)   : 26 NOV 2020
    Description                 : Stored procedure for Meta data Migration ;
____________________________________________________________________________________;
                        CHANGE HISTORY;
____________________________________________________________________________________;
Date        Change By        Change Description (Bug No. (IF Any))

____________________________________________________________________________________*/
CREATE OR REPLACE FUNCTION WFMigrateVariantMetaData
  (
    v_sourceCabinet    VARCHAR,
    v_targetCabinet    VARCHAR,
    v_dblink        VARCHAR,
    v_processDefId     INTEGER ,
    v_processVariantId INTEGER,
    v_migrateAllData   VARCHAR,
    v_copyForceFully   VARCHAR,
	v_executionLogId	INTEGER
	)
RETURNS void  LANGUAGE 'plpgsql' AS $function$ 
BEGIN
  declare v_query                    VARCHAR(4000);
  v_queryStr                 VARCHAR(2000);
  v_queryStr2                VARCHAR(2000);
  v_importedFlag             INT;
  v_migratedflag             INT;
  v_existsflag               INT;
  v_tableId                  INTEGER;
  v_tableName                VARCHAR(256);
  v_isVariantTable           VARCHAR(1);
  v_dataMigrationSuccessful  VARCHAR(1);
  v_existingVariantString    VARCHAR(2000);
  v_existingProcessVariantId INTEGER;
/*TYPE TableNameCursor
IS
  REF
  CURSOR;*/
    v_TableNameCursor refcursor;
 /* TYPE processVariantCursor
IS
  REF
  CURSOR;*/
    v_processVariantCursor refcursor;
    v_processVariantName VARCHAR(255);
    v_transactionalTable VARCHAR(256);
	nv_query 			varchar(4000);
  BEGIN --1
    v_query  :='Select ProcessVariantId from ' || v_targetCabinet || '.PUBLIC.WFProcessVariantDefTable ';
    v_existingVariantString := '-1,';
    OPEN v_processVariantCursor FOR EXECUTE v_query;
    LOOP
		FETCH v_processVariantCursor INTO v_existingProcessVariantId;
		EXIT WHEN NOT FOUND;
		v_existsFlag           := 0;
		v_existingVariantString:=v_existingVariantString||v_existingProcessVariantId||',';
	END LOOP;
	--v_existingVariantString:=trim(trailing ',' FROM v_existingVariantString);
	v_existingVariantString:=trim(trailing FROM v_existingVariantString);
  CLOSE v_processVariantCursor;
  
	v_query  := 'SELECT * FROM ' || v_targetCabinet || '.public.WFMETADATATABLELIST where isVariantTableFlag = ''Y''';
	IF(v_migrateAllData='N') THEN --For Migrating all metadata Check 1
    BEGIN                       --3
		v_migratedflag:=0;
		SELECT 1 INTO v_migratedflag FROM WFProcessVariantDefTable WHERE ProcessDefId   = v_processdefid
		AND ProcessVariantId = v_processVariantId;
		EXCEPTION
			WHEN OTHERS THEN
			v_migratedflag := 0;
    END; --3
	
    IF(v_migratedflag =1) THEN
		Raise Notice 'Variant % Already Exists' , ||v_processVariantId||;
	  --RETURN;
    END IF;
    
	END IF;   --For Migrating all metadata Check 1
    IF(v_migratedflag =	1) THEN
      Raise Notice 'v_migratedflag is 1 ';
    ELSE    -- Not yet Migrated
		IF(v_migrateAllData='N') THEN --For Migrating all metadata Check 2

		BEGIN --5
			v_existsflag:=0;
			--v_queryStr2 :='Select 1 from '|| v_sourcecabinet||'.WFProcessVariantDefTable'|| idblinkname||' WHERE ProcessDefId ='|| v_processdefid ||' and ProcessVariantId ='||v_processVariantId ;
			
			nv_query  := 'Select count(1) from WFProcessVariantDefTable WHERE ProcessDefId ='|| v_processdefid ||' and ProcessVariantId ='||v_processVariantId;
	
			v_queryStr2 := 'SELECT NROWNUM FROM public.dblink ($1,$2) AS DATA(NROWNUM INTEGER)';
			
			
			EXECUTE  v_querystr2 INTO v_existsflag using v_dblink , nv_query;
			EXCEPTION
				WHEN OTHERS THEN
				v_existsflag:= 0;
		END; --5
		IF(v_existsflag=0) THEN
			Raise Notice 'Process variant  % Does not Exists',|| v_processVariantId ;
			RETURN;
		END IF;
		END IF; --For Migrating all metadata
    OPEN v_TableNameCursor FOR EXECUTE v_query;
    LOOP
		FETCH v_TableNameCursor INTO v_tableId,  v_tableName, v_isVariantTable, v_dataMigrationSuccessful;
		EXIT WHEN NOT FOUND;
		v_existsFlag := 0;
		BEGIN --6
			--SELECT 1 INTO v_existsFlag FROM DBA_Tables WHERE TABLE_NAME    = UPPER(v_tableName) AND OWNER = UPPER(v_targetCabinet);
			SELECT COUNT (1) INTO v_existsFlag FROM PG_CLASS WHERE upper(relname) = UPPER(v_tableName);
			EXCEPTION 
				WHEN OTHERS THEN
					v_existsFlag := 0;
		END; --6
		IF (v_existsFlag = 1) THEN
		begin
			SELECT WFMoveVariantMetaData(v_sourceCabinet ,v_targetCabinet ,v_tableName,v_processDefId,v_processVariantId,v_dblink,v_migrateAllData,v_copyForcefully,v_existingVariantString,v_executionLogId);
			RAISE Notice 'Metadata successfully migrated for Variant % ', v_processVariantId;
		end;	
		END IF;
      --WFExportVariantTable(v_sourceCabinet, v_targetCabinet, idblinkname,v_processDefId,v_processVariantId);
    END LOOP;
    CLOSE v_TableNameCursor;
  END IF; --  Not yet Migrated
END;
END;
$function$ ;