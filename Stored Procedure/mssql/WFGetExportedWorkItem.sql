/*----------------------------------------------------------------------------------------------------
		NEWGEN SOFTWARE TECHNOLOGIES LIMITED
------------------------------------------------------------------------------------------------------
	Group				: Application –Products
	Product / Project	: Omniflow 9.0
	Module				: Transaction Server
	File Name			: WFGetExportedWorkitem.sql
	Author				: Neeraj Sharma
	Date written (DD/MM/YYYY)	: 01/11/2013
	Description			: To Check the Rights on Query WorkStep and return mainCode.
------------------------------------------------------------------------------------------------------
			CHANGE HISTORY
------------------------------------------------------------------------------------------------------*/

If Exists (Select * FROM SysObjects (NOLOCK) Where xType = 'P' and name = 'WFGetExportedWorkitem')
Begin
	Execute('DROP PROCEDURE WFGetExportedWorkitem')
	Print 'Procedure WFGetExportedWorkitem already exists, hence older one dropped ..... '
End

~

CREATE PROCEDURE WFGetExportedWorkitem(
	@DBSessionId			Integer,
	@DBProcessInstanceId		NVarchar(64),
	@DBWorkItemId			Integer,
	@DBQueueId			Integer,
	@DBQueueType			NVarchar(1),		/* '' -> Search; 'F' -> FIFO; 'D', 'S', 'N' -> WIP */
	@DBLastProcessInstanceId	NVarchar(64),
	@processDefId		Integer,
	@DBGenerateLog			NVarchar(1),
	@DBOrderBy			Integer, /*Bug #815*/
	@DBSortOrder			NVarchar(64),
	@DBLastValue			NVarchar(1000),
	@DBAssignMe			NVarchar(1)	,
	@DBClientOrderFlag	NVarchar(1)
	
)
AS
Begin

	Declare @rowCount		INT
	Declare @userIndex		INT
	Declare	@status			NVARCHAR(1)
	Declare @userName		NVARCHAR(30)
	Declare @QueryActivityId        INT
	Declare @v_QueryPreview		NVARCHAR(1)
	Declare @MainCode       INT
	Declare @ActivityId 		INT
	Declare @lockFlag		NVARCHAR(1)	

BEGIN
	Select @mainCode=0;
	Select	@userIndex	= userIndex,
		@userName	= userName,
		@status = statusFlag
	FROM	WFSessionView, WFUserView 
	WHERE	UserId		= UserIndex 
	AND	SessionID	= @DBSessionId 

	Select	@rowCount	= @@rowCount

	IF(@rowCount <= 0)
	Begin
		SELECT	@MainCode	= 11		/* Invalid Session Handle */
		Select	@MainCode	MainCode,
			@lockFlag	lockFlag
		RETURN
	End

	
	IF(@status = 'N')
	BEGIN
		Update WFSessionView set statusflag = 'Y' , AccessDateTime = GETDATE()
          WHERE SessionID = @DBSessionId
	END
	
	IF(@DBQueueId >= 0)
		Begin
			Select	@MainCode = 810 /* Workitem not in the queue specified. */
			Select	@MainCode	MainCode,
				@lockFlag	lockFlag
			Return
		End
		/* ActivityType 11 is for query workstep */
		/*WFS_8.0_031,WFS_8.0_121*/
		

			Select Top 1 @QueryActivityId = ActivityTable.ActivityId,
			@v_QueryPreview = QUSERGROUPVIEW.QueryPreview
			FROM ActivityTable, QueueStreamTable , QUSERGROUPVIEW
			WHERE ActivityTable.ProcessDefId = QueueStreamTable.ProcessDefId
			AND ActivityTable.ActivityId = QueueStreamTable.ActivityId
			AND QUSERGROUPVIEW.QueueId = QueueStreamTable.QueueId
			AND ActivityTable.ActivityType = 11
			AND ActivityTable.ProcessDefId = @ProcessDefID
			AND QUSERGROUPVIEW.UserId = @userIndex
			ORDER BY QUSERGROUPVIEW.UserId DESC
		Select @rowCount = @@rowCount
		If(@rowCount <= 0)
			Begin
				Select Top 1 @QueryActivityId = ActivityTable.ActivityId,
				@v_QueryPreview = QUSERGROUPVIEW.QueryPreview
				FROM ActivityTable, QueueStreamTable , QUSERGROUPVIEW
				WHERE ActivityTable.ProcessDefId = QueueStreamTable.ProcessDefId
				AND ActivityTable.ActivityId = QueueStreamTable.ActivityId
				AND QUSERGROUPVIEW.QueueId = QueueStreamTable.QueueId
				AND ActivityTable.ActivityType = 11
				AND ActivityTable.ProcessDefId = @ProcessDefID
				AND QUSERGROUPVIEW.UserId = @userIndex
				AND QUSERGROUPVIEW.groupid IS NOT NULL
				ORDER BY QUSERGROUPVIEW.UserId DESC
			Select @rowCount = @@rowCount
			If(@rowCount <= 0)	
			
				Begin
					Select @MainCode = 300 /*No Authorization*/
					Select @MainCode	MainCode,
						   @lockFlag	LockFlag
					Return
				End
				Else
				Begin
					/*WFS_8.0_031*/
					Select @MainCode = 16
					IF(@v_QueryPreview = 'Y' OR @v_QueryPreview IS NULL)
					BEGIN
						Select @ActivityId = @QueryActivityId
					END
				End
			END
			ELSE
			BEGIN
			
				Select @MainCode = 16 /*To be shown in Read only mode*/
				IF(@v_QueryPreview = 'Y' OR @v_QueryPreview IS NULL)
				BEGIN
					Select @ActivityId = @QueryActivityId
				END
			END	
END
				Select	@MainCode	MainCode, 
					@lockFlag	LockFlag,
					@userIndex  UserIndex
END
