/*__________________________________________________________________________________;
NEWGEN SOFTWARE TECHNOLOGIES LIMITED;
Group                       : Phoenix;
Product / Project           : IBPS;
Module                      : IBPS Server;
File Name                   : WFPartitionTable.sql (Oracle)
Author                      : Mohnish Chopra
Date written (DD/MM/YYYY)   : 22 MAY 2014
Description                 : Support for Partitioning in Archival 
____________________________________________________________________________________;
CHANGE HISTORY;
____________________________________________________________________________________;
Date        Change By        Change Description (Bug No. (IF Any))
____________________________________________________________________________________*/
/***************************************************************************************;
*  Description : Database partitioning Solution for IBPS
* It is mandatory to compile and EXECUTE IMMEDIATE this script on target cabinet 
*
***************************************************************************************/
create or replace
PROCEDURE WFPartitionTable
  (
	v_targetCabinet VARCHAR2,
	v_tableName     VARCHAR2,
	v_tableAlias	VARCHAR2,
	 tableVariableMap Process_Variant_Tab_Var,
	v_migrateAllData VARCHAR2,
	v_partitionColumn VARCHAR2 	
	)
AS
  v_query      VARCHAR2(4000);
  v_queryStr   VARCHAR2(4000);
  v_colStr     VARCHAR2(4000);
  v_FilterQueryString VARCHAR2(1000);
  v_columnName VARCHAR2(256);
  v_ProcessInstanceId			NVARCHAR2(255); 
  v_partitionName         VARCHAR2(512);
  v_partitionTempName	VARCHAR2(512);
v_subPartitionName      VARCHAR2(512);
 TYPE processCursor
IS
  REF
  CURSOR;
	v_processCursor processCursor;
	TYPE processVariantCursor
IS
  REF
  CURSOR;
	v_processVariantCursor processVariantCursor;
	v_processdefid INTEGER;
	v_remarks VARCHAR2(4000);
	v_localTableVariableMap Process_Variant_Tab_Var :=Process_Variant_Tab_Var();
	v_RegPrefix			NVARCHAR2(25); 
	v_RegSuffix			NVARCHAR2(25); 
	v_RegStartingNo				INT;
	v_RegSeqLength				INT; 
	v_processVariantid 		INTEGER;
  v_variantId           INTEGER;
	v_partitioningQuery VARCHAR2(4000);
  v_Length					INT;
  v_existsFlag      INT;
  v_partitionCondition	VARCHAR2(1000);
  v_queryExecuted	CHAR(1);
  BEGIN
	BEGIN
	 -- SAVEPOINT Move_Meta_Data;
	--dbms_output.put_line(v_tableName);
	  
	  IF(v_migrateAllData='Y') THEN
			v_query              := 'Select ProcessDefId from ProcessDefTable where ProcessType= ''S''';
			OPEN v_processCursor FOR TO_CHAR(v_query);
			LOOP
			  FETCH v_processCursor INTO v_processdefid;
			EXIT
		   WHEN v_processCursor%NOTFOUND;
		  v_localTableVariableMap.extend;
			v_localTableVariableMap(v_localTableVariableMap.Last) := Process_Variant_Type(v_processdefid,0);
		  END LOOP;
		  CLOSE v_processCursor ;
	  v_query              := 'Select ProcessDefId from ProcessDefTable where ProcessType= ''M''';
		OPEN v_processCursor FOR TO_CHAR(v_query);
		LOOP
		  FETCH v_processCursor INTO v_processdefid;
		EXIT
	  WHEN v_processCursor%NOTFOUND;
		v_queryStr := 'Select ProcessVariantId FROM WFPROCESSVARIANTDEFTABLE where processdefid = '||v_processdefid;
		OPEN v_processVariantCursor FOR TO_CHAR(v_queryStr);
		LOOP
		  FETCH v_processVariantCursor INTO v_processVariantid;
		EXIT
	  WHEN v_processVariantCursor%NOTFOUND;
		v_localTableVariableMap.extend;
		v_localTableVariableMap(v_localTableVariableMap.Last) := Process_Variant_Type(v_processdefid,v_processVariantid);
	  END LOOP;
	  CLOSE v_processVariantCursor ;
	  END LOOP;
	CLOSE v_processCursor ; 
	ELSE
	  v_localTableVariableMap:=tableVariableMap;
	END IF;
	FOR cur_row IN 1 .. v_localTableVariableMap.Count
	LOOP
	  DBMS_OUTPUT.put_line(v_localTableVariableMap(cur_row).ProcessDefId || ' ' || v_localTableVariableMap(cur_row).ProcessVariantId);
	  v_ProcessDefId  :=v_localTableVariableMap(cur_row).ProcessDefId ;
	  v_variantId     :=v_localTableVariableMap(cur_row).ProcessVariantId ;
	  IF(v_variantId =0) THEN
			SELECT	RegPrefix, 
					RegSuffix, 
					RegSeqLength
					INTO v_RegPrefix,v_RegSuffix,v_RegSeqLength
					FROM	ProcessDefTable 
					WHERE	ProcessDefID	= v_ProcessDefId; 
			
	  ELSE 
		IF(v_partitionColumn = 'PROCESSDEFID') THEN
			GOTO end_loop;
		END IF;
	 SELECT	WFProcessVariantDefTable.RegPrefix, 
			WFProcessVariantDefTable.RegSuffix, 
			WFProcessVariantDefTable.RegStartingNo, 
			ProcessDefTable.RegSeqLength
	  INTO v_RegPrefix,v_RegSuffix,v_RegStartingNo,v_RegSeqLength
		FROM	WFProcessVariantDefTable, ProcessDefTable
		WHERE	WFProcessVariantDefTable.ProcessDefId = ProcessDefTable.ProcessDefId
		AND		ProcessDefTable.ProcessDefID	= v_processdefid
		AND		ProcessVariantId = v_variantid;/*Process Variant Support*/

	  END IF;
	  
			v_RegPrefix:=v_RegPrefix||'-';
			v_RegSuffix:='-'||v_RegSuffix;
			v_Length:= v_RegSeqLength - LENGTH(v_RegPrefix) - LENGTH(v_RegSuffix); 

	  v_partitionName:= 'PARTITION_'||v_tableAlias||'_'||v_ProcessDefId||'_'||v_variantId ; 
	  v_partitionTempName:= 'PARTITION_'||v_tableAlias||'_'||v_ProcessDefId; 
	  v_existsFlag:=0;
    --Select count(*),subobject_name from user_objects where subobject_name like 'PARTITION_WFIT_14%' group by  subobject_name
    Begin
	  v_query:='Select count(*),subobject_name from user_objects where subobject_name  like '''||v_partitionTempName||'%'||''' and object_name='''||v_tableName||'''';
    v_query:=v_query||' group by subobject_name';
	Execute immediate v_query into v_existsFlag,v_partitionName;
    EXCEPTION when no_data_found then
    v_existsFlag:=0;
    v_partitionName:='PARTITION_'||v_tableAlias||'_'||v_ProcessDefId||'_'||v_variantId ; 
    END;
	  if (v_existsFlag =0) then 
	  v_query:='ALTER TABLE '|| v_tableName||' ADD PARTITION '||v_partitionName||'  VALUES ('|| v_ProcessDefId||') (';
	  end if;
		  v_RegStartingNo:=1000000;
		For loop_counter in 1..10 loop
		
			v_ProcessInstanceId	:= RPAD('0', v_Length,'0'); 
			v_ProcessInstanceId	:= v_RegPrefix || SUBSTR(v_ProcessInstanceId,1, LENGTH(v_ProcessInstanceId) - LENGTH(v_RegStartingNo)) || TO_CHAR(v_RegStartingNo) || v_RegSuffix;
		--IF(v_variantId =0) THEN
		IF(v_partitionColumn = 'PROCESSDEFID') THEN
			v_partitionCondition:='('''||v_ProcessInstanceId||''')';
		else 
		v_processVariantId:= v_variantId+1;

		v_partitionCondition:='('||v_processVariantId||','''||v_ProcessInstanceId||''')';
		end if;
			if (v_existsFlag =0) then 
			v_subPartitionName:=	'SUB_PART_'||v_tableAlias||'_'||loop_counter||'_'||v_ProcessDefId||'_'||v_variantId;
			v_query:=	v_query||' SUBPARTITION '||v_subPartitionName||' VALUES LESS THAN '||v_partitionCondition||',';
			v_queryExecuted:='N';
		   
		    else 
			v_subPartitionName:=	'SUB_PART_'||v_tableAlias||'_'||loop_counter||'_'||v_ProcessDefId||'_'||v_variantId;
			v_query:= 'ALTER TABLE '|| v_tableName||' MODIFY PARTITION '||v_partitionName||' ADD SUBPARTITION '	||v_subPartitionName|| ' VALUES LESS THAN '||v_partitionCondition;
			EXECUTE immediate v_query;
			DBMS_OUTPUT.PUT_LINE(v_query);
			v_queryExecuted:='Y';

			end if;
		  v_RegStartingNo:= v_regstartingno +1000000;
		  End loop;
		  v_query:=trim(trailing ',' FROM v_query); 
		  v_query:=v_query||')';
		  if(v_queryExecuted='N') then
		  EXECUTE immediate v_query;
		  DBMS_OUTPUT.PUT_LINE(v_query);
		  end if;
		  <<end_loop>>
		NULL;
	  END LOOP;
   
  EXCEPTION
  WHEN OTHERS THEN
	BEGIN
	ROLLBACK ;
	RAISE;
	END;
  END;
END;