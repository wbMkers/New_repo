/*__________________________________________________________________________________;
NEWGEN SOFTWARE TECHNOLOGIES LIMITED;
Group                       : Phoenix;
Product / Project           : IBPS;
Module                      : IBPS Server;
File Name                   : WFMoveTaskData.sql (MS SQL)
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

If Exists (Select * FROM SysObjects  WITH (NOLOCK)  Where xType = 'P' and name = 'WFMoveTaskData')
Begin
	Execute('DROP PROCEDURE WFMoveTaskData')
	Print 'Procedure WFMoveTaskData already exists, hence older one dropped ..... '
End
~
	
create PROCEDURE WFMoveTaskData (
	@v_sourceCabinet                         Varchar(256),
    @v_targetCabinet                         Varchar(256),
	@dblinkString          					 VARCHAR(256),
	@v_tableName							Varchar(50),
	@v_fromDate           					 VARCHAR(256),	
	@v_toDate			 					VARCHAR(256)
) AS
	
BEGIN
	Declare @v_taskId							INT
	Declare @v_query              				NVARCHAR(2000)
	Declare @v_filterString						NVARCHAR(1000)
	DECLARE @ParmDefinition 					NVARCHAR(500)
	Declare @existsFlag							INT
	DECLARE @v_orderByString	VARCHAR(4000)
	BEGIN 
	 
	Select @v_filterString =' where EntryDateTime Between '''+@v_fromDate+'''' ; 
	Select @v_filterString  = @v_filterString+ ' and  '''+@v_toDate+'''';
	SELECT @v_orderByString = ' Order By ProcessInstanceId'
	
	BEGIN
		Select @existsFlag	= 0
		Select @v_query = 'Select @retvalOUT = 1 From '+@dblinkString+'SYS.TABLES WHERE NAME = '''+@v_tableName+''''
		SET @ParmDefinition = '@retvalOUT int OUTPUT'
		EXEC sp_executesql @v_query, @ParmDefinition, @retvalOUT=@existsFlag OUTPUT
		IF(@existsFlag = 0)
		Begin
			PRINT ' [WFMoveTaskData] Table Doest Not exist on Source Cabinet'
			RETURN
		End
		
		While(1=1)
			BEGIN
				Select @existsFlag	= 0
				Select @v_query = ' Select @retvalOUT =  count(*)  from ( Select Top 100 * FROM ' +@dblinkString+ '.' +@v_tableName+@v_filterString+' ) A '
				SET @ParmDefinition = '@retvalOUT int OUTPUT'
				EXEC sp_executesql @v_query, @ParmDefinition, @retvalOUT=@existsFlag OUTPUT
				IF(@existsFlag < 1)
				Begin
					PRINT ' [WFMoveTaskData] Table Doest Not Contain Any record to be moved from  Source Cabinet'
					RETURN
				End
				 
				Select @v_query = 'Insert into '+@v_tableName+' Select TOP 100 * from '+@dblinkString+'.'+@v_tableName+@v_filterString
				EXECUTE(@v_query)
				 
				Select @v_query = 'Delete TOP(100) from '+@dblinkString+'.'+@v_tableName+@v_filterString
				EXECUTE(@v_query)
			END
		END
	END	
END
