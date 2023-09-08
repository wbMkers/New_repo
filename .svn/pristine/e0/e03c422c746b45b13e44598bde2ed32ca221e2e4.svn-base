CREATE OR REPLACE FUNCTION SetAndMigrateMetaData() RETURNS void  LANGUAGE 'plpgsql' AS $function$
DECLARE
	v_sourceCabinet      		VARCHAR(256);
	v_targetCabinet      		VARCHAR(256);
	v_isDBLink			  		VARCHAR(1);
	sourceMachineIp      		VARCHAR(256);
	v_migrateAllData 	  		VARCHAR(1);	
	v_copyForceFully	  		VARCHAR(1);
	v_overRideCabinetData		VARCHAR(1);
	v_DeleteFromSrc				VARCHAR(1);    /* Required for MoveDocDb whether Data has to be deleted from source or not */
	v_moveTaskData        		VARCHAR(2);
	v_idblinkname 				VARCHAR(100);
	v_query 					VARCHAR(4000);
	v_processDefId 				INTEGER;
	v_existsFlag 				INTEGER;
	
BEGIN

	DECLARE v_idblinkname VARCHAR(100);
	v_query VARCHAR(4000);
	v_processDefId 	INTEGER;
	v_existsFlag INTEGER;
	cursor1               REFCURSOR;
	tableVarRemarks VARCHAR(4000); 
	V_ProcessVariantID INTEGER; 
/*tableVariableMap Process_Variant_Tab_Var := Process_Variant_Tab_Var();
v_localTableVariableMap Process_Variant_Tab_Var :=Process_Variant_Tab_Var();*/

	tableVarRemarks := '';
	
	BEGIN   
		SELECT count(1) INTO v_existsFlag  FROM pg_type WHERE typname = 'Process_Variant_Type';
		IF(v_existsFlag >= 0) THEN
		BEGIN
			EXECUTE 'create TYPE Process_Variant_Type AS (ProcessDefId number(15), ProcessVariantId number(15))';
		END;
		END IF;
			
	END;
	
	BEGIN   
	
		SELECT count(1) INTO v_existsFlag  FROM pg_type WHERE upper(typname) = upper('Process_Variant_Type');
		IF(v_existsFlag >= 0) THEN
		BEGIN
			EXECUTE 'create TABLE Var_Process_Variant_Table (Process_Variant Process_Variant_Type)';
			  
		END;
		END IF;
	
	END;
	
	
	IF ( (UPPER(v_isDBLink) NOT IN ('Y','N')) OR (UPPER(v_migrateAllData) NOT IN ('Y','N')) OR (UPPER(v_copyForceFully) NOT IN ('Y','N')) or (UPPER(v_overRideCabinetData) NOT IN ('Y','N')) or v_sourceCabinet is null or v_targetCabinet is null )
	THEN
		Raise Notice('Invalid parameter passed');
		
	END IF;
	

	BEGIN
		--Insert into Var_Process_Variant_Table(ProcessDefid,ProcessVariantID) values (3,0)
		INSERT INTO Var_Process_Variant_Table VALUES ((3, 0));
		
		v_QueryStr := 'Select ProcessDefId,ProcessVariantID From Var_Process_Variant_Table'
		
		OPEN cursor1 FOR EXECUTE v_QueryStr; 
		
		
		LOOP
			BEGIN
				FETCH cursor1 INTO V_ProcessdefId , V_ProcessVariantID;
				IF (NOT FOUND) THEN
					EXIT;
				END IF;
				--RAISE NOTICE 'delete starts ';
			
					SELECT tableVarRemarks +  'PId--'+ @Id + 'PVId--' + @PVId;
			
			END; 
		END LOOP; 
		CLOSE cursor1;
	
		
		Insert into getnerateLogId DEFAULT VALUES
		SELECT @v_executionLogId =  max(id) from  getnerateLogId
		SELECT @v_remarks = 'MetaData Execution Begins with following parameters --> v_sourceCabinet : ' + @v_sourceCabinet + ' , v_targetCabinet : ' + @v_targetCabinet + ' , v_isDBLink : ' + @v_isDBLink  + ' , sourceMachineIp : '+ @sourceMachineIp + ' , v_migrateAllData : ' + @v_migrateAllData + ' , v_copyForceFully : ' + @v_copyForceFully + '  , v_overRideCabinetData : ' + @v_overRideCabinetData + ' ,  tableVariable : ' + @tableVarRemarks + ' ,  dblinkString : ' + @dblinkString
		Insert into WFMigrationLogTable values (@v_executionLogId,getdate(),@v_remarks)
		
		EXEC WFMigrateMetaData @v_sourceCabinet , @v_targetCabinet , @dblinkString , @tableVariableMap , @v_migrateAllData ,@v_copyForceFully , @v_overRideCabinetData,@v_DeleteFromSrc,@v_executionLogId,@v_moveTaskData
		
		
		
	END
	
END;
                    
$function$;
	