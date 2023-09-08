/*____________________________________________________________________________________________________
			NEWGEN SOFTWARE TECHNOLOGIES LIMITED
______________________________________________________________________________________________________
	Group						: Genesis
	Product / Project			: OmniFlow 10.1
	Module						: Transaction Server
	File Name					: WFLoadAssignmentPS.sql (Oracle)
	Author						: Mohnish Chopra
	Date written (DD/MM/YYYY)	: 04/04/2014
	Description					: Stored procedure to Expire workitems candidates for expiry
______________________________________________________________________________________________________
				CHANGE HISTORY
______________________________________________________________________________________________________
 Date		Change By		Change Description (Bug No. (If Any))
22/06/2017	Sajid Khan		Bug 70211 - AssociatedFieldName is coming blank for ActionId = 28[Workitem Expired] 
____________________________________________________________________________________________________*/
If Exists (Select * from SysObjects Where xType = 'P' and name = 'WFExpireWorkItems')
Begin
	Execute('DROP PROCEDURE WFExpireWorkItems')
	Print 'Procedure WFExpireWorkItems already exists, hence older one dropped ..... '
End

~

Create Procedure WFExpireWorkItems
AS     
SET NOCOUNT ON  
DECLARE		@v_rowCount		INT   
DECLARE @v_DivertedUserIndex INT 
DECLARE @v_procInstId NVARCHAR(63)
BEGIN

	BEGIN
		DECLARE ESC_CURSOR CURSOR FAST_FORWARD FOR 
		SELECT ProcessInstanceID FROM WFINSTRUMENTTABLE WHERE  ValidTill < GETDATE()
		OPEN ESC_CURSOR
		FETCH NEXT FROM ESC_CURSOR INTO @v_procInstId
		WHILE(@@FETCH_STATUS = 0)
		BEGIN 
			DELETE FROM WFEscalationTable WHERE ProcessInstanceId =@v_procInstId
			/*DELETE FROM WFEscInProcessTable WHERE ProcessInstanceId =@v_procInstId*/
			FETCH NEXT FROM ESC_CURSOR INTO @v_procInstId
		END 
		CLOSE ESC_CURSOR
		DEALLOCATE ESC_CURSOR
	END 

	BEGIN
	

	Update WFINSTRUMENTTABLE  WITH (UPDLOCK,READPAST) set AssignmentType = 'X', WorkItemState = 6,Q_queueid=0, Statename = 'COMPLETED' , LockStatus = 'N',
             		RoutingStatus = 'Y' , ValidTill = null, Q_UserId = null, AssignedUser = null, FilterValue = null, LockedByName = null, LockedTime = null, NotifyStatus	= null , Q_DivertedByUserId = 0,Q_StreamId = Null ,QueueName = NULL,QueueType = NULL Output INSERTED.processinstanceid ,INSERTED.workitemid,INSERTED.processdefid,INSERTED.activityid,INSERTED.ACTIVITYNAME,INSERTED.Q_UserId,28,getDate(),0 into WFCURRENTROUTELOGTABLE(PROCESSINSTANCEID,WORKITEMID,PROCESSDEFID,ACTIVITYID,ACTIVITYNAME,USERID,ACTIONID,ACTIONDATETIME,ASSOCIATEDFIELDID) 	where ValidTill<getDate() 
	
	SELECT @@ROWCOUNT			
	END
	--Going to Delete entries from UserDiversionTable in case Diversion Period is reached.
	print 'Going to Delete entries from UserDiversionTable in case Diversion Period reached '
	BEGIN
		DECLARE EXPIRY_CURSOR CURSOR FAST_FORWARD FOR
		SELECT DivertedUserIndex FROM UserDiversionTable WHERE ToDate < GETDATE()
	    OPEN EXPIRY_CURSOR
	    FETCH NEXT FROM EXPIRY_CURSOR INTO @v_DivertedUserIndex
		WHILE(@@FETCH_STATUS = 0)
		BEGIN
			DELETE FROM UserDiversionTable WHERE DivertedUserIndex = @v_DivertedUserIndex
			FETCH NEXT FROM EXPIRY_CURSOR INTO @v_DivertedUserIndex
		END
	    CLOSE EXPIRY_CURSOR
	    DEALLOCATE EXPIRY_CURSOR
	END
	RETURN 
END		
~

