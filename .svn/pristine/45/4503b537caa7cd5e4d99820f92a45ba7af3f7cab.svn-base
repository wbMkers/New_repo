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
END 

~

Print 'Executing procedure CalendarProc........... '
exec CalendarProc 

~

Print 'Dropping procedure CalendarProc........... '
drop procedure CalendarProc 

~