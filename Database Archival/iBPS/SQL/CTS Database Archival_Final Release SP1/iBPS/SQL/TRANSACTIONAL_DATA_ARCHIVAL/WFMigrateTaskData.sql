/*__________________________________________________________________________________;
NEWGEN SOFTWARE TECHNOLOGIES LIMITED;
Group                       : Phoenix;
Product / Project           : IBPS;
Module                      : IBPS Server;
File Name                   : WFMigrateTaskData.sql (MS SQL)
Author                      : Sajid Khan
Date written (DD/MM/YYYY)   : 29 July 2015
Description                 : Stored Procedure for Transactional data Archival;
____________________________________________________________________________________;
CHANGE HISTORY
____________________________________________________________________________________;
Date        Change By        Change Description (Bug No. (IF Any))
____________________________________________________________________________________*/
/***************************************************************************************
*  Description : Transactional Data Migration Solution for IBPS
* It is mandatory to execute the script/procedures on Target cabinet
*
***************************************************************************************/
If Exists (Select * FROM SysObjects  WITH (NOLOCK)  Where xType = 'P' and name = 'WFMigrateTaskData')
Begin
	Execute('DROP PROCEDURE WFMigrateTaskData')
	Print 'Procedure WFMigrateTaskData already exists, hence older one dropped ..... '
End
~
	
Create PROCEDURE WFMigrateTaskData (
	@v_processDefId     			INT,
	@v_sourceCabinet      			VARCHAR(256),
	@v_targetCabinet      			VARCHAR(256),
	@dblinkString          			VARCHAR(256),
	@v_fromDate           			VARCHAR(256),
	@v_toDate			 			VARCHAR(256)
) AS
BEGIN
	Declare @v_taskId								INT
	Declare @v_query              				NVARCHAR(2000)
	Declare @v_tableName							NVARCHAR(50)

	BEGIN 
		Select @v_query = 'SELECT TaskId FROM '+@dblinkString+'.WFTaskDefTable WHERE ProcessDefId = '+CONVERT(NVarchar(10),@v_ProcessDefId)
		EXECUTE('DECLARE v_taskCursor CURSOR  FAST_FORWARD for ' + @v_query)
		IF(@@error <> 0)
		Begin
			PRINT ' [WFMigrateTaskData] Error in executing v_taskCursor cursor query'
			CLOSE v_taskCursor 
			DEALLOCATE v_taskCursor 
			RETURN
		End
		
		OPEN v_taskCursor
		
		IF(@@error <> 0)
		Begin
			PRINT ' [WFMigrateTaskData] Error in opening v_taskCursor cursor query'
			CLOSE v_taskCursor 
			DEALLOCATE v_taskCursor 
			RETURN
		End
		
		FETCH NEXT FROM v_taskCursor INTO @v_taskId
		WHILE @@FETCH_STATUS = 0
		BEGIN
			Select @v_tableName = 'WFGenericData_'+CONVERT(NVarchar(10),@v_ProcessDefId)+'_'+CONVERT(NVarchar(10),@v_taskId)
			EXEC WFMoveTaskData @v_sourceCabinet,@v_targetCabinet,@dblinkString,@v_tableName,@v_fromDate,@v_toDate
			FETCH NEXT FROM v_taskCursor INTO  @v_taskId
		END
		CLOSE v_taskCursor 
		DEALLOCATE v_taskCursor 
	END
END
