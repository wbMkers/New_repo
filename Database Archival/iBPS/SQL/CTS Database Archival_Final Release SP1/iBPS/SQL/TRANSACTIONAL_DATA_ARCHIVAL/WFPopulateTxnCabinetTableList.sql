/*__________________________________________________________________________________;
	NEWGEN SOFTWARE TECHNOLOGIES LIMITED;
	Group                       : Genesis;
	Product / Project           : IBPS;
	Module                      : IBPS Server;
	File Name                   : WFPopulateTxnCabinetTableList.sql (MSSQL)
	Author                      : Kahkeshan
	Date written (DD/MM/YYYY)   : 26 MAY 2014
	Description                 : Stored Procedure To Populate Table List Invovled in 
								  Cabinet Level Transactional Data migration
	____________________________________________________________________________________;
	CHANGE HISTORY;
	____________________________________________________________________________________;
	Date        Change By        Change Description (Bug No. (IF Any))
	____________________________________________________________________________________*/


	If Exists (Select * FROM SysObjects (NOLOCK) Where xType = 'P' and name = 'WFPopulateTxnCabinetTableList')
	Begin
		Execute('DROP PROCEDURE WFPopulateTxnCabinetTableList')
		Print 'Procedure WFPopulateTxnCabinetTableList already exists, hence older one dropped ..... '
	End

	~


	CREATE Procedure WFPopulateTxnCabinetTableList
	(
		@v_targetCabinet VARCHAR(256)
	)AS
	BEGIN
		DECLARE @v_query VARCHAR(4000)
		SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFTXNCABINETBLELIST VALUES(''SummaryTable'',''N'') '
		EXECUTE(@v_query)
		
		SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFTXNCABINETBLELIST VALUES(''WFActivityReportTable'',''N'') '
		EXECUTE(@v_query)
		
		SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFTXNCABINETBLELIST VALUES(''WFRecordedChats'',''N'') '
		EXECUTE(@v_query)
		
		SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFTXNCABINETBLELIST VALUES(''WFUserRatingLogTable'',''N'') '
		EXECUTE(@v_query)
		
		SELECT @v_query = 'INSERT INTO ' + @v_targetCabinet + '..WFTXNCABINETBLELIST VALUES(''WFMailQueueHistoryTable'',''N'') '
		EXECUTE(@v_query)
	END
