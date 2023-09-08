/*
Change DATE		Name				Description
--------------------------------------------------------------
26/05/2017		Ashok Kumar		Bug 62518 - Step by Step Debugs in Version Upgrade.
*/

If Exists (Select * from SysObjects Where xType = 'P' and name = 'update_searchview')
Begin
	Execute('DROP PROCEDURE update_searchview')
	Print 'Procedure update_searchview, Part of Upgrade already exists, hence older one dropped ..... '
End

~

Create Procedure update_searchview as  
Begin
	DECLARE @v_logStatus  NVARCHAR(10) 
	DECLARE @v_scriptName varchar(100)
	SET NOCOUNT ON
	SELECT @v_scriptName = 'Upgrade09_SP00_006'
	
		
exec @v_logStatus= LogInsert 1,@v_scriptName,'Updating WFSearchView'
	BEGIN
	BEGIN TRY
		exec  @v_logStatus = LogSkip 1,@v_scriptName
		Declare @QueueId Varchar(10)
		Declare @Query	Varchar(8000)
		IF NOT EXISTS(Select * from sysObjects where name = 'QUEUETABLE' AND xType = 'V')
		BEGIN
			RETURN
		END
		Declare changeview_cur Cursor FAST_FORWARD For 
			select QueueId From QueueDefTable 
		
		OPEN changeview_cur
		IF (@@CURSOR_ROWS <> 0)
		BEGIN
			FETCH NEXT FROM changeview_cur INTO @QueueId
			WHILE (@@FETCH_STATUS = 0)
			BEGIN
				IF EXISTS(Select * from sysObjects where name = 'WFSearchView_' + Convert(varchar(4), @QueueId) AND xType = 'V')
					Execute ('Drop View WFSearchView_' + @QueueId)
				
				FETCH NEXT FROM changeview_cur INTO @QueueId
			End
		End
		CLOSE changeview_cur
		DEALLOCATE changeview_cur

		
	END TRY
	BEGIN CATCH
		exec  @v_logStatus = LogFailed 1,@v_scriptName
		RAISERROR('Block 1 Failed.',16,1)
		RETURN
	END CATCH	
	END
exec @v_logStatus = LogUpdate 1,@v_scriptName

End

~
exec update_searchview 
drop procedure update_searchview 

print 'Script update_searchview, part of Upgrade executed successfully, procedure DROPPED ...... ' 

~
