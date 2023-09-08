	/*__________________________________________________________________________________;
	NEWGEN SOFTWARE TECHNOLOGIES LIMITED;
	Group                       : Genesis;
	Product / Project           : IBPS;
	Module                      : IBPS Server;
	File Name                   : WFMoveHistoryAuditTrailData.sql (MSSQL)
	Author                      : Kahkeshan
	Date written (DD/MM/YYYY)   : 23 MAY 2014
	Description                 : Stored Procedure To Move History Audit Trail Data
	____________________________________________________________________________________;
	CHANGE HISTORY;
	____________________________________________________________________________________;
	Date        Change By        Change Description (Bug No. (IF Any))
	____________________________________________________________________________________*/
	
	
	If Exists (Select * FROM SysObjects  WITH (NOLOCK)  Where xType = 'P' and name = 'WFMoveHistoryAuditTrailData')
	Begin
		Execute('DROP PROCEDURE WFMoveHistoryAuditTrailData')
		Print 'Procedure WFMoveHistoryAuditTrailData already exists, hence older one dropped ..... '
	End

	~

	create Procedure WFMoveHistoryAuditTrailData
	(	 
		@v_processInstanceId  		NVARCHAR(256),
		@v_processDefId				INT,
		@v_sourceCabinet			VARCHAR(256),
		@v_targetCabinet			VARCHAR(256),
		@dblinkString				VARCHAR(256),
		@v_fromDate           		VARCHAR(256),
		@v_toDate					VARCHAR(256),
		@executionLogId				INT
		
	)AS
	BEGIN
		DECLARE  @v_query  VARCHAR(4000)
		DECLARE  @colStr   NVARCHAR(2000)
		
		SELECT @v_query =  'Insert into WFHistoryRouteLogTable Select * from ' + @dblinkString + '.WFHistoryRouteLogTable where processinstanceid = '+''''+ @v_processInstanceId + ''''
		EXECUTE(@v_query)
		
		SELECT @v_query =  'Delete from ' + @dblinkString  + '.WFHistoryRouteLogTable where processinstanceid = '+''''+ @v_processInstanceId + ''''
		EXECUTE(@v_query)
		
		EXECUTE GetColStr 'WFATTRIBUTEMESSAGETABLE',@v_columnStr = @colStr OUTPUT
		SELECT @v_query = 'set IDENTITY_INSERT '  + @v_targetCabinet + '..WFATTRIBUTEMESSAGETABLE ON' + ' Insert into WFATTRIBUTEMESSAGETABLE ( ' + @colStr +' ) Select * from ' +  @dblinkString + '.WFATTRIBUTEMESSAGETABLE where processinstanceid = '+''''+ @v_processInstanceId + '''' + ' set IDENTITY_INSERT '  + @v_targetCabinet + '.. WFATTRIBUTEMESSAGETABLE OFF'
		EXECUTE(@v_query)
		SELECT @v_query =  'Delete from ' + @dblinkString  + '.WFATTRIBUTEMESSAGETABLE where processinstanceid = '+''''+ @v_processInstanceId + ''''
		EXECUTE(@v_query)
		
		EXECUTE GetColStr 'WFATTRIBUTEMESSAGEHISTORYTABLE',@v_columnStr = @colStr OUTPUT
		SELECT @v_query = ' Insert into WFATTRIBUTEMESSAGEHISTORYTABLE (' + @colStr + ') Select * from ' +  @dblinkString + '..WFATTRIBUTEMESSAGEHISTORYTABLE where processinstanceid = '+''''+ @v_processInstanceId + ''''
		EXECUTE (@v_query)
		
		SELECT @v_query =  'Delete from ' + @dblinkString + '..WFATTRIBUTEMESSAGEHISTORYTABLE where processinstanceid = '+''''+ @v_processInstanceId + ''''
		EXECUTE(@v_query)
		PRINT 'WFMoveHistoryAuditTrailData executed successfuly'
	END
