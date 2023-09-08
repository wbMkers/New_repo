/*____________________________________________________________________________________________________
			NEWGEN SOFTWARE TECHNOLOGIES LIMITED
______________________________________________________________________________________________________
	Group				: Genesis
	Product / Project	: OmniFlow 10.1
	Module				: Transaction Server
	File Name			: WFLoadAssignmentPS.sql (Oracle)
	Author				: Mohnish Chopra
	Date written (DD/MM/YYYY)	: 18/02/2014
	Description			: Stored procedure to Distribute Load among PS for Bulk load activities
						  This procedure shall be scheduled on an interval of 15 mins.
						  The recommended value of DBThreshold is 500.
                          This parameter is the count of workitems on an activity, beyond which
                          load on the acitvity will be distributed among running PS.
                          The recommended value of DBTimeOutParameter is 30 mins.
                          If PS does not process an item which is allocated for given time.
                          Workitem is be send back to pool for redistribution.
______________________________________________________________________________________________________
				CHANGE HISTORY
______________________________________________________________________________________________________
 Date		Change By		Change Description (Bug No. (If Any))
13/10/16	Rishi		Bug-64860 - PRDP Bug 59917 - Bulk Ps support 
19/05/2018	Ambuj		PRDP Merging :: Bug 77534 - Optimization in Procedures WFLoadAssignmentPS and WFGetNextWorkitemForPS
03/07/2018	Ambuj		Bug 78208 - NOLOCK is missing in WFSessionView, WFUserView and PSRegisterationTable
____________________________________________________________________________________________________*/
If Exists (Select * from SysObjects Where xType = 'P' and name = 'WFLoadAssignmentPS')
Begin
	Execute('DROP PROCEDURE WFLoadAssignmentPS')
	Print 'Procedure WFLoadAssignmentPS already exists, hence older one dropped ..... '
End

~

CREATE PROCEDURE WFLoadAssignmentPS(
	@DBthreshold INT = 500,
	@DBUseFactor INT = 0,   
	@DBUnUseFactor INT = 1, 
	@DBTimeOutParameter INT = 30,
	@DBActivityID INT = 0,
	@DBProcessDefID INT = 0
)
AS
 
	DECLARE @v_STR1             VARCHAR(8000);
    DECLARE @v_STR2             VARCHAR(8000);
    DECLARE @v_STR3             VARCHAR(8000);
	DECLARE @v_ACT				VARCHAR(1);
	DECLARE @v_ISBULKPS			VARCHAR(1);
    DECLARE @v_ProcessDefId      INT;
    DECLARE @v_ActivityId        INT;
    DECLARE @v_count             INT;
    DECLARE @v_fCount            INT;
    DECLARE @v_PSId              INT;
    DECLARE @v_WICount           INT;
	DECLARE @v_PSName			VARCHAR(100);

BEGIN
	IF  @DBProcessDefID <= 0 
		BEGIN
			RAISERROR ('WFLoadAssignmentPS: Error ProcessDefId cannot be 0', 16, 1)
			RETURN
		END		

	IF @DBActivityID <> 0 
		SELECT @v_ACT = 'Y'
	ELSE
		SELECT @v_ACT = 'N'
		
	IF @DBUseFactor = 0 
		SELECT @v_ISBULKPS = 'Y'
	ELSE
		SELECT @v_ISBULKPS = 'N'
		
	IF @v_ACT = 'Y' 
	BEGIN
		UPDATE WFINSTRUMENTTABLE SET Q_USERId = NULL, LOCKEDTIME = NULL, LOCKSTATUS = N'N', LOCKEDBYNAME = NULL WHERE RoutingStatus = 'Y' and LockStatus = 'Y' AND LockedTime < (getDate() - (@DBTimeOutParameter/ (	24 * 60))) AND ProcessDefId = CAST(@DBProcessDefID AS VARCHAR)  AND ActivityId = CAST(@DBActivityID AS VARCHAR) 
	END
	ELSE
		UPDATE WFINSTRUMENTTABLE SET Q_USERId = NULL, LOCKEDTIME = NULL, LOCKSTATUS = N'N', LOCKEDBYNAME = NULL WHERE  RoutingStatus = 'Y' and LockStatus = 'Y' AND LockedTime < (getDate() - @DBTimeOutParameter/ (24 * 60))
	
	IF @v_ACT = 'Y'
		DECLARE cur_ProcDefId CURSOR FOR
		SELECT ProcessDefId, ActivityId FROM WFINSTRUMENTTABLE WHERE ProcessDefId = @DBProcessDefID AND ActivityId = @DBActivityID AND RoutingStatus = 'Y' AND LockStatus = 'N' GROUP BY processdefid, activityid HAVING count(1) > @DBthreshold
	ELSE
		DECLARE cur_ProcDefId CURSOR FOR
		SELECT ProcessDefId, ActivityId FROM WFINSTRUMENTTABLE WHERE  RoutingStatus = 'Y' AND LockStatus = 'N' GROUP BY processdefid, activityid HAVING count(1) > @DBthreshold 

	OPEN cur_ProcDefId
	
   	FETCH NEXT FROM cur_ProcDefId INTO @v_ProcessDefId,@v_ActivityId
	WHILE (@@Fetch_STATUS = 0)
	BEGIN
	
		IF @v_ISBULKPS = 'Y'
		BEGIN
			SELECT @v_count = count(1) FROM PSRegisterationTable  psreg inner join WFPSConnection PSCon ON psreg.PSID=pscon.psid  WHERE Data = 'PROCESS SERVER' AND ProcessDefId = @v_ProcessDefId 
			and pscon.SessionId is not NULL 
			and UPPER(BulkPS) = 'Y'
		END
		ELSE
			BEGIN
			SELECT @v_count = count(1) FROM PSRegisterationTable psreg WITH(NOLOCK)  inner join WFPSConnection PSCon ON psreg.PSID=pscon.psid  WHERE Data = 'PROCESS SERVER' AND ProcessDefId = @v_ProcessDefId 
			and pscon.SessionId is not NULL 
			SELECT @v_count = @v_count * (@DBUseFactor/ (@DBUseFactor + @DBUnUseFactor))
				
			END	
		
		 SELECT @v_fCount= FLOOR(@v_count)
		
		IF @v_fCount <> 0 
            BEGIN
		IF @v_ISBULKPS = 'Y'
					DECLARE cur_PSId CURSOR FOR
					SELECT TOP (@v_fCount) psreg.psid, psreg.PSName FROM PSRegisterationTable psreg WITH(NOLOCK)  inner join WFPSConnection pscon on psreg.psid=pscon.psid WHERE Data = 'PROCESS SERVER' AND ProcessDefId = @v_ProcessDefId 
					and pscon.SessionId is not NULL 
					and UPPER(BulkPS) = 'Y' order by PSId
				ELSE
					DECLARE cur_PSId CURSOR FOR 
					SELECT TOP (@v_fCount) psreg.psid, psreg.PSName FROM PSRegisterationTable psreg WITH(NOLOCK)  inner join WFPSConnection pscon on psreg.psid=pscon.psid WHERE Data = 'PROCESS SERVER' AND ProcessDefId = @v_ProcessDefId 
					and pscon.SessionId is not NULL 
					order by PSId
				
				
                SELECT @v_WICount = count(1) FROM WFINSTRUMENTTABLE WHERE ProcessDefId = @v_ProcessDefId AND ActivityId = @v_ActivityId AND ROUTINGSTATUS = 'Y' AND LockStatus = 'N'
				SELECT @v_WICount = @v_WICount/ @v_fCount
                SELECT @v_WICount = FLOOR(@v_WICount)
				
                    OPEN cur_PSId 
					FETCH NEXT FROM cur_PSId INTO @v_PSId, @v_PSName
                    WHILE(@@Fetch_STATUS = 0)
                        BEGIN
								
								UPDATE TOP (@v_WICount) WFINSTRUMENTTABLE SET LOCKEDTIME = getDate(), Q_UserId = @v_PSId, LOCKSTATUS = N'Y', LOCKEDBYNAME = @v_PSName WHERE ProcessDefId = @v_ProcessDefId AND ActivityId = @v_ActivityId AND (Q_USERId IS NULL OR Q_USERId=0) AND RoutingStatus ='Y' AND LockStatus = N'N'
								FETCH NEXT FROM cur_PSId INTO @v_PSId, @v_PSName
                        END
	
                    
                    CLOSE cur_PSId
					DEALLOCATE cur_PSId
            END
        FETCH NEXT FROM cur_ProcDefId INTO @v_ProcessDefId,@v_ActivityId
		
	END
	CLOSE cur_ProcDefId
	DEALLOCATE cur_ProcDefId

END

~
