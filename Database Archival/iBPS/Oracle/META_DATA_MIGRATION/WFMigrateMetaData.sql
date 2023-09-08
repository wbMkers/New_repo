/*__________________________________________________________________________________;
            NEWGEN SOFTWARE TECHNOLOGIES LIMITED;

    Group                       : Phoenix;
    Product / Project           : IBPS;
    Module                      : IBPS Server;
    File Name                   : WFMigrateMetaData.sql (Oracle)
    Author                      : Mohnish Chopra
    Date written (DD/MM/YYYY)   : 14 MAY 2014
    Description                 : Stored procedure for Meta data Migration ;
____________________________________________________________________________________;
                        CHANGE HISTORY;
____________________________________________________________________________________;
Date        Change By        Change Description (Bug No. (IF Any))

____________________________________________________________________________________*/
create or replace
PROCEDURE WFMigrateMetaData
  (
    v_sourceCabinet VARCHAR2,
    v_targetCabinet VARCHAR2,
	v_isDBLink		VARCHAR2,
    idblinkname     VARCHAR2,
    tableVariableMap Process_Variant_Tab_Var,
	v_migrateAllData VARCHAR2,
	v_copyForceFully VARCHAR2,
	v_overRideCabinetData	VARCHAR2,
	v_moveTaskData      VARCHAR2
  )
AS
  v_query        VARCHAR2(4000);
  v_queryFolder  VARCHAR2(4000);
  v_queryStr2        VARCHAR2(4000);
  v_tableId      INTEGER;
  v_variantId    INTEGER;
  v_tableName    VARCHAR2(256);
  v_routeFolderId NVARCHAR2(255);
  v_scratchFolderId NVARCHAR2(255);
  v_workFlowFolderId NVARCHAR2(255);
  v_completedFolderId NVARCHAR2(255);
  v_dicarderFolderId NVARCHAR2(255);
  v_dataMigrationSuccessful VARCHAR2(1);
  v_isVariantTable  VARCHAR2(1);
  v_genIndex                INT;
  v_folderStatus            INT;
  v_processType             VARCHAR2(1);
  v_existingProcessString 	Varchar2(2000);
  v_existingProcessDefId	INTEGER;
  v_ErrorCode								INTEGER;
  v_ErrorMessage							NVARCHAR2(500);
  v_remarks 			VARCHAR2(4000);
  v_tablevariableremarks VARCHAR2(4000);
TYPE TableNameCursor
IS
  REF
  CURSOR;
    v_TableNameCursor TableNameCursor;
	TYPE processCursor
IS
  REF
  CURSOR;
    v_processDefIdCursor processCursor;
     v_importedFlag     INT;
    v_migratedflag     INT;
    v_existsFlag       INT;
    v_processDefId     INTEGER;
	v_ExecutionLogId	INTEGER;
	
  BEGIN
    BEGIN
	  	FOR cur_row IN 1 .. tableVariableMap.Count LOOP
		--DBMS_OUTPUT.put_line(tableVariableMap(cur_row).ProcessDefId || ' ' || tableVariableMap(cur_row).ProcessVariantId);
		v_tablevariableremarks:=v_tablevariableremarks||'(' ||tableVariableMap(cur_row).ProcessDefId||' --'||tableVariableMap(cur_row).ProcessVariantID||');' ;
	END LOOP;
		v_tablevariableremarks:=trim(trailing ';' FROM v_tablevariableremarks);
	  Select  SEQ_migrationLog.nextval INTO v_ExecutionLogId from dual;
		v_remarks := 'v_sourceCabinet:'|| v_sourceCabinet||',v_targetCabinet:'|| v_targetCabinet||',idblinkname:'|| idblinkname||',tableVariableMap:'|| v_tablevariableremarks||',v_migrateAllData:'   ||v_migrateAllData|| ',v_copyForceFully:'||v_copyForceFully||',v_overRideCabinetData:'||v_overRideCabinetData||',v_moveTaskData:'||v_moveTaskData;	 

      insert into WFMigrationLogTable(executionLogId,actionDateTime,remarks)values(v_ExecutionLogId, current_timestamp,v_remarks);
	  commit;

	  WFMigrateProcessData(v_sourceCabinet,v_targetCabinet,idblinkname,v_overRideCabinetData,v_moveTaskData,v_ExecutionLogId);
	  DBMS_OUTPUT.PUT_LINE('Disabling triggers');
      WFChangeTriggersStatus(v_sourceCabinet,v_targetCabinet,'D',idblinkname);
      DBMS_OUTPUT.PUT_LINE('Triggers Disabled');
      v_query := 'DROP TABLE ' || v_targetCabinet || '.WFMETADATATABLELIST';
      EXECUTE IMMEDIATE v_query;
    EXCEPTION
    WHEN OTHERS THEN
      --DBMS_OUTPUT.PUT_LINE ('Do nothing ....');
	  DBMS_OUTPUT.PUT_LINE ('  ');
    END;
    v_query := 'CREATE TABLE ' || v_targetCabinet || '.WFMETADATATABLELIST (                            



tableId                 INT,                            



tableName               VARCHAR2(256),                               


isVariantTableFlag VARCHAR2(1) ,


dataMigrationSuccessful VARCHAR2(1),    

UNIQUE (tableName)                    



)';
    EXECUTE IMMEDIATE v_query;
    BEGIN
      v_query := 'DROP SEQUENCE ' || v_targetCabinet || '.SEQ_WFMETADATATABLELIST';
      EXECUTE IMMEDIATE v_query;
    EXCEPTION
    WHEN OTHERS THEN
      --DBMS_OUTPUT.PUT_LINE ('Do nothing ....');
		DBMS_OUTPUT.PUT_LINE ('  ');
    END;
    v_query := 'CREATE SEQUENCE ' || v_targetCabinet || '.SEQ_WFMETADATATABLELIST START WITH 1 INCREMENT BY 1';
    EXECUTE IMMEDIATE v_query;
    v_query := 'CREATE OR REPLACE TRIGGER ' || v_targetCabinet || '.WFMETADATATABLELIST_ID_TRIGGER                      



BEFORE INSERT                     



ON ' || v_targetCabinet || '.WFMETADATATABLELIST                     



FOR EACH ROW                     



BEGIN                         



SELECT ' || v_targetCabinet || '.SEQ_WFMETADATATABLELIST.nextval INTO :new.tableId FROM dual;                     



END;';
    EXECUTE IMMEDIATE v_query;
    WFPopulateMetaData (v_targetCabinet,v_moveTaskData);
	v_query:='Select ProcessDefId from ' || v_targetCabinet || '.ProcessDefTable';
	v_existingProcessString := '-1,0,';
	 OPEN v_processDefIdCursor FOR TO_CHAR(v_query);
        LOOP
          FETCH v_processDefIdCursor
          INTO v_existingProcessDefId;
        
          EXIT
        WHEN v_processDefIdCursor%NOTFOUND;
          v_existsFlag := 0;
          v_existingProcessString:=v_existingProcessString||v_existingProcessDefId||',';
       END LOOP;
	   v_existingProcessString:=trim(trailing ',' FROM v_existingProcessString);
	   CLOSE v_processDefIdCursor;

	  
    v_query := 'SELECT * FROM ' || v_targetCabinet || '.WFMETADATATABLELIST where isVariantTableFlag=''N''';

    BEGIN
	
      FOR cur_row IN 1 .. tableVariableMap.Count
      LOOP
        DBMS_OUTPUT.put_line('Process id : '||tableVariableMap(cur_row).ProcessDefId || ' Variant id :  ' || tableVariableMap(cur_row).ProcessVariantId);
        v_ProcessDefId:=tableVariableMap(cur_row).ProcessDefId ;
        v_variantId   :=tableVariableMap(cur_row).ProcessVariantId ;
		
		IF(v_migrateAllData='N') THEN -- for v_migrateAllData
		  	
		v_queryStr2 := 'Select ProcessType from '|| v_sourcecabinet||'.ProcessDefTable'|| idblinkname||' WHERE ProcessDefId    ='|| v_processdefid ;
        EXECUTE Immediate v_querystr2 INTO v_processType;
        BEGIN
          v_migratedflag:=0;
          SELECT 1
          INTO v_migratedflag
          FROM ProcessDefTable
          WHERE ProcessDefId = v_processdefid ;
		  EXCEPTION
		  WHEN OTHERS THEN
			v_migratedflag := 0;
		  END;
		  IF(v_migratedflag =1) THEN
		  IF(v_copyForceFully ='N') THEN
			dbms_output.put_line('Process '||v_processdefid||' Already Exists ');
			IF(v_processType ='M') THEN
			  WFMigrateVariantMetaData (v_sourceCabinet, v_targetCabinet, idblinkname,v_processDefId,v_VariantId,v_migrateAllData,v_copyForceFully,v_ExecutionLogId);
			  dbms_output.put_line('variant migrated : '|| v_VariantId);
			  COMMIT;
			END IF;                                                                                              
			GOTO end_loop;
			END IF;
		  END IF;
		/*  BEGIN
			v_migratedflag:=0;
			SELECT 1
			INTO v_migratedflag
			FROM SuccessfulMigratedMetaData
			WHERE ProcessDefId = v_processdefid ;
		  EXCEPTION
		  WHEN OTHERS THEN
			v_migratedflag := 0;
		  END; 
		 */
	  END IF; -- For v_migrateAllData
      IF(v_migratedflag =1) THEN
        dbms_output.put_line(' ');
      ELSE -- Not yet Migrated
		IF(v_migrateAllData='N') THEN --For v_migrateAllData
		BEGIN
          v_existsflag:=0;
          v_queryStr2 :='Select 1 from '|| v_sourcecabinet||'.ProcessDefTable'|| idblinkname||' WHERE ProcessDefId    ='|| v_processdefid ;
          EXECUTE Immediate v_querystr2 INTO v_existsflag;
        EXCEPTION
        WHEN OTHERS THEN
          v_existsflag := 0;
        END;
        IF(v_existsflag=0) THEN
          dbms_output.put_line('Process '||v_processdefid||' Does not Exists ');
          GOTO end_loop;
        END IF;
	   END IF; --For v_migrateAllData
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
          BEGIN
            SELECT 1
            INTO v_existsFlag
            FROM DBA_Tables
            WHERE TABLE_NAME    = UPPER(v_tableName)
            AND OWNER = UPPER(v_targetCabinet);
          EXCEPTION
          WHEN OTHERS THEN
            v_existsFlag := 0;
          END;
          IF (v_existsFlag = 1) THEN 
            WFMoveMetaData(v_sourceCabinet, v_targetCabinet, v_tableName, v_processdefid,idblinkname,v_migrateAllData,v_copyForcefully,v_existingProcessString,v_ExecutionLogId);
          END IF;
        END LOOP;
        CLOSE v_TableNameCursor;
		DBMS_OUTPUT.PUT_LINE('Executed Move Metadata for process '|| v_processdefid);
        WFMoveQueueData(v_sourceCabinet, v_targetCabinet, v_processdefid,idblinkname,v_migrateAllData,v_copyForcefully,v_existingProcessString);
		DBMS_OUTPUT.PUT_LINE('Queues migrated for process '|| v_processdefid);
		WFMoveOmnidocsFolderData(v_sourcecabinet,v_targetCabinet,v_isDBLink,idblinkname,v_processdefid,v_migrateAllData,v_copyForceFully,v_existingProcessString);
		DBMS_OUTPUT.PUT_LINE('OD DATA MIGRATED ');
         DBMS_OUTPUT.PUT_LINE('Metadata successfully migrated for ProcessDefId '|| v_processdefid);
        COMMIT;
        WFExportExternalTable(v_sourceCabinet, v_targetCabinet, idblinkname,v_processDefId,v_migrateAllData);
		IF(v_moveTaskData = 'Y') THEN
		WFExportTaskTables(v_sourceCabinet, v_targetCabinet, idblinkname,v_processDefId,v_migrateAllData,'N');
		END IF;
        IF((v_processType ='M')or(v_migratealldata ='Y')) THEN
        DBMS_OUTPUT.PUT_LINE('Migrating variant ');
         WFMigrateVariantMetaData (v_sourceCabinet, v_targetCabinet, idblinkname,v_processDefId,v_VariantId,v_migrateAllData,v_copyForceFully,v_ExecutionLogId);
        COMMIT;
        END IF;
      END IF; --Not yet migrated
	  <<end_loop>>
	  NULL;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('Triggers enabled');
    WFChangeTriggersStatus(v_sourceCabinet,v_targetCabinet,'E',idblinkname);
    DBMS_OUTPUT.PUT_LINE('Migration Completes successfully');
  EXCEPTION
  WHEN OTHERS THEN
    BEGIN
	ROLLBACK;
	  v_ErrorCode:= SQLCODE;
      v_ErrorMessage:=SQLERRM;								
	  DBMS_OUTPUT.PUT_LINE('Error Code : '||v_ErrorCode);
	  DBMS_OUTPUT.PUT_LINE('v_ErrorMessage : '||v_ErrorMessage);
      v_remarks:= 'Meta Data Migration Failed . Error Code is '|| v_ErrorCode ||' and Error message is '||v_ErrorMessage;
      INSERT INTO WFFailedMetaDataMigrationLog (ExecutionLogId,actionDateTime,ProcessDefId,Status) VALUES (v_ExecutionLogId, Current_Timestamp, v_processDefId,v_remarks);
	  commit;
      WFChangeTriggersStatus(v_sourceCabinet,v_targetCabinet,'E',idblinkname);
      DBMS_OUTPUT.PUT_LINE('Triggers enabled'); 
      DBMS_OUTPUT.PUT_LINE('Error in executing WFMigrateMetaData !');
      
      RAISE;
      --END;
    END;
  END;
END;