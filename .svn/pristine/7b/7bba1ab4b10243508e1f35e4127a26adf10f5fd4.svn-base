/*----------------------------------------------------------------------------------------------------
		NEWGEN SOFTWARE TECHNOLOGIES LIMITED
------------------------------------------------------------------------------------------------------
	Group				: Application –Products
	Product / Project		: iBPS 4.0
	Module				: Transaction Server
	File Name			: WFStreamDataUpdate.sql
	Author				: Ravi Ranjan Kumar
	Date written (DD/MM/YYYY)	: 01/04/2020
	Description			: To insert missing stream data in streamdeftable
------------------------------------------------------------------------------------------------------
			CHANGE HISTORY
------------------------------------------------------------------------------------------------------
 Date		Change By		Change Description (Bug No. (If Any))
----------------------------------------------------------------------------------------------------*/

If Exists (Select * FROM SysObjects (NOLOCK) Where xType = 'P' and name = 'WFStreamDataUpdate')
Begin
	Execute('DROP PROCEDURE WFStreamDataUpdate')
	Print 'Procedure WFStreamDataUpdate already exists, hence older one dropped ..... '
End

~
Create Procedure WFStreamDataUpdate(
@DBProcessDefID			Integer
) AS
BEGIN
	DECLARE @ProcessDefId		INT
	Declare @existsFlag			INT
	Declare @StreamId 			INT
	Declare @ActivityId 		INT
	Declare @StreamName  		NVARCHAR(50)
	Declare @v_QueryStr 		NVARCHAR(2000)
	
	select @v_QueryStr='Select processdefid,ActivityId from ACTIVITYTABLE where ActivityType not in (2,3,7,5,6,18,20) and ProcessDefId='+CONVERT(NVarchar(10), @DBProcessDefID)+' order by processdefid,ActivityId'
	
	EXECUTE ('DECLARE cur_streamActUpdate CURSOR Fast_Forward FOR ' + @v_QueryStr) 

	OPEN cur_streamActUpdate
	FETCH NEXT FROM cur_streamActUpdate INTO @ProcessDefId,@ActivityId

	WHILE @@FETCH_STATUS = 0 
	BEGIN
        Select @existsFlag = count(*) from STREAMDEFTABLE where processdefid = @ProcessDefId and ActivityId=@ActivityId 
		If (@existsFlag = 0)
		Begin
				insert into STREAMDEFTABLE (ProcessDefId,StreamId,ActivityId,StreamName,SortType,SortOn,StreamCondition) values(@ProcessDefId,1,@ActivityId,'Default','A','PriorityLevel','ALWAYS')
	
		End
		FETCH NEXT FROM cur_streamActUpdate INTO @ProcessDefId,@ActivityId
	END
	CLOSE cur_streamActUpdate   
	DEALLOCATE cur_streamActUpdate 
	
	
	select @v_QueryStr='Select processdefid,ActivityId,StreamId,StreamName from STREAMDEFTABLE WHERE ProcessDefId='+CONVERT(NVarchar(10), @DBProcessDefID)+' order by processdefid,ActivityId,StreamId'
	
	EXECUTE ('DECLARE cur_streamIDUpdate CURSOR Fast_Forward FOR ' + @v_QueryStr) 
	
	OPEN cur_streamIDUpdate
	FETCH NEXT FROM cur_streamIDUpdate INTO @ProcessDefId,@ActivityId,@StreamId,@StreamName

	WHILE @@FETCH_STATUS = 0 
	BEGIN
        Select @existsFlag = count(*) from ruleconditiontable where processdefid = @ProcessDefId and ActivityId=@ActivityId and RuleType='S' 
		If (@existsFlag = 0 and @StreamName='Default')
		Begin
				insert into RuleConditionTable (ProcessDefId,ActivityId,RuleType,RuleOrderId,RuleId,ConditionOrderId,Param1,Type1,ExtObjID1,VariableId_1,VarFieldId_1,Param2,Type2,ExtObjID2,VariableId_2,VarFieldId_2,Operator,LogicalOp) values(@ProcessDefId,@ActivityId,'S',1,@StreamId,1,'ALWAYS','S',0,0,0,'ALWAYS','S',0,0,0,4,4)
	
		End
		FETCH NEXT FROM cur_streamIDUpdate INTO @ProcessDefId,@ActivityId,@StreamId,@StreamName
	END
	CLOSE cur_streamIDUpdate   
	DEALLOCATE cur_streamIDUpdate 
	
END