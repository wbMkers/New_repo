/*____________________________________________________________________________________________ 
			NEWGEN SOFTWARE TECHNOLOGIES LIMITED 
______________________________________________________________________________________________ 
	Group				: Application � Products 
	Product / Project		: WorkFlow 6.2 
	Module				: WorkFlow Server 
	File Name			: WFSearchMove.sql [SQL Server] 
	Author				: Vikram Kumbhar
	Date written (DD/MM/YYYY)	: 28/05/2008 
	Description			: Stored procedure for Optimized Search to move records 
					  from all tables that satisfying specified condition  
					  into WFTempSearchTable which is a global temporary 
					  table. (WFS_6.2_023)
______________________________________________________________________________________________ 
				CHANGE HISTORY 
______________________________________________________________________________________________ 
Date			Change By		Change Description (Bug No. (If Any)) 
08/10/2009		Nishant Singh		Adavance search giving error after clicking next and previous batch. final string size become more than declared size variable in this SP.
23/11/2015		Mohnish Chopra	Changes for Bug 57633 - view is not proper while opening any workitem from quick search result.
								Sending ActivityType in SearchWorkItemList API so that Case view can be opened for ActivityType 32.
09-05-2017	Sajid Khan			Queue Varaible Extension Enahncement
28/12/2017    Kumar Kimil     Bug 74287-EAP6.4+SQL: Search on URN is not working proper
28/12/2017    Kumar Kimil     Bug 72882-WBL+Oracle: Incorrect workitem count is showing in quick search result.
______________________________________________________________________________________________ 
____________________________________________________________________________________________*/ 

If Exists (Select * from SysObjects Where xType = 'P' and name = 'WFSearchMove') 
Begin 
	Execute('DROP PROCEDURE WFSearchMove') 
	Print 'Procedure WFSearchMove already exists, hence older one dropped ..... ' 
End 

~ 

CREATE PROCEDURE WFSearchMove(
	@DBQueryStr			ntext
)
AS     
BEGIN
	DECLARE @DBStatus		INT
	DECLARE @ProcessInstanceId	NVARCHAR (63)
	DECLARE @URN	NVARCHAR (63)
	DECLARE @CALENDARNAME NVARCHAR (63)
	DECLARE @ProcessdefId		INT
	DECLARE @ProcessName		NVARCHAR(30)
	DECLARE @ActivityId		INT
	DECLARE @ActivityName		NVARCHAR(30)
	DECLARE @PriorityLevel		SMALLINT
	DECLARE @InstrumentStatus	NVARCHAR(1)
	DECLARE @LockStatus		NVARCHAR(1)
	DECLARE @LockedByName		NVARCHAR(63)
	DECLARE @ValidTill		DATETIME
	DECLARE @CreatedByName		NVARCHAR(63)
	DECLARE @CreatedDateTime	DATETIME
	DECLARE @StateName		NVARCHAR(255)
	DECLARE @CheckListCompleteFlag	NVARCHAR(1)
	DECLARE @EntryDateTime		DATETIME
	DECLARE @LockedTime		DATETIME
	DECLARE @IntroductionDateTime	DATETIME
	DECLARE @IntroducedBy		NVARCHAR(63)
	DECLARE @AssignedUser		NVARCHAR(63)
	DECLARE @WorkitemId		INT
	DECLARE @QueueName		NVARCHAR(63)
	DECLARE @AssignmentType		NVARCHAR(1)
	DECLARE @ProcessInstanceState	INT
	DECLARE @QueueType		NVARCHAR(1)
	DECLARE @Status			NVARCHAR(255)
	DECLARE @Q_QueueId		INT
	DECLARE @TurnAroundTime		INT
	DECLARE @ReferredBy		INT
	DECLARE @ReferredTo		INT
	DECLARE @Q_UserId		INT
	DECLARE @ParentWorkitemId	INT
	DECLARE @ProcessedBy		NVARCHAR(63)
	DECLARE @ProcessVersion		SMALLINT
	DECLARE @WorkItemState		INT
	DECLARE @ExpectedProcessDelay	DATETIME
	DECLARE @ExpectedWorkItemDelay	DATETIME

	DECLARE @VAR_INT1		SMALLINT
	DECLARE @VAR_INT2		SMALLINT
	DECLARE @VAR_INT3		SMALLINT
	DECLARE @VAR_INT4		SMALLINT
	DECLARE @VAR_INT5		SMALLINT
	DECLARE @VAR_INT6		SMALLINT
	DECLARE @VAR_INT7		SMALLINT
	DECLARE @VAR_INT8		SMALLINT
	DECLARE @VAR_FLOAT1		NUMERIC(15, 2)
	DECLARE @VAR_FLOAT2		NUMERIC(15, 2)
	DECLARE @VAR_DATE1		DATETIME
	DECLARE @VAR_DATE2		DATETIME
	DECLARE @VAR_DATE3		DATETIME
	DECLARE @VAR_DATE4		DATETIME
	DECLARE @VAR_DATE5		DATETIME
	DECLARE @VAR_DATE6		DATETIME
	DECLARE @VAR_LONG1		INT
	DECLARE @VAR_LONG2		INT
	DECLARE @VAR_LONG3		INT
	DECLARE @VAR_LONG4		INT
	DECLARE @VAR_LONG5		INT
	DECLARE @VAR_LONG6		INT
	DECLARE @VAR_STR1		NVARCHAR(255)
	DECLARE @VAR_STR2		NVARCHAR(255)
	DECLARE @VAR_STR3		NVARCHAR(255)
	DECLARE @VAR_STR4		NVARCHAR(255)
	DECLARE @VAR_STR5		NVARCHAR(255)
	DECLARE @VAR_STR6		NVARCHAR(255)
	DECLARE @VAR_STR7		NVARCHAR(255)
	DECLARE @VAR_STR8		NVARCHAR(255)
	DECLARE @VAR_STR9		NVARCHAR(255)
	DECLARE @VAR_STR10		NVARCHAR(255)
	DECLARE @VAR_STR11		NVARCHAR(255)
	DECLARE @VAR_STR12		NVARCHAR(255)
	DECLARE @VAR_STR13		NVARCHAR(255)
	DECLARE @VAR_STR14		NVARCHAR(255)
	DECLARE @VAR_STR15		NVARCHAR(255)
	DECLARE @VAR_STR16		NVARCHAR(255)
	DECLARE @VAR_STR17		NVARCHAR(255)
	DECLARE @VAR_STR18		NVARCHAR(255)
	DECLARE @VAR_STR19		NVARCHAR(255)
	DECLARE @VAR_STR20		NVARCHAR(255)
	DECLARE @VAR_REC1		NVARCHAR(255)
	DECLARE @VAR_REC2		NVARCHAR(255)
	DECLARE @VAR_REC3		NVARCHAR(255)
	DECLARE @VAR_REC4		NVARCHAR(255)
	DECLARE @VAR_REC5		NVARCHAR(255)
	DECLARE @ActivityType		INT

	EXECUTE ('DECLARE CursorSearchTable CURSOR FAST_FORWARD FOR ' + @DBQueryStr)

	OPEN	CursorSearchTable 

	FETCH	CursorSearchTable 
	INTO	@PROCESSINSTANCEID, @QUEUENAME, @PROCESSNAME, @PROCESSVERSION,  
		@ACTIVITYNAME, @STATENAME, @CHECKLISTCOMPLETEFLAG, @ASSIGNEDUSER, 
		@ENTRYDATETIME, @VALIDTILL, @WORKITEMID, @PRIORITYLEVEL, 
		@PARENTWORKITEMID, @PROCESSDEFID, @ACTIVITYID, @INSTRUMENTSTATUS, 
		@LOCKSTATUS, @LOCKEDBYNAME, @CREATEDBYNAME, @CREATEDDATETIME, 
		@LOCKEDTIME, @INTRODUCTIONDATETIME, @INTRODUCEDBY, @ASSIGNMENTTYPE, 
		@PROCESSINSTANCESTATE, @QUEUETYPE, @STATUS, @Q_QUEUEID, @TURNAROUNDTIME,
		@REFERREDBY, @REFERREDTO, @ExpectedProcessDelay, @ExpectedWorkitemDelay,
		@PROCESSEDBY, @Q_USERID, @WORKITEMSTATE, @ActivityType,@URN, @CALENDARNAME, @VAR_INT1, @VAR_INT2, @VAR_INT3,
		@VAR_INT4, @VAR_INT5, @VAR_INT6, @VAR_INT7, @VAR_INT8, @VAR_FLOAT1,
		@VAR_FLOAT2, @VAR_DATE1, @VAR_DATE2, @VAR_DATE3, @VAR_DATE4,@VAR_DATE5, @VAR_DATE6, @VAR_LONG1,
		@VAR_LONG2, @VAR_LONG3, @VAR_LONG4,@VAR_LONG5, @VAR_LONG6, @VAR_STR1, @VAR_STR2, @VAR_STR3,
		@VAR_STR4, @VAR_STR5, @VAR_STR6, @VAR_STR7, @VAR_STR8,@VAR_STR9, @VAR_STR10, @VAR_STR11,@VAR_STR12, @VAR_STR13, @VAR_STR14, @VAR_STR15, @VAR_STR16, @VAR_STR17, @VAR_STR18, @VAR_STR19, @VAR_STR20, @VAR_REC1, 
		@VAR_REC2, @VAR_REC3, @VAR_REC4, @VAR_REC5

	IF (@@Fetch_Status = -1 OR  @@Fetch_Status = -2) 
	BEGIN 
		CLOSE CursorSearchTable 
		DEALLOCATE CursorSearchTable 
		RETURN 
	END 

	WHILE(@@FETCH_STATUS <> -1) 
	BEGIN 
		IF(@@FETCH_STATUS <> -2) 
		BEGIN
			INSERT INTO #TempSearchTable 
			VALUES (@PROCESSINSTANCEID, @QUEUENAME, @PROCESSNAME, @PROCESSVERSION, 
				@ACTIVITYNAME, @STATENAME, @CHECKLISTCOMPLETEFLAG, @ASSIGNEDUSER, 
				@ENTRYDATETIME, @VALIDTILL, @WORKITEMID, @PRIORITYLEVEL, 
				@PARENTWORKITEMID, @PROCESSDEFID, @ACTIVITYID, @INSTRUMENTSTATUS, 
				@LOCKSTATUS, @LOCKEDBYNAME, @CREATEDBYNAME, @CREATEDDATETIME, 
				@LOCKEDTIME, @INTRODUCTIONDATETIME, @INTRODUCEDBY, @ASSIGNMENTTYPE, 
				@PROCESSINSTANCESTATE, @QUEUETYPE, @STATUS, @Q_QUEUEID, 
				@TURNAROUNDTIME, @REFERREDBY, @REFERREDTO, @ExpectedProcessDelay, 
				@ExpectedWorkitemDelay, @PROCESSEDBY, @Q_USERID, @WORKITEMSTATE,
				@ActivityType,@URN, @CALENDARNAME, @VAR_INT1, @VAR_INT2, @VAR_INT3, @VAR_INT4, @VAR_INT5, @VAR_INT6,
				@VAR_INT7, @VAR_INT8, @VAR_FLOAT1, @VAR_FLOAT2, @VAR_DATE1,
				@VAR_DATE2 ,@VAR_DATE3, @VAR_DATE4,@VAR_DATE5, @VAR_DATE6, @VAR_LONG1, @VAR_LONG2,
				@VAR_LONG3, @VAR_LONG4,@VAR_LONG5, @VAR_LONG6, @VAR_STR1, @VAR_STR2, @VAR_STR3, @VAR_STR4,
				@VAR_STR5, @VAR_STR6, @VAR_STR7, @VAR_STR8,@VAR_STR9, @VAR_STR10, @VAR_STR11,@VAR_STR12, @VAR_STR13, @VAR_STR14, @VAR_STR15, @VAR_STR16, @VAR_STR17, @VAR_STR18, @VAR_STR19, @VAR_STR20, @VAR_REC1, @VAR_REC2,
				@VAR_REC3, @VAR_REC4, @VAR_REC5)
			IF (@@ERROR <> 0 OR @@ROWCOUNT = 0)
			BEGIN
				SELECT @DBStatus = 1
			END
		END

		FETCH	CursorSearchTable 
		INTO	@PROCESSINSTANCEID, @QUEUENAME, @PROCESSNAME, @PROCESSVERSION,  
			@ACTIVITYNAME, @STATENAME, @CHECKLISTCOMPLETEFLAG, @ASSIGNEDUSER, 
			@ENTRYDATETIME, @VALIDTILL, @WORKITEMID, @PRIORITYLEVEL, 
			@PARENTWORKITEMID, @PROCESSDEFID, @ACTIVITYID, @INSTRUMENTSTATUS, 
			@LOCKSTATUS, @LOCKEDBYNAME, @CREATEDBYNAME, @CREATEDDATETIME, 
			@LOCKEDTIME, @INTRODUCTIONDATETIME, @INTRODUCEDBY, @ASSIGNMENTTYPE, 
			@PROCESSINSTANCESTATE, @QUEUETYPE, @STATUS, @Q_QUEUEID, @TURNAROUNDTIME,
			@REFERREDBY, @REFERREDTO, @ExpectedProcessDelay, @ExpectedWorkitemDelay,
			@PROCESSEDBY, @Q_USERID, @WORKITEMSTATE,@ActivityType,@URN, @CALENDARNAME, @VAR_INT1, @VAR_INT2, @VAR_INT3,
			@VAR_INT4, @VAR_INT5, @VAR_INT6, @VAR_INT7, @VAR_INT8, @VAR_FLOAT1,
			@VAR_FLOAT2, @VAR_DATE1, @VAR_DATE2, @VAR_DATE3, @VAR_DATE4,@VAR_DATE5, @VAR_DATE6, @VAR_LONG1,
			@VAR_LONG2, @VAR_LONG3, @VAR_LONG4,@VAR_LONG5, @VAR_LONG6, @VAR_STR1, @VAR_STR2, @VAR_STR3,
			@VAR_STR4, @VAR_STR5, @VAR_STR6, @VAR_STR7, @VAR_STR8,@VAR_STR9, @VAR_STR10, @VAR_STR11,@VAR_STR12, @VAR_STR13, @VAR_STR14, @VAR_STR15, @VAR_STR16, @VAR_STR17, @VAR_STR18, @VAR_STR19, @VAR_STR20, @VAR_REC1, 
			@VAR_REC2, @VAR_REC3, @VAR_REC4, @VAR_REC5
		IF @@ERROR <> 0 
		BEGIN 
			CLOSE CursorSearchTable 
			DEALLOCATE CursorSearchTable 
			RETURN 
		END 
	END 
	CLOSE CursorSearchTable 
	DEALLOCATE CursorSearchTable
END

~ 

Print 'Stored Procedure WFSearchMove compiled successfully ........'