/*__________________________________________________________________________________;
            NEWGEN SOFTWARE TECHNOLOGIES LIMITED;

    Group                       : Phoenix;
    Product / Project           : IBPS;
    Module                      : IBPS Server;
    File Name                   : SetAndMigrateMetaData.sql (Oracle)
    Author                      : Mohnish Chopra
    Date written (DD/MM/YYYY)   : 14 MAY 2014
    Description                 : Entry point Stored procedure for Meta data Migration ;
____________________________________________________________________________________;
                        CHANGE HISTORY;
____________________________________________________________________________________;
Date        Change By        Change Description (Bug No. (IF Any))

____________________________________________________________________________________*/
create or replace
Procedure SetAndMigrateMetaData
(
    v_sourceCabinet      VARCHAR2,
    v_targetCabinet      VARCHAR2,
	v_isDBLink			VARCHAR2,
    idblinkname          VARCHAR2,
	v_migrateAllData 	 VARCHAR2,	
	v_copyForceFully	 VARCHAR2,
	v_overRideCabinetData	VARCHAR2,
	v_moveTaskData        VARCHAR2
)

AS
  v_idblinkname VARCHAR2(100);
  v_query VARCHAR2(4000);
	v_processDefId 	INTEGER;
tableVariableMap Process_Variant_Tab_Var := Process_Variant_Tab_Var();
v_localTableVariableMap Process_Variant_Tab_Var :=Process_Variant_Tab_Var();

BEGIN
	
	IF ( (UPPER(v_isDBLink) NOT IN ('Y','N')) OR (UPPER(v_migrateAllData) NOT IN ('Y','N')) OR (UPPER(v_copyForceFully) NOT IN ('Y','N')) or (UPPER(v_overRideCabinetData) NOT IN ('Y','N')) or v_sourceCabinet is null or v_targetCabinet is null )
	THEN
		dbms_output.put_line('Invalid parameter passed');
		Raise OraExcpPkg.Excp_Invalid_Parameter;
	END IF;
	if(UPPER(v_isDBLink)='Y') THEN
	v_idblinkname:= '@'||idblinkname;
	else
	v_idblinkname:='';
	END IF;
--Populate our SourceIDMap variable (dummy select statement for now).
tableVariableMap.extend;
tableVariableMap(tableVariableMap.Last) := Process_Variant_Type(4, 1);
tableVariableMap.extend;
tableVariableMap(tableVariableMap.Last) := Process_Variant_Type(4, 2);

    IF(v_migrateAllData='Y') THEN

        v_localTableVariableMap.extend;
        v_localTableVariableMap(v_localTableVariableMap.Last) := Process_Variant_Type(-1,-1);
    ELSE
      v_localTableVariableMap:=tableVariableMap;
    END IF;

--Print out contents of collection
FOR cur_row IN 1 .. tableVariableMap.Count LOOP
DBMS_OUTPUT.put_line(tableVariableMap(cur_row).ProcessDefId || ' ' || tableVariableMap(cur_row).ProcessVariantId);
END LOOP;
wfmigratemetadata(v_sourceCabinet,v_targetCabinet,v_isDBLink,v_idblinkname ,v_localTableVariableMap,UPPER(v_migrateAllData),UPPER(v_copyForceFully),UPPER(v_overRideCabinetData),Upper(v_moveTaskData));
WFPartitionLargeTables(v_targetCabinet,tableVariableMap,UPPER(v_migrateAllData)) ;
Exception
When others then
Rollback;
Raise;
END; 