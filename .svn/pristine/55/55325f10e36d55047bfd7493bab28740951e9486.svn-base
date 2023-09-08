//----------------------------------------------------------------------------------------------------
//		NEWGEN SOFTWARE TECHNOLOGIES LIMITED
//	Group				: Application ?Products
//	Product / Project		: WorkFlow
//	Module				: Transaction Server
//	File Name			: CreateWorkitem.java
//	Author				: Prashant
//	Date written (DD/MM/YYYY)	: 16/05/2002
//	Description			:
//----------------------------------------------------------------------------------------------------
//			CHANGE HISTORY
//----------------------------------------------------------------------------------------------------
// Date			Change By	Change Description (Bug No. (If Any))
// (DD/MM/YYYY)
//----------------------------------------------------------------------------------------------------
//  26/11/2002          Prashant	Bug No OF_BUG_125
//  26/11/2002          Prashant	Bug No OF_BUG_177
//  24/03/2003          Prashant	Bug No TSR_3.0.1_009
//  24/03/2003          Prashant	Bug No TSR_3.0.1_024
//  31/05/2003          Prashant	Bug No TSR_3.0.2.0005
//  31/05/2003          Prashant	Bug No TSR_3.0.2.0012
//  31/05/2003          Prashant	Bug No TSR_3.0.2.0013
//  31/05/2003          Prashant	Bug No TSR_3.0.2.0015
//  31/05/2003          Prashant	Bug No TSR_3.0.2.0017
//  07/06/2003          Prashant	Bug No TSR_3.0.2.00/20
//  17/06/2003          Prashant	Bug No TSR_3.0.2.0023
//  18/06/2004          Ruhi Hira	Bug No SRU_5.0.1_004
//  23/06/2004          Krishan Dutt	Bug No WSE_I_5.0.1_478
//  28/06/2004          Krishan Dutt    Connection should be committed before making entry in RouteLogTable (Bug no 605)
//  06/07/2004          Krishan Dutt	Bug No WSE_5.0.1_beta_008 (Transaction committed before sending the messahe to JMS)
//  09/07/2004          Ruhi Hira	Bug No WSE_I_5.0.1_697 (setAttribute swapped with createWorkItem)
//  14/07/2004          Krishan Dutt	Bug No WSE_5.0.1_beta_186
//  14/07/2004          Krishan Dutt	Bug No WSE_5.0.1_beta_200
//  19/07/2004          Krishan Dutt	Bug No WSE_5.0.1_beta_238
//  08/09/2004          Krishan		wfs_5_001 (For removing JMS)
//  09/11/2004          Krishan		ProcessInstance delay report related bug rectified(Bug # WFS_5_010).
//  17/01/2005          Harmeet Kaur	Bug WFS_5.2.1_0003.
//  06/03/2005          Ashish Mangla	Conditional Distribute, if target is distribute, mark it done at Distribute so that PS can pick it again and execute entry setting and can find where to distribute
//  06/03/2005          Ashish Mangla	Variable Collect, Do not get collection criteria from the database, it is being supplied by PS itself
//  06/03/2005          Ashish Mangla	Suspend WorkItem
//  08/03/2005          Ruhi Hira	SrNo-1.
//  18/03/2005          Ruhi Hira	SrNo-2, SrNo-3.
//  01/04/2005          Ruhi Hira	SrNo-4.
//  09/04/2005          Harmeet Kaur	WFS_6_004
//  11/04/2005          Ashish Mangla	WFS_6_006
//  02/05/2005          Ruhi Hira	Bug # WFS_6_011.
//  18/08/2005          Ruhi Hira	SrNo-5.
//  23/12/2005          Ashish Mangla	Bug # WFS_6.1_043
//  15/02/2006          Ashish Mangla	WFS_6.1.2_049 (Changed WMUser.WFCheckSession by WFSUtil.WFCheckSession)
//  17/02/2006          Ashish Mangla	WFS_6.1.2_056 Histrory of entry setting setattributes should be coming on correct workstep...(in case custom -> custom, in case decision -> custom, history will come on decision)
//  17/02/2006          Ashish Mangla	WFS_6.1.2_055	--override the values for teh set attributes in the fetchattributes....
//  13/03/2006          Ashish Mangla	WFS_6.1.2_062   --IN case of distibute, first call set attributes and then createworkitem as the setting of values are treated as exit rules.
//  11/04/2006          Ruhi Hira       Bug # WFS_6.1.2_065.
//  14/08/2006          Ruhi Hira       Bugzilla Bug 61.
//  25/08/2006          Ashish Mangla	Bugzilla Bug 140.
//  29/08/2006          Ruhi Hira	    Bugzilla Bug 210.
//  13/12/2006          Ashish Mangla	SrNo-6 (Calendar Support)	ExpectedWorkItemDelay and validTill are to be set in this call. (Use CalUtil for addition of date)
//  23/02/2007          Varun Bhansaly  Calendar Support in the Calculation of Expected WorkItem Delay and validTill
//  12/05/2007          Ruhi Hira       Bugzilla Bug 687, Custom Interface Support.
//  14/05/2007          Ruhi Hira       Bugzilla Bug 690, delete on collect configuration.
//  06/07/2007          Ruhi Hira       Bugzilla Bug 1402.
//  04/09/2007          Shilpi S        SrNo-7, Omniflow7.1 , dateprecision till minutes
//  05/09/2007          Ruhi Hira       SrNo-8, Synchronous routing of workitems.
//  12/09/2007          Ruhi Hira       Inherited from 5.0 (WFS_5_192, Duplicate WI issue;
//                                                      WFS_5_199, Simultaneous collection attempt).
//  19/10/2007          Varun Bhansaly	SrNo-9, Use WFSUtil.printXXX instead of System.out.println()
//									System.err.println() & printStackTrace() for logging.
//  15/11/2007          Ruhi Hira       Due to some technical complications, adhoc routing is not synchronous as of now.
//  23/11/2007          Shilpi S        SrNo-10, Export Type of WorkStep
//  10/12/2007          Shilpi S        Bugzilla Bug # 1844
//  17/12/2007          Ashish Mangla	Bugzilla Bug 2121 (DeleteOnCollectflag to be considered while checking count for duplicate WI)
//  18/12/2007          Shilpi S        Bugzilla Bug # 1715
//  19/12/2007          Shilpi S        Bug # 1608
//  20/12/2007          Shilpi S        Bug # 2823
//  1/1/2008            Shilpi S        Bug # 1716
//  2/1/2008            Shilpi S        Bug # 3196
//  08/01/2008          Ruhi Hira       Bugzilla Bug 1649 Method moved from OraCreateWI.
//  01/02/2008          Ruhi Hira       Bugzilla Bug 3766, Dangling workstep issue.
//  01/02/2008          Ruhi Hira       Bugzilla Bug 3511, createProcessInstance moved to WFSUtil
//                                                  wfs_ejb classes not accessible from wfsshared.
//  25/02/2008          Shilpi S        WFS_5_216
//  06/03/2008		Shweta Tyagi	Bugzilla Bug 3912 Optimization : OraCreateWorkitem - fire query on QueueDataTable
//  10/03/2008		Shweta Tyagi	Bugzilla Bug 3913 Optimization : OraCreateWorkitem - Need to modify condition to change processInstanceState
//  17/06/2008          Ruhi Hira       SrNo-11, New feature : user defined complex data type support [OF 7.2]
//  03/04/3008          Ruhi Hira       Bugzilla Bug 5488, Set command in entry settings does not execute.
//  08/07/2008          Shweta Tyagi    Bugzilla Bug 5051, Collect bug when collection criteria < Distributed items.(Inherited from 7.1)
//  09/07/2008          Shilpi S        Bug # 5597
//  16/07/2008          Ruhi Hira       Bugzilla Bug 5797, OF 7.2 onwards AssignedUser will not come in name value pair.
//  31/10/2008          Shilpi S        Multiple Distribute Requirement 
//  17/12/2008          Shilpi S        SrNo-12, BPEL Event Handling in Omniflow 
//  22/12/2008		Ashish Mangla	Bugzilla Bug 7390 (In fetchworklist, lockstatus was null , giving error in oracle)
//  29/12/2008          Shilpi S        Bugzilla Bug 7514 
//  31/12/2008          Shilpi S        Bug # 7531
//  31/12/2008		Ashish Mangla	Bugzilla Bug 7538 (Reflect changes of 5.0 for Collection criteria WFS_5_235)
//  27/08/2009          Shilpi S        WFS_8.0_026, SrNo-13, Workitem Based Calendar
//	14/09/2009			Preeti Awasthi  WFS_8.0_034 Workitem is distributed and collection criteria is set as 1 and when one instance reaches on collect and deleteOnCollet then if the second instance is further distributed it is not getting deleted automatically.
// 16/11/2009			Vikas/Ashish	WFS_8.0_056  SetAttributeExt function should not be call when target activity id is collect
// 18/03/2010			Ashish Mangla	Bugzilla Bug 12344 (SetAttributeExt function should not be call when target activity id is discard and workitemid > 1 )
// 09/08/2010			Saurabh Kamal	WFS_8.0_122, Exception Trigger on entry setting not working.
// 06/01/2011		Preeti Awasthi	[Replicated] WFS_8.0_124: Referred workitem cannot be adhoc routed
// 11/01/2011		Preeti Awasthi	[Replicated] WFS_8.0_141: Support of adhoc routing from Hold workstep
// 05/07/2011		Preeti Awasthi	Bug 27418:CreateWorkitem call gets failed at distribute workstep from Process Server if apostrophe is present in any 
//									string type queue variable.
// 31/08/2010		Saurabh Kamal   WFS_8.0_129, Change for createChildWorkitem trigger and deleteChildWorkitem method execution
//	17/04/2012		Preeti Awasthi	Bug 31094 - If user is deleted , assignto rule is failed
// 16/05/2012		Preeti Awasthi	Bug 31949 - Using bind variables
// 08/06/2012		Sachin Pipal	Bug 32542 - Not able to search the workitem after adhoc routing.
// 05/07/2012       Bhavneet Kaur   Bug 33029 Cabinet Based Logging for Console, Error, PSError, PSXML & PSOut logs
// 10/03/2011		Abhishek Gupta	Audit type rule support	
// 01/02/2013		Sweta Bansal	Bug 38167 - Support for deleting child instance from WorkListtable and PendingWorklisttable.
//// 22/03/2013		Bhavneet Kaur	Bug 38783 - Adhoc-routing one workitem to Discard workstep, Process History Report shows that two workitems have been aborted
//17/05/2013		Shweta Singhal	Process Variant Support Changes
//26/06/2013        Shweta Singhal  Bug 40704- CreateChildWorkitem is not in transaction in OraCreateWorkitem
//03/02/2014        Shweta Singhal  WFSetExternalData transaction logging and query filter switched
// 18/02/2014       Shweta Singhal	No need to call fetchAttributes() just to fetch CalenderName
//25/02/2014        Sajid Khan          NGLogger Implementation.
// 28/02/2014	    Kahkeshan		Stop movement of workitems into QueueHistoryTable on exit (with ProcessInstanceState as 6) . 
// 24/03/2014		Kahkeshan		Changes done for In Memory rule execution of consecutive Decision worksteps.	
//17/04/2014        Kanika Manik    Bug 44342 - While adhoc routing for the workitem from workdesk2 to Endevent, Now search workitem, showing ar EndEvent but color is not getting changed
// 13/06/2014      Anwar Ali Danish   PRD Bug 38828 merged - Changes done for diversion requirement. CQRId 				CSCQR-00000000050705-Process 
// 16/06/2014		Mohnish Chopra	Changes in spawnProcess because of change in table structure of WFLinksTable
//23/06/2014        Kanika Manik        PRD Bug 42691 - Mails to be triggered in case of Refer,Reassign and SetDiversion based upon the NotifyByEmail flag value which is to be read from WFAppContext.xml.
// 26/06/2014       Anwar Danish     PRD Bug 45001 merged - Add new action ids, handle also at front end configuration screen and history generation functionality.
// 27/06/2014		Kahkeshan			Bug 46270 Code review defects in OraCreateWorkitem/ WFCreateWorkitemInternal 
// 27/06/2014		Kahkeshan			Bug 46969 Application is not getting started in ofservices 
//20/08/2014		Mohnish Chopra		Prdp Bug 45015 merged - Proper Error message needs to be displayed while trying to ahdoc route a referred workitem.
//17/09/2014		Mohnish Chopra		Bug 50113 :"While search ""in-process"" wi, terminated workitem should not be shown in search result"
//08/10/2014		Mohnish Chopra		Bug 50668 - Check to be Applied if the SubProcess is not enabled. 
// 07/08/2015       Anwar Danish	    PRDP Bug 50715 merged - Various Issues in Admin Audit Log and Workitem Audit Log// 07/08/2015		   Anwar Danish		   PRD Bug 51267 merged - Handling of new ActionIds and optimize usage of current ActionIds regarding OmniFlow Audit Logging functionality.
//11/08/2015		Mohnish Chopra		Changes for Case Management- Added column ActivityType in WFInstrumentTable
//20 Nov 2015		Sajid Khan			Hold Workstep ENnhancement.
//22/02/2017		Mohnish Chopra		UT Defect after Critical Bug merging-- Q_UserId was not getting cleared 
//										when workitem of main process moves to sub process workstep
// 28/07/2015		Sweta Bansal	Bug 56062 - Handling done to use WFUploadWorkitem API for creating workitem in SubProcess(Subprocess/Exit) and to perform operation like: workitem creation in subprocess, Bring ParentWorkitem in flow when child routed to exit, will be performed before CreateWorkitem.
// 13/04/2017		Kumar Kimil       Bug 66398 - Support of WFChangeWorkItemPriority API to get the Priority Level audting when Workitem priority is changed
// 17/04/2017		Kumar Kimil		Bug 66718 - Handling of the errorneous cases in the WMCreateWorkItem API to suspend the workitem and also to print the Query execution time to fetch and set queue and external variables
//19/4/2017       Kumar Kimil     Bug 64096 - Support to send the notification by Email when workitem is suspended abnormally due to some error
//19/04/2017        Mohnish Chopra     PRDP Bug 62490 - Parent data is getting updated from distributed child workitem even after collection criteria met and parent workitem is in the flow --66680
//21/04/2017        Mohnish Chopra     Bug 64446 - Handling to create the childworkitem on multiple activities at the same time with a single CreateChildWorkitem trigger when activity list is coma or semicolon separated and error handling when generate same parent is true
//03/05/2017       Kumar Kimil      Bug 57071 - Html formatting is not present when mails are triggered by escalte to feature.
//02-05-2017		Sajid Khan		Merging Bug 58898 - Error coming while fetching the filtervalue from wfInstrumenttable in WMCreateWorkItem API
//05-05-2017        Sajid Khan      Merging Bug 55753 - Provided option to add Comments while ad-hoc routing of Work Item in process manager
// 09/05/2017		Rakesh K Saini	Bug 56761 - Seperating configuration data and Application parameters from WFAppContext.xml file by dividing the file into two files. 1. WFAppContext.xml 2. WFAppConfigParam.xml
//09-05-2017	Sajid Khan			Queue Varaible Extension Enahncement
//10/05/2017     Kumar Kimil         Bug 56115 - Optimization in Process Server(Both Synchronous and Non-Synchronous) for smooth processing of the workitems and to handle erroneous cases.
//19/05/2017	Mohnish Chopra		Prdp Bug 62664 - Support for letting Child workitems to be adhoc routed to anywhere except Exit and Discard .
//22/05/2017	Sajid Khan			Merging Bug 64308 - AssignmentType for the referred and distributed parent workitems changed to Z and while searching the workitems, workitems with assignment type Z will not be visible
//31/05/2017    Sajid Khan          Merging Bug 69027 - When user AdHoc routes a workitem the processed by doesn't get changed
//14/07/2017    Sajid Khan          Invalid column name QretainPreviousStageueuetype when workitem is routed back to Introduction workstep in Asu=ynchronous mode
//31/05/2017	Sajid Khan	    Mergingn Bug 69647 - Call to WFLinkWorkitem to be removed for sub process workitem creation and initiate workitem through exit.
//              Sajid Khan          PRDP Bug 69029 - Need to send escalation mail after every defined time
//06/09/2017    Sajid Khan          Changes done for Unable to adhoc workitem on discard event . 
////04/09/2017	Ambuj Tripathi			Bug 70680 - Discrepancy in the date time while generating history.
//20/09/2017	Mohnish Chopra			Changes for Sonar issues
//31/10/2017	Shubhankur Manuja	Bug 73025 - Exit workitems are shown in Myqueue due to user diversion
//10/11/2017	Mohnish Chopra 		Prpd Bug 71568 - ProcessInstanceState changed to 1 when workitem is Reinitiated
//17/11/2017	Mohnish Chopra		Case Registeration changes --Support for urn in mailing template for Suspend workitem
//07/12/2017	Ambuj Tripathi		Bug#71971 merging :: Sessionid and other important input parameters to be added in output xml response of important APIs
//03/01/2018	Mohnish Chopra		Bug 74325 - EAP6.4+SQL: URN should be shown instead of Processinstanceid & label 'Workitem ID' should be URN or Registration No. in mail template.
//13-01-2018    Kumar Kimil         Sonar Cube-"PreparedStatement" and "ResultSet" methods should be called with valid indices
//16-01-2018    Sajid Khan          Merging Bug 73584 - Support to delete child workitems of a parent if System.deleteChildWorkitem trigger is executed on it .
//30/04/2018	Ambuj Tripathi		Bug 77354 - Workitem is shown with processinstance id instead of registration no at inclusive workstep. 
//21/11/2018	Ravi Ranjan			Bug 80146 - Task should be deleted if child workitem on case workdesk is deleted through delete on collect functionality 
//26/02/2018    Shubham Singla		Bug 83295 - Ibps 3.0 SP1+Oracle: IntroductionDateTime not getting converted into proper format in asynchronous case while distributing workitem
//11/03/2018	Ravi Ranjan			Bug 83488 - When a WI is adhoc routed to any workstep from case workdesk then its initiated tasks does not auto revoke
//28/06/2019    Shubham Singla      Bug 85475 - iBPS 4.0:Workitem needs to be distributed to all users having the rights on that queue except the user on which diversion is set when queue type is selected as permanent assignment in asynchronous mode.
//26/06/2018    Sourabh Tantuway    Bug 85436 - In case of asynchronous mode of server, for a child workitem, entry condition set parent data is not working if set and execute deletechildworkitem() condition is also present in entry settings. This is occurring for entry settings on decision workstep.
//10/12/2019	Ravi Ranjan Kumar PRDP Bug Merging(Bug 87270 - Handling done to execute product API's even if API name in input xml has different case.)
//12/12/2019    Sourabh Tantuway    Bug 89026 - iBPS 4.0 SP0: CreatedByName,Introducedbyid, introducedby and introductiondatetime are getting set 'null' for disctributed child workitems.
//04/02/2020	Ambuj Tripathi		Bug 90526 - Suspended Workitem list is not getting populated when user clicks on GO button in Resume suspended WI screen
//08/05/2020		Ravi Ranjan Kumar	Bug 92237 - iBPS 5 patch 1+JBOSS +SQL: Archive, Initiation, PFE and Mailing agent are not working 
//08/06/2020	Mohnish Chopra		Internal Bug - Incorrect transaction handling in case of Collecting workitems in Distribute flow.
//24/06/2020    Sourabh Tantuway    Bug 94268 - iBPS 4.0+Asynchronous: Variable aliases with Arabic characters are visible as question mark sign(??) on workitem list, for distributed workitems. It is working fine for Synchronous mode
//22/09/2020    Ravi Raj Mewara    Bug 94730 - iBPS 3.0 SP2 :Variable not getting set at Entry Settings when using deleteChildWorkitem() function in entry setting
//24/09/2020    Shubham Singla     Bug 94368 - iBPS 4.0 SP1: Wronq Queuename is coming when the workitem is getting routed to Case Queue and getting assigned to the user using Assigned To entry settings.Also "'" is coming in the beginning of QueueName.
//09//11/2020	Satyanarayan Sharma	Internal Bug- when workiten route to previous workstep and previous workstep is startWorkdesk than set processInstanceState to 1 instead of 2
//15/02/2021   Shubham Singla     Bug 98038 - iBPS 5.0:Activity name is not coming in workitem history when two worksteps are used consecutively.
//29/07/2022    Satyanarayan Sharma  Bug 113638 - iBPS5.0SP1+Postgre-Transcation getting discard on deletechildworkitem
//05/08/2022   Satyanarayan Sharma  Bug 113972 - iBPS5.0SP2-When InMomoryRouting disable parent workitem PreviousStage is setting as null when there are two nonuser workdesk.
//28/04/2023 Satyanarayan Sharma Bug 127809 - On CaseManager workdesk data and document rules should work on WFGetTaskList api call instead of  Task Initiation.
//23/06/2023	Vaishali Jain	Bug 131015 - iBPS5Spx - Handling in WFCompleteWorkitem API to delete the WFTaskStatusTable data on WI completion instead of deleting it in WI routing
//---------------------------------------------------------------------------------------------------

package com.newgen.omni.jts.txn.wapi;

import com.newgen.omni.jts.cmgr.*;
import com.newgen.omni.jts.dataObject.*;
import com.newgen.omni.jts.excp.*;
import com.newgen.omni.jts.srvr.*;
import com.newgen.omni.jts.util.*;
import com.newgen.omni.util.cal.*;
import com.newgen.omni.jts.util.EmailTemplateUtil;
import com.newgen.omni.jts.txn.wapi.common.*;

import java.sql.*;
import java.util.*;

import com.newgen.omni.jts.constt.WFSConstant;
import com.newgen.omni.jts.cache.CachedObjectCollection;

import java.io.File;

import com.newgen.omni.jts.constt.JTSConstant;
import com.newgen.omni.wf.util.data.Location;
import com.newgen.omni.wf.util.misc.WFConfigLocator;
import com.newgen.omni.wf.util.xml.api.CreateXML;


public class OraCreateWorkItem extends com.newgen.omni.jts.txn.NGOServerInterface {
//    implements com.newgen.omni.jts.txn.Transaction {
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
        if (("WMCreateWorkItem").equalsIgnoreCase(option)) {
            outputXml = WMCreateWorkitem(con, parser, gen);
        } else {
            outputXml = gen.writeError("CreateWorkItem", WFSError.WF_INVALID_OPERATION_SPECIFICATION, 0,
                                       WFSErrorMsg.getMessage(WFSError.WF_INVALID_OPERATION_SPECIFICATION), null, WFSError.WF_TMP);
        }
        return outputXml;
    }

    //----------------------------------------------------------------------------------------------------
    //	Function Name 						: WMCreateWorkitem
    //	Date Written (DD/MM/YYYY)			: 16/05/2002
    //	Author								: Prashant
    //	Input Parameters					: Connection , XMLParser , XMLGenerator
    //	Output Parameters					: none
    //	Return Values						: String
    //	Description							: Performs execution of Exit Rules for the Curent Activity ,
    //										  Triggers  and entry Settings for the Target Activity and
    //										  Rouetes the workItem by calling  CreateWorkItem
    //----------------------------------------------------------------------------------------------------
    //  Change Description          : Changes for Code Optimization-Merging of WorkFlow 
    //								  tables to WFInstrumentTable, logging of Query and removal of throw WFSException
    //  Changed by					: Shweta Singhal
    public String WMCreateWorkitem(Connection con, XMLParser parser,
                                   XMLGenerator gen) throws WFSException, JTSException {
        StringBuffer outputXML = null;
        PreparedStatement pstmt = null;
		Statement stmt = null;
        ResultSet rs = null;
        int mainCode = 0;
        int subCode = 0;
        String subject = null;
        String descr = null;
        String errType = WFSError.WF_TMP;
        int procInstState = 0;
        String exitStr = "";
        String engine= "";
        String option = parser.getValueOf("Option", "", false);
        long startTime = 0l;
        long endTime = 0l;
        String pinstId="";
        int workItemID = 0;
        int procDefID = 0;
        String previousActivityName="";
        int previousActivityId = 0;
        String targetActivityName = "";
        int targetActivityID = 0;
        WFParticipant participant=null;
        int count = -1;
        String retStr = "";
        boolean userDefVarFlag = true;
        HashMap opattr = null;
        boolean suspendWorkitem = false;
        int sessionID = 0;
        int userId = 0;
        boolean debug = false;
        HashMap timeElapsedInfoMap= new HashMap();
        String suspensionCause = "";
        String processedByStr = "";
        String userName = "";
        int childWorkItemID = 0;
        try {
            boolean adhoc = false;
             sessionID = parser.getIntOf("SessionId", 0, false);
             workItemID = parser.getIntOf("WorkItemID", 0, false);
             int queryTimeout = WFSUtil.getQueryTimeOut();
             pinstId = parser.getValueOf("ProcessInstanceID", "", false);
            String childProcessInstanceID = parser.getValueOf("ChildProcessInstanceID", "", true);
            int childProcessDefID = parser.getIntOf("ChildProcessDefID", 0, true);
            int childActivityID = parser.getIntOf("ChildActivityID", 0, true);
            childWorkItemID =  parser.getIntOf("ChildWorkItemID", 1, true);
             targetActivityID = parser.getIntOf("ActivityID", 0, false);
             targetActivityName = parser.getValueOf("ActivityName","",true);
            int streamId = parser.getIntOf("StreamID", 0, true);
            int psSessionId = parser.getIntOf("SessionId", 0, true); /*Bug # 5597*/
            char expired = parser.getCharOf("Expired", '\0', true);
            engine = parser.getValueOf("EngineName");
            int dbType = ServerProperty.getReference().getDBType(engine);
            char suspensionFlag = parser.getCharOf("SuspensionFlag", 'N', true);
             count = -1;
             if(suspensionFlag == 'Y'){
            	 suspensionCause = parser.getValueOf("SuspensionCause");
             }
             retStr = "";
             previousActivityId = parser.getIntOf("PrevActivityId", 0, true);
             previousActivityName = parser.getValueOf("PrevActivityName","",true);
             procDefID = parser.getIntOf("ProcessDefId", 0, true);
            int prevActivityType = parser.getIntOf("PrevActivityType", 0, true);
            char collectFlag = parser.getCharOf("CollectFlag", 'N', true);
            boolean deleteOnCollectFlag = (parser.getCharOf("DeleteOnCollectFlag", 'Y', true) == 'Y') ? true : false;
             userDefVarFlag = parser.getValueOf("UserDefVarFlag", "N", true).equalsIgnoreCase("Y");
            boolean debugFlag = parser.getValueOf("DebugFlag", "N", true).equalsIgnoreCase("Y");
            String strDeleteChildFlag = parser.getValueOf("DeleteChildWorkitem");
            boolean auditFlag = parser.getValueOf("AuditFlag", "N", true).equalsIgnoreCase("Y");
            int procVarId = parser.getIntOf("VariantId", 0, true);	//Process Variant Support Changes
			WFSUtil.printOut(engine,"[OraCreateWorkitem] WMCreateWorkitem() userDefVarFlag >> " + userDefVarFlag);
			
			WFSUtil.printOut(engine,"[OraCreateWorkitem] WMCreateWorkitem() userDefVarFlag >> " + userDefVarFlag);
			 participant = WFSUtil.WFCheckSession(con, sessionID);
            WFSUtil.printOut(engine,"Participant : " + participant + " collectFlag : " + collectFlag +
                                " suspensionFlag : " + suspensionFlag);
             debug = parser.getValueOf("DebugFlag", "N", true).equalsIgnoreCase("Y");
            boolean inMemoryFlag = parser.getValueOf("InMemoryFlag", "N", true).equalsIgnoreCase("Y");
            String assignType = parser.getValueOf("AssignMentType","N", true);
            String currWsName = parser.getValueOf("CurrentActivityName","", true);
            int targetActivityType = parser.getIntOf("ActivityType", 0, true);
            String targetActName = parser.getValueOf("ActivityName", "", true);
            ArrayList parameters = new ArrayList();
            String queryString = null;
            userId = 0;
            String strComments = parser.getValueOf("Comments", "", true);
            if (participant != null) {
                userName = participant.getname();
                //Changes to generate Log for In Memory Routing
				if(inMemoryFlag){
					XMLParser parser1 = new XMLParser(parser.getValueOf("RouteInfo"));
							//WFSUtil.printOut(engine,"DEBUGG :RouteInfo>>" + parser1.toString());
					generateLogForInMemRouting(con,parser1,engine,pinstId,workItemID,procDefID);
				}
                //OF Optimization
                userId = participant.getid();
                userName = participant.getname();
                //  Code for delete Child workitem.
                boolean bDeleteChild = strDeleteChildFlag.equals("Y") && workItemID != 1;
                boolean bDeleteAllChild = strDeleteChildFlag.equals("Y") && workItemID == 1; //To delete all child of the parent with workitemid 1
                adhoc = participant.gettype() == 'U';
                if(adhoc){
                    processedByStr = " , ProcessedBy = " + TO_STRING(userName, true, dbType) + "  , " + " LastProcessedBy = " + userId  ;
                }
                int adhocTargetActiivtyType = parser.getIntOf("ActivityType", 0, true);
                
                if(adhoc){
                    pstmt = con.prepareStatement("SELECT activityid , activityname,processdefId FROM WFINSTRUMENTTABLE  "+WFSUtil.getTableLockHintStr(dbType)+" WHERE ProcessInstanceID=? and workitemid=?");
                    pstmt.setString(1, pinstId);
                    pstmt.setInt(2, workItemID);
                    if(queryTimeout <= 0)
              			pstmt.setQueryTimeout(60);
                    else
              			pstmt.setQueryTimeout(queryTimeout);
                    pstmt.execute();
                    rs = pstmt.getResultSet();
                    int activityId=0;
                    String actName=null;
                    int procDefID1=0;
                    if (rs.next()) {
                    	activityId = rs.getInt("activityid");
                    	actName = TO_SANITIZE_STRING(rs.getString("activityname"),false);
                    	procDefID1 = rs.getInt("processdefId");
                    }
                    if(rs!=null){
                    	rs.close();
                    	rs=null;
                    }
                    if(pstmt!=null){
                    	pstmt.close();
                    	pstmt=null;
                    }
                    boolean isCaseWorkStep = false;
                    boolean allTasksCompleted = true;
                    isCaseWorkStep =WFSUtil.isCaseWorkStepActivity(con, dbType, procDefID1, activityId);
    				boolean generateCaseSummaryDoc =false;
                	if(isCaseWorkStep){
                	allTasksCompleted =WFSUtil.isCompletedAllTasks(con, dbType, pinstId, workItemID, procDefID1, activityId);
                	generateCaseSummaryDoc = WFSUtil.isGenerationCaseDocRequired(con,dbType,procDefID1, activityId);
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
                	}
                	if(generateCaseSummaryDoc){
                		WFSUtil.addToCaseSummaryQueue(con, dbType, procDefID1,pinstId, workItemID, activityId, actName);
                	}
                 }
                
                if(adhoc && workItemID > 1 && (adhocTargetActiivtyType == WFSConstant.ACT_EXT || adhocTargetActiivtyType == WFSConstant.ACT_DISCARD ))
                {
                    mainCode = WFSError.WM_INVALID_WORKITEM;
                    subCode = WFSError.WFS_CHILD_NOT_ADHOC_ROUTED;
                    subject = WFSErrorMsg.getMessage(mainCode);
                    descr = WFSErrorMsg.getMessage(subCode);
                    errType = WFSError.WF_TMP;
                }
                else if(adhoc && adhocTargetActiivtyType == WFSConstant.ACT_COLLECT)
                {
                    mainCode = WFSError.WF_INVALID_ACTIVITY_ID;
                    subCode = WFSError.WFS_NOT_ADHOC_ROUTED_TO_COLLECT;
                    subject = WFSErrorMsg.getMessage(mainCode);
                    descr = WFSErrorMsg.getMessage(subCode);
                    errType = WFSError.WF_TMP;
                }
                else if  (collectFlag == 'Y') {
                    /** Bug # WFS_6.1.2_065, Remove the workitem from
                     * system that having collectFlag Y - Ruhi Hira */
                    removeWorkitemFromSystem(con, pinstId, workItemID, dbType, debug, sessionID, userId, engine);
					//WFSUtil.generateLog(engine, con, WFSConstant.WFL_ChildWorkitemDeleted, pinstId, workItemID, procDefID,
					//previousActivityId, "", 0, 0, "", targetActivityID, "", null, null, null, null);
                    //if (bDeleteChild) {
                        WFSUtil.generateLog(engine, con,
 							WFSConstant.WFL_ChildProcessInstanceDeleted, pinstId, workItemID,
 							procDefID, previousActivityId, "", 0,
 							0, "", previousActivityId, "", null, null, null, null);
                    // }
               
                } else {
                    if (suspensionFlag == 'Y') { //Check if workitem is to be suspended....

                    	StringBuffer suspendStr = new StringBuffer();
                        suspendStr.append("<SuspendedWorkItemDetails>");
                        suspendStr.append("<ProcessDefId>").append(procDefID).append("</ProcessDefId>");
                        suspendStr.append("<ProcessName>").append(parser.getValueOf("ProcessName")).append("</ProcessName>");
                        suspendStr.append("<WorkItemName>").append(pinstId).append("</WorkItemName>");
                        suspendStr.append("<ProcessInstanceId>").append(pinstId).append("</ProcessInstanceId>");
                        suspendStr.append("<WorkItemId>").append(workItemID).append("</WorkItemId>");
                        suspendStr.append("<PrevActivityName>").append(previousActivityName).append("</PrevActivityName>");
                        suspendStr.append("<PrevActivityId>").append(previousActivityId).append("</PrevActivityId>");
                        suspendStr.append("<ActivityName>").append(parser.getValueOf("ActivityName")).append("</ActivityName>");
                        suspendStr.append("<ActivityId>").append(targetActivityID).append("</ActivityId>");
                        suspendStr.append("<AssignmentType>").append("P").append("</AssignmentType>");
                        suspendStr.append("<DebugFlag>").append(debug).append("</DebugFlag>");
                        suspendStr.append("<SessionId>").append(sessionID).append("</SessionId>");
                        suspendStr.append("<SuspensionCause>").append(suspensionCause).append("</SuspensionCause>");
                        suspendStr.append("</SuspendedWorkItemDetails>");
                        XMLParser suspendParser = new XMLParser(suspendStr.toString());
                        //suspendWorkItem(engine, con, participant, suspendParser, pinstId, workItemID, debug, sessionID, userId);
                        WFSUtil.suspendWorkItem(engine, con, participant, suspendParser);
                    } else {
                        if (bDeleteAllChild) {
                                removeWorkitemFromSystem(con, pinstId, workItemID, dbType, debug, sessionID, userId, engine);
                                WFSUtil.generateLog(engine, con,WFSConstant.WFL_ChildProcessInstanceDeleted, pinstId, workItemID,
                                procDefID, previousActivityId, "", 0,0, "", previousActivityId, "", null, null, null, null);
                        }
                        int userid = participant.getid();
                        String username = participant.getname();
                        if (participant.gettype() == 'P'){
                        	username = "System";
                        }
                        int prevActivityId = 0;
						/** 16/07/2008, Bugzilla Bug 5797, OF 7.2 onwards AssignedUser will not come in name value pair - Ruhi Hira */
                        String assgnToUser = parser.getValueOf("AssignedUser", "", true);						
                        int pworkItemID = 0;
                        //adhoc = participant.gettype() == 'U';
						String adhocStr = "";
						if(adhoc)
							adhocStr = " , AssignedUser = null "; 
                        //	---------------- SRU_5.0.1_004 -----------------
                        //----------------------------------------------------------------------------
                        // Changed By						: Ruhi Hira
                        // Reason / Cause (Bug No if Any)	:
                        // Change Description				: AttributeMap is initialized in the begining ....
                        //									  As Role / Assigned to user value is provided as Attribute
                        //									  with Name AssignedUser instead of AssignedToUser from PS
                        //									  Earlier AttributeMap was initialized conditionally along
                        //									  with parentAttributes. Also it was the previous version of PS
                        //									  that use to provide assignedToUser tag .. this is no longer
                        //									  in existance
                        //----------------------------------------------------------------------------

                        int start = parser.getStartIndex("Attributes", 0, 0);
                        int deadend = parser.getEndIndex("Attributes", start, 0);
                        int noOfAtt = parser.getNoOfFields("Attribute", start, deadend);
                        HashMap attributes = new HashMap();
                        int end = start;
                        String tempStr = "";

                        for (int i = 0; i < noOfAtt; i++) {
                            start = parser.getStartIndex("Attribute", end, 0);
                            end = parser.getEndIndex("Attribute", start, 0);
                            tempStr = parser.getValueOf("Name", start, end).trim();
                            attributes.put(tempStr.toUpperCase(), new WMAttribute(tempStr,
                                parser.getValueOf("Value", start, end), Integer.parseInt(parser.getValueOf("Type",
                                start, end))));
                            if (!adhoc) {
                                if (tempStr.equalsIgnoreCase("AssignedUser")) {
                                    // WFS_5.2.1_0003
                                    assgnToUser = parser.getValueOf("Value", start, end);
                                }
                            }
                        }
                        //	---------------- SRU_5.0.1_004 -----------------
                        // targetActivity can be zero for distribute type activity
                        if (targetActivityID == 0 && prevActivityType != WFSConstant.ACT_DISTRIBUTE) {
                            /*SrNo-12*/
                            HashMap map = (HashMap) CachedObjectCollection.getReference().getCacheObject(con, engine, procDefID, WFSConstant.CACHE_CONST_WFActivity, "").getData();
                            WFActivityInfo srcActvEventInfo = (WFActivityInfo) map.get(previousActivityId + "");
                            boolean eventWI = false;
                            if (srcActvEventInfo != null && !srcActvEventInfo.getEventId().equalsIgnoreCase("0")) {
                                eventWI = true;
                            }
                            // --------------------------------------------------------------------------------------
                            // Changed On  : 18/03/2005
                            // Changed By  : Ruhi Hira
                            // Description : SrNo-3; For a dangling workstep workitem should be in the same queue.
                            // --------------------------------------------------------------------------------------
                            String defaultQueueName = "";
                            String defaultQueueType = "";
                            int defaultQueueId = 0;
                            String defaultFilterValue = "";
                            int defaultStreamId = 0;

                            /*pstmt = con.prepareStatement(
                                " SELECT a.QueueName as queueName, a.QueueType as queueType, a.QueueId as queueId, a.FILTERVALUE as filterValue, b.StreamId as streamId" +
                                " FROM QUEUEDEFTABLE a , QUEUESTREAMTABLE b WHERE a.QueueID =  b.QueueID " +
                                " AND b.streamId = (SELECT streamId FROM STREAMDEFTABLE WHERE processDefId = ? " +
                                " AND ActivityId = ? AND UPPER(StreamName) = N'DEFAULT') AND b.ProcessDefID = ? " +
                                " AND b.ActivityID = ? ");*/
                            int res = 0;
                            pstmt = con.prepareStatement(
                                " SELECT a.QueueName as queueName, a.QueueType as queueType, a.QueueId as queueId, a.FILTERVALUE as filterValue, b.StreamId as streamId" +
                                " FROM QUEUEDEFTABLE a "+WFSUtil.getTableLockHintStr(dbType)+" , QUEUESTREAMTABLE b "+WFSUtil.getTableLockHintStr(dbType)+" WHERE a.QueueID =  b.QueueID " +
                                " AND b.streamId = (SELECT streamId FROM STREAMDEFTABLE "+WFSUtil.getTableLockHintStr(dbType)+" WHERE processDefId = ? " +
                                " AND ActivityId = ? AND " + TO_STRING("StreamName", false, dbType) + " = " + TO_STRING("DEFAULT", true, dbType) + " ) AND b.ProcessDefID = ? " + " AND b.ActivityID = ? ");
                            pstmt.setInt(1, procDefID);
                            pstmt.setInt(2, previousActivityId);
                            pstmt.setInt(3, procDefID);
                            pstmt.setInt(4, previousActivityId);

                            if(queryTimeout <= 0)
                      			pstmt.setQueryTimeout(60);
                            else
                      			pstmt.setQueryTimeout(queryTimeout);
                            rs = pstmt.executeQuery();
                            if (rs != null && rs.next()) {
                                defaultQueueName = rs.getString("QueueName");
                                defaultQueueType = rs.getString("QueueType");
                                defaultQueueId = rs.getInt("QueueId");
                                defaultFilterValue = rs.getString("FilterValue");
                                defaultStreamId = rs.getInt("StreamId");
                            }

                            if (rs != null) {
                                rs.close();
                                rs = null;
                            }
                            if (pstmt != null) {
                                pstmt.close();
                                pstmt = null;
                            }
                            con.setAutoCommit(false);
                            if (participant.gettype() == 'U') {
                            	queryString = "Select  ParentWorkItemId,ActivityName from WFInstrumentTable where ProcessInstanceID = ? and WorkItemId = ? and RoutingStatus = ?";
                                pstmt = con.prepareStatement(queryString);
                                WFSUtil.DB_SetString(1, pinstId, pstmt, dbType);
                                pstmt.setInt(2, workItemID);
                                WFSUtil.DB_SetString(3, "N", pstmt, dbType);
                                parameters.add(pinstId);
                                parameters.add(workItemID);
                                parameters.add("N");
                              } else {
                            	queryString = "Select  ParentWorkItemId,ActivityName from WFInstrumentTable where ProcessInstanceID = ? and WorkItemId = ?  and RoutingStatus = ? and LockStatus = ?";
                                pstmt = con.prepareStatement(queryString);
                                WFSUtil.DB_SetString(1, pinstId, pstmt, dbType);
                                pstmt.setInt(2, workItemID);
                                WFSUtil.DB_SetString(3, "Y", pstmt, dbType);
                                WFSUtil.DB_SetString(4, "Y", pstmt, dbType);
                                parameters.add(pinstId);
                                parameters.add(workItemID);
                                parameters.add("Y");
                                parameters.add("Y");
                            }
                            rs = WFSUtil.jdbcExecuteQuery(pinstId, psSessionId, userId, queryString, pstmt, parameters, debug, engine);
                            parameters.clear();
                            if (rs.next()) {
                            	pworkItemID = rs.getInt(1);
                                String prevActName = null;
								if(inMemoryFlag){
									 prevActName = previousActivityName;
								}
								else{
									 prevActName = rs.getString(2);
								}
								rs.close();
                                pstmt.close();
                                int parentAtt = 0;
                                HashMap pattributes = new HashMap();
                                if (pworkItemID > 0) {
                                    start = parser.getStartIndex("ParentAttributes", 0, 0);
                                    deadend = parser.getEndIndex("ParentAttributes", start, 0);
                                    parentAtt = parser.getNoOfFields("Attribute", start, deadend);
                                    end = start;
                                    tempStr = "";

                                    for (int i = 0; i < parentAtt; i++) {
                                        start = parser.getStartIndex("Attribute", end, 0);
                                        end = parser.getEndIndex("Attribute", start, 0);
                                        tempStr = parser.getValueOf("Name", start, end).trim();
                                        pattributes.put(tempStr.toUpperCase(), new WMAttribute(tempStr,
                                            parser.getValueOf("Value", start, end), Integer.parseInt(parser.getValueOf("Type",
                                            start, end))));
                                    }
                                }
                            
                            if ((prevActivityType == WFSConstant.ACT_RULE) || (prevActivityType == WFSConstant.ACT_EXPORT) ) { 
                              if (noOfAtt > 0) {
                                    if (!userDefVarFlag) {
                                        WFSUtil.setAttributes(con, participant, attributes, engine, pinstId, workItemID, gen, prevActName, true, psSessionId, debug);
                                        }
                                }
                                
                                if (userDefVarFlag) {
                                    WFSUtil.setAttributesExt(con, participant,  parser.getValueOf("Attributes"), engine, pinstId, workItemID, gen, prevActName, true, debug, false, psSessionId);
                                }
                                if (parentAtt > 0 && pworkItemID > 0) {
                                    if (!userDefVarFlag) {
                                        WFSUtil.setAttributes(con, participant, pattributes, engine, pinstId, pworkItemID, gen, null, true, psSessionId, debug);
                                    }
                                }
                                if (userDefVarFlag && pworkItemID > 0) {
                                    WFSUtil.setAttributesExt(con, participant, parser.getValueOf("ParentAttributes"), engine, pinstId, pworkItemID, gen, prevActName, true, debug, false, psSessionId);
                                }
                            }
                           } 
                            /** 01/02/1007, Bugzilla Bug 3766, Workitem moved to pendingWorkstep as
                             * dangling workstep can be a system workstep and utility will process
                             * the same workitem again and again. - Ruhi Hira */
                            /*SrNo-12*/
                            if (eventWI) {
                                // OF Optimization
                                queryString = "Delete from WFInstrumentTable where ProcessInstanceID = ? and WorkItemID = ? ";
                                pstmt = con.prepareStatement(queryString);
                                WFSUtil.DB_SetString(1, pinstId, pstmt, dbType);
                                pstmt.setInt(2, workItemID);
                                parameters.add(pinstId);
                                parameters.add(workItemID);
                                res = WFSUtil.jdbcExecuteUpdate(pinstId, sessionID, userId, queryString, pstmt, parameters, debug, engine);
                                parameters.clear();
                                pstmt.close();
//                                pstmt = con.prepareStatement("Delete from QueueDataTable where processInstanceId = ? and workitemId = ?");
//                                WFSUtil.DB_SetString(1, pinstId, pstmt, dbType);
//                                pstmt.setInt(2, workItemID);
//                                res = pstmt.executeUpdate();
//                                pstmt.close();
                            }else{
							//Process Variant Support Changes
                                //OF Optimization
                                queryString = "update WFInstrumentTable set Q_StreamId = ?,Q_QueueId = ?,FilterValue = ?,WorkItemState = ?,Statename = ?,LockStatus = ?,Queuename = ?,Queuetype = ?, RoutingStatus =? where ProcessInstanceID = ? and WorkItemID = ? ";
                                pstmt = con.prepareStatement(queryString);
                                pstmt.setInt(1, defaultStreamId);
                                pstmt.setInt(2, defaultQueueId);
                                if (dbType != JTSConstant.JTS_POSTGRES) {
                                    WFSUtil.DB_SetString(3,
                                                    defaultFilterValue == null ? ""
                                                                    : defaultFilterValue,
                                                    pstmt, dbType);
                            } else {
                                    if (defaultFilterValue == null
                                                    || ""
                                                                    .equals(defaultFilterValue))
                                            defaultFilterValue = "0";
                                    pstmt.setInt(3, Integer
                                                    .parseInt(defaultFilterValue));
                            }
                                pstmt.setInt(4, 6);
                                WFSUtil.DB_SetString(5, WFSConstant.WF_COMPLETED, pstmt, dbType);
                                WFSUtil.DB_SetString(6, "N", pstmt, dbType);
                                WFSUtil.DB_SetString(7, defaultQueueName == null ? "" : defaultQueueName, pstmt, dbType);
                                WFSUtil.DB_SetString(8, defaultQueueType == null ? "" : defaultQueueType, pstmt, dbType);
                                WFSUtil.DB_SetString(9, "R", pstmt, dbType);
                                WFSUtil.DB_SetString(10, pinstId, pstmt, dbType);
                                pstmt.setInt(11, workItemID);
                                parameters.add(defaultStreamId);
                                parameters.add(defaultQueueId);
                                parameters.add(defaultFilterValue == null ? "" : defaultFilterValue);
                                parameters.add(6);
                                parameters.add(WFSConstant.WF_COMPLETED);
                                parameters.add("N");
                                parameters.add(defaultQueueName == null ? "" : defaultQueueName);
                                parameters.add(defaultQueueType == null ? "" : defaultQueueType);
                                parameters.add("R");
                                parameters.add(pinstId);
                                parameters.add(workItemID);
                                res = WFSUtil.jdbcExecuteUpdate(pinstId, sessionID, userId, queryString, pstmt, parameters, debug, engine);
                                parameters.clear();
                                
//                                pstmt = con.prepareStatement("INSERT INTO PendingWorklisttable (ProcessInstanceId,WorkItemId," + " ProcessName,ProcessVersion,ProcessDefID,LastProcessedBy,ProcessedBy,ActivityName," + " ActivityId,EntryDateTime,ParentWorkItemId,AssignmentType,CollectFlag,PriorityLevel," + " ValidTill,Q_StreamId,Q_QueueId,Q_UserId,AssignedUser,FilterValue,CreatedDateTime," + " WorkItemState,Statename,ExpectedWorkitemDelay,PreviousStage,LockStatus," + " Queuename,Queuetype,NotifyStatus, ProcessVariantId)" + " Select ProcessInstanceId,WorkItemId," + " ProcessName,ProcessVersion,ProcessDefID,LastProcessedBy,ProcessedBy,ActivityName," + " ActivityId,EntryDateTime,ParentWorkItemId," + "AssignmentType,CollectFlag,PriorityLevel," + "ValidTill," + defaultStreamId + "," + defaultQueueId + ",Q_UserId,AssignedUser, " + TO_STRING((defaultFilterValue == null ? "" : defaultFilterValue), true, dbType) + ",CreatedDateTime," + "6 , " /*Statename*/ + TO_STRING(WFSConstant.WF_COMPLETED, true, dbType) + " , ExpectedWorkitemDelay, PreviousStage, " + TO_STRING("N", true, dbType) + " , " + TO_STRING((defaultQueueName == null ? "" : defaultQueueName), true, dbType) + " , " + TO_STRING((defaultQueueType == null ? "" : defaultQueueType), true, dbType) + " , NotifyStatus, ProcessVariantId from WorkwithPStable" + " where ProcessInstanceID = ? and WorkItemID = ? ");
//                                WFSUtil.DB_SetString(1, pinstId, pstmt, dbType);
//                                pstmt.setInt(2, workItemID);
//                                res = pstmt.executeUpdate();
                                pstmt.close();
                            }
                            if (res > 0) {
//                                pstmt = con.prepareStatement("Delete from  WorkwithPStable where ProcessInstanceID = ? and WorkItemID = ? ");
//                                WFSUtil.DB_SetString(1, pinstId, pstmt, dbType);
//                                pstmt.setInt(2, workItemID);
//                                int f = pstmt.executeUpdate();
//                                pstmt.close();
//                                if (f == res) {
                                    if (!con.getAutoCommit()) {
                                        con.commit();
                                        con.setAutoCommit(true);
                                    }
//                                } else {
//                                    if (!con.getAutoCommit()) {
//                                        con.rollback();
//                                        con.setAutoCommit(true);
//                                    }
//                                }
                            } else {
                                if (!con.getAutoCommit()) {
                                    con.rollback();
                                    con.setAutoCommit(true);
                                }
                            }
                            if(!eventWI){
                                retStr = "<Comment>Invalid target activityId = 0</Comment>";
                            }
                        } else {
                            // Only single query will be executed and as per participant type  set userid --SHWETA
                            if (participant.gettype() == 'U') {
                                /*System.out.println("Select ProcessDefId,ActivityID,AssignmentType,ParentWorkItemId,CreatedDatetime,ActivityName, " + TO_STRING("Worklisttable", true, dbType) + " ,Q_QueueId, ExpectedWorkitemDelay, EntryDatetime," + WFSUtil.getDate(dbType) + "," +
                                        "LockedTime, processedBy, CreatedDateTime, ProcessName, ProcessVersion, LastProcessedBy , CollectFlag, PriorityLevel, WorkitemState, StateName, ProcessVariantId from Worklisttable " + " where ProcessInstanceID = " + TO_STRING(pinstId, true, dbType) + " and WorkItemId = " + workItemID 
									+ " UNION Select ProcessDefId,ActivityID,AssignmentType,ParentWorkItemId,CreatedDatetime,ActivityName, " + TO_STRING("WorkinProcesstable", true, dbType) + " ,Q_QueueId, ExpectedWorkitemDelay, EntryDatetime, " + WFSUtil.getDate(dbType) + "," +
                                        "LockedTime, processedBy, CreatedDateTime, ProcessName, ProcessVersion, LastProcessedBy , CollectFlag, PriorityLevel, WorkitemState, StateName, ProcessVariantId from WorkinProcesstable " + " where ProcessInstanceID = " + TO_STRING(pinstId, true, dbType) + " and WorkItemId = " + workItemID 
									+ " UNION Select ProcessDefId,ActivityID,AssignmentType,ParentWorkItemId,CreatedDatetime,ActivityName, " + TO_STRING("PendingWorkListTable", true, dbType) + " ,Q_QueueId, ExpectedWorkitemDelay, EntryDatetime, " + WFSUtil.getDate(dbType) + "," +
                                        "LockedTime, processedBy, CreatedDateTime, ProcessName, ProcessVersion, LastProcessedBy , CollectFlag, PriorityLevel, WorkitemState, StateName, ProcessVariantId from PendingWorkListTable " + " where ProcessInstanceID = " + TO_STRING(pinstId, true, dbType) + " and WorkItemId = " + workItemID);*/
										//Process Variant Support Changes
                                //OF Optimization
                                queryString = " Select ProcessDefId,ActivityID,AssignmentType,ParentWorkItemId,CreatedDatetime,ActivityName," + TO_STRING("WFInstrumentTable", true, dbType) + ", "
                                    + "Q_QueueId, ExpectedWorkitemDelay, EntryDatetime, " + WFSUtil.getDate(dbType) + ",LockedTime, "
                                    + "processedBy, CreatedDateTime, ProcessName, ProcessVersion, LastProcessedBy , CollectFlag, PriorityLevel,"
                                    + " WorkitemState, StateName, ProcessVariantId, RoutingStatus , PreviousStage from WFInstrumentTable  where "
                                    + "ProcessInstanceID = ? and WorkItemId = ? and RoutingStatus in('N','R')";
                                pstmt = con.prepareStatement(queryString);
                                WFSUtil.DB_SetString(1, pinstId, pstmt, dbType);
                                pstmt.setInt(2, workItemID);
                                //WFSUtil.DB_SetString(3, "Y", pstmt, dbType);
                                parameters.add(pinstId);
                                parameters.add(workItemID);
                                //parameters.add("Y");
                                
//                                pstmt = con.prepareStatement(
//									" Select ProcessDefId,ActivityID,AssignmentType,ParentWorkItemId,CreatedDatetime,ActivityName, " + TO_STRING("Worklisttable", true, dbType) + " ,Q_QueueId, ExpectedWorkitemDelay, EntryDatetime," + WFSUtil.getDate(dbType) + "," +
//                                        "LockedTime, processedBy, CreatedDateTime, ProcessName, ProcessVersion, LastProcessedBy , CollectFlag, PriorityLevel, WorkitemState, StateName, ProcessVariantId from Worklisttable " + " where ProcessInstanceID = " + TO_STRING(pinstId, true, dbType) + " and WorkItemId = " + workItemID 
//									+ " UNION Select ProcessDefId,ActivityID,AssignmentType,ParentWorkItemId,CreatedDatetime,ActivityName, " + TO_STRING("WorkinProcesstable", true, dbType) + " ,Q_QueueId, ExpectedWorkitemDelay, EntryDatetime, " + WFSUtil.getDate(dbType) + "," +
//                                        "LockedTime, processedBy, CreatedDateTime, ProcessName, ProcessVersion, LastProcessedBy , CollectFlag, PriorityLevel, WorkitemState, StateName, ProcessVariantId from WorkinProcesstable " + " where ProcessInstanceID = " + TO_STRING(pinstId, true, dbType) + " and WorkItemId = " + workItemID 
//									+ " UNION Select ProcessDefId,ActivityID,AssignmentType,ParentWorkItemId,CreatedDatetime,ActivityName, " + TO_STRING("PendingWorkListTable", true, dbType) + " ,Q_QueueId, ExpectedWorkitemDelay, EntryDatetime, " + WFSUtil.getDate(dbType) + "," +//WFS_8.0_141
//                                        "LockedTime, processedBy, CreatedDateTime, ProcessName, ProcessVersion, LastProcessedBy , CollectFlag, PriorityLevel, WorkitemState, StateName, ProcessVariantId from PendingWorkListTable " + " where ProcessInstanceID = " + TO_STRING(pinstId, true, dbType) + " and WorkItemId = " + workItemID);
                            } else {
                                /*System.out.println("Select ProcessDefId,ActivityID,AssignmentType,ParentWorkItemId,CreatedDatetime,ActivityName, " + TO_STRING("WorkwithPStable", true, dbType) + " ,Q_QueueId, ExpectedWorkitemDelay, EntryDatetime," + WFSUtil.getDate(dbType) + "," +
                                        "LockedTime, processedBy, CreatedDateTime, ProcessName, ProcessVersion, LastProcessedBy , CollectFlag, PriorityLevel, WorkitemState, StateName, ProcessVariantId from WorkwithPStable " + " where ProcessInstanceID = " + TO_STRING(pinstId, true, dbType) + " and WorkItemId = " + workItemID);*/
                                //Process Variant Support Changes
                                //OF Optimization
                                queryString = "Select ProcessDefId,ActivityID,AssignmentType,ParentWorkItemId,CreatedDatetime,ActivityName," + TO_STRING("WFInstrumentTable", true, dbType) + ", "
                                + " Q_QueueId, ExpectedWorkitemDelay, EntryDatetime," + WFSUtil.getDate(dbType) + ",LockedTime, processedBy, "
                                + "CreatedDateTime, ProcessName, ProcessVersion, LastProcessedBy , CollectFlag, PriorityLevel, WorkitemState, "
                                + "StateName, ProcessVariantId, RoutingStatus, PreviousStage from WFInstrumentTable where ProcessInstanceID = ? and WorkItemId = ? "
                                + "and RoutingStatus = ? and LockStatus = ?";
                                pstmt = con.prepareStatement(queryString);
                                WFSUtil.DB_SetString(1, pinstId, pstmt, dbType);
                                pstmt.setInt(2, workItemID);
                                WFSUtil.DB_SetString(3, "Y", pstmt, dbType);
                                WFSUtil.DB_SetString(4, "Y", pstmt, dbType);
                                parameters.add(pinstId);
                                parameters.add(workItemID);
                                parameters.add("Y");
                                parameters.add("Y");
                            }   
                            rs = WFSUtil.jdbcExecuteQuery(pinstId, sessionID, userId, queryString, pstmt, parameters, debug, engine);
                            parameters.clear();
                            //pstmt.execute();
                            //rs = pstmt.getResultSet();
                            if (rs.next()) {
                                procDefID = rs.getInt(1);
                                if(inMemoryFlag){
                                        prevActivityId = previousActivityId;
                                }	
                                else{
                                        prevActivityId = rs.getInt(2);
                                }
                                retStr = rs.getString(3);
								String assignmenttype = retStr; //WFS_8.0_124
                                char rState = rs.wasNull() ? 'Y' : retStr.charAt(0);
                                retStr = "";
                                pworkItemID = rs.getInt(4);
                                String date = rs.getString(5);
                                date = rs.wasNull() ? "" : WFSUtil.TO_DATE(date, true, dbType);
                                String prevActName = null;
                                if(inMemoryFlag){
                                         prevActName = previousActivityName;
                                }
                                else{
                                         prevActName = rs.getString(6);
                                }
                                String adhoctable = rs.getString(7);
                                int qId = rs.getInt(8);
                                String expectedWkDelay = rs.getString(9);
                                String entryDateTime = rs.getString(10);

                                String currentDate = rs.getString(11);
                                String lockedTime = rs.getString(12);
                                String processedBy = rs.getString(13);
                                String createdDateTime = rs.getString(14);
                                String processName = rs.getString(15);
                                String processVersion = rs.getString(16);
                                String lastProcessedBy = rs.getString(17);
                                String collectFlag1 = rs.getString(18);
                                String priorityLevel = rs.getString(19);
                                String wiState = rs.getString(20);
                                String stateName = rs.getString(21); 
                                procVarId = rs.getInt(22);
                                String routeStatus = rs.getString(23); 
                             
                                if(prevActivityType == WFSConstant.ACT_RULE ||  prevActivityType == WFSConstant.ACT_DISTRIBUTE||prevActivityType == WFSConstant.ACT_COLLECT || prevActivityType == WFSConstant.ACT_EXPORT ){
                               	 prevActName = rs.getString("PreviousStage");
                             
                               }
                                rs.close();
                                pstmt.close();
                                
                                //  Call to create Child workitem.  Abhishek.
                                WFSUtil.printOut(engine,"Before createChildWorkitem : ");
                                StringBuffer preActivityBuffer = new StringBuffer();
                                StringBuffer postActivityBuffer = new StringBuffer();
                                preActivityBuffer.append(",").append(WFSUtil.appendDBString(processName)).
                                        append(",").append(processVersion).append(",").append(procDefID).
                                        append(",").append(lastProcessedBy).append(",").append(WFSUtil.appendDBString(processedBy)).
                                        append(",").append(WFSUtil.TO_DATE(currentDate, true, dbType)).append(",").append(WFSUtil.appendDBString(collectFlag1)).
                                        append(",").append(priorityLevel).append(",").append("null, 0, 0, 0, null, null").
                                        append(",").append(WFSUtil.TO_DATE(createdDateTime, true, dbType)).append(",").append(wiState).
                                        append(",").append(WFSUtil.appendDBString(stateName)).append(",").append("null, ");
                                postActivityBuffer.append(", null, 'N', null");
                                XMLParser parser1 = new XMLParser(parser.getValueOf("CreateChildWorkitem"));
								int startex = parser1.getStartIndex("Activities", 0, 0);
								int deadendex = parser1.getEndIndex("Activities", startex, 0);
								int iActivityCount = parser1.getNoOfFields("Activity", startex, deadendex);
								int endEx = 0;
                                WFSUtil.printOut(engine,"iActivityCount : " + iActivityCount);
								String strActivityName = null;
                                String strActivityId=null;
								int currWorkitemId = 0;
								con.setAutoCommit(false);
								try{
									for(int i = 1;i <= iActivityCount; i++){
										startex = parser1.getStartIndex("Activity", endEx, 0);
										endEx = parser1.getEndIndex("Activity", startex, 0);
										strActivityName = parser1.getValueOf("ActivityName",startex,endEx);
										strActivityId=parser1.getValueOf("ActivityId",startex,endEx);
										String attributeXml = parser1.getValueOf("Attributes",startex,endEx);
										boolean generateSameParent = parser1.getValueOf("GenerateSameParent",startex,endEx).equalsIgnoreCase("Y");
										if(generateSameParent  && pworkItemID > 0){
											currWorkitemId = pworkItemID;
										} else {
											currWorkitemId = workItemID;
										}
										WFSUtil.printOut(engine,"Inside for loop :");
										WFSUtil.printOut(engine,"ActivityName : " + strActivityName);
										StringBuffer parentWIPropBuffer = new StringBuffer();
										parentWIPropBuffer.append(preActivityBuffer).append(WFSUtil.appendDBString(strActivityName)).append(postActivityBuffer);
										WFSUtil.printOut(engine,"parentWIPropBuffer : " + parentWIPropBuffer);
										int newWIId = WFSUtil.createChildWorkitem(con, engine, pinstId, currWorkitemId,
												strActivityName, strActivityId,procDefID, dbType, parentWIPropBuffer.toString(), attributeXml, participant, debug, sessionID);
										WFSUtil.printOut(engine,"New workitem Id : " + newWIId);
									}
								}catch(SQLException se){//Bug 40704
									con.rollback();
								}
                                //  createChildWorkitem Ends here.

                                
                                int parentAtt = 0;
                                HashMap pattributes = new HashMap();
                                if (!(assignmenttype.equalsIgnoreCase("E") && participant.gettype() == 'U' )) { //WFS_8.0_124 && "SOMETHHING"
								//if (!(assignmenttype.equalsIgnoreCase("E") && (adhoctable.equalsIgnoreCase("Worklisttable") || adhoctable.equalsIgnoreCase("WorkinProcesstable")))) { //WFS_8.0_124
                                if (pworkItemID > 0) {
                                    start = parser.getStartIndex("ParentAttributes", 0, 0);
                                    deadend = parser.getEndIndex("ParentAttributes", start, 0);
                                    parentAtt = parser.getNoOfFields("Attribute", start, deadend);
                                    end = start;
                                    tempStr = "";

                                    for (int i = 0; i < parentAtt; i++) {
                                        start = parser.getStartIndex("Attribute", end, 0);
                                        end = parser.getEndIndex("Attribute", start, 0);
                                        tempStr = parser.getValueOf("Name", start, end).trim();
                                        pattributes.put(tempStr.toUpperCase(), new WMAttribute(tempStr,
                                            parser.getValueOf("Value", start, end), Integer.parseInt(parser.getValueOf("Type",
                                            start, end))));
                                    }
                                }


                                String cliIntrfc = parser.getValueOf("ClientInterface", "", true);
                                String srvrIntrc = parser.getValueOf("ServerInterface", "", true);
                                String appExecFlag = parser.getValueOf("AppExecutionFlag", null, true);
                                appExecFlag = (appExecFlag == null) ? "W" : appExecFlag.trim();

                                con.setAutoCommit(false);

//                                HashMap opattr = (HashMap) (WFSUtil.fetchAttributes(con, pinstId, workItemID, "", engine,
//                                    dbType, gen, "", true, participant.gettype() == 'P', sessionID, userId, debug));//No need to call fetchAttributes--Shweta Singhal

                                StringBuffer queueId = new StringBuffer("0");

                                //WFS_6.1.2_055	--override the values for teh set attributes in the fetchattributes....
                                Iterator iter = null;
                                iter = attributes.values().iterator();
                                while (iter.hasNext()) {
                                    WMAttribute iattr = (WMAttribute) (iter.next());
//                                    opattr.put(iattr.name.toUpperCase(), iattr);
                                }
                                //WFS_6.1.2_055	--override the values for teh set attributes in the fetchattributes....

                                // ----------  Bug No WSE_I_5.0.1_697 -----------
                                // if (prevActivityType == WFSConstant.ACT_RULE) {	//WFS_6.1.2_056
                                //SrNo-10
                                if ((prevActivityType == WFSConstant.ACT_RULE) || (prevActivityType == WFSConstant.ACT_EXPORT) || ((prevActivityId == targetActivityID) && (prevActivityType == WFSConstant.ACT_DISTRIBUTE))) { //WFS_6.1.2_056 //WFS_6.1.2_062
                                    
                                    if (noOfAtt > 0) {
                                        if (!userDefVarFlag) {
                                            WFSUtil.setAttributes(con, participant, attributes, engine, pinstId, workItemID, gen, prevActName, false, sessionID, debug);
                                        }
                                    } 
									/** 03/04/2008, Bugzilla Bug 5488, Set command in entry settings does not execute. - Ruhi Hira */
									if (userDefVarFlag) {
                                    	/** 17/06/2008, SrNo-11, New feature : user defined complex data type support [OF 7.2] - Ruhi Hira */
//                                        String attributeXML = parser.getValueOf("Attributes");
//                                        attributeXML = "<Attributes>" + attributeXML + "</Attributes>";
//                                        ArrayList attribList = WFXMLUtil.convertXMLToObject(attributeXML, engine);	
                                        WFSUtil.setAttributesExt(con, participant, parser.getValueOf("Attributes"), engine, pinstId, workItemID, gen, prevActName, false, debug, false, sessionID,timeElapsedInfoMap, true);
										//WFSUtil.setAttributesExt(con, participant, parser.getValueOf("Attributes"), engine, pinstId, workItemID, gen, prevActName, false, debugFlag, false);
                                    }
                                    if (parentAtt > 0 && pworkItemID > 0   && collectFlag != 'X') {
                                        if (!userDefVarFlag) {
                                            WFSUtil.setAttributes(con, participant, pattributes, engine, pinstId, pworkItemID, gen, prevActName, false, sessionID, debug);
                                        }
                                    }
									if (pworkItemID > 0 && userDefVarFlag   && collectFlag != 'X') { 
//                                        String attributeXML = parser.getValueOf("ParentAttributes");
//                                        attributeXML = "<Attributes>" + attributeXML + "</Attributes>";
//                                        ArrayList attribList = WFXMLUtil.convertXMLToObject(attributeXML, engine);
                                        WFSUtil.setAttributesExt(con, participant, parser.getValueOf("ParentAttributes"), engine, pinstId, pworkItemID, gen, prevActName, false, debug, false, sessionID,timeElapsedInfoMap, true);
                                      
										//WFSUtil.setAttributesExt(con, participant, parser.getValueOf("ParentAttributes"), engine, pinstId, pworkItemID, gen, prevActName, false, debugFlag, false);
									}
                                }

                                if (targetActivityType == WFSConstant.ACT_SUBPROC) {
                                    spawnProcess(engine, con,participant, pinstId, workItemID, targetActivityID, procDefID,
                                            targetActName, adhoc, parser, procDefID, prevActivityId,adhoctable, prevActName,
                                            currentDate, childProcessInstanceID, childWorkItemID,childProcessDefID, childActivityID,sessionID,userId,debug);

                                    //retStr = "<Node><ProcInstance>" + retStr + "</ProcInstance><WorkItem>1</WorkItem><WorkStep>" + targetActivityID + "</WorkStep><ProcDefId>" + procDefID + "</ProcDefId></Node>";
                                } else if (!cliIntrfc.equals("") && srvrIntrc.startsWith("Y")) {
                                    // --------------------------------------------------------------------------------------
                                    // Changed On  : 08/03/2005
                                    // Changed By  : Ruhi Hira
                                    // Description : SrNo-1; Omniflow 6.0; Feature: DynamicRuleModification
                                    //				    parser passed to createWorkitem, so as to fetch expiry data.
                                    // --------------------------------------------------------------------------------------
                                    count = createWorkitem(parser, engine, con, workItemID, pinstId, targetActivityID, procDefID,
                                        prevActivityId, cliIntrfc, targetActName, targetActivityType, targetActName, adhoc,
                                        adhoctable, streamId, currentDate, debug, sessionID, userId,processedByStr);
                                } else {
                                    count = createWorkitem(engine, con, parser, workItemID, pinstId, targetActivityID, procDefID,
                                        prevActivityId, prevActName, prevActivityType, date, targetActivityType, adhoc, assgnToUser, streamId,
                                        false, pworkItemID, targetActName, adhoctable, expectedWkDelay,
                                        entryDateTime, currentDate, lockedTime,
                                        processedBy, createdDateTime, queueId, participant.gettype() == 'P' ? "System" : participant.getname(), participant.getid(),
                                        deleteOnCollectFlag, debug, sessionID, userId, routeStatus,noOfAtt, attributes, userDefVarFlag, gen,assignType, currWsName,processedByStr,childProcessInstanceID,childProcessDefID,childActivityID );
                                }
								/* put the code of setexternaldata here*/							
																
								int iExceptionBegin = parser.getStartIndex("Exceptions", 0, Integer.MAX_VALUE);
                                int iExceptionEnd = parser.getEndIndex("Exceptions", 0, Integer.MAX_VALUE);
                                int iExcepCount = parser.getNoOfFields("Exception", iExceptionBegin, iExceptionEnd);
                                end = 0;
                                XMLParser excepParser = new XMLParser();
                                XMLGenerator excepGen = new XMLGenerator();
                                /*Bug # 5597*/    
                                if (iExcepCount > 0) {
                                    StringBuffer outputXmlBuf = new StringBuffer(500);
                                    outputXmlBuf.append("<Option>WFSetExternalData</Option>");
                                    outputXmlBuf.append("<EngineName>" + engine + "</EngineName>");
                                    outputXmlBuf.append("<SessionId>" + psSessionId + "</SessionId>");
                                    outputXmlBuf.append("<ProcessDefinitionID>" + procDefID + "</ProcessDefinitionID>");
                                    outputXmlBuf.append("<ActivityID>" + prevActivityId + "</ActivityID>");
                                    outputXmlBuf.append("<ProcessInstanceID>" + pinstId + "</ProcessInstanceID>");
                                    outputXmlBuf.append("<WorkItemID>" + workItemID + "</WorkItemID>");
                                    outputXmlBuf.append("<Exceptions>");
                                    for (int iCount = 0; iCount < iExcepCount; ++iCount) {
                                        iExceptionBegin = parser.getStartIndex("Exception", end, 0);
                                        end = parser.getEndIndex("Exception", iExceptionBegin, 0);  
                                        
                                        outputXmlBuf.append("<Exception>");
                                        outputXmlBuf.append("<ExceptionDefIndex>" +
                                                parser.getValueOf("id", iExceptionBegin, end) +
                                                "</ExceptionDefIndex>");
                                        outputXmlBuf.append("<ExceptionDefName>" +
                                                parser.getValueOf("ExceptionName", iExceptionBegin, end) +
                                                "</ExceptionDefName>");
                                        outputXmlBuf.append("<ExceptionActivityId>" +
                                                parser.getValueOf("ExceptionActivityId", iExceptionBegin, end) +
                                                "</ExceptionActivityId>");
                                        outputXmlBuf.append("<ExceptionActivityName>" +
                                                parser.getValueOf("ExceptionActivityName", iExceptionBegin, end) +
                                        "</ExceptionActivityName>");
                                        outputXmlBuf.append("<ExceptionComments>" +
                                                parser.getValueOf("Comments", iExceptionBegin, end) +
                                                "</ExceptionComments>");
                                        outputXmlBuf.append("<Status>" +
                                                parser.getValueOf("Attribute", iExceptionBegin,
                                                end) + "</Status>");
                                        outputXmlBuf.append("</Exception>");
                                    }
                                    outputXmlBuf.append("</Exceptions>");
                                    try {
                                        excepParser.setInputXML(outputXmlBuf.toString());
                                        // Bugzilla Bug 687, Custom Interface Support. - Ruhi Hira (May 12th 2007)
                                        startTime = System.currentTimeMillis();
                                        String strOUT = WFFindClass.getReference().execute("WFSetExternalData", engine, con, excepParser, excepGen);
                                        endTime = System.currentTimeMillis();
                                        if(debug)
                                            WFSUtil.writeLog("OraCreateWorkItem", "OraCreateWorkItem_WFSetExternalData", startTime, endTime, 0, "", "", engine,(endTime-startTime),sessionID, userId);  
                                        excepParser.setInputXML(strOUT);

                                        int errorCode = excepParser.getIntOf("SubCode",
                                            WFSError.WF_OPERATION_FAILED, true);
                                    } catch (Exception e) {
                                        WFSUtil.printErr(engine,"", e);
                                    }
                                }
								
                                // if (prevActivityType != WFSConstant.ACT_RULE) {	//WFS_6.1.2_056
                                //SrNo-10
                                if (!((prevActivityType == WFSConstant.ACT_RULE) || (prevActivityType == WFSConstant.ACT_EXPORT) || ((prevActivityId == targetActivityID) && (prevActivityType == WFSConstant.ACT_DISTRIBUTE)))) { //WFS_6.1.2_056 //WFS_6.1.2_062
                                if(targetActivityType != WFSConstant.ACT_COLLECT && targetActivityType != WFSConstant.ACT_DISCARD  && targetActivityType != WFSConstant.ACT_EXT ) //setAttribute will be called from createWorkitem() for target activity as Exit or Discard
						        //if(targetActivityType != WFSConstant.ACT_COLLECT && !(targetActivityType == WFSConstant.ACT_DISCARD && workItemID > 1) )//WFS_8.0_056 //Bugzilla Bug 12344
						        {
                                    if (noOfAtt > 0) {
                                        if (!userDefVarFlag) {
                                            WFSUtil.setAttributes(con, participant, attributes, engine, pinstId, workItemID, gen, targetActName, false,sessionID, debug);
                                        }
                                    }
                                    if (userDefVarFlag) {
										/** 17/06/2008, SrNo-11, New feature : user defined complex data type support [OF 7.2] - Ruhi Hira */
//                                        String attributeXML = parser.getValueOf("Attributes");
//                                        attributeXML = "<Attributes>" + attributeXML + "</Attributes>";
//                                        ArrayList attribList = WFXMLUtil.convertXMLToObject(attributeXML, engine);	
                                        WFSUtil.setAttributesExt(con, participant, parser.getValueOf("Attributes"), engine, pinstId, workItemID, gen, targetActName, false, debug, false, sessionID,timeElapsedInfoMap, true);
										//WFSUtil.setAttributesExt(con, participant, parser.getValueOf("Attributes"), engine, pinstId, workItemID, gen, targetActName, false, debugFlag, false);
									}
						        }
                                    if (parentAtt > 0 && pworkItemID > 0 && collectFlag != 'X') {
                                        if (!userDefVarFlag) {
                                            WFSUtil.setAttributes(con, participant, attributes, engine, pinstId, workItemID, gen, targetActName, false,sessionID, debug);
                                        }
                                    }
									if (userDefVarFlag && pworkItemID > 0  && collectFlag != 'X') {
//                                        String attributeXML = parser.getValueOf("ParentAttributes");
//                                        attributeXML = "<Attributes>" + attributeXML + "</Attributes>";
//                                        ArrayList attribList = WFXMLUtil.convertXMLToObject(attributeXML, engine);	
										WFSUtil.setAttributesExt(con, participant, parser.getValueOf("ParentAttributes"), engine, pinstId, pworkItemID, gen, targetActName, false, debug, false, sessionID,timeElapsedInfoMap, true);
                                        //WFSUtil.setAttributesExt(con, participant, parser.getValueOf("ParentAttributes"), engine, pinstId, pworkItemID, gen, targetActName, false, debugFlag, false);
									}
                                }
								
								 /* Add entries to MailQueue if any send by PS*/ 
								NGXmlList mailList = parser.createList("MailQueueData", "MailItem");
                                String mailData = null;
								XMLParser parser2 = new XMLParser();
                                for (mailList.reInitialize(); mailList.hasMoreElements(); mailList.skip()) {
									mailData = mailList.getVal("MailItem");
									parser2.setInputXML(mailData);
									WFSUtil.addToMailQueue(username, con, parser2, gen) ;
                                }
								

                                if (targetActivityType == WFSConstant.ACT_EXT || targetActivityType == WFSConstant.ACT_DISCARD) {
                                	boolean skipQuery = true;
                                	StringBuilder sQuery = new StringBuilder();
                                  	sQuery.append("SELECT 1 FROM IMPORTEDPROCESSDEFTABLE").append(WFSUtil.getTableLockHintStr(dbType));
                                  	pstmt = con.prepareStatement(sQuery.toString());
                                  	if(queryTimeout <= 0)
                              			pstmt.setQueryTimeout(60);
                                    else
                              			pstmt.setQueryTimeout(queryTimeout);
                                  	rs = pstmt.executeQuery();
                                  	if (rs != null && rs.next()) 
                                  		skipQuery = false; 
                                  	else
                                  		skipQuery = true;
                                  	
                                  	if(rs!=null){
                                  		rs.close();
                                  		rs=null;
                                  	}
                                  	if(pstmt!=null){
                                  		pstmt.close();
                                  		pstmt=null;
                                  	}
                                  	if(!skipQuery){   //optimization to skip unnecessary execution of query
	                                	if(!adhoc){
		                                	queryString = "SELECT ProcessInstanceId, WorkItemId, RoutingStatus, ProcessDefId, ActivityId, ActivityName FROM WFInstrumentTable " + WFSUtil.getTableLockHintStr(dbType) + " WHERE ChildProcessInstanceId = ? and ChildWorkItemId = ?";
		                                    pstmt = con.prepareStatement(queryString);
		                                    WFSUtil.DB_SetString(1, pinstId, pstmt, dbType);
		                                    pstmt.setInt(2, workItemID);
		                                    parameters.addAll(Arrays.asList(pinstId, workItemID));
		                                    rs = WFSUtil.jdbcExecuteQuery(pinstId, sessionID, userId, queryString, pstmt, parameters, debugFlag, engine);
		                                    parameters.clear();
		                                    if (rs != null && rs.next()) {
		                                        String sParentProcessInstanceId = rs.getString(1);
		                                        int iParentWorkItemId = rs.getInt(2);
		                                        String sParentRoutingStatus = rs.getString(3);
		                                        int iParentProcessDefId = rs.getInt(4);
		                                        int iParentActivityId = rs.getInt(5);
		                                        String sParentActivityName = rs.getString(6);
		                                        if(rs!=null){
		                                    		rs.close();
		                                    		rs=null;
		                                    	}
		                                    	if(pstmt!=null){
		                                    		pstmt.close();
		                                    		pstmt=null;
		                                    	}
		                                        if ("R".equalsIgnoreCase(sParentRoutingStatus)) {
		                                        	String tempQuery="";
		                                        	 if(WFSUtil.isSyncRoutingMode())
		                                                 tempQuery = ",LockStatus = 'Y', RoutingStatus='Y' ";
		                                             else 
		                                                 tempQuery = ",LockStatus = 'N', RoutingStatus='Y' ";
		                                             
		                                            queryString = "UPDATE WFInstrumentTable SET WorkItemState = 6, StateName = 'completed'"+tempQuery+", Q_UserId = 0, Q_QueueId = 0, ValidTill = NULL WHERE ProcessInstanceId = ? AND Workitemid = ?";
		                                            pstmt = con.prepareStatement(queryString);
		                                            WFSUtil.DB_SetString(1, sParentProcessInstanceId, pstmt, dbType);
		                                            pstmt.setInt(2, iParentWorkItemId);
		                                            parameters.addAll(Arrays.asList(sParentProcessInstanceId, iParentWorkItemId));
		                                            int res = WFSUtil.jdbcExecuteUpdate(sParentProcessInstanceId, sessionID, userId, queryString, pstmt, parameters, debugFlag, engine);
		                                            pstmt.close();
		                                            if (res > 0) {
		                                                WFSUtil.generateLog(engine, con, WFSConstant.WFL_ProcessInstanceStateChanged, sParentProcessInstanceId, iParentWorkItemId, iParentProcessDefId, iParentActivityId, sParentActivityName, 0, 0, "System", 6, "completed", null, null, null, null);
		                                                if ( WFSUtil.isSyncRoutingMode()) {
		                                                	 WFRoutingUtil.routeWorkitem(con, sParentProcessInstanceId, iParentWorkItemId, iParentProcessDefId, engine,0,0,true,true);
		                                                }
		                                            }
		                                        } else {
		                                          //  throw new Exception("Parent workitem is not in suspended state");
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
	                                	}
	                                	if(pstmt!=null){
	                                		pstmt.close();
	                                		pstmt=null;
	                                	}
                                	}
                                	
                                    queryString = "Select ProcessInstanceState from QueueHistoryTable "+ WFSUtil.getTableLockHintStr(dbType)+ " where ProcessInstanceID = ? and WorkItemID = ?";
                                    pstmt = con.prepareStatement(queryString);
                                    WFSUtil.DB_SetString(1, pinstId, pstmt, dbType);
                                    pstmt.setInt(2, workItemID);
                                    parameters.add(pinstId);
                                    parameters.add(workItemID);
                                    rs = WFSUtil.jdbcExecuteQuery(pinstId, sessionID, userId, queryString, pstmt, parameters, debug, engine);
                                    parameters.clear();
                                    
//                                    pstmt.execute();
//                                    rs = pstmt.getResultSet();
                                    if (rs.next()) {
                                        procInstState = rs.getInt(1);
                                        rs.close();
                                        pstmt.close();
                                    } else {
                                        if (rs != null) {
                                            rs.close();
                                        }
                                        pstmt.close();
                                        queryString ="Select ProcessInstanceState from WFInstrumentTable where ProcessInstanceID = ? ";
                                        pstmt = con.prepareStatement(queryString);
                                        //pstmt = con.prepareStatement("Select ProcessInstanceState from ProcessInstanceTable " + "where ProcessInstanceID = ? ");
                                        WFSUtil.DB_SetString(1, pinstId, pstmt, dbType);
                                        parameters.add(pinstId);
                                        rs = WFSUtil.jdbcExecuteQuery(pinstId, sessionID, userId, queryString, pstmt, parameters, debug, engine);
                                        parameters.clear();
//                                        pstmt.execute();
//                                        rs = pstmt.getResultSet();
                                        if (rs.next()) {
                                            procInstState = rs.getInt(1);
                                        }
                                        if (rs != null) {
                                            rs.close();
                                        }
                                        pstmt.close();
                                    }
                                }
                                /*if (procInstState == 6 || procInstState == 5) {
                                    String root = "";
                                    queryString = "Select ProcessInstanceId,Workitemid from WFInstrumentTable where ChildProcessInstanceID = ? and ChildWorkItemID = ?";
                                    pstmt = con.prepareStatement(queryString);
                                     WFSUtil.DB_SetString(1, pinstId, pstmt, dbType);
                                    pstmt.setInt(2, workItemID);
                                    parameters.add(pinstId);
                                    parameters.add(workItemID);
                                    rs = WFSUtil.jdbcExecuteQuery(pinstId, sessionID, userId, queryString, pstmt, parameters, debug, engine);
                                    parameters.clear();
//                                    pstmt.execute();
//                                    rs = pstmt.getResultSet();
                                    if (rs.next()) {
                                        String parentpid = rs.getString(1);
                                        int parentwid = rs.getInt(2);
                                        root = "<Root><ProcInstance>" + parentpid + "</ProcInstance>";
                                        root += "<WorkItem>" + parentwid + "</WorkItem>";
                                        rs.close();
                                        pstmt.close();
                                        //queryString = "Select ProcessDefId,Activityid from PendingWorklistTable where ProcessInstanceID = ? and WorkItemID = ?";
                                        queryString = "Select ProcessDefId,Activityid from WFInstrumentTable where ProcessInstanceID = ? and WorkItemID = ?";
                                        pstmt = con.prepareStatement(queryString);
                                        WFSUtil.DB_SetString(1, parentpid, pstmt, dbType);
                                        pstmt.setInt(2, parentwid);
                                        parameters.add(parentpid);
                                        parameters.add(parentwid);
                                        rs = WFSUtil.jdbcExecuteQuery(pinstId, sessionID, userId, queryString, pstmt, parameters, debug, engine);
                                        parameters.clear();
//                                        pstmt.execute();
//                                        rs = pstmt.getResultSet();
                                        if (rs.next()) {
                                            root += "<ProcDefId>" + rs.getInt(1) + "</ProcDefId>";
                                            root += "<WorkStep>" + rs.getInt(2) + "</WorkStep></Root>";
                                        }
                                        if (rs != null) {
                                            rs.close();
                                        }
                                        pstmt.close();
                                    } else {
                                        if (rs != null) {
                                            rs.close();
                                        }
                                        pstmt.close();
                                    }
                                    exitStr = root;
                                } else {
                                    exitStr = "";
                                }*/
                                /* gen Log invoked for EscalationData, SrNo-5 - Ruhi Hira */
								String escData = parser.getValueOf("EscalationData", "", true);
                                if (!escData.equals("")) {
									NGXmlList escList = parser.createList("EscalationData", "Escalate");
                                            for (escList.reInitialize(); escList.hasMoreElements(); escList.skip()) {
		                                escData = escList.getVal("Escalate");
		                                parser.setInputXML(escData);
		                                String escalationId = "";
		                                String sEscMode = parser.getValueOf("EscalationMode", "", false);
		                                String sEscConcernedAuthInfo = parser.getValueOf("ConcernedAuthInfo", "", false);
        		                        String sEscComments = parser.getValueOf("Comments", "", false);
                		                String sEscMessage = parser.getValueOf("Message", "", false);
                        		        String sEscSchDate = parser.getValueOf("ScheduleTime", "", false);
                                		String sEscFrom = parser.getValueOf("From", "", false);
		                                String sEscCC = parser.getValueOf("cc", "", true);
        		                        String sEscBCC = parser.getValueOf("bcc", "", true);
        		                        if(!sEscMessage.toUpperCase().contains("</HTML>"))
					                        sEscMessage = "<html><body>"+sEscMessage.replaceAll("\n","<br>")+"</body></html>";
                		                
                                                int frequency = parser.getIntOf("Frequency",0,true);
                                                int freqDuration = parser.getIntOf("FrequencyDuration",0,true);
                                                XMLParser repeatEscalation = new XMLParser(parser.getValueOf("RepeatEscalation", "", true));
		                                String repeat = repeatEscalation.getValueOf("Repeat", "N", true).equalsIgnoreCase("Y") ? "R" : "F";
		                                int minutes = repeatEscalation.getIntOf("Minutes", 0, true);
		                                if (dbType == JTSConstant.JTS_ORACLE) {
		                                    if (con.getAutoCommit()) {
        		                                con.setAutoCommit(false);
                		                    }
                        		            escalationId = WFSUtil.nextVal(con, "EscalationId", dbType);
                                		    pstmt = con.prepareStatement("Insert Into WFEscalationTable (EscalationId, ProcessInstanceId, WorkitemId, ProcessDefId, ActivityId, EscalationMode, ConcernedAuthInfo, Comments, Message, FromId, CCId, BCCId,Frequency,FrequencyDuration,EscalationType, ResendDurationMinutes,ScheduleTime) Values (" + escalationId + ", ?, ?, ?, ?, ?, ?, ?, EMPTY_CLOB(),?,?,?,?,?,?,?," + WFSUtil.TO_DATE(sEscSchDate, true, dbType) + ")");
		                                }       
		                                 else if ((dbType == JTSConstant.JTS_MSSQL) || (dbType == JTSConstant.JTS_DB2) || (dbType == JTSConstant.JTS_POSTGRES)) {
	                        		            pstmt = con.prepareStatement("Insert Into WFEscalationTable (ProcessInstanceId, WorkitemId, ProcessDefId, ActivityId, EscalationMode, ConcernedAuthInfo, Comments, Message, FromId, CCId, BCCId,Frequency,FrequencyDuration,EscalationType, ResendDurationMinutes,ScheduleTime) Values (?, ?, ?, ?, ?, ?, ?, ?,?,?,?,?,?,?,?," + WFSUtil.TO_DATE(sEscSchDate, true, dbType) + ")");
	                                		}
                                		WFSUtil.DB_SetString(1, pinstId, pstmt, dbType);
		                                pstmt.setInt(2, workItemID);
    		                            pstmt.setInt(3, procDefID);
        		                        pstmt.setInt(4, targetActivityID);
            		                    WFSUtil.DB_SetString(5, sEscMode, pstmt, dbType);
                		                WFSUtil.DB_SetString(6, sEscConcernedAuthInfo, pstmt, dbType);
                    		            WFSUtil.DB_SetString(7, sEscComments, pstmt, dbType);
	                    	            if ((dbType == JTSConstant.JTS_MSSQL) || (dbType == JTSConstant.JTS_DB2) || (dbType == JTSConstant.JTS_POSTGRES)) {
    	                    	            pstmt.setCharacterStream(8, new java.io.StringReader(sEscMessage), sEscMessage.length());
        	                    	        WFSUtil.DB_SetString(9, sEscFrom, pstmt, dbType);
            	                    	    WFSUtil.DB_SetString(10, sEscCC, pstmt, dbType);
                	                    	WFSUtil.DB_SetString(11, sEscBCC, pstmt, dbType);
                                                pstmt.setInt(12, frequency);
                                                pstmt.setInt(13,freqDuration);
                                                 WFSUtil.DB_SetString(14, repeat, pstmt, dbType);
                                                pstmt.setInt(15, minutes);
	                    	            }
    	                    	        if (dbType == JTSConstant.JTS_ORACLE){
        	                    	        WFSUtil.DB_SetString(8, sEscFrom, pstmt, dbType);
            	                    	    WFSUtil.DB_SetString(9, sEscCC, pstmt, dbType);
                	                    	WFSUtil.DB_SetString(10, sEscBCC, pstmt, dbType);
                                                pstmt.setInt(11, frequency);
                                                pstmt.setInt(12,freqDuration);
                                                WFSUtil.DB_SetString(13, repeat, pstmt, dbType);
                                                pstmt.setInt(14, minutes);
	                	                }
    	                    	        if(queryTimeout <= 0)
    	                          			pstmt.setQueryTimeout(60);
    	                                else
    	                          			pstmt.setQueryTimeout(queryTimeout);
                                          
    	                    	        pstmt.execute();
        	                	        pstmt.close();
                                                pstmt = null;
	                                	if (dbType == JTSConstant.JTS_ORACLE) {
    	                                	stmt = con.createStatement();
	        	                            WFSUtil.writeOracleCLOB(con, stmt, "WFEscalationTable", "Message", "escalationId = " + escalationId, sEscMessage);
    	        	                        stmt.close();
        	        	                    stmt = null;
            	        	                if (!con.getAutoCommit()) {
                	        	                con.commit();
                    	        	            con.setAutoCommit(true);
                        	        	    }
	                        	        }
    	                        	}
								}
								
                                if (adhoc) {
                                    /*	************************************************************************************	*/
                                    /*		Change By	: Krishan Dutt Dixit													*/
                                    /*		Reason		: Activity Name is added in the genlog method							*/
                                    /*		Date		: 23/06/2004															*/
                                    /*		Bug No.		: WSE_I_5.0.1_478														*/
                                    /*	************************************************************************************	*/
									WFSUtil.deleteEscalation(engine, con, pinstId, workItemID, procDefID, prevActivityId);
									WFSUtil.generateLog(engine, con, WFSConstant.WFL_AdHocRouted, pinstId, workItemID, procDefID, 
										prevActivityId, prevActName, Integer.parseInt(queueId.toString()),
                                        participant.getid(), username, 0, targetActName, currentDate, null, null, null);
                                        if (!strComments.equals("")) {
                                            pstmt = con.prepareStatement("Insert Into WFCommentsTable (ProcessDefId, ActivityId, ProcessInstanceId, WorkItemId, CommentsBy, CommentsByName, CommentsTo, CommentsToName, Comments, ActionDateTime, CommentsType) Values (?, ?, ?, ?, ?, ?, ?, ?, ?, " + WFSUtil.getDate(dbType) + ", ?)");
                                            pstmt.setInt(1, procDefID);
                                            pstmt.setInt(2, targetActivityID);
                                            WFSUtil.DB_SetString(3, pinstId, pstmt, dbType);
                                            pstmt.setInt(4, workItemID);
                                            pstmt.setInt(5, userid);
                                            WFSUtil.DB_SetString(6, username, pstmt, dbType);
                                            pstmt.setInt(7, userid);
                                            WFSUtil.DB_SetString(8, username, pstmt, dbType);
                                            WFSUtil.DB_SetString(9, strComments, pstmt, dbType);
                                            pstmt.setInt(10, WFSConstant.CONST_COMMENTS_ADHOC_ROUTE);
                                            if(queryTimeout <= 0)
                                      			pstmt.setQueryTimeout(60);
                                            else
                                      			pstmt.setQueryTimeout(queryTimeout);
                                            pstmt.executeUpdate();
                                            pstmt.close();
                                            pstmt = null;
                                    }                                
                                
                                }
								if(auditFlag){
                                    pstmt = con.prepareStatement("Delete from WFAuditTrackTable where ProcessInstanceID = ? and WorkItemID = ?");
                                    WFSUtil.DB_SetString(1, pinstId, pstmt, dbType);
                                    pstmt.setInt(2, workItemID);
                                    if(queryTimeout <= 0)
                              			pstmt.setQueryTimeout(60);
                                    else
                              			pstmt.setQueryTimeout(queryTimeout);
                                    int deleteCount = pstmt.executeUpdate();
                                    WFSUtil.printOut(engine,"[OraCreateWorkitem] WMCreateWorkitem() WFAuditTrackTable deleteCount >> " + deleteCount);
                                    /*WFSUtil.generateLog(engine, con, WFSConstant.WFL_QCAudit, pinstId, workItemID, procDefID, 
                                                        prevActivityId, prevActName, Integer.parseInt(queueId.toString()),
                                                        participant.getid(), username, 0, targetActName, currentDate, null, null, null);*/
                                }
							}
							else { /*WFS_8.0_124*/								
								mainCode = WFSError.WM_INVALID_WORKITEM;
								subCode = WFSError.WF_NO_AUTHORIZATION_ADHOC;
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
                        }
                    }
                }
				
                if (bDeleteChild) {
                    removeWorkitemFromSystem(con, pinstId, workItemID, dbType, debug, psSessionId, userId, engine);
						WFSUtil.generateLog(engine, con,
							WFSConstant.WFL_ChildProcessInstanceDeleted, pinstId, workItemID,
							procDefID, previousActivityId, "", 0,
							0, "", previousActivityId, "", null, null, null, null);
					
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
        } catch (SQLException e){
            if (e.getErrorCode()== 8152 || e.getErrorCode()== 12899 || e.getErrorCode()==0) {
            try {
                if (!con.getAutoCommit()) {
                    con.rollback();
                    con.setAutoCommit(true);
                }
            } catch (SQLException ex) {
            }
            try {
                 WFSUtil.printErr(engine,"", e);
                 engine = parser.getValueOf("EngineName");
                 int dbType = ServerProperty.getReference().getDBType(engine);
               //Error code for POSTGRES in case of exception is 0 where as for oracle/mssql 0=succesfull
                 if ((e.getErrorCode() == 0 && dbType != JTSConstant.JTS_POSTGRES)||(dbType == JTSConstant.JTS_POSTGRES && e.getErrorCode() != 0)) {
                    if (e.getSQLState().equalsIgnoreCase("08S01")) {
                        suspensionCause = (new JTSSQLError(e.getSQLState())).getMessage() + "(SQL State : " + e.getSQLState() + ")";
                    }
                    
                }//Error code for POSTGRES in case of exception is 0 where as for oracle/mssql 0=succesfull 
                else if((e.getErrorCode()!=0 && dbType != JTSConstant.JTS_POSTGRES)||(dbType == JTSConstant.JTS_POSTGRES && e.getErrorCode() == 0)) {
                    suspensionCause = e.getMessage();
                }
                // workitem need to be suspended
                StringBuffer suspendStr = new StringBuffer();
                suspendStr.append("<SuspendedWorkItemDetails>");
                suspendStr.append("<ProcessDefId>").append(procDefID).append("</ProcessDefId>");
                suspendStr.append("<ProcessName>").append(parser.getValueOf("ProcessName")).append("</ProcessName>");
                suspendStr.append("<WorkItemName>").append(pinstId).append("</WorkItemName>");
                suspendStr.append("<ProcessInstanceId>").append(pinstId).append("</ProcessInstanceId>");
                suspendStr.append("<WorkItemId>").append(workItemID).append("</WorkItemId>");
                suspendStr.append("<PrevActivityName>").append(previousActivityName).append("</PrevActivityName>");
                suspendStr.append("<PrevActivityId>").append(previousActivityId).append("</PrevActivityId>");
                suspendStr.append("<ActivityId>").append(targetActivityID).append("</ActivityId>");
                suspendStr.append("<SuspensionCause>").append(suspensionCause).append("</SuspensionCause>");
                suspendStr.append("<AssignmentType>").append("P").append("</AssignmentType>");
                suspendStr.append("<DebugFlag>").append(debug).append("</DebugFlag>");
                suspendStr.append("<SessionId>").append(sessionID).append("</SessionId>");
                suspendStr.append("</SuspendedWorkItemDetails>");
                XMLParser suspendParser = new XMLParser(suspendStr.toString());
//                suspendWorkItem(engine, con, participant, suspendParser, pinstId, workItemID,debug,sessionID, userId);
                WFSUtil.suspendWorkItem(engine, con, participant, suspendParser);
                mainCode = 0;
                suspendWorkitem = true;
            } catch (JTSException ex) {
                 WFSUtil.printErr(engine,"", e);
                mainCode = WFSError.WF_OPERATION_FAILED;
                subCode = e.getErrorCode();
                subject = WFSErrorMsg.getMessage(mainCode);
                errType = WFSError.WF_TMP;
                descr = e.getMessage();
            }
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
        	StringBuilder inputParamInfo = new StringBuilder();
        	inputParamInfo.append(gen.writeValueOf("SessionId", String.valueOf(sessionID)));
        	inputParamInfo.append(gen.writeValueOf("UserName", (participant == null ? "" : participant.getname())));
        	inputParamInfo.append(gen.writeValueOf("ProcessInstanceID", pinstId));
        	inputParamInfo.append(gen.writeValueOf("WorkItemID", String.valueOf(workItemID)));
        	inputParamInfo.append(gen.writeValueOf("SourceActivityId", String.valueOf(previousActivityId)));
        	inputParamInfo.append(gen.writeValueOf("SourceActivityName", previousActivityName));
        	inputParamInfo.append(gen.writeValueOf("TargetActivityId", String.valueOf(targetActivityID)));
        	inputParamInfo.append(gen.writeValueOf("TargetActivityName", targetActivityName));
        	if (mainCode == 0) {
                outputXML = new StringBuffer(500);
                outputXML.append(gen.createOutputFile("WMCreateWorkItem"));
                outputXML.append("<Exception>\n<MainCode>0</MainCode>\n</Exception>\n");
                if (userDefVarFlag) {
                    Long timeElapsedForQueueData;
                    Long timeElapsedForExtData;
                    if (timeElapsedInfoMap == null) {
                        timeElapsedForQueueData = 0L;
                        timeElapsedForExtData = 0L;
                    } else {
                        timeElapsedForQueueData = (Long) timeElapsedInfoMap.get(WFSConstant.CONST_TIME_ELAPSED_QUEUE_DATA);
                        timeElapsedForExtData = (Long) timeElapsedInfoMap.get(WFSConstant.CONST_TIME_ELAPSED_EXT_DATA);
                    }
                    outputXML.append("<TimeElapsedInSetQueueData>").append(timeElapsedForQueueData != null ? timeElapsedForQueueData : 0).append("</TimeElapsedInSetQueueData>\n");
                    outputXML.append("<TimeElapsedInSetExtData>").append(timeElapsedForExtData != null ? timeElapsedForExtData : 0).append("</TimeElapsedInSetExtData>\n");
                }
                if (suspendWorkitem) {
                    outputXML.append("<Exception>").append("Workitem Suspended : Error ").append(suspensionCause).append("</Exception>");
                }
                outputXML.append("<TotalWorkitemCount>" + count + "</TotalWorkitemCount>");
                outputXML.append("<ProcessInstanceState>" + procInstState + "</ProcessInstanceState>");
                outputXML.append(retStr);
                outputXML.append(exitStr);
                outputXML.append(inputParamInfo.toString());
                outputXML.append(gen.closeOutputFile("WMCreateWorkItem"));
            }
            try {
                if (rs != null) {
                    rs.close();
                    rs = null;
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
                if (!con.getAutoCommit()) {
                    con.rollback();
                    con.setAutoCommit(true);
                }
            } catch (SQLException ex) {
            }
			try {
                if (stmt != null) {
                    stmt.close();
                    stmt = null;
                }
            } catch (Exception ignored) {
            }
            
        }
        if (mainCode != 0) {
            //String strReturn = WFSUtil.generalError(option, engine, gen,mainCode, subCode,errType, subject,descr, inputParamInfo.toString());
	//		return strReturn;	
            throw new WFSException(mainCode, subCode, errType, subject, descr);
        }
        return outputXML.toString();
    }

    //----------------------------------------------------------------------------------------------------
    //	Function Name 						: createWorkitem
    //	Date Written (DD/MM/YYYY)			: 16/05/2002
    //	Author								: Prashant
    //	Input Parameters					: Connection , XMLParser , XMLGenerator
    //	Output Parameters					: none
    //	Return Values						: String
    //	Description							: Performs Routing of workItem from Curent Activity to
    //										  destination .
    //----------------------------------------------------------------------------------------------------
    private int createWorkitem(String engine, Connection con, XMLParser parser, int wrkItemID, String procInstID,
                                      int targetActivity, int procDefId, int prevActivity, String prevActName,
                                      int prevActivityType, String createddate, int targetActivityType,
                                      boolean adhoc, String assgnToUser, int finStreamId, boolean returnCount,
                                      int parentWIId, String targetActName, String adhoctable,
                                      String expectedWkDelay, String entryDateTime,
                                      String currentDate, String lockedTime,
                                      String processedBy, String createdDateTime, StringBuffer queueid, String participantName, int participantId,
                                      boolean deleteOnCollectFlag, boolean debug, int sessionId, int userId, String routeStatus, int noOfAtt,HashMap  attributes,
                                      boolean userDefVarFlag,XMLGenerator  gen,String assignMentType, String currWsName,String processedByStr,String childProcessInstanceID,int childProcessDefID,int childActivityID) throws JTSException {
        /*SrNo-12*/
        int error = 0;
        int count = -1;
        String adhocStr = "";
        String prevActName1 = "";
       /*
       Retainining and updating Previous Stage correctely for various case:
		-Adhoc cases
		-Expired cases
		-In Memory Cases
		-Other System Worskteps
        */
        boolean retainPreviousStage = false;//Dont update the previousStage
        
        if(currWsName.length()>0){//USer workstep before Decision to handle for  memory cases
             retainPreviousStage = false;//No need to reatin rather just last user step before the decision to be updated
             prevActName1 = currWsName;
        }else if (prevActivityType == WFSConstant.ACT_RULE ||  prevActivityType == WFSConstant.ACT_DISTRIBUTE||prevActivityType == WFSConstant.ACT_COLLECT || prevActivityType == WFSConstant.ACT_EXPORT){
        	prevActName1 = prevActName; 
             retainPreviousStage = true;
        }else if (assignMentType.equalsIgnoreCase("D")){//For Adhoc cases and distirbuted workitems
            retainPreviousStage = true;
        }else{
            prevActName1 = prevActName;
            retainPreviousStage = false;
        }
        if(adhoc)
                adhocStr = " , AssignedUser = null "; 
        String errorMsg = "";
		int Q_DivertedByUserId = 0;
		String Q_DivertedByUserName = "";
        if(adhoc){
            HashMap map = (HashMap) CachedObjectCollection.getReference().getCacheObject(con, engine, procDefId, WFSConstant.CACHE_CONST_WFActivity, "").getData();
            WFActivityInfo srcActvEventInfo = (WFActivityInfo) map.get(prevActivity + "");
            WFActivityInfo targetActvEventInfo = (WFActivityInfo) map.get(targetActivity + "");
            if(srcActvEventInfo != null && targetActvEventInfo != null  && 
                srcActvEventInfo.getEventId() != null && targetActvEventInfo.getEventId() != null &&
                srcActvEventInfo.getEventScopeId() != null && targetActvEventInfo.getActvScopeId() != null &&     
                (!srcActvEventInfo.getEventId().equalsIgnoreCase(targetActvEventInfo.getEventId()) 
             || !srcActvEventInfo.getEventScopeId().equalsIgnoreCase(targetActvEventInfo.getActvScopeId()))){
                error = WFSError.WM_INVALID_WORKITEM;
                errorMsg = WFSErrorMsg.getMessage(error);
                throw new JTSException(error, errorMsg);
            }
        }
        Statement stmt = null;
        PreparedStatement pstmt = null;
        String queryStr = null;
        ArrayList parameters = new ArrayList();
        WFParticipant participant = new WFParticipant(participantId, participantName, 'P', "SERVER", Locale.getDefault().toString());
        try { 
            /* Selects Target ActivityName and Target Activity Type */
            if ( (prevActivity == targetActivity) && (prevActivityType == WFSConstant.ACT_DISTRIBUTE)) { //WFS_6.1_043
                //Call has come for creating the workItems at multiple worksteps, create and adhoc route the workitems at the
                distributeWorkitem(engine, con, parser, wrkItemID, procInstID, prevActivity, prevActName, procDefId, targetActivity, targetActName, participant,debug,sessionId,userId);
            } else {
                int dbType = ServerProperty.getReference().getDBType(engine);
                String queueName = "";
                String userName = "null";
                String actUserName = "";
                String queueType = "";
                String aType = "S";
                String emailnotify = "N";
                int finUserId = 0;
                int qId = 0;
                String filterValue = "null";
                ResultSet rs = null;
                String validTillColumn = "";
                String assignedUserColumn = "";
                String assignedUserValue = "";
                String filterValueColumn = "";
                String activtyTurnAroundColumn = "";
				boolean noUserExists = false;
                WFConfigLocator configLocator=null;
                stmt = con.createStatement();
                if (!(targetActivityType == WFSConstant.ACT_RULE
                       || targetActivityType == WFSConstant.ACT_EXT
                       || targetActivityType == WFSConstant.ACT_DISCARD
                       || targetActivityType == WFSConstant.ACT_COLLECT
                       || targetActivityType == WFSConstant.ACT_DISTRIBUTE
                       || targetActivityType == WFSConstant.ACT_EXPORT
                       || targetActivityType == WFSConstant.ACT_SOAPRESPONSECONSUMER)) { //SrNo-10

                    queryStr = " Select a.QueueName, a.QueueType, a.QueueId, a.FILTERVALUE"
                        + " from QueueDefTable a "+WFSUtil.getTableLockHintStr(dbType)+" , QueueStreamTable "+WFSUtil.getTableLockHintStr(dbType)+" where StreamID = " + finStreamId
                        + " and QueueStreamTable.QueueID =  a.QueueID and ProcessDefID = " + procDefId
                        + " and ActivityID = " + targetActivity;
					WFSUtil.printOut(engine,"procInstID:"+procInstID+":finStreamId:"+finStreamId+":procDefId:"+procDefId+":targetActivity:"+targetActivity);
                    rs = stmt.executeQuery(queryStr);
                    if (rs.next()) {
                        queueName = rs.getString(1);
                        queueType = rs.getString(2);
                        qId = rs.getInt(3);
                        filterValue = rs.getString(4);
                        filterValue = rs.wasNull() ? "null" : filterValue;
                        filterValue = filterValue.trim().equals("") ? "null" : filterValue;

                        boolean assgnTo = !assgnToUser.equals("");
						WFSUtil.printOut(engine,"procInstID:"+procInstID+":assgnTo:"+assgnTo+":queueType:"+queueType+":queueName:"+queueName);
                        rs.close();

                        if (!filterValue.equals("null")) {
                            //OF Optimization
                            queryStr = "Select " + filterValue + " from WFInstrumentTable where ProcessInstanceID = ? and WorkItemID = ?";
                            pstmt = con.prepareStatement(queryStr);
                            WFSUtil.DB_SetString(1, procInstID, pstmt, dbType);
                            pstmt.setInt(2,wrkItemID);
                            parameters.add(procInstID);
                            parameters.add(wrkItemID);
                            rs = WFSUtil.jdbcExecuteQuery(procInstID, sessionId, userId, queryStr, pstmt, null, debug, engine);
                            parameters.clear();
                            //rs = stmt.executeQuery("Select " + filterValue + " from QueueDataTable where ProcessInstanceID = " + TO_STRING(procInstID, true, dbType) + " and WorkItemID = " + wrkItemID);
                            if (rs.next()) {
                                filterValue = rs.getString(1);
                                filterValue = rs.wasNull() ? "null" : filterValue;
                            }
                            if (rs != null)
                                rs.close();
                        }
                        //WFS_5.2.1_0003
                        if (assgnTo) {
                            /*              rs = stmt.executeQuery(
                                              "Select UserName , UserIndex from WFUserView , QUsergroupview "
                                              + "where upper(rtrim(UserName)) = upper(rtrim("+ WFSConstant.WF_VARCHARPREFIX + assgnToUser + "')) "
                                              + "and userindex = userid and QueueID = " + qId);
                             */
                            rs = stmt.executeQuery(" SELECT UserName , UserIndex FROM WFUserView WHERE " + TO_STRING("UserName", false, dbType) + " = " + TO_STRING(TO_STRING(assgnToUser, true, dbType), false, dbType));
                            if (rs.next()) {
                                userName = rs.getString(1);
                                actUserName = userName;
                                userName = rs.wasNull() ? "null" : userName.trim();
                                finUserId = rs.getInt(2);
								Q_DivertedByUserId = 0;
								Q_DivertedByUserName = "";
                            }
							else {
								WFSUtil.printOut(engine,"userName:"+userName+":noUserExists:"+noUserExists);
								noUserExists = true;
							}
							
                            if (rs != null)
                                rs.close();

                        } 
						if ((queueType.startsWith("S") && !assgnTo) || (assgnTo && noUserExists && queueType.startsWith("S"))) {
                            String qloadpart = " and AssignmentType = " + TO_STRING("F", true, dbType);
                            queryStr = "Select * from (Select " + WFSUtil.getFetchPrefixStr(dbType, 1) + " UserName,WFUserView.UserIndex,"
                                    + "(Select Count(*) from WFInstrumentTable where Q_Userid = UserIndex and RoutingStatus = ? and LockStatus = ? " + qloadpart + ")"
                                    + " as UserLoad from WFUserView , QUserGroupView  where WFUserView.UserIndex = QUserGroupView.UserId  and "
                                    + "QUserGroupView.QueueId = ? and QUserGroupView.UserId not in (Select Diverteduserindex from UserDiversionTable " + WFSUtil.getTableLockHintStr(dbType) + "  where " + WFSUtil.getDate(dbType) + " >= fromDate and toDate >= " + WFSUtil.getDate(dbType)+") ORDER BY UserLoad asc ) q " + WFSUtil.getFetchSuffixStr(dbType, 1, WFSConstant.QUERY_STR_WHERE);
                            pstmt = con.prepareStatement(queryStr);
                            WFSUtil.DB_SetString(1, "N", pstmt, dbType);
                            WFSUtil.DB_SetString(2, "N", pstmt, dbType);
                            pstmt.setInt(3,qId);
                            parameters.add("N");
                            parameters.add("N");
                            parameters.add(qId);
                            rs = WFSUtil.jdbcExecuteQuery(procInstID, sessionId, userId, queryStr, pstmt, parameters, debug, engine);
                            parameters.clear();
//                            rs = stmt.executeQuery("Select * from (Select " + WFSUtil.getFetchPrefixStr(dbType, 1)
//                                + " UserName,WFUserView.UserIndex, "
//                                + " (Select Count(*) from WorklistTable where Q_Userid = UserIndex "
//                                + qloadpart + ") as UserLoad from WFUserView , QUserGroupView "
//                                + " where WFUserView.UserIndex = QUserGroupView.UserId "
//                                + " and QUserGroupView.QueueId = " + qId + " ORDER BY UserLoad asc ) q "
//                                + WFSUtil.getFetchSuffixStr(dbType, 1, WFSConstant.QUERY_STR_WHERE));

                            if (rs.next()) {
                                userName = rs.getString(1);
                                actUserName = userName;
                                userName = rs.wasNull() ? "null" : userName.trim();
                                finUserId = rs.getInt(2);
                            }
                            if (rs != null)
                                rs.close();
                        }
                        if (assgnTo || queueType.startsWith("S")) {
                            configLocator = WFConfigLocator.getInstance();
                            String strConfigFileName = configLocator.getPath(Location.IBPS_CONFIG) + File.separator + WFSConstant.CONST_DIRECTORY_CONFIG + File.separator + WFSConstant.CONST_FILE_WFAPPCONFIGPARAM;
                            XMLParser parserTemp = new XMLParser(WFSUtil.readFile(strConfigFileName));
                            emailnotify = parserTemp.getValueOf(WFSConstant.CONST_NOTIFYBYEMAIL, "N", true);
							WFSUtil.printOut(engine,"procInstID:"+procInstID+":final - userName:"+userName+":finUserId:"+finUserId+":queueName:"+queueName);
                            if (!userName.equals("null")) {
                            	
                            	if(queueType.startsWith("M"))
                                {
                                	queueName = userName + WfsStrings.getMessage(2);
                                }
                            	else
                            	{
                            		queueName = userName + WfsStrings.getMessage(1);
                            	}

                                queueType = "U";
                                aType = "F";
                                qId = 0;
                                
                                /** 08/01/2008, Bugzilla Bug 1649, Method moved from OraCreateWI - Ruhi Hira */
                                int tUserId = WFSUtil.getDivert(con, finUserId, dbType,procDefId, targetActivity);
                                if (tUserId != finUserId) {
                                    rs = stmt.executeQuery("Select UserName from WFUserView where userindex = " + tUserId);
                                    if (rs.next()) {
										Q_DivertedByUserId = finUserId;
										Q_DivertedByUserName = actUserName;
                                        finUserId = tUserId;
                                        userName = rs.getString(1);
                                        actUserName = userName;
                                        userName = rs.wasNull() ? "null" : userName.trim();
                                        queueName = userName + WfsStrings.getMessage(1);
                                    }
                                    if (rs != null)
                                        rs.close();
                                }
								if(emailnotify.equalsIgnoreCase("N")) {
                                rs = stmt.executeQuery("Select NotifyByEmail from UserPreferencesTable "+ WFSUtil.getTableLockHintStr(dbType)+ " where UserID = " + finUserId + " and ObjectType = " + TO_STRING("U", true, dbType));
                                if (rs.next()) {
                                    emailnotify = rs.getString(1);
                                    emailnotify = rs.wasNull() ? "N" : emailnotify;
                                }
                                if (rs != null)
                                    rs.close();
                                }
                            }
                        }
                    } else {
                        if (rs != null)
                            rs.close();
                    }
                }
                //  ROUTE TO TARGET ACTIVITY
                // --------------------------------------------------------------------------------------
                // Changed On  : 08/03/2005
                // Changed By  : Ruhi Hira
                // Description : SrNo-1; Omniflow 6.0; Feature: DynamicRuleModification
                //				    No need to fire query, values provided by process server.
                // --------------------------------------------------------------------------------------
                /*
                  rs = stmt.executeQuery(
                            "SELECT NeverExpireFlag , ExpiryOperator, Expiry , HoldTillVariable , "
                            + "ActivityTurnAroundTime FROM ACTIVITYTABLE WHERE ProcessdefId = " + procDefId
                            + " and ActivityID = " + targetActivity);
                        if(rs.next()) {
                          String neverExpireFlag = rs.getString(1);
                          boolean expiryOp = rs.getInt(2) == WFSConstant.WF_SUB ? false : true;
                          int expDuration = rs.getInt(3);
                          String expVar = rs.getString(4);
                          expVar = rs.wasNull() ? "" : expVar.trim().toUpperCase();
                 */

                int startIndexExp = parser.getStartIndex("ExpireData", 0, Integer.MAX_VALUE);
                int endIndexExp = parser.getEndIndex("ExpireData", 0, Integer.MAX_VALUE);

                String neverExpireFlag = parser.getValueOf("NeverExpireFlag", startIndexExp, endIndexExp);
                boolean expiryOp = true;
                try {
                    expiryOp = Integer.parseInt(parser.getValueOf("ExpiryOperator", startIndexExp, endIndexExp).trim())
                        == WFSConstant.WF_SUB ? false : true;
                } catch (Exception ignored) {
                    expiryOp = true;
                }
                int expDuration = 0;
                try {
                    expDuration = Integer.parseInt(parser.getValueOf("ExpiryDuration", startIndexExp, endIndexExp));
                } catch (Exception ignored) {
                    expDuration = 0;
                }
                // Added By Varun Bhansaly On 23/02/2007 to provide Calendar Support
                // Process Server will calculate and send ExpectedWorkItemDelay in the XML.
                String activityTurnAroundTime = parser.getValueOf("ExpectedWIDelay", startIndexExp, endIndexExp);
                // Process Server will calculate and send ValidTill in the XML.
                if (neverExpireFlag.startsWith("N")) {
                    neverExpireFlag = "";
					validTillColumn = "ValidTill = null";
					validTillColumn = validTillColumn + ", ";
                } else {
                    // Added By Varun Bhansaly On 23/02/2007 to provide Calendar Support
                    neverExpireFlag = parser.getValueOf("ValidTill", startIndexExp, endIndexExp);
                    neverExpireFlag = WFSUtil.TO_DATE(neverExpireFlag, true, dbType);
                    //neverExpireFlag = neverExpireFlag + ", ";
                    validTillColumn = "ValidTill="+neverExpireFlag;
                    validTillColumn = validTillColumn + ", ";
                }

                if (activityTurnAroundTime.trim().equals("")) {
                    activityTurnAroundTime = "";
					 activtyTurnAroundColumn = "ExpectedWorkitemDelay=null";
                    activtyTurnAroundColumn = activtyTurnAroundColumn + ", ";
                } else {
                    activityTurnAroundTime = WFSUtil.TO_DATE(activityTurnAroundTime, true, dbType);
                    //activityTurnAroundTime = activityTurnAroundTime + ", ";
                    activtyTurnAroundColumn = "ExpectedWorkitemDelay="+activityTurnAroundTime;
                    activtyTurnAroundColumn = activtyTurnAroundColumn + ", ";
                }
                if (filterValue.equals("null")) {
                    filterValue = "";
					filterValueColumn = "FilterValue=null";
                    filterValueColumn = filterValueColumn + ", ";
                } else {
                    //filterValue = filterValue + ", ";
                    filterValueColumn = "FilterValue="+TO_STRING(filterValue, true, dbType);
                    filterValueColumn = filterValueColumn + ", ";
                }
                if (finUserId != 0) {
                    /* Bugzilla Bug 1402, UserName changed to AssignedUser, 06/07/07 - Ruhi Hira */
                    //assignedUserValue = finUserId + ", " + TO_STRING(userName, true, dbType) + ", ";
                    assignedUserColumn = " Q_UserId="+finUserId+", AssignedUser="+TO_STRING(userName, true, dbType)+", Q_DivertedByUserId = " + Q_DivertedByUserId + ", ";					
                }
				if(assignedUserColumn == ""){
					assignedUserColumn = " Q_UserId = 0 ,";
				}
                /* if(rs != null)
                       rs.close(); */

                if (targetActivityType == WFSConstant.ACT_RULE) {
                	 boolean inputPreviousStage = true;
                     if (prevActivityType == WFSConstant.ACT_RULE || prevActivityType == WFSConstant.ACT_COLLECT || prevActivityType == WFSConstant.ACT_EXPORT){
                         inputPreviousStage = false;
                         //prevActName=""; 
                        //OF Optimization
                        //" + validTillColumn +filterValueColumn+activtyTurnAroundColumn + "
                    	//Changes for Case Management -Adding ActivityType in WFInstrumentTable
                        queryStr = "update WFInstrumentTable set ActivityName = ?, ActivityId = ?,EntryDateTime="+WFSUtil.getDate(dbType)+", AssignmentType=?,"
                        + " WorkItemState=?,Statename=?, " + validTillColumn +filterValueColumn + activtyTurnAroundColumn + " RoutingStatus=?, LockStatus=?"
                                + ",LockedByName=null, LockedTime=null,Q_userId=0"+ processedByStr
                                + ",ActivityType=? " + adhocStr + " where ProcessInstanceID = ? and WorkItemID = ? and RoutingStatus";
                        if(adhoc)
                            queryStr = queryStr + " in('N','R')";
                        else
                            queryStr = queryStr + " = 'Y' ";
                        pstmt = con.prepareStatement(queryStr);
                        WFSUtil.DB_SetString(1, targetActName, pstmt, dbType);
                        pstmt.setInt(2,targetActivity);
                        WFSUtil.DB_SetString(3, adhoc ? "D" : "R", pstmt, dbType);
                        pstmt.setInt(4,6);
                        WFSUtil.DB_SetString(5, WFSConstant.WF_COMPLETED, pstmt, dbType);
                        WFSUtil.DB_SetString(6, "Y", pstmt, dbType);
                        WFSUtil.DB_SetString(7, "N", pstmt, dbType);
                        pstmt.setInt(8,targetActivityType);
                        WFSUtil.DB_SetString(9, procInstID.trim(), pstmt, dbType);
                        pstmt.setInt(10,wrkItemID);
                        //WFSUtil.DB_SetString(10, "Y", pstmt, dbType);
                        parameters.add(targetActName);
                        parameters.add(targetActivity);
                        parameters.add(adhoc ? "D" : "R");
                        parameters.add(6);
                        parameters.add(WFSConstant.WF_COMPLETED);
                        parameters.add("Y");
                        parameters.add("N");
                        parameters.add(targetActivityType);
                        parameters.add(procInstID.trim());
                        parameters.add(wrkItemID);
                        //parameters.add("Y");
                        int res = WFSUtil.jdbcExecuteUpdate(procInstID, sessionId, userId, queryStr, pstmt, parameters, debug, engine);
                        parameters.clear();
                        
//                        int res = stmt.executeUpdate("Insert into WorkDoneTable (ProcessInstanceId, "
//                            + "WorkItemId, ProcessName, ProcessVersion, ProcessDefID, LastProcessedBy,"
//                            + "ProcessedBy, ActivityName, ActivityId, EntryDateTime, ParentWorkItemId, "
//                            + "AssignmentType, CollectFlag, PriorityLevel, " + validTillColumn + filterValueColumn
//                            + " CreatedDateTime, WorkItemState,"
//                            + "Statename, " + activtyTurnAroundColumn + "PreviousStage, PROCESSVARIANTID) Select "
//                            + "ProcessInstanceId, WorkItemId, ProcessName, ProcessVersion, ProcessDefID, "
//                            + "LastProcessedBy, ProcessedBy, " + TO_STRING(targetActName, true, dbType) + " , " + targetActivity + " , "
//                            + WFSUtil.getDate(dbType) + ", ParentWorkItemId, " + TO_STRING( (adhoc ? "D" : "R"), true, dbType)
//                            + " , " + "CollectFlag, PriorityLevel, " + neverExpireFlag
//                            + filterValue + " CreatedDateTime, 6, " + TO_STRING(WFSConstant.WF_COMPLETED, true, dbType) + " , " + activityTurnAroundTime
//                            + " PreviousStage, PROCESSVARIANTID from " + (adhoc ? adhoctable : "WorkwithPStable")
//                            + " where ProcessInstanceID = " + TO_STRING(procInstID.trim(), true, dbType) + " and WorkItemID = " + wrkItemID);
                        if (res <= 0) {
//                            int f = stmt.executeUpdate("Delete from " + (adhoc ? adhoctable : "WorkwithPStable")
//                                + " where ProcessInstanceID = " + TO_STRING(procInstID.trim(), true, dbType) + " and WorkItemID = " + wrkItemID);
//                            if (f != res) {
//                                error = WFSError.WM_INVALID_WORKITEM;
//                                errorMsg = WFSErrorMsg.getMessage(error);
//                            }
//                        } else {
                            error = WFSError.WM_INVALID_WORKITEM;
                            errorMsg = WFSErrorMsg.getMessage(error);
                        }
                    } else {
                        //OF Optimization
                    	//Changes for Case Management -Adding ActivityType in WFInstrumentTable
                        queryStr = "update WFInstrumentTable set ActivityName = ?, ActivityId = ?,EntryDateTime="+WFSUtil.getDate(dbType)+", AssignmentType=?,"
                        + " WorkItemState=?,Statename=?, RoutingStatus=?,LockStatus=?," + validTillColumn +filterValueColumn + 
                                activtyTurnAroundColumn 
                        +(!retainPreviousStage ? " PreviousStage = " + TO_STRING(prevActName1, true, dbType)+"," : "")+" LockedByName=null, LockedTime=null,Q_userId=0"+ processedByStr+",ActivityType=? " + adhocStr + " where ProcessInstanceID = ? and WorkItemID = ? and RoutingStatus";
                        if(adhoc)
                            queryStr = queryStr + " in('N','R') ";
                        else
                            queryStr = queryStr + " = 'Y' ";

                        pstmt = con.prepareStatement(queryStr);
                        WFSUtil.DB_SetString(1, targetActName, pstmt, dbType);
                        pstmt.setInt(2,targetActivity);
                        WFSUtil.DB_SetString(3, adhoc ? "D" : "R", pstmt, dbType);
                        pstmt.setInt(4,6);
                        WFSUtil.DB_SetString(5, WFSConstant.WF_COMPLETED, pstmt, dbType);
                        WFSUtil.DB_SetString(6, "Y", pstmt, dbType);
                        WFSUtil.DB_SetString(7, "N", pstmt, dbType);
                        //WFSUtil.DB_SetString(8, prevActName, pstmt, dbType);
                        pstmt.setInt(8,targetActivityType);
                        WFSUtil.DB_SetString(9, procInstID.trim(), pstmt, dbType);
                        pstmt.setInt(10,wrkItemID);
                        //WFSUtil.DB_SetString(11, "Y", pstmt, dbType);
                        parameters.add(targetActName);
                        parameters.add(targetActivity);
                        parameters.add(adhoc ? "D" : "R");
                        parameters.add(6);
                        parameters.add(WFSConstant.WF_COMPLETED);
                        parameters.add("Y");
                        parameters.add("N");
                       // parameters.add(prevActName);
                        parameters.add(targetActivityType);
                        parameters.add(procInstID.trim());
                        parameters.add(wrkItemID);
                        //parameters.add("Y");
                        int res = WFSUtil.jdbcExecuteUpdate(procInstID, sessionId, userId, queryStr, pstmt, parameters, debug, engine);
                        parameters.clear();
//                        int res = stmt.executeUpdate("Insert into WorkDoneTable (ProcessInstanceId, "
//                            + "WorkItemId, ProcessName, ProcessVersion, ProcessDefID, LastProcessedBy, "
//                            + "ProcessedBy, ActivityName, ActivityId, EntryDateTime, ParentWorkItemId, "
//                            + "AssignmentType, CollectFlag, PriorityLevel, " + validTillColumn + filterValueColumn
//                            + " CreatedDateTime, WorkItemState, "
//                            + "Statename, " + activtyTurnAroundColumn + "PreviousStage, PROCESSVARIANTID) Select "
//                            + "ProcessInstanceId, WorkItemId, ProcessName, ProcessVersion, ProcessDefID, "
//                            + "LastProcessedBy, ProcessedBy, " + TO_STRING(targetActName, true, dbType) + " , " + targetActivity + ", "
//                            + WFSUtil.getDate(dbType) + " , ParentWorkItemId, " + TO_STRING( (adhoc ? "D" : "R"), true, dbType) + " , " + "CollectFlag, PriorityLevel, " + neverExpireFlag
//                            + filterValue + " CreatedDateTime, 6, " + TO_STRING(WFSConstant.WF_COMPLETED, true, dbType) + " , " + activityTurnAroundTime
//                            + TO_STRING(prevActName, true, dbType) + ", PROCESSVARIANTID from " + (adhoc ? adhoctable : "WorkwithPStable")
//                            + " where ProcessInstanceID = " + TO_STRING(procInstID.trim(), true, dbType) + " and WorkItemID = " + wrkItemID);
                        if (res<= 0) {
//                            int f = stmt.executeUpdate("Delete from " + (adhoc ? adhoctable : "WorkwithPStable")
//                                + " where ProcessInstanceID = " + TO_STRING(procInstID.trim(), true, dbType) + " and WorkItemID = " + wrkItemID);
//                            if (f != res) {
//                                error = WFSError.WM_INVALID_WORKITEM;
//                                errorMsg = WFSErrorMsg.getMessage(error);
//                            }
//                        } else {
                            error = WFSError.WM_INVALID_WORKITEM;
                            errorMsg = WFSErrorMsg.getMessage(error);
                        }
                    }
                    if (error == 0) {
						WFSUtil.generateLog(engine, con, WFSConstant.WFL_ProcessInstanceRouted, procInstID, wrkItemID, procDefId, 
							prevActivity, prevActName, 0, 0, "", targetActivity, targetActName, currentDate, null, null, null);
                    }
                } else if (targetActivityType == WFSConstant.ACT_EXT) {
                    HashMap map = (HashMap) CachedObjectCollection.getReference().getCacheObject(con, engine, procDefId, WFSConstant.CACHE_CONST_WFActivity, "").getData();
                    WFActivityInfo targetActvEventInfo = (WFActivityInfo) map.get(targetActivity + "");  
                    boolean eventWI = false;
                    if(targetActvEventInfo != null && !targetActvEventInfo.getEventId().equalsIgnoreCase("0") ){
                        eventWI = true;
                    }
                    int res = 0;
                    /*attribute will be set before moving the workitem to QueueHistoryTable*/
                    if (noOfAtt > 0) {
                        if (!userDefVarFlag) {
                            WFSUtil.setAttributes(con, participant, attributes, engine, procInstID, wrkItemID, gen, targetActName, false);//In Asynchronous mode
                        }
                    }
                    if (userDefVarFlag) {
                        WFSUtil.setAttributesExt(con, participant, parser.getValueOf("Attributes"), engine, procInstID, wrkItemID, gen, targetActName, false, debug, false);//In Asynchronous mode
                    }
                    if (eventWI) {
                        //OF Optimization
                        String tableName = WFSUtil.searchAndLockWorkitem(con, engine, procInstID, parentWIId, sessionId, userId, debug);
                        queryStr = "Update WFInstrumentTable set EntryDateTime="+WFSUtil.getDate(dbType)+",AssignmentType=?,Q_StreamId=?,Q_QueueId=?,Q_UserId=?,WorkItemState=?,"
                                + "Statename=?,LockStatus=?,RoutingStatus =?,LockedByName=null, LockedTime=null where ProcessInstanceID = ? ";
                        pstmt = con.prepareStatement(queryStr);
                        WFSUtil.DB_SetString(1, "R", pstmt, dbType);
                        pstmt.setInt(2,0);
                        pstmt.setInt(3,0);
                        pstmt.setInt(4,0);
                        pstmt.setInt(5,6);
                        WFSUtil.DB_SetString(6, WFSConstant.WF_COMPLETED, pstmt, dbType);
                        WFSUtil.DB_SetString(7, "N", pstmt, dbType);
                        WFSUtil.DB_SetString(8, "R", pstmt, dbType);
                        WFSUtil.DB_SetString(9, procInstID, pstmt, dbType);
                        //pstmt.setInt(10,parentWIId);
                        parameters.add("R");
                        parameters.add(0);
                        parameters.add(0);
                        parameters.add(0);
                        parameters.add(6);
                        parameters.add(WFSConstant.WF_COMPLETED);
                        parameters.add("N");
                        parameters.add("R");
                        parameters.add(procInstID);
                        //parameters.add(parentWIId);
                        
                        res = WFSUtil.jdbcExecuteUpdate(procInstID, sessionId, userId, queryStr, pstmt, parameters, debug, engine);
                        parameters.clear();
                        //res = stmt.executeUpdate("Insert into PendingWorklistTable (ProcessInstanceId,WorkItemId,ProcessName,ProcessVersion,ProcessDefID," + "LastProcessedBy,ProcessedBy,ActivityName,ActivityId,EntryDateTime,ParentWorkItemId," + "AssignmentType,CollectFlag,PriorityLevel,Q_StreamId,Q_QueueId,Q_UserId," + "CreatedDateTime,WorkItemState,Statename,PreviousStage," + "LockStatus, PROCESSVARIANTID) Select " + "ProcessInstanceId,WorkItemId,ProcessName,ProcessVersion,ProcessDefID,LastProcessedBy," + "ProcessedBy, ActivityName, ActivityId, " + WFSUtil.getDate(dbType) + ",ParentWorkItemId," + TO_STRING("R", true, dbType) + " ,CollectFlag,PriorityLevel,0,0," + " 0,CreatedDateTime, 6, "+ TO_STRING(WFSConstant.WF_COMPLETED, true, dbType)+ " ,PreviousStage,'N'" + ", PROCESSVARIANTID from " + tableName.trim() + " where ProcessInstanceID = " + TO_STRING(procInstID, true, dbType) + " and WorkItemID = " + parentWIId);
                    if (res <= 0) {
//                            res = stmt.executeUpdate("Delete From " + tableName.trim() + " Where processInstanceId = " + TO_STRING(procInstID.trim(), true, dbType) + " and WorkItemID = " + parentWIId);
//                        } else {
                            error = WFSError.WM_INVALID_WORKITEM;
                            errorMsg = WFSErrorMsg.getMessage(error);
                        }
                    } else {
                        /* 1st Case mainWI */
                        //OF Optimization
                    	//Changes for Case Management -Adding ActivityType in WFInstrumentTable
                        queryStr = "Update WFInstrumentTable set ActivityName=?,ActivityId=?, EntryDateTime="+WFSUtil.getDate(dbType)+",AssignmentType=?,"
                                + "WorkItemState=?,Statename=?,LockStatus = ?"+(!retainPreviousStage ? ", PreviousStage = " 
                                + TO_STRING(prevActName1, true, dbType) : "")+","+ validTillColumn + filterValueColumn + 
                                activtyTurnAroundColumn +" RoutingStatus =?,LockedByName=null, LockedTime=null,Q_QueueId=0,q_divertedbyuserid=0,Q_UserId =0, queuename = null,ActivityType=? " + adhocStr  + processedByStr +" where ProcessInstanceID = ? and WorkItemID = ? and RoutingStatus ";
                        if(adhoc)
                            queryStr = queryStr + " in('N','R') ";
                        else
                            queryStr = queryStr + " = 'Y' ";

                        pstmt= con.prepareStatement(queryStr);
                        WFSUtil.DB_SetString(1, targetActName, pstmt, dbType);
                        pstmt.setInt(2,targetActivity);
                        WFSUtil.DB_SetString(3, (adhoc ? "D":"R"), pstmt, dbType);
                        pstmt.setInt(4,6);
                        WFSUtil.DB_SetString(5, WFSConstant.WF_COMPLETED, pstmt, dbType);
                        WFSUtil.DB_SetString(6, "N", pstmt, dbType);
                       // WFSUtil.DB_SetString(7, prevActName, pstmt, dbType);
                        WFSUtil.DB_SetString(7, adhoc ? "Y" : "R", pstmt, dbType);
                        pstmt.setInt(8,targetActivityType);
                        WFSUtil.DB_SetString(9,procInstID.trim(), pstmt, dbType);
                        pstmt.setInt(10,wrkItemID);
                       //WFSUtil.DB_SetString(10, "Y", pstmt, dbType);
                        parameters.add(targetActName);
                        parameters.add(targetActivity);
                        parameters.add(adhoc ? "D" : "R");
                        parameters.add(6);
                        parameters.add(WFSConstant.WF_COMPLETED);
                        parameters.add("N");
                       // parameters.add(prevActName);
                        parameters.add(adhoc ? "Y" : "R");
                        parameters.add(targetActivityType);
                        parameters.add(procInstID.trim());
                        parameters.add(wrkItemID);
                        //parameters.add("Y");
                        res = WFSUtil.jdbcExecuteUpdate(procInstID, sessionId, userId, queryStr, pstmt, parameters, debug, engine);
                        parameters.clear();
                        //res = stmt.executeUpdate("Insert into " + (adhoc ? "WorkDoneTable" : "PendingWorklisttable") + " (ProcessInstanceId, " + "WorkItemId, ProcessName, ProcessVersion, ProcessDefID, LastProcessedBy, " + "ProcessedBy, ActivityName, ActivityId, EntryDateTime, ParentWorkItemId, " + "AssignmentType, CollectFlag, PriorityLevel, " + validTillColumn + filterValueColumn + "CreatedDateTime, WorkItemState, " + "Statename, " + activtyTurnAroundColumn + " PreviousStage, PROCESSVARIANTID) Select " + "ProcessInstanceId, WorkItemId, ProcessName, ProcessVersion, ProcessDefID, " + "LastProcessedBy, ProcessedBy, " + TO_STRING(targetActName, true, dbType) + " , " + targetActivity + " , " + WFSUtil.getDate(dbType) + " , ParentWorkItemId, " + TO_STRING((adhoc ? "D" : "R"), true, dbType) + " , " + "CollectFlag, PriorityLevel, " + neverExpireFlag + filterValue + "CreatedDateTime, 6, " + TO_STRING(WFSConstant.WF_COMPLETED, true, dbType) + " , " + activityTurnAroundTime + TO_STRING(prevActName, true, dbType) + ", PROCESSVARIANTID from " + (adhoc ? adhoctable : "WorkwithPStable") + " where ProcessInstanceID = " + TO_STRING(procInstID.trim(), true, dbType) + " and WorkItemID = " + wrkItemID);
                        if(res > 0){
                            WFSUtil.deleteAllChildrenWIs(con, engine, procDefId, procInstID, wrkItemID, sessionId, userId,debug);
                        }else{
                            error = WFSError.WM_INVALID_WORKITEM;
                            errorMsg = WFSErrorMsg.getMessage(error);
                        }
                    }
                    if (res <= 0 ) {
                    //if (res > 0 ) {
//                        int f = stmt.executeUpdate("Delete from " + (adhoc ? adhoctable : "WorkwithPStable")
//                            + " where ProcessInstanceID = " + TO_STRING(procInstID.trim(), true, dbType) + " and WorkItemID = " + wrkItemID);
//                        if (f != res) {
//                            error = WFSError.WM_INVALID_WORKITEM;
//                            errorMsg = WFSErrorMsg.getMessage(error);
//                        }
//                        /*delete all siblings*/
//                         if(eventWI){
//                            WFSUtil.deleteAllChildrenWIs(con, engine, procDefId, procInstID, parentWIId,debug, sessionId,userId);
//                        }
//                    } else {
                        error = WFSError.WM_INVALID_WORKITEM;
                        errorMsg = WFSErrorMsg.getMessage(error);
                    }
                    if (error == 0) {
                        if (!adhoc) {
                            /*rs = stmt.executeQuery("Select count(*) from "
                                + "(Select ProcessInstanceId , WorkItemId , ActivityID from Worklisttable union all "
                                + " Select ProcessInstanceId , WorkItemId , ActivityID from WorkinProcesstable union all "
                                + " Select ProcessInstanceId , WorkItemId , ActivityID from Workdonetable union all "
                                + " Select ProcessInstanceId , WorkItemId , ActivityID from WorkwithPStable union all "
                                + " Select ProcessInstanceId , WorkItemId , ActivityID from PendingWorklisttable ) a "
                                + " where ProcessInstanceID = " + TO_STRING(procInstID, true, dbType) + " and ActivityId in (Select ActivityID from ActivityTable where ProcessDefId  = "
                                + procDefId + " and ActivityType not in (" + WFSConstant.ACT_EXT + ", "
                                + WFSConstant.ACT_DISCARD + " )) and ProcessInstanceID = " + TO_STRING(procInstID.trim(), true, dbType));
                            // Can be Optimized
                            if (rs.next()) {
                                if (rs.getInt(1) > 0) {
                                    rs.close();*/
									WFSUtil.generateLog(engine, con, WFSConstant.WFL_ProcessInstanceRouted, procInstID, wrkItemID, procDefId, 
										prevActivity, prevActName, 0, 0, "", targetActivity, targetActName, currentDate, null, null, null);
                                /*} else {
                                    if (rs != null)
                                        rs.close();	*/
                                  //  stmt.execute(
                                  //      " Update ProcessInstanceTable Set ProcessInstanceState = 6 where ProcessInstanceID = " + TO_STRING(procInstID, true, dbType));
                                    /*int priorityLevel = 1;
                                    queryStr = " select ExpectedProcessDelay,PriorityLevel from WFInstrumentTable where ProcessInstanceID = ? and WorkItemId = ?";
                                    pstmt = con.prepareStatement(queryStr);
                                    WFSUtil.DB_SetString(1, procInstID, pstmt, dbType);
                                    pstmt.setInt(2,wrkItemID);
                                    parameters.add(procInstID);
                                    parameters.add(wrkItemID);
                                    rs = WFSUtil.jdbcExecuteQuery(procInstID, sessionId, userId, queryStr, pstmt, parameters, debug, engine);
                                    parameters.clear();
                                    //rs = stmt.executeQuery(queryStr);
                                    if (rs.next()){
                                        expectedWkDelay = rs.getString(1);
                                        priorityLevel = rs.getInt(2);
                                    }
                                    if (rs != null)
                                        rs.close();

                                    queryStr = "Insert into QueueHistoryTable(ProcessDefId,ProcessName,ProcessVersion,ProcessInstanceId,ProcessInstanceName,"
                                            + "ActivityId,ActivityName,ParentWorkItemId,WorkItemId,ProcessInstanceState,WorkItemState,Statename,QueueName,"
                                            + "QueueType,AssignedUser,AssignmentType,InstrumentStatus,CheckListCompleteFlag,IntroductionDateTime,CreatedDatetime,"
                                            + "Introducedby,CreatedByName,EntryDATETIME,LockStatus,HoldStatus,PriorityLevel,LockedByName,LockedTime,ValidTill,"
                                            + "SaveStage,PreviousStage,ExpectedWorkItemDelayTime,ExpectedProcessDelayTime,Status,VAR_INT1,VAR_INT2,VAR_INT3,"
                                            + "VAR_INT4,VAR_INT5,VAR_INT6,VAR_INT7,VAR_INT8,VAR_FLOAT1,VAR_FLOAT2,VAR_DATE1,VAR_DATE2,VAR_DATE3,VAR_DATE4,"
                                            + "VAR_LONG1,VAR_LONG2,VAR_LONG3,VAR_LONG4,VAR_STR1,VAR_STR2,VAR_STR3,VAR_STR4,VAR_STR5,VAR_STR6,VAR_STR7,VAR_STR8,"
                                            + "VAR_REC_1,VAR_REC_2,VAR_REC_3,VAR_REC_4,VAR_REC_5,Q_StreamId,Q_QueueId,Q_UserID,LastProcessedBy,ProcessedBy,ReferredTo,"
                                            + "ReferredToName,ReferredBy,ReferredByName,CollectFlag,CompletionDatetime,CalendarName,ExportStatus,ProcessVariantId) "
                                            + "Select ProcessDefId,ProcessName,ProcessVersion,ProcessInstanceId,ProcessInstanceId,ActivityId,ActivityName,ParentWorkItemId,"
                                            + "WorkItemId,?,WorkItemState,Statename,QueueName,QueueType,AssignedUser,AssignmentType,InstrumentStatus,CheckListCompleteFlag,"
                                            + "IntroductionDateTime,CreatedDatetime,Introducedby,CreatedByName,EntryDATETIME,LockStatus,HoldStatus,?,LockedByName,"
                                            + "LockedTime,ValidTill,SaveStage,PreviousStage,ExpectedWorkItemDelay,ExpectedProcessDelay,Status,VAR_INT1,VAR_INT2,"
                                            + "VAR_INT3,VAR_INT4,VAR_INT5,VAR_INT6,VAR_INT7,VAR_INT8,VAR_FLOAT1,VAR_FLOAT2,VAR_DATE1,VAR_DATE2,VAR_DATE3,VAR_DATE4,"
                                            + "VAR_LONG1,VAR_LONG2,VAR_LONG3,VAR_LONG4,VAR_STR1,VAR_STR2,VAR_STR3,VAR_STR4,VAR_STR5,VAR_STR6,VAR_STR7,VAR_STR8,VAR_REC_1,"
                                            + "VAR_REC_2,VAR_REC_3,VAR_REC_4,VAR_REC_5,Q_StreamId,Q_QueueId,Q_UserID,LastProcessedBy,ProcessedBy,ReferredTo,"
                                            + "ReferredToName,ReferredBy,ReferredByName,CollectFlag,"+WFSUtil.getDate(dbType)+",CalendarName,ExportStatus,ProcessVariantId from WFInstrumentTable "
                                            + "Where ProcessInstanceId = ? and WorkItemId = ?";
									pstmt = con.prepareStatement(queryStr);
									pstmt.setInt(1,6);
                                    pstmt.setInt(2,priorityLevel);
									WFSUtil.DB_SetString(3, procInstID, pstmt, dbType);
                                    pstmt.setInt(4,wrkItemID);
									parameters.add(6);
                                    parameters.add(priorityLevel);
                                    parameters.add(procInstID);
                                    parameters.add(wrkItemID);
                                    res = WFSUtil.jdbcExecuteUpdate(procInstID, sessionId, userId, queryStr, pstmt, parameters, debug, engine);
                                    
                                    //pstmt.execute();
									pstmt.close();
									pstmt = null;								  
                                    parameters.clear();
                                    if(res > 0){
                                        queryStr = "Delete from WFInstrumentTable where ProcessInstanceId = ?";
                                        pstmt = con.prepareStatement(queryStr);
                                        WFSUtil.DB_SetString(1, procInstID, pstmt, dbType);
                                        parameters.add(procInstID);
                                        WFSUtil.jdbcExecute(procInstID, sessionId, userId, queryStr, pstmt, parameters, debug, engine);
                                        parameters.clear();
                                    }*/
                                    // WF_COM_AND_AUDIT_LOG
                              //  }
                            // }
                        }
                        /*	************************************************************************************	*/
                        /*		Change By	: Krishan Dutt Dixit													*/
                        /*		Reason		: Connection should be committed before making entry in RouteLogTable	*/
                        /*		Date		: 28/06/2004															*/
                        /*	************************************************************************************	*/
                        /*if (!con.getAutoCommit()) {
                            con.commit();
                            con.setAutoCommit(true);
                        }*/

                        // Changed By  : Krishan Dutt Dixit
                        // Changed On  : Nov 9th 2004
                        // Description : Report related Bug rectified (Bug # WFS_5_010).
						queryStr = "Update WFInstrumentTable set ProcessInstanceState = 6 where ProcessInstanceID = ? and WorkitemId = ?";
						pstmt = con.prepareStatement(queryStr);
						WFSUtil.DB_SetString(1, procInstID, pstmt, dbType);
                        pstmt.setInt(2,wrkItemID);
						parameters.clear();
						parameters.add(procInstID);
						parameters.add(wrkItemID);
						WFSUtil.jdbcExecute(procInstID, sessionId, userId, queryStr, pstmt, parameters, debug, engine);
						
						queryStr = " select ExpectedProcessDelay from WFInstrumentTable where ProcessInstanceID = ? and WorkItemId = ?";
						pstmt = con.prepareStatement(queryStr);
						WFSUtil.DB_SetString(1, procInstID, pstmt, dbType);
                        pstmt.setInt(2,wrkItemID);
						parameters.clear();
						parameters.add(procInstID);
						parameters.add(wrkItemID);
						rs = WFSUtil.jdbcExecuteQuery(procInstID, sessionId, userId, queryStr, pstmt, parameters, debug, engine);
						if (rs.next()) {
                            expectedWkDelay = rs.getString(1);
                        }	
                        //WFSUtil.generateLog(engine, con, WFSConstant.WFL_ProcessInstanceCompleted, procInstID, wrkItemID, procDefId,
                          //  targetActivity, targetActName, 0, 0, processedBy, 0, null, currentDate, createdDateTime, null, expectedWkDelay);
                        
                        if (!adhoc && !(wrkItemID > 1)){//Logging for ProcessInstanceCompleted restricted for child workitems which have been routed to exit
                        	WFSUtil.generateLog(engine, con, WFSConstant.WFL_ProcessInstanceCompleted, procInstID, wrkItemID, procDefId, 
								targetActivity, targetActName, 0, 0, processedBy, 0, null, currentDate, createdDateTime, null, expectedWkDelay);
                        }
                        
                        if (childProcessInstanceID != null && !childProcessInstanceID.equals("")){
                            WFSUtil.generateLog(engine, con, WFSConstant.WFL_SpawnProcess, procInstID, 0, procDefId, 
                            targetActivity, targetActName, childActivityID, 0, "System", 0, childProcessInstanceID, null, null, null, null);
                            WFSUtil.generateLog(engine, con, WFSConstant.WFL_ProcessSpawn, childProcessInstanceID, 0, childProcessDefID, 
                            childActivityID, "", 0, 0, "System", 0, procInstID, null, null, null, null);
                        }
                    }
                } else if (targetActivityType == WFSConstant.ACT_DISCARD) {
                    /*SrNo-12*/
                    HashMap map = (HashMap) CachedObjectCollection.getReference().getCacheObject(con, engine, procDefId, WFSConstant.CACHE_CONST_WFActivity, "").getData();
                    WFActivityInfo targetActvEventInfo = (WFActivityInfo) map.get(targetActivity + "");  
                    boolean eventWI = false;
                    if(targetActvEventInfo != null && !targetActvEventInfo.getEventId().equalsIgnoreCase("0") ){
                        eventWI = true;
                    }
                    /*attribute will be set before moving the workitem to QueueHistoryTable*/
                    if(wrkItemID ==1){
                        if (noOfAtt > 0) {
                            if (!userDefVarFlag) {
                                WFSUtil.setAttributes(con, participant, attributes, engine, procInstID, wrkItemID, gen, targetActName, false);//In Asynchronous Mode
                            }
                        }
                        if (userDefVarFlag) {
                            WFSUtil.setAttributesExt(con, participant, parser.getValueOf("Attributes"), engine, procInstID, wrkItemID, gen, targetActName, false, debug, false);//In ASynchronous mode
                        }
                    }
                    int res = 0;
                    if (eventWI) {
                    	/**
                    	 * Changes for Bug 50113 starts- Mohnish Chopra
                    	 * Processinstancestate should be set to 5 if parent workitem is discarded
                    	 * 
                    	 */
                    	
                    	String procInstStateString =(parentWIId==1)?",processinstancestate=5":"";
                        String tableName = WFSUtil.searchAndLockWorkitem(con, engine, procInstID, parentWIId, sessionId, userId,debug);
                        queryStr = "Update WFInstrumentTable set EntryDateTime="+WFSUtil.getDate(dbType)+",AssignmentType=?,Q_StreamId=?,Q_QueueId=?,queuename = null, Q_UserId=?,"
                                + "WorkItemState=?,Statename=?,LockStatus =?,RoutingStatus =?,LockedByName=null, LockedTime=null"+ procInstStateString
                                + "   where ProcessInstanceID = ? and WorkItemID = ?";
                        //Changes for Bug 50113 ends- Mohnish Chopra
                        pstmt = con.prepareStatement(queryStr);
                        WFSUtil.DB_SetString(1, "R", pstmt, dbType);
                        pstmt.setInt(2, 0);
                        pstmt.setInt(3, 0);
                        pstmt.setInt(4, 0);
                        pstmt.setInt(5, 5);
                        WFSUtil.DB_SetString(6, WFSConstant.WF_ABORTED, pstmt, dbType);
                        WFSUtil.DB_SetString(7, "N", pstmt, dbType);
                        WFSUtil.DB_SetString(8, "R", pstmt, dbType);
                        WFSUtil.DB_SetString(9, procInstID, pstmt, dbType);
                        pstmt.setInt(10, parentWIId);
                        parameters.add("R");
                        parameters.add(0);
                        parameters.add(0);
                        parameters.add(0);
                        parameters.add(5);
                        parameters.add(WFSConstant.WF_ABORTED);
                        parameters.add("N");
                        parameters.add("R");
                        parameters.add(procInstID);
                        parameters.add(parentWIId);
                        res = WFSUtil.jdbcExecuteUpdate(procInstID, sessionId, userId, queryStr, pstmt, parameters, debug, engine);
                        parameters.clear();
                        //res = stmt.executeUpdate("Insert into PendingWorklistTable (ProcessInstanceId,WorkItemId,ProcessName,ProcessVersion,ProcessDefID," + "LastProcessedBy,ProcessedBy,ActivityName,ActivityId,EntryDateTime,ParentWorkItemId," + "AssignmentType,CollectFlag,PriorityLevel,Q_StreamId,Q_QueueId,Q_UserId," + "CreatedDateTime,WorkItemState,Statename,PreviousStage," + "LockStatus, PROCESSVARIANTID) Select " + "ProcessInstanceId,WorkItemId,ProcessName,ProcessVersion,ProcessDefID,LastProcessedBy," + "ProcessedBy, ActivityName, ActivityId, " + WFSUtil.getDate(dbType) + ",ParentWorkItemId," + TO_STRING("R", true, dbType) + " ,CollectFlag,PriorityLevel,0,0," + " 0,CreatedDateTime, 5, " + TO_STRING(WFSConstant.WF_ABORTED, true, dbType)+ " ,PreviousStage,'N'" + ", PROCESSVARIANTID from " + tableName + " where ProcessInstanceID = " + TO_STRING(procInstID, true, dbType) + " and WorkItemID = " + parentWIId);
                         if(res > 0){
                            WFSUtil.deleteAllChildrenWIs(con, engine, procDefId, procInstID, wrkItemID, sessionId, userId, debug);
                        }else{
                            error = WFSError.WM_INVALID_WORKITEM;
                            errorMsg = WFSErrorMsg.getMessage(error);
                        }
                    } else {
                    	//Changes for Case Management -Adding ActivityType in WFInstrumentTable
                        queryStr="Update WFInstrumentTable set ActivityName=?, ActivityId=?,EntryDateTime="+WFSUtil.getDate(dbType)+",AssignmentType=?,WorkItemState=?,"
                                + "Statename=?"+(!retainPreviousStage ? ", PreviousStage = " 
                                + TO_STRING(prevActName1, true, dbType) : "")+",LockStatus =?, "+ validTillColumn + filterValueColumn + activtyTurnAroundColumn 
                                +"RoutingStatus =?,LockedByName=null, LockedTime=null,Q_QueueId=0,queuename = null,Q_UserId =0,q_divertedbyuserid=0,ActivityType=?"+processedByStr +  adhocStr + " where ProcessInstanceID = ? and WorkItemID = ? and RoutingStatus";
                        if(adhoc)
                            queryStr = queryStr + " in('N','R')";
                        else
                            queryStr = queryStr + " = 'Y'";

                        pstmt = con.prepareStatement(queryStr);
                        WFSUtil.DB_SetString(1, targetActName, pstmt, dbType);
                        pstmt.setInt(2,targetActivity);
                        WFSUtil.DB_SetString(3, adhoc ? "D" : "R", pstmt, dbType);
                        pstmt.setInt(4,5);
                        WFSUtil.DB_SetString(5, WFSConstant.WF_ABORTED, pstmt, dbType);
                       // WFSUtil.DB_SetString(6, prevActName, pstmt, dbType);
                        WFSUtil.DB_SetString(6, "N", pstmt, dbType);
                        WFSUtil.DB_SetString(7, adhoc ? "Y" : "R", pstmt, dbType);
                        pstmt.setInt(8,targetActivityType);
                        WFSUtil.DB_SetString(9, procInstID, pstmt, dbType);
                        pstmt.setInt(10,wrkItemID);
                        //WFSUtil.DB_SetString(11, "Y", pstmt, dbType);
                        parameters.add(targetActName);
                        parameters.add(targetActivity);
                        parameters.add(adhoc ? "D" : "R");
                        parameters.add(5);
                        parameters.add(WFSConstant.WF_ABORTED);
                        //parameters.add(prevActName);
                        parameters.add("N");
                        parameters.add(adhoc ? "Y" : "R");
                        parameters.add(targetActivityType);
                        parameters.add(procInstID);
                        parameters.add(wrkItemID);
                        //parameters.add("Y");
                        res = WFSUtil.jdbcExecuteUpdate(procInstID, sessionId, userId, queryStr, pstmt, parameters, debug, engine);
                        parameters.clear();
                        //res = stmt.executeUpdate("Insert into " + (adhoc ? "WorkDoneTable" : "PendingWorklisttable") + " (ProcessInstanceId, " + "WorkItemId, ProcessName, ProcessVersion, ProcessDefID, LastProcessedBy, " + "ProcessedBy, ActivityName, ActivityId, EntryDateTime, ParentWorkItemId, " + "AssignmentType, CollectFlag, PriorityLevel, " + validTillColumn + filterValueColumn + "CreatedDateTime, WorkItemState, " + "Statename," + activtyTurnAroundColumn + "PreviousStage, PROCESSVARIANTID) Select " + "ProcessInstanceId, WorkItemId, ProcessName, ProcessVersion, ProcessDefID, " + "LastProcessedBy, ProcessedBy, " + TO_STRING(targetActName, true, dbType) + " , " + targetActivity + " , " + WFSUtil.getDate(dbType) + ", ParentWorkItemId, " + TO_STRING((adhoc ? "D" : "R"), true, dbType) + " , " + "CollectFlag, PriorityLevel, " + neverExpireFlag + filterValue + "CreatedDateTime, 5, " + TO_STRING(WFSConstant.WF_ABORTED, true, dbType) + " , " + activityTurnAroundTime + TO_STRING(prevActName, true, dbType) + ", PROCESSVARIANTID from " + (adhoc ? adhoctable : "WorkwithPStable") + " where ProcessInstanceID = " + TO_STRING(procInstID.trim(), true, dbType) + " and WorkItemID = " + wrkItemID);
                        if(res > 0){
                            WFSUtil.deleteAllChildrenWIs(con, engine, procDefId, procInstID, wrkItemID, sessionId, userId, debug);
                        }else{
                            error = WFSError.WM_INVALID_WORKITEM;
                            errorMsg = WFSErrorMsg.getMessage(error);
                        }
                    }
//                    if (res > 0) {
//                        //OF Optimization
////                        int f = stmt.executeUpdate("Delete from " + (adhoc ? adhoctable : "WorkwithPStable")
////                            + " where ProcessInstanceID = " + TO_STRING(procInstID.trim(), true, dbType) + " and WorkItemID = " + wrkItemID);
////                        if (f != res) {
////                            error = WFSError.WM_INVALID_WORKITEM;
////                            errorMsg = WFSErrorMsg.getMessage(error);
////                        }
//                        /*delete all siblings*/
//                        if(eventWI){
//                            WFSUtil.deleteAllChildrenWIs(con, engine, procDefId, procInstID, parentWIId, debug, sessionId, userId);
//                        }
//                    } else {
//                        error = WFSError.WM_INVALID_WORKITEM;
//                        errorMsg = WFSErrorMsg.getMessage(error);
//                    }
                    if (error == 0) {
                        /*rs = stmt.executeQuery("Select count(*) from "
                                               + "( Select ProcessInstanceId , WorkItemId , ActivityId from Worklisttable union all "
                                               + " Select ProcessInstanceId , WorkItemId , ActivityId from WorkinProcesstable union all "
                                               + " Select ProcessInstanceId , WorkItemId , ActivityId from Workdonetable union all "
                                               + " Select ProcessInstanceId , WorkItemId , ActivityId from WorkwithPStable union all "
                                               + " Select ProcessInstanceId , WorkItemId , ActivityId from PendingWorklisttable ) a where ProcessInstanceID = " + TO_STRING(procInstID, true, dbType)
                                               + " and ActivityId in (Select ActivityID from ActivityTable where ProcessDefId  = "
                                               + procDefId + " and ActivityType not in (" + WFSConstant.ACT_EXT + ", "
                                               + WFSConstant.ACT_DISCARD + " )) and ProcessInstanceID = " + TO_STRING(procInstID.trim(), true, dbType));
                        if (rs.next()) {
                            if (rs.getInt(1) > 0) {
                                rs.close();
                                /*	************************************************************************************	*/
                                /*		Change By	: Krishan Dutt Dixit													*/
                                /*		Reason		: User Name should not be passed in genlog method						*/
                                /*		Date		: 19/07/2004															*/
                                /*		Bug No.		: WSE_5.0.1_beta_238													*/
                                /*	************************************************************************************	*/
								WFSUtil.generateLog(engine, con, WFSConstant.WFL_ProcessInstanceRouted, procInstID, wrkItemID, procDefId, prevActivity, prevActName, 0,
                                               0, "", targetActivity, targetActName, currentDate, null, null, null);
                            /*} else {
                                if (rs != null)
                                    rs.close();	*/
                         //       stmt.execute(
                          //          " Update ProcessInstanceTable Set ProcessInstanceState = 5 where ProcessInstanceID = " + TO_STRING(procInstID, true, dbType));
                                
                                /*int priorityLevel = 1;
                                queryStr = " select PriorityLevel from WFInstrumentTable where ProcessInstanceID = ? and WorkItemId = ?";
                                pstmt = con.prepareStatement(queryStr);
                                WFSUtil.DB_SetString(1, procInstID, pstmt, dbType);
                                pstmt.setInt(2,wrkItemID);
                                parameters.add(procInstID);
                                parameters.add(wrkItemID);
                                rs = WFSUtil.jdbcExecuteQuery(procInstID, sessionId, userId, queryStr, pstmt, parameters, debug, engine);
                                parameters.clear();
                                //rs = stmt.executeQuery(queryStr);
                                if (rs.next()){
                                    priorityLevel = rs.getInt(1);
                                }
                                if (rs != null)
                                    rs.close();

                                queryStr = "Insert into QueueHistoryTable(ProcessDefId,ProcessName,ProcessVersion,ProcessInstanceId,ProcessInstanceName,"
                                + "ActivityId,ActivityName,ParentWorkItemId,WorkItemId,ProcessInstanceState,WorkItemState,Statename,QueueName,"
                                + "QueueType,AssignedUser,AssignmentType,InstrumentStatus,CheckListCompleteFlag,IntroductionDateTime,CreatedDatetime,"
                                + "Introducedby,CreatedByName,EntryDATETIME,LockStatus,HoldStatus,PriorityLevel,LockedByName,LockedTime,ValidTill,"
                                + "SaveStage,PreviousStage,ExpectedWorkItemDelayTime,ExpectedProcessDelayTime,Status,VAR_INT1,VAR_INT2,VAR_INT3,"
                                + "VAR_INT4,VAR_INT5,VAR_INT6,VAR_INT7,VAR_INT8,VAR_FLOAT1,VAR_FLOAT2,VAR_DATE1,VAR_DATE2,VAR_DATE3,VAR_DATE4,"
                                + "VAR_LONG1,VAR_LONG2,VAR_LONG3,VAR_LONG4,VAR_STR1,VAR_STR2,VAR_STR3,VAR_STR4,VAR_STR5,VAR_STR6,VAR_STR7,VAR_STR8,"
                                + "VAR_REC_1,VAR_REC_2,VAR_REC_3,VAR_REC_4,VAR_REC_5,Q_StreamId,Q_QueueId,Q_UserID,LastProcessedBy,ProcessedBy,ReferredTo,"
                                + "ReferredToName,ReferredBy,ReferredByName,CollectFlag,CompletionDatetime,CalendarName,ExportStatus,ProcessVariantId) "
                                + "Select ProcessDefId,ProcessName,ProcessVersion,ProcessInstanceId,ProcessInstanceId,ActivityId,ActivityName,ParentWorkItemId,"
                                + "WorkItemId,?,WorkItemState,Statename,QueueName,QueueType,AssignedUser,AssignmentType,InstrumentStatus,CheckListCompleteFlag,"
                                + "IntroductionDateTime,CreatedDatetime,Introducedby,CreatedByName,EntryDATETIME,LockStatus,HoldStatus,?,LockedByName,"
                                + "LockedTime,ValidTill,SaveStage,PreviousStage,ExpectedWorkItemDelay,ExpectedProcessDelay,Status,VAR_INT1,VAR_INT2,"
                                + "VAR_INT3,VAR_INT4,VAR_INT5,VAR_INT6,VAR_INT7,VAR_INT8,VAR_FLOAT1,VAR_FLOAT2,VAR_DATE1,VAR_DATE2,VAR_DATE3,VAR_DATE4,"
                                + "VAR_LONG1,VAR_LONG2,VAR_LONG3,VAR_LONG4,VAR_STR1,VAR_STR2,VAR_STR3,VAR_STR4,VAR_STR5,VAR_STR6,VAR_STR7,VAR_STR8,VAR_REC_1,"
                                + "VAR_REC_2,VAR_REC_3,VAR_REC_4,VAR_REC_5,Q_StreamId,Q_QueueId,Q_UserID,LastProcessedBy,ProcessedBy,ReferredTo,"
                                + "ReferredToName,ReferredBy,ReferredByName,CollectFlag,"+WFSUtil.getDate(dbType)+",CalendarName,ExportStatus,ProcessVariantId from WFInstrumentTable "
                                + "Where ProcessInstanceId = ? and WorkItemId = ?";
								pstmt = con.prepareStatement(queryStr);
								pstmt.setInt(1,5);
                                pstmt.setInt(2,priorityLevel);
                                WFSUtil.DB_SetString(3, procInstID, pstmt, dbType);
                                pstmt.setInt(4,wrkItemID);
                                parameters.add(5);
                                parameters.add(priorityLevel);
                                parameters.add(procInstID);
                                parameters.add(wrkItemID);
								res = WFSUtil.jdbcExecuteUpdate(procInstID, sessionId, userId, queryStr, pstmt, parameters, debug, engine);
                                //pstmt.execute();
                                parameters.clear();
								pstmt.close();
								pstmt = null;	
                                if(res > 0){
                                    queryStr = "Delete from WFInstrumentTable where ProcessInstanceId = ? ";
                                    pstmt = con.prepareStatement(queryStr);
                                    WFSUtil.DB_SetString(1, procInstID, pstmt, dbType);
                                    parameters.add(procInstID);
                                    WFSUtil.jdbcExecute(procInstID, sessionId, userId, queryStr, pstmt, parameters, debug, engine);
                                    parameters.clear();
                                }
                                // stmt.execute(
                                //  " Delete from ProcessInstanceTable where ProcessInstanceID = " + WFSConstant.WF_VARCHARPREFIX
                                //   + procInstID + "' ");
                                /*	************************************************************************************	*/
                                /*		Change By	: Krishan Dutt Dixit													*/
                                /*		Reason		: Connection should be committed before making entry in RouteLogTable	*/
                                /*		Date		: 06/07/2004															*/
                                /*		Bug No.		: WSE_5.0.1_beta_008													*/
                                /*	************************************************************************************	*/
                                /*if (!con.getAutoCommit()) {
                                    con.commit();
                                    con.setAutoCommit(true);
                                }*/ 
								queryStr = "Update WFInstrumentTable set ProcessInstanceState = 5 where ProcessInstanceID = ? and WorkitemId = ?";
								pstmt = con.prepareStatement(queryStr);
								WFSUtil.DB_SetString(1, procInstID, pstmt, dbType);
								pstmt.setInt(2,wrkItemID);
								parameters.clear();
								parameters.add(procInstID);
								parameters.add(wrkItemID);
								WFSUtil.jdbcExecute(procInstID, sessionId, userId, queryStr, pstmt, parameters, debug, engine);
                                if(!adhoc)
                                    WFSUtil.generateLog(engine, con, WFSConstant.WFL_ProcessInstanceDiscarded, procInstID, wrkItemID, procDefId, 
									prevActivity, prevActName, qId, 0, processedBy, 0, "", currentDate, entryDateTime, lockedTime, expectedWkDelay);

                          //  }
                       // }
                    }
                } else if (targetActivityType == WFSConstant.ACT_HOLD) {
                    //OF Optimization
                	//Changes for Case Management -Adding ActivityType in WFInstrumentTable
                    /*
                     There is a case when workitem is Holded manually to Hold Workstep and another when workitem reached hold workstep thorugh normal flow:
                     * 1.In Manually Hold - Previous Stage need not to be updated as it is already update in WFHoldWorkitemAPI
                     * 2.In Normal Flow - Previous stage updated during flow.
                     */
                    String prevStage = "";
                    boolean manualHoldCase = false;
                    if(prevActName1.equalsIgnoreCase(targetActName) && !adhoc){//Manul Hold Case 
                         prevStage = "";  
                         manualHoldCase = true;
                    }else if(retainPreviousStage){//Retain Previous Stage
                        prevStage = "";
                    
                    }else{
                         prevStage = ",PreviousStage =?";
                    }
                    queryStr = "Update WFInstrumentTable set ActivityName=?, ActivityId=?,EntryDateTime="+WFSUtil.getDate(dbType)+",AssignmentType=?,WorkItemState=?,"
                            + "Statename=?,LockStatus =?," + validTillColumn + filterValueColumn + activtyTurnAroundColumn
                            + "RoutingStatus =?,LockedByName = null, LockedTime = null, Q_UserId = 0,ActivityType=? "
                            + " ,QueueType = ?,Q_QueueId = ? ,queuename = ?"+prevStage+",VAR_REC_4 = null " + adhocStr +processedByStr+ " where ProcessInstanceID = ? and WorkItemID = ? and RoutingStatus";
                    if(adhoc)
                        queryStr = queryStr + " in('N','R') ";
                    else
                        queryStr = queryStr + " = 'Y' ";

                    pstmt = con.prepareStatement(queryStr);
                    WFSUtil.DB_SetString(1, targetActName, pstmt, dbType);
                    pstmt.setInt(2,targetActivity);
                    WFSUtil.DB_SetString(3, adhoc ? "D" : "H", pstmt, dbType);
                    pstmt.setInt(4,7);
                    WFSUtil.DB_SetString(5, WFSConstant.WF_HOLDED, pstmt, dbType);
                    
                    WFSUtil.DB_SetString(6, "N", pstmt, dbType);
                    WFSUtil.DB_SetString(7, adhoc ? "Y" : "N", pstmt, dbType);
                    pstmt.setInt(8,targetActivityType);
                    WFSUtil.DB_SetString(9, "H", pstmt, dbType);
                    pstmt.setInt(10,qId);
                    WFSUtil.DB_SetString(11, queueName, pstmt, dbType);
                    if(manualHoldCase || retainPreviousStage){
                        WFSUtil.DB_SetString(12, procInstID.trim(), pstmt, dbType);
                        pstmt.setInt(13,wrkItemID);
                    }else{
                        WFSUtil.DB_SetString(12, prevActName1, pstmt, dbType);
                        WFSUtil.DB_SetString(13, procInstID.trim(), pstmt, dbType);
                        pstmt.setInt(14,wrkItemID);
                    }
                    
                    //WFSUtil.DB_SetString(11, "Y", pstmt, dbType);
                    parameters.add(targetActName);
                    parameters.add(targetActivity);
                    parameters.add(adhoc ? "D" : "H");
                    parameters.add(3);
                    parameters.add(WFSConstant.WF_HOLDED);
                    parameters.add(prevActName1);
                    parameters.add("N");
                    parameters.add(adhoc ? "Y" : "N");
                    parameters.add(targetActivityType);
                    parameters.add(procInstID.trim());
                    parameters.add(wrkItemID);
                    //parameters.add("Y");
                    
                    int res = WFSUtil.jdbcExecuteUpdate(procInstID, sessionId, userId, queryStr, pstmt, parameters, debug, engine);
                    parameters.clear();
                    
                    //int res = stmt.executeUpdate("Insert into " + (adhoc ? "WorkDoneTable" : "PendingWorklisttable") + " (ProcessInstanceId, "
//                                                 + "WorkItemId, ProcessName, ProcessVersion, ProcessDefID, LastProcessedBy, "
//                                                 + "ProcessedBy, ActivityName, ActivityId, EntryDateTime, ParentWorkItemId, "
//                                                 + "AssignmentType, CollectFlag, PriorityLevel, " + validTillColumn + filterValueColumn
//                                                 + "CreatedDateTime, WorkItemState, "
//                                                 + "Statename, " + activtyTurnAroundColumn + "PreviousStage, PROCESSVARIANTID) Select "
//                                                 + "ProcessInstanceId, WorkItemId, ProcessName, ProcessVersion, ProcessDefID, "
//                                                 + "LastProcessedBy, ProcessedBy, " + TO_STRING(targetActName, true, dbType)
//                                                 + " , " + targetActivity + " , "
//                                                 + WFSUtil.getDate(dbType) + ", ParentWorkItemId, " + TO_STRING( (adhoc ? "D" : "H"), true, dbType) + " , "
//                                                 + "CollectFlag, PriorityLevel, " + neverExpireFlag + filterValue + "CreatedDateTime, 3, " + TO_STRING(WFSConstant.WF_SUSPENDED, true, dbType) + " , "
//                                                 + activityTurnAroundTime + TO_STRING(prevActName, true, dbType) + ", PROCESSVARIANTID from "
//                                                 + (adhoc ? adhoctable : "WorkwithPStable") + " where ProcessInstanceID = " + TO_STRING(procInstID.trim(), true, dbType) + " and WorkItemID = " + wrkItemID);
                    if (res <= 0) {
                    //if (res > 0) {
//                        int f = stmt.executeUpdate("Delete from " + (adhoc ? adhoctable : "WorkwithPStable")
//                            + " where ProcessInstanceID = " + TO_STRING(procInstID.trim(), true, dbType)
//                            + " and WorkItemID = " + wrkItemID);
//                        if (f != res) {
//                            error = WFSError.WM_INVALID_WORKITEM;
//                            errorMsg = WFSErrorMsg.getMessage(error);
//                        }
//                    } else {
                        error = WFSError.WM_INVALID_WORKITEM;
                        errorMsg = WFSErrorMsg.getMessage(error);
                    }
                    if (error == 0) {
                        WFSUtil.generateLog(engine, con, WFSConstant.WFL_ProcessInstanceRouted, procInstID, wrkItemID, procDefId, 
							prevActivity, prevActName, 0, 0, "[HOLD USER]", targetActivity, targetActName, currentDate, null, null, null);

                    }
                } else if (targetActivityType == WFSConstant.ACT_COLLECT) {
                	 if (parser.getCharOf("CollectFlag", 'N', true) == 'X') {
                         removeWorkitemFromSystem(con, procInstID, wrkItemID, dbType,debug,sessionId,userId,engine);
                         WFSUtil.generateLog(engine, con, WFSConstant.WFL_ChildWorkitemDeleted, procInstID, wrkItemID, procDefId, prevActivity, "", 0, 0, "", 1, "", "", null, null, null);
                     } else {
					if(parentWIId == 0) {
						error = WFSError.WF_INVALID_STATE_TRANSITION;
						errorMsg = WFSErrorMsg.getMessage(error);
					} else {
						if(adhoc) {
                            //OF Optimization
                            upDateWI(con, prevActName1, targetActivity, targetActName, null, procInstID, wrkItemID, dbType, adhoc, engine, parser, debug, sessionId, userId,processedByStr);
                            //upDateWI(con, prevActName, targetActivity, targetActName, null, procInstID, wrkItemID, dbType, adhoc, engine, procDefId, adhoctable, parser, debug, sessionId, userId);
						} else {
							startIndexExp = parser.getStartIndex("CollectionCriteria", 0, Integer.MAX_VALUE);
							endIndexExp = parser.getEndIndex("CollectionCriteria", 0, Integer.MAX_VALUE);
							if(startIndexExp != -1 && endIndexExp != -1) {
								String strDistributeActID = parser.getValueOf("DistributeActivityId", startIndexExp, endIndexExp).trim();
								int distributeActID = Integer.parseInt(strDistributeActID);
								String strPrimaryActID = parser.getValueOf("PrimaryActivityId", startIndexExp, endIndexExp).trim();
								int primaryActID = (strPrimaryActID.equals("")) ? 0 : Integer.parseInt(strPrimaryActID);
								String strNoOfCollect = parser.getValueOf("NoOfInstances", startIndexExp, endIndexExp).trim();
								int noOfCollect = (strNoOfCollect.equals("")) ? 0 : Integer.parseInt(strNoOfCollect);
								
								int collected = 0;
								boolean isPrimaryCollected = false;
								// Check whether to collect the workitem or not
                                boolean toBeCollcted = false;					
								
								/* Find count of collected instances and whether primary instance is collected.
								WFS_5_199, CASE : Say workitem is distributed in two instances and two process servers are
								running, now after completion these two distribued instances are picked by one process
								server each, let collection criteria be "collect on 2 instances", both will parallely
								look whether collection criteria is satisfied or not resulting collection condition
								never satisfied.
								Hence copy is locked before verifying collection criteria. */
								WFSUtil.generateLog(engine, con, WFSConstant.WFL_ProcessInstanceRouted, procInstID, wrkItemID, procDefId,
									prevActivity, prevActName, 0, 0, "", targetActivity, targetActName, currentDate, null, null, null);
                                   
                                queryStr = "Select NoOfCollectedInstances, IsPrimaryCollected From WFInstrumentTable " + WFSUtil.getLockPrefixWithoutReadPast(dbType) + " Where ProcessInstanceID = ? and WorkItemID = ? and ActivityID = ? and RoutingStatus = ?" + WFSUtil.getLockSuffixStr(dbType);
								pstmt = con.prepareStatement(queryStr);
								WFSUtil.DB_SetString(1, procInstID, pstmt, dbType);
								pstmt.setInt(2, parentWIId);
								pstmt.setInt(3, distributeActID);
                                WFSUtil.DB_SetString(4, "R", pstmt, dbType);
                                parameters.add(procInstID);
                                parameters.add(parentWIId);
                                parameters.add(distributeActID);
                                parameters.add("R");
								rs =WFSUtil.jdbcExecuteQuery(procInstID, sessionId, userId, queryStr, pstmt, parameters, debug, engine);
                                parameters.clear();
                                //pstmt.execute();
								//rs = pstmt.getResultSet();
								if(rs.next()) {
									collected = rs.getInt(1);
									String strIsPrimaryCollected = rs.getString(2);
									isPrimaryCollected = rs.wasNull() ? false : strIsPrimaryCollected.startsWith("Y");
									pstmt.close();
									pstmt = null;
									// Consider this activity
									collected++;
									if(prevActivity == primaryActID) {
										isPrimaryCollected = true;
									}

									// Check whether to collect the workitem or not
									//boolean toBeCollcted = false;
									if(primaryActID == 0) {
										// Just wait for no of instances
										toBeCollcted = (collected >= noOfCollect);
									}
									else {
										// Consider the primary workstep
										toBeCollcted = isPrimaryCollected ? ((collected - 1) >= noOfCollect) : false;
									}

									if (toBeCollcted) {
										int noOfWorkitemsDeleted = collect(con, prevActivity,targetActivity, procInstID, parentWIId, targetActName, adhoc, engine, procDefId, wrkItemID, deleteOnCollectFlag, parser,true,sessionId, userId);
										if(noOfWorkitemsDeleted > 0)
										WFSUtil.generateLog(engine, con, WFSConstant.WFL_ChildWorkitemDeleted, procInstID, wrkItemID, procDefId,
										prevActivity, "", 0, 0, "", noOfWorkitemsDeleted, "", "", null, null, null);							
										} else {
                                        queryStr = "Update WFInstrumentTable Set NoOfCollectedInstances = ?, IsPrimaryCollected = ? where ProcessInstanceID = ? and WorkItemID = ? and RoutingStatus =?";
										pstmt = con.prepareStatement(queryStr);
										pstmt.setInt(1, collected);
										WFSUtil.DB_SetString(2, isPrimaryCollected ? "Y" : "N", pstmt, dbType);
										WFSUtil.DB_SetString(3, procInstID, pstmt, dbType);
										pstmt.setInt(4, parentWIId);
                                        WFSUtil.DB_SetString(5, "R", pstmt, dbType);
                                        parameters.add(collected);
                                        parameters.add((isPrimaryCollected ? "Y" : "N"));
                                        parameters.add(procInstID);
                                        parameters.add(parentWIId);
                                        parameters.add("R");
                                        
                                        int res = WFSUtil.jdbcExecuteUpdate(procInstID, sessionId, userId, queryStr, pstmt, parameters, debug, engine);
										//int res = pstmt.executeUpdate();
                                        parameters.clear();
										if(pstmt != null) {
											pstmt.close();
											pstmt = null;
										}
									}
								}
								else {                                    
                                    //WFSUtil.generateLog(engine, con, WFSConstant.WFL_ChildWorkitemDeleted, procInstID, wrkItemID, procDefId,
									//targetActivity, targetActName, 0, 0, "", targetActivity, targetActName, currentDate, null, null, null);
                                                                    
                                    if(pstmt != null) {
										pstmt.close();
										pstmt = null;
                                    }
								}
                                                                
								if (toBeCollcted){
									WFSUtil.generateLog(engine, con, WFSConstant.WFL_WorkitemCollected, procInstID, wrkItemID, procDefId,
																		targetActivity, targetActName, 0, 0, "", targetActivity, targetActName, currentDate, null, null, null);
								}
                                                                
								removeWorkitemFromSystem(con, procInstID, wrkItemID, dbType, debug, sessionId, userId,engine);
							}

						}
					}
                     }
                } else {
                    if (targetActivityType == WFSConstant.ACT_INTRODUCTION) {
                        // -----------------------------------------------------------------
                        // Changed By  : Ruhi Hira.
                        // Changed On  : 01/04/2005.
                        // Description : SrNo-4 , Omniflow 6.0, For reinitiate command
                        //				workitem should be initiated also.
                        // -----------------------------------------------------------------
                        /* NOTE : No need to modify queueName/ queueId; as workitems are
                         fetched from worklist view for a queue and it does not contain
                         workDoneTable in its definition.
                         */
                        // Reinitiate to Worklist
                        boolean initiateAlso = false;
                        int processInstanceState =1;
                        if (parser.getValueOf("InitiateAlso", "N", true).equalsIgnoreCase("Y")) {
                            initiateAlso = true;
                            aType = "R";
                            processInstanceState=2;
                        }
                        /** Bugzilla Bug 210, 29/08/2006 - Ruhi Hira */
                        //OF Optimization
                    	//Changes for Case Management -Adding ActivityType in WFInstrumentTable
                        queryStr = "UPDATE WFInstrumentTable set ActivityName=?, ActivityId=?, EntryDateTime="+WFSUtil.getDate(dbType)+", AssignmentType=?, "
                                + " Q_StreamId=?,Q_QueueId=?,WorkItemState=?, Statename=? "+(!retainPreviousStage ? ", PreviousStage = " 
                                + TO_STRING(prevActName1, true, dbType) : "")+", Queuename=?, Queuetype=?,"
                                + " NotifyStatus=?," + validTillColumn + assignedUserColumn + filterValueColumn+ activtyTurnAroundColumn + "RoutingStatus=?,"
                                + " LockStatus =?,LockedByName = null, LockedTime = null,ActivityType=?,ProcessInstanceState=? "
								+ adhocStr+processedByStr
                                + " where ProcessInstanceID = ? and WorkItemID =?";
                        pstmt = con.prepareStatement(queryStr);
                        WFSUtil.DB_SetString(1, targetActName, pstmt, dbType);
                        pstmt.setInt(2,targetActivity);
                        WFSUtil.DB_SetString(3, adhoc ? "D" : aType, pstmt, dbType);
                        pstmt.setInt(4,finStreamId);
                        pstmt.setInt(5,qId);
                        pstmt.setInt(6,1);
                        WFSUtil.DB_SetString(7, WFSConstant.WF_NOTSTARTED, pstmt, dbType);
                        //WFSUtil.DB_SetString(8, prevActName, pstmt, dbType);
                        WFSUtil.DB_SetString(8, queueName, pstmt, dbType);
                        WFSUtil.DB_SetString(9, queueType, pstmt, dbType);
                        WFSUtil.DB_SetString(10, emailnotify, pstmt, dbType);
                        WFSUtil.DB_SetString(11, (adhoc || initiateAlso) ? "Y" : "N", pstmt, dbType);
                        WFSUtil.DB_SetString(12, "N", pstmt, dbType);
                        pstmt.setInt(13,targetActivityType);
                        pstmt.setInt(14,processInstanceState);
                        WFSUtil.DB_SetString(15, procInstID.trim(), pstmt, dbType);
                        pstmt.setInt(16,wrkItemID);
                        
                        parameters.add(targetActName);
                        parameters.add(targetActivity);
                        parameters.add(adhoc ? "D" : aType);
                        parameters.add(finStreamId);
                        parameters.add(qId);
                        parameters.add(1);
                        parameters.add(WFSConstant.WF_NOTSTARTED);
                        //parameters.add(prevActName);
                        parameters.add(queueName);
                        parameters.add(queueType);
                        parameters.add(emailnotify);
                        parameters.add((adhoc || initiateAlso) ? "Y" : "N");
                        parameters.add("N");
                        parameters.add(targetActivityType);
                        parameters.add(procInstID.trim());
                        parameters.add(wrkItemID);
                        
                        int res = WFSUtil.jdbcExecuteUpdate(procInstID, sessionId, userId, queryStr, pstmt, parameters, debug, engine);
                        parameters.clear();
//                        int res = stmt.executeUpdate("Insert into " + ( (adhoc || initiateAlso) ? "WorkDoneTable" : "Worklisttable") + " (ProcessInstanceId,"
//                            + "WorkItemId, ProcessName, ProcessVersion, ProcessDefID, LastProcessedBy, "
//                            + "ProcessedBy, ActivityName, ActivityId, EntryDateTime, ParentWorkItemId, "
//                            + "AssignmentType, CollectFlag, PriorityLevel, " + validTillColumn + " Q_StreamId,Q_QueueId,"
//                            + assignedUserColumn + filterValueColumn
//                            + "CreatedDateTime, WorkItemState, "
//                            + "Statename, " + activtyTurnAroundColumn + "PreviousStage, Queuename, Queuetype, NotifyStatus, PROCESSVARIANTID) Select "
//                            + "ProcessInstanceId, WorkItemId, ProcessName, ProcessVersion, ProcessDefID, "
//                            + "LastProcessedBy, ProcessedBy, " + TO_STRING(targetActName, true, dbType) + " , " + targetActivity + " , "
//                            + WFSUtil.getDate(dbType) + ", ParentWorkItemId, " + TO_STRING( (adhoc ? "D" : aType), true, dbType) + " ,CollectFlag, PriorityLevel, " + neverExpireFlag
//                            + finStreamId + " , " + qId + " , " + assignedUserValue + filterValue + "CreatedDateTime, 1, " + TO_STRING(WFSConstant.WF_NOTSTARTED, true, dbType)
//                            + " , " + activityTurnAroundTime + TO_STRING(prevActName, true, dbType)
//                            + " , " + TO_STRING(queueName, true, dbType) + " , " + TO_STRING(queueType, true, dbType) + " , "
//                            + (adhoc ? "" : TO_STRING(emailnotify, true, dbType)) + ", PROCESSVARIANTID from "
//                            + (adhoc ? adhoctable : "WorkwithPStable") + " where ProcessInstanceID = " + TO_STRING(procInstID.trim(), true, dbType) + " and WorkItemID = " + wrkItemID);
                        if (res <= 0) {
//                            int f = stmt.executeUpdate("Delete from " + (adhoc ? adhoctable : "WorkwithPStable")
//                                + " where ProcessInstanceID = " + TO_STRING(procInstID.trim(), true, dbType) + " and WorkItemID = " + wrkItemID);
//                            if (f != res) {
//                                error = WFSError.WM_INVALID_WORKITEM;
//                                errorMsg = WFSErrorMsg.getMessage(error);
//                            }
//                        } else {
                            error = WFSError.WM_INVALID_WORKITEM;
                            errorMsg = WFSErrorMsg.getMessage(error);
                        }
                        if (error == 0) {
                       //     stmt.execute("Update ProcessInstancetable Set ProcessInstanceState = 1 where ProcessInstanceID = " + TO_STRING(procInstID.trim(), true, dbType));
                        	/*queryStr = "Update WFInstrumentTable Set ProcessInstanceState = ? where ProcessInstanceID = ?";
                            pstmt = con.prepareStatement(queryStr);
							pstmt.setInt(1,1);
							WFSUtil.DB_SetString(2, procInstID, pstmt, dbType);
                            parameters.add(1);
                            parameters.add(procInstID);
                            WFSUtil.jdbcExecute(procInstID, sessionId, userId, queryStr, pstmt, parameters, debug, engine);
							parameters.clear();
                            pstmt.execute();
							pstmt.close();
							pstmt = null;*/	
                            /*	************************************************************************************	*/
                            /*		Change By	: Krishan Dutt Dixit													*/
                            /*		Reason		: User Name is added in the genlog method								*/
                            /*		Date		: 23/06/2004															*/
                            /*		Bug No.		: WSE_I_5.0.1_478														*/
                            /*	************************************************************************************	*/
							WFSUtil.generateLog(engine, con, WFSConstant.WFL_Reinitate, procInstID, wrkItemID, procDefId, 
								prevActivity, prevActName, qId, participantId, participantName, 0, targetActName, null, null, null, null);
                            // Entry should be there for reintroduced WI as a introduced WI
							WFSUtil.generateLog(engine, con, WFSConstant.WFL_StartProcessInstance, procInstID, wrkItemID, procDefId, 
								targetActivity, targetActName, qId,  participantId, participantName, 0, "", currentDate, null, null, null, 2);
                        }
                    } else if (targetActivityType == WFSConstant.ACT_DISTRIBUTE) {
                        //Ashish added this case , just mark done the workitem at this distribute activity
                        //OF Optimization
                    	//Changes for Case Management -Adding ActivityType in WFInstrumentTable
                        queryStr = "UPDATE WFInstrumentTable set ActivityName=?, ActivityId=?, EntryDateTime="+WFSUtil.getDate(dbType)+", AssignmentType=?,"
                                + " WorkItemState=?, Statename=?, PreviousStage=?, " + validTillColumn + filterValueColumn+
                                activtyTurnAroundColumn + "RoutingStatus=?, LockStatus =?,LockedByName = null, LockedTime = null, Q_UserId = 0, queuename = null,ActivityType=? where ProcessInstanceID = ? and WorkItemID =? ";
                        pstmt = con.prepareStatement(queryStr);
                        WFSUtil.DB_SetString(1, targetActName, pstmt, dbType);
                        pstmt.setInt(2,targetActivity);
                        WFSUtil.DB_SetString(3, "D" , pstmt, dbType);
                        pstmt.setInt(4,6);
                        WFSUtil.DB_SetString(5, WFSConstant.WF_COMPLETED, pstmt, dbType);
                        WFSUtil.DB_SetString(6, prevActName1, pstmt, dbType);
                        WFSUtil.DB_SetString(7,  "Y", pstmt, dbType);
                        WFSUtil.DB_SetString(8,  "N", pstmt, dbType);
                        pstmt.setInt(9,targetActivityType);
                        WFSUtil.DB_SetString(10, procInstID.trim(), pstmt, dbType);
                        pstmt.setInt(11,wrkItemID);
                        
                        parameters.add(targetActName);
                        parameters.add(targetActivity);
                        parameters.add("D");
                        parameters.add(6);
                        parameters.add(WFSConstant.WF_COMPLETED);
                        parameters.add(prevActName);
                        parameters.add("Y");
                        parameters.add("N");
                        parameters.add(targetActivityType);
                        parameters.add(procInstID.trim());
                        parameters.add(wrkItemID);
                        
                        int res = WFSUtil.jdbcExecuteUpdate(procInstID, sessionId, userId, queryStr, pstmt, parameters, debug, engine);
                        parameters.clear();
                        
//                        int res = stmt.executeUpdate("Insert into WorkDoneTable" /* Always insert into WorkDonetable so that PS can pick it again */
//                            + " (ProcessInstanceId, WorkItemId, ProcessName, ProcessVersion, ProcessDefID, LastProcessedBy,"
//                            + " ProcessedBy, ActivityName, ActivityId, EntryDateTime, ParentWorkItemId,"
//                            + " AssignmentType, CollectFlag, PriorityLevel," + validTillColumn + filterValueColumn
//                            + " CreatedDateTime, WorkItemState,"
//                            + " Statename, " + activtyTurnAroundColumn + " PreviousStage, PROCESSVARIANTID) Select"
//                            + " ProcessInstanceId, WorkItemId, ProcessName, ProcessVersion, ProcessDefID, LastProcessedBy, "
//                            + " ProcessedBy, " + TO_STRING(targetActName, true, dbType) + " , " + targetActivity + " , "
//                            + WFSUtil.getDate(dbType) + " , ParentWorkItemId, " + TO_STRING("D", true, dbType) //WFS_6.1_043
//                            + " , CollectFlag, PriorityLevel," + neverExpireFlag + filterValue + "CreatedDateTime, 6, " + TO_STRING(WFSConstant.WF_COMPLETED, true, dbType)
//                            + " , " + activityTurnAroundTime + TO_STRING(prevActName, true, dbType)
//                            + ", PROCESSVARIANTID from " + (adhoc ? adhoctable : "WorkwithPStable") + " where ProcessInstanceID = " + TO_STRING(procInstID.trim(), true, dbType) + " and WorkItemID = " + wrkItemID);
                        if (res <= 0) {
//                            int f = stmt.executeUpdate("Delete from " + (adhoc ? adhoctable : "WorkwithPStable")
//                                + " where ProcessInstanceID = " + TO_STRING(procInstID.trim(), true, dbType) + " and WorkItemID = " + wrkItemID);
//                            if (f != res) {
//                                error = WFSError.WM_INVALID_WORKITEM;
//                                errorMsg = WFSErrorMsg.getMessage(error);
//                            }
//                        } else {
                            error = WFSError.WM_INVALID_WORKITEM;
                            errorMsg = WFSErrorMsg.getMessage(error);
                        }
                        if (error == 0) {
							WFSUtil.generateLog(engine, con, WFSConstant.WFL_ProcessInstanceRouted, procInstID, wrkItemID, procDefId, 
								prevActivity, prevActName, qId, 0, "", targetActivity, targetActName, currentDate, null, null, null); //WFS_6_006
                        }
                    } else if (targetActivityType == WFSConstant.ACT_EXPORT) { //SrNo-10

                        int ret = 0;
                        //Bug # 2823
                        int startIndex = parser.getStartIndex("ExportData", 0, 0);
                        int endIndex = parser.getEndIndex("ExportData", startIndex, 0);
                        String exportTable = parser.getValueOf("TableName", startIndex, endIndex);
                        //Bugzilla Bug # 1844
                        ret = WFRoutingUtil.MoveToExportTable(con, parser, dbType, procDefId, targetActivity, procInstID, wrkItemID);
                        if (ret > 0) {
                        	 boolean inputPreviousStage = true;
//                             if (prevActivityType == WFSConstant.ACT_RULE || prevActivityType == WFSConstant.ACT_COLLECT || prevActivityType == WFSConstant.ACT_EXPORT)
//                                 isAssignTypeD = true;
                        	//Changes for Case Management -Adding ActivityType in WFInstrumentTable
                            queryStr = "UPDATE WFInstrumentTable set ActivityName=?, ActivityId=?, EntryDateTime="+WFSUtil.getDate(dbType)+", AssignmentType=?,"
                                + " WorkItemState=?, Statename=? "+(!retainPreviousStage ? ", PreviousStage = " 
                                + TO_STRING(prevActName1, true, dbType) : "")+", " + validTillColumn + filterValueColumn+
                                activtyTurnAroundColumn + "RoutingStatus=?, LockStatus=?,LockedByName=null, LockedTime=null,Q_userId=0,ActivityType=? " + adhocStr +processedByStr+ " where ProcessInstanceID = ? and WorkItemID =? ";

                            pstmt = con.prepareStatement(queryStr);
                            WFSUtil.DB_SetString(1, targetActName, pstmt, dbType);
                            pstmt.setInt(2,targetActivity);
                            WFSUtil.DB_SetString(3, adhoc ? "D" : "R" , pstmt, dbType);
                            pstmt.setInt(4,6);
                            WFSUtil.DB_SetString(5, WFSConstant.WF_COMPLETED, pstmt, dbType);
                           // WFSUtil.DB_SetString(6, prevActName, pstmt, dbType);
                            WFSUtil.DB_SetString(6,  "Y", pstmt, dbType);
                            WFSUtil.DB_SetString(7, "N", pstmt, dbType);
                            pstmt.setInt(8,targetActivityType);
                            WFSUtil.DB_SetString(9, procInstID.trim(), pstmt, dbType);
                            pstmt.setInt(10,wrkItemID);
                            
                            parameters.add(targetActName);
                            parameters.add(targetActivity);
                            parameters.add(adhoc ? "D" : "R");
                            parameters.add(6);
                            parameters.add(WFSConstant.WF_COMPLETED);
                            parameters.add(prevActName1);
                            parameters.add("Y");
                            parameters.add("N");
                            parameters.add(targetActivityType);
                            parameters.add(procInstID.trim());
                            parameters.add(wrkItemID);
                           
                            int res = WFSUtil.jdbcExecuteUpdate(procInstID, sessionId, userId, queryStr, pstmt, parameters, debug, engine);
                            parameters.clear();
//                            int res = stmt.executeUpdate("Insert into WorkDoneTable" /* Always insert into WorkDonetable so that PS can pick it again */
//                                + " (ProcessInstanceId, WorkItemId, ProcessName, ProcessVersion, ProcessDefID, LastProcessedBy,"
//                                + " ProcessedBy, ActivityName, ActivityId, EntryDateTime, ParentWorkItemId,"
//                                + " AssignmentType, CollectFlag, PriorityLevel," + validTillColumn + filterValueColumn
//                                + " CreatedDateTime, WorkItemState,"
//                                + " Statename, " + activtyTurnAroundColumn + " PreviousStage, PROCESSVARIANTID) Select"
//                                + " ProcessInstanceId, WorkItemId, ProcessName, ProcessVersion, ProcessDefID, LastProcessedBy, "
//                                + " ProcessedBy, " + TO_STRING(targetActName, true, dbType) + " , " + targetActivity + " , "
//                                + WFSUtil.getDate(dbType) + " , ParentWorkItemId, " + TO_STRING( (adhoc ? "D" : "R"), true, dbType) //WFS_6.1_043
//                                + " ,CollectFlag, PriorityLevel, " + neverExpireFlag + filterValue + "CreatedDateTime, 6, " + TO_STRING(WFSConstant.WF_COMPLETED, true, dbType)
//                                + " , " + activityTurnAroundTime + TO_STRING(prevActName, true, dbType)
//                                + ", PROCESSVARIANTID from " + (adhoc ? adhoctable : "WorkwithPStable") + " where ProcessInstanceID = " + TO_STRING(procInstID.trim(), true, dbType) + " and WorkItemID = " + wrkItemID);
                            if (ret != res) {
                                error = WFSError.WM_INVALID_WORKITEM;
                                errorMsg = WFSErrorMsg.getMessage(error);
                            } else {
                                if (res <= 0) {
//                                    int f = stmt.executeUpdate("Delete from " + (adhoc ? adhoctable : "WorkwithPStable")
//                                        + " where ProcessInstanceID = " + TO_STRING(procInstID.trim(), true, dbType) + " and WorkItemID = " + wrkItemID);
//                                    if (f != res) {
//                                        error = WFSError.WM_INVALID_WORKITEM;
//                                        errorMsg = WFSErrorMsg.getMessage(error);
//                                    }
//                                } else {
                                    error = WFSError.WM_INVALID_WORKITEM;
                                    errorMsg = WFSErrorMsg.getMessage(error);
                                }
                            }
                        } else {
                            error = WFSError.WM_INVALID_WORKITEM;
                            errorMsg = WFSErrorMsg.getMessage(error);
                        }
                        if (error == 0) {
                            //Bug # 2823
							WFSUtil.generateLog(engine, con, WFSConstant.WFL_WorkitemExported, procInstID, wrkItemID, procDefId, 
								targetActivity, targetActName, 0, 0, "", 0, exportTable, null, null, null, null);

                        }
                    }  else if (targetActivityType == WFSConstant.ACT_SOAPRESPONSECONSUMER) {
                        Object[] errorData = WFCreateWorkitemInternal.processSOAPResponse(con, dbType, procDefId, procInstID, wrkItemID, activtyTurnAroundColumn, 
                            validTillColumn, filterValueColumn, targetActName, targetActivity, adhoc,
                            neverExpireFlag, filterValue, activityTurnAroundTime, prevActName1, 
                            adhoctable, false, null, engine, debug, sessionId, userId);
                        error = ((Integer)errorData[0]).intValue();
                        errorMsg = (String)errorData[1];
                    } else {
						if (targetActivityType == WFSConstant.ACT_CASE) {
							// checkPreCondition "E' to run data and document rules
							// rules in case of task , T- task Rules, A-- Only Auto initaite Rules
							int activityId = parser.getIntOf("ActivityId", 0, false);
							int wId = parser.getIntOf("WorkItemId", 0, false);
							String pId = parser.getValueOf("ProcessInstanceId", "", false);
							int processDefId = parser.getIntOf("ProcessDefId", 0, false);
							String checkPreCondition = "N";
							String query = "SELECT checkPreCondition from WFTaskPreCheckTable "
									+ WFSUtil.getTableLockHintStr(dbType)
									+ " where ProcessInstanceId=? and WorkItemId=? and ActivityId=? ";
							 pstmt = con.prepareStatement(query);
							pstmt.setString(1, pId);
							pstmt.setInt(2, wId);
							pstmt.setInt(3, activityId);
							rs = pstmt.executeQuery();
							if (rs.next()) {
								checkPreCondition = rs.getString("checkPreCondition");
							} else {
								if (rs != null) {
									rs.close();
									rs = null;
								}
								if (pstmt != null) {
									pstmt.close();
									pstmt = null;
								}
								query = "Insert into WFTaskPreCheckTable (ProcessInstanceId,WorkItemId,ActivityId,checkPreCondition,ProcessDefId) values(?,?,?,?,?)";
								pstmt = con.prepareStatement(query);
								pstmt.setString(1, pId);
								pstmt.setInt(2, wId);
								pstmt.setInt(3, activityId);
								pstmt.setString(4, "A");
								pstmt.setInt(5, processDefId);
								pstmt.executeUpdate();
								checkPreCondition = "A";
							}

							if ("N".equalsIgnoreCase(checkPreCondition) || "Y".equalsIgnoreCase(checkPreCondition)) {
								if (rs != null) {
									rs.close();
									rs = null;
								}
								if (pstmt != null) {
									pstmt.close();
									pstmt = null;
								}
								 query = "Update WFTaskPreCheckTable set checkPreCondition=? where ProcessInstanceId=? and WorkItemId=? and ActivityId=?  ";
								pstmt = con.prepareStatement(query) ;
								pstmt.setString(1, "A");
								pstmt.setString(2, pId);
								pstmt.setInt(3, wId);
								pstmt.setInt(4,activityId);
								pstmt.executeUpdate();
								if (pstmt != null) {
									pstmt.close();
									pstmt = null;
								}
							}
							try{
							
							StringBuffer getTaskListInputXml=CreateXML.WFGetTaskList(engine, sessionId, procInstID, wrkItemID, procDefId, activityId,"http://127.0.0.1:8080", "http://127.0.0.1:8080");
									XMLParser xmlParser=new XMLParser();
						               xmlParser.setInputXML(getTaskListInputXml.toString());
									String output= WFFindClass.getReference().execute("WFGetTaskList", engine, con, xmlParser, gen);
									xmlParser=new XMLParser();
									xmlParser.setInputXML(output);
								int	mainCode=xmlParser.getIntOf("MainCode", 1, false);
              					  if(mainCode!=0){
              						WFSUtil.printOut(engine,"Check Check someting went wrong while executiing Auto initate Rules for TaskProcess through api WFGetTaskList>>");
              						
              								  
              					  }
							}catch(Exception e){
								WFSUtil.printErr(engine,"Check Check someting went wrong while executiing Auto initate Rules for TaskProcess through api WFGetTaskList>>", e);
							}
							
							 query = "SELECT checkPreCondition from WFTaskPreCheckTable "
									+ WFSUtil.getTableLockHintStr(dbType)
									+ " where ProcessInstanceId=? and WorkItemId=? and ActivityId=? ";
							 pstmt = con.prepareStatement(query);
							pstmt.setString(1, pId);
							pstmt.setInt(2, wId);
							pstmt.setInt(3, activityId);
							rs = pstmt.executeQuery();
							if (rs.next()) {
								checkPreCondition = rs.getString("checkPreCondition");
							} else {
								if (rs != null) {
									rs.close();
									rs = null;
								}
								if (pstmt != null) {
									pstmt.close();
									pstmt = null;
								}
								query = "Insert into WFTaskPreCheckTable (ProcessInstanceId,WorkItemId,ActivityId,checkPreCondition,ProcessDefId) values(?,?,?,?,?)";
								pstmt = con.prepareStatement(query);
								pstmt.setString(1, pId);
								pstmt.setInt(2, wId);
								pstmt.setInt(3, activityId);
								pstmt.setString(4, "E");
								pstmt.setInt(5, processDefId);
								pstmt.executeUpdate();
								checkPreCondition = "E";
							}

							if ("A".equalsIgnoreCase(checkPreCondition) || "N".equalsIgnoreCase(checkPreCondition) || "Y".equalsIgnoreCase(checkPreCondition) ) {
								if (rs != null) {
									rs.close();
									rs = null;
								}
								if (pstmt != null) {
									pstmt.close();
									pstmt = null;
								}
								 query = "Update WFTaskPreCheckTable set checkPreCondition=? where ProcessInstanceId=? and WorkItemId=? and ActivityId=?  ";
								pstmt = con.prepareStatement(query) ;
								pstmt.setString(1, "E");
								pstmt.setString(2, pId);
								pstmt.setInt(3, wId);
								pstmt.setInt(4,activityId);
								pstmt.executeUpdate();
								if (pstmt != null) {
									pstmt.close();
									pstmt = null;
								}
							}

						}
                        String notifyStr = "";
                        if(!adhoc)
                            notifyStr = " NotifyStatus=" + TO_STRING(emailnotify, true, dbType)+",";                        	
                    	//Changes for Case Management -Adding ActivityType in WFInstrumentTable
                        queryStr = "UPDATE WFInstrumentTable set ActivityName=?, ActivityId=?, EntryDateTime="+WFSUtil.getDate(dbType)+", AssignmentType=?, "
                            + " Q_StreamId=?,Q_QueueId=?,WorkItemState=?, Statename=? "+(!retainPreviousStage ? ", PreviousStage = " 
                                + TO_STRING(prevActName1, true, dbType) : "")+", Queuename=?, Queuetype=?,"
                            + validTillColumn + assignedUserColumn + filterValueColumn+ activtyTurnAroundColumn + notifyStr +"RoutingStatus=?, LockStatus= ?,LockedByName=null, LockedTime=null,ActivityType= ?  "
							+ adhocStr+processedByStr
                            + " where ProcessInstanceID = ? and WorkItemID =?  ";
                        pstmt = con.prepareStatement(queryStr);
                        WFSUtil.DB_SetString(1, targetActName, pstmt, dbType);
                        pstmt.setInt(2,targetActivity);
                        WFSUtil.DB_SetString(3, adhoc ? "D" : aType, pstmt, dbType);
                        pstmt.setInt(4,finStreamId);
                        pstmt.setInt(5,qId);
                        pstmt.setInt(6,1);
                        WFSUtil.DB_SetString(7, WFSConstant.WF_NOTSTARTED, pstmt, dbType);
                       // WFSUtil.DB_SetString(8, prevActName, pstmt, dbType);
                        WFSUtil.DB_SetString(8, queueName, pstmt, dbType);
                        WFSUtil.DB_SetString(9, queueType, pstmt, dbType);
                        WFSUtil.DB_SetString(10, adhoc ? "Y" : "N", pstmt, dbType);
                        WFSUtil.DB_SetString(11, "N", pstmt, dbType);
                        pstmt.setInt(12, targetActivityType);
                        WFSUtil.DB_SetString(13, procInstID.trim(), pstmt, dbType);
                        pstmt.setInt(14,wrkItemID);
                        parameters.add(targetActName);
                        parameters.add(targetActivity);
                        parameters.add(adhoc ? "D" : aType);
                        parameters.add(finStreamId);
                        parameters.add(qId);
                        parameters.add(1);
                        parameters.add(WFSConstant.WF_NOTSTARTED);
                        parameters.add(prevActName1);
                        parameters.add(queueName);
                        parameters.add(queueType);
                        parameters.add(adhoc? "Y" : "N");
                        parameters.add("N");
                        parameters.add(targetActivityType);
                        parameters.add(procInstID.trim());
                        parameters.add(wrkItemID);
                        int res = WFSUtil.jdbcExecuteUpdate(procInstID, sessionId, userId, queryStr, pstmt, parameters, debug, engine);
                        parameters.clear();
                        
//                        String debug = "Insert into " + (adhoc ? "WorkDoneTable" : "Worklisttable") + " (ProcessInstanceId, "
//                            + "WorkItemId, ProcessName, ProcessVersion, ProcessDefID, LastProcessedBy, "
//                            + "ProcessedBy, ActivityName, ActivityId, EntryDateTime, ParentWorkItemId, "
//                            + "AssignmentType, CollectFlag, PriorityLevel, " + validTillColumn + " Q_StreamId, Q_QueueId, "
//                            + assignedUserColumn + filterValueColumn
//                            + "CreatedDateTime, WorkItemState, "
//                            + "Statename," + activtyTurnAroundColumn + " PreviousStage, Queuename, Queuetype" + (adhoc ? "" : ", NotifyStatus") + ", PROCESSVARIANTID) Select "
//                            + "ProcessInstanceId, WorkItemId, ProcessName, ProcessVersion, ProcessDefID, "
//                            + "LastProcessedBy, ProcessedBy, " + TO_STRING(targetActName, true, dbType) + " , " + targetActivity + ", "
//                            + WFSUtil.getDate(dbType) + ", ParentWorkItemId, " + TO_STRING( (adhoc ? "D" : aType), true, dbType) + " ,CollectFlag, PriorityLevel, " + neverExpireFlag
//                            + finStreamId + " , " + qId + ", " + assignedUserValue + filterValue + "CreatedDateTime, 1, " + TO_STRING(WFSConstant.WF_NOTSTARTED, true, dbType) + " , " + activityTurnAroundTime + TO_STRING(prevActName, true, dbType) + " , " + TO_STRING(queueName, true, dbType) + " , " + TO_STRING(queueType, true, dbType) + (adhoc ? "" : ", " + TO_STRING(emailnotify, true, dbType)) + ", PROCESSVARIANTID from " + (adhoc ? adhoctable : "WorkwithPStable") + " where ProcessInstanceID = "
//                            + TO_STRING(procInstID.trim(), true, dbType) + " and WorkItemID = " + wrkItemID;
//                        int res = stmt.executeUpdate(debug);
                        if (res > 0) {
//                            int f = stmt.executeUpdate("Delete from " + (adhoc ? adhoctable : "WorkwithPStable")
//                                + " where ProcessInstanceID = " + TO_STRING(procInstID.trim(), true, dbType) + " and WorkItemID = " + wrkItemID);
//                            if (f != res) {
//                                error = WFSError.WM_INVALID_WORKITEM;
//                                errorMsg = WFSErrorMsg.getMessage(error);
//                            }
//							else if(adhoctable.equalsIgnoreCase("PendingWorklisttable")){
                            if("R".equals(routeStatus)){
                                queryStr = "Update WFInstrumentTable Set ProcessInstanceState = 2 where ProcessInstanceID = " + TO_STRING(procInstID.trim(), true, dbType);
								stmt.executeUpdate(queryStr);
                                WFSUtil.jdbcExecute(procInstID, sessionId, userId, queryStr, stmt, null, debug, engine);
                            }
                        } else {
                            error = WFSError.WM_INVALID_WORKITEM;
                            errorMsg = WFSErrorMsg.getMessage(error);
                        }
                        if (error == 0) {
                            actUserName = (actUserName == null) ? "" : actUserName;
							WFSUtil.generateLog(engine, con, WFSConstant.WFL_ProcessInstanceRouted, procInstID, wrkItemID, procDefId, 
								prevActivity, prevActName, qId, 0, "", targetActivity, targetActName, currentDate, null, null, null);
							
							if(finUserId > 0) {
								if(Q_DivertedByUserId!=0){
									WFSUtil.generateLog(engine, con, WFSConstant.WFL_WorkItemReassigned, procInstID, wrkItemID, 
											procDefId, targetActivity, targetActName, 0, 0, "System", finUserId, Q_DivertedByUserName, null, null, null, null);
								}
								else{
								WFSUtil.generateLog(engine, con, WFSConstant.WFL_WorkItemReassigned, procInstID, wrkItemID, 
											procDefId, targetActivity, targetActName, 0, 0, "System", finUserId, actUserName, null, null, null, null);
								}
							}

                        }
                    }
                }
                queueid = new StringBuffer(qId + "");
				if(error == 0 && Q_DivertedByUserId!=0){
                    actUserName = (actUserName == null) ? "" : actUserName;
                    WFSUtil.generateLog(engine, con, WFSConstant.WFL_WorkitemDiverted, procInstID, wrkItemID,
                                            procDefId, targetActivity, targetActName, 0, 0, "System", finUserId, actUserName+","+Q_DivertedByUserName, null, null, null, null);
                }
            }
        } catch (SQLException e) {
            WFSUtil.printErr(engine,"", e);
            error = WFSError.WFS_SQL;
            errorMsg = e.toString();
        } catch (Exception e) {
            WFSUtil.printErr(engine,"", e);
            error = WFSError.WFS_SYS;
            errorMsg = e.toString();
        } finally {
            try {
                if (stmt != null) {
                    stmt.close();
                }
                if (pstmt != null) {
                    pstmt.close();
                }
            } catch (Exception e) {}

            
        }
        if (error != 0) {
            throw new JTSException(error, errorMsg);
        }
        return count;
    }

    //----------------------------------------------------------------------------------------------------
    //	Function Name 						: distributeWorkitem
    //	Date Written (DD/MM/YYYY)			: 16/05/2002
    //	Author								: Prashant
    //	Input Parameters					: Connection , XMLParser , XMLGenerator
    //	Output Parameters					: none
    //	Return Values						: String
    //	Description							: Performs Routing of workItem from Curent Activity to
    //										  all destination activities.
    //----------------------------------------------------------------------------------------------------
    // Change Sumnmary*
    //----------------------------------------------------------------------------
    // Changed By						: Ashish Mangla
    // Reason / Cause (Bug No if Any)	: Changes for conditional distribute
    // Change Description				: do not query for getting where to distribute, list is being sent by PS
    //									  Also itargetActivity & stargetActName previously used are useless, as PS is now not skipping the step for routing the workitem
    //----------------------------------------------------------------------------
    private void distributeWorkitem(String engine, Connection con, XMLParser parser, int wrkItemID,
                                           String procInstID, int prevActivity, String prevActName,
                                           int procDefId,  int itargetActivity, String stargetActName, WFParticipant participant, boolean debug, int sessionId, int userId) throws JTSException {
        int error = 0;
        String errorMsg = "";
        Statement stmt = null;
		ResultSet rs = null;
        PreparedStatement pstmt = null;
        String queryString = null;
        ArrayList parameters = new ArrayList();
		char char21 = 21;
		String string21 = "" + char21;
        try {
            int dbType = ServerProperty.getReference().getDBType(engine);
            String previousStage = null;
            String targetActName = null;
            int targetActivity;
            Vector target = new Vector();
            /* only for primitive types
             need to redo for complex - shilpi */
            Vector<String> targetAttribsStr = new Vector<String>();
            int start = parser.getStartIndex("DistributeActivities", 0, 0); //Ashish added parse data from input XML......
            int deadend = parser.getEndIndex("DistributeActivities", start, 0);
            int noOfActivities = parser.getNoOfFields("DistributeActivity", start, deadend);
            int end = 0;

            for (int i = 0; i < noOfActivities; i++) {
                start = parser.getStartIndex("DistributeActivity", end, 0);
                end = parser.getEndIndex("DistributeActivity", start, 0);
                target.add(parser.getValueOf("DistributeActivityId", start, end).trim() + string21 + parser.getValueOf("DistributeActivityName", start, end).trim());
                targetAttribsStr.add(parser.getValueOf("Attributes", start, end).trim());
            }

            stmt = con.createStatement();

            String queueName = "";
            String userName = "null";
            String queueType = "";
            int finUserId = 0;
            int qId = 0;
            String aType = "S";
            int finStreamId = 0;
			StringBuffer insertBuffer = new StringBuffer(100);
			StringBuffer insertDataBuffer = new StringBuffer(100);
			int parentWIIDOfParent = 0;
			int nWrkItemId = 2;//Bug 3913
            String attributeStr = null;
            
			if (target.size() > 0) {
				// WFS_5_235
				//Process Variant Support Changes
                //OF Optimization
                String lockStatus = "Y";
                String routingStatus = "Y";
                queryString = "Select ParentWorkItemId, ProcessName, ProcessVersion, "
				+ "ProcessDefID, LastProcessedBy, ProcessedBy, " + WFSUtil.getDate(dbType)
				+ ", CollectFlag, PriorityLevel, null, 0, 0, 0, null, null, CreatedDateTime, WorkItemState, "
				+ "StateName, null, PreviousStage, null, 'N', null, ProcessVariantId,"
                                + "VAR_INT1, VAR_INT2, VAR_INT3, VAR_INT4, VAR_INT5, VAR_INT6, VAR_INT7, VAR_INT8, "
                                + "VAR_FLOAT1, VAR_FLOAT2, VAR_DATE1, VAR_DATE2, VAR_DATE3, VAR_DATE4, VAR_DATE5, VAR_DATE6, VAR_LONG1, VAR_LONG2, "
                                + "VAR_LONG3, VAR_LONG4, VAR_LONG5, VAR_LONG6,  VAR_STR1, VAR_STR2, VAR_STR3, VAR_STR4, VAR_STR5, VAR_STR6, VAR_STR7, VAR_STR8, VAR_STR9, "
                                + "VAR_STR10, VAR_STR11, VAR_STR12, VAR_STR13, VAR_STR14, VAR_STR15, VAR_STR16, VAR_STR17, VAR_STR18, VAR_STR19, VAR_STR20, "
                                + "VAR_REC_1, VAR_REC_2,VAR_REC_3, VAR_REC_4, VAR_REC_5, "
                                + "INSTRUMENTSTATUS, CHECKLISTCOMPLETEFLAG, SAVESTAGE, HOLDSTATUS, STATUS, REFERREDTO, REFERREDTONAME, "
                                + "REFERREDBY, REFERREDBYNAME, CHILDPROCESSINSTANCEID, CHILDWORKITEMID, " + wrkItemID +", URN, CreatedByName, Introducedbyid, introducedby , introductiondatetime ,SecondaryDBFlag , locale from WFInstrumentTable "
				+ "where ProcessInstanceID = " + TO_STRING(procInstID, true, dbType)
				+ " and WorkItemID=" + wrkItemID +" and RoutingStatus = '"+routingStatus+"' and LockStatus = '"+lockStatus+"' ";// RoutingStatus will come first in where clause as index is created in the same order
				rs = WFSUtil.jdbcExecuteQuery(procInstID, sessionId, userId, queryString, stmt, null, debug, engine);
                //rs = stmt.executeQuery(queryString);
				
				if(rs != null && rs.next()) {
                    String strValue = null;
					parentWIIDOfParent = rs.getInt(1);
                    int i = 0;
					for(i = 2; i <= 23; i++) {
						strValue = rs.getString(i);
						 if(i == 20)
                                                    previousStage = strValue;
                                                else
                                                {
                                                    if(rs.wasNull()) {
                                                            insertBuffer.append(", null ");
                                                    }
                                                    else {
                                                            if(i == 7 || i == 16)
                                                                    insertBuffer.append(", " + WFSUtil.TO_DATE(strValue, true, dbType));
                                                            else
                                                                    insertBuffer.append(", '" + strValue.trim().replace("'","''") + "'"); // WFS_5_235
                                                    }
                                                }
					}
                    strValue = String.valueOf(rs.getInt(i));
                    insertBuffer.append(", " + strValue);
                    for(i = 25; i <= 90; i++) {
						strValue = rs.getString(i);
						if(rs.wasNull()) {
							insertDataBuffer.append(", null ");
						}
						else {
							/*Appending N before String values for handling multiple languages (ex. arabic). String values here are till URN Column*/
							if((i >= 47 && i <= 74) || i==76 || i==78 || i==80 || i==81 || i==84 || i==85 || i==87 || i==89){
								insertDataBuffer.append(", " + TO_STRING(strValue.trim(), true, dbType));
							}else if((i >= 35 && i <= 40) || i == 88)
								insertDataBuffer.append(", " + WFSUtil.TO_DATE(strValue, true, dbType));
							else
								insertDataBuffer.append(", '" + strValue.trim().replace("'","''") + "'"); // WFS_5_235
						}
					}
				}
				
//				rs = stmt.executeQuery("Select VAR_INT1, VAR_INT2, VAR_INT3, "
//				+"VAR_INT4, VAR_INT5, VAR_INT6, VAR_INT7, VAR_INT8, VAR_FLOAT1, VAR_FLOAT2, VAR_DATE1, "
//				+"VAR_DATE2, VAR_DATE3, VAR_DATE4, VAR_LONG1, VAR_LONG2, VAR_LONG3, VAR_LONG4, VAR_STR1, "
//				+"VAR_STR2, VAR_STR3, VAR_STR4, VAR_STR5, VAR_STR6, VAR_STR7, VAR_STR8, VAR_REC_1, VAR_REC_2,"
//				+"VAR_REC_3, VAR_REC_4, VAR_REC_5, INSTRUMENTSTATUS, CHECKLISTCOMPLETEFLAG, SAVESTAGE, "
//				+"HOLDSTATUS, STATUS, REFERREDTO, REFERREDTONAME, REFERREDBY, REFERREDBYNAME, "
//				+"CHILDPROCESSINSTANCEID, CHILDWORKITEMID, " + wrkItemID
//				+" from QueueDataTable where ProcessInstanceID = " + TO_STRING(procInstID, true, dbType)
//				+ " and WorkItemID="+ wrkItemID);
//
//				if(rs != null && rs.next()) {
//					for(int i = 1; i <= 43; i++) {
//						String strValue = rs.getString(i);
//						if(rs.wasNull()) {
//							insertDataBuffer.append(", null ");
//						}
//						else {
//							if(i >= 11 && i <= 14)
//								insertDataBuffer.append(", " + WFSUtil.TO_DATE(strValue, true, dbType));
//							else
//								insertDataBuffer.append(", '" + strValue.trim().replace("'","''") + "'"); // WFS_5_235
//						}
//					}
//				}
			}

            for (int i = 0; i < target.size(); i++) {
                targetActName = (String) target.elementAt(i);
                attributeStr = targetAttribsStr.elementAt(i);
                targetActivity = Integer.parseInt(targetActName.substring(0, targetActName.indexOf(string21)));
                targetActName = targetActName.substring(targetActName.indexOf(string21) + 1);

                // --------------------------------------------------------------------------------------
                // Changed On  : 08/03/2005
                // Changed By  : Ruhi Hira
                // Description : SrNo-1; Omniflow 6.0; Feature: DynamicRuleModification
                //				    No need to fire query, values provided by process server.
                // --------------------------------------------------------------------------------------
                /*
                  ResultSet rs = stmt.executeQuery(
                            "SELECT NeverExpireFlag , ExpiryOperator, Expiry , HoldTillVariable , "
                            + "ActivityTurnAroundTime FROM ACTIVITYTABLE WHERE ProcessdefId = " + procDefId
                            + " and ActivityID = " + targetActivity);
                        if(rs.next()) {
                    String neverExpireFlag = rs.getString(1);
                          boolean expiryOp = rs.getInt(2) == WFSConstant.WF_SUB ? false : true;
                          int expDuration = rs.getInt(3);
                          String expVar = rs.getString(4);
                          expVar = rs.wasNull() ? "" : expVar.trim().toUpperCase();
                 */
                String neverExpireFlag = "N";
                boolean expiryOp = true;
                int expDuration = 0;
                String expVar = "";
                /*
                          if(expVar.equals("ENTRYDATETIME") || expVar.equals("CURRENTDATETIME") ) {
                            expVar = WFSUtil.getDate(dbType);
                          } else {
                            WMAttribute attr = (WMAttribute) opattr.get(expVar.trim().toUpperCase());
                            if(attr != null && attr.value != null && !attr.value.equals("") ) {
                              expVar = WFSUtil.TO_DATE(attr.value, true, dbType);
                            }else
                            {
                              expVar = WFSUtil.getDate(dbType);
                            }
                          }
                 */
                neverExpireFlag = (neverExpireFlag == null) ? " null " : (neverExpireFlag.startsWith("N")
                    ? " null " : WFSUtil.DATEADD(WFSConstant.WFL_hh, (expiryOp ? "" : "-") + expDuration,
                                                 expVar, dbType));
                /*
                    String activityTurnAroundTime = rs.getString(5);
                          activityTurnAroundTime = rs.wasNull() ? " null " : WFSUtil.DATEADD(WFSConstant.WFL_hh,
                              activityTurnAroundTime, WFSUtil.getDate(dbType), dbType);
                    if(rs != null)
                           rs.close();
                 */
                String activityTurnAroundTime = " null ";
                
                /*rs = stmt.executeQuery("Select Max(WorkItemID)+1 from (Select WorkItemId from Worklisttable where ProcessInstanceid = " + TO_STRING(procInstID, true, dbType)
                                       + " union all Select WorkItemId from WorkinProcesstable where ProcessInstanceid = " + TO_STRING(procInstID, true, dbType)
                                       + " union all Select WorkItemId from Workdonetable where ProcessInstanceid = " + TO_STRING(procInstID, true, dbType)
                                       + " union all Select WorkItemId from WorkwithPStable where ProcessInstanceid = " + TO_STRING(procInstID, true, dbType)
                                       + " union all Select WorkItemId from PendingWorklisttable where ProcessInstanceid = " + TO_STRING(procInstID, true, dbType)+ ") a");*/

				// Bugzilla bug 3913 conditional execute of query
				if (i ==0) {
						rs = stmt.executeQuery("SELECT MAX(WorkItemID)+1 FROM WFInstrumentTable  WHERE ProcessInstanceid = " + TO_STRING(procInstID, true, dbType) ); //bug 3912 
					if (rs.next()) {
						nWrkItemId = rs.getInt(1);
					}
					if (rs != null)
						rs.close();
				} else {
					nWrkItemId++;
				}
//Process Variant Support Changes
                //OF Optimization
				//Changes for Case Management -Adding ActivityType in WFInstrumentTable
                int targetActivityType =WFSUtil.getActivityType(con, procDefId, targetActivity, null, 0, dbType);

                queryString = "Insert into WFInstrumentTable(ProcessInstanceId,WorkItemId,AssignmentType,ActivityName,ActivityId,PreviousStage,ProcessName,ProcessVersion,ProcessDefID,LastProcessedBy,"
                        + "ProcessedBy,EntryDateTime,CollectFlag,PriorityLevel,ValidTill,Q_StreamId,Q_QueueId,Q_UserId,AssignedUser,FilterValue,CreatedDateTime,WorkItemState,StateName,"
                        + "ExpectedWorkitemDelay,LockedByName,LockStatus,LockedTime, ProcessVariantId," 
                        + " VAR_INT1, VAR_INT2, VAR_INT3, VAR_INT4, VAR_INT5, VAR_INT6, VAR_INT7,"
                        + "VAR_INT8,VAR_FLOAT1, VAR_FLOAT2, VAR_DATE1, VAR_DATE2, VAR_DATE3, VAR_DATE4,VAR_DATE5, VAR_DATE6, VAR_LONG1, VAR_LONG2, VAR_LONG3, VAR_LONG4,VAR_LONG5, VAR_LONG6, VAR_STR1, VAR_STR2, VAR_STR3, VAR_STR4, "
                        + "VAR_STR5, VAR_STR6, VAR_STR7, VAR_STR8,VAR_STR9, VAR_STR10, VAR_STR11, VAR_STR12, VAR_STR13, VAR_STR14, VAR_STR15, VAR_STR16, VAR_STR17, VAR_STR18, VAR_STR19, VAR_STR20, VAR_REC_1, VAR_REC_2,VAR_REC_3, VAR_REC_4, VAR_REC_5,"
                        + "INSTRUMENTSTATUS, CHECKLISTCOMPLETEFLAG, SAVESTAGE, HOLDSTATUS, STATUS,"
                        + " REFERREDTO, REFERREDTONAME, REFERREDBY, REFERREDBYNAME, CHILDPROCESSINSTANCEID, CHILDWORKITEMID, PARENTWORKITEMID, URN, CreatedByName, Introducedbyid, introducedby , introductiondatetime,SecondaryDBFlag,locale, RoutingStatus, CreatedBy, IntroducedAt, ProcessInstanceState,ActivityType) Values "
                        + "( " + TO_STRING(procInstID, true, dbType) + ", " + nWrkItemId+ "," + TO_STRING("D", true, dbType) + ","+TO_STRING(targetActName, true, dbType) 
                        + ","+ targetActivity+",NULL "+ insertBuffer.toString()+" "+ insertDataBuffer.toString()+"," + TO_STRING("Y", true, dbType) + "," + userId
                        + ","+TO_STRING(prevActName, true, dbType) + ", 2,"+targetActivityType+")";
                int res1 = WFSUtil.jdbcExecuteUpdate(procInstID, sessionId, userId, queryString, stmt, null, debug, engine);
//				int res1 = stmt.executeUpdate("Insert into WorkDonetable(ProcessInstanceId,"
//				+ "WorkItemId,ParentWorkItemId,AssignmentType,ActivityName,ActivityId,ProcessName,"
//				+ "ProcessVersion,ProcessDefID,LastProcessedBy,ProcessedBy,EntryDateTime,"
//				+ "CollectFlag,PriorityLevel,ValidTill,Q_StreamId,Q_QueueId,Q_UserId,"
//				+ "AssignedUser,FilterValue,CreatedDateTime,WorkItemState,StateName,"
//				+ "ExpectedWorkitemDelay,PreviousStage,LockedByName,LockStatus,LockedTime, ProcessVariantId) "
//				+ "Values ( " + TO_STRING(procInstID, true, dbType) + ", " + nWrkItemId
//				+ "," + wrkItemID + "," + TO_STRING("D", true, dbType) + ","
//				+ TO_STRING(targetActName, true, dbType) + "," + targetActivity
//				+ insertBuffer.toString() + ")");
//
//				int res2 = stmt.executeUpdate(
//				"Insert into QueueDataTable ( PROCESSINSTANCEID, WORKITEMID, VAR_INT1, VAR_INT2, VAR_INT3, "
//				+"VAR_INT4, VAR_INT5, VAR_INT6, VAR_INT7, VAR_INT8, VAR_FLOAT1, VAR_FLOAT2, VAR_DATE1, "
//				+"VAR_DATE2, VAR_DATE3, VAR_DATE4, VAR_LONG1, VAR_LONG2, VAR_LONG3, VAR_LONG4, VAR_STR1, "
//				+"VAR_STR2, VAR_STR3, VAR_STR4, VAR_STR5, VAR_STR6, VAR_STR7, VAR_STR8, VAR_REC_1, VAR_REC_2,"
//				+"VAR_REC_3, VAR_REC_4, VAR_REC_5, INSTRUMENTSTATUS, CHECKLISTCOMPLETEFLAG, SAVESTAGE, "
//				+"HOLDSTATUS, STATUS, REFERREDTO, REFERREDTONAME, REFERREDBY, REFERREDBYNAME, "
//				+"CHILDPROCESSINSTANCEID, CHILDWORKITEMID, PARENTWORKITEMID) Values ( "
//				+ TO_STRING(procInstID, true, dbType) + ", " + nWrkItemId 
//				+ insertDataBuffer.toString() + ")");
                
				if (!(res1 > 0)) {
                    error = WFSError.WM_INVALID_WORKITEM;
                    errorMsg = WFSErrorMsg.getMessage(error);
                    break;
                }
                userName = userName.equals("null") ? "" : userName;

                // to be checked
//                String attributeXML = "<Attributes>" + attributeStr + "</Attributes>";
//                ArrayList attribList = WFXMLUtil.convertXMLToObject(attributeXML, engine);	
				WFSUtil.printOut(engine,"attributeStr>>"+attributeStr);
                //WFSUtil.setAttributesExt(con, participant, attributeStr, engine, procInstID, nWrkItemId, null, prevActName, false, debug, false, sessionId);
                WFSUtil.setAttributesExt(con, participant, attributeStr, engine, procInstID, nWrkItemId, null, prevActName, false, true, false);
                WFSUtil.generateLog(engine, con, WFSConstant.WFL_ProcessInstanceDistributed, procInstID, wrkItemID, procDefId, prevActivity, prevActName, qId, 0, "", targetActivity, targetActName, null, null, null, null);
				if(finUserId > 0) {
					WFSUtil.generateLog(engine, con, WFSConstant.WFL_WorkItemReassigned, procInstID, wrkItemID, procDefId, 
											targetActivity, targetActName, 0, 0, "System", finUserId, userName, null, null, null, null);
				}

                // It is being commented as there is no need for making entry in summarytable for a distributed WI as it is being done for all distributed WI's in createworkitem
                // Krishan dated 14/07/2004
                // WSE_5.0.1_beta_200
                /*			  WFSUtil.genLogsummary(engine, procDefId, targetActivity, targetActName,
                                                  WFSConstant.WFL_ProcessInstanceDistributed,
                                                  0, qId, null,
                                                  0, 0, currentDate,
                                                  0, 0, "");*/
            }
            if (error == 0) {
                //OF Optimization
            	//Changes for Case Management -Adding ActivityType in WFInstrumentTable
                int itargetActivityType =WFSUtil.getActivityType(con, procDefId, itargetActivity, null, 0, dbType);
                queryString = "update WFInstrumentTable set ParentWorkItemId=?, AssignmentType=?, ActivityName=?,ActivityId=?,"
                        + "LockStatus=?, RoutingStatus =?,LockedByName=null, LockedTime=null,Q_userId=0,ActivityType=? ,PreviousStage = ? where ProcessInstanceID =?" +
                        		" and WorkItemID = ? and RoutingStatus = ? and LockStatus = ?";
                pstmt = con.prepareStatement(queryString);
                pstmt.setInt(1,parentWIIDOfParent);
                WFSUtil.DB_SetString(2, "Z", pstmt, dbType);
                WFSUtil.DB_SetString(3, stargetActName, pstmt, dbType);
                pstmt.setInt(4,itargetActivity);
                WFSUtil.DB_SetString(5, "N", pstmt, dbType);
                WFSUtil.DB_SetString(6, "R", pstmt, dbType);
                pstmt.setInt(7,itargetActivityType);
                 WFSUtil.DB_SetString(8, previousStage, pstmt, dbType);
                WFSUtil.DB_SetString(9, procInstID, pstmt, dbType);
                pstmt.setInt(10,wrkItemID);
                WFSUtil.DB_SetString(11, "Y", pstmt, dbType);
                WFSUtil.DB_SetString(12, "Y", pstmt, dbType);
                parameters.add(parentWIIDOfParent);
                parameters.add("Z");
                parameters.add(stargetActName);
                parameters.add(itargetActivity);
                parameters.add("N");
                parameters.add("R");
                parameters.add(itargetActivityType);
                parameters.add(procInstID);
                parameters.add(wrkItemID);
                parameters.add("Y");
                parameters.add("Y");
                int res = WFSUtil.jdbcExecuteUpdate(procInstID, sessionId, userId, queryString,pstmt, parameters, debug, engine);
                parameters.clear();
//				int res = stmt.executeUpdate("Insert into PendingWorklisttable(ProcessInstanceId,"
//					+ "WorkItemId,ParentWorkItemId,AssignmentType,ActivityName,ActivityId,ProcessName,"
//					+ "ProcessVersion,ProcessDefID,LastProcessedBy,ProcessedBy,EntryDateTime,"
//					+ "CollectFlag,PriorityLevel,ValidTill,Q_StreamId,Q_QueueId,Q_UserId,"
//					+ "AssignedUser,FilterValue,CreatedDateTime,WorkItemState,StateName,"
//					+ "ExpectedWorkitemDelay,PreviousStage,LockedByName,LockStatus,LockedTime, ProcessVariantId) "
//					+ "Values ( " + TO_STRING(procInstID, true, dbType) + ", " + wrkItemID
//					+ "," + parentWIIDOfParent + "," + TO_STRING("R", true, dbType) + ","
//					+ TO_STRING(stargetActName, true, dbType) + "," + itargetActivity
//					+ insertBuffer.toString() + ")");//Process Variant Support Changes

                if (!(res > 0)) {
//                    int f = stmt.executeUpdate("Delete from WorkwithPStable where ProcessInstanceID = " + TO_STRING(procInstID, true, dbType) + " and WorkItemID = " + wrkItemID);
//                    if (f != res) {
//                        error = WFSError.WM_INVALID_WORKITEM;
//                        errorMsg = WFSErrorMsg.getMessage(error);
//                    }
//                } else {
                    error = WFSError.WM_INVALID_WORKITEM;
                    errorMsg = WFSErrorMsg.getMessage(error);
                }
            }
        } catch (SQLException e) {
            WFSUtil.printErr(engine,"", e);
            error = WFSError.WFS_SQL;
            errorMsg = e.toString();
        } catch (Exception e) {
            WFSUtil.printErr(engine,"", e);
            error = WFSError.WFS_SQL;
            errorMsg = e.toString();
        } finally {
            if (stmt != null) {
                try {
                    stmt.close();
                } catch (Exception e) {}
            }
            if (pstmt != null) {
                try {
                    pstmt.close();
                } catch (Exception e) {}
            }
        }
        if (error != 0) {
            throw new JTSException(error, errorMsg);
        }
    }

    //----------------------------------------------------------------------------------------------------
    //	Function Name 						: createWorkitem
    //	Date Written (DD/MM/YYYY)			: 16/05/2002
    //	Author								: Prashant
    //	Input Parameters					: Connection , XMLParser , XMLGenerator
    //	Output Parameters					: none
    //	Return Values						: String
    //	Description							: Performs Routing of workItem from Curent Activity to
    //										  destination .
    //----------------------------------------------------------------------------------------------------
    private int createWorkitem(XMLParser parser, String engine, Connection con, int wrkItemID, String procInstID,
                                      int targetActivity, int procDefId, int activity, String cliIntrfc, String targetActName,
                                      int targetActivityType, String prevActName, boolean adhoc, String adhoctable,
                                      int finStreamId, String currentDate, boolean debug, int sessionId, int userId,String processedByStr) throws JTSException {
        /*Check if this method also needs to be modidifed for event feature in omniflow -shilpi */
        int error = 0;
        String errorMsg = "";
        Statement stmt = null;
        PreparedStatement pstmt = null;
        int count = 0;
        try {
            String adhocStr = "";
            if(adhoc)
                    adhocStr = " , AssignedUser = null "; 
            stmt = con.createStatement();
            targetActivityType = WFSConstant.ACT_RULE;

            int dbType = ServerProperty.getReference().getDBType(engine);

            // --------------------------------------------------------------------------------------
            // Changed On  : 08/03/2005
            // Changed By  : Ruhi Hira
            // Description : SrNo-1; Omniflow 6.0; Feature: DynamicRuleModification
            //				    No need to fire query, values provided by process server.
            // --------------------------------------------------------------------------------------
            ResultSet rs = null;
            /*
               ResultSet rs = stmt.executeQuery(
                      "SELECT NeverExpireFlag , ExpiryOperator, Expiry , HoldTillVariable , "
                      + "ActivityTurnAroundTime FROM ACTIVITYTABLE WHERE ProcessdefId = " + procDefId
                      + " and ActivityID = " + targetActivity);
                  if(rs.next()) {
                    String neverExpireFlag = rs.getString(1);
                    boolean expiryOp = rs.getInt(2) == WFSConstant.WF_SUB ? false : true;
                    int expDuration = rs.getInt(3);
                    String expVar = rs.getString(4);
                    expVar = rs.wasNull() ? "" : expVar.trim().toUpperCase();
             */
            //Bug # 3196
            String expectedWIDelay = " null ";
            String validTill = " null ";
            int startIndexExp = parser.getStartIndex("ExpireData", 0, Integer.MAX_VALUE);
            int endIndexExp = parser.getEndIndex("ExpireData", 0, Integer.MAX_VALUE);
            String neverExpireFlag = parser.getValueOf("NeverExpireFlag", startIndexExp, endIndexExp);
            try{
                expectedWIDelay = parser.getValueOf("ExpectedWIDelay", startIndexExp, endIndexExp);
            }catch(Exception exp){
                expectedWIDelay = " null ";
            }
            if(neverExpireFlag != null && !neverExpireFlag.equals("") && neverExpireFlag.trim().equalsIgnoreCase("Y")){
                try{
                    validTill = parser.getValueOf("ValidTill",startIndexExp, endIndexExp);
                }catch(Exception exp){
                    validTill = " null ";
                }
            }
            int qId = 0;
            /*	************************************************************************************	*/
            /*		Change By	: Krishan Dutt Dixit													*/
            /*		Reason		: Queue Id should be sent in genlog for making entry in RouteLogTable	*/
            /*		Date		: 14/07/2004															*/
            /*		Bug No.		: WSE_5.0.1_beta_186													*/
            /*	************************************************************************************	*/
            String queryStr = " Select a.QueueId"
                + " from QueueDefTable a "+WFSUtil.getTableLockHintStr(dbType)+" , QueueStreamTable "+WFSUtil.getTableLockHintStr(dbType)+" where StreamID = " + finStreamId
                + " and QueueStreamTable.QueueID =  a.QueueID and ProcessDefID = " + procDefId
                + " and ActivityID = " + targetActivity;

            rs = stmt.executeQuery(queryStr);
            if (rs.next()) {
                qId = rs.getInt(3);
            }
            if (rs != null) {
                rs.close();
            }
            //Bug # 3196
			//Process Variant Support Changes
            String queryString = null;
            ArrayList parameters = new ArrayList();
        	//Changes for Case Management -Adding ActivityType in WFInstrumentTable
            queryString = "update WFInstrumentTable set ActivityName = ?, ActivityId = ?, EntryDateTime = "+WFSUtil.getDate(dbType)+", AssignmentType = ?,"
                    + "ValidTill=?, Q_StreamId=?, Q_QueueId=?, WorkItemState = ?,Statename = ?,  ExpectedWorkitemDelay=?,PreviousStage=?,"
                    + "RoutingStatus = ?, LockStatus =?,ActivityType = ?  " + adhocStr +processedByStr+ " where ProcessInstanceId = ? AND WorkitemId = ? and RoutingStatus ";
            if(adhoc)
                queryString = queryString + " in('N','R') ";
            else
                queryString = queryString + " = 'Y' ";

            pstmt = con.prepareStatement(queryString);
            WFSUtil.DB_SetString(1, targetActName, pstmt, dbType);
            pstmt.setInt(2, targetActivity);
            WFSUtil.DB_SetString(3, adhoc ? "D" : "R", pstmt, dbType);
            WFSUtil.DB_SetString(4, validTill, pstmt, dbType);
            pstmt.setInt(5, 0);
            pstmt.setInt(6, 0);
            pstmt.setInt(7, 6);
            WFSUtil.DB_SetString(8, WFSConstant.WF_COMPLETED, pstmt, dbType);
            WFSUtil.DB_SetString(9, expectedWIDelay , pstmt, dbType);
            WFSUtil.DB_SetString(10, prevActName, pstmt, dbType);
            WFSUtil.DB_SetString(11, "Y", pstmt, dbType);
            WFSUtil.DB_SetString(12, "N", pstmt, dbType);
            pstmt.setInt(13,targetActivityType);
            WFSUtil.DB_SetString(14, procInstID, pstmt, dbType);
            pstmt.setInt(15, wrkItemID);
            //WFSUtil.DB_SetString(15, "Y", pstmt, dbType);
            parameters.add(targetActName);
            parameters.add(targetActivity);
            parameters.add((adhoc ? "D" : "R"));
            parameters.add(validTill);
            parameters.add(0);
            parameters.add(0);
            parameters.add(6);
            parameters.add(WFSConstant.WF_COMPLETED);
            parameters.add(expectedWIDelay);
            parameters.add(prevActName);
            parameters.add("Y");
            parameters.add("N");
            parameters.add(targetActivityType);
            parameters.add(procInstID);
            parameters.add(wrkItemID);
            //parameters.add("Y");
            int res = WFSUtil.jdbcExecuteUpdate(procInstID, sessionId, userId, queryString, pstmt, parameters, debug, engine);
            parameters.clear();
//            int res = stmt.executeUpdate("Insert into WorkDoneTable "
//                                         + "(ProcessInstanceId,WorkItemId,ProcessName,ProcessVersion,ProcessDefID,LastProcessedBy,"
//                                         + "ProcessedBy,ActivityName,ActivityId,EntryDateTime,"
//                                         + "ParentWorkItemId,AssignmentType,"
//                                         + "CollectFlag,PriorityLevel, ValidTill,"
//                                         + "Q_StreamId,Q_QueueId,"
//                                         + "CreatedDateTime,WorkItemState,Statename, ExpectedWorkitemDelay, PreviousStage, ProcessVariantId) Select "
//                                         + "ProcessInstanceId,WorkItemId,ProcessName,ProcessVersion,ProcessDefID,LastProcessedBy,"
//                                         + "ProcessedBy, " + TO_STRING(targetActName, true, dbType) + " , " + targetActivity + " , " + WFSUtil.getDate(dbType)
//                                         + ",ParentWorkItemId, "+ (adhoc ? TO_STRING("D", true, dbType) : TO_STRING("R", true, dbType)) + " ,CollectFlag,PriorityLevel, " + validTill
//                                         + " ,0,0, "
//                                         + "CreatedDateTime,6, " + TO_STRING(WFSConstant.WF_COMPLETED, true, dbType) + " , " + expectedWIDelay + ","
//                                         + TO_STRING(prevActName, true, dbType) + " , ProcessVariantId from " + (adhoc ? adhoctable
//                : "WorkwithPStable") + " where ProcessInstanceID = " + TO_STRING(procInstID, true, dbType) + " and WorkItemID = "
//                                         + wrkItemID);
            if (res <= 0) {
//                int f = stmt.executeUpdate("Delete from " + (adhoc ? adhoctable : "WorkwithPStable") + " where ProcessInstanceID = " + TO_STRING(procInstID.trim(), true, dbType) + " and WorkItemID = " + wrkItemID);
//                if (f != res) {
//                    error = WFSError.WM_INVALID_WORKITEM;
//                    errorMsg = WFSErrorMsg.getMessage(error);
//                }
//            } else {
                error = WFSError.WM_INVALID_WORKITEM;
                errorMsg = WFSErrorMsg.getMessage(error);
            }
            if (error == 0) {
				WFSUtil.generateLog(engine, con, WFSConstant.WFL_ProcessInstanceRouted, procInstID, wrkItemID, procDefId, 
					activity, prevActName, qId, 0, "", targetActivity, targetActName, currentDate, null, null, null);
            }
        } catch (SQLException e) {
            WFSUtil.printErr(engine,"", e);
            error = WFSError.WFS_SQL;
            errorMsg = e.toString();
        } catch (Exception e) {
            WFSUtil.printErr(engine,"", e);
            error = WFSError.WFS_SYS;
            errorMsg = e.toString();
        } finally {
            try {
                if (stmt != null) {
                    stmt.close();
                }
                if (pstmt != null) {
                    pstmt.close();
                }
            } catch (Exception e) {}

            
        }
        if (error != 0) {
            throw new JTSException(error, errorMsg);
        }
        return count;
    }

    // SPAWN SUB PROCESS YET TO BE DONE

    //----------------------------------------------------------------------------------------------------
    //	Function Name 						: spawnProcess
    //	Date Written (DD/MM/YYYY)			: 31/05/2003
    //	Author								: Prashant
    //	Input Parameters					: String engine , Connection con , String procInstId, int wrkItemId ,
    //                             int targetActivityId , int procDefID , String targetActName ,
    //                             boolean adhoc , XMLParser parser
    //	Output Parameters					: none
    //	Return Values						: String
    //	Description							: Performs the creation of a Child Process
    //  Change Description                  : Bug # 1715
    //----------------------------------------------------------------------------------------------------
    private void spawnProcess(String engine, Connection con,WFParticipant participant, String procInstId, int wrkItemId,
            int targetActivityId, int procDefID, String targetActName, boolean adhoc, XMLParser parser,
            int procDefId, int prevActivity, String adhoctable,
            String prevActName, String currentDate, String childProcessInstanceID,int childWorkItemID, int childProcessDefID, int childActivityID,
            int sessionId,int userID,boolean debug) throws JTSException {
        //String pinstId = "";
        int error = 0;
        String errorMsg = "";
        //Statement stmt = null;
        boolean throwException =false;
        PreparedStatement pstmt = null;
        String activityTurnAroundTime = null;
        //String calFlag = "";
        //int count = 0;
        //int durationId = 0;
        String queryString = null;
        ArrayList parameters = new ArrayList();
        ResultSet rs = null;
        String adhocStr = "";
        if(adhoc)
                adhocStr = " , AssignedUser = null "; 
        try {
            // stmt = con.createStatement();
            int targetActivityType = WFSConstant.ACT_SUBPROC;
            int dbType = ServerProperty.getReference().getDBType(engine);
            if(prevActName==null || prevActName.equals("")){
            pstmt = con.prepareStatement(" Select ActivityName from ActivityTable " +  WFSUtil.getTableLockHintStr(dbType)+
                                          " where ProcessDefId = ? and  ActivityID = ? ");
            pstmt.setInt(1, procDefId);
            pstmt.setInt(2, prevActivity);
            pstmt.execute();
            rs = pstmt.getResultSet();
            if (rs.next()) 
                prevActName = rs.getString(1);
            if (rs != null)
            {
                rs.close();
                rs = null;
            }
            if(pstmt != null)
            {
                pstmt.close();
                pstmt = null;
            }
            }
                //----------------------------------------------------------------------------
                // Changed By											: Prashant
                // Reason / Cause (Bug No if Any)	: Bug No TSR_3.0.2.0015
                // Change Description							:	SubProcesses to be started by System user rather
                //																	than the DMS users, and audit to be generated
                //																	whenever a subprocess is created.
                //----------------------------------------------------------------------------
                //String username = "System";
                //boolean success = false;
                //if (rs != null)
                //  rs.close();
                //pstmt.close();

                //stmt = con.createStatement();
                //SrNo-7
                //Bug # 1716
                //rs = stmt.executeQuery(
                  //  " SELECT ActivityTurnAroundTime , TATCalFlag, " + WFSUtil.getDate(dbType) + " as CurrDateTime FROM ACTIVITYTABLE " + WFSUtil.getTableLockHintStr(dbType) + " WHERE ProcessdefId = " + procDefID + " and ActivityID = " +
                   // targetActivityId);
	            pstmt = con.prepareStatement(" SELECT ActivityTurnAroundTime , TATCalFlag, " + WFSUtil.getDate(dbType) + " as CurrDateTime FROM ACTIVITYTABLE WHERE ProcessdefId = ? and ActivityID = ?");
	            pstmt.setInt(1, procDefId);
	            pstmt.setInt(2, targetActivityId);
	            pstmt.execute();
	            rs = pstmt.getResultSet();
                java.util.Date currentDateTime = null;
                Calendar cal = null;

                if (rs.next()) {
                	String calFlag = rs.getString("TATCalFlag");
                    int durationId = rs.getInt(1);
                    if (durationId <= 0) { //Bug # 1716
                        activityTurnAroundTime = " null ";
                    } else {
                        HashMap map = (HashMap) CachedObjectCollection.getReference().getCacheObject(con, engine, procDefId, WFSConstant.CACHE_CONST_WFDuration, "").getData();
                        WFDuration duration = (WFDuration )map.get(durationId + "");
                        if (duration != null) {
                            String years = duration.getYears();
                            String months = duration.getMonths();
                            String days = duration.getDays();
                            String hours = duration.getHours();
                            String minutes = duration.getMinutes();
                            String seconds = duration.getSeconds();
                            //Bug # 1715
                            currentDateTime = (java.util.Date) rs.getTimestamp("CurrDateTime");
                            cal = Calendar.getInstance();
                            if (calFlag != null && !calFlag.equals("") && calFlag.trim().equals("Y")) {
								/*Changed By: Shilpi S
                                  Changed On: 27th August 2009 
                                  Changed For: WFS_8.0_026, SrNo-13, Workitem based calendar*/
								/*do we need to use this opattr for getting value of CalendarName process attribute*/
                                /*no need to fetch CalenderName from map--Shweta Singhal*/
//								WMAttribute calAttrib = (WMAttribute)opattr.get("CALENDARNAME"); /*key is kept in upper case*/
//								String calendarName = calAttrib.value; /*need to check what it returns*/
                                queryString = "Select CALENDARNAME from WFInstrumentTable "+ WFSUtil.getTableLockHintStr(dbType)+ " where ProcessInstanceId =? and WorkitemId =?";
                                pstmt= con.prepareStatement(queryString);
                                WFSUtil.DB_SetString(1, procInstId, pstmt, dbType);
                                pstmt.setInt(2,wrkItemId);
                                parameters.add(procInstId);
                                parameters.add(wrkItemId);
                                rs = WFSUtil.jdbcExecuteQuery(procInstId, sessionId, userID, queryString, pstmt, parameters, debug, engine);
                                parameters.clear();
                                String calendarName = null;
                                if(rs.next()){
                                    calendarName = rs.getString("CALENDARNAME");
                                }
                                WFCalAssocData wfCalAssocData = WFSUtil.getWICalendarInfo(con, engine, procDefId, Integer.toString(targetActivityId), calendarName);
								if (wfCalAssocData != null) {
                                    cal.setTime(WFCalUtil.getSharedInstance().getNextDateTime(currentDateTime, Integer.parseInt(days), Integer.parseInt(hours), Integer.parseInt(minutes), wfCalAssocData.getProcessDefId(), wfCalAssocData.getCalId()));
                                    cal.add(Calendar.YEAR, Integer.parseInt(years));
                                    cal.add(Calendar.MONTH, Integer.parseInt(months));
                                    activityTurnAroundTime = WFSUtil.TO_DATE(new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.US).format(cal.getTime()), true, dbType);
                                } else {
                                    activityTurnAroundTime = "null";
                                }
                            } else {
                                cal.setTime(currentDateTime);
                                cal.add(Calendar.YEAR, Integer.parseInt(years));
                                cal.add(Calendar.MONTH, Integer.parseInt(months));
                                cal.add(Calendar.DATE, Integer.parseInt(days));
                                cal.add(Calendar.HOUR, Integer.parseInt(hours));
                                cal.add(Calendar.MINUTE, Integer.parseInt(minutes));
                                activityTurnAroundTime = WFSUtil.TO_DATE(new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.US).format(cal.getTime()), true, dbType);
                            }
                        } else {
                    activityTurnAroundTime = " null ";
                    }
                   }

                    if (rs != null){
                        rs.close();
                        rs = null;
                    }
                    if(pstmt != null)
                    {
                        pstmt.close();
                        pstmt = null;
                    }

                        /*pstmt = con.prepareStatement(" Select ProcessDefId,ProcessDefTable.ProcessName from "
                                                     + "ProcessDefTable,(Select ProcessDefTable.ProcessName,"
                                                     + "Max(VersionNo) MaxVersion from IMPORTEDPROCESSDEFTABLE,"
                                                     + "ProcessDefTable where IMPORTEDPROCESSDEFTABLE.ProcessDefID = ? "
                                                     + "and ActivityID = ? and ImportedProcessName = ProcessName "
                                                     + "and upper(rtrim(ProcessState)) = " + WFSConstant.WF_VARCHARPREFIX + "ENABLED' "
                                                     + "group By ProcessDefTable.ProcessName ) b "
                                                     + "where b.ProcessName = ProcessDefTable.ProcessName "
                                                     + "and MaxVersion = ProcessDefTable.VersionNo ");*/
                    /*pstmt = con.prepareStatement(" Select ProcessDefId,ProcessDefTable.ProcessName from "
                                                 + "ProcessDefTable,(Select ProcessDefTable.ProcessName,"
                                                 + "Max(VersionNo) as MaxVersion from IMPORTEDPROCESSDEFTABLE,"
                                                 + "ProcessDefTable where IMPORTEDPROCESSDEFTABLE.ProcessDefID = ? "
                                                 + "and ActivityID = ? and ImportedProcessName = ProcessName and "
                                                 + TO_STRING("ProcessState", false, dbType) + " = "
                                                 + TO_STRING("ENABLED", true, dbType) + " group By ProcessDefTable.ProcessName ) b " + "where b.ProcessName = ProcessDefTable.ProcessName "
                                                 + " and MaxVersion = ProcessDefTable.VersionNo ");
                    pstmt.setInt(1, procDefID);
                    pstmt.setInt(2, targetActivityId);
                    pstmt.execute();
                    rs = pstmt.getResultSet();
                    if (rs.next()) {
                        int newProcDefId = rs.getInt(1);
                        String tempProc = rs.getString(2);

                        rs.close();
                        pstmt.close();

                        //int userID = 0;
                        int queueId = 0;
                        int streamId = 0;
                        String queuename = "";

                        // --------------------------------------------------------------------------------------
                        // Changed On  : 18/03/2005
                        // Changed By  : Ruhi Hira
                        // Description : SrNo-2; Omniflow 6.0; Feature: MultipleIntroduction
                        //				    As route designer is not providing any option to select introduction
                        //					workstep for subprocess, workitems will always be created in
                        //					default workstep in sub process.
                        // --------------------------------------------------------------------------------------
                        /*pstmt = con.prepareStatement(
                            "Select QueueDeftable.QueueID , QueueName," + WFSUtil.getDate(dbType)
                            + " from QueueDeftable , "
                            + " QueueStreamTable where QueueDeftable.QueueID = QueueStreamTable.QueueID " + " and ProcessDefID = ? and ActivityID = (Select Activityid from Activitytable where Processdefid = ? and ActivityType = "
                            + WFSConstant.ACT_INTRODUCTION + " and Upper(primaryActivity) = N'Y')");
                        pstmt = con.prepareStatement(
                            "Select QueueDeftable.QueueID , QueueName," + WFSUtil.getDate(dbType)
                            + " from QueueDeftable "+WFSUtil.getTableLockHintStr(dbType)+" , "
                            + " QueueStreamTable "+WFSUtil.getTableLockHintStr(dbType)+" where QueueDeftable.QueueID = QueueStreamTable.QueueID " + " and ProcessDefID = ? and ActivityID = (Select Activityid from Activitytable where Processdefid = ? and ActivityType = "
                            + WFSConstant.ACT_INTRODUCTION + " and " + TO_STRING("primaryActivity", false, dbType) + " = "
                            + TO_STRING("Y", true, dbType) + ")");
                        pstmt.setInt(1, newProcDefId);
                        pstmt.setInt(2, newProcDefId);
                        pstmt.execute();
                        rs = pstmt.getResultSet();
                        if (rs.next()) {
                            queueId = rs.getInt(1);
                            queuename = rs.getString(2);
                            currentDate = rs.getString(3);
                        }
                        if (rs != null)
                            rs.close();
                        pstmt.close();

                        StringBuffer activityId = new StringBuffer("");
                        StringBuffer activityName = new StringBuffer("");
                        *//** 01/02/2008, Bugzilla Bug 3511, createProcessInstance moved to WFSUtil
                         * wfs_ejb classes not accessible from wfsshared. - Ruhi Hira *//*
                        pinstId = WFSUtil.createProcessInstance(con, newProcDefId, userID, username,
                            streamId, queueId, queuename, dbType, activityId, activityName, false, parser,procVarId, debug, sessionId, engine);
                        queueid = queueid.append(queueId + "");
						WFSUtil.generateLog(engine, con, WFSConstant.WFL_SpawnProcess, procInstId, 0, procDefID, 
							targetActivityId, targetActName, queueId, userID, username, 0, pinstId, null, null, null, null);


						WFSUtil.generateLog(engine, con, WFSConstant.WFL_ProcessSpawn, pinstId, 0, newProcDefId, 
							0, "", queueId, userID, username, 0, procInstId, null, null, null, null);

						WFSUtil.generateLog(engine, con, WFSConstant.WFL_CreateProcessInstance, pinstId, 0, newProcDefId, Integer.parseInt(activityId.toString()), null, queueId,
                                       userID, username, 0, "", currentDate, null, null, null);
                        //----------------------------------------------------------------------------
                        // Changed By											: Prashant
                        // Reason / Cause (Bug No if Any)	: Bug No TSR_3.0.1_009
                        // Change Description							:	Child ProcessInstances linked to the Parenr
                        //----------------------------------------------------------------------------

                        *//**
                         * Prepared Statement changes for DB2 support.
                         * Bugzilla Bug 61, Aug 14th 2006 - Ruhi Hira.
                         *//*
                        pstmt = con.prepareStatement(" Insert into WFLinkstable Select " + TO_STRING(pinstId, true, dbType) + " , " + TO_STRING(procInstId, true, dbType) + ",'N','N' "+WFSUtil.getDummyTableName(dbType)
                            + " where not exists ( Select * from WFLinkstable where "
                            + " ChildProcessInstanceID = ? and ParentProcessInstanceId = ? ) ");
                        WFSUtil.DB_SetString(1, procInstId, pstmt, dbType);
                        WFSUtil.DB_SetString(2, pinstId, pstmt, dbType);
                        int res = pstmt.executeUpdate();
                        if (res > 0) {
							WFSUtil.generateLog(engine, con, WFSConstant.WFL_link, pinstId, 0, procDefID, targetActivityId, targetActName, 0,
                                           userID, username, 0, procInstId, null, null, null, null);
                        }
                        
                        //OF Optimization
                        queryString = "Update WFInstrumentTable Set ChildProcessInstanceID = ?,ChildWorkItemID = ? where ProcessInstanceId = ? and Workitemid = ?";
                        pstmt = con.prepareStatement(queryString);
                        WFSUtil.DB_SetString(1, pinstId, pstmt, dbType);
                        pstmt.setInt(2, 1);
                        WFSUtil.DB_SetString(3, procInstId, pstmt, dbType);
                        pstmt.setInt(4, wrkItemId);
                        parameters.add(pinstId);
                        parameters.add(1);
                        parameters.add(procInstId);
                        parameters.add(wrkItemId);
                        res = WFSUtil.jdbcExecuteUpdate(procInstId, sessionId, userID, queryString, pstmt, parameters, debug, engine);
                        parameters.clear();
                        //res = pstmt.executeUpdate();
                    }
                    else {
                        //Bug 50668 - Check to be Applied if the SubProcess is not enabled. 
                    	 throwException =true;
                    }
                } else {
                    if (rs != null)
                        rs.close();
                    pstmt.close();
                }*/
                if (childProcessInstanceID != null && !childProcessInstanceID.equals("")) {
				//Process Variant Support Changes
                    // OF Optimization
                    String tempcolumn = null;
                    tempcolumn = activityTurnAroundTime.trim().equalsIgnoreCase("null") ? "" : "ExpectedWorkitemDelay";
                    if(!tempcolumn.equals("")){
                        tempcolumn = tempcolumn+" ="+activityTurnAroundTime+",";
                    }
                	//Changes for Case Management -Adding ActivityType in WFInstrumentTable
                    queryString = "update WFInstrumentTable set ActivityName = ?, ActivityId = ?, EntryDateTime = "+WFSUtil.getDate(dbType)+", AssignmentType = ?, "
                            + "WorkItemState = ?,Statename = ?," + tempcolumn + " RoutingStatus = ?,LockStatus = ?,ActivityType = ? ,Q_UserId= 0 " + adhocStr + ",LockedByName = null, LockedTime = null,ChildProcessinstanceId = ? ,ChildWorkitemId = ?  where ProcessInstanceId = ? AND WorkitemId = ? and RoutingStatus";
                    if(adhoc)
                        queryString = queryString + " in('N','R') ";
                    else
                        queryString = queryString + " = 'Y' ";
                    pstmt = con.prepareStatement(queryString);
                    WFSUtil.DB_SetString(1, targetActName, pstmt, dbType);
                    pstmt.setInt(2, targetActivityId);
                    WFSUtil.DB_SetString(3, "S", pstmt, dbType);
                    pstmt.setInt(4, 3);
                    WFSUtil.DB_SetString(5, WFSConstant.WF_SUSPENDED, pstmt, dbType);
                    WFSUtil.DB_SetString(6, "R", pstmt, dbType);
                    WFSUtil.DB_SetString(7, "N", pstmt, dbType);
                    pstmt.setInt(8, targetActivityType);
                    WFSUtil.DB_SetString(9, childProcessInstanceID, pstmt, dbType);
                    pstmt.setInt(10, childWorkItemID);
                    WFSUtil.DB_SetString(11, procInstId, pstmt, dbType);
                    pstmt.setInt(12, wrkItemId);
                    //WFSUtil.DB_SetString(10, "Y", pstmt, dbType);
                    parameters.add(targetActName);
                    parameters.add(targetActivityId);
                    parameters.add("S");
                    parameters.add(3);
                    parameters.add(WFSConstant.WF_SUSPENDED);
                    parameters.add("R");
                    parameters.add("N");
                    parameters.add(targetActivityType);
                    parameters.add(childProcessInstanceID);
                    parameters.add(childWorkItemID);
                    parameters.add(procInstId);
                    parameters.add(wrkItemId);
                    //parameters.add("Y");
                    int res = WFSUtil.jdbcExecuteUpdate(procInstId, sessionId, userID, queryString, pstmt, parameters, debug, engine);
                    parameters.clear();
//                    int res = stmt.executeUpdate("Insert into PendingWorklistTable (ProcessInstanceId,"
//                                                 + "WorkItemId,ProcessName,ProcessVersion,ProcessDefID,LastProcessedBy,"
//                                                 + "ProcessedBy,ActivityName,ActivityId,EntryDateTime,ParentWorkItemId,"
//                                                 + "AssignmentType,CollectFlag,PriorityLevel,"
//                                                 + "CreatedDateTime,WorkItemState,"
//                                                 + "Statename," + (activityTurnAroundTime.trim().equalsIgnoreCase("null") ? "" : "ExpectedWorkitemDelay,") + "PreviousStage, ProcessVariantId) Select "
//                                                 + "ProcessInstanceId,WorkItemId,ProcessName,ProcessVersion,ProcessDefID,"
//                                                 + "LastProcessedBy,ProcessedBy, " + TO_STRING(targetActName, true, dbType) + " , " + targetActivityId + " , "
//                                                 + WFSUtil.getDate(dbType) + ",ParentWorkItemId," + TO_STRING( (adhoc ? "D" : "R"), true, dbType) + " , " + "CollectFlag,PriorityLevel,"
//                                                 + "CreatedDateTime,3, " + TO_STRING(WFSConstant.WF_SUSPENDED, true, dbType) + " , " + (activityTurnAroundTime.trim().equalsIgnoreCase("null") ? "" : activityTurnAroundTime + ",")
//                                                 + " PreviousStage, ProcessVariantId from " + (adhoc ? adhoctable : "WorkwithPStable") + " WHERE ProcessInstanceId = " + TO_STRING(procInstId, true, dbType) + " AND WorkitemId = " + wrkItemId);
                    if (res <= 0) {
//                        int f = stmt.executeUpdate("Delete from " + (adhoc ? adhoctable : "WorkwithPStable")
//                            + " where ProcessInstanceID = " + TO_STRING(procInstId.trim(), true, dbType) + " and WorkItemID = " + wrkItemId);
//                        if (f != res) {
//                            error = WFSError.WM_INVALID_WORKITEM;
//                            errorMsg = WFSErrorMsg.getMessage(error);
//                        }
//                    } else {
                        error = WFSError.WM_INVALID_WORKITEM;
                        errorMsg = WFSErrorMsg.getMessage(error);
                    }else{
                        WFSUtil.generateLog(engine, con, WFSConstant.WFL_SpawnProcess, procInstId, 0, procDefId, 
							targetActivityId, targetActName, childActivityID, 0, "System", 0, childProcessInstanceID, null, null, null, null);
                        WFSUtil.generateLog(engine, con, WFSConstant.WFL_ProcessSpawn, childProcessInstanceID, 0, childProcessDefID, 
                                childActivityID, "", 0, 0, "System", 0, procInstId, null, null, null, null);
                    }
                    
                } else if(adhoc) {
				//Process Variant Support Changes
                	if(!throwException){
                    String tempcolumn = null;
                    tempcolumn = activityTurnAroundTime.trim().equalsIgnoreCase("null") ? "" : "ExpectedWorkitemDelay";
                    if(!tempcolumn.equals("=")){
                        tempcolumn = tempcolumn+" ="+activityTurnAroundTime+",";
                    }
                	//Changes for Case Management -Adding ActivityType in WFInstrumentTable
                    queryString = "update WFInstrumentTable set ActivityName = ?, ActivityId = ?, EntryDateTime = "+WFSUtil.getDate(dbType)+", AssignmentType = ?, "
                            + "WorkItemState = ?,Statename = ?,"+tempcolumn+" RoutingStatus = ?, LockStatus =?,ActivityType = ? " + adhocStr + " where ProcessInstanceId = ? AND WorkitemId = ? and RoutingStatus ";
                    if(adhoc)
                        queryString = queryString + " in('N','R') ";
                    else
                        queryString = queryString + " = 'Y' ";
                    pstmt = con.prepareStatement(queryString);
                    WFSUtil.DB_SetString(1, targetActName, pstmt, dbType);
                    pstmt.setInt(2, targetActivityId);
                    WFSUtil.DB_SetString(3, "S", pstmt, dbType);
                    pstmt.setInt(4, 6);
                    WFSUtil.DB_SetString(5, WFSConstant.WF_COMPLETED, pstmt, dbType);
                    WFSUtil.DB_SetString(6, "Y", pstmt, dbType);
                    WFSUtil.DB_SetString(7, "N", pstmt, dbType);
                    pstmt.setInt(8, targetActivityType);
                    WFSUtil.DB_SetString(9, procInstId, pstmt, dbType);
                    pstmt.setInt(10, wrkItemId);
                    //WFSUtil.DB_SetString(10, "Y", pstmt, dbType);
                    parameters.add(targetActName);
                    parameters.add(targetActivityId);
                    parameters.add(("S"));
                    parameters.add(6);
                    parameters.add(WFSConstant.WF_COMPLETED);
                    parameters.add("Y");
                    parameters.add("N");
                    parameters.add(targetActivityType);
                    parameters.add(procInstId);
                    parameters.add(wrkItemId);
                    //parameters.add("Y");
                    int res = WFSUtil.jdbcExecuteUpdate(procInstId, sessionId, userID, queryString, pstmt, parameters, debug, engine);
                    parameters.clear();
//                    int res = stmt.executeUpdate("Insert into WorkDoneTable (ProcessInstanceId,"
//                                                 + "WorkItemId,ProcessName,ProcessVersion,ProcessDefID,LastProcessedBy,"
//                                                 + "ProcessedBy,ActivityName,ActivityId,EntryDateTime,ParentWorkItemId,"
//                                                 + "AssignmentType,CollectFlag,PriorityLevel,"
//                                                 + "CreatedDateTime,WorkItemState,"
//                                                 + "Statename," + (activityTurnAroundTime.trim().equalsIgnoreCase("null") ? "" : "ExpectedWorkitemDelay,") + "PreviousStage, ProcessVariantId) Select "
//                                                 + "ProcessInstanceId,WorkItemId,ProcessName,ProcessVersion,ProcessDefID,"
//                                                 + "LastProcessedBy,ProcessedBy, " + TO_STRING(targetActName, true, dbType) + " , " + targetActivityId + " , "
//                                                 + WFSUtil.getDate(dbType) + " ,ParentWorkItemId, " + TO_STRING( (adhoc ? "D" : "Y"), true, dbType) + " , " + "CollectFlag,PriorityLevel"
//                                                 + " ,CreatedDateTime,6, " + TO_STRING(WFSConstant.WF_COMPLETED, true, dbType) + " , " + (activityTurnAroundTime.trim().equalsIgnoreCase("null") ? "" : activityTurnAroundTime + ",")
//                                                 + " PreviousStage, ProcessVariantId from " + (adhoc ? adhoctable : "WorkwithPStable") + " WHERE ProcessInstanceId = " + TO_STRING(procInstId, true, dbType) + " AND WorkitemId = " + wrkItemId);
                    if (res <= 0) {
//                        int f = stmt.executeUpdate("Delete from " + (adhoc ? adhoctable : "WorkwithPStable")
//                            + " where ProcessInstanceID = " + TO_STRING(procInstId.trim(), true, dbType) + " and WorkItemID = " + wrkItemId);
//                        if (f != res) {
//                            error = WFSError.WM_INVALID_WORKITEM;
//                            errorMsg = WFSErrorMsg.getMessage(error);
//                        //}
//                    } else {
                        error = WFSError.WM_INVALID_WORKITEM;
                        errorMsg = WFSErrorMsg.getMessage(error);
                    }
                }
                }
                else
                {
                    error = -1;
                    StringBuffer suspendStr = new StringBuffer();
                    String suspensionCause = WFSErrorMsg.getMessage(WFSError.WM_INVALID_WORKITEM) + " : Neither Child present Nor Adhoc routed";
					suspendStr.append("<SuspendedWorkItemDetails>");
					
                    suspendStr.append("<ProcessDefId>").append(procDefId).append("</ProcessDefId>");
                    suspendStr.append("<ProcessName>").append(parser.getValueOf("ProcessName")).append("</ProcessName>");
					suspendStr.append("<WorkItemName>").append(procInstId).append("</WorkItemName>");
					suspendStr.append("<ProcessInstanceId>").append(procInstId).append("</ProcessInstanceId>");
					suspendStr.append("<WorkItemId>").append(wrkItemId).append("</WorkItemId>");
					suspendStr.append("<PrevActivityName>").append(prevActName).append("</PrevActivityName>");
					
                    suspendStr.append("<PrevActivityId>").append(prevActivity).append("</PrevActivityId>");
                    suspendStr.append("<ActivityId>").append(targetActivityId).append("</ActivityId>");
					suspendStr.append("<ActivityName>").append(targetActName).append("</ActivityName>");
					suspendStr.append("<SuspensionCause>").append(suspensionCause).append("</SuspensionCause>");
                    suspendStr.append("<AssignmentType>").append("P").append("</AssignmentType>");
                    suspendStr.append("<DebugFlag>").append(debug).append("</DebugFlag>");
                    suspendStr.append("<SessionId>").append(sessionId).append("</SessionId>");
					suspendStr.append("</SuspendedWorkItemDetails>");
					 XMLParser suspendParser = new XMLParser(suspendStr.toString());
//                    suspendWorkItem(engine, con, participant, suspendParser, procInstId, wrkItemId,debug,sessionId, userID);
                     WFSUtil.suspendWorkItem(engine, con, participant, suspendParser);
                }
                if ((error == 0)&&!(!throwException)) {
					WFSUtil.generateLog(engine, con, WFSConstant.WFL_ProcessInstanceRouted, procInstId, wrkItemId, procDefID, 
						prevActivity, prevActName, 0, 0, "", targetActivityId, targetActName, currentDate, null, null, null);
                }
                else if (error == -1)
                    error = 0;
            } /*else {
                if (rs != null)
                    rs.close();
                pstmt.close();
            }*/
        } catch (SQLException e) {
            WFSUtil.printErr(engine,"", e);
            error = WFSError.WFS_SQL;
            errorMsg = e.toString();
        } catch (Exception e) {
            WFSUtil.printErr(engine,"", e);
            error = WFSError.WFS_SYS;
            errorMsg = e.toString();
        } finally {
            try {
               if (pstmt != null) {
                    pstmt.close();
                    pstmt= null;
                }
            } catch (Exception e) {}
        }
        if (error != 0) {
            throw new JTSException(error, errorMsg);
        }
        if(throwException){
        	int mainCode = WFSError.WF_SUB_PROCESS_DISABLED;
        	int subCode = 0;
        	//Changes for Bug 50668 - Check to be Applied if the SubProcess is not enabled. 
            throw new WFSException(mainCode,
                    subCode, WFSError.WF_TMP,
                    WFSErrorMsg.getMessage(mainCode),
                    WFSErrorMsg.getMessage(subCode));
        }
        //return pinstId;
    }

    private int upDateWI(Connection con, String prevActivity, int targetActivity,
            String targetActName, java.util.Date expiry, String pInstId, int wrkItemID, int dbType,
            boolean adhoc, String engine, XMLParser parser, boolean debug, int sessionId, int userId, String processedByStr) throws SQLException, JTSException {
        PreparedStatement pstmt = null;
        int res = 0;
        int error = 0;
        String errorMsg = "";
        String queryStr = null;
        String validStr =null;
        ArrayList parameters = new ArrayList();
        String adhocStr = "";
        if(adhoc)
                adhocStr = " , AssignedUser = null "; 
        try {
		//Process Variant Support Changes
            //OF Optimization
            if(expiry == null )
                validStr = "" ;
            else
                validStr = ", ValidTill = "+WFSUtil.TO_DATE(new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.US).format(expiry), true, dbType);
        	//Changes for Case Management -Adding ActivityType in WFInstrumentTable
            int targetActivityType = WFSUtil.getActivityType(con, 0, targetActivity, pInstId, wrkItemID, dbType);
            queryStr = "Update WFInstrumentTable set ActivityName=?, ActivityId=?,EntryDateTime="+WFSUtil.getDate(dbType)+",AssignmentType=?,WorkItemState=?,"
                    + "Statename=?,PreviousStage =?,LockStatus =?,RoutingStatus =?"+validStr+",ActivityType = ? " + adhocStr+processedByStr+" where ProcessInstanceID = ? and WorkItemID = ? and RoutingStatus";
            if(adhoc)
                queryStr = queryStr + " in('N','R')";
            else
                queryStr = queryStr + " = 'Y' ";

            pstmt = con.prepareStatement(queryStr);
            WFSUtil.DB_SetString(1, targetActName, pstmt, dbType);
            pstmt.setInt(2,targetActivity);
            WFSUtil.DB_SetString(3, adhoc ? "D" : "R", pstmt, dbType);
            pstmt.setInt(4,6);
            WFSUtil.DB_SetString(5, WFSConstant.WF_COMPLETED, pstmt, dbType);
            WFSUtil.DB_SetString(6, prevActivity, pstmt, dbType);
            WFSUtil.DB_SetString(7, "N", pstmt, dbType);
            WFSUtil.DB_SetString(8, adhoc ? "Y" : "R", pstmt, dbType);
            pstmt.setInt(9,targetActivityType);
            WFSUtil.DB_SetString(10, pInstId.trim(), pstmt, dbType);
            pstmt.setInt(11,wrkItemID);
            //WFSUtil.DB_SetString(11, "Y", pstmt, dbType);
            parameters.add(targetActName);
            parameters.add(targetActivity);
            parameters.add(adhoc ? "D" : "R");
            parameters.add(6);
            parameters.add(WFSConstant.WF_COMPLETED);
            parameters.add(prevActivity);
            parameters.add("N");
            parameters.add(adhoc ? "Y" : "R");
            parameters.add(targetActivityType);
            parameters.add(pInstId.trim());
            parameters.add(wrkItemID);
            //parameters.add("Y");
//            pstmt = con.prepareStatement("Insert into " + (adhoc ? "WorkDoneTable" : "PendingWorklisttable")
//                                         + " (ProcessInstanceId, WorkItemId, ProcessName, ProcessVersion, ProcessDefID, LastProcessedBy, "
//                                         + "ProcessedBy, ActivityName, ActivityId, EntryDateTime, ParentWorkItemId, "
//                                         + "AssignmentType, CollectFlag, PriorityLevel, "
//                                         + (expiry == null ? "" : "ValidTill, ") //+ "AssignmentType, CollectFlag, PriorityLevel, ValidTill, "
//                                         + "CreatedDateTime, WorkItemState, "
//                                         + "Statename, PreviousStage, ProcessVariantId) Select "
//                                         + "ProcessInstanceId, WorkItemId, ProcessName, ProcessVersion, ProcessDefID, "
//                                         + "LastProcessedBy, ProcessedBy, " + TO_STRING(targetActName, true, dbType) + " , " + targetActivity + " , " + WFSUtil.getDate(dbType) + " ,ParentWorkItemId, " + TO_STRING( (adhoc ? "D" : "R"), true, dbType) //+ "LastProcessedBy,ProcessedBy,?,?," + WFSUtil.getDate(dbType) + ",ParentWorkItemId," + WFSConstant.WF_VARCHARPREFIX
//                                         + " ,CollectFlag, PriorityLevel, "
//                                         + (expiry == null ? "" : WFSUtil.TO_DATE(new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.US).format(expiry), true, dbType)) //Bug #1608
//                                         + "CreatedDateTime, 6, " + TO_STRING(WFSConstant.WF_COMPLETED, true, dbType) //+ (adhoc ? "D" : "R") + "'," + "CollectFlag,PriorityLevel,?," + "CreatedDateTime,6," + WFSConstant.WF_VARCHARPREFIX + WFSConstant.WF_COMPLETED
//                                         + " , " + TO_STRING(prevActivity, true, dbType) + ", ProcessVariantId from " + (adhoc ? adhoctable //+ "',? from " + (adhoc ? adhoctable
//                : "WorkwithPStable") + " where ProcessInstanceId = ? and WorkItemID = ? ");
//            WFSUtil.DB_SetString(1, pInstId, pstmt, dbType);
//            pstmt.setInt(2, wrkItemID);
            res = WFSUtil.jdbcExecuteUpdate(pInstId, sessionId, userId, queryStr, pstmt, parameters, debug, engine);
            //res = pstmt.executeUpdate();
            parameters.clear();
            pstmt.close();
            if (res <= 0) {
//                pstmt = con.prepareStatement("Delete from " + (adhoc ? adhoctable : "WorkwithPStable")
//                                             + " where ProcessInstanceID = ? and WorkItemID = ? ");
//                WFSUtil.DB_SetString(1, pInstId, pstmt, dbType);
//                pstmt.setInt(2, wrkItemID);
//                int f = pstmt.executeUpdate();
//                pstmt.close();
//                if (f != res) {
//                    error = WFSError.WM_INVALID_WORKITEM;
//                    errorMsg = WFSErrorMsg.getMessage(error);
//                }
//            } else {
                error = WFSError.WM_INVALID_WORKITEM;
                errorMsg = WFSErrorMsg.getMessage(error);
            }
        } catch (Exception e) {
            WFSUtil.printErr(engine,"", e);
            error = WFSError.WFS_SYS;
            errorMsg = e.toString();
        } finally { //Bug WFS_6_004 - Statement closed in finally.
            try {
                if (pstmt != null) {
                    pstmt.close();
                    pstmt = null;
                }
            } catch (Exception ignored) {}
        }
        if (error != 0) {
            throw new JTSException(error, errorMsg);
        }
        return res;
    }

    //----------------------------------------------------------------------------------------------------
    //	Function Name 						: upDateWI
    //	Date Written (DD/MM/YYYY)	: 31/05/2003
    //	Author										: Prashant
    //	Input Parameters					: Connection con , int targetActivity,Date expiry,String pInstId
    //	Output Parameters					: none
    //	Return Values							: int
    //	Description								: Performs the updation of Expiry Settings for distributed Workitems
    //----------------------------------------------------------------------------------------------------
    private int upDateWI(Connection con, int targetActivity, java.util.Date expiry,
                                String pInstId, int dbType, XMLParser parser) throws SQLException {
        PreparedStatement pstmt = null;
        int res = 0;
        try {
            //OF Optimization
            pstmt = con.prepareStatement("Update WFInstrumentTable set ValidTill = ? where ProcessInstanceId = ? and ActivityID = ?");
            //pstmt = con.prepareStatement("Update PendingWorklistTable set ValidTill = ? where ProcessInstanceId = ? and ActivityID = ?");
            pstmt.setTimestamp(1, new java.sql.Timestamp(expiry.getTime()));
            WFSUtil.DB_SetString(2, pInstId, pstmt, dbType);
            pstmt.setInt(3, targetActivity);
            res = pstmt.executeUpdate();
            pstmt.close();
        } catch (Exception e) {
           // WFSUtil.printErr(parser,"", e);
        } finally { //Bug WFS_6_004 - Statement closed in finally.
            try {
                if (pstmt != null) {
                    pstmt.close();
                    pstmt = null;
                }
            } catch (Exception ignored) {}
        }
        return res;
    }

    //----------------------------------------------------------------------------------------------------
    //	Function Name 						: collect
    //	Date Written (DD/MM/YYYY)	: 31/05/2003
    //	Author										: Prashant
    //	Input Parameters					: Connection con , int targetActivity,String pInstId,int parentWI,String targetActName, boolean adhoc
    //	Output Parameters					: none
    //	Return Values							: int
    //	Description								: Performs the collection of distributed Workitems
    //----------------------------------------------------------------------------------------------------
    //----------------------------------------------------------------------------
    // Changed By											: Prashant
    // Reason / Cause (Bug No if Any)	: Bug No TSR_3.0.2.0017
    // Change Description							:	While merging distributed WorkItems on Collect WorkSteps those WorkItems
    //																	which have reached this collect WorkStep will be deleted along with their
    //																	respective parents if all of their children have already been merged i.e
    //																	no children other than the Workitems lying in this Collect WorkStep remain.
    //																	All parent Workitems of deleted Workitems, which do not have any child
    //																	Workitems active shall be deleted as well Except the original Workitem ie
    //																	WokitemId = 1.
    //----------------------------------------------------------------------------
	/* Bugzilla Bug 7538 (31/12/2008) Now according to new architecture of Distribute / collect,
		[2 new columns are being added in pendingworklisttable....		NoOfCollectedInstances, IsPrimaryCollected ]
		WI will not be inserted in pendingworklisttable while they come to collect 
		(if not to be collected as no. of instance are not fulfilled or may be waiting for primary activity workitem)
		Instead these will be deleted and NoOfCollectedInstances column will be updated of parent WI which is in pendingworklisttable
		if the wi was from primary acyivity then IsPrimaryCollected will be updated
		Also if collection criteria is satisfied, then CollectFlag will now not be updated any more.
		While these WI will come and found that their parent is not there, will be deleted....
	*/
    private int collect(Connection con, int previousActivityId, int targetActivity,String pInstId, int parentWI, String targetActName,
                                boolean adhoc, String engine, int procDefId, int wrkItemId, boolean deleteOnCollectFlag, XMLParser parser, boolean debug, int sessionId, int userId) throws SQLException, JTSException {
        Statement stmt = null;
        PreparedStatement pstmt = null;
        StringBuffer strBuff = new StringBuffer(100);
	    int[] deleteOnCollectNumber = {0};
        int error = 0;
        String queryStr = null;
        ArrayList parameters = new ArrayList();
        String errorMsg = "";
        try {
            int dbType = ServerProperty.getReference().getDBType(engine);
            stmt = con.createStatement();
            /** Bug # WFS_6.1.2_065, Remove the workitem from WorkListTableas well - Ruhi Hira */
//            stmt.addBatch("Update WorklistTable  set CollectFlag = " + WFSConstant.WF_VARCHARPREFIX + "Y' " + " where ProcessInstanceId = " + WFSConstant.WF_VARCHARPREFIX
//                          + pInstId + "' and ParentWorkItemID = " + parentWI);
			/** Bugzilla Bug 5051, Scenario is Create a dist-coll process, distribute the workitem on two worksteps
             * and set collection criteria as collect on 1. Complete first workitem, parent workitem get collected,
             * now when user complete second distributed workitem, it gives error - Invalid workitem.
             * When first instance is completed parent is collected and
             * all siblings should have collectFlag as Y, but update WorkListTable got commented when we started
             * deleting siblings from WorkListTable in collect. Then this delete was made configurable from
             * process modeller. Hence added Update WorkListTable Set CollectFlag conditionally. - Ruhi Hira */
            /* res[0] */
/*
            if(!deleteOnCollectFlag){
                stmt.addBatch("Update WorklistTable set CollectFlag = " + TO_STRING("Y", true, dbType) + " where ProcessInstanceId = " + TO_STRING(pInstId, true, dbType) + " and ParentWorkItemID = " + parentWI);
            }
            /* res[1] * /
            stmt.addBatch("Update WorkinProcessTable  set CollectFlag = " + TO_STRING("Y", true, dbType) + " where ProcessInstanceId = " + TO_STRING(pInstId, true, dbType) + " and ParentWorkItemID = " + parentWI);
            /* res[2] * /
            stmt.addBatch("Update WorkDoneTable  set CollectFlag = " + TO_STRING("Y", true, dbType) + " where ProcessInstanceId = " + TO_STRING(pInstId, true, dbType) + " and ParentWorkItemID = " + parentWI);
            /* res[3] * /
            stmt.addBatch("Update WorkwithPSTable  set CollectFlag = " + TO_STRING("Y", true, dbType) + " where ProcessInstanceId = " + TO_STRING(pInstId, true, dbType) + " and ParentWorkItemID = " + parentWI);
            /* res[4] * /
            stmt.addBatch("Update PendingWorklistTable  set CollectFlag = " + TO_STRING("Y", true, dbType) + " where ProcessInstanceId = " + TO_STRING(pInstId, true, dbType) + " and ActivityID <> " + targetActivity
                          + " and ParentWorkItemID = " + parentWI);
            /* res[5] * /
            strBuff.append("Delete from QueueDataTable where ParentWorkItemID = ");
            strBuff.append(parentWI);
            strBuff.append(" and ProcessInstanceId = " + TO_STRING(pInstId, true, dbType));
            strBuff.append(" and WorkItemID in ((Select WorkItemID ");
            strBuff.append("from PendingWorklistTable where ParentWorkItemID = ");
            strBuff.append(parentWI);
            strBuff.append(" and ProcessInstanceId = " + TO_STRING(pInstId, true, dbType));
            strBuff.append(" and ActivityID = ");
            strBuff.append(targetActivity);
            strBuff.append(")");
            /**
             * Changed On  : 14/05/2007
             * Changed By  : Ruhi Hira
             * Description : Bugzilla Bug 690, delete on collect configuration
             * /
            if (deleteOnCollectFlag) {
                strBuff.append(" union all (Select WorkItemID ");
                strBuff.append(" from WorklistTable where ParentWorkItemID = ");
                strBuff.append(parentWI);
                strBuff.append(" and ProcessInstanceId = " + TO_STRING(pInstId, true, dbType));
                strBuff.append(")");
            }
            strBuff.append(")");

            stmt.addBatch(strBuff.toString());
			/* res[6] * /
            stmt.addBatch("Delete from PendingWorklistTable where ParentWorkItemID = " + parentWI
                          + " and ProcessInstanceId = " + TO_STRING(pInstId, true, dbType) + " and ActivityID = " + targetActivity);

            if (deleteOnCollectFlag) {
                /* res[7] * /
                stmt.addBatch("Delete from WorkListTable where ProcessInstanceId = " + TO_STRING(pInstId, true, dbType)
                              + " and ParentWorkItemID = " + parentWI); //Bugzilla Bug 140
            }
*/
            //Ashish added
            /* res[0] */
			ArrayList arryItems = new ArrayList();
            ArrayList queryArr = new ArrayList();
			int cnt = 0;
            
			if (deleteOnCollectFlag) {	
                queryStr = "Select WorkitemId from WFInstrumentTable where ProcessInstanceId = ? and ParentworkitemId = ? and RoutingStatus = ? and LockStatus = ?";
                pstmt = con.prepareStatement(queryStr);
                WFSUtil.DB_SetString(1, pInstId, pstmt, dbType);
                pstmt.setInt(2, parentWI);
                WFSUtil.DB_SetString(3, "R", pstmt, dbType);
                WFSUtil.DB_SetString(4, "N", pstmt, dbType);
                parameters.add(pInstId);
                parameters.add(parentWI);
                parameters.add("R");
                parameters.add("N");
                ResultSet rs = WFSUtil.jdbcExecuteQuery(pInstId, sessionId, userId, queryStr, pstmt, parameters, debug, engine);
                parameters.clear();
				//ResultSet rs = stmt.executeQuery(queryStr);
				while(rs.next())
				{
					arryItems.add(rs.getString(1));
					cnt++;
				}
				rs.close();
			}
			//Process Variant Support Changes
            //OF Optimization
        	//Changes for Case Management -Adding ActivityType in WFInstrumentTable
			int targetActivityType  = WFSUtil.getActivityType(con, procDefId, targetActivity, null, 0, dbType);
             queryStr = "Update WFInstrumentTable set ActivityName=" + TO_STRING(targetActName, true, dbType) + ", ActivityId=" + targetActivity + ","
                    + "AssignmentType=" + TO_STRING("Y", true, dbType) + ",WorkItemState=6,Statename=" + TO_STRING(WFSConstant.WF_COMPLETED, true, dbType)+""
                    + ",LockStatus =" + TO_STRING("N", true, dbType) + ",RoutingStatus =" + TO_STRING("Y", true, dbType) + ",LockedByName = null, LockedTime = null, Q_UserId = 0 ,noofcollectedinstances = 0,"
                    + " IsPrimaryCollected=null ,collectflag = null , ActivityType= "+targetActivityType +                    
                     " where ProcessInstanceID = " + TO_STRING(pInstId, true, dbType) + " and WorkItemID = "+ parentWI+" and RoutingStatus = " + TO_STRING("R", true, dbType) ;
            queryArr.add(queryStr);
            stmt.addBatch(queryStr);
//            stmt.addBatch("Insert into WorkDoneTable "
//                          + "(ProcessInstanceId,WorkItemId,ProcessName,ProcessVersion,ProcessDefID,LastProcessedBy,"
//                          + "ProcessedBy,ActivityName,ActivityId,EntryDateTime,ParentWorkItemId,"
//                          + "AssignmentType,CollectFlag,PriorityLevel,"
//                          + "CreatedDateTime,WorkItemState,"
//                          + "Statename,PreviousStage, ProcessVariantId) Select "
//                          + "ProcessInstanceId,WorkItemId,ProcessName,ProcessVersion,ProcessDefID,"
//                          + "LastProcessedBy,ProcessedBy, " + TO_STRING(targetActName, true, dbType) + " , " + targetActivity + " ,EntryDateTime,"
//                          + "ParentWorkItemId, " + TO_STRING("Y", true, dbType) + ", CollectFlag,PriorityLevel,CreatedDateTime,6, " + TO_STRING(WFSConstant.WF_COMPLETED, true, dbType) + " ,PreviousStage, ProcessVariantId from "
//                          + "PendingWorkListtable where ProcessInstanceId = " + TO_STRING(pInstId, true, dbType) + " and WorkItemID = "
//                          + parentWI);
            /* res[1] */
            //stmt.addBatch("Delete from PendingWorklistTable where ProcessInstanceId = " + TO_STRING(pInstId, true, dbType) + "  and WorkItemID = " + parentWI);

            if (deleteOnCollectFlag) {
				int err = collectAll(con, dbType, pInstId, arryItems, debug, sessionId, userId, engine,deleteOnCollectNumber);	/*WFS_8.0_034*/
				
				if(dbType==JTSConstant.JTS_MSSQL){
				strBuff.append("Delete a from WFTaskStatusTable a inner join WFInstrumentTable b on a.processInstanceId=b.ProcessInstanceId and a.workitemid=b.workitemid and a.processdefid=b.processdefid where b.processInstanceId= ");
				strBuff.append(TO_STRING(pInstId, true, dbType));
				strBuff.append(" AND b.ActivityType = 32");
				strBuff.append(" AND b.ParentWorkItemID = ");
				strBuff.append(parentWI).append(" and b.RoutingStatus = ");
				strBuff.append(TO_STRING("N", true, dbType)).append(" and b.LockStatus = ");
				strBuff.append(TO_STRING("N", true, dbType));
				}
				else if(dbType==JTSConstant.JTS_ORACLE){
					strBuff.append("Delete  from WFTaskStatusTable where (processInstanceId, workitemid, processdefid ) in (select ProcessInstanceId, workitemid, processdefid from  WFInstrumentTable b  where b.processInstanceId= ");
					strBuff.append(TO_STRING(pInstId, true, dbType));
					strBuff.append(" AND b.ActivityType = 32");
					strBuff.append(" AND b.ParentWorkItemID = ");
					strBuff.append(parentWI).append(" and b.RoutingStatus = ");
					strBuff.append(TO_STRING("N", true, dbType)).append(" and b.LockStatus = ");
					strBuff.append(TO_STRING("N", true, dbType));
					strBuff.append(" ) ");
					}
				else if(dbType==JTSConstant.JTS_POSTGRES){
					strBuff.append("Delete  from WFTaskStatusTable a using WFInstrumentTable b where a.processInstanceId=b.ProcessInstanceId and a.workitemid=b.workitemid and a.processdefid=b.processdefid and b.processInstanceId= ");
					strBuff.append(TO_STRING(pInstId, true, dbType));
					strBuff.append(" AND b.ActivityType = 32");
					strBuff.append(" AND b.ParentWorkItemID = ");
					strBuff.append(parentWI).append(" and b.RoutingStatus = ");
					strBuff.append(TO_STRING("N", true, dbType)).append(" and b.LockStatus = ");
					strBuff.append(TO_STRING("N", true, dbType));
					}
            
				queryArr.add(strBuff.toString());
				stmt.addBatch(strBuff.toString());
				strBuff=new StringBuffer();
				
                strBuff.append("Delete from WFInstrumentTable where ProcessInstanceId = ");
                strBuff.append(TO_STRING(pInstId, true, dbType));
                strBuff.append(" AND ParentWorkItemID = ");
                strBuff.append(parentWI).append(" and RoutingStatus = ");
                strBuff.append(TO_STRING("N", true, dbType)).append(" and LockStatus = ");
                strBuff.append(TO_STRING("N", true, dbType));
//				strBuff.append("Delete from QueueDataTable where ProcessInstanceId = " + TO_STRING(pInstId, true, dbType));
//				strBuff.append(" and WorkItemID in (Select WorkItemID ");
//				strBuff.append(" from WorklistTable where ParentWorkItemID = ");
//				strBuff.append(parentWI);
//				strBuff.append(" and ProcessInstanceId = " + TO_STRING(pInstId, true, dbType));
//				strBuff.append(")");
  
				/* res[2] */
                queryArr.add(strBuff.toString());
				stmt.addBatch(strBuff.toString());
				
				

				/* res[3] */
//				stmt.addBatch("Delete from WorkListTable where ProcessInstanceId = " + TO_STRING(pInstId, true, dbType)
//                              + " and ParentWorkItemID = " + parentWI); 
				//Bugzilla Bug 140
				String updateQuery = "Update WFINSTRUMENTTABLE SET CollectFlag = 'Y' where ProcessInstanceId = " + TO_STRING(pInstId, true, dbType)
                              + " and ParentWorkItemID >= " + parentWI + " and LockStatus = " + TO_STRING("Y", true, dbType) + " and RoutingStatus = " + TO_STRING("N", true, dbType);	
				queryArr.add(updateQuery);
				stmt.addBatch(updateQuery);					
				
				if(err !=0)
					error = err;
					errorMsg = WFSErrorMsg.getMessage(error);
            }else {
                stmt.addBatch("UPDATE WFInstrumentTable SET CollectFlag = 'X' WHERE ProcessInstanceId = " + TO_STRING(pInstId, true, dbType) + " AND ParentWorkItemID = " + parentWI);

			}
            int res[] = WFSUtil.jdbcExecuteBatch(pInstId, sessionId, userId, queryArr, stmt, null, debug, engine);
            //int res[] = stmt.executeBatch();
            stmt.close();
            if (deleteOnCollectFlag) {
                WFSUtil.generateLog(engine, con,WFSConstant.WFL_ChildProcessInstanceDeleted, pInstId, parentWI,
                procDefId, previousActivityId, "", 0,0, "", 0, "", null, null, null, null);
            }
//			 if(deleteOnCollectFlag && res[1] > 0){
//                WFSUtil.generateLog(engine, con, WFSConstant.WFL_ChildWorkitemDeleted, pInstId, wrkItemId, procDefId,
//                                    0, "", 0, 0, "", targetActivity, "", null, null, null, null);
//            }

            /** 14/09/2007, WFS_5_192, Code inherited from OF5.0
             * Count of deleted workitems from QueueDataTable and WorkListTable
			 * must be same and greater than zero, also count of workitems moved from
             * PendingWorkListTable to WorkDoneTable must be same and greater than zero */
            //if (res[0] <= 0 || (deleteOnCollectFlag && res[1] <= 0 ) ) { //Bugzilla Bug 2121
			if (res[0] <= 0 ) {
                error = WFSError.WM_INVALID_WORKITEM;
                errorMsg = WFSErrorMsg.getMessage(error);
            } else if(deleteOnCollectFlag){
                deleteOnCollectNumber[0] = deleteOnCollectNumber[0] + res[2] + res[3];
			}
			
        } catch (Exception e) {
            WFSUtil.printErr(engine,"", e);
            error = WFSError.WFS_SYS;
            errorMsg = e.toString();
        } finally { //Bug WFS_6_004 - Statement closed in finally.
            try {
                if (stmt != null) {
                    stmt.close();
                    stmt = null;
                }
            } catch (Exception ignored) {}
        }
        if (error != 0) {
            throw new JTSException(error, errorMsg);
        }
		return deleteOnCollectNumber[0];
    }

    

    //----------------------------------------------------------------------------------------------------
    //	Function Name 						: suspendWorkItem
    //	Date Written (DD/MM/YYYY)			: 03/03/2005
    //	Author								: Ashish Mangla
    //	Input Parameters					: Connection con , int userId, int dbType
    //	Output Parameters					: none
    //	Return Values						: int
    //	Description							: Suspends the workitem, moves the workitem from one table to pendingworklisttable
    //----------------------------------------------------------------------------------------------------
    private void suspendWorkItem(String engine, Connection con, WFParticipant participant, XMLParser parser, String pinstId, int wrkItmId, boolean debug, int sessionId, int userId) throws JTSException {
        //should be called only by PS
        int error = 0;
        String errorMsg = "";
        //Statement stmt = null;
        ResultSet rs = null;
        PreparedStatement pstmt = null;

        String suspensionCause = parser.getValueOf("SuspensionCause");
        int prevActivityId = parser.getIntOf("PrevActivityId", 0, true);
        int procDefID = parser.getIntOf("ProcessDefId", 0, true);
        String prevActName = parser.getValueOf("PrevActivityName");
        String dateTimeFormat = WFSUtil.getDateTimeFormat();
        String mailMessage ="";
        String query = null;
        ArrayList parameters = new ArrayList();
        String urn = "";
        try {
        
            int dbType = ServerProperty.getReference().getDBType(engine);
        	
            StringBuilder urnQuery = new StringBuilder();
        	urnQuery.append( "Select URN from WFInstrumentTable "); 
        	urnQuery.append(WFSUtil.getTableLockHintStr(dbType) );
        	urnQuery.append(" where processinstanceid=? and workitemid = ?");
        	pstmt = con.prepareStatement(urnQuery.toString());
        	WFSUtil.DB_SetString(1, pinstId.trim(), pstmt, dbType);
            pstmt.setInt(2,wrkItmId);
            parameters.add(pinstId.trim());
            parameters.add(wrkItmId);
            rs = WFSUtil.jdbcExecuteQuery(pinstId, sessionId, userId, urnQuery.toString(), pstmt, parameters, debug, engine);
            parameters.clear();
            if(rs.next()){
                urn = rs.getString("URN");   
                if(urn==null||urn.equalsIgnoreCase("")){
                	urn =pinstId;
                }
            }
            pstmt.close();
            rs.close();
            pstmt= null;
            rs=null;
        
            //stmt = con.createStatement();
            query = "Update WFInstrumentTable set WorkItemState = ?,Statename =?, AssignmentType = ?, RoutingStatus = ?, LockStatus = ?,"
                    + "Q_UserId = 0, LockedTime = null, LockedByName = null where ProcessInstanceID = ? and WorkItemID = ?";
            pstmt = con.prepareStatement(query);
			pstmt.setInt(1,3);
            WFSUtil.DB_SetString(2, WFSConstant.WF_SUSPENDED, pstmt, dbType);
            WFSUtil.DB_SetString(3, "R", pstmt, dbType);
            WFSUtil.DB_SetString(4, "R", pstmt, dbType);
            WFSUtil.DB_SetString(5, "N", pstmt, dbType);
            WFSUtil.DB_SetString(6, pinstId.trim(), pstmt, dbType);
            pstmt.setInt(7,wrkItmId);
            
            parameters.add("3");
            parameters.add(WFSConstant.WF_SUSPENDED);
            parameters.add("R");
            parameters.add("R");
            parameters.add("N");
            parameters.add(pinstId.trim());
            parameters.add(wrkItmId);
            
            WFSUtil.jdbcExecute(pinstId, sessionId, userId, query, pstmt, parameters, debug, engine);
            parameters.clear();
            //pstmt.execute();
            //Process Variant Support Changes
            
//            stmt.execute("Insert into PendingWorklisttable ("
//                         + " ProcessInstanceId, WorkItemId, ProcessName, ProcessVersion, ProcessDefID, LastProcessedBy,"
//                         + " ProcessedBy, ActivityName, ActivityId, EntryDateTime, ParentWorkItemId,"
//                         + " AssignmentType, CollectFlag, PriorityLevel, ValidTill, Q_StreamId, Q_QueueId,"
//                         + " AssignedUser, FilterValue, CreatedDateTime, WorkItemState,"
//                         + " Statename, LockStatus, "
//                         + " ExpectedWorkitemDelay, PreviousStage, Queuename, Queuetype, NotifyStatus, ProcessVariantId) "
//                         + "Select "
//                         + " ProcessInstanceId, WorkItemId, ProcessName, ProcessVersion, ProcessDefID, LastProcessedBy,"
//                         + " ProcessedBy, ActivityName, ActivityId, EntryDateTime,ParentWorkItemId, "
//                         + TO_STRING("R", true, dbType) + " , CollectFlag , PriorityLevel, ValidTill, Q_StreamId, Q_QueueId,"
//                         + " AssignedUser, FilterValue,CreatedDateTime, 3, "
//                         + TO_STRING(WFSConstant.WF_SUSPENDED, true, dbType) + " , " + TO_STRING("N", true, dbType) +  " , "
//                         + " ExpectedWorkitemDelay, PreviousStage, Queuename, Queuetype, NotifyStatus, ProcessVariantId from WorkwithPStable"
//                         + " where ProcessInstanceID = " + TO_STRING(pinstId.trim(), true, dbType) + " and WorkItemID = " + wrkItmId);
//
//            int f = stmt.executeUpdate("Delete from WorkwithPStable where ProcessInstanceID = " + TO_STRING(pinstId.trim(), true, dbType) + " and WorkItemID = " + wrkItmId);

            // Audit Log to be generated...
			WFSUtil.generateLog(engine, con, WFSConstant.WFL_WorkItemSuspended, pinstId, wrkItmId, procDefID, prevActivityId, prevActName, 0, participant.getid(), (participant.gettype() == 'P' ? "System" : participant.getname()), 0,
                           suspensionCause, null, null, null, null);
			// Entry to be inserted into WFMailQueueTable for each suspended workitem
			String ownerEmailId = CachedObjectCollection.getReference().getOwnerEmailId(con, engine, procDefID);  
			WFSUtil.printOut(engine, " OraCreateWorkitem : suspendWorkItem() : OwnerEmailID : " + ownerEmailId);
			boolean isToSendEmail = EmailTemplateUtil.isToSendEmail("WorkItemSuspension", engine,  0);
			if (ownerEmailId != null && !ownerEmailId.equalsIgnoreCase("") && isToSendEmail) {
				//mailMessage = WFMailTemplateUtil.getSharedInstance().getTemplate(procDefID);
				mailMessage = EmailTemplateUtil.retrieveEmailTemplate("WorkItemSuspension"+"_"+Locale.getDefault().toString(), engine, procDefID);
				if(mailMessage.equals("")|| mailMessage == null)
				{
				   mailMessage =  "&<WorkItemName>& - Suspended \n\n" ;
				   mailMessage =  mailMessage + "PFB the logs : \n\n";
				   mailMessage =  mailMessage +" &<Logs>& ";
				}
			    Properties emailProperties = EmailTemplateUtil.retrieveEmailProperties("WorkItemSuspension"+"_"+Locale.getDefault().toString(), engine, procDefID);
			    String mailSubject = (String) emailProperties.get("EmailSubject");
				String mailFrom = (String) emailProperties.get("EmailFrom");
				mailFrom = TO_SANITIZE_STRING(mailFrom, true);
				if (mailFrom == "") {
					mailFrom = "OmniFlowSystem_do_not_reply@newgen.co.in";
				}
				
				String mailCC="";
				String strInputXml = WFSUtil.getAddToMailQueueXML(engine, mailFrom, ownerEmailId, mailCC,
				WFSUtil.searchAndReplaceTags(mailSubject.replaceAll("&<URN>&", urn), "", dateTimeFormat, parser), WFSUtil.searchAndReplaceTags(mailMessage.replaceAll("&<URN>&", urn), "", dateTimeFormat,parser), "text/html;charset=UTF-8",
				String.valueOf( procDefID), pinstId , String.valueOf(wrkItmId), String.valueOf(prevActivityId));
				XMLParser mailParser = new XMLParser();
				mailParser.setInputXML(strInputXml);
				XMLGenerator gen = new XMLGenerator();
				WFSUtil.addToMailQueue(participant.getname(), con, mailParser, gen);
            }
            //ends here
			
        } catch (SQLException e) {
            WFSUtil.printErr(engine,"", e);
            error = WFSError.WFS_SQL;
            errorMsg = e.toString();
        } catch (Exception e) {
            WFSUtil.printErr(engine,"", e);
            error = WFSError.WFS_SQL;
            errorMsg = e.toString();
        } finally {
            if (pstmt != null) {
                try {
                    pstmt.close();
                } catch (Exception e) {}
            }
            
        }
        if (error != 0) {
            throw new JTSException(error, errorMsg);
        }
    }

    /**
     * *************************************************************************
     * Function Name            : removeWorkitemFromSystem
     * Date Written (DD/MM/YYYY): 11/04/2006
     * Programmer               : Ruhi Hira
     * Input Parameters         : Connection con, String pInstId, int wrkItemId
     * Output Parameters        : NONE
     * Return Values            : NONE
     * Description              : Method to remove workitem that should not be
     *                              in omniflow system as CollectFlag is Y.
     *                              Bug # WFS_6.1.2_065.
     * *************************************************************************
     */
    private void removeWorkitemFromSystem(Connection con, String pInstId, int wrkItemId, int dbType, boolean debug, int sessionId, int userId, String engine) throws SQLException {
        PreparedStatement pstmt = null;
        String query = null;
        
        ArrayList parameters = new ArrayList();
        try {
            //stmt = con.createStatement();
//            stmt.addBatch("Delete from QueueDataTable where ProcessInstanceId = "
//                          + TO_STRING(pInstId, true, dbType) + " and WorkItemID = " + wrkItemId);
//            stmt.addBatch("Delete from WorkWithPSTable where ProcessInstanceId = "
//                          + TO_STRING(pInstId, true, dbType) + " and WorkItemID = " + wrkItemId);
//            stmt.addBatch("Delete from WorkListTable where ProcessInstanceId = "
//                          + TO_STRING(pInstId, true, dbType) + " and WorkItemID = " + wrkItemId);
//            stmt.addBatch("Delete from PendingWorkListTable where ProcessInstanceId = "
//                          + TO_STRING(pInstId, true, dbType) + " and WorkItemID = " + wrkItemId);    
            String workitemIDFilter = "";
            String workitemIDFilter1="";
            if(wrkItemId == 1){
                    workitemIDFilter = " WorkItemID > 1";
                    workitemIDFilter1=" b.WorkItemID > 1";
            }
            else{
                    workitemIDFilter = " ( WorkItemID = " + wrkItemId + " OR ParentWorkItemID = " + wrkItemId + ") " ; // delete all child of this parent
                    workitemIDFilter1 = " ( b.WorkItemID = " + wrkItemId + " OR b.ParentWorkItemID = " + wrkItemId + ") " ;
            }
            
//            if(dbType==JTSConstant.JTS_MSSQL){
//            query = "Delete a from WFTaskStatusTable a inner join WFInstrumentTable b on a.processInstanceId=b.ProcessInstanceId and a.workitemid=b.workitemid and a.processdefid=b.processdefid where b.ProcessInstanceId = ? and "+workitemIDFilter1+" AND ((b.RoutingStatus = "+TO_STRING("Y", true, dbType) +" and b.LockStatus = "+TO_STRING("Y", true, dbType) +") OR (b.RoutingStatus = "+TO_STRING("N", true, dbType) +" and b.LockStatus = "+TO_STRING("N", true, dbType) +") OR (b.RoutingStatus = "+TO_STRING("R", true, dbType) +" and b.LockStatus = "+TO_STRING("N", true, dbType) +") )";
//            }
//            else if(dbType==JTSConstant.JTS_ORACLE){
//                query = "Delete  from WFTaskStatusTable where (processInstanceId, workitemid, processdefid ) in (select ProcessInstanceId, workitemid, processdefid from WFInstrumentTable b where b.ProcessInstanceId = ? and "+workitemIDFilter1+" AND ((b.RoutingStatus = "+TO_STRING("Y", true, dbType) +" and b.LockStatus = "+TO_STRING("Y", true, dbType) +") OR (b.RoutingStatus = "+TO_STRING("N", true, dbType) +" and b.LockStatus = "+TO_STRING("N", true, dbType) +") OR (b.RoutingStatus = "+TO_STRING("R", true, dbType) +" and b.LockStatus = "+TO_STRING("N", true, dbType) +") ) )";
//                }
//            else if(dbType==JTSConstant.JTS_POSTGRES){
//                query = "Delete  from WFTaskStatusTable a using WFInstrumentTable b where a.processInstanceId=b.ProcessInstanceId and a.workitemid=b.workitemid and a.processdefid=b.processdefid and b.ProcessInstanceId = ? and "+workitemIDFilter1+" AND ((b.RoutingStatus = "+TO_STRING("Y", true, dbType) +" and b.LockStatus = "+TO_STRING("Y", true, dbType) +") OR (b.RoutingStatus = "+TO_STRING("N", true, dbType) +" and b.LockStatus = "+TO_STRING("N", true, dbType) +") OR (b.RoutingStatus = "+TO_STRING("R", true, dbType) +" and b.LockStatus = "+TO_STRING("N", true, dbType) +") )";
//                }
//            
//            pstmt = con.prepareStatement(query);
//            WFSUtil.DB_SetString(1, pInstId, pstmt, dbType);
//            parameters.add(pInstId);
//            WFSUtil.jdbcExecute(pInstId, sessionId, userId, query, pstmt, parameters, debug, engine);
//            parameters.clear();
            
            query = "Delete from WFInstrumentTable where ProcessInstanceId = ? and "+workitemIDFilter+" AND ((RoutingStatus = "+TO_STRING("Y", true, dbType) +" and LockStatus = "+TO_STRING("Y", true, dbType) +") OR (RoutingStatus = "+TO_STRING("N", true, dbType) +" and LockStatus = "+TO_STRING("N", true, dbType) +") OR (RoutingStatus = "+TO_STRING("R", true, dbType) +" and LockStatus = "+TO_STRING("N", true, dbType) +") )";
            pstmt = con.prepareStatement(query);
            
            //stmt.executeBatch();
            WFSUtil.DB_SetString(1, pInstId, pstmt, dbType);
            //pstmt.setInt(2,wrkItemId);
            parameters.add(pInstId);
            //parameters.add(wrkItemId);
            WFSUtil.jdbcExecute(pInstId, sessionId, userId, query, pstmt, parameters, debug, engine);
            parameters.clear();
            
            
            
            //mark collect flag y for all locked child
            query = "Update WFInstrumentTable set CollectFlag = "  + TO_STRING("Y", true, dbType) + " where ProcessInstanceId = ? and " + workitemIDFilter  +" and LockStatus = "+ TO_STRING("Y", true, dbType) ;
            pstmt = con.prepareStatement(query);            
            WFSUtil.DB_SetString(1, pInstId, pstmt, dbType);
            parameters.add(pInstId);
            WFSUtil.jdbcExecute(pInstId, sessionId, userId, query, pstmt, parameters, debug, engine);
            parameters.clear();
            if (pstmt != null) {
                pstmt.close();
                pstmt = null;
            }

            //pstmt.execute();
//            if (pstmt != null) {
//                pstmt.close();
//                pstmt = null;
//            }
        } finally {
            try {
                if (pstmt != null) {
                    pstmt.close();
                    pstmt = null;
                }
            } catch (Exception ignored) {}
        }
    }

	 /**
     * *************************************************************************
     * Function Name            : collectAll
     * Date Written (DD/MM/YYYY): 11/04/2006
     * Programmer               : Preeti Awasthi
     * Input Parameters         : Connection con, String pInstId, ArrayList arrayWIs
     * Output Parameters        : NONE
     * Return Values            : NONE
     * Description              : Method to collect all workitems when deletOnCollect 
								  flag is true.
     *                              Bug # WFS_8.0_034.
     * *************************************************************************
     */
	
	
	private int collectAll(Connection con,  int dbType, String pInstId, ArrayList arrayWIs, boolean debug, int sessionId, int userId, String engine, int[] deleteOnCollectNumber) throws SQLException , Exception
	{		/*
		for (each element of pending ){ 
			find from worklist...
			delete all these found...
			delete also from queuedata				
			create array of pending 
			if (any){			
				collectAll(with this array)
			}
			delete myself from pending as well as( queuedata only for internal distribute )
			{
			}
		}*/
		StringBuffer strBuff = new StringBuffer();
		String wId = "";
		Statement stmt = null;
		ResultSet rs = null;
		ArrayList arrayWorkitems = new ArrayList(); 
		int count = 0;
		int error = 0;
		try
		{			
			stmt = con.createStatement();
			for(int i = 0 ; i < arrayWIs.size() ; i++) {
				
				 
                StringBuffer strBuff1 = new StringBuffer();
                if(dbType==JTSConstant.JTS_MSSQL){
                strBuff1.append("Delete a from WFTaskStatusTable a inner join WFInstrumentTable b on a.processInstanceId=b.ProcessInstanceId and a.workitemid=b.workitemid and a.processdefid=b.processdefid where b.processInstanceId= ");
                strBuff1.append(TO_STRING(pInstId, true, dbType));
                strBuff1.append(" AND b.ActivityType = 32");
                strBuff1.append(" AND b.ParentWorkItemID = ");
                strBuff1.append(TO_SANITIZE_STRING((String)arrayWIs.get(i), true)).append(" and b.RoutingStatus = ");
                strBuff1.append(TO_STRING("N", true, dbType)).append(" and b.LockStatus = ");
                strBuff1.append(TO_STRING("N", true, dbType));
                }
                else if(dbType==JTSConstant.JTS_ORACLE){
                    strBuff1.append("Delete  from WFTaskStatusTable where (processInstanceId, workitemid, processdefid ) in (select ProcessInstanceId, workitemid, processdefid WFInstrumentTable b  where b.processInstanceId= ");
                    strBuff1.append(TO_STRING(pInstId, true, dbType));
                    strBuff1.append(" AND b.ActivityType = 32");
                    strBuff1.append(" AND b.ParentWorkItemID = ");
                    strBuff1.append(TO_SANITIZE_STRING((String)arrayWIs.get(i), true)).append(" and b.RoutingStatus = ");
                    strBuff1.append(TO_STRING("N", true, dbType)).append(" and b.LockStatus = ");
                    strBuff1.append(TO_STRING("N", true, dbType));
                    strBuff1.append(" ) ");
                    }
                else if(dbType==JTSConstant.JTS_POSTGRES){
                    strBuff1.append("Delete  from WFTaskStatusTable a using WFInstrumentTable b where a.processInstanceId=b.ProcessInstanceId and a.workitemid=b.workitemid and a.processdefid=b.processdefid and b.processInstanceId= ");
                    strBuff1.append(TO_STRING(pInstId, true, dbType));
                    strBuff1.append(" AND b.ActivityType = 32");
                    strBuff1.append(" AND b.ParentWorkItemID = ");
                    strBuff1.append(TO_SANITIZE_STRING((String)arrayWIs.get(i), true)).append(" and b.RoutingStatus = ");
                    strBuff1.append(TO_STRING("N", true, dbType)).append(" and b.LockStatus = ");
                    strBuff1.append(TO_STRING("N", true, dbType));
                    }
                int res1 = WFSUtil.jdbcExecuteUpdate(pInstId, sessionId, userId, strBuff1.toString(), stmt, null, debug, engine);
				
				strBuff = new StringBuffer();
                strBuff.append("Delete from WFInstrumentTable where ProcessInstanceId = ");
                strBuff.append(TO_STRING(pInstId, true, dbType));
                strBuff.append(" AND ParentWorkItemID = ");
                strBuff.append(TO_SANITIZE_STRING((String)arrayWIs.get(i), true)).append(" and RoutingStatus = ");
                strBuff.append(TO_STRING("N", true, dbType)).append(" and LockStatus = ");
                strBuff.append(TO_STRING("N", true, dbType));
//				strBuff.append("Delete from QueueDataTable where ProcessInstanceId = " + TO_STRING(pInstId, true, dbType));
//				strBuff.append(" and WorkItemID in (Select WorkItemID ");
//				strBuff.append(" from WorklistTable where ParentWorkItemID = ");
//				strBuff.append((String)arrayWIs.get(i));
//				strBuff.append(" and ProcessInstanceId = " + TO_STRING(pInstId, true, dbType));
//				strBuff.append(")");
                int res = WFSUtil.jdbcExecuteUpdate(pInstId, sessionId, userId, strBuff.toString(), stmt, null, debug, engine);
                
              
				//stmt.addBatch(strBuff.toString());
//				String str = "Delete from WorkListTable where ProcessInstanceId = " + TO_STRING(pInstId, true, dbType)
//                              + " and ParentWorkItemID = " + (String)arrayWIs.get(i);
				//stmt.addBatch(str); 
				//int res[] = stmt.executeBatch();
//Same has been already commented in WFCreateWorktiemInternal as it was causing prblem for distributed worktiem at the time of collection
//                if(res <= 0) {
//				//if(res[0] != res[1]) {
//					error = WFSError.WM_INVALID_WORKITEM;
//					return error;
//				}else{
//                    deleteOnCollectNumber[0] = deleteOnCollectNumber[0] + res;
//                }

				stmt.clearBatch();
               rs = stmt.executeQuery("Select WorkitemId from WFInstrumentTable where ProcessInstanceId = "+TO_STRING(pInstId, true, dbType)+" and ParentworkitemId = "+TO_SANITIZE_STRING((String)arrayWIs.get(i), true)+" and RoutingStatus = "+TO_STRING("R", true, dbType)+"and LockStatus= "+TO_STRING("N", true, dbType)+"");
                //rs = WFSUtil.jdbcExecuteQuery(pInstId, sessionId, userId, strBuff.toString(), stmt, null, debug, engine);
				//rs = stmt.executeQuery("Select WorkitemId from PendingWorkListTable where ProcessInstanceId = "+TO_STRING(pInstId, true, dbType)+" and ParentworkitemId = "+(String)arrayWIs.get(i));
				stmt.clearBatch();
                while(rs.next()) {
					arrayWorkitems.add(rs.getString(1));
					count++;
				}
				if(rs != null)
				{
					rs.close();
					rs  = null;
				}
				if(arrayWorkitems.size() > 0) {
					collectAll(con, dbType,  pInstId, arrayWorkitems, debug, sessionId, userId, engine, deleteOnCollectNumber);
				}
				
				if(dbType==JTSConstant.JTS_MSSQL){
				 strBuff1.append("Delete a from WFTaskStatusTable a inner join WFInstrumentTable b on a.processInstanceId=b.ProcessInstanceId and a.workitemid=b.workitemid and a.processdefid=b.processdefid where b.ProcessInstanceId = "+TO_STRING(pInstId, true, dbType)+" and b.ActivityType= 32 and b.workitemId = "+TO_SANITIZE_STRING((String)arrayWIs.get(i), true)+" and b.RoutingStatus = "+TO_STRING("R", true, dbType)); 
				}
				else if(dbType==JTSConstant.JTS_ORACLE){
					 strBuff1.append("Delete  from WFTaskStatusTable where (processInstanceId, workitemid, processdefid ) in (select ProcessInstanceId, workitemid, processdefid from WFInstrumentTable b  where b.ProcessInstanceId = "+TO_STRING(pInstId, true, dbType)+" and b.ActivityType= 32 and b.workitemId = "+TO_SANITIZE_STRING((String)arrayWIs.get(i), true)+" and b.RoutingStatus = "+TO_STRING("R", true, dbType)+" ) "); 
					}
				else if(dbType==JTSConstant.JTS_POSTGRES){
					 strBuff1.append("Delete  from WFTaskStatusTable a using WFInstrumentTable b where a.processInstanceId=b.ProcessInstanceId and a.workitemid=b.workitemid and a.processdefid=b.processdefid and b.ProcessInstanceId = "+TO_STRING(pInstId, true, dbType)+" and b.ActivityType= 32 and b.workitemId = "+TO_SANITIZE_STRING((String)arrayWIs.get(i), true)+" and b.RoutingStatus = "+TO_STRING("R", true, dbType)); 
					}
				res1 = WFSUtil.jdbcExecuteUpdate(pInstId, sessionId, userId, strBuff1.toString(), stmt, null, debug, engine);
				
                strBuff.append("Delete from WFInstrumentTable where ProcessInstanceId = "+TO_STRING(pInstId, true, dbType)+" and workitemId = "+TO_SANITIZE_STRING((String)arrayWIs.get(i), true)+" and RoutingStatus = "+TO_STRING("R", true, dbType));
                res = WFSUtil.jdbcExecuteUpdate(pInstId, sessionId, userId, strBuff.toString(), stmt, null, debug, engine);
                
               
//				stmt.addBatch("Delete From PendingWorkListTable where ProcessInstanceId = "+TO_STRING(pInstId, true, dbType)+" and workitemId = "+(String)arrayWIs.get(i));
//				stmt.addBatch("Delete from QueueDataTable where ProcessInstanceId = "+TO_STRING(pInstId, true, dbType)+" and WorkitemId = "+(String)arrayWIs.get(i));
				//int res1[] = stmt.executeBatch();
//                if(res <= 0)
//				//if(res1[0] != res1[1])
//				{
//					error = WFSError.WM_INVALID_WORKITEM;
//					return error;
//				}		
				stmt.clearBatch();
			}
			if(stmt != null) {
				stmt.close();
				stmt = null;
			}
		}
		catch(SQLException sqe)
		{
			throw sqe;
		}
		catch(Exception ex)
		{
			throw ex;
		}
		finally
		{
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
			} catch (Exception ignored)	{
				WFSUtil.printErr(engine,"", ignored);
			}
		}
		return error;
	}
        public static void generateLogForInMemRouting(Connection con,XMLParser parser,String engine,String pid,int wid,int procDefId) throws SQLException, WFSException{
		
		//WFSUtil.printOut(engine,"DEBUGGG : Inside generateLogForInMemRouting");
		int startex = parser.getStartIndex("ActivityInfo", 0, 0);
		int deadendex = parser.getEndIndex("ActivityInfo", startex, 0);
		int ActivityCount = parser.getNoOfFields("ActivityInfo");
		//WFSUtil.printOut(engine,"DEBUGGG : ActivityCount>>"+ActivityCount);
		int endEx = 0;
		for(int i = 1;i <= ActivityCount; i++){
			String currentDate = null;
			startex = parser.getStartIndex("ActivityInfo", endEx, 0);
			endEx = parser.getEndIndex("ActivityInfo", startex, 0);
			int prevActId = Integer.parseInt(parser.getValueOf("PreviousActivityId",startex,endEx));
			String prevActivityName = parser.getValueOf("PreviousActivityName",startex,endEx);
			int targetActId = Integer.parseInt(parser.getValueOf("TargetActivityId",startex,endEx));
			String targetActivityName = parser.getValueOf("TargetActivityName",startex,endEx);
			int dbType = ServerProperty.getReference().getDBType(engine);
			//String currentDate = new java.text.SimpleDateFormat("yyyy-MM-dd H:mm:ss", Locale.US).format(new java.util.Date());
			currentDate = WFSUtil.dbDateTime(con, dbType);
            WFSUtil.printOut(engine,"PreviousActivityId"+"\t"+"TargetActivityId");
			WFSUtil.printOut(engine,prevActId+"\t"+targetActId);
			WFSUtil.generateLog(engine, con, WFSConstant.WFL_ProcessInstanceRouted, pid, wid,procDefId, prevActId, prevActivityName, 0, 0, "", targetActId, targetActivityName, currentDate, null, null, null);
			
		}
		
	
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
} // End Class OraCreateWorkItem