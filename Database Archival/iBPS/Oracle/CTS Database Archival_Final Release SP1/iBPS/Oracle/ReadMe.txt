Archival Approach :
=================

1. Follow steps of OD_ReadMe.txt.
2. Execute Create_Partitioned_Table.sql on target  cabinet. This should be executed only once . This step is required for Partitioning support.
3. To migrate process' metadata :
 From Oracle database client such as SQL developer etc, 
	Run SetAndMigrateMetaData procedure to migrate processdefid and variant id as specified in SetAndMigrateMetaData procedure. This procedure has following input parameters : 
	v_sourceCabinet     		: Name of source cabinet.
    v_targetCabinet     		: Name of target cabinet.
	v_isDBLink					: Parameter to define if data is to be migrated over dblink.Possible values are 'Y'/'N' .
    idblinkname         		: Name of dblink in case above parameter is 'Y'
	v_migrateAllData 			: Flag to indicate whether all meta data is to be migrated at once.Possible values are 'Y'/'N' .
	v_copyForceFully			: Flag to indicate whether existing data is to be replaced.
	v_overRideCabinetData		: Flag to indicate whether existing cabinet level metadata is to be replace. Possible values are 'Y'/'N' .
	
	##Kindly Note##: From Oracle client, Modify SetAndMigrateMetaData to specify processdefid and processvariantid's  to be migrated: 
	To migrate Multivariant processdefid 4 and it's variant with variantid as 1 ,add following lines in procedure 
		tableVariableMap.extend;
		tableVariableMap(tableVariableMap.Last) := Process_Variant_Type(4, 1);	
	To migrate Generic processdefid 5 ,add following lines in procedure :
		tableVariableMap.extend;
		tableVariableMap(tableVariableMap.Last) := Process_Variant_Type(5, 0);	
	
 Sample Call :
		DECLARE
		  V_SOURCECABINET VARCHAR2(200);
		  V_TARGETCABINET VARCHAR2(200);
		  V_ISDBLINK VARCHAR2(200);
		  IDBLINKNAME VARCHAR2(200);
		  V_MIGRATEALLDATA VARCHAR2(200);
		  V_COPYFORCEFULLY VARCHAR2(200);
		  V_OVERRIDECABINETDATA VARCHAR2(200);
		BEGIN
		  V_SOURCECABINET := 'ORAIBPMS13MAY';
		  V_TARGETCABINET := 'MOHTARGETCAB';
		  V_ISDBLINK := 'Y';
		  IDBLINKNAME := 'ORA13_DBLINK';
		  V_MIGRATEALLDATA := 'N';
		  V_COPYFORCEFULLY := 'N';
		  V_OVERRIDECABINETDATA :='Y';

		  SETANDMIGRATEMETADATA(
			V_SOURCECABINET => V_SOURCECABINET,
			V_TARGETCABINET => V_TARGETCABINET,
			V_ISDBLINK => V_ISDBLINK,
			IDBLINKNAME => IDBLINKNAME,
			V_MIGRATEALLDATA => V_MIGRATEALLDATA,
			V_COPYFORCEFULLY => V_COPYFORCEFULLY,
			V_OVERRIDECABINETDATA => V_OVERRIDECABINETDATA
		  );
		END;

4. To migrate process' level transactional data ,
From Oracle database client such as SQL developer etc, Run SetAndMigrateTransactionalData procedure to migrate transactional data of processdefid and variant id as specified in SetAndMigrateTransactionalData procedure. This procedure has following input parameters : 
	
  V_SOURCECABINET   		: Name of source cabinet.
  V_TARGETCABINET 			: Name of target cabinet.	
  V_ISDBLINK 				: Parameter to define if data is to be archived over dblink.Possible values are 'Y'/'N' .
  IDBLINKNAME 				: Name of dblink in case above parameter is 'Y'
  V_MIGRATEALLPROCESSES 	: Flag to indicate whether all transactional data is to be archived at once.Possible values are 'Y'/'N' .
  V_FROMDATE 				: Date in DD-MMM-YYYY format from which transactional data is to be archived . Specify in Format 'DD-MMM-YYYY'
  V_TODATE 					: Date in DD-MMM-YYYY format till which transactional data is to be archived . Specify in Format 'DD-MMM-YYYY'
  V_BATCHSIZE 				: Batch size of workitems.
  V_MOVEAUDITTRAILDATA 		: Flag to indicate whether audit trail data is to be archived.Possible values are 'Y'/'N' .
  V_MOVEFROMHISTORYDATA 	: Flag to indicate whether history data is to be archived .Possible values are 'Y'/'N' .If this flag is 'Y', transactional data will not be archived.
  V_MOVEEXTERNALPROCESSDATA : Flag to indicate whether data of external	variables and complex variables is to be archived.
  
DECLARE
  V_SOURCECABINET VARCHAR2(200);
  V_TARGETCABINET VARCHAR2(200);
  V_ISDBLINK VARCHAR2(200);
  IDBLINKNAME VARCHAR2(200);
  V_MIGRATEALLPROCESSES VARCHAR2(200);
  V_FROMDATE VARCHAR2(200);
  V_TODATE VARCHAR2(200);
  V_BATCHSIZE NUMBER;
  V_MOVEAUDITTRAILDATA VARCHAR2(200);
  V_MOVEFROMHISTORYDATA VARCHAR2(200);
  V_MOVEEXTERNALPROCESSDATA VARCHAR2(200);
BEGIN
  V_SOURCECABINET := 'ORAIBPMS13MAY';
  V_TARGETCABINET := 'MOHTARGETCAB';
  V_ISDBLINK := 'Y';
  IDBLINKNAME := 'ORA13_DBLINK';
  V_MIGRATEALLPROCESSES := 'N';
  V_FROMDATE := '02-FEB-2014';
  V_TODATE := '02-APR-2014';
  V_BATCHSIZE := 1000;
  V_MOVEAUDITTRAILDATA := 'Y';
  V_MOVEFROMHISTORYDATA := 'N';
  V_MOVEEXTERNALPROCESSDATA := 'Y';

  SETANDMIGRATETRANSACTIONALDATA(
    V_SOURCECABINET => V_SOURCECABINET,
    V_TARGETCABINET => V_TARGETCABINET,
    V_ISDBLINK => V_ISDBLINK,
    IDBLINKNAME => IDBLINKNAME,
    V_MIGRATEALLPROCESSES => V_MIGRATEALLPROCESSES,
    V_FROMDATE => V_FROMDATE,
    V_TODATE => V_TODATE,
    V_BATCHSIZE => V_BATCHSIZE,
    V_MOVEAUDITTRAILDATA => V_MOVEAUDITTRAILDATA,
    V_MOVEFROMHISTORYDATA => V_MOVEFROMHISTORYDATA,
    V_MOVEEXTERNALPROCESSDATA => V_MOVEEXTERNALPROCESSDATA
  );
END;

5. To migrate cabinet level transactional data ,
From Oracle database client such as SQL developer etc, Call WFMigrateTxnCabinetData procedure to archive cabinet level transactional data before specific date passed as input parameter. This procedure has following input parameters : 

v_sourceCabinet     	: Name of source cabinet.
v_targetCabinet   		: Name of target cabinet.
v_isDBLink				: Parameter to define if data is to be migrated over dblink.Possible values are 'Y'/'N' .
idblinkname       		: Name of dblink in case above parameter is 'Y'
v_beforeDate      		: Date in DD-MMM-YYYY format before which data is to be archived .


DECLARE
  V_SOURCECABINET VARCHAR2(200);
  V_TARGETCABINET VARCHAR2(200);
  V_ISDBLINK VARCHAR2(200);
  IDBLINKNAME VARCHAR2(200);
  V_BEFOREDATE VARCHAR2(200);
BEGIN
  V_SOURCECABINET := 'ORAIBPMS13MAY';
  V_TARGETCABINET := 'MOHTARGETCAB';
  V_ISDBLINK := 'Y';
  IDBLINKNAME := 'ORA13_DBLINK';
  V_BEFOREDATE := '02-APR-2014';

  WFMIGRATETXNCABINETDATA(
    V_SOURCECABINET => V_SOURCECABINET,
    V_TARGETCABINET => V_TARGETCABINET,
    V_ISDBLINK => V_ISDBLINK,
    IDBLINKNAME => IDBLINKNAME,
    V_BEFOREDATE => V_BEFOREDATE
  );
END;

