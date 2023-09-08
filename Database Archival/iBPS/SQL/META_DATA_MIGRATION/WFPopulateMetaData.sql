	/*__________________________________________________________________________________;
		NEWGEN SOFTWARE TECHNOLOGIES LIMITED;
		Group                       : Genesis;
		Product / Project           : IBPS;
		Module                      : IBPS Server;
		File Name                   : WFPopulateMetaData.sql (MSSQL)
		Author                      : Kahkeshan
		Date written (DD/MM/YYYY)   : 21 MAY 2014
		Description                 : Stored Procedure To Populate WFMETADATATABLELIST Table
									  List
		____________________________________________________________________________________;
		CHANGE HISTORY;
		____________________________________________________________________________________;
		Date        Change By        Change Description (Bug No. (IF Any))
		21/9/2017	Ambuj			Added the changes for Archiving the case management tables
		____________________________________________________________________________________*/	

	If Exists (Select * FROM SysObjects  WITH (NOLOCK)  Where xType = 'P' and name = 'WFPopulateMetaData')
	Begin
		Execute('DROP PROCEDURE WFPopulateMetaData')
		Print 'Procedure WFPopulateMetaData already exists, hence older one dropped ..... '
	End

	~

	CREATE 
	PROCEDURE WFPopulateMetaData(
		@v_targetCabinet			VARCHAR(256),
		@v_moveTaskData				VARCHAR(1)
	) AS
	BEGIN
		DECLARE @v_query            VARCHAR(4000)
		
		SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFMETADATATABLELIST VALUES (''PROCESSDEFTABLE'', ''N'', ''N'', ''Y'' ) '
		EXECUTE (@v_query)
		
		SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFMETADATATABLELIST VALUES (''ACTIONCONDITIONTABLE'', ''N'', ''N'', ''N'' ) '
		EXECUTE (@v_query)
		
		SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFMETADATATABLELIST VALUES (''ACTIONDEFTABLE'', ''N'', ''N'', ''N'' ) '
		EXECUTE (@v_query)
		
		SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFMETADATATABLELIST VALUES (''ACTIONOPERATIONTABLE'', ''N'', ''N'', ''N'' ) '
		EXECUTE (@v_query)
		
		SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFMETADATATABLELIST VALUES (''ACTIVITYASSOCIATIONTABLE'', ''N'', ''N'', ''N'' ) '
		EXECUTE (@v_query)
		
		SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFMETADATATABLELIST VALUES (''ACTIVITYINTERFACEASSOCTABLE'', ''N'', ''N'', ''N'' ) '
		EXECUTE (@v_query)
		
		SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFMETADATATABLELIST VALUES (''ACTIVITYTABLE'', ''N'', ''N'', ''N'' ) '
		EXECUTE (@v_query)
		
		SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFMETADATATABLELIST VALUES (''ARCHIVEDATAMAPTABLE'', ''N'', ''N'', ''N'' ) '
		EXECUTE (@v_query)
		
		SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFMETADATATABLELIST VALUES (''ARCHIVEDOCTYPETABLE'', ''N'', ''N'', ''N'' ) '
		EXECUTE (@v_query)
		
		SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFMETADATATABLELIST VALUES (''ARCHIVETABLE'', ''N'', ''N'', ''N'' ) '
		EXECUTE (@v_query)
		
		SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFMETADATATABLELIST VALUES (''CONSTANTDEFTABLE'', ''N'', ''N'', ''N'' ) '
		EXECUTE (@v_query)
		
		SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFMETADATATABLELIST VALUES (''DATAENTRYTRIGGERTABLE'', ''N'', ''N'', ''N'' ) '
		EXECUTE (@v_query)
		
		SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFMETADATATABLELIST VALUES (''DATASETTRIGGERTABLE'', ''N'', ''N'', ''N'' ) '
		EXECUTE (@v_query)
		
		SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFMETADATATABLELIST VALUES (''EXCEPTIONDEFTABLE'', ''N'', ''N'', ''N'' ) '
		EXECUTE (@v_query)
		
		SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFMETADATATABLELIST VALUES (''EXCEPTIONTRIGGERTABLE'', ''N'', ''N'', ''N'' ) '
		EXECUTE (@v_query)
		
		SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFMETADATATABLELIST VALUES (''EXECUTETRIGGERTABLE'', ''N'', ''N'', ''N'' ) '
		EXECUTE (@v_query)
		
		SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFMETADATATABLELIST VALUES (''EXTDBCONFTABLE'', ''N'', ''N'', ''N'' ) '
		EXECUTE (@v_query)
		
		SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFMETADATATABLELIST VALUES (''EXTDBFIELDDEFINITIONTABLE'', ''N'', ''N'', ''N'' ) '
		EXECUTE (@v_query)
		
		SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFMETADATATABLELIST VALUES (''EXTMETHODDEFTABLE'', ''N'', ''N'', ''N'' ) '
		EXECUTE (@v_query)
		
		SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFMETADATATABLELIST VALUES (''EXTMETHODPARAMDEFTABLE'', ''N'', ''N'', ''N'' ) '
		EXECUTE (@v_query)
		
		SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFMETADATATABLELIST VALUES (''EXTMETHODPARAMMAPPINGTABLE'', ''N'', ''N'', ''N'' ) '
		EXECUTE (@v_query)
		
		SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFMETADATATABLELIST VALUES (''GENERATERESPONSETABLE'', ''N'', ''N'', ''N'' ) '
		EXECUTE (@v_query)
		
		SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFMETADATATABLELIST VALUES (''IMPORTEDPROCESSDEFTABLE'', ''N'', ''N'', ''N'' ) '
		EXECUTE (@v_query)
		
		SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFMETADATATABLELIST VALUES (''INITIATEWORKITEMDEFTABLE'', ''N'', ''N'', ''N'' ) '
		EXECUTE (@v_query)
		
		SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFMETADATATABLELIST VALUES (''LAUNCHAPPTRIGGERTABLE'', ''N'', ''N'', ''N'' ) '
		EXECUTE (@v_query)
		
		SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFMETADATATABLELIST VALUES (''MAILTRIGGERTABLE'', ''N'', ''N'', ''N'' ) '
		EXECUTE (@v_query)
		
		SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFMETADATATABLELIST VALUES (''PROCESSDEFCOMMENTTABLE'', ''N'', ''N'', ''N'' ) '
		EXECUTE (@v_query)
		
		SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFMETADATATABLELIST VALUES (''PROCESS_INTERFACETABLE'', ''N'', ''N'', ''N'' ) '
		EXECUTE (@v_query)
		
		SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFMETADATATABLELIST VALUES (''RULECONDITIONTABLE'', ''N'', ''N'', ''N'' ) '
		EXECUTE (@v_query)
		
		SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFMETADATATABLELIST VALUES (''RULEOPERATIONTABLE'', ''N'', ''N'', ''N'' ) '
		EXECUTE (@v_query)
		
		SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFMETADATATABLELIST VALUES (''SCANACTIONSTABLE'', ''N'', ''N'', ''N'' ) '
		EXECUTE (@v_query)
		
		SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFMETADATATABLELIST VALUES (''TODOLISTDEFTABLE'', ''N'', ''N'', ''N'' ) '
		EXECUTE (@v_query)
		
		SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFMETADATATABLELIST VALUES (''TODOPICKLISTTABLE'', ''N'', ''N'', ''N'' ) '
		EXECUTE (@v_query)
		
		SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFMETADATATABLELIST VALUES (''TRIGGERDEFTABLE'', ''N'', ''N'', ''N'' ) '
		EXECUTE (@v_query)
		
		SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFMETADATATABLELIST VALUES (''TRIGGERTYPEDEFTABLE'', ''N'', ''N'', ''N'' ) '
		EXECUTE (@v_query)
		
		SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFMETADATATABLELIST VALUES (''VARMAPPINGTABLE'', ''N'', ''N'', ''N'' ) '
		EXECUTE (@v_query)
		
		SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFMETADATATABLELIST VALUES (''WFCalendarAssocTable'', ''N'', ''N'', ''N'' ) '
		EXECUTE (@v_query)

		SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFMETADATATABLELIST VALUES (''WFCalRuleDefTable'', ''N'', ''N'', ''N'' ) '
		EXECUTE (@v_query)
		
		SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFMETADATATABLELIST VALUES (''WFDataStructureTable'', ''N'', ''N'', ''N'' ) '
		EXECUTE (@v_query)
		
		SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFMETADATATABLELIST VALUES (''WFDurationTable'', ''N'', ''N'', ''N'' ) '
		EXECUTE (@v_query)
		
		SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFMETADATATABLELIST VALUES (''WFExtInterfaceConditionTable'', ''N'', ''N'', ''N'' ) '
		EXECUTE (@v_query)
		
		SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFMETADATATABLELIST VALUES (''WFExtInterfaceOperationTable'', ''N'', ''N'', ''N'' ) '
		EXECUTE (@v_query)
		
		SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFMETADATATABLELIST VALUES (''WFJMSPublishTable'', ''N'', ''N'', ''N'' ) '
		EXECUTE (@v_query)
		
		SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFMETADATATABLELIST VALUES (''WFJMSSubscribeTable'', ''N'', ''N'', ''N'' ) '
		EXECUTE (@v_query)
		
		SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFMETADATATABLELIST VALUES (''WFSearchVariableTable'', ''N'', ''N'', ''N'' ) '
		EXECUTE (@v_query)
		
		SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFMETADATATABLELIST VALUES (''WFSwimLaneTable'', ''N'', ''N'', ''N'' ) '
		EXECUTE (@v_query)
		
		SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFMETADATATABLELIST VALUES (''WFTypeDefTable'', ''N'', ''N'', ''N'' ) '
		EXECUTE (@v_query)
		
		SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFMETADATATABLELIST VALUES (''WFTypeDescTable'', ''N'', ''N'', ''N'' ) '
		EXECUTE (@v_query)
		
		SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFMETADATATABLELIST VALUES (''WFUDTVarMappingTable'', ''N'', ''N'', ''N'' ) '
		EXECUTE (@v_query)
		
		SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFMETADATATABLELIST VALUES (''WFVarRelationTable'', ''N'', ''N'', ''N'' ) '
		EXECUTE (@v_query)
		
		SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFMETADATATABLELIST VALUES (''WFWebServicetable'', ''N'', ''N'', ''N'' ) '
		EXECUTE (@v_query)
		
		SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFMETADATATABLELIST VALUES (''WORKSTAGELINKTABLE'', ''N'', ''N'', ''N'' ) '
		EXECUTE (@v_query)
		
		SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFMETADATATABLELIST VALUES (''WFDataMaptable'', ''N'', ''N'', ''N'' ) '
		EXECUTE (@v_query)
		
		SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFMETADATATABLELIST VALUES (''WFExporttable'', ''N'', ''N'', ''N'' ) '
		EXECUTE (@v_query)
		
		SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFMETADATATABLELIST VALUES (''WFFORM_table'', ''N'', ''N'', ''N'' ) '
		EXECUTE (@v_query)
		
		SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFMETADATATABLELIST VALUES (''WFSoapReqCorrelationtable'', ''N'', ''N'', ''N'' ) '
		EXECUTE (@v_query)
		
		SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFMETADATATABLELIST VALUES (''PRINTFAXEMAILDOCTYPETABLE'', ''N'', ''N'', ''N'' ) '
		EXECUTE (@v_query)
		
		SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFMETADATATABLELIST VALUES (''PRINTFAXEMAILTABLE'', ''N'', ''N'', ''N'' ) '
		EXECUTE (@v_query)
				
		SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFMETADATATABLELIST VALUES (''WFMileStoneTable'', ''N'', ''N'', ''N'' ) '
		EXECUTE (@v_query)
		
		SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFMETADATATABLELIST VALUES (''WFRequirementTable'', ''N'', ''N'', ''N'' ) '
		EXECUTE (@v_query)
		
		SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFMETADATATABLELIST VALUES (''WFDocBuffer'', ''N'', ''N'', ''N'' ) '
		EXECUTE (@v_query)
		
		SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFMETADATATABLELIST VALUES (''WFActivitySequenceTable'', ''N'', ''N'', ''N'' ) '
		EXECUTE (@v_query)
		
		SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFMETADATATABLELIST VALUES (''WFWebServiceInfoTable'', ''N'', ''N'', ''N'' ) '
		EXECUTE (@v_query)
		
		SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFMETADATATABLELIST VALUES (''WFGroupBoxTable'', ''N'', ''N'', ''N'' ) '
		EXECUTE (@v_query)
		
		SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFMETADATATABLELIST VALUES (''STREAMDEFTABLE'', ''N'', ''N'', ''N'' ) '
		EXECUTE (@v_query)
		
		SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFMETADATATABLELIST VALUES (''RECORDMAPPINGTABLE'', ''N'', ''N'', ''N'' ) '
		EXECUTE (@v_query)
		
		SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFMETADATATABLELIST VALUES (''WFEventDefTable'', ''N'', ''N'', ''N'' ) '
		EXECUTE (@v_query)
		
		SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFMETADATATABLELIST VALUES (''WFScopeDefTable'', ''N'', ''N'', ''N'' ) '
		EXECUTE (@v_query)
		
		SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFMETADATATABLELIST VALUES (''WFActivityScopeAssocTable'', ''N'', ''N'', ''N'' ) '
		EXECUTE (@v_query)
		
		SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFMETADATATABLELIST VALUES (''WFDataObjectTable'', ''N'', ''N'', ''N'' ) '
		EXECUTE (@v_query)
		
		SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFMETADATATABLELIST VALUES (''QueueStreamTable'', ''N'', ''N'', ''N'' ) '
		EXECUTE (@v_query)
		
		SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFMETADATATABLELIST VALUES (''WFProviderTable'', ''N'', ''N'', ''N'' ) '
		EXECUTE (@v_query)
		
		SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFMETADATATABLELIST VALUES (''WFSystemTable'', ''N'', ''N'', ''N'' ) '
		EXECUTE (@v_query)
		
		SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFMETADATATABLELIST VALUES (''WFOwnerTable'', ''N'', ''N'', ''N'' ) '
		EXECUTE (@v_query)
		
		SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFMETADATATABLELIST VALUES (''WFFormFragmentTable'', ''N'', ''N'', ''N'' ) '
		EXECUTE (@v_query)
	
		SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFMETADATATABLELIST VALUES (''WFSAPAdapterAssocTable'', ''N'', ''N'', ''N'' ) '
		EXECUTE (@v_query)
		
		SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFMETADATATABLELIST VALUES (''WFSAPGUIAssocTable'', ''N'', ''N'', ''N'' ) '
		EXECUTE (@v_query)
		
		SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFMETADATATABLELIST VALUES (''WFDOCTYPESEARCHMAPPING'', ''N'', ''N'', ''N'' ) '
		EXECUTE (@v_query)
		
		SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFMETADATATABLELIST VALUES (''WFMsgAFTable'', ''N'', ''N'', ''N'' ) '
		EXECUTE (@v_query)
		
		SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFMETADATATABLELIST VALUES (''WFPDATable'', ''N'', ''N'', ''N'' ) '
		EXECUTE (@v_query)
		
		SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFMETADATATABLELIST VALUES (''WFPDA_FormTable'', ''N'', ''N'', ''N'' ) '
		EXECUTE (@v_query)
		
		SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFMETADATATABLELIST VALUES (''WFBRMSActivityAssocTable'', ''N'', ''N'', ''N'' ) '
		EXECUTE (@v_query)
		
		SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFMETADATATABLELIST VALUES (''ROUTEPARENTTABLE'', ''N'', ''N'', ''N'' ) '
		EXECUTE (@v_query)
		
		SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFMETADATATABLELIST VALUES (''PROCESSINITABLE'', ''N'', ''N'', ''N'' ) '
		EXECUTE (@v_query)
		
		SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFMETADATATABLELIST VALUES (''WFVARSTATUSTABLE'', ''N'', ''N'', ''N'' ) '
		EXECUTE (@v_query)
		
		SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFMETADATATABLELIST VALUES (''INTERFACEDESCLANGUAGETABLE'', ''N'', ''N'', ''N'' ) '
		EXECUTE (@v_query)
		
		SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFMETADATATABLELIST VALUES (''WFQUICKSEARCHTABLE'', ''N'', ''N'', ''Y'' ) '
		EXECUTE (@v_query)
		
		SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFMETADATATABLELIST VALUES (''WFProcessVariantDefTable'', ''Y'', ''N'', ''Y'' ) '
		EXECUTE (@v_query)
		
		SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFMETADATATABLELIST VALUES (''WFVariantFieldInfoTable'', ''Y'', ''N'', ''N'' ) '
		EXECUTE (@v_query)
		
		SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFMETADATATABLELIST VALUES (''WFVariantFieldAssociationTable'', ''Y'', ''N'', ''N'' ) '
		EXECUTE (@v_query)
		
		SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFMETADATATABLELIST VALUES (''WFVariantFormListenerTable'', ''Y'', ''N'', ''N'' ) '
		EXECUTE (@v_query)
		
		SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFMETADATATABLELIST VALUES (''WFVariantFormTable'', ''Y'', ''N'', ''Y'' ) '
		EXECUTE (@v_query)
		
		SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFMETADATATABLELIST VALUES (''WFDocTypeFieldMapping'', ''N'', ''N'', ''N'' ) '
		EXECUTE (@v_query)
		
		SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFMETADATATABLELIST VALUES (''RouteFolderDefTable'', ''N'', ''N'', ''N'' ) '
		EXECUTE (@v_query)
		
		SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFMETADATATABLELIST VALUES (''WFARCHIVEINSHAREPOINT'', ''N'', ''N'', ''N'' ) '
		EXECUTE (@v_query)
		
		SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFMETADATATABLELIST VALUES (''WFBPELDEFTABLE'', ''N'', ''N'', ''N'' ) '
		EXECUTE (@v_query)
		
		SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFMETADATATABLELIST VALUES (''WFCREATECHILDWITABLE'', ''N'', ''N'', ''N'' ) '
		EXECUTE (@v_query)
		
		SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFMETADATATABLELIST VALUES (''WFPOOLTABLE'', ''N'', ''N'', ''N'' ) '
		EXECUTE (@v_query)
		
		SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFMETADATATABLELIST VALUES (''WFPROCESSSHAREPOINTASSOC'', ''N'', ''N'', ''N'' ) '
		EXECUTE (@v_query)
		
		SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFMETADATATABLELIST VALUES (''WFSHAREPOINTDOCASSOCTABLE'', ''N'', ''N'', ''N'' ) '
		EXECUTE (@v_query)
		
		SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFMETADATATABLELIST VALUES (''WFSHAREPOINTDATAMAPTABLE'', ''N'', ''N'', ''N'' ) '
		EXECUTE (@v_query)
		
		 IF(@v_moveTaskData = 'Y')  
			BEGIN
				SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFMETADATATABLELIST VALUES (''WFTaskDefTable'', ''N'',''N'',''N'')' 
				EXECUTE (@v_query)
				SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFMETADATATABLELIST VALUES (''WFTaskInterfaceAssocTable'', ''N'',''N'',''N'')'
				EXECUTE (@v_query)
				SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFMETADATATABLELIST VALUES (''WFTaskTemplateFieldDefTable'', ''N'',''N'',''N'') ';
				EXECUTE (@v_query)
				SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFMETADATATABLELIST VALUES (''WFTaskTemplateDefTable'', ''N'',''N'',''N'') ';
				EXECUTE (@v_query)
				SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFMETADATATABLELIST VALUES (''WFTaskTempControlValues'', ''N'',''N'',''N'') ';
				EXECUTE (@v_query)
				SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFMETADATATABLELIST VALUES (''WFTaskVariableMappingTable'', ''N'',''N'',''N'') ';
				EXECUTE (@v_query)
				SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFMETADATATABLELIST VALUES (''WFTaskRulePreConditionTable'', ''N'',''N'',''N'') ';
				EXECUTE (@v_query)
				SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFMETADATATABLELIST VALUES (''WFTaskFormTable'', ''N'',''N'',''N'') ';
				EXECUTE (@v_query)				
				SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFMETADATATABLELIST VALUES (''WFCaseDataVariableTable'', ''N'',''N'',''N'') ';
				EXECUTE (@v_query)
				
				--IBPS 3.2 start
				SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFMETADATATABLELIST VALUES (''WFDefaultTaskUser'', ''N'',''N'',''N'')' 
				EXECUTE (@v_query)
				SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFMETADATATABLELIST VALUES (''WFTaskruleOperationTable'', ''N'',''N'',''N'')' 
				EXECUTE (@v_query)
				SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFMETADATATABLELIST VALUES (''WFTaskPropertyTable'', ''N'',''N'',''N'')' 
				EXECUTE (@v_query)
				SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFMETADATATABLELIST VALUES (''WFGenericServicesTable'', ''N'',''N'',''N'')' 
				EXECUTE (@v_query)
				SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFMETADATATABLELIST VALUES (''WFTaskExpiryOperation'', ''N'',''N'',''N'')' 
				EXECUTE (@v_query)
				SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFMETADATATABLELIST VALUES (''CaseINITIATEWORKITEMTABLE'', ''N'',''N'',''N'')' 
				EXECUTE (@v_query)
				SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFMETADATATABLELIST VALUES (''CaseIMPORTEDPROCESSDEFTABLE'', ''N'',''N'',''N'')' 
				EXECUTE (@v_query)
				SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFMETADATATABLELIST VALUES (''WFCaseInfoVariableTable'', ''N'',''N'',''N'')' 
				EXECUTE (@v_query)
				SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFMETADATATABLELIST VALUES (''WFTaskUserAssocTable'', ''N'',''N'',''N'')' 
				EXECUTE (@v_query)
				
				--IBPS 3.2 end
			END
	END
