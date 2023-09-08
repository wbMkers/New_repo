/*
Change DATE		Name				Description
--------------------------------------------------------------
26/05/2017		Ashok Kumar		Bug 62518 - Step by Step Debugs in Version Upgrade.
*/

If Exists (Select 1 From SYSObjects Where name = 'CalendarProc' AND xType = 'P')
Begin
	Drop Procedure actionsp
	Print 'As Procedure CalendarProc exists dropping old procedure ........... '
End

Print 'Creating procedure CalendarProc ........... '
 
~

CREATE PROCEDURE CalendarProc 
AS 
BEGIN 
	SET NOCOUNT ON
	DECLARE @v_logStatus  NVARCHAR(10) 
	DECLARE @v_scriptName varchar(100)
	
	SELECT @v_scriptName = 'Upgrade09_SP00_005'
	
		
exec @v_logStatus= LogInsert 1,@v_scriptName,'Inserting values in WFCalendarAssocTable'
	BEGIN
	BEGIN TRY
		exec  @v_logStatus = LogSkip 1,@v_scriptName
		DECLARE @pId			INT

		DECLARE processDefIDCur Cursor FASt_Forward For
			SELECT processDefId FROM ProcessDefTABLE Where processDefId not in 
				(Select processDefId from WFCalendarAssocTable)
		
		OPEN processDefIDCur
		FETCH NEXT FROM processDefIDCur INTO @pId
		WHILE(@@Fetch_Status <> -1)

		BEGIN
			IF (@@Fetch_Status <> -2)
			BEGIN
				Insert into WFCalendarAssocTable values (1, @pId, 0, N'G')
			END
			FETCH NEXT FROM processDefIDCur INTO @pId
		END

		CLOSE processDefIDCur
		DEALLOCATE processDefIDCur
	END TRY
	BEGIN CATCH
		exec  @v_logStatus = LogFailed 1,@v_scriptName
		RAISERROR('Block 1 Failed.',16,1)
		RETURN
	END CATCH	
	END
exec @v_logStatus = LogUpdate 1,@v_scriptName	
END 

~

Print 'Executing procedure CalendarProc........... '
exec CalendarProc 

~

Print 'Dropping procedure CalendarProc........... '
drop procedure CalendarProc 

~