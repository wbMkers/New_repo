	/*__________________________________________________________________________________;
	NEWGEN SOFTWARE TECHNOLOGIES LIMITED;
	Group                       : Genesis;
	Product / Project           : IBPS;
	Module                      : IBPS Server;
	File Name                   : WFSynchLinksData.sql (MSSQL)
	Author                      : Kahkeshan
	Date written (DD/MM/YYYY)   : 23 MAY 2014
	Description                 : Stored Procedure To Synch WFLinksTable Data
	____________________________________________________________________________________;
	CHANGE HISTORY;
	____________________________________________________________________________________;
	Date        Change By        Change Description (Bug No. (IF Any))
	____________________________________________________________________________________*/
	

	If Exists (Select * FROM SysObjects  WITH (NOLOCK)  Where xType = 'P' and name = 'WFSynchLinksData')
	Begin
		Execute('DROP PROCEDURE WFSynchLinksData')
		Print 'Procedure WFSynchLinksData already exists, hence older one dropped ..... '
	End

	~

	Create Procedure WFSynchLinksData
	(
		@v_sourceCabinet      			VARCHAR(256),
		@v_targetCabinet      			VARCHAR(256),
		@dblinkString          			VARCHAR(256),
		@executionLogId				INT
	)
	AS
	BEGIN
		Declare @vquery 			NVARCHAR(2000)
		Declare @v_queryStr			NVARCHAR(2000)
		Declare @vqueryParam		NVARCHAR(2000)
		Declare @v_count			INT
		Declare @v_lastInstanceId 	NVARCHAR(70)
		Declare @v_processInstanceId NVARCHAR(70)
		Declare @v_conditionStr		NVARCHAR(100)
		
		Select @v_lastInstanceId = ''
		Execute('Truncate table ' + @v_targetCabinet + '..WFLinksTable' )
		If(@@error <> 0 )
		Begin
				Print 'Error in truncation of v_linkCursor'
				Close v_linkCursor
				Deallocate v_linkCursor
				Return
		End
		
		WHILE(1=1)
		Begin
			/*Check added*/
			if(@v_lastInstanceId = '')
			BEGIN
				SELECT @v_conditionStr = ''
			END
			else
			BEGIN
				SELECT @v_conditionStr = ' where parentprocessinstanceid > ''' + @v_lastInstanceId + ''''
			END
			--PRINT @v_conditionStr
			
			Select @vquery = 'Select top 100 parentprocessinstanceid from ' + @dblinkString + '.WFLinksTable ' + @v_conditionStr + ' order by parentprocessinstanceid '
			
			--print @vquery
			
			Select @v_queryStr = ' SELECT @value =  count(*) from ( Select top 100 parentprocessinstanceid from ' + @dblinkString + '.WFLinksTable ' + @v_conditionStr + ' order by parentprocessinstanceid )a' 
			Select @vqueryParam = '@value int output'
			EXEC sp_executesql @v_queryStr, @vqueryParam, @value = @v_count OUTPUT
			
			/*Check ends*/

			If(@v_count = 0 )
			Begin
				break 
			End
			Execute ( ' Declare v_linkCursor Cursor Fast_Forward for ' + @vquery)
			If(@@error <> 0 )
			begin
				Print 'error in declaration of v_linkCursor'
				Close v_linkCursor
				Deallocate v_linkCursor
				Return
			end
			Open v_linkCursor
			If(@@error <> 0 )
			begin
				Print 'error in opening of v_linkCursor'
				Close v_linkCursor
				Deallocate v_linkCursor
				Return
			end
			Fetch next from v_linkCursor into @v_processInstanceId
			If(@@error <> 0 )
			begin
				Print 'error in opening of v_linkCursor'
				Close v_linkCursor
				Deallocate v_linkCursor
				Return
			end
			
			While( @@Fetch_Status <>  -1)
			Begin
				If(@@Fetch_Status <>  -2)
				Begin
					Select @vquery = 'Insert into ' + @v_targetCabinet + '..WfLinksTable Select * from ' + @dblinkString + '.WfLinksTable where ParentProcessInstanceid = ' +
									'''' + @v_processInstanceId + ''''
					Execute ( @vquery )
					Select @v_lastInstanceId = @v_processInstanceId
				End
				Fetch next from v_linkCursor into @v_processInstanceId
				If(@@error <> 0 )
					begin
					Print 'error in opening of v_linkCursor'
					Close v_linkCursor
					Deallocate v_linkCursor
					Return
				end
			
			End
			Close v_linkCursor
			Deallocate v_linkCursor
		End
	
	END