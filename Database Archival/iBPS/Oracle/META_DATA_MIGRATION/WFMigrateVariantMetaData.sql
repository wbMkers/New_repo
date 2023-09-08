/*__________________________________________________________________________________;
            NEWGEN SOFTWARE TECHNOLOGIES LIMITED;

    Group                       : Phoenix;
    Product / Project           : IBPS;
    Module                      : IBPS Server;
    File Name                   : WFMigrateVariantMetaData.sql (Oracle)
    Author                      : Mohnish Chopra
    Date written (DD/MM/YYYY)   : 14 MAY 2014
    Description                 : Stored procedure for Meta data Migration ;
____________________________________________________________________________________;
                        CHANGE HISTORY;
____________________________________________________________________________________;
Date        Change By        Change Description (Bug No. (IF Any))

____________________________________________________________________________________*/
CREATE OR REPLACE
PROCEDURE WFMigrateVariantMetaData
  (
    v_sourceCabinet    VARCHAR2,
    v_targetCabinet    VARCHAR2,
    idblinkname        VARCHAR2,
    v_processDefId     INTEGER ,
    v_processVariantId INTEGER,
    v_migrateAllData   VARCHAR2,
    v_copyForceFully   VARCHAR2,
	v_executionLogId	INTEGER
	)
AS
  v_query                    VARCHAR2(4000);
  v_queryStr                 VARCHAR2(2000);
  v_queryStr2                VARCHAR2(2000);
  v_importedFlag             INT;
  v_migratedflag             INT;
  v_existsflag               INT;
  v_tableId                  INTEGER;
  v_tableName                VARCHAR2(256);
  v_isVariantTable           VARCHAR2(1);
  v_dataMigrationSuccessful  VARCHAR2(1);
  v_existingVariantString    VARCHAR2(2000);
  v_existingProcessVariantId INTEGER;
TYPE TableNameCursor
IS
  REF
  CURSOR;
    v_TableNameCursor TableNameCursor;
  TYPE processVariantCursor
IS
  REF
  CURSOR;
    v_processVariantCursor processVariantCursor;
    v_processVariantName VARCHAR2(255);
    v_transactionalTable VARCHAR2(256);
  BEGIN --1
    v_query                 :='Select ProcessVariantId from ' || v_targetCabinet || '.WFProcessVariantDefTable ';
    v_existingVariantString := '-1,';
    OPEN v_processVariantCursor FOR TO_CHAR(v_query);
    LOOP
      FETCH v_processVariantCursor INTO v_existingProcessVariantId;
    EXIT
  WHEN v_processVariantCursor%NOTFOUND;
    v_existsFlag           := 0;
    v_existingVariantString:=v_existingVariantString||v_existingProcessVariantId||',';
  END LOOP;
  v_existingVariantString:=trim(trailing ',' FROM v_existingVariantString);
  CLOSE v_processVariantCursor;
  v_query           := 'SELECT * FROM ' || v_targetCabinet || '.WFMETADATATABLELIST where isVariantTableFlag = ''Y''';
  IF(v_migrateAllData='N') THEN --For Migrating all metadata Check 1
    BEGIN                       --3
      v_migratedflag:=0;
      SELECT 1
      INTO v_migratedflag
      FROM WFProcessVariantDefTable
      WHERE ProcessDefId   = v_processdefid
      AND ProcessVariantId = v_processVariantId;
    EXCEPTION
    WHEN OTHERS THEN
      v_migratedflag := 0;
    END; --3
    IF(v_migratedflag =1) THEN
      dbms_output.put_line('Variant '||v_processVariantId||' Already Exists ');
	  --RETURN;
    END IF;
    /*BEGIN--4
      v_migratedflag:=0;
      SELECT 1
      INTO v_migratedflag
      FROM SuccessfulMigratedMetaData
      WHERE ProcessDefId   = v_processdefid
      AND ProcessVariantId = v_processVariantId;
    EXCEPTION
    WHEN OTHERS THEN
      v_migratedflag := 0;
    END; --4 */
	
	END IF;   --For Migrating all metadata Check 1
    IF(v_migratedflag =1) THEN
      dbms_output.put_line(' ');
    ELSE    -- Not yet Migrated
	  IF(v_migrateAllData='N') THEN --For Migrating all metadata Check 2

      BEGIN --5
        v_existsflag:=0;
        v_queryStr2 :='Select 1 from '|| v_sourcecabinet||'.WFProcessVariantDefTable'|| idblinkname||' WHERE ProcessDefId ='|| v_processdefid ||' and ProcessVariantId ='||v_processVariantId ;
        EXECUTE Immediate v_querystr2 INTO v_existsflag;
      EXCEPTION
      WHEN OTHERS THEN
        v_existsflag:= 0;
      END; --5
		  IF(v_existsflag=0) THEN
			dbms_output.put_line('Process variant '||v_processVariantId||' Does not Exists ');
			RETURN;
		  END IF;
	 END IF; --For Migrating all metadata
    OPEN v_TableNameCursor FOR TO_CHAR(v_query);
    LOOP
      FETCH v_TableNameCursor
      INTO v_tableId,
        v_tableName,
        v_isVariantTable,
        v_dataMigrationSuccessful;
      EXIT
    WHEN v_TableNameCursor%NOTFOUND;
      v_existsFlag := 0;
      BEGIN --6
        SELECT 1
        INTO v_existsFlag
        FROM DBA_Tables
        WHERE TABLE_NAME    = UPPER(v_tableName)
        AND OWNER = UPPER(v_targetCabinet);
      EXCEPTION
      WHEN OTHERS THEN
        v_existsFlag := 0;
      END; --6
      IF (v_existsFlag = 1) THEN
        WFMoveVariantMetaData(v_sourceCabinet ,v_targetCabinet ,v_tableName,v_processDefId,v_processVariantId,idblinkname,v_migrateAllData,v_copyForcefully,v_existingVariantString,v_executionLogId);
        DBMS_OUTPUT.PUT_LINE('Metadata successfully migrated for Variant '|| v_processVariantId);
      END IF;
      --WFExportVariantTable(v_sourceCabinet, v_targetCabinet, idblinkname,v_processDefId,v_processVariantId);
    END LOOP;
    CLOSE v_TableNameCursor;
  END IF; --  Not yet Migrated
END;