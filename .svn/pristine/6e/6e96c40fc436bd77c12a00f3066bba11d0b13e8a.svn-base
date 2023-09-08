/*__________________________________________________________________________________;
			NEWGEN SOFTWARE TECHNOLOGIES LIMITED;
			Group                       : Genesis;
			Product / Project           : IBPS;
			Module                      : IBPS Server;
			File Name                   : RebuildIndexes.sql (MSSQL)
			Author                      : Kahkeshan
			Date written (DD/MM/YYYY)   : 25 JUNE 2014
			Description                 : Stored Procedure To Rebuild Indexes after Migration
			____________________________________________________________________________________;
			CHANGE HISTORY;
			____________________________________________________________________________________;
			Date        Change By        Change Description (Bug No. (IF Any))
	____________________________________________________________________________________*/	
	If Exists (Select * FROM SysObjects (NOLOCK) Where xType = 'P' and name = 'RebuildIndexes')
	Begin
		Execute('DROP Procedure RebuildIndexes')
		Print 'Procedure RebuildIndexes already exists, hence older one dropped ..... '
	End

	~

	Create Procedure RebuildIndexes(
		@v_buildHistoryTables VARCHAR(1)
	)AS
	BEGIN
	
	/* Rebuilding ibps Tables indexes */
	EXEC RebuildIndexForTable 'WFInstrumentTable'
	EXEC RebuildIndexForTable 'WFCurrentRouteLogTable'
	EXEC RebuildIndexForTable 'WFAttributemessagetable'
	EXEC RebuildIndexForTable 'ToDoStatusTable'
	EXEC RebuildIndexForTable 'ExceptionTable'
	EXEC RebuildIndexForTable 'WFCommentsTable'
	
	IF(@v_buildHistoryTables = 'Y')
	BEGIN
		EXEC RebuildIndexForTable 'ToDoStatusHistoryTable'
		EXEC RebuildIndexForTable 'ExceptionHistoryTable'
		EXEC RebuildIndexForTable 'QueueHistoryTable'
	END
	
	/* Rebuilding Omnidocs Tables indexes */
	EXEC RebuildIndexForTable 'PDBRights'
	EXEC RebuildIndexForTable 'PDBIntGlobalindex'
	EXEC RebuildIndexForTable 'PDBBoolGlobalindex'
	EXEC RebuildIndexForTable 'PDBFloatGlobalindex'
	EXEC RebuildIndexForTable 'PDBDateGlobalindex'
	EXEC RebuildIndexForTable 'PDBStringGlobalindex'
	EXEC RebuildIndexForTable 'PDBLongGlobalIndex'
	EXEC RebuildIndexForTable 'PDBDocIdGlobalIndex'
	EXEC RebuildIndexForTable 'PDBTextGlobalIndex'
	EXEC RebuildIndexForTable 'PDBKeyword'
	EXEC RebuildIndexForTable 'PDBAnnotationObjectVersion'
	EXEC RebuildIndexForTable 'PDBAnnotationDataVersion'
	EXEC RebuildIndexForTable 'PDBAnnotationVersion'
	EXEC RebuildIndexForTable 'PDBAnnotationObject'
	EXEC RebuildIndexForTable 'PDBAnnotationData'
	EXEC RebuildIndexForTable 'PDBLinkNotesTable'
	EXEC RebuildIndexForTable 'PDBAnnotation'
	EXEC RebuildIndexForTable 'PDBFTSData'
	EXEC RebuildIndexForTable 'PDBFTSDataVersion'
	EXEC RebuildIndexForTable 'PDBDocumentVersion'
	EXEC RebuildIndexForTable 'PDBThumbNail'
	EXEC RebuildIndexForTable 'PDBThumbNailVersion'
	EXEC RebuildIndexForTable 'PDBReminder'
	EXEC RebuildIndexForTable 'PDBAlarm'
	EXEC RebuildIndexForTable 'PDBFoldDocLockStatus'
	EXEC RebuildIndexForTable 'PDBDocumentContent'
	EXEC RebuildIndexForTable 'PDBDocument'
END

	