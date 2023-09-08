/*---------------------------------------------------------------------------------------------------
		NEWGEN SOFTWARE TECHNOLOGIES LIMITED
	Group				: Genesis
	Product / Project	: OmniFlow 9.0
	Module				: Transaction Server
	File Name			: WFGetMailQueueItem.sql
	Author				: Ashutosh Pandey
	Date written		: May 26th 2016
	Description			: This procedure will return the Task Id of the next avilable Mail Item
-----------------------------------------------------------------------------------------------------
				CHANGE HISTORY
-----------------------------------------------------------------------------------------------------
Date			Change By		Change Description (Bug No. (If Any))
-----------------------------------------------------------------------------------------------------
26/05/2016		Ashutosh Pandey	Bug 59010 - Mailing Agent Enhancement : 1) Option to filter mail items 2) Optimization in WFGetMailQueueItem API 3) Purge mechanism for old mail items
23/04/2020      Shubham Singla  Bug 91759 - iBPS 4.0:-MailStatus is not getting updated while fetching the workitem for mail.
----------------------------------------------------------------------------------------------------*/

IF EXISTS (SELECT * FROM SysObjects WHERE xType = 'P' AND name = 'WFGetMailQueueItem')
BEGIN
	EXECUTE('DROP PROCEDURE WFGetMailQueueItem')
	PRINT 'Procedure WFGetMailQueueItem already exists, hence older one dropped ..... '
END

~

CREATE PROCEDURE WFGetMailQueueItem (
	@AgentName NVARCHAR(100),
	@NoOfTrials INT,
	@MailFilter NVARCHAR(100),
	@TaskId BIGINT OUTPUT 
)
AS
SET NOCOUNT ON
BEGIN
	DECLARE @Query NVARCHAR(1000)
	DECLARE @QueryParameter NVARCHAR(256)
	SET @TaskId = 0
	
	SELECT @Query = 'SELECT TOP 1 @TempTaskId = TaskId FROM WFMailQueueTable WITH (UPDLOCK, READPAST) WHERE MailStatus = ''N'' AND NoOfTrials < ' + CAST(@NoOfTrials AS VARCHAR(3)) + @MailFilter + ' ORDER BY TaskId ASC'
	SELECT @QueryParameter = '@TempTaskId BIGINT OUTPUT'
	EXEC sp_executesql @Query, @QueryParameter, @TempTaskId = @TaskId OUTPUT
	
	IF @TaskId <> 0
	BEGIN
		EXECUTE('UPDATE WFMailQueueTable SET MailStatus = ''L'', LockedBy = ''' + @AgentName + ''', LastLockTime = GETDATE() WHERE TaskId = ' + @TaskId)
	END

	IF @TaskId = 0
	BEGIN
		SELECT @Query = 'SELECT TOP 1 @TempTaskId = TaskId FROM WFMailQueueTable WITH (NOLOCK) WHERE MailStatus = ''L'' AND LockedBy = ''' + @AgentName + ''' AND NoOfTrials < ' + CAST(@NoOfTrials AS VARCHAR(3)) + @MailFilter + 'and LastLockTime < DATEADD(ss,-5,GETDATE())  ORDER BY TaskId ASC'
		SELECT @QueryParameter = '@TempTaskId BIGINT OUTPUT'
		EXEC sp_executesql @Query, @QueryParameter, @TempTaskId = @TaskId OUTPUT

		
	END
END

~

Print 'Stored Procedure WFGetMaiLQueueItem compiled successfully ........'