/* ----------------------------------------------------------------------------------
NEWGEN SOFTWARE TECHNOLOGIES LIMITED
Group				: Application - Products
Product / Project	: WorkFlow
Module				: Transaction Server
File Name			: WFSConstant.java
Author				: Prashant
Date written		: 29/05/2002
Description			: Defines the constants used by the Transaction Server.
-----------------------------------------------------------------------------------
CHANGE HISTORY
-----------------------------------------------------------------------------------
Date				Change By		Change Description (Bug No. If Any)
24/09/2002			Prashant		New constants added
24/02/2005			Ruhi Hira		SrNo-1.
25/05/2005			Ruhi Hira		SrNo-2.
25/05/2005			Ashish Mangla	Changes for automatic cache updation
18/08/2005			Ruhi Hira		SrNo-3.
28/09/2005			Ruhi Hira		SrNo-4.
01/09/2005         Virochan        SrNo-5
27/12/2005			Harmeet Kaur	Audit Log Configuration SrNo-6.
02/01/2006			Virochan		SrNo-7
02/01/2006			Virochan		SrNo-8
03/01/2005			Ashish Mangha	SrNo-9
09/01/2005			Harmeet Kaur	SrNo-10
19/01/2006			Harmeet Kaur	SrNo-11  Bug WFS_6.1.2_037
05/11/2006			Ashish Mangla	Bugzilla Bug 285 (New Action Id for "QueryFilter changed")
05/01/2007			Varun Bhansaly	Bugzilla Bug 370
22/01/2007			Ahsan Javed		Added for WFCalCache.
12/05/2007         Ruhi Hira       Bugzilla Bug 687, Bugzilla Bug 357.
19/07/2007         Ruhi Hira       Bugzilla Bug 1492.
17/08/2007			Ruhi Hira	    SrNo-12, Synchronous routing of workitems.
12/09/2007			Varun Bhansaly	SrNo-13, Comments in Refer\ Reassign\ Audit Reject.
03/10/2007			Varun Bhansaly	SrNo-14, Configuration File Names and Directory Names.
10/10/2007			Varun BhansaLY	SrNo-15, log4j configuration File Names & Directory Names.
10/10/2007			Harmeet Kaur    Bugzilla Bug 1695(New Action ID for change of QueueName and processname)
19/11/2007         Shilpi S        SrNo-16, new Action ID and Activity ID for WorkitemExported
13/12/2007         Shilpi S        SrNo-17, new Constant added for Synchronous Routing Mode
19/12/2007			Tirupati Srivastava   work for ActionId for Setting quicksearchVariable
15/01/2008			Vikram Kumbhar	Bugzilla Bug 2774 Maker Checker Functionality
24/04/2008			Vikram Kumbhar	WFS_6.2_013 Search on process variables and order of Column Display in Search Result.
Case: Variables having read only rights not coming in search result.
19/05/2008         Varun Bhansaly  SrNo-18, Id for WF_Boolean & WF_ANY.
30/04/2008			Shweta Tyagi	SrNo-19, changes for new complex type cache
26/05/2008			Shweta Tyagi	SrNo-20, changes for fixed Variable Ids for system variables
14/08/2008         Varun Bhansaly  SrNo-21, constants for default float precision + length
19/08/2008         Varun Bhansaly  Bugzilla Id 6040, BPEL ? WSDL files currently being thrown in CWD
31/10/2008			Shweta Tyagi	Added Duration Data Type
26/11/2008         Shweta Tyagi    SrNo-22 , Constants for HTTPProtocolName,HTTPIP,HTTPPort Added
19/12/2008         Shilpi S        SrNo-23, Entry for activity info cache 
22/01/2009			Ashish Mangla	Bugzilla Bug 7643 (Duplicate ActionId used)
01/04/2009         Shweta Tyagi    SrNo-24, Entry for activity type SAPAdapter
01/07/2009			Ashish Mangla	constants for audting of checkout/checkin/undocheckout (other document operations)
01/07/2009         Abhishek Gupta           Support for nText  Bug Id  WFS_8.0_014
14/08/2009         Saurabh Kamal	New constants entry for Exception with Raise and Response
20/08/2009         Minakshi Sharma  SrNo-25   New Constant added for  SAP License Key File Name
25/08/2009         Saurabh Kamal	New Constant added for Response type Action
27/08/2009         Shilpi Srivastava    WFS_8.0_026, SrNo-26, Workitem Based Calendar Support
07/10/09		   Indraneel			WFS_8.0_039	Support for Personal Name along with username in fetching worklist,workitem history, setting reminder,refer/reassign workitem and search.
14/10/09		   Ashish Mangla	WFS_8.0_044 TurnAroundTime support in FetchWorklist and SearchWorkitem
22/10/09		   Saurabh Kamal	WFS_8.0_045, New Constant added for auditing of  Add Calendar
14/04/2010			Indraneel		WFS_8.0_097, New Constant added for auditing of  Delete Calendar
06/08/2010			Ashish Mangla	Support of ondexing documents at the time of upload (Caching of dataclass/global indexes is done)
27/08/2010          Vikas Saraswat  WFS_8.0_127 Configuring Threshold logs for execution time and size of APIs.
10/03/2011			Abhishek Gupta	Audit type rule support
12/02/2011			Prateek Verma	Constant added for log4jConfig.xml
14/08/2012			Abhishek Gupta  Bug 33212 - there in no action is performed on "commit" & " initiate" operation.
31/01/2013          Neeraj Sharma   Bug 38164 - CreatedDateTime tag was missing in the output of WFgetworkitemDataExt call.
17/05/2013			Shweta Singhal	Constant Added for Process Variant Support
25/06/2013          Shweta Singhal  Constant defined for unregister right on Project ObjectType
02/07/2013    		Mohnish Chopra  Bug 40367  -"CACHE_CONST_VARIABLE_HISTORY" Constant defined. 
29/07/2013			Sajid Khan		Entry for CONST_IMAGEUPGRADE made.
04/09/2013			Shweta Singhal	ActionId added for logging of Process Variant
31/12/2013			Kahkeshan		Changes for Code Optimization
11/02/2014		   Anwar Danish	    New constant added for BusinessRuleExecutor
25/02/2014                  Sajid Khan      NGLogger implementation.
23/06/2014         Kanika Manik        PRD Bug 42691 - Mails to be triggered in case of Refer,Reassign and SetDiversion based upon the NotifyByEmail flag value which is to be read from WFAppContext.xml.
 24/06/2014        Anwar Danish      PRD Bug 45001 merged - Add new action ids, handle also at front end configuration screen and history generation functionality.
09-07-2014		   Sajid Khan		 ActinId  122 addded for OjectTypeSet .
 11/07/2014		   Mohnish Chopra	Added constants CONST_TIMER_SERVICE_LOOKUP_PREFIX and CONST_TIMER_SERVICE_LOOKUP_SUFFIX for Timer Service look up in JBossEAP
 12/05/2015		   Mohnish Chopra	ActivityType 32 added for Case Workstep
 14-08-2015		   RishiRam Meel    Added constant String CONST_ORM_MODULE = "orm_server" to generate  ORM Server logs in separate folder .
 22-12-2015		   Kirti Wadhwa     Added Constant  WFL_TaskDiverted to handle  diversion of tasks along with workitems.  
 28/07/2015		   Sweta Bansal		Bug 56062 - Handling done to use WFUploadWorkitem API for creating workitem in SubProcess(Subprocess/Exit) and to perform operation like: workitem creation in subprocess, Bring ParentWorkitem in flow when child routed to exit, will be performed before CreateWorkitem.
10/03/2017                 Sajid Khan             Bug 67568 - Deletion of Audit Logs after audit trail archieve.
13/04/2017		  	Kumar Kimil       Bug 66398 - Support of WFChangeWorkItemPriority API to get the Priority Level audting when Workitem priority is changed
17/04/2017			Kumar Kimil		Bug 66718 - Handling of the errorneous cases in the WMCreateWorkItem API to suspend the workitem and also to print the Query execution time to fetch and set queue and external variables
18/04/2016          Kumar Kimil     Bug 64096 - Support to send the notification by Email when workitem is abnormally suspended due to some error
20/04/2017        Kumar Kimil			Bug 58408-Logging for diversion missing for the current workitems assigned to a user for whom diversion is being set.
20/04/2017        Kumar Kimil			Bug 60184-Entry missing in WFSString.properties from ActionId = 123[Diverstion Rollback workitem ]
20/04/2017        Kumar Kimil			Bug 66056-Support to send the Mail Notification when user diversion is set or removed
19/04/2017		  Rakesh K Saini   Bug 66398 - Support of WFChangeWorkItemPriority API to get the Priority Level audting when Workitem priority is changed 
09/05/2017		  Rakesh K Saini	Bug 56761 - Seperating configuration data and Application parameters from WFAppContext.xml file by dividing the file into two files. 1. WFAppContext.xml 2. WFAppConfigParam.xml
07/04/2017        Kumar Kimil       Multiple precondition support for Task
4/07/2017		  Shubhankur Manuja	Added new constants to support WFDeclineTask API.
06/07/2017		  Ambuj Tripathi		Added new constants to support WFReassignTask API.
18/07/2017        Kumar Kimil     Multiple Precondition enhancement
09/08/2017  	  Ambuj Tripathi  Added the ActionID for the task escalation feature for Case Management
11/08/2017 		  Mohnish Chopra	Changes for Case Summary document generation requirement
18/08/2017 		  Ambuj Tripathi	Added as the review point for the Task Reassignment and Task Expiry features in Case Management
19/08/2017        Kumar Kimil       Process Task Changes(Synchronous and Asynchronous)
28/08/2017        Ambuj Tripathi       Added constants for the UserGroups feature
05/10/2017        Ambuj Tripathi	Added comment type for RevokeTask       
08/12/2017		  Mohnish Chopra	Prdp Bug 71731 - Audit log generation for change/set user preferences
12/12/2017		  Sajid Khan		Bug 73913 - Rest Ful webservices implementation in iBPS
22/12/2017		  Mohnish Chopra	Changes for LikeSearchEnabled Configuration for Case Basket
05/09/2018		  Mohnish Chopra	Bug 80086 - iBPS 4:Provision to call Revoke and Reassign APi's on expiry of task based on some ini.
17/04/2019        Shubham Singla    Bug 83717 - Support is required to move/save external variables and complex variables data to Secondary cabinet based on some flag SecondaryDBFlag
13/05/2019		  Ravi Ranjan Kumar Bug 84500 - Support of URN as system variable is required
01/04/2019	   	  Mohnish Chopra	Bug 83717 - Support is required to move/save external variables and complex variables data to Secondary cabinet based on some flag SecondaryDBFlag
20/12/2019		  Ambuj Tripathi	Changes for DataExchange Functionality
27/12/2019		Ravi Ranjan Kumar		Bug 89374 - Support for Global Webservice and external method 
01/03/2019		Ambuj Tripathi		Changes for returning the rights string in Criteria List API.
13/01/2020	Ravi Ranjan Kumar	Bug 89950 - Support for Multilingual in Criteria Name, Filter Name and display Name
//27/01/2020	Ravi Ranjan Kumar	Bug 89872 - Unable to delete multiple objects getting Blank error message.
//13/02/2020    Ravi Raj Mewara     Bug 89872 - Unable to delete multiple objects getting Blank error message. 
//27/01/2020					Ambuj Tripathi		Rights Migration changes for migrating the users/groups/associations from XLS file.
//06/04/2020     Ravi Ranjan Kumar   PRDP Bug Merging -Bug 87085 - Handling for new Admin action id 508,509,510 in Audit log report
//16/04/2020    Chitranshi Nitharia Bug 91524 - Framework to manage custom utility via ofservices
//14/05/2020		Ravi Ranjan Kumar	Bug 92380 - Right Migration : Need to move Group ,Profile and their Rights and queue Association from source to destination environment for specific process 
//29/01/2020      Sourabh Tantuway    Bug 93812 - iBPS 5.0 SP1: Requirement for get SAP user credentials based on process variable value. This mapped variable will contain the username of the user, whose details are to be fetched
//14/08/2020	Ravi Ranjan Kumar	Bug 94098 - When any API returning mainCode not zero or throwing the error than call the POST HOOK method on basis of ini flag 
//22/01/2021      Satyanarayan Sharma     Handling of new actionId for Purging workitem in process.
//01/04/2021   Shubham Singla        Bug 98964 - iBPS 5.0 :Requirement to adhoc route distributed workitems based on configuration.
//28/06/2021		Aqsa hashmi			 Bug 100024 - WorkflowReport tag is not required in WFAppConfigParam.xml as it is no more used by BAM 
//24/03/2022 		Rishabh Jain 		Support of addition of documentype in the registered process
//26/09/2022  Satyanarayan Sharma Bug 116153 - iBPS4.0SP1-Requirement to make use of WFWebServiceUtilAxis1 class in Soap Webservice.
-------------------------------------------------------------------------------- */
package com.newgen.omni.jts.constt;
import java.util.regex.*;

public interface WFSConstant {

// FilterType Constants
    int WF_LEFT = 1;
    int WF_RIGHT = 2;
    int WF_EQUI = 3;
    int WF_FULL = 4;
    String WF_DATEFMT = " 'YYYY-MM-DD HH24:MI:SS' ";
    String WF_SHORT_DATEFMT = " 'YYYY-MM-DD' ";
    String WF_DELMT = "-";
    String Underscore = "_";
    int WF_STRBUF = 200;

    //Cache Constants
    String CACHE_CONST_Archive = "com.newgen.omni.jts.cache.WFArchive";
    String CACHE_CONST_TodoList = "com.newgen.omni.jts.cache.WFTodoList";
    String CACHE_CONST_Attribute = "com.newgen.omni.jts.cache.WFAttributeCache";	//SrNo-19

    String CACHE_CONST_Variable = "com.newgen.omni.jts.cache.WFVariableCache";
    String CACHE_CONST_VARIABLE_HISTORY= "com.newgen.omni.jts.cache.WFVariableCacheHistory";
    String CACHE_CONST_Trigger = "com.newgen.omni.jts.cache.WFTrigger";
    String CACHE_CONST_DocumentDefinition = "com.newgen.omni.jts.cache.WFDocumentDefinition";
    String CACHE_CONST_PrintFaxEmail = "com.newgen.omni.jts.cache.WFPrintFaxEmail";
    String CACHE_CONST_CabinetPropertyCache = "com.newgen.omni.jts.cache.WFCabinetPropertyCache";
    String CACHE_CONST_ActionCache = "com.newgen.omni.jts.cache.WFActionCache"; //SrNo-6

    String CACHE_CONST_CalCache = "com.newgen.omni.jts.cache.WFCalCache";
	String CACHE_CONST_CalNameCache = "com.newgen.omni.jts.cache.WFCalNameCache";
    String CACHE_CONST_WFDuration = "com.newgen.omni.jts.cache.WFDurationCache";
    String CACHE_CONST_WFActivity = "com.newgen.omni.jts.cache.WFActivityCache";
	String CACHE_CONST_UserCache = "com.newgen.omni.jts.cache.WFUserCache";	 /*WFS_8.0_039*/
	String CACHE_CONST_DataClassCache = "com.newgen.omni.jts.cache.WFDataClassCache";	 /* Support of indexing documents */
    String CACHE_CONST_RuleCache = "com.newgen.omni.jts.cache.WFRuleCache";
    String CACHE_CONST_SAPCache = "com.newgen.omni.jts.cache.WFSAPCache";

    // External Interface package
    String EXT_INT_PACKAGE = "com.newgen.omni.jts.externalInterfaces";
    String EXT_INT_EXCEPTION_NAME = "Exceptions";
    String EXT_INT_DOCUMENT_NAME = "Document";
    String EXT_INT_TODOLIST_NAME = "ToDoList";
    String EXT_INT_ACTION_NAME = "Action";
    String EXT_INT_FORM_NAME = "FormView";
    String EXT_INT_PRINTFAXMAIL_NAME = "PrintFaxEmail";
    String EXT_INT_ARCHIVE_NAME = "Archive";
    String EXT_INT_SCANTOOL_NAME = "ScanTool";
    String EXT_INT_SAPGUIADAPTER_NAME = "SAPGUIAdapter";
    String EXT_INT_FORMEXT_NAME = "FormExtView";
    String EXT_INT_TASK_NAME = "Task";

    String EXT_INT_EXCEPTION_CLASS = "com.newgen.omni.jts.externalInterfaces.WFExceptionClass";
    String EXT_INT_DOCUMENT_CLASS = "com.newgen.omni.jts.externalInterfaces.WFDocumentTypeClass";
    String EXT_INT_TODOLIST_CLASS = "com.newgen.omni.jts.externalInterfaces.WFToDoListClass";
    String EXT_INT_ACTION_CLASS = "com.newgen.omni.jts.externalInterfaces.WFActionClass";
    String EXT_INT_FORM_CLASS = "com.newgen.omni.jts.externalInterfaces.WFFormClass";
    String EXT_INT_PRINTFAXMAIL_CLASS = "com.newgen.omni.jts.externalInterfaces.WFPrintFaxEmailClass";
    String EXT_INT_ARCHIVE_CLASS = "com.newgen.omni.jts.externalInterfaces.WFArchiveClass";
    String EXT_INT_SCANTOOL_CLASS = "";
    String EXT_INT_SAPGUIADAPTER_CLASS = "com.newgen.omni.jts.externalInterfaces.SAPGUIAdapterClass";
    String INTERFACE_TYPE_TODO = "T";
	String CONST_IMAGEUPGRADE = "ImageDataUpgrade.xml";
    String EXT_INT_FORMEXT_CLASS = "com.newgen.omni.jts.externalInterfaces.WFFormExtClass";
    String EXT_INT_TASK_CLASS = "com.newgen.omni.jts.externalInterfaces.WFTaskClass";

    /*122 ActionId is already being used in IBPS for WFL_ObjecTypePropertySet*/
    int WFL_AssignBackDivertedWorkitem = 123; /*ActionId used by Expiry Utility and WFSetDiversionForUser API for Assigning Back WorkItem to Original User in case Diversion Period gets Over*/
	
// FilterType Constants
    int WF_INT = 3;
    int WF_LONG = 4;
    int WF_FLT = 6;
    int WF_DAT = 8;
    int WF_STR = 10;
    int WF_COMPLEX = 11;
    int WF_BOOLEAN = 12;
    int WF_ANY = 14;
    int WF_SHORT_DAT = 15;
    int WF_TIME = 16;
    int WF_DURATION = 17;//Duration Support
    int WF_SQL = 256;
    int WF_NTEXT = 18;  //nText support Bug Id WFS_8.0_014
	public static final int WF_DEFAULT_VAR_LENGTH = 255;

//Constants indicating the ActivityTypes
    int ACT_INTRODUCTION = 1;
    int ACT_EXT = 2;
    int ACT_DISCARD = 3;
    int ACT_HOLD = 4;
    int ACT_DISTRIBUTE = 5;
    int ACT_COLLECT = 6;
    int ACT_RULE = 7;
    int ACT_QUERY = 11; //  int ACT_QUERY = 8;	SrNo-9

    int ACT_CUSTOM = 10;
//  int ACT_EXPIRY = 11;	//	SrNo-9
    int ACT_SUBPROC = 18;
    int ACT_JMSPUBLISHER = 19;
    int ACT_EXPORT = 20; //SrNo-16

    int ACT_JMSSUBSCRIBER = 21;
    int ACT_WEBSERVICEINVOKER = 22;
    int ACT_JMSRESPONSECONSUMER = 23;
    int ACT_SOAPREQUESTCONSUMER = 24;
    int ACT_SOAPRESPONSECONSUMER = 25;
    int ACT_SOAPREPLY = 26;
    int ACT_ONMESSAGE = 27;
    int ACT_ONALARM = 28;
    int ACT_SAPADAPTER = 29;//
	int ACT_BUSINESSRULEEXECUTOR = 31;
        int ACT_RESTSERVICEINVOKE = 40;
	int ACT_CASE=32;
	int ACT_OMSADAPTER=33;
	int ACT_DATAEXCHANGE=34;
	
// Constants specifying values for ActionType in RuleActionTable
    int ACTION_SET = 1;
    int ACTION_INITIATE = 2;
    int ACTION_WAITAT = 3;
    int ACTION_ROUTETO = 4;
    int ACTION_RAISE = 5;
    int ACTION_CLEAR = 6;
    int ACTION_MERGE = 7;
    int ACTION_INCPRIORITY = 8;
    int ACTION_DECPRIORITY = 9;
    int ACTION_REINITIATE = 10;
    int ACTION_ARCHIVE = 12;
    int ACTION_SUBMIT = 13;
    int ACTION_RELEASE = 14;
    int ACTION_TRIGGER = 15;
	int ACTION_RESPONSE = 25;

// Constants specifying values for RouteLog
    int WFL_CreateProcessInstance = 1;
    int WFL_StartProcessInstance = 2;
    int WFL_ProcessInstanceDiscarded = 3;
    int WFL_ProcessInstanceRouted = 4;
    int WFL_ProcessInstanceAborted = 5;
    int WFL_ProcessInstanceDistributed = 6;
    int WFL_WorkItemLock = 7;
    int WFL_WorkItemUnlock = 8;
    int WFL_Exception_Raised = 9;
    int WFL_Exception_Cleared = 10;
    int WFL_Priority_Set = 13;
    int WFL_Priority_Decremented = 14;
    int WFL_ToDoItemStatus_Modified = 15;
    int WFL_Attribute_Set = 16;
    int WFL_WorkItemReassigned = 17;
    int WFL_DocumentTypeAdded = 18;
    int WFL_DocumentTypeAnnotated = 19;
    int WFL_ProcessInstanceCompleted = 20;
    int WFL_ProcessStateChanged = 21;
    int WFL_ActionPerformed = 22;
    int WFL_UserLogIn = 23;
    int WFL_UserLogOut = 24;
    int WFL_ProcessInstanceTerminated = 25;
    int WFL_ProcessInstanceStateChanged = 26;
    int WFL_WorkItemCompleted = 27;
    int WFL_WorkItemExpired = 28;
    int WFL_Submit = 29;
    int WFL_Release = 30;
    int WFL_Trigger = 31;
    int WFL_Reject = 32;
    int WFL_Accept = 33;
    int WFL_AuditSet = 34;
    int WFL_Collect = 35;
    int WFL_link = 36;
//----------------------------------------------------------------------------
// Changed By											: Prashant
// Reason / Cause (Bug No if Any)	: New constants added
// Change Description							: New constants added
//----------------------------------------------------------------------------
    int WFL_dlink = 37;
    int WFL_Reinitate = 38;
    int WFL_ProcessInstanceDeleted = 39;
    int WFL_getlink = 40;
    int WFL_WorkItemReferred = 41;
    int WFL_WorkItemWithDrawn = 42;
    int WFL_WorkItemSubmit = 43;
    int WFL_SpawnProcess = 44;
    int WFL_ProcessSpawn = 46;
    int WFL_AdHocRouted = 45;
    int WFL_RemSet = 47;
    int WFL_RemDel = 48;
    int WFL_LogDel = 49;
    int WFL_AddQueue = 50;
    int WFL_ChnQueue = 51;
    int WFL_DelQueue = 52;
    int WFL_DivertSet = 53;
    int WFL_DivertDel = 54;
    int WFL_Exception_Undo = 55;
    int WFL_Exception_Modify = 56;
    int WFL_Print = 57;
    int WFL_Fax = 58;
    int WFL_Mail = 59;
    int WFL_AddUserToQueue = 60;
    int WFL_DeleteUserFromQueue = 61;
    int WFL_AddWorkStepToQueue = 62;
    int WFL_DeleteWorkStepFromQueue = 63;
    int WFL_AddPreferedQueue = 64;
    int WFL_DeletePreferedQueue = 65;
    int WFL_AddAliasToQueue = 66;
    int WFL_DeleteAliasFromQueue = 67;
    int WFL_ProcessTATime = 68;
    int WFL_ActivityTATime = 69;
    // -----------------------------------------------------------------------------------------
    // Changed On  : 24/02/2005
    // Changed By  : Ruhi Hira
    // Description : SrNo-1, Omniflow 6.0, Feature: DynamicRuleModification, New Constant added.
    // -----------------------------------------------------------------------------------------

    // -----------------------------------------------------------------------------------------
    // Changed On  : 05/01/2007
    // Changed By  : Varun Bhansaly
    // Reason      : Bugzilla Bug 370
    // -----------------------------------------------------------------------------------------
    // New actionId for Action ACTION_MAIL_SENT_SUCCESS & ACTION_MAIL_SENT_FAILURE
    int ACTION_MAIL_SENT_SUCCESS = 70;
    int ACTION_MAIL_SENT_FAILURE = 71;

    // New actionId for escalateTo action, SrNo-3, Omniflow 6.0, feature : Escalation. - Ruhi Hira
    int WFL_ScheduleEscalationAction = 72;
    int WFL_EscalationAction = 73;
    //New actionId for subscribe - SrNo-5
    int WFL_SubscribeAction = 74;
    //New ActionId for Set Attribute
    int WFL_AttributeHasBeenSet = 75;
    //SrNo-10
    int WFL_AuditLogPreferencesChanged = 76; /* SrNo-11 */

    int WFL_QueryFilter_Set = 77; //Bugzilla Bug 285

    // -----------------------------------------------------------------------------------------
    // Changed On  : 05/01/2007
    // Changed By  : Varun Bhansaly
    // Reason		 : Bugzilla Bug 370
    // -----------------------------------------------------------------------------------------
    int WFL_Constant_Updated = 78;
    int WFL_WorkItemSuspended = 79;
    int WFL_Calendar_Modified = 80;

    // -----------------------------------------------------------------------------------------
    // Changed On  : 10/10/2007
    // Changed By  : Harmeet Kaur
    // Reason	   : Bugzilla Bug 1695
    // -----------------------------------------------------------------------------------------
    int WFL_ChangeActivityName = 81;
    int WFL_ChangeProcessName = 82;
    //SrNo-16
    int WFL_WorkitemExported = 83;
    //SrNo-10
    int WFL_Add_QuickSearchVariable = 84; //Tirupati Srivastava : ActionId for quicksearchVariable

    int WFL_Delete_QuickSearchVariable = 85;
    int WFL_AuthorizationCompleted = 86; // Bugzilla Bug 2774

    int WFL_WorkItemUnassigned = 87;
    int WFL_AuditTrail = 88; //WFS_6.2_057

    int WFL_DocumentType_CheckOut = 89;
    int WFL_DocumentType_CheckIn = 90;
    int WFL_DocumentType_UndoCheckOut = 91;
    int WFL_DocumentType_SaveTransformation = 92;
    int WFL_DocumentType_Deleted = 93;
    int WFL_DocumentType_VersionCreated = 94;
    int WFL_DocumentType_Overwrite = 95;
    int WFL_Document_Download_Print = 96;
    int WFL_Event_OnMessage = 101;
    int WFL_Event_OnAlarm = 102;
    int WFL_Split_Workitem = 103;
    int WF_History_Deleted = 127;
    int WFL_WorkStarted = 200;
    //Exception with Raise and Response
    int WFL_Exception_Responded = 104;
    int WFL_Exception_Rejected = 105;
	//WFS_8.0_045, ActionId for Add Calendar
	int WFL_ChnQueueColor = 106;    //  Added for color display at web. Abhishek Gupta.    
	int WFL_Add_Calendar = 107;
	int WFL_Delete_Calendar = 108; //WFS_8.0_097
    int WFL_ChildProcessInstanceCreated = 109;
    int WFL_ChildProcessInstanceDeleted = 110;	
	int WFL_Calendar_Association = 111;
	int ACTION_ADD_TO_MAILQUEUE = 112;
	
	//New Action ids Added
	int WFL_WorkitemDiverted = 113;
	int WFL_WorkitemCollected = 114;
	int WFL_ChildWorkitemDeleted = 115;
	int WFL_SetExportCabinet = 116;
	int WFL_ModifyExportCabinet = 117;
	int WFL_DeleteExportCabinet = 118;
	int WFL_AddPurgeCriteria = 119;
	int WFL_ModifyPurgeCriteria = 120;
	int WFL_DeletePurgeCriteria = 121;
        int WFL_ObjecTypePropertySet = 122;	
    
	int WFL_OTMS_ProcessTransported = 150;
	int WFL_SetWorkAudit = 124;
	int WFL_ModifiedWorkAudit = 125;
	int WFL_DeleteWorkAudit = 126;	
    int WFL_SetPreferencesChanged = 128; 

    /*	SrNo-2, New Actionids added for RouteDesigner - Ruhi, 25/05/2005 */
// ActionIds for Route Designer
    int WFL_Process_Register = 501;
    int WFL_Process_UnRegister = 502;
    int WFL_Process_CheckOut = 503;
    int WFL_Process_CheckIn = 504;
    int WFL_Process_UndoCheckOut = 505;
    int WFL_Project_UnRegister = 506;
	int WFL_Process_CheckIn_NewVer = 507;
	int WFL_Process_Variable_Alias = 508;
    int WFS_Process_TemplateModification = 509;
    int WFS_Process_FormEditing = 510;
    int WFS_Process_Purge =511;
    int WFS_Process_DocType_Added = 512;
// ActionIds for Process Variant
    int WFL_AddVariant = 601;
    int WFL_ModifyVariant = 602;
    int WFL_DelVariant = 603;
    int WFL_Change_VariantState = 604;
    
// ActionIds for Task Related Operations
    int WFL_TaskInitiated = 701;
    int WFL_TaskCompleted = 702;
    int WFL_TaskRevoked = 703;
    int WFL_TaskAdded = 704;
    int WFL_TaskDataSet = 705;
    int WFL_TaskDataHasBeenSet = 706;
    int WFL_TaskDiverted = 707;
    int WFL_TaskDeclined = 708;
    int WFL_TaskReassigned = 709;
    int WFL_TaskExpired = 710;
    int WFL_TaskEscalated = 711;
    int WFL_TaskUnlocked = 712;
    int WFL_TaskApproved = 713;
    int WFL_TaskRejected = 714;
    int WFL_AssignBackDivertedTask = 715;
    
    int WFL_WorkitemHolded = 800;
    int WFL_WorkitemUnholded = 801;
    
    int WFL_Resume = 803;
    int WFL_SetSecondaryDBFlag=804;
  //Constants for Data Exchange    
    //ActionIds for Data Exchange Operations
     int WFL_Import_Data = 805;
     int WFL_Export_Data = 806;
//Constant for DateUnit
    int WFL_yy = 1;
    int WFL_qq = 2;
    int WFL_mm = 3;
    int WFL_dd = 4;
    int WFL_wk = 5;
    int WFL_hh = 6;
    int WFL_mi = 7;
    int WFL_ss = 8;
    int WFL_ms = 9;
    int WFL_dw = 10;
    int WFL_dy = 11;

//Constants for Operators
    int WF_ADD = 11;
    int WF_SUB = 12;

//Constants for Filter
    int WF_EQUAL = 2;
    int WF_NOTEQ = 3;

//Constants for Split Queuetable
    int WF_PITBL = 1;
    int WF_QDTBL = 2;
    int WF_WLTBL = 3;
    int WF_WPTBL = 4;
    int WF_WDTBL = 5;
    int WF_WSTBL = 6;
    int WF_PWTBL = 7;

//Constants for Operators
    int WF_OPERATOR_ADD = 11;
    int WF_OPERATOR_SUBSTRACT = 12;
    int WF_OPERATOR_MULTIPLY = 13;
    int WF_OPERATOR_DIVIDE = 14;

//Constants for FinalizationStatus
    char WF_Exception_Temperory = 'T';
    char WF_Exception_Live = 'L';
    char WF_Exception_Finalized = 'F';

    // WFS_6.2_013
    //SrNo-20 added fixed variable id
    String[][] wklattribs = new String[][]{{"PriorityLevel", "323", "M", "38"}
    , {"WorkItemState", "323", "S", "41"}
	, {"ActivityId", "323", "S", "43"}
	, {"LockedByName", "3210", "S", "46"}
	, {"LockedTime", "328", "S", "47"}
	, {"LockStatus", "3210", "S", "48"}
	, {"ActivityName", "3110", "S", "49"}
	, {"AssignmentType", "3110", "S", "51"}
	, {"ProcessedBy", "3210", "S", "52"}
	, {"EntryDateTime", "318", "S", "29"}
	, {"ValidTillDateTime", "318", "S", "30"}
	, {"WorkItemName", "3110", "S", "31"}
	, {"PreviousStage", "3110", "S", "33"}
	, {"TurnAroundDateTime", "318", "S", "10002"}
	, {"WorkItemId", "323", "S", "10004"}
	, {"SecondaryDBFlag", "3210", "M", "10022"}
	, {"URN", "3110", "S", "10023"}
	,{"ManualProcessingFlag", "3210", "M", "10024"}
	,{"DBExErrCode", "323", "M", "10025"}
	,{"DBExErrDesc", "3210", "M", "10026"},
	{"Locale", "3210", "M", "10027"}
	, {"CurrentDateTime", "318", "S", "27"}	
	};

    // WFS_6.2_013
    //SrNo-20 added fixed variable id
    String[][] prcattribs = new String[][]{{"ProcessInstanceState", "323", "S", "40"}
	, {"CreatedDateTime", "318", "S", "28"}
	, {"CreatedByName", "3110", "S", "32"}
	, {"IntroductionDateTime", "318", "S", "35"}
	, {"IntroducedBy", "3110", "S", "36"}
	, {"IntroducedAt", "3110", "S", "10003"} //as discussed with Ruhi Hira- Shweta Tyagi
    };

    // WFS_6.2_013
    //SrNo-20 added fixed variable id
    String[][] qdmattribs = new String[][]{{"HoldStatus", "323", "S", "39"},
        {"CheckListCompleteFlag", "3210", "S", "50"},
        {"InstrumentStatus", "3110", "S", "37"},
        {"SaveStage", "3110", "Q", "34"},
        {"Status", "3110", "Q", "42"},
        {"CalendarName" , "3110", "Q", "10001"}
    };
    String[][] qdmchildattribs = new String[][]{{"ChildProcessInstanceId", "3110", "Q", "-1"},
            {"ChildWorkItemId", "313", "Q", "-2"}
       };
    String[][] s_timeattribs = new String[][]{{"TimeElapsedToFetchQueueData", "3110", "S", "-3"},
            {"TimeElapsedToFetchExtData", "3110", "S", "-4"},{"TimeElapsedToFetchCmplxQueData", "3110", "S", "-5"},{"TimeElapsedToFetchCmplxExtData", "3110", "S", "-6"}
        };
	
	//tables which are excluded from the WFPMWTableMapping.xml
	String[] ignoringtableInCheckOut = new String[]{"QUEUEDEFTABLE","QUEUEUSERTABLE"};
	
	
    String s_attribqdatam = "HoldStatus,CheckListCompleteFlag,InstrumentStatus,SaveStage,Status,CalendarName";
    String s_attribqdatachild = ",ChildProcessInstanceId,ChildWorkItemId";
    String s_attribwrklst = "Select PriorityLevel, WorkItemState, ActivityId, LockedByName, LockedTime, " 
			+ "LockStatus, ActivityName, AssignmentType, ProcessedBy, EntryDateTime, ValidTill," 
			+ "ProcessInstanceId, PreviousStage, expectedWorkITemDelay,WorkItemId,SecondaryDBFlag,URN,ManualProcessingFlag,DBExErrCode, DBExErrDesc, Locale ,";
    //String s_attribpinlst = "Select ProcessInstanceState,CreatedDateTime,CreatedByName," 
		//	+ "IntroductionDateTime,IntroducedBy,IntroducedAt from ProcessInstanceTable";
	String s_attribpinlst = "Select ProcessInstanceState,CreatedDateTime,CreatedByName," 
		+ "IntroductionDateTime,IntroducedBy,IntroducedAt from WFInstrumentTable";
    String WF_NOTSTARTED = "NOTSTARTED";
    String WF_RUNNING = "RUNNING";
    String WF_SUSPENDED = "SUSPENDED";
    String WF_TERMINATED = "TERMINATED";
    String WF_ABORTED = "ABORTED";
    String WF_COMPLETED = "COMPLETED";
    String WF_HOLDED = "HOLDED";
    String WF_TEMP_HOLDED = "THOLDED";
    String WF_VARCHARPREFIX = "N'";
	String s_attribqueht = "Select ProcessInstanceState,CreatedDateTime,CreatedByName,"
			+ "IntroductionDateTime,IntroducedBy,'NULL' from QueuehistoryTable";

    //Constants for Expression
    int WF_LESSTHAN = 1; //   <;

    int WF_LESSTHANEQUALTO = 2; //   <=;

    int WF_EQUALTO = 3; //   =

    int WF_NOTEQUALTO = 4; //   =

    int WF_GREATERTHAN = 5; //   >

    int WF_GREATERTHANEQUALTO = 6; //   >=

    int WF_LIKE = 7; //   LIKE

    int WF_NOTLIKE = 8; //   NOTLIKE

    int WF_NULL = 9; //   NULL

    int WF_NOTNULL = 10; //   NOTNULL

    int WF_PLUS = 11;
    int WF_MINUS = 12;
    int WF_MULTIPLY = 13;
    int WF_DIVIDE = 14;

    // SrNo-4, New Utility types for license implementation for utilities.
    String UTIL_PS = "PROCESS SERVER";
    String UTIL_PFE = "PRINT,FAX & EMAIL";
    String UTIL_SA = "SCHEDULED APPLICATION";
    String UTIL_MailUtil = "MAILING UTILITY";
    String UTIL_LB = "LOAD BALANCER";
    String UTIL_EXP = "EXPIRY UTILITY";
    String UTIL_ARCH = "ARCHIVE UTILITY";
    String UTIL_MAILAGT = "MAILING AGENT";
    String UTIL_MESSAGT = "MESSAGE AGENT";
    String UTIL_JMSPUB = "JMS PUBLISHER";
    String UTIL_JMSSUB = "JMS SUBSCRIBER";

    //SrNo-7. File name WFMapping.xml added.
    String FILE_WFMAPPING = "wfmapping.xml";
    //SrNo-8. File name JMSMessage.log added.
    String FILE_FAILEDJMSMESSAGE = "FailedJMSMessages.log";
    String QUERY_STR_WHERE = " Where ";
    String QUERY_STR_AND = " And ";

    // Constants for reports
    char CONST_TYPE_YEAR = 'Y';
    char CONST_TYPE_QUARTER = 'Q';
    char CONST_TYPE_MONTH = 'M';
    char CONST_TYPE_WEEK = 'W';
    char CONST_TYPE_DAY = 'D';
    char CONST_TYPE_HOUR = 'H';
    char CONST_DURATION_TODAY = 'T';
    char CONST_DURATION_LAST_DAY = 'D';
    char CONST_DURATION_LAST_WEEK = 'W';
    char CONST_DURATION_LAST_MONTH = 'M';
    char CONST_DURATION_LAST_QUARTER = 'Q';
    char CONST_DURATION_LAST_YEAR = 'Y';
    /** 19/07/2007, Bugzilla Bug 1492, Japanese error messages not visible properly - Ruhi Hira. */
    String CONST_ENCODING_UTF8 = "UTF-8";
    String CONST_ENCODING_ISO8859 = "ISO8859_1";

    /* 17/08/2007, SrNo-12, Synchronous routing of workitems - Ruhi Hira */
    String CONST_BROKER_APP_SERVER_IP = "jndiServerName";
    String CONST_BROKER_APP_SERVER_PORT = "jndiServerPort";
    String CONST_BROKER_APP_SERVER_TYPE = "appServerType";
    //SrNo-22
    String CONST_HTTP_PROTOCOL_NAME = "HTTPProtocolName";
    String CONST_HTTP_IP = "HTTPIP";
    String CONST_HTTP_PORT = "HTTPPort";
    //SrNo-17
    String CONST_JCO_VERSION = "SAPJCoVersion";//SrNo-24
    public static String CONST_SYNC_ROUTING_MODE = "syncRoutingMode";
    public static String CONST_HOOK_ENABLE_ON_ERROR = "HookEnableOnError";
    public static String CONST_LIKE_SEARCH_ENABLED = "LikeSearchEnabled";
    public static String CONST_CALL_APIS_ON_TASK_EXPIRY = "CallApisOnTaskExpiry";
	public static String CONST_ALLOW_ADHOC_ROUTING_CHILD = "AllowAdhocRouteForChild";
    public static String CONST_Hyphen_Required = "hyphenRequired";
    public static String CONST_ENABLEAXIS1 = "EnableAxis1";
    public static String CONST_SOFTDELETEFORARRAY = "SoftDeleteForArray";
    public static String CONST_HideEmailIdInLog = "HideEmailIdInLog";
    int CONST_COMMENTS_REFER = 1;
    int CONST_COMMENTS_REASSIGN = 2;
    int CONST_COMMENTS_AUDIT_REJECT = 3;
    int CONST_COMMENTS_HOLD = 4;
    int CONST_COMMENTS_UNHOLD = 5;
    int CONST_COMMENTS_ADHOC_ROUTE = 6;
    int CONST_COMMENTS_DECLINE = 7;
    int CONST_COMMENTS_TASK_APPROVAL = 8;
    int CONST_COMMENTS_TASK_REJECTED = 9;
    int CONST_COMMENTS_TASK_REVOKED = 10;
    String CONST_DIRECTORY_CONFIG = "wfsconfig";
    String CONST_FILE_CONFIGURATION = "Omniflow_Configurations.xml";
    String CONST_FILE_WFAPPCONFIGPARAM = "WFAppConfigParam.xml";
    String CONST_FILE_WFAPPCONTEXT = "wfappcontext.xml";
    String CONST_FILE_WFOBJECTPOOL = "WFObjectPool.xml";
    String CONST_DIRECTORY_LOG = "Omniflow_Logs";
    String CONST_FILE_LOG4J = "log4j.properties";
	String CONST_FILE_LOG4J_CONFIG_XML = "log4jconfig.xml";
    String CONST_FILE_SAPLICENSE = "ngsaplicense.txt"; //SrNo-25
	String CONST_TABLEMAPPING = "wfpmwtablemapping.xml";   
	String CONST_DIRECTORY_RIGHTMIGRATION = "rightmigration";
	String CONST_FILE_RIGHTMIGRATION= "ProcessName-QueueUserGroup-data-ddmmyyyy-hhmmss.xls";
	String CONST_FILE_NEWRIGHTMIGRATION= "ProcessName-QueueUserGroup-data-";
	String CONST_USERSHEET_NAME="User";
	String CONST_GROUPSHEET_NAME="Group";
	String CONST_USERGROUPMAPPINGSHEET_NAME="UserGroupMapping";
	String CONST_USERPROFILEMAPPINGSHEET_NAME="UserProfileMapping";
	String CONST_USERQUEUEMAPPINGSHEET_NAME="UserQueueMapping";
	String CONST_SYSTEMDATASHEET_NAME="System";
	
    String CONST_FLOAT_LENGTH = "15";
    int CONST_FLOAT_PRECISION = 2;
    String CONST_DIRECTORY_BPELCONFIG = "WFBPELConfig";
    String CONST_BPELCONFIG_LOCATION = "BPEL_WSDL_Location";
	//WFS_8.0_127
	String CONST_THRESHOLD_TIME= "ThresholdTime";
    String CONST_THRESHOLD_SIZE = "ThresholdSize";
    String CONST_NOTIFYBYEMAIL="NotifyByEmail";
    String CONST_OFQUERYTIMEOUT="OFQueryTimeOut";
  // Application Types.
  String CONST_PROCESSSERVER = "Process Server";
  String CONST_SCHAPPLICATION = "Scheduled Application";
  String CONST_MAILUTILITY = "Mailing Utility";
  String CONST_PRINTFAXMAIL = "Print Fax Email";
  String CONST_LOADBALANCER = "Load Balancer";
  String CONST_EXPIRY = "Expiry Utility";
  String CONST_ARCHIVE = "Archive Utility";
  String CONST_MAILAGENT = "Mailing Agent";
  String CONST_MESSAGENT = "Message Agent";
  String CONST_PUBLISHER = "JMS Publisher";
  String CONST_SUBSCRIBER = "JMS Subscriber";
  String CONST_WSINVOKER = "WebService Invoker";
  String CONST_BRMSINVOKER = "Business Rule Executor"; // New Activity BRMS Added
  String CONST_SAPINVOKER = "SAP Invoker";
  String CONST_EXPORTUTIL = "Export Utility";
  String CONST_EXPORTPURGE = "Export Purge Utility";
  String CONST_IMPORT = "Import Utility";
  String CONST_UPLOAD = "File Upload Utility";
  String CONST_INITIATE = "Initiation Agent";
  String CONST_SHAREPOINT = "SharePoint Archive Utility";
  String CONST_REMINDER = "Reminder Utility";
  String CONST_OMSADAPTER = "OMS Adapter Service";
  String CONST_AUDITARCHIVE = "Audit Archive Utility";
  //String CONST_WORKFLOW_REPORT = "WorkFlowReport";
  String CONST_CLUSTERNAME="ClusterName";
  String CONST_CASESUMMARY = "Case Summary";
  String CONST_RESTSERVICE = "RestServiceInvoker";
  String CONST_GENERIC = "Generic";
  String CONST_SECONDARYDATAMIGRATION = "Secondary Data Migration";
  String CONST_DATA_EXCHANGE = "Data Exchange Utility";
    String CONST_CUSTOM_EXTERNAL_SERVICE = "Custom Service(E)";
    String CONST_CUSTOM_INTEGRATED_SERVICE = "Custom Service(I)";

    // Action Ids for service operations
    int ACTION_SERVICE_REGISTER = 1;
    int ACTION_SERVICE_MODIFY = 2;
    int ACTION_SERVICE_UNREGISTER = 3;
    int ACTION_SERVICE_START = 4;
    int ACTION_SERVICE_STOP = 5;
    int ACTION_SERVICE_RESTART = 6;
  
  
  Pattern WF_DATE_PATTERN = Pattern.compile("\\d{1,4}-\\d{1,2}-\\d{1,2}(\\s+(([0-9])|([0-1][0-9])|(2[0-3]))(:([0-9]|([0-5][0-9]))(:([0-9]|([0-5][0-9])))?)?)?");
  Pattern WF_DATE_PATTERN1 = Pattern.compile("'\\d{1,4}-\\d{1,2}-\\d{1,2}(\\s+(([0-9])|([0-1][0-9])|(2[0-3]))(:([0-9]|([0-5][0-9]))(:([0-9]|([0-5][0-9])))?)?)?'");
  /** 26/09/2011, Changes for Worflow Report Folder creation issue(For Saas)BugID 28477 - Mandeep Kaur */
  
  
  //Profile Right ObjectTypeConstants
  String CONST_OBJTYPE_PROCESS = "PRC";
  String CONST_OBJTYPE_QUEUE = "QUE";
  String CONST_OBJTYPE_PROJECT = "PROJECT";
  String CONST_OBJTYPE_SWIMLANE = "SLANE";
  String CONST_OBJTYPE_TRANSPORT = "OTMS";
  String CONST_OBJTYPE_CRITERIA = "CRM";
  String CONST_OBJTYPE_ProcessClientWorklist ="WDWLMNU";
  
  //Profile Right OrderBy Constants
  int CONST_PROCESS_VIEW = 1;
  int CONST_PROCESS_MODIFY =2;
  int CONST_PROCESS_UNREGISTER = 3;
  int CONST_PROCESS_CHECKOUT = 4;
  int CONST_PROCESS_CHNGSTATE = 5;
  int CONST_QUEUE_VIEW = 1;
  int CONST_QUEUE_DELETE = 2;
  //int CONST_QUEUE_MODIFY = 2;
  int CONST_QUEUE_MODIFYQPROP = 3;
  int CONST_QUEUE_MODIFYQUSER = 4;
  int CONST_QUEUE_MODIFYQSTREAM = 5;
  int CONST_TRANSPORT_MODIFY = 1;
  int CONST_PROJECT_UNREGISTER = 2;
  
  int CONST_ProcessClientWorklist_UNLOCK = 20;
  int CONST_ProcessClientWorklist_ADHOC = 19;
  int CONST_ProcessClientWorklist_REASSIGN = 8;
  int CONST_ProcessClientWorklist_ASSIGN_TO_ME = 12;
  int CONST_ProcessClientWorklist_UNHOLD = 22;
  
  int CONST_CRITERIA_VIEW = 1;
  //ActionID defined for Right Management Auditing
  int WFR_Add_Profile = 1001;
  int WFR_Del_Profile = 1002;
  int WFR_ChnProfile_Property = 1003;
  int WFR_AddUserToProfile = 1004; 
  int WFR_DelUserfromProfile = 1005;
  int WFR_UpdUserfromProfile = 1006; 
  int WFR_AddObjTypeToProfile = 1007;
  int WFR_DelObjTypeToProfile = 1008;
  int WFR_UpdObjTypeToProfile = 1009;
  int WFR_AddObjTypeToUser = 1010;
  int WFR_DelObjTypeToUser = 1011;
  int WFR_UpdObjTypeToUser = 1012;
  
//ActionID defined for Setting System Property
  int WFL_SetSystemProperty=1101;
  
  String CONST_DEFAULT_RIGHTSTR = "1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111";
  String CONST_DEFAULT_PROJECT_RIGHTSTR="1100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";
  String CONST_DEFAULT_CRITERIA_RIGHTSTR = "1110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";
  String CONST_DEFAULT_PROCESS_RIGHTSTR = "1111111100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";
  String CONST_DEFAULT_QUEUE_RIGHTSTR = "1111100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";
  String CONST_DEFAULT_PROCESS_VIEW_RIGHTSTR = "1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";
  String CONST_MODULE_NAME = "of_server";
  String CONST_SAP_MODULE = "SynchronousSAP";
  String CONST_JMS_MODULE = "SynchoronousJMS";
  String CONST_WS_MODULE = "SynchoronousWS";
  //Timer Service Look up constants 
  String CONST_TIMER_SERVICE_LOOKUP_PREFIX= "TimerServiceLookUpPrefix";
  String CONST_TIMER_SERVICE_LOOKUP_SUFFIX= "TimerServiceLookUpSuffix";
  String TIMER_SERVICE_LOOKUP_NAME="com.newgen.omni.jts.timer.WFTimerServiceBean";
  String CONST_DATETIMEFORMAT = "DateTimeFormat";
  String CONST_MAILFROMEMAILID = "MailFromEmailId";
  String CONST_BYPASS_TRUSTED_CERTIFICATE_CHECK = "BypassTrustedCertificateCheck"; //checkmarx changes ss
  String HISTORY_LOG_ON_TARGET = "HistoryLoggingOnTarget";
  //Constants for Task in Case Management
 
  int WF_TaskInitiated = 2;
  int WF_TaskCompleted = 3;
  int WF_TaskRevoked = 4;
  int WF_TaskDeclined = 5;
  int WF_TaskPendingForApproval = 6;
  int WF_CASE_SUBMITTED = 7;
 //Constant for Notification by email for Case Management Task
  String CONST_DIRECTORY_TASK_NOTIFICATION = "tasknotification";
  String CONST_ORM_MODULE = "orm_server";
  
  String CONST_TIME_ELAPSED_QUEUE_DATA = "TimeElapsedInSetQueueData";
  String CONST_TIME_ELAPSED_EXT_DATA= "TimeElapsedInSetExtData";
  String CONST_Priority_Value_1 ="Low";
  String CONST_Priority_Value_2 ="Medium";
  String CONST_Priority_Value_3 ="High";
  String CONST_Priority_Value_4 ="Very High";
  
  //Constant for Multiple-Precondition Operation in Task
  int TASK_SET=1;
  int TASK_TRIGGER=15;
  int TASK_WAITING_TO_READY=101;
  int TASK_OPTIONAL_TO_MANDATORY=102;
  int TASK_MANDATORY_TO_OPTIONAL=103;
  int TASK_INITIATE_ASSIGN=104;

  int TASK_NORMAL=1;
  int TASK_PROCESS=2;
  String TASK_SUB_ASYNCHRONOUS="A";
  String TASK_SUB_SYNCHRONOUS="S";
  String TASK_SUB_USER_DEF_SYNCHRONOUS="U";  
  
//REST Implementations:
    public static final String APPLICATION_XML = "application/xml";
    public static final String APPLICATION_JSON = "application/json";
    public static final String APPLICATION_FORM_URLENCODED = "application/x-www-form-urlencoded";
    public static final String MULTIPART_FORM_DATA = "multipart/form-data";
    public static final String APPLICATION_OCTET_STREAM = "application/octet-stream";
    public static final String TEXT_PLAIN = "text/plain";
    public static final String TEXT_XML = "text/xml";
    public static final String TEXT_HTML = "text/html";
  
  //Constants for Task Expiry action
  int REVOKE_TASK=1;
  int REASSIGN_TASK=2;

  //Constant for iForm Device type
  String DEVICE_TYPE_IFORM = "A";

  String CONST_ProductVersion = "ProductVersion";
  String CONST_SHAREPOINT_TIMEOUT = "SharePointTimeOut";
  
  //Constant for UserGroups feature
  int USER_TYPE_ASSOCIATION = 0;
  int GROUP_TYPE_ASSOCIATION = 1;
  int CASE_SUMMARY_DOCUMENT_READY = 0;
  int CASE_SUMMARY_DOCUMENT_IN_PROGRESS =1;
  int CASE_SUMMARY_DOCUMENT_SUCCESS = 2;
  int CASE_SUMMARY_DOCUMENT_FAILURE = 3;
  
  int SEARCH_CASE_BASKET_PROCESSINSTANCEID= 1;
  int SEARCH_CASE_BASKET_ACTIVITY_NAME = 2;
  
  //Constant for ReusableConponent feature
  String CONST_THRESHOLD_RECORD= "ThresholdRecord";
  public static final int IF_RULE = 100;
  public static final int END_IF_RULE = -100;
  public static final int RESULT_RULE = 999;
  public static final int RETRIEVE_RULE = 1001;
  public static final int INSERT_RULE = 1002;
  public static final int UPDATE_RULE = 1003;
  
	// Logical Operator Types
	public final static int WF_OPERATOR_AND = 1;
	public final static int WF_OPERATOR_OR = 2;
	public final static int WF_OPERATOR_EOE = 3; // End of Expression//
	
	public static final String COLUMN_TYPE_SET = "SET";
	public static final String COLUMN_TYPE_FILTER = "FILTER";
	public static final String COLUMN_TYPE_JOIN = "JOIN";
	
	//Global External Method OR Global WebService(SOAP) extmethodindex range
	public static final int EXTERNAL_METHOD_START_INDEX=5000;
	public static final int EXTERNAL_METHOD_END_INDEX=6999;
	public static final int WEB_SERVICE_START_INDEX=7000;
	public static final int WEB_SERVICE_END_INDEX=8999;
	
	//Multilingual Support for criteriaName, FilterName and displayName
	public static final int CRITERIA_ENTITY_TYPE=8;
	public static final int FILTER_ENTITY_TYPE=9;
	public static final int PROCESS_ENTITY_TYPE=1;
	public static final int QUEUE_ENTITY_TYPE=3;
	public static final int DISPLAY_ENTITY_TYPE=10;

	public static final int WF_SUCCESS = 0;
	public static final int WF_WARNING = 1;
	public static final int WF_FAILED = 2;
	
	static final String CONST_DEFAULT_RIGHTSTR_ZERO = "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";

	  /** pattern for XLS file parsing in Data Migration API **/
	public static final String WF_XLS_DATE_FORMAT = "dd/MM/yyyy";
	Pattern WF_XLS_COMMENTS_PATTERN = Pattern.compile("^[^~`!@#\\$%\\^&\\*()+={}|\\[\\]\\\\:\";'<>?,./]*$");
	Pattern WF_XLS_USERNAME_PATTERN = Pattern.compile("^[^~`!@#\\$%\\^&\\*()+={}|\\[\\]\\\\:\";'<>?,./]*$");
	Pattern WF_XLS_EMAIL_PATTERN = Pattern.compile("^[A-Za-z0-9+_.-]+@(.+)$");
	public static String CONFIG_DIR = "restconfig";
	public static String OMNIFLOW_SERVER_CONFIG_FILE = "RestConfig.ini";
	
	// Constants for Data Exchange
	public static final String EXPORT_OPERATION= "E";
	public static final String IMPORT_OPERATION= "I";
	public static final String COLUMN_TYPE_RELATION = "RELATION";
	
	
	// Constant for Checkmarx
	public static final String WF_UTF16 = "UTF-16";
	public static final String WF_MD5 = "MD5";
} //end-JTSConstant