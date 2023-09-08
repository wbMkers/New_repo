//---------------------------------- ------------------------------------------------------------------
//		NEWGEN SOFTWARE TECHNOLOGIES LIMITED
//	Group					: Application Products
//	Product / Project		: WorkFlow
//	Module					: Transaction Server
//	File Name				: WMWorkitem.java
//	Author					: Prashant
//	Date written (DD/MM/YYYY)	: 16/05/2002
//	Description				: This class implements the WAPI WorkList API
//----------------------------------------------------------------------------------------------------
//			CHANGE HISTORY
//----------------------------------------------------------------------------------------------------
// Date                 Change By           Change Description (Bug No. (If Any))
// (DD/MM/YYYY)
//----------------------------------------------------------------------------------------------------
// 01/10/2002           Prashant        Change in FetchWorkItem for QueueTypes
// 26/11/2002           Prashant        Bug No OF_BUG_18
// 23/01/2003           Prashant        Bug No TSR_3.0.1_002
// 27/01/2003           Prashant        Bug No WFL_2.0.5.014
// 05/03/2003           Prashant        New Calls WFReferWorkItem , WFWithdrawWorkitem
// 24/03/2003           Prashant        Bug No TSR_3.0.1_012
// 24/03/2003           Prashant        Bug No TSR_3.0.1_01825-Feb-04
// 31/05/2003           Prashant        Bug No TSR_3.0.2.0005
// 31/05/2003           Prashant        Bug No TSR_3.0.2.0007
// 31/05/2003           Prashant        Bug No TSR_3.0.2.0009
// 01/08/2003           Nitin           Bug No TSR_4.0.1_040
// 03/06/2004           Krishan         Bug No WSE_5.0.1_003
// 25/06/2004           Dinesh Parikh	Changes done in WMCompleteWorkItem for Refered workItem case.
//										( Need to write bug number here )
// 08/07/2004           Dinesh Parikh	WSE_I_5.0.1_696
// 16/07/2004           Ashish Mangla	Bug No WSE_5.0.1_beta_166
// 16/07/2004           Ashish Mangla	Bug No WSE_5.0.1_beta_231
// 08/09/2004           Krishan         New call added
// 30/09/2004           Ruhi Hira       Logic for FetchWorkItemWithLock moved to SP.
// 17/01/2005           Harmeet Kaur	Bug WFS_5.2.1_0005
// 30/03/2005           Ashish Mangla	Items getting stuck in 'MyQueue' even if Save is 'No' while closing the workitem in dynamic queue.
// 07/04/2005           Ruhi Hira       Bug # WFS_6_002.
// 09/04/2005           Harmeet Kaur	WFS_6_004
// 13/04/2005           Ashish Mangla	WFS_6_008 In case when WI submitted with AssignMent Type E, it might be the case that the workitme is original workitem, so do not try to get the parent workitem in such case...
// 09/06/2005           Dinesh Parikh	Bug No WFS_6_024 Batching not working in case of Sorting on Aliases.
// 20/08/2005           Ashish Mangla	SRNo-1 (Queue Association filter on Queue asprovided in 3.1.5 sp10 patch)
// 03/11/2005           Harmeet Kaur	Bug No WFS_6_031 - Support for Oracle in WFFetchWorkitemsWithLock
// 03/01/2006           Mandeep Kaur	SRNo-2 (Query WorkStep)
// 24/01/2006           Ashish Mangla	Bug No. WFS_6_036 - clear Q_UserId in N type queue also.
// 02/02/2006           Ashish Mangla	Bug No. WFS_6_037 - Support for batching on queuefilter with order by
// 15/02/2006           Ashish Mangla	WFS_6.1.2_049 (Changed WMUser.WFCheckSession by WFSUtil.WFCheckSession)
// 15/05/2006           Ahsan Javed     WFS_5_106 (New API exposed for fetching workitem count)
// 15/05/2006           Ahsan Javed     WFS_5_088 (Transaction in Complete WI)
// 27/06/2006           Ashish Mangla	Bugzilla Id 47 - RTrim( ? )
// 11/08/2006           Ruhi Hira       Bugzilla Id 61.
// 18/08/2006           Ruhi Hira       Bugzilla Id 54.
// 09/01/2007           Ashish Mangla   Bugzilla Bug 41 - Support for DB2 in WFFetchWorkitemsWithLock
// 17/01/2007           Varun Bhansaly  Bugzilla Id 54 (Provide Dirty Read Support for DB2 Database)
// 27/04/2007           Shilpi S        new method named WFGetWorkitemDataExt , for singlecall support , is added
// 03/05/2007           Ashish Mangla	Bugzilla Bug 637 - While Referring WorkItem do not change the original AssignmentType
// 07/05/2007           Varun Bhansaly  WFS_5_137 (Mail to be sent in case of refered user in case of refer workitem.)
// 16/05/2007           Varun Bhansaly  WFFetchWorkItems, rs & cstmt closed in finally, batch size
//										cannot be greater than the entry in server.xml
// 16/05/2007           Shilpi S        changes in WFGetWorkitemDataExt (remove check of no authorization )
// 22/05/2007           Ruhi Hira       Bugzilla Bug 885.
// 19/06/2007           Ruhi Hira       Bugzilla Bug 1175.
// 19/07/2007           Varun Bhansaly  Bugzilla Id 1439 ([Jboss] [MSSQL] [omniflow 7.0 japanese] audit feature not working properly)
// 27/07/2007           Varun Bhansaly	Bugzilla Id 960 (repetation of queue variables in single call)
// 08/08/2007           Shilpi S        Bug # 1608
// 20/08/2007           Ruhi Hira       SrNo-3, Synchronous routing of workitems.
// 11/09/2007           Varun Bhansaly	SrNo-4, Comments support in Refer\ Reassign\ Audit Rejection\ WFGetWorkItemDataExt.
// 14/09/2007           Shilpi S        SrNo-5 , Omniflow7.1 feature, multiple exception raise and clear on activity
// 14/09/2007           Ruhi Hira       WFS_5_192, Duplicate workitem issue (Inherited from 5.0).
// 28/09/2007           Shilpi S        Bugzilla Bug 1680 (Support for count of WI in Queue considering on User Queue Assoc Filter)
// 28/09/2007           Ashish Mangla	Bugzilla Bug 1647 (In Refer WI query On QueueDataTable Not required)
// 28/09/2007           Ashish Mangla	Bugzilla Bug 1648 (User Diversion case not properly handled)
// 18/10/2007           Varun Bhansaly	SrNo-6, Use WFSUtil.printXXX instead of System.out.println()
//										System.err.println() & printStackTrace() for logging.
// 19/10/2007           Vikram Kumbhar	Bugzilla Bug 1703, Support for showing 'only unlocked' or 'both locked and unlocked' workitems in worklist
// 16/11/2007           Ruhi Hira       SrNo-7, Synchronous routing of workitems, Removal of WorkDoneTable.
// 16/11/2007           Tirupati Srivastava      changes in queries for PostgreSql dbase
// 19/11/2007           Varun Bhansaly	WFSUtil.readLargeString() should be avoided.
// 19/11/2007           Varun Bhansaly	WFSUtil.getBIGData() to be used instead of getCharacterStream()
// 29/11/2007           Varun Bhansaly	SrNo-8, APIs FetchWorkItem1, WFFetchWorkItemCount modified for PostgreSQL
// 12/12/2007           Ashish Mangla	Bugzilla Bug 1917 (UserName fetched from resultset without selecting this column gives xception)
// 17/12/2007           Varun Bhansaly	API WFGetWorkItemDataExt() modified to open WIs in PostgreSQL.
// 21/12/2007           Ashish Mangla	Bugzilla Bug 1765 (if lastvlaue is null use set Null method instead of set string)
// 04/01/2008           Ruhi Hira       Bugzilla Bug 3227, different tableName used for different scenario
// 07/01/2008           Ashish Mangla	Bugzilla Bug 3303 (Query was formed incorrectly)
// 08/01/2008           Ashish Mangla	Bugzilla Bug 1681 (UserName Marco support required)
// 08/01/2008           Ruhi Hira       Bugzilla Bug 1649 Method moved from OraCreateWI.
// 09/01/2008           Varun Bhansaly	Bugzilla Id 3284,
//                                      Bug WFS_5_221 Returning the size of variables in case of char/varchar/nvarchar
// 09/01/2008           Varun Bhansaly	WFGetWorkItemData() - Query not being executed on UserPreferencesTable
// 10/01/2008           Ruhi Hira       Bugzilla Bug 3380, transaction started in syncRoutingMode in completeWorkitem.
// 24/01/2008           Shilpi S        Bug # 1621
// 31/01/2008           Ruhi Hira       Bugzilla Bug 3772 New message for reassignment not allowed.
// 26/02/2008           Shilpi S        return target activity id from complete workitem
// 12/03/2008           Varun Bhansaly  WFS_5_182 - Workitems locked by a user must get unlocked as soon as user's web Session Expires.
// 17/03/2008			Shweta Tyagi	Bugzilla bug 3919 return new tag ownerindex in WFGetWorkitemDataExt
// 19/03/2008			Sirish Gupta	WMReassignWorkItem changed. Added .trim() to variable TargetUser.
// 20/06/2008			Shweta Tyagi	Bugzilla Bug Id 5142
// 14/08/2008           Varun Bhansaly  SrNo-9, API WFGetWorkitemDataExt to return precision & length
//                                              for float variables + deleted commented queries.
//                                      Bugzilla Id 5976, rs.getBigdecimal() to be used instead of getFloatValue of XMLgenerator
// 25/08/2008           Shilpi S        Complex data type support, a new tag is added userDefVarFlag is added in fetchAttributes call
// 26/08/2008           Varun Bhansaly  SrNo-10, Open WIs with complex type.
// 28/08/2008           Shilpi S        SrNo-11, Block Activity Requirement
// 13/04/2009           Saurabh Kamal	SrNo-12, Calling WFPDAUtil.fetchAttributes on the basis of pdaFlag(OFME Support)
// 27/04/2009           Saurabh Kamal   Bugzilla Bug 9216
// 09/06/2009			Ishu Saraf		API for Adhoc routing of workitems
// 21/07/2009			Indraneel Dasgupta	WFS_7.1_040  Error "WFS_SQL" while fetching row count on MyQueue because statement
//											is closed within for loop that returns row count.
// 31/08/2009           Shilpi S        WFS_8.0_026 , workitem specific calendar
//	07/10/09			Indraneel		WFS_8.0_039	Support for Personal Name along with username in fetching worklist,workitem history, setting reminder,refer/reassign workitem and search.
// 06/10/2009			Preeti Awasthi	WFS_8.0_040 Support for filter using queue variables/aliases on Queue is 'No Assignment' Type.
// 14/10/09				Ashish Mangla	WFS_8.0_044 TurnAroundTime support in FetchWorklist and SearchWorkitem
// 03/11/09				Saurabh Kamal	WFS_8.0_049 Return completion time, ActvityId, ActivityName,ProcessInscanceId, WorkitemId in completeworkitem
// 04/11/09				Saurabh Kamal	WFS_8.0_052 Return ProcessedBy	in FetchWorklist
// 02/12/2009			Ashish Mangla	WFS_8.0_061 (Support of process specific alias in case of MYQueue)
// 27/01/2010			Preeti Awasthi	WFS_8.0_079 Participant tag is not coming in WFGetWorkitem API
// 03/02/2010			Ruhi Hira		WFS_8.0_082 Block Activity support for reinitiate and subprocess cases [CIG (CapGemini) Ã¢â‚¬â€œ generic AP process].
// 10/02/2010			Vikas Saraswat	WFS_8.0_084 Form Fragment functionality
//	21/09/2010			Saurabh Kamal	Changes for postgres - in method WFFetchWorkItems1
// 10/11/2010           Saurabh Sinha   Bug #815 : Support for Previous Next in Introduction,FIFO and WIP
// 01/07/2011			Saurabh Kamal	Bug 27393, In case of FIFO Queue, if a user is working on a workitem then it should get permanently assigned to the same user(Fixed Assignment).
// 12/09/2011			Saurabh Kamal/Abhishek	WFS_8.0_149[Replicated] Search support on Alias on external on process specific queue
// 21/03/2012			Vikas Saraswat	Bug 30800 - sorting is not working on Prev next click after opening the workitem
// 29/03/2012			Vikas Saraswat  WFS_8.0_148: Support for reassignment of workitem from one auditor's my queue to another.[Bug Replicated]
// 05/07/2012     		Bhavneet Kaur   Bug 33029 Cabinet Based Logging for Console, Error, PSError, PSXML & PSOut logs
// 22/08/2012			Bhavneet Kaur	Bug 34209 Invalid filter error while reassigning WorkItem
// 06/09/2012			Bhavneet Kaur	Bug 34661 Message description for WFS_NOQ changed from "Invalid Queue" to "WorkItem has already been processed." 
// 12/09/2012			Preeti Awasthi	Bug 34839 - User should get pop-up for reminder without relogin
// 28/09/12             Neeraj Sharma	Bug 35455 - Mails were escalated because the entries from 				  WFescalationTable were not deleted by messageAgent.
// 18/07/2012	        Abhishek Gupta	Bug 33200 and 30984 : RevisedDateTime and OwnerName returned in Document information in WFGetWorkitemDataExt API.
// 03/09/2012	        Abhishek Gupta	Bug 34167 - An undefined error message is occured.
//18/10/2012			Shweta Singhal	Bug 35875 - Always FetchInstrumentList tag is coming in output XML
//17/12/2012			Sajid Khan		Bug 36355 - Changes done in query , we were passing column name instead of column's value.
//	29/01/2013			Preeti Awasthi	Bug 38109 - LockForMe option gets failed due to case sensitivity of value in <TargetUser> tag
//26/02/2013			Sajid Khan		Bug 38059 - Details regarding Acceptance of WI are not showing in 'Work Audit Details'
//28/02/2013			Sajid Khan		Bug 38562 - Approve status is not showing in Work Audit Details.
// 18/03/2013           Deepak Mittal   [Replicate] Bug 38689 - Workitem has unassign by the user who has neither lock the workitem nor workitem has assigned to it
//26/04/2013			Mohnish Chopra	Process Variant Support --Changes in WMReassignWorkItem,WFReferWorkItem,WFWithDraw,
//										WMUnlockWorkItem,WMChangeWorkItemState,WMCompleteWorkitem
//03/05/2013			Shweta Singhal	Process Variant Support Changes
// //10/06/2013         Kahkeshan       Bug 40338 - Not able to release the lock in workitem (inconsistent) 
//29/07/2013			Shweta Singhal	Bug 41579,  requested operation failed on newly created queue
//22/12/2013   			Kahkeshan 		Code Optimization Changes
//23/12/2013   			Mohnish Chopra 	Code Optimization Changes
//23/12/2013			Shweta Singhal	Changes for Code Optimization Merged
// 24/12/2013		   Anwar Ali Danish	 Changes done for code optimization
// 24/12/2013      	    Kahkeshan		Code optimzation Changes for WMUnAssignWorkItem ,WFAdhocWorkItem API's and
//										WFFetchWorkItems1 method
// 05/02/2014		Kahkeshan			Queue Caching Changes ,LastModifiedOn Column support in QueueDefTable
//	10/02/2014		Shweta Singhal		Paging will be provided on the basis of pagingFlag
// 05/03/2014		Shweta Singhal		Changed method for optimization was not called from WFWithdrawQorkitem API and same parameter was passed twice in method signature
// 25/03/2014           Kanika Manik            Bug-43991 User Management: Set Work Audit > Workitem is not moving to Auditor's Queue. 
// 04/04/2014		Mohnish Chopra		Code Optimization : Return Error message in CompleteWorkitem,ReferWorkitem,ReassignWorkitem and getworkitemdataext api's if workitem has expired
// 04/04/2014		Mohnish Chopra		Bug 44116 - "Done" option is showing as disabled in WorkList view if workitem is coming from JMS publisher Activity. 
//										Reason : AssignedUser was not getting cleared in CompleteWorkItem.
// 05/06/2014       Kanika Manik        PRD Bug 42177 - Restriction of SQL Injection in APIs
//06/06/2014        Anwar Danish        PRD Bug 40431 merged : To include UserDefVarFlag in in WFGetworkitemdataext API output to differentiate Omniflow 6 and 9 versions
//13/06/2014		Mohnish Chopra		Changes for Workitem opening in Archival -- PRD bug 42458
//13/06/2014        Kanika Manik        PRD Bug 41839 - Incorrect completion time when calender is associated on activity.
//13/06/2014        Kanika Manik        PRD Bug 43141 - Reassign should not happen when work item is locked.
//16/06/2014  		Anwar Ali Danish    PRD Bug 38828 merged - Changes done for diversion requirement. CQRId 				CSCQR-00000000050705-Process  
//23/06/2014        Kanika Manik        PRD Bug 42691 - Mails to be triggered in case of Refer,Reassign and SetDiversion based upon the NotifyByEmail flag value which is to be read from WFAppContext.xml.
//26/06/2014       Anwar Danish         PRD Bug 45001 merged - Add new action ids, handle also at front end configuration screen and history generation functionality.
//03-07-2014		Sajid Khan			Reassign case was getting failed if NotifyByMail feature is applied. 
// 07/07/2014		Anwar Danish	    PRD Bug 42423 merged - Making the Workitem Routing i.e. Synchronous and Asynchronous configurable on the basis of a flag. 	
//05-09-2014		Sajid Khan			NGOGetDocumenListExt API called for DocListOptionFlag = Y and some tags required by web returned like VolIndex,RemoteSiteId etcc..
//12/09/2014		Mohnish Chopra		Bug 50125 : Checked a workitem, click on reassign, an error is generated
//15/09/2014		Mohnish Chopra		Bug 50123 : While unlock workitem, an error �invalid Workitem: operation failed� is generated if wi is locked by another user
//										Admin flag handled in UnlockWorkitem call.
//30/10/2014		Mohnish Chopra		Code review defect - Error code WM_INVALID_SESSION_HANDLE not handled in API WFGetWorkitemDataExt
//26/03/2014		Mohnish Chopra		Bug 54573 - Windows : JBOSS : SQL : Functional > Workitem is showing locked in my queue, lock icon is not showing, and also Assign To me option is enabled
//05/05/2015		Mohnish Chopra		Changes For Case Management in WFGetWorkItemDataExt
//14/05/2015		Mohnish Chopra		Changes For Case Management in WMCompleteWorkItem
//05/08/2015		Mohnish Chopra		Changes For Case Management in WMUnlockWorkItem. QueueType M handling done
//06/08/2015		Mohnish Chopra		Changes for Case Management -Adding ActivityType in WFInstrumentTable
//07/08/2015		Anwar Danish	Bug 51267 - Handling of new ActionIds and optimize usage of current ActionIds regarding OmniFlow Audit Logging functionality.
//11/08/2015		Mohnish Chopra		Changes for Data Locking issue in Case Management 
//11/08/2015		Mohnish Chopra		Changes for CaseView in Case Management. Returning InitiatedBy and InitiatedOn in WFGetWorkItemDataExt
//20/08/2015		Mohnish Chopra		Changes for Case management. By passing lock requirement in Task View 
//11/09/2015		Mohnish Chopra		Changes for Case Management - Returning errors WF_TASK_ALREADY_COMPLETED and WF_TASK_ALREADY_REVOKED in case a task is opened for an already completed /revoked task.
//22/09/2015		Mohnish Chopra		Changes for Case Management --Rights on Case Visualisation during Initiation of Task
//29/10/2015		Mohnish Chopra		Changes for Case Management --WFFetchCaseWorkItems api added for Case Basket Component
//26/10/2015		Kirti Wadhwa		Changes for Case Management -- Update Read Flag for tasks when they are first refernced in WFGetWorkitemDataExt.
//03/11/2015		Mohnish Chopra		Changes for Case Management -- Can Initiate Requirement
//16 Nov 2015		Sajid Khan			Hold Workstep Enhancement
//18/11/2015		Mohnish Chopra		Changes for Case Management -- Changes for detailed view in Case Basket(FetchCaseWorkItems)
//26/11/2015		Mohnish Chopra		Bug 57360 - error while performing done operation in a WI where all mandatory tasks are completed
//30/11/2015		Mohnish Chopra		Bug 57931 - Jboss EAP : Error message while changing priority of WI
//02/12/2015        Kirti Wadhwa	    WF_CASE_RELEASE_NOT_ALLOWED added in unassignworkitem  for handling invalid release of workitem
//02/12/2015		Mohnish Chopra		Bug 58014 - show case visualization check box during assigning a task is not working according to specification
//02/12/2015		Mohnish Chopra		Bug 58016 - Jboss EAP : Count of WI in MY queue is showing count of My cases of case mgt also
//18/02/2016		Mohnish Chopra		Changes for QueryTimeout-Optimisation.
//10/05/2016		Mohnish Chopra		Changes for Postgres
//18/10/2016        RishiRam Meel		Changes done for Bug 64916 - PreviousStage is not updated as per rule defined.Its updated by previous to previous activity
//20/09/2016        RishiRam Meel       Bug 65056 : Changes done for Bug 55482  Support of API WMCreateChildWorkitem and  PRDBug 62511/59717 - Support to set the Attributes while creating child workitem through WMCreateChildWorkItem API
//28/07/2015		Sweta Bansal	Bug 56062 - Handling done to use WFUploadWorkitem API for creating workitem in SubProcess(Subprocess/Exit) and to perform operation like: workitem creation in subprocess, Bring ParentWorkitem in flow when child routed to exit, will be performed before CreateWorkitem.
//07/04/2017			Kumar Kimil				Bug 63462 -Wrong escalation time set in case of EntryDateTime system variable used in Escalation rule
//21/04/2017			Kumar Kimil  	Bug 56509 - Create a webservice to Set the attributes of a workitem and also complete the workitem based on a flag.
//29/04/2017        Sajid Khan          Merging Bug 64117 - Support of API WMDeleteChildWorkitem
//29/04/2017        Sajid Khan          Merging Bug 56800 - No same workitem should be allowed to be reassigned by two different user if the same is already assigned to some other user
//01-May-2017       Sajid Khan      Merging Bug 56949 - WMGetWorkItem API should be called implicitly from  WFReferWorkItem API's.
//05-05-2017        Sajid Khan      Merging Bug 58399 - Need an option to view refer, reassign and ad-hoc routing comments in workitem properties
// 09/05/2017		Rakesh K Saini	Bug 56761 - Seperating configuration data and Application parameters from WFAppContext.xml file by dividing the file into two files. 1. WFAppContext.xml 2. WFAppConfigParam.xml
//09-05-2017        Sajid Khan			Queue Varaible Extension Enahncement
//09/05/2017		Kumar Kimil      		Bug 55927 - Support for API Wise Synchronous Routing.
//17/05/2017        Mohnish Chopra 		 Changes for Nested Complex array requirement-Updation & Batching
//18/05/2017        Sajid Khan              Merging  Bug 66701 - Need to Lock multiple workitem.
//22/05/2017	Sajid Khan			Merging Bug 64308 - AssignmentType for the referred and distributed parent workitems changed to Z and while searching the workitems, workitems with assignment type Z will not be visible
//31-05-2017		Sajid Khan		Bug 69719 - JbossEAP+Postgres:-unable to create WI it shows "the request filter is invalid"
//02/06/2017        Kumar Kimil     Archival UT Defects
//06/06/2017	Mohnish Chopra		Bug 69882 - EAP+Postgres: Functionality of batching/arrow is not working proper in listview
//07/06/2017	Mohnish Chopra		UT Defect - Archived document not opening
//06/07/2017	Ambuj Triapthi		Added provision to lock the task when the task is opened for first time to supprt WFReassignTask feature in Case Management
//17/07/2017	Shubhankur Manuja	Bug 70574 - Special chars were not handled while creating output for WFFetchCaseWorkItems API.
//31/07/2017	Sajid Khan			Bug 70831 - Unable to Reassign workitem thorugh custom code if the workitem lies in another user's queue.
//03/08/2017		Kumar Kimil     	Bug 70043 - Entry for action id 200 is getting inserted while performing the reassign operation from webdesktop
//04/08/2017	Sajid Khan			Bug 70894 - Reassign Option is not working when a person is trying to assign a transaction from someone else's queue in business admin view
//08/08/2017	Ambuj Tripathi		Added the provision for task to expire when its ValidTill in TaskStatusDefTable is < Current DateTime
//11/08/2017	Mohnish Chopra		Changes for Case Summary document generation requirement
//18/08/2017    Ambuj Tripathi  	Added the changes related to task reassignment review points (unlocktask) feature for Case Management
//19/08/2017    Kumar Kimil      	 Process Task Changes(Synchronous and Asynchronous)
//22/08/2017	Mohnish Chopra		Changes for Case Management Requirement(Document to be visible in case when 
//									task is completed)  Changes in WFGetWorkItemDataExt
//06/09/2017        Kumar Kimil             Process task Changes (User Monitored,Synchronous and Asynchronous)
//14/09/2017	Mohnish Chopra		Changes for Searching ,sorting and filtering in FetchCaseList 

//18/09/2017    Kumar Kimil         Tasktype and TaskMode added in Output of WFGetWorkitemDataExt

//20/09/2017	Mohnish Chopra	Changes for Sonar issues
//28/09/2017    Kumar Kimil        Bug 72238 - EAP+SQL: If delete added variables from Case Details Configuration, assigned cases & Task are removed from case Basket
//04/10/2017    Kumar Kimil        Bug 71011 - EAP+SQL: Workiteitem should be removed from My queue if open another workitem and queue type is set as Search
//10/10/2017	Mohnish Chopra	   Bug 72454 - EAP+SQL: If Assign to Me any workitem from Case workdesk, Queue name should be "user's My Cases" instead of "user's My Queue" in search result for that workitem
//11/10/2017	Mohnish Chopra		Changes for Sonar in WFFetchCaseWorkItems
//17/10/2017	Ambuj Tripathi		Case registeration Name changes requirement- Added URN in output of WMFetchWorkList API
//17/10/2017	Mohnish Chopra		Case registeration Name changes requirement- Added URN in output of WFGetWorkItemDataExt API
//24/10/2017	Ambuj Tripathi		Case registration changes for Adding URN in the output of WFFetchCaseWorkItems API
//01/11/2017	Shubhankur Manuja	Changes related to Multilevel refer
//02/11/2017	Ambuj Tripathi		Bug 72848 - Weblogic+ Oracle: Invalid characters are coming in WI, updated processedBy and LastProcessedBy in WMCompleteWorkitem update queries
//06/11/2017        Kumar Kimil         Bug 72824 - Action id bugs reported by simulator team
//15/11/2017        Kumar Kimil     API Changes for Case Registration
//17/11/2017    Ambuj Tripathi        Case registration changes for adding URN in the XML output of APIs
//22/11/2017        Kumar Kimil     Multiple Precondition enhancement
//05/12/2017	Mohnish Chopra		Bug 73425 - Batching is not working on the list view when the flag is set in the appropriate INI
//18/12/2017	Mohnish Chopra		Bug 74246 - User should be allowed to release the workitem assigned to another user if he is a superior of that user
//22/12/2017	Mohnish Chopra		Changes for LikeSearchEnabled Configuration for Case Basket
//26/12/2017	Ambuj Tripathi		Bug 74317 - EAP6.4+SQL: URN should be shown instead of processinstanceid for referred/reassigned workitems, Changes done in WFReferWorkitem API to add the URN in referred workitem instance
//13/01/2018    Kumar Kimil         Sonar Cube-"PreparedStatement" and "ResultSet" methods should be called with valid indices
//15/01/2018	Ambuj Tripathi		Sonar bug fixing for the Rule : Multiline blocks should be enclosed in curly braces
//14/02/2018    Kumar Kimil         Bug 75718 - Unable to see the archived WI
//27/02/2018	Ambuj Tripathi		Bug 70322 - Update session support on queue click and search. 
//02/04/2018	Shubhankur Manuja	Bug 76840 - Todo deletion support for workItems created in Omniflow.
//03/04/2018    Kumar Kimil         Prev-Next Unlock Changes for TCA merging
//20/04/2018	Shubhankur Manuja	Bug 77212 - Refer functionality changes when referred workitem from shared queue comes back.
//20/04/2018	Ambuj Tripathi		Bug 77179 - Webdesktop page :: While searching for work-item sometimes getting error message in result.
//16-05-2018	Sajid Ali Khan		Bug 77183	Previous-Next Functionality to be implemented on ORACLE and POSTGRES SQL Database
//02/06/2018	Mohnish Chopra		Bug 78237 - Allow referred workitem to be reassigned by Admin user.
//21/11/2018	Ravi Ranjan Kumar		Bug 80762 - Postgres specific: Save option not visible on opening task
//07/01/2018    Shubham Singla      Bug 81112 - Comments while raising an Exception using special characters gets introduced with unwanted characters on Saving         
//22/01/2019    Shubham Singla      Bug 82565 - Ibps 3.0 sp1+ Postgres:Fetchworklist call output not bringing all alias defined on queue variables
//11/03/2019	Ravi Ranjan Kumar 	Bug 83511 - PRDP bug merging (Support of multiple image cabinets for archived workitems(Queuehistorytable)) 
//14/03/2019    Shubham Singla      Bug 83646 - iBPS 4.0 :Fetchworklist call output not bringing all alias defined on queue variables for oracle.
//01/04/2019	Mohnish Chopra		Need to ensure that rights are always checked while locking a workitem.
//07/06/2019    Sourabh Tantuway    Bug 85123 - iBPS 4.0 :Values of Process variable alias are not visible in workitem list in Omniapp for oracle.
//6/7/2019		Ravi Ranjan Kumar 	Bug 85140 - Enabling to edit workitem (only data and document ) on query workstep if workitem is present on end workstep
//19/06/2019		Ravi Ranjan Kumar	PRDP Bug Mergin ( Bug 85051 - Diverted workitems should not be visible in source user(diverted by user) myqueue)
//12/8/2019 	Ravi Ranjan Kumar	Bug 85915 - Workitem is hold on Timer Event workstep, when unholding these workitem manual then workitem not routed to target workstep
//19/09/2019	AMbuj Tripathi		Bug 86766 - iBPS 4.0: If done workitem of FIFO Type worklist from Embedded view , next workitem should be fetched instead of showing message "no next workitem" 
//14/10/2019	Ravi Ranjan Kumar	Bug 87309 - When unlocking the end workitem then its throwing null pointer exception( workitem present on end workstep which QueueType=null in WFINSTRUMENTTABLE) 
//05/11/2019    Reverting previous change for BugID 87380 and setting Q_QueueID = 0 in case workitem is being referred from the shared queue.//----------------------------------------------------------------------------------------------------
//20/11/2019	Ravi Ranjan Kumar	Bug 88441 - When Workitem is present on timer event , user open the workitem and close the workitem then workitem still shows in user's myqueue
//26/11/2019	Ambuj Tripathi		Internal fixing for client - Dailchi (all  the earlier changes are reverted, and other refer related fixes). 
//09/12/2019	Ravi Ranjan Kumar	Bug 88922 - On closing a WI on timer event queue, error is displayed.
//09/12/2019	Ravi Ranjan Kumar	Bug 88902 - Referring WI after opening a WI opens in Read only mode after operation is performed 
//10/12/2019	Ravi Ranjan Kumar PRDP Bug Merging(Bug 87270 - Handling done to execute product API's even if API name in input xml has different case.)
//10/12/2019	Ravi Ranjan Kumar	Bug 88740 - Priority of WI from a referred user not changed when seen at the referrer's end
//11/12/2019	Ravi Ranjan Kumar	Bug 88727 - Referred WIs can't be revoked from assigned user's shared Queue || should not be revoked from there or error message to be different
//17/12/2019	Ravi Ranjan Kumar	Bug 89135 - Support for calling Storeprocedure on entry setting of Workstep through System Function and support of two variant return type(string and integer)
//20/11/2019	Mohnish Chopra		No Authorization error is to be returned in case Workitem is getting opened after searching from Mobile on an activity which is not mobile Enabled.
//19/12/2019    Mohnish Chopra		Bug 88668 - iBPS 4.0 : One of the childs in not getting assigned to Assigned_User(Value sent in Attribute ) if Assigned to rule is used in Entry setting rule to assign workitem to Assigned_User variable. (edit)
//27/12/2019	Shahzad Malik		Bug 89370 - Provide a new API for adhoc routing.
//14/01/2020	Shahzad Malik		Bug 89865 - In case user has used WMCompleteWorkItem for introducing a workitem, this API should internally redirect to WMStartProcess.
//27/01/2020	Ravi Ranjan Kumar	Bug 89538 - Ad hoc Routing on a WI shows Error
//16/01/2020  Sourabh Tantuway    Bug 90086 - iBPS 4.0 + mssql + oracle + postgres: Support for returning CalendarName in the output of WFFetchWorkItems API, so that Calendar based TAT can be calculated in the post hook.
//31/01/2020	Ravi Ranjan Kumar	Bug 90421 - Postgres: Alias are not getting displayed for Workitem
//04/02/2020	Ravi Ranjan Kumar	Bug 90490 - Refereed workitem got disappear after doing hold and Unhold operation.
//18/02/2020		Ravi Ranjan Kumar	Bug 90769 - Query Queue Filter is not calculated in WFGetWorkitem API when user opeing the workitem.
//24/03/2020	Ravi Ranjan Kumar	Bug 91415 - IOCL:- Adhoc routing not working properly.
//25/03/2020	Ambuj Tripathi		Group Box Activity feature support in Asynchronous mode in iBPS 5.0(already supported in synch mode)
//26/02/2020    Sourabh Tantuway    Bug 91487 - iBPS 4.0 : After referring the workitem, Queuename is null for referred copy.
//23/03/2020	Ravi Ranjan Kumar	PRDP Bug Merging Bug 91203 - Child WI should be deleted in WMCompleteWorkItem API if CollectFlag is Y
//08/04/2020	Shahzad Malik		Bug 91513 - Optimization in mailing utility.
//09/04/2020  Sourabh Tantuway    Bug 91626 - iBPS 4.0 : EntryDateTime for referred workitem is coming as of parent workitem instead it should be the time when workitem got referred.
//04/05/2020  Sourabh Tantuway    Bug 92140 - iBPS 4.0: CreatedDateTime and CreatedByName is not going in WFInstrumentTable, for the child workitems created by WMCreateChildWorkitem API.
//09/07/2020   Shubham Singla     Bug 93229 - iBPS 4.0+SP1:Adhoc routing not working on exit workstep
//10-07-2020	Mohnish Chopra	Bug 93224 - ZipBuffer support in webdesktop for data compression at API level 
//14/07/2020	Ravi Ranjan Kumar	Bug 93279 - Advance search on alias variables not working as it shows error on search
//14/09/2020    Shubham Singla    Bug 94571 - iBPS 4.0:Issue is coming while opening the workitem present in QueueHistoryTable.
//08/05/2020  Sourabh Tantuway    Bug 92243 - iBPS 4.0 : Parent workitem is not getting resumed when child workitem in subprocess reaches to exit.
//26/02/2021  Shubham Singla     Catastrophic bug For indusInd-- Issue in todo list.     
//01/04/2021    Shubham Singla     Bug 98964 - iBPS 5.0 :Requirement to adhoc route distributed workitems based on configuration. 
//26/05/2021   Ravi Raj Mewara     Bug 99548 - iBPS 5.0 SP2: If a workitem is temporary hold by any user then only that user can open it in editable mode and only badmin or that particular user can unhold the workitem.
//27/05/2021  Satyanarayan Sharma Bug 99496 - iBPS 5.0 :While opening the Archive WI then Sometimes it throws error "The Requested Operation Failed".
//28/06/2021  Satyanarayan Sharma Bug 99908 - iBPS 5.0 : WFInvokeDBFuncExecute api throwing an error "Transaction Rolled back for API ::: WFInvokeDBFuncExecute".
//19/07/2021  Rvai Raj Mewara     Bug 99753 - Code Review Defect - Unlock Workitem when called from Utilities updates RoutingStatus to Y
//06/11/2020    Sourabh Tantuway Bug 95940 - iBPS 4.0 : Requirement for optimizations related to workitem expiry.
//02/10/2021    Ravi Raj Mewara  Bug 101830 - iBPS 5.0 SP1 : Special Character handling missing in Exception comments
//22/10/2021    Ravi Raj Mewara  Bug 102214 - iBPS 5.0 SP2 : In WFChangeWorkitemPriority API, check for workitem is already locked or not is missing before unlocking the workitem 
//04/10/2021  Ravi Raj Mewara     Bug 101894 - iBPS 5.0 SP2 : Support of TAT variables ( TATConsumed and TATRemaining) in omniapp 
//13/03/2022  Satyanarayan Sharma Bug 106672 - iBPS5.0SP2+Postgres +WebLogic :- When login in omniapp getting error resultset closed in WFFetchWorkitems Api.
//1611/2022 Satyanarayan Sharma Bug 119089 - iBPS5.0Sp2:-Provided support for adhoc route from Case workdesk.
//27/04/2023	Vaishali Jain	Bug 124906 - iBPS5 - CQRN-252330 - Handling is required in assign and reassign workitem API to assign/reassign workitem only when processinstanceId is 2 
//27/04/2023 Satyanarayan Sharma Bug 123466 - iBPS5.0Sp3- WFInvokeDBFuncExecute APi is not working for integer return type.
//23/06/2023	Vaishali Jain	Bug 131015 - iBPS5Spx - Handling in WFCompleteWorkitem API and WFAdhocWorkItem API to delete the WFTaskStatusTable data on WI completion or WI adhoc route from case workstep
//28/06/2023	Vaishali Jan	Bug 131300 - iBPS5SPx - changing QueueType from 'T' to 'G' 
//----------------------------------------------------------------------------------------------------
package com.newgen.omni.jts.txn.wapi;

import java.io.File;
import java.math.BigInteger;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Locale;
import java.util.StringTokenizer;

import org.w3c.dom.Document;
import org.w3c.dom.Element;

import com.newgen.omni.jts.cache.CachedActionObject;
import com.newgen.omni.jts.cache.CachedObjectCollection;
import com.newgen.omni.jts.cmgr.XMLGenerator;
import com.newgen.omni.jts.cmgr.XMLParser;
import com.newgen.omni.jts.constt.JTSConstant;
import com.newgen.omni.jts.constt.WFSConstant;
import com.newgen.omni.jts.dataObject.WFBatchInfo;
import com.newgen.omni.jts.dataObject.WFCalAssocData;
import com.newgen.omni.jts.dataObject.WFUserInfo;
import com.newgen.omni.jts.dataObject.WMAttribute;
import com.newgen.omni.jts.excp.JTSException;
import com.newgen.omni.jts.excp.JTSSQLError;
import com.newgen.omni.jts.excp.WFSError;
import com.newgen.omni.jts.excp.WFSErrorMsg;
import com.newgen.omni.jts.excp.WFSException;
import com.newgen.omni.jts.srvr.NGDBConnection;
import com.newgen.omni.jts.srvr.ServerProperty;
import com.newgen.omni.jts.srvr.WFFindClass;
import com.newgen.omni.jts.srvr.WFServerProperty;
import com.newgen.omni.jts.txn.wapi.common.WfsStrings;
import com.newgen.omni.jts.util.VariableClass;
import com.newgen.omni.jts.util.WFCaseDataVariableMap;
import com.newgen.omni.jts.util.WFPDAUtil;
import com.newgen.omni.jts.util.WFRoutingUtil;
import com.newgen.omni.jts.util.WFSUtil;
import com.newgen.omni.jts.util.WFUserApiContext;
import com.newgen.omni.jts.util.WFUserApiThreadLocal;
import com.newgen.omni.jts.util.WFXMLUtil;
import com.newgen.omni.util.cal.WFCalUtil;
import com.newgen.omni.wf.data.process.WFProcess;
import com.newgen.omni.wf.ps.WFRuleEngine;
import com.newgen.omni.wf.util.data.Location;
import com.newgen.omni.wf.util.misc.Utility;
import com.newgen.omni.wf.util.misc.WFConfigLocator;
import com.newgen.omni.wf.wfdms.WFDMSImpl;

public class WMWorkitem extends com.newgen.omni.jts.txn.NGOServerInterface {
    //----------------------------------------------------------------------------------------------------
    //	Function Name 				:	execute
    //	Date Written (DD/MM/YYYY)	:	16/05/2002
    //	Author						:	Prashant
    //	Input Parameters			:	Connection , XMLParser , XMLGenerator
    //	Output Parameters			:   none
    //	Return Values				:	String
    //	Description					:   Reads the Option from the input XML and invokes the
    //									Appropriate function .
    //----------------------------------------------------------------------------------------------------

    public String execute(Connection con, XMLParser parser, XMLGenerator gen) throws JTSException,
            WFSException {
        String option = parser.getValueOf("Option", "", false);
        String outputXml = null;
        //----------------------------------------------------------------------------
        // Changed By                       : Prashant
        // Reason / Cause (Bug No if Any)	: WFL_2.0.5.014
        // Change Description               : Call names WMFetchWorkItem,
        //                                    WMFetchWorkitemStates WMFetchActivityInstance
        //                                    chganged for proper understanding .
        //----------------------------------------------------------------------------
        if (("WMFetchWorkItem").equalsIgnoreCase(option)) {
            outputXml = WFFetchWorkItems(con, parser, gen);
        } else if (("WMFetchWorkItems").equalsIgnoreCase(option)) {
            outputXml = WFFetchWorkItems(con, parser, gen);
        } else if (("WMGetWorkItem").equalsIgnoreCase(option)) {
            outputXml = WMGetWorkItem(con, parser, gen);
        } else if (("WMFetchWorkItemState").equalsIgnoreCase(option)) {
            outputXml = WMFetchWorkItemStates(con, parser, gen);
        } else if (("WMFetchWorkItemStates").equalsIgnoreCase(option)) {
            outputXml = WMFetchWorkItemStates(con, parser, gen);
        } else if (("WMChangeWorkItemState").equalsIgnoreCase(option)) {
            outputXml = WMChangeWorkItemState(con, parser, gen);
        } else if (("WMCompleteWorkItem").equalsIgnoreCase(option)) {
            outputXml = WMCompleteWorkItem(con, parser, gen);
        } else if (("WMReassignWorkItem").equalsIgnoreCase(option)) {
            outputXml = WMReassignWorkItem(con, parser, gen);
        } else if (("WMFetchWorkItemAttribute").equalsIgnoreCase(option)) {
            outputXml = WMFetchWorkItemAttributes(con, parser, gen);
        } else if (("WMFetchWorkItemAttributes").equalsIgnoreCase(option)) {
            outputXml = WMFetchWorkItemAttributes(con, parser, gen);
        } else if (("WMGetWorkItemAttributeValue").equalsIgnoreCase(option)) {
            outputXml = WMGetWorkItemAttributeValue(con, parser, gen);
        } else if (("WMAssignWorkItemAttribute").equalsIgnoreCase(option)) {
            outputXml = WMAssignWorkItemAttribute(con, parser, gen);
        } else if (("WMUnlockWorkItem").equalsIgnoreCase(option)) {
            outputXml = WMUnlockWorkItem(con, parser, gen);
        } else if (("WFFetchInstrumentsList").equalsIgnoreCase(option)) {
            outputXml = WFFetchWorkItems(con, parser, gen);
        } else if (("WMFetchWorkList").equalsIgnoreCase(option)) {
            outputXml = WFFetchWorkItems(con, parser, gen);
        } else if (("WFReferWorkItem").equalsIgnoreCase(option)) {
            outputXml = WFReferWorkItem(con, parser, gen);
        } else if (("WFWithdrawWorkitem").equalsIgnoreCase(option)) {
            outputXml = WFWithdrawWorkitem(con, parser, gen);
        } else if (("WFFetchWorkItemsWithLock").equalsIgnoreCase(option)) {
            outputXml = WFFetchWorkItemsWithLock(con, parser, gen);
        } else if (("WFFetchWorkItemCount").equalsIgnoreCase(option)) { //WFS_5_106
            outputXml = WFFetchWorkItemCount(con, parser, gen);
        } else if (("WFGetWorkitemDataExt").equalsIgnoreCase(option)) {
            outputXml = WFGetWorkitemDataExt(con, parser, gen);
            XMLParser parser_new= new XMLParser(outputXml);
            int maincode = parser_new.getIntOf("maincode", 0, false);
            if(maincode == 400){
            	int SubErrorCode = parser_new.getIntOf("SubErrorCode", 0, false);
            	if(maincode == 400 && SubErrorCode == 825){
                	outputXml = WFGetWorkitemDataExt(con, parser, gen);
                }
            }
        } else if (("WFAdhocWorkitem").equalsIgnoreCase(option)) {
            outputXml = WFAdhocWorkitem(con, parser, gen);
		}else if (("WMUnAssignWorkitem").equalsIgnoreCase(option)) {
            outputXml = WMUnAssignWorkitem(con, parser, gen);
        }else if (("WMCreateChildWorkItem").equalsIgnoreCase(option)) {
            outputXml = WFCreateChildWorkItem(con, parser, gen);
        }else if (("WFFetchCaseWorkItems").equalsIgnoreCase(option)) {
            outputXml = WFFetchCaseWorkItems(con, parser, gen);
        }else if (("WFHoldWorkitem").equalsIgnoreCase(option)) {
            outputXml = WFHoldWorkitem(con, parser, gen);
        }else if (("WFUnholdWorkitem").equalsIgnoreCase(option)) {
            outputXml = WFUnholdWorkitem(con, parser, gen);
        } else if (("WFGetParentWIInfo").equalsIgnoreCase(option)) {
            outputXml = WFGetParentWIInfo(con, parser, gen);
        } else if (("WFSetAndCompleteWorkItem").equalsIgnoreCase(option)) {
            outputXml = WFSetAndCompleteWorkItem(con, parser, gen);
        } else if (("WMDeleteChildWorkItem").equalsIgnoreCase(option)) {
            outputXml = WMDeleteChildWorkItem(con, parser, gen);
        }else if (("WFChangeWorkItemPriority").equalsIgnoreCase(option)) {
            outputXml = WFChangeWorkItemPriority(con, parser, gen);}
        else if (("WFBulkLockWorkitem").equalsIgnoreCase(option)) {
            outputXml = WFBulkLockWorkitem(con, parser, gen);
        }else if (("WFGetSuspendedWorkItem").equalsIgnoreCase(option)) {
            outputXml = WFGetSuspendedWorkItem(con, parser, gen);
        } else if (("WFResumeSuspendedWorkItem").equalsIgnoreCase(option)) {
            outputXml = WFResumeSuspendedWorkItem(con, parser, gen);
        }  else if (("WFSuspendWorkitem").equalsIgnoreCase(option)) { 
            outputXml = WFSuspendWorkitem(con, parser, gen);
        }  else if (("WFInvokeDBFuncExecute").equalsIgnoreCase(option)) {
            outputXml = WFInvokeDBFuncExecute(con, parser, gen);
        } 
		else {
            outputXml = gen.writeError("WMWorkitem", WFSError.WF_INVALID_OPERATION_SPECIFICATION, 0,
                    WFSErrorMsg.getMessage(WFSError.WF_INVALID_OPERATION_SPECIFICATION), null,
                    WFSError.WF_TMP);
        }
        return outputXml;
    }

    //----------------------------------------------------------------------------------------------------
    //	Function Name 				:	WMFetchWorkItemStates
    //	Date Written (DD/MM/YYYY)	:	16/05/2002
    //	Author						:	Prashant
    //	Input Parameters			:	Connection , XMLParser , XMLGenerator
    //	Output Parameters			:   none
    //	Return Values				:	String
    //	Description					:   Fetch the possible WorkItemStates of given WorkItem
    //----------------------------------------------------------------------------------------------------
    public String WMFetchWorkItemStates(Connection con, XMLParser parser,
            XMLGenerator gen) throws JTSException, WFSException {
    	StringBuffer outputXML = new StringBuffer("");
        PreparedStatement pstmt = null;
        int mainCode = 0;
        int subCode = 0;
        String subject = null;
        String descr = null;
        String errType = WFSError.WF_TMP;
		boolean printQueryFlag = true;
		String queryString ;
		ArrayList parameters = new ArrayList();
		String option = parser.getValueOf("Option", "", false);
		String engine  = null;
		ResultSet rs=null;
        try {
            int sessionID = parser.getIntOf("SessionId", 0, false);
            char countFlag = parser.getCharOf("CountFlag", 'N', true);
            String procInstID = parser.getValueOf("ProcessInstanceId", "", false);
            int wrkItemID = parser.getIntOf("WorkItemId", 0, false);

            engine = parser.getValueOf("EngineName");
            int dbType = ServerProperty.getReference().getDBType(engine);
            int noOfRectoFetch = parser.getIntOf("NoOfRecordsToFetch",
                    ServerProperty.getReference().getBatchSize(), true);
            if (noOfRectoFetch > ServerProperty.getReference().getBatchSize() || noOfRectoFetch <= 0) {
                noOfRectoFetch = ServerProperty.getReference().getBatchSize();
            }
            WFParticipant user = WFSUtil.WFCheckSession(con, sessionID);
            int userID = 0;
            char pType = '\0';
            StringBuffer tempXml = new StringBuffer(100);
            if (user != null && user.gettype() == 'U') {
                userID = user.getid();
                pType = user.gettype();

                /*pstmt = con.prepareStatement(
                        " Select * from (Select Processdefid,activityid,Statename," + "ProcessInstanceID,WorkItemID from Worklisttable UNION ALL Select " + "Processdefid,activityid,Statename,ProcessInstanceID,WorkItemID " + "from Workinprocesstable UNION ALL Select Processdefid,activityid," + "Statename,ProcessInstanceID,WorkItemID from WorkDonetable " + "UNION ALL Select Processdefid,activityid,Statename,ProcessInstanceID," + "WorkItemID from Workwithpstable UNION ALL Select Processdefid,activityid," + " Statename,ProcessInstanceID,WorkItemID from PendingWorklisttable) a " + "where ProcessInstanceID=? and WorkItemID=?");*/
				queryString = "Select Processdefid,activityid from WFInstrumentTable " + WFSUtil.getTableLockHintStr(dbType) + " where ProcessInstanceID=? and WorkItemID=?" ;
				pstmt = con.prepareStatement(queryString);
                WFSUtil.DB_SetString(1, procInstID, pstmt, dbType);
                pstmt.setInt(2, wrkItemID);
				parameters.add(Arrays.asList(procInstID,wrkItemID));
                //pstmt.execute();
				WFSUtil.jdbcExecute(procInstID,sessionID,userID,queryString,pstmt,parameters,printQueryFlag,engine);
                 rs = pstmt.getResultSet();
                if (rs.next()) {
                    int procDefID = rs.getInt(1);
                    int activity = rs.getInt(2);

                    rs.close();
                    pstmt.close();

                    if (countFlag == 'Y') {
                        pstmt = con.prepareStatement("Select COUNT(*) from  ( Select StateName from StatesDefTable " + WFSUtil.getTableLockHintStr(dbType) + " where ProcessDefID  = ? UNION SELECT StateName FROM ActivityAssociationtable " + WFSUtil.getTableLockHintStr(dbType) + " , StatesDefTable " + WFSUtil.getTableLockHintStr(dbType) + " WHERE Definitionid = StateID AND ActivityAssociationtable.ProcessDefID = StatesDefTable.ProcessDefID  AND definitiontype = 'P' AND ActivityAssociationtable.ProcessDefID = ? AND ActivityID = ? ) a where 1 = 1 " + TO_SANITIZE_STRING(WFSUtil.getFilter(parser, con), true));
                        pstmt.setInt(1, procDefID);
                        pstmt.setInt(2, procDefID);
                        pstmt.setInt(3, activity);
                        pstmt.execute();
                        rs = pstmt.getResultSet();
                        if (rs.next()) {
                            tempXml.append(gen.writeValueOf("Count", String.valueOf(rs.getInt(1))));
                        }
                        if (rs != null) {
                            rs.close();
                        }
                        pstmt.close();
                    }

                    // Tirupati Srivastava : changes in queries for PostgreSql dbase
                    pstmt = con.prepareStatement("Select StateName from ( Select StateName from StatesDefTable " + WFSUtil.getTableLockHintStr(dbType) + " where ProcessDefID  = ? UNION SELECT StateName FROM ActivityAssociationtable " + WFSUtil.getTableLockHintStr(dbType) + " , StatesDefTable" + WFSUtil.getTableLockHintStr(dbType) + " WHERE Definitionid = StateID AND ActivityAssociationtable.ProcessDefID = StatesDefTable.ProcessDefID  AND definitiontype = " + WFSUtil.TO_STRING("P", true, dbType) + " AND ActivityAssociationtable.ProcessDefID = ? AND ActivityID = ? ) a where 1 = 1 " + WFSUtil.getFilter(parser, con) + WFSUtil.getBatch(parser, "", 0,
                            "StateName",
                            WFSConstant.WF_STR));

                    pstmt.setInt(1, procDefID);
                    pstmt.setInt(2, procDefID);
                    pstmt.setInt(3, activity);
                    pstmt.execute();
                    rs = pstmt.getResultSet();
                    int i = 0;
                    while (rs.next() && i < noOfRectoFetch) {
                        tempXml.append(gen.writeValueOf("WorkItemState", rs.getString(1)));
                        i++;
                    }
                    if (rs != null) {
                        rs.close();
                    }
                    pstmt.close();

                    if (i > 0) {
                        tempXml.insert(0, "<WorkItemStates>\n");
                        tempXml.append("</WorkItemStates>\n");
                    } else {
                        mainCode = WFSError.WM_NO_MORE_DATA;
                        subCode = 0;
                        subject = WFSErrorMsg.getMessage(mainCode);
                        descr = WFSErrorMsg.getMessage(subCode);
                        errType = WFSError.WF_TMP;
                    }
                    tempXml.append("</WorkitemStates>\n");
                    tempXml.append(gen.writeValueOf("RetrievedCount", String.valueOf(i)));
                } else {
                    if (rs != null) {
                        rs.close();
                    }
                    pstmt.close();

                    mainCode = WFSError.WM_INVALID_PROCESS_DEFINITION;
                    subCode = 0;
                    subject = WFSErrorMsg.getMessage(mainCode);
                    descr = WFSErrorMsg.getMessage(subCode);
                    errType = WFSError.WF_TMP;
                }
            } else {
                mainCode = WFSError.WM_INVALID_SESSION_HANDLE;
                subCode = 0;
                subject = WFSErrorMsg.getMessage(mainCode);
                descr = WFSErrorMsg.getMessage(subCode);
                errType = WFSError.WF_TMP;
            }
            if (mainCode == 0) {
                outputXML = new StringBuffer(500);
                outputXML.append(gen.createOutputFile("WMFetchWorkitemState"));
                outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
                outputXML.append(tempXml);
                outputXML.append(gen.closeOutputFile("WMFetchWorkitemState"));
            }
        } catch (SQLException e) {
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WM_INVALID_FILTER;
            subCode = WFSError.WFS_SQL;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_FAT;
            if (e.getErrorCode() == 0) {
                if (e.getSQLState().equalsIgnoreCase("08S01")) {
                    descr = (new JTSSQLError(e.getSQLState())).getMessage() + "(SQL State : " + e.getSQLState() + ")";
                }
            } else {
                descr = e.getMessage();
            }
        } catch (NumberFormatException e) {
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_ILP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch (NullPointerException e) {
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_SYS;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch (JTSException e) {
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = e.getErrorCode();
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.getMessage();
        } catch (Exception e) {
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_EXP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch (Error e) {
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_EXP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } finally {
        	try {
                if (rs != null) {
                	rs.close();
                	rs = null;
                }
            } catch (Exception e) {
            }
            try {
                if (pstmt != null) {
                    pstmt.close();
                    pstmt = null;
                }
            } catch (Exception e) {
            }
            
        }
        if (mainCode != 0) {
            //throw new WFSException(mainCode, subCode, errType, subject, descr);
			String errorString = WFSUtil.generalError(option, engine, gen,mainCode, subCode,errType, subject,descr);
   	        return errorString;
        }
        return outputXML.toString();
    }
	    
    //----------------------------------------------------------------------------------------------------
    //	Function Name 				:	createNewChildWorkItem
    //	Date Written (DD/MM/YYYY)   :	19/06/2015
    //	Author					    :	Kahkeshan
    //	Input Parameters			:	Connection , XMLParser , XMLGenerator
    //	Output Parameters			:       none
    //	Return Values				:	String
    //	Description				:       Creates new Child workitem for given parent workitem.
    //----------------------------------------------------------------------------------------------------
    // Change Summary *
    //----------------------------------------------------------------------------

    private String WFCreateChildWorkItem(Connection con, XMLParser parser, XMLGenerator gen) throws WFSException {
        int mainCode = 0;
        int subCode = 0;
        String subject = null;
        String descr = null;
        String errType = WFSError.WF_TMP;
        StringBuffer outputXML = new StringBuffer();
        ResultSet rs = null;
        ResultSet rs1 = null;
        Statement stmt = null;
        int error = 0;
        String errorMsg = "";
        int qId = 0;
		PreparedStatement pstmt = null;
		boolean commit = false;
         try{
            String processInstanceId = parser.getValueOf("ProcessInstanceID", "", false);
            int parentWIId = parser.getIntOf("ParentWorkItemId", 0, false);
            String targetActivityName = parser.getValueOf("ActivityName", "", false);
            String engine = parser.getValueOf("EngineName");
            int dbType = ServerProperty.getReference().getDBType(engine);
            /*boolean bParentWIOnDistribute = false;
            boolean bCollectCountModified = false;
            int iActivityId = -1;
            int iProcessDefId = -1;
            int iParentTargetActivity = -1;*/
            int sessionID = parser.getIntOf("SessionId", 0, false);
            WFParticipant participant = WFSUtil.WFCheckSession(con, sessionID);
            if (participant != null) {
                //  Check whether the workitem is on Distribute Activity or not.
                 pstmt = con.prepareStatement(" Select ProcessDefId,ActivityID,AssignmentType,ParentWorkItemId,CreatedDatetime,ActivityName,Q_QueueId, ExpectedWorkitemDelay, EntryDatetime," + WFSUtil.getDate(dbType) + "," +
                                        "LockedTime, processedBy, CreatedDateTime, ProcessName, ProcessVersion, LastProcessedBy , CollectFlag, PriorityLevel, WorkitemState, StateName,ProcessInstanceState from WFInstrumentTable " + " where ProcessInstanceID = " + WFSUtil.TO_STRING(processInstanceId, true, dbType) + " and WorkItemId = " + parentWIId);
				pstmt.execute();
                rs = pstmt.getResultSet();
				if (rs.next()) {
					if (con.getAutoCommit()) {
                        con.setAutoCommit(false);
                        commit= true;
                    }
                    int procDefID = rs.getInt(1);
                    int prevActivityId = rs.getInt(2);
                    String assignmenttype = rs.getString(3);
                    int pworkItemID = rs.getInt(4);
                    String date = rs.getString(5);
                    date = rs.wasNull() ? "" : WFSUtil.TO_DATE(date, true, dbType);
                    String prevActName = rs.getString(6);
                     qId = rs.getInt(7);
                    String expectedWkDelay = rs.getString(8);
                    String entryDateTime = rs.getString(9);

                    String currentDate = rs.getString(10);
                    String lockedTime = rs.getString(11);
                    String processedBy = rs.getString(12);
                    String createdDateTime = rs.getString(13);
                    String processName = rs.getString(14);
                    String processVersion = rs.getString(15);
                    String lastProcessedBy = rs.getString(16);
                    String collectFlag1 = rs.getString(17);
                    String priorityLevel = rs.getString(18);
                    String wiState = rs.getString(19);
                    String stateName = rs.getString(20);
                    int processInstanceState=rs.getInt(21);
                    rs.close();
                    pstmt.close();        
                    
                     if (processInstanceState < 5) {
                        StringBuffer preActivityBuffer = new StringBuffer();
                        StringBuffer postActivityBuffer = new StringBuffer();
                        preActivityBuffer.append(",").append(WFSUtil.appendDBString(processName)).
                                append(",").append(processVersion).append(",").append(procDefID).
                                append(",").append(lastProcessedBy).append(",").append(WFSUtil.appendDBString(processedBy)).
                                append(",").append(WFSUtil.TO_DATE(currentDate, true, dbType)).append(",").append(WFSUtil.appendDBString(collectFlag1)).
                                append(",").append(priorityLevel).append(",").append("null, 0, 0, 0, null, null").
                                append(",").append(WFSUtil.TO_DATE(currentDate, true, dbType)).append(",").append(wiState).
                                append(",").append(WFSUtil.appendDBString(stateName)).append(",").append("null, ");
                        postActivityBuffer.append(", null, 'N', null");
                        String attributeXml = parser.getValueOf("Attributes");
                        StringBuffer parentWIPropBuffer = new StringBuffer();
                        parentWIPropBuffer.append(preActivityBuffer).append(WFSUtil.appendDBString(targetActivityName)).append(postActivityBuffer);
                        int iNewWorkItemId = WFSUtil.createChildWorkitem(con, engine, processInstanceId,
                                parentWIId, targetActivityName, procDefID, dbType, parentWIPropBuffer.toString(), attributeXml, participant);

                        if (mainCode == 0) {
                            outputXML = new StringBuffer(500);
                            outputXML.append(gen.createOutputFile("WMCreateChildWorkItem"));
                            outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
                            outputXML.append("<ProcessInstanceID>" + processInstanceId + "</ProcessInstanceID>");
                            outputXML.append("<WorkItemId>" + iNewWorkItemId + "</WorkItemId>");
                            outputXML.append("<ActivityName>" + targetActivityName + "</ActivityName>");
                            outputXML.append(gen.closeOutputFile("WMCreateChildWorkItem"));
                         }
                     } else {
                         mainCode = WFSError.WF_OPERATION_FAILED;
                         subCode = WFSError.WM_PROCESS_INSTANCE_ALREADY_COMPLETED;
                         subject = WFSErrorMsg.getMessage(mainCode);
                         descr =   WFSErrorMsg.getMessage(subCode);
                         errType = WFSError.WF_TMP;
                    }
                     if(commit) {
                    	 con.commit();
                    	 con.setAutoCommit(true);
                    	 commit=false;
                     }
                } else {
                   mainCode = WFSError.WF_OPERATION_FAILED;
				   subCode = WFSError.WM_PROCESS_INSTANCE_ALREADY_COMPLETED;
				   subject = WFSErrorMsg.getMessage(mainCode);
				   descr =   WFSErrorMsg.getMessage(subCode);
				   errType = WFSError.WF_TMP;
                }
            } else {
                mainCode = WFSError.WM_INVALID_SESSION_HANDLE;
                subCode = 0;
                subject = WFSErrorMsg.getMessage(mainCode);
                descr = WFSErrorMsg.getMessage(subCode);
                errType = WFSError.WF_TMP;
            }
        } catch (SQLException e) {
            WFSUtil.printErr("", e);
            mainCode = WFSError.WM_INVALID_FILTER;
            subCode = WFSError.WFS_SQL;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_FAT;
            if (e.getErrorCode() == 0) {
                if (e.getSQLState().equalsIgnoreCase("08S01")) {
                    descr = (new JTSSQLError(e.getSQLState())).getMessage() + "(SQL State : " + e.getSQLState() + ")";
                }
            } else {
                descr = e.getMessage();
            }
        } catch (NumberFormatException e) {
            WFSUtil.printErr("", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_ILP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch (NullPointerException e) {
            WFSUtil.printErr("", e);
            //e.printStackTrace();
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_SYS;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch (JTSException e) {
            WFSUtil.printErr("", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = e.getErrorCode();
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.getMessage();
        } catch (Exception e) {
            WFSUtil.printErr("", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_EXP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch (Error e) {
            WFSUtil.printErr("", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_EXP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } finally {
            try {
                if (rs != null) {
                    rs.close();
                    rs = null;
                }
            } catch (Exception ignored) {
            }
            try {
                if (rs1 != null) {
                    rs1.close();
                    rs1 = null;
                }
            } catch (Exception ignored) {
            }
            try {
                if (stmt != null) {
                    stmt.close();
                    stmt = null;
                }
            } catch (Exception e) {
            }

            try {
                if (!con.getAutoCommit()) {
                    con.rollback();
                    con.setAutoCommit(true);
                }
            } catch (SQLException ex) {
            }
           
        }
        if (mainCode != 0) {
            throw new WFSException(mainCode, subCode, errType, subject, descr);
        }
        return outputXML.toString();
    }
    //----------------------------------------------------------------------------------------------------
    //	Function Name 				:	WMChangeWorkItemState
    //	Date Written (DD/MM/YYYY)	:	16/05/2002
    //	Author						:	Prashant
    //	Input Parameters			:	Connection , XMLParser , XMLGenerator
    //	Output Parameters			:   none
    //	Return Values				:	String
    //	Description					:   Change the WorkItemState of given WorkItem
    //----------------------------------------------------------------------------------------------------
    //  Change Description          : Changes for Code Optimization-Merging of WorkFlow 
    //								  tables to WFInstrumentTable, logging of Query and removal of throw WFSException
    //  Changed by					: Shweta Singhal
    public String WMChangeWorkItemState(Connection con, XMLParser parser,
            XMLGenerator gen) throws JTSException, WFSException {
        StringBuffer outputXML = null;
        PreparedStatement pstmt = null;
        int mainCode = 0;
        int subCode = 0;
        String subject = null;
        String descr = null;
        String errType = WFSError.WF_TMP;
        boolean commit = false;
        boolean bSynchronousRoutingFlag = false;
        String engine= null;
        String option = parser.getValueOf("Option", "", false);
        try {
            engine = parser.getValueOf("EngineName", "", false);
            int dbType = ServerProperty.getReference().getDBType(engine);
            int sessionID = parser.getIntOf("SessionId", 0, true);
            String procInstID = parser.getValueOf("ProcessInstanceId", "", false);
            int wrkItemID = parser.getIntOf("WorkItemId", 0, false);
            String wkItemState = parser.getValueOf("WorkItemState", "", false);
            char omniServiceFlag = parser.getCharOf("OmniService", 'N', true);
            String synchronousRoutingFlag = parser.getValueOf("SynchronousRouting", "", true);
            if(synchronousRoutingFlag.equalsIgnoreCase("Y"))
                bSynchronousRoutingFlag = true;
            else if(synchronousRoutingFlag.equalsIgnoreCase(""))
                bSynchronousRoutingFlag = WFSUtil.isSyncRoutingMode();
            int wState = 0;
            int procDefID = 0;
            String lockStatus = null;
            String routingStatus = null;
            String assignType = null;
            ArrayList parameters = new ArrayList();
            String queryString = null; 
            boolean debug = parser.getValueOf("DebugFlag", "N", true).equalsIgnoreCase("Y");
            /* 20/08/2007, SrNo-3, Synchronous routing of workitems. - Ruhi Hira */
            WFParticipant user = null;
            if (omniServiceFlag == 'Y') {
                user = new WFParticipant(0, "System", 'P', "SERVER", Locale.getDefault().toString());
            } else {
                user = WFSUtil.WFCheckSession(con, sessionID);
            }
            int userID = 0;
            char pType = '\0';
            if (user != null) {
                userID = user.getid();
                pType = user.gettype();
                // OF Optimization
                queryString = "Select Processdefid,activityid,ActivityName, LockStatus,RoutingStatus,AssignmentType from WFInstrumentTable " + WFSUtil.getTableLockHintStr(dbType) + " where ProcessInstanceID=? and WorkItemID=?";
                pstmt = con.prepareStatement(queryString);
                //pstmt = con.prepareStatement(" Select * from (Select Processdefid,activityid,1 as wState," + "ProcessInstanceID,WorkItemID,ActivityName from Worklisttable " + WFSUtil.getTableLockHintStr(dbType) + " where ProcessInstanceID=? and WorkItemID=? UNION ALL Select " + "Processdefid,activityid,2 as wState,ProcessInstanceID,WorkItemID,ActivityName " + "from Workinprocesstable " + WFSUtil.getTableLockHintStr(dbType) + " where ProcessInstanceID=? and WorkItemID=? UNION ALL Select Processdefid,activityid," + "6 as wState,ProcessInstanceID,WorkItemID,ActivityName from WorkDonetable " + WFSUtil.getTableLockHintStr(dbType) + " where ProcessInstanceID=? and WorkItemID=? UNION ALL" + " Select Processdefid,activityid,6 as wState,ProcessInstanceID," + "WorkItemID,ActivityName from Workwithpstable " + WFSUtil.getTableLockHintStr(dbType) + " where ProcessInstanceID=? and WorkItemID=? UNION ALL Select Processdefid,activityid," + " 3 as wState,ProcessInstanceID,WorkItemID,ActivityName from PendingWorklisttable " + WFSUtil.getTableLockHintStr(dbType) + " where ProcessInstanceID=? and WorkItemID=?) a " + "where ProcessInstanceID=? and WorkItemID=?");
                WFSUtil.DB_SetString(1, procInstID, pstmt, dbType);
                pstmt.setInt(2, wrkItemID);
                parameters.add(procInstID);
                parameters.add(wrkItemID);
//                WFSUtil.DB_SetString(3, procInstID, pstmt, dbType);
//                pstmt.setInt(4, wrkItemID);
//                WFSUtil.DB_SetString(5, procInstID, pstmt, dbType);
//                pstmt.setInt(6, wrkItemID);
//                WFSUtil.DB_SetString(7, procInstID, pstmt, dbType);
//                pstmt.setInt(8, wrkItemID);
//                WFSUtil.DB_SetString(9, procInstID, pstmt, dbType);
//                pstmt.setInt(10, wrkItemID);
//                WFSUtil.DB_SetString(11, procInstID, pstmt, dbType);
//                pstmt.setInt(12, wrkItemID);
                ResultSet rs = WFSUtil.jdbcExecuteQuery(procInstID,sessionID,userID,queryString,pstmt,parameters,debug,engine);
                //pstmt.execute();
                //ResultSet rs = pstmt.getResultSet();
                if (rs.next()) {
                    procDefID = rs.getInt(1);
                    int actID = rs.getInt(2);
                    lockStatus = rs.getString("LockStatus");
                    routingStatus = rs.getString("RoutingStatus");
                    assignType = rs.getString("AssignmentType");
                    if("N".equals(lockStatus) && "N".equals(routingStatus))
                        wState = 1;
                    else if("Y".equals(lockStatus) && "N".equals(routingStatus))
                        wState = 2;
                    else if("Y".equals(routingStatus))
                        wState = 6;
                    else
                        wState = 3;
                    String actName = rs.getString("ActivityName");
                    rs.close();
                    pstmt.close();
                    if (pType == 'P' || (wState == 1 || wState == 2)) {

                        // Tirupati Srivastava : changes in queries for PostgreSql dbase
                        pstmt = con.prepareStatement(" Select StateId from StatesDefTable " + WFSUtil.getTableLockHintStr(dbType)+ " where ProcessDefID = ? and " + WFSUtil.TO_STRING("StateName", false, dbType) + " = " + WFSUtil.TO_STRING(WFSUtil.TO_STRING(wkItemState, true, dbType), false, dbType) + (pType != 'P' ? " and StateId > 6" : ""));
                        pstmt.setInt(1, procDefID);
                        //WFSUtil.DB_SetString(2, wkItemState, pstmt, dbType);		//Bugzilla Id 47 - RTrim( ? )
                        pstmt.execute();
                        rs = pstmt.getResultSet();
                        if (rs.next()) {
                            int cPState = rs.getInt(1);
                            rs.close();
                            pstmt.close();

                            String tableStr = "";
                            int res = 0;
                            if (con.getAutoCommit()) {
                                con.setAutoCommit(false);
                                commit = true;
                            }
                            //OF Optimization
                            String tempQuery ="";
                            if(wState ==3 && WFSUtil.isSyncRoutingMode())
                                tempQuery = ",lockStatus = 'Y', routingStatus='Y' ";
                            else if(wState ==3 && !WFSUtil.isSyncRoutingMode())
                                tempQuery = ",lockStatus = 'N', routingStatus='Y' ";
                            
                            if (cPState ==6 ){
                            	tempQuery =tempQuery + ",Q_QueueId=0,validtill = null ";
                            }
                            queryString = "Update WFInstrumentTable Set WorkItemState=?,StateName=? "+tempQuery+" where ProcessInstanceId=? and Workitemid=? and LockStatus = ? and RoutingStatus = ? and AssignmentType = ?";
                            pstmt = con.prepareStatement(queryString);
                            pstmt.setInt(1, cPState);
                            WFSUtil.DB_SetString(2, wkItemState, pstmt, dbType);
                            WFSUtil.DB_SetString(3, procInstID, pstmt, dbType);
                            pstmt.setInt(4, wrkItemID);
                            WFSUtil.DB_SetString(5, lockStatus, pstmt, dbType);
                            WFSUtil.DB_SetString(6, routingStatus, pstmt, dbType);
                            WFSUtil.DB_SetString(7, assignType, pstmt, dbType);
                            parameters.clear();
                            parameters.add(cPState);
                            parameters.add(wkItemState);
                            parameters.add(procInstID);
                            parameters.add(wrkItemID);
                            parameters.add(lockStatus);
                            parameters.add(routingStatus);
                            parameters.add(assignType);
                            //res = pstmt.executeUpdate();
                            
                            res = WFSUtil.jdbcExecuteUpdate(procInstID, sessionID, userID, queryString, pstmt, parameters, debug, engine);
                            pstmt.close();
//                            switch (wState) {
//                                case 1:
//                                    pstmt = con.prepareStatement(
//                                            "Update Worklisttable Set WorkItemState=?,StateName=? " + "where ProcessInstanceId=? and Workitemid=?");
//                                    pstmt.setInt(1, cPState);
//                                    WFSUtil.DB_SetString(2, wkItemState, pstmt, dbType);
//                                    WFSUtil.DB_SetString(3, procInstID, pstmt, dbType);
//                                    pstmt.setInt(4, wrkItemID);
//                                    res = pstmt.executeUpdate();
//                                    pstmt.close();
//                                    break;
//                                case 2:
//                                    pstmt = con.prepareStatement(
//                                            "Update WorkinProcesstable Set WorkItemState=?,StateName=? " + "where ProcessInstanceId=? and Workitemid=?");
//                                    pstmt.setInt(1, cPState);
//                                    WFSUtil.DB_SetString(2, wkItemState, pstmt, dbType);
//                                    WFSUtil.DB_SetString(3, procInstID, pstmt, dbType);
//                                    pstmt.setInt(4, wrkItemID);
//                                    res = pstmt.executeUpdate();
//                                    pstmt.close();
//                                    break;
//                                case 3:
//
//                                    // Tirupati Srivastava : changes in queries for PostgreSql dbase
//                                    /* 04/01/2008, Bugzilla Bug 3227, different tableName used for different scenario - Ruhi Hira */
//                                    String tableName = "WorkDonetable";
//                                    if (WFSUtil.isSyncRoutingMode()) {
//                                        tableName = "WorkInProcesstable";
//                                    }
//									//Process Variant Support 
//                                    pstmt = con.prepareStatement(
//                                            "Insert into " + tableName + " (ProcessInstanceId, " + "WorkItemId, ProcessName, ProcessVersion, ProcessDefID, LastProcessedBy, " + "ProcessedBy, ActivityName, ActivityId, EntryDateTime, ParentWorkItemId, " + "AssignmentType, CollectFlag, PriorityLevel, ValidTill, Q_StreamId, Q_QueueId, " + "AssignedUser, CreatedDateTime, WorkItemState, " + "Statename, ExpectedWorkitemDelay, PreviousStage, Queuename, Queuetype, ProcessVariantId) Select " + "ProcessInstanceId, WorkItemId, ProcessName, ProcessVersion, ProcessDefID, " + "LastProcessedBy, ProcessedBy, ActivityName, ActivityId, " + "EntryDatetime, ParentWorkItemId, " + WFSUtil.TO_STRING("Y", true, dbType) + ", CollectFlag, PriorityLevel, ValidTill, " + "Q_StreamId, Q_QueueId, " + "AssignedUser, CreatedDateTime, 6, " + WFSUtil.TO_STRING(WFSConstant.WF_COMPLETED, true, dbType) + ", ExpectedWorkitemDelay, " + "PreviousStage, QueueName, QueueType, ProcessVariantId from PendingWorklisttable where ProcessInstanceID = ? and WorkItemID = ? ");
//                                    WFSUtil.DB_SetString(1, procInstID, pstmt, dbType);
//                                    pstmt.setInt(2, wrkItemID);
//                                    res = pstmt.executeUpdate();
//                                    pstmt.close();
//                                    break;
//                            }
//                            if (wState == 3) {
//                                pstmt = con.prepareStatement("Delete from PendingWorklisttable where ProcessInstanceID = ? and WorkItemID = ? ");
//                                WFSUtil.DB_SetString(1, procInstID, pstmt, dbType);
//                                pstmt.setInt(2, wrkItemID);
//                                int f = pstmt.executeUpdate();
//                                pstmt.close();
//                            }
                            if (res > 0) { //Ashish changed WFL_ProcessStateChanged to WFL_ProcessInstanceStateChanged
                                WFSUtil.generateLog(engine, con, WFSConstant.WFL_ProcessInstanceStateChanged, procInstID, wrkItemID,
                                        procDefID, actID, actName, 0, (user.gettype() == 'P' ? 0 : userID), (user.gettype() == 'P' ? "System" : user.getname()), cPState, wkItemState, null, null, null, null);
                            }

                        } else {
                            if (rs != null) {
                                rs.close();
                            }
                            pstmt.close();

                            mainCode = WFSError.WM_INVALID_STATE;
                            subCode = 0;
                            subject = WFSErrorMsg.getMessage(mainCode);
                            descr = WFSErrorMsg.getMessage(subCode);
                            errType = WFSError.WF_TMP;
                        }
                    } else {
                        mainCode = WFSError.WM_TRANSITION_NOT_ALLOWED;
                        subCode = 0;
                        subject = WFSErrorMsg.getMessage(mainCode);
                        descr = WFSErrorMsg.getMessage(subCode);
                        errType = WFSError.WF_TMP;
                    }
                } else {
                    if (rs != null) {
                        rs.close();
                    }
                    pstmt.close();

                    mainCode = WFSError.WM_INVALID_WORKITEM;
                    subCode = 0;
                    subject = WFSErrorMsg.getMessage(mainCode);
                    descr = WFSErrorMsg.getMessage(subCode);
                    errType = WFSError.WF_TMP;
                }
            } else {
                mainCode = WFSError.WM_INVALID_SESSION_HANDLE;
                subCode = 0;
                subject = WFSErrorMsg.getMessage(mainCode);
                descr = WFSErrorMsg.getMessage(subCode);
                errType = WFSError.WF_TMP;
            }
            if (mainCode == 0) {
                outputXML = new StringBuffer(500);
                outputXML.append(gen.createOutputFile("WMChangeWorkItemState"));
                outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
                outputXML.append(gen.closeOutputFile("WMChangeWorkItemState"));
                /* 20/08/2007, SrNo-3, Synchronous routing of workitems. - Ruhi Hira */
                if (wState == 3 && bSynchronousRoutingFlag) {
                    WFRoutingUtil.routeWorkitem(con, procInstID, wrkItemID, procDefID, engine,0,0,true,bSynchronousRoutingFlag);
                }
                if (commit && !con.getAutoCommit()) {
                    con.commit();
                    con.setAutoCommit(true);
                    commit = false;
                }
            }
        } catch (SQLException e) {
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WM_INVALID_STATE;
            subCode = WFSError.WFS_SQL;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_FAT;
            if (e.getErrorCode() == 0) {
                if (e.getSQLState().equalsIgnoreCase("08S01")) {
                    descr = (new JTSSQLError(e.getSQLState())).getMessage() + "(SQL State : " + e.getSQLState() + ")";
                }
            } else {
                descr = e.getMessage();
            }
        } catch (NumberFormatException e) {
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_ILP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch (NullPointerException e) {
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_SYS;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch (JTSException e) {
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = e.getErrorCode();
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.getMessage();
        } catch (Exception e) {
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_EXP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch (Error e) {
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_EXP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } finally {
            try {
                if (commit && !con.getAutoCommit()) {
                    con.rollback();
                    con.setAutoCommit(true);
                    commit = false;
                }
            }catch (Exception e) {
            }
           try {
                if (pstmt != null) {
                    pstmt.close();
                    pstmt = null;
                }
            } catch (Exception e) {
            }
            
        }
        if (mainCode != 0) {
            String strReturn = WFSUtil.generalError(option, engine, gen,mainCode, subCode,errType, subject,descr);
            return strReturn;	
            //throw new WFSException(mainCode, subCode, errType, subject, descr);
        }
        return outputXML.toString();
    }
	
    //----------------------------------------------------------------------------------------------------
    //	Function Name 				:	WMFetchWorkItemAttributes
    //	Date Written (DD/MM/YYYY)	:	16/05/2002
    //	Author						:	Prashant
    //	Input Parameters			:	Connection , XMLParser , XMLGenerator
    //	Output Parameters			:   none
    //	Return Values				:	String
    //	Description					:   Fetch the Attributes of an assigned WorkItem
    //----------------------------------------------------------------------------------------------------
    public String WMFetchWorkItemAttributes(Connection con, XMLParser parser,
            XMLGenerator gen) throws JTSException, WFSException { 
        StringBuffer outputXML = null;
        int mainCode = 0;
        int subCode = 0;
        String subject = null;
        String engine =null;
        String descr = null;            
        String targetCabinetName= "";
        String strOption= "";
        Connection tarConn=null;
        String errType = WFSError.WF_TMP;
        try {
            int sessionID = parser.getIntOf("SessionId", 0, false);
            String procInstID = parser.getValueOf("ProcessInstanceId", "", false);
            int wrkItemID = parser.getIntOf("WorkItemId", 0, false);
            int queryTimeout = WFSUtil.getQueryTimeOut();
            engine = parser.getValueOf("EngineName");
            int activityID = parser.getIntOf("ActivityId", 0, true); //SRNo-2
			String name = parser.getValueOf("AttributeName", "", true);//WFS_8.0_084
            int procDefId = parser.getIntOf("ProcessDefinitionId", 0, true); //SRNo-2
            boolean userDefVarFlag = parser.getValueOf("UserDefVarFlag", "N", true).equalsIgnoreCase("Y");
            boolean fetchAttributeProperty = parser.getValueOf("UserDefVarFlag", "N", true).equalsIgnoreCase("X");
            String batchInfoXml = parser.getValueOf("BatchInfo","",true);
            ArrayList batchinfo =new ArrayList();
            if(batchInfoXml .equals("")){
            	int noOfRecordsToFetch = parser.getIntOf("NoOfRecordsToFetch", -1, true);
            	if(noOfRecordsToFetch >0 ){
            		HashMap map = new HashMap();
            		map.put("NoOfRecordsToFetch", noOfRecordsToFetch);
            		batchinfo.add(map);

            	}	
            }
            else{
            	batchInfoXml = "<BatchInfo>" + batchInfoXml + "</BatchInfo>";
            	batchinfo = WFXMLUtil.convertXMLToObject(batchInfoXml, engine);
            }
            PreparedStatement pstmt = null;
            ResultSet rs = null;
            int dbType = ServerProperty.getReference().getDBType(engine);
            String filter = WFSUtil.getFilter(parser, con);
            int userID = 0;
            char pType = '\0';
            String tempXml = "";
            WFParticipant user = WFSUtil.WFCheckSession(con, sessionID);
            if (user != null) {
                userID = user.getid();
                pType = user.gettype();
                String userName = user.getname();
                
                String ArchiveSearch= parser.getValueOf("ArchiveSearch","N",true);
                if(ArchiveSearch!=null && ArchiveSearch.equalsIgnoreCase("Y")) {
                	strOption=parser.getValueOf("Option");
                    pstmt=con.prepareStatement("Select PropertyValue from WFSYSTEMPROPERTIESTABLE where PropertyKey = ?");
                    pstmt.setString(1,"ARCHIVALCABINETNAME");
                    if(queryTimeout <= 0)
              			pstmt.setQueryTimeout(60);
                    else
              			pstmt.setQueryTimeout(queryTimeout);
                    rs= pstmt.executeQuery();
                    if(rs.next()){
                    	targetCabinetName=WFSUtil.getFormattedString(rs.getString("PropertyValue"))	;
                    }
                    else{

                        mainCode = WFSError.WF_ARCHIVAL_CABINET_NOT_SET;
                        subCode = 0;
                        subject = WFSErrorMsg.getMessage(mainCode);
                        descr = WFSErrorMsg.getMessage(subCode);
                        errType = WFSError.WF_TMP;
        			
                    	//throw new WFSException(mainCode, subCode, errType, subject, descr);
        				String errorString = WFSUtil.generalError(strOption, engine, gen,mainCode, subCode,errType, subject,descr);
        				return errorString;
                    	
                    }
                    if(rs!=null){
                    	rs.close();
                    	rs=null;
                    }
                    if(pstmt!=null){
                    	pstmt.close();
                    	pstmt=null;
                    }
                    //targetCabinetName=parser.getValueOf("ArchivalCabinet","",false);
                    tarConn=WFSUtil.createConnectionToTargetCabinet(targetCabinetName,strOption,engine);
                    if(tarConn!=null)
                    WFSUtil.printOut(engine,"Connection with Target Cabinet "+targetCabinetName+" is established.");
                }
	 			//WFS_8.0_084
                if (userDefVarFlag) {
                	 if(ArchiveSearch!=null && ArchiveSearch.equalsIgnoreCase("Y")) {
                   	  tempXml = (String) WFSUtil.fetchAttributesExt(
                   			  tarConn, procDefId, activityID, procInstID, wrkItemID, filter,
                         		  engine, dbType, gen, name, false, false,false,0,0,0,false,"Y",batchinfo);
                	 }
                	 else{
                         tempXml = (String) WFSUtil.fetchAttributesExt(
                         		con, procDefId, activityID, procInstID, wrkItemID, filter,
                         		  engine, dbType, gen, name, false, false,false,0,0,0,false,"Y",batchinfo);
                	 }
                   
                } else if(fetchAttributeProperty){
                	 if(ArchiveSearch!=null && ArchiveSearch.equalsIgnoreCase("Y")) {
                     	tempXml = 	(String) WFSUtil.fetchAttributesExt(tarConn, procDefId, activityID, procInstID, wrkItemID, filter, //SRNo-2
                                 engine,
                                 dbType, gen, name, false, false, false,0,0,0,false, "X"); 
                     }
                	 else{

                         tempXml = (String) WFSUtil.fetchAttributesExt(con, procDefId, activityID, procInstID, wrkItemID, filter, //SRNo-2
                                 engine,
                                 dbType, gen, name, false, false, false,0,0,0,false, "X");  
                	 } 
                   
                }else {
                	   if(ArchiveSearch!=null && ArchiveSearch.equalsIgnoreCase("Y")) {
                           tempXml = (String) WFSUtil.fetchAttributes(tarConn, procDefId, activityID, procInstID, wrkItemID, filter, //SRNo-2
                                   engine,
                                   dbType, gen, name, false, false);
                       }
                	   else{
                           tempXml = (String) WFSUtil.fetchAttributes(con, procDefId, activityID, procInstID, wrkItemID, filter, //SRNo-2
                                   engine,
                                   dbType, gen, name, false, false);
                	   }
                }
            } else {
                mainCode = WFSError.WM_INVALID_SESSION_HANDLE;
                subCode = 0;
                subject = WFSErrorMsg.getMessage(mainCode);
                descr = WFSErrorMsg.getMessage(subCode);
                errType = WFSError.WF_TMP;
            }
            if (mainCode == 0) {
                outputXML = new StringBuffer(500);
                outputXML.append(gen.createOutputFile("WMFetchWorkItemAttributes"));
                outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
				//Bug 40431: To include UserDefVarFlag in in WFGetworkitemdataext API output to differentiate Omniflow 6 and 9 versions
                outputXML.append("<UserDefVarFlag>"+(userDefVarFlag?"Y":"N")+"</UserDefVarFlag>\n");                
                outputXML.append(tempXml);
                outputXML.append(gen.closeOutputFile("WMFetchWorkItemAttributes"));
            }
        } catch (NumberFormatException e) {
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_ILP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch (NullPointerException e) {
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_SYS;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch (WFSException e) {
            mainCode = e.getMainErrorCode();
            subCode = e.getSubErrorCode();
            subject = e.getMessage();
            errType = e.getTypeOfError();
            descr = e.getErrorDescription();
        } catch (JTSException e) {
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = e.getErrorCode();
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.getMessage();
        } catch (Exception e) {
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_EXP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch (Error e) {
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_EXP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } finally {
        	try {
        	if(tarConn!=null){
					if (!tarConn.getAutoCommit()) {
						tarConn.commit();
						tarConn.setAutoCommit(true);
					}
	                NGDBConnection.closeDBConnection(tarConn, strOption);
	                tarConn = null;
				} 
        	}catch (SQLException e) {
					//e.printStackTrace();
        		 WFSUtil.printErr(engine,"", e);
			}
            
           
        }
        if (mainCode != 0) {
            throw new WFSException(mainCode, subCode, errType, subject, descr);
        }
        return outputXML.toString();
    }

    //----------------------------------------------------------------------------------------------------
    //	Function Name 				:	WMGetWorkItemAttributeValue
    //	Date Written (DD/MM/YYYY)	:	16/05/2002
    //	Author						:	Prashant
    //	Input Parameters			:	Connection , XMLParser , XMLGenerator
    //	Output Parameters			:   none
    //	Return Values				:	String
    //	Description					:   Get value of the given WorkItem Attribute
    //----------------------------------------------------------------------------------------------------
    public String WMGetWorkItemAttributeValue(Connection con, XMLParser parser,
            XMLGenerator gen) throws JTSException, WFSException {
    	StringBuffer outputXML = new StringBuffer("");
        PreparedStatement pstmt = null;
        int mainCode = 0;
        int subCode = 0;
        String subject = null;
        String descr = null;
        String errType = WFSError.WF_TMP;
        String engine =null;
        try {
            engine = parser.getValueOf("EngineName", "", false);
            int sessionID = parser.getIntOf("SessionId", 0, false);
            String procInstID = parser.getValueOf("ProcessInstanceId", "", false);
            int wrkItemID = parser.getIntOf("WorkItemId", 0, false);
            String name = parser.getValueOf("Name", "", false);
            int dbType = ServerProperty.getReference().getDBType(parser.getValueOf("EngineName", "", false));

            WFParticipant user = WFSUtil.WFCheckSession(con, sessionID);
            int userID = 0;
            char pType = '\0';
            StringBuffer tempXml = null;
            if (user != null && user.gettype() == 'U') {
                userID = user.getid();
                pType = user.gettype();
                //Fetch One
                tempXml = new StringBuffer((String) WFSUtil.fetchAttributes(con, procInstID, wrkItemID, "", engine,
                        dbType, gen, name, false, false));

            } else {
                mainCode = WFSError.WM_INVALID_SESSION_HANDLE;
                subCode = 0;
                subject = WFSErrorMsg.getMessage(mainCode);
                descr = WFSErrorMsg.getMessage(subCode);
                errType = WFSError.WF_TMP;
            }
            if (mainCode == 0) {
                outputXML = new StringBuffer(500);
                outputXML.append(gen.createOutputFile("WMGetWorkItemAttributeValue"));
                outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
                outputXML.append(tempXml);
                outputXML.append(gen.closeOutputFile("WMGetWorkItemAttributeValue"));
            }
        } catch (NumberFormatException e) {
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_ILP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch (NullPointerException e) {
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_SYS;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch (JTSException e) {
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WM_INVALID_ATTRIBUTE;
            subCode = e.getErrorCode();
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.getMessage();
        } catch (Exception e) {
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_EXP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch (Error e) {
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_EXP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } finally {
            try {
                if (pstmt != null) {
                    pstmt.close();
                    pstmt = null;
                }
            } catch (Exception e) {
            }
           
        }
        if (mainCode != 0) {
            throw new WFSException(mainCode, subCode, errType, subject, descr);
        }
        return outputXML.toString();
    }

    //----------------------------------------------------------------------------------------------------
    //	Function Name 				:	WMAssignWorkItemAttribute
    //	Date Written (DD/MM/YYYY)	:	16/05/2002
    //	Author						:	Prashant
    //	Input Parameters			:	Connection , XMLParser , XMLGenerator
    //	Output Parameters			:   none
    //	Return Values				:	String
    //	Description					:   Assign value to the given WorkItem Attribute
    //----------------------------------------------------------------------------------------------------
    public String WMAssignWorkItemAttribute(Connection con, XMLParser parser,
            XMLGenerator gen) throws JTSException, WFSException {
    	StringBuffer outputXML = new StringBuffer("");
        PreparedStatement pstmt = null;
        int mainCode = 0;
        int subCode = 0;
        String subject = null;
        String descr = null;
        String errType = WFSError.WF_TMP;
        String engine =null;
        try {
            int sessionID = parser.getIntOf("SessionId", 0, false);
            String procInstID = parser.getValueOf("ProcessInstanceId", "", false);
            int wrkItemID = parser.getIntOf("WorkItemId", 0, false);
            String name = parser.getValueOf("Name", "", false);
            int type = parser.getIntOf("Type", 0, false);
            int len = parser.getIntOf("Length", 0, true);
            String value = parser.getValueOf("Value", "", true);
            engine = parser.getValueOf("EngineName");
            int dbType = ServerProperty.getReference().getDBType(engine);

            WFParticipant participant = WFSUtil.WFCheckSession(con, sessionID);
            if (participant != null) {
                int userID = participant.getid();

                String tempStr = "";
                HashMap ipattributes = new HashMap(1, 1.0F);
                tempStr = parser.getValueOf("Name", "", false).trim();
                ipattributes.put(tempStr.toUpperCase(), new WMAttribute(tempStr,
                        parser.getValueOf("Value",
                        "", false), 10));
            } else {
                mainCode = WFSError.WM_INVALID_SESSION_HANDLE;
                subCode = 0;
                subject = WFSErrorMsg.getMessage(mainCode);
                descr = WFSErrorMsg.getMessage(subCode);
                errType = WFSError.WF_TMP;
            }
            if (mainCode == 0) {
                outputXML = new StringBuffer(500);
                outputXML.append(gen.createOutputFile("WMAssignWorkItemAttribute"));
                outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
                outputXML.append(gen.closeOutputFile("WMAssignWorkItemAttribute"));
            }
        } catch (WFSException e) {
            mainCode = e.getMainErrorCode();
            subCode = e.getSubErrorCode();
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.getErrorDescription();
        } catch (NumberFormatException e) {
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_ILP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch (NullPointerException e) {
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_SYS;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch (JTSException e) {
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WM_ATTRIBUTE_ASSIGNMENT_FAILED;
            subCode = e.getErrorCode();
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.getMessage();
        } catch (Exception e) {
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_EXP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch (Error e) {
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_EXP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } finally {
            try {
                if (pstmt != null) {
                    pstmt.close();
                    pstmt = null;
                }
            } catch (Exception e) {
            }
          
        }
        if (mainCode != 0) {
            throw new WFSException(mainCode, subCode, errType, subject, descr);
        }
        return outputXML.toString();
    }

    //----------------------------------------------------------------------------------------------------
    //	Function Name 				:	WMGetWorkItem
    //	Date Written (DD/MM/YYYY)	:	16/05/2002
    //	Author						:	Prashant
    //	Input Parameters			:	Connection , XMLParser , XMLGenerator
    //	Output Parameters			:   none
    //	Return Values				:	String
    //	Description					:   Returns the WorkItem
    //----------------------------------------------------------------------------------------------------
    public String WMGetWorkItem(Connection con, XMLParser parser, XMLGenerator gen) throws JTSException, WFSException {
    	StringBuffer outputXML = new StringBuffer("");
        StringBuffer tempXML = null;
        int mainCode = 0;
        int subCode = 0;
        String subject = null;
        String descr = null;
        String errType = WFSError.WF_TMP;
		CallableStatement cstmt = null;
		Statement stmt = null;
		PreparedStatement pstmt=null;
        ResultSet rs = null;
        ResultSetMetaData rsmd = null;
        String lockFlag = null;
        String engine =null;
        StringBuilder inputParamInfo = new StringBuilder();
        try {
            int sessionID = parser.getIntOf("SessionId", 0, false);
            String procInstID = parser.getValueOf("ProcessInstanceId", "", false).trim();
            int wrkItemID = parser.getIntOf("WorkItemId", 0, false);
            engine = parser.getValueOf("EngineName");
            String appServerIP = WFServerProperty.getSharedInstance().getCallBrokerData().getProperty(WFSConstant.CONST_BROKER_APP_SERVER_IP);
            int appServerPort = Integer.parseInt(WFServerProperty.getSharedInstance().getCallBrokerData().getProperty(WFSConstant.CONST_BROKER_APP_SERVER_PORT));
            String appServerType = WFServerProperty.getSharedInstance().getCallBrokerData().getProperty(WFSConstant.CONST_BROKER_APP_SERVER_TYPE);
            WFProcess wfProcess = null;
            String externalTableName="";
            String historyTableName="";
            
            int queueId = parser.getIntOf("QueueId", -1, true);
            //Ensuring that rights are always checked.
            if(queueId>0) {
            	queueId = -1;
            }
            String queueType = parser.getValueOf("QueueType", "", true);
            int lastWorkitem = parser.getIntOf("LastWorkitem", 0, true);
            String lastProcessInstance = parser.getValueOf("LastProcessInstance", "", true);
            String utilityFlag = parser.getValueOf("UtilityFlag", "N", true);
            //Bug #815
            int orderBy = parser.getIntOf("OrderBy", 2, true);
            String lastValue = parser.getValueOf("LastValue", "", true);
            String sortOrder = parser.getValueOf("SortOrder", "A", true);
            String generateLog = parser.getValueOf("GenerateLog", "Y", true);
			String assignMe = parser.getValueOf("AssignMe", "N", true);
			String ClientOrderFlag = parser.getValueOf("ClientOrderFlag", "N", true);
            int dbType = ServerProperty.getReference().getDBType(engine);
            WFParticipant user = WFSUtil.WFCheckSession(con, sessionID); 
            inputParamInfo.append(gen.writeValueOf("SessionId", String.valueOf(sessionID)));
            inputParamInfo.append(gen.writeValueOf("UserName", (user == null ? "" : user.getname())));
            inputParamInfo.append(gen.writeValueOf("ProcessInstanceId", procInstID));
            inputParamInfo.append(gen.writeValueOf("WorkItemId", String.valueOf(wrkItemID)));
            int indx = procInstID.indexOf(" ");
            if(indx > -1)
                procInstID = procInstID.substring(0, indx);
            
            
          //Getting process object from cache
            String targetCabinetName = WFSUtil.getTargetCabinetName(con);
			boolean tarHistoryLog= WFSUtil.checkIfHistoryLoggingOnTarget(targetCabinetName);
            int tmpProcessDefID=0;
            WFRuleEngine wfRuleEngine = WFRuleEngine.getSharedInstance();
            wfRuleEngine.initialize(appServerIP, appServerPort, appServerType,"iBPS");
            	
            pstmt= con.prepareStatement("select processdefId from WFInstrumenttable "+WFSUtil.getTableLockHintStr(dbType)+" where processInstanceId= ? and workitemId= ?");
            WFSUtil.DB_SetString(1, procInstID, pstmt, dbType);
            pstmt.setInt(2, wrkItemID);
            pstmt.execute();
            rs = pstmt.getResultSet();
            if(rs.next()){
            	tmpProcessDefID=rs.getInt(1);
           	}else{
            	if(rs!=null){
            		rs.close();
            		rs=null;
            	}
            if(pstmt!=null){
            		pstmt.close();
            		pstmt=null;
            	}
            	pstmt= con.prepareStatement("select processdefId from QueueHistoryTable "+WFSUtil.getTableLockHintStr(dbType)+" where processInstanceId= ? and workitemId= ?");
               	WFSUtil.DB_SetString(1, procInstID, pstmt, dbType);
               	pstmt.setInt(2, wrkItemID);
               	pstmt.execute();
               	rs = pstmt.getResultSet();
            }
            	
            if(rs!=null){
        		rs.close();
        		rs=null;
        	}
        	if(pstmt!=null){
        		pstmt.close();
        		pstmt=null;
        	}
            if(tmpProcessDefID!=0){
            	wfProcess = wfRuleEngine.getProcessInfo(tmpProcessDefID, engine);
            	if(wfProcess!=null){
            		externalTableName=wfProcess.getExternalTable();
            		historyTableName=wfProcess.getExternalHistoryTable();
            	}
            }else{
            	WFSUtil.printOut("ProcessdefId=0 for processInstanceID:"+procInstID+" WorkitemID:"+wrkItemID);
            }
            
			//Bug #815
            if (dbType == JTSConstant.JTS_POSTGRES) {
                cstmt = con.prepareCall("{call WFGetWorkitem(?, ?, ?, ?, ?, ?, ?, ?, ?,?,?,?,?,?,?,?,?,?)}");
                con.setAutoCommit(false);
            }
             else if (dbType == JTSConstant.JTS_ORACLE) {
                cstmt = con.prepareCall("{call WFGetWorkitem(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,?,?,?,?,?,?,?,?,?,?,?)}");
            } else if (dbType == JTSConstant.JTS_MSSQL) {
                cstmt = con.prepareCall("{call WFGetWorkitem(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,?,?,?,?,?,?)}");
            }
            cstmt.setInt(1, sessionID);
            cstmt.setString(2, procInstID);
            cstmt.setInt(3, wrkItemID);
            cstmt.setInt(4, queueId);
            cstmt.setString(5, queueType);
            cstmt.setString(6, lastProcessInstance);
            cstmt.setInt(7, lastWorkitem);
            cstmt.setString(8, generateLog+",N");
			//Bug #815
            if (dbType == JTSConstant.JTS_MSSQL) {
                if ( !lastProcessInstance.equals("") ) {
                        cstmt.setInt(9, orderBy);
                        cstmt.setString(10, sortOrder);
                        if (lastValue.equals("")) {
                                cstmt.setNull(11, java.sql.Types.VARCHAR);
                        } else {
                                cstmt.setString(11, lastValue);
                        }
                } else {
                        cstmt.setNull(9, java.sql.Types.INTEGER);
                        cstmt.setNull(10, java.sql.Types.VARCHAR);
                        cstmt.setNull(11, java.sql.Types.VARCHAR);
                }
				cstmt.setString(12, assignMe);
				cstmt.setString(13, ClientOrderFlag);
				cstmt.setInt(14, 0);
                                cstmt.setString(15, utilityFlag);
                                cstmt.setString(16, "");//No USerFIlter String is required 
                                cstmt.setString(17, externalTableName);
                                cstmt.setString(18, historyTableName);
            }

            if (dbType == JTSConstant.JTS_ORACLE) {
				cstmt.setString(9, assignMe);
                cstmt.registerOutParameter(10, java.sql.Types.INTEGER);
                cstmt.registerOutParameter(11, java.sql.Types.VARCHAR);
                cstmt.registerOutParameter(12, oracle.jdbc.OracleTypes.CURSOR);
                cstmt.setInt(13, 0);
                cstmt.setString(14, utilityFlag);
                cstmt.setInt(15, orderBy);
                cstmt.setString(16, sortOrder);
                cstmt.setString(17, lastValue);
                cstmt.setString(18, ClientOrderFlag);
                cstmt.setString(19, "");
                cstmt.setString(20, externalTableName);
                cstmt.setString(21, historyTableName);
                if(!tarHistoryLog)
            		cstmt.setString(22, "N");
            	else
            		cstmt.setString(22, "Y");
            	cstmt.setString(23, targetCabinetName);
            } else if (dbType == JTSConstant.JTS_POSTGRES){
				cstmt.setString(9, assignMe);
                                cstmt.setInt(10, 0);
                                cstmt.setString(11, utilityFlag);
                                cstmt.setInt(12, orderBy);
                                cstmt.setString(13, sortOrder);
                                if (lastValue.equals("")) {
                                    cstmt.setNull(14, java.sql.Types.VARCHAR);
                                } else {
                                    cstmt.setString(14, lastValue);
                                }
                                cstmt.setString(15, ClientOrderFlag);
                                cstmt.setString(16, "");
                                cstmt.setString(17, externalTableName);
                                cstmt.setString(18, historyTableName);
			}
            cstmt.execute();
            if (dbType == JTSConstant.JTS_MSSQL || dbType == JTSConstant.JTS_POSTGRES) {
                rs = cstmt.getResultSet();
            }
            if ((dbType == JTSConstant.JTS_MSSQL && rs != null && rs.next()) || dbType == JTSConstant.JTS_ORACLE) {
                if (dbType == JTSConstant.JTS_ORACLE) {
                    mainCode = cstmt.getInt(10);
                    lockFlag = cstmt.getString(11);
                } else {
                    mainCode = rs.getInt("MainCode");
                    lockFlag = rs.getString("LockFlag");
                    rs.close();
                    rs = null;
                }
            } else if (dbType == JTSConstant.JTS_POSTGRES) {
                if (rs != null && rs.next()) {
                    stmt = con.createStatement();
                    String name = rs.getString(1);
                    rs.close();
                    rs = stmt.executeQuery("Fetch All In \"" + TO_SANITIZE_STRING(name, true) + "\"");
                    if (rs != null && rs.next()) {
                        mainCode = rs.getInt("MainCode");
                        lockFlag = rs.getString("LockFlag");
                    }
                }
            } else {
                if (rs != null) {
                    rs.close();
                    rs = null;
                }
                mainCode = WFSError.WF_OPERATION_FAILED;
                subCode = WFSError.WFS_FATAL;
            }
            if (mainCode == 0 || mainCode == WFSError.WM_LOCKED) {
                if (dbType == JTSConstant.JTS_MSSQL && cstmt.getMoreResults() == true) {
                    rs = cstmt.getResultSet();
                } else if (dbType == JTSConstant.JTS_ORACLE) {
                    rs = (ResultSet) cstmt.getObject(12);
                }
                if (dbType == JTSConstant.JTS_ORACLE || dbType == JTSConstant.JTS_MSSQL) {
                    if (rs != null) {
                        rs.next();
                    }
                }
                if (rs != null) {
					tempXML = new StringBuffer();
                    int userIndex = rs.getInt("UserIndex");
                    tempXML.append("<Workitem>");
                    String processInstanceId = rs.getString("ProcessInstanceId");
                    tempXML.append(gen.writeValueOf("WorkitemName", processInstanceId));
                    int workitemId = rs.getInt("WorkitemId");
                    tempXML.append(gen.writeValueOf("WorkitemId", String.valueOf(workitemId)));
                    int activityId = rs.getInt("ActivityId");
                    tempXML.append(gen.writeValueOf("ActivityInstanceId", String.valueOf(activityId)));
                    tempXML.append(gen.writeValueOf("ProcessInstanceId", processInstanceId));
					tempXML.append(gen.writeValueOf("PriorityLevel", rs.getString("PriorityLevel")));
					tempXML.append("\n<Participants>\n");  //WFS_8.0_079
					tempXML.append(gen.writeValueOf("Participant", rs.getString("UserName")));
					tempXML.append("\n</Participants>\n");
					tempXML.append(gen.writeValueOf("LastModifiedTime", rs.getString("LastModifiedTime")));
					tempXML.append(gen.writeValueOf("URN", rs.getString("URN")));
					tempXML.append("</Workitem>");
                    if (dbType == JTSConstant.JTS_POSTGRES) {
                        con.commit();
						con.setAutoCommit(true);
                    }
                    rs.close();
                    rs = null;
                } else {
                    if (rs != null) {
                        rs.close();
                        rs = null;
                    }
                    mainCode = WFSError.WF_OPERATION_FAILED;
                    subCode = WFSError.WFS_FATAL;
                }
            }
            if (mainCode == 0) {
                outputXML = new StringBuffer(500);
                outputXML.append(gen.createOutputFile("WMGetWorkItem"));
                outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
                outputXML.append(tempXML);
                outputXML.append(inputParamInfo);
                outputXML.append(gen.closeOutputFile("WMGetWorkItem"));
            } else {
                subject = WFSErrorMsg.getMessage(mainCode);
                descr = WFSErrorMsg.getMessage(subCode);
                errType = WFSError.WF_TMP;
            }
        } catch (SQLException e) {
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WM_INVALID_FILTER;
            subCode = WFSError.WFS_SQL;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_FAT;
            if (e.getErrorCode() == 0) {
                if (e.getSQLState().equalsIgnoreCase("08S01")) {
                    descr = (new JTSSQLError(e.getSQLState())).getMessage() + "(SQL State : " + e.getSQLState() + ")";
                }
            } else {
                descr = e.getMessage();
            }
        } catch (NumberFormatException e) {
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_ILP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch (NullPointerException e) {
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_SYS;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch (JTSException e) {
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = e.getErrorCode();
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.getMessage();
        } catch (Exception e) {
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_EXP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch (Error e) {
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_EXP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } finally {
            try {
                if (!con.getAutoCommit()) {
                    con.rollback();
                    con.setAutoCommit(true);
                }

                if (stmt != null) {
                    stmt.close();
                    stmt = null;
                }
            } catch (Exception e) {
            }
            try {

                if (rs != null) {
                	rs.close();
                	rs = null;
                }
            } catch (Exception e) {
            }
            try {

                if (pstmt != null) {
                	pstmt.close();
                	pstmt = null;
                }
            } catch (Exception e) {
            }
            
        }
        if (mainCode != 0) {
            throw new WFSException(mainCode, subCode, errType, subject, descr, inputParamInfo.toString());
        }
        return outputXML.toString();
    }

//      public String WMGetWorkItem(Connection con, XMLParser parser, XMLGenerator gen) throws JTSException, WFSException {
//        StringBuffer outputXML = null;
//        Statement stmt = null;
//        int mainCode = 0;
//        int subCode = 0;
//        String subject = null;
//        String descr = null;
//        String errType = WFSError.WF_TMP;
//        try {
//            int sessionID = parser.getIntOf("SessionId", 0, false);
//            String procInstID = parser.getValueOf("ProcessInstanceId", "", false).trim();
//            int wrkItemID = parser.getIntOf("WorkItemId", 0, false);
//            String engine = parser.getValueOf("EngineName");
//			int dbType = ServerProperty.getReference().getDBType(engine);
//            int activityId = 0;
//            StringBuffer tempXml = null;
//            WFParticipant participant = WMUser.WFCheckUpdateSession(con, sessionID, dbType);
//            if (participant != null && participant.gettype() == 'U') {
//                int userid = participant.getid();
//                String username = participant.getname();
//                float errExp = 0;
//                stmt = con.createStatement();
//                /* Changed By - Ruhi Hira, on - Dec 07' 2005, Bug # WFS_5_088. */
//                if (con.getAutoCommit()) {
//                    con.setAutoCommit(false);
//                }
//                // Tirupati Srivastava : changes in queries for PostgreSql dbase
//                ResultSet rs = stmt.executeQuery("Select ActivityID,PriorityLevel,ActivityName," + "ProcessDefId,QueueName,QueueType,AssignmentType,Q_QueueId,FilterValue,Q_UserID " + "from Worklisttable " + WFSUtil.getLockPrefixStr(dbType) + " where ProcessInstanceID = " + WFSUtil.TO_STRING(procInstID, true, dbType) + " and WorkItemID = " + wrkItemID + WFSUtil.getLockSuffixStr(dbType));
//                tempXml = new StringBuffer();
//                if (rs.next()) {
//                    activityId = rs.getInt(1);
//                    tempXml.append("\n<Workitem>\n");
//                    tempXml.append(gen.writeValueOf("WorkitemName", procInstID));
//                    tempXml.append(gen.writeValueOf("WorkitemID", String.valueOf(wrkItemID)));
//                    tempXml.append(gen.writeValueOf("ActivityInstanceId", String.valueOf(activityId)));
//                    tempXml.append(gen.writeValueOf("ProcessInstanceId", procInstID));
//                    tempXml.append(gen.writeValueOf("PriorityLevel", rs.getString(2)));
//                    String actName = rs.getString(3);
//                    int procDefID = rs.getInt(4);
//                    String qName = rs.getString(5);
//                    String qType = rs.getString(6);
//                    String aType = rs.getString(7);
//                    aType = rs.wasNull() ? "S" : aType;
//                    int qId = rs.getInt(8);
//                    int fltrVal = rs.getInt(9);
//                    int assnuserId = rs.getInt(10);
//                    int filterOpt = 0;
//                    String queueFilter = "";
//                    String filterValue = "";
//                    tempXml.append("\n<Participants>\n");
//                    tempXml.append(gen.writeValueOf("Participant", username));
//                    tempXml.append("\n</Participants>\n");
//                    tempXml.append("\n</Workitem>\n");
//                    if (rs != null) {
//                        rs.close();
//                    }
//                    if (!(aType.trim().equalsIgnoreCase("F") || aType.trim().equalsIgnoreCase("E"))) {
//                        rs = stmt.executeQuery(
//                                " Select DISTINCT QueueDefTable.QueueId, QueueDefTable.FilterOption, QueueDefTable.QueueFilter from QueueDefTable , Userqueuetable " + " where QueueDefTable.QueueID = Userqueuetable.QueueID " + " and QueueDefTable.QueueID = " + qId + " and UserId = " + userid);
//
//                        qId = -1; //For checking whether qId is get from resultset
//                        if (rs != null && rs.next()) {
//                            qId = rs.getInt(1);
//                            filterOpt = rs.getInt(2);
//                            queueFilter = rs.getString("QueueFilter");
//
//                            if (filterOpt == WFSConstant.WF_EQUAL || filterOpt == WFSConstant.WF_NOTEQ) {
//                                filterValue = " and filterValue" + (filterOpt == WFSConstant.WF_NOTEQ ? " != " : " = ") + userid;
//                            }
//                            rs.close();
//                        }
//                        if (qId == -1 && qType.trim().equalsIgnoreCase("U")) {
//                            qId = 0;
//                        }
//                        // SRNo-1 Added by Ashish Mangla Get user specific filter to add
//                        if (qId > 0) {
//                            String queryFilter = "";
//                            String[] result = null;
//                            result = WFSUtil.getQueryFilter(con, qId, dbType, participant, queueFilter);
//                            queryFilter = result[0];
//
//                            if (!queryFilter.trim().equals("")) {
//                                /* Bugzilla id 54, LockHint changes for DB2, 18/08/2006 - Ruhi Hira */
//                                StringBuffer strBuff = new StringBuffer(" SELECT ProcessInstanceId From ");
//                                strBuff.append(qType.trim().equalsIgnoreCase("F") ? " QueueDataTable " + WFSUtil.getTableLockHintStr(dbType) : " WFWorklistView_" + qId);
//                                strBuff.append(" WHERE ProcessInstanceId = '");
//                                strBuff.append(procInstID);
//                                strBuff.append("' AND WorkItemId = ");
//                                strBuff.append(wrkItemID);
//                                strBuff.append(" AND ( "); //QueryFilter is not NULL
//                                strBuff.append(queryFilter);
//                                strBuff.append(" ) ");
//                                strBuff.append(WFSUtil.getQueryLockHintStr(dbType));
//                                rs = stmt.executeQuery(strBuff.toString());
//                                if (rs != null & rs.next()) {
//                                    //let user lock workitems
//                                    rs.close();
//                                } else {
//                                    //set maincode to a value other than 0	--- Don't let user lock workitem
//                                    mainCode = WFSError.WM_INVALID_WORKITEM;
//                                    subCode = WFSError.WF_NO_AUTHORIZATION;
//                                    subject = WFSErrorMsg.getMessage(mainCode);
//                                    descr = WFSErrorMsg.getMessage(subCode);
//                                    errType = WFSError.WF_TMP;
//                                    if (rs != null) {
//                                        rs.close();
//                                    }
//                                }
//                            }
//                        }
//                    // SRNo-1 end Added by Ashish Mangla Get user specific filter to add
//                    } else { //case of fixed assigned workitems or Refer case workItems...
//                        if (assnuserId != userid) {
//                            qId = -1; //Don't let user lock the workItems
//                        } else {
//                            qId = 0; //MYQueue
//                        }
//                    }
//
//                    if (mainCode == 0) {
//                        if (qId != -1) {
//                            if (con.getAutoCommit()) {
//                                con.setAutoCommit(false);
//                            }
//                            // Tirupati Srivastava : changes in queries for PostgreSql dbase
//                            int res = stmt.executeUpdate(
//                                    " Insert into WorkinProcesstable (ProcessInstanceId,WorkItemId,ProcessName," + "ProcessVersion,ProcessDefID,LastProcessedBy,ProcessedBy,ActivityName,ActivityId,EntryDateTime," + "ParentWorkItemId,AssignmentType,CollectFlag,PriorityLevel,ValidTill,Q_StreamId,Q_QueueId,Q_UserId," + "AssignedUser,FilterValue,CreatedDateTime,WorkItemState,Statename,ExpectedWorkitemDelay,PreviousStage," + "LockedByName,LockStatus,LockedTime,Queuename,Queuetype) " + "Select ProcessInstanceId,WorkItemId,ProcessName,ProcessVersion,ProcessDefID,LastProcessedBy,ProcessedBy," + "ActivityName,ActivityId,EntryDateTime,ParentWorkItemId," + WFSUtil.TO_STRING(aType, true, dbType) + ",CollectFlag,PriorityLevel,ValidTill," + "Q_StreamId,Q_QueueId," + userid + "," + WFSUtil.TO_STRING(username, true, dbType) + ",FilterValue,CreatedDateTime,2," + WFSUtil.TO_STRING(WFSConstant.WF_RUNNING, true, dbType) + "," + "ExpectedWorkitemDelay,PreviousStage," + WFSUtil.TO_STRING(username, true, dbType) + "," + WFSUtil.TO_STRING("Y", true, dbType) + "," + WFSUtil.getDate(dbType) + ",Queuename,Queuetype " + "from Worklisttable where ProcessInstanceID = " + WFSUtil.TO_STRING(procInstID.trim(), true, dbType) + " and WorkItemID = " + wrkItemID + " and ActivityId = " + activityId + filterValue);
//                            if (res > 0) {
//                                // Tirupati Srivastava : changes in queries for PostgreSql dbase
//                                int f = stmt.executeUpdate("Delete from Worklisttable where ProcessInstanceID = " + WFSUtil.TO_STRING(procInstID.trim(), true, dbType) + " and WorkItemID = " + wrkItemID);
//                                stmt.close();
//                                /* Changed By - Ruhi Hira, on - Dec 07' 2005, Bug # WFS_5_088. */
//                                if (f == res) {
//                                    if (!con.getAutoCommit()) {
//                                        con.commit();
//                                        con.setAutoCommit(true);
//                                    }
//                                    WFSUtil.generateLog(engine, con, WFSConstant.WFL_WorkItemLock, procInstID, wrkItemID, procDefID,
//                                            activityId, actName, qId, userid, username, 0, qName, null, null, null, null);
//                                } else {
//                                    mainCode = WFSError.WM_INVALID_WORKITEM;
//                                    subCode = WFSError.WFS_NOQ;
//                                    if (!con.getAutoCommit()) {
//                                        con.rollback();
//                                        con.setAutoCommit(true);
//                                    }
//                                }
//                            } else {
//                                if (filterOpt == WFSConstant.WF_NOTEQ ? (fltrVal != userid)
//                                        : (filterOpt == WFSConstant.WF_EQUAL ? (fltrVal == userid) : true)) {
//                                    mainCode = WFSError.WM_LOCKED;
//                                    subCode = 0;
//                                } else {
//                                    mainCode = WFSError.WM_INVALID_WORKITEM;
//                                    subCode = WFSError.WF_NO_AUTHORIZATION;
//                                }
//                                stmt.close();
//                            }
//                        } else {
//                            mainCode = WFSError.WM_INVALID_WORKITEM;
//                            subCode = WFSError.WFS_NOQ;
//                        }
//                    }
//                } else {
//                    // Change By Dinesh Parikh For Backwork compatiblity of locked workitem
//                    // Tirupati Srivastava : changes in queries for PostgreSql dbase
//                    rs = stmt.executeQuery("Select Q_userid,ActivityID,PriorityLevel" + " from workinprocesstable where ProcessInstanceID = " + WFSUtil.TO_STRING(procInstID, true, dbType) + " and WorkItemID = " + wrkItemID);
//                    if (rs.next()) {
//                        if (rs.getInt(1) != userid) {
//                            mainCode = WFSError.WM_LOCKED;
//                            subCode = 0;
//                        } else {
//                            activityId = rs.getInt(2);
//                            tempXml.append("\n<Workitem>\n");
//                            tempXml.append(gen.writeValueOf("WorkitemName", procInstID));
//                            tempXml.append(gen.writeValueOf("WorkitemID", String.valueOf(wrkItemID)));
//                            tempXml.append(gen.writeValueOf("ActivityInstanceId", String.valueOf(activityId)));
//                            tempXml.append(gen.writeValueOf("ProcessInstanceId", procInstID));
//                            tempXml.append(gen.writeValueOf("PriorityLevel", rs.getString(3)));
//                            tempXml.append("\n<Participants>\n");
//                            tempXml.append(gen.writeValueOf("Participant", username));
//                            tempXml.append("\n</Participants>\n");
//                            tempXml.append("\n</Workitem>\n");
//                        }
//                        if (rs != null) {
//                            rs.close();
//                        }
//                    } else {
//                        // Tirupati Srivastava : changes in queries for PostgreSql dbase
//                        rs = stmt.executeQuery("Select AssignmentType from pendingworklisttable where ProcessInstanceID = " + WFSUtil.TO_STRING(procInstID, true, dbType) + " and WorkItemID = " + wrkItemID + " and Q_userid = " + userid);
//                        if (rs.next()) {
//                            if (rs.getString(1).equalsIgnoreCase("E")) {
//                                mainCode = WFSError.WM_INVALID_WORKITEM;
//                            }
//                            subCode = WFSError.WM_INVALID_STATE;
//                        } else {
//                            stmt.close();
//                            mainCode = WFSError.WM_INVALID_WORKITEM;
//                            subCode = 0;
//                        }
//                    }
//				}
//            } else {
//                mainCode = WFSError.WM_INVALID_SESSION_HANDLE;
//                subCode = 0;
//            }
//            if (mainCode == 0) {
//                outputXML = new StringBuffer(500);
//                outputXML.append(gen.createOutputFile("WMGetWorkItem"));
//                outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
//                outputXML.append(tempXml);
//                outputXML.append(gen.closeOutputFile("WMGetWorkItem"));
//            } else {
//                subject = WFSErrorMsg.getMessage(mainCode);
//                descr = WFSErrorMsg.getMessage(subCode);
//                errType = WFSError.WF_TMP;
//            }
//        } catch (SQLException e) {
//            WFSUtil.printErr(engine,"", e);
//            mainCode = WFSError.WM_INVALID_FILTER;
//            subCode = WFSError.WFS_SQL;
//            subject = WFSErrorMsg.getMessage(mainCode);
//            errType = WFSError.WF_FAT;
//            if (e.getErrorCode() == 0) {
//                if (e.getSQLState().equalsIgnoreCase("08S01")) {
//                    descr = (new JTSSQLError(e.getSQLState())).getMessage() + "(SQL State : " + e.getSQLState() + ")";
//                }
//            } else {
//                descr = e.getMessage();
//            }
//        } catch (NumberFormatException e) {
//            WFSUtil.printErr(engine,"", e);
//            mainCode = WFSError.WF_OPERATION_FAILED;
//            subCode = WFSError.WFS_ILP;
//            subject = WFSErrorMsg.getMessage(mainCode);
//            errType = WFSError.WF_TMP;
//            descr = e.toString();
//        } catch (NullPointerException e) {
//            WFSUtil.printErr(engine,"", e);
//            mainCode = WFSError.WF_OPERATION_FAILED;
//            subCode = WFSError.WFS_SYS;
//            subject = WFSErrorMsg.getMessage(mainCode);
//            errType = WFSError.WF_TMP;
//            descr = e.toString();
//        } catch (JTSException e) {
//            WFSUtil.printErr(engine,"", e);
//            mainCode = WFSError.WF_OPERATION_FAILED;
//            subCode = e.getErrorCode();
//            subject = WFSErrorMsg.getMessage(mainCode);
//            errType = WFSError.WF_TMP;
//            descr = e.getMessage();
//        } catch (Exception e) {
//            WFSUtil.printErr(engine,"", e);
//            mainCode = WFSError.WF_OPERATION_FAILED;
//            subCode = WFSError.WFS_EXP;
//            subject = WFSErrorMsg.getMessage(mainCode);
//            errType = WFSError.WF_TMP;
//            descr = e.toString();
//        } catch (Error e) {
//            WFSUtil.printErr(engine,"", e);
//            mainCode = WFSError.WF_OPERATION_FAILED;
//            subCode = WFSError.WFS_EXP;
//            subject = WFSErrorMsg.getMessage(mainCode);
//            errType = WFSError.WF_TMP;
//            descr = e.toString();
//        } finally {
//            try {
//                if (!con.getAutoCommit()) {
//                    con.rollback();
//                    con.setAutoCommit(true);
//                }
//
//                if (stmt != null) {
//                    stmt.close();
//                    stmt = null;
//                }
//            } catch (Exception e) {
//            }
//            if (mainCode != 0) {
//                throw new WFSException(mainCode, subCode, errType, subject, descr);
//            }
//
//        }
//        return outputXML.toString();
//    }
//    //----------------------------------------------------------------------------------------------------
//    //	Function Name 				:	WMCompleteWorkItem
//    //	Date Written (DD/MM/YYYY)	:	16/05/2002
//    //	Author						:	Prashant
//    //	Input Parameters			:	Connection , XMLParser , XMLGenerator
//    //	Output Parameters			:   none
//    //	Return Values				:	String
//    //	Description					:   Complete WorkItem
//    //----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//  Change Description          : Changes for Code Optimization-Merging of WorkFlow 
//								  tables to WFInstrumentTable and logging of Query
//  Changed by					: Mohnish Chopra  
    public String WMCompleteWorkItem(Connection con, XMLParser parser, XMLGenerator gen) throws JTSException, WFSException {
        StringBuffer outputXML = null;
        PreparedStatement pstmt = null;
        Statement st=null;
        ResultSet rs = null;
        int mainCode = 0;
        int subCode = 0;
        String subject = null;
        String descr = null;
        String errType = WFSError.WF_TMP;
        boolean done = false; /* In use before synchronous routing, for checking different cases in complete. */
        boolean doneFlag = false; /* To check weather workitem is to be picked by process server or not. */
        int auditor = 0;
        String auditorname = null;
        int auditee = 0;
        String auditeename = null;
        String auditeeQname = "MYQUEUE";
        /* Added By Varun Bhansaly On 19/07/2007 for Bugzilla Id 1439
        In case of Audit, instead of RouteLogTable, WorkInProcessTable will be Queried.
        associatedFieldName is concatenation of ProcessName_ActivityName */
        String associatedFieldName = null;
        String comments = "";
        String tableName = "WFRouteLogView";
        boolean bSynchronousRoutingFlag = false;
        ArrayList parameters = new ArrayList ();
        boolean debugFlag=false;
        String engine=null;
        String option = parser.getValueOf("Option", "", false);
        long startTime = 0l;
        long endTime = 0l;
        int userID = 0;
        int pWrkItemReferredBy = 0;
        boolean isCaseWorkStep = false;
        boolean allTasksCompleted = true;
        StringBuilder inputParamInfo = new StringBuilder();
        /** @todo for backward compatiblity, variable to be initialized on the basis of flag.*/
        try {
            int sessionID = parser.getIntOf("SessionId", 0, false);
            String procInstID = parser.getValueOf("ProcessInstanceId", "", false);
            int wrkItemID = parser.getIntOf("WorkItemId", 0, false);
            engine = parser.getValueOf("EngineName");
			boolean synchronousGenFlag = WFSUtil.isSyncRoutingMode();
			String synchronousRoutingFlag = parser.getValueOf("SynchronousRouting", "", true);
            boolean syncRoute = parser.getValueOf("SynchronousRouting","N",true).equalsIgnoreCase("Y");
			
            String actId = parser.getValueOf("ActivityId", null, true);
            if(synchronousRoutingFlag.equalsIgnoreCase("Y"))
                bSynchronousRoutingFlag = true;
            else if(synchronousRoutingFlag.equalsIgnoreCase(""))
                bSynchronousRoutingFlag = WFSUtil.isSyncRoutingMode();
            int dbType = ServerProperty.getReference().getDBType(engine);
            debugFlag = parser.getValueOf("DebugFlag", "N", true).equalsIgnoreCase("Y");
            //        StringBuffer tempXml = null; -no use
            int procDefID = 0;
            int activityId = -1;
			String actName = "";
			String completionTime = null;
			String entryDateTime = "";
            WFParticipant participant = WFSUtil.WFCheckSession(con, sessionID);
            inputParamInfo.append(gen.writeValueOf("SessionId", String.valueOf(sessionID)));
            inputParamInfo.append(gen.writeValueOf("UserName", (participant == null ? "" : participant.getname())));
            inputParamInfo.append(gen.writeValueOf("ProcessInstanceId", procInstID));
            inputParamInfo.append(gen.writeValueOf("WorkItemId", String.valueOf(wrkItemID)));
            int indx = procInstID.indexOf(" ");
            if(indx > -1)
                procInstID = procInstID.substring(0, indx);
            if (participant != null ) {
                userID = participant.getid();
				WFSUtil.printOut(engine,"Initial bSynchronousRoutingFlag => " + bSynchronousRoutingFlag);
                /**
				 * Changed by: Mohnish Chopra
				 * Change Description : Return Error if workitem has expired.
				 * 
				 */
            	/*if(WFSUtil.isWorkItemExpired(con, dbType, procInstID, wrkItemID, sessionID, userID, debugFlag, engine)){
    				
                 //   throw new WFSException(mainCode, subCode, errType, subject, descr);
                
    				    mainCode = WFSError.WF_OPERATION_FAILED;
    		            subCode = WFSError.WM_WORKITEM_EXPIRED;
    		            subject = WFSErrorMsg.getMessage(mainCode);
    		            errType = WFSError.WF_TMP;
    		            descr = WFSErrorMsg.getMessage(subCode);
    		            String strReturn = WFSUtil.generalError(option, engine, gen,
    	   	                   mainCode, subCode,
    	   	                   errType, subject,
    	   	                    descr);
    	   	             
    	   	        return strReturn;	
                
    			}*/
            	
                String username = participant.getname();

//                tempXml = new StringBuffer(100);
                /* Changed By Varun Bhansaly On 19/07/2007 for Bugzilla Id 1439 */
				// Process Variant Support
                /*pstmt = con.prepareStatement(
                        "Select WorkItemState, Q_UserId, ProcessDefID, ActivityId, ActivityName, " + 
                        "AssignmentType, QueueName, ParentWorkItemID, Q_QueueID, EntryDateTime, " + 
                        "ExpectedWorkitemDelay, EntryDatetime, " + WFSUtil.getDate(dbType) + ", LockedTime, 
                        LastProcessedBy, ProcessedBy, ProcessName, activityname,ProcessVariantId from WorkinProcessTable
                        " + WFSUtil.getTableLockHintStr(dbType) + " where ProcessInstanceID= ? and WorkItemID = ? " 
                        + WFSUtil.getQueryLockHintStr(dbType));*/
                // Change 1 for Code Optimization
                String query=
                    "Select WorkItemState, Q_UserId, ProcessDefID, ActivityId, ActivityName, " + "AssignmentType," +
                    " QueueName, ParentWorkItemID, Q_QueueID, EntryDateTime, " + "ExpectedWorkitemDelay, EntryDatetime, " +
                    "" + WFSUtil.getDate(dbType) + ", LockedTime, LastProcessedBy, ProcessedBy, ProcessName, activityname," +
                    "ProcessVariantId,ReferredTo,ReferredBy, CalendarName ,CollectFlag from WFInstrumentTable " + WFSUtil.getTableLockHintStr(dbType) +
                    " where ProcessInstanceID= ? and WorkItemID = ? and LockStatus = ? and RoutingStatus = ?" 
                    //and LOCKEDBYNAME=? and LOCKSTATUS =? and RoutingStatus = ?" 
                    + WFSUtil.getQueryLockHintStr(dbType);
                pstmt = con.prepareStatement(query);

                WFSUtil.DB_SetString(1, procInstID, pstmt, dbType);
                pstmt.setInt(2, wrkItemID);
                pstmt.setString(3, "Y");
                pstmt.setString(4, "N");
                parameters.add(procInstID);
                parameters.add(wrkItemID);
                parameters.add("Y");
                parameters.add("N");
              //  pstmt.setString(3, username);
             //   pstmt.setInt(4, wrkItemID);
             //   pstmt.setInt(5, wrkItemID);
              //  pstmt.execute();
                WFSUtil.jdbcExecute(procInstID, sessionID, userID, query, pstmt, parameters, debugFlag, engine);
                parameters.clear();
                
                rs = pstmt.getResultSet();
                if (rs.next()) {
                    int wState = rs.getInt(1);
                    int lockedBy = rs.getInt(2);
                    procDefID = rs.getInt(3);
                    inputParamInfo.append(gen.writeValueOf("ProcessDefId", String.valueOf(procDefID)));
                    activityId = rs.getInt(4);
                    actName = TO_SANITIZE_STRING(rs.getString(5),false);
                    String tStr = TO_SANITIZE_STRING(rs.getString(6),false);
                    char assgnType = rs.wasNull() ? '\0' : tStr.toUpperCase().charAt(0);
                    auditeeQname =TO_SANITIZE_STRING(rs.getString(7),false);
                    int pInstSt = 2;
                    int pWkItem = rs.getInt(8);
                    int qId = rs.getInt(9);
                    String date = TO_SANITIZE_STRING(rs.getString(10),false);
                    date = rs.wasNull() ? "" : WFSUtil.TO_DATE(date, true, dbType);
                    String expectedWkDelay =TO_SANITIZE_STRING(rs.getString(11),false);
                    entryDateTime = TO_SANITIZE_STRING(rs.getString(12),false);
                    String currentDate = TO_SANITIZE_STRING(rs.getString(13),false);
                    String lockedTime = TO_SANITIZE_STRING(rs.getString(14),false);
                    int procVariantId=rs.getInt("ProcessVariantId");////Process Variant Support
                    String sCollectFlag = TO_SANITIZE_STRING(rs.getString("CollectFlag"),false);
                    if (actId != null && !actId.equals(String.valueOf(activityId))) {
						mainCode = WFSError.WM_INVALID_ACTIVITY_INSTANCE;
						subCode = 0;
						subject = WFSErrorMsg.getMessage(mainCode);
						descr = WFSErrorMsg.getMessage(subCode);
						errType = WFSError.WF_TMP;
						WFSUtil.printErr(engine,"Inside WFSError.WM_INVALID_WORKITEM ");
					}
					else {
					int wkduration = WFSUtil.getTimeDiff(entryDateTime, currentDate, engine);
                    /* Added By Varun Bhansaly On 19/07/2007 for Bugzilla Id 1439 */
                    auditee = rs.getInt("LastProcessedBy");
                    auditeename = rs.getString("ProcessedBy");
                    associatedFieldName = rs.getString("ProcessName") + "_" + rs.getString("activityname");
                    /* Bugzilla Bug 885, activityId was hardcoded 0, 22/05/2007 - Ruhi Hira */
                    //WFCalAssocData wfCalAssocData = (WFCalAssocData) CachedObjectCollection.getReference().getCacheObject(con, engine, procDefID, WFSConstant.CACHE_CONST_CalCache, String.valueOf(activityId)).getData();
                    /* Bugzilla Bug 1175, Check for NULL, 19/06/2007 - Ruhi Hira * /
                    /*if (wfCalAssocData != null && wfCalAssocData.getTatCalFlag() == 'Y') {
                    wkduration = (int) WFCalUtil.getSharedInstance().subtractDate(entryDateTime,
                    new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.US).parse(currentDate),
                    wfCalAssocData.getProcessDefId(),
                    wfCalAssocData.getCalId()); //bug # 1608
                    }*/
                   /* if (rs != null) {
                        rs.close();
                        rs = null;
                    }
                    if (pstmt != null) {
                        pstmt.close();
                        pstmt = null;
                    }*/
                    int rfrBy = 0;
                    int rfrTo = 0;
					/*WFS_8.0_026*/
                    String calendarName = null;
					if (pWkItem > 0) {
		                // Change 2 for Code Optimization
                        /*pstmt = con.prepareStatement(
                                "Select ReferredTo,ReferredBy, CalendarName from QueueDataTable " + WFSUtil.getTableLockHintStr(dbType) + " " +
                                		"where " + "ProcessInstanceID= ? and WorkItemID = ? " + WFSUtil.getQueryLockHintStr(dbType));
                        WFSUtil.DB_SetString(1, procInstID, pstmt, dbType); //WFSUtil.DB_SetString(1, procInstID.toUpperCase(),pstmt,dbType);
                        pstmt.setInt(2, wrkItemID);
                        pstmt.execute();
                        rs = pstmt.getResultSet();
*/                        /*if (rs.next()) {*/
                            rfrTo = rs.getInt("ReferredTo");
                            rfrBy = rs.getInt("ReferredBy");
							calendarName = rs.getString("CalendarName");
                       /* }*/
                    }else{
				/*		pstmt = con.prepareStatement("Select CalendarName from QueueDataTable " + WFSUtil.getTableLockHintStr(dbType) + " where " + "ProcessInstanceID= ? and WorkItemID = ? " + WFSUtil.getQueryLockHintStr(dbType));
						WFSUtil.DB_SetString(1, procInstID, pstmt, dbType); //WFSUtil.DB_SetString(1, procInstID.toUpperCase(),pstmt,dbType);
                        pstmt.setInt(2, wrkItemID);
                        pstmt.execute();
                        rs = pstmt.getResultSet();
						if(rs.next()){  */
							calendarName = rs.getString("CalendarName");
						//}
					}
					WFSUtil.printOut(engine,"Before calcluating isContinuousBlock Flag => " + bSynchronousRoutingFlag);
					if(!bSynchronousRoutingFlag){
						//Changes for the Group Box Activities features in Asynchrounous mode in the iBPS.
	                	WFSUtil.printOut(engine, "case if the current & next activity both in the same group block");
		                boolean isContinuousBlock = false;
		                int currentBlockId = 0;
		                int nextBlockId = 0;
		                int nextActivityId = 0;
		                try{
		                	pstmt = con.prepareStatement("select A.BlockId, A.TargetActivity from ActivityTable A " + WFSUtil.getTableLockHintStr(dbType) 
		                				+ " where A.processdefid = ? and A.activityid = ?");
		                	pstmt.setInt(1, procDefID);
		                	pstmt.setInt(2, activityId);
		                	rs = pstmt.executeQuery();
		                	if(rs != null && rs.next()){
		                		currentBlockId = rs.getInt("BlockId");
		                		nextActivityId = rs.getInt("TargetActivity");
		                	}
		                	if(rs != null ){
		                		rs.close();
		                		rs = null;
		                	}
		                	if(pstmt != null){
		                		pstmt.close();
		                		pstmt = null;
		                	}
		                	if(currentBlockId > 0 && nextActivityId > 0){
		                		pstmt = con.prepareStatement("select A.BlockId from ActivityTable A  " + WFSUtil.getTableLockHintStr(dbType) 
		                				+ " where A.processdefid = ? and A.activityid = ?");
		                    	pstmt.setInt(1, procDefID);
		                    	pstmt.setInt(2, nextActivityId);
		                    	rs = pstmt.executeQuery();
		                    	if(rs != null && rs.next()){
		                    		nextBlockId = rs.getInt("BlockId");
		                    	}
		                    	if(rs != null ){
		                    		rs.close();
		                    		rs = null;
		                    	}
		                    	if(pstmt != null){
		                    		pstmt.close();
		                    		pstmt = null;
		                    	}
		                    	//Here currentBlockId > 0 and nextBlockId also > 0 then below condition will be true.
		                    	if(currentBlockId != nextBlockId){
		                    		isContinuousBlock = false;
		                    	}else{
		                    		isContinuousBlock = true;
		                    	}
		                	}
		                }catch(Exception ex){
		                	WFSUtil.printOut(engine, ex.getMessage());
		                	WFSUtil.printErr(engine, "Error occrred while calculating the BlockID, Error Message :: " + ex.getMessage(), ex);
		            		isContinuousBlock = false;
		                }
		                if(isContinuousBlock){
		                	bSynchronousRoutingFlag = true;
		                }
		                
		            	WFSUtil.printOut(engine, "currentActivityId : " + activityId + ", currentBlockId : " + currentBlockId + ", nextActivityId : " 
		            				+ nextActivityId + ", nextBlockId : " + nextBlockId + ", isContinuousBlock : " + isContinuousBlock + ", bSynchronousRoutingFlag" + bSynchronousRoutingFlag);
					}
					
					WFSUtil.printOut(engine,"Final bSynchronousRoutingFlag => " + bSynchronousRoutingFlag);
					
                        XMLParser parser1 = new XMLParser(parser.toString());
                        int activityType = 0;
                        String queryStr = "Select ActivityType from ActivityTable " + WFSUtil.getTableLockHintStr(dbType) + " where processdefid = ? and activityid = ?";
                        pstmt = con.prepareStatement(queryStr);
                        pstmt.setInt(1, procDefID);
                        pstmt.setInt(2, activityId);
                        rs = pstmt.executeQuery();
                        if (rs.next()) {
                            activityType = rs.getInt(1);
                        }
                        rs.close();
                        rs = null;
                        pstmt.close();
                        pstmt = null;
                        if (activityType == WFSConstant.ACT_INTRODUCTION) {
                            StringBuilder sWMStartProcessInputXML = new StringBuilder();

                            sWMStartProcessInputXML.append("<?xml version=\"1.0\"?><WMStartProcess_Input><Option>WMStartProcess</Option>");
                            sWMStartProcessInputXML.append("<EngineName>" + engine + "</EngineName>");
                            sWMStartProcessInputXML.append("<SessionId>" + sessionID + "</SessionId>");
                            sWMStartProcessInputXML.append("<ProcessInstanceId>" + parser.getValueOf("ProcessInstanceId", "", true) + "</ProcessInstanceId>");
                            sWMStartProcessInputXML.append("<WorkItemId>" + parser.getValueOf("WorkItemId", "", true) + "</WorkItemId>");
                            sWMStartProcessInputXML.append("<ActivityId>" + parser.getValueOf("ActivityId", "", true) + "</ActivityId>");
                            sWMStartProcessInputXML.append("</WMStartProcess_Input>");

                            parser1.setInputXML(sWMStartProcessInputXML.toString());
                            String sWMStartProcessOutputXML;
                            try {
                                sWMStartProcessOutputXML = WFFindClass.getReference().execute("WMStartProcess", engine, con, parser1, gen);
                            } catch (WFSException wfse) {
                                throw wfse;
                            }
                            return sWMStartProcessOutputXML;
                        }
					isCaseWorkStep =WFSUtil.isCaseWorkStepActivity(con, dbType, procDefID, activityId);
					boolean generateCaseSummaryDoc =false;
	            	if(isCaseWorkStep){
	            	allTasksCompleted =WFSUtil.isCompletedAllTasks(con, dbType, procInstID, wrkItemID, procDefID, activityId);
	            	generateCaseSummaryDoc = WFSUtil.isGenerationCaseDocRequired(con,dbType,procDefID, activityId);
	            	}
	            	if(!allTasksCompleted){
	            		mainCode = WFSError.WF_OPERATION_FAILED;
	            		subCode  = WFSError.WF_TASKS_NOT_COMPLETED;
	            		subject = WFSErrorMsg.getMessage(mainCode);
	            		descr = WFSErrorMsg.getMessage(subCode);
	            		errType = WFSError.WF_TMP;
	            		String strReturn = WFSUtil.generalError(option, engine, gen,
	    	   	                   mainCode, subCode,
	    	   	                   errType, subject,
	    	   	                    descr);
	    	   	             
	    	   	        return strReturn;	
	            	}else {
	            		String workitemIDFilter = "";
	                    String workitemIDFilter1="";
	                    if(wrkItemID == 1){
                            workitemIDFilter = " WorkItemID > 1";
                            workitemIDFilter1=" b.WorkItemID > 1";
	                    }
	                    else{
                            workitemIDFilter = " ( WorkItemID = " + wrkItemID + " OR ParentWorkItemID = " + wrkItemID + ") " ; // delete all child of this parent
                            workitemIDFilter1 = " ( b.WorkItemID = " + wrkItemID + " OR b.ParentWorkItemID = " + wrkItemID + ") " ;
	                    }
	                   
                        query = "Delete  from WFTaskStatusTable where processInstanceId = ? and workitemid = ? and processdefid = ? and activityid = ?";
                        
                        pstmt = con.prepareStatement(query);
                        WFSUtil.DB_SetString(1, procInstID, pstmt, dbType);
                        pstmt.setInt(2, wrkItemID);
                        pstmt.setInt(3, procDefID);
                        pstmt.setInt(4, activityId);
                        parameters.add(procInstID);
                        parameters.add(wrkItemID);
                        parameters.add(procDefID);
                        parameters.add(activityId);
                        WFSUtil.jdbcExecute(procInstID, sessionID, userID, query, pstmt, parameters, debugFlag, engine);
                        parameters.clear();
	            	}
	            	if(generateCaseSummaryDoc){
	            		WFSUtil.addToCaseSummaryQueue(con, dbType, procDefID,procInstID, wrkItemID, activityId, actName);
	            	}

					 if (rs != null) {
	                        rs.close();
	                        rs = null;
	                    }
	                    if (pstmt != null) {
	                        pstmt.close();
	                        pstmt = null;
	                    }
					/*WFS_8.0_049*/
                    if(debugFlag){
                        startTime  = System.currentTimeMillis();
                    }
					WFCalAssocData wfCalAssocData = WFSUtil.getWICalendarInfo(con, engine, procDefID, String.valueOf(activityId), calendarName);
					if (wfCalAssocData != null) {//do not consider wfCalAssocData.getTatCalFlag() while returing business difference
							try{
								WFSUtil.printOut(engine,"EntryDateTime:::="+entryDateTime);
								WFSUtil.printOut(engine,"currentDateTime:::="+currentDate);
								WFSUtil.printOut(engine,"CalId:::="+wfCalAssocData.getCalId());
								WFSUtil.printOut(engine,"ProcessDefId:::="+wfCalAssocData.getProcessDefId());
								wkduration = (int) WFCalUtil.getSharedInstance().subtractDate(new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.US).parse(entryDateTime), new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.US).parse(currentDate), wfCalAssocData.getProcessDefId(),wfCalAssocData.getCalId());
							}catch (Exception e){
								WFSUtil.printErr(engine,"", e);
							}
						}
                    
                    if(debugFlag){
                        endTime  = System.currentTimeMillis();
                        WFSUtil.writeLog("WMCompleteWorkitem", "[WMCompleteWorkitem]_Constant_cache", startTime, endTime, 0, "", "", engine,(endTime-startTime),sessionID, userID);  
                    }
                    char auditStatus = '\0';
                    if (assgnType == 'A' && pInstSt == 2 && (wState != 5 || wState != 6)) {
                        auditStatus = parser.getCharOf("AuditStatus", '\0', false);
                        auditor = userID;
                        auditorname = username;
                        if (auditStatus == 'R') {
                            comments = parser.getValueOf("Comments", "", true);
                            /* Changed By Varun Bhansaly On 19/07/2007 for Bugzilla Id 1439 */
                            auditeeQname = associatedFieldName;
                            String assignment = "R";
                            String myQueue = auditeename.trim() + WfsStrings.getMessage(1);
                            if (con.getAutoCommit()) {
                                con.setAutoCommit(false);
                            }
                            // Tirupati Srivastava : changes in queries for PostgreSql dbase
							// Process Variant Support
                            /*pstmt = con.prepareStatement(
                                    "Insert into Worklisttable (ProcessInstanceId," + "WorkItemId, ProcessName, ProcessVersion, " +
                                     "ProcessDefID,ProcessVariantId, LastProcessedBy, " + "ProcessedBy, ActivityName, ActivityId," +
                                     " EntryDateTime, ParentWorkItemId, " + "AssignmentType#, CollectFlag, PriorityLevel, ValidTill," +
                                     " Q_StreamId, Q_QueueId#, " + "Q_UserId, AssignedUser, CreatedDateTime, WorkItemState, " + "Statename," +
                                     "ExpectedWorkitemDelay, PreviousStage, Queuename, Queuetype) Select " + "ProcessInstanceId, " +
                                     "WorkItemId, ProcessName, ProcessVersion, ProcessDefID,ProcessVariantId, " + "LastProcessedBy," +
                                     " ProcessedBy, ActivityName, ActivityId, " + "EntryDatetime, ParentWorkItemId, "
                                     + WFSUtil.TO_STRING(assignment, true, dbType) + ", CollectFlag, PriorityLevel, ValidTill, "
                                     + "Q_StreamId, " + qId + ", " + auditee + ", " + WFSUtil.TO_STRING(auditeename, true, dbType) 
                                     + ", CreatedDateTime, 1, " + WFSUtil.TO_STRING(WFSConstant.WF_NOTSTARTED, true, dbType) 
                                     + ", ExpectedWorkitemDelay, PreviousStage, " + WFSUtil.TO_STRING(myQueue, true, dbType)
                                     + ", " + WFSUtil.TO_STRING("U", true, dbType) + " from WorkinProcesstable " 
                                     + " where ProcessInstanceID = ? and WorkItemID = ? "); */
                            // Updating AssignmentType , Q_QueueId not required to be updated
                            // Change 3 for Code Optimization
                            query=  "Update WFInstrumentTable set AssignmentType = ?,Q_QueueId=?, Q_UserId=? , AssignedUser=? , WorkItemState=? ," +
                            		"Statename=?,Queuename=?, Queuetype=?,LockStatus = ?,RoutingStatus=?,LockedByName=null,LockedTime=null, Q_DivertedByUserId = 0 where ProcessInstanceID = ? and " +
                            		"WorkItemID = ? and RoutingStatus = ? and LockStatus=? "; 
                            pstmt = con.prepareStatement(query);
                            
                               /*      "Select " + "ProcessInstanceId, " +
                                     "WorkItemId, ProcessName, ProcessVersion, ProcessDefID,ProcessVariantId, " + "LastProcessedBy," +
                                     " ProcessedBy, ActivityName, ActivityId, " + "EntryDatetime, ParentWorkItemId, "
                                     + WFSUtil.TO_STRING(assignment, true, dbType) + ", CollectFlag, PriorityLevel, ValidTill, "
                                     + "Q_StreamId, " + qId + ", " + auditee + ", " + WFSUtil.TO_STRING(auditeename, true, dbType) 
                                     + ", CreatedDateTime, 1, " + WFSUtil.TO_STRING(WFSConstant.WF_NOTSTARTED, true, dbType) 
                                     + ", ExpectedWorkitemDelay, PreviousStage, " + WFSUtil.TO_STRING(myQueue, true, dbType)
                                     + ", " + WFSUtil.TO_STRING("U", true, dbType) + " from WorkinProcesstable " 
                                     + " where ProcessInstanceID = ? and WorkItemID = ? ");
                            /**
                             * Bugzilla Id 61, 11/08/2006, PreparedStatement issue in DB2 - Ruhi Hira
                             */
                            pstmt.setString(1, assignment);
                            pstmt.setInt(2, qId);
                            pstmt.setInt(3, auditee);
                            pstmt.setString(4, auditeename);
                            pstmt.setInt(5, 1);
                            pstmt.setString(6,WFSConstant.WF_NOTSTARTED);
                            pstmt.setString(7,myQueue);
                            pstmt.setString(8,"U");
                            pstmt.setString(9,"N");
                            pstmt.setString(10,"N");
                            WFSUtil.DB_SetString(11, procInstID, pstmt, dbType);
                            pstmt.setInt(12, wrkItemID);
                            pstmt.setString(13, "N");
                            pstmt.setString(14, "Y");
                            
                            parameters.add(assignment);
                            parameters.add(qId);
                            parameters.add(auditee);
                            parameters.add(auditeename);
                            parameters.add(1);
                            parameters.add(WFSConstant.WF_NOTSTARTED);
                            parameters.add(myQueue);
                            parameters.add("U");
                            parameters.add("N");
                            parameters.add("N");
                            parameters.add(procInstID);
                            parameters.add(wrkItemID);
                            parameters.add("N");
                            parameters.add("Y");
                            
                            int res = WFSUtil.jdbcExecuteUpdate(procInstID, sessionID, userID, query, pstmt, parameters, debugFlag, engine);
                            //int res = pstmt.executeUpdate();
                            parameters.clear();
                            pstmt.close();
                            pstmt = null;
                            if (res > 0) {
                            	 if (!comments.equals("")) {
										// Process Variant Support
                                     pstmt = con.prepareStatement("Insert Into WFCommentsTable (ProcessDefId, ActivityId, ProcessInstanceId, WorkItemId, CommentsBy, CommentsByName, CommentsTo, CommentsToName, Comments, ActionDateTime, CommentsType ,ProcessVariantId) Values (?, ?, ?, ?, ?, ?, ?, ?, ?, " + WFSUtil.getDate(dbType) + ", ?,?)");
                                     pstmt.setInt(1, procDefID);
                                     pstmt.setInt(2, activityId);
                                     WFSUtil.DB_SetString(3, procInstID, pstmt, dbType);
                                     pstmt.setInt(4, wrkItemID);
                                     pstmt.setInt(5, userID);
                                     WFSUtil.DB_SetString(6, username, pstmt, dbType);
                                     pstmt.setInt(7, auditee);
                                     WFSUtil.DB_SetString(8, auditeename, pstmt, dbType);
                                     WFSUtil.DB_SetString(9, comments, pstmt, dbType);
                                     pstmt.setInt(10, WFSConstant.CONST_COMMENTS_AUDIT_REJECT);
                                     pstmt.setInt(11,procVariantId);
                                     if(debugFlag){
                                        startTime  = System.currentTimeMillis();
                                     }
                                     pstmt.executeUpdate();
                                     
                                    if(debugFlag){
                                        endTime  = System.currentTimeMillis();
                                        WFSUtil.writeLog("WMCompleteWorkitem", "[WMCompleteWorkitem]_CommentsTable", startTime, endTime, 0, "", "", engine,(endTime-startTime),sessionID, userID);  
                                    }
                                     pstmt.close();
                                     pstmt = null;
                                 }
//                                 if(!con.getAutoCommit()){
//                                     con.commit();
//                                     con.setAutoCommit(true);
//                                 }
                                 WFSUtil.generateLog(engine, con, WFSConstant.WFL_Reject, procInstID, wrkItemID, procDefID,
                                         activityId, actName, 0, auditor, auditorname, auditee, auditeeQname, null, null, null, null);


                                 done = true;
                                 
                                 // Change 4 for Code Optimization

                            	/*
                                pstmt = con.prepareStatement(
                                        "Delete from WorkinProcesstable where ProcessInstanceID = ? and WorkItemID = ? ");
                                WFSUtil.DB_SetString(1, procInstID.trim(), pstmt, dbType);
                                pstmt.setInt(2, wrkItemID);
                                int f = pstmt.executeUpdate();
                                pstmt.close();
                                pstmt = null;
                                 Changed By - Ruhi Hira, on - Dec 07' 2005, Bug # WFS_5_088. 
                                if (f == res) {
                                	
                                	
                                    if (!comments.equals("")) {
										// Process Variant Support
                                        pstmt = con.prepareStatement("Insert Into WFCommentsTable (ProcessDefId, ActivityId, ProcessInstanceId, WorkItemId, CommentsBy, CommentsByName, CommentsTo, CommentsToName, Comments, ActionDateTime, CommentsType ,ProcessVariantId) Values (?, ?, ?, ?, ?, ?, ?, ?, ?, " + WFSUtil.getDate(dbType) + ", ?,?)");
                                        pstmt.setInt(1, procDefID);
                                        pstmt.setInt(2, activityId);
                                        WFSUtil.DB_SetString(3, procInstID, pstmt, dbType);
                                        pstmt.setInt(4, wrkItemID);
                                        pstmt.setInt(5, userID);
                                        WFSUtil.DB_SetString(6, username, pstmt, dbType);
                                        pstmt.setInt(7, auditee);
                                        WFSUtil.DB_SetString(8, auditeename, pstmt, dbType);
                                        WFSUtil.DB_SetString(9, comments, pstmt, dbType);
                                        pstmt.setInt(10, WFSConstant.CONST_COMMENTS_AUDIT_REJECT);
                                        pstmt.setInt(11,procVariantId);
                                        pstmt.executeUpdate();
                                        pstmt.close();
                                        pstmt = null;
                                    }
//                                    if(!con.getAutoCommit()){
//                                        con.commit();
//                                        con.setAutoCommit(true);
//                                    }
                                    WFSUtil.generateLog(engine, con, WFSConstant.WFL_Reject, procInstID, wrkItemID, procDefID,
                                            activityId, actName, 0, auditor, auditorname, auditee, auditeeQname, null, null, null, null);


                                    done = true;
                                } else {
                                    mainCode = WFSError.WM_INVALID_WORKITEM;
                                    subCode = WFSError.WFS_NOQ;
                                    if (!con.getAutoCommit()) {
                                        con.rollback();
                                        con.setAutoCommit(true);
                                    }
                                }
                            */} else {
                                mainCode = WFSError.WM_INVALID_WORKITEM;
                                subCode = WFSError.WFS_NOQ;
                                if (!con.getAutoCommit()) {
                                    con.rollback();
                                    con.setAutoCommit(true);
                                }
                            }
                        }
                    } else if (assgnType == 'R' && pInstSt == 2 && (wState != 5 || wState != 6)) {
                        auditee = userID;
                        auditeename = username;
                        pstmt = con.prepareStatement(
                                " select Auditoruserindex from UserWorkAudittable " + WFSUtil.getTableLockHintStr(dbType) + "" +
                                " where AuditActivityId =  ? and UserIndex = ? and ProcessDefID = ? " 
                                + WFSUtil.getQueryLockHintStr(dbType));
                        pstmt.setInt(1, activityId);
                        pstmt.setInt(2, auditee);
                        pstmt.setInt(3, procDefID);
                        pstmt.execute();
                        rs = pstmt.getResultSet();
                        if (rs.next()) {
                            auditor = rs.getInt(1);
                            rs.close();
                            rs = null;
                            pstmt.close();
                            pstmt = null;
                            pstmt = con.prepareStatement(
                                    " Select AssignedUserindex from Userdiversiontable " + WFSUtil.getTableLockHintStr(dbType)
                                    + " where Diverteduserindex = ? and fromDate < " + WFSUtil.getDate(dbType) + "  and toDate > "
                                    + WFSUtil.getDate(dbType) + WFSUtil.getQueryLockHintStr(dbType));
                            pstmt.setInt(1, auditor);
                            pstmt.execute();
                            rs = pstmt.getResultSet();
                            if (rs.next()) {
                                auditor = rs.getInt(1);
                            }
                            if (rs != null) {
                                rs.close();
                                rs = null;
                            }
                            if (pstmt != null) {
                                pstmt.close();
                                pstmt = null;
                            }
                            pstmt = con.prepareStatement(
                                    " Select Username from WFUserView where UserIndex = ? ");
                            pstmt.setInt(1, auditor);
                            pstmt.execute();
                            rs = pstmt.getResultSet();
                            if (rs.next()) {
                                auditorname = rs.getString(1);
                                rs.close();
                                rs = null;
                                pstmt.close();
                                pstmt = null;
                                qId = 0;
                                String myQueue = auditorname.trim() + WfsStrings.getMessage(1);
                                //----------------------------------------------------------------------------
                                // Changed By	                        : Varun Bhansaly
                                // Changed On                           : 17/01/2007
                                // Reason                        	: Bugzilla Id 54
                                // Change Description			: Provide Dirty Read Support for DB2 Database
                                //----------------------------------------------------------------------------

                                // Tirupati Srivastava : changes in queries for PostgreSql dbase
                                pstmt = con.prepareStatement(" Select QueueName , a.QueueId from QuserGroupView a , QueueDefTable b " +
                                		"where a.QueueId =  b.QueueId  and QueueType = " + WFSUtil.TO_STRING("U", true, dbType) + " " +
                                		"and UserID = ? " + WFSUtil.getQueryLockHintStr(dbType));
                                pstmt.setInt(1, auditor);
                                if(debugFlag){
                                    startTime  = System.currentTimeMillis();
                                }
                                pstmt.execute();
                                rs = pstmt.getResultSet();
                                
                                if(debugFlag){
                                    endTime  = System.currentTimeMillis();
                                    WFSUtil.writeLog("WMCompleteWorkitem", "[WMCompleteWorkitem]_QueueQuery", startTime, endTime, 0, "", "", engine,(endTime-startTime),sessionID, userID);  
                                }
                                if (rs.next()) {
                                    myQueue = rs.getString(1);
                                    qId = rs.getInt(2);
                                }
                                if (rs != null) {
                                    rs.close();
                                    rs = null;
                                }
                                if (pstmt != null) {
                                    pstmt.close();
                                    pstmt = null;
                                }
                                if (con.getAutoCommit()) {
                                    con.setAutoCommit(false);
                                }
                                // Tirupati Srivastava : changes in queries for PostgreSql dbase
								// Process Variant Support
                        /*        pstmt = con.prepareStatement(
                                        "Insert into Worklisttable (ProcessInstanceId, " + "WorkItemId, ProcessName," +
                                        " ProcessVersion, ProcessDefID,ProcessVariantId, LastProcessedBy, " + "ProcessedBy," +
                                        " ActivityName, ActivityId, EntryDateTime, ParentWorkItemId, " + "AssignmentType, CollectFlag," +
                                        " PriorityLevel, ValidTill, Q_StreamId, Q_QueueId, " + "Q_UserId, AssignedUser, CreatedDateTime, " +
                                        "WorkItemState, " + "Statename, ExpectedWorkitemDelay, PreviousStage, Queuename, Queuetype) " +
                                        "Select " + "ProcessInstanceId, WorkItemId, ProcessName, ProcessVersion, ProcessDefID," +
                                        "ProcessVariantId, " + "LastProcessedBy, ProcessedBy, ActivityName, ActivityId, " 
                                        + "EntryDatetime, ParentWorkItemId, " + WFSUtil.TO_STRING("A", true, dbType) 
                                        + ", CollectFlag, PriorityLevel, ValidTill, "
                                        + "Q_StreamId, " + qId + ", " + auditor + ", " 
                                        + WFSUtil.TO_STRING(auditorname, true, dbType) + ", CreatedDateTime, 1, "
                                        + WFSUtil.TO_STRING(WFSConstant.WF_NOTSTARTED, true, dbType) + ", ExpectedWorkitemDelay, "
                                        + "PreviousStage, " + WFSUtil.TO_STRING(myQueue, true, dbType) + ", "
                                        + WFSUtil.TO_STRING("U", true, dbType) + " from WorkinProcesstable where ProcessInstanceID = ? and WorkItemID = ? ");*/
                                /**
                                 * Bugzilla Id 61, 11/08/2006, PreparedStatement issue in DB2 - Ruhi Hira
                                 */

                                // Change 5 for Code Optimization
                                query=
                                    "Update WFInstrumentTable set AssignmentType = ?,Q_QueueId=?, Q_UserId=? , AssignedUser=? , WorkItemState=? ," +
                                    "Statename=?, Queuename=?, Queuetype=?,LockStatus = ?,RoutingStatus=?,LockedByName=null,LockedTime=null, Q_DivertedByUserId = 0 where ProcessInstanceID = ? and WorkItemID = ? and LockStatus=? " +
                                    "and RoutingStatus = ?" ;
                                pstmt = con.prepareStatement(query);
                                pstmt.setString(1, "A");
                                pstmt.setInt(2, qId);
                                pstmt.setInt(3, auditor);
                                pstmt.setString(4, auditorname);
                                pstmt.setInt(5, 1);
                                pstmt.setString(6,WFSConstant.WF_NOTSTARTED);
                                pstmt.setString(7,myQueue);
                                pstmt.setString(8,"U");
                                pstmt.setString(9,"N");
                                pstmt.setString(10,"N");
                                WFSUtil.DB_SetString(11, procInstID, pstmt, dbType);
                                pstmt.setInt(12, wrkItemID);
                                pstmt.setString(13,"Y");
                                pstmt.setString(14,"N");                               
                                parameters.add("A");
                                parameters.add(qId);
                                parameters.add(auditor);
                                parameters.add(auditorname);
                                parameters.add(1);
                                parameters.add(WFSConstant.WF_NOTSTARTED);
                                parameters.add(myQueue);
                                parameters.add("U");
                                parameters.add("N");
                                parameters.add("N");
                                parameters.add(procInstID);
                                parameters.add(wrkItemID);
                                parameters.add("Y");
                                parameters.add("N");
                                int res =WFSUtil.jdbcExecuteUpdate(procInstID, sessionID, userID, query, pstmt, parameters, debugFlag, engine);
                                //int res = pstmt.executeUpdate();
                                parameters.clear();
                                
                                pstmt.close();
                                pstmt = null;
                                 /* Changed By - Ruhi Hira, on - Dec 07' 2005, Bug # WFS_5_088. */
                                if (res > 0) {
                                    done = true;
                                    // Change 6 for Code Optimization

                   /*                 pstmt = con.prepareStatement(
                                            "Delete from WorkinProcesstable where ProcessInstanceID = ? and WorkItemID = ? ");
                                    WFSUtil.DB_SetString(1, procInstID.trim(), pstmt, dbType);
                                    pstmt.setInt(2, wrkItemID);
                                    int f = pstmt.executeUpdate();
                                    pstmt.close();
                                    pstmt = null;*/
/*                                    if (f == res) {
//                                        if(!con.getAutoCommit()){
//                                            con.commit();
//                                            con.setAutoCommit(true);
//                                        }

                                        done = true;
                                    } else {
                                        mainCode = WFSError.WM_INVALID_WORKITEM;
                                        subCode = WFSError.WFS_NOQ;
                                        if (!con.getAutoCommit()) {
                                            con.rollback();
                                            con.setAutoCommit(true);
                                        }
                                    }*/
                                } else {
                                    mainCode = WFSError.WM_INVALID_WORKITEM;
                                    subCode = WFSError.WFS_NOQ;
                                    if (!con.getAutoCommit()) {
                                        con.rollback();
                                        con.setAutoCommit(true);
                                    }
                                }
                            } else {
                                if (rs != null) {
                                    rs.close();
                                    rs = null;
                                }
                                if (pstmt != null) {
                                    pstmt.close();
                                    pstmt = null;
                                }
                            }
                        } else {
                            if (rs != null) {
                                rs.close();
                                rs = null;
                            }
                            if (pstmt != null) {
                                pstmt.close();
                                pstmt = null;
                            }
                        }
                    } else if (assgnType == 'E' && wState == 2 && rfrTo == 0 && rfrBy != 0) { 
                    	//Ashish added WFS_6_008 added condition "rfrBy != 0" also in the list
                        if (con.getAutoCommit()) {
                            con.setAutoCommit(false);
                        }
                        pstmt = con.prepareStatement("Select Q_QueueId from WFInstrumentTable " + WFSUtil.getTableLockHintStr(dbType) + " where ProcessInstanceID = ? and WorkItemID = ? And RoutingStatus = ? ");
                        WFSUtil.DB_SetString(1, procInstID, pstmt, dbType);
                        pstmt.setInt(2, pWkItem);
                        WFSUtil.DB_SetString(3, "R", pstmt, dbType);
                      //  WFSUtil.DB_SetString(4, "N", pstmt, dbType);
                        pstmt.execute();
                        ResultSet rs1 =  pstmt.getResultSet();
                        if (rs1.next()) {
                            qId = rs1.getInt(1);
                        }
                        if (rs1 != null) {
                            rs1.close();
                            rs1 = null;
                        }
                        if (pstmt != null) {
                                pstmt.close();
                                pstmt = null;
                            }
                        
                        pstmt = con.prepareStatement("Select ReferredBy from WFInstrumentTable " + WFSUtil.getTableLockHintStr(dbType) + " where ProcessInstanceID = ? and WorkItemID = ?");
                        WFSUtil.DB_SetString(1, procInstID, pstmt, dbType);
                        pstmt.setInt(2, pWkItem);
                        pstmt.execute();
                        rs1 =  pstmt.getResultSet();
                        if (rs1.next()) {
                            pWrkItemReferredBy = rs1.getInt(1);
                        }
                        if (rs1 != null) {
                            rs1.close();
                            rs1 = null;
                        }
                        if (pstmt != null) {
                                pstmt.close();
                                pstmt = null;
                        }
                        // Tirupati Srivastava : changes in queries for PostgreSql dbase
						// Process Variant Support
/*                        pstmt = con.prepareStatement(
                                "Insert into Worklisttable (ProcessInstanceId, " + "WorkItemId, ProcessName, ProcessVersion," +
                                " ProcessDefID,ProcessVariantId, LastProcessedBy, " + "ProcessedBy, ActivityName, ActivityId," +
                                " EntryDateTime, ParentWorkItemId, " + "AssignmentType, CollectFlag, PriorityLevel, ValidTill, " +
                                "Q_StreamId, Q_QueueId, " + "Q_UserId, AssignedUser, CreatedDateTime, WorkItemState, " + "Statename, " +
                                "ExpectedWorkitemDelay, PreviousStage, Queuename, Queuetype) Select " + "ProcessInstanceId," +
                                " WorkItemId, ProcessName, ProcessVersion, ProcessDefID,ProcessVariantId, " + "LastProcessedBy," +
                                " ProcessedBy, ActivityName, ActivityId, " + "EntryDatetime, ParentWorkItemId, " + "AssignmentType, " +
                                "CollectFlag, PriorityLevel, ValidTill, " //Bugzilla Bug 637 (Assignment type not changed as while refering original AssignmentType is there in pendingWorklisttable
                                + "Q_StreamId, Q_QueueId, Q_UserId, AssignedUser, CreatedDateTime, 2, "
                                + WFSUtil.TO_STRING(WFSConstant.WF_RUNNING, true, dbType) + ", ExpectedWorkitemDelay, " 
                                + "PreviousStage, QueueName, QueueType from PendingWorklisttable" +
                                " where ProcessInstanceID = ? and WorkItemID = ? ");*/
                        //Need to check if AssignmentType needs to be updated.
                        // Change 7 for Code Optimization
                        /*query= "Update WFInstrumentTable set WorkItemState=? ," +
                        "Statename=?, LockStatus = ?,RoutingStatus=?,LockedByName=null,LockedTime=null,Q_UserId=0,Q_QueueId=0, Q_DivertedByUserId = 0 where ProcessInstanceID = ? and WorkItemID = ? and RoutingStatus= ? " ;*/
						
                        //query = "Update WFInstrumentTable set WorkItemState=? ,Statename=?, Q_DivertedByUserId=?, LockStatus = ?,RoutingStatus=? ,LockedByName=null,LockedTime=null where ProcessInstanceID = ? and WorkItemID = ? and RoutingStatus= ?" ;								
			query = "Update WFInstrumentTable set WorkItemState=? ,Statename=?, "
                                + "Q_DivertedByUserId=?, LockStatus = ?,RoutingStatus=? ,LockedByName=null,"
                                + "LockedTime=null, AssignmentType = ? where ProcessInstanceID = ? and WorkItemID = ? "
                                + "and RoutingStatus= ?" ;											
                        pstmt = con.prepareStatement(query);
/*                        WFSUtil.DB_SetString(1, procInstID, pstmt, dbType);
                        pstmt.setInt(2, pWkItem);*/
                        pstmt.setInt(1, 2);
                        pstmt.setString(2,WFSConstant.WF_RUNNING);
						pstmt.setInt(3, 0);
                        pstmt.setString(4,"N");
                        pstmt.setString(5,"N");
                        if(pWrkItemReferredBy!=0){
                        	 WFSUtil.DB_SetString(6, "E", pstmt, dbType);
                        }
                        else{
                            WFSUtil.DB_SetString(6, (qId > 0 ?"S" : "F"), pstmt, dbType);
                        }
                        WFSUtil.DB_SetString(7, procInstID, pstmt, dbType);
                        pstmt.setInt(8, pWkItem);
                        pstmt.setString(9, "R");
                        
                        parameters.add(2);
                        parameters.add(WFSConstant.WF_RUNNING);
                        parameters.add("N");
                        parameters.add("N");
                        parameters.add(procInstID);
                        parameters.add(pWkItem);
                        parameters.add("R");
                        int res = WFSUtil.jdbcExecuteUpdate(procInstID, sessionID, userID, query, pstmt, parameters, debugFlag, engine);
                        //int res = pstmt.executeUpdate();
	                    parameters.clear();    
                        pstmt.close();
                        pstmt = null;
                        if (res > 0) {

                        	// Change 8 for Code Optimization
                        	/*pstmt = con.prepareStatement(
                             "Update QueueDataTable Set ReferredToName = null, ReferredTo = null where ProcessInstanceID = ? and WorkItemID = ?");*/
                            query="Update WFInstrumentTable Set ReferredToName = null, ReferredTo = null where " +
                            "ProcessInstanceID = ? and WorkItemID = ?";
                            pstmt = con.prepareStatement(query);
                            WFSUtil.DB_SetString(1, procInstID, pstmt, dbType);
                            pstmt.setInt(2, pWkItem);
                            parameters.add(procInstID);
                            parameters.add(pWkItem);
                            //int res1 = pstmt.executeUpdate();
                            int res1 =WFSUtil.jdbcExecuteUpdate(procInstID, sessionID, userID, query, pstmt, parameters, debugFlag, engine);
                            parameters.clear();
                            pstmt.close();
                            pstmt = null;
                            query=
                                "Delete from WFInstrumentTable where ProcessInstanceID = ? and WorkItemID = ?";
                            pstmt = con.prepareStatement(query);
                            WFSUtil.DB_SetString(1, procInstID, pstmt, dbType);
                            pstmt.setInt(2, wrkItemID);
                            parameters.add(procInstID);
                            parameters.add(wrkItemID);
                            int res2 =WFSUtil.jdbcExecuteUpdate(procInstID, sessionID, userID, query, pstmt, parameters, debugFlag, engine);
                            parameters.clear();
                            //int res2 = pstmt.executeUpdate();
                            pstmt.close();
                            pstmt = null;
                            // Change 9 for Code Optimization

                /*            pstmt = con.prepareStatement(
                                    "Delete from WorkinProcessTable where ProcessInstanceID = ? and WorkItemID = ?");
                            WFSUtil.DB_SetString(1, procInstID, pstmt, dbType);
                            pstmt.setInt(2, wrkItemID);
                            int res3 = pstmt.executeUpdate();*/

                           /* pstmt = con.prepareStatement(
                                    "Delete from PendingWorklistTable where ProcessInstanceID = ? and WorkItemID = ?");
                            WFSUtil.DB_SetString(1, procInstID, pstmt, dbType);
                            pstmt.setInt(2, pWkItem);
                            int res4 = pstmt.executeUpdate();
                            pstmt.close();
                            pstmt = null;*/
                            if (res1 > 0 && res2 > 0 //&& res3 > 0 && res4 > 0
                            		) {
//                                if(!con.getAutoCommit()){
//                                    con.commit();
//                                    con.setAutoCommit(true);
//                                }
                                done = true;
                                pstmt = con.prepareStatement("Select Username from WFUserView where UserIndex = ?");
                                pstmt.setInt(1, rfrBy);
                                pstmt.execute();
                                rs = pstmt.getResultSet();
                                String rfrByName = "";
                                if (rs.next()) {
                                    rfrByName = rs.getString(1);
                                }
                                if (rs != null) {
                                    rs.close();
                                    rs = null;
                                }
                                if (pstmt != null) {
                                    pstmt.close();
                                    pstmt = null;
                                }
                                WFSUtil.generateLog(engine, con, WFSConstant.WFL_WorkItemSubmit, procInstID, wrkItemID, procDefID,
                                        activityId, actName, 0, userID, username, rfrBy, rfrByName, null, null, null, null);
                            } else {
                                mainCode = WFSError.WM_INVALID_WORKITEM;
                                subCode = WFSError.WFS_NOQ;
                                if (!con.getAutoCommit()) {
                                    con.rollback();
                                    con.setAutoCommit(true);
                                }
                            }
                        }
                    }
                    if (!done && (wState == 2 || wState == 4) && lockedBy == userID) {
                        if (assgnType != 'A' && pInstSt == 2) {
                            auditee = userID;
                            auditeename = username;

                            pstmt = con.prepareStatement(
                                    " select Auditoruserindex , Percentageaudit , WorkItemCount from UserWorkAudittable " 
                            		+ WFSUtil.getTableLockHintStr(dbType) + " where AuditActivityId =  ? and UserIndex = ? and ProcessDefID = ? " 
                            		+ WFSUtil.getQueryLockHintStr(dbType));
                            pstmt.setInt(1, activityId);
                            pstmt.setInt(2, auditee);
                            pstmt.setInt(3, procDefID);
                            pstmt.execute();
                            rs = pstmt.getResultSet();
                            if (rs.next()) {
                                auditor = rs.getInt(1);
                                int prcnt = rs.getInt(2);
                                BigInteger b = new BigInteger(rs.getString(3), Character.MAX_RADIX);
                                rs.close();
                                rs = null;
                                pstmt.close();
                                pstmt = null;

                                if (b.bitLength() == 1) {
                                    b = new BigInteger(WFSUtil.generateRandomPattern(prcnt,
                                            Character.MAX_RADIX), Character.MAX_RADIX);
                                }

                                if (b.testBit(0)) {
                                    pstmt = con.prepareStatement(
                                            " Select AssignedUserindex from Userdiversiontable " + WFSUtil.getTableLockHintStr(dbType) + "  where Diverteduserindex = ? and fromDate < "
                                    		+ WFSUtil.getDate(dbType) + "  and toDate > " + WFSUtil.getDate(dbType) + " ");
                                    pstmt.setInt(1, auditor);
                                    pstmt.execute();
                                    rs = pstmt.getResultSet();
                                    if (rs.next()) {
                                        auditor = rs.getInt(1);
                                    }
                                    if (rs != null) {
                                        rs.close();
                                        rs = null;
                                    }
                                    if (pstmt != null) {
                                        pstmt.close();
                                        pstmt = null;
                                    }

                                    pstmt = con.prepareStatement(
                                            " Select Username from WFUserView where UserIndex = ? ");
                                    pstmt.setInt(1, auditor);
                                    pstmt.execute();
                                    rs = pstmt.getResultSet();
                                    if (rs.next()) {
                                        auditorname = rs.getString(1);
                                        rs.close();
                                        rs = null;
                                        pstmt.close();
                                        pstmt = null;

                                        qId = 0;

                                        String myQueue = auditorname.trim() + WfsStrings.getMessage(1);
                                        //----------------------------------------------------------------------------
                                        // Changed By	                : Varun Bhansaly
                                        // Changed On                       : 17/01/2007
                                        // Reason                        	: Bugzilla Id 54
                                        // Change Description		: Provide Dirty Read Support for DB2 Database
                                        //----------------------------------------------------------------------------

                                        // Tirupati Srivastava : changes in queries for PostgreSql dbase
                                        pstmt = con.prepareStatement(" Select QueueName , a.QueueId from QuserGroupView a , " +
                                        		"QueueDefTable b " + WFSUtil.getTableLockHintStr(dbType) + "  where a.QueueId =  b.QueueId  and QueueType = " + WFSUtil.TO_STRING("U", true, dbType) 
                                        		+ " and UserID = ? " + WFSUtil.getQueryLockHintStr(dbType));
                                        pstmt.setInt(1, auditor);
                                        if(debugFlag){
                                            startTime  = System.currentTimeMillis();
                                        }
                                        pstmt.execute();
                                        rs = pstmt.getResultSet();
                                        
                                        if(debugFlag){
                                            endTime  = System.currentTimeMillis();
                                            WFSUtil.writeLog("WMCompleteWorkitem", "[WMCompleteWorkitem]_QueueQuery2", startTime, endTime, 0, "", "", engine,(endTime-startTime),sessionID, userID);  
                                        }
                                        if (rs.next()) {
                                            myQueue = rs.getString(1);
                                            qId = rs.getInt(2);
                                        }
                                        if (rs != null) {
                                            rs.close();
                                            rs = null;
                                        }
                                        if (pstmt != null) {
                                            pstmt.close();
                                            pstmt = null;
                                        }
                                        if (con.getAutoCommit()) {
                                            con.setAutoCommit(false);
                                        }
                                        // Tirupati Srivastava : changes in queries for PostgreSql dbase
										// Process Variant Support
                                      /*  pstmt = con.prepareStatement(
                                                "Insert into Worklisttable (ProcessInstanceId, " + "WorkItemId, ProcessName, ProcessVersion," +
                                                " ProcessDefID,ProcessVariantId, LastProcessedBy, " + "ProcessedBy, ActivityName, ActivityId," +
                                                " EntryDateTime, ParentWorkItemId, " + "AssignmentType, CollectFlag, PriorityLevel, ValidTill," +
                                                " Q_StreamId, Q_QueueId, " + "Q_UserId, AssignedUser, CreatedDateTime, WorkItemState, " + 
                                                "Statename, ExpectedWorkitemDelay, PreviousStage, Queuename, Queuetype) Select " +
                                                "ProcessInstanceId, WorkItemId, ProcessName, ProcessVersion, ProcessDefID,ProcessVariantId, " +
                                                "" + userID + ", " + WFSUtil.TO_STRING(username, true, dbType) + ", ActivityName, ActivityId, " +
                                                "" + "EntryDatetime, ParentWorkItemId, " + WFSUtil.TO_STRING("A", true, dbType)
                                                + ", CollectFlag, PriorityLevel, ValidTill, " + "Q_StreamId, " + qId + ", " + auditor + ", " 
                                                + WFSUtil.TO_STRING(auditorname, true, dbType) + " , CreatedDateTime, 1, " 
                                                + WFSUtil.TO_STRING(WFSConstant.WF_NOTSTARTED, true, dbType) + ", ExpectedWorkitemDelay, " 
                                                + "PreviousStage," + WFSUtil.TO_STRING(myQueue, true, dbType) + " , " 
                                                + WFSUtil.TO_STRING("U", true, dbType) + " from WorkinProcesstable where ProcessInstanceID = ? " +
                                                "and WorkItemID = ? ");*/
                                        // Change 10 for Code Optimization

                                        query=
                                            "Update WFInstrumentTable set LastProcessedBy=?,ProcessedBy=? ,AssignmentType = ?,Q_QueueId=?, Q_UserId=? ," +
                                            " AssignedUser=? , WorkItemState=? ,Statename=?, Queuename=?, Queuetype=?,LockStatus = ?," +
                                            "RoutingStatus=?,LockedByName=null,LockedTime=null, Q_DivertedByUserId = 0, NotifyStatus = ? where ProcessInstanceID = ? and WorkItemID = ? and LockStatus = ? and RoutingStatus = ? " ;
                                        pstmt = con.prepareStatement(query);
                                        pstmt.setInt(1, participant.gettype()=='P' ? 0 : userID);
                                        pstmt.setString(2,participant.gettype()=='P' ? "System" : username);
                                        pstmt.setString(3, "A");
                                        pstmt.setInt(4, qId);
                                        pstmt.setInt(5, auditor);
                                        pstmt.setString(6, auditorname);
                                        pstmt.setInt(7, 1);
                                        pstmt.setString(8,WFSConstant.WF_NOTSTARTED);
                                        pstmt.setString(9,myQueue);
                                        pstmt.setString(10,"U");
                                        pstmt.setString(11,"N");
                                        pstmt.setString(12,"N");
                                        pstmt.setString(13,"N");
                                        WFSUtil.DB_SetString(14, procInstID, pstmt, dbType);
                                        pstmt.setInt(15, wrkItemID);
                                        pstmt.setString(16, "Y");
                                        pstmt.setString(17, "N");
                                        parameters.add(participant.gettype()=='P' ? 0 : userID);
                                        parameters.add(participant.gettype()=='P' ? "System" : username);
                                        parameters.add("A");
                                        parameters.add(qId);
                                        parameters.add(auditor);
                                        parameters.add(auditorname);
                                        parameters.add(1);
                                        parameters.add(WFSConstant.WF_NOTSTARTED);
                                        parameters.add(myQueue);
                                        parameters.add("U");
                                        parameters.add("N");
                                        parameters.add("N");
                                        parameters.add("N");
                                        parameters.add(procInstID);
                                        parameters.add(wrkItemID);
                                        parameters.add("Y");
                                        parameters.add("N");
                                        int res =WFSUtil.jdbcExecuteUpdate(procInstID, sessionID, userID, query, pstmt, parameters, debugFlag, engine);
                                        //int res = pstmt.executeUpdate();
                                        parameters.clear();
                                        
                                        pstmt.close();
                                        pstmt = null;
                                        /**
                                         * Bugzilla Id 61, 11/08/2006, PreparedStatement issue in DB2 - Ruhi Hira
                                         */
                                      /*  WFSUtil.DB_SetString(1, procInstID, pstmt, dbType);
                                        pstmt.setInt(2, wrkItemID);
*/                                     if (res > 0) {
                                      /*      pstmt = con.prepareStatement("Delete from  WorkinProcesstable where ProcessInstanceID = ? and WorkItemID = ? ");
                                            WFSUtil.DB_SetString(1, procInstID, pstmt, dbType);
                                            pstmt.setInt(2, wrkItemID);
                                            int f = pstmt.executeUpdate();
                                            pstmt.close();
                                            pstmt = null;*/
                                       /*     if (f == res) {*/
//                                                if(!con.getAutoCommit()){
//                                                    con.commit();
//                                                    con.setAutoCommit(true);
//                                                }
                                                done = true;
                                                WFSUtil.generateLog(engine, con, WFSConstant.WFL_AuditSet, procInstID, wrkItemID, procDefID,
                                                        activityId, actName, 0, auditor, auditorname, auditee, auditeeQname, null, null, null, null);
                                            /* Generate Logging for Setting Audit */
                                           /* }*/ /*else {
                                                mainCode = WFSError.WM_INVALID_WORKITEM;
                                                subCode = WFSError.WFS_NOQ;
                                                if (!con.getAutoCommit()) {
                                                    con.rollback();
                                                    con.setAutoCommit(true);
                                                }
                                            }*/
                                        } else {
                                            mainCode = WFSError.WM_INVALID_WORKITEM;
                                            subCode = WFSError.WFS_NOQ;
                                            if (!con.getAutoCommit()) {
                                                con.rollback();
                                                con.setAutoCommit(true);
                                            }
                                        }
                                    } else {
                                        if (rs != null) {
                                            rs.close();
                                            rs = null;
                                        }
                                        if (pstmt != null) {
                                            pstmt.close();
                                            pstmt = null;
                                        }
                                    }
                                }
                                b = b.shiftRight(1);
                                pstmt = con.prepareStatement(" Update UserWorkAudittable Set WorkItemCount = ? where AuditActivityId =  ? and UserIndex = ? and ProcessDefID = ? ");
                                WFSUtil.DB_SetString(1, b.toString(Character.MAX_RADIX), pstmt, dbType);
                                pstmt.setInt(2, activityId);
                                pstmt.setInt(3, userID);
                                pstmt.setInt(4, procDefID);
                                pstmt.executeUpdate();
                                pstmt.close();
                                pstmt = null;
                            } else {
                                if (rs != null) {
                                    rs.close();
                                    rs = null;
                                }
                                if (pstmt != null) {
                                    pstmt.close();
                                    pstmt = null;
                                }
                            }
                        } else if (!done && auditStatus == 'A' && assgnType == 'A' && pInstSt == 2 && (wState != 1 || wState != 5 || wState != 6)) {
                            int res = 0;
                            /** SrNo-7, Synchronous routing of workitems, Removal of WorkDoneTable - Ruhi Hira*/
                            if (!bSynchronousRoutingFlag) {
                                if (con.getAutoCommit()) {
                                    con.setAutoCommit(false);
                                }
                                // Tirupati Srivastava : changes in queries for PostgreSql dbase
								// Process Variant Support
                                
                                
        /*                        pstmt = con.prepareStatement(
                                        "Insert into WorkDonetable " +
                                        "			(ProcessInstanceId, WorkItemId, ProcessName, ProcessVersion," +
                                        " ProcessDefID,ProcessVariantId, LastProcessedBy, " + "ProcessedBy, ActivityName, ActivityId," +
                                      " EntryDateTime, ParentWorkItemId, " + "AssignmentType, CollectFlag, " +
                                        "PriorityLevel, ValidTill, Q_StreamId, Q_QueueId, " + "CreatedDateTime," +
                                        " WorkItemState, " + "Statename, ExpectedWorkitemDelay, PreviousStage, Queuename, Queuetype)" +
                                        
                                        "Select " + "ProcessInstanceId, WorkItemId, ProcessName, ProcessVersion, ProcessDefID,ProcessVariantId, "
                                        + "LastProcessedBy, ProcessedBy, ActivityName, ActivityId, " + "EntryDatetime, ParentWorkItemId, "
                                        + WFSUtil.TO_STRING("Y", true, dbType) + ", CollectFlag, PriorityLevel, ValidTill, "
                                        + "Q_StreamId, Q_QueueId, " + WFProcessServers.getInstance(engine,procDefID).getNextProcessServer() 
                                        + "CreatedDateTime, 6, " + WFSUtil.TO_STRING(WFSConstant.WF_COMPLETED, true, dbType) 
                                        + ", ExpectedWorkitemDelay, " + WFSUtil.TO_STRING(actName, true, dbType) + ", QueueName, QueueType from" +
                                        " WorkinProcesstable " + WFSUtil.getTableLockHintStr(dbType) + " where ProcessInstanceID = ? and WorkItemID = ? " + WFSUtil.getQueryLockHintStr(dbType));
                                */
                                // Change 11 for Code Optimization
                                query=
                                    "Update WFInstrumentTable set AssignmentType = ?, WorkItemState=? ,Q_QueueId=0,validtill = null,Statename=?, PreviousStage=? ,LockStatus = ?,AssignedUser= null," +
                                    "RoutingStatus=?,LockedByName=null,LockedTime=null,Q_UserId=0, Q_DivertedByUserId = 0, NotifyStatus = null where ProcessInstanceID = ? and WorkItemID = ? and LockStatus = ? and RoutingStatus = ?  " ;
                                pstmt = con.prepareStatement(query);
                                pstmt.setString(1, "Y");
                                pstmt.setInt(2,6);
                                pstmt.setString(3,WFSConstant.WF_COMPLETED);
                                pstmt.setString(4,actName);
                                pstmt.setString(5,"N");
                                pstmt.setString(6,"Y");
                                WFSUtil.DB_SetString(7, procInstID, pstmt, dbType);
                                pstmt.setInt(8, wrkItemID);
                                pstmt.setString(9,"Y");
                                pstmt.setString(10,"N");
                                parameters.add("Y");
                                parameters.add(6);
                                parameters.add(WFSConstant.WF_COMPLETED);
                                parameters.add(actName);
                                parameters.add("N");
                                parameters.add("Y");
                                parameters.add(procInstID);
                                parameters.add(wrkItemID);
                                parameters.add("Y");
                                parameters.add("N");
                                res =WFSUtil.jdbcExecuteUpdate(procInstID, sessionID, userID, query, pstmt, parameters, debugFlag, engine);
                                parameters.clear();
/*                                WFSUtil.DB_SetString(1, procInstID, pstmt, dbType);
                                pstmt.setInt(2, wrkItemID);*/
                             //   res = pstmt.executeUpdate();
                                pstmt.close();
                                pstmt = null;
                                /*if (res > 0) {
                                    pstmt = con.prepareStatement("Delete from  WorkinProcesstable where ProcessInstanceID = ? and WorkItemID = ? ");
                                    WFSUtil.DB_SetString(1, procInstID, pstmt, dbType);
                                    pstmt.setInt(2, wrkItemID);
                                    int f = pstmt.executeUpdate();
                                    pstmt.close();
                                    pstmt = null;
                                    if (f == res) {
//                                        if(!con.getAutoCommit()){
//                                            con.commit();
//                                            con.setAutoCommit(true);
//                                        }
                                    } else {
                                        mainCode = WFSError.WM_INVALID_WORKITEM;
                                        subCode = WFSError.WFS_NOQ;
                                        if (!con.getAutoCommit()) {
                                            con.rollback();
                                            con.setAutoCommit(true);
                                        }
                                    }
                                }*/
                                /*else*/
                                if (res <= 0) {
                                	   mainCode = WFSError.WM_INVALID_WORKITEM;
                                       subCode = WFSError.WFS_NOQ;
                                       if (!con.getAutoCommit()) {
                                           con.rollback();
                                           con.setAutoCommit(true);
                                       }
                                }
                            } else {
                                // Tirupati Srivastava : changes in queries for PostgreSql dbase
                                /** 10/01/2008, Bugzilla Bug 3380, transaction started in syncRoutingMode in completeWorkitem. - Ruhi Hira */
                                if (con.getAutoCommit()) {
                                    con.setAutoCommit(false);
                                }
                                // Change 12 for Code Optimization
/*                                pstmt = con.prepareStatement(
                                        "Update WorkInProcesstable set AssignmentType = " + WFSUtil.TO_STRING("Y", true, dbType) 
                                        + ", WorkItemState = 6, Statename = " + WFSUtil.TO_STRING(WFSConstant.WF_COMPLETED, true, dbType)
                                         + ", PreviousStage = " + WFSUtil.TO_STRING(actName, true, dbType) + " where ProcessInstanceID = ? 
                                         and WorkItemID = ? ");
*/                                
                                query="Update WFInstrumentTable set AssignmentType = ? "+ 
                                ", WorkItemState = ?,Q_QueueId=0,validtill = null, Q_DivertedByUserId = 0, AssignedUser= null, Statename = ?,PreviousStage = ? ,RoutingStatus = ?, NotifyStatus = null where ProcessInstanceID = ? and " +
                                " WorkItemID = ? and LockStatus = ? ";
                                pstmt = con.prepareStatement(query);
                                pstmt.setString(1, "Y");
                                pstmt.setInt(2, 6);
                                pstmt.setString(3, WFSConstant.WF_COMPLETED);
                                pstmt.setString(4, actName);
                                pstmt.setString(5, "Y");
                                WFSUtil.DB_SetString(6, procInstID, pstmt, dbType);
                                pstmt.setInt(7, wrkItemID);
                                pstmt.setString(8, "Y");
                                parameters.add("Y");
                                parameters.add(6);
                                parameters.add(WFSConstant.WF_COMPLETED);
                                parameters.add(actName);
                                parameters.add("Y");
                                parameters.add(procInstID);
                                parameters.add(wrkItemID);
                                parameters.add("Y");
                                res =WFSUtil.jdbcExecuteUpdate(procInstID, sessionID, userID, query, pstmt, parameters, debugFlag, engine);
                                parameters.clear();
                                pstmt.close();
                                pstmt = null;
                            /** @todo Do we need to check the result for this. - Ruhi Hira */
                            }
                            
                            if (mainCode == 0) {
                                if (res != 0) {
                                    doneFlag = true;
                                    done = true;
                                    /* Logging Accept and Complete - Prashant 13/09/2003 */
                                    pstmt = con.prepareStatement("Select * From (Select " + WFSUtil.getFetchPrefixStr(dbType, 1) + "" +
                                    		" AssociatedFieldID, AssociatedFieldName from " + tableName + " where ActionID = ? and " +
                                    		"ProcessInstanceId = ? and ActivityId =  ? and WorkItemID = ? " + " ORDER BY ActionDateTime DESC) " +
                                    		"" + tableName + WFSUtil.getFetchSuffixStr(dbType, 1, WFSConstant.QUERY_STR_WHERE));
                                    pstmt.setInt(1, WFSConstant.WFL_AuditSet);
                                    WFSUtil.DB_SetString(2, procInstID, pstmt, dbType);
                                    pstmt.setInt(3, activityId);
                                    pstmt.setInt(4, wrkItemID);
                                    if(debugFlag){                                    
                                        startTime  = System.currentTimeMillis();
                                    }
                                    pstmt.execute();
                                    rs = pstmt.getResultSet();
                                    
                                    if(debugFlag){
                                        endTime  = System.currentTimeMillis();
                                        WFSUtil.writeLog("WMCompleteWorkitem", "[WMCompleteWorkitem]_QueueQuery3", startTime, endTime, 0, "", "", engine,(endTime-startTime),sessionID, userID);  
                                    }
                                    if (rs.next()) {
                                        auditee = rs.getInt(1);
                                        auditeeQname = rs.getString(2);
                                    }
                                    if (rs != null) {
                                        rs.close();
                                        rs = null;
                                    }
                                    if (pstmt != null) {
                                        pstmt.close();
                                        pstmt = null;
                                    }
                                    pstmt = con.prepareStatement(
                                            "Select Queueid from QueueDeftable " + WFSUtil.getTableLockHintStr(dbType) + " where Queuename = ? ");
                                    WFSUtil.DB_SetString(1, auditeename, pstmt, dbType);
                                    if(debugFlag){
                                        startTime  = System.currentTimeMillis();
                                    }
                                    pstmt.execute();
                                    rs = pstmt.getResultSet();
                                    
                                    if(debugFlag){
                                        endTime  = System.currentTimeMillis();
                                        WFSUtil.writeLog("WMCompleteWorkitem", "[WMCompleteWorkitem]_QueueQuery4", startTime, endTime, 0, "", "", engine,(endTime-startTime),sessionID, userID);  
                                    }
                                    if (rs.next()) {
                                        qId = rs.getInt(1);
                                    }
                                    if (rs != null) {
                                        rs.close();
                                        rs = null;
                                    }
                                    if (pstmt != null) {
                                        pstmt.close();
                                        pstmt = null;
                                    }
                                    /* krishan regarding JMS */
                                    pstmt = con.prepareStatement(" Select UserName from WFUserView where UserIndex = ? ");
                                    pstmt.setInt(1, auditee);
                                    pstmt.execute();
                                    rs = pstmt.getResultSet();
                                    if (rs.next()) {
                                        auditeename = rs.getString(1);
                                    }
                                    if (rs != null) {
                                        rs.close();
                                        rs = null;
                                    }
                                    if (pstmt != null) {
                                        pstmt.close();
                                        pstmt = null;
                                    }
                                    //WFSUtil.genLog(engine,con,procDefID,procInstID,activityId,actName,WFSConstant.WFL_WorkItemCompleted,auditee,qId,null,wrkItemID,username);// to be done properly for complete
                                    //WFSUtil.genLogsummary(con,engine,procDefID,activityId,actName,WFSConstant.WFL_WorkItemCompleted,userID,qId,username,wkduration,expectedWkDelay,currentDate,processingTime,0,"");
									WFSUtil.deleteEscalation(engine, con, procInstID, wrkItemID, procDefID, activityId);
                                    
                                    if(debugFlag){
                                        startTime  = System.currentTimeMillis();
                                    }
                                    WFSUtil.generateLog(engine, con, WFSConstant.WFL_WorkItemCompleted, procInstID, wrkItemID, procDefID,
                                            activityId, actName, qId, auditee, auditeename, 0, null, currentDate, entryDateTime, lockedTime, expectedWkDelay , calendarName); /*WFS_8.0_026*/
                                    
                                    if(debugFlag){
                                        endTime  = System.currentTimeMillis();
                                        WFSUtil.writeLog("WMCompleteWorkitem", "[WMCompleteWorkitem]_GenerateLog1", startTime, endTime, 0, "", "", engine,(endTime-startTime),sessionID, userID);  
                                    }
                                    
                                    if(debugFlag){
                                        startTime  = System.currentTimeMillis();
                                    }
                                    WFSUtil.generateLog(engine, con, WFSConstant.WFL_WorkItemUnlock, procInstID, wrkItemID, procDefID,
                                            activityId, actName, qId, userID, username, 0, null, currentDate, null, lockedTime, null, 1);
                                    
                                    if(debugFlag){
                                        endTime  = System.currentTimeMillis();
                                        WFSUtil.writeLog("WMCompleteWorkitem", "[WMCompleteWorkitem]_GenerateLog2", startTime, endTime, 0, "", "", engine,(endTime-startTime),sessionID, userID);  
                                    }
                                  /*  WFSUtil.generateLog(engine, con, WFSConstant.WFL_Accept, procInstID, wrkItemID, procDefID,
                                            activityId, actName, qId, userID, username, 0, null, null, null, null, null); // to be done properly for Accept*/
											
						/* Bug 38059 - Details regarding Acceptance of WI are not showing in 'Work Audit Details */
						/* Bug 38562 - Approve status is not showing in Work Audit Details.*/
                        if(debugFlag){
                            startTime  = System.currentTimeMillis();                                    
                        }
						WFSUtil.generateLog(engine, con, WFSConstant.WFL_Accept, procInstID, wrkItemID, procDefID,
                             activityId, actName, 0, auditor, auditorname, auditee, auditeeQname, null, null, null, null);
                        
                        if(debugFlag){
                            endTime  = System.currentTimeMillis();
                            WFSUtil.writeLog("WMCompleteWorkitem", "[WMCompleteWorkitem]_GenerateLog2", startTime, endTime, 0, "", "", engine,(endTime-startTime),sessionID, userID);  
                        }

									completionTime = String.valueOf(wkduration);

                                } else {
                                    mainCode = WFSError.WM_INVALID_WORKITEM;
                                    subCode = WFSError.WFS_NOQ;
                                    if (!con.getAutoCommit()) {
                                        con.rollback();
                                        con.setAutoCommit(true);
                                    }
                                }
                            }
                        }
                        if (!done && (pInstSt == 2 || pInstSt > 6) && (wState != 1 || wState != 5 || wState != 6)) {
                            if (!bSynchronousRoutingFlag) {
                                if (con.getAutoCommit()) {
                                    con.setAutoCommit(false);
                                }
/*                                StringBuffer insertQuery = new StringBuffer(1000);
                                // Tirupati Srivastava : changes in queries for PostgreSql dbase
								// Process Variant Support
                                insertQuery.append("Insert into WorkDonetable (ProcessInstanceId, " + "WorkItemId, ProcessName, ProcessVersion," +
                                " ProcessDefID,ProcessVariantId, LastProcessedBy, " + "ProcessedBy, ActivityName, ActivityId, EntryDateTime," +
                                " ParentWorkItemId, " + "AssignmentType, CollectFlag, PriorityLevel, ValidTill, Q_StreamId, Q_QueueId, " +
                                "" + "Q_UserId, FilterValue, CreatedDateTime, WorkItemState, " + "Statename, ExpectedWorkitemDelay," +
                                " PreviousStage, Queuename, Queuetype) Select " + "ProcessInstanceId, WorkItemId, ProcessName," +
                                " ProcessVersion, ProcessDefID,ProcessVariantId, " + userID + ", " + WFSUtil.TO_STRING(username, true, dbType) 
                                + ", ActivityName, ActivityId, " //	+ "?, ?, ActivityName, ActivityId, "
                                + "EntryDatetime, ParentWorkItemId, " + WFSUtil.TO_STRING("Y", true, dbType) 
                                + ", CollectFlag, PriorityLevel, ValidTill, " + "Q_StreamId, Q_QueueId, 0 " 
                                + WFProcessServers.getInstance(engine,procDefID).getNextProcessServer()  
                                + ", FilterValue, CreatedDateTime, 6, " + WFSUtil.TO_STRING(WFSConstant.WF_COMPLETED, true, dbType) 
                                + ", ExpectedWorkitemDelay, " // Bug WFS_5.2.1_0005
                                        //			+ "PreviousStage,QueueName,QueueType,null from WorkinProcesstable "
                                + WFSUtil.TO_STRING(actName, true, dbType) + ", QueueName, QueueType from WorkinProcesstable " 
                                + WFSUtil.getTableLockHintStr(dbType) + " where ProcessInstanceID = ? and WorkItemID = ? " 
                                + WFSUtil.getQueryLockHintStr(dbType));*/
                                // Change 13 for Code Optimization
                                if (pstmt != null) {
                                    pstmt.close();
                                    pstmt = null;
                                }
                                query=
                                    "Update WFInstrumentTable set LastProcessedBy=?, ProcessedBy = ?,AssignmentType=?, Q_UserId = ? , Q_Queueid=0," +
                                    "WorkItemState=? ,AssignedUser= null,validtill = null,Statename=?, LockStatus = ?, PreviousStage = ?, " +
                                    "RoutingStatus=?,LockedByName=null,LockedTime=null, Q_DivertedByUserId = 0,EntryDateTime=" + WFSUtil.getDate(dbType)+", NotifyStatus = null where ProcessInstanceID = ? and WorkItemID = ? and LockStatus = ? and RoutingStatus = ? " ;
                                pstmt = con.prepareStatement(query);
                                pstmt.setInt(1, participant.gettype()=='P' ? 0 : userID);
                                pstmt.setString(2,participant.gettype()=='P' ? "System" : username);
                                pstmt.setString(3,"Y");
                                pstmt.setInt(4,0);
                                pstmt.setInt(5,6);
                                pstmt.setString(6,WFSConstant.WF_COMPLETED);
                                pstmt.setString(7,"N");
                                pstmt.setString(8 ,actName);
                                pstmt.setString(9,"Y");
                                WFSUtil.DB_SetString(10, procInstID, pstmt, dbType);
                                pstmt.setInt(11, wrkItemID);
                                pstmt.setString(12,"Y");
                                pstmt.setString(13,"N");
                                parameters.add(participant.gettype()=='P' ? 0 : userID);
                                parameters.add(participant.gettype()=='P' ? "System" : username);
                                parameters.add("Y");
                                parameters.add(0);
                                parameters.add(6);
                                parameters.add(WFSConstant.WF_COMPLETED);
                                parameters.add(null);
                                parameters.add("N");
                                parameters.add("Y");
                                parameters.add(procInstID);
                                parameters.add(wrkItemID);
                                parameters.add("Y");
                                parameters.add("N");
                                parameters.add(actName);
                                int res =WFSUtil.jdbcExecuteUpdate(procInstID, sessionID, userID, query, pstmt, parameters, debugFlag, engine);
                                parameters.clear(); 
                                pstmt.close();
                                pstmt=null;
                                //pstmt = con.prepareStatement(insertQuery.toString());
                                //pstmt.setInt(1, userID);
                                //WFSUtil.DB_SetString(2, username, pstmt, dbType);
                                /*WFSUtil.DB_SetString(1, procInstID, pstmt, dbType); //WFSUtil.DB_SetString(3, procInstID, pstmt, dbType);
                                pstmt.setInt(2, wrkItemID); //pstmt.setInt(4, wrkItemID);
                                int res = pstmt.executeUpdate();*/
                                /*try { 
                                int nz=0;
                                	StringBuffer access=new StringBuffer(1000);
                               	 	access.append("select * from WFescalationTable " + WFSUtil.getTableLockHintStr(dbType) + " where processInstanceId='"+procInstID+"'");
                                	st=con.createStatement();
                                	ResultSet rss=st.executeQuery(access.toString());
                                    StringBuffer delstat=new StringBuffer(1000);
                                	delstat.append("delete from WFescalationTable where processinstanceId='"+procInstID+"' and WorkItemid='"+wrkItemID+"'and scheduleTime >'"+currentDate+"'");
                                    while(rss.next())
                                    {
                                    	int k=1;
                                    	nz=st.executeUpdate(delstat.toString());
                                    	k++;
                                    }
                                	WFSUtil.printOut(engine,"Entries deleted from wfescalationtable and value of i=>"+nz);
                          			}
                      				catch(Exception e)
                      				{
                       					//WFSUtil.printOut(engine,"Exception : "+e);
                      				}
                      				finally
                      				{
                         				st.close();
                      				}*/

                                if (res > 0) {
/*                                    pstmt = con.prepareStatement("Delete from  WorkinProcesstable where ProcessInstanceID = ? and WorkItemID = ? ");
                                    WFSUtil.DB_SetString(1, procInstID, pstmt, dbType);
                                    pstmt.setInt(2, wrkItemID);
                                    int f = pstmt.executeUpdate();
                                    pstmt.close();
                                    pstmt = null;*/
                                  /*  if (f == res) {*/
                                        done = true;
//                                        if(!con.getAutoCommit()){
//                                            con.commit();
//                                            con.setAutoCommit(true);
//                                        }
                                   /* }*/ /*else {
                                        mainCode = WFSError.WM_INVALID_WORKITEM;
                                        subCode = WFSError.WFS_NOQ;
                                        if (!con.getAutoCommit()) {
                                            con.rollback();
                                            con.setAutoCommit(true);
                                        }
                                    }*/
                                } else {
                                    mainCode = WFSError.WM_INVALID_WORKITEM;
                                    subCode = WFSError.WFS_NOQ;
                                    if (!con.getAutoCommit()) {
                                        con.rollback();
                                        con.setAutoCommit(true);
                                    }
                                }
                            } else {
                                // Tirupati Srivastava : changes in queries for PostgreSql dbase
                                if (con.getAutoCommit()) {
                                    con.setAutoCommit(false);
                                }
                                
                          
/*                                pstmt = con.prepareStatement("Update WorkInProcessTable set " +
                                "LastProcessedBy = " + userID + ", ProcessedBy = " + WFSUtil.TO_STRING(username, true, dbType) + 
                                ", AssignmentType = " + WFSUtil.TO_STRING("Y", true, dbType) + ", Q_UserId = 0, " +
                                "WorkItemState = 6, Statename = " + WFSUtil.TO_STRING(WFSConstant.WF_COMPLETED, true, dbType) +
                                ", PreviousStage = " + WFSUtil.TO_STRING(actName, true, dbType) + 
                                " Where ProcessInstanceID = ? and WorkItemID = ? ");*/
                                // Change 14 for Code Optimization
                                query = "Update WFInstrumentTable set " +
                                "LastProcessedBy = ?, ProcessedBy = ?, AssignmentType = ?, Q_UserId = ?,Q_QueueId=0,AssignedUser= null," +
                                "WorkItemState = ?, validtill = null, Q_DivertedByUserId = 0, Statename = ?, PreviousStage = ?,RoutingStatus = ? ,EntryDateTime=" + WFSUtil.getDate(dbType)+", NotifyStatus = null Where ProcessInstanceID = ? " +
                                "and WorkItemID = ? and RoutingStatus = ? and LockStatus=? ";
                                pstmt=con.prepareStatement(query);
                                pstmt.setInt(1, participant.gettype()=='P' ? 0 : userID);
                                pstmt.setString(2,participant.gettype()=='P' ? "System" : username);
                                pstmt.setString(3,"Y");
                                pstmt.setInt(4,0);
                                pstmt.setInt(5,6);
                                pstmt.setString(6,WFSConstant.WF_COMPLETED);
                                pstmt.setString(7,actName);
                                pstmt.setString(8,"Y");
                                pstmt.setString(9,procInstID);
                                pstmt.setInt(10, wrkItemID);
                                pstmt.setString(11,"N");
                                pstmt.setString(12,"Y");
                                
                                parameters.add(participant.gettype()=='P' ? 0 : userID);
                                parameters.add(participant.gettype()=='P' ? "System" : username);
                                parameters.add("Y");
                                parameters.add(0);
                                parameters.add(6);
                                parameters.add(WFSConstant.WF_COMPLETED);
                                parameters.add(actName);
                                parameters.add("Y");
                                parameters.add(procInstID);
                                parameters.add(wrkItemID);
                                parameters.add("N");
                                parameters.add("Y");
                                /*WFSUtil.DB_SetString(1, procInstID, pstmt, dbType);
                                pstmt.setInt(2, wrkItemID);*/
                                int res= WFSUtil.jdbcExecuteUpdate(procInstID, sessionID, userID, query, pstmt, parameters, debugFlag, engine);        
                                parameters.clear();
                                /*int res = pstmt.executeUpdate();*/
                                pstmt.close();
                                pstmt = null;
                            /** @todo do we need to check for result of update ? - Ruhi */
                            }
                            if (mainCode == 0) {
                                // Entry for completed and unlock
                                doneFlag = true;
                                done = true;
								WFSUtil.deleteEscalation(engine, con, procInstID, wrkItemID, procDefID, activityId);
                                if(debugFlag){
                                    startTime  = System.currentTimeMillis();
                                }
                                WFSUtil.generateLog(engine, con, WFSConstant.WFL_WorkItemCompleted, procInstID, wrkItemID, procDefID,
                                        activityId, actName, qId, userID, username, 0, null, currentDate, entryDateTime, lockedTime, expectedWkDelay, calendarName); /*WFS_8.0_026*/
                                
                                if(debugFlag){
                                    endTime  = System.currentTimeMillis();
                                    WFSUtil.writeLog("WMCompleteWorkitem", "[WMCompleteWorkitem]_GenerateLog5", startTime, endTime, 0, "", "", engine,(endTime-startTime),sessionID, userID);  
                                }
                                
                                if(debugFlag){
                                    startTime  = System.currentTimeMillis();
                                }
                                WFSUtil.generateLog(engine, con, WFSConstant.WFL_WorkItemUnlock, procInstID, wrkItemID, procDefID,
                                        activityId, actName, qId, userID, username, 0, null, currentDate, null, lockedTime, null, 1);
                                
                                if(debugFlag){
                                    endTime  = System.currentTimeMillis();
                                    WFSUtil.writeLog("WMCompleteWorkitem", "[WMCompleteWorkitem]_GenerateLog6", startTime, endTime, 0, "", "", engine,(endTime-startTime),sessionID, userID);  
                                }

								completionTime = String.valueOf(wkduration);

                            }
                        }
                    }
                    if (done && wrkItemID > 1 && "Y".equalsIgnoreCase(sCollectFlag)) {
                        String sQuery = "DELETE FROM WFInstrumentTable WHERE ProcessInstanceId = ? AND WorkItemId = ?";
                        if (pstmt != null) {
                            pstmt.close();
                            pstmt = null;
                        }
                        pstmt = con.prepareStatement(sQuery);
                        WFSUtil.DB_SetString(1, procInstID, pstmt, dbType);
                        pstmt.setInt(2, wrkItemID);
                        parameters.add(Arrays.asList(procInstID, wrkItemID));
                        WFSUtil.jdbcExecuteUpdate(procInstID, sessionID, userID, sQuery.toString(), pstmt, parameters, debugFlag, engine);
                        parameters.clear();
                        pstmt.close();
                        pstmt = null;
                        WFSUtil.generateLog(engine, con, WFSConstant.WFL_ChildProcessInstanceDeleted, procInstID, wrkItemID, procDefID, activityId, actName, 0, 0, "", activityId, "", null, null, null, null);
                        bSynchronousRoutingFlag = false;
                    }
                    if (!done) {
                        mainCode = WFSError.WM_INVALID_WORKITEM;
                        subCode = 0;
                        subject = WFSErrorMsg.getMessage(mainCode);
                        descr = WFSErrorMsg.getMessage(subCode);
                        errType = WFSError.WF_TMP;
                    }
                    }
                } else {
                    if (rs != null) {
                        rs.close();
                        rs = null;
                    }
                    if (pstmt != null) {
                        pstmt.close();
                        pstmt = null;
                    }

                    mainCode = WFSError.WM_INVALID_WORKITEM;
                    subCode = 0;
                    subject = WFSErrorMsg.getMessage(mainCode);
                    descr = WFSErrorMsg.getMessage(subCode);
                    errType = WFSError.WF_TMP;
                }
            } else {
                mainCode = WFSError.WM_INVALID_SESSION_HANDLE;
                subCode = 0;
                subject = WFSErrorMsg.getMessage(mainCode);
                descr = WFSErrorMsg.getMessage(subCode);
                errType = WFSError.WF_TMP;
            }
            if (mainCode == 0) {
                outputXML = new StringBuffer(500);
                outputXML.append(gen.createOutputFile("WMCompleteWorkItem"));
                outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
                //  outputXML.append(tempXml);
                /* 20/08/2007, SrNo-3, Synchronous routing of workitems. - Ruhi Hira */
                //if (doneFlag && WFSUtil.isSyncRoutingMode()) {
                if (doneFlag && bSynchronousRoutingFlag) {
                    String[] retInfo;
                    if(debugFlag){
                        startTime  = System.currentTimeMillis();
                    }
                    retInfo = WFRoutingUtil.routeWorkitem(con, procInstID, wrkItemID, procDefID, engine,0,0,true,bSynchronousRoutingFlag);
                    
                    if(debugFlag){
                        endTime  = System.currentTimeMillis();
                        WFSUtil.writeLog("WMCompleteWorkitem", "[WMCompleteWorkitem]_routeWorkitem", startTime, endTime, 0, "", "", engine,(endTime-startTime),sessionID, userID);  
                    }

                    if (activityId != -1 && retInfo != null) {
                        String srcActivityId = retInfo[0];
                        String srcBlockId = retInfo[1];
                        String targetActivityID = retInfo[2];
                        String targetBlockId = retInfo[3];
                        String targetQueueId = retInfo[4];
                        String targetQueueType = retInfo[5];
                        String targetProcessInstanceId = retInfo[6];
                        String targetWorkitemId = retInfo[7];
						/** 05/02/2010,	WFS_8.0_082 Block Activity support for reinitiate and subprocess cases
						  * [CIG (CapGemini) – generic AP process]. - Ruhi Hira */
                        if (!srcBlockId.equalsIgnoreCase("0") && srcBlockId.equalsIgnoreCase(targetBlockId)) {
                            outputXML.append("<TargetActivityID>" + targetActivityID + "</TargetActivityID>");
                            outputXML.append("<TargetQueueID>" + targetQueueId + "</TargetQueueID>");
                            outputXML.append("<TargetQueueType>" + targetQueueType + "</TargetQueueType>");
                            outputXML.append("<TargetProcessInstanceId>" + targetProcessInstanceId + "</TargetProcessInstanceId>");
                            outputXML.append("<TargetWorkitemId>" + targetWorkitemId + "</TargetWorkitemId>");
                        }
                    }
                }
				outputXML.append(gen.writeValueOf("EntryDateTime", entryDateTime));
				outputXML.append(gen.writeValueOf("CompletionTime", completionTime));
				outputXML.append(inputParamInfo);
				outputXML.append(gen.writeValueOf("ActivityName", actName));
				outputXML.append(gen.writeValueOf("ActivityId", String.valueOf(activityId)));
                outputXML.append(gen.closeOutputFile("WMCompleteWorkItem"));
                if (!con.getAutoCommit()) {
                    con.commit();
                    con.setAutoCommit(true);
                }
            }
        } catch (SQLException e) {
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WM_INVALID_FILTER;
            subCode = WFSError.WFS_SQL;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_FAT;
            if (e.getErrorCode() == 0) {
                if (e.getSQLState().equalsIgnoreCase("08S01")) {
                    descr = (new JTSSQLError(e.getSQLState())).getMessage() + "(SQL State : " + e.getSQLState() + ")";
                }
            } else {
                descr = e.getMessage();
            }
        } catch (NumberFormatException e) {
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_ILP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch (NullPointerException e) {
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_SYS;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        }catch (WFSException e) {
            mainCode = e.getMainErrorCode();
            subCode = e.getSubErrorCode();
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = WFSErrorMsg.getMessage(subCode);
        }
        catch (JTSException e) {
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = e.getErrorCode();
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.getMessage();
        } catch (Exception e) {
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_EXP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch (Error e) {
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_EXP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } finally {
            try {
                if (!con.getAutoCommit()) {
                    con.rollback();
                    con.setAutoCommit(true);
                }
            } catch (Exception e) {
            }
            try {
                if (rs != null) {
                    rs.close();
                    rs = null;
                }
            } catch (SQLException sqle) {
            }
            try {
                if (pstmt != null) {
                    pstmt.close();
                    pstmt = null;
                }
            } catch (SQLException sqle) {
            }
            
        }
        if (mainCode != 0) {/*
            throw new WFSException(mainCode, subCode, errType, subject, descr);
        */
        	String strReturn = WFSUtil.generalError(option, engine, gen,
   	                   mainCode, subCode,
   	                   errType, subject,
   	                    descr, inputParamInfo.toString());
   	             
   	        return strReturn;	
        }
        return outputXML.toString();
    }

//----------------------------------------------------------------------------------------------------
//	Function Name 				:	WMReassignWorkItem
//	Date Written (DD/MM/YYYY)	:	16/05/2002
//	Author						:	Prashant
//	Input Parameters			:	Connection , XMLParser , XMLGenerator
//	Output Parameters			:   none
//	Return Values				:	String
//	Description					:   Reassigns WorkItem to a User
//----------------------------------------------------------------------------------------------------
// Change Summary *
//----------------------------------------------------------------------------
// Changed By						: Ashish Mangla
// Reason / Cause (Bug No if Any)	: WSE_5.0.1_beta_166
// Change Description				: Workitem can be in Worklisttable also consider that case also while reassigning....
//----------------------------------------------------------------------------
//  Change Description          : Changes for Code Optimization-Merging of WorkFlow 
//								  tables to WFInstrumentTable, logging of Query and removal of throw WFSException
//  Changed by					: Shweta Singhal    
    public String WMReassignWorkItem(Connection con, XMLParser parser,
            XMLGenerator gen) throws JTSException, WFSException {
    	StringBuffer outputXML = new StringBuffer("");
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        int mainCode = 0;
        int subCode = 0;
        String subject = null;
        String descr = null;
        String errType = WFSError.WF_TMP;
        String comments = "";
        boolean debug = false;
        ArrayList parameters = null;
        String queryString = null;
        String engine= null;
        String option = parser.getValueOf("Option", "", false);
		int Q_DivertedByUserId = 0;
		String Q_DivertedByUserName = "";
		int activityType=0;
		String currentDate = null;
		String lockedTime = null;
		String entryDateTime = null;
        WFConfigLocator configLocator = null;
        boolean rightsFlag = false;
        try {
            int sessionID = parser.getIntOf("SessionId", 0, false);
            String procInstID = parser.getValueOf("ProcessInstanceId", "", false);
            int wrkItemID = parser.getIntOf("WorkItemId", 0, false);
            String SourceUser = parser.getValueOf("SourceUser", "", true);
            /*If OpenMode = WD[WebDesktop] then no need to by pass WMGetWorkitem .
            If OpenMode = PM[Process Manager] then user should be able to Reassign the worktiem form other user's My Queue.*/
            boolean pmMode = parser.getValueOf("OpenMode", "WD", true).equalsIgnoreCase("PM");
            String TargetUser = parser.getValueOf("TargetUser", "", false);
            engine = parser.getValueOf("EngineName");
            int dbType = ServerProperty.getReference().getDBType(engine);
            debug = parser.getValueOf("DebugFlag", "N", true).equalsIgnoreCase("Y");
             long startTime = 0L;
            long endTime = 0L;
            XMLParser parser1 = null;
            WFParticipant participant = WFSUtil.WFCheckSession(con, sessionID);
            int indx = procInstID.indexOf(" ");
            if(indx > -1)
               procInstID = procInstID.substring(0, indx);
            if (participant != null && participant.gettype() == 'U') {
                int userID = participant.getid();
                /**
				 * Changed by: Mohnish Chopra
				 * Change Description : Return Error if workitem has expired.
				 * 
				 */
            	if(WFSUtil.isWorkItemExpired(con, dbType, procInstID, wrkItemID, sessionID, userID, debug, engine)){
    				/*
                    throw new WFSException(mainCode, subCode, errType, subject, descr);
                */
    				    mainCode = WFSError.WF_OPERATION_FAILED;
    		            subCode = WFSError.WM_WORKITEM_EXPIRED;
    		            subject = WFSErrorMsg.getMessage(mainCode);
    		            errType = WFSError.WF_TMP;
    		            descr = WFSErrorMsg.getMessage(subCode);
    		            String strReturn = WFSUtil.generalError(option, engine, gen,
    	   	                   mainCode, subCode,
    	   	                   errType, subject,
    	   	                    descr);
    	   	             
    	   	        return strReturn;	
                
    			}
                String username = participant.getname();
                boolean isAdmin = participant.getscope().equals("ADMIN");
				// Process Variant Support
                // OF Optimization
                //Checking ORM rights for Reassign and user is part of business admin group
                 boolean partOfAdminGroup = isPartOfAdminGroup(con,dbType,userID);
                 if(!partOfAdminGroup)
                 {
                	 if(TargetUser.equalsIgnoreCase(username))
                	 {
                	 rightsFlag = WFSUtil.checkRights(con, dbType, WFSConstant.CONST_OBJTYPE_ProcessClientWorklist, 0, sessionID, WFSConstant.CONST_ProcessClientWorklist_ASSIGN_TO_ME);
                	 }
                	 else
                	 {
           	          rightsFlag = WFSUtil.checkRights(con, dbType, WFSConstant.CONST_OBJTYPE_ProcessClientWorklist, 0, sessionID, WFSConstant.CONST_ProcessClientWorklist_REASSIGN);
                	 }
                  }
           	     if(partOfAdminGroup || rightsFlag)
                 {
               	  isAdmin = true;
                 }
                queryString = "Select WorkitemState,AssignedUser,Q_QueueId,ProcessDefID,ActivityID,ActivityName,AssignmentType,ProcessVariantId, LockStatus,LockedByName,activityType,CreatedDatetime," + WFSUtil.getDate(dbType) + ", LockedTime, PROCESSINSTANCESTATE from WFInstrumentTable " + WFSUtil.getTableLockHintStr(dbType) + " where ProcessInstanceID=? and WorkItemID=? and routingStatus = ? ";
                pstmt = con.prepareStatement(queryString);
                //pstmt = con.prepareStatement("Select WorkitemState,AssignedUser,Q_QueueId,ProcessDefID," + "ActivityID,ActivityName," + "'Worklisttable', AssignmentType,ProcessVariantId from Worklisttable where " + "ProcessInstanceID=? and WorkItemID=? UNION " + "Select WorkitemState,AssignedUser,Q_QueueId,ProcessDefID," + "ActivityID,ActivityName,'WorkinProcesstable', AssignmentType,ProcessVariantId from WorkinProcesstable " + " where ProcessInstanceID=? and WorkItemID=?");
                WFSUtil.DB_SetString(1, procInstID, pstmt, dbType);
                pstmt.setInt(2, wrkItemID);
                WFSUtil.DB_SetString(3, "N", pstmt, dbType);
                parameters = new ArrayList();
                parameters.add(procInstID);
                parameters.add(wrkItemID);
                parameters.add("N");
                rs = WFSUtil.jdbcExecuteQuery(procInstID, sessionID, userID, queryString, pstmt, parameters, debug, engine);
//                pstmt.execute();
//                rs = pstmt.getResultSet();
                if (rs.next()) {
                	 activityType=rs.getInt("activityType");
					if((!(isAdmin || pmMode)) || (TargetUser.equalsIgnoreCase(username))){
						StringBuilder wmGetWorkItemInputXml = new StringBuilder();
						wmGetWorkItemInputXml.append("<?xml version=\"1.0\"?><WMGetWorkItem_Input><Option>WMGetWorkItem</Option>");
						wmGetWorkItemInputXml.append("<EngineName>").append(engine).append("</EngineName>");
						wmGetWorkItemInputXml.append("<SessionId>").append(sessionID).append("</SessionId>");
						wmGetWorkItemInputXml.append("<ProcessInstanceId>").append(procInstID).append("</ProcessInstanceId>");
						wmGetWorkItemInputXml.append("<WorkItemId>").append(wrkItemID).append("</WorkItemId>");
						wmGetWorkItemInputXml.append("</WMGetWorkItem_Input>");
						parser1 = new XMLParser();
						parser1.setInputXML(wmGetWorkItemInputXml.toString());
						try
						{
							startTime = System.currentTimeMillis();
							String wmGetWorkItemOutputXml = WFFindClass.getReference().execute("WMGetWorkItem", engine, con, parser1, gen);
							parser1.setInputXML(wmGetWorkItemOutputXml);
							endTime = System.currentTimeMillis();
							WFSUtil.writeLog("WFClientServiceHandlerBean", "WMGetWorkItem", startTime, endTime, 0, wmGetWorkItemInputXml.toString(), wmGetWorkItemOutputXml);
							wmGetWorkItemInputXml = null;
							mainCode = Integer.parseInt(parser1.getValueOf("MainCode"));
						}
						catch(WFSException wfs)
						{
							WFSUtil.printErr(engine, "[WMReassignWorkItem] : WFSException in WMGetworkItem");
							WFSUtil.printErr(engine, wfs);
							throw wfs;
						}
					}	
					
                    if(mainCode==0){
                        int wState = rs.getInt("WorkitemState");
                        String lockedBy = rs.getString("AssignedUser");
                        lockedBy = rs.wasNull() ? "" : lockedBy;
                        int qId = rs.getInt("Q_QueueId");
                        int procDefID = rs.getInt("ProcessDefID");
                        int activityId = rs.getInt("ActivityID");
                        String actName = rs.getString("ActivityName");
                        String myQueue = TargetUser.trim() + WfsStrings.getMessage(1);
                       // String tableName = rs.getString(7);
                        String assignmenttype = rs.getString("AssignmentType");
                        int procVariantId= rs.getInt("ProcessVariantId");//Process Variant Support
                        String lockStatus = rs.getString("LockStatus");
                        String LockedByUser = rs.getString("LockedByName");
                        int processInstanceState = rs.getInt("PROCESSINSTANCESTATE");
                        currentDate = rs.getString(12);
    					lockedTime = rs.getString(13);
    					entryDateTime = rs.getString(14);
                        int target = 0;
                        String emailnotify = "N";
                        char allowReassign = 'N';
                        comments = parser.getValueOf("Comments", "", true);
                        configLocator = WFConfigLocator.getInstance();
                        String strConfigFileName = configLocator.getPath(Location.IBPS_CONFIG) + File.separator + WFSConstant.CONST_DIRECTORY_CONFIG + File.separator + WFSConstant.CONST_FILE_WFAPPCONFIGPARAM;
                        XMLParser parserTemp = new XMLParser(WFSUtil.readFile(strConfigFileName));
                        emailnotify = parserTemp.getValueOf(WFSConstant.CONST_NOTIFYBYEMAIL, "N", false);
                        rs.close();
                        rs = null;
                        pstmt.close();
                        pstmt = null;
                        
                        if(activityType==WFSConstant.ACT_CASE){
	                        pstmt=con.prepareStatement("UPDATE WFTaskPreCheckTable set checkPreCondition='Y' where ProcessInstanceId=? and WorkitemId=? and ActivityId=?");
	                        pstmt.setString(1,procInstID);
	                        pstmt.setInt(2, wrkItemID);
	                        pstmt.setInt(3, activityId);
	                        int updateCount=pstmt.executeUpdate();
	                        pstmt.close();
	                        if(updateCount==0){
	                        	pstmt=con.prepareStatement("Insert into WFTaskPreCheckTable (ProcessInstanceId,WorkItemId,ActivityId,checkPreCondition,ProcessDefId) values (?,?,?,?,?)");
	                        	pstmt.setString(1,procInstID);
	                        	pstmt.setInt(2,wrkItemID);
	                        	pstmt.setInt(3,activityId);
	                        	pstmt.setString(4,"Y");
	                        	pstmt.setInt(5,procDefID);
	                        	pstmt.executeUpdate();
	                        	pstmt.close();
	                        	
	                        }
                        }	
                        if (wState < 3 && ("N".equalsIgnoreCase(lockStatus.trim()) || LockedByUser.trim().equalsIgnoreCase(username))) {

                            if (isAdmin|| pmMode || qId == 0) {
                                pstmt = con.prepareStatement(
                                        " Select UserIndex, UserName from WFUserView where Upper(UserName) = ? ");
                                WFSUtil.DB_SetString(1, TargetUser.toUpperCase(), pstmt, dbType);
                                pstmt.execute();
                                rs = pstmt.getResultSet();
                                if (rs.next()) {
                                    target = rs.getInt("UserIndex");
                                    TargetUser = rs.getString("UserName").trim();
                                }
                                if (rs != null) {
                                    rs.close();
                                    rs = null;
                                }
                                if (pstmt != null) {
                                    pstmt.close();
                                    pstmt = null;
                                }
                            }
                            else {
                            pstmt = con.prepareStatement(
                                    " Select AllowReassignment from QueueDefTable " + WFSUtil.getTableLockHintStr(dbType) + "  where QueueId = ? ");
                            pstmt.setInt(1, qId);
                            pstmt.execute();
                            rs = pstmt.getResultSet();
                            if (rs.next()) {
                                String allow = rs.getString(1);
                                allowReassign = rs.wasNull() ? 'N' : allow.charAt(0);
                            }
                            if (rs != null) {
                                rs.close();
                                rs = null;
                            }
                            if (pstmt != null) {
                                pstmt.close();
                                pstmt = null;
                            }

                            if (allowReassign == 'Y') {
                                //----------------------------------------------------------------------------
                                // Changed By	                        : Varun Bhansaly
                                // Changed On                           : 17/01/2007
                                // Reason                        	: Bugzilla Id 54
                                // Change Description			: Provide Dirty Read Support for DB2 Database
                                //----------------------------------------------------------------------------

                                pstmt = con.prepareStatement(" Select UserIndex, UserName from WFUserView , QUserGroupView where Upper(UserName) = ? and QueueId = ? and UserId = UserIndex " + WFSUtil.getQueryLockHintStr(dbType));
                                WFSUtil.DB_SetString(1, TargetUser.toUpperCase(), pstmt, dbType);
                                pstmt.setInt(2, qId);
                                pstmt.execute();
                                rs = pstmt.getResultSet();
                                if (rs.next()) {
                                    target = rs.getInt("UserIndex");
                                    TargetUser = rs.getString("UserName").trim();
                                }
                                if (rs != null) {
                                    rs.close();
                                    rs = null;
                                }
                                if (pstmt != null) {
                                    pstmt.close();
                                    pstmt = null;
                                }

                            } else {
                                /** 31/01/2008, Bugzilla Bug 3772 New message for reassignment not allowed - Ruhi Hira */
                                mainCode = WFSError.WF_OPERATION_FAILED;
                                subCode = WFSError.WFS_ERR_REASSGN_NOT_ALLOWED_QUEUE;
                                //Changes for Bug 50125 --Proper error subject and description should be sent
                                subject = WFSErrorMsg.getMessage(mainCode);
                                descr = WFSErrorMsg.getMessage(subCode);
                                errType = WFSError.WF_TMP;
                            }
                            }
                            if (mainCode == 0) {
                                if (target > 0) {
                                    int divertId = WFSUtil.getDivert(con, target, dbType,procDefID, activityId);

                                    if (divertId != target) {
                                        //get user name also
                                        pstmt = con.prepareStatement("Select Username from WFUserView where UserIndex = ?");
                                        pstmt.setInt(1, divertId);
                                        pstmt.execute();
                                        rs = pstmt.getResultSet();
                                        if (rs != null && rs.next()) {
                                                                                    Q_DivertedByUserName = TargetUser;
                                            TargetUser = rs.getString("UserName").trim();
                                                                                    Q_DivertedByUserId = target;
                                            target = divertId;
                                        } else {
                                            mainCode = WFSError.WM_INVALID_TARGET_USER;
                                            subCode = 0;
                                            subject = WFSErrorMsg.getMessage(mainCode);
                                            descr = WFSErrorMsg.getMessage(subCode);
                                            errType = WFSError.WF_TMP;
                                        }

                                        if (rs != null) {
                                            rs.close();
                                            rs = null;
                                        }
                                        if (pstmt != null) {
                                            pstmt.close();
                                            pstmt = null;
                                        }
                                    }
                                    if(activityType==WFSConstant.ACT_CASE){
                                    	myQueue = TargetUser + WfsStrings.getMessage(2);	
                                    }
                                    else{
                                    myQueue = TargetUser + WfsStrings.getMessage(1);
                                    }
                                    if(processInstanceState == 1) {
                                    	mainCode = WFSError.WFS_ERR_REASSGN_NOT_ALLOWED_QUEUE;
                                        subCode = 0;
                                        subject = WFSErrorMsg.getMessage(mainCode);
                                        descr = WFSErrorMsg.getMessage(subCode);
                                        errType = WFSError.WF_TMP;	
                                    }
                                    else if(!(qUserAssociation(con,target,qId) || isAdmin || pmMode || qId == 0))
                                    {
                                    	mainCode = WFSError.WM_INVALID_TARGET_USER;
                                        subCode = 0;
                                        subject = WFSErrorMsg.getMessage(mainCode);
                                        descr = WFSErrorMsg.getMessage(subCode);
                                        errType = WFSError.WF_TMP;	
                                    }
                                } else {
                                    mainCode = WFSError.WM_INVALID_TARGET_USER;
                                    subCode = 0;
                                    subject = WFSErrorMsg.getMessage(mainCode);
                                    descr = WFSErrorMsg.getMessage(subCode);
                                    errType = WFSError.WF_TMP;
                                }
                            }
                            if (mainCode == 0) {
                                if ((wState < 3 || wState > 6) && target > 0 && (allowReassign == 'Y' || (isAdmin|| pmMode || qId == 0))) {
                                    if(emailnotify.equalsIgnoreCase("N")) {
                                    pstmt = con.prepareStatement(
                                            "Select NotifyByEmail from UserPreferencesTable " + WFSUtil.getTableLockHintStr(dbType) + " where UserID = ? and ObjectType = 'U' ");
                                    pstmt.setInt(1, target);
                                    pstmt.execute();
                                    rs = pstmt.getResultSet();
                                    if (rs.next()) {
                                        emailnotify = rs.getString(1);
                                        emailnotify = rs.wasNull() ? "N" : emailnotify;
                                    }
                                    if (rs != null) {
                                        rs.close();
                                        rs = null;
                                    }
                                    if (pstmt != null) {
                                        pstmt.close();
                                        pstmt = null;
                                    }
                                    if (!comments.equals("")) {
                                        if (con.getAutoCommit()) {
                                            con.setAutoCommit(false);
                                        }
                                    }
                                    }
                                    if (mainCode == 0) {
                                        //Ashish added condition WSE_5.0.1_beta_166
                                        //OF Optimization
                                        //if (tableName.equalsIgnoreCase("Worklisttable")) {
                                                                                    //WFS_8.0_148
                                            if(assignmenttype.equalsIgnoreCase("A"))
                                            {    
                                                //OF Optimization
                                                queryString = "Update WFInstrumentTable Set Q_QueueId =  ?, Q_UserId = ?,  AssignedUser = ?, FilterValue = null, WorkItemState = 1,  Statename = " + WFSUtil.TO_STRING(WFSConstant.WF_NOTSTARTED, true, dbType) + ", Queuename = ?, Queuetype = ?, NotifyStatus = ?,LockStatus=?, LockedByName=null, LockedTime=null, Q_DivertedByUserId = ? where ProcessInstanceID = ? and WorkItemID = ? and RoutingStatus = ?";
                                                pstmt = con.prepareStatement(queryString);
                                                 //pstmt = con.prepareStatement("Update Worklisttable Set Q_QueueId =  ?, Q_UserId = ?,  AssignedUser = ?, " + "FilterValue = null, WorkItemState = 1,  Statename = " + WFSUtil.TO_STRING(WFSConstant.WF_NOTSTARTED, true, dbType) + ", " + "Queuename = ?, Queuetype = ?, NotifyStatus = ? " + " where ProcessInstanceID = ? and WorkItemID = ? ");
                                            }else if (assignmenttype.equalsIgnoreCase("E")){
                                            	 queryString = "Update WFInstrumentTable Set Q_QueueId =  ?, Q_UserId = ?,  AssignedUser = ?, FilterValue = null, WorkItemState = 2,  "
                                            	 		+ "Statename = " + WFSUtil.TO_STRING(WFSConstant.WF_RUNNING, true, dbType) + ", Queuename = ?, Queuetype = ?, NotifyStatus = ?,"
                                            	 				+ "LockStatus=?, LockedByName=null, LockedTime=null, Q_DivertedByUserId = ? where ProcessInstanceID = ? and WorkItemID = ? and RoutingStatus = ?";
                                                 pstmt = con.prepareStatement(queryString);
                                                
                                            }
                                            	
                                            else
                                            {
                                            // Tirupati Srivastava : changes in queries for PostgreSql dbase
                                                //OF Optimization
                                                queryString = "Update WFInstrumentTable Set AssignmentType = " + WFSUtil.TO_STRING("F", true, dbType) + ",Q_QueueId =  ?, Q_UserId = ?,  AssignedUser = ?, FilterValue = null, WorkItemState = 1,  Statename = " + WFSUtil.TO_STRING(WFSConstant.WF_NOTSTARTED, true, dbType) + ", Queuename = ?, Queuetype = ?, NotifyStatus = ?,LockStatus=?, LockedByName=null, LockedTime=null, Q_DivertedByUserId = ? where ProcessInstanceID = ? and WorkItemID = ? and RoutingStatus =?";
                                                pstmt = con.prepareStatement(queryString);
                                            //pstmt = con.prepareStatement("Update Worklisttable Set AssignmentType = " + WFSUtil.TO_STRING("F", true, dbType) + "," + "Q_QueueId =  ?, Q_UserId = ?,  AssignedUser = ?, " + "FilterValue = null, WorkItemState = 1,  Statename = " + WFSUtil.TO_STRING(WFSConstant.WF_NOTSTARTED, true, dbType) + ", " + "Queuename = ?, Queuetype = ?, NotifyStatus = ? " + " where ProcessInstanceID = ? and WorkItemID = ? ");
                                                                                    }
                                            pstmt.setInt(1, 0);
                                            pstmt.setInt(2, target);
                                            WFSUtil.DB_SetString(3, TargetUser, pstmt, dbType);
                                            if(assignmenttype.equalsIgnoreCase("E")){
                                            	pstmt.setNull(4, java.sql.Types.VARCHAR);
                                                WFSUtil.DB_SetString(5, "U", pstmt, dbType);
                                                WFSUtil.DB_SetString(6, emailnotify.trim(), pstmt, dbType);
                                                WFSUtil.DB_SetString(7, "N", pstmt, dbType);
                                                                                        pstmt.setInt(8, Q_DivertedByUserId);
                                                WFSUtil.DB_SetString(9, procInstID, pstmt, dbType);
                                                pstmt.setInt(10, wrkItemID);
                                                WFSUtil.DB_SetString(11, "N", pstmt, dbType);
                                                	
                                            }
                                            else{
                                            	WFSUtil.DB_SetString(4, myQueue, pstmt, dbType);
                                            	WFSUtil.DB_SetString(5, "U", pstmt, dbType);
                                            	WFSUtil.DB_SetString(6, emailnotify.trim(), pstmt, dbType);
                                            	WFSUtil.DB_SetString(7, "N", pstmt, dbType);
                                            	pstmt.setInt(8, Q_DivertedByUserId);
                                            	WFSUtil.DB_SetString(9, procInstID, pstmt, dbType);
                                            	pstmt.setInt(10, wrkItemID);
                                            	WFSUtil.DB_SetString(11, "N", pstmt, dbType);
                                            }
                                            parameters.clear();
                                            parameters.add(0);
                                            parameters.add(target);
                                            parameters.add(TargetUser);
                                            if(assignmenttype.equalsIgnoreCase("E")){
                                            	parameters.add("null");
                                            }
                                            else{
                                            	parameters.add(myQueue);
                                            }
                                            parameters.add("U");
                                            parameters.add(emailnotify.trim());
                                            parameters.add("N");
                                            parameters.add(Q_DivertedByUserId);
                                            
                                            int res = WFSUtil.jdbcExecuteUpdate(procInstID, sessionID, userID, queryString, pstmt, parameters, debug, engine);
                                            //int res = pstmt.executeUpdate();
                                            pstmt.close();
                                            pstmt = null;
    //                                    } else {
    //                                        if (con.getAutoCommit()) {
    //                                            con.setAutoCommit(false);
    //                                        }
    //										 if(assignmenttype.equalsIgnoreCase("A"))//WFS_8.0_148
    //                                        // Tirupati Srivastava : changes in queries for PostgreSql dbase
    //										// Process Variant Support
    //											pstmt = con.prepareStatement(
    //												"Insert into Worklisttable (ProcessInstanceId, " + "WorkItemId, ProcessName, ProcessVersion, ProcessDefID,ProcessVariantId, LastProcessedBy, " + "ProcessedBy, ActivityName, ActivityId, EntryDateTime, ParentWorkItemId, " + "AssignmentType, CollectFlag, PriorityLevel, ValidTill, Q_StreamId, Q_QueueId, " + "Q_UserId, AssignedUser, CreatedDateTime, WorkItemState, " + "Statename, ExpectedWorkitemDelay, PreviousStage, Queuename, Queuetype, NotifyStatus) Select " + "ProcessInstanceId, WorkItemId, ProcessName, ProcessVersion, ProcessDefID,ProcessVariantId, " + "LastProcessedBy, ProcessedBy, ActivityName, ActivityId, " + "EntryDatetime, ParentWorkItemId, AssignmentType, CollectFlag, PriorityLevel, ValidTill, " + "Q_StreamId, 0, " + target + ", " + WFSUtil.TO_STRING(TargetUser, true, dbType) + ", CreatedDateTime, 1, " + WFSUtil.TO_STRING(WFSConstant.WF_NOTSTARTED, true, dbType) + ", ExpectedWorkitemDelay, " + "PreviousStage, " + WFSUtil.TO_STRING(myQueue, true, dbType) + ", " + WFSUtil.TO_STRING("U", true, dbType) + ", " + WFSUtil.TO_STRING(emailnotify.trim(), true, dbType) + " from WorkinProcesstable where ProcessInstanceID = ? and WorkItemID = ? ");
    //                                         else
    //                                            // Tirupati Srivastava : changes in queries for PostgreSql dbase
    //											// Process Variant Support
    //                                             pstmt = con.prepareStatement(
    //                                                "Insert into Worklisttable (ProcessInstanceId, " + "WorkItemId, ProcessName, ProcessVersion, ProcessDefID,ProcessVariantId, LastProcessedBy, " + "ProcessedBy, ActivityName, ActivityId, EntryDateTime, ParentWorkItemId, " + "AssignmentType, CollectFlag, PriorityLevel, ValidTill, Q_StreamId, Q_QueueId, " + "Q_UserId, AssignedUser, CreatedDateTime, WorkItemState, " + "Statename, ExpectedWorkitemDelay, PreviousStage, Queuename, Queuetype, NotifyStatus) Select " + "ProcessInstanceId, WorkItemId, ProcessName, ProcessVersion, ProcessDefID,ProcessVariantId, " + "LastProcessedBy, ProcessedBy, ActivityName, ActivityId, " + "EntryDatetime, ParentWorkItemId, " + WFSUtil.TO_STRING("F", true, dbType) + ", CollectFlag, PriorityLevel, ValidTill, " + "Q_StreamId, 0, " + target + ", " + WFSUtil.TO_STRING(TargetUser, true, dbType) + ", CreatedDateTime, 1, " + WFSUtil.TO_STRING(WFSConstant.WF_NOTSTARTED, true, dbType) + ", ExpectedWorkitemDelay, " + "PreviousStage, " + WFSUtil.TO_STRING(myQueue, true, dbType) + ", " + WFSUtil.TO_STRING("U", true, dbType) + ", " + WFSUtil.TO_STRING(emailnotify.trim(), true, dbType) + " from WorkinProcesstable where ProcessInstanceID = ? and WorkItemID = ? ");
    //                                        /**
    //                                         * Bugzilla Id 61, 11/08/2006, PreparedStatement issue in DB2 - Ruhi Hira
    //                                         */
    //                                        WFSUtil.DB_SetString(1, procInstID, pstmt, dbType);
    //                                        pstmt.setInt(2, wrkItemID);
    //                                        int res = pstmt.executeUpdate();
    //                                        pstmt.close();
    //                                        pstmt = null;
    //                                        //Bug # 1621
    //                                        if (res > 0) {
    //                                            pstmt = con.prepareStatement("Delete from  WorkinProcesstable where ProcessInstanceID = ? and WorkItemID = ? ");
    //                                            WFSUtil.DB_SetString(1, procInstID, pstmt, dbType);
    //                                            pstmt.setInt(2, wrkItemID);
    //                                            int f = pstmt.executeUpdate();
    //                                            pstmt.close();
    //                                            pstmt = null;
    //                                            //Bug # 1621
    //                                            if (f != res) {
    //                                                if (!con.getAutoCommit()) {
    //                                                    con.rollback();
    //                                                    con.setAutoCommit(true);
    //                                                }
    //                                                mainCode = WFSError.WM_INVALID_WORKITEM;
    //                                                subCode = WFSError.WFS_NOQ;
    //                                                subject = WFSErrorMsg.getMessage(mainCode);
    //                                                descr = WFSErrorMsg.getMessage(subCode);
    //                                            }
    //                                        } else {
    //                                            if (!con.getAutoCommit()) {
    //                                                con.rollback();
    //                                                con.setAutoCommit(true);
    //                                            }
    //                                            mainCode = WFSError.WM_INVALID_WORKITEM;
    //                                            subCode = WFSError.WFS_NOQ;
    //                                            subject = WFSErrorMsg.getMessage(mainCode);
    //                                            descr = WFSErrorMsg.getMessage(subCode);
    //                                        }
    //                                    }
                                        if (mainCode == 0) {
                                            if (!comments.equals("")) {
                                                                                            // Process Variant Support
                                                pstmt = con.prepareStatement("Insert Into WFCommentsTable (ProcessDefId, ActivityId, ProcessInstanceId, WorkItemId, CommentsBy, CommentsByName, CommentsTo, CommentsToName, Comments, ActionDateTime, CommentsType,ProcessVariantId) Values (?, ?, ?, ?, ?, ?, ?, ?, ?, " + WFSUtil.getDate(dbType) + ", ?,?)");
                                                pstmt.setInt(1, procDefID);
                                                pstmt.setInt(2, activityId);
                                                WFSUtil.DB_SetString(3, procInstID, pstmt, dbType);
                                                pstmt.setInt(4, wrkItemID);
                                                pstmt.setInt(5, userID);
                                                WFSUtil.DB_SetString(6, username, pstmt, dbType);
                                                pstmt.setInt(7, target);
                                                WFSUtil.DB_SetString(8, TargetUser, pstmt, dbType);
                                                WFSUtil.DB_SetString(9, comments, pstmt, dbType);
                                                pstmt.setInt(10, WFSConstant.CONST_COMMENTS_REASSIGN);
                                                                                            pstmt.setInt(11,procVariantId);
                                                pstmt.executeUpdate();
                                                pstmt.close();
                                                pstmt = null;
                                            }
                                            if (!con.getAutoCommit()) {
                                                con.commit();
                                                con.setAutoCommit(true);
                                            }
                                            if(Q_DivertedByUserId!=0){
                                            WFSUtil.generateLog(engine, con, WFSConstant.WFL_WorkItemReassigned, procInstID, wrkItemID,
                                                    procDefID, activityId, actName, 0, userID, username, target, Q_DivertedByUserName, null, null, null, null);
                                            }else{
                                            	WFSUtil.generateLog(engine, con, WFSConstant.WFL_WorkItemReassigned, procInstID, wrkItemID,
                                                        procDefID, activityId, actName, 0, userID, username, target, TargetUser, null, null, null, null);
                                            }
                                                                                    if(Q_DivertedByUserId!=0){
                                                WFSUtil.generateLog(engine, con, WFSConstant.WFL_WorkitemDiverted, procInstID, wrkItemID,
                                                        procDefID, activityId, actName, 0, userID, username, target, TargetUser+","+Q_DivertedByUserName, null, null, null, null);
                                            }
                                           WFSUtil.generateLog(engine, con, WFSConstant.WFL_WorkItemUnlock, procInstID, wrkItemID,
                                        		   procDefID,activityId, actName, 0, userID, username, 0, null, currentDate, null, lockedTime, null, 1);
                                        }
                                    }
                                } else {
                                    mainCode = WFSError.WM_INVALID_WORKITEM;
                                    subCode = WFSError.WFS_WKM_CLSD;
                                    subject = WFSErrorMsg.getMessage(mainCode);
                                    descr = WFSErrorMsg.getMessage(subCode);
                                    errType = WFSError.WF_TMP;
                                }
                            }
                        } else {
                            mainCode = WFSError.WM_INVALID_WORKITEM;
                            subCode = WFSError.WFS_WKM_N_RASN;
                            subject = WFSErrorMsg.getMessage(mainCode);
                            descr = WFSErrorMsg.getMessage(subCode);
                            errType = WFSError.WF_TMP;
                        }
                       
                        
                }//If ends for maincode returned from GETWorktiem = 0
                } else {
                    if (rs != null) {
                        rs.close();
                        rs = null;
                    }
                    if (pstmt != null) {
                        pstmt.close();
                        pstmt = null;
                    }
                    mainCode = WFSError.WM_INVALID_WORKITEM;
                    subCode = 0;
                    subject = WFSErrorMsg.getMessage(mainCode);
                    descr = WFSErrorMsg.getMessage(subCode);
                    errType = WFSError.WF_TMP;
                }
            } else {
                mainCode = WFSError.WM_INVALID_SESSION_HANDLE;
                subCode = 0;
                subject = WFSErrorMsg.getMessage(mainCode);
                descr = WFSErrorMsg.getMessage(subCode);
                errType = WFSError.WF_TMP;
            }
            if (mainCode == 0) {
                outputXML = new StringBuffer(500);
                outputXML.append(gen.createOutputFile("WMReassignWorkItem"));
                outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
                outputXML.append(gen.closeOutputFile("WMReassignWorkItem"));
            }
        } catch (SQLException e) {
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WM_INVALID_FILTER;
            subCode = WFSError.WFS_SQL;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_FAT;
            if (e.getErrorCode() == 0) {
                if (e.getSQLState().equalsIgnoreCase("08S01")) {
                    descr = (new JTSSQLError(e.getSQLState())).getMessage() + "(SQL State : " + e.getSQLState() + ")";
                }
            } else {
                descr = e.getMessage();
            }
        } catch (NumberFormatException e) {
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_ILP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch (NullPointerException e) {
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_SYS;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch (JTSException e) {
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = e.getErrorCode();
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.getMessage();
        } catch (Exception e) {
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_EXP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch (Error e) {
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_EXP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } finally {
            try {

                if (!con.getAutoCommit()) {
                    con.rollback();
                    con.setAutoCommit(true);
                }
            } catch (Exception e) {
            }
            try {
                if (rs != null) {
                    rs.close();
                    rs = null;
                }
            } catch (SQLException sqle) {
            }
            try {
                if (pstmt != null) {
                    pstmt.close();
                    pstmt = null;
                }
            } catch (SQLException sqle) {
            }
            
        }
        if (mainCode != 0) {
            String strReturn = WFSUtil.generalError(option, engine, gen,mainCode, subCode,errType, subject,descr);
            return strReturn;	
            //throw new WFSException(mainCode, subCode, errType, subject, descr);
        }
        return outputXML.toString();
    }

private boolean qUserAssociation(Connection con, int target, int qId) throws SQLException {
	
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	boolean isAssociated = false;
	String query = "SELECT * FROM QUSERGROUPVIEW WHERE queueid=? AND userid=?";
	pstmt = con.prepareStatement(query);
	pstmt.setInt(1,qId);
	pstmt.setInt(2,target);
	rs = pstmt.executeQuery();
	if(rs.next())
	{
		isAssociated = true;
	}
	try {

        if (rs != null) {
        	rs.close();
        	rs = null;
        }
    } catch (Exception e) {
    }
	try {

        if (pstmt != null) {
        	pstmt.close();
        	pstmt = null;
        }
    } catch (Exception e) {
    }
    return isAssociated;
}

//----------------------------------------------------------------------------------------------------
//	Function Name 				:	WMUnlockWorkItem
//	Date Written (DD/MM/YYYY)	:	16/05/2002
//	Author						:	Prashant
//	Input Parameters			:	Connection , XMLParser , XMLGenerator
//	Output Parameters			:   none
//	Return Values				:	String
//	Description					:   Unlock WorkItem
//----------------------------------------------------------------------------------------------------
//  Change Description          : Changes for Code Optimization-Merging of WorkFlow 
//								  tables to WFInstrumentTable, logging of Query and removal of throw WFSException
//  Changed by					: Shweta Singhal
    public String WMUnlockWorkItem(Connection con, XMLParser parser,
            XMLGenerator gen) throws JTSException, WFSException {
        StringBuffer outputXML = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        PreparedStatement pstmt2 = null;
        //PreparedStatement pstmt3 = null;
        PreparedStatement pstmt4 = null;
        int mainCode = 0;
        int subCode = 0;
        String subject = null;
        String descr = null;
        String errType = WFSError.WF_TMP;
        String procInstID = "";
        int wrkItemID = -1;
        boolean workItemFound = false;
        boolean partOfAdminGroup = false;
        boolean rightsFlag = false;
        int res = -1;
        String engine = parser.getValueOf("EngineName", "", false);
        String option = parser.getValueOf("Option", "", false);
        StringBuilder inputParamInfo = new StringBuilder();
        boolean queuehistorytable=false;
        try {
            int sessionID = parser.getIntOf("SessionId", 0, true);
            //engine = parser.getValueOf("EngineName");
            int dbType = ServerProperty.getReference().getDBType(engine);
            char omniServiceFlag = parser.getCharOf("OmniService", 'N', true);
            boolean debug = parser.getValueOf("DebugFlag", "N", true).equalsIgnoreCase("Y");
            /**
             * Changes for Bug 50123 --Mohnish Chopra
             * Optional Admin flag added to check if user is of scope Admin .
             *   
             */
            
            boolean isAdmin = parser.getValueOf("Admin", "N", true).equalsIgnoreCase("Y");
            /** WFS_5_182 - API would be executed either in User -> 'U' or WorkItem -> 'W' mode
             ** Default will be WorkItem mode for backward compatibility.
             ** In User mode, all WIs locked by the user will be unlocked.
             ** This support has to be provided because once users web session expires,
             ** web doesnot have information on which WI to unlock.
             ** - Varun Bhansaly
             **/
            boolean allowUnlock=false;
            char unlockOption = parser.getCharOf("UnlockOption", 'W', true);
            String queryStr = null;
            ArrayList parameters = new ArrayList();
            if (unlockOption == 'W' || unlockOption == 'w') {
                procInstID = parser.getValueOf("ProcessInstanceId", "", false);
                wrkItemID = parser.getIntOf("WorkItemId", 0, false);
            }
            WFParticipant participant = null;
            /* 20/08/2007, SrNo-3, Synchronous routing of workitems. - Ruhi Hira */
            if (omniServiceFlag == 'Y') {
                participant = new WFParticipant(0, "System", 'P', "SERVER", Locale.getDefault().toString());
            } else {
                participant = WFSUtil.WFCheckSession(con, sessionID);
            }
            inputParamInfo.append(gen.writeValueOf("SessionId", String.valueOf(sessionID)));
            inputParamInfo.append(gen.writeValueOf("UserName", (participant == null ? "" : participant.getname())));
//            WFParticipant participant = WFSUtil.WFCheckSession(con, sessionID);
            if (participant != null) {
                int userID = participant.getid();
                String username = participant.getname();
                char pType = participant.gettype();
                //Changes for Bug 50123 --Commented -Admin flag will be fetched from Input XML.
                //boolean isAdmin = participant.getscope().equalsIgnoreCase("ADMIN");

                int indx = procInstID.indexOf(" ");
                if(indx > -1)
                   procInstID = procInstID.substring(0, indx);
                if (pType == 'P') {
                    /* TO DO: REALLOCATION */
                    /** This code will not be executed in case of synchronous process server. - Ruhi Hira */
                    if (con.getAutoCommit()) {
                        con.setAutoCommit(false);
                    }
                    // Tirupati Srivastava : changes in queries for PostgreSql dbase
					//Process Variant Support
                    queryStr = "Update WFInstrumentTable set LockStatus = ?, LockedByName = null, LockedTime = null where ProcessInstanceID= ? and WorkItemID= ?";
                    pstmt = con.prepareStatement(queryStr);
//                    pstmt = con.prepareStatement(
//                            "Insert into Workdonetable (ProcessInstanceId, WorkItemId, " + "ProcessName, ProcessVersion, ProcessDefID, LastProcessedBy, " + "ProcessedBy, ActivityName, ActivityId, EntryDateTime, " + "ParentWorkItemId, AssignmentType, CollectFlag, PriorityLevel, " + "ValidTill, CreatedDateTime, WorkItemState, Statename, " + "ExpectedWorkitemDelay, PreviousStage, LockStatus, ProcessVariantId) " + "Select ProcessInstanceId, WorkItemId, ProcessName, ProcessVersion, " + "ProcessDefID, LastProcessedBy, ProcessedBy, ActivityName, ActivityId, " + "EntryDateTime, ParentWorkItemId, AssignmentType, CollectFlag, " + "PriorityLevel, ValidTill, CreatedDateTime, WorkItemState, " + "Statename, ExpectedWorkitemDelay, PreviousStage, " + WFSUtil.TO_STRING("N", true, dbType) + " , ProcessVariantId from WorkwithPSTable where ProcessInstanceID= ? and WorkItemID= ?");
                    WFSUtil.DB_SetString(1, "N", pstmt, dbType);
                    //WFSUtil.DB_SetString(2, "Y", pstmt, dbType);
                    WFSUtil.DB_SetString(2, procInstID, pstmt, dbType);
                    pstmt.setInt(3, wrkItemID);
                    parameters.add("N");
                    //parameters.add("Y");
                    parameters.add(procInstID);
                    parameters.add(wrkItemID);
                    res = WFSUtil.jdbcExecuteUpdate(procInstID, sessionID, userID, queryStr, pstmt, parameters, debug, engine);
                    parameters.clear();
                    //res = pstmt.executeUpdate();
                    pstmt.close();
                    pstmt = null;
//                    if (res <= 0) {
                    if (res > 0) {
//                        pstmt = con.prepareStatement("Delete from  WorkwithPSTable where ProcessInstanceID = ? and WorkItemID = ? ");
//                        WFSUtil.DB_SetString(1, procInstID, pstmt, dbType);
//                        pstmt.setInt(2, wrkItemID);
//                        int f = pstmt.executeUpdate();
//                        pstmt.close();
//                        pstmt = null;
//                        if (f == res) {
                            if (!con.getAutoCommit()) {
                                con.commit();
                                con.setAutoCommit(true);
                            }
//                        } else {
//                            if (!con.getAutoCommit()) {
//                                con.rollback();
//                                con.setAutoCommit(true);
//                            }
//                            mainCode = WFSError.WM_NOT_LOCKED;
//                            subCode = 0;
//                            subject = WFSErrorMsg.getMessage(mainCode);
//                            descr = WFSErrorMsg.getMessage(subCode);
//                            errType = WFSError.WF_TMP;
//                        }
                    } else {
                        if (!con.getAutoCommit()) {
                            con.rollback();
                            con.setAutoCommit(true);
                        }
                        mainCode = WFSError.WM_NOT_LOCKED;
                        subCode = 0;
                        subject = WFSErrorMsg.getMessage(mainCode);
                        descr = WFSErrorMsg.getMessage(subCode);
                        errType = WFSError.WF_TMP;
                    }
                } else if (pType == 'U') {
                	
                	 
                	//Added handling for unlocking the task (Lock on task used in the reassignTask API)
                	if(unlockOption == 'T' || unlockOption == 't'){
                		//Task is unlocked if only its locked and its locked by the same user which is unlocking it
                		int activityId = parser.getIntOf("ActivityId", 0, false);
                		int taskId = parser.getIntOf("TaskId", 0, false);
                		int subTaskId = parser.getIntOf("SubTaskId", 0, false);
                		String processInstanceId = parser.getValueOf("ProcessInstanceId", "", false);
                		int workitemId = parser.getIntOf("WorkItemId", 0, false);
                		int processDefId = 0;
                		int taskStatus = 0;
                		String assignedTo = null;
                		String lockStatus = null;
                		String actionDateTime = WFSUtil.dbDateTime(con, dbType);
                		
                		boolean isValidTask = false;
                		int returnResult = 0;

                		queryStr = "select processDefId, TaskStatus, AssignedTo, LockStatus from wftaskstatustable where ProcessInstanceId = ? and activityid =? and taskid =? and subTaskid =?";
                		pstmt = con.prepareStatement(queryStr);
                		WFSUtil.DB_SetString(1, processInstanceId, pstmt, dbType);
                		pstmt.setInt(2, activityId);
                		pstmt.setInt(3, taskId);
                		pstmt.setInt(4, subTaskId);
                		rs = pstmt.executeQuery();
                		if(rs.next()){
                			processDefId = rs.getInt(1);
                			taskStatus = rs.getInt(2);
                			assignedTo = rs.getString(3);
                			lockStatus = rs.getString(4);
                			isValidTask = true;
                		}
                        if (rs != null) {
                            rs.close();
                            rs = null;
                        }
                        if (pstmt != null) {
                            pstmt.close();
                            pstmt = null;
                        }
                        
                		if(isValidTask){
                			if(taskStatus != WFSConstant.WF_TaskCompleted){
	                            if(username.equalsIgnoreCase(assignedTo)){
		                            if (con.getAutoCommit()) {
		                            	con.setAutoCommit(false);
	                            	}
	                            	pstmt = con.prepareStatement("update wftaskstatustable set LockStatus = 'N' where ProcessInstanceId = ? and "
	                            			+ "ActivityId = ? and TaskId = ? and SubTaskId = ?");
	                            	WFSUtil.DB_SetString(1, processInstanceId, pstmt, dbType);
	                            	pstmt.setInt(2, activityId);
	                            	pstmt.setInt(3, taskId);
	                            	pstmt.setInt(4, subTaskId);
	                            	
	                            	returnResult = pstmt.executeUpdate();
	                            	if(returnResult > 0){
	                                    if (!con.getAutoCommit()) {
	                                        con.commit();
	                                        con.setAutoCommit(true);
	                                    }
	                                    WFSUtil.generateTaskLog(engine, con, dbType, processInstanceId, WFSConstant.WFL_TaskUnlocked, workitemId, 
	                                    		processDefId, activityId, null, 0, userID, username, username, taskId, subTaskId, actionDateTime);
	                            	}else{
		                                mainCode = WFSError.WM_NOT_LOCKED;
		                                subCode = 0;
		                                subject = WFSErrorMsg.getMessage(mainCode);
		                                descr = WFSErrorMsg.getMessage(subCode);
		                                errType = WFSError.WF_TMP;
	                            	}
	                            }else{
		                            mainCode = WFSError.WF_INVALID_TASK;
		                            subCode = 0;
		                            subject = WFSErrorMsg.getMessage(mainCode);
		                            descr = WFSErrorMsg.getMessage(subCode);
		                            errType = WFSError.WF_TMP;
	                            }
                			}else{
	                            mainCode = WFSError.WF_TASK_ALREADY_COMPLETED;
	                            subCode = 0;
	                            subject = WFSErrorMsg.getMessage(mainCode);
	                            descr = WFSErrorMsg.getMessage(subCode);
	                            errType = WFSError.WF_TMP;
                			}
                		}else{
                            mainCode = WFSError.WF_INVALID_TASK;
                            subCode = 0;
                            subject = WFSErrorMsg.getMessage(mainCode);
                            descr = WFSErrorMsg.getMessage(subCode);
                            errType = WFSError.WF_TMP;
                		}
                	}else{
	                    if (unlockOption == 'W' || unlockOption == 'w') {
	                        queryStr = "Select Q_UserId,ProcessDefID,ActivityId,ActivityName,QueueName,QueueType,Q_QueueID,LockedByName, LockedTime, " + WFSUtil.getDate(dbType) + ",AssignmentType,ActivityType from WFInstrumentTable " + WFSUtil.getTableLockHintStr(dbType) + " where ProcessInstanceID = ? and WorkItemID = ? and ( RoutingStatus =? or ( RoutingStatus=? and ( ActivityType=? or AssignmentType=?))) and LockStatus =?";
	                       // pstmt = con.prepareStatement(queryStr);
	                        pstmt=con.prepareStatement(queryStr, ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
	//                        pstmt = con.prepareStatement(
	//                                " Select Q_UserId,ProcessDefID,ActivityId,ActivityName,QueueName,QueueType," + "Q_QueueID,LockedByName, LockedTime, " + WFSUtil.getDate(dbType) + " from WorkinProcessTable where ProcessInstanceID = ? " + "and WorkItemID = ? ");
	
	                        WFSUtil.DB_SetString(1, procInstID, pstmt, dbType);
	                        pstmt.setInt(2, wrkItemID);
	                        WFSUtil.DB_SetString(3, "N", pstmt, dbType);
	                        WFSUtil.DB_SetString(4, "R", pstmt, dbType);
	                        pstmt.setInt(5, WFSConstant.ACT_EXT);
	                        WFSUtil.DB_SetString(6, "Z", pstmt, dbType);
	                        WFSUtil.DB_SetString(7, "Y", pstmt, dbType);
	                    } else {
						//Process Variant Support
	                        queryStr = "Select Q_UserId, ProcessDefID, ActivityId, ActivityName, QueueName, QueueType, Q_QueueID,LockedByName, LockedTime, " + WFSUtil.getDate(dbType) + ",AssignmentType,ActivityType, ProcessInstanceID, WorkItemID, ProcessVariantId from WFInstrumentTable " + WFSUtil.getTableLockHintStr(dbType) + " where Q_UserId = ? and ( RoutingStatus =? or ( RoutingStatus=? and ( ActivityType=? or AssignmentType=?))) and LockStatus =?";
	                      //  pstmt = con.prepareStatement(queryStr);
	                        pstmt=con.prepareStatement(queryStr, ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
	                        //pstmt = con.prepareStatement("Select Q_UserId, ProcessDefID, ActivityId, ActivityName, QueueName, QueueType, Q_QueueID,LockedByName, LockedTime, " + WFSUtil.getDate(dbType) + ", ProcessInstanceID, WorkItemID, ProcessVariantId from WorkinProcessTable where Q_UserId = ?");
	
	                        pstmt.setInt(1, userID);
	                        WFSUtil.DB_SetString(2, "N", pstmt, dbType);
	                        WFSUtil.DB_SetString(3, "R", pstmt, dbType);
	                        pstmt.setInt(4, WFSConstant.ACT_EXT);
	                        WFSUtil.DB_SetString(5, "Z", pstmt, dbType);
	                        WFSUtil.DB_SetString(6, "Y", pstmt, dbType);
	                    }
	                    rs = WFSUtil.jdbcExecuteQuery(procInstID, sessionID, userID, queryStr, pstmt, parameters, debug, engine);
	                    int count=0;
	                    if(rs!=null){
	                    	if(rs.last()){
	                    		count=rs.getRow();
	                    	}
	                    }
	                    if(count<=0){
	                    	if(rs!=null){
	                    		rs.close();
	                    		rs=null;
	                    	}
	                    	if(pstmt!=null){
	                    		pstmt.close();
	                    		pstmt=null;
	                    	}
	                    	queryStr=queryStr.replace("WFInstrumentTable", "QueuehistoryTable");
	                    	queuehistorytable=true;
	                    	 pstmt = con.prepareStatement(queryStr);
	                    	 if (unlockOption == 'W' || unlockOption == 'w') {
	                    	    WFSUtil.DB_SetString(1, procInstID, pstmt, dbType);
	 	                        pstmt.setInt(2, wrkItemID);
	 	                        WFSUtil.DB_SetString(3, "N", pstmt, dbType);
	 	                        WFSUtil.DB_SetString(4, "R", pstmt, dbType);
	 	                        pstmt.setInt(5, WFSConstant.ACT_EXT);
	 	                       WFSUtil.DB_SetString(6, "Z", pstmt, dbType);
	 	                        WFSUtil.DB_SetString(7, "Y", pstmt, dbType);
	                    	 }else{
	                    		pstmt.setInt(1, userID);
	 	                        WFSUtil.DB_SetString(2, "N", pstmt, dbType);
	 	                        WFSUtil.DB_SetString(3, "R", pstmt, dbType);
	 	                        pstmt.setInt(4, WFSConstant.ACT_EXT);
	 	                       WFSUtil.DB_SetString(5, "Z", pstmt, dbType);
	 	                        WFSUtil.DB_SetString(6, "Y", pstmt, dbType);
	                    	 }
	                    	 rs = WFSUtil.jdbcExecuteQuery(procInstID, sessionID, userID, queryStr, pstmt, parameters, debug, engine);
	                    }
	                    else{
	                    	rs.beforeFirst();
	                    }
	                    parameters.clear();
	
	                    /** In case of permanent assignment of workitems to a particular user, (QType -> 'S') donot change value for AssignedUser.
	                     ** - Varun Bhansaly
	                     **/
	                    /** For QueueType -> I, D, N, F */
						//Process Variant Support
	                    
	                    
	//                    pstmt2 = con.prepareStatement(
	//                            "Insert into Worklisttable (ProcessInstanceId, WorkItemId, " + "ProcessName, ProcessVersion, ProcessDefID, LastProcessedBy, ProcessedBy, ActivityName, " + "ActivityId, EntryDateTime, ParentWorkItemId, CollectFlag, PriorityLevel, ValidTill, " + "Q_StreamId, Q_QueueId, Q_UserId, AssignedUser, AssignmentType, FilterValue, " + "CreatedDateTime, WorkItemState, Statename, ExpectedWorkitemDelay, PreviousStage, LockStatus, Queuename, Queuetype, ProcessVariantId)" + "Select ProcessInstanceId, WorkItemId, ProcessName, ProcessVersion, ProcessDefID, LastProcessedBy, ProcessedBy, " + "ActivityName, ActivityId, EntryDateTime, ParentWorkItemId, CollectFlag, PriorityLevel, ValidTill," + "Q_StreamId, Q_QueueId, 0, null, " + "AssignmentType, FilterValue, CreatedDateTime, WorkItemState, Statename, " + "ExpectedWorkitemDelay, PreviousStage, " + WFSUtil.TO_STRING("N", true, dbType) + ", Queuename, Queuetype, ProcessVariantId from WorkinProcessTable " + "where ProcessInstanceId = ? and WorkItemId = ?");
						//Process Variant Support
	//                    pstmt4 = con.prepareStatement(
	//                            "Insert into Worklisttable (ProcessInstanceId, WorkItemId, " + "ProcessName, ProcessVersion, ProcessDefID, LastProcessedBy, ProcessedBy, ActivityName, " + "ActivityId, EntryDateTime, ParentWorkItemId, CollectFlag, PriorityLevel, ValidTill, " + "Q_StreamId, Q_QueueId, Q_UserId, AssignedUser, AssignmentType, FilterValue, " + "CreatedDateTime, WorkItemState, Statename, ExpectedWorkitemDelay, PreviousStage, LockStatus, Queuename, Queuetype, ProcessVariantId)" + "Select ProcessInstanceId, WorkItemId, ProcessName, ProcessVersion, ProcessDefID, LastProcessedBy, ProcessedBy, " + "ActivityName, ActivityId, EntryDateTime, ParentWorkItemId, CollectFlag, PriorityLevel, ValidTill," + "Q_StreamId, Q_QueueId, Q_UserId, AssignedUser, " + "AssignmentType, FilterValue, CreatedDateTime, WorkItemState, Statename, " + "ExpectedWorkitemDelay, PreviousStage, " + WFSUtil.TO_STRING("N", true, dbType) + ", Queuename, Queuetype , ProcessVariantId from WorkinProcessTable " + "where ProcessInstanceId = ? and WorkItemId = ?");
	
	                    //pstmt3 = con.prepareStatement("Delete from WorkinProcessTable where ProcessInstanceID = ? and WorkItemID = ?");
	                    while (rs.next()) {
	                        workItemFound = true;
	                        int lockedByid = rs.getInt(1);
	                        int procDefID = rs.getInt(2);
	                        int activityId = rs.getInt(3);
	                        String actName = rs.getString(4);
	                        String qname = rs.getString(5);
	                        String qType = rs.getString(6);
	                        int qId = rs.getInt(7);
	                        String lockedBy = rs.getString(8);
	
	                        String lockedTime = rs.getString(9);
	                        String currentDate = rs.getString(10);
	                        String assignType = rs.getString(11);
							int actType = rs.getInt(12);
	                        if (unlockOption == 'U' || unlockOption == 'u') {
	                            procInstID = rs.getString(13);
	                            wrkItemID = rs.getInt(14);
	                        }
	                        
	                        if(isAdmin || lockedByid == userID){
	                        	allowUnlock=true;
	                        }
	                        
	                        if(!allowUnlock){
	                        	partOfAdminGroup = isPartOfAdminGroup(con,dbType,userID);
	                        	 if(partOfAdminGroup){
	                        		 allowUnlock=true;
	                        	 }
	                        }
	                        
	                        if(!allowUnlock){
	                        	rightsFlag = WFSUtil.checkRights(con, dbType, WFSConstant.CONST_OBJTYPE_ProcessClientWorklist, 0, sessionID, WFSConstant.CONST_ProcessClientWorklist_UNLOCK);	  	                      
	                        	 if(rightsFlag){
	                        		 allowUnlock=true;
	                        	 }
	                        }
	                    	        
	                        if (allowUnlock) {
	                        	
	                            if (con.getAutoCommit()) {
	                                con.setAutoCommit(false);
	                            }
	                            // Tirupati Srivastava : changes in queries for PostgreSql dbase
	                            //Changes For Case Management . QueueType M handling done
	                            if ((actType==WFSConstant.ACT_EXT ||qType.startsWith("I") || qType.startsWith("F") || qType.startsWith("D") || qType.startsWith("N")||qType.startsWith("M")||qType.startsWith("T"))&& !(assignType.equalsIgnoreCase("H")||assignType.equalsIgnoreCase("Z"))) {
	                               // queryStr = "update WFInstrumentTable set Q_UserId=?, AssignedUser=?, LockStatus=?,LockedByName = null, LockedTime = null where ProcessInstanceId = ? and WorkItemId = ?";							
	                                if(queuehistorytable){
	                            		queryStr = "update QueueHistoryTable set Q_UserId=?, AssignedUser=?, LockStatus=?,LockedByName = null, LockedTime = null where ProcessInstanceId = ? and WorkItemId = ?";
	                            	}else{
	                            		queryStr = "update WFInstrumentTable set Q_UserId=?, AssignedUser=?, LockStatus=?,LockedByName = null, LockedTime = null where ProcessInstanceId = ? and WorkItemId = ?";							
	                            	}
	                                pstmt2 = con.prepareStatement(queryStr);
	                                pstmt2.setInt(1,0);
	                                WFSUtil.DB_SetString(2, null, pstmt2, dbType);
	                                WFSUtil.DB_SetString(3, "N", pstmt2, dbType);
	                                WFSUtil.DB_SetString(4, procInstID, pstmt2, dbType);
	                                pstmt2.setInt(5, wrkItemID);
	                                parameters.add(0);
	                                parameters.add(null);
	                                parameters.add("N");
	                                parameters.add(procInstID);
	                                parameters.add(wrkItemID);
	                                res = WFSUtil.jdbcExecuteUpdate(procInstID, sessionID, userID, queryStr, pstmt2, parameters, debug, engine);
	                                parameters.clear();
	                                //res = pstmt2.executeUpdate();
	                                pstmt2.clearParameters();
	                            } else if(assignType.equalsIgnoreCase("H")) {
	                                String stateName = "";
	                                int workitemState = 0;
	                                if(qType.equalsIgnoreCase("H")){
	                                    stateName = "HOLDED";
	                                    workitemState = 7;
	                                }else{
	                                    stateName = "THOLDED";
	                                    workitemState = 8;
	                                }
	                               // queryStr = "update WFInstrumentTable set LockStatus=?,LockedByName = null, LockedTime = null,StateName = ? , "
	                              //          + "WorkitemState = ? where ProcessInstanceId = ? and WorkItemId = ?";
	                                if(queuehistorytable){
	                                	queryStr = "update QueueHistoryTable set LockStatus=?,LockedByName = null, LockedTime = null,StateName = ? , "
		                                        + "WorkitemState = ? , Q_UserId=? , AssignedUser=? where ProcessInstanceId = ? and WorkItemId = ?";
	                                }
	                                else{
	                                	queryStr = "update WFInstrumentTable set LockStatus=?,LockedByName = null, LockedTime = null,StateName = ? , "
		                                        + "WorkitemState = ?"+ (qType.equalsIgnoreCase("H")? ", Q_UserId=?":"") + "  , AssignedUser=? where ProcessInstanceId = ? and WorkItemId = ?";
	                              
	                                }
	                                pstmt4 = con.prepareStatement(queryStr);
	                                if(qType.equalsIgnoreCase("H")){
	                                	WFSUtil.DB_SetString(1, "N", pstmt4, dbType);
		                                WFSUtil.DB_SetString(2, stateName, pstmt4, dbType);
		                                pstmt4.setInt(3, workitemState);
		                                pstmt4.setInt(4,0);
		                                WFSUtil.DB_SetString(5, null, pstmt4, dbType);
		                                WFSUtil.DB_SetString(6, procInstID, pstmt4, dbType);
		                                pstmt4.setInt(7, wrkItemID);
		                                parameters.add("N");
		                                parameters.add(procInstID);
		                                parameters.add(wrkItemID);
		                                parameters.add(0);
		                                parameters.add(null);
	                                }else{
	                                	WFSUtil.DB_SetString(1, "N", pstmt4, dbType);
		                                WFSUtil.DB_SetString(2, stateName, pstmt4, dbType);
		                                pstmt4.setInt(3, workitemState);
		                               // pstmt4.setInt(4,0);
		                                WFSUtil.DB_SetString(4, null, pstmt4, dbType);
		                                WFSUtil.DB_SetString(5, procInstID, pstmt4, dbType);
		                                pstmt4.setInt(6, wrkItemID);
		                                parameters.add("N");
		                                parameters.add(procInstID);
		                                parameters.add(wrkItemID);
		                                //parameters.add(0);
		                                parameters.add(null);
	                                }
	                                
	                               
	                                
	                                res = WFSUtil.jdbcExecuteUpdate(procInstID, sessionID, userID, queryStr, pstmt4, parameters, debug, engine);
	                                parameters.clear();
	                                //res = pstmt4.executeUpdate();
	                                pstmt4.clearParameters();
	                            }else{
	                               // queryStr = "update WFInstrumentTable set LockStatus=?,LockedByName = null, LockedTime = null where ProcessInstanceId = ? and WorkItemId = ?";
	                            	if(queuehistorytable){
	                            		 queryStr = "update QueueHistoryTable set LockStatus=?,LockedByName = null, LockedTime = null where ProcessInstanceId = ? and WorkItemId = ?";
	                            	}else{
	                            		queryStr = "update WFInstrumentTable set LockStatus=?,LockedByName = null, LockedTime = null where ProcessInstanceId = ? and WorkItemId = ?";
	                            	}
	                            	pstmt4 = con.prepareStatement(queryStr);
	                                WFSUtil.DB_SetString(1, "N", pstmt4, dbType);
	                                WFSUtil.DB_SetString(2, procInstID, pstmt4, dbType);
	                                pstmt4.setInt(3, wrkItemID);
	                                parameters.add("N");
	                                parameters.add(procInstID);
	                                parameters.add(wrkItemID);
	                                res = WFSUtil.jdbcExecuteUpdate(procInstID, sessionID, userID, queryStr, pstmt4, parameters, debug, engine);
	                                parameters.clear();
	                                //res = pstmt4.executeUpdate();
	                                pstmt4.clearParameters();
	                            }
	                            
	                            if (res > 0) {
	//                                WFSUtil.DB_SetString(1, procInstID, pstmt3, dbType);
	//                                pstmt3.setInt(2, wrkItemID);
	//                                int f = pstmt3.executeUpdate();
	//                                pstmt3.clearParameters();
	//                                if (f == res) {
	                                    if (!con.getAutoCommit()) {
	                                        con.commit();
	                                        con.setAutoCommit(true);
	                                    }
	                                    WFSUtil.generateLog(engine, con, WFSConstant.WFL_WorkItemUnlock, procInstID, wrkItemID, procDefID,
	                                            activityId, actName, qId, userID, username, 0, null, currentDate, null, lockedTime, null);
	
	                                } else {
	//                                    mainCode = WFSError.WM_NOT_LOCKED;
	//                                    subCode = 0;
	//                                    subject = WFSErrorMsg.getMessage(mainCode);
	//                                    descr = WFSErrorMsg.getMessage(subCode);
	//                                    errType = WFSError.WF_TMP;
	//                                    if (!con.getAutoCommit()) {
	//                                        con.rollback();
	//                                        con.setAutoCommit(true);
	//                                    }
	//                                }
	//                            } else {
	//----------------------------------------------------------------------------
	// Changed By											: Prashant
	// Reason / Cause (Bug No if Any)	: Bug No TSR_3.0.1_012
	// Change Description							:	In case a WorkItem is not locked return Error.
	//----------------------------------------------------------------------------
	                                mainCode = WFSError.WM_NOT_LOCKED;
	                                subCode = 0;
	                                subject = WFSErrorMsg.getMessage(mainCode);
	                                descr = WFSErrorMsg.getMessage(subCode);
	                                errType = WFSError.WF_TMP;
	                            }
	                        } else {
	                            mainCode = WFSError.WM_INVALID_WORKITEM;
	                            subCode = 0;
	                            subject = WFSErrorMsg.getMessage(mainCode);
	                            descr = WFSErrorMsg.getMessage(subCode);
	                            errType = WFSError.WF_TMP;
	                        }
	                    }
                    }
                    if ((unlockOption == 'W' || unlockOption == 'w') && !workItemFound) {
                        if (rs != null) {
                            rs.close();
                            rs = null;
                        }
                        if (pstmt != null) {
                            pstmt.close();
                            pstmt = null;
                        }

                        mainCode = WFSError.WM_INVALID_WORKITEM;
                        subCode = 0;
                        subject = WFSErrorMsg.getMessage(mainCode);
                        descr = WFSErrorMsg.getMessage(subCode);
                        errType = WFSError.WF_TMP;
                    }
                }
            } else {
                mainCode = WFSError.WM_INVALID_SESSION_HANDLE;
                subCode = 0;
                subject = WFSErrorMsg.getMessage(mainCode);
                descr = WFSErrorMsg.getMessage(subCode);
                errType = WFSError.WF_TMP;
            }
            if (mainCode == 0) {
                outputXML = new StringBuffer(500);
                outputXML.append(gen.createOutputFile("WMUnlockWorkItem"));
                outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
                outputXML.append(inputParamInfo);
                outputXML.append(gen.closeOutputFile("WMUnlockWorkItem"));
            }
        } catch (SQLException e) {
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WM_INVALID_FILTER;
            subCode = WFSError.WFS_SQL;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_FAT;
            if (e.getErrorCode() == 0) {
                if (e.getSQLState().equalsIgnoreCase("08S01")) {
                    descr = (new JTSSQLError(e.getSQLState())).getMessage() + "(SQL State : " + e.getSQLState() + ")";
                }
            } else {
                descr = e.getMessage();
            }
        } catch (NumberFormatException e) {
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_ILP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch (NullPointerException e) {
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_SYS;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch (JTSException e) {
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = e.getErrorCode();
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.getMessage();
        } catch (Exception e) {
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_EXP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch (Error e) {
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_EXP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } finally {
            try {

                if (!con.getAutoCommit()) {
                    con.rollback();
                    con.setAutoCommit(true);
                }

                if (rs != null) {
                    rs.close();
                    rs = null;
                }
                if (pstmt != null) {
                    pstmt.close();
                    pstmt = null;
                }
                if (pstmt2 != null) {
                    pstmt2.close();
                    pstmt2 = null;
                }
                /*if (pstmt3 != null) {
                    pstmt3.close();
                    pstmt3 = null;
                }*/
                if (pstmt4 != null) {
                    pstmt4.close();
                    pstmt4 = null;
                }

            } catch (Exception e) {
            }
           
        }
        if (mainCode != 0) {
            String strReturn = WFSUtil.generalError(option, engine, gen,mainCode, subCode,errType, subject,descr, inputParamInfo.toString());
			return strReturn;	
           // throw new WFSException(mainCode, subCode, errType, subject, descr);
        }
        return outputXML.toString();
    }

private boolean isPartOfAdminGroup(Connection con, int dbType, int userID) throws SQLException 
{
	PreparedStatement pstmt = null;
	boolean isPartOfAdminGroup = false;
	ResultSet rs = null;
	int groupndex = 0;
	String query ="SELECT GroupIndex FROM WFGROUPVIEW WHERE GroupName = ?";
	pstmt = con.prepareStatement(query);
	pstmt.setString(1, "Business Admin");
	rs = pstmt.executeQuery();
	if(rs.next())
	 groupndex = rs.getInt("GroupIndex");
	try {

        if (rs != null) {
        	rs.close();
        	rs = null;
        }
    } catch (Exception e) {
    }
	try {

        if (pstmt != null) {
        	pstmt.close();
        	pstmt = null;
        }
    } catch (Exception e) {
    }
    String str ="SELECT * FROM WFGROUPMEMBERVIEW WHERE GroupIndex=? AND UserIndex=? ";
    pstmt = con.prepareStatement(str);
	pstmt.setInt(1,groupndex);
	pstmt.setInt(2,userID);
	rs = pstmt.executeQuery();
	if(rs.next())
	{		
		isPartOfAdminGroup =  true;
	}
	try {

        if (rs != null) {
        	rs.close();
        	rs = null;
        }
    } catch (Exception e) {
    }
	try {

        if (pstmt != null) {
        	pstmt.close();
        	pstmt = null;
        }
    } catch (Exception e) {
    }
	return isPartOfAdminGroup;
}

//----------------------------------------------------------------------------------------------------
//	Function Name 				:	WFFetchWorkItems
//	Date Written (DD/MM/YYYY)	:	16/05/2002
//	Author						:	Prashant
//	Input Parameters			:	Connection , XMLParser , XMLGenerator
//	Output Parameters			:   none
//	Return Values				:	String
//	Description					:   Fetches the workItems and their details
//----------------------------------------------------------------------------------------------------
//			CHANGE HISTORY
//----------------------------------------------------------------------------------------------------
// Date						Change By		Change Description (Bug No. (If Any))
// (DD/MM/YYYY)
//	08/07/2004				Dinesh Parikh	WSE_I_5.0.1_696
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
    private String WFFetchWorkItems1(Connection con, XMLParser parser, XMLGenerator gen,boolean printQueryFlag) throws JTSException, WFSException {
    	StringBuffer outputXML = new StringBuffer("");
        Statement stmt = null;
        ResultSet rs = null;
        ResultSetMetaData rsmd = null;
        String subject = null;
        String descr = null;
        String errType = WFSError.WF_TMP;
        String queueFilter = "";
        String query = "";
        String queueFilterStr = " 1 = 1 ";
        String[] result = null;
        //String[] countQuery = {"", "", ""};
		String countQuery = "";
        String lastValueOrderby = null;
        String token = null;
        String columnName = null;
        StringBuffer lastValueQuery = null;
        StringBuffer newInnerOrderBy = new StringBuffer();
        StringBuffer queryStmt = new StringBuffer(500);
        char columnOrder = ' ';
        int jdbcType;
        int groupId = -1;
        int orderByPos = -1;
        int counter = 0;
        int recordsFetched = 0;
        int returnCount = 0;
        int returnCountFlag = -1;
        int mainCode = 0;
        int subCode = 0;
        int nRSize = 0;
        int j = 0;
        int tot = 0;
		PreparedStatement pstmt = null;
        WFBatchInfo batchInfo = null;
		String queryString;
		ArrayList parameters = new ArrayList();
		String engine =null;
		char char21 = 21;
		String string21 = "" + char21;
        try {
            int sessionID = parser.getIntOf("SessionId", 0, false);
            engine = parser.getValueOf("EngineName");
            int dbType = ServerProperty.getReference().getDBType(engine);
            int queueid = parser.getIntOf("QueueId", 0, true);
            String filterValue = "";
            StringBuffer tempXml = null;

            String innerOrderBy = "";
            String queryFilter = "";

            WFParticipant participant = WFSUtil.WFCheckSession(con, sessionID);
            if (participant != null && participant.gettype() == 'U') {
                int userid = participant.getid();
                String username = participant.getname();
                stmt = con.createStatement();
                if (queueid > 0) {
                    //----------------------------------------------------------------------------
                    // Changed By	                : Varun Bhansaly
                    // Changed On                   : 17/01/2007
                    // Reason                       : Bugzilla Id 54
                    // Change Description			: Provide Dirty Read Support for DB2 Database
                    //----------------------------------------------------------------------------
                    /* checking whether user has rights on the queue */
                    rs = stmt.executeQuery("Select QueueId from QUserGroupView where QueueId = " + queueid + " and UserId = " + userid + WFSUtil.getQueryLockHintStr(dbType));
                    if (rs.next()) {
                        queueFilterStr = " Q_QueueId = " + queueid;
                    } else {
                        mainCode = WFSError.WM_NO_MORE_DATA;
                        subCode = WFSError.WFS_NOQ;
                        subject = WFSErrorMsg.getMessage(mainCode);
                        descr = WFSErrorMsg.getMessage(subCode);
                        errType = WFSError.WF_TMP;
                    }
                    if (rs != null) {
                        rs.close();
                        rs = null;
                    }

                    //----------------------------------------------------------------------------
                    // Changed By						: Prashant
                    // Reason / Cause (Bug No if Any)	: Bug No TSR_3.0.2.0007
                    // Change Description				:	Specified Filter criterion not being evaluated
                    //										while locking Workitems in Get/GetNext/GeNextUnlocked Workitem
                    //----------------------------------------------------------------------------
                    if (mainCode == 0) {
                        int filterOpt = 0;
                        rs = stmt.executeQuery("Select FilterOption, FilterValue, QueueFilter from QueueDeftable " + WFSUtil.getTableLockHintStr(dbType) + "  where QueueID = " + queueid);
                        if (rs != null && rs.next()) {
                            filterOpt = rs.getInt(1);
                            if (filterOpt == WFSConstant.WF_EQUAL || filterOpt == WFSConstant.WF_NOTEQ) {
                                filterValue = rs.getString(2);
                                filterValue = rs.wasNull() ? "" : " and " + TO_SANITIZE_STRING(filterValue, true) + (filterOpt == WFSConstant.WF_NOTEQ ? " != " : " = ") + userid;
                            } else {
                                rs.getString(2);
                            }
                            queueFilter = rs.getString(3);
                            if (rs.wasNull()) {
                                queueFilter = "";
                            }
                            rs.close();
                            rs = null;
                        }
                        result = WFSUtil.getQueryFilter(con, queueid, dbType, participant, queueFilter, engine);
                        queryFilter = result[0];
                        innerOrderBy = result[1];
                    }
                } else if (queueid < 0) { // Bug # WFS_6_002, Error only whene queueId is negative.
                    mainCode = WFSError.WM_NO_MORE_DATA;
                    subCode = WFSError.WFS_NOQ;
                    subject = WFSErrorMsg.getMessage(mainCode);
                    descr = WFSErrorMsg.getMessage(subCode);
                    errType = WFSError.WF_TMP;
                }
                if (mainCode == 0) {

                    /* Not Required */ char countFlag = parser.getCharOf("CountFlag", 'N', true);
                    int batchSize = ServerProperty.getReference().getBatchSize();
                    int noOfRectoFetch = parser.getIntOf("NoOfRecordsToFetch", batchSize, true);
                    int lastWIValue = parser.getIntOf("LastWorkItem", 0, true);
                    String lastValue = parser.getValueOf("LastValue", "", true);
                    String lastPIValue = parser.getValueOf("LastProcessInstance", "", true);
                    char sortOrder = parser.getCharOf("SortOrder", 'D', true);
                    int orderBy = parser.getIntOf("OrderBy", 1, true);
                    char dataflag = parser.getCharOf("DataFlag", 'N', true);
                    String fetchLockedFlag = parser.getValueOf("FetchLockedFlag", "N", true); /* Bugzilla Bug 1703 */
                    String returnCountFlagStr = parser.getValueOf("ReturnCountFlag", "N", true); /* Bugzilla Bug 1680 */
                    /**Tag ReturnOnlyCountFlag was added so that it could be called from API WFFetchWorkItemCount()
                     * This is a makeshift implementation, should not be exposed to the Client/ or stated in any manual.
                     */
                    String returnOnlyCountFlag = parser.getValueOf("ReturnOnlyCountFlag", "N", true);
                    String userFilterStr = WFSUtil.getFilter(parser, con, dbType);

                    String sortField = " PriorityLevel ";
                    String tempStr = "";
                    String aliasStr = "";
                    String toReturn = "";
                    String param1 = "";
                    String alias = "";

                    if (returnOnlyCountFlag.trim().equalsIgnoreCase("Y")) {
                        returnCountFlag = 1;
                    } else if (returnCountFlagStr.trim().equalsIgnoreCase("N")) {
                        returnCountFlag = 0;
                    } else {
                        returnCountFlag = 2;
                    }

                    if (noOfRectoFetch > batchSize || noOfRectoFetch <= 0) {
                        noOfRectoFetch = batchSize;
                    }
                    tempXml = new StringBuffer(500 * noOfRectoFetch);
                    /** Specification -
                     *  ORDER BY String present in the XML is to be ignored if ORDER BY is present in the query Filter(Queue User Assoc Filter).
                     */
                    if (dataflag == 'Y' || dataflag == 'y' || orderBy > 100 || !queryFilter.trim().equals("")) {
                        query = "SELECT PARAM1, ALIAS, ToReturn FROM VarAliasTable " + WFSUtil.getTableLockHintStr(dbType) + "  WHERE QueueId = " + queueid + " ORDER BY ID ASC ";
                        rs = stmt.executeQuery(query);
                        counter = 0;
                        while (rs != null && rs.next()) {
                            counter++;
                            param1 = rs.getString(1);
                            alias = rs.getString(2);
                            toReturn = rs.getString(3);
                            if (toReturn.trim().equalsIgnoreCase("Y")) {
                                aliasStr = aliasStr + ", " + param1 + " AS " + alias;
                            }
                            if (orderBy > 100) {
                                if (counter == (orderBy - 100)) {
                                    sortField = " " + param1 + " ";
                                }
                            }
                        }
                        rs.close();
                        rs = null;
                    }
                    String sortStr = (sortOrder == 'A') ? " ASC " : " DESC ";
                    String op = (sortOrder == 'A') ? " > " : " < ";
                    boolean bReverseOrder = (sortOrder == 'A') ? false : true;
                    String orderbyStr = "";

                    if (innerOrderBy.trim().equals("")) {
                        switch (orderBy) {
                            case 1:
                              //  lastValue = lastValue;
                                sortField = " PriorityLevel ";
                                break;
                            case 2:
                                lastValue = lastValue.equals("") ? "" : WFSUtil.TO_STRING(lastValue, true, dbType);
                                sortField = " ProcessInstanceId ";
                                break;
                            case 3:
                                lastValue = lastValue.equals("") ? "" : WFSUtil.TO_STRING(lastValue, true, dbType);
                                sortField = " ActivityName ";
                                break;
                            case 4:
                                lastValue = lastValue.equals("") ? "" : WFSUtil.TO_STRING(lastValue, true, dbType);
                                sortField = " LockedByName ";
                                break;
                            case 5:
                                lastValue = lastValue.equals("") ? "" : WFSUtil.TO_STRING(lastValue, true, dbType);
                                sortField = " IntroducedBy ";
                                break;
                            case 6:
                                lastValue = lastValue.equals("") ? "" : WFSUtil.TO_STRING(lastValue, true, dbType);
                                sortField = " InstrumentStatus ";
                                break;
                            case 7:
                                lastValue = lastValue.equals("") ? "" : WFSUtil.TO_STRING(lastValue, true, dbType);
                                sortField = " CheckListCompleteFlag  ";
                                break;
                            case 8:
                                lastValue = lastValue.equals("") ? "" : WFSUtil.TO_STRING(lastValue, true, dbType);
                                sortField = " LockStatus ";
                                break;
                            case 9:
                                lastValue = lastValue.equals("") ? "" : WFSUtil.TO_NUMBER(lastValue, true, dbType);
                                sortField = " WorkItemState ";
                                break;
                            case 10:
                                lastValue = lastValue.equals("") ? "" : WFSUtil.TO_DATE(lastValue, true, dbType);
                                sortField = " EntryDateTime ";
                                break;
                            case 11:
                                lastValue = lastValue.equals("") ? "" : WFSUtil.TO_DATE(lastValue, true, dbType);
                                sortField = " ValidTill ";
                                break;
                            case 12:
                                lastValue = lastValue.equals("") ? "" : WFSUtil.TO_DATE(lastValue, true, dbType);
                                sortField = " LockedTime ";
                                break;
                            case 13:
                                lastValue = lastValue.equals("") ? "" : WFSUtil.TO_DATE(lastValue, true, dbType);
                                sortField = " IntroductionDateTime ";
                                break;
                            case 17:
                                lastValue = lastValue.equals("") ? "" : WFSUtil.TO_STRING(lastValue, true, dbType);
                                sortField = " Status ";
                                break;
                            case 18:
                                lastValue = lastValue.equals("") ? "" : WFSUtil.TO_DATE(lastValue, true, dbType);
                                sortField = " CreatedDateTime ";
                                break;
                            case 19:
                                lastValue = lastValue.equals("") ? "" : WFSUtil.TO_DATE(lastValue, true, dbType);
                                sortField = " ExpectedWorkItemDelay ";
                                break;
							case 20:
                                lastValue = lastValue.equals("") ? "" : WFSUtil.TO_DATE(lastValue, true, dbType);
                                sortField = " ProcessedBy ";
                                break;
                            default:
                                if (orderBy > 100) {
                                    rs = stmt.executeQuery("SELECT " + TO_SANITIZE_STRING(sortField, true) + " FROM QueueHistoryTable " + WFSUtil.getTableLockHintStr(dbType) + "  WHERE 1 = 2");
                                    if (rs != null) {
                                        rs.next();
                                        rsmd = rs.getMetaData();
                                        if (!lastValue.equals("")) {
                                            lastValue = WFSUtil.TO_SQL_EXT(lastValue, rsmd.getColumnType(1), dbType);
                                        }
                                        rs.close();
                                        rs = null;
                                        rsmd = null;
                                    }
                                } else {
                                    throw new WFSException(WFSError.WF_OTHER, WFSError.WFS_ILP,
                                            WFSError.WF_TMP,
                                            WFSErrorMsg.getMessage(WFSError.WF_OTHER),
                                            WFSErrorMsg.getMessage(WFSError.WFS_ILP));
                                }
                        }
                        if (lastValue.equals("")) {
                            lastValue = null;
                        }

                        if (orderBy == 2) {
                            orderbyStr = " ORDER BY ProcessInstanceID " + sortStr + ", WorkItemID " + sortStr;
                        } else {
                            orderbyStr = " ORDER BY " + TO_SANITIZE_STRING(sortField, true) + sortStr + ", ProcessInstanceID " + sortStr + ", WorkItemID " + sortStr;
                        }
                        String batchStr = "";

                        if (!lastPIValue.equals("")) {
                            ArrayList arList = new ArrayList();
                            arList.add(new WFBatchInfo(sortField, sortOrder, lastValue));

                            batchStr = getBatchString(arList, 0, WFSUtil.TO_STRING(lastPIValue, true, dbType), lastWIValue, op, dbType);

                            orderbyStr = " AND (" + batchStr + ") " + TO_SANITIZE_STRING(orderbyStr, true);
                        }
                    } else { /* Will be executed only when there is OrderBy string in Queue User Assoc Filter */
                        if (bReverseOrder || !lastPIValue.equals("")) {
                            ArrayList arList = new ArrayList();

                            StringTokenizer colTokenizer = null;
                            //Find the last values of the columns corresponding to the order by columns
                            //First of all find the column names included in the order by string
                            StringTokenizer st = new StringTokenizer(innerOrderBy, ",");
                            while (st.hasMoreTokens()) {
                                token = st.nextToken();
                                colTokenizer = new StringTokenizer(token);

                                columnName = colTokenizer.nextToken();
                                if (colTokenizer.hasMoreTokens()) {
                                    columnOrder = colTokenizer.nextToken().toUpperCase().trim().charAt(0);
                                } else {
                                    columnOrder = 'A';
                                }
                                if (bReverseOrder) {
                                    columnOrder = (columnOrder == 'A' ? 'D' : 'A');
                                }

                                batchInfo = new WFBatchInfo(columnName, columnOrder, "");
                                arList.add(batchInfo);
                            }

                            lastValueQuery = new StringBuffer();

                            for (int iTemp = 0; iTemp < arList.size(); iTemp++) {
                                batchInfo = (WFBatchInfo) arList.get(iTemp);
                                if (iTemp != 0) {
                                    lastValueQuery.append(", ");
                                    newInnerOrderBy.append(", ");
                                }
                                lastValueQuery.append(batchInfo.columnName);
                                newInnerOrderBy.append(batchInfo.columnName).append(" ").append(batchInfo.orderBy == 'A' ? "ASC" : "DESC");
                            }
                            newInnerOrderBy.append(", ProcessInstanceId ").append(sortStr).append(", WorkItemId ").append(sortStr);

                            innerOrderBy = newInnerOrderBy.toString();
							
							/* replacement for QueueDataTable.* -Code Optimization */ 
							String qdtStr = "ProcessInstanceId, WorkItemId,"
                                                                + " VAR_INT1, VAR_INT2, VAR_INT3, VAR_INT4, VAR_INT5, VAR_INT6, VAR_INT7,"
                                                                    + "VAR_INT8,VAR_FLOAT1, VAR_FLOAT2, VAR_DATE1, VAR_DATE2, VAR_DATE3, VAR_DATE4,VAR_DATE5, VAR_DATE6, VAR_LONG1, VAR_LONG2, VAR_LONG3, VAR_LONG4,VAR_LONG5, VAR_LONG6, VAR_STR1, VAR_STR2, VAR_STR3, VAR_STR4, "
                                                                    + "VAR_STR5, VAR_STR6, VAR_STR7, VAR_STR8,VAR_STR9, VAR_STR10, VAR_STR11, VAR_STR12, VAR_STR13, VAR_STR14, VAR_STR15, VAR_STR16, VAR_STR17, VAR_STR18, VAR_STR19, VAR_STR20"
                                                                    + ",InstrumentStatus ,CheckListCompleteFlag ,SaveStage, HoldStatus, "+
							"Status, ReferredTo, ReferredToName, ReferredBy, ReferredByName, "+ "ChildProcessInstanceId ChildWorkitemId, ParentWorkItemID, CalendarName";

                            if (!lastPIValue.equals("")) {
                                /*rs = stmt.executeQuery("Select " + lastValueQuery.toString() + " From ( Select QueueDataTable.* " + aliasStr + " From QueueDataTable Where ProcessInstanceID = " + WFSUtil.TO_STRING(lastPIValue, true, dbType) + " AND WorkItemID = " + lastWIValue + ") Table10 ");*/
								
								queryString = "Select " + lastValueQuery.toString() + " From ( Select " + qdtStr + TO_SANITIZE_STRING(aliasStr, true) + " From WFInstrumentTable " + WFSUtil.getTableLockHintStr(dbType) + "  Where ProcessInstanceID = ? " +
								"AND WorkItemID  = ?  ) Table10  ";
								pstmt = con.prepareStatement(queryString);
								WFSUtil.DB_SetString(1, lastPIValue, pstmt, dbType);
								pstmt.setInt(2, lastWIValue);
								parameters.addAll(Arrays.asList(lastPIValue,lastWIValue));
								rs = WFSUtil.jdbcExecuteQuery(lastPIValue,sessionID,userid,queryString,pstmt,parameters,printQueryFlag,engine);
                                ResultSetMetaData rsmdTemp = rs.getMetaData();
                                if (rs.next()) {
                                    for (int iTemp = 0; iTemp < arList.size(); iTemp++) {
                                        batchInfo = (WFBatchInfo) arList.get(iTemp);

                                        batchInfo.lastValue = rs.getString(batchInfo.columnName);
                                        jdbcType = rsmdTemp.getColumnType(iTemp + 1);

                                        batchInfo.lastValue = WFSUtil.TO_SQL_EXT(batchInfo.lastValue, jdbcType, dbType);
                                    }

                                    //debug
                                    lastValueOrderby = getBatchString(arList, 0, WFSUtil.TO_STRING(lastPIValue, true, dbType), lastWIValue, op, dbType);
                                }

                                if (rs != null) {
                                    rs.close();
                                    rs = null;
                                }
								if (pstmt != null)
									pstmt.close();
                            //reverse order by for the innerOrderBy string.......
                            }

                        } else {
                            //append processintanceid, workitemid
                            innerOrderBy = innerOrderBy + ", ProcessInstanceId " + sortStr + ", WorkItemId " + sortStr;
                        }

                        innerOrderBy = (lastValueOrderby == null || lastValueOrderby.trim().equals("") ? " " : " AND (" + lastValueOrderby + ")") + " ORDER BY " + innerOrderBy;
                        orderbyStr = innerOrderBy;
                    }


                    /*String WLTColStr = " QueueDataTable.ProcessInstanceId, QueueDataTable.ProcessInstanceId as ProcessInstanceName, ProcessInstanceTable.ProcessDefId, ProcessName, ActivityId, ActivityName, PriorityLevel, InstrumentStatus, LockStatus, LockedByName, ValidTill, CreatedByName, ProcessInstanceTable.CreatedDateTime, Statename, CheckListCompleteFlag, EntryDateTime, LockedTime, IntroductionDateTime, IntroducedBy, AssignedUser, QueueDataTable.WorkItemId, QueueName, AssignmentType, ProcessInstanceState, QueueType, Status, Q_QueueID, ReferredByname, ReferredTo, Q_UserID, FILTERVALUE, Q_StreamId, CollectFlag, QueueDataTable.ParentWorkItemId, ProcessedBy, LastProcessedBy, ProcessVersion, WORKITEMSTATE, PREVIOUSSTAGE, ExpectedWorkItemDelay";*/
					
					String WLTColStr = " ProcessInstanceId, ProcessInstanceId as ProcessInstanceName, ProcessDefId, ProcessName, ActivityId, ActivityName, PriorityLevel, InstrumentStatus, LockStatus, LockedByName, ValidTill, CreatedByName, CreatedDateTime, Statename, CheckListCompleteFlag, EntryDateTime, LockedTime, IntroductionDateTime, IntroducedBy, AssignedUser, WorkItemId, QueueName, AssignmentType, ProcessInstanceState, QueueType, Status, Q_QueueID, ReferredByname, ReferredTo, Q_UserID, FILTERVALUE, Q_StreamId, CollectFlag, ParentWorkItemId, ProcessedBy, LastProcessedBy, ProcessVersion, WORKITEMSTATE, PREVIOUSSTAGE, ExpectedWorkItemDelay ";

                    String WLTColStr1 = " ProcessInstanceId, ProcessDefId, ProcessName, ActivityId, ActivityName, PriorityLevel, InstrumentStatus, LockStatus, LockedByName, ValidTill, CreatedByName, CreatedDateTime, Statename, CheckListCompleteFlag, EntryDateTime, LockedTime, IntroductionDateTime, IntroducedBy, AssignedUser, WorkItemId, QueueName, AssignmentType, ProcessInstanceState, QueueType, Status, Q_QueueID, ReferredByname, ReferredTo, Q_UserID, FILTERVALUE, Q_StreamId, CollectFlag, ParentWorkItemId, ProcessedBy, LastProcessedBy, ProcessVersion, WORKITEMSTATE, PREVIOUSSTAGE, ExpectedWorkItemDelay";
					
                    String QDTColStr = " ,VAR_INT1, VAR_INT2, VAR_INT3, VAR_INT4, VAR_INT5, VAR_INT6, VAR_INT7,"
                                + "VAR_INT8,VAR_FLOAT1, VAR_FLOAT2, VAR_DATE1, VAR_DATE2, VAR_DATE3, VAR_DATE4,VAR_DATE5, VAR_DATE6, VAR_LONG1, VAR_LONG2, VAR_LONG3, VAR_LONG4,VAR_LONG5, VAR_LONG6, VAR_STR1, VAR_STR2, VAR_STR3, VAR_STR4, "
                                + "VAR_STR5, VAR_STR6, VAR_STR7, VAR_STR8,VAR_STR9, VAR_STR10, VAR_STR11, VAR_STR12, VAR_STR13, VAR_STR14, VAR_STR15, VAR_STR16, VAR_STR17, VAR_STR18, VAR_STR19, VAR_STR20";

                    if (!queryFilter.trim().equals("")) {
                        queryFilter = " AND " + TO_SANITIZE_STRING(queryFilter, true);
                    }

                    /*query = "SELECT " + WLTColStr1 + QDTColStr + " FROM ( SELECT * FROM (SELECT " + WLTColStr + QDTColStr + aliasStr + " FROM Worklisttable, ProcessInstanceTable, QueueDatatable " + " WHERE QueueDatatable.ProcessInstanceId = ProcessInstanceTable.ProcessInstanceId AND Worklisttable.ProcessInstanceId = QueueDatatable.ProcessInstanceId AND Worklisttable.Workitemid = QueueDatatable.Workitemid) Table1 WHERE " + queueFilterStr + userFilterStr + filterValue + queryFilter + orderbyStr +
                            " ) Table2 " + WFSUtil.getFetchSuffixStr(dbType, noOfRectoFetch + 1, "");*/
				
					
					query = "SELECT " + WLTColStr1 + QDTColStr + " FROM ( SELECT * FROM ( SELECT " + WLTColStr + 
					QDTColStr + TO_SANITIZE_STRING(aliasStr, true) + " FROM WFInstrumentTable " + WFSUtil.getTableLockHintStr(dbType) + "  where " +
					"  RoutingStatus = " + WFSUtil.TO_STRING("N",true, dbType) + "and LockStatus = "+
					WFSUtil.TO_STRING("N",true, dbType) + " ) Table1 WHERE " + TO_SANITIZE_STRING(queueFilterStr, true) + TO_SANITIZE_STRING(userFilterStr, true) + TO_SANITIZE_STRING(filterValue, true) + TO_SANITIZE_STRING(queryFilter, true) + TO_SANITIZE_STRING(orderbyStr, true) +
                    " ) Table2 " + WFSUtil.getFetchSuffixStr(dbType, noOfRectoFetch + 1, "");
					
                    /*countQuery[0] = "SELECT COUNT(*) FROM ( SELECT * FROM (SELECT " + WLTColStr + QDTColStr + aliasStr + " FROM Worklisttable, ProcessInstanceTable, QueueDatatable " + " WHERE QueueDatatable.ProcessInstanceId = ProcessInstanceTable.ProcessInstanceId AND Worklisttable.ProcessInstanceId = QueueDatatable.ProcessInstanceId AND Worklisttable.Workitemid = QueueDatatable.Workitemid) Table1 WHERE " + queueFilterStr + userFilterStr + filterValue + queryFilter + " ) Table2 "; */					
					countQuery = "SELECT COUNT(*) FROM ( SELECT * FROM (SELECT " + WLTColStr + QDTColStr + TO_SANITIZE_STRING(aliasStr, true) + " FROM WFInstrumentTable " + WFSUtil.getTableLockHintStr(dbType) + "  WHERE "+
					"  RoutingStatus = " + WFSUtil.TO_STRING("N",true, dbType) + "and LockStatus = "+
					WFSUtil.TO_STRING("N",true, dbType) +" ) Table1 WHERE " + TO_SANITIZE_STRING(queueFilterStr, true) + TO_SANITIZE_STRING(userFilterStr, true) + TO_SANITIZE_STRING(filterValue, true) + TO_SANITIZE_STRING(queryFilter, true) + " ) Table2 "; 

					
                    /*query = "SELECT " + WLTColStr1 + QDTColStr + " FROM ( SELECT * FROM (SELECT " + WLTColStr + QDTColStr + aliasStr + " FROM WorkInProcesstable, ProcessInstanceTable, QueueDatatable WHERE QueueDatatable.ProcessInstanceId = ProcessInstanceTable.ProcessInstanceId AND WorkInProcesstable.ProcessInstanceId = QueueDatatable.ProcessInstanceId AND WorkInProcesstable.Workitemid = QueueDatatable.Workitemid) Table3 WHERE " + queueFilterStr + userFilterStr + filterValue + queryFilter +
                            orderbyStr + ") Table4 " + WFSUtil.getFetchSuffixStr(dbType, noOfRectoFetch + 1, "");*/
														
                    if (queueid == 0 || fetchLockedFlag.trim().equalsIgnoreCase("Y")) {
					
                        countQuery = "SELECT COUNT(*) FROM ( SELECT * FROM (SELECT " + WLTColStr + QDTColStr + TO_SANITIZE_STRING(aliasStr, true) + " FROM WFInstrumentTable " + WFSUtil.getTableLockHintStr(dbType) + "  where RoutingStatus = " + WFSUtil.TO_STRING("N",true, dbType) + " )Table3 WHERE " + TO_SANITIZE_STRING(queueFilterStr, true) + TO_SANITIZE_STRING(userFilterStr, true) + TO_SANITIZE_STRING(filterValue, true) + TO_SANITIZE_STRING(queryFilter, true) + ") Table4 ";
						
						query = "SELECT " + WLTColStr1 + QDTColStr + " FROM ( SELECT * FROM (SELECT " + WLTColStr + QDTColStr + TO_SANITIZE_STRING(aliasStr, true) + " FROM WFInstrumentTable " + WFSUtil.getTableLockHintStr(dbType) + "  where RoutingStatus = " +WFSUtil.TO_STRING("N",true, dbType) + ") Table3 WHERE " + TO_SANITIZE_STRING(queueFilterStr, true) + TO_SANITIZE_STRING(userFilterStr, true) + TO_SANITIZE_STRING(filterValue, true) + TO_SANITIZE_STRING(queryFilter, true) +TO_SANITIZE_STRING(orderbyStr, true) + ") Table4 " + WFSUtil.getFetchSuffixStr(dbType, noOfRectoFetch + 1, "");
                        //queryStmt.append(" UNION ALL ").append(" ( ").append(query).append(" ) ");
												
                        if (queueid == 0) {
                            /*query = "SELECT " + WLTColStr1 + QDTColStr + " FROM ( SELECT * FROM (SELECT " + WLTColStr + QDTColStr + aliasStr + " FROM PendingWorkListTable, ProcessInstanceTable, QueueDatatable WHERE QueueDatatable.ProcessInstanceId = ProcessInstanceTable.ProcessInstanceId AND PendingWorkListTable.ProcessInstanceId = QueueDatatable.ProcessInstanceId AND PendingWorkListTable.Workitemid = QueueDatatable.Workitemid) Table5 WHERE " + queueFilterStr + userFilterStr + filterValue +
                                    queryFilter + orderbyStr + ") Table6 " + WFSUtil.getFetchSuffixStr(dbType, noOfRectoFetch + 1, "");*/
									
							query = "SELECT " + WLTColStr1 + QDTColStr + " FROM ( SELECT * FROM (SELECT " + WLTColStr + QDTColStr + TO_SANITIZE_STRING(aliasStr, true) + " FROM WFInstrumentTable " + WFSUtil.getTableLockHintStr(dbType) + "  where RoutingStatus in ( " + WFSUtil.TO_STRING("N",true, dbType) + " , " + WFSUtil.TO_STRING("R",true, dbType) + " ) " + ")  Table5 WHERE " + TO_SANITIZE_STRING(queueFilterStr, true) + TO_SANITIZE_STRING(userFilterStr, true) + TO_SANITIZE_STRING(filterValue, true) +TO_SANITIZE_STRING(queryFilter, true) + TO_SANITIZE_STRING(orderbyStr, true) + ") Table6 " + WFSUtil.getFetchSuffixStr(dbType, noOfRectoFetch + 1, "");
				

                            /*countQuery[2] = "SELECT COUNT(*) FROM ( SELECT * FROM (SELECT " + WLTColStr + QDTColStr + aliasStr + " FROM PendingWorkListTable, ProcessInstanceTable, QueueDatatable WHERE QueueDatatable.ProcessInstanceId = ProcessInstanceTable.ProcessInstanceId AND PendingWorkListTable.ProcessInstanceId = QueueDatatable.ProcessInstanceId AND PendingWorkListTable.Workitemid = QueueDatatable.Workitemid) Table5 WHERE " + queueFilterStr + userFilterStr + filterValue + queryFilter +
                                    ") Table6 "; */
							
							countQuery = "SELECT COUNT(*) FROM ( SELECT * FROM (SELECT " + WLTColStr + QDTColStr + TO_SANITIZE_STRING(aliasStr, true) + " FROM WFInstrumentTable " + WFSUtil.getTableLockHintStr(dbType) + "  WHERE RoutingStatus in ( " + WFSUtil.TO_STRING("N",true, dbType) + " , " + WFSUtil.TO_STRING("R",true, dbType) + " ) " +
					        ") Table1 WHERE " + TO_SANITIZE_STRING(queueFilterStr, true) + TO_SANITIZE_STRING(userFilterStr, true) + TO_SANITIZE_STRING(filterValue, true) + TO_SANITIZE_STRING(queryFilter, true) + " ) Table2 "; 

                            //queryStmt.append(" UNION ALL ").append(" ( ").append(query).append(" ) ");
                        }
                    }
					queryStmt.append(" ( ").append(query).append(" ) ");
                    if (returnCountFlag == 0 || returnCountFlag == 2) {
                        query =
                                "SELECT ProcessInstanceId, ProcessInstanceId as ProcessInstanceName, ProcessDefId, ProcessName, ActivityId, ActivityName, PriorityLevel, InstrumentStatus, LockStatus, LockedByName, ValidTill, CreatedByName, CreatedDateTime, Statename, CheckListCompleteFlag, EntryDateTime, LockedTime, IntroductionDateTime, IntroducedBy, AssignedUser, WorkItemId, QueueName, AssignmentType, ProcessInstanceState, QueueType, Status, Q_QueueID, null as TurnaroundTime ,ReferredByname, ReferredTo as ReferTo , ExpectedWorkitemDelay, ProcessedBy  " +
                                TO_SANITIZE_STRING(aliasStr, true) + " FROM ( " + queryStmt.toString() + " ) Table7 WHERE " + TO_SANITIZE_STRING(queueFilterStr, true) + TO_SANITIZE_STRING(orderbyStr, true) + WFSUtil.getFetchSuffixStr(dbType, noOfRectoFetch + 1, "");
						pstmt = con.prepareStatement(query);
						rs = WFSUtil.jdbcExecuteQuery(null,sessionID,userid,query,pstmt,null,printQueryFlag,engine);
                        //rs = stmt.executeQuery(query);
                        if (dataflag == 'Y') {
                            rsmd = rs.getMetaData();
                            nRSize = rsmd.getColumnCount();
                        }
						String userName = null;
						String personalName = null;
                        while (j < noOfRectoFetch && rs.next()) {
                            tempXml.append("<Instrument>\n");
                            tempXml.append(gen.writeValueOf("ProcessInstanceId", rs.getString(1)));
                            tempXml.append(gen.writeValueOf("WorkItemName", rs.getString(2)));
                            tempXml.append(gen.writeValueOf("RouteId", rs.getString(3)));
                            tempXml.append(gen.writeValueOf("RouteName", rs.getString(4)));
                            tempXml.append(gen.writeValueOf("WorkStageId", rs.getString(5)));
                            tempXml.append(gen.writeValueOf("ActivityName", rs.getString(6)));
                            tempXml.append(gen.writeValueOf("PriorityLevel", rs.getString(7)));
                            tempXml.append(gen.writeValueOf("InstrumentStatus", rs.getString(8)));
                            tempXml.append(gen.writeValueOf("LockStatus", rs.getString(9)));
                            //tempXml.append(gen.writeValueOf("LockedByUserName", rs.getString(10)));
							userName = rs.getString(10);	/*WFS_8.0_039*/
						    WFUserInfo userInfo = (WFUserInfo) CachedObjectCollection.getReference().getCacheObject(con, engine, 0, WFSConstant.CACHE_CONST_UserCache, "userName" + string21 + userName).getData();
							if (userInfo!=null){
								personalName = userInfo.getPersonalName();
							} else {
								personalName = null;
							}
							tempXml.append(gen.writeValueOf("LockedByUserName", userName));
							tempXml.append(gen.writeValueOf("LockedByPersonalName", personalName));

                            tempXml.append(gen.writeValueOf("ExpiryDateTime", rs.getString(11)));
                            tempXml.append(gen.writeValueOf("CreatedByUserName", rs.getString(12)));
                            tempXml.append(gen.writeValueOf("CreationDateTime", rs.getString(13)));
                            tempXml.append(gen.writeValueOf("WorkitemState", rs.getString(14)));
                            tempXml.append(gen.writeValueOf("CheckListCompleteFlag", rs.getString(15)));
                            tempXml.append(gen.writeValueOf("EntryDateTime", rs.getString(16)));
                            tempXml.append(gen.writeValueOf("LockedTime", rs.getString(17)));
                            tempXml.append(gen.writeValueOf("IntroductionDateTime", rs.getString(18)));
                            //tempXml.append(gen.writeValueOf("IntroducedBy", rs.getString(19)));
                            //tempXml.append(gen.writeValueOf("AssignedTo", rs.getString(20)));
							userName = rs.getString(19);	/*WFS_8.0_039*/
						    userInfo = (WFUserInfo) CachedObjectCollection.getReference().getCacheObject(con, engine, 0, WFSConstant.CACHE_CONST_UserCache, "userName" + string21 + userName).getData();
							if (userInfo!=null){
								personalName = userInfo.getPersonalName();
							} else {
								personalName = null;
							}
							tempXml.append(gen.writeValueOf("IntroducedBy", userName));
							tempXml.append(gen.writeValueOf("IntroducedByPersonalName", personalName));
							userName = rs.getString(20);	/*WFS_8.0_039*/
                            userInfo = (WFUserInfo) CachedObjectCollection.getReference().getCacheObject(con, engine, 0, WFSConstant.CACHE_CONST_UserCache, "userName" + string21 + userName).getData();
							if (userInfo!=null){
								personalName = userInfo.getPersonalName();
							} else {
								personalName = null;
							}
							tempXml.append(gen.writeValueOf("AssignedTo", userName));
							tempXml.append(gen.writeValueOf("AssignedToPersonalName", personalName));
                            tempXml.append(gen.writeValueOf("WorkItemId", rs.getString(21)));
                            tempXml.append(gen.writeValueOf("QueueName", rs.getString(22)));
                            tempXml.append(gen.writeValueOf("AssignmentType", rs.getString(23)));
                            tempXml.append(gen.writeValueOf("ProcessInstanceState", rs.getString(24)));
                            tempXml.append(gen.writeValueOf("QueueType", rs.getString(25)));
                            tempXml.append(gen.writeValueOf("Status", rs.getString(26)));
                            tempXml.append(gen.writeValueOf("QueueId", rs.getString(27)));
                            tempXml.append(gen.writeValueOf("Turnaroundtime", rs.getString(28)));
                            tempXml.append(gen.writeValueOf("Referredby", rs.getString(29)));
                            tempXml.append(gen.writeValueOf("Referredto", rs.getString(30)));
							tempXml.append(gen.writeValueOf("TurnAroundDateTime", rs.getString("ExpectedWorkItemDelay")));
							userName = rs.getString("ProcessedBy");	/*WFS_8.0_052*/
                            userInfo = (WFUserInfo) CachedObjectCollection.getReference().getCacheObject(con, engine, 0, WFSConstant.CACHE_CONST_UserCache, "userName" + string21 + userName).getData();
							if (userInfo!=null){
								personalName = userInfo.getPersonalName();
							} else {
								personalName = null;
							}
							tempXml.append(gen.writeValueOf("ProcessedBy", userName));
							tempXml.append(gen.writeValueOf("ProcessedByPersonalName", personalName));
                            tempXml.append("<Data>\n");
                            // Code added for Processmanager functionality for fetching workitems based on logged in user for WSE_5.0.1_003
                            for (int k = 0; k < nRSize - 32; k++) {
                                tempXml.append("<QueueData>\n");
                                tempXml.append(gen.writeValueOf("Name", rsmd.getColumnLabel(33 + k)));
                                tempXml.append(gen.writeValueOf("Value", rs.getString(33 + k)));
                                tempXml.append("\n</QueueData>\n");
                            }
                            tempXml.append("</Data>\n");
                            tempXml.append("</Instrument>\n");
                            j++;
                            tot++;
                        }
                        if (rs.next()) {
                            tot++;
                        }
                        if (rs != null) {
                            rs.close();
                            rs = null;
                        }
                        if (j > 0) {
                            tempXml.insert(0, "<Instruments>\n");
                            tempXml.append("</Instruments>\n");
                        } else {
                            mainCode = WFSError.WM_NO_MORE_DATA;
                            subCode = 0;
                            subject = WFSErrorMsg.getMessage(mainCode);
                            descr = WFSErrorMsg.getMessage(subCode);
                            errType = WFSError.WF_TMP;
                        }
                    }
                    if (returnCountFlag == 1 || returnCountFlag == 2) {
                        /*for (int i = 0; i < 3; i++) {
                            query = countQuery[i];
                            if (!query.equals("")) {
                                rs = stmt.executeQuery(query);
                                if (rs != null && rs.next()) {
                                    returnCount += rs.getInt(1);
                                }
                            }
                        }*/
						query = countQuery ;
						if (!query.equals("")) {
							rs = stmt.executeQuery(query);
							if (rs != null && rs.next()) {
								returnCount += rs.getInt(1);
							}
                        }
					   stmt.close(); /*WFS_7.1_040*/
                       rs.close();   /*WFS_7.1_040*/
                    }
                    tempXml.append(gen.writeValueOf("RetrievedCount", String.valueOf(j)));
                    tempXml.append(gen.writeValueOf("Count", String.valueOf(tot)));
                    tempXml.append(gen.writeValueOf("WorkitemCount", String.valueOf(returnCount)));
                }
            } else {
                mainCode = WFSError.WM_INVALID_SESSION_HANDLE;
                subCode = 0;
                subject = WFSErrorMsg.getMessage(mainCode);
                descr = WFSErrorMsg.getMessage(subCode);
                errType = WFSError.WF_TMP;
            }
            if (mainCode == 0) {
                outputXML = new StringBuffer(500);
                outputXML.append(gen.createOutputFile("WMFetchInstrumentList"));
                outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
                outputXML.append(tempXml);
                outputXML.append(gen.closeOutputFile("WMFetchInstrumentList"));
            }
        } catch (SQLException e) {
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WM_INVALID_FILTER;
            subCode = WFSError.WFS_SQL;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_FAT;
            if (e.getErrorCode() == 0) {
                if (e.getSQLState().equalsIgnoreCase("08S01")) {
                    descr = (new JTSSQLError(e.getSQLState())).getMessage() + "(SQL State : " + e.getSQLState() + ")";
                }
            } else {
                descr = e.getMessage();
            }
        } catch (NumberFormatException e) {
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_ILP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch (NullPointerException e) {
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_SYS;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch (WFSException e) {
            mainCode = WFSError.WM_NO_MORE_DATA;
            subCode = 0;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = WFSErrorMsg.getMessage(subCode);
        } catch (JTSException e) {
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = e.getErrorCode();
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.getMessage();
        } catch (Exception e) {
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_EXP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch (Error e) {
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_EXP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } finally {
            try {
                if (rs != null) {
                    rs.close();
                    rs = null;
                }
            } catch (Exception e) {
            }
            try {
                if (stmt != null) {
                    stmt.close();
                    stmt = null;
                }
            } catch (Exception e) {
            }
            
        }
        if (mainCode != 0) {
            throw new WFSException(mainCode, subCode, errType, subject, descr);
        }
        return outputXML.toString();
    }
//----------------------------------------------------------------------------------------------------
//	Function Name 				:	WMReferWorkItem
//	Date Written (DD/MM/YYYY)	:	16/05/2002
//	Author						:	Prashant
//	Input Parameters			:	Connection , XMLParser , XMLGenerator
//	Output Parameters			:   none
//	Return Values				:	String
//	Description					:   Refer WorkItem to a User
//----------------------------------------------------------------------------------------------------
//  Change Description          : Changes for Code Optimization-Merging of WorkFlow 
//								  tables to WFInstrumentTable, logging of Query and removal of throw WFSException
//  Changed by					: Shweta Singhal
    public String WFReferWorkItem(Connection con, XMLParser parser,
            XMLGenerator gen) throws JTSException, WFSException {
    	StringBuffer outputXML = new StringBuffer("");
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        int mainCode = 0;
        int subCode = 0;
        String subject = null;
        String descr = null;
        String errType = WFSError.WF_TMP;
        String comments = "";
        String engine= null;
        String option = parser.getValueOf("Option", "", false);
		int Q_DivertedByUserId = 0;
                String createdDateTime = "";
                String entryDateTime = "";
                String introducedDateTime = "";
        try {
            int sessionID = parser.getIntOf("SessionId", 0, false);
            String procInstID = parser.getValueOf("ProcessInstanceId", "", false);
            int wrkItemID = parser.getIntOf("WorkItemId", 0, false);
            char emailnotify = parser.getCharOf("Emailnotify", 'N', true);
            String TargetUser = parser.getValueOf("TargetUser", "", false);
            engine = parser.getValueOf("EngineName");
            WFConfigLocator configLocator=null;
            int dbType = ServerProperty.getReference().getDBType(engine);
            //emailnotify = 'Y'; /* WFS_5_137 */
            //OF Optimization
            boolean debug = parser.getValueOf("DebugFlag", "N", true).equalsIgnoreCase("Y");
            ArrayList parameters = new ArrayList();
            String queryStr = null;
            WFParticipant participant = WFSUtil.WFCheckSession(con, sessionID);
            XMLParser parser1 = null;
            if (participant != null && participant.gettype() == 'U') {
                int userID = participant.getid();
                String username = participant.getname();
                /**
				 * Changed by: Mohnish Chopra
				 * Change Description : Return Error if workitem has expired.
				 * 
				 */
            	if(WFSUtil.isWorkItemExpired(con, dbType, procInstID, wrkItemID, sessionID, userID, debug, engine)){
    				/*
                    throw new WFSException(mainCode, subCode, errType, subject, descr);
                */
    				    mainCode = WFSError.WF_OPERATION_FAILED;
    		            subCode = WFSError.WM_WORKITEM_EXPIRED;
    		            subject = WFSErrorMsg.getMessage(mainCode);
    		            errType = WFSError.WF_TMP;
    		            descr = WFSErrorMsg.getMessage(subCode);
    		            String strReturn = WFSUtil.generalError(option, engine, gen,
    	   	                   mainCode, subCode,
    	   	                   errType, subject,
    	   	                    descr);
    	   	             
    	   	        return strReturn;	
                
    			}
                configLocator = WFConfigLocator.getInstance();
                String strConfigFileName = configLocator.getPath(Location.IBPS_CONFIG) + File.separator + WFSConstant.CONST_DIRECTORY_CONFIG + File.separator + WFSConstant.CONST_FILE_WFAPPCONFIGPARAM;
                XMLParser parserTemp = new XMLParser(WFSUtil.readFile(strConfigFileName));
                String notifyMe = parserTemp.getValueOf(WFSConstant.CONST_NOTIFYBYEMAIL, "N", false);
                emailnotify=notifyMe.equalsIgnoreCase("Y")?(emailnotify='Y'):(emailnotify='N');
				// Process Variant Support
                queryStr = "Select WorkItemState, AssignedUser, Q_QueueId, ProcessDefID, ActivityID, ActivityName,AssignmentType,ProcessVariantId,createddatetime , introductiondatetime, entrydatetime from WFInstrumentTable where ProcessInstanceID = ? and WorkItemID = ? and Q_UserID = ? and RoutingStatus = ? and LockStatus = ?";
                pstmt = con.prepareStatement(queryStr);
                WFSUtil.DB_SetString(1, procInstID, pstmt, dbType);
                pstmt.setInt(2, wrkItemID);
                pstmt.setInt(3, userID);
                WFSUtil.DB_SetString(4, "N", pstmt, dbType);
                WFSUtil.DB_SetString(5, "Y", pstmt, dbType);
                parameters.add(procInstID);
                parameters.add(wrkItemID);
                parameters.add(userID);
                parameters.add("N");
                parameters.add("Y");
                rs = WFSUtil.jdbcExecuteQuery(procInstID, sessionID, userID, queryStr, pstmt, parameters, debug, engine);
                parameters.clear();
                //pstmt.execute();

                //rs = pstmt.getResultSet();
                if (rs != null && rs.next()) {
                    StringBuilder wmGetWorkItemInputXml = new StringBuilder();
                    wmGetWorkItemInputXml.append("<?xml version=\"1.0\"?><WMGetWorkItem_Input><Option>WMGetWorkItem</Option>");
                    wmGetWorkItemInputXml.append("<EngineName>").append(engine).append("</EngineName>");
                    wmGetWorkItemInputXml.append("<SessionId>").append(sessionID).append("</SessionId>");
                    wmGetWorkItemInputXml.append("<ProcessInstanceId>").append(procInstID).append("</ProcessInstanceId>");
                    wmGetWorkItemInputXml.append("<WorkItemId>").append(wrkItemID).append("</WorkItemId>");
                    wmGetWorkItemInputXml.append("</WMGetWorkItem_Input>");
                    parser1 = new XMLParser();
                    parser1.setInputXML(wmGetWorkItemInputXml.toString());
                    try
                    {
                        long startTime = 0L;
                        long endTime = 0L;
                        startTime = System.currentTimeMillis();
                        String wmGetWorkItemOutputXml = WFFindClass.getReference().execute("WMGetWorkItem", engine, con, parser1, gen);
                        parser1.setInputXML(wmGetWorkItemOutputXml);
                        endTime = System.currentTimeMillis();
                        WFSUtil.writeLog("WFClientServiceHandlerBean", "WMGetWorkItem", startTime, endTime, 0, wmGetWorkItemInputXml.toString(), wmGetWorkItemOutputXml);
                        wmGetWorkItemInputXml = null;
                        mainCode = Integer.parseInt(parser1.getValueOf("MainCode"));
                    }
                    catch(WFSException wfs)
                    {
                        WFSUtil.printErr(engine, "[WFSetAndCompleteWorkItem] : WFSException in WMGetworkItem");
                        WFSUtil.printErr(engine, wfs);
                        throw wfs;
                    }
                if(mainCode==0){
                    int wState = rs.getInt("WorkItemState");
                    String lockedBy = rs.getString("AssignedUser");
                    lockedBy = rs.wasNull() ? "" : lockedBy.trim();
                    int qId = rs.getInt("Q_QueueId");
                    int procDefID = rs.getInt("ProcessDefID");
                    int activityId = rs.getInt("ActivityID");
                    String actName = rs.getString("ActivityName");
                    String tempStr = rs.getString("AssignmentType");
                    int procVariantId = rs.getInt("ProcessVariantId");//Process Variant Support
                    char assgnType = rs.wasNull() ? '\0' : tempStr.charAt(0);
                    createdDateTime = rs.getString("createddatetime");
                    entryDateTime = rs.getString("entrydatetime");
                    introducedDateTime = rs.getString("introductiondatetime");
                    int referredTo = 0;
                    comments = parser.getValueOf("Comments", "", true);

                    rs.close();
                    rs = null;
                    pstmt.close();
                    pstmt = null;

                    String myQueue = TargetUser.trim() + WfsStrings.getMessage(1);
                    int target = 0;

                    if (lockedBy.equalsIgnoreCase(username) && (assgnType != 'A' || assgnType != 'R')) {
//                        pstmt = con.prepareStatement(" Select UserIndex, UserName from WFUserView where upper(rtrim(UserName)) = ? ");
                        pstmt = con.prepareStatement(" Select UserIndex, UserName from WFUserView where " + WFSUtil.TO_STRING("UserName", false, dbType) + " = " + WFSUtil.TO_STRING("?", false, dbType)); //Bugzilla Bug 1917
                        WFSUtil.DB_SetString(1, TargetUser.trim(), pstmt, dbType);
                        pstmt.execute();
                        rs = pstmt.getResultSet();
                        if (rs.next()) {
                            target = rs.getInt("UserIndex");
                            TargetUser = rs.getString("UserName");
                            rs.close();
                            rs = null;
                            pstmt.close();
                            pstmt = null;

                            /** 08/01/2008, Bugzilla Bug 1649, Method moved from OraCreateWI - Ruhi Hira */
                            int divertId = WFSUtil.getDivert(con, target, dbType,procDefID, activityId);

                            if (divertId != userID) {
                                queryStr = "SELECT 1 FROM WFInstrumentTable WHERE ProcessInstanceId = ? AND Q_UserId = ? AND ActivityID = ? and RoutingStatus = ? and LockStatus = ?";
                                pstmt = con.prepareStatement(queryStr);

                                WFSUtil.DB_SetString(1, procInstID, pstmt, dbType);
                                pstmt.setInt(2, divertId);
                                pstmt.setInt(3, activityId);
                                WFSUtil.DB_SetString(4, "R", pstmt, dbType);
                                WFSUtil.DB_SetString(5, "N", pstmt, dbType);
                                parameters.add(procInstID);
                                parameters.add(divertId);
                                parameters.add(activityId);
                                parameters.add("R");
                                parameters.add("N");
                                rs = WFSUtil.jdbcExecuteQuery(procInstID, sessionID, userID, queryStr, pstmt, parameters, debug, engine);
                                parameters.clear();
                                        
//                                pstmt.execute();
//
//                                rs = pstmt.getResultSet();
                                if (rs != null && rs.next()) {
                                    mainCode = WFSError.WM_INVALID_TARGET_USER; // A -> B -> C , if now C refers to A, it should not be allowed
                                    subCode = 0;
                                    subject = WFSErrorMsg.getMessage(mainCode);
                                    descr = WFSErrorMsg.getMessage(subCode);
                                    errType = WFSError.WF_TMP;
                                    rs.close();
                                    rs = null;
                                } else {

                                    if (rs != null) {
                                        rs.close();
                                        rs = null;
                                    }
                                    if (pstmt != null) {
                                        pstmt.close();
                                        pstmt = null;
                                    }

                                    if (divertId != target) {
                                        //get user name also
                                        pstmt = con.prepareStatement("Select Username from WFUserView where UserIndex = ?");
                                        pstmt.setInt(1, divertId);
                                        pstmt.execute();
                                        rs = pstmt.getResultSet();
                                        if (rs != null && rs.next()) {
                                            TargetUser = rs.getString("UserName").trim();
                                            myQueue = TargetUser + WfsStrings.getMessage(1);
											Q_DivertedByUserId = target;
                                            target = divertId;
                                        }
                                        if (rs != null) {
                                            rs.close();
                                            rs = null;
                                        }

                                        if (pstmt != null) {
                                            pstmt.close();
                                            pstmt = null;
                                        }
                                    }
                                }
                            } else {
                                mainCode = WFSError.WM_INVALID_TARGET_USER;
                                subCode = 0;
                                subject = WFSErrorMsg.getMessage(mainCode);
                                descr = WFSErrorMsg.getMessage(subCode);
                                errType = WFSError.WF_TMP;
                            }

                            if (mainCode == 0) {
                                if (emailnotify == 'N') {
                                    // Tirupati Srivastava : changes in queries for PostgreSql dbase
                                    pstmt = con.prepareStatement("Select NotifyByEmail from UserPreferencesTable  where UserID = ? and ObjectType = " + WFSUtil.TO_STRING("U", true, dbType));
                                    pstmt.setInt(1, target);
                                    pstmt.execute();
                                    rs = pstmt.getResultSet();
                                    if (rs.next()) {
                                        String strTmp = "";
                                        strTmp = rs.getString(1);
                                        emailnotify = rs.wasNull() ? 'N' : strTmp.charAt(0);
                                    }
                                    if (rs != null) {
                                        rs.close();
                                        rs = null;
                                    }
                                    if (pstmt != null) {
                                        pstmt.close();
                                        pstmt = null;
                                    }
                                }
                                // Begin Transaction
                                if (con.getAutoCommit()) {
                                    con.setAutoCommit(false);
                                }
                                int newid = 0;
                                queryStr = "Select Max(WorkItemId) from WFInstrumentTable " + WFSUtil.getTableLockHintStr(dbType) + " Where"
                                        + " ProcessInstanceId = ? " + WFSUtil.getQueryLockHintStr(dbType);
                                pstmt = con.prepareStatement(queryStr);
                                WFSUtil.DB_SetString(1, procInstID, pstmt, dbType);
                                /*WFSUtil.DB_SetString(2, "Y", pstmt, dbType);
                                WFSUtil.DB_SetString(3, "Y", pstmt, dbType);*/
                                parameters.add(procInstID);
                                /*parameters.add("Y");
                                parameters.add("Y");*/
                                rs = WFSUtil.jdbcExecuteQuery(procInstID, sessionID, userID, queryStr, pstmt, parameters, debug, engine);
                                parameters.clear();
//                                pstmt.execute();
//                                rs = pstmt.getResultSet();
                                if (rs.next()) {
                                    newid = rs.getInt(1);
                                    newid++;
                                }
                                if (rs != null) {
                                    rs.close();
                                    rs = null;
                                }
                                if (pstmt != null) {
                                    pstmt.close();
                                    pstmt = null;
                                }
//                                pstmt = con.prepareStatement(" Update QueueDataTable Set ReferredTo = ?, ReferredToName = ? " + " where ProcessInstanceID = ? and WorkItemId = ? ");
//                                pstmt.setInt(1, target);
//                                WFSUtil.DB_SetString(2, TargetUser, pstmt, dbType);
//                                WFSUtil.DB_SetString(3, procInstID, pstmt, dbType);
//                                pstmt.setInt(4, wrkItemID);
//                                int res1 = pstmt.executeUpdate(); //Bug # 1621
//                                pstmt.close();
//                                pstmt = null;
                                //OF Optimization
                            	//Changes for Case Management -Adding ActivityType in WFInstrumentTable
                               String targetQueueName = TargetUser + WfsStrings.getMessage(1);
                                queryStr = "Insert into WFInstrumentTable(ProcessInstanceId,WorkItemId,AssignmentType,ActivityName,ActivityId,ProcessName,"
                                        + "ProcessVersion,ProcessDefID,LastProcessedBy,ProcessedBy,EntryDateTime,CollectFlag,PriorityLevel,ValidTill,"
                                        + "Q_StreamId,Q_QueueId,Q_UserId,AssignedUser,FilterValue,CreatedDateTime,WorkItemState,StateName,ExpectedWorkitemDelay"
                                        + ",PreviousStage,LockedByName,LockStatus,LockedTime, ProcessVariantId, "
                                        + " VAR_INT1, VAR_INT2, VAR_INT3, VAR_INT4, VAR_INT5, VAR_INT6, VAR_INT7,"
+ "VAR_INT8,VAR_FLOAT1, VAR_FLOAT2, VAR_DATE1, VAR_DATE2, VAR_DATE3, VAR_DATE4,VAR_DATE5, VAR_DATE6, VAR_LONG1, VAR_LONG2, VAR_LONG3, VAR_LONG4,VAR_LONG5, VAR_LONG6, VAR_STR1, VAR_STR2, VAR_STR3, VAR_STR4, "
+ "VAR_STR5, VAR_STR6, VAR_STR7, VAR_STR8,VAR_STR9, VAR_STR10, VAR_STR11, VAR_STR12, VAR_STR13, VAR_STR14, VAR_STR15, VAR_STR16, VAR_STR17, VAR_STR18, VAR_STR19, VAR_STR20, VAR_REC_1, VAR_REC_2,VAR_REC_3, VAR_REC_4, VAR_REC_5,"
                                        + "INSTRUMENTSTATUS, CHECKLISTCOMPLETEFLAG, SAVESTAGE, HOLDSTATUS,"
                                        + " STATUS, REFERREDTO, REFERREDTONAME, REFERREDBY, REFERREDBYNAME, CHILDPROCESSINSTANCEID, CHILDWORKITEMID, PARENTWORKITEMID, "
                                        + "RoutingStatus, CreatedBy, IntroducedAt,CreatedByName,IntroducedById,Introducedby,IntroductionDateTime,NotifyStatus,ProcessInstanceState,ExpectedProcessDelay,QueueType,QueueName,ActivityType,URN , locale) "
                                        + "select ProcessInstanceId, " + newid+ "," + WFSUtil.TO_STRING("E", true, dbType) + ",ActivityName,ActivityId,"
                                        + "ProcessName,ProcessVersion,ProcessDefID,LastProcessedBy,ProcessedBy,"+WFSUtil.getDate(dbType)+",CollectFlag,"
                                        + "PriorityLevel,ValidTill,Q_StreamId,0," + target + ", " + WFSUtil.TO_STRING(TargetUser, true, dbType) + " ,"
                                        + "FilterValue, "+WFSUtil.TO_DATE(createdDateTime,true, dbType)+",WorkItemState, Statename, ExpectedWorkitemDelay, PreviousStage, NULL,"
                                        + WFSUtil.TO_STRING("N", true, dbType) + ",NULL,ProcessVariantId, "
                                     + " VAR_INT1, VAR_INT2, VAR_INT3, VAR_INT4, VAR_INT5, VAR_INT6, VAR_INT7,"
+ "VAR_INT8,VAR_FLOAT1, VAR_FLOAT2, VAR_DATE1, VAR_DATE2, VAR_DATE3, VAR_DATE4,VAR_DATE5, VAR_DATE6, VAR_LONG1, VAR_LONG2, VAR_LONG3, VAR_LONG4,VAR_LONG5, VAR_LONG6, VAR_STR1, VAR_STR2, VAR_STR3, VAR_STR4, "
+ "VAR_STR5, VAR_STR6, VAR_STR7, VAR_STR8,VAR_STR9, VAR_STR10, VAR_STR11, VAR_STR12, VAR_STR13, VAR_STR14, VAR_STR15, VAR_STR16, VAR_STR17, VAR_STR18, VAR_STR19, VAR_STR20, VAR_REC_1, VAR_REC_2,VAR_REC_3, VAR_REC_4, VAR_REC_5,"
                                        + "INSTRUMENTSTATUS, CHECKLISTCOMPLETEFLAG, SAVESTAGE, HOLDSTATUS, "
                                        + "STATUS,null,null," + userID + ", "
                                        + WFSUtil.TO_STRING(username, true, dbType) + " ,CHILDPROCESSINSTANCEID, CHILDWORKITEMID, " + wrkItemID + ","
                                        + WFSUtil.TO_STRING("N", true, dbType) + "," + userID + ", ActivityName,"+ WFSUtil.TO_STRING(username, true, dbType) + ","
                                        + userID + ","+ WFSUtil.TO_STRING(username, true, dbType) + ","+TO_SANITIZE_STRING(WFSUtil.TO_DATE(introducedDateTime,true, dbType), true)+","+(emailnotify == 'Y' ? WFSUtil.TO_STRING("Y", true, dbType) : WFSUtil.TO_STRING("N", true, dbType))+",ProcessInstanceState,ExpectedProcessDelay," +WFSUtil.TO_STRING("U", true, dbType) + ","+WFSUtil.TO_STRING(targetQueueName, true, dbType)+" , ActivityType,URN , locale from WFInstrumentTable " + WFSUtil.getTableLockHintStr(dbType)
                                        + " where ProcessInstanceID = ? and WorkItemID = ? and RoutingStatus = ? and LockStatus = ?";
                                pstmt = con.prepareStatement(queryStr);
                                
                                //pstmt = con.prepareStatement("Insert into QueueDataTable (ProcessInstanceId, WorkItemId, " + " VAR_INT1, VAR_INT2, VAR_INT3, VAR_INT4, VAR_INT5, VAR_INT6, VAR_INT7, VAR_INT8, VAR_FLOAT1, " + " VAR_FLOAT2, VAR_DATE1, VAR_DATE2, VAR_DATE3, VAR_DATE4, VAR_LONG1, VAR_LONG2, VAR_LONG3, " + " VAR_LONG4, VAR_STR1, VAR_STR2, VAR_STR3, VAR_STR4, VAR_STR5, VAR_STR6, VAR_STR7, VAR_STR8, " + " VAR_REC_1, VAR_REC_2, VAR_REC_3, VAR_REC_4, VAR_REC_5, InstrumentStatus, CheckListCompleteFlag, " + " SaveStage, HoldStatus, Status, ReferredBy, ReferredByName, " + " ChildProcessInstanceId, ChildWorkitemId, ParentWorkitemid) " + " Select ProcessInstanceId, " + newid + ", VAR_INT1, VAR_INT2, VAR_INT3, VAR_INT4, VAR_INT5, VAR_INT6, VAR_INT7, VAR_INT8, " + " VAR_FLOAT1, VAR_FLOAT2, VAR_DATE1, VAR_DATE2, VAR_DATE3, VAR_DATE4, VAR_LONG1, VAR_LONG2, " + " VAR_LONG3, VAR_LONG4, VAR_STR1, VAR_STR2, VAR_STR3, VAR_STR4, VAR_STR5, VAR_STR6, VAR_STR7, " + " VAR_STR8, VAR_REC_1, VAR_REC_2, VAR_REC_3, VAR_REC_4, VAR_REC_5, InstrumentStatus, " + " CheckListCompleteFlag, SaveStage, HoldStatus, Status, " + userID + ", " + WFSUtil.TO_STRING(username, true, dbType) + " ," + " ChildProcessInstanceId, ChildWorkitemId, " + wrkItemID + " from " + " QueueDataTable where ProcessInstanceID = ? and WorkItemID = ?");
                                /**
                                 * Bugzilla Id 61, 11/08/2006, PreparedStatement issue in DB2 - Ruhi Hira
                                 */
                                WFSUtil.DB_SetString(1, procInstID, pstmt, dbType);
                                pstmt.setInt(2, wrkItemID);
                                WFSUtil.DB_SetString(3, "N", pstmt, dbType);
                                WFSUtil.DB_SetString(4, "Y", pstmt, dbType);
                                parameters.add(procInstID);
                                parameters.add(wrkItemID);
                                parameters.add("N");
                                parameters.add("Y");
                                int res1 = WFSUtil.jdbcExecuteUpdate(procInstID, sessionID, userID, queryStr, pstmt, parameters, debug, engine);
                                parameters.clear();
                                //int res2 = pstmt.executeUpdate(); //Bug # 1621
                                pstmt.close();
                                pstmt = null;
//                                StringBuffer insertQuery = new StringBuffer(1000);
//                                // Tirupati Srivastava : changes in queries for PostgreSql dbase
//								// Process Variant Support
//                                insertQuery.append("INSERT INTO Worklisttable (ProcessInstanceId, WorkItemId, " + " ProcessName, ProcessVersion, ProcessDefID,ProcessVariantId, LastProcessedBy, ProcessedBy, ActivityName, " + " ActivityId, EntryDateTime, ParentWorkItemId, AssignmentType, CollectFlag, PriorityLevel, " + " ValidTill, Q_StreamId, Q_QueueId, Q_UserId, AssignedUser, FilterValue, CreatedDateTime, " + " WorkItemState, Statename, ExpectedWorkitemDelay, PreviousStage, LockStatus, " + " Queuename, Queuetype, NotifyStatus )" + " Select ProcessInstanceId, " + newid + ", " + " ProcessName, ProcessVersion, ProcessDefID,ProcessVariantId, LastProcessedBy, ProcessedBy, ActivityName, " + " ActivityId, EntryDateTime, " + wrkItemID + ", " + WFSUtil.TO_STRING("E", true, dbType) + ", CollectFlag, PriorityLevel, " + " ValidTill, Q_StreamId, 0, " + target + ", " + WFSUtil.TO_STRING(TargetUser, true, dbType) + " , FilterValue, CreatedDateTime, " + " WorkItemState, Statename, ExpectedWorkitemDelay, PreviousStage, " + WFSUtil.TO_STRING("N", true, dbType) + "," + WFSUtil.TO_STRING(myQueue, true, dbType) + ", " + WFSUtil.TO_STRING("U", true, dbType) + "," + (emailnotify == 'Y' ? WFSUtil.TO_STRING("Y", true, dbType) : WFSUtil.TO_STRING("N", true, dbType)) + " from WorkInProcessTable where ProcessInstanceID = ? and WorkItemID = ? ");
//                                /**
//                                 * Bugzilla Id 61, 11/08/2006, PreparedStatement issue in DB2 - Ruhi Hira
//                                 */
//                                pstmt = con.prepareStatement(insertQuery.toString());
//                                WFSUtil.DB_SetString(1, procInstID, pstmt, dbType);
//                                pstmt.setInt(2, wrkItemID);
//                                int res3 = pstmt.executeUpdate(); //Bug # 1621
//                                pstmt.close();
//                                pstmt = null;
                                // Tirupati Srivastava : changes in queries for PostgreSql dbase
								// Process Variant Support
                                queryStr = "Update WFInstrumentTable Set ReferredTo = ?, ReferredToName = ?, Q_UserId=?,AssignedUser=?,WorkItemState=?,"
                                        + "StateName=?,LockedByName=?,LockStatus=?,LockedTime="+WFSUtil.getDate(dbType)+", RoutingStatus = ? , Q_DivertedByUserId = " + Q_DivertedByUserId + ",AssignmentType = ? where ProcessInstanceID = ? "
                                        + "and WorkItemId = ? and RoutingStatus = ? and LockStatus = ?";
                                pstmt = con.prepareStatement(queryStr);
//                                pstmt = con.prepareStatement(" " + " Insert into PendingWorklisttable (ProcessInstanceId,WorkItemId,ProcessName,ProcessVersion,ProcessDefID,ProcessVariantId," + " LastProcessedBy,ProcessedBy,ActivityName,ActivityId,EntryDateTime,ParentWorkItemId," + " AssignmentType,CollectFlag,PriorityLevel,ValidTill,Q_StreamId,Q_QueueId,Q_UserId," + " AssignedUser,FilterValue,CreatedDateTime,WorkItemState,StateName,ExpectedWorkitemDelay,PreviousStage," + " LockedByName,LockStatus,LockedTime,QueueName,QueueType)" + " Select ProcessInstanceId,WorkItemId,ProcessName,ProcessVersion,ProcessDefID,ProcessVariantId,LastProcessedBy," + " ProcessedBy,ActivityName,ActivityId,EntryDateTime,ParentWorkItemId," + " AssignmentType,CollectFlag,PriorityLevel,ValidTill,Q_StreamId,Q_QueueId, " + userID + "," //Bugzilla Bug 637 (Assignment type not changed as while refering original AssignmentType is there in pendingWorklisttable
//                                        + WFSUtil.TO_STRING(username, true, dbType) + ", FilterValue,CreatedDateTime,3," + WFSUtil.TO_STRING(WFSConstant.WF_SUSPENDED, true, dbType) + ", ExpectedWorkitemDelay,PreviousStage," + WFSUtil.TO_STRING(username, true, dbType) + "," + WFSUtil.TO_STRING("Y", true, dbType) + "," + WFSUtil.isnull(dbType) + "(LockedTime," + WFSUtil.getDate(dbType) + "),QueueName,QueueType" + " from  WorkInProcessTable where ProcessInstanceID = ? and WorkItemID = ?");
                                /**
                                 * Bugzilla Id 61, 11/08/2006, PreparedStatement issue in DB2 - Ruhi Hira
                                 */
                                pstmt.setInt(1, target);
                                WFSUtil.DB_SetString(2, TargetUser, pstmt, dbType);
                                pstmt.setInt(3, userID);
                                WFSUtil.DB_SetString(4, username, pstmt, dbType);
                                pstmt.setInt(5, 3);
                                WFSUtil.DB_SetString(6, WFSConstant.WF_SUSPENDED, pstmt, dbType);
                                WFSUtil.DB_SetString(7, username, pstmt, dbType);
                                WFSUtil.DB_SetString(8, "Y", pstmt, dbType);/*In Refer-- WI is locked by the person who has referred to someone */
                                WFSUtil.DB_SetString(9, "R", pstmt, dbType);
                                WFSUtil.DB_SetString(10, "Z", pstmt, dbType);//Parnet copy of refered worktiem's assignment type changed to Z
                                WFSUtil.DB_SetString(11, procInstID, pstmt, dbType);
                                pstmt.setInt(12, wrkItemID);
                                WFSUtil.DB_SetString(13, "N", pstmt, dbType);
                                WFSUtil.DB_SetString(14, "Y", pstmt, dbType);
                                parameters.add(target);
                                parameters.add(TargetUser);
                                parameters.add(userID);
                                parameters.add(username);
                                parameters.add(3);
                                parameters.add(WFSConstant.WF_SUSPENDED);
                                parameters.add(username);
                                parameters.add("N");
                                parameters.add("R");
                                parameters.add(procInstID);
                                parameters.add(wrkItemID);
                                parameters.add("N");
                                parameters.add("Y");
                                int res2 = WFSUtil.jdbcExecuteUpdate(procInstID, sessionID, userID, queryStr, pstmt, parameters, debug, engine);
//                                //int res4 = pstmt.executeUpdate();
//                                pstmt = con.prepareStatement("Delete from WorkInProcessTable where ProcessInstanceID = ? and WorkItemID = ? ");
//                                WFSUtil.DB_SetString(1, procInstID, pstmt, dbType);
//                                pstmt.setInt(2, wrkItemID);
//                                int f1 = pstmt.executeUpdate();
//                                pstmt.close();
//                                pstmt = null;
                                //Bug # 1621
                                //if (res1 > 0 && res2 > 0 && res3 > 0 && res4 > 0 && f1 > 0) {
                                if (res1 > 0 && res2 > 0) {
                                    if (!comments.equals("")) {
										// Process Variant Support
                                        pstmt = con.prepareStatement("Insert Into WFCommentsTable (ProcessDefId, ActivityId, ProcessInstanceId, WorkItemId, CommentsBy, CommentsByName, CommentsTo, CommentsToName, Comments, ActionDateTime, CommentsType,ProcessVariantId) Values (?, ?, ?, ?, ?, ?, ?, ?, ?, " + WFSUtil.getDate(dbType) + ", ?,?)");
                                        pstmt.setInt(1, procDefID);
                                        pstmt.setInt(2, activityId);
                                        WFSUtil.DB_SetString(3, procInstID, pstmt, dbType);
                                        pstmt.setInt(4, newid);
                                        pstmt.setInt(5, userID);
                                        WFSUtil.DB_SetString(6, username, pstmt, dbType);
                                        pstmt.setInt(7, target);
                                        WFSUtil.DB_SetString(8, TargetUser, pstmt, dbType);
                                        WFSUtil.DB_SetString(9, comments, pstmt, dbType);
                                        pstmt.setInt(10, WFSConstant.CONST_COMMENTS_REFER);
                                        pstmt.setInt(11,procVariantId);
                                        pstmt.executeUpdate();
                                        pstmt.close();
                                        pstmt = null;
                                    }

                                    if (!con.getAutoCommit()) {
                                        con.commit();
                                        con.setAutoCommit(true);
                                    }
                                    WFSUtil.generateLog(engine, con, WFSConstant.WFL_WorkItemReferred, procInstID, wrkItemID,
                                            procDefID, activityId, actName, 0, userID, username, target, TargetUser, null, null, null, null);
                                } else {
                                    mainCode = WFSError.WM_INVALID_WORKITEM;
                                    subCode = WFSError.WFS_NOQ;
                                    subject = WFSErrorMsg.getMessage(mainCode);
                                    descr = WFSErrorMsg.getMessage(subCode);
                                    if (!con.getAutoCommit()) {
                                        con.rollback();
                                        con.setAutoCommit(true);
                                    }
                                }
                            }
                        } else {
                            if (rs != null) {
                                rs.close();
                                rs = null;
                            }
                            if (pstmt != null) {
                                pstmt.close();
                                pstmt = null;
                            }
                            mainCode = WFSError.WM_INVALID_TARGET_USER;
                            subCode = 0;
                            subject = WFSErrorMsg.getMessage(mainCode);
                            descr = WFSErrorMsg.getMessage(subCode);
                            errType = WFSError.WF_TMP;
                        }
                    } else {
                        mainCode = WFSError.WM_INVALID_WORKITEM;
                        subCode = WFSError.WM_NOT_LOCKED;
                        subject = WFSErrorMsg.getMessage(mainCode);
                        descr = WFSErrorMsg.getMessage(subCode);
                        errType = WFSError.WF_TMP;
                    }
                 }
                } else {
                    if (rs != null) {
                        rs.close();
                        rs = null;
                    }
                    if (pstmt != null) {
                        pstmt.close();
                        pstmt = null;
                    }
                    mainCode = WFSError.WM_INVALID_WORKITEM;
                    subCode = 0;
                    subject = WFSErrorMsg.getMessage(mainCode);
                    descr = WFSErrorMsg.getMessage(subCode);
                    errType = WFSError.WF_TMP;
                }
            } else {
                mainCode = WFSError.WM_INVALID_SESSION_HANDLE;
                subCode = 0;
                subject = WFSErrorMsg.getMessage(mainCode);
                descr = WFSErrorMsg.getMessage(subCode);
                errType = WFSError.WF_TMP;
            }
            if (mainCode == 0) {
                outputXML = new StringBuffer(500);
                outputXML.append(gen.createOutputFile("WFReferWorkItem"));
                outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
                outputXML.append(gen.closeOutputFile("WFReferWorkItem"));
            }
        } catch (SQLException e) {
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WM_INVALID_FILTER;
            subCode = WFSError.WFS_SQL;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_FAT;
            if (e.getErrorCode() == 0) {
                if (e.getSQLState().equalsIgnoreCase("08S01")) {
                    descr = (new JTSSQLError(e.getSQLState())).getMessage() + "(SQL State : " + e.getSQLState() + ")";
                }
            } else {
                descr = e.getMessage();
            }
        } catch (NumberFormatException e) {
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_ILP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch (NullPointerException e) {
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_SYS;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch (JTSException e) {
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = e.getErrorCode();
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.getMessage();
        } catch (Exception e) {
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_EXP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch (Error e) {
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_EXP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } finally {
            try {
                if (!con.getAutoCommit()) {
                    con.rollback();
                    con.setAutoCommit(true);
                }
                if (rs != null) {
                    rs.close();
                    rs = null;
                }
                if (pstmt != null) {
                    pstmt.close();
                    pstmt = null;
                }
            } catch (Exception e) {
            }
           
        }
        if (mainCode != 0) {
            String strReturn = WFSUtil.generalError(option, engine, gen,mainCode, subCode,errType, subject,descr);
			return strReturn;	
            //throw new WFSException(mainCode, subCode, errType, subject, descr);
        }
        return outputXML.toString();
    }

//----------------------------------------------------------------------------------------------------
//	Function Name 			:	WFWithdrawWorkitem
//	Date Written (DD/MM/YYYY)	:	05/03/2003
//	Author							:	Prashant
//	Input Parameters		:	Connection , XMLParser , XMLGenerator
//	Output Parameters		: none
//	Return Values				:	String
//	Description					: Withdraw Referred WorkItem from the User
//----------------------------------------------------------------------------------------------------
    public String WFWithdrawWorkitem(Connection con, XMLParser parser,
            XMLGenerator gen) throws JTSException, WFSException {
    	StringBuffer outputXML = new StringBuffer("");
        PreparedStatement pstmt = null;
        int mainCode = 0;
        int subCode = 0;
        String subject = null;
        String descr = null;
        String errType = WFSError.WF_TMP;
        String engine =null;
        try {
            int sessionID = parser.getIntOf("SessionId", 0, false);
            String procInstID = parser.getValueOf("ProcessInstanceId", "", false);
            int wrkItemID = parser.getIntOf("WorkItemId", 0, false);
            engine = parser.getValueOf("EngineName");
            int dbType = ServerProperty.getReference().getDBType(engine);

            WFParticipant participant = WFSUtil.WFCheckSession(con, sessionID);
            if (participant != null && participant.gettype() == 'U') {
                WFWithDraw(participant, con, procInstID, wrkItemID, engine);
            } else {
                mainCode = WFSError.WM_INVALID_SESSION_HANDLE;
                subCode = 0;
                subject = WFSErrorMsg.getMessage(mainCode);
                descr = WFSErrorMsg.getMessage(subCode);
                errType = WFSError.WF_TMP;
            }
            if (mainCode == 0) {
                outputXML = new StringBuffer(500);
                outputXML.append(gen.createOutputFile("WFWithdrawWorkitem"));
                outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
                outputXML.append(gen.closeOutputFile("WFWithdrawWorkitem"));
            }
        } catch (SQLException e) {
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WM_INVALID_FILTER;
            subCode = WFSError.WFS_SQL;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_FAT;
            if (e.getErrorCode() == 0) {
                if (e.getSQLState().equalsIgnoreCase("08S01")) {
                    descr = (new JTSSQLError(e.getSQLState())).getMessage() + "(SQL State : " + e.getSQLState() + ")";
                }
            } else {
                descr = e.getMessage();
            }
        } catch (NumberFormatException e) {
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_ILP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch (NullPointerException e) {
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_SYS;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch (WFSException e) {
            WFSUtil.printErr(engine,"", e);
            mainCode = e.getMainErrorCode();
            subCode = e.getSubErrorCode();
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = WFSErrorMsg.getMessage(subCode);
        } catch (JTSException e) {
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = e.getErrorCode();
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.getMessage();
        } catch (Exception e) {
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_EXP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch (Error e) {
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_EXP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } finally {
            try {
                if (!con.getAutoCommit()) {
                    con.rollback();
                    con.setAutoCommit(true);
                }
            } catch (Exception ignored) {
            }
            try {
                if (pstmt != null) {
                    pstmt.close();
                    pstmt = null;
                }
            } catch (Exception e) {
            }
           
        }
        if (mainCode != 0) {
            throw new WFSException(mainCode, subCode, errType, subject, descr);
        }
        return outputXML.toString();
    }

//----------------------------------------------------------------------------------------------------
//	Function Name 			:	WFWithdrawWorkitem
//	Date Written (DD/MM/YYYY)	:	05/03/2003
//	Author							:	Prashant
//	Input Parameters		:	String engine , Connection con , String procInstID , int wrkItemID , int userIndex , String username
//	Output Parameters		: none
//	Return Values				:	int
//	Description					: Withdraw Referred WorkItem from the User
//----------------------------------------------------------------------------------------------------
    static int withdrawWI(String engine, Connection con, String procInstID, int wrkItemID,
            int userIndex, String username, int sessionId , boolean debug) throws SQLException, WFSException {
        PreparedStatement pstmt = null;
        //Bug # 1621
        int mainCode = 0;
        int subCode = 0;
        String subject = null;
        String descr = null;
        String errType = WFSError.WF_TMP;
        ArrayList parameter = new ArrayList();
        String qStr = "";
        
        try {
            int dbType = ServerProperty.getReference().getDBType(engine);

            /*pstmt = con.prepareStatement(
                    "Select PendingWorklisttable.WorkItemId,ReferredTo," +
                    "ProcessDefId,ActivityID,ActivityName,Q_UserID,ReferredToName from PendingWorklisttable," +
                    "QueueDataTable where PendingWorklisttable.ProcessInstanceID=QueueDataTable.ProcessInstanceID " + "and PendingWorklisttable.WorkItemId=QueueDataTable.WorkItemId " + "and PendingWorklisttable.ProcessInstanceID=? and QueueDataTable.ParentWorkItemID=? and ReferredBy=?");*/
            qStr =  "Select WorkItemId,ReferredTo,ProcessDefId,ActivityID,ActivityName,Q_UserID,ReferredToName from WFINSTRUMENTTABLE " + WFSUtil.getTableLockHintStr(dbType) + "  where  ProcessInstanceID = ? and ParentWorkItemID = ? and ReferredBy = ? and RoutingStatus = 'R'";
            pstmt = con.prepareStatement(qStr);
            WFSUtil.DB_SetString(1, procInstID, pstmt, dbType);
            pstmt.setInt(2, wrkItemID);
            pstmt.setInt(3, userIndex);
            parameter.addAll(Arrays.asList(procInstID,wrkItemID,userIndex));            
            ResultSet rs = WFSUtil.jdbcExecuteQuery(procInstID, sessionId, userIndex, qStr, pstmt, parameter, debug, engine);
            /*if(con.getAutoCommit())
            con.setAutoCommit(false);*/
            //Bug # 1621

            if (rs.next()) {
                int wId = rs.getInt(1);
                int target = rs.getInt(2);
                int procDefID = rs.getInt(3);
                int activityId = rs.getInt(4);
                String actName = rs.getString(5);
                int referBy = rs.getInt(6);
                String TargetUser = rs.getString(7);
                rs.close();
                pstmt.close();

                //withdrawWI(engine, con, procInstID, wId, referBy, TargetUser);
                withdrawWI(engine, con, procInstID, wId, referBy, TargetUser, sessionId, debug);

                /*pstmt = con.prepareStatement(
                        "Delete from PendingWorklisttable where ProcessInstanceID=? and WorkItemId=?");
                WFSUtil.DB_SetString(1, procInstID, pstmt, dbType);
                pstmt.setInt(2, wId);
                int res1 = pstmt.executeUpdate(); //Bug # 1621
                pstmt.close();

                pstmt = con.prepareStatement(
                        "Delete from QueueDatatable where ProcessInstanceID=? and WorkItemId=?");
                WFSUtil.DB_SetString(1, procInstID, pstmt, dbType);
                pstmt.setInt(2, wId);*/
                
                qStr = "Delete from WFINSTRUMENTTABLE where ProcessInstanceID = ? and WorkItemId = ?";
                pstmt = con.prepareStatement(qStr);
                WFSUtil.DB_SetString(1, procInstID, pstmt, dbType);
                pstmt.setInt(2, wId);
                parameter.clear();
                parameter.addAll(Arrays.asList(procInstID,wId));
                
                int res = WFSUtil.jdbcExecuteUpdate(procInstID, sessionId, userIndex, qStr, pstmt, parameter, debug, engine);
                pstmt.close();
                //if (res1 > 0 && res2 > 0) { //Bug # 1621
                if (res > 0) {
                    //	    WFSUtil.genLog(engine, con, procDefID, procInstID, activityId, actName,
                    //		WFSConstant.WFL_WorkItemWithDrawn, referBy, userIndex, username, wrkItemID,
                    //		TargetUser);
                    WFSUtil.generateLog(engine, con, WFSConstant.WFL_WorkItemWithDrawn, procInstID, wrkItemID,
                            procDefID, activityId, actName, 0, userIndex, username, userIndex, username, null, null, null, null);
                } else {
                    mainCode = WFSError.WM_INVALID_WORKITEM;
                    subCode = WFSError.WFS_NOQ;
                    subject = WFSErrorMsg.getMessage(mainCode);
                    descr = WFSErrorMsg.getMessage(subCode);
                }
            } else {
                /*if (rs != null) {
                    rs.close();
                }
                pstmt.close();

                pstmt = con.prepareStatement("Select Worklisttable.WorkItemId,ReferredTo," +
                        "ProcessDefId,ActivityID,ActivityName,Q_UserID,ReferredToName from Worklisttable," +
                        "QueueDataTable where Worklisttable.ProcessInstanceID=QueueDataTable.ProcessInstanceID " + "and Worklisttable.WorkItemId=QueueDataTable.WorkItemId " +
                        "and Worklisttable.ProcessInstanceID=? and QueueDataTable.ParentWorkItemID=? and ReferredBy=?");
                WFSUtil.DB_SetString(1, procInstID, pstmt, dbType);
                pstmt.setInt(2, wrkItemID);
                pstmt.setInt(3, userIndex);
                pstmt.execute();
                rs = pstmt.getResultSet();
                if (rs.next()) {
                    int wId = rs.getInt(1);
                    int target = rs.getInt(2);
                    int procDefID = rs.getInt(3);
                    int activityId = rs.getInt(4);
                    String actName = rs.getString(5);
                    int referBy = rs.getInt(6);
                    String TargetUser = rs.getString(7);
                    rs.close();
                    pstmt.close();

                    //		WFSUtil.genLog(engine, con, procDefID, procInstID, activityId, actName,
                    //		    WFSConstant.WFL_WorkItemWithDrawn, referBy, userIndex, username, wrkItemID,
                    //		    TargetUser);

                    WFSUtil.generateLog(engine, con, WFSConstant.WFL_WorkItemWithDrawn, procInstID, wrkItemID,
                            procDefID, activityId, actName, 0, userIndex, username, userIndex, username, null, null, null, null);


                    pstmt = con.prepareStatement(
                            "Delete from Worklisttable where ProcessInstanceID=? and WorkItemId=?");
                    WFSUtil.DB_SetString(1, procInstID, pstmt, dbType);
                    pstmt.setInt(2, wId);
                    int res = pstmt.executeUpdate();
                    pstmt.close();
                    pstmt = con.prepareStatement(
                            "Delete from QueueDataTable where ProcessInstanceID=? and WorkItemId=?");
                    WFSUtil.DB_SetString(1, procInstID, pstmt, dbType);
                    pstmt.setInt(2, wId);
                    res = pstmt.executeUpdate();
                    pstmt.close();

                } else {
                    if (rs != null) {
                        rs.close();
                    }
                    pstmt.close();

                    pstmt = con.prepareStatement("Select WorkDonetable.WorkItemId,ReferredTo," +
                            "ProcessDefId,ActivityID,ActivityName,Q_UserID,ReferredToName from WorkDonetable," +
                            "QueueDataTable where WorkDonetable.ProcessInstanceID=QueueDataTable.ProcessInstanceID " + "and WorkDonetable.WorkItemId=QueueDataTable.WorkItemId " +
                            "and WorkDonetable.ProcessInstanceID=? and QueueDataTable.ParentWorkItemID=? and ReferredBy=?");
                    WFSUtil.DB_SetString(1, procInstID, pstmt, dbType);
                    pstmt.setInt(2, wrkItemID);
                    pstmt.setInt(3, userIndex);
                    pstmt.execute();
                    rs = pstmt.getResultSet();

                    if (rs.next()) {
                        int wId = rs.getInt(1);
                        int target = rs.getInt(2);
                        int procDefID = rs.getInt(3);
                        int activityId = rs.getInt(4);
                        String actName = rs.getString(5);
                        int referBy = rs.getInt(6);
                        String TargetUser = rs.getString(7);
                        rs.close();
                        pstmt.close();
                        pstmt = con.prepareStatement(
                                "Delete from WorkDonetable where ProcessInstanceID=? and WorkItemId=?");
                        WFSUtil.DB_SetString(1, procInstID, pstmt, dbType);
                        pstmt.setInt(2, wId);
                        int res1 = pstmt.executeUpdate();
                        pstmt.close();
                        pstmt = con.prepareStatement(
                                "Delete from QueueDataTable where ProcessInstanceID=? and WorkItemId=?");
                        WFSUtil.DB_SetString(1, procInstID, pstmt, dbType);
                        pstmt.setInt(2, wId);
                        int res2 = pstmt.executeUpdate();
                        pstmt.close();
                        if (res1 > 0 && res2 > 0) {
                            //		    WFSUtil.genLog(engine, con, procDefID, procInstID, activityId, actName,
                            //			WFSConstant.WFL_WorkItemWithDrawn, referBy, userIndex, username, wrkItemID,
                            //			TargetUser);
                            WFSUtil.generateLog(engine, con, WFSConstant.WFL_WorkItemWithDrawn, procInstID, wrkItemID,
                                    procDefID, activityId, actName, 0, userIndex, username, userIndex, username, null, null, null, null);


                        } else {
                            mainCode = WFSError.WM_INVALID_WORKITEM;
                            subCode = WFSError.WFS_NOQ;
                            subject = WFSErrorMsg.getMessage(mainCode);
                            descr = WFSErrorMsg.getMessage(subCode);
                        }
                    } else {
                        if (rs != null) {
                            rs.close();
                        }
                        pstmt.close();

                        pstmt = con.prepareStatement("Select Worklisttable.WorkItemId,ReferredTo," +
                                "ProcessDefId,ActivityID,ActivityName,Q_UserID,ReferredToName from Worklisttable," +
                                "QueueDataTable where Worklisttable.ProcessInstanceID=QueueDataTable.ProcessInstanceID " + "and Worklisttable.WorkItemId=QueueDataTable.WorkItemId " +
                                "and Worklisttable.ProcessInstanceID=? and QueueDataTable.ParentWorkItemID=? and ReferredBy=?");
                        WFSUtil.DB_SetString(1, procInstID, pstmt, dbType);
                        pstmt.setInt(2, wrkItemID);
                        pstmt.setInt(3, userIndex);
                        pstmt.execute();
                        rs = pstmt.getResultSet();
                        if (rs.next()) {
                            int wId = rs.getInt(1);
                            int target = rs.getInt(2);
                            int procDefID = rs.getInt(3);
                            int activityId = rs.getInt(4);
                            String actName = rs.getString(5);
                            int referBy = rs.getInt(6);
                            String TargetUser = rs.getString(7);
                            rs.close();
                            pstmt.close();

                            pstmt = con.prepareStatement(
                                    "Delete from Worklisttable where ProcessInstanceID=? and WorkItemId=?");
                            WFSUtil.DB_SetString(1, procInstID, pstmt, dbType);
                            pstmt.setInt(2, wId);
                            int res1 = pstmt.executeUpdate();
                            pstmt.close();
                            pstmt = con.prepareStatement(
                                    "Delete from QueueDataTable where ProcessInstanceID=? and WorkItemId=?");
                            WFSUtil.DB_SetString(1, procInstID, pstmt, dbType);
                            pstmt.setInt(2, wId);
                            int res2 = pstmt.executeUpdate();
                            pstmt.close();
                            if (res1 > 0 && res2 > 0) {
                                //			WFSUtil.genLog(engine, con, procDefID, procInstID, activityId, actName,
                                //			    WFSConstant.WFL_WorkItemWithDrawn, referBy, userIndex, username,
                                //			    wrkItemID, TargetUser);

                                WFSUtil.generateLog(engine, con, WFSConstant.WFL_WorkItemWithDrawn, procInstID, wrkItemID,
                                        procDefID, activityId, actName, 0, userIndex, username, userIndex, username, null, null, null, null);

                            } else {
                                mainCode = WFSError.WM_INVALID_WORKITEM;
                                subCode = WFSError.WFS_NOQ;
                                subject = WFSErrorMsg.getMessage(mainCode);
                                descr = WFSErrorMsg.getMessage(subCode);
                            }

                        } else {
                            if (rs != null) {
                                rs.close();
                            }
                            pstmt.close();

                            pstmt = con.prepareStatement(
                                    "Select WorkinProcesstable.WorkItemId,ReferredTo," +
                                    "ProcessDefId,ActivityID,ActivityName,Q_UserID,ReferredToName from WorkinProcesstable," +
                                    "QueueDataTable where WorkinProcesstable.ProcessInstanceID=QueueDataTable.ProcessInstanceID " + "and WorkinProcesstable.WorkItemId=QueueDataTable.WorkItemId " +
                                    "and WorkinProcesstable.ProcessInstanceID=? and QueueDataTable.ParentWorkItemID=? and ReferredBy=?");
                            WFSUtil.DB_SetString(1, procInstID, pstmt, dbType);
                            pstmt.setInt(2, wrkItemID);
                            pstmt.setInt(3, userIndex);
                            pstmt.execute();
                            rs = pstmt.getResultSet();

                            if (rs.next()) {
                                int wId = rs.getInt(1);
                                int target = rs.getInt(2);
                                int procDefID = rs.getInt(3);
                                int activityId = rs.getInt(4);
                                String actName = rs.getString(5);
                                int referBy = rs.getInt(6);
                                String TargetUser = rs.getString(7);
                                rs.close();
                                pstmt.close();
                                pstmt = con.prepareStatement(
                                        "Delete from WorkinProcesstable where ProcessInstanceID=? and WorkItemId=?");
                                WFSUtil.DB_SetString(1, procInstID, pstmt, dbType);
                                pstmt.setInt(2, wId);
                                int res1 = pstmt.executeUpdate();
                                pstmt.close();
                                pstmt = con.prepareStatement(
                                        "Delete from QueueDataTable where ProcessInstanceID=? and WorkItemId=?");
                                WFSUtil.DB_SetString(1, procInstID, pstmt, dbType);
                                pstmt.setInt(2, wId);
                                int res2 = pstmt.executeUpdate();
                                pstmt.close();
                                if (res1 > 0 && res2 > 0) {

                                    //			    WFSUtil.genLog(engine, con, procDefID, procInstID, activityId, actName,
                                    //				WFSConstant.WFL_WorkItemWithDrawn, referBy, userIndex, username,
                                    //				wrkItemID, TargetUser);
                                    WFSUtil.generateLog(engine, con, WFSConstant.WFL_WorkItemWithDrawn, procInstID, wrkItemID,
                                            procDefID, activityId, actName, 0, userIndex, username, userIndex, username, null, null, null, null);

                                } else {
                                    mainCode = WFSError.WM_INVALID_WORKITEM;
                                    subCode = WFSError.WFS_NOQ;
                                    subject = WFSErrorMsg.getMessage(mainCode);
                                    descr = WFSErrorMsg.getMessage(subCode);
                                }
                            } else {
                                if (rs != null) {
                                    rs.close();
                                }
                                pstmt.close();
                            }
                        }
                    }
                }*/
            	
        	if (rs != null) {
                rs.close();
            }
            pstmt.close();
            qStr = "Select WorkItemId,ReferredTo,ProcessDefId,ActivityID,ActivityName,Q_UserID,ReferredToName from WFINSTRUMENTTABLE where ProcessInstanceID = ? and ParentWorkItemID = ? and ReferredBy = ? and RoutingStatus <> 'R' and not (RoutingStatus = 'Y' and LockStatus = 'Y')";
            pstmt = con.prepareStatement(qStr);
            WFSUtil.DB_SetString(1, procInstID, pstmt, dbType);
            pstmt.setInt(2, wrkItemID);
            pstmt.setInt(3, userIndex);
            parameter.clear();
            parameter.addAll(Arrays.asList(procInstID,wrkItemID,userIndex));
            rs = WFSUtil.jdbcExecuteQuery(procInstID, sessionId, userIndex, qStr, pstmt, parameter, debug, engine);

            if (rs.next()) {
                int wId = rs.getInt(1);
                int target = rs.getInt(2);
                int procDefID = rs.getInt(3);
                int activityId = rs.getInt(4);
                String actName = rs.getString(5);
                int referBy = rs.getInt(6);
                String TargetUser = rs.getString(7);
                rs.close();
                pstmt.close();      
                qStr = "Delete from WFINSTRUMENTTABLE where ProcessInstanceID = ? and WorkItemId = ?";
                pstmt = con.prepareStatement(qStr);
                WFSUtil.DB_SetString(1, procInstID, pstmt, dbType);
                pstmt.setInt(2, wId);
                parameter.clear();
                parameter.addAll(Arrays.asList(procInstID,wId));
                int res = WFSUtil.jdbcExecuteUpdate(procInstID, sessionId, userIndex, qStr, pstmt, parameter, debug, engine);
                pstmt.close();
                if (res > 0) {
                	
                    WFSUtil.generateLog(engine, con, WFSConstant.WFL_WorkItemWithDrawn, procInstID, wrkItemID,
                            procDefID, activityId, actName, 0, userIndex, username, userIndex, username, null, null, null, null);


                } else {
                    mainCode = WFSError.WM_INVALID_WORKITEM;
                    subCode = WFSError.WFS_NOQ;
                    subject = WFSErrorMsg.getMessage(mainCode);
                    descr = WFSErrorMsg.getMessage(subCode);
                }
            	
            }
          }

        /* if(!con.getAutoCommit()){
        con.commit();
        con.setAutoCommit(true);
        }*/
        } catch (Exception e) {
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_EXP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } finally { //Bug WFS_6_004 - Statement closed in finally.
            try {
                if (pstmt != null) {
                    pstmt.close();
                    pstmt = null;
                }
            } catch (Exception ignored) {
            }
        }
        if (mainCode != 0) {
            throw new WFSException(mainCode, subCode, errType, subject, descr);
        }
        return 0;
    }

//=====================================

static int withdrawWI(String engine, Connection con, String procInstID, int wrkItemID,
        int userIndex, String username) throws SQLException, WFSException {
	
	return withdrawWI(engine, con, procInstID, wrkItemID,userIndex, username, 0, false);
		}


//  public BigInteger generateRandomPattern(int percent) {
//    BigInteger b = BigInteger.ZERO;
//    java.util.Random randomizer = new java.util.Random(System.currentTimeMillis());
//    while (b.bitCount()!=percent){
//      b = b.setBit(randomizer.nextInt(100));
//    }
//    return b;
//  }

    /*	************************************************************************************	*/
    /*		Change By	: Dinesh Parikh															*/
    /*		Reason		: When workitem is withdraw then workitem should be removed from		*/
    /*					  user's Myqueue														*/
    /*		Date		: 21/06/2004															*/
    /*	************************************************************************************	*/
//----------------------------------------------------------------------------
// Changed By						: Ashish Mangla
// Reason / Cause (Bug No if Any)	: WSE_5.0.1_beta_231
// Change Description				: Reassign a wi from A to B.The wi will come in Myqueue of user B. Now,user B refers that WI to C,and then revokes it back.Error:-The Wi should come in Myqueue of B,whereas it is not coming.
//----------------------------------------------------------------------------
    public static void WFWithDraw(WFParticipant participant, Connection con, String procInstID,
            int wrkItemID, String engine, int sessionId , boolean debug) throws SQLException, JTSException {
        int dbType = ServerProperty.getReference().getDBType(engine);
        StringBuffer outputXML = null;
        PreparedStatement pstmt = null;
        int mainCode = 0;
        int subCode = 0;
        String subject = null;
        String descr = null;
        String errType = WFSError.WF_TMP;
        boolean transactionOpened = false; // WFS_5_215
        ArrayList parameter = new ArrayList(); 
        String qStr = "";
        try {
            int userID = participant.getid();
            String username = participant.getname();
			qStr = "SELECT WorkItemState, AssignedUser, Q_QueueId, AssignmentType, Q_UserID" + ", ReferredTo, ReferredToName, ReferredBy, ReferredByName " + " FROM WFINSTRUMENTTABLE " + WFSUtil.getLockPrefixStr(dbType) + " WHERE ProcessInstanceID = ? AND WorkItemID = ? AND RoutingStatus = 'R'";
            //pstmt = con.prepareStatement("SELECT WorkItemState, AssignedUser, Q_QueueId, AssignmentType, Q_UserID" + ", ReferredTo, ReferredToName, ReferredBy, ReferredByName " + " FROM PendingWorklisttable " + WFSUtil.getLockPrefixStr(dbType) + ", QueueDataTable " + WFSUtil.getLockPrefixStr(dbType) + " WHERE PendingWorklisttable.processinstanceid = QueueDataTable.processinstanceid" + " AND PendingWorklisttable.workitemid = QueueDataTable.workItemId" + " AND PendingWorklisttable.ProcessInstanceID = ? AND PendingWorklisttable.WorkItemID = ? ");
			pstmt = con.prepareStatement(qStr);
            WFSUtil.DB_SetString(1, procInstID, pstmt, dbType);
            pstmt.setInt(2, wrkItemID);
            //pstmt.execute();
            parameter.addAll(Arrays.asList(procInstID,wrkItemID));
            ResultSet rs = WFSUtil.jdbcExecuteQuery(procInstID, sessionId, participant.getid(), qStr, pstmt, parameter, debug, engine);
            
            if (rs.next()) {
                int wState = rs.getInt("WorkItemState");
                String lockedBy = rs.getString("AssignedUser");
                lockedBy = rs.wasNull() ? "" : lockedBy;
                int qId = rs.getInt("Q_QueueId");
                String tempStr = rs.getString("AssignmentType");
                char assgnType = rs.wasNull() ? '\0' : tempStr.charAt(0);
                int q_UserId = rs.getInt("Q_UserID");
                int referredToId = rs.getInt("ReferredTo");
                String referredToName = rs.getString("ReferredToName");
                int referredById = rs.getInt("ReferredBy");
                String referredByName = rs.getString("ReferredByName");

                rs.close();
                pstmt.close();

                if (wState == 3 && q_UserId == userID && lockedBy.trim().equalsIgnoreCase(username) && referredToId != 0) {
                    // Insert into Worklist Table
                    if (con.getAutoCommit()) {
                        con.setAutoCommit(false);
                        transactionOpened = true;
                    }
                    // Tirupati Srivastava : changes in queries for PostgreSql dbase
					//Process Variant Support
                    
                    /*pstmt = con.prepareStatement(
                            "Insert into Worklisttable (ProcessInstanceId, WorkItemId, " + "ProcessName, ProcessVersion, ProcessDefID,ProcessVariantId, LastProcessedBy, ProcessedBy, ActivityName, " + "ActivityId, EntryDateTime, ParentWorkItemId, AssignmentType, CollectFlag, PriorityLevel, " + "ValidTill, Q_StreamId, Q_QueueId, Q_UserId, AssignedUser, FilterValue, CreatedDateTime, " + "WorkItemState, Statename, ExpectedWorkitemDelay, PreviousStage, LockStatus, " + "Queuename, Queuetype, NotifyStatus) Select ProcessInstanceId, WorkItemId, " + "ProcessName, ProcessVersion, ProcessDefID,ProcessVariantId, LastProcessedBy, ProcessedBy, ActivityName, " + "ActivityId, EntryDateTime, ParentWorkItemId, " + "AssignmentType, CollectFlag, " //Bugzilla Bug 637 (Assignment type not changed as while refering original AssignmentType is there in pendingWorklisttable //modified in case of qId = 0 case added for WSE_5.0.1_beta_231 by Ashish
                            + "PriorityLevel, ValidTill, Q_StreamId, Q_QueueId, Q_UserId, AssignedUser, FilterValue, " //modified in case of qId = 0 case added for WSE_5.0.1_beta_231 Ashish
                            + "CreatedDateTime, 2, " + WFSUtil.TO_STRING(WFSConstant.WF_RUNNING, true, dbType) + ", ExpectedWorkitemDelay, PreviousStage, N'N', " + " Queuename, Queuetype, NotifyStatus from PendingWorklisttable " + "where ProcessInstanceID=? and WorkItemID=? ");
                    WFSUtil.DB_SetString(1, procInstID, pstmt, dbType);
                    pstmt.setInt(2, wrkItemID);
                    int res1 = pstmt.executeUpdate(); //Bug # 1621
                    pstmt.close();

                    pstmt = con.prepareStatement(
                            "Delete from PendingWorklisttable where ProcessInstanceID=? and WorkItemID=?");
                    WFSUtil.DB_SetString(1, procInstID, pstmt, dbType);
                    pstmt.setInt(2, wrkItemID);
                    int res2 = pstmt.executeUpdate();
                    pstmt.close();
                    pstmt = con.prepareStatement(
                            "Update QueueDataTable Set ReferredTo = null, ReferredToName = null " + "where ProcessInstanceID = ? and WorkItemID = ?");
                    WFSUtil.DB_SetString(1, procInstID, pstmt, dbType);
                    pstmt.setInt(2, wrkItemID);
                    int res3 = pstmt.executeUpdate();
                    pstmt.close();*/
                    //qStr = "Update WFINSTRUMENTTABLE Set WorkItemState = 2 , Statename = ? , LockStatus = N'N' , ReferredTo = null, ReferredToName = null, RoutingStatus = N'N' where ProcessInstanceID = ? and WorkItemID = ? and RoutingStatus = 'R'";
                    //Changes for Bug 54573 - Windows : JBOSS : SQL : Functional > Workitem is showing locked in my queue, lock icon is not showing, and also Assign To me option is enabled
					String tempQStr = null;
                    if(qId > 0 ){
                        tempQStr = ",Q_UserID = 0, AssignedUser = null , LockedByName = null , LockStatus = N'N',AssignmentType = 'S'";
                    }
                    qStr = "Update WFINSTRUMENTTABLE Set WorkItemState = 2 , Statename = ? , ReferredTo = null, ReferredToName = null, RoutingStatus = N'N'" + (qId > 0 ? tempQStr : ", AssignmentType = 'F'") +" where ProcessInstanceID = ? and WorkItemID = ? and RoutingStatus = 'R'";
                    
                    if(referredById!=0){
                    	qStr = "Update WFINSTRUMENTTABLE Set WorkItemState = 2 , AssignmentType = 'E', Statename = ? , ReferredTo = null, ReferredToName = null, RoutingStatus = N'N' where ProcessInstanceID = ? and WorkItemID = ? and RoutingStatus = 'R'";
                    }
                    
                    pstmt = con.prepareStatement(qStr);
                    WFSUtil.DB_SetString(1, WFSConstant.WF_RUNNING, pstmt, dbType);
                    WFSUtil.DB_SetString(2, procInstID, pstmt, dbType);
                    pstmt.setInt(3, wrkItemID);
                    parameter.clear();
                    parameter.addAll(Arrays.asList(WFSConstant.WF_RUNNING,procInstID,wrkItemID));
                    int res1 = WFSUtil.jdbcExecuteUpdate(procInstID, sessionId, participant.getid(), qStr, pstmt, parameter, debug, engine);
                    if (res1 > 0) {
                        if (transactionOpened) {
                            con.commit();
                            con.setAutoCommit(true);
                            transactionOpened = false;
                        }
                        withdrawWI(engine, con, procInstID, wrkItemID, userID, username, sessionId, debug);
                    } else {
                        mainCode = WFSError.WM_INVALID_WORKITEM;
                        subCode = WFSError.WFS_NOQ;
                        subject = WFSErrorMsg.getMessage(mainCode);
                        descr = WFSErrorMsg.getMessage(subCode);
                        // WFS_5_215 Rollback transaction only if opened in this function
                        if (transactionOpened) {
                            con.rollback();
                            con.setAutoCommit(true);
                            transactionOpened = false;
                        }
                    }
                } else {
                    mainCode = WFSError.WM_INVALID_WORKITEM;
                    subCode = WFSError.WFS_NOT_RFR;
                    subject = WFSErrorMsg.getMessage(mainCode);
                    descr = WFSErrorMsg.getMessage(subCode);
                    errType = WFSError.WF_TMP;
                }
            } else {
                if (rs != null) {
                    rs.close();
                }
                pstmt.close();
                mainCode = WFSError.WM_INVALID_WORKITEM;
                subCode = WFSError.WFS_WKM_CLSD;
                subject = WFSErrorMsg.getMessage(mainCode);
                descr = WFSErrorMsg.getMessage(subCode);
                errType = WFSError.WF_TMP;
            }

        } catch (Exception e) {
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_EXP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } finally { //Bug WFS_6_004 - Statement closed in finally.
            try {
                // WFS_5_215 Rollback transaction only if opened in this function
                if (transactionOpened) {
                    con.rollback();
                    con.setAutoCommit(true);
                }
                if (pstmt != null) {
                    pstmt.close();
                    pstmt = null;
                }
            } catch (Exception ignored) {
            }
            
        }
        if (mainCode != 0) {
            throw new WFSException(mainCode, subCode, errType, subject, descr);
        }
    }

	public static void WFWithDraw(WFParticipant participant, Connection con, String procInstID,
			int wrkItemID, String engine) throws SQLException, JTSException {
		
		  WFWithDraw(participant, con, procInstID,wrkItemID, engine, 0, false); 
	}

// Added By Dinesh
    public String WFFetchWorkItemsWithLock(Connection con, XMLParser parser, XMLGenerator gen) throws JTSException, WFSException {
        int subCode = 0;
        int mainCode = 0;
        ResultSet rs = null;
        String descr = null;
        String subject = null;
        StringBuffer outputXML = new StringBuffer("");
        String errType = WFSError.WF_TMP;
        CallableStatement cstmt = null;
        String engine =null;
        try {
            int sessionID = parser.getIntOf("SessionId", 0, false);
            engine = parser.getValueOf("EngineName");
            int dbType = ServerProperty.getReference().getDBType(engine);
            int queueid = parser.getIntOf("QueueId", 0, true);
            char countFlag = parser.getCharOf("CountFlag", 'N', true);
            int noOfRectoFetch = parser.getIntOf("NoOfRecordsToFetch", ServerProperty.getReference().getBatchSize(), true);
            int lastWIValue = parser.getIntOf("LastWorkItem", 0, true);
            String lastValue = parser.getValueOf("LastValue", "", true);
            String lastPIValue = parser.getValueOf("LastProcessInstance", "", true);
            char sortOrder = parser.getCharOf("SortOrder", 'D', true);
            int orderBy = parser.getIntOf("OrderBy", 1, true);
            char dataflag = parser.getCharOf("DataFlag", 'Y', true);
            String userFilterStr = WFSUtil.getFilter(parser, con, dbType);
            int noOfRecordsFetched = 0;
            int totalNoOfRecords = 0;
            // ------------------------------------------
            // Changed By  : Ruhi Hira
            // Changed On  : 30th Sep 2004
            // Description : Logic for FetchWorkItemWithLock moved to SP.
            // ------------------------------------------
            //Begin WFS_6_031
            if (noOfRectoFetch > ServerProperty.getReference().getBatchSize() || noOfRectoFetch <= 0) {
                noOfRectoFetch = ServerProperty.getReference().getBatchSize();
            }
            if ((dbType == JTSConstant.JTS_MSSQL) || (dbType == JTSConstant.JTS_DB2)) {
                cstmt = con.prepareCall("{call WFLockWorkItem(?, ?, ?, ?, ?, ?, ?, ?, ?)}");
            } else if (dbType == JTSConstant.JTS_ORACLE) {
                cstmt = con.prepareCall("{call WFLockWorkItem(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)}");
            }
            //End WFS_6_031
            cstmt.setInt(1, sessionID);
            cstmt.setInt(2, queueid);
            cstmt.setString(3, "" + sortOrder);
            cstmt.setInt(4, orderBy);
            cstmt.setInt(5, noOfRectoFetch);
            cstmt.setInt(6, lastWIValue);
            cstmt.setString(7, lastPIValue);
            cstmt.setString(8, lastValue);
            cstmt.setString(9, userFilterStr);

            //Begin WFS_6_031
            if (dbType == JTSConstant.JTS_ORACLE) {
                cstmt.registerOutParameter(10, java.sql.Types.INTEGER);
                cstmt.registerOutParameter(11, java.sql.Types.INTEGER);
                cstmt.registerOutParameter(12, java.sql.Types.INTEGER);
                cstmt.registerOutParameter(13, java.sql.Types.INTEGER);
                cstmt.registerOutParameter(14, oracle.jdbc.OracleTypes.CURSOR);
            }
            //End WFS_6_031
            cstmt.execute();
            //Begin WFS_6_031
            if ((dbType == JTSConstant.JTS_MSSQL) || (dbType == JTSConstant.JTS_DB2)) {
                rs = cstmt.getResultSet();
            }
            if (((dbType == JTSConstant.JTS_MSSQL || dbType == JTSConstant.JTS_DB2) && rs != null && rs.next()) || dbType == JTSConstant.JTS_ORACLE) {
                if (dbType == JTSConstant.JTS_ORACLE) {
                    mainCode = cstmt.getInt(10);
                    subCode = cstmt.getInt(11);
                    noOfRecordsFetched = cstmt.getInt(12);
                    totalNoOfRecords = cstmt.getInt(13);
                } else {
                    mainCode = rs.getInt(1);
                    subCode = rs.getInt(2);
                    noOfRecordsFetched = rs.getInt(3);
                    totalNoOfRecords = rs.getInt(4);
                }
                if (mainCode != 0) {
                    throw new WFSException(mainCode, subCode, WFSError.WF_TMP, WFSErrorMsg.getMessage(mainCode), WFSErrorMsg.getMessage(mainCode));
                }
            } else {
                mainCode = WFSError.WM_NO_MORE_DATA;
                subCode = 0;
                throw new WFSException(mainCode, subCode, WFSError.WF_TMP, WFSErrorMsg.getMessage(mainCode), WFSErrorMsg.getMessage(mainCode));
            }
            if (rs != null) {
                rs.close();
            }
            if ((dbType == JTSConstant.JTS_MSSQL || dbType == JTSConstant.JTS_DB2) && cstmt.getMoreResults() == false) {
                throw new WFSException(WFSError.WF_OTHER, WFSError.WF_OTHER, WFSError.WF_TMP, WFSErrorMsg.getMessage(WFSError.WF_OTHER), WFSErrorMsg.getMessage(WFSError.WF_OTHER));
            }
            if ((dbType == JTSConstant.JTS_MSSQL || dbType == JTSConstant.JTS_DB2)) {
                rs = cstmt.getResultSet();
            } else {
                rs = (ResultSet) cstmt.getObject(14);
            }

            if (rs == null) {
                throw new WFSException(WFSError.WF_OTHER, WFSError.WF_OTHER, WFSError.WF_TMP, WFSErrorMsg.getMessage(WFSError.WF_OTHER), WFSErrorMsg.getMessage(WFSError.WF_OTHER));
            }
            //End WFS_6_031
            int j = 0;
            boolean lock = false;
            String strProcessInstanceId = "";
            String strLockstatus = "";
            String lockedByUserName = "";
            String strColumnValue = "";
            int i = 0;
            StringBuffer tempXml = new StringBuffer(500 * (i > noOfRectoFetch ? noOfRectoFetch : i));
            ResultSetMetaData rsmd = null;
            int nRSize = 0;
            if (dataflag == 'Y') {
                rsmd = rs.getMetaData();
                nRSize = rsmd.getColumnCount();
            }
            while (j < noOfRectoFetch && rs.next()) {
                tempXml.append("<Instrument>\n");
                strProcessInstanceId = rs.getString(1);
                tempXml.append(gen.writeValueOf("ProcessInstanceId", strProcessInstanceId));
                tempXml.append(gen.writeValueOf("WorkItemName", rs.getString(2)));
                tempXml.append(gen.writeValueOf("RouteId", rs.getString(3)));
                tempXml.append(gen.writeValueOf("RouteName", rs.getString(4)));
                tempXml.append(gen.writeValueOf("WorkStageId", rs.getString(5)));
                tempXml.append(gen.writeValueOf("ActivityName", rs.getString(6)));
                tempXml.append(gen.writeValueOf("PriorityLevel", rs.getString(7)));
                tempXml.append(gen.writeValueOf("InstrumentStatus", rs.getString(8)));
                strLockstatus = rs.getString(9);
                strLockstatus = rs.wasNull() ? "" : strLockstatus;
                tempXml.append(gen.writeValueOf("LockStatus", strLockstatus));
                lockedByUserName = rs.getString(10);
                lockedByUserName = rs.wasNull() ? "" : lockedByUserName;
                tempXml.append(gen.writeValueOf("LockedByUserName", lockedByUserName));
                tempXml.append(gen.writeValueOf("ExpiryDateTime", rs.getString(11)));
                tempXml.append(gen.writeValueOf("CreatedByUserName", rs.getString(12)));
                tempXml.append(gen.writeValueOf("CreationDateTime", rs.getString(13)));
                tempXml.append(gen.writeValueOf("WorkitemState", rs.getString(14)));
                tempXml.append(gen.writeValueOf("CheckListCompleteFlag", rs.getString(15)));
                tempXml.append(gen.writeValueOf("EntryDateTime", rs.getString(16)));
                tempXml.append(gen.writeValueOf("LockedTime", rs.getString(17)));
                tempXml.append(gen.writeValueOf("IntroductionDateTime", rs.getString(18)));
                tempXml.append(gen.writeValueOf("IntroducedBy", rs.getString(19)));
                tempXml.append(gen.writeValueOf("AssignedTo", rs.getString(20)));
                strColumnValue = rs.getString(21);
                tempXml.append(gen.writeValueOf("WorkItemId", strColumnValue));
                tempXml.append(gen.writeValueOf("QueueName", rs.getString(22)));
                tempXml.append(gen.writeValueOf("AssignmentType", rs.getString(23)));
                tempXml.append(gen.writeValueOf("ProcessInstanceState", rs.getString(24)));
                tempXml.append(gen.writeValueOf("QueueType", rs.getString(25)));
                tempXml.append(gen.writeValueOf("Status", rs.getString(26)));
                tempXml.append(gen.writeValueOf("QueueId", rs.getString(27)));
                tempXml.append(gen.writeValueOf("Turnaroundtime", rs.getString(28)));
                tempXml.append(gen.writeValueOf("Referredby", rs.getString(29)));
                tempXml.append(gen.writeValueOf("Referredto", rs.getString(30)));
                tempXml.append("<Data>\n");
                for (int k = 0; k < nRSize - 53; k++) {
                    tempXml.append("<QueueData>\n");
                    tempXml.append(gen.writeValueOf("Name", rsmd.getColumnLabel(54 + k)));
                    tempXml.append(gen.writeValueOf("Value", rs.getString(54 + k)));
                    tempXml.append("\n</QueueData>\n");
                }
                tempXml.append("</Data>\n");
                tempXml.append("</Instrument>\n");
                j++;
            }
            if (rs.next()) {
                j++;
            }
            if (rs != null) {
                rs.close();
            }
            if (j > 0) {
                tempXml.insert(0, "<Instruments>\n");
                tempXml.append("</Instruments>\n");
            } else {
                mainCode = WFSError.WM_NO_MORE_DATA;
                subCode = 0;
                subject = WFSErrorMsg.getMessage(mainCode);
                descr = WFSErrorMsg.getMessage(subCode);
                errType = WFSError.WF_TMP;
            }
            tempXml.append(gen.writeValueOf("RetrievedCount", "" + noOfRecordsFetched));
            if (countFlag == 'Y') {
                tempXml.append(gen.writeValueOf("Count", "" + totalNoOfRecords));
            }
            if (mainCode == 0) {
                outputXML = new StringBuffer(500);
                outputXML.append(gen.createOutputFile("WFFetchWorkItemsWithLock"));
                outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
                outputXML.append(tempXml);
                outputXML.append(gen.closeOutputFile("WFFetchWorkItemsWithLock"));
            }
        } catch (SQLException e) {
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WM_INVALID_FILTER;
            subCode = WFSError.WFS_SQL;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_FAT;
            if (e.getErrorCode() == 0) {
                if (e.getSQLState().equalsIgnoreCase("08S01")) {
                    descr = (new JTSSQLError(e.getSQLState())).getMessage() + "(SQL State : " + e.getSQLState() + ")";
                }
            } else {
                descr = e.getMessage();
            }
        } catch (NumberFormatException e) {
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_ILP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch (NullPointerException e) {
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_SYS;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch (WFSException e) {
            WFSUtil.printErr(engine,"", e);
            mainCode = e.getMainErrorCode();
            subCode = e.getSubErrorCode();
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = WFSErrorMsg.getMessage(subCode);
        } catch (JTSException e) {
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = e.getErrorCode();
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.getMessage();
        } catch (Exception e) {
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_EXP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch (Error e) {
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_EXP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } finally {
        	try {
                if (rs != null) {
                    rs.close();
                    rs = null;
                }
            } catch (Exception e) {
            }
            try {
                if (cstmt != null) {
                    cstmt.close();
                    cstmt = null;
                }
            } catch (Exception e) {
            }
           
        }
        if (mainCode != 0) {
            throw new WFSException(mainCode, subCode, errType, subject, descr);
        }
        return outputXML.toString();
    }

// Added By Dinesh
//----------------------------------------------------------------------------------------------------
//	Function Name 				:	getBatchString
//	Date Written (DD/MM/YYYY)	:	02/02/2006
//	Author						:	Ashish Mangla
//	Input Parameters			:	workItemId, tablename, processInstance, orderBy, srtby, operator1, operator2, lastValue, sortOrder, dbType
//	Output Parameters			:   none
//	Return Values				:	StringBuffer
//	Description					:   Prepares the order by string and last value string for batching
//----------------------------------------------------------------------------------------------------
    /**
     * This function is to create the query part that required to implement batching
     * Here Batching is required for workitems and
     * primary key for a workitem is -> [ProcessInstanceId + WorkitemId]
     * User may need to get sorted workitem list on one or more fields
     * Taking an example : say city is a queue variable and it can have null value
     * And data is to be fetched with sort field city asc
     * Then for Oracle ['' is also null]  : null values comes after not null values
     * for DB2 & MSSQL ['' is diff from null] : null then not null then ''
     * Hence to fetch a workitem list with listed data, sort field is city, batch size is 2
     * ---------------------------------------------
     *  ProcessInstanceId   WorkitemId      City
     * ---------------------------------------------
     *   wf_0001                1            a6
     *   wf_0002                1            null
     *   wf_0003                1            a4
     *   wf_0004                1            a4
     *   wf_0004                2            a6
     *   wf_0005                1            null
     *   wf_0006                1            a2
     *   wf_0007                1            null
     * ---------------------------------------------
     * Expected result for oracle is :
     * ---------------------------------------------
     *  ProcessInstanceId   WorkitemId      City
     * ---------------------------------------------
     *   wf_0006                1            a2
     *   wf_0003                1            a4
     * ---------------------------------------------
     *   wf_0004                1            a4
     *   wf_0001                1            a6
     * ---------------------------------------------
     *   wf_0004                2            a6
     *   wf_0002                1            null
     * ---------------------------------------------
     *   wf_0005                1            null
     *   wf_0007                1            null
     * ---------------------------------------------
     * query to get the same is
     *
     * Select * From ( Select ....
     *                  Where city > <<lastCity>> or city is null
     *                  OR ( city = <<lastCity>> AND ((Processinstanceid = <<lastProcessInstanceId>> AND  WorkItemId > <<lastWorkItemId>> )
     *                                          OR Processinstanceid > <<lastProcessInstanceId>> ))
     *                  order by city, ProcessInstanceId, WorkItemId
     * ) Where rownum < 3
     *
     * This is a recursive function, hence as the number of fields increases in sort list, the function is invoked
     * with (index + 1) => level
     */
    private String getBatchString(ArrayList arList, int index, String ProcessInstanceId, int WorkItemId, String operator, int dbType) {

        StringBuffer query = new StringBuffer();
        WFBatchInfo batchInfo = (WFBatchInfo) arList.get(index);
        boolean dbTypeOracle = false;
        char sortOrder = batchInfo.orderBy;
        if (dbType == JTSConstant.JTS_ORACLE || dbType == JTSConstant.JTS_POSTGRES) {
            dbTypeOracle = true;
        }

        if (batchInfo.lastValue != null) {
            query.append(batchInfo.columnName).append(sortOrder == 'A' ? " > " : " < ").append(batchInfo.lastValue);
            query.append((sortOrder == 'A' ? (dbTypeOracle ? " or " + batchInfo.columnName + " is null" : "") : (dbTypeOracle ? "" : " or " + batchInfo.columnName + " is null")));
        } else {
            query.append((sortOrder == 'A' ? (dbTypeOracle ? "" : batchInfo.columnName + " is not null") : (dbTypeOracle ? batchInfo.columnName + " is not null" : "")));
        }

        if (query.length() > 0) { //Bugzilla Bug 3303
            query.append(" OR ");
        }

        if (index == arList.size() - 1) {
            query.append(" ( ").append(batchInfo.columnName).append((batchInfo.lastValue != null ? " = " + batchInfo.lastValue : " is null"));
            query.append(" AND (  ( Processinstanceid ").append(" = ").append(ProcessInstanceId);
            query.append(" AND  WorkItemId ").append(operator).append(WorkItemId).append(") ");

            query.append(" OR  Processinstanceid ").append(operator).append(ProcessInstanceId).append(" )");
            query.append(")");

        } else {
            query.append(" ( ").append(batchInfo.columnName).append((batchInfo.lastValue != null ? " = " + batchInfo.lastValue : " is null"));
            query.append(" AND (").append(getBatchString(arList, index + 1, ProcessInstanceId, WorkItemId, operator, dbType)).append(" )");
            query.append(")");
        }

        return (query.toString());
    }

    //----------------------------------------------------------------------------------------------------
//	Function Name 				:	WFFetchWorkItemCount
//	Date Written (DD/MM/YYYY)	:	06/03/2006
//	Author						:	Harmeet Kaur
//	Input Parameters			:	Connection , XMLParser , XMLGenerator
//	Output Parameters			:   none
//	Return Values				:	String
//	Description					:   Fetch the count of workitems in a queue
//  Change Description          :   Bugzilla Bug 1680
//----------------------------------------------------------------------------------------------------
    public String WFFetchWorkItemCount(Connection con, XMLParser parser, XMLGenerator gen) throws JTSException, WFSException { //WFS_5_106
        StringBuffer outputXML = null;
        StringBuffer inputXML = null;
        CallableStatement cstmt = null;
        ResultSet rs = null;
        ResultSet curResultSet = null;
        ResultSet rs1 = null;
        Statement stmt = null;
        String cursorName = "";
        int mainCode = 0;
        int subCode = 0;
        int returnCount = 0;
        String subject = null;
        String descr = null;
        String errType = WFSError.WF_TMP;
        String ClientOrderFlag = "";
		int startingRecordNo = 0;
		boolean printQueryFlag = true;
        String pagingFlag = null;
        String engine =null;
        String queueType1 = "";
        boolean dynamicQueueFlag = false;
        boolean myQueueFlag = false;
        try {
            int sessionID = parser.getIntOf("SessionId", 0, false);
            int userid = 0;
            WFParticipant participant = WFSUtil.WFCheckSession(con, sessionID);
            if (participant != null && participant.gettype() == 'U') {
                userid = participant.getid();
            }
            String filter = "";
            int queueid = parser.getIntOf("QueueId", 0, true);
            myQueueFlag = parser.getValueOf("MyQueueFlag", "N", true).equalsIgnoreCase("Y");
            dynamicQueueFlag = parser.getValueOf("DynamicQueueFlag", "Y", true).equalsIgnoreCase("Y");
            queueType1 = parser.getValueOf("QueueType", "", true);
            engine = parser.getValueOf("EngineName");
            String fetchLockedFlag = parser.getValueOf("FetchLockedFlag", "N", true); // Bugzilla Bug 1703
            int dbType = ServerProperty.getReference().getDBType(engine);
            //Bug 1531
            String systemAssignedWI = parser.getValueOf("SystemAssignedWI", "N", true);
            ClientOrderFlag = parser.getValueOf("ClientOrderFlag", "N", true);
			startingRecordNo = parser.getIntOf("StartingRecordNo", 0, true);
            pagingFlag = parser.getValueOf("PagingFlag", "N", true);  
            if(startingRecordNo > 0){     //if page number comes in input xml
				pagingFlag = "Y";
            }
            //	Added By Varun Bhansaly On 16/05/2007 so that size should not be greater than the entry set in server.xml
            int serverBatchSize = ServerProperty.getReference().getBatchSize();
            String filterValue = "";
            StringBuffer tempXml = null;
			String tempStr = parser.getValueOf("FilterString", "", true);
            /*Bugzilla Bug 1680*/
            /*if (queueid == 0) {
				//Changes for Bug 58016
                filter = " Q_UserId = " + userid + " and ActivityType!=32 ";
				//Bug 1531
				if(systemAssignedWI.equalsIgnoreCase("Y"))
				   filter = filter + "and assignmentType != 'S' ";
            }
            if((queueid > 0)||((queueid==0) &&(tempStr != null && !tempStr.equals("")))) {
                filterValue = WFSUtil.getFilterDoubleQuoteCase(parser, con, dbType);
				filter = filterValue;
            }*/
            WFSUtil.printOut(engine,"[FetchWorkitemCount]>>"+filter);
//            if (dbType == JTSConstant.JTS_POSTGRES) {
//                inputXML = new StringBuffer(500);
//                inputXML.append("<?xml version=\"1.0\"?><WMFetchWorkList_Input><Option>WMFetchWorkList</Option><EngineName>").append(engine).append("</EngineName><SessionId>").append(sessionID).append("</SessionId><Filter><QueueId>").append(queueid).append("</QueueId><Type>256</Type><Comparison>0</Comparison><FilterString>").append(filter).append("</FilterString></Filter><UserIndex>").append(userid).append("</UserIndex>").append(
//                        "<ReturnCountFlag>Y</ReturnCountFlag><ReturnOnlyCountFlag>Y</ReturnOnlyCountFlag><FetchLockedFlag>").append(fetchLockedFlag).append("</FetchLockedFlag>").append("</WMFetchWorkList_Input>");
//                parser.setInputXML(inputXML.toString());
//                outputXML = new StringBuffer(WFFetchWorkItems1(con, parser, gen,printQueryFlag));
//                parser.setInputXML(outputXML.toString());
//                returnCount = parser.getIntOf("WorkitemCount", 0, true);
//            } else {
             //   if (!filter.trim().equals("") && filterValue.trim().equals("")) {
                  // filter = " and " + filter;
               // }
                if (dbType == JTSConstant.JTS_POSTGRES){
                    con.setAutoCommit(false);
                    cstmt = con.prepareCall("{call WFFetchWorkList(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,?,?,?)}"); 
               }
                else if (dbType == JTSConstant.JTS_MSSQL) {
                    cstmt = con.prepareCall("{call WFFetchWorkList(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,?)}"); // Bugzilla Bug 1703
                }
                else if (dbType == JTSConstant.JTS_ORACLE) {
                    cstmt = con.prepareCall("{call WFFetchWorkList(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,?)}"); // Bugzilla Bug 1703
                }
                cstmt.setInt(1, sessionID);
                cstmt.setInt(2, queueid);
                cstmt.setString(3, "A");
                cstmt.setInt(4, 2);// By default order by on processinstanceid, workitemid
                cstmt.setInt(5, serverBatchSize);
                cstmt.setInt(6, 0);
                cstmt.setString(7, "N");
                cstmt.setString(8, fetchLockedFlag); // Bugzilla Bug 1703
                cstmt.setString(9, "");
                cstmt.setString(10, "");
                
                String filterStr = "";
                filterStr=" AND (assignmentType!='Z' OR (assignmentType='Z' AND  Q_UserId= "+userid+"  ) ) ";
                if (myQueueFlag) {                
    				filterStr = "AND (Q_UserId = " + userid + " )";
                    if(systemAssignedWI.equalsIgnoreCase("Y"))
                        filterStr = filterStr + " and assignmentType != 'S' ";
                    cstmt.setString(11, filterStr);
                }else if(dynamicQueueFlag && queueType1.equalsIgnoreCase("D")){
                    filterStr = " AND Q_UserId =" + userid + " AND assignmentType = 'S' ";
                    cstmt.setString(11, filterStr);
                }else {
    				if (queueid == 0)
    					filterStr = "AND (Q_UserId = " + userid  + " ) and ActivityType != 32 ";
                    filterStr = filterStr + WFSUtil.getFilter(parser, con, dbType);
                    if((queueid == 0) && systemAssignedWI.equalsIgnoreCase("Y"))
                        filterStr = filterStr + " and assignmentType != 'S' ";
                    cstmt.setString(11, filterStr);
                }
                
            
                /*Bugzilla Bug 1680*/
                cstmt.setInt(12, 1);
				cstmt.setString(13, "N");	//ProcessSpecificAlias has no impact on count
				cstmt.setInt(14, 0);	//should be sent 0 in conjunction with above parameter
                cstmt.setString(15, ClientOrderFlag);
				cstmt.setInt(16, startingRecordNo);
                if (dbType == JTSConstant.JTS_MSSQL || dbType == JTSConstant.JTS_POSTGRES) {
                    cstmt.setString(17, pagingFlag);
                }
                if (dbType == JTSConstant.JTS_ORACLE) {
                    cstmt.registerOutParameter(17, java.sql.Types.INTEGER);
                    cstmt.registerOutParameter(18, java.sql.Types.INTEGER);
                    cstmt.registerOutParameter(19, java.sql.Types.INTEGER); /*Bugzilla Bug 1680*/
					cstmt.registerOutParameter(20, java.sql.Types.INTEGER);
                    cstmt.registerOutParameter(21, oracle.jdbc.OracleTypes.CURSOR);
                    cstmt.setString(22, pagingFlag);
                }
                cstmt.execute();
                if (dbType == JTSConstant.JTS_MSSQL) {
                    rs = cstmt.getResultSet();
                }
                if ((dbType == JTSConstant.JTS_MSSQL && rs != null && rs.next()) || dbType == JTSConstant.JTS_ORACLE || dbType == JTSConstant.JTS_POSTGRES) {
                    if (dbType == JTSConstant.JTS_ORACLE) {
                        mainCode = cstmt.getInt(17);
                        subCode = cstmt.getInt(18);
                        returnCount = cstmt.getInt(19); /*Bugzilla Bug 1680*/
                    }else if(dbType == JTSConstant.JTS_POSTGRES){
                        curResultSet = cstmt.getResultSet();
                        if(curResultSet.next()){
                            stmt = con.createStatement();
                            cursorName = curResultSet.getString(1);
                            rs1 = stmt.executeQuery("Fetch All In \"" + TO_SANITIZE_STRING(cursorName, false) + "\"");
                            if(rs1!=null && rs1.next()){
                               mainCode = rs1.getInt("MainCode");
                               returnCount = rs1.getInt("ReturnCount");
                            }
                        }
                        if(rs1!=null){
                            rs1.close();
                            rs1 = null;
                        }
                        if(curResultSet!=null){
                            curResultSet.close();    
                            curResultSet =null;
                        }
                        if(stmt!=null){
                            stmt.close();
                            stmt =null;
                        }
                    } else {
                        mainCode = rs.getInt("MainCode");
                        returnCount = rs.getInt("ReturnCount");
                        rs.close();
                        rs = null;
                    }
                } else {
                    /* This should never be the case */
                    if (rs != null) {
                        rs.close();
                        rs = null;
                    }
                    mainCode = WFSError.WF_OPERATION_FAILED;
                    subCode = WFSError.WFS_FATAL;
                    returnCount = 0; /*Bugzilla Bug 1680*/
                }
            //}
            if (mainCode == 0) {
                outputXML = new StringBuffer(500);
                outputXML.append(gen.createOutputFile("WFFetchWorkItemCount"));
                outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
                outputXML.append("<WorkitemCount>");
                outputXML.append(String.valueOf(returnCount));
                outputXML.append("</WorkitemCount>");
                outputXML.append(gen.closeOutputFile("WFFetchWorkItemCount"));
            }
            if(dbType==JTSConstant.JTS_POSTGRES){
                con.commit();
                con.setAutoCommit(true);
            }
        } catch (SQLException e) {
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WM_INVALID_FILTER;
            subCode = WFSError.WFS_SQL;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_FAT;
            if (e.getErrorCode() == 0) {
                if (e.getSQLState().equalsIgnoreCase("08S01")) {
                    descr = (new JTSSQLError(e.getSQLState())).getMessage() + "(SQL State : " + e.getSQLState() + ")";
                }
            } else {
                descr = e.getMessage();
            }
        } catch (NumberFormatException e) {
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_ILP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch (NullPointerException e) {
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_SYS;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch (WFSException e) {
            mainCode = e.getMainErrorCode();
            subCode = e.getSubErrorCode();
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = e.getTypeOfError();
            descr = WFSErrorMsg.getMessage(subCode);
        } catch (JTSException e) {
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = e.getErrorCode();
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.getMessage();
        } catch (Exception e) {
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_EXP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch (Error e) {
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_EXP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } finally {
            try {
//				Added By Varun Bhansaly On 16/05/2007
                if (rs != null) {
                    rs.close();
                    rs = null;
                }
            } catch (Exception e) {
            }
            try {
//				Added By Varun Bhansaly On 16/05/2007
                if (cstmt != null) {
                    cstmt.close();
                    cstmt = null;
                }
            } catch (Exception e) {
            }
            
        }
        if (mainCode != 0) {
            throw new WFSException(mainCode, subCode, errType, subject, descr);
        }
        return outputXML.toString();

    }

    /**-------------------------------------------------------------------------------
     *	Function Name                   :   WFGetWorkitemDataExt
     *	Date Written (DD/MM/YYYY)       :   27/04/2007
     *	Changed By                      :   Shilpi S
     *	Input Parameters                :   Connection , XMLParser , XMLGenerator
     *	Output Parameters               :   none
     *	Return Values                   :   String
     *	Description                     :   Locks the workitem and return the workitem
     *					    with data.
     * Change Description               :   added for single call support (as in 5.0)
     *-----------------------------------------------------------------------------*/
    public String WFGetWorkitemDataExt(Connection con, XMLParser parser, XMLGenerator gen) throws JTSException, WFSException {
        int mainCode = 0;
        int subCode = 0;
        ResultSet rs2=null;
        String strOption=null;
        String targetCabinetName=null;
        Connection tarConn=null;
        String processName=null;
        ResultSet cursorResultSet=null;
        CallableStatement cstmt = null;
        Statement stmt = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        ResultSetMetaData rsmd = null;
        String descr = null;
        String subject = null;	
        StringBuffer outputXML = new StringBuffer("");
        String errType = WFSError.WF_TMP;
        String zippedFlag = "";
        String objectPreferenceList; //Sr No. 2
        String tempStr = " "; //Sr No. 2
        String query = "";
        String varRec1 = "";
        String varRec2 = "";
        int counter = 0; // Sr No. 2
        int pos; //Sr No. 2
        Object[] result = null;
//		ResultSet[] resultSet = null;
        PreparedStatement[] pstmtArray = null;
        boolean queryQueueHistoryTable = false;
        //Bug #815
        String sortedOn = null;
		String assignMe = null;
		boolean reminder = false;
		String option = null;
		String engine = null;
        String queryCallable = null;
        long startTime = 0l;
        long endTime = 0l;
		char char21 = 21;
		String string21 = "" + char21;
        boolean throwError = false;
        String canInitiate = "N";
        String showCaseVisual = "N";
        StringBuilder inputParamInfo = new StringBuilder();
        boolean dynamicQueueFlag = false;
        int taskStatus = 0;
        try {
        	ArrayList batchInfo = new ArrayList();
			option = parser.getValueOf("Option", "", false);
            int sessionID = parser.getIntOf("SessionId", 0, false);
            engine = parser.getValueOf("EngineName");
            
            String appServerIP = WFServerProperty.getSharedInstance().getCallBrokerData().getProperty(WFSConstant.CONST_BROKER_APP_SERVER_IP);
            int appServerPort = Integer.parseInt(WFServerProperty.getSharedInstance().getCallBrokerData().getProperty(WFSConstant.CONST_BROKER_APP_SERVER_PORT));
            String appServerType = WFServerProperty.getSharedInstance().getCallBrokerData().getProperty(WFSConstant.CONST_BROKER_APP_SERVER_TYPE);
            WFProcess wfProcess = null;
            String externalTableName="";
            String historyTableName="";
            int queryTimeout = WFSUtil.getQueryTimeOut();
            
            String ArchiveSearch= parser.getValueOf("ArchiveSearch","N",true);
            int noOfRecordsToFetch = parser.getIntOf("NoOfRecordsToFetch", -1, true);
            dynamicQueueFlag = parser.getValueOf("DynamicQueueFlag", "N", true).equalsIgnoreCase("Y");
            if(noOfRecordsToFetch >0 ){
            	HashMap map = new HashMap();
            	map.put("NoOfRecordsToFetch", noOfRecordsToFetch);
            	batchInfo.add(map);
            	
            }
            //Mohnish Chopra : Changed for Support in Archival
            if(ArchiveSearch!=null && ArchiveSearch.equalsIgnoreCase("Y")) {
                strOption=parser.getValueOf("Option");
                pstmt=con.prepareStatement("Select PropertyValue from WFSYSTEMPROPERTIESTABLE where PropertyKey = ?");
                pstmt.setString(1,"ARCHIVALCABINETNAME");
                if(queryTimeout <= 0)
          			pstmt.setQueryTimeout(60);
                else
          			pstmt.setQueryTimeout(queryTimeout);
                rs= pstmt.executeQuery();
                if(rs.next()){
                	targetCabinetName=rs.getString("PropertyValue")	;
                }
                else{

                    mainCode = WFSError.WF_ARCHIVAL_CABINET_NOT_SET;
                    subCode = 0;
                    subject = WFSErrorMsg.getMessage(mainCode);
                    descr = WFSErrorMsg.getMessage(subCode);
                    errType = WFSError.WF_TMP;
    			
                	//throw new WFSException(mainCode, subCode, errType, subject, descr);
    				String errorString = WFSUtil.generalError(option, engine, gen,mainCode, subCode,errType, subject,descr);
    				return errorString;
                	
                }
                if(rs!=null){
                	rs.close();
                	rs=null;
                }
                if(pstmt!=null){
                	pstmt.close();
                	pstmt=null;
                }
                //targetCabinetName=parser.getValueOf("ArchivalCabinet","",false);
                tarConn=WFSUtil.createConnectionToTargetCabinet(targetCabinetName,strOption,engine);
                if(tarConn!=null)
                WFSUtil.printOut(engine,"Connection with Target Cabinet "+targetCabinetName+" is established.");
            }
            int dbType = ServerProperty.getReference().getDBType(engine);
            String processInstanceId = parser.getValueOf("ProcessInstanceId", "", true);
            int workitemId = parser.getIntOf("WorkitemId", 0, true);
            int queueId = parser.getIntOf("QueueId", -1, true);
            //Ensuring that rights are always checked in opening workitem
            if( !processInstanceId.isEmpty() && workitemId != 0 && (queueId>0) ) {
            	queueId = -1;
            }
            String queueType = parser.getValueOf("QueueType", "", true);
            if(queueType.equalsIgnoreCase("D")){
            	dynamicQueueFlag = true;
            }else{
            	dynamicQueueFlag = false;
            }
            int lastWorkitem = parser.getIntOf("LastWorkitem", 0, true);
            String lastProcessInstance = parser.getValueOf("LastProcessInstance", "", true);
            //Bug #815
            //int  queueid = parser.getIntOf("QueueId", 0, true);
            int orderBy = parser.getIntOf("OrderBy", 2, true);
            String lastValue = parser.getValueOf("LastValue", "", true);
            String sortOrder = parser.getValueOf("SortOrder", "A", true);
            String generateLog = parser.getValueOf("GenerateLog", "Y", true);
            String clientOrderFlag = parser.getValueOf("DBClientOrderFlag", "N", true);
            zippedFlag = parser.getValueOf("ZipBuffer", "N", true);
            /* Begin Sr No. 2 */
            String tempPreferenceList = parser.getValueOf("ObjectPreferenceList", " ", true);
            boolean userDefVarFlag = parser.getValueOf("UserDefVarFlag", "N", true).equalsIgnoreCase("Y");
			String ClientOrderFlag = parser.getValueOf("ClientOrderFlag", "N", true);
            boolean pdaFlag = parser.getValueOf("PDAFlag", "N", true).equalsIgnoreCase("Y"); //Sr No. 12
			assignMe = parser.getValueOf("AssignMe", "N", true);
			String isSharePoint = parser.getValueOf("IsSharePoint", "N", true);
			boolean sharePointFlag = parser.getValueOf("IsSharePoint", "N", true).equalsIgnoreCase("Y");
            boolean debugFlag = parser.getValueOf("DebugFlag", "N", true).equalsIgnoreCase("Y");
			reminder = parser.getValueOf("ReminderFlag", "N", true).equalsIgnoreCase("Y");
            String utilityFlag = parser.getValueOf("UtilityFlag", "N", true);
			boolean dmsPropFlag = true;
			if(sharePointFlag)
				dmsPropFlag = false;
			String dmsUserName = parser.getValueOf("DMSUserName", "", dmsPropFlag); 
			String dmsPass_word = parser.getValueOf("DMSPassword", "", dmsPropFlag);
            String docListOptionFlag = parser.getValueOf("DocListOption", "Y", true);
            String isDocFlag = parser.getValueOf("ISDocFlag", "N", true);
            String dataAlsoFlag = parser.getValueOf("DataAlsoFlag", "N", true);
            int clientSite = parser.getIntOf("ClientSite", 1, true);
            //taskId and SubTaskId added in Input for Case Management
            int taskId = parser.getIntOf("TaskId", 0, true);
            int subTaskId = parser.getIntOf("SubTaskId", 0, true);
            int activityType =parser.getIntOf("ActivityType",0,true);	
            boolean isCaseActivity= false;
            // if no vales passed,pass default value
			int userId=0;
			String readFlag=null;
			WFParticipant participant = WFSUtil.WFCheckSession(con, sessionID);
            inputParamInfo.append(gen.writeValueOf("SessionId", String.valueOf(sessionID)));
            inputParamInfo.append(gen.writeValueOf("UserName", (participant == null ? "" : participant.getname())));
            if (participant != null && participant.gettype() == 'U') {
            	userId= participant.getid();
            }
            else{//Code review defect - Error code WM_INVALID_SESSION_HANDLE not handled in API WFGetWorkitemDataExt

				mainCode = WFSError.WM_INVALID_SESSION_HANDLE;
				subCode = 0;
				subject = WFSErrorMsg.getMessage(mainCode);
				descr = WFSErrorMsg.getMessage(subCode);
				errType = WFSError.WF_TMP;
				String strReturn = WFSUtil.generalError(option, engine, gen,
	   	                   mainCode, subCode,
	   	                   errType, subject,
	   	                    descr, inputParamInfo.toString());
	   	             
	   	        return strReturn;	
            }
            
            
          //Getting process object from cache
            int tmpProcessDefID=0;
            if("N".equalsIgnoreCase(ArchiveSearch)){
            	WFRuleEngine wfRuleEngine = WFRuleEngine.getSharedInstance();
            	wfRuleEngine.initialize(appServerIP, appServerPort, appServerType,"iBPS");
            	
            	pstmt= con.prepareStatement("select processdefId from WFInstrumenttable "+WFSUtil.getTableLockHintStr(dbType)+" where processInstanceId= ? and workitemId= ?");
            	WFSUtil.DB_SetString(1, processInstanceId, pstmt, dbType);
            	pstmt.setInt(2, workitemId);
            	if(queryTimeout <= 0)
          			pstmt.setQueryTimeout(60);
            	else
          			pstmt.setQueryTimeout(queryTimeout);
            	pstmt.execute();
            	rs = pstmt.getResultSet();
            	if(rs.next()){
            		tmpProcessDefID=rs.getInt(1);
            	}else{
            		if(rs!=null){
            			rs.close();
            			rs=null;
            		}
            		if(pstmt!=null){
            			pstmt.close();
            			pstmt=null;
            		}
            		pstmt= con.prepareStatement("select processdefId from QueueHistoryTable "+WFSUtil.getTableLockHintStr(dbType)+" where processInstanceId= ? and workitemId= ?");
                	WFSUtil.DB_SetString(1, processInstanceId, pstmt, dbType);
                	pstmt.setInt(2, workitemId);
                	if(queryTimeout <= 0)
              			pstmt.setQueryTimeout(60);
                	else
              			pstmt.setQueryTimeout(queryTimeout);
                	pstmt.execute();
                	rs = pstmt.getResultSet();
                	if(rs.next()){
                		tmpProcessDefID=rs.getInt(1);
                	}
            	}
            	
            	if(rs!=null){
        			rs.close();
        			rs=null;
        		}
        		if(pstmt!=null){
        			pstmt.close();
        			pstmt=null;
        		}
            	if(tmpProcessDefID!=0){
            		wfProcess = wfRuleEngine.getProcessInfo(tmpProcessDefID, engine);
            		if(wfProcess!=null){
            			externalTableName=wfProcess.getExternalTable();
            			historyTableName=wfProcess.getExternalHistoryTable();
            		}
            	}else{
            		WFSUtil.printOut("ProcessdefId=0 for processInstanceID:"+processInstanceId+" WorkitemID:"+workitemId);
            	}
            }
            
            //Handling of Set Filter/Advance Search on Queue for Prev- Next:
            String targetCabinetNameForaudit = WFSUtil.getTargetCabinetName(con);
			boolean tarHistoryLog= WFSUtil.checkIfHistoryLoggingOnTarget(targetCabinetName);
            String filterStr = "";
            if(dynamicQueueFlag){
                filterStr = " AND Q_UserId =" + userId + " AND assignmentType = 'S' ";
                //cstmt.setString(11, filterStr);
            }else {
                if (queueId == 0)
					filterStr = "AND (Q_UserId = " + userId + " ) and ActivityType != 32 ";
                filterStr = filterStr + WFSUtil.getFilterDoubleQuoteCase(parser, con, dbType);
                if((queueId == 0))
                    filterStr = filterStr + " and assignmentType != 'S' ";
                //cstmt.setString(11, filterStr);
            }
            WFSUtil.printOut(engine,"[WFGetWorktiemDataExt]filterStr>>"+filterStr);  
            
            if(activityType==WFSConstant.ACT_CASE || taskId>0){
            	isCaseActivity=   true;
            }
            if(taskId>0){
            	//Returning errors WF_TASK_ALREADY_COMPLETED and WF_TASK_ALREADY_REVOKED in case a task is opened for an already completed /revoked task.
            	java.util.Date validTill = null;
            	java.util.Date currentDate = new Date();
            	pstmt=con.prepareStatement("Select ReadFlag,TaskStatus,a.ValidTill from WFTaskStatusTable a inner join WFInstrumentTable b on a.processinstanceid = b.processinstanceid and a.workitemid = b.workitemid and a.activityid =b.activityid where a.processinstanceid = ? and a.workitemid =?  and a.taskid=? and a.subtaskid =? and a.AssignedTo = ? ");
            	WFSUtil.DB_SetString(1, processInstanceId, pstmt, dbType);
            	pstmt.setInt(2,workitemId);
            	pstmt.setInt(3, taskId);
            	pstmt.setInt(4, subTaskId);
            	WFSUtil.DB_SetString(5, participant.getname(),pstmt,dbType);
            	if(queryTimeout <= 0)
          			pstmt.setQueryTimeout(60);
                else
          			pstmt.setQueryTimeout(queryTimeout);
            	rs = pstmt.executeQuery();
            	if(rs.next()){
            		taskStatus=rs.getInt("TaskStatus");
            		readFlag=rs.getString("ReadFlag");
            		validTill=rs.getTimestamp("ValidTill");
            	}
            	else {
            		taskStatus=WFSConstant.WF_CASE_SUBMITTED;
            	}
            	    if(taskStatus == WFSConstant.WF_CASE_SUBMITTED) {
            	    	mainCode=WFSError.WF_CASE_SUBMITTED;
            			throwError = true;
            	    }
            	    	
            		if((validTill!=null)&&validTill.compareTo(currentDate) < 0){
            			mainCode=WFSError.WF_TASK_ALREADY_EXPIRED;
            			throwError = true;
            		}
            		
    				if(rs!=null){
                    	rs.close();
                    	rs=null;
                    }
                    if(pstmt!=null){
                    	pstmt.close();
                    	pstmt=null;
                    }
                    if(throwError){
                    	subCode = 0;
        				subject = "The case has been already submitted.";
        				descr = WFSErrorMsg.getMessage(subCode);
        				errType = WFSError.WF_TMP;
    				String strReturn = WFSUtil.generalError(option, engine, gen,
    	   	                   mainCode, subCode,
    	   	                   errType, subject,
    	   	                    descr, inputParamInfo.toString());
    				return strReturn;	
                    }
            	}
            
            /**
			 * Changed by: Mohnish Chopra
			 * Change Description : Return Error if workitem has expired.
			 * 
			 */
			if(WFSUtil.isWorkItemExpired(con, dbType, processInstanceId, workitemId, sessionID, userId, debugFlag, engine)){
				/*
                throw new WFSException(mainCode, subCode, errType, subject, descr);
            */
				    mainCode = WFSError.WF_OPERATION_FAILED;
		            subCode = WFSError.WM_WORKITEM_EXPIRED;
		            subject = WFSErrorMsg.getMessage(mainCode);
		            errType = WFSError.WF_TMP;
		            descr = WFSErrorMsg.getMessage(subCode);
		            String strReturn = WFSUtil.generalError(option, engine, gen,
	   	                   mainCode, subCode,
	   	                   errType, subject,
	   	                    descr, inputParamInfo.toString());
	   	             
	   	        return strReturn;	
            
			}
            if ((tempPreferenceList == " ") || (tempPreferenceList.equals(" "))) {
                objectPreferenceList = "'W','D'";
            } else {
                // Case single value passed,eg:- W
                if (tempPreferenceList.indexOf(",") == -1) {
                    objectPreferenceList =WFSUtil.TO_STRING(tempPreferenceList, true, dbType);
                } else { // If multiple values passed eg:- W,D,Q
                    while ((pos = tempPreferenceList.indexOf(",")) != -1) {
                        if (counter == 0) {
                            tempStr = WFSUtil.TO_STRING(tempPreferenceList.substring(0, pos), true, dbType);
                        } else {
                            tempStr = tempStr +"," +  WFSUtil.TO_STRING(tempPreferenceList.substring(0, pos), true, dbType);
                        }
                        tempPreferenceList = tempPreferenceList.substring(pos + 1);
                        counter++;

                    }
                    if (tempPreferenceList.length() != -1) {
                        tempStr = tempStr + "," + WFSUtil.TO_STRING(tempPreferenceList, true, dbType);
                    }

                    objectPreferenceList = tempStr;
                }
            }

            /* End Sr No. 2 */
            //String documentOrderBy = parser.getValueOf("DocOrderBy", "Name", true); //Sr No. 1
			String documentOrderBy = parser.getValueOf("DocOrderBy", "5", true); //Sr No. 1
            if(documentOrderBy.length() > 2) {
				if(documentOrderBy.trim().equalsIgnoreCase("Index")){
					documentOrderBy = "1";
				}
				else if(documentOrderBy.trim().equalsIgnoreCase("Object Name")){
					documentOrderBy = "2";
				}
				else if(documentOrderBy.trim().equalsIgnoreCase("Owner")){
					documentOrderBy = "3";
				}
				else if(documentOrderBy.trim().equalsIgnoreCase("RevisedDateTime")){
					documentOrderBy = "5";
				}
				else if(documentOrderBy.trim().equalsIgnoreCase("CreatedByAppName")){
					documentOrderBy = "9";
				}
				else if(documentOrderBy.trim().equalsIgnoreCase("NoOfPages")){
					documentOrderBy = "10";
				}
				else if(documentOrderBy.trim().equalsIgnoreCase("DocumentSize")){
					documentOrderBy = "11";
				}
				else if(documentOrderBy.trim().equalsIgnoreCase("DocOrderNo")){
					documentOrderBy = "18";
				}
				else{
					documentOrderBy = "5";
				}
			}
            String documentSortOrder = parser.getValueOf("DocSortOrder", "A", true); //Sr No. 1
            HashMap attribMapQ = new HashMap();
            HashMap attribMapE = new HashMap();
            StringBuffer wiXML = new StringBuffer(50);
            StringBuffer tempXML = new StringBuffer(50);
            String lockFlag = null;
            String isIndex = null;
            String columnName = null;
            String columnValue = null;
            int colType = 0;
            int processDefId = 0;
            int activityId = 0;
            int userIndex = 0;
            int count = 0;
            int processVariantId = 0;//Process Variant Support
            if (documentSortOrder.equalsIgnoreCase("A")) {
                documentSortOrder = "ASC";
            } else if ((documentSortOrder.equalsIgnoreCase("D"))) {
                documentSortOrder = "DESC";
            }
            
            int indx = processInstanceId.indexOf(" ");
            if(indx > -1)
                processInstanceId = processInstanceId.substring(0, indx);
            /* Prepare call for WFGetWorkitem - to lock the workitem */
            //WFS_5_080
			//Bug #815
            //Mohnish Chopra : Changed for Support in Archival
            if(ArchiveSearch!=null && ArchiveSearch.equalsIgnoreCase("Y")) {
                docListOptionFlag="N";
                rs2=getWIData(tarConn,processInstanceId,workitemId,dbType,engine);
                if(rs2.next()) {
                    processDefId=rs2.getInt("processDefId");
                }
            }
            if (dbType == JTSConstant.JTS_POSTGRES) {
                if(ArchiveSearch!=null && ArchiveSearch.equalsIgnoreCase("Y")) {
                    cstmt = con.prepareCall("{call WFGetExportedWorkitem(?, ?, ?, ?, ?, ?, ?, ?, ?)}");
                }else{
                    queryCallable = "{call WFGetWorkitem(?, ?, ?, ?, ?, ?, ?, ?, ?,?,?,?,?,?,?,?,?,?)}";
                    cstmt = con.prepareCall(queryCallable);
                }
                con.setAutoCommit(false);
            } 
           else if (dbType == JTSConstant.JTS_ORACLE) {
            	 if(ArchiveSearch!=null && ArchiveSearch.equalsIgnoreCase("Y")) {
                     cstmt = con.prepareCall("{call WFGetExportedWorkitem(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)}");
                 }
            	 else{
                queryCallable = "{call WFGetWorkitem(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,?,?,?,?,?,?,?,?,?,?,?)}";
                cstmt = con.prepareCall(queryCallable);
            	 }
            //WFS_5_080
            } else  if (dbType == JTSConstant.JTS_MSSQL) {
                if(ArchiveSearch!=null && ArchiveSearch.equalsIgnoreCase("Y")) {
                    cstmt = con.prepareCall("{call WFGetExportedWorkitem(?, ?, ?, ?, ?, ?, ?, ?, ? , ? , ?, ?,?)}");
                }
                else{
                queryCallable = "{call WFGetWorkitem(?, ?, ?, ?, ?, ?, ?, ?, ? , ? , ?, ?,?,?,?,?,?,?)}";
                cstmt = con.prepareCall(queryCallable);
                }
            } 

            cstmt.setInt(1, sessionID);
            cstmt.setString(2, processInstanceId);
            cstmt.setInt(3, workitemId);
            cstmt.setInt(4, queueId);
            cstmt.setString(5, queueType);
            cstmt.setString(6, lastProcessInstance);
            if(ArchiveSearch!=null && ArchiveSearch.equalsIgnoreCase("Y")){
                cstmt.setInt(7, processDefId);
            }
             else{
            cstmt.setInt(7, lastWorkitem);
             }
            HashMap actionMap = (HashMap) CachedActionObject.getReference().getCacheObject(con, engine);
            HashMap actionIDMap = (HashMap) actionMap.get(new Integer(0));
            if (actionIDMap.containsKey(new Integer(WFSConstant.WFL_WorkStarted))) {
                cstmt.setString(8, generateLog + ",Y");
            } else {
                cstmt.setString(8, generateLog + ",N");
            }

            //WFS_5_080
            if (dbType == JTSConstant.JTS_ORACLE) {
				cstmt.setString(9, assignMe);
                cstmt.registerOutParameter(10, java.sql.Types.INTEGER);
                cstmt.registerOutParameter(11, java.sql.Types.VARCHAR);
                cstmt.registerOutParameter(12, oracle.jdbc.OracleTypes.CURSOR);
                if(ArchiveSearch.equalsIgnoreCase("N")){
                	cstmt.setInt(13, taskId);
                         cstmt.setString(14, utilityFlag);
                         cstmt.setInt(15, orderBy);
                        cstmt.setString(16, sortOrder);
                        cstmt.setString(17, lastValue);
                        cstmt.setString(18, clientOrderFlag);
                        cstmt.setString(19, filterStr);
                        cstmt.setString(20, externalTableName);
                        cstmt.setString(21, historyTableName);
                        if(!tarHistoryLog)
                    		cstmt.setString(22, "N");
                    	else
                    		cstmt.setString(22, "Y");
                    	cstmt.setString(23, targetCabinetNameForaudit);
                }
            } else if(dbType == JTSConstant.JTS_POSTGRES){
                    cstmt.setString(9, assignMe);
                    if(ArchiveSearch!=null && ArchiveSearch.equalsIgnoreCase("N")){ 
                       cstmt.setInt(10, taskId);
                    }
                    cstmt.setString(11, utilityFlag);
                    cstmt.setInt(12, orderBy);
                    cstmt.setString(13, sortOrder);
                     if(lastValue.equals("")){
                        cstmt.setNull(14, java.sql.Types.VARCHAR);
                     }else{
                        cstmt.setString(14, lastValue);
                     }
                    cstmt.setString(15, ClientOrderFlag);
                    cstmt.setString(16,filterStr);
                    cstmt.setString(17, externalTableName);
                    cstmt.setString(18, historyTableName);
           }
            //Bug #815
             if (dbType == JTSConstant.JTS_MSSQL) {
				if ( !lastProcessInstance.equals("") ) {
					cstmt.setInt(9, orderBy);
					cstmt.setString(10, sortOrder);
					if (lastValue.equals("")) {
						cstmt.setNull(11, java.sql.Types.VARCHAR);
					} else {
						cstmt.setString(11, lastValue);
					}
				} else {
					cstmt.setNull(9, java.sql.Types.INTEGER);
					cstmt.setNull(10, java.sql.Types.VARCHAR);
					cstmt.setNull(11, java.sql.Types.VARCHAR);
				}
				cstmt.setString(12, assignMe);
				cstmt.setString(13, ClientOrderFlag);
				if(ArchiveSearch!=null && ArchiveSearch.equalsIgnoreCase("N")) {
				cstmt.setInt(14,taskId);
                                cstmt.setString(15, utilityFlag);
                                cstmt.setString(16, filterStr);
                                cstmt.setString(17, externalTableName);
                                cstmt.setString(18, historyTableName);
				}
			 }			 
            //WFS_5_080
             WFSUtil.jdbcCallableExecute(cstmt, engine, queryCallable);
            //cstmt.execute();
            //WFS_5_080
            /* ResultSet 1 -> MainCode and LockFlag */
            if (dbType == JTSConstant.JTS_MSSQL || dbType == JTSConstant.JTS_POSTGRES) {
                rs = cstmt.getResultSet();
            }

            if ((dbType == JTSConstant.JTS_MSSQL && rs != null && rs.next()) || dbType == JTSConstant.JTS_ORACLE) {
                if (dbType == JTSConstant.JTS_ORACLE) {
                    mainCode = cstmt.getInt(10);
                    lockFlag = cstmt.getString(11);
                    if(mainCode==0 && ArchiveSearch!=null && ArchiveSearch.equalsIgnoreCase("Y")) {
                        userIndex=rs.getInt("UserIndex");
                    }
                } else {
                    mainCode = rs.getInt("MainCode");
                    lockFlag = rs.getString("LockFlag");
                    rs.close();
                    rs = null;
                }
                if(taskStatus==WFSConstant.WF_TaskCompleted || taskStatus==WFSConstant.WF_TaskRevoked){
        			mainCode=WFSError.WM_LOCKED;
                }
            } else if (dbType == JTSConstant.JTS_POSTGRES) {
                if (rs != null && rs.next()) {
                    stmt = con.createStatement();
                    String name = rs.getString(1);
                    rs.close();
                    rs = stmt.executeQuery("Fetch All In \"" + TO_SANITIZE_STRING(name, true) + "\"");
                    if (rs != null && rs.next()) {
                        mainCode = rs.getInt("MainCode");
                        lockFlag = rs.getString("LockFlag");
                    }
                    if(ArchiveSearch.equalsIgnoreCase("Y")) {
                        userIndex=rs.getInt("UserIndex");
                        activityId = rs.getInt("ActivityId");
                    }
                }
                if(taskStatus==WFSConstant.WF_TaskCompleted || taskStatus==WFSConstant.WF_TaskRevoked){
        			mainCode=WFSError.WM_LOCKED;
        		}
            } else {
                /* This should never be the case */
                if (rs != null) {
                    rs.close();
                    rs = null;
                }
                mainCode = WFSError.WF_OPERATION_FAILED;
                subCode = WFSError.WFS_FATAL;
            }
            if(ArchiveSearch!=null && ArchiveSearch.equalsIgnoreCase("Y")) {
                if(rs2!=null) {
                    rs2.close();
                    rs2=null;
                }
                rs2=getWIData(tarConn,processInstanceId,workitemId,dbType,engine);
      }

            //WFS_5_080
            if (mainCode == 0 || mainCode == WFSError.WM_LOCKED ||mainCode == WFSError.WM_BYPASS_LOCK) { /* changed for query workstep feature*/
                /* ResultSet 2 -> Workitem related data */
                // WFS_5_080
                if (dbType == JTSConstant.JTS_MSSQL && cstmt.getMoreResults() == true) {
                    rs = cstmt.getResultSet();
                } else if (!ArchiveSearch.equalsIgnoreCase("Y") && dbType == JTSConstant.JTS_ORACLE) {
                    rs = (ResultSet) cstmt.getObject(12);
                }
                if (dbType == JTSConstant.JTS_ORACLE || dbType == JTSConstant.JTS_MSSQL) {
                    if (rs != null) {
                        rs.next();
                    }
                }
                if(ArchiveSearch!=null && ArchiveSearch.equalsIgnoreCase("Y")) {
                    if (rs2 != null && rs2.next()) {
                        if(!ArchiveSearch.equalsIgnoreCase("Y")) {
                             userIndex = rs2.getInt("UserIndex");
                        }
                        wiXML.append("<Workitem>");
                        if(ArchiveSearch!=null && ArchiveSearch.equalsIgnoreCase("Y")) {
                            wiXML.append(gen.writeValueOf("CurrentDateTime", ""));
                        }
                        else{
                        	wiXML.append(gen.writeValueOf("CurrentDateTime", ""));
                        }
                        attribMapQ.put("CURRENTDATETIME", WFSUtil.getDate(dbType));
                        processInstanceId = rs2.getString("ProcessInstanceId");
                        attribMapQ.put("WORKITEMNAME", processInstanceId);
                        
                        attribMapQ.put("PROCESSINSTANCEID", processInstanceId);
                        wiXML.append(gen.writeValueOf("ProcessInstanceId", processInstanceId));
                        workitemId = rs2.getInt("WorkitemId");
                        
                        wiXML.append(gen.writeValueOf("WorkitemId", String.valueOf(workitemId)));
                        wiXML.append(gen.writeValueOf("ProcessName", rs2.getString("ProcessName")));
                        wiXML.append(gen.writeValueOf("ProcessVersion", String.valueOf(rs2.getInt("ProcessVersion")))); /* Not in Doc*/
                        processDefId = rs2.getInt("ProcessDefID");
                        wiXML.append(gen.writeValueOf("ProcessDefId", String.valueOf(processDefId)));
                        wiXML.append(gen.writeValueOf("ProcessedBy", rs2.getString("ProcessedBy")));
                        attribMapQ.put("PROCESSEDBY", rs2.getString("ProcessedBy"));
                        wiXML.append(gen.writeValueOf("ActivityName", rs2.getString("ActivityName")));
                        attribMapQ.put("ACTIVITYNAME", rs2.getString("ActivityName"));
                        HashMap<String,Integer> queryPreviewMap=getQueryPreview(con,processDefId,userId);
                        if((Integer)queryPreviewMap.get("QueryPreview")>0){
                        	int queryActivityId=(Integer)queryPreviewMap.get("ActivityId");
	                        if(queryActivityId!=activityId){
	                        	activityId=queryActivityId;//Incase Query Workstep is present we should pass QueryWorkstep activityId(Archival Case)
	                        }
                        }else{
                        	activityId = rs2.getInt("ActivityId");
                        }
                        
                        wiXML.append(gen.writeValueOf("ActivityId", String.valueOf(activityId)));
                        attribMapQ.put("ACTIVITYID", String.valueOf(activityId));
                        wiXML.append(gen.writeValueOf("EntryDateTime", rs2.getString("EntryDateTime")));
                        attribMapQ.put("ENTRYDATETIME", rs2.getString("EntryDateTime"));
                        wiXML.append(gen.writeValueOf("AssignmentType", rs2.getString("AssignmentType")));
                        attribMapQ.put("ASSIGNMENTTYPE", rs2.getString("AssignmentType"));
                        wiXML.append(gen.writeValueOf("PriorityLevel", rs2.getString("PriorityLevel")));
                        attribMapQ.put("PRIORITYLEVEL", rs2.getString("PriorityLevel")); /* Required in attribute map also. */
                        wiXML.append(gen.writeValueOf("ValidTill", rs2.getString("ValidTill")));
                        attribMapQ.put("VALIDTILLDATETIME", rs2.getString("ValidTill"));
                        wiXML.append(gen.writeValueOf("QueueId", String.valueOf(rs2.getInt("Q_QueueId"))));
                        wiXML.append(gen.writeValueOf("AssignedTo", rs2.getString("AssignedUser")));
                        attribMapQ.put("CREATEDDATETIME", rs2.getString("CreatedDateTime"));
                        wiXML.append(gen.writeValueOf("WorkitemStateId", String.valueOf(rs2.getInt("WorkItemState"))));
                        wiXML.append(gen.writeValueOf("WorkitemState", rs2.getString("StateName")));
                        attribMapQ.put("WORKITEMSTATE", rs2.getString("StateName"));
                        attribMapQ.put("PREVIOUSSTAGE", rs2.getString("PreviousStage"));
                        attribMapQ.put("LOCKEDBYNAME", rs2.getString("LockedByName"));
                        wiXML.append(gen.writeValueOf("LockStatus", rs2.getString("LockStatus")));
                        attribMapQ.put("LOCKSTATUS", rs2.getString("LockStatus"));
                        wiXML.append(gen.writeValueOf("LockedTime", rs2.getString("LockedTime")));
                        attribMapQ.put("LOCKEDTIME", rs2.getString("LockedTime"));
                        wiXML.append(gen.writeValueOf("QueueName", rs2.getString("QueueName")));
                        wiXML.append(gen.writeValueOf("QueueType", rs2.getString("QueueType")));
                                            //Bug #815
                        if (dbType==JTSConstant.JTS_MSSQL && ArchiveSearch.equalsIgnoreCase("N")) {
                                sortedOn = rs2.getString("SortedOn");
                                if (sortedOn != null && !sortedOn.trim().equals(""))
                                    wiXML.append(gen.writeValueOf("LastValue", sortedOn));
                        }
                        if (dbType == JTSConstant.JTS_POSTGRES) {
                            rs2.getString("TableName");
                            if (!rs2.wasNull()) {
                                queryQueueHistoryTable = true;
                            }
                            con.commit();
                        }
                        if(rs2!=null) {
                            rs2.close();
                            rs2 = null;
                        }
                    } else {
                        /* This should never be the case */
                        if(rs2!=null) {
                            rs2.close();
                            rs2 = null;
                        }
                        mainCode = WFSError.WF_OPERATION_FAILED;
                        subCode = WFSError.WFS_FATAL;
                    }
                }
                 else {
                // WFS_5_080
                if (rs != null) {
                    userIndex = rs.getInt("UserIndex");
                    wiXML.append("<Workitem>");
                    wiXML.append(gen.writeValueOf("CurrentDateTime", rs.getString("CurrentDateTime")));
                    attribMapQ.put("CURRENTDATETIME", rs.getString("CurrentDateTime"));
                    processInstanceId = rs.getString("ProcessInstanceId");
                    attribMapQ.put("WORKITEMNAME", processInstanceId);
                    
                    attribMapQ.put("PROCESSINSTANCEID", processInstanceId);
                    wiXML.append(gen.writeValueOf("ProcessInstanceId", processInstanceId));
                    workitemId = rs.getInt("WorkitemId");
                    
                    wiXML.append(gen.writeValueOf("WorkitemId", String.valueOf(workitemId)));
                    wiXML.append(gen.writeValueOf("ProcessName", rs.getString("ProcessName")));
                    wiXML.append(gen.writeValueOf("ProcessVersion", String.valueOf(rs.getInt("ProcessVersion")))); /* Not in Doc*/
                    processDefId = rs.getInt("ProcessDefID");
                    wiXML.append(gen.writeValueOf("ProcessDefId", String.valueOf(processDefId)));
                    wiXML.append(gen.writeValueOf("ProcessedBy", rs.getString("ProcessedBy")));
                    attribMapQ.put("PROCESSEDBY", rs.getString("ProcessedBy"));
                    wiXML.append(gen.writeValueOf("ActivityName", rs.getString("ActivityName")));
                    attribMapQ.put("ACTIVITYNAME", rs.getString("ActivityName"));
                    activityId = rs.getInt("ActivityId");
                    wiXML.append(gen.writeValueOf("ActivityId", String.valueOf(activityId)));
                    attribMapQ.put("ACTIVITYID", String.valueOf(activityId));
                    wiXML.append(gen.writeValueOf("EntryDateTime", rs.getString("EntryDateTime")));
                    attribMapQ.put("ENTRYDATETIME", rs.getString("EntryDateTime"));
                    wiXML.append(gen.writeValueOf("AssignmentType", rs.getString("AssignmentType")));
                    attribMapQ.put("ASSIGNMENTTYPE", rs.getString("AssignmentType"));
                    wiXML.append(gen.writeValueOf("PriorityLevel", rs.getString("PriorityLevel")));
                    attribMapQ.put("PRIORITYLEVEL", rs.getString("PriorityLevel")); /* Required in attribute map also. */
                    wiXML.append(gen.writeValueOf("ValidTill", rs.getString("ValidTill")));
                    attribMapQ.put("VALIDTILLDATETIME", rs.getString("ValidTill"));
                    wiXML.append(gen.writeValueOf("QueueId", String.valueOf(rs.getInt("Q_QueueId"))));
                    wiXML.append(gen.writeValueOf("AssignedTo", rs.getString("AssignedUser")));
                    attribMapQ.put("CREATEDDATETIME", rs.getString("CreatedDateTime"));
                    wiXML.append(gen.writeValueOf("WorkitemStateId", String.valueOf(rs.getInt("WorkItemState"))));
                    wiXML.append(gen.writeValueOf("WorkitemState", rs.getString("StateName")));
                    attribMapQ.put("WORKITEMSTATE", rs.getString("StateName"));
                    attribMapQ.put("PREVIOUSSTAGE", rs.getString("PreviousStage"));
                    attribMapQ.put("LOCKEDBYNAME", rs.getString("LockedByName"));
                    wiXML.append(gen.writeValueOf("LockStatus", rs.getString("LockStatus")));
                    attribMapQ.put("LOCKSTATUS", rs.getString("LockStatus"));
                    wiXML.append(gen.writeValueOf("LockedTime", rs.getString("LockedTime")));
                    attribMapQ.put("LOCKEDTIME", rs.getString("LockedTime"));
                    wiXML.append(gen.writeValueOf("QueueName", rs.getString("QueueName")));
                    wiXML.append(gen.writeValueOf("QueueType", rs.getString("QueueType")));
                    processVariantId = rs.getInt("ProcessVariantId");//Process Variant Support
                    wiXML.append(gen.writeValueOf("VariantId", String.valueOf(processVariantId)));
                    if(activityType ==32){
                    	if(mainCode == 0){
                    		canInitiate = "Y";
                    		wiXML.append(gen.writeValueOf("CanInitiate", canInitiate));
                    		showCaseVisual  = "Y";
                    		wiXML.append(gen.writeValueOf("ShowCaseVisual", showCaseVisual));
                    	}
                    	else{
                    	canInitiate = rs.getString("CanInitiate");
                    	wiXML.append(gen.writeValueOf("CanInitiate", canInitiate));
                    	showCaseVisual = rs.getString("ShowCaseVisual");
                    	wiXML.append(gen.writeValueOf("ShowCaseVisual", showCaseVisual));
                    	}
                    }
                    wiXML.append(gen.writeValueOf("LastModifiedTime", rs.getString("LastModifiedTime")));
                    wiXML.append(gen.writeValueOf("URN", rs.getString("URN")));
					//Bug #815
                   if (ArchiveSearch.equalsIgnoreCase("N")) {
                        sortedOn = rs.getString("SortedOn");
                        if (sortedOn != null && !sortedOn.trim().equals(""))
                            wiXML.append(gen.writeValueOf("LastValue", sortedOn));
                    }
                    if (dbType == JTSConstant.JTS_POSTGRES) {
//                        rs.getString("TableName");
//                        if (!rs.wasNull()) {
//                            queryQueueHistoryTable = true;
//                        }
                        con.commit();
                        con.setAutoCommit(true);
                    }
                    rs.close();
                    rs = null;
					WFSUtil.printOut(engine,"Workitem XML::"+wiXML);
                } else {
                    /* This should never be the case */
                    if (rs != null) {
                        rs.close();
                        rs = null;
                    }
                    mainCode = WFSError.WF_OPERATION_FAILED;
                    subCode = WFSError.WFS_FATAL;
                }
            }
            }
            // WFS_5_080
            /* This should never be the case */
            // WFS_5_080
			
			WFSUtil.printOut(engine,"MainCode::"+mainCode);
			
            if (mainCode == 0 || mainCode == WFSError.WM_LOCKED||mainCode == WFSError.WM_BYPASS_LOCK) { /* changed for query workstep feature*/
                /* Prepare call for WFGetWorkitem - to get the data for the workitem */
                /* WFS_5_090 */
                if (cstmt != null) {
                    cstmt.close();
                }
                /* Sr No. 1 */
                /* WFS_5_080 */
               // if ((dbType == JTSConstant.JTS_MSSQL)|| (dbType == JTSConstant.JTS_POSTGRES)) {
//                    stmt.close();
//                    stmt = null;
//                    pstmtArray = WFGetWorkItemData(con, dbType, processInstanceId, workitemId, processDefId, activityId, userIndex, objectPreferenceList, queryQueueHistoryTable);
                    //Mohnish Chopra : Changed for Support in Archival
                    if (dbType == JTSConstant.JTS_MSSQL) {
                        if(ArchiveSearch!=null && ArchiveSearch.equalsIgnoreCase("Y")) {
                            cstmt = tarConn.prepareCall("{call WFGetWorkitemData(?, ?, ?, ?, ?, ?, ?, ?, ?,?,?)}");
                        }
                        else {
                        queryCallable = "{call WFGetWorkitemData(?, ?, ?, ?, ?, ?, ?, ?, ?,?,?)}";
                        cstmt = con.prepareCall(queryCallable);
                        }
                    } if (dbType == JTSConstant.JTS_POSTGRES) {
                        con.setAutoCommit(false);
                        if(ArchiveSearch!=null && ArchiveSearch.equalsIgnoreCase("Y")) {
                            cstmt = tarConn.prepareCall("{call WFGetWorkitemData(?, ?, ?, ?, ?, ?, ?, ?, ?,?,?)}");
                        }
                        else {
                            queryCallable = "{call WFGetWorkitemData(?, ?, ?, ?, ?, ?, ?, ?, ?,?,?)}";
                            cstmt = con.prepareCall(queryCallable);
                        }
                    }else if (dbType == JTSConstant.JTS_ORACLE) {
                    	   if(ArchiveSearch!=null && ArchiveSearch.equalsIgnoreCase("Y")) {
                               cstmt = tarConn.prepareCall("{call WFGetWorkitemData(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,?,?,?)}");
                           }
                           else {
                        queryCallable = "{call WFGetWorkitemData(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,?,?,?)}";
                        cstmt = con.prepareCall(queryCallable);

                           }
                    }
                    /* WFS_5_080 */
                    cstmt.setString(1, processInstanceId);
                    cstmt.setInt(2, workitemId);
                    cstmt.setInt(3, processDefId);
                    cstmt.setInt(4, activityId);
                    cstmt.setInt(5, userIndex);
                    cstmt.setString(6, documentOrderBy);
                    cstmt.setString(7, documentSortOrder);
                    cstmt.setString(8, objectPreferenceList);
					cstmt.setString(9, isSharePoint);
                    /* WFS_5_080 */
                    if (dbType == JTSConstant.JTS_ORACLE) {
                        cstmt.registerOutParameter(10, oracle.jdbc.OracleTypes.CURSOR);
                        cstmt.registerOutParameter(11, oracle.jdbc.OracleTypes.CURSOR);
                        cstmt.registerOutParameter(12, oracle.jdbc.OracleTypes.CURSOR);
                        cstmt.registerOutParameter(13, oracle.jdbc.OracleTypes.CURSOR);
                        cstmt.registerOutParameter(14, oracle.jdbc.OracleTypes.CURSOR);
                        cstmt.registerOutParameter(15, oracle.jdbc.OracleTypes.CURSOR);
                        cstmt.registerOutParameter(16, oracle.jdbc.OracleTypes.CURSOR);	
                        cstmt.registerOutParameter(17, oracle.jdbc.OracleTypes.CURSOR);	
                        //New parameters passed for Case Management --Mohnish
        				cstmt.setInt(18, taskId);
        				cstmt.setInt(19, subTaskId);

                    }
                    else{
                        //New parameters passed for Case Management --Mohnish
    					cstmt.setInt(10, taskId);
    					cstmt.setInt(11, subTaskId);

                    }

                    /* WFS_5_080 */
                    //cstmt.execute();
                    WFSUtil.jdbcCallableExecute(cstmt, engine, queryCallable);
               // }
                /* WFS_5_080 */
                if (dbType == JTSConstant.JTS_MSSQL) /* ResultSet 1 -> User' Preferences */ {
                    rs = cstmt.getResultSet();
                } else if (dbType == JTSConstant.JTS_ORACLE) {
                    rs = (ResultSet) cstmt.getObject(10);
                /* WFS_5_080 */
                } else if (dbType == JTSConstant.JTS_POSTGRES) {
                    cursorResultSet = cstmt.getResultSet();
                    stmt.close();
                    stmt = null;
                    stmt = con.createStatement();
                    if(cursorResultSet.next()){
                        String cursorName = cursorResultSet.getString(1);
                        rs = stmt.executeQuery("Fetch All In \"" + TO_SANITIZE_STRING(cursorName, false) + "\"");
                    }   
                }

                count = 0;
                if(!(ArchiveSearch!=null && ArchiveSearch.equalsIgnoreCase("Y"))) {
                while (rs != null && rs.next()) {
                    if (count == 0) {
                        tempXML.append("<Preferences>");
                    }
                    count++;
                    tempXML.append("<Preference>");
                    tempXML.append(gen.writeValueOf("ObjectId", rs.getString(1)));
                    tempXML.append(gen.writeValueOf("ObjectName", rs.getString(2)));
                    tempXML.append(gen.writeValueOf("ObjectType", rs.getString(3)));
                    tempXML.append(gen.writeValueOf("NotifyByEmail", rs.getString(4)));
                    tempXML.append("<Data>");
                    result = WFSUtil.getBIGData(con, rs, "Data", dbType, null);
                    tempXML.append((String) result[0]);
                    tempXML.append("</Data>");
                    tempXML.append("</Preference>");
					WFSUtil.printOut(engine,"</Preferences> tempXML::"+tempXML);
                }
                if (count > 0) {
                    tempXML.append("</Preferences>");
                }
                }
                count = 0;
                if (rs != null) {
                    rs.close();
                    rs = null;
//                    if (dbType == JTSConstant.JTS_POSTGRES) {
//                        pstmtArray[0].close();
//                        pstmtArray[0] = null;
//                    }
                }
                /* WFS_5_080 */
                /* ResultSet 2 -> ProcessInstanceTable */
                if ((dbType == JTSConstant.JTS_MSSQL && cstmt.getMoreResults()) || dbType == JTSConstant.JTS_ORACLE || ((dbType == JTSConstant.JTS_POSTGRES)&&cursorResultSet.next())) {
                    if (dbType == JTSConstant.JTS_ORACLE) {
                        rs = (ResultSet) cstmt.getObject(11);
                    } else if (dbType == JTSConstant.JTS_MSSQL) {
                        rs = cstmt.getResultSet();
                    /* WFS_5_080 */
                    } else if (dbType == JTSConstant.JTS_POSTGRES) {
                        if( stmt!=null){
                            stmt.close();
                            stmt = null;
                        }
                        stmt = con.createStatement();
                        String cursorName = cursorResultSet.getString(1);
                        rs = stmt.executeQuery("Fetch All In \"" + TO_SANITIZE_STRING(cursorName, false) + "\"");
                    }
                    if (rs != null && rs.next()) {
                        attribMapQ.put("CREATEDBYNAME", rs.getString("CreatedByName"));
                        wiXML.append(gen.writeValueOf("IntroducedBy", rs.getString("IntroducedBy")));
                        attribMapQ.put("INTRODUCEDBY", rs.getString("IntroducedBy"));
                        wiXML.append(gen.writeValueOf("IntroductionDateTime", rs.getString("IntroductionDateTime")));
                        attribMapQ.put("INTRODUCTIONDATETIME", rs.getString("IntroductionDateTime"));
                        wiXML.append(gen.writeValueOf("ImageCabName", rs.getString("ImageCabName")));
                        attribMapQ.put("ImageCabName", rs.getString("ImageCabName"));
                    }
                }
                if (rs != null) {
                    rs.close();
                    rs = null;
//                    if (dbType == JTSConstant.JTS_POSTGRES) {
//                        pstmtArray[1].close();
//                        pstmtArray[1] = null;
//                    }
                }
                tempXML.append("<WorkitemData>");
                String folderIndex = "-1";
                /* WFS_5_080 */
                /* ResultSet 3 -> QueueDataTable */
                if ((dbType == JTSConstant.JTS_MSSQL && cstmt.getMoreResults()) || dbType == JTSConstant.JTS_ORACLE || ((dbType == JTSConstant.JTS_POSTGRES)&&cursorResultSet.next())) {
                    if (dbType == JTSConstant.JTS_ORACLE) {
                        rs = (ResultSet) cstmt.getObject(12);
                    } else if (dbType == JTSConstant.JTS_MSSQL) {
                        rs = cstmt.getResultSet();
                    /* WFS_5_080 */
                    } else if (dbType == JTSConstant.JTS_POSTGRES) {
                        if( stmt!=null){
                           stmt.close();
                           stmt = null;
                        }
                        stmt = con.createStatement();
                        String cursorName = cursorResultSet.getString(1);
                        rs = stmt.executeQuery("Fetch All In \"" + TO_SANITIZE_STRING(cursorName, false) + "\"");
                    }
                    if (rs != null && rs.next()) {
                        rsmd = rs.getMetaData();
                        count = rsmd.getColumnCount();
                        wiXML.append(gen.writeValueOf("ReferredBy", rs.getString("ReferredByName")));
                        wiXML.append(gen.writeValueOf("ReferredTo", rs.getString("ReferredTo")));
                        wiXML.append(gen.writeValueOf("CheckListCompleteFlag", rs.getString("CheckListCompleteFlag")));
                        attribMapQ.put("CHECKLISTCOMPLETEFLAG", rs.getString("CheckListCompleteFlag"));
                        attribMapQ.put("HOLDSTATUS", rs.getString("HoldStatus"));
                        wiXML.append(gen.writeValueOf("InstrumentStatus", rs.getString("InstrumentStatus")));
                        attribMapQ.put("INSTRUMENTSTATUS", rs.getString("InstrumentStatus"));
                        attribMapQ.put("SAVESTAGE", rs.getString("SaveStage"));
                        attribMapQ.put("STATUS", rs.getString("Status"));
                        wiXML.append(gen.writeValueOf("ActivityType", String.valueOf(rs.getInt("ActivityType"))));
                        folderIndex = rs.getString("VAR_REC_1");
                        for (int i = 10; i <= count; i++) {
                            columnName = rsmd.getColumnName(i);
                            colType = WFSUtil.JDBCTYPE_TO_WFSTYPE(rsmd.getColumnType(i));
                            if (colType == WFSConstant.WF_FLT) {
                                columnValue = rs.getBigDecimal(columnName) + "";
                                if (rs.wasNull()) {
                                    columnValue = "";
                                }
                            } else {
                                columnValue = rs.getString(columnName);
                            }
                            attribMapQ.put(columnName.toUpperCase(), columnValue);
                        }
						WFSUtil.printOut(engine,"</Workitem> wiXML::"+wiXML);
                    }
		  wiXML.append("</Workitem>");
                }
                if (rs != null) {
                    rs.close();
                    rs = null;
//                    if (dbType == JTSConstant.JTS_POSTGRES) {
//                        pstmtArray[2].close();
//                        pstmtArray[2] = null;
//                    }
                }
                count = 0;

                /* WFS_5_080 */
                /* ResultSet 4 -> Documents */
				if(!sharePointFlag){
					if ((dbType == JTSConstant.JTS_MSSQL && cstmt.getMoreResults()) || dbType == JTSConstant.JTS_ORACLE || ((dbType == JTSConstant.JTS_POSTGRES)&&cursorResultSet.next())) {
						if (ArchiveSearch.equalsIgnoreCase("Y") && dbType == JTSConstant.JTS_ORACLE) {
							rs = (ResultSet) cstmt.getObject(13);
						} else if (ArchiveSearch.equalsIgnoreCase("Y") && dbType == JTSConstant.JTS_MSSQL) {
							rs = cstmt.getResultSet();
						/* WFS_5_080 */
						} else if (ArchiveSearch.equalsIgnoreCase("Y") && dbType == JTSConstant.JTS_POSTGRES) {
                                                        if( stmt!=null){
                                                            stmt.close();
                                                            stmt = null;
                                                         }
                                                        stmt = con.createStatement();
				                        String cursorName = cursorResultSet.getString(1);
				                        rs = stmt.executeQuery("Fetch All In \"" + TO_SANITIZE_STRING(cursorName, false) + "\"");
                                                        
//							varRec1 = (String) attribMapQ.get("VAR_REC_1");
//							varRec2 = (String) attribMapQ.get("VAR_REC_2");
//							query = "Select PDBDocument.DocumentIndex AS DocumentIndex, VersionNumber, Name, Owner, CreatedDateTime, Comment, AppName AS CreatedByApplication, ImageIndex, VolumeId, DocumentType, CheckoutStatus, CheckoutByUser, NoOfPages, DocumentSize, RevisedDateTime From PDBDocument  Inner Join PDBDocumentContent ON PDBDocument.documentIndex = PDBDocumentContent.documentIndex AND parentFolderIndex = " + varRec1 + " AND " + WFSUtil.TO_STRING(varRec2, true, dbType) + " = " +
//									WFSUtil.TO_STRING("F", true, dbType) + " Order By " + documentOrderBy + " " + documentSortOrder;  /* bug 3919*/
//						     if(ArchiveSearch!=null && ArchiveSearch.equalsIgnoreCase("Y")) {
//                                                                 stmt = tarConn.createStatement();
//                                                        }
//                                                     else
//							stmt = con.createStatement();
//                                                     rs = stmt.executeQuery(query);
						}
                                        if (docListOptionFlag.equalsIgnoreCase("Y")) {
                                                        //make a call to NGOGetDocumentListExt
                                                StringBuilder wfGetDocumentListXML  = new StringBuilder();
                                                String wfGetDocumentListResult = "";
                                                wfGetDocumentListXML.append("<?xml version=\"1.0\"?><NGOGetDocumentListExt_Input><Option>NGOGetDocumentListExt</Option>");
                                                wfGetDocumentListXML.append("<CabinetName>" + engine + "</CabinetName>");
                                                wfGetDocumentListXML.append("<UserDBId>" + sessionID  + "</UserDBId>");
                                                wfGetDocumentListXML.append("<FolderIndex>" +  folderIndex  + "</FolderIndex>");
                                                wfGetDocumentListXML.append("<NoOfRecordsToFetch>" +  1000   + "</NoOfRecordsToFetch>");
                                                wfGetDocumentListXML.append("<OrderBy>" +  documentOrderBy   + "</OrderBy>");
                                                wfGetDocumentListXML.append("<SortOrder>" +  documentSortOrder   + "</SortOrder>");
                                                wfGetDocumentListXML.append("<ISDocFlag>" +  isDocFlag   + "</ISDocFlag>");
                                                wfGetDocumentListXML.append("<DataAlsoFlag>" +  dataAlsoFlag   + "</DataAlsoFlag>");                
                                                wfGetDocumentListXML.append("<ClientSite>" +  clientSite   + "</ClientSite>");    
                                                wfGetDocumentListXML.append("</NGOGetDocumentListExt_Input>");   

                                                XMLParser parser1 = new XMLParser(wfGetDocumentListXML.toString());
                                                //call NGOGetDocumentListExt API                                                                         
                                                wfGetDocumentListResult =  WFFindClass.getReference().execute("NGOGetDocumentListExt", engine, con, parser1,gen);
                                                XMLParser resultParser = new XMLParser(wfGetDocumentListResult);
                                                tempXML.append("<Documents>");
                                                tempXML.append(resultParser.getValueOf("Documents"));
                                                tempXML.append("</Documents>");
                                        }
                                    }
					count = 0;
					while (rs != null && rs.next()) {
						if (count == 0) {
							tempXML.append("<Documents>");
						}
						count++;
						tempXML.append("<Document>");
						tempXML.append(gen.writeValueOf("DocumentIndex", String.valueOf(rs.getInt("DocumentIndex"))));
						tempXML.append(gen.writeValueOf("VersionNumber", rs.getString("VersionNumber")));
						tempXML.append(gen.writeValueOf("DocumentName", rs.getString("Name")));
						int iOwnerIndex = rs.getInt("Owner");
						tempXML.append(gen.writeValueOf("OwnerIndex", String.valueOf(iOwnerIndex)));   /*bug 3919*/
						String strOwnerName = "";
						WFUserInfo userInfo = (WFUserInfo) CachedObjectCollection.getReference().getCacheObject(con, engine, 0, WFSConstant.CACHE_CONST_UserCache, "userIndex"+ string21 + iOwnerIndex).getData();
						if (userInfo !=null){
							strOwnerName = userInfo.getUserName();
						} else {
							strOwnerName = null;
						}
						tempXML.append(gen.writeValueOf("OwnerName", strOwnerName));
						tempXML.append(gen.writeValueOf("CreationDateTime", rs.getString("CreatedDateTime")));
						if (dbType == JTSConstant.JTS_MSSQL || dbType == JTSConstant.JTS_POSTGRES) /* WFS_5_104 */ {
							tempXML.append(gen.writeValueOf("Comment", rs.getString("Comment")));
						} else if (dbType == JTSConstant.JTS_ORACLE) {
							tempXML.append(gen.writeValueOf("Comment", rs.getString("Commnt"))); /* WFS_5_104 */
						}

						tempXML.append(gen.writeValueOf("CreatedByAppName", rs.getString("CreatedByApplication")));
						isIndex = String.valueOf(rs.getString("ImageIndex")) + "#" + String.valueOf(rs.getString("VolumeId")) + "#";
						tempXML.append(gen.writeValueOf("ISIndex", isIndex));
						tempXML.append(gen.writeValueOf("DocumentType", rs.getString("DocumentType")));
						String checkOutStatus = rs.getString("CheckoutStatus");
						tempXML.append(gen.writeValueOf("CheckoutStatus", checkOutStatus));
						if (checkOutStatus != null && !checkOutStatus.trim().equalsIgnoreCase("N")) {
							tempXML.append(gen.writeValueOf("CheckoutBy", rs.getString("CheckoutByUser")));
						}
						tempXML.append(gen.writeValueOf("NoOfPages", rs.getString("NoOfPages")));
						tempXML.append(gen.writeValueOf("DocumentSize", rs.getString("DocumentSize"))); /* WFS_5_117 */
						tempXML.append(gen.writeValueOf("RevisedDateTime", rs.getString("RevisedDateTime")));
						tempXML.append("</Document>");
						WFSUtil.printOut(engine,"</Document> tempXML::"+tempXML);
					}
					if (count > 0) {
						tempXML.append("</Documents>");
					}

					count = 0;
					if (rs != null) {
						rs.close();
						rs = null;
						if (dbType == JTSConstant.JTS_POSTGRES) {
							stmt.close();
							stmt = null;
						}
					}			
				} else {
					DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
					Date date = new Date();
					String currentDate = dateFormat.format(date);
					//WFParticipant participant = WFSUtil.WFCheckSession(con, sessionID);
					varRec1 = (String) attribMapQ.get("VAR_REC_1");
					varRec2 = (String) attribMapQ.get("VAR_REC_2");
					//varRec1 = "2D7E7DD5-490B-4508-90CE-EC462DA51309";
					String userName = participant.getname();
					//dmsUserName = "administrator"; 
					//dmsPassword = "system123#";
					//dmsUserName = "bpmdemo";
					//dmsPassword = "Pa$$word";
					WFDMSImpl wfDms = (WFDMSImpl) Class.forName("com.newgen.omni.wf.wfdms.SharePointOperation").newInstance();		
					String sharepointGetDocXml = "<EngineName>"+engine+"</EngineName>"+"<FolderGuid>"+varRec1+"</FolderGuid>"+"<ProcessDefId>"+processDefId+"</ProcessDefId>";		
					WFSUtil.printOut(engine,"sharepointGetDocXml :: "+sharepointGetDocXml);
					XMLParser parser1 = new XMLParser(sharepointGetDocXml);
					String outputXml = wfDms.getDocumentList(parser1, dmsUserName, dmsPass_word);
					parser1.setInputXML(outputXml);
					int startTable = parser1.getStartIndex("Output", 0, 0);
					int deadendTable = parser1.getEndIndex("Output", startTable, 0);
					int noOfAttTable = parser1.getNoOfFields("Document", startTable, deadendTable);
					int endTable = 0;		
					tempXML.append("<Documents>");
					for(int count1 = 0; count1 < noOfAttTable; count1++){
						startTable = parser1.getStartIndex("Document", endTable, 0);
						endTable = parser1.getEndIndex("Document", startTable, 0);
						String docName = parser1.getValueOf("Name",startTable,endTable);
						String id = parser1.getValueOf("ID",startTable,endTable);				
						tempXML.append("<Document>");
						tempXML.append(gen.writeValueOf("DocumentIndex",id));
						tempXML.append(gen.writeValueOf("VersionNumber","1.0"));
						tempXML.append(gen.writeValueOf("DocumentName",docName.substring(0, docName.lastIndexOf("."))));
						tempXML.append(gen.writeValueOf("OwnerIndex","1"));
						tempXML.append(gen.writeValueOf("CreationDateTime",currentDate));
						tempXML.append(gen.writeValueOf("Comment",id));
						String docType = docName.substring(docName.lastIndexOf(".")+1);
						tempXML.append(gen.writeValueOf("CreatedByAppName",docType));
						tempXML.append(gen.writeValueOf("ISIndex","0" + string21 + "0"));
						
						if ((docType.equalsIgnoreCase("tif")) || (docType.equalsIgnoreCase("tiff")) || (docType.equalsIgnoreCase("bmp")) || (docType.equalsIgnoreCase("jpeg")) || (docType.equalsIgnoreCase("jpg")) || (docType.equalsIgnoreCase("jif")) || (docType.equalsIgnoreCase("gif")))
							tempXML.append(gen.writeValueOf("DocumentType", "I"));
						else {
							tempXML.append(gen.writeValueOf("DocumentType", "N"));
						}
						
						//tempXML.append(gen.writeValueOf("DocumentType","N"));
						tempXML.append(gen.writeValueOf("CheckoutStatus","N"));
						tempXML.append(gen.writeValueOf("NoOfPages","1"));
						tempXML.append(gen.writeValueOf("DocumentSize","0"));
						tempXML.append("</Document>");
						
					}
						
					tempXML.append("</Documents>");					
				}
				if(isCaseActivity){
					tempXML.append("<HiddenDocuments>");
					if(taskId==0){
						pstmt = con.prepareStatement("Select DocumentIndex, ISIndex from WFCaseDocStatusTable " +WFSUtil.getTableLockHintStr(dbType) + " "
								+ "where processinstanceid = ? and workitemid = ? and activityid = ? and completestatus = ? ");
						WFSUtil.DB_SetString(1, processInstanceId, pstmt, dbType);
						pstmt.setInt(2, workitemId);
						pstmt.setInt(3,activityId);
						WFSUtil.DB_SetString(4, "N", pstmt, dbType);
						if(queryTimeout <= 0)
		          			pstmt.setQueryTimeout(60);
		                else
		          			pstmt.setQueryTimeout(queryTimeout);
						rs=pstmt.executeQuery();
					}
					else if(taskId>0){
						pstmt = con.prepareStatement("Select DocumentIndex, ISIndex from WFCaseDocStatusTable " +WFSUtil.getTableLockHintStr(dbType) + " "
								+ "where processinstanceid = ? and workitemid = ? and activityid = ? and taskId !=? and completestatus = ? ");
						WFSUtil.DB_SetString(1, processInstanceId, pstmt, dbType);
						pstmt.setInt(2, workitemId);
						pstmt.setInt(3,activityId);
						pstmt.setInt(4,taskId);
						WFSUtil.DB_SetString(5, "N", pstmt, dbType);
						if(queryTimeout <= 0)
		          			pstmt.setQueryTimeout(60);
		                else
		          			pstmt.setQueryTimeout(queryTimeout);
						rs=pstmt.executeQuery();
					}
					while(rs.next()){
						String documentIndex = rs.getString("DocumentIndex");
						isIndex = rs.getString("ISIndex");
						tempXML.append("<Document>");
						tempXML.append(gen.writeValueOf("DocumentIndex",documentIndex));
						tempXML.append(gen.writeValueOf("ISIndex",isIndex));
						tempXML.append("</Document>");
					}
					tempXML.append("</HiddenDocuments>");
					
					if(rs!=null){
						rs.close();
						rs= null;
					}
					if(pstmt!=null){
						pstmt.close();
						pstmt= null;
					}
				}
                tempXML.append("<ExternalData>");
                /* WFS_5_080 */
                /* ResultSet 5 -> ToDo items; NOTE : Code replicated as in WFTODOListClass */
                if ((dbType == JTSConstant.JTS_MSSQL && cstmt.getMoreResults()) || dbType == JTSConstant.JTS_ORACLE || ((dbType == JTSConstant.JTS_POSTGRES)&&cursorResultSet.next())) {
                    if (dbType == JTSConstant.JTS_ORACLE) {
                        rs = (ResultSet) cstmt.getObject(14);
                    } else if (dbType == JTSConstant.JTS_MSSQL) {
                        rs = cstmt.getResultSet();
                    /* WFS_5_080 */
                    } else if (dbType == JTSConstant.JTS_POSTGRES) {
			if(stmt!=null){
                            stmt.close();
                            stmt = null;
                        }    
                        stmt = con.createStatement();
                        String cursorName = cursorResultSet.getString(1);
                        rs = stmt.executeQuery("Fetch All In \"" + TO_SANITIZE_STRING(cursorName, false) + "\"");
                    }
                }
                if (rs != null && rs.next()) {
                    tempXML.append("<ToDoListInterface>");
                    tempXML.append("<Status>");
                    tempXML.append("<ToDoListStats>\n");
                    String todoValues = rs.getString("ToDoValue");
                    // TO Do status is kept in array where space also indicates one todo status so it should not be trimmed
                    todoValues = rs.wasNull() ? "" : todoValues.substring(0,
                            todoValues.indexOf(todoValues.trim()) + todoValues.trim().length());
                    char[] todoStatarr = todoValues.toCharArray();
                    int pickListOff = 0;
                  //  int xmlListOff = 0;
                    //String key = engine.toUpperCase() + "#" + processDefId;

//----------------------------------------------------------------------------
// Changed By				: Saurabh Kamal
// Reason / Cause (Bug No if Any)	: Bugzilla Bug 9216
// Change Description			: Passing the key as "0#N" in place of 0
//----------------------------------------------------------------------------

                    String key = "0" + string21 + "N";
                    HashMap todoListMap = (HashMap) CachedObjectCollection.getReference().getCacheObject(con, engine.toUpperCase(), processDefId, WFSConstant.CACHE_CONST_TodoList, key.trim()).getData();
                    
                    ArrayList toDoIndex = new ArrayList();
                    Collections.addAll(toDoIndex, todoListMap.keySet().toArray());
                    Collections.sort(toDoIndex);
                    int spaceCounter = 0;
                    for (int i = 0; i < todoStatarr.length; i++) {
                        if (todoStatarr[i] != ' ') {
                            switch (todoStatarr[i]) {
                                case '0':
                                    break;
                                case '1':
                                    break;
                                case '2':
                                    tempXML.append("<ToDoListStat>\n");
                                    tempXML.append(gen.writeValueOf("ToDoIndex", String.valueOf(i + 1)));
                                    tempXML.append(gen.writeValueOf("Value", "Yes"));
                                    tempXML.append("</ToDoListStat>\n");
                                    break;
                                case '3':
                                    tempXML.append("<ToDoListStat>\n");
                                    tempXML.append(gen.writeValueOf("ToDoIndex", String.valueOf(i + 1)));
                                    tempXML.append(gen.writeValueOf("Value", "No"));
                                    tempXML.append("</ToDoListStat>\n");
                                    break;
                                case '4':
                                    tempXML.append("<ToDoListStat>\n");
                                    tempXML.append(gen.writeValueOf("ToDoIndex", String.valueOf(i + 1)));
                                    tempXML.append(gen.writeValueOf("Value", "Not Applicable"));
                                    tempXML.append("</ToDoListStat>\n");
                                    break;
                                case '5':
                                    tempXML.append("<ToDoListStat>\n");
                                    tempXML.append(gen.writeValueOf("ToDoIndex", String.valueOf(i + 1)));
                                    tempXML.append(gen.writeValueOf("Value", "Success"));
                                    tempXML.append("</ToDoListStat>\n");
                                    break;
                                case '6':
                                    tempXML.append("<ToDoListStat>\n");
                                    tempXML.append(gen.writeValueOf("ToDoIndex", String.valueOf(i + 1)));
                                    tempXML.append(gen.writeValueOf("Value", "Fail"));
                                    tempXML.append("</ToDoListStat>\n");
                                    break;
                                default: {
                                    pickListOff = (int) todoStatarr[i] - 64;
                                    if (pickListOff > 0) {
                                    	String value = "";
                                        todoValues = (String) todoListMap.get(String.valueOf(i + 1));
                                        
                                        if (todoValues != null && !todoValues.trim().equals("")) {
                                            XMLParser xParser = new XMLParser(todoValues);
                                            XMLParser xTempParser = new XMLParser();
                                            int iPickListDataCount = xParser.getNoOfFields("PickListData");
                                            for (int j = 0; j < iPickListDataCount; j++) {
                                                if (j == 0) {
                                                    xTempParser.setInputXML(xParser.getFirstValueOf("PickListData"));
                                                } else {
                                                    xTempParser.setInputXML(xParser.getNextValueOf("PickListData"));
                                                }
                                                if(xTempParser.getIntOf("PickListId", 0, false) == pickListOff){
                                                    value = xTempParser.getValueOf("PickList");
                                                    break;
                                                }
                                            }
                                        }
                                        tempXML.append("<ToDoListStat>\n");
                                        tempXML.append(gen.writeValueOf("ToDoIndex",String.valueOf(i + 1)));
                                        tempXML.append(gen.writeValueOf("Value", value));
                                        tempXML.append("</ToDoListStat>\n");
                                    }
                                }
                            }
                        }
                        else{
                        	spaceCounter++;
                        }
                    }
                    tempXML.append("</ToDoListStats>\n");
                    tempXML.append("</Status>");
                    tempXML.append("</ToDoListInterface>");
                }
                if (rs != null) {
                    rs.close();
                    rs = null;
//                    if (dbType == JTSConstant.JTS_POSTGRES) {
//                        pstmtArray[3].close();
//                        pstmtArray[3] = null;
//                    }
                }

                /* WFS_5_080 */
                /* ResultSet 6 -> Exceptions; NOTE : Code replicated as in WFExceptionClass */
                count = 0;
                if ((dbType == JTSConstant.JTS_MSSQL && cstmt.getMoreResults()) || dbType == JTSConstant.JTS_ORACLE || ((dbType == JTSConstant.JTS_POSTGRES)&&cursorResultSet.next())) {
                    if (dbType == JTSConstant.JTS_ORACLE) {
                        rs = (ResultSet) cstmt.getObject(15);
                    } else if (dbType == JTSConstant.JTS_MSSQL) {
                        rs = cstmt.getResultSet();
                    } else if (dbType == JTSConstant.JTS_POSTGRES) {
                        if(stmt!=null){
                            stmt.close();
                            stmt = null;
                        } 
                        stmt = con.createStatement();
                        String cursorName = cursorResultSet.getString(1);
                        rs = stmt.executeQuery("Fetch All In \"" + TO_SANITIZE_STRING(cursorName, false) + "\"");    
                    }
                }
                /* WFS_5_080 */

                int exp = 0;
                while (rs != null && rs.next()) {
                    count++;
                    if (count == 1) {
                        tempXML.append("<ExceptionInterface>");
                        tempXML.append("<Status>");
                        tempXML.append("<ExceptionStats>");
                    }
                    if (exp != rs.getInt("ExceptionId")) {
                        if (exp == 0) {
                            /* first occurence of exception */
                            tempXML.append("<ExceptionStat>\n");
                        } else {
                            /* closing tag for previous exception */
                            tempXML.append("</ExceptionHistories>\n");
                            tempXML.append("</ExceptionStat>\n");
                            tempXML.append("<ExceptionStat>\n");
                        }
                        exp = rs.getInt("ExceptionId");
                        tempXML.append(gen.writeValueOf("ExceptionDefIndex", String.valueOf(rs.getInt("ExceptionId"))));
                        //tempXML.append(gen.writeValueOf("Status", (rs.getInt("ActionId") == WFSConstant.WFL_Exception_Raised) ? "R" : "C"));//SrNo-5
                        tempXML.append("<ExceptionHistories>\n");
                    }
                    tempXML.append("<ExceptionHistory>\n");
                    tempXML.append(gen.writeValueOf("ActionIndex", rs.getString("ActionId")));
                    tempXML.append(gen.writeValueOf("ExcpSeqId", rs.getString("ExcpSeqId"))); //SrNo-5
                    tempXML.append(gen.writeValueOf("ActivityName", rs.getString("ActivityName")));
                    tempXML.append(gen.writeValueOf("UserName", rs.getString("UserName")));
                    tempXML.append(gen.writeValueOf("ActionDateTime", rs.getString("ActionDateTime")));
                    tempXML.append(gen.writeValueOf("ExceptionName", rs.getString("ExceptionName")));
                    tempXML.append(gen.writeValueOf("ExceptionComments", WFSUtil.handleSpecialCharInXml(rs.getString("ExceptionComments"))));
                    //tempXML.append(gen.writeValueOf("ExceptionComments", rs.getString("ExceptionComments")));
                    tempXML.append("</ExceptionHistory>\n");
                }
                if (exp != 0) {
                    /* finish up the tags of last exceptionid */
                    tempXML.append("</ExceptionHistories>\n");
                    tempXML.append("</ExceptionStat>\n");
                }
                if (count > 0) {
                    tempXML.append("</ExceptionStats>");
                    tempXML.append("</Status>");
                    tempXML.append("</ExceptionInterface>");
                }
                if (rs != null) {
                    rs.close();
                    rs = null;
//                    if (dbType == JTSConstant.JTS_POSTGRES) {
//                        pstmtArray[4].close();
//                        pstmtArray[4] = null;
//                    }
                }
                count = 0;
                tempXML.append("</ExternalData>");

                /* ResultSet 7 -> All information on Comments */
                if ((dbType == JTSConstant.JTS_MSSQL && cstmt.getMoreResults()) || dbType == JTSConstant.JTS_ORACLE || ((dbType == JTSConstant.JTS_POSTGRES)&&cursorResultSet.next())) {
                    if (dbType == JTSConstant.JTS_ORACLE) {
                        rs = (ResultSet) cstmt.getObject(16);
                    } else if (dbType == JTSConstant.JTS_MSSQL) {
                        rs = cstmt.getResultSet();
                    } else if (dbType == JTSConstant.JTS_POSTGRES) {
                        if(stmt!=null){
                            stmt.close();
                            stmt = null;
                        }
                        stmt = con.createStatement();
                        String cursorName = cursorResultSet.getString(1);
	                rs = stmt.executeQuery("Fetch All In \"" + TO_SANITIZE_STRING(cursorName, false) + "\"");    
                    }
                }
                String userName = null;
				String personalName = null;
				tempXML.append("<CommentData>");
                while (rs != null && rs.next()) {
                    tempXML.append("<CommentInfo>");
                    tempXML.append(gen.writeValueOf("Comment", rs.getString("Comments")));
                    tempXML.append(gen.writeValueOf("CommentBy", rs.getString("CommentsBy")));
                    //tempXML.append(gen.writeValueOf("CommentByName", rs.getString("CommentsByName")));
					userName = rs.getString("CommentsByName");	/*WFS_8.0_039*/
					WFUserInfo userInfo = (WFUserInfo) CachedObjectCollection.getReference().getCacheObject(con, engine, 0, WFSConstant.CACHE_CONST_UserCache, "userName" + string21 + userName).getData();
					if (userInfo !=null){
						personalName = userInfo.getPersonalName();
					} else {
						personalName = null;
					}
    				tempXML.append(gen.writeValueOf("CommentByName", userName));
					tempXML.append(gen.writeValueOf("CommentByPersonalName", personalName));
                    tempXML.append(gen.writeValueOf("CommentTo", rs.getString("CommentsTo")));
                    //tempXML.append(gen.writeValueOf("CommentToName", rs.getString("CommentsToName")));
					userName = rs.getString("CommentsToName");
					userInfo = (WFUserInfo) CachedObjectCollection.getReference().getCacheObject(con, engine, 0, WFSConstant.CACHE_CONST_UserCache, "userName" + string21 + userName).getData();
					if (userInfo !=null){
						personalName = userInfo.getPersonalName();
					} else {
						personalName = null;
					}
					tempXML.append(gen.writeValueOf("CommentToName", userName));
					tempXML.append(gen.writeValueOf("CommentToPersonalName", personalName));
                    tempXML.append(gen.writeValueOf("CommentType", rs.getString("CommentsType")));
                    tempXML.append(gen.writeValueOf("CommentDateTime", rs.getString("ActionDateTime")));
                    tempXML.append(gen.writeValueOf("ActivityName", rs.getString("ActivityName")));
                    tempXML.append("</CommentInfo>");
					WFSUtil.printOut(engine,"</CommentInfo> tempXML::"+tempXML);
                }
                tempXML.append("</CommentData>");
                if (rs != null) {
                    rs.close();
                    rs = null;
//                    if (dbType == JTSConstant.JTS_POSTGRES) {
//                        pstmtArray[5].close();
//                        pstmtArray[5] = null;
//                    }
                }
                /* ResultSet 8 -> External Data, First seven result sets are mandatory but eighth that is data from
                external table is optional */

                /** ResultSet 8 -> This result set is no longer required. -Varun Bhansaly */
                /* WFS_5_080 */
                /*SrNo-12*/
                
                //Changes for Case Management
                /** ResultSet 8 -> For Task specific Data */
                if(taskId>0){
					tempXML.append("<TaskInfo>");
					if ((dbType == JTSConstant.JTS_MSSQL && cstmt.getMoreResults()) || dbType == JTSConstant.JTS_ORACLE ||((dbType == JTSConstant.JTS_POSTGRES)&&cursorResultSet.next())) {
                		if (dbType == JTSConstant.JTS_ORACLE) {
                			rs = (ResultSet) cstmt.getObject(17);
                		} else if (dbType == JTSConstant.JTS_MSSQL) {
                			rs = cstmt.getResultSet();
                		}  else if (dbType == JTSConstant.JTS_POSTGRES) {
                                    if(stmt!=null){
                                        stmt.close();
                                        stmt = null;
                                    } 
                                    stmt = con.createStatement();
                                    String cursorName = cursorResultSet.getString(1);
                                    rs = stmt.executeQuery("Fetch All In \"" + TO_SANITIZE_STRING(cursorName, false) + "\"");    
                                }
                		while(rs.next()){
                			tempXML.append(gen.writeValueOf("InitiatedBy", rs.getString("AssignedBy")));
                			tempXML.append(gen.writeValueOf("InitiatedOn", rs.getString("ActionDateTime")));
                			tempXML.append(gen.writeValueOf("AssignedTo", rs.getString("AssignedTo")));
                			tempXML.append(gen.writeValueOf("DueDate", rs.getString("DueDate")));
                			tempXML.append(gen.writeValueOf("TaskType", rs.getString("TaskType")));
                			tempXML.append(gen.writeValueOf("TaskMode", rs.getString("TaskMode")));
                			tempXML.append(WFSUtil.getSubProcessDetail(con, taskId, processInstanceId, processDefId));
                			/*tempXML.append(gen.writeValueOf("ShowCaseVisual", rs.getString("ShowCaseVisual")));
                			tempXML.append(gen.writeValueOf("CanInitiate", rs.getString("CanInitiate")));*/
                		}
                        tempXML.append("</TaskInfo>");
                	}
                }
                if (rs != null) {
                    rs.close();
                    rs = null;
                }
                 if (dbType == JTSConstant.JTS_POSTGRES ) {
                      con.commit();
                      con.setAutoCommit(true);
                 }
                
                if (userDefVarFlag) {
                    if(ArchiveSearch!=null && ArchiveSearch.equalsIgnoreCase("Y")) {
                        tempXML.append(WFSUtil.fetchAttributesExt(tarConn, processDefId, activityId, processInstanceId, workitemId, "", engine, dbType, gen, "", false, false));
                    }
                    else
                //Process Variant Support
                    if(debugFlag){
                        startTime = System.currentTimeMillis();
                    }
                    tempXML.append(WFSUtil.fetchAttributesExt(con, processDefId, activityId, processInstanceId, workitemId, "", engine, dbType, gen, "", false, false, false,processVariantId,0,0,false,"Y",batchInfo));
                    
                    if(debugFlag){
                        endTime = System.currentTimeMillis();
                        WFSUtil.writeLog("fetchAttributesExt", "[WFGetWorkitemDataExt]_fetchAttributesExt", startTime, endTime, 0, "", "", engine,(endTime-startTime),0, 0);  
                    }
                } else {
                    if (pdaFlag) {
                        if(ArchiveSearch!=null && ArchiveSearch.equalsIgnoreCase("Y")) {
                            tempXML.append(WFPDAUtil.fetchAttributes(tarConn, processDefId, activityId, processInstanceId, workitemId, "", engine, dbType, gen, "", false, false));
                        }
                        else
                        tempXML.append(WFPDAUtil.fetchAttributes(con, processDefId, activityId, processInstanceId, workitemId, "", engine, dbType, gen, "", false, false));
                    } else {
                        if(ArchiveSearch!=null && ArchiveSearch.equalsIgnoreCase("Y")) {
                            tempXML.append(WFSUtil.fetchAttributes(tarConn, processDefId, activityId, processInstanceId, workitemId, "", engine, dbType, gen, "", false, false));
                        }
                        else
                        tempXML.append(WFSUtil.fetchAttributes(con, processDefId, activityId, processInstanceId, workitemId, "", engine, dbType, gen, "", false, false));
                    }

                }
                tempXML.append("</WorkitemData>");
                wiXML.append(tempXML);
				if(reminder) {
					String reminderFound = WFSUtil.getReminderDetails(con, engine, userIndex);
					wiXML.append("<ReminderFlag>"+reminderFound+"</ReminderFlag>");
				}
            }
            outputXML = new StringBuffer(500);

            if (mainCode == 0 || mainCode == WFSError.WM_LOCKED || mainCode == WFSError.WF_NO_AUTHORIZATION||mainCode == WFSError.WM_BYPASS_LOCK) {
                outputXML.append(gen.createOutputFile("WFGetWorkitemDataExt"));
                outputXML.append("<Exception>\n");
                outputXML.append("<MainCode>" + mainCode + "</MainCode>\n");
				if(pdaFlag) {
                	   boolean mobileEnabled  =false;
                	   PreparedStatement pstmt1 = con.prepareStatement("Select MobileEnabled from ActivityTable "+WFSUtil.getTableLockHintStr(dbType) +" "
                               + " where ProcessDefId = ? and ActivityId = ? ");
                       pstmt1.setInt(1, processDefId);
                       pstmt1.setInt(2, activityId);
                       if(queryTimeout <= 0)
                    	   pstmt1.setQueryTimeout(60);
                       else
                    	   pstmt1.setQueryTimeout(queryTimeout);
                       
                       ResultSet rs1 = pstmt1.executeQuery();
                       if(rs1.next()){
                    	   mobileEnabled = "Y".equalsIgnoreCase(rs1.getString(1));
                       }
                       if (pstmt1 != null) {
                           pstmt1.close();
                           pstmt1 = null;
                       }
                       if (rs1 != null) {
                           rs1.close();
                           rs1 = null;
                       }
                       if(!mobileEnabled) {
                    	   mainCode = WFSError.WF_NO_AUTHORIZATION  ;	
                    	   subCode = WFSError.WFS_SYS;
                           subject = WFSErrorMsg.getMessage(mainCode);
                           errType = WFSError.WF_TMP;
                    	   String errorString = WFSUtil.generalError(option, engine, gen,mainCode, subCode,errType, subject,descr, inputParamInfo.toString());
                    	   return errorString;

                       }
                }
                if(mainCode == WFSError.WF_NO_AUTHORIZATION) {
                    subCode = WFSError.WFS_SYS;
                    subject = WFSErrorMsg.getMessage(mainCode);
                    errType = WFSError.WF_TMP;
                    descr = WFSErrorMsg.getMessage(subCode);
                    outputXML.append("<SubErrorCode>" + subCode + "</SubErrorCode>\n");
                    outputXML.append("<TypeOfError>" + errType + "</TypeOfError>\n");
                    outputXML.append("<Subject>" + subject + "</Subject>\n");
                    outputXML.append("<Description>" + descr + "</Description>\n");
                }
                else if(taskId>0){ // update the ReadFlag of a task when it is first opened
                	
                	if (con.getAutoCommit()) {
                        con.setAutoCommit(false);
                	}
                	int res;
                	//Changes done to lock the task (to change the lockstatus flag in WFTaskStatusTable for ReassginTask API)
                	if(readFlag.equalsIgnoreCase("N")){
	                	pstmt = con.prepareStatement("Update WFTASKSTATUSTABLE Set readFlag = ?, LockStatus=? where ProcessInstanceID = ? and WorkItemId=? and ProcessDefId=? and ActivityId=? and TaskId=? and SubTaskId=? ");
	        			pstmt.setString(1,"Y");
	        			pstmt.setString(2,"Y");
	        			WFSUtil.DB_SetString(3, processInstanceId, pstmt, dbType);
	                	pstmt.setInt(4,workitemId);
	        			pstmt.setInt(5,processDefId);
	        			pstmt.setInt(6,activityId);
	        			pstmt.setInt(7,taskId);
	        			pstmt.setInt(8,subTaskId);
                	}else{
	                	pstmt = con.prepareStatement("Update WFTASKSTATUSTABLE Set LockStatus=? where ProcessInstanceID = ? and WorkItemId=? and ProcessDefId=? and ActivityId=? and TaskId=? and SubTaskId=? ");
	        			pstmt.setString(1,"Y");
	        			WFSUtil.DB_SetString(2, processInstanceId, pstmt, dbType);
	                	pstmt.setInt(3,workitemId);
	        			pstmt.setInt(4,processDefId);
	        			pstmt.setInt(5,activityId);
	        			pstmt.setInt(6,taskId);
	        			pstmt.setInt(7,subTaskId);
                	}
                	if(queryTimeout <= 0)
              			pstmt.setQueryTimeout(60);
                	else
              			pstmt.setQueryTimeout(queryTimeout);
        			res=pstmt.executeUpdate();
        			if (!con.getAutoCommit()) {
                        con.commit();
                        con.setAutoCommit(true);
                    }
        			if (pstmt != null) {
        				pstmt.close();
        				pstmt = null;
        			}
                  }
              
                outputXML.append("</Exception>\n");
				outputXML.append("<UserDefVarFlag>"+(userDefVarFlag?"Y":"N")+"</UserDefVarFlag>\n");
                outputXML.append(wiXML);
                outputXML.append("<LockResult>" + lockFlag + "</LockResult>");
                outputXML.append("<CacheTime>");
                outputXML.append(new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.US).format(CachedObjectCollection.getReference().getProcessLastModifiedTime(con, engine, processDefId))); //bug # 1608
                outputXML.append("</CacheTime>");
                outputXML.append(inputParamInfo);
                outputXML.append(gen.closeOutputFile("WFGetWorkitemDataExt"));
            }
            if (mainCode != 0) {
                subject = WFSErrorMsg.getMessage(mainCode);
                if(mainCode == 810)
                {
                    subCode = WFSError.WF_WORKITEM_NOT_PRESENT;
                    descr = WFSErrorMsg.getMessage(subCode);
                }
            }
            /*if (zippedFlag.equalsIgnoreCase("Y")) {
                try {
                    outputXML = new StringBuffer(com.newgen.omni.jts.txn.EncodeDecode.zipString(outputXML.toString(), "WFGetWorkitemDataExt"));
                } catch (Exception ex) {
                    mainCode = WFSError.WF_OPERATION_FAILED;
                    subCode = WFSError.WFS_EXP;
                    subject = WFSErrorMsg.getMessage(mainCode);
                    errType = WFSError.WF_TMP;
                    descr = ex.toString();
                    WFSUtil.printErr(engine,"", ex);
                }
            }*/
        } catch (SQLException e) {
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WM_INVALID_FILTER;
            subCode = WFSError.WFS_SQL;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_FAT;
            descr = WFSErrorMsg.getMessage(subCode);
        } catch (NumberFormatException e) {
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_ILP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch (NullPointerException e) {
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_SYS;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch (WFSException e) {
            WFSUtil.printErr(engine,"", e);
            mainCode = e.getMainErrorCode();
            subCode = e.getSubErrorCode();
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = WFSErrorMsg.getMessage(subCode);
        } catch (JTSException e) {
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = e.getErrorCode();
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.getMessage();
        } catch (Exception e) {
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_EXP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch (Error e) {
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_EXP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } finally {
            try {
                if (rs != null) {
                    rs.close();
                    rs = null;
                }
                if (cursorResultSet != null) {
                    cursorResultSet.close();
                    cursorResultSet= null;
                }
                if(tarConn!=null){
                	if (!tarConn.getAutoCommit()) {
                		tarConn.commit();
                		tarConn.setAutoCommit(true);
                    }
                    NGDBConnection.closeDBConnection(tarConn, strOption);
                    tarConn = null;
                }
            } catch (Exception e) {
            }
            try {
                if (stmt != null) {
                    stmt.close();
                    stmt = null;
                }
            } catch (Exception e) {
            }
            try {
                if (pstmt != null) {
                    pstmt.close();
                    pstmt = null;
                }
            } catch (Exception e) {
            }
            if (pstmtArray != null) {
                for (int i = 0; i < pstmtArray.length; i++) {
                    try {
                        if (pstmtArray[i] != null) {
                            pstmtArray[i].close();
                            pstmtArray[i] = null;
                        }
                    } catch (Exception e) {
                    }
                }
            }
            try {
                if (cstmt != null) {
                    cstmt.close();
                    cstmt = null;
                }
            } catch (Exception e) {
            }
            
        }
        if (!(mainCode == 0 || mainCode == WFSError.WM_LOCKED || mainCode == WFSError.WF_NO_AUTHORIZATION||mainCode == WFSError.WM_BYPASS_LOCK)) {
            //throw new WFSException(mainCode, subCode, errType, subject, descr);
			String errorString = WFSUtil.generalError(option, engine, gen,mainCode, subCode,errType, subject,descr, inputParamInfo.toString());
			return errorString;
        }
        return outputXML.toString();
    }

private HashMap<String, Integer> getQueryPreview(Connection con,int processDefId,
			int userIndex) {
		HashMap<String, Integer> getQueryPreview=new HashMap<String, Integer>();
		getQueryPreview.put("QueryPreview",0);
		ResultSet rs=null;
		PreparedStatement pstmt=null;
		String sql="select Distinct ActivityTable.ActivityId,QUSERGROUPVIEW.QueryPreview	FROM ActivityTable, QueueStreamTable , QUSERGROUPVIEW WHERE ActivityTable.ProcessDefId = QueueStreamTable.ProcessDefId	AND ActivityTable.ActivityId = QueueStreamTable.ActivityId	AND QUSERGROUPVIEW.QueueId = QueueStreamTable.QueueId	AND ActivityTable.ActivityType = 11	AND ActivityTable.ProcessDefId = ? AND QUSERGROUPVIEW.UserId = ?";
		try {
			 pstmt=con.prepareStatement(sql);
			pstmt.setInt(1, processDefId);
			pstmt.setInt(2, userIndex);
			
			 rs=pstmt.executeQuery();
			if(rs.next()){
				getQueryPreview.put("QueryPreview", rs.getString(2).equalsIgnoreCase("Y")?1:0);
				getQueryPreview.put("ActivityId", rs.getInt(1));
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			//e.printStackTrace();
			WFSUtil.printErr("","", e);
		}finally{
			try {
				  if (rs != null){
					  rs.close();
					  rs = null;
				  }
			  }
			  catch(Exception ignored){WFSUtil.printErr("","", ignored);}
				  
			  try {
				  if (pstmt != null){
					  pstmt.close();
					  pstmt = null;
				  }
			  }
			  catch(Exception ignored){WFSUtil.printErr("","", ignored);}
		}
		return getQueryPreview;
	}

//----------------------------------------------------------------------------------------------------
//	Function Name 				:	WFFetchWorkItems
//	Date Written (DD/MM/YYYY)	:	14/05/2007
//	Author						:	Prashant
//	Input Parameters			:	Connection , XMLParser , XMLGenerator
//	Output Parameters			:   none
//	Return Values				:	String
//	Description					:   Fetches the workItems and their details (Uses SP)
//  Change Description          :   Bugzilla Bug 1680
//----------------------------------------------------------------------------------------------------
    public String WFFetchWorkItems(Connection con, XMLParser parser, XMLGenerator gen) throws JTSException, WFSException {
    	StringBuffer outputXML = new StringBuffer("");
        CallableStatement cstmt = null;
        Statement stmt = null;
        ResultSet rs = null;
        int mainCode = 0;
        int subCode = 0;
        int returnCount = 0;
        String subject = null;
        String descr = null;
        String errType = WFSError.WF_TMP;
        int recordsFetched = 0;
        int totalCount = 0;
        int queueid = 0;
        int orderBy = 0;
        int serverBatchSize = 0;
        int noOfRectoFetch = 0;
        int lastWIValue = 0;
        int sessionID = 0;
        int dbType = 0;
        String lastValue = "";
        String lastPIValue = "";
        String sortOrder = "";
        String dataflag = "";
        String fetchLockedFlag = "";
        String ClientOrderFlag = "";
        String returnCountFlag = "";
        String engine = "";
        StringBuffer tempXml = null;
        boolean myQueueFlag = false;
		int processDefId = -1;
		String fetchProcessSpecificAlias = "N";
		int aliasProcessDefId = 0;
		int startingRecordNo = 0;
		boolean reminder = false;
		String optionTag = null;
		boolean printQueryFlag = true;
		PreparedStatement pstmt = null;
        String pagingFlag = null;
		char char21 = 21;
		String string21 = "" + char21;
		Document doc = null;
		boolean stdParserFlag = false;
		ResultSet curResultSet = null;
        String cursorName = "";
        ResultSet rs1 = null;
		boolean dynamicQueueFlag = false;
		String queueType1 = "";
        StringBuilder inputParamInfo = new StringBuilder();
        XMLParser parserTemp= null;
        boolean found = false;
        try {
        	int queryTimeout = WFSUtil.getQueryTimeOut();
            sessionID = parser.getIntOf("SessionId", 0, false);
            engine = parser.getValueOf("EngineName");
            dbType = ServerProperty.getReference().getDBType(engine);
			optionTag = parser.getValueOf("Option");
			dbType = ServerProperty.getReference().getDBType(engine);
            WFParticipant participant = WMUser.WFCheckUpdateSession(con, sessionID, dbType);
            inputParamInfo.append(gen.writeValueOf("SessionId", String.valueOf(sessionID)));
            inputParamInfo.append(gen.writeValueOf("UserName", (participant == null ? "" : participant.getname())));
            //Bug 1531
            String systemAssignedWI = parser.getValueOf("SystemAssignedWI", "N", true);
            int userid = 0;
            String dbCurrentDateTime = WFSUtil.getCurrentDateTimeFromDB(con,engine,dbType);
           /* if (dbType == JTSConstant.JTS_POSTGRES) {
                outputXML = new StringBuffer(WFFetchWorkItems1(con, parser, gen,printQueryFlag));
                return outputXML.toString();
            } else {*/
                queueid = parser.getIntOf("QueueId", 0, true);
                orderBy = parser.getIntOf("OrderBy", 2, true);// By default order by on processinstanceid, workitemid
                //			Added By Varun Bhansaly On 16/05/2007 so that size should not be greater than the entry set in server.xml
                serverBatchSize = ServerProperty.getReference().getBatchSize();
                noOfRectoFetch = parser.getIntOf("NoOfRecordsToFetch", serverBatchSize, true);
                if (noOfRectoFetch > serverBatchSize || noOfRectoFetch <= 0) {
                    noOfRectoFetch = serverBatchSize;
                }
                lastWIValue = parser.getIntOf("LastWorkItem", 0, true);
                lastValue = parser.getValueOf("LastValue", "", true);
                lastPIValue = parser.getValueOf("LastProcessInstance", "", true);
                sortOrder = parser.getValueOf("SortOrder", "A", true);
                dataflag = parser.getValueOf("DataFlag", "N", true);
                fetchLockedFlag = parser.getValueOf("FetchLockedFlag", "N", true); // Bugzilla Bug 1703
                returnCountFlag = parser.getValueOf("ReturnCountFlag", "N", true); /*Bugzilla Bug 1680*/
                myQueueFlag = parser.getValueOf("MyQueueFlag", "N", true).equalsIgnoreCase("Y");
				fetchProcessSpecificAlias = parser.getValueOf("ProcessAlias", "N", true);
				processDefId = parser.getIntOf("ProcessDefId", 0, true);
                ClientOrderFlag = parser.getValueOf("ClientOrderFlag", "N", true);
				startingRecordNo = parser.getIntOf("StartingRecordNo", 0, true);
				reminder = parser.getValueOf("ReminderFlag", "N", true).equalsIgnoreCase("Y");          
                pagingFlag = parser.getValueOf("PagingFlag", "N", true);  
                if(startingRecordNo > 0){     //if page number comes in input xml
					pagingFlag = "Y";
				}
				stdParserFlag = parser.getValueOf("usestdparser", "N", true).equalsIgnoreCase("Y"); 	
				stdParserFlag = false;
                dynamicQueueFlag = parser.getValueOf("DynamicQueueFlag", "Y", true).equalsIgnoreCase("Y");
				queueType1 = parser.getValueOf("QueueType", "", true);
				WFConfigLocator configlocator = null;
				configlocator = WFConfigLocator.getInstance();
				String strConfigFileName = configlocator.getPath(Location.IBPS_CONFIG) + File.separator + WFSConstant.CONST_DIRECTORY_CONFIG + File.separator + WFSConstant.CONST_FILE_WFAPPCONFIGPARAM;
		   	 	parserTemp = new XMLParser(WFSUtil.readFile(strConfigFileName));
		        String QueueTypeForFecthWorklist = parserTemp.getValueOf("QueueTypeForFecthWorklist");
		        String[] QueueTypes = QueueTypeForFecthWorklist.split(",");
		        
               // if (myQueueFlag) {
                    if (participant != null && participant.gettype() == 'U') {
                        userid = participant.getid();
                    }
               // }
                if(queueid > 0) {
                	pstmt = con.prepareStatement("Select QueueType from QueueDefTable " + WFSUtil.getTableLockHintStr(dbType) + "  where queueid = ? ");
    				pstmt.setInt(1,queueid);
    				rs = pstmt.executeQuery();
    				if(rs.next()) {
    						queueType1 = rs.getString("QueueType");
    				}
    				if(rs != null)
    					rs.close();
    				if(pstmt != null)
    					pstmt.close();
                }
                for (String QueueType : QueueTypes) {
		            if (QueueType.equalsIgnoreCase(queueType1)) {
		            	found = true;
		            }
                }
    		    if(found || queueid == 0) {         
                if(dbType == JTSConstant.JTS_POSTGRES){
                	con.setAutoCommit(false);
                }
                if (dbType == JTSConstant.JTS_MSSQL) {
                    cstmt = con.prepareCall("{call WFFetchWorkList(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,?,?,?)}"); // Bugzilla Bug 1703
                } else if (dbType == JTSConstant.JTS_ORACLE) {
                    cstmt = con.prepareCall("{call WFFetchWorkList(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,?,?,?)}"); // Bugzilla Bug 1703
                }else if (dbType == JTSConstant.JTS_POSTGRES){
                     cstmt = con.prepareCall("{call WFFetchWorkList(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,?,?,?)}"); 
                }
            /*}*/
            if(queryTimeout <= 0)
                cstmt.setQueryTimeout(60);
            else
                cstmt.setQueryTimeout(queryTimeout);
            cstmt.setInt(1, sessionID);
            cstmt.setInt(2, queueid);
            cstmt.setString(3, sortOrder);
            cstmt.setInt(4, orderBy);
            cstmt.setInt(5, noOfRectoFetch);
            cstmt.setInt(6, lastWIValue);
            cstmt.setString(7, dataflag);
            cstmt.setString(8, fetchLockedFlag); // Bugzilla Bug 1703
            if (lastPIValue.equals("") || startingRecordNo != 0) //Bugzilla Bug 1765
            {
                cstmt.setNull(9, java.sql.Types.VARCHAR);
            } else {
                cstmt.setString(9, lastPIValue);
            }

            if (lastValue.equals("") || startingRecordNo != 0) //Bugzilla Bug 1765
            {
                cstmt.setNull(10, java.sql.Types.VARCHAR);
            } else {
                cstmt.setString(10, lastValue);
            }
			//Bug 1531
            String filterStr = "";
            filterStr=" AND (assignmentType!='Z' OR (assignmentType='Z' AND  Q_UserId= "+userid+"  ) ) ";
            if (myQueueFlag) {                
				filterStr = "AND (Q_UserId = " + userid + " )";
                if(systemAssignedWI.equalsIgnoreCase("Y"))
                    filterStr = filterStr + " and assignmentType != 'S' ";
                cstmt.setString(11, filterStr);
            }else if(dynamicQueueFlag && queueType1.equalsIgnoreCase("D")){
                filterStr = " AND Q_UserId =" + userid + " AND assignmentType = 'S' ";
                cstmt.setString(11, filterStr);
            }else {
				if (queueid == 0)
					filterStr = "AND (Q_UserId = " + userid  + " ) and ActivityType != 32 ";
                filterStr = filterStr + WFSUtil.getFilterDoubleQuoteCase(parser, con, dbType);
                if((queueid == 0) && systemAssignedWI.equalsIgnoreCase("Y"))
                    filterStr = filterStr + " and assignmentType != 'S' ";
                cstmt.setString(11, filterStr);
            }
            WFSUtil.printOut(engine,"[WFFetchWorkItems]filterStr>>"+filterStr);            
            /*Bugzilla Bug 1680*/
            if (returnCountFlag.startsWith("N")) {
                cstmt.setInt(12, 0);
            } else {
                cstmt.setInt(12, 2);
            }

			if (queueid == 0) {
				cstmt.setString(13, fetchProcessSpecificAlias);
				cstmt.setInt(14, processDefId);
			} else {
				cstmt.setString(13, "N");
				cstmt.setInt(14, 0);
			}
            cstmt.setString(15, ClientOrderFlag);
			cstmt.setInt(16, startingRecordNo);
            if (dbType == JTSConstant.JTS_MSSQL|| dbType == JTSConstant.JTS_POSTGRES) {
                cstmt.setString(17, pagingFlag);
            }
            if (dbType == JTSConstant.JTS_ORACLE) {

                cstmt.registerOutParameter(17, java.sql.Types.INTEGER);
                cstmt.registerOutParameter(18, java.sql.Types.INTEGER);
                cstmt.registerOutParameter(19, java.sql.Types.INTEGER); /*Bugzilla Id 1680*/
				cstmt.registerOutParameter(20, java.sql.Types.INTEGER);
                cstmt.registerOutParameter(21, oracle.jdbc.OracleTypes.CURSOR);
                cstmt.setString(22, pagingFlag);
            }
            
            if(queryTimeout <= 0)
                cstmt.setQueryTimeout(60);
            else
                cstmt.setQueryTimeout(queryTimeout);
            cstmt.execute();
            if (dbType == JTSConstant.JTS_MSSQL) {
                rs = cstmt.getResultSet();
            }
            if ((dbType == JTSConstant.JTS_MSSQL && rs != null && rs.next()) || dbType == JTSConstant.JTS_ORACLE|| dbType == JTSConstant.JTS_POSTGRES) {
                if (dbType == JTSConstant.JTS_ORACLE) {
                    mainCode = cstmt.getInt(17);
                    subCode = cstmt.getInt(18);
                    returnCount = cstmt.getInt(19); /*Bugzilla Id 1680*/
					aliasProcessDefId = cstmt.getInt(20);
                }
                else if(dbType == JTSConstant.JTS_POSTGRES){
                    curResultSet = cstmt.getResultSet();
                    if(curResultSet.next()){
                        stmt = con.createStatement();
                        cursorName = curResultSet.getString(1);
//                        if(rs !=null)
//                            rs.close();
                        
                        rs1 = stmt.executeQuery("Fetch All In \"" + TO_SANITIZE_STRING(cursorName, false) + "\"");
                        if(rs1!=null && rs1.next()){
                        {
                            mainCode = rs1.getInt("MainCode");
                            returnCount = rs1.getInt("ReturnCount");
                            aliasProcessDefId = rs1.getInt("AliasProcessDefId");
                        }
                        if (mainCode == 0) {
                             if(curResultSet.next()){
                                 stmt =  null;
                                 stmt = con.createStatement();
                                 cursorName = curResultSet.getString(1);
                                 if(rs1 !=null)
                                    rs1.close();
                                 rs1 = stmt.executeQuery("Fetch All In \"" + TO_SANITIZE_STRING(cursorName, false) + "\"");
                             }   
                                
                        }
                    }
                    
                }
                
                else {
                    mainCode = rs.getInt("MainCode");
                    returnCount = rs.getInt("ReturnCount");
					if (mainCode == 0) {
						aliasProcessDefId = rs.getInt("AliasProcessDefId");
					}
                    rs.close();
                    rs = null;
                }
            }
                
                else {
                    mainCode = rs.getInt("MainCode");
                    subCode = rs.getInt("SubCode");/*bug 41579, subcode defined*/
                    returnCount = rs.getInt("ReturnCount");
					if (mainCode == 0) {
						aliasProcessDefId = rs.getInt("AliasProcessDefId");
					}
                    rs.close();
                    rs = null;
                }
            } else {
                /* This should never be the case */
                if (rs != null) {
                    rs.close();
                    rs = null;
                }
                mainCode = WFSError.WF_OPERATION_FAILED;
                subCode = WFSError.WFS_FATAL;
                returnCount = 0; /*Bugzilla Bug 1680*/
            }
            inputParamInfo.append(gen.writeValueOf("QueueId", String.valueOf(queueid)));
            if (mainCode == 0) {
                /* ResultSet 2 -> Workitem related data */
                if (dbType == JTSConstant.JTS_MSSQL && cstmt.getMoreResults() == true) {
                    rs = cstmt.getResultSet();
                } else if (dbType == JTSConstant.JTS_ORACLE) {
                    rs = (ResultSet) cstmt.getObject(21); /* Bugzilla Bug 1680*/
                }else if (dbType == JTSConstant.JTS_POSTGRES) {
                    rs = rs1;
                }
                ResultSetMetaData rsmd = null;
                int nRSize = 0;
                if (dataflag.startsWith("Y")) {
                    rsmd = rs.getMetaData();
                    nRSize = rsmd.getColumnCount();
                }
                 
				if(dbType == JTSConstant.JTS_ORACLE && pagingFlag.equalsIgnoreCase("Y"))
					nRSize = nRSize-1;
                tempXml = new StringBuffer();

                int j = 0;
                int tot = 0;
				String personalName = null;
				String familyName = null;
				String userName = null;
				
				
				
				
				if(stdParserFlag){
					doc = WFXMLUtil.createDocument();
					Element instruments = WFXMLUtil.createRootElement(doc, "Instruments");				
					while (j < noOfRectoFetch && rs.next()) {						
						Element instrument = WFXMLUtil.createElement(instruments, doc, "Instrument");					
						Element processInstanceId = WFXMLUtil.createElement(instrument, doc, "ProcessInstanceId");
						processInstanceId.appendChild(doc.createTextNode(WFSUtil.avoidNullValues(rs.getString(1))));							
						Element workItemName = WFXMLUtil.createElement(instrument, doc, "WorkItemName");
						workItemName.appendChild(doc.createTextNode(WFSUtil.avoidNullValues(rs.getString(2))));			
						Element routeId = WFXMLUtil.createElement(instrument, doc, "RouteId");
						routeId.appendChild(doc.createTextNode(WFSUtil.avoidNullValues(rs.getString(3))));					
						Element routeName = WFXMLUtil.createElement(instrument, doc, "RouteName");
						routeName.appendChild(doc.createTextNode(WFSUtil.avoidNullValues(rs.getString(4))));										
						Element workStageId = WFXMLUtil.createElement(instrument, doc, "WorkStageId");
						workStageId.appendChild(doc.createTextNode(WFSUtil.avoidNullValues(rs.getString(5))));									
						Element activityName = WFXMLUtil.createElement(instrument, doc, "ActivityName");
						activityName.appendChild(doc.createTextNode(WFSUtil.avoidNullValues(rs.getString(6))));									
						Element priorityLevel = WFXMLUtil.createElement(instrument, doc, "PriorityLevel");
						priorityLevel.appendChild(doc.createTextNode(WFSUtil.avoidNullValues(rs.getString(7))));						
						Element instrumentStatus = WFXMLUtil.createElement(instrument, doc, "InstrumentStatus");
						instrumentStatus.appendChild(doc.createTextNode(WFSUtil.avoidNullValues(rs.getString(8))));					
						Element lockStatus = WFXMLUtil.createElement(instrument, doc, "LockStatus");
						lockStatus.appendChild(doc.createTextNode(WFSUtil.avoidNullValues(rs.getString(9))));					   
						userName = rs.getString(10);   /*WFS_8.0_039*/
						WFUserInfo userInfo = (WFUserInfo) CachedObjectCollection.getReference().getCacheObject(con, engine, 0, WFSConstant.CACHE_CONST_UserCache, "userName" + string21 + userName).getData();
						if (userInfo!=null){
							personalName = userInfo.getPersonalName();
							familyName = userInfo.getFamilyName();
						}
						else {
							personalName = null;
							familyName = null;
						}
						Element lockedByUserName = WFXMLUtil.createElement(instrument, doc, "LockedByUserName");
						lockedByUserName.appendChild(doc.createTextNode(WFSUtil.avoidNullValues(userName)));										
						Element lockedByPersonalName = WFXMLUtil.createElement(instrument, doc, "LockedByPersonalName");
						lockedByPersonalName.appendChild(doc.createTextNode(WFSUtil.avoidNullValues(personalName)));
						Element lockedByFamilyName = WFXMLUtil.createElement(instrument, doc, "LockedByFamilyName");
						lockedByFamilyName.appendChild(doc.createTextNode(WFSUtil.avoidNullValues(familyName)));
						Element expiryDateTime = WFXMLUtil.createElement(instrument, doc, "ExpiryDateTime");
						expiryDateTime.appendChild(doc.createTextNode(WFSUtil.avoidNullValues(rs.getString(11))));				   
						userName = rs.getString(12);   /*WFS_8.0_039*/
						userInfo = (WFUserInfo) CachedObjectCollection.getReference().getCacheObject(con, engine, 0, WFSConstant.CACHE_CONST_UserCache, "userName" + string21 + userName).getData();
						if (userInfo!=null){
							personalName = userInfo.getPersonalName();
							familyName = userInfo.getFamilyName();
						}
						else {
							personalName = null;
							familyName = null;
						}					
						Element createdByUserName = WFXMLUtil.createElement(instrument, doc, "CreatedByUserName");
						createdByUserName.appendChild(doc.createTextNode(WFSUtil.avoidNullValues(userName)));									
						Element createdByPersonalName = WFXMLUtil.createElement(instrument, doc, "CreatedByPersonalName");
						createdByPersonalName.appendChild(doc.createTextNode(WFSUtil.avoidNullValues(personalName)));
						Element createdByFamilyName = WFXMLUtil.createElement(instrument, doc, "CreatedByFamilyName");
						createdByFamilyName.appendChild(doc.createTextNode(WFSUtil.avoidNullValues(familyName)));
						Element creationDateTime = WFXMLUtil.createElement(instrument, doc, "CreationDateTime");
						creationDateTime.appendChild(doc.createTextNode(WFSUtil.avoidNullValues(rs.getString(13))));								
						Element workitemState = WFXMLUtil.createElement(instrument, doc, "WorkitemState");
						workitemState.appendChild(doc.createTextNode(WFSUtil.avoidNullValues(rs.getString(14))));								
						Element checkListCompleteFlag = WFXMLUtil.createElement(instrument, doc, "CheckListCompleteFlag");
						checkListCompleteFlag.appendChild(doc.createTextNode(WFSUtil.avoidNullValues(rs.getString(15))));						
						Element entryDateTime = WFXMLUtil.createElement(instrument, doc, "EntryDateTime");
						entryDateTime.appendChild(doc.createTextNode(WFSUtil.avoidNullValues(rs.getString(16))));							
						Element lockedTime = WFXMLUtil.createElement(instrument, doc, "LockedTime");
						lockedTime.appendChild(doc.createTextNode(WFSUtil.avoidNullValues(rs.getString(17))));									
						Element introductionDateTime = WFXMLUtil.createElement(instrument, doc, "IntroductionDateTime");
						introductionDateTime.appendChild(doc.createTextNode(WFSUtil.avoidNullValues(rs.getString(18))));						
						userName = rs.getString(19);	/*WFS_8.0_039*/
						userInfo = (WFUserInfo) CachedObjectCollection.getReference().getCacheObject(con, engine, 0, WFSConstant.CACHE_CONST_UserCache, "userName" + string21 + userName).getData();
						if (userInfo!=null){
							personalName = userInfo.getPersonalName();
							familyName = userInfo.getFamilyName();
						}
						else {
							personalName = null;
							familyName = null;
						}					
						Element introducedBy = WFXMLUtil.createElement(instrument, doc, "IntroducedBy");
						introducedBy.appendChild(doc.createTextNode(WFSUtil.avoidNullValues(userName)));											
						Element introducedByPersonalName = WFXMLUtil.createElement(instrument, doc, "IntroducedByPersonalName");
						introducedByPersonalName.appendChild(doc.createTextNode(WFSUtil.avoidNullValues(personalName)));
						Element introducedByFamilyName = WFXMLUtil.createElement(instrument, doc, "IntroducedByFamilyName");
						introducedByFamilyName.appendChild(doc.createTextNode(WFSUtil.avoidNullValues(familyName)));
						userName = rs.getString(20);   /*WFS_8.0_039*/
						userInfo = (WFUserInfo) CachedObjectCollection.getReference().getCacheObject(con, engine, 0, WFSConstant.CACHE_CONST_UserCache, "userName" + string21 + userName).getData();
						if (userInfo!=null){
							personalName = userInfo.getPersonalName();
							familyName = userInfo.getFamilyName();
						}
						else {
							personalName = null;
							familyName = null;
						}						
						Element assignedTo = WFXMLUtil.createElement(instrument, doc, "AssignedTo");
						assignedTo.appendChild(doc.createTextNode(WFSUtil.avoidNullValues(userName)));						
						Element AssignedToPersonalName = WFXMLUtil.createElement(instrument, doc, "AssignedToPersonalName");
						AssignedToPersonalName.appendChild(doc.createTextNode(WFSUtil.avoidNullValues(personalName)));
						Element AssignedToFamilyName = WFXMLUtil.createElement(instrument, doc, "AssignedToFamilyName");
						AssignedToFamilyName.appendChild(doc.createTextNode(WFSUtil.avoidNullValues(familyName)));
						Element workItemId = WFXMLUtil.createElement(instrument, doc, "WorkItemId");
						workItemId.appendChild(doc.createTextNode(WFSUtil.avoidNullValues(rs.getString(21))));								
						Element queueName = WFXMLUtil.createElement(instrument, doc, "QueueName");
						queueName.appendChild(doc.createTextNode(WFSUtil.avoidNullValues(rs.getString(22))));						
						Element assignmentType = WFXMLUtil.createElement(instrument, doc, "AssignmentType");
						assignmentType.appendChild(doc.createTextNode(WFSUtil.avoidNullValues(rs.getString(23))));								
						Element processInstanceState = WFXMLUtil.createElement(instrument, doc, "ProcessInstanceState");
						processInstanceState.appendChild(doc.createTextNode(WFSUtil.avoidNullValues(rs.getString(24))));							
						Element queueType = WFXMLUtil.createElement(instrument, doc, "QueueType");
						queueType.appendChild(doc.createTextNode(WFSUtil.avoidNullValues(rs.getString(25))));									
						Element status = WFXMLUtil.createElement(instrument, doc, "Status");
						status.appendChild(doc.createTextNode(WFSUtil.avoidNullValues(rs.getString(26))));										
						Element queueId = WFXMLUtil.createElement(instrument, doc, "QueueId");
						queueId.appendChild(doc.createTextNode(WFSUtil.avoidNullValues(rs.getString(27))));									
						Element turnaroundtime = WFXMLUtil.createElement(instrument, doc, "Turnaroundtime");
						turnaroundtime.appendChild(doc.createTextNode(WFSUtil.avoidNullValues(rs.getString(28))));						
						Element referredby = WFXMLUtil.createElement(instrument, doc, "Referredby");
						referredby.appendChild(doc.createTextNode(WFSUtil.avoidNullValues(rs.getString(29))));					
						Element referredto = WFXMLUtil.createElement(instrument, doc, "Referredto");
						referredto.appendChild(doc.createTextNode(WFSUtil.avoidNullValues(rs.getString(30))));								
						Element turnAroundDateTime = WFXMLUtil.createElement(instrument, doc, "TurnAroundDateTime");
						turnAroundDateTime.appendChild(doc.createTextNode(WFSUtil.avoidNullValues(rs.getString("ExpectedWorkItemDelay"))));		
						userName = rs.getString("ProcessedBy");   /*WFS_8.0_052*/						
						Element q_DivertedByUserId = WFXMLUtil.createElement(instrument, doc, "Q_DivertedByUserId");
						q_DivertedByUserId.appendChild(doc.createTextNode(WFSUtil.avoidNullValues(rs.getString("Q_DivertedByUserId"))));	
						Element activityTypeElement = WFXMLUtil.createElement(instrument, doc, "ActivityType");
						activityTypeElement.appendChild(doc.createTextNode(WFSUtil.avoidNullValues(rs.getString("ActivityType"))));							
						userInfo = (WFUserInfo) CachedObjectCollection.getReference().getCacheObject(con, engine, 0, WFSConstant.CACHE_CONST_UserCache, "userName" + string21 + userName).getData();
						if (userInfo!=null){
							personalName = userInfo.getPersonalName();
							familyName = userInfo.getFamilyName();
						}
						else {
							personalName = null;
							familyName = null;
						}						
						Element processedBy = WFXMLUtil.createElement(instrument, doc, "ProcessedBy");
						processedBy.appendChild(doc.createTextNode(WFSUtil.avoidNullValues(userName)));							
						Element processedByPersonalName = WFXMLUtil.createElement(instrument, doc, "ProcessedByPersonalName");
						processedByPersonalName.appendChild(doc.createTextNode(WFSUtil.avoidNullValues(personalName)));			
						Element processedByFamilyName = WFXMLUtil.createElement(instrument, doc, "ProcessedByFamilyName");
						processedByFamilyName.appendChild(doc.createTextNode(WFSUtil.avoidNullValues(familyName)));
						Element urn = WFXMLUtil.createElement(instrument, doc, "URN");
						urn.appendChild(doc.createTextNode(WFSUtil.avoidNullValues(rs.getString("URN"))));
						Element secondaryDBFlag = WFXMLUtil.createElement(instrument, doc, "SecondaryDBFlag");
						secondaryDBFlag.appendChild(doc.createTextNode(WFSUtil.avoidNullValues(rs.getString("SecondaryDBFlag"))));
						Element calendarName = WFXMLUtil.createElement(instrument, doc, "CalendarName");
						calendarName.appendChild(doc.createTextNode(WFSUtil.avoidNullValues(rs.getString("CalendarName"))));
						
						String tATRemaining = null;
                    	String tATConsumed = null;
						WFCalAssocData wfCalAssocData = WFSUtil.getWICalendarInfo(con, engine, Integer.parseInt(rs.getString(3)), rs.getString(5), rs.getString("CalendarName"));
                        if (wfCalAssocData != null) {
                        	String expectedWorkItemDelay= rs.getString("ExpectedWorkItemDelay");                        	
                        	HashMap<String,Long> dateDiffenenceTATRemaining = new HashMap<String,Long>();
                        	HashMap<String,Long> dateDiffenenceTATConsumed = new HashMap<String,Long>();
                        	if((expectedWorkItemDelay!=null)&&(!"".equalsIgnoreCase(expectedWorkItemDelay)))
                        	{
                        		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                        		Date expectedWorkItemDelayDate = sdf.parse(expectedWorkItemDelay);
                        		Date dbCurrentDate = sdf.parse(dbCurrentDateTime);
                        		Date entryDate = sdf.parse(rs.getString(16));
                        		
	                        	dateDiffenenceTATRemaining = WFCalUtil.getSharedInstance().getDateDifference(dbCurrentDate, expectedWorkItemDelayDate,'M', wfCalAssocData.getProcessDefId(), wfCalAssocData.getCalId());
	                        	tATRemaining = String.valueOf(dateDiffenenceTATRemaining.get("DifferenceInMinutes"));
	                        	Element tATRemainingElement = WFXMLUtil.createElement(instrument, doc, "TATRemaining");
	                        	tATRemainingElement.appendChild(doc.createTextNode(WFSUtil.avoidNullValues(tATRemaining)));
	                        	
	                        	dateDiffenenceTATConsumed = WFCalUtil.getSharedInstance().getDateDifference(entryDate, dbCurrentDate,'M', wfCalAssocData.getProcessDefId(), wfCalAssocData.getCalId());
	                        	tATConsumed = String.valueOf(dateDiffenenceTATConsumed.get("DifferenceInMinutes"));
	                        	Element tATConsumedElement = WFXMLUtil.createElement(instrument, doc, "TATConsumed");
	                        	tATConsumedElement.appendChild(doc.createTextNode(WFSUtil.avoidNullValues(tATConsumed)));
                        	}
                        	
                        	
                        }
                        
						
						Element data = WFXMLUtil.createElement(instrument, doc, "Data");								
						for (int k = 0; k < nRSize - 38	; k++) {
							String value = rs.getString(39 + k);
							String TATR_value = "TATRemaining_"+(k+1);
							String TATC_value = "TATConsumed_"+(k+1);
							Element queueData = WFXMLUtil.createElement(data, doc, "QueueData");					
							Element name = WFXMLUtil.createElement(queueData, doc, "Name");
							name.appendChild(doc.createTextNode(WFSUtil.avoidNullValues(rsmd.getColumnLabel(39 + k))));
							Element valueElement = WFXMLUtil.createElement(queueData, doc, "Value");
							if(!(TATR_value.equalsIgnoreCase(value) || TATC_value.equalsIgnoreCase(value)))
							{							
							valueElement.appendChild(doc.createTextNode(WFSUtil.avoidNullValues(value)));
							}
							else
							{
								if(TATR_value.equalsIgnoreCase(value) )
									valueElement.appendChild(doc.createTextNode(WFSUtil.avoidNullValues(tATRemaining)));									
								else
									valueElement.appendChild(doc.createTextNode(WFSUtil.avoidNullValues(tATConsumed)));	
							}
						}					
						j++;
						tot++;
					}
				}else{
				
					while (j < noOfRectoFetch && rs.next()) {
						tempXml.append("<Instrument>\n");
						tempXml.append(gen.writeValueOf("ProcessInstanceId", WFSUtil.handleSpecialCharInXml(rs.getString(1))));
						tempXml.append(gen.writeValueOf("WorkItemName", WFSUtil.handleSpecialCharInXml(rs.getString(2))));
						tempXml.append(gen.writeValueOf("RouteId", rs.getString(3)));
						tempXml.append(gen.writeValueOf("RouteName", WFSUtil.handleSpecialCharInXml(rs.getString(4))));
						tempXml.append(gen.writeValueOf("WorkStageId", rs.getString(5)));
						tempXml.append(gen.writeValueOf("ActivityName", WFSUtil.handleSpecialCharInXml(rs.getString(6))));
						tempXml.append(gen.writeValueOf("PriorityLevel", rs.getString(7)));
						tempXml.append(gen.writeValueOf("InstrumentStatus", rs.getString(8)));
						tempXml.append(gen.writeValueOf("LockStatus", rs.getString(9)));
					   // tempXml.append(gen.writeValueOf("LockedByUserName", rs.getString(10)));
						userName = rs.getString(10);   /*WFS_8.0_039*/
						WFUserInfo userInfo = (WFUserInfo) CachedObjectCollection.getReference().getCacheObject(con, engine, 0, WFSConstant.CACHE_CONST_UserCache, "userName" + string21 + userName).getData();
						if (userInfo!=null){
							personalName = userInfo.getPersonalName();
							familyName = userInfo.getFamilyName();
						}
						else {
							personalName = null;
							familyName = null;
						}
						tempXml.append(gen.writeValueOf("LockedByUserName", WFSUtil.handleSpecialCharInXml(userName)));
						tempXml.append(gen.writeValueOf("LockedByPersonalName", WFSUtil.handleSpecialCharInXml(personalName)));
						tempXml.append(gen.writeValueOf("LockedByFamilyName", WFSUtil.handleSpecialCharInXml(familyName)));
						tempXml.append(gen.writeValueOf("ExpiryDateTime", rs.getString(11)));
					   // tempXml.append(gen.writeValueOf("CreatedByUserName", rs.getString(12)));
						userName = rs.getString(12);   /*WFS_8.0_039*/
						userInfo = (WFUserInfo) CachedObjectCollection.getReference().getCacheObject(con, engine, 0, WFSConstant.CACHE_CONST_UserCache, "userName" + string21 + userName).getData();
						if (userInfo!=null){
							personalName = userInfo.getPersonalName();
							familyName = userInfo.getFamilyName();
						}
						else {
							personalName = null;
							familyName = null;
						}
						tempXml.append(gen.writeValueOf("CreatedByUserName", WFSUtil.handleSpecialCharInXml(userName)));
						tempXml.append(gen.writeValueOf("CreatedByPersonalName",WFSUtil.handleSpecialCharInXml(personalName)));
						tempXml.append(gen.writeValueOf("CreatedByFamilyName", WFSUtil.handleSpecialCharInXml(familyName)));
						tempXml.append(gen.writeValueOf("CreationDateTime", rs.getString(13)));
						tempXml.append(gen.writeValueOf("WorkitemState", rs.getString(14)));
						tempXml.append(gen.writeValueOf("CheckListCompleteFlag", rs.getString(15)));
						tempXml.append(gen.writeValueOf("EntryDateTime", rs.getString(16)));
						tempXml.append(gen.writeValueOf("LockedTime", rs.getString(17)));
						tempXml.append(gen.writeValueOf("IntroductionDateTime", rs.getString(18)));
	//                    tempXml.append(gen.writeValueOf("IntroducedBy", rs.getString(19)));
	//                    tempXml.append(gen.writeValueOf("AssignedTo", rs.getString(20)));
						userName = rs.getString(19);	/*WFS_8.0_039*/
						userInfo = (WFUserInfo) CachedObjectCollection.getReference().getCacheObject(con, engine, 0, WFSConstant.CACHE_CONST_UserCache, "userName" + string21 + userName).getData();
						if (userInfo!=null){
							personalName = userInfo.getPersonalName();
							familyName = userInfo.getFamilyName();
						}
						else {
							personalName = null;
							familyName = null;
						}
						tempXml.append(gen.writeValueOf("IntroducedBy",WFSUtil.handleSpecialCharInXml(userName)));
						tempXml.append(gen.writeValueOf("IntroducedByPersonalName", WFSUtil.handleSpecialCharInXml(personalName)));
						tempXml.append(gen.writeValueOf("IntroducedByFamilyName", WFSUtil.handleSpecialCharInXml(familyName)));
						userName = rs.getString(20);   /*WFS_8.0_039*/
						userInfo = (WFUserInfo) CachedObjectCollection.getReference().getCacheObject(con, engine, 0, WFSConstant.CACHE_CONST_UserCache, "userName" + string21 + userName).getData();
						if (userInfo!=null){
							personalName = userInfo.getPersonalName();
							familyName = userInfo.getFamilyName();
						}
						else {
							personalName = null;
							familyName = null;
						}
						tempXml.append(gen.writeValueOf("AssignedTo", WFSUtil.handleSpecialCharInXml(userName)));
						tempXml.append(gen.writeValueOf("AssignedToPersonalName", WFSUtil.handleSpecialCharInXml(personalName)));
						tempXml.append(gen.writeValueOf("AssignedToFamilyName", WFSUtil.handleSpecialCharInXml(familyName)));
						tempXml.append(gen.writeValueOf("WorkItemId", rs.getString(21)));
						tempXml.append(gen.writeValueOf("QueueName", WFSUtil.handleSpecialCharInXml(rs.getString(22))));
						tempXml.append(gen.writeValueOf("AssignmentType", rs.getString(23)));
						tempXml.append(gen.writeValueOf("ProcessInstanceState", rs.getString(24)));
						tempXml.append(gen.writeValueOf("QueueType", rs.getString(25)));
						tempXml.append(gen.writeValueOf("Status", WFSUtil.handleSpecialCharInXml(rs.getString(26))));
						tempXml.append(gen.writeValueOf("QueueId", rs.getString(27)));
						tempXml.append(gen.writeValueOf("Turnaroundtime", rs.getString(28)));
						tempXml.append(gen.writeValueOf("Referredby", WFSUtil.handleSpecialCharInXml(rs.getString(29))));
						tempXml.append(gen.writeValueOf("Referredto",  WFSUtil.handleSpecialCharInXml(rs.getString(30))));
						tempXml.append(gen.writeValueOf("TurnAroundDateTime", rs.getString("ExpectedWorkItemDelay")));
						userName = rs.getString("ProcessedBy");   /*WFS_8.0_052*/
						tempXml.append(gen.writeValueOf("Q_DivertedByUserId", rs.getString("Q_DivertedByUserId")));
						tempXml.append(gen.writeValueOf("ActivityType", rs.getString("ActivityType")));
						userInfo = (WFUserInfo) CachedObjectCollection.getReference().getCacheObject(con, engine, 0, WFSConstant.CACHE_CONST_UserCache, "userName" + string21 + userName).getData();
						if (userInfo!=null){
							personalName = userInfo.getPersonalName();
							familyName = userInfo.getFamilyName();
						}
						else {
							personalName = null;
							familyName = null;
						}
						tempXml.append(gen.writeValueOf("ProcessedBy", WFSUtil.handleSpecialCharInXml(userName)));
						tempXml.append(gen.writeValueOf("ProcessedByPersonalName", WFSUtil.handleSpecialCharInXml(personalName)));
						tempXml.append(gen.writeValueOf("ProcessedByFamilyName", WFSUtil.handleSpecialCharInXml(familyName)));
						tempXml.append(gen.writeValueOf("URN", rs.getString("URN")));
						tempXml.append(gen.writeValueOf("SecondaryDBFlag", rs.getString("SecondaryDBFlag")));
						tempXml.append(gen.writeValueOf("CalendarName", rs.getString("CalendarName")));
						

                    	String tATRemaining = null;
                    	String tATConsumed = null;
						WFCalAssocData wfCalAssocData = WFSUtil.getWICalendarInfo(con, engine, Integer.parseInt(rs.getString(3)), rs.getString(5), rs.getString("CalendarName"));
                        if (wfCalAssocData != null) {
                        	String expectedWorkItemDelay= rs.getString("ExpectedWorkItemDelay");
                        	HashMap<String,Long> dateDiffenenceTATRemaining = new HashMap<String,Long>();
                        	HashMap<String,Long> dateDiffenenceTATConsumed = new HashMap<String,Long>();
                        	if((expectedWorkItemDelay!=null)&&(!"".equalsIgnoreCase(expectedWorkItemDelay)))
                        	{
                        		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                        		Date expectedWorkItemDelayDate = sdf.parse(expectedWorkItemDelay);
                        		Date dbCurrentDate = sdf.parse(dbCurrentDateTime);
                        		Date entryDate = sdf.parse(rs.getString(16));
                        		
	                        	dateDiffenenceTATRemaining = WFCalUtil.getSharedInstance().getDateDifference(dbCurrentDate, expectedWorkItemDelayDate,'M', wfCalAssocData.getProcessDefId(), wfCalAssocData.getCalId());
	                        	tATRemaining = String.valueOf(dateDiffenenceTATRemaining.get("DifferenceInMinutes"));
	                        	tempXml.append(gen.writeValueOf("TATRemaining", tATRemaining));
	                        	
	                        	dateDiffenenceTATConsumed = WFCalUtil.getSharedInstance().getDateDifference(entryDate, dbCurrentDate,'M', wfCalAssocData.getProcessDefId(), wfCalAssocData.getCalId());
	                        	tATConsumed = String.valueOf(dateDiffenenceTATConsumed.get("DifferenceInMinutes"));
	                            tempXml.append(gen.writeValueOf("TATConsumed", tATConsumed));
                        	}
                        	
                        	
                        }
                        
                        

						tempXml.append("<Data>\n");
						//				Code added for Processmanager functionality for fetching workitems based on logged in user for WSE_5.0.1_003
						for (int k = 0; k < nRSize -38	; k++) {
							String value = rs.getString(39 + k);
							String TATR_value = "TATRemaining_"+(k+1);
							String TATC_value = "TATConsumed_"+(k+1);
							tempXml.append("<QueueData>\n");
							tempXml.append(gen.writeValueOf("Name", WFSUtil.handleSpecialCharInXml(rsmd.getColumnLabel(39 + k))));
							if(!(TATR_value.equalsIgnoreCase(value) || TATC_value.equalsIgnoreCase(value)))
							tempXml.append(gen.writeValueOf("Value", WFSUtil.handleSpecialCharInXml(value)));
							else
							{
								if(TATR_value.equalsIgnoreCase(value) )
									tempXml.append(gen.writeValueOf("Value", WFSUtil.handleSpecialCharInXml(WFSUtil.avoidNullValues(tATRemaining))));
								else
									tempXml.append(gen.writeValueOf("Value", WFSUtil.handleSpecialCharInXml(WFSUtil.avoidNullValues(tATConsumed))));
							}
							tempXml.append("\n</QueueData>\n");
						}
						tempXml.append("</Data>\n");
						tempXml.append("</Instrument>\n");
						j++;
						tot++;
					}			
				
				}			
				
				
                if (rs.next()) {
                    tot++;
                }
                if (rs != null) {
                    rs.close();
                }
                if(dbType == JTSConstant.JTS_POSTGRES){
                	//nRSize = nRSize-1;  
                    con.commit();
                    con.setAutoCommit(true);
                }
                if (j > 0) {
					if(!stdParserFlag){	
						tempXml.insert(0, "<Instruments>\n");
						tempXml.append("</Instruments>\n");
					}
                } else{
                    mainCode = WFSError.WM_NO_MORE_DATA;
                    subCode = 0;
                    subject = WFSErrorMsg.getMessage(mainCode);
                    descr = WFSErrorMsg.getMessage(subCode);
                    errType = WFSError.WF_TMP;
                }
				if(stdParserFlag){
					tempXml.append(WFXMLUtil.getXmlStringforDOMDocument(doc));	
				}
                tempXml.append(gen.writeValueOf("RetrievedCount", String.valueOf(j)));
                tempXml.append(gen.writeValueOf("Count", String.valueOf(tot)));
                tempXml.append(gen.writeValueOf("WorkitemCount", String.valueOf(returnCount))); /*Bugzilla Bug 1680*/
				tempXml.append(gen.writeValueOf("AliasProcessDefId", String.valueOf(aliasProcessDefId)));
            }
		    }else {
            	 WFSUtil.printErr(engine,"Invalid QueueType for WFFetchWorkItems");
            	 mainCode = WFSError.WF_INVALID_QUEUETYPE;
                 subCode = WFSError.WF_INVALID_QUEUETYPE;
                 subject = WFSErrorMsg.getMessage(mainCode);
                 errType = WFSError.WF_TMP;
                 descr = "Not a vaild Queue ";
            }  
			/*bug 35875 fixed*/
            if (mainCode == 0 || mainCode == 18) {
                outputXML = new StringBuffer(500);
                outputXML.append(gen.createOutputFile(optionTag));
                outputXML.append("<Exception>\n<MainCode>"+mainCode+"</MainCode>\n</Exception>\n");
                outputXML.append(tempXml);
				pstmt = con.prepareStatement("Select LastModifiedOn from QueueDefTable " + WFSUtil.getTableLockHintStr(dbType) + "  where queueid = ? ");
				pstmt.setInt(1,queueid);
				if(queryTimeout <= 0)
					pstmt.setQueryTimeout(60);
	            else
	            	pstmt.setQueryTimeout(queryTimeout);
				rs = pstmt.executeQuery();
				if(rs.next())
						outputXML.append(gen.writeValueOf("LastModifiedOn", rs.getString("LastModifiedOn")));
				if(reminder) {
					outputXML.append(gen.writeValueOf("ReminderFlag", WFSUtil.getReminderDetails(con, engine, participant.getid())));
				}
				if(rs != null)
					rs.close();
				if(pstmt != null)
					pstmt.close();
				outputXML.append(inputParamInfo);
                outputXML.append(gen.closeOutputFile(optionTag));
            }
        } catch (SQLException e) {
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WM_INVALID_FILTER;
            subCode = WFSError.WFS_SQL;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_FAT;
            if (e.getErrorCode() == 0) {
                if (e.getSQLState().equalsIgnoreCase("08S01")) {
                    descr = (new JTSSQLError(e.getSQLState())).getMessage() + "(SQL State : " + e.getSQLState() + ")";
                }
            } else {
                descr = e.getMessage();
            }
        } catch (NumberFormatException e) {
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_ILP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch (NullPointerException e) {
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_SYS;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch (WFSException e) {
            mainCode = e.getMainErrorCode();
            subCode = e.getSubErrorCode();
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = e.getTypeOfError();
            descr = WFSErrorMsg.getMessage(subCode);
        } catch (JTSException e) {
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = e.getErrorCode();
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.getMessage();
        } catch (Exception e) {
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_EXP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch (Error e) {
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_EXP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } finally {
            try {
//				Added By Varun Bhansaly On 16/05/2007
                if (rs != null) {
                    rs.close();
                    rs = null;
                }
                if (stmt != null) {
                    stmt.close();
                    stmt = null;
                }
//				Added By Varun Bhansaly On 16/05/2007
                if (cstmt != null) {
                    cstmt.close();
                    cstmt = null;
                }
            } catch (Exception e) {
            }
            
        }
        if (mainCode != 0 && mainCode != 18) {
            throw new WFSException(mainCode, subCode, errType, subject, descr, inputParamInfo.toString());
        }
        return outputXML.toString();
    }
    
//----------------------------------------------------------------------------------------------------
//	Function Name 				:	WFFetchCaseWorkItems
//	Date Written (DD/MM/YYYY)	:	29/10/2015
//	Author						:	Mohnish Chopra
//	Input Parameters			:	Connection , XMLParser , XMLGenerator
//	Output Parameters			:   none
//	Return Values				:	String
//	Description					:   Fetch my cases for User A will include :
//								    1. Cases that are owned by Case Manager A 
//   								2. Cases in which task are assigned to Case Worker A or Case Participant A
//  Change Description          :   
//----------------------------------------------------------------------------------------------------
    public String WFFetchCaseWorkItems(Connection con, XMLParser parser, XMLGenerator gen) throws JTSException, WFSException {
        StringBuilder outputXML = new StringBuilder(500);
        CallableStatement cstmt = null;
        Statement stmt = null;
        ResultSet rs = null;
        int mainCode = 0;
        int subCode = 0;
        int returnCount = 0;
        String subject = null;
        String descr = null;
        String errType = WFSError.WF_TMP;
        int orderBy = 0;
        int serverBatchSize = 0;
        int noOfRectoFetch = 0;
        int lastWIValue = 0;
        int sessionID = 0;
        int dbType = 0;
        String lastValue = "";
        String lastPIValue = "";
        String sortOrder = "";
        String dataflag = "";
        String returnCountFlag = "";
        boolean overDueFlag = false;
        String engine = "";
        StringBuilder tempXml = null;
        boolean myQueueFlag = false;
		int aliasProcessDefId = 0;
		int startingRecordNo = 0;
		String optionTag = null;
		char char21 = 21;
		String string21 = "" + char21;
		Document doc = null;
		boolean stdParserFlag = false;
		ResultSet curResultSet = null;
		String cursorName = "";
		try {
			int queryTimeout = WFSUtil.getQueryTimeOut();
			sessionID = parser.getIntOf("SessionId", 0, false);
			engine = parser.getValueOf("EngineName");
			optionTag = parser.getValueOf("Option");
			WFParticipant participant = WFSUtil.WFCheckSession(con, sessionID);
			int userid = 0;
			dbType = ServerProperty.getReference().getDBType(engine);
			orderBy = parser.getIntOf("OrderBy", 2, true);// By default order by on processinstanceid, workitemid
			serverBatchSize = ServerProperty.getReference().getBatchSize();
			noOfRectoFetch = parser.getIntOf("NoOfRecordsToFetch", serverBatchSize, true);
			if (noOfRectoFetch > serverBatchSize || noOfRectoFetch <= 0) {
				noOfRectoFetch = serverBatchSize;
			}
			lastWIValue = parser.getIntOf("LastWorkItem", 0, true);
			lastValue = parser.getValueOf("LastValue", "", true);
			lastPIValue = parser.getValueOf("LastProcessInstance", "", true);
			sortOrder = parser.getValueOf("SortOrder", "A", true);
			dataflag = parser.getValueOf("DataFlag", "N", true);
			returnCountFlag = parser.getValueOf("ReturnCountFlag", "N", true);
			stdParserFlag = parser.getValueOf("usestdparser", "N", true).equalsIgnoreCase("Y"); 	
			String pinstname = null;
			String activityNameFilter = null;
			String ownedFlag = parser.getValueOf("Owned", "A", true);

			int searchCriteria = parser.getIntOf("SearchCriteria", 0, true);
			if(searchCriteria==WFSConstant.SEARCH_CASE_BASKET_PROCESSINSTANCEID){
				pinstname = parser.getValueOf("SearchPrefix", "", true);
			}else if(searchCriteria==WFSConstant.SEARCH_CASE_BASKET_ACTIVITY_NAME){
				activityNameFilter = parser.getValueOf("SearchPrefix", "", true);
			}
			
			if(WFSUtil.isLikeSearchEnabled()){
				if(searchCriteria==WFSConstant.SEARCH_CASE_BASKET_PROCESSINSTANCEID){
					pinstname = pinstname + "*";
				}else if(searchCriteria==WFSConstant.SEARCH_CASE_BASKET_ACTIVITY_NAME){
					activityNameFilter = activityNameFilter +"*";
				}
					
			}
			overDueFlag = parser.getValueOf("OverDue", "N", true).equalsIgnoreCase("Y");
			StringBuilder filterString = new StringBuilder(100);
			 if((pinstname!=null)&&(!pinstname.equalsIgnoreCase(""))){ 
             	pinstname = WFSUtil.TO_STRING_WITHOUT_RTRIM(pinstname, true, dbType);
					String tempProcessInstanceId = WFSUtil.replace(pinstname, "*", "");
					if (!tempProcessInstanceId.trim().equals("")) {
						filterString.append(" and processinstanceid ");
						if(pinstname.indexOf("*") > 0 || pinstname.indexOf("?") > 0 || pinstname.indexOf("_") > 0)
							filterString.append(" like ");
						else
							filterString.append("= ");

                     	if(dbType == JTSConstant.JTS_POSTGRES) {
							//Changes done for optmization in Postgres 
							filterString.append(WFSUtil.convertToPostgresLikeSQLString(pinstname.trim()).replace('*', '%'));   	 
                     }
					 else if(dbType == JTSConstant.JTS_ORACLE) {
						//Changes for 10.1 Postgres support ends
                    	 filterString.append(parser.convertToSQLString(pinstname.trim(),dbType).replace('*', '%'));
                         if (pinstname.indexOf("?") > 0 || pinstname.indexOf("_") > 0)
                         {
                        	 filterString.append(" ESCAPE '\\' ");
                         }
						}
						else {
							filterString.append(parser.convertToSQLString(pinstname.trim()).replace('*', '%'));

						}
                     	filterString.append(" ");

					}
			 }else if((activityNameFilter!=null)&&(!activityNameFilter.equalsIgnoreCase(""))){
				 activityNameFilter = WFSUtil.TO_STRING_WITHOUT_RTRIM(activityNameFilter, true, dbType);
				 String tempProcessInstanceId = WFSUtil.replace(activityNameFilter, "*", "");
				 if (!tempProcessInstanceId.trim().equals("")) {
					 filterString.append(" and ActivityName ");
					 if(activityNameFilter.indexOf("*") > 0 || activityNameFilter.indexOf("?") > 0 || activityNameFilter.indexOf("_") > 0)
						 filterString.append(" like ");
					 else
						 filterString.append("= ");

					 if(dbType == JTSConstant.JTS_POSTGRES) {
						 filterString.append(WFSUtil.convertToPostgresLikeSQLString(activityNameFilter.trim()).replace('*', '%'));   	 
					 }
					 else if(dbType == JTSConstant.JTS_ORACLE) {
						 filterString.append(parser.convertToSQLString(activityNameFilter.trim(),dbType).replace('*', '%'));
						 if (activityNameFilter.indexOf("?") > 0 || activityNameFilter.indexOf("_") > 0)
						 {
							 filterString.append(" ESCAPE '\\' ");
						 }
					 }
					 else {
						 filterString.append(parser.convertToSQLString(activityNameFilter.trim()).replace('*', '%'));

					 }

				 }

			 }
			 if(overDueFlag){
				 filterString.append(" and ").append("ExpectedWorkItemDelay < ").append(WFSUtil.getDate(dbType));
			 }
			LinkedHashMap<String, LinkedList<VariableClass>> caseDataVariableMap = WFCaseDataVariableMap.getSharedInstance().getCaseDataMap();
			if(caseDataVariableMap.isEmpty()){
				caseDataVariableMap=WFCaseDataVariableMap.populateCaseDataMap(con, dbType);
			}
			
			if ((myQueueFlag)&&(participant != null && participant.gettype() == 'U')){
					userid = participant.getid();
			} 
			if (dbType == JTSConstant.JTS_MSSQL) {
				cstmt = con.prepareCall("{call WFFetchCaseList(?, ?, ?, ?, ?, ?, ?, ?,?,?)}"); // Bugzilla Bug 1703
			} else if (dbType == JTSConstant.JTS_ORACLE) {
				cstmt = con.prepareCall("{call WFFetchCaseList(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,?,?)}"); // Bugzilla Bug 1703
			}else if (dbType == JTSConstant.JTS_POSTGRES) {
                con.setAutoCommit(false);
				cstmt = con.prepareCall("{call WFFetchCaseList(?, ?, ?, ?, ?, ?, ?, ?,?,?)}"); // Bugzilla Bug 1703
			}
			if(queryTimeout <= 0)
                            cstmt.setQueryTimeout(60);
                        else
                            cstmt.setQueryTimeout(queryTimeout);
			cstmt.setInt(1, sessionID);
			cstmt.setString(2, sortOrder);
			cstmt.setInt(3, orderBy);
			cstmt.setInt(4, noOfRectoFetch);
			cstmt.setInt(5, lastWIValue);
			if (("").equals(lastPIValue) || startingRecordNo != 0) //Bugzilla Bug 1765
			{
				cstmt.setNull(6, java.sql.Types.VARCHAR);
			} else {
				cstmt.setString(6, lastPIValue);
			}

			if (("").equals(lastValue) || startingRecordNo != 0) //Bugzilla Bug 1765
			{
				cstmt.setNull(7, java.sql.Types.VARCHAR);
			} else {
				cstmt.setString(7, lastValue);
			}
			cstmt.setString(8,ownedFlag);
			cstmt.setString(9,filterString.toString());
			
			if (returnCountFlag.startsWith("N")) {
				cstmt.setInt(10, 0);
			} else {
				cstmt.setInt(10, 2);
			}
			if (dbType == JTSConstant.JTS_ORACLE) {
				cstmt.registerOutParameter(11, java.sql.Types.INTEGER);
				cstmt.registerOutParameter(12, java.sql.Types.INTEGER);
				cstmt.registerOutParameter(13, java.sql.Types.INTEGER); /*Bugzilla Id 1680*/
				cstmt.registerOutParameter(14, oracle.jdbc.OracleTypes.CURSOR);
			}
			if(queryTimeout <= 0)
      			cstmt.setQueryTimeout(60);
			else
      			cstmt.setQueryTimeout(queryTimeout);
			cstmt.execute();
			if (dbType == JTSConstant.JTS_MSSQL) {
				rs = cstmt.getResultSet();
			}
			else if(dbType == JTSConstant.JTS_POSTGRES){
                curResultSet = cstmt.getResultSet();
                if(curResultSet.next()){
                    stmt = con.createStatement();
                    cursorName = curResultSet.getString(1);
                    rs = stmt.executeQuery("Fetch All In \"" + TO_SANITIZE_STRING(cursorName, false) + "\"");
                    if(rs!=null && rs.next()){
                    {
                        mainCode = rs.getInt("MainCode");
    					subCode = rs.getInt("SubCode");
                        returnCount = rs.getInt("ReturnCount");
                    }
                    
                }
                
                    if ((mainCode == 0)&&(curResultSet.next())) {
                            stmt =  null;
                            stmt = con.createStatement();
                            cursorName = curResultSet.getString(1);
                            if(rs !=null){
                               rs.close();
                               rs=null;
                            }
                            rs = stmt.executeQuery("Fetch All In \"" + TO_SANITIZE_STRING(cursorName, false) + "\"");
                           
                           
                   }
                    if(curResultSet!=null){
                        curResultSet.close();    
                        curResultSet =null;
                    }
            }
        }
			if ((dbType == JTSConstant.JTS_MSSQL && rs != null && rs.next()) || dbType == JTSConstant.JTS_ORACLE) {
				if (dbType == JTSConstant.JTS_ORACLE) {
					mainCode = cstmt.getInt(11);
					subCode = cstmt.getInt(12);
					returnCount = cstmt.getInt(13); 
				} else {
					mainCode = rs.getInt("MainCode");
					subCode = rs.getInt("SubCode");/*bug 41579, subcode defined*/
					returnCount = rs.getInt("ReturnCount");
					rs.close();
					rs = null;
				}
			} else if (dbType == JTSConstant.JTS_POSTGRES) {
				//main code, sub code and return count already fetched
			}  else {
				/* This should never be the case */
				if (rs != null) {
					rs.close();
					rs = null;
				}
				mainCode = WFSError.WF_OPERATION_FAILED;
				subCode = WFSError.WFS_FATAL;
				returnCount = 0; /*Bugzilla Bug 1680*/
			}

			if (mainCode == 0) {
				/* ResultSet 2 -> Workitem related data */
				if (dbType == JTSConstant.JTS_MSSQL && cstmt.getMoreResults() == true ) {
					rs = cstmt.getResultSet();
				} else if (dbType == JTSConstant.JTS_ORACLE) {
					rs = (ResultSet) cstmt.getObject(14); /* Bugzilla Bug 1680*/
				}
				ResultSetMetaData rsmd = null;
				int nRSize = 0;
				if (dataflag.startsWith("Y")) {
					rsmd = rs.getMetaData();
					nRSize = rsmd.getColumnCount();
				}
				if(dbType == JTSConstant.JTS_ORACLE)
					nRSize = nRSize-1;
				tempXml = new StringBuilder();

				int j = 0;
				int tot = 0;
				String personalName = null;
				String userName = null;




				if(stdParserFlag){
					doc = WFXMLUtil.createDocument();
					Element instruments = WFXMLUtil.createRootElement(doc, "Instruments");				
					while (j < noOfRectoFetch && rs.next()) {						
						Element instrument = WFXMLUtil.createElement(instruments, doc, "Instrument");					
						Element processInstanceId = WFXMLUtil.createElement(instrument, doc, "ProcessInstanceId");
						processInstanceId.appendChild(doc.createTextNode(WFSUtil.avoidNullValues(rs.getString(1))));							
						Element workItemName = WFXMLUtil.createElement(instrument, doc, "WorkItemName");
						workItemName.appendChild(doc.createTextNode(WFSUtil.avoidNullValues(rs.getString(2))));			
						Element routeId = WFXMLUtil.createElement(instrument, doc, "RouteId");
						routeId.appendChild(doc.createTextNode(WFSUtil.avoidNullValues(rs.getString(3))));					
						Element routeName = WFXMLUtil.createElement(instrument, doc, "RouteName");
						routeName.appendChild(doc.createTextNode(WFSUtil.avoidNullValues(rs.getString(4))));										
						Element workStageId = WFXMLUtil.createElement(instrument, doc, "WorkStageId");
						workStageId.appendChild(doc.createTextNode(WFSUtil.avoidNullValues(rs.getString(5))));									
						Element activityName = WFXMLUtil.createElement(instrument, doc, "ActivityName");
						activityName.appendChild(doc.createTextNode(WFSUtil.avoidNullValues(rs.getString(6))));									
						Element priorityLevel = WFXMLUtil.createElement(instrument, doc, "PriorityLevel");
						priorityLevel.appendChild(doc.createTextNode(WFSUtil.avoidNullValues(rs.getString(7))));						
						Element instrumentStatus = WFXMLUtil.createElement(instrument, doc, "InstrumentStatus");
						instrumentStatus.appendChild(doc.createTextNode(WFSUtil.avoidNullValues(rs.getString(8))));					
						Element lockStatus = WFXMLUtil.createElement(instrument, doc, "LockStatus");
						lockStatus.appendChild(doc.createTextNode(WFSUtil.avoidNullValues(rs.getString(9))));					   
						userName = rs.getString(10);   /*WFS_8.0_039*/
						WFUserInfo userInfo = (WFUserInfo) CachedObjectCollection.getReference().getCacheObject(con, engine, 0, WFSConstant.CACHE_CONST_UserCache, "userName" + string21 + userName).getData();
						if (userInfo!=null){
							personalName = userInfo.getPersonalName();
						}
						else {
							personalName = null;
						}
						Element lockedByUserName = WFXMLUtil.createElement(instrument, doc, "LockedByUserName");
						lockedByUserName.appendChild(doc.createTextNode(WFSUtil.avoidNullValues(userName)));										
						Element lockedByPersonalName = WFXMLUtil.createElement(instrument, doc, "LockedByPersonalName");
						lockedByPersonalName.appendChild(doc.createTextNode(WFSUtil.avoidNullValues(personalName)));								
						Element expiryDateTime = WFXMLUtil.createElement(instrument, doc, "ExpiryDateTime");
						expiryDateTime.appendChild(doc.createTextNode(WFSUtil.avoidNullValues(rs.getString(11))));				   
						userName = rs.getString(12);   /*WFS_8.0_039*/
						userInfo = (WFUserInfo) CachedObjectCollection.getReference().getCacheObject(con, engine, 0, WFSConstant.CACHE_CONST_UserCache, "userName" + string21 + userName).getData();
						if (userInfo!=null){
							personalName = userInfo.getPersonalName();
						}
						else {
							personalName = null;
						}					
						Element createdByUserName = WFXMLUtil.createElement(instrument, doc, "CreatedByUserName");
						createdByUserName.appendChild(doc.createTextNode(WFSUtil.avoidNullValues(userName)));									
						Element createdByPersonalName = WFXMLUtil.createElement(instrument, doc, "CreatedByPersonalName");
						createdByPersonalName.appendChild(doc.createTextNode(WFSUtil.avoidNullValues(personalName)));						
						Element creationDateTime = WFXMLUtil.createElement(instrument, doc, "CreationDateTime");
						creationDateTime.appendChild(doc.createTextNode(WFSUtil.avoidNullValues(rs.getString(13))));								
						Element workitemState = WFXMLUtil.createElement(instrument, doc, "WorkitemState");
						workitemState.appendChild(doc.createTextNode(WFSUtil.avoidNullValues(rs.getString(14))));								
						Element checkListCompleteFlag = WFXMLUtil.createElement(instrument, doc, "CheckListCompleteFlag");
						checkListCompleteFlag.appendChild(doc.createTextNode(WFSUtil.avoidNullValues(rs.getString(15))));						
						Element entryDateTime = WFXMLUtil.createElement(instrument, doc, "EntryDateTime");
						entryDateTime.appendChild(doc.createTextNode(WFSUtil.avoidNullValues(rs.getString(16))));							
						Element lockedTime = WFXMLUtil.createElement(instrument, doc, "LockedTime");
						lockedTime.appendChild(doc.createTextNode(WFSUtil.avoidNullValues(rs.getString(17))));									
						Element introductionDateTime = WFXMLUtil.createElement(instrument, doc, "IntroductionDateTime");
						introductionDateTime.appendChild(doc.createTextNode(WFSUtil.avoidNullValues(rs.getString(18))));						
						userName = rs.getString(19);	/*WFS_8.0_039*/
						userInfo = (WFUserInfo) CachedObjectCollection.getReference().getCacheObject(con, engine, 0, WFSConstant.CACHE_CONST_UserCache, "userName" + string21 + userName).getData();
						if (userInfo!=null){
							personalName = userInfo.getPersonalName();
						}
						else {
							personalName = null;
						}					
						Element introducedBy = WFXMLUtil.createElement(instrument, doc, "IntroducedBy");
						introducedBy.appendChild(doc.createTextNode(WFSUtil.avoidNullValues(userName)));											
						Element introducedByPersonalName = WFXMLUtil.createElement(instrument, doc, "IntroducedByPersonalName");
						introducedByPersonalName.appendChild(doc.createTextNode(WFSUtil.avoidNullValues(personalName)));						
						userName = rs.getString(20);   /*WFS_8.0_039*/
						userInfo = (WFUserInfo) CachedObjectCollection.getReference().getCacheObject(con, engine, 0, WFSConstant.CACHE_CONST_UserCache, "userName" + string21 + userName).getData();
						if (userInfo!=null){
							personalName = userInfo.getPersonalName();
						}
						else {
							personalName = null;
						}						
						Element assignedTo = WFXMLUtil.createElement(instrument, doc, "AssignedTo");
						assignedTo.appendChild(doc.createTextNode(WFSUtil.avoidNullValues(userName)));						
						Element assignedToPersonalName = WFXMLUtil.createElement(instrument, doc, "AssignedToPersonalName");
						assignedToPersonalName.appendChild(doc.createTextNode(WFSUtil.avoidNullValues(personalName)));						
						Element workItemId = WFXMLUtil.createElement(instrument, doc, "WorkItemId");
						workItemId.appendChild(doc.createTextNode(WFSUtil.avoidNullValues(rs.getString(21))));								
						Element queueName = WFXMLUtil.createElement(instrument, doc, "QueueName");
						queueName.appendChild(doc.createTextNode(WFSUtil.avoidNullValues(rs.getString(22))));						
						Element assignmentType = WFXMLUtil.createElement(instrument, doc, "AssignmentType");
						assignmentType.appendChild(doc.createTextNode(WFSUtil.avoidNullValues(rs.getString(23))));								
						Element processInstanceState = WFXMLUtil.createElement(instrument, doc, "ProcessInstanceState");
						processInstanceState.appendChild(doc.createTextNode(WFSUtil.avoidNullValues(rs.getString(24))));							
						Element queueType = WFXMLUtil.createElement(instrument, doc, "QueueType");
						queueType.appendChild(doc.createTextNode(WFSUtil.avoidNullValues(rs.getString(25))));									
						Element status = WFXMLUtil.createElement(instrument, doc, "Status");
						status.appendChild(doc.createTextNode(WFSUtil.avoidNullValues(rs.getString(26))));										
						Element queueId = WFXMLUtil.createElement(instrument, doc, "QueueId");
						queueId.appendChild(doc.createTextNode(WFSUtil.avoidNullValues(rs.getString(27))));									
						Element turnaroundtime = WFXMLUtil.createElement(instrument, doc, "Turnaroundtime");
						turnaroundtime.appendChild(doc.createTextNode(WFSUtil.avoidNullValues(rs.getString(28))));						
						Element referredby = WFXMLUtil.createElement(instrument, doc, "Referredby");
						referredby.appendChild(doc.createTextNode(WFSUtil.avoidNullValues(rs.getString(29))));					
						Element referredto = WFXMLUtil.createElement(instrument, doc, "Referredto");
						referredto.appendChild(doc.createTextNode(WFSUtil.avoidNullValues(rs.getString(30))));								
						Element turnAroundDateTime = WFXMLUtil.createElement(instrument, doc, "TurnAroundDateTime");
						turnAroundDateTime.appendChild(doc.createTextNode(WFSUtil.avoidNullValues(rs.getString("ExpectedWorkItemDelay"))));		
						userName = rs.getString("ProcessedBy");   /*WFS_8.0_052*/						
						Element qDivertedByUserId = WFXMLUtil.createElement(instrument, doc, "Q_DivertedByUserId");
						qDivertedByUserId.appendChild(doc.createTextNode(WFSUtil.avoidNullValues(rs.getString("Q_DivertedByUserId"))));	
						Element activityTypeElement = WFXMLUtil.createElement(instrument, doc, "ActivityType");
						activityTypeElement.appendChild(doc.createTextNode(WFSUtil.avoidNullValues(rs.getString("ActivityType"))));							
						userInfo = (WFUserInfo) CachedObjectCollection.getReference().getCacheObject(con, engine, 0, WFSConstant.CACHE_CONST_UserCache, "userName" + string21 + userName).getData();
						Element canInitiateTypeElement = WFXMLUtil.createElement(instrument, doc, "CanInitiate");
						canInitiateTypeElement.appendChild(doc.createTextNode(WFSUtil.avoidNullValues(rs.getString("CanInitiate"))));							
						Element caseManagerElement = WFXMLUtil.createElement(instrument, doc, "CaseManager");
						caseManagerElement.appendChild(doc.createTextNode(WFSUtil.avoidNullValues(rs.getString("CaseManager"))));
						//Changes for Bug 57931: RETURNING LastModifiedTime and that will be sent in input in AssignWorkItemAttributes for Priority
						Element lastModifiedTime = WFXMLUtil.createElement(instrument, doc, "LastModifiedTime");
						lastModifiedTime.appendChild(doc.createTextNode(WFSUtil.avoidNullValues(rs.getString("LastModifiedTime"))));
						Element showCaseVisualElement = WFXMLUtil.createElement(instrument, doc, "ShowCaseVisual");
						showCaseVisualElement.appendChild(doc.createTextNode(WFSUtil.avoidNullValues(rs.getString("ShowCaseVisual"))));
						Element urn = WFXMLUtil.createElement(instrument, doc, "URN");
						urn.appendChild(doc.createTextNode(WFSUtil.avoidNullValues(rs.getString("URN"))));
						if (userInfo!=null){
							personalName = userInfo.getPersonalName();
						}
						else {
							personalName = null;
						}						
						Element processedBy = WFXMLUtil.createElement(instrument, doc, "ProcessedBy");
						processedBy.appendChild(doc.createTextNode(WFSUtil.avoidNullValues(userName)));							
						Element processedByPersonalName = WFXMLUtil.createElement(instrument, doc, "ProcessedByPersonalName");
						processedByPersonalName.appendChild(doc.createTextNode(WFSUtil.avoidNullValues(personalName)));						
						Element data = WFXMLUtil.createElement(instrument, doc, "Data");								
						for (int k = 0; k < nRSize - 33	; k++) {							
							Element queueData = WFXMLUtil.createElement(data, doc, "QueueData");					
							Element name = WFXMLUtil.createElement(queueData, doc, "Name");
							name.appendChild(doc.createTextNode(WFSUtil.avoidNullValues(rsmd.getColumnLabel(34 + k))));							
							Element value = WFXMLUtil.createElement(queueData, doc, "Value");
							value.appendChild(doc.createTextNode(WFSUtil.avoidNullValues(rs.getString(34 + k))));
						}					
						j++;
						tot++;
					}
				}else{

					while (j < noOfRectoFetch && rs.next()) {
						tempXml.append("<Instrument>\n");
						tempXml.append(gen.writeValueOf("ProcessInstanceId", rs.getString(1)));
						tempXml.append(gen.writeValueOf("WorkItemName", rs.getString(2)));
						String routeId = rs.getString(3);
						tempXml.append(gen.writeValueOf("RouteId", routeId));
						tempXml.append(gen.writeValueOf("RouteName", rs.getString(4)));
						String workStageId = rs.getString(5);
						tempXml.append(gen.writeValueOf("WorkStageId", workStageId));
						String key = routeId + "#" +workStageId;
						tempXml.append(gen.writeValueOf("ActivityName", rs.getString(6)));
						tempXml.append(gen.writeValueOf("PriorityLevel", rs.getString(7)));
						tempXml.append(gen.writeValueOf("InstrumentStatus", rs.getString(8)));
						tempXml.append(gen.writeValueOf("LockStatus", rs.getString(9)));
						userName = rs.getString(10);   /*WFS_8.0_039*/
						WFUserInfo userInfo = (WFUserInfo) CachedObjectCollection.getReference().getCacheObject(con, engine, 0, WFSConstant.CACHE_CONST_UserCache, "userName" + string21 + userName).getData();
						if (userInfo!=null){
							personalName = userInfo.getPersonalName();
						}
						else {
							personalName = null;
						}
						tempXml.append(gen.writeValueOf("LockedByUserName", userName));
						tempXml.append(gen.writeValueOf("LockedByPersonalName", personalName));
						tempXml.append(gen.writeValueOf("ExpiryDateTime", rs.getString(11)));
						userName = rs.getString(12);   /*WFS_8.0_039*/
						userInfo = (WFUserInfo) CachedObjectCollection.getReference().getCacheObject(con, engine, 0, WFSConstant.CACHE_CONST_UserCache, "userName" + string21 + userName).getData();
						if (userInfo!=null){
							personalName = userInfo.getPersonalName();
						}
						else {
							personalName = null;
						}
						tempXml.append(gen.writeValueOf("CreatedByUserName", userName));
						tempXml.append(gen.writeValueOf("CreatedByPersonalName", personalName));
						tempXml.append(gen.writeValueOf("CreationDateTime", rs.getString(13)));
						tempXml.append(gen.writeValueOf("WorkitemState", rs.getString(14)));
						tempXml.append(gen.writeValueOf("CheckListCompleteFlag", rs.getString(15)));
						tempXml.append(gen.writeValueOf("EntryDateTime", rs.getString(16)));
						tempXml.append(gen.writeValueOf("LockedTime", rs.getString(17)));
						tempXml.append(gen.writeValueOf("IntroductionDateTime", rs.getString(18)));
						userName = rs.getString(19);	/*WFS_8.0_039*/
						userInfo = (WFUserInfo) CachedObjectCollection.getReference().getCacheObject(con, engine, 0, WFSConstant.CACHE_CONST_UserCache, "userName" + string21 + userName).getData();
						if (userInfo!=null){
							personalName = userInfo.getPersonalName();
						}
						else {
							personalName = null;
						}
						tempXml.append(gen.writeValueOf("IntroducedBy", userName));
						tempXml.append(gen.writeValueOf("IntroducedByPersonalName", personalName));
						userName = rs.getString(20);   /*WFS_8.0_039*/
						userInfo = (WFUserInfo) CachedObjectCollection.getReference().getCacheObject(con, engine, 0, WFSConstant.CACHE_CONST_UserCache, "userName" + string21 + userName).getData();
						if (userInfo!=null){
							personalName = userInfo.getPersonalName();
						}
						else {
							personalName = null;
						}
						tempXml.append(gen.writeValueOf("AssignedTo", userName));
						tempXml.append(gen.writeValueOf("AssignedToPersonalName", personalName));
						tempXml.append(gen.writeValueOf("WorkItemId", rs.getString(21)));
						tempXml.append(gen.writeValueOf("QueueName", rs.getString(22)));
						tempXml.append(gen.writeValueOf("AssignmentType", rs.getString(23)));
						tempXml.append(gen.writeValueOf("ProcessInstanceState", rs.getString(24)));
						tempXml.append(gen.writeValueOf("QueueType", rs.getString(25)));
						tempXml.append(gen.writeValueOf("Status", rs.getString(26)));
						tempXml.append(gen.writeValueOf("QueueId", rs.getString(27)));
						tempXml.append(gen.writeValueOf("Turnaroundtime", rs.getString(28)));
						tempXml.append(gen.writeValueOf("Referredby", rs.getString(29)));
						tempXml.append(gen.writeValueOf("Referredto", rs.getString(30)));
						tempXml.append(gen.writeValueOf("TurnAroundDateTime", rs.getString("ExpectedWorkItemDelay")));
						userName = rs.getString("ProcessedBy");   /*WFS_8.0_052*/
						tempXml.append(gen.writeValueOf("Q_DivertedByUserId", rs.getString("Q_DivertedByUserId")));
						tempXml.append(gen.writeValueOf("ActivityType", rs.getString("ActivityType")));
						tempXml.append(gen.writeValueOf("CanInitiate",rs.getString("CanInitiate")));
						tempXml.append(gen.writeValueOf("CaseManager",rs.getString("CaseManager")));
						tempXml.append(gen.writeValueOf("ShowCaseVisual",rs.getString("ShowCaseVisual")));
						//Changes for Bug 57931: RETURNING LastModifiedTime and that will be sent in input in AssignWorkItemAttributes for Priority
						tempXml.append(gen.writeValueOf("LastModifiedTime",rs.getString("LastModifiedTime")));
						tempXml.append(gen.writeValueOf("URN", rs.getString("URN")));
						userInfo = (WFUserInfo) CachedObjectCollection.getReference().getCacheObject(con, engine, 0, WFSConstant.CACHE_CONST_UserCache, "userName" + string21 + userName).getData();
						if (userInfo!=null){
							personalName = userInfo.getPersonalName();
						}
						else {
							personalName = null;
						}
						tempXml.append(gen.writeValueOf("ProcessedBy", userName));
						tempXml.append(gen.writeValueOf("ProcessedByPersonalName", personalName));
						tempXml.append("<CaseVariables>");
						LinkedList<VariableClass> listOfCaseVariables = caseDataVariableMap.get(key);
						if(listOfCaseVariables!=null){						
						Iterator<VariableClass> caseVariablesIterator = listOfCaseVariables.iterator();
						while(caseVariablesIterator.hasNext()){
							VariableClass obj =caseVariablesIterator.next();
							String systemDefinedName = obj.getSystemDefinedName();
							String displayName = obj.getDisplayName();
							if((displayName=="")&&(displayName==null)){
								displayName = obj.getUserDefinedName();
							}
							String caseVariableValue = rs.getString(systemDefinedName);
							if(caseVariableValue!=null || displayName!=null){
							tempXml.append("<CaseVariable>");
							tempXml.append(gen.writeValueOf("DisplayName", displayName));
							tempXml.append(gen.writeValueOf("Value", WFSUtil.handleSpecialCharInXml(caseVariableValue)));
							tempXml.append("</CaseVariable>");
							}

						}
						}
						tempXml.append("</CaseVariables>");
						tempXml.append("<Data>\n");
						//				Code added for Processmanager functionality for fetching workitems based on logged in user for WSE_5.0.1_003
						for (int k = 0; k < nRSize - 33	; k++) {
							tempXml.append("<QueueData>\n");
							tempXml.append(gen.writeValueOf("Name", rsmd.getColumnLabel(34 + k)));
							tempXml.append(gen.writeValueOf("Value", rs.getString(34 + k)));
							tempXml.append("\n</QueueData>\n");
						}
						tempXml.append("</Data>\n");
						tempXml.append("</Instrument>\n");
						j++;
						tot++;
					}			

				}			


				if (rs.next()) {
					tot++;
				}
				if (rs != null) {
					rs.close();
				}
				if (j > 0) {
					if(!stdParserFlag){	
						tempXml.insert(0, "<Instruments>\n");
						tempXml.append("</Instruments>\n");
					}
				} else{
					mainCode = WFSError.WM_NO_MORE_DATA;
					subCode = 0;
					subject = WFSErrorMsg.getMessage(mainCode);
					descr = WFSErrorMsg.getMessage(subCode);
					errType = WFSError.WF_TMP;
				}
				if(stdParserFlag){
					tempXml.append(WFXMLUtil.getXmlStringforDOMDocument(doc));	
				}
				tempXml.append(gen.writeValueOf("RetrievedCount", String.valueOf(j)));
				tempXml.append(gen.writeValueOf("Count", String.valueOf(tot)));
				tempXml.append(gen.writeValueOf("WorkitemCount", String.valueOf(returnCount))); /*Bugzilla Bug 1680*/
				tempXml.append(gen.writeValueOf("AliasProcessDefId", String.valueOf(aliasProcessDefId)));
			}
                        if (dbType == JTSConstant.JTS_POSTGRES) {
                            con.commit();
                            con.setAutoCommit(true);
			}
			if (mainCode == 0 || mainCode == 18) {
				outputXML.append(gen.createOutputFile(optionTag));
				outputXML.append("<Exception>\n<MainCode>"+mainCode+"</MainCode>\n</Exception>\n");
				outputXML.append(tempXml);
				outputXML.append(gen.closeOutputFile(optionTag));
			}
		} catch (SQLException e) { 
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WM_INVALID_FILTER;
            subCode = WFSError.WFS_SQL;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_FAT;
            if (e.getErrorCode() == 0) {
                if (e.getSQLState().equalsIgnoreCase("08S01")) {
                    descr = (new JTSSQLError(e.getSQLState())).getMessage() + "(SQL State : " + e.getSQLState() + ")";
                }
            } else {
                descr = e.getMessage();
            }
        } catch (NumberFormatException e) {
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_ILP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch (NullPointerException e) {
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_SYS;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch (WFSException e) {
            WFSUtil.printOut(engine, e);
            mainCode = e.getMainErrorCode();
            subCode = e.getSubErrorCode();
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = e.getTypeOfError();
            descr = WFSErrorMsg.getMessage(subCode);
        } catch (JTSException e) {
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = e.getErrorCode();
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.getMessage();
        } catch (Exception e) {
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_EXP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } finally {
            try {
                if (rs != null) {
                    rs.close();
                    rs = null;
                }
                if (stmt != null) {
                    stmt.close();
                    stmt = null;
                }
                if (cstmt != null) {
                    cstmt.close();
                    cstmt = null;
                }
            } catch (Exception e) {
                WFSUtil.printErr(engine,"", e);
            }
            if (mainCode != 0 && mainCode != 18) {
	            String errorString = WFSUtil.generalError(optionTag, engine, gen,mainCode, subCode,errType, subject,descr);
				outputXML = new StringBuilder(errorString);
            }
        }
        return outputXML.toString();
    }

    /**
     * *************************************************************
     * Function Name    :	WFGetWorkItemData
     * Programmer' Name :   Varun Bhansaly
     * Date Written     :   04/12/2007
     * Input Parameters :   con						-> SQL Connection,
    dbType					-> Database Type,
    processInstanceId		-> To identify the WI,
    workItemId				-> To identify the WI,
    processDefId			-> Process Def. Id
    activityId				-> Activity Id
    userIndex				-> User Index
    objectPreferenceList	-> User Preferences
    queryQueueHistoryTable	-> True  - Query QueueHistoryTable
     * Output Parameters:   NONE
     * Return Value     :   PreparedStatement[]
     * Description      :   PreparedStatement[0] - User Preferences
    PreparedStatement[1] - ProcessInstance Data
    PreparedStatement[2] - Queue Varaiables Data
    PreparedStatement[3] - ToDo Data
    PreparedStatement[4] - Exception Data
    PreparedStatement[5] - Comments Data
     * *************************************************************
     */
    private PreparedStatement[] WFGetWorkItemData(Connection con, int dbType, String processInstanceId, int workItemId, int processDefId, int activityId, int userIndex, String objectPreferenceList, boolean queryQueueHistoryTable) throws SQLException {
        PreparedStatement[] pstmt = {null, null, null, null, null, null};
        String objectName = "";
        String query1 = "";
        String tableName = "";

        query1 = " Select ObjectId, ObjectName, ObjectType, NotifyByEmail, Data From	UserPreferencesTable " + WFSUtil.getTableLockHintStr(dbType) + "  Where userId = " + userIndex + " AND ObjectName = " + WFSUtil.TO_STRING((processDefId + "@" + activityId), true, dbType) + " AND ObjectType in ( " + objectPreferenceList + " )";
        pstmt[0] = con.prepareStatement(query1);
        pstmt[0].execute();
        if (!queryQueueHistoryTable) {
            query1 = "SELECT CreatedByName, ExpectedProcessDelay, Introducedby, IntroductionDatetime, ProcessInstanceState From	ProcessInstanceTable " + WFSUtil.getTableLockHintStr(dbType) + "  Where ProcessInstanceId = ?";
        } else {
            query1 = "SELECT CreatedByName, NULL AS ExpectedProcessDelay, Introducedby, IntroductionDatetime, ProcessInstanceState From QueueHistoryTable " + WFSUtil.getTableLockHintStr(dbType) + "  Where ProcessInstanceId = ? AND WorkItemId = ?";
        }
        pstmt[1] = con.prepareStatement(query1);
        pstmt[1].setString(1, processInstanceId);
        if (queryQueueHistoryTable) {
            pstmt[1].setInt(2, workItemId);
        }
        pstmt[1].execute();

        if (!queryQueueHistoryTable) {
            //tableName = "QueueDataTable";
            tableName = "WFInstrumentTable";
        } else {
            tableName = "QueueHistoryTable";
        }
        query1 = "SELECT ReferredByName, ReferredTo, CheckListCompleteFlag, HoldStatus, InstrumentStatus, ParentWorkItemID, ProcessInstanceId, SaveStage, Status, VAR_REC_1, VAR_REC_2 FROM " +
                tableName + " WHERE ProcessInstanceId = ? AND WorkItemId = ?";
        pstmt[2] = con.prepareStatement(query1);
        pstmt[2].setString(1, processInstanceId);
        pstmt[2].setInt(2, workItemId);
        pstmt[2].execute();

        query1 = "SELECT ToDoValue FROM	ToDoStatusView WHERE ProcessInstanceId = ?";
        pstmt[3] = con.prepareStatement(query1);
        pstmt[3].setString(1, processInstanceId);
        pstmt[3].execute();

        query1 = "SELECT ExceptionId, ExcpSeqId, ActionId, ActivityTable.ActivityName AS ActivityName, UserName, ActionDateTime, ExceptionName, ExceptionComments, FinalizationStatus FROM	ExceptionTable " + WFSUtil.getTableLockHintStr(dbType) + " , ActivityTable " + WFSUtil.getTableLockHintStr(dbType) + "  WHERE	ExceptionTable.ProcessDefId	= ? AND	ActivityTable.ActivityId = ExceptionTable.activityId AND	ActivityTable.ProcessDefId = ExceptionTable.ProcessDefId AND ProcessInstanceId = ? ORDER BY exceptionid, excpseqid DESC";
        pstmt[4] = con.prepareStatement(query1);
        pstmt[4].setInt(1, processDefId);
        pstmt[4].setString(2, processInstanceId);
        pstmt[4].execute();

        query1 = "SELECT Comments, CommentsBy, CommentsByName, CommentsTo, CommentsToName, CommentsType, ActionDateTime FROM WFCommentsTable WHERE ProcessInstanceId = ? AND ActivityId = ? Order By CommentsId DESC";
        pstmt[5] = con.prepareStatement(query1);
        pstmt[5].setString(1, processInstanceId);
        pstmt[5].setInt(2, activityId);
        pstmt[5].execute();

        return pstmt;
    }
	//----------------------------------------------------------------------------------------------------
//	Function Name 				:	WMUnAssignWorkitem
//	Date Written (DD/MM/YYYY)	:	14/10/2009
//	Author						:	Nishant kumar Singh
//	Input Parameters			:	Connection , XMLParser , XMLGenerator
//	Output Parameters			:   none
//	Return Values				:	String
//	Description					:   Unassigns WorkItem to a User
//----------------------------------------------------------------------------------------------------
// Change Summary *
//----------------------------------------------------------------------------
 public String WMUnAssignWorkitem(Connection con, XMLParser parser,
                                     XMLGenerator gen) throws JTSException, WFSException{
	 StringBuffer outputXML = new StringBuffer("");
        PreparedStatement pstmt = null;
        PreparedStatement pstmt1 = null;
        int mainCode = 0;
        int subCode = 0;
        String subject = null;
        String descr = null;
        String errType = WFSError.WF_TMP;
		ArrayList parameters = new ArrayList();
		String queryString;
		Boolean printQueryFlag = true;
		String engine = null;
		ResultSet rs1 = null;
		String option = parser.getValueOf("Option", "", false);
		try {
            int sessionID = parser.getIntOf("SessionId", 0, false);
            String procInstID = parser.getValueOf("ProcessInstanceId", "", false);
            int wrkItemID = parser.getIntOf("WorkItemId", 0, false);
            engine = parser.getValueOf("EngineName");
            int dbType = ServerProperty.getReference().getDBType(engine);
			int queueId = -1;
			int q_UserId= -1;
			int procDefID=-1,activityId=-1;
			String queueName = "", queueType="", filterValue="", actName="";
            WFParticipant participant = WFSUtil.WFCheckSession(con, sessionID);
            int indx = procInstID.indexOf(" ");
            int activityType=0;
            if(indx > -1){
            	procInstID = procInstID.substring(0, indx);
			}
            if (participant != null && participant.gettype() == 'U'){
                int userID = participant.getid();
                String username = participant.getname();
                boolean partOfAdminGroup = isPartOfAdminGroup(con,dbType,userID);
				/*pstmt = con.prepareStatement(
						"Select Processdefid, Activityid,Q_StreamId,"
					  + "ActivityName,'Worklisttable',Q_QueueID, QueueName, "
					  + " QueueType, FilterValue from Worklisttable "
				 	  + " where ProcessInstanceID=? and WorkItemID =? AND Q_UserId = ? UNION "
					  + " Select Processdefid,Activityid,Q_StreamId, "
					  + " ActivityName,'WorkinProcesstable', Q_QueueID, "
					  + " QueueName, QueueType, FilterValue from WorkinProcesstable "
                      + " where ProcessInstanceID=? and WorkItemID =? AND Q_UserId = ? ");
				*/
				queryString = "Select Processdefid, Activityid,Q_StreamId,"
					  + "ActivityName,Q_QueueID, QueueName, "
					  + " QueueType, FilterValue,activityType,Q_UserId from WFInstrumentTable "
				 	  + " where ProcessInstanceID=? and WorkItemID =? and RoutingStatus ="+WFSUtil.TO_STRING("N",true, dbType);
				pstmt = con.prepareStatement(queryString);
  				WFSUtil.DB_SetString(1, procInstID, pstmt, dbType);
				pstmt.setInt(2, wrkItemID);
				//pstmt.setInt(3, userID);
				//WFSUtil.DB_SetString(4, procInstID, pstmt, dbType);
                //pstmt.setInt(5, wrkItemID);
                //pstmt.setInt(6, userID);
				parameters.addAll(Arrays.asList(procInstID,wrkItemID,userID));
				WFSUtil.jdbcExecute(procInstID,sessionID,userID,queryString,pstmt,parameters,printQueryFlag,engine);
				//pstmt.execute();
				ResultSet rs = pstmt.getResultSet();
				if (rs.next()){
					q_UserId=rs.getInt("Q_UserId");
                    boolean unassignAllowed =false;
                    if(partOfAdminGroup){
                    	unassignAllowed=true;
                    }
					if(q_UserId!=userID){
						StringBuilder tempXML = new StringBuilder ();
	                     tempXML.append("<?xml version=\"1.0\"?>");
	                     tempXML.append("<NGOGetUserProperty_Input>");
	                     tempXML.append("<Option>NGOGetUserProperty</Option>");
	                     tempXML.append("<CabinetName>" + engine+ "</CabinetName>");
	                     tempXML.append("<UserDBId>" + sessionID + "</UserDBId>");
	                     tempXML.append("<UserIndex>"+q_UserId+"</UserIndex>");    //Changes Done by Anju
	                     tempXML.append("<DataAlsoFlag>Y</DataAlsoFlag>");
	                     tempXML.append("</NGOGetUserProperty_Input>");
	                     parser.setInputXML(tempXML.toString());
	                     parser.setInputXML(WFFindClass.getReference().execute("NGOGetUserProperty", engine, con, parser, gen));
	                     if (parser.getValueOf("Status").equalsIgnoreCase("0")) {
	                         boolean isSuperiorDefined = parser.getValueOf("SuperiorFlag").equalsIgnoreCase("U")||parser.getValueOf("SuperiorFlag").equalsIgnoreCase("G");
	                         if(!isSuperiorDefined && !partOfAdminGroup){
	                         	mainCode = WFSError.WF_NO_AUTHORIZATION;
	                         	subCode = 0;
	                         }
	                         else{
	                         	if(parser.getValueOf("SuperiorFlag").equalsIgnoreCase("U")){
	                         		if(userID== parser.getIntOf("SuperiorIndex",0,true)){
	                         			unassignAllowed = true;
	                         		}
	                         	}
	                         	else if(parser.getValueOf("SuperiorFlag").equalsIgnoreCase("G")){
	                         		int userIdWithAssignRights = parser.getIntOf("SuperiorIndex",0,true);
	                         		String groupRoleId= parser.getValueOf("GroupRoleIndex","",true);
	                         		tempXML = new StringBuilder ();
	                         		tempXML.append("<NGOGetUserProperty_Input>");
	                         		tempXML.append("<Option>NGOGetUserProperty</Option>");
	                         		tempXML.append("<CabinetName>" + engine+ "</CabinetName>");
	                         		tempXML.append("<UserDBId>" + sessionID + "</UserDBId>");
	                         		tempXML.append("<UserIndex>"+userIdWithAssignRights+"</UserIndex>"); 
	                         		tempXML.append("<DataAlsoFlag>Y</DataAlsoFlag>");
	                         		tempXML.append("</NGOGetUserProperty_Input>");
	                         		parser.setInputXML(tempXML.toString());
	                         		parser.setInputXML(WFFindClass.getReference().execute("NGOGetUserProperty", engine, con, parser, gen));
	                         		XMLParser roleParser = new XMLParser(parser.getValueOf("RoleInfo","",true));
	                         		int startIndex=0;
	                         		int endIndex=0;
	                         		int startAttrIndex=0;
	                         		int endAttrIndex=0;
	                         		HashMap<String,String> roles= new HashMap<String, String>();
	                         		if(roleParser !=null){
	                         			int noOfRoles = parser.getNoOfFields("Role", startIndex, endIndex);
	                         			if(noOfRoles >0){
	                         				roles = new java.util.HashMap();
	                         				for(int j=0; j < noOfRoles ; j++){ 
	                         					startAttrIndex = parser.getStartIndex("Role", endAttrIndex , endIndex);
	                         					endAttrIndex = parser.getEndIndex("Role", startAttrIndex , endIndex);
	                         					String userGroupRoleId = parser.getValueOf("GroupRoleId", startAttrIndex, endAttrIndex).trim();
	                         					if(userGroupRoleId .equalsIgnoreCase(groupRoleId)){
	                         						String roleId = parser.getValueOf("RoleId", startAttrIndex, endAttrIndex).trim();
	                         						String groupIndex = parser.getValueOf("GroupIndex", startAttrIndex, endAttrIndex).trim();
	                         						roles.put(roleId, groupIndex);
	                         					}
	                         				}
	                         			}

	                         		}
	                         		tempXML = new StringBuilder ();
	                         		tempXML.append("<NGOGetUserProperty_Input>");
	                         		tempXML.append("<Option>NGOGetUserProperty</Option>");
	                         		tempXML.append("<CabinetName>" + engine+ "</CabinetName>");
	                         		tempXML.append("<UserDBId>" + sessionID + "</UserDBId>");
	                         		tempXML.append("<UserIndex>"+userID+"</UserIndex>");   
	                         		tempXML.append("<DataAlsoFlag>Y</DataAlsoFlag>");
	                         		tempXML.append("</NGOGetUserProperty_Input>");
	                         		parser.setInputXML(tempXML.toString());
	                         		parser.setInputXML(WFFindClass.getReference().execute("NGOGetUserProperty", engine, con, parser, gen));
	                         		roleParser = new XMLParser(parser.getValueOf("RoleInfo",null,true));
	                         		startIndex=0;
	                         		endIndex=0;
	                         		startAttrIndex=0;
	                         		endAttrIndex=0;
	                         		HashMap<String,String> loggedInUserRoles= new HashMap<String, String>();
	                         		if(roleParser !=null){
	                         			int noOfRoles = parser.getNoOfFields("Role", startIndex, endIndex);
	                         			if(noOfRoles >0){
	                         				for(int j=0; j < noOfRoles ; j++){ 
	                         					startAttrIndex = parser.getStartIndex("Role", endAttrIndex , endIndex);
	                         					endAttrIndex = parser.getEndIndex("Role", startAttrIndex , endIndex);
	                         					String roleId = parser.getValueOf("RoleId", startAttrIndex, endAttrIndex).trim();
	                         					if(roles.containsKey(roleId)){
	                         						String groupIndex = parser.getValueOf("GroupIndex", startAttrIndex, endAttrIndex).trim();
	                         						if(groupIndex.equalsIgnoreCase(roles.get(roleId))){
	                         							unassignAllowed=true;
	                         						}

	                         					}

	                         				}
	                         			}
	                         		}

	                         	}
	                         		
	                         }
	                     }
						}	else{
						unassignAllowed=true;
					}
					/*IF q_UserId IS NOT the same as that of logged in User:
					 * Call NGOGetUserProperty for the q_UserId
					 * Check SupervisorFlag .
					 * If it is U , then check if Supervisor Id is equal to User Id of  logged in User
					 * If it is G , then check if User belongs to group mentioned in Supervisor Id
					 * In both these cases allow user to unassig the workitem
					 * Ohterwise , No Authrization
					 * 
					*/
					if(unassignAllowed){
						procDefID = rs.getInt(1);
						activityId = rs.getInt(2);
						int qStreamId = rs.getInt(3);
						actName = rs.getString(4);
						//tableName = rs.getString(5);
						queueId = rs.getInt(5);
						queueName = rs.getString(6);
						queueType = rs.getString(7);
						filterValue = rs.getString(8);
						activityType=rs.getInt(9);
						rs.close();
						pstmt.close();
						if(queueId <= 0){
							pstmt = con.prepareStatement(
									" Select A.QueueId, QueueName, QueueType, FilterValue "
											+ " from QueueStreamTable A, QueueDefTable B "
											+ " where A.queueId = B.QueueId "
											+ " And ProcessDefId = ? And ActivityId = ? And StreamId = ?");
							pstmt.setInt(1, procDefID);
							pstmt.setInt(2, activityId);
							pstmt.setInt(3, qStreamId);
							pstmt.execute();
							rs = pstmt.getResultSet();
							if (rs.next()){
								queueId = rs.getInt(1);
								queueName = rs.getString(2);
								queueType = rs.getString(3);
								filterValue = rs.getString(4);
							}else{
								mainCode = WFSError.WM_INVALID_WORKITEM;
								subCode = 0;
							}
						}
						
						if (rs != null)
							rs.close();
						pstmt.close();
					}else{
						mainCode = WFSError.WF_NO_AUTHORIZATION;
						subCode = 0;
					}
					
				}
				if (mainCode == 0){
					/*if (tableName.equalsIgnoreCase("Worklisttable")){
						if (con.getAutoCommit())
							con.setAutoCommit(false);
							/* 17/12/2012, Sajid Khan, Bug 36355 - Changes done in query, we were passing column name instead of column's value.*/
							/*Bug 40338*-/
							if(filterValue!=null && filterValue.trim().equals("")){
								filterValue = "null";
							}
						pstmt = con.prepareStatement(
								"Update Worklisttable Set AssignmentType = "
							  + WFSConstant.WF_VARCHARPREFIX + "S',"
							  + "Q_QueueId =  ?, Q_UserId = ?,  AssignedUser = null, "
							  + "FilterValue = (Select " + filterValue + " From QueueDataTable Where ProcessInstanceID = ? and WorkItemID = ?), WorkItemState = 1,  Statename = "
							  + WFSConstant.WF_VARCHARPREFIX + WFSConstant.WF_NOTSTARTED + "', "
							  + " Queuename = ?, Queuetype = ?, NotifyStatus = " + WFSConstant.WF_VARCHARPREFIX + "N'"
							  + " where ProcessInstanceID = ? and WorkItemID = ? ");

						pstmt.setInt(1, queueId);
						pstmt.setInt(2, 0);
						//WFSUtil.DB_SetString(3, filterValue, pstmt, dbType);  BUG 36355 , filtervalue issue.
						WFSUtil.DB_SetString(3, procInstID, pstmt, dbType);
						pstmt.setInt(4, wrkItemID);
						WFSUtil.DB_SetString(5, queueName, pstmt, dbType);
						WFSUtil.DB_SetString(6, queueType, pstmt, dbType);
						WFSUtil.DB_SetString(7, procInstID, pstmt, dbType);
						pstmt.setInt(8, wrkItemID);
						int res = pstmt.executeUpdate();
						if (res > 0 ){
							if (!con.getAutoCommit()){
								con.commit();
								con.setAutoCommit(true);
							}
	//							WFSUtil.genLog(engine, con, procDefID, procInstID, activityId,
//							   actName,
//							   WFSConstant.WFL_WorkItemUnassigned, userID, 0, null,
//							   wrkItemID,  username);
								WFSUtil.generateLog(engine, con, WFSConstant.WFL_WorkItemUnassigned,
								procInstID, wrkItemID,
								procDefID, activityId, actName, queueId,
								userID, username, 0, null,
								WFSUtil.getDate(dbType), "", "", "");
                                                        
						}else{
							mainCode = WFSError.WM_INVALID_WORKITEM;
							subCode = WFSError.WFS_NOQ;
							if (!con.getAutoCommit()){
								con.rollback();
								con.setAutoCommit(true);
							}
						}
						pstmt.close();
					}else{
						if (con.getAutoCommit())
							con.setAutoCommit(false);
							//Process Variant Support
						pstmt = con.prepareStatement(
							"Insert into Worklisttable (ProcessInstanceId,"
							+
							"WorkItemId,ProcessName,ProcessVersion,ProcessDefID,LastProcessedBy,"
							+
							"ProcessedBy,ActivityName,ActivityId,EntryDateTime,ParentWorkItemId,"
							+
							"AssignmentType,CollectFlag,PriorityLevel,ValidTill,Q_StreamId,Q_QueueId,"
							+
							"Q_UserId,AssignedUser,FilterValue,CreatedDateTime,WorkItemState,"
							+
							"Statename,ExpectedWorkitemDelay,PreviousStage,LockedByName,Queuename,Queuetype,NotifyStatus, ProcessVariantId) Select "
							+
							"ProcessInstanceId,WorkItemId,ProcessName,ProcessVersion,ProcessDefID,"
							+ "LastProcessedBy,ProcessedBy,ActivityName,ActivityId,"
							+ "EntryDatetime,ParentWorkItemId,"
							+ WFSConstant.WF_VARCHARPREFIX
							+ "S',CollectFlag,PriorityLevel,ValidTill,Q_StreamId,"
							+ "?,0,null,?,CreatedDateTime,1,"
							+ WFSConstant.WF_VARCHARPREFIX + WFSConstant.WF_NOTSTARTED
							+ "',ExpectedWorkitemDelay,"
							+ "PreviousStage,null,?,?,"+ WFSConstant.WF_VARCHARPREFIX + "N' "
							+" , ProcessVariantId from WorkinProcesstable where ProcessInstanceID = ? and WorkItemID = ? ");

						pstmt.setInt(1, queueId);
						WFSUtil.DB_SetString(2, filterValue, pstmt, dbType);
						WFSUtil.DB_SetString(3, queueName, pstmt, dbType);
						WFSUtil.DB_SetString(4, queueType, pstmt, dbType);
						WFSUtil.DB_SetString(5, procInstID, pstmt, dbType);
						pstmt.setInt(6, wrkItemID);
						int res = pstmt.executeUpdate();
						pstmt.close();

						if (res > 0){
							pstmt = con.prepareStatement("Delete from  WorkinProcesstable where ProcessInstanceID = ? and WorkItemID = ? ");
							WFSUtil.DB_SetString(1, procInstID, pstmt, dbType);
							pstmt.setInt(2, wrkItemID);
							int f = pstmt.executeUpdate();
							pstmt.close();
							if (res == f ){
								if (!con.getAutoCommit()){
									con.commit();
									con.setAutoCommit(true);
								}
								WFSUtil.genLog(engine, con, procDefID, procInstID, activityId,
								   actName,
								   WFSConstant.WFL_WorkItemUnassigned, userID, 0, null,
								   wrkItemID,  username);
							}else{
								mainCode = WFSError.WM_INVALID_WORKITEM;
								subCode = WFSError.WFS_NOQ;
								if (!con.getAutoCommit()){
									con.rollback();
									con.setAutoCommit(true);
								}
							}
						}else{
							mainCode = WFSError.WM_INVALID_WORKITEM;
							subCode = WFSError.WFS_NOQ;
							if (!con.getAutoCommit()){
								con.rollback();
								con.setAutoCommit(true);
							}
						}
					}
				}*/
					/* 17/12/2012, Sajid Khan, Bug 36355 - Changes done in query, we were passing column name instead of column's value.*/
					/*Bug 40338*/
					if(filterValue!=null && filterValue.trim().equals("")){
						filterValue = "null";
					}
						if (con.getAutoCommit())
							con.setAutoCommit(false);
						if(activityType==WFSConstant.ACT_CASE)
						{
							pstmt1=con.prepareStatement("select TaskStatus from WFTaskStatusTable where processinstanceid= ? and workitemid= ? and  processdefid= ? and activityId= ? and TaskStatus in( 2, 3)");
							WFSUtil.DB_SetString(1, procInstID, pstmt1, dbType);
							pstmt1.setInt(2, wrkItemID);
							pstmt1.setInt(3, procDefID);
							pstmt1.setInt(4, activityId);
							pstmt1.execute();
							 rs1 = pstmt1.getResultSet();
							if(rs1.next())
							{
									mainCode = WFSError.WF_CASE_RELEASE_NOT_ALLOWED;
									subCode = 0;
									subject = WFSErrorMsg.getMessage(mainCode);
									descr = WFSErrorMsg.getMessage(subCode);
									errType = WFSError.WF_TMP;
									String errorString = WFSUtil.generalError(option, engine, gen,mainCode, subCode,errType, subject,descr);
									return errorString;
							}		
						}
						
						queryString = "Update WFInstrumentTable Set AssignmentType = "
							  + WFSConstant.WF_VARCHARPREFIX + "S',"
							  + "Q_QueueId =  ?, Q_UserId = ?,  AssignedUser = null, LockedByName = null , LockStatus ='N', LockedTime =null"
							  + ", FilterValue = " + TO_SANITIZE_STRING(filterValue, true) + ", WorkItemState = 1,  Statename = "
							  + WFSConstant.WF_VARCHARPREFIX + WFSConstant.WF_NOTSTARTED + "', "
							  + " Queuename = ?, Queuetype = ?, NotifyStatus = " + WFSConstant.WF_VARCHARPREFIX + "N'"
							  + " where ProcessInstanceID = ? and WorkItemID = ? ";
						pstmt = con.prepareStatement(queryString);
						parameters = new ArrayList();
						parameters.addAll(Arrays.asList(queueId,0,procInstID,wrkItemID,queueName,queueType,procInstID,wrkItemID));
						pstmt.setInt(1, queueId);
						pstmt.setInt(2, 0);
						//WFSUtil.DB_SetString(3, filterValue, pstmt, dbType);  BUG 36355 , filtervalue issue.
						WFSUtil.DB_SetString(3, queueName, pstmt, dbType);
						WFSUtil.DB_SetString(4, queueType, pstmt, dbType);
						WFSUtil.DB_SetString(5, procInstID, pstmt, dbType);
						pstmt.setInt(6, wrkItemID);
						//int res = pstmt.executeUpdate();
						int res = WFSUtil.jdbcExecuteUpdate(procInstID,sessionID,userID,queryString,pstmt,parameters,printQueryFlag,engine);
						if (res > 0 ){
							if (!con.getAutoCommit()){
								con.commit();
								con.setAutoCommit(true);
							}
	//							WFSUtil.genLog(engine, con, procDefID, procInstID, activityId,
//							   actName,
//							   WFSConstant.WFL_WorkItemUnassigned, userID, 0, null,
//							   wrkItemID,  username);
								WFSUtil.generateLog(engine, con, WFSConstant.WFL_WorkItemUnassigned,
								procInstID, wrkItemID,
								procDefID, activityId, actName, queueId,
								userID, username, 0, null,
								WFSUtil.getDate(dbType), "", "", "");
                                                        
						}else{
							mainCode = WFSError.WM_INVALID_WORKITEM;
							subCode = WFSError.WFS_NOQ;
							if (!con.getAutoCommit()){
								con.rollback();
								con.setAutoCommit(true);
							}
						}
						pstmt.close();
					
				}
			}else{
                mainCode = WFSError.WM_INVALID_SESSION_HANDLE;
                subCode = 0;
                subject = WFSErrorMsg.getMessage(mainCode);
                descr = WFSErrorMsg.getMessage(subCode);
                errType = WFSError.WF_TMP;
			}

			if (mainCode == 0){
                outputXML = new StringBuffer(500);
                outputXML.append(gen.createOutputFile("WMUnAssignWorkItem"));
                outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
                outputXML.append(gen.closeOutputFile("WMUnAssignWorkItem"));
            }else{
				    subject = WFSErrorMsg.getMessage(mainCode);
                    descr = WFSErrorMsg.getMessage(subCode);
                    errType = WFSError.WF_TMP;
			}
		}
		catch (SQLException e) {
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WM_INVALID_FILTER;
            subCode = WFSError.WFS_SQL;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_FAT;
            if (e.getErrorCode() == 0){
                if (e.getSQLState().equalsIgnoreCase("08S01")){
                    descr = (new JTSSQLError(e.getSQLState())).getMessage() + "(SQL State : "
                        + e.getSQLState()
                        + ")";
                }
            }else{
                descr = e.getMessage();
            }
        }catch (NumberFormatException e){
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_ILP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        }catch (NullPointerException e){
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_SYS;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        }catch (JTSException e){
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = e.getErrorCode();
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.getMessage();
        }catch (Exception e){
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_EXP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        }catch (Error e){
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_EXP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        }finally{
            try{

                if (!con.getAutoCommit()){
                    con.rollback();
                    con.setAutoCommit(true);
                }
               
            }catch (Exception e){}
           
            try{
                if (rs1 != null){
                	rs1.close();
                	rs1 = null;
                }
            }catch (Exception e){}

            try{
                if (pstmt != null){
                    pstmt.close();
                    pstmt = null;
                }
            }catch (Exception e){}
            try{
                if (pstmt1 != null){
                    pstmt1.close();
                    pstmt1 = null;
                }
            }catch (Exception e){}
        }
        if (mainCode != 0){
            //throw new WFSException(mainCode, subCode, errType, subject, descr);
			String errorString = WFSUtil.generalError(option, engine, gen,mainCode, subCode,errType, subject,descr);
			return errorString;
        }
        return outputXML.toString();
 }
 
	//----------------------------------------------------------------------------------------------------
//	Function Name 				:	getWIData
//	Date Written (DD/MM/YYYY)	:	13/06/2014
//	Author						:	Mohnish Chopra
//	Input Parameters			:	Connection ,String ,int ,int ,String 
//	Output Parameters			:   none
//	Return Values				:	ResultSet
//	Description					:   Returns WorkItem 
//----------------------------------------------------------------------------------------------------
//Change Summary *
//----------------------------------------------------------------------------
 public ResultSet getWIData(Connection tarConn,String processInstanceId,int workitemId,int dbType,String engine) {
     List data= new ArrayList();
     PreparedStatement pstmt=null;
     ResultSet rs=null;
     try {
         StringBuffer QueryOnWFIT=new StringBuffer();
         QueryOnWFIT.append("select * from QueueHistoryTable where processInstanceId= ? and workitemId= ?");
         pstmt= tarConn.prepareStatement(QueryOnWFIT.toString());
         WFSUtil.DB_SetString(1, processInstanceId, pstmt, dbType);
         pstmt.setInt(2, workitemId);
         pstmt.execute();
         rs = pstmt.getResultSet();
         /*if(rs==null || !rs.next()) {
             pstmt= tarConn.prepareStatement(QueryOnPWD.toString());
             WFSUtil.DB_SetString(1, processInstanceId, pstmt, dbType);
             pstmt.setInt(2, workitemId);
             pstmt.execute();
             rs = pstmt.getResultSet();
         }*/
     }
         catch(Exception e) {
            // e.printStackTrace();
             WFSUtil.printErr(engine,"Some Error occurred while calling getWIData() : "+e);
}
finally {

}
return rs;
}
  //----------------------------------------------------------------------------------------------------
    //	Function Name 				:	WFHoldWorkitem
    //	Date Written (DD/MM/YYYY)               :	05 Nov 2015
    //	Author					:	Sajid Khan
    //	Input Parameters			:	Connection , XMLParser , XMLGenerator
    //	Output Parameters			:       none
    //	Return Values				:	String
    //	Description				:       Hold the workitem either temporarily to my queue or any selected Hold Activity.
    //----------------------------------------------------------------------------------------------------
 /***********************************************************************************************************************
  * Two Types of Hold has been introduced:[From WebDesktop]
	->Tempory Hold - It will hold  the workitem to a user’s My Queue
	->ActivityHold - It will move the workitem to Hold WOrkstep.
	
	Temporary Hold[User Hold] :WFHoldWorkitem API with <HoldType> as T:
		When workitem is hold temporarily by any user .
		Q_QueueId – 0 
		Q-UserId – UserId
		AssignmentType = H
		 Statename – THOLDED
		WorktiemState – 8
		RoutingStaus – N
		LockStatus – N

		
AcitivityHold[Workstep Hold]:WFHoldWorkitem with <HoldType> as A:
		RoutingStatus- Y
		LockStatus – N
		ACtivityId and ACtivityName – Target ones
		AsssignmentType – D
                Q_QueuId - 0
Note: Changs to be done in OracreateWorkitem for targetActivitytype = Hold as there were no queues before for Hold Workstep
.WFHoldWorkitems API to Hold Wroktiems from a normal 
Queue to Hold queue or Temporary Hold on My Queue.						
 			
i). To   Hold a workitem to  any Hold Workstep , WMGetActivityList API should be called with  ActivityTYpe = 4 to fetch the lists of Hold Worksteps. 
	<WMGetActivityList_Input>
		<Option>WMGetActivityList</Option>
                <EngineName>sqlcab15july</EngineName>
                <SessionId>-344889690</SessionId>
		<ZipBuffer>N</ZipBuffer><RightFlag>010100</RightFlag>
                <ProcessDefinitionID>25</ProcessDefinitionID>
		<ProcessName>25</ProcessName>
                <ActivityType>4</ActivityType>
                <BatchInfo><OrderBy>2</OrderBy><SortOrder>A</SortOrder>
                <NoOfRecordsToFetch>10</NoOfRecordsToFetch></BatchInfo>
		<DataFlag>N</DataFlag>
	</WMGetActivityList_Input>
	
	<WMGetActivityList_Output>
		<Option>WMGetActivityList</Option>
		<Exception>
		<MainCode>0</MainCode>
		</Exception>
		<CacheTime>2015-10-26 14:09:33</CacheTime>
		<ActivityList>
		<ActivityInfo>
			<ID>2</ID><Name>Hold_1</Name><EntityName></EntityName>
                        <ActivityTATCalFlag>N</ActivityTATCalFlag><ActivityType>4</ActivityType>
			<ProcessDefinitionID>25</ProcessDefinitionID>
                        <ProcessName>TestHoldProcess</ProcessName>
                        <VersionNo>1</VersionNo>
		</ActivityInfo>
		<ActivityInfo>
			<ID>4</ID><Name>Hold_4</Name><EntityName></EntityName>
                        <ActivityTATCalFlag>N</ActivityTATCalFlag><ActivityType>4</ActivityType>
			<ProcessDefinitionID>25</ProcessDefinitionID>
                        <ProcessName>TestHoldProcess</ProcessName>
                        <VersionNo>1</VersionNo>
		</ActivityInfo>
		</ActivityList>
		<TotalCount>2</TotalCount><RetrievedCount>2</RetrievedCount>
	</WMGetActivityList_Output>





ii).Once the Hold Activity is selected for a workitem to move them to it  , WFHoldWorkItem API  should be called.
	<WFHoldWorkitem_Input>
		<Option> WFHoldWorkitem </Option>
		<EngineName>casemgmt06oct</EngineName>
		<SessionId>-562151966</SessionId>
                <ProcessDefId>12</ProcessDefId>
		<ProcessInstanceId>abc-001-prcoess</ProcessInstanceId >
		<WorkitemId>1</WorkitemId>
		<HoldType>A</HoldType>; A- Activity Hold, T- Temporary My Queue Hold.
		<ActivityId>2</ActivityId>
		<ActivityName>workdesk2</ActivityName>
		<TargetActivityId>3</TargetActivityId>
		<TargetActivityName>Hold3</TargetActivityName>
                <Comments>Holded for purpose abc</Comments>
	</WFHoldWorkitem_Input >
	
	<WFHoldWorkitem _Output>
		<Option> WFHoldWorkitem </Option>
		<Exception>
			<MainCode>0</MainCode>
		</Exception>
        </WFHoldWorkitem _Output>



iii).If the workitem Holded temporarily to My Queue: 
	No need for GetActivityList API.
	WFHoldWorkitem API should be called :
 	<WFHoldWorkitem_Input>
		<Option> WFHoldWorkitem </Option>
		<EngineName>casemgmt06oct</EngineName>
		<SessionId>-562151966</SessionId>
                <ProcessDefId>12</ProcessDefId>
		<ProcessInstanceId>abc-001-prcoess</ProcessInstanceId >
		<WorkitemId>1</WorkitemId>
		<HoldType>T</HoldType>; A- Activity Hold, T- Temporary My Queue Hold.
                <ActivityId>2</ActivityId>
		<ActivityName>worksdesk1</ActivityName>
		<Comments>Holded for purpose abc otemporarily</Comments>
	</WFHoldWorkitem_Input >

	<WFHoldWorkitem _Output>
		<Option> WFHoldWorkitem </Option>
		<Exception>
			<MainCode>0</MainCode>
		</Exception>
        </WFHoldWorkitem _Output>

Note: Server will call WMGetWorkitem internally from Hold and Unhold APIs to avaoid concurrent operation.
* In case of Temporariy Hold there is no need of ActivityId and ACtivityName in the input XML
*********************************************************************************************************************/
    public String WFHoldWorkitem(Connection con, XMLParser parser, XMLGenerator gen) throws JTSException, WFSException {
        StringBuffer outputXML = null;
        StringBuffer tempXML = null;
        int mainCode = 0;
        int subCode = 0;
        String subject = null;
        String descr = null;
        String errType = WFSError.WF_TMP;
        ResultSet rs = null;
        PreparedStatement pstmt1 = null;
        PreparedStatement pstmt2 = null;
        ResultSet rs1 = null;
        String engine =null;
        int userId = 0;
        String userName = "";
        try {
            int sessionID = parser.getIntOf("SessionId", 0, false);
            String procInstID = parser.getValueOf("ProcessInstanceId", "", false).trim();
            int workItemId = parser.getIntOf("WorkitemId",0,false);
            int wrkItemID = parser.getIntOf("WorkItemId", 0, false);
            engine = parser.getValueOf("EngineName");
            String holdType = parser.getValueOf("HoldType", "", true);
            String comments = parser.getValueOf("Comments", "", true);
            int actvitiyId = 0;
            int queueid=0;
            String activityName = "";
            int processDefId = 0;
            actvitiyId= parser.getIntOf("ActivityId", 0, false);
            activityName = parser.getValueOf("ActivityName","",false);
            int  targetActvitiyId= parser.getIntOf("TargetActivityId", 0, true);
            String targetActivityName = parser.getValueOf("TargetActivityName","",true);
            processDefId = parser.getIntOf("ProcessDefId",0,false);
            int dbType = ServerProperty.getReference().getDBType(engine);
            WFParticipant participant = WFSUtil.WFCheckSession(con, sessionID);
            if (participant != null) {
                XMLParser parser1 = null;
                long startTime = 0L;
                long endTime = 0L;
                StringBuilder wmGetWorkItemInputXml = new StringBuilder();
                wmGetWorkItemInputXml.append("<?xml version=\"1.0\"?><WMGetWorkItem_Input><Option>WMGetWorkItem</Option>");
                wmGetWorkItemInputXml.append("<EngineName>").append(engine).append("</EngineName>");
                wmGetWorkItemInputXml.append("<SessionId>").append(sessionID).append("</SessionId>");
                wmGetWorkItemInputXml.append("<ProcessInstanceId>").append(procInstID).append("</ProcessInstanceId>");
                wmGetWorkItemInputXml.append("<WorkItemId>").append(wrkItemID).append("</WorkItemId>");
                wmGetWorkItemInputXml.append("</WMGetWorkItem_Input>");
                parser1 = new XMLParser();
                parser1.setInputXML(wmGetWorkItemInputXml.toString());
                try
                {
                    startTime = System.currentTimeMillis();
                    String wmGetWorkItemOutputXml = WFFindClass.getReference().execute("WMGetWorkItem", engine, con, parser1, gen);
                    parser1.setInputXML(wmGetWorkItemOutputXml);
                    endTime = System.currentTimeMillis();
                    WFSUtil.writeLog("WFClientServiceHandlerBean", "WMGetWorkItem", startTime, endTime, 0, wmGetWorkItemInputXml.toString(), wmGetWorkItemOutputXml);
                    wmGetWorkItemInputXml = null;
                    mainCode = Integer.parseInt(parser1.getValueOf("MainCode"));
                }
                catch(WFSException wfs)
                {
                    WFSUtil.printErr(engine, "[WFHoldWorkitem ] : WFSException in WMGetworkItem");
                    WFSUtil.printErr(engine, wfs);
                    throw wfs;
                }
                if(mainCode == 0 ){
                    if (con.getAutoCommit()){
                        con.setAutoCommit(false);
                    }
                    userId = participant.getid();
                    userName = participant.getname();
                    if(holdType.equalsIgnoreCase("T")){//WOrkitem is temporarily holded to My QUeue.
                        
                    	//Changes done from myqueue when workitem hold from myqueue then also return to myqueue in same state
                    	pstmt1=con.prepareStatement("Select Q_QueueId From WFInstrumentTable " +WFSUtil.getTableLockHintStr(dbType)+" where ProcessInstanceId = ? and WorkitemId = ? ");
                    	WFSUtil.DB_SetString(1, procInstID, pstmt1, dbType);
                    	pstmt1.setInt(2,workItemId);
                    	rs1=pstmt1.executeQuery();
                    	if(rs1!=null && rs1.next()){
                    		queueid=rs1.getInt(1);
                    	}
                    	if(rs1!=null){
                    		rs1.close();
                    		rs1=null;
                    	}
                    	if(pstmt1!=null){
                    		pstmt1.close();
                    		pstmt1=null;
                    	}
                    	if(queueid==0){
                    		queueid=-1;
                    	}else{
                    		queueid=0;
                    	}
                    
                    	
                    	pstmt1 = con.prepareStatement("Update WFInstrumentTable Set Q_QueueId = "+queueid+" , Q_UserId = ? , AssignmentType = ?,Statename = ?"
                                + ",WorkitemState = 8,RoutingStatus = ?, LockStatus = ?,VAR_REC_4 = null Where ProcessInstanceId = ? and WorkitemId = ? ");
                        pstmt1.setInt(1, userId);
                        WFSUtil.DB_SetString(2, "H", pstmt1, dbType);
                        WFSUtil.DB_SetString(3, WFSConstant.WF_TEMP_HOLDED, pstmt1, dbType);
                        WFSUtil.DB_SetString(4, "N", pstmt1, dbType);
                        WFSUtil.DB_SetString(5, "N", pstmt1, dbType);
                        WFSUtil.DB_SetString(6, procInstID, pstmt1, dbType);
                        pstmt1.setInt(7,workItemId);
                        pstmt1.executeUpdate();
                    }else if (holdType.equalsIgnoreCase("A")){//Workitem is HOlded to Some Hold Workstep.
                        pstmt1 = con.prepareStatement("Update WFInstrumentTable Set ActivityId = ?, ActivityName = ?,RoutingStatus = ?,"
                                + " LockStatus = ?,AssignmentType = ? ,PreviousStage = ?,ValidTill = null,Q_QueueId = 0,Q_UserId = 0 ,"
                                + "LockedByName = null,LockedTime = null, VAR_REC_4 = null Where ProcessInstanceId = ? and WorkitemId = ? ");
                        pstmt1.setInt(1, targetActvitiyId);
                        WFSUtil.DB_SetString(2, targetActivityName, pstmt1, dbType);
                        WFSUtil.DB_SetString(3, "Y", pstmt1, dbType);
                        WFSUtil.DB_SetString(4, "N", pstmt1, dbType);
                        WFSUtil.DB_SetString(5, "D", pstmt1, dbType);
                        WFSUtil.DB_SetString(6, activityName, pstmt1, dbType);
                        WFSUtil.DB_SetString(7, procInstID, pstmt1, dbType);
                        pstmt1.setInt(8,workItemId);
                        pstmt1.executeUpdate();
                    }
                    
                    if(!comments.equalsIgnoreCase("")){
                         if (pstmt1 != null) {
                             pstmt1.close();
                             pstmt1 = null;
                         }
                         pstmt1 = con.prepareStatement("Insert Into WFCommentsTable (ProcessDefId, ActivityId, ProcessInstanceId, WorkItemId,"
                                + " CommentsBy, CommentsByName, CommentsTo, CommentsToName, Comments, ActionDateTime, "
                                + "CommentsType ,ProcessVariantId) Values (?, ?, ?, ?, ?, ?, ?, ?, ?, " + WFSUtil.getDate(dbType) + ", ?,?)");
                        pstmt1.setInt(1, processDefId);
                        pstmt1.setInt(2, actvitiyId);
                        WFSUtil.DB_SetString(3, procInstID, pstmt1, dbType);
                        pstmt1.setInt(4, workItemId);
                        pstmt1.setInt(5, userId);
                        WFSUtil.DB_SetString(6, userName, pstmt1, dbType);
                        pstmt1.setInt(7, userId);
                        WFSUtil.DB_SetString(8, userName, pstmt1, dbType);
                        WFSUtil.DB_SetString(9, comments, pstmt1, dbType);
                        pstmt1.setInt(10, WFSConstant.CONST_COMMENTS_HOLD);
                        pstmt1.setInt(11, 0);
                        pstmt1.executeUpdate();
                    }
                    if (!con.getAutoCommit()) {
                        con.commit();
                        con.setAutoCommit(true);
                    }
                    
                    //Auditing to be done For Hold Action at this line
                    WFSUtil.generateLog(engine, con, WFSConstant.WFL_WorkitemHolded, procInstID, workItemId, processDefId,actvitiyId, activityName, 
                            0, userId, userName, targetActvitiyId, "<FieldName><TargetActivityName>"+targetActivityName+"</TargetActivityName>"
                            + "<HoldType>"+holdType+"</HoldType></FieldName>", null, null, null, null , null);
                }else{
                    subCode = Integer.parseInt(parser1.getValueOf("SubErrorCode", "0", true));
                    subject = parser1.getValueOf("Subject", WFSErrorMsg.getMessage(mainCode), true);
                    descr = parser1.getValueOf("Description", WFSErrorMsg.getMessage(subCode), true);
                    errType = parser1.getValueOf("TypeOfError", WFSError.WF_TMP, true);
                }
            }else{
                mainCode = WFSError.WM_INVALID_SESSION_HANDLE;
                subCode = 0;
                subject = WFSErrorMsg.getMessage(mainCode);
                descr = WFSErrorMsg.getMessage(subCode);
                errType = WFSError.WF_TMP;
            } 
            if (mainCode == 0) {
                outputXML = new StringBuffer(500);
                outputXML.append(gen.createOutputFile("WFHoldWorkitem"));
                outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
                outputXML.append(gen.closeOutputFile("WFHoldWorkitem"));
            } else {
                subject = WFSErrorMsg.getMessage(mainCode);
                descr = WFSErrorMsg.getMessage(subCode);
                errType = WFSError.WF_TMP;
            }
        } catch (SQLException e) {
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WM_INVALID_FILTER;
            subCode = WFSError.WFS_SQL;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_FAT;
            if (e.getErrorCode() == 0) {
                if (e.getSQLState().equalsIgnoreCase("08S01")) {
                    descr = (new JTSSQLError(e.getSQLState())).getMessage() + "(SQL State : " + e.getSQLState() + ")";
                }
            } else {
                descr = e.getMessage();
            }
        } catch (NumberFormatException e) {
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_ILP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch (NullPointerException e) {
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_SYS;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch (JTSException e) {
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = e.getErrorCode();
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.getMessage();
        } catch (Exception e) {
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_EXP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch (Error e) {
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_EXP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } finally {
            try {
                if (!con.getAutoCommit()) {
                    con.rollback();
                    con.setAutoCommit(true);
                }
                
                if (rs1 != null) {
                	rs1.close();
                	rs1 = null;
                }
                
                if (pstmt1 != null) {
                    pstmt1.close();
                    pstmt1 = null;
                }
            } catch (Exception e) {
            }
            
        }
        if (mainCode != 0) {
            throw new WFSException(mainCode, subCode, errType, subject, descr);
        }
        return outputXML.toString();
    }
    
     //----------------------------------------------------------------------------------------------------
    //	Function Name 				:	WFUnholdWorkitem
    //	Date Written (DD/MM/YYYY)               :	05 Nov 2015
    //	Author					:	Sajid Khan
    //	Input Parameters			:	Connection , XMLParser , XMLGenerator
    //	Output Parameters			:       none
    //	Return Values				:	String
    //	Description				:       UnHold the workitem either from  temporarily holded my queue or Any Hold Queue.
    //----------------------------------------------------------------------------------------------------
     /***********************************************************************************************************************
  Workitem Can be unhold either from Users My Queue to Shared Queue or From Hold Workstep's Queue
  to the next Target workstep of the current  Hold Workstep based on the Event selected.

When Workitem is Unhold from Users My Queue then Update the following in WFInstrumentTable for that workitem:
			Q-QueueId - Q_QueueId(Queue for the current activity)
			Q_UserId  - 0
			LockStatus – N
			RoutingStatus - N
			StateName - NotStarted
			WorktiemState – 1
			AssignemntType  - S(If CurrentyActivityType != 4 else H)

When Workitem is Unhold from Hold Workstep then Update the following in WFInstrumnettable for that workitem:
			VAR_REC_4  - eventname 
			RoutingStatus  - Y
			LockStatus - N
                        ValidTill - Null
WFUnholdWorkitem  API to Unhold Wroktiems from a Temporarily Holded My Queue or Hold Queue to Shared Queue from which it was holded. 
User can Unhold workitem after selection of any event or without selection.

i).If user Unholds the workitem from My Queue(Temporarily Holded Workitems):
	<WFUnholdWorkitem_Input>
		<Option>WFUnholdWorkitem</Option>
		<EngineName>casemgmt06oct</EngineName>
		<SessionId>-562151966</SessionId>
		<ProcessInstanceId>abc-001-prcoess</ ProcessInstanceId >
		<ProcessDefId>12</ProcessDefId>
		<WorkitemId>1</WorkitemId>
		<ActivityId>2< ActivityId >
		<ActivityName>workdesk2</ActivityName>
		<HoldType>T</HoldType>;  T- Temporary My Queue Hold.
		<Comments>Holded for purpose abc otemporarily</Comments>
	</WFUnholdWorkitem _Input>

	<WFUnholdWorkitem _Output>
		<Option> WFUnholdWorkitem </Option>
		<Exception>
			<MainCode>0</MainCode>
		</Exception>
        </WFUnholdWorkitem _Output>


ii).If User Unholds the workitem from Hold Queue .
    User will unhold the workitem with or without selection of events defined on the Hold Workstep.
    To select any event  Events would be fetched defined on the Hold worktep .
    Following API would be called :
	WFGetHoldEvents API(New)

	<WFGetHoldEvents _Input>
		<Option> WFGetHoldEvents </Option>
                <EngineName>sqlcab15july</EngineName>
                <SessionId>-344889690</SessionId>
		<ProcessDefinitionID>25</ProcessDefinitionID>
		<ActivityId>3</ActivityId>
	</WFGetHoldEvents _Input>

        <WFGetHoldEvents_Output>
		<Option> WFGetHoldEvents </Option>
		<Exception>
		<MainCode>0</MainCode>
		</Exception>
		<EventList>
		<EventInfo>
			<ID>2</ID>
                        <Name>event1</Name>
                        <TriggerName>trigger1</TriggerName>
                        <TargetActivityId>13</TargetActivityId>
                        <TargetActivityName>workdesk4</TargetActivityName>		
		</EventInfo >
		<EventInfo>
			<ID>3</ID>
                        <Name>event2</Name>
                        <TriggerName>trigger1</TriggerName>
                        <TargetActivityId>21</TargetActivityId>
                        <TargetActivityName>workdesk12</TargetActivityName>		
		</EventInfo >
		</EventList >
		<TotalCount>2</TotalCount><RetrievedCount>2</RetrievedCount>
	</WFGetHoldEvents_Output>

Once the event is selected, WFUnholdWorkitem API will be called :

	<WFUnholdWorkitem_Input>
		<Option>WFUnholdWorkitem</Option>
		<EngineName>casemgmt06oct</EngineName>
		<SessionId>-562151966</SessionId>
		<ProcessInstanceId>abc-001-prcoess</ProcessInstanceId >
		<WorkitemId>1</WorkitemId>
		<ActivityId>2</ActivityId>; 
		<ActivityName>workdesk2</ActivityName>
		<HoldType>A</HoldType>;  A- Activity Hold
		<EventName>event1</EventName>
                <TargetActivityId>1</TargetActivityId>
                <TargetActivityName>abcdesk1</TargetActivityName>
		<Comments>Holded for purpose abc</Comments>
	</WFUnholdWorkitem _Input>

	<WFUnholdWorkitem _Output>
		<Option> WFUnholdWorkitem </Option>
		<Exception>
			<MainCode>0</MainCode>
		</Exception>
        </WFUnholdWorkitem _Output>


Note: Server will call WMGetWorkitem internally from Hold and Unhold APIs to avaoid concurrent operation.
*********************************************************************************************************************/
    public String WFUnholdWorkitem(Connection con, XMLParser parser, XMLGenerator gen) throws JTSException, WFSException {
        StringBuffer outputXML = null;
        int mainCode = 0;
        int subCode = 0;
        String subject = null;
        String descr = null;
        String errType = WFSError.WF_TMP;
        ResultSet rs = null;
        PreparedStatement pstmt1 = null;
        String engine =null;
        int userId = 0;
        String userName = "";
        try {
            int sessionID = parser.getIntOf("SessionId", 0, false);
            String procInstID = parser.getValueOf("ProcessInstanceId", "", false).trim();
            int workItemId = parser.getIntOf("WorkitemId",0,false);
            int wrkItemID = parser.getIntOf("WorkItemId", 0, false);
            engine = parser.getValueOf("EngineName");
            String holdType = parser.getValueOf("HoldType", "", true);
            String comments = parser.getValueOf("Comments", "", true);
            int actvitiyId = 0;
            int processDefId = 0;
            actvitiyId= parser.getIntOf("ActivityId", 0, true);
            String activityName = parser.getValueOf("ActivityName","",true);
            processDefId = parser.getIntOf("ProcessDefId",0,false);
            String eventName = parser.getValueOf("EventName",null,true);
            int  targetActviityId = parser.getIntOf("TargetActivityId", -1, true);
            String targetActivityName = parser.getValueOf("TargetActivityName", "", true);
            int dbType = ServerProperty.getReference().getDBType(engine);
            WFParticipant participant = WFSUtil.WFCheckSession(con, sessionID);
            boolean rightsFlag = false;
            boolean isAdmin = false;
            XMLParser parser1 = null;            
            if (participant != null) {
            	
	            	userId = participant.getid();
	                userName = participant.getname();
	                
            	boolean partOfAdminGroup = isPartOfAdminGroup(con,dbType,userId);            	
				if(!partOfAdminGroup)
                 {
           	          rightsFlag = WFSUtil.checkRights(con, dbType, WFSConstant.CONST_OBJTYPE_ProcessClientWorklist, 0, sessionID, WFSConstant.CONST_ProcessClientWorklist_UNHOLD );                	
                 }
           	     if(partOfAdminGroup || rightsFlag)
                 {
               	  isAdmin = true;
                 }
           	     else
           	     {
	                long startTime = 0L;
	                long endTime = 0L;
	                StringBuilder wmGetWorkItemInputXml = new StringBuilder();
	                wmGetWorkItemInputXml.append("<?xml version=\"1.0\"?><WMGetWorkItem_Input><Option>WMGetWorkItem</Option>");
	                wmGetWorkItemInputXml.append("<EngineName>").append(engine).append("</EngineName>");
	                wmGetWorkItemInputXml.append("<SessionId>").append(sessionID).append("</SessionId>");
	                wmGetWorkItemInputXml.append("<ProcessInstanceId>").append(procInstID).append("</ProcessInstanceId>");
	                wmGetWorkItemInputXml.append("<WorkItemId>").append(wrkItemID).append("</WorkItemId>");
	                wmGetWorkItemInputXml.append("</WMGetWorkItem_Input>");
	                parser1 = new XMLParser();
	                parser1.setInputXML(wmGetWorkItemInputXml.toString());
	                try
	                {
	                    startTime = System.currentTimeMillis();
	                    String wmGetWorkItemOutputXml = WFFindClass.getReference().execute("WMGetWorkItem", engine, con, parser1, gen);
	                    parser1.setInputXML(wmGetWorkItemOutputXml);
	                    endTime = System.currentTimeMillis();
	                    WFSUtil.writeLog("WFClientServiceHandlerBean", "WMGetWorkItem", startTime, endTime, 0, wmGetWorkItemInputXml.toString(), wmGetWorkItemOutputXml);
	                    wmGetWorkItemInputXml = null;
	                    mainCode = Integer.parseInt(parser1.getValueOf("MainCode"));
	                }
	                catch(WFSException wfs)
	                {
	                    WFSUtil.printErr(engine, "[WFUnholdWorkitem] : WFSException in WMGetworkItem");
	                    WFSUtil.printErr(engine, wfs);
	                    throw wfs;
	                }
           	    }
                if(mainCode == 0 || isAdmin ){
                    if (con.getAutoCommit()){
                        con.setAutoCommit(false);
                    }
                    
                    int queueId = 0;
                    int actvityType = 0;
                    
                    int workitemQueueId=0;
                    int parentWorkitemId=0;
                    
                    if(targetActviityId==0 && holdType.equalsIgnoreCase("A")){//Case when TargetActivity set with an event whose target activity
                                                                              //= PreviousStage or No Target is set
                        //Get the name of the previousstage 
                        pstmt1 = con.prepareStatement("Select PreviousStage from WFInstrumentTable "+WFSUtil.getTableLockHintStr(dbType) +" "
                                + " where ProcessInstanceId  = ? and WorkitemId= ? ");
                        WFSUtil.DB_SetString(1, procInstID, pstmt1, dbType);
                        pstmt1.setInt(2, workItemId);
                        rs = pstmt1.executeQuery();
                        if(rs.next()){
                            targetActivityName = rs.getString(1);
                        }
                        if (pstmt1 != null) {
                            pstmt1.close();
                            pstmt1 = null;
                        }
                        if (rs != null) {
                            rs.close();
                            rs = null;
                        }
                        //Get the ActivityId for the target one
                        pstmt1 = con.prepareStatement("Select ActivityId  from ActivityTable where ProcessDefId = ? and ActivityName = ? ");
                        pstmt1.setInt(1, processDefId);
                        WFSUtil.DB_SetString(2, targetActivityName, pstmt1, dbType);
                        rs = pstmt1.executeQuery();
                        if(rs.next()){
                            targetActviityId = rs.getInt(1);
                        }
                        if (pstmt1 != null) {
                            pstmt1.close();
                            pstmt1 = null;
                        }
                        if (rs != null) {
                            rs.close();
                            rs = null;
                        }
                    
                    }
                    //Temporarily Holded from a Hold Type Queue
                   if(holdType.equalsIgnoreCase("T")){//WOrkitem is unhold from Temporary Hold  My Queue
                        String assignmentType = "S";
                        pstmt1 = con.prepareStatement("Select ActivityType from ActivityTable "+WFSUtil.getTableLockHintStr(dbType) +" "
                                + " where ProcessDefId = ? and ActivityId = ? ");
                        pstmt1.setInt(1, processDefId);
                        pstmt1.setInt(2, actvitiyId);
                        rs = pstmt1.executeQuery();
                        if(rs.next()){
                            actvityType = rs.getInt(1);
                        }
                        if(actvityType == 4){
                            assignmentType = "H";
                        }
                        if (pstmt1 != null) {
                            pstmt1.close();
                            pstmt1 = null;
                        }
                        if (rs != null) {
                            rs.close();
                            rs = null;
                        }
                     //   }
                        
                        int streamId = 1;
                        pstmt1 = con.prepareStatement("select q_streamid,q_queueId,parentworkitemId from wfinstrumenttable "+ WFSUtil.getTableLockHintStr(dbType) +" where processinstanceid = ? and processdefid = ? and activityid = ? and workitemid = ?");
                        WFSUtil.DB_SetString(1, procInstID, pstmt1, dbType);
                        pstmt1.setInt(2, processDefId);
                        pstmt1.setInt(3, actvitiyId);
                        pstmt1.setInt(4, workItemId);
                        rs = pstmt1.executeQuery();
                        if(rs.next()){
                        	streamId = rs.getInt(1);
                        	workitemQueueId=rs.getInt(2);
                        	parentWorkitemId=rs.getInt(3);
                        }
                        if (pstmt1 != null) {
                            pstmt1.close();
                            pstmt1 = null;
                        }
                        if (rs != null) {
                            rs.close();
                            rs = null;
                        }
                        
                        pstmt1 = con.prepareStatement("Select QueueId from QUEUESTREAMTABLE where ProcessDefId = ? and ActivityId = ? and streamid = ?");
                        pstmt1.setInt(1, processDefId);
                        pstmt1.setInt(2, actvitiyId);
                        pstmt1.setInt(3, streamId);
                        
                        rs = pstmt1.executeQuery();
                        if(rs.next()){
                            queueId = rs.getInt(1);
                        }
                        if (pstmt1 != null) {
                            pstmt1.close();
                            pstmt1 = null;
                        }
                        if (rs != null) {
                            rs.close();
                            rs = null;
                        }
                        
                        if(workitemQueueId==-1){
                        	queueId=0;
                        	assignmentType="F";
                        	if(parentWorkitemId>0){
	                        	pstmt1=con.prepareStatement("select 1 from WFInstrumentTable "+ WFSUtil.getTableLockHintStr(dbType) + "where  processinstanceid = ?  and workitemid = ? and AssignmentType=?");
	                        	WFSUtil.DB_SetString(1, procInstID, pstmt1, dbType);
	                            pstmt1.setInt(2, parentWorkitemId);
	                            WFSUtil.DB_SetString(3, "Z", pstmt1, dbType);
	                            rs = pstmt1.executeQuery();
	                            if(rs.next()){
	                            	assignmentType="E";
	                            }
	                            if (pstmt1 != null) {
	                                pstmt1.close();
	                                pstmt1 = null;
	                            }
	                            if (rs != null) {
	                                rs.close();
	                                rs = null;
	                            }
                        	}
                        }
                        
                        if(workitemQueueId==-1){
                        	pstmt1 = con.prepareStatement("Update WFInstrumentTable Set Q_QueueId = ? , AssignmentType = ?,Statename = ?"
                                + ",WorkitemState = 1,RoutingStatus = ?, LockStatus = ?,LockedByName = null, LockedTime = null Where ProcessInstanceId = ? and WorkitemId = ? ");
                        }else{
                        	pstmt1 = con.prepareStatement("Update WFInstrumentTable Set Q_QueueId = ? , Q_UserId = 0 , AssignmentType = ?,Statename = ?"
                                    + ",WorkitemState = 1,RoutingStatus = ?, LockStatus = ?,LockedByName = null, LockedTime = null Where ProcessInstanceId = ? and WorkitemId = ? ");
                        }
                        pstmt1.setInt(1, queueId);
                        WFSUtil.DB_SetString(2, assignmentType, pstmt1, dbType);
                        WFSUtil.DB_SetString(3, WFSConstant.WF_NOTSTARTED, pstmt1, dbType);
                        WFSUtil.DB_SetString(4, "N", pstmt1, dbType);
                        WFSUtil.DB_SetString(5, "N", pstmt1, dbType);
                        WFSUtil.DB_SetString(6, procInstID, pstmt1, dbType);
                        pstmt1.setInt(7,workItemId);
                        pstmt1.executeUpdate();
                    }else if (holdType.equalsIgnoreCase("A")){//Workitem is HOlded to Some Hold Workstep.
                        if(eventName==null || "".equals(eventName)){
                            eventName = null;
                        }
                        pstmt1 = con.prepareStatement("Update WFInstrumentTable Set RoutingStatus = ?,q_userid=0,"
                                + " LockStatus = ?,ValidTill = null ,LockedByName = null, LockedTime = null ,VAR_REC_4 = ?  Where ProcessInstanceId = ? and WorkitemId = ? ");
                        WFSUtil.DB_SetString(1, "Y", pstmt1, dbType);
                        WFSUtil.DB_SetString(2, "N", pstmt1, dbType);
                        WFSUtil.DB_SetString(3,eventName , pstmt1, dbType);
                        WFSUtil.DB_SetString(4, procInstID, pstmt1, dbType);
                        pstmt1.setInt(5,workItemId);
                        pstmt1.executeUpdate();
                        
                        if (pstmt1 != null) {
                            pstmt1.close();
                            pstmt1 = null;
                        }
                        pstmt1 = con.prepareStatement("Update WFEscalationTable Set Frequency = 0 Where ProcessInstanceId = ? and WorkitemId = ? And EscalationMode = ? ");
                        WFSUtil.DB_SetString(1, procInstID, pstmt1, dbType);
                        pstmt1.setInt(2,workItemId);
                        WFSUtil.DB_SetString(3,"Reminder", pstmt1 , dbType);
                        pstmt1.executeUpdate();
                    }
                    if(!comments.equalsIgnoreCase("")){
                        if (pstmt1 != null) {
                            pstmt1.close();
                            pstmt1 = null;
                        }
                        pstmt1 = con.prepareStatement("Insert Into WFCommentsTable (ProcessDefId, ActivityId, ProcessInstanceId, WorkItemId,"
                                + " CommentsBy, CommentsByName, CommentsTo, CommentsToName, Comments, ActionDateTime, "
                                + "CommentsType ,ProcessVariantId) Values (?, ?, ?, ?, ?, ?, ?, ?, ?, " + WFSUtil.getDate(dbType) + ", ?,?)");
                        pstmt1.setInt(1, processDefId);
                        pstmt1.setInt(2, actvitiyId);
                        WFSUtil.DB_SetString(3, procInstID, pstmt1, dbType);
                        pstmt1.setInt(4, workItemId);
                        pstmt1.setInt(5, userId);
                        WFSUtil.DB_SetString(6, userName, pstmt1, dbType);
                        pstmt1.setInt(7, userId);
                        WFSUtil.DB_SetString(8, userName, pstmt1, dbType);
                        WFSUtil.DB_SetString(9, comments, pstmt1, dbType);
                        pstmt1.setInt(10, WFSConstant.CONST_COMMENTS_UNHOLD);
                        pstmt1.setInt(11, 0);
                        pstmt1.executeUpdate();
                    }
                    if (!con.getAutoCommit()) {
                        con.commit();
                        con.setAutoCommit(true);
                    }
                    //Auditing to be done For Unhold Action at this line
                    WFSUtil.generateLog(engine, con, WFSConstant.WFL_WorkitemUnholded, procInstID, workItemId, processDefId,actvitiyId, activityName, 
                            0, userId, userName, targetActviityId, "<FieldName><TargetActivityName>"+targetActivityName+"</TargetActivityName>"
                            + "<HoldType>"+holdType+"</HoldType></FieldName>", null, null, null, null , null);
                }else{
                    subCode = Integer.parseInt(parser1.getValueOf("SubErrorCode", "0", true));
                    subject = parser1.getValueOf("Subject", WFSErrorMsg.getMessage(mainCode), true);
                    descr = parser1.getValueOf("Description", WFSErrorMsg.getMessage(subCode), true);
                    errType = parser1.getValueOf("TypeOfError", WFSError.WF_TMP, true);
                }
            }else{
                mainCode = WFSError.WM_INVALID_SESSION_HANDLE;
                subCode = 0;
                subject = WFSErrorMsg.getMessage(mainCode);
                descr = WFSErrorMsg.getMessage(subCode);
                errType = WFSError.WF_TMP;
            } 
            if (mainCode == 0) {
                outputXML = new StringBuffer(500);
                outputXML.append(gen.createOutputFile("WFUnholdWorkitem"));
                outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
                outputXML.append(gen.closeOutputFile("WFUnholdWorkitem"));
            } else {
                subject = WFSErrorMsg.getMessage(mainCode);
                descr = WFSErrorMsg.getMessage(subCode);
                errType = WFSError.WF_TMP;
            }
        } catch (SQLException e) {
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WM_INVALID_FILTER;
            subCode = WFSError.WFS_SQL;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_FAT;
            if (e.getErrorCode() == 0) {
                if (e.getSQLState().equalsIgnoreCase("08S01")) {
                    descr = (new JTSSQLError(e.getSQLState())).getMessage() + "(SQL State : " + e.getSQLState() + ")";
                }
            } else {
                descr = e.getMessage();
            }
        } catch (NumberFormatException e) {
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_ILP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch (NullPointerException e) {
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_SYS;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch (JTSException e) {
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = e.getErrorCode();
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.getMessage();
        } catch (Exception e) {
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_EXP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch (Error e) {
            WFSUtil.printErr(engine,"", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_EXP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } finally {
            try {
                if (!con.getAutoCommit()) {
                    con.rollback();
                    con.setAutoCommit(true);
                }

                if (pstmt1 != null) {
                    pstmt1.close();
                    pstmt1 = null;
                }
            } catch (Exception e) {
            }
            
        }
        if (mainCode != 0) {
            throw new WFSException(mainCode, subCode, errType, subject, descr);
        }
        return outputXML.toString();
    }
    private String WFGetParentWIInfo(Connection con, XMLParser parser, XMLGenerator gen) throws WFSException {
        int mainCode = 0;
        int subCode = 0;
        String subject = null;
        String descr = null;
        String errType = WFSError.WF_TMP;
        StringBuilder sOutputXML = new StringBuilder();
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String sEngineName = "";
        boolean skipQuery = true;
        try {
            String sChildProcessInstanceId = parser.getValueOf("ProcessInstanceID", "", false);
            int sChildWorkItemId = parser.getIntOf("WorkItemId", 0, false);
            sEngineName = parser.getValueOf("EngineName", "", false);
            int dbType = ServerProperty.getReference().getDBType(sEngineName);
            WFParticipant participant;
            if (parser.getCharOf("OmniService", 'N', true) == 'Y') {
                participant = new WFParticipant(0, "INTERNAL_ROUTING_SERVER", 'P', "SERVER", Locale.getDefault().toString());
            } else {
                participant = WFSUtil.WFCheckSession(con, parser.getIntOf("SessionId", 0, false));
            }
            if (participant != null) {
				StringBuilder sQuery1 = new StringBuilder();
            	sQuery1.append("SELECT 1 FROM IMPORTEDPROCESSDEFTABLE").append(WFSUtil.getTableLockHintStr(dbType));
            	pstmt = con.prepareStatement(sQuery1.toString());
            	rs = pstmt.executeQuery();
            	if (rs != null && rs.next()) {
            		skipQuery = false; 
            	
            	}
            	else{
            		
            		if(rs!=null){
                		rs.close();
                		rs=null;
                	}
                	if(pstmt!=null){
                		pstmt.close();
                		pstmt=null;
                	}
                	
            		StringBuilder sQuery3 = new StringBuilder();
                	sQuery3.append("SELECT 1 FROM CaseINITIATEWORKITEMTABLE").append(WFSUtil.getTableLockHintStr(dbType));
                	pstmt = con.prepareStatement(sQuery3.toString());
                	rs = pstmt.executeQuery();
                	if (rs != null && rs.next()) {
                		skipQuery = false; 
                	
                	}
                	else
                		skipQuery = true;
                	
                	
            	}
            		
            	
            	if(rs!=null){
            		rs.close();
            		rs=null;
            	}
            	if(pstmt!=null){
            		pstmt.close();
            		pstmt=null;
            	}
            	
            	
                
            	if(!skipQuery){  //optimization to skip unnecessary execution of query
	            		
	                StringBuilder sQuery = new StringBuilder();
	                sQuery.append("SELECT ProcessInstanceId, WorkItemId, ProcessDefId, ActivityId, ActivityType, RoutingStatus FROM WFInstrumentTable ")
	                        .append(WFSUtil.getTableLockHintStr(dbType)).append(" WHERE ChildProcessInstanceId = ? AND ChildWorkItemId = ?");
	                pstmt = con.prepareStatement(sQuery.toString());
	                WFSUtil.DB_SetString(1, sChildProcessInstanceId, pstmt, dbType);
	                pstmt.setInt(2, sChildWorkItemId);
	                rs = pstmt.executeQuery();
	                if (rs != null && rs.next()) {
	                    String sProcessInstanceId = rs.getString("ProcessInstanceId");
	                    int iWorkitemId = rs.getInt("WorkItemId");
	                    int iProcessDefId = rs.getInt("ProcessDefId");
	                    int iActivityId = rs.getInt("ActivityId");
	                    int iActivityType = rs.getInt("ActivityType");
	                    String sRoutingStatus = rs.getString("RoutingStatus");
	
	                    rs.close();
	                    rs = null;
	                    pstmt.close();
	                    pstmt = null;
	
	                    if ((iActivityType == WFSConstant.ACT_CASE && "N".equalsIgnoreCase(sRoutingStatus)) || (iActivityType != WFSConstant.ACT_CASE && "R".equalsIgnoreCase(sRoutingStatus))) {
	                        sOutputXML.append(gen.createOutputFile("WFGetParentWIInfo"))
	                                .append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n")
	                                .append("<Root>\n")
	                                .append("<ProcInstance>").append(sProcessInstanceId).append("</ProcInstance>\n")
	                                .append("<WorkItem>").append(iWorkitemId).append("</WorkItem>\n")
	                                .append("<ProcDefId>").append(iProcessDefId).append("</ProcDefId>\n")
	                                .append("<WorkStep>").append(iActivityId).append("</WorkStep>\n");
	
	                        HashMap<String, String> mTaskDetail = WFSUtil.getTaskDetail(con, iProcessDefId, sChildProcessInstanceId, sProcessInstanceId);
	                        sOutputXML.append("<TaskId>").append(mTaskDetail.get("TaskId")).append("</TaskId>\n")
	                                .append("<TaskType>").append(mTaskDetail.get("TaskType")).append("</TaskType>\n")
	                                .append("<SubTaskId>").append(mTaskDetail.get("SubTaskId")).append("</SubTaskId>\n")
	                                .append("<TaskMode>").append(mTaskDetail.get("TaskMode")).append("</TaskMode>\n");
	
	                        sOutputXML.append("</Root>");
	                        sOutputXML.append(gen.closeOutputFile("WFGetParentWIInfo"));
	                       
	                    } else {
	                        mainCode = WFSError.WM_NO_MORE_DATA;
	                        subCode = 0;
	                        subject = WFSErrorMsg.getMessage(mainCode);
	                        descr = WFSErrorMsg.getMessage(subCode);
	                        errType = WFSError.WF_TMP;
	                    }
	                } else {
	                		                	

	            		if (rs != null) {
	                        rs.close();
	                        rs = null;
	                    }
						if (pstmt != null) {
	                        pstmt.close();
	                        pstmt = null;
	                    }
						
					 StringBuilder sQuery2 = new StringBuilder();
	                sQuery2.append("SELECT ProcessInstanceId, WorkItemId, ProcessDefId, ActivityId  FROM WFTaskStatusTable ")
	                        .append(WFSUtil.getTableLockHintStr(dbType)).append(" WHERE ChildProcessInstanceId = ? AND ChildWorkItemId = ?");
	                pstmt = con.prepareStatement(sQuery2.toString());
	                WFSUtil.DB_SetString(1, sChildProcessInstanceId, pstmt, dbType);
	                pstmt.setInt(2, sChildWorkItemId);
	                rs = pstmt.executeQuery();
	                if (rs != null && rs.next()) {
	                    String sProcessInstanceId = rs.getString("ProcessInstanceId");
	                    int iWorkitemId = rs.getInt("WorkItemId");
	                    int iProcessDefId = rs.getInt("ProcessDefId");
	                    int iActivityId = rs.getInt("ActivityId");	                 
	
	                    rs.close();
	                    rs = null;
	                    pstmt.close();
	                    pstmt = null;
	
	                        sOutputXML.append(gen.createOutputFile("WFGetParentWIInfo"))
	                                .append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n")
	                                .append("<Root>\n")
	                                .append("<ProcInstance>").append(sProcessInstanceId).append("</ProcInstance>\n")
	                                .append("<WorkItem>").append(iWorkitemId).append("</WorkItem>\n")
	                                .append("<ProcDefId>").append(iProcessDefId).append("</ProcDefId>\n")
	                                .append("<WorkStep>").append(iActivityId).append("</WorkStep>\n");
	
	                        HashMap<String, String> mTaskDetail = WFSUtil.getTaskDetail(con, iProcessDefId, sChildProcessInstanceId, sProcessInstanceId);
	            
	                        sOutputXML.append("<TaskId>").append(mTaskDetail.get("TaskId")).append("</TaskId>\n")
	                                .append("<TaskType>").append(mTaskDetail.get("TaskType")).append("</TaskType>\n")
	                                .append("<SubTaskId>").append(mTaskDetail.get("SubTaskId")).append("</SubTaskId>\n")
	                                .append("<TaskMode>").append(mTaskDetail.get("TaskMode")).append("</TaskMode>\n");
	                       
	                        sOutputXML.append("</Root>");
	                        sOutputXML.append(gen.closeOutputFile("WFGetParentWIInfo"));
	                        
	                } else {
	                	
	                	
	                    if (rs != null) {
	                        rs.close();
	                        rs = null;
	                    }
	                    pstmt.close();
	                    pstmt = null;
	
	                    mainCode = WFSError.WM_NO_MORE_DATA;
	                    subCode = 0;
	                    subject = WFSErrorMsg.getMessage(mainCode);
	                    descr = WFSErrorMsg.getMessage(subCode);
	                    errType = WFSError.WF_TMP;
	                }
	                }
				}else{
            		 mainCode = WFSError.WM_NO_MORE_DATA;
                     subCode = 0;
                     subject = WFSErrorMsg.getMessage(mainCode);
                     descr = WFSErrorMsg.getMessage(subCode);
                     errType = WFSError.WF_TMP;
            	}
            } else {
                mainCode = WFSError.WM_INVALID_SESSION_HANDLE;
                subCode = 0;
                subject = WFSErrorMsg.getMessage(mainCode);
                descr = WFSErrorMsg.getMessage(subCode);
                errType = WFSError.WF_TMP;
            }
        } catch (SQLException e) {
            WFSUtil.printErr(sEngineName, "", e);
            mainCode = WFSError.WM_INVALID_FILTER;
            subCode = WFSError.WFS_SQL;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_FAT;
            if (e.getErrorCode() == 0) {
                if (e.getSQLState().equalsIgnoreCase("08S01")) {
                    descr = (new JTSSQLError(e.getSQLState())).getMessage() + "(SQL State : " + e.getSQLState() + ")";
                }
            } else {
                descr = e.getMessage();
            }
        } catch (NumberFormatException e) {
            WFSUtil.printErr(sEngineName, "", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_ILP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch (NullPointerException e) {
            WFSUtil.printErr(sEngineName, "", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_SYS;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch (JTSException e) {
            WFSUtil.printErr(sEngineName, "", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = e.getErrorCode();
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.getMessage();
        } catch (Exception e) {
            WFSUtil.printErr(sEngineName, "", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_EXP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch (Error e) {
            WFSUtil.printErr(sEngineName, "", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_EXP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } finally {
            try {
                if (rs != null) {
                    rs.close();
                }
            } catch (Exception ignored) {
            }
            try {
                if (pstmt != null) {
                    pstmt.close();
                }
            } catch (Exception ignored) {
            }
        }
        if (mainCode != 0) {
            sOutputXML.delete(0, sOutputXML.length());
            sOutputXML.append(WFSUtil.generalError("WFGetParentWIInfo", sEngineName, gen, mainCode, subCode, errType, subject, descr));
        }
        return sOutputXML.toString();
    }
    
  //----------------------------------------------------------------------------------------------------
//	Function Name 				:	WFSetAndCompleteWorkItem
//	Date Written (DD/MM/YYYY)	:	21/04/2017
//	Author						:	Kimil
//	Input Parameters			:	Connection , XMLParser , XMLGenerator
//	Output Parameters			:   none
//	Return Values				:	String
//	Description					:   Sets And Completes WorkItem through Webservice call
//----------------------------------------------------------------------------------------------------
    private String WFSetAndCompleteWorkItem(Connection con, XMLParser parser, XMLGenerator gen) throws WFSException {
        int mainCode = 0;
        int subCode = 0;
        String subject = null;
        String descr = null;
        String errType = WFSError.WF_TMP;
        StringBuffer outputXML = null;
        boolean bWorkItemLocked = false;
        XMLParser parser1 = null;
        int sessionID = 0;
        String processInstanceId = null;
        int workItemId = 0;
        String engine = null;
        long startTime = 0L;
        long endTime = 0L;
        boolean completeAlsoFlag = false;
        try
        {
            processInstanceId = parser.getValueOf("ProcessInstanceID", "", false);
            workItemId = parser.getIntOf("WorkItemId", 0, false);
            engine = parser.getValueOf("EngineName", "", false);
            sessionID = parser.getIntOf("SessionId", 0, false);
            int dbType = ServerProperty.getReference().getDBType(engine);
            WFParticipant participant = WFSUtil.WFCheckSession(con, sessionID);
            if (participant != null) {
                StringBuilder wmGetWorkItemInputXml = new StringBuilder();
                wmGetWorkItemInputXml.append("<?xml version=\"1.0\"?><WMGetWorkItem_Input><Option>WMGetWorkItem</Option>");
                wmGetWorkItemInputXml.append("<EngineName>").append(engine).append("</EngineName>");
                wmGetWorkItemInputXml.append("<SessionId>").append(sessionID).append("</SessionId>");
                wmGetWorkItemInputXml.append("<ProcessInstanceId>").append(processInstanceId).append("</ProcessInstanceId>");
                wmGetWorkItemInputXml.append("<WorkItemId>").append(workItemId).append("</WorkItemId>");
                wmGetWorkItemInputXml.append("</WMGetWorkItem_Input>");
                parser1 = new XMLParser();
                parser1.setInputXML(wmGetWorkItemInputXml.toString());
                try
                {
                    startTime = System.currentTimeMillis();
                    String wmGetWorkItemOutputXml = WFFindClass.getReference().execute("WMGetWorkItem", engine, con, parser1, gen);
                    parser1.setInputXML(wmGetWorkItemOutputXml);
                    endTime = System.currentTimeMillis();
                    WFSUtil.writeLog("WFClientServiceHandlerBean", "WMGetWorkItem", startTime, endTime, 0, wmGetWorkItemInputXml.toString(), wmGetWorkItemOutputXml);
                    wmGetWorkItemInputXml = null;
                    mainCode = Integer.parseInt(parser1.getValueOf("MainCode"));
                }
                catch(WFSException wfs)
                {
                    WFSUtil.printErr(engine, "[WFSetAndCompleteWorkItem] : WFSException in WMGetworkItem");
                    WFSUtil.printErr(engine, wfs);
                    throw wfs;
                }
                if(mainCode == 0)
                {
                    bWorkItemLocked = true;
                    int activityId = Integer.parseInt(parser1.getValueOf("ActivityInstanceId"));
                    String attributeStr = parser.getValueOf("Attributes", "", true);
                    if(attributeStr != null && attributeStr.length() > 0)
                    {
                        StringBuilder wfSetAttributesInputXml = new StringBuilder();
                        wfSetAttributesInputXml.append("<?xml version=\"1.0\"?><WFSetAttributes_Input><Option>WFSetAttributes</Option>");
                        wfSetAttributesInputXml.append("<EngineName>").append(engine).append("</EngineName>");
                        wfSetAttributesInputXml.append("<SessionId>").append(sessionID).append("</SessionId>");                      
                        wfSetAttributesInputXml.append("<ProcessInstanceId>").append(processInstanceId).append("</ProcessInstanceId>");   
                        wfSetAttributesInputXml.append("<WorkItemId>").append(workItemId).append("</WorkItemId>");
                        wfSetAttributesInputXml.append("<Attributes>").append(attributeStr).append("</Attributes>");
                        wfSetAttributesInputXml.append("<ActivityId>").append(activityId).append("</ActivityId>");
                        wfSetAttributesInputXml.append("</WFSetAttributes_Input>");
                        parser1.setInputXML(wfSetAttributesInputXml.toString());
                        try
                        {
                            startTime = System.currentTimeMillis();
                            String wfSetAttributesOutputXml = WFFindClass.getReference().execute("WFSetAttributes", engine, con, parser1, gen);
                            parser1.setInputXML(wfSetAttributesOutputXml);
                            endTime = System.currentTimeMillis();
                            WFSUtil.writeLog("WFClientServiceHandlerBean", "WFSetAttributes", startTime, endTime, 0, wfSetAttributesInputXml.toString(), wfSetAttributesOutputXml);
                            wfSetAttributesInputXml = null;
                            mainCode = Integer.parseInt(parser1.getValueOf("MainCode"));
                        }
                        catch(WFSException wfs)
                        {
                            WFSUtil.printErr(engine, "[WFSetAndCompleteWorkItem] : WFSException in WFSetAttributes");
                            WFSUtil.printErr(engine, wfs);
                            throw wfs;
                        }
                    }
                    if(mainCode == 0)
                    {
                        completeAlsoFlag = parser.getValueOf("CompleteAlso", "N", true).equalsIgnoreCase("Y");
                        if(completeAlsoFlag)
                        {
                            String synchronousRoutingFlag = parser.getValueOf("SynchronousRouting", "", true);
                            StringBuilder wmCompleteWorkItemInputXml = new StringBuilder();
                            wmCompleteWorkItemInputXml.append("<?xml version=\"1.0\"?><WMCompleteWorkItem_Input><Option>WMCompleteWorkItem</Option>");
                            wmCompleteWorkItemInputXml.append("<EngineName>").append(engine).append("</EngineName>");
                            wmCompleteWorkItemInputXml.append("<SessionId>").append(sessionID).append("</SessionId>");                      
                            wmCompleteWorkItemInputXml.append("<ProcessInstanceId>").append(processInstanceId).append("</ProcessInstanceId>");   
                            wmCompleteWorkItemInputXml.append("<WorkItemId>").append(workItemId).append("</WorkItemId>");
                            wmCompleteWorkItemInputXml.append("<ActivityId>").append(activityId).append("</ActivityId>");
                            if(!synchronousRoutingFlag.equals(""))
                                wmCompleteWorkItemInputXml.append("<SynchronousRouting>").append(synchronousRoutingFlag).append("</SynchronousRouting>");
                            wmCompleteWorkItemInputXml.append("</WMCompleteWorkItem_Input>");
                            parser1.setInputXML(wmCompleteWorkItemInputXml.toString());
                            try
                            {
                                startTime = System.currentTimeMillis();
                                String wmCompleteWorkItemOutputXml = WFFindClass.getReference().execute("WMCompleteWorkItem", engine, con, parser1,gen);
                                parser1.setInputXML(wmCompleteWorkItemOutputXml);
                                endTime = System.currentTimeMillis();
                                WFSUtil.writeLog("WFClientServiceHandlerBean", "WMCompleteWorkItem", startTime, endTime, 0, wmCompleteWorkItemInputXml.toString(), wmCompleteWorkItemOutputXml);
                                wmCompleteWorkItemInputXml = null;
                                mainCode = Integer.parseInt(parser1.getValueOf("MainCode"));
                            }
                            catch(WFSException wfs)
                            {
                                WFSUtil.printErr(engine, "[WFSetAndCompleteWorkItem] : WFSException in WMCompleteWorkItem");
                                WFSUtil.printErr(engine, wfs);
                                throw wfs;
                            }
                        }
                        if(mainCode == 0)
                        {
                            outputXML = new StringBuffer(500);
                            outputXML.append(gen.createOutputFile("WFSetAndCompleteWorkItem"));
                            outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
                            outputXML.append(gen.closeOutputFile("WFSetAndCompleteWorkItem"));
                        }
                        else
                        {
                            subCode = Integer.parseInt(parser1.getValueOf("SubErrorCode", "0", true));
                            subject = parser1.getValueOf("Subject", WFSErrorMsg.getMessage(mainCode), true);
                            descr = parser1.getValueOf("Description", WFSErrorMsg.getMessage(subCode), true);
                            errType = parser1.getValueOf("TypeOfError", WFSError.WF_TMP, true);
                        }
                    }
                    else
                    {
                        subCode = Integer.parseInt(parser1.getValueOf("SubErrorCode", "0", true));
                        subject = parser1.getValueOf("Subject", WFSErrorMsg.getMessage(mainCode), true);
                        descr = parser1.getValueOf("Description", WFSErrorMsg.getMessage(subCode), true);
                        errType = parser1.getValueOf("TypeOfError", WFSError.WF_TMP, true);
                    }
                }
                else
                {
                    subCode = Integer.parseInt(parser1.getValueOf("SubErrorCode", "0", true));
                    subject = parser1.getValueOf("Subject", WFSErrorMsg.getMessage(mainCode), true);
                    descr = parser1.getValueOf("Description", WFSErrorMsg.getMessage(subCode), true);
                    errType = parser1.getValueOf("TypeOfError", WFSError.WF_TMP, true);
                }
            }
            else
            {
                mainCode = WFSError.WM_INVALID_SESSION_HANDLE;
                subCode = 0;
                subject = WFSErrorMsg.getMessage(mainCode);
                descr = WFSErrorMsg.getMessage(subCode);
                errType = WFSError.WF_TMP;
            }
        }
        catch (WFSException e)
        {
            mainCode = e.getMainErrorCode();
            subCode = e.getSubErrorCode();
            subject = e.getErrorMessage();
            errType = e.getTypeOfError();
            descr = e.getErrorDescription();
        }
        catch (SQLException e)
        {
            WFSUtil.printErr("", e);
            mainCode = WFSError.WM_INVALID_FILTER;
            subCode = WFSError.WFS_SQL;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_FAT;
            if (e.getErrorCode() == 0)
            {
                if (e.getSQLState().equalsIgnoreCase("08S01"))
                {
                    descr = (new JTSSQLError(e.getSQLState())).getMessage() + "(SQL State : " + e.getSQLState() + ")";
                }
            }
            else
            {
                descr = e.getMessage();
            }
        }
        catch (NumberFormatException e)
        {
            WFSUtil.printErr("", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_ILP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        }
        catch (NullPointerException e)
        {
            WFSUtil.printErr("", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_SYS;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        }
        catch (JTSException e)
        {
            WFSUtil.printErr("", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = e.getErrorCode();
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.getMessage();
        }
        catch (Exception e)
        {
            WFSUtil.printErr("", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_EXP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        }
        catch (Error e)
        {
            WFSUtil.printErr("", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_EXP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        }
        finally
        {
            if(bWorkItemLocked && ((mainCode != 0 && mainCode != 11) || !completeAlsoFlag))
            {
                StringBuilder wmUnlockWorkItemInputXml = new StringBuilder();
                wmUnlockWorkItemInputXml.append("<?xml version=\"1.0\"?><WMUnlockWorkItem_Input><Option>WMUnlockWorkItem</Option>");
                wmUnlockWorkItemInputXml.append("<EngineName>").append(engine).append("</EngineName>");
                wmUnlockWorkItemInputXml.append("<SessionId>").append(sessionID).append("</SessionId>");                      
                wmUnlockWorkItemInputXml.append("<ProcessInstanceId>").append(processInstanceId).append("</ProcessInstanceId>");   
                wmUnlockWorkItemInputXml.append("<WorkItemId>").append(workItemId).append("</WorkItemId>");
                wmUnlockWorkItemInputXml.append("</WMUnlockWorkItem_Input>");
                parser1.setInputXML(wmUnlockWorkItemInputXml.toString());
                int mainCode1 = 0;
                try
                {
                    startTime = System.currentTimeMillis();
                    String wmUnlockWorkItemOutputXml = WFFindClass.getReference().execute("WMUnlockWorkItem", engine, con, parser1, gen);
                    parser1.setInputXML(wmUnlockWorkItemOutputXml);
                    endTime = System.currentTimeMillis();
                    WFSUtil.writeLog("WFClientServiceHandlerBean", "WMUnlockWorkItem", startTime, endTime, 0, wmUnlockWorkItemInputXml.toString(), wmUnlockWorkItemOutputXml);
                    mainCode1 = Integer.parseInt(parser1.getValueOf("MainCode"));
                }
                catch(WFSException wfs)
                {
                    WFSUtil.printErr(engine, "[WFSetAndCompleteWorkItem] : WFSException in WMUnlockWorkItem with mainCode : " + mainCode1);
                    WFSUtil.printErr(engine, wfs);
                }
                catch(Exception ex)
                {
                    WFSUtil.printErr(engine, "[WFSetAndCompleteWorkItem] : Exception in WMUnlockWorkItem with mainCode : " + mainCode1);
                    WFSUtil.printErr(engine, ex);
                }
            }
           
        }
        if(mainCode != 0)
        {
            throw new WFSException(mainCode, subCode, errType, subject, descr);
        }
        return outputXML.toString();
    }
    
    //----------------------------------------------------------------------------------------------------
//	Function Name 				:	WMDeleteChildWorkItem
//	Date Written (DD/MM/YYYY)   :	01/09/2016
//	Author					    :	Kahkeshan
//	Input Parameters			:	Connection , XMLParser , XMLGenerator
//	Output Parameters			:       none
//	Return Values				:	String
//	Description				:       Deletes a  Child workitem with given ProcessInstanceId and WorkitemId
//----------------------------------------------------------------------------------------------------
// Change Summary *
//----------------------------------------------------------------------------

    private String WMDeleteChildWorkItem(Connection con, XMLParser parser, XMLGenerator gen) throws WFSException {
        int mainCode = 0;
        int subCode = 0;
        String subject = null;
        String descr = null;
        String errType = WFSError.WF_TMP;
        StringBuffer outputXML = new StringBuffer();
		PreparedStatement pstmt = null;
		String query = null;
        ArrayList parameters = new ArrayList();

         try{
            String processInstanceId = parser.getValueOf("ProcessInstanceID", "", false);
            int workitemId = parser.getIntOf("WorkItemId", 0, false);
            String engine = parser.getValueOf("EngineName");
            int dbType = ServerProperty.getReference().getDBType(engine);
            int sessionID = parser.getIntOf("SessionId", 0, false);
            WFParticipant participant = WFSUtil.WFCheckSession(con, sessionID);
                        boolean debug =  parser.getValueOf("DebugFlag", "N", true).equalsIgnoreCase("Y");
                        debug = true;
            if (participant != null) {
				if (workitemId != 1) {

					con.setAutoCommit(false);
					int userid = participant.getid();
					query = "Delete from WFInstrumentTable where ProcessInstanceId = ? and WorkItemID = ? AND ((RoutingStatus = "+WFSUtil.TO_STRING("Y", true, dbType) +" and LockStatus = "+WFSUtil.TO_STRING("Y", true, dbType) +") OR (RoutingStatus = "+WFSUtil.TO_STRING("N", true, dbType) +" and LockStatus = "+WFSUtil.TO_STRING("N", true, dbType) +") OR (RoutingStatus = "+WFSUtil.TO_STRING("R", true, dbType) +" and LockStatus = "+WFSUtil.TO_STRING("N", true, dbType) +") )";
					pstmt = con.prepareStatement(query);
					WFSUtil.DB_SetString(1, processInstanceId, pstmt, dbType);
					pstmt.setInt(2,workitemId);
					parameters.add(processInstanceId);
					parameters.add(workitemId);
					WFSUtil.jdbcExecute(processInstanceId, sessionID, userid, query, pstmt, parameters, debug, engine);

					con.commit();
					con.setAutoCommit(true);

					parameters.clear();
					if (pstmt != null) {
						pstmt.close();
						pstmt = null;
					}
					outputXML = new StringBuffer(500);
					outputXML.append(gen.createOutputFile("WMDeleteChildWorkItem"));
					outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
					outputXML.append("<ProcessInstanceID>" + processInstanceId + "</ProcessInstanceID>");
					outputXML.append("<WorkItemId>" + workitemId + "</WorkItemId>");
					outputXML.append(gen.closeOutputFile("WMDeleteChildWorkItem"));
                } else {
                   mainCode = WFSError.WF_OPERATION_FAILED;
				   subCode = WFSError.WM_INVALID_WORKITEM;
				   subject = WFSErrorMsg.getMessage(mainCode);
				   descr =   WFSErrorMsg.getMessage(subCode);
				   errType = WFSError.WF_TMP;
                }
            } else {
                mainCode = WFSError.WM_INVALID_SESSION_HANDLE;
                subCode = 0;
                subject = WFSErrorMsg.getMessage(mainCode);
                descr = WFSErrorMsg.getMessage(subCode);
                errType = WFSError.WF_TMP;
            }
        } catch (SQLException e) {
            WFSUtil.printErr("", e);
            mainCode = WFSError.WM_INVALID_FILTER;
            subCode = WFSError.WFS_SQL;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_FAT;
            if (e.getErrorCode() == 0) {
                if (e.getSQLState().equalsIgnoreCase("08S01")) {
                    descr = (new JTSSQLError(e.getSQLState())).getMessage() + "(SQL State : " + e.getSQLState() + ")";
                }
            } else {
                descr = e.getMessage();
            }
        } catch (NumberFormatException e) {
            WFSUtil.printErr("", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_ILP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch (NullPointerException e) {
            WFSUtil.printErr("", e);
            //e.printStackTrace();
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_SYS;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch (JTSException e) {
            WFSUtil.printErr("", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = e.getErrorCode();
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.getMessage();
        } catch (Exception e) {
            WFSUtil.printErr("", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_EXP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch (Error e) {
            WFSUtil.printErr("", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_EXP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } finally {

            try {
                if (pstmt != null) {
                    pstmt.close();
                    pstmt = null;
                }
            } catch (Exception e) {
            }

            try {
                if (!con.getAutoCommit()) {
                    con.rollback();
                    con.setAutoCommit(true);
                }
            } catch (SQLException ex) {
            }
           
        }
        if (mainCode != 0) {
            throw new WFSException(mainCode, subCode, errType, subject, descr);
        }
        return outputXML.toString();
    }
    private String WFChangeWorkItemPriority(Connection con, XMLParser parser, XMLGenerator gen) throws WFSException {
        int mainCode = 0;
        int subCode = 0;
        String subject = null;
        String descr = null;
        String errType = WFSError.WF_TMP;
        StringBuffer outputXML = new StringBuffer();
        PreparedStatement pstmt = null;
        boolean commit = false;
        ArrayList parameters = new ArrayList();
        ResultSet rs= null;
        String query=null;
        try {
            
            String engine = "";
            int procDefID = 0;
            int actID = 0;
            String actName = "";
            String lockedTime = "";
            String currentDateTime = "";
            int queueId = 0;
            int sessionID = parser.getIntOf("SessionId", 0, false);
            engine = parser.getValueOf("EngineName");
            boolean debugFlag = parser.getValueOf("DebugFlag", "N", true).equalsIgnoreCase("Y");
            boolean pmMode = parser.getValueOf("OpenMode", "WD", true).equalsIgnoreCase("PM");
            int dbType = ServerProperty.getReference().getDBType(engine);
            WFParticipant participant = WFSUtil.WFCheckSession(con, sessionID);
            if (participant != null && participant.gettype() == 'U') {
                int userID = participant.getid();
                String username = participant.getname();
                String procInstID = parser.getValueOf("ProcessInstanceId", "", false);
                int wrkItemID = parser.getIntOf("WorkItemId", 0, false);
                
                //Checking whether workitem is already locked or not
                boolean isAlreadyLocked = false;                
                query="Select LockStatus from WFInstrumentTable " + WFSUtil.getTableLockHintStr(dbType)+" where ProcessInstanceId = ? and WorkitemId = ? ";
                pstmt = con.prepareStatement(query);
                WFSUtil.DB_SetString(1, procInstID, pstmt, dbType);
                pstmt.setInt(2, wrkItemID);
                pstmt.execute();
                rs = pstmt.getResultSet();
                if(rs!=null&&rs.next()){
                	String lockStatus = rs.getString("LockStatus");
                	if(lockStatus != null && "Y".equalsIgnoreCase(lockStatus)) {
                	isAlreadyLocked = true;
                	}
                }
                if(rs!=null){
                	rs.close();
                	rs=null;
                }
                if(pstmt!=null){
                	pstmt.close();
                	pstmt=null;
                }
                
                
                if(!((((participant.getscope()).equalsIgnoreCase("ADMIN")) || pmMode) || isAlreadyLocked)){
                    StringBuilder wmGetWorkItemInputXml = new StringBuilder();
                    wmGetWorkItemInputXml.append("<?xml version=\"1.0\"?><WMGetWorkItem_Input><Option>WMGetWorkItem</Option>");
                    wmGetWorkItemInputXml.append("<EngineName>").append(engine).append("</EngineName>");
                    wmGetWorkItemInputXml.append("<SessionId>").append(sessionID).append("</SessionId>");
                    wmGetWorkItemInputXml.append("<ProcessInstanceId>").append(procInstID).append("</ProcessInstanceId>");
                    wmGetWorkItemInputXml.append("<WorkItemId>").append(wrkItemID).append("</WorkItemId>");
                    wmGetWorkItemInputXml.append("<UtilityFlag>").append("N").append("</UtilityFlag>");
                    wmGetWorkItemInputXml.append("</WMGetWorkItem_Input>");
                    XMLParser parser1 = new XMLParser();
                    parser1.setInputXML(wmGetWorkItemInputXml.toString());
                    try {
                        Long startTime = System.currentTimeMillis();
                        String wmGetWorkItemOutputXml = WFFindClass.getReference().execute("WMGetWorkItem", engine, con, parser1, gen);
                        parser1.setInputXML(wmGetWorkItemOutputXml);
                        Long endTime = System.currentTimeMillis();
                        WFSUtil.writeLog("WFClientServiceHandlerBean", "WMGetWorkItem", startTime, endTime, 0, wmGetWorkItemInputXml.toString(), wmGetWorkItemOutputXml);
                        wmGetWorkItemInputXml = null;
                        mainCode = Integer.parseInt(parser1.getValueOf("MainCode"));
                    } catch (WFSException wfs) {
                        WFSUtil.printErr(engine, "[WMGetworkItem] : WFSException in WMGetworkItem");
                        WFSUtil.printErr(engine, wfs);
                        mainCode = wfs.getErrorCode();
                    }
                    if(mainCode != 0){
                        subCode = mainCode;
                        mainCode = WFSError.WF_OPERATION_FAILED;
                        subject = WFSErrorMsg.getMessage(mainCode);
                        descr = WFSErrorMsg.getMessage(subCode);
                        errType = WFSError.WF_TMP;
                    }
                } 
                if (mainCode == 0) {
                    if (con.getAutoCommit()) {
                        con.setAutoCommit(false);
                        commit = true;
                    }
                    
                    //Change the priority of referred workitem
                    String workitemids = "";
                    query="Select ParentWorkItemID from WFInstrumentTable " + WFSUtil.getTableLockHintStr(dbType)+" where ProcessInstanceId = ? and WorkitemId = ? ";
                    pstmt = con.prepareStatement(query);
                    WFSUtil.DB_SetString(1, procInstID, pstmt, dbType);
                    pstmt.setInt(2, wrkItemID);
                    pstmt.execute();
                    rs = pstmt.getResultSet();
                    int parentWI=0;
                    if(rs!=null&&rs.next()){
                    	parentWI=rs.getInt(1);
                    }
                    if(rs!=null){
                    	rs.close();
                    	rs=null;
                    }
                    if(pstmt!=null){
                    	pstmt.close();
                    	pstmt=null;
                    }
                    if (parentWI != 0) {
                        int newWorkitemID = wrkItemID;
                        query = "Select ParentWorkItemID, ReferredBy from WFInstrumentTable " + WFSUtil.getTableLockHintStr(dbType) 
                                + " where " + " ProcessInstanceId = ? and WorkitemId = ? ";
                        pstmt = con.prepareStatement(query);
                        /** When a user refer a workitem to another user, there are two copies of workitems
                         * in database with different workitemIds, say user A referred workitem to user B,
                         * then user A will have workitem with Id 1 in his/ her my queue, and user B will have
                         * the one with Id 2, workitem with Id 2 will have parentWorkitemId 1 and workitem with Id 1
                         * will have parentWorkitemId 0, new values if set in attrbutes on workitem with Id 2
                         * should also be updated in workitem with Id 1.
                         */
                        int referby=0;
                        while (true) {
                            WFSUtil.DB_SetString(1, procInstID, pstmt, dbType);
                            pstmt.setInt(2, newWorkitemID);
                            pstmt.execute();
                            rs = pstmt.getResultSet();
                            if (rs.next()) {
                                parentWI = rs.getInt(1);
                                referby = rs.getInt(2);
                                rs.close();
                                rs = null;
                            } else {
                                rs.close();
                                rs = null;
                                break;
                            }
                            if (referby != 0) {
                                workitemids += workitemids.equals("") ? "" + parentWI : "," + parentWI;
                            }else{
                            	break;
                            }
                            newWorkitemID = parentWI;
    						if(parentWI == 1){
    							break;
    						}
                        }
                        pstmt.close();
                        pstmt = null;
                    }
                    
                    int priority = parser.getIntOf("Priority", 0, false);
                    String queryString = "Update WFInstrumentTable Set PriorityLevel = ? where ProcessInstanceId = ? and workitemId = ?";
                    if(workitemids!=null && !workitemids.equalsIgnoreCase("")){
                    	queryString="Update WFInstrumentTable Set PriorityLevel = ? where ProcessInstanceId = ? and ( workitemId = ? OR workitemId in ( "+workitemids+"))";
                    }
                	pstmt = con.prepareStatement(queryString);
                	pstmt.setInt(1, priority);
                	WFSUtil.DB_SetString(2, procInstID, pstmt, dbType);
                	pstmt.setInt(3, wrkItemID);
                	parameters.addAll(Arrays.asList(priority,procInstID, wrkItemID));                 
                    int res = WFSUtil.jdbcExecuteUpdate(procInstID, sessionID, userID, queryString, pstmt, parameters, debugFlag, engine);
                   
                    if (res > 0) {
                        pstmt = con.prepareStatement("Select ProcessDefId, ActivityId, ActivityName, LockedTime, Q_QueueId, " + WFSUtil.getDate(dbType) + " from WFInstrumentTable  where ProcessInstanceId = ? and workitemId = ?");
                        WFSUtil.DB_SetString(1, procInstID, pstmt, dbType);
                        pstmt.setInt(2, wrkItemID);
                        pstmt.execute();
                        rs = pstmt.getResultSet();
                        if (rs != null && rs.next()) {
                            procDefID = rs.getInt(1);
                            actID = rs.getInt(2);
                            actName = rs.getString(3);
                            lockedTime = rs.getString(4);
                            queueId = rs.getInt(5);
                            currentDateTime = rs.getString(6);
                            rs.close();
                            rs = null;
                        }
                        String strPriority;
                        switch (priority) {
                            case 2:
                                strPriority = WFSConstant.CONST_Priority_Value_2;
                                break;
                            case 3:
                                strPriority = WFSConstant.CONST_Priority_Value_3;
                                break;
                            case 4:
                                strPriority = WFSConstant.CONST_Priority_Value_4;
                                break;
                            case 1:
                            default:
                                strPriority = WFSConstant.CONST_Priority_Value_1;
                                break;
                        }
                        WFSUtil.generateLog(engine, con, WFSConstant.WFL_Priority_Set,
                                procInstID, wrkItemID,
                                procDefID, actID, actName, 0,
                                userID, username, 0, strPriority,
                                currentDateTime, "", "", "");
                    } else {
                        mainCode = WFSError.WF_OPERATION_FAILED;
                        subCode = WFSError.WM_INVALID_WORKITEM;
                        subject = WFSErrorMsg.getMessage(mainCode);
                        descr = WFSErrorMsg.getMessage(subCode);
                        errType = WFSError.WF_TMP;
                    }
                    //unlock workitem
                    //create log
                    if(!isAlreadyLocked)
                    {
                    if (queueId == 0) {
                        queryString = "Update WFInstrumentTable set LockStatus = 'N', LockedbyName = null, LockedTime = null where ProcessInstanceId = ? and WorkItemId = ? and LockStatus = ?";
                    } else {
                        queryString = "Update WFInstrumentTable set Q_userid = 0, AssignedUser = null, LockStatus = 'N', LockedbyName = null, LockedTime = null where ProcessInstanceId = ? and WorkItemId = ? and LockStatus = ?";
                    }
                    pstmt = con.prepareStatement(queryString);
                    WFSUtil.DB_SetString(1, procInstID, pstmt, dbType);
                    pstmt.setInt(2, wrkItemID);
                    WFSUtil.DB_SetString(3, "Y", pstmt, dbType);
                    parameters.addAll(Arrays.asList(procInstID, wrkItemID, "Y"));
		    res = WFSUtil.jdbcExecuteUpdate(procInstID, sessionID, userID, queryString, pstmt, parameters, debugFlag, engine);
                    if (res > 0) {
                        WFSUtil.generateLog(engine, con, WFSConstant.WFL_WorkItemUnlock, procInstID, wrkItemID, procDefID,
                                actID, actName, 0, userID, username, 0, null, currentDateTime, null, lockedTime, null);
                    }
                }
                }
            } else {
                mainCode = WFSError.WM_INVALID_SESSION_HANDLE;
                subCode = 0;
                subject = WFSErrorMsg.getMessage(mainCode);
                descr = WFSErrorMsg.getMessage(subCode);
                errType = WFSError.WF_TMP;

            }

            if (mainCode == 0) {
                if (commit && !con.getAutoCommit()) {
                    con.commit();
                    con.setAutoCommit(true);
                    commit = false;
                }
                outputXML = new StringBuffer(500);
                outputXML.append(gen.createOutputFile("WFChangeWorkItemPriority"));
                outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
                outputXML.append(gen.closeOutputFile("WFChangeWorkItemPriority"));
            }
        } catch (SQLException e) {
            WFSUtil.printErr("", e);
            mainCode = WFSError.WM_INVALID_FILTER;
            subCode = WFSError.WFS_SQL;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_FAT;
            if (e.getErrorCode() == 0) {
                if (e.getSQLState().equalsIgnoreCase("08S01")) {
                    descr = (new JTSSQLError(e.getSQLState())).getMessage() + "(SQL State : " + e.getSQLState() + ")";
                }
            } else {
                descr = e.getMessage();
            }
        } catch (NumberFormatException e) {
            WFSUtil.printErr("", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_ILP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch (NullPointerException e) {
            WFSUtil.printErr("", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_SYS;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch (JTSException e) {
            WFSUtil.printErr("", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = e.getErrorCode();
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.getMessage();
        } catch (Exception e) {
            WFSUtil.printErr("", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_EXP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch (Error e) {
            WFSUtil.printErr("", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_EXP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } finally {
            try {
                if (commit && !con.getAutoCommit()) {
                    con.rollback();
                    con.setAutoCommit(true);
                }
            } catch (Exception ex) {
            }
            if (pstmt != null) {
                try {
                    pstmt.close();
                    pstmt = null;
                } catch (Exception e) {
                }
            }
            if (rs != null) {
                try {
                    rs.close();
                } catch (SQLException ex) {
                }
            }
           
        }
        if (mainCode != 0) {
            throw new WFSException(mainCode, subCode, errType, subject, descr);
        }
        return outputXML.toString();
    }
    
     
public String WFBulkLockWorkitem(Connection con, XMLParser parser, XMLGenerator gen) throws JTSException, WFSException {
        int subCode = 0;
        int mainCode = 0;
        int noOfFailedRecord = 0;
        String strFailedProcessInstances = null;
        String strFailedWISubCodes = null;
        String descr = null;
        String subject = null;
        StringBuffer outputXML = new StringBuffer("");
        String errType = WFSError.WF_TMP;
        CallableStatement cstmt = null;
        String engine = "";
        String option = null;
        try {
            option = parser.getValueOf("Option", "", false);
            int sessionID = parser.getIntOf("SessionId", 0, false);
            engine = parser.getValueOf("EngineName");
            int dbType = ServerProperty.getReference().getDBType(engine);
            int queueid = parser.getIntOf("QueueId", 0, false);
            int noOfRecordToLock = parser.getIntOf("NoOfRecordsToLock", ServerProperty.getReference().getBatchSize(), true);
            String strBatchComplete = parser.getValueOf("BatchComplete", "Y", true);
            int NoOfProcessInstanceId = parser.getNoOfFields("ProcessInstanceId");
            WFConfigLocator configLocator = WFConfigLocator.getInstance();
            String strConfigFileName = configLocator.getPath(Location.IBPS_CONFIG) + File.separator + WFSConstant.CONST_DIRECTORY_CONFIG + File.separator + WFSConstant.CONST_FILE_WFAPPCONTEXT;
            //boolean isHistoryNew = CachedObjectCollection.getReference().icon, engine);
            boolean isHistoryNew = true;
            String strHistoryNew;
            if (isHistoryNew) {
                strHistoryNew = "Y";
            } else {
                strHistoryNew = "N";
            }
            XMLParser parserTemp = new XMLParser(WFSUtil.readFile(strConfigFileName));
            int maxNoOfRecord = parserTemp.getIntOf("MaxProcessInstanceCount", 50, true);
            StringBuffer sbProcessInstanceIdList = new StringBuffer();
            StringBuffer sbWorkitemList = new StringBuffer();
            StringBuffer sbFailedProccessInstances = new StringBuffer();
            int startIndex = 0;
            int startIndex1 = 0;
            int startIndex2 = 0;
            int endIndex = 0;
            int endIndex1 = 0;
            int endIndex2 = 0;
            String pInstId = "";
            String wItemId = "";
            if (queueid <= 0) {
                mainCode = WFSError.WF_OPERATION_FAILED;
                subCode = WFSError.WF_INVALID_QUEUE_ID;
                subject = WFSErrorMsg.getMessage(mainCode);
                descr = WFSErrorMsg.getMessage(subCode);
                errType = WFSError.WF_TMP;
            } else if (noOfRecordToLock > maxNoOfRecord) {
                mainCode = WFSError.WF_OPERATION_FAILED;
                subCode = WFSError.WF_BATCH_SIZE_EXCEEDED;
                subject = WFSErrorMsg.getMessage(mainCode);
                descr = WFSErrorMsg.getMessage(subCode);
                errType = WFSError.WF_TMP;

            } else if (noOfRecordToLock != NoOfProcessInstanceId) {
                mainCode = WFSError.WF_OPERATION_FAILED;
                subCode = WFSError.WF_INVALID_BATCH_SIZE;
                subject = WFSErrorMsg.getMessage(mainCode);
                descr = WFSErrorMsg.getMessage(subCode);
                errType = WFSError.WF_TMP;

            }
            else {
                for (int i = 0; i < noOfRecordToLock; i++) {
                    startIndex = parser.getStartIndex("ProcessInstance", endIndex, 0);
                    endIndex = parser.getEndIndex("ProcessInstance", startIndex, 0);
                    pInstId = parser.getValueOf("ProcessInstanceId", startIndex, endIndex).trim();
                    wItemId = parser.getValueOf("WorkItemId", startIndex, endIndex).trim();
                    sbProcessInstanceIdList.append(pInstId + ",");
                    sbWorkitemList.append(wItemId + ",");
                }


                if ((dbType == JTSConstant.JTS_MSSQL) || (dbType == JTSConstant.JTS_ORACLE)) {
                    cstmt = con.prepareCall("{call WFBulkLockWorkitem(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)}");
                    cstmt.setInt(1, sessionID);
                    cstmt.setInt(2, queueid);
                    cstmt.setInt(3, noOfRecordToLock);
                    cstmt.setString(4, strBatchComplete);
                    cstmt.setString(5, strHistoryNew);
                    cstmt.setString(6, sbProcessInstanceIdList.toString());
                    cstmt.setString(7, sbWorkitemList.toString());
                    cstmt.registerOutParameter(8, java.sql.Types.INTEGER);
                    cstmt.registerOutParameter(9, java.sql.Types.INTEGER);
                    cstmt.registerOutParameter(10, java.sql.Types.INTEGER);
                    cstmt.registerOutParameter(11, java.sql.Types.NVARCHAR);
                    cstmt.registerOutParameter(12, java.sql.Types.NVARCHAR);
                }
                cstmt.execute();

                if ((dbType == JTSConstant.JTS_MSSQL || dbType == JTSConstant.JTS_ORACLE)) {
                    mainCode = cstmt.getInt(8);
                    subCode = cstmt.getInt(9);
                    noOfFailedRecord = cstmt.getInt(10);
                    strFailedProcessInstances = cstmt.getString(11);

                }
                if (mainCode != 0) {
                    throw new WFSException(mainCode, subCode, WFSError.WF_TMP, WFSErrorMsg.getMessage(mainCode), WFSErrorMsg.getMessage(subCode));
                } else {
                    outputXML = new StringBuffer(50);
                    if (strBatchComplete.equalsIgnoreCase("N")) {
                        startIndex1 = 0;
                        startIndex2 = 0;
                        strFailedWISubCodes = cstmt.getString(12);
                        while (noOfFailedRecord > 0) {
                            endIndex1 = strFailedProcessInstances.indexOf(",", startIndex1);
                            endIndex2 = strFailedWISubCodes.indexOf(",", startIndex2);
                            sbFailedProccessInstances.append("<ProcessInstanceId>" + strFailedProcessInstances.substring(startIndex1, endIndex1) + "</ProcessInstanceId>\n");
                            sbFailedProccessInstances.append("<Description>" +WFSErrorMsg.getMessage(Integer.parseInt(strFailedWISubCodes.substring(startIndex2, endIndex2))) + "</Description>\n");
                            startIndex1 = endIndex1 + 1;
                            startIndex2 = endIndex2 + 1;
                            noOfFailedRecord = noOfFailedRecord - 1;
                        }
                        outputXML.append(gen.createOutputFile("WFBulkLockWorkitem"));
                        outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
                        outputXML.append("<FailedProcessInstances>\n" + sbFailedProccessInstances + "</FailedProcessInstances>\n");
                        outputXML.append(gen.closeOutputFile("WFBulkLockWorkitem"));
                    } else {
                        outputXML.append(gen.createOutputFile("WFBulkLockWorkitem"));
                        outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
                        outputXML.append(gen.closeOutputFile("WFBulkLockWorkitem"));
                    }

                }
            }
        } catch (SQLException e) {
            WFSUtil.printErr(engine, "", e);
            mainCode = WFSError.WM_INVALID_FILTER;
            subCode = WFSError.WFS_SQL;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_FAT;
            if (e.getErrorCode() == 0) {
                if (e.getSQLState().equalsIgnoreCase("08S01")) {
                    descr = (new JTSSQLError(e.getSQLState())).getMessage() + "(SQL State : " + e.getSQLState() + ")";
                }
            } else {
                descr = e.getMessage();
            }
        } catch (NullPointerException e) {
            WFSUtil.printErr(engine, "", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_SYS;
            subject = WFSErrorMsg.getMessage(mainCode); 
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch (WFSException e) {
            WFSUtil.printErr(engine, "", e);
            mainCode = e.getMainErrorCode();
            subCode = e.getSubErrorCode();
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = WFSErrorMsg.getMessage(subCode);
        } catch (Exception e) {
            WFSUtil.printErr(engine, "", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_EXP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } finally {
            try {
                if (cstmt != null) {
                    cstmt.close();
                    cstmt = null;
                }
            } catch (Exception e) {
            }

           
        }
        if (mainCode != 0) {
            String errorString = WFSUtil.generalError(option, engine, gen, mainCode, subCode, errType, subject, descr);
            return errorString;
        }

        return outputXML.toString();
    }

 public String WFGetSuspendedWorkItem(Connection con, XMLParser parser, XMLGenerator gen) throws JTSException, WFSException {
        int mainCode = 0;
        int subCode = 0;
        StringBuffer outputXML = new StringBuffer("");
        StringBuffer tempXML = null;
        PreparedStatement pstmt = null;
        String engine = "";
        boolean debugFlag = false;
        String subject = null;
        String descr = null;
        String errType = WFSError.WF_TMP;
        ResultSet rs = null;
        try {
            int sessionID = parser.getIntOf("SessionId", 0, false);
            engine = parser.getValueOf("EngineName");
            int processDefId = parser.getIntOf("ProcessDefId", 0, false);
            int activityId = parser.getIntOf("ActivityId", 0, true);
            String utilityType = parser.getValueOf("UtilityType", "", true);
            debugFlag = parser.getValueOf("DebugFlag", "N", true).equalsIgnoreCase("Y");
            boolean isAdmin = false;
            WFParticipant user = WFSUtil.WFCheckSession(con, sessionID);
            int dbType = ServerProperty.getReference().getDBType(engine);
            int noOfRows = ServerProperty.getReference().getBatchSize();
            int userID = 0;
            if (user != null) {
                userID = user.getid();
                if (processDefId > 0) {
                    isAdmin= parser.getValueOf("IsAdmin", "N", true).equalsIgnoreCase("Y");
                    if (isAdmin) {
                        String queryStr = null;
                        if ((activityId == 0) && (utilityType.equals(""))) {
                            queryStr = "select"  + WFSUtil.getFetchPrefixStr(dbType, noOfRows) + " ProcessInstanceId,WorkitemId,EntryDateTime,VAR_REC_3,AssignmentType,URN from WFInstrumentTable " + WFSUtil.getTableLockHintStr(dbType) + " where ProcessDefId =? And ((AssignmentType = 'P') OR (AssignmentType = 'A') OR (AssignmentType = 'B') )"+WFSUtil.getFetchSuffixStr(dbType, noOfRows, WFSConstant.QUERY_STR_AND);
                            pstmt = con.prepareStatement(queryStr);
                            pstmt.setInt(1, processDefId);
                        } else if ((activityId != 0) && (utilityType.equals(""))) {
                            queryStr = "select"  + WFSUtil.getFetchPrefixStr(dbType, noOfRows) + "ProcessInstanceId,WorkitemId,EntryDateTime,VAR_REC_3,AssignmentType,URN from WFInstrumentTable " + WFSUtil.getTableLockHintStr(dbType) + " where ProcessDefId =? And ((AssignmentType = 'P') OR (AssignmentType = 'A') OR (AssignmentType = 'B')) AND ActivityId=?"+WFSUtil.getFetchSuffixStr(dbType, noOfRows, WFSConstant.QUERY_STR_AND);
                            pstmt = con.prepareStatement(queryStr);
                            pstmt.setInt(1, processDefId);
                            pstmt.setInt(2, activityId);
                        } else if ((activityId == 0) && (!utilityType.equals(""))) {
                            queryStr = "select" + WFSUtil.getFetchPrefixStr(dbType, noOfRows) + "ProcessInstanceId,WorkitemId,EntryDateTime,VAR_REC_3,AssignmentType,URN from WFInstrumentTable " + WFSUtil.getTableLockHintStr(dbType) + " where ProcessDefId =? And AssignmentType =?"+WFSUtil.getFetchSuffixStr(dbType, noOfRows, WFSConstant.QUERY_STR_AND);
                            pstmt = con.prepareStatement(queryStr);
                            pstmt.setInt(1, processDefId);
                            WFSUtil.DB_SetString(2, utilityType, pstmt, dbType);
                        } else {
                            queryStr = "select" + WFSUtil.getFetchPrefixStr(dbType, noOfRows) + "ProcessInstanceId,WorkitemId,EntryDateTime,VAR_REC_3,AssignmentType,URN from WFInstrumentTable " + WFSUtil.getTableLockHintStr(dbType) + " where ProcessDefId =? And AssignmentType =? And ActivityId=?"+WFSUtil.getFetchSuffixStr(dbType, noOfRows, WFSConstant.QUERY_STR_AND);
                            pstmt = con.prepareStatement(queryStr);
                            pstmt.setInt(1, processDefId);
                            WFSUtil.DB_SetString(2, utilityType, pstmt, dbType);
                            pstmt.setInt(3, activityId);
                        }
                        ArrayList parameters = new ArrayList();
                        parameters.add(processDefId);
                        rs = WFSUtil.jdbcExecuteQuery(null, sessionID, userID, queryStr, pstmt, parameters, debugFlag, engine);
                        boolean hasRecord = false;
                        if (rs != null) {
                            String assignmentType = null;
                            tempXML = new StringBuffer();
                            tempXML.append("<ProcessInstanceList>");
                            while (rs.next()) {
                                hasRecord = true;
                                tempXML.append("<ProcessInstance>");
                                tempXML.append(gen.writeValueOf("ProcessInstanceId", rs.getString("ProcessInstanceId")));
                                tempXML.append(gen.writeValueOf("URN", rs.getString("URN")));
                                tempXML.append(gen.writeValueOf("WorkItemId", rs.getString("WorkItemId")));
                                assignmentType = rs.getString("AssignmentType");
                                tempXML.append(gen.writeValueOf("AssignmentType", assignmentType));
                                if (assignmentType.equalsIgnoreCase("P")) {
                                    tempXML.append(gen.writeValueOf("SuspendedBy", "Process Server"));
                                }
                                if (assignmentType.equalsIgnoreCase("A")) {
                                    tempXML.append(gen.writeValueOf("SuspendedBy", "Archival"));
                                }
                                if (assignmentType.equalsIgnoreCase("B")) {
                                    tempXML.append(gen.writeValueOf("SuspendedBy", "Print Fax Mail"));
                                }
                                tempXML.append(gen.writeValueOf("SuspensionCause", rs.getString("VAR_REC_3")));
                                tempXML.append(gen.writeValueOf("SuspensionTime", rs.getString("EntryDateTime")));
                                tempXML.append("</ProcessInstance>");
                            }
                            tempXML.append("</ProcessInstanceList>");
                            rs.close();
                            rs = null;
                        }
                        if (!hasRecord) {
                            mainCode = WFSError.WM_NO_MORE_DATA;
                            subCode = 0;
                            subject = WFSErrorMsg.getMessage(mainCode);
                            descr = WFSErrorMsg.getMessage(subCode);
                            errType = WFSError.WF_TMP;
                        }
                    } else {
                        mainCode = WFSError.WF_NO_AUTHORIZATION;
                        subCode = 0;
                        subject = WFSErrorMsg.getMessage(mainCode);
                        descr = WFSErrorMsg.getMessage(subCode);
                        errType = WFSError.WF_TMP;
                    }
                } else {
                    mainCode = WFSError.WF_OPERATION_FAILED;
                    subCode = WFSError.WM_INVALID_PROCESS_DEFINITION;
                    subject = WFSErrorMsg.getMessage(mainCode);
                    descr = WFSErrorMsg.getMessage(subCode);
                    errType = WFSError.WF_TMP;
                }
            } else {
                mainCode = WFSError.WM_INVALID_SESSION_HANDLE;
                subCode = 0;
                subject = WFSErrorMsg.getMessage(mainCode);
                descr = WFSErrorMsg.getMessage(subCode);
                errType = WFSError.WF_TMP;
            }
            if (mainCode == 0) {
                outputXML = new StringBuffer(500);
                outputXML.append(gen.createOutputFile("WFGetSuspendedWorkItem"));
                outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
                outputXML.append(tempXML);
                outputXML.append(gen.closeOutputFile("WFGetSuspendedWorkItem"));
            }
        } catch (SQLException e) {
            WFSUtil.printErr(engine, "", e);
            mainCode = WFSError.WM_INVALID_PROCESS_DEFINITION;
            subCode = WFSError.WFS_SQL;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_FAT;
            if (e.getErrorCode() == 0) {
                if (e.getSQLState().equalsIgnoreCase("08S01")) {
                    descr = (new JTSSQLError(e.getSQLState())).getMessage() + "(SQL State : " + e.getSQLState()
                            + ")";
                }
            } else {
                descr = e.getMessage();
            }
        } catch (NumberFormatException e) {
            WFSUtil.printErr(engine, "", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_ILP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch (NullPointerException e) {
            WFSUtil.printErr(engine, "", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_SYS;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch (WFSException e) {
            mainCode = e.getMainErrorCode();
            subCode = e.getSubErrorCode();
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = WFSErrorMsg.getMessage(subCode);
        } catch (JTSException e) {
            WFSUtil.printErr(engine, "", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = e.getErrorCode();
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.getMessage();
        } catch (Exception e) {
            WFSUtil.printErr(engine, "", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_EXP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch (Error e) {
            WFSUtil.printErr(engine, "", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_EXP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } finally {
           try
            {
                if (rs != null)
                {
                    rs.close();
                    rs = null;
                }
            }
            catch (Exception ignored)
            {}
            try
            {
                if (pstmt != null)
                {
                    pstmt.close();
                    pstmt = null;
                }
            }
            catch (Exception ignored)
            {}
            
        }
        if (mainCode != 0) {
            throw new WFSException(mainCode, subCode, errType, subject, descr);
        }
        return outputXML.toString();
    }
    public String WFResumeSuspendedWorkItem(Connection con, XMLParser parser, XMLGenerator gen) throws JTSException, WFSException {
        int mainCode = 0;
        int subCode = 0;
        StringBuffer outputXML = new StringBuffer("");
        StringBuffer tempXML = null;
        PreparedStatement pstmt = null;
        PreparedStatement pstmt1 = null;
        ResultSet rs = null;
        String engine = "";
        boolean debugFlag = false;
        String subject = null;
        String descr = null;
        String errType = WFSError.WF_TMP;
        try {
            int sessionID = parser.getIntOf("SessionId", 0, false);
            engine = parser.getValueOf("EngineName");
            debugFlag = parser.getValueOf("DebugFlag", "N", true).equalsIgnoreCase("Y");
            WFParticipant user = WFSUtil.WFCheckSession(con, sessionID);
            int dbType = ServerProperty.getReference().getDBType(engine);
            int userID = 0;
            boolean isAdmin = false;
            if (user != null) {
                userID = user.getid();
                isAdmin= parser.getValueOf("IsAdmin", "N", true).equalsIgnoreCase("Y");
                if (isAdmin) {
                    int start = parser.getStartIndex("ProcessInstanceList", 0, 0);
                    int deadend = parser.getEndIndex("ProcessInstanceList", start, 0);
                    int noOfAtt = parser.getNoOfFields("ProcessInstance", start, deadend);
                    int end = 0;
                    tempXML = new StringBuffer();
                    tempXML.append("<ProcessInstanceList>");
                    for (int i = 0; i < noOfAtt; i++) {
                    
                        start = parser.getStartIndex("ProcessInstance", end, 0);
                        end = parser.getEndIndex("ProcessInstance", start, 0);
                        String processInstanceId = parser.getValueOf("ProcessInstanceId", start, end);
                        String workitemIdAsString = parser.getValueOf("WorkItemId", start, end);
                        String assignmentType = parser.getValueOf("AssignmentType", start, end);
                        int workitemId = Integer.parseInt(workitemIdAsString);
                        String queryStr = "select processdefid,activityid,activityname,URN from WFInstrumentTable " + WFSUtil.getTableLockHintStr(dbType) + " where ProcessInstanceId =? And WorkitemId =? And AssignmentType =?";
                        pstmt = con.prepareStatement(queryStr);
                        WFSUtil.DB_SetString(1, processInstanceId, pstmt, dbType);
                        pstmt.setInt(2, workitemId);
                        WFSUtil.DB_SetString(3, assignmentType, pstmt, dbType);
                        ArrayList parameters = new ArrayList();
                        parameters.add(processInstanceId);
                        parameters.add(workitemId);
                        parameters.add(assignmentType);
                        rs = WFSUtil.jdbcExecuteQuery(null, sessionID, userID, queryStr, pstmt, parameters, debugFlag, engine);
                        tempXML.append("<ProcessInstance>");
                        tempXML.append("<ProcessInstanceId>");
                        tempXML.append(processInstanceId);
                        tempXML.append("</ProcessInstanceId>");
                        tempXML.append("<WorkItemId>");
                        tempXML.append(workitemIdAsString);
                        tempXML.append("</WorkItemId>");
                        if(rs.next()){
                        String queryStr1 = "Update WFInstrumenttable set Q_UserId = 0, AssignedUser = null, AssignmentType ='N',RoutingStatus='Y', WorkItemState =6, Statename = 'COMPLETED' , Lockstatus ='N' , VAR_REC_3 = null where ProcessInstanceId = ? AND WorkItemId = ? AND AssignmentType = ?";
                        pstmt1 = con.prepareStatement(queryStr1);
                        WFSUtil.DB_SetString(1, processInstanceId, pstmt1, dbType);
                        pstmt1.setInt(2, workitemId);
                        WFSUtil.DB_SetString(3, assignmentType, pstmt1, dbType);
                        ArrayList parameters1 = new ArrayList();
                        parameters.add(Arrays.asList(processInstanceId, workitemId, assignmentType));
                        int res = WFSUtil.jdbcExecuteUpdate(processInstanceId, sessionID, userID, queryStr, pstmt1, parameters1, debugFlag, engine);
                        parameters.clear();
                        tempXML.append("<URN>");
                        tempXML.append(rs.getString("URN"));
                        tempXML.append("</URN>");
                        if (res > 0) {
                            WFSUtil.generateLog(engine, con, WFSConstant.WFL_Resume, processInstanceId, workitemId, rs.getInt("ProcessDefId"), rs.getInt("ActivityId"), rs.getString("ActivityName"), 0, userID, user.getname(), 0, null, null, null, null, null);
                            tempXML.append("<Status>Success</Status>");
                            tempXML.append("</ProcessInstance>");
                        } else {
                          tempXML.append("<Status>").append(WFSErrorMsg.getMessage(WFSError.WM_INVALID_WORKITEM)).append("</Status>");
                          tempXML.append("</ProcessInstance>");
                        }
                        }else{
                          tempXML.append("<Status>").append(WFSErrorMsg.getMessage(WFSError.WM_INVALID_WORKITEM)).append("</Status>");
                          tempXML.append("</ProcessInstance>");
                        }
                        if (rs != null) {
                            rs.close();
                            rs = null;
                        }
                        if(pstmt != null){
                        	pstmt.close();
                        	pstmt = null;
                        }
                        if(pstmt1 != null){
                        	pstmt1.close();
                        	pstmt1 = null;
                        }
                    }
                    tempXML.append("</ProcessInstanceList>");
                }else {
                        mainCode = WFSError.WF_NO_AUTHORIZATION;
                        subCode = 0;
                        subject = WFSErrorMsg.getMessage(mainCode);
                        descr = WFSErrorMsg.getMessage(subCode);
                        errType = WFSError.WF_TMP;
                    }
            }else {
                mainCode = WFSError.WM_INVALID_SESSION_HANDLE;
                subCode = 0;
                subject = WFSErrorMsg.getMessage(mainCode);
                descr = WFSErrorMsg.getMessage(subCode);
                errType = WFSError.WF_TMP;
            }if (mainCode == 0) {
                outputXML = new StringBuffer();
                outputXML.append(gen.createOutputFile("WFResumeSuspendedWorkItem"));
                outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
                outputXML.append(tempXML);
                outputXML.append(gen.closeOutputFile("WFResumeSuspendedWorkItem"));
            }
        } catch (SQLException e) {
            WFSUtil.printErr(engine, "", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_SQL;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_FAT;
            if (e.getErrorCode() == 0) {
                if (e.getSQLState().equalsIgnoreCase("08S01")) {
                    descr = (new JTSSQLError(e.getSQLState())).getMessage() + "(SQL State : " + e.getSQLState()
                            + ")";
                }
            } else {
                descr = e.getMessage();
            }
        } catch (NumberFormatException e) {
            WFSUtil.printErr(engine, "", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_ILP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch (NullPointerException e) {
            WFSUtil.printErr(engine, "", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_SYS;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch (WFSException e) {
            mainCode = e.getMainErrorCode();
            subCode = e.getSubErrorCode();
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = WFSErrorMsg.getMessage(subCode);
        } catch (JTSException e) {
            WFSUtil.printErr(engine, "", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = e.getErrorCode();
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.getMessage();
        } catch (Exception e) {
            WFSUtil.printErr(engine, "", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_EXP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch (Error e) {
            WFSUtil.printErr(engine, "", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_EXP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } finally {
            try {
                if (rs != null)
                {
                    rs.close();
                    rs = null;
                }
                if (pstmt != null) {
                    pstmt.close();
                    pstmt = null;
                }
                if (pstmt1 != null) {
                    pstmt1.close();
                    pstmt1 = null;
                }
            } catch (Exception e) {
            }
           
        }
        
        if (mainCode != 0) {
            throw new WFSException(mainCode, subCode, errType, subject, descr);
        }
        return outputXML.toString();
    }

    public String WFSuspendWorkitem (Connection con, XMLParser parser, XMLGenerator gen) throws JTSException, WFSException {

        int mainCode = 0;
        int subCode = 0;
        String subject = null;
        StringBuffer outputXML = new StringBuffer("");
        String descr = null;
        String errType = null;
        String engine = null;
        try{
            int sessionID = parser.getIntOf("SessionId", 0, false);
            engine = parser.getValueOf("EngineName");
            WFParticipant participant = WFSUtil.WFCheckSession(con, sessionID);
            if (participant != null) {
			
                WFSUtil.suspendWorkItem(engine, con, participant, parser);
				
            }else {
				mainCode = WFSError.WM_INVALID_SESSION_HANDLE;
				subCode = 0;
				subject = WFSErrorMsg.getMessage(mainCode);
				descr = WFSErrorMsg.getMessage(subCode);
				errType = WFSError.WF_TMP;
				throw new WFSException(mainCode, subCode, errType, subject, descr);
            }
			
			if(mainCode == 0) {
				outputXML = new StringBuffer(500);
				outputXML.append(gen.createOutputFile("WFSuspendWorkitem"));
				outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
				outputXML.append(gen.closeOutputFile("WFSuspendWorkitem"));
			}
           
        }catch(NullPointerException e) {
			WFSUtil.printErr(engine,"", e);
			mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_SYS;
		    subject = WFSErrorMsg.getMessage(mainCode);
			errType = WFSError.WF_TMP;
			descr = e.toString();
		}catch(Exception e) {
		    WFSUtil.printErr(engine,"", e);
		    mainCode = WFSError.WF_OPERATION_FAILED;
		    subCode = WFSError.WFS_EXP;
		    subject = WFSErrorMsg.getMessage(mainCode);
		    errType = WFSError.WF_TMP;
		    descr = e.toString();
		}catch(Error e) {
		    WFSUtil.printErr(engine,"", e);
		    mainCode = WFSError.WF_OPERATION_FAILED;
		    subCode = WFSError.WFS_EXP;
		    subject = WFSErrorMsg.getMessage(mainCode);
		    errType = WFSError.WF_TMP;
		    descr = e.toString();
		}
		
		if(mainCode != 0) {
			throw new WFSException(mainCode, subCode, errType, subject, descr);
		}
		return outputXML.toString();
	}
    
    
    public String WFInvokeDBFuncExecute(Connection con, XMLParser parser, XMLGenerator gen) throws JTSException, WFSException {
        int mainCode = 0;
        int subCode = 0;
        String subject = null;
        StringBuffer outputXML = new StringBuffer("");
        String descr = null;
        String errType = null;
        String engine = null;
        Boolean commit=false;
        String query=null;
        CallableStatement cstmt=null;
        String retString=null;
        Connection con1=null;
        try{
        	engine = parser.getValueOf("EngineName");
        	 int sessionID = parser.getIntOf("SessionId", 0, true);
        	 char omniServiceFlag = parser.getCharOf("OmniService", 'N', true);
        	 WFParticipant participant = null;
        	 if (omniServiceFlag == 'Y') {
        		 participant = new WFParticipant(0, "System", 'P', "SERVER", Locale.getDefault().toString());
 			} else {
 				participant = WFSUtil.WFCheckSession(con, sessionID);
 			}
             if (participant != null) {
            	String userName=participant.getname();
            	String storedProcedureName=parser.getValueOf("StoreProcedureName", "", false);
            	String processInstanceId=parser.getValueOf("ProcessInstanceId", "", true);
            	int workItemId=parser.getIntOf("WorkItemId", 0, true);
            	int processDefId=parser.getIntOf("ProcessDefID", 0, true);
            	int activityId=parser.getIntOf("ActivityID", 0, true);
            	String param1=parser.getValueOf("PARAM1", "", true);
            	int param2=parser.getIntOf("PARAM2", 0, true);
            	String tempParam3=parser.getValueOf("PARAM3", "", true);
            	int returnType=parser.getIntOf("ReturnType",10,true);
            	Date param3=null;
            	if(tempParam3!=null&&!tempParam3.equals("")){
                    //param3=new SimpleDateFormat("yyyy-MM-dd hh:mm:ss.S").parse(tempParam3);
                    try {
            		param3=new SimpleDateFormat("yyyy-MM-dd hh:mm:ss.S").parse(tempParam3);
                      } catch (Exception e) {
                          param3 = Utility.parseDate(tempParam3,"yyyy-MM-dd HH:mm:ss");
            	}
          	}
            	boolean synchRouteflag=WFSUtil.isSyncRoutingMode();
            	if(!synchRouteflag){
            		con1=con;
            	}else{
            		WFUserApiContext userContext = WFUserApiThreadLocal.get();
            		if(userContext!=null){
            			con1=userContext.getConnection();
            		}
            		if(con1==null){
            			con1=con;
            		}
            	}
	        	if(con1.getAutoCommit()){
					con1.setAutoCommit(false);
					commit=true;
				}
				query="{Call "+storedProcedureName+"(?,?,?,?,?,?,?,?)}";
				cstmt=con1.prepareCall(query);
				cstmt.setQueryTimeout(60);
				cstmt.setString(1, processInstanceId);
				cstmt.setInt(2, workItemId);
				cstmt.setInt(3, processDefId);
				cstmt.setInt(4, activityId);
				cstmt.setString(5, param1);
				cstmt.setInt(6, param2);
				if(param3!=null)
					cstmt.setTimestamp(7, new java.sql.Timestamp(param3.getTime()));
				else
					cstmt.setTimestamp(7, null);
				if(returnType==3){
					cstmt.registerOutParameter(8, java.sql.Types.INTEGER);
				}else{
					cstmt.registerOutParameter(8, java.sql.Types.VARCHAR);
				}
				WFSUtil.printOut(engine, "Executing the Procedure " +
						storedProcedureName+" with parameter : "+processInstanceId
						+" , "+workItemId+" , "+processDefId+" , "+activityId+" ,"+
						param1+" , "+ param2+" , "+param3);
				cstmt.execute();
				if(returnType==WFSConstant.WF_INT){
					retString=Integer.toString(cstmt.getInt(8));
				}else{
					retString=cstmt.getString(8);
				}
				WFSUtil.printOut(engine, "Procedure Executed Sucessfully : "+storedProcedureName+" Output: "+retString);
				
				if(commit && !con1.getAutoCommit()){
					con1.commit();
					commit=false;
					con1.setAutoCommit(true);
				}
				outputXML.append("<WFInvokeDBFuncExecute_Output>");
				outputXML.append("<Option>");
				outputXML.append("WFInvokeDBFuncExecute");
				outputXML.append("</Option>");
				outputXML.append("<MainCode>0</MainCode>");
				outputXML.append("<Attribute>").append(retString).append("</Attribute>");
				outputXML.append("<SessionId>").append(sessionID).append("</SessionId>");
				outputXML.append("<UserName>").append(userName).append("</UserName>");
				outputXML.append("</WFInvokeDBFuncExecute_Output>");
				
             }else {
 				mainCode = WFSError.WM_INVALID_SESSION_HANDLE;
 				subCode = 0;
 				subject = WFSErrorMsg.getMessage(mainCode);
 				descr = WFSErrorMsg.getMessage(subCode);
 				errType = WFSError.WF_TMP;
 				throw new WFSException(mainCode, subCode, errType, subject, descr);
             }
        }catch (SQLException e) {
            WFSUtil.printErr(engine, "", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_SQL;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_FAT;
            if (e.getErrorCode() == 0) {
                if (e.getSQLState().equalsIgnoreCase("08S01")) {
                    descr = (new JTSSQLError(e.getSQLState())).getMessage() + "(SQL State : " + e.getSQLState()
                            + ")";
                }
            } else {
                descr = e.getMessage();
            }
        } catch (NumberFormatException e) {
            WFSUtil.printErr(engine, "", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_ILP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch (NullPointerException e) {
            WFSUtil.printErr(engine, "", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_SYS;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch (WFSException e) {
        	mainCode = e.getMainErrorCode();
            subCode = e.getSubErrorCode();
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = WFSErrorMsg.getMessage(subCode);
        } catch (JTSException e) {
            WFSUtil.printErr(engine, "", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = e.getErrorCode();
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.getMessage();
        } catch (Exception e) {
            WFSUtil.printErr(engine, "", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_EXP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch (Error e) {
            WFSUtil.printErr(engine, "", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_EXP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        }finally{
        	try{
				if(commit && !con1.getAutoCommit()){
					con1.rollback();
					commit=false;
					con1.setAutoCommit(true);
				}
			}catch(Exception e){
				WFSUtil.printErr(engine, "", e);
			}
			try{
				if(cstmt!=null){
					cstmt.close();
					cstmt=null;
				}
			}catch(Exception e){
				WFSUtil.printErr(engine, "", e);
			}
			
			con1=null;
			
        }
		if(mainCode != 0) {
			throw new WFSException(mainCode, subCode, errType, subject, descr);
		}
		return outputXML.toString();
	}
        
    public String WFAdhocWorkitem(Connection con, XMLParser parser, XMLGenerator gen) throws JTSException, WFSException {
        int mainCode = 0;
        int subCode = 0;
        StringBuffer outputXML = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String engine = "";
        boolean debugFlag = false;
        String subject = null;
        String descr = null;
        String errType = WFSError.WF_TMP;
        int workItemState = 0;
        String stateName = null;
        int processInstanceState = 0;
        int sourceActivityId = 0;
        String sourceActivityName = null;
        boolean bCommit = false;
        String tarActivityName = null;
        int sessionID = 0;
        WFParticipant user = null;
        String procInstID = null;
        int wrkItemID = 0;
        int targetActivityId = 0;
        int count = -1;
        int processDefId = 0;
        int prevActivityType = 0;
        boolean rightsFlag = false;
        boolean allTasksCompleted = true;
        ArrayList parameters = new ArrayList ();
        try {
            String queryStr = null;
            sessionID = parser.getIntOf("SessionId", 0, false);
            engine = parser.getValueOf("EngineName");
            debugFlag = parser.getValueOf("DebugFlag", "N", true).equalsIgnoreCase("Y");
            int dbType = ServerProperty.getReference().getDBType(engine);
            processDefId = parser.getIntOf("ProcessDefID", 0, true);
            procInstID = parser.getValueOf("ProcessInstanceId", "", false).trim();
            wrkItemID = parser.getIntOf("WorkItemID", 0, false);
            targetActivityId = parser.getIntOf("ActivityID", 0, false);
            int targetActivityType = parser.getIntOf("ActivityType", 0, true);
            String targetActivityName = parser.getValueOf("ActivityName", "", true);
            prevActivityType = parser.getIntOf("PrevActivityType", 0, true);
            String strComments = parser.getValueOf("Comments", "", true);
            boolean pmMode = parser.getValueOf("OpenMode", "WD", true).equalsIgnoreCase("PM");
            String option = parser.getValueOf("Option", "", false);
            int userID = 0;
            String currentDate = null;
            String synchronousRoutingFlag = parser.getValueOf("SynchronousRouting", "N", true);
            boolean bSynchronousRoutingFlag;
            if (synchronousRoutingFlag.equalsIgnoreCase("Y")) {
                bSynchronousRoutingFlag = true;
            } else {
                bSynchronousRoutingFlag = WFSUtil.isSyncRoutingMode();
            }
            boolean allowAdhocRouteForChild = false;
            try {
            	allowAdhocRouteForChild = ((String) WFFindClass.wfGetServerPropertyMap().get(WFSConstant.CONST_ALLOW_ADHOC_ROUTING_CHILD)).equalsIgnoreCase("Y") ? true : false;
            } catch (Exception ignored) {
                
            }
			
            user = WFSUtil.WFCheckSession(con, sessionID);
            if (user != null) {
                userID = user.getid();
                String username = user.getname();
                boolean partOfAdminGroup = isPartOfAdminGroup(con,dbType,userID);
                if(!partOfAdminGroup)
           	     rightsFlag = WFSUtil.checkRights(con, dbType, WFSConstant.CONST_OBJTYPE_ProcessClientWorklist, 0, sessionID, WFSConstant.CONST_ProcessClientWorklist_ADHOC);
               
                if (user.getscope().equalsIgnoreCase("ADMIN")|| pmMode || partOfAdminGroup || rightsFlag) {
                    if (wrkItemID > 1 && !allowAdhocRouteForChild) {
                        mainCode = WFSError.WM_INVALID_WORKITEM;
                        subCode = WFSError.WFS_CHILD_NOT_ADHOC_ROUTED;
                        subject = WFSErrorMsg.getMessage(mainCode);
                        descr = WFSErrorMsg.getMessage(subCode);
                        errType = WFSError.WF_TMP;
                    } else {                    	
                        if (con.getAutoCommit()) {
                            con.setAutoCommit(false);
                            bCommit = true;
                        }
	                        queryStr = "Select ProcessDefId, ActivityId, ActivityName, " + WFSUtil.getDate(dbType) + ",ExpectedWorkItemDelay,EntryDateTime from WFInstrumenttable " + WFSUtil.getTableLockHintStr(dbType) + " where ProcessInstanceId = ? And WorkitemId = ? And( RoutingStatus =?  or  (RoutingStatus =? and processinstancestate in (?,?)))";
	                        pstmt = con.prepareStatement(queryStr);
	                        WFSUtil.DB_SetString(1, procInstID, pstmt, dbType);
	                        pstmt.setInt(2, wrkItemID);
	                        WFSUtil.DB_SetString(3, "N", pstmt, dbType);
	                        WFSUtil.DB_SetString(4, "R", pstmt, dbType);
	                        pstmt.setInt(5, 5);
	                        pstmt.setInt(6, 6);
	                        pstmt.execute();
	                        rs = pstmt.getResultSet();
	                        if (rs != null && rs.next()) {
	                            processDefId = rs.getInt(1);
	                            sourceActivityId = rs.getInt(2);
	                            sourceActivityName = rs.getString(3);
	                            currentDate = rs.getString(4);
	                            String EXWIDelay=rs.getString(5);
	                            String entrydatetime=rs.getString(6);
	                            rs.close();
	                            rs = null;
	                            pstmt.close();
	                            pstmt = null;
	                            queryStr = "Select ActivityName, ActivityType from ActivityTable " + WFSUtil.getTableLockHintStr(dbType) + " where ProcessdefId = ? and ActivityId = ?";
	                            pstmt = con.prepareStatement(queryStr);
	                            pstmt.setInt(1, processDefId);
	                            pstmt.setInt(2, targetActivityId);
	                            rs = pstmt.executeQuery();
	                            if (rs.next()) {
	                                targetActivityName = rs.getString(1);
	                                targetActivityType = rs.getInt(2);
	                                rs.close();
	                                rs = null;
	                                pstmt.close();
	                                pstmt = null;
	                                if (targetActivityType != WFSConstant.ACT_EXT && targetActivityType != WFSConstant.ACT_DISCARD && targetActivityType != WFSConstant.ACT_CUSTOM) {
	                                    mainCode = WFSError.WF_INVALID_TARGET_ACTIVITY;
	                                    subCode = 0;
	                                    subject = WFSErrorMsg.getMessage(mainCode);
	                                    descr = WFSErrorMsg.getMessage(subCode);
	                                    errType = WFSError.WF_TMP;
	                                } else {
	                                    queryStr = "Select ActivityType from ActivityTable " + WFSUtil.getTableLockHintStr(dbType) + " where ProcessdefId = ? and ActivityId = ?";
	                                    pstmt = con.prepareStatement(queryStr);
	                                    pstmt.setInt(1, processDefId);
	                                    pstmt.setInt(2, sourceActivityId);
	                                    rs = pstmt.executeQuery();
	                                    if (rs != null && rs.next()) {
	                                        prevActivityType = rs.getInt(1);
	                                        rs.close();
	                                        rs = null;
	                                        pstmt.close();
	                                        pstmt = null;
	                                        if (prevActivityType != WFSConstant.ACT_EXT && prevActivityType != WFSConstant.ACT_DISCARD && prevActivityType != WFSConstant.ACT_CUSTOM && prevActivityType != WFSConstant.ACT_CASE ) {
	                                            mainCode = WFSError.WF_INVALID_SOURCE_ACTIVITY;
	                                            subCode = 0;
	                                            subject = WFSErrorMsg.getMessage(mainCode);
	                                            descr = WFSErrorMsg.getMessage(subCode);
	                                            errType = WFSError.WF_TMP;
	                                        } else {
	                                            if (targetActivityType == WFSConstant.ACT_CUSTOM) {
	                                                workItemState = 1;
	                                                stateName = "NOTSTARTED";
	                                                processInstanceState = 2;
	                                            } else if (targetActivityType == WFSConstant.ACT_DISCARD) {
	                                                workItemState = 5;
	                                                stateName = "ABORTED";
	                                                processInstanceState = 5;
	                                            } else if (targetActivityType == WFSConstant.ACT_EXT) {
	                                                workItemState = 6;
	                                                stateName = "COMPLETED";
	                                                processInstanceState = 6;
	                                            } 
	                                            if(prevActivityType == WFSConstant.ACT_CASE) {
	                                            	boolean generateCaseSummaryDoc =false;
	                            	            	allTasksCompleted =WFSUtil.isCompletedAllTasks(con, dbType, procInstID, wrkItemID, processDefId, sourceActivityId);
	                            	            	generateCaseSummaryDoc = WFSUtil.isGenerationCaseDocRequired(con,dbType,processDefId, sourceActivityId);
	                            	            	
	                            	            	if(!allTasksCompleted){
	                            	            		mainCode = WFSError.WF_OPERATION_FAILED;
	                            	            		subCode  = WFSError.WF_TASKS_NOT_COMPLETED;
	                            	            		subject = WFSErrorMsg.getMessage(mainCode);
	                            	            		descr = WFSErrorMsg.getMessage(subCode);
	                            	            		errType = WFSError.WF_TMP;
	                            	            		String strReturn = WFSUtil.generalError(option, engine, gen,
	                            	    	   	                   mainCode, subCode,
	                            	    	   	                   errType, subject,
	                            	    	   	                    descr);
	                            	    	   	             
	                            	    	   	        return strReturn;	
	                            	            	}else {
	                            	            		String workitemIDFilter = "";
	                            	                    String workitemIDFilter1="";
	                            	                    if(wrkItemID == 1){
	                                                        workitemIDFilter = " WorkItemID > 1";
	                                                        workitemIDFilter1=" b.WorkItemID > 1";
	                            	                    }
	                            	                    else{
	                                                        workitemIDFilter = " ( WorkItemID = " + wrkItemID + " OR ParentWorkItemID = " + wrkItemID + ") " ; // delete all child of this parent
	                                                        workitemIDFilter1 = " ( b.WorkItemID = " + wrkItemID + " OR b.ParentWorkItemID = " + wrkItemID + ") " ;
	                            	                    }
	                            	                   
	                                                    queryStr = "Delete  from WFTaskStatusTable where processInstanceId = ? and workitemid = ? and processdefid = ? and activityid = ?";
	                                                    
	                                                    pstmt = con.prepareStatement(queryStr);
	                                                    WFSUtil.DB_SetString(1, procInstID, pstmt, dbType);
	                                                    pstmt.setInt(2, wrkItemID);
	                                                    pstmt.setInt(3, processDefId);
	                                                    pstmt.setInt(4, sourceActivityId);
	                                                    parameters.add(procInstID);
	                                                    parameters.add(wrkItemID);
	                                                    parameters.add(processDefId);
	                                                    parameters.add(sourceActivityId);
	                                                    WFSUtil.jdbcExecute(procInstID, sessionID, userID, queryStr, pstmt, parameters, debugFlag, engine);
	                                                    parameters.clear();
	                            	            	}
	                            	            	if(generateCaseSummaryDoc){
	                            	            		WFSUtil.addToCaseSummaryQueue(con, dbType, processDefId,procInstID, wrkItemID, sourceActivityId, sourceActivityName);
	                            	            	}
	                                            }
	                                            queryStr = "UPDATE WFINSTRUMENTTABLE SET ASSIGNMENTTYPE = 'D',QUEUENAME = NULL, QUEUETYPE = NULL, Q_QUEUEID = 0, Q_STREAMID = 0, ROUTINGSTATUS = 'Y', PREVIOUSSTAGE = ?, WORKITEMSTATE = ?, STATENAME = ? , PROCESSINSTANCESTATE  = ?, ACTIVITYNAME = ?, ACTIVITYID = ?, ENTRYDATETIME = " + WFSUtil.getDate(dbType) + ", LockStatus = ? , Q_USERID=0  WHERE PROCESSINSTANCEID = ? AND WORKITEMID = ?";
	                                            pstmt = con.prepareStatement(queryStr);
	                                            WFSUtil.DB_SetString(1, sourceActivityName, pstmt, dbType);
	                                            pstmt.setInt(2, workItemState);
	                                            WFSUtil.DB_SetString(3, stateName, pstmt, dbType);
	                                            pstmt.setInt(4, processInstanceState);
	                                            WFSUtil.DB_SetString(5, targetActivityName, pstmt, dbType);
	                                            pstmt.setInt(6, targetActivityId);
	                                            if (bSynchronousRoutingFlag) {
	                                                WFSUtil.DB_SetString(7, "Y", pstmt, dbType);
	                                            } else {
	                                                WFSUtil.DB_SetString(7, "N", pstmt, dbType);
	                                            }
	                                            WFSUtil.DB_SetString(8, procInstID, pstmt, dbType);
	                                            pstmt.setInt(9, wrkItemID);
	                                            int rs1 = pstmt.executeUpdate();
	                                            if (rs1 > 0) {
	                                                WFSUtil.deleteEscalation(engine, con, procInstID, wrkItemID, processDefId, sourceActivityId);
	                                                WFSUtil.generateLog(engine, con, WFSConstant.WFL_AdHocRouted, procInstID, wrkItemID, processDefId,
	                                                        sourceActivityId, sourceActivityName, 0,
	                                                        userID, username, 0, targetActivityName, currentDate, entrydatetime, null, EXWIDelay);
	                                                pstmt.close();
	                                                pstmt = null;
	                                                if (!strComments.equals("")) {
	                                                    pstmt = con.prepareStatement("Insert Into WFCommentsTable (ProcessDefId, ActivityId, ProcessInstanceId, WorkItemId, CommentsBy, CommentsByName, CommentsTo, CommentsToName, Comments, ActionDateTime, CommentsType) Values (?, ?, ?, ?, ?, ?, ?, ?, ?, " + WFSUtil.getDate(dbType) + ", ?)");
	                                                    pstmt.setInt(1, processDefId);
	                                                    pstmt.setInt(2, targetActivityId);
	                                                    WFSUtil.DB_SetString(3, procInstID, pstmt, dbType);
	                                                    pstmt.setInt(4, wrkItemID);
	                                                    pstmt.setInt(5, userID);
	                                                    WFSUtil.DB_SetString(6, username, pstmt, dbType);
	                                                    pstmt.setInt(7, userID);
	                                                    WFSUtil.DB_SetString(8, username, pstmt, dbType);
	                                                    WFSUtil.DB_SetString(9, strComments, pstmt, dbType);
	                                                    pstmt.setInt(10, WFSConstant.CONST_COMMENTS_ADHOC_ROUTE);
	                                                    pstmt.executeUpdate();
	                                                    pstmt.close();
	                                                    pstmt = null;
	                                                }
	                                                if (bSynchronousRoutingFlag) {
	                                                    WFRoutingUtil.routeWorkitem(con, procInstID, wrkItemID, processDefId, engine, 0, 0, true, bSynchronousRoutingFlag);
	                                                }
	                                            } else {
	                                                mainCode = WFSError.WM_INVALID_WORKITEM;
	                                                subCode = 0;
	                                                subject = WFSErrorMsg.getMessage(mainCode);
	                                                descr = WFSErrorMsg.getMessage(subCode);
	                                                errType = WFSError.WF_TMP;
	                                            }
	                                        }
	                                    } else {
	                                        mainCode = WFSError.WF_INVALID_SOURCE_ACTIVITY;
	                                        subCode = 0;
	                                        subject = WFSErrorMsg.getMessage(mainCode);
	                                        descr = WFSErrorMsg.getMessage(subCode);
	                                        errType = WFSError.WF_TMP;
	                                    }
	                                }
	                            } else {
	                                mainCode = WFSError.WF_INVALID_TARGET_ACTIVITY;
	                                subCode = 0;
	                                subject = WFSErrorMsg.getMessage(mainCode);
	                                descr = WFSErrorMsg.getMessage(subCode);
	                                errType = WFSError.WF_TMP;
	                            }
	                        } else {
	                            mainCode = WFSError.WM_INVALID_WORKITEM;
	                            subCode = 0;
	                            subject = WFSErrorMsg.getMessage(mainCode);
	                            descr = WFSErrorMsg.getMessage(subCode);
	                            errType = WFSError.WF_TMP;
	                        }
	                     
                        if (bCommit) {
                            con.commit();
                            con.setAutoCommit(true);
                            bCommit = false;
                        }
                    }
                } else {
                    mainCode = WFSError.WF_NO_AUTHORIZATION;
                    subCode = 0;
                    subject = WFSErrorMsg.getMessage(mainCode);
                    descr = WFSErrorMsg.getMessage(subCode);
                    errType = WFSError.WF_TMP;
                }
            } else {
                mainCode = WFSError.WM_INVALID_SESSION_HANDLE;
                subCode = 0;
                subject = WFSErrorMsg.getMessage(mainCode);
                descr = WFSErrorMsg.getMessage(subCode);
                errType = WFSError.WF_TMP;
            }
        } catch (SQLException e) {
            WFSUtil.printErr(engine, "", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_SQL;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_FAT;
            if (e.getErrorCode() == 0) {
                if (e.getSQLState().equalsIgnoreCase("08S01")) {
                    descr = (new JTSSQLError(e.getSQLState())).getMessage() + "(SQL State : " + e.getSQLState()
                            + ")";
                }
            } else {
                descr = e.getMessage();
            }
        } catch (NumberFormatException e) {
            WFSUtil.printErr(engine, "", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_ILP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch (NullPointerException e) {
            WFSUtil.printErr(engine, "", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_SYS;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch (WFSException e) {
            mainCode = e.getMainErrorCode();
            subCode = e.getSubErrorCode();
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = WFSErrorMsg.getMessage(subCode);
        } catch (JTSException e) {
            WFSUtil.printErr(engine, "", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = e.getErrorCode();
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.getMessage();
        } catch (Exception e) {
            WFSUtil.printErr(engine, "", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_EXP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } catch (Error e) {
            WFSUtil.printErr(engine, "", e);
            mainCode = WFSError.WF_OPERATION_FAILED;
            subCode = WFSError.WFS_EXP;
            subject = WFSErrorMsg.getMessage(mainCode);
            errType = WFSError.WF_TMP;
            descr = e.toString();
        } finally {
            StringBuilder inputParamInfo = new StringBuilder();
            inputParamInfo.append(gen.writeValueOf("SessionId", String.valueOf(sessionID)));
            inputParamInfo.append(gen.writeValueOf("UserName", (user == null ? "" : user.getname())));
            inputParamInfo.append(gen.writeValueOf("ProcessInstanceID", procInstID));
            inputParamInfo.append(gen.writeValueOf("WorkItemID", String.valueOf(wrkItemID)));
            inputParamInfo.append(gen.writeValueOf("SourceActivityId", String.valueOf(sourceActivityId)));
            inputParamInfo.append(gen.writeValueOf("SourceActivityName", sourceActivityName));
            inputParamInfo.append(gen.writeValueOf("TargetActivityId", String.valueOf(targetActivityId)));
            inputParamInfo.append(gen.writeValueOf("TargetActivityName", tarActivityName));
            if (mainCode == 0) {
                outputXML = new StringBuffer(500);
                outputXML.append(gen.createOutputFile("WFAdhocWorkItem"));
                outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
                outputXML.append("<TotalWorkitemCount>").append(count).append("</TotalWorkitemCount>");
                outputXML.append("<ProcessInstanceState>").append(processInstanceState).append("</ProcessInstanceState>");
                outputXML.append(inputParamInfo);
                outputXML.append(gen.closeOutputFile("WFAdhocWorkItem"));
            }
            try {
                if (rs != null) {
                    rs.close();
                    rs = null;
                }
                if (pstmt != null) {
                    pstmt.close();
                    pstmt = null;
                }
            } catch (Exception e) {
            }
            try {
                if (bCommit) {
                    con.rollback();
                    con.setAutoCommit(true);
                    bCommit = false;
                }
            } catch (SQLException exc) {
            }
            
        }
        if (mainCode != 0) {
            throw new WFSException(mainCode, subCode, errType, subject, descr);
        }
        return outputXML.toString();
    }
    
	//Checkmarx Second Order SQL Injection Solution

	public static String TO_SANITIZE_STRING(String in, boolean isQuery)  {
		
		
		  if (in == null) {
	            return null;
	        }
	        if (!isQuery) {
	            return in.replaceAll("'", "''");
	        } else {
	            String newStr = in.replaceAll("'", "''");

	 

	            return newStr.replaceAll("''", "'");
	        }
	        
	}
    

 } // class WMWorkitem
