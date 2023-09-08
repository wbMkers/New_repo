/*__________________________________________________________________________________;
NEWGEN SOFTWARE TECHNOLOGIES LIMITED;
Group                       : Phoenix;
Product / Project           : IBPS;
Module                      : IBPS Server;
File Name                   : WFPartitionGlobalTable.sql (Oracle)
Author                      : Mohnish Chopra
Date written (DD/MM/YYYY)   : 22 MAY 2014
Description                 : Support for Partitioning in Archival . Partitions a table on the basis of date time.
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
PROCEDURE WFPartitionGlobalTable
  (
  v_targetCabinet VARCHAR2,
  v_tableName     VARCHAR2,
  v_tableAlias	VARCHAR2 
  )
AS
  v_query      VARCHAR2(4000);
  v_partitionName         VARCHAR2(512);
  v_date				  INTEGER;
  v_existsFlag    int;
  BEGIN
  BEGIN
       select extract(year from sysdate) into v_date from dual ;

    v_existsFlag:=0;
   /* v_query:='Select count(*) from user_objects where subobject_name='''||v_partitionName||''' and object_name='''||v_tableName||'''';
  Execute immediate v_query into v_existsFlag; 
    if (v_existsFlag =0) then 
    v_query:='ALTER TABLE '|| v_tableName||' ADD PARTITION '||v_partitionName||'  VALUES ('|| v_ProcessDefId||') (';
    end if;
    v_RegStartingNo:=1000000; */
    For loop_counter in 1..10 loop
        v_date :=v_date+1; 
      v_partitionName:= 'PARTITION_'||v_tableAlias||'_'||v_date; 
      DBMS_OUTPUT.PUT_LINE(v_partitionName);		
      v_query:='Select count(*) from user_objects where subobject_name='''||v_partitionName||''' and object_name='''||v_tableName||'''';
      Execute immediate v_query into v_existsFlag; 
      if (v_existsFlag =0) then 

      --Alter table members add partition p1 VALUES LESS THAN ('01-JAN-2011');
      v_query:='ALTER TABLE '|| v_tableName||' ADD PARTITION '||v_partitionName||' VALUES LESS THAN (''01-JAN-'||v_date||''') ';
	  Execute Immediate v_query;
      DBMS_OUTPUT.PUT_LINE(v_query);
	  else
	  DBMS_OUTPUT.PUT_LINE('Partition '||v_partitionName||' already exists..');
       end if;
    End loop;
  EXCEPTION
  WHEN OTHERS THEN
  BEGIN
  ROLLBACK ;
  RAISE;
  END;
  END;
END;
