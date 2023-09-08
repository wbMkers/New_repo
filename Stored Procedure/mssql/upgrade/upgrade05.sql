/*________________________________________________________________________________
				NEWGEN SOFTWARE TECHNOLOGIES LIMITED
  ________________________________________________________________________________
		Group					: Phoenix
		Product / Project		: WorkFlow 7.0
		Module					: Transaction Server
		File Name				: upgrade05.sql
		Author					: Shilpi Srivastava
		Date written(DD/MM/YYYY): 01/02/2008
		Description				: Upgrade Script for new features of Multiple Exception and Minute support
  ________________________________________________________________________________
						CHANGE HISTORY
  ________________________________________________________________________________
  Date (DD/MM/YYYY)	Change By	Change Description (Bug No. (If Any))
   27/07/2012		Bhavneet Kaur	Bug 33636- Error while upgrading from OmniFlow6.2
  ________________________________________________________________________________
  ________________________________________________________________________________
  ________________________________________________________________________________*/

/*******************************************Multiple Raise/Clear of Exceptions*********************************************/
If Exists (Select 1 From SYSObjects Where name = 'MultipleExcpProc' AND xType = 'P')
Begin
	Drop Procedure MultipleExcpProc
	Print 'As Procedure  MultipleExcpProc exists dropping old procedure ........... '
End

Print 'Creating procedure MultipleExcpProc ........... '

~

CREATE PROCEDURE MultipleExcpProc 
AS 
BEGIN 
	BEGIN TRANSACTION UpdateExceptionTable
		UPDATE ExceptionTable SET ExcpSeqId = ExcpSeqId - 1 WHERE ActionId = 10
		If( @@Error <> 0 )
			BEGIN
				ROLLBACK TRANSACTION UpdateExceptionTable
			END
	COMMIT TRANSACTION UpdateExceptionTable
END

Print 'ExceptionTale Updated for Multiple Exception Raise and Clear........... '

~
/**********************************************Duration Changes for ProcessTurnAroundTime***********************************************/

If Exists (Select 1 From SYSObjects Where name = 'ProcessTATProc' AND xType = 'P')
Begin
	Drop Procedure ProcessTATProc
	Print 'As Procedure ProcessTATProc exists dropping old procedure ........... '
End

Print 'Creating procedure ProcessTATProc ........... '


~

CREATE PROCEDURE ProcessTATProc 
AS 
BEGIN 
	DECLARE @pId			INT
	DECLARE @processTAT             INT
	DECLARE @durationId             INT
	DECLARE @days                   INT
	DECLARE @hours                  INT
        DECLARE @processCurStatus       INT
	
	DECLARE processDefIDCur Cursor FASt_Forward FOR
		SELECT processDefId , processTurnAroundTime FROM ProcessDefTABLE WHERE processTurnAroundTime IS NOT NULL 

	OPEN processDefIDCur
	FETCH NEXT FROM processDefIDCur INTO @pId , @processTAT
	Select @processCurStatus = @@Fetch_Status
	WHILE(@processCurStatus <> -1)

	BEGIN
		IF (@processCurStatus <> -2)
		BEGIN
			Select @days = @processTAT/24
			Select @hours = @processTAT%24
			BEGIN TRANSACTION Update_And_Insert
				SELECT @durationId = coalesce(max(durationId),0) FROM WFDurationTable Where processDefId = @pId
				If( @@Error <> 0 )
				BEGIN
					ROLLBACK TRANSACTION Update_And_Insert
					Return
				END
				Select @durationId = @durationId + 1
				Update ProcessDefTable set processTurnAroundTime = @durationId where processDefId = @pId
				If( @@Error <> 0 )
				BEGIN
					ROLLBACK TRANSACTION Update_And_Insert
					Return
				END
				Insert into WFDurationTable(ProcessDefId, DurationId, WFYears, WFMonths, WFDays, WFHours, WFMinutes, WFSeconds, 
				VariableId_Years, VarFieldId_Years,
				VariableId_Months, VarFieldId_Months,
				VariableId_Days, VarFieldId_Days,
				VariableId_Hours, VarFieldId_Hours,
				VariableId_Minutes, VarFieldId_Minutes,
				VariableId_Seconds, VarFieldId_Seconds) values (@pId, @durationId, 0, 0, @days, @hours, 0, 0 , 0,0,0,0,0,0,0,0,0,0,0,0)
				If( @@Error <> 0 )
				BEGIN
					ROLLBACK TRANSACTION Update_And_Insert
					Return
				END
			COMMIT TRANSACTION Update_And_Insert
		END
		FETCH NEXT FROM processDefIDCur INTO @pId, @processTAT
		Select @processCurStatus = @@Fetch_Status
	END

	CLOSE processDefIDCur
	DEALLOCATE processDefIDCur

END 

~
/**********************************************Duration Changes for ActivityTurnAroundTime***********************************************/

If Exists (Select 1 From SYSObjects Where name = 'ActivityTATProc' AND xType = 'P')
Begin
	Drop Procedure ActivityTATProc
	Print 'As Procedure ActivityTATProc exists dropping old procedure ........... '
End

Print 'Creating procedure ActivityTATProc ........... '

~

CREATE PROCEDURE ActivityTATProc 
AS 
BEGIN 
	DECLARE @pId			INT
	DECLARE @activityTAT            INT
	DECLARE @durationId             INT
	DECLARE @activityId             INT
	DECLARE @days                   INT
	DECLARE @hours                  INT
        DECLARE @activityCurStatus      INT
	
	DECLARE activityTATCur Cursor FASt_Forward For
		SELECT processDefId , activityId , ActivityTurnAroundTime FROM ActivityTABLE Where ActivityTurnAroundTime is not null

	OPEN activityTATCur
	FETCH NEXT FROM activityTATCur INTO @pId , @activityId ,@activityTAT
	Select @activityCurStatus = @@Fetch_Status
	
	WHILE(@activityCurStatus <> -1)

	BEGIN
		IF (@activityCurStatus <> -2)
		BEGIN
			Select @days = @activityTAT/24
			Select @hours = @activityTAT%24
			BEGIN TRANSACTION Update_And_Insert
				
				SELECT @durationId =  coalesce(max(durationId),0) FROM WFDurationTable Where processDefId = @pId
				If( @@Error <> 0 )
				BEGIN
					ROLLBACK TRANSACTION Update_And_Insert
					Return
				END
				Select @durationId = @durationId + 1
				Update ActivityTable set activityTurnAroundTime = @durationId where processDefId = @pId and activityid = @activityId
				If( @@Error <> 0 )
				BEGIN
					ROLLBACK TRANSACTION Update_And_Insert
					Return
				END
				Insert into WFDurationTable(ProcessDefId, DurationId, WFYears, WFMonths, WFDays, WFHours, WFMinutes, WFSeconds, 
				VariableId_Years, VarFieldId_Years,
				VariableId_Months, VarFieldId_Months,
				VariableId_Days, VarFieldId_Days,
				VariableId_Hours, VarFieldId_Hours,
				VariableId_Minutes, VarFieldId_Minutes,
				VariableId_Seconds, VarFieldId_Seconds) values (@pId, @durationId, 0, 0, @days, @hours, 0, 0 , 0,0,0,0,0,0,0,0,0,0,0,0)
				If( @@Error <> 0 )
				BEGIN
					ROLLBACK TRANSACTION Update_And_Insert
					Return
				END
			
			COMMIT TRANSACTION Update_And_Insert

		END
		FETCH NEXT FROM activityTATCur INTO @pId , @activityId ,@activityTAT
		Select @activityCurStatus = @@Fetch_Status
	
	END

	CLOSE activityTATCur
	DEALLOCATE activityTATCur
	
END 

~

/**********************************************Duration Changes for Activity Expiry***********************************************/

If Exists (Select 1 From SYSObjects Where name = 'ActivityExpiryProc' AND xType = 'P')
Begin
	Drop Procedure ActivityExpiryProc
	Print 'As Procedure ActivityExpiryProc exists dropping old procedure ........... '
End

Print 'Creating procedure ActivityExpiryProc ........... '

~

CREATE PROCEDURE ActivityExpiryProc 
AS 
BEGIN 
	DECLARE @pId			INT
	DECLARE @expiry                 NVARCHAR(200)
	DECLARE @durationId             INT
	DECLARE @activityId             INT
	DECLARE @days                   NVARCHAR(200) 
	DECLARE @hourStr            NVARCHAR(200) 
        DECLARE @hours               INT
	DECLARE @minuteStr            NVARCHAR(200) 
	DECLARE @minutes                INT
	DECLARE @activityCurStatus      INT
	DECLARE @index          INT 
	DECLARE @div               INT 
	DECLARE @flag           INT

	DECLARE activityExpiryCur Cursor FASt_Forward For
		SELECT processDefId , activityId , Expiry FROM ActivityTABLE Where Expiry is not null 

	OPEN activityExpiryCur
	FETCH NEXT FROM activityExpiryCur INTO @pId , @activityId ,@expiry
	Select @activityCurStatus = @@Fetch_Status
	WHILE(@activityCurStatus <> -1)

	BEGIN
		IF (@activityCurStatus <> -2)
		BEGIN
			Select @flag = 0
			Select @expiry = RTRIM(LTRIM(@expiry))
			If(len(@expiry) <= 0 or UPPER(@expiry)  IS NULL)
				BEGIN
					Select @flag = 1
				END
			ELSE
				BEGIN
					If(charindex('*', @expiry) < 0)
					BEGIN
						Select @days = substring( @expiry , 1 , charindex('*', @expiry)-1)
					END
					--Select @days = substring( @expiry , 1 , charindex('*', @expiry)-1)
					Select @hourStr = substring( @expiry , charindex('+', @expiry)+1 , len(@expiry)-charindex('+', @expiry))
					Select @minuteStr = '0'
					Select @hourStr  = RTRIM(LTRIM(@hourStr))
					Select @days = RTRIM(LTRIM(@days))
					if(UPPER(@days) = 'NULL')
						BEGIN
							Select @days = '0'
						END

					if(UPPER(@hourStr) = 'NULL' )
						BEGIN
							Select @hourStr = '0'
						END
					ELSE
						BEGIN
							Select @index = charindex('.', @hourStr)
							if(@index > 0)
								BEGIN
									Select @hours = substring(@hourStr , 1 , @index-1)
									Select @minutes = substring(@hourStr, @index+1 ,2)
									Select @div = @minutes/10
									IF(@div <= 0)
										BEGIN
											Select @minutes = @minutes*10
										END
									Select @minutes = (@minutes*60)/100
									Select @hours = @hours + @minutes/60
									Select  @minutes = @minutes%60 
									Select @minuteStr = RTRIM(LTRIM(str(@minutes)))
									Select  @hourStr = RTRIM(LTRIM(str(@hours)))
								END
						END
					If (@days = '0' and @hourStr = '0' and @minuteStr = '0')
					BEGIN
						Select @flag = 1
					END
				END
			
			BEGIN TRANSACTION Update_And_Insert
			
			If(@flag = 1)
				BEGIN
					Update ActivityTable set Expiry = null ,  neverexpireflag = 'N' , holdtillvariable = null where processDefId = @pId and activityid = @activityId
			
					If( @@Error <> 0 )
						BEGIN
							ROLLBACK TRANSACTION Update_And_Insert
							Return
						END
				END
			ELSE
				BEGIN
					SELECT @durationId = coalesce(max(durationId),0) FROM WFDurationTable Where processDefId = @pId
                        
					If( @@Error <> 0 )
						BEGIN
							ROLLBACK TRANSACTION Update_And_Insert
							Return
						END
					Select @durationId = @durationId + 1
					
					Update ActivityTable set Expiry = RTRIM(LTRIM(str(@durationId))) where processDefId = @pId and activityid = @activityId
					
					If( @@Error <> 0 )
					BEGIN
						ROLLBACK TRANSACTION Update_And_Insert
						Return
					END
					
					Insert into WFDurationTable(ProcessDefId, DurationId, WFYears, WFMonths, WFDays, WFHours, WFMinutes, WFSeconds, 
				VariableId_Years, VarFieldId_Years,
				VariableId_Months, VarFieldId_Months,
				VariableId_Days, VarFieldId_Days,
				VariableId_Hours, VarFieldId_Hours,
				VariableId_Minutes, VarFieldId_Minutes,
				VariableId_Seconds, VarFieldId_Seconds)	values (@pId, @durationId, 0, 0, @days, @hourStr, @minuteStr, 0 , 0,0,0,0,0,0,0,0,0,0,0,0)
					
					If( @@Error <> 0 )
					BEGIN
						ROLLBACK TRANSACTION Update_And_Insert
						Return
					END
					
				END
			COMMIT TRANSACTION Update_And_Insert
			
		END
		FETCH NEXT FROM activityExpiryCur INTO @pId , @activityId ,@expiry
		Select @activityCurStatus = @@Fetch_Status
	
	END

	CLOSE activityExpiryCur
	DEALLOCATE activityExpiryCur
	
	

END 

~
/**********************************************Duration Changes for Escalation***********************************************/
If Exists (Select 1 From SYSObjects Where name = 'EscalationProc' AND xType = 'P')
Begin
	Drop Procedure EscalationProc
	Print 'As Procedure EscalationProc exists dropping old procedure ........... '
End

Print 'Creating procedure EscalationProc ........... '

~

CREATE PROCEDURE EscalationProc 
AS 
BEGIN 
	DECLARE @pId			INT
	DECLARE @param3                 NVARCHAR(200)
	DECLARE @expression             NVARCHAR(200)
	DECLARE @mode                   NVARCHAR(200)
	DECLARE @durationId             INT
	DECLARE @activityId             INT
	DECLARE @days                   NVARCHAR(200)
	DECLARE @hourStr               NVARCHAR(200) 
	DECLARE @hours                  INT
	DECLARE @minutes            INT 
	DECLARE @minuteStr         NVARCHAR(200) 
        DECLARE @activityCurStatus      INT
	DECLARE @param3Val              NVARCHAR(200)
	DECLARE @ruleId			INT
	DECLARE @ruleType               NVARCHAR(64)
	DECLARE @index                 INT  
	DECLARE @div                     INT
	DECLARE @flag                   INT
	
	DECLARE escalationCur Cursor FASt_Forward For
		SELECT processDefId , activityId , Param3 , RuleId , RuleType FROM RuleOperationTable Where  OperationType  = 24 and  Param3 is not null 

	OPEN escalationCur
	FETCH NEXT FROM escalationCur INTO @pId , @activityId ,@param3,  @ruleId, @ruleType
	Select @activityCurStatus = @@Fetch_Status
	WHILE(@activityCurStatus <> -1)
	BEGIN
		IF (@activityCurStatus <> -2)
		BEGIN
			BEGIN TRANSACTION Update_And_Insert
				Select @flag = 0
				Select @param3 = RTRIM(LTRIM(@param3))
				IF(len(@param3) <= 0 or UPPER(@param3) = 'NULL' )
					BEGIN
						Select @flag = 1
					END
				ELSE
					BEGIN
						Select @index = charindex('<Expression>', @param3) 
						If(@index >0)
							BEGIN
						
								Select @expression = substring( @param3, charindex('<Expression>', @param3) + 12 , charindex('</Expression>', @param3) - charindex('<Expression>', @param3) - 12 )
								Select @mode = substring( @param3, charindex('<Mode>', @param3) , len(@param3) - charindex('<Mode>', @param3) + 1 )
								
								Select @expression = RTRIM(LTRIM(@expression))
								
								Select @days = substring( @expression , 1 , charindex('*', @expression) - 1)
								Select @hourStr = substring( @expression , charindex('+', @expression) + 1 , len(@expression)-charindex('+', @expression))
								
								Select @minuteStr = '0'
								Select @hourStr  = RTRIM(LTRIM(@hourStr))
								Select @days = RTRIM(LTRIM(@days))
								
								IF(UPPER(@days) = 'NULL' )
									BEGIN
										Select @days = '0'
									END					
								IF(UPPER(@hourStr) = 'NULL' )
									BEGIN
										Select @hourStr = '0'
									END
								ELSE
									BEGIN
										Select @index = charindex('.', @hourStr)
										if(@index > 0)
											BEGIN
												Select @hours = substring(@hourStr , 1 , @index-1)
												Select @minutes = substring(@hourStr, @index+1 , 2) 
												Select @div = @minutes/10
												IF(@div <= 0)
													BEGIN
														Select @minutes = @minutes*10
													END
												Select @minutes = (@minutes*60)/100
												Select @hours = @hours + @minutes/60
												Select  @minutes = @minutes%60 
												Select @minuteStr = RTRIM(LTRIM(str(@minutes)))
												Select  @hourStr = RTRIM(LTRIM(str(@hours)))
											END
									END
								IF(@days = '0' and @hourStr = '0' and @minuteStr = '0')
									BEGIN
										Select @flag = 1
									END
							END
						ELSE
							BEGIN
								Select @days = @param3
								Select @hourStr = '0'
								Select @minuteStr = '0'
								Select @flag = 2
							END
					END
				
				IF(@flag = 1)
					BEGIN
						Update RuleOperationTable set Param3 = null, Type3 = null 
							where ProcessDefId = @pId  
								and ActivityId = @activityId 
								and RuleId = @ruleId 
							and RuleType = @ruleType
						If( @@Error <> 0  )
							BEGIN
								ROLLBACK TRANSACTION Update_And_Insert
								Return
							END
					END
				ELSE 
					BEGIN
						SELECT @durationId = coalesce(max(durationId),0) FROM WFDurationTable Where processDefId = @pId
						If( @@Error <> 0  )
							BEGIN
								ROLLBACK TRANSACTION Update_And_Insert
								Return
							END
						Select @durationId = @durationId + 1
						IF (@flag = 2)
							BEGIN
								Select @param3Val =  RTRIM(LTRIM(str(@durationId)))
							END
						ELSE
							BEGIN
								Select @param3Val = '<Expression>' + RTRIM (LTRIM(str(@durationId))) + '</Expression>' + @mode
							END
						Select @param3Val = RTRIM(LTRIM(@param3Val))
						
						Update RuleOperationTable set Param3 = @param3Val
							where ProcessDefId = @pId  
								and ActivityId = @activityId 
								and RuleId = @ruleId 
							and RuleType = @ruleType
						If( @@Error <> 0  )
							BEGIN
								ROLLBACK TRANSACTION Update_And_Insert
								Return
							END
						
						Insert into WFDurationTable(ProcessDefId, DurationId, WFYears, WFMonths, WFDays, WFHours, WFMinutes, WFSeconds, 
				VariableId_Years, VarFieldId_Years,
				VariableId_Months, VarFieldId_Months,
				VariableId_Days, VarFieldId_Days,
				VariableId_Hours, VarFieldId_Hours,
				VariableId_Minutes, VarFieldId_Minutes,
				VariableId_Seconds, VarFieldId_Seconds) values (@pId, @durationId, 0, 0, @days, @hourStr, @minuteStr, 0, 0,0,0,0,0,0,0,0,0,0,0,0) 
						
						If( @@Error <> 0 )
							BEGIN
								ROLLBACK TRANSACTION Update_And_Insert
								Return
							END
					END
			COMMIT TRANSACTION Update_And_Insert
			
		END
			FETCH NEXT FROM escalationCur INTO @pId , @activityId ,@param3,  @ruleId, @ruleType
		Select @activityCurStatus = @@Fetch_Status
	
	END

	CLOSE escalationCur
	DEALLOCATE escalationCur
	
	

END 

~
/**********************************************Executing above made all stored procedures ***********************************************/

If Exists (Select 1 From SYSObjects Where name = 'AllUpgrade' AND xType = 'P')
Begin
	Drop Procedure AllUpgrade
	Print 'As Procedure AllUpgrade exists dropping old procedure ........... '
End

Print 'Creating procedure AllUpgrade ........... '

~

CREATE PROCEDURE AllUpgrade 
AS 
BEGIN 
	DECLARE @v_msgCount			INTEGER
	DECLARE @v_cabVersionId		INTEGER
	DECLARE @v_msgStr			NVARCHAR(128)

	If Not Exists (Select 1 from WFCabVersionTable where Remarks = 'UPGRADE FOR MULTIPLE EXCEPTION AND TIMESTAMP')
	Begin
		/* If WFMessageTable contains unprocessed message, Upgrade must be halted - Varun Bhansaly */
		SELECT @v_msgCount = COUNT(*) FROM WFMessageTable
		IF(@v_msgCount > 0)
		BEGIN
			SELECT @v_cabVersionId = @@IDENTITY
			UPDATE WFCabVersionTable SET Remarks = Remarks + N' - Upgrade Halted! WFMessageTable contains ' + CONVERT(NVARCHAR(10), @v_msgCount) + N' unprocessed messages. To process these messages run Message Agent. Thereafter, Upgrade once again.' WHERE cabVersionId =  @v_cabVersionId
			SELECT @v_msgStr = 'Upgrade Halted! WFMessageTable contains ' + CONVERT(NVARCHAR(10), @v_msgCount) + ' unprocessed messages. To process these messages run Message Agent. Thereafter, run Upgrade once again.'
			RAISERROR(@v_msgStr, 16, 1) 
		END

		BEGIN TRANSACTION AllUpgradeTrans
		
		exec MultipleExcpProc
		If( @@Error <> 0 )
		BEGIN
			ROLLBACK TRANSACTION AllUpgradeTrans
			Return
		END
		
		exec ProcessTATProc
		If( @@Error <> 0 )
		BEGIN
			ROLLBACK TRANSACTION AllUpgradeTrans
			Return
		END
		
		
		exec ActivityTATProc 
		If( @@Error <> 0 )
		BEGIN
			ROLLBACK TRANSACTION AllUpgradeTrans
			Return
		END
		
		
		exec ActivityExpiryProc 
		If( @@Error <> 0  )
		BEGIN
			ROLLBACK TRANSACTION AllUpgradeTrans
			Return
		END
		
		
		exec EscalationProc
		If( @@Error <> 0 )
		BEGIN
			ROLLBACK TRANSACTION AllUpgradeTrans
			Return
		END
		
		Insert into WFCabVersionTable values ('MULTIPLE_EXCEPTION_AND_MINUTE_SUPPORT', getDate(), getDate(),'UPGRADE FOR MULTIPLE EXCEPTION AND TIMESTAMP','Y')
		If( @@Error <> 0 )
		BEGIN
			ROLLBACK TRANSACTION AllUpgradeTrans
			Return
		END

		COMMIT TRANSACTION AllUpgradeTrans

	End
	
END 

~

/************************************************************Execute Allupgrade************************************/

exec AllUpgrade 

~
If Exists (Select 1 From SYSObjects Where name = 'AllUpgrade' AND xType = 'P')
Begin
	Drop Procedure AllUpgrade
	Print ' dropped procedure AllUpgrade  ........... '
End

~

If Exists (Select 1 From SYSObjects Where name = 'MultipleExcpProc' AND xType = 'P')
Begin
	Drop Procedure MultipleExcpProc
	Print '  dropped procedure MultipleExcpProc  ........... '
End

~

If Exists (Select 1 From SYSObjects Where name = 'ProcessTATProc' AND xType = 'P')
Begin
	Drop Procedure ProcessTATProc
	Print ' dropped procedure ProcessTATProc  ........... '
End

~

If Exists (Select 1 From SYSObjects Where name = 'ActivityTATProc' AND xType = 'P')
Begin
	Drop Procedure ActivityTATProc
	Print ' dropped procedure ActivityTATProc  ........... '
End

~

If Exists (Select 1 From SYSObjects Where name = 'ActivityExpiryProc' AND xType = 'P')
Begin
	Drop Procedure ActivityExpiryProc
	Print ' dropped procedure  ActivityExpiryProc  ........... '
End

~

If Exists (Select 1 From SYSObjects Where name = 'EscalationProc' AND xType = 'P')
Begin
	Drop Procedure EscalationProc
	Print ' dropped procedure EscalationProc  ........... '
End

~
