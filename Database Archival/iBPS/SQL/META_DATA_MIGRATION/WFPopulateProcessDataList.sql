	/*__________________________________________________________________________________;
		NEWGEN SOFTWARE TECHNOLOGIES LIMITED;
		Group                       : Genesis;
		Product / Project           : IBPS;
		Module                      : IBPS Server;
		File Name                   : WFPopulateProcessDataList.sql (MSSQL)
		Author                      : Kahkeshan
		Date written (DD/MM/YYYY)   : 21 MAY 2014
		Description                 : Stored Procedure To Populate WFPROCESSTABLELIST Table 
		____________________________________________________________________________________;
		CHANGE HISTORY;
		____________________________________________________________________________________;
		Date        Change By        Change Description (Bug No. (IF Any))
		____________________________________________________________________________________*/	


	If Exists (Select * FROM SysObjects  WITH (NOLOCK) Where xType = 'P' and name = 'WFPopulateProcessDataList')
	Begin
		Execute('DROP PROCEDURE WFPopulateProcessDataList')
		Print 'Procedure WFPopulateProcessDataList already exists, hence older one dropped ..... '
	End

	~

	CREATE 
	PROCEDURE WFPopulateProcessDataList
	(
		@v_targetCabinet      VARCHAR(255),
		@v_moveTaskData		  VARCHAR(1)
	)
	AS

	BEGIN
		
		DECLARE @v_query            VARCHAR(4000)
		
		SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFPROCESSTABLELIST VALUES ( ''WFCabVersionTable'', ''N'' , ''Y'' ) '
		EXECUTE (@v_query)
		
		SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFPROCESSTABLELIST VALUES ( ''INTERFACEDEFTABLE'', ''N'' , ''N'' ) '
		EXECUTE (@v_query)
		
		--SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFPROCESSTABLELIST VALUES ( ''USERDIVERSIONTABLE'', ''N'', ''N'' ) '
		--EXECUTE (@v_query)
		
		--SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFPROCESSTABLELIST VALUES ( ''USERWORKAUDITTABLE'', ''N'', ''N'' ) '
		--EXECUTE (@v_query)
		
		SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFPROCESSTABLELIST VALUES ( ''PREFERREDQUEUETABLE'', ''N'', ''N'' ) '
		EXECUTE (@v_query)
		
		--SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFPROCESSTABLELIST VALUES ( ''USERPREFERENCESTABLE'', ''N'', ''N'' ) '
	   -- EXECUTE (@v_query)
		
		SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFPROCESSTABLELIST VALUES ( ''WFJMSDestInfo'', ''N'', ''N'' ) '
		EXECUTE (@v_query)
		
		SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFPROCESSTABLELIST VALUES ( ''WFActionStatusTable'', ''N'', ''N'' ) '
		EXECUTE (@v_query)
		
		--SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFPROCESSTABLELIST VALUES ( ''WFAuthorizeQueueColorTable'', ''N'', ''N'' ) '
		--EXECUTE (@v_query)
		
		SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFPROCESSTABLELIST VALUES ( ''WFQueueColorTable'', ''N'', ''Y'' ) '
		EXECUTE (@v_query)
		
		SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFPROCESSTABLELIST VALUES ( ''WFFilterTable'', ''N'', ''N'' ) '
		EXECUTE (@v_query)
		
		SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFPROCESSTABLELIST VALUES ( ''WFAutoGenInfoTable'', ''N'', ''N'' ) '
		EXECUTE (@v_query)
		
		SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFPROCESSTABLELIST VALUES ( ''WFRoutingServerInfo'', ''N'', ''Y'' ) '
		EXECUTE (@v_query)
		
		SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFPROCESSTABLELIST VALUES ( ''WFProxyInfo'', ''N'', ''N'' ) '
		EXECUTE (@v_query)
		
		--SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFPROCESSTABLELIST VALUES ( ''WFAuthorizationTable'', ''N'', ''Y'' ) '
		--EXECUTE (@v_query)
		
		SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFPROCESSTABLELIST VALUES ( ''WFEXPORTINFOTABLE'', ''N'', ''N'' ) '
		EXECUTE (@v_query)
		
		SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFPROCESSTABLELIST VALUES ( ''WFSOURCECABINETINFOTABLE'', ''N'', ''N'' ) '
		EXECUTE (@v_query)
		
		--SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFPROCESSTABLELIST VALUES ( ''WFTMSChangeQueuePropertyEx'', ''N'', ''N'' ) '
		--EXECUTE (@v_query)
		
		--SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFPROCESSTABLELIST VALUES ( ''WFTMSAddQueue'', ''N'', ''N'' ) '
		--EXECUTE (@v_query)
		
		--SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFPROCESSTABLELIST VALUES ( ''WFTMSDeleteQueue'', ''N'', ''N'' ) '
		--EXECUTE (@v_query)
		
		--SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFPROCESSTABLELIST VALUES ( ''WFTransportRegisterationInfo'', ''N'', ''N'' ) '
		--EXECUTE (@v_query)
		
		SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFPROCESSTABLELIST VALUES ( ''WFUnderlyingDMS'', ''N'', ''N'' ) '
		EXECUTE (@v_query)
		
		SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFPROCESSTABLELIST VALUES ( ''WFSharePointInfo'', ''N'', ''N'' ) '
		EXECUTE (@v_query)
		
		SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFPROCESSTABLELIST VALUES ( ''WFDMSLibrary'', ''N'', ''Y'' ) '
		EXECUTE (@v_query)
		
		SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFPROCESSTABLELIST VALUES ( ''VARALIASTABLE'', ''N'', ''Y'' ) '
		EXECUTE (@v_query)
		
		SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFPROCESSTABLELIST VALUES ( ''WFPROFILETABLE'', ''N'', ''Y'' ) '
		EXECUTE (@v_query)
		
		SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFPROCESSTABLELIST VALUES ( ''WFOBJECTLISTTABLE'', ''N'', ''Y'' ) '
		EXECUTE (@v_query)
		
		SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFPROCESSTABLELIST VALUES ( ''WFASSIGNABLERIGHTSTABLE'', ''N'', ''N'' ) '
		EXECUTE (@v_query)
		
		--SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFPROCESSTABLELIST VALUES ( ''WFPROFILEOBJTYPETABLE'', ''N'', ''N'' ) '
		--EXECUTE (@v_query)
		
		--SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFPROCESSTABLELIST VALUES ( ''WFUSEROBJASSOCTABLE'', ''N'', ''N'' ) '
		--EXECUTE (@v_query)
		
		SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFPROCESSTABLELIST VALUES ( ''WFFILTERLISTTABLE'', ''N'', ''N'' ) '
		EXECUTE (@v_query)
		
		SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFPROCESSTABLELIST VALUES ( ''WFPROJECTLISTTABLE'', ''N'', ''N'' ) '
		EXECUTE (@v_query)
		
		SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFPROCESSTABLELIST VALUES ( ''WFCalDefTable'', ''N'', ''N'' ) '
		EXECUTE (@v_query)
		
		SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFPROCESSTABLELIST VALUES ( ''WFCalHourDefTable'', ''N'', ''N'' ) '
		EXECUTE (@v_query)
		
		SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFPROCESSTABLELIST VALUES ( ''WFCalRuleDefTable'', ''N'', ''N'' ) '
		EXECUTE (@v_query)
		
		SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFPROCESSTABLELIST VALUES ( ''WFLaneQueueTable'', ''N'', ''N'' ) '
		EXECUTE (@v_query)
		
		SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFPROCESSTABLELIST VALUES ( ''WFSAPConnectTable'', ''N'', ''N'' ) '
		EXECUTE (@v_query)
		
		SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFPROCESSTABLELIST VALUES ( ''STATESDEFTABLE'', ''N'', ''N'' ) '
		EXECUTE (@v_query)
		
		SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFPROCESSTABLELIST VALUES ( ''WFSAPGUIDefTable'', ''N'', ''N'' ) '
		EXECUTE (@v_query)
		
		SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFPROCESSTABLELIST VALUES ( ''WFSAPGUIFieldMappingTable'', ''N'', ''N'' ) '
		EXECUTE (@v_query)
		
		SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFPROCESSTABLELIST VALUES ( ''WFBRMSCONNECTTABLE'', ''N'', ''N'' ) '
		EXECUTE (@v_query)
		
		SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFPROCESSTABLELIST VALUES ( ''WFBRMSRULESETINFO'', ''N'', ''N'' ) '
		EXECUTE (@v_query)
		
		SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFPROCESSTABLELIST VALUES ( ''WFSYSTEMPROPERTIESTABLE'', ''N'', ''N'' ) '
		EXECUTE (@v_query)
		
		SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFPROCESSTABLELIST VALUES ( ''WFUSERSKILLCATEGORYTABLE'', ''N'', ''Y'' ) '
		EXECUTE (@v_query)
		
		SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFPROCESSTABLELIST VALUES ( ''WFUSERSKILLDEFINITIONTABLE'', ''N'', ''Y'' ) '
		EXECUTE (@v_query)

		SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFPROCESSTABLELIST VALUES ( ''WFWORKDESKLAYOUTTABLE'', ''N'', ''N'' ) '
		EXECUTE (@v_query)
		
		SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFPROCESSTABLELIST VALUES ( ''WFWORKLISTCONFIGTABLE'', ''N'', ''N'' ) '
		EXECUTE (@v_query)

		SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFPROCESSTABLELIST VALUES ( ''WFEVENTDETAILSTABLE'', ''N'', ''N'' ) '
		EXECUTE (@v_query)

		SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFPROCESSTABLELIST VALUES ( ''WFREPEATEVENTTABLE'', ''N'', ''N'' ) '
		EXECUTE (@v_query)

		  
		IF(@v_moveTaskData = 'Y') 
		BEGIN
		  SELECT @v_query = 'INSERT INTO '+@v_targetCabinet+'..WFPROCESSTABLELIST VALUES('' TaskTemplateLibraryDefTable'',''N'',''N'') '
		  EXECUTE (@v_query) 
		  SELECT @v_query = 'INSERT INTO '+@v_targetCabinet+'..WFPROCESSTABLELIST VALUES(''TaskTemplateFieldLibraryDefTable'',''N'',''N'')'
		  EXECUTE (@v_query) 
		  SELECT @v_query = 'INSERT INTO '+@v_targetCabinet+'..WFPROCESSTABLELIST VALUES(''TaskTempLibraryControlValues'',''N'',''N'') '	
		  EXECUTE (@v_query) 
		END
	END
	