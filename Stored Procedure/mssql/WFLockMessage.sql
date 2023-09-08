/*____________________________________________________________________________________________________
			NEWGEN SOFTWARE TECHNOLOGIES LIMITED
______________________________________________________________________________________________________
	Group				: Phoenix
	Product / Project		: OmniFlow 7.2
	Module				: Transaction Server
	File Name			: WFLockMessage.sql (MSSQL)
	Author				: Ashish Mangla
	Date written (DD/MM/YYYY)	: 11/07/2008
	Description			: Stored procedure to lock message
					  (invoked from WFInternal.java).
______________________________________________________________________________________________________
				CHANGE HISTORY
______________________________________________________________________________________________________
 Date		Change By		Change Description (Bug No. (If Any))
 28/01/2014		Shweta Singhal	UPDLock replaced with UPDLock, READPAST
 03-05-2014		Sajid Khan		Bug 44499 - INT to BIGINT changes for Audit Tables.
 12/08/2020		Ashutosh Pandey	Bug 94054 - Optimization in Message Agent
____________________________________________________________________________________________________*/

If Exists (Select * from SysObjects Where xType = 'P' and name = 'WFLockMessage')
Begin
	Execute('DROP PROCEDURE WFLockMessage')
	Print 'Procedure WFLockMessage already exists, hence older one dropped ..... '
End

~

CREATE  PROCEDURE WFLockMessage(
	@UtilId			NVARCHAR(65)
)     
AS     
SET NOCOUNT ON     
BEGIN  
	DECLARE @messId_temp 		 BIGINT
	DECLARE @ActionDateTime_temp DATETIME
	DECLARE @message_temp		 NVARCHAR(4000)
	DECLARE @dbQuery			 NVARCHAR(1000)
	DECLARE @params				 NVARCHAR(1000)

	SET @dbQuery = 'SELECT TOP 1 @messId_temp = messageId, @ActionDateTime_temp = ActionDateTime, @message_temp = message FROM WFMessageTable WITH(NOLOCK)'
	SET @params = '@messId_temp BIGINT OUTPUT, @ActionDateTime_temp DATETIME OUTPUT, @message_temp NVARCHAR(4000) OUTPUT'
	EXECUTE SP_EXECUTESQL @dbQuery, @params, @messId_temp = @messId_temp OUTPUT, @ActionDateTime_temp = @ActionDateTime_temp OUTPUT, @message_temp = @message_temp OUTPUT

	IF(@@ROWCOUNT <= 0)
	BEGIN
		SELECT 0, getDate(), 'NO_MORE_DATA'
		RETURN
	END
	IF @@Error <> 0
	BEGIN
		SELECT -2, getDate(), '<Message>Select from WFMessageTable Failed</Message>'
		RETURN
	END

	Select @messId_temp, @ActionDateTime_temp, @message_temp

END
		
~

Print 'Stored Procedure WFLockMessage compiled successfully ........'