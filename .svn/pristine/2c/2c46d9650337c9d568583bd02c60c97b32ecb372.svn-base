/*____________________________________________________________________________________________
			NEWGEN SOFTWARE TECHNOLOGIES LIMITED
______________________________________________________________________________________________
	Group				: Application � Products
	Product / Project		: WorkFlow 6.2
	Module				: WorkFlow Server
	File Name			: WFFetchWorkList.sql [Oracle]
	Author				: Ashish Mangla
	Date written (DD/MM/YYYY)	: 27/02/2007
	Description			: Stored procedure for Dynamic queue for 
						WFFetchWorkList API [Optimized].
______________________________________________________________________________________________
				CHANGE HISTORY
______________________________________________________________________________________________
Date			Change By		Change Description (Bug No. (If Any))
05/06/2007		Varun Bhansaly	Bugzilla Bug 1016 (Query on QUserGroupView returns 
								multiple result sets causes exception in Oracle)
06/06/2007		Varun Bhansaly	Bugzilla Id 637 ([View Modification] null referTo -> 
								referredTo as referTo --- Revoke / Unlock / Complete after refer).
13/07/2007		Ruhi Hira		Bugzilla Bug 1390.
06/09/2007		Varun Bhansaly	Added for Support for Complex Query Filters and Generic Queue Filters.

28/09/2007              Shilpi S        Bugzilla Id 1680 
19/10/2007		Vikram Kumbhar	Bugzilla Bug 1703, Support for showing 'only unlocked' or 'both locked and unlocked' workitems in worklist
08/01/2008		Ashish Mangla	Bugzilla Bug 1681 (UserName Marco support required)
08/01/2008		Varun Bhansaly	Bugzilla Id 3310
20/12/2008		Ruhi Hira	Bugzilla Bug 7374, query length increased.
14/10/09		Ashish Mangla	WFS_8.0_044 TurnAroundTime support in FetchWorklist and SearchWorkitem
28/10/2009		Saurabh Kamal	WFS_8.0_046 (In case user is member of multiple groups which are added to Queue, One group having no filter, then user should be able to view workitems considering 'no filter')
29/10/2009		Indraneel	WFS_8.0_047 Support for sorting on queue variables in fetch worklist
04/11/2009		Saurabh Kamal	WFS_8.0_052 Return ProcessedBy in FetchWorklist
02/12/2009		Ashish Mangla	WFS_8.0_061 (Support of process specific alias in case of MYQueue)
23/12/2009		Saurabh Kamal	WFS_8.0_072 Error in Fetchworklist in case of SetFilter on MyQueue
28/09/2010		Saurabh / Preeti	WFS_8.0_133: Error in workitem opening if filter string is very large
29/09/2010		Ashish/Abhishek/	WFS_8.0_136	Support of process specific queue and alias on external table variables.
					Saurabh			
16/11/2010		Abhishek Gupta	WFS_8.0_144(Error in fetching data for MyQueue alias.)
09/12/2010		Abhishek Gupta	WFS_8.0_145(Error in sorting on aliases created).
15/03/2010		Saurabh Kamal	WFS_8.0_153 Support of FUNCTION in QueryFilter
23/05/2011      Vikas Saraswat  Bug 27083 : Order By is not working if inner order is set in queuefilter or user filter
09/06/2011		Ashish Mangla	Bug 27241 ,New QueueType Introduced on which we need not add Q_Queueid = ? criteria, just we need to consider filters only. No worksteps can be added to this type of queue.
24/06/2011		Saurabh Kamal	Bug 27310, Page batching support in FetchWorklist
03/08/2011      Gaurav Rana     Bug 27833, Support of workitem count in searchworkitem [In queue] and restricting sql injection in input xml.
11/06/2012		Saurabh Kamal	Bug 31397 - Error if alias on CreatedDateTime is defined.
13/06/2012		Bhavneet Kaur	Bug 32588: Error in FetchWorkList after creating external table's column alias and applying it in a user level filter
26/09/2012		Shweta Singhal	Bug 35181 - Error code changed for insufficient rights from no more records.
07/02/2013		Shweta Singhal	Bug 38263 - Error code changed for No association with Queue.
17/05/2013		Shweta Singhal	Process Variant Support Changes
29/07/2013		Shweta Singhal	Bug 41579- requested operation failed on newly created queue
10/01/2013		Mohnish Chopra	Changes in Code Optimization
10/02/2014		Shweta Singhal	Paging will be provided on the basis of pagingFlag
12/02/2014		Shweta Singhal	GTempWorkListTable Query removed 
02-06-2014		Sajid Khan		Bug 40904 - Replacing '}' with correct ASCII value.
03/06/2014		Anwar Danish	PRD Bug 42698 merged - "java.sql.SQLException: ORA-06502: character string buffer too small" error returned from wfParseQueryFilter SP which is called from WFFetchWorklist and WFGetWorkitem SP due to small size of input v_ParsedQueryFilter variable then v_QueryFilter variable.
13/06/2014     Anwar Ali Danish  PRD Bug 38828 merged - Changes done for diversion requirement. CSCQR-00000000050705-Process 
11/08/2015	   Mohnish Chopra	Changes for Data Locking issue in Case Management -Returning ActivityType from  Call
10/03/2016     Kirti Wadhwa     Changes for Bug 59472 - RHEL-7 + Weblogic 12.1.2C + Oracle 11g : Requested filter is invalid on sorting through column. 
17/02/2017	   Mohnish Chopra	Merged changes for Fetchworklist from OF 9/10 done by Sanal/Sajid		
22/04/2017	   Sajid Khan		Bug 64902 - QueryFilter is not getting executed in a specific case[Oracle]	
22/04/2017	   Sajid Khan		Bug 63942 - Requested filter invalid issue coming while opening of a worktiem or clicking on a queue where query filter length is more than 265
02-05-2017	    Sajid Khan		Various Issues related to Queue and QUery Filter.
09-05-2017		Sajid Khan			Queue Varaible Extension Enahncement
16-08-2017		Mohnish Chopra		Changes for Case Management - Queue variable header alias should allow spaces
09/19/2017		Mohnish Chopra	Changes for Case management - QueueFilter required on Case workstep queue.
17/10/2017	Ambuj Tripathi		Changes for Case Registration requirements, fetch URN in output
26/10/2017	Ambuj Tripathi		Bugfix for Bug#72843, Query was not getting formed correctly in case when Alias was created.
30/10/2017  Kumar Kimil         Bug 72903 - WBL+Oracle: Getting error in worklist if click on header of alias
1/11/2017   Kumar Kimil         Bug 72917 - WBL+Oracle: Getting error in fetch worklist of My queue if alias has been added on My Queue
02-11-2017	Shubhankur Manuja	Bug Merging - 70858
17/11/2017	Ambuj Tripathi		Bug 73508 - WBL+Oracle: sorting on 'Registration No.' column is not working, commented code for checking if the pagingFlag is Y then not sorting
07/03/2018	Ambuj Tripathi		Bug 76389 - eap 6.4+oracle: Filter on queue is not working in case of alias variable. 
18/04/2018  Kumar Kimil 		Bug 76389 - eap 6.4+oracle: Filter on queue is not working in case of alias variable. 
22/04/2018	Kumar Kimil		    Bug 77269 - CheckMarx changes (High Severity) 
07/06/2018	Mohnish Chopra		Bug 78337 - Paging and Batching in Worklist not working when paging flag is enabled
23/07/2018		Mohnish Chopra	Bug 79314 - Ibps 3.0 sp1+ Oracle : Worklist shows requested operation failed when alias is created on extended queue variables like on var_str9 and var_str10
12/09/2018	Ambuj Tripathi		PRDP merging - Bug 80103 - WFGetWorkitem procedure gets hang if function filter returns null
03/05/2019	Mohnish Chopra		Need to return SecondaryDBFlag in WFFetchWorkItems api.
27/03/2019	Ravi Ranjan Kumar	Bug 83660 - Providing support to Global Queue 
25/07/2019 Shubham Singla       Bug 85725 - iBPS 4.0 +Oracle:Sorting on Queue variable is not working in Oracle Case.
20/12/2019  Shubham Singla      Bug 87781 - iBPS 4.0+Oracle:Function filter on external variable alias are not working.
01/01/2019	Ambuj Tripathi		Internal bug fix for Testing with AIX Server -> Sorting on the queue variable alias are not working.
16/01/2020 Sourabh Tantuway    Bug 90086 - iBPS 4.0 + mssql + oracle + postgres: Support for returning CalendarName in the output of WFFetchWorkItems API, so that Calendar based TAT can be calculated in the post hook.
20/01/2020	Ravi Ranjan Kumar	Bug 90371 - Getting error"The requested filter is invalid." on click on queue name if alias is defined on queue. 
14/02/2020	Ravi Ranjan Kumar	Bug 90701 - initiating WI from global queue does not move to swimlane and wrong error is shown on Oracle + weblogic 
14/02/2020	Ravi Ranjan Kumar	Bug 90641 - "The requested filter is invalid." error shown on swimlane click 
20/03/2020  Sourabh Tantuway   Bug 91401 - iBPS 4.0 + oracle : 'Order by' clause is not working in user filter. Also when order by clause used with filter on queue then opening workitem is giving error.
15/06/2020  Sourabh Tantuway   Bug 92843 - iBPS 4.0 : FetchWorkList is giving error when Alias is defined in small case on any VAR_STR, and same alias is used in user filter
22/02/2021  Sourabh Tantuway   Bug 98269 - iBPS 5.0 SP1 + oracle : Clicking on Search Queue is giving error
05/10/2021  Ravi Raj Mewara    Bug 101894 - iBPS 5.0 SP2 : Support of TAT variables ( TATConsumed and TATRemaining) in omniapp 
12/11/2021  Ravi Raj Mewara   Bug 102318 - TATRemaining and TatConsumed feature not working not able to see on WI list.
____________________________________________________________________________________________*/


/* Algorithm :
	1. Check of user session validity 
	2. Prepare filterString to be appended for (the case like loggedin userindex = (!= ) VAR_INT1	[FILTER WI] 
	3. Prepare the QueryFilter to be appended (User Queue asdsociation filter)			[FILTER WI] 
		-> While getting QueryFiler, Also prepare the the order by string for innerOrderBy. 
		-> QueryFilter may contain Complex Filters of Type &<UserIndex.*>&/ &<GroupIndex.*>&
		-> Use SP WFParseQueryFilter for complex Query Filter Parsing.
	4. If Query Filter is empty for either of User or Group, for NO Assignment Type Queues only, consider Generic Queue Filter.
	5. if data flag is Y, prepare the alias string  
		-> Also check if the sorting is to be done on Alias, get the order by string for that also 
 
CASES :- 
	1. '&<UserIndex>&' should have a space after it. 
	2. Queue-User-Assoc Filter can contain Order By maximxum upto 5 levels. 
	3. If User member of multiple groups, QuerryFilter will be ORed AND Order By of last (that is having order by) group coming is considered. 
*/ 
/*Bugzilla Id 1680
** a new input parameter is added in WFFetchWorklist-SP returnParam, if 0 -> only list, if 1 -> only count, if 2 -> both count and list
** sp will return count value as out parameter
** Oracle will fire a count(*) query will similar conditions as for fetching worklist for case returnParam value 1 & 2
*/

create or replace
PROCEDURE WFFetchWorkList ( 
	temp_DBsessionId			INT, 
	temp_DBqueueId			INT, 
	in_sortOrder			NVARCHAR2, 
	in_orderBy			INT, 
	in_batchSize			INT, 
	in_lastWorkItem			INT, 
	in_dataFlag			NVARCHAR2, 
	in_fetchLockedFlag		NVARCHAR2, /* Bugzilla Bug 1703 */
	temp_in_lastProcessInstance		NVARCHAR2, 
	temp_in_lastValue			NVARCHAR2, 
	temp_in_userFilterStr		NVARCHAR2,
	in_returnParam                  INT, /*0 -> only list, if 1 -> only count, if 2 -> both count and list*/
	in_processAlias			NVARCHAR2,
	in_processDefId			INT,
	in_ClientOrderFlag		NVARCHAR2, 
	in_StartingRecNo		INT,	
	out_mainCode			OUT	INT, 
	out_subCode			OUT	INT, 
	out_returnCount                 OUT     INT, /* returns number of workitems in a queue*/
	out_AliasProcessDefId	OUT	INT,
	RefCursor			OUT ORACONSTPKG.DBLIST,
	in_pagingFlag		NVARCHAR2
) 
AS 
	TYPE DynamicCursor	IS REF CURSOR; 
	v_DBStatus		INT; 
	v_rowCount		INT; 	
	v_filterStr		NVARCHAR2(100); 
	v_filterOption		INT; 
	v_QueryStr		VARCHAR2(32000);  /** 20/12/2008, Bugzilla Bug 7374, query length increased - Ruhi Hira */ 
	v_QDTColStr		VARCHAR2(8000); 
	v_WLTColStr		VARCHAR2(8000); 
	v_WLTColStr1		VARCHAR2(8000);
	v_CountStr              VARCHAR2(8000);
        v_tempCount             INT;
	v_UserId		INT; 
	v_UserName		NVARCHAR2(63); 
	v_queueFilterStr	NVARCHAR2(100); 
	v_existsFlag		INT; 
	v_retval		INT; 
	v_QueryFilter		NVARCHAR2(8000); 
	v_CursorQueryFilter	INT; 
	v_innerOrderBy		NVARCHAR2(500); 
	v_orderByPos		INT; 
	v_tempFilter		NVARCHAR2(8000); 
	v_counter		INT; 
	v_counter1		INT; 
	v_noOfCounters		INT; /* Bugzilla Bug 1703 */
	v_counterCondition	INT; 
	v_CursorAlias		INT;
	v_AliasStr		NVARCHAR2(2000); 
	v_ExtAlias		NVARCHAR2(2000); 
	v_ExtAliasOuter		NVARCHAR2(2000);
	v_Param1ExtAlias NVARCHAR2(2000); 
	v_PARAM1		NVARCHAR2(255); 
	v_ALIAS			NVARCHAR2(255); 
	v_ToReturn		NVARCHAR2(1); 
	v_OrderByStr		NVARCHAR2(500); 
	v_BacthStr		NVARCHAR2(1000); 
	v_sortStr		NVARCHAR2(6); 
	v_op			CHAR(1); 
	v_sortFieldStr		NVARCHAR2(50); 
	v_quoteChar 		CHAR(1); 
	v_DATEFMT 		NVARCHAR2(21); 
	v_tempDataType		NVARCHAR2(50); 
	v_TempColumnName	NVARCHAR2(64); 
	v_TempColumnVal		NVARCHAR2(64); 
	v_TempSortOrder		NVARCHAR2(6); 
	v_TempOperator		NVARCHAR2(3); 
	v_lastValueStr		NVARCHAR2(1000); 
	v_TemplastValueStr	NVARCHAR2(1000); 

	v_innerOrderByCol1	NVARCHAR2(64); 
	v_innerOrderByCol2	NVARCHAR2(64); 
	v_innerOrderByCol3	NVARCHAR2(64); 
	v_innerOrderByCol4	NVARCHAR2(64); 
	v_innerOrderByCol5	NVARCHAR2(64); 
	v_innerOrderBySort1	NVARCHAR2(6); 
	v_innerOrderBySort2	NVARCHAR2(6); 
	v_innerOrderBySort3	NVARCHAR2(6); 
	v_innerOrderBySort4	NVARCHAR2(6); 
	v_innerOrderBySort5	NVARCHAR2(6); 
	v_innerOrderByVal1	NVARCHAR2(256); 
	v_innerOrderByVal2	NVARCHAR2(256); 
	v_innerOrderByVal3	NVARCHAR2(256); 
	v_innerOrderByVal4	NVARCHAR2(256); 
	v_innerOrderByVal5	NVARCHAR2(256); 
	v_innerOrderByType1	NVARCHAR2(50); 
	v_innerOrderByType2	NVARCHAR2(50); 
	v_innerOrderByType3	NVARCHAR2(50); 
	v_innerOrderByType4	NVARCHAR2(50); 
	v_innerOrderByType5	NVARCHAR2(50); 
	v_innerOrderByCount	INT; 
	v_innerLastValueStr	NVARCHAR2(2000); 
	v_CursorLastValue	INT; 
	v_reverseOrder		INT; 
	v_PositionComma		INT; 

	v_Suffix		NVARCHAR2(50);
	v_tableName		NVARCHAR2(30);
	v_tableNameFilter NVARCHAR2(1000);
	v_returnCount		INT;
	v_CountCursor		INT;
	v_extTableName 		NVARCHAR2(50);
	v_extTableStr 		NVARCHAR2(64);
	v_gTempRecStr     	NVARCHAR2(256);
	v_SingleProcessQueue	NVARCHAR2(1);
	v_SearchQueueType		NVARCHAR2(1);
	v_RowIdQuery			NVARCHAR2(50);
	v_RowId					INT;
	
	v_FunctionPos		INTEGER;	
	v_funPos1			INTEGER;
	v_funPos2			INTEGER;
	v_FunValue			VARCHAR(8000);
	queryFunStr			VARCHAR(8000);
	v_functionFlag		VARCHAR(1);
	v_prevFilter		VARCHAR(2000);
	v_funFilter			VARCHAR(2000);
	v_postFilter		VARCHAR(1000);
	v_tempFunStr  		VARCHAR(100);
	v_FunLength			INTEGER;

	v_CursorWLTable		DynamicCursor; 
	v_AliasCursor		DynamicCursor; 
	v_ProcessInstanceId	WFInstrumentTable.ProcessInstanceId%Type; 
	v_ProcessdefId		WFInstrumentTable.ProcessdefId%Type; 
	v_ProcessName		WFInstrumentTable.ProcessName%Type; 
	v_ActivityId		WFInstrumentTable.ActivityId%Type; 
	v_ActivityName		WFInstrumentTable.ActivityName%Type; 
	v_PriorityLevel		WFInstrumentTable.PriorityLevel%Type; 
	v_InstrumentStatus	WFInstrumentTable.InstrumentStatus%Type; 
	v_LockStatus		WFInstrumentTable.LockStatus%Type; 
	v_LockedByName		WFInstrumentTable.LockedByName%Type; 
	v_ValidTill		WFInstrumentTable.ValidTill%Type; 
	v_CreatedByName		WFInstrumentTable.CreatedByName%Type; 
	v_CreatedDateTime	WFInstrumentTable.CreatedDateTime%Type; 
	v_StateName		WFInstrumentTable.StateName%Type; 
	v_CheckListCompleteFlag	WFInstrumentTable.CheckListCompleteFlag%Type; 
	v_EntryDateTime		WFInstrumentTable.EntryDateTime%Type; 
	v_LockedTime		WFInstrumentTable.LockedTime%Type; 
	v_IntroductionDateTime	WFInstrumentTable.IntroductionDateTime%Type; 
	v_IntroducedBy		WFInstrumentTable.IntroducedBy%Type; 
	v_AssignedUser		WFInstrumentTable.AssignedUser%Type; 
	v_WorkitemId		WFInstrumentTable.WorkitemId%Type; 
	v_QueueName		WFInstrumentTable.QueueName%Type; 
	v_AssignmentType	WFInstrumentTable.AssignmentType%Type; 
	v_ProcessInstanceState	WFInstrumentTable.ProcessInstanceState%Type; 
	v_QueueType		WFInstrumentTable.QueueType%Type; 
	v_Status		WFInstrumentTable.Status%Type; 
	v_Q_QueueId		WFInstrumentTable.Q_QueueId%Type; 
	v_ReferredByName	WFInstrumentTable.ReferredByName%Type; 
	v_ReferredTo		WFInstrumentTable.ReferredTo%Type; 
	v_Q_UserId		WFInstrumentTable.Q_UserId%Type; 
	v_FilterValue		WFInstrumentTable.FilterValue%Type; 
	v_Q_StreamId		WFInstrumentTable.Q_StreamId%Type; 
	v_Collectflag		WFInstrumentTable.Collectflag%Type; 
	v_ParentWorkitemId	WFInstrumentTable.ParentWorkitemId%Type; 
	v_ProcessedBy		WFInstrumentTable.ProcessedBy%Type; 
	v_LastProcessedBy	WFInstrumentTable.LastProcessedBy%Type; 
	v_ProcessVersion	WFInstrumentTable.ProcessVersion%Type; 
	v_WorkItemState		WFInstrumentTable.WorkItemState%Type; 
	v_PreviousStage		WFInstrumentTable.PreviousStage%Type; 
	v_ExpectedWorkItemDelay	WFInstrumentTable.ExpectedWorkItemDelay%Type; 
	v_VAR_INT1		WFInstrumentTable.VAR_INT1%Type; 
	v_VAR_INT2		WFInstrumentTable.VAR_INT2%Type; 
	v_VAR_INT3		WFInstrumentTable.VAR_INT3%Type; 
	v_VAR_INT4		WFInstrumentTable.VAR_INT4%Type; 
	v_VAR_INT5		WFInstrumentTable.VAR_INT5%Type; 
	v_VAR_INT6		WFInstrumentTable.VAR_INT6%Type; 
	v_VAR_INT7		WFInstrumentTable.VAR_INT7%Type; 
	v_VAR_INT8		WFInstrumentTable.VAR_INT8%Type; 
	v_VAR_FLOAT1		WFInstrumentTable.VAR_FLOAT1%Type; 
	v_VAR_FLOAT2		WFInstrumentTable.VAR_FLOAT2%Type; 
	v_VAR_DATE1		WFInstrumentTable.VAR_DATE1%Type; 
	v_VAR_DATE2		WFInstrumentTable.VAR_DATE2%Type; 
	v_VAR_DATE3		WFInstrumentTable.VAR_DATE3%Type; 
	v_VAR_DATE4		WFInstrumentTable.VAR_DATE4%Type;
	v_VAR_DATE5		WFInstrumentTable.VAR_DATE5%Type;
	v_VAR_DATE6		WFInstrumentTable.VAR_DATE6%Type;
	v_VAR_LONG1		WFInstrumentTable.VAR_LONG1%Type; 
	v_VAR_LONG2		WFInstrumentTable.VAR_LONG2%Type; 
	v_VAR_LONG3		WFInstrumentTable.VAR_LONG3%Type; 
	v_VAR_LONG4		WFInstrumentTable.VAR_LONG4%Type;
	v_VAR_LONG5		WFInstrumentTable.VAR_LONG5%Type;
	v_VAR_LONG6		WFInstrumentTable.VAR_LONG6%Type;
	v_VAR_STR1		WFInstrumentTable.VAR_STR1%Type; 
	v_VAR_STR2		WFInstrumentTable.VAR_STR2%Type; 
	v_VAR_STR3		WFInstrumentTable.VAR_STR3%Type; 
	v_VAR_STR4		WFInstrumentTable.VAR_STR4%Type; 
	v_VAR_STR5		WFInstrumentTable.VAR_STR5%Type; 
	v_VAR_STR6		WFInstrumentTable.VAR_STR6%Type; 
	v_VAR_STR7		WFInstrumentTable.VAR_STR7%Type; 
	v_VAR_STR8		WFInstrumentTable.VAR_STR8%Type;
	v_VAR_STR9		WFInstrumentTable.VAR_STR9%Type;
	v_VAR_STR10		WFInstrumentTable.VAR_STR10%Type;
	v_VAR_STR11		WFInstrumentTable.VAR_STR11%Type;
	v_VAR_STR12		WFInstrumentTable.VAR_STR12%Type;
	v_VAR_STR13		WFInstrumentTable.VAR_STR13%Type;
	v_VAR_STR14		WFInstrumentTable.VAR_STR14%Type;
	v_VAR_STR15		WFInstrumentTable.VAR_STR15%Type;
	v_VAR_STR16		WFInstrumentTable.VAR_STR16%Type;
	v_VAR_STR17		WFInstrumentTable.VAR_STR17%Type;
	v_VAR_STR18		WFInstrumentTable.VAR_STR18%Type;
	v_VAR_STR19		WFInstrumentTable.VAR_STR19%Type;
	v_VAR_STR20		WFInstrumentTable.VAR_STR20%Type;
	v_VAR_REC1		WFInstrumentTable.VAR_REC_1%Type;
	v_VAR_REC2		WFInstrumentTable.VAR_REC_2%Type;
	v_ParsedQueryFilter NVARCHAR2(8000);
	v_groupID			INT;
	v_QueueFilter		NVARCHAR2(8000);
	v_TempQueryFilter		NVARCHAR2(8000);
	v_AliasProcessFilter	VARCHAR(50);
	v_ProcessFilter			VARCHAR(50);
	v_CommonProcessQuery	VARCHAR(255);
	v_CommonTempId			INT;
	v_CommonTableCount		INT;
	v_CommonProcessDefId 	INT;
	v_CommonProcessCursor	DynamicCursor;
	v_CommonProcessCounter	INT;
	v_VariableId			VarAliasTable.VariableId1%Type;
	v_Type					VarAliasTable.Type1%Type;
	v_JoinExtTable			INT;
	v_ExtTable_QDTable_JoinStr		VARCHAR(3000);
	v_ExtTable_TmpWLTable_JoinStr		VARCHAR(3000);
	v_ExtTable_BTable_JoinStr		VARCHAR(3000); 
	v_QuerySelectColumnStr		VARCHAR(2000);
	v_QDTJoinConditionStr		VARCHAR(255);
	v_ProcessVariantId		INT;
	v_QDTWhereConditionStr		VARCHAR(255);
	v_Q_DivertedByUserId     INT;
	v_QueryFilterUG		NVARCHAR2(8000);
	v_QueryFilterQueue		NVARCHAR2(8000);
	v_NullFlag				VARCHAR2(2);
	v_nullSortStr		VARCHAR2(40);	
	in_lastValue			NVARCHAR2(8000);
    in_userFilterStr    NVARCHAR2(8000);
    in_lastProcessInstance NVARCHAR2(8000);
	DBsessionId			INT;
	DBqueueId			INT;
BEGIN 
    v_quoteChar := CHR(39);
	out_mainCode := 0; 
	out_subCode := 0;
	out_returnCount := 0;
	out_AliasProcessDefId := 0;
	v_CommonProcessDefId  := 0;
	v_AliasProcessFilter := ' AND ProcessDefId = 0 ';
	v_SearchQueueType := N'T';
	v_JoinExtTable := 0; /* default is 0 means do not join  */
	v_orderByStr := '';
	v_NullFlag  := 'Y';	
	/* Check for validity of session ... */ 
	IF(temp_DBsessionId is NOT NULL) THEN
		DBsessionId:=CAST(REPLACE(temp_DBsessionId,v_quoteChar,v_quoteChar||v_quoteChar) AS INTEGER);
	END IF;
	IF(temp_DBqueueId is NOT NULL) THEN
		DBqueueId:=CAST(REPLACE(temp_DBqueueId,v_quoteChar,v_quoteChar||v_quoteChar) AS INTEGER);
	END IF;
	BEGIN 
		SELECT UserID, UserName INTO v_UserId , v_UserName  
		FROM WFSessionView, WFUserView 
		WHERE UserId = UserIndex AND SessionID = DBsessionId; 
		v_rowcount := SQL%ROWCOUNT;  
		v_DBStatus := SQLCODE; 
	EXCEPTION  
		WHEN NO_DATA_FOUND THEN 
		v_rowcount := 0; 		
	END; 

	IF (v_DBStatus <> 0 OR v_rowcount <= 0) THEN 
		out_mainCode := 11; 
		out_subCode := 0; 
		RETURN; 
	END IF;
	
	
	/* 
	in_lastValue:=temp_in_lastValue;
	in_userFilterStr:=temp_in_userFilterStr;
	IF(temp_in_lastProcessInstance IS NOT NULL) THEN 
		in_lastProcessInstance:=REPLACE(temp_in_lastProcessInstance,v_quoteChar,v_quoteChar||v_quoteChar);
	End if; 
	if(in_lastValue is not NULL) THEN
	in_lastValue:=REPLACE(in_lastValue,v_quoteChar,v_quoteChar||v_quoteChar);
	ELSE
	in_lastValue:='';
	in_lastValue:=REPLACE(in_lastValue,v_quoteChar,v_quoteChar||v_quoteChar);
	in_lastValue:=NULL;
	end if;
	if(in_userFilterStr is not NULL) THEN
	in_userFilterStr:=REPLACE(in_userFilterStr,v_quoteChar,v_quoteChar||v_quoteChar);
	in_userFilterStr:=REPLACE(in_userFilterStr,v_quoteChar||v_quoteChar,v_quoteChar);
	else
	in_userFilterStr:='';
	in_userFilterStr:=REPLACE(in_userFilterStr,v_quoteChar,v_quoteChar||v_quoteChar);
	in_userFilterStr:=NULL;
	end if;
	
	*/
	
	IF(temp_in_lastProcessInstance is NOT NULL) THEN
		SELECT sys.DBMS_ASSERT.noop(temp_in_lastProcessInstance) into in_lastProcessInstance FROM dual;
	END IF;	
	IF(temp_in_lastValue is NOT NULL) THEN
		SELECT sys.DBMS_ASSERT.noop(temp_in_lastValue) into in_lastValue FROM dual;
	END IF;
	IF(temp_in_userFilterStr is NOT NULL) THEN
		SELECT sys.DBMS_ASSERT.noop(temp_in_userFilterStr) into in_userFilterStr FROM dual;
	END IF;
	
	
	v_queueFilterStr := ' 1 = 1 '; 
	/* Add filer on the basis of queue ... */
	/* Changed By Varun Bhansaly On 05/06/2007 for Bugzilla Bug 1016 */
	IF (DBqueueId > 0) THEN 
	BEGIN 
		--v_queueFilterStr := ' Q_QueueId = ' || DBqueueId || ' '; 
		BEGIN  
			SELECT 1 INTO v_existsFlag 
			FROM QUserGroupView 
			WHERE QueueId = DBqueueId AND UserId = v_UserId
			AND ROWNUM <= 1; 
		EXCEPTION 
		        WHEN NO_DATA_FOUND THEN 
				out_mainCode := 300; 
				out_subCode := 810; 
				RETURN; 
	        END;  
		/* todo : can add check for queueType - D */ 
		SELECT FilterOption, QueueType, QueueFilter, ProcessName 
		INTO v_filterOption, v_QueueType, v_QueueFilter, v_ProcessName 
		FROM QueueDeftable  
		WHERE QueueID = DBqueueId; 

		v_rowcount := SQL%ROWCOUNT; 

		IF(v_rowcount > 0) THEN 
		BEGIN 
			IF ( v_QueueType = 'G' OR v_QueueType = 'Q') THEN 
				out_mainCode := 18; 
				out_subCode := 0; 
				RETURN;  	
			END IF;
			IF (v_QueueType != v_SearchQueueType AND v_QueueType != 'G') THEN /* Q_QueueId filter considered in case not filter Queue*/
				--v_queueFilterStr := ' Q_QueueId = ' || DBqueueId || ' '; 	
				v_queueFilterStr := ' Q_QueueId = :DBqueueId ';									
			END IF;
			/* case to be checked for 1 - done - Ruhi */ 
			IF(v_filterOption = 2) THEN 
				v_filterStr := ' AND FilterValue' || ' = ' || v_UserId; 
			ELSIF(v_filterOption = 3) THEN  
				v_filterStr := ' AND FilterValue' || ' != ' || v_UserId; 
			END IF; 
			
			IF (v_ProcessName IS NOT NULL) THEN
			BEGIN
				Select TableName INTO v_extTableName from ExtDbConfTable 
				where ProcessDefId = 
					(Select Max(ProcessDefId) from ProcessDefTable WHERE processName = v_ProcessName) 
				and ExtObjId = 1;
				v_extTableName:=REPLACE(v_extTableName,v_quoteChar,v_quoteChar||v_quoteChar);--CheckMarx Changes
			EXCEPTION
				WHEN NO_DATA_FOUND THEN
				v_extTableName := NULL;
			END;
			END IF;
		END; 
		END IF; 

		
		
		/* QueryFilter to be evaluated... */ 
		IF (v_QueueType != 'D' AND v_QueueType != 'd') THEN 
		BEGIN
		BEGIN 
			SELECT QueryFilter INTO v_QueryFilter 
			FROM QueueUserTable  
			WHERE QueueId = DBqueueId AND UserId = v_UserId AND AssociationType = 0; 
			v_rowcount := SQL%ROWCOUNT; 
		EXCEPTION  
		        WHEN NO_DATA_FOUND THEN 
				v_rowcount := 0;  
		END; 

		IF(v_rowcount > 0) THEN 
		BEGIN 
			IF (v_QueryFilter IS NOT NULL) THEN 
				v_QueryFilter := REPLACE(v_QueryFilter, '&<UserIndex>&', v_UserId); 
				v_QueryFilter := REPLACE(v_QueryFilter, '&<UserName>&', v_UserName); 
				v_orderByPos := INSTR(UPPER(v_QueryFilter), 'ORDER BY'); 
				IF (v_orderByPos != 0) THEN
				  IF(in_ClientOrderFlag = N'N') THEN 
					v_innerOrderBy := SUBSTR(v_queryFilter, v_orderByPos + LENGTH('ORDER BY'));
				  END IF;
				  v_queryFilter := SUBSTR(v_queryFilter, 1, v_orderByPos - 1); 
				END IF; 
				Wfparsequeryfilter (v_QueryFilter, N'U', v_UserId, v_ParsedQueryFilter);
				/* As per specifications, User Filters will not contain &<GroupIndex.*>& Hence ignored */
				v_QueryFilter := v_ParsedQueryFilter;
			END IF; 
		END; 
		ELSE 
		BEGIN 
			/* User is not directly associated in Queue, rather is showing like this due to some group is added in queue and user is added in that group*/ 
			v_CursorQueryFilter := DBMS_SQL.OPEN_CURSOR; /* cursor id */ 
			v_QueryStr := 'SELECT QueryFilter, GroupId FROM QUserGroupView WHERE QueueId = ' || 
				DBqueueId || ' AND UserId = '  || v_UserId || ' AND GroupId IS NOT NULL ORDER BY QueryFilter'; 

			DBMS_SQL.PARSE(v_CursorQueryFilter, TO_CHAR(v_QueryStr), DBMS_SQL.NATIVE); 

			DBMS_SQL.DEFINE_COLUMN(v_CursorQueryFilter, 1 , v_QueryFilter, 1000); 
			DBMS_SQL.DEFINE_COLUMN(v_CursorQueryFilter, 2 , v_groupId); 

			v_retval := DBMS_SQL.EXECUTE(v_CursorQueryFilter);  

			/* Fetch next row and close cursor in case of error */ 
			v_DBStatus := DBMS_SQL.FETCH_ROWS(v_CursorQueryFilter);  
			v_counter := 0; 
			WHILE (v_DBStatus <> 0) LOOP 
			BEGIN 
				DBMS_SQL.COLUMN_VALUE(v_CursorQueryFilter, 1, v_QueryFilter);  
				DBMS_SQL.COLUMN_VALUE(v_CursorQueryFilter, 2, v_groupId);  
				v_QueryFilter := LTRIM(RTRIM(v_queryFilter));
				IF (v_QueryFilter IS NOT NULL) THEN 
				BEGIN
					v_QueryFilter := REPLACE(v_QueryFilter, '&<UserIndex>&', v_UserId); 
					v_QueryFilter := REPLACE(v_QueryFilter, '&<UserName>&', v_UserName);
					v_orderByPos := INSTR(UPPER(v_QueryFilter), 'ORDER BY'); 
					IF (v_orderByPos != 0) THEN 
						IF(in_ClientOrderFlag = N'N') THEN 
							v_innerOrderBy := SUBSTR(v_queryFilter, v_orderByPos + LENGTH('ORDER BY')); 
						END IF;
					  v_queryFilter := SUBSTR(v_queryFilter, 1, v_orderByPos - 1); 
					END IF; 
					/* Group Filters can contain &<UserIndex.*>&*/
					Wfparsequeryfilter (v_QueryFilter, N'U', v_UserId, v_ParsedQueryFilter);
					v_QueryFilter := v_ParsedQueryFilter;
					Wfparsequeryfilter (v_QueryFilter, N'G', v_GroupId, v_ParsedQueryFilter);
					v_QueryFilter := v_ParsedQueryFilter;
					/* If multiple groups added to the queue and if logged in user is a member of more than 1 group, 
					 *	all such group filters to be ORed together. 
					 */
					IF (LENGTH(v_queryFilter) > 0) THEN
						v_queryFilter := '(' || v_queryFilter || ')';
						IF (v_counter = 0) THEN 
							v_tempFilter := v_tempFilter || v_queryFilter; 
						ELSE 
							v_tempFilter := v_tempFilter || ' OR ' || v_queryFilter; 
						END IF;
						v_counter := v_counter + 1; 
					END IF;
				END;
				/*WFS_8.0_046*/
				ELSE
				BEGIN
					v_tempFilter := '';
				END;
				END IF;
				--EXIT WHEN v_tempFilter = '';
				/*Case:Bug 64902 - QueryFilter is not getting executed in a specific case[Oracle]
					->Add an User U1 to two differnet groups G1 and G2.
					->Update QueryFilter on a queue Q1 for both groups as follows:
						  G1- null
						  G2 - VAR_INT1 = 12
					->Now login with U1 and click on Q1.All the workitems are fetched irrespective
					of the value of VAR_INT1 = 12.

					RCA:
					 WHen Cursor was opened on QUserGroupView then it was getting exited if the
					first value of QueryFilter is null.*/
				/* Fetch next row and close cursor in case of error */ 
				v_DBStatus := DBMS_SQL.FETCH_ROWS(v_CursorQueryFilter);  
			END; 
			END LOOP; 
			v_queryFilter := v_tempFilter; 
			/* Close the cursor */ 
			dbms_sql.close_cursor(v_CursorQueryFilter); 
		EXCEPTION  
			WHEN OTHERS THEN  
			BEGIN 
				IF (DBMS_SQL.IS_OPEN(v_CursorQueryFilter)) THEN 
					DBMS_SQL.CLOSE_CURSOR(v_CursorQueryFilter);  
				END IF; 
				RETURN;  
			END; 
		END; 
		END IF;	
		END;
		END IF;
		v_QueryFilterUG 	:='';
		v_QueryFilterQueue  := '';
		v_QueryFilterUG 	:= v_queryFilter;--Assigning User or Group filter to v_QueryFilterUG

		/*IF (v_queryFilter IS NOT NULL AND LENGTH(LTRIM(RTRIM(v_queryFilter))) > 0 ) THEN -- in case Order by only is written and one space is before queryfilter
		BEGIN
			v_queryFilter := ' AND ( ' || v_queryFilter || ')' ; 
		END;*/
		--ELSE
		--BEGIN /* Query Filter IS NULL, for No Assignment Queues, check for Queue Filter */
		IF ((v_QueueType = N'N' OR v_QueueType = N'T' OR v_QueueType = N'M') AND v_queueFilter IS NOT NULL AND LENGTH(v_queueFilter) > 0) THEN
		BEGIN
			v_queryFilter := LTRIM(RTRIM(v_queueFilter));
			v_QueryFilter := REPLACE(v_QueryFilter, '&<UserIndex>&', v_UserId); 
			v_QueryFilter := REPLACE(v_QueryFilter, '&<UserName>&', v_UserName);
			v_orderByPos := INSTR(UPPER(v_QueryFilter), 'ORDER BY');
			IF (v_orderByPos <> 0) THEN
			BEGIN 
				IF(in_ClientOrderFlag = N'N') THEN 
					v_innerOrderBy := SUBSTR(v_queryFilter, v_orderByPos + LENGTH('ORDER BY')); 
				END IF;
				v_queryFilter := SUBSTR(v_queryFilter, 1, v_orderByPos - 1); 
			END;
			END IF;
			Wfparsequeryfilter (v_QueryFilter, N'U', v_UserId, v_ParsedQueryFilter);
			v_QueryFilter := v_ParsedQueryFilter;
			v_TempQueryFilter := v_QueryFilter;
			v_QueryStr := 'SELECT GroupId FROM QUserGroupView WHERE QueueId = ' || DBqueueId || ' AND UserId = ' || v_UserId || ' AND GroupId IS NOT NULL'; 
			v_CursorQueryFilter := DBMS_SQL.OPEN_CURSOR; /* cursor id */ 
			DBMS_SQL.PARSE(v_CursorQueryFilter, TO_CHAR(v_QueryStr), DBMS_SQL.NATIVE); 
			DBMS_SQL.DEFINE_COLUMN(v_CursorQueryFilter, 1 , v_groupId); 
			v_retval := DBMS_SQL.EXECUTE(v_CursorQueryFilter);  

			/* Fetch next row and close cursor in case of error */ 
			v_DBStatus := DBMS_SQL.FETCH_ROWS(v_CursorQueryFilter);  

			v_counter := 0; 
			v_tempFilter := '';
			WHILE (v_DBStatus <> 0) LOOP 
			BEGIN 
				/** User can be member of multiple groups, for each of the groups, replace &<GroupIndex.*>& with respective values.
				  * If logged in user is member of 2 groups and both of the groups have rights on the Queue.
				  * Parsed version of filter VAR_INT1 = 1000 AND VAR_STR1 = &<GroupIndex.City>& will be like
				  * ((VAR_INT1 =1000 AND VAR_STR1 = 'Pune') OR (VAR_INT1 =1000 AND VAR_STR1 = 'Kolkata'))
				  * Though it should be like ((VAR_INT1 =1000 AND (VAR_STR1 = 'Pune' OR VAR_STR1 = 'Kolkata'))
				*/
				v_QueryFilter := v_TempQueryFilter;
				DBMS_SQL.COLUMN_VALUE(v_CursorQueryFilter, 1, v_groupId);  

				Wfparsequeryfilter (v_QueryFilter, N'G', v_groupId, v_ParsedQueryFilter);
				v_QueryFilter := v_ParsedQueryFilter;

				IF (LENGTH(v_queryFilter) > 0) THEN
				BEGIN
					v_queryFilter := '(' || v_queryFilter || ')';
					IF (v_counter = 0) THEN
					BEGIN 
						v_tempFilter := v_queryFilter;
					END;
					ELSE  
					BEGIN 
						v_tempFilter := v_tempFilter || ' OR ' || v_queryFilter;
					END;
					END IF;
					v_counter := v_counter + 1;
				END;
				END IF;
				/* Fetch next row and close cursor in case of error */ 
				v_DBStatus := DBMS_SQL.FETCH_ROWS(v_CursorQueryFilter);  
			END;
			END LOOP;
			IF(v_tempFilter IS NOT NULL) THEN
			BEGIN
				v_queryFilter := v_tempFilter;
			END;
			END IF;
			IF (LENGTH(v_queryFilter) > 0) THEN
			BEGIN
				v_QueryFilterQueue := v_queryFilter;
			END;
			END IF;
			/*IF (v_queryFilter IS NOT NULL AND LENGTH(LTRIM(RTRIM(v_queryFilter))) > 0 ) THEN -- in case Order by only is written and one space is before queryfilter
			BEGIN
				v_queryFilter := ' AND ( ' || v_queryFilter || ')' ; 
			END;
			END IF;*/
			/* Close and DeAllocate the CURSOR */ 
			dbms_sql.close_cursor(v_CursorQueryFilter); 
		EXCEPTION  
			WHEN OTHERS THEN  
			BEGIN 
				IF (DBMS_SQL.IS_OPEN(v_CursorQueryFilter)) THEN 
					DBMS_SQL.CLOSE_CURSOR(v_CursorQueryFilter);  
				END IF; 
				RETURN;  
			END; 
		END;
		END IF;
		--END;
		--END IF; 
		IF (v_queryFilter IS NOT NULL AND LENGTH(LTRIM(RTRIM(v_queryFilter))) > 0 ) THEN 
		BEGIN
			IF(((v_QueryFilterUG IS NOT NULL) AND LENGTH(LTRIM(RTRIM(v_QueryFilterUG))) > 0) AND ((v_QueryFilterQueue IS NOT NULL)  AND LENGTH(LTRIM(RTRIM(v_QueryFilterQueue))) > 0)) THEN
				v_queryFilter := ' AND ( ' || v_QueryFilterUG || ' AND '||v_QueryFilterQueue||') ' ; 
			ELSIF(v_QueryFilterUG IS NOT NULL AND LENGTH(LTRIM(RTRIM(v_QueryFilterUG))) > 0) THEN
				v_queryFilter := ' AND ( ' || v_QueryFilterUG || ')' ; 
			ELSIF(v_QueryFilterQueue IS NOT NULL AND LENGTH(LTRIM(RTRIM(v_QueryFilterQueue))) > 0) THEN
				v_queryFilter := ' AND ( ' || v_QueryFilterQueue || ')' ; 
			END IF;
			--v_queryFilter := ' AND ( ' || v_queryFilter || ')' ; 
		END;
		END IF;
	END; 
	ELSE 
		/* 	DBqueueId = 0 Itis case of MYQueue*/ 
		/* Currently webdesktop sends q_userId = <loggedinUserindex> It can be assumed by itself*/ 
		IF (in_processAlias = N'Y' AND in_processDefId = -1) THEN
			/*  v_Counter := 0; */
			v_CommonTableCount := 0;
		/*	WHILE (v_Counter < 1) LOOP /* Bugzilla Bug 1703 */
				/* IF (v_Counter = 0) THEN */
					v_tableNameFilter:= ' RoutingStatus in (' || v_quoteChar || 'N'|| v_quoteChar || ' , '||   v_quoteChar || 'R'|| v_quoteChar|| ' ) AND ACTIVITYTYPE!=32' ; 
				/*END IF; * / 
				v_Counter := v_Counter + 1;
		
			/*	v_CommonProcessQuery := 'SELECT DISTINCT ProcessDefId from ' || v_tableName; */
				v_CommonProcessQuery := 'SELECT DISTINCT ProcessDefId from WFInstrumentTable WHERE ' || v_tableNameFilter;
				IF (in_userFilterStr IS NOT NULL) THEN
					v_CommonProcessQuery := v_CommonProcessQuery || ' AND Q_USERID = ' || TO_CHAR(v_UserId);
				END IF;
				OPEN v_CommonProcessCursor FOR v_CommonProcessQuery;
				v_CommonProcessCounter := 0;
				LOOP
					FETCH v_CommonProcessCursor INTO v_CommonTempId;
					EXIT WHEN v_CommonProcessCursor%NOTFOUND;
					v_CommonProcessCounter := v_CommonProcessCounter + 1;
					IF (v_CommonProcessCounter > 1) THEN
						EXIT;
					END IF;
				END LOOP;
				CLOSE v_CommonProcessCursor;

				IF (v_CommonProcessCounter = 1) THEN
					IF (v_CommonTableCount = 0) THEN
						v_CommonProcessDefId := v_CommonTempId;
						v_CommonTableCount :=  v_CommonTableCount + 1;
					ELSE 
						IF (v_CommonProcessDefId <> v_CommonTempId) THEN
							v_CommonProcessDefId := 0;
							/* EXIT; */
						END IF;
					END IF;
				ELSIF (v_CommonProcessCounter > 1) THEN
					v_CommonProcessDefId := 0;
					/* EXIT; */
				END IF;				
				/*		END LOOP; */
			v_AliasProcessFilter := ' AND ProcessDefId = ' || to_char(v_CommonProcessDefId);
			out_AliasProcessDefId := v_CommonProcessDefId;
		ELSIF (in_processAlias = N'Y' AND in_processDefId > -1) THEN
			IF (in_processDefId > 0 ) THEN
				v_ProcessFilter := ' AND ProcessDefId = ' || to_char(in_processDefId);
				v_AliasProcessFilter := ' AND ProcessDefId = ' || to_char(in_processDefId);
				out_AliasProcessDefId := in_processDefId;
			END IF;
		END IF;
		v_queueFilterStr := ' 1 = 1 ';
	END IF; 
	
	IF (v_QueryFilter IS NOT NULL AND LENGTH(LTRIM(RTRIM(v_QueryFilter))) > 0 ) THEN
		BEGIN
			v_FunctionPos := INSTR(v_QueryFilter, '&<FUNCTION>&');	
			IF(v_FunctionPos != 0) THEN
			v_FunLength := LENGTH('&<FUNCTION>&');
			BEGIN	
				v_functionFlag := 'Y';		
				WHILE(v_functionFlag = 'Y') LOOP
					BEGIN
						v_prevFilter := SUBSTR(v_QueryFilter, 0, v_FunctionPos-1);
						v_funPos1 := INSTR(v_QueryFilter, CHR(123));				
						
						v_tempFunStr := SUBSTR(v_QueryFilter, v_FunctionPos + v_FunLength, v_funPos1 - (v_FunctionPos + v_FunLength));
						v_tempFunStr := LTRIM(RTRIM(v_tempFunStr));						
						
						IF (v_tempFunStr IS NULL OR LENGTH(v_tempFunStr) = 0) THEN
							v_funPos2 := INSTR(v_QueryFilter, CHR(125));
							v_funFilter := SUBSTR(v_QueryFilter, v_funPos1 + 1, v_funPos2 - v_funPos1 -1);
							v_postFilter := SUBSTR(v_QueryFilter, v_funPos2 + 1);
							queryFunStr := 'SELECT ' || v_funFilter || ' FROM DUAL ';							
							EXECUTE IMMEDIATE queryFunStr INTO v_FunValue;
							
							--PRDP Bug merge - 80103
							IF(v_FunValue IS NULL OR LENGTH(LTRIM(RTRIM(v_FunValue))) <= 0 ) THEN
								v_FunValue := '1 = 1';
							END IF;
							
							v_FunValue:=REPLACE(v_FunValue,v_quoteChar,v_quoteChar||v_quoteChar);
							v_FunValue:=REPLACE(v_FunValue,v_quoteChar||v_quoteChar,v_quoteChar);
							v_QueryFilter := v_prevFilter || ' ' || v_FunValue || ' ' || v_postFilter;
						ELSE
							EXIT;
						END IF;							
						v_FunctionPos := INSTR(v_QueryFilter, '&<FUNCTION>&');
						IF(v_FunctionPos = 0) THEN
							v_functionFlag := 'N';
						END IF;					
					END;
				END LOOP;						
			END;	
			END IF;
			END;
		END IF;	

	/* Bugzilla Bug 1390, Alias on system variables not working, 13/07/2007 - Ruhi Hira */
		IF (in_dataFlag = N'Y' OR  in_orderBy > 100 OR v_innerOrderBy IS NOT NULL OR v_queryFilter IS NOT NULL OR in_returnParam = 1) THEN 
	BEGIN 
		v_QueryStr := 'SELECT PARAM1, ALIAS, ToReturn, VariableId1, TYPE1 FROM VarAliasTable WHERE QueueId = ' || DBqueueId || v_AliasProcessFilter || ' ORDER BY ID ASC'; 
		
		Open v_AliasCursor For v_QueryStr;
		v_counter := 1;	
		LOOP 
			FETCH v_AliasCursor INTO v_PARAM1, v_ALIAS, v_ToReturn, v_VariableId, v_Type;
			EXIT WHEN v_AliasCursor%NOTFOUND;
			v_PARAM1:=REPLACE(v_PARAM1,v_quoteChar,v_quoteChar||v_quoteChar);--CheckMarx Changes
			v_ALIAS:=REPLACE(v_ALIAS,v_quoteChar,v_quoteChar||v_quoteChar);--CheckMarx Changes
			IF (v_ToReturn = N'Y') THEN
				IF(v_PARAM1 = UPPER('CreatedDateTime')) THEN
					v_PARAM1 := 'WFInstrumentTable.' || v_PARAM1;
				END IF;
				IF (v_ALIAS LIKE '%'||chr(32)||'%') THEN
					BEGIN
						IF(UPPER(v_PARAM1) = UPPER('TATRemaining')) THEN
							BEGIN
							    v_AliasStr :=  v_AliasStr || ', ' || '''TATRemaining_' || v_counter ||''' AS "' || v_ALIAS||'"'; 
								v_ExtAlias := v_ExtAlias || ', "' || v_ALIAS||'"';
								v_ExtAliasOuter := v_ExtAliasOuter || ', ' || '''TATRemaining_' || v_counter ||''' AS "' || v_ALIAS ||'"'; 
							END;
						ELSIF (UPPER(v_PARAM1) = UPPER('TATConsumed')) THEN
							BEGIN
							    v_AliasStr :=  v_AliasStr || ', ' || '''TATConsumed_' || v_counter ||''' AS "' || v_ALIAS||'"'; 
								v_ExtAlias := v_ExtAlias || ', "' || v_ALIAS||'"';
								v_ExtAliasOuter := v_ExtAliasOuter || ', ' || '''TATConsumed_' || v_counter ||''' AS "' || v_ALIAS ||'"'; 
							END;
						ELSE
							BEGIN
								v_AliasStr :=  v_AliasStr || ', ' || v_PARAM1 || ' AS "' || v_ALIAS||'"'; 
								v_ExtAlias := v_ExtAlias || ', "' || v_ALIAS||'"';
								v_ExtAliasOuter := v_ExtAliasOuter || ', ' || v_PARAM1 || ' AS "' || v_ALIAS ||'"'; 
							END;	
                        END IF;							
					END;
				ELSE
					BEGIN
					    IF(UPPER(v_PARAM1) = UPPER('TATRemaining')) THEN
							BEGIN
								v_AliasStr :=  v_AliasStr || ', ' || '''TATRemaining_' || v_counter ||''' AS ' || v_ALIAS||''; 
								v_ExtAlias := v_ExtAlias || ', ' || v_ALIAS;
								v_ExtAliasOuter := v_ExtAliasOuter || ', ' || '''TATRemaining_' || v_counter ||''' AS ' || v_ALIAS; 
							END;
						ELSIF (UPPER(v_PARAM1) = UPPER('TATConsumed')) THEN
							BEGIN
								v_AliasStr :=  v_AliasStr || ', ' || '''TATConsumed_' || v_counter ||''' AS ' || v_ALIAS||''; 
								v_ExtAlias := v_ExtAlias || ', ' || v_ALIAS;
								v_ExtAliasOuter := v_ExtAliasOuter || ', ' || '''TATConsumed_' || v_counter ||''' AS ' || v_ALIAS; 
							END;
						ELSE
							BEGIN
								v_AliasStr :=  v_AliasStr || ', ' || v_PARAM1 || ' AS ' || v_ALIAS||''; 
								v_ExtAlias := v_ExtAlias || ', ' || v_ALIAS;
								v_ExtAliasOuter := v_ExtAliasOuter || ', ' || v_PARAM1 || ' AS ' || v_ALIAS; 
                            END;	
                        END IF;							
					END;
				end if;	
				
			END IF; 
			
			IF (in_orderBy > 100) THEN
				IF (v_VariableId = in_orderBy) THEN  
				
					IF (v_ALIAS LIKE '%'||chr(32)||'%') THEN
						BEGIN
							v_sortFieldStr := ' "' || v_ALIAS || '" '; 
						END;
					ELSE
						BEGIN
							v_sortFieldStr := v_ALIAS ;
						END;
					END IF;
					IF (v_Type = 8) THEN
						v_tempDataType	:= 'DATE';
					END IF;
				END IF; 
			END IF;
			
			IF ((v_VariableId > 157 AND (v_VariableId < 10001 OR v_VariableId > 10023) AND v_extTableName IS NOT NULL) AND (UPPER(v_PARAM1) != 'TATREMAINING' AND UPPER(v_PARAM1) != 'TATCONSUMED')) THEN
				v_JoinExtTable := 1;
				v_Param1ExtAlias := v_Param1ExtAlias || ', ' || v_PARAM1;
			END IF;
			v_counter := v_counter + 1;
		END LOOP; 
		CLOSE v_AliasCursor; 
		
		/* IF sorting was on something > 100 but no alias defined on the same, error should be returned.
			 
		*/
		
		IF (in_orderBy > 100 AND v_sortFieldStr IS NULL) THEN
			out_mainCode := 400; 
			out_subCode := 852; /* subcode changed for bug 41579*/
			RETURN; 
		END IF;
		
/* Fetch next row and close cursor in case of error */ 
	EXCEPTION  
		WHEN OTHERS THEN 
		BEGIN 
			/* close cursor*/
			RETURN;  
		END; 
	END; 
	END IF;

	IF (v_JoinExtTable = 1) THEN
		v_gTempRecStr :=' WHERE GTempWorkListTable.VAR_REC_1 = ItemIndex AND GTempWorkListTable.VAR_REC_2 = ItemType ';
		v_ExtTable_QDTable_JoinStr := ' INNER JOIN ' || '(Select ItemIndex, ItemType '||v_Param1ExtAlias||'  from ' ||v_extTableName || ')' ||v_extTableName ||
		' ON (WFInstrumentTable.VAR_REC_1 = ItemIndex AND WFInstrumentTable.VAR_REC_2 = ItemType)';
		v_ExtTable_TmpWLTable_JoinStr := ' INNER JOIN ' ||  '(Select ItemIndex, ItemType '||v_Param1ExtAlias|| ' from ' ||v_extTableName || ')' ||v_extTableName ||' ON (GTempWorkListTable.VAR_REC_1 = ItemIndex AND GTempWorkListTable.VAR_REC_2 = ItemType)';
		v_ExtTable_BTable_JoinStr := ' INNER JOIN ' || '(Select ItemIndex, ItemType  ' ||v_Param1ExtAlias||' from ' ||v_extTableName || ')' ||v_extTableName ||  ' ON (b.VAR_REC_1 = ItemIndex AND b.VAR_REC_2 = ItemType)'; 
		/*Need to change */
	ELSE	
		v_extTableName := '';
		v_gTempRecStr :='';
		v_ExtTable_TmpWLTable_JoinStr := '';
		v_ExtTable_QDTable_JoinStr := '';
		v_ExtTable_BTable_JoinStr := '';
	END IF;
		
	v_quoteChar := CHR(39);  
	v_DATEFMT := 'YYYY-MM-DD HH24:MI:SS'; 

	/* Define sortOrder */ 
	IF(in_sortOrder = 'D') THEN 
		v_reverseOrder := 1; 
		v_sortStr := ' DESC '; 
		v_nullSortStr := ' NULLS LAST ';
		v_op := '<'; 
	ELSE /* IF(in_sortOrder = 'A') */ 
		v_reverseOrder := 0; 
		v_sortStr := ' ASC '; 
		v_op := '>'; 
		v_nullSortStr := ' NULLS FIRST ';
	END IF; 

	IF (v_innerOrderBy IS NULL) THEN 
		IF(in_orderBy = 1) THEN 
		BEGIN 
			v_lastValueStr := in_lastValue; 
			v_sortFieldStr := ' PriorityLevel '; 
			v_NullFlag  := 'N';		
		END; 
		ELSIF(in_orderBy = 2) THEN 
		BEGIN 
			IF(LENGTH(in_lastValue) > 0) THEN 
				v_lastValueStr := v_quoteChar || in_lastValue || v_quoteChar; 
			END IF; 
			v_sortFieldStr := ' ProcessInstanceId '; 
			v_NullFlag  := 'N';		
		END; 
		ELSIF(in_orderBy = 3) THEN 
		BEGIN 
			IF(LENGTH(in_lastValue) > 0) THEN 
				v_lastValueStr := v_quoteChar || in_lastValue || v_quoteChar; 
			END IF; 
			v_sortFieldStr := ' ActivityName '; 
			v_NullFlag  := 'N';		
		END; 
		ELSIF(in_orderBy = 4) THEN 
		BEGIN 
			IF(LENGTH(in_lastValue) > 0) THEN 
				v_lastValueStr := v_quoteChar || in_lastValue || v_quoteChar; 
			END IF; 
			v_sortFieldStr := ' LockedByName '; 
		END; 
		ELSIF(in_orderBy = 5) THEN 
		BEGIN 
			IF(LENGTH(in_lastValue) > 0) THEN 
				v_lastValueStr := v_quoteChar || in_lastValue || v_quoteChar; 
			END IF; 
			v_sortFieldStr := ' IntroducedBy '; 
		END; 
		ELSIF(in_orderBy = 6) THEN 
		BEGIN 
			IF(LENGTH(in_lastValue) > 0) THEN 
				v_lastValueStr := v_quoteChar || in_lastValue || v_quoteChar; 
			END IF;	 
			v_sortFieldStr := ' InstrumentStatus '; 
		END; 
		ELSIF(in_orderBy = 7) THEN 
		BEGIN 
			IF(LENGTH(in_lastValue) > 0) THEN 
				v_lastValueStr := v_quoteChar || in_lastValue || v_quoteChar; 
			END IF; 
			v_sortFieldStr := ' CheckListCompleteFlag '; 
		END; 
		ELSIF(in_orderBy = 8) THEN 
		BEGIN 
			IF(LENGTH(in_lastValue) > 0) THEN 
				v_lastValueStr := v_quoteChar || in_lastValue || v_quoteChar; 
			END IF; 
			v_sortFieldStr := ' LockStatus '; 
			v_NullFlag  := 'N';		
		END; 
		ELSIF(in_orderBy = 9) THEN 
		BEGIN 
			IF(LENGTH(in_lastValue) > 0) THEN 
				v_lastValueStr := in_lastValue; 
			END IF; 
			v_sortFieldStr := ' WorkItemState '; 
			v_NullFlag  := 'N';		
		END; 
		ELSIF(in_orderBy = 10) THEN 
		BEGIN 
			IF(LENGTH(in_lastValue) > 0) THEN 
				v_lastValueStr := ' TO_DATE(' || v_quoteChar || SUBSTR(in_lastValue, 1, 19) || v_quoteChar || ' , ' || v_quoteChar || v_DATEFMT || v_quoteChar || ') ' ; 
			END IF; 
			v_sortFieldStr := ' EntryDateTime '; 
			v_NullFlag  := 'N';		
		END; 
		ELSIF(in_orderBy = 11) THEN 
		BEGIN 
			IF(LENGTH(in_lastValue) > 0) THEN 
				v_lastValueStr := ' TO_DATE(' || v_quoteChar || SUBSTR(in_lastValue, 1, 19) || v_quoteChar || ' , ' || v_quoteChar || v_DATEFMT || v_quoteChar || ') ' ; 
			END IF; 
			v_sortFieldStr := ' ValidTill '; 
		END; 
		ELSIF(in_orderBy = 12) THEN 
		BEGIN 
			IF(LENGTH(in_lastValue) > 0) THEN 
				v_lastValueStr := ' TO_DATE(' || v_quoteChar || SUBSTR(in_lastValue, 1, 19) || v_quoteChar || ' , ' || v_quoteChar || v_DATEFMT || v_quoteChar || ') ' ; 
			END IF; 
			v_sortFieldStr := ' LockedTime '; 
		END; 
		ELSIF(in_orderBy = 13) THEN 
		BEGIN 
			IF(LENGTH(in_lastValue) > 0) THEN 
				v_lastValueStr := ' TO_DATE(' || v_quoteChar || SUBSTR(in_lastValue, 1, 19) || v_quoteChar || ' , ' || v_quoteChar || v_DATEFMT || v_quoteChar || ') ' ; 
			END IF;	 
			v_sortFieldStr := ' IntroductionDateTime '; 
		END; 		
		ELSIF(in_orderBy = 16) THEN  
		BEGIN  
			IF(LENGTH(in_lastValue) > 0) THEN  
				v_lastValueStr := v_quoteChar || in_lastValue || v_quoteChar;  
			END IF;  
			v_sortFieldStr := ' AssignedUser ';  
		END; 		
		ELSIF(in_orderBy = 17) THEN 
		BEGIN 
			IF(LENGTH(in_lastValue) > 0) THEN 
				v_lastValueStr := v_quoteChar || in_lastValue || v_quoteChar; 
			END IF; 
			v_sortFieldStr := ' Status '; 
		END; 
		ELSIF(in_orderBy = 18) THEN 
			IF(LENGTH(in_lastValue) > 0) THEN 
				v_lastValueStr := ' TO_DATE(' || v_quoteChar || SUBSTR(in_lastValue, 1, 19) || v_quoteChar || ' , ' || v_quoteChar || v_DATEFMT || v_quoteChar || ') ' ; 
			END IF; 
			v_sortFieldStr := ' CreatedDateTime '; 
			v_NullFlag  := 'N';		
		ELSIF(in_orderBy = 19) THEN 
			IF(LENGTH(in_lastValue) > 0) THEN 
				v_lastValueStr := ' TO_DATE(' || v_quoteChar || SUBSTR(in_lastValue, 1, 19) || v_quoteChar || ' , ' || v_quoteChar || v_DATEFMT || v_quoteChar || ') ' ; 
			END IF; 
			v_sortFieldStr := ' ExpectedWorkItemDelay '; 
		ELSIF(in_orderBy = 20) THEN 
			IF(LENGTH(in_lastValue) > 0) THEN 
				v_lastValueStr := v_quoteChar || in_lastValue || v_quoteChar ; 
			END IF; 
			v_sortFieldStr := ' ProcessedBy '; 
		ELSIF(in_orderBy > 100) THEN 
		BEGIN 
			IF(LENGTH(in_lastValue) > 0) THEN 
				IF (v_tempDataType = 'DATE') THEN 
					v_lastValueStr := ' TO_DATE(' || v_quoteChar || SUBSTR(in_lastValue, 1, 19) || v_quoteChar || ' , ' || v_quoteChar || v_DATEFMT || v_quoteChar || ') ' ; 
				ELSE 
					v_lastValueStr := v_quoteChar || in_lastValue || v_quoteChar; 
				END IF; 
			END IF; 

		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
			out_mainCode := 400; 
			out_subCode := 802; 
			RETURN; 
		END; 
		END IF; 
		IF(temp_in_lastProcessInstance IS NOT NULL) THEN 
		SELECT sys.DBMS_ASSERT.noop(temp_in_lastProcessInstance) into in_lastProcessInstance FROM dual;
		--in_lastProcessInstance:=REPLACE(temp_in_lastProcessInstance,v_quoteChar,v_quoteChar||v_quoteChar);
		BEGIN 
			/*v_TempColumnVal := v_lastValueStr; 

			IF(in_lastValue IS NOT NULL) THEN 
				v_lastValueStr := ' AND ( ( ' || v_sortFieldStr || v_op || v_TempColumnVal || ') ' ; 
				v_lastValueStr := v_lastValueStr || ' OR ( ' || v_sortFieldStr || ' = ' || v_TempColumnVal; 
			ELSE 
				v_lastValueStr := ' AND  ( ( ' || v_sortFieldStr || ' IS NULL '; 
			END IF; 

			v_lastValueStr := v_lastValueStr || ' AND (  '; 
			v_lastValueStr := v_lastValueStr || ' ( Processinstanceid = ' || v_quoteChar || in_lastProcessInstance || v_quoteChar || ' AND  WorkItemId ' || v_op || in_lastWorkItem || ' )'; 
			v_lastValueStr := v_lastValueStr || ' OR Processinstanceid' || v_op || v_quoteChar || in_lastProcessInstance || v_quoteChar; 
			v_lastValueStr := v_lastValueStr || ' ) '; 

			IF(in_lastValue IS NOT NULL) THEN 
				IF (in_sortOrder = 'A') THEN 
					v_lastValueStr := v_lastValueStr || ') OR (' || v_sortFieldStr ||  ' IS NULL )' ; 
				ELSE 
					v_lastValueStr := v_lastValueStr || ') ' ; 
				END IF; 
				v_lastValueStr := v_lastValueStr || ') ' ; 
			ELSE 
				IF (in_sortOrder = 'D') THEN 
					v_lastValueStr := v_lastValueStr || ') OR (' || v_sortFieldStr ||  ' IS NOT NULL )'; 
				ELSE 
					v_lastValueStr := v_lastValueStr || ') ' ; 
				END IF; 
				v_lastValueStr := v_lastValueStr || ') ' ; 
			END IF; 
		END; 
		END IF; */
			v_TempColumnVal := v_lastValueStr; 
			/*LastValue and LastProcessInstanceId would be same so removing the unwanted condition in case of Fetch In Order of 
			is selected as ProcessInstanceName*/
			IF(in_orderBy <> 2) THEN
			BEGIN
				IF(in_lastValue IS NOT NULL) THEN 
					v_lastValueStr := ' AND ( ' || v_sortFieldStr || v_op || v_TempColumnVal ; 
					v_lastValueStr := v_lastValueStr || ' OR ( ' || v_sortFieldStr || ' = ' || v_TempColumnVal; 
				ELSE 
					IF(v_NullFlag = 'Y') THEN
					BEGIN
						v_lastValueStr := ' AND  ( ( ' || v_sortFieldStr || ' IS NULL '; 
					END;
					END IF;					
				END IF; 
			END;
			END IF;
			
			IF(in_orderBy = 2) THEN -- Fetch In Order Of ProcessInstanceId
			BEGIN
				v_lastValueStr := ' AND ('; 
				v_lastValueStr := v_lastValueStr || 'Processinstanceid' || v_op || v_quoteChar || in_lastProcessInstance || v_quoteChar; 
				v_lastValueStr := v_lastValueStr || ' OR ( Processinstanceid = ' || v_quoteChar || in_lastProcessInstance || v_quoteChar || ' AND  WorkItemId ' || v_op || in_lastWorkItem || ')'; 
			END;
			ELSE	---- Fetch In Order Of for Fields Other Than ProcessInstanceId
			BEGIN
				v_lastValueStr := v_lastValueStr || ' AND  '; 
				v_lastValueStr := v_lastValueStr || 'Processinstanceid' || v_op || v_quoteChar || in_lastProcessInstance || v_quoteChar; 
			END;
			END IF;
			IF(in_lastValue IS NOT NULL) THEN 
				IF (in_sortOrder = 'A') THEN 
					v_lastValueStr := v_lastValueStr || ')' ; 
				ELSE 
					IF(v_NullFlag = 'Y') THEN
						v_lastValueStr := v_lastValueStr || ') OR (' ||v_sortFieldStr ||  ' IS NULL )' ;
					ELSE
						v_lastValueStr := v_lastValueStr || ')' ;
					END IF;
				END IF; 
				IF(in_orderBy <> 2) THEN
					v_lastValueStr := v_lastValueStr || ')' ; 
				END IF;
			ELSE 
				IF (in_sortOrder = 'D') THEN 
					v_lastValueStr := v_lastValueStr || ')'; 
				ELSE 
					v_lastValueStr := v_lastValueStr || ') OR (' || v_sortFieldStr ||' IS NOT NULL )'; 
				END IF; 
				v_lastValueStr := v_lastValueStr || ') ' ; 
			END IF; 
		END; 
		END IF; 
		IF(v_NullFlag = 'N') THEN
			v_nullSortStr :='';
		END IF;
		IF (in_orderBy = 2 OR v_sortFieldStr IS NULL OR v_sortFieldStr = '') THEN 
           v_orderByStr := ' ORDER BY ProcessInstanceID ' || v_sortStr || ', WorkItemID ' || v_sortStr; 
		ELSE 
			v_orderByStr := ' ORDER BY ' || v_sortFieldStr || v_sortStr ||v_nullSortStr||', ProcessInstanceID ' || v_sortStr 
					|| ', WorkItemID ' || v_sortStr; 
		END IF; 

	ELSE 
		v_orderByStr := ' ORDER BY '; 
		v_innerOrderBy := v_innerOrderBy || ','; 

		v_PositionComma := INSTR (v_innerOrderBy, ','); 
		v_innerOrderByCount := 0; 

		WHILE (v_PositionComma > 0) LOOP 
			v_innerOrderByCount := v_innerOrderByCount + 1; 

			v_TempColumnName := SUBSTR(v_innerOrderBy, 1 , v_PositionComma - 1); 

			v_orderByPos := INSTR( UPPER(v_TempColumnName), 'ASC'); 
			IF (v_orderByPos > 0) THEN 
				v_TempSortOrder := 'ASC'; 
				v_TempColumnName := RTRIM(SUBSTR(v_TempColumnName, 1, v_orderByPos -1)); 
			ELSE 
				v_orderByPos := INSTR( UPPER(v_TempColumnName), 'DESC'); 
				IF (v_orderByPos > 0) THEN 
					v_TempSortOrder := 'DESC'; 
					v_TempColumnName := RTRIM(SUBSTR(v_TempColumnName, 1, v_orderByPos -1)); 
				ELSE 
					v_TempSortOrder := 'ASC'; 
				END IF; 
			END IF; 

			IF (v_reverseOrder = 1) THEN 
				IF (v_TempSortOrder = 'ASC') THEN 
					v_TempSortOrder := 'DESC'; 
				ELSE 
					v_TempSortOrder := 'ASC'; 
				END IF; 
			END IF; 

			IF (v_innerOrderByCount = 1) THEN 
				--v_innerLastValueStr := v_TempColumnName; 
				IF( (INSTR( UPPER(LTRIM(RTRIM(v_TempColumnName))),'DATE' ) > 0) OR ( UPPER(LTRIM(RTRIM(v_TempColumnName))) = 'VALIDTILL')  )THEN
					v_innerLastValueStr := ' TO_CHAR( ' || v_TempColumnName || ' , ' || v_quoteChar || v_DATEFMT || v_quoteChar || ') ' ; 
				ELSE
				  v_innerLastValueStr := v_TempColumnName; 
				END IF;
				v_orderByStr := v_orderByStr || v_TempColumnName || ' ' || v_TempSortOrder; 
			ELSE 
				--IF(UPPER(LTRIM(RTRIM(v_TempColumnName))) = UPPER('entrydatetime'))THEN
				IF( (INSTR( UPPER(LTRIM(RTRIM(v_TempColumnName))),'DATE' ) > 0) OR ( UPPER(LTRIM(RTRIM(v_TempColumnName))) = 'VALIDTILL')  )THEN
					v_innerLastValueStr := v_innerLastValueStr ||  ', ' || ' TO_CHAR( ' || v_TempColumnName || ' , ' || v_quoteChar || v_DATEFMT || v_quoteChar || ') ' ; 
				ELSE
					v_innerLastValueStr := v_innerLastValueStr ||  ', ' || v_TempColumnName; 
				END IF;
				v_orderByStr := v_orderByStr || ', ' || v_TempColumnName || ' ' || v_TempSortOrder; 
			END IF; 

			IF (v_innerOrderByCount = 1 ) THEN 
				v_innerOrderByCol1 := v_TempColumnName; 
				v_innerOrderBySort1 := v_TempSortOrder; 
			ELSIF (v_innerOrderByCount = 2 ) THEN 
				v_innerOrderByCol2 := v_TempColumnName; 
				v_innerOrderBySort2 := v_TempSortOrder; 
			ELSIF (v_innerOrderByCount = 3 ) THEN 
				v_innerOrderByCol3 := v_TempColumnName; 
				v_innerOrderBySort3 := v_TempSortOrder; 
			ELSIF (v_innerOrderByCount = 4 ) THEN 
				v_innerOrderByCol4 := v_TempColumnName; 
				v_innerOrderBySort4 := v_TempSortOrder; 
			ELSIF (v_innerOrderByCount = 5 ) THEN 
				v_innerOrderByCol5 := v_TempColumnName; 
				v_innerOrderBySort5 := v_TempSortOrder; 
			END IF; 
			v_innerOrderBy := SUBSTR(v_innerOrderBy, v_PositionComma + 1); 
			v_PositionComma := INSTR (v_innerOrderBy, ','); 
		END LOOP; 
		v_orderByStr := v_orderByStr || ', ' || 'ProcessInstanceID' || v_sortStr || ', WorkItemID ' || v_sortStr; 

		IF(in_lastProcessInstance IS NOT NULL) THEN 
			v_counter := 0; 

			WHILE (v_counter < v_innerOrderByCount) LOOP 
				v_counter := v_counter + 1; 
				IF (v_counter = 1 ) THEN 
					v_sortFieldStr := v_innerOrderByCol1; 
				ELSIF (v_counter = 2 ) THEN 
					v_sortFieldStr := v_innerOrderByCol2; 
				ELSIF (v_counter = 3 ) THEN 
					v_sortFieldStr := v_innerOrderByCol3; 
					v_sortFieldStr := v_innerOrderByCol3; 
				ELSIF (v_counter = 4 ) THEN 
					v_sortFieldStr := v_innerOrderByCol4; 
				ELSIF (v_counter = 5 ) THEN 
					v_sortFieldStr := v_innerOrderByCol5; 
				END IF; 
				
				IF( (INSTR( UPPER(LTRIM(RTRIM(v_sortFieldStr))),'DATE' ) > 0) OR ( UPPER(LTRIM(RTRIM(v_sortFieldStr))) = 'VALIDTILL')  )THEN
				--IF(UPPER(LTRIM(RTRIM(v_sortFieldStr))) = UPPER('entrydatetime'))THEN
					v_tempDataType	:= 'DATE'; 
				END IF;

				IF (v_counter = 1 ) THEN 
					v_innerOrderByType1 := v_tempDataType; 
				ELSIF (v_counter = 2 ) THEN 
					v_innerOrderByType2 := v_tempDataType; 
				ELSIF (v_counter = 3 ) THEN 
					v_innerOrderByType3 := v_tempDataType; 
				ELSIF (v_counter = 4 ) THEN 
					v_innerOrderByType4 := v_tempDataType; 
				ELSIF (v_counter = 5 ) THEN 
					v_innerOrderByType5 := v_tempDataType; 
				END IF; 
			END LOOP; 

			IF (v_innerOrderByCount > 0 ) THEN 
				v_counter := 5 - v_innerOrderByCount; 

				WHILE (v_counter > 0) LOOP 
					v_innerLastValueStr := v_innerLastValueStr ||  ', Null'; 
					v_counter := v_counter - 1; 
				END LOOP; 
			END IF; 		
			
			BEGIN 
				v_CursorLastValue := DBMS_SQL.OPEN_CURSOR; /* cursor id */ 
				
			/*	v_QuerySelectColumnStr := 'SELECT a.PROCESSINSTANCEID, a.WORKITEMID, ' || 
				' a.PARENTWORKITEMID, PROCESSNAME, PROCESSVERSION, PROCESSDEFID,  ' || 
				' LASTPROCESSEDBY, PROCESSEDBY, ACTIVITYNAME, ACTIVITYID, ENTRYDATETIME,  ' || 
				' ASSIGNMENTTYPE, COLLECTFLAG, PRIORITYLEVEL, VALIDTILL, Q_STREAMID, Q_QUEUEID,  ' || 
				' Q_USERID, ASSIGNEDUSER, FILTERVALUE, CREATEDDATETIME, WORKITEMSTATE, STATENAME,  ' || 
				' EXPECTEDWORKITEMDELAY, PREVIOUSSTAGE, LOCKEDBYNAME, LOCKSTATUS, LOCKEDTIME,  ' || 
				' QUEUENAME, QUEUETYPE, NOTIFYSTATUS, VAR_INT1, VAR_INT2, VAR_INT3, VAR_INT4,  ' || 
				' VAR_INT5, VAR_INT6, VAR_INT7, VAR_INT8, VAR_FLOAT1, VAR_FLOAT2, VAR_DATE1,  ' || 
				' VAR_DATE2, VAR_DATE3, VAR_DATE4, VAR_LONG1, VAR_LONG2, VAR_LONG3, VAR_LONG4,  ' || 
				' VAR_STR1, VAR_STR2, VAR_STR3, VAR_STR4, VAR_STR5, VAR_STR6, VAR_STR7, VAR_STR8,  ' || 
				' VAR_REC_1, VAR_REC_2, VAR_REC_3, VAR_REC_4, VAR_REC_5, INSTRUMENTSTATUS,  ' || 
				' CHECKLISTCOMPLETEFLAG, SAVESTAGE, HOLDSTATUS, STATUS, REFERREDTO, REFERREDTONAME,  ' || 
				' REFERREDBY, REFERREDBYNAME ,CHILDPROCESSINSTANCEID, CHILDWORKITEMID, CALENDARNAME'; */
				
				v_QuerySelectColumnStr := 'SELECT PROCESSINSTANCEID, WORKITEMID, ' || 
				' PARENTWORKITEMID, PROCESSNAME, PROCESSVERSION, PROCESSDEFID,  ' || 
				' LASTPROCESSEDBY, PROCESSEDBY, ACTIVITYNAME, ACTIVITYID, ENTRYDATETIME,  ' || 
				' ASSIGNMENTTYPE, COLLECTFLAG, PRIORITYLEVEL, VALIDTILL, Q_STREAMID, Q_QUEUEID,  ' || 
				' Q_USERID, ASSIGNEDUSER, FILTERVALUE, CREATEDDATETIME, WORKITEMSTATE, STATENAME,  ' || 
				' EXPECTEDWORKITEMDELAY, PREVIOUSSTAGE, LOCKEDBYNAME, LOCKSTATUS, LOCKEDTIME,  ' || 
				' QUEUENAME, QUEUETYPE, NOTIFYSTATUS, VAR_INT1, VAR_INT2, VAR_INT3, VAR_INT4,  ' || 
				' VAR_INT5, VAR_INT6, VAR_INT7, VAR_INT8, VAR_FLOAT1, VAR_FLOAT2, VAR_DATE1,  ' || 
				' VAR_DATE2, VAR_DATE3, VAR_DATE4,VAR_DATE5, VAR_DATE6, VAR_LONG1, VAR_LONG2, VAR_LONG3, VAR_LONG4,VAR_LONG5, VAR_LONG6,  ' || 
				' VAR_STR1, VAR_STR2, VAR_STR3, VAR_STR4, VAR_STR5, VAR_STR6, VAR_STR7, VAR_STR8,VAR_STR9, VAR_STR10, VAR_STR11, VAR_STR12, VAR_STR13, '||
				' VAR_STR14,VAR_STR15, VAR_STR16, VAR_STR17, VAR_STR18,VAR_STR19, VAR_STR20,  ' || 
				' VAR_REC_1, VAR_REC_2, VAR_REC_3, VAR_REC_4, VAR_REC_5, INSTRUMENTSTATUS,  ' || 
				' CHECKLISTCOMPLETEFLAG, SAVESTAGE, HOLDSTATUS, STATUS, REFERREDTO, REFERREDTONAME,  ' || 
				' REFERREDBY, REFERREDBYNAME ,CHILDPROCESSINSTANCEID, CHILDWORKITEMID, CALENDARNAME,ACTIVITYTYPE,URN,SECONDARYDBFLAG';
				
			/*	v_QDTJoinConditionStr := 'JOIN QUEUEDATATABLE on (QueueDataTable.ProcessInstanceId =  ' || 
				' a.ProcessInstanceId AND QueueDataTable.WorkitemId = a.WorkitemId AND a.PROCESSINSTANCEID = ' || 
				v_quoteChar || in_lastProcessInstance || v_quoteChar || ' AND a.WORKITEMID = ' || 
				in_lastWorkItem || ')'; */
				v_QDTWhereConditionStr := ' Where PROCESSINSTANCEID = ' || 
				v_quoteChar || in_lastProcessInstance || v_quoteChar || ' AND WORKITEMID = ' || 
				in_lastWorkItem || ' AND RoutingStatus in ( ' || v_quoteChar || 'N'|| v_quoteChar || ' , '|| v_quoteChar || 'R'|| v_quoteChar ||')'  ;
				
			/*	v_QueryStr := 'SELECT ' ||  v_innerLastValueStr || 
					' FROM ((select b.* ' || v_AliasStr || ' from ( ' || v_QuerySelectColumnStr || 
					' from WORKLISTTABLE a ' || v_QDTJoinConditionStr || ' ) b ' || 
					v_ExtTable_BTable_JoinStr || ' ) UNION ALL (select b.* ' || v_AliasStr || 
					' from ( ' || v_QuerySelectColumnStr || ' from WORKINPROCESSTABLE  a ' || 
					v_QDTJoinConditionStr || ' ) b ' || v_ExtTable_BTable_JoinStr || 
					' ) UNION ALL (select b.* ' || v_AliasStr || ' from ( ' || v_QuerySelectColumnStr || 
					' from PENDINGWORKLISTTABLE a ' || v_QDTJoinConditionStr || ') b ' || 
					v_ExtTable_BTable_JoinStr || ' ))';  */
					
				v_QueryStr := 'SELECT ' ||  v_innerLastValueStr || 
					' FROM (select b.* ' || v_AliasStr || ' from ( ' || v_QuerySelectColumnStr || 
					' from WFInstrumentTable ' || v_QDTWhereConditionStr || ' ) b ' || 
					v_ExtTable_BTable_JoinStr || ' )';
--Debugging over query result for field value of innerOrderBy					
				
				DBMS_SQL.PARSE(v_CursorLastValue, TO_CHAR(v_QueryStr), DBMS_SQL.NATIVE); 
				DBMS_SQL.DEFINE_COLUMN(v_CursorLastValue, 1 , v_innerOrderByVal1, 256); 
				DBMS_SQL.DEFINE_COLUMN(v_CursorLastValue, 2 , v_innerOrderByVal2, 256); 
				DBMS_SQL.DEFINE_COLUMN(v_CursorLastValue, 3 , v_innerOrderByVal3, 256); 
				DBMS_SQL.DEFINE_COLUMN(v_CursorLastValue, 4 , v_innerOrderByVal4, 256); 
				DBMS_SQL.DEFINE_COLUMN(v_CursorLastValue, 5 , v_innerOrderByVal5, 256); 

				v_retval := DBMS_SQL.EXECUTE(v_CursorLastValue); 

				/* Fetch next row and close cursor in case of error */ 
				v_DBStatus := DBMS_SQL.FETCH_ROWS(v_CursorLastValue); 
				v_counter := 0; 
				WHILE (v_DBStatus <> 0) LOOP 
				BEGIN 
					DBMS_SQL.COLUMN_VALUE(v_CursorLastValue, 1, v_innerOrderByVal1);  
					DBMS_SQL.COLUMN_VALUE(v_CursorLastValue, 2, v_innerOrderByVal2);  
					DBMS_SQL.COLUMN_VALUE(v_CursorLastValue, 3, v_innerOrderByVal3); 
					DBMS_SQL.COLUMN_VALUE(v_CursorLastValue, 4, v_innerOrderByVal4); 
					DBMS_SQL.COLUMN_VALUE(v_CursorLastValue, 5, v_innerOrderByVal5); 

					v_DBStatus := DBMS_SQL.fetch_rows(v_CursorLastValue); 
					v_innerOrderByVal1:=REPLACE(v_innerOrderByVal1,v_quoteChar,v_quoteChar||v_quoteChar);
					v_innerOrderByVal2:=REPLACE(v_innerOrderByVal2,v_quoteChar,v_quoteChar||v_quoteChar);
					v_innerOrderByVal3:=REPLACE(v_innerOrderByVal3,v_quoteChar,v_quoteChar||v_quoteChar);
				END; 
				END LOOP; 
				/* Close the cursor */ 
				dbms_sql.close_cursor(v_CursorLastValue); 
			EXCEPTION 
				WHEN NO_DATA_FOUND THEN 
					out_mainCode := 1; 
					RETURN; 
			END; 

			v_counter := 0; 
			v_counterCondition := 0; 
			v_lastValueStr := ' AND ( '; 
			WHILE (v_counter < v_innerOrderByCount + 1 ) LOOP 
				v_counter1 := 0; 
				v_TemplastValueStr := NULL; 
				WHILE (v_counter1 <= v_counter) LOOP 
					IF (v_counter1 = 0) THEN 
						v_TempColumnName := v_innerOrderByCol1; 
						v_TempSortOrder := v_innerOrderBySort1; 
						v_TempColumnVal := v_innerOrderByVal1; 
						v_tempDataType := v_innerOrderByType1; 
					ELSIF (v_counter1 = 1) THEN 
						v_TempColumnName := v_innerOrderByCol2; 
						v_TempSortOrder := v_innerOrderBySort2; 
						v_TempColumnVal := v_innerOrderByVal2; 
						v_tempDataType := v_innerOrderByType2; 
					ELSIF (v_counter1 = 2) THEN 
						v_TempColumnName := v_innerOrderByCol3; 
						v_TempSortOrder := v_innerOrderBySort3; 
						v_TempColumnVal := v_innerOrderByVal3; 
						v_tempDataType := v_innerOrderByType3; 
					ELSIF (v_counter1 = 3) THEN 
						v_TempColumnName := v_innerOrderByCol4; 
						v_TempSortOrder := v_innerOrderBySort4; 
						v_TempColumnVal := v_innerOrderByVal4; 
						v_tempDataType := v_innerOrderByType4; 
					ELSIF (v_counter1 = 4) THEN 
						v_TempColumnName := v_innerOrderByCol5; 
						v_TempSortOrder := v_innerOrderBySort5; 
						v_TempColumnVal := v_innerOrderByVal5; 
						v_tempDataType := v_innerOrderByType5; 
					END IF; 

					IF (v_counter = v_innerOrderByCount ) THEN 
						IF (v_counter1 < v_counter) THEN 
							IF (v_TempColumnVal IS NULL) THEN 
								v_TemplastValueStr := v_TemplastValueStr || v_TempColumnName || ' IS NULL '; 
							ELSE 
								IF (v_tempDataType = 'DATE') THEN 
									v_TemplastValueStr := v_TemplastValueStr || v_TempColumnName || ' = ' || ' TO_DATE(' || v_quoteChar || SUBSTR(v_TempColumnVal, 1, 19) || v_quoteChar || ' , ' || v_quoteChar || v_DATEFMT || v_quoteChar || ') ' ; 
								ELSE 
									v_TemplastValueStr := v_TemplastValueStr || v_TempColumnName || ' = ' || v_quoteChar || v_TempColumnVal || v_quoteChar; 
								END IF; 
							END IF; 
							v_TemplastValueStr := v_TemplastValueStr || ' AND '; 
						END IF; 
					ELSE  
						IF (v_counter1 = v_counter) THEN 
							IF (v_TempSortOrder = 'ASC') THEN 
								IF (v_TempColumnVal IS NOT NULL) THEN 
									v_TemplastValueStr := v_TemplastValueStr || ' ( '; 
									IF (v_tempDataType = 'DATE') THEN 
										v_TemplastValueStr := v_TemplastValueStr || v_TempColumnName || ' > ' || ' TO_DATE(' || v_quoteChar || SUBSTR(v_TempColumnVal, 1, 19) || v_quoteChar || ' , ' || v_quoteChar || v_DATEFMT || v_quoteChar || ') ' ; 
									ELSE 
										v_TemplastValueStr := v_TemplastValueStr || v_TempColumnName || ' > ' || v_quoteChar || v_TempColumnVal || v_quoteChar; 
									END IF; 
									v_TemplastValueStr := v_TemplastValueStr || ' OR ' || v_TempColumnName || ' IS NULL )'; 
								ELSE 
									v_TemplastValueStr := NULL; 
								END IF; 
							ELSE 
								IF (v_TempColumnVal IS NOT NULL) THEN 
									IF (v_tempDataType = 'DATE') THEN 
										v_TemplastValueStr := v_TemplastValueStr || v_TempColumnName || ' < ' || ' TO_DATE(' || v_quoteChar || SUBSTR(v_TempColumnVal, 1, 19) || v_quoteChar || ' , ' || v_quoteChar || v_DATEFMT || v_quoteChar || ') ' ; 
									ELSE 
										v_TemplastValueStr := v_TemplastValueStr || v_TempColumnName || ' < ' || v_quoteChar || v_TempColumnVal || v_quoteChar; 
									END IF; 
								ELSE 
									v_TemplastValueStr := v_TemplastValueStr || v_TempColumnName || ' IS NOT NULL '; 
								END IF;	
							END IF; 
						ELSE 
							IF (v_TempColumnVal IS NOT NULL) THEN 
								IF (v_tempDataType = 'DATE') THEN 
									v_TemplastValueStr := v_TemplastValueStr || v_TempColumnName || ' = ' || ' TO_DATE(' || v_quoteChar || SUBSTR(v_TempColumnVal, 1, 19) || v_quoteChar || ' , ' || v_quoteChar || v_DATEFMT || v_quoteChar || ') ' ; 
								ELSE 
									v_TemplastValueStr := v_TemplastValueStr || v_TempColumnName || ' = ' || v_quoteChar || v_TempColumnVal || v_quoteChar; 
								END IF; 
							ELSE 
								v_TemplastValueStr := v_TemplastValueStr || v_TempColumnName || ' IS NULL '; 
							END IF; 

							v_TemplastValueStr := v_TemplastValueStr || ' AND '; 
						END IF; 
					END IF; 
					v_counter1 := v_counter1 + 1; 
				END LOOP; 

				IF (v_TemplastValueStr IS NOT NULL) THEN 
					IF (v_counterCondition > 0) THEN 
						v_lastValueStr := v_lastValueStr || ' OR ( '; 
					END IF; 
					v_lastValueStr := v_lastValueStr || v_TemplastValueStr; 
					IF (v_counterCondition > 0 AND v_counter < v_innerOrderByCount ) THEN 
						v_lastValueStr := v_lastValueStr || ' )'; 
					END IF; 
					v_counterCondition := v_counterCondition + 1; 
				END IF; 
				v_counter := v_counter + 1; 
			END LOOP; 

			v_lastValueStr := v_lastValueStr || ' (  ( Processinstanceid = ' || v_quoteChar || in_lastProcessInstance || v_quoteChar; 
			v_lastValueStr := v_lastValueStr || ' AND  WorkItemId ' || v_op || in_lastWorkItem || ' )'; 
			v_lastValueStr := v_lastValueStr || ' OR Processinstanceid' || v_op || v_quoteChar || in_lastProcessInstance || v_quoteChar; 
			v_lastValueStr := v_lastValueStr || ' ) )'; 

			IF ( v_counterCondition > 1 ) THEN 
				v_lastValueStr := v_lastValueStr || ' )'; 
			END IF; 

		END IF; 

	END IF; 

	DELETE FROM GTempWorkListTable; 

	IF(in_StartingRecNo = 0) THEN		
		v_RowIdQuery := '';
	ELSE		
		v_RowIdQuery := ' AND row_id > ' || in_StartingRecNo;
	END IF;		

	v_WLTColStr := 	' ProcessInstanceId, ProcessInstanceId as ProcessInstanceName,' || 
		' ProcessDefId, ProcessName, ActivityId, ActivityName, PriorityLevel, InstrumentStatus,' ||  
		' LockStatus, LockedByName, ValidTill, CreatedByName, CreatedDateTime, Statename,' || 
		' CheckListCompleteFlag, EntryDateTime, LockedTime, IntroductionDateTime, IntroducedBy, AssignedUser,' || 
		' WorkItemId, QueueName, AssignmentType, ProcessInstanceState, QueueType, Status, Q_QueueID,' || 
		' ReferredByname, ReferredTo, Q_UserID,' || 
		' FILTERVALUE, Q_StreamId, CollectFlag, ParentWorkItemId, ProcessedBy, LastProcessedBy,' || 
		' ProcessVersion, WORKITEMSTATE, PREVIOUSSTAGE, ExpectedWorkItemDelay, ProcessVariantId, Q_DivertedByUserId,ActivityType,URN,SECONDARYDBFLAG,calendarName'; /*Process Variant Support*/

	v_WLTColStr1 := ' ProcessInstanceId, ' || 
		' ProcessDefId, ProcessName, ActivityId, ActivityName, PriorityLevel, InstrumentStatus,' || 
		' LockStatus, LockedByName, ValidTill, CreatedByName, CreatedDateTime, Statename,' || 
		' CheckListCompleteFlag, EntryDateTime, LockedTime, IntroductionDateTime, IntroducedBy, AssignedUser,' || 
		' WorkItemId, QueueName, AssignmentType, ProcessInstanceState, QueueType, Status, Q_QueueID,' || 
		' ReferredByname, ReferredTo, Q_UserID,' || 
		' FILTERVALUE, Q_StreamId, CollectFlag, ParentWorkItemId, ProcessedBy, LastProcessedBy,' || 
		' ProcessVersion, WORKITEMSTATE, PREVIOUSSTAGE, ExpectedWorkItemDelay, ProcessVariantId, Q_DivertedByUserId,ActivityType,URN,SECONDARYDBFLAG,calendarName'; /*Process Variant Support*/

	v_QDTColStr :=	', VAR_INT1, VAR_INT2, VAR_INT3, VAR_INT4, VAR_INT5, VAR_INT6, VAR_INT7, VAR_INT8,' || 
		' VAR_FLOAT1, VAR_FLOAT2, VAR_DATE1, VAR_DATE2, VAR_DATE3, VAR_DATE4,VAR_DATE5, VAR_DATE6,' || 
		' VAR_LONG1, VAR_LONG2, VAR_LONG3, VAR_LONG4,VAR_LONG5, VAR_LONG6,'|| 
		' VAR_STR1, VAR_STR2, VAR_STR3, VAR_STR4, VAR_STR5, VAR_STR6, VAR_STR7, VAR_STR8, VAR_STR9, VAR_STR10, VAR_STR11, VAR_STR12, VAR_STR13, VAR_STR14,VAR_STR15, VAR_STR16, VAR_STR17, VAR_STR18,VAR_STR19, VAR_STR20,VAR_REC_1, VAR_REC_2'; 

	--IF ( (v_queryFilter IS NULL) AND (v_filterStr IS NULL) AND (in_userFilterStr IS NULL) AND (v_lastValueStr IS NULL) ) THEN 
		v_Suffix := ' WHERE ROWNUM <= ' || (in_batchSize + 1); 
	--END IF; 

	/* Bugzilla Bug 1703 */
	v_noOfCounters := 1;
	IF (DBqueueId = 0) THEN 
	--v_tableNameFilter:= ' WHERE RoutingStatus in ( '|| v_quoteChar || 'N'|| v_quoteChar||' , '|| v_quoteChar || 'R'|| v_quoteChar||') ';
	v_tableNameFilter:= ' ';
		/*v_noOfCounters := 3; */
	ELSIF (in_fetchLockedFlag = N'Y') THEN
		/* v_noOfCounters := 2; */
		-- v_tableNameFilter:= ' WHERE RoutingStatus =' || v_quoteChar || 'N'|| v_quoteChar;
		v_tableNameFilter:= ' ';
	ELSE	
		v_tableNameFilter:= ' WHERE LockStatus = ' || v_quoteChar || 'N'|| v_quoteChar;
	END IF;
	
	v_noOfCounters:=1;
/*	IF (v_noOfCounters > 1) THEN */
		v_Counter := 0;
	--	WHILE (v_Counter < v_noOfCounters) LOOP /* Bugzilla Bug 1703 */

			/*v_QueryStr := 'SELECT ' || v_WLTColStr1 || v_QDTColStr || ' ,row_id FROM (' || 
				' SELECT row_number() over ( ' || v_orderByStr || ' ) as row_id, FetchRecords.* FROM (SELECT ' || v_WLTColStr || v_QDTColStr || v_AliasStr || 
				' FROM ' || v_tableName || ' Worklisttable, ProcessInstanceTable, QueueDatatable' || v_ExtTable_QDTable_JoinStr || 
				' WHERE QueueDatatable.ProcessInstanceId = ProcessInstanceTable.ProcessInstanceId' || 
				' AND WorklistTable.ProcessInstanceId = QueueDatatable.ProcessInstanceId' || 
				' AND WorklistTable.Workitemid =QueueDatatable.Workitemid' || 
				' ) FetchRecords WHERE ' || v_queueFilterStr || v_ProcessFilter
				|| in_userFilterStr || v_filterStr || v_queryFilter || v_lastValueStr 
				|| ')' || v_Suffix || v_RowIdQuery; */

			/*v_QueryStr := 'SELECT ' || v_WLTColStr1 || v_QDTColStr || ' ,row_id FROM (' || 
				' SELECT row_number() over ( ' || v_orderByStr || ' ) as row_id, FetchRecords.* FROM (SELECT ' || v_WLTColStr || v_QDTColStr || v_AliasStr || 
				' FROM  WFInstrumentTable ' || v_ExtTable_QDTable_JoinStr || v_tableNameFilter|| ' ) FetchRecords WHERE ' || v_queueFilterStr || v_ProcessFilter
				|| in_userFilterStr || v_filterStr || v_queryFilter || v_lastValueStr 
				|| ')' || v_Suffix || v_RowIdQuery; */
				/* GtempWorklist removed*/
			v_queryStr := 'SELECT /*+FIRST_ROWS(100)*/  ProcessInstanceId, ProcessInstanceId as ProcessInstanceName,' || 
				' ProcessDefId, ProcessName, ActivityId, ActivityName, PriorityLevel, InstrumentStatus,' || 
				' LockStatus, LockedByName, ValidTill, CreatedByName, CreatedDateTime, Statename,' || 
				' CheckListCompleteFlag, EntryDateTime, LockedTime, IntroductionDateTime, IntroducedBy, AssignedUser,' || 
				' WorkItemId, QueueName, AssignmentType, ProcessInstanceState, QueueType, Status, Q_QueueID,' || 
				' null as TurnaroundTime ,ReferredByname, ReferredTo as ReferTo, ExpectedWorkItemDelay, ProcessVariantId, ProcessedBy, Q_DivertedByUserId,ActivityType,URN,SECONDARYDBFLAG,calendarName' || v_ExtAlias;
			IF (in_pagingFlag = N'Y') THEN
				v_QueryStr := v_QueryStr || ' ,row_id';
			END IF;	
            v_QueryStr := v_QueryStr ||'       FROM ( ';
			v_QueryStr := v_QueryStr ||'SELECT ' || v_WLTColStr1 || v_QDTColStr || v_ExtAlias ;
			IF (in_pagingFlag = N'Y') THEN
				v_QueryStr := v_QueryStr || ' ,row_id';
			END IF;	
			v_QueryStr := v_QueryStr ||' FROM ( SELECT ' ;
			IF(in_pagingFlag = N'Y') THEN
				v_QueryStr := v_QueryStr || ' row_number() over ( ' || v_orderByStr || ' ) as row_id,';
			END IF;
			v_QueryStr := v_QueryStr || ' FetchRecords.* FROM (SELECT ' || v_WLTColStr || v_QDTColStr || v_AliasStr || 
							' FROM  WFInstrumentTable ' || v_ExtTable_QDTable_JoinStr || v_tableNameFilter|| ' ) FetchRecords WHERE ' || v_queueFilterStr || v_ProcessFilter
							|| in_userFilterStr || v_filterStr || v_queryFilter || v_lastValueStr ;
			
			/*Bugfix#73508 Sorting not working on Registration no.
			IF(in_pagingFlag <> N'Y') THEN		
				v_QueryStr := v_QueryStr || v_orderByStr;
			END IF;
			*/
			v_QueryStr := v_QueryStr || v_orderByStr;
			v_QueryStr := v_QueryStr || ')' || v_Suffix || v_RowIdQuery || ')';	
			
			
			/*OPEN v_CursorWLTable FOR v_QueryStr; 

			v_counter1 := 0; 
			LOOP 
				IF(in_pagingFlag = N'Y') THEN
					FETCH v_CursorWLTable INTO v_ProcessInstanceId, v_ProcessdefId, v_ProcessName, v_ActivityId, v_ActivityName, 
						v_PriorityLevel, v_InstrumentStatus, v_LockStatus, v_LockedByName, v_ValidTill, v_CreatedByName, 
						v_CreatedDateTime, v_StateName, v_CheckListCompleteFlag, v_EntryDateTime, v_LockedTime, 
						v_IntroductionDateTime, v_IntroducedBy, v_AssignedUser, v_WorkitemId, v_QueueName, v_AssignmentType, 
						v_ProcessInstanceState, v_QueueType, v_Status, v_Q_QueueId, v_ReferredByName, v_ReferredTo, v_Q_UserId, 
						v_FilterValue, v_Q_StreamId, v_Collectflag, v_ParentWorkitemId, v_ProcessedBy, v_LastProcessedBy, 
						v_ProcessVersion, v_WorkItemState, v_PreviousStage, v_ExpectedWorkItemDelay, v_ProcessVariantId, v_VAR_INT1, v_VAR_INT2, 
						v_VAR_INT3, v_VAR_INT4, v_VAR_INT5, v_VAR_INT6, v_VAR_INT7, v_VAR_INT8, v_VAR_FLOAT1, v_VAR_FLOAT2, 
						v_VAR_DATE1, v_VAR_DATE2 ,v_VAR_DATE3, v_VAR_DATE4, v_VAR_LONG1, v_VAR_LONG2, v_VAR_LONG3, v_VAR_LONG4, 
						v_VAR_STR1, v_VAR_STR2, v_VAR_STR3, v_VAR_STR4, v_VAR_STR5, v_VAR_STR6, v_VAR_STR7, v_VAR_STR8, v_VAR_REC1, v_VAR_REC2, v_RowId; /*Process Variant Support* /
				ELSE
					FETCH v_CursorWLTable INTO v_ProcessInstanceId, v_ProcessdefId, v_ProcessName, v_ActivityId, v_ActivityName, 
						v_PriorityLevel, v_InstrumentStatus, v_LockStatus, v_LockedByName, v_ValidTill, v_CreatedByName, 
						v_CreatedDateTime, v_StateName, v_CheckListCompleteFlag, v_EntryDateTime, v_LockedTime, 
						v_IntroductionDateTime, v_IntroducedBy, v_AssignedUser, v_WorkitemId, v_QueueName, v_AssignmentType, 
						v_ProcessInstanceState, v_QueueType, v_Status, v_Q_QueueId, v_ReferredByName, v_ReferredTo, v_Q_UserId, 
						v_FilterValue, v_Q_StreamId, v_Collectflag, v_ParentWorkitemId, v_ProcessedBy, v_LastProcessedBy, 
						v_ProcessVersion, v_WorkItemState, v_PreviousStage, v_ExpectedWorkItemDelay, v_ProcessVariantId, v_VAR_INT1, v_VAR_INT2, 
						v_VAR_INT3, v_VAR_INT4, v_VAR_INT5, v_VAR_INT6, v_VAR_INT7, v_VAR_INT8, v_VAR_FLOAT1, v_VAR_FLOAT2, 
						v_VAR_DATE1, v_VAR_DATE2 ,v_VAR_DATE3, v_VAR_DATE4, v_VAR_LONG1, v_VAR_LONG2, v_VAR_LONG3, v_VAR_LONG4, 
						v_VAR_STR1, v_VAR_STR2, v_VAR_STR3, v_VAR_STR4, v_VAR_STR5, v_VAR_STR6, v_VAR_STR7, v_VAR_STR8, v_VAR_REC1, v_VAR_REC2; /*Process Variant Support* /
				END IF;	
				EXIT WHEN v_CursorWLTable%NOTFOUND; 
				IF (v_counter1 <= in_batchSize + 1) THEN 
				
/*Process Variant Support* /
					INSERT INTO GTempWorkListTable(PROCESSINSTANCEID, PROCESSDEFID, PROCESSNAME, ACTIVITYID, ACTIVITYNAME, 
						PRIORITYLEVEL, INSTRUMENTSTATUS, LOCKSTATUS, LOCKEDBYNAME, VALIDTILL, 
						CREATEDBYNAME, CREATEDDATETIME, STATENAME, CHECKLISTCOMPLETEFLAG, 
						ENTRYDATETIME, LOCKEDTIME, INTRODUCTIONDATETIME, INTRODUCEDBY, ASSIGNEDUSER, 
						WORKITEMID, QUEUENAME, ASSIGNMENTTYPE, PROCESSINSTANCESTATE, QUEUETYPE, 
						STATUS, Q_QUEUEID, REFERREDBYNAME, REFERREDTO, Q_USERID, FILTERVALUE, 
						Q_STREAMID, COLLECTFLAG, PARENTWORKITEMID, PROCESSEDBY, LASTPROCESSEDBY, 
						PROCESSVERSION, WORKITEMSTATE, PREVIOUSSTAGE, EXPECTEDWORKITEMDELAY, PROCESSVARIANTID,
						VAR_INT1, VAR_INT2, VAR_INT3, VAR_INT4, VAR_INT5, VAR_INT6, VAR_INT7, VAR_INT8, 
						VAR_FLOAT1, VAR_FLOAT2, VAR_DATE1, VAR_DATE2, VAR_DATE3, VAR_DATE4, 
						VAR_LONG1, VAR_LONG2, VAR_LONG3, VAR_LONG4, 
						VAR_STR1, VAR_STR2, VAR_STR3, VAR_STR4, VAR_STR5, VAR_STR6, VAR_STR7, VAR_STR8, VAR_REC_1, VAR_REC_2) 
					VALUES (v_ProcessInstanceId, v_ProcessdefId, v_ProcessName, v_ActivityId, v_ActivityName, 
						v_PriorityLevel, v_InstrumentStatus, v_LockStatus, v_LockedByName, v_ValidTill, v_CreatedByName, 
						v_CreatedDateTime, v_StateName, v_CheckListCompleteFlag, v_EntryDateTime, v_LockedTime, 
						v_IntroductionDateTime, v_IntroducedBy, v_AssignedUser, v_WorkitemId, v_QueueName, v_AssignmentType, 
						v_ProcessInstanceState, v_QueueType, v_Status, v_Q_QueueId, v_ReferredByName, v_ReferredTo, v_Q_UserId, 
						v_FilterValue, v_Q_StreamId, v_Collectflag, v_ParentWorkitemId, v_ProcessedBy, v_LastProcessedBy, 
						v_ProcessVersion, v_WorkItemState, v_PreviousStage, v_ExpectedWorkItemDelay,v_ProcessVariantId, v_VAR_INT1, v_VAR_INT2, 
						v_VAR_INT3, v_VAR_INT4, v_VAR_INT5, v_VAR_INT6, v_VAR_INT7, v_VAR_INT8, v_VAR_FLOAT1, v_VAR_FLOAT2, 
						v_VAR_DATE1, v_VAR_DATE2 ,v_VAR_DATE3, v_VAR_DATE4, v_VAR_LONG1, v_VAR_LONG2, v_VAR_LONG3, v_VAR_LONG4, 
						v_VAR_STR1, v_VAR_STR2, v_VAR_STR3, v_VAR_STR4, v_VAR_STR5, v_VAR_STR6, v_VAR_STR7, v_VAR_STR8, v_VAR_REC1, v_VAR_REC2); 
					v_counter1 := v_counter1 + 1; 
					
				ELSE 
					EXIT; 
				END IF; 
			END LOOP; 
			CLOSE v_CursorWLTable; */
			
		--	v_Counter := v_Counter + 1;
	--	END LOOP; 
				/*Process Variant Support* /
		v_queryStr := 'SELECT ProcessInstanceId, ProcessInstanceId as ProcessInstanceName,' || 
				' ProcessDefId, ProcessName, ActivityId, ActivityName, PriorityLevel, InstrumentStatus,' || 
				' LockStatus, LockedByName, ValidTill, CreatedByName, CreatedDateTime, Statename,' || 
				' CheckListCompleteFlag, EntryDateTime, LockedTime, IntroductionDateTime, IntroducedBy, AssignedUser,' || 
				' WorkItemId, QueueName, AssignmentType, ProcessInstanceState, QueueType, Status, Q_QueueID,' || 
				' null as TurnaroundTime ,ReferredByname, ReferredTo as ReferTo, ExpectedWorkItemDelay, ProcessVariantId, ProcessedBy' || v_ExtAlias || ',0 rowid'||
			      ' FROM ( SELECT GTempWorkListTable.*' || v_AliasStr || ' FROM GTempWorkListTable ' || v_ExtTable_TmpWLTable_JoinStr || v_orderByStr || ')' || 
			      'WHERE ROWNUM <= ' || (in_batchSize + 1); 
/*	ELSE
/*Process Variant Support
		v_queryStr := 'SELECT ProcessInstanceId, ProcessInstanceId as ProcessInstanceName,' || 
				' ProcessDefId, ProcessName, ActivityId, ActivityName, PriorityLevel, InstrumentStatus,' || 
				' LockStatus, LockedByName, ValidTill, CreatedByName, CreatedDateTime, Statename,' || 
				' CheckListCompleteFlag, EntryDateTime, LockedTime, IntroductionDateTime, IntroducedBy, AssignedUser,' || 
				' WorkItemId, QueueName, AssignmentType, ProcessInstanceState, QueueType, Status, Q_QueueID,' || 
				' null as TurnaroundTime ,ReferredByname, ReferredTo as ReferTo, ExpectedWorkItemDelay, ProcessVariantId, ProcessedBy' || v_ExtAlias || 
			      ' , row_id FROM ( SELECT row_number() over ( ' || v_orderByStr || ' ) as row_id, FetchRecords.* FROM (SELECT ' || v_WLTColStr || v_QDTColStr || v_AliasStr || 
				' FROM WFInstrumentTable ' || v_ExtTable_QDTable_JoinStr ||  
				' WHERE RoutingStatus = '|| v_quoteChar || 'N'|| v_quoteChar||' and LockStatus = '|| v_quoteChar || 'N'|| v_quoteChar ||  
				' ) FetchRecords WHERE ' || v_queueFilterStr || in_userFilterStr || v_filterStr || v_queryFilter || v_lastValueStr || ')' || 
			      'WHERE ROWNUM <= ' || (in_batchSize + 1) || v_RowIdQuery; 		
	END IF; 
	
*/
	IF (in_returnParam > 0) THEN 
		v_Counter := 0;
		v_noOfCounters:=1;
		WHILE (v_Counter < v_noOfCounters) LOOP /* Bugzilla Bug 1703 */
		/*	IF (v_Counter = 0) THEN
				/* v_tableName := 'WorkListTable'; 
			v_tableNameFilter := ' WHERE RoutingStatus = '|| v_quoteChar || 'N'|| v_quoteChar||' and LockStatus = '|| v_quoteChar || 'N'|| v_quoteChar;

			ELSIF (v_Counter = 1) THEN
			/*	v_tableName := 'WorkInProcessTable'; 
			v_tableNameFilter := ' WHERE RoutingStatus = '|| v_quoteChar || 'N'|| v_quoteChar||' and LockStatus = '|| v_quoteChar || 'Y'|| v_quoteChar;

			ELSIF (v_Counter = 2) THEN
			v_tableNameFilter := ' WHERE RoutingStatus = '|| v_quoteChar || 'R'|| v_quoteChar;
			END IF;
			*/

			v_CountStr := 'SELECT COUNT(1) FROM (' || 
				' SELECT * FROM (SELECT ' || v_WLTColStr || v_QDTColStr || v_AliasStr || 
				' FROM  WFInstrumentTable ' || v_ExtTable_QDTable_JoinStr || 
				' '|| v_tableNameFilter || 
				'  ) WHERE ' || v_queueFilterStr || in_userFilterStr || v_filterStr || v_queryFilter || ')' ; 
		
			--EXECUTE IMMEDIATE v_CountStr INTO v_tempCount;
			IF (DBqueueId = 0) THEN
				BEGIN
					EXECUTE IMMEDIATE v_CountStr INTO v_tempCount;
				END;	
			ELSE
				BEGIN
					EXECUTE IMMEDIATE v_CountStr INTO v_tempCount using DBqueueId;
				END;
			END IF;	

			out_returnCount := out_returnCount + v_tempCount;
			
			v_Counter := v_Counter + 1;
		END LOOP; 
	END IF;

	IF (in_returnParam = 0 OR  in_returnParam = 2) THEN 

		--OPEN RefCursor FOR v_queryStr; 
		IF (DBqueueId = 0  OR v_QueueType = v_SearchQueueType) THEN
			OPEN RefCursor FOR v_queryStr;
		ELSE 
			OPEN RefCursor FOR v_queryStr using DBqueueId; 
		END IF;
	END IF;
	
	RETURN; 
END; 

