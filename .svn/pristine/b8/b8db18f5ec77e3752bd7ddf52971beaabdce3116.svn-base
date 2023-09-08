/*____________________________________________________________________________________________________
			NEWGEN SOFTWARE TECHNOLOGIES LIMITED
______________________________________________________________________________________________________
	Group				: Genesis
	Product / Project	: iBPS 
	Module				: Transaction Server
	File Name			: WFFetchCaseList.sql (SQL)
	Author				: Mohnish Chopra
	Date written (DD/MM/YYYY)	: 29/10/2015
	Description			: Stored procedure to fetch my Cases.
						  My cases for User A will include :
							    1. Cases that are owned by Case Manager A 
   								2. Cases in which task are assigned to Case Worker A or Case Participant A
______________________________________________________________________________________________________
				CHANGE HISTORY
______________________________________________________________________________________________________
 Date		Change By		Change Description (Bug No. (If Any))
06/11/2015	Mohnish Chopra		Changes for Case management -Can Initiate requirement 
30/11/2015	Mohnish Chopra		Bug 57931 - Jboss EAP : Error message while changing priority of WI
								Sending LastModifiedTime in WFFetchCaseWorkItems
/02/12/2015	Mohnish Chopra		Bug 58014 - show case visualization check box during assigning a task is not working according to specification
09-05-2017	Sajid Khan			Queue Varaible Extension Enahncement
17/05/2017 Kumar Kimil          Length of Query Exceeding the max limit of NVARCHAR after Queue Variable Extension hence changed
14/09/2017	Mohnish Chopra		Changes for Searching ,sorting and filtering in FetchCaseList
24/10/2017	AMbuj Tripathi		Case registration changes for Adding URN in the output of WFFetchCaseWorkItems API
15/02/2018	Ambuj Tripathi		Bug#Bug 76025 - Arabic:-Batching not working if batch size is 3.
22/04/2018  Ambuj Tripathi		Bug 76862 - Remove the db console messages from all procedures
____________________________________________________________________________________________________*/

If Exists (Select * from SysObjects Where xType = 'P' and name = 'WFFetchCaseList')
BEGIN
	EXECUTE('DROP PROCEDURE WFFetchCaseList')
	PRINT 'PROCEDURE WFFetchCaseList ALREADY EXISTS HENCE OLDER ONE DROPPED'
END

~

CREATE PROCEDURE WFFetchCaseList
(  
		@DBsessionId			INT,  
		@DBsortOrder			NVARCHAR(1) ,  
		@DBorderBy				INT , 
		@DBbatchSize			INT , 
		@DBlastWorkItem			INT , 
		@DBlastProcessInstance	NVARCHAR(63) , 
		@DBlastValue			NVARCHAR(2000) , 
		@DBCaseManagerFlag		NVARCHAR(1) ,
		@DBSearchFilter			NVARCHAR(2000),
		@DBreturnParam          INT /* 0 -> only list, if 1 -> only count, if 2 -> both count and list*/
) 
AS 

Set NoCount On
	 
DECLARE		@v_DBStatus			INT 
DECLARE		@v_rowCount			INT 	
DECLARE		@v_queryStr1			VARCHAR(8000) 
DECLARE     @v_queryStr2            NVARCHAR(4000)
DECLARE		@groupByClause			VARCHAR(8000) 
DECLARE     @v_queryForCaseWorker	VARCHAR(8000)

DECLARE		@v_CountStr			VARCHAR(8000) 
DECLARE		@v_CountStr1			VARCHAR(8000) 
DECLARE		@v_UserId			INT 
DECLARE		@v_UserName			NVARCHAR(63) 


DECLARE		@v_innerOrderBy			NVARChar(200) 
DECLARE		@v_orderByPos			INT 
DECLARE		@v_tempFilter			NVARCHAR(2000) 
DECLARE		@v_counter			INT 
DECLARE		@v_counter1			INT 
DECLARE		@v_noOfCounters			INT /* Bugzilla Bug 1703 */
DECLARE		@v_counterCondition		INT 
DECLARE		@v_OrderByStr			NVARChar(2000) 
DECLARE		@v_sortStr			NVARCHAR(6) 
DECLARE		@v_op				CHAR(1) 
DECLARE		@v_sortFieldStr			NVARCHAR(50) 
DECLARE		@v_quoteChar 			CHAR(1) 
DECLARE		@v_TempColumnVal		NVARCHAR(64) 
DECLARE		@v_lastValueStr			NVARCHAR(1000) 
DECLARE 	@DBmainCode			INT 
DECLARE 	@DBsubCode				INT 
DECLARE		@v_returnCount                  INT
DECLARE		@v_TempCount			INT
DECLARE		@v_reverseOrder			INT 
DECLARE		@v_prefix			NVARCHAR(50) 


BEGIN 
	SELECT @DBmainCode = 0 
	SELECT @DBsubCode = 0 
	SELECT @v_returnCount = 0
	SELECT @v_quoteChar = CHAR(39)  
	
	/* Check for session validity ... */  
	BEGIN 
		SELECT @v_UserId = UserID, @v_UserName = UserName  
		FROM WFSessionView, WFUserView 
		WHERE UserId = UserIndex AND SessionID = @DBsessionId 

		SELECT @v_rowcount = @@ROWCOUNT  
		SELECT @v_DBStatus = @@ERROR 
	END 


	IF (@v_DBStatus <> 0 OR @v_rowcount <= 0) 
	BEGIN 
		SELECT @DBmainCode = 11     /* Invalid Session */
		SELECT @DBsubCode = 0 
		SELECT MainCode = @DBmainCode, SubCode = @DBsubCode, ReturnCount = @v_returnCount/*Bugzilla Id 1680*/
		RETURN 
	END
	
		IF(@DBsortOrder = 'D') 
	BEGIN 
		SELECT @v_reverseOrder = 1  
		SELECT @v_sortStr = ' DESC '  
		SELECT @v_op = '<'  
	END 
	Else /* IF(@DBsortOrder = 'A') */  
	BEGIN 
		SELECT @v_reverseOrder = 0  
		SELECT @v_sortStr = ' ASC '  
		SELECT @v_op = '>'  
	END   
	
	IF (@v_innerOrderBy is NULL)  
	BEGIN 
		IF(@DBorderBy = 1)  
		BEGIN  
			IF(LEN(@DBlastValue) > 0)  
			BEGIN 
				SELECT @v_lastValueStr = @v_quoteChar + @DBlastValue + @v_quoteChar   
			END  
			SELECT @v_sortFieldStr = ' PriorityLevel '  
		END  
		ElSE IF(@DBorderBy = 2)  
		BEGIN  
			IF(LEN(@DBlastValue) > 0)  
			BEGIN 
				SELECT @v_lastValueStr = @v_quoteChar + @DBlastValue + @v_quoteChar  
			END  
			SELECT @v_sortFieldStr = ' ProcessInstanceId ' 
		END  
		ElSE IF(@DBorderBy = 3)  
		BEGIN  
			IF(LEN(@DBlastValue) > 0)  
			BEGIN 
				SELECT @v_lastValueStr = @v_quoteChar + @DBlastValue + @v_quoteChar 
			END  
			SELECT @v_sortFieldStr = ' ActivityName ' 
		END 
		ElSE IF(@DBorderBy = 4)  
		BEGIN 
			IF(LEN(@DBlastValue) > 0) 
			BEGIN 
				SELECT @v_lastValueStr = @v_quoteChar + @DBlastValue + @v_quoteChar  
			END  
			SELECT @v_sortFieldStr = ' LockedByName ' 
		END 
		ElSE IF(@DBorderBy = 5) 
		BEGIN 
			IF(LEN(@DBlastValue) > 0) 
			BEGIN 
				SELECT @v_lastValueStr = @v_quoteChar + @DBlastValue + @v_quoteChar  
			END  
			SELECT @v_sortFieldStr = ' IntroducedBy ' 
		END 
		ElSE IF(@DBorderBy = 6)  
		BEGIN 
			IF(LEN(@DBlastValue) > 0) 
			BEGIN 
				SELECT @v_lastValueStr = @v_quoteChar + @DBlastValue + @v_quoteChar 
			END 	 
			SELECT @v_sortFieldStr = ' InstrumentStatus ' 
		END 
		ElSE IF(@DBorderBy = 7)  
		BEGIN 
			IF(LEN(@DBlastValue) > 0) 
			BEGIN 
				SELECT @v_lastValueStr = @v_quoteChar + @DBlastValue + @v_quoteChar 
			END  
			SELECT @v_sortFieldStr = ' CheckListCompleteFlag '  
		END 
		ElSE IF(@DBorderBy = 8)  
		BEGIN 
			IF(LEN(@DBlastValue) > 0) 
			BEGIN 
				SELECT @v_lastValueStr = @v_quoteChar + @DBlastValue + @v_quoteChar  
			END  
			SELECT @v_sortFieldStr = ' LockStatus ' 
		END 
		ElSE IF(@DBorderBy = 9)  
		BEGIN 
			IF(LEN(@DBlastValue) > 0) 
			BEGIN 
				SELECT @v_lastValueStr = @DBlastValue 
			END  
			SELECT @v_sortFieldStr = ' WorkItemState ' 
		END 
		ElSE IF(@DBorderBy = 10) 
		BEGIN 
			IF(LEN(@DBlastValue) > 0) 
			BEGIN 
				SELECT @v_lastValueStr = @v_quoteChar + @DBlastValue + @v_quoteChar  
			END  
			SELECT @v_sortFieldStr = ' EntryDateTime ' 
		END 
		ElSE IF(@DBorderBy = 11)  
		BEGIN 
			IF(LEN(@DBlastValue) > 0) 
			BEGIN 
				SELECT @v_lastValueStr = @v_quoteChar + @DBlastValue + @v_quoteChar  
			END  
			SELECT @v_sortFieldStr = ' ValidTill ' 
		END 
		ElSE IF(@DBorderBy = 12)  
		BEGIN 
			IF(LEN(@DBlastValue) > 0) 
			BEGIN 
				SELECT @v_lastValueStr = @v_quoteChar + @DBlastValue + @v_quoteChar  
			END 
			SELECT @v_sortFieldStr = ' LockedTime ' 
		END 
		ElSE IF(@DBorderBy = 13)  
		BEGIN 
			IF(LEN(@DBlastValue) > 0)  
			BEGIN 
				SELECT @v_lastValueStr = @v_quoteChar + @DBlastValue + @v_quoteChar  
			END 	 
			SELECT @v_sortFieldStr = ' IntroductionDateTime ' 
		END 		
		ElSE IF(@DBorderBy = 16) 
		BEGIN 
			IF(LEN(@DBlastValue) > 0) 
			BEGIN 
				SELECT @v_lastValueStr = @v_quoteChar + @DBlastValue + @v_quoteChar  
			END  
			SELECT @v_sortFieldStr = ' AssignedUser ' 
		END 		
		ElSE IF(@DBorderBy = 17)  
		BEGIN 
			IF(LEN(@DBlastValue) > 0) 
			BEGIN 
				SELECT @v_lastValueStr = @v_quoteChar + @DBlastValue + @v_quoteChar  
			END  
			SELECT @v_sortFieldStr = ' Status ' 
		END 
		ElSE IF(@DBorderBy = 18) 
		BEGIN 
			IF(LEN(@DBlastValue) > 0)  
			BEGIN 
				SELECT @v_lastValueStr = @v_quoteChar + @DBlastValue + @v_quoteChar  
			END  
			SELECT @v_sortFieldStr = ' CreatedDateTime ' 
		END 
		ElSE IF(@DBorderBy = 19) 
		BEGIN 
			IF(LEN(@DBlastValue) > 0)  
			BEGIN 
				SELECT @v_lastValueStr = @v_quoteChar + @DBlastValue + @v_quoteChar  
			END  
			SELECT @v_sortFieldStr = ' ExpectedWorkItemDelay ' 
		END 		/* Sorting On Alias */
		ElSE IF(@DBorderBy = 20) 
		BEGIN 
			IF(LEN(@DBlastValue) > 0)  
			BEGIN 
				SELECT @v_lastValueStr = @v_quoteChar + @DBlastValue + @v_quoteChar  
			END  
			SELECT @v_sortFieldStr = ' ProcessedBy ' 
		END 		
	
		IF(@DBlastProcessInstance IS NOT NULL)  
		BEGIN 		
			SELECT @v_TempColumnVal = @v_lastValueStr 

			IF(@DBlastValue IS NOT NULL) 
			BEGIN 
				SELECT @v_lastValueStr = ' AND ( ( ' + @v_sortFieldStr + @v_op + @v_TempColumnVal + ') '   
				SELECT @v_lastValueStr = @v_lastValueStr + ' OR ( ' + @v_sortFieldStr + ' = ' + @v_TempColumnVal 
			END 
			ELSE 
			BEGIN 
				SELECT @v_lastValueStr = ' AND  ( ( ' + @v_sortFieldStr + ' IS NULL '  
			END  

			SELECT @v_lastValueStr = @v_lastValueStr + ' AND (  ' 
			SELECT @v_lastValueStr = @v_lastValueStr + ' ( Processinstanceid = N' + @v_quoteChar + @DBlastProcessInstance + @v_quoteChar + ' AND  WorkItemId ' + @v_op + CONVERT(NVarchar(10), (@DBlastWorkItem)) + ' )' 
			SELECT @v_lastValueStr = @v_lastValueStr + ' OR Processinstanceid' + @v_op +'N'+ @v_quoteChar + @DBlastProcessInstance + @v_quoteChar  
			SELECT @v_lastValueStr = @v_lastValueStr + ' ) '  
			
			IF(@DBlastValue IS NOT NULL) 
			BEGIN 
				IF (@DBsortOrder = N'A') 
				BEGIN 
					SELECT @v_lastValueStr = @v_lastValueStr + ') '  
				END 
				ELSE  
				BEGIN 
					SELECT @v_lastValueStr = @v_lastValueStr + ') OR (' + @v_sortFieldStr +  ' IS NULL )'  
				END 
				SELECT @v_lastValueStr = @v_lastValueStr + ') ' 
			END 
			ELSE  
			BEGIN 
				IF (@DBsortOrder = N'D') 
				BEGIN 
					SELECT @v_lastValueStr = @v_lastValueStr + ') '  
				END 
				ELSE 
				BEGIN 
					SELECT @v_lastValueStr = @v_lastValueStr + ') OR (' + @v_sortFieldStr +  ' IS NOT NULL )'  
				END  
				SELECT @v_lastValueStr = @v_lastValueStr + ') ' 
			END 
		END 
		
		
		IF (@DBorderBy = 2) 
		BEGIN 
			SELECT @v_orderByStr = ' ORDER BY ProcessInstanceID ' + @v_sortStr + ', WorkItemID ' + @v_sortStr 
		END 
		ELSE  
		BEGIN 
			SELECT @v_orderByStr = ' ORDER BY ' + @v_sortFieldStr + @v_sortStr + ', ProcessInstanceID ' + @v_sortStr + ', WorkItemID ' + @v_sortStr 
		END  
	END /* End Case Inner_Order_By IS NULL*/ 
	
		SELECT @v_prefix = ' TOP  ' + CONVERT(NVarchar(10), @DBbatchSize + 1)

	Select @groupByClause = 'group by ProcessInstanceId, ProcessInstanceId, ProcessDefId, ProcessName, ActivityId, ActivityName, PriorityLevel, InstrumentStatus, LockStatus, LockedByName, ValidTill, CreatedByName, CreatedDateTime, Statename, CheckListCompleteFlag, EntryDateTime, LockedTime, IntroductionDateTime, IntroducedBy, AssignedUser, WorkItemId, QueueName, AssignmentType, ProcessInstanceState, QueueType, Status, Q_QueueID, ReferredByname, ReferredTo, Q_UserID, FILTERVALUE, Q_StreamId, CollectFlag, ParentWorkItemId, ProcessedBy, LastProcessedBy, ProcessVersion, WORKITEMSTATE, PREVIOUSSTAGE, ExpectedWorkItemDelay, ProcessVariantId, Q_DivertedByUserId,ActivityType, VAR_INT1, VAR_INT2, VAR_INT3, VAR_INT4, VAR_INT5, VAR_INT6, VAR_INT7, VAR_INT8, VAR_FLOAT1, VAR_FLOAT2, VAR_DATE1, VAR_DATE2, VAR_DATE3, VAR_DATE4,VAR_DATE5, VAR_DATE6, VAR_LONG1, VAR_LONG2, VAR_LONG3, VAR_LONG4,VAR_LONG5, VAR_LONG6, VAR_STR1, VAR_STR2, VAR_STR3, VAR_STR4, VAR_STR5, VAR_STR6, VAR_STR7, VAR_STR8,VAR_STR9, VAR_STR10, VAR_STR11, VAR_STR12, VAR_STR13, VAR_STR14, VAR_STR15, VAR_STR16, VAR_STR17, VAR_STR18, VAR_STR19, VAR_STR20, VAR_REC_1, VAR_REC_2,LastModifiedTime,URN ';
	
	--Select @v_queryStr1 = @v_queryStr1 + @groupByClause +@v_orderByStr;
	
	SELECT @v_noOfCounters = 1 /* Bugzilla Bug 1703 */
--print @v_orderByStr
--print @groupByClause
--	print @v_queryStr1
--	print @v_CountStr1
	
	/*Bugzilla Id 1680*/
	IF(@DBCaseManagerFlag='A')
	BEGIN
	--print 'All workitems'
	SELECT @v_queryStr1 = ' SELECT ' + ISNULL(@v_prefix,'') +' ProcessInstanceId, ProcessInstanceId as ProcessInstanceName, ProcessDefId, ProcessName, ActivityId, ActivityName, PriorityLevel, InstrumentStatus, LockStatus, LockedByName, ValidTill, CreatedByName, CreatedDateTime, Statename, CheckListCompleteFlag, EntryDateTime, LockedTime, IntroductionDateTime, IntroducedBy, AssignedUser, WorkItemId, QueueName, AssignmentType, ProcessInstanceState, QueueType, Status, Q_QueueID, ReferredByname, ReferredTo, Q_UserID, FILTERVALUE, Q_StreamId, CollectFlag, ParentWorkItemId, ProcessedBy, LastProcessedBy, ProcessVersion, WORKITEMSTATE, PREVIOUSSTAGE, ExpectedWorkItemDelay, ProcessVariantId, Q_DivertedByUserId,ActivityType, VAR_INT1, VAR_INT2, VAR_INT3, VAR_INT4, VAR_INT5, VAR_INT6, VAR_INT7, VAR_INT8, VAR_FLOAT1, VAR_FLOAT2, VAR_DATE1, VAR_DATE2, VAR_DATE3, VAR_DATE4, VAR_DATE5, VAR_DATE6,VAR_LONG1, VAR_LONG2, VAR_LONG3, VAR_LONG4,VAR_LONG5, VAR_LONG6, VAR_STR1, VAR_STR2, VAR_STR3, VAR_STR4, VAR_STR5, VAR_STR6, VAR_STR7, VAR_STR8, VAR_STR9, VAR_STR10, VAR_STR11, VAR_STR12, VAR_STR13, VAR_STR14, VAR_STR15, VAR_STR16, VAR_STR17, VAR_STR18, VAR_STR19, VAR_STR20, VAR_REC_1, VAR_REC_2,LastModifiedTime,URN,
	 max(CanInitiate) AS CanInitiate,max(CaseManager) AS CaseManager ,max(ShowCaseVisual) as ShowCaseVisual 
	 from (SELECT  a.ProcessInstanceId, a.ProcessInstanceId as ProcessInstanceName, a.ProcessDefId, a.ProcessName, a.ActivityId, a.ActivityName, a.PriorityLevel, a.InstrumentStatus, a.LockStatus, a.LockedByName, a.ValidTill, a.CreatedByName, a.CreatedDateTime, a.Statename, a.CheckListCompleteFlag, a.EntryDateTime, a.LockedTime, a.IntroductionDateTime, a.IntroducedBy, a.AssignedUser, a.WorkItemId, a.QueueName, a.AssignmentType, a.ProcessInstanceState, a.QueueType, a.Status, a.Q_QueueID, a.ReferredByname, a.ReferredTo, a.Q_UserID, a.FILTERVALUE, a.Q_StreamId, a.CollectFlag, a.ParentWorkItemId, a.ProcessedBy, a.LastProcessedBy, a.ProcessVersion, a.WORKITEMSTATE, a.PREVIOUSSTAGE, a.ExpectedWorkItemDelay, a.ProcessVariantId, a.Q_DivertedByUserId,ActivityType, a.VAR_INT1, a.VAR_INT2, a.VAR_INT3, a.VAR_INT4, a.VAR_INT5, a.VAR_INT6, a.VAR_INT7, a.VAR_INT8, a.VAR_FLOAT1, a.VAR_FLOAT2, a.VAR_DATE1, a.VAR_DATE2, a.VAR_DATE3, a.VAR_DATE4, a.VAR_DATE5, a.VAR_DATE6, a.VAR_LONG1, a.VAR_LONG2, a.VAR_LONG3, a.VAR_LONG4, a.VAR_LONG5, a.VAR_LONG6, a.VAR_STR1, a.VAR_STR2, a.VAR_STR3, a.VAR_STR4, a.VAR_STR5, a.VAR_STR6, a.VAR_STR7, a.VAR_STR8,  a.VAR_STR9, a.VAR_STR10, a.VAR_STR11, a.VAR_STR12, a.VAR_STR13, a.VAR_STR14, a.VAR_STR15, a.VAR_STR16, a.VAR_STR17, a.VAR_STR18, a.VAR_STR19, a.VAR_STR20,a.VAR_REC_1, a.VAR_REC_2,a.LastModifiedTime,a.URN,''Y'' as CanInitiate,''Y'' as CaseManager,''Y'' as ShowCaseVisual FROM  WFInstrumentTable a  WITH (NOLOCK) WHERE 1 = 1 AND (Q_UserID = '+ CONVERT(NVarchar(10),@v_UserId)+ ' or Q_DivertedByUserId = '+ CONVERT(NVarchar(10),@v_UserId)+ ') and ActivityType =32 '

	Select @v_queryStr2=' union SELECT  a.ProcessInstanceId, a.ProcessInstanceId as ProcessInstanceName, a.ProcessDefId, a.ProcessName, a.ActivityId, a.ActivityName, a.PriorityLevel, a.InstrumentStatus, a.LockStatus, a.LockedByName, a.ValidTill, a.CreatedByName, a.CreatedDateTime, a.Statename, a.CheckListCompleteFlag, a.EntryDateTime, a.LockedTime, a.IntroductionDateTime, a.IntroducedBy, a.AssignedUser, a.WorkItemId, a.QueueName, a.AssignmentType, a.ProcessInstanceState, a.QueueType, a.Status, a.Q_QueueID, a.ReferredByname, a.ReferredTo, a.Q_UserID, a.FILTERVALUE, a.Q_StreamId, a.CollectFlag, a.ParentWorkItemId, a.ProcessedBy, a.LastProcessedBy, a.ProcessVersion, a.WORKITEMSTATE, a.PREVIOUSSTAGE, a.ExpectedWorkItemDelay, a.ProcessVariantId, a.Q_DivertedByUserId,ActivityType, a.VAR_INT1, a.VAR_INT2, a.VAR_INT3, a.VAR_INT4, a.VAR_INT5, a.VAR_INT6, a.VAR_INT7, a.VAR_INT8, a.VAR_FLOAT1, a.VAR_FLOAT2, a.VAR_DATE1, a.VAR_DATE2, a.VAR_DATE3, a.VAR_DATE4,a.VAR_DATE5, a.VAR_DATE6, a.VAR_LONG1, a.VAR_LONG2, a.VAR_LONG3, a.VAR_LONG4, a.VAR_LONG5, a.VAR_LONG6, a.VAR_STR1, a.VAR_STR2, a.VAR_STR3, a.VAR_STR4, a.VAR_STR5, a.VAR_STR6, a.VAR_STR7, a.VAR_STR8, a.VAR_STR9, a.VAR_STR10, a.VAR_STR11, a.VAR_STR12, a.VAR_STR13, a.VAR_STR14, a.VAR_STR15, a.VAR_STR16, a.VAR_STR17, a.VAR_STR18, a.VAR_STR19, a.VAR_STR20, a.VAR_REC_1, a.VAR_REC_2,a.LastModifiedTime,a.URN,b.CanInitiate,''N'' as CaseManager,b.ShowCaseVisual FROM  WFInstrumentTable a  WITH (NOLOCK) inner join WFTaskStatusTable b  WITH (NOLOCK) on a.processinstanceid = b.processinstanceid and a.workitemid = b.workitemid where b.assignedTo = '+@v_quoteChar +@v_UserName +@v_quoteChar + ' and b.taskstatus =2 and ActivityType =32 ) a where 1=1 '+ ISNULL(@DBSearchFilter,'')
	+ ISNULL(@v_lastValueStr,'');
	
	END
	ELSE IF(@DBCaseManagerFlag='Y')
	BEGIN
	--print 'Case manager workitems'

	SELECT @v_queryStr1 = ' SELECT ' + ISNULL(@v_prefix,'') +' ProcessInstanceId, ProcessInstanceId as ProcessInstanceName, ProcessDefId, ProcessName, ActivityId, ActivityName, PriorityLevel, InstrumentStatus, LockStatus, LockedByName, ValidTill, CreatedByName, CreatedDateTime, Statename, CheckListCompleteFlag, EntryDateTime, LockedTime, IntroductionDateTime, IntroducedBy, AssignedUser, WorkItemId, QueueName, AssignmentType, ProcessInstanceState, QueueType, Status, Q_QueueID, ReferredByname, ReferredTo, Q_UserID, FILTERVALUE, Q_StreamId, CollectFlag, ParentWorkItemId, ProcessedBy, LastProcessedBy, ProcessVersion, WORKITEMSTATE, PREVIOUSSTAGE, ExpectedWorkItemDelay, ProcessVariantId, Q_DivertedByUserId,ActivityType, VAR_INT1, VAR_INT2, VAR_INT3, VAR_INT4, VAR_INT5, VAR_INT6, VAR_INT7, VAR_INT8, VAR_FLOAT1, VAR_FLOAT2, VAR_DATE1, VAR_DATE2, VAR_DATE3, VAR_DATE4, VAR_DATE5, VAR_DATE6,VAR_LONG1, VAR_LONG2, VAR_LONG3, VAR_LONG4,VAR_LONG5, VAR_LONG6, VAR_STR1, VAR_STR2, VAR_STR3, VAR_STR4, VAR_STR5, VAR_STR6, VAR_STR7, VAR_STR8, VAR_STR9, VAR_STR10, VAR_STR11, VAR_STR12, VAR_STR13, VAR_STR14, VAR_STR15, VAR_STR16, VAR_STR17, VAR_STR18, VAR_STR19, VAR_STR20, VAR_REC_1, VAR_REC_2,LastModifiedTime,URN,
	 max(CanInitiate) AS CanInitiate,max(CaseManager) AS CaseManager ,max(ShowCaseVisual) as ShowCaseVisual 
	 from (SELECT  a.ProcessInstanceId, a.ProcessInstanceId as ProcessInstanceName, a.ProcessDefId, a.ProcessName, a.ActivityId, a.ActivityName, a.PriorityLevel, a.InstrumentStatus, a.LockStatus, a.LockedByName, a.ValidTill, a.CreatedByName, a.CreatedDateTime, a.Statename, a.CheckListCompleteFlag, a.EntryDateTime, a.LockedTime, a.IntroductionDateTime, a.IntroducedBy, a.AssignedUser, a.WorkItemId, a.QueueName, a.AssignmentType, a.ProcessInstanceState, a.QueueType, a.Status, a.Q_QueueID, a.ReferredByname, a.ReferredTo, a.Q_UserID, a.FILTERVALUE, a.Q_StreamId, a.CollectFlag, a.ParentWorkItemId, a.ProcessedBy, a.LastProcessedBy, a.ProcessVersion, a.WORKITEMSTATE, a.PREVIOUSSTAGE, a.ExpectedWorkItemDelay, a.ProcessVariantId, a.Q_DivertedByUserId,ActivityType, a.VAR_INT1, a.VAR_INT2, a.VAR_INT3, a.VAR_INT4, a.VAR_INT5, a.VAR_INT6, a.VAR_INT7, a.VAR_INT8, a.VAR_FLOAT1, a.VAR_FLOAT2, a.VAR_DATE1, a.VAR_DATE2, a.VAR_DATE3, a.VAR_DATE4, a.VAR_DATE5, a.VAR_DATE6, a.VAR_LONG1, a.VAR_LONG2, a.VAR_LONG3, a.VAR_LONG4, a.VAR_LONG5, a.VAR_LONG6, a.VAR_STR1, a.VAR_STR2, a.VAR_STR3, a.VAR_STR4, a.VAR_STR5, a.VAR_STR6, a.VAR_STR7, a.VAR_STR8,  a.VAR_STR9, a.VAR_STR10, a.VAR_STR11, a.VAR_STR12, a.VAR_STR13, a.VAR_STR14, a.VAR_STR15, a.VAR_STR16, a.VAR_STR17, a.VAR_STR18, a.VAR_STR19, a.VAR_STR20,a.VAR_REC_1, a.VAR_REC_2,a.LastModifiedTime,a.URN,''Y'' as CanInitiate,''Y'' as CaseManager,''Y'' as ShowCaseVisual FROM  WFInstrumentTable a  WITH (NOLOCK) WHERE 1 = 1 AND (Q_UserID = '+ CONVERT(NVarchar(10),@v_UserId)+ ' or Q_DivertedByUserId = '+ CONVERT(NVarchar(10),@v_UserId)+ ') and ActivityType = 32 '

	Select @v_queryStr2 = ISNULL(@DBSearchFilter,'')
	+ ISNULL(@v_lastValueStr,'')+ @groupByClause +@v_orderByStr + ' ) b'
	END
	ELSE IF(@DBCaseManagerFlag='N')
	BEGIN
	SELECT @v_queryStr1 = ' SELECT ' + ISNULL(@v_prefix,'') +' ProcessInstanceId, ProcessInstanceId as ProcessInstanceName, ProcessDefId, ProcessName, ActivityId, ActivityName, PriorityLevel, InstrumentStatus, LockStatus, LockedByName, ValidTill, CreatedByName, CreatedDateTime, Statename, CheckListCompleteFlag, EntryDateTime, LockedTime, IntroductionDateTime, IntroducedBy, AssignedUser, WorkItemId, QueueName, AssignmentType, ProcessInstanceState, QueueType, Status, Q_QueueID, ReferredByname, ReferredTo, Q_UserID, FILTERVALUE, Q_StreamId, CollectFlag, ParentWorkItemId, ProcessedBy, LastProcessedBy, ProcessVersion, WORKITEMSTATE, PREVIOUSSTAGE, ExpectedWorkItemDelay, ProcessVariantId, Q_DivertedByUserId,ActivityType, VAR_INT1, VAR_INT2, VAR_INT3, VAR_INT4, VAR_INT5, VAR_INT6, VAR_INT7, VAR_INT8, VAR_FLOAT1, VAR_FLOAT2, VAR_DATE1, VAR_DATE2, VAR_DATE3, VAR_DATE4, VAR_DATE5, VAR_DATE6,VAR_LONG1, VAR_LONG2, VAR_LONG3, VAR_LONG4,VAR_LONG5, VAR_LONG6, VAR_STR1, VAR_STR2, VAR_STR3, VAR_STR4, VAR_STR5, VAR_STR6, VAR_STR7, VAR_STR8, VAR_STR9, VAR_STR10, VAR_STR11, VAR_STR12, VAR_STR13, VAR_STR14, VAR_STR15, VAR_STR16, VAR_STR17, VAR_STR18, VAR_STR19, VAR_STR20, VAR_REC_1, VAR_REC_2,LastModifiedTime,URN,
	 max(CanInitiate) AS CanInitiate,max(CaseManager) AS CaseManager ,max(ShowCaseVisual) as ShowCaseVisual 
	 from ('
		Select @v_queryForCaseWorker = 'SELECT  a.ProcessInstanceId, a.ProcessInstanceId as ProcessInstanceName, a.ProcessDefId, a.ProcessName, a.ActivityId, a.ActivityName, a.PriorityLevel, a.InstrumentStatus, a.LockStatus, a.LockedByName, a.ValidTill, a.CreatedByName, a.CreatedDateTime, a.Statename, a.CheckListCompleteFlag, a.EntryDateTime, a.LockedTime, a.IntroductionDateTime, a.IntroducedBy, a.AssignedUser, a.WorkItemId, a.QueueName, a.AssignmentType, a.ProcessInstanceState, a.QueueType, a.Status, a.Q_QueueID, a.ReferredByname, a.ReferredTo, a.Q_UserID, a.FILTERVALUE, a.Q_StreamId, a.CollectFlag, a.ParentWorkItemId, a.ProcessedBy, a.LastProcessedBy, a.ProcessVersion, a.WORKITEMSTATE, a.PREVIOUSSTAGE, a.ExpectedWorkItemDelay, a.ProcessVariantId, a.Q_DivertedByUserId,ActivityType, a.VAR_INT1, a.VAR_INT2, a.VAR_INT3, a.VAR_INT4, a.VAR_INT5, a.VAR_INT6, a.VAR_INT7, a.VAR_INT8, a.VAR_FLOAT1, a.VAR_FLOAT2, a.VAR_DATE1, a.VAR_DATE2, a.VAR_DATE3, a.VAR_DATE4,a.VAR_DATE5, a.VAR_DATE6, a.VAR_LONG1, a.VAR_LONG2, a.VAR_LONG3, a.VAR_LONG4, a.VAR_LONG5, a.VAR_LONG6, a.VAR_STR1, a.VAR_STR2, a.VAR_STR3, a.VAR_STR4, a.VAR_STR5, a.VAR_STR6, a.VAR_STR7, a.VAR_STR8, a.VAR_STR9, a.VAR_STR10, a.VAR_STR11, a.VAR_STR12, a.VAR_STR13, a.VAR_STR14, a.VAR_STR15, a.VAR_STR16, a.VAR_STR17, a.VAR_STR18, a.VAR_STR19, a.VAR_STR20, a.VAR_REC_1, a.VAR_REC_2,a.LastModifiedTime,a.URN,b.CanInitiate,''N'' as CaseManager,b.ShowCaseVisual FROM  WFInstrumentTable a  WITH (NOLOCK) inner join WFTaskStatusTable b  WITH (NOLOCK) on a.processinstanceid = b.processinstanceid and a.workitemid = b.workitemid where b.assignedTo = '+@v_quoteChar +@v_UserName +@v_quoteChar + ' and b.taskstatus =2 and ActivityType =32 and a.processinstanceid in(	SELECT  a.ProcessInstanceId FROM  WFInstrumentTable a  WITH (NOLOCK) inner join WFTaskStatusTable b  WITH (NOLOCK) on a.processinstanceid = b.processinstanceid and a.workitemid = b.workitemid where b.assignedTo = '+@v_quoteChar +@v_UserName +@v_quoteChar + ' and b.taskstatus =2 and ActivityType =32
		Except Select a.ProcessInstanceId FROM  WFInstrumentTable a  WITH (NOLOCK) WHERE 1 = 1 AND Q_UserID = '+ CONVERT(NVarchar(10),@v_UserId)+ ' and ActivityType =32 ) )c '
		Select @v_queryStr2 = 'where 1=1 '+ ISNULL(@DBSearchFilter,'') + ISNULL(@v_lastValueStr,'');

	END
	IF(@DBreturnParam = 1 OR @DBreturnParam = 2)
	BEGIN
		SELECT @v_counter = 0
		Select @v_noOfCounters = 1
		SELECT @v_returnCount = 0
		WHILE (@v_counter < @v_noOfCounters)
		BEGIN 
			SELECT @v_CountStr = @v_CountStr1
		
	IF(@DBCaseManagerFlag='A')
	BEGIN
		 
		/*SELECT @v_CountStr1 = 'SELECT COUNT(*) FROM (' + @v_queryStr1 +@v_queryStr2+ @groupByClause +@v_orderByStr + ' ) b'*/
		/*print 'SELECT COUNT(*) FROM (' + @v_queryStr1 
		print @v_queryStr2 
		print @groupByClause 
		print @v_orderByStr 
		print ' ) b'*/
		EXECUTE('DECLARE CountCursor CURSOR Fast_Forward FOR ' + 'SELECT COUNT(*) FROM (' + @v_queryStr1 +@v_queryStr2+ @groupByClause +@v_orderByStr + ' ) b' ) 
		
	END
	ELSE IF(@DBCaseManagerFlag='Y')
	BEGIN 
	
		/*SELECT @v_CountStr1 = 'SELECT COUNT(*) FROM (' + @v_queryStr1 + ') a where 1=1 '+ ISNULL(@DBSearchFilter,'')
+ ISNULL(@v_lastValueStr,'')+ @groupByClause +@v_orderByStr + ' ) b'*/
		/*print 'SELECT COUNT(*) FROM (' + @v_queryStr1 + ') a where 1=1 '+ ISNULL(@DBSearchFilter,'')
		print @v_lastValueStr
		print @groupByClause
		print @v_orderByStr + ' ) b'*/
		EXECUTE('DECLARE CountCursor CURSOR Fast_Forward FOR SELECT COUNT(*) FROM (' + @v_queryStr1 + ') a where 1=1 '+ @v_queryStr2) 
		
	END
	ELSE IF(@DBCaseManagerFlag='N')
	BEGIN 
		 /*SELECT @v_CountStr1 = 'SELECT COUNT(*) FROM (' + @v_queryStr1 +@v_queryForCaseWorker+  @groupByClause +@v_orderByStr + ' ) b' */
		/*print 'SELECT COUNT(*) FROM (' + @v_queryStr1 
		print @v_queryForCaseWorker 
		print @groupByClause 
		print @v_orderByStr 
		print' ) d' */
		EXECUTE('DECLARE CountCursor CURSOR Fast_Forward FOR ' + 'SELECT COUNT(*) FROM (' + @v_queryStr1 +@v_queryForCaseWorker+@v_queryStr2+ @groupByClause +@v_orderByStr + ' ) d' ) 

	END
			
		
			OPEN CountCursor
			FETCH NEXT FROM CountCursor INTO @v_TempCount
			IF (@@FETCH_STATUS < 0) 
			BEGIN 
				SELECT @DBmainCode = 15 
				SELECT @DBsubCode = 802 
				SELECT @v_returnCount = 0
			END
			ELSE
			BEGIN
				SELECT @DBmainCode = 0 
				SELECT @DBsubCode = 0 
			END
			CLOSE CountCursor
			DEALLOCATE CountCursor

			SELECT @v_counter = @v_counter + 1
			SELECT @v_returnCount = @v_returnCount + @v_TempCount
		END
		SELECT MainCode = @DBmainCode, SubCode = @DBsubCode, ReturnCount = @v_returnCount 
	END
        ELSE
	BEGIN
		SELECT MainCode = 0, SubCode = 0, ReturnCount = 0 
	END
	
	IF(@DBreturnParam = 0 OR @DBreturnParam = 2)
	BEGIN
		IF(@DBCaseManagerFlag='A')
				BEGIN
				EXECUTE(
				'SELECT ProcessInstanceId, ProcessInstanceId as ProcessInstanceName,' + ' ProcessDefId, ProcessName, ActivityId, ActivityName, PriorityLevel,InstrumentStatus,  LockStatus, LockedByName, ValidTill, CreatedByName, CreatedDateTime, Statename,' + ' CheckListCompleteFlag, EntryDateTime, LockedTime, IntroductionDateTime, IntroducedBy, AssignedUser,' + ' WorkItemId, QueueName, AssignmentType, ProcessInstanceState, QueueType, Status, Q_QueueID,' + ' null as TurnaroundTime ,ReferredByname, ReferredTo as ReferTo, ExpectedWorkItemDelay, ProcessVariantId, ProcessedBy, Q_DivertedByUserId,ActivityType, VAR_INT1, VAR_INT2, VAR_INT3, VAR_INT4, VAR_INT5, VAR_INT6, VAR_INT7, VAR_INT8, VAR_FLOAT1, VAR_FLOAT2, VAR_DATE1, VAR_DATE2, VAR_DATE3, VAR_DATE4,VAR_DATE5, VAR_DATE6, VAR_LONG1, VAR_LONG2, VAR_LONG3, VAR_LONG4,VAR_LONG5, VAR_LONG6, VAR_STR1, VAR_STR2, VAR_STR3, VAR_STR4, VAR_STR5, VAR_STR6, VAR_STR7, VAR_STR8,VAR_STR9, VAR_STR10, VAR_STR11, VAR_STR12, VAR_STR13, VAR_STR14, VAR_STR15, VAR_STR16, VAR_STR17, VAR_STR18, VAR_STR19, VAR_STR20, VAR_REC_1, VAR_REC_2,CanInitiate,CaseManager,ShowCaseVisual,LastModifiedTime,URN  FROM ( ' 
				+ @v_queryStr1 +@v_queryStr2+ @groupByClause +@v_orderByStr 
				+ ' )c ')
				--print 'SELECT ProcessInstanceId, ProcessInstanceId as ProcessInstanceName,' + ' ProcessDefId, ProcessName, ActivityId, ActivityName, PriorityLevel,InstrumentStatus, LockStatus, LockedByName, ValidTill, CreatedByName, CreatedDateTime, Statename,' + ' CheckListCompleteFlag, EntryDateTime, LockedTime, IntroductionDateTime, IntroducedBy, AssignedUser,' + ' WorkItemId, QueueName, AssignmentType, ProcessInstanceState, QueueType, Status, Q_QueueID,' + ' null as TurnaroundTime ,ReferredByname, ReferredTo as ReferTo, ExpectedWorkItemDelay, ProcessVariantId, ProcessedBy, Q_DivertedByUserId,ActivityType, VAR_INT1, VAR_INT2, VAR_INT3, VAR_INT4, VAR_INT5, VAR_INT6, VAR_INT7, VAR_INT8, VAR_FLOAT1, VAR_FLOAT2, VAR_DATE1, VAR_DATE2, VAR_DATE3, VAR_DATE4,VAR_DATE5, VAR_DATE6, VAR_LONG1, VAR_LONG2, VAR_LONG3, VAR_LONG4,VAR_LONG5, VAR_LONG6, VAR_STR1, VAR_STR2, VAR_STR3, VAR_STR4, VAR_STR5, VAR_STR6, VAR_STR7, VAR_STR8,VAR_STR9, VAR_STR10, VAR_STR11, VAR_STR12, VAR_STR13, VAR_STR14, VAR_STR15, VAR_STR16, VAR_STR17, VAR_STR18, VAR_STR19, VAR_STR20, VAR_REC_1, VAR_REC_2,CanInitiate,CaseManager,ShowCaseVisual,LastModifiedTime,URN  FROM ( ' 
				/*print @v_queryStr1 
				print @v_queryStr2  
				print @groupByClause 
				print @v_orderByStr
				print ' )c '	*/			
				END
			ELSE IF(@DBCaseManagerFlag='Y')
				BEGIN
				--print @v_queryStr1
				EXECUTE(
				'SELECT ProcessInstanceId, ProcessInstanceId as ProcessInstanceName,' + ' ProcessDefId, ProcessName, ActivityId, ActivityName, PriorityLevel, InstrumentStatus,' + ' LockStatus, LockedByName, ValidTill, CreatedByName, CreatedDateTime, Statename,' + ' CheckListCompleteFlag, EntryDateTime, LockedTime, IntroductionDateTime, IntroducedBy, AssignedUser,' + ' WorkItemId, QueueName, AssignmentType, ProcessInstanceState, QueueType, Status, Q_QueueID,' + ' null as TurnaroundTime ,ReferredByname, ReferredTo as ReferTo, ExpectedWorkItemDelay, ProcessVariantId, ProcessedBy, Q_DivertedByUserId,ActivityType, VAR_INT1, VAR_INT2, VAR_INT3, VAR_INT4, VAR_INT5, VAR_INT6, VAR_INT7, VAR_INT8, VAR_FLOAT1, VAR_FLOAT2, VAR_DATE1, VAR_DATE2, VAR_DATE3, VAR_DATE4,VAR_DATE5, VAR_DATE6, VAR_LONG1, VAR_LONG2, VAR_LONG3, VAR_LONG4,VAR_LONG5, VAR_LONG6, VAR_STR1, VAR_STR2, VAR_STR3, VAR_STR4, VAR_STR5, VAR_STR6, VAR_STR7, VAR_STR8,VAR_STR9, VAR_STR10, VAR_STR11, VAR_STR12, VAR_STR13, VAR_STR14, VAR_STR15, VAR_STR16, VAR_STR17, VAR_STR18, VAR_STR19, VAR_STR20, VAR_REC_1, VAR_REC_2,CanInitiate,CaseManager,ShowCaseVisual,LastModifiedTime,URN  FROM ( ' 
				+ @v_queryStr1 + ') a where 1=1 '+ @v_queryStr2)
				--print 'SELECT ProcessInstanceId, ProcessInstanceId as ProcessInstanceName,' + ' ProcessDefId, ProcessName, ActivityId, ActivityName, PriorityLevel, InstrumentStatus,' + ' LockStatus, LockedByName, ValidTill, CreatedByName, CreatedDateTime, Statename,' + ' CheckListCompleteFlag, EntryDateTime, LockedTime, IntroductionDateTime, IntroducedBy, AssignedUser,' + ' WorkItemId, QueueName, AssignmentType, ProcessInstanceState, QueueType, Status, Q_QueueID,' + ' null as TurnaroundTime ,ReferredByname, ReferredTo as ReferTo, ExpectedWorkItemDelay, ProcessVariantId, ProcessedBy, Q_DivertedByUserId,ActivityType, VAR_INT1, VAR_INT2, VAR_INT3, VAR_INT4, VAR_INT5, VAR_INT6, VAR_INT7, VAR_INT8, VAR_FLOAT1, VAR_FLOAT2, VAR_DATE1, VAR_DATE2, VAR_DATE3, VAR_DATE4,VAR_DATE5, VAR_DATE6, VAR_LONG1, VAR_LONG2, VAR_LONG3, VAR_LONG4,VAR_LONG5, VAR_LONG6, VAR_STR1, VAR_STR2, VAR_STR3, VAR_STR4, VAR_STR5, VAR_STR6, VAR_STR7, VAR_STR8,VAR_STR9, VAR_STR10, VAR_STR11, VAR_STR12, VAR_STR13, VAR_STR14, VAR_STR15, VAR_STR16, VAR_STR17, VAR_STR18, VAR_STR19, VAR_STR20, VAR_REC_1, VAR_REC_2,CanInitiate,CaseManager,ShowCaseVisual,LastModifiedTime,URN  FROM ( ' 

				/*print @v_queryStr1 
				print ') a where 1=1 '
				print @v_queryStr2*/
				END
			ELSE IF(@DBCaseManagerFlag='N')
			BEGIN
				EXECUTE(
				'SELECT ProcessInstanceId, ProcessInstanceId as ProcessInstanceName,' + ' ProcessDefId, ProcessName, ActivityId, ActivityName, PriorityLevel, InstrumentStatus,' + ' LockStatus, LockedByName, ValidTill, CreatedByName, CreatedDateTime, Statename,' + ' CheckListCompleteFlag, EntryDateTime, LockedTime, IntroductionDateTime, IntroducedBy, AssignedUser,' + ' WorkItemId, QueueName, AssignmentType, ProcessInstanceState, QueueType, Status, Q_QueueID,' + ' null as TurnaroundTime ,ReferredByname, ReferredTo as ReferTo, ExpectedWorkItemDelay, ProcessVariantId, ProcessedBy, Q_DivertedByUserId,ActivityType, VAR_INT1, VAR_INT2, VAR_INT3, VAR_INT4, VAR_INT5, VAR_INT6, VAR_INT7, VAR_INT8, VAR_FLOAT1, VAR_FLOAT2, VAR_DATE1, VAR_DATE2, VAR_DATE3, VAR_DATE4,VAR_DATE5, VAR_DATE6, VAR_LONG1, VAR_LONG2, VAR_LONG3, VAR_LONG4,VAR_LONG5, VAR_LONG6, VAR_STR1, VAR_STR2, VAR_STR3, VAR_STR4, VAR_STR5, VAR_STR6, VAR_STR7, VAR_STR8,VAR_STR9, VAR_STR10, VAR_STR11, VAR_STR12, VAR_STR13, VAR_STR14, VAR_STR15, VAR_STR16, VAR_STR17, VAR_STR18, VAR_STR19, VAR_STR20, VAR_REC_1, VAR_REC_2,CanInitiate,CaseManager,ShowCaseVisual,LastModifiedTime,URN  FROM ( ' 
				+ @v_queryStr1 +@v_queryForCaseWorker+@v_queryStr2 + @groupByClause +@v_orderByStr + ' ) b')
				/*print  @v_queryStr1 
				print @v_queryForCaseWorker 
				print @groupByClause 
				print @v_orderByStr*/
			END
		END
	RETURN 
END  

	