	/*__________________________________________________________________________________;
			NEWGEN SOFTWARE TECHNOLOGIES LIMITED;
			Group                       : Genesis;
			Product / Project           : IBPS;
			Module                      : IBPS Server;
			File Name                   : RebuildIndexForTable.sql (MSSQL)
			Author                      : Kahkeshan
			Date written (DD/MM/YYYY)   : 25 JUNE 2014
			Description                 : Stored Procedure To Rebuild Indexes After Data 
										  Migration
			____________________________________________________________________________________;
			CHANGE HISTORY;
			____________________________________________________________________________________;
			Date        Change By        Change Description (Bug No. (IF Any))
	____________________________________________________________________________________*/	
		
	/* Rebuild Indexes for ibps Tables */
	
	If Exists (Select * FROM SysObjects (NOLOCK) Where xType = 'P' and name = 'RebuildIndexForTable')
	Begin
		Execute('DROP Procedure RebuildIndexForTable')
		Print 'Procedure RebuildIndexForTable already exists, hence older one dropped ..... '
	End

	~

	Create Procedure RebuildIndexForTable(
		@v_tableName varchar(256)
	)As
	BEGIN
		Declare @vquery NVARCHAR(2000)
		Select @vquery = ' ALTER INDEX ALL ON ' + @v_tableName + ' REBUILD WITH (FILLFACTOR = 80, SORT_IN_TEMPDB = ON,STATISTICS_NORECOMPUTE = ON) '
		Execute (@vquery)
	END
	