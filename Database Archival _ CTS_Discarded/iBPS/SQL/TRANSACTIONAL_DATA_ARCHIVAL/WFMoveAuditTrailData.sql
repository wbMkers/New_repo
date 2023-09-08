	/*__________________________________________________________________________________;
	NEWGEN SOFTWARE TECHNOLOGIES LIMITED;
	Group                       : Genesis;
	Product / Project           : IBPS;
	Module                      : IBPS Server;
	File Name                   : WFMoveAuditTrailData.sql (MSSQL)
	Author                      : Kahkeshan
	Date written (DD/MM/YYYY)   : 23 MAY 2014
	Description                 : Stored Procedure To Move Audit Trail Data
	____________________________________________________________________________________;
	CHANGE HISTORY;
	____________________________________________________________________________________;
	Date        Change By        Change Description (Bug No. (IF Any))
	10-09-2019	Ambuj Tripathi		Internal Bug fixes- increased the length of variable @colStr
	____________________________________________________________________________________*/
	
	
	If Exists (Select * FROM SysObjects  WITH (NOLOCK)  Where xType = 'P' and name = 'WFMoveAuditTrailData')
	Begin
		Execute('DROP PROCEDURE WFMoveAuditTrailData')
		Print 'Procedure WFMoveAuditTrailData already exists, hence older one dropped ..... '
	End

	~

	CREATE Procedure WFMoveAuditTrailData
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
		DECLARE  @colStr   NVARCHAR(4000)
		
		EXECUTE GetColStr 'WFHistoryRouteLogTable',@v_columnStr = @colStr OUTPUT
		SELECT @v_query = ' Insert into WFHistoryRouteLogTable ( ' + @colStr +' ) Select * from ' +  @dblinkString + '.WFCurrentRouteLogTable where processinstanceid = '+''''+ @v_processInstanceId + ''''
		EXECUTE(@v_query)
		SELECT @v_query =  'Delete from ' + @dblinkString  + '.WFCurrentRouteLogTable where processinstanceid = '+''''+ @v_processInstanceId + ''''
		EXECUTE(@v_query)

		EXECUTE GetColStr 'WFATTRIBUTEMESSAGEHISTORYTABLE',@v_columnStr = @colStr OUTPUT
		SELECT @v_query = ' Insert into WFATTRIBUTEMESSAGEHISTORYTABLE ( ' + @colStr +' ) Select * from ' +  @dblinkString + '.WFATTRIBUTEMESSAGETABLE where processinstanceid = '+''''+ @v_processInstanceId + ''''
		EXECUTE(@v_query)
		SELECT @v_query =  'Delete from ' + @dblinkString  + '.WFATTRIBUTEMESSAGETABLE where processinstanceid = '+''''+ @v_processInstanceId + ''''
		EXECUTE(@v_query)

		
		PRINT 'WFMoveAuditTrailData executed successfuly'
	END
