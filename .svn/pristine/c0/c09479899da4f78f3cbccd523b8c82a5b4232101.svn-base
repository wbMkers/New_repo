//----------------------------------------------------------------------------------------------------
//              NEWGEN SOFTWARE TECHNOLOGIES LIMITED
//      Group                       : Application Products
//      Product / Project           : WorkFlow
//      Module                      : Transaction Server
//      File Name                   : WMInstrument.java
//      Author                      : Prashant
//      Date written (DD/MM/YYYY)	: 16/05/2002
//      Description                 : implementation of Non WFMC Calls.
//----------------------------------------------------------------------------------------------------
//                      CHANGE HISTORY
//----------------------------------------------------------------------------------------------------
// Date						Change By		Change Description (Bug No. (If Any))
// (DD/MM/YYYY)
//----------------------------------------------------------------------------------------------------
//	01/10/2002		Prashant		Added calls WFSetAttributes , WFGetLinkedWorkItems , WFDeleteWorkItem
//                                  WFGetNextUnlockedWorkitem , WFGetVariableMapping , WFSetVariableMapping
//                                  WFLinkWorkitem
//	26/11/2002		Prashant		Bug No OF_BUG_11
//	26/11/2002		Prashant		Bug No OF_BUG_151
//	17/01/2003		Prashant		Changes to support Search across Process Versions
//	27/01/2003		Prashant		Bug No WFL_2.0.5.014
//	31/05/2003		Prashant		Bug No TSR_3.0.2.0006
//	31/05/2003		Prashant		Bug No TSR_3.0.2.0007
//	31/05/2003		Prashant		Bug No TSR_3.0.2.0008
//	31/05/2003		Prashant		Bug No TSR_3.0.2.0009
//	31/05/2003		Prashant		Bug No TSR_3.0.2.0014
//	31/05/2003		Prashant		Bug No TSR_3.0.2.0016
//	31/05/2003		Prashant		Bug No TSR_3.0.2.0018
//	31/05/2003		Prashant		Bug No WSE_5.0.1_005
//  09/06/2004		Ashish Mangla	Bug No WSE_I_5.0.1_8
//  23/06/2004		Krishan Dutt    Bug No WSE_I_5.0.1_149
//	25/06/2004		Ruhi Hira		Bug No WSE_5.0.1_006
//	25/06/2004		Dinesh Parikh	In getNextUnlockedWorkitemUtil setAutoCommit() makes true.
//	26/06/2004		Dinesh Parikh	In WFGetNextUnlockedWorkItem FilterString to be used. ()
//  07/07/2004		Harmeet Kaur	Bug No WSE_I_5.0.1_695
//	07/07/2004		Ashish Mangla	Bug No WSE_5.0.1_beta_37
//  15/07/2004		Ruhi Hira		Bug # SRU_5.0.1_017 (beta bugs 247)
//  16/07/2004		Ashish Mangla	Bug No WSE_5.0.1_beta_16
//  16/07/2004		Ashish Mangla	Changed SerachView, keep Id of ReferBy and Referedto, removed name from view
//	08/11/2004		Ruhi Hira		WfWorkListView_0 view definition changed, WorkListTable included(Bug # WFS_5_009).
//	30/11/2004		Krishan Dutt	Data to be fetched for workitems those are not part of any Queue(Bug # WFS_5_011).
//	18/01/2005		Harmeet Kaur	WfWorkListView_0 updated (Bug WFS_5.2.1_0007)
//	03/03/2005		Ruhi Hira		SrNo-1, SrNo-2.
//  04/05/2005		Ashish Mangla   WFS_6_012 QueueView definition changed as it was made over  queuetable (a new view as in 3.1.5)
//	06/06/2005		Ashish Mangla	WFS_6_015 getNextUnlockedWorkitem was slow due to use of View, Instead of one single call make three queries on tables directly.
//  07/06/2005		Ruhi Hira		SrNo-3.
//  18/06/2005		Ruhi Hira		Bug # WFS_6_027.
// 	03/08/2005		Mandeep Kaur    SRNo-4(Bug Ref # WFS_5_041)
//  04/08/2005      Mandeep Kaur    SRNo-5(Bug Ref # WFS_5_046)
//  04/08/2005      Mandeep Kaur    SRNo-6 (Bug Ref # WFS_5_048)
//  20/08/2005		Ashish Mangla	SRNo-7 (Queue Association filter on Queue asprovided in 3.1.5 sp10 patch)
//  07/09/2005		Ruhi Hira		Bug # WFS_6_029.
//  15/10/2005		Ruhi Hira		Bug # WFS_6.1_052.
//  20/12/2005		Ruhi Hira		SrNo-8.
//  03/01/2006		Ashish Mangla	SrNo-9 (Query WorkStep)
//  15/02/2006		Ashish Mangla	WFS_6.1.2_049 (Changed WMUser.WFCheckSession by WFSUtil.WFCheckSession)
//  17/04/2006		Ashish Mangla	Bug # WFS_6_039
//  28/07/2006		Ruhi Hira	    Bugzilla Id 47.
//  14/08/2006      Ruhi Hira       Bugzilla Id 61.
//  18/08/2006      Ruhi Hira       Bugzilla Id 54.
//	22/08/2006		Ahsan Javed		Bugzilla # 103
//	24/08/2006		Ahsan Javed		Bugzilla Bug 107
//	25/08/2006		Ahsan Javed		Bugzilla Bug 132
//  09/01/2007		Ashish Mangla	Bugzilla Bug 259	(XML should be cotrrect closing tag should come once and nothing should come after closing tag)
//  16/01/2007		Varun Bhansaly	Bugzilla Id 54 (Provide Dirty Read Support for DB2 Database)
//  15/03/2007		Ashish Mangla	Bugzilla Bug 472 (In case of getLinkedWorkitem Call is sorting is performed on any field which
//										has values for some workitems and is blank for others, batching is not working properly)
//	18/05/2007		Ashish Mangla	Bugzilla Bug 789 (While linking Workitem, if the orig Workitemid is 2, it was checking the same workitemid for the ProcessInstances to be linked)
//  30/05/2007      Ruhi Hira       Bugzilla Bug 637.
//  05/06/2007      Ruhi Hira       WFS_5_161, MultiLingual Support (Inherited from 5.0).
//  08/08/2007      Shilpi S        Bug # 1608
//	06/09/2007		Varun Bhansaly	Added Support for Complex Query Filters.
//  05/09/2007      Ruhi Hira       SrNo-10, Synchronous routing of workitems.
//  19/10/2007		Varun Bhansaly	SrNo-11, Use WFSUtil.printXXX instead of System.out.println()
//									System.err.println() & printStackTrace() for logging.
//	19/11/2007		Varun Bhansaly	WFSUtil.getBIGData() signature changed
//  23/11/2007      Shilpi S        SrNo-12, Export Utility
//  26/11/2007      Tirupati Srivastava      changes in queries for PostgreSql dbase
//  14/12/2007      Shilpi S        Bug # 2740
//  18/12/2007      Shilpi S        Bug # 2795
//  20/12/2007      Ruhi Hira       Bugzilla Bug 1750, Logging for WFL_getlink removed.
//  21/12/2007		Ashish Mangla	Bugzilla Bug 2817 (Tag <EncodedBinaryData> should now be sent on the basis of isEnctrypted column)
//  21/12/2007      Shilpi S        Bug # 2858
//  27/12/2007      Shilpi S        Bug # 3058
//  03/01/2008      Ruhi Hira       Bugzilla Bug 3227, OmniServiceFlag considered in SetAttribute and sessionId made non mandatory in LinkWorkitem.
//  08/01/2008		Ashish Mangla	Bugzilla Bug 1681 (UserName Marco support required)
//	09/01/2008		Varun Bhansaly	Bugzilla Id 3284
//									Bug WFS_5_221 Returning the size of variables in case of char/varchar/nvarchar
//	30/01/2008      Shweta Tyagi    Bug # 3733    mismatch in date format for export utility
//	08/02/2008		Ashish Mangla	Bugzilla Bug 3752 (Alias name gets capitalized)
//  03/06/2008      Shilpi S        BPEL Compliant Omniflow - Complex data type variable's mapping with webservice's parameters
//  10/06/2008      Ruhi Hira       BPEL Compliant Omniflow - Initiation thru web services,
//                                  userDefTypes returned from WFGetProcessVariables
//                                  Bugzilla Bug 5096, getNextUnlockedWorkitemUtil overriden for userDefVarFlag
//  17/06/2008      Ruhi Hira       SrNo-13, New feature : user defined complex data type support [OF 7.2]
//  03/04/3008      Ruhi Hira       Bugzilla Bug 5488, Set command in entry settings does not execute.
//  07/08/2008      Ruhi Hira       Bugzilla Bug 5530, Boolean/ ShortDate/ Time support in pick list.
//  14/08/2008      Varun Bhansaly  SrNo-14, Float precision..Meta-data API WFGetProcessVariables to return precision & length
//									for float variables + deleted commented queries.
//	19/08/2008		Ishu Saraf		TaskId 13 Delete workitem-API checks for reminder
//  25/08/2008      Shilpi S		Complex data type support and optimization in archive
//  25/08/2008      Shilpi S		Complex data type support and optimization in pfe
//  26/08/2008		Amul Jain		Optimization Requirement WFS_6.2_033 (Use of bind variables)
//  23/09/2008		Shweta Tyagi	SrNo-15, Added API WFGetProcessVariableExt for fetching variable information
//  31/10/2008      Shilpi S		SrNo-16, Complex data type support in Picklist
//  05/11/2008		Ashish Mangla	Bugzilla Bug 6894 (Invalid object name)
//  05/11/2008		Ashish Mangla	Bugzilla Bug 6900 (ArgList should be defined while defining template (PFE can also use same arglist))
//  11/11/2008		Ashish Mangla	Bugzilla Bug 6936 (Varprecision should be selected in searchscope also)
//  19/11/2008      Shilpi S		Bug # 6964, Use WFCheckUpdateSession, insteadof WFCheckSession in few calls.
//  11/11/2008      Ruhi Hira       Bugzilla Bug 6941, PickList give error when search with some value in int field in Oracle.
//  28/12/2008		Ashish Mangla	SrNo-17, Supporting both old and new History in case of upgrade
//  30/06/2009      Shilpi S            Bug # 9862
//  31/08/2009		Preeti Awasthi	WFS_8.0_033 WFDeleteWorkItem : Support provided to delete workitem from any activity
//	07/10/09		Indraneel		WFS_8.0_039	Support for Personal Name along with username in fetching worklist,workitem history, setting reminder,refer/reassign workitem and search.
//  02/11/2009      Vikas Saraswat  WFS_8.0_048 Support of Soring on Aliases
//  20/11/2009      Saurabh Kamal   WFS_8.0_061, Support of ProcessDefId in Aliases[Change in WFGetVariableMapping and WFSetVariableMapping]
//  24/11/2009      Nishant Singh	WFS_8.0_062 Requirement of �File name used�in�export workstep in return from export workstep. As per requirement, need to use this file name in client  process for further processing.
//  19/01/10        Saurabh Sinha   WFS_8.0_076 Duplicate entries in export downloaded file.
//	20/01/2010		Indraneel	  	WFS_8.0_077	Add AliasRule column in VarAliasTable to support rule execution in webdesktop.
//  25/01/10	    Saurabh Sinha   WFS_8.0_078 New output file template required with current date and sequence number
//	10/02/2010		Saurabh Kamal	[OTMS]Change in SetVariableMapping
//  03/03/2010		Ashish Mangla	Bugzilla Bug 12075 now search result / criteria tab removed from introduction activity
//  26/04/2010		Ashish Mangla	Bugzilla Bug 12274 (sequence of displaying workitem in queue is not correct)
// 	29/04/2010		Saurabh Kamal	Bugzilla Bug 12091, Incorrect rightInfo.
//	28/10/2010		Saurabh Kamal	Bugzilla Bug 13148, Error while creating WFSearchView in case of postgres database [PickList]
//  18/01/2011      Saurabh Sinha   WFS_8.0_092[Replicated] All the files are not getting exported to the destination.
//  18/01/2011      Saurabh SInha   WFS_8.0_095[Replicated] Null values in getnextworkitem output.
//  18/01/2011      Saurabh Sinha   SRU_8.0_049[Replicated] Export Utility Issues and requirements:
//                                    1.Requirement for dynamic export location.
//                                    2.Error when additional file separator provided as Cs.
//                                    3.Sequence Number change - daily, monthly or yearly as provided by hook.
//                                    4.Time synchronization for file exported date time.
//                                    5.Extra newline issue.
//                                    6.Space issue with values in exported file.
//                                    7.Error in reading new line character.
//  18/01/2011      Saurabh Sinha   WFS_8.0_103[Replicated] Issues:
//									  1. Masked value
//									  2. Date Format configurable
//									  3. Beta Character issue
//									  4. File name issue
//									  5. Error in import utility
//  18/01/2011		Vikas Saraswat	WFS_8.0_105[Replicated] Support of NCLOB Data in Export Utility.
//  18/01/2011      Saurabh SInha   WFS_8.0_110[Replicated]:
//                                    1. Support for DMS update session in case of export Utility.
//                                    2. Sequence string error in case of export.
// 12/09/2011		Saurabh Kamal/Abhishek	WFS_8.0_149[Replicated] Search support on Alias on external on process specific queue
// 02/09/2011       Neeraj Kumar     (Bug 28240) - To delete external table data at the time of deleteworkitem
// 02/02/2012		Bhavneet Kaur	  Bug 30371 [Replicated] Changes for SQL Injection
// 21/03/2012		Vikas Saraswat	  Bug 30800 - sorting is not working on Prev next click after opening the workitem
// 27/03/2012		Vikas Saraswat	  WFS_5_281 Optimization in getNextUnlockedWorkitemUtil[Bug Replicated]
// 29/03/2012		Vikas Saraswat	  WFS_8.0_157: Processdefid tag provided in outputxml of WFDeleteWorkItem API for hook support[Bug Replicated]
//	11/04/2012		Preeti Awasthi	Bug 31008 - Support of sorting on queue variable / system variables on FIFO type queue.
//17/04/2012    	Hitesh Kumar   [Replicated] WFS_8.0_137:
//                                 1 display the Personal Name along with the userid in the Initiated By
//                                 2. Configurable date format.
//                                 3. Get values of queue variables in template.
//24/04/2012        Bhavneet Kaur     Bug 31160: Supprort of defining format of Template to be gererated(Pdf/Doc).
//22/05/2012		Preeti Awasthi	Bug 32089 - Error In WFPickList for aliases on external table variables.
// 05/07/2012     	Bhavneet Kaur   Bug 33029 Cabinet Based Logging for Console, Error, PSError, PSXML & PSOut logs
// 12/09/2012		Preeti Awasthi	Bug 34839 - User should get pop-up for reminder without relogin
//	03/06/2011		Saurabh Kamal	System Queue support in PFE and Archive Utility
//	18/04/2011		Ashish Mangla	WFS_6.2_109[Replicated] Query modified for optimizaion fetching Linked Workitems
// 25/01/2013		Preeti Awasthi	Bug 38072 - Error while deleting workitem from Introduction if no external table is associated
// 05/03/2013		Arun Kishore	Bug 38633 - In process variable mapping of ProcessManager, expectedWorkitemDelay variable was not getting mapped
//21/03/2103		Sajid Khan		Bug 34850 - There is no data in columns 'TAT', 'Valid Till' and 'Status' While TAT is defined in Workitems List 
// 17/05/2013		Shweta Singhal	Process Variant Support Changes
//01/07/2013		Sajid Khan		Bug 38088 - Added alias for variable 'Activityid' is not showing in Process Variable Mapping 
//19/12/2013		Mohnish Chopra	Changes for Code Optimization
//23/12/2013		Shweta Singhal	Changes for Code Optimization Merged
//24/12/2013		Anwar Ali Danish	Changes done in WFLinkWorkitem for code optimization
//24/12/2013		Mohnish Chopra		Changes for code optimization
//10/01/2014		Shweta Singhal		Changes for code optimization in getNextUnlockedWorkitemUtil()
//24/01/2014		Kahkeshan			Merging of WMAssignWorkitemAttributes with WMStartProcess and WMCompleteWorkitem for reducing network slowness.
//05/02/2014		Kahkeshan			Queue Caching Changes ,LastModifiedOn Column support in QueueDefTable
//07-02-2014		Sajid Khan			AliasId returned for defined alias in WFGetVariableMapping call[OF MOBILE requirement]
//17-02-2014		Kahkeshan		    For MSSQL GetNextUnlockedWorkitem index was made on q_queueid,workitemstate but the same was not used while fetching data ,same done now 
//										and check for workitemstate>6 removed
//18-02-2014		Kahkeshan			LockStatus and RoutingStatus check added in query for GetNextUnlockedWorkitem.
//18-02-2014		Shweta Singhal      Workitem which has routingStatus as N and LockStatus as N have workitemstate <3, So no need to put extra filter in query
//24-03-2014		Mohnish Chopra		Changes in WFGetWorkItemData API and getNextUnlockedWorkitemUtil
//28-03-2014		Kahkeshan			Code Optimization : Removal Of Views
//04-04-2014		Mohnish Chopra		Code Optimization : Return Error message in WFSetAttributes if workitem has expired
//08-04-2014		Sajid Khan			Bug 44006 - In Opened Workitem view , if there is some error in Introducing WI then error message should show.
//17-04-2014        Kanika Manik        Bug 44444 - While search with data for "nText" type variable from Quick search, an error is generated.
//18/04/2014		Kahkeshan			Bug 44459  Unable to Start Export Utility if I use set Filter property in Export Utility.
//09-05-2014            Sajid Khan      Bug 45440 - IF Session is expired and now save the workitem, relevant error message should be shown on UI.
//26/05/2014        Kanika Manik        PRD Bug 42840 - Support for configurable Subject Field in Mailing Utility.
//05/06/2014        Kanika Manik        PRD Bug 42177 - Restriction of SQL Injection in APIs 
// 11/06/2014       Anwar Danish        PRD Bug 42861 merged - In omniflow UserQueueTable is replaced with QUserGroupView to provide omniflow support for applications not using WMconnect call.
//16/06/2014		Mohnish Chopra		Changes in WFGetLinkedWorkitems- If linked workitem is archived , then Archived flag should be set as Y in output of API.
//										Also there is a change in WFLinkWorkitem as table structure of WFLinksWorkItem is changed.
//17-06-2014		Sajid KHan			Bug 46408 - Advance Search: While click on Picklist icon, an error 'Requested operation Failed' is showing in Picklist.
//03-07-2014		Sajid Khan			Mailing Service getting failed whenver NotifyByMal=il Flag is Y bacause Query being formed is wrong.
//12-08-2014		Sajid Khan			Multilingual Support for Queue, Activity, Process,Aliases - Bug 41790.
//18/05/2015		Mohnish Chopra		Changes in WFSetAttributes for Case Management for Completing a task. 
//28/07/2015		Anwar Danish		PRDP Bug 51341 merged - To provide support to fetch action description/statement corresponding to each actionId at server end via WFGetWorkItemHistory and WFGetHistory API call itself.
//11/08/2015		Mohnish Chopra		Changes for Data locking issue in Case Management 
//07/12/2015        Kirti Wadhwa		Bug 58080 - error while saving task after editing value of combo box
//02/08/2016		Kirti Wadhwa        Made changes in WFGetWorkitemData for Bug 58974 - EAP+SQL+WINDOWS: in property of workitem, its shown as locked by current user
//07/07/2016		Mohnish Chopra		UT Defect 62583:  Changes for Postgres in WFGetLinkedWorkItem
//07/07/2016		Mohnish Chopra		Changes for Postgres in getNextUnlockedWorkitemUtil
//14/02/2017		Rakesh K Saini		Bug 58357 :Workitems are not fetched according to the Order By ColumnName for FIFO Queues.
//15/02/2017        RishiRam            Bug 66721 - When a user searched workItem , not opened, but that workItem is assigning to that user. If user doesn’t have rights for that queue also still that workitem is assigning to that user.
//17/02/2017        RishiRam            Sorting is not working properly for APIs LIke WFGetNextWorktiemForPFE, WFGetNextWorktiemForArchieve, WFGetNextWorktiemForPublish etc,,
//28/07/2015		Sweta Bansal	    Bug 56062 - Handling done to use WFUploadWorkitem API for creating workitem in SubProcess(Subprocess/Exit) and to perform operation like: workitem creation in subprocess, Bring ParentWorkitem in flow when child routed to exit, will be performed before CreateWorkitem.
//07/03/2017        RishiRam Meel      	Bug 67796 - iBPS 3.0 SP-2: Archive Utility is not executing Workitem, Wi is getting stuck at DMS workstep
//10/03/2017                 Sajid Khan             Bug 67568 - Deletion of Audit Logs after audit trail archieve.
//	17/03/2017		Sweta Bansal		Changes done for removing support of CurrentRouteLogTable in the system.
//05 April 2017		Sajid Khan			Bug 68239 - Default WorkList Configuration fields are deleted while Defininig Variable mapping for My Queue
//29-Apr-2017           Sajid Khan          Meging Bug 62599: Upgrade the custom upload and custom upload history table on File Upload and Import utility start.
//09-05-2017            Sajid Khan			Queue Varaible Extension Enahncement
//24/05/2017		Mohnish Chopra		Changes for nested complex array requirement for batching
//31/05/2017		Mohnish Chopra		Changes for Archival in WFGetWorkitemData
//16 June 2017      Kumar Kimil         Queue variable Alias in FIFO queues
//30/06/2017           Kumar Kimil          Email Notification to Case Manager and Task Initiator whenever a task gets completed
//11/08/2017 		Mohnish Chopra		Changes for Case Summary document generation requirement and Adhoc task approach changes
//19/08/2017        Kumar Kimil       Process Task Changes(Synchronous and Asynchronous)

//20/08/2017        Sajid Khan          PRDP Bug 69647 - Call to WFLinkWorkitem to be removed from Process Server .Bug 68315 reverted also.
//06/09/2017		Mohnish Chopra		Changes for Adhoc task data saving approach
//06/09/2017        Kumar Kimil             Process task Changes (User Monitored,Synchronous and Asynchronous)
//15/09/2017        Kumar Kimil         Changes in WFLinkWorkitem for Process Task(after common code sync)
//19/09/2017		Mohnish Chopra		Changes for PRDP Bug 70739 - Handling for showing parent workitem name in the history of child workitem in case the workitem is linked/delinked.	
//20/09/2017		Mohnish Chopra			Changes for Sonar issues
//4/10/2017			Ambuj Tripathi			Added feature for adding the expiry and escalation for adhoc tasks.
//4/10/2017 		Mohnish Chopra		Bug 72311 - EAP 6.2 +SQL: After approval, unable to 'done' the workitem. Getting error 'The requested filter is invalid"
//04/10/2017        Kumar Kimil         Bug 72004 - EAP 6.4+SQL:-Should not ask to approved in case if both case manager and case worker in the task are same
//24/10/2017		Ambuj Tripathi		Changes for Case Registration name changes(Added URN as the output in WFGetWorkitemData API)
//24/10/2017		Mohnish Chopra		Changes for Case Registration changes for FIFO Queue(Added URN as the output in WFGetWorkitemData)
//01/11/2017		Ambuj Tripathi		Bug 73014 - WBL+Oracle: Getting error message in Picklist of String Type Alias instead of value or relevant message, encoding the Values in the output XML.
//15/11/2017        Kumar Kimil     API Changes for Case Registration
//22/11/2017        Kumar Kimil     Multiple Precondition enhancement
//07/12/2017		Ambuj Tripathi	Bug#71971 merging :: Sessionid and other important input parameters to be added in output xml response of important APIs
//03/01/2018		Mohnish Chopra		Bug 74326 - EAP6.4+SQL: If reassign task, URN should be shown in mail notification instead of processinstanceid & change label name of Case ID
//15/01/2018		Ambuj Tripathi	Sonar bug fixed for rule : Multiline blocks should be enclosed in curly braces
//22/02/2018		Ambuj Tripathi	Bug 75515 - Arabic ibps 4: Validation message is coming in English and that out of colored area 
//30/03/2018		Ambuj Tripathi	Bug 76622 - WAS+Oracle+ Linux: WI is stuck at SAP Activity in asynchronous mode
//05/04/2018		Mohnish Chopra	Bug  - User is able to delete a workitem even if he is not having rights on Initiation queue. 
//10/05/2018            Sajid Khan      Bug 77392 EAP 6.4+SQL: Intuitive assignee name should be come in worklist if workitem is present on System queue
//10/05/2018        Ambuj Tripathi  [Bug 77186] EAP6.4+SQL: Interface is completely distorted when WI is opened from mail
// 14/05/2018			Ambuj Tripathi		PRD Bug 73436 - Support for various type of template in generate response of PFE utility. Generate response code will be common to PFE and Webdesktop as well. 
//22/05/2018		Ambuj Tripathi	Reverting PRD Bug 77201 changes
//03/07/2018		Ambuj Tripathi	Bug 78208 - NOLOCK is missing in WFSessionView, WFUserView and PSRegisterationTable
//10/12/2018        Shubham Singla  Bug 81849 - Case Summary document not generating if there are duplicate entries for workitem in casesummarydetailstable. 
//01/01/2018        Shubham Singla  Bug 82212 - IBPS 4.0:In Helpdesk System, the comments containing & comes as & in case summary document.
//07/01/2019		Ravi Ranjan Kumar Bug 81823 - Advance search not working getting error " org.postgresql.util.PSQLException: The column name EntityName was not found in this ResultSet." onj selecting process name(merging from sp2 bug)
//07/01/2019	Ravi Ranjan Kumar	Bug 82344 - Providing backward compatibility for insertion or deletion of complex data
//29/04/2019		Ambuj Tripathi	Bug 84390 - Error occuring while completing task
//22/07/2019        Ravi Ranjan Kumar Bug 85705 - Write SP for fetching next item for utilities
//08/08/2019        Shubham Singla  Bug 85850 - iBPS 4.0+Oracle:WFpickList call returning error when external variable is used as search variable in oracle case. 
//11/10/2019		Ravi Ranjan Kumar  Bug 85910 - Optimization in WFGetNextWorkItemForUtil procedure (PRDP Bug Merging)
//25/10/2019		Ambuj Tripathi	Landing page (Criteria Management) Requirement.
//11/07/2019		Ravi Ranjan Kumar	Bug 87904 - Support of Sorting on Process Search Result Variable(Only old queue variable )
//14/11/2019		Ravi Ranjan Kumar	Bug 88152 - Long variable Type not displayed in Variable Name in quick search management. 
//18/11/2019		Ambuj Tripathi		Internal Bug fix - Changes to send the sorting information for Alias variabels.
//20/11/2019		Ambuj Tripathi		Internal UT bug fix - removing the alias from the select column
//22/11/2019		Ravi Ranjan Kumar	Bug 88529 - Criteria cannot be created from criteria management screen 
//10/12/2019	Ravi Ranjan Kumar PRDP Bug Merging(Bug 87270 - Handling done to execute product API's even if API name in input xml has different case.)
//20/12/2019		Ambuj Tripathi	Changes for DataExchange Functionality
//05/02/2020		Shahzad Malik		Bug 90535 - Product query optimization
//11/03/2020        Shubham Singla     Bug 90573 - iBPS 4.0:Wrong search variables are getting displayed when two query worksteps are used.
//09/04/2020		Shahzad Malik		Bug 91513 - Optimization in mailing utility.
//09/07/2020		Mohnish Chopra		Bug 93231 - Validation required in WMAssignWorkItemAttributes API
//21/07/2020		Ravi Ranjan Kumar	Bug 93335 - Registration no not showing on validation message on link WI.
//28/07/2020     Shubham Singla     Bug 93351 - iBPS 4.0 :-Wrong processdefId is getting returned from the table if the entry for the disabled process is present when alias is defined for the external varriables.
//03/11/2020     Satyanarayan Sharma   Optimization in API WFGETWORKITEMDATA. We dont  need to consider queryworkstep flag in inputxml
//02/11/2020        Sourabh Tantuway   Bug 95789 - iBPS 5.0 SP1: Requirement for showing search variable aliases in Advance Search.
//26/11/2020    Ravi Raj Mewara     Bug 96279 - iBPS 5.0: Wrong values of ProcessDefId and WorkitemId are updated in WFCurrentRouteLogTable when deleting workitem .
//12/04/2021    Shubham Singla     Bug 99074 - iBPS 4.0 SP1:-Workitem is not coming on clicking the FIFO when value for any of alias defined contains special characters.
//06/11/2020    Sourabh Tantuway Bug 95940 - iBPS 4.0 : Requirement for optimizations related to workitem expiry.
//03/10/2021    Ravi Raj Mewara    Bug 101832 - iBPS 5.0 SP2 : In WFPickList output, special character in value of '<Value>' tag got handled twice
//23/09/2022    Nikhil Garg        Bug 115930 - IBPS 5.0 SP2 - Handling Error of Alias variable in FIFO Queue
//17/04/2023	Vaishali Jain		iBPS5x - CQRN-0000259119 - Requirements in Task Email notification
//----------------------------------------------------------------------------------------------------
package com.newgen.omni.jts.txn.wapi;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Set;
import java.util.StringTokenizer;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;

import com.newgen.omni.jts.cache.CachedObjectCollection;
import com.newgen.omni.jts.cmgr.XMLGenerator;
import com.newgen.omni.jts.cmgr.XMLParser;
import com.newgen.omni.jts.constt.JTSConstant;
import com.newgen.omni.jts.constt.WFSConstant;
import com.newgen.omni.jts.dataObject.WFFieldInfo;
import com.newgen.omni.jts.dataObject.WFUserInfo;
import com.newgen.omni.jts.dataObject.WFVariabledef;
import com.newgen.omni.jts.dataObject.WMAttribute;
import com.newgen.omni.jts.excp.JTSException;
import com.newgen.omni.jts.excp.JTSSQLError;
import com.newgen.omni.jts.excp.WFSError;
import com.newgen.omni.jts.excp.WFSErrorMsg;
import com.newgen.omni.jts.excp.WFSException;
import com.newgen.omni.jts.srvr.DatabaseTransactionServer;
import com.newgen.omni.jts.srvr.ServerProperty;
import com.newgen.omni.jts.srvr.WFFindClass;
import com.newgen.omni.jts.util.EmailTemplateUtil;
import com.newgen.omni.jts.util.WFPDAUtil;
import com.newgen.omni.jts.util.WFSExtDB;
import com.newgen.omni.jts.util.WFSUtil;
import com.newgen.omni.jts.util.WFTMSUtil;
import com.newgen.omni.jts.util.WFTaskInfoClass;
import com.newgen.omni.jts.util.WFTaskThreadLocal;
import com.newgen.omni.jts.util.WFXMLUtil;

public class WMInstrument extends com.newgen.omni.jts.txn.NGOServerInterface {

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
		// Changed By							: Prashant
		// Reason / Cause (Bug No if Any)	: WFL_2.0.5.014
		// Change Description			: Call names WFFetchWorkitems changed
		//----------------------------------------------------------------------------
		if (("WFGetNextUnlockedWorkitem").equalsIgnoreCase(option)) {
			outputXml = WFGetNextUnlockedWorkitem(con, parser, gen);
		} else if (("WFSetAttributes").equalsIgnoreCase(option)) {
			outputXml = WFSetAttributes(con, parser, gen);
		} else if (("WFGetResponseFile").equalsIgnoreCase(option)) {
			outputXml = WFGetResponseFile(con, parser, gen);
		} else if (("WFGetRecordMappedFields").equalsIgnoreCase(option)) {
			outputXml = WFGetRecordMappedFields(con, parser, gen);
		} else if (("WFGetStateList").equalsIgnoreCase(option)) {
			outputXml = WFGetStateList(con, parser, gen);
		} else if (("WFGetProcessVariables").equalsIgnoreCase(option)) {
			outputXml = WFGetProcessVariables(con, parser, gen);
			// --------------------------------------------------------------------------------------
			// Changed On  : 03/03/2005
			// Changed By  : Ruhi Hira
			// Description : SrNo-1, Omniflow 6.0, API not in use hence code commented.
			// --------------------------------------------------------------------------------------
			//    } else if(("WFGetProcessData").equals(option)) {
			//    outputXml = WFGetProcessData(con, parser, gen);
		} else if (("WMAssignWorkItemAttributes").equalsIgnoreCase(option)) {
			outputXml = WFSetAttributes(con, parser, gen);
		} else if (("WFGetVariableMapping").equalsIgnoreCase(option)) {
			outputXml = WFGetVariableMapping(con, parser, gen);
		} else if (("WFSetVariableMapping").equalsIgnoreCase(option)) {
			outputXml = WFSetVariableMapping(con, parser, gen);
		} else if (("WFLinkWorkitem").equalsIgnoreCase(option)) {
			outputXml = WFLinkWorkitem(con, parser, gen);
		} else if (("WFGetLinkedWorkitems").equalsIgnoreCase(option)) {
			outputXml = WFGetLinkedWorkitems(con, parser, gen);
		} else if (("WFDeleteWorkItem").equalsIgnoreCase(option)) {
			outputXml = WFDeleteWorkItem(con, parser, gen);
		} else if (("WFGetNextUnlockedWorkItemforMail").equalsIgnoreCase(option)) {
			outputXml = WFGetNextWorkitemforMail(con, parser, gen);
		} else if (("WFGetNextWorkitemforPrintFaxMail").equalsIgnoreCase(option)) {
			outputXml = WFGetNextWorkitemforPrintFaxMail(con, parser, gen);
		} else if (("WFGetNextWorkitemforArchive").equalsIgnoreCase(option)) {
			outputXml = WFGetNextWorkitemforArchive(con, parser, gen);
		} else if (("WFGetNextWorkitemforPublish").equalsIgnoreCase(option)) {
			outputXml = WFGetNextWorkitemforPublish(con, parser, gen);
		} else if (("WFPickList").equalsIgnoreCase(option)) {
			outputXml = WFPickList(con, parser, gen);
		} else if (("WFGetWorkitemData").equalsIgnoreCase(option)) {
			outputXml = WFGetWorkitemData(con, parser, gen);
		} else if (("WFGetNextRecordForExport").equalsIgnoreCase(option)) { //SrNo-12
			//outputXml = WFGetNextRecordForExport(con, parser, gen);
		} else if (("WFSetRecordStatusForExport").equalsIgnoreCase(option)) { //SrNo-12
			//outputXml = WFSetRecordStatusForExport(con, parser, gen);
		} else if (("WFGetProcessVariablesExt").equalsIgnoreCase(option)) { //SrNo-15//
			outputXml = WFGetProcessVariablesExt(con, parser, gen);
		} else if (("WFGetLastExportFileTime").equalsIgnoreCase(option)) {
			//outputXml = WFGetLastExportFileTime(con, parser, gen);	
		} else if (("WFGetNextWorkitemforSharepoint").equalsIgnoreCase(option)) {
			outputXml = WFGetNextWorkitemforSharepoint(con, parser, gen);	
		} else if (("WFCheckLastExportFileExistence").equalsIgnoreCase(option)) {
			//outputXml = WFCheckLastExportFileExistence(con, parser, gen);
		}else if(("WFPopulateAuditTrailList").equalsIgnoreCase(option)){	//WFS_6.2_057
                        //outputXml = WFPopulateAuditTrailList(con, parser, gen);       
                } else if (("WFGetNextWorkitemforArchiveAudit").equalsIgnoreCase(option)) {
                    //outputXml = WFGetNextWorkitemforArchiveAudit(con, parser, gen);
                } else if(("WFCompleteWorkitemforArchiveAudit").equalsIgnoreCase(option)) {
                        //outputXml = WFCompleteWorkitemforArchiveAudit(con, parser, gen);
                } else if (("WFGetSystemVariableList").equalsIgnoreCase(option)) {
			outputXml = WFGetSystemVariableList(con, parser, gen);
		} else if(("WFGetNextWorkitemforCaseSummary").equalsIgnoreCase(option)){
			outputXml = WFGetNextWorkitemforCaseSummary(con, parser, gen);
		} else if(("WFGetProcessVariablesList").equalsIgnoreCase(option)){
			outputXml = WFGetProcessVariablesList(con, parser, gen);
		}else if (option.equalsIgnoreCase("WFPurgeWorkItem")) {
			outputXml = WFPurgeWorkItem(con, parser, gen);
		}  else if (option.equalsIgnoreCase("WFGetNextWorkitemforSystem")) {
			outputXml = WFGetNextWorkitemforSystem(con, parser, gen);
		}
			
	else {
			outputXml = gen.writeError("WMInstrument", WFSError.WF_INVALID_OPERATION_SPECIFICATION, 0,
					WFSErrorMsg.getMessage(WFSError.WF_INVALID_OPERATION_SPECIFICATION), null, WFSError.WF_TMP);
		}
		return outputXml;
	}

	//----------------------------------------------------------------------------------------------------
	//	Function Name 				:	WFGetRecordMappedFields
	//	Date Written (DD/MM/YYYY)	:	16/05/2002
	//	Author						:	Prashant
	//	Input Parameters			:	Connection , XMLParser , XMLGenerator
	//	Output Parameters			:   none
	//	Return Values				:	String
	//	Description					:   Get Record MappedFields for a Process Definiton
	//----------------------------------------------------------------------------------------------------
	// Deprecated : Tirupati Srivastava
	public String WFGetRecordMappedFields(Connection con, XMLParser parser,
			XMLGenerator gen) throws JTSException, WFSException {
		StringBuffer outputXML = new StringBuffer("");
		PreparedStatement pstmt = null;
		ResultSet rs =null;
		int mainCode = 0;
		int subCode = 0;
		String subject = null;
		String descr = null;
		String errType = WFSError.WF_TMP;
		String engine ="";
		try {
			engine = parser.getValueOf("EngineName");
			int dbType = ServerProperty.getReference().getDBType(engine);
			int sessionID = parser.getIntOf("SessionId", 0, false);
			String processInst = parser.getValueOf("ProcessInstanceId", "", false);
			StringBuffer tempXml = null;

			WFParticipant user = WFSUtil.WFCheckSession(con, sessionID);
			if (user != null && user.hashCode() == 'U') {
				tempXml = new StringBuffer(100);

				pstmt = con.prepareStatement(
						//" Select DatabaseName, DatabaseType, TableName, b.ExtObjID, REC1, VAR_REC_1, " + "REC2, VAR_REC_2, REC3 , VAR_REC_3, REC4 ,VAR_REC_4, REC5 , VAR_REC_5 from " + "QueueDataTable a , ExtDBConfTable b , RecordMappingTable c where a.ProcessDefID " + "= b.ProcessDefID and c.ProcessDefID = a.ProcessDefID and ProcessInstanceId = ? ");
                        " Select DatabaseName, DatabaseType, TableName, b.ExtObjID, REC1, VAR_REC_1, " + "REC2, VAR_REC_2, REC3 , VAR_REC_3, REC4 ,VAR_REC_4, REC5 , VAR_REC_5 from " + "WFInstrumentTable a " + WFSUtil.getTableLockHintStr(dbType) +"  , ExtDBConfTable b " + WFSUtil.getTableLockHintStr(dbType) +"  , RecordMappingTable c " + WFSUtil.getTableLockHintStr(dbType) +"  where a.ProcessDefID " + "= b.ProcessDefID and c.ProcessDefID = a.ProcessDefID and ProcessInstanceId = ? ");
				WFSUtil.DB_SetString(1, processInst, pstmt, dbType);
				pstmt.execute();
				 rs = pstmt.getResultSet();
				if (!rs.next()) {
					pstmt = con.prepareStatement(
							" Select DatabaseName, DatabaseType, TableName, b.ExtObjID, REC1, VAR_REC_1, " + "REC2, VAR_REC_2, REC3 , VAR_REC_3, REC4 ,VAR_REC_4, REC5 , VAR_REC_5 from " + "QueueHistorytable a " + WFSUtil.getTableLockHintStr(dbType) +"  , ExtDBConfTable b " + WFSUtil.getTableLockHintStr(dbType) +"  , RecordMappingTable c " + WFSUtil.getTableLockHintStr(dbType) +"  where a.ProcessDefID " + "= b.ProcessDefID and c.ProcessDefID = a.ProcessDefID and ProcessInstanceId = ? ");
					WFSUtil.DB_SetString(1, processInst, pstmt, dbType);
					pstmt.execute();
					rs = pstmt.getResultSet();
					if (!rs.next()) {
						mainCode = WFSError.WM_NO_MORE_DATA;
						subCode = 0;
						subject = WFSErrorMsg.getMessage(mainCode);
						descr = WFSErrorMsg.getMessage(subCode);
						errType = WFSError.WF_TMP;
					}
				}
				if (mainCode == 0) {
					tempXml.append("<RecordMapping>\n");
					tempXml.append(gen.writeValueOf("MappedDatabaseName", rs.getString(1)));
					tempXml.append(gen.writeValueOf("MappedDatabaseType", rs.getString(2)));
					tempXml.append(gen.writeValueOf("MappedDatabaseTable", rs.getString(3)));
					tempXml.append(gen.writeValueOf("MappedObjectID", rs.getString(4)));
					tempXml.append(gen.writeValueOf("ColumnREC1", rs.getString(5)));
					tempXml.append(gen.writeValueOf("ValueREC1", rs.getString(6)));
					tempXml.append(gen.writeValueOf("ColumnREC2", rs.getString(7)));
					tempXml.append(gen.writeValueOf("ValueREC2", rs.getString(8)));
					tempXml.append(gen.writeValueOf("ColumnREC3", rs.getString(9)));
					tempXml.append(gen.writeValueOf("ValueREC3", rs.getString(10)));
					tempXml.append(gen.writeValueOf("ColumnREC4", rs.getString(11)));
					tempXml.append(gen.writeValueOf("ValueREC4", rs.getString(12)));
					tempXml.append(gen.writeValueOf("ColumnREC5", rs.getString(13)));
					tempXml.append(gen.writeValueOf("ValueREC5", rs.getString(14)));
					tempXml.append("</RecordMapping>\n");
				}
				if (rs != null) {
					rs.close();
				}
				pstmt.close();
			} else {
				mainCode = WFSError.WM_INVALID_SESSION_HANDLE;
				subCode = 0;
				subject = WFSErrorMsg.getMessage(mainCode);
				descr = WFSErrorMsg.getMessage(subCode);
				errType = WFSError.WF_TMP;
			}
			if (mainCode == 0) {
				outputXML = new StringBuffer(500);
				outputXML.append(gen.createOutputFile("WFGetRecordMappedFields"));
				outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
				outputXML.append(tempXml);
				outputXML.append(gen.closeOutputFile("WFGetRecordMappedFields"));
			}
		} catch (SQLException e) {
			WFSUtil.printErr(engine,"", e);
			mainCode = WFSError.WF_OPERATION_FAILED;
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
			try{
				if(rs!=null){
					rs.close();
					rs=null;
				}
			}catch(Exception e){
				WFSUtil.printErr(engine,"", e);
			}
			try {
				if (pstmt != null) {
					pstmt.close();
					pstmt = null;
				}
			} catch (Exception e) {
				WFSUtil.printErr(engine,"", e);
			}
			
		}
		if (mainCode != 0) {
			throw new WFSException(mainCode, subCode, errType, subject, descr);
		}
		return outputXML.toString();
	}

	//----------------------------------------------------------------------------------------------------
	//	Function Name 				:	WFGetResponseFile
	//	Date Written (DD/MM/YYYY)	:	16/05/2002
	//	Author						:	Prashant
	//	Input Parameters			:	Connection , XMLParser , XMLGenerator
	//	Output Parameters			:   none
	//	Return Values				:	String
	//	Description					:   Get ResponseFile for a Process
	//----------------------------------------------------------------------------------------------------
	public String WFGetResponseFile(Connection con, XMLParser parser, XMLGenerator gen) throws JTSException, WFSException {
	StringBuffer outputXML = null;
	PreparedStatement pstmt = null; 
	int mainCode = 0;
	int subCode = 0;
	String subject = null;
	String descr = null; 
	String errType = WFSError.WF_TMP;
	ResultSet rs = null;
	int dbType = 0;
	String engine ="";
	try {
		engine = parser.getValueOf("EngineName");
		dbType = ServerProperty.getReference().getDBType(engine);
		int sessionID = parser.getIntOf("SessionId", 0, false);
		String templatefile = parser.getValueOf("TemplateFileName", "", false);
		String cabinetName = parser.getValueOf("EngineName", "", false);
		int procdefid = parser.getIntOf("ProcessDefId", 0, false);
		String locale  =parser.getValueOf("Locale",null,true);
		WFParticipant user = WFSUtil.WFCheckSession(con, sessionID);
		StringBuffer tempXml = new StringBuffer(100);
		boolean bFound = false;
		StringBuffer strBuf = new StringBuffer(WFSConstant.WF_STRBUF);
		int len = 0;
//        boolean bEncodedData = false;
		strBuf.append("<FileBuffer>");
		if(templatefile != null && !templatefile.isEmpty() && templatefile.contains(".")){
			templatefile = templatefile.trim().substring(0, templatefile.lastIndexOf("."));
		}
		if (user != null) {
			/* WFS_5_161, MultiLingual Support (Inherited from 5.0), 05/06/2007 - Ruhi Hira */
			if(locale==null) {
				locale = user.getlocale();
			}
			String encodedBinaryData = null;
			String argListData = null;
            String format = null;
            String inputFormat = null;
            String tool = null;
            String dateFormat = null;
			if (dbType == JTSConstant.JTS_POSTGRES && con.getAutoCommit()) {
				con.setAutoCommit(false);
			}
			try {
				/* Join required as TemplateMultiLanguageTable does not contain TemplateName - Ruhi Hira */
				if ((locale != null && locale.trim().length() > 0)) {

				
					pstmt = con.prepareStatement(" Select TemplateMultiLanguageTable.TemplateBuffer, TemplateMultiLanguageTable.isEncrypted, ArgList, format, InputFormat, Tools, DateTimeFormat "
					+ " from TemplateMultiLanguageTable " + WFSUtil.getTableLockHintStr(dbType) +" , TemplateDefinitionTable " 
							+ WFSUtil.getTableLockHintStr(dbType) + " where TemplateMultiLanguageTable.TemplateId = TemplateDefinitionTable.TemplateId "
					+ " and TemplateMultiLanguageTable.ProcessDefId = TemplateDefinitionTable.ProcessDefId " 
							+ " and " 
							+ TO_STRING("TemplateFileName", false, dbType) + " = " + TO_STRING("?", false, dbType) 
							+ " and TemplateMultiLanguageTable.ProcessDefId = ? " + " and " 
							+ TO_STRING("Locale", false, dbType) + " = " + TO_STRING("?", false, dbType));
					WFSUtil.DB_SetString(1, templatefile.trim().toUpperCase(), pstmt, dbType);
					pstmt.setInt(2, procdefid);
					WFSUtil.DB_SetString(3, locale.trim().toUpperCase(), pstmt, dbType);
					pstmt.execute();
					rs = pstmt.getResultSet();
					len = 0;
					if (rs.next()) {
						Object[] res = WFSUtil.getBIGData(con, rs, "TemplateBuffer", dbType, null);
						strBuf.append((String) res[0]);
						len = ((Integer) res[1]).intValue();
						bFound = true;

						encodedBinaryData = rs.getString("isEncrypted"); //Bugzilla Bug 2817
						encodedBinaryData = (rs.wasNull() ? "N" : encodedBinaryData);
						argListData = rs.getString("ArgList");
                        format = rs.getString("format");
                        inputFormat = rs.getString("InputFormat");
                        tool = rs.getString("Tools");
                        dateFormat = rs.getString("DateTimeFormat");
						/** @todo Check for encoding.. At present process modeler encode buffer only when
						 * the locale of machine is not English. Process modeler should check for locale
						 * in TemplateMultiLanguageTable also. */
					}
				}
			} catch (SQLException e) {
				int ecode = e.getErrorCode();
				if (!(ecode == 208 || ecode == 942)) {
					WFSUtil.printErr(engine,"", e);
				}
			}
			if (!bFound) {
				// Tirupati Srivastava : changes made to make code compatible with postgreSQL
                /*pstmt = con.prepareStatement("Select TemplateBuffer from TemplateDefinitionTable where upper(rtrim(TemplateFileName)) = ? and ProcessDefId = ? ");*/
				pstmt = con.prepareStatement(" Select TemplateBuffer, isEncrypted, ArgList, format, InputFormat, Tools, DateTimeFormat  from TemplateDefinitionTable " + WFSUtil.getTableLockHintStr(dbType) +"  where " +
						TO_STRING("TemplateFileName", false, dbType) + " = " + TO_STRING("?", false, dbType) + " and ProcessDefId = ? ");
				WFSUtil.DB_SetString(1, templatefile.trim().toUpperCase(), pstmt, dbType);
				pstmt.setInt(2, procdefid);
				pstmt.execute();
				rs = pstmt.getResultSet();
				len = 0;
				if (rs.next()) {
					Object[] res = WFSUtil.getBIGData(con, rs, "TemplateBuffer", dbType, null);
					strBuf.append((String) res[0]);
					len = ((Integer) res[1]).intValue();

					encodedBinaryData = rs.getString("isEncrypted"); //Bugzilla Bug 2817
					encodedBinaryData = (rs.wasNull() ? "N" : encodedBinaryData);
					argListData = rs.getString("ArgList");
                    format = rs.getString("format");
                    inputFormat = rs.getString("InputFormat");
                    tool = rs.getString("Tools");
                    dateFormat = rs.getString("DateTimeFormat");
				}
			}
			strBuf.append("</FileBuffer>");
			tempXml.append(gen.writeValueOf("FileLength", String.valueOf(len)));
			tempXml.append(strBuf);
			// ------------- WSE_5.0.1_006 ----------------
			//----------------------------------------------------------------------------
			// Changed By                       : Ruhi Hira
			// Reason / Cause (Bug No if Any)   :
			// Change Description		    : EncodedBinaryData tag returned as required
			//				        by web client
			//----------------------------------------------------------------------------
			//if (! (com.newgen.omni.jts.srvr.DatabaseTransactionServer.charSet.equalsIgnoreCase("ISO8859_1")))
			//    tempXml.append("<EncodedBinaryData>Y</EncodedBinaryData>");
			tempXml.append(gen.writeValueOf("EncodedBinaryData", encodedBinaryData));
			tempXml.append(gen.writeValueOf("ArgList", argListData));
            tempXml.append(gen.writeValueOf("Format", format));
            tempXml.append(gen.writeValueOf("InputFormat", inputFormat));
            tempXml.append(gen.writeValueOf("Tool", tool));
            tempXml.append(gen.writeValueOf("DateFormat", dateFormat)); 
			if (rs != null) {
				rs.close();
			}
			pstmt.close();
		} else {
			mainCode = WFSError.WM_INVALID_SESSION_HANDLE;
			subCode = 0;
			subject = WFSErrorMsg.getMessage(mainCode);
			descr = WFSErrorMsg.getMessage(subCode);
			errType = WFSError.WF_TMP;
		}
		if (mainCode == 0) {
			outputXML = new StringBuffer(500);
			outputXML.append(gen.createOutputFile("WFGetResponseFile"));
			outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
			outputXML.append(tempXml);
			outputXML.append(gen.closeOutputFile("WFGetResponseFile"));
		}
	} catch (SQLException e) {
		WFSUtil.printErr(engine,"", e);
		mainCode = WFSError.WF_OPERATION_FAILED;
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
            if (dbType == JTSConstant.JTS_POSTGRES &&  !con.getAutoCommit()) {
                con.setAutoCommit(true);
            }
        } catch (SQLException sqle) {}		
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
		
	}
	
		if (mainCode != 0) {
			throw new WFSException(mainCode, subCode, errType, subject, descr);
		}
	
	return outputXML.toString();
}

	//----------------------------------------------------------------------------------------------------
	//	Function Name 						:	WFGetStateList
	//	Date Written (DD/MM/YYYY)			:	16/05/2002
	//	Author								:	Advid Parmar
	//	Input Parameters					:	Connection , XMLParser , XMLGenerator
	//	Output Parameters					:   none
	//	Return Values						:	String
	//	Description							:   Returns List of States defined
	//
	//----------------------------------------------------------------------------------------------------
	public String WFGetStateList(Connection con, XMLParser parser,
			XMLGenerator gen) throws JTSException, WFSException {
		StringBuffer outputXML = new StringBuffer("");
		PreparedStatement pstmt = null;
		ResultSet rs=null;
		int mainCode = 0;
		int subCode = 0;
		String subject = null;
		String descr = null;
		String errType = WFSError.WF_TMP;
		String engine ="";
		try {
			int sessionID = parser.getIntOf("SessionId", 0, false);
			//----------------------------------------------------------------------------
			// Changed By											: Prashant
			// Reason / Cause (Bug No if Any)	: Changes to support Search across Process Versions
			// Change Description							: ProcessDefinitionID is not Mandatory
			//																	ProcessName also parsed from Input XML
			//----------------------------------------------------------------------------
			int processdefid = parser.getIntOf("ProcessDefinitionID", 0, true);
			String processName = "";
			if (processdefid == 0) {
				processName = parser.getValueOf("ProcessName", "", true);
			}
			engine = parser.getValueOf("EngineName");
			int dbType = ServerProperty.getReference().getDBType(engine);
			int noOfRectoFetch = parser.getIntOf("NoOfRecordsToFetch",
					ServerProperty.getReference().getBatchSize(), true);
			char sortOrder = parser.getCharOf("SortOrder", 'A', true);
			int orderBy = parser.getIntOf("OrderBy", 1, true);
			String lastValue = parser.getValueOf("LastValue", "", true);
			int lastIndex = parser.getIntOf("LastIndex", 0, true);
			String lastValueStr = "";
			String orderBystr = "";
			String operator1 = "";
			String operator2 = "";
			String srtby = "";
			String orderbyStr = "";
			String exeStr = "";
			StringBuffer tempXml = new StringBuffer(100);

			WFParticipant user = WFSUtil.WFCheckSession(con, sessionID);
			if (noOfRectoFetch > ServerProperty.getReference().getBatchSize() || noOfRectoFetch <= 0) {
				noOfRectoFetch = ServerProperty.getReference().getBatchSize();
			}
			if (user != null) {
				switch (sortOrder) {
					case 'A':
						operator1 = ">";
						operator2 = ">=";
						srtby = " ASC";

						break;
					case 'D':
						operator1 = "<";
						operator2 = "<=";
						srtby = " DESC";
						break;
				}

				switch (orderBy) {
					case 1:
						orderbyStr = " Order by 1 " + srtby;
						if (lastIndex > 0) {
							lastValueStr = "and StateId" + operator1 + lastIndex;
						}
						break;
					case 2:
						orderbyStr = " Order by 2 " + srtby + ",1 " + srtby;
						if (lastIndex > 0 && !lastValue.equals("")) {
							lastValueStr = " and ( statename " + operator1 + TO_STRING(lastValue, true, dbType) + " or ( statename " + operator2 + TO_STRING(lastValue, true, dbType) + " and stateid " + operator1 + lastIndex + "))";
						}
						break;
				}

				if (processName.equals("")) {
					exeStr = "select  stateid,statename" + " from statesdeftable " + WFSUtil.getTableLockHintStr(dbType) +" where statesdeftable.processdefid= " + processdefid + lastValueStr + orderbyStr;
				} else {
					// Tirupati Srivastava : changes made to make code compatible with postgreSQL
                    /*exeStr = "select  DISTINCT stateid,statename" + " from statesdeftable"
					+ " where statesdeftable.processdefid "
					+ "	in ( Select processdefid from ProcessDefTable where upper(rtrim(ProcessName)) = upper(rtrim(" + WFSConstant.WF_VARCHARPREFIX
					+ processName + "'))) " + lastValueStr + orderbyStr;*/
					exeStr = "select  DISTINCT stateid,statename" + " from statesdeftable " + WFSUtil.getTableLockHintStr(dbType) +" where statesdeftable.processdefid " + "	in ( Select processdefid from ProcessDefTable " + WFSUtil.getTableLockHintStr(dbType) + " where " + TO_STRING("ProcessName", false, dbType) + "	= " + TO_STRING(TO_STRING(processName, true, dbType), false, dbType) + " ) " + lastValueStr + orderbyStr;
				}
				pstmt = con.prepareStatement(exeStr);
				pstmt.execute();
				rs = pstmt.getResultSet();
				int i = 0;
				int tot = 0;
				tempXml.append("\n<StateList>\n");
				while (rs.next()) {
					if (i < noOfRectoFetch) {
						tempXml.append("\n<StateInfo>\n");
						tempXml.append(gen.writeValueOf("ID", String.valueOf(rs.getInt(1))));
						tempXml.append(gen.writeValueOf("StateName", rs.getString(2)));
						tempXml.append("\n</StateInfo>\n");
						i++;
					}
					tot++;
				}
				if (i > 0) {
					tempXml.append("</StateList>\n");
					tempXml.append(gen.writeValueOf("TotalCount", String.valueOf(tot)));
					tempXml.append(gen.writeValueOf("RetrievedCount", String.valueOf(i)));
				} else {
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
			if (mainCode == 0) {
				outputXML = new StringBuffer(500);
				outputXML.append(gen.createOutputFile("WFGetStateList"));
				outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
				outputXML.append(tempXml);
				outputXML.append(gen.closeOutputFile("WFGetStateList"));
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
			try{
				if(rs!=null){
					rs.close();
					rs=null;
				}
			}catch(Exception e){
				WFSUtil.printErr(engine,"", e);
			}
			try {
				if (pstmt != null) {
					pstmt.close();
					pstmt = null;
				}
			} catch (Exception e) {
				WFSUtil.printErr(engine,"", e);
			}
			
		}
		if (mainCode != 0) {
			throw new WFSException(mainCode, subCode, errType, subject, descr);
		}
		return outputXML.toString();
	}

	//----------------------------------------------------------------------------------------------------
	//	Function Name 				:	WFGetProcessVariables
	//	Date Written (DD/MM/YYYY)	:	16/05/2002
	//	Author						:	Prashant
	//	Input Parameters			:	Connection , XMLParser , XMLGenerator
	//	Output Parameters			:   none
	//	Return Values				:	String
	//	Description					:   Fetches the list of Variables defined for a Process
	//									and associated with a given Activity.
	//----------------------------------------------------------------------------------------------------
	public String WFGetProcessVariables(Connection con, XMLParser parser,
			XMLGenerator gen) throws JTSException, WFSException {
		StringBuffer outputXML = new StringBuffer("");
		PreparedStatement pstmt = null;
		int mainCode = 0;
		int subCode = 0;
		String subject = null;
		String descr = null;
		String errType = WFSError.WF_TMP;
		String engine="";
		String userLocale = null;
		ResultSet rs =null;
		boolean isSortable=false;
		try {
			int sessionID = 0;
                        String locale = "en_US";
                        String scope = "";
                        boolean isAdmin = false;
                        String rightsFlag = "";
			//----------------------------------------------------------------------------
			// Changed By											: Prashant
			// Reason / Cause (Bug No if Any)	: Changes to support Search across Process Versions
			// Change Description							: ProcessDefinitionID is not Mandatory
			//																	ProcessName also parsed from Input XML
			//----------------------------------------------------------------------------
			int procDefId = parser.getIntOf("ProcessDefinitionId", 0, true);
			String enableMultiLingual = parser.getValueOf("EnableMultiLingual", "N", true);
			boolean pmMode = parser.getValueOf("OpenMode", "WD", true).equalsIgnoreCase("PM");
			if(pmMode){
				enableMultiLingual="N";
			}
			userLocale = parser.getValueOf("Locale", "", true);
			String processName = "";
			if (procDefId == 0) {
				processName = parser.getValueOf("ProcessName", "", false);
			}
			int activityId = parser.getIntOf("ActivityId", 0, true);
			int activityType = parser.getIntOf("ActivityType", 0, true);
			engine=parser.getValueOf("EngineName");
			int dbType = ServerProperty.getReference().getDBType(parser.getValueOf("EngineName"));
			boolean userDefVarFlag = parser.getValueOf("UserDefVarFlag", "N", true).equalsIgnoreCase("Y");
			char omniServiceFlag = parser.getCharOf("OmniService", 'N', true);
                        char FetchSearchCompatibleVariables  = parser.getCharOf("FetchSearchCompatibleVariables", 'N', true);
			StringBuffer queryBuff = new StringBuffer(250);
			rightsFlag = parser.getValueOf("RightFlag", "000000", true);
			

			StringBuffer tempXml = new StringBuffer(100);
			WFParticipant participant = null;
			if (omniServiceFlag == 'Y') {
				participant = new WFParticipant(0, "System", 'P', "SERVER", Locale.getDefault().toString());
			} else {
				sessionID = parser.getIntOf("SessionId", 0, false);
				participant = WFSUtil.WFCheckSession(con, sessionID);
			}

			//Added by Ashish for error Invalid Attribute..
			if (procDefId == 0) {
				// Tirupati Srivastava : changes made to make code compatible with postgreSQL
				pstmt = con.prepareStatement("Select max(ProcessDefID) from ProcessDefTable " + WFSUtil.getTableLockHintStr(dbType) + " where " + TO_STRING("ProcessName", false, dbType) + " = " + TO_STRING(TO_STRING(processName, true, dbType), false, dbType));
				pstmt.execute();
				rs = pstmt.getResultSet();
				if (rs.next()) {
					procDefId = rs.getInt(1);
				}
				pstmt.close();
			}

			if ((participant != null) || (omniServiceFlag == 'Y')) {
                             scope = participant.getscope();
                             if(rightsFlag.startsWith("0101")){
                                 isAdmin = true;//Scope is ADMIN
                             }else if(scope.equalsIgnoreCase("ADMIN")){
                                 isAdmin = true;//Scope is ADMIN
                             }
                             if(!scope.equalsIgnoreCase("ADMIN")){
                                   locale = participant.getlocale();
                                   }
//                int userID = participant.getid();
//                char pType = participant.gettype();
//                String username = participant.getname();
//                String queryStr = "";

				String usrdfnmfltr = null;
				usrdfnmfltr = WFSUtil.DB_LEN("UserDefinedName", dbType) + " > 0 ";

				// WFS_6.2_013
				String searchScope = parser.getValueOf("SearchScope", "", true);
				if (!searchScope.equals("")) {
					isSortable=true;
					StringTokenizer st = new StringTokenizer(searchScope, ",");
					searchScope = "";
					ArrayList<String> searchScopeList=new ArrayList<String>();
					StringBuffer searchScopeArg = new StringBuffer();
					searchScopeArg.append("?");
					searchScopeList.add(st.nextToken().trim());
					while (st.countTokens() > 0) {
						searchScopeList.add(st.nextToken().trim());
						searchScopeArg.append(",?");
						//searchScope = searchScope + ", " + TO_STRING(st.nextToken().trim(),true,dbType);
					}
					int userID = participant.getid();
					int searchActivityID = WFSUtil.getSearchActivityForUser(con, procDefId, userID, dbType,isAdmin);
					//pstmt = con.prepareStatement(" Select FieldName as AttributeName , VariableScope , Scope  , VariableType as Type , 1024 as Length from WFSearchVariableTable left outer join VarMappingTable on " + TO_STRING("WFSearchVariableTable.FieldName", false, dbType) + " = " + TO_STRING("VarMappingTable.UserDefinedName", false, dbType) + " where WFSearchVariableTable.ProcessDefID = ? and WFSearchVariableTable.activityID = ? and Scope in ( " + searchScope + " ) and (VarMappingTable.ProcessDefID is null or VarMappingTable.ProcessDefID = WFSearchVariableTable.ProcessDefID) order by Scope asc, OrderId asc ");
					if((locale == null) || (locale != null && locale.equalsIgnoreCase("en-us")) || !enableMultiLingual.equalsIgnoreCase("Y"))
                                        {
                                            queryBuff.append("Select FieldName as AttributeName, VariableScope, Scope, VariableType as Type, 1024 as Length, unbounded, SystemDefinedName, VarPrecision,WFSearchVariableTable.VariableId from WFSearchVariableTable ");	//Bugzilla Bug 6936
                                            queryBuff.append(WFSUtil.getTableLockHintStr(dbType));
                                            queryBuff.append(" LEFT OUTER JOIN VarMappingTable " + WFSUtil.getTableLockHintStr(dbType) +" ON  ");
                                            queryBuff.append("WFSearchVariableTable.VariableId");
                                            queryBuff.append(" = ");
                                            queryBuff.append("VarMappingTable.VariableId");
                                            queryBuff.append(" and VarMappingTable.ProcessDefID = WFSearchVariableTable.ProcessDefID");
                                            queryBuff.append(" where WFSearchVariableTable.ProcessDefID = ? and WFSearchVariableTable.activityID = ? and Scope in (");
                                            queryBuff.append(searchScopeArg);
                                            //queryBuff.append(") and VarMappingTable.variableType != ");
                                            queryBuff.append(") ");
                                           // queryBuff.append(WFSConstant.WF_COMPLEX);
                                            //queryBuff.append(" and VarMappingTable.unbounded = 'N' order by Scope asc, OrderId asc ");
                                            queryBuff.append(" order by OrderId asc ");
                                            pstmt = con.prepareStatement(queryBuff.toString());
                                            pstmt.setInt(1, procDefId);
                                            pstmt.setInt(2, searchActivityID);
                                            int count=3;
                                            for (int i=0;i<searchScopeList.size();i++) {
                                            pstmt.setString(count++, searchScopeList.get(i));
                                            }
                                            WFSUtil.printOut("***************************WFGetProcessVariable query :"+queryBuff);
                                            WFSUtil.printOut("Parameters: Processdefid - "+procDefId);
                                            WFSUtil.printOut("searchActivityID - "+searchActivityID);
                                            WFSUtil.printOut("search scope - "+searchScopeList); 
                                            
                                       }
                                       else
                                       {
                                            queryBuff.append(" Select A.*, EntityName from (");
                                            queryBuff.append("Select FieldName as AttributeName, VariableScope, Scope, VariableType as Type, 1024 as Length, unbounded, SystemDefinedName, VarPrecision, WFSearchVariableTable.VariableId, OrderId from WFSearchVariableTable ");	//Bugzilla Bug 6936
                                            queryBuff.append(WFSUtil.getTableLockHintStr(dbType));
                                            queryBuff.append(" LEFT OUTER JOIN VarMappingTable "+ WFSUtil.getTableLockHintStr(dbType) +  " ON  ");
                                            queryBuff.append(" WFSearchVariableTable.VariableId ");
                                            queryBuff.append(" = ");
                                            queryBuff.append(" VarMappingTable.VariableId ");
                                            queryBuff.append(" and VarMappingTable.ProcessDefID = WFSearchVariableTable.ProcessDefID ");
                                            queryBuff.append(" where WFSearchVariableTable.ProcessDefID = ? and WFSearchVariableTable.activityID = ? and Scope in (");
                                            queryBuff.append(searchScopeArg);
                                            //queryBuff.append(") and VarMappingTable.variableType != ");
                                            queryBuff.append(") ");
                                            //queryBuff.append(WFSConstant.WF_COMPLEX);
                                            //queryBuff.append(" and VarMappingTable.unbounded = 'N') A LEFT OUTER JOIN WFMultiLingualTable B on A.VariableId = B.EntityId and B.ProcessDefId = ? and EntityType = 4 and Locale = ?");
                                            queryBuff.append(" ) A LEFT OUTER JOIN WFMultiLingualTable B on A.VariableId = B.EntityId and B.ProcessDefId = ? and EntityType = 4 and Locale = ?");
                                            queryBuff.append(" order by OrderId asc ");

                                            pstmt = con.prepareStatement(queryBuff.toString());
                                            pstmt.setInt(1, procDefId);
                                            pstmt.setInt(2, searchActivityID);
                                            int count=3;
                                            for (int i=0;i<searchScopeList.size();i++) {
                                                pstmt.setString(count++, searchScopeList.get(i));
                                            }
                                            pstmt.setInt(count++, procDefId);
                                            WFSUtil.DB_SetString(count++, locale, pstmt, dbType);

                                            WFSUtil.printOut("***************************WFGetProcessVariable query :"+queryBuff);
                                            WFSUtil.printOut("Parameters: Processdefid - "+procDefId);
                                            WFSUtil.printOut("searchActivityID - "+searchActivityID);
                                            WFSUtil.printOut("search scope - "+searchScopeList); 
                                            WFSUtil.printOut("	locale  - "+locale); 
                                             
                                       }	
                                        
				} else // --------------------------------------------------------------------------------------
				// Changed On  : 22/03/2005
				// Changed By  : Ruhi Hira
				// Description : SrNo-2, Omniflow 6.0, Feature : MultipleIntroduction, Constraint added,
				//				ActivityType if provided is Introduction only.
				// --------------------------------------------------------------------------------------
				if (activityId == 0 && activityType != 0 && activityType != WFSConstant.ACT_INTRODUCTION) {
					mainCode = WFSError.WF_OPERATION_FAILED;
					subCode = WFSError.WFS_ILP;
					subject = WFSErrorMsg.getMessage(mainCode, userLocale);
					descr = WFSErrorMsg.getMessage(subCode, userLocale);
					errType = WFSError.WF_TMP;
				} // Add as length after 1024 - Ruhi - August 4th
				else if (activityId == 0 && activityType == 0 && procDefId != 0) {
                                    if((locale == null) || (locale != null && locale.equalsIgnoreCase("en-us")) || !enableMultiLingual.equalsIgnoreCase("Y"))
                                    {
                                        pstmt = con.prepareStatement(" Select UserDefinedName , VariableScope , 'R' , VariableType , VariableLength, unbounded, SystemDefinedName, VarPrecision from VarMappingTable where ProcessDefID =   ?  and " + usrdfnmfltr);
                                        pstmt.setInt(1, procDefId);
                                    }
                                    else
                                    {
                                        pstmt = con.prepareStatement(" Select UserDefinedName , VariableScope , 'R' , VariableType , VariableLength, unbounded, SystemDefinedName, VarPrecision, A.ProcessDefId, EntityName from VarMappingTable LEFT OUTER JOIN WFMultiLingualTable B on A.VariableId = B.EntityId and A.ProcessDefID = B.ProcessDefId and EntityType = 4 and Locale = ? where A.ProcessDefID =   ?  and " + usrdfnmfltr);
                                        WFSUtil.DB_SetString(1, locale, pstmt, dbType);
                                        pstmt.setInt(2, procDefId);
                                    }	
//					pstmt = con.prepareStatement(" Select UserDefinedName , VariableScope , 'R' , VariableType , VariableLength, unbounded, SystemDefinedName, VarPrecision from VarMappingTable " + WFSUtil.getTableLockHintStr(dbType) +"  where ProcessDefID =   ?  and " + usrdfnmfltr);
//					pstmt.setInt(1, procDefId);
				} else if (activityId == 0 && activityType == 0 && !processName.equals("")) {
					/** Changed By : Mandeep Kaur
					 * Changed On : 8th August 2005
					 * Description: SRNo-5,Length of external table variable is changed from 255 to 1024. */
					// Tirupati Srivastava : changes made to make code compatible with postgreSQL
                                    if((locale == null) || (locale != null && locale.equalsIgnoreCase("en-us")) || !enableMultiLingual.equalsIgnoreCase("Y"))
                                    {
					queryBuff.append("Select VarMappingTable.UserDefinedName, VariableScope, 'R',");
					queryBuff.append("VariableType, VariableLength, VarMappingTable.unbounded, VarMappingTable.SystemDefinedName, VarPrecision from VarMappingTable " + WFSUtil.getTableLockHintStr(dbType) + " , (Select UserDefinedName as VarName, ");
					queryBuff.append("max(ProcessDefID) as ProcDef from VarMappingTable " + WFSUtil.getTableLockHintStr(dbType) + " where ProcessDefID in ");
					queryBuff.append("(Select ProcessDefID from ProcessDefTable " + WFSUtil.getTableLockHintStr(dbType) + " where " + TO_STRING("ProcessName", false, dbType));
					queryBuff.append(" = " + TO_STRING(TO_STRING(processName, true, dbType), false, dbType) + " ) ");
					queryBuff.append(" group by UserDefinedName ) a where  UserDefinedName = VarName and ProcessDefID = ProcDef ");
					queryBuff.append(" and " + usrdfnmfltr);
					if (!userDefVarFlag) {
						queryBuff.append(" and VarMappingTable.variableType != 11 and VarMappingTable.unbounded = 'N' ");
					}
					pstmt = con.prepareStatement(queryBuff.toString());
                                    }
                                    else
                                    {
                                        queryBuff.append("Select A.*, EntityName from (");
                                        queryBuff.append("Select VarMappingTable.UserDefinedName, VariableScope, 'R' as Rights,");
                                        queryBuff.append("VariableType, VariableLength, VarMappingTable.unbounded, VarMappingTable.SystemDefinedName, VarPrecision, ProcessDefId, VariableId from VarMappingTable " + WFSUtil.getTableLockHintStr(dbType) + " , (Select UserDefinedName as VarName, ");
                                        queryBuff.append("max(ProcessDefID) as ProcDef from VarMappingTable " + WFSUtil.getTableLockHintStr(dbType) + " where ProcessDefID in ");
                                        queryBuff.append("(Select ProcessDefID from ProcessDefTable " + WFSUtil.getTableLockHintStr(dbType) + " where " + TO_STRING("ProcessName", false, dbType));
                                        queryBuff.append(" = " + TO_STRING(TO_STRING(processName, true, dbType), false, dbType) + " ) ");
                                        queryBuff.append(" group by UserDefinedName ) a where  UserDefinedName = VarName and ProcessDefID = ProcDef ");
                                        queryBuff.append(" and " + usrdfnmfltr);
                                        if (!userDefVarFlag) {
                                                queryBuff.append(" and VarMappingTable.variableType != 11 and VarMappingTable.unbounded = 'N' ");
                                        }
                                        queryBuff.append(") A LEFT OUTER JOIN WFMultiLingualTable B on A.VariableId = B.EntityId and A.ProcessDefID = B.ProcessDefId and EntityType = 4 and Locale = ?");

                                        pstmt = con.prepareStatement(queryBuff.toString());
                                        WFSUtil.DB_SetString(1, locale, pstmt, dbType);
                                    }
//                    WFSUtil.DB_SetString(1, processName, pstmt, dbType); // Bugzilla Id 47.
				} else if (activityId != 0 && procDefId != 0) {
                                    queryBuff = new StringBuffer(250);
					// --------------------------------------------------------------------------------------
					// Changed On  : 22/03/2005
					// Changed By  : Ruhi Hira
					// Description : SrNo-2, Omniflow 6.0, Feature : MultipleIntroduction, Condition added,
					//				return variable corresponding to default introduction only.
					// --------------------------------------------------------------------------------------
                                    if((locale == null) || (locale != null && locale.equalsIgnoreCase("en-us")) || !enableMultiLingual.equalsIgnoreCase("Y"))
                                    {    
					queryBuff.append("Select DISTINCT UserDefinedName as AttributeName, VariableScope, Attribute, VariableType as Type, VariableLength, VarMappingTable.unbounded, VarMappingTable.SystemDefinedName, VarPrecision from VarMappingTable " + WFSUtil.getTableLockHintStr(dbType) +"  , ActivityAssociationTable " + WFSUtil.getTableLockHintStr(dbType) +"  where ActivityAssociationTable.ProcessDefID = VarMappingTable.ProcessDefID and ActivityAssociationTable.ActivityId = ? and  ");
					queryBuff.append(TO_STRING("ActivityAssociationTable.FieldName", false, dbType));
					queryBuff.append(" = ");
					queryBuff.append(TO_STRING("VarMappingTable.UserDefinedName", false, dbType));
					queryBuff.append(" and DefinitionType in ( 'I', 'Q', 'U', 'M' ) and Attribute in ( 'O', 'B', 'R', 'M' ) and VarMappingTable.ProcessDefID = ? ");
					if (!userDefVarFlag) {
						queryBuff.append(" and VarMappingTable.variableType != 11 and VarMappingTable.unbounded = 'N' ");
					}
					pstmt = con.prepareStatement(queryBuff.toString());
					pstmt.setInt(1, activityId);
					pstmt.setInt(2, procDefId);
                                    }
                                    else
                                    {
                                        queryBuff.append("Select A.*, EntityName from (");
                                        queryBuff.append("Select DISTINCT UserDefinedName as AttributeName, VariableScope, Attribute, VariableType as Type, VariableLength, VarMappingTable.unbounded, VarMappingTable.SystemDefinedName, VarPrecision, VarMappingTable.ProcessDefId, VarMappingTable.VariableId from VarMappingTable , ActivityAssociationTable where ActivityAssociationTable.ProcessDefID = VarMappingTable.ProcessDefID and ActivityAssociationTable.ActivityId = ? and  ");
                                        queryBuff.append(TO_STRING("ActivityAssociationTable.FieldName", false, dbType));
                                        queryBuff.append(" = ");
                                        queryBuff.append(TO_STRING("VarMappingTable.UserDefinedName", false, dbType));
                                        queryBuff.append(" and DefinitionType in ( 'I', 'Q', 'U', 'M' ) and Attribute in ( 'O', 'B', 'R', 'M' ) and VarMappingTable.ProcessDefID = ? ");
                                        if (!userDefVarFlag) {
                                            queryBuff.append(" and VarMappingTable.variableType != 11 and VarMappingTable.unbounded = 'N' ");
                                        }
                                        queryBuff.append(") A LEFT OUTER JOIN WFMultiLingualTable B on A.VariableId = B.EntityId and A.ProcessDefID = B.ProcessDefId and EntityType = 4 and Locale = ?");
                                        pstmt = con.prepareStatement(queryBuff.toString());
                                        pstmt.setInt(1, activityId);
                                        pstmt.setInt(2, procDefId);
                                        WFSUtil.DB_SetString(3, locale, pstmt, dbType);
                                    }	
				} else if (procDefId != 0) {
					// --------------------------------------------------------------------------------------
					// Changed On  : 22/03/2005
					// Changed By  : Ruhi Hira
					// Description : SrNo-2, Omniflow 6.0, Feature : MultipleIntroduction, Condition added,
					//				return variable corresponding to default introduction only.
					// --------------------------------------------------------------------------------------
					queryBuff = new StringBuffer(250);
                                        if((locale == null) || (locale != null && locale.equalsIgnoreCase("en-us")) || !enableMultiLingual.equalsIgnoreCase("Y"))
                                        {    
                                            queryBuff.append("Select DISTINCT UserDefinedName as AttributeName, VariableScope, Attribute, VariableType as Type, VariableLength, VarMappingTable.unbounded, VarMappingTable.SystemDefinedName, VarPrecision from VarMappingTable " + WFSUtil.getTableLockHintStr(dbType) +" , ActivityAssociationTable " + WFSUtil.getTableLockHintStr(dbType) +" , ActivityTable " + WFSUtil.getTableLockHintStr(dbType) +"  where ActivityAssociationTable.ProcessDefID = VarMappingTable.ProcessDefID and ActivityAssociationTable.ProcessDefID = ActivityTable.ProcessDefID and ActivityAssociationTable.ActivityId = ActivityTable.ActivityId and ");
                                            queryBuff.append(TO_STRING("ActivityTable.primaryActivity", false, dbType));
                                            queryBuff.append(" = ");
                                            queryBuff.append(TO_STRING("Y", true, dbType));
                                            queryBuff.append(" and ActivityTable.ActivityType = ? and ");
                                            queryBuff.append(TO_STRING("ActivityAssociationTable.FieldName", false, dbType));
                                            queryBuff.append(" = ");
                                            queryBuff.append(TO_STRING("VarMappingTable.UserDefinedName", false, dbType));
                                            queryBuff.append(" and DefinitionType in ( 'I', 'Q', 'U', 'M' ) and Attribute in ( 'O', 'B', 'R', 'M' ) and VarMappingTable.ProcessDefID =   ?  ");
                                            if (!userDefVarFlag) {
                                                    queryBuff.append(" and VarMappingTable.variableType != 11 and VarMappingTable.unbounded = 'N'");
                                            }
                                            pstmt = con.prepareStatement(queryBuff.toString());
                                            pstmt.setInt(1, activityType);
                                            pstmt.setInt(2, procDefId);
                                        }
                                        else
                                        {
                                            queryBuff.append("Select A.*, EntityName from (");
                                            queryBuff.append("Select DISTINCT UserDefinedName as AttributeName, VariableScope, Attribute, VariableType as Type, VariableLength, VarMappingTable.unbounded, VarMappingTable.SystemDefinedName, VarPrecision, VarMappingTable.ProcessDefId, VarMappingTable.VariableId from VarMappingTable, ActivityAssociationTable, ActivityTable where ActivityAssociationTable.ProcessDefID = VarMappingTable.ProcessDefID and ActivityAssociationTable.ProcessDefID = ActivityTable.ProcessDefID and ActivityAssociationTable.ActivityId = ActivityTable.ActivityId and ");
                                            queryBuff.append(TO_STRING("ActivityTable.primaryActivity", false, dbType));
                                            queryBuff.append(" = ");
                                            queryBuff.append(TO_STRING("Y", true, dbType));
                                            queryBuff.append(" and ActivityTable.ActivityType = ? and ");
                                            queryBuff.append(TO_STRING("ActivityAssociationTable.FieldName", false, dbType));
                                            queryBuff.append(" = ");
                                            queryBuff.append(TO_STRING("VarMappingTable.UserDefinedName", false, dbType));
                                            queryBuff.append(" and DefinitionType in ( 'I', 'Q', 'U', 'M' ) and Attribute in ( 'O', 'B', 'R', 'M' ) and VarMappingTable.ProcessDefID =   ?  ");
                                            if (!userDefVarFlag) {
                                                queryBuff.append(" and VarMappingTable.variableType != 11 and VarMappingTable.unbounded = 'N'");
                                            }
                                            queryBuff.append(") A LEFT OUTER JOIN WFMultiLingualTable B on A.VariableId = B.EntityId and A.ProcessDefID = B.ProcessDefId and EntityType = 4 and Locale = ?");

                                            pstmt = con.prepareStatement(queryBuff.toString());
                                            pstmt.setInt(1, activityType);
                                            pstmt.setInt(2, procDefId);
                                            WFSUtil.DB_SetString(3, locale, pstmt, dbType);
                                        }
				} else if (!processName.equals("")) {
					queryBuff = new StringBuffer(250);
                                        if((locale == null) || (locale != null && locale.equalsIgnoreCase("en-us")) || !enableMultiLingual.equalsIgnoreCase("Y"))
                                        {
                                            queryBuff.append(" Select DISTINCT UserDefinedName as AttributeName, VariableScope, ");
                                            queryBuff.append(" Attribute, VariableType as Type, VariableLength, VarMappingTable.unbounded, VarMappingTable.SystemDefinedName, VarPrecision from VarMappingTable, ");
                                            queryBuff.append(" ActivityAssociationTable, ActivityTable, (Select UserDefinedName as VarName, max(ProcessDefID) ");
                                            queryBuff.append(" as ProcDef from VarMappingTable where ProcessDefID in (Select ProcessDefID from ProcessDefTable " + WFSUtil.getTableLockHintStr(dbType));
                                            queryBuff.append(" where ");
                                            queryBuff.append(TO_STRING("ProcessName", false, dbType));
                                            queryBuff.append(" = ");
                                            queryBuff.append(TO_STRING(TO_STRING(processName, true, dbType), false, dbType));
                                            queryBuff.append(" ) group by UserDefinedName ) a ");
                                            queryBuff.append(" where ");
                                            queryBuff.append(TO_STRING("UserDefinedName", false, dbType));
                                            queryBuff.append(" = ");
                                            queryBuff.append(TO_STRING("VarName", false, dbType));
                                            queryBuff.append(" and VarMappingTable.ProcessDefID = ProcDef ");
                                            queryBuff.append(" and ActivityAssociationTable.ProcessDefID = VarMappingTable.ProcessDefID ");
                                            queryBuff.append(" and ActivityAssociationTable.ProcessDefID = ActivityTable.ProcessDefID ");
                                            queryBuff.append(" and ActivityAssociationTable.ActivityId = ActivityTable.ActivityId ");
                                            queryBuff.append(" and ");
                                            queryBuff.append(TO_STRING("ActivityTable.primaryActivity", false, dbType));
                                            queryBuff.append(" = ");
                                            queryBuff.append(TO_STRING("Y", true, dbType));
                                            queryBuff.append(" and ActivityTable.ActivityType = ? and ");
                                            queryBuff.append(TO_STRING("ActivityAssociationTable.FieldName", false, dbType));
                                            queryBuff.append(" = ");
                                            queryBuff.append(TO_STRING("VarMappingTable.UserDefinedName", false, dbType));
                                            queryBuff.append(" and DefinitionType in ( ");
                                            queryBuff.append(TO_STRING("I", true, dbType));
                                            queryBuff.append(" , ");
                                            queryBuff.append(TO_STRING("Q", true, dbType));
                                            queryBuff.append(" , ");
                                            queryBuff.append(TO_STRING("U", true, dbType));
                                            queryBuff.append(" , ");
                                            queryBuff.append(TO_STRING("M", true, dbType));
                                            queryBuff.append(" ) ");
                                            queryBuff.append(" and Attribute in ( ");
                                            queryBuff.append(TO_STRING("O", true, dbType));
                                            queryBuff.append(" , ");
                                            queryBuff.append(TO_STRING("B", true, dbType));
                                            queryBuff.append(" , ");
                                            queryBuff.append(TO_STRING("R", true, dbType));
                                            queryBuff.append(" , ");
                                            queryBuff.append(TO_STRING("M", true, dbType));
                                            queryBuff.append(" ) ");
                                            if (!userDefVarFlag) {
                                                    queryBuff.append(" and VarMappingTable.variableType != 11 and VarMappingTable.unbounded = 'N' ");
                                            }
                                            pstmt = con.prepareStatement(queryBuff.toString());
    //                    WFSUtil.DB_SetString(1, processName, pstmt, dbType); // Bugzilla Id 47.
                                            pstmt.setInt(1, activityType);
                                        }
                                        else
                                        {
                                            queryBuff.append("Select A.*, EntityName from (");
                                            queryBuff.append(" Select DISTINCT UserDefinedName as AttributeName, VariableScope, ");
                                            queryBuff.append(" Attribute, VariableType as Type, VariableLength, VarMappingTable.unbounded, VarMappingTable.SystemDefinedName, VarPrecision, VarMappingTable.ProcessDefId, VarMappingTable.VariableId from VarMappingTable, ");
                                            queryBuff.append(" ActivityAssociationTable, ActivityTable, (Select UserDefinedName as VarName, max(ProcessDefID) ");
                                            queryBuff.append(" as ProcDef from VarMappingTable where ProcessDefID in (Select ProcessDefID from ProcessDefTable " + WFSUtil.getTableLockHintStr(dbType));
                                            queryBuff.append(" where ");
                                            queryBuff.append(TO_STRING("ProcessName", false, dbType));
                                            queryBuff.append(" = ");
                                            queryBuff.append(TO_STRING(TO_STRING(processName, true, dbType), false, dbType));
                                            queryBuff.append(" ) group by UserDefinedName ) a ");
                                            queryBuff.append(" where ");
                                            queryBuff.append(TO_STRING("UserDefinedName", false, dbType));
                                            queryBuff.append(" = ");
                                            queryBuff.append(TO_STRING("VarName", false, dbType));
                                            queryBuff.append(" and VarMappingTable.ProcessDefID = ProcDef ");
                                            queryBuff.append(" and ActivityAssociationTable.ProcessDefID = VarMappingTable.ProcessDefID ");
                                            queryBuff.append(" and ActivityAssociationTable.ProcessDefID = ActivityTable.ProcessDefID ");
                                            queryBuff.append(" and ActivityAssociationTable.ActivityId = ActivityTable.ActivityId ");
                                            queryBuff.append(" and ");
                                            queryBuff.append(TO_STRING("ActivityTable.primaryActivity", false, dbType));
                                            queryBuff.append(" = ");
                                            queryBuff.append(TO_STRING("Y", true, dbType));
                                            queryBuff.append(" and ActivityTable.ActivityType = ? and ");
                                            queryBuff.append(TO_STRING("ActivityAssociationTable.FieldName", false, dbType));
                                            queryBuff.append(" = ");
                                            queryBuff.append(TO_STRING("VarMappingTable.UserDefinedName", false, dbType));
                                            queryBuff.append(" and DefinitionType in ( ");
                                            queryBuff.append(TO_STRING("I", true, dbType));
                                            queryBuff.append(" , ");
                                            queryBuff.append(TO_STRING("Q", true, dbType));
                                            queryBuff.append(" , ");
                                            queryBuff.append(TO_STRING("U", true, dbType));
                                            queryBuff.append(" , ");
                                            queryBuff.append(TO_STRING("M", true, dbType));
                                            queryBuff.append(" ) ");
                                            queryBuff.append(" and Attribute in ( ");
                                            queryBuff.append(TO_STRING("O", true, dbType));
                                            queryBuff.append(" , ");
                                            queryBuff.append(TO_STRING("B", true, dbType));
                                            queryBuff.append(" , ");
                                            queryBuff.append(TO_STRING("R", true, dbType));
                                            queryBuff.append(" , ");
                                            queryBuff.append(TO_STRING("M", true, dbType));
                                            queryBuff.append(" ) ");
                                            if (!userDefVarFlag) {
                                                    queryBuff.append(" and VarMappingTable.variableType != 11 and VarMappingTable.unbounded = 'N' ");
                                            }
                                            queryBuff.append(") A LEFT OUTER JOIN WFMultiLingualTable B on A.VariableId = B.EntityId and A.ProcessDefID = B.ProcessDefId and EntityType = 4 and Locale = ?");
                                            pstmt = con.prepareStatement(queryBuff.toString());
                    //                      WFSUtil.DB_SetString(1, processName, pstmt, dbType); // Bugzilla Id 47.
                                            pstmt.setInt(1, activityType);
                                            WFSUtil.DB_SetString(2, locale, pstmt, dbType);
                                        }
				}
				// --------------------------------------------------------------------------------------
				// Changed On  : 22/03/2005
				// Changed By  : Ruhi Hira
				// Description : SrNo-2, Omniflow 6.0, Feature : MultipleIntroduction,
				//				Move ahead only when valid data.
				// --------------------------------------------------------------------------------------
				if (mainCode == 0) {
					pstmt.execute();

					rs = pstmt.getResultSet();
					int retrCount = 0;
					String tempStr = "";
                                        String entityName = "";
					tempXml.append("<Attributes>\n");
					while (rs.next()) {
                                            int tempType = rs.getInt(4);
                                            if (!((FetchSearchCompatibleVariables =='Y')
                                               &&( tempType ==18)))
                                            {
						tempXml.append("<Attribute>\n");
						tempXml.append(gen.writeValueOf("Name", rs.getString(1)));
						tempXml.append("<Type>");
						String tempScope = rs.getString(2);
						char k = rs.wasNull() ? '\0' : tempScope.toUpperCase().charAt(0);

						switch (k) {
							case 'C':
								tempXml.append("3");
								break;
							case 'S':
								tempXml.append("3");
								break;
							case 'M':
								tempXml.append("3");
								break;
							case 'I':
								tempXml.append("2");
								break;
							default:
								tempXml.append("1");
						}

						tempStr = rs.getString(3);
						k = rs.wasNull() ? '\0' : tempStr.toUpperCase().charAt(0);

						/* In case of search, value will be:
						C(Search Criteria Field), R(Search Result), F(Search Filter)
						 */
						switch (k) {
							case 'B':
								tempXml.append("3");
								break;
							case 'O':
								tempXml.append("3");
								break;
							case 'R':
								tempXml.append("1");
								break;
							case 'M':
								tempXml.append("2");
								break;
							case 'C':
								tempXml.append("4");
								break;
							case 'F':
								tempXml.append("5");
								break;
							default:
								tempXml.append("0");
						}
						//int tempType = rs.getInt(4);
						tempXml.append(tempType);
						tempXml.append("</Type>");
						String tempLength = rs.getString(5);
						if (tempType == WFSConstant.WF_FLT && rs.wasNull()) {
							tempLength = WFSConstant.CONST_FLOAT_LENGTH;
						}
						if (tempScope != null && !(tempScope.trim().equals("I"))) {
							if (tempLength == null) {
								tempXml.append(gen.writeValueOf("Length", "255"));
							} else {
								tempXml.append(gen.writeValueOf("Length", tempLength));
							}
						} else {
							if (tempLength == null) {
								tempXml.append(gen.writeValueOf("Length", "1024"));
							} else {
								tempXml.append(gen.writeValueOf("Length", tempLength));
							}
						}
						/** 10/06/2008, BPEL Compliant Omniflow - Initiation thru web services,
						 * userDefTypes returned from WFGetProcessVariables - Ruhi Hira */
						if (userDefVarFlag) {
							tempXml.append(gen.writeValueOf("Unbounded", rs.getString("unbounded")));
							tempXml.append(gen.writeValueOf("SystemDefinedName", rs.getString("SystemDefinedName")));
						}
						if (tempType == WFSConstant.WF_FLT) {
							String precision = rs.getString("VarPrecision");
							if (rs.wasNull()) {
								precision = WFSConstant.CONST_FLOAT_PRECISION + "";
							}
							tempXml.append(gen.writeValueOf("Precision", precision));
						}
                                                entityName = "";
                                                if(locale != null && !locale.equalsIgnoreCase("en-us") && enableMultiLingual.equalsIgnoreCase("Y"))
                                                {
                                                   entityName = rs.getString("EntityName");
                                                   if(rs.wasNull())
                                                       entityName = "";
                                                }
                                                tempXml.append(gen.writeValueOf("EntityName", entityName));
                         
                                                
						
						if(isSortable){
                        	String isSort="N";
                        	int variableID=rs.getInt("VariableId");
                        	int orderBy=variableID+100;
                        	if("R".equalsIgnoreCase(tempStr)&&variableID>=1&&variableID<=26){
                        		isSort="Y";
                        	}
                        	tempXml.append(gen.writeValueOf("SortAble", isSort));
                        	if("Y".equalsIgnoreCase(isSort))
                        		tempXml.append(gen.writeValueOf("OrderBy", Integer.toString(orderBy)));
                        }
						tempXml.append("\n</Attribute>\n");
						
						retrCount++;
                                        
					}
                                        }
					pstmt.close();
					tempXml.append("\n</Attributes>\n");
					tempXml.append(gen.writeValueOf("Count", String.valueOf(retrCount)));
					/** 10/06/2008, BPEL Compliant Omniflow - Initiation thru web services,
					 * userDefTypes returned from WFGetProcessVariables - Ruhi Hira */
					if (userDefVarFlag) {
						/** For now we are just supporting processDefId in this call... */
						queryBuff = new StringBuffer(200);
						queryBuff.append("SELECT TypeId, TypeName, ExtensionTypeId FROM WFTypeDescTable ");
						queryBuff.append(WFSUtil.getTableLockHintStr(dbType));
						queryBuff.append(" WHERE ProcessDefId = ? ORDER BY TypeId ");
						pstmt = con.prepareStatement(queryBuff.toString());
						pstmt.setInt(1, procDefId);
						pstmt.execute();
						rs = pstmt.getResultSet();
						tempXml.append("\n<UserDefTypeDescInfo>");
						while (rs.next()) {
							tempXml.append("\n<UserDefTypeDesc>\n");
							tempXml.append(gen.writeValueOf("TypeId", rs.getString("TypeId")));
							tempXml.append(gen.writeValueOf("TypeName", rs.getString("TypeName")));
							tempXml.append(gen.writeValueOf("ExtensionTypeId", rs.getString("ExtensionTypeId")));
							tempXml.append("\n</UserDefTypeDesc>");
						}
						tempXml.append("\n</UserDefTypeDescInfo>\n");
						if (rs != null) {
							rs.close();
							rs = null;
						}
						pstmt.close();
						pstmt = null;

						queryBuff = new StringBuffer(200);
						queryBuff.append("SELECT ParentTypeId, TypeFieldId, FieldName, WFType, TypeId, Unbounded, ExtensionTypeId FROM WFTypeDefTable ");
						queryBuff.append(WFSUtil.getTableLockHintStr(dbType));
						queryBuff.append(" WHERE ProcessDefId = ? ORDER BY ParentTypeId, TypeFieldId ");
						pstmt = con.prepareStatement(queryBuff.toString());
						pstmt.setInt(1, procDefId);
						pstmt.execute();
						rs = pstmt.getResultSet();
						tempXml.append("\n<UserDefinedTypeInfo>");
						while (rs.next()) {
							tempXml.append("\n<UserDefinedType>\n");
							tempXml.append(gen.writeValueOf("ParentTypeId", rs.getString("ParentTypeId")));
							tempXml.append(gen.writeValueOf("TypeFieldId", rs.getString("TypeFieldId")));
							tempXml.append(gen.writeValueOf("FieldName", rs.getString("FieldName")));
							tempXml.append(gen.writeValueOf("WFType", rs.getString("WFType")));
							tempXml.append(gen.writeValueOf("TypeId", rs.getString("TypeId")));
							tempXml.append(gen.writeValueOf("Unbounded", rs.getString("Unbounded")));
							tempXml.append(gen.writeValueOf("ExtensionTypeId", rs.getString("ExtensionTypeId")));
							tempXml.append("\n</UserDefinedType>");
						}
						tempXml.append("\n</UserDefinedTypeInfo>\n");
						if (rs != null) {
							rs.close();
							rs = null;
						}
						pstmt.close();
						pstmt = null;
					}
					if (retrCount == 0) {
						mainCode = WFSError.WM_NO_MORE_DATA;
						subCode = 0;
						subject = WFSErrorMsg.getMessage(mainCode, userLocale);
						descr = WFSErrorMsg.getMessage(subCode, userLocale);
						errType = WFSError.WF_TMP;
					}
				}
			} else {
				mainCode = WFSError.WM_INVALID_SESSION_HANDLE;
				subCode = 0;
				subject = WFSErrorMsg.getMessage(mainCode, userLocale);
				descr = WFSErrorMsg.getMessage(subCode, userLocale);
				errType = WFSError.WF_TMP;
			}
			if (mainCode == 0) {
				outputXML = new StringBuffer(500);
				outputXML.append(gen.createOutputFile("WFGetProcessVariables"));
				outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
				outputXML.append(tempXml);
				outputXML.append(gen.closeOutputFile("WFGetProcessVariables"));
			}
		} catch (SQLException e) {
			WFSUtil.printErr(engine,"", e);
			mainCode = WFSError.WM_INVALID_FILTER;
			subCode = WFSError.WFS_SQL;
			subject = WFSErrorMsg.getMessage(mainCode, userLocale);
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
			subject = WFSErrorMsg.getMessage(mainCode, userLocale);
			errType = WFSError.WF_TMP;
			descr = e.toString();
		} catch (NullPointerException e) {
			WFSUtil.printErr(engine,"", e);
			mainCode = WFSError.WF_OPERATION_FAILED;
			subCode = WFSError.WFS_SYS;
			subject = WFSErrorMsg.getMessage(mainCode, userLocale);
			errType = WFSError.WF_TMP;
			descr = e.toString();
		} catch (JTSException e) {
			WFSUtil.printErr(engine,"", e);
			mainCode = WFSError.WF_OPERATION_FAILED;
			subCode = e.getErrorCode();
			subject = WFSErrorMsg.getMessage(mainCode, userLocale);
			errType = WFSError.WF_TMP;
			descr = e.getMessage();
		} catch (Exception e) {
			WFSUtil.printErr(engine,"", e);
			mainCode = WFSError.WF_OPERATION_FAILED;
			subCode = WFSError.WFS_EXP;
			subject = WFSErrorMsg.getMessage(mainCode, userLocale);
			errType = WFSError.WF_TMP;
			descr = e.toString();
		} catch (Error e) {
			WFSUtil.printErr(engine,"", e);
			mainCode = WFSError.WF_OPERATION_FAILED;
			subCode = WFSError.WFS_EXP;
			subject = WFSErrorMsg.getMessage(mainCode, userLocale);
			errType = WFSError.WF_TMP;
			descr = e.toString();
		} finally {
			try{
				if(rs!=null){
					rs.close();
					rs=null;
				}
			}catch(Exception e){
				WFSUtil.printErr(engine,"", e);
			}
			try {
				if (pstmt != null) {
					pstmt.close();
					pstmt = null;
				}
			} catch (Exception e) {
				WFSUtil.printErr(engine,"", e);
			}
			
		}
		if (mainCode != 0) {
			throw new WFSException(mainCode, subCode, errType, subject, descr);
		}
		return outputXML.toString();
	}

	//----------------------------------------------------------------------------------------------------
	//	Function Name 				:	WFGetProcessData
	//	Date Written (DD/MM/YYYY)	:	16/05/2002
	//	Author						:	Prashant
	//	Input Parameters			:	Connection , XMLParser , XMLGenerator
	//	Output Parameters			:   none
	//	Return Values				:	String
	//	Description					:   Fetches the form Buffer for the reqired Activity .
	//----------------------------------------------------------------------------------------------------
	// --------------------------------------------------------------------------------------
	// Changed On  : 24/02/2005
	// Changed By  : Ruhi Hira
	// Description : SrNo-1, API not in use hence marked deprecated.
	// --------------------------------------------------------------------------------------
	/**
	 * @deprecated NOT USED ANYMORE
	 */
	public String WFGetProcessData(Connection con, XMLParser parser,
			XMLGenerator gen) throws JTSException, WFSException {
		StringBuffer outputXML = new StringBuffer("");
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int mainCode = 0;
		int subCode = 0;
		String subject = null;
		String descr = null;
		String errType = WFSError.WF_TMP;
		Object[] result = null;
		String engine = "";
		try {
			int sessionID = parser.getIntOf("SessionId", 0, false);
			int procDefId = parser.getIntOf("ProcessDefinitionId", 0, false);
			int activityId = parser.getIntOf("ActivityId", 0, true);
			int activityType = parser.getIntOf("ActivityType", 0, true);
			engine = parser.getValueOf("EngineName");
			int dbType = ServerProperty.getReference().getDBType(parser.getValueOf("EngineName"));
			String activityName = null;
			StringBuffer tempXml = new StringBuffer(100);
			WFParticipant participant = WFSUtil.WFCheckSession(con, sessionID);
			if (participant != null && participant.gettype() == 'U') {
				int userID = participant.getid();
				char pType = participant.gettype();
				String username = participant.getname();
				String queryStr = "";

				if (activityId == 0 && activityType == 0) {
					throw new WFSException(WFSError.WF_ELEMENT_MISSING, 0, WFSError.WF_TMP,
							WFSErrorMsg.getMessage(WFSError.WF_ELEMENT_MISSING),
							WFSErrorMsg.getMessage(WFSError.WF_ELEMENT_MISSING) + ": ActivityId OR ActivityType.");
				} else if (activityId == 0) {
					pstmt = con.prepareStatement(
							" Select ActivityID , ActivityName from ActivityTable " + WFSUtil.getTableLockHintStr(dbType) +"  where ActivityType = ? and ProcessDefID =  ? ");
					pstmt.setInt(1, activityType);
					pstmt.setInt(2, procDefId);
					pstmt.execute();
					rs = pstmt.getResultSet();
					if (rs.next()) {
						activityId = rs.getInt(1);
						activityName = rs.getString(2);
					}
					pstmt.close();
				}

				pstmt = con.prepareStatement("Select FormId , FormName,  DATALENGTH(FormBuffer) , FormBuffer from WFForm_Table " + WFSUtil.getTableLockHintStr(dbType) +"  , ActivityInterfaceAssocTable " + WFSUtil.getTableLockHintStr(dbType) +"  where ActivityInterfaceAssocTable.ProcessDefId = WFForm_Table.ProcessDefId and ActivityInterfaceAssocTable.ProcessDefId = ?  and ActivityID = ? and ActivityInterfaceAssocTable.InterfaceElementID = WFForm_Table.FormID and InterfaceType = " +
						WFSConstant.WF_VARCHARPREFIX + "F' ");

				pstmt.setInt(1, procDefId);
				pstmt.setInt(2, activityId);
				pstmt.execute();
				rs = pstmt.getResultSet();

				tempXml.append("<Data>\n");
				tempXml.append(gen.writeValueOf("ActivityName", activityName));
				tempXml.append("<Forms>\n");
				while (rs.next()) {
					tempXml.append("<Form>\n");
					tempXml.append(gen.writeValueOf("FormIndex", rs.getString(1)));
					tempXml.append(gen.writeValueOf("FormName", rs.getString(2)));
					tempXml.append(gen.writeValueOf("LengthFormBuffer", rs.getString(3)));
					java.io.InputStream fin = rs.getBinaryStream(4);

					byte[] text = null;
					StringBuffer formBuffer = new StringBuffer();
					for (;;) {
						text = new byte[512];
						int size = fin.read(text);
						if (size == -1) { // at end of stream
							break;
						}
						fin.close();
						formBuffer.append(new String(text, 0, size, DatabaseTransactionServer.charSet));
					}
					tempXml.append(gen.writeValueOf("FormBuffer", formBuffer.toString()));
					tempXml.append("</Form>\n");
				}
				tempXml.append("</Forms>\n");
				tempXml.append("<Data>\n");
				pstmt.close();

				String usrdfnmfltr = null;
				usrdfnmfltr = WFSUtil.DB_LEN("UserDefinedName", dbType) + " > 0 ";
				pstmt = con.prepareStatement(" Select UserDefinedName as AttributeName , VariableScope , Attribute , VariableType as Type ,1024 as Length from VarMappingTable " + WFSUtil.getTableLockHintStr(dbType) +" , ActivityAssociationTable " + WFSUtil.getTableLockHintStr(dbType) +"  where VarMappingTable.ProcessDefID = ActivityAssociationTable.ProcessDefID  and VarMappingTable.ProcessDefID =  ?  and ActivityID = ? and Attribute in (" + WFSConstant.WF_VARCHARPREFIX + "O'," +
						WFSConstant.WF_VARCHARPREFIX + "B'," + WFSConstant.WF_VARCHARPREFIX + "R'," +
						WFSConstant.WF_VARCHARPREFIX + "M') and DefinitionType In (" + WFSConstant.WF_VARCHARPREFIX + "I'," + WFSConstant.WF_VARCHARPREFIX + "Q'," + WFSConstant.WF_VARCHARPREFIX + "U') and  UserDefinedName = fieldName and " + usrdfnmfltr + " UNION Select UserDefinedName as AttributeName , VariableScope , case when VariableScope = " + WFSConstant.WF_VARCHARPREFIX + "M'  then " + WFSConstant.WF_VARCHARPREFIX + "M' else " + WFSConstant.WF_VARCHARPREFIX + "R' end , VariableType as Type ,1024 as Length from VarMappingTable " + WFSUtil.getTableLockHintStr(dbType) +"  where  VariableScope IN ( " +
						WFSConstant.WF_VARCHARPREFIX + "S' , " + WFSConstant.WF_VARCHARPREFIX + "M' ) and VarMappingTable.ProcessDefID =  ? ");

				pstmt.setInt(1, procDefId);
				pstmt.setInt(2, activityId);
				pstmt.setInt(3, procDefId);
				pstmt.execute();
				rs = pstmt.getResultSet();
				int i = 0;
				String tempStr = "";
				tempXml.append("<Attributes>\n");
				while (rs.next()) {
					tempXml.append("<Attribute>\n");
					tempXml.append(gen.writeValueOf("Name", rs.getString(1)));

					tempXml.append("<Type>");
					tempStr = rs.getString(2);
					char k = rs.wasNull() ? '\0' : tempStr.toUpperCase().charAt(0);

					switch (k) {
						case 'C':
							tempXml.append("3");
							break;
						case 'S':
							tempXml.append("3");
							break;
						case 'M':
							tempXml.append("3");
							break;
						case 'I':
							tempXml.append("2");
							break;
						default:
							tempXml.append("1");
							break;
					}

					tempStr = rs.getString(3);
					k = rs.wasNull() ? '\0' : tempStr.toUpperCase().charAt(0);

					switch (k) {
						case 'B':
							tempXml.append("3");
							break;
						case '0':
							tempXml.append("3");
							break;
						case 'R':
							tempXml.append("1");
							break;
						case 'M':
							tempXml.append("2");
							break;
						default:
							tempXml.append("0");
							break;
					}
					tempXml.append(rs.getInt(4));
					tempXml.append("</Type>");

					tempXml.append(gen.writeValueOf("Length", String.valueOf(rs.getString(5))));
					tempXml.append("\n</Attribute>\n");
					i++;
				}
				tempXml.append("\n</Attributes>\n");

				pstmt.close();
				if (i == 0) {
					mainCode = WFSError.WM_NO_MORE_DATA;
					subCode = 0;
					subject = WFSErrorMsg.getMessage(mainCode);
					descr = WFSErrorMsg.getMessage(subCode);
					errType = WFSError.WF_TMP;
				} else {
					tempXml.append(gen.writeValueOf("RetrievedCount", String.valueOf(i)));
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
				outputXML.append(gen.createOutputFile("WFGetProcessData"));
				outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
				outputXML.append(tempXml);
				outputXML.append(gen.closeOutputFile("WFGetProcessData"));
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
			try{
				if(rs!=null){
					rs.close();
					rs=null;
				}
			}catch(Exception e){
				WFSUtil.printErr(engine,"", e);
			}
			try {
				if (pstmt != null) {
					pstmt.close();
					pstmt = null;
				}
			} catch (Exception e) {
				WFSUtil.printErr(engine,"", e);
			}
			
		}
		if (mainCode != 0) {
			throw new WFSException(mainCode, subCode, errType, subject, descr);
		}
		return outputXML.toString();
	}

	//----------------------------------------------------------------------------------------------------
	//	Function Name 				:	WFSetAttributes
	//	Date Written (DD/MM/YYYY)	:	16/05/2002
	//	Author						:	Prashant
	//	Input Parameters			:	Connection , XMLParser , XMLGenerator
	//	Output Parameters			:   none
	//	Return Values				:	String
	//	Description					:   Multiple attribute assignment.
	//----------------------------------------------------------------------------------------------------
	public String WFSetAttributes(Connection con, XMLParser parser,
			XMLGenerator gen) throws JTSException, WFSException {
		StringBuffer outputXML = new StringBuffer("");
		ResultSet rs = null;
                Statement stmtTask  = null;
                PreparedStatement psmt = null;
                ResultSet rsTask = null;
		int mainCode = 0; 
		int subCode = 0;
		String subject = null;
		String descr = null;
		String errType = WFSError.WF_TMP;
		boolean reminder = false;
		boolean isWMCompleteTask=false;
		String engine ="";
		String dbLastModifiedTime = ""; 
		PreparedStatement pstmt = null;
		boolean isConcurrentChangeDone = false;
		Boolean processVariablesModified =false;
		HashMap hashIdInsertionIdMap = new HashMap();
		StringBuffer tempXML =new StringBuffer(100);
		int taskId = 0;
        int subTaskId = 0;
        int processDefId = 0;
        int workItemID = 0;
		String pinstId = "";
		String urn = "";
		try {
			int sessionID = parser.getIntOf("SessionId", 0, true);
			engine = parser.getValueOf("EngineName");
			int dbType = ServerProperty.getReference().getDBType(engine);
			String modifiedTime =WFSUtil.dbDateTime(con, dbType);
			/* 05/09/2007, SrNo-10, Synchronous routing of workitems. - Ruhi Hira */
			/** 04/01/2008, Bugzilla Bug 3227, OmniServiceFlag considered in SetAttribute
			 * and sessionId made non mandatory in LinkWorkitem. - Ruhi Hira */
			char omniServiceFlag = parser.getCharOf("OmniService", 'N', true);
			HashMap ipattributes = new HashMap();
			int queryTimeout = WFSUtil.getQueryTimeOut();
			Iterator iter = null;
			boolean internalServiceFlag = false;
			boolean userDefVarFlag = parser.getValueOf("UserDefVarFlag", "N", true).equalsIgnoreCase("Y");
			boolean byPassWorkitemLock = parser.getValueOf("ByPassWorkitemLock", "N", true).equalsIgnoreCase("Y");
			boolean isValidationRequired = parser.getValueOf("IsValidationRequired", "N", true).equalsIgnoreCase("Y");
			boolean isDeleteInsertFlag = parser.getValueOf("IsDeleteInsertFlag", "N", true).equalsIgnoreCase("Y");
			boolean pdaFlag = parser.getValueOf("PDAFlag", "N", true).equalsIgnoreCase("Y");
			boolean debugFlag = parser.getValueOf("DebugFlag", "N", true).equalsIgnoreCase("Y");
			reminder = parser.getValueOf("ReminderFlag", "N", true).equalsIgnoreCase("Y");
			boolean isAssignAttributes = !parser.getValueOf("Attributes", "", true).equalsIgnoreCase("");
	        String option = parser.getValueOf("Option", "", false);
                        int activityId = parser.getIntOf("ActivityId",0,true);
                        int activityType = parser.getIntOf("ActivityType",0,true);
                        String lastModifiedTime =parser.getValueOf("LastModifiedTime", "", true);
                        if(lastModifiedTime.contains(".")){
                        	lastModifiedTime =lastModifiedTime.substring(0, lastModifiedTime.indexOf("."));              				  
              			  }
                         taskId = parser.getIntOf("TaskId",0,true);
                         subTaskId = parser.getIntOf("SubTaskId",0,true);
                         processDefId = parser.getIntOf("ProcessDefId",0,true);
                         workItemID = parser.getIntOf("WorkItemID", 0, false);
        				 pinstId = parser.getValueOf("ProcessInstanceID", "", false);            
			long startTime = 0L;
			long endTime = 0L;
			int userId = 0 ;
			XMLParser parser1 = new XMLParser(parser.toString());
			WFParticipant participant = null;
			if (omniServiceFlag == 'Y') {
				participant = new WFParticipant(0, "System", 'P', "SERVER", Locale.getDefault().toString());
				internalServiceFlag = true;
			} else {
				participant = WFSUtil.WFCheckSession(con, sessionID);
			}
//            WFParticipant participant = WFSUtil.WFCheckSession(con, sessionID);
			
			if (participant != null && (participant.gettype() == 'U' || participant.gettype() == 'P')) {

				
				userId =participant.getid();
				/**
				 * Changed by: Mohnish Chopra
				 * Change Description : Return Error if workitem has expired.
				 * 
				 */
            	/*if(WFSUtil.isWorkItemExpired(con, dbType, pinstId, workItemID, sessionID, userId, debugFlag, engine)){
    				
                   // throw new WFSException(mainCode, subCode, errType, subject, descr);
                
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
              
                    if(con.getAutoCommit()){
                        con.setAutoCommit(false);
                    }
                    if(activityType == 32){
              		  pstmt =con.prepareStatement("Select LastModifiedTime,URN FROM wfinstrumenttable where processinstanceid =? and workitemid= ? ");
              		  WFSUtil.DB_SetString(1, pinstId, pstmt, dbType);
              		  pstmt.setInt(2, workItemID);
              		if(queryTimeout <= 0)
              			pstmt.setQueryTimeout(60);
              		else
              			pstmt.setQueryTimeout(queryTimeout);
              		  rs = pstmt.executeQuery();
              		 
              		  if(rs.next()){
              			  dbLastModifiedTime = rs.getString("LastModifiedTime");
              			  urn = rs.getString("URN");
              			  if(dbLastModifiedTime==null){
              				  dbLastModifiedTime ="";
              			  }
              			  else if(dbLastModifiedTime.contains(".")){
              				dbLastModifiedTime =dbLastModifiedTime.substring(0, dbLastModifiedTime.indexOf("."));              				  
              			  }
              		  }
              		  if(pstmt!=null){
              			  pstmt.close();
              			  pstmt = null;
              		  }
              		  if(rs!=null){
              			  rs.close();
              			  rs = null;
              		  }
              		  if(!dbLastModifiedTime.equalsIgnoreCase(lastModifiedTime)){/*  
              			  mainCode = WFSError.WF_OPERATION_FAILED;
                            subCode = WFSError.WF_WORKITEM_DATA_MODIFIED;
                            subject = WFSErrorMsg.getMessage(mainCode);
                            descr = WFSErrorMsg.getMessage(subCode);
                            errType = WFSError.WF_TMP;
            				String errorString = WFSUtil.generalError("WMSetExternalData", engine, gen,mainCode, subCode,errType, subject,descr);
          				return errorString;
              		  */
              			isConcurrentChangeDone=true;  
              		  }
              		 
              	  }
                //Saving task data while saving or completing a task.
                	String scope = "P";
                	boolean useSeparateTable =true;
                	int taskType = 0 ;//1-Genereic, 4 - Approval, 2-Subprocess , 3-Meeting Task
                    if(taskId>0){
                    	String taskQry = "Select Scope,UseSeparateTable from WFTaskDefTable where  ProcessDefId =? And TaskId = ?";
                    	psmt = con.prepareStatement(taskQry);
                    	psmt.setInt(1, processDefId);
                    	psmt.setInt(2, taskId);
                    	if(queryTimeout <= 0)
                  			psmt.setQueryTimeout(60);
                  		else
                  			psmt.setQueryTimeout(queryTimeout);
                    	rsTask = psmt.executeQuery();
                    	if(rsTask.next()){
                    		scope= TO_SANITIZE_STRING(rsTask.getString("Scope"),true);
                    		useSeparateTable = ("Y").equalsIgnoreCase(rsTask.getString("UseSeparateTable"));
		                	
                    		
                    	}
                    }
                    if(rsTask!=null){
                    	rsTask.close();
                    	rsTask=null;
                    }
                    if(psmt!=null){
                    	psmt.close();
                    	psmt=null;
                    }
                                int noOfTaskDataFields = parser.getNoOfFields("Data");
                                if(noOfTaskDataFields >0){
                                    XMLParser taskDataParser = new XMLParser();
                                    HashMap<Integer,WFTaskInfoClass> taskDataMap = new HashMap<Integer,WFTaskInfoClass>();
                                    ArrayList taskDataList = new ArrayList();
                                    int templateId = 0;
                                   
                                    int templateVarId = 0;
                                    String taskVarName = "";
                                    String value = "";
                                    int variableType = 0;
                                    taskDataList.add(parser.getFirstValueOf("Data"));
                                    for(int i = 1; i < noOfTaskDataFields; i++) {
                                       taskDataList.add(parser.getNextValueOf("Data"));
                                    }
                                    taskDataList.add(parser.getFirstValueOf("Data"));
                                    for(int i = 0; i < noOfTaskDataFields; i++){
                                       taskDataParser.setInputXML((String) taskDataList.get(i));
                                       templateVarId = taskDataParser.getIntOf("TemplateVariableId",0,true);
                                       taskVarName = taskDataParser.getValueOf("TaskVariableName");
                                       value  = taskDataParser.getValueOf("Value");
                                       //value=WFSUtil.handleSpecialCharInXml(value, false);
                                       variableType = taskDataParser.getIntOf("VariableType",0,false);
                                       taskDataMap.put(templateVarId,new WFTaskInfoClass(templateVarId, taskVarName, value,variableType));
                                    }
                                    
                                    Boolean processVariablesModified1[]={processVariablesModified};
                                    mainCode = WFSUtil.setTaskData(con,participant, engine,dbType,processDefId,pinstId,workItemID,activityId,
                                                           taskId,subTaskId,taskType,taskDataMap,isConcurrentChangeDone,processVariablesModified1,scope,useSeparateTable,internalServiceFlag);
                                    processVariablesModified=processVariablesModified1[0];
                                    if(mainCode!=0&&!isConcurrentChangeDone){
                                        //Handle new error code to represent Error while Saving Task Data
                                           mainCode = WFSError.WF_TASK_DATA_NOTSAVED;
                                           subCode = 0;
                                           subject = WFSErrorMsg.getMessage(mainCode);
                                           descr = WFSErrorMsg.getMessage(mainCode);
                                           errType = WFSError.WF_TMP;
                                           String strReturn = WFSUtil.generalError(option, engine, gen,mainCode, subCode,errType, subject,descr);
                                           return strReturn;

                                    }
                                    else if(mainCode!=0&&isConcurrentChangeDone){
                                    	mainCode = WFSError.WF_OPERATION_FAILED;
                                        subCode = WFSError.WF_WORKITEM_DATA_MODIFIED;
                                        subject = WFSErrorMsg.getMessage(mainCode);
                                        descr = WFSErrorMsg.getMessage(subCode);
                                        errType = WFSError.WF_TMP;
                        				String errorString = WFSUtil.generalError("WMSetExternalData", engine, gen,mainCode, subCode,errType, subject,descr);
                      				return errorString;

                                    }
                                } 
                                if((isConcurrentChangeDone)&&(processVariablesModified||isAssignAttributes)){
              					  mainCode = WFSError.WF_OPERATION_FAILED;
                                    subCode = WFSError.WF_WORKITEM_DATA_MODIFIED;
                                    subject = WFSErrorMsg.getMessage(mainCode);
                                    descr = WFSErrorMsg.getMessage(subCode);
                                    errType = WFSError.WF_TMP;
                    				String errorString = WFSUtil.generalError("WMSetExternalData", engine, gen,mainCode, subCode,errType, subject,descr);
                  				return errorString;
              				}
                                
                                	WFTaskThreadLocal.set(taskId);
				int start = parser.getStartIndex("Attributes", 0, 0);
				int deadend = parser.getEndIndex("Attributes", start, 0);
				int noOfAtt = parser.getNoOfFields("Attribute", start, deadend);
				int end = 0;
				String tempStr = "";
				//Added for code optimization
				for (int i = 0; i < noOfAtt; i++) {
					start = parser.getStartIndex("Attribute", end, 0);
					end = parser.getEndIndex("Attribute", start, 0);
					tempStr = parser.getValueOf("Name", start, end).trim();
					ipattributes.put(tempStr.toUpperCase(), new WMAttribute(tempStr,
							parser.getValueOf("Value", start, end), 10));
				}
                                int indx = pinstId.indexOf(" ");
                                if(indx > -1)
                                pinstId = pinstId.substring(0, indx);
				if (!userDefVarFlag) {
					if (pdaFlag) {
						/*WFPDAUtil.setAttributes(con, participant, ipattributes, engine, pinstId, workItemID, gen, null, internalServiceFlag);*/
						WFPDAUtil.setAttributes(con, participant, ipattributes, engine, pinstId, workItemID, gen, null, internalServiceFlag, sessionID, debugFlag);
					} else {
						WFSUtil.setAttributes(con, participant, ipattributes, engine, pinstId, workItemID, gen, null, internalServiceFlag);
					}
				} else {
					/** 03/04/2008, Bugzilla Bug 5488, Set command in entry settings does not execute. - Ruhi Hira */
					/** 17/06/2008, SrNo-13, New feature : user defined complex data type support [OF 7.2] - Ruhi Hira */
					WFSUtil.setAttributesExt(con, participant, (parser.getValueOf("Attributes")), engine, pinstId, workItemID, gen, null, internalServiceFlag, debugFlag, false,sessionID,null,false,hashIdInsertionIdMap,isDeleteInsertFlag,isValidationRequired,byPassWorkitemLock);
				}
                                
                               if (!con.getAutoCommit()) {
                                    con.commit();
                                    con.setAutoCommit(true);
                             }

			} else {
				mainCode = WFSError.WM_INVALID_SESSION_HANDLE;
				subCode = 0;
				subject = WFSErrorMsg.getMessage(mainCode);
				descr = WFSErrorMsg.getMessage(subCode);
				errType = WFSError.WF_TMP;
			}
               //Bug 45440 - IF Session is expired and now save the workitem, relevant error message should be shown on UI.
               //Sajid Khan - 09- May 2014
                  if (mainCode == 0) {
                	  if(hashIdInsertionIdMap.size()>0){

                		  tempXML.append("<InsertionOrderIdValues>\n");
                		  Iterator iterator = hashIdInsertionIdMap.entrySet().iterator();
                		  while (iterator.hasNext()) {
                			  Map.Entry pair = (Map.Entry)iterator.next();
                			  tempXML.append("<InsertionOrderIdValue>\n");
                			  tempXML.append("<HashId>");
                			  tempXML.append(pair.getKey());
                			  tempXML.append("</HashId>\n");
                			  tempXML.append("<InsertionOrderId>");
                			  tempXML.append(pair.getValue());
                			  tempXML.append("</InsertionOrderId>\n");
                			  tempXML.append("</InsertionOrderIdValue>\n");
                		  }
                		  tempXML.append("</InsertionOrderIdValues>\n");
                	  }
                	  
			if(isAssignAttributes){
					processVariablesModified=true;
					outputXML = new StringBuffer(500);
					if (ipattributes.size() > 0) {
						outputXML.append(gen.writeError("WFSetAttributes",
								WFSError.WM_ATTRIBUTE_ASSIGNMENT_FAILED, 0, WFSError.WF_TMP,
								WFSErrorMsg.getMessage(WFSError.WM_ATTRIBUTE_ASSIGNMENT_FAILED), null));
						outputXML.delete(outputXML.indexOf("</" + "WFSetAttributes" + "_Output>"), outputXML.length()); //Bugzilla Bug 259
						iter = ipattributes.keySet().iterator();
						outputXML.append("<FailedList>");
						while (iter.hasNext()) {
							outputXML.append("<Attribute>");
							outputXML.append(iter.next());
							outputXML.append("</Attribute>");
						}
						outputXML.append("</FailedList>\n");
					} else {
						outputXML.append(gen.createOutputFile("WFSetAttributes"));
						outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
					}
					outputXML.append(tempXML);
					if(reminder) {
						String reminderFound = WFSUtil.getReminderDetails(con, engine, participant.getid());
						outputXML.append("<ReminderFlag>"+reminderFound+"</ReminderFlag>");
					}
					
			}
			else{
				outputXML = new StringBuffer(500);
				outputXML.append(gen.createOutputFile("WFSetAttributes"));
				outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");           
			}
			String complete = parser.getValueOf("Complete", "", true);
			String startProcessResult = "";
			boolean isWMComplete = false;
			boolean isStartProcess = false;
			//Added for Case Management
			if(complete.equalsIgnoreCase("D")&&(taskId>0)){
				isWMCompleteTask=true;
			}
			else if(complete.equalsIgnoreCase("D")){
				isWMComplete = true;
			}else if (complete.equalsIgnoreCase("I")){
				isStartProcess = true;
			}  
			
			String completeWorkItemResult = "";
			StringBuilder combinedResult = new StringBuilder();

			if(isWMComplete){
				//input XML for WMCompleteWorkItem
				StringBuilder wmCompleteWorkItemXML = new StringBuilder();

				wmCompleteWorkItemXML.append("<?xml version=\"1.0\"?><WMCompleteWorkItem_Input><Option>WMCompleteWorkItem</Option>");
				wmCompleteWorkItemXML.append("<EngineName>" + engine + "</EngineName>");
				wmCompleteWorkItemXML.append("<SessionId>" + sessionID  + "</SessionId>");                      
				wmCompleteWorkItemXML.append("<ProcessInstanceId>" +  parser.getValueOf("ProcessInstanceId", "", true)  + "</ProcessInstanceId>");   
				wmCompleteWorkItemXML.append("<WorkItemId>" +  parser.getValueOf("WorkItemId", "", true)   + "</WorkItemId>");
				wmCompleteWorkItemXML.append("<AuditStatus>" +  parser.getValueOf("AuditStatus", "", true)   + "</AuditStatus>");
				wmCompleteWorkItemXML.append("<Comments>" +  parser.getValueOf("Comments", "", true)   + "</Comments>");
				wmCompleteWorkItemXML.append("<ActivityId>" +  parser.getValueOf("ActivityId", "", true)   + "</ActivityId>");
				wmCompleteWorkItemXML.append("</WMCompleteWorkItem_Input>");

				parser1.setInputXML(wmCompleteWorkItemXML.toString());

				try{
					startTime = System.currentTimeMillis();
					//call WMCompleteWorkItem API                                                                         
					completeWorkItemResult =  WFFindClass.getReference().execute("WMCompleteWorkItem", engine, con, parser1,gen);                                                        
					endTime = System.currentTimeMillis();  
				}catch(WFSException wfse){                       
					throw wfse;
				}
				WFSUtil.writeLog("WFClientServiceHandlerBean", "WMCompleteWorkItem", startTime, endTime, 0, wmCompleteWorkItemXML.toString(),completeWorkItemResult,engine,0,sessionID,userId);                              
				wmCompleteWorkItemXML = null;                  
			}                      
			else if(isStartProcess){
				//input XML for WMStartProcess
				StringBuilder wmStartProcessXML = new StringBuilder();

				wmStartProcessXML.append("<?xml version=\"1.0\"?><WMStartProcess_Input><Option>WMStartProcess</Option>");
				wmStartProcessXML.append("<EngineName>" + engine + "</EngineName>");
				wmStartProcessXML.append("<SessionId>" + sessionID  + "</SessionId>");                      
				wmStartProcessXML.append("<ProcessInstanceId>" +  parser.getValueOf("ProcessInstanceId", "", true)  + "</ProcessInstanceId>");   
				wmStartProcessXML.append("<WorkItemId>" +  parser.getValueOf("WorkItemId", "", true)  + "</WorkItemId>"); 
				wmStartProcessXML.append("<ActivityId>" +  parser.getValueOf("ActivityId", "", true)   + "</ActivityId>");
				wmStartProcessXML.append("</WMStartProcess_Input>");

				parser1.setInputXML(wmStartProcessXML.toString());
				try{
					startTime = System.currentTimeMillis();
					//call WMCompleteWorkItem API                                                                         
					startProcessResult =  WFFindClass.getReference().execute("WMStartProcess", engine, con, parser1,gen);                                                        
					endTime = System.currentTimeMillis();  
				}catch(WFSException wfse){     
					throw wfse;
				}
				WFSUtil.writeLog("WFClientServiceHandlerBean", "WMStartProcess", startTime, endTime, 0, wmStartProcessXML.toString(), startProcessResult,engine,0,sessionID,userId);
				wmStartProcessXML = null;                  
			}
			
			else if(isWMCompleteTask){//Added for Case Management
				int caseWorkStepId = 0;
				String caseManager="";
				String taskInitiator="";
				String username = participant.gettype() == 'P' ? "System" : participant.getname();
				

//					PreparedStatement pstmt = null;
					ResultSet rs2=null;
					//int activityType =0;
					
					pstmt = con.prepareStatement("Select ActivityId,AssignedUser FROM WFInstrumentTable " + WFSUtil.getTableLockHintStr(dbType) + " where ProcessInstanceId = ? AND WorkItemId  = ? ");
			        WFSUtil.DB_SetString(1, pinstId, pstmt, dbType);
			        pstmt.setInt(2, workItemID);
			        if(queryTimeout <= 0)
              			pstmt.setQueryTimeout(60);
              		else
              			pstmt.setQueryTimeout(queryTimeout);

			        pstmt.execute();
					rs2 = pstmt.getResultSet();
			        if (rs2 != null && rs2.next()) {
			        	if(activityId==0){
			        	caseWorkStepId = rs2.getInt("ActivityId");
			        	}
			        	caseManager=rs2.getString("AssignedUser");
			        }

			        if (rs2 != null) {
			            rs2.close();
			            rs2 = null;
			        }
			        if (pstmt != null) {
			            pstmt.close();
			            pstmt = null;
			        }
			        if (rs != null) {
			            rs.close();
			            rs = null;
			        }
					caseWorkStepId=activityId;
					boolean approvalRequired =false;
					String approvalSentBy = "";
					pstmt = con
					 .prepareStatement("select ApprovalRequired,ApprovalSentBy,InitiatedBy,AssignedTo from WFTaskStatusTable " + WFSUtil.getTableLockHintStr(dbType)
					 + "where ProcessInstanceId= ? and WorkItemId= ? and ProcessDefId= ? and ActivityId= ? and TaskId= ? and subtaskid= ? "
					 + "and AssignedTo= ? ");
			 WFSUtil.DB_SetString(1, pinstId, pstmt, dbType);
			 pstmt.setInt(2, workItemID);
			 pstmt.setInt(3, processDefId);
			 pstmt.setInt(4, activityId);
			 pstmt.setInt(5, taskId);
			 pstmt.setInt(6, subTaskId);
			 WFSUtil.DB_SetString(7, username, pstmt, dbType);
			 if(queryTimeout <= 0)
       			pstmt.setQueryTimeout(60);
       		else
       			pstmt.setQueryTimeout(queryTimeout);
			 pstmt.executeQuery();
			 rs = pstmt.getResultSet();
			 if (rs.next()) {
				 approvalRequired = rs.getString("ApprovalRequired").equalsIgnoreCase("Y");
				 approvalSentBy = rs.getString("ApprovalSentBy");
			 }
			 String initiatedBy = rs.getString("InitiatedBy");
			 String assignedTo = rs.getString("AssignedTo");
			 rs.close();
			 pstmt.close();
			 int rs1 = 0;
			 HashMap<String,Integer> completeTaskMap=new HashMap<String,Integer>();
			 if(approvalRequired && initiatedBy!=null && initiatedBy.equalsIgnoreCase(assignedTo))
			 {
				 approvalRequired = false;
			 }
			 if(!approvalRequired){
				 completeTaskMap = WFSUtil.completeTask(con, dbType, processDefId, pinstId, workItemID, caseWorkStepId, taskId, subTaskId,modifiedTime,username);
				 rs1=completeTaskMap.get("UpdateCount");
			 }
			 else {
				 pstmt = con.prepareStatement(" update WFTaskStatusTable set TaskStatus=?,ApprovalSentBy=?,AssignedTo=initiatedby , ActionDateTime=" + WFSUtil.TO_DATE(modifiedTime, true, dbType) 
   						 + " where ProcessInstanceId=? and WorkItemId=? and ProcessDefId=? and ActivityId=? and TaskId=? and SubTaskId =? and TaskStatus=? and Assignedto=? and ApprovalRequired=?");
   						 pstmt.setInt(1, WFSConstant.WF_TaskPendingForApproval); 
   						 WFSUtil.DB_SetString(2, username, pstmt, dbType);
   						 WFSUtil.DB_SetString(3, pinstId, pstmt, dbType);
   						 pstmt.setInt(4, workItemID); 
   						 pstmt.setInt(5, processDefId);
   						 pstmt.setInt(6, activityId);
   						 pstmt.setInt(7, taskId); 
   						 pstmt.setInt(8, subTaskId); 
   						 pstmt.setInt(9, 2);
   						 WFSUtil.DB_SetString(10, username, pstmt, dbType);
   						 WFSUtil.DB_SetString(11, "Y", pstmt, dbType);
   						if(queryTimeout <= 0)
   	              			pstmt.setQueryTimeout(60);
   	              		else
   	              			pstmt.setQueryTimeout(queryTimeout);
   						 rs1=pstmt.executeUpdate();
			 }
				if(rs1>0){
					combinedResult.append("<TaskCompleted>Y</TaskCompleted>");  
                                        WFSUtil.generateTaskLog(engine, con,dbType, pinstId,WFSConstant.WFL_TaskCompleted, workItemID, 
                                                    processDefId,activityId,null,0,userId, participant.getname(),null, taskId,subTaskId,modifiedTime);
                        HashMap<String,String> mapForTaskAttributes = new HashMap<String, String>();
                        boolean notifyByEmail=false;
                        String taskName="";
                        pstmt = con.prepareStatement("Select NotifyEmail, TaskName,"+WFSUtil.getDate(dbType)+" CreatedDate  From WFTaskDefTable " + WFSUtil.getTableLockHintStr(dbType) + " Where ProcessDefId = ? And TaskId = ? ");
                        pstmt.setInt(1, processDefId);
                        pstmt.setInt(2, taskId);
                        if(queryTimeout <= 0)
   	              			pstmt.setQueryTimeout(60);
   	              		else
   	              			pstmt.setQueryTimeout(queryTimeout);
                        rs = pstmt.executeQuery();
                        
						if(rs.next()){
                            notifyByEmail = (rs.getString("NotifyEmail")).equalsIgnoreCase("Y");
                            taskName = rs.getString(2);
                            mapForTaskAttributes.put("TaskName",taskName);
                            mapForTaskAttributes.put("CompletedOn",rs.getString("CreatedDate"));
                        }
                        if(pstmt!= null){
                            pstmt.close();
                            pstmt = null;
                        }
                        if(rs!= null){
                            rs.close();
                            rs = null;
                        }
                        if(notifyByEmail){
                        	pstmt = con.prepareStatement("Select AssignedBy, AssignedTo  From wftaskstatustable " + WFSUtil.getTableLockHintStr(dbType) + " Where ProcessDefId = ? And TaskId = ? and processinstanceid=?");
                            pstmt.setInt(1, processDefId);
                            pstmt.setInt(2, taskId);
                            pstmt.setString(3,pinstId);
                            if(queryTimeout <= 0)
       	              			pstmt.setQueryTimeout(60);
       	              		else
       	              			pstmt.setQueryTimeout(queryTimeout);
                            rs = pstmt.executeQuery();
                            
    						if(rs.next()){
    							if(approvalRequired) {
    								taskInitiator = username;
    							}else {
    								taskInitiator=rs.getString("AssignedTo");
    							}
                                mapForTaskAttributes.put("CompletedBy",taskInitiator);
                                mapForTaskAttributes.put("AssignedTo",rs.getString("AssignedTo"));
                            }
                        	pstmt =con.prepareStatement("Select a.processname, b.activityname from ProcessDefTable a " + WFSUtil.getTableLockHintStr(dbType) + " inner join activitytable b " + WFSUtil.getTableLockHintStr(dbType) + " on a.processdefid = b.processdefid and a.processdefid = ? and b.activityid = ?");
                        	pstmt.setInt(1, processDefId);
                        	pstmt.setInt(2, activityId);
                        	if(queryTimeout <= 0)
       	              			pstmt.setQueryTimeout(60);
       	              		else
       	              			pstmt.setQueryTimeout(queryTimeout);
                        	rs=pstmt.executeQuery();
                        	if(rs.next()){
                        		mapForTaskAttributes.put("RouteName",rs.getString("processname"));
                        		mapForTaskAttributes.put("ActivityName",rs.getString("activityname"));
                        	}
                        	 if(pstmt!= null){
                                 pstmt.close();
                                 pstmt = null;
                             }
                             if(rs!= null){
                                 rs.close();
                                 rs = null;
                             }
                        	
                        
                        String webServerAddress = parser.getValueOf("WebServerAddress","http://127.0.0.1:8080",true);
                        int webServerPort = parser.getIntOf("WebServerPort",0,true);
                       
                  	  String OAPWebServerAddress = parser.getValueOf("OAPWebServerAddress","http://127.0.0.1:8080",true);
            			mapForTaskAttributes.put("ProcessInstanceId", pinstId);
        				mapForTaskAttributes.put("WorkItemId", String.valueOf(workItemID));
        			//	mapForTaskAttributes.put("DueDate",dueDate);////Not required
        			//	mapForTaskAttributes.put("InitiatedOn",strDate);//Not required
        			//	mapForTaskAttributes.put("CompletedOn",);//Newly Added-added
        			//	mapForTaskAttributes.put("AssignedTo", assgnTo);//--
        				mapForTaskAttributes.put("EngineName", engine);
        				mapForTaskAttributes.put("TaskId",String.valueOf(taskId));
        				mapForTaskAttributes.put("OAPWebServerAddress", OAPWebServerAddress);//--
        				mapForTaskAttributes.put("WebServerAddress",webServerAddress);//--
        			//	mapForTaskAttributes.put("WebServerPort",String.valueOf(webServerPort));//--Not required
        				//mapForTaskAttributes.put("Instructions",instruction);//--//Not required
        				mapForTaskAttributes.put("ActivityType",String.valueOf(32));//--
        				//mapForTaskAttributes.put("TaskName",taskName);//--Already added
        				if(urn!=null&&!urn.equals("")){
        					mapForTaskAttributes.put("URN", urn);
            				mapForTaskAttributes.put("MailSubject", "Task- "+taskName+ " completed for "+urn);
        				}else{
        					mapForTaskAttributes.put("URN", pinstId);
            				mapForTaskAttributes.put("MailSubject", "Task- "+taskName+ " completed for "+pinstId);
        				}
        				
                        pstmt = con.prepareStatement("Select MailId From wfuserview Where UserName = ?");
                        if(approvalSentBy != null) {
                        	pstmt.setString(1, approvalSentBy);
                        }else {
                        	 pstmt.setString(1, caseManager);
                        }
                        if(queryTimeout <= 0)
   	              			pstmt.setQueryTimeout(60);
   	              		else
   	              			pstmt.setQueryTimeout(queryTimeout);
                        rs = pstmt.executeQuery();
                        String userEmail="";
						while(rs.next()){
                            userEmail = rs.getString(1);
                        }
						
						//ccEmailId support
                        pstmt = con.prepareStatement("Select MailId From wfuserview Where UserName = ?");
						pstmt.setString(1, taskInitiator);
						rs = pstmt.executeQuery();
                        String ccUserEmail="";
						while(rs.next()){
							ccUserEmail = rs.getString(1);
                        }
                        if(userEmail != null && !("".equals(userEmail))){
							HashMap<String, String> mailStringAttributes = new HashMap<String, String>(); 
							HashMap<String, Integer> mailIntAttributes = new HashMap<String, Integer>();
							mailStringAttributes.put("CabinetName", engine);
							mailStringAttributes.put("MailTo", userEmail.toString());
							if(ccUserEmail != null && !("".equals(ccUserEmail))) {
								mailStringAttributes.put("MailCC", ccUserEmail.toString());
							}else {
								mailStringAttributes.put("MailCC", null);
							}
							mailStringAttributes.put("MailAttachmentIndex", null);
							mailStringAttributes.put("MailAttachmentNames", null);
							mailStringAttributes.put("MailStatus", "N");
							mailStringAttributes.put("MailStatusComments", null);
							mailStringAttributes.put("MailInsertedBy", null);
							mailStringAttributes.put("MailActionType", "TaskNotification");
							mailStringAttributes.put("MailAttachmentExtensions", null);
							mailStringAttributes.put("PropertyName", "CompleteTask");
							mailStringAttributes.put("ProcessInstanceId", pinstId);
							mailIntAttributes.put("MailPriority", 1);
							mailIntAttributes.put("ProcessDefID", processDefId);
							mailIntAttributes.put("WorkItemId", workItemID);
							mailIntAttributes.put("ActivityId", activityId);
							mailIntAttributes.put("DbType", dbType);
							mailIntAttributes.put("NoOfTrials", 3);
							mapForTaskAttributes.put("SubTaskId", String.valueOf(subTaskId));
							EmailTemplateUtil.addTaskToMailQueue(con, mapForTaskAttributes, mailIntAttributes, mailStringAttributes);
                        }
                        if(pstmt!= null){
                            pstmt.close();
                            pstmt = null;
                        }
                        if(rs!= null){
                            rs.close();
                            rs = null;
                        }
                      }
        				
				}else {
					mainCode = WFSError.WF_NO_AUTHORIZATION;
					subCode = 0;
					subject = WFSErrorMsg.getMessage(mainCode);
					descr = WFSErrorMsg.getMessage(subCode);
					errType = WFSError.WF_TMP;
					throw new WFSException(mainCode, subCode, errType, subject, descr);
				}
			}
			
			
			XMLParser resultParser = new XMLParser();
			if(completeWorkItemResult.length() > 0){
			   resultParser.setInputXML(completeWorkItemResult);
			   combinedResult.append("<WMCompleteWorkItem_Output>");
			   combinedResult.append("<Exception>");
			   combinedResult.append("<MainCode>");
			   combinedResult.append(resultParser.getValueOf("MainCode"));
			   combinedResult.append("</MainCode>");
			   combinedResult.append("</Exception>");
			   resultParser.setInputXML(completeWorkItemResult);
			   combinedResult.append("<EntryDateTime>");
			   combinedResult.append(resultParser.getValueOf("EntryDateTime"));
			   combinedResult.append("</EntryDateTime>");
			   combinedResult.append("<CompletionTime>");
			   combinedResult.append(resultParser.getValueOf("CompletionTime"));
			   combinedResult.append("</CompletionTime>");
			   combinedResult.append("<ProcessInstanceId>");
			   combinedResult.append(resultParser.getValueOf("ProcessInstanceId"));
			   combinedResult.append("</ProcessInstanceId>");
			   combinedResult.append("<WorkitemId>");
			   combinedResult.append(resultParser.getValueOf("WorkitemId"));
			   combinedResult.append("</WorkitemId>");
			   combinedResult.append("<ActivityName>");
			   combinedResult.append(resultParser.getValueOf("ActivityName"));
			   combinedResult.append("</ActivityName>");
			   combinedResult.append("<ActivityId>");
			   combinedResult.append(resultParser.getValueOf("ActivityId"));
			   combinedResult.append("</ActivityId>");
			   if(resultParser.toString().indexOf("TargetActivityID") > 0){
				   combinedResult.append("<TargetActivityID>");
				   combinedResult.append(resultParser.getValueOf("TargetActivityID"));
				   combinedResult.append("</TargetActivityID>");
			   }
			   if(resultParser.toString().indexOf("TargetQueueID") > 0){
				   combinedResult.append("<TargetQueueID>");
				   combinedResult.append(resultParser.getValueOf("TargetQueueID"));
				   combinedResult.append("</TargetQueueID>");
			   }
			   if(resultParser.toString().indexOf("TargetActivityID") > 0){
				   combinedResult.append("<TargetActivityID>");
				   combinedResult.append(resultParser.getValueOf("TargetActivityID"));
				   combinedResult.append("</TargetActivityID>");
			   }
			   if(resultParser.toString().indexOf("TargetQueueType") > 0){
				   combinedResult.append("<TargetQueueType>");
				   combinedResult.append(resultParser.getValueOf("TargetQueueType"));
				   combinedResult.append("</TargetQueueType>");
			   }
			   if(resultParser.toString().indexOf("TargetProcessInstanceId") > 0){
				   combinedResult.append("<TargetProcessInstanceId>");
				   combinedResult.append(resultParser.getValueOf("TargetProcessInstanceId"));
				   combinedResult.append("</TargetProcessInstanceId>");
			   }
			   if(resultParser.toString().indexOf("TargetWorkitemId") > 0){
				   combinedResult.append("<TargetWorkitemId>");
				   combinedResult.append(resultParser.getValueOf("TargetWorkitemId"));
				   combinedResult.append("</TargetWorkitemId>");
			   }
			   combinedResult.append("</WMCompleteWorkItem_Output>");
                                //Bug 44006- Showing Error if WMStartProcess or WMCompleteWorkItem call gets failed.
                                 mainCode = Integer.parseInt(resultParser.getValueOf("MainCode"));
               if(resultParser.toString().indexOf("SubErrorCode") > 0){
                  subCode = Integer.parseInt(resultParser.getValueOf("SubErrorCode"));
              }
			}       
			if(startProcessResult.length() > 0){
			   resultParser.setInputXML(startProcessResult);
			   combinedResult.append("<WMStartProcesss_Output>");
			   combinedResult.append("<Exception>");
			   combinedResult.append("<MainCode>");
			   combinedResult.append(resultParser.getValueOf("MainCode"));
			   combinedResult.append("</MainCode>");
			   combinedResult.append("</Exception>");
			   combinedResult.append("<ProcessInstanceId>");
			   combinedResult.append(resultParser.getValueOf("ProcessInstanceId"));
			   combinedResult.append("</ProcessInstanceId>");
			   combinedResult.append("<WorkitemId>");
			   combinedResult.append(resultParser.getValueOf("WorkitemId"));
			   combinedResult.append("</WorkitemId>");
			   combinedResult.append("<ActivityName>");
			   combinedResult.append(resultParser.getValueOf("ActivityName"));
			   combinedResult.append("</ActivityName>");
			   combinedResult.append("<ActivityId>");
			   combinedResult.append(resultParser.getValueOf("ActivityId"));
			   combinedResult.append("</ActivityId>");
			   combinedResult.append("<CompletionTime>");
			   combinedResult.append(resultParser.getValueOf("CompletionTime"));
			   combinedResult.append("</CompletionTime>");
			   if(resultParser.toString().indexOf("TargetActivityID") > 0){
				   combinedResult.append("<TargetActivityID>");
				   combinedResult.append(resultParser.getValueOf("TargetActivityID"));
				   combinedResult.append("</TargetActivityID>");
			   }
			   if(resultParser.toString().indexOf("TargetQueueID") > 0){
				   combinedResult.append("<TargetQueueID>");
				   combinedResult.append(resultParser.getValueOf("TargetQueueID"));
				   combinedResult.append("</TargetQueueID>");
			   }
			   if(resultParser.toString().indexOf("TargetActivityID") > 0){
				   combinedResult.append("<TargetActivityID>");
				   combinedResult.append(resultParser.getValueOf("TargetActivityID"));
				   combinedResult.append("</TargetActivityID>");
			   }
			   if(resultParser.toString().indexOf("TargetQueueType") > 0){
				   combinedResult.append("<TargetQueueType>");
				   combinedResult.append(resultParser.getValueOf("TargetQueueType"));
				   combinedResult.append("</TargetQueueType>");
			   }
			   if(resultParser.toString().indexOf("TargetProcessInstanceId") > 0){
				   combinedResult.append("<TargetProcessInstanceId>");
				   combinedResult.append(resultParser.getValueOf("TargetProcessInstanceId"));
				   combinedResult.append("</TargetProcessInstanceId>");
			   }
			   if(resultParser.toString().indexOf("TargetWorkitemId") > 0){
				   combinedResult.append("<TargetWorkitemId>");
				   combinedResult.append(resultParser.getValueOf("TargetWorkitemId"));
				   combinedResult.append("</TargetWorkitemId>");
			   }
			   combinedResult.append("</WMStartProcesss_Output>");
			      //Bug 44006- Showing Error if WMStartProcess or WMCompleteWorkItem call gets failed.
                           mainCode = Integer.parseInt(resultParser.getValueOf("MainCode"));
		   }
			if((mainCode == 0 && activityType == WFSConstant.ACT_CASE)){
				/*pstmt =con.prepareStatement("Select "+WFSUtil.getDate(dbType) + (dbType==JTSConstant.JTS_ORACLE? " from dual" :""));
				rs = pstmt.executeQuery();
				if(rs.next()){
					modifiedTime =rs.getString(1);

				}*/
				if(processVariablesModified){
					pstmt = con.prepareStatement("Update WFInstrumentTable Set LastModifiedTime  = "+WFSUtil.TO_DATE(modifiedTime, true, dbType) + " Where ProcessInstanceId = ? AND WorkItemId = ?");
					WFSUtil.DB_SetString(1, pinstId,pstmt,dbType);
					pstmt.setInt(2, workItemID);
					if(queryTimeout <= 0)
	              			pstmt.setQueryTimeout(60);
	              		else
	              			pstmt.setQueryTimeout(queryTimeout);
					pstmt.executeUpdate();
					if(pstmt != null){
						pstmt.close();
						pstmt = null;
					}
					if(rs!=null){
						rs.close();
						rs = null;
					}
					outputXML.append("\n<LastModifiedTime>");
					outputXML.append(modifiedTime);
					outputXML.append("</LastModifiedTime>\n");
				}
				else{
					outputXML.append("\n<LastModifiedTime>");
					outputXML.append(lastModifiedTime); 
					outputXML.append("</LastModifiedTime>\n");
				}
			}
			

                  if(mainCode != 0){
                        mainCode = WFSError.WF_OPERATION_FAILED;
                        subject =  WFSErrorMsg.getMessage(mainCode);
                        errType =  WFSError.WF_TMP;
                        descr   =  WFSErrorMsg.getMessage(subCode);
                    }
                        outputXML.append(combinedResult.toString());
                        outputXML.append(gen.closeOutputFile("WFSetAttributes"));
                }
		} catch(SQLException e) {
                    WFSUtil.printErr(engine,"", e);
                    mainCode = WFSError.WM_INVALID_FILTER;
                    subCode = WFSError.WFS_SQL;
                    subject = WFSErrorMsg.getMessage(mainCode);
                    errType = WFSError.WF_FAT;
                    if(e.getErrorCode() == 0) {
                      if(e.getSQLState().equalsIgnoreCase("08S01")) {
                        descr = (new JTSSQLError(e.getSQLState())).getMessage() + "(SQL State : " + e.getSQLState()
                          + ")";
                      }
                    } else {
                      descr = e.getMessage();
                    }
                } catch (WFSException e) {
			mainCode = e.getMainErrorCode();
			subCode = e.getSubErrorCode();
			subject = WFSErrorMsg.getMessage(mainCode);
			errType = WFSError.WF_TMP;
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
                        	 WFTaskThreadLocal.unset();
                            if (!con.getAutoCommit()){
                                  try {
                                       con.rollback();
                                  } catch (Exception innerEx) {
                                  }
                            }
                            if(stmtTask!=null){
                                stmtTask.close();
                                stmtTask = null;
                            }
                            if(rsTask!=null){
                                rsTask.close();
                                rsTask = null;
                            }
                           con.setAutoCommit(true);
                        }
                        catch (Exception e) {
                        }
           		
		}
		if (mainCode != 0) {
			throw new WFSException(mainCode, subCode, errType, subject, descr);
		}
		return outputXML.toString();
	}

	//----------------------------------------------------------------------------------------------------
	//	Function Name 				:	WFGetVariableMapping
	//	Date Written (DD/MM/YYYY)	:	16/05/2002
	//	Author						:	Prashant
	//	Input Parameters			:	Connection , XMLParser , XMLGenerator
	//	Output Parameters			:   none
	//	Return Values				:	String
	//	Description					:   Get Variable Mapping
	//----------------------------------------------------------------------------------------------------
	public String WFGetVariableMapping(Connection con, XMLParser parser,
			XMLGenerator gen) throws JTSException, WFSException {
		StringBuffer outputXML = new StringBuffer("");
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int mainCode = 0;
		int subCode = 0;
		String subject = null;
		String descr = null;
		String errType = WFSError.WF_TMP;
		String engine ="";
		String getWorkListConfigFlag = "";
		try {
			int sessionID = parser.getIntOf("SessionId", 0, false);
			engine = parser.getValueOf("EngineName");
			int mqueueid = parser.getIntOf("QueueId", -1, true);
			char dataFlag = parser.getCharOf("DataFlag", 'Y', true); //Ashish added
			int processDefId = parser.getIntOf("ProcessDefId", 0, true);//WFS_8.0_061
			getWorkListConfigFlag = parser.getValueOf("GetWorkListConfigFlag","",true);		
			String enableMultiLingual = parser.getValueOf("EnableMultiLingual", "N", true);
			boolean pmMode = parser.getValueOf("OpenMode", "WD", true).equalsIgnoreCase("PM");
			boolean isArtifactMigrationCase = parser.getValueOf("ArtificationMigration", "N", true).equalsIgnoreCase("Y");
			if(pmMode){
				enableMultiLingual="N";
			}
			int qProcessDefId = 0;
			int dbType = ServerProperty.getReference().getDBType(engine);
			StringBuffer tempXml = null;
                        String locale = "en_US";
                        String scope = "";
			WFParticipant participant = WFSUtil.WFCheckSession(con, sessionID);
            boolean bIsSingleProcessQueue = false;
            if(isArtifactMigrationCase)
            {
            	String queueName = parser.getValueOf("QueueName", "", true);
            	if(!"".equalsIgnoreCase(queueName.trim()))
            	{
            		//Code chnages for Bug 102449 - UT Defect : Handling for My Queue cases was missing for artifact migration of process alias mapping configuration. 
            		if("My Queue".equalsIgnoreCase(queueName.trim()))
            		{
            			mqueueid = 0;
            			String processName = parser.getValueOf("ProcessName", "", true);
            			if(!"".equalsIgnoreCase(processName.trim()))
            			{
            				String exeStr = "select ProcessDefId from ProcessDefTable "+ WFSUtil.getTableLockHintStr(dbType) + " where ProcessName = ? order by VersionNo desc ";
							pstmt = con.prepareStatement(exeStr);
							WFSUtil.DB_SetString(1, processName, pstmt, dbType);
							pstmt.execute();
							rs = pstmt.getResultSet();
							if (rs.next()) {
								processDefId = rs.getInt(1);								
							}
							else
							{
								mainCode = WFSError.WF_INVALID_PROCESS_NAME;
		    					subCode = 0;
		    					subject = WFSErrorMsg.getMessage(mainCode);
		    					descr = WFSErrorMsg.getMessage(subCode);
		    					errType = WFSError.WF_TMP;   
							}
            				
            			}
            		}
            		// Code changes for Bug-102449 ends here
            		else
            		{
	            		pstmt = con.prepareStatement("select queueid from queuedeftable "+ WFSUtil.getTableLockHintStr(dbType) +" where queuename=?");    				
	    				WFSUtil.DB_SetString(1, queueName, pstmt, dbType);
	    				pstmt.execute();
	    				rs = pstmt.getResultSet();
	    				if (rs.next()) {
	    					mqueueid = rs.getInt(1);
	    				}
	    				else
	    				{
	    					mainCode = WFSError.WFS_NOQ;
	    					subCode = 0;
	    					subject = WFSErrorMsg.getMessage(mainCode);
	    					descr = WFSErrorMsg.getMessage(subCode);
	    					errType = WFSError.WF_TMP;    					
	    				}
	    				if(rs != null){
	    					rs.close();
	    					rs = null;
	    				}
	    				if(pstmt != null){
	    					pstmt.close();
	    					pstmt = null;
	    				}	
            		}
            	}
            	else
            	{
					mainCode = WFSError.WF_QUEUENAME_CANNOT_BE_NULL;
					subCode = 0;
					subject = WFSErrorMsg.getMessage(mainCode);
					descr = WFSErrorMsg.getMessage(subCode);
					errType = WFSError.WF_TMP;    					
				}
            }
            if(mainCode == 0)
            {
			if (participant != null && participant.gettype() == 'U') {
                            scope = participant.getscope();
                            if(!scope.equalsIgnoreCase("ADMIN"))
                                locale = participant.getlocale();
				//WFS_8.0_061
				//pstmt = con.prepareStatement(" select Alias , VariableType " + (dataFlag == 'Y' ? ",ToReturn ,Param1 " : ", '' as ToReturn, '' as Param1 ") + (mqueueid == -1 ? ", Queueid " : ", " + mqueueid + " as Queueid ") + "from varaliastable, VarMappingTable where VarAliasTable.Param1 = VarMappingTable.SystemDefinedName and VarMappingTable.processDefId = (Select max(ProcessDefId) from ProcessDefTable) " + (mqueueid == -1 ? "" : (" and Queueid =  " + mqueueid)) + " order by varaliastable.id asc");
				//pstmt = con.prepareStatement(" select Alias , VariableType " + (dataFlag == 'Y' ? ",ToReturn ,Param1 " : ", '' as ToReturn, '' as Param1 ") + (mqueueid == -1 ? ", Queueid " : ", " + mqueueid + " as Queueid ") + "from varaliastable, VarMappingTable where VarAliasTable.Param1 = VarMappingTable.SystemDefinedName and VarMappingTable.processDefId = (Select max(ProcessDefId) from ProcessDefTable) " + (processDefId == 0 ? (mqueueid == -1 ? "" : (" and Queueid =  " + mqueueid)) + " and VarAliasTable.ProcessDefId = 0 ": (" and VarAliasTable.ProcessDefId = " + processDefId)) + " order by varaliastable.id asc");
                
			//	WFS_8.0_136
                /*Query on QueueDefTable to check whether the queue is a single Process Queue.*/
                            if((locale == null) || (locale != null && locale.equalsIgnoreCase("en-us")) || !enableMultiLingual.equalsIgnoreCase("Y"))
				pstmt = con.prepareStatement(" select Alias , Type1 " + (dataFlag == 'Y' ? ",ToReturn ,Param1 " : ", '' as ToReturn, '' as Param1 ") + (mqueueid == -1 ? ", Queueid " : ", " + mqueueid + " as Queueid ") + ", AliasRule, VariableId1, Id,DisplayFlag, SortFlag, SearchFlag from varaliastable " + WFSUtil.getTableLockHintStr(dbType) +"   where " + (mqueueid == -1 ? (processDefId == 0 ? "" : " VarAliasTable.ProcessDefId = " + processDefId) : (" Queueid =  " + mqueueid + " AND VarAliasTable.ProcessDefId = " + processDefId )) + " order by varaliastable.id asc");
                              else
                            {
                                pstmt = con.prepareStatement(" select A.*, EntityName from (select Alias , Type1 " + (dataFlag == 'Y' ? ",ToReturn ,Param1 " : ", '' as ToReturn, '' as Param1 ") + (mqueueid == -1 ? ", Queueid " : ", " + mqueueid + " as Queueid ") + ", AliasRule, VariableId1,Id,DisplayFlag, SortFlag, SearchFlag, ProcessDefId from varaliastable where " + (mqueueid == -1 ? (processDefId == 0 ? "" : " VarAliasTable.ProcessDefId = " + processDefId) : (" Queueid =  " + mqueueid + " AND VarAliasTable.ProcessDefId = " + processDefId )) + ")A LEFT OUTER JOIN WFMultiLingualTable B on A.VariableId1 = EntityId and A.QueueId = B.ParentId and A.ProcessDefId = B.ProcessDefId and B.EntityType = 5 and B.Locale = ? order by Id asc");
                                WFSUtil.DB_SetString(1, locale, pstmt, dbType);
                            }
				pstmt.execute();
				rs = pstmt.getResultSet();
				tempXml = new StringBuffer(200);
				tempXml.append("<VarList>\n");
				int rel = 0;
				String strtemp = "";
                                String entityName = "";
				while (rs.next()) {
					rel++;
					tempXml.append("<Var>\n");
					tempXml.append(gen.writeValueOf("AliasId", String.valueOf(rs.getInt("Id"))));
					tempXml.append(gen.writeValueOf("Alias", rs.getString(1)));
					if(isArtifactMigrationCase)
		            {
						tempXml.append(gen.writeValueOf("ToReturn", rs.getString(3)));
		            }
					else
					{
					tempXml.append(gen.writeValueOf("Return", rs.getString(3)));
					}
					String param1 = rs.getString(4);
					tempXml.append(gen.writeValueOf("Param1", param1));
					tempXml.append(gen.writeValueOf("QueueID", rs.getString(5)));
                    tempXml.append(gen.writeValueOf("OrderBy", rs.getString(7)));
                    tempXml.append(gen.writeValueOf("Type", rs.getString(2)));
					tempXml.append(gen.writeValueOf("AliasRule", rs.getString(6)));
                                        tempXml.append(gen.writeValueOf("VariableId", rs.getString(7)));
                                        tempXml.append(gen.writeValueOf("DisplayFlag", rs.getString(9)));
                                        tempXml.append(gen.writeValueOf("SortFlag", rs.getString(10)));
                                        tempXml.append(gen.writeValueOf("SearchFlag", rs.getString(11)));
                                                            entityName = "";
                                        if(locale != null && !locale.equalsIgnoreCase("en-us") && enableMultiLingual.equalsIgnoreCase("Y"))
                                        {
                                            entityName = rs.getString("EntityName");
                                            if(rs.wasNull())
                                                entityName = "";
                                        }
                                        tempXml.append(gen.writeValueOf("EntityName", entityName));
                    tempXml.append("</Var>\n");
				}
				tempXml.append("</VarList>\n");
				
				// changes start for Bug Id 47350
				String varType = "";
				int varId = 0;
				String varName = "";
				String displayName = "";
				String mobileDisplay = "";	
				StringBuffer varStr = new StringBuffer();
				if(getWorkListConfigFlag.equalsIgnoreCase("Y")){
					Statement stmtWListConfig = null;
					ResultSet rsWListConfig = null;
					stmtWListConfig =con.createStatement();
					rsWListConfig = stmtWListConfig.executeQuery("select   distinct  wlct.variableid,vmt.SystemDefinedName,wlct.aliasid,wlct.variabletype,vat.Alias as AliasName,wlct.ViewCategory, wlct.DisplayName,wlct.MobileDisplay from WFWorkListConfigTable wlct  " +  WFSUtil.getTableLockHintStr(dbType) + " LEFT OUTER JOIN  Varmappingtable vmt " +  WFSUtil.getTableLockHintStr(dbType) + " ON  wlct.variableid = vmt.VariableId LEFT OUTER JOIN VARALIASTABLE vat " +  WFSUtil.getTableLockHintStr(dbType) + "  ON wlct.queueId = vat.QueueId and wlct.aliasid = vat.Id WHERE wlct.queueid = " + mqueueid);

					varStr.append("\n<WorkListConfigFields>\n");
					while(rsWListConfig.next()){
						rel++;
						//varStr.append(gen.writeValue("ViewCategory", rsWListConfig.getString(6)));
						varType = rsWListConfig.getString(4);
						if(varType.equalsIgnoreCase("A")){
							varId = rsWListConfig.getInt(3);
							varName = rsWListConfig.getString(5);
						}else{
							varId = rsWListConfig.getInt(1);
							varName = rsWListConfig.getString(2);
						}
						displayName = rsWListConfig.getString("DisplayName");
						mobileDisplay = rsWListConfig.getString("MobileDisplay");
						if(varId == 31){
							varName = "ProcessInstanceId";
						}else if(varId == 32){
							varName = "CreatedByPersonalName";
						}else if(varId == 46){
							varName = "LockedByUserName";
						}
						varStr.append("<Variable>");
						varStr.append(gen.writeValueOf("VariableId", String.valueOf(varId)));
						varStr.append(gen.writeValueOf("VariableType", varType));
						varStr.append(gen.writeValueOf("VariableName", varName));
						varStr.append(gen.writeValueOf("DisplayName", displayName));			
						varStr.append(gen.writeValueOf("MobileDisplay", mobileDisplay));
						varStr.append("</Variable>");
					}
					varStr.append("\n</WorkListConfigFields>\n");
					tempXml.append(varStr.toString());
				}
				
				// Changes end for Bug 47350
				
				
				if (rel == 0) {
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
			
			if(rs != null){
				rs.close();
				rs = null;
			}
			if(pstmt != null){
				pstmt.close();
				pstmt = null;
			}	
			if (mainCode == 0 || mainCode == 18)  {
				outputXML = new StringBuffer(500);
				outputXML.append(gen.createOutputFile("WFGetVariableMapping"));
				outputXML.append("<Exception>\n<MainCode>"+mainCode+"</MainCode>\n</Exception>\n");
				outputXML.append(tempXml);
				pstmt = con.prepareStatement("Select LastModifiedOn from QueueDefTable " + WFSUtil.getTableLockHintStr(dbType) +"   where queueid = ? ");
				pstmt.setInt(1,mqueueid);
				rs = pstmt.executeQuery();
				if(rs.next())
						outputXML.append(gen.writeValueOf("LastModifiedOn", rs.getString("LastModifiedOn")));
				if(rs != null)
					rs.close();
				if(pstmt != null)
					pstmt.close();
				outputXML.append(gen.closeOutputFile("WFGetVariableMapping"));
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
		} catch (WFSException e) {
			mainCode = e.getMainErrorCode();
			subCode = e.getSubErrorCode();
			subject = e.getErrorMessage();
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
			try{
				if(rs!=null){
					rs.close();
					rs=null;
				}
			}catch(Exception e){
				WFSUtil.printErr(engine,"", e);
			}
			try {
				if (pstmt != null) {
					pstmt.close();
					pstmt = null;
				}
			} catch (Exception e) {
				WFSUtil.printErr(engine,"", e);
			}
			
		}
		if (mainCode != 0 && mainCode != 18) {
			//if(mainCode != 0 )
				throw new WFSException(mainCode, subCode, errType, subject, descr);
			}
		return outputXML.toString();
	}
	//----------------------------------------------------------------------------------------------------
	//	Function Name 				:	WFSetVariableMapping
	//	Date Written (DD/MM/YYYY)	:	16/05/2002
	//	Author						:	Prashant
	//	Input Parameters			:	Connection , XMLParser , XMLGenerator
	//	Output Parameters			:   none
	//	Return Values				:	String
	//	Description					:   Set Variable Mapping
	//----------------------------------------------------------------------------------------------------
    //  Change Description          : Changes for Code Optimization-Merging of WorkFlow 
    //								  tables to WFInstrumentTable and logging of Query
    //  Changed by					: Mohnish Chopra  
	public String WFSetVariableMapping(Connection con, XMLParser parser,
			XMLGenerator gen) throws JTSException, WFSException {
		StringBuffer outputXML = new StringBuffer("");
		Statement stmt = null;
        Statement stmt1 = null;
		ResultSet rs = null;
		int mainCode = 0;
		int subCode = 0;
		int orderby = 0;
		String subject = null;
		String descr = null;
		String errType = WFSError.WF_TMP;
		int mQueueId = 0;
		int processDefId = 0;
		XMLParser inputXML = new XMLParser();
		inputXML.setInputXML(parser.toString());
		int qProcessDefId = 0;
        String qProcessName = null;
        boolean bIsSingleProcessQueue = false;
        String engine = null;
		String option = parser.getValueOf("Option", "", false);
		PreparedStatement pstmt = null;
		boolean aliasDelete = true ;
		char char21 = 21;
		String string21 = "" + char21;
		try {
			int sessionID = parser.getIntOf("SessionId", 0, false);
			engine = parser.getValueOf("EngineName");
			processDefId = parser.getIntOf("ProcessDefId", 0, true);//WFS_8.0_061
			int dbType = ServerProperty.getReference().getDBType(engine);
			String actionComments = parser.getValueOf("ActionComments", "", true);
			boolean isArtifactMigrationCase = parser.getValueOf("ArtificationMigration", "N", true).equalsIgnoreCase("Y");
            HashMap qVarAliasMap = null;
            ArrayList failedList = new ArrayList();
            HashMap<String,String> aliasNameAndIDMap = new HashMap<String,String>();

			WFParticipant participant = WFSUtil.WFCheckSession(con, sessionID);
			if (participant != null && participant.gettype() == 'U') {
				int rel = parser.getNoOfFields("Var");
				int start = 0;
				int end = 0;

				int addCnt = 0;
				int deleteCnt = 0;
				StringBuffer tempAddList = new StringBuffer(100);
				StringBuffer tempDeleteList = new StringBuffer(100);
				ArrayList arrayList = new ArrayList();
				String qName = "";
				//	WFS_8.0_136
				//  Check whether the Queue is a Single Process Queue.
                
                //  Populate Map for all process variables.
                qVarAliasMap = populateAliasMap();
                
                //Code changes for Artifact Migration
                if(isArtifactMigrationCase)
                {
                	String queueName = parser.getValueOf("QueueName", "", true);
                	if(!"".equalsIgnoreCase(queueName.trim()))
                	{
                		//Code chnages for Bug 102449 - UT Defect : Handling for My Queue cases was missing for artifact migration of process alias mapping configuration.
                		if("My Queue".equalsIgnoreCase(queueName.trim()))
                		{
                			mQueueId = 0;
                			String processName = parser.getValueOf("ProcessName", "", true);
                			if(!"".equalsIgnoreCase(processName.trim()))
                			{
                				String exeStr = "select ProcessDefId from ProcessDefTable "+ WFSUtil.getTableLockHintStr(dbType) + " where ProcessName = ? order by VersionNo desc ";
    							pstmt = con.prepareStatement(exeStr);
    							WFSUtil.DB_SetString(1, processName, pstmt, dbType);
    							pstmt.execute();
    							rs = pstmt.getResultSet();
    							if (rs.next()) {
    								processDefId = rs.getInt(1);								
    							}
    							else
    							{
    								mainCode = WFSError.WF_INVALID_PROCESS_NAME;
    		    					subCode = 0;
    		    					subject = WFSErrorMsg.getMessage(mainCode);
    		    					descr = WFSErrorMsg.getMessage(subCode);
    		    					errType = WFSError.WF_TMP;   
    							}
                				
                			}
                		}
                		// Code changes for Bug-102449 ends here
                		else
                		{
	                		pstmt = con.prepareStatement("select queueid from queuedeftable "+ WFSUtil.getTableLockHintStr(dbType) +" where queuename=?");    				
	        				WFSUtil.DB_SetString(1, queueName, pstmt, dbType);
	        				pstmt.execute();
	        				rs = pstmt.getResultSet();
	        				if (rs.next()) {
	        					mQueueId = rs.getInt(1);
	        				}
	        				else
	        				{
	        					mainCode = WFSError.WFS_NOQ;
	        					subCode = 0;
	        					subject = WFSErrorMsg.getMessage(mainCode);
	        					descr = WFSErrorMsg.getMessage(subCode);
	        					errType = WFSError.WF_TMP;    					
	        				}
	        				if(rs != null){
	        					rs.close();
	        					rs = null;
	        				}
	        				if(pstmt != null){
	        					pstmt.close();
	        					pstmt = null;
	        				}	
                		}
                	}
                	else
                	{
    					mainCode = WFSError.WF_QUEUENAME_CANNOT_BE_NULL;
    					subCode = 0;
    					subject = WFSErrorMsg.getMessage(mainCode);
    					descr = WFSErrorMsg.getMessage(subCode);
    					errType = WFSError.WF_TMP;    					
    				}
                }
                else
                {

        			mQueueId = parser.getIntOf("QueueId", 0, false);
                }
                if(mainCode == 0)
		           {
						StringBuffer tempStr = new StringBuffer(parser.toString());
						if (mQueueId != 0) {
							stmt = con.createStatement();
							/* Bugzilla Id 54, LockHint for DB2, 18/08/2006 - Ruhi Hira */
							rs = stmt.executeQuery(" Select QueueName, ProcessName ,OrderBy from QueueDefTable  " + WFSUtil.getTableLockHintStr(dbType) + " where QueueId = " + mQueueId + WFSUtil.getQueryLockHintStr(dbType));
							if (rs.next()) {
								qName = rs.getString(1).trim();
		                        qProcessName = rs.getString("ProcessName");
								orderby = rs.getInt("OrderBy");
							} else {
								/*throw new WFSException(WFSError.WF_OPERATION_FAILED, WFSError.WFS_NOQ, WFSError.WF_TMP, WFSErrorMsg.getMessage(WFSError.WF_OPERATION_FAILED), WFSErrorMsg.getMessage(WFSError.WFS_NOQ));*/
								String strReturn = WFSUtil.generalError(option, engine, gen,
										WFSError.WF_OPERATION_FAILED, WFSError.WFS_NOQ,
										WFSError.WF_TMP, WFSErrorMsg.getMessage(WFSError.WF_OPERATION_FAILED),
										WFSErrorMsg.getMessage(WFSError.WFS_NOQ));
					   	             
					   	        return strReturn;
							}
							stmt.close();
							if (rs != null) {
								rs.close();
		                        rs = null;
							}
							/* Change done for Right Management */
							boolean rightsFlag = WFSUtil.checkRights(con, dbType, WFSConstant.CONST_OBJTYPE_QUEUE, mQueueId, sessionID, WFSConstant.CONST_QUEUE_MODIFYQPROP);
							if (!rightsFlag) {
								/*throw new WFSException(WFSError.WFS_NORIGHTS, WFSError.WM_SUCCESS, WFSError.WF_TMP, WFSErrorMsg.getMessage(WFSError.WFS_NORIGHTS), WFSErrorMsg.getMessage(WFSError.WM_SUCCESS));*/
								String strReturn = WFSUtil.generalError(option, engine, gen,
										WFSError.WFS_NORIGHTS,  WFSError.WM_SUCCESS,
										WFSError.WF_TMP, WFSErrorMsg.getMessage(WFSError.WFS_NORIGHTS),
										WFSErrorMsg.getMessage(WFSError.WM_SUCCESS));
					   	             
					   	        return strReturn;
							}
		                    //If MYqueue is not a process specific queue
		                    stmt1 = con.createStatement();
		                    rs = stmt1.executeQuery(" Select ProcessDefId from ProcessDefTable " + WFSUtil.getTableLockHintStr(dbType) +"   where ProcessName = " + TO_STRING(qProcessName, true, dbType)+" and processstate = "+TO_STRING("Enabled",true,dbType));
		                    if(rs != null && rs.next()){
		                        bIsSingleProcessQueue = true;
		                        qProcessDefId = rs.getInt("ProcessDefId");    
		                    }
		                    if(rs != null) {
		                        rs.close();
		                        rs = null;
		                    }
							
							//  Populate Map for all process variables.
		                    qVarAliasMap = populateAliasMap();
		
							//WFS_8.0_061
							tempAddList.append("<ProcessDefId>" + processDefId + "</ProcessDefId>");
							tempAddList.append("<QueueName>" + qName.trim() + "</QueueName>");
							tempDeleteList.append("<ProcessDefId>" + processDefId + "</ProcessDefId>");
							tempDeleteList.append("<QueueName>" + qName.trim() + "</QueueName>");
						} else {
							StringBuffer strBuff = new StringBuffer(100);
							strBuff = new StringBuffer("<?xml version=\"1.0\"?><NGOIsAdmin_Input><Option>NGOIsAdmin</Option><CabinetName>");
							strBuff.append(engine);
							strBuff.append("</CabinetName><UserDBId>");
							strBuff.append(sessionID);
							strBuff.append("</UserDBId></NGOIsAdmin_Input>");
							parser.setInputXML(strBuff.toString());
							parser.setInputXML(com.newgen.omni.jts.srvr.WFFindClass.getReference().execute("NGOIsAdmin", engine, con, parser, gen));
							String status = parser.getValueOf("Status");
							if (!status.equals("0")) {
		/*						throw new WFSException(WFSError.WFS_NORIGHTS, WFSError.WM_SUCCESS, WFSError.WF_TMP, WFSErrorMsg.getMessage(WFSError.WFS_NORIGHTS), WFSErrorMsg.getMessage(WFSError.WM_SUCCESS));
		*/						String strReturn = WFSUtil.generalError(option, engine, gen,
										WFSError.WFS_NORIGHTS,  WFSError.WM_SUCCESS,
										WFSError.WF_TMP, WFSErrorMsg.getMessage(WFSError.WFS_NORIGHTS),
										WFSErrorMsg.getMessage(WFSError.WM_SUCCESS));
					   	             
					   	        return strReturn;
							} else if (status.equals("0")) {
								if (parser.getValueOf("IsAdmin").equalsIgnoreCase("N")) {
		/*							throw new WFSException(WFSError.WFS_NORIGHTS, WFSError.WM_SUCCESS, WFSError.WF_TMP, WFSErrorMsg.getMessage(WFSError.WFS_NORIGHTS), WFSErrorMsg.getMessage(WFSError.WM_SUCCESS));
		*/							String strReturn = WFSUtil.generalError(option, engine, gen,
											WFSError.WFS_NORIGHTS,  WFSError.WM_SUCCESS,
											WFSError.WF_TMP, WFSErrorMsg.getMessage(WFSError.WFS_NORIGHTS),
											WFSErrorMsg.getMessage(WFSError.WM_SUCCESS));
						   	        return strReturn;
		
								}
							}
							qName = "My Queue";
							tempAddList.append("<ProcessDefId>" + processDefId + "</ProcessDefId>");//WFS_8.0_061
							tempAddList.append("<QueueName>" + qName.trim() + "</QueueName>");
							tempDeleteList.append("<ProcessDefId>" + processDefId + "</ProcessDefId>");
							tempDeleteList.append("<QueueName>" + qName.trim() + "</QueueName>");
						}
						parser.setInputXML(tempStr.toString());
						if (rel >= 0) {
							String retFlag = "";
							String alias = "";
							String param1 = "";
							String qparam1 = "";
							String sparam1 = "";
							String type1 = "";
							String aliasRule = "";
		                                        String displayFlag;
							String sortFlag;
							String searchFlag;
							StringBuffer dataStr = new StringBuffer(50);
							StringBuffer qdataStr = new StringBuffer(50);				
							int dataType = 10;
							if (rel >= 0) {
								stmt = con.createStatement();
								//WFS_8.0_061
								//rs = stmt.executeQuery("Select Alias FROM VarAliasTable where QueueId = " + mQueueId + (processDefId == 0 ? "" : (" AND ProcessDefId = " + processDefId )));
		
								rs = stmt.executeQuery("Select Alias,Id FROM VarAliasTable " + WFSUtil.getTableLockHintStr(dbType) + " where QueueId = " + mQueueId + " AND ProcessDefId = " + processDefId );
								while (rs != null && rs.next()) {
									arrayList.add(rs.getString("Alias"));
									aliasNameAndIDMap.put(rs.getString("Alias"),String.valueOf(rs.getInt("Id")));
								}
								if (rs != null) {
									rs.close();
									rs = null;
								}
		                        
								if (con.getAutoCommit()) {
									con.setAutoCommit(false);
								}
								//WFS_8.0_061
								//stmt.addBatch(" Delete from VarAliasTable where QueueID=" + mQueueId + (processDefId == 0 ? "" : (" AND ProcessDefId = " + processDefId )));
								stmt.addBatch(" Delete from VarAliasTable where QueueID=" + mQueueId + " AND ProcessDefId = " + processDefId );
		                        
								WFVariabledef attribs = null;
								LinkedHashMap cacheMap = new LinkedHashMap();
								WFFieldInfo fieldInfo = null;
		                        Object field = null;
		
								int variableId;
		                        int variableType;
								String type = null;
		                        boolean bIsExtVariableExists;
		
		                        if(bIsSingleProcessQueue){
								//Process Variant Support
		                            attribs = (WFVariabledef) CachedObjectCollection.getReference().getCacheObject(con, engine, qProcessDefId, WFSConstant.CACHE_CONST_Variable, "0" + string21 + "0").getData();
		                            cacheMap = attribs.getAttribMap();
		                        }
		                        String aliasList = null;
								String aliasNameList = null;	
								boolean isFirstIter = true ;
								String aliasId	= null;
								String aliasIdList = null;
								HashMap<String,String> varAliasMap1 = new HashMap(); 
								HashMap<String,String> varAliasMap2 = new HashMap();
		                        
		                        for (int i = 0; i < rel; i++) {
		                            bIsExtVariableExists = false;
		                            variableId = -1;
		                            variableType = -1;
									start = parser.getStartIndex("Var", end, 0);
									end = parser.getEndIndex("Var", start, 0);
		
									retFlag = parser.getValueOf("ToReturn", start, end).toUpperCase();
									alias = parser.getValueOf("Alias", start, end); //Bugzilla Bug 3752
									/**
									 * Client does not allow a quote character in alias name and
									 * a column will not have quote in its name.
									 * Hence no need to replace ' with ''. [As discussed with Ashish]
									 * 16/08/2006 - Ruhi Hira
									 */
									param1 = parser.getValueOf("Param1", start, end); //Bugzilla Bug 132
									sparam1 = (param1.trim().equalsIgnoreCase("CurrentDateTime") ? WFSUtil.getDate(dbType)
											: "WFInstrumentTable." + param1);          //sparam1 is only used for print
									qparam1 = (param1.trim().equalsIgnoreCase("CurrentDateTime") ? WFSUtil.getDate(dbType)
											: (param1.trim().equalsIgnoreCase("CreatedDateTime")
											? "WFInstrumentTable." + param1 : param1));
									type1 = parser.getValueOf("Type1", start, end).toUpperCase();
									dataType = parser.getIntOf("Param1Type", 10, true);
									aliasRule = parser.getValueOf("AliasRule", start, end);
									displayFlag = parser.getValueOf("DisplayFlag", start, end);
		                                                        displayFlag = displayFlag.equals("") ? "Y" : displayFlag;
		                                                        sortFlag = parser.getValueOf("SortFlag", start, end);
		                                                        sortFlag = sortFlag.equals("") ? "N" : sortFlag;
		                                                        searchFlag = parser.getValueOf("SearchFlag", start, end);
		                                                        searchFlag = searchFlag.equals("") ? "N" : searchFlag;
									aliasId =  parser.getValueOf("AliasId", start, end);
									if(aliasId != null && !aliasId.trim().equalsIgnoreCase("") && !isArtifactMigrationCase){
										if(isFirstIter){
											aliasIdList = aliasId;
											isFirstIter = false; 	
										}else{
											aliasIdList = aliasIdList + "," + aliasId ;									
										}	
									
									}
		                            //	WFS_8.0_136
		                            if(!qVarAliasMap.containsKey(param1.toUpperCase())){
		                                if(bIsSingleProcessQueue){
		                                    Iterator it = cacheMap.keySet().iterator();
		                                    while(it.hasNext()){
		                                        field = it.next();
		                                        fieldInfo = (WFFieldInfo)cacheMap.get(field);
		                                        if(fieldInfo.getExtObjId() == 1 && fieldInfo.getMappedColumn().equalsIgnoreCase(param1)){
		                                            break;
		                                        }
		                                        fieldInfo = null;
		                                    }
		                                    if(fieldInfo != null) {
		                                        variableId = fieldInfo.getVariableId() + 100;
		                                        if((variableId > 157) && (variableId < 10001))
		                                            bIsExtVariableExists = true;
		                                        variableType = fieldInfo.getWfType();
		                                    } else failedList.add(param1);
		                                } else {
		                                    //  Variable Info not found. No entry made in VarAliasTable in this case.
		                                    failedList.add(param1);
		                                }
		                            } else {
		                                Object[] obj = (Object[])qVarAliasMap.get(param1.toUpperCase());
		                                if(obj != null){
		                                    variableId = ((Integer)obj[0]).intValue();
		                                    variableType = ((Integer)obj[1]).intValue();
		                                }
		                            }
									if((orderby > 100) && (orderby == variableId)){
										aliasDelete = false ;
									}
		
		                            //  Restricting entry for External variables in case Queue is not Single Process Queue.
		//                            if(fieldInfo != null && !bIsSingleProcessQueue && fieldInfo.getExtObjId() != 0)
		//                                continue;
		
									if (!alias.equals("") && variableId != -1 && variableType != -1) {
		                                
		                                if (retFlag.startsWith("Y")) {
		                                    dataStr.append(",");
		                                    dataStr.append(sparam1);
		                                    if(!bIsExtVariableExists) {
		                                        qdataStr.append(",");
		                                        qdataStr.append(qparam1);
		                                    }
		                                }
										if (retFlag.startsWith("Y")) {
											dataStr.append(" as " + alias); //Bugzilla Bug 3752
		                                    if(!bIsExtVariableExists)
		                                        qdataStr.append(" as " + alias); //Bugzilla Bug 3752
										}
										// Tirupati Srivastava : changes made to make code compatible with postgreSQL
		                                /*stmt.addBatch(
										" Insert into VarAliasTable (QueueId,Alias,ToReturn,Param1) Values ( "
										+ mQueueId + "," + WFSConstant.WF_VARCHARPREFIX + alias + "' , " + WFSConstant.WF_VARCHARPREFIX + retFlag + "' , " + WFSConstant.WF_VARCHARPREFIX + param1 + "' )");*/
										//WFS_8.0_061
										stmt.addBatch(
												" Insert into VarAliasTable (QueueId,Alias,ToReturn,Param1,ProcessDefId,AliasRule, VariableId1, Type1, DisplayFlag, SortFlag, SearchFlag) Values ( " + mQueueId + "," + TO_STRING(alias, true, dbType) + " , " + TO_STRING(retFlag, true, dbType) + " , " + TO_STRING(param1, true, dbType) + "," + processDefId + " , " + TO_STRING(aliasRule, true, dbType) + ", " + variableId +", " + TO_STRING(String.valueOf(variableType), true, dbType) + ", " + TO_STRING(displayFlag, true, dbType) + ", " + TO_STRING(sortFlag, true, dbType) + ", " + TO_STRING(searchFlag, true, dbType) + ")");
										WFSUtil.printOut(engine,"Insert Query = = = =" + "Insert into VarAliasTable (QueueId,Alias,ToReturn,Param1,ProcessDefId,AliasRule, VariableId1, Type1) Values ( " + mQueueId + "," + TO_STRING(alias, true, dbType) + " , " + TO_STRING(retFlag, true, dbType) + " , " + TO_STRING(param1, true, dbType) + "," + processDefId + " , " + TO_STRING(aliasRule, true, dbType) + ", " + variableId +", " + TO_STRING(String.valueOf(variableType), true, dbType) + ")");
										if (addCnt++ == 0) {
											tempAddList.append("<AliasList>");
										}
										if (!arrayList.contains(alias)) {
											tempAddList.append("<AliasInfo>");
											tempAddList.append("<AliasName>" + alias + "</AliasName>");
											tempAddList.append("<MappedVariable>" + param1 + "</MappedVariable>");
											tempAddList.append("</AliasInfo>");
										} else {
											arrayList.remove(arrayList.indexOf(new String(alias)));
											if(isArtifactMigrationCase)
											{
												if(isFirstIter){
													aliasIdList = aliasNameAndIDMap.get(alias);
													isFirstIter = false; 	
												}else{
													aliasIdList = aliasIdList + "," + aliasNameAndIDMap.get(alias) ;									
												}	
											}
										}
									}
								}
		                        WFSUtil.printOut(engine,"[WFSetVariableMapping] dataStr : " + dataStr);
		                        WFSUtil.printOut(engine,"[WFSetVariableMapping] qdataStr : " + qdataStr);
								
								Statement stmtTemp = con.createStatement();
								stmtTemp.executeUpdate("Delete from WFWorkListConfigTable where QueueId = "+mQueueId+" and AliasId NOT IN (" + TO_SANITIZE_STRING(aliasIdList,true) + ") And VariableId Not In (29,31,32,37,38,46,48,49,52)");
								ResultSet rsTemp = stmtTemp.executeQuery("select Id, Param1 from VARALIASTABLE VAT, WFWorkListConfigTable WLCT where VAT.QueueId = WLCT.QueueId and VAT.id = WLCT.AliasId and WLCT.AliasId in (" + TO_SANITIZE_STRING(aliasIdList,true) + ")"); 
								isFirstIter = true;
								if(rsTemp != null){
									while(rsTemp.next()){
										varAliasMap1.put(rsTemp.getString("Id"),rsTemp.getString("Param1"));
										if(isFirstIter){
											aliasNameList = TO_STRING(rsTemp.getString("Param1"), true, dbType);
											isFirstIter = false;
										}else{
											aliasNameList = aliasNameList + "," + TO_STRING(rsTemp.getString("Param1"), true, dbType);
										}	
									}	
								}						
								
								int res[] = stmt.executeBatch();
								stmt.clearBatch();
								
								rsTemp = stmtTemp.executeQuery("Select Param1, Id from VARALIASTABLE where QueueID = " + mQueueId + " AND ProcessDefId = " + processDefId + " AND Param1 in (" + TO_SANITIZE_STRING(aliasNameList, true) + ")"); 
								
								if(rsTemp != null){
									while(rsTemp.next()){
										varAliasMap2.put(rsTemp.getString("Param1"),rsTemp.getString("Id"));
									}	
								}
								PreparedStatement tempPstmt = con.prepareStatement("Update WFWorkListConfigTable set AliasId = ? where AliasId = ? ");
								
								Set<String> keySet = varAliasMap1.keySet();
								Iterator<String> keySetIterator = keySet.iterator();
								String key = null;
								String value1 = null;
								String value2 = null;
								while (keySetIterator.hasNext()) {	
									key = keySetIterator.next();
									value1 = varAliasMap1.get(key);
									value2 = varAliasMap2.get(value1);
									tempPstmt.setInt(1,Integer.parseInt(value2));
									tempPstmt.setInt(2,Integer.parseInt(key));
									tempPstmt.executeUpdate();
								}
								if(tempPstmt != null){
									tempPstmt.close();
									tempPstmt = null;
								}	
								
								pstmt = con.prepareStatement("Update QueueDefTable set LastModifiedOn = " + WFSUtil.getDate(dbType) + "where  QueueId = ? ");
								pstmt.setInt(1,mQueueId);
								pstmt.execute();
								pstmt.close();
								if((orderby > 100) && aliasDelete){
									WFSUtil.printOut(engine,"Alias deleted ,so Order by made 10 in QueueDefTable");
									pstmt = con.prepareStatement("Update QueueDefTable set OrderBy = 10 where  QueueId = ? ");
									pstmt.setInt(1,mQueueId);
									pstmt.execute();
									pstmt.close();
								}
								if (!con.getAutoCommit()) {
									con.commit();
									con.setAutoCommit(true);
								}
		                        //if(!bIsSingleProcessQueue) {
		                            /** @todo With UR does not work with view - Ruhi Hira */
		                            /*String queryStmt = "Create view WFWorklistView_" + mQueueId + " AS Select Worklisttable.ProcessInstanceId,Worklisttable.ProcessInstanceId as ProcessInstanceName," + " Worklisttable.ProcessDefId,ProcessName,ActivityId,ActivityName,PriorityLevel,InstrumentStatus, " + " LockStatus,LockedByName,ValidTill,CreatedByName,ProcessInstanceTable.CreatedDateTime," + " Statename, CheckListCompleteFlag,EntryDateTime,LockedTime,IntroductionDateTime," + " IntroducedBy,AssignedUser, Worklisttable.WorkItemId,QueueName,AssignmentType," + " ProcessInstanceState,QueueType,Status,Q_QueueID, " + WFSUtil.DATEDIFF(WFSConstant.WFL_hh, "entrydatetime", "ExpectedWorkItemDelay",
		                                    dbType) + " as TurnaroundTime," + " ReferredByname, 0 as ReferTo, Q_UserID,FILTERVALUE,Q_StreamId,CollectFlag," + " QueueDataTable.ParentWorkItemId,ProcessedBy,LastProcessedBy,ProcessVersion," + "	 WORKITEMSTATE, PREVIOUSSTAGE, ExpectedWorkitemDelay,VAR_INT1,VAR_INT2,VAR_INT3,VAR_INT4,VAR_INT5,VAR_INT6,VAR_INT7,VAR_INT8,VAR_LONG1,VAR_LONG2,VAR_LONG3,VAR_LONG4  " // var_int1 to var_long4 added for Processmanager functionality for fetching workitems based on logged in user
		                                    + qdataStr.toString() + " from Worklisttable " + WFSUtil.getTableLockHintStr(dbType) + ",ProcessInstanceTable " + WFSUtil.getTableLockHintStr(dbType) + ",QueueDatatable " + WFSUtil.getTableLockHintStr(dbType) + " where " + " Worklisttable.ProcessInstanceid = QueueDatatable.ProcessInstanceId " + " and Worklisttable.Workitemid = QueueDatatable.Workitemid " + " and Worklisttable.ProcessInstanceid = ProcessInstanceTable.ProcessInstanceId " + (mQueueId == 0 ? "" : "AND Q_QueueId=" + mQueueId) + " union all Select Workinprocesstable.ProcessInstanceId,Workinprocesstable.ProcessInstanceId as ProcessInstanceName," + " Workinprocesstable.ProcessDefId,ProcessName,ActivityId,ActivityName,PriorityLevel,InstrumentStatus, " + " LockStatus,LockedByName,ValidTill,CreatedByName,ProcessInstanceTable.CreatedDateTime," + " Statename, CheckListCompleteFlag,EntryDateTime,LockedTime,IntroductionDateTime," + " IntroducedBy,AssignedUser, Workinprocesstable.WorkItemId,QueueName,AssignmentType," + " ProcessInstanceState,QueueType,Status,Q_QueueID, " + WFSUtil.DATEDIFF(WFSConstant.WFL_hh, "entrydatetime", "ExpectedWorkItemDelay",
		                                    dbType) + " as TurnaroundTime," + " ReferredByname, 0 as ReferTo, Q_UserID,FILTERVALUE,Q_StreamId,CollectFlag," + " QueueDataTable.ParentWorkItemId,ProcessedBy,LastProcessedBy,ProcessVersion," + " WORKITEMSTATE, PREVIOUSSTAGE, ExpectedWorkitemDelay,VAR_INT1,VAR_INT2,VAR_INT3,VAR_INT4,VAR_INT5,VAR_INT6,VAR_INT7,VAR_INT8,VAR_LONG1,VAR_LONG2,VAR_LONG3,VAR_LONG4  " // var_int1 to var_long4 added for Processmanager functionality for fetching workitems based on logged in user
		                                    + qdataStr.toString() + " from Workinprocesstable " + WFSUtil.getTableLockHintStr(dbType) + " ,ProcessInstanceTable " + WFSUtil.getTableLockHintStr(dbType) + " ,QueueDatatable " + WFSUtil.getTableLockHintStr(dbType) + " where " + " Workinprocesstable.ProcessInstanceid = QueueDatatable.ProcessInstanceId " + " and Workinprocesstable.Workitemid = QueueDatatable.Workitemid " + " and Workinprocesstable.ProcessInstanceid = ProcessInstanceTable.ProcessInstanceId " + (mQueueId == 0 ? "" : "AND Q_QueueId=" + mQueueId);
		*/
		                            // Changed By  : Ruhi Hira
		                            // Changed On  : 08/11/2004
		                            // Description : WfWorkListView_0 view definition changed, WorkListTable included (Bug # WFS_5_009).
		
		                            // Bug WFS_5.2.1_0007
		                            /* Bugzilla Bug 637, referTo returned in output, earlier it was null, 30/05/2007 - Ruhi Hira */
		                          /*  if (mQueueId == 0) {
		                                queryStmt = "Create view WFWorklistView_" + mQueueId + " AS Select Worklisttable.ProcessInstanceId,Worklisttable.ProcessInstanceId as ProcessInstanceName," + " Worklisttable.ProcessDefId,ProcessName,ActivityId,ActivityName,PriorityLevel,InstrumentStatus, " + " LockStatus,LockedByName,ValidTill,CreatedByName,ProcessInstanceTable.CreatedDateTime," + " Statename, CheckListCompleteFlag,EntryDateTime,LockedTime,IntroductionDateTime," + " IntroducedBy,AssignedUser, Worklisttable.WorkItemId,QueueName,AssignmentType," + " ProcessInstanceState,QueueType,Status,Q_QueueID, " + WFSUtil.DATEDIFF(WFSConstant.WFL_hh, "entrydatetime", "ExpectedWorkItemDelay",
		                                        dbType) + " as TurnaroundTime," + " ReferredByname, 0 as ReferTo, Q_UserID,FILTERVALUE,Q_StreamId,CollectFlag," + " QueueDataTable.ParentWorkItemId,ProcessedBy,LastProcessedBy,ProcessVersion," + " WORKITEMSTATE, PREVIOUSSTAGE, ExpectedWorkitemDelay ,VAR_INT1,VAR_INT2,VAR_INT3,VAR_INT4,VAR_INT5,VAR_INT6,VAR_INT7,VAR_INT8,VAR_LONG1,VAR_LONG2,VAR_LONG3,VAR_LONG4  " // var_int1 to var_long4 added for Processmanager functionality for fetching workitems based on logged in user
		                                        + qdataStr.toString() + " from Worklisttable " + WFSUtil.getTableLockHintStr(dbType) + " ,ProcessInstanceTable " + WFSUtil.getTableLockHintStr(dbType) + " ,QueueDatatable  " + WFSUtil.getTableLockHintStr(dbType) + " where " + " Worklisttable.ProcessInstanceid = QueueDatatable.ProcessInstanceId " + " and Worklisttable.Workitemid = QueueDatatable.Workitemid " + " and Worklisttable.ProcessInstanceid = ProcessInstanceTable.ProcessInstanceId " + " UNION ALL " + " Select PendingWorklisttable.ProcessInstanceId,PendingWorklisttable.ProcessInstanceId as ProcessInstanceName," + " PendingWorklisttable.ProcessDefId,ProcessName,ActivityId,ActivityName,PriorityLevel,InstrumentStatus, " + " LockStatus,LockedByName,ValidTill,CreatedByName,ProcessInstanceTable.CreatedDateTime," + " Statename, CheckListCompleteFlag,EntryDateTime,LockedTime,IntroductionDateTime," + " IntroducedBy,AssignedUser, PendingWorklisttable.WorkItemId,QueueName,AssignmentType," + " ProcessInstanceState,QueueType,Status,Q_QueueID, " + WFSUtil.DATEDIFF(WFSConstant.WFL_hh, "entrydatetime", "ExpectedWorkItemDelay",
		                                        dbType) + " as TurnaroundTime," + " ReferredByname, ReferredTo as ReferTo, Q_UserID,FILTERVALUE,Q_StreamId,CollectFlag," + " QueueDataTable.ParentWorkItemId,ProcessedBy,LastProcessedBy,ProcessVersion," + " WORKITEMSTATE, PREVIOUSSTAGE, ExpectedWorkitemDelay ,VAR_INT1,VAR_INT2,VAR_INT3,VAR_INT4,VAR_INT5,VAR_INT6,VAR_INT7,VAR_INT8,VAR_LONG1,VAR_LONG2,VAR_LONG3,VAR_LONG4  " // var_int1 to var_long4 added for Processmanager functionality for fetching workitems based on logged in user
		                                        + qdataStr.toString() + " from PendingWorklisttable " + WFSUtil.getTableLockHintStr(dbType) + " ,ProcessInstanceTable " + WFSUtil.getTableLockHintStr(dbType) + " ,QueueDatatable " + WFSUtil.getTableLockHintStr(dbType) + " where " + " PendingWorklisttable.ProcessInstanceid = QueueDatatable.ProcessInstanceId " + " and PendingWorklisttable.Workitemid = QueueDatatable.Workitemid " + " and PendingWorklisttable.ProcessInstanceid = ProcessInstanceTable.ProcessInstanceId " + " UNION ALL " + " Select WorkInProcessTable.ProcessInstanceId,WorkInProcessTable.ProcessInstanceId as ProcessInstanceName," + " WorkInProcessTable.ProcessDefId,ProcessName,ActivityId,ActivityName,PriorityLevel,InstrumentStatus, " + " LockStatus,LockedByName,ValidTill,CreatedByName,ProcessInstanceTable.CreatedDateTime," + " Statename, CheckListCompleteFlag,EntryDateTime,LockedTime,IntroductionDateTime," + " IntroducedBy,AssignedUser, WorkInProcessTable.WorkItemId,QueueName,AssignmentType," + " ProcessInstanceState,QueueType,Status,Q_QueueID, " + WFSUtil.DATEDIFF(WFSConstant.WFL_hh, "entrydatetime", "ExpectedWorkItemDelay",
		                                        dbType) + " as TurnaroundTime," + " ReferredByname, 0 as ReferTo, Q_UserID,FILTERVALUE,Q_StreamId,CollectFlag," + " QueueDataTable.ParentWorkItemId,ProcessedBy,LastProcessedBy,ProcessVersion," + " WORKITEMSTATE, PREVIOUSSTAGE, ExpectedWorkitemDelay ,VAR_INT1,VAR_INT2,VAR_INT3,VAR_INT4,VAR_INT5,VAR_INT6,VAR_INT7,VAR_INT8,VAR_LONG1,VAR_LONG2,VAR_LONG3,VAR_LONG4  " + qdataStr.toString() + " from WorkInProcessTable " + WFSUtil.getTableLockHintStr(dbType) + " ,ProcessInstanceTable " + WFSUtil.getTableLockHintStr(dbType) + " ,QueueDatatable " + WFSUtil.getTableLockHintStr(dbType) + " where " + " WorkInProcessTable.ProcessInstanceid = QueueDatatable.ProcessInstanceId " + " and WorkInProcessTable.Workitemid = QueueDatatable.Workitemid " + " and WorkInProcessTable.ProcessInstanceid = ProcessInstanceTable.ProcessInstanceId ";
		
		                            }*/
		/*                            String dataStmt = "Create view WFWorkinProcessView_" + mQueueId + " AS Select WorkinProcesstable.ProcessInstanceId,WorkinProcesstable.ProcessInstanceId as WorkItemName," + " WorkinProcesstable.ProcessdefId,ProcessName,ActivityId,ActivityName,PriorityLevel,InstrumentStatus," + " LockStatus,LockedByName,Validtill,CreatedByName,ProcessInstanceTable.CreatedDateTime,Statename," + " CheckListCompleteFlag,EntryDateTime,LockedTime,IntroductionDateTime,IntroducedBy, AssignedUser, " + " WorkinProcesstable.WorkItemId,QueueName,AssignmentType,ProcessInstanceState,QueueType,Status,Q_QueueId," + WFSUtil.DATEDIFF(WFSConstant.WFL_hh, "entrydatetime", "ExpectedWorkItemDelay", dbType) + " as TurnaroundTime," + "ReferredByname,0 as ReferTo, guid,Q_userId " + qdataStr.toString() + " from Workinprocesstable " + WFSUtil.getTableLockHintStr(dbType) + " ,ProcessInstanceTable " + WFSUtil.getTableLockHintStr(dbType) + " ,QueueDatatable " + WFSUtil.getTableLockHintStr(dbType) + " where " + " Workinprocesstable.ProcessInstanceid = QueueDatatable.ProcessInstanceId " + " and Workinprocesstable.Workitemid = QueueDatatable.Workitemid " + " and Workinprocesstable.ProcessInstanceid = ProcessInstanceTable.ProcessInstanceId " + (mQueueId == 0 ? "" : "AND Q_QueueId=" + mQueueId);
		*/
									// CODE OPTIMIZATION - REMOVAL OF VIEWS 
		                           /* String srchStmt = " Create view WFSearchView_" + mQueueId + " as Select queueview.ProcessInstanceId,queueview.QueueName," +
		                            		"queueview.ProcessName," + " ProcessVersion,queueview.ActivityName, statename, queueview.CheckListCompleteFlag," +
		                            		" " + " queueview.AssignedUser,queueview.EntryDateTime,queueview.ValidTill,queueview.workitemid," 
		                            		+ " queueview.prioritylevel, queueview.parentworkitemid,queueview.processdefid," + " queueview.ActivityId," +
		                            		"queueview.InstrumentStatus,queueview.LockStatus,queueview.LockedByName," + 
		                            		" queueview.CreatedByName,queueview.CreatedDateTime, queueview.LockedTime," + 
		                            		" queueview.IntroductionDateTime,queueview.IntroducedBy ,queueview.assignmenttype," + 
		                            		" queueview.processinstancestate, queueview.queuetype , Status ,Q_QueueId , " 
		                            		+ WFSUtil.DATEDIFF(WFSConstant.WFL_hh, "entrydatetime", "ExpectedWorkItemDelayTime", dbType) 
		                            		+ " as TurnaroundTime, ReferredBy ," + " ReferredTo , ExpectedProcessDelayTime , ExpectedWorkItemDelayTime, " +
		                            		" ProcessedBy ,Q_UserID , " + " WorkItemState " + (mQueueId == 0 ? "" : qdataStr.toString()) 
		                            		+ " from " + (mQueueId == 0 ? "queueview " : "queuetable queueview ") 
		                            		+ WFSUtil.getTableLockHintStr(dbType) + " where  queueview.referredTo is null " 
		                            		+ (mQueueId == 0 ? "" : " AND Q_QueueId = " + mQueueId);
		/*                            try {
		                                stmt.execute(" Create view WFWorklistview_" + mQueueId + "_old as Select * from WFWorklistview_" + mQueueId + WFSUtil.getTableLockHintStr(dbType));
		                            } catch (SQLException ex) {
		                                WFSUtil.printErr(engine,"", ex);
		                            }
		  */                        /*  try {
		                                stmt.execute(" Create view WFSearchView_" + mQueueId + "_old as Select * from WFSearchView_" + mQueueId + WFSUtil.getTableLockHintStr(dbType));
		                            } catch (SQLException ex) {
		                                WFSUtil.printErr(engine,"", ex);
		                            }*/
		                         /*   try {
		                                stmt.execute(" Create view WFWorkinProcessView_" + mQueueId + "_old as Select * from WFWorkinProcessView_" + mQueueId + WFSUtil.getTableLockHintStr(dbType));
		                            } catch (SQLException ex) {
		                                WFSUtil.printErr(engine,"", ex);
		                            }*/
		                            /** @todo Algorithm is not correct for recovering old view in case of failure - Ruhi Hira */
		                          /*  try {
		                                stmt.execute(" Drop view WFWorkListview_" + mQueueId);
		                            } catch (SQLException ex) {
		                                WFSUtil.printErr(engine,"", ex);
		                            }*/
									//Code Optimization - View Usages to be removed
		                            /*try {
		                                stmt.execute(" Drop view WFSearchView_" + mQueueId);
		                            } catch (SQLException ex) {
		                                WFSUtil.printErr(engine,"", ex);
		                            }
		                            /*try {
		                                stmt.execute(" Drop view WFWorkinProcessView_" + mQueueId);
		                            } catch (SQLException ex) {
		                                WFSUtil.printErr(engine,"", ex);
		                            }
		*/
		                            try {
		                             /*   stmt.execute(queryStmt);*/
		                               // stmt.execute(srchStmt);
		                                /*stmt.execute(dataStmt); */
		                                if (!con.getAutoCommit()) {
		                                    con.commit();
		                                    con.setAutoCommit(true);
		                                }
		                            } catch (SQLException e) {
		                                WFSUtil.printErr(engine,"", e);
		                                if (!con.getAutoCommit()) {
		                                    con.rollback();
		                                    con.setAutoCommit(true);
		                                }
		                             /*   try {
		                                    stmt.execute(" Create view WFWorklistview_" + mQueueId + " as Select * from WFWorklistview_" + mQueueId + "_old " + WFSUtil.getTableLockHintStr(dbType));
		                                } catch (SQLException ex) {
		                                    WFSUtil.printErr(engine,"", ex);
		                                }*/
										//Code Optimization - View Usages to be removed
		                                /*try {
		                                    stmt.execute(" Create view WFSearchView_" + mQueueId + " as Select * from WFSearchView_" + mQueueId + "_old " + WFSUtil.getTableLockHintStr(dbType));
		                                } catch (SQLException ex) {
		                                    WFSUtil.printErr(engine,"", ex);
		                                }
		                            /*    try {
		                                    stmt.execute(" Create view WFWorkinProcessView_" + mQueueId + " as Select * from WFWorkinProcessView_" + mQueueId + "_old" + WFSUtil.getTableLockHintStr(dbType));
		                                } catch (SQLException ex) {
		                                    WFSUtil.printErr(engine,"", ex);
		                                }*/
		                            }
		
		                          /*  try {
		                                stmt.execute(" Drop view WFWorklistview_" + mQueueId + "_old ");
		                            } catch (SQLException ex) {
		                                WFSUtil.printErr(engine,"", ex);
		                            }*/
									//Code Optimization - View Usages to be removed
		                            /*try {
		                                stmt.execute(" Drop view WFSearchView_" + mQueueId + "_old ");
		                            } catch (SQLException ex) {
		                                WFSUtil.printErr(engine,"", ex);
		                            }
		                            /*try {
		                                stmt.execute(" Drop view WFWorkinProcessView_" + mQueueId + "_old");
		                            } catch (SQLException ex) {
		                                WFSUtil.printErr(engine,"", ex);
		                            }
		                            stmt.close();*/
		                        //}
								if (addCnt > 0) {
									tempAddList.append("</AliasList>");
		//						WFSUtil.printOut(engine,"COMING IN ALIAS addCnt BEFOE" );
									WFSUtil.genAdminLog(engine, con, WFSConstant.WFL_AddAliasToQueue, 0, mQueueId, qName.trim(), participant.getid(), participant.getname(), 0, tempAddList.toString(), null, null);
		
		//						WFSUtil.printOut(engine,"COMING IN ALIAS addCnt AFTEr" );
								}
								if (res[0] > 0) {
									tempDeleteList.append("<AliasCount>" + res[0] + "</AliasCount>");
									tempDeleteList.append("<AliasList>");
									for (int counter = 0; counter < arrayList.size(); counter++) {
										tempDeleteList.append("<AliasInfo>");
										tempDeleteList.append("<AliasName>" + arrayList.get(counter) + "</AliasName>");
										tempDeleteList.append("</AliasInfo>");
									}
									tempDeleteList.append("</AliasList>");
									WFSUtil.genAdminLog(engine, con, WFSConstant.WFL_DeleteAliasFromQueue, 0, mQueueId, qName.trim(), participant.getid(), participant.getname(), 0, tempDeleteList.toString(), null, null);
								}
								if (!con.getAutoCommit()) {
									con.commit();
									con.setAutoCommit(true);
								}
							}
						}
						WFTMSUtil.genRequestId(engine, con, WFSConstant.WFL_AddAliasToQueue, "", "Q", processDefId, actionComments, inputXML, participant,mQueueId);
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
				outputXML.append(gen.createOutputFile("WFSetVariableMapping"));
				outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
				outputXML.append("<ProcessDefId>" + processDefId + "</ProcessDefId>\n");//WFS_8.0_061
                outputXML.append("<FailedList>");
                Iterator it1 = failedList.iterator();
                while(it1.hasNext()){
                    outputXML.append(gen.writeValueOf("Variable", (String)it1.next()));
                    outputXML.append(gen.writeValueOf("Reason", WFSErrorMsg.getMessage(WFSError.WF_VARIABLE_INFO_NOT_FOUND)));
                }
                outputXML.append("</FailedList>");
				outputXML.append(gen.closeOutputFile("WFSetVariableMapping"));
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
			subject = e.getErrorMessage();
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
				if (!con.getAutoCommit()) {
					con.rollback();
					con.setAutoCommit(true);
				}

				if (stmt != null) {
					//Code Optimization - View Usages to be removed
					/*try {
						stmt.execute(" Drop view WFWorklistview_" + mQueueId + "_old ");
					} catch (SQLException ex) {
					}
					try {
						stmt.execute(" Drop view WFSearchView_" + mQueueId + "_old ");
					} catch (SQLException ex) {
					}
				/*	try {
						stmt.execute(" Drop view WFWorkinProcessView_" + mQueueId + "_old");
					} catch (SQLException ex) {
					}
*/
					stmt.close();
					stmt = null;
				}
				if(stmt1 != null) {
					stmt1.close();
					stmt1 = null;
				}
			} catch (Exception e) {
			}
			
		}
		if (mainCode != 0) {
			/*				throw new WFSException(mainCode, subCode, errType, subject, descr);
			*/
							String strReturn = WFSUtil.generalError(option, engine, gen,
				   	                   mainCode, subCode,
				   	                   errType, subject,
				   	                    descr);
				   	             
				   	        return strReturn;	
							}
		return outputXML.toString();
	}

	//----------------------------------------------------------------------------------------------------
	//	Function Name 				    :	WFGetNextUnlockedWorkitem
	//	Date Written (DD/MM/YYYY)	:	16/05/2002
	//	Author						        :	Prashant
	//	Input Parameters		    	:	Connection , XMLParser , XMLGenerator
	//	Output Parameters			    : none
	//	Return Values				      :	String
	//	Description					      : Get Next Unlocked Workitem and lock it.
	//----------------------------------------------------------------------------------------------------
	//	Changed By						:	Mohnish Chopra
	//	Change Description				: 	Changed for Code Optimization
	//	Reason							:	This API is removed.
/*	public String WFGetNextUnlockedWorkitemold(Connection con, XMLParser parser, // NOT USED ANYMORE
			XMLGenerator gen) throws JTSException, WFSException {
		StringBuffer outputXML = null;
		Statement stmt = null;
		ResultSet rs = null;
		int mainCode = 0;
		int subCode = 0;
		String subject = null;
		String descr = null;
		String errType = WFSError.WF_TMP;
		StringBuffer tempXml = null;

		try {
			int sessionID = parser.getIntOf("SessionId", 0, false);
			String engine = parser.getValueOf("EngineName");
			int dbType = ServerProperty.getReference().getDBType(engine);

			WFParticipant participant = WMUser.WFCheckUpdateSession(con, sessionID, dbType);
			if (participant != null && participant.gettype() == 'U') {
				int userid = participant.getid();
				String username = participant.getname();

				int i = 0;
				int lastWIValue = parser.getIntOf("LastWorkItem", 0, true);
				String lastValue = parser.getValueOf("LastValue", "", true);
				String lastPIValue = parser.getValueOf("LastProcessInstance", "", true);
				char sortOrder = parser.getCharOf("SortOrder", 'A', true);
				int orderBy = parser.getIntOf("OrderBy", 18, true);
				char dataflag = parser.getCharOf("DataFlag", 'N', true);
				int queueid = parser.getIntOf("QueueId", 0, true);
				String qStr = " ( Q_Userid = " + userid + " OR Q_QueueId in (Select QueueID from QUserGroupView where UserId = " + userid + ")) ";
				int filterOpt = 0;
				String filterStr = WFSUtil.getFilter(parser, con, dbType);
				String filterValue = "";

				String sortField = " PriorityLevel ";
				String tempStr = "";
				char QType = '\0';
				String queueName = "";

				stmt = con.createStatement();

				if (queueid > 0) {
					rs = stmt.executeQuery("Select QueueId from UserQueuetable " + WFSUtil.getTableLockHintStr(dbType) + " where UserId = " + userid + WFSUtil.getQueryLockHintStr(dbType));
					if (rs.next()) {
						qStr = " Q_QueueId = " + queueid;
					} else {
						mainCode = WFSError.WM_NO_MORE_DATA;
						subCode = WFSError.WFS_NOQ;
						subject = WFSErrorMsg.getMessage(mainCode);
						descr = WFSErrorMsg.getMessage(subCode);
						errType = WFSError.WF_TMP;
					}
					if (rs != null) {
						rs.close();
					}

					rs = stmt.executeQuery("Select Queuename,QueueType,FilterOption from QueueDeftable " + WFSUtil.getTableLockHintStr(dbType) + " where QueueID = " + queueid + WFSUtil.getQueryLockHintStr(dbType));
					if (rs.next()) {
						queueName = rs.getString(1);
						tempStr = rs.getString(2);
						QType = rs.wasNull() ? '\0' : tempStr.charAt(0);
						orderBy = (QType == 'F') ? 18 : orderBy;
						sortOrder = (QType == 'F') ? 'A' : sortOrder;
						filterOpt = rs.getInt(3);
						if (filterOpt == WFSConstant.WF_EQUAL || filterOpt == WFSConstant.WF_NOTEQ) {
							filterValue = "and filterValue " + (filterOpt == WFSConstant.WF_NOTEQ ? " != "
									: " = ") + userid;
						}
					}
					if (rs != null) {
						rs.close();
					}
				}

				if (mainCode == 0) {
					String sortStr = (sortOrder == 'A') ? " ASC " : " DESC ";
					String op = (sortOrder == 'A') ? " > " : " < ";
					String orderbyStr = "";
					String porderbyStr = " ORDER BY PriorityLevel DESC ";

					switch (orderBy) {
						case 1:
							lastValue = lastValue;
							sortField = " PriorityLevel ";
							break;
						case 2:
							lastValue = lastValue.equals("") ? "" : TO_STRING(lastValue, true, dbType);
							sortField = " ProcessInstanceId ";
							break;
						case 3:
							lastValue = lastValue.equals("") ? "" : TO_STRING(lastValue, true, dbType);
							sortField = " ActivityName ";
							break;
						case 4:
							lastValue = lastValue.equals("") ? "" : TO_STRING(lastValue, true, dbType);
							sortField = " LockedByName ";
							break;
						case 5:
							lastValue = lastValue.equals("") ? "" : TO_STRING(lastValue, true, dbType);
							sortField = " IntroducedBy ";
							break;
						case 6:
							lastValue = lastValue.equals("") ? "" : TO_STRING(lastValue, true, dbType);
							sortField = " InstrumentStatus ";
							break;
						case 7:
							lastValue = lastValue.equals("") ? "" : TO_STRING(lastValue, true, dbType);
							sortField = " CheckListCompleteFlag  ";
							break;
						case 8:
							lastValue = lastValue.equals("") ? "" : TO_STRING(lastValue, true, dbType);
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
							lastValue = lastValue.equals("") ? "" : TO_STRING(lastValue, true, dbType);
							sortField = " Status ";
							break;
						case 18:
							lastValue = lastValue.equals("") ? "" : WFSUtil.TO_DATE(lastValue, true, dbType);
							sortField = " CreatedDateTime ";
							break;
						default:
							if (orderBy > 100) {
								rs = stmt.executeQuery("Select Alias from VarAliasTable order by id asc");
								int k = 0;
								while (rs.next()) {
									k++;
									if (k == orderBy - 100) {
										sortField = "\"" + rs.getString(1).trim() + "\"";
									}
								}
								if (rs != null) {
									rs.close();
								}
								if (k < orderBy - 100) {
									throw new WFSException(WFSError.WF_OTHER, WFSError.WFS_ILP, WFSError.WF_TMP,
											WFSErrorMsg.getMessage(WFSError.WF_OTHER),
											WFSErrorMsg.getMessage(WFSError.WFS_ILP));
								} else {
									lastValue = lastValue.equals("") ? "" : TO_STRING(lastValue, true, dbType);
								}
							} else {
								throw new WFSException(WFSError.WF_OTHER, WFSError.WFS_ILP, WFSError.WF_TMP,
										WFSErrorMsg.getMessage(WFSError.WF_OTHER),
										WFSErrorMsg.getMessage(WFSError.WFS_ILP));
							}
					}

					if (orderBy == 1) {
						sortStr = " ORDER BY PriorityLevel " + sortStr + ", ProcessInstanceID " + sortStr + ", WorkItemID " + sortStr;
					} else if (orderBy == 2) {
						sortStr = " ORDER BY ProcessInstanceID " + sortStr + ", WorkItemID " + sortStr;
					} else {
						sortStr = " ORDER BY " + sortField + sortStr + ", ProcessInstanceID " + sortStr + ", WorkItemID " + sortStr;
					}

					if (!lastPIValue.equals("") && QType != 'F') {
						if (!lastValue.equals("")) {
							orderbyStr = " AND ( ( " + sortField + " = " + lastValue + " AND ProcessInstanceID = " + TO_STRING(lastPIValue, true, dbType) + " AND WorkItemID " + op + " " + lastWIValue + " ) OR  ( " + sortField + " = " + lastValue + " AND ProcessInstanceID " + op + TO_STRING(lastPIValue, true, dbType) + "  ) OR ( " + sortField + op + lastValue + " ) ) ";
						} else {
							if (sortOrder == 'A') {
								orderbyStr = " AND ( ( " + sortField + " is null AND ProcessInstanceID = " + TO_STRING(lastPIValue, true,
										dbType) + " AND WorkItemID " + op + lastWIValue + " ) OR  ( " + sortField + " is null AND ProcessInstanceID " + op + TO_STRING(lastPIValue, true, dbType) + "  ) OR ( " + sortField + " is not null ) ) ";
							} else {
								orderbyStr = " AND ( ( " + sortField + " is null AND ProcessInstanceID = " + TO_STRING(lastPIValue, true, dbType) + " AND WorkItemID " + op + lastWIValue + " ) OR  ( " + sortField + " is null AND ProcessInstanceID " + op + TO_STRING(lastPIValue, true, dbType) + " )) ";
							}
						}
					}
					if (!lastPIValue.equals("")) {
						orderbyStr += " AND NOT( ProcessInstanceID = " + TO_STRING(lastPIValue, true, dbType) + " AND WorkItemID = " + lastWIValue + " ) " + sortStr;
					} else {
						orderbyStr += sortStr;
					}

					String pqueryStmt = "";
					String queryStmt = "";
					if (QType == 'F') {
						pqueryStmt = qStr + filterValue + " and PriorityLevel > 1 " + porderbyStr;

						queryStmt = qStr + filterValue + orderbyStr;
					} else {
						queryStmt = qStr + filterValue + filterStr + orderbyStr;
					}
					int res = 0;
					long time = System.currentTimeMillis();
					boolean datafetched = false;
					if (QType == 'F') {
    				    res = stmt.executeUpdate(
								"Insert into WorkinProcesstable (ProcessInstanceId,WorkItemId,ProcessName," + "ProcessVersion,ProcessDefID,LastProcessedBy,ProcessedBy,ActivityName,ActivityId,EntryDateTime," + "ParentWorkItemId,AssignmentType,CollectFlag,PriorityLevel,ValidTill,Q_StreamId,Q_QueueId,Q_UserId," + "AssignedUser,FilterValue,CreatedDateTime,WorkItemState,Statename,ExpectedWorkitemDelay,PreviousStage," + "LockedByName,LockStatus,LockedTime,Queuename,Queuetype,guid, ProcessVariantId) " + "Select " + WFSUtil.getFetchPrefixStr(dbType, 1) + " ProcessInstanceId,WorkItemId,ProcessName,ProcessVersion,ProcessDefID,LastProcessedBy,ProcessedBy," + "ActivityName,ActivityId,EntryDateTime,ParentWorkItemId,AssignmentType,CollectFlag,PriorityLevel,ValidTill," + "Q_StreamId,Q_QueueId," + userid + "," + TO_STRING(username, false, dbType) + ",FilterValue,CreatedDateTime,2," + TO_STRING(WFSConstant.WF_RUNNING, true, dbType) + "," //Statename,"
								+ "ExpectedWorkitemDelay,PreviousStage," + TO_STRING(username, true, dbType) + ",'Y'," + WFSUtil.getDate(dbType) + ",Queuename,Queuetype, " + time + ", ProcessVariantId from Worklisttable " + WFSUtil.getTableLockHintStr(dbType) + " where 1 = 1 " + " AND " + pqueryStmt + WFSUtil.getFetchSuffixStr(dbType, 1, WFSConstant.QUERY_STR_AND) + WFSUtil.getQueryLockHintStr(dbType));

						if (res <= 0) {
							res = stmt.executeUpdate(
									"Insert into WorkinProcesstable (ProcessInstanceId,WorkItemId,ProcessName," + "ProcessVersion,ProcessDefID,LastProcessedBy,ProcessedBy,ActivityName,ActivityId,EntryDateTime," + "ParentWorkItemId,AssignmentType,CollectFlag,PriorityLevel,ValidTill,Q_StreamId,Q_QueueId,Q_UserId," + "AssignedUser,FilterValue,CreatedDateTime,WorkItemState,Statename,ExpectedWorkitemDelay,PreviousStage," + "LockedByName,LockStatus,LockedTime,Queuename,Queuetype,guid, ProcessVariantId) " + "Select " + WFSUtil.getFetchPrefixStr(dbType, 1) + " ProcessInstanceId,WorkItemId,ProcessName,ProcessVersion,ProcessDefID,LastProcessedBy,ProcessedBy," + "ActivityName,ActivityId,EntryDateTime,ParentWorkItemId,AssignmentType,CollectFlag,PriorityLevel,ValidTill," + "Q_StreamId,Q_QueueId," + userid + "," + TO_STRING(username, true, dbType) + ",FilterValue,CreatedDateTime,2," + TO_STRING(WFSConstant.WF_RUNNING, true, dbType) + "," //Statename,"
									+ "ExpectedWorkitemDelay,PreviousStage," + TO_STRING(username, true, dbType) + "," + TO_STRING("Y", true, dbType) + "," + WFSUtil.getDate(dbType) + ",Queuename,Queuetype, " + time + ", ProcessVariantId from Worklisttable " + WFSUtil.getTableLockHintStr(dbType) + " where 1 = 1 " + " AND " + queryStmt + WFSUtil.getFetchSuffixStr(dbType, 1, WFSConstant.QUERY_STR_AND) + WFSUtil.getQueryLockHintStr(dbType));
							if (res > 0) {
								datafetched = true;
							}
						} else {
							datafetched = true;
						}
					} else {
						res = stmt.executeUpdate("Insert into WorkinProcesstable (ProcessInstanceId,WorkItemId,ProcessName," + "ProcessVersion,ProcessDefID,LastProcessedBy,ProcessedBy,ActivityName,ActivityId,EntryDateTime," + "ParentWorkItemId,AssignmentType,CollectFlag,PriorityLevel,ValidTill,Q_StreamId,Q_QueueId,Q_UserId," + "AssignedUser,FilterValue,CreatedDateTime,WorkItemState,Statename,ExpectedWorkitemDelay,PreviousStage," + "LockedByName,LockStatus,LockedTime,Queuename,Queuetype,guid, ProcessVariantId) " + "Select " + WFSUtil.getFetchPrefixStr(dbType, 1) + " ProcessInstanceId,WorkItemId,ProcessName,ProcessVersion,ProcessDefID,LastProcessedBy,ProcessedBy," + "ActivityName,ActivityId,EntryDateTime,ParentWorkItemId,AssignmentType,CollectFlag,PriorityLevel,ValidTill," + "Q_StreamId,Q_QueueId," + userid + "," + TO_STRING(username, true, dbType) + " ,FilterValue,CreatedDateTime,2," + TO_STRING(WFSConstant.WF_RUNNING, true, dbType) + " , " //Statename,"
								+ "ExpectedWorkitemDelay,PreviousStage," + TO_STRING(username, true, dbType) + "," + TO_STRING("Y", true, dbType) + "," + WFSUtil.getDate(dbType) + ",Queuename,Queuetype, " + time + ", ProcessVariantId from Worklisttable " + WFSUtil.getTableLockHintStr(dbType) + " where 1 = 1" + " AND " + queryStmt + WFSUtil.getFetchSuffixStr(dbType, 1, WFSConstant.QUERY_STR_AND) + WFSUtil.getQueryLockHintStr(dbType));
						if (res > 0) {
							datafetched = true;
						}
					}

					if (datafetched) {
						rs = stmt.executeQuery("Select * from WFWorkinProcessView_" + queueid + "  " + WFSUtil.getTableLockHintStr(dbType) + " where guid = " + time + " and Q_userId=" + userid + WFSUtil.getQueryLockHintStr(dbType));
						ResultSetMetaData rsmd = null;
						if (dataflag == 'Y') {
							rsmd = rs.getMetaData();
						}
						int nRSize = dataflag != 'Y' ? 0 : rsmd.getColumnCount();
						if (rs.next()) {
							mainCode = 0;
							tempXml = new StringBuffer(500);
							tempXml.append("<Instrument>\n");

							String procInstID = rs.getString(1);
							tempXml.append(gen.writeValueOf("ProcessInstanceId", procInstID));
							tempXml.append(gen.writeValueOf("WorkItemName", rs.getString(2)));
							int procDefID = rs.getInt(3);
							tempXml.append(gen.writeValueOf("RouteId", String.valueOf(procDefID)));
							tempXml.append(gen.writeValueOf("RouteName", rs.getString(4)));
							int activityId = rs.getInt(5);
							tempXml.append(gen.writeValueOf("WorkStageId", String.valueOf(activityId)));
							String actName = rs.getString(6);
							tempXml.append(gen.writeValueOf("ActivityName", actName));
							tempXml.append(gen.writeValueOf("PriorityLevel", rs.getString(7)));
							tempXml.append(gen.writeValueOf("InstrumentStatus", rs.getString(8)));
							tempXml.append(gen.writeValueOf("LockStatus", rs.getString(9)));
							tempXml.append(gen.writeValueOf("LockedByUserName", rs.getString(10)));
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
							int wrkitemId = rs.getInt(21);
							tempXml.append(gen.writeValueOf("WorkItemId", String.valueOf(wrkitemId)));
							String qName = rs.getString(22);
							tempXml.append(gen.writeValueOf("QueueName", qName));
							tempXml.append(gen.writeValueOf("AssignmentType", rs.getString(23)));
							tempXml.append(gen.writeValueOf("ProcessInstanceState", rs.getString(24)));
							String qType = rs.getString(25);
							tempXml.append(gen.writeValueOf("QueueType", qType));
							tempXml.append(gen.writeValueOf("Status", rs.getString(26)));
							int qId = rs.getInt(27);
							tempXml.append(gen.writeValueOf("QueueId", String.valueOf(qId)));
							tempXml.append(gen.writeValueOf("Turnaroundtime", rs.getString(28)));
							tempXml.append(gen.writeValueOf("Referredby", rs.getString(29)));
							tempXml.append(gen.writeValueOf("Referredto", rs.getString(30)));
							tempXml.append("<Data>\n");

							for (int k = 0; k < nRSize - 32; k++) {
								tempXml.append("<QueueData>\n");
								tempXml.append(gen.writeValueOf("Name", rsmd.getColumnLabel(33 + k)));
								tempXml.append(gen.writeValueOf("Value", rs.getString(33 + k)));
								tempXml.append("\n</QueueData>\n");
							}
							tempXml.append("</Data>\n");
							tempXml.append("</Instrument>\n");
							if (rs != null) {
								rs.close();
							}
							stmt.close();
							WFSUtil.generateLog(engine, con, WFSConstant.WFL_WorkItemLock, procInstID, wrkitemId, procDefID,
									activityId, actName, qId, userid, username, 0, qName, null, null, null, null);

						}
					} else {
						stmt.close();
						mainCode = WFSError.WM_NO_MORE_DATA;
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
				outputXML.append(gen.createOutputFile("WFGetNextUnlockedWorkitem"));
				outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
				outputXML.append(tempXml);
				outputXML.append(gen.closeOutputFile("WFGetNextUnlockedWorkitem"));
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
			if (mainCode != 0) {
				throw new WFSException(mainCode, subCode, errType, subject, descr);
			}
		}
		return outputXML.toString();
	}*/

//----------------------------------------------------------------------------------------------------
//	Function Name 				:	WFLinkWorkitem
//	Date Written (DD/MM/YYYY)	:	16/05/2002
//	Author						:	Prashant
//	Input Parameters			:	Connection , XMLParser , XMLGenerator
//	Output Parameters			:   none
//	Return Values				:	String
//	Description					:   Link Workitem for a ProcessInstance
//----------------------------------------------------------------------------------------------------
// Change Summary *
//----------------------------------------------------------------------------
// Changed By						: Ashish Mangla
// Reason / Cause (Bug No if Any)	: WSE_5.0.1_beta_16
// Change Description				: Do not convert processinstanceid to upper case
//----------------------------------------------------------------------------
public String WFLinkWorkitem(Connection con, XMLParser parser, XMLGenerator gen) throws JTSException, WFSException {
	StringBuffer outputXML = new StringBuffer("");
        PreparedStatement pstmt = null;
        PreparedStatement pstmt_1 = null;
        PreparedStatement pstmt_2 = null;
        ResultSet rs = null;
        int mainCode = 0;
        int subCode = 0;
        String subject = null;
        String descr = null;
        String errType = WFSError.WF_TMP;
        String engine = parser.getValueOf("EngineName");
		int taskId=0;
        try {
            /**
             * 04/01/2008, Bugzilla Bug 3227, OmniServiceFlag considered in
             * SetAttribute and sessionId made non mandatory in LinkWorkitem. -
             * Ruhi Hira
             */
            int sessionID = parser.getIntOf("SessionId", 0, true);
            int dbType = ServerProperty.getReference().getDBType(engine);
            char oper = parser.getCharOf("Operation", 'A', true);
            StringBuffer failedList = new StringBuffer();
            /* 05/09/2007, SrNo-10, Synchronous routing of workitems. - Ruhi Hira */
            char omniServiceFlag = parser.getCharOf("OmniService", 'N', true);
            boolean updateQueueData = parser.getValueOf("UpdateQueueData", "N", true).equalsIgnoreCase("Y");
            String query = null;
			taskId=parser.getIntOf("TaskId", 0, true);
            ArrayList parameters = new ArrayList();
            boolean debugFlag = parser.getValueOf("DebugFlag", "N", true).equalsIgnoreCase("Y");
            WFParticipant participant = null;
            if (omniServiceFlag == 'Y') {
                participant = new WFParticipant(0, "INTERNAL_ROUTING_SERVER", 'P', "SERVER", Locale.getDefault().toString());
            } else {
                participant = WFSUtil.WFCheckSession(con, sessionID);
            }
            if (participant != null && (participant.gettype() == 'U' || (participant.gettype() == 'P' && taskId>0))) {
                        //if(participant.gettype()=='U'){
                //updateQueueData = false;
                //}
                int userID ;
                String username ;
                               
                if(taskId>0){
                userID = participant.gettype() == 'P' ? 0 : participant.getid();
				username = participant.gettype() == 'P' ? "System" : participant.getname();
                }
                else{
                	username = participant.getname();
                    userID = participant.getid();
                }
                int noOfLinks = parser.getNoOfFields("LinkedProcessInstanceID");

                String ppinstId = parser.getValueOf("ProcessInstanceID", "", false);
                int wrkItemID = parser.getIntOf("WorkItemID", 0, false);
                String lpinstId = parser.getFirstValueOf("LinkedProcessInstanceID");
                        //----------------------------------------------------------------------------
                // Changed By	                        : Varun Bhansaly
                // Changed On                           : 16/01/2007
                // Reason                        	: Bugzilla Id 54
                // Change Description			: Provide Dirty Read Support for DB2 Database
                //----------------------------------------------------------------------------

                query = "Select ProcessDefId , ActivityID , ActivityName from WFInstrumentTable " + WFSUtil.getTableLockHintStr(dbType) + " where ProcessInstanceId = ? and WorkItemID = ? " + WFSUtil.getQueryLockHintStr(dbType) + "UNION ALL Select ProcessDefId , ActivityID , ActivityName from QueueHistoryTable " + WFSUtil.getTableLockHintStr(dbType) + " where ProcessInstanceId = ? and WorkItemID = ? " + WFSUtil.getQueryLockHintStr(dbType);
                pstmt = con.prepareStatement(query);

                pstmt_2 = con.prepareStatement("Select URN from WFInstrumentTable " + WFSUtil.getTableLockHintStr(dbType) + " where ProcessInstanceId = ? "
                        + " UNION ALL Select URN from QueueHistoryTable " + WFSUtil.getTableLockHintStr(dbType) + " where ProcessInstanceId = ? " + WFSUtil.getQueryLockHintStr(dbType));

                WFSUtil.DB_SetString(1, ppinstId, pstmt, dbType);
                pstmt.setInt(2, wrkItemID);
                WFSUtil.DB_SetString(3, ppinstId, pstmt, dbType);
                pstmt.setInt(4, wrkItemID);
                parameters.add(ppinstId);
                parameters.add(wrkItemID);
                parameters.add(ppinstId);
                parameters.add(wrkItemID);
                rs = WFSUtil.jdbcExecuteQuery(ppinstId, sessionID, userID, query, pstmt, parameters, debugFlag, engine);
                parameters.clear();
                //rs = pstmt.getResultSet();
                if (rs != null && rs.next()) {
                    int procDefID = rs.getInt(1);
                    int actID = rs.getInt(2);
                    String actName = rs.getString(3);
                    rs.close();
                    rs = null;
                    if (con.getAutoCommit()) {
                        con.setAutoCommit(false);
                    }

                    while (noOfLinks-- > 0) {
                        WFSUtil.DB_SetString(1, lpinstId, pstmt_2, dbType); //Bugzilla Bug 789
                        WFSUtil.DB_SetString(2, lpinstId, pstmt_2, dbType); //pstmt.setInt(2, wrkItemID);
                        pstmt_2.execute(); //pstmt.execute();
                        rs = pstmt_2.getResultSet(); //rs = pstmt.getResultSet();
                        if (rs.next()) {
                           // rs.getInt(1);
                                        //rs.getInt(2);
                            //rs.getString(3);
                        	String urn=rs.getString(1);
                            int res = 0;
                            switch (oper) {
                                case 'D':
                                    pstmt_1 = con.prepareStatement(" Delete from WFLinksTable  where ChildProcessInstanceID in ( ?, ? ) and ParentProcessInstanceId in ( ?, ? ) ");
                                    //Ashish removed conversion to upper case for WSE_5.0.1_beta_16
                                    WFSUtil.DB_SetString(1, lpinstId, pstmt_1, dbType);
                                    WFSUtil.DB_SetString(2, ppinstId, pstmt_1, dbType);
                                    WFSUtil.DB_SetString(3, lpinstId, pstmt_1, dbType);
                                    WFSUtil.DB_SetString(4, ppinstId, pstmt_1, dbType);
                                    res = pstmt_1.executeUpdate();
                                    if (res > 0) {
                                        WFSUtil.generateLog(engine, con, WFSConstant.WFL_dlink, ppinstId, 0, procDefID, actID, actName, 0, userID, username, 0, lpinstId, null, null, null, null);
                                        WFSUtil.generateLog(engine, con, WFSConstant.WFL_dlink, lpinstId, 0, procDefID, actID, actName, 0, userID, username, 0, ppinstId, null, null, null, null);
                                       
                                    } else {
                                        failedList.append("<FailedProcessInstance>");
                                        failedList.append(gen.writeValueOf("FailedProcessInstanceId", lpinstId));
                                        failedList.append(gen.writeValueOf("FailedProcessInstanceId", lpinstId));
                                        failedList.append(gen.writeValueOf("FailedURN", urn));
                                        failedList.append(gen.writeValueOf("FailedDescription", WFSErrorMsg.getMessage(WFSError.WFS_NO_LNK)));
                                        failedList.append("</FailedProcessInstance>");
                                    }
                                    break;
                                case 'A':
                                    if (ppinstId.equalsIgnoreCase(lpinstId)) {
                                        break;
                                    }
                                    try {
                                        /**
                                         * Prepared Statement changes for DB2
                                         * support. 14/08/2006 Bugzilla Id 61, -
                                         * Ruhi Hira
                                         */
                                        pstmt_1 = con.prepareStatement(" Insert into WFLinkstable Select " + TO_STRING(ppinstId, true, dbType) + " , " + TO_STRING(lpinstId, true, dbType) +",'N','N',"+taskId+" "+ WFSUtil.getDummyTableName(dbType) + " where not exists ( Select * from WFLinkstable where ChildProcessInstanceID in ( ?, ? ) and ParentProcessInstanceId in ( ?, ? )) ");
                                        WFSUtil.DB_SetString(1, lpinstId, pstmt_1, dbType);
                                        WFSUtil.DB_SetString(2, ppinstId, pstmt_1, dbType);
                                        WFSUtil.DB_SetString(3, lpinstId, pstmt_1, dbType);
                                        WFSUtil.DB_SetString(4, ppinstId, pstmt_1, dbType);
                                        res = pstmt_1.executeUpdate();
                                        pstmt_1.close();
                                        pstmt_1 = null;
                                        if (res <= 0) {
                                            failedList.append("<FailedProcessInstance>");
                                            failedList.append(gen.writeValueOf("FailedProcessInstanceId", lpinstId));
                                            failedList.append(gen.writeValueOf("FailedURN", urn));
                                            failedList.append(gen.writeValueOf("FailedDescription", WFSErrorMsg.getMessage(WFSError.WFS_ALR_LNK)));
                                            failedList.append("</FailedProcessInstance>");
                                        } else if (updateQueueData) {
                                            pstmt_1 = con.prepareStatement("Update WFInstrumentTable Set ChildProcessInstanceID = ?,"
                                                    + " ChildWorkItemID = 1 where ProcessInstanceId = ? and Workitemid = ?");
                                            WFSUtil.DB_SetString(1, lpinstId, pstmt_1, dbType);
                                            WFSUtil.DB_SetString(2, ppinstId, pstmt_1, dbType);
                                            pstmt_1.setInt(3, wrkItemID);
                                            res = pstmt_1.executeUpdate();
                                            if (res <= 0) {
                                                failedList.append("<FailedProcessInstance>");
                                                failedList.append(gen.writeValueOf("FailedProcessInstanceId", lpinstId));
                                                failedList.append(gen.writeValueOf("FailedURN", urn));
                                                failedList.append(gen.writeValueOf("FailedDescription", WFSErrorMsg.getMessage(WFSError.WM_INVALID_PROCESS_INSTANCE)));
                                                failedList.append("</FailedProcessInstance>");
                                            }
                                            if (pstmt_1 != null) {
                                                pstmt_1.close();
                                                pstmt_1 = null;
                                            }
                                        }
                                        if (res > 0) {
                                            WFSUtil.generateLog(engine, con, WFSConstant.WFL_link, ppinstId, 0, procDefID, actID, actName, 0, userID, username, 0, lpinstId, null, null, null, null);
                                            WFSUtil.generateLog(engine, con, WFSConstant.WFL_link, lpinstId, 0, procDefID, actID, actName, 0, userID, username, 0, ppinstId, null, null, null, null);                                        
                                        }

                                    } catch (SQLException e) {
                                        throw e;
                                    }
                                    break;
                            }
                        } else {
                            failedList.append("<FailedProcessInstance>");
                            failedList.append(gen.writeValueOf("FailedProcessInstanceId", lpinstId));
                            failedList.append(gen.writeValueOf("FailedDescription", WFSErrorMsg.getMessage(WFSError.WM_INVALID_WORK_ITEM)));
                            failedList.append("</FailedProcessInstance>");
                        }
                        if (rs != null) {
                            rs.close();
                            rs = null;
                        }
                        lpinstId = parser.getNextValueOf("LinkedProcessInstanceID");
                    }
                } else {
                    mainCode = WFSError.WM_INVALID_PROCESS_INSTANCE;
                    subCode = 0;
                    subject = WFSErrorMsg.getMessage(mainCode);
                    descr = WFSErrorMsg.getMessage(subCode);
                    errType = WFSError.WF_TMP;
                }
                if (rs != null) {
                    rs.close();
                    rs = null;
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
                if (failedList.length() != 0) {
                    outputXML.append(gen.writeError("WFLinkWorkItem", WFSError.WFS_NA_WI_LNK, 0,
                            WFSError.WF_TMP, WFSErrorMsg.getMessage(WFSError.WFS_NA_WI_LNK), null));
                    outputXML.delete(outputXML.indexOf("</" + "WFLinkWorkItem" + "_Output>"), outputXML.length()); //Bugzilla Bug 259
                    outputXML.append("<FailedList>");
                    outputXML.append(failedList.toString());
                    outputXML.append("</FailedList>");
                } else {
                    outputXML.append(gen.createOutputFile("WFLinkWorkitem"));
                    outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
                }
                outputXML.append(gen.closeOutputFile("WFLinkWorkitem"));
                if (!con.getAutoCommit()) {
                    con.commit();
                    con.setAutoCommit(true);
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
            subject = e.getErrorMessage();
            errType = e.getTypeOfError();
            descr = e.getErrorDescription();
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
            /* AutoCommit made true in finally. - Ruhi */
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
            try {
                if (pstmt_1 != null) {
                    pstmt_1.close();
                    pstmt_1 = null;
                }
            } catch (Exception e) {
            }
            try {
                if (pstmt_2 != null) {
                    pstmt_2.close();
                    pstmt_2 = null;
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
            
        }
        if (mainCode != 0) {
            throw new WFSException(mainCode, subCode, errType, subject, descr);
        }
        return outputXML.toString();
    }

	//----------------------------------------------------------------------------------------------------
	//	Function Name 				:	WFGetLinkededWorkitems
	//	Date Written (DD/MM/YYYY)	:	16/05/2002
	//	Author						:	Prashant
	//	Input Parameters			:	Connection , XMLParser , XMLGenerator
	//	Output Parameters			:   none
	//	Return Values				:	String
	//	Description					:   Get all related Workitems for a ProcessInstance
	//----------------------------------------------------------------------------------------------------
	public String WFGetLinkedWorkitems(Connection con, XMLParser parser,
			XMLGenerator gen) throws JTSException, WFSException {
		StringBuffer outputXML = new StringBuffer("");
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int mainCode = 0;
		int subCode = 0;
		String subject = null;
		String descr = null;
		String errType = WFSError.WF_TMP;
		String engine ="";
		String query = null; 
		StringBuffer linkedWorkitems2 = new StringBuffer();
		StringBuffer archivedWorkitems2 = new StringBuffer();
		PreparedStatement pstmt1= null;
		ResultSet rs1=null;
		boolean archiveFlag=false;
		String isArchived="N";
		String targetCabinetName=null;
		boolean targetConnectionRequired=false;
		Connection tarConn =null;
		ArrayList<ResultSet> resultSetsList=new ArrayList<ResultSet>();
		char char21 = 21;
		String string21 = "" + char21;
		try {
			int sessionID = parser.getIntOf("SessionId", 0, false);
			engine = parser.getValueOf("EngineName");
			int dbType = ServerProperty.getReference().getDBType(engine);
			StringBuffer tempXml = null;
			WFParticipant participant = WFSUtil.WFCheckSession(con, sessionID);
			if (participant != null && participant.gettype() == 'U') {
				int userID = participant.getid();
				String username = participant.getname();

				int noOfRectoFetch = parser.getIntOf("NoOfRecordsToFetch",
						ServerProperty.getReference().getBatchSize(), true);

				int lastWIValue = parser.getIntOf("LastWorkItem", 0, true);
				String lastValue = parser.getValueOf("LastValue", "", true);
				String lastPIValue = parser.getValueOf("LastProcessInstance", "", true);
				char sortOrder = parser.getCharOf("SortOrder", 'D', true);
				int orderBy = parser.getIntOf("OrderBy", 1, true);

				String pinstId = parser.getValueOf("ProcessInstanceID", "", false);

				String sortStr = (sortOrder == 'A') ? " ASC " : " DESC ";
				String op = (sortOrder == 'A') ? " > " : " < ";
				String sortField = " PriorityLevel ";
				String orderbyStr = "";
				boolean debug = parser.getValueOf("DebugFlag", "N", true).equalsIgnoreCase("Y");
				if (noOfRectoFetch > ServerProperty.getReference().getBatchSize() || noOfRectoFetch <= 0) {
					noOfRectoFetch = ServerProperty.getReference().getBatchSize();
				}
				switch (orderBy) {
					case 1:
						//lastValue = lastValue;
						sortField = " PriorityLevel ";
						break;
					case 2:
						lastValue = lastValue.equals("") ? "" : TO_STRING(lastValue, true, dbType);
						sortField = " ProcessInstanceId ";
						break;
					case 3:
						lastValue = lastValue.equals("") ? "" : TO_STRING(lastValue, true, dbType);
						sortField = " ActivityName ";
						break;
					case 4:
						lastValue = lastValue.equals("") ? "" : TO_STRING(lastValue, true, dbType);
						sortField = " LockedByName ";
						break;
					case 5:
						lastValue = lastValue.equals("") ? "" : TO_STRING(lastValue, true, dbType);
						sortField = " IntroducedBy ";
						break;
					case 6:
						lastValue = lastValue.equals("") ? "" : TO_STRING(lastValue, true, dbType);
						sortField = " InstrumentStatus ";
						break;
					case 7:
						lastValue = lastValue.equals("") ? "" : TO_STRING(lastValue, true, dbType);
						sortField = " CheckListCompleteFlag  ";
						break;
					case 8:
						lastValue = lastValue.equals("") ? "" : TO_STRING(lastValue, true, dbType);
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
						lastValue = lastValue.equals("") ? "" : TO_STRING(lastValue, true, dbType);
						sortField = " Status ";
						break;
					case 18:
						lastValue = lastValue.equals("") ? "" : WFSUtil.TO_DATE(lastValue, true, dbType);
						sortField = " createdDateTime ";
						break;
					default:
						throw new WFSException(WFSError.WF_OTHER, WFSError.WFS_ILP, WFSError.WF_TMP,
								WFSErrorMsg.getMessage(WFSError.WF_OTHER), WFSErrorMsg.getMessage(WFSError.WFS_ILP));
				}
				if (orderBy == 2) {
					orderbyStr = " ORDER BY ProcessInstanceID " + sortStr + ", WorkItemID " + sortStr;
				} else {
					orderbyStr = " ORDER BY " + sortField + sortStr + ", ProcessInstanceID " + sortStr + ", WorkItemID " + sortStr;

				} // Tirupati Srivastava : changes made to make code compatible with postgreSQL
				if (!lastPIValue.equals("")) {
					if (!lastValue.equals("")) {
						orderbyStr = " AND ( ( " + sortField + " = " + lastValue + " AND ProcessInstanceID = " + TO_STRING(lastPIValue, true, dbType) + " AND WorkItemID " + op + " " + lastWIValue + " ) OR  ( " + sortField + " = " + lastValue + " AND ProcessInstanceID " + op + TO_STRING(lastPIValue, true, dbType) + " ) OR ( " + sortField + op + lastValue + " ) " + (sortOrder == 'A' ? (dbType == JTSConstant.JTS_MSSQL ? "" : " OR (" + sortField + " is null )")
								: (dbType == JTSConstant.JTS_MSSQL ? " OR (" + sortField + " is null )" : "")) + " ) " + orderbyStr; //Bugzilla Bug 472
					} else {
						orderbyStr = " AND ( ( " + sortField + " is null AND ProcessInstanceID = " + TO_STRING(lastPIValue, true, dbType) + " AND WorkItemID " + op + lastWIValue + " ) OR  ( " + sortField + " is null AND ProcessInstanceID " + op + TO_STRING(lastPIValue, true, dbType) + " )" + (sortOrder == 'A' ? (dbType == JTSConstant.JTS_MSSQL ? " OR (" + sortField + " is not null )" : "")
								: (dbType == JTSConstant.JTS_MSSQL ? "" : " OR (" + sortField + " is not null )")) + ") " + orderbyStr; //Bugzilla Bug 472

					}
				}
				pstmt = con.prepareStatement("Select ChildProcessInstanceID,IsChildArchived from WFLinksTable " + WFSUtil.getTableLockHintStr(dbType) + " where " 
								+ " ParentProcessInstanceID = ? UNION " 
								+ " Select ParentProcessInstanceID,IsParentArchived from WFLinksTable " + WFSUtil.getTableLockHintStr(dbType) + " where " 
								+ " ChildProcessInstanceID = ?  ");
				WFSUtil.DB_SetString(1, pinstId, pstmt, dbType);
				WFSUtil.DB_SetString(2, pinstId, pstmt, dbType);
				pstmt.execute();
				rs = pstmt.getResultSet();
				StringBuffer linkedWorkitems = new StringBuffer();
				StringBuffer archivedWorkitems = new StringBuffer();
				String linkedItem = null;
				while (rs != null && rs.next()){
					linkedItem = rs.getString(1);
					 isArchived=rs.getString(2);
					if(isArchived.equalsIgnoreCase("Y")){
						targetConnectionRequired=true;
						archivedWorkitems.append(TO_STRING(linkedItem, true, dbType)).append(",");
						
					}
					else{
					linkedWorkitems.append(TO_STRING(linkedItem, true, dbType)).append(",");
					}
				}
				if (rs != null){
					rs.close();
					rs = null;
				}
				pstmt.close();
				pstmt = null;
				linkedWorkitems2.append(linkedWorkitems);
				archivedWorkitems2.append(archivedWorkitems);
				if ((linkedWorkitems.length()+ archivedWorkitems.length())<= 0 ){ //Some workitems are linked. Query can be execued on Queuview
					throw new WFSException(WFSError.WM_NO_MORE_DATA, WFSError.WFS_NO_LNK, WFSError.WF_TMP,
							WFSErrorMsg.getMessage(WFSError.WM_NO_MORE_DATA),
							WFSErrorMsg.getMessage(WFSError.WFS_NO_LNK)); // None Found
				}
				//----------------------------------------------------------------------------
				// Changed By	                        : Varun Bhansaly
				// Changed On                           : 16/01/2007
				// Reason                        	: Bugzilla Id 54
				// Change Description			: Provide Dirty Read Support for DB2 Database
				//----------------------------------------------------------------------------

				/*pstmt = con.prepareStatement(" Select * from (Select " + WFSUtil.getFetchPrefixStr(dbType, (noOfRectoFetch + 1)) + " ProcessInstanceId,ProcessInstanceName,ProcessDefId,ProcessName,ActivityId,ActivityName," + " PriorityLevel,InstrumentStatus,LockStatus,LockedByName,ValidTill,CreatedByName,CreatedDateTime," + " Statename,CheckListCompleteFlag,EntryDateTime,LockedTime,IntroductionDateTime,IntroducedBy," + " AssignedUser,WorkItemId,QueueName,AssignmentType,ProcessInstanceState,QueueType,Status,Q_Queueid," + WFSUtil.DATEDIFF(WFSConstant.WFL_hh, "entrydatetime", "ExpectedWorkItemDelayTime",
						dbType) + " as TurnareoundTime,ReferredByName,ReferredToName from queueview " + WFSUtil.getTableLockHintStr(dbType) + " where  ProcessInstanceId in " 
						+ "( "
						+ linkedWorkitems.deleteCharAt(linkedWorkitems.length()-1)
						+ ") " 
						+ orderbyStr + " ) queueview " + WFSUtil.getFetchSuffixStr(dbType, (noOfRectoFetch + 1), WFSConstant.QUERY_STR_WHERE) + WFSUtil.getQueryLockHintStr(dbType));*/
						
				
				if(targetConnectionRequired){
					//UT Defect 62583:  Changes for Postgres in WFGetLinkedWorkItem
					if(dbType==JTSConstant.JTS_POSTGRES){
					query = " (Select * from (Select " + WFSUtil.getFetchPrefixStr(dbType, (noOfRectoFetch + 1)) + " ProcessInstanceId,ProcessInstanceId as ProcessInstanceName,ProcessDefId,ProcessName,ActivityId,ActivityName," + " PriorityLevel,InstrumentStatus,LockStatus,LockedByName,ValidTill,CreatedByName,CreatedDateTime," + " Statename,CheckListCompleteFlag,EntryDateTime,LockedTime,IntroductionDateTime,IntroducedBy," + " AssignedUser,WorkItemId,QueueName,AssignmentType,ProcessInstanceState,QueueType,Status,Q_Queueid," + WFSUtil.DATEDIFF(WFSConstant.WFL_hh, "entrydatetime", "ExpectedWorkItemDelay",
								dbType) + " as TurnaroundTime,ReferredByName,ReferredToName from WFINSTRUMENTTABLE " + WFSUtil.getTableLockHintStr(dbType) + " where  ProcessInstanceId in " 
								+ "( "+ archivedWorkitems.deleteCharAt(archivedWorkitems.length()-1)
								+ ") " + orderbyStr + " ) queueview " + WFSUtil.getFetchSuffixStr(dbType, (noOfRectoFetch + 1), WFSConstant.QUERY_STR_WHERE) + WFSUtil.getQueryLockHintStr(dbType)
								+" ) UNION ALL ( Select * from (Select " + WFSUtil.getFetchPrefixStr(dbType, (noOfRectoFetch + 1)) + " ProcessInstanceId,ProcessInstanceName,ProcessDefId,ProcessName,ActivityId,ActivityName," + " PriorityLevel,InstrumentStatus,LockStatus,LockedByName,ValidTill,CreatedByName,CreatedDateTime," + " Statename,CheckListCompleteFlag,EntryDateTime,LockedTime,IntroductionDateTime,IntroducedBy," + " AssignedUser,WorkItemId,QueueName,AssignmentType,ProcessInstanceState,QueueType,Status,Q_Queueid," + WFSUtil.DATEDIFF(WFSConstant.WFL_hh, "entrydatetime", "ExpectedWorkItemDelayTime",
								dbType) + " as TurnaroundTime,ReferredByName,ReferredToName from QUEUEHISTORYTABLE " + WFSUtil.getTableLockHintStr(dbType) + " where  ProcessInstanceId in " 
								+ "( "+ archivedWorkitems2.deleteCharAt(archivedWorkitems2.length()-1)+ ") " 
								+ orderbyStr + " ) queueview " + WFSUtil.getFetchSuffixStr(dbType, (noOfRectoFetch + 1), WFSConstant.QUERY_STR_WHERE) + WFSUtil.getQueryLockHintStr(dbType)+ " )";					
					}
					else{
					query = " Select * from (Select " + WFSUtil.getFetchPrefixStr(dbType, (noOfRectoFetch + 1)) + " ProcessInstanceId,ProcessInstanceId as ProcessInstanceName,ProcessDefId,ProcessName,ActivityId,ActivityName," + " PriorityLevel,InstrumentStatus,LockStatus,LockedByName,ValidTill,CreatedByName,CreatedDateTime," + " Statename,CheckListCompleteFlag,EntryDateTime,LockedTime,IntroductionDateTime,IntroducedBy," + " AssignedUser,WorkItemId,QueueName,AssignmentType,ProcessInstanceState,QueueType,Status,Q_Queueid," + WFSUtil.DATEDIFF(WFSConstant.WFL_hh, "entrydatetime", "ExpectedWorkItemDelay",
							dbType) + " as TurnaroundTime,ReferredByName,ReferredToName from WFINSTRUMENTTABLE " + WFSUtil.getTableLockHintStr(dbType) + " where  ProcessInstanceId in " 
							+ "( "+ archivedWorkitems.deleteCharAt(archivedWorkitems.length()-1)
							+ ") " + orderbyStr + " ) queueview " + WFSUtil.getFetchSuffixStr(dbType, (noOfRectoFetch + 1), WFSConstant.QUERY_STR_WHERE) + WFSUtil.getQueryLockHintStr(dbType)
							+"UNION ALL  Select * from (Select " + WFSUtil.getFetchPrefixStr(dbType, (noOfRectoFetch + 1)) + " ProcessInstanceId,ProcessInstanceName,ProcessDefId,ProcessName,ActivityId,ActivityName," + " PriorityLevel,InstrumentStatus,LockStatus,LockedByName,ValidTill,CreatedByName,CreatedDateTime," + " Statename,CheckListCompleteFlag,EntryDateTime,LockedTime,IntroductionDateTime,IntroducedBy," + " AssignedUser,WorkItemId,QueueName,AssignmentType,ProcessInstanceState,QueueType,Status,Q_Queueid," + WFSUtil.DATEDIFF(WFSConstant.WFL_hh, "entrydatetime", "ExpectedWorkItemDelayTime",
							dbType) + " as TurnaroundTime,ReferredByName,ReferredToName from QUEUEHISTORYTABLE " + WFSUtil.getTableLockHintStr(dbType) + " where  ProcessInstanceId in " 
							+ "( "+ archivedWorkitems2.deleteCharAt(archivedWorkitems2.length()-1)+ ") " 
							+ orderbyStr + " ) queueview " + WFSUtil.getFetchSuffixStr(dbType, (noOfRectoFetch + 1), WFSConstant.QUERY_STR_WHERE) + WFSUtil.getQueryLockHintStr(dbType);
					}
					pstmt1=con.prepareStatement("Select PropertyValue from WFSYSTEMPROPERTIESTABLE where PropertyKey = ?");
	            	pstmt1.setString(1,"ARCHIVALCABINETNAME");
	            	rs1= pstmt1.executeQuery();
	            	if(rs1.next()){
	            		targetCabinetName=WFSUtil.getFormattedString(rs1.getString("PropertyValue"))	;
	            	}
	            	
	            	else{

	                    mainCode = WFSError.WF_ARCHIVAL_CABINET_NOT_SET;
	                     subCode = 0;
	                     subject = WFSErrorMsg.getMessage(mainCode);
	                     descr = WFSErrorMsg.getMessage(subCode);
	                     errType = WFSError.WF_TMP;
	     			
	                 	//throw new WFSException(mainCode, subCode, errType, subject, descr);
	     				String errorString = WFSUtil.generalError("WFGetLinkedWorkItems", engine, gen,mainCode, subCode,errType, subject,descr);
	     				return errorString;
	                 
	            	}
	            	tarConn =WFSUtil.createConnectionToTargetCabinet(targetCabinetName, "", engine);
					pstmt = tarConn.prepareStatement(query);
					WFSUtil.jdbcExecute(null, sessionID, userID, query, pstmt, null, debug, engine);
					ResultSet rs3 = pstmt.getResultSet();
					resultSetsList.add(rs3);
				}
				if(linkedWorkitems.length()>0){
					//UT Defect 62583:  Changes for Postgres in WFGetLinkedWorkItem
					if(dbType==JTSConstant.JTS_POSTGRES){
						query = " (Select * from (Select " + WFSUtil.getFetchPrefixStr(dbType, (noOfRectoFetch + 1)) + " ProcessInstanceId,ProcessInstanceId as ProcessInstanceName,ProcessDefId,ProcessName,ActivityId,ActivityName," + " PriorityLevel,InstrumentStatus,LockStatus,LockedByName,ValidTill,CreatedByName,CreatedDateTime," + " Statename,CheckListCompleteFlag,EntryDateTime,LockedTime,IntroductionDateTime,IntroducedBy," + " AssignedUser,WorkItemId,QueueName,AssignmentType,ProcessInstanceState,QueueType,Status,Q_Queueid," + WFSUtil.DATEDIFF(WFSConstant.WFL_hh, "entrydatetime", "ExpectedWorkItemDelay",
								dbType) + " as TurnaroundTime,ReferredByName,ReferredToName,URN from WFINSTRUMENTTABLE " + WFSUtil.getTableLockHintStr(dbType) + " where  ProcessInstanceId in " 
								+ "( "+ linkedWorkitems.deleteCharAt(linkedWorkitems.length()-1)
								+ ") " + orderbyStr + " ) queueview " + WFSUtil.getFetchSuffixStr(dbType, (noOfRectoFetch + 1), WFSConstant.QUERY_STR_WHERE) + WFSUtil.getQueryLockHintStr(dbType)
								+") UNION ALL  (Select * from (Select " + WFSUtil.getFetchPrefixStr(dbType, (noOfRectoFetch + 1)) + " ProcessInstanceId,ProcessInstanceName,ProcessDefId,ProcessName,ActivityId,ActivityName," + " PriorityLevel,InstrumentStatus,LockStatus,LockedByName,ValidTill,CreatedByName,CreatedDateTime," + " Statename,CheckListCompleteFlag,EntryDateTime,LockedTime,IntroductionDateTime,IntroducedBy," + " AssignedUser,WorkItemId,QueueName,AssignmentType,ProcessInstanceState,QueueType,Status,Q_Queueid," + WFSUtil.DATEDIFF(WFSConstant.WFL_hh, "entrydatetime", "ExpectedWorkItemDelayTime",
								dbType) + " as TurnaroundTime,ReferredByName,ReferredToName,URN from QUEUEHISTORYTABLE " + WFSUtil.getTableLockHintStr(dbType) + " where  ProcessInstanceId in " 
								+ "( "+ linkedWorkitems2.deleteCharAt(linkedWorkitems2.length()-1)+ ") " 
								+ orderbyStr + " ) queueview " + WFSUtil.getFetchSuffixStr(dbType, (noOfRectoFetch + 1), WFSConstant.QUERY_STR_WHERE) + WFSUtil.getQueryLockHintStr(dbType)+")";
						
					}
					else{
					query = " Select * from (Select " + WFSUtil.getFetchPrefixStr(dbType, (noOfRectoFetch + 1)) + " ProcessInstanceId,ProcessInstanceId as ProcessInstanceName,ProcessDefId,ProcessName,ActivityId,ActivityName," + " PriorityLevel,InstrumentStatus,LockStatus,LockedByName,ValidTill,CreatedByName,CreatedDateTime," + " Statename,CheckListCompleteFlag,EntryDateTime,LockedTime,IntroductionDateTime,IntroducedBy," + " AssignedUser,WorkItemId,QueueName,AssignmentType,ProcessInstanceState,QueueType,Status,Q_Queueid," + WFSUtil.DATEDIFF(WFSConstant.WFL_hh, "entrydatetime", "ExpectedWorkItemDelay",
							dbType) + " as TurnaroundTime,ReferredByName,ReferredToName,URN from WFINSTRUMENTTABLE " + WFSUtil.getTableLockHintStr(dbType) + " where  ProcessInstanceId in " 
							+ "( "+ linkedWorkitems.deleteCharAt(linkedWorkitems.length()-1)
							+ ") " + orderbyStr + " ) queueview " + WFSUtil.getFetchSuffixStr(dbType, (noOfRectoFetch + 1), WFSConstant.QUERY_STR_WHERE) + WFSUtil.getQueryLockHintStr(dbType)
							+"UNION ALL  Select * from (Select " + WFSUtil.getFetchPrefixStr(dbType, (noOfRectoFetch + 1)) + " ProcessInstanceId,ProcessInstanceName,ProcessDefId,ProcessName,ActivityId,ActivityName," + " PriorityLevel,InstrumentStatus,LockStatus,LockedByName,ValidTill,CreatedByName,CreatedDateTime," + " Statename,CheckListCompleteFlag,EntryDateTime,LockedTime,IntroductionDateTime,IntroducedBy," + " AssignedUser,WorkItemId,QueueName,AssignmentType,ProcessInstanceState,QueueType,Status,Q_Queueid," + WFSUtil.DATEDIFF(WFSConstant.WFL_hh, "entrydatetime", "ExpectedWorkItemDelayTime",
							dbType) + " as TurnaroundTime,ReferredByName,ReferredToName,URN from QUEUEHISTORYTABLE " + WFSUtil.getTableLockHintStr(dbType) + " where  ProcessInstanceId in " 
							+ "( "+ linkedWorkitems2.deleteCharAt(linkedWorkitems2.length()-1)+ ") " 
							+ orderbyStr + " ) queueview " + WFSUtil.getFetchSuffixStr(dbType, (noOfRectoFetch + 1), WFSConstant.QUERY_STR_WHERE) + WFSUtil.getQueryLockHintStr(dbType);
					}
				pstmt = con.prepareStatement(query);
				WFSUtil.jdbcExecute(null, sessionID, userID, query, pstmt, null, debug, engine);
			 	ResultSet rs2 = pstmt.getResultSet();
			 	resultSetsList.add(rs2);
				}
				//pstmt.execute();
				
				tempXml = new StringBuffer(200);
				tempXml.append("<LinkedWorkItems>");
				int j = 0;
				String userName = null;
				String personalName = null;
				String familyName = null;
				Iterator<ResultSet> iter = resultSetsList.iterator();
				while(iter.hasNext()){
				 rs=iter.next();
				while (rs.next() && j++ < noOfRectoFetch) {
					tempXml.append("<WorkItem>\n");
					String linkedProcessInstanceId =rs.getString(1);
					pstmt1=con.prepareStatement("Select 1 from WFLinksTable where (parentprocessinstanceid=? and isparentarchived=?) or (childprocessinstanceid = ? and ischildarchived = ? )");
					pstmt1.setString(1,linkedProcessInstanceId);
					pstmt1.setString(2,"Y");
					pstmt1.setString(3,linkedProcessInstanceId);
					pstmt1.setString(4,"Y");
					rs1=pstmt1.executeQuery();
					if(rs1.next()){
						archiveFlag=true;
					}
					if(pstmt1!=null){
						pstmt1.close();
						pstmt1=null;
					}
					if(rs1!=null){
						rs1.close();
						rs1=null;
					}
					tempXml.append(gen.writeValueOf("URN", rs.getString("URN")));
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
					if (userInfo != null) {
						personalName = userInfo.getPersonalName();
						familyName = userInfo.getFamilyName();
						if(familyName == null)
						{
							familyName = "";
						}
					} else {
						personalName = "";
						familyName = "";
					}
					tempXml.append(gen.writeValueOf("LockedByUserName", userName));
					tempXml.append(gen.writeValueOf("LockedByPersonalName", personalName + " " + familyName));
					tempXml.append(gen.writeValueOf("ExpiryDateTime", rs.getString(11)));
					//tempXml.append(gen.writeValueOf("CreatedByUserName", rs.getString(12)));
					userName = rs.getString(12);	/*WFS_8.0_039*/
					userInfo = (WFUserInfo) CachedObjectCollection.getReference().getCacheObject(con, engine, 0, WFSConstant.CACHE_CONST_UserCache, "userName" + string21 + userName).getData();
					if (userInfo != null) {
						personalName = userInfo.getPersonalName();
						familyName = userInfo.getFamilyName();
						if(familyName == null)
						{
							familyName = "";
						}
					} else {
						personalName = "";
						familyName = "";
					}
					tempXml.append(gen.writeValueOf("CreatedByUserName", userName));
					tempXml.append(gen.writeValueOf("CreatedByPersonalName", personalName + " " + familyName));
					tempXml.append(gen.writeValueOf("CreationDateTime", rs.getString(13)));
					tempXml.append(gen.writeValueOf("WorkitemState", rs.getString(14)));
					tempXml.append(gen.writeValueOf("CheckListCompleteFlag", rs.getString(15)));
					tempXml.append(gen.writeValueOf("EntryDateTime", rs.getString(16)));
					tempXml.append(gen.writeValueOf("LockedTime", rs.getString(17)));
					tempXml.append(gen.writeValueOf("IntroductionDateTime", rs.getString(18)));
					if(archiveFlag){
						tempXml.append(gen.writeValueOf("Archived", "Y"));
					}else{
						tempXml.append(gen.writeValueOf("Archived", "N"));
					}
					archiveFlag=false;
					//tempXml.append(gen.writeValueOf("IntroducedBy", rs.getString(19)));
					//tempXml.append(gen.writeValueOf("AssignedTo", rs.getString(20)));
					userName = rs.getString(19);  /*WFS_8.0_039*/
					userInfo = (WFUserInfo) CachedObjectCollection.getReference().getCacheObject(con, engine, 0, WFSConstant.CACHE_CONST_UserCache, "userName" + string21 + userName).getData();
					if (userInfo != null) {
						personalName = userInfo.getPersonalName();
						familyName = userInfo.getFamilyName();
						if(familyName == null)
						{
							familyName = "";
						}
					} else {
						personalName = "";
						familyName = "";
					}
					tempXml.append(gen.writeValueOf("IntroducedBy", userName));
					tempXml.append(gen.writeValueOf("IntroducedByPersonalName", personalName + " " + familyName));
					userName = rs.getString(20);	/*WFS_8.0_039*/
					userInfo = (WFUserInfo) CachedObjectCollection.getReference().getCacheObject(con, engine, 0, WFSConstant.CACHE_CONST_UserCache, "userName" + string21 + userName).getData();
					if (userInfo != null) {
						personalName = userInfo.getPersonalName();
						familyName = userInfo.getFamilyName();
						if(familyName == null)
						{
							familyName = "";
						}
					} else {
						personalName = "";
						familyName = "";
					}
					tempXml.append(gen.writeValueOf("AssignedTo", userName));
					tempXml.append(gen.writeValueOf("AssignedToPersonalName", personalName + " " + familyName));
					tempXml.append(gen.writeValueOf("WorkItemId", rs.getString(21)));
					tempXml.append(gen.writeValueOf("QueueName", rs.getString(22)));
					tempXml.append(gen.writeValueOf("AssignmentType", rs.getString(23)));
					tempXml.append(gen.writeValueOf("ProcessInstanceState", rs.getString(24)));
					tempXml.append(gen.writeValueOf("QueueType", rs.getString(25)));
					tempXml.append(gen.writeValueOf("Status", rs.getString(26)));
					tempXml.append(gen.writeValueOf("QueueID", rs.getString(27)));
					tempXml.append(gen.writeValueOf("Turnaroundtime", rs.getString(28)));
					tempXml.append(gen.writeValueOf("Referredby", rs.getString(29)));
					tempXml.append(gen.writeValueOf("Referredto", rs.getString(30)));
					tempXml.append("</WorkItem>\n");
				}
					if(rs!=null){
						rs.close();
						rs=null;
					}
				}
				tempXml.append("</LinkedWorkItems>");
				if (j > noOfRectoFetch) {
					tempXml.append(gen.writeValueOf("NoOfRecordsFetched", String.valueOf(noOfRectoFetch)));
				} else {
					tempXml.append(gen.writeValueOf("NoOfRecordsFetched", String.valueOf(j)));
				}
				tempXml.append(gen.writeValueOf("TotalNoOfRecords", String.valueOf(j)));
				if (j == 0) {
					throw new WFSException(WFSError.WM_NO_MORE_DATA, WFSError.WFS_NO_LNK, WFSError.WF_TMP,
							WFSErrorMsg.getMessage(WFSError.WM_NO_MORE_DATA),
							WFSErrorMsg.getMessage(WFSError.WFS_NO_LNK)); // None Found
				} else {
					pstmt.close();
					/* Bugzilla Bug 1750, Logging for WFL_getlink removed, 20/12/2007, Ruhi Hira */
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
				outputXML.append(gen.createOutputFile("WFGetLinkedWorkitems"));
				outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
				outputXML.append(tempXml);
				outputXML.append(gen.closeOutputFile("WFGetLinkedWorkitems"));
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
			subject = e.getErrorMessage();
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
			try{
				if(rs!=null){
					rs.close();
					rs=null;
				}
			}catch(Exception e){
				WFSUtil.printErr(engine,"", e);
			}
			try{
				if(rs1!=null){
					rs1.close();
					rs1=null;
				}
			}catch(Exception e){
				WFSUtil.printErr(engine,"", e);
			}
			try{
				if(pstmt!=null){
					pstmt.close();
					pstmt=null;
				}
			}catch(Exception e){
				WFSUtil.printErr(engine,"", e);
			}
			try{
				if(pstmt1!=null){
					pstmt1.close();
					pstmt1=null;
				}
			}catch(Exception e){
				WFSUtil.printErr(engine,"", e);
			}
			try {
				if (tarConn != null) {
					tarConn.close();
					tarConn = null;
				}
			} catch (Exception e) {
				WFSUtil.printErr(engine,"", e);
			}
			
		}
		if (mainCode != 0) {
			throw new WFSException(mainCode, subCode, errType, subject, descr);
		}
		return outputXML.toString();
	}

	//----------------------------------------------------------------------------------------------------
	//	Function Name 				:	WFDeleteWorkItem
	//	Date Written (DD/MM/YYYY)	:	11/7/2002
	//	Author								:	Prashant
	//	Input Parameters			:	Connection , XMLParser , XMLGenerator
	//	Output Parameters			: none
	//	Return Values					:	String
	//	Description						: Get all related Workitems for a ProcessInstance
	//----------------------------------------------------------------------------------------------------
    //  Change Description          : Changes for Code Optimization-Merging of WorkFlow 
    //								  tables to WFInstrumentTable and logging of Query
    //  Changed by					: Mohnish Chopra  
	public String WFDeleteWorkItem(Connection con, XMLParser parser,
			XMLGenerator gen) throws JTSException, WFSException {
		StringBuffer outputXML = null;
		String option = parser.getValueOf("Option", "", false);
		Statement stmt = null;
		ResultSet rs = null;
		String var_rec_1 = null;
		String var_rec_2 = null;
		String activityName = "";
		int actId = 0;
		int mainCode = 0;
		int subCode = 0;
		String subject = null;
		String descr = null;
                int processDefId = 0 ;
                int processInstanceState = -1;
		int workitemState = -1; //WFS_8.0_033
		String errType = WFSError.WF_TMP;
		ArrayList<String> queries = new ArrayList<String>();
		String engine=null;
		try {
			boolean loggingFlag=true;
			int sessionID = parser.getIntOf("SessionId", 0, false);
			engine = parser.getValueOf("EngineName");
			int dbType = ServerProperty.getReference().getDBType(engine);
			StringBuffer tempXml = null;
			WFParticipant participant = WFSUtil.WFCheckSession(con, sessionID);
			String activityId = parser.getValueOf("ActivityId", null, true);  //WFS_8.0_033
			boolean deleteHistory_Flag = parser.getValueOf("DeleteHistoryFlag", "N", true).
					trim().equalsIgnoreCase("Y") ? true : false;
			// changes made for getting dms information
			// - Ruhi Hira
           boolean deleteExternalTableData_Flag = parser.getValueOf("DeleteExternalTableDataFlag", "N", true).trim().equalsIgnoreCase("Y") ? true : false;
			
			boolean returnDMSInfo = parser.getValueOf("ReturnDMSInfo", "N", true).trim().equalsIgnoreCase("Y") ? true : false;
			if (participant != null && participant.gettype() == 'U') {
				int userID = participant.getid();
				String username = participant.getname();

				String pinstId = parser.getValueOf("ProcessInstanceID", "", false);

				stmt = con.createStatement();
				if (returnDMSInfo) {
					ResultSet rs_temp = null;
					// Bug # WFS_6_027, Query not working on Oracle - Ruhi Hira.
					/*rs_temp = stmt.executeQuery("Select var_rec_1, var_rec_2, ActivityName, ActivityId, WorkitemState, " +
					"ProcessDefId From queueview Where processInstanceId = " + TO_STRING(pinstId, true, dbType));*/
					rs_temp = stmt.executeQuery("Select var_rec_1, var_rec_2, ActivityName, ActivityId, WorkitemState, " +
					"ProcessDefId, ProcessInstanceState From WFINSTRUMENTTABLE " + WFSUtil.getTableLockHintStr(dbType) +"   Where processInstanceId = " + TO_STRING(pinstId, true, dbType));
					if (rs_temp != null && rs_temp.next()) {
						var_rec_1 = rs_temp.getString(1);
						var_rec_2 = rs_temp.getString(2);
						activityName = rs_temp.getString(3);
						actId = rs_temp.getInt(4);
						workitemState = rs_temp.getInt(5);
                        processDefId = rs_temp.getInt(6);
                        processInstanceState= rs_temp.getInt(7);
					} else {
						mainCode = WFSError.WM_INVALID_PROCESS_INSTANCE;
						subCode = 0;
						subject = WFSErrorMsg.getMessage(mainCode);
						descr = WFSErrorMsg.getMessage(subCode);
						errType = WFSError.WF_TMP;
					}
					if (rs_temp != null) {
						rs_temp.close();
						rs_temp = null;
					}
				}
				if (mainCode == 0) {
					// Tirupati Srivastava : changes made to make code compatible with postgreSQL
					//WFS_8.0_033
					if (activityId != null && !activityId.equals(String.valueOf(actId)) || processInstanceState != 1) {
						mainCode = WFSError.WM_INVALID_WORKITEM;
						subCode = 0;
						subject = WFSErrorMsg.getMessage(mainCode);
						descr = WFSErrorMsg.getMessage(subCode);
						errType = WFSError.WF_TMP;
						WFSUtil.printErr(engine,"Inside WFSError.WM_INVALID_WORKITEM ");
					} else { 
						StringBuilder wmGetWorkItemInputXml = new StringBuilder();
						wmGetWorkItemInputXml.append("<?xml version=\"1.0\"?><WMGetWorkItem_Input><Option>WMGetWorkItem</Option>");
						wmGetWorkItemInputXml.append("<EngineName>").append(engine).append("</EngineName>");
						wmGetWorkItemInputXml.append("<SessionId>").append(sessionID).append("</SessionId>");
						wmGetWorkItemInputXml.append("<ProcessInstanceId>").append(pinstId).append("</ProcessInstanceId>");
						wmGetWorkItemInputXml.append("<WorkItemId>1</WorkItemId>");
						wmGetWorkItemInputXml.append("</WMGetWorkItem_Input>");
						XMLParser getWIParser = new XMLParser();
						getWIParser.setInputXML(wmGetWorkItemInputXml.toString());
						try
						{
							String wmGetWorkItemOutputXml = WFFindClass.getReference().execute("WMGetWorkItem", engine, con, getWIParser, gen);
							getWIParser.setInputXML(wmGetWorkItemOutputXml);
							mainCode = Integer.parseInt(getWIParser.getValueOf("MainCode"));
						}
						catch(WFSException wfs)
						{
							WFSUtil.printErr(engine, "[WMDeleteWorkitem] : WFSException in WMGetworkItem");
							WFSUtil.printErr(engine, wfs);
							throw wfs;
						}

                        if(mainCode == 0)
                        {
                        	//query to find processDefId
                        	String query = "SELECT ProcessDefId FROM WFINSTRUMENTTABLE " + WFSUtil.getTableLockHintStr(dbType) +" WHERE ProcessInstanceID = ?";
                        	PreparedStatement ipstmt = con.prepareStatement(query);
                        	ipstmt.setString(1,pinstId );
                        	ResultSet irs = ipstmt.executeQuery();
                        	if(irs.next())
                        	{
                        		processDefId = irs.getInt("ProcessDefId");
                        	}
                        	if (con.getAutoCommit())
                        	{
                        		con.setAutoCommit(false);
                        	}
                        	stmt.addBatch(" Delete from WFReminderTable where ProcessInstanceID = " + TO_STRING(pinstId, true, dbType));
                        	stmt.addBatch(" Delete from WFLinkstable where ParentProcessInstanceID = " + TO_STRING(pinstId, true, dbType) + " OR ChildProcessInstanceID = " + TO_STRING(pinstId, true, dbType));
                        	stmt.addBatch(" Delete from QueueHistoryTable where ProcessInstanceID = " + TO_STRING(pinstId, true, dbType));
                        	/*	stmt.addBatch(" Delete from ProcessInstanceTable where ProcessInstanceID = " + TO_STRING(pinstId, true, dbType));
						stmt.addBatch(" Delete from QueueDatatable where ProcessInstanceID = " + TO_STRING(pinstId, true, dbType));
						stmt.addBatch(" Delete from Worklisttable where ProcessInstanceID = " + TO_STRING(pinstId, true, dbType));
						// WSE_5.0.1_005 --  Begin
						stmt.addBatch(" Delete from WorkinProcesstable where ProcessInstanceID = " + TO_STRING(pinstId, true, dbType));
						stmt.addBatch(" Delete from Workdonetable where ProcessInstanceID = " + TO_STRING(pinstId, true, dbType));
						stmt.addBatch(" Delete from WorkwithPStable where ProcessInstanceID = " + TO_STRING(pinstId, true, dbType));
						stmt.addBatch(" Delete from PendingWorklisttable where ProcessInstanceID = " + TO_STRING(pinstId, true, dbType));*/ // WSE_5.0.1_005 --  End
                        	stmt.addBatch(" Delete from WFInstrumentTable where ProcessInstanceID = " + TO_STRING(pinstId, true, dbType));
                        	stmt.addBatch(" Delete from ExceptionTable	where ProcessInstanceId = " + TO_STRING(pinstId, true, dbType));
                        	stmt.addBatch(" Delete from ToDoStatusTable where ProcessInstanceID = " + TO_STRING(pinstId, true, dbType));
                        	stmt.addBatch(" Delete from ExceptionHistoryTable where ProcessInstanceId = " + TO_STRING(pinstId, true, dbType));
                        	stmt.addBatch(" Delete from ToDoStatusHistoryTable where ProcessInstanceID = " + TO_STRING(pinstId, true, dbType));

                        	queries.add(" Delete from WFReminderTable where ProcessInstanceID = " + TO_STRING(pinstId, true, dbType));
                        	queries.add(" Delete from WFLinkstable where ParentProcessInstanceID = " + TO_STRING(pinstId, true, dbType) + " OR ChildProcessInstanceID = " + TO_STRING(pinstId, true, dbType));
                        	queries.add(" Delete from QueueHistoryTable where ProcessInstanceID = " + TO_STRING(pinstId, true, dbType));
                        	/*	stmt.addBatch(" Delete from ProcessInstanceTable where ProcessInstanceID = " + TO_STRING(pinstId, true, dbType));
						stmt.addBatch(" Delete from QueueDatatable where ProcessInstanceID = " + TO_STRING(pinstId, true, dbType));
						stmt.addBatch(" Delete from Worklisttable where ProcessInstanceID = " + TO_STRING(pinstId, true, dbType));
						// WSE_5.0.1_005 --  Begin
						stmt.addBatch(" Delete from WorkinProcesstable where ProcessInstanceID = " + TO_STRING(pinstId, true, dbType));
						stmt.addBatch(" Delete from Workdonetable where ProcessInstanceID = " + TO_STRING(pinstId, true, dbType));
						stmt.addBatch(" Delete from WorkwithPStable where ProcessInstanceID = " + TO_STRING(pinstId, true, dbType));
						stmt.addBatch(" Delete from PendingWorklisttable where ProcessInstanceID = " + TO_STRING(pinstId, true, dbType));*/ // WSE_5.0.1_005 --  End
                        	queries.add(" Delete from WFInstrumentTable where ProcessInstanceID = " + TO_STRING(pinstId, true, dbType));
                        	queries.add(" Delete from ExceptionTable	where ProcessInstanceId = " + TO_STRING(pinstId, true, dbType));
                        	queries.add(" Delete from ToDoStatusTable where ProcessInstanceID = " + TO_STRING(pinstId, true, dbType));
                        	queries.add(" Delete from ExceptionHistoryTable where ProcessInstanceId = " + TO_STRING(pinstId, true, dbType));
                        	queries.add(" Delete from ToDoStatusHistoryTable where ProcessInstanceID = " + TO_STRING(pinstId, true, dbType));

                        	// Changes made for deleting history from routelogtable conditionally
                        	// - Ruhi Hira
                        	if (deleteHistory_Flag) {
                        		stmt.addBatch(" Delete from WFCurrentRouteLogTable where ProcessInstanceID = " + TO_STRING(pinstId, true, dbType));
                        		stmt.addBatch(" Delete from WFHistoryRouteLogTable where ProcessInstanceID = " + TO_STRING(pinstId, true, dbType));
                        		queries.add(" Delete from WFCurrentRouteLogTable where ProcessInstanceID = " + TO_STRING(pinstId, true, dbType));
                        		queries.add(" Delete from WFHistoryRouteLogTable where ProcessInstanceID = " + TO_STRING(pinstId, true, dbType));

                        	}

                        	//----------------------------------------------------------------------------
                        	// Changed By											: Prashant
                        	// Reason / Cause (Bug No if Any)	: Bug No TSR_3.0.2.0014
                        	// Change Description							:	DeleteWorkItem not to remove the entries from AuditTrail for the Workitem
                        	//----------------------------------------------------------------------------
                        	if(deleteExternalTableData_Flag)
                        	{
                        		String strTableName = null;
                        		try {
                        			strTableName=WFSExtDB.getTableName(engine, processDefId, 1);
                        		}
                        		catch(JTSException jte) {
                        			//jte.printStackTrace();
                        			WFSUtil.printErr(engine,"", jte);
                        			strTableName = null;
                        		}
                        		if (strTableName != null && !strTableName.equals(""))
                        			stmt.addBatch(" Delete from " + strTableName + " where ITEMINDEX ="+TO_STRING(var_rec_1,true,dbType)+"and ItemType="+TO_STRING(var_rec_2,true,dbType));
                        	}
                        	int res[]=WFSUtil.jdbcExecuteBatch(pinstId, sessionID, userID, queries, stmt, null, loggingFlag , engine);
                        	/*						int res[] = stmt.executeBatch();
                        	 */						if (stmt != null) {
                        		 stmt.close();
                        	 }

                        	 /* Begin
						Changes done by : Ishu Saraf
						Changes On : 19/08/2008
						TaskId 13 */
                        	 /*  if (res[0] > 0) {
						mainCode = WFSError.WM_INVALID_PROCESS_INSTANCE;
						subCode = 0;
						subject = WFSErrorMsg.getMessage(mainCode);
						descr = WFSErrorMsg.getMessage(subCode);
						errType = WFSError.WF_TMP;
						} else {*/ //end
                        	 WFSUtil.generateLog(engine, con, WFSConstant.WFL_ProcessInstanceDeleted, pinstId, 1, processDefId,
                        			 actId, activityName, 0, userID, username, 0, null, null, null, null, null);

                        	 if (!con.getAutoCommit()) {
                        		 con.commit();
                        		 con.setAutoCommit(true);
                        	 }
                        }
                        else
                        {
                        	subCode = 0;
                        	subject = WFSErrorMsg.getMessage(mainCode);
                        	descr = WFSErrorMsg.getMessage(subCode);
                        	errType = WFSError.WF_TMP;
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
				outputXML = new StringBuffer(300);
				outputXML.append(gen.createOutputFile("WFDeleteWorkItem"));
				if (returnDMSInfo) {
					outputXML.append("<DMSInfo>");
					outputXML.append("<Name>VAR_REC_1</Name>");
					outputXML.append("<Value>" + var_rec_1 + "</Value>");
					outputXML.append("</DMSInfo>");
					outputXML.append("<DMSInfo>");
					outputXML.append("<Name>VAR_REC_2</Name>");
					outputXML.append("<Value>" + var_rec_2 + "</Value>");
					outputXML.append("</DMSInfo>");
					outputXML.append("<Name>ProcessDefId</Name>");
					outputXML.append("<Value>" + processDefId + "</Value>");
				}
				outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
				outputXML.append(gen.closeOutputFile("WFDeleteWorkItem"));
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
			subject = e.getErrorMessage();
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
				if (!con.getAutoCommit()) {
					con.rollback();
					con.setAutoCommit(true);
				}
			} catch (Exception e) {
				WFSUtil.printErr(engine,"", e);
			}
			try{
				if(rs!=null){
					rs.close();
					rs=null;
				}
			}catch(Exception e){
				WFSUtil.printErr(engine,"", e);
			}
			try{
				if(stmt!=null){
					stmt.close();
					stmt=null;
				}
			}catch(Exception e){
				WFSUtil.printErr(engine,"", e);
			}
			
		}
		if (mainCode != 0) {
			String strReturn = WFSUtil.generalError(option, engine, gen,
   	                   mainCode, subCode,
   	                   errType, subject,
   	                    descr);
   	             
   	             return strReturn;				}
		return outputXML.toString();
	}

	//----------------------------------------------------------------------------------------------------
	//	Function Name 				:	WFPurgeWorkItem
	//	Date Written (DD/MM/YYYY)	:	30/04/2018
	//	Author						:	Shubhankur Manuja
	//	Input Parameters			:	Connection , XMLParser , XMLGenerator
	//	Output Parameters			: 	none
	//	Return Values				:	String
	//	Description					: 	Purge workitem data from all tables in the database on various conditions.
	//----------------------------------------------------------------------------------------------------
	
	public String WFPurgeWorkItem(Connection con, XMLParser parser,
			XMLGenerator gen) throws JTSException, WFSException {
		StringBuffer outputXML = null;
		String option = parser.getValueOf("Option", "", false);
        CallableStatement cstmt = null;
		int mainCode = 0;
		int subCode = 0;
		String subject = null;
		String descr = null;
        int processDefId = 0 ;
		String errType = WFSError.WF_TMP;
		String engine=null;
		try {
			int sessionID = parser.getIntOf("SessionId", 0, false);
			engine = parser.getValueOf("EngineName");
			int dbType = ServerProperty.getReference().getDBType(engine);
			WFParticipant participant = WFSUtil.WFCheckSession(con, sessionID);
			
			if (participant != null && participant.gettype() == 'U') {
				if (con.getAutoCommit()) {
    				con.setAutoCommit(false);
    			}
				
				String dbHostName = parser.getValueOf("DBHostName", "USER", true);
				String dbAPPInfo = parser.getValueOf("DBAPPInfo", "", false);
				String dbAPPName = parser.getValueOf("DBAPPName", "OAP", true);
				String processInstanceID = parser.getValueOf("ProcessInstanceID", null , true);
				int processDefID = parser.getIntOf("ProcessDefID", 0, false);
				int activityID = parser.getIntOf("ActivityID", 0, true);
				String startDate = parser.getValueOf("StartDate", null, true);
				String endDate = parser.getValueOf("EndDate", null, true);
				String deleteHistoryFlag = parser.getValueOf("DeleteHistoryFlag", "", false);
				String deleteExternalData = parser.getValueOf("DeleteExternalData", "", false);
				String resetProcessSeqFlag = parser.getValueOf("ResetProcessSeqFlag", "", false);
			

	           if (dbType == JTSConstant.JTS_MSSQL) {
	               cstmt = con.prepareCall("{call WFPurgeWorkItem(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)}");
	               cstmt.setInt(1, sessionID);
	               cstmt.setString(2, dbHostName);  
	               cstmt.setString(3, dbAPPInfo);   
	               cstmt.setString(4, dbAPPName);
	               if(processInstanceID!=null){
	            	   cstmt.setString(5, processInstanceID); 
	               }
	               else{
	            	   cstmt.setNull(5, java.sql.Types.VARCHAR);
	               }
	               cstmt.setInt(6, processDefID);  

	               if(activityID!=0){
	            	   cstmt.setInt(7, activityID);
	               }
	               else{
	            	   cstmt.setNull(7, java.sql.Types.INTEGER);
	               }
	               if(startDate!=null){
	            	   cstmt.setString(8, startDate); 
	               }
	               else{
	            	   cstmt.setNull(8, java.sql.Types.VARCHAR);
	               }
	               if(endDate!=null){
	            	   cstmt.setString(9, endDate); 
	               }
	               else{
	            	   cstmt.setNull(9, java.sql.Types.VARCHAR);
	               }
	               cstmt.setString(10, deleteHistoryFlag); 
	               cstmt.setString(11, deleteExternalData);
	               cstmt.setString(12, resetProcessSeqFlag); 
	               
	           } else if (dbType == JTSConstant.JTS_ORACLE) {
	               cstmt = con.prepareCall("{call WFPurgeWorkItem(?, ?, ?, ?, ?, ?, ?)}");/*Bug 36306 fixed*/
	               cstmt.setInt(1, sessionID);
	               cstmt.setString(2, dbHostName);
	               if(processInstanceID!=null){
	            	   cstmt.setString(3, processInstanceID); 
	               }
	               else{
	            	   cstmt.setNull(3, java.sql.Types.VARCHAR);
	               }
	               cstmt.setInt(4, processDefId);
	               cstmt.setString(5, deleteHistoryFlag);   
	               cstmt.setString(6, deleteExternalData);    
	               cstmt.registerOutParameter(7, java.sql.Types.INTEGER);    //  Output Parameter.
	           } else if (dbType == JTSConstant.JTS_POSTGRES) {
	           }
	           cstmt.execute();

				
			} else {
				mainCode = WFSError.WM_INVALID_SESSION_HANDLE;
				subCode = 0;
				subject = WFSErrorMsg.getMessage(mainCode);
				descr = WFSErrorMsg.getMessage(subCode);
				errType = WFSError.WF_TMP;
			}
			if (mainCode == 0) {
				
				if (!con.getAutoCommit()) {
					con.commit();
					con.setAutoCommit(true);
				}
				
				outputXML = new StringBuffer(300);
				outputXML.append(gen.createOutputFile("WFPurgeWorkItem"));
				outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
				outputXML.append(gen.closeOutputFile("WFPurgeWorkItem"));
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
			subject = e.getErrorMessage();
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
				if (!con.getAutoCommit()) {
					con.rollback();
					con.setAutoCommit(true);
				}

			} catch (Exception e) {
				WFSUtil.printErr(engine,"", e);
			}
			try{

				if (cstmt != null) {
					cstmt.close();
					cstmt = null;
				}
			}catch(Exception e){
				WFSUtil.printErr(engine,"", e);
			}
			
		}
		if (mainCode != 0) {
			String strReturn = WFSUtil.generalError(option, engine, gen,
   	                   mainCode, subCode,
   	                   errType, subject,
   	                    descr);
   	             
   	             return strReturn;				}
		return outputXML.toString();
	}
	
	//----------------------------------------------------------------------------------------------------
	//	Function Name 				    :	WFGetNextWorkitemforMail
	//	Date Written (DD/MM/YYYY)	:	16/05/2002
	//	Author						        :	Prashant
	//	Input Parameters		    	:	Connection , XMLParser , XMLGenerator
	//	Output Parameters			    : none
	//	Return Values				      :	String
	//	Description					      : Get Next Workitem for Mailing
	//----------------------------------------------------------------------------------------------------
    //  Change Description          : Changes for Code Optimization-Merging of WorkFlow 
    //								  tables to WFInstrumentTable, logging of Query and Removal of throw WFSException
    //  Changed by					: Shweta Singhal
	   public String WFGetNextWorkitemforMail(Connection con, XMLParser parser,
            XMLGenerator gen) throws JTSException, WFSException {
        StringBuilder outputXML = new StringBuilder(500);
        ResultSet rs = null;
        int mainCode = WFSError.WM_NO_MORE_DATA;
        int subCode = 0;
        String subject = null;
        String descr = null;
        String userName = null;
        String personalName = null;
        String errType = WFSError.WF_TMP;
        String engine = null;
        String familyName = null;
        CallableStatement cstmt = null;
        PreparedStatement pstmt = null;
        String queryCallable = null;
        String option = parser.getValueOf("Option", "", false);
        boolean bCommit = false;
        char char21 = 21;
        String string21 = "" + char21;
        ResultSet rs2 = null;
        String name = null;
        try {
            int cssession = 0;
            int sessionID = parser.getIntOf("SessionId", 0, false);
            engine = parser.getValueOf("EngineName");
            int dbType = ServerProperty.getReference().getDBType(engine);
            String procInstID = parser.getValueOf("ProcessInstanceId");
            int wrkitemId = parser.getIntOf("WorkItemId", 0, true);
            String csName = parser.getValueOf("CSName");
            boolean userDefVarFlag = parser.getValueOf("UserDefVarFlag", "N", true).equalsIgnoreCase("Y");
            boolean debugFlag = parser.getValueOf("DebugFlag", "N", true).equalsIgnoreCase("Y");

            if (dbType == JTSConstant.JTS_ORACLE) {
                queryCallable = "{call WFGETNEXTWORKITEMFORMAIL(?, ?, ?, ?, ?)}";
            } else if (dbType == JTSConstant.JTS_MSSQL || dbType == JTSConstant.JTS_POSTGRES) {
                queryCallable = "{call WFGETNEXTWORKITEMFORMAIL(?, ?)}";
            }

            if (con.getAutoCommit()) {
                con.setAutoCommit(false);
                bCommit = true;
            }
            cstmt = con.prepareCall(queryCallable);
            cstmt.setInt(1, sessionID);
            cstmt.setString(2, csName);
            if (dbType == JTSConstant.JTS_ORACLE) {
                cstmt.registerOutParameter(3, java.sql.Types.INTEGER);
                cstmt.registerOutParameter(4, java.sql.Types.INTEGER);
                cstmt.registerOutParameter(5, oracle.jdbc.OracleTypes.CURSOR);
            }
            cstmt.execute();
            if (dbType == JTSConstant.JTS_ORACLE) {
                mainCode = cstmt.getInt(3);
                cssession = cstmt.getInt(4);
            } else if (dbType == JTSConstant.JTS_MSSQL) {
                rs = cstmt.getResultSet();
                if (rs != null && rs.next()) {
                    mainCode = rs.getInt(1);
                    cssession = rs.getInt(2);
                }
            } else if (dbType == JTSConstant.JTS_POSTGRES) {
                rs2 = cstmt.getResultSet();
                if (rs2 != null && rs2.next()) {
                    name = rs2.getString(1);
                    pstmt = con.prepareStatement("Fetch All In \"" + TO_SANITIZE_STRING(name, true) + "\"");
                    rs = pstmt.executeQuery();
                    if (rs != null && rs.next()) {
                        mainCode = rs.getInt(1);
                        cssession = rs.getInt(2);
                    }
                }
            }

            if (rs != null) {
                rs.close();
                rs = null;
            }

            if (pstmt != null) {
                pstmt.close();
                pstmt = null;
            }
            if (mainCode == 0) {
                if (dbType == JTSConstant.JTS_ORACLE) {
                    rs = (ResultSet) cstmt.getObject(5);
                } else if (dbType == JTSConstant.JTS_MSSQL) {
                    if (cstmt.getMoreResults()) {
                        rs = cstmt.getResultSet();
                    }
                } else if (dbType == JTSConstant.JTS_POSTGRES) {
                    if (rs2.next()) {
                        name = rs2.getString(1);
                        pstmt = con.prepareStatement("Fetch All In \"" + TO_SANITIZE_STRING(name, true) + "\"");
                        rs = pstmt.executeQuery();
                    }
                }
                if (rs != null && rs.next()) {
                    outputXML.append(gen.createOutputFile(option));
                    outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
                    outputXML.append(gen.writeValueOf("CSSession", String.valueOf(cssession)));
                    outputXML.append("<Instrument>\n");
                    outputXML.append(gen.writeValueOf("ProcessInstanceId", rs.getString("ProcessInstanceId")));
                    procInstID = rs.getString("ProcessInstanceId");
                    outputXML.append(gen.writeValueOf("WorkItemName", rs.getString("WorkItemName")));
                    outputXML.append(gen.writeValueOf("RouteId", rs.getString("RouteId")));
                    outputXML.append(gen.writeValueOf("RouteName", rs.getString("RouteName")));
                    outputXML.append(gen.writeValueOf("WorkStageId", rs.getString("WorkStageId")));
                    outputXML.append(gen.writeValueOf("ActivityName", rs.getString("ActivityName")));
                    outputXML.append(gen.writeValueOf("PriorityLevel", rs.getString("PriorityLevel")));
                    outputXML.append(gen.writeValueOf("InstrumentStatus", rs.getString("InstrumentStatus")));
                    outputXML.append(gen.writeValueOf("LockStatus", rs.getString("LockStatus")));
                    outputXML.append(gen.writeValueOf("LockedByUserName", rs.getString("LockedByUserName")));
                    outputXML.append(gen.writeValueOf("ExpiryDateTime", rs.getString("ExpiryDateTime")));
                    outputXML.append(gen.writeValueOf("CreatedByUserName", rs.getString("CreatedByUserName")));
                    outputXML.append(gen.writeValueOf("CreationDateTime", rs.getString("CreationDateTime")));
                    outputXML.append(gen.writeValueOf("WorkitemState", rs.getString("WorkitemState")));
                    outputXML.append(gen.writeValueOf("CheckListCompleteFlag", rs.getString("CheckListCompleteFlag")));
                    outputXML.append(gen.writeValueOf("EntryDateTime", rs.getString("EntryDateTime")));
                    outputXML.append(gen.writeValueOf("LockedTime", rs.getString("LockedTime")));
                    outputXML.append(gen.writeValueOf("IntroductionDateTime", rs.getString("IntroductionDateTime")));
                    userName = rs.getString("IntroducedBy");
                    outputXML.append(gen.writeValueOf("IntroducedBy", userName));
                    outputXML.append(gen.writeValueOf("AssignedTo", rs.getString("AssignedTo")));
                    wrkitemId = Integer.parseInt(rs.getString("WorkItemId"));
                    outputXML.append(gen.writeValueOf("WorkItemId", rs.getString("WorkItemId")));
                    outputXML.append(gen.writeValueOf("QueueName", rs.getString("QueueName")));
                    outputXML.append(gen.writeValueOf("AssignmentType", rs.getString("AssignmentType")));
                    outputXML.append(gen.writeValueOf("ProcessInstanceState", rs.getString("ProcessInstanceState")));
                    outputXML.append(gen.writeValueOf("QueueType", rs.getString("QueueType")));
                    outputXML.append(gen.writeValueOf("Status", rs.getString("Status")));
                    outputXML.append(gen.writeValueOf("QueueId", rs.getString("QueueId")));
                    outputXML.append(gen.writeValueOf("Turnaroundtime", rs.getString("Turnaroundtime")));
                    outputXML.append(gen.writeValueOf("UserID", rs.getString("UserID")));
                    WFUserInfo userInfo = (WFUserInfo) CachedObjectCollection.getReference().getCacheObject(con, engine, 0, WFSConstant.CACHE_CONST_UserCache, "userName" + string21 + userName).getData();
                    if (userInfo != null) {
                        personalName = userInfo.getPersonalName();
                        familyName = userInfo.getFamilyName();
                        if (familyName == null) {
                            familyName = "";
                        }
                        outputXML.append(gen.writeValueOf("PersonalName", personalName + " " + familyName));
                    } else {
                        personalName = "";
                    }
                    String urn = rs.getString("URN");
                    if (urn != null && !urn.equals("")) {
                        outputXML.append(gen.writeValueOf("URN", urn));
                    } else {
                        outputXML.append(gen.writeValueOf("URN", rs.getString(1)));
                    }
                    outputXML.append(gen.writeValueOf("ActivityType", rs.getString("ActivityType")));
                    if (userDefVarFlag) {
                        outputXML.append(((String) WFSUtil.fetchAttributesExt(con, procInstID, wrkitemId, "", engine, dbType, gen, "", false, false)));
                    } else {
                        outputXML.append(((String) WFSUtil.fetchAttributes(con, procInstID, wrkitemId, "", engine, dbType, gen, "", false, false)));
                    }
                    outputXML.append("</Instrument>\n");
                    outputXML.append(gen.closeOutputFile(option));
                } else {
                    mainCode = WFSError.WM_NO_MORE_DATA;
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
                subCode = 0;
                subject = WFSErrorMsg.getMessage(mainCode);
                errType = WFSError.WF_TMP;
                descr = WFSErrorMsg.getMessage(subCode);
                outputXML.append(WFSUtil.generalError(option, engine, gen, mainCode, subCode, errType, subject, descr));
            }
            if (rs2 != null) {
                rs2.close();
                rs2 = null;
            }
            if (bCommit) {
                con.commit();
                con.setAutoCommit(true);
                bCommit = false;
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
            WFSUtil.printErr(engine, "", e);
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
                if (rs != null) {
                    rs.close();
                    rs = null;
                }
            } catch (SQLException ignore) {
            }
            try {
                if (rs2 != null) {
                    rs2.close();
                    rs2 = null;
                }
            } catch (SQLException ignore) {
            }
            try {
                if (pstmt != null) {
                    pstmt.close();
                    pstmt = null;
                }
//     					con.setTransactionIsolation(Connection.TRANSACTION_READ_UNCOMMITTED);
            } catch (Exception e) {
            }
            try {
                if (cstmt != null) {
                    cstmt.close();
                    cstmt = null;
                }
//     					con.setTransactionIsolation(Connection.TRANSACTION_READ_UNCOMMITTED);
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
            String strReturn = WFSUtil.generalError(option, engine, gen, mainCode, subCode, errType, subject, descr);
            return strReturn;
            //throw new WFSException(mainCode, subCode, errType, subject, descr);
        }
        return outputXML.toString();
    }

	private String getNextUnlockedWorkitemUtil(Connection con, XMLParser parser, XMLGenerator gen) throws JTSException, WFSException {
        int mainCode = WFSError.WM_NO_MORE_DATA;
        int subCode = 0;
        ResultSet rs = null;
        String subject = null;
        String descr = null;
        String errType = WFSError.WF_TMP;
        StringBuilder outputXML = new StringBuilder(500);
        String engine = null;
        CallableStatement cstmt = null;
        String queryCallable = null;
        String option = parser.getValueOf("Option", "", false);
        Statement stmt=null;
        boolean bCommit = false;
        try {
            String procInstId = null;
            String procName = null;
            String urn=null;
            int wrkItmId = 0;
            int procDefId = 0;
            int actId = 0;
            int csSessionId = 0;
            int userId = 0;
            String userName;
            int sessionID = parser.getIntOf("SessionId", 0, false);
            int queryTimeout = WFSUtil.getQueryTimeOut();
            engine = parser.getValueOf("EngineName");
            String csName = parser.getValueOf("CSName");
            boolean userDefVarFlag = parser.getValueOf("UserDefVarFlag", "N", true).equalsIgnoreCase("Y");
            boolean isDataExchangeFlag = parser.getValueOf("IsDataExchangeFlag", "N", true).equalsIgnoreCase("Y");
            int q_QueueId = parser.getIntOf("Queueid", -1, true);
            boolean debugFlag = parser.getValueOf("DebugFlag", "N", true).equalsIgnoreCase("Y");
            int dbType = ServerProperty.getReference().getDBType(engine);
            String targetCabinetName = WFSUtil.getTargetCabinetName(con);
			boolean tarHistoryLog= WFSUtil.checkIfHistoryLoggingOnTarget(targetCabinetName);
            if (dbType == JTSConstant.JTS_ORACLE) {
                queryCallable = "{call WFGETNEXTWORKITEMFORUTIL(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,?,?,?)}";
            } else if (dbType == JTSConstant.JTS_MSSQL || dbType == JTSConstant.JTS_POSTGRES) {
                queryCallable = "{call WFGETNEXTWORKITEMFORUTIL(?, ?, ?)}";
            }
            if (con.getAutoCommit()) {
                con.setAutoCommit(false);
                bCommit = true;
            }
            cstmt = con.prepareCall(queryCallable);
            cstmt.setInt(1, sessionID);
            cstmt.setInt(2, q_QueueId);
            cstmt.setString(3, csName);
            if (dbType == JTSConstant.JTS_ORACLE) {
                cstmt.registerOutParameter(4, java.sql.Types.INTEGER);
                cstmt.registerOutParameter(5, java.sql.Types.INTEGER);
                cstmt.registerOutParameter(6, java.sql.Types.INTEGER);
                cstmt.registerOutParameter(7, java.sql.Types.VARCHAR);
                cstmt.registerOutParameter(8, java.sql.Types.VARCHAR);
                cstmt.registerOutParameter(9, java.sql.Types.INTEGER);
                cstmt.registerOutParameter(10, java.sql.Types.INTEGER);
                cstmt.registerOutParameter(11, java.sql.Types.INTEGER);
                cstmt.registerOutParameter(12, java.sql.Types.VARCHAR);
				cstmt.registerOutParameter(13, java.sql.Types.VARCHAR);
				
				if(!tarHistoryLog)
            		cstmt.setString(14, "N");
            	else
            		cstmt.setString(14, "Y");
            	cstmt.setString(15, targetCabinetName);
            }
          /*  if (dbType == JTSConstant.JTS_POSTGRES) {
            	if (con.getAutoCommit()) {
					con.setAutoCommit(false);
				}
            }*/
            
            if(queryTimeout <= 0)
      			cstmt.setQueryTimeout(60);
            else
      			cstmt.setQueryTimeout(queryTimeout);
            cstmt.execute();
            if ((dbType == JTSConstant.JTS_ORACLE)) {
                mainCode = cstmt.getInt(4);
                csSessionId = cstmt.getInt(5);
                userId = cstmt.getInt(6);
                userName = cstmt.getString(7);
                if (mainCode == 0) {
                    procInstId = cstmt.getString(8);
                    wrkItmId = cstmt.getInt(9);
                    procDefId = cstmt.getInt(10);
                    actId = cstmt.getInt(11);
                    procName = cstmt.getString(12);
                    urn=cstmt.getString(13);
                }
            } else if (dbType == JTSConstant.JTS_MSSQL) {
                rs = cstmt.getResultSet();
                if (rs != null && rs.next()) {
                    mainCode = rs.getInt(1);
                    csSessionId = rs.getInt(2);
                    userId = rs.getInt(3);
                    userName = rs.getString(4);
                }
                if (mainCode == 0) {
                    if (rs != null) {
                        rs.close();
                        rs = null;
                    }
                    if (cstmt.getMoreResults()) {
                        rs = cstmt.getResultSet();
                    }
                    if (rs != null && rs.next()) {
                        procInstId = rs.getString(1);
                        wrkItmId = rs.getInt(2);
                        procDefId = rs.getInt(3);
                        actId = rs.getInt(4);
                        procName = rs.getString(5);
                        urn=rs.getString("URN");
                    }
                }

            } else if (dbType == JTSConstant.JTS_POSTGRES) {
            	rs = cstmt.getResultSet();
                if (rs != null && rs.next()) {
                    stmt = con.createStatement();
                    String name = rs.getString(1);
                    name=TO_SANITIZE_STRING(name, true);
                    rs.close();
                    rs = stmt.executeQuery("Fetch All IN \"" + name + "\"");
                    if (rs != null && rs.next()) {
	                    mainCode = rs.getInt(1);
	                    csSessionId = rs.getInt(2);
	                    userId = rs.getInt(3);
	                    userName = rs.getString(4);
	                }
                }
                if (mainCode == 0) {
                    if (rs != null ) {
                    	procInstId = rs.getString("PROCESSINSTANCEID");
		                wrkItmId = rs.getInt("WORKEDITEMID");
		                procDefId = rs.getInt("PROCESSDEFID");
		                actId = rs.getInt("ACTIVITYID");
		                procName = rs.getString("PROCESSNAME");
		                urn=rs.getString("URN");
                    }
                    
                }
                if(rs!=null){
                	rs.close();
                	rs=null;
                }
              /*  if (!con.getAutoCommit()){
                    con.commit();
                    con.setAutoCommit(true);
	            }*/
            }

            if (mainCode == 0) {
                outputXML.append(gen.createOutputFile(option));
                outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
                outputXML.append(gen.writeValueOf("CSSession", String.valueOf(csSessionId)));
                outputXML.append("<Instrument>\n");
                outputXML.append(gen.writeValueOf("ProcessInstanceId", procInstId));
                outputXML.append(gen.writeValueOf("RouteId", String.valueOf(procDefId)));
                outputXML.append(gen.writeValueOf("RouteName", procName));
                outputXML.append(gen.writeValueOf("WorkStageId", String.valueOf(actId)));
                outputXML.append(gen.writeValueOf("WorkItemId", String.valueOf(wrkItmId)));
                outputXML.append(gen.writeValueOf("URN", urn));
                outputXML.append(gen.writeValueOf("CacheTime", new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.US).format(CachedObjectCollection.getReference().getProcessLastModifiedTime(con, engine, procDefId)))); //Bug # 1608
                if( ! isDataExchangeFlag ){
	                if (userDefVarFlag) {
	                    outputXML.append(((String) WFSUtil.fetchAttributesExt(con, 0, 0, procInstId, wrkItmId, "", engine, dbType, gen, "", false, false, false, sessionID, userId, debugFlag)));
	                } else {
	                    outputXML.append(((String) WFSUtil.fetchAttributes(con, 0, 0, procInstId, wrkItmId, "", engine, dbType, gen, "", false, false, false, sessionID, userId, debugFlag)));
	                }
                }

                outputXML.append("</Instrument>\n");
                outputXML.append(gen.closeOutputFile(option));
            } else {
                subCode = 0;
                subject = WFSErrorMsg.getMessage(mainCode);
                errType = WFSError.WF_TMP;
                descr = WFSErrorMsg.getMessage(subCode);
                outputXML.append(WFSUtil.generalError(option, engine, gen, mainCode, subCode, errType, subject, descr));
                mainCode = 0;
            }
            if (bCommit) {
                con.commit();
                con.setAutoCommit(true);
                bCommit = false;
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
            mainCode = WFSError.WF_OPERATION_FAILED;
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
        	try{
	        	if (!con.getAutoCommit()) {
					con.rollback();
					con.setAutoCommit(true);
					bCommit = false;
				}}catch(Exception e){}
            try {
                if (rs != null) {
                    rs.close();
                    rs = null;
                }
            } catch (SQLException ignore) {
            }
            try {
                if (stmt != null) {
                	stmt.close();
                	stmt = null;
                }
            } catch (SQLException ignore) {
            }
            try {
                if (cstmt != null) {
                    cstmt.close();
                    cstmt = null;
                }
            } catch (SQLException ignore) {
            }
            
        }
        if (mainCode != 0) {
            throw new WFSException(mainCode, subCode, errType, subject, descr);
        }
        return outputXML.toString();
    }


 private String WFGetNextWorkitemforSystem(Connection con, XMLParser parser, XMLGenerator gen) throws JTSException, WFSException {
        return getNextUnlockedWorkitemUtil(con, parser, gen);
    }
	

	//----------------------------------------------------------------------------------------------------
	//	Function Name 				    :	WFGetNextWorkitemforPrintFaxMail
	//	Date Written (DD/MM/YYYY)	:	16/05/2002
	//	Author						        :	Prashant
	//	Input Parameters		    	:	Connection , XMLParser , XMLGenerator
	//	Output Parameters			    : none
	//	Return Values				      :	String
	//	Description					      : Get Next Workitem for Print Fax Mail
	//----------------------------------------------------------------------------------------------------
	public String WFGetNextWorkitemforPrintFaxMail(Connection con, XMLParser parser, XMLGenerator gen) throws JTSException, WFSException {
		 return getNextUnlockedWorkitemUtil(con, parser, gen);
	}

	//----------------------------------------------------------------------------------------------------
	//	Function Name 				    :	WFGetNextWorkitemforArchive
	//	Date Written (DD/MM/YYYY)	:	16/05/2002
	//	Author						        :	Prashant
	//	Input Parameters		    	:	Connection , XMLParser , XMLGenerator
	//	Output Parameters			    : none
	//	Return Values				      :	String
	//	Description					      : Get Next Workitem for Archive
	//----------------------------------------------------------------------------------------------------
	public String WFGetNextWorkitemforArchive(Connection con, XMLParser parser, XMLGenerator gen) throws JTSException, WFSException {
		return getNextUnlockedWorkitemUtil(con, parser, gen);
	}

	/** Bugzilla Bug 5096, getNextUnlockedWorkitemUtil overriden for userDefVarFlag - Ruhi Hira */
	private String getNextUnlockedWorkitemUtil(Connection con, String engine, WFParticipant participant, String filterStr, boolean attributeAlso, XMLGenerator gen) throws JTSException, WFSException {
		return getNextUnlockedWorkitemUtil(con, engine, participant, filterStr, attributeAlso, gen, false);
	}

	//----------------------------------------------------------------------------------------------------
	//	Function Name 				    :	getNextUnlockedWorkitemUtil
	//	Date Written (DD/MM/YYYY)		:	09/06/2004
	//	Author						    :	Dinesh Parikh
	//	Input Parameters		    	:	Connection, engineName, participant, filterStr, attributeAlso,  XMLGenerator
	//	Output Parameters			    :	none
	//	Return Values				    :	String
	//	Description					    :	Get Next Unlocked Workitem and lock it.
	//----------------------------------------------------------------------------------------------------
    
    private String getNextUnlockedWorkitemUtil(Connection con, String engine, WFParticipant participant, String filterStr, boolean attributeAlso, XMLGenerator gen, boolean userDefVarFlag) throws JTSException, WFSException {
        return getNextUnlockedWorkitemUtil(con, engine, participant, filterStr, attributeAlso, gen, userDefVarFlag, 0, false);
    }
    
	private String getNextUnlockedWorkitemUtil(Connection con, String engine, WFParticipant participant, String filterStr, boolean attributeAlso, XMLGenerator gen, boolean userDefVarFlag, int sessionId, boolean debug) throws JTSException, WFSException {
		Statement stmt = null;
        PreparedStatement pstmt = null;
		ResultSet rs = null;
		int mainCode = 0;
		int subCode = 0;
		String subject = null;
		String descr = null;
		String errType = WFSError.WF_TMP;
		StringBuffer tempXml = null;		
		try {
			String procInstId = null;
			String procName = null;
			String qName = null;
			String actName = null;
			int wrkItmId = 0;
			int procDefId = 0;
			int actId = 0;
			int qId = 0;
                        String urn= "";
			String lockStatus = null;
            ArrayList parameters = new ArrayList();
            int userId = participant.getid();
            String userName = participant.getname();
            
			int dbType = ServerProperty.getReference().getDBType(engine);
			stmt = con.createStatement();
			StringBuffer queryBuff = new StringBuffer(200);
			//queryBuff.append("Select * from (SELECT ");
			
			/*
			 * 			Change in Query 
			 *  workitem was only fetched instead of being fetched and locked
			 * 	Changed by : Mohnish Chopra
			 * 	Changed on : 24/03/2014
			 * */
            if(dbType == JTSConstant.JTS_MSSQL){
                queryBuff.append(" SELECT * FROM (");
            }else if(dbType == JTSConstant.JTS_ORACLE){
                queryBuff.append("SELECT  ProcessInstanceId, WorkItemId, ProcessDefId, ActivityId, ActivityName, ProcessName, "
                        + "QueueName, Q_QueueId,LockStatus,URN"
                        + "  FROM wfinstrumenttable where wfinstrumenttable.rowid in (SELECT rowid FROM (");
            }else if(dbType == JTSConstant.JTS_POSTGRES){
                 queryBuff.append(" Select * from (Select * from (");
            }
            queryBuff.append("SELECT ");
			queryBuff.append(WFSUtil.getFetchPrefixStr(dbType, 1));
			queryBuff.append(" ProcessInstanceId, WorkItemId, ProcessDefId, ActivityId, ActivityName, ProcessName, QueueName, Q_QueueId , LockStatus,URN ");
			queryBuff.append(" FROM WFInstrumentTable " );
			queryBuff.append(WFSUtil.getLockPrefixStr(dbType));
			queryBuff.append(" WHERE 1 = 1 ");
            queryBuff.append(" AND RoutingStatus = N'N' AND ( LockStatus = N'N' OR (LockStatus = N'Y' AND Q_UserId = ?)) ");
//            queryBuff.append(" FROM WorkListTable WHERE 1 = 1 ");
			queryBuff.append(filterStr);
//			if (dbType == JTSConstant.JTS_POSTGRES){
//				queryBuff.append(" Order By EntryDateTime ASC ");
//				queryBuff.append(WFSUtil.getFetchSuffixStr(dbType, 1, "AND"));
//			}
//			else{
//				queryBuff.append(WFSUtil.getFetchSuffixStr(dbType, 1, "AND"));
//				queryBuff.append(" Order By EntryDateTime ASC ");
//			}
            //queryBuff.append(" Order By EntryDateTime ASC) WorkListTable ");
			queryBuff.append(" Order By EntryDateTime ASC ");
			queryBuff.append(")abc ");
			queryBuff.append(WFSUtil.getFetchSuffixStr(dbType, 1, WFSConstant.QUERY_STR_WHERE));
            if(dbType == JTSConstant.JTS_POSTGRES){
                 queryBuff.append(")def");
            }else if(dbType == JTSConstant.JTS_ORACLE){
                queryBuff.append(")");
            }
            queryBuff.append(WFSUtil.getLockSuffixStr(dbType));
			//queryBuff.append(WFSUtil.getFetchSuffixStr(dbType, 1, WFSConstant.QUERY_STR_WHERE));

//			WFSUtil.printOut(engine,"Select Query In out block"+queryBuff);
            pstmt = con.prepareStatement(queryBuff.toString());
            //WFSUtil.DB_SetString(1, "N", pstmt, dbType);
           // WFSUtil.DB_SetString(2, "N", pstmt, dbType);
		    pstmt.setInt(1,userId);
            parameters.add(userId);
            //parameters.add("N");
            rs = WFSUtil.jdbcExecuteQuery(null, sessionId, userId, queryBuff.toString(), pstmt, parameters, debug, engine);
            parameters.clear();
			//rs = stmt.executeQuery(queryBuff.toString());
			if (rs != null && rs.next()) {
				procInstId = rs.getString("ProcessInstanceId");
				wrkItmId = rs.getInt("WorkItemId");
				procDefId = rs.getInt("ProcessDefId");
				actId = rs.getInt("ActivityId");
				actName = rs.getString("ActivityName");
				procName = rs.getString("ProcessName");
				qName = rs.getString("QueueName");
				qId = rs.getInt("Q_QueueId");
				lockStatus = rs.getString("LockStatus");
                                urn = rs.getString("URN");
                                if(urn == null || "".equals(urn)){
                                    urn = procInstId;
                                }
				rs.close();
				
				if(pstmt != null){
					pstmt.close();
					pstmt = null;
				}

				
//				insqueryBuff.append("Insert into WorkinProcesstable (");
//				insqueryBuff.append("ProcessInstanceId, WorkItemId, ProcessName, ProcessVersion, ");
//				insqueryBuff.append("ProcessDefID, LastProcessedBy, ProcessedBy, ActivityName, ActivityId, EntryDateTime,");
//				insqueryBuff.append("ParentWorkItemId, AssignmentType, CollectFlag, PriorityLevel, ValidTill, Q_StreamId, Q_QueueId");
//				insqueryBuff.append(",Q_UserId,AssignedUser,FilterValue,CreatedDateTime,WorkItemState,");
//				insqueryBuff.append("Statename,ExpectedWorkitemDelay,PreviousStage,LockedByName,LockStatus,LockedTime,");
//				insqueryBuff.append("Queuename,Queuetype, ProcessVariantId) Select ");
//				insqueryBuff.append("ProcessInstanceId, WorkItemId, ProcessName, ProcessVersion, ");
//				insqueryBuff.append("ProcessDefID, LastProcessedBy, ProcessedBy, ActivityName, ActivityId, EntryDateTime,");
//				insqueryBuff.append("ParentWorkItemId, AssignmentType, CollectFlag, PriorityLevel, ValidTill, Q_StreamId, Q_QueueId,");
//				insqueryBuff.append(participant.getid() + ", ");
//				// Tirupati Srivastava : changes made to make code compatible with postgreSQL
//				//insqueryBuff.append(WFSConstant.WF_VARCHARPREFIX + participant.getname());
//				insqueryBuff.append(TO_STRING(participant.getname(), true, dbType));
//				//insqueryBuff.append("',FilterValue, CreatedDateTime, 2 as State ," + WFSConstant.WF_VARCHARPREFIX + WFSConstant.WF_RUNNING + "' as Statename" /*Statename*/ + ", ExpectedWorkitemDelay,PreviousStage,");
//				insqueryBuff.append(",FilterValue, CreatedDateTime, 2 as State ," + TO_STRING(WFSConstant.WF_RUNNING, true, dbType) + " as Statename" /*Statename*/ + ", ExpectedWorkitemDelay,PreviousStage,");
//				//insqueryBuff.append(WFSConstant.WF_VARCHARPREFIX + participant.getname());
//				insqueryBuff.append(TO_STRING(participant.getname(), true, dbType));
//				insqueryBuff.append(",N'Y',");
//				insqueryBuff.append(WFSUtil.getDate(dbType));
//				insqueryBuff.append(",Queuename,Queuetype, ProcessVariantId FROM Worklisttable ");
//				insqueryBuff.append(WFSUtil.getLockPrefixStr(dbType));
//				//insqueryBuff.append(" WHERE ProcessInstanceId = ").append(WFSConstant.WF_VARCHARPREFIX).append(procInstId).append("' ");
//				insqueryBuff.append(" WHERE ProcessInstanceId = " + TO_STRING(procInstId, true, dbType));
//				insqueryBuff.append(" AND WorkItemId = " + wrkItmId);
				if(lockStatus != null && lockStatus.trim().equalsIgnoreCase("N")){
					StringBuffer insqueryBuff = new StringBuffer(500);
					insqueryBuff.append("update WFInstrumentTable set Q_UserId=?,AssignedUser=?,WorkItemState=?,Statename=?,LockedByName=?,LockStatus=?," + "LockedTime=").append(WFSUtil.getDate(dbType)).append(",RoutingStatus =? WHERE ProcessInstanceId = ? AND WorkItemId = ? and RoutingStatus = ? and LockStatus =? ");
					pstmt = con.prepareStatement(insqueryBuff.toString());
					pstmt.setInt(1,userId);
					WFSUtil.DB_SetString(2, participant.gettype()=='P' ? "System" : userName, pstmt, dbType);
					pstmt.setInt(3,2);
					WFSUtil.DB_SetString(4, WFSConstant.WF_RUNNING, pstmt, dbType);
					WFSUtil.DB_SetString(5, participant.gettype()=='P' ? "System" : userName, pstmt, dbType);
					WFSUtil.DB_SetString(6, "Y", pstmt, dbType);
					WFSUtil.DB_SetString(7, "N", pstmt, dbType);
					WFSUtil.DB_SetString(8, procInstId, pstmt, dbType);
					pstmt.setInt(9,wrkItmId);
					WFSUtil.DB_SetString(10, "N", pstmt, dbType);
					WFSUtil.DB_SetString(11, "N", pstmt, dbType);
					parameters.add(userId);
					parameters.add(participant.gettype()=='P' ? "System" : userName);
					parameters.add(2);
					parameters.add(WFSConstant.WF_RUNNING);
					parameters.add(participant.gettype()=='P' ? "System" : userName);
					parameters.add("Y");
					parameters.add("N");
					parameters.add(procInstId);
					parameters.add(wrkItmId);
					parameters.add("N");
					parameters.add("N");
					
					/** @todo for update missing,
					 * Not required as concurrency handled with rollback on the
					 * basis of result of insert and delete - Ruhi Hira */
					// Bug # WFS_6.1_052, FOR UPDATE does not work with Insert.
	//				if(dbType == JTSConstant.JTS_ORACLE)
	//					insqueryBuff.append(" FOR UPDATE");
					if (con.getAutoCommit()) {
						con.setAutoCommit(false);
					}

	//				WFSUtil.printOut(engine,"Insert Query "+insqueryBuff);
					int result = WFSUtil.jdbcExecuteUpdate(procInstId, sessionId, userId, insqueryBuff.toString(), pstmt, parameters, debug, engine);
					parameters.clear();
					//int result = stmt.executeUpdate(insqueryBuff.toString());

	//				WFSUtil.printOut(engine,"Result of insert " + result);

					if (result > 0) {
	//					StringBuffer delqueryBuff = new StringBuffer(200);
	//					delqueryBuff.append("DELETE FROM Worklisttable ");
	//					//delqueryBuff.append("WHERE ProcessInstanceId = ").append(WFSConstant.WF_VARCHARPREFIX).append(procInstId).append("' ");
	//					delqueryBuff.append(" WHERE ProcessInstanceId = " + TO_STRING(procInstId, true, dbType));
	//					delqueryBuff.append(" AND WorkItemId = " + wrkItmId);
	//
	////					WFSUtil.printOut(engine,"Delete Query "+delqueryBuff);
	//
	//					result = stmt.executeUpdate(delqueryBuff.toString());

	//					WFSUtil.printOut(engine,"Result of delete " + result);

						//if (result > 0) {
							if (!con.getAutoCommit()) {
								con.commit();
								con.setAutoCommit(true);
							}
                                                        if(participant.gettype()=='P'){
                                                            userName = "System";
                                                            userId = 0;
                                                        }
							// maincode = 0 As row inserted in workinprocess and deleted from worklist successfully.
							WFSUtil.generateLog(engine, con, WFSConstant.WFL_WorkItemLock, procInstId, wrkItmId, procDefId, actId, actName,
									qId, userId, userName, 0, qName, null, null, null, null);
						} else {
							if (!con.getAutoCommit()) {
								con.rollback();
								con.setAutoCommit(true);
							}
							mainCode = WFSError.WM_NO_MORE_DATA;
						}
				}	
//				} else {
//					mainCode = WFSError.WM_NO_MORE_DATA;
//				}
			}else{
				mainCode = WFSError.WM_NO_MORE_DATA;
			} 
			/*else {
				
				//try finding it in WorkInProcessTable, may be some items are there in WorkInProcesTable left due to some error
				//
				 // 			Change in Query 
				 //  workitem was only fetched instead of being fetched and locked
				 // 	Changed by : Mohnish Chopra
				 // 	Changed on : 24/03/2014
				 
				queryBuff = new StringBuffer(200);
                queryBuff.append("SELECT ");
				//queryBuff.append("Select * from (SELECT ");
				queryBuff.append(WFSUtil.getFetchPrefixStr(dbType, 1));
				queryBuff.append(" ProcessInstanceId, WorkItemId, ProcessDefId, ActivityId, ActivityName, ProcessName, QueueName, Q_QueueId ");
                queryBuff.append(" FROM WFInstrumentTable " );
                queryBuff.append(WFSUtil.getLockPrefixStr(dbType));
                queryBuff.append(" WHERE Q_UserId = ");
				//queryBuff.append(" FROM WorkInProcessTable WHERE Q_UserId = ");
				queryBuff.append(participant.getid());
                queryBuff.append(" AND LockStatus =? AND RoutingStatus = ? ");
				queryBuff.append(filterStr);
				//queryBuff.append(" Order By EntryDateTime ASC) WorkInProcessTable");
                queryBuff.append(WFSUtil.getFetchSuffixStr(dbType, 1, " And "));
                queryBuff.append(" Order By EntryDateTime ASC");
				//queryBuff.append(WFSUtil.getFetchSuffixStr(dbType, 1, WFSConstant.QUERY_STR_WHERE));
                queryBuff.append(WFSUtil.getLockSuffixStr(dbType));

//				WFSUtil.printOut(engine,"Select Query In ELSE block"+queryBuff);
                pstmt = con.prepareStatement(queryBuff.toString());
               // pstmt.setInt(1,userId);
                WFSUtil.DB_SetString(1, "Y", pstmt, dbType);
                WFSUtil.DB_SetString(2, "N", pstmt, dbType);
                parameters.add(userId);
                parameters.add("Y");
                parameters.add("N");
                rs = WFSUtil.jdbcExecuteQuery(null, sessionId, userId, queryBuff.toString(), pstmt, parameters, debug, engine);
                parameters.clear();
				//rs = stmt.executeQuery(queryBuff.toString());
				if (rs != null && rs.next()) {
					procInstId = rs.getString("ProcessInstanceId");
					wrkItmId = rs.getInt("WorkItemId");
					procDefId = rs.getInt("ProcessDefId");
					actId = rs.getInt("ActivityId");
					actName = rs.getString("ActivityName");
					procName = rs.getString("ProcessName");
					qName = rs.getString("QueueName");
					qId = rs.getInt("Q_QueueId");

					rs.close();
				} else {
					mainCode = WFSError.WM_NO_MORE_DATA;
				}
			}*/


			if (mainCode == 0) {
				tempXml = new StringBuffer(500);
				tempXml.append("<Instrument>\n");
				tempXml.append(gen.writeValueOf("ProcessInstanceId", procInstId));
				tempXml.append(gen.writeValueOf("RouteId", String.valueOf(procDefId)));
				tempXml.append(gen.writeValueOf("RouteName", procName));
                                tempXml.append(gen.writeValueOf("URN", urn));
				tempXml.append(gen.writeValueOf("WorkStageId", String.valueOf(actId)));
				tempXml.append(gen.writeValueOf("WorkItemId", String.valueOf(wrkItmId)));
				tempXml.append(gen.writeValueOf("CacheTime", new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.US).format(CachedObjectCollection.getReference().getProcessLastModifiedTime(con, engine, procDefId)))); //Bug # 1608
				if (attributeAlso) {
					if (userDefVarFlag) {
                        tempXml.append(((String) WFSUtil.fetchAttributesExt(con, 0,0, procInstId, wrkItmId, "", engine, dbType, gen, "", false, false, false,0,sessionId,userId,debug)));
						//tempXml.append(((String) WFSUtil.fetchAttributesExt(con, procInstId, wrkItmId, "", engine, dbType, gen, "", false, false)));
					} else {
                        tempXml.append(((String) WFSUtil.fetchAttributes(con, 0,0,procInstId, wrkItmId, "", engine, dbType, gen, "", false, false, false, sessionId, userId, debug)));
						//tempXml.append(((String) WFSUtil.fetchAttributes(con, procInstId, wrkItmId, "", engine, dbType, gen, "", false, false)));
					}
				}
				tempXml.append("</Instrument>\n");
			} else {
				subCode = 0;
				subject = WFSErrorMsg.getMessage(mainCode);
				errType = WFSError.WF_TMP;
				descr = WFSErrorMsg.getMessage(subCode);
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
			try {
				if (mainCode != 0) {
					if (!con.getAutoCommit()) {
						con.rollback();
						con.setAutoCommit(true);
					}
				} else {
					if (!con.getAutoCommit()) {
						con.commit();
						con.setAutoCommit(true);
					}
				}
			} catch (Exception e) {
			}
			
		}
		if (mainCode != 0) {
			throw new WFSException(mainCode, subCode, errType, subject, descr);
		}
		return tempXml.toString();
	}

	//----------------------------------------------------------------------------------------------------
	//	Function Name 				    :	WFGetNextUnlockedWorkitem
	//	Date Written (DD/MM/YYYY)	:	16/05/2002
	//	Author						        :	Prashant
	//	Input Parameters		    	:	Connection , XMLParser , XMLGenerator
	//	Output Parameters			    : none
	//	Return Values				      :	String
	//	Description					      : Get Next Unlocked Workitem and lock it.
	//----------------------------------------------------------------------------------------------------
	// --------------------------------------------------------------------------------------
	// Changed On  : 06/06/2005
	// Changed By  : Ashish Mangla
	// Description : Make 3 queries on the tables directly instead of view which is making queries slow
	// --------------------------------------------------------------------------------------
    
    public String getNextUnlockedWorkitem(Connection con, String engine, WFParticipant participant,
			int queueid, String filterStr, XMLGenerator gen, boolean dataFlag) throws JTSException, WFSException {
        return getNextUnlockedWorkitem(con, engine, participant,queueid, filterStr, gen, dataFlag, 0, false);
    }
	public String getNextUnlockedWorkitem(Connection con, String engine, WFParticipant participant,
			int queueid, String filterStr, XMLGenerator gen, boolean dataFlag, int sessionId, boolean debug) throws JTSException, WFSException {
		Statement stmt = null;
        PreparedStatement pstmt = null;
		ResultSet rs = null;
		int mainCode = 0;
		int subCode = 0;
		int groupId = -1;
		String subject = null;
		String descr = null;
		String errType = WFSError.WF_TMP;
		StringBuffer tempXml = new StringBuffer("");
		char char21 = 21;
		String string21 = "" + char21;
		try {
			int dbType = ServerProperty.getReference().getDBType(engine);
			if (participant != null && participant.gettype() == 'U') {
				int userid = participant.getid();
				String username = participant.getname();
				String tempStr = "";
				char QType = '\0';
				int orderBy;
				String sortOrder = null;
				String columnName = null;
				String queueFilter = "";
				//String turnAroundTime = null;

				stmt = con.createStatement();
				StringBuffer strQuery = new StringBuffer(500);
                ArrayList parameters = new ArrayList();
				strQuery.append("Select");
				strQuery.append(WFSUtil.getFetchPrefixStr(dbType, 1));
				//Process Variant Support Changes
				strQuery.append(" ProcessInstanceId, ProcessInstanceId as WorkItemName, ProcessDefId, ProcessName, ActivityId, ActivityName, PriorityLevel, LockStatus, LockedByName, ValidTill, StateName, EntryDateTime, LockedTime, AssignedUser ,WorkItemId , QueueName , AssignmentType , QueueType , Q_QueueID, ExpectedWorkitemDelay, ProcessVariantId ,URN");
				//strQuery.append(" From WORKINPROCESSTABLE " + WFSUtil.getTableLockHintStr(dbType));
                strQuery.append(" From WFInstrumentTable ").append(WFSUtil.getTableLockHintStr(dbType));
				//end WFS_6_015 make queries on table instead on view
				strQuery.append(" Where Q_Userid =?");
				//strQuery.append(userid);
				strQuery.append(" And Q_QueueId = ?");
				//strQuery.append(queueid);
				strQuery.append(" And LockedByName = ?");
				//strQuery.append(TO_STRING(username, true, dbType));
                strQuery.append(" And RoutingStatus = ?");
				//strQuery.append(TO_STRING("N", true, dbType));
                strQuery.append(" And LockStatus = ?");
				//strQuery.append(TO_STRING("Y", true, dbType));
				strQuery.append(filterStr);
				strQuery.append(WFSUtil.getFetchSuffixStr(dbType, 1, WFSConstant.QUERY_STR_AND));
				strQuery.append(WFSUtil.getQueryLockHintStr(dbType));
                
				WFSUtil.printOut(engine,strQuery.toString());
                pstmt = con.prepareStatement(strQuery.toString());
                pstmt.setInt(1,userid);
                pstmt.setInt(2,queueid);
                WFSUtil.DB_SetString(3, username, pstmt, dbType);
                WFSUtil.DB_SetString(4, "N", pstmt, dbType);
                WFSUtil.DB_SetString(5, "Y", pstmt, dbType);
                parameters.add(userid);
                parameters.add(queueid);
                parameters.add(username);
                parameters.add("N");
                parameters.add("Y");
                rs = WFSUtil.jdbcExecuteQuery(null, sessionId, userid, strQuery.toString(), pstmt, parameters, debug, engine);
                parameters.clear();
				//rs = stmt.executeQuery(strQuery.toString());
				if (rs != null && !rs.next()) {
					rs.close();
					rs = null;
					if (queueid > 0) {
						StringBuffer strNextQuery = new StringBuffer(100);
						strNextQuery.append("Select QueueType, QueueFilter, OrderBy, SortOrder From QueueDefTable " + WFSUtil.getTableLockHintStr(dbType) + " where QueueId = ");
						strNextQuery.append(queueid);
						rs = stmt.executeQuery(strNextQuery.toString());
						if (rs != null && rs.next()) {
							tempStr = rs.getString("QueueType");
                            QType = rs.wasNull() ? '\0' : tempStr.charAt(0);
							tempStr = rs.getString("QueueFilter");
							queueFilter = rs.wasNull() ? "" : tempStr;
							orderBy = rs.getInt("OrderBy");
							sortOrder = rs.getString("SortOrder");
							if (rs.wasNull()) {
								sortOrder = "A";
							}
							
							if (rs != null) {
								rs.close();
								rs = null;
							}
							boolean bJoinPIT = false;
							boolean bJoinQDT = false;
							if (QType == 'F') {
								String secondOrderBy = null;
								switch(orderBy){
									case 1:
										columnName = " PriorityLevel ";
										break;
									case 2:  
										columnName = " ProcessInstanceId ";
										break;
									case 3:
										columnName = " ActivityName ";
										break;			
									case 4:
										columnName = " LockedByName ";
										break;
									case 5:
										columnName = " IntroducedBy "; // PIT
										bJoinPIT = true;
										break;
									case 6:			 	 
										columnName = " InstrumentStatus "; // QDT
										bJoinQDT = true;
										break;
									case 7:
										columnName = " CheckListCompleteFlag "; // QDT
										bJoinQDT = true;
										break;
									case 8: 
										columnName = " LockStatus ";
										break;
									case 9:
										columnName = " WorkItemState ";
										break;
									case 10:
										columnName = " EntryDateTime ";
										break;
									case 11: 
										columnName = " ValidTill ";
										break;
									case 12:			 
										columnName = " LockedTime ";
										break;
									case 13: 
										columnName = " IntroductionDateTime "; // PIT
										bJoinPIT = true;
										break;
									case 17: 
										columnName = " Status "; // QDT
										bJoinQDT = true;
										break;
									case 18:
										columnName = " CreatedDateTime ";
										break;
									case 19:
										columnName = " ExpectedWorkItemDelay ";
										break;
									case 20:
										columnName = " ProcessedBy ";
										break;
									case 101:
										columnName = " VAR_INT1 ";
										bJoinQDT = true;
										break;
									case 102:
										columnName = " VAR_INT2 ";
										bJoinQDT = true;
										break;
									case 103:
										columnName = " VAR_INT3 ";
										bJoinQDT = true;
										break;
									case 104:
										columnName = " VAR_INT4 ";
										bJoinQDT = true;
										break;
									case 105:
										columnName = " VAR_INT5 ";
										bJoinQDT = true;
										break;
									case 106:
										columnName = " VAR_INT6 ";
										bJoinQDT = true;
										break;
									case 107:
										columnName = " VAR_INT7 ";
										bJoinQDT = true;
										break;
									case 108:
										columnName = " VAR_INT8 ";
										bJoinQDT = true;
										break;
									case 109:
										columnName = " VAR_FLOAT1 ";
										bJoinQDT = true;
										break;
									case 110:
										columnName = " VAR_FLOAT2 ";
										bJoinQDT = true;
										break;
									case 111:
										columnName = " VAR_DATE1 ";
										bJoinQDT = true;
										break;
									case 112:
										columnName = " VAR_DATE2 ";
										bJoinQDT = true;
										break;
									case 113:
										columnName = " VAR_DATE3 ";
										bJoinQDT = true;
										break;
									case 114:
										columnName = " VAR_DATE4 ";
										bJoinQDT = true;
										break;
									case 115:
										columnName = " VAR_LONG1 ";
										bJoinQDT = true;
										break;
									case 116:
										columnName = " VAR_LONG2 ";
										bJoinQDT = true;
										break;
									case 117:
										columnName = " VAR_LONG3 ";
										bJoinQDT = true;
										break;
									case 118:
										columnName = " VAR_LONG4 ";
										bJoinQDT = true;
										break;
									case 119:
										columnName = " VAR_STR1 ";
										bJoinQDT = true;
										break;
									case 120:
										columnName = " VAR_STR2 ";
										bJoinQDT = true;
										break;
									case 121:
										columnName = " VAR_STR3 ";
										bJoinQDT = true;
										break;
									case 122:
										columnName = " VAR_STR4 ";
										bJoinQDT = true;
										break;
									case 123:
										columnName = " VAR_STR5 ";
										bJoinQDT = true;
										break;
									case 124:
										columnName = " VAR_STR6 ";
										bJoinQDT = true;
										break;
									case 125:
										columnName = " VAR_STR7 ";
										bJoinQDT = true;
										break;
									case 126:
										columnName = " VAR_STR8 ";
										bJoinQDT = true;
										break;
									default:
										//columnName = "WorkListTable.Entrydatetime ";
                                        columnName = "Entrydatetime ";
										break;
								}
								String orderbyStr = " ORDER BY q_queueid,RoutingStatus,LockStatus, " + columnName + (sortOrder.equals("A")?  " ASC " : " DESC "); //If Query filter says to Order By ProcessINstanceId, ambiguity will be there and user should write explicitely
								orderbyStr += (secondOrderBy == null ? "" : "," + secondOrderBy);
								
								StringBuffer strSubQuery = new StringBuffer(100);
								//Check for user validity in FIFO Queue
								strSubQuery.append(" Select QueueID From Qusergroupview Where userID =");
								strSubQuery.append(userid);
								strSubQuery.append(" And QueueId = ");
								strSubQuery.append(queueid);
								rs = stmt.executeQuery(strSubQuery.toString());
								if (rs != null && rs.next()) {
									rs.close();
									rs = null;
									/////////////////////////// GET THE USER FILTER TO BE APPENDED......
									String innerOrderBy = "";
									String queryFilter = "";
									String[] result = null;
									result = WFSUtil.getQueryFilter(con, queueid, dbType, participant, queueFilter, engine);
									queryFilter = result[0];
									innerOrderBy = result[1];

									//	Remove order by from filter value ..... Keep it in different variable
									//	Now we have got innerOrder by and Query Filter differently....
									//just use this order by if exists if
									//////////////////////////
									strSubQuery = new StringBuffer(100);
									//	strSubQuery.append(" SELECT * FROM (");
	                                    if(dbType == JTSConstant.JTS_MSSQL){
	                                        strSubQuery.append(" SELECT * FROM (");
	                                    }else if(dbType == JTSConstant.JTS_ORACLE){
	                                        strSubQuery.append("SELECT ProcessInstanceId , WorkitemId  FROM wfinstrumenttable ");
	                                    }else if(dbType == JTSConstant.JTS_POSTGRES){
	                                         strSubQuery.append(" Select * from (Select * from (");
	                                    }
	                                    if(dbType == JTSConstant.JTS_MSSQL || dbType == JTSConstant.JTS_POSTGRES){
										strSubQuery.append(" Select ");
										strSubQuery.append(WFSUtil.getFetchPrefixStr(dbType, 1));
	                                    strSubQuery.append(" ProcessInstanceId , WorkitemId ");
										//strSubQuery.append(" WorkListTable.ProcessInstanceId , WorkListTable.WorkitemId ");
	                                    strSubQuery.append(" From WFInstrumentTable ");
										//strSubQuery.append(" From WorkListTable  ");
										strSubQuery.append(WFSUtil.getLockPrefixStr(dbType));
	                                    }
										//strSubQuery.append((queryFilter.trim().equals("") && innerOrderBy.trim().equals("") && !bJoinQDT) ? "" : " , QueueDataTable " + WFSUtil.getTableLockHintStr(dbType)); 
										//strSubQuery.append(!bJoinPIT ? "" : " , ProcessInstanceTable " + WFSUtil.getTableLockHintStr(dbType));
										// SRNo-6, Changed By Mandeep, lockStatus condition removed as GetNextUnlockedWorkitem' query was taking time.
										//if(dbType == JTSConstant.JTS_ORACLE){
	                                     //   strSubQuery.append(WFSUtil.getFetchSuffixStr(dbType, 1, WFSConstant.QUERY_STR_WHERE));
	                                     //   strSubQuery.append(" AND ");
	                                   // }else
	                                        strSubQuery.append(" Where ");
	                                    strSubQuery.append(" Q_QueueId = ?");
										//strSubQuery.append(queueid);
	                                    /*Workitem which has routingStatus as N and LockStatus as N have workitemstate <3, So no need to put extra filter in query-- Shweta Singhal*/
										//strSubQuery.append(" And WorkItemState < 3 ");
										strSubQuery.append(" And RoutingStatus = "+WFSUtil.TO_STRING("N", true, dbType));
										strSubQuery.append(" And LockStatus = "+WFSUtil.TO_STRING("N", true, dbType));
										
										if(dbType == JTSConstant.JTS_ORACLE){
		                                	   strSubQuery.append(WFSUtil.getFetchSuffixStr(dbType, 1, WFSConstant.QUERY_STR_AND));
		                                   }
										//strSubQuery.append((queryFilter.trim().equals("") && innerOrderBy.trim().equals("") && !bJoinQDT) ? "" : " AND WorkListTable.ProcessInstanceId = QueueDataTable.ProcessInstanceId AND WorkListTable.WorkItemId = QueueDataTable.WorkItemId ");
										//strSubQuery.append(!bJoinPIT ? "" :" AND WorkListTable.ProcessInstanceId = ProcessInstanceTable.ProcessInstanceId ");
										strSubQuery.append(queryFilter.trim().equals("") ? "" : "  AND ( " + queryFilter + " ) ");
										//Changes for Postgres
										//if (dbType == JTSConstant.JTS_POSTGRES){
										//strSubQuery.append(innerOrderBy.trim().equals("") ? orderbyStr : " ORDER BY " + innerOrderBy);
										//strSubQuery.append(WFSUtil.getFetchSuffixStr(dbType, 1, WFSConstant.QUERY_STR_AND));
										//}
										//else{
										//strSubQuery.append(WFSUtil.getFetchSuffixStr(dbType, 1, WFSConstant.QUERY_STR_AND));
										//strSubQuery.append(innerOrderBy.trim().equals("") ? orderbyStr : " ORDER BY " + innerOrderBy);
										//}
	                                   strSubQuery.append(WFSUtil.TO_SANITIZE_STRING(innerOrderBy, true).trim().equals("") ? orderbyStr : " ORDER BY " + WFSUtil.TO_SANITIZE_STRING(innerOrderBy, true));
										/** @todo For UPDATE Missing
										 * Not required as concurrency handled with rollback on the
										 * basis of result of insert and delete - Ruhi Hira */
										//strSubQuery.append(") WorkListTable ");
										//strSubQuery.append(WFSUtil.getFetchSuffixStr(dbType, 1, WFSConstant.QUERY_STR_WHERE));
									    //if(dbType == JTSConstant.JTS_ORACLE)
										//strSubQuery.append( WFSUtil.getLockSuffixStr(dbType) );
	                                   
	                                   if(dbType == JTSConstant.JTS_MSSQL || dbType == JTSConstant.JTS_POSTGRES){
	                                   strSubQuery.append(")abc ");
	                                   strSubQuery.append(WFSUtil.getFetchSuffixStr(dbType, 1, WFSConstant.QUERY_STR_WHERE));
	                                   }
	                                    if(dbType == JTSConstant.JTS_POSTGRES){
	                                        strSubQuery.append(")def");
	                                   }
	                                   strSubQuery.append( WFSUtil.getLockSuffixStr(dbType) );
										if (con.getAutoCommit()) {
											con.setAutoCommit(false);
										}
										strSubQuery.append(WFSUtil.getQueryLockHintStr(dbType));
	                                    pstmt = con.prepareStatement(WFSUtil.TO_SANITIZE_STRING(strSubQuery.toString(),true));
	                                    pstmt.setInt(1,queueid);
	                                    parameters.add(queueid);
	                                    rs = WFSUtil.jdbcExecuteQuery(null, sessionId, userid, strSubQuery.toString(), pstmt, parameters, debug, engine);
										parameters.clear();
									//rs = stmt.executeQuery(strSubQuery.toString());
									strSubQuery = new StringBuffer(50);
									int counter = 0;
									if (rs != null) {
										while (rs.next()) {

											if (counter == 0) {
												strSubQuery.append(" ( ProcessInstanceid = ");
												//strSubQuery.append(WFSConstant.WF_VARCHARPREFIX);
												//strSubQuery.append(rs.getString(1));
												strSubQuery.append(TO_STRING(rs.getString(1), true, dbType));
												strSubQuery.append(" AND WorkitemId = ");
												strSubQuery.append(rs.getInt(2));
												strSubQuery.append(")");
											} else if (counter > 0 && counter < 5) {
												strSubQuery.append(" OR ");
												strSubQuery.append(" ( ProcessInstanceid = ");
												//strSubQuery.append(WFSConstant.WF_VARCHARPREFIX);
												//strSubQuery.append(rs.getString(1));
												strSubQuery.append(TO_STRING(rs.getString(1), true, dbType));
												strSubQuery.append(" AND WorkitemId = ");
												strSubQuery.append(rs.getInt(2));
												strSubQuery.append(")");
											}
											counter++;
										}
										rs.close();
										rs = null;
									}
									if (counter == 0) {
										mainCode = WFSError.WM_NO_MORE_DATA;
									} else { // Tirupati Srivastava : changes made to make code compatible with postgreSQL
										strNextQuery = new StringBuffer(500);
										long time = System.currentTimeMillis();
//										strNextQuery.append("Insert into WorkinProcesstable (ProcessInstanceId,WorkItemId,ProcessName,ProcessVersion,ProcessDefID,LastProcessedBy,ProcessedBy,ActivityName,ActivityId,EntryDateTime,"); /*strNextQuery.append("ParentWorkItemId,AssignmentType,CollectFlag,PriorityLevel,ValidTill,Q_StreamId,Q_QueueId,Q_UserId," + "AssignedUser,FilterValue,CreatedDateTime,WorkItemState,Statename,ExpectedWorkitemDelay,PreviousStage,LockedByName,LockStatus,LockedTime,Queuename,Queuetype,guid) Select ProcessInstanceId,WorkItemId,ProcessName,ProcessVersion,ProcessDefID,LastProcessedBy,ProcessedBy," +                "ActivityName,ActivityId,EntryDateTime,ParentWorkItemId,AssignmentType,CollectFlag,PriorityLevel,ValidTill,Q_StreamId,Q_QueueId," + userid + " as userid," + WFSConstant.WF_VARCHARPREFIX + username + "' as username ,FilterValue,CreatedDateTime,2 as State ," + WFSConstant.WF_VARCHARPREFIX + WFSConstant.WF_RUNNING + "' as Statename," /*Statename,"*/
//										
//										/*);*/
//										//Process Variant Support Changes
//										strNextQuery.append("ParentWorkItemId,AssignmentType,CollectFlag,PriorityLevel,ValidTill,Q_StreamId,Q_QueueId,Q_UserId," +
//												"AssignedUser,FilterValue,CreatedDateTime,WorkItemState,Statename,ExpectedWorkitemDelay,PreviousStage,LockedByName,LockStatus,LockedTime,Queuename,Queuetype,guid, ProcessVariantId) Select ProcessInstanceId,WorkItemId,ProcessName,ProcessVersion,ProcessDefID,LastProcessedBy,ProcessedBy," +
//												"ActivityName,ActivityId,EntryDateTime,ParentWorkItemId,AssignmentType,CollectFlag,PriorityLevel,ValidTill,Q_StreamId,Q_QueueId," + userid + " as userid, " + TO_STRING(username, true, dbType) + " as username ,FilterValue,CreatedDateTime,2 as State , " + TO_STRING(WFSConstant.WF_RUNNING, true, dbType) + " as Statename," /*Statename,"*/);
//										/*strNextQuery.append("ExpectedWorkitemDelay,PreviousStage," + WFSConstant.WF_VARCHARPREFIX + username + "' as username1 ,'Y' as LockStatus," + WFSUtil.getDate(dbType) + ",Queuename,Queuetype, " + time + " as guid from Worklisttable " + WFSUtil.getTableLockHintStr(dbType));*/
//										//Process Variant Support Changes
//										strNextQuery.append("ExpectedWorkitemDelay,PreviousStage," + TO_STRING(username, true, dbType) + " as username1 ,'Y' as LockStatus," + WFSUtil.getDate(dbType) + ",Queuename,Queuetype, " + time + " as guid, ProcessVariantId from Worklisttable " + WFSUtil.getTableLockHintStr(dbType));
                                        strNextQuery.append("update WFInstrumentTable set Q_UserId=?,AssignedUser=?,WorkItemState=?,Statename=?,LockedByName=?,LockStatus=?,"
                                                + "LockedTime="+WFSUtil.getDate(dbType)+",guid = "+time+" ");
                                        /*Table lock removed as its an update query*/
                                        //strNextQuery.append(WFSUtil.getTableLockHintStr(dbType));
										strNextQuery.append(" Where ");
										strNextQuery.append(strSubQuery);
										//strNextQuery.append(WFSUtil.getQueryLockHintStr(dbType));
//								strNextQuery.append(")");
										// Bug # WFS_5_048, Changed By Ruhi, lockStatus condition removed.
                                        pstmt = con.prepareStatement(strNextQuery.toString());
                                        pstmt.setInt(1,userid);
                                        WFSUtil.DB_SetString(2, username, pstmt, dbType);
                                        pstmt.setInt(3,2);
                                        WFSUtil.DB_SetString(4, WFSConstant.WF_RUNNING, pstmt, dbType);
                                        WFSUtil.DB_SetString(5, username, pstmt, dbType);
                                        WFSUtil.DB_SetString(6, "Y", pstmt, dbType);
                                        //pstmt.setLong(7,time);
                                        parameters.add(userid);
                                        parameters.add(username);
                                        parameters.add(2);
                                        parameters.add(WFSConstant.WF_RUNNING);
                                        parameters.add(username);
                                        parameters.add("Y");
                                        //parameters.add(time);
                                        int res = WFSUtil.jdbcExecuteUpdate(null, sessionId, userid, strNextQuery.toString(), pstmt, parameters, debug, engine);        
                                        parameters.clear();
										//int res = stmt.executeUpdate(strNextQuery.toString());
										/* Changed By - Ruhi Hira, on - Dec 07' 2005, Bug # WFS_5_088. */
										if (res > 0) {
//											int f = stmt.executeUpdate("Delete from Worklisttable where " + strSubQuery);
//											if (f > 0) {
												if (!con.getAutoCommit()) {
													con.commit();
													con.setAutoCommit(true);
												}
                                                pstmt = con.prepareStatement(strQuery.toString());
                                                pstmt.setInt(1,userid);
                                                pstmt.setInt(2,queueid);
                                                WFSUtil.DB_SetString(3, username, pstmt, dbType);
                                                WFSUtil.DB_SetString(4, "N", pstmt, dbType);
                                                WFSUtil.DB_SetString(5, "Y", pstmt, dbType);
                                                parameters.add(userid);
                                                parameters.add(queueid);
                                                parameters.add(username);
                                                parameters.add("N");
                                                parameters.add("Y");
                                                rs = WFSUtil.jdbcExecuteQuery(null, sessionId, userid, strQuery.toString(), pstmt, parameters, debug, engine);
                                                parameters.clear();
												//rs = stmt.executeQuery(strQuery.toString());
                                                
												if (rs != null && !rs.next()) {
													mainCode = WFSError.WM_NO_MORE_DATA;
													if (rs != null) {
														rs.close();
														rs = null;
													}
												}
//											} else {
//												mainCode = WFSError.WM_NO_MORE_DATA;
//												if (!con.getAutoCommit()) {
//													con.rollback();
//													con.setAutoCommit(true);
//												}
//											}
										} else {
											mainCode = WFSError.WM_NO_MORE_DATA;
											if (!con.getAutoCommit()) {
												con.rollback();
												con.setAutoCommit(true);
											}
										}
									}
								} else {
									mainCode = WFSError.WF_NO_AUTHORIZATION;
									if (rs != null) {
										rs.close();
										rs = null;
									}
								}
							} else {
								mainCode = WFSError.WM_NO_MORE_DATA_FOR_SPECIFIED_QUEUE;
							}
						} else {
							mainCode = WFSError.WM_NO_MORE_DATA_FOR_SPECIFIED_QUEUE;
							if (rs != null) {
								rs.close();
								rs = null;
							}
						}
					} else {
						mainCode = WFSError.WM_NO_MORE_DATA_FOR_SPECIFIED_QUEUE;
					}
				}
				String userName = null;
				String personalName = null;
				String familyName = null;
				if (mainCode == 0) {
					String processInstanceId = "";
					String urn="";
					String activityName = "";
					int workItemId = 0;
					String queueName = "";
					int activityId = 0;
					int processDefId = 0;
				    int procVarId = 0;//Process Variant Support
					tempXml = new StringBuffer(500);
					tempXml.append("<Instrument>\n");

					processInstanceId = rs.getString("ProcessInstanceId");
					tempXml.append(gen.writeValueOf("ProcessInstanceId", processInstanceId));
					tempXml.append(gen.writeValueOf("WorkItemName", rs.getString("WorkItemName")));
					processDefId = rs.getInt("ProcessDefId");
					tempXml.append(gen.writeValueOf("RouteId", processDefId + ""));
					tempXml.append(gen.writeValueOf("RouteName", rs.getString("ProcessName")));
					//Bug 34850 - There is no data in columns 'TAT', 'Valid Till' and 'Status' While TAT is defined in Workitems List 
					tempXml.append(gen.writeValueOf("TurnAroundTime", rs.getString("ExpectedWorkItemDelay")));
					activityId = rs.getInt("ActivityId");
					tempXml.append(gen.writeValueOf("WorkStageId", activityId + ""));
					activityName = rs.getString("ActivityName");
					tempXml.append(gen.writeValueOf("ActivityName", activityName));
					tempXml.append(gen.writeValueOf("PriorityLevel", rs.getString("PriorityLevel")));
//-				tempXml.append(gen.writeValueOf("InstrumentStatus", rs.getString(8)));		//to be provided from different table WFS_6_015
					tempXml.append(gen.writeValueOf("LockStatus", rs.getString("LockStatus")));
					//tempXml.append(gen.writeValueOf("LockedByUserName", rs.getString("LockedByName")));
					userName = rs.getString("LockedByName");	/*WFS_8.0_039*/
					WFUserInfo userInfo = (WFUserInfo) CachedObjectCollection.getReference().getCacheObject(con, engine, 0, WFSConstant.CACHE_CONST_UserCache, "userName" + string21 + userName).getData();
					if (userInfo != null) {
						personalName = userInfo.getPersonalName();
						familyName = userInfo.getFamilyName();
						if(familyName == null)
						{
							familyName = "";
						}
					} else {
						personalName = "";
						familyName = "";
					}
					tempXml.append(gen.writeValueOf("LockedByUserName", userName));
					tempXml.append(gen.writeValueOf("LockedByPersonalName", personalName + " " + familyName));

					tempXml.append(gen.writeValueOf("ExpiryDateTime", rs.getString("ValidTill")));
//-				tempXml.append(gen.writeValueOf("CreatedByUserName", rs.getString(12)));	//to be provided from different table WFS_6_015
//-				tempXml.append(gen.writeValueOf("CreationDateTime", rs.getString(13)));		//to be provided from different table WFS_6_015
					tempXml.append(gen.writeValueOf("WorkitemState", rs.getString("StateName")));
//-				tempXml.append(gen.writeValueOf("CheckListCompleteFlag", rs.getString(15)));	//to be provided from different table WFS_6_015
					tempXml.append(gen.writeValueOf("EntryDateTime", rs.getString("EntryDateTime")));
					tempXml.append(gen.writeValueOf("LockedTime", rs.getString("LockedTime")));
//-				tempXml.append(gen.writeValueOf("IntroductionDateTime", rs.getString(18)));		//to be provided from different table WFS_6_015
//-				tempXml.append(gen.writeValueOf("IntroducedBy", rs.getString(19)));				//to be provided from different table WFS_6_015
					// tempXml.append(gen.writeValueOf("AssignedTo", rs.getString("AssignedUser")));
					userName = rs.getString("AssignedUser");  /*WFS_8.0_039*/
					userInfo = (WFUserInfo) CachedObjectCollection.getReference().getCacheObject(con, engine, 0, WFSConstant.CACHE_CONST_UserCache, "userName" + string21 + userName).getData();
					if (userInfo != null) {
						personalName = userInfo.getPersonalName();
						familyName = userInfo.getFamilyName();
						if(familyName == null)
						{
							familyName = "";
						}
					} else {
						personalName = "";
						familyName = "";
					}
					tempXml.append(gen.writeValueOf("AssignedTo", userName));
					tempXml.append(gen.writeValueOf("AssignedToPersonalName", personalName + " " + familyName));
					workItemId = rs.getInt("WorkItemId");
					tempXml.append(gen.writeValueOf("WorkItemId", workItemId + ""));
					queueName = rs.getString("QueueName");
					tempXml.append(gen.writeValueOf("QueueName", queueName));
					tempXml.append(gen.writeValueOf("AssignmentType", rs.getString("AssignmentType")));
//-				tempXml.append(gen.writeValueOf("ProcessInstanceState", rs.getString(24)));		//to be provided from different table WFS_6_015
					tempXml.append(gen.writeValueOf("QueueType", rs.getString("QueueType")));
//-				tempXml.append(gen.writeValueOf("Status", rs.getString(26)));					//to be provided from different table WFS_6_015
					tempXml.append(gen.writeValueOf("QueueId", rs.getString("Q_QueueID")));
//\				tempXml.append(gen.writeValueOf("Turnaroundtime", rs.getString(28)));			//These were selected as Null previously also WFS_6_015
//\				tempXml.append(gen.writeValueOf("Referredby", rs.getString(29)));				//These were selected as Null previously also WFS_6_015
//\				tempXml.append(gen.writeValueOf("Referredto", rs.getString(30)));				//These were selected as Null previously also WFS_6_015
										//Process Variant Support Changes
                                        procVarId = rs.getInt("ProcessVariantId");
                                        tempXml.append(gen.writeValueOf("VariantId", String.valueOf(procVarId)));
                                        urn = rs.getString("URN");
                    					tempXml.append(gen.writeValueOf("URN", urn));
                    				
//Ashish added for quering from other tables WFS_6_015
					rs.close();
					rs = null;
					pstmt=con.prepareStatement("SELECT PARAM1,ALIAS, VariableId1 FROM VarAliasTable "+ WFSUtil.getTableLockHintStr(dbType) +" WHERE QueueId = ?");
					pstmt.setInt(1,queueid);
					rs = pstmt.executeQuery(); 
					int count=0;
					StringBuffer aliasVar=new StringBuffer();
					StringBuffer aliasVarExt=new StringBuffer();

					ArrayList<String> param=new ArrayList<String>();
					ArrayList<String> alias=new ArrayList<String>();
					ArrayList<String> varaiableId=new ArrayList<String>();
					while(rs.next()) {
                        //tempXml.append("<QueueData>");
                        //tempXml.append(gen.writeValueOf("Name", rs.getString("ALIAS")));
                        //tempXml.append(gen.writeValueOf("Value", rs.getString("VariableId1")));
                        //tempXml.append("</QueueData>");
                        if(Integer.valueOf(rs.getString("VariableId1"))>157) {
                            aliasVar.append(","+rs.getString("ALIAS"));
                            aliasVarExt.append(","+rs.getString("PARAM1")+" as \""+ rs.getString("ALIAS")+'\"');
                        }
                        else {
                        aliasVar.append(","+rs.getString("PARAM1")+" as \""+ rs.getString("ALIAS")+'\"');
                        }
                        
                        
                        param.add(rs.getString("PARAM1"));
                        alias.add(rs.getString("ALIAS"));
                        
                        
                        
                    //    varaiableId.add(rs.getString("VariableId1"));
                        count++;
                    }
					String exttablename="";
                    rs.close();
                    rs = null;
                    pstmt=con.prepareStatement("SELECT TABLEName, DatabaseName FROM EXTDBCONFTABLE "+ WFSUtil.getTableLockHintStr(dbType) +" WHERE ExtObjId=1 and ProcessDefId = ?");
                    pstmt.setInt(1,processDefId);
                    rs = pstmt.executeQuery();
                    while(rs.next()){
                    exttablename=rs.getString("TABLEName");
                    }
                    aliasVarExt.append(" from " + exttablename +" "+ WFSUtil.getTableLockHintStr(dbType) + ")"+ exttablename +" ON (WFInstrumentTable.VAR_REC_1 = ItemIndex AND WFInstrumentTable.VAR_REC_2 = ItemType)");
                    strQuery = new StringBuffer();
                    if(!exttablename.isEmpty()){
                    	strQuery.append("SELECT CreatedByName, CreatedDateTime, IntroductionDateTime , IntroducedBy , ProcessInstanceState,InstrumentStatus,"
                                + " CheckListCompleteFlag, Status "+WFSUtil.TO_SANITIZE_STRING(aliasVar.toString(), true)+"  FROM WFInstrumentTable INNER JOIN (Select ItemIndex, ItemType "+WFSUtil.TO_SANITIZE_STRING(aliasVarExt.toString(), true)+" Where ProcessInstanceId = ? and WorkItemId =?");
                    } else {
                    	strQuery.append("SELECT CreatedByName, CreatedDateTime, IntroductionDateTime , IntroducedBy , ProcessInstanceState,InstrumentStatus,"
                                + " CheckListCompleteFlag, Status "+WFSUtil.TO_SANITIZE_STRING(aliasVar.toString(), true)+"  FROM WFInstrumentTable Where ProcessInstanceId = ? and WorkItemId =?");
                    }
                    //strQuery.append("SELECT CreatedByName, CreatedDateTime, IntroductionDateTime , IntroducedBy , ProcessInstanceState  FROM PROCESSINSTANCETABLE Where ProcessInstanceId = ");
                    // Tirupati Srivastava : changes made to make code compatible with postgreSQL
                    //strQuery.append(WFSConstant.WF_VARCHARPREFIX + processInstanceId);
                    //strQuery.append(WFSUtil.TO_STRING(processInstanceId, true, dbType));
                    //strQuery.append("'");
                    WFSUtil.printOut(engine, strQuery);
                    pstmt = con.prepareStatement(strQuery.toString());
                    WFSUtil.DB_SetString(1, processInstanceId, pstmt, dbType);
                    pstmt.setInt(2,workItemId);
                    parameters.add(processInstanceId);
                    parameters.add(workItemId);
                    rs = WFSUtil.jdbcExecuteQuery(processInstanceId, sessionId, userid, strQuery.toString(), pstmt, parameters, debug, engine);
                    parameters.clear();
					//rs = stmt.executeQuery(strQuery.toString());
					if (rs != null && rs.next()) {
						//tempXml.append(gen.writeValueOf("CreatedByUserName", rs.getString("CreatedByName")));
						userName = rs.getString("CreatedByName");	/*WFS_8.0_039*/
						userInfo = (WFUserInfo) CachedObjectCollection.getReference().getCacheObject(con, engine, 0, WFSConstant.CACHE_CONST_UserCache, "userName" + string21 + userName).getData();
						if (userInfo != null) {
							personalName = userInfo.getPersonalName();
							familyName = userInfo.getFamilyName();
							if(familyName == null)
							{
								familyName = "";
							}
						} else {
							personalName = "";
							familyName = "";
						}
						tempXml.append(gen.writeValueOf("CreatedByUserName", userName));
						tempXml.append(gen.writeValueOf("CreatedByPersonalName", personalName + " " + familyName));
						tempXml.append(gen.writeValueOf("CreationDateTime", rs.getString("CreatedDateTime")));
						tempXml.append(gen.writeValueOf("IntroductionDateTime", rs.getString("IntroductionDateTime")));
						//tempXml.append(gen.writeValueOf("IntroducedBy", rs.getString("IntroducedBy")));
						userName = rs.getString("IntroducedBy");	/*WFS_8.0_039*/
						userInfo = (WFUserInfo) CachedObjectCollection.getReference().getCacheObject(con, engine, 0, WFSConstant.CACHE_CONST_UserCache, "userName" + string21 + userName).getData();
						if (userInfo != null) {
							personalName = userInfo.getPersonalName();
							familyName = userInfo.getFamilyName();
							if(familyName == null)
							{
								familyName = "";
							}
						} else {
							personalName = "";
							familyName = "";
						}
						tempXml.append(gen.writeValueOf("IntroducedBy", userName));
						tempXml.append(gen.writeValueOf("IntroducedByPersonalName", personalName + " " + familyName));
						tempXml.append(gen.writeValueOf("ProcessInstanceState", rs.getString("ProcessInstanceState")));
                        tempXml.append(gen.writeValueOf("InstrumentStatus", rs.getString("InstrumentStatus")));
						tempXml.append(gen.writeValueOf("CheckListCompleteFlag", rs.getString("CheckListCompleteFlag")));
						tempXml.append(gen.writeValueOf("Status", rs.getString("Status")));
						tempXml.append("<Data>");
						while(count>0){
							tempXml.append("<QueueData>");
							tempXml.append(gen.writeValueOf("Name", alias.get(count-1)));
							tempXml.append(gen.writeValueOf("Value",WFSUtil.handleSpecialCharInXml(rs.getString(alias.get(count-1)))));
							tempXml.append("</QueueData>");
							count--;
					}
						tempXml.append("</Data>");
					}
					if (rs != null) {
						rs.close();
						rs = null;
					}

//					strQuery = new StringBuffer();
//					strQuery.append("SELECT InstrumentStatus, CheckListCompleteFlag, Status FROM QUEUEDATATABLE Where ProcessInstanceId = ");
//					//strQuery.append(WFSConstant.WF_VARCHARPREFIX + processInstanceId);
//					strQuery.append(TO_STRING(processInstanceId, true, dbType));
//					strQuery.append(" and WorkItemId = ");
//					strQuery.append(workItemId);
//
//					rs = stmt.executeQuery(strQuery.toString());
//					if (rs != null && rs.next()) {
//						tempXml.append(gen.writeValueOf("InstrumentStatus", rs.getString("InstrumentStatus")));
//						tempXml.append(gen.writeValueOf("CheckListCompleteFlag", rs.getString("CheckListCompleteFlag")));
//						tempXml.append(gen.writeValueOf("Status", rs.getString("Status")));
//					}
//					if (rs != null) {
//						rs.close();
//						rs = null;
//					}
//Ashish added for quering from other tables WFS_6_015

					tempXml.append("</Instrument>\n");
					/* SrNo-8, Attributes returned in this call on the basis of dataflag - Ruhi Hira */
					if (dataFlag) {
						tempXml.append(WFSUtil.fetchAttributes(con, processInstanceId, workItemId, "", engine, dbType, gen, "", false, false));
					}
					WFSUtil.generateLog(engine, con, WFSConstant.WFL_WorkItemLock, processInstanceId, workItemId, processDefId, activityId, activityName,
							queueid, userid, username, 0, queueName, null, null, null, null);
				} else {
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
			
		}
		if (mainCode != 0) {
			throw new WFSException(mainCode, subCode, errType, subject, descr);
		}
		return tempXml.toString();
	}

	//----------------------------------------------------------------------------------------------------
	//	Function Name 			:	WFPickList
	//	Date Written (DD/MM/YYYY)	:	02/09/2003
	//	Author				:	Prashant
	//	Input Parameters		:	Connection , XMLParser , XMLGenerator
	//	Output Parameters		:       none
	//	Return Values			:	String
	//	Description			:       Get the distinct values of any DataField
	//  Change Description              :       SrNo-16, Complex variable support in PickList
	//----------------------------------------------------------------------------------------------------
	public String WFPickList(Connection con, XMLParser parser, XMLGenerator gen) throws JTSException, WFSException {
		StringBuffer outputXML = new StringBuffer("");
		Statement stmt = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int mainCode = 0;
		int subCode = 0;
		String subject = null;
		String descr = null;
		String errType = WFSError.WF_TMP;
		String engine ="";
		char char21 = 21;
		String string21 = "" + char21;
		try {
			int sessionID = parser.getIntOf("SessionId", 0, false);
			int procDefId = parser.getIntOf("ProcessDefID", -1, true);
			int queueId = parser.getIntOf("QueueID", -1, true);
			String attrbName = parser.getValueOf("Attribute", "", false);
			engine = parser.getValueOf("EngineName", "", false);
			int dbType = ServerProperty.getReference().getDBType(engine);
			int noOfRectoFetch = parser.getIntOf("NoOfRecordsToFetch", ServerProperty.getReference().getBatchSize(), true);
			char sortOrder = parser.getCharOf("SortOrder", 'A', true);
			String lastValue = parser.getValueOf("LastValue", "", true);
			String compprefix = parser.getValueOf("Prefix", "", true);
			String sortStr = "";
			StringBuffer tempXml = new StringBuffer(1024);
			boolean complexName = false;
			String extAttrib = null;
			int extProcId = -1;
			boolean isProcSpecific = false;
			int varType = WFSConstant.WF_STR;

			//SrNo-16 , /*for complex search this attribName will be like a.b.c.d -shilpi*/
			if (attrbName.indexOf(".") > 0) {
				complexName = true;
			}
			WFParticipant user = WFSUtil.WFCheckSession(con, sessionID);
			if (noOfRectoFetch > ServerProperty.getReference().getBatchSize() || noOfRectoFetch <= 0) {
				noOfRectoFetch = ServerProperty.getReference().getBatchSize();
			}
			if (user != null && user.gettype() == 'U') {
				stmt = con.createStatement();
				String strQuery = "";
				boolean tabFlag = true; //SRNo-4
				varType = WFSConstant.WF_STR;
				pstmt = con.prepareStatement("SELECT PARAM1 FROM VARALIASTABLE WHERE QUEUEID = ? AND alias = ? ");
				pstmt.setInt(1,queueId);
				WFSUtil.DB_SetString(2, attrbName.trim(), pstmt, dbType);
				pstmt.execute();
				rs = pstmt.getResultSet();
				if (rs != null && rs.next()) {
					extAttrib = rs.getString(1);
					rs.close();
				}
				pstmt.close();
				pstmt = null;
				if(extAttrib != null && !extAttrib.equals("")) {  // alias on external variables, so processdefid is retrieved.
					pstmt = con.prepareStatement("Select ProcessDefId from ProcessDefTable " + WFSUtil.getTableLockHintStr(dbType) + " where ProcessName = (SELECT ProcessName FROM QueueDefTable " + WFSUtil.getTableLockHintStr(dbType) + " WHERE QUEUEID = ? )");
					pstmt.setInt(1,queueId);
					pstmt.execute();
					rs = pstmt.getResultSet();
					if (rs != null && rs.next()) {
						procDefId = rs.getInt(1);
						if(rs.wasNull() || procDefId <= 0)
							isProcSpecific = false;
						else
							isProcSpecific = true;
						rs.close();
					}
					pstmt.close();
					pstmt = null;
					attrbName = extAttrib;
				}
				if (queueId >= 0 && !isProcSpecific) {
					//strQuery = "Select distinct " + WFSUtil.getFetchPrefixStr(dbType, (noOfRectoFetch + 1)) + attrbName + " from WFSearchView_" + queueId + " where " + attrbName + " is not null "; //Bugzilla Bug 107
					strQuery = "Select distinct " + WFSUtil.getFetchPrefixStr(dbType, (noOfRectoFetch + 1)) + TO_SANITIZE_STRING(attrbName, true) + " from " + (queueId == 0 ? " (select "+ TO_SANITIZE_STRING(attrbName, true) +" from WFINSTRUMENTTABLE where WFINSTRUMENTTABLE.referredTo is null " + (queueId == 0 ? "" : " AND Q_QueueId = " + queueId)+ " union all select "+ TO_SANITIZE_STRING(attrbName, true) +" from QUEUEHISTORYTABLE where QUEUEHISTORYTABLE.referredTo is null " + (queueId == 0 ? "" : " AND Q_QueueId = " + queueId)+ " )Tab " :  " (select "+ TO_SANITIZE_STRING(attrbName, true) +" from WFINSTRUMENTTABLE  where WFINSTRUMENTTABLE.referredTo is null " + (queueId == 0 ? "" : " AND Q_QueueId = " + queueId)+ ")Tab ") + " where " + TO_SANITIZE_STRING(attrbName, true) + " is not null ";
					
				} else if (procDefId > 0) {
					/*	************************************************************************************	*/
					/*		Change By	: Krishan Dutt Dixit													*/
					/*		Reason		: Query changed for getting variable type also							*/
					/*		Date		: 23/06/2004															*/
					/*		Bug No.		: Bug No WSE_I_5.0.1_149												*/
					/*	************************************************************************************	*/
					// Tirupati Srivastava : changes made to make code compatible with postgreSQL
                    /*ResultSet rs = stmt.executeQuery("Select SystemDefinedName, ExtObjID,VariableType from VarMappingTable where UserdefinedName = " + WFSConstant.WF_VARCHARPREFIX + attrbName + "' and ProcessDefID = " + procDefId);*/
					int mExtobjid = 0;
					String tableName = "";
					if (complexName) {
					//Process Variant Support
						WFVariabledef varDef = (WFVariabledef) CachedObjectCollection.getReference().getCacheObject(con, engine, procDefId, WFSConstant.CACHE_CONST_Variable, "0" + string21 + "0").getData();
						LinkedHashMap<String, WFFieldInfo> cacheMap = varDef.getAttribMap();
						String[] retInfo = getAttributeInfo(cacheMap, attrbName);/*name of method can be changed- shilpi*/
						attrbName = retInfo[0];
						mExtobjid = Integer.parseInt(retInfo[1]);
						varType = Integer.parseInt(retInfo[2]);
						tableName = retInfo[3]; /*this shouldnt be null - shilpi*/
						String columnName = retInfo[4];
						attrbName = columnName; /*this shouldnt be null - shilpi*/
					} else {
						rs = stmt.executeQuery("Select SystemDefinedName, ExtObjID,VariableType from VarMappingTable where UserdefinedName = " + TO_STRING(attrbName, true, dbType) + " and ProcessDefID = " + procDefId);
						if (rs.next()) {
							attrbName = rs.getString(1);
							mExtobjid = rs.getInt(2);
							varType = rs.getInt(3);
							rs.close();
							if (mExtobjid > 0) {
								tableName = WFSExtDB.getTableName(engine, procDefId, mExtobjid);
								//****************************************************************************************
								// changed by          :		Mandeep Kaur
								// Change Description  :		SRNo-4 ,On Click of Pick List in advanced Search error comes
								//**************************************************************************************
								tabFlag = WFSUtil.isObjectTable(con, tableName, dbType);
							}
						}
					}
					strQuery = "Select distinct " + WFSUtil.getFetchPrefixStr(dbType, (noOfRectoFetch + 1)) + TO_SANITIZE_STRING(attrbName, true) + " from "; //Bugzilla Bug 107

					/** 11/11/2008, Bugzilla Bug 6941, PickList give error when search with some value in int field in Oracle.
					 * In this case tableName is QueueView, hence UTF8Flag to be passed to getLikeFilterStr should be true.
					 * NOTE : Escape sequence is added only when UTF8Flag is true for Oracle
					 * - Ruhi Hira */
					if (mExtobjid == 0) {
						tabFlag = true;
					}
					String queueView = " (select " + TO_SANITIZE_STRING(attrbName, true) + ",ProcessDefId from WFINSTRUMENTTABLE union all select " + TO_SANITIZE_STRING(attrbName, true) + ",ProcessDefId from QUEUEHISTORYTABLE)QView ";
					strQuery += Integer.parseInt(TO_SANITIZE_STRING(Integer.toString(mExtobjid), false)) == 0 ? queueView :tableName;
					if (mExtobjid == 0) {
						strQuery += " where ProcessDefId = " + Integer.parseInt(TO_SANITIZE_STRING(Integer.toString(procDefId), false)) + " and ";
						if (varType == 10 || varType == 255) {
							strQuery += WFSUtil.DB_LEN(attrbName, dbType) + " > 0 ";
						} else {
							strQuery += TO_SANITIZE_STRING(attrbName, true) + " is not null ";
						}
					} else {
						strQuery += " where ";
						if (varType == 10 || varType == 255) {
							strQuery += WFSUtil.DB_LEN(attrbName, dbType) + " > 0 ";
						} else {
							strQuery += TO_SANITIZE_STRING(attrbName, true) + " is not null ";
						}
					}
				}
				if (!strQuery.equals("")) {
					int totalCount = 0;
					if (!compprefix.equals("")) {
						compprefix = " and " + WFSUtil.getLikeFilterStr(parser, attrbName, compprefix, dbType, tabFlag, varType); //Bugzilla Bug 3421
					}

					if (!lastValue.equals("")) {
						//sortStr = " AND " + attrbName + " " + (sortOrder == 'A' ? ">" : "<") + WFSConstant.WF_VARCHARPREFIX + lastValue + "'";
						sortStr = " AND " + TO_SANITIZE_STRING(attrbName, true) + " " + (sortOrder == 'A' ? " > " : " < ") + TO_STRING(lastValue, true, dbType);
					}

					rs = null;
//					WFSUtil.printOut(engine,"WFPickList Query ====== "+"Select * from (" + strQuery + compprefix + sortStr + " Order by 1 "
//                                           + (sortOrder == 'A' ? "ASC" : "DESC") + ") a "
//                                           + WFSUtil.getFetchSuffixStr(dbType, (noOfRectoFetch + 1), WFSConstant.QUERY_STR_WHERE));
					rs = stmt.executeQuery("Select * from (" + TO_SANITIZE_STRING(strQuery, true) + TO_SANITIZE_STRING(compprefix, true) + TO_SANITIZE_STRING(sortStr, true) + " Order by 1 " + (sortOrder == 'A' ? "ASC" : "DESC") + ") a " + WFSUtil.getFetchSuffixStr(dbType, (noOfRectoFetch + 1), WFSConstant.QUERY_STR_WHERE)); //Bugzilla Bug 107
					tempXml.append("<Values>");
					/** 07/08/2008, Bugzilla Bug 5530, Boolean/ ShortDate/ Time support in pick list - Ruhi Hira */
					String tempValueStr = null;
					while (totalCount < noOfRectoFetch && rs.next()) {
						tempValueStr = rs.getString(1);
						if (procDefId > 0) {
							tempValueStr = WFSUtil.to_OmniFlow_Value(tempValueStr, varType);
							tempXml.append(gen.writeValueOf("Value", tempValueStr));
						} else {
							tempXml.append(gen.writeValueOf("Value", WFSUtil.handleSpecialCharInXml(tempValueStr)));
						}
						totalCount++;
					}
					totalCount = (totalCount == noOfRectoFetch) && rs.next() ? totalCount + 1 : totalCount;
					tempXml.append("</Values>");
					tempXml.append(gen.writeValueOf("TotalCount", String.valueOf(totalCount)));
					if (rs != null) {
						rs.close();
					}
					stmt.close();
					stmt = null;
					if (totalCount == 0) {
						mainCode = WFSError.WM_NO_MORE_DATA;
						subCode = 0;
						subject = WFSErrorMsg.getMessage(mainCode);
						descr = WFSErrorMsg.getMessage(subCode);
						errType = WFSError.WF_TMP;
					}
				} else {
					mainCode = WFSError.WM_INVALID_ATTRIBUTE;
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
				outputXML.append(gen.createOutputFile("WFPickList"));
				outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
				outputXML.append(tempXml);
				outputXML.append(gen.closeOutputFile("WFPickList"));
			}
		} catch (SQLException e) {
			WFSUtil.printErr(engine,"", e);
			mainCode = WFSError.WF_OPERATION_FAILED;
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
			try{
				if(rs!=null){
					rs.close();
					rs=null;
				}
			}catch(Exception e){
				WFSUtil.printErr(engine,"", e);
			}
			try {
				if (stmt != null) {
					stmt.close();
					stmt = null;
				}
			} catch (Exception e) {
				WFSUtil.printErr(engine,"", e);
			}
			try{
				if(pstmt!=null){
					pstmt.close();
					pstmt=null;
				}
			}catch(Exception e){
				WFSUtil.printErr(engine,"", e);
			}
			
		}
		if (mainCode != 0) {
			throw new WFSException(mainCode, subCode, errType, subject, descr);
		}
		return outputXML.toString();
	}

	public String WFGetNextUnlockedWorkitem(Connection con, XMLParser parser, XMLGenerator gen) throws JTSException, WFSException {
		StringBuffer outputXML = null;
		Statement stmt = null;
		ResultSet rs = null;
		int mainCode = 0;
		int subCode = 0;
		String subject = null;
		String descr = null;
		String errType = WFSError.WF_TMP;
		StringBuffer tempXml = new StringBuffer(1000);
		PreparedStatement pstmt = null;
		String engine ="";
		StringBuilder inputParamInfo = new StringBuilder();
		try {
			int sessionID = parser.getIntOf("SessionId", 0, false);
			engine = parser.getValueOf("EngineName");
			int dbType = ServerProperty.getReference().getDBType(engine);

			WFParticipant participant = WMUser.WFCheckUpdateSession(con, sessionID, dbType);
			inputParamInfo.append(gen.writeValueOf("SessionId", String.valueOf(sessionID)));
			inputParamInfo.append(gen.writeValueOf("UserName", (participant == null ? "" : participant.getname())));
			inputParamInfo.append(gen.writeValueOf("QueueId", String.valueOf(parser.getIntOf("QueueId", 0, true))));
			if (participant != null && participant.gettype() == 'U') {
				int userid = participant.getid();
				String username = participant.getname();
				String filterStr = WFSUtil.getFilter(parser, con, dbType);
				int queueid = parser.getIntOf("QueueId", 0, true);
				char sortOrder = parser.getCharOf("SortOrder", 'A', true);
				int orderBy = parser.getIntOf("OrderBy", 18, true);
				char dataflag = parser.getCharOf("DataFlag", 'N', true);
				int lastWIValue = parser.getIntOf("LastWorkItem", 0, true);
				String lastValue = parser.getValueOf("LastValue", "", true);
				String lastPIValue = parser.getValueOf("LastProcessInstance", "", true);
                boolean debug = parser.getValueOf("DebugFlag", "N", true).equalsIgnoreCase("Y");
				if (!lastPIValue.equals("") && lastWIValue != 0) //filterStr += " AND NOT(ProcessInstanceId = " + WFSConstant.WF_VARCHARPREFIX + lastPIValue + "' AND WorkItemID = " + lastWIValue + ")";
				// Tirupati Srivastava : changes made to make code compatible with postgreSQL
				{
					filterStr += " AND NOT( ProcessInstanceId = " + TO_STRING(lastPIValue, true, dbType) + " AND WorkItemID = " + lastWIValue + ")";
				}

				tempXml.append(getNextUnlockedWorkitem(con, engine, participant, queueid, filterStr, gen,
                        (dataflag == 'Y') ? true : false, sessionID, debug));
				pstmt = con.prepareStatement("Select LastModifiedOn from QueueDefTable " + WFSUtil.getTableLockHintStr(dbType) + " where queueid = ? ");
				pstmt.setInt(1,queueid);
				rs = pstmt.executeQuery();
				if(rs.next())
						tempXml.append(gen.writeValueOf("LastModifiedOn", rs.getString("LastModifiedOn")));
				if(rs != null)
					rs.close();
				if(pstmt != null)
					pstmt.close();
			} else {
				mainCode = WFSError.WM_INVALID_SESSION_HANDLE;
				subCode = 0;
				subject = WFSErrorMsg.getMessage(mainCode);
				descr = WFSErrorMsg.getMessage(subCode);
				errType = WFSError.WF_TMP;
			}

			if (mainCode == 0 || mainCode == 18) {
				outputXML = new StringBuffer(500);
				outputXML.append(gen.createOutputFile("WFGetNextUnlockedWorkitem"));
				outputXML.append("<Exception>\n<MainCode>"+mainCode+"</MainCode>\n</Exception>\n");
				outputXML.append(tempXml);
				outputXML.append(inputParamInfo);
				outputXML.append(gen.closeOutputFile("WFGetNextUnlockedWorkitem"));
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
			if(mainCode == 18){
				outputXML = new StringBuffer();
				outputXML.append(gen.createOutputFile("WFGetNextUnlockedWorkitem"));
				outputXML.append("<Exception>\n<MainCode>"+mainCode+"</MainCode>\n");
				outputXML.append("\t<SubErrorCode>"+String.valueOf(subCode)+"</SubErrorCode>\n");
				outputXML.append("\t<TypeOfError>"+String.valueOf(errType)+"</TypeOfError>\n");
				outputXML.append("\t<Subject>"+String.valueOf(subject)+"</Subject>\n");
				outputXML.append("\t<Description>"+String.valueOf(descr)+"</Description>\n");
				outputXML.append("</Exception>\n");
				outputXML.append(inputParamInfo.toString());
				outputXML.append(gen.closeOutputFile("WFGetNextUnlockedWorkitem"));
			}
		}
		if (mainCode != 0 && mainCode !=18) {
			throw new WFSException(mainCode, subCode, errType, subject, descr, inputParamInfo.toString());
		}
		return outputXML.toString();
	}

	//----------------------------------------------------------------------------------------------------
	// Function Name 	: WFGetWorkitemData
	// Date Written (DD/MM/YYYY): 02/12/2003
	// Author		: Prashant
	// Input Parameters	: Connection , XMLParser , XMLGenerator
	// Output Parameters	: none
	// Return Values	: String
	// Description		: Get Workitem's Data and Aliases.
	//----------------------------------------------------------------------------------------------------
	// Changed By							: Ashish Mangla
	// Reason / Cause (Bug No if Any)		: WFS_6_023
	// Change Description					: No need to check in which Queue the workItem exists
	//----------------------------------------------------------------------------
	//Changed by							: Mohnish
	//Reason							    : Calling GetWorkItemDataExt from this call and returning the data . 
	//Change Description					: Changes for code optimization
	public String WFGetWorkitemData(Connection con, XMLParser parser,
			XMLGenerator gen) throws JTSException, WFSException {
		StringBuffer outputXML = null;
		Statement stmt = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int mainCode = 0;
        String strOption=null;
		int subCode = 0;
		String subject = null;
		String descr = null;
		
		String errType = WFSError.WF_TMP;
		
		StringBuffer tempXml = null;
        XMLParser parser2=new XMLParser();
        String targetCabinetName=null;
        Connection tarConn=null;
		boolean debugFlag = false;
		String queryStr = null;
		
		String engine = null;
		ArrayList parameters = new ArrayList();
		char char21 = 21;
		String string21 = "" + char21;
		try {
			int sessionID = parser.getIntOf("SessionId", 0, false);
			engine = parser.getValueOf("EngineName");
			boolean bCheckQueryWorkStep = parser.getValueOf("QueryWorkStep", "N", true).trim().equalsIgnoreCase("Y") ? true : false;
			bCheckQueryWorkStep = false;                            
			int dbType = ServerProperty.getReference().getDBType(engine);

			boolean bInQueue = false;
			boolean bFetchQueryWorkStepId = false;
			String filterValue = null;
			String aType = null;
			StringBuffer strBuff = null;
			int assnuserId;
			int filterOption = 0;
			String queueFilter = "";
			int prcoessdefid;
			String queryFilter = null;
			String qType = null;

			WFParticipant participant = WMUser.WFCheckUpdateSession(con, sessionID, dbType);
			if (participant != null && participant.gettype() == 'U') {
                 String ArchiveSearch= parser.getValueOf("ArchiveSearch","N",true);
                 if(ArchiveSearch!=null && ArchiveSearch.equalsIgnoreCase("Y")) {
	                strOption=parser.getValueOf("Option");
	                pstmt=con.prepareStatement("Select PropertyValue from WFSYSTEMPROPERTIESTABLE where PropertyKey = ?");
	                pstmt.setString(1,"ARCHIVALCABINETNAME");
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
	                tarConn=WFSUtil.createConnectionToTargetCabinet(targetCabinetName,strOption,engine);
	                if(tarConn!=null)
	                WFSUtil.printOut(engine,"Connection with Target Cabinet "+targetCabinetName+" is established.");
			 }
				int userid = participant.getid();
				String username = participant.getname();

				int i = 0;
//        char dataflag = parser.getCharOf("DataFlag", 'N', true);
				String spInstId = parser.getValueOf("ProcessInstanceId", "", false);
				int nwrkItmId = parser.getIntOf("WorkItemId", 0, false);
				int queueId = -1;
				String stableName = null;
				//String stablename = "WFWorklistview_0";		//WFS_6_023

				//WFS_6_023
				StringBuffer queryString = new StringBuffer();
				StringBuffer strQuery = null;
				StringBuffer filterStr = new StringBuffer();
				boolean resultExist = false;
				boolean bfoundInHistory = false;

				filterStr.append(" where ProcessInstanceId = ");
				// Tirupati Srivastava : changes made to make code compatible with postgreSQL
				//filterStr.append(WFSConstant.WF_VARCHARPREFIX);
				//filterStr.append(spInstId);
				filterStr.append(" ? ");
				filterStr.append(" AND ");
				filterStr.append(" Workitemid = ");
				filterStr.append(" ? ");

				queryString.append(" Select ProcessInstanceId, ProcessInstanceId as ProcessinstanceName, ProcessdefId, ");
				queryString.append(" ProcessName, ActivityId, ActivityName, PriorityLevel, ");
				queryString.append(" LockStatus, LockedbyName, ValidTill, ");
				queryString.append(" StateName, EntryDateTime, LockedTime, ");
				queryString.append(" AssignedUser, WorkitemId, QueueName, AssignmentType, ");
				queryString.append(" Queuetype,  Q_QueueId, ");
				//queryString.append( WFSUtil.DATEDIFF(WFSConstant.WFL_hh, "entrydatetime", "ExpectedWorkItemDelay",
               // dbType) + " as TurnaroundTime,");
                queryString.append ("Q_UserId, WorkItemState ");
                /*if(ArchiveSearch!=null && ArchiveSearch.equalsIgnoreCase("Y")) {
                     stmt = tarConn.createStatement();
                }
                else
					stmt = con.createStatement();*/
				/*rs = stmt.executeQuery(queryString.toString() + " from WorkListTable " + WFSUtil.getTableLockHintStr(dbType) + filterStr.toString() + WFSUtil.getQueryLockHintStr(dbType));
				if (!rs.next()) {
					if (rs != null) {
						rs.close();
						rs = null;
					}
					rs = stmt.executeQuery(queryString.toString() + " from WorkInProcessTable " + WFSUtil.getTableLockHintStr(dbType) + filterStr.toString() + WFSUtil.getQueryLockHintStr(dbType));
					if (!rs.next()) {
						if (rs != null) {
							rs.close();
							rs = null;
						}
						//Find the workItem in HistoryTable
						strQuery = new StringBuffer();
						strQuery.append(" , InstrumentStatus , CheckListCompleteFlag, Status, ReferredByName, ReferredTo, ");
						strQuery.append(" CreatedByName, CreatedDateTime, IntroductionDateTime, IntroducedBy, ProcessInstanceState ");
						strQuery.append(" FROM QueueHistoryTable ");
						strQuery.append(WFSUtil.getTableLockHintStr(dbType));
//                        strQuery.append(WFSUtil.getQueryLockHintStr(dbType));// Bugzilla # 103
//						WFSUtil.printOut(engine,"Here is the Query of GetWorkitemData======"+queryString.toString() + strQuery.toString() + filterStr.toString());
						rs = stmt.executeQuery(queryString.toString() + strQuery.toString() + filterStr.toString() + WFSUtil.getQueryLockHintStr(dbType));
						if (!rs.next()) {
							if (rs != null) {
								rs.close();
								rs = null;
							}

							rs = stmt.executeQuery(queryString.toString() + " from PendingWorkListTable " + WFSUtil.getTableLockHintStr(dbType) + filterStr.toString() + WFSUtil.getQueryLockHintStr(dbType));
							if (!rs.next()) {
								if (rs != null) {
									rs.close();
									rs = null;
								}

								rs = stmt.executeQuery(queryString.toString() + " from WorkDoneTable " + WFSUtil.getTableLockHintStr(dbType) + filterStr.toString() + WFSUtil.getQueryLockHintStr(dbType));
								if (!rs.next()) {
									if (rs != null) {
										rs.close();
										rs = null;
									}
									rs = stmt.executeQuery(queryString.toString() + " from WorkWithPSTable " + WFSUtil.getTableLockHintStr(dbType) + filterStr.toString() + WFSUtil.getQueryLockHintStr(dbType));
									if (rs.next()) {
										resultExist = true;
									}
								} else {
									resultExist = true;
								}
							} else {
								resultExist = true;
							}
						} else {
							resultExist = true;
							bfoundInHistory = true;
						}
					} else {
						stableName = "WorkInProcessTable";
						bInQueue = true;
						resultExist = true;
					}
				} else {
					stableName = "WorkListTable";
					bInQueue = true;
					resultExist = true;
				}*/
				strQuery = new StringBuffer();
				strQuery.append(" , InstrumentStatus , CheckListCompleteFlag, Status, ReferredByName, ReferredTo, ");
				strQuery.append(" CreatedByName, CreatedDateTime, IntroductionDateTime, IntroducedBy, ProcessInstanceState, URN ");
				
				queryStr = queryString.toString()  + strQuery.toString() + ",ExpectedWorkItemDelay,RoutingStatus from WFInstrumentTable " + WFSUtil.getTableLockHintStr(dbType) + filterStr.toString() + WFSUtil.getQueryLockHintStr(dbType);
				if(ArchiveSearch!=null && ArchiveSearch.equalsIgnoreCase("Y")) {
					pstmt = tarConn.prepareStatement(queryStr);
				}else{
					pstmt = con.prepareStatement(queryStr);
				}
				
				WFSUtil.DB_SetString(1, spInstId, pstmt, dbType);
				pstmt.setInt(2, nwrkItmId);
				parameters.add(Arrays.asList(spInstId, nwrkItmId));
				if(con.getAutoCommit())
                    con.setAutoCommit(false);
				rs = WFSUtil.jdbcExecuteQuery(spInstId, sessionID, userid, queryStr, pstmt, parameters, debugFlag, engine);
		        parameters.clear();
				if (!rs.next()) {
					if (rs != null) {
						rs.close();
						rs = null;
					}
					//Find the workItem in HistoryTable
					strQuery.append(",ExpectedWorkItemDelayTime FROM QueueHistoryTable ");
					strQuery.append(WFSUtil.getTableLockHintStr(dbType));
					queryStr = queryString.toString() + strQuery.toString() + filterStr.toString() + WFSUtil.getQueryLockHintStr(dbType);
					
					if(ArchiveSearch!=null && ArchiveSearch.equalsIgnoreCase("Y")) {
						pstmt = tarConn.prepareStatement(queryStr);
					}else{
						pstmt = con.prepareStatement(queryStr);
					}
				
					WFSUtil.DB_SetString(1, spInstId, pstmt, dbType);
					pstmt.setInt(2, nwrkItmId);
					parameters.add(Arrays.asList(spInstId, nwrkItmId));
					
					rs = WFSUtil.jdbcExecuteQuery(spInstId, sessionID, userid, queryStr, pstmt, parameters, debugFlag, engine);
					parameters.clear();
					if(rs.next()){
						resultExist = true;
						bfoundInHistory = true;
					}
				}else{
					resultExist = true;
				}
				
				String userName = null;
				String personalName = null;
				String familyName = null;
				if (resultExist) {
					String turnAroundTime="";
					if(bfoundInHistory){
						turnAroundTime=rs.getString("ExpectedWorkItemDelayTime");
					}else{
						turnAroundTime=rs.getString("ExpectedWorkItemDelay");
					}
					tempXml = new StringBuffer();
					tempXml.append("<Instrument>\n");

					tempXml.append(gen.writeValueOf("ProcessInstanceId", rs.getString("ProcessInstanceId")));
					tempXml.append(gen.writeValueOf("ProcessInstanceName", rs.getString("ProcessinstanceName")));
					prcoessdefid = rs.getInt("ProcessdefId");
					tempXml.append(gen.writeValueOf("RouteId", String.valueOf(prcoessdefid)));
					tempXml.append(gen.writeValueOf("RouteName", rs.getString("ProcessName")));
					tempXml.append(gen.writeValueOf("WorkStageId", rs.getString("ActivityId")));
					tempXml.append(gen.writeValueOf("ActivityName", rs.getString("ActivityName")));
					tempXml.append(gen.writeValueOf("PriorityLevel", rs.getString("PriorityLevel")));
					tempXml.append(gen.writeValueOf("LockStatus", rs.getString("LockStatus")));
					//tempXml.append(gen.writeValueOf("LockedByUserName", rs.getString("LockedbyName")));
					userName = rs.getString("LockedbyName");	/*WFS_8.0_039*/
					WFUserInfo userInfo = (WFUserInfo) CachedObjectCollection.getReference().getCacheObject(con, engine, 0, WFSConstant.CACHE_CONST_UserCache, "userName" + string21 + userName).getData();
					if (userInfo != null) {
						personalName = userInfo.getPersonalName();
                        familyName = userInfo.getFamilyName();
                        if(familyName == null)
                        {
                        familyName = "";
                        }
					} else {
						personalName = null;
                        familyName = ""; 
					}
					tempXml.append(gen.writeValueOf("LockedByUserName", userName));
					tempXml.append(gen.writeValueOf("LockedByPersonalName", personalName + " " + familyName));
					tempXml.append(gen.writeValueOf("ExpiryDateTime", rs.getString("ValidTill")));
					tempXml.append(gen.writeValueOf("Statename", rs.getString("StateName")));
					tempXml.append(gen.writeValueOf("EntryDateTime", rs.getString("EntryDateTime")));
					tempXml.append(gen.writeValueOf("LockedTime", rs.getString("LockedTime")));
					//tempXml.append(gen.writeValueOf("AssignedTo", rs.getString("AssignedUser")));
					userName = rs.getString("AssignedUser");	/*WFS_8.0_039*/
					userInfo = (WFUserInfo) CachedObjectCollection.getReference().getCacheObject(con, engine, 0, WFSConstant.CACHE_CONST_UserCache, "userName" + string21 + userName).getData();
					if (userInfo !=null){
						personalName = userInfo.getPersonalName();
                        familyName = userInfo.getFamilyName();
                        if(familyName == null)
                        {
                        familyName = "";
                        }
					} else {
						personalName = null;
                        familyName = ""; 
					}
					tempXml.append(gen.writeValueOf("AssignedTo", userName));
					tempXml.append(gen.writeValueOf("AssignedToPersonalName", personalName + " " + familyName));
					tempXml.append(gen.writeValueOf("WorkItemId", rs.getString("WorkitemId")));
					tempXml.append(gen.writeValueOf("QueueName", rs.getString("QueueName")));
					aType = rs.getString("AssignmentType");
					tempXml.append(gen.writeValueOf("AssignmentType", aType));
					aType = rs.wasNull() ? "S" : aType;
					qType = rs.getString("Queuetype");
					tempXml.append(gen.writeValueOf("QueueType", qType));
					queueId = rs.getInt("Q_QueueId");
					tempXml.append(gen.writeValueOf("QueueId", String.valueOf(queueId)));
				//	tempXml.append(gen.writeValueOf("Turnaroundtime", rs.getString("TurnaroundTime")));
					assnuserId = rs.getInt("Q_UserId");
					tempXml.append(gen.writeValueOf("UserID", String.valueOf(assnuserId)));
					tempXml.append(gen.writeValueOf("WorkitemState", rs.getString("WorkItemState")));
					tempXml.append(gen.writeValueOf("URN", rs.getString("URN")));
					if (!bfoundInHistory) {
						//CLOSE THE RESULTSET all the relevent data has already been captured
						/*if (rs != null) {
							rs.close();
							rs = null;
						}
						strQuery = new StringBuffer();
						strQuery.append("Select InstrumentStatus , CheckListCompleteFlag, Status, ReferredByName, ReferredTo, ");
						strQuery.append("B.CreatedByName, B.CreatedDateTime, B.IntroductionDateTime, B.IntroducedBy, B.ProcessInstanceState ");
						strQuery.append("from QueueDataTable" + WFSUtil.getTableLockHintStr(dbType));
						strQuery.append(", (Select CreatedByName, CreatedDateTime, IntroductionDateTime, IntroducedBy, ProcessInstanceState ");
						// Tirupati Srivastava : changes made to make code compatible with postgreSQL
						//strQuery.append("from ProcessinstanceTable " + WFSUtil.getTableLockHintStr(dbType) + " where processInstanceId = N'" + spInstId + "') B");
						strQuery.append("from ProcessinstanceTable " + WFSUtil.getTableLockHintStr(dbType) + " where processInstanceId = " + TO_STRING(spInstId, true, dbType) + " ) B");
						strQuery.append(filterStr);
						strQuery.append(WFSUtil.getQueryLockHintStr(dbType));
						rs = stmt.executeQuery(strQuery.toString());
						if (rs != null && rs.next()) {*/
							bfoundInHistory = true;
						//}
					}
					if (bfoundInHistory) {

						tempXml.append(gen.writeValueOf("InstrumentStatus", rs.getString("InstrumentStatus")));
						tempXml.append(gen.writeValueOf("CheckListCompleteFlag", rs.getString("CheckListCompleteFlag")));
						tempXml.append(gen.writeValueOf("Status", rs.getString("Status")));
						tempXml.append(gen.writeValueOf("Referredby", rs.getString("ReferredByName")));
						tempXml.append(gen.writeValueOf("Referredto", rs.getString("ReferredTo")));
						//tempXml.append(gen.writeValueOf("CreatedByUserName", rs.getString("CreatedByName")));
						userName = rs.getString("CreatedByName");	/*WFS_8.0_039*/
						userInfo = (WFUserInfo) CachedObjectCollection.getReference().getCacheObject(con, engine, 0, WFSConstant.CACHE_CONST_UserCache, "userName" + string21 + userName).getData();
						if (userInfo !=null){
							personalName = userInfo.getPersonalName();
                            familyName = userInfo.getFamilyName();
                            if(familyName == null)
                            {
                            familyName = "";
                            }
						} else {
							personalName = null;
                            familyName = ""; 
						}
						tempXml.append(gen.writeValueOf("CreatedByUserName", userName));
						tempXml.append(gen.writeValueOf("CreatedByPersonalName", personalName + " " + familyName));
						tempXml.append(gen.writeValueOf("CreationDateTime", rs.getString("CreatedDateTime")));
						tempXml.append(gen.writeValueOf("IntroductionDateTime", rs.getString("IntroductionDateTime")));
						//tempXml.append(gen.writeValueOf("IntroducedBy", rs.getString("IntroducedBy")));
						userName = rs.getString("IntroducedBy");	/*WFS_8.0_039*/
						userInfo = (WFUserInfo) CachedObjectCollection.getReference().getCacheObject(con, engine, 0, WFSConstant.CACHE_CONST_UserCache, "userName" + string21 + userName).getData();
						if (userInfo !=null){
							personalName = userInfo.getPersonalName();
                            familyName = userInfo.getFamilyName();
                            if(familyName == null)
                            {
                            familyName = "";
                            }
						} else {
							personalName = null;
                            familyName = ""; 
						}
						tempXml.append(gen.writeValueOf("IntroducedBy", userName));
						tempXml.append(gen.writeValueOf("IntroducedByPersonalName", personalName + " " + familyName));
						tempXml.append(gen.writeValueOf("ProcessInstanceState", rs.getString("ProcessInstanceState")));
						tempXml.append(gen.writeValueOf("CacheTime", new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.US).format(CachedObjectCollection.getReference().getProcessLastModifiedTime(con, engine, prcoessdefid)))); //bug # 1608
						tempXml.append(gen.writeValueOf("Turnaroundtime", turnAroundTime));
					}
					if (rs != null) {
						rs.close();
						rs = null;
					}

					if (bCheckQueryWorkStep) { //	SrNo-9
						if (aType.trim().equalsIgnoreCase("F") || aType.trim().equalsIgnoreCase("E")) {
							if (assnuserId != userid) {
								bFetchQueryWorkStepId = true;
							}
						} else if (bInQueue) {
							//Filter Option
                           	if(ArchiveSearch!=null && ArchiveSearch.equalsIgnoreCase("Y")) {
                                  pstmt = tarConn.prepareStatement("Select QueueDefTable.FilterOption,  from QueueDefTable , QUserGroupView " + " where QueueDefTable.QueueID = QUserGroupView.QueueID AND QueueDefTable.QueueID = ? AND UserId = ? ");
                          	 }
                           	else{
                           		pstmt = con.prepareStatement("Select QueueDefTable.FilterOption,  from QueueDefTable , QUserGroupView " + " where QueueDefTable.QueueID = QUserGroupView.QueueID AND QueueDefTable.QueueID = ? AND UserId = ? ");
                           	}
							pstmt.setInt(1, queueId);
							pstmt.setInt(2, userid);

							pstmt.execute();
							rs = pstmt.getResultSet();

							if (rs != null && rs.next()) {
								//Check for filter option and Query Filter.. for getting if user has rights on queue
								filterOption = rs.getInt("FilterOption");
								queueFilter = rs.getString("QueueFilter");
								queueFilter = rs.wasNull() ? "" : queueFilter;
							} else { //Not associated in Queue....
								bFetchQueryWorkStepId = true;
							}

							rs.close();
							pstmt.close();

							if (!bFetchQueryWorkStepId) {
								//Check For Filter Option
								if (filterOption == WFSConstant.WF_EQUAL || filterOption == WFSConstant.WF_NOTEQ) {

									filterValue = "  filterValue" + (filterOption == WFSConstant.WF_NOTEQ ? " != " : " = ") + userid;

									strBuff = new StringBuffer(" SELECT ProcessInstanceId From ");
									strBuff.append(" WFInstrumentTable " + WFSUtil.getTableLockHintStr(dbType));
									strBuff.append(" WHERE ProcessInstanceId = ? ");
									//strBuff.append(TO_STRING(spInstId, true, dbType));
									strBuff.append(" AND WorkItemId = ? ");
									//strBuff.append(nwrkItmId);
									strBuff.append(" AND RoutingStatus = ? ");
									strBuff.append(" AND ( "); //
									strBuff.append(filterValue);
									strBuff.append(" ) ");
									strBuff.append(WFSUtil.getQueryLockHintStr(dbType));
									WFSUtil.printOut(engine,strQuery.toString());
									
									pstmt = con.prepareStatement(strQuery.toString());
									WFSUtil.DB_SetString(1,spInstId, pstmt, dbType);
									pstmt.setInt(2, nwrkItmId);
									WFSUtil.DB_SetString(3,"N", pstmt, dbType);
									parameters.add(Arrays.asList(spInstId, nwrkItmId, "N"));
					
									rs = WFSUtil.jdbcExecuteQuery(spInstId, sessionID, userid, strQuery.toString(), pstmt, parameters, debugFlag, engine);
									parameters.clear();
									//rs = stmt.executeQuery(strBuff.toString());

									if (rs != null && rs.next()) {
										bFetchQueryWorkStepId = false;
									} else {
										bFetchQueryWorkStepId = true;
									}

									rs.close();
									pstmt.close();
								}
							}

							if (!bFetchQueryWorkStepId) {
								String innerOrderBy = "";
								String[] result = null;
								result = WFSUtil.getQueryFilter(con, queueId, dbType, participant, queueFilter, engine);
								queryFilter = result[0];
								innerOrderBy = result[1];

								if (queryFilter != null && (!queryFilter.trim().equals(""))) {
									strBuff = new StringBuffer(" SELECT ProcessInstanceId From ");
									
									strBuff.append(" WFInstrumentTable ");
									//strBuff.append(qType.trim().equalsIgnoreCase("F") ? " QueueDataTable " + WFSUtil.getTableLockHintStr(dbType) : " WFWorklistView_" + queueId);
									strBuff.append(" WHERE ProcessInstanceId = ? ");
									//strBuff.append(TO_STRING(spInstId, true, dbType));
									strBuff.append(" AND WorkItemId = ? ");
									//strBuff.append(nwrkItmId);
									strBuff.append(" AND ( "); //QueryFilter is not NULL
									strBuff.append(TO_SANITIZE_STRING(queryFilter, true));
									strBuff.append(" ) ");
									strBuff.append(WFSUtil.getQueryLockHintStr(dbType));
//								WFSUtil.printOut(engine,"strBuff.toString()  " + strBuff.toString());
									
									pstmt = con.prepareStatement(strBuff.toString());
									WFSUtil.DB_SetString(1,spInstId, pstmt, dbType);
									pstmt.setInt(2, nwrkItmId);
									parameters.add(Arrays.asList(spInstId, nwrkItmId));
					
									rs = WFSUtil.jdbcExecuteQuery(spInstId, sessionID, userid, strBuff.toString(), pstmt, parameters, debugFlag, engine);
									parameters.clear();
									
									//rs = stmt.executeQuery(strBuff.toString());
									if (rs != null && rs.next()) {
										bFetchQueryWorkStepId = false;
									} else {
										//set maincode to a value other than 0	--- Don't let user lock workitem
										bFetchQueryWorkStepId = true;
									}
									rs.close();
									pstmt.close();
								}
							}

						} else {
							//Not in Queue , To be opened as Query WorkStep rights....
							bFetchQueryWorkStepId = true;
						}

						//if fails anywhere then return the QueryWorkStepId
						if (bFetchQueryWorkStepId) {
                            if(ArchiveSearch!=null && ArchiveSearch.equalsIgnoreCase("Y")) {
                               pstmt = tarConn.prepareStatement(
							 	"Select ActivityTable.ActivityId from ActivityTable, QueueStreamTable , QUserGroupView" + " where ActivityTable.ProcessDefId = QueueStreamTable.ProcessDefId " + " AND ActivityTable.ActivityId = QueueStreamTable.ActivityId " + " AND QUserGroupView.QueueId = QueueStreamTable.QueueId " + " AND ActivityTable.ActivityType = " + WFSConstant.ACT_QUERY + " AND ActivityTable.ProcessDefId = ? " + " AND QUserGroupView.UserId = ? ");
                            }
                            else{
							pstmt = con.prepareStatement(
									"Select ActivityTable.ActivityId from ActivityTable, QueueStreamTable , QUserGroupView" + " where ActivityTable.ProcessDefId = QueueStreamTable.ProcessDefId " + " AND ActivityTable.ActivityId = QueueStreamTable.ActivityId " + " AND QUserGroupView.QueueId = QueueStreamTable.QueueId " + " AND ActivityTable.ActivityType = " + WFSConstant.ACT_QUERY + " AND ActivityTable.ProcessDefId = ? " + " AND QUserGroupView.UserId = ? ");
                            }
							pstmt.setInt(1, prcoessdefid);
							pstmt.setInt(2, userid);

							pstmt.execute();
							rs = pstmt.getResultSet();
							if (rs != null && rs.next()) {
								tempXml.append("<QueryActivityId>" + rs.getString("ActivityId") + "</QueryActivityId>");
							} else {
								mainCode = WFSError.WF_NO_AUTHORIZATION;
								subCode = WFSError.WFS_ERR_NO_QUERYACTIVITY_DEFINED;
								subject = WFSErrorMsg.getMessage(mainCode);
								descr = WFSErrorMsg.getMessage(subCode); //"No QueryActivity found for the loggedin user.";
								errType = WFSError.WF_TMP;
							}
							rs.close();
							pstmt.close();
						}
					}

					tempXml.append("</Instrument>\n");

				} else {
					mainCode = WFSError.WM_INVALID_FILTER;
					subCode = WFSError.WM_INVALID_PROCESS_INSTANCE;
				}
				//WFS_6_023

				if (!con.getAutoCommit()) {
                    con.commit();
                    con.setAutoCommit(true);
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
				outputXML.append(gen.createOutputFile("WFGetWorkitemData"));
				outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
				outputXML.append(tempXml);
				outputXML.append(gen.closeOutputFile("WFGetWorkitemData"));
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

			
            if(tarConn!=null) {
                try {
                     	tarConn.close();
                     	tarConn=null;
                     }
                     catch(Exception e) {
                        WFSUtil.printOut(engine,"[Exception occurred while trying to close the Connection for Target Cabinet ::: "+e);
                      //  throw new WFSException(mainCode, subCode, errType, subject, descr);
                     }
        }
		}
		if (mainCode != 0) {
			throw new WFSException(mainCode, subCode, errType, subject, descr);
		}
		return outputXML.toString();
        
        /*	int mainCode = WFSError.WF_API_NOT_SUPPORTED;
		int subCode = 0;
		String subject = WFSErrorMsg.getMessage(mainCode);
		String errType = WFSError.WF_TMP;
		String descr = WFSErrorMsg.getMessage(subCode);
		throw new WFSException(mainCode, subCode, errType, subject, descr);

	

		String strReturn = WFSUtil.generalError(option, engine, gen,
                   mainCode, subCode,
                   errType, subject,
                    descr);
             
             return strReturn;	*/
             
             
             
		/*String descr = e.toString();*/
		/*
		StringBuffer outputXML = null;
		Statement stmt = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int mainCode = 0;
		int subCode = 0;
		String subject = null;
		String descr = null;
		String errType = WFSError.WF_TMP;
		StringBuffer tempXml = null;
		ArrayList parameters = new ArrayList();
		try {
			int sessionID = parser.getIntOf("SessionId", 0, false);
			String engine = parser.getValueOf("EngineName");
			boolean bCheckQueryWorkStep = parser.getValueOf("QueryWorkStep", "N", true).trim().equalsIgnoreCase("Y") ? true : false;
			int dbType = ServerProperty.getReference().getDBType(engine);

			boolean bInQueue = false;
			boolean bFetchQueryWorkStepId = false;
			String filterValue = null;
			String aType = null;
			StringBuffer strBuff = null;
			int assnuserId;
			int filterOption = 0;
			String queueFilter = "";
			int prcoessdefid;
			String queryFilter = null;
			String qType = null;
			boolean debugFlag=true;

			WFParticipant participant = WMUser.WFCheckUpdateSession(con, sessionID, dbType);
			if (participant != null && participant.gettype() == 'U') {
				int userid = participant.getid();
				String username = participant.getname();

				int i = 0;
//        char dataflag = parser.getCharOf("DataFlag", 'N', true);
				String spInstId = parser.getValueOf("ProcessInstanceId", "", false);
				int nwrkItmId = parser.getIntOf("WorkItemId", 0, false);
				int queueId = -1;
				String stableName = null;
				//String stablename = "WFWorklistview_0";		//WFS_6_023

				//WFS_6_023
				StringBuffer queryString = new StringBuffer();
				StringBuffer strQuery = null;
				StringBuffer filterStr = new StringBuffer();
				boolean resultExist = false;
				boolean bfoundInHistory = false;

				filterStr.append(" where ProcessInstanceId = ");
				// Tirupati Srivastava : changes made to make code compatible with postgreSQL
				//filterStr.append(WFSConstant.WF_VARCHARPREFIX);
				//filterStr.append(spInstId);
				filterStr.append(TO_STRING(spInstId, true, dbType));
				filterStr.append(" AND ");
				filterStr.append(" Workitemid = ");
				filterStr.append(nwrkItmId);

				queryString.append(" Select ProcessInstanceId, ProcessInstanceId as ProcessinstanceName, ProcessdefId, ");
				queryString.append(" ProcessName, ActivityId, ActivityName, PriorityLevel, ");
				queryString.append(" LockStatus, LockedbyName, ValidTill, ");
				queryString.append(" StateName, EntryDateTime, LockedTime, ");
				queryString.append(" AssignedUser, WorkitemId, QueueName, AssignmentType, ");
				queryString.append(" Queuetype,  Q_QueueId, ");
				queryString.append(" '' as TurnaroundTime, Q_UserId, WorkItemState ");
				
		        String queryForActiveData = " Select ProcessInstanceId, ProcessInstanceId as ProcessinstanceName, ProcessdefId," +
		        		"ProcessName, ActivityId, ActivityName, PriorityLevel, LockStatus, LockedbyName, ValidTill, " +
		        		"StateName, EntryDateTime, LockedTime,AssignedUser, WorkitemId, QueueName, AssignmentType," +
		        		"Queuetype,  Q_QueueId,'' as TurnaroundTime, Q_UserId, WorkItemState,, InstrumentStatus , " +
		        		"CheckListCompleteFlag, Status, ReferredByName, ReferredTo,CreatedByName, CreatedDateTime, " +
		        		"IntroductionDateTime, IntroducedBy, ProcessInstanceState from WFInstrumentTable "+ WFSUtil.getTableLockHintStr(dbType)
		        		+ " where ProcessInstanceId= ? and WorkItemId= ? and RoutingStatus = ? "+ WFSUtil.getQueryLockHintStr(dbType);
		        
		        String queryForHistoryData = " Select ProcessInstanceId, ProcessInstanceId as ProcessinstanceName, ProcessdefId," +
        		"ProcessName, ActivityId, ActivityName, PriorityLevel, LockStatus, LockedbyName, ValidTill, " +
        		"StateName, EntryDateTime, LockedTime,AssignedUser, WorkitemId, QueueName, AssignmentType," +
        		"Queuetype,  Q_QueueId,'' as TurnaroundTime, Q_UserId, WorkItemState,, InstrumentStatus , " +
        		"CheckListCompleteFlag, Status, ReferredByName, ReferredTo,CreatedByName, CreatedDateTime, " +
        		"IntroductionDateTime, IntroducedBy, ProcessInstanceState from QueueHistoryTable "+ WFSUtil.getTableLockHintStr(dbType)
        		+ " where ProcessInstanceId= ? and WorkItemId= ? "+ WFSUtil.getQueryLockHintStr(dbType);
		       
		        String workitemExistsQuery = " Select ProcessInstanceId, ProcessInstanceId as ProcessinstanceName, ProcessdefId," +
        		"ProcessName, ActivityId, ActivityName, PriorityLevel, LockStatus, LockedbyName, ValidTill, " +
        		"StateName, EntryDateTime, LockedTime,AssignedUser, WorkitemId, QueueName, AssignmentType," +
        		"Queuetype,  Q_QueueId,'' as TurnaroundTime, Q_UserId, WorkItemState,, InstrumentStatus , " +
        		"CheckListCompleteFlag, Status, ReferredByName, ReferredTo,CreatedByName, CreatedDateTime, " +
        		"IntroductionDateTime, IntroducedBy, ProcessInstanceState from WFInstrumentTable "+ WFSUtil.getTableLockHintStr(dbType)
        		+ " where ProcessInstanceId= ? and WorkItemId= ? "+ WFSUtil.getQueryLockHintStr(dbType);
		        
				stmt = con.createStatement();
		        pstmt=con.prepareStatement(queryForActiveData);
		        pstmt.setString(1, spInstId);
		        pstmt.setInt(2,nwrkItmId);
		        pstmt.setString(3,"N");
		        parameters.add(spInstId);
		        parameters.add(nwrkItmId);
		        parameters.add("N");
		        rs = WFSUtil.jdbcExecuteQuery(spInstId, sessionID, userid, queryForActiveData, pstmt, parameters, debugFlag, engine);
		        parameters.clear();
		        pstmt.close();
		        pstmt=null;
				rs = stmt.executeQuery(queryString.toString() + " from WorkListTable " + WFSUtil.getTableLockHintStr(dbType) 
						+ filterStr.toString() + WFSUtil.getQueryLockHintStr(dbType));
				if (!rs.next()) {
					if (rs != null) {
						rs.close();
						rs = null;
					}
					rs = stmt.executeQuery(queryString.toString() + " from WorkInProcessTable "
							+ WFSUtil.getTableLockHintStr(dbType) + filterStr.toString() + WFSUtil.getQueryLockHintStr(dbType));
					if (!rs.next()) {
						if (rs != null) {
							rs.close();
							rs = null;
						}
						//Find the workItem in HistoryTable
						strQuery = new StringBuffer();
						strQuery.append(" , InstrumentStatus , CheckListCompleteFlag, Status, ReferredByName, ReferredTo, ");
						strQuery.append(" CreatedByName, CreatedDateTime, IntroductionDateTime, IntroducedBy, ProcessInstanceState ");
						strQuery.append(" FROM QueueHistoryTable ");
						strQuery.append(WFSUtil.getTableLockHintStr(dbType));
//                        strQuery.append(WFSUtil.getQueryLockHintStr(dbType));// Bugzilla # 103
//						WFSUtil.printOut(engine,"Here is the Query of GetWorkitemData======"+queryString.toString() + strQuery.toString() + filterStr.toString());
						rs = stmt.executeQuery(queryString.toString() + strQuery.toString() + filterStr.toString() + WFSUtil.getQueryLockHintStr(dbType));
				        pstmt=con.prepareStatement(queryForHistoryData);
				        pstmt.setString(1, spInstId);
				        pstmt.setInt(2,nwrkItmId);
				        parameters.add(spInstId);
				        parameters.add(nwrkItmId);
				        rs = WFSUtil.jdbcExecuteQuery(spInstId, sessionID, userid, queryForHistoryData, pstmt, parameters, debugFlag, engine);
				        parameters.clear();
				        pstmt.close();
				        pstmt=null;
						if (!rs.next()) {
							if (rs != null) {
								rs.close();
								rs = null;
							}
							pstmt=con.prepareStatement(workitemExistsQuery);
							pstmt.setString(1, spInstId);
						    pstmt.setInt(2,nwrkItmId);
						    parameters.add(spInstId);
						    parameters.add(nwrkItmId);
							rs =WFSUtil.jdbcExecuteQuery(spInstId, sessionID, userid, workitemExistsQuery, pstmt, parameters, debugFlag, engine);
					        parameters.clear();
					        //stmt.executeQuery(queryString.toString() + " from PendingWorkListTable " + WFSUtil.getTableLockHintStr(dbType) + filterStr.toString() + WFSUtil.getQueryLockHintStr(dbType));
							if (!rs.next()) {
								if (rs != null) {
									rs.close();
									rs = null;
								}

								rs = stmt.executeQuery(queryString.toString() + " from WorkDoneTable " + WFSUtil.getTableLockHintStr(dbType) + filterStr.toString() + WFSUtil.getQueryLockHintStr(dbType));
								if (!rs.next()) {
									if (rs != null) {
										rs.close();
										rs = null;
									}
									rs = stmt.executeQuery(queryString.toString() + " from WorkWithPSTable " + WFSUtil.getTableLockHintStr(dbType) + filterStr.toString() + WFSUtil.getQueryLockHintStr(dbType));
									if (rs.next()) {
										resultExist = true;
									}
								} else {
									resultExist = true;
								}
							} else {
								resultExist = true;
							}
						} else {
							resultExist = true;
							bfoundInHistory = true;
						}
					} else {
						stableName = "WorkInProcessTable";
						bInQueue = true;
						resultExist = true;
					}
				} else {
					//stableName = "WorkListTable";
					bInQueue = true;
					resultExist = true;
				}

				String userName = null;
				String personalName = null;
				if (resultExist) {
					tempXml = new StringBuffer();
					tempXml.append("<Instrument>\n");

					tempXml.append(gen.writeValueOf("ProcessInstanceId", rs.getString("ProcessInstanceId")));
					tempXml.append(gen.writeValueOf("ProcessInstanceName", rs.getString("ProcessinstanceName")));
					prcoessdefid = rs.getInt("ProcessdefId");
					tempXml.append(gen.writeValueOf("RouteId", String.valueOf(prcoessdefid)));
					tempXml.append(gen.writeValueOf("RouteName", rs.getString("ProcessName")));
					tempXml.append(gen.writeValueOf("WorkStageId", rs.getString("ActivityId")));
					tempXml.append(gen.writeValueOf("ActivityName", rs.getString("ActivityName")));
					tempXml.append(gen.writeValueOf("PriorityLevel", rs.getString("PriorityLevel")));
					tempXml.append(gen.writeValueOf("LockStatus", rs.getString("LockStatus")));
					//tempXml.append(gen.writeValueOf("LockedByUserName", rs.getString("LockedbyName")));
					userName = rs.getString("LockedbyName");	WFS_8.0_039
					WFUserInfo userInfo = (WFUserInfo) CachedObjectCollection.getReference().getCacheObject(con, engine, 0, WFSConstant.CACHE_CONST_UserCache, "userName#" + userName).getData();
					if (userInfo != null) {
						personalName = userInfo.getPersonalName();
					} else {
						personalName = null;
					}
					tempXml.append(gen.writeValueOf("LockedByUserName", userName));
					tempXml.append(gen.writeValueOf("LockedByPersonalName", personalName));
					tempXml.append(gen.writeValueOf("ExpiryDateTime", rs.getString("ValidTill")));
					tempXml.append(gen.writeValueOf("Statename", rs.getString("StateName")));
					tempXml.append(gen.writeValueOf("EntryDateTime", rs.getString("EntryDateTime")));
					tempXml.append(gen.writeValueOf("LockedTime", rs.getString("LockedTime")));
					//tempXml.append(gen.writeValueOf("AssignedTo", rs.getString("AssignedUser")));
					userName = rs.getString("AssignedUser");	WFS_8.0_039
					userInfo = (WFUserInfo) CachedObjectCollection.getReference().getCacheObject(con, engine, 0, WFSConstant.CACHE_CONST_UserCache, "userName#" + userName).getData();
					if (userInfo != null) {
						personalName = userInfo.getPersonalName();
					} else {
						personalName = null;
					}
					tempXml.append(gen.writeValueOf("AssignedTo", userName));
					tempXml.append(gen.writeValueOf("AssignedToPersonalName", personalName));
					tempXml.append(gen.writeValueOf("WorkItemId", rs.getString("WorkitemId")));
					tempXml.append(gen.writeValueOf("QueueName", rs.getString("QueueName")));
					aType = rs.getString("AssignmentType");
					tempXml.append(gen.writeValueOf("AssignmentType", aType));
					aType = rs.wasNull() ? "S" : aType;
					qType = rs.getString("Queuetype");
					tempXml.append(gen.writeValueOf("QueueType", qType));
					queueId = rs.getInt("Q_QueueId");
					tempXml.append(gen.writeValueOf("QueueId", String.valueOf(queueId)));
					tempXml.append(gen.writeValueOf("Turnaroundtime", rs.getString("TurnaroundTime")));
					assnuserId = rs.getInt("Q_UserId");
					tempXml.append(gen.writeValueOf("UserID", String.valueOf(assnuserId)));
					tempXml.append(gen.writeValueOf("WorkitemState", rs.getString("WorkItemState")));

					if (!bfoundInHistory) {
						//CLOSE THE RESULTSET all the relevent data has already been captured
						if (rs != null) {
							rs.close();
							rs = null;
						}
						strQuery = new StringBuffer();
						strQuery.append("Select InstrumentStatus , CheckListCompleteFlag, Status, ReferredByName, ReferredTo, ");
						strQuery.append("B.CreatedByName, B.CreatedDateTime, B.IntroductionDateTime, B.IntroducedBy, B.ProcessInstanceState ");
						strQuery.append("from QueueDataTable" + WFSUtil.getTableLockHintStr(dbType));
						strQuery.append(", (Select CreatedByName, CreatedDateTime, IntroductionDateTime, IntroducedBy, ProcessInstanceState ");
						// Tirupati Srivastava : changes made to make code compatible with postgreSQL
						//strQuery.append("from ProcessinstanceTable " + WFSUtil.getTableLockHintStr(dbType) + " where processInstanceId = N'" + spInstId + "') B");
						strQuery.append("from ProcessinstanceTable " + WFSUtil.getTableLockHintStr(dbType) + " where processInstanceId = " + TO_STRING(spInstId, true, dbType) + " ) B");
						strQuery.append(filterStr);
						strQuery.append(WFSUtil.getQueryLockHintStr(dbType));
						rs = stmt.executeQuery(strQuery.toString());
						if (rs != null && rs.next()) {
							bfoundInHistory = true;
						}
					}
					//if (bfoundInHistory) {

						tempXml.append(gen.writeValueOf("InstrumentStatus", rs.getString("InstrumentStatus")));
						tempXml.append(gen.writeValueOf("CheckListCompleteFlag", rs.getString("CheckListCompleteFlag")));
						tempXml.append(gen.writeValueOf("Status", rs.getString("Status")));
						tempXml.append(gen.writeValueOf("Referredby", rs.getString("ReferredByName")));
						tempXml.append(gen.writeValueOf("Referredto", rs.getString("ReferredTo")));
						//tempXml.append(gen.writeValueOf("CreatedByUserName", rs.getString("CreatedByName")));
						userName = rs.getString("CreatedByName");	WFS_8.0_039
						userInfo = (WFUserInfo) CachedObjectCollection.getReference().getCacheObject(con, engine, 0, WFSConstant.CACHE_CONST_UserCache, "userName#" + userName).getData();
						if (userInfo != null) {
							personalName = userInfo.getPersonalName();
						} else {
							personalName = null;
						}
						tempXml.append(gen.writeValueOf("CreatedByUserName", userName));
						tempXml.append(gen.writeValueOf("CreatedByPersonalName", personalName));
						tempXml.append(gen.writeValueOf("CreationDateTime", rs.getString("CreatedDateTime")));
						tempXml.append(gen.writeValueOf("IntroductionDateTime", rs.getString("IntroductionDateTime")));
						//tempXml.append(gen.writeValueOf("IntroducedBy", rs.getString("IntroducedBy")));
						userName = rs.getString("IntroducedBy");	WFS_8.0_039
						userInfo = (WFUserInfo) CachedObjectCollection.getReference().getCacheObject(con, engine, 0, WFSConstant.CACHE_CONST_UserCache, "userName#" + userName).getData();
						if (userInfo != null) {
							personalName = userInfo.getPersonalName();
						} else {
							personalName = null;
						}
						tempXml.append(gen.writeValueOf("IntroducedBy", userName));
						tempXml.append(gen.writeValueOf("IntroducedByPersonalName", personalName));
						tempXml.append(gen.writeValueOf("ProcessInstanceState", rs.getString("ProcessInstanceState")));
						tempXml.append(gen.writeValueOf("CacheTime", new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.US).format(CachedObjectCollection.getReference().getProcessLastModifiedTime(con, engine, prcoessdefid)))); //bug # 1608
				//	}
					if (rs != null) {
						rs.close();
						rs = null;
					}

					if (bCheckQueryWorkStep) { //	SrNo-9
						if (aType.trim().equalsIgnoreCase("F") || aType.trim().equalsIgnoreCase("E")) {
							if (assnuserId != userid) {
								bFetchQueryWorkStepId = true;
							}
						} else if (bInQueue) {
							//Filter Option
							pstmt = con.prepareStatement("Select QueueDefTable.FilterOption,QueueFilter  from QueueDefTable , UserQueueTable" +
									" where QueueDefTable.QueueID = UserQueueTable.QueueID AND QueueDefTable.QueueID = ? AND UserId = ? ");

							pstmt.setInt(1, queueId);
							pstmt.setInt(2, userid);

							pstmt.execute();
							rs = pstmt.getResultSet();

							if (rs != null && rs.next()) {
								//Check for filter option and Query Filter.. for getting if user has rights on queue
								filterOption = rs.getInt("FilterOption");
								queueFilter = rs.getString("QueueFilter");
								queueFilter = rs.wasNull() ? "" : queueFilter;
							} else { //Not associated in Queue....
								bFetchQueryWorkStepId = true;
							}

							rs.close();
							pstmt.close();

							if (!bFetchQueryWorkStepId) {
								//Check For Filter Option
								if (filterOption == WFSConstant.WF_EQUAL || filterOption == WFSConstant.WF_NOTEQ) {

									filterValue = "  filterValue" + (filterOption == WFSConstant.WF_NOTEQ ? " != " : " = ") + userid;

									strBuff = new StringBuffer(" SELECT ProcessInstanceId From ");
									strBuff.append(stableName + WFSUtil.getTableLockHintStr(dbType));
									strBuff.append(" WHERE ProcessInstanceId = ");
									strBuff.append(TO_STRING(spInstId, true, dbType));
									strBuff.append(" AND WorkItemId = ");
									strBuff.append(nwrkItmId);
									strBuff.append(" AND ( "); //
									strBuff.append(filterValue);
									strBuff.append(" ) ");
									strBuff.append(WFSUtil.getQueryLockHintStr(dbType));
									WFSUtil.printOut(engine,strQuery.toString());
									rs = stmt.executeQuery(strBuff.toString());

									if (rs != null & rs.next()) {
										bFetchQueryWorkStepId = false;
									} else {
										bFetchQueryWorkStepId = true;
									}

									rs.close();
								}
							}

							if (!bFetchQueryWorkStepId) {
								String innerOrderBy = "";
								String[] result = null;
								result = WFSUtil.getQueryFilter(con, queueId, dbType, participant, queueFilter, engine);
								queryFilter = result[0];
								innerOrderBy = result[1];

								if (queryFilter != null && (!queryFilter.trim().equals(""))) {
									strBuff = new StringBuffer(" SELECT ProcessInstanceId From ");
									strBuff.append(qType.trim().equalsIgnoreCase("F") ? " QueueDataTable " + 
									WFSUtil.getTableLockHintStr(dbType) : " WFWorklistView_" + queueId);
									strBuff.append(" WHERE ProcessInstanceId = ");
									strBuff.append(TO_STRING(spInstId, true, dbType));
									strBuff.append(" AND WorkItemId = ");
									strBuff.append(nwrkItmId);
									strBuff.append(" AND ( "); //QueryFilter is not NULL
									strBuff.append(queryFilter);
									strBuff.append(" ) ");
									strBuff.append(WFSUtil.getQueryLockHintStr(dbType));
//								WFSUtil.printOut(engine,"strBuff.toString()  " + strBuff.toString());
									rs = stmt.executeQuery(strBuff.toString());
									if (rs != null & rs.next()) {
										bFetchQueryWorkStepId = false;
									} else {
										//set maincode to a value other than 0	--- Don't let user lock workitem
										bFetchQueryWorkStepId = true;
									}
									rs.close();
								}
							}

						} else {
							//Not in Queue , To be opened as Query WorkStep rights....
							bFetchQueryWorkStepId = true;
						}

						//if fails anywhere then return the QueryWorkStepId
						if (bFetchQueryWorkStepId) {

							pstmt = con.prepareStatement(
									"Select ActivityTable.ActivityId from ActivityTable, QueueStreamTable , UserQueueTable" 
									+ " where ActivityTable.ProcessDefId = QueueStreamTable.ProcessDefId " + " AND ActivityTable.ActivityId " +
									"= QueueStreamTable.ActivityId " + " AND UserQueueTable.QueueId = QueueStreamTable.QueueId "
									+ " AND ActivityTable.ActivityType = " + WFSConstant.ACT_QUERY + " AND ActivityTable.ProcessDefId = ? " 
									+ " AND UserQueueTable.UserId = ? ");
							pstmt.setInt(1, prcoessdefid);
							pstmt.setInt(2, userid);

							pstmt.execute();
							rs = pstmt.getResultSet();
							if (rs != null && rs.next()) {
								tempXml.append("<QueryActivityId>" + rs.getString("ActivityId") + "</QueryActivityId>");
							} else {
								mainCode = WFSError.WF_NO_AUTHORIZATION;
								subCode = WFSError.WFS_ERR_NO_QUERYACTIVITY_DEFINED;
								subject = WFSErrorMsg.getMessage(mainCode);
								descr = WFSErrorMsg.getMessage(subCode); //"No QueryActivity found for the loggedin user.";
								errType = WFSError.WF_TMP;
							}
							rs.close();
							pstmt.close();
						}
					}

					tempXml.append("</Instrument>\n");

				} else {
					mainCode = WFSError.WM_INVALID_FILTER;
					subCode = WFSError.WM_INVALID_PROCESS_INSTANCE;
				}
				//WFS_6_023

			} else {
				mainCode = WFSError.WM_INVALID_SESSION_HANDLE;
				subCode = 0;
				subject = WFSErrorMsg.getMessage(mainCode);
				descr = WFSErrorMsg.getMessage(subCode);
				errType = WFSError.WF_TMP;
			}
			if (mainCode == 0) {
				outputXML = new StringBuffer(500);
				outputXML.append(gen.createOutputFile("WFGetWorkitemData"));
				outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
				outputXML.append(tempXml);
				outputXML.append(gen.closeOutputFile("WFGetWorkitemData"));
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

			if (mainCode != 0) {
				throw new WFSException(mainCode, subCode, errType, subject, descr);
			}
		}
		return outputXML.toString();
	*/}

	//----------------------------------------------------------------------------------------------------
	//	Function Name 				    :	WFGetNextWorkitemforPublish
	//	Date Written (DD/MM/YYYY)		:	23/09/2005
	//	Author						    :	Ashish Mangla
	//	Input Parameters		    	:	Connection , XMLParser , XMLGenerator
	//	Output Parameters			    :	none
	//	Return Values				    :	String
	//	Description					    :	Get Next Workitem for publishing JMS messages
	//----------------------------------------------------------------------------------------------------
	public String WFGetNextWorkitemforPublish(Connection con, XMLParser parser, XMLGenerator gen) throws JTSException, WFSException {
		return getNextUnlockedWorkitemUtil(con, parser, gen);
	}
/*
	//--------------------------------------------------------------------------------------------------
	//	Function Name 				    :	WFGetNextRecordForExport
	//	Date Written (DD/MM/YYYY)		:	28/11/2007
	//	Author						    :	Shilpi S
	//	Input Parameters		    	:	Connection , XMLParser , XMLGenerator
	//	Output Parameters			    :	none
	//	Return Values				    :	String
	//	Description					    :	Get Next record for export
	//  Change Description              :   Bug #2795
	//--------------------------------------------------------------------------------------------------
	public String WFGetNextRecordForExport(Connection con, XMLParser parser, XMLGenerator gen) throws JTSException, WFSException {
		StringBuffer outputXML = null;
		Statement stmt = null;
		Statement update_stmt = null; //Bug # 3058
		ResultSet rs = null;
		ResultSet rs1 = null;//WFS_8.0_078
		int mainCode = WFSError.WM_NO_MORE_DATA;
		int subCode = 0;
		String subject = null;
		String descr = null;
		String errType = WFSError.WF_TMP;
		StringBuffer tempXml = new StringBuffer(500);
		int cssession = 0;
		boolean found = false;
		boolean commit = false;
		String sqNumber = "";
		try {
			//Bug # 3058
			if (con.getAutoCommit()) {
				con.setAutoCommit(false);
				commit = true;
			}

			int sessionID = parser.getIntOf("SessionId", 0, false);
			String engine = parser.getValueOf("EngineName");
			int dbType = ServerProperty.getReference().getDBType(engine);
			String csName = parser.getValueOf("CSName");
			int ProcessDefId = parser.getIntOf("ProcessDefId", 0, false);
			int ActivityId = parser.getIntOf("ActivityId", 0, false);
			String filter = parser.getValueOf("Filter");
			String orderBy = parser.getValueOf("OrderBy");
			String exportTable = parser.getValueOf("TableName");
			String queryString = "";
			String queryPrefix = "";
			String querySuffix = "";
			int pid = 0,actId = 0;//WFS_8.0_078

			if ((filter != null) && (!filter.equalsIgnoreCase("")) && (filter.trim().length() > 0)) {
				filter = " AND " + filter + " ";
			}
			if ((orderBy != null) && (!orderBy.equalsIgnoreCase("")) && (orderBy.trim().length() > 0)) {
				orderBy = " Order By " + orderBy + " ASC ";
			}

			queryPrefix = " SELECT * FROM " + exportTable + WFSUtil.getLockPrefixStr(dbType) + " Where ExportDataId in ( Select row_id From ( Select  " + WFSUtil.getFetchPrefixStr(dbType, 1) + " exportdataid as row_id , " + exportTable + ".* FROM " + exportTable + " WHERE ProcessDefId = " + ProcessDefId + " AND ActivityId = " + ActivityId;
			 //WFS_8.0_110
			WFParticipant participantDMS ;
			String dmsSessionId = parser.getValueOf("DMSSessionId");
			if((dmsSessionId != null) && !dmsSessionId.equalsIgnoreCase("") && !dmsSessionId.equalsIgnoreCase("null"))
				participantDMS = WMUser.WFCheckUpdateSession(con, Integer.parseInt(dmsSessionId), dbType);
			querySuffix = filter + orderBy + " ) a " + WFSUtil.getFetchSuffixStr(dbType, 1, WFSConstant.QUERY_STR_WHERE) + " ) " + WFSUtil.getLockSuffixStr(dbType);

			/*Bug # 6964*/
		/*	WFParticipant participant = WMUser.WFCheckUpdateSession(con, sessionID, dbType);
			if (participant != null && participant.gettype() == 'P') {
				int userid = participant.getid();
				String username = participant.getname();
				stmt = con.createStatement();
				if (csName != null && !csName.trim().equals("")) {
					rs = stmt.executeQuery(" Select SessionID from PSRegisterationTable where " + TO_STRING("Type", false, dbType) + " = " + TO_STRING("C", true, dbType) + " AND " + TO_STRING("PSName", false, dbType) + " = " + TO_STRING(csName, true, dbType));
					if (rs != null) { //Bug # 3058
						if (rs.next()) {
							cssession = rs.getInt(1);
						}
						rs.close();
						rs = null;
					}
				}
				
				queryString = queryPrefix + " AND " + TO_STRING("LockStatus", false, dbType) + " = " + TO_STRING("Y", true, dbType) + " AND " + TO_STRING("LockedByName", false, dbType) + " = " + TO_STRING(username, true, dbType) + " AND " + TO_STRING("Status", false, dbType) + "  = " + TO_STRING("I", true, dbType) + querySuffix;
				rs = stmt.executeQuery(queryString);
				if (rs != null && rs.next()) {
					found = true;
				} else {
					//Bug # 3058
					if (rs != null) {
						rs.close();
						rs = null;
					}

					queryString = queryPrefix + " AND " + TO_STRING("LockStatus", false, dbType) + " = " + TO_STRING("N", true, dbType) + " AND " + TO_STRING("Status", false, dbType) + "  = " + TO_STRING("N", true, dbType) + querySuffix;
					rs = stmt.executeQuery(queryString);
					if (rs != null && rs.next()) {
					//WFS_8.0_078
					    pid = rs.getInt("ProcessDefId");
						actId = rs.getInt("ActivityId");
						String pInstId = rs.getString("ProcessInstanceId");
						int wid = rs.getInt("WorkitemId");
						int expId = rs.getInt("ExportDataId");//WFS_8.0_076
						queryString = " UPDATE " + exportTable +
								" SET Status" + "  = " + TO_STRING("I", true, dbType) + " , LockStatus" + " = " + TO_STRING("Y", true, dbType) + " , LockedByName " + " = " + TO_STRING(username, true, dbType) + " , LockedTime " + " = " + WFSUtil.getDate(dbType) +
								" WHERE  ProcessDefId = " + pid +
								" AND ActivityId = " + actId +
								" AND ProcessInstanceId  = " + TO_STRING(pInstId, true, dbType) +
								" AND WorkitemId = " + wid +
								" AND ExportDataId = " + expId;//WFS_8.0_076
						update_stmt = con.createStatement(); //Bug # 3058
						update_stmt.executeUpdate(queryString); //Bug # 3058
						found = true;
					} else {
						mainCode = WFSError.WM_NO_MORE_DATA;
						subCode = 0;
						subject = WFSErrorMsg.getMessage(mainCode);
						descr = WFSErrorMsg.getMessage(subCode);
						errType = WFSError.WF_TMP;
					}
				}
				//WFS_8.0_078
				if (found) {
				
					if (rs != null) { //Bug # 3058
						ResultSetMetaData rsMetaData = rs.getMetaData();
						int noOfColumns = rsMetaData.getColumnCount();
						tempXml.append("<ExportData>");
						for (int i = 1; i <= noOfColumns; i++) {
							//WFS_8.0_095
							//WFS_8.0_105
							String value = ""; //Bug #2858
                            Object[] result = null;
                            if(rsMetaData.getColumnType(i)==java.sql.Types.CLOB)
                            {
                                 result=WFSUtil.getBIGData(con, rs, rsMetaData.getColumnName(i), dbType, "8859_1");
                                 value=result[0].toString();
                            }
                            else
                                 value = rs.getString(i); //Bug #2858
							tempXml.append("<Data>");
							if (!rs.wasNull()) {
								tempXml.append("<Name>").append(rsMetaData.getColumnName(i)).append("</Name>");
								tempXml.append("<Value>").append(value).append("</Value>"); // bug # 3733
							}
							else
							{   tempXml.append("<Name>").append(rsMetaData.getColumnName(i)).append("</Name>");
								tempXml.append("<Value>").append("").append("</Value>");
							}
							tempXml.append("</Data>");
						}
				tempXml.append("</ExportData>");
				//WFS_8.0_078
				//WFS_8.0_092
				pid = Integer.parseInt(parser.getValueOf("ProcessDefId"));
				actId = Integer.parseInt(parser.getValueOf("ActivityId"));
				String currentCount = "";
				if(parser.getValueOf("CachedVal").equalsIgnoreCase("true"))
				{
				 String dateValue = parser.getValueOf("Date");
				//SRU_8.0_049
				String likeVal = "";
				String matchValue[] =  parser.getValueOf("ValuesToMatch").split(",");
				for(int count = 0;count < matchValue.length; count++)
				{  likeVal = likeVal + rs.getString(matchValue[count]) +"%";
				}
				likeVal = likeVal + dateValue;
                String queryStr = "Select ExportFileName,SequenceNumber from "+exportTable+" where ExportDataId = " +
                                      "(Select max(ExportDataId) from " + exportTable + " where ProcessDefId = "+pid+"" +
                                      " and ActivityId = "+actId+" and "+TO_STRING("Status", false, dbType) + 
                                      "  = " + TO_STRING("P", true, dbType)+" and ExportFileName like '%"+
                                      likeVal+"%')";
				rs1 = stmt.executeQuery(queryStr);
				String fileNameVal = "";
				int counterRecord = 0;
				int maxRecordSize = 0;
				String flagRecordVal = "";
				if (rs1 != null && rs1.next()) 
					{ 				
					  fileNameVal = rs1.getString("ExportFileName");
					  sqNumber = rs1.getString("SequenceNumber");
					   //WFS_8.0_103
					  if((sqNumber != null) && !sqNumber.equalsIgnoreCase("null")  && (sqNumber.length() != 0))
						  currentCount = sqNumber;
					  else
						  currentCount = parser.getValueOf("CurrentCount");
					  counterRecord = Integer.parseInt(parser.getValueOf("Counter"));
					  maxRecordSize = Integer.parseInt(parser.getValueOf("MaxRecordSize"));
					  flagRecordVal = parser.getValueOf("RecordFlag");
					  if(flagRecordVal.equalsIgnoreCase("false"))
					  {
					  if ( counterRecord < (maxRecordSize - 1) )
						{  	tempXml.append("<Counter>").append(counterRecord+1).append("</Counter>");
							tempXml.append("<RecordFlag>").append("false").append("</RecordFlag>");
						}
					  else
					  {	  
						  tempXml.append("<Counter>").append(0).append("</Counter>");
						  tempXml.append("<RecordFlag>").append("true").append("</RecordFlag>");
					  }
					  }
					  else if(flagRecordVal.equalsIgnoreCase("true"))
					  {   tempXml.append("<Counter>").append(0).append("</Counter>");
					      currentCount = String.valueOf(Integer.parseInt(currentCount) + 1);
						  tempXml.append("<RecordFlag>").append("false").append("</RecordFlag>");
					  }
					}
				else
					{ 
					 tempXml.append("<Counter>").append(0).append("</Counter>");
					 currentCount = parser.getValueOf("CurrentCount");//String.valueOf(Integer.parseInt(currentCount) + 1);
					 tempXml.append("<RecordFlag>").append("false").append("</RecordFlag>");
					}
                                }
				if (rs1 != null) {
					rs1.close();
					rs1 = null;
				}
					
						if(currentCount.length() != 0)
						tempXml.append("<CurrentCount>").append(currentCount).append("</CurrentCount>");
						
						mainCode = 0;
						//Bug # 3058
						if (commit) {
							con.commit();
							con.setAutoCommit(true);
							commit = false;
						}
					}
				}
				if (rs != null) {
					rs.close();
					rs = null;
				}
				if (stmt != null) {
					stmt.close();
					stmt = null;
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
				outputXML.append(gen.createOutputFile("WFGetNextRecordForExport"));
				outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
				outputXML.append(gen.writeValueOf("CSSession", String.valueOf(cssession)));
				outputXML.append(tempXml);
				outputXML.append(gen.closeOutputFile("WFGetNextRecordForExport"));
			}
			if (mainCode == WFSError.WM_NO_MORE_DATA) {
				outputXML = new StringBuffer(500);
				outputXML.append(gen.writeError("WFGetNextRecordForExport",
						WFSError.WM_NO_MORE_DATA, 0,
						WFSError.WF_TMP,
						WFSErrorMsg.getMessage(WFSError.WM_NO_MORE_DATA), ""));
				outputXML.delete(outputXML.indexOf("</" + "WFGetNextRecordForExport" +
						"_Output>"), outputXML.length());
				outputXML.append(gen.writeValueOf("CSSession", String.valueOf(cssession)));
				outputXML.append(gen.closeOutputFile("WFGetNextRecordForExport"));
				mainCode = 0;
			}
		} catch (SQLException e) {
			WFSUtil.printErr(engine,"", e);
			mainCode = WFSError.WM_INVALID_FILTER;
			subCode = WFSError.WFS_SQL;
			subject = WFSErrorMsg.getMessage(mainCode);
			errType = WFSError.WF_FAT;
			if (e.getErrorCode() == 0) {
				if (e.getSQLState().equalsIgnoreCase("08S01")) {
					descr = (new JTSSQLError(e.getSQLState())).getMessage() +
							"(SQL State : " + e.getSQLState() + ")";
				}
			} else {
				descr = e.getMessage();
			}
			try {
				if (!con.getAutoCommit()) {
					con.rollback();
					con.setAutoCommit(true);
				}
			} catch (Exception exp) {
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
				if (commit) {
					if (!con.getAutoCommit()) {
						con.rollback();
						con.setAutoCommit(true);
					}
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
				if (stmt != null) {
					stmt.close();
					stmt = null;
				}
			} catch (Exception e) {
			}
			if (mainCode != 0) {
				throw new WFSException(mainCode, subCode, errType, subject, descr);
			}
		}
		return outputXML.toString();
	}*/
	
//code merged for OF 8.0 for Export Utility
	//--------------------------------------------------------------------------------------------------
	//	Function Name                   :	WFGetNextRecordForExport
	//	Date Written (DD/MM/YYYY)		:	28/11/2007
	//	Author							:	Shilpi S
	//	Input Parameters		    	:	Connection , XMLParser , XMLGenerator
	//	Output Parameters				:	none
	//	Return Values					:	String
	//	Description						:	Get Next record for export
    //Change Description                :       Bug #2795
	//--------------------------------------------------------------------------------------------------
//public String WFGetNextRecordForExport(Connection con, XMLParser parser, XMLGenerator gen) throws JTSException, WFSException {
//    StringBuffer outputXML = null;
//    Statement stmt = null;
//    Statement update_stmt = null; //Bug # 3058
//    ResultSet rs = null;
//    ResultSet rs1 = null;//WFS_8.0_078
//    int mainCode = WFSError.WM_NO_MORE_DATA;
//    int subCode = 0;
//    String subject = null;
//    String descr = null;
//    String errType = WFSError.WF_TMP;
//    StringBuffer tempXml = new StringBuffer(500);
//    int cssession = 0;
//    boolean found = false;
//    boolean commit = false;
//    String sqNumber = "";
//    String lastRecordFlag = "N";
//    String engine ="";
//    try {
//        //Bug # 3058
//        if (con.getAutoCommit()) {
//            con.setAutoCommit(false);
//            commit = true;
//        }
//
//        int sessionID = parser.getIntOf("SessionId", 0, false);
//        engine = parser.getValueOf("EngineName");
//        int dbType = ServerProperty.getReference().getDBType(engine);
//        String csName = parser.getValueOf("CSName");
//        int ProcessDefId = parser.getIntOf("ProcessDefId", 0, false);
//        int ActivityId = parser.getIntOf("ActivityId", 0, false);
//        String filter = parser.getValueOf("Filter");
//		
//        String orderBy = parser.getValueOf("OrderBy");
//        String exportTable = parser.getValueOf("TableName");
//        String queryString = "";
//        String queryPrefix = "";
//        String querySuffix = "";
//        int pid = 0,actId = 0;//WFS_8.0_078
//
//        if ((filter != null) && (!filter.equalsIgnoreCase("")) && (filter.trim().length() > 0)) {
//			filter = WFSUtil.handleSpecialCharInXml(filter,true);  /*Bug 44459*/
//            filter = " AND " + filter + " ";
//        }
//        if ((orderBy != null) && (!orderBy.equalsIgnoreCase("")) && (orderBy.trim().length() > 0)) {
//            orderBy = " Order By " + orderBy + " ASC ";
//        }
//
//        queryPrefix = " SELECT * FROM " + exportTable + WFSUtil.getLockPrefixStr(dbType) + " Where ExportDataId in ( Select row_id From ( Select  " + WFSUtil.getFetchPrefixStr(dbType, 1) + " exportdataid row_id , " + exportTable + ".* FROM " + exportTable + " WHERE ProcessDefId = " + ProcessDefId + " AND ActivityId = " + ActivityId;
//
//        querySuffix = filter + orderBy + " ) a " + WFSUtil.getFetchSuffixStr(dbType, 1, WFSConstant.QUERY_STR_WHERE) + " ) " + WFSUtil.getLockSuffixStr(dbType);
//        //WFS_8.0_110
//        WFParticipant participantDMS ;
//        String dmsSessionId = parser.getValueOf("DMSSessionId");
//        if((dmsSessionId != null) && !dmsSessionId.equalsIgnoreCase("") && !dmsSessionId.equalsIgnoreCase("null"))
//            participantDMS = WMUser.WFCheckUpdateSession(con, Integer.parseInt(dmsSessionId), dbType);
//        /*Bug # 6964*/
//        WFParticipant participant = WMUser.WFCheckUpdateSession(con, sessionID, dbType);
//        if (participant != null && participant.gettype() == 'P') {
//            int userid = participant.getid();
//            String username = participant.getname();
//            stmt = con.createStatement();
//            if (csName != null && !csName.trim().equals("")) {
//                rs = stmt.executeQuery(" Select SessionID from PSRegisterationTable where " + TO_STRING("Type", false, dbType) + " = " + TO_STRING("C", true, dbType) + " AND " + TO_STRING("PSName", false, dbType) + " = " + TO_STRING(csName, true, dbType));
//                if (rs != null) { //Bug # 3058
//                    if (rs.next()) {
//                        cssession = rs.getInt(1);
//                    }
//                    rs.close();
//                    rs = null;
//                }
//            }
//
//            queryString = queryPrefix + " AND " + TO_STRING("LockStatus", false, dbType) + " = " + TO_STRING("Y", true, dbType) + " AND "+ TO_STRING("Status", false, dbType) + "  = " + TO_STRING("I", true, dbType) + querySuffix;
//            rs = stmt.executeQuery(queryString);
//            if (rs != null && rs.next()) {
//                found = true;
//                lastRecordFlag = "Y";
//            } else {
//                //Bug # 3058
//                if (rs != null) {
//                    rs.close();
//                    rs = null;
//                }
//
//                queryString = queryPrefix + " AND " + TO_STRING("LockStatus", false, dbType) + " = " + TO_STRING("N", true, dbType) + " AND " + TO_STRING("Status", false, dbType) + "  = " + TO_STRING("N", true, dbType) + querySuffix;
//                rs = stmt.executeQuery(queryString);
//                if (rs != null && rs.next()) {
//                //WFS_8.0_078
//                    pid = rs.getInt("ProcessDefId");
//                    actId = rs.getInt("ActivityId");
//                    String pInstId = rs.getString("ProcessInstanceId");
//                    int wid = rs.getInt("WorkitemId");
//                    int expId = rs.getInt("ExportDataId");//WFS_8.0_076
//                    queryString = " UPDATE " + exportTable +
//                                    " SET Status" + "  = " + TO_STRING("I", true, dbType) + " , LockStatus" + " = " + TO_STRING("Y", true, dbType) + " , LockedByName " + " = " + TO_STRING(username, true, dbType) + " , LockedTime " + " = " + WFSUtil.getDate(dbType) +
//                                    " WHERE  ProcessDefId = " + pid +
//                                    " AND ActivityId = " + actId +
//                                    " AND ProcessInstanceId  = " + TO_STRING(pInstId, true, dbType) +
//                                    " AND WorkitemId = " + wid +
//                                    " AND ExportDataId = " + expId;//WFS_8.0_076
//                    update_stmt = con.createStatement(); //Bug # 3058
//                    update_stmt.executeUpdate(queryString); //Bug # 3058
//                    found = true;
//                } else {
//                    mainCode = WFSError.WM_NO_MORE_DATA;
//                    subCode = 0;
//                    subject = WFSErrorMsg.getMessage(mainCode);
//                    descr = WFSErrorMsg.getMessage(subCode);
//                    errType = WFSError.WF_TMP;
//                }
//            }
//                        //WFS_8.0_078
//            if (found) {
//
//                if (rs != null) { //Bug # 3058
//                    ResultSetMetaData rsMetaData = rs.getMetaData();
//                    int noOfColumns = rsMetaData.getColumnCount();
//                    tempXml.append("<ExportData>");
//                    for (int i = 1; i <= noOfColumns; i++) {
//                        //WFS_8.0_095
//                        //WFS_8.0_105
//                        String value = ""; //Bug #2858
//                        Object[] result = null;
//                        if(rsMetaData.getColumnType(i)==java.sql.Types.CLOB)
//                        {
//                            result=WFSUtil.getBIGData(con, rs, rsMetaData.getColumnName(i), dbType, "8859_1");
//                            value=result[0].toString();
//                        }
//                        else
//                            value = rs.getString(i); //Bug #2858
//                        tempXml.append("<Data>");
//                        if (!rs.wasNull()) {
//                            tempXml.append("<Name>").append(rsMetaData.getColumnName(i)).append("</Name>");
//                            tempXml.append("<Value>").append(value).append("</Value>"); // bug # 3733
//                        }
//                        else
//                        {
//                            tempXml.append("<Name>").append(rsMetaData.getColumnName(i)).append("</Name>");
//                            tempXml.append("<Value>").append("").append("</Value>");
//                        }
//                        tempXml.append("</Data>");
//                    }
//                    tempXml.append("</ExportData>");
//                    //WFS_8.0_078
//                    //WFS_8.0_092
//                    pid = Integer.parseInt(parser.getValueOf("ProcessDefId"));
//                    actId = Integer.parseInt(parser.getValueOf("ActivityId"));
//                    String currentCount = "";
//                    // if(parser.getValueOf("CachedVal").equalsIgnoreCase("true"))
//                    // { 
//                    String dateValue = parser.getValueOf("Date");
//                    //SRU_8.0_049
//                    String likeVal = "";
//                    String queryStrTemp = "";
//                    boolean yrFlag = false;
//                    String matchValue[] =  parser.getValueOf("ValuesToMatch").split(",");
//                    for(int count = 0;count < matchValue.length; count++)
//                    {  
//                        likeVal = likeVal + rs.getString(matchValue[count]) +"%";
//                    }
//                    if(dateValue.indexOf(",") <= 0)
//                        likeVal = likeVal + dateValue;
//                    else
//                    {
//                        yrFlag = true;
//                        dateValue = dateValue.split(",")[1];
//                    }
//                    WFSUtil.printOut(engine,"[EMInstrument]Export:yrFlag>>"+yrFlag);
//                    WFSUtil.printErr(engine,"[EMInstrument]Export:yrFlag>>"+yrFlag);
//                    if(yrFlag)
//                    {
//                        if(dbType == 1)
//                            queryStrTemp = "select year(a.exporteddatetime) as year,a.SequenceNumber as SequenceNumber from ( ";
//                        else
//                            queryStrTemp = "select to_char(a.exporteddatetime, 'YYYY') as year,a.SequenceNumber as SequenceNumber from ( ";
//                    }
//                    //WFS_8.0_110
//                    // String queryStr = "Select ExportedDateTime,SequenceNumber from "+exportTable+" where ExportDataId = " +
//                              // "(Select max(ExportDataId) from " + exportTable + " where ProcessDefId = "+pid+"" +
//                              // " and ActivityId = "+actId+" and "+TO_STRING("Status", false, dbType) + 
//                              // "  = " + TO_STRING("P", true, dbType)+" and ExportFileName like '%"+
//                              // likeVal+"%')";
//                    // String queryStr = "Select * from (Select "+WFSUtil.getFetchPrefixStr(dbType,1)+" (Select max(ExportedDateTime) as ExportedDateTime from "+exportTable+" where sequenceNumber= (Select max(sequencenumber) from "+exportTable+" where ProcessDefId = "+pid+" and ActivityId = "+actId+" and "+TO_STRING("Status", false, dbType)+"= " + TO_STRING("P", true, dbType)+" and ExportFileName like '%"+likeVal+"%')"+" and ExportFileName like '%"+likeVal+"%') as ExportedDateTime, (Select max(sequencenumber) from "+exportTable+" where ProcessDefId = "+pid+" and ActivityId = "+actId+" and "+TO_STRING("Status", false, dbType)+"= " + TO_STRING("P", true, dbType)+" and ExportFileName like '%"+likeVal+"%') as sequencenumber from "+exportTable+" ) B WHERE ExportedDateTime IS NOT NULL "+WFSUtil.getFetchSuffixStr(dbType,1,WFSConstant.QUERY_STR_AND);
//                    likeVal = likeVal.replace('\'','_');
//                    String queryStr = "Select * from (Select max(ExportedDateTime) as ExportedDateTime, max(sequenceNumber) as sequenceNumber from "+exportTable+" where sequenceNumber = (Select max(sequencenumber) from "+exportTable+" where ProcessDefId = "+pid+" and ActivityId = "+actId+" and ExportFileName like '%"+likeVal+"%')) B WHERE ExportedDateTime IS NOT NULL "+WFSUtil.getFetchSuffixStr(dbType,1,WFSConstant.QUERY_STR_AND);
//
//                    if(yrFlag)
//                    {
//                        queryStrTemp = queryStrTemp + queryStr + " )a";
//                        queryStr = queryStrTemp;
//                        WFSUtil.printOut(engine,"[EMInstrument]Export:queryStr>>"+queryStr);							
//                    }
//                    WFSUtil.printOut(engine,"[EMInstrument]Export:queryStr1>>"+queryStr);
//                    rs1 = stmt.executeQuery(queryStr);
//                    String exportedDateTime = "";
//
//                    String fileNameVal = "";
//                    int counterRecord = 0;
//                    int maxRecordSize = 0;
//                    String flagRecordVal = "";
//                    if (rs1 != null && rs1.next()) 
//                    {								
//                        if(yrFlag)
//                            exportedDateTime = rs1.getString("year");
//                        else
//                            exportedDateTime = rs1.getString("ExportedDateTime");
//                        sqNumber = rs1.getString("SequenceNumber");
//                        WFSUtil.printOut(engine,"[EMInstrument]Export:exportedDateTime>>"+exportedDateTime);
//                        WFSUtil.printErr(engine,"[EMInstrument]Export:exportedDateTime>>"+exportedDateTime);
//                        rs1.close();
//                        rs1 = null;							
//                        WFSUtil.printOut(engine,"sqNumber >> "+sqNumber+" << parser.getValueOf(CurrentCount) >>"+parser.getValueOf("CurrentCount"));
//                        if((sqNumber != null) && !sqNumber.equalsIgnoreCase("null") && (sqNumber.length() != 0))
//                            currentCount = sqNumber;
//                        else
//                            currentCount = parser.getValueOf("CurrentCount");
//                        counterRecord = Integer.parseInt(parser.getValueOf("Counter"));
//                        maxRecordSize = Integer.parseInt(parser.getValueOf("MaxRecordSize"));
//                        flagRecordVal = parser.getValueOf("RecordFlag");
//                        if(yrFlag && !exportedDateTime.equalsIgnoreCase(dateValue))
//                        {
//                            WFSUtil.printOut(engine,"[EMInstrument]Export:NewCase>>");
//                            tempXml.append("<Counter>").append(0).append("</Counter>");
//                            currentCount = parser.getValueOf("CurrentCount");//String.valueOf(Integer.parseInt(currentCount) + 1);
//                            tempXml.append("<RecordFlag>").append("false").append("</RecordFlag>");
//                        }
//                        else
//                        {
//                            if(flagRecordVal.equalsIgnoreCase("false"))
//                            {
//                                if ( counterRecord < (maxRecordSize - 1) )
//                                {  	
//                                    tempXml.append("<Counter>").append(counterRecord+1).append("</Counter>");
//                                    tempXml.append("<RecordFlag>").append("false").append("</RecordFlag>");
//                                }
//                                else
//                                {
//                                    tempXml.append("<Counter>").append(0).append("</Counter>");
//                                    tempXml.append("<RecordFlag>").append("true").append("</RecordFlag>");
//                                    //currentCount = String.valueOf(Integer.parseInt(currentCount) + 1);
//                                }
//                            }
//                            else if(flagRecordVal.equalsIgnoreCase("true"))
//                            {   
//                                tempXml.append("<Counter>").append(0).append("</Counter>");
//                                currentCount = String.valueOf(Integer.parseInt(currentCount) + 1);
//                                tempXml.append("<RecordFlag>").append("false").append("</RecordFlag>");
//                            }
//                        }
//                    }
//                    else
//                    {
//                            tempXml.append("<Counter>").append(0).append("</Counter>");
//                            currentCount = parser.getValueOf("CurrentCount");//String.valueOf(Integer.parseInt(currentCount) + 1);
//                            tempXml.append("<RecordFlag>").append("false").append("</RecordFlag>");
//                    }
//                    //}
//                    if (rs1 != null) {
//                        rs1.close();
//                        rs1 = null;
//                    }
//                    WFSUtil.printOut(engine,"[EMInstrument]currentCount	>>"+currentCount);
//                    if(currentCount.length() != 0)
//                        tempXml.append("<CurrentCount>").append(currentCount).append("</CurrentCount>");
//
//                    mainCode = 0;
//                    //Bug # 3058
//                    if (commit) {
//                        con.commit();
//                        con.setAutoCommit(true);
//                        commit = false;
//                    }
//                }
//            }
//            tempXml.append("<LastRecordFlag>").append(lastRecordFlag).append("</LastRecordFlag>");							
//            if (rs != null) {
//                rs.close();
//                rs = null;
//            }
//            if (stmt != null) {
//                stmt.close();
//                stmt = null;
//            }
//        } else {
//            mainCode = WFSError.WM_INVALID_SESSION_HANDLE;
//            subCode = 0;
//            subject = WFSErrorMsg.getMessage(mainCode);
//            descr = WFSErrorMsg.getMessage(subCode);
//            errType = WFSError.WF_TMP;
//        }
//        if (mainCode == 0) {
//            outputXML = new StringBuffer(500);
//            outputXML.append(gen.createOutputFile("WFGetNextRecordForExport"));
//            outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
//            outputXML.append(gen.writeValueOf("CSSession", String.valueOf(cssession)));
//            outputXML.append(tempXml);
//            outputXML.append(gen.closeOutputFile("WFGetNextRecordForExport"));
//        }
//        if (mainCode == WFSError.WM_NO_MORE_DATA) {
//            outputXML = new StringBuffer(500);
//            outputXML.append(gen.writeError("WFGetNextRecordForExport",
//                            WFSError.WM_NO_MORE_DATA, 0,
//                            WFSError.WF_TMP,
//                            WFSErrorMsg.getMessage(WFSError.WM_NO_MORE_DATA), ""));
//            outputXML.delete(outputXML.indexOf("</" + "WFGetNextRecordForExport" +
//                            "_Output>"), outputXML.length());
//            outputXML.append(gen.writeValueOf("CSSession", String.valueOf(cssession)));
//            outputXML.append(gen.closeOutputFile("WFGetNextRecordForExport"));
//            mainCode = 0;
//        }
//    } catch (SQLException e) {
//        WFSUtil.printErr(engine,"", e);
//        mainCode = WFSError.WM_INVALID_FILTER;
//        subCode = WFSError.WFS_SQL;
//        subject = WFSErrorMsg.getMessage(mainCode);
//        errType = WFSError.WF_FAT;
//        if (e.getErrorCode() == 0) {
//            if (e.getSQLState().equalsIgnoreCase("08S01")) {
//                descr = (new JTSSQLError(e.getSQLState())).getMessage() +
//                        "(SQL State : " + e.getSQLState() + ")";
//            }
//        } else {
//            descr = e.getMessage();
//        }
//        try {
//            if (!con.getAutoCommit()) {
//                con.rollback();
//                con.setAutoCommit(true);
//            }
//        } catch (Exception exp) {
//        }
//
//    } catch (NumberFormatException e) {
//        WFSUtil.printErr(engine,"", e);
//        mainCode = WFSError.WF_OPERATION_FAILED;
//        subCode = WFSError.WFS_ILP;
//        subject = WFSErrorMsg.getMessage(mainCode);
//        errType = WFSError.WF_TMP;
//        descr = e.toString();
//    } catch (NullPointerException e) {
//        WFSUtil.printErr(engine,"", e);
//        mainCode = WFSError.WF_OPERATION_FAILED;
//        subCode = WFSError.WFS_SYS;
//        subject = WFSErrorMsg.getMessage(mainCode);
//        errType = WFSError.WF_TMP;
//        descr = e.toString();
//    } catch (WFSException e) {
//        mainCode = WFSError.WM_NO_MORE_DATA;
//        subCode = 0;
//        subject = WFSErrorMsg.getMessage(mainCode);
//        errType = WFSError.WF_TMP;
//        descr = WFSErrorMsg.getMessage(subCode);
//    } catch (JTSException e) {
//        mainCode = WFSError.WF_OPERATION_FAILED;
//        subCode = e.getErrorCode();
//        subject = WFSErrorMsg.getMessage(mainCode);
//        errType = WFSError.WF_TMP;
//        descr = e.getMessage();
//    } catch (Exception e) {
//        WFSUtil.printErr(engine,"", e);
//        mainCode = WFSError.WF_OPERATION_FAILED;
//        subCode = WFSError.WFS_EXP;
//        subject = WFSErrorMsg.getMessage(mainCode);
//        errType = WFSError.WF_TMP;
//        descr = e.toString();
//    } catch (Error e) {
//        WFSUtil.printErr(engine,"", e);
//        mainCode = WFSError.WF_OPERATION_FAILED;
//        subCode = WFSError.WFS_EXP;
//        subject = WFSErrorMsg.getMessage(mainCode);
//        errType = WFSError.WF_TMP;
//        descr = e.toString();
//    } finally {
//        try {
//            if (commit) {
//                if (!con.getAutoCommit()) {
//                    con.rollback();
//                    con.setAutoCommit(true);
//                }
//            }
//        } catch (Exception e) {
//        }
//        try {
//            if (rs != null) {
//                rs.close();
//                rs = null;
//            }
//        } catch (Exception e) {
//        }
//        try {
//            if (stmt != null) {
//                stmt.close();
//                stmt = null;
//            }
//        } catch (Exception e) {
//        }
//        if (mainCode != 0) {
//            throw new WFSException(mainCode, subCode, errType, subject, descr);
//        }
//    }
//    return outputXML.toString();
//}
	/*//----------------------------------------------------------------------------------------------------
	//	Function Name 				    :	WFSetRecordStatusForExport
	//	Date Written (DD/MM/YYYY)		:	28/11/2007
	//	Author						    :	Shilpi S
	//	Input Parameters		    	:	Connection , XMLParser , XMLGenerator
	//	Output Parameters			    :	none
	//	Return Values				    :	String
	//	Description					    :	Set success status for export
	//  Change Description              :   Bug #2795
	//----------------------------------------------------------------------------------------------------
	public String WFSetRecordStatusForExport(Connection con, XMLParser parser, XMLGenerator gen) throws JTSException, WFSException {
		StringBuffer outputXML = null;
		Statement stmt = null;
		ResultSet rs = null;
		int mainCode = WFSError.WF_OPERATION_FAILED;
		int subCode = 0;
		String subject = null;
		String descr = null;
		String errType = WFSError.WF_TMP;
		boolean commit = false;
		try {
			int sessionID = parser.getIntOf("SessionId", 0, false);
			String engine = parser.getValueOf("EngineName");
			int dbType = ServerProperty.getReference().getDBType(engine);
			String csName = parser.getValueOf("CSName");
			String status = parser.getValueOf("Status");
			int exportDataId = parser.getIntOf("ExportDataId", 0, false);
			String exportTable = parser.getValueOf("TableName");
			String exportFileName = parser.getValueOf("ExportFileName");
			String exportFileDateTime = parser.getValueOf("ExportFileDateTime");
			//WFS_8.0_103
            String exportSeqNo = parser.getValueOf("ExportSequenceNumber");
			if(exportFileName.length()<0)
				exportFileName = " ";
			/*Bug # 6964*/
		/*	WFParticipant participant = WMUser.WFCheckUpdateSession(con, sessionID, dbType);
			String queryString = "";
			if (participant != null && participant.gettype() == 'P') {
                if (exportTable != null && !exportTable.equals("") && exportTable.trim().length() > 0) {
                    if (con.getAutoCommit()) {
                        con.setAutoCommit(false);
                        commit = true;
                    }
                    stmt = con.createStatement();
                    //WFS_8.0_103
                    queryString = " UPDATE " + exportTable + " SET Status = " + TO_STRING(status, true, dbType) + " , LockedByName = null , LockedTime = null , LockStatus  = " + TO_STRING("N", true, dbType) + " , ExportFileName = "+TO_STRING(exportFileName, true, dbType)+ ", ExportFileDateTime = " +WFSUtil.TO_DATE(exportFileDateTime, true, dbType)+", SequenceNumber = "+TO_STRING(exportSeqNo, true, dbType)+" WHERE ExportDataId = " +exportDataId ;
                    stmt.executeUpdate(queryString);
                    mainCode = 0;
                    if (commit) {
                        con.commit();
                        con.setAutoCommit(true);
                        commit = false;
                    }
                    if (rs != null) {
                        rs.close();
                        rs = null;
                    }
                    if (stmt != null) {
                        stmt.close();
                        stmt = null;
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
				outputXML.append(gen.createOutputFile("WFSetRecordStatusForExport"));
				outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
				outputXML.append(gen.closeOutputFile("WFSetRecordStatusForExport"));
			}
			if (mainCode == WFSError.WM_NO_MORE_DATA) {
				outputXML = new StringBuffer(500);
				outputXML.append(gen.writeError("WFSetRecordStatusForExport",
						WFSError.WM_NO_MORE_DATA, 0,
						WFSError.WF_TMP,
						WFSErrorMsg.getMessage(WFSError.WM_NO_MORE_DATA), ""));
				outputXML.delete(outputXML.indexOf("</" + "WFSetRecordStatusForExport" +
						"_Output>"), outputXML.length());
				outputXML.append(gen.closeOutputFile("WFSetRecordStatusForExport"));
				mainCode = 0;
			}
		} catch (SQLException e) {
			WFSUtil.printErr(engine,"", e);
			mainCode = WFSError.WM_INVALID_FILTER;
			subCode = WFSError.WFS_SQL;
			subject = WFSErrorMsg.getMessage(mainCode);
			errType = WFSError.WF_FAT;
			if (e.getErrorCode() == 0) {
				if (e.getSQLState().equalsIgnoreCase("08S01")) {
					descr = (new JTSSQLError(e.getSQLState())).getMessage() +
							"(SQL State : " + e.getSQLState() + ")";
				}
			} else {
				descr = e.getMessage();
			}
			try {
				if (!con.getAutoCommit()) {
					con.rollback();
					con.setAutoCommit(true);
				}
			} catch (Exception exp) {
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
				if (commit) {
					if (!con.getAutoCommit()) {
						con.rollback();
						con.setAutoCommit(true);
					}
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
				if (stmt != null) {
					stmt.close();
					stmt = null;
				}
			} catch (Exception e) {
			}
			if (mainCode != 0) {
				throw new WFSException(mainCode, subCode, errType, subject, descr);
			}
		}
		return outputXML.toString();
	}*/
	//COde merged from OF 8.0 for Export Utility
	//----------------------------------------------------------------------------------------------------
	//	Function Name 				:	WFSetRecordStatusForExport
	//	Date Written (DD/MM/YYYY)		:	28/11/2007
	//	Author					:	Shilpi S
	//	Input Parameters		    	:	Connection , XMLParser , XMLGenerator
	//	Output Parameters			:	none
	//	Return Values				:	String
	//	Description				:	Set success status for export
	//      Change Description                      :       Bug #2795
	//----------------------------------------------------------------------------------------------------
//	public String WFSetRecordStatusForExport(Connection con, XMLParser parser, XMLGenerator gen) throws JTSException, WFSException {
//		StringBuffer outputXML = null;
//		Statement stmt = null;
//		ResultSet rs = null;
//		int mainCode = WFSError.WF_OPERATION_FAILED;
//		int subCode = 0;
//		String subject = null;
//		String descr = null;
//		String errType = WFSError.WF_TMP;
//		boolean commit = false;
//		String engine = "";
//		try {
//			int sessionID = parser.getIntOf("SessionId", 0, false);
//			engine = parser.getValueOf("EngineName");
//			int dbType = ServerProperty.getReference().getDBType(engine);
//			String csName = parser.getValueOf("CSName");
//			String status = parser.getValueOf("Status");
//			int exportDataId = parser.getIntOf("ExportDataId", 0, false);
//			String exportTable = parser.getValueOf("TableName");
//			String exportFileName = parser.getValueOf("ExportFileName");
//			String exportDateTime = parser.getValueOf("ExportFileDateTime");
//			//WFS_8.0_103
//            String exportSeqNo = parser.getValueOf("ExportSequenceNumber");
//			String operationType = parser.getValueOf("OperationType", "R", false);
//			if(exportFileName.length()<0)
//				exportFileName = " ";
//			/*Bug # 6964*/
//			WFParticipant participant = WMUser.WFCheckUpdateSession(con, sessionID, dbType);
//			String queryString = "";
//			if (participant != null && participant.gettype() == 'P') {
//                if (exportTable != null && !exportTable.equals("") && exportTable.trim().length() > 0) {
//                    if (con.getAutoCommit()) {
//                        con.setAutoCommit(false);
//                        commit = true;
//                    }
//                    stmt = con.createStatement();
//					//WFS_8.0_103
//					if(operationType.equalsIgnoreCase("R"))
//						queryString = " UPDATE " + exportTable + " SET Status = " + TO_STRING(status, true, dbType) + " , LockedByName = null , LockedTime = null , LockStatus  = " + TO_STRING("N", true, dbType) + " , ExportFileName = "+TO_STRING(exportFileName, true, dbType)+ ", exporteddatetime = " +WFSUtil.TO_DATE(exportDateTime, true, dbType)+", SequenceNumber = "+TO_STRING(exportSeqNo, true, dbType)+" WHERE ExportDataId = " +exportDataId ;
//					else if(operationType.equalsIgnoreCase("F"))
//						queryString = " UPDATE " + exportTable + " SET Status = " + TO_STRING(status, true, dbType) + " , ExportFileDateTime = " +WFSUtil.TO_DATE(exportDateTime, true, dbType)+" WHERE ExportFileName = "+TO_STRING(exportFileName, true, dbType);
//						
//                    int res = stmt.executeUpdate(queryString);
//                    if(res>1 && operationType.equalsIgnoreCase("R"))
//                    {
//                        WFSUtil.printErr(engine,"[WFSetRecordStatusForExport] More than one row are updated for OperationType = R and ExportDataId = " + exportDataId);
//                        mainCode = WFSError.WF_OPERATION_FAILED;
//						subCode = WFSError.WFS_SQL;
//						subject = WFSErrorMsg.getMessage(mainCode);
//						errType = WFSError.WF_TMP;
//                        descr = WFSErrorMsg.getMessage(subCode);
//                    }
//                    else
//                    {
//                    mainCode = 0;
//                    if (commit) {
//                        con.commit();
//                        con.setAutoCommit(true);
//                        commit = false;
//                    }
//                    if (rs != null) {
//                        rs.close();
//                        rs = null;
//                    }
//                    if (stmt != null) {
//                        stmt.close();
//                        stmt = null;
//                    }
//                    }
//                }
//				
//			} else {
//				mainCode = WFSError.WM_INVALID_SESSION_HANDLE;
//				subCode = 0;
//				subject = WFSErrorMsg.getMessage(mainCode);
//				descr = WFSErrorMsg.getMessage(subCode);
//				errType = WFSError.WF_TMP;
//			}
//			if (mainCode == 0) {
//				outputXML = new StringBuffer(500);
//				outputXML.append(gen.createOutputFile("WFSetRecordStatusForExport"));
//				outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
//				outputXML.append(gen.closeOutputFile("WFSetRecordStatusForExport"));
//			}
//			if (mainCode == WFSError.WM_NO_MORE_DATA) {
//				outputXML = new StringBuffer(500);
//				outputXML.append(gen.writeError("WFSetRecordStatusForExport",
//						WFSError.WM_NO_MORE_DATA, 0,
//						WFSError.WF_TMP,
//						WFSErrorMsg.getMessage(WFSError.WM_NO_MORE_DATA), ""));
//				outputXML.delete(outputXML.indexOf("</" + "WFSetRecordStatusForExport" +
//						"_Output>"), outputXML.length());
//				outputXML.append(gen.closeOutputFile("WFSetRecordStatusForExport"));
//				mainCode = 0;
//			}
//		} catch (SQLException e) {
//			WFSUtil.printErr(engine,"", e);
//			mainCode = WFSError.WM_INVALID_FILTER;
//			subCode = WFSError.WFS_SQL;
//			subject = WFSErrorMsg.getMessage(mainCode);
//			errType = WFSError.WF_FAT;
//			if (e.getErrorCode() == 0) {
//				if (e.getSQLState().equalsIgnoreCase("08S01")) {
//					descr = (new JTSSQLError(e.getSQLState())).getMessage() +
//							"(SQL State : " + e.getSQLState() + ")";
//				}
//			} else {
//				descr = e.getMessage();
//			}
//			try {
//				if (!con.getAutoCommit()) {
//					con.rollback();
//					con.setAutoCommit(true);
//				}
//			} catch (Exception exp) {
//			}
//
//		} catch (NumberFormatException e) {
//			WFSUtil.printErr(engine,"", e);
//			mainCode = WFSError.WF_OPERATION_FAILED;
//			subCode = WFSError.WFS_ILP;
//			subject = WFSErrorMsg.getMessage(mainCode);
//			errType = WFSError.WF_TMP;
//			descr = e.toString();
//		} catch (NullPointerException e) {
//			WFSUtil.printErr(engine,"", e);
//			mainCode = WFSError.WF_OPERATION_FAILED;
//			subCode = WFSError.WFS_SYS;
//			subject = WFSErrorMsg.getMessage(mainCode);
//			errType = WFSError.WF_TMP;
//			descr = e.toString();
//		} catch (WFSException e) {
//			mainCode = WFSError.WM_NO_MORE_DATA;
//			subCode = 0;
//			subject = WFSErrorMsg.getMessage(mainCode);
//			errType = WFSError.WF_TMP;
//			descr = WFSErrorMsg.getMessage(subCode);
//		} catch (JTSException e) {
//			mainCode = WFSError.WF_OPERATION_FAILED;
//			subCode = e.getErrorCode();
//			subject = WFSErrorMsg.getMessage(mainCode);
//			errType = WFSError.WF_TMP;
//			descr = e.getMessage();
//		} catch (Exception e) {
//			WFSUtil.printErr(engine,"", e);
//			mainCode = WFSError.WF_OPERATION_FAILED;
//			subCode = WFSError.WFS_EXP;
//			subject = WFSErrorMsg.getMessage(mainCode);
//			errType = WFSError.WF_TMP;
//			descr = e.toString();
//		} catch (Error e) {
//			WFSUtil.printErr(engine,"", e);
//			mainCode = WFSError.WF_OPERATION_FAILED;
//			subCode = WFSError.WFS_EXP;
//			subject = WFSErrorMsg.getMessage(mainCode);
//			errType = WFSError.WF_TMP;
//			descr = e.toString();
//		} finally {
//			try {
//				if (commit) {
//					if (!con.getAutoCommit()) {
//						con.rollback();
//						con.setAutoCommit(true);
//					}
//				}
//			} catch (Exception e) {
//			}
//			try {
//				if (rs != null) {
//					rs.close();
//					rs = null;
//				}
//			} catch (Exception e) {
//			}
//			try {
//				if (stmt != null) {
//					stmt.close();
//					stmt = null;
//				}
//			} catch (Exception e) {
//			}
//			if (mainCode != 0) {
//				throw new WFSException(mainCode, subCode, errType, subject, descr);
//			}
//		}
//		return outputXML.toString();
//	}
	
/*	//----------------------------------------------------------------------------------------------------
	//	Function Name 				    :	WFGetLastExportFileTime
	//	Date Written (DD/MM/YYYY)		:	28/11/2007
	//	Author						    :	Shilpi S
	//	Input Parameters		    	:	Connection , XMLParser , XMLGenerator
	//	Output Parameters			    :	none
	//	Return Values				    :	String
	//	Description					    :	Set success status for export
	//  Change Description              :   Bug #2795
	//----------------------------------------------------------------------------------------------------
	public String WFGetLastExportFileTime(Connection con, XMLParser parser, XMLGenerator gen) throws JTSException, WFSException {
		StringBuffer outputXML = null;
		Statement stmt = null;
		ResultSet rs = null;
		int mainCode = WFSError.WF_OPERATION_FAILED;
		int subCode = 0;
		String subject = null;
		String descr = null;
		String errType = WFSError.WF_TMP;
		String exportFileDateTime = "";
		boolean commit = false;
		try {
			int sessionID = parser.getIntOf("SessionId", 0, false);
			String engine = parser.getValueOf("EngineName");
			int dbType = ServerProperty.getReference().getDBType(engine);
			String processDefId = parser.getValueOf("ProcessDefId");		
			String activityId = parser.getValueOf("ActivityId");
			String exportTable = parser.getValueOf("ExportTable");
			/*Bug # 6964*/
			/*WFParticipant participant = WMUser.WFCheckUpdateSession(con, sessionID, dbType);
			String queryString = "";
			if (participant != null && participant.gettype() == 'P') {
                
                    stmt = con.createStatement();
                    queryString = " SELECT MAX ( ExportFileDateTime) as ExportFileDateTime from " + exportTable + " WHERE ProcessDefId = " +processDefId+ " AND ActivityId = " +activityId;
                    mainCode = 0;
                    rs = stmt.executeQuery(queryString);
					if (rs != null && rs.next()) {
						exportFileDateTime = rs.getString("ExportFileDateTime");
						}
                    if (rs != null) {
                        rs.close();
                        rs = null;
                    }
                    if (stmt != null) {
                        stmt.close();
                        stmt = null;
                    }   	
			}
			else {
				mainCode = WFSError.WM_INVALID_SESSION_HANDLE;
				subCode = 0;
				subject = WFSErrorMsg.getMessage(mainCode);
				descr = WFSErrorMsg.getMessage(subCode);
				errType = WFSError.WF_TMP;
			}
			if (mainCode == 0) {
				outputXML = new StringBuffer(500);
				outputXML.append(gen.createOutputFile("WFGetLastExportFileTime"));
				outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
				outputXML.append("<ExportFileDateTime>");
				outputXML.append(exportFileDateTime);
				outputXML.append("</ExportFileDateTime>");
				outputXML.append(gen.closeOutputFile("WFGetLastExportFileTime"));
			}
			if (mainCode == WFSError.WM_NO_MORE_DATA) {
				outputXML = new StringBuffer(500);
				outputXML.append(gen.writeError("WFGetLastExportFileTime",
						WFSError.WM_NO_MORE_DATA, 0,
						WFSError.WF_TMP,
						WFSErrorMsg.getMessage(WFSError.WM_NO_MORE_DATA), ""));
				outputXML.delete(outputXML.indexOf("</" + "WFGetLastExportFileTime" +
						"_Output>"), outputXML.length());
				outputXML.append(gen.closeOutputFile("WFGetLastExportFileTime"));
				mainCode = 0;
			}
		} catch (SQLException e) {
			WFSUtil.printErr(engine,"", e);
			mainCode = WFSError.WM_INVALID_FILTER;
			subCode = WFSError.WFS_SQL;
			subject = WFSErrorMsg.getMessage(mainCode);
			errType = WFSError.WF_FAT;
			if (e.getErrorCode() == 0) {
				if (e.getSQLState().equalsIgnoreCase("08S01")) {
					descr = (new JTSSQLError(e.getSQLState())).getMessage() +
							"(SQL State : " + e.getSQLState() + ")";
				}
			} else {
				descr = e.getMessage();
			}
			try {
				if (!con.getAutoCommit()) {
					con.rollback();
					con.setAutoCommit(true);
				}
			} catch (Exception exp) {
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
				if (commit) {
					if (!con.getAutoCommit()) {
						con.rollback();
						con.setAutoCommit(true);
					}
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
				if (stmt != null) {
					stmt.close();
					stmt = null;
				}
			} catch (Exception e) {
			}
			if (mainCode != 0) {
				throw new WFSException(mainCode, subCode, errType, subject, descr);
			}
		}
		return outputXML.toString();
	}*/
	//COde merged from OF 8.0 for Export Utility.
	//----------------------------------------------------------------------------------------------------
	//	Function Name 				:	WFGetLastExportFileTime
	//	Date Written (DD/MM/YYYY)	:	28/11/2007
	//	Author						:	Shilpi S
	//	Input Parameters		    :	Connection , XMLParser , XMLGenerator
	//	Output Parameters			:	none
	//	Return Values				:	String
	//	Description					:	Set success status for export
	//  Change Description          :   Bug #2795
	//----------------------------------------------------------------------------------------------------
//	public String WFGetLastExportFileTime(Connection con, XMLParser parser, XMLGenerator gen) throws JTSException, WFSException {
//		StringBuffer outputXML = null;
//		Statement stmt = null;
//		ResultSet rs = null;
//		int mainCode = WFSError.WF_OPERATION_FAILED;
//		int subCode = 0;
//		String subject = null;
//		String descr = null;
//		String errType = WFSError.WF_TMP;
//		String exportFileDateTime = "";
//		boolean commit = false;
//		String engine = "";
//		try {
//			int sessionID = parser.getIntOf("SessionId", 0, false);
//			engine = parser.getValueOf("EngineName");
//			int dbType = ServerProperty.getReference().getDBType(engine);
//			String processDefId = parser.getValueOf("ProcessDefId");		
//			String activityId = parser.getValueOf("ActivityId");
//			String exportTable = parser.getValueOf("ExportTable");
//			String exportFileName = parser.getValueOf("ExportFileName","", true);
//			String operationType = parser.getValueOf("OperationType", "X", true);
//			/*Bug # 6964*/
//			WFParticipant participant = WMUser.WFCheckUpdateSession(con, sessionID, dbType);
//			String queryString = "";
//			if (participant != null && participant.gettype() == 'P') {
//                
//                    stmt = con.createStatement();
//					if(operationType.equalsIgnoreCase("X"))
//						queryString = " SELECT MAX ( ExportFileDateTime) as ExportFileDateTime from " + exportTable + " WHERE ProcessDefId = " +processDefId+ " AND ActivityId = " +activityId;
//					else if(operationType.equalsIgnoreCase("I"))
//						queryString = " SELECT MIN(exporteddatetime) as ExportFileDateTime from " + exportTable + " WHERE ProcessDefId = " +processDefId+ " AND ActivityId = " +activityId;
//						
//					if(exportFileName != null && !exportFileName.equalsIgnoreCase("null") && !exportFileName.equals(""))
//						queryString = queryString+ " AND ExportFileName = "+TO_STRING(exportFileName, true, dbType);
//					WFSUtil.printOut(engine,"WFGetLastExportFileTime == "+queryString);
//                    rs = stmt.executeQuery(queryString);
//					if (rs != null && rs.next()) {
//						exportFileDateTime = rs.getString("ExportFileDateTime");
//						mainCode = 0;
//					}
//					else 
//						mainCode = WFSError.WM_NO_MORE_DATA;
//                    if (rs != null) {
//                        rs.close();
//                        rs = null;
//                    }
//                    if (stmt != null) {
//                        stmt.close();
//                        stmt = null;
//                    }   	
//			}
//			else {
//				mainCode = WFSError.WM_INVALID_SESSION_HANDLE;
//				subCode = 0;
//				subject = WFSErrorMsg.getMessage(mainCode);
//				descr = WFSErrorMsg.getMessage(subCode);
//				errType = WFSError.WF_TMP;
//			}
//			if (mainCode == 0) {
//				outputXML = new StringBuffer(500);
//				outputXML.append(gen.createOutputFile("WFGetLastExportFileTime"));
//				outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
//				outputXML.append("<ExportFileDateTime>");
//				outputXML.append(exportFileDateTime);
//				outputXML.append("</ExportFileDateTime>");
//				outputXML.append(gen.closeOutputFile("WFGetLastExportFileTime"));
//			}
//			if (mainCode == WFSError.WM_NO_MORE_DATA) {
//				outputXML = new StringBuffer(500);
//				outputXML.append(gen.writeError("WFGetLastExportFileTime",
//						WFSError.WM_NO_MORE_DATA, 0,
//						WFSError.WF_TMP,
//						WFSErrorMsg.getMessage(WFSError.WM_NO_MORE_DATA), ""));
//				outputXML.delete(outputXML.indexOf("</" + "WFGetLastExportFileTime" +
//						"_Output>"), outputXML.length());
//				outputXML.append(gen.closeOutputFile("WFGetLastExportFileTime"));
//				mainCode = 0;
//			}
//		} catch (SQLException e) {
//			WFSUtil.printErr(engine,"", e);
//			mainCode = WFSError.WM_INVALID_FILTER;
//			subCode = WFSError.WFS_SQL;
//			subject = WFSErrorMsg.getMessage(mainCode);
//			errType = WFSError.WF_FAT;
//			if (e.getErrorCode() == 0) {
//				if (e.getSQLState().equalsIgnoreCase("08S01")) {
//					descr = (new JTSSQLError(e.getSQLState())).getMessage() +
//							"(SQL State : " + e.getSQLState() + ")";
//				}
//			} else {
//				descr = e.getMessage();
//			}
//			try {
//				if (!con.getAutoCommit()) {
//					con.rollback();
//					con.setAutoCommit(true);
//				}
//			} catch (Exception exp) {
//			}
//
//		} catch (NumberFormatException e) {
//			WFSUtil.printErr(engine,"", e);
//			mainCode = WFSError.WF_OPERATION_FAILED;
//			subCode = WFSError.WFS_ILP;
//			subject = WFSErrorMsg.getMessage(mainCode);
//			errType = WFSError.WF_TMP;
//			descr = e.toString();
//		} catch (NullPointerException e) {
//			WFSUtil.printErr(engine,"", e);
//			mainCode = WFSError.WF_OPERATION_FAILED;
//			subCode = WFSError.WFS_SYS;
//			subject = WFSErrorMsg.getMessage(mainCode);
//			errType = WFSError.WF_TMP;
//			descr = e.toString();
//		} catch (WFSException e) {
//			mainCode = WFSError.WM_NO_MORE_DATA;
//			subCode = 0;
//			subject = WFSErrorMsg.getMessage(mainCode);
//			errType = WFSError.WF_TMP;
//			descr = WFSErrorMsg.getMessage(subCode);
//		} catch (JTSException e) {
//			mainCode = WFSError.WF_OPERATION_FAILED;
//			subCode = e.getErrorCode();
//			subject = WFSErrorMsg.getMessage(mainCode);
//			errType = WFSError.WF_TMP;
//			descr = e.getMessage();
//		} catch (Exception e) {
//			WFSUtil.printErr(engine,"", e);
//			mainCode = WFSError.WF_OPERATION_FAILED;
//			subCode = WFSError.WFS_EXP;
//			subject = WFSErrorMsg.getMessage(mainCode);
//			errType = WFSError.WF_TMP;
//			descr = e.toString();
//		} catch (Error e) {
//			WFSUtil.printErr(engine,"", e);
//			mainCode = WFSError.WF_OPERATION_FAILED;
//			subCode = WFSError.WFS_EXP;
//			subject = WFSErrorMsg.getMessage(mainCode);
//			errType = WFSError.WF_TMP;
//			descr = e.toString();
//		} finally {
//			try {
//				if (commit) {
//					if (!con.getAutoCommit()) {
//						con.rollback();
//						con.setAutoCommit(true);
//					}
//				}
//			} catch (Exception e) {
//			}
//			try {
//				if (rs != null) {
//					rs.close();
//					rs = null;
//				}
//			} catch (Exception e) {
//			}
//			try {
//				if (stmt != null) {
//					stmt.close();
//					stmt = null;
//				}
//			} catch (Exception e) {
//			}
//			if (mainCode != 0) {
//				throw new WFSException(mainCode, subCode, errType, subject, descr);
//			}
//		}
//		return outputXML.toString();
//	}
//	//Code merge from OF 8.0 for Export Utility.
//	//----------------------------------------------------------------------------------------------------
//	//	Function Name 				:	WFCheckLastExportFileExistence
//	//	Date Written (DD/MM/YYYY)	:	28/12/2012
//	//	Author						:	Preeti Awasthi
//	//	Input Parameters		    :	Connection , XMLParser , XMLGenerator
//	//	Output Parameters			:	none
//	//	Return Values				:	String
//	//	Description					:	Check existence of last export time
//	//----------------------------------------------------------------------------------------------------        
//	public String WFCheckLastExportFileExistence(Connection con, XMLParser parser, XMLGenerator gen) throws JTSException, WFSException {
//		StringBuffer outputXML = null;
//		Statement stmt = null;
//		ResultSet rs = null;
//		int mainCode = WFSError.WF_OPERATION_FAILED;
//		int subCode = 0;
//		String subject = null;
//		String descr = null;
//		String errType = WFSError.WF_TMP;
//		String existsFlag = "N";
//		boolean commit = false;
//		String queryString = "";
//		String dbExportLoc = null;
//		StringBuffer strBuff = new StringBuffer();
//        String tempVal = "";
//        int startIndex = -1;
//        int endIndex = -1;
//		String finalVal = null;
//		String fieldToAppend = "";
//		String engine ="";
//		try {
//			int sessionID = parser.getIntOf("SessionId", 0, false);
//			engine = parser.getValueOf("EngineName");
//			int dbType = ServerProperty.getReference().getDBType(engine);
//			String processDefId = parser.getValueOf("ProcessDefId");
//			String activityId = parser.getValueOf("ActivityId");
//			String exportTable = parser.getValueOf("ExportTable");
//			String fieldName = parser.getValueOf("FieldName","",true);
//			String exportFileName = parser.getValueOf("ExportFileName","",false);
//			String opType= parser.getValueOf("OperationType","F",false);
//			//WFParticipant participant = WMUser.WFCheckUpdateSession(con, sessionID, dbType);
//			//if (participant != null && participant.gettype() == 'P') {
//				stmt = con.createStatement();
//				if(opType.equalsIgnoreCase("F") && exportFileName != null && !exportFileName.equalsIgnoreCase("null") && !exportFileName.equalsIgnoreCase("")) {
//					fieldToAppend = "1";
//				}
//				else if(opType.equalsIgnoreCase("C") && fieldName != null && !fieldName.equals("") && fieldName.contains("&<")){
//					try {
//						finalVal = fieldName;
//						while(true){
//							startIndex = finalVal.indexOf("&<");
//							endIndex = finalVal.indexOf(">&", startIndex);
//							if(endIndex <= -1 || startIndex <= -1)
//								break;
//							tempVal = finalVal.substring(startIndex+2,endIndex);
//							finalVal = finalVal.substring(endIndex,finalVal.length());
//							strBuff.append(tempVal).append(",");
//						}
//					}catch (Exception ex) {
//						WFSUtil.printErr(engine,"Ignoring ", ex);
//					}
//					fieldToAppend = strBuff.toString().substring(0,strBuff.toString().lastIndexOf(","));
//				}
//				String columns[] = fieldToAppend.split(",");				
//				WFSUtil.printOut(engine,"WFCheckLastExportFileExistence fieldToAppend ="+fieldToAppend);
//				queryString = " SELECT "+fieldToAppend+" from " + exportTable + " WHERE ExportDataId = ( Select MAX(ExportDataId) from "+exportTable+" WHERE ExportFileName = "+TO_STRING(exportFileName, true, dbType)+")";
//				WFSUtil.printOut(engine,"WFCheckLastExportFileExistence optype ="+opType+" == "+queryString);
//				rs = stmt.executeQuery(queryString);
//				String value = "";
//				if (rs != null && rs.next()) {
//					if(opType.equalsIgnoreCase("F"))
//						existsFlag = "Y";
//					else if(opType.equalsIgnoreCase("C")) {
//						for(int count = 0;count < columns.length; count++) {
//							value = rs.getString(columns[count]);
//							if(value == null)
//								value = "";
//							fieldName  = fieldName.replaceAll("&<"+columns[count]+">&",value);						
//						}
//					}
//					mainCode = 0;
//					rs.close();
//					rs = null;
//				}
//				else
//					mainCode = WFSError.WM_NO_MORE_DATA;
//				dbExportLoc = fieldName;
//				WFSUtil.printOut(engine,"WFCheckLastExportFileExistence dbExportLoc ="+dbExportLoc);
//					
//				if (rs != null) {
//					rs.close();
//					rs = null;
//				}
//				if (stmt != null) {
//					stmt.close();
//					stmt = null;
//				}
//			/*}
//			else {
//				mainCode = WFSError.WM_INVALID_SESSION_HANDLE;
//				subCode = 0;
//				subject = WFSErrorMsg.getMessage(mainCode);
//				descr = WFSErrorMsg.getMessage(subCode);
//				errType = WFSError.WF_TMP;
//			}*/
//			if (mainCode == 0) {
//				outputXML = new StringBuffer(500);
//				outputXML.append(gen.createOutputFile("WFCheckLastExportFileExistence"));
//				outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
//				outputXML.append("<Exists>");
//				outputXML.append(existsFlag);
//				outputXML.append("</Exists>");
//				outputXML.append("<DBExportLocation>");
//				outputXML.append(dbExportLoc);
//				outputXML.append("</DBExportLocation>");
//				outputXML.append(gen.closeOutputFile("WFCheckLastExportFileExistence"));
//			}
//			if (mainCode == WFSError.WM_NO_MORE_DATA) {
//				outputXML = new StringBuffer(500);
//				outputXML.append(gen.writeError("WFCheckLastExportFileExistence",
//						WFSError.WM_NO_MORE_DATA, 0,
//						WFSError.WF_TMP,
//						WFSErrorMsg.getMessage(WFSError.WM_NO_MORE_DATA), ""));
//				outputXML.delete(outputXML.indexOf("</" + "WFCheckLastExportFileExistence" +
//						"_Output>"), outputXML.length());
//				outputXML.append(gen.closeOutputFile("WFCheckLastExportFileExistence"));
//				mainCode = 0;
//			}
//		} catch (SQLException e) {
//			WFSUtil.printErr(engine,"", e);
//			mainCode = WFSError.WM_INVALID_FILTER;
//			subCode = WFSError.WFS_SQL;
//			subject = WFSErrorMsg.getMessage(mainCode);
//			errType = WFSError.WF_FAT;
//			if (e.getErrorCode() == 0) {
//				if (e.getSQLState().equalsIgnoreCase("08S01")) {
//					descr = (new JTSSQLError(e.getSQLState())).getMessage() +
//							"(SQL State : " + e.getSQLState() + ")";
//				}
//			} else {
//				descr = e.getMessage();
//			}
//			try {
//				if (!con.getAutoCommit()) {
//					con.rollback();
//					con.setAutoCommit(true);
//				}
//			} catch (Exception exp) {
//			}
//
//		} catch (NumberFormatException e) {
//			WFSUtil.printErr(engine,"", e);
//			mainCode = WFSError.WF_OPERATION_FAILED;
//			subCode = WFSError.WFS_ILP;
//			subject = WFSErrorMsg.getMessage(mainCode);
//			errType = WFSError.WF_TMP;
//			descr = e.toString();
//		} catch (NullPointerException e) {
//			WFSUtil.printErr(engine,"", e);
//			mainCode = WFSError.WF_OPERATION_FAILED;
//			subCode = WFSError.WFS_SYS;
//			subject = WFSErrorMsg.getMessage(mainCode);
//			errType = WFSError.WF_TMP;
//			descr = e.toString();
//		} catch (WFSException e) {
//			mainCode = WFSError.WM_NO_MORE_DATA;
//			subCode = 0;
//			subject = WFSErrorMsg.getMessage(mainCode);
//			errType = WFSError.WF_TMP;
//			descr = WFSErrorMsg.getMessage(subCode);
//		} catch (JTSException e) {
//			mainCode = WFSError.WF_OPERATION_FAILED;
//			subCode = e.getErrorCode();
//			subject = WFSErrorMsg.getMessage(mainCode);
//			errType = WFSError.WF_TMP;
//			descr = e.getMessage();
//		} catch (Exception e) {
//			WFSUtil.printErr(engine,"", e);
//			mainCode = WFSError.WF_OPERATION_FAILED;
//			subCode = WFSError.WFS_EXP;
//			subject = WFSErrorMsg.getMessage(mainCode);
//			errType = WFSError.WF_TMP;
//			descr = e.toString();
//		} catch (Error e) {
//			WFSUtil.printErr(engine,"", e);
//			mainCode = WFSError.WF_OPERATION_FAILED;
//			subCode = WFSError.WFS_EXP;
//			subject = WFSErrorMsg.getMessage(mainCode);
//			errType = WFSError.WF_TMP;
//			descr = e.toString();
//		} finally {
//			try {
//				if (commit) {
//					if (!con.getAutoCommit()) {
//						con.rollback();
//						con.setAutoCommit(true);
//					}
//				}
//			} catch (Exception e) {
//			}
//			try {
//				if (rs != null) {
//					rs.close();
//					rs = null;
//				}
//			} catch (Exception e) {
//			}
//			try {
//				if (stmt != null) {
//					stmt.close();
//					stmt = null;
//				}
//			} catch (Exception e) {
//			}
//			if (mainCode != 0) {
//				throw new WFSException(mainCode, subCode, errType, subject, descr);
//			}
//		}
//		return outputXML.toString();
//	}        
	//----------------------------------------------------------------------------------------------------
	//	Function Name 				    :	WFGetProcessVariablesExt
	//	Date Written (DD/MM/YYYY)		:	23/09/08
	//	Author						    :	Shweta Tyagi
	//	Input Parameters		    	:	Connection , XMLParser , XMLGenerator
	//	Output Parameters			    :	none
	//	Return Values				    :	String
	//	Description					    :	API to get variables' vital information
	//----------------------------------------------------------------------------------------------------

	public String WFGetProcessVariablesExt(Connection con, XMLParser parser, XMLGenerator gen) throws JTSException, WFSException {
		StringBuffer outputXML = new StringBuffer("");
		int mainCode = 0;
		int subCode = 0;
		String subject = null;
		String descr = null;
		String errType = WFSError.WF_TMP;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String engine = "";
		char char21 = 21;
		String string21 = "" + char21;
		try {
			int sessionID = 0;
			String enableMultiLingual = parser.getValueOf("EnableMultiLingual", "N", true);
			boolean pmMode = parser.getValueOf("OpenMode", "WD", true).equalsIgnoreCase("PM");
			if(pmMode){
				enableMultiLingual="N";
			}
			engine = parser.getValueOf("EngineName");
			int dbType = ServerProperty.getReference().getDBType(engine);
			int userid = 0;
			int activityID = parser.getIntOf("ActivityId", 0, true);
			int procDefId = parser.getIntOf("ProcessDefinitionId", 0, true);
            String userDefVarFlag = parser.getValueOf("UserDefVarFlag", "Y", true);
            String rightsFlag = parser.getValueOf("RightFlag", "000000", true);
            boolean bReturnAll = userDefVarFlag.equalsIgnoreCase("Y") ? true : false;
			String processName = null;
                        String locale = "en_US";
                        String uScope = "";
                        boolean isAdmin = false;
			int procVarId = parser.getIntOf("VariantId", 0, true);//Process Variant Support Changes
			char omniServiceFlag = parser.getCharOf("OmniService", 'N', true);
			String searchScope = parser.getValueOf("SearchScope", "", true);
			String aliasAllowed = parser.getValueOf("ForAliasCreation", "", true);
			Document doc = WFXMLUtil.createDocumentWithRoot("Attributes");
			Node parent = doc.getDocumentElement();
    		Document childDoc = parent.getOwnerDocument();
			StringBuffer tempXml = new StringBuffer();
			WFParticipant participant = null;
			/* Adding changes for CriteriaReport */
			boolean isCriteriaReportCase = "Y".equalsIgnoreCase(parser.getValueOf("IsCriteriaCase", "N", true));
			/* Adding changes for CriteriaReport till here*/
			if (omniServiceFlag == 'Y') {
				participant = new WFParticipant(0, "System", 'P', "SERVER", Locale.getDefault().toString());
			} else {
				sessionID = parser.getIntOf("SessionId", 0, false);
				participant = WFSUtil.WFCheckSession(con, sessionID);
			}
			if (procDefId ==0 && !isCriteriaReportCase) {
				processName = parser.getValueOf("ProcessName", "", false);
			}
			if ((participant != null && (participant.gettype() == 'U' || participant.gettype() == 'P')) || (omniServiceFlag == 'Y')) {
				if(!isCriteriaReportCase){
				int userID = participant.getid();
                                uScope = participant.getscope();
                                if(!uScope.equalsIgnoreCase("ADMIN")){
                                    locale = participant.getlocale();
                                    }
                                 if(omniServiceFlag == 'Y'){
                                    isAdmin = true;
                                }else if(uScope.equalsIgnoreCase("ADMIN")){
                                    isAdmin = true;
                                }
                                
				WFVariabledef attribs = null;
				LinkedHashMap cacheMap = new LinkedHashMap();
				WFFieldInfo fieldInfo = null;
                if(procDefId == 0){
                    pstmt = con.prepareStatement("Select Max(ProcessDefId) from ProcessDefTable " + WFSUtil.getTableLockHintStr(dbType) + " where ProcessName = ?");
                    pstmt.setString(1, processName.trim());
                    rs = pstmt.executeQuery();
                    if(rs != null && rs.next()){
                        procDefId = rs.getInt(1);
                    }
                }
                if(rs != null){
					rs.close();
					rs = null;
				}
				if(pstmt != null){
					pstmt.close();
					pstmt = null;
				}
                if(procDefId != 0){
                    /*WFS_6.2_013 Search on process variables and order of Column Display in Search Result.*/
                    if (!searchScope.equals("")) {
						StringTokenizer st = new StringTokenizer(searchScope, ",");
						searchScope = "";
						searchScope = searchScope + TO_STRING(st.nextToken().trim(),true,dbType);
						while (st.countTokens() > 0) {
							searchScope = searchScope + ", " + TO_STRING(st.nextToken().trim(),true,dbType);
						}
                        if (!searchScope.equals("N'E'")){
                            int searchActivityID = WFSUtil.getSearchActivityForUser(con, procDefId, userID, dbType,isAdmin);				
							//if (searchActivityID > 0) {
							//Process Variant Support
								attribs = (WFVariabledef) CachedObjectCollection.getReference().getCacheObject(con, engine, procDefId, WFSConstant.CACHE_CONST_Variable, "" + 0+string21+procVarId).getData();
								cacheMap = attribs.getAttribMap();
								StringBuffer queryBuff = new StringBuffer(250);
                                                                if((locale == null) || (locale != null && locale.equalsIgnoreCase("en-us")) || !enableMultiLingual.equalsIgnoreCase("Y"))
                                                                {
                                                                    queryBuff.append("Select FieldName as AttributeName , VariableScope , Scope  , VariableType as Type , 1024 as Length from WFSearchVariableTable ");
                                                                    queryBuff.append(WFSUtil.getTableLockHintStr(dbType));
                                                                    queryBuff.append(" LEFT OUTER JOIN VarMappingTable " + WFSUtil.getTableLockHintStr(dbType) +"  ON  ");
                                                                    queryBuff.append(TO_STRING("WFSearchVariableTable.FieldName", false, dbType));
                                                                    queryBuff.append(" = ");
                                                                    queryBuff.append(TO_STRING("VarMappingTable.UserDefinedName", false, dbType));
                                                                    queryBuff.append(" and VarMappingTable.ProcessDefID = WFSearchVariableTable.ProcessDefID");
                                                                    queryBuff.append(" where WFSearchVariableTable.ProcessDefID = ? and WFSearchVariableTable.activityID = ? and Scope in (");
                                                                    queryBuff.append(searchScope);
                                                                    queryBuff.append(") order by Scope asc, OrderId asc ");
                                                                    pstmt = con.prepareStatement(queryBuff.toString());
                                                                    pstmt.setInt(1, procDefId);
                                                                    pstmt.setInt(2, searchActivityID);
                                                                }
                                                                else
                                                                {
                                                                    queryBuff.append("Select A.*, EntityName from (");
                                                                    queryBuff.append("Select FieldName as AttributeName , VariableScope , Scope  , VariableType as Type , 1024 as Length,wfsvt.VariableId, OrderId from WFSearchVariableTable wfsvt");
                                                                    queryBuff.append(" LEFT OUTER JOIN VarMappingTable ON  ");
                                                                    queryBuff.append(TO_STRING("wfsvt.FieldName", false, dbType));
                                                                    queryBuff.append(" = ");
                                                                    queryBuff.append(TO_STRING("VarMappingTable.UserDefinedName", false, dbType));
                                                                    queryBuff.append(" and VarMappingTable.ProcessDefID = wfsvt.ProcessDefID");
                                                                    queryBuff.append(" where wfsvt.ProcessDefID = ? and wfsvt.activityID = ? and Scope in (");
                                                                    queryBuff.append(searchScope);
                                                                    queryBuff.append("))A LEFT OUTER JOIN WFMultiLingualTable B  on A.VariableId = B.EntityId and EntityType = 4 and locale = ? and B.ProcessdefId=? ");
                                                                    queryBuff.append(" order by Scope asc, OrderId asc ");
                                                                    pstmt = con.prepareStatement(queryBuff.toString());
                                                                    pstmt.setInt(1, procDefId);
                                                                    pstmt.setInt(2, searchActivityID);
                                                                    WFSUtil.DB_SetString(3, locale, pstmt, dbType);
																	pstmt.setInt(4, procDefId);
                                                                }
								//pstmt = con.prepareStatement(" Select FieldName as AttributeName , VariableScope , Scope  , VariableType as Type , 1024 as Length from WFSearchVariableTable left outer join VarMappingTable on " + TO_STRING("WFSearchVariableTable.FieldName", false, dbType) + " = " + TO_STRING("VarMappingTable.UserDefinedName", false, dbType) + " where WFSearchVariableTable.ProcessDefID = ? and WFSearchVariableTable.activityID = ? and Scope in ( " + searchScope + " ) and (VarMappingTable.ProcessDefID is null or VarMappingTable.ProcessDefID = WFSearchVariableTable.ProcessDefID) order by Scope asc, OrderId asc ");
								pstmt.execute();
								rs = pstmt.getResultSet();
								while (rs != null && rs.next()) {
									String key = rs.getString(1);
									String scope = rs.getString(3);
									char ch = rs.wasNull() ? '\0' : scope.toUpperCase().charAt(0);
									switch (ch) {
										case 'C':
											scope = "4";
											break;
										case 'F':
											scope = "5";
											break;
									}

									fieldInfo = (WFFieldInfo) cacheMap.get(key.toUpperCase());
									if (fieldInfo == null) {
										if (scope.equals("5")) {
											tempXml.append(gen.writeValueOf("ForcedFilter", key));
										}
									} else if (fieldInfo.getRightsInfo().charAt(0) != '3') {

										if(bReturnAll || (!bReturnAll && !fieldInfo.isComplex() && !fieldInfo.isArray())){
											//fieldInfo.serializeFieldInfo(doc, doc.getDocumentElement(), scope, engine);
                                                                                    String entityName = "";
                                                                                    if(locale != null && !locale.equalsIgnoreCase("en-us")  && enableMultiLingual.equalsIgnoreCase("Y"))
                                                                                    {
                                                                                       entityName = rs.getString("EntityName");
                                                                                        if(rs.wasNull())
                                                                                           entityName = "";
                                                                                    }
                                                                                    fieldInfo.serializeFieldInfo(doc, doc.getDocumentElement(), scope, entityName, engine);                                        
										}
									}
								}
								rs.close();
								rs = null;
								pstmt.close();
								pstmt = null;

								tempXml.append(WFXMLUtil.removeXMLHeader(doc));
							/*} else {
                                mainCode = WFSError.WF_OPERATION_FAILED;
                                subCode = WFSError.WFS_ERR_NO_QUERYACTIVITY_DEFINED;
                                subject = WFSErrorMsg.getMessage(mainCode);
                                descr = WFSErrorMsg.getMessage(subCode);
                                errType = WFSError.WF_TMP;
                            }*/
                        }else{
						//Process Variant Support
                            attribs = (WFVariabledef) CachedObjectCollection.getReference().getCacheObject(con, engine, procDefId, WFSConstant.CACHE_CONST_Variable, "0"+ string21 +procVarId).getData();
                            cacheMap = attribs.getAttribMap();
                            Iterator itr = cacheMap.entrySet().iterator();
                            while (itr.hasNext()) {
                                Map.Entry entries = (Map.Entry) itr.next();
                                fieldInfo = (WFFieldInfo) entries.getValue();
                                /*only user defined variables were required hence scope checked*/
                                //if (fieldInfo.getRightsInfo().charAt(0) != '3') {
                                if (fieldInfo.getExtObjId() == 1) {
                                    fieldInfo.serializeFieldInfo(doc, doc.getDocumentElement(), null, 100, engine);
                                }
                            }
                            tempXml.append(WFXMLUtil.removeXMLHeader(doc));
                        } 
                    } else {
					//Process Variant Support
                        attribs = (WFVariabledef) CachedObjectCollection.getReference().getCacheObject(con, engine, procDefId, WFSConstant.CACHE_CONST_Variable, "" + activityID+string21+procVarId).getData();
                        cacheMap = attribs.getAttribMap();
                        Iterator itr = cacheMap.entrySet().iterator();
                        while (itr.hasNext()) {
                            Map.Entry entries = (Map.Entry) itr.next();
                            fieldInfo = (WFFieldInfo) entries.getValue();
                            /*only user defined variables were required hence scope checked*/
                            if (fieldInfo.getRightsInfo().charAt(0) != '3') {
                                fieldInfo.serializeFieldInfo(doc, doc.getDocumentElement(), engine);
                            }
                        }
                        tempXml.append(WFXMLUtil.removeXMLHeader(doc));
                    }
                } else {
                    mainCode = WFSError.WF_OPERATION_FAILED;
                    subCode = WFSError.WFS_ILP;
                    subject = WFSErrorMsg.getMessage(mainCode);
                    descr = WFSErrorMsg.getMessage(subCode);
                    errType = WFSError.WF_TMP;                
                }
                }else{
                	//This block is to return the variables details required in criteria definition..
                	//There are four cases possible - (P,AllQ), (P,Q), (AllP,Q),(AllP,AllQ)
                	if(pstmt != null){
                		pstmt.close();
                		pstmt = null;
                	}
                	int queueId = parser.getIntOf("QueueId", 0, false);
                	StringBuilder query = new StringBuilder();
                	/*Check if the queue is global queue or simple queue*/
                	boolean isGlobalQueue = false;
                	if(procDefId == -1 && queueId != -1){
                		pstmt = con.prepareStatement("select QueueType from queuedeftable "+ WFSUtil.getTableLockHintStr(dbType) + " where queueid = ?");
                		pstmt.setInt(1, queueId);
                		rs = pstmt.executeQuery();
                		if(rs != null && rs.next()){
                			isGlobalQueue = "G".equalsIgnoreCase(rs.getString("QueueType"));
                		}
                		if(rs != null){
                			rs.close();
                			rs = null;
                		}
                		if(pstmt != null){
                			pstmt.close();
                			pstmt = null;
                		}
                	}
                	//First case (Only one process is selected)
                	if(procDefId != -1 && queueId == -1){
                		query.append("select VariableId, SystemDefinedName, UserDefinedName, VariableScope, VariableType from varmappingtable "
                				+ WFSUtil.getTableLockHintStr(dbType) + " where processdefid = ? AND ((VariableScope IN ('S', 'M') "
                				+ " AND VariableId IN (28,29,30,31,35,36,37,38,41,45,46,47,48,49,50,52,10002)) OR (VariableScope IN ('U', 'I') AND VariableType !="+WFSConstant.WF_COMPLEX+"))");
                    	WFSUtil.printOut(engine,"[WMInstruments][WFGetProcessVariablesExt][FirstCase] final query to get the list of input variables : " + query);
                		pstmt = con.prepareStatement(query.toString());
                    	pstmt.setInt(1, procDefId);
                    	rs = pstmt.executeQuery();
                    	while(rs != null && rs.next()){
                    		String systemDefinedName = rs.getString("SystemDefinedName");
                    		String userDefinedName = rs.getString("UserDefinedName");
                    		String variableScope = rs.getString("VariableScope");
                    		if(userDefinedName == null || userDefinedName.isEmpty()){
                    			userDefinedName = systemDefinedName;
                    		}
                    		Element element = childDoc.createElement(userDefinedName);
                    		int variableId=rs.getInt("VariableId");
                            element.setAttribute("VariableId", variableId+"");
                            element.setAttribute("VariableName", userDefinedName);
                            element.setAttribute("Type", rs.getString("VariableType"));
                            element.setAttribute("VariableType", variableScope);
                            element.setAttribute("SystemDefinedName", systemDefinedName);
                            if("M".equalsIgnoreCase(variableScope) || "S".equalsIgnoreCase(variableScope)||(variableId>=1&&variableId<=26)){
                                element.setAttribute("IsSortable", "Y");
                            }else{
                                element.setAttribute("IsSortable", "N");
                            }
                            if(systemDefinedName.equals("EntryDateTime") || systemDefinedName.equals("CheckListCompleteFlag") 
                            		|| systemDefinedName.equals("TurnAroundDateTime") || systemDefinedName.equals("ValidTillDateTime")
                            		|| systemDefinedName.equals("ProcessedBy") || systemDefinedName.equals("LockedTime")
                            		|| systemDefinedName.equals("QueueName") || systemDefinedName.equals("LockStatus")
                            		|| systemDefinedName.equals("Priority") || systemDefinedName.equals("InstrumentStatus"))
                            {
                                element.setAttribute("MappedType", "2");
                            }else{
                                element.setAttribute("MappedType", "3");
                            }
                            parent.appendChild(element);
                    	}
                		Element element = childDoc.createElement("AssignedUser");
						element.setAttribute("VariableId", "0");
						element.setAttribute("VariableName", "AssignedUser");
						element.setAttribute("Type", "10");
						element.setAttribute("VariableType", "M");
						element.setAttribute("SystemDefinedName", "AssignedUser");
						element.setAttribute("MappedType", "3");
                        element.setAttribute("IsSortable", "N");
						parent.appendChild(element);
                    	
                    	tempXml.append(WFXMLUtil.removeXMLHeader(doc));
                    	if(rs != null){
                    		rs.close();
                    		rs = null;
                    	}
                    	if(pstmt != null){
                    		pstmt.close();
                    		pstmt = null;
                    	}
                	}else if(procDefId != -1 && queueId != -1){	//Second Case
                		query.append("select VM.VariableId, VM.SystemDefinedName, VM.UserDefinedName, VM.VariableScope, VM.VariableType, VA.Alias, VA.VariableId1 from "
                				+ " (select VariableId, SystemDefinedName, UserDefinedName, VariableScope, VariableType from varmappingtable " + WFSUtil.getTableLockHintStr(dbType)
                				+ " where ProcessDefID = ? AND ((VariableScope IN ('S', 'M') AND VariableId IN (28,29,30,31,35,36,37,38,41,42,45,46,47,48,49,50,52,10002)) "
                				+ " OR (VariableScope IN ('U', 'I') AND VariableType!= "+WFSConstant.WF_COMPLEX+"))) VM LEFT JOIN (select Alias, Param1, Type1, VariableId1 from varAliasTable "+ WFSUtil.getTableLockHintStr(dbType) 
                				+ " where queueId = ?" 
                				+ (queueId==0 ? " AND ProcessDefID = ?": "" )
                				+ ") VA ON VA.Param1 = VM.SystemDefinedName and VA.Type1 = VM.VariableType");
                    	WFSUtil.printOut(engine,"[WMInstruments][WFGetProcessVariablesExt][SecondCase] final query to get the list of input variables : " + query);
                		pstmt = con.prepareStatement(query.toString());
                		pstmt.setInt(1, procDefId);
                		pstmt.setInt(2, queueId);
                		if( queueId == 0 )
                		{
                		pstmt.setInt(3, procDefId);
                		}
                    	rs = pstmt.executeQuery();
                    	while(rs != null && rs.next()){
                    		String systemDefinedName = rs.getString("SystemDefinedName");
                    		String userDefinedName = rs.getString("UserDefinedName");
                    		String variableScope = rs.getString("VariableScope");
                    		String alias = rs.getString("Alias");
                    		if(userDefinedName == null || userDefinedName.isEmpty()){
                    			userDefinedName = systemDefinedName;
                    		}
                    		if(alias == null || alias.isEmpty()){
                    			alias = userDefinedName;
                    		}else{
                    			variableScope = "A";
                    		}
                    		Element element = null;
                            if("A".equalsIgnoreCase(variableScope)){
                                element = childDoc.createElement("Alias");
                                element.setAttribute("VariableId", rs.getInt("VariableId")+"");
                                element.setAttribute("Name", alias);
                                element.setAttribute("OrderBy", rs.getInt("VariableId1")+"");
                            }else{
                            	element = childDoc.createElement(userDefinedName);
                                element.setAttribute("VariableId", rs.getInt("VariableId")+"");
                                element.setAttribute("VariableName", alias);
                            }
                            element.setAttribute("Type", rs.getString("VariableType"));
                            element.setAttribute("VariableType", variableScope);
                            element.setAttribute("SystemDefinedName", systemDefinedName);
                            if("M".equalsIgnoreCase(variableScope) || "S".equalsIgnoreCase(variableScope) || "A".equalsIgnoreCase(variableScope)){
                                element.setAttribute("IsSortable", "Y");
                            }else{
                                element.setAttribute("IsSortable", "N");
                            }
                            if(systemDefinedName.equals("VarientName") || systemDefinedName.equals("InstrumentStatus") || systemDefinedName.equals("Status")){
                                element.setAttribute("MappedType", "1");
                            }else if(systemDefinedName.equals("TurnAroundDateTime") || systemDefinedName.equals("ProcessedBy") || systemDefinedName.equals("LockedTime")
                            		|| systemDefinedName.equals("QueueName") || systemDefinedName.equals("StateName"))
                            {
                                element.setAttribute("MappedType", "2");
                            }else{
                                element.setAttribute("MappedType", "3");
                            }
                            parent.appendChild(element);
                    	}
                		Element element = childDoc.createElement("AssignedUser");
						element.setAttribute("VariableId", "0");
						element.setAttribute("VariableName", "AssignedUser");
						element.setAttribute("Type", "10");
						element.setAttribute("VariableType", "M");
						element.setAttribute("SystemDefinedName", "AssignedUser");
						element.setAttribute("MappedType", "3");
                        element.setAttribute("IsSortable", "N");
						parent.appendChild(element);
                    	
                    	tempXml.append(WFXMLUtil.removeXMLHeader(doc));
                    	if(rs != null){
                    		rs.close();
                    		rs = null;
                    	}
                    	if(pstmt != null){
                    		pstmt.close();
                    		pstmt = null;
                    	}
                	}else if(procDefId == -1 && queueId != -1){ //Third Case
                		if(!isGlobalQueue){
	                		query.append("select VM.VariableId, VM.SystemDefinedName, VM.VariableScope, VM.VariableType, VA.Alias, VA.VariableId1 "
	                				+ " from (select VariableId, SystemDefinedName, VariableScope, VariableType from varmappingtable " + WFSUtil.getTableLockHintStr(dbType) 
	                				+ " where ProcessDefID = (select MAX(PRocessDefiD) from ProcessDefTable " + WFSUtil.getTableLockHintStr(dbType) 
	                				+ " ) AND ((VariableScope IN ('S', 'M') AND VariableId IN (28,29,30,31,35,36,37,38,41,42,45,46,47,48,49,50,52,10002)) "
	                				+ " OR (VariableScope = 'U'))) VM LEFT JOIN (select Alias, Param1, Type1, VariableId1 from varAliasTable " + WFSUtil.getTableLockHintStr(dbType) 
	                				+ " where queueId = ?"
	                				+ (queueId==0 ? " AND ProcessDefID = 0": "") 
	                				+ ") VA ON VA.Param1 = VM.SystemDefinedName and VA.Type1 = VM.VariableType");
	                		WFSUtil.printOut(engine,"[WMInstruments][WFGetProcessVariablesExt][ThirdCase] final query to get the list of input variables : " + query);
	                		pstmt = con.prepareStatement(query.toString());
	                		pstmt.setInt(1, queueId);
	                    	rs = pstmt.executeQuery();
	                    	while(rs != null && rs.next()){
	                    		String systemDefinedName = rs.getString("SystemDefinedName");
	                    		//String userDefinedName = rs.getString("UserDefinedName");
	                    		String variableScope = rs.getString("VariableScope");
	                    		String alias = rs.getString("Alias");
	                    		if(alias == null || alias.isEmpty()){
	                    			alias = systemDefinedName;
	                    		}else{
	                    			variableScope = "A";
	                    		}
	                    		Element element = null;
	                            if("A".equalsIgnoreCase(variableScope)){
	                                element = childDoc.createElement("Alias");
		                            element.setAttribute("VariableId", rs.getInt("VariableId")+"");
		                            element.setAttribute("Name", alias);
	                                element.setAttribute("OrderBy", rs.getInt("VariableId1")+"");
	                            }else{
	                            	element = childDoc.createElement(systemDefinedName);
		                            element.setAttribute("VariableId", rs.getInt("VariableId")+"");
		                            element.setAttribute("VariableName", alias);
	                            }
	                            element.setAttribute("Type", rs.getString("VariableType"));
	                            element.setAttribute("VariableType", variableScope);
	                            element.setAttribute("SystemDefinedName", systemDefinedName);
	                            if("M".equalsIgnoreCase(variableScope) || "S".equalsIgnoreCase(variableScope) || "A".equalsIgnoreCase(variableScope)){
	                                element.setAttribute("IsSortable", "Y");
	                            }else{
	                                element.setAttribute("IsSortable", "N");
	                            }
	                            if(systemDefinedName.equals("VarientName") || systemDefinedName.equals("InstrumentStatus") || systemDefinedName.equals("Status")){
	                                element.setAttribute("MappedType", "1");
	                            }else if(systemDefinedName.equals("TurnAroundDateTime") || systemDefinedName.equals("ProcessedBy") || systemDefinedName.equals("LockedTime")
	                            		|| systemDefinedName.equals("QueueName") || systemDefinedName.equals("StateName"))
	                            {
	                                element.setAttribute("MappedType", "2");
	                            }else{
	                                element.setAttribute("MappedType", "3");
	                            }
	                            parent.appendChild(element);
	                    	}
	                		Element element = childDoc.createElement("AssignedUser");
							element.setAttribute("VariableId", "0");
							element.setAttribute("VariableName", "AssignedUser");
							element.setAttribute("Type", "10");
							element.setAttribute("VariableType", "M");
							element.setAttribute("SystemDefinedName", "AssignedUser");
							element.setAttribute("MappedType", "3");
	                        element.setAttribute("IsSortable", "N");
							parent.appendChild(element);
							
	                    	tempXml.append(WFXMLUtil.removeXMLHeader(doc));
	                    	if(rs != null){
	                    		rs.close();
	                    		rs = null;
	                    	}
	                    	if(pstmt != null){
	                    		pstmt.close();
	                    		pstmt = null;
	                    	}
                		}else{
	                		query.append("select VM.VariableId, VM.SystemDefinedName, VM.VariableScope, VM.VariableType, VA.Alias, VA.VariableId1 "
	                				+ " from (select VariableId, SystemDefinedName, VariableScope, VariableType from varmappingtable " + WFSUtil.getTableLockHintStr(dbType) 
	                				+ " where ProcessDefID = (select MAX(PRocessDefiD) from ProcessDefTable " + WFSUtil.getTableLockHintStr(dbType) 
	                				+ " ) AND ((VariableScope = 'U') OR (VariableScope IN ('S', 'M') AND VariableId IN (28,29,30,31,35,36,37,38,41,42,45,46,47,48,49,50,52,10002))"
	                				+ " )) VM LEFT JOIN (select Alias, Param1, Type1, VariableId1 from varAliasTable " + WFSUtil.getTableLockHintStr(dbType) 
	                				+ " where queueId = ?) VA ON VA.Param1 = VM.SystemDefinedName and VA.Type1 = VM.VariableType");
	                		WFSUtil.printOut(engine,"[WMInstruments][WFGetProcessVariablesExt][ThirdCase - Global Queue] final query to get the list of input variables : " + query);
	                		pstmt = con.prepareStatement(query.toString());
	                		pstmt.setInt(1, queueId);
	                    	rs = pstmt.executeQuery();
	                    	while(rs != null && rs.next()){
	                    		String systemDefinedName = rs.getString("SystemDefinedName");
	                    		//String userDefinedName = rs.getString("UserDefinedName");
	                    		String variableScope = rs.getString("VariableScope");
	                    		String alias = rs.getString("Alias");
	                    		if(alias == null || alias.isEmpty()){
	                    			alias = systemDefinedName;
	                    		}else{
	                    			variableScope = "A";
	                    		}
	                    		Element element = null;
	                            if("A".equalsIgnoreCase(variableScope)){
	                                element = childDoc.createElement("Alias");
		                            element.setAttribute("VariableId", rs.getInt("VariableId")+"");
		                            element.setAttribute("Name", alias);
		                            element.setAttribute("OrderBy", rs.getInt("VariableId1")+"");
	                            }else{
	                            	element = childDoc.createElement(systemDefinedName);
		                            element.setAttribute("VariableId", rs.getInt("VariableId")+"");
		                            element.setAttribute("VariableName", alias);
	                            }
	                            element.setAttribute("Type", rs.getString("VariableType"));
	                            element.setAttribute("VariableType", variableScope);
	                            element.setAttribute("SystemDefinedName", systemDefinedName);
	                            if("M".equalsIgnoreCase(variableScope) || "S".equalsIgnoreCase(variableScope) || "A".equalsIgnoreCase(variableScope)){
	                                element.setAttribute("IsSortable", "Y");
	                            }else{
	                                element.setAttribute("IsSortable", "N");
	                            }
	                            if(systemDefinedName.equals("VarientName") || systemDefinedName.equals("InstrumentStatus") || systemDefinedName.equals("Status")){
	                                element.setAttribute("MappedType", "1");
	                            }else if(systemDefinedName.equals("TurnAroundDateTime") || systemDefinedName.equals("ProcessedBy") || systemDefinedName.equals("LockedTime")
	                            		|| systemDefinedName.equals("QueueName") || systemDefinedName.equals("StateName"))
	                            {
	                                element.setAttribute("MappedType", "2");
	                            }else{
	                                element.setAttribute("MappedType", "3");
	                            }
	                            parent.appendChild(element);
	                    	}
	                		Element element = childDoc.createElement("AssignedUser");
							element.setAttribute("VariableId", "0");
							element.setAttribute("VariableName", "AssignedUser");
							element.setAttribute("Type", "10");
							element.setAttribute("VariableType", "M");
							element.setAttribute("SystemDefinedName", "AssignedUser");
							element.setAttribute("MappedType", "3");
	                        element.setAttribute("IsSortable", "N");
							parent.appendChild(element);
							
	                    	tempXml.append(WFXMLUtil.removeXMLHeader(doc));
	                    	if(rs != null){
	                    		rs.close();
	                    		rs = null;
	                    	}
	                    	if(pstmt != null){
	                    		pstmt.close();
	                    		pstmt = null;
	                    	}
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
				outputXML = new StringBuffer(500);
				outputXML.append(gen.createOutputFile("WFGetProcessVariablesExt"));
				outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
				outputXML.append(tempXml);
				outputXML.append(gen.closeOutputFile("WFGetProcessVariablesExt"));
			}
		} catch (NullPointerException e) {
			WFSUtil.printErr(engine,"", e);
			mainCode = WFSError.WF_OPERATION_FAILED;
			subCode = WFSError.WFS_SYS;
			subject = WFSErrorMsg.getMessage(mainCode);
			errType = WFSError.WF_TMP;
			descr = e.toString();
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
			try{
				if(rs!=null){
					rs.close();
					rs=null;
				}
			}catch(Exception e){
				WFSUtil.printErr(engine,"", e);
			}
			
			try{
				if(pstmt!=null){
					pstmt.close();
					pstmt=null;
				}
			}catch(Exception e){
				WFSUtil.printErr(engine,"", e);
			}
			
		}
		if (mainCode != 0) {
			throw new WFSException(mainCode, subCode, errType, subject, descr);
		}
		return outputXML.toString();
	}

	/*need to see where to put it, in wfsutil or here only -shilpi*/
	private String[] getAttributeInfo(LinkedHashMap<String, WFFieldInfo> cacheMap, String attribName) {
		StringTokenizer strTokenizer = new StringTokenizer(attribName, ".");
		String toReturn = attribName;
		String tableName = null;
		String columnName = null;
		int extObjId = 0;
		int wfType = 10;
		/*in our case it will always be column - shilpi*/
		LinkedHashMap<String, WFFieldInfo> tempMap = cacheMap;
		while (strTokenizer.hasMoreTokens()) {
			toReturn = strTokenizer.nextToken().toUpperCase();
			/* whats key in here? is it userdefname*/
			extObjId = tempMap.get(toReturn).getExtObjId();
			wfType = tempMap.get(toReturn).getWfType();
			if (extObjId > 0) {
				if (tempMap.get(toReturn).getMappedTable() != null) {
					tableName = tempMap.get(toReturn).getMappedTable();
				}
				columnName = tempMap.get(toReturn).getMappedColumn();
			}
			tempMap = tempMap.get(toReturn).getChildInfoMap();
		}
		/*toReturn is in upper case- check it may create some problem- shilpi*/
		return new String[]{toReturn, "" + extObjId, "" + wfType, tableName, columnName};
	}
        //----------------------------------------------------------------------------------------------------
	//	Function Name 				    :	populateAliasMap
	//	Date Written (DD/MM/YYYY)		:	01/10/2010
	//	Author						    :	Abhishek Gupta
	//	Input Parameters		    	:	None
	//	Output Parameters			    :	HashMap
	//	Return Values				    :	None
	//	Description					    :	Method populates Hashmap with the System defined
    //                                         variables information.
	//----------------------------------------------------------------------------------------------------
    private HashMap populateAliasMap() {
        HashMap aliasMap = new HashMap<String, Object[]>();
        aliasMap.put("VAR_INT1", new Object[]{101, 3});
        aliasMap.put("VAR_INT2", new Object[]{102, 3});
        aliasMap.put("VAR_INT3", new Object[]{103, 3});
        aliasMap.put("VAR_INT4", new Object[]{104, 3});
        aliasMap.put("VAR_INT5", new Object[]{105, 3});
        aliasMap.put("VAR_INT6", new Object[]{106, 3});
        aliasMap.put("VAR_INT7", new Object[]{107, 3});
        aliasMap.put("VAR_INT8", new Object[]{108, 3});
        aliasMap.put("VAR_FLOAT1", new Object[]{109, 6});
        aliasMap.put("VAR_FLOAT2", new Object[]{110, 6});
        aliasMap.put("VAR_DATE1", new Object[]{111, 8});
        aliasMap.put("VAR_DATE2", new Object[]{112, 8});
        aliasMap.put("VAR_DATE3", new Object[]{113, 8});
        aliasMap.put("VAR_DATE4", new Object[]{114, 8});
        aliasMap.put("VAR_LONG1", new Object[]{115, 4});
        aliasMap.put("VAR_LONG2", new Object[]{116, 4});
        aliasMap.put("VAR_LONG3", new Object[]{117, 4});
        aliasMap.put("VAR_LONG4", new Object[]{118, 4});
        aliasMap.put("VAR_STR1", new Object[]{119, 10});
        aliasMap.put("VAR_STR2", new Object[]{120, 10});
        aliasMap.put("VAR_STR3", new Object[]{121, 10});
        aliasMap.put("VAR_STR4", new Object[]{122, 10});
        aliasMap.put("VAR_STR5", new Object[]{123, 10});
        aliasMap.put("VAR_STR6", new Object[]{124, 10});
        aliasMap.put("VAR_STR7", new Object[]{125, 10});
        aliasMap.put("VAR_STR8", new Object[]{126, 10});
        aliasMap.put("VAR_DATE5", new Object[]{10006, 8});
        aliasMap.put("VAR_DATE6", new Object[]{10007, 8});
        aliasMap.put("VAR_LONG5", new Object[]{10008, 4});
        aliasMap.put("VAR_LONG6", new Object[]{10009, 4});
        aliasMap.put("VAR_STR9", new Object[]{10010, 10});
        aliasMap.put("VAR_STR10", new Object[]{10011, 10});
        aliasMap.put("VAR_STR11", new Object[]{10012, 10});
        aliasMap.put("VAR_STR12", new Object[]{10013, 10});
        aliasMap.put("VAR_STR13", new Object[]{10014, 10});
        aliasMap.put("VAR_STR14", new Object[]{10015, 10});
        aliasMap.put("VAR_STR15", new Object[]{10016, 10});
        aliasMap.put("VAR_STR16", new Object[]{10017, 10});
        aliasMap.put("VAR_STR17", new Object[]{10018, 10});
        aliasMap.put("VAR_STR18", new Object[]{10019, 10});
        aliasMap.put("VAR_STR19", new Object[]{10020, 10});
        aliasMap.put("VAR_STR20", new Object[]{10021, 10});
        aliasMap.put("PriorityLevel".toUpperCase(), new Object[]{1, 3});
        aliasMap.put("processinstanceid".toUpperCase(), new Object[]{2, 10});
        aliasMap.put("ActivityName".toUpperCase(), new Object[]{3, 10});
        aliasMap.put("lockedByname".toUpperCase(), new Object[]{4, 10});
        aliasMap.put("introducedby".toUpperCase(), new Object[]{5, 10});
        aliasMap.put("InstrumentStatus".toUpperCase(), new Object[]{6, 10});
        aliasMap.put("CheckListCompleteFlag".toUpperCase(), new Object[]{7, 10});
        aliasMap.put("lockstatus".toUpperCase(), new Object[]{8, 10});
        aliasMap.put("statename".toUpperCase(), new Object[]{9, 10});
        aliasMap.put("entrydatetime".toUpperCase(), new Object[]{10, 8});
        aliasMap.put("ValidTill".toUpperCase(), new Object[]{11, 8});
        aliasMap.put("LockedTime".toUpperCase(), new Object[]{12, 8});
        aliasMap.put("introductiondatetime".toUpperCase(), new Object[]{13, 8});
        aliasMap.put("queuename".toUpperCase(), new Object[]{14, 10});
        aliasMap.put("processname".toUpperCase(), new Object[]{15, 10});
        aliasMap.put("assigneduser".toUpperCase(), new Object[]{16, 10});
        aliasMap.put("Status".toUpperCase(), new Object[]{17, 10});
        aliasMap.put("createddatetime".toUpperCase(), new Object[]{18, 8});
        aliasMap.put("expectedWorkitemDelay".toUpperCase(), new Object[]{19, 8});
        aliasMap.put("CreatedByName".toUpperCase(), new Object[]{21, 10});
	// 01/07/2013 	Bug 38088 - Added alias for variable 'Activityid' is not showing in Process Variable Mapping 
		aliasMap.put("WorkItemState".toUpperCase(), new Object[]{22, 3});
		aliasMap.put("ActivityId".toUpperCase(), new Object[]{23, 3});
		aliasMap.put("AssignmentType ".toUpperCase(), new Object[]{24, 10});
		aliasMap.put("ProcessedBy".toUpperCase(), new Object[]{25, 10});
		aliasMap.put("ValidTillDateTime".toUpperCase(), new Object[]{26, 8});
		aliasMap.put("WorkItemName".toUpperCase(), new Object[]{27, 10});
		aliasMap.put("PreviousStage".toUpperCase(), new Object[]{28, 10});
		aliasMap.put("TurnAroundDateTime".toUpperCase(), new Object[]{29, 8});
		aliasMap.put("CurrentDateTime".toUpperCase(), new Object[]{30, 8});
		aliasMap.put("TATRemaining".toUpperCase(), new Object[]{10028, 4});
		aliasMap.put("TATConsumed".toUpperCase(), new Object[]{10029, 4});
		
		
		
//ProcessedbY missing


        return aliasMap;
    }
	
	//----------------------------------------------------------------------------------------------------
	//	Function Name 				      :	WFGetNextWorkitemforSharepoint
	//	Date Written (DD/MM/YYYY)	      :	1/05/2012
	//	Author						      :	Shweta Singhal
	//	Input Parameters		    	  :	Connection , XMLParser , XMLGenerator
	//	Output Parameters			      : none
	//	Return Values				      :	String
	//	Description					      : Get Next Workitem for Share Point Archive
	//----------------------------------------------------------------------------------------------------
	public String WFGetNextWorkitemforSharepoint(Connection con, XMLParser parser, XMLGenerator gen) throws JTSException, WFSException {
		return getNextUnlockedWorkitemUtil(con, parser, gen);
	}
        
//        public String WFPopulateAuditTrailList(Connection con, XMLParser parser, XMLGenerator gen) throws JTSException, WFSException 
//	{
//		StringBuffer outputXML = null;
//		PreparedStatement pstmt = null;
//		int mainCode = 0;
//		int subCode = 0;
//		String subject = null;
//		String descr = null;
//		String errType = WFSError.WF_TMP;
//		try 
//		{
//			int sessionID = parser.getIntOf("SessionId", 0, false);
//			String engine = parser.getValueOf("EngineName");
//			int processdefId = parser.getIntOf("ProcessDefId", 0, false);
//			String processInstanceId = parser.getValueOf("ProcessInstanceId", "", false);
//			int workitemId = parser.getIntOf("WorkitemId", 0, false);
//			int activityId = parser.getIntOf("ActivityId", 0, false);
//			int docId = parser.getIntOf("DocId", 0, false);
//			int parentFolder = parser.getIntOf("ParentFolderIndex", 0, false);
//			int volId = parser.getIntOf("VoulmeIndex", 0, false);
//			String appServerIP = parser.getValueOf("AppServerIP");
//			int appServerPort = parser.getIntOf("AppSeverPort", 0, false);
//			String appServerType = parser.getValueOf("AppServerType");
//			String cabinetName = parser.getValueOf("dmsEngineName");
//                        String deleteAudit = parser.getValueOf("deleteAudit", "", false);
//			int dbType = ServerProperty.getReference().getDBType(engine);
//			WFParticipant participant = WFSUtil.WFCheckSession(con, sessionID);
//			if(participant != null  && participant.gettype() == 'U') {
//				pstmt = con.prepareStatement("Insert into WFAuditTrailDocTable values ( ?,?,?,?,?,?,?,?,?,?,?,?,"
//				+ WFSConstant.WF_VARCHARPREFIX +"N',NULL)");
//				pstmt.setInt(1, processdefId);
//				WFSUtil.DB_SetString(2, processInstanceId, pstmt, dbType);
//				pstmt.setInt(3, workitemId);
//				pstmt.setInt(4, activityId);
//				pstmt.setInt(5, docId);
//				pstmt.setInt(6, parentFolder);
//				pstmt.setInt(7, volId);
//				WFSUtil.DB_SetString(8, appServerIP, pstmt, dbType);
//				pstmt.setInt(9, appServerPort);
//				WFSUtil.DB_SetString(10, appServerType, pstmt, dbType);
//				WFSUtil.DB_SetString(11, cabinetName, pstmt, dbType);
//                                WFSUtil.DB_SetString(12, deleteAudit, pstmt, dbType);
//				pstmt.executeUpdate();
//				pstmt.close();
//			}
//			else {
//				mainCode = WFSError.WM_INVALID_SESSION_HANDLE;
//				subCode = 0;
//				subject = WFSErrorMsg.getMessage(mainCode);
//				descr = WFSErrorMsg.getMessage(subCode);
//				errType = WFSError.WF_TMP;
//			}
//			if(mainCode == 0) 
//			{
//				outputXML = new StringBuffer(500);
//				outputXML.append(gen.createOutputFile("WFPopulateAuditTrailList"));
//				outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
//				outputXML.append(gen.closeOutputFile("WFPopulateAuditTrailList"));
//			}
//
//		}
//		catch (SQLException e) {
//            WFSUtil.printErr("", e);
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
//            WFSUtil.printErr("", e);
//            mainCode = WFSError.WF_OPERATION_FAILED;
//            subCode = WFSError.WFS_ILP;
//            subject = WFSErrorMsg.getMessage(mainCode);
//            errType = WFSError.WF_TMP;
//            descr = e.toString();
//        } catch (NullPointerException e) {
//            WFSUtil.printErr("", e);
//            mainCode = WFSError.WF_OPERATION_FAILED;
//            subCode = WFSError.WFS_SYS;
//            subject = WFSErrorMsg.getMessage(mainCode);
//            errType = WFSError.WF_TMP;
//            descr = e.toString();
//        } catch (WFSException e) {
//            mainCode = WFSError.WM_NO_MORE_DATA;
//            subCode = 0;
//            subject = WFSErrorMsg.getMessage(mainCode);
//            errType = WFSError.WF_TMP;
//            descr = WFSErrorMsg.getMessage(subCode);
//        } catch (JTSException e) {
//            mainCode = WFSError.WF_OPERATION_FAILED;
//            subCode = e.getErrorCode();
//            subject = WFSErrorMsg.getMessage(mainCode);
//            errType = WFSError.WF_TMP;
//            descr = e.getMessage();
//        } catch (Exception e) {
//            WFSUtil.printErr("", e);
//            mainCode = WFSError.WF_OPERATION_FAILED;
//            subCode = WFSError.WFS_EXP;
//            subject = WFSErrorMsg.getMessage(mainCode);
//            errType = WFSError.WF_TMP;
//            descr = e.toString();
//        } catch (Error e) {
//            WFSUtil.printErr("", e);
//            mainCode = WFSError.WF_OPERATION_FAILED;
//            subCode = WFSError.WFS_EXP;
//            subject = WFSErrorMsg.getMessage(mainCode);
//            errType = WFSError.WF_TMP;
//            descr = e.toString();
//        } finally {
//            try {
//				if (pstmt != null) {
//                    pstmt.close();
//                    pstmt = null;
//                }
//            } catch (Exception e) {}
//            if (mainCode != 0) {
//                throw new WFSException(mainCode, subCode, errType, subject, descr);
//            }
//        }
//        return outputXML.toString();
//
//	}
        
    public String WFGetNextWorkitemforCaseSummary(Connection con, XMLParser parser,XMLGenerator gen) throws JTSException, WFSException  {
        	int mainCode = 0 ;
        	int subCode = 0;
        	StringBuffer outputXML = null;
        	StringBuffer tempXml = new StringBuffer(500);
        	PreparedStatement pstmt = null;
        	PreparedStatement pstmt1 = null;

        	ResultSet rs = null;
        	String subject = null;
        	String descr = null;
        	String errType = WFSError.WF_TMP;
        	int cssession = 0 ;
        	try 
        	{
        		int processDefId = 0;
        		int sessionID = parser.getIntOf("SessionId", 0, false);
        		String engine = parser.getValueOf("EngineName");
        		String csName = parser.getValueOf("CSName");
        		StringBuffer queryBuff = new StringBuffer(100);
        		int dbType = ServerProperty.getReference().getDBType(engine);
        		WFParticipant participant = WFSUtil.WFCheckSession(con, sessionID);
        		if(participant != null && participant.gettype() == 'P') {

        			int userid = participant.getid();
        			String username = participant.getname();
        			if(csName != null && !csName.trim().equals("")){

        				pstmt = con.prepareStatement("Select SessionID from PSRegisterationTable " + WFSUtil.getTableLockHintStr(dbType) + " where Type = 'C' AND PSName = ?");
        				WFSUtil.DB_SetString(1, csName.trim(), pstmt, dbType);
        				pstmt.execute();
        				rs = pstmt.getResultSet();
        				if(rs != null && rs.next()){
        					cssession = rs.getInt(1);
        				}

        			}
        			if (rs != null) {
        				rs.close();
        				rs=null;
        			}
        			if(pstmt != null) {
        				pstmt.close();
        				pstmt = null;
        			}
        			if (con.getAutoCommit()) {
        				con.setAutoCommit(false);
        			}
        			queryBuff.setLength(0);
        			queryBuff.append("Select ");
        			queryBuff.append(WFSUtil.getFetchPrefixStr(dbType, 1));
        			queryBuff.append("  ProcessInstanceId,WorkItemId,ProcessDefId,ActivityId,ActivityName,Status,NoOfRetries,EntryDateTime,LockedBy From WFCaseSummaryDetailsTable "+WFSUtil.getLockPrefixStr(dbType)+" where (Status = ? and (LockedBy IS NULL or LockedBy = ? )");
        			queryBuff.append(" and NoOfRetries<=?)or  (Status = ? and NoOfRetries<=? )");
        			queryBuff.append(WFSUtil.getFetchSuffixStr(dbType, 1, " and "));
        			queryBuff.append(WFSUtil.getLockSuffixStr(dbType));
        			pstmt =	con.prepareStatement(queryBuff.toString());
        			pstmt.setInt(1,WFSConstant.CASE_SUMMARY_DOCUMENT_READY);
        			pstmt.setString(2, username);
        			pstmt.setInt(3, 5);
        			pstmt.setInt(4,WFSConstant.CASE_SUMMARY_DOCUMENT_FAILURE);
        			pstmt.setInt(5, 5);
        			
        			pstmt.execute();
        			rs = pstmt.getResultSet();
        			if (rs != null && rs.next()){
        				processDefId = rs.getInt("ProcessDefId");
        				tempXml.append(gen.writeValueOf("ProcessDefId",String.valueOf(rs.getInt("ProcessDefId"))));;
        				String processInstanceId = rs.getString("ProcessInstanceId");
        				tempXml.append(gen.writeValueOf("ProcessInstanceId",processInstanceId));
        				int workitemId = rs.getInt("WorkItemId");
        				tempXml.append(gen.writeValueOf("WorkitemId", String.valueOf(workitemId)));
        				int activityId=rs.getInt("ActivityId");
        				tempXml.append(gen.writeValueOf("ActivityId",String.valueOf(activityId)));
        				int status = rs.getInt("Status");
        				pstmt1 = con.prepareStatement("Update WFCaseSummaryDetailsTable set Status = ? , LockedBy = ?,NoOfRetries=NoOfRetries+1 where ProcessInstanceId = ? and WorkitemId = ? and activityid = ? and status=?");
        				pstmt1.setInt(1, WFSConstant.CASE_SUMMARY_DOCUMENT_IN_PROGRESS);
        				WFSUtil.DB_SetString(2, username, pstmt1, dbType);
        				WFSUtil.DB_SetString(3, processInstanceId, pstmt1, dbType);
        				pstmt1.setInt(4, workitemId);
        				pstmt1.setInt(5, activityId);
        				pstmt1.setInt(6,status);
        				int f = pstmt1.executeUpdate();
        				if(f>0) {
        					if (!con.getAutoCommit()) {
        						con.commit();
        						con.setAutoCommit(true);
        					}
        				}
        				else {
        					if(!con.getAutoCommit()) {
        						con.rollback();
        						con.setAutoCommit(true);
        						mainCode = WFSError.WF_OPERATION_FAILED;
        					}
        				}
        				if(rs!=null){
        					rs.close();
        					rs=null;
        				}
        				if(pstmt1!=null){
        					pstmt1.close();
        					pstmt1=null;
        				}
        				pstmt1= con.prepareStatement("Select VAR_REC_1 from WFInstrumentTable "+WFSUtil.getTableLockHintStr(dbType) + " where processinstanceid= ? and workitemid= ?");
        				pstmt1.setString(1,processInstanceId);
        				pstmt1.setInt(2,workitemId);
        				rs=pstmt1.executeQuery();
        				if(rs.next()){
        					String folderIndex =rs.getString(1);
        					tempXml.append(gen.writeValueOf("FolderIndex",String.valueOf(folderIndex)));;
            				
        				}
        				if(rs!=null){
        					rs.close();
        					rs=null;
        				}
        				if(pstmt1!=null){
        					pstmt1.close();
        					pstmt1=null;
        				}
        				pstmt1= con.prepareStatement("Select a.ActivityName,b.DocName from ActivityTable a "+WFSUtil.getTableLockHintStr(dbType) 
        				+ " inner join DocumentTypeDefTable b "+WFSUtil.getTableLockHintStr(dbType) 
        				+ " on a.processdefid = b.processdefid and a.DocTypeId = b.DocId where a.processdefid = ? and a.activityid= ?");
        				pstmt1.setInt(1,processDefId);
        				pstmt1.setInt(2,activityId);
        				rs=pstmt1.executeQuery();
        				if(rs.next()){
        					String activityName =rs.getString(1);
        					String caseDocName = rs.getString(2);
        					tempXml.append(gen.writeValueOf("CaseSummaryDocName",caseDocName ));;
            				
        				}
        				if(rs!=null){
        					rs.close();
        					rs=null;
        				}
        				if(pstmt1!=null){
        					pstmt1.close();
        					pstmt1=null;
        				}
        				
        				
        				
        				
        			}
        			else{
        				mainCode = WFSError.WM_NO_MORE_DATA;
        			}
        			if (rs!= null){
        				rs.close();
        				rs = null;
        			}
        			if (pstmt!= null){
        				pstmt.close();
        				pstmt = null;
        			}
        			if (pstmt1!= null){
        				pstmt1.close();
        				pstmt1 = null;
        			}
        		}
        		else {
        			mainCode = WFSError.WM_INVALID_SESSION_HANDLE;
        			subCode = 0;
        			subject = WFSErrorMsg.getMessage(mainCode);
        			descr = WFSErrorMsg.getMessage(subCode);
        			errType = WFSError.WF_TMP;
        		}
        		if(mainCode == 0) {
            		outputXML = new StringBuffer(500);
        			outputXML.append(gen.createOutputFile("WFGetNextWorkitemforCaseSummary"));
        			outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
        			outputXML.append(gen.writeValueOf("CSSession", String.valueOf(cssession)));
        			outputXML.append(tempXml.toString());
        			outputXML.append(gen.closeOutputFile("WFGetNextWorkitemforCaseSummary"));
        		}
        		if(mainCode == WFSError.WM_NO_MORE_DATA) {
        			outputXML = new StringBuffer(500);
        			outputXML.append(gen.writeError("WFGetNextWorkitemforCaseSummary", WFSError.WM_NO_MORE_DATA, 0,
        					WFSError.WF_TMP, WFSErrorMsg.getMessage(WFSError.WM_NO_MORE_DATA), ""));
        			outputXML.delete(outputXML.indexOf("</" + "WFGetNextWorkitemforCaseSummary" + "_Output>"), outputXML.length());
        			outputXML.append(gen.writeValueOf("CSSession", String.valueOf(cssession)));
        			outputXML.append(gen.closeOutputFile("WFGetNextWorkitemforCaseSummary"));
        			mainCode = 0;
        		}
        	}
        	catch(SQLException e)
        	{
        		WFSUtil.printErr("", e);
        		mainCode = WFSError.WM_INVALID_FILTER;
        		subCode = WFSError.WFS_SQL;
        		subject = WFSErrorMsg.getMessage(mainCode);
        		errType = WFSError.WF_FAT;
        		if(e.getErrorCode() == 0) {
        			if(e.getSQLState().equalsIgnoreCase("08S01")) {
        				descr = (new JTSSQLError(e.getSQLState())).getMessage() + "(SQL State : " + e.getSQLState()+ ")";
        			}
        		}
        		else
        			descr = e.getMessage();
        	}
        	catch(NumberFormatException e) {
        		WFSUtil.printErr("", e);
        		mainCode = WFSError.WF_OPERATION_FAILED;
        		subCode = WFSError.WFS_ILP;
        		subject = WFSErrorMsg.getMessage(mainCode);
        		errType = WFSError.WF_TMP;
        		descr = e.toString();
        	} catch(NullPointerException e) {
        		WFSUtil.printErr("", e);
        		mainCode = WFSError.WF_OPERATION_FAILED;
        		subCode = WFSError.WFS_SYS;
        		subject = WFSErrorMsg.getMessage(mainCode);
        		errType = WFSError.WF_TMP;
        		descr = e.toString();
        	} catch(WFSException e) {
        		mainCode = WFSError.WM_NO_MORE_DATA;
        		subCode = 0;
        		subject = WFSErrorMsg.getMessage(mainCode);
        		errType = WFSError.WF_TMP;
        		descr = WFSErrorMsg.getMessage(subCode);
        	} catch(JTSException e) {
        		mainCode = WFSError.WF_OPERATION_FAILED;
        		subCode = e.getErrorCode();
        		subject = WFSErrorMsg.getMessage(mainCode);
        		errType = WFSError.WF_TMP;
        		descr = e.getMessage();
        	} catch(Exception e) {
        		WFSUtil.printErr("", e);
        		mainCode = WFSError.WF_OPERATION_FAILED;
        		subCode = WFSError.WFS_EXP;
        		subject = WFSErrorMsg.getMessage(mainCode);
        		errType = WFSError.WF_TMP;
        		descr = e.toString();
        	} catch(Error e) {
        		WFSUtil.printErr("", e);
        		mainCode = WFSError.WF_OPERATION_FAILED;
        		subCode = WFSError.WFS_EXP;
        		subject = WFSErrorMsg.getMessage(mainCode);
        		errType = WFSError.WF_TMP;
        		descr = e.toString();
        	} 
        	finally 
        	{
        		try
        		{
        			if (!con.getAutoCommit()) 
        			{
        				con.rollback();
        				con.setAutoCommit(true);
        			}
        			if (rs!= null){
        				rs.close();
        				rs = null;
        			}
        			// WFS_6.2_033.
        			if(pstmt != null) {
        				pstmt.close();
        				pstmt = null;
        			}
        		}
        		catch (Exception ignored) {}
        		
        	}
        	if(mainCode != 0) {
    			throw new WFSException(mainCode, subCode, errType, subject, descr);
    		}
        	return outputXML.toString();
        }
        
        
        
//        public String WFGetNextWorkitemforArchiveAudit(Connection con, XMLParser parser,XMLGenerator gen) throws JTSException, WFSException  
//	{
//		int mainCode = 0 ;
//		int subCode = 0;
//		StringBuffer outputXML = null;
//		StringBuffer tempXml = new StringBuffer(500);
//		PreparedStatement pstmt = null;
//		ResultSet rs = null;
//		String subject = null;
//		String descr = null;
//		String errType = WFSError.WF_TMP;
//		int cssession = 0 ;
//		try 
//		{
//			int sessionID = parser.getIntOf("SessionId", 0, false);
//			String engine = parser.getValueOf("EngineName");
//			String csName = parser.getValueOf("CSName");
//			StringBuffer queryBuff = new StringBuffer(100);
//			int dbType = ServerProperty.getReference().getDBType(engine);
//			WFParticipant participant = WFSUtil.WFCheckSession(con, sessionID);
//			if(participant != null && participant.gettype() == 'P') 
//			{
//				int userid = participant.getid();
//				String username = participant.getname();
//				if(csName != null && !csName.trim().equals(""))
//				{
//					pstmt = con.prepareStatement("Select SessionID from PSRegisterationTable where Type = 'C' AND PSName = ?");
//					WFSUtil.DB_SetString(1, csName.trim(), pstmt, dbType);
//					pstmt.execute();
//					rs = pstmt.getResultSet();
//					if(rs != null && rs.next())
//						cssession = rs.getInt(1);
//					if (rs != null) rs.close();
//					if(pstmt != null) {
//						pstmt.close();
//						pstmt = null;
//					}
//				}
//
//				queryBuff.append("Select ");
//				if (dbType==JTSConstant.JTS_MSSQL){
//					queryBuff.append("Top 1 ");
//				}
//				queryBuff.append(" * From WFAuditTrailDocTable where Status = ? and LockedBy =? ");
//				if (dbType==JTSConstant.JTS_ORACLE){
//					queryBuff.append(" and ROWNUM < 2 ");
//				}
//				pstmt =	con.prepareStatement(queryBuff.toString());
//				WFSUtil.DB_SetString(1, "L", pstmt, dbType);
//				WFSUtil.DB_SetString(2, username, pstmt, dbType);
//				pstmt.execute();
//				rs = pstmt.getResultSet();
//				if (rs != null && rs.next())
//				{
//					tempXml.append(gen.writeValueOf("ProcessDefId",rs.getString(1)));
//					tempXml.append(gen.writeValueOf("ProcessInstanceId",rs.getString(2)));
//					tempXml.append(gen.writeValueOf("WorkitemId", rs.getString(3)));
//					tempXml.append(gen.writeValueOf("ActivityId",rs.getString(4)));
//					tempXml.append(gen.writeValueOf("DocId",rs.getString(5)));
//					tempXml.append(gen.writeValueOf("ParentFolderIndex",rs.getString(6)));
//					tempXml.append(gen.writeValueOf("VolId",rs.getString(7)));
//					tempXml.append(gen.writeValueOf("AppServerIP",rs.getString(8)));
//					tempXml.append(gen.writeValueOf("AppServerPort",rs.getString(9)));
//					tempXml.append(gen.writeValueOf("AppServerType",rs.getString(10)));
//					tempXml.append(gen.writeValueOf("CabinetName",rs.getString(11)));
//                                        tempXml.append(gen.writeValueOf("DeleteAudit",rs.getString(12)));
//					pstmt.close();
//					rs.close();
//				}
//				else
//				{
//					if (con.getAutoCommit()) {
//						con.setAutoCommit(false);
//					}
//					queryBuff.setLength(0);
//					queryBuff.append("Select ");
//					if (dbType==JTSConstant.JTS_MSSQL){
//						queryBuff.append("Top 1 ");
//					}
//					String prefix = (dbType == JTSConstant.JTS_MSSQL) ? " (UPDLOCK) " : " ";
//						queryBuff.append("  * From WFAuditTrailDocTable "+prefix+" where Status = ? and LockedBy IS NULL ");
//					if (dbType==JTSConstant.JTS_ORACLE){
//						queryBuff.append(" and ROWNUM < 2 FOR UPDATE");
//					}
//                                        
//					pstmt.close();
//					rs.close();
//					pstmt =	con.prepareStatement(queryBuff.toString());
//					WFSUtil.DB_SetString(1, "R", pstmt, dbType);
//					pstmt.execute();
//					rs = pstmt.getResultSet();
//					if (rs != null && rs.next())
//					{
//						tempXml.append(gen.writeValueOf("ProcessDefId",rs.getString(1)));;
//						String processInstanceId = rs.getString(2);
//						tempXml.append(gen.writeValueOf("ProcessInstanceId",processInstanceId));
//						int workitemId = rs.getInt(3);
//						tempXml.append(gen.writeValueOf("WorkitemId", workitemId+""));
//						tempXml.append(gen.writeValueOf("ActivityId",rs.getString(4)));;
//						tempXml.append(gen.writeValueOf("DocId",rs.getString(5)));
//						tempXml.append(gen.writeValueOf("ParentFolderIndex",rs.getString(6)));
//						tempXml.append(gen.writeValueOf("VolId",rs.getString(7)));
//						tempXml.append(gen.writeValueOf("AppServerIP",rs.getString(8)));
//						tempXml.append(gen.writeValueOf("AppServerPort",rs.getString(9)));
//						tempXml.append(gen.writeValueOf("AppServerType",rs.getString(10)));
//						tempXml.append(gen.writeValueOf("CabinetName",rs.getString(11)));
//                        tempXml.append(gen.writeValueOf("DeleteAudit",rs.getString(12)));
//						pstmt.close();
//
//						pstmt = con.prepareStatement("Update WFAuditTrailDocTable set Status = ? , LockedBy = ? where ProcessInstanceId = ? and WorkitemId = ? ");
//						WFSUtil.DB_SetString(1, "L", pstmt, dbType);
//						WFSUtil.DB_SetString(2, username, pstmt, dbType);
//						WFSUtil.DB_SetString(3, processInstanceId, pstmt, dbType);
//						pstmt.setInt(4, workitemId);
//						int f = pstmt.executeUpdate();
//						if(f == 1) {
//							if (!con.getAutoCommit()) {
//								con.commit();
//								con.setAutoCommit(true);
//							}
//						}
//						else {
//							if(!con.getAutoCommit()) {
//								con.rollback();
//								con.setAutoCommit(true);
//								mainCode = WFSError.WF_OPERATION_FAILED;
//							}
//						}
//						if (rs!= null){
//							rs.close();
//							rs = null;
//						}
//						if (pstmt!= null){
//							pstmt.close();
//							pstmt = null;
//						}
//					}
//					else
//					{
//						mainCode = WFSError.WM_NO_MORE_DATA;
//					}
//				}
//			}
//			else 
//			{
//				mainCode = WFSError.WM_INVALID_SESSION_HANDLE;
//				subCode = 0;
//				subject = WFSErrorMsg.getMessage(mainCode);
//				descr = WFSErrorMsg.getMessage(subCode);
//				errType = WFSError.WF_TMP;
//			}
//			if(mainCode == 0) 
//			{
//				outputXML = new StringBuffer(500);
//				outputXML.append(gen.createOutputFile("WFGetNextWorkitemforArchiveAudit"));
//				outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
//				outputXML.append(gen.writeValueOf("CSSession", String.valueOf(cssession)));
//				outputXML.append(tempXml.toString());
//				outputXML.append(gen.closeOutputFile("WFGetNextWorkitemforArchiveAudit"));
//			}
//			if(mainCode == WFSError.WM_NO_MORE_DATA) 
//			{
//				outputXML = new StringBuffer(500);
//				outputXML.append(gen.writeError("WFGetNextWorkitemforArchiveAudit", WFSError.WM_NO_MORE_DATA, 0,
//				WFSError.WF_TMP, WFSErrorMsg.getMessage(WFSError.WM_NO_MORE_DATA), ""));
//				outputXML.delete(outputXML.indexOf("</" + "WFGetNextWorkitemforArchiveAudit" + "_Output>"), outputXML.length());
//				outputXML.append(gen.writeValueOf("CSSession", String.valueOf(cssession)));
//				outputXML.append(gen.closeOutputFile("WFGetNextWorkitemforArchiveAudit"));
//				mainCode = 0;
//			}
//		}
//		catch(SQLException e)
//		{
//			WFSUtil.printErr("", e);
//			mainCode = WFSError.WM_INVALID_FILTER;
//			subCode = WFSError.WFS_SQL;
//			subject = WFSErrorMsg.getMessage(mainCode);
//			errType = WFSError.WF_FAT;
//			if(e.getErrorCode() == 0) {
//			if(e.getSQLState().equalsIgnoreCase("08S01")) {
//				descr = (new JTSSQLError(e.getSQLState())).getMessage() + "(SQL State : " + e.getSQLState()+ ")";
//			}
//		}
//		else
//			descr = e.getMessage();
//		}
//		 catch(NumberFormatException e) {
//		  WFSUtil.printErr("", e);
//		  mainCode = WFSError.WF_OPERATION_FAILED;
//		  subCode = WFSError.WFS_ILP;
//		  subject = WFSErrorMsg.getMessage(mainCode);
//		  errType = WFSError.WF_TMP;
//		  descr = e.toString();
//		} catch(NullPointerException e) {
//		  WFSUtil.printErr("", e);
//		  mainCode = WFSError.WF_OPERATION_FAILED;
//		  subCode = WFSError.WFS_SYS;
//		  subject = WFSErrorMsg.getMessage(mainCode);
//		  errType = WFSError.WF_TMP;
//		  descr = e.toString();
//		} catch(WFSException e) {
//		  mainCode = WFSError.WM_NO_MORE_DATA;
//		  subCode = 0;
//		  subject = WFSErrorMsg.getMessage(mainCode);
//		  errType = WFSError.WF_TMP;
//		  descr = WFSErrorMsg.getMessage(subCode);
//		} catch(JTSException e) {
//		  mainCode = WFSError.WF_OPERATION_FAILED;
//		  subCode = e.getErrorCode();
//		  subject = WFSErrorMsg.getMessage(mainCode);
//		  errType = WFSError.WF_TMP;
//		  descr = e.getMessage();
//		} catch(Exception e) {
//		  WFSUtil.printErr("", e);
//		  mainCode = WFSError.WF_OPERATION_FAILED;
//		  subCode = WFSError.WFS_EXP;
//		  subject = WFSErrorMsg.getMessage(mainCode);
//		  errType = WFSError.WF_TMP;
//		  descr = e.toString();
//		} catch(Error e) {
//		  WFSUtil.printErr("", e);
//		  mainCode = WFSError.WF_OPERATION_FAILED;
//		  subCode = WFSError.WFS_EXP;
//		  subject = WFSErrorMsg.getMessage(mainCode);
//		  errType = WFSError.WF_TMP;
//		  descr = e.toString();
//		} 
//		finally 
//		{
//			try
//			{
//				if (!con.getAutoCommit()) 
//				{
//					con.rollback();
//					con.setAutoCommit(true);
//				}
//				if (rs!= null){
//					rs.close();
//					rs = null;
//				}
//				// WFS_6.2_033.
//				if(pstmt != null) {
//					pstmt.close();
//					pstmt = null;
//				}
//			}
//			catch (Exception ignored) {}
//			if(mainCode != 0) {
//			  throw new WFSException(mainCode, subCode, errType, subject, descr);
//			}
//		}
//		return outputXML.toString();
//	}
        
        
//        public String WFCompleteWorkitemforArchiveAudit(Connection con, XMLParser parser,XMLGenerator gen)  throws JTSException, WFSException 
//	{
//		int mainCode = 0 ;
//		int subCode = 0;
//		StringBuffer outputXML = null;
//		StringBuffer tempXml = new StringBuffer(500);
//		PreparedStatement pstmt = null;
//		ResultSet rs = null;
//		String subject = null;
//		String descr = null;
//		String errType = WFSError.WF_TMP;
//		int cssession = 0;
//		try 
//		{
//			int sessionID = parser.getIntOf("SessionId", 0, false);
//			String engine = parser.getValueOf("EngineName");
//			String csName = parser.getValueOf("CSName");
//			String processInstanceId = parser.getValueOf("ProcessInstanceId", "", false);
//			String successFlag = parser.getValueOf("SucessFlag", "", false);
//			int workitemId = parser.getIntOf("WorkitemId", 0, false);
//			int dbType = ServerProperty.getReference().getDBType(engine);
//			WFParticipant participant = WFSUtil.WFCheckSession(con, sessionID);
//			if(participant != null && participant.gettype() == 'P') 
//			{
//				int userid = participant.getid();
//				String username = participant.getname();
//				if (con.getAutoCommit()) {
//					con.setAutoCommit(false);
//				}
//
//				if(csName != null && !csName.trim().equals(""))
//				{
//					pstmt = con.prepareStatement("Select SessionID from PSRegisterationTable where Type = 'C' AND PSName = ?");
//					WFSUtil.DB_SetString(1, csName.trim(), pstmt, dbType);
//					pstmt.execute();
//					rs = pstmt.getResultSet();
//					if(rs != null && rs.next())
//						cssession = rs.getInt(1);
//					if (rs != null) rs.close();
//					if(pstmt != null) {
//						pstmt.close();
//						pstmt = null;
//					}
//				}
//				if(successFlag.equalsIgnoreCase("T")) // T - True(Success)
//				{
///*					pstmt = con.prepareStatement("Insert into WFAuditTrailDocHistory (ProcessDefId , ProcessInstanceId , WorkitemId , ActivityId, DocId , ParentFolderIndex , VolId ,Status ) Select  ProcessDefId , ProcessInstanceId , WorkitemId , ActivityId, DocId , ParentFolderIndex , VolId , 'S' from WFAuditTrailDocTable "
//					+ "where ProcessInstanceId = ? and  WorkitemId = ? ");
//					WFSUtil.DB_SetString(1, processInstanceId, pstmt, dbType);
//					pstmt.setInt(2, workitemId);
//					int res = pstmt.executeUpdate();
//					pstmt.close();
//					if(res >0)
//					{ */
//						pstmt = con.prepareStatement("Delete From WFAuditTrailDocTable "
//						+ "where ProcessInstanceId = ? and WorkitemId = ? ");
//						WFSUtil.DB_SetString(1, processInstanceId, pstmt, dbType);
//						pstmt.setInt(2, workitemId);
//						int f = pstmt.executeUpdate();
//						if(f > 0) {
//							if (!con.getAutoCommit()) {
//								con.commit();
//								con.setAutoCommit(true);
//							}
//						}
//						else {
//							if(!con.getAutoCommit()) {
//								con.rollback();
//								con.setAutoCommit(true);
//								mainCode = WFSError.WF_OPERATION_FAILED;
//							}
//						}
//           //                        }
//					
//	/*				else
//					{
//						if(!con.getAutoCommit()) {
//							con.rollback();
//							con.setAutoCommit(true);
//							mainCode = WFSError.WF_OPERATION_FAILED;
//						}
//					} */
//					pstmt.close();
//					pstmt = null;
//				}
//				else if(successFlag.equalsIgnoreCase("E")) // E -  Exception (In case Okb Doc is not added due to error)
//				{
//
//					pstmt = con.prepareStatement(" Delete from WFAuditTrailDocTable "
//					+ "where ProcessInstanceId = ? and  WorkitemId = ? ");
//					WFSUtil.DB_SetString(1, processInstanceId, pstmt, dbType);
//					pstmt.setInt(2, workitemId);
//					int rowCount = pstmt.executeUpdate();
//					if(rowCount>0)
//					{
//						if (!con.getAutoCommit()) {
//							con.commit();
//							con.setAutoCommit(true);
//						}
//					}
//					pstmt.close();
//					pstmt = null;
//				}
//				else // F - Fail (Not called as of now)
//				{
//					pstmt = con.prepareStatement("Update WFAuditTrailDocTable  Set Status = ?  , LockedBy = NULL "
//					+ " where ProcessInstanceId = ? and WorkitemId = ? ");
//					WFSUtil.DB_SetString(1, "F", pstmt, dbType);
//					WFSUtil.DB_SetString(2, processInstanceId, pstmt, dbType);
//					pstmt.setInt(3, workitemId);
//					int rowCount = pstmt.executeUpdate();
//					if(rowCount>0)
//					{
//						if (!con.getAutoCommit()) {
//							con.commit();
//							con.setAutoCommit(true);
//						}
//					}
//					pstmt.close();
//					pstmt = null;
//				}
//			}
//			else 
//			{
//				mainCode = WFSError.WM_INVALID_SESSION_HANDLE;
//				subCode = 0;
//				subject = WFSErrorMsg.getMessage(mainCode);
//				descr = WFSErrorMsg.getMessage(subCode);
//				errType = WFSError.WF_TMP;
//			}
//			if(mainCode == 0) 
//			{
//				outputXML = new StringBuffer(500);
//				outputXML.append(gen.createOutputFile("WFCompleteWorkitemforArchiveAudit"));
//				outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
//				outputXML.append(gen.writeValueOf("CSSession", String.valueOf(cssession)));
//				outputXML.append(gen.closeOutputFile("WFCompleteWorkitemforArchiveAudit"));
//			}
//		}
//		catch(SQLException e)
//		{
//			WFSUtil.printErr("", e);
//			mainCode = WFSError.WM_INVALID_FILTER;
//			subCode = WFSError.WFS_SQL;
//			subject = WFSErrorMsg.getMessage(mainCode);
//			errType = WFSError.WF_FAT;
//			if(e.getErrorCode() == 0) {
//			if(e.getSQLState().equalsIgnoreCase("08S01")) {
//				descr = (new JTSSQLError(e.getSQLState())).getMessage() + "(SQL State : " + e.getSQLState()+ ")";
//			}
//			}
//		else
//			descr = e.getMessage();
//		}
//		 catch(NumberFormatException e) {
//		  WFSUtil.printErr("", e);
//		  mainCode = WFSError.WF_OPERATION_FAILED;
//		  subCode = WFSError.WFS_ILP;
//		  subject = WFSErrorMsg.getMessage(mainCode);
//		  errType = WFSError.WF_TMP;
//		  descr = e.toString();
//		} catch(NullPointerException e) {
//		  WFSUtil.printErr("", e);
//		  mainCode = WFSError.WF_OPERATION_FAILED;
//		  subCode = WFSError.WFS_SYS;
//		  subject = WFSErrorMsg.getMessage(mainCode);
//		  errType = WFSError.WF_TMP;
//		  descr = e.toString();
//		} catch(WFSException e) {
//		  mainCode = WFSError.WM_NO_MORE_DATA;
//		  subCode = 0;
//		  subject = WFSErrorMsg.getMessage(mainCode);
//		  errType = WFSError.WF_TMP;
//		  descr = WFSErrorMsg.getMessage(subCode);
//		} catch(JTSException e) {
//		  mainCode = WFSError.WF_OPERATION_FAILED;
//		  subCode = e.getErrorCode();
//		  subject = WFSErrorMsg.getMessage(mainCode);
//		  errType = WFSError.WF_TMP;
//		  descr = e.getMessage();
//		} catch(Exception e) {
//		  WFSUtil.printErr("", e);
//		  mainCode = WFSError.WF_OPERATION_FAILED;
//		  subCode = WFSError.WFS_EXP;
//		  subject = WFSErrorMsg.getMessage(mainCode);
//		  errType = WFSError.WF_TMP;
//		  descr = e.toString();
//		} catch(Error e) {
//		  WFSUtil.printErr("", e);
//		  mainCode = WFSError.WF_OPERATION_FAILED;
//		  subCode = WFSError.WFS_EXP;
//		  subject = WFSErrorMsg.getMessage(mainCode);
//		  errType = WFSError.WF_TMP;
//		  descr = e.toString();
//		} 
//		finally 
//		{
//			try {
//				if (!con.getAutoCommit()) {
//					con.rollback();
//					con.setAutoCommit(true);
//				}
//			}
//			catch (Exception ignored) {}
//			try {
//				if(rs != null) {
//				  rs.close();
//				  rs = null;
//				}
//				if(pstmt != null) {
//					pstmt.close();
//					pstmt = null;
//				}
//			} catch(Exception e) {}
//			if(mainCode != 0) {
//			  throw new WFSException(mainCode, subCode, errType, subject, descr);
//			}
//		}
//		return outputXML.toString();
//	}
        

        
        public String WFGetSystemVariableList(Connection con, XMLParser parser, XMLGenerator gen) throws JTSException, WFSException {
            
            
        	StringBuffer outputXML = new StringBuffer("");
		PreparedStatement pstmt = null;
                ResultSet rs = null;
                StringBuffer tempXml = new StringBuffer(500);
		int mainCode = 0;
		int subCode = 0;
		String subject = null;
		String descr = null;
		String errType = WFSError.WF_TMP;
                String engine = null;
                
                try{
                    int sessionID = 0;
                    WFParticipant participant = null;
                    int dbType = ServerProperty.getReference().getDBType(parser.getValueOf("EngineName"));                   
		    sessionID = parser.getIntOf("SessionId", 0, false);
                    engine = parser.getValueOf("EngineName");
		    participant = WFSUtil.WFCheckSession(con, sessionID);
                    
                    if (participant != null){
                        pstmt = con.prepareStatement("select distinct(systemdefinedname), variableid, variabletype, variablescope "
                                + "from varmappingtable where "
                                + "extobjid=0 order by variableid");
                        rs = pstmt.executeQuery();
                        tempXml.append("<VarList>\n");
                        int rel = 0;
                        while (rs.next()) {
                            String systemDefinedName = rs.getString(1);
                            if (systemDefinedName.equalsIgnoreCase("VAR_REC_1") || systemDefinedName.equalsIgnoreCase("VAR_REC_2")
                                    || systemDefinedName.equalsIgnoreCase("VAR_REC_3")|| systemDefinedName.equalsIgnoreCase("VAR_REC_4")
                                    || systemDefinedName.equalsIgnoreCase("VAR_REC_5")) {
                                continue;
                            }
                            rel++;
                            tempXml.append("<VarInfo>\n");
                            tempXml.append(gen.writeValueOf("SystemDefinedName", systemDefinedName));
                            tempXml.append(gen.writeValueOf("VariableId", rs.getString(2)));
                            tempXml.append(gen.writeValueOf("VariableType", rs.getString(3)));
                            tempXml.append(gen.writeValueOf("VariableScope", rs.getString(4)));
                            int orderid = Integer.parseInt(rs.getString(2));
                            orderid = orderid+100;
                            tempXml.append(gen.writeValueOf("OrderId", String.valueOf(orderid)));
                            tempXml.append("</VarInfo>\n");
                        }
                        tempXml.append("</VarList>\n");
                        
                        if (rel == 0) {
					mainCode = WFSError.WM_NO_MORE_DATA;
					subCode = 0;
					subject = WFSErrorMsg.getMessage(mainCode);
					descr = WFSErrorMsg.getMessage(subCode);
					errType = WFSError.WF_TMP;
				}
                    }
                    else {
				mainCode = WFSError.WM_INVALID_SESSION_HANDLE;
				subCode = 0;
				subject = WFSErrorMsg.getMessage(mainCode);
				descr = WFSErrorMsg.getMessage(subCode);
				errType = WFSError.WF_TMP;
			}
                    if (mainCode == 0) {
				outputXML = new StringBuffer(500);
				outputXML.append(gen.createOutputFile("WFGetSystemVariableList"));
				outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
				outputXML.append(tempXml);
				outputXML.append(gen.closeOutputFile("WFGetSystemVariableList"));
			}
			
                }
                catch (SQLException e) {
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
			subject = e.getErrorMessage();
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
			try{
				if(rs!=null){
					rs.close();
					rs=null;
				}
			}catch(Exception e){
				WFSUtil.printErr(engine,"", e);
			}
			try {
				if (pstmt != null) {
					pstmt.close();
					pstmt = null;
				}
			} catch (Exception e) {
				WFSUtil.printErr(engine,"", e);
			}
			
		}
		if (mainCode != 0) {
			throw new WFSException(mainCode, subCode, errType, subject, descr);
		}
		return outputXML.toString();
            
        }

/**
 * This API will return the list of All the variables and variables details after applying the filters
 * @param con
 * @param parser
 * @param gen
 * @return
 * @throws JTSException
 * @throws WFSException
 * @author ambuj.tripathi
 */
	public String WFGetProcessVariablesList(Connection con, XMLParser parser, XMLGenerator gen) throws JTSException, WFSException {
		StringBuffer outputXML = new StringBuffer("");
		String engine = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int mainCode = 0;
		int subCode = 0;
		String subject = null;
		String descr = null;
		String errType = WFSError.WF_TMP;
		StringBuilder query = new StringBuilder();
		try {
			int sessionID = parser.getIntOf("SessionId", 0, false);
			engine = parser.getValueOf("EngineName", "", false);
			int dbType = ServerProperty.getReference().getDBType(engine);
			WFParticipant participant = WFSUtil.WFCheckSession(con, sessionID);
			if (participant != null) {
				if (con.getAutoCommit()) {
					con.setAutoCommit(false);
				}

				int processDefId = parser.getIntOf("ProcessDefId", 0, false);
				int activityId = parser.getIntOf("ActivityId", 0, false);
				String variableScopeStr = parser.getValueOf("VariableScope", "A", true);
				String varDataTypeStr = parser.getValueOf("VariableDataType", "0", true);
				int retrievedCount = 0;
				
				//Get the list of variables that have access to the given activity
				List<Integer> variableAccessList = new ArrayList<Integer>();
				pstmt = con.prepareStatement("select variableId from ActivityAssociationTable " + WFSUtil.getTableLockHintStr(dbType)
						+ " where processdefid = ? and activityid = ? and DefinitionType IN ('Q','I') and Attribute in ('O','M','R')");
				pstmt.setInt(1, processDefId);
				pstmt.setInt(2, activityId);
				rs = pstmt.executeQuery();
				while(rs.next()){
					int procdefid = rs.getInt(1);
					variableAccessList.add(procdefid);
				}
				
				//Get the list of variables that are defined for the given process
				outputXML = new StringBuffer();
				outputXML.append(gen.createOutputFile("WFGetProcessVariablesList"));
				outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>");
				outputXML.append("<Attributes>");
				StringBuilder filterString = new StringBuilder();
				
				if(variableScopeStr.equalsIgnoreCase("A")){
					filterString.append("");
				}else{
					filterString.append(" and variableScope IN ('" + variableScopeStr.replaceAll(",", "','") + "') ");
				}
				
				if(varDataTypeStr.equalsIgnoreCase("0")){
					filterString.append("");
				}else{
					filterString.append(" and variableType IN (" + varDataTypeStr + ") ");
				}
				
				pstmt = con.prepareStatement("select VariableId,UserDefinedName,VariableType,VariableScope,ExtObjId from varmappingtable"
						+ WFSUtil.getTableLockHintStr(dbType) + " where processdefid = ? and userdefinedname is not null and systemdefinedname not "
						+ "in ('VAR_REC_1','VAR_REC_2','VAR_REC_3','VAR_REC_4','VAR_REC_5') " + filterString.toString());
				pstmt.setInt(1, processDefId);
				rs = pstmt.executeQuery();
				while(rs.next()){
					int varId = rs.getInt("VariableId");
					String varScope = rs.getString("VariableScope");
					//Check if its queue var or ext var and have correct rights
					if("I".equalsIgnoreCase(varScope) || "U".equalsIgnoreCase(varScope)){
						if(variableAccessList.contains(varId)){
							retrievedCount++;
							outputXML.append("<Attribute>");
							outputXML.append("<Name>" + rs.getString("UserDefinedName") + "</Name>");
							outputXML.append("<VariableId>" + varId + "</VariableId>");
							outputXML.append("<VariableType>" + rs.getString("VariableType") + "</VariableType>");
							outputXML.append("<VariableScope>" + varScope + "</VariableScope>");
							outputXML.append("<ExtObjId>" + rs.getString("ExtObjId") + "</ExtObjId>");
							outputXML.append("</Attribute>");
						}
					}else{
						retrievedCount++;
						outputXML.append("<Attribute>");
						outputXML.append("<Name>" + rs.getString("UserDefinedName") + "</Name>");
						outputXML.append("<VariableId>" + varId + "</VariableId>");
						outputXML.append("<VariableType>" + rs.getString("VariableType") + "</VariableType>");
						outputXML.append("<VariableScope>" + varScope + "</VariableScope>");
						outputXML.append("<ExtObjId>" + rs.getString("ExtObjId") + "</ExtObjId>");
						outputXML.append("</Attribute>");					}
				}
				if (rs != null) {
					rs.close();
					rs = null;
				}
				if (pstmt != null) {
					pstmt.close();
					pstmt = null;
				}
				outputXML.append("</Attributes>");
				outputXML.append("<RetrievedCount>" + retrievedCount + "</RetrievedCount>");
				outputXML.append(gen.closeOutputFile("WFGetProcessVariablesList"));
			} else {
				mainCode = WFSError.WM_INVALID_SESSION_HANDLE;
				subCode = 0;
				subject = WFSErrorMsg.getMessage(mainCode);
				descr = WFSErrorMsg.getMessage(subCode);
				errType = WFSError.WF_TMP;
			}
			if(mainCode == 0){
                con.commit();
                con.setAutoCommit(true);
			}
		} catch (SQLException e) {
			WFSUtil.printErr(engine, "", e);
			mainCode = WFSError.WM_INVALID_FILTER;
			subCode = WFSError.WFS_SQL;
			subject = WFSErrorMsg.getMessage(mainCode);
			errType = WFSError.WF_FAT;
			descr = e.getMessage();
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
			try{
				if(rs!=null){
					rs.close();
					rs=null;
				}
			}catch(Exception e){
				WFSUtil.printErr(engine,"", e);
			}
			try {
				if (pstmt != null) {
					pstmt.close();
					pstmt = null;
				}
			} catch (Exception ignored) {
				WFSUtil.printErr(engine,"", ignored);
			}
			
		}
		if (mainCode != 0) {
			throw new WFSException(mainCode, subCode, errType, subject, descr);
		}
		return outputXML.toString();
	}
	
	
	public static String TO_STRING(String in, boolean isConst, int dbType) {
        StringBuffer outputXml = new StringBuffer(100);
        if (in == null || in.equals("")) {
            outputXml.append(" NULL ");
        } else {
            switch (dbType) {
                case JTSConstant.JTS_MSSQL: {
                    /** Bugzilla Bug 1241, 1242, Refer ReAssign not working in MSSQL 2005 + Japanese N'XXX's MyQueue'
                     * does not work in MSSQL2005 (other than English, case reported for Japanese) - Ruhi Hira */
                    /** Bugzilla Bug 1705, startsWith, endsWith removed. - Ruhi Hira */
                    if (isConst) {
                        outputXml.append(WFSConstant.WF_VARCHARPREFIX);
                        outputXml.append(replace(in, "'", "' + char(39) + N'"));
                        outputXml.append("'");
                    } else {
                        outputXml.append(replace(in, "'", "''"));
                    }
                    break;
                }
                case JTSConstant.JTS_ORACLE: {
                    if (isConst) {
                        outputXml.append(WFSConstant.WF_VARCHARPREFIX);
                        outputXml.append(replace(in, "'", "''"));
                        outputXml.append("'");
                    } else {
                        outputXml.append("UPPER(RTRIM(");
                        outputXml.append(replace(in, "'", "''"));
                        outputXml.append(") )");
                    }
                    break;
                }
                case JTSConstant.JTS_POSTGRES: {
                    if (isConst) {
                        //outputXml.append(WFSConstant.WF_VARCHARPREFIX);
                        outputXml.append("'");
                        outputXml.append(replace(in, "'", "''"));
                        outputXml.append("'");
                    //outputXml.append(" :: VARCHAR ");
                    } else {
                        outputXml.append("UPPER( ");
                        outputXml.append(replace(in, "'", "''"));
                        outputXml.append(" )");
                    }
                    break;
                }
                case JTSConstant.JTS_DB2: {
                    /** Bugzilla Id 68, Aug 16th 2006, N'XXX's MyQueue' does not work - Ruhi Hira */
                    if (isConst) {
                        outputXml.append(WFSConstant.WF_VARCHARPREFIX);
                        outputXml.append(replace(in, "'", "' || chr(39) || '"));
                        outputXml.append("'");
                    } else {
                        outputXml.append("UPPER(RTRIM(");
                        outputXml.append(replace(in, "'", "''"));
                        outputXml.append(") )");
                    }
                    break;
                }
            }
        } 
        	if(isConst)
        	{
        		return outputXml.toString();
        	}
        	else
        	{
        		return outputXml.toString().replaceAll("''", "'");
        	}
    }
	
    public static String replace(String in, String src, String dest) {
        // Bug # WFS_6_009, causing NullPointerException if input is null....
        if (in == null || src == null) {
            return in;
        }
        int offset = 0;
        int startindex = 0;
        int srcLen = src.length();
        StringBuffer strBuf = new StringBuffer();
        do {
            try {
                startindex = in.indexOf(src, offset);
                strBuf.append(in.substring(offset, startindex));
                strBuf.append(dest);
                offset = startindex + srcLen;
            } catch (StringIndexOutOfBoundsException e) {
                break;
            }
        } while (startindex >= 0);
        strBuf.append(in.substring(offset));
        return strBuf.toString();
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
			
		
			
} // class WMInstrument

