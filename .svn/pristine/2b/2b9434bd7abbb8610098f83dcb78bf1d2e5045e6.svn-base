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
	v_moveTaskData        VARCHAR2,
	v_DBProcessDefId      VARCHAR2,
	v_fromDate           VARCHAR2,
	v_toDate			VARCHAR2,
    v_batchSize          INTEGER,
	v_moveAuditTrailData 	VARCHAR2,
	v_moveFromHistoryData 	VARCHAR2,
	v_moveExternalProcessData 	VARCHAR2,
	v_loggingEnabled			VARCHAR2
)

AS
  v_idblinkname VARCHAR2(100);
  v_query VARCHAR2(4000);
	--v_processDefId 	INTEGER;
tableVariableMap Process_Variant_Tab_Var := Process_Variant_Tab_Var();
v_localTableVariableMap Process_Variant_Tab_Var :=Process_Variant_Tab_Var();

v_queryStr1        VARCHAR2(4000);
v_queryStr2        VARCHAR2(4000);
v_queryStr3        VARCHAR2(4000);
v_processname    VARCHAR2(256);
v_srcModified    DATE;
v_targetModified    DATE;
v_migrateFlag       VARCHAR2(256);


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


--changes by Nikhil
v_queryStr1 := 'Select Processname from '|| v_sourcecabinet||'.ProcessDefTable'|| idblinkname||' WHERE ProcessDefId    ='|| v_DBProcessDefId ;
EXECUTE Immediate v_queryStr1 INTO v_processname;

v_queryStr2 := 'Select LastModifiedOn from '|| v_sourcecabinet||'.ProcessDefTable'|| idblinkname||' WHERE ProcessDefId    ='|| v_DBProcessDefId ;
EXECUTE Immediate v_queryStr2 INTO v_srcModified;

BEGIN
v_migrateFlag := 'N';
SELECT 'N' INTO v_migrateFlag FROM Processdeftable  WHERE ProcessName = v_processname;
	EXCEPTION
		WHEN NO_DATA_FOUND THEN 
		v_migrateFlag := 'Y';
END;

IF (v_migrateFlag = 'N') then
BEGIN
	select LastModifiedOn into v_targetModified from ProcessDefTable where Processname = v_processname;
	IF (v_targetModified < v_srcModified) then
		BEGIN
		v_migrateFlag := 'Y';
		end;
		end if;
end;
end if;





--Print out contents of collection
FOR cur_row IN 1 .. tableVariableMap.Count LOOP
DBMS_OUTPUT.put_line(tableVariableMap(cur_row).ProcessDefId || ' ' || tableVariableMap(cur_row).ProcessVariantId);
END LOOP;
IF (v_migrateFlag = 'Y') then
BEGIN
wfmigratemetadata(v_sourceCabinet,v_targetCabinet,v_isDBLink,v_idblinkname ,v_localTableVariableMap,UPPER(v_migrateAllData),UPPER(v_copyForceFully),UPPER(v_overRideCabinetData),Upper(v_moveTaskData));
end;
end if;
--WFPartitionLargeTables(v_targetCabinet,tableVariableMap,UPPER(v_migrateAllData)) ;
SetAndMigrateTransactionalData(v_sourceCabinet,v_targetCabinet,v_isDBLink,v_idblinkname,'N',v_fromDate,v_toDate,v_batchSize,v_moveAuditTrailData,v_moveFromHistoryData,v_moveExternalProcessData,v_loggingEnabled,Upper(v_moveTaskData),v_DBProcessDefId);
Exception
When others then
Rollback;
Raise;
END; 